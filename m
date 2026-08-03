Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE55BC55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988086B008A; Mon,  3 Aug 2026 03:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F086B0092; Mon,  3 Aug 2026 03:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E266B0093; Mon,  3 Aug 2026 03:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D60B6B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:11:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02A02805EA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:11:01 +0000 (UTC)
X-FDA: 85059086364.01.8BAD866
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf21.hostedemail.com (Postfix) with ESMTP id F3BAC1C000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:10:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=i2WSxqIR;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2FZl2/YzaMjC0aIAZHsTKk9OBnNm9ulSHwBzV0fwO8=;
	b=ylnmIUYVSfrbox12wgmiyBqmSLg6oFXcpQTLHDPxx57mYeqshUl7SrgQG+etAroUz8Fv5O
	sea6zbtfYO73sosxJLpUQPkP78t2/82KL5FlEqmLL/vsQazGAod7rLM1uDghNLD6TsEYCi
	7gM8a07KcF0JWTO3JYHjekB5qL1IM5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741060;
	b=gJiRunLoLjRx9xozRKS0owkI4Wq+7+ySRivZyPAFhMo+Og3J7ZFg4sJlC3PEU7brNVchrx
	0Ar3Us5KVJrimD0HM4loJmCiY/559p3p5S1L7/Jv5dOCgpcMcGG3U1ZyvDAin+99qsYJPr
	pkF0oOdz52/bnTo7LE/9VQpTJbojcUM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=i2WSxqIR;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741050; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=z2FZl2/YzaMjC0aIAZHsTKk9OBnNm9ulSHwBzV0fwO8=;
 b=i2WSxqIRdqGvplhwpLJaUV0EdGUhtOYx5M1jbRWaKgzQITPgEok2kL4W25Ez8Gpmsu7lrs
 OdiJ21y/bXiumW6E7ZeGka2vpJswKLVzo7/S7SGqQbFvsCGiFu6gxAFPVU3YRr9aLKpJ2L
 eidedDOFrgQ64d8tNcfN/Lsp3H9ZWID5hWF0DP3qsb02VLTGbyl6DijPps6ieIgtXE7Q99
 tOOkBMnvwcpBQJbZtghMUQVHgOnQr2nIHNf2TqH19mcaHPwg0+sgzAKgbrx9/7ISxJIbjn
 NsrkLfZBPpw4tEOBJWtTJIxZditRigSXJ6uNGNOuyirUPvrHKxDh2BFVAt5wTg==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v9 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
Message-Id: <20260803070929.86075-3-lizhe.67@bytedance.com>
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a703ef9+2a4596+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Date: Mon,  3 Aug 2026 15:09:23 +0800
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F3BAC1C000C
X-Stat-Signature: 65mixo813oi65ksjkaoe8z6bqhj5fomf
X-Rspam-User: 
X-HE-Tag: 1785741059-779380
X-HE-Meta: U2FsdGVkX1+P11XsjD5BMg0iji59S7WqTyd9tSy7U0hhSO4keTvvqiIQnFq0mM0AkSeCChSvKHyYBO8a/p/PMu3ohVbrRNCFbxWOiaD/w4jbQQieY3sQrovwI9n6rsZzLfUR9anPB1azVyX1Z7WZ/A1qDtZCJMUyLOcjWxvb1FfsbBmsXbRl3njVmQx/V4b1ESRwWiqbBdqkQ2ts1TBcPK64bMro/GpEJluCFy3+EgEFAD4HnvCEiw12TEgQEGcb/2RaRhDn8nQFSEZlSWB8dU2cOQ2J2/qO9qzne+fxe8FCMsvopII/xPQPgwfEEubraDaJDHjxzMUOUVXJD0rL3huJ2nwPc4UwGYo/GF0zDsHSDaOKIlGAYmlRXU4rE8qgOi5of9koIh25tvrFdkMErenT3P0EGgMW75/UtzF7gHsKzIaQhlpn2e0rrtcmuVfnzFtI35S6oV8mWc/Jqbo5loDIt54Z3uAf2FJnC8+MSmhfXhyMulF8w4l3lAXP5buAWT0gAaTGxCz+K8ilGxdBAhKsJjJGLtIBJXHg6Xf/0X3wGPTopmKVJzFvSg3MW8YfMAIoZs1nNaO91CxHJJkLI1wKUDzZXACBEg1aD1E3TR/XPX2ZuBX6JHhz5iJiLEaFz0ohuYvGzVptouuj5rnhH93o/TZ7+opdp+Ja1QRV7aAR2mAbre42xZJHkTVYvM53GEE8rpkhH+jmmvxuduZI2jNkCTgpcGLehHPSLdI2dzJ/gRtChgQL5W/3cIknzwpeSvuc9F/bIjoU2Yc1RSxMcaKh3MSvMxLBX5ZTRcZKL6BdfhBHvJHm+ERf2X9p3IslamXEdx9Ndl42/Q2PgyACfor6gSWLrsuHHGwdzqYr5YR5qJaXb8NgYzIUVukAL5CYLqeiUE4Iyv+FFeIVnAKgpaIy81G5V0kSf2zeFr0GCyuMw3SSPGubWS+qKjr/oQoBGPCVpVRjEjzNwTYu8ZZ
 cfBotdY7
 BkRDr/C4mw1e0Yui8fOQAUpOnlKmrqDfPfQ+PaqVAxgfONaRAm25570RxRTLLMuyb5dSJxgiftBRzFdenKrTdm1u0w5XPmP30IQLNn+cIonyU/xicYecAo5bT/z8bJZ4Xx5I85urbjY0yWKuXqMutf8rW8XVzs7buSRu0h0AJ78VsNmXdHZK5bldo6Y46oaIWcxHharOqAhVeSMHToofZUhkU539zk7aIZ4EFISo4JFuqhTfOza0LTfsWhYCOFm15HR7Za+V8V6A2CCvbPub7ZRYns7GTXTz6wry0tLYwxbAPnyhBPvGz/X67s5AcThO/NN2oOf3KHo3iNcku0ITqBFH1cM1f8AePhZafcQqrWZQ1afMsTi7BK2cVz138KrrCL6k7fO2pzXejIqb0Pc+3Bzd+gDsF2G0M/U6QrLv0LmjMkFN1rhVK8+9FDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() currently mixes refcount policy and core
ZONE_DEVICE page setup in a single helper.

Factor the refcount-reset predicate into pagemap_requires_refcount_reset(),
move the common page initialization into __zone_device_page_init(), and
wrap the existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 95808ab5cfdb..a70acb7431a6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+/*
+ * Return true when memmap_init_zone_device() must initialize the page
+ * refcount to 0. MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in
+ * the free path, while the remaining ZONE_DEVICE types start from 0 here
+ * and raise the count again when the allocator or driver hands the page
+ * out.
+ */
+static inline bool pagemap_requires_refcount_reset(const struct dev_pagemap *pgmap)
+{
+	/*
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
+	 */
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_FS_DAX:
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+	case MEMORY_DEVICE_PCI_P2PDMA:
+		return true;
+	case MEMORY_DEVICE_GENERIC:
+		return false;
+	}
+
+	return false;
+}
+
+static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
 					  unsigned long zone_idx, int nid,
 					  struct dev_pagemap *pgmap)
 {
-
 	__init_single_page(page, pfn, zone_idx, nid);
 
 	/*
@@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	 */
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
+}
 
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
-	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
+static void __ref zone_device_page_init_slow(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap)
+{
+	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
+	if (pagemap_requires_refcount_reset(pgmap))
 		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
 }
 
 /*
@@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
@@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

