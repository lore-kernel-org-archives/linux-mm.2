Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71CA4606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=USh/uglF
Received: by kanga.kvack.org (Postfix)
	id 990346B05B4; Fri, 30 Oct 2026 06:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942066B05B5; Fri, 30 Oct 2026 06:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832CC6B05B6; Fri, 30 Oct 2026 06:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54BC36B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:18:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4D79A064D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:18:08 +0000 (UTC)
X-FDA: 85378892256.17.505589F
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3873A120004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:18:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="USh/uglF";
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793355487;
	b=U9mlXJ8kogLKI7TACaNoG9IzZAEHn3b0LehN04oriEh8a7+LDGi6SOHsHUSgHJPwLneQgT
	rb+xbZ3QFY/rVz8pxL+jb1N+uHn7os08nwbVGYWwpTuicIAvjbqH5A3v6vViAGaQQBo0n1
	Pqpdg7le79boF4HPyt/kjIqWxM/jZ3s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="USh/uglF";
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793355487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yXaqoh5s4PPf38iH+x6/oHHC3PWrUNwJu1/pUiEDlE=;
	b=AIQC1mFElOFZoxur8iYRbMklQGDCbJMZUaA3NGEL+V0pkjhxTacfS25e5l9uA7uAKvvMIw
	Hz3Gd0bLOO2po8yaT4L6kpHFo1hISbN+Z2BqirYQtaf5TWXO4f/gTJg0sr36TotoJ0dG2C
	HF8UvHFEdKxGwqKq3VLCYEq2GudLEqY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jxdOHkyiVlgx0ljrE8WPZ+UvQQ8nJ+n+xgvwtsmeeU0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793355481; v=1; x=1793960281;
 b=USh/uglFKtNIE72pa2slhmXIbXPLaJ/+BKMtF37xJQh6jZZlIZwL/3d/OSdInl2NsZsqoQEF
 hpPN4QWYMP+4pZasQ5EPNX5RQenkNVPjhFRuWDPdeRLxQPuadxWLQcvmXIP0eFpZM1LSuChbB4l
 HZ6iG6pYa0cpQdns3OJmVWbQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e316e627bb9b034f;
	Fri, 30 Oct 2026 10:18:01 +0000
X-Mizu-Trace-ID: e316e627bb9b034f
X-Migadu-Flow: FLOW_OUT
Message-ID: <0f0f8e9d-b7c7-4032-9045-8d910d763e27@linux.dev>
Date: Fri, 30 Oct 2026 18:17:49 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org, Kairui Song <ryncsn@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
 <23a3fa60-9489-48ff-ab0e-38a865d6bde7@linux.dev>
In-Reply-To: <23a3fa60-9489-48ff-ab0e-38a865d6bde7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3873A120004
X-Stat-Signature: oxbc6jhq5aofmdt4srwmm51bqqfxgsdm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793355484-905953
X-HE-Meta: U2FsdGVkX1+ybPPcYsKicBujFHYj2pk1Npz8jDO12M5KoHwCIbzheENoRTP3r9TjmDI9uzMgOxTTBL24FhoDJNE9D0WtJrU5FV03FOw/gMXfJuqYVvO4iytzbc6kY3L7vKcXDHbyNBlAhhKhEoxRPtZN+sr2ND3y1mX1XOktWBk/ZMnLW50av9AgIGhWVDFSkv2UiD2BXbP02atSpFUg1yg2IH1NVFAJIhPoIt0lyIuaX+rf9YWzzQjxpuG38u/DVYw/Ix+1mtatb06YtAHrwQPEY+104yBwer5GJmqYM+Wz3A5FvotXNuXxUHNjIM0AkvUUwKsG26nDH0xxNHFi2qC6J/4s2ByYlGUvDzNsNwU+eAQ0UAYb0vCGVAqewFFlWEQ3fM+GMAySZTcdaAgAm2OTA5Yrk7Tf0zcmixtQ5rnEk42NWlJXATAEz1bJ4qycT03/4Eyew37o3hgGaioBtWZlZjKmJdHybTy3Qh6OuyDEnFy4NmBsHUjgBRklGvKH+CfLDLgrZJ82TXA4zIIII4WxwQ6a17pYQwpTH3ndQqYhqy5Tja3JZ++qwVINQwBuJbAexKmebqzgcxdgg3MjXeVI8UcaxljoJhFUH3gkGS3E8FSQGDBqzF+dgFXbkugxQjB+XoJ3LNC5LLockbx8GRnzfnffmmE9EfVIB/zPXQDZoLJ7H+Uqzp3WmL1uMX5gJYQW5LfcRqhHFhXORN4LH8ymCmvHGeI8sfCsepYiEHhZcd6QH8FbUHy7mSHOaRA8AneiprYTw9faLtKVlksXtm9G3bG4kjE1vZWox4BTy2nqzBV+9KpLHAiwhNVbQNabZJ60S0NgWVVJ52cXryoW/hx3ru2r0CHkIHjg8Mly/nqlZOVz2Bww+PJUWys4Da4Rm23XuAQt+mzz+cuobRNAKI8ecLXirbQjeuWgSGMxKfKL3m5sIyTnuazWLK/8tSyEICc9opHDnHvrI/2uMhw
 Wfprvmyf
 COzVorkLbcbiANCVdMnUnynRRtYFnqxMhGDHdOgok5hOqc9nzlVGl1I/WgHKQCWAJT4soIqXil7/AItqWIsss+fzB8qyMfwTZWQaZ2mvWpsq9W8D2qZJHWzqBj5OuJLzgXDem0gQUtn+9XXtfm9h29SD3yKrsIAV8hQkPPmjBlOZj1czerVfbVXsAJGqL+7UC21BSvo/kcGNh9KrsIyjNwlVhZyhF6K6oLJjAIoSDhqB3YCxZ7Z5hjGatIE9SLvpYtiF5ZP90Doeh0n+CDAFvN6wLC3wgWWBLz3xRJbE4ERMm/KLb5378gJDZ5F+ME16+BynVjndqOS/zc0RHItwpCKLGZIyXKBnnDvsXKm6fLVHZCVE8Y5sYh6Tp7ALQaVraAnASU6TrxxQ6yICmOgXMtyqZStpjwOW3Qz2DV7ulgjr6TBUGeCfBbusGsBwh2l9IKFEo8YDG7v0z1MJLqB9ONl8CDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/30/26 6:11 PM, Jiayuan Chen wrote:
>
> On 10/15/26 2:05 PM, Jiayuan Chen wrote:
>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>>
>> swap_cache_get_folio() reads the folio from the swap table and takes a
>> reference with folio_try_get(), without any lock. If the folio is
>> removed from the swap cache and freed in between, and its memory gets
>> reused, folio_try_get() still succeeds and we return a page that has
>> nothing to do with the swap entry:
>>
>>    CPU 0                                  CPU 1
>>    do_swap_page()
>>      swap_cache_get_folio()
>>        swp_tb = swap_table_get()
>>        folio = swp_tb_to_folio(swp_tb)
>>                                           madvise(MADV_DONTNEED)
>> zap_nonpresent_ptes()
>> swap_put_entries_direct()
>> swap_put_entries_cluster()
>> __try_to_reclaim_swap()
>> swap_cache_del_folio()
>> folio_put()   <- freed
>>                                           page reused, e.g. as an anon
>>                                           folio of another task
>>        folio_try_get(folio)               <- succeeds
>>        return folio
>>      swap_update_readahead()              <- may clear PG_readahead 
>> on it
>>      folio_lock_or_retry()                <- locks it
>>      folio_matches_swap_entry() fails, unlock and put
>>
>> filemap_get_entry() does the same lockless lookup for the page cache,
>> and after folio_try_get() it rechecks the xarray, because the folio may
>> have been freed and reused in between. swap_cache_get_folio() lost
>> that recheck when the swap cache moved to the swap table.
>>
>> So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
>> takes the folio lock of someone else's page, before
>> folio_matches_swap_entry() finds out the folio is not ours.
>>
>> Recheck the slot after folio_try_get() and retry if it no longer holds
>> this folio.
>>
>> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache 
>> and switch API")
>> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
>> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
>> ---
>> https://sashiko.dev/#/patchset/20261014090821.227366-1-jiayuan.chen@linux.dev 
>>
>> ---
>>   mm/swap_state.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>> index ebef568cd62e..d9e36c505398 100644
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -92,17 +92,27 @@ void show_swap_cache_info(void)
>>    */
>>   struct folio *swap_cache_get_folio(swp_entry_t entry)
>>   {
>> +    struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
>> +    unsigned int ci_off = swp_cluster_offset(entry);
>>       unsigned long swp_tb;
>>       struct folio *folio;
>>         for (;;) {
>> -        swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
>> -                    swp_cluster_offset(entry));
>> +        swp_tb = swap_table_get(ci, ci_off);
>>           if (!swp_tb_is_folio(swp_tb))
>>               return NULL;
>>           folio = swp_tb_to_folio(swp_tb);
>> -        if (likely(folio_try_get(folio)))
>> +        if (!folio_try_get(folio))
>> +            continue;
>> +        /*
>> +         * The folio may have been freed and its memory reused before
>> +         * we got the reference. Make sure it is still in the slot.
>> +         */
>> +        swp_tb = swap_table_get(ci, ci_off);
>> +        if (likely(swp_tb_is_folio(swp_tb) &&
>> +               swp_tb_to_folio(swp_tb) == folio))
>>               return folio;
>> +        folio_put(folio);
>>       }
>>         return NULL;
>
>
>
>
> I spent some more time on this and I'm not happy with any of the
> options I have. Advice welcome.
>
>   1. Trigger the worker where the zap gives up (this patch). On the
>      swap entry side that works, __try_to_reclaim_swap() has the si.
>      On the present PTE side it doesn't: free_swap_cache() lost the
>      trylock, so it can't read folio->swap to find the si, as Kairui
>      pointed out. And that trylock-and-give-up is not in one place,
>      free_swap_cache(), do_wp_page() and __uprobe_write() all have
>      their own copy. Chasing every one of them doesn't feel right.
>
>   2. Clean up at memcg offline. Doesn't cover the root cgroup or a
>      cgroup that stays alive, and on mm-new the folios are reparented
>      at offline anyway, so there is nothing left to find there.
>
>   3. A swapon flag, say --clean-cache, that enables the cleanup.
>      Pro: covers everything, and the cleanup can live in its own
>      function without touching the existing paths. Con: we know to
>      turn it on because we hit this, others won't. Needs util-linux
>      too.
>
>   4. A per-device worker that walks the device on its own, say 1024
>      clusters per second, backing off when a pass finds nothing.
>      Pro: same as 3, and nothing to turn on. Con: a worker that wakes
>      up on its own for this, I expect objections.
>
>   5. A sysctl (or a drop_caches bit) to kick the cleanup by hand.
>      Pro: same as 4, all in the worker. Con: same as 3, someone has
>      to know to poke it.
>
> 4 is the one I'd pick if nobody objects. Thoughts?


Plesase ignore his. I reply the wrong thread......


