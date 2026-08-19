Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F20FC5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6E96B0092; Wed, 19 Aug 2026 12:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56CD6B0093; Wed, 19 Aug 2026 12:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C716B0095; Wed, 19 Aug 2026 12:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0EDB6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:32:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C95180347
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:32:39 +0000 (UTC)
X-FDA: 85118562438.02.C2AFF43
Received: from mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	by imf09.hostedemail.com (Postfix) with ESMTP id C8736140003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:32:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kauuV0qv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787157157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVf9kZHC2vP/Q5JzpuKDJBCYmkPvlYjBfOky0SRaL3s=;
	b=2lt+m4g99kgeTVbog/HV12hBDChpXyu5WltPX6UdYsVEvL3IrIS0l1S3n8Zt0shqT2nBLa
	8KiizEfeBsZYMNdHojqquZuBTw/ST2S1akCz0YJPeebTQTZzWBtQ0XFfEKqct8qmQjBZX2
	Lf62sxiaV1PYqewcQzSzdJ2snxXhqQ4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kauuV0qv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787157157;
	b=TuVT668W3MnxXkRGYYS9Iyat2QhqhJdZa10E5aq0neCnEbv7veGwz7WFhXV1m3NNIQsdc0
	oa6zW679v7EI+bZDSzQqehnftfNiVzHAgnYaAI7p8wXyna8gZQ5GfdNpZK+HW6DodRv2mf
	IyL8oSNrxcCNT85xVU+F1Bv/33nFnpo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zxkoUC4bgxUtiTO0LYujsc/ZDtFLJGnt/5/oXxFaLqo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787157155; v=1; x=1787761955;
 b=kauuV0qvk+nddmk8N88Tg4r9m+tmv11v81X1/Ote7n7vArJhi78VlCePe4bCi6wipuBNmBqJ
 Oemk6UdiCpOOGRG/8KPlgCxKr3DI76E7nV60SkZfCqGckQRYxL12QATKpLoKrGCeJ776cpoqm38
 QENTxzivd8lKC/ZFizop58tQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:a428)
	by smtp.migadu.com with ESMTPS id f5385ad13ce1f56a;
	Wed, 19 Aug 2026 16:32:35 +0000
X-Mizu-Trace-ID: f5385ad13ce1f56a
X-Migadu-Flow: FLOW_OUT
Message-ID: <1d0271fc-9f60-4b7f-8b89-e82a4f7034d5@linux.dev>
Date: Wed, 19 Aug 2026 17:32:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
To: Lance Yang <lance.yang@linux.dev>, kas@kernel.org
Cc: hughd@google.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com, ziy@nvidia.com,
 nphamcs@gmail.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, stable@vger.kernel.org
References: <aoWw_iKEDLjKL2jr@thinkstation>
 <20260819161728.70270-1-lance.yang@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260819161728.70270-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C8736140003
X-Stat-Signature: xowoqtrbm94wwz4gcwwf45hi1494a39s
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787157156-127108
X-HE-Meta: U2FsdGVkX1+eY59Snw5rkm1SkTNl6dlh1jxgqA9DKuKD50L8fmpOgkgfZoCt5hZYPBfzHyB3dErf+NHTixuTMgpKhi6borA8YawAHjkXXySXhFHupvr1TQp4Jomfy+S2Tk7RpDxuzBfdF9nmspFawaOtCfOu9TnBoMc6U5Rd0fwO4K5iCb/rkfjYxEp4CGi8wFFr8Ep2Jk6VreokPZi0VieGFpz9hfQHSjml95H+IQNqTNhAhz7nAPJnu6VxxeIUmQ7RqgVdzeZZ7/UG3v+OekLicgOljqktBBwGR3VH7Aw50bCVBzbvbpMo3pvqJjsedzH3N7vbaZNF+8MCueH/4qqTaOyLqrNzdp1CsI6WOe7kvu3gQT1UiKdjSzMrXvUifsq73lUd2aysbXD9I89R7S3OR84SHtrj0ajw4nGtrOHRK7PhWTM+dfwgep4btZfudEmqUlXxJktRdTLBoX2eB4AQ2ORusgN3/MkslsKOd3so+sVSzFR7No3Bq7l0O06btjLLCfWkmvxWFYanTx6wCcCm8NCtHC6iVWp8a7v6T96vymRy1vI4NrqIDvYOjme75H4N/a3Q4BvG7JjdBzueePPStrCqclQEJML9h0HawgLX4h4LDMw1LUUH2hzfT45G8W6083wCtGpbkTuvlxDkZ54qyFU379q5yt3ZzXweYSRN/p7ILtPwoJVybwtNgIhnhRyZi/bbbLkmiKjJfXO5lcjACUttQLKbWMExPDe6JNDL0fJXY71UY29CEFYK06hx/zaDDkqUPPqSG0RQBES9l/UPoaqdT5q3nCjbVq088w5QrTaVDMwb2Ew3ygaSImSpL8UixWbSBgvbeQroEhUfIitIHA6Yw7dkgA/PS80f2n39kM1KIZjmqhXKz7tT6pBVC4PFIQoMeuWgzI3z7xBq2qBd9XfEa88eTAB1lVZokSdfXgJ8QftznDKRqSzTWY6RrdTAIwsRgnLrE6OcAX1
 ei/i9SUY
 1e3vZtwsxiaeM19ec/jLDJkY/6WmQr5gqumvkl4kt/y9u9/Np9HPNuoQrfCH7Ehx3EGfXX5m9EEjOWpd+qb97ojAdNJBr85zvKwotcAOjNXbczobq8iqSkhAeFBr3mPc+pnRDrcr9vKu+WGh/sg1LeHXQmzDI4fM5BPQdAE1PVBSpRvuBnXgoECfm8Zyl1svTer4zhIJCvlouErUtK2M2hn1/2S+EEFTeCY6FPUjjjeQdqBD2EofAjsIvXMdOecO51mJX08ik8b4oF3kFs+annHBgNys7Z9DRSd5261SroRak0LZ7BhhVOK0URrHNC3CjiUxgSbbgBQkIYGWhNWp/x1iGPGME/oFUigYb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/08/2026 17:17, Lance Yang wrote:
> 
> On Wed, Aug 19, 2026 at 03:31:40PM +0100, Kiryl Shutsemau wrote:
>> On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
> [...]
>>> ---
>>>  mm/huge_memory.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index ced400f72d43a..afbb5974bd225 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>>>  		add_mm_counter(mm, mm_counter_file(folio),
>>>  			       -HPAGE_PMD_NR);
>>>  
>>> +		if (is_present && pmd_dirty(pmdval))
>>> +			folio_mark_dirty(folio);
>>
>> Unrelated to your patch, but noticed while looking at it: we drop the rmap
>> here under the pmd lock, while the TLB flush is deferred to
>> tlb_finish_mmu(). The pte path handles this with
>> tlb_delay_rmap()/force_flush (5df397dec7c4), but there's no pmd equivalent:
>> tlb_flush_rmap_batch() only knows folio_remove_rmap_ptes(), and
>> zap_huge_pmd() uses tlb_remove_page_size(), which takes no delay_rmap.
> 
> Well spotted!
> 
>> Doesn't matter for shmem, but xfs & friends do get PMD-order folios, and
> 
> Right. pageout() cannot pass its refcount check while PMD mapping still
> holds an extra folio ref, and mmu_gather drops that ref only after TLB
> flush.
> 
>> do_set_pmd() makes the pmd dirty+writable once page_mkwrite() has run. So
>> folio_mkclean() can clean the folio while another CPU still stores through a
>> stale TLB entry -- silently lost write, no PG_dirty left behind.
> 
> Yep. Writeback can run folio_mkclean() while that ref is still held,
> though, and with rmap already gone it misses the PMD ...
> 
>> I think we need to fix this too.
> 
> +1
> 
>> Wanna give it a try?
> 
> zap_huge_pmd() only handles one PMD under PTL anyway ... how about just
> flushing before folio_remove_rmap_pmd()?
> 
> ---8<---
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index afbb5974bd22..6fb34924ef66 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2531,6 +2531,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	is_present = pmd_present(orig_pmd);
>  	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
>  	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
> +	/*
> +	 * folio_mkclean() relies on the rmap to find writable mappings.
> +	 * Flush stale TLB entries before removing it below.
> +	 */
> +	if (folio && is_present && !folio_test_anon(folio) &&
> +	    pmd_dirty(orig_pmd))
> +		tlb_flush_mmu_tlbonly(tlb);
> +
>  	if (folio)
>  		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
>  	if (has_deposit)
> ---


I am currently at below to reduce tlb flushes, but still WIP


diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index bdcc2778ac64f..60bdd6287b5a9 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -301,6 +301,12 @@ bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
  * function, except we define it before the 'struct mmu_gather'.
  */
 #define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
+/*
+ * Like tlb_delay_rmap() but without the side effect, for callers that must
+ * flush rather than delay: can another CPU still reach this mapping through a
+ * stale TLB entry once its rmap entry is gone? Not during fullmm teardown.
+ */
+#define tlb_rmap_needs_flush(tlb) (!(tlb)->fullmm)
 extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
 #endif

@@ -315,6 +321,7 @@ extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
  */
 #ifndef tlb_delay_rmap
 #define tlb_delay_rmap(tlb) (false)
+#define tlb_rmap_needs_flush(tlb) (false)
 static inline void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
 #endif

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afbb5974bd225..76d8d5cf92ee0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2493,6 +2493,33 @@ static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
        return folio && folio_test_anon(folio);
 }


+static bool pmd_zap_needs_tlb_flush(struct mmu_gather *tlb, pmd_t pmdval,
+                                   struct folio *folio, bool is_present)
+{
+       struct address_space *mapping;
+
+       if (!is_present || !pmd_dirty(pmdval) || folio_test_anon(folio))
+               return false;
+       if (!tlb_rmap_needs_flush(tlb))
+               return false;
+
+       mapping = folio_mapping(folio);
+       return mapping && mapping_can_writeback(mapping);
+}
+
 /**
  * zap_huge_pmd - Zap a huge THP which is of PMD size.
  * @tlb: The MMU gather TLB state associated with the operation.
@@ -2531,8 +2558,15 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
        is_present = pmd_present(orig_pmd);
        folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
        has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
-       if (folio)
+       if (folio) {
+               /* Flush before zap_huge_pmd_folio() drops the rmap entry. */
+               if (pmd_zap_needs_tlb_flush(tlb, orig_pmd, folio, is_present)) {
+                       tlb_flush_mmu_tlbonly(tlb);
+                       /* Re-arm: tlb_remove_page_size() needs tlb->end set. */
+                       tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+               }
                zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
+       }
        if (has_deposit)
                zap_deposited_table(mm, pmd);

> 
> Cheers, Lance
> 
>>
>>>  		if (is_present && pmd_young(pmdval) &&
>>>  		    likely(vma_has_recency(vma)))
>>>  			folio_mark_accessed(folio);
>>> -- 
>>> 2.53.0-Meta
>>>
>>
>> -- 
>>  Kiryl Shutsemau / Kirill A. Shutemov
>>


