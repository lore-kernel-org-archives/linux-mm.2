Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BB2FED9FD
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 18:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E886B0096; Tue, 17 Mar 2026 14:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290516B0099; Tue, 17 Mar 2026 14:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6F06B009B; Tue, 17 Mar 2026 14:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F25736B0096
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:13:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A65F01B6FA2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:13:29 +0000 (UTC)
X-FDA: 84556352538.08.E1207A6
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6DFEE14000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:13:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773771208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/V1V7z2CUnekQaC1Prdn9vb9EYdGjiC71Kz6Xp5hKU8=;
	b=lf+4Dz71zxJsqB2nOy6Dhf/tLu+BdK/faDvjLkSkgEEbvZkfpQdjfz4N+tfO96EVarD+0f
	+lpPw3hjDj6aV49CuaDURwYlgLHWmylcuhpLZORiEDYwJQ//ceMJdrsLIt9ltBel3MG9PK
	w5ow4jBP42IIFjcrqQlM52/+iAz4Yj4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773771208; a=rsa-sha256;
	cv=none;
	b=f2Q/DYD+sYCkAIFnACMWuBRthRfxH5niYqBz+6T4CNz0TkXfzJ3PR5QbXgWsJTVhqkWioR
	nOAwsSMBZ2Ur6NDoZMaO6Dg7AOSSyoWJUV10LSUjnbAQJ8eFFQsuw+i1u71+iqPDFCc9Uh
	LNKr8vzRXAkTyf2WMidGTwqkSpjGQm8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 18 Mar 2026 03:13:24 +0900
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
Subject: [PATCH v4 2/3] mm/swap: remove redundant swap device reference in alloc/free
Date: Wed, 18 Mar 2026 03:13:17 +0900
Message-Id: <20260317181318.2517015-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260317181318.2517015-1-youngjun.park@lge.com>
References: <20260317181318.2517015-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DFEE14000E
X-Stat-Signature: 139bfgeco6ryr811t4i7g3gio1ak9yxi
X-HE-Tag: 1773771207-826468
X-HE-Meta: U2FsdGVkX1+6lnUvomVnCiE4lJ2Wb8NeAWXW+t2qoFOhN3r0zH4BsLde6rgHcSJzvwSlkkL9utiC5iOaySq7XRunctp+rrV+2EnyvnWNPrXT6i9u6+QozHzEhN0gF9Z4leu5uuECvuBUL7KTpyUV9xKF6ZmgA7WmDDkfcNtqDfahe0mWsrtjtPiIvbrZQljDHXSws0PIC3NlEwKCHbA772fM2CIIBcC0jW83GQki4pNOYs1Vw3IVYP8vYoLEqrS9hToeYX13fHoNNNIFZLtKmERxKnLtp1ljHxLFEoPgaCcyLCOGKC9tDCSpJZharTJgxdQoSpsDcTCdKTNF9d7qtNa2rjVPQ1cKAZpT0uCmX0I72/DAySV+KRz/Od81ywqOkJOaa8u++oMvEAu3KhxEG9wbpM4OO5oHLwh4qPG2AyOEe06XuK9Qmn9sVzGpRSgZw2RnckZlIRYj8aYNP3L14EKVG3zYIoudLooX37XaQ4NxE1X9rakUNO5RMNfRO9sdeSGIDyuvmYtDD/GAa71gRu4tG6+Sv7kWxJ7uC/Q40LAiE+5hchhLFXggBBIwP+sVWSPzskLhiH6k7N9oe03K+llpB1vY3VHgHaw0L/J2nBHUrd4Grr+0oTazC/ngIIpR5Kw0OJIHtKMxOVAg5RNeoKM625lk8NEKlAhZ2pEgPJZA6Kl+mZtChtz8b2kzbio+TczHJbVx1tFEX0VvJLx8F3TCpWtZsyQjDHajS7jzv6//EshVN+B4vxgrOTCW1LEQnTZAkG2YY1LO4oMlpoqya6KBXKmuUcUZiRbx8c+6/e1btpd2vrmWiamoRDGHSSawOreLExMDUNTYsF27fR4PwddxspnYGEvZKGKQ7zdxFQF4CRzejrUtWYdW8qv8vmXAGweX1ZirLOZfkMeSvPm4i0vHRY/rxrKd+pOp1aFT73NCmNYU+ac+Q7j9UwxLZA6XvLIyfD791wNBA3DmBIt
 utjqfcrZ
 MQzdz64kkZrr8WaS9rO2ikOKvl5/N+TqBk85nLahVHsY916n5gjYv4vYM+qJ9ycCYHlkGYuW9vTuVmdIlcMoNxcp+GFK9ZrTWsXp6ue+SmgFw9AvAq87tTxFNyswLeVzt8up0DcI1BrgKoAZpdOhHfcJnazX8elL8upJE
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
 mm/swapfile.c | 62 +++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7baa0f270cff..73159535b085 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2078,7 +2078,12 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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
 	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
@@ -2089,46 +2094,40 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
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
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
 	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
@@ -2136,7 +2135,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 	/* In theory readahead might add it to the swap cache by accident */
 	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-	put_swap_device(si);
 }
 
 static int swap_type_of(dev_t device, sector_t offset)
-- 
2.34.1


