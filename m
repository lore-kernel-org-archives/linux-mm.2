Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42644CCA462
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 05:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC106B0092; Sat, 17 Oct 2026 01:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1672F6B0095; Sat, 17 Oct 2026 01:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D506B0098; Sat, 17 Oct 2026 01:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D019E6B0092
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:26:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 141DFC012A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:26:19 +0000 (UTC)
X-FDA: 85330982478.23.F936DEA
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2DF7CC0003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:26:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=l7gXBwlg;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792214777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3GgPGTx3643lXfeM9v6MzNcAxFHDhjpDZHTgMJtQGg=;
	b=d9r51HQazb1Rwrmn5Ob6AIVSIC+atLvDzMQZms77y4o5a145iah6es8ocP4nNzdmz0/JOk
	Tqf+kQZr5Qv4waDXf7/AaccyQc3bQeovsL4SywHQQMwA3a696SIPuCtn04G2U25iYXoZf+
	sSCXHFrGHDze8OAL3HWv4P6XAnO3vGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792214777;
	b=RtLUwqxhPNwo7ekHm5p8rmWlACC76UJnkRnXhKkTRe0Z8rbEi0ZFusrNbO0Qk5Zd0u14C/
	YXPVTJtHzEjV6Ptfdan7cV9OmioyP9ZaYe58pNo9Bp9Et2PldWrHTF4RYu1wE/PCURdgz7
	z3W1wKahtsDsuhAwo/LgdcuksBB8f7k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=l7gXBwlg;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792214771; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=l3GgPGTx3643lXfeM9v6MzNcAxFHDhjpDZHTgMJtQGg=;
	b=l7gXBwlgH+Klzkb0EJl/rIF6P04xlgNYgvHyLjDLbQwbrzM2KL+fXj8XZ+MeFTbzEuUYrAKzLkdxy2EdevJrjkjmUyTlnRUZFh2WLoJKIM6g3qcwd8eVFj0iI6QqdB0/+U/yVNdSKLizcLOw3BnsCmiWIZyD66AIzsRDYGGkgd8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XCwX9so_1792214768;
Received: from 30.42.72.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCwX9so_1792214768 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Oct 2026 13:26:09 +0800
Message-ID: <5b8d5b3b-9308-40d1-91f5-8c6ea045c596@linux.alibaba.com>
Date: Sat, 17 Oct 2026 13:26:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Lance Yang <lance.yang@linux.dev>, pfalcato@suse.de
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 jack@suse.cz, djwong@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hch@lst.de,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
 ngocthang2710.1999@gmail.com, willy@infradead.org, rppt@kernel.org,
 ljs@kernel.org
References: <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
 <20261016154342.31940-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261016154342.31940-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DF7CC0003
X-Stat-Signature: fr5mef3r7qeegg8efyxu6widph5dpwth
X-Rspamd-Server: rspam05
X-HE-Tag: 1792214774-523864
X-HE-Meta: U2FsdGVkX18oOhx8qXE/wGf1cjTGLfwUiL3w4ipwXOcZSDzFDz/zbtdlNrx5dfmyC/DWo4qejvN9TPnL8bSjAswJ9EOIgOc/BI9VLXltzBWlErVBsD/EB4+RAWjzsMpLOIrmsDbxkthP9FNlAlK81phOcMY5SnTvj+hqt8BWrXwTYSQxUKiXzmsKr/FUjvuQrSqtJXnDxW0U5oWrlxVoMFNxaC4lu8823uE9jNIdJe3Ma31esLRBF8f4Hz4O8CXb6A0ckEU1AHhfgsNJ6xjBYTQQn7/m694G520E2QzavyyDBAvlCcvofqv0TEW55CwaNmtOO/hmkkjfZWdJOE6+4eFOEnEsj2wjs/GquBTm3rCxeB5vRhOHMw/U76scH50ZLo9us46waJN/OXp+lXSYCjliilRC3xplielKcQy1ibyFdKZdHaQhN7Bx+o/HePb9O6qJ/sFubFnEkIgZeU3PQvgagOR0B6iaMd1WtAqUghueKxD5RUa4ZgBnzNKZgjdvvg3OITREDjdUdsY9aZ1KSKMlPRV3IQIwjTdMTAcpSxBajzgDznDrnL0AceAxlx/3gx8TCxcSEGYqrWmNip/mEDKsduJv45jn3s7usTW/iN+oeype11W7ODJ5byu6mv7m0fe+b2V14mI35dAA05XlxZWBXjS5vSJWgZiHHoOuxwmvi6Ce5dIr3N2jmb175PajIfdW2mN3ZqqHaTUWq8UmHiCZ8m14Zg0E8fn2ycMfL8L3CLNp51r7+to8ZIVw/Vcu5hRYJuekt2tei2xU44rbO3os214bI6F1KlxNFE5caWLqbhjWtvLijDOCih0+Q7hiWznKOYUchY78IWuJRkQPoXPnOAMA9qI00aETk+02vYjrjMMFiZdwJRc8E2J7d5PQ1mZowCTAp2vAqZXueEsYibfy9gn0DCB+dF37S0ix8ZdZrWM13ev3+DZj+UbPEH/D3zsfpvZvQrcT8xEkFpH
 L8csUPK+
 INpdkECzypNR6Q87oHHtWfjNE6xExVXDULI6zG3ZxX9R0npp+/APwUASe9Blpmk5gNbxfHr2qC6eSSiZbhY5tfJcaZv4CquXPMokaMNVZ5+bL4uc1Qa4d5BCHqs9zkEwwUn5pCROz3Qz8TwFqUU3xYErQlhd8wSrrpszCCBNRHTZ8rM0Vz81sUfbny873CNwAzlX4z7E1fV38lNA0s16hk+aestXM42WxhcgKcSNbjWPacRlmdDRIccLap5gUVx4NBPZs7A7c8oRlKTiLNyFknS9oj5bEK4NZ/DVibXU31QmiEeneZYW21tGHC9RaBQ5RB8eLaHCqcSzJs24mECOnAMmssUdPJfWY972YxJ+miF3Ch8QjTkCByiR6y7hBQPUAc8ADYwHeE64I1whZOYcuJ0XHVbMIdE9ygASvsOUiQofEE7VepTE9Yz3YYUlTsMm9brmnPYUiJDgmOmb5AkoQoMvm3Zvwt5FCSaswR1MLcdEbD7Yg6NtTlf/n7Dofsn/RJ2OFiojBlthQqnmU50MRkDMY4FhvO2j432CdXfCQCbgt/Uo0om4xrEP5Iq4a6O6sWM9/YUqfBgQgN66OpICfvrhluxhotJibaKZ9nr9go2HF6qiNmkzlihJa0vJbYyHEu1iINOcwaWTJNUgk2dTKNgOk2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/16/26 11:43 PM, Lance Yang wrote:
> +Cc: Pedro
> 
> On Fri, Oct 16, 2026 at 05:57:48PM +0800, Baolin Wang wrote:
>>
>>
>> On 10/16/26 2:59 PM, Lance Yang wrote:
>>> collapse_file() can end up calling page_cache_sync_readahead() with
>>> source folios from earlier in the range still locked. If truncate already
>>> holds mapping->invalidate_lock exclusively and is waiting for one of
>>> those folios, readahead blocks on the same invalidate_lock and neither
>>> side can make progress.
>>>
>>> Do readahead in a separate pass before we start holding source folios
>>> locked for collapse. Keep page_cache_sync_readahead() and its existing
>>> policy, and drop each folio's lock and reference after checking that it
>>> is uptodate. If truncate or reclaim removes a folio between the two
>>> passes, roll back instead of doing readahead again with source folios
>>> locked.
>>>
>>> Shmem handles swapin and fallocated folios through shmem_get_folio()
>>> without taking mapping->invalidate_lock, so it isn't affected by this
>>> lock inversion.
>>>
>>> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
>>> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>
>> Thanks for the fix.
> 
> Cheers!
> 
>>> Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
>>> happy to take this over.
>>>
>>> Some older stable trees lack the folio infrastructure used here, and the
>>> code will differ for each stable tree, so each backport will need quite a
>>> bit of rework and its own review. I'm not sure whether to Cc stable here.
>>> Once we agree on the fix, I'll send a separate backport for each maintained
>>> stable tree except 5.10, which isn't affected.
>>>
>>> v2 -> v3:
>>>    - Replace the scan-wide invalidate_lock and page_cache_ra_unbounded() with
>>>      a preparation pass using page_cache_sync_readahead().
>>>    - Roll back on a new page cache miss during collapse.
>>>    - https://lore.kernel.org/all/20260913163644.122133-1-ngocthang2710.1999@gmail.com/
>>>
>>>    mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
>>>    1 file changed, 31 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index ef5cd6fda34f..b3f67617caf0 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>    	new_folio->index = start;
>>>    	new_folio->mapping = mapping;
>>>    
>>> +	if (!is_shmem) {
>>> +		/*
>>> +		 * Populate the range before accumulating locked source folios:
>>> +		 * readahead may block on invalidate_lock.
>>> +		 */
>>> +		for (index = start; index < end;) {
>>
>> why drop xas_unlock_irq()?
> 
> Hmm ... we haven't taken the lock here yet, so there's just nothing to
> unlock, no?

Ah, yes, I misread the diff. Sorry for noise:) .

>>> +			folio = filemap_lock_folio(mapping, index);
>>> +			if (IS_ERR(folio)) {
>>> +				page_cache_sync_readahead(mapping, &file->f_ra,
>>> +							  file, index, end - index);
>>> +				folio = filemap_lock_folio(mapping, index);
>>> +				if (IS_ERR(folio)) {
>>> +					result = SCAN_FAIL;
>>> +					goto rollback;
>>> +				}
>>> +			}
>>> +			if (!folio_test_uptodate(folio))
>>> +				result = SCAN_FAIL;
>>
>> Do we need to check PG_uptodate after locking the folio? If we
>> successfully lock the folio, doesn't that mean the read I/O has
>> completed? The following code also checks the writeback flag, so the
>> uptodate check seems unnecessary to me.
> 
> IIRC, the folio gets unlocked even if the read fails. I just wanted to
> catch read errors early. And yeah, we already check uptodate later,
> so this one can go, thanks!
> 
>>> +			index = folio_next_index(folio);
>>> +			folio_unlock(folio);
>>> +			folio_put(folio);
>>> +			if (result != SCAN_SUCCEED)
>>> +				goto rollback;
>>> +		}
>>> +		/* drain lru cache to help folio_isolate_lru() */
>>> +		lru_add_drain();
>>> +	}
>>
>> Could we factor this code out into a small helper?
> 
> Okay, let me play with it a bit :) Might pull it out if it reads cleaner.

Thanks. Because collapse_file() is already too long.

