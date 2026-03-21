Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B911094468
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 10:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2090D6B009B; Sat, 21 Mar 2026 06:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB8E6B009E; Sat, 21 Mar 2026 06:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033D86B009F; Sat, 21 Mar 2026 06:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8B4C6B009B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:33:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8685C1B8198
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:33:20 +0000 (UTC)
X-FDA: 84569708160.22.216BD70
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf02.hostedemail.com (Postfix) with ESMTP id 57B4E80006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:33:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774089198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cTh3SjyQV9zVIHrEEyzDbGNBD7xaCu8FNq5LhVeb820=;
	b=Y9VJsiaM6qbMDm1peTvJZYILPJ9okt9jXxaH9kq1s+JKwkwBkJiS7ZwlPYYTagAijxXx0i
	ppQI+p+faXqyJtb1IzKXWhQyIsccDY2czEzif4kWN/TkZsrC8mhEnJM/CsmkmgQ9brMJnU
	15v57WHaHVqzZ1unvhTc7vDql5WKl8Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774089198; a=rsa-sha256;
	cv=none;
	b=B2Nm4pnPNuHhMtr+M2kKTgee8swmdlwJyuMSFZRB4HfnS8PfisUdhgCFdlDxNnmPdkrtXo
	74XvZs7Tmz0EgQVDQqdTW/1CRum26TiQkkpjSdcgxqiGdlddCQtkfes92CxQyQzD9dcgUy
	q8gDWK5uynM6/kwj3pXG3Ojj4ZqKHr4=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 21 Mar 2026 19:33:16 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: rafael@kernel.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	pavel@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	usama.arif@linux.dev,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v7 2/2] mm/swap: remove redundant swap device reference in alloc/free
Date: Sat, 21 Mar 2026 19:33:09 +0900
Message-Id: <20260321103309.439265-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260321103309.439265-1-youngjun.park@lge.com>
References: <20260321103309.439265-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57B4E80006
X-Stat-Signature: ddpywnqkwe4awkcndq75nc46ccswm4mz
X-Rspam-User: 
X-HE-Tag: 1774089197-757048
X-HE-Meta: U2FsdGVkX19t4ypP5+0pVaUvtQcWeA3/2ZSIgIx56myXl/vJ7UbMgDko3VG6LF/2ScgITHKW+aR9Qb0JJpP8wnsbgPvPee4yUrWa3g61kECCJbS9K5FQE9uaLVdAxlNAEQhUbg0L7M86kIL6Lb+vaJ6fzjxqd08SnLzoyZl+GDMcJ48ehE9cmGUYsdG2zihD5KfOChvXxYuM828C4StoDZvjX0GAslhKzbGYEx4xwislXrF0fK/Pdl1A7XcxXHcV9muS7LeNvEwxaIPpxe+nrU4r3HerNub0iTqmTF2dCWm7m2FLIRZaUcvRaishGnI28a5eZW31xy5EihstJxikdh1r0A8c2cxHadtI5vJYggFvlQrp3so0n+JS1rb/MqVLDhEmU9MF3E2URojPrUhf16+XkTuPN07BNbyYzbJ6Wxk/JeM0RJo476T+RLIzr3KcYOuK0v2skYwlSl3vM42BEfri4Ad4nCOM4bBwYj/MwZfD564BpjIV8R0nrytPkAfY9Gxm8TOQFCG74eAvl3zvtG8OsxCK8Z+LomB9jhk008L6yZMTGQehd+hXhYKFGgUYoCGeBfQIYoxOUcL/Yhy24sLUQa8tpIIiH4mBWUK/Org8hXj0uY7ezYAV9Cx1Va20kCwpbB50b42QAhz8vuU5vgMl3/ShQ+WbWlZIdMDrPRgBiQKXuW6wYuT927zsT13DquR3WBjXSwdDfj2vD5yMPJpntukCVm6if7MrF2ZM07O5YSvTv46FyjEROEFXv/aAVfkmGsM6eItNm2CnFKRH4JXWTrBpUiGKGh/okAKI85Ep1RblnYvETXMsRAQdm6ZlI97oyouO3i9GqU6N4lfaXew3P+Epk/dcDpuhc/8UbZrFvGQVOxVBIImkW6OWpybe+nC+5pFx7YTjwpPviUIDeIPdvNAaIL+TlJg/iek0/FN+ffbz3nzioqzhufnnmdXLp7+It+9HHNwCDayAR57
 KCuH6zWg
 H9WOaiNb6soV7cfEqUY5ilQNO1ET5U/JXD98WBLppK35AzxG/NOdn79LyP7infszOzWeqXmFLs9El5O05b4msUEw/SOOSNLWag0cU8BiiPhIjO9JLFZlFR8hDVNq+YsUVmzDMruwBUsnVYFxY9Fby/zAn1fOEzi2mJZVY
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

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ac1574acade7..dd9631658808 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1923,7 +1923,12 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 }
 
 #ifdef CONFIG_HIBERNATION
-/* Allocate a slot for hibernation */
+/*
+ * Allocate a slot for hibernation.
+ *
+ * Note: The caller must ensure the swap device is stable, either by
+ * holding a reference or by freezing user-space before calling this.
+ */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
 	struct swap_info_struct *si = swap_type_to_info(type);
@@ -1933,43 +1938,35 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (!si)
 		goto fail;
 
-	/* This is called for allocating swap entry, not cache */
-	if (get_swap_device_info(si)) {
-		if (si->flags & SWP_WRITEOK) {
-			/*
-			 * Grab the local lock to be compliant
-			 * with swap table allocation.
-			 */
-			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, NULL);
-			local_unlock(&percpu_swap_cluster.lock);
-			if (offset)
-				entry = swp_entry(si->type, offset);
-		}
-		put_swap_device(si);
-	}
+	/*
+	 * Grab the local lock to be compliant
+	 * with swap table allocation.
+	 */
+	local_lock(&percpu_swap_cluster.lock);
+	offset = cluster_alloc_swap_entry(si, NULL);
+	local_unlock(&percpu_swap_cluster.lock);
+	if (offset)
+		entry = swp_entry(si->type, offset);
 fail:
 	return entry;
 }
 
-/* Free a slot allocated by swap_alloc_hibernation_slot */
+/*
+ * Free a slot allocated by swap_alloc_hibernation_slot.
+ * As with allocation, the caller must ensure the swap device is stable.
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
 	swap_put_entry_locked(si, ci, offset);
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
 	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-	put_swap_device(si);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
-- 
2.34.1


