Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D4A4CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4EAF8E0008; Fri, 22 Aug 2025 15:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE978E0003; Fri, 22 Aug 2025 15:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7358E0008; Fri, 22 Aug 2025 15:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 971918E0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:20:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 414741DC6D5
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:20:59 +0000 (UTC)
X-FDA: 83805361038.28.971BEC6
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 69C24C0009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:20:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GGJpgUWB;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890457;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPC8fKY9lYOENGHM8BlxnczCD4bDvatV7ABAMC7FrMc=;
	b=z7A9EbbFAmyGDlbWP2f5gdIzWOwOeSOivyuaPd7Aj78OdE6vcWnDBNMLXgBQZg24IdxvTq
	1CU7rqJjp9MODZHE+uRgTc9T7RFxAj7XjCzHH+UtF3ivQ4V32pAto8UHPsFJKyGSPoyVVs
	RJKULs2yYw0h6FcX6vfNEAMzKTogTrA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GGJpgUWB;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890457; a=rsa-sha256;
	cv=none;
	b=NKpEsXXwLLSb77vMZvLUdCS5k0+SuN1VIGxCfyU4XanVsC6ke8huwrp7tN3R4ugZOeT58i
	ENjJesl7eFTD+H79vGaMbMDUl1Az6tFpn441/Ahfid3u9dVdrctJ41hn1o+TTv8aint5WY
	TTQF4GeOwftFmaPOH9rkP7t5fxSpyP8=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70d93f5799bso13978336d6.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890456; x=1756495256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TPC8fKY9lYOENGHM8BlxnczCD4bDvatV7ABAMC7FrMc=;
        b=GGJpgUWBSxtAP7peW6VE9sy1BZLfTM960ChI77e1JmGX1oPI8KnG0DFsREMpAzcg6V
         9UQ+ICvLLv8uXsD3HdR7RZsIYn/MJUy0HNs1hCGnVY96SJGcoHT/4RtPRY39OHF5Zj/R
         G5fvi+HmKDTCmaDCLPBj4CQNiiDRFq9xgA1F+hp3CThfqzJXRUU5ZJrbm+2rs0/me+ri
         75GMApNfkIzcwrN71LLS8w8Jd2LrlyZpf7dSuhYpUvbO7upNo3VGQYtT3L1VtpTXQn7Z
         fvpm/mU9OrJxa3vyvefkH3K8t8ay+/FdyfAD5+/Nvkx6PdJ8VopIHqLlKdp8rBj6GmNK
         0jVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890456; x=1756495256;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TPC8fKY9lYOENGHM8BlxnczCD4bDvatV7ABAMC7FrMc=;
        b=cfgi+QzWL6opo8dz6w+bk8JH5fyy71jzcXlt8Qgvoz3paxfOKoX6ZS78+GLDInrF9I
         nf50FROgRboc64qaAkXRmLt6AiqCiqyebCp+VDhWz4hofIBh+6AZOpmOPjrxBpOCANGE
         PK1qE0WrIC0DSIIZgXi5opPshyqk+JAZtErmrWyPz8F25b5GlvkfZSAt36b3DuJC2rey
         X8t+7qQCMrcG1BhdRqmXmwiOhwDxP1+FHreLE0QseTWMjd0SHTq6eNZH3Z8ydehRfHEk
         44MD0tKr9d1lQmYRXgdJWvS/61FiLXX2tXeJjBfYGN+9vQ0ayew8ffZydFtYvQ/nfhX9
         xIAg==
X-Gm-Message-State: AOJu0Yy5d1mfpupr843q/1bMU18B6wR46o43xSLpqk45eENrhfLZMSQ7
	/1Po1Jy7Gad64EAHVloK3QyGq/6GGQOSeihwVNgurICeMnmyuiwE2Dd0Lo0MunQh8Vc=
X-Gm-Gg: ASbGnculpTDxyuoaygWQRZqF+VnQQa7cZNx/MbRUqANhL9TGiJ9aDRyfaqP1XgXTcW+
	hme+l7vFP4FW9JHOBbqqVcUIpNnf13GyNPsPu0NeX6JwaCxwx81AtD3HWvr+e+ioijlTB0L5Stl
	mFZ0UOI+jh9gOfA4r+Lo7ZVcr4zAO90BM8Q9F+dnEokGkND4jgcGMBL1oVtpm9HEcBeyGlz9221
	qHnM8H8qzHNwBfXeoTCXM84EDYHVYvBEIT56BrTFtFc6+QLMf+zoVVBTOaWr7UqombkRzRfjRKp
	wRAYAcw0gBD0/PK285z7IwQsmKXuWPtFEffnS2SbQ2cGD2ptbLWMn6t61BvsqFDifNknUXoRxcI
	9jY9nEVrza+YDSd+pXLgMJ1NfCIvBwbVRNvxPl71JKzajpIayioZEYA==
X-Google-Smtp-Source: AGHT+IFercWRtfaBvKSiuBTbOi61gw/vYK89k9RSquXFYUj53lRFJ7gU9v1uG67cTWNGlGYoKenNsg==
X-Received: by 2002:a05:6214:3f83:b0:70d:a2f9:393f with SMTP id 6a1803df08f44-70da2f93ba0mr26749896d6.36.1755890456017;
        Fri, 22 Aug 2025 12:20:56 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.20.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:20:55 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 2/9] mm, swap: always lock and check the swap cache folio before use
Date: Sat, 23 Aug 2025 03:20:16 +0800
Message-ID: <20250822192023.13477-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
References: <20250822192023.13477-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 69C24C0009
X-Rspam-User: 
X-Stat-Signature: fiwdxgz5rrpowhger8yyswcihr3dttut
X-Rspamd-Server: rspam09
X-HE-Tag: 1755890457-104437
X-HE-Meta: U2FsdGVkX18pUQspIU8+bPoZ5wb1gp7tMOrn0UJdgAyKRgo/C4AgGB/veFKICC5t+HlwxgjMJhCYlHXvp75LRtL6hbjWANyieeik3qMQtEsudHJ7f8Gc2e1je6q66jWaihFX/djBrM5lrz4jyLBa2mINDdnAyC/V1V1SSZXhuRNr9OQYC4gW4wTrPrjSnUvyfwuZptBKRbfZNy9hhSzBDz4n2LxW0u3VNamjGBy+is+9nuqvfA9BIHM/e62iuP1a76djSEPEWjudihDzN2bwAukFYDxRC73/fDi4mB5Qm6+uPeHuNkO+1E0cOFwDD7iY/Z2EAWqh1w8UnvouVFzZoLuyMd467uYNrFAlzUI/egOGPlcFxR5O71D0+5EytDythL16tf6l/h0vs9Xpmnzf3JxLcy0l+d1P/HdQ4r602CcD+IkZNpe94wp5Q+Rz/b9oRmRHXIfaxDgy9Vy2FslDkl6ThCKYnjibu7WAqP6dp88p5uv19FbBDqF8yvXfCQPDpwAgBniKQhd3GbFfin5S95TsdNMQIp80jfgBay4ukBmEgICx9ICh/SiEg9Pc1DsG4hGTVkARO3xtBRvBoiYBMqgKvpQIIibQVmlVKM4Qsl1wFHuLKqWJ0NzKyFxS5HmLV7oiPpEPRmlYqtCLE2nS/Ja1VRrV8ZyBkiUzJoG/uyAyK0j75+/b3dJz4zc36u7ApStojqWFdFggucy3xN260EulQmHGgWJ4KIMArFZ7A4ShZtTbkBvzvZzenTuk+AYkuXiFpEdkZRTKA78jx8S8r5jB+e6rR7VytZBHsCKulTbg362M2oQQWSSkeRA9Whadlo+EFYjXKYChu3EKSAIRykpIbEEcC6j7w4nWN1YOAYY+xHrAHKEE0bBfOGG57Jror+4YQRkWyd3LdHJDrdPFXKe3QqpznoI6neJUn96UAW7LC6/0uMpQ7/zgtfAS3jKnICPd6v6qM+o4Qm8+bAs
 3iriXd15
 8wm9LKHANM5T4dxQXKUFAVGMAAwO7Fd0v4wBSbz0+w0t3a448S5bWNFb8Ee94osbmLc5r34an3/L3Wc6L7Q+6IBRv6vFy/qQF0Fa1riF8lDg3Ga6QPnyL2SAS99BajCoL0a3l9ShugzdZkMuL12BLlQbJHGoQgAvOlFlzdWmvkQ1poHENNOjUws/V7mOikv8EE/7pyG1utAQ2VTs3SNQkFzxwlxPP0tpFODrJO8Jrv+8QETAftyP9lmRsqPXM3s48c4PG2YYu7zUQh+2IysriZrMe4xSUbSTStsShLambjm1rmYXOTd7A+REJORJ7iHVinltc/m5aimfWJDjx7IBfs4o/H77aKN5lEJWq3N+8nzlTQVIzVDbMzqi8T8Or/WeRHL0FUTmkK62JbfhrLAGc6SnUQfSwgOVVKeGO86+qXzD279Tw3nmA8Su7mqgdeZl2bTtzahoTsE4Yfubec7XUW+U0GOVR0+XsEA7V2DcnRyWugBoAttRRMEl0/CgofAH4B4C9yteg/IUXii9HYO+hFXq9IWcGp+z2Szaeg+zDCxs7IB2aIQMk0CsRXz1vHgziBmapKFYWc4dDdZuIKL2j0zePScTkbF8Mou35
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cache lookup is lockless, it only increases the reference count
of the returned folio. That's not enough to ensure a folio is stable in
the swap cache, so the folio could be removed from the swap cache at any
time. The caller always has to lock and check the folio before use.

Document this as a comment, and introduce a helper for swap cache folio
verification with proper sanity checks.

Also, sanitize all current users to use this convention, and use the new
helper when possible for easier debugging. Some existing callers won't
cause any major problem right now, only trivial issues like incorrect
readahead statistic (swapin) or wasted loop (swapoff). It's better to
always follow this convention to make things robust.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c     | 28 +++++++++++++---------------
 mm/shmem.c      |  4 ++--
 mm/swap.h       | 28 ++++++++++++++++++++++++++++
 mm/swap_state.c | 13 +++++++++----
 mm/swapfile.c   | 10 ++++++++--
 5 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 10ef528a5f44..9ca8e1873c6e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4661,12 +4661,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
-	if (folio) {
-		swap_update_readahead(folio, vma, vmf->address);
-		page = folio_file_page(folio, swp_offset(entry));
-	}
 	swapcache = folio;
-
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
@@ -4735,20 +4730,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
-		page = folio_file_page(folio, swp_offset(entry));
-	} else if (PageHWPoison(page)) {
-		/*
-		 * hwpoisoned dirty swapcache pages are kept for killing
-		 * owner processes (which may be unknown at hwpoison time)
-		 */
-		ret = VM_FAULT_HWPOISON;
-		goto out_release;
 	}
 
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
 
+	page = folio_file_page(folio, swp_offset(entry));
 	if (swapcache) {
 		/*
 		 * Make sure folio_free_swap() or swapoff did not release the
@@ -4757,10 +4745,20 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		 * swapcache, we need to check that the page's swap has not
 		 * changed.
 		 */
-		if (unlikely(!folio_test_swapcache(folio) ||
-			     page_swap_entry(page).val != entry.val))
+		if (!folio_contains_swap(folio, entry))
 			goto out_page;
 
+		if (PageHWPoison(page)) {
+			/*
+			 * hwpoisoned dirty swapcache pages are kept for killing
+			 * owner processes (which may be unknown at hwpoison time)
+			 */
+			ret = VM_FAULT_HWPOISON;
+			goto out_page;
+		}
+
+		swap_update_readahead(folio, vma, vmf->address);
+
 		/*
 		 * KSM sometimes has to copy on read faults, for example, if
 		 * folio->index of non-ksm folios would be nonlinear inside the
diff --git a/mm/shmem.c b/mm/shmem.c
index e9d0d2784cd5..b4d39f2a1e0a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
-	} else {
-		swap_update_readahead(folio, NULL, 0);
 	}
 
 	if (order > folio_order(folio)) {
@@ -2431,6 +2429,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		error = -EIO;
 		goto failed;
 	}
+	if (!skip_swapcache)
+		swap_update_readahead(folio, NULL, 0);
 	folio_wait_writeback(folio);
 	nr_pages = folio_nr_pages(folio);
 
diff --git a/mm/swap.h b/mm/swap.h
index efb6d7ff9f30..bb2adbfd64a9 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -52,6 +52,29 @@ static inline pgoff_t swap_cache_index(swp_entry_t entry)
 	return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
 }
 
+/**
+ * folio_contains_swap - Does this folio contain this swap entry?
+ * @folio: The folio.
+ * @entry: The swap entry to check against.
+ *
+ * Swap version of folio_contains()
+ *
+ * Context: The caller should have the folio locked to ensure
+ * nothing will move it out of the swap cache.
+ * Return: true or false.
+ */
+static inline bool folio_contains_swap(struct folio *folio, swp_entry_t entry)
+{
+	pgoff_t offset = swp_offset(entry);
+
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	if (unlikely(!folio_test_swapcache(folio)))
+		return false;
+	if (unlikely(swp_type(entry) != swp_type(folio->swap)))
+		return false;
+	return offset - swp_offset(folio->swap) < folio_nr_pages(folio);
+}
+
 void show_swap_cache_info(void);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
@@ -144,6 +167,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t entry)
 	return 0;
 }
 
+static inline bool folio_contains_swap(struct folio *folio, swp_entry_t entry)
+{
+	return false;
+}
+
 static inline void show_swap_cache_info(void)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ff9eb761a103..be0d96494dc1 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -70,10 +70,12 @@ void show_swap_cache_info(void)
 }
 
 /*
- * Lookup a swap entry in the swap cache. A found folio will be returned
- * unlocked and with its refcount incremented.
+ * swap_cache_get_folio - Lookup a swap entry in the swap cache.
  *
- * Caller must lock the swap device or hold a reference to keep it valid.
+ * A found folio will be returned unlocked and with its refcount increased.
+ *
+ * Context: Caller must ensure @entry is valid and pin the swap device, also
+ * check the returned folio after locking it (e.g. folio_swap_contains).
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
@@ -338,7 +340,10 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	for (;;) {
 		int err;
 
-		/* Check the swap cache in case the folio is already there */
+		/*
+		 * Check the swap cache first, if a cached folio is found,
+		 * return it unlocked. The caller will lock and check it.
+		 */
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			goto got_folio;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4b8ab2cb49ca..12f2580ebe8d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -240,12 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	entry = folio->swap;
-	if (offset < swp_offset(entry) || offset >= swp_offset(entry) + nr_pages) {
+	if (!folio_contains_swap(folio, entry)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
 	}
+	entry = folio->swap;
 	offset = swp_offset(entry);
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
@@ -2150,6 +2150,12 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		}
 
 		folio_lock(folio);
+		if (!folio_contains_swap(folio, entry)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
 		folio_wait_writeback(folio);
 		ret = unuse_pte(vma, pmd, addr, entry, folio);
 		if (ret < 0) {
-- 
2.51.0


