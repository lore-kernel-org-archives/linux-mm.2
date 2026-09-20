Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A46FC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A85A6B00A4; Sun, 20 Sep 2026 03:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77FA56B00A5; Sun, 20 Sep 2026 03:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BCFC6B00A6; Sun, 20 Sep 2026 03:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48C156B00A4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:22:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8A381A03E5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:02 +0000 (UTC)
X-FDA: 85233296484.03.C66C407
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id E24C1100003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888921;
	b=XYMlrDs10tvG3Z/NhLN5fIKqVmltEGCybegGmXGyrPMYDqfX6XHANcRTNJjDvqKQa84akT
	jwy1SJbN3FHgmv9u5i43lNWnW2ZszaaX18N1VqAMiC3UAtEKLJ8Hmg7fFbA2xN8cJ9IW+P
	hEP/MdIS6VTmm5sQLx/APLgPt8tUjHM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jl9MWTRKxbgshMS0tfjX4bc7m/Wp5MjpIlTw59y5bpI=;
	b=StnaPaXx7WjvwEWjaIaeXe9h02e/OdLxUsQmbIQQ7ShdSKqvja1xhA2gD5vk+4wYYUQqp5
	DrV/dxFGG6SvUJI+I7T2L7GUxtPBmNC0+p/0wTslT/yshe3jGY2vXAfFD0FQCMLyoKOi1f
	1YMhyCGyCFsXXOczbtfP67Kabp3f/JU=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d420a654e56a550a;
	Sun, 20 Sep 2026 07:21:59 +0000
X-Mizu-Trace-ID: d420a654e56a550a
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
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 10/17] mm, swap: enable THP swapin for xswap entries
Date: Sun, 20 Sep 2026 15:20:36 +0800
Message-ID: <20260920072043.430390-11-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E24C1100003
X-Stat-Signature: dm554f8bmfx53firtnn1jxikz79pj4u6
X-HE-Tag: 1789888920-687622
X-HE-Meta: U2FsdGVkX1/fnDzYRGcqjBZq54ftQfOXqJhIiIKukU4m1H7uq2vOaU1G6gN4iEyKBaGli4zZ1KL3kdYK+0u620BhDM9Zvwrlg2egNTYwRy8o0ZOLDOc27jKa1EbLGq4QSBl0mQvlcrpszCy5gYvoQIFukgYnHNWgMLVnG/bKCUAmGJJJocVURb0cnnGzsyMfW8zo2+og2e2Bqm5hq0dHHomWD+zWARRor4NSY3lgjZvkHaYtUMhco6/NmSS7buH6GRfDH4gO9LG7Pr/XLVoN4jSdlea1Sm6MEdNvSP2dGVAWqZCJ0UFTu+4/Mn6gVLEBJ82QYPPLLUajUy8mBtmcFOmbAYjklA46CCz6pLzNblmipNr3EbZsrXR6xczdQDJA1JOgN9dtY2BBdQ7YdEnB1se1bNeF7ZRlu+u4sIwAau2FnmRT9AfNykL3n9gtkk5t4qY+8xqqjZ66mzkTsISfsOCxUvVcpuM01djRpTlxvfUMIFZCA2jOkX1GGDTACELhoADPydo/2tMwxHmvHeP3O+rLPiYr0GBr7Q0TIVa/dedA72FoapJjFaNa3KnT38Oo0/937PJ9NnMFrNp8u9LzMgZXA8UkAZNN7QhfRAT6srba/X/Vpw5YX8qd26J72Nt09t5i9GmEdgO8eB4+qsnuSxwzuna3SuL3A5mG60Y2Uw7Eh86EyjBsONcojq77wX+9sIq8h5XfZjvlPPa6LRAOBYy+DYzIc+iytL/CeXnbpDFheHnV9inXgVL9EEoS2HdCHX/ErqCfgDO6HNkL90hi4pp9N+3PXS2slylFPC3nS0YnxTLzv05ALI7GfkJyjLutUhkR5r+PektmhQlma5D0HqKDtgcsfJYvHbOSZ0I2/hCz5l2Buwf/Rf50L+wGiWFpb1hEqcohsWeVoj5nCxMCC1av1i30MxErYbTK0iRm6j0zQGXcu9/FqRGS7DsSLqCx1QeIj09fGYvsErwGS9Y
 XqxAywxe
 Y4qzVstkJwy5kHU9MDYQ68z+F542HkitCY911SCgaFN11UvpzrmSXAMXSKSRVkvxIYSpidSSINmmbJD72yAmtvTZOk+kxrOLh4nt+ECe8vqP0KmRCkc4UYr393cVMQHR/1DFVryyND1mwj6j3mw0B4ynVbPWKYyn76FSxTClYl9jOS4H20Dw6Zg1PX0Quo4J/pT+3qLi8zC4ADXTUQDWv8Kz5BoimAuE0d3GzOg3BHfpWVNknEpP9M+wkj5DOlp7sf1NE+F2NnYh2xvdM2aQMIwWLUSI5803ZdPiHT9foT9pKpXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap a large anon folio back in as one unit, instead of falling back to
order-0 faults. This needs all of the folio's xswap entries to be
backed contiguously by one physical swap device.

Otherwise the folio is refused and read page by page. Its data may
still be in zswap, or the entries may span more than one backend
device. zswap cannot load a large folio in either case. The fault
then retries at a smaller order.

An xswap device is marked SWP_SYNCHRONOUS_IO. Its reads come from
memory, so readahead is skipped. Skipping readahead also avoids
pinning swap cache slots that xswap wants to shrink.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/memory.c     |  7 +++++--
 mm/swap.h       |  8 ++++++++
 mm/swap_state.c |  6 ++++++
 mm/swapfile.c   | 34 +++++++++++++++++++++++++++++++++-
 4 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..c08ef143b8f1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4772,15 +4772,18 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
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
index 4fcbb21a583d..990accefd3b6 100644
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
index 135d9573a9dc..112ab952fa0c 100644
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
index 4d72c854c7b3..852f10642b99 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4164,6 +4164,34 @@ swp_entry_t xswap_slot_backend(struct swap_cluster_info *ci, unsigned int slot)
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
@@ -5066,7 +5094,11 @@ static int xswap_create(int prio)
 	nr_clusters = DIV_ROUND_UP(ram, SWAPFILE_CLUSTER);
 
 	si->bdev = NULL;
-	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE;
+	/*
+	 * Reads are served from zswap, so no readahead. Only a synchronous
+	 * device can swap a large folio back in as a unit.
+	 */
+	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE | SWP_SYNCHRONOUS_IO;
 	si->max = maxpages;
 	si->pages = min_t(unsigned long, nr_clusters * SWAPFILE_CLUSTER,
 			  si->max) - 1;
-- 
2.54.0


