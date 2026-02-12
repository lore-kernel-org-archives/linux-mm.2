Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71F4ECD6FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02FFA6B0099; Wed, 11 Feb 2026 19:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDE96B0098; Wed, 11 Feb 2026 19:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE33F6B0099; Wed, 11 Feb 2026 19:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6C346B0096
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CA93C229F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:40 +0000 (UTC)
X-FDA: 84433941480.15.971655A
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A32280006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xmTcSpli;
	spf=pass (imf02.hostedemail.com: domain of 30SCNaQsKCJo46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=30SCNaQsKCJo46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770856658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mW1n+uSYA6jLOEsvKLlQWfWVUyuDqSU/loYnlj1zbjs=;
	b=pE+FsPS+r0LqBCJZeiBq3QJgdn00/1/1PGgjMmHw+5Gg2iOvgXB5DF9OTjha1c8zdlZgJi
	sp4z8OO6/0YkQuA8x0sCcEOTcaHkQSuvT/2SHCcF4eGWXlcfVUwJ7YJSWW4HjlOqm3MUbJ
	pdIQ/hBi/TqZ5XaCvq7EHbYwDrJ23bo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xmTcSpli;
	spf=pass (imf02.hostedemail.com: domain of 30SCNaQsKCJo46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=30SCNaQsKCJo46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770856658; a=rsa-sha256;
	cv=none;
	b=YZBq3YJDAYijU1iZc+jNspbZV6PkUQimcHN5DbEej7jF/Rrmzsq8xK63N+ezUoFtjVUWJx
	6eSvC9eSKQ7LS7AyV9qjcL/EmfPuwvdOIhTuG+FN/QqOLvM7O4mHdjH9p9FKI9FQ6s+bCv
	QDLvhSwPEOYU/Xqkh8MIz4rOIY6hW4Q=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a92a3f5de9so16550155ad.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770856657; x=1771461457; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mW1n+uSYA6jLOEsvKLlQWfWVUyuDqSU/loYnlj1zbjs=;
        b=xmTcSpliIAGKGpY+vh/hp88AssCOpYMwnf9nfRFfJc1GEnJx3mLUjt5fEkst7sM1L8
         9ZYp6oYyErHiD1/rKqFlSnr9NtNm1V5uM8UyK2FKDHDkPV1G8nX/9xMVSKD217gdyFGr
         y/p8V05CRIl46PzOetzJI7hllTJ9Yi/Grivldg2kYxVgoZSOQVL63/zAOd82fq/8p32m
         WNAdHmuBLlpzNlxUOlXIGpwZvp9vB3VU7wrom9J6GJEXI2cEyCNG7i9FDrZbvMtscvgj
         Uq0Fq+vF2jegryX7Wb8ZSSeVRBHkT8d7VljaIeOu+SeJ4XHx5De84e88oHdekYssY4xO
         M7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856657; x=1771461457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mW1n+uSYA6jLOEsvKLlQWfWVUyuDqSU/loYnlj1zbjs=;
        b=PGLIsswM9q0nzc+x1DPmIWs7SROIvx0+lYyilZz4Lk98wQMKCQ0HH4vwgoeBdpIpOP
         2ZNmS/vlVOtl3JIqOIWd+DEcjwaZw1Wh31pETSkUclFb+O3ZfAgN2myPayHAnNtAcvNJ
         kndJlDmo3ItEymbe6jo0JCoWSbv9zPZiDsaeeYBDAO3T/l/YceAuwawUw5kRfGduQJ6l
         ceWOk0hMWMAnP0ZbeeKjKbrvkMHoE8nY3JlMZbRW1GFPYoOMbOhU5TNlYHxYR1Fk1n2x
         fthz2duyWS2yAZ/gY6cR0wnujMLXv8rc2ngH+lKJ5/GzUpy72DXjf1jlKJ+27yL4UX81
         upkA==
X-Forwarded-Encrypted: i=1; AJvYcCUw8C+bFJZY5V4KojYaYQULSvED4HMrJIKJUi2+KI4cdlz612kaB1T23o0vchZB1lDm2upBKTKxkA==@kvack.org
X-Gm-Message-State: AOJu0Yyk7Uu5FQrjVKXnVBK8+pLpDi1VVFTl23q0VxROr2Z+3kuKRibg
	QnSd8aswReZlcnXgra7COGmcVTFAWnlKgBcW9P70tR17jEL+yqd1vLFdRQiOLoiIXPJN8vzQC1P
	oNIrBV0FyfqCywV0xgtJRKsCmkQ==
X-Received: from plbla13.prod.google.com ([2002:a17:902:fa0d:b0:2a9:622c:47d6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:9cf:b0:2a7:d5c0:c659 with SMTP id d9443c01a7336-2ab3b1581a3mr5091465ad.5.1770856657375;
 Wed, 11 Feb 2026 16:37:37 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:18 -0800
In-Reply-To: <cover.1770854662.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <3803e96be57ab3201ab967ba47af22d12024f9e1.1770854662.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 7/7] mm: hugetlb: Refactor out hugetlb_alloc_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com
Cc: ackerleytng@google.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A32280006
X-Stat-Signature: kirfnisdmi9qfh6nuaxj6b8fdb6zwec7
X-Rspam-User: 
X-HE-Tag: 1770856658-909737
X-HE-Meta: U2FsdGVkX18UI+q4Q7fcjT5eKJGhtNnvSjtWxrvWxJSgj6pJGL5c+NkorTxiYanBop2JZwv9AfcIB3CyROZOipYpPLRaSYi2vQg7+T4QyGpqO7wnfXTLm/6D9Xllie3tQbj/MKzfkFHxzd+yvFdsNEiykFNOoXu53NeP826Tkg/FDotCHeqLI/XxbKrZieuS1YSYpk+0RVVaWckvuErW2u5nVf2k9n+Y020Ia7oXlwtyjTwxTiA4W96rUpTTxmyeIb0zGkIP1acRQ/eYz3FFrlBUa7sKIHSJupu2YduQRXfSoydk1AmeHdxjPDBJ8TFo+XAEgLhZdcaWoVTLBDSMRQiaBTVPIEv+mTdWt6PF7AyiBBOV/NI45Ve0yQSd/gkTG7KFXm99gVUPJyL2OxJg6sm6emRiPQLVQNQ5DbTPnRUpXYHy2uB/KJ0hTp5otm4jMc8kpxzl65FzTAkywAdRA0Alwh1bgSNgLJUH+AjgIeg9N63jrN7ZH3+8wZq7dUTZa11CRQc0HTj4N6eGZ3DeGdRl9atdSMjawb59p5nr97vq3948mVx+LYHAtdQPn/OR34Us09CBwx64J8ncwFoGRpHMWRtTu0twpnlVkpCAT13703Jbn6sHDrrAUOHceY+eBKIAWvD9vbzW6jZwiNEgEavzR855xP1tcpVJmtcIzSMj7ITWAuk/Pp01eoMAMdCsiDZhxaPdRcvvx8nFyCCZ9VDJPLCCGql60lboYCYEZBcPnUEcefSgbMLkFDldtAWKO8/DW6cM7UfplrvMgCSqmtRQS5W0pg+gmeMYYIp4WroTF5Js2qS0um3d4vuHIIK6B4h030CNTFBRZMhA+h1RM7fbugyzSVSFk1HuJ7p4TZUpBbEIHohQiEh7DTsRHznL8YMtwtufqAIR/Bahb5nYy0sCEFPJ7asLLdGR/2tfZBQoeF0jL0eLkwR9M6RnV1R6O/3UUSBBSjIEE9ptzCd
 SeIKhddA
 3f+CI2rWUXNMizjFVHC6RyDG6RYC2v3y6Zb5vzSaqwJv5wOc/8nE/a1+sOmmGQuco7mykOmJ4Qi6IKzoSUnnl7npRhHxuR5S5MjvgM5bNq+fodaaBf1LWBHYhCEN07UAX5rmx6WyuHTg0aafbAjW9JAfD8quK4OtHl4KyDnR/CXvF/ZoV64xA5MCDgm0bvwvY/lG7xZRbQ/SWyB9S8Oml4Qe50ocVwewB7pTrg1XCqi7W6E9Te0I9/tWbRl+oNBLAHBHPhjW7QAzZxxjJ/jSchr2xdLmftIynup3hpxmtXvoBd4o4DccXFJqt0DK2ItfZGYW/naGTSCeFHf7kr5ku7LW/UTxj9LWvUMQABm+qFWJPQ0G+Wyw7VPVWAvmJZVFEUamOzs/m4l6MK67yfSRgpUfJvPCvCWBAg0jf+jX3XUxruLeMS3Xdm+RrovnhQYCFma65EtFTfcpZ5L1iuPsVXpzLsWUK/GrYYarRJ0aEvUOILdP4pC4rjUNrgGuIK98Hl2MsT7kBM/6gpmAWDPwmzBE6hml+FqJ9BRa07N6o3iQT9iTF4B/K1F9kv2FpiS7lFlXFo70t6uAGsRlZ1OUeB5GbW68kd9aAm8Q9/nXmGJCKbWuxTbPKZs8M7/j2PGyNX1UWXXw74kCiIeHla7bor0RNsRMtgizo7TnNfRe7hMFnadRlouj6tWbfVRW/HB1apIQdWyts9cFk7B+ZrPucq3b9IA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
handles allocation of a folio and memory and HugeTLB charging to cgroups.

Other than flags to control charging, hugetlb_alloc_folio() also takes
parameters for memory policy and memcg to charge memory to.

This refactoring decouples the HugeTLB page allocation from VMAs,
specifically:

1. Reservations (as in resv_map) are stored in the vma
2. mpol is stored at vma->vm_policy
3. A vma must be used for allocation even if the pages are not meant to be
   used by host process.

Without this coupling, VMAs are no longer a requirement for
allocation. This opens up the allocation routine for usage without VMAs,
which will allow guest_memfd to use HugeTLB as a more generic allocator of
huge pages, since guest_memfd memory may not have any associated VMAs by
design. In addition, direct allocations from HugeTLB could possibly be
refactored to avoid the use of a pseudo-VMA.

Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
subpool is stored at the fs mount. This is also a requirement for
guest_memfd, where the plan is to have a subpool created per-fd and stored
on the inode.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/hugetlb.h |  11 +++
 mm/hugetlb.c            | 201 +++++++++++++++++++++++-----------------
 2 files changed, 126 insertions(+), 86 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index e51b8ef0cebd9..e385945c04af0 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -704,6 +704,9 @@ bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
+struct folio *hugetlb_alloc_folio(struct hstate *h, struct mempolicy *mpol,
+		int nid, nodemask_t *nodemask, struct mem_cgroup *memcg,
+		bool charge_hugetlb_rsvd, bool use_existing_reservation);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1115,6 +1118,14 @@ static inline void wait_for_freed_hugetlb_folios(void)
 {
 }
 
+static inline struct folio *hugetlb_alloc_folio(struct hstate *h,
+		struct mempolicy *mpol, int nid, nodemask_t *nodemask,
+		struct mem_cgroup *memcg, bool charge_hugetlb_rsvd,
+		bool use_existing_reservation)
+{
+	return NULL;
+}
+
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   bool cow_from_owner)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 70e91edc47dc1..c6cfb268a527a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2844,6 +2844,105 @@ void wait_for_freed_hugetlb_folios(void)
 	flush_work(&free_hpage_work);
 }
 
+/**
+ * hugetlb_alloc_folio() - Allocates a hugetlb folio.
+ *
+ * @h: struct hstate to allocate from.
+ * @mpol: struct mempolicy to apply for this folio allocation.
+ *        Caller must hold reference to mpol.
+ * @nid: Node id, used together with mpol to determine folio allocation.
+ * @nodemask: Nodemask, used together with mpol to determine folio allocation.
+ * @memcg: Memory cgroup to charge for memory usage.
+ *         Caller must hold reference on memcg.
+ * @charge_hugetlb_rsvd: Set to true to charge hugetlb reservations in cgroup.
+ * @use_existing_reservation: Set to true if this allocation should use an
+ *                            existing hstate reservation.
+ *
+ * This function handles cgroup and global hstate reservations. VMA-related
+ * reservations and subpool debiting must be handled by the caller if necessary.
+ *
+ * Return: folio on success or negated error otherwise.
+ */
+struct folio *hugetlb_alloc_folio(struct hstate *h, struct mempolicy *mpol,
+		int nid, nodemask_t *nodemask, struct mem_cgroup *memcg,
+		bool charge_hugetlb_rsvd, bool use_existing_reservation)
+{
+	size_t nr_pages = pages_per_huge_page(h);
+	struct hugetlb_cgroup *h_cg = NULL;
+	gfp_t gfp = htlb_alloc_mask(h);
+	bool memory_charged = false;
+	int idx = hstate_index(h);
+	struct folio *folio;
+	int ret;
+
+	if (charge_hugetlb_rsvd) {
+		if (hugetlb_cgroup_charge_cgroup_rsvd(idx, nr_pages, &h_cg))
+			return ERR_PTR(-ENOSPC);
+	}
+
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg)) {
+		ret = -ENOSPC;
+		goto out_uncharge_hugetlb_page_count;
+	}
+
+	ret = mem_cgroup_hugetlb_try_charge(memcg, gfp | __GFP_RETRY_MAYFAIL,
+					    nr_pages);
+	if (ret == -ENOMEM)
+		goto out_uncharge_memory;
+
+	memory_charged = !ret;
+
+	spin_lock_irq(&hugetlb_lock);
+
+	folio = NULL;
+	if (use_existing_reservation || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
+
+	if (!folio) {
+		spin_unlock_irq(&hugetlb_lock);
+		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
+		if (!folio) {
+			ret = -ENOSPC;
+			goto out_uncharge_memory;
+		}
+		spin_lock_irq(&hugetlb_lock);
+		list_add(&folio->lru, &h->hugepage_activelist);
+		folio_ref_unfreeze(folio, 1);
+		/* Fall through */
+	}
+
+	if (use_existing_reservation) {
+		folio_set_hugetlb_restore_reserve(folio);
+		h->resv_huge_pages--;
+	}
+
+	hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio);
+
+	if (charge_hugetlb_rsvd)
+		hugetlb_cgroup_commit_charge_rsvd(idx, nr_pages, h_cg, folio);
+
+	spin_unlock_irq(&hugetlb_lock);
+
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
+
+	if (memory_charged)
+		mem_cgroup_commit_charge(folio, memcg);
+
+	return folio;
+
+out_uncharge_memory:
+	if (memory_charged)
+		mem_cgroup_cancel_charge(memcg, nr_pages);
+
+	hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+
+out_uncharge_hugetlb_page_count:
+	if (charge_hugetlb_rsvd)
+		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, nr_pages, h_cg);
+
+	return ERR_PTR(ret);
+}
+
 typedef enum {
 	/*
 	 * For either 0/1: we checked the per-vma resv map, and one resv
@@ -2878,17 +2977,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct folio *folio;
 	long retval, gbl_chg, gbl_reserve;
 	map_chg_state map_chg;
-	int ret, idx;
-	struct hugetlb_cgroup *h_cg = NULL;
 	gfp_t gfp = htlb_alloc_mask(h);
-	bool memory_charged = false;
+	bool charge_hugetlb_rsvd;
+	bool use_existing_reservation;
 	struct mem_cgroup *memcg;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	int nid;
 
-	idx = hstate_index(h);
-
 	/* Whether we need a separate per-vma reservation? */
 	if (cow_from_owner) {
 		/*
@@ -2920,7 +3016,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (map_chg) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
 		if (gbl_chg < 0) {
-			ret = -ENOSPC;
+			folio = ERR_PTR(-ENOSPC);
 			goto out_end_reservation;
 		}
 	} else {
@@ -2935,85 +3031,30 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * If this allocation is not consuming a per-vma reservation,
 	 * charge the hugetlb cgroup now.
 	 */
-	if (map_chg) {
-		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
-		if (ret) {
-			ret = -ENOSPC;
-			goto out_subpool_put;
-		}
-	}
+	charge_hugetlb_rsvd = (bool)map_chg;
 
-	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret) {
-		ret = -ENOSPC;
-		goto out_uncharge_cgroup_reservation;
-	}
+	/*
+	 * gbl_chg == 0 indicates a reservation exists for the allocation, so
+	 * try to use it.
+	 */
+	use_existing_reservation = gbl_chg == 0;
 
 	memcg = get_mem_cgroup_from_current();
-	ret = mem_cgroup_hugetlb_try_charge(memcg, gfp | __GFP_RETRY_MAYFAIL,
-					    pages_per_huge_page(h));
-	if (ret == -ENOMEM)
-		goto out_put_memcg;
-
-	memory_charged = !ret;
-
-	spin_lock_irq(&hugetlb_lock);
 
 	/* Takes reference on mpol. */
 	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
 
-	/*
-	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
-	 * try dequeuing a page. If there are available_huge_pages(), try using
-	 * them!
-	 */
-	folio = NULL;
-	if (!gbl_chg || available_huge_pages(h))
-		folio = dequeue_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
-
-	if (!folio) {
-		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
-		if (!folio) {
-			mpol_cond_put(mpol);
-			ret = -ENOSPC;
-			goto out_uncharge_memory;
-		}
-		spin_lock_irq(&hugetlb_lock);
-		list_add(&folio->lru, &h->hugepage_activelist);
-		folio_ref_unfreeze(folio, 1);
-		/* Fall through */
-	}
+	folio = hugetlb_alloc_folio(h, mpol, nid, nodemask, memcg,
+				    charge_hugetlb_rsvd,
+				    use_existing_reservation);
 
 	mpol_cond_put(mpol);
 
-	/*
-	 * Either dequeued or buddy-allocated folio needs to add special
-	 * mark to the folio when it consumes a global reservation.
-	 */
-	if (!gbl_chg) {
-		folio_set_hugetlb_restore_reserve(folio);
-		h->resv_huge_pages--;
-	}
-
-	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
-	/* If allocation is not consuming a reservation, also store the
-	 * hugetlb_cgroup pointer on the page.
-	 */
-	if (map_chg) {
-		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
-	}
-
-	spin_unlock_irq(&hugetlb_lock);
-
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (memory_charged)
-		mem_cgroup_commit_charge(folio, memcg);
 	mem_cgroup_put(memcg);
 
+	if (IS_ERR(folio))
+		goto out_subpool_put;
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -3046,17 +3087,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	return folio;
 
-out_uncharge_memory:
-	if (memory_charged)
-		mem_cgroup_cancel_charge(memcg, pages_per_huge_page(h));
-out_put_memcg:
-	mem_cgroup_put(memcg);
-
-	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
-out_uncharge_cgroup_reservation:
-	if (map_chg)
-		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
@@ -3067,11 +3097,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
-
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-	return ERR_PTR(ret);
+	return folio;
 }
 
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
-- 
2.53.0.310.g728cabbaf7-goog


