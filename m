Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863E3C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048606B0095; Wed, 23 Jul 2025 05:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01FEF6B0096; Wed, 23 Jul 2025 05:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77FC6B0098; Wed, 23 Jul 2025 05:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5B056B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:03:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85F9414059F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:03:45 +0000 (UTC)
X-FDA: 83694941610.29.2AA24DE
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id E520212000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:03:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753261423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=24mwQJA5jKFv/eFbossQ/ot8RaJcQ32RfDDqIokIJBQ=;
	b=y6ei3D4FzXE878v1a5fxaQxvbNHTvDW0UB+8tb0IPCH2gyWc0QDpjgGvn7uyPAbini+lpQ
	jsVB57ikpU5kLoV3xwxDzSIP/KOjcPLhchAPAZG0SrEDY/FBquxohWvNpLoVOWciDEXpK3
	Szqvc2qbhRAlY6MzQHkaONunBSBej6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753261423; a=rsa-sha256;
	cv=none;
	b=k5HWKZbpNAIHYtJgZfhtGl0WIgnxguPHPxFyyJX29NQ68A9VfXrANKrBHjZM+Zw+us2vcu
	ZD8VGG1c4troR1QjaTaKG7BFUpTL/he3Z4EZ2Q9ljX0tMWM/g3sKK7QH9B/+U6UbgCf2C+
	gZXl0b9c9ZPZM3ihq3QrDiY8p/OP060=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bn7Tj00gLzKHMtd
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:03:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B56A71A12F6
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:03:35 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP1 (Coremail) with SMTP id cCh0CgBn2LNlpYBov6W_BA--.5952S3;
	Wed, 23 Jul 2025 17:03:35 +0800 (CST)
Subject: Re: [PATCH RFC] mm/readahead: improve randread performance with
 readahead disabled
To: Yu Kuai <yukuai1@huaweicloud.com>, willy@infradead.org,
 akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250701110834.3237307-1-yukuai1@huaweicloud.com>
 <19b73b35-1e16-cb7d-d32f-d054d3e66fa0@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <416d00a2-1530-3ee7-be31-2a58f5fc70e2@huaweicloud.com>
Date: Wed, 23 Jul 2025 17:03:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <19b73b35-1e16-cb7d-d32f-d054d3e66fa0@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBn2LNlpYBov6W_BA--.5952S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WFyfXw4kCFyUWFy3AF4Dtwb_yoW5JFy8pF
	s5JFWUtryUWrn3Ary7J34UJFyrGr48X3W5JryrJFyUAr43Gr4a9ryUXr1qgF1UJr4xJw1U
	Zr4DZr9xZr1Yvr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E520212000F
X-Stat-Signature: udwk7wic8zfb9pegpxpqbqxyxbokh79u
X-Rspam-User: 
X-HE-Tag: 1753261420-201610
X-HE-Meta: U2FsdGVkX19Xmn6tp6YNAhW78U5cvpwqecbLgITG6qYaO/uSST0tneQ4gQwLl2c/cz+36ckcCk6ebdYHxrybtHIEnPHYret81qAa0tTn5pKTGqUIB3pk1ySEi4QCVlG83QyH7zNmFFsii0c2l7yd/RyjbXe9rGxT6KEefLPlDgRPi3fF9E5nfvDGivpkZiAGrZdDfI+Dzsmgs29JTlKBIkER1bwImY2MMRP3jFNf5+EvICVVGd3jEYvBPxVP2R+WkpZ3BlmnS7FNF8OSOZGRPdZWf5jOy5KboK54tlrxkvJiiIE/xrcN4d8QI9SghWNaZ57FgqFq0/ndKwoLTe3wMzvGkONK38qFVu75/qTMwabIMBrVNh3L3MJ+BF2I4ozZ06maDc6GezNU5ZFORyavCQNLNWzd03LojPSD7XuOY+DbiLiPlkDb6l3b4yhxczj4K4BpjLapi07jeiqIh/cBjCsUhXfiyaPd4inflOa32UvobdqKmar0R6/LfZy0rF2vP9U8H5Uvz706W5C8FF5cNxDlaZ/d45Y3rYK7OFNBZddEt0aaU3540BOZzE/7QW7OIB7p9vDOs1YVXOS78Qw2Bzi4ResmHk0vYdURqOJ3vtFs1mXUn31l7q1RUvZ/vv+kwTJh25RSonXzrqekScbh+iesZjCMZQkYXsno4E9QPgye+B66IODpwAFT82bjZs7Q+WgwOM7tRphy2xWGto6I7BBhJPyBcVBmBM7Q5NyJgeZtD4SOEJObgBQrOCskbt1sKlrr89s1zxdUiby2wo8USnBEemSPNa6L/7erRL0afiaIgWL+PTL98SaqNL20GZoQrMiM7IfX+e37xtf+BQoy5Od5T2YGhQR0zbHwYNI16Ntev7D8TBSb2GSCBBMkCc6C8FiWu9u5GIbN4mrKPN8CCpMxJ4SXw/Hu34HBcqnmiC2jzieZdCwIy9bSSnfe/SnwruKUkV7S6WQo+jyEr0I
 Yutt4nl8
 9j3k2btNOIW9aJU2wgDKmOqU/EvR9wzK44jz06/AVlxCQ/XHrRJiECbzRKtegqiPob6LjdCdp4AFwJ3vw9u04cuffYK1JxMfZsZ6bjEx0Rxd13VImpeS8gralTF9kNAGX7qAW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

在 2025/07/14 9:42, Yu Kuai 写道:
> Hi,
> 
> 在 2025/07/01 19:08, Yu Kuai 写道:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> We have a workload of random 4k-128k read on a HDD, from iostat we 
>> observed
>> that average request size is 256k+ and bandwidth is 100MB+, this is 
>> because
>> readahead waste lots of disk bandwidth. Hence we disable readahead and
>> performance from user side is indeed much better(2x+), however, from
>> iostat we observed request size is just 4k and bandwidth is just around
>> 40MB.
>>
>> Then we do a simple dd test and found out if readahead is disabled,
>> page_cache_sync_ra() will force to read one page at a time, and this
>> really doesn't make sense because we can just issue user requested size
>> request to disk.
>>
>> Fix this problem by removing the limit to read one page at a time from
>> page_cache_sync_ra(), this way the random read workload can get better
>> performance with readahead disabled.
>>
>> PS: I'm not sure if I miss anything, so this version is RFC
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   mm/readahead.c | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
> 
> Friendly ping ...
> 

Friendly ping again ...

>> diff --git a/mm/readahead.c b/mm/readahead.c
>> index 20d36d6b055e..1df85ccba575 100644
>> --- a/mm/readahead.c
>> +++ b/mm/readahead.c
>> @@ -561,13 +561,21 @@ void page_cache_sync_ra(struct readahead_control 
>> *ractl,
>>        * Even if readahead is disabled, issue this request as readahead
>>        * as we'll need it to satisfy the requested range. The forced
>>        * readahead will do the right thing and limit the read to just the
>> -     * requested range, which we'll set to 1 page for this case.
>> +     * requested range.
>>        */
>> -    if (!ra->ra_pages || blk_cgroup_congested()) {
>> +    if (blk_cgroup_congested()) {
>>           if (!ractl->file)
>>               return;
>> +        /*
>> +         * If the cgroup is congested, ensure to do at least 1 page of
>> +         * readahead to make progress on the read.
>> +         */
>>           req_count = 1;
>>           do_forced_ra = true;
>> +    } else if (!ra->ra_pages) {
>> +        if (!ractl->file)
>> +            return;
>> +        do_forced_ra = true;
>>       }
>>       /* be dumb */
>>
> 
> .
> 


