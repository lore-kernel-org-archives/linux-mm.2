Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B9F105A587
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F5A6B0089; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626FC6B008A; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FA86B0093; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F53F6B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE0191C07D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:25:19 +0000 (UTC)
X-FDA: 84537179958.03.7D4EC2F
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id B52D9120013
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:25:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mmu6eowjXLQfYALUOmnNiA8hQ3WwgeeKrRYtMJveR5c=;
	b=cAMbqIohJoSsUlEQd/bckpVEdwaYSESDTAxOrJ7ff2lmKEsN75GRLBma5YKvfS60dkjUzx
	eLBY/Ofczp26tB8T6ec3ZHgU6kH6bCJypuqFqJ9ON0R1za/GnfpKV4dHIJYDgab4UFs+7Z
	C+ZJ2JepyL6k3qcZClc47FvM8Jwr44k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314718; a=rsa-sha256;
	cv=none;
	b=Lh4z3PKqIkQy3w76ptcm1FZm7HbDu94bOiblU11rs1QZVV+MpW5hEEnDmLnoHQZpdcrV8C
	RjbCLxjL3RL2jVbRqEV6y5ZEqLhw/CyfLryvL6zE28h7TFLvvUm0FD2qfoF2PFx3pVx+n6
	B7hpjAH9OsDbBox5693BvSmUsOe0G4c=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 12 Mar 2026 20:25:14 +0900
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
Subject: [RESEND RFC PATCH v3 2/2] mm/swap: remove redundant swap device reference in alloc/free
Date: Thu, 12 Mar 2026 20:25:11 +0900
Message-Id: <20260312112511.3596781-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312112511.3596781-1-youngjun.park@lge.com>
References: <20260312112511.3596781-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B52D9120013
X-Stat-Signature: ipsj6trjjzmt6mopcjwsn8bi1bu1hr15
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773314716-155042
X-HE-Meta: U2FsdGVkX1/VONrjQTxu6uVc9K0HZvBpty7iYK7xj6wtpTjYDx1w55yAC+1fVwM/FZTGae1zEAbSuRWqKpTlGy4TzKbYZQfVIpow5V7HQr1kx5JNmyZ+elabP3/GmDvWy2fg1aB8XR2DP3YNLnXYQM7zuN0vQgLX2MfG3Xi0cO8AdnW324ZGtgEqZR1Gaf8mEth8+jH0JO2aIW8ZrvAc9ijvYn3AutZlRHIAs1yVKMX40vQU8s+kmKMrP5vanx+3XN9BrUo0XvwXI6qCrf5e8lyVxM5KXQ69vdN6KCqUqsyYoHSvYo9/jN1ZJR4YWMGqGricCIgYwe340JVcojqj+yLV74cziYOFS2xluoIAYabQt76rQ/E2MaiaN60NyYN492Hc+R6CsJT9inqwF9SvcPBMiXdpCHZiAXQ5gwN6iwivYZdj+mzkCVLvYm/NAk9IpXHPpDHKit5fnh+lO07Pq8lo7YKaL9GozvuZhhz/43dPa2EPu7jlA+7UsRfgg/YOqOvzuqb5NeQETw4nZxxmP+WWp3XYCf0zo4YWAtlRWcpFChs0zya2YFOwuMeOgSjtGl4trjOhoie/WwMsj3cWfdYXjaAVNNV/4fgmpGNWSW87nRqoR9IyTzpC9fvp+M9F4MQRnZrRSTbB2mCIDyRekC/gH2CiNq0GErm2C5czZJlpy/H+GWPP6dp3h0xJrB9LY1FhziFPms9ODxDUM7hCS+kEBNDcPRt+NgQHwSu+FMIgPiq9maXO1ojwPZl+oyh7woHvBpDUKlJw27paM6yLv8jxrC6wTyxNQ1GulTG4c/ZwKzHaGN4oatWEq9EbJMf+QfklBAhzX2TJSvakMmjHQemb/7DlScW0/19KVYM+AxgNLAPcQGzdRzvuSugQnRuvKqsLVCizbgmRs8W8eEBZZVmHyvR6fhxZgSDEcTcWndCboDQGE+I75RzVB54zGgqMZRVDIXwGjy2pJjqmTJL
 L4GZncRE
 /m6+a+UNCp/VdR49BrOZYC4fX6NFTudF/QfZrCDSYvwNCb5SlANg01WAjdg06irL39wNX+AwLNOzFVkmdHCSSyoowAU+hIS2/TjG8BnqBVlhL8tw+FOCF+Iwbwamg8lw6QJiXh4ITCQTM7FFv3EaNCK7gqR4sEC8SfcjI
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
 mm/swapfile.c | 50 ++++++++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5a3d5c1e1f81..8467c3511870 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2091,31 +2091,26 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
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
@@ -2123,14 +2118,10 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 /* Free a slot allocated by swap_alloc_hibernation_slot */
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
@@ -2138,7 +2129,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 	/* In theory readahead might add it to the swap cache by accident */
 	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-	put_swap_device(si);
 }
 
 /*
-- 
2.34.1


