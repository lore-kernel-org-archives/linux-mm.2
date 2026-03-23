Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B9BF483C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575546B008C; Mon, 23 Mar 2026 12:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C336B0092; Mon, 23 Mar 2026 12:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462196B0093; Mon, 23 Mar 2026 12:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 368836B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:08:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3ACE1EEB7
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:08:31 +0000 (UTC)
X-FDA: 84577810422.07.3D4DA71
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf14.hostedemail.com (Postfix) with ESMTP id E403E10000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:08:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774282110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7lBYQbO7UqN8914FwBq0/YiV2qY7hNFJS/1qWqLxndk=;
	b=MHfbkuemoOmwvUHaKMOpxgLeArzKuTKdQoGIGkBc97yIgKqrxal2zqPfxffg+xemfSEMgT
	TygCZR9qLunVhijc76KNb39j6qn195EunIslG1711xItFtGb/UZMdjNZAGm/SHuFxsl/ZN
	626W9FOd05QlDmckF6x9hshJ9vy0E/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774282110; a=rsa-sha256;
	cv=none;
	b=OfVAHM769nSxScV9Ftpmv791i7G27+b94OXit0RUzfHjr0SBbACR31KVm8afxWwoPTzh8h
	m/xdLYxt8n7kK3gGNE2NZd/Vmih9ZXyh0z6hMrN2/XpOvA+DjyrHo0pwiA7mFWg1vbzeyy
	F2ci7UrmZM3ooWvuk7gY/U3bOGFlPUg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 24 Mar 2026 01:08:27 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: "Rafael J . Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Pavel Machek <pavel@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v8 2/2] mm/swap: remove redundant swap device reference in alloc/free
Date: Tue, 24 Mar 2026 01:08:22 +0900
Message-Id: <20260323160822.1409904-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323160822.1409904-1-youngjun.park@lge.com>
References: <20260323160822.1409904-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E403E10000B
X-Stat-Signature: 79jbo7gmdr6tkgyjr1n69bnuo1sytp7b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774282109-648601
X-HE-Meta: U2FsdGVkX1/+bs9s71sM5IC+ku6Y+NV+X1qgboVYiiTWy0pAzMji12zsGP8anWpDwIWKm813LGh4KINpR5u5yodIJ4mJ1+wCflftyNf/OkI5Z9pzU2wi18hq/TCz0TrWhUbIeFHTNx/tLL7rLUlV8heN4lVVJuN+H+KmYZjCGb7911unOls/m1tSUdpzMX3jDDWYA2wkXp/bE+Nj279fbcWWKteii4qf21fvrUN7z+oaUAhlhcewndDxDqyUzUwwtwx0wjcz9pS6qi9V5qkGL+Qhnb65NU1D0XiE11pteU2AUVG3DFFpdMEnG1vLkxE5vzHHWTytYYZ2iAjeKrxUHQaJHYNmggPIFNmrpgp2UfsdW9rJZAg4fDnu54bSmngy1t45Ty639yWafcb74nUV9KTQDPmg0b+DTAZf4wI9KmHVXSKSVxx2VEWJNnWehqVJRU/KRc66csP8vm8kQaOlLjLbd0CiPwGrvmtrD+I6GacIxCgrFwPXL+NXtw2klsEyu9wXziosTIb1oK5CopsFtplvJNx/bogVOrqewWYdyrDi54Oy/gUQhdyClP7O93fzwt/IlEZVWQoeHHItQ68i9E9OjnClWNQ4CM24rfvYrIiMwp6vWcLsvg3H/V3Y14997uWGN6nLTeqQ2gXKOhB/ynlDwLdWTzzR5HinFsAITJHj3CZ+ra4/ml0CLY09ATMiR9wwlf21AiBiEv3AhPA4Doy7i0H5Kux0Yg1pqFOcJMSxtYQoCvPTZLbr8WNl2709mK834mUms+ZFOAmCzjqUS6NovCyOm7PVPDWQB43yPloh/LpqP+dStxUHRCvovaYhl+80+ZzjJ59DiZJzd/x7NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the previous commit, uswsusp was modified to pin the swap device
when the swap type is determined, ensuring the device remains valid
throughout the hibernation I/O path.

Therefore, it is no longer necessary to repeatedly get and put the swap
device reference for each swap slot allocation and free operation.

For hibernation via the sysfs interface, user-space tasks are frozen
before swap allocation begins, so swapoff cannot race with allocation.
After resume, tasks remain frozen while swap slots are freed, so
additional reference management is not required there either.

Remove the redundant swap device get/put operations from the
hibernation swap allocation and free paths.

Also remove the SWP_WRITEOK check before allocation, as the cluster
allocation logic already validates the swap device state.

Update function comments to document the caller's responsibility for
ensuring swap device stability.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 68 +++++++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c5b459a18f43..ff315b752afd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2077,7 +2077,16 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 }
 
 #ifdef CONFIG_HIBERNATION
-/* Allocate a slot for hibernation */
+/**
+ * swap_alloc_hibernation_slot() - Allocate a swap slot for hibernation.
+ * @type: swap device type index to allocate from.
+ *
+ * The caller must ensure the swap device is stable, either by pinning
+ * it (SWP_HIBERNATION) or by freezing user-space.
+ *
+ * Return: a valid swp_entry_t on success, or an empty entry (val == 0)
+ * on failure.
+ */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
 	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
@@ -2088,46 +2097,42 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (!si)
 		goto fail;
 
-	/* This is called for allocating swap entry, not cache */
-	if (get_swap_device_info(si)) {
-		if (si->flags & SWP_WRITEOK) {
-			/*
-			 * Try the local cluster first if it matches the device. If
-			 * not, try grab a new cluster and override local cluster.
-			 */
-			local_lock(&percpu_swap_cluster.lock);
-			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
-			if (pcp_si == si && pcp_offset) {
-				ci = swap_cluster_lock(si, pcp_offset);
-				if (cluster_is_usable(ci, 0))
-					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-				else
-					swap_cluster_unlock(ci);
-			}
-			if (!offset)
-				offset = cluster_alloc_swap_entry(si, NULL);
-			local_unlock(&percpu_swap_cluster.lock);
-			if (offset)
-				entry = swp_entry(si->type, offset);
-		}
-		put_swap_device(si);
+	/*
+	 * Try the local cluster first if it matches the device. If
+	 * not, try grab a new cluster and override local cluster.
+	 */
+	local_lock(&percpu_swap_cluster.lock);
+	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+	if (pcp_si == si && pcp_offset) {
+		ci = swap_cluster_lock(si, pcp_offset);
+		if (cluster_is_usable(ci, 0))
+			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+		else
+			swap_cluster_unlock(ci);
 	}
+	if (!offset)
+		offset = cluster_alloc_swap_entry(si, NULL);
+	local_unlock(&percpu_swap_cluster.lock);
+	if (offset)
+		entry = swp_entry(si->type, offset);
+
 fail:
 	return entry;
 }
 
-/* Free a slot allocated by swap_alloc_hibernation_slot */
+/**
+ * swap_free_hibernation_slot() - Free a swap slot allocated for hibernation.
+ * @entry: swap entry to free.
+ *
+ * The caller must ensure the swap device is stable.
+ */
 void swap_free_hibernation_slot(swp_entry_t entry)
 {
-	struct swap_info_struct *si;
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_cluster_info *ci;
 	pgoff_t offset = swp_offset(entry);
 
-	si = get_swap_device(entry);
-	if (WARN_ON(!si))
-		return;
-
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
 	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
@@ -2135,7 +2140,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 	/* In theory readahead might add it to the swap cache by accident */
 	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-	put_swap_device(si);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
-- 
2.34.1


