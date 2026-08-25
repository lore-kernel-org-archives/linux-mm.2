Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE17C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA676B00D7; Tue, 25 Aug 2026 09:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2336B00D8; Tue, 25 Aug 2026 09:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D98A6B00D9; Tue, 25 Aug 2026 09:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 638456B00D7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:54:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE17C120454
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:54:34 +0000 (UTC)
X-FDA: 85139936868.22.A871A1B
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by imf30.hostedemail.com (Postfix) with ESMTP id D6DC280007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:54:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XNF3YZfLaqg7Zbwd/w+li4n1E+o4c3AB1KA87rhZtPM=;
	b=m3CMTTEp+QvLsk3t2kgWE2fFslZiiUBPAIyLNWWNXLXIRiqpYcMUQQGQgZUG6pzUgL7Cjg
	yvdvrSFPMnR4bQieA8DU9wF9hfOmQdZPMDqvdkGDIs+/pDNrk+x+zVnh3RnFaKNa2m5ZXw
	pUP43ki5uvNC3gW2mWK5ulugmx418rk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787666073;
	b=IbeSHSzFKNIK81wMlz23PSZKt22UcMWDv7Sr+mANdUxZab/lW1WQH4iybHU5kvDv8mAt7T
	ZkzSwTfekwhc9gAGWd0RCGaN2lLGZqi08OmoaUy/4YJOSGD+Krqcq1Zr1Ol/Zeaw9Lbc6Q
	GqLDYTnsfdHitoVKSGeWptffOQ1FktY=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 5E0683EDDC;
	Tue, 25 Aug 2026 13:54:28 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v4 2/3] mm: swap: drop dropbehind swap cache folios on writeback completion
Date: Tue, 25 Aug 2026 15:52:06 +0200
Message-ID: <20260825135209.3135169-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825135209.3135169-1-alex@ghiti.fr>
References: <20260825135209.3135169-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTE5yRoPOtXaeVjz9nQYgYdgB2auKAdjCUIr5fKYD4tdDaE1rs3LHZQc4Y+i/VGPnn893m6ZXKNvOHjIpP0WvxT1xRkSxTAmSD74k5h/QvYA5e/Qd5Qp+C+1l/DaTi8AhfimOpo9Hb/M/tYAzEgQ8mJpPSqgcAOHSEeUKAFK6+Jfc5ACHK4WH5T526qhUWIUJwtcTcKZAD6bevELJuJmneh86u1cgECUmL27fSiv7RBksWh3FxjVFmXOYZkitH61oBWQZOvCWZXxb3FwYRES+GIVDfBZysSnq4f/n5MyAXRWt/BFEaqWacVR1vTB2r/AICAplFmbCabDE651DW+YI5R0MiadWc/QraQBB74Gpzn/mui0X/sfjIUwnOZiGiD6R9fjMzia+THvV3eU/pqFJcpa5AiOFBG7jHRqE7m2M0nde/lddf0N/IO9jaAllKtNcpNxHET+eJ2HLgOeurGb3ZJymrfTO5WLDVNy996zV/T9LQt67lWKEZKmb70WvRn5+mEAuJO6NVCNGSofgxM8MpPpSm0bu9a/u8pkn/UPn/Lu7q33O7Kfz64jozefevC9CxyGbgFBTI7CkFDYcLh9/ht9LiQzTzQoSslVYP4S6WdSWnmp2sF/0X6lOPGUqp/GMYUlDpILRmIDABSzGBb8aitWwdtbuaS+/p7SjMyYFD4ZUw
X-GND-State: clean
X-Stat-Signature: zyicru815qa3ac65jbc1tuw5j3yhw56u
X-Rspamd-Queue-Id: D6DC280007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787666072-241549
X-HE-Meta: U2FsdGVkX1+2NxDXr9Z3YCBezOJpwo26DN2xg4s/rzMc9/XuyfSet/LgSqhX18u+TM0ZuE5v6qGL3peRm3maX7kHdI2tCGQHyUPUBpPgADiEDB54J4XUESCc0mRP+khxGc1gQYG9ujDRW1kTLGi4maTNTruxkrIWCQCrayAyxwdE7MPHABX3ylgk/jiAcklFlf2Xn+IGLD+gFhSn7iUrTraPtqD0MhQt9YRmmb5ZGkHjfp+bDMMSjrUqGN0zMDQu6BKTgHWLGD+8phiBFQIqfwkUbd+eeD1xqkxJXpLwYbeGHM9FTL4G66HupFkRp4trFTPWm4jt6z4qcQ7D0vddbYXU7WSqneYoHogGFGidrjuxqoYyMsgG9BR30aX6TyGtX6si1It2t0Psbqd4L+CSxcnO+oZ1zOwHa/oEKCJ6JJHZuQ3wzCWZf88tZpnUvRJ6TqMVA/qZQTEaPSqgqU9lN2Th1e4+XfkTZZm3bJY8EAqr47rrLTUobcVFJWvvPkARzaKdlsJFG0KojTdurPU6lJ8lFHd+MQJUqj+sT1W64zLMUfZqfYB4Dy6yrZdKZXNgwSsdqHHayQQa6Wrz91TF9hnvmL+WpGQ2NSkR+0RWMva1Rrln6n2F/14hZit7Unkt0xM7AbRy326l2NHzbm6EtPtBkWFw0EH6y4iq7cuJpoqGJSeT6zAeJt+AmJl7VsyJy6zvCBdiXa3SxRLQjhT05BcswbVD7R6RCydFwwsfpIkpq9Gq7dZ3C6rAtFGFta37xOBBt78HpULcMRW0HjVG1lF6DT37D30a+bY/7TUriHCbnIYSEMAgwsxHf2GgAigtBkqQvk74b+kw9xEnwgH6NuY5TC3kRRlg4nPKo/iqdzatIiS/rPUyyz1ORRrHFbBJXsQbgqryBhSg5PxZrDCYpHt4wHH8IPNNXEit+OfUItQkR0l/Ye6BeSHxE49dT4yUEzGV0PREobVKRV2APC+
 biPxTk7m
 /lDXmzOmGoxc8FFXfhYVA3CiJWquXvENJm9IMgxcMb2xXXO+KAbXFfI5irNftieaBesIQvem6AkR7xtH9WPSur9HgwvrqS3AFwHzOa0gfgFHaM1TYIloA0ETKZWo19Bh+exrfrHih6aaW/B2Q9cYaKqm+afQin7rRRXVg+oWHpyUZa/4BrXqFT/x1zEzENjiNLLmd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A PG_dropbehind folio is dropped from its cache once writeback completes
rather than left for reclaim to find later; this is implemented for file
folios in folio_end_dropbehind(). Extend it to swap cache folios.

The drop takes the folio and swap cluster locks and may sleep, so it
cannot run in interrupt context. Set BIO_COMPLETE_IN_TASK on the write,
as the file dropbehind paths do, and drop the folio directly from
folio_end_writeback().

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/swap.h |  5 +++++
 mm/filemap.c         | 19 ++++++++++++++++++
 mm/page_io.c         |  7 +++++++
 mm/swap_state.c      | 41 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c          | 48 +++++++++++++++++++++++++++++++++++---------
 5 files changed, 110 insertions(+), 10 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..29ec60dcae21 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -374,6 +374,8 @@ extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
+long remove_mapping_reclaim(struct address_space *mapping, struct folio *folio,
+			    struct mem_cgroup *target_memcg);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
 extern int reclaim_register_node(struct node *node);
@@ -465,6 +467,8 @@ void swap_put_entries_direct(swp_entry_t entry, int nr);
  */
 bool folio_free_swap(struct folio *folio);
 
+void swap_writeback_dropbehind_folio(struct folio *folio);
+
 /* Allocate / free (hibernation) exclusive entries */
 swp_entry_t swap_alloc_hibernation_slot(int type);
 void swap_free_hibernation_slot(swp_entry_t entry);
@@ -475,6 +479,7 @@ static inline void put_swap_device(struct swap_info_struct *si)
 }
 
 #else /* CONFIG_SWAP */
+static inline void swap_writeback_dropbehind_folio(struct folio *folio) {}
 static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/filemap.c b/mm/filemap.c
index d721986d5f46..040c97a121de 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1686,6 +1686,8 @@ EXPORT_SYMBOL_GPL(folio_end_writeback_no_dropbehind);
  */
 void folio_end_writeback(struct folio *folio)
 {
+	bool swap_dropbehind;
+
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
 	/*
@@ -1695,7 +1697,24 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
+
+	/*
+	 * Sample this before folio_end_writeback_no_dropbehind() clears
+	 * PG_writeback: until then a racing swapin cannot remove the folio from
+	 * the swap cache. Afterwards it can, and the drop below then finds a
+	 * non-swapcache folio and puts it back on the LRU instead. The
+	 * reference taken above keeps the folio alive across that window.
+	 */
+	swap_dropbehind = folio_test_swapcache(folio) &&
+			  folio_test_dropbehind(folio);
+
 	folio_end_writeback_no_dropbehind(folio);
+
+	if (swap_dropbehind) {
+		swap_writeback_dropbehind_folio(folio);
+		return;
+	}
+
 	folio_end_dropbehind(folio);
 	folio_put(folio);
 }
diff --git a/mm/page_io.c b/mm/page_io.c
index b23f494fcc83..586c79c3bb3d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -456,6 +456,13 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	bio->bi_end_io = end_swap_bio_write;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 
+	/*
+	 * Dropping the folio from the swap cache takes sleeping locks, so the
+	 * completion must not run in interrupt context.
+	 */
+	if (folio_test_dropbehind(folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	bio_associate_blkg_from_page(bio, folio);
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 07418fc94f00..231fa87cbbe0 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -537,6 +537,47 @@ struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 	return ret;
 }
 
+/**
+ * swap_writeback_dropbehind_folio - drop a dropbehind swap cache folio
+ * @folio: the off-LRU folio whose writeback has completed
+ *
+ * Context: task context, with the reference taken by folio_end_writeback()
+ * donated to us.
+ */
+void swap_writeback_dropbehind_folio(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+
+	folio_lock(folio);
+
+	/* The folio was allocated off the LRU and nothing re-adds it here. */
+	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (!mem_cgroup_tryget(memcg))
+		memcg = NULL;
+	rcu_read_unlock();
+
+	/*
+	 * Gate remove_mapping_reclaim() on folio_test_swapcache(): a racing
+	 * swapin may have freed the swap slot (folio_free_swap()) and dropped the
+	 * folio from the cache, and it must not run on a non-swapcache folio (it
+	 * would trip __remove_mapping()'s mapping == folio_mapping() check).
+	 */
+	if (!folio_test_swapcache(folio) || folio_test_writeback(folio) ||
+	    !remove_mapping_reclaim(swap_address_space(folio->swap), folio, memcg)) {
+		/* Raced: the folio is now owned by the swapin; put it back. */
+		folio_clear_dropbehind(folio);
+		folio_add_lru(folio);
+	}
+
+	mem_cgroup_put(memcg);
+
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 /*
  * If we are the only user, then try to free up the swap cache.
  *
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 848bd3e5eee2..4cc3a3ed6db6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -780,6 +780,22 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	return 0;
 }
 
+static long __remove_mapping_unfreeze(struct address_space *mapping,
+				      struct folio *folio, bool reclaimed,
+				      struct mem_cgroup *target_memcg)
+{
+	if (__remove_mapping(mapping, folio, reclaimed, target_memcg)) {
+		/*
+		 * Unfreezing the refcount with 1 effectively
+		 * drops the pagecache ref for us without requiring another
+		 * atomic operation.
+		 */
+		folio_ref_unfreeze(folio, 1);
+		return folio_nr_pages(folio);
+	}
+	return 0;
+}
+
 /**
  * remove_mapping() - Attempt to remove a folio from its mapping.
  * @mapping: The address space.
@@ -794,16 +810,28 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
  */
 long remove_mapping(struct address_space *mapping, struct folio *folio)
 {
-	if (__remove_mapping(mapping, folio, false, NULL)) {
-		/*
-		 * Unfreezing the refcount with 1 effectively
-		 * drops the pagecache ref for us without requiring another
-		 * atomic operation.
-		 */
-		folio_ref_unfreeze(folio, 1);
-		return folio_nr_pages(folio);
-	}
-	return 0;
+	return __remove_mapping_unfreeze(mapping, folio, false, NULL);
+}
+
+/**
+ * remove_mapping_reclaim() - Remove a folio from its mapping, as reclaim does.
+ * @mapping: The address space.
+ * @folio: The folio to remove.
+ * @target_memcg: The memcg to charge the eviction shadow to; the caller must
+ *                keep it alive across the call.
+ *
+ * Like remove_mapping(), but stores a workingset eviction shadow the way page
+ * reclaim does, so that a later refault can be detected and the folio
+ * re-activated.
+ * Return: The number of pages removed from the mapping.  0 if the folio
+ * could not be removed.
+ * Context: The caller should have a single refcount on the folio and
+ * hold its lock.
+ */
+long remove_mapping_reclaim(struct address_space *mapping, struct folio *folio,
+			    struct mem_cgroup *target_memcg)
+{
+	return __remove_mapping_unfreeze(mapping, folio, true, target_memcg);
 }
 
 /**
-- 
2.53.0-Meta


