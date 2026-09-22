Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCACC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921716B009B; Tue, 22 Sep 2026 09:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBA46B009D; Tue, 22 Sep 2026 09:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F756B00A2; Tue, 22 Sep 2026 09:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB7E6B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:22:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4CBE4042F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:22:47 +0000 (UTC)
X-FDA: 85241463174.24.FB73E27
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf18.hostedemail.com (Postfix) with ESMTP id A076D1C000E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:22:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790083366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SAo+6m60TUwBtaV43HMaUA2roGxabJIqlFNH5+Wecf0=;
	b=ZlSF7naoxutnJIJMd4PIeHxmkOHibPktVHdfxM4198Ltlm2OouJsXddXH3vYEyM6LYqWKY
	kAmsQ9OwmSNTF+WUUjiVbwHw59gyuy2at8JJ4W5j5yf5LSMZ+/S3IBfyZbuO5YV9diexzR
	Wb8nP58wjhqMlAeqmUgbunBJ/UyWw0Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790083366;
	b=OtTk0OFyp7bo0dtM+ATJBNHcpeMfd8qYrDynS/GC0W+bZAMaFgiTH8YNV8aXsKsFvJ9m3b
	KqLzDS0V2IyZFch+/qwHcXKeVK6Nv9/X+pFnlYkyA45sra7CBGqhrFHEML7MkI1ch20WjL
	Ayq7Yi6vUbgre1dWgYDXIE8V9ZnixjM=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 688CD3E97F;
	Tue, 22 Sep 2026 13:22:35 +0000 (UTC)
Message-ID: <6f377965-c743-4d9f-81a7-3aa3294d61d3@ghiti.fr>
Date: Tue, 22 Sep 2026 15:22:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback
 completion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz,
 liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org,
 youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org,
 chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu,
 hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921152449.629486-1-alex@ghiti.fr> <arJYmwKnEu-djZlK@gremlin>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <arJYmwKnEu-djZlK@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: 0
X-GND-Cause: dmFkZTF/8uKKPssWFWWUf2U9HYiLJp5w+tXmVv+YDcS50c92DN1fQwYMZw1OuAUFlMAUzydZ4lXRRy6z7Brsk1rMOWSDgAXu2353p2ew8iHihpx2mRh5MZnvnXouWJxc60fJs6S7hvviAdPurSzfBVWd8mosx9G2KkRsOYox/bM3YbLfwA0jA+DT3WldNx5VY0Jw33Qfh9MvmRLsqwaQgUJFthpc8Pk9S7RlBCLZNe7P0rvwHW1S88CjPepTSS/ejhOtF40J4dIzcwN3W3ULvldJtBYhvzLc2p+CY7GTYR7O8AKecnKvTUVzeiXR4yg2Aalo68fBlf3hRylxr6oUVGV6RgnuR92bC4P5hIC+zFhEYfhVxTpIxW4EQByzng8e7n0Wp3Mf9SWj7MDYuZjqdnQSNKIoX1lVar0PxeDT6UEppvXgClrGTJNiG1HW3cq+eP4h7hFHjV400HCqHxSlfXsgtRIaPJTfEzHmXekmvJiR1jceQUGwyB/cJJpsyyqUp1n0zBD2PdPCUtO5ZedRCY0z8CDcO4JyyvRYHZ9VkLt92wIUWMwW+UjMbQOXUR6kdTolQsKXo7rNygnRjt5L+8VluOfUAy+SgfpBW+4iTT5u8I49L62jFrhWz2n0TAbH4VtPcImIAr1CrjY4sSTahPrEwdJkuiVwlMbayGO/Jxeb+/VDZA
X-Rspamd-Queue-Id: A076D1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: afqd391yezw6ws18fr6pdrrgghkegjaf
X-HE-Tag: 1790083365-41054
X-HE-Meta: U2FsdGVkX187Q1Lidnikp5APXOX57cdkkJBcsULqrxY2WbKdPMY18xh9c5cm1OzOkWBLl9lnwQtKPAzPxsH3ysGT9fS69VyTDEdjAEa0aWf/s1ioni+Xz/wPHWFquxKsrlcdZn6/QZumj3165W/TxtpzmpxiDgpG8Wp2gNZ81gFU7yxlLSYh/qcwMTlShE2xdcbV5wzOrbb2YBwmTwXFCeEStF3FIsbqyXZrshU0nkcYeczlgXGnlgbxrgY5HS6BwWGin0cttZCKQkUGrNVo7c9fFLdwjaEbr5r3PtcYvEGA1t5lUOoUId3sZCiVcCpUMkPzAzizIsaf9QBFmGj1ohZye3esRHdsh6CC1shKcG5DEScxUGWwL2JInZd+ulq8Uhlr+j3A7tPWyVaGAJV+CAuLyz+gmj8WZ0svk7gJKSswLwTqsY/8NUcqak+x6E8FAYox+jSE2uDZC/GiBC5B63mIS3Y4zujNabetDjGD7ytCi/HMt73gBf1eGjx9ev1CcDSjkOGEqqU9mttAWkMhoVcJaRQp2EfyobCfttMlaLa43fhDfaylYyqyoX5kW57Zi9O/5fpXuSIOQg0a0/4F+Rrn5v8pyUrWw4eFF07jVWUtE8wolVBaDtdihTmRPbErjcxYz2ebGunEdAunbtuEcGCHBrmlOc8A0W2TLIdUV/64nmBSSFcjnbI6m3y8KnVa4b7nklmYjJ/9WgY7EujnSoe2zsGLA/3omUXEoRaHKHO8g5kgX5BRojkxCAy7W6Y2E/L85Y7IrwNhAi8rSdvJ6T8pDPv1zc0i+XZY+WaAH21yeQgehkWr2+cfAG6Qsc2SsAiMq6VcjN1aUK6rRWC/i/O74jjOeLe9vWm+c4klQpZB9sjz+cvYQQCmHXGf6yX3+bBS4DbdpkFY2OGebxMI7fSUUs5hOpEWCyB95ZwcoNz2lu0T3/ve4bUOCVMsdEYrLZVMIL9KeZijgv1vLMk
 pDslks3c
 NyXkL9MRMVqmOokOPAPuFpUPe7YCbAn6k+Gd9CTfXN0qAV5cBi54CavxtDJgS/bj3C/Cq6BJc/nKQi1CGHVAkN2CkGq+VVJQdtK3KuvYwN2sH21XlkatUQnDtBAvLJIcjbzHMOsuEhC1Nm2WEV9QUiSGXff0LW7VdO0Le7aZIf68vGEiTCi+QL5n/Rt+TScxmzosx0LqcSNAzOKMlCUU9AkRIZVkkQr4MavBEQNPOcXAq2IY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On 9/22/26 12:44, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 21, 2026 at 05:24:33PM +0200, Alexandre Ghiti wrote:
>> On an asynchronous swap device MADV_PAGEOUT only marks the folio
>> PG_reclaim and rotates it to the tail of the inactive list once its
>> writeback completes, so the memory is not actually freed until a later
>> reclaim scan removes the by then clean swap cache folio. Mark those
>> folios dropbehind at isolation time instead and let folio_end_writeback()
>> drop them from the swap cache as each write lands.
> Please split out very large paragraphs like this. It's hard to read this.
>
> You aren't giving any justification here you're saying 'X happens so don't do X
> any more'.
>
> Why? That should come FIRST.


You are right. I believe leaving those folios in memory creates useless 
memory pressure and then should be freed as soon as possible.


>
>> A dropbehind folio is dropped by whoever completes its writeback, so the
> Ugh I really don't love 'dropbehind'. But I guess it's a thing then?
>
> Can you explain what that is? This commit message isn't really teling me much.


I'll do in the next revision. And indeed I have been playing with 
dropbehind quite a bit lately and I believe (and benchmarked) it 
prevents useless reclaim (see the zswap writeback dropbehind patchset).


>
>> reference the submitter holds has to be released before the write is
>> submitted. As reclaim does before freeing a folio, flush the pending TLB
>> batch first.
> Why do you do that? I don't care if something does something, _why_?


To prevent stale TLB entries to persist while the folio has been freed 
by the callback. I'll add that in the next revision, thanks.


>
>> Note that for dropbehind folios nr_reclaimed is now credited when the
>> write is submitted rather than when the folio is actually freed, since the
>> reclaimer never sees the folio again.
> That sounds iffy...
>
> If this is a change that you are actively doing don't say 'note that' as if it's
> a fact that can't be avoided.
>
> You are _choosing_ to make a change, justify it then say you did it.


Yes, this is questionable indeed, hence the note so that I can have 
feedback. Even if it is too early to state the folios were reclaimed, I 
believe it must be done somehow, I'll add that in the next version.


>
>> Suggested-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>> This applies on top of "[PATCH v6 0/3] mm: zswap: free cold writeback folios
>> promptly":
>>
>> https://lore.kernel.org/linux-mm/20260921151306.625134-1-alex@ghiti.fr/
> Hmm, but you're targeting mm-unstable no?


Yes, I was not sure how to proceed here: should I RFC instead? Or is it ok?


>
>>   mm/filemap.c |  7 +++++++
>>   mm/madvise.c | 23 ++++++++++++++++++----
>>   mm/page_io.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>>   mm/swap.h    |  2 ++
>>   mm/vmscan.c  | 10 ++++++++++
>>   mm/zswap.c   |  9 ++++-----
> Why is this a core mm change which also changes madvise but you're changing
> zswap too? This feels like it needs to be broken out into commits.


Because I make modifications in the core mm that is then not needed 
anymore in zswap (the release of the reference). But I can split that 
into another patch, I'll do. Thanks


>
>>   6 files changed, 95 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index e1f1bbe943ce..14fa96fca8b8 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1630,6 +1630,13 @@ void folio_end_dropbehind(struct folio *folio)
>>   	if (!folio_test_dropbehind(folio))
>>   		return;
>>
>> +	/*
>> +	 * PG_dropbehind could be set on an anonymous folio after
>> +	 * folio_end_writeback() samples it (for example MADV_PAGEOUT).
>> +	 */
> I don't really feel this comment explains why you're exiting here? It's like you
> randomly state a fact as a comment.
>
> Something like 'do not end dropbehind for anon because < reason >' no?


We need to test anon here because PG_dropbehind could be set in parallel 
by MADV_PAGEOUT and that would make the anon folio reach 
filemap_end_dropbehind(), which is wrong. I'll improve the comment. Thanks


>
>> +	if (folio_test_anon(folio))
>> +		return;
>> +
>>   	/*
>>   	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
>>   	 * but can happen if normal writeback just happens to find dirty folios
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index eeee82cf2b3f..63164f95720b 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -359,6 +359,17 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
>>   				     FPB_MERGE_YOUNG_DIRTY);
>>   }
>>
>> +static void madvise_mark_dropbehind(struct folio *folio)
>> +{
>> +	/*
>> +	 * A folio already under writeback is skipped: that writeback is not
>> +	 * ours to hand over, so reclaim will put the folio back on the LRU
>> +	 * while its completion could be dropping it at the same time.
>> +	 */
>> +	if (folio_test_anon(folio) && !folio_test_writeback(folio))
>> +		folio_set_dropbehind(folio);
>> +}
>> +
>>   static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>>   				unsigned long addr, unsigned long end,
>>   				struct mm_walk *walk)
>> @@ -439,10 +450,12 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>>   			folio_set_workingset(folio);
>>   		if (pageout) {
>>   			if (folio_isolate_lru(folio)) {
>> -				if (folio_test_unevictable(folio))
>> +				if (folio_test_unevictable(folio)) {
>>   					folio_putback_lru(folio);
>> -				else
>> +				} else {
>> +					madvise_mark_dropbehind(folio);
>>   					list_add(&folio->lru, &folio_list);
>> +				}
>>   			}
>>   		} else
>>   			folio_deactivate(folio);
>> @@ -554,10 +567,12 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>>   			folio_set_workingset(folio);
>>   		if (pageout) {
>>   			if (folio_isolate_lru(folio)) {
>> -				if (folio_test_unevictable(folio))
>> +				if (folio_test_unevictable(folio)) {
>>   					folio_putback_lru(folio);
>> -				else
>> +				} else {
>> +					madvise_mark_dropbehind(folio);
>>   					list_add(&folio->lru, &folio_list);
>> +				}
>>   			}
> This existing code is utterly horrible can we maybe do some refactoring before
> adding yet more functionality here?


I can't speak for him but I think Gregory Price has prepared a patchset 
that indeed refactors this code, I'll check with him.


>
> I feel like the 'pay down technical debt first' take I had in THP is pretty
> valid here also.
>
> But also, yeah you DEFINITELY need to separate out patches here.


Ok, I'll improve that in v2.


>
>
>>   		} else
>>   			folio_deactivate(folio);
>> diff --git a/mm/page_io.c b/mm/page_io.c
>> index 52eae99de6e3..bf8238768cc9 100644
>> --- a/mm/page_io.c
>> +++ b/mm/page_io.c
>> @@ -26,9 +26,12 @@
>>   #include <linux/delayacct.h>
>>   #include <linux/zswap.h>
>>   #include <linux/swap_ops.h>
>> +#include "internal.h"
>>   #include "swap.h"
>>   #include "swap_table.h"
>>
>> +#include <trace/events/vmscan.h>
>> +
>>   int generic_swapfile_activate(struct swap_info_struct *sis,
>>   				struct file *swap_file,
>>   				sector_t *span)
>> @@ -248,8 +251,19 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>>   	}
>>   	rcu_read_unlock();
>>
>> +	if (folio_test_dropbehind(folio)) {
>> +		/*
>> +		 * pageout() traces and accounts at its tail, which we can't do
>> +		 * because dropbehind folios may already be freed by then.
>> +		 */
> I'm really confused by this comment.
>
> You're in swap_writeout() but you're talking about pageout() and what they 'may'
> be freed by then so you're tracing/accounting in more than one place which
> sounds wrong?
>
> This  at least needs to be clarified.


I see, it's not obvious: trace_mm_vmscan_write_folio(folio) is usually called in pageout() after calling swap_writeout(). But with dropbehind, the folio could be freed when swap_writeout() returns and then we can't use the folio anymore. I'll be more explicit in v2, thanks.


>
>> +		trace_mm_vmscan_write_folio(folio);
>> +		lruvec_stat_mod_folio(folio, NR_VMSCAN_WRITE,
>> +				      folio_nr_pages(folio));
>> +		ret = SWAP_WRITE_DROPBEHIND;
> Not sure the comment explains why you're chaging the ret here?


The folio could be freed and must not be touched after the IO was 
submitted. I'll make it more explicit.


>
>> +	}
>> +
>>   	__swap_writepage(ctx, folio);
>> -	return 0;
>> +	return ret;
>>   out_unlock:
>>   	folio_unlock(folio);
>>   	return ret;
>> @@ -692,8 +706,45 @@ EXPORT_SYMBOL_GPL(swap_fs_activate);
>>
>>   void swap_write_submit(struct swap_io_ctx *ctx)
>>   {
>> -	if (!ctx->sio)
>> +	struct swap_iocb *sio = ctx->sio;
>> +	bool dropbehind = false;
>> +	int p;
>> +
>> +	if (!sio)
>>   		return;
>> +
>> +	for (p = 0; p < sio->nr_bvecs; p++) {
>> +		if (folio_test_dropbehind(bvec_folio(&sio->bvecs[p]))) {
>> +			dropbehind = true;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (dropbehind) {
>> +		/*
>> +		 * A dropbehind folio is freed by the completion, not by the
>> +		 * reclaimer, and freeing needs every deferred unmap flushed,
>> +		 * not just the writable ones try_to_unmap_flush_dirty() covers
>> +		 * before the IO.  The reclaimer flushes before it frees, but
>> +		 * that is too late for a batch swap_add_folio() already
>> +		 * submitted mid-loop.  A no-op once that flush has happened.
>> +		 */
> please use newlines to separate paragraphs :))
>
> This is really hard to read, it's an LLM-like wall of text.
>
> There's so much going on here.
>
> - A dropbehind folio is freed by completion not by reclaimer
>
> - Freeing needs every deferred unmap to be flushed (not only blah blah)
>
> - Reclaimer flushes before it frees but then it's too late for blah blah
>
> - This is somehow a no-op once a flush has happened.
>
> Reading all that really makes me think that this solution isn't the right one,
> instinctively? If you're having to juggle many many delicate things all at once
> to justify some code that generally implies your design is wrong or at a wrong
> granularity.


I don't think it's that delicate, the comment may be too complicated 
though: we simply need to make sure to flush tlb entries here before the 
folio is freed to avoid stale entries. I tried to explain why 
try_to_unmap_flush_dirty() in shrink_folio_list() is not enough...etc. 
I'll keep it short and I think it should be enough (?).


>
>> +		try_to_unmap_flush();
>> +
>> +		/*
>> +		 * Now that the TLB is clean, drop the submitter's reference:
>> +		 * the swap cache then holds the only ones left, which is what
>> +		 * __remove_mapping() expects when the completion drops the
>> +		 * folio.  This has to happen before the write is submitted.
>> +		 */
>> +		for (p = 0; p < sio->nr_bvecs; p++) {
>> +			struct folio *folio = bvec_folio(&sio->bvecs[p]);
>> +
>> +			if (folio_test_dropbehind(folio))
>> +				folio_put(folio);
>> +		}
> Is it ok to iterate through a bvec folio and start fiddling with refrences like
> this? What if your put frees the folio, is the bv->bv_page not now a dangling
> pointer?


Here, at least the swap cache holds references on the folio, to me it 
cannot be freed, I'll check again though.


>
> Also the comment for bvec_folio() makes me worry:
>
>   * A bvec can contain non-folio memory, so this should only be called by
>   * the creator of the bvec; drivers have no business looking at the owner
>   * of the memory.  It may not even be the right interface for the caller
>   * to use as a bvec can span multiple folios.  You may be better off using
>   * something like bio_for_each_folio_all() which iterates over all folios.
>
> Can each bvec span multiple folios? Why is bio_for_each_folio_all() not right
> here?


I don't have answers for that now, I'll check. Thanks


>
>> +	}
>> +
>>   	count_vm_events(NRSWPOUT, 1);
>>   	ctx->sis->ops->submit_write(ctx);
>>   	ctx->sio = NULL;
>> diff --git a/mm/swap.h b/mm/swap.h
>> index 8679cb61268e..81114ad9e44a 100644
>> --- a/mm/swap.h
>> +++ b/mm/swap.h
>> @@ -92,6 +92,8 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>>   	return READ_ONCE(vm_swappiness);
>>   }
>>
>> +#define SWAP_WRITE_DROPBEHIND	1
>> +
>>   #ifdef CONFIG_SWAP
>>   #include <linux/swapops.h> /* for swp_offset */
>>   #include <linux/blk_types.h> /* for bio_end_io_t */
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index a02f942418d3..5435fa5111b3 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -613,6 +613,8 @@ typedef enum {
>>   	PAGE_SUCCESS,
>>   	/* folio is clean and locked */
>>   	PAGE_CLEAN,
>> +	/* folio will be freed after writeback, do not touch */
>> +	PAGE_DROPBEHIND,
> Oh god, really? Do we have to add a whole new outcome possibility for CORE
> reclaim logic just for this?
>
> Ugh man.


Dirty as hell, I agree! But this is the only way I found so that the 
folio, which may have been freed in the meantime, is not touched anymore.


>
>>   } pageout_t;
>>
>>   /*
>> @@ -659,6 +661,9 @@ static pageout_t pageout(struct swap_io_ctx *ctx, struct address_space *mapping,
>>   	else
>>   		res = swap_writeout(ctx, folio);
>>
>> +	if (res == SWAP_WRITE_DROPBEHIND)
>> +		return PAGE_DROPBEHIND;
>> +
>>   	if (res < 0)
>>   		handle_write_error(mapping, folio, res);
>>   	if (res == AOP_WRITEPAGE_ACTIVATE) {
>> @@ -1437,6 +1442,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>   					nr_pages = 1;
>>   				}
>>   				goto activate_locked;
>> +			case PAGE_DROPBEHIND:
>> +				nr_reclaimed += nr_pages;
>> +				continue;
>>   			case PAGE_SUCCESS:
>>   				if (nr_pages > 1 && !folio_test_large(folio)) {
>>   					sc->nr_scanned -= (nr_pages - 1);
>> @@ -2198,6 +2206,8 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
>>   	while (!list_empty(folio_list)) {
>>   		folio = lru_to_folio(folio_list);
>>   		list_del(&folio->lru);
>> +		if (folio_test_anon(folio))
>> +			folio_clear_dropbehind(folio);
>>   		folio_putback_lru(folio);
>>   	}
>>   	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index dc8425d6b21e..640936fe7464 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1051,17 +1051,16 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>>   	folio_set_dropbehind(folio);
>>
>>   	/*
>> -	 * Drop our reference before starting writeback so the swap cache holds
>> -	 * the only one: the drop in folio_end_writeback() needs that for
>> -	 * remove_mapping_set_shadow() to succeed, otherwise the folio is
>> -	 * handed back to reclaim instead.
>> +	 * Our reference is donated to swap_write_submit(), which drops it just
>> +	 * before submitting so the swap cache holds the only one left: the drop
>> +	 * in folio_end_writeback() needs that for remove_mapping_set_shadow()
>> +	 * to succeed, otherwise the folio is handed back to reclaim instead.
> This feels really conplicated.
>
> My instinct with this change overall, though I'm not familiar with the
> dropbehind code, is that thi


I'm sure this works as explained, but I can't argue with you it's not 
complicated, if you have any idea to make that clearer, I'm happy to try.


>
>>   	 *
>>   	 * Nothing can free the folio in the meantime: we hold the folio lock
>>   	 * until writeback starts, PG_writeback then blocks swap cache removal,
>>   	 * and folio_end_writeback() takes its own reference before clearing
>>   	 * PG_writeback and donates it to the drop.
>>   	 */
> This comment is now a comment on...? Nothing?


I still think it is an important comment so I'll "attach" it to 
__swap_writepage() below. Thanks

Thanks for the thorough review!

Alex


>
>> -	folio_put(folio);
>>
>>   	/* start writeback */
>>   	__swap_writepage(&ctx, folio);
>> --
>> 2.53.0-Meta
>>
> --
> Cheers, Lorenzo

