Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358DA606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nPv5bnBp
Received: by kanga.kvack.org (Postfix)
	id 47AEA6B070D; Tue, 27 Oct 2026 08:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453726B070E; Tue, 27 Oct 2026 08:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369146B070F; Tue, 27 Oct 2026 08:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 194E46B070D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:50:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD72D809AF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:50:49 +0000 (UTC)
X-FDA: 85368390618.26.51343F1
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf20.hostedemail.com (Postfix) with ESMTP id 43BBF1C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:50:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nPv5bnBp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793105447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ki1DP5OhpeVVGgytP6sTrVXQsGKeGWZHq3HMgm8Yio=;
	b=15wCVf7Suf0ukG+sb/vjdh/L69nnz5T8vqVYMpYiAJRQ6tr1RjJlKs5j/0NTTuywrxTX8f
	V1tyHXCLPEiXjgCDHRO9uyE06zEo0x5EqbNvuZaqnyK1ysDYrlmUdSDVBQ514bkmlnPtQR
	dPlaex22/ODxaaMvd/GhfYU8O6BCkh8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nPv5bnBp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793105447;
	b=3HBT5QnHsLLXmioGvouNxfCeR9e+W+6eyeekF6+spRfQopGj3c9ELwwK96y6qhEcmR+foF
	GdePcz2VVBjpVpuxDENG5/+vweW4ulFNnvMrjS8n/7Xg241mzsicFxqgMYaGOCYbh42Z3J
	GqegYPXUu8D1rKDH1G3jOemAblwJx0c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793105441; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2ki1DP5OhpeVVGgytP6sTrVXQsGKeGWZHq3HMgm8Yio=;
	b=nPv5bnBpU3MTWDNOuD8kVVxjbSQGmyyU3S4KtBcrUdtH6z8w9yOBQ3kQn5DY+z38GW0lTrhxRmP0x3lcK8ymwfjoTfOh2TnGEHquRJJKmU7rRhDA4IXkvkETI4gz+T+HSEonM7FGd9g46yswlzsUXh3QEUXmEmie3T1ETch40x4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDdu1Jp_1793105440;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDdu1Jp_1793105440 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 20:50:40 +0800
Message-ID: <f41d0720-ca14-4aa3-a2e4-3ba2de3280d0@linux.alibaba.com>
Date: Tue, 27 Oct 2026 20:50:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <d7f009c90b11ded86654885b5ebcb8c9308fa31a.1793067441.git.baolin.wang@linux.alibaba.com>
 <2ba579e8-06fb-41f5-9eb2-f02b2aabe29b@kernel.org>
 <87e32afd-75de-4407-8f0c-fb70b40d5eca@linux.alibaba.com>
 <81ee2c92-f342-4f7f-aacd-d9558e67a980@kernel.org>
 <de0b41fb-4ae2-46a5-afe0-c021134ebba0@linux.alibaba.com>
 <4880d4ff-8486-4e22-9923-bd4f2407b1cb@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <4880d4ff-8486-4e22-9923-bd4f2407b1cb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43BBF1C0004
X-Stat-Signature: bm815csectebquc5as9ekg86ud6or5nf
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793105445-499681
X-HE-Meta: U2FsdGVkX1+wfvylVBhW4xkvZXNSYvvSYzr0RaYx7zhOTst5wg+6InfiYz8gdxQZehv5x1dts+V3sKwkAmxBj2qZE4/iepBjevktLl2GbCmOVqhGE8X0TVskHAV+j5X2JXzxCL4eo8kuqfzD1V4Dw8i9HDpaO3jkDdIxMEXRnB38zktKlVnURbJgcfYK1wmSL+gk6I1B6k9YUUS+O06i3OscZybJv+zkaYnPDkeZWTJYyUOnR+18V5c4zDRooIgVc3aJ8uVR5ZwuxOrEo3i4oeDO63Sl0wSISZ7GFmlKKnoCHsMgIX/2IySngffrvPbj9H18MvyIFY8RZYlCxxa2blF99KpAEbx4ph4KyrmHMrYGRYjra48h3edelBIJf/lOFqHepz+fAS3LcP7TopaFJY+u/z2rain81ostwzo4Los3fOmVqQH4KIbBxL9UjQEvSKUBHIu1KwWCyB9TkNLLmoFFGLTmliEn0rctVjktqvuBLVgfQ6gSJe1iobcN42Z6DIaRhRJr92cTn5v1Jytp8H9zt/WS81gxpW8VQFCjgXyIo6hjJ4FwYR5tY4XHU/yMkaK6RGWNiTzgoXlLTwwO5mwLM4/pZTQfmg48fHtSFe2quqKOemcG56xjT74jZqpGHkaBmg+HHgOlI6uyS+MVnbK5tpMFQ9Kz0ti162XzZ1yPVrCA+7o1a6cb124r6VXfQHZdgvBMDRbHmjSW+tkT6cCMmynY9v7uHIBNYLWIXVpr/FwutvgbFTvtM8JcGvfAST4uTVSQI7OrJNBU8NxLrNxizp6yaGlFg8BtyymVEEgKtxFMSrsgYwAQ8qW96ygm9VzOeWzQE2hp/Y5YcB4Zw3qDMUCvtFnvzigu3olg2GpGtUc/fRq/ajQAcK56YOZVB1DnlVOGGmK+wRpzd1AkBMo+5UUtJoVqSPThx39HfiKMEZ6ao1JW9NUZVj622UTRyLk1fTUL0v0CgCPfGQz
 51azFifF
 8UbTamLTxwabUu8jkfDIEAcpIFQdxyo731Tuck9TiSAl1RAHbbV/kKLAf8uTWEjfxb53teHZuBhDS+OMjEXwmWVItArNN+IGRZNG+ozCjD/nM34eGFm64PVxm8p4bs/C0rNe6WiazOzaff55j+vUN/Qs4r6bEmMf/ToEM7vqpGpJrQ4Fb9lCReSglBwoql5956RrVnkCuX8+aUoOzEeDnsB2So3ONh1wYd5sZEn8RDlmc5cN/a3t6UYNUW+QVi4sTIAHWSS/QdbehvltHnMmCILls74KfHwEZWbLhp7AxqGlvKeVs9J6k+EobfyAoPzicVxmTX3B6yunC+waj9JJP/DKcCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 6:55 PM, David Hildenbrand (Arm) wrote:
> On 10/27/26 11:35, Baolin Wang wrote:
>>
>>
>> On 10/27/26 5:33 PM, David Hildenbrand (Arm) wrote:
>>> On 10/27/26 10:03, Baolin Wang wrote:
>>>>
>>>>
>>>>
>>>> No, keeping two pmd_none() checks cannot fix the race, as I replied before. [1]
>>>>
>>>
>>> Best to wait to submit new versions if there are open discussions? Because now
>>> we have the same discussion in two places.
>>
>> Sure.
>>
>>>
>>> I think you're right about the race, the issue is that we check for
>>> pmd_is_huge(), not pmd_present() which confused me.
>>>
>>> Clearest to me would be to not drop the second pmd_none() check but move it
>>> where it belongs: if splitting zapped the PMD.
>>>
>>> @@ -2101,13 +2104,15 @@ static inline unsigned long zap_pmd_range(struct
>>> mmu_gather *tlb,
>>>                                   addr = next;
>>>                                   continue;
>>>                           }
>>> +                       /* We already synchronized with concurrent zapping. */
>>> +                       if (pmd_none(*pmd)) {
>>> +                               addr = next;
>>> +                               continue;
>>> +                       }
>>>                           /* fall through */
>>> -               } else if (details && details->single_folio &&
>>> -                          folio_test_pmd_mappable(details->single_folio) &&
>>> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>>> -                       sync_with_folio_pmd_zap(tlb->mm, pmd);
>>> -               }
>>> -               if (pmd_none(*pmd)) {
>>> +               } else if (pmd_none(*pmd)) {
>>> +                       if (details && details->single_folio)
>>> +                               sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>                           addr = next;
>>>                           continue;
>>>                   }
>>
>> IMHO, I'm not a big fan of adding two pmd_none() checks just to avoid an
>> uncommon concurrent sync.
> 
> It's what we already had. We had to: one for handling pmd_none() directly and
> one for handling zapping while splitting (file THPs).
> 
> We just managed to let the second also handle the final piece of the former.
> 
> Anyhow, let's get this fixed.
> 
> If you think the code is clearer your way (where I disagree)

Fair enough. Though I have a different taste, I'd still like to make the 
maintainer happy. I'll send out v6 tomorrow following your suggestion.

But could you help check the following whole diff to avoid any 
unnecessary misunderstandings? (I don't want to give Andrew more trouble 
:)). Thanks.

diff --git a/mm/internal.h b/mm/internal.h
index b1b0f29d2216..ffb8eaec90e3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -584,14 +584,16 @@ void free_pgtables(struct mmu_gather *tlb, struct 
unmap_desc *desc);
  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);

  /**
- * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
+ * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
   * @mm: The mm_struct.
   * @pmdp: Pointer to the pmd that was found to be pmd_none().
   *
   * When we find a pmd_none() while unmapping a folio without holding 
the PTL,
- * zap_huge_pmd() may have cleared the PMD but not yet modified the 
folio to
- * indicate that it's unmapped. Skipping the PMD without 
synchronization could
- * make folio unmapping code assume that unmapping failed.
+ * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
+ * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
+ * for the table have been removed, but nothing orders the pmd_none() read
+ * against later mapcount reads. Skipping the PMD without synchronization
+ * could make folio unmapping code assume that unmapping failed.
   *
   * Wait for concurrent zapping to complete by grabbing the PTL.
   */
diff --git a/mm/memory.c b/mm/memory.c
index e911e63ba1ed..e0fef107a022 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct 
mmu_gather *tlb,
                 }
         } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);

+       add_mm_rss_vec(mm, rss);
+       lazy_mmu_mode_disable();
+
+       /* Do the actual TLB flush before dropping ptl */
+       if (force_flush) {
+               tlb_flush_mmu_tlbonly(tlb);
+               tlb_flush_rmaps(tlb, vma);
+       }
+
         /*
          * Fast path: try to hold the pmd lock and unmap the PTE page.
          *
@@ -2043,18 +2052,12 @@ static unsigned long zap_pte_range(struct 
mmu_gather *tlb,
          * to hold the pmd lock failed, then we need to recheck all pte 
entries
          * to ensure they are still none, thereby preventing the pte 
entries
          * from being repopulated by another thread.
+        *
+        * Clear the PMD after the rmaps for the table have been 
removed, in case
+        * an incorrect mapcount is observed after unmapping the folio.
          */
         if (can_reclaim_pt && direct_reclaim && addr == end)
                 direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, 
&pmdval);
-
-       add_mm_rss_vec(mm, rss);
-       lazy_mmu_mode_disable();
-
-       /* Do the actual TLB flush before dropping ptl */
-       if (force_flush) {
-               tlb_flush_mmu_tlbonly(tlb);
-               tlb_flush_rmaps(tlb, vma);
-       }
         pte_unmap_unlock(start_pte, ptl);

         /*
@@ -2101,13 +2104,15 @@ static inline unsigned long zap_pmd_range(struct 
mmu_gather *tlb,
                                 addr = next;
                                 continue;
                         }
+                       /* We already synchronized with concurrent 
zapping. */
+                       if (pmd_none(*pmd)) {
+                               addr = next;
+                               continue;
+                       }
                         /* fall through */
-               } else if (details && details->single_folio &&
-                          folio_test_pmd_mappable(details->single_folio) &&
-                          next - addr == HPAGE_PMD_SIZE && 
pmd_none(*pmd)) {
-                       sync_with_folio_pmd_zap(tlb->mm, pmd);
-               }
-               if (pmd_none(*pmd)) {
+               } else if (pmd_none(*pmd)) {
+                       if (details && details->single_folio)
+                               sync_with_folio_pmd_zap(tlb->mm, pmd);
                         addr = next;
                         continue;
                 }

