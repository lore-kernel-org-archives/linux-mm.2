Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86CBBC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 01:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6130D6B008C; Wed, 19 Aug 2026 21:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C44F6B0092; Wed, 19 Aug 2026 21:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3BB6B0095; Wed, 19 Aug 2026 21:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17C5A6B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:52:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8A84A33BC
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:52:12 +0000 (UTC)
X-FDA: 85119972504.05.40A16CB
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6D9C620002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:52:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GsADzSfk;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787190731;
	b=hJJEK5NbpZA8LR+3MtoGPOUgBCpr8Yr/hchn11PtDS6pC5SecrLTUaA3IHP7fP4FWURFCn
	ivYG+S4vOWm2ja1U0Cqqbj72MhJsAjG3q7/9mY40BFt9WByq1uRR2Mugc5H3ie9GurQ66c
	/bj6UXg9jai+r8bcaX69Nhixu3pJPA8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GsADzSfk;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787190731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVu8SbPzt7/dSva3YZ9XkqmI4phhhFSkD/CIXqb94tE=;
	b=5ZQhi+alQZF0x46WIu7nSS3AVqBoT2V9gnyik4pyjeU8HEfEMpqYzsG8mgPtrcJ+oOjgGU
	4dhlFfW1BbK+lgTuXPMtygWWe9DRBMbhpMJNDCTpIq7p5ypugl+9HA6Wt4DE9n49Z5g6SR
	eWyItotvKfPGUgvKxqfU3EfTOlyQS8s=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787190726; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qVu8SbPzt7/dSva3YZ9XkqmI4phhhFSkD/CIXqb94tE=;
	b=GsADzSfkkj0bL7+T9sSwx540jLvTIHB92scbAI7pvGZcCajKB8UN5PU37Hawf4MD8BBGJsUs/rsXGV1ci5whE8Hokzoijg5ku68P9TQNHlGK5A7h9E/yRV2aTwk38QaZj3oTTVhGHTcAwp+bbW12ZMQat+TTr2z44Am5uqaVVOI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9HoXSS_1787190723;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9HoXSS_1787190723 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 09:52:03 +0800
Message-ID: <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com>
Date: Thu, 20 Aug 2026 09:52:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm/mglru: fix potential generation folio number leak
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6D9C620002
X-Stat-Signature: g1cdd16my6eybosijq59i99aukwfa9qi
X-HE-Tag: 1787190729-876721
X-HE-Meta: U2FsdGVkX181sXFOUg/hTLwpCA+ZXWQAuQko5FRbWmcr337qRzjxLvfEn6VIFWrQ5/k66DiiVCfTEGVshsmhS0J1mBvKW3r0jXwuOsNgH00Fp2xzGKOwbTuHOl/4W04qj0dl/pB51X16TAZ9nslvYs3vZhyNbluR5axPhorSOhsHCY4GEuIr3GQPQHxpVzankkAACfJI9/ypWTWoD0JBP6YjyPrq9MQ0Z55yclH1/7gWZUpgCAWC3zF3lHhbvX95PHbczN1EB0K3l0+Cwy57hj2IkNMSCLQt/eaB0cwZ63or6s4XjlzYV/4N9uYAh9+dDYj1LgA+5G2uoco2RBAeLO6JoOMt958HyM9sYIun0QwpIHvYJvHroaGM/OkBOnbat282aSItg97EYVH1JqVfEA1L5kXn636J+yKT5dun8QmcUvsflcjwpPiiQ/H25tDResCOyXfCOo3h2S0TVPnRuqRVxHBqssI5bXEZ7McGFM9DIxSlDeVQUk3ePKSeTJ/DFZFFvHDF1nkzrKkpVnGSOW7yz2/Lz95EgSkAlkfVKrEpUf1FvNhoZhCblLSBSWJ0L8mECr4FZYSnlmjZC3XtUkIHpwMVg/lWaaEkQBqmSgmDHKk0wI/tSYqP9djj5Md7DHzX2A+lX8R7i8vF8mnrW5CGGAhZ1w01v0NXH33gcNE40hXo/Lp8N+tM5l3plnaSdO2tnLYYM91iQTILRhQYuJfYbRlKqueLrpfgPQJLdojvMJE7ersoGTVT2Xuh8ipxbKaPx4O9/ukbfXFg4RNn0uGPnHjzMw4t9/wauZYdR5MXo72Ai9lG1IFMw7NPucXtQQiVZI+dgvsjBJ8i2mMCd7iXn3ImvFAGaoyyfrw5nyvoFuxoB3IzLPl4o9H6rThdRv6PpYMSeTXDlVx+tLFpl1k15VT6aONKQwabjFKGFVKWTlahNChbHzCgAHRmF4Ez/ESFyZgixSHNB/nY+0D
 qzPolKgo
 6TnPIeYmJCS9KEhF61hxGimLAsPXb9UftTlSQwXURbkLDH6iMwWGiqV5j+uMVdcFwaPNUwP7aR1fQd+Qi8cY20foN0NW6/VbOnad9ms43oFLMgwidTU7h/71x+WgEmzFTqFpOXhaSW27WuYxZudrxa+N6kc4WTHy4dlWnnKdvfuwuKIW9a7L/6HzmPeOsAuif7hdjW9QpV/St327bxwPZuSIBethTyF1g1q0xkmbtuSrm5AtA8kY0IceyP+wpfOOpBohj+AgnxGWf5aInF1cbYqAnT1o4pmFWO6oncvvoaDsgJuN9bTBPyoySC1aCcUtKiUe30nz73dYOD2wqwLVSj6yBtEUl8wFPFUeDG/wQRZupZ0CB6KMzJjpcGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Each generation of MGLRU accounts anon and file folio numbers
> separately. The page table walker's update_batch_size() derives the
> anon / file type of a folio from its current flags, but the page table
> walk holds neither the lruvec lock nor the folio lock, so the type can
> change during that period.

Right.

> MADV_FREE's lazyfree path clears PG_swapbacked under the lruvec lock,
> so the folio is no longer considered on the anon LRU list. Lazyfreed
> folios can also be changed back to the anon list again. If the flip
> lands between folio_update_gen()'s cmpxchg and the type read in
> update_batch_size(), the batched delta pair is applied to the wrong
> type. The anon and file generation counters then carry phantom deltas
> that nothing reconciles, permanently skewing lrugen->nr_pages and the
> reclaim budgets derived from it.

But I think the problem occurs between update_batch_size() and 
sort_folio(). update_batch_size() only updates the anon or file folio 
statistics, while sort_folio() moves promoted folios to the 
corresponding type's list:

/* promoted */
if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
	list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
	return true;
}

If the folio's anon/file type changes between these two steps (e.g., a 
lazyfree folio), it would lead to what you described: "The anon and file 
generation counters then carry phantom deltas that nothing reconciles, 
permanently skewing lrugen->nr_pages and the reclaim budgets derived 
from it."

If you agree that this is where the problem lies, I don't see a good way 
to fix it, since the state of a lazyfree folio can change between 
update_batch_size() and sort_folio().

A simple approach would be to skip checking the access flag for lazyfree 
folios during the page table walk, and let shrink_folio_list() 
reactivate accessed lazyfree folios instead. What do you think?

> Fix it by capturing the type from the flags snapshot the cmpxchg
> linearized against: folio_update_gen() returns the type of the state
> it transitioned from, and update_batch_size() accounts with it instead
> of re-reading the live flags. The batched deltas then always match the
> type of the state the cmpxchg transitioned from.
> 
> Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h |  7 ++++++-
>   mm/vmscan.c               | 13 +++++++------
>   2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index df62daaa2ee7..4bb390d9516e 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -10,6 +10,11 @@
>   #include <linux/userfaultfd_k.h>
>   #include <linux/leafops.h>
>   
> +static inline int folio_flags_is_file_lru(const unsigned long *flags)
> +{
> +	return !test_bit(PG_swapbacked, flags);
> +}
> +
>   /**
>    * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
>    * @folio: The folio to test.
> @@ -27,7 +32,7 @@
>    */
>   static inline int folio_is_file_lru(const struct folio *folio)
>   {
> -	return !folio_test_swapbacked(folio);
> +	return folio_flags_is_file_lru(const_folio_flags(folio, 0));
>   }
>   
>   static __always_inline void __update_lru_size(struct lruvec *lruvec,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a613bb8d7271..7169cac60869 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
>    ******************************************************************************/
>   
>   /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
> +static int folio_update_gen(struct folio *folio, int new_gen, int *is_file,
> +			    const vma_flags_t *vma_flags)
>   {
>   	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>   	int old_gen;
> @@ -3298,6 +3299,7 @@ static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t
>   		new_flags |= BIT(PG_workingset);
>   	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>   
> +	*is_file = folio_flags_is_file_lru(&old_flags);
>   	return old_gen;
>   }
>   
> @@ -3328,9 +3330,8 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
>   }
>   
>   static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
> -			      int old_gen, int new_gen)
> +			      int old_gen, int new_gen, int type)
>   {
> -	int type = folio_is_file_lru(folio);
>   	int zone = folio_zonenum(folio);
>   	int delta = folio_nr_pages(folio);
>   
> @@ -3519,7 +3520,7 @@ static bool suitable_to_scan(int total, int young)
>   static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
>   			      struct lruvec *lruvec, struct folio *folio, bool dirty)
>   {
> -	int new_gen, old_gen;
> +	int new_gen, old_gen, file;
>   
>   	if (!folio)
>   		return;
> @@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struc
>   		folio_mark_dirty(folio);
>   
>   	if (walk) {
> -		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
> +		old_gen = folio_update_gen(folio, new_gen, &file, &vma->flags);
>   		if (old_gen >= 0 && old_gen != new_gen)
> -			update_batch_size(walk, folio, old_gen, new_gen);
> +			update_batch_size(walk, folio, old_gen, new_gen, file);
>   	} else if (lru_gen_set_refs(folio, &vma->flags)) {
>   		old_gen = folio_lru_gen(folio);
>   		if (old_gen >= 0 && old_gen != new_gen)
> 


