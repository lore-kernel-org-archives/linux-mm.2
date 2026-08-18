Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6AA6C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3CB6B0259; Tue, 18 Aug 2026 06:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC2A6B0469; Tue, 18 Aug 2026 06:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC11E6B046A; Tue, 18 Aug 2026 06:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5D2A6B0259
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:08:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4949D1C204E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:37 +0000 (UTC)
X-FDA: 85113965874.27.E8CBB0E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4BCE11C0005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tE21RPI2;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787047715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9KuxdbMXarhzOqWryoLJREjzAVULu+8jNKt/2uhZrc=;
	b=ijQ+13aiFjHq4yiDx7htnFYI3p4CKqyytsvbdYIeiORVtmcwhVKkd7y2un+6Q4qJ9nl+aK
	lZYvC6cL0ySXCH4dqJLLCTZMQN1hp1cZldRb9O2hpPV+alLwoQhYHnbV0X7rJCLqEjHJy8
	22mBkTsbcYjc4zkuCZ3QpfY11mp1t4A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tE21RPI2;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787047715;
	b=VSyoCq17h3ENOMP+kMY7zRjoPfPajX81uvDhLVPVX1MjSe6SoSJFeopzSk60bv/DQkhKLq
	YtW7wjUpYgiEfiGNhltha7scMo+RFsFuwlG74xW83zxV3+hgxes8WwppF7DiujnDuzaB+3
	c7LTzjOZ/u84y3JuzwlKp0Fa4FypGvM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=G9KuxdbMXarhzOqWryoLJREjzAVULu+8jNKt/2uhZrc=; b=tE21RPI2vktLk0uTk2t0g+KUU2
	6XNkmTbilLx3CArimV0Kn3yV6z5SPduqZqUqQitICJAivYHuLBHzeR15ghsNe+7YFnNz4XdH7abte
	QkopcDpnICt/YU1rlo7lQqrdSXalKIGxk4spjGLeePTda/LKdOolR1k4pQ39eAnr9m/ZB4Tk4gazp
	Bq6KUZwghm5IOIhGhbjf8Xntk8dL8ASKTrAlFrNdvyJrhtxpxe2BNOz1zcAanPUUhT16WCeF7aHVn
	7Qe7fBmuEJdgOeGRHCGUk5s+fUkseXBPgEBuYctxuYevOu6mPXPY5qt4fm5kKTO3m084xa+l/AJQl
	NnK5kq1w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wwGk1-008wGT-08;
	Tue, 18 Aug 2026 10:08:21 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 18 Aug 2026 03:06:23 -0700
Subject: [PATCH v3 1/2] mm, swap: distinguish a malformed swap entry from a
 dying device
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-swap-v3-1-d3fa52598a59@debian.org>
References: <20260818-swap-v3-0-d3fa52598a59@debian.org>
In-Reply-To: <20260818-swap-v3-0-d3fa52598a59@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6257; i=leitao@debian.org;
 h=from:subject:message-id; bh=YAGrMLLCUasxDttA7eyHnCoI15R8kt2N/zq1pMcZSZM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqhC8HOtBiM0iguv0eeUSXDTd55DYPFmgOsnGpS
 xdL87D89yqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaoQvBwAKCRA1o5Of/Hh3
 beE+D/41At++CwJ+00eHB2rsH+6LnmclU55BnvqWAfWdwE8FNybwh21lVFRdDHgFwM7qJ+vNGma
 WMGtADyxG+UC7pmCnA7Lcn+6jVPloKif95TBWbomexE1KBGTL2vkGjCxAXB0DYP4l/Bvf9W7O96
 zH7O+juAPpoise6f0EVIzeFnmrVbX52Povx/G9Lneml+V17fwaFWDYrgc1aujiY+9AZiY1GPDoC
 U8b9bhQVzUnx8/cGs94iODqqCW7Tn+9SOqj8GTJoUY3fRD3SDyD07uMZFF//f+KmJVlJ4o4ZcsD
 2M7BBPJwxpf4pff8ZEMC4SACf5VSip/DV7vJmbsUy3V4T2cspBFSt0ca6H5VyQyTLf4gJDd4z6k
 SJLxSCIbcJ23yr5kTgB+86v7GAAlCIrOfed/yuQkr0SxdpmQozGOaa5+5ChtaLfE1hOwH9xUL3a
 R7OrsAmHymD027cM8QQGzWoBR9i1xrA7qbgoKVQYCJ98m5M53VkxziDKGV69QNfvU0klQ4C6F4W
 2JIhKWGnGDnGayIIcUa4HoTcxbkOArLeKTClci6esFVoI1gq3ySpM5uXGIBtR3PQScQcPBaFzTd
 Ooovj9k1uxj19+axmXXoNrEHVDf1VXdZJPDBijGUj9OelkBTxV8DGkuTyQRA+n+z2n6xYd6F9Km
 Z9kSbPaSAiOzWAA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: teyagkfugkz5rxzkxrmdjcrfcqre5zbi
X-Rspamd-Queue-Id: 4BCE11C0005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787047715-264309
X-HE-Meta: U2FsdGVkX18gVSMrvlLbaiFmPKORUVWX2u8f13/upbb7kJIwIPYL9Cw5JdHB8lxcT/W37erQMB4FQNHyJa3PLWCwgTqhzLJJvRrqCXxHYULp6Zzef8rSbDPCA3Q4VI96YwM+2QgaEPfd1+XkrlSbMXwLZgbuKDVplM1hJGy3w5SgIjUG3KUlqP5cqXsv8voiA4YMmLO11Bcd+GW4od8zB2908qzPPmdSah671AcmT8OFnlTxe/MgjKbtejeLSGenMhiHN+dVaUz0hUPTKpZ2h8ZRO92pNjKLa0VF/Ao7LG1xkNQ1llbw5JnggPubqHqocTqRuL6wdQLiXtnqAaE8yasN05Dxit/SBBKaqnsg+YiqRhp1IdKFXLFXBlPG2cYlo7IFPGKeSi26wimwfSsA8SqQnm0SijExFny6E+xE6XdZbAs9EueqQzIRp+X0ZJmCS8hfN24XmDmFVj/kSOnC0e3GwoCMgMSZFF87EJ+MPEyPT18pTO4wMfHxEwvd1v4CVY7ZxEdMzAn3qOP2lSWQuI84CbqMFphy32WXsfM2DYN8I55s03twYM9Pv4QfwVDLItJMKAC29P4u//egsguXodNahAhhiiwXgU4CNhHjczJVzYm/fnfVLAmSjYrux8/TYzcCTDiOWI3Ag9grE6ajEIIq5JTygRARH21xCX6BZZOQ8g6hL8CBjJLAZFOMQX2EZyperez3p8zztRmNgkF0v3Zk8Vup6dbxKCQ10uWl67O9tu+IFZzF8ncpdpxJWfJsx+F4E7KnKdSVimJLsP4U+DwpTZQBzmR9/CUlHZmNd96P3ra9cegdEES6iWSBG3/g7211PGbLKanSrT6VqByvzSbvEudaq7nAunCifQqehLIU9x2T3GTuxD2EKFQVY3y+hh1qHFanqha+kPBooW8x9TrOzyK2ve8iSkDz9CS/8x2uXq5x+3hN8m2Pn2qJq5BPiPYHkqDzhZh5fJZzsoQ
 jQ0HQev9
 GeBHjR1xSjuOalvv44sAbIXCXhqgPF42RtkZnkt5ncuFvGi21vv5gNiuXlexN+zPjpVtcrXQ/H6tCWYIF+rab5YbZWNMxlWzNGz80BhYjRPp+PFaKAxHpfmCVjGnq+cI3jEIQn4YKQWABgXkelEXkosUwt4E6UosqUKYAQZfcsRl3PhY0mg6k4rjUEeLnXbApAN21fJUm+syf/atJ3StTIdisDeIuuvDr1NJ3MY2OcN23Ot9uQw0izt2xqp4ygv6DPTybuDUtwuqZyKaJ2Ddret6nqBjWR0Z84XNMSyJikE4IXh0VKRB3d7qEMqY+rQNwDj3Af9XIZmPgsTINEZk+IMg9gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_swap_device() returns NULL for two different things: an entry whose
type names no swap device or whose offset is past the end of one, and a
device that swapoff is taking away. The first never becomes valid, the
second does, and callers cannot tell them apart.

Return ERR_PTR(-EIO) for the two malformed cases and keep NULL for
swapoff. copy_nonpresent_pte() already reports -EIO for an entry whose
type names no device.

Callers bail out on failure either way, so switch them to
IS_ERR_OR_NULL(), and let the two paths that drop the reference skip an
error pointer. No functional change.

Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory.c      |  6 +++---
 mm/mincore.c     |  2 +-
 mm/shmem.c       |  2 +-
 mm/swap_state.c  |  4 ++--
 mm/swapfile.c    | 14 +++++++++-----
 mm/userfaultfd.c |  4 ++--
 mm/zswap.c       |  2 +-
 7 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d9cf941967cf0..03d8cf111d0be 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4954,9 +4954,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out;
 	}
 
-	/* Prevent swapoff from happening to us. */
+	/* Prevent swapoff from happening to us, and reject a bad entry. */
 	si = get_swap_device(entry);
-	if (unlikely(!si))
+	if (IS_ERR_OR_NULL(si))
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
@@ -5266,7 +5266,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
-	if (si)
+	if (!IS_ERR_OR_NULL(si))
 		put_swap_device(si);
 	return ret;
 out_nomap:
diff --git a/mm/mincore.c b/mm/mincore.c
index ff4ac82817683..c086836bc4bcc 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -71,7 +71,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	 */
 	if (shmem) {
 		si = get_swap_device(entry);
-		if (!si)
+		if (IS_ERR_OR_NULL(si))
 			return 0;
 	}
 	folio = swap_cache_get_folio(entry);
diff --git a/mm/shmem.c b/mm/shmem.c
index 65572cbf1bd3c..d0a9f52bfed71 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2276,7 +2276,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 	si = get_swap_device(index_entry);
 	order = shmem_confirm_swap(mapping, index, index_entry);
-	if (unlikely(!si)) {
+	if (IS_ERR_OR_NULL(si)) {
 		if (order < 0)
 			return -EEXIST;
 		else
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4b7a3303c463b..f2e86d6626ecc 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -715,7 +715,7 @@ struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
 	struct folio *folio;
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
@@ -951,7 +951,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		 */
 		if (swp_type(entry) != swp_type(targ_entry)) {
 			si = get_swap_device(entry);
-			if (!si)
+			if (IS_ERR_OR_NULL(si))
 				continue;
 		}
 		folio = swap_cache_read_folio(&ctx, entry, gfp_mask, mpol, ilx,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4d4e3e3059f6b..3b1883930e943 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1504,7 +1504,7 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 	unsigned long offset = swp_offset(entry);
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
@@ -1859,7 +1859,10 @@ void folio_put_swap(struct folio *folio, struct page *page)
  * Check whether swap entry is valid in the swap device.  If so,
  * return pointer to swap_info_struct, and keep the swap entry valid
  * via preventing the swap device from being swapoff, until
- * put_swap_device() is called.  Otherwise return NULL.
+ * put_swap_device() is called.  Return NULL for an empty entry or a
+ * device that is going away, and ERR_PTR(-EIO) if the entry's type
+ * names no swap device or its offset is past the end of one. These EIOs
+ * are preceded by pr_err().
  *
  * Notice that swapoff or swapoff+swapon can still happen before the
  * percpu_ref_tryget_live() in get_swap_device() or after the
@@ -1900,12 +1903,13 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return si;
 bad_nofile:
 	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	return ERR_PTR(-EIO);
 out:
 	return NULL;
 put_out:
 	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
-	return NULL;
+	return ERR_PTR(-EIO);
 }
 
 /*
@@ -2001,7 +2005,7 @@ int swp_swapcount(swp_entry_t entry)
 	int count;
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = swap_cluster_lock(si, swp_offset(entry));
@@ -2127,7 +2131,7 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	struct swap_info_struct *si;
 
 	si = get_swap_device(entry);
-	if (WARN_ON_ONCE(!si))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(si)))
 		return;
 	if (WARN_ON_ONCE(end_offset > si->max))
 		goto out;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 24a4d92ffa3c2..cba5e20a641ed 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1700,7 +1700,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		}
 
 		si = get_swap_device(entry);
-		if (unlikely(!si)) {
+		if (IS_ERR_OR_NULL(si)) {
 			ret = -EAGAIN;
 			goto out;
 		}
@@ -1757,7 +1757,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	if (dst_pte)
 		pte_unmap(dst_pte);
 	mmu_notifier_invalidate_range_end(&range);
-	if (si)
+	if (!IS_ERR_OR_NULL(si))
 		put_swap_device(si);
 
 	return ret;
diff --git a/mm/zswap.c b/mm/zswap.c
index f7c9c89f6449c..bc9b931d6f447 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -997,7 +997,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return -EEXIST;
 
 	mpol = get_task_policy(current);

-- 
2.53.0-Meta


