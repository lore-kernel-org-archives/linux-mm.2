Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EB31099B25
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DACFC6B00A8; Fri, 20 Mar 2026 13:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84136B00AC; Fri, 20 Mar 2026 13:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99676B00AD; Fri, 20 Mar 2026 13:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B887A6B00A8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:18:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D5F7C177E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:18:25 +0000 (UTC)
X-FDA: 84567100170.15.5233124
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D410C000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:18:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774027103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cTh3SjyQV9zVIHrEEyzDbGNBD7xaCu8FNq5LhVeb820=;
	b=en9vKyqectzp46yAEXzRoDPW9lZaaeVqhyr/Ktehx3ZIiq/osCklPVyOQ5RIGnbBkDkEZW
	u52ZjGCPYuaxXuDZRvOO38WEFXfdCmTm7ATOEPE/jxmVymNlNNOdOFm7jo1WlrLNCFAfEC
	TbkhI6/TRtkn4MUvCpkLKNxROSrWfbc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774027103; a=rsa-sha256;
	cv=none;
	b=sMM6CoFExQZlMqA8lGEXLB/Te6BJIFoWawdrDectiTaaCJb22EZiaNGm6MjG/h6vG7TOWk
	vqPhy3/5B/Fzfiy1nav8M0hxUjhS0sW9e+S7cfXGw9s6jfwPvYP7x1j46kdyNqC1HsQ+Xa
	9a+26SWibPkoQ63uK7MPfnMZpHKJ7n8=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 Mar 2026 02:03:19 +0900
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
Subject: [PATCH v6 2/3] mm/swap: remove redundant swap device reference in alloc/free
Date: Sat, 21 Mar 2026 02:03:12 +0900
Message-Id: <20260320170313.163386-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320170313.163386-1-youngjun.park@lge.com>
References: <20260320170313.163386-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D410C000F
X-Rspamd-Server: rspam07
X-Stat-Signature: rdkewxejut1uxyfdub7cidp9nzyzrr56
X-Rspam-User: 
X-HE-Tag: 1774027101-139906
X-HE-Meta: U2FsdGVkX1/1IxuJOgeqLy154ppIMP9XY6ce5F3MoPkNdk8bcz/0Ge42SHp+3UpWQzLa0yTkfJGsjCIm6pgD9lhCX73SOalR2EB9+R62eYCWROezZRchY1ZTgV+LUynah0Ol4cBQ4+j4YZ/rgK7JMWVbPTMXhaeQOfcdhQmOsOiNej8vk+PyuLl45BAcBiwjUMZ5ynStNG4Q2k4097y0aIDA6U9zv9Y5sg2qTPjSXawB8QdlpixYMPLE1+sIEwPfGhpEdbtqZoVToqNsfcfHh5s8kTBRAm+vT/9XmmjPrmvbjUPyKKVg9Wq57qS2g/NzPjkfITX/5j1YNecBxxTeGZq7KSu0NIX4S4+Hb0rLkMQoJLRu6GDkwZjspcPQAPDuGoGOXFna6stgdXNOrBFYRk0nCqmDurnyhGFZx0FahtmYYUUW8Kh3HM7DscX4Gp9T9IxA/XLQ4aZpwCH+YC1WlHlGQUWgwyFv0YuaO/pE7LJJ7WCzrCEkRwKjCuGb40pkQCk9nuhQ4cnt0oGe3DjfAVTG0ZyF/33Ysvjif4lksJX2bAcWctHeVlIpuCfeXVJvxoYteUstDgZAZ0pYrUC95YBbiqiSNZXNK+qkhNZUVDVAJN2Rtq6QmdfV/KRn2xwYyEuMBI7ClzqzfcaBD2uRxXZqae4wCPkBWbmodPvLRP0o/Pjlyh0B1GgNk2DiCqdzo49vcUXWdiLKb7bWckEllTLe+1keooKcWejXqkmvmLOSHqLxSTDEwL6RSrF+LHkfiXJOs65RK2l1NQLBGLdENetNFA1ljX5KR9alyU90S1TdJmrwjBdj+ymzuan9ivfa5g/oltWEvMrsOEw2lj3z/7T+GYTMODyFD59eMJ9y90iXvAMNmkAz/V8SQlWN+LDxRLL8BRpbIT8lnLVOavYmVR5JPiMVcI6R7RPL3KALIy3RPY9HeDpWrYuBWFalK6xkWtBBjCSjFjbAXPe96kN
 dRVaBAFZ
 W5llKmSTPEOUDlmkv3W1e1Lovz+83VLtXkm7Ccp7guSP/4cA5HFog4G5qdDdzpRD1y1DuhkB7A59Tx9n5MUWIgnEuwUFLY27kaYBxxFNUf9jg3vlAOd1rDx0kAzVTPc4bxURuTpbyUsE2FbvCP+SCy3QkU8cfcv3upUZc
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


