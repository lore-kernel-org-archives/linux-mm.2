Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 092C8C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C8E6B00C2; Tue, 25 Aug 2026 09:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18696B00C6; Tue, 25 Aug 2026 09:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D636B00C8; Tue, 25 Aug 2026 09:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B43406B00C2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:53:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 333961C191E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:53:32 +0000 (UTC)
X-FDA: 85139934264.18.9F0FBA3
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2793040003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:53:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7fezERsH0j5EygsoZrf6ywDo3M0FJQ057ZqhtoZrKfM=;
	b=Q2703/2iryK10yNpWr2XzAlVp6H5Nyl13M1ljviVBsIFBtJWCUfbQTplQdNR1uRz9dt8b2
	8/vaihbFg6+FWulyGxW0bcAMCi6S2vm41OMNj83oqLUyoPy+tsv5QKxjFUc6+2e9YS5q6Y
	56nWTAO5Q2KAJSgq4rF/hauI7JBZO3E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787666010;
	b=LHjFsp0lNVhIPmss3Ocpy0c9VRbQFzluFgmnoYz3ktphpsyHodUwXRqjnPYYlRwfxc8E3f
	c5ASWTE0HWL7RVcay9pGWRHS8N93hsCakSJMXDF9PPaNtfP7ZDuCAAGBd5h93GraIQxlOb
	1tFWGFEHhW9mGGVISJqFJ3m2zQw7o6M=
Received: by mail.gandi.net (Postfix) with ESMTPSA id C4D6D3EC40;
	Tue, 25 Aug 2026 13:53:20 +0000 (UTC)
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
Subject: [PATCH v4 1/3] mm: swap: move LRU insertion out of the swap cache allocator
Date: Tue, 25 Aug 2026 15:52:05 +0200
Message-ID: <20260825135209.3135169-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825135209.3135169-1-alex@ghiti.fr>
References: <20260825135209.3135169-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGiHDiWlfQ5ccxBZewsSasowgl6gtfYlDY1PWykUS63s55gMKk5eyoNcDBuK/u7C54COj+K24nRLBNKdyIK2RQTz0Gd7w2H9vLC2370zE+Ddl7i6a/AXnrEXG/Z0BlNEt/8xyMeSW6zBiRZZwvjEQff7MVGCDEPhCRkLbIwEbRTVuxjo/fEYI5R/+1hgmHojmsu8cW0sWOxX9UVZyxkZFjKfn8+jU4byiXlitSGcdBMjxKaqXvJ5iTQAfdm2MFjYyiM9uE53CRdiBRxdil8ElrlmgLmGYOBnqlq0fAMw7kI3FGQeaxVI5JUrPkWhh338+VpDFe89mQ4tcVzXfaSQ8hzDc0daAEIRGFZmYT0D7iWGD5qbwVNcKHLyfesFsfK/xpXyoXvm+s3SJlZnm5pqMnFKTlBYmZ/tPlFbha8ECk/iGOxwFzxS2k18DAYhofQFOQl7PhNmSRxtmRghS0HkfJLLVDqgtGFpiMZbNZ4qwuldG/IuC7XTINHXKU9Ox7Mafs95pYy44z5lAsZ7z42M81z8bzR4mgmtFTPz38QShROj60PllvcOBhS8190kONhlBFG2XZV0gWssJzlzOi1h80WAjRrvSYVIuVUxkntGmHdcDl03QGFX9/nPC7Gtw2vwvjDlR4c8x8D/6W1uz8PuK3jKeibQsG+9yx1D3u9ztRX5Q
X-GND-State: clean
X-Stat-Signature: gbb5adxwr49aqdh87crmsqrwmf6euqt6
X-Rspamd-Queue-Id: 2793040003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787666009-182425
X-HE-Meta: U2FsdGVkX19Z5EOv5nWMTbWC72dxHaih8AusZGr4pOGT0cbLLn5oCpMGyV2NKGB8cYZOGtGm5QBnRVxw609Ky/hNlkxZWXAVm5BUOh5U4/PAdfu5CaAy4hJyPHOAMUS4b22SXqqeeZGqpqJs89Mfn1R/pX9Ei9KKCD4skDzWVf2HVn6YdoPSxKqbFJvdODB7dyu+NrPyzupn3LWYwZqxtc6Mpc6khzdvythbsbpOXZdybDZ5H2M6dJ5kSiaHHTzvtbiiu7sal/HgwfrA9QYnCe7YoxOnSpI2NqVdMNedeFmuZUWtZLPvqpDpuk4yNu+OwZZKnY2/ioK4edpVNSgHV+py+jQ0WI2IB+wTFQOhB7uvaia6C1ooSTunDAUh9QwNcXB2AUMOB4NXs0G237jbzFKGxtM1iaYpWcy4leNkIHX7xvRblKZPR7ax2dMUefbw8k7IkouBEu7V47S/4ZmHTKw6v9jkXtSS0vL834t24szCqQNhmdRfTfzXJU1Nu4SzqHzCXpJZIGYk9k0TZ00uGBpDaQ4zWj7EeYwXWeZT3KVTRPAjudTkm7434c3P4GYMU5C1jUgaUEZBUuG+FdZPgiqlA11qdLQrdOLc2BHq6E18ViQwOMV580Feq+qQqZIdW3XKJcCIMFwAEySYQSayfcsmc5fth48BIOV5OjpzsIxkRGXVD8aOLnjuQs7m9h/lOHQrJuVnqpvOkKhUeFm4Ve0Beorppp7iTrmYcVFi/HjdbueeIqC1lF2ln6/VpqGbnRg6idmduEK+7Yv8yPapSJl9JDBIatdlYZrBUijqKIAHZs0Xnhvf5yUS91XWDabqRAUUAwJSb5vKLr9oZXJTDdVIvKj14RWK0RCLVgYoOGdue/xBik6Pwzr9vA+VfopWbflb3f2wePUHzskqlNUNsRnCrw8Sh20FyxhWguCW/cleZ0dOpsnjAPqdeu1rymXWS7R8SyYIGlmgi5X1Oam
 5lIElF7e
 zIblywXiCwYCdaY091edlwMw8e/OBPqYA3WaNOuuWzlHcO8oJ4EKw0TXVPme6GiB3uDi/uaSpALTZeuXR4PmnNlVOtTv2TBzh+UcLn04/0WIX7Jw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback wants a swap cache folio it can free directly once
writeback completes, i.e. one that is not on the LRU (folio_add_lru()
stages the folio in a per-CPU batch that holds a reference until it is
drained, which keeps remove_mapping() from freeing the folio on
synchronous devices, and likely on asynchronous ones too).

So defer the LRU addition to the callers of __swap_cache_alloc_folio(),
no functional change intended.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 20 ++++++++++++--------
 mm/zswap.c      |  5 +++--
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..fc44daae1de1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -304,9 +304,9 @@ bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
-struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx);
+struct folio *__swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 727a17ee7821..07418fc94f00 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -483,13 +483,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 
-	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(folio);
 	return folio;
 }
 
 /**
- * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * __swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
  * @targ_entry: swap entry indicating the target slot
  * @gfp: memory allocation flags
  * @orders: allocation orders, must be non zero
@@ -501,13 +499,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
  * @targ_entry must have a non-zero swap count (swapped out).
  *
+ * The returned folio is locked and is NOT on the LRU. The caller must either
+ * add it to the LRU with folio_add_lru() so page reclaim can find it, or free
+ * it directly once done; a folio left off the LRU is unreclaimable and leaks.
+ *
  * Context: Caller must protect the swap device with reference count or locks.
  * Return: Returns the folio if allocation succeeded and folio is in the swap
  * cache. Returns error code if failed due to race, OOM or invalid arguments.
  */
-struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx)
 {
 	int order, err;
 	struct folio *ret;
@@ -643,12 +645,13 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	folio_add_lru(folio);
 	swap_read_folio(folio, plug);
 	if (readahead) {
 		folio_set_readahead(folio);
@@ -683,12 +686,13 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	folio_add_lru(folio);
 	swap_read_folio(folio, NULL);
 	return folio;
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..8163e6c5f76c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1000,8 +1000,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX);
+	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
+					 NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
 
 	/*
@@ -1013,6 +1013,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
+	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
-- 
2.53.0-Meta


