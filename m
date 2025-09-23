Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CCFCCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC7A8E000F; Tue, 23 Sep 2025 03:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D278E0001; Tue, 23 Sep 2025 03:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A8D8E000F; Tue, 23 Sep 2025 03:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 405068E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:10:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 147501DF05E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:10:41 +0000 (UTC)
X-FDA: 83919642282.12.B3BDE21
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6439D40004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:10:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PonrAqPV;
	spf=pass (imf12.hostedemail.com: domain of 37UfSaAsKCBQ584yC102xBu08805y.w86527EH-664Fuw4.8B0@flex--lokeshgidra.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37UfSaAsKCBQ584yC102xBu08805y.w86527EH-664Fuw4.8B0@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758611439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3nUZrrHqnOwtuRjcCouc4i7eyGnswidSaXfkl4Gbx0=;
	b=GQHis+KHpo+C70il955zx9yHuCkfmghPuqyy2PSQJUqbIrUx4iFSRKbEr494RyO/BMZjxG
	GKGedvKs4rBUGTMVmZNdyXWfTpvf5kQpYlfq2TePzD027LCKMpF0nSXNLQjf1JusNCiMW6
	1kjBFtLiOkkPe6W52Smu8q0yCvCuhbo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PonrAqPV;
	spf=pass (imf12.hostedemail.com: domain of 37UfSaAsKCBQ584yC102xBu08805y.w86527EH-664Fuw4.8B0@flex--lokeshgidra.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37UfSaAsKCBQ584yC102xBu08805y.w86527EH-664Fuw4.8B0@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758611439; a=rsa-sha256;
	cv=none;
	b=DQN/dUJDX5/fK1L1GlN8I3OYY0FpvqaIcaa3Ql7YzhbhL00OSLRNH46X8S5yowNnSg5tTW
	8CoieeaU4DW6Zpm3gtvmUuPm8OrS03GEvgXmFBzjgebSfij/QgnkSNAzb2a4+3zcWKC/Pu
	Lyh/7W42xfru+t3NjMylWcPRap/evUQ=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-268149e1c28so60984565ad.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758611437; x=1759216237; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m3nUZrrHqnOwtuRjcCouc4i7eyGnswidSaXfkl4Gbx0=;
        b=PonrAqPVBh1f/+leTK5nwWEcPbGp/Ler6DHBgu8/pAcM5CG7Cf1ZsMQm826nLhU2wO
         yTH/Oi8qQubOhpNpg2wPkBZ4Yx5XPyZxaNYxfNbn9LnVHEjd2zMkXOuJLje+nWRyZaP4
         mD9xFxlrR2VKk8FHgikIB/LznFKmsDKTYUQrAnl/dr20TM98vxGr0TaaJLY2fMpc57nx
         Svi66k1GHU5/9KvgiiZYiPAiBXazxd4ev1c6jGXQdFaCZmi+/VbDfWZWDQAlWRqW2R6/
         Ui3KQqdJAKYNcvLFq8IXWcu9IpqYMh+YZcLCDPaOtQ3qX9XbnMoiIEC1IJznCol3utb+
         AQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758611437; x=1759216237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m3nUZrrHqnOwtuRjcCouc4i7eyGnswidSaXfkl4Gbx0=;
        b=SMc5SO9jymcZsB6lTr8PSA2egQwEiiVTnfFR96hy+/LXzecxZ8nW9tVJWDdoE8b6Iw
         4ejSY/Nn6V6NqLtWjdhGSr4TiExR6qrAqoHN1kmgmjezgvEksLfu+DnIGvEBUQiqxZ3M
         qtNXoNcsMn/c7wdzWwjj8G14mD6nuH39O60MQq+scENWcB4YriWK/P3k8CQEn99hlwg5
         WiV1rVFJg48imGaDOcCsRbw50xnLIU65aqDITfMdCLuFH5EiI1G/JPE0ARWMt/QP1LdD
         eHJmcgwEBJ0q8kMKzT+Pj3P8p1pKY3QiqAcSUpUiwnZbbSynBEnlBNiiZLNLZdXeeOUB
         Ztmw==
X-Gm-Message-State: AOJu0YzhFyZ3SqgDiBqmeEZ+zQwnMzcUKdeRMWQln9AgKLdAPPuEnn6x
	4OXIQwcCpxWLNNvta1JqHhLkCmb0V0Pr3DVlyKbE9paK9VViTRnYF/MmM0PDMiG3LYRYRwb0ml4
	T2M88pv9ARCxFAY29Y2izY+DEZA==
X-Google-Smtp-Source: AGHT+IHQWSpTWDoe0n0S/Kt0MZpXySmfxM+6Z/OJmOywt3KuU99LkdmOORFp94oq09e9cGboEGHO0klq7YY/RmDokA==
X-Received: from pldv20.prod.google.com ([2002:a17:902:ca94:b0:24b:66a:7448])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2b10:b0:235:e8da:8d1 with SMTP id d9443c01a7336-27cc0fa7f36mr19537265ad.8.1758611437297;
 Tue, 23 Sep 2025 00:10:37 -0700 (PDT)
Date: Tue, 23 Sep 2025 00:10:19 -0700
In-Reply-To: <20250923071019.775806-1-lokeshgidra@google.com>
Mime-Version: 1.0
References: <20250923071019.775806-1-lokeshgidra@google.com>
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250923071019.775806-3-lokeshgidra@google.com>
Subject: [PATCH v2 2/2] mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	jannh@google.com, Lokesh Gidra <lokeshgidra@google.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mhqgpptng83s8iuzf17o4k6cy7sot841
X-Rspam-User: 
X-Rspamd-Queue-Id: 6439D40004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758611438-638387
X-HE-Meta: U2FsdGVkX18bdGu7rYZQKou94brnUfBNMvOmsYMuiYYoMQrkNuw0RcZ9WdhypbQSiwcvISTRgmDK40zqnHFxe9jefaBVKBwQMQJBTmFbrdhP9llJvDiuSQ+aObjTZ/y74GY99RQVFCGkG+M4b4h1fogSNLbAyq1zmDTirMmZIElTY635kLeo4vWOgOI6EAiyLJ9TEygdh+cguMBZQUkyMA5Vo+sHGDEYvYB7AIr5+sFw6qqayGTXALCZxx92lwhN7FqaKudLHETQdK2IgkZBg5LmWxsTY7SMptyut78zGqBJ/f3oDWQmQPfH1VgN3O3gWJztDLMoVYzdLFrxV9w+H+bA8Hg5OuoTp8IYQqoMFN40m6hoGNgPakRCpSl3w2N+GJRu/f9ET2oI5h/WzcRdtIbeXKdjozQtHfmootCz5ypG4WKg1MtZlYX3W8B2J9dAj417+gaURLNORVeXjxyKS1TyMoPBAtdDzXoUB8XPIjrX9GMNnvsttjumUqWPZgNXRlIl0xH9yjmSFNTQDMCTPo69X1DptqX/p0w0YD8L4eb+6zYXm6FGmt2fnkLnxj2tyn8xEie5wK7+OK+WHszifOwwB7qnXbp1nj+j5voQon/mVnBmHirpY2RrPz3pC+395BntfW3U2F372Dmx/HfnxgmDkhJ7Rnxpnd7dPlhWpzOjEwAm5ID+wzBaeUd45lLEEqtO+xG0Zma2lU1ODOsdbmFRrFgT9FwH2yI6DNYO52f+L121RkhlNCkpb366f/GiNP5jGt6Yr4sypqz6RMUz36lQ2E6uOQJeQ3P1/rx5cTqBfyF8Zceuu8QKBbfuuMgu9xL1ERf/hTLmVxbwRTqy8mPQJzGnUck6RN1R3/ebprwszT55+/qr/KHtiha0m8OMqhPsu3vo3dCabHdi41xDx5fZ2aD/VT+NFrMfJWVj14Mgnqpw3hUtR9/7Lpu23EHdGPPRRA88rFe3u39nn4u
 bwe2KhS0
 z4/M4ljtWZ8DHDtSd7OLHuzn5Ujvv2GC9gRmDOzMwYofvLtUe63e/bu9yTJbZSMztvpRpLoRrRYLcGz1Dp5XhkSn2iD1AEEYgVIqXLeWj1pd1adHeGitwrMqf17MuuXF8C04pkrD+ZmDgEKHBpR/6WPJV7503Gi+6RuPkn0djELsig8Xi/SCJOYgkePkveMJCmSozzFAJseVrBVz70MWGWXkehp6xiY27TdkHE9w1hhaJ+25TBNBIdNnFur0o2G2dCn0vNBvVAuDj3LIOnqO/40+ruvpmDwm8C1r8JePdwlhAjxDDoa1VeqRbtHyQCy82GbvbUE9gWWd8Ce0vRByGz6kL6C4OcgeVT4wfHORv1qnRpiL9XectHmVELcOJqbRcIZ1jxuCTwsiIl520LZyTGkuRTI6UidIqfFRCx7JFqGW+EIZWGDqgQFAh64N62jx68L/gY+rzY+iK6uB0VdcgJLLZT5bWrVGTDQaVHK18SJYyRe8YJ40tDK+pjVkM2PCDVW31IEkupQVczKx2ql96IMfpFiMMtdN/7cgbUzuMn/EZTblZNcmmNsFRB0TiFvJQI8kh6ZdNL0ETSMDePTvRVpaAvbe8hP82t7rmgOnCF+1TwWp7tVohxnU7GlEZS/rX1jftrbIZ1A2LEux2/yA4ldDMqLCtbd9lhgzlWnpdE5utZW1vFtLFNm7MDgZd4m/7hxj/wu0Z+NcZs7RGbVFEwcIPuX/+k1rXX3KE
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
rmap_walk() as used by folio_referenced() and others who call it on
unlocked non-KSM anon folios, and therefore the anon_vma lock is no
longer required.

Note that this handling is now the same as for other
folio_move_anon_rmap() users that also do not hold the anon_vma lock --
namely COW reuse handling (do_wp_page()->wp_can_reuse_anon_folio(),
do_huge_pmd_wp_page(), and hugetlb_wp()). These users never required the
anon_vma lock as they are only moving the anon VMA closer to the anon_vma
leaf of the VMA, for example, from an anon_vma root to a leaf of that root.
rmap walks were always able to tolerate that scenario.

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
index 1b81680b4225..a16e3778b544 100644
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
2.51.0.534.gc79095c0ca-goog


