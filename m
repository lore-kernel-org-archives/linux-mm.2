Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE47C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976E36B00C7; Mon, 21 Sep 2026 11:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F296B00CC; Mon, 21 Sep 2026 11:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865186B00CD; Mon, 21 Sep 2026 11:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BEE36B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:15:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC0FD40205
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:15:25 +0000 (UTC)
X-FDA: 85238118210.19.77DBC5F
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf27.hostedemail.com (Postfix) with ESMTP id D5EAE4000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:15:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+DEMpz1enyo/5O84l5omCmKUzlM6BlqGZUKbQvxyttc=;
	b=7Nl8Ptu4S3/aGYXvSDQwG4oCVC0ZZ/yQM6UzJBO4G7Muy1sN2SRvE8C82L1m9RAwwQGrWN
	sE3Xl/hexxUU5nEm5dXWONOgBMRVU4i4ystvCf95QYmwSEkntQT2yiPfhYdmrs2UrZEZmv
	IZwFOe+xJ4N5kIzABkvObJb0gUfH0s0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003724;
	b=uHYkOWEIq7UUGRrNB+KTXUpRmeBJoLG2Skl+5hRkHcbinXqhKDBYeOS2we87VshOkUz0Cp
	JbwuILd071fjLUpVeTMJAlFKtVcMHE5RzNKram7HpFLRlb07oi7D2wOTAZ/X/onAuH7eHf
	z1N1XQZI1beftOT03TotuATdPz/sYN4=
Received: by mail.gandi.net (Postfix) with ESMTPSA id B251C3F08D;
	Mon, 21 Sep 2026 15:15:16 +0000 (UTC)
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
	Tal Zussman <tz2294@columbia.edu>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v6 2/3] mm: swap: drop dropbehind swap cache folios on writeback completion
Date: Mon, 21 Sep 2026 17:13:03 +0200
Message-ID: <20260921151306.625134-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921151306.625134-1-alex@ghiti.fr>
References: <20260921151306.625134-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTErTfvtT3pejKA2c3+atWyTlcQY/2uOK/WC4ZxB6ECJeRWaowlY444Pz8MwijVZahcejcCp//J/4zmYyFaV9n5+fTE2W/zk+j08buYeKqj57bfKmR/1aCQIHlePtPRPO7BFkHK0YG5Nc1HJwubtzFLSUafD39eqhbCa1WaoWlky0QU7/s0p+KOQ9WQHVlH/Z4GSeEq8dey3bbFn2mfiX3yy4C/x/sPvRb/5ajFS224lU/TDUiRGF84sCwEmKZTfv8RTO++xBjYCxbdesAxiH6ogpHphBvCw2671svHud/lqwjl9g1Z9dZdvEeBo4gqi7f4j2kALMQ4m3/C5K84EELuYK+ju9CO5tMjR++bNyjSsG34zbPjZN5buQHRpcSy3us9PXqNjqBevp1Cm+mijAV8c+qV/NU5jXq4RH867rh805hwx0502zVy33bVuha3XUqm8NT/42nWatRmS8F19Wi7YskUn/igDxF0gXphrSs1TT4K3T0wdEHExhNUyeG2iJC5fzJNX4l2Q29O0ZTq2G2bAh/AR/Sf66I4Cki7uDRd/V+4slfP5gzJQO4zyj6lBK3zheTSrQacTgOrHiWrynQUcz8XrLyQmTPMe6mNfEy1VGdln5OSVu1R73Cjv+nFUqKwsslBYSKryLLo9Jako1HQvVV0JcbkFJJyefd81JzIipw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5EAE4000C
X-Stat-Signature: x55i4dq3axe4bshafpwhxb9nre7yjj1z
X-Rspam-User: 
X-HE-Tag: 1790003723-695092
X-HE-Meta: U2FsdGVkX1/pBKpU9FMRbVh77U1cfZXj0nBYA02tmbSnh1smRUmt4jttmuEfJJVtKB7HHQlYqNj6FttukyhKkwWDzwwWkz7OzJhlCZqyXN4ysydzsIFALiQopnxdYLubrLG6uomDOktaAA4Dp/XkqiT3sxNcffj1O88qMDL7CgTimI9Ypgij2z/8Cd+m/lB3z8k2KDLic7g6Sk5Nox1wReZ2jFgUUTZFLpgB0EUQiw4UxmcyxqDbI7GIrRScIlEnFkr5yTAPi2GUBG/hhI+oSE+hf8HVv87KDIFccE4MRmhg5exerPp+y8cGO0usarXC/SvNE5sDGJj8T2mvHJMdR3LAVa9WtvEauqXDq78qZjzHiLu8oNH233T7g5YDyRbcCxmdLuTjqr4/MYh/yH32SGeK2I9ygK1Z9ySNYXddIZ8T+n5rHAlPokawh0/pKXdEfy5qMbiLqycAkGiYwy5PG4XneCJZG52t0acKO97a2m0ZhtRnZ/QfDs6k5QxhEe237YPOhMdcW45t0/RX7M2Dk08XDgbYbS4wKkpiQnW0EXjTdPW73CogTIQgRCITb4UX2j9IKm8v5ZuRgwNDoOInKXS11jIIyYG9+YZOI9xIp/tGzU08WKtjkoHvAcDnkFmiONYhdgcKvcNek1LS2CqYNRTnp+MKqGlxFKmZa7qHYoMKZLjmwKp/bnA4EAGlzFtb5TB2DEUnCSp/roP8ifCDt6jZ4KmvwYs/Gp1ggRfy8CoSmWimKZMLde7cTmvCCApv7tAxJPpxSKP7KX4SkP+XANHx6baGFOG0eZi42n+SAOCmRmTHO/xaCebrcA09QkCHjVnzpyEr8838HOuryyaS5ZcHsNZb7D7h5GexPBWx3PPFKYmrIQNuO1WIRIvDyy5rCBmRwPkhegJgWUmQbwvS4J/l5HOC4jagIYcg9reDqXiMYGXE82cu2ToL2ZpwMGS+zqK57e6qggXnwYEesZi
 70rlvIVQ
 BEPgx7mQnknO1FcPqNMcrZOCLQGWFWtZin+Kci4QaL/crm/YaaMf0aWIA6rdP2wQy50KKbayIUEcQ7LqkFx12Z4VnrSz1GY5/KvfafrDkoaBKcsAZlCNdVoJzul+njqKqh/gB4CEEbQsUJpnVPlPTaQf1E1ieXh/4mgWOwuaACfcXhWWV4JY4tEkEmpAaP0Z59U6S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A PG_dropbehind folio is dropped from its cache once writeback completes
rather than left for reclaim to find later; this is implemented for file
folios in folio_end_dropbehind(). Extend it to swap cache folios.

The drop blocks on the folio lock, so it cannot run in interrupt
context. Set BIO_COMPLETE_IN_TASK on the write, as the file dropbehind
paths do, and drop the folio directly from folio_end_writeback().

It has to block rather than trylock: the folio is off the LRU, so
skipping it would leave it in the swap cache with nothing able to
reclaim it, and it cannot be put back while another thread holds its
lock.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/swap.h |  6 ++++++
 mm/filemap.c         | 19 +++++++++++++++++
 mm/page_io.c         |  9 ++++++++
 mm/swap_state.c      | 42 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c          | 49 +++++++++++++++++++++++++++++++++++---------
 5 files changed, 115 insertions(+), 10 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5658a1634b85..538b723a276f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -318,6 +318,9 @@ static inline bool lru_cache_disabled(void)
 
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 long remove_mapping(struct address_space *mapping, struct folio *folio);
+long remove_mapping_set_shadow(struct address_space *mapping,
+			       struct folio *folio,
+			       struct mem_cgroup *target_memcg);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
 extern int reclaim_register_node(struct node *node);
@@ -402,6 +405,8 @@ void swap_put_entries_direct(swp_entry_t entry, int nr);
  */
 bool folio_free_swap(struct folio *folio);
 
+void swap_writeback_dropbehind_folio(struct folio *folio);
+
 /* Allocate / free (hibernation) exclusive entries */
 swp_entry_t swap_alloc_hibernation_slot(int type);
 void swap_free_hibernation_slot(swp_entry_t entry);
@@ -412,6 +417,7 @@ static inline void put_swap_device(struct swap_info_struct *si)
 }
 
 #else /* CONFIG_SWAP */
+static inline void swap_writeback_dropbehind_folio(struct folio *folio) {}
 static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..e1f1bbe943ce 100644
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
index 88962571cb93..52eae99de6e3 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -602,6 +602,15 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 		submit_bio_wait(bio);
 		end_swap_bio_write(bio);
 	} else {
+		int p;
+
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			if (folio_test_dropbehind(bvec_folio(&sio->bvecs[p]))) {
+				bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+				break;
+			}
+		}
+
 		bio->bi_end_io = end_swap_bio_write;
 		submit_bio(bio);
 	}
diff --git a/mm/swap_state.c b/mm/swap_state.c
index e5b7fa468ade..b1656e2d5288 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -543,6 +543,48 @@ struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
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
+	 * Gate remove_mapping_set_shadow() on folio_test_swapcache(): a racing
+	 * swapin may have freed the swap slot (folio_free_swap()) and dropped the
+	 * folio from the cache, and it must not run on a non-swapcache folio (it
+	 * would trip __remove_mapping()'s mapping == folio_mapping() check).
+	 */
+	if (!folio_test_swapcache(folio) || folio_test_writeback(folio) ||
+	    !remove_mapping_set_shadow(swap_address_space(folio->swap), folio,
+				       memcg)) {
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
index f11491ee9ed5..a02f942418d3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -783,6 +783,22 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
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
@@ -797,16 +813,29 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
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
+ * remove_mapping_set_shadow() - Remove a folio and record an eviction shadow.
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
+long remove_mapping_set_shadow(struct address_space *mapping,
+			       struct folio *folio,
+			       struct mem_cgroup *target_memcg)
+{
+	return __remove_mapping_unfreeze(mapping, folio, true, target_memcg);
 }
 
 /**
-- 
2.53.0-Meta


