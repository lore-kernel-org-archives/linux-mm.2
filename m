Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031DD606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tx98uMwC
Received: by kanga.kvack.org (Postfix)
	id 1C1A96B05CC; Sun, 22 Nov 2026 07:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172F06B05CD; Sun, 22 Nov 2026 07:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0629F6B05CE; Sun, 22 Nov 2026 07:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D03686B05CC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:48:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5887BC06E9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:46 +0000 (UTC)
X-FDA: 85462734252.11.8EB260B
Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5CC6440004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tx98uMwC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351724;
	b=nQJkRElYBzOqhcZi1/qHWftbLsl1kxWAa/E6Y1Whf6D+CYCpprrRbB8raD4ju7EGhUtO/2
	70spgKGSBNIih1r3UiRshn/NDVOZQ/3iQHjswqGFLL3u+dAMO9JEEKO1y5R3TvlD02LWC4
	h6RSjvWn61cP4jKjd7ZNeYpUrjgUFig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mamQiHx1S+rM6/wse/M+cvChqIyNrpBo8EiBe0rO+vw=;
	b=cy9qSMv/Rd0ighoQcOC7s2ePkki8PubHcrhReimdBDgyOUiek9DjK5rtatzFfXpN7W+oR7
	Q5cd8FBgxwtc6vrnJyWifdtARyF6hlOrnZcT61wz4cikjNnE4GZUNs0QQDPxJKv6S3b2wj
	i2A5ywj0x7yoPiE7uEoB+20ZJp3NbR8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tx98uMwC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nu0dicTLjst8u+/L1vGewxsOnB12Omss4t6mzzyIEZs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351721; v=1; x=1795956521;
 b=tx98uMwCK/iKiMHHVWPj1CpcA6h90u8ztGoJR+blTsy5tQ5yVPBg6EfJKUhNCCRykXcXrJkM
 QkQW/4YX1VWpG6VvYLJs/KcEyl5BVqppjrQVmWBI+ttSkNaOyrv78yqOE5aIYxZaxV6qNAQmoo9
 fu//mM3KYOP9uY3uCkk5zQjA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 829fdfb4fa3c0e22;
	Sun, 22 Nov 2026 12:48:41 +0000
X-Mizu-Trace-ID: 829fdfb4fa3c0e22
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 13/14] mm, swap: do not give an xswap slot to a cgroup that cannot zswap
Date: Sun, 22 Nov 2026 20:48:13 +0800
Message-ID: <20261122124814.3489077-4-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122124814.3489077-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
 <20261122124814.3489077-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5CC6440004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rtd41dnmn1wbrt54xyxdrxkxigze5r9m
X-HE-Tag: 1795351724-859564
X-HE-Meta: U2FsdGVkX19CbXWfyOL8qvWCSo4v39/8Jtl+3PCT12spXL3CZ8zaBPpRAcUto5cfRY2kKeXO6vchxL7emK7CgAN/UWAzODTQWodcb+4xZ8tAKecHLvWkRX03j50jKrW2Vt+n6Beyl43Pf9/DGML0d0K8VGWt0cEMd6iiIZnLWIzjaccgSc0xEFGYnk/qowXfi1HasGYnTyY4/HNdgXbsUdlygSbUYxeMnygKWj7/BYH3v4kbYNlQh3xdFkYaKgFiG1SJeRUjZVsuXCdvBKJGKa4PRMqKPYO2STHhXMdpD2t1QKRq3eb3B1M0v0AvlV7WXJO/PeD7t47He0OrldMZbqZL2JVoYuk2o7Tem3jLz4dUf1rToh3tJ70BYFJSp1Cn60/R8nu+fCifAyt0PRFeSVhxmST05Q5oyoBFxV0SyWxLuAr6m7mSY6AfjDxR8tHXLykv5J5Wgk5LA5MCYKThUabN0bpXbTsYqnwrgitiknsOBC0dGEZKe/vQilz8ytmtYfZY+bMQwIhd8aTVL3ezsemaToDLsS9btOOWv8dEMSgit3K/nkvSYC6IBfuqNSsKYcoxMk9tHkXkvM3mp4ItOJQspuB84PXd1ISe94l/tfLQ/RhTHsC8Is+1f2qj6SAnJZBmuuVjTQ/UT+NFEs8HkTremWvxjOa/spLSxjQ8A1aCxV56ZzK5YBEiD0cg444efF+uLTHsRWi3zMeust4+zLFdenLTJ9u65Niav0VB0o1ZmSN46FoVfgFNugGRxm9G6K8nVAHK5985mwbTvK5vNKLEFUxvvPtbIPSWJRShZVa6GxJS9MQsqWEoCql3hee6ozwXKHTi/aWBLsP2UpDrDN3AT/faHsYnp5wq286aMZKINyy7U2k8n2JRVf7IATg3ry6gcndOmcAa/jOj/m1eFe5WmDY1272iMt/8+DY1YGR/cWxpJma20Mldjv/U5h3SnGPzVu6pEiRdYos7Z8R
 ULvCvhQr
 oeXRmiWc1eM9vdo3uBJ1P4NGGXnee0rGzRp7zfCzkJGx04rqpAuQfIh03BjgjjDMm53BvsDOAOs0+OADS8B3Nehm3Yx3VJYB2T35hj8EzSnZK8NL48Ul4RKpMWyUV8ag4Iu8mjzBSoh7NDPHm4LuHWrFz5nbBwXAVH9dFhl35vGvYov401hue8nY392WFmF2oagesvEDluHEf2hVC6iUxR1VzsmESH6r+0MZQw4J+aeWbsuxqe03DhC5b3rrGLlqHOjZxT9Klvm5yh+v/Wpb4GqKWNHJEMeKrfu96JZT8XXUNJO6U7n4WsFy/5TJYLwBeWK6gVm0HfQp+Mx7raD0WvfLgCUGOhKxDQ65T/buAjSk6OPKjOl80mwT4SczealE/oOArh6Gz0zYL9TcMRQJ+2wcNFxbCkgJkbGhWzAlbVIlLQN4vxVcfVayseaRRqdagP9Q93nRi08aMv7Lt9tUWsgZR9IAKLoEqIAf/2O9ZiVE143h+fImAjr0ENu/nUz62n0SLlRebBTtJFZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

At this point, an xswap slot holds only a zswap-backed page. It has no
storage of its own. If the folio's cgroup cannot take another zswap
page, giving it an xswap slot is wasted: zswap refuses the page and the
slot cannot hold it.

Skip xswap devices when the cgroup cannot zswap, and try a physical swap
device instead.

The check is obj_cgroup_may_zswap(): zswap_store() uses the same check
but first tries to shrink the memcg, while the allocation-time check does
not, so it is stricter.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 462efeef887a..90f17edce1d0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -226,6 +226,8 @@ static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 atomic_t nr_real_swapfiles;
+/* Active xswap devices, as in nr_real_swapfiles. */
+static atomic_t nr_xswap_files;
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
@@ -1452,7 +1454,9 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		lockdep_assert_held(&si->lock);
 		si->flags &= ~SWP_WRITEOK;
 		/* Count active devices, not merely those on the avail list. */
-		if (!(si->flags & SWP_XSWAP))
+		if (si->flags & SWP_XSWAP)
+			atomic_sub(1, &nr_xswap_files);
+		else
 			atomic_sub(1, &nr_real_swapfiles);
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
@@ -1488,7 +1492,9 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 		lockdep_assert_held(&si->lock);
 		si->flags |= SWP_WRITEOK;
 		/* A full device is still active and skips the add below. */
-		if (!(si->flags & SWP_XSWAP))
+		if (si->flags & SWP_XSWAP)
+			atomic_add(1, &nr_xswap_files);
+		else
 			atomic_add(1, &nr_real_swapfiles);
 	} else {
 		if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
@@ -1612,7 +1618,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(struct folio *folio)
+static bool swap_alloc_fast(struct folio *folio, bool may_zswap)
 {
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
@@ -1628,6 +1634,11 @@ static bool swap_alloc_fast(struct folio *folio)
 	if (!si || !offset || !get_swap_device_info(si))
 		return false;
 
+	if (!may_zswap && (si->flags & SWP_XSWAP)) {
+		put_swap_device(si);
+		return false;
+	}
+
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
@@ -1642,13 +1653,19 @@ static bool swap_alloc_fast(struct folio *folio)
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static void swap_alloc_slow(struct folio *folio, bool may_zswap)
 {
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		/*
+		 * Do not rotate a skipped device: the walk follows the
+		 * rotation and would spin forever.
+		 */
+		if (!may_zswap && (si->flags & SWP_XSWAP))
+			continue;
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
@@ -1971,6 +1988,17 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	return err;
 }
 
+/* Can the folio's cgroup take another zswap page? */
+static bool folio_may_zswap(struct folio *folio)
+{
+	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
+	bool may_zswap = !objcg || obj_cgroup_may_zswap(objcg);
+
+	if (objcg)
+		obj_cgroup_put(objcg);
+	return may_zswap;
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1987,10 +2015,21 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	bool may_zswap = true;
+	bool zswap_checked = false;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
+	/*
+	 * A folio zswap will not take must not get an xswap slot; without
+	 * a device to route away from, skip the lookup.
+	 */
+	if (atomic_read(&nr_xswap_files)) {
+		may_zswap = folio_may_zswap(folio);
+		zswap_checked = true;
+	}
+
 	if (order) {
 		/*
 		 * Reject large allocation when THP_SWAP is disabled. Check below
@@ -2011,8 +2050,8 @@ int folio_alloc_swap(struct folio *folio)
 
 again:
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
+	if (!swap_alloc_fast(folio, may_zswap))
+		swap_alloc_slow(folio, may_zswap);
 	local_unlock(&percpu_swap_cluster.lock);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
@@ -2020,6 +2059,20 @@ int folio_alloc_swap(struct folio *folio)
 			goto again;
 	}
 
+	/*
+	 * The gate was skipped when there was no device; one may have
+	 * appeared since, so ask the slot itself.
+	 */
+	if (unlikely(!zswap_checked && folio_test_swapcache(folio) &&
+		     (__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP))) {
+		zswap_checked = true;
+		may_zswap = folio_may_zswap(folio);
+		if (!may_zswap) {
+			swap_cache_del_folio(folio);
+			goto again;
+		}
+	}
+
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
 		swap_cache_del_folio(folio);
@@ -2037,6 +2090,13 @@ int folio_alloc_swap(struct folio *folio)
 	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
 		return -ENOMEM;
 
+	/*
+	 * Only xswap devices exist and the folio cannot use them; splitting
+	 * cannot help.
+	 */
+	if (!may_zswap && !atomic_read(&nr_real_swapfiles))
+		return -ENOMEM;
+
 	return order ? -E2BIG : -ENOMEM;
 }
 
-- 
2.54.0


