Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C683CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 04:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E6E8E0009; Mon,  8 Sep 2025 00:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7660B8E0001; Mon,  8 Sep 2025 00:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2C68E0009; Mon,  8 Sep 2025 00:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 566D88E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:50:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E25CD140870
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:50:18 +0000 (UTC)
X-FDA: 83864856516.18.F4E8BED
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id 202D518000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:50:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4dNwf6/w";
	spf=pass (imf06.hostedemail.com: domain of 3h2C-aAsKCI4362wAzy0v9sy66y3w.u64305CF-442Dsu2.69y@flex--lokeshgidra.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3h2C-aAsKCI4362wAzy0v9sy66y3w.u64305CF-442Dsu2.69y@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757307017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01YR2CqURkhlHCrnM5KuvdGLvZAe2bqIjaptSX7fxeg=;
	b=vNRNGDpgHEFLi81njDbq/IxWaRWFSzUbLGCRHOHux1DyMJw4CXwgJCVnFMTWmjjudWRw1M
	8hrpO4Vo+f4JU42jD8n5PvWP/yQoNeWAU1UmSy68txATT19Cp9e082E+fyqL4hkBAGkulp
	nMfzjWN4iehBm4Zj39GK66ysmK3OuzM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4dNwf6/w";
	spf=pass (imf06.hostedemail.com: domain of 3h2C-aAsKCI4362wAzy0v9sy66y3w.u64305CF-442Dsu2.69y@flex--lokeshgidra.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3h2C-aAsKCI4362wAzy0v9sy66y3w.u64305CF-442Dsu2.69y@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757307017; a=rsa-sha256;
	cv=none;
	b=ibKSVi6b25fJjJq/8C3n6le1BdhRG3irBGKG95kpW7i41ZlO1k6d3xqng72i8RIHx5NBgV
	DN+lGvuPhT40EInZqrwisZRv5umrTFIxIAvQuadeMBrcncafu1miS9hbtErsJxtEhtHfLg
	XiqovWaoEuuKjLP+p1XxYmv/k9+EDIU=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4d3ab49a66so6842924a12.3
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 21:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757307016; x=1757911816; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=01YR2CqURkhlHCrnM5KuvdGLvZAe2bqIjaptSX7fxeg=;
        b=4dNwf6/wpns4+q+t4fLti2dECvRa6YYTKFN3RvT+ocJcOf/HRTHceJgB0ys7eaef5Z
         AOOm4u9X98Lgkx8aWDVnHXxBD0369jC949mNAm1oTB9r1iuEO5EkfTzcwc/MN+z9NwFq
         5NGPDNmbMc3ZiJz46gBUD+M3y5Cw29dtR5zw0EdKz5g2ZlVJBwE9KornvKEGJPRdMw8w
         G5wxWilNKdHlplFzoeQ0HBx5G8EkT4fRFZiQRzLgbnigVUt1bEyUKNuOgk6xLAmuA9z7
         rBb4P8QGexaV7VoF2Vjo/K0B7SotAVIw0nBn99r1vgW3as8q0iZ2PkHmi3sMFXfKg03M
         6Veg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757307016; x=1757911816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=01YR2CqURkhlHCrnM5KuvdGLvZAe2bqIjaptSX7fxeg=;
        b=euiI1zTkLAdcsSlhPZAImbh4tPAURhm6pq6HRNLZWC5/OkCVvqBLbKV6vS1No1btAW
         1bEQvuSXVPeyYysQ+hevNUP90q7rvTf/jE3Rsche6Pdd6dEPy85FpjGmMVqPBg/o9Y5a
         lIYhNIkwuML0/So9swSRZ5yfk8Qf0/8baMl+EOgy2MAyv+QSVo/TPbv7IoiPnYZKwadN
         G7sGM+Fs7TMK+CwfflaaNN0rNHV0I6al5IXqqAwzSabf9fc2LD9X+SBi1IjhJoi1rX72
         F2IOvofatQ3bgNZAu3bR/igjmG+DwAxep6xDS/vIJPiqKc6rTNixybmo60WLJQhs8Cw1
         bglg==
X-Gm-Message-State: AOJu0YyvBPe2TkOjn68EXOGvD7DBgQ8H1uZ8PdK9GTuGhdKhRxfBQNWB
	fxh7/wsSS/hBA3HUL9w1GtbimtjEtn7HPpMRDoz+Jitmykmr1zwC6gWG8ZmlSPw1h5M+5xOW6mk
	QxSz8Cb7DpikvHZqPHcPSGH6IUw==
X-Google-Smtp-Source: AGHT+IHa209QkvD2E9KcyUrPHUrxCGRHz1zr7Z3+I3J39cIRe0Dhjbq3FKgWt2EW/LsTSWaXvJzW2MlJFHGZueixbA==
X-Received: from pfbdr10.prod.google.com ([2002:a05:6a00:4a8a:b0:772:45:ada8])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3c8f:b0:248:f4c3:b31e with SMTP id adf61e73a8af0-2534441f670mr10455752637.33.1757307015908;
 Sun, 07 Sep 2025 21:50:15 -0700 (PDT)
Date: Sun,  7 Sep 2025 21:49:50 -0700
In-Reply-To: <20250908044950.311548-1-lokeshgidra@google.com>
Mime-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
X-Mailer: git-send-email 2.51.0.355.g5224444f11-goog
Message-ID: <20250908044950.311548-2-lokeshgidra@google.com>
Subject: [RFC PATCH 2/2] userfaultfd: remove anon-vma lock for moving folios
 in MOVE ioctl
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	Lokesh Gidra <lokeshgidra@google.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7u6ubimhd3zwttxic6p33unehhprdzx8
X-Rspam-User: 
X-Rspamd-Queue-Id: 202D518000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1757307016-655344
X-HE-Meta: U2FsdGVkX1/qFBWb9f05FFnbYSRpMGyUrxYGj16AG7JFxwGwPM9kULZ/2BJPB8bJgAL0BvL6uEJOCwbQBm2wef3WWQ1vER16qJAPRsRZ+EUADNPTuxa4UEJXUCX0tV4JUT7JRPFH4wsoHbkpk/BEKM2+K1RVDuhUw3wT+QzPq8IUkm0dCquijBrZ/5VXUErbEpfkacdGBUWmYJo/6VIG903Cs66FkxrK4k2sIyqc2F7x7vDm2oPsv6xTAV8HOiozucVsSMt4gHXUJdFYIKB/IpySjca05+wzfxt3muNqdP/GNuSlbSRuI61KU1YkNc2kH2jWlx2j6zIjj0UH052zr+ioWy7eN5fzT+KI3rmZo7R4BArhb3ep3iXDVlZWzJa1Q8ZXXXsfWClZvRlQQ8EXg6wwhael2hCPV6V2VdKUPSf83SLSF18o1jDCu5X7mGlqDA5xX3BoFfW8ORz1MArAgkFuuUPMD+F2FTmbBegG5LrEqCYfHbhQdNjOGnK20fxHWNu1LIyXOj3ipwEUpniCdPJlnVZzXqvIxlL9DAi9K4mTjqgVWuTPsR2Ci4YPrmpb0pdUcl+CDiUHFGcwY459QyHX/ZE3ocAr+evCwGUAzr6cuI5JMu5BPq3ejbM0Tlj32Qg/4EnT/atBTRPbB8K5sYZ5skppjfYXdaQ30IM8JnSImbzx1ivwu0hhNJJUWd7Nl10UvGOGT7FlEOhXAFIpR2F5j7E1vTPTReUYuSgBKndiIuKp2g9i+ojUQrgB45lbaXZXu+lShqB+FdsZSltrnuAFfeZRaNavnWLwSPBZ9lihB/Q7YtmoBzR+4QO9ffnnJOqzBgi6UY1Z2dGQuJg1BIDgKxKLQsN73x1Eh2XyOAn8ZBvL96woC803gAJH9KjWHJ72o0J4X8Pe4yp4e0QmTN37eJZPT+Rg+sV3D8jbViGtU/ykbLOYhtXR91ZdumHftv6ME43qTQ+TdYZrayn
 1U2VhTjp
 N17QCRYy7GEGSX1AXNv7OekwR7qIC+nZz+GDnaj1VdzCxj5F+4NLFiDXKVTG3DgOBdrwrycFX1vMAN96QqZ1VQS2kKceGrVww0TZRy46cWPbdx6RJSFmNyS94FBEdANEPpDtc+sS512YA0B1Wu62tO0o6kPlS1pFHFO5LM9OdtpE8vGVt7TAqwoW32E+3xvL7ub6dBU+z749aLtV4Humxc8PqmNrpqrmwDCTGNUO1beheLStlkLsL9XQcySvomJZXucr5dpAe/6TwVGNPJ/nfzNNWNEibz6sdGPextJ1QKbO0n59oVCJTrueMjXSCYjLwXdhmJUWyPrUrDICxjHx0ci72jWaYQRyB38l+gjWRTbLEnriRpMPyfQfAe0XrS4SUjiM5aJDrmpFspjzabgZ6h0vbySw1kRNm+0z4V/8Wmn36F3jjSI98T/nsnwSvUHrjyBoZAHlfJdGVK5DHqO3Rnwv5cRXxHxu11pSbXJoU3MKsgbGGawGKaBVk9Stuzxuzde3b6By9W2NNJoihwNEKB1ujAC5dkdxhjtg8Wn/zsDfMMhoKrRgvcnWes0sWPDurmmQej9+qgzszhfPkBkBshW812vs5+lvHL/9m6f4QyVxJWuDX7j08Q8ps3oG5ABc2OPf+4AqpmzKR4e9fPb7JJCfv7j09EB4VMP7ZVoacB04OnbzIbYGg6GxOew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since rmap_walk() is now always called on locked anon folios, we don't
have to serialize on anon_vma lock when updating folio->mapping.

This helps avoid contention on src anon_vma when multiple threads are
simultaneously moving distinct pages from the same src vma.

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
index 26cedfcd7418..5cd3957f92d4 100644
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
index 50aaa8dcd24c..1a36760a36c7 100644
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
 
@@ -1516,10 +1489,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	}
 
 out:
-	if (src_anon_vma) {
-		anon_vma_unlock_write(src_anon_vma);
-		put_anon_vma(src_anon_vma);
-	}
 	if (src_folio) {
 		folio_unlock(src_folio);
 		folio_put(src_folio);
@@ -1793,15 +1762,6 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
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
2.51.0.355.g5224444f11-goog


