Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AA5C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 18:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4226B0096; Wed, 16 Sep 2026 14:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D8E6B0098; Wed, 16 Sep 2026 14:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB286B0099; Wed, 16 Sep 2026 14:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8CEF6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:34:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EE961C2D98
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:34:42 +0000 (UTC)
X-FDA: 85220476404.24.F457F41
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1CD6C2000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:34:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789583680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2sejfwZB9QU2TfswUOEjeGlq+lJslGaqJGnbjtHTwWM=;
	b=FnVouDNbawQSneHDPOpWs3ZyoaYi2vAop8FZLYG+W5g1ie17reksICqIF+7Pdy8yPyAxM3
	7k4nIUNtJu0yk4AHLuxjtIaLyLzGoebPiYuV56QUfdINcpDUFg1o7ROh7cil6uJVAfe0tS
	IsvzBvaTXjeC94FOxz2LWMSNaHR2o2U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789583680;
	b=sVRilAeckHjvkiGNznJu4hPvV5dud7Mt2RhkzD5X7eB9n71DA6O00ZUpHt9LTqnkDbENAv
	stBC60r8T1AP3uOrniF/NRi90tVD5dgvL1XjPHtqLMDGIOWRav1UIaksm6yPY8RuhjHTiS
	2Rc8t8/ztFErhOeInb5sF2d9q72URrw=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Sep 2026 03:34:37 +0900
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
	taejoon.song@lge.com,
	her0gyugyu@gmail.com,
	lianux.mm@gmail.com
Subject: [RFC PATCH v11 4/4] mm: swap: filter swap allocation by memcg tier mask
Date: Thu, 17 Sep 2026 03:34:37 +0900
Message-Id: <20260916183437.2946306-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260916183437.2946306-1-youngjun.park@lge.com>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xppj66mmrbnu9bkq73ehkqnxgsecf4za
X-Rspamd-Queue-Id: 1CD6C2000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789583679-288283
X-HE-Meta: U2FsdGVkX19Xcrn3qWzRHlxKFi3AC3TrJgS/XwmxgjUTuPpy+Az2o3FIeaK+OIAqSt7STa1KYSl31S8J2uISYHIsEVSiL7Lt0cXwTL46gZfL/ejO0LC/Bs5CIF8oVQk1bce7psGEYPcT5kzgA622hvWc2YSSK0kgWlOhhtThKnrgof3qXVSHEjP2+GmF0wQXEDiil9mJNJ0IPolr6QmOZehtPWYTTr1qMfBmyQEwSpgPoxp2VeaEQvS3l2jLhXrZFJtIxq9YZUJTFJOBJxo2MH41ykdU8wqRuEuQ3RlXOSjk56MYT8Zkm3Yyqgo1UjDcEZrjae2oDy7JRfN0mGw4GYOmbs26rgtZeT9txImWW8F7Wl6HXvl2x2gkL46SpDj2V/fhn1JK3n5vPiYCSYX2lLuXXrbSvjcIlzl25pAYxs8pU7tQPBwKeDa7fsPqZY4kqO90f6oFOb6Y2pxflo2wy2/h5TiZqBl0ajjJ6VC+hwBUawb5LVpv5sJzvpJQKHn0ORY+14eUavncPTk2TWNu5YBxz0eWqVz6eqRkKNojZ35Ix6Z9zjboc6KQyj52wbWGxiXbVAndNFIjhzVrofZ0nUqpkEidsQFA4vihj3Rpgwyl4wMqz0OLzsNi3On82gdiwmEhIeTf68TrHV8kOkoiaLVsvVQCdsDeG5ENzzwTOfeek7a2nEVftShMFpP3OHZ8izZscRodCyZpcYqyj0CLjb79JbYlXjefBlohUhiPhCszRv3XuHfI9OB4CJxcpvUblr4nxpENFo8hDHaW+47MoC3r70oLeD68+vwY0opXIyxV1C1hPbiejlyY85MIinP3WBsi2pSnv/Q0gui7qaE2CcI8uxOsVJ4haJuN98DThpx9ElcmZWqp1WUDxeXiXm6GLXk3NSg822Oylj6rR8ZYunB3IKbfMTzxj6oba2Ca6jyrGYXA4y/Xbu4/5IhLVmjul26qGyBxPdNXbjKfBNE
 QURQkPPY
 uzKGolRrR7JTEmL+dXogr5hSfSyAWSVMl79cUCGyrsGJac1fqyGkn7+D0fHHWxXW13xxaslNSiGMbhwSGLc/eodK1Cg1iazXhX+OWvT5KXV9dcf5h51kXI5/tlt98IbYIA7HJ1SQlpIlv9Ns/8JOCEisCk1z0Qx8033Ba01K4uFpDGmmNosFCIgRwpzQ9Ysw9nrLYtjNC989sjmt3XHoeXo8gvGrcX6yST+5L6tBKGQiEe4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply the cgroup tier mask during swap slot allocation to enforce
per-cgroup swap tier restrictions.

The folio's mask is looked up once and passed to the fast, slow and
discard paths as a parameter, so all of them act on the same mask even
if the cgroup's mask changes concurrently.

The device tier_mask is read with READ_ONCE() in the two paths that
do not hold swap_lock, matching how si->flags is read in the same
allocator.

In the fast path, check the percpu cached swap_info's tier_mask
against the folio's mask. If it does not match, fall through to the
slow path. In the slow path, skip swap devices whose tier_mask is not
covered by the folio's mask. The discard fallback honors the mask too.
Without it, a discard on a device outside the folio's tiers still
returns true and drives the retry, so the allocation spins through the
loop consuming another device's discard queue while it cannot succeed.

This works correctly when there is only one non-rotational
device in the system and no devices share the same priority.
However, there are known limitations.

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
index bb953dd33ca0..b246eff25c96 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1364,7 +1364,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(struct folio *folio)
+static bool swap_alloc_fast(struct folio *folio, unsigned int mask)
 {
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
@@ -1376,8 +1376,11 @@ static bool swap_alloc_fast(struct folio *folio)
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	if (!si || !swap_tiers_mask_test(READ_ONCE(si->tier_mask), mask))
+		return false;
+
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!offset || !get_swap_device_info(si))
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1394,7 +1397,7 @@ static bool swap_alloc_fast(struct folio *folio)
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static void swap_alloc_slow(struct folio *folio, unsigned int mask)
 {
 	struct swap_info_struct *si, *next;
 	struct swap_tier *tier;
@@ -1405,6 +1408,9 @@ static void swap_alloc_slow(struct folio *folio)
 	for_each_active_tier(tier) {
 		prio = tier->prio;
 		plist_for_each_entry_safe(si, next, &tier->avail_head, avail_list) {
+			if (!swap_tiers_mask_test(READ_ONCE(si->tier_mask), mask))
+				continue;
+
 			/* Rotate the device and switch to a new cluster */
 			plist_requeue(&si->avail_list, &tier->avail_head);
 			spin_unlock(&swap_avail_lock);
@@ -1439,7 +1445,7 @@ static void swap_alloc_slow(struct folio *folio)
  * Discard pending clusters in a synchronized way when under high pressure.
  * Return: true if any cluster is discarded.
  */
-static bool swap_sync_discard(void)
+static bool swap_sync_discard(unsigned int mask)
 {
 	bool ret = false;
 	struct swap_info_struct *si, *next;
@@ -1451,6 +1457,8 @@ static bool swap_sync_discard(void)
 	for_each_active_tier(tier) {
 		prio = tier->prio;
 		plist_for_each_entry_safe(si, next, &tier->active_head, list) {
+			if (!swap_tiers_mask_test(si->tier_mask, mask))
+				continue;
 			spin_unlock(&swap_lock);
 			if (get_swap_device_info(si)) {
 				if (si->flags & SWP_PAGE_DISCARD)
@@ -1749,6 +1757,7 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	unsigned int mask;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1772,13 +1781,14 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
+	mask = folio_tier_mask(folio);
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
2.48.1


