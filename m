Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C65FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 02:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950F96B008A; Sun, 12 Jul 2026 22:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900E66B0093; Sun, 12 Jul 2026 22:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8806B008A; Sun, 12 Jul 2026 22:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99A8C6B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:56:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A6A7409CB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:56:57 +0000 (UTC)
X-FDA: 84982241274.05.9CB0CF7
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id 66C4F40003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:56:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783911415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQrWGK4EYZ6ClenvA+TH4nYiPXcKayEGljI8spTvWx0=;
	b=arlfJeR6RKx4kXQ7gNy7R/auMOitv4BEcwva27TJaNCt0zinsyO/UKYIFe3nGpWNjGgaCH
	0meozti/7sJPuwUEQIoiTwU/T52vslYsJ8HEuagY3x2ibQ/ueaGNycofloLCX3s+rEf3Ge
	0CPDg5oiFTLx78Tf7arKGnLaxeXOaW0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783911415;
	b=JiuZHojvYWwmwYetno/W3hE622zcODNAOc3T08JgDr+wZOarL0s6mA4weL5Rlu3gagyzJa
	+L4ZGy9WPlVv6MGGlCoi3C4Xh8bCEE8obyjCsUq8GMb+ee+V5Cxqjg2dCR3uctyL33UZYj
	twOwnDEALj7WgZA31CqftBqRAU5xny0=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 13 Jul 2026 11:56:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	baver.bae@lge.com,
	her0gyugyu@gmail.com
Subject: [PATCH v10 4/6] mm: swap: filter swap allocation by memcg tier mask
Date: Mon, 13 Jul 2026 11:56:42 +0900
Message-Id: <20260713025644.170839-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260713025644.170839-1-youngjun.park@lge.com>
References: <20260713025644.170839-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 66C4F40003
X-Stat-Signature: mccepcm1raii4e18h9skbx81djf3er9d
X-Rspam-User: 
X-HE-Tag: 1783911415-2221
X-HE-Meta: U2FsdGVkX19s/gAcm9Kv4hYwMnU+gpxzavvY6PZRhvgN0c+S27lILTXpmxdZ0/tI2e7C6yrAW4a5gqhjv50GC9gV1CkZrJ6j1PVwMFpwn84DDEVYdHpqoQVNUOyEeCzdxh1ytwEvoQ+JgXB0diGDqykXpot6Xh3XL/p+02nxZhqfvXbxXF3tHOGQQMnbaCSlor/c6cUuxBqHrcQKMUg/H23ADBoXdq5O0L8R3hjzyr598ZxwDoX3ZWu2lpkZUgKqkQo9jzbIL8KB8aUh53Ok8bsEHM5DM46ec1dm2d5zbNstjwwFKqVwulVRSeZ651tHPdg8dBeGb5sL+206aJHHBQuZKzA2H5QOnJL7TYGvbe26fHK+A5Bs9PZDNuSIaSrF5k2X+07q4jSD2RZmQOr7+pplZlCqoISrRK72oXtAsiSG/AA633GUJpnpMir4d1Da3qKF+ZEp6oESAVueptKyFgpeglic0cUSI4059Y9REojdbTSSIcvCqPffZfaR0pA/ZbviCj+b9JW4zL2WLht6iWfkTpTVK8U0x3IBX6V/xeOOSRfoVZR8gqRK9tuBHu5TgS+uo5o5Mom81cSNRXzdB70Op2GTs7jhOCLmBsSKNecKvFge0y3BqN4IQjJHYX/54FRRpKGWtOloRG7LI54wNGWU1lLPNx9kCjzB+VaHaYvJvwdWqMzzF5c7nRZKIKF3pVVQRF3M25xla8iGwca5cEPbmCfjyhwzJb+ooGhMTDtcYrMe3TpiOvJZQ3/y8pSamoVexMz7daiTLx8io7HPvNXm1o2iiU0/kc37HEXpGPCeFRrrI5BqKI2itKxyKDlueINiWQiCEopyPLqdyLO9uZwmQyV+5z6Jag/43w1TOTUGDqX3k0xBdEMQwOugFrgY/yQpb5R12fP04fV0Yk9hwwSQJFSNrI30soJRDHf1zfSp0qdcsckZWCFQoZ5rUzQ0nR0bDezoojXcrvUsRq9
 4iim/3AN
 48Ro+W4MyFpzGSTo+yN6afT1T115pcUTqwk4CslkF03qhhJskgRPjHc6MzIIlGJADJP3TjbvHEYjy25zSHMT7VkfIQOyL75GIKP7TGt7Ez08k/Lxd6Ulm5xXDGeOhrwdOChzLXkNIKApxPqcr4mYMhQ03DO/JoJRZLhYoyHsE8J2wfFiUhtwi9IjpHsvQFi2SkWa/eDXx+/cj0fC5Ye5FXhwsEIeem4q6yQfj8AMBYDpQ7+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply memcg tier effective mask during swap slot allocation to
enforce per-cgroup swap tier restrictions.

The folio's effective mask is computed once and passed to the fast,
slow and discard paths as a parameter, so all of them act on the same
mask even if the memcg's mask changes concurrently.

In the fast path, check the percpu cached swap_info's tier_mask
against the folio's effective mask. If it does not match, fall
through to the slow path. In the slow path, skip swap devices
whose tier_mask is not covered by the folio's effective mask.
The discard fallback honors the mask too: otherwise it would drain
the discard clusters of a device outside the folio's tiers and then
loop back to allocate from a tier the memcg is not allowed to use.

This works correctly when there is only one non-rotational
device in the system and no devices share the same priority.
However, there are known limitations:

 - When non-rotational devices are distributed across multiple
   tiers, and different memcgs are configured to use those
   distinct tiers, they may constantly overwrite the shared
   percpu swap cache. This cache thrashing leads to frequent
   fast path misses.

 - Combined with the above issue, if same-priority devices exist
   among them, a percpu cache miss (overwritten by another memcg)
   forces the allocator to round-robin to the next device
   prematurely, even if the current cluster is not fully
   exhausted.

These edge cases do not affect the primary use case of
directing swap traffic per cgroup. Further optimization is
planned for future work.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f3cff586cf30..967399936108 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1359,7 +1359,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(struct folio *folio)
+static bool swap_alloc_fast(struct folio *folio, int mask)
 {
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
@@ -1371,8 +1371,11 @@ static bool swap_alloc_fast(struct folio *folio)
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask))
+		return false;
+
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!offset || !get_swap_device_info(si))
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1389,13 +1392,16 @@ static bool swap_alloc_fast(struct folio *folio)
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static void swap_alloc_slow(struct folio *folio, int mask)
 {
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
+
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
@@ -1429,7 +1435,7 @@ static void swap_alloc_slow(struct folio *folio)
  * Discard pending clusters in a synchronized way when under high pressure.
  * Return: true if any cluster is discarded.
  */
-static bool swap_sync_discard(void)
+static bool swap_sync_discard(int mask)
 {
 	bool ret = false;
 	struct swap_info_struct *si, *next;
@@ -1437,6 +1443,8 @@ static bool swap_sync_discard(void)
 	spin_lock(&swap_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
 		spin_unlock(&swap_lock);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
@@ -1736,6 +1744,7 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	int mask;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1759,13 +1768,14 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
+	mask = folio_tier_effective_mask(folio);
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
+	if (!swap_alloc_fast(folio, mask))
+		swap_alloc_slow(folio, mask);
 	local_unlock(&percpu_swap_cluster.lock);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
-		if (swap_sync_discard())
+		if (swap_sync_discard(mask))
 			goto again;
 	}
 
-- 
2.34.1


