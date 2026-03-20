Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311131099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2766B014C; Fri, 20 Mar 2026 15:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C482A6B014E; Fri, 20 Mar 2026 15:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37A16B014F; Fri, 20 Mar 2026 15:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4B706B014C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:27:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48CC68B172
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:43 +0000 (UTC)
X-FDA: 84567426006.06.A3234CA
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6EA9216000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GTrtWJ7W;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2YShPZ4Jwzd3oBlE3QRrECRq+KlYIXhWhrhg6PnH0Y=;
	b=8rWIZuy9Czg0GpBmI54DlOnQ3Mb1k3DwIeVFwIBivdGPOOPcowSbglW9R61ocUM5SIiSoo
	+Uo1ldz5CZPFcOdZhKVgJe46ZyxrJYSrbCCJh7IhZORLmANqhDf8ByQl1S0Qi3qpN3lLOT
	RptwVqDbkyAg6Lhrmb7zgBO3eiFcJtE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GTrtWJ7W;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034861; a=rsa-sha256;
	cv=none;
	b=y9kKieaw70DKnFqHMTnfg+aO/g7Ck66SzcI5WqY+yu6idnY8wvriKJ6a+VWMuY2pPsuX86
	6M7pzLPTtXNPZI7UNRz3F3HgO/GdkcAJjECxNko8UTM+2fbmnI4l6Ivyrg5qa3qscRxs8P
	RPsiuU3VLVcnBKM/3vjuW03WObk5XVE=
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d7f035bc39so705408a34.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034860; x=1774639660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2YShPZ4Jwzd3oBlE3QRrECRq+KlYIXhWhrhg6PnH0Y=;
        b=GTrtWJ7W2GeXsZ0SfV7MnBcegtbvI/FIz3UbNRBTniXkffwg2Y3hHnZRi5Yb8rvCJS
         1NgIyh9RwJIAK/0m+tlfmNgB5RY3ZFFJSV0rlTXv2JVVXvvxSJVjRddTfh3LbrRgR+JN
         lSor0QqawNdm/f+bvq3VDofhvW9hbUpzdVmHxZp+h6zLSZtXhKZnowpq0MEJczD8Klxk
         77qp8CE6CBo+wS+BCL/9RusXr89l5ktcYhKxVGeMfFXfSVAj/NScdsW4K857U9MlE7mI
         44gUSFyoxrhhE1R8vTXtv+2XEvjfiqkTlsca99WHgeKuV7lSAtj52NWinTI1WScdJSEj
         h9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034860; x=1774639660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c2YShPZ4Jwzd3oBlE3QRrECRq+KlYIXhWhrhg6PnH0Y=;
        b=QWgaTN6JYfepoQdz8zfm8aP7vbGJnZnxjkltnp1wAL9S9Mn5mO1ocrz+7VAO9jDDkn
         y5ZLMvVaAp/l2EvxTC/8QvRCOq4AsKK5YjxnfRrjtfYZw1MgOZDH0L0ByNC2qz3Rjyub
         G25C3wAnIb6vJbN9siMVRXIt1aa+aUbGx3ALTpUF+W/h8H7a07+POdsgD/c356yjt72z
         ZnF2BpOgzfia7yjLmsAWKT5ObM+5eisuTKZn0Hpgjr5haowlE6XkWbNsF2F1+uAEOV+b
         r4pz99o6u/2wvdJlgLtKohl6qzQY0uDPhBiHUHobLST/ZIU9MXYuQStnnwI4/604KJGI
         f0Xg==
X-Forwarded-Encrypted: i=1; AJvYcCU9forhNVVQeRt+TED/cqoNBPvGWyLI2cZgneIrpC47Rm94UkpCYXbqTulD0sgYRyhHTLGxtWSEfA==@kvack.org
X-Gm-Message-State: AOJu0YzZicoxPjFkIwpr1nqWV/dQtsRcfMzTZVLNZnAyMpUllHT0IHIq
	DcTFjptmXO0luY2XzUqhYgsuTb4wpBDrP2z1nk/e0ncfILvMKSaKhEAZ
X-Gm-Gg: ATEYQzz0/tDkt2wohoXYORmp6lduWAfLb0QOTcL1VTJn6p8cDfJ5a45pVPEu9zpSqRI
	yQYCA1awjVtXsyrnS2L+jymV7+izLUC18zixD8xMkzpjRF9kMMQW2tB5xWrNmjRwlUls5e7b2Za
	08quZbN8R9HZ+mVgoACMFGet/uphxokQ+BJ4XRN1gwaI8sgLYGLv3vl1+8fLllunu3XOyadjxT+
	pphB65xH0C06T7odmL2aDoaW/KKHGTEiuwY3HmvPyxYnllQAQgWDizLW59G2awqw5/5uics+Tp0
	T/041pil1my3iT4afVXiS0Abbyx6d5wT/tzj9ACVG6dW0GIkV4BrrvR7lRrNZkXo+2qiNVHv8KE
	j0b1ECkNYQ++Sdog86Ax8OKX4Yut0LOP1QF3TBVhpHE/TQQjT9W4sHL2Fc1pIA797Fz4+3bPLxi
	A3+0vy/XzWP3l1/auof3FijStt99cpxE9zFSpA7wA9OypahkvUjHKh4MtC
X-Received: by 2002:a05:6830:2713:b0:7d7:f73d:bd7f with SMTP id 46e09a7af769-7d7f73dbde9mr1155806a34.5.1774034860392;
        Fri, 20 Mar 2026 12:27:40 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7fbee2c6dsm331772a34.1.2026.03.20.12.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:40 -0700 (PDT)
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
	riel@surriel.com
Subject: [PATCH v5 03/21] mm: swap: add an abstract API for locking out swapoff
Date: Fri, 20 Mar 2026 12:27:17 -0700
Message-ID: <20260320192735.748051-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6EA9216000A
X-Stat-Signature: 3kniyhkwqe6t9yao65k9sg4g6ajop3g5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774034861-562367
X-HE-Meta: U2FsdGVkX18IEuge6MQHAkYAKWD4UYhaWB4jeNoIVE4zPaYW8Ps7LhKzAMUkxfNPAC+TNol7BFpcMZ52XmqXvVbT/7jzj4I8uzzMIhfBUXyALenUOSn9JqR7ZTo+/5JAfF5HNIXT02u6h6A2cC4WL7UvIYxAFeiYVynmf7RluMHBLAxvPFrzlicZHSTm661QG5eRKK+SVorwQnjm7sKtQJyt4lUmOcrtQ3VOn/bD1OMaUhGPrQMuVb0/VUCwCyES9IzjmDtEaoYaepkXU6Ei/Hq6JImGlO1Zu8EL+p08w7yekoY7kkekXcDEi30lufWWGzaYlpHQP0SBPY2hVicCNmLaVEMhzTCaBtjcOUcn7fODFsS1TPlL7A9noOolSjlftmNWkJKx6xwQdyoRyGhBb6UBvvCZlpTawc3I1eYAUQ8/7l++q9n21MrZ2HJ+WlPJFwz2pg/DLXuSCyfOig+CeIeya6kYeaOmRKEv0bmf5aqTIV6AO1atB3sN9YX4BBftdPF8iNA2iv4K9hdW37RcKOxZ4nmvIfz5K9AyoK41Z362OBak5YDK66FnAe1CiE1PN4OKNm3L1owIyNgzJjNDX/Hy4jDfYBgvT5u6BF4uhVEfP21PRaLPS8V3k0vgBJVPTV8qgWb+wRf9RwVyAeD6Z/R/7+SrPdBEYzLeZA812K1SWjE0ivR7jVpq7YZPGRlxY+xb+RzpZOzl+56VOhEZ2dEXRXMO/gPk94y5rwVz+eLakNITKRjtLw44WjUh92OVVmlNiPduDAbwjhVnX6tVot3dX6IK3W17880+Zc+cPqsv5/qSBgxCXh6Hn3jCF6LfOraTutCZ9TzL3Vvb0ELo8ROOHWCYn1MpU4c4h8X66bwXyFxA4GaDk/4NwaBoC+WdbOtvcgiHbZcsQEZjaRrspjx3WkE7irFVshDGdlDoLBKcDGl/+tIyNBw50HNBDaiaBcph3gnT9UHEAW6qjN3
 lXuFyObb
 FqiWjioSU8OUJ2zaMvTyNdJsUHEe8nawZkI1C9biZkncH7FwWDRdckj9bq12N/Dgw1gjoqn0Wp2c/1z5mPJWBFcXkZ+GH1tM3j6+s9a588Ks5QezsU/BUvHcb05ZiBYHUuMT6jbShwbWFpkaIJJkbT6lEc9a8twgB1lXht15gOdecE8msc338KJ4+6pLXP6J5dQDmSerYAhsYU6qnTOFOEOx4D7CgdV+tU7AlkJC2Zwi2KCEpcyKK0ncwB2a50QcW5KpXF4dsMOm3lpeBFEfFsfraDQ2uNDQSzZiSl7pGRGPHAVv01skQ3DTrKqx0A9kZIQ6Pa0XgaA32bpeDq7lRycztC73o6inrMzsJlYLkooRK/zUPZ8g4+YQ+O0mLFapLsvcYNuIMExli4D/iPuslAUL2penZoWz6tFeZzZJYNpZrtNw+iMHsYAuNJENe1pUwC/o6kHXRQXCw7NxYiTpXMHj/DND/rRgZsPYLn6Fj5ADnzHnKZ5u41bo4WHuuH2Ve3v4AkYmtVxvmvSOSykFV0RdogGm9eWWyGcetEpJeSLJHfILahsPuQrl18kEJgLtMfHNd
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
 mm/mincore.c         | 15 +++------------
 mm/shmem.c           | 12 ++++++------
 mm/swap_state.c      | 14 +++++++-------
 mm/userfaultfd.c     | 15 +++++++++------
 mm/zswap.c           |  5 ++---
 7 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index aa29d8ac542d1..3da637b218baf 100644
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
index da360a6eb8a48..90031f833f52e 100644
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
index e5d13eea92347..f3eb771249d67 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -77,19 +77,10 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	if (!softleaf_is_swap(entry))
 		return !shmem;
 
-	/*
-	 * Shmem mapping lookup is lockless, so we need to grab the swap
-	 * device. mincore page table walk locks the PTL, and the swap
-	 * device is stable, avoid touching the si for better performance.
-	 */
-	if (shmem) {
-		si = get_swap_device(entry);
-		if (!si)
-			return 0;
-	}
+	if (!tryget_swap_entry(entry, &si))
+		return 0;
 	folio = swap_cache_get_folio(entry);
-	if (shmem)
-		put_swap_device(si);
+	put_swap_entry(entry, si);
 	/* The swap cache space contains either folio, shadow or NULL */
 	if (folio && !xa_is_value(folio)) {
 		present = folio_test_uptodate(folio);
diff --git a/mm/shmem.c b/mm/shmem.c
index 1db97ef2d14eb..b40be22fa5f09 100644
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
index 34c9d9b243a74..bece18eb540fa 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -538,8 +538,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	pgoff_t ilx;
 	struct folio *folio;
 
-	si = get_swap_device(entry);
-	if (!si)
+	if (!tryget_swap_entry(entry, &si))
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
@@ -550,7 +549,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	if (page_allocated)
 		swap_read_folio(folio, plug);
 
-	put_swap_device(si);
+	put_swap_entry(entry, si);
 	return folio;
 }
 
@@ -763,6 +762,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
 		struct swap_info_struct *si = NULL;
 		softleaf_t entry;
+		bool swapoff_locked = false;
 
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
@@ -781,14 +781,14 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
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
index e6dfd5f28acd7..25f89eba0438c 100644
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
index ac9b7a60736bc..315e4d0d08311 100644
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


