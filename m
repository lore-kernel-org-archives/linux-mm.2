Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07326C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 19:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610B19000CA; Wed, 13 Aug 2025 15:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E83A900088; Wed, 13 Aug 2025 15:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDFB9000CA; Wed, 13 Aug 2025 15:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC5D900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:30:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC9BF82EF3
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 19:30:32 +0000 (UTC)
X-FDA: 83772725904.01.E10B3E1
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0C5634000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 19:30:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GyzCmjrp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 31eecaAsKCGQNQMGUJIKFTCIQQING.EQONKPWZ-OOMXCEM.QTI@flex--lokeshgidra.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=31eecaAsKCGQNQMGUJIKFTCIQQING.EQONKPWZ-OOMXCEM.QTI@flex--lokeshgidra.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755113431; a=rsa-sha256;
	cv=none;
	b=6n9dqO+r0aS9rad+MsNJJhmXZ7lK0uBppX2nb59zXwT+bZFY+R7jo02VbvVf7SYCqtyu4l
	InTdE2lo9sydyurTFeur9Q/tTpNWYkOC6vV1/KX1+g6tUxG2fak3g0K81pt36F7h3769kL
	QdUZ7jLKL6dJZsAG0avKJ21jsm6SoYw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GyzCmjrp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 31eecaAsKCGQNQMGUJIKFTCIQQING.EQONKPWZ-OOMXCEM.QTI@flex--lokeshgidra.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=31eecaAsKCGQNQMGUJIKFTCIQQING.EQONKPWZ-OOMXCEM.QTI@flex--lokeshgidra.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755113431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sZcZ35hsFkSj3zqo8km1ND4V+M8ktGnKBnb2TnrRjQM=;
	b=GecIZgxiS8VS+4Ej/qqjMybBiG6guXEnuRj1SNyU8+geRXOe0AMt7c4FMvujuiWN+sbVaC
	5ZN72wUcX2NZnrqfB8ihTseG2E9x2njRGq0UUCRMzPUcbKCfB+Pb7kMjGYMLvmHIT5ZkkW
	UuBuyVdjctMdGfVZoEXoq/JgZAyX1gY=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457f44a29so1294165ad.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755113430; x=1755718230; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sZcZ35hsFkSj3zqo8km1ND4V+M8ktGnKBnb2TnrRjQM=;
        b=GyzCmjrpfW3T09r3VKb1f7N3PeaVw3Gr1v8WfwWSWMAJvKbFaEVuv6m8XxR2aZC3uB
         s+L/gxoA6ba4oqV5Yv4WSBsMdMb7E5UOv1nvrOHKm7vMgJ7SIJGhwk6+ksmnejo+Bwa1
         yoVE+zTlddMgcHPDFu08GYFwBxSC5f/x6qCvr52kcYxFaTMgeGn9JqOby8HftmCcgwH4
         nbmoRW3rydELEj5Oude0gS6ZxMysrNrmUmpm5CwrQAdFC7Qqu+zkKReYg5hyGQ8qmLb+
         zIDmDWzPwKkcyFGH+nmuzHVy/MJ9ioiOdSQ6v5SFTImKCriMyO9n7F6uD/JZ/084fiTx
         HhXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755113430; x=1755718230;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sZcZ35hsFkSj3zqo8km1ND4V+M8ktGnKBnb2TnrRjQM=;
        b=IFHyKDEKUFKSUM69yI5RDPOTbCl7Ggs79/5ZYKhieGDFSCxmSK9AfA2GxaziThVeNQ
         pdPHE8T7rQlnQMtYi1ylo//qOWIKlBRBWVkvMFbmbRThY6tSBTrqQ8uSizqtdGCWoHlx
         YYedKsWm3RDt83x6Yte24IHmHQgA7mo2q1Dio+J0PK+xUZIbfP1XgVC00RAf++yrvAXN
         J1zSRg/TMp0jSa7f26qYU5A7gcpB5378WRcZ8T0yfdv6JelLgMZCAWPShS1wjdXRc3+m
         jKW8EOeY0ptMoK2b6rKoSa7tX004iNmBQnQEdYjZCdTQ0+IjrDCIpXtKcbLVz5pMidx5
         FGug==
X-Forwarded-Encrypted: i=1; AJvYcCXdojGM1/oj2qmKdGfdQC6k4VT3gMnZT95q6dLXuHpJXteWfm5ECJtMNaStEA/p7ZxCPZX552mV/A==@kvack.org
X-Gm-Message-State: AOJu0Yxe1i/0/RFPJtzUqbfeOF5l5/NZDpyKyligZdPqq62BLOZ6Kb+Y
	g47hKd7EAW2dWImT9te6jFY2nSFEHmHXbgwUCf5mmSjFqWemrVO1IUYa26yafbHayroPBR13Bow
	FbUjRI0NpKlwhJrJI3nNtAwefdg==
X-Google-Smtp-Source: AGHT+IHvMTP5xEQBg/OMjVTpxGxeF8kv6LBiqZIQTbqXJoVdRpFGliJPnJRNNa+PvIM1jFVGCeyUIr5xMASFIiykWw==
X-Received: from plei13.prod.google.com ([2002:a17:902:e48d:b0:240:25ce:3b7a])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a23:b0:242:eb33:96a0 with SMTP id d9443c01a7336-24458505212mr3626395ad.25.1755113429640;
 Wed, 13 Aug 2025 12:30:29 -0700 (PDT)
Date: Wed, 13 Aug 2025 12:30:24 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250813193024.2279805-1-lokeshgidra@google.com>
Subject: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	21cnbao@gmail.com, ngeoffray@google.com, 
	Lokesh Gidra <lokeshgidra@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Barry Song <v-songbaohua@oppo.com>, 
	David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C5634000D
X-Stat-Signature: aqqb7geo4sq6sahmn67w3mwjxg8hxwcb
X-HE-Tag: 1755113430-635634
X-HE-Meta: U2FsdGVkX19aDLBQJZCOL1Hh9htuAQFrjb0EKprGrQllrs10erzreQIWikcpfLhJWFOutMYx9NaytyCipn+NRXRE4E1phklty3ViEDoM3/t3Hh93mya/+CJGiK40p7sbIc5R9Yu1qIwbRT03ann6rJy4WwQkCzY4Hv42CdwAZVmcufPjAceWmNxco2NeR6egtXhkRKG+ObMF1rt0zHoWpMVEWlnoQ2Oawgz/XanhQXqzu9evAgDZghSV3EBHi+3tZa/azT9Txu6NpsyTLtq0keVwUkHfq1OyBx6oSch+/CECPLH+zjOJvD/W8+JJjBkjrK1fKmiIPrPPV7pFBuYTYAl6RQyIMnYFzGYfcEQWRnEOSxLxWYAf1Ut9IXScnu7oS8+7xX1Bz2MIExkPl3acQIgNhI7KX5BGz7u7EFo6+U92YAs9WBtAXUSSl+PXc+fKws+RRnq5UqwoVTzeP6FeVTQ1ZEmggM1mN9LmhrFQZwzzlGPErGdnIHTLPwOUV6UsPk8xVdRXlKrJkSr8nG+wS4CsW3Ta8tPg9Tm6VoIBuRJiVAdyDTkj18CI3VtQV3azP9b1XOiKNsNwhtFaEnHcitH18/fsL5rC9W//z3Gnms0Y5fUZ4L7P5+cVdIr2aCGaev2Tahxqpk62pD62yDzq/r2SDw+OSSQ24ubvTKLaw5kYE5roSSwO77JNQ4s+JZXIkjgn/NCcGj5l1G16k6WjL127v0R7ACUXfmSYA/xZsk7f5ukvbbiiIatsfBvsyaqK7Aq75HwSPrhowtLdzJ75s8CsbvTFrJpNd+vzYXlN2bajr62eNn4u7oY26ipAlQUQBKL3ttYj1ApaYH59LnE0gtPCo0YZoV+NCFgGiv+6vYFrdEmEfd4mNjV03DuRg/bf61llC9ELvVAvvEYaj/VLRUsC+RpW74ZpzDV77vgFBvC1jh3HqJuCEDmpnkWKwggmXffmtY5n5KytxNFop9+
 7JVUlC6i
 UIlY7+EZyu9Ux6tzMLb9wrHp7BZ5kxAnC9vvYiD8okIgeuPyUpDf/+AhGyIeNAUJfm2tBD2X0gMzEQ0PPFuFTnnOfvdt6lQlPr5ZBus4tmEs795W0WNEywEfeL7AfWjBgyrsVGpYpfENbdc+4J0eAYCh8hQ2xrU4fcYq7RwKB4kpoJ2jTGnqCIoFTRmS/ejhXQc0sc0RS4ok3Wu8/H0l+U01YyDWKdUn4vl6p2r7Gnytv8fkX7O75FSY+v8dloH0H/bZdqMGaECNnj8FsBnCUMvA00FAHTqt1CJthyGmwhPUkMWL+3u3BR6eYOYTnIe4RWGbTPYPnK5QAvT2sg9kRzycTFYt14uQmWOJ+6eNfNyDTwi2AJSXhdtNkynZBJC2FyS7g3qjxWVu09/K6IPPEQU9lGcVVCOqiRedDSX9Rr1YdgfDMzmrmv69+VT/hHZcKoVMKKKjHUjpwK8kouGgG1hBcx1EfL6TnG/seKfHcn2VzrFqY8mjaCJzxcqIE0XG0lD18rRnWlWnDzMxGgRr/zEp54TSTXnvGXEY+4PGzBhIioU5ildLYE2qydMxh55ZsNdSRHuLVgOAbU0YK81gDqRpkJ2R3LB8MCuLZGvGqYeK3cjJFXRfhicHxGhxOyET/ZSdTpRwgwWHgHJdbXHuWuvL0eUoPEusX/L/T/ASNxuMeo+H1acq7uiuphw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
for moving present pages. Mitigate this cost by opportunistically
batching present contiguous pages for TLB flushing.

Without batching, in our testing on an arm64 Android device with UFFD GC,
which uses MOVE ioctl for compaction, we observed that out of the total
time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
~20% in vm_normal_folio().

With batching, the proportion of vm_normal_folio() increases to over
70% of move_pages_pte() without any changes to vm_normal_folio().
Furthermore, time spent within move_pages_pte() is only ~20%, which
includes TLB-flush overhead.

When the GC intensive benchmark, which was used to gather the above
numbers, is run on cuttlefish (qemu android instance on x86_64), the
completion time of the benchmark went down from ~45mins to ~20mins.

Furthermore, system_server, one of the most performance critical system
processes on android, saw over 50% reduction in GC compaction time on an
arm64 android device.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
---
Chagnes since v4 [1]
- Replaced 'err' with 'ret' in move_pages_ptes(), per Barry Song
- Use pmd_addr_end() for calculating largest extent that can be
  batched under the same src and dst PTLs, per Barry Song
- Add a description comment for move_present_ptes() explaining what
  conditions are to be met by folios to be batched, per Barry Song

Changes since v3 [2]
- Fix unintialized 'step_size' warning, per Dan Carpenter
- Removed pmd_none() from check_ptes_for_batched_move(), per Peter Xu
- Removed flush_cache_range() in zero-page case, per Peter Xu
- Added comment to explain why folio reference for batched pages is not
  required, per Peter Xu
- Use MIN() in calculation of largest extent that can be batched under
  the same src and dst PTLs, per Peter Xu
- Release first folio's reference in move_present_ptes(), per Peter Xu

Changes since v2 [3]
- Addressed VM_WARN_ON failure, per Lorenzo Stoakes
- Added check to ensure all batched pages share the same anon_vma

Changes since v1 [4]
- Removed flush_tlb_batched_pending(), per Barry Song
- Unified single and multi page case, per Barry Song

[1] https://lore.kernel.org/all/20250810062912.1096815-1-lokeshgidra@google.com/
[2] https://lore.kernel.org/all/20250807103902.2242717-1-lokeshgidra@google.com/
[3] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@google.com/
[4] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@google.com/

 mm/userfaultfd.c | 227 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 153 insertions(+), 74 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 45e6290e2e8b..589294994f98 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1026,18 +1026,67 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
 	       pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
 }
 
-static int move_present_pte(struct mm_struct *mm,
-			    struct vm_area_struct *dst_vma,
-			    struct vm_area_struct *src_vma,
-			    unsigned long dst_addr, unsigned long src_addr,
-			    pte_t *dst_pte, pte_t *src_pte,
-			    pte_t orig_dst_pte, pte_t orig_src_pte,
-			    pmd_t *dst_pmd, pmd_t dst_pmdval,
-			    spinlock_t *dst_ptl, spinlock_t *src_ptl,
-			    struct folio *src_folio)
+/*
+ * Checks if the two ptes and the corresponding folio are eligible for batched
+ * move. If so, then returns pointer to the locked folio. Otherwise, returns NULL.
+ *
+ * NOTE: folio's reference is not required as the whole operation is within
+ * PTL's critical section.
+ */
+static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
+						 unsigned long src_addr,
+						 pte_t *src_pte, pte_t *dst_pte,
+						 struct anon_vma *src_anon_vma)
 {
-	int err = 0;
+	pte_t orig_dst_pte, orig_src_pte;
+	struct folio *folio;
+
+	orig_dst_pte = ptep_get(dst_pte);
+	if (!pte_none(orig_dst_pte))
+		return NULL;
+
+	orig_src_pte = ptep_get(src_pte);
+	if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_src_pte)))
+		return NULL;
+
+	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
+	if (!folio || !folio_trylock(folio))
+		return NULL;
+	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
+	    folio_anon_vma(folio) != src_anon_vma) {
+		folio_unlock(folio);
+		return NULL;
+	}
+	return folio;
+}
 
+/*
+ * Moves src folios to dst in a batch as long as they share the same
+ * anon_vma as the first folio, are not large, and can successfully
+ * take the lock via folio_trylock().
+ */
+static long move_present_ptes(struct mm_struct *mm,
+			      struct vm_area_struct *dst_vma,
+			      struct vm_area_struct *src_vma,
+			      unsigned long dst_addr, unsigned long src_addr,
+			      pte_t *dst_pte, pte_t *src_pte,
+			      pte_t orig_dst_pte, pte_t orig_src_pte,
+			      pmd_t *dst_pmd, pmd_t dst_pmdval,
+			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
+			      struct folio **first_src_folio, unsigned long len,
+			      struct anon_vma *src_anon_vma)
+{
+	int err = 0;
+	struct folio *src_folio = *first_src_folio;
+	unsigned long src_start = src_addr;
+	unsigned long src_end;
+
+	if (len > PAGE_SIZE) {
+		len = pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
+		src_end = pmd_addr_end(src_addr, src_addr + len);
+	} else
+		src_end = src_addr + len;
+	flush_cache_range(src_vma, src_addr, src_end);
 	double_pt_lock(dst_ptl, src_ptl);
 
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
@@ -1051,31 +1100,56 @@ static int move_present_pte(struct mm_struct *mm,
 		err = -EBUSY;
 		goto out;
 	}
+	/* It's safe to drop the reference now as the page-table is holding one. */
+	folio_put(*first_src_folio);
+	*first_src_folio = NULL;
+	arch_enter_lazy_mmu_mode();
+
+	while (true) {
+		orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
+		/* Folio got pinned from under us. Put it back and fail the move. */
+		if (folio_maybe_dma_pinned(src_folio)) {
+			set_pte_at(mm, src_addr, src_pte, orig_src_pte);
+			err = -EBUSY;
+			break;
+		}
 
-	orig_src_pte = ptep_clear_flush(src_vma, src_addr, src_pte);
-	/* Folio got pinned from under us. Put it back and fail the move. */
-	if (folio_maybe_dma_pinned(src_folio)) {
-		set_pte_at(mm, src_addr, src_pte, orig_src_pte);
-		err = -EBUSY;
-		goto out;
-	}
-
-	folio_move_anon_rmap(src_folio, dst_vma);
-	src_folio->index = linear_page_index(dst_vma, dst_addr);
+		folio_move_anon_rmap(src_folio, dst_vma);
+		src_folio->index = linear_page_index(dst_vma, dst_addr);
 
-	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
-	/* Set soft dirty bit so userspace can notice the pte was moved */
+		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
+		/* Set soft dirty bit so userspace can notice the pte was moved */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
+		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 #endif
-	if (pte_dirty(orig_src_pte))
-		orig_dst_pte = pte_mkdirty(orig_dst_pte);
-	orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_dirty(orig_src_pte))
+			orig_dst_pte = pte_mkdirty(orig_dst_pte);
+		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
+
+		src_addr += PAGE_SIZE;
+		if (src_addr == src_end)
+			break;
+		dst_addr += PAGE_SIZE;
+		dst_pte++;
+		src_pte++;
 
-	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
+		folio_unlock(src_folio);
+		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
+							dst_pte, src_anon_vma);
+		if (!src_folio)
+			break;
+	}
+
+	arch_leave_lazy_mmu_mode();
+	if (src_addr > src_start)
+		flush_tlb_range(src_vma, src_start, src_addr);
+
+	if (src_folio)
+		folio_unlock(src_folio);
 out:
 	double_pt_unlock(dst_ptl, src_ptl);
-	return err;
+	return src_addr > src_start ? src_addr - src_start : err;
 }
 
 static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
@@ -1140,7 +1214,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 static int move_zeropage_pte(struct mm_struct *mm,
@@ -1167,20 +1241,20 @@ static int move_zeropage_pte(struct mm_struct *mm,
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 
 /*
- * The mmap_lock for reading is held by the caller. Just move the page
- * from src_pmd to dst_pmd if possible, and return true if succeeded
- * in moving the page.
+ * The mmap_lock for reading is held by the caller. Just move the page(s)
+ * from src_pmd to dst_pmd if possible, and return number of bytes moved.
+ * On failure, an error code is returned.
  */
-static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *dst_vma,
-			  struct vm_area_struct *src_vma,
-			  unsigned long dst_addr, unsigned long src_addr,
-			  __u64 mode)
+static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
+			    struct vm_area_struct *dst_vma,
+			    struct vm_area_struct *src_vma,
+			    unsigned long dst_addr, unsigned long src_addr,
+			    unsigned long len, __u64 mode)
 {
 	swp_entry_t entry;
 	struct swap_info_struct *si = NULL;
@@ -1194,11 +1268,10 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	struct folio *src_folio = NULL;
 	struct anon_vma *src_anon_vma = NULL;
 	struct mmu_notifier_range range;
-	int err = 0;
+	long ret = 0;
 
-	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				src_addr, src_addr + PAGE_SIZE);
+				src_addr, src_addr + len);
 	mmu_notifier_invalidate_range_start(&range);
 retry:
 	/*
@@ -1212,7 +1285,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 
 	/* Retry if a huge pmd materialized from under us */
 	if (unlikely(!dst_pte)) {
-		err = -EAGAIN;
+		ret = -EAGAIN;
 		goto out;
 	}
 
@@ -1231,14 +1304,14 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	 * transparent huge pages under us.
 	 */
 	if (unlikely(!src_pte)) {
-		err = -EAGAIN;
+		ret = -EAGAIN;
 		goto out;
 	}
 
 	/* Sanity checks before the operation */
 	if (pmd_none(*dst_pmd) || pmd_none(*src_pmd) ||
 	    pmd_trans_huge(*dst_pmd) || pmd_trans_huge(*src_pmd)) {
-		err = -EINVAL;
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -1246,7 +1319,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	orig_dst_pte = ptep_get(dst_pte);
 	spin_unlock(dst_ptl);
 	if (!pte_none(orig_dst_pte)) {
-		err = -EEXIST;
+		ret = -EEXIST;
 		goto out;
 	}
 
@@ -1255,21 +1328,21 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	spin_unlock(src_ptl);
 	if (pte_none(orig_src_pte)) {
 		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
-			err = -ENOENT;
+			ret = -ENOENT;
 		else /* nothing to do to move a hole */
-			err = 0;
+			ret = PAGE_SIZE;
 		goto out;
 	}
 
 	/* If PTE changed after we locked the folio them start over */
 	if (src_folio && unlikely(!pte_same(src_folio_pte, orig_src_pte))) {
-		err = -EAGAIN;
+		ret = -EAGAIN;
 		goto out;
 	}
 
 	if (pte_present(orig_src_pte)) {
 		if (is_zero_pfn(pte_pfn(orig_src_pte))) {
-			err = move_zeropage_pte(mm, dst_vma, src_vma,
+			ret = move_zeropage_pte(mm, dst_vma, src_vma,
 					       dst_addr, src_addr, dst_pte, src_pte,
 					       orig_dst_pte, orig_src_pte,
 					       dst_pmd, dst_pmdval, dst_ptl, src_ptl);
@@ -1292,14 +1365,14 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			spin_lock(src_ptl);
 			if (!pte_same(orig_src_pte, ptep_get(src_pte))) {
 				spin_unlock(src_ptl);
-				err = -EAGAIN;
+				ret = -EAGAIN;
 				goto out;
 			}
 
 			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
 			if (!folio || !PageAnonExclusive(&folio->page)) {
 				spin_unlock(src_ptl);
-				err = -EBUSY;
+				ret = -EBUSY;
 				goto out;
 			}
 
@@ -1313,7 +1386,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			 */
 			if (!locked && folio_test_large(folio)) {
 				spin_unlock(src_ptl);
-				err = -EAGAIN;
+				ret = -EAGAIN;
 				goto out;
 			}
 
@@ -1332,7 +1405,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			}
 
 			if (WARN_ON_ONCE(!folio_test_anon(src_folio))) {
-				err = -EBUSY;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
@@ -1343,8 +1416,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			pte_unmap(src_pte);
 			pte_unmap(dst_pte);
 			src_pte = dst_pte = NULL;
-			err = split_folio(src_folio);
-			if (err)
+			ret = split_folio(src_folio);
+			if (ret)
 				goto out;
 			/* have to reacquire the folio after it got split */
 			folio_unlock(src_folio);
@@ -1362,7 +1435,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			src_anon_vma = folio_get_anon_vma(src_folio);
 			if (!src_anon_vma) {
 				/* page was unmapped from under us */
-				err = -EAGAIN;
+				ret = -EAGAIN;
 				goto out;
 			}
 			if (!anon_vma_trylock_write(src_anon_vma)) {
@@ -1375,10 +1448,11 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			}
 		}
 
-		err = move_present_pte(mm,  dst_vma, src_vma,
-				       dst_addr, src_addr, dst_pte, src_pte,
-				       orig_dst_pte, orig_src_pte, dst_pmd,
-				       dst_pmdval, dst_ptl, src_ptl, src_folio);
+		ret = move_present_ptes(mm, dst_vma, src_vma,
+					dst_addr, src_addr, dst_pte, src_pte,
+					orig_dst_pte, orig_src_pte, dst_pmd,
+					dst_pmdval, dst_ptl, src_ptl, &src_folio,
+					len, src_anon_vma);
 	} else {
 		struct folio *folio = NULL;
 
@@ -1389,20 +1463,20 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				migration_entry_wait(mm, src_pmd, src_addr);
-				err = -EAGAIN;
+				ret = -EAGAIN;
 			} else
-				err = -EFAULT;
+				ret = -EFAULT;
 			goto out;
 		}
 
 		if (!pte_swp_exclusive(orig_src_pte)) {
-			err = -EBUSY;
+			ret = -EBUSY;
 			goto out;
 		}
 
 		si = get_swap_device(entry);
 		if (unlikely(!si)) {
-			err = -EAGAIN;
+			ret = -EAGAIN;
 			goto out;
 		}
 		/*
@@ -1422,7 +1496,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 					swap_cache_index(entry));
 		if (!IS_ERR_OR_NULL(folio)) {
 			if (folio_test_large(folio)) {
-				err = -EBUSY;
+				ret = -EBUSY;
 				folio_put(folio);
 				goto out;
 			}
@@ -1439,7 +1513,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 				goto retry;
 			}
 		}
-		err = move_swap_pte(mm, dst_vma, dst_addr, src_addr, dst_pte, src_pte,
+		ret = move_swap_pte(mm, dst_vma, dst_addr, src_addr, dst_pte, src_pte,
 				orig_dst_pte, orig_src_pte, dst_pmd, dst_pmdval,
 				dst_ptl, src_ptl, src_folio, si, entry);
 	}
@@ -1461,7 +1535,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	if (si)
 		put_swap_device(si);
 
-	return err;
+	return ret;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1732,7 +1806,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *src_vma, *dst_vma;
-	unsigned long src_addr, dst_addr;
+	unsigned long src_addr, dst_addr, src_end;
 	pmd_t *src_pmd, *dst_pmd;
 	long err = -EINVAL;
 	ssize_t moved = 0;
@@ -1775,8 +1849,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	if (err)
 		goto out_unlock;
 
-	for (src_addr = src_start, dst_addr = dst_start;
-	     src_addr < src_start + len;) {
+	for (src_addr = src_start, dst_addr = dst_start, src_end = src_start + len;
+	     src_addr < src_end;) {
 		spinlock_t *ptl;
 		pmd_t dst_pmdval;
 		unsigned long step_size;
@@ -1844,6 +1918,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 						  dst_addr, src_addr);
 			step_size = HPAGE_PMD_SIZE;
 		} else {
+			long ret;
+
 			if (pmd_none(*src_pmd)) {
 				if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
 					err = -ENOENT;
@@ -1860,10 +1936,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 				break;
 			}
 
-			err = move_pages_pte(mm, dst_pmd, src_pmd,
-					     dst_vma, src_vma,
-					     dst_addr, src_addr, mode);
-			step_size = PAGE_SIZE;
+			ret = move_pages_ptes(mm, dst_pmd, src_pmd,
+					      dst_vma, src_vma, dst_addr,
+					      src_addr, src_end - src_addr, mode);
+			if (ret < 0)
+				err = ret;
+			else
+				step_size = ret;
 		}
 
 		cond_resched();

base-commit: 3a4a0367c9f45b025ec57e1ba492512d5479d361
-- 
2.51.0.rc1.167.g924127e9c0-goog


