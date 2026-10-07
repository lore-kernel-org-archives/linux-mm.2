Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F01CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 15:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1DF6B0095; Wed,  7 Oct 2026 11:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2B26B0096; Wed,  7 Oct 2026 11:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B87F6B0098; Wed,  7 Oct 2026 11:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27E826B0095
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:36:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90C51802BA
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:36:32 +0000 (UTC)
X-FDA: 85296232224.26.FB8E9F9
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf18.hostedemail.com (Postfix) with ESMTP id 632231C0011
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:36:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791387390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mpbsMF/bOIB8y8yer4YR1HPIhxur3GCdnSZEjWka0vc=;
	b=gBVFeAL4FYuhEBgHTpHh+cT5eow4wBBz+OS4ejAmYLxe3M3HpVThvXMDXrHQqE4vPXq4CG
	A6b5NkUPAsBJntb9+hJvhY839PP7jQi7XA+9fqgcGS0S36hSmoOdP4oz751BHh08P/Hmec
	YzuXgdrd8EuWmN3EQmjZNk70njyWtUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791387390;
	b=dLXqcazb32g5l+cuz3lubyTdMntmixrp5l5KRoMZpmreq8pe/pYw4uFoyB6FIsMst8qhQ3
	COGXDu316647yQbjZuZ7PC0s1RWR5fZdL1ohNW4c+mwjGRKDe54mivc0fQ+kJBuuqLEXOC
	y0hlYzYSvqq/okZCtBJYj/TgJnsUzbQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id A60D63E9B1;
	Wed,  7 Oct 2026 15:36:26 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 1/2] mm/zswap: batch the writeback IO of consecutive entries
Date: Wed,  7 Oct 2026 17:34:43 +0200
Message-ID: <20261007153507.50715-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007153507.50715-1-alex@ghiti.fr>
References: <20261007153507.50715-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTFMmDhzRI1VF4VJEv1Glxi0/xCf5/UsaPxWiZO6CFitpeL7iII4ozF9mAko/Y4N96ToP1F+wO9d8Cyt3n3dCOkrHN5hKkSWqaXARpt/7JbAg3TpjzCUl4KqGKKBz3AR7HIKyFjdQExErAoROeYZPqoxG1hEcCJfeu4H30zWPy7XFcsGnqc1OviNnc7t7euAQXNG1ugsMfrmgxN7Mj3vrEto5zHPM7+7sYmBN/JegeTAvN4WAi4RcHGVN7oWMt7WFFDKBlNE6uQOLfQURLf3Il6Khr5Lc5CbsnRODEDRmt1CxIN5yefsqczuun4pWuL/6FgGBOZT1eF/1ulnRaqq9f5tsNMFC2UvucvHA4pLqgJ/GPVFDZfU1+8Am1I7bI5y2zD11GBygzJ8X3gFqnuuD1wv0hcAR7cSVPRq1tLtb1WJzgVTEo0VhrkbRNZ2sMQTWM8o2WKatM15mLpuD3PR1/4Vaa4yfv/JeqJG8FE/Lf04ZMPoOlknI0FYreqYqaLwH+WvercYbeQG8/vEQyu79LC7AbuHP5wt9O8+82QOhGTrlsHUZ/XDFpaKswe1Yrc2Vva4ytwZxfVVMncjfkiseOoEr+IRz/DxWbK7M99V7hKYtRaclP7Xd30yxX+3uR1YxJVeZGU1bXxlDV4hAU0KDnihCZYw6LsabuSaQpW+7WipZQ
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 632231C0011
X-Stat-Signature: mafwgw5zbgrk9d775pt9oe38c865jekc
X-HE-Tag: 1791387390-209650
X-HE-Meta: U2FsdGVkX1/t/GIHPLwTOaKi0lozdfEgjhFcWqvpYy5PnweKNHjLO+IkEXhicMtawUPxGVlfBp+4i95v6XbVfk2e179duNg2YIguog9drIaeIs7+PX+OJWS/itrzZhum6fPsqO48LtoXboh+LTvrtyzhIDwref/3Ei+9mHhOWmRNMVPflDTWAwa65053KU0mMyUIdt/Ra44cjdzZJIujNQBIeG8hglYeBvPA8guFU9wn72Yftjvwmv+SvleEcpu0Ad2j4UXQjin1NgM5j2GrL+bYdWLDZ7HjRlgvoD11kJXNQde5c4c1dIir+LequETHJbMStq2bE3Cv+jBYS6QkywH0QNVhU0rzZC8hi8fJZjfvnscItDDhmLN02N9kwzHWLm5KiB0PH/U9g2+NL0PYurCsT6aVAwNhm0fHYcHSiIe2pyimTJOvALnnzziffhYRWmTw7a2fuJ71pVFRT7nu3MmmkW9er5VPPt0Z8fT5C0eDzqyjx6QUj22LmShwWNSBxfUDJ0XHeU/IUfig58ea0ChTrMTO0f00rkVxG8u04+oAHQ4ngv+sGn/MCZ+Wr6Sr4MMVOUC973OBbnzLLA0esa3XuFIpn+pIS/YGOK+kwqFf9kH9sQVTT0dfjUJQJrwfc0Xu0DQssivTK1YPWoSUjMFj+SWcrPvjFSv7FZc7ER7XeODzc0JnUequFky9rKuGiOfK8B4TiDRCmSUg8FOQaWg3xNCO2yTR304DAGOO8ITV8NN8ahC0VVDMZySGnbRQsqhId/tJwYQib8TAhfm8w4muzeHfoDxtLb81HAjtbyjOafviO7omyC2m0KQQhs0CmxXU4+eJgPP/dRL+YhOmkx3osBDPkLggemi3Y9zm7rjqO74j0f2sw9qHWNle8RowK9qp1iyGgFWukGx6V0OYjg1DZIbkNFVj0vKwyIBzULnPICkNs0LcjwGauWoLdYkIiB/j1MOAb/eLDfnjgkN
 nq40Lo5A
 YEcZboz+kG7Zw00GYJkhi8d09YCQGlVI1u6g0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 8f29aa226f82 ("mm/swap: introduce struct swap_io_ctx") introduced a
simple way to batch the swap writes of folios with consecutive slots into a
single bio. zswap writeback does not use it: zswap_writeback_entry()
submits a context of its own for every entry, so every entry written back
becomes its own IO.

So let the two functions that walk the zswap LRU, zswap_shrinker_scan()
and shrink_memcg(), own the context and submit it once the walk is done.

Kernel build (defconfig, -j4) in a 600M memory.max cgroup with the zswap
shrinker enabled, swapping to an NVMe partition with iocost enabled. It
runs alone, and next to a sibling fio random writer with 10 times its
io.weight so that iocost throttles it. Mean +- stddev, counters from the
build's cgroup:

Alone:

                                unbatched       batched
  build time (s)                1066 +- 9     1061 +- 2   -0.5%
  write requests (k)            748 +- 47     596 +- 26   -20.4%
  pages per write request    1.07 +- 0.01  1.30 +- 0.01   +21.2%
  iocost debt (s)             15.0 +- 2.7   12.1 +- 1.2   -19.5%
  iocost wait (s)              7.5 +- 1.2    7.2 +- 1.1   -3.6%
  IO full pressure (s)        19.0 +- 1.8   18.2 +- 0.9   -4.2%

Next to the writer:

                                unbatched       batched
  build time (s)               2269 +- 50    2203 +- 62   -2.9%
  write requests (k)            714 +- 31     605 +- 24   -15.2%
  pages per write request    1.08 +- 0.00  1.30 +- 0.02   +20.3%
  iocost debt (s)               685 +- 25     646 +- 26   -5.7%
  iocost wait (s)               655 +- 26     632 +- 23   -3.6%
  IO full pressure (s)          655 +- 31     624 +- 30   -4.7%

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced..698fb74c5d47 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -990,6 +990,21 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 /*********************************
 * writeback code
 **********************************/
+/* State shared by all the entries written back by one LRU walk. */
+struct zswap_shrink_ctl {
+	/*
+	 * Collects the writeback of consecutive entries into as few IOs as
+	 * possible. The owner of the walk must submit what is left in it
+	 * once it is done.
+	 */
+	struct swap_io_ctx io_ctx;
+	/*
+	 * If not NULL, stop the walk when writeback finds a folio already in
+	 * the swap cache, and set it to true.
+	 */
+	bool *encountered_page_in_swapcache;
+};
+
 /*
  * Attempts to free an entry by adding a folio to the swap cache,
  * decompressing the entry data into the folio, and issuing a
@@ -1001,8 +1016,12 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
  * in the first place.  After the folio has been decompressed into
  * the swap cache, the compressed version stored by zswap can be
  * freed.
+ *
+ * The folio is only added to @ctx here, it is up to the owner of @ctx to
+ * submit the IO.
  */
-static int zswap_writeback_entry(struct zswap_entry *entry,
+static int zswap_writeback_entry(struct swap_io_ctx *ctx,
+				 struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
 	struct xarray *tree;
@@ -1010,7 +1029,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
-	struct swap_io_ctx ctx = {};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1082,8 +1100,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_put(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio);
-	swap_write_submit(&ctx);
+	__swap_writeout(ctx, folio);
 
 	return 0;
 
@@ -1123,7 +1140,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	struct zswap_shrink_ctl *ctl = arg;
 	swp_entry_t swpentry;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
@@ -1178,7 +1195,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(&ctl->io_ctx, entry, swpentry);
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
@@ -1189,9 +1206,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+		if (writeback_result == -EEXIST && ctl->encountered_page_in_swapcache) {
 			ret = LRU_STOP;
-			*encountered_page_in_swapcache = true;
+			*ctl->encountered_page_in_swapcache = true;
 		}
 	} else {
 		zswap_written_back_pages++;
@@ -1203,8 +1220,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
-	unsigned long shrink_ret;
 	bool encountered_page_in_swapcache = false;
+	struct zswap_shrink_ctl ctl = {
+		.encountered_page_in_swapcache = &encountered_page_in_swapcache,
+	};
+	unsigned long shrink_ret;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1213,7 +1233,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&ctl);
+
+	swap_write_submit(&ctl.io_ctx);
 
 	if (encountered_page_in_swapcache)
 		return SHRINK_STOP;
@@ -1319,6 +1341,7 @@ static struct shrinker *zswap_alloc_shrinker(void)
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
+	struct zswap_shrink_ctl ctl = {};
 	int nid, shrunk = 0, scanned = 0;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
@@ -1335,10 +1358,12 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 		unsigned long nr_to_walk = SWAP_CLUSTER_MAX;
 
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
-					    &shrink_memcg_cb, NULL, &nr_to_walk);
+					    &shrink_memcg_cb, &ctl, &nr_to_walk);
 		scanned += SWAP_CLUSTER_MAX - nr_to_walk;
 	}
 
+	swap_write_submit(&ctl.io_ctx);
+
 	/* Nothing was scanned: every LRU under @memcg was empty. */
 	if (!scanned)
 		return -ENOENT;
-- 
2.53.0-Meta


