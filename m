Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2685C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11916B0095; Fri, 11 Sep 2026 08:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8F06B0096; Fri, 11 Sep 2026 08:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD76C6B0098; Fri, 11 Sep 2026 08:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC9D6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:16:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 144B7801D9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:16:06 +0000 (UTC)
X-FDA: 85201378332.14.A68668B
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2E76412000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:16:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789128964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ha6A6BGG4AZMU2gaAK8CLnCc/iVWEvzwhsBuObuk7yo=;
	b=nEAPTOA4oEkOc0U5MUAyIiHcyk8PXYJgvgD3PMK21nBSZCgQfTO7xsnZTihxdyp9+aSlwQ
	p2BlwvrGpnIzwWTek7BCaxscGB4vGXa7awl5Ok+dIujOhvVRuC2GWDkWC2yJqAPtjdwlYE
	VnXvZoW4yKLdjG09ywp0RnI8MriZqr4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789128964;
	b=ggM3wyl415YEyk/L6s5r48SeaogNo89sOwkUXbfTLAWxBYs9quOyJa5be7rPQdjn0ul9Qb
	B2spef+jV7jAS8V5s4DloM+6vs1k5grsZQ0GDVG2iPMr1G8hWPRdIVMb6IaUvTuHneelX3
	HIPNYFq/L/xSLJ1LkOmjv3uqUF69Y2c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 07E7E3EBAD;
	Fri, 11 Sep 2026 12:15:56 +0000 (UTC)
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
Subject: [PATCH v5 2/3] mm: swap: drop dropbehind swap cache folios on writeback completion
Date: Fri, 11 Sep 2026 14:13:29 +0200
Message-ID: <20260911121341.178028-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911121341.178028-1-alex@ghiti.fr>
References: <20260911121341.178028-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGfAlh9c+pEh1Y00g1ucsY9TXoPvlSpq+kLO/TyS5eegFUhSZk1HWGBEKI2EIGpMjwYV84dXepg2QrFzjdjhJpD6uJ7UOjwxR4tmFH3HJlDtAdZIv/b82CTk0cvtKYnnlQSesrrWi8eaFeV5GPBNEW00Fw38Sew7azh5zrRlSzfWnGj/zBzOo8f54f1hMdr3s25eShLr9Q2E+gJ5nIKtpdbn7VmBtfAShkJZR/VKWYVh9m0eENOkd+/YMjkMt4MJdqVG1j0L+yDgSQOi9ZZkE0CUfSq92WrHbhe1A00cDoD08RJOchvE15pjmEcvjeF9JzmN2OHb/AlwyGI3s7wzPg8PnXvoD9pAIOfCi0mwSxodaEGLbHW1jDUkqzt745Bp0HYIoaIc5WW0VCvRtpYrA4qU1pkGmrhM1XY02MEj7deCOandoFqRVbSSfKnu1LbHA4/N1uBCV7MQfzlK5PgHmRL/Xzs4QHkkBgiSHLOvqwc9WNOvlb7q0vFUIDCLQXFWsHH6Mj7zSfqhFrNWh2p3tj+EKWRiBWRPb1X+UPF3eUJsAb0MWMJPPAJzAkIwKm/tv/Fwea4FXSeGShkyeiWvvj3hM+2On/na6Wor0wKce3QPDICoRIeudagdRsbeNUCjdaCIDHV30bApqUl5mmAfuH50egqlXbeb+64eAeQL/VMQQ
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2E76412000A
X-Stat-Signature: mtf8rqjapnb8mnosqog3imsi4b4rzwm9
X-Rspam-User: 
X-HE-Tag: 1789128963-899947
X-HE-Meta: U2FsdGVkX1+CKPiwP0TcDrrCBvLUtNHrdk89WgKNtPXMzeQvj0tgI4NKsXkAqSFkYDgBcwk97PmYgj4A7EmjjV4KZywgsD8TF8LFBE+5FN+v3P59d3lhskTqIBiemJEHtMzRV7VZDZI5G3Ae8GT/TLj104xdryxJV6CQFtztgx096sR5hBT3FZudKEWti74YWjPOSyUq1LwKIUESEd4i6aifZWlg09N03OaaoW26DPptb681KrmRxEy50zQ/em+BKhc0g88Y0WksWHnolBs8l7+A2dhkW7XQnWzFMAehyUwDjk5s4odWpj3T2NyHikHj7+TMnMIWrr/n1YMlR5J7dnlcnDwuKglCTToKQIy3pOskftw5HfsVAhoYqbYpkOURX8xDpvJKEcfIFPTCnvn6EPTuXrrhDtJfOMAwpg5TDjwqiJIBjKrdYHMJTWReACm2H/U0LQBuvSz87DIIGGltCLq2pgM0+Pt19KC+vuu73RZljLk6Zc968J66nDDI8czmzC+LhjD58UWRrKqGTI3Vnzu2aAqs1HfHUArX4Z2yNLAutF3xqV54P6FNVHRU4NPK6ovfjf2o+5dNsNP37JIfJEwk6v9+Q5aO6qHUDIVraJl2R8xQgCEH5oOMPfARzIRXeZqi3MQ4RJ1VzewyJMgC65Is/DfPF1skMANpPIz+F/vjfIURIoUULLxKkdv8Tu4hKfntxC1ihUx47+HEYCE4nPIoGetN2pA0cFcFk5pqXot8kD6WbE4ZAtEFp4MWPYL1yADdd1ISlr8j7XRBmq4NgLNdTZxpwlvxc9z5uXCLWS4AROlqKNDP/5qLkWABmF+ttmYzFtSuw8vCjhmEv2UJVRjNXToQg9p6ZFk1tupLy9LIUWiTBh8GYPAws806Yh3o9mRfG3tkKWfNKdoDPhb/qY05ynaqihTixIu9obhmfXpqZOLWw/c66qkrPOaxKaJHNpM3Qqq5D6uinevxsRT
 KkfLn81x
 o3wIqjp1b1Zx5+0EOWmYVlsKY8ar6l7cuMpqc5rf/V1ZG5KYnwE/RPU1SxW+/8PQhsiMT4/JZKK689SOtsD9pGSHQ2b3y//XAa1C9o/x6RcmLxwWj7I/72pxkr6EXnSyv5WOFAACd5VEd8BoW24aq/W/wdADDDNNpw9huSz4FzxLZ8w1qefcWqoO3hZKviqRrvHJE
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
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
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


