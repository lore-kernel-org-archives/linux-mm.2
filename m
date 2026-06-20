Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F87ECD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 18:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666576B0096; Sat, 20 Jun 2026 14:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E246B0098; Sat, 20 Jun 2026 14:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554156B0099; Sat, 20 Jun 2026 14:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 237E26B0096
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 14:17:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E8A08CBDF
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:12 +0000 (UTC)
X-FDA: 84901097904.26.EB8109A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 868F4140007
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BShU0Tu9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781979430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYeylIml7s8sCOsaJDbGPnepJyRivCDRMtCf2+mDIaE=;
	b=3e7Y2yqoumlIFftd6jkU4+GNNKln+zdp5IOBVQycA9VkwP4gVYF7zLwkc9Lmd54ohKZkY2
	jDyIuUi11OlVjGRfhny36stZbJ4TPAV+HzCYM6OntMdW0lC6R2Hem1pzbUkWRjOZOn34Ny
	UW6J7Cr070B0UUy88jG6FDdjZEJwGLQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BShU0Tu9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781979430;
	b=YxxJUiMSuWAGtMFCdRqTVALGz6nOsFHtKvDAsX3qbJsSwbEv3v07qqobwypl+vPlOEgdVY
	6QqGEWDCN8vG3DmYGvjc+aZklMBpCM1oRVxSeY8ZFh+mgT6AphFjaiX517qNnbPGC316Oe
	V1ya3Oa27cmygRDDmpIEBrh3Jp0gMb0=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c6fcfcdb2bso22600085ad.1
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 11:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781979429; x=1782584229; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYeylIml7s8sCOsaJDbGPnepJyRivCDRMtCf2+mDIaE=;
        b=BShU0Tu91AnVGw1lcC2z8wuYmdwKiMsIMjAyqXqc0LAAh6EYTQAPOBDWZDofGUV/rO
         VWdYDJM3iaKTjS1xrvuGSBTCkK6si1IZx87ISd0Hp+8ZSZND6aui4NO4IZvrXMooDlLr
         H4fnK2ggVevYnPs4/FCGNTgLNZ4EqWRroO5A5+UO/G8JTdrDUpqB0OnWaTzWNn/E0Bep
         HOcCmzgF0QHVv4OOsWXHu4spss9PONBpTQrNUrUxNoGo+CX6WF4ETCaJTKp1gWubP8a1
         u5efSOF9pjXT+I1HeZMqOdXJjKyg1l0+N5Hoefq6emTb5WWEYZHg0oum/hyDO3BCYL0C
         yg8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781979429; x=1782584229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GYeylIml7s8sCOsaJDbGPnepJyRivCDRMtCf2+mDIaE=;
        b=ChbsHjw4HrWwbV9ObfVSluNkpACjqSxqdeNJVA5b6vw8WNf28GuRX+bXc0qLNa6/SW
         /J/pnIjzq7ZaN0XEL/rYquenGlKtQlW3HY5bLpSC7s+kXgsipo/s4SQtZfTraSXCYtQi
         F0DP7NsHWhz/csODh92VgOW9EQIB9SYJmfrVv97iu6fM6oYWr6Yy3qcZWOudD2WPomyu
         9BT1vt2FuqIxpicOfWDgh5CcdWThHZAGSnJdyEAM4KcKCpR84fglcjAUgg8+/JRNxm/v
         KoWOWoPNTBJYgPt1JT2fGex9XpkmAmMkuGidKlzvzopSJwzrx4ucEwZaOxlH1agFScn1
         6skA==
X-Forwarded-Encrypted: i=1; AHgh+RrQ3xizJs7APiT+TLZZMIZqemdpGuLBaVLuxCHGkdTu7OWE04p6kJGXOZ5togt69WCfRUYNAM6a5w==@kvack.org
X-Gm-Message-State: AOJu0YwULNFzlwQGf0/L59/BB6TA7Y8y9X6Cft+zMsi6OMF0aw9OMfQ0
	ivVfM8K6jzDiN63efse2YS4NR4QrGkYq8iuR1QTwj/eBElkUWVD6KxcK
X-Gm-Gg: AfdE7clngx7uhCVEySXZIgkEMHX7ZSGV0YIcXXs6nKSUMcA8dlmLlAObQTZv5VWeLeu
	BAg89wjyfbDuDUNZ1syZKikI+xu+aFoSvmGsaiKBc69lB5dOfSf04z0lim5x0AqgOkoCLQNoaNm
	HpVFuC/elxFue7JazN/rdtuXM+6vihxU9MHUO3uFyGx2ih7klFhtIu1S44h9Y8UNVBubUoOo+kt
	yOmrQVw3Rwa2kwmfxO45nhYI54UUxjH8nAqnkyvC4On4/jhFNOGlVTRIqk+lYM6Y5B4F2frin18
	oxsReI/0PdEpiYnsI0hNmvTlcZM5kpC2oDJZLnS8zxGmsTX5jUDk2ryd/WTEscIQKYwBfK6AXrs
	+5fvVxkm5qvXFfNc2G/boQ+MmmQOaSgodFRbCDXR+fOiQNN3oWg/CTw16Qo0w5iQrmKEmk3VbDQ
	GyCmw8//YPvGxZE8iIRCQMJXNY5xg2IZ4Q9edhF90OUQ5/6uAbiz+8BZAAuUsgleuhYEOPmwoXJ
	w==
X-Received: by 2002:a17:902:d586:b0:2c2:27be:39aa with SMTP id d9443c01a7336-2c725d7d58dmr82330625ad.17.1781979429395;
        Sat, 20 Jun 2026 11:17:09 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af6d9sm30339465ad.4.2026.06.20.11.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 11:17:08 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
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
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v9 4/6] mm: swap: filter swap allocation by memcg tier mask
Date: Sun, 21 Jun 2026 03:16:29 +0900
Message-ID: <20260620181635.299364-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>
References: <20260620181635.299364-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 868F4140007
X-Stat-Signature: 533s488frahpnjzrn8j8zdwuimqfgrgd
X-Rspam-User: 
X-HE-Tag: 1781979430-524823
X-HE-Meta: U2FsdGVkX18ulp47UXT14yqjwJ1+BMZgBgeCPwAub3P/r/viPo2hANX+Dtpm06HeHmYYZ0somo66BcX9Salv/p+8vRFe4KZ+TY3hWhiv7vITwXeTgIb8IjsfGtXRV+KkahCv4e9fobDcEga+93aCDlZAF/7QgmK5z9Q3+dKrsNw161Owewbx9YnivJnsvvixLJ4raYAGlbLAgGGbCwiHxbPu4qJE05akJ/+tal2y2Q/Annnd5htk+aCAMeI8jLeXDGq0dsrUY12/xLZWuY63ZNfc8P3eqHCmV/rJ+6RWUhOKcDgkKV4XaeDCF5UMvzZ2d2Yb/Y0kye6hHVmyCcSFwQg49tcb87udn8zoFKrCW3tYSENs9fqTGCJbyo+fjK9VF7PZL0xzig2km+NOeU/j5WGuGG8kayP4nPsRcWmp547FDAlzzaiq1pGLUtje1CXHDheWLCKpcYmfxrF44tbG7+cd7l6yOahjpFkkheureqfp0MT9doajO1ENuFcQxtDnxuY2ZZqdH72FxAkOmiZBJkapg6BlzeG14gJKL/HO7pcYZLUp8kpV9Wfhhp0OgFzZLWUb5HPr432RHc+oo5AovliIImUBzvsSiBuaF/TWYN6fU6OmMTYGQOiYI5mluRib+cF5lNH4SFsPE09/I4O/TyDKy9wrKpfW9bi15ljG5SRAPjAOK127ja4ukgtK8oMEELYTKk9ixonuiYfnEYHeTKICF1fCKOKUPnSjwTtp+80hL8xYEtiAx91efVUjN04nkqsBvVGmjFfncY/56mHMZzDgChmMeeKBZ9wCGxdaMt+uLcye0XvR9Ce6PJTd6K2VQosOofDWSqdVDlStZt2txq6qwVm62jVLqABZOdvyczkY/p7MtsPXfw9jgzJ+e6pXr7z+xagp3u7JvyRNgWIb/zFBznJhV5lnULYdmoyF7H8CbxEAZsEkTHtFb8Q0kIWjSjSWJ8S01Kn1+EDjxGO
 rFwbh+dU
 LCDaXUvB1Jq7d0sanU/wpxnn7PNxcWUbNGLLW/v246g3NArfPGYk4vkWqYC2NKlrlOR2/mrgAfj76bZm8W7OTd8hWx7/rGR8mPAkommHLI7tiEHirzraN4NED8gCEFUlfdcEFkw0s+vALSkj9jGaZkjwL7lJyfyrSdc1wCYYu6KJmsClGlZAlUS7stEtU9eXSFHdNoPI2+F4zRDm1JSApDVGW0Msq7kKaJ74MqGCZE52h/X0jEWvWhK8qsp+GG60npa+n5nwR7yWGwNo2CyVxTMzEbZwQ4FKl7GuPny78bHICQanRVrmVggsiHOwkJTUStX0zcF7rgVsCxQ3SpkVNeZ2i/2C3AwBZe0hX/YT2KQ8VDcwBnxO5sipiMQ==
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
index 9a86ebe992f4..624d1ba93fd9 100644
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
2.48.1


