Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA159EF3711
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218E96B0088; Mon,  9 Mar 2026 04:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD806B008A; Mon,  9 Mar 2026 04:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36E46B0089; Mon,  9 Mar 2026 04:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2CAB6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:18:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 920C61B941C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:18:00 +0000 (UTC)
X-FDA: 84525821520.14.EBACF5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AE67814000A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:17:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=to+JoEq0;
	spf=pass (imf23.hostedemail.com: domain of devnull+zippermonkey.icloud.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+zippermonkey.icloud.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773044278;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJX5gru+C8JccbwodX3heicCaeFlV7f3K3eEiwxxg5k=;
	b=LQtRkOYauO34JKWEYccMAkypizYey6pzSGMta5GGcUTH4kDRFPaZHA8rAWGBVqO+czFK1t
	9xj3oKr2BOhoZZ0+IltTj2TnXO5hGpagViXCQ/URUg/fsquECboOlfDyCx8MOK5l/mRsG4
	PXSjoFN3vOD23yFtdylOaGcG73vQC5c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=to+JoEq0;
	spf=pass (imf23.hostedemail.com: domain of devnull+zippermonkey.icloud.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+zippermonkey.icloud.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773044278; a=rsa-sha256;
	cv=none;
	b=LbmgUU3AD7/Z7C8mlAlirUpL4Nd8MzqMMQyU+3zR0Rgl3cS7KuDnFGManF2JkeXkiUUtws
	NtOB/Ay5ZsqZdNNknHSZESc1dgmrF+5Y9IVrY5MOgu6faP+LdJ7l+6RMxDyZc2G+6giYe9
	+dL9KD7mZUVoD75r3C60qoIiJxYAJ0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F16B60130;
	Mon,  9 Mar 2026 08:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A313BC19423;
	Mon,  9 Mar 2026 08:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773044277;
	bh=FT9VMk1KXYmFsJX8cVrdDaU8Ef7bUUwo2kla+ED6KKc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=to+JoEq06VZ2w/l7RiuUOWrInYOlHo/LJZlFNkjwcZJS6wwITSXonvp6yl5Q9eQSA
	 ssTcoVslnJRG41lB7kODqdf3NZOaG4s7e+sNHuXmLvNZW5snZIyD3YcJ14Myd+84Jo
	 vaH3Llg/ogB2sJwTmVzEjyyS4DP4MQOsDHghbIHAIQHC3HGzH8z9sUOQlmHk/bFd7B
	 RlocF8rVpAesSLcvUOGhXgzLeTvObiVWwT3wo8yOARvOBI3hs+j40uqw8tNSBtu777
	 wAktG6BvOiaqEM+dlWA0LLO7HAQQjN2cf8rNzmDoaUeIaq7y3B3EMp7A8I8s1ag+c8
	 JlffVfa9W2I7Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99012EF3711;
	Mon,  9 Mar 2026 08:17:57 +0000 (UTC)
From: Zhang Peng via B4 Relay <devnull+zippermonkey.icloud.com@kernel.org>
Date: Mon, 09 Mar 2026 16:17:41 +0800
Subject: [PATCH 1/2] mm/vmscan: refactor shrink_folio_list for readability
 and maintainability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-batch-tlb-flush-v1-1-eb8fed7d1a9e@icloud.com>
References: <20260309-batch-tlb-flush-v1-0-eb8fed7d1a9e@icloud.com>
In-Reply-To: <20260309-batch-tlb-flush-v1-0-eb8fed7d1a9e@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773044270; l=15615;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=hrfPhSLZZ+Rs47sneAPE3A+aMP6Jn54Z4Elam2hH+qQ=;
 b=fUmw9fFg8kt3KWtm2+E4vru0K1g6gu3U9xmpxMOL/reogAbxVlV3fpbzzCERza86X04XKFhtC
 VEZIwe1KMrjCfyLtZNomyGBfvdZ/yLy9FI8h+mzUEkEHPYh1tkSv0+I
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Endpoint-Received: by B4 Relay for zippermonkey@icloud.com/20260309 with
 auth_id=671
X-Original-From: Zhang Peng <zippermonkey@icloud.com>
Reply-To: zippermonkey@icloud.com
X-Rspam-User: 
X-Rspamd-Queue-Id: AE67814000A
X-Rspamd-Server: rspam08
X-Stat-Signature: 9y1eij4ft3wnejp4mw3dem31paaot1qz
X-HE-Tag: 1773044278-146337
X-HE-Meta: U2FsdGVkX19gN4eJq0cQbJv0QFaxgF+G3IcWa/u/gPr3hFpvM7rGLG3rrGJbUobBjBuh4agW7lgC8t4Yk37N9jFGl4lIhZwdJG/BtIqXxCTca4iGn+jpUpO41S/MdP6x5mynYb0Y7JKD7Xw3PcOuoYaC0Bd7pO0I+9jj1xMuFi1ik7Hl9wG4Du5xfOC/XwvjKFTLtTDq4QCIdiY/rxNDkF9fbv/hbDli34A6puv1rJh0ReYMdl4L29HCQ3khEGMMQwW9AuZKTcQuc0JJxwBA5ffzpi1CbBzJmiAuqHDexTjvmNeyTGX4LKh/m8pStctLxhy/dAb1NzZAzONI3PN/+LBLaDefoueZewz8XYIGLaQvh/00ndFSfhY+1weho9IdjM9A+4Ho9TsTF0zbsFOsQ/8LgrRXh0rRcObx9SHFYnIXTd2jytYQM9yXSO3I6mytjKq1w1XXIXwxFDFwDyoEg5pZzQoqHRZte+fz44FKiMTQUGLldWB9fIUbbIETkO51ZW6AhnDDSuP73j2Sf6qLFQS+qmY3SHDf5r10f54zv210J7D4W7TX+NoL64GAWS6R3CWCepWssDeHCdNXB4fNH/feRIM4BgdGmMlGuaZkglEhvgRCG6trJRn9RyoU3qPw3VbGCwepFTq1XbRP+mMVrYQ0Vwuc9Gk0pobL86TxTGXnwLp/91txnixQduyD1Fu58z26izFRdy1ONaEqC0FxD7FgWGp8A5pDAqv+ESBbPfdv2ByGjXXbbCcJGgJTOWt2OFixBh2q3REU+8MPanlvdb/IMu1SXKFLgUFMUsJXZU7mWPvcX8aQjGpsPozyukFhF5BbS3gnCXiKHozWAd+BpkFsX5yM0b4CHbov2GogHVMEXjJt1D6NTgJadqqWbU2HTgHyXmPP3Lt+8ASC0A8LqJRjJUwvBvZUePdIJo+YSjsu2OBH3N/jkc0DmSN3dFlHUfnSdOvFdkHNre16yLW
 HfCNGp57
 dzDIEoqEyh9rRR6GF6gFYYSCH+vtQxS/aB4l/AEZ4bLUsdsayQ6xaDDJ4yiGw6NyN7aoGjHzscN+Pa9Zgr684yTsp55tmfhvq6aIiLbWSXrZ4Vn51QxwCER+R5hey43WRSrTgbGOsHZvAmgsiQuNWcicbr+/zaztoYxhUIpIH25xQslUibNto6DF4krWs8HDDGKeeYkHSqsoOdYlPR4YcVPw5glXQlrx91KNK947etHIAfWAOVF1L/qgp9tzIpQ6oLGOMvtapZSM5Fkb8rpxUTRsHpE5jhQcbpni7m4nCPwOWzPHJ26A7LPI3Hfd7YNBQFY8Zouc18d9C2cF4JWEZh8R/PJzeBsmTqJ1onhj7hYRlADprxzBbEbnsCs/wodXv1mXBEHaPEfwMkb3DFJSlTOWPFkmTE5VXm0kqI3bGCHmHTJnh2qnv6RdYIfWfoytdfbiePBsIhiAx78JimXXoL6TDspgSb8MU+W1D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: bruzzhang <bruzzhang@tencent.com>

Refactor shrink_folio_list() by extracting three helper functions to
improve code organization and readability:

- folio_active_bounce(): Handle folio activation logic when pages need to
  be bounced back to the head of the LRU list
- folio_free(): Handle folio freeing logic, including buffer release,
  mapping removal, and batch management
- pageout_one(): Handle single folio pageout logic with proper state
  transition handling

Change shrink_folio_list() return type from unsigned int to void and track
reclaimed pages through stat->nr_reclaimed instead of a local variable.
Add nr_reclaimed field to struct reclaim_stat to support this change.

This refactoring maintains the same functionality while making the code
more modular and easier to understand. The extracted functions encapsulate
specific logical operations, making the main function flow clearer and
reducing code duplication.

No functional change.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: bruzzhang <bruzzhang@tencent.com>
---
 include/linux/vmstat.h |   1 +
 mm/vmscan.c            | 323 ++++++++++++++++++++++++++++---------------------
 2 files changed, 186 insertions(+), 138 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..f088c5641d99 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -26,6 +26,7 @@ struct reclaim_stat {
 	unsigned nr_unmap_fail;
 	unsigned nr_lazyfree_fail;
 	unsigned nr_demoted;
+	unsigned nr_reclaimed;
 };
 
 /* Stat data for system wide items */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3f64a09f415c..a336f7fc7dae 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1076,10 +1076,174 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
 }
 
+/* Mark folio as active and prepare to bounce back to head of LRU */
+static void folio_active_bounce(struct folio *folio, struct reclaim_stat *stat,
+		unsigned int nr_pages)
+{
+	/* Not a candidate for swapping, so reclaim swap space. */
+	if (folio_test_swapcache(folio) &&
+		(mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
+		folio_free_swap(folio);
+	VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
+	if (!folio_test_mlocked(folio)) {
+		int type = folio_is_file_lru(folio);
+
+		folio_set_active(folio);
+		stat->nr_activate[type] += nr_pages;
+		count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
+	}
+}
+
+static bool folio_free(struct folio *folio, struct folio_batch *free_folios,
+		struct scan_control *sc, struct reclaim_stat *stat)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct address_space *mapping = folio_mapping(folio);
+
+	/*
+	 * If the folio has buffers, try to free the buffer
+	 * mappings associated with this folio. If we succeed
+	 * we try to free the folio as well.
+	 *
+	 * We do this even if the folio is dirty.
+	 * filemap_release_folio() does not perform I/O, but it
+	 * is possible for a folio to have the dirty flag set,
+	 * but it is actually clean (all its buffers are clean).
+	 * This happens if the buffers were written out directly,
+	 * with submit_bh(). ext3 will do this, as well as
+	 * the blockdev mapping.  filemap_release_folio() will
+	 * discover that cleanness and will drop the buffers
+	 * and mark the folio clean - it can be freed.
+	 *
+	 * Rarely, folios can have buffers and no ->mapping.
+	 * These are the folios which were not successfully
+	 * invalidated in truncate_cleanup_folio().  We try to
+	 * drop those buffers here and if that worked, and the
+	 * folio is no longer mapped into process address space
+	 * (refcount == 1) it can be freed.  Otherwise, leave
+	 * the folio on the LRU so it is swappable.
+	 */
+	if (folio_needs_release(folio)) {
+		if (!filemap_release_folio(folio, sc->gfp_mask)) {
+			folio_active_bounce(folio, stat, nr_pages);
+			return false;
+		}
+
+		if (!mapping && folio_ref_count(folio) == 1) {
+			folio_unlock(folio);
+			if (folio_put_testzero(folio))
+				goto free_it;
+			else {
+				/*
+				 * rare race with speculative reference.
+				 * the speculative reference will free
+				 * this folio shortly, so we may
+				 * increment nr_reclaimed here (and
+				 * leave it off the LRU).
+				 */
+				stat->nr_reclaimed += nr_pages;
+				return true;
+			}
+		}
+	}
+
+	if (folio_test_lazyfree(folio)) {
+		/* follow __remove_mapping for reference */
+		if (!folio_ref_freeze(folio, 1))
+			return false;
+		/*
+		 * The folio has only one reference left, which is
+		 * from the isolation. After the caller puts the
+		 * folio back on the lru and drops the reference, the
+		 * folio will be freed anyway. It doesn't matter
+		 * which lru it goes on. So we don't bother checking
+		 * the dirty flag here.
+		 */
+		count_vm_events(PGLAZYFREED, nr_pages);
+		count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
+	} else if (!mapping || !__remove_mapping(mapping, folio, true,
+							sc->target_mem_cgroup))
+		return false;
+
+	folio_unlock(folio);
+free_it:
+	/*
+	 * Folio may get swapped out as a whole, need to account
+	 * all pages in it.
+	 */
+	stat->nr_reclaimed += nr_pages;
+
+	folio_unqueue_deferred_split(folio);
+	if (folio_batch_add(free_folios, folio) == 0) {
+		mem_cgroup_uncharge_folios(free_folios);
+		try_to_unmap_flush();
+		free_unref_folios(free_folios);
+	}
+	return true;
+}
+
+static void pageout_one(struct folio *folio, struct list_head *ret_folios,
+			struct folio_batch *free_folios,
+			struct scan_control *sc, struct reclaim_stat *stat,
+			struct swap_iocb **plug, struct list_head *folio_list)
+{
+	struct address_space *mapping = folio_mapping(folio);
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	switch (pageout(folio, mapping, plug, folio_list)) {
+	case PAGE_ACTIVATE:
+		/*
+		 * If shmem folio is split when writeback to swap,
+		 * the tail pages will make their own pass through
+		 * this function and be accounted then.
+		 */
+		if (nr_pages > 1 && !folio_test_large(folio)) {
+			sc->nr_scanned -= (nr_pages - 1);
+			nr_pages = 1;
+		}
+		folio_active_bounce(folio, stat, nr_pages);
+		fallthrough;
+	case PAGE_KEEP:
+		goto locked_keepit;
+	case PAGE_SUCCESS:
+		if (nr_pages > 1 && !folio_test_large(folio)) {
+			sc->nr_scanned -= (nr_pages - 1);
+			nr_pages = 1;
+		}
+		stat->nr_pageout += nr_pages;
+
+		if (folio_test_writeback(folio))
+			goto keepit;
+		if (folio_test_dirty(folio))
+			goto keepit;
+
+		/*
+		 * A synchronous write - probably a ramdisk.  Go
+		 * ahead and try to reclaim the folio.
+		 */
+		if (!folio_trylock(folio))
+			goto keepit;
+		if (folio_test_dirty(folio) ||
+			folio_test_writeback(folio))
+			goto locked_keepit;
+		mapping = folio_mapping(folio);
+		fallthrough;
+	case PAGE_CLEAN:
+		; /* try to free the folio below */
+	}
+	if (folio_free(folio, free_folios, sc, stat))
+		return;
+locked_keepit:
+	folio_unlock(folio);
+keepit:
+	list_add(&folio->lru, ret_folios);
+	VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
+			folio_test_unevictable(folio), folio);
+}
 /*
- * shrink_folio_list() returns the number of reclaimed pages
+ * Reclaimed folios are counted in stat->nr_reclaimed.
  */
-static unsigned int shrink_folio_list(struct list_head *folio_list,
+static void shrink_folio_list(struct list_head *folio_list,
 		struct pglist_data *pgdat, struct scan_control *sc,
 		struct reclaim_stat *stat, bool ignore_references,
 		struct mem_cgroup *memcg)
@@ -1087,7 +1251,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0, nr_demoted = 0;
+	unsigned int nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
@@ -1421,126 +1585,15 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping, &plug, folio_list)) {
-			case PAGE_KEEP:
-				goto keep_locked;
-			case PAGE_ACTIVATE:
-				/*
-				 * If shmem folio is split when writeback to swap,
-				 * the tail pages will make their own pass through
-				 * this function and be accounted then.
-				 */
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				goto activate_locked;
-			case PAGE_SUCCESS:
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				stat->nr_pageout += nr_pages;
-
-				if (folio_test_writeback(folio))
-					goto keep;
-				if (folio_test_dirty(folio))
-					goto keep;
-
-				/*
-				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the folio.
-				 */
-				if (!folio_trylock(folio))
-					goto keep;
-				if (folio_test_dirty(folio) ||
-				    folio_test_writeback(folio))
-					goto keep_locked;
-				mapping = folio_mapping(folio);
-				fallthrough;
-			case PAGE_CLEAN:
-				; /* try to free the folio below */
-			}
-		}
-
-		/*
-		 * If the folio has buffers, try to free the buffer
-		 * mappings associated with this folio. If we succeed
-		 * we try to free the folio as well.
-		 *
-		 * We do this even if the folio is dirty.
-		 * filemap_release_folio() does not perform I/O, but it
-		 * is possible for a folio to have the dirty flag set,
-		 * but it is actually clean (all its buffers are clean).
-		 * This happens if the buffers were written out directly,
-		 * with submit_bh(). ext3 will do this, as well as
-		 * the blockdev mapping.  filemap_release_folio() will
-		 * discover that cleanness and will drop the buffers
-		 * and mark the folio clean - it can be freed.
-		 *
-		 * Rarely, folios can have buffers and no ->mapping.
-		 * These are the folios which were not successfully
-		 * invalidated in truncate_cleanup_folio().  We try to
-		 * drop those buffers here and if that worked, and the
-		 * folio is no longer mapped into process address space
-		 * (refcount == 1) it can be freed.  Otherwise, leave
-		 * the folio on the LRU so it is swappable.
-		 */
-		if (folio_needs_release(folio)) {
-			if (!filemap_release_folio(folio, sc->gfp_mask))
-				goto activate_locked;
-			if (!mapping && folio_ref_count(folio) == 1) {
-				folio_unlock(folio);
-				if (folio_put_testzero(folio))
-					goto free_it;
-				else {
-					/*
-					 * rare race with speculative reference.
-					 * the speculative reference will free
-					 * this folio shortly, so we may
-					 * increment nr_reclaimed here (and
-					 * leave it off the LRU).
-					 */
-					nr_reclaimed += nr_pages;
-					continue;
-				}
-			}
+			pageout_one(folio, &ret_folios, &free_folios, sc, stat,
+				&plug, folio_list);
+			goto next;
 		}
 
-		if (folio_test_lazyfree(folio)) {
-			/* follow __remove_mapping for reference */
-			if (!folio_ref_freeze(folio, 1))
-				goto keep_locked;
-			/*
-			 * The folio has only one reference left, which is
-			 * from the isolation. After the caller puts the
-			 * folio back on the lru and drops the reference, the
-			 * folio will be freed anyway. It doesn't matter
-			 * which lru it goes on. So we don't bother checking
-			 * the dirty flag here.
-			 */
-			count_vm_events(PGLAZYFREED, nr_pages);
-			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
-		} else if (!mapping || !__remove_mapping(mapping, folio, true,
-							 sc->target_mem_cgroup))
+		if (!folio_free(folio, &free_folios, sc, stat))
 			goto keep_locked;
-
-		folio_unlock(folio);
-free_it:
-		/*
-		 * Folio may get swapped out as a whole, need to account
-		 * all pages in it.
-		 */
-		nr_reclaimed += nr_pages;
-
-		folio_unqueue_deferred_split(folio);
-		if (folio_batch_add(&free_folios, folio) == 0) {
-			mem_cgroup_uncharge_folios(&free_folios);
-			try_to_unmap_flush();
-			free_unref_folios(&free_folios);
-		}
-		continue;
-
+		else
+			continue;
 activate_locked_split:
 		/*
 		 * The tail pages that are failed to add into swap cache
@@ -1551,29 +1604,21 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			nr_pages = 1;
 		}
 activate_locked:
-		/* Not a candidate for swapping, so reclaim swap space. */
-		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
-			folio_free_swap(folio);
-		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
-		if (!folio_test_mlocked(folio)) {
-			int type = folio_is_file_lru(folio);
-			folio_set_active(folio);
-			stat->nr_activate[type] += nr_pages;
-			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
-		}
+		folio_active_bounce(folio, stat, nr_pages);
 keep_locked:
 		folio_unlock(folio);
 keep:
 		list_add(&folio->lru, &ret_folios);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
 				folio_test_unevictable(folio), folio);
+next:
+		continue;
 	}
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
 	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
-	nr_reclaimed += nr_demoted;
+	stat->nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
@@ -1613,7 +1658,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 	if (plug)
 		swap_write_unplug(plug);
-	return nr_reclaimed;
 }
 
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
@@ -1647,8 +1691,9 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 	 * change in the future.
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
-	nr_reclaimed = shrink_folio_list(&clean_folios, zone->zone_pgdat, &sc,
+	shrink_folio_list(&clean_folios, zone->zone_pgdat, &sc,
 					&stat, true, NULL);
+	nr_reclaimed = stat.nr_reclaimed;
 	memalloc_noreclaim_restore(noreclaim_flag);
 
 	list_splice(&clean_folios, folio_list);
@@ -2017,8 +2062,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
-					 lruvec_memcg(lruvec));
+	shrink_folio_list(&folio_list, pgdat, sc, &stat, false, lruvec_memcg(lruvec));
+	nr_reclaimed = stat.nr_reclaimed;
 
 	spin_lock_irq(&lruvec->lru_lock);
 	move_folios_to_lru(lruvec, &folio_list);
@@ -2195,7 +2240,8 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
 		.no_demotion = 1,
 	};
 
-	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &stat, true, NULL);
+	shrink_folio_list(folio_list, pgdat, &sc, &stat, true, NULL);
+	nr_reclaimed = stat.nr_reclaimed;
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
@@ -4703,7 +4749,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (list_empty(&list))
 		return scanned;
 retry:
-	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
+	shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
+	reclaimed = stat.nr_reclaimed;
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,

-- 
2.43.7



