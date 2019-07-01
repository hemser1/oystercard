require 'oystercard'

describe Oystercard do

  let(:station) { double :station }
  it 'card has default balance of zero when initialized' do
    expect(subject.balance).to eq(0)
  end

  it 'tops up card balance' do
    subject.top_up(5)
    expect(subject.balance).to eq (5)
  end

  it 'raises an error if card topped up over maximum value' do
    subject.top_up(Oystercard::MAXIMUM_VALUE)
    expect { subject.top_up(1) }.to raise_error "Card balance cannot exceed £#{Oystercard::MAXIMUM_VALUE}"
  end

  it 'card is in journey if it is touched in' do
    subject.top_up(50)
    subject.touch_in(station)
    expect(subject.in_journey?).to eq true
  end

  it 'card is not in journey if touched out' do
    subject.top_up(50)
    subject.touch_in(station)
    subject.touch_out
    expect(subject.in_journey?).to eq false
  end

  it 'raises an error if balance is below £1' do
    expect { subject.touch_in(station) }.to raise_error "Balance below £1, please top up"
  end

  it 'deducts the minimum fare from balance when you touch out' do
    subject.top_up(50)
    subject.touch_in(station)
    expect { subject.touch_out }.to change {subject.balance}.by(-1)
  end



end
