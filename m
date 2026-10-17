Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D87CC6B2A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 05:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DBD46B0088; Sat, 17 Oct 2026 01:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C9D6B008A; Sat, 17 Oct 2026 01:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B116B008C; Sat, 17 Oct 2026 01:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48CB46B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:43:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73E0FA0214
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:43:35 +0000 (UTC)
X-FDA: 85331025990.14.04A7449
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf25.hostedemail.com (Postfix) with ESMTP id C2878A0003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:43:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YSCFTki7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792215813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NzrDCYoAPXZ3QXhbNS3e0GZIh1YHAHXFMXaEZ1z778=;
	b=XTpkz3/rt5kZvpjypMZfp3UmdKlNDpzd09jWopPZDYJIHMMQfBquHAilZCgDcTxSQXOPlI
	HmvFxO7QNmqA7YXdrjxcXuXk4kUt/KMjdx515Zr8SQzHMOZtk4l7s/TwQR/qdnfJGjscED
	VjfE3cmpuvYEJKuej2D4u4yKdlexi4o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792215813;
	b=483pCvz/t3wqlJBG3fu+Ya/ZNfcxDoAyKs4tgudW07QoPKxoHaazbSq6hsjJ1dYW9aNoCR
	wrWA4jj1P7/g0LM1LUUEaTTzXKL8w9SDlcngdos8tmYHJS2vCha9402RvjJpuau/MAWZD8
	PDQpzVBDnKqmCsgWd9IY5FEdnl/ejn4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YSCFTki7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792215807; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7NzrDCYoAPXZ3QXhbNS3e0GZIh1YHAHXFMXaEZ1z778=;
	b=YSCFTki7VBHQqvRfEAXikdT6PbVNAoHOib0Epl7AkRIds2G8bk/WcImh3I5QKMQc+rtAsaBkT/N2qSD2ndGnvyi1vDXkfn9ANoCkLFdWrCkLEp3sF7iCayjB8ZM/W+UyebeoIE59bonoX4fssVPcSh0mXQFdhYFQfs7MjNPInDo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XCwbfOi_1792215805;
Received: from 30.42.72.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCwbfOi_1792215805 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Oct 2026 13:43:26 +0800
Message-ID: <6a005d89-df5b-4524-a4b9-c637cb15f1ee@linux.alibaba.com>
Date: Sat, 17 Oct 2026 13:43:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, kas@kernel.org, jack@suse.cz, djwong@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, hch@lst.de,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
 ngocthang2710.1999@gmail.com, willy@infradead.org, rppt@kernel.org,
 ljs@kernel.org
References: <20261016065920.4153-1-lance.yang@linux.dev>
 <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
 <atICp2NL8j2z7UFM@pedro-suse.tail5790ac.ts.net>
 <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2878A0003
X-Stat-Signature: f6jqprwjy7gnj3w3dfn3ok8jcy1qrwd4
X-Rspam-User: 
X-HE-Tag: 1792215810-404270
X-HE-Meta: U2FsdGVkX19ivyUBxuLKv8Ly8fj56WzlFWaJKBKpTatpj/ZmXdbAaksi+WaQnioBZ0X/B6Mm/8NltKhrbqEag+eQaHE8+BwzxQKuPKoOlseQHJm84mihJsK6MjaR+NqucoQaLhGz3BUWC7Jr7qQngLL9i7jAGqr6ko15OON71fmkV91fZiwLLOHngKbTLTuGckrcnQ/I0g5wlIaGzRW1NOAqTH4zgFO2ZOXQIfH4T/RcqoJCBP+47dSgcV406c8080AEswzQr463dAOjeOSFHWbmYYXllH/GFJN8uD6GVPcsTDfTk6E6t2lq/K/7GSb1/PFnG+8u3kt04U7CXGihyLbxAu7iQfJQj40UxDGK/TsH/QD/vyaQxdYDs7i07TkYzTbvH5wDxoJAl6dw5oRkpMfreTAbpDhHFwTYDlY1eCyU2VwBFPol3CE7yTweN0CPjSkW11d/fmwvLPBxhJTBrt9W+8fK6OQfEWEAmtIj08CZyUIFxmKlLlsy3rJ3Xa3hrDEt3GOFYWNeQpCw4kJR08stvQwvH5mAU+szognzF6bO/My156HEbagu1x92QQ+EUadoEPJHGdwyN9X7orxcgbJQ8v1DAdYiybRi7Vj0+5eTUP/oQtx6twOhTLxwPnx/2pYS19CLRT/r0uaqyc5XGRa0qNs5YBhSwz1fBlbLx+2XfNsCPKTqJZvmP0/irlKgfQpbiuSJA6ZhnPzQDlSaTx6t7IO0lCsTinsED2IO0T2F+8CpRvfx4kgHf3egsadWI+T8h1SdBb0ESvLsTKdBCVpVZ6cDYz8ft4yOOLmC3nvZC7dp0/KVBfGQ8ze1Enho/c2pi+ZR+QiL6a1ptCLINrz5Atxajpfnf3dt8C6x2htgTEt/lw/NaqBmaXZu3XlJU8vdq80BjxQUi3pTnNssM3oYGqVOgXsz9RdJXNd8SidxPs+cYSRGY0MoZU/vRg6GAnUz6FgdysN7jCPaSJR
 2/MlC++l
 1t4m3AiKhXsYZfSgcFIEg/ibeROdeeHzNjujaZovksxmgTGaaTJmt0LY0XFErPshambemvQKvSpz3o4uOEREYsmAXjfM3hIHyz9s0TwuyZGtOx6lqE6vN8+ee7DLjIkQG5RZxYl05YzZ0I028UUd/s+x5wkmZLsLcBUVbeikU35CfclIyU8uZSJ9SvcVyfoPSKfyfpV9sb5PoMC+HHvbd6dCAXrVs2SY4d6ZRnyDCP+uZWqIJ5MUfI36Vm/BbnxPe8qdNtNz3vAU0C+du8jCwblTNUFF0tAfzEowYsSenjUuPsZIcFrrxOlKWM8prggmv6CCt8+W+Nzb+sSMaLS8Nu9UpwcuwCwZoJIShY229XSYqvzyC2Lr85uPyUPUW2PxdkeR8t3Q2bukXMDmTPSoqQSX5WbEbOd80yBKqx3E996gNBJ7soAniyvoemY1udGsAsDFyIZLAewgmU+OT60lveHEW3YUAXTXk+94EW9IUiF2A9zJG6lDb0uDxqprDN/dfyZG1puFnX3WqV/KAAUofx1pRroO9Td0bdXlX6mddhjtaMzYDg8mAOXaNbKjC2T8sIUFjI+JtiMQABEIAWUREZsdzHJk9TCyWGEhTjlucOFs8uTpDWwv/QeoeYfvlXujR58iwhoW8crf8G5632yahQF9pHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/16/26 9:18 PM, Pedro Falcato wrote:
> On Fri, Oct 16, 2026 at 12:00:24PM +0100, Pedro Falcato wrote:
>> On Fri, Oct 16, 2026 at 05:57:48PM +0800, Baolin Wang wrote:
>>>
>>>
>>> On 10/16/26 2:59 PM, Lance Yang wrote:
>>>> collapse_file() can end up calling page_cache_sync_readahead() with
>>>> source folios from earlier in the range still locked. If truncate already
>>>> holds mapping->invalidate_lock exclusively and is waiting for one of
>>>> those folios, readahead blocks on the same invalidate_lock and neither
>>>> side can make progress.
>>>>
>>>> Do readahead in a separate pass before we start holding source folios
>>>> locked for collapse. Keep page_cache_sync_readahead() and its existing
>>>> policy, and drop each folio's lock and reference after checking that it
>>>> is uptodate. If truncate or reclaim removes a folio between the two
>>>> passes, roll back instead of doing readahead again with source folios
>>>> locked.
>>>>
>>>> Shmem handles swapin and fallocated folios through shmem_get_folio()
>>>> without taking mapping->invalidate_lock, so it isn't affected by this
>>>> lock inversion.
>>>>
>>>> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>>>> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
>>>> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>
>>> Thanks for the fix.
>>>
>>>> Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
>>>> happy to take this over.
>>>>
>>>> Some older stable trees lack the folio infrastructure used here, and the
>>>> code will differ for each stable tree, so each backport will need quite a
>>>> bit of rework and its own review. I'm not sure whether to Cc stable here.
>>>> Once we agree on the fix, I'll send a separate backport for each maintained
>>>> stable tree except 5.10, which isn't affected.
>>>>
>>>> v2 -> v3:
>>>>    - Replace the scan-wide invalidate_lock and page_cache_ra_unbounded() with
>>>>      a preparation pass using page_cache_sync_readahead().
>>>>    - Roll back on a new page cache miss during collapse.
>>>>    - https://lore.kernel.org/all/20260913163644.122133-1-ngocthang2710.1999@gmail.com/
>>>>
>>>>    mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
>>>>    1 file changed, 31 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index ef5cd6fda34f..b3f67617caf0 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>    	new_folio->index = start;
>>>>    	new_folio->mapping = mapping;
>>>> +	if (!is_shmem) {
>>>> +		/*
>>>> +		 * Populate the range before accumulating locked source folios:
>>>> +		 * readahead may block on invalidate_lock.
>>>> +		 */
>>>> +		for (index = start; index < end;) {
>>>
>>> why drop xas_unlock_irq()?
>>>
>>>> +			folio = filemap_lock_folio(mapping, index);
>>>> +			if (IS_ERR(folio)) {
>>>> +				page_cache_sync_readahead(mapping, &file->f_ra,
>>>> +							  file, index, end - index);
>>>> +				folio = filemap_lock_folio(mapping, index);
>>>> +				if (IS_ERR(folio)) {
>>>> +					result = SCAN_FAIL;
>>>> +					goto rollback;
>>>> +				}
>>>> +			}
>>>> +			if (!folio_test_uptodate(folio))
>>>> +				result = SCAN_FAIL;
>>>
>>> Do we need to check PG_uptodate after locking the folio? If we successfully
>>> lock the folio, doesn't that mean the read I/O has completed? The following
>>
>> Yes, you do; a read can "complete" without the IO having completed successfully,
>> and in those cases PG_uptodate is not set, but the folio is unlocked.

OK.

>> Either way, why are we checking for uptodate here? We only care for starting readahead.
>> Anyway, I would possibly recommend we do this as post-processing, not pre-processing.
>> The current loop is a little overhead-happy.
> 
> To clarify: I would do this kind of RA as an error path if isolation failed.

Sounds good.

> Namely, at the end of rollback, after unlocking folios. It doesn't make sense
> to me to do this kind of checking upfront. I don't think it's particularly
> realistic that, starting RA upfront, you'd see uptodate completed folio reads
> when doing the actual isolation.

But why not add RA logic in collapse_pmd(), as we do for 
SCAN_PAGE_DIRTY_OR_WRITEBACK? There's already retry logic there, and 
this would also simplify the long collapse_file().

