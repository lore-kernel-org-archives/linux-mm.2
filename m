Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D77CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0401C8E00B7; Thu, 18 Sep 2025 01:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32528E0093; Thu, 18 Sep 2025 01:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E216D8E00B7; Thu, 18 Sep 2025 01:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB9428E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:52:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D8661DFBF4
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:52:29 +0000 (UTC)
X-FDA: 83901301218.12.601F206
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id C753320008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:52:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V2rXqPXC;
	spf=pass (imf13.hostedemail.com: domain of 3Gp7LaAsKCNE8B71F4350Ex3BB381.zB985AHK-997Ixz7.BE3@flex--lokeshgidra.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Gp7LaAsKCNE8B71F4350Ex3BB381.zB985AHK-997Ixz7.BE3@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758174747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTE7lJIO/UOmjwb/mBSmuXLueEhoKKMY9pJxQCFV6J4=;
	b=liWu7BwQfWR6s7SkIfdKe5VekE/jJscsi9VaHQT7mAAAF7zssym4KFGCcaaWqXvcEFZdaY
	gvhof6NliAnkNlQJFLWQke3pOOCSTnrJIqieq392+MZV3kPqp2YIyUG81NZviitiA+39tq
	eAyyfYWqYHHz+bPoeXetA4ZVtNvMV+s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V2rXqPXC;
	spf=pass (imf13.hostedemail.com: domain of 3Gp7LaAsKCNE8B71F4350Ex3BB381.zB985AHK-997Ixz7.BE3@flex--lokeshgidra.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Gp7LaAsKCNE8B71F4350Ex3BB381.zB985AHK-997Ixz7.BE3@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758174747; a=rsa-sha256;
	cv=none;
	b=xOcR6Cs78awaZ8wUAzbu/21SNOOcptGd5VZL+we5NTKujJxQygo2lGnM3B/nTXceln+v+X
	dRSl/tfN4KYZaLuxB5rZCpBRALtIJG508RGCj+yujXYPdl9DRem19j0OZ/0Gm2YjCAnb+H
	q81lC4eQJfq+/UqjIUYOxDCPscLQKw4=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b550514936fso293910a12.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758174746; x=1758779546; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UTE7lJIO/UOmjwb/mBSmuXLueEhoKKMY9pJxQCFV6J4=;
        b=V2rXqPXCKd1hQPZVPtO8Qcx8TDicYD30mEMN9DrX3YLYow8kGTW9S24rI/n0FsRKKL
         cdTQUVIEBHlHWI0RMPSxwEG+udR66nTEm2HYhJ+wGF0aS8mm08oeX1rkvfkoI+PHSJNK
         7i4vNwsn/WeaAIGzOt74IBXML0DiWk7+ckC/bMJTJTU1GlgNTCMlg+6b+jnf6iFrB4v4
         qRjnU0BaSDtvlazoVQmsVrKgZk1iWPOS8Di60Jg2Av5z/5k1amH6vty46NFyQXpfXZX6
         7ZNpaPkzkcPTGpee1fOP+1W5mzrftF2AzTVSv3n6eLtNwjQrOFzjDizb0y8DuAbbh5Ma
         IPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758174746; x=1758779546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTE7lJIO/UOmjwb/mBSmuXLueEhoKKMY9pJxQCFV6J4=;
        b=KOzxmzuPcTEVLnACnlfh0Fs7+dVKJ2VpazrZODufhRTFBeXxXfC+1CW5qFWWJKcOxz
         kZlZv0zwzMVx4PLCgvUU+0Qp0araEtBt4nCKVpV4w4qQzffGqti429eMPG1ige7sr5/c
         2AaNlN/c+mRfLm4pXp6tJW+GoIwA/QaKr8C4vr6lzmZAYOR7mtblLhUUUVTQ78JA0w9n
         E8CX0N744qyu9YB+5CXaRuyo0LjtpLykBrQuQwmlujOGtheU79jytQw1hathL769B+QV
         k5TQhhnxgctFo9WtmFqCAGInYoPLUUZK4+3CFWI2dMwZklhATyEg/D9NUmN+2EH+M9Ln
         xc5A==
X-Gm-Message-State: AOJu0YysrEkvkHvVp/dQ7RdVT87LIrtECOCovlFzol35XXhuvsBwMAmX
	j/cc/Fqe6GJeyJ/BZH5rKEx7n3D25v5I7bHfJ4Mafw1YPZB5fBdkCxTD85/Rbq44vlWQdzPy1jz
	EXz8MTa9+bWgNWZP6RquOuURrVQ==
X-Google-Smtp-Source: AGHT+IHtxSoI/YJwTDIb9+nDI28UNoAfsvFW3vGxQj4nAJJjQDWHiWC6TdfuxAfsaPXt7aCn6pD6zIsBpHrX4TMdgA==
X-Received: from pluo8.prod.google.com ([2002:a17:903:4b08:b0:24c:b370:db43])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:22c9:b0:265:bb0:cbc with SMTP id d9443c01a7336-26813be8919mr66822715ad.47.1758174746709;
 Wed, 17 Sep 2025 22:52:26 -0700 (PDT)
Date: Wed, 17 Sep 2025 22:51:35 -0700
In-Reply-To: <20250918055135.2881413-1-lokeshgidra@google.com>
Mime-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918055135.2881413-3-lokeshgidra@google.com>
Subject: [PATCH 2/2] mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	jannh@google.com, Lokesh Gidra <lokeshgidra@google.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3tjzr8s4uyeun7kfrehtz8qkoh531bms
X-Rspam-User: 
X-Rspamd-Queue-Id: C753320008
X-Rspamd-Server: rspam04
X-HE-Tag: 1758174747-885301
X-HE-Meta: U2FsdGVkX18Mc9LGA/etmJYC7QqjjSHo1S31ZUovoCuNFvoweWuvgc8yjL5HwpjB/VYikBuvEq90VweikQWxYc5V0vgOw4/O9u7rJQwai7YhDtliR32Bbhjxsybt/Xwi+kc5ZoE+10r1NRNKvfA9+AbM2ecpC3CJJXr18WHl6a5X+Iv2c67myEI5YoRMJrqJvR9w9bOPKSoOYfpgjVI7I933a6CoX/W/b+PEXPXSlgILQHJHCg9D90UpSETzpsh4EysODmAdU3u3/kXLMnhsfKa+x2xZue3+yXRoYblxgmvSyILJ2i0C0DaBlJB+TiFjAz2DTPJTLG7l+UMVtk52ikc2bHSTk5MBrJieBLQsQZuEhfAy2zc1qQxoncgNUCt8S6kBX2Mxx8bMDlsT1vcYf9BTuxTIc7B1T5a4tbejZtK/okeMYYv6sh9q8DdU+Agn/zig5NolxvB5pUJDOWkEtiYrmlxvY/JT/PJnDSYvysElfaYHZCd+PI6zqaiWAbk06kY59tCPYiknTdKFLA3xS3dOPwUi9J0TDYKzGvQhNtKyM7VVOWXPwbByZmWwardFYywLg9EKUcWHnDzENdfDn+N3hOVlcXw85Bix7PW+9mzBkSosT7wIIfhuizsma+diwuVdD9eGI3wNdAalHU38fiEZ2mY34yFV9Fx+2s6dH/4VZTcBQzsnaqXZ9ARqPU0dWdHI8BvdS2tbAftavv+uLj9lDCRCKWon4a+nKJTKlOCfo/v9v5bWRbjpPYHA8puKL1b60fOxxRAK2zP9VtXywwXEBKRhEErFCm15gpOaUB73NR4LAuG3qzFZvKeDKbzQrGD8WMWRiwz+qcrLgQCeUJekABCJb7M9Syd0LE8XEbplDbM3Rk1YypJLRSTRC7TjKqxWKTvEl6rqtOxgkVcH9cIdV4edXBr8l2sknMl87mInSnuvDfjiZPfbglA4hJauuWWqRPl6hAY/2oiqc+A
 9OPrACIJ
 ByHTSNdQtU4vXRdt5eTTmNzJJl3TIvU6VISw9Us8YshLdP1zExC3mkP6ka/mvdIN13lV2P8WPh8w99t7yRa64L8tR/bHXwrv7G90MqKIbBwTx9OVlNrsJ9rB4ft5GBvRmqaWL0PBawwLfGt+L1lJzByFDVotT5FznvTDztLdrJpvhPw9NU+fBIzJETwa3xkwBzUajilpyU2vpNvOzs9xI4QOg/zBolUQ/CfGpBtrRuKwm6gEdTXdhZ/Q2v0wgFJ9iWBe5sHrucuL23VuU+FZDqd4RIlxDmy74nb9ZwHLtMHjPkDtQc2iEHZjuOCDFT5aYimfM/6FpjSKgeRgVKvP+mK/Bny5VXQROW2y/83nhbSCaajiC5d8acnGNYOBbxLRnd7GHjChyYs3POUGLjoWRwA4yXxTEtYksapzWpG9ceIKVGDuZYG4EhLxmdZ/5Vnzy26jPPa0Yu5c5IEE0gg7ZvdcDTNVQV2XOuSgDemF34vGkGQoEQRW6FktibIvisxmKSvkez1xj6Arq9zhyz7wBRi7wDYk+SOgZyUoOmQZjXZG6QmOliVtJ2vRU1xZfat5Ykrda37vizHsL7T+c1jerYipeH/izpbbNOmk34A/15mCkESOIZrpJglMHbCw1eFPrJ68QIqnGz3kTE27iwzs5jOa2Z9wXWSfKf1z09dlzX5cisPgFzoLuklKDhJSMlp1U8xFN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that rmap_walk() is guaranteed to be called with the folio lock
held, we can stop serializing on the src VMA anon_vma lock when moving
an exclusive folio from a src VMA to a dst VMA in UFFDIO_MOVE ioctl.

When moving a folio, we modify folio->mapping through
folio_move_anon_rmap() and adjust folio->index accordingly. Doing that
while we could have concurrent RMAP walks would be dangerous. Therefore,
to avoid that, we had to acquire anon_vma of src VMA in write-mode. That
meant that when multiple threads called UFFDIO_MOVE concurrently on
distinct pages of the same src VMA, they would serialize on it, hurting
scalability.

In addition to avoiding the scalability bottleneck, this patch also
simplifies the complicated lock dance that UFFDIO_MOVE has to go through
between RCU, folio-lock, ptl, and anon_vma.

folio_move_anon_rmap() already enforces that the folio is locked. So
when we have the folio locked we can no longer race with concurrent
rmap_walk() as used by folio_referenced() and hence the anon_vma lock
is no longer required.

Note that this handling is now the same as for other
folio_move_anon_rmap() users that also do not hold the anon_vma lock --
namely COW reuse handling. These users never required the anon_vma lock
as they are only moving the anon VMA closer to the anon_vma leaf of the
VMA, for example, from an anon_vma root to a leaf of that root. rmap
walks were always able to tolerate that scenario.

CC: David Hildenbrand <david@redhat.com>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Peter Xu <peterx@redhat.com>
CC: Suren Baghdasaryan <surenb@google.com>
CC: Barry Song <baohua@kernel.org>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
---
 mm/huge_memory.c | 22 +----------------
 mm/userfaultfd.c | 62 +++++++++---------------------------------------
 2 files changed, 12 insertions(+), 72 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5acca24bbabb..f444c142a8be 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2533,7 +2533,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	pmd_t _dst_pmd, src_pmdval;
 	struct page *src_page;
 	struct folio *src_folio;
-	struct anon_vma *src_anon_vma;
 	spinlock_t *src_ptl, *dst_ptl;
 	pgtable_t src_pgtable;
 	struct mmu_notifier_range range;
@@ -2582,23 +2581,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 				src_addr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
-	if (src_folio) {
+	if (src_folio)
 		folio_lock(src_folio);
 
-		/*
-		 * split_huge_page walks the anon_vma chain without the page
-		 * lock. Serialize against it with the anon_vma lock, the page
-		 * lock is not enough.
-		 */
-		src_anon_vma = folio_get_anon_vma(src_folio);
-		if (!src_anon_vma) {
-			err = -EAGAIN;
-			goto unlock_folio;
-		}
-		anon_vma_lock_write(src_anon_vma);
-	} else
-		src_anon_vma = NULL;
-
 	dst_ptl = pmd_lockptr(mm, dst_pmd);
 	double_pt_lock(src_ptl, dst_ptl);
 	if (unlikely(!pmd_same(*src_pmd, src_pmdval) ||
@@ -2643,11 +2628,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
 unlock_ptls:
 	double_pt_unlock(src_ptl, dst_ptl);
-	if (src_anon_vma) {
-		anon_vma_unlock_write(src_anon_vma);
-		put_anon_vma(src_anon_vma);
-	}
-unlock_folio:
 	/* unblock rmap walks */
 	if (src_folio)
 		folio_unlock(src_folio);
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index af61b95c89e4..6be65089085e 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1035,8 +1035,7 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
  */
 static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
 						 unsigned long src_addr,
-						 pte_t *src_pte, pte_t *dst_pte,
-						 struct anon_vma *src_anon_vma)
+						 pte_t *src_pte, pte_t *dst_pte)
 {
 	pte_t orig_dst_pte, orig_src_pte;
 	struct folio *folio;
@@ -1052,8 +1051,7 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
 	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
 	if (!folio || !folio_trylock(folio))
 		return NULL;
-	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
-	    folio_anon_vma(folio) != src_anon_vma) {
+	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
 		folio_unlock(folio);
 		return NULL;
 	}
@@ -1061,9 +1059,8 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
 }
 
 /*
- * Moves src folios to dst in a batch as long as they share the same
- * anon_vma as the first folio, are not large, and can successfully
- * take the lock via folio_trylock().
+ * Moves src folios to dst in a batch as long as they are not large, and can
+ * successfully take the lock via folio_trylock().
  */
 static long move_present_ptes(struct mm_struct *mm,
 			      struct vm_area_struct *dst_vma,
@@ -1073,8 +1070,7 @@ static long move_present_ptes(struct mm_struct *mm,
 			      pte_t orig_dst_pte, pte_t orig_src_pte,
 			      pmd_t *dst_pmd, pmd_t dst_pmdval,
 			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
-			      struct folio **first_src_folio, unsigned long len,
-			      struct anon_vma *src_anon_vma)
+			      struct folio **first_src_folio, unsigned long len)
 {
 	int err = 0;
 	struct folio *src_folio = *first_src_folio;
@@ -1132,8 +1128,8 @@ static long move_present_ptes(struct mm_struct *mm,
 		src_pte++;
 
 		folio_unlock(src_folio);
-		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
-							dst_pte, src_anon_vma);
+		src_folio = check_ptes_for_batched_move(src_vma, src_addr,
+							src_pte, dst_pte);
 		if (!src_folio)
 			break;
 	}
@@ -1263,7 +1259,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	pmd_t dummy_pmdval;
 	pmd_t dst_pmdval;
 	struct folio *src_folio = NULL;
-	struct anon_vma *src_anon_vma = NULL;
 	struct mmu_notifier_range range;
 	long ret = 0;
 
@@ -1347,9 +1342,9 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		}
 
 		/*
-		 * Pin and lock both source folio and anon_vma. Since we are in
-		 * RCU read section, we can't block, so on contention have to
-		 * unmap the ptes, obtain the lock and retry.
+		 * Pin and lock source folio. Since we are in RCU read section,
+		 * we can't block, so on contention have to unmap the ptes,
+		 * obtain the lock and retry.
 		 */
 		if (!src_folio) {
 			struct folio *folio;
@@ -1423,33 +1418,11 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 			goto retry;
 		}
 
-		if (!src_anon_vma) {
-			/*
-			 * folio_referenced walks the anon_vma chain
-			 * without the folio lock. Serialize against it with
-			 * the anon_vma lock, the folio lock is not enough.
-			 */
-			src_anon_vma = folio_get_anon_vma(src_folio);
-			if (!src_anon_vma) {
-				/* page was unmapped from under us */
-				ret = -EAGAIN;
-				goto out;
-			}
-			if (!anon_vma_trylock_write(src_anon_vma)) {
-				pte_unmap(src_pte);
-				pte_unmap(dst_pte);
-				src_pte = dst_pte = NULL;
-				/* now we can block and wait */
-				anon_vma_lock_write(src_anon_vma);
-				goto retry;
-			}
-		}
-
 		ret = move_present_ptes(mm, dst_vma, src_vma,
 					dst_addr, src_addr, dst_pte, src_pte,
 					orig_dst_pte, orig_src_pte, dst_pmd,
 					dst_pmdval, dst_ptl, src_ptl, &src_folio,
-					len, src_anon_vma);
+					len);
 	} else {
 		struct folio *folio = NULL;
 
@@ -1515,10 +1488,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	}
 
 out:
-	if (src_anon_vma) {
-		anon_vma_unlock_write(src_anon_vma);
-		put_anon_vma(src_anon_vma);
-	}
 	if (src_folio) {
 		folio_unlock(src_folio);
 		folio_put(src_folio);
@@ -1792,15 +1761,6 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
  * virtual regions without knowing if there are transparent hugepage
  * in the regions or not, but preventing the risk of having to split
  * the hugepmd during the remap.
- *
- * If there's any rmap walk that is taking the anon_vma locks without
- * first obtaining the folio lock (the only current instance is
- * folio_referenced), they will have to verify if the folio->mapping
- * has changed after taking the anon_vma lock. If it changed they
- * should release the lock and retry obtaining a new anon_vma, because
- * it means the anon_vma was changed by move_pages() before the lock
- * could be obtained. This is the only additional complexity added to
- * the rmap code to provide this anonymous page remapping functionality.
  */
 ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 		   unsigned long src_start, unsigned long len, __u64 mode)
-- 
2.51.0.384.g4c02a37b29-goog


