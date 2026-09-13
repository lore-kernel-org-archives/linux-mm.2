Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 267C9C88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 16:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9D16B0092; Sun, 13 Sep 2026 12:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B146B0093; Sun, 13 Sep 2026 12:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97786B0095; Sun, 13 Sep 2026 12:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B25B06B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 12:17:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8C38160824
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:17:17 +0000 (UTC)
X-FDA: 85209243714.09.1A05E7C
Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6CF7A40008
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:17:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VZXQLr/h";
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789316235;
	b=5EG/ULS736jC8P+KLzlued9/uUE0VJhUleYu0aE5Hag+pEcBDQ3LbeHrgxKRptS/9YOt20
	GKhIh7bMKTE6dxpLMHD3ryNeWjDC5kKCzeUuEhoL0cjy4KToO1u54kV0jRxOLG+oDbll20
	TIWgIdzUVQHVcxqEsD6ud/udKnRXeuM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VZXQLr/h";
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789316235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfxA0C1BJxifdEbHLrvrB4Owp/1iqwk7Yibr7BeXp1I=;
	b=R/Iy/LQyOn+8YNI+YUdzc0MaXm8A8P9K7DzFgtCQWr6p4TtL/EIzB7tDIpJObpkFLsSYAj
	0aG91Zq2sY3wR81pNTnY6vRlfpqBQm20j7Mtg/64HTy/7yo68jdxCvwemB2nsJOtjUqnG/
	t8dkTyNVt8SoWxYFjDBYNIMGSwvuyCA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=svZCpv21FthwypPz3c8MpF7aUfNyE0+BDGgA1bEnvbg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789316231; v=1; x=1789921031;
 b=VZXQLr/hmgNgOJwye9d2L+gV/euc+YUVN1o+oyvNDQW/WqP2Dg0N/iy/YDC1wM2wYkiKUpm6
 3Jo6E0Uut3QwEwxOEbYcJrf5tL7DDnUtdohLUNvTaY3lTLeV9KQfAVFyk4MGa0sbJk7y8uZZM0J
 vWYmrJJ3lP0gGqGFdJLZEX7s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id caa88b22c15f5b16;
	Sun, 13 Sep 2026 16:17:10 +0000
X-Mizu-Trace-ID: caa88b22c15f5b16
X-Migadu-Flow: FLOW_OUT
Message-ID: <dc6f3b89-58cf-48c6-bb4f-9fe605c92028@linux.dev>
Date: Mon, 14 Sep 2026 00:16:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] khugepaged: hold invalidate_lock across collapse_file()
 readahead
To: ngocthang2710.1999@gmail.com
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260913101142.28802-1-ngocthang2710.1999@gmail.com>
 <20260913161245.11120-1-lance.yang@linux.dev>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260913161245.11120-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6CF7A40008
X-Stat-Signature: ddh5zbaomx338c13d8mogk5umyyzz4uk
X-HE-Tag: 1789316235-613645
X-HE-Meta: U2FsdGVkX1/U8RRnV3PkBbgDr5ygxXTkUm1ZkwswZPQ6ityIP+zDpxmj7ldugV4P35lkObXvJ02i8gGl575yBVMnUmWeKt1W37eFhwY9s6kFWkA2ESrFQOpW37Qz1mWT/zPJjBDsSRsC4EATqiVV/tAnr1Okc44OsHfiAlTDAGAopo+Yo3JaXfAWo9SllOpalh06q9jVYSJ71Ww8ZgDYhNJfwdYfzo+h+3FIs8wghFnruyEttqwrtXAAi6FpCZ4s7C7fXvGvkMcNYHeHHS7Wj8BiZ3EbApZpnhOEI4ODAHVAGZsMj0klBP0f5BXVS/svcBT6QyTInD3PFW066KWXEl00GHtr91wJZ038gOrx5NlDqPt3t4b2HuPO22oOEgdB1HZcCI0Bv6peVXGvrzj9v2yJthExN9YR1tdtngRcWUO63957K1Ri8hu8+lFznPKuzFoyWRG9L1hhgVWieUztr0xhqp/U7nbtjmU6WPHj9uVdoZLNi17jKTfHhWIBDfabZ58zxUf3PHcBE0FBHBhVt6Dpj7v7IIGd3v1fqt8DVy+R9l67Nrw6bYBtWDodjGeOKHCRVQ/EziyFU/c8XFn7n95Wcw0fT8Mtufv3vUAUBGJnKCvmu2TiLMkOhd2YRFq6le65gQV8417igOo/ZJ6i1U8WA4FHDCd7aWd52uLldOmiYbkxwws+2u7pw76DMZTUbNYHTefgng3ra4wOHIul3PpKGzAGDoxfGYVwLtRt4XwH+3+hPCBmwAmSYu33vON/LL9lGUmOmVRuN2YapopODvYnHd6tzM5HuBjgM+cLLSJ3oTMbzxxeHAq90nLOPEksI0iWm2F6ij1HFZF2ITNRSzRlCeckV83hRew3eYOZ6qDIbsZUlfMeJwbZ/bV58o35XlTHv2DXHWayHZcut6hcyGs6d5QaDB1sUNjBs/8VTf16lubQBA/7KbJ9L99iyIvNYJvOoj9quWEPfoNuLcv
 +P4d701a
 6r7+mIUCHIuIn0MX7w0ieaiPkHaBfUj1u71OLnLVc3AIxt59j1cwi0u+yaJWsLsRngtbEKI7boMBGJT/JTjljS/v0lkqR9iZllflBAM5X+Ah8CJkibVfNv7Ag7ATjmV9V4MuA4UHZ7erlUF6PSog8F7cPk/LvhoTI8WPCEmAQTCqSra0pJDqhbopLB50hdqDNHS/z/kJYD/HMMJgizQ6KbYIMUMPKvlwsHq++XF2Aay8S7GQYKQNOfCCPgBiUedNv8eV1IxRqo2LkhRX1FKtri1n572e71tHWb0qc0IrFon3UfRQd+9KqEhXA4Fz7TWfMZFiZ4prUKnLCj5zMPZAL1PCDT6TbYadvth4JREkE47tRTb97MsLKzr/JgZxI5Eg/ZvS/z3uxg2c+4HsT4TkmmtOYbBgb2h0LYSVG1TVWB9FDvQIcDQ/8X4xCSH/Zla0dPHauGMotsovCLzF+C0XXL9Z8p+WW/SMajvBEJZa7+8252P/G5ee6wVYx8/uzkZra5Zljp6i2WhMyT2leG6uyhcTKVFGtCpuwj8hTUH/n+RG9+lsC/LPXMHkRnInXy/Esw4yrqzHwrz8BE4X+lulQyhfFvpa4iRHR32OYVWasGOSl0qY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/14 00:12, Lance Yang wrote:
> Hi Nguyen,
> 
> Good catch, thanks!
> 
> On Sun, Sep 13, 2026 at 05:11:42PM +0700, Nguyen Ngoc Thang wrote:
>> collapse_file() calls page_cache_sync_readahead() to fault in missing
>> pages before collapsing them into a THP. That helper takes
>> mapping->invalidate_lock itself for the duration of the call, then
>> drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())
>> takes invalidate_lock and then waits on each page's folio lock while
>> holding it. If collapse_file() has already locked one of those folios
>> by the time truncate reaches it, and then tries to acquire
>> invalidate_lock again (e.g. on the next iteration, or via a nested
>> readahead call), the two paths can deadlock/hang on each other's lock:
>> truncate blocked on the folio lock collapse holds, and collapse
>> blocked waiting for invalidate_lock that truncate holds.
> 
> That can happen on the first readahead call.
> 
>>
>> Reproducing this over ~150,000 collapse iterations with truncate
>> racing concurrently reliably hits hung_task: blocked tasks within
>> about 20 seconds on an unpatched kernel.
>>
>> Fix it by taking invalidate_lock_shared once for the whole scan, before
>> locking any folio, and using page_cache_ra_unbounded() directly in the
>> readahead call site instead of page_cache_sync_readahead(), since the
>> latter would try to retake the lock we already hold.
>> page_cache_ra_unbounded() does not clamp to EOF like the helper it
>> replaces, so clamp the requested range explicitly.
>>
>> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> 
> Ouch, we should add a Fixes tag and Cc stable:
> 
> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> Cc: stable@vger.kernel.org
> 
> 730633f0b7f9 added invalidate_lock acquisition to readahead but missed
> collapse_file(), which already called it with page locks held. The
> subsequent filesystem conversions made the deadlock possible by taking
> invalidate_lock before locking pages :( right?
> 
>> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>> ---

Forgot to mention:

I reproduced the hang too, and it goes away with this patch applied :)

Tested-by: Lance Yang <lance.yang@linux.dev>

>> mm/khugepaged.c | 25 ++++++++++++++++++++++---
>> 1 file changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 11ff98d55c76..690ccbcdf593 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2267,6 +2267,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>> 	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
>> 	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>>
>> +	/*
>> +	 * Take invalidate_lock before any folio lock: the readahead below
>> +	 * needs it, and truncate holds it while waiting on folio locks.
>> +	 */
>> +	if (!is_shmem)
>> +		filemap_invalidate_lock_shared(mapping);
> 
> Could we take the lock after alloc_charge_folio() succeeds, before
> locking any folio? That would keep allocation and charging outside the
> critical section. And if allocation fails, we should skip the unlock :)
> 
> Cheers, Lance
> 
>> +
>> 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>> 	if (result != SCAN_SUCCEED)
>> 		goto out;
>> @@ -2337,10 +2344,20 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>> 			}
>> 		} else {	/* !is_shmem */
>> 			if (!folio || xa_is_value(folio)) {
>> +				DEFINE_READAHEAD(ractl, file, &file->f_ra,
>> +						  mapping, index);
>> +				pgoff_t eof = DIV_ROUND_UP(i_size_read(mapping->host),
>> +							    PAGE_SIZE);
>> +
>> 				xas_unlock_irq(&xas);
>> -				page_cache_sync_readahead(mapping, &file->f_ra,
>> -							  file, index,
>> -							  end - index);
>> +				/*
>> +				 * invalidate_lock held above; don't retake it.
>> +				 * page_cache_ra_unbounded(), unlike the readahead
>> +				 * helper this replaces, does not clamp to EOF.
>> +				 */
>> +				if (index < eof)
>> +					page_cache_ra_unbounded(&ractl,
>> +						min(end, eof) - index, 0);
>> 				/* drain lru cache to help folio_isolate_lru() */
>> 				lru_add_drain();
>> 				folio = filemap_lock_folio(mapping, index);
>> @@ -2672,6 +2689,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>> 	folio_unlock(new_folio);
>> 	folio_put(new_folio);
>> out:
>> +	if (!is_shmem)
>> +		filemap_invalidate_unlock_shared(mapping);
>> 	VM_BUG_ON(!list_empty(&pagelist));
>> 	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
>> 	return result;
>> -- 
>> 2.43.0
>>
>>


