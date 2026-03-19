Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16FE31090234
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5216B04DC; Thu, 19 Mar 2026 10:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0413E6B04DE; Thu, 19 Mar 2026 10:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73AC6B04DF; Thu, 19 Mar 2026 10:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDCB66B04DC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:24:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8539B8C119
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:27 +0000 (UTC)
X-FDA: 84563032974.11.ADF60D5
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf03.hostedemail.com (Postfix) with ESMTP id 500EA20008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773930265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZzAuNYcRCTwQCccEV9fvt3KbO94i2TjA68nRsoYByk=;
	b=z7BnJ/3Bh2vmk2GuizlMpl4gYT1uCKlexGRFhu+V8Q7AXuhQa8LgjxjelbS77rK70nSQkt
	J6jE3F7slXwhIaVbs+ihIyi6TnKE/9d9a2cCMonmDrzrbfDYepfjcUIPh1gZiXALaUr5He
	BS9OQWFR1k6Zh7fh0lKUN1I5x/nFTa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773930265; a=rsa-sha256;
	cv=none;
	b=LBAO4x5Y5W5fVfZ7RxLePc+kpJH07Lm75joML2R/fGv0Cg+bYFMi3vm3L4G1/vAbkw8ztY
	Om2rkcetJ3TWhXPFkPRjw3w8RzNgJWuof19rIBpmBXaUXnohUM89WK56G986iEm+eO9KAl
	Z8tPnbj409F8747jl/9BtOT+jKOgoTY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 19 Mar 2026 23:24:22 +0900
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
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: [PATCH v5 2/3] mm/swap: remove redundant swap device reference in alloc/free
Date: Thu, 19 Mar 2026 23:24:03 +0900
Message-Id: <20260319142404.3683019-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319142404.3683019-1-youngjun.park@lge.com>
References: <20260319142404.3683019-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8scbr33gzdehzt5cpekzyqakq8i7s9ek
X-Rspamd-Queue-Id: 500EA20008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773930264-62217
X-HE-Meta: U2FsdGVkX19Yw+vy6lL6OsJ3BR6z8XXACNo4j4wEJBUmpofzHonuqTifnJWzuDI5Z8GO/s2iwIvlBV2w6c8aDjaJGw0OW8V70AQx416EJb/bm6id9cNN+VO53MRDcjjoLgPjhVODBX39oADE4DOLOCLDIJUwfKU17JJEayCseWy/23PiavObxsN7fIl94xTT6Eyw/t6R/AebNBoPeYGtMtbVcMFU06GB0JeE4G8fdrTsFO8l9NkHdXA8joSAMqJw1L3OoY6DjDo6TCoEjTp6pUnaENh5XXOTu7GPL5NNWhXcmjx6m+id/XQb9KLxOimfUMSG+/8W/4y0dJeDIUKaq8+0RiHFumP/mokp260caLsuhj3FvWuMuRQKvq6EGOrEU7gpW1EYzDKCFSRnMuLofvv4Ij1W2pT/y9k1Onzvc9t0ol01i4yYcy3sjglE9z1KbGQazVSIV/aG8cPG7WJa30JR767AzosLVqMb1em9C/Nc3OqRgwVEqMUzq655yZ1wqpUEhJKYHw+SX9TgznXcMjrLZZlpCvGBJFUnI1ULIMD5F3XQZOOyFhW+4e5y/dka7qhBPD5uLICYVTBLowgzEjjsC4UW2QY3Z16+9eUI6EDJdAKxl4CrZwoVwQMHG1h4jgv2PaqYAsB5wlfH/2NXXVJpSHLxPn1moKa7vu3Aogn25k2eB+i5HFDnL3j34p2VXu4tGYN0Z3s7KI0bSDA58CWz+eXOB+CBos4MeF2GmWfxA6c4sCkOxviEVFYP9/uZuTGJj8FIpOtSCBh9fYXI4e4ZyD+NsKShazT+bpnxC0R46HZMyoxZ5/QrxbP7/g4B3hVpR+DjsJn8a1gmbv8Kl1efCxLZibHh907Zgp5AWeJg15KM/kBvQDAcvoFv4O77C7I23V6Gp8W8BGAgI4A9Frw0CJwI+TyK69CXc/D6JX7vAHqC99EYh8JVuzNVN5xwbV6ffMuQLn4PUDVOpoA
 vEBDgDr/
 akZl4uaFJxm2tyyHipSP/ENN8Xd6WNP57OenvGJDLsL8tcwHCKqgGCAOp1vaMDNqd/exXosk5qYXVznCDdToIE71MSl9Lif2bfgybOQNKRbigA2TKOo0Vw31DOYhohV8U+txoU0rZC9v8eg0g/+WgoDJNqkzm5znfqrue
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the previous commit, uswsusp was modified to acquire the swap device
reference at the time of determining the swap type. As a result, it is
no longer necessary to repeatedly acquire and release the reference to
protect against swapoff every time a swap slot is allocated.

For hibernation via the sysfs interface, user-space processes are already
frozen, making swapoff inherently impossible. Thus, acquiring and
releasing the reference during allocation is unnecessary. Furthermore,
even after returning from suspend, processes are not yet thawed when
swap slots are freed, meaning reference management is not required at
that stage either.

Therefore, remove the redundant swap device reference acquire and release
operations from the hibernation swap allocation and free functions.

Additionally, remove the SWP_WRITEOK check before allocation. This check
is redundant because the cluster allocation logic already handles it.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5069074ab11b..f1188743037a 100644
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
 
 static int swap_type_of(dev_t device, sector_t offset)
-- 
2.34.1


