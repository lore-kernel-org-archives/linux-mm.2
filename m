Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD1D606D82D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ctivv3Mq
Received: by kanga.kvack.org (Postfix)
	id AF8936B05B9; Thu,  5 Nov 2026 08:23:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFE76B05BC; Thu,  5 Nov 2026 08:23:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C6E6B05BD; Thu,  5 Nov 2026 08:23:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4706B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:23:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBC4CA0A03
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:23:07 +0000 (UTC)
X-FDA: 85401131214.18.CB3F0EE
Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9E0E320008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:23:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ctivv3Mq;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zh22YFNTcCHiUEzZGKdpmex1nn80VuR77bgSMkmuY98=;
	b=k3ZhpqTNMj85nYeaf/++Ex/7udSw8Y2sd5uslLrBgh7awheCWw6iBAPn7BwZbnIzJIRYUR
	QTJg3PI9+Cx/kty6k2lmACAPb53W8eatnMNgERqoMfm6Q+MW284vIaPwkCGCB3fnerrLGn
	qFog0QAjOchChjVnDs4+Jiq9i2NwNos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884985;
	b=cKTLoQzxgSTmC7c4Wz9pRvR7CLbW8IOCbxetStKuX299k1/PCyfQJkTmgdfAOo3KqU+JaJ
	w96sYX3rrN0csWZXGcG2oE8f934o9gLcg0vbjdQFFubrmuDxigYHNKY+8hqjCnO7+coisN
	J0HH+AlFZr8a2yf4jDl+twYKhj1jWtE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ctivv3Mq;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QBfD3euoOAyBl9/iW0ZdDnIB6ewWJVoLmTJxoE+3xEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793884984; v=1; x=1794489784;
 b=Ctivv3MqLQ4XnJ94Sj9gsOzisWtJAH4/DiB9quX/uiOO9cHAIQB5FABRKLGAujlhwA67zQGY
 P1IYf8kMSPqCpUXaEb8crOi0Igh7hb+Qx0dSNuydc2XZq/PhTD7W0CVvqAdtZ3yHgg0drHHOPVT
 Va+QrsaRaDC7WOPU+0o4qJqA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3da0c8e7b0babbc2;
	Thu, 05 Nov 2026 13:23:03 +0000
X-Mizu-Trace-ID: 3da0c8e7b0babbc2
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: lance.yang@linux.dev,
	baohua@kernel.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	qi.zheng@linux.dev,
	pfalcato@suse.de,
	ayushr@modal.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio sizes
Date: Thu,  5 Nov 2026 21:22:58 +0800
Message-ID: <20261105132258.99528-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <8ebb182b-8a01-4d32-8c76-7e4bd9e54ddb@kernel.org>
References: <8ebb182b-8a01-4d32-8c76-7e4bd9e54ddb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: m13m1nso158jhc3ih3temr6dq7on9aky
X-Rspamd-Queue-Id: 9E0E320008
X-Rspam-User: 
X-HE-Tag: 1793884985-137037
X-HE-Meta: U2FsdGVkX18gX39sjtXI2GibFCNAAI0Zn4IiyecyCUbCSH2jaVoNF6LcZuVz8GMoc/UZg/+cqXLoAZl/qlAFBKcagQoJD/J/jIZugv8VroJbwXmuUcsgi8eOM2RLABr557hDq+NgyHbD9mzadf8jt8F5EQWlE9+CS4wFrO/zKCBJcewQnOoDukmCloH3sTVFfOqQFuL88jjYj3URI4so3JlNC4R/Ygm636mz91PR6rytBGBRQT70Cqm5eJBCAFTYx9/rUvydRgcOwyGab10nzQsYmdXI6bC8ynOBEZ/y7SwTRsbg9XQS4EAuwMTh8xnVmTKXduLRr+c71JYiLNohFB+aKiKEVhrW6v6QjSuh8dZ+bJp/UUEbEvwiYoX3BCArNtyGK/oKFTk3VWdUu+aek5/r+kuIB7e1hmQURjGpjwHYO9LBwXzQb635jM5Gr0qOgjkFgheCK8hQu1+E/F1OqY8yqjosqY8VrMDgq3QYg6o4va4eL/nV51Z+Dr2EIBm1E/5br+PsxHMHUTjTyDs1EDCemPQqwvMI8rrLyxiIKH9fOBE6ht/c9RV1g6IwHzWixZ8tbtLkxDLA87kj2sOjoG77z56AAyOWGP6LjDo3m9y4bOPMb9HW/BPLb72F+6l0+0UHBgMnSGSgl2ES7u0qwajGKatQjWYT7vbkc7inkVmBc5jKjPY+AMZPiFLBNrt+OG1UhI8+haGf4T8ZikB/bPzritr1bLZRMLJklnw2/cRwEly2c+YXRHEl9/k1kYz+txaLA4/7z8FYMSyC6XtBb3kN1xahS98jHXZ2Qnl/+Ip/C9AB/vg6bNEmzsVpF86l/fkUFKttQ6O/1G4kkanqHh1xBxXbW6JkykRNjjSxVCm6S5W3GblWd9Fg1spafHDmr9cyIHOPG7aVFvBjPjxjapegBhja8NtKnvm0XPwtaoiBCAj8kbLypHl3UVyhQpmeEthYI9nSx4/u/BYbRMM
 0/sFsk8v
 LG/Q2ayobaaMUFPFVnouh+j/t0vdtDTlP+iDIYm+WXRs0CcPYb/A+yNl3Dj+F5v+SoMTZ252BrEC4Ts+/v+qjyNpP6Jy5H3z3JTKgVJ5O0NgFtJItMzdf8gLeWCFogRhmJiWJrLDO+ooEjqsAKmdY+oLu9AxGpACV052P2933MMREpkUsAYHnAx45VBRoqTC1vKu2b8PHvFswk7Ep9cPVGy7DySYpcPKhyc3alzlVhncr4P7OPFLZN3Yxc/UkbgkVnko2Zj/IQV4F4tbgpBcuJgXP/LsZ2jySghRX2sG1GsgPy3CuaJyBTYmTdbfiefggjg4HG+YX9kBknblA4F1Zj7etVVH/+AcBPw7z7DXt5WUIU7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 11:06:29AM +0100, David Hildenbrand (Arm) wrote:
>On 11/5/26 10:00, Baolin Wang wrote:
>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>> 
>> On 11/5/26 1:48 PM, Lance Yang wrote:
>>>
>>>
>>> On 2026/11/5 12:54, Lance Yang wrote:
>>>>
>>>>
>>>> Good catch!
>>>>
>>>>
>>>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>>>> PTE table can be reclaimed, so those extra checks can skip synchronization
>>>> that the caller explicitly asked for ;)
>>>
>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>
>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>>> hit the same race there?
>> 
>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which is used
>> to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set, it means the
>> caller can tolerate some racy checks.
>> 
>> For this case, I think we should set TTU_SYNC unconditionally in
>> shrink_folio_list(). Barry, what do you think?
>
>That makes sense. I hope this doesn't throw a big wrench into our reclaim
>performance numbers.
>
>Can someone benchmark this?
>
>But maybe we should really follow-up with the folio-size based optimization in
>sync_with_folio_pmd_zap(), where we only need a memory barrier (and sufficient
>documentation why something that cannot be PMD-mapped can get away cheaper).

Dug into the history a bit :D

TTU_SYNC goes back to Hugh's THP splitting fix [1]. A racing zap could
clear the PTE/PMD before updating mapcount, so the walker could skip the
lock and return before the accounting caught up.

Barry later enabled it for large-folio reclaim [2], to avoid skipping
temporarily cleared PTEs and ending up with a partially unmapped folio.
He mentioned that small folios had the same race, but with just one PTE,
they couldn't be partially unmapped. That's where the large-folio check
in shrink_folio_list() came from.

Then PTE table reclaim [3] added another way to end up with an empty PMD,
even for a folio that can't be PMD-mapped. The truncation fix [4] moved
the rmap flush before the PMD clear and extended synchronization in
zap_pmd_range() to cover those folios too.

Looking back at the truncation discussion [5], you also pointed out that
page_vma_mapped_walk() needed checking, and suggested a possible
folio-size based optimization in the helper.

[1] https://lore.kernel.org/all/c1e95853-8bcd-d8fd-55fa-e7f2488e78f@google.com/
[2] https://lore.kernel.org/all/20240306095219.71086-1-21cnbao@gmail.com/
[3] https://lore.kernel.org/all/92aba2b319a734913f18ba41e7d86a265f0b84e2.1733305182.git.zhengqi.arch@bytedance.com/
[4] https://lore.kernel.org/all/14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com/
[5] https://lore.kernel.org/all/08a0907f-8e3a-4071-a2e4-fd1411c446f3@kernel.org/

So, how about starting with order-0 folios?

---8<---
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c726..d01fe8282417 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -872,6 +872,8 @@ struct page_vma_mapped_walk {
 	spinlock_t *ptl;
 	unsigned int flags;
 	bool pgoff_is_anon : 1;
+	/* Set from the folio, not the number of pages being walked. */
+	bool folio_is_order0 : 1;
 };

 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -883,6 +885,7 @@ struct page_vma_mapped_walk {
 		.address = _address,					\
 		.flags = _flags,					\
 		.pgoff_is_anon = folio_test_anon(_folio),		\
+		.folio_is_order0 = !folio_test_large(_folio),	\
 	}

 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/internal.h b/mm/internal.h
index 9b8864a8540a..e70869b38292 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -592,21 +592,29 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
  * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
  * @mm: The mm_struct.
  * @pmdp: Pointer to the pmd that was found to be pmd_none().
+ * @order0: True if the target is known to be an order-0 folio.
  *
- * When we find a pmd_none() while unmapping a folio without holding the PTL,
- * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
- * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
- * for the table have been removed, but nothing orders the pmd_none() read
- * against later mapcount reads. Skipping the PMD without synchronization
- * could make folio unmapping code assume that unmapping failed.
+ * An empty PMD does not guarantee that a later mapcount read sees the
+ * completed rmap updates. For PMD-mapped folios, zap_huge_pmd() clears
+ * the PMD before updating mapcount, so we must wait for the PMD lock.
  *
- * Wait for concurrent zapping to complete by grabbing the PTL.
+ * Order-0 folios cannot be PMD-mapped. Their fully ordered
+ * atomic_add_negative() updates mapcount before PTE table reclaim clears
+ * the PMD. The PTE lock preserves this ordering if another CPU reclaims
+ * the table. A read barrier therefore suffices for order-0 folios.
+ * Keep taking the PMD lock for all other folios.
  */
-static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
+static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp,
+					   bool order0)
 {
-	spinlock_t *ptl = pmd_lock(mm, pmdp);
+	if (order0) {
+		/* Order the PMD read before subsequent mapcount reads. */
+		smp_rmb();
+	} else {
+		spinlock_t *ptl = pmd_lock(mm, pmdp);

-	spin_unlock(ptl);
+		spin_unlock(ptl);
+	}
 }

 struct zap_details;
diff --git a/mm/memory.c b/mm/memory.c
index 44376321180b..8955d1cd31b0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2112,7 +2112,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 			/* fall through */
 		} else if (pmd_none(*pmd)) {
 			if (details && details->single_folio)
-				sync_with_folio_pmd_zap(tlb->mm, pmd);
+				sync_with_folio_pmd_zap(tlb->mm, pmd,
+							!folio_test_large(details->single_folio));
 			addr = next;
 			continue;
 		}
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e6b6170c2f4f..36881f8fd45e 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -293,11 +293,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			if ((pvmw->flags & PVMW_SYNC) &&
-			    thp_vma_suitable_order(vma, pvmw->address,
-						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR))
-				sync_with_folio_pmd_zap(mm, pvmw->pmd);
+			if (pvmw->flags & PVMW_SYNC)
+				sync_with_folio_pmd_zap(mm, pvmw->pmd,
+							pvmw->folio_is_order0);

 			goto next_pmd;
 		}
@@ -379,6 +377,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
 		.nr_pages = 1,
 		.vma = vma,
 		.flags = PVMW_SYNC,
+		.folio_is_order0 = !folio_test_large(folio),
 	};

 	if (folio_test_anon(folio))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7db6be53f3a9..79cfa9bc475b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1434,26 +1434,17 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * processes. Try to unmap it here.
 		 */
 		if (folio_mapped(folio)) {
-			enum ttu_flags flags = TTU_BATCH_FLUSH;
+			enum ttu_flags flags = TTU_BATCH_FLUSH | TTU_SYNC;
 			bool was_swapbacked = folio_test_swapbacked(folio);

 			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
+
 			/*
-			 * Without TTU_SYNC, try_to_unmap will only begin to
-			 * hold PTL from the first present PTE within a large
-			 * folio. Some initial PTEs might be skipped due to
-			 * races with parallel PTE writes in which PTEs can be
-			 * cleared temporarily before being written new present
-			 * values. This will lead to a large folio is still
-			 * mapped while some subpages have been partially
-			 * unmapped after try_to_unmap; TTU_SYNC helps
-			 * try_to_unmap acquire PTL from the first PTE,
-			 * eliminating the influence of temporary PTE values.
+			 * Synchronize with concurrent rmap updates before checking
+			 * folio_mapped(). Also avoid skipping temporarily cleared
+			 * PTEs, which could leave a large folio partially mapped.
 			 */
-			if (folio_test_large(folio))
-				flags |= TTU_SYNC;
-
 			try_to_unmap(folio, flags);
 			if (folio_mapped(folio)) {
 				stat->nr_unmap_fail += nr_pages;
--

atomic_add_negative() provides full ordering for mapcount updates. With
243cf1f67b36, rmap removal completes before clearing PMD, including when
another CPU reclaims an empty table under PTE lock. So smp_rmb() is enough
here, without an extra writer-side barrier.

nr_pages == 1 isn't enough to identify an order-0 folio, since
page_mapped_in_vma() also checks individual pages of large folios.

We can then enable TTU_SYNC for order-0 reclaim and use smp_rmb() on an
empty PMD, while keeping PMD locking for large folios. 

(Haven't benchmarked it yet) ...

Cheers, Lance

