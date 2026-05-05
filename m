Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C45CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1D36B0098; Tue,  5 May 2026 11:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E942B6B0099; Tue,  5 May 2026 11:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82A56B009B; Tue,  5 May 2026 11:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C37046B0098
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82D3F140381
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:06 +0000 (UTC)
X-FDA: 84733774692.10.2244100
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 99DB7180010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QdN9KyBp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDrN5UJNMucxxkduNBtwUT+YIWRTL7z/5dVTQpr2UXk=;
	b=J9drQk20YidjmFUeuvXbST24Chrfrze2L6B7nQQfZum+Et2a2OxY+OCkt4sQ5W2t/zNKIV
	6L+QnaaSy0XWfRxv5OqGsT+43WfS1fsP8gGvnxc4Hj0VEnuKQZmiwXSJDjuC5Xhmp8HTQr
	5cNxKTcef1tMkcuHxZ6U1M4D5svDiZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995544; a=rsa-sha256;
	cv=none;
	b=ypC627S+tnaesMittuKQjPIU2hAJ0s/jC6ZT1sRli5pu3Ysczu5A9lG/B9kCrskCo5vODU
	1DYd/6ERSQ3bEnip7MWvy4+0RqtSq1i1Ack/JMGvCIRxsP4WaKJjEHvP6dGGcLiTDr6cZf
	dUkqfPLxYgDXX14iG71BTRfBciZXIA4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QdN9KyBp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-479dc6d26e3so3030692b6e.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995544; x=1778600344; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NDrN5UJNMucxxkduNBtwUT+YIWRTL7z/5dVTQpr2UXk=;
        b=QdN9KyBp7xdjAfCyk+DfKARnWAyKaulK3/vXgNR9RXSsvZ44WZ1GY0mqLoUWFGgrFG
         gRNX1QsWPNB9xdU95oG3htK7+r7/iwdyrMOhUNv1AA4V02b2DJjcN6N9706/MDpZs2R4
         21mgTlUEJXEB6EPccWZBB+h/nAbxRH6Ei+IEBywWvhl3Tu87S4cCiuIH2Gb/SqOoy3gq
         DP7YN2lhoS4NfJHBlPxIjgwogLnnbg9ynv9x40nwoBJlF0cgtI4gmxNAqBbVDcSLCBFM
         UCbNZPQzvtRH+lW22Kwt3+3xB6c/h7fUobDrdbYIhsgppNsdlHnSo2v6GYIV9e+1xzOg
         eWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995544; x=1778600344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NDrN5UJNMucxxkduNBtwUT+YIWRTL7z/5dVTQpr2UXk=;
        b=sfW0ShsLPoIaXvgBYXLNpvzO6appBAaBa5yvdEuxD4q2yvb/BKkibVuBFkTSusqFqB
         keLrhopDcqVticN1Hq1ClQbwbKnQFhvyuLGCvg1YeWhPZq6jdESXMdHa9LMZCdJOP47x
         LpbAIwImf3fq156wpplv7Bv8cHPMoeHsm9ehcmwYWtoOb0cilrHc+5xIT2jyZWe4PvEc
         GAMyZqnutnUhJ5gLhMMWU4VlSkB33af+UZgD1oldQ3Vd00eZUwmkWyhESCZ12wm4/7DI
         l/UkkAjKnwFinCqt7oW5SE1q8yD2GjjW8bMH/brJAihzktbwvEIdXFv9f0pF3o8Danwj
         CHrA==
X-Forwarded-Encrypted: i=1; AFNElJ90ucTR95WElSIDaj7Lc50WPBquVqhDBF4uv/ChmKNL4Da7Mr1uOHtuehHBsfW/xI+O92rmF1LKWA==@kvack.org
X-Gm-Message-State: AOJu0Yw2B78Wg1e7Tph2xxcYoNgRDJAbRjaeEO0Tmq2L5Yk/bH5VU0J9
	wNbhjsszXRhf9idRpPrkkPbL7OIKxvZ+D8PCRfZHqtUCV12epEvQkTy9
X-Gm-Gg: AeBDievCAjVTXUOOCZA+QnAEDRkrUQVQsfEuLwQIK3hUE161qMREKvwSrMTd3tNgx4j
	7vcScmsgGdIXPTLkBXW0yQq9Yp6LqdgX9Sz+NBkMBG9jYAVexHasmRmtK7nu6SZTiNyLAvWtwMB
	c6OnL9AAR2OD6M24884WQp5LiI+7ZflbXU2Modo2hB9vzDYqohy3TEY4L/kd1BKIFUzkrUQsK0B
	kKIp1hHvFwzyNoT201cruAb3tV8ydU/NjPlKmodwXKM1A0EqlCtln6Fig2bAkOTmDu3xP1MZcco
	ptTVJiL9ZtbpLLUFCtoiumk+p7Brm51DmkBF5AQ0zPwCWKwg+31x4HEkwASLKA/WL1BiG6omZEU
	zlIET9pC9WlDFZXWuq9kDOlC+HaGhOAtZpc2jHvjeKo5MLtqMsnEgVic6WgQ27L6Aq1xF/S006x
	2pJMlYrv1b+/tendEsB2bcTexfqb+xWmQdt4TqK635Gds0R21pneHtokIGAEphW0CImXw=
X-Received: by 2002:a05:6808:1446:b0:45e:f0af:5148 with SMTP id 5614622812f47-47c892315e3mr7434984b6e.30.1777995543417;
        Tue, 05 May 2026 08:39:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5f::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76935904sm8701006b6e.11.2026.05.05.08.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:02 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 03/22] mm: swap: add an abstract API for locking out swapoff
Date: Tue,  5 May 2026 08:38:32 -0700
Message-ID: <20260505153854.1612033-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 99DB7180010
X-Stat-Signature: 8fmpb8cwda7dtgihrijoz8uto1xepsm9
X-Rspam-User: 
X-HE-Tag: 1777995544-367591
X-HE-Meta: U2FsdGVkX19z7CoDpiK5SduiOedXrZFKMkwOPTRCBF9mWjq1tE6PXhbgot0W/MSOuUdA/XFgCrvq+Bd02mtw1NeTowslKAbn3yx4/eaZla+naDyE1/UPhWmyLwIxPTdUqmUwi4EZa+yA/AcnzpfJwDqAGdon3HiDa59YdxaNiBNYENI+2Wzl6RmfuWxRR5CEmixRj4Bb1PvWqTd3t4FiRSc0601smTzoGoDnL/2OkHo4Mt9N7nifjgYneesIScztcImPGEUUiVzfXdxTdT5oIZOdK/iqMU43pmMMJE0EPQxYNKT0CWb7JwKjpS3kqW7+l5AfJ+foQEwW+jzOwCMsvDRZVe2fOaBEc3KPD0vKZD80DC7KQPZZ+0d0fN4SBvv4oqoPfatM1zqA3KCVZ8SErmiHbrxN7Njkhf7MvbxiEPy8Q5ZlalvKi+2MRthvGuw9+qzSEcd2qSE+3cheXyc8/k7ZVjCay10tnRj3ZXXye1tiwoyHSH1sxl7AwtZtKl0BzSxbtMj6h0ssPZaX7p0NZpHhcY6iUUO8Rt743q09MrAJKZAxEakIti3keGPnZ/9h0r5pqjElTrnzVM2G08adGXXE8oGeO8jB3qdLq7Ig5OUlxKkqQ+9u9aVknGRKdcXan7h/I1JrqDlHrnU1CZ2owHtyJVreOBsEzsAxW0+9UnjTVaw3Cjao0lYDXI0AywkY2LHwpVttOBJeb0KKju+ZwEalx6lgbXyaFQPYw+z81GaE90IyPZs85DAxFELjNOVDjrM5SxpSfVeHIlvSHv1VdwgzPNBiW9L3pXq9IDMJh8HzXWZ22lG4iFcD+sM4S7UYSmCnBTvP9q1xiwmmzMbDbxi8Lxe8G8obujdQMzshvUuU0BYIarq6EvTdkkB145B+Rug4NrA8ijzEmAyS/7oCFlv08a5P+OYHb2mc5eO9ml+kJtoQuZmtISDsyLou/gixsL34KRWwoC6o2+deev/
 ncXopjB5
 RUKQ0JQkHkz6qtJY5ZRGPGseEE80mdL1MEwtBVonvK+P3TJdgNO6OpGljK6UzIrHzwSFaTMnzDrydeW1R9p7smtG4ot+9u8REBmoPP19J2LTaUGA7QLKFmd4c5Mt1v7La38P5fHV9EUa55KxgU//y59TNzkTNrxRUNn9QCt1N0LUjKf35/g14N4Wyv3XrFK6RFiJExG6a28sAHRyyjalE9tRHjP9OV15InxrXJ1Q1ZaaSoT1xzPX+XxHKTjnsejG1iL0mjbZrGDr7cue1bvR2oqxWRP1uG0MI+stIV8OJD5VfnlO/eok2R/Of5eNZLMCjAQ4sbIrZzmZrZ/qV+li0lzvcTCAqCECcPO7d/C3ukoJ4cgxfNGQJ/Xnvk9aDzP/XIIJ/gJCROovcXbNziXVto+tRAmQ+rI48wA2b7Rs8A+kGw4zTRi5XyN57A8mSiidVsTwlNVYyXmf140DJrkiitgYG9IULckp4VeLS4fe0Q6miv8rJILr54s4r906k8NxixTmxCvYTb9NnFTqjF8CcxFzFlv0krfvsaYnjg48Z0Womkztd/dXo9kBQdSL2mmSsjQ6F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we get a reference to the backing swap device in order to
prevent swapoff from freeing the metadata of a swap entry. This does not
make sense in the new virtual swap design, especially after the swap
backends are decoupled - a swap entry might not have any backing swap
device at all, and its backend might change at any time during its
lifetime.

In preparation for this, abstract away the swapoff locking out behavior
into a generic API.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 17 +++++++++++++++++
 mm/memory.c          | 13 +++++++------
 mm/mincore.c         | 15 ++++++---------
 mm/shmem.c           | 12 ++++++------
 mm/swap_state.c      | 14 +++++++-------
 mm/userfaultfd.c     | 15 +++++++++------
 mm/zswap.c           |  5 ++---
 7 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index aa29d8ac542d..3da637b218ba 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -659,5 +659,22 @@ static inline bool mem_cgroup_swap_full(struct folio *folio)
 }
 #endif
 
+static inline bool tryget_swap_entry(swp_entry_t entry,
+				struct swap_info_struct **sip)
+{
+	struct swap_info_struct *si = get_swap_device(entry);
+
+	if (sip)
+		*sip = si;
+
+	return si;
+}
+
+static inline void put_swap_entry(swp_entry_t entry,
+				struct swap_info_struct *si)
+{
+	put_swap_device(si);
+}
+
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..90031f833f52 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4630,6 +4630,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
 	bool need_clear_cache = false;
+	bool swapoff_locked = false;
 	bool exclusive = false;
 	softleaf_t entry;
 	pte_t pte;
@@ -4698,8 +4699,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	}
 
 	/* Prevent swapoff from happening to us. */
-	si = get_swap_device(entry);
-	if (unlikely(!si))
+	swapoff_locked = tryget_swap_entry(entry, &si);
+	if (unlikely(!swapoff_locked))
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
@@ -5047,8 +5048,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		if (waitqueue_active(&swapcache_wq))
 			wake_up(&swapcache_wq);
 	}
-	if (si)
-		put_swap_device(si);
+	if (swapoff_locked)
+		put_swap_entry(entry, si);
 	return ret;
 out_nomap:
 	if (vmf->pte)
@@ -5066,8 +5067,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		if (waitqueue_active(&swapcache_wq))
 			wake_up(&swapcache_wq);
 	}
-	if (si)
-		put_swap_device(si);
+	if (swapoff_locked)
+		put_swap_entry(entry, si);
 	return ret;
 }
 
diff --git a/mm/mincore.c b/mm/mincore.c
index e5d13eea9234..ee6ce6088d51 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -78,18 +78,15 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 		return !shmem;
 
 	/*
-	 * Shmem mapping lookup is lockless, so we need to grab the swap
-	 * device. mincore page table walk locks the PTL, and the swap
-	 * device is stable, avoid touching the si for better performance.
+	 * Shmem mapping lookup is lockless, so we need to pin the swap entry.
+	 * mincore page table walk holds the PTL, which keeps the swap entry
+	 * (and thus its vswap cluster) alive, so skip the pin for performance.
 	 */
-	if (shmem) {
-		si = get_swap_device(entry);
-		if (!si)
-			return 0;
-	}
+	if (shmem && !tryget_swap_entry(entry, &si))
+		return 0;
 	folio = swap_cache_get_folio(entry);
 	if (shmem)
-		put_swap_device(si);
+		put_swap_entry(entry, si);
 	/* The swap cache space contains either folio, shadow or NULL */
 	if (folio && !xa_is_value(folio)) {
 		present = folio_test_uptodate(folio);
diff --git a/mm/shmem.c b/mm/shmem.c
index 1db97ef2d14e..b40be22fa5f0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2307,7 +2307,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	softleaf_t index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
-	bool skip_swapcache = false;
+	bool swapoff_locked, skip_swapcache = false;
 	int error, nr_pages, order;
 	pgoff_t offset;
 
@@ -2319,16 +2319,16 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (softleaf_is_poison_marker(index_entry))
 		return -EIO;
 
-	si = get_swap_device(index_entry);
+	swapoff_locked = tryget_swap_entry(index_entry, &si);
 	order = shmem_confirm_swap(mapping, index, index_entry);
-	if (unlikely(!si)) {
+	if (unlikely(!swapoff_locked)) {
 		if (order < 0)
 			return -EEXIST;
 		else
 			return -EINVAL;
 	}
 	if (unlikely(order < 0)) {
-		put_swap_device(si);
+		put_swap_entry(index_entry, si);
 		return -EEXIST;
 	}
 
@@ -2448,7 +2448,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	}
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
-	put_swap_device(si);
+	put_swap_entry(swap, si);
 
 	*foliop = folio;
 	return 0;
@@ -2466,7 +2466,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
 	if (folio)
 		folio_put(folio);
-	put_swap_device(si);
+	put_swap_entry(swap, si);
 
 	return error;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 01212975c00c..7647341e00ed 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -539,8 +539,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	pgoff_t ilx;
 	struct folio *folio;
 
-	si = get_swap_device(entry);
-	if (!si)
+	if (!tryget_swap_entry(entry, &si))
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
@@ -551,7 +550,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	if (page_allocated)
 		swap_read_folio(folio, plug);
 
-	put_swap_device(si);
+	put_swap_entry(entry, si);
 	return folio;
 }
 
@@ -764,6 +763,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
 		struct swap_info_struct *si = NULL;
 		softleaf_t entry;
+		bool swapoff_locked = false;
 
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
@@ -782,14 +782,14 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		 * holding a reference to, try to grab a reference, or skip.
 		 */
 		if (swp_type(entry) != swp_type(targ_entry)) {
-			si = get_swap_device(entry);
-			if (!si)
+			swapoff_locked = tryget_swap_entry(entry, &si);
+			if (!swapoff_locked)
 				continue;
 		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
-		if (si)
-			put_swap_device(si);
+		if (swapoff_locked)
+			put_swap_entry(entry, si);
 		if (!folio)
 			continue;
 		if (page_allocated) {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e6dfd5f28acd..25f89eba0438 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1262,9 +1262,11 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	pte_t *dst_pte = NULL;
 	pmd_t dummy_pmdval;
 	pmd_t dst_pmdval;
+	softleaf_t entry;
 	struct folio *src_folio = NULL;
 	struct mmu_notifier_range range;
 	long ret = 0;
+	bool swapoff_locked = false;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				src_addr, src_addr + len);
@@ -1429,7 +1431,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 					len);
 	} else { /* !pte_present() */
 		struct folio *folio = NULL;
-		const softleaf_t entry = softleaf_from_pte(orig_src_pte);
+		entry = softleaf_from_pte(orig_src_pte);
 
 		if (softleaf_is_migration(entry)) {
 			pte_unmap(src_pte);
@@ -1449,8 +1451,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 			goto out;
 		}
 
-		si = get_swap_device(entry);
-		if (unlikely(!si)) {
+		swapoff_locked = tryget_swap_entry(entry, &si);
+		if (unlikely(!swapoff_locked)) {
 			ret = -EAGAIN;
 			goto out;
 		}
@@ -1480,8 +1482,9 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 				pte_unmap(src_pte);
 				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
-				put_swap_device(si);
+				put_swap_entry(entry, si);
 				si = NULL;
+				swapoff_locked = false;
 				/* now we can block and wait */
 				folio_lock(src_folio);
 				goto retry;
@@ -1507,8 +1510,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	if (dst_pte)
 		pte_unmap(dst_pte);
 	mmu_notifier_invalidate_range_end(&range);
-	if (si)
-		put_swap_device(si);
+	if (swapoff_locked)
+		put_swap_entry(entry, si);
 
 	return ret;
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index ac9b7a60736b..315e4d0d0831 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1009,14 +1009,13 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
-	si = get_swap_device(swpentry);
-	if (!si)
+	if (!tryget_swap_entry(swpentry, &si))
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
 	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
 			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
-	put_swap_device(si);
+	put_swap_entry(swpentry, si);
 	if (!folio)
 		return -ENOMEM;
 
-- 
2.52.0


