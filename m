Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 825DECA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3B56B00A7; Fri,  2 Oct 2026 21:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8949C6B00A9; Fri,  2 Oct 2026 21:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CFE6B00AA; Fri,  2 Oct 2026 21:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB086B00A7
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:00:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2DD31A0894
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:31 +0000 (UTC)
X-FDA: 85279509462.27.5D02734
Received: from mta0.migadu.com (out-232.mta0.migadu.com [91.218.175.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0C141180006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.232 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjdRaDACt5UB6fF/sDSpygMIK46uz/tyz/dNDgrvY0M=;
	b=KUaMzz3ENQQpx2iHU8Xob/1nfaFqLeHOaYkeWHzVV6TAPzAL7uivTh5z9CxQ9Gjv8W7vEr
	d1sg7RPrEkoyaZxy7rHYdJnXrKOzD0+LeVJ4rmSB0tbYmxady2H2r5kq9ZQPp9PbZl6csU
	X4P2KT12uLzKRwYGaZ+J5SqX8WFIMLw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989230;
	b=deMqDMY/LTZliVwiYZ9mE5lKWiqp3Up8o6M5IMvyBP6GkFiZJsvmLwwZ52ZSYuI4VT1Gh3
	U28DbW9Vazw+hCjTzz7UqME6Le57HoKry/uBqd3dti8FpjshYV+UbZwGNqGGnecIcIdeuF
	Sh9wT2LJAcfm2R/3qOxHCAl2Uno4iB4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.232 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a96359e4dbd9a031;
	Sat, 03 Oct 2026 01:00:28 +0000
X-Mizu-Trace-ID: a96359e4dbd9a031
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 10/12] mm, swap: enable THP swapin for xswap entries
Date: Sat,  3 Oct 2026 08:58:58 +0800
Message-ID: <20261003005900.909710-11-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C141180006
X-Stat-Signature: 55mx15zsx7nm9guk1zgrj3cxisfk3dgz
X-HE-Tag: 1790989229-483154
X-HE-Meta: U2FsdGVkX1+z6tn1+1Af2fMgXgn+r4X234fc1cNbrGNRJRRz0XRC6UYap5hhXid/dJCM5ifUzCILcWI77cT8xKwmYUifRKdF+wGEuTFZ+BUizs5756V6oQ7YJ5+bZQ7D+ujknwlRWsL83oT9UYUwj6hXR/jnsmj/VwRB7OpZ5HtrvAtignrJ71qtWzXb/8qwUxY5lO5rA5q1ZlpxrPr2ZPK82jnM9VUa06UwGqDukRUzNvQpB+0O8y7FvMdeuOxDnecXjc43w+GPZjSVqCxfVd2Nug5AalbJDhFq43F5Pf9xfFO8X1PFdcfRYGf+VqthLKPLSIk//ijLod0smQUz2h+230QkQU8f/4IxFLZ4SfJft8CT5+xd49snoQdIOdYO6upduuL5MW29Qz+tHMov9azhqRXjNbwylyBYhZ2iEgPACF76GJaVgw8jc+bmra1tcQ7pweY7tcNPQUybVDazP8Y1qrI3yBUmL+o6bTB4mxZMpAT59F9x2rOJbaidldjXhopbgBY5FHDVkF70ewyVBUwJRedhDR0iB+pRu6XDt+4OWJLgEBdVFM9x9jly5VJAnFqPk9PYWTbbncXWvKi09Su1/dn/qz7ubHaZU4h3uV/EwvCUyPZNx4Z9/T1424Rn6RIKxTK/QYkCBT9rZUT735wueGEST9wB4nuKADs0Lu9MpIeaw2zScTIAQQHqS1UzwWxSbOCp9NTL65E/DZcwSfK2KyDQ7tu+w8SnIHBfxhAMK9cFCF3t1ztvR8evDW/V63biakTfGHQqFBJt33xprkgoz+waGG4EiZieFSo4ZXsLu4M7hW+SgiDlfr3Rdsh0vo1h/g9waa8b0OMU5naNqBGf3FLLPBSYZC1IAhwfeP3g9SHJOfVRYvr3WYMt58KIBbJqfmJhSU2mN5+YWY16HYafgzP7oT96i0BU/VSKBeTrIwDA3Mm1N/1wdhL8/blJYm424cjVaxcpM6Bs+/S
 PMhuxMmp
 JVoMNqnM7ppA9Evae4mmo7cB5XoJowc+CkfQAaCkK1ZsS9f6oaEnYocm86fPKppVTTUtQX5GzgHMywq1kk6Fegl8GRapRELkyICzncV1L9I6bcqxB7b+ChQAXMvWlSYKf5556fPSpDf7gHwLzhTX15EJAvooa/W0DqS7YRUvm5q4qNlT1m3JzSpMeapqHEnpW9dvjmVKf7K2Z/opCHvPFzWKT76kq94jl4qcWStJyA3FmRzByB884hCiFjvVVAt8iier73DiyALK+FocBhMvHBAgoJL2O68F7GaUDBepapOe1yBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Read a large anon folio back as one unit when all of its xswap entries are
contiguous on one physical swap device, instead of falling back to order-0
faults. The device is marked SWP_SYNCHRONOUS_IO, which is required for THP
swapin and also skips readahead, so no swap cache slot is pinned while
xswap tries to shrink.

A batched read is refused when its data is still in zswap or spans more
than one device, since zswap cannot load a large folio. It is then read
page by page and the fault retries at a smaller order.
xswap_check_backing() decides this under the cluster lock, before the folio
is allocated, so zswap_load() takes the physical path instead of warning.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/memory.c     |  7 +++++--
 mm/swap.h       |  8 ++++++++
 mm/swap_state.c |  6 ++++++
 mm/swapfile.c   | 36 +++++++++++++++++++++++++++++++++++-
 4 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1f83a26f8733..6fd9258772ea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4833,15 +4833,18 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	if (unlikely(userfaultfd_armed(vma)))
 		return 0;
 
+	entry = softleaf_from_pte(vmf->orig_pte);
+
 	/*
 	 * A large swapped out folio could be partially or fully in zswap. We
 	 * lack handling for such cases, so fallback to swapping in order-0
 	 * folio.
+	 * An xswap entry is deferred to __swap_cache_add_check() instead.
 	 */
-	if (!zswap_never_enabled())
+	if (!(__swap_entry_to_info(entry)->flags & SWP_XSWAP) &&
+	    !zswap_never_enabled())
 		return 0;
 
-	entry = softleaf_from_pte(vmf->orig_pte);
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
diff --git a/mm/swap.h b/mm/swap.h
index 9f04c8486b98..628395885919 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -477,6 +477,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci, unsigned int slot);
 swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order);
 void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order);
+int xswap_check_backing(struct swap_cluster_info *ci, unsigned int off,
+			unsigned int nr);
 #else
 static inline swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci,
 					     unsigned int slot)
@@ -492,6 +494,12 @@ static inline swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int or
 static inline void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
 {
 }
+
+static inline int xswap_check_backing(struct swap_cluster_info *ci,
+				      unsigned int off, unsigned int nr)
+{
+	return nr;
+}
 #endif /* CONFIG_XSWAP */
 
 #endif /* _MM_SWAP_H */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c5c182489d6a..56e4879abc93 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -194,6 +194,12 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	if (nr == 1)
 		return 0;
 
+	/* A zswap-backed or mixed batch falls back to a smaller order. */
+	if (__swap_entry_to_info(targ_entry)->flags & SWP_XSWAP) {
+		if (xswap_check_backing(ci, round_down(ci_off, nr), nr) != nr)
+			return -EBUSY;
+	}
+
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
 	ci_end = ci_off + nr;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8e005e8d2250..8e6b0cb899e5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4454,6 +4454,36 @@ swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci, unsigned int slot)
 	return (swp_entry_t){ .val = xs[slot] };
 }
 
+/*
+ * A large xswap folio is read back as one IO only when the whole range is
+ * backed by one device, contiguously. Returns how many leading slots are.
+ */
+int xswap_check_backing(struct swap_cluster_info *ci, unsigned int off,
+			unsigned int nr)
+{
+	swp_entry_t first;
+	unsigned int i;
+
+	lockdep_assert_held(&ci->lock);
+	/* A folio's slots never straddle a cluster, or the walk runs off. */
+	VM_WARN_ON_ONCE(off + nr > SWAPFILE_CLUSTER);
+
+	/* In zswap, which cannot load a large folio. */
+	if (!ci->xs_table || !ci->xs_table[off])
+		return 1;
+
+	first.val = ci->xs_table[off];
+	for (i = 1; i < nr; i++) {
+		swp_entry_t cur = { .val = ci->xs_table[off + i] };
+
+		if (swp_type(cur) != swp_type(first) ||
+		    swp_offset(cur) != swp_offset(first) + i)
+			break;
+	}
+
+	return i;
+}
+
 /* Cluster lock held. xswap never unmaps a cluster below the mapped prefix. */
 static unsigned long *xswap_xs_table_locked(struct swap_cluster_info *ci,
 					    gfp_t gfp)
@@ -5345,7 +5375,11 @@ static int xswap_create(int prio)
 	maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
 
 	si->bdev = NULL;
-	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE;
+	/*
+	 * Reads are served from zswap, so no readahead. Only a synchronous
+	 * device can swap a large folio back in as a unit.
+	 */
+	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE | SWP_SYNCHRONOUS_IO;
 	si->max = maxpages;
 	si->pages = maxpages - 1;
 	/*
-- 
2.54.0


