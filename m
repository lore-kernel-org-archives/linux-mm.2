Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6FFC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7652E6B008C; Thu,  9 Jul 2026 07:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D1B6B0092; Thu,  9 Jul 2026 07:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679586B0093; Thu,  9 Jul 2026 07:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44CB26B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:26:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D355FC01D4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:26:39 +0000 (UTC)
X-FDA: 84969010518.17.EE1C6AC
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8CFDAC0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:26:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fa8+fkBt;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNOp3A+Cf74MvgdRY1y3rnv0S7rzKFSj9rQ2hHQ4JAk=;
	b=T03EowGOeeAf0HsgiN4W3MTvDqKky3E9NxcCn0FBMGZuU5czkeEnuE5Hb2xz5FRJhmDBZx
	5M3+ANLqXO/mhuHaSsHGSLZgNKPADCgE/crTX8pZvBp7O5vGlCFftYt+Qeu/ot4UeEsVbX
	sASgl0BnldAC2442hZw/G8mf9vOTpg4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fa8+fkBt;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596398;
	b=sEXepCJGWe3tkbRLQ2tbED/xMG3CIkN1CQuorGkfR7eoHbgkF0yV74UtKyBT1vAOTZJ4Me
	rJEsNx+P7LEx8MdEyjxOCJSKprSCZ+L/9vZYjHUEMdPEHfw01SzDuQ8UR4fMcJ5VOTNzhA
	X9Qi0g3Xbpfj/7dG+RmeqspmKoHbZxY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596392; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=SNOp3A+Cf74MvgdRY1y3rnv0S7rzKFSj9rQ2hHQ4JAk=;
 b=fa8+fkBtNF/5N6G1S9f4NYUJtXbvZEOe8QsX7g7dcMYYai206gryNTRTStY8jEyCXeejoU
 irCrffoFU5vUATBzq4yedLP2dqnJnPf5Cwh/SM8iJIM81iKxyKaYBGuz5h65BoWNY3CfJA
 W0rIIkd9HlCLg5TIJjAiZqghJ96a0wZI1Qmar1JgpN6YX60QlDVNDblFSjPrbrsGaifDzV
 kLi3IAB+ESHlRHXjkhID1gIX0VgRAYDLxPoFscSQ7myyRHnUwihJ6J43+ccn32jGYNX2Nu
 +BpnA61jfdVuZPd0uDHYq3+Kwf6JshuF+jCaccmOCpKQlCDmxNN63QoJCOSwZw==
X-Lms-Return-Path: <lba+26a4f8566+477f1a+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20260709112520.24857-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260709112520.24857-3-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Mime-Version: 1.0
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
Subject: [PATCH v6 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
Date: Thu,  9 Jul 2026 19:25:14 +0800
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8CFDAC0006
X-Stat-Signature: ony9zbt94e68bboum9sfobyku7kfnhsg
X-HE-Tag: 1783596397-647985
X-HE-Meta: U2FsdGVkX1/yTouNACnSOJW1XNyySse0SSqDXIFgTJTwuMfcrMju9xMMpsAULp+KI4nDpRCLtKhFClhCibkNPRkCXAi+cgGAKKknkAZr2kn/XnCPjAOoRH4iDOhlXLEmfODdpS53W8j2wMoqEHM4GtG+PfxQP+KM2GiBoa6VtDvdj3rZhYwQAnHo8YRlDtdrQJwtfGkkTWKy8EF2aZNdqt1khS8cPmItojkx2qlxdi50wMEhpG7kTxNWpbhjkoN1kxHy7TOaSEhpIyqjv+ENwa7iU0huuI7ovp+DBqAsEGAhsLCWWb4eDkzqU4sEAZkUGqr0ZlzcY9vwb5X4gdJOrPl2OJ2mxPN1cnUgSpldXuHSFXInxc0FqT/LV2ErwkYVIf82mkA/oiAOw+H4kMMeHn16h1lw0po/4oDeNlmzHU3BaPE/k0oT1vVv8kdbvWSmSUn6SSpSA0l8rkPd3xn0i98n8ah+76ezAOx2uJELELUSZa2XjZYeuwQpqIoR5wMp9ll5ChsnXOzaqb97nEjQeYdoP7MEtxLco+oNrvh9XbL2FTaJ8wYDrLYfqaxtcSD0bdRIFxjR+9tC0AVUxaZoMQiWtrPqxIzitx2BaEWialTFbwWhFXHfhionCN/zg0B6ikdkteU+gNYJxBc9+w2OpLG1Imq3/qtkqVYG1YHky3wL5zqJtLU9bwOuKHMUyAl+oIDT2IfahfNxmhvWQB1yu2JY1pULpiDfMt0LJEZGuO+rvy48cPyGQ5Sp8CSOvvYKddqWjzaarqZzOxP1FoK5R/kh25MP6CheDxrmdEiKw6Z5Prq9dwafnWQ7359FmB2u/rgk+kYrOzTlv0IvcLHyhf6anOfV+xkv6/f8fjCXKoDv0tfWFYJqeRHbQXvHsVq3XjVGN69sxFykv3gZMJpoGg+On6WBr/3BZz84+lYaQjO83IFYjOUiBuOvubM/E0Bdxf7nwvuqQ39IC+Bgix/
 na/3+BDr
 A7+r/JAD7bZ5VDJ0ou0/fNbg7hNUcxY91LMOLwFWU4p/jt/LWD4fOff5B5T2XH8uAGjuN1bSxDCF39BrZu1pyywxi1uU/RYWD0ZVfZz7+F5ZypHef/mRqPkOMNC60cAUwBHI+ayxc1ME0ak0vFMzwDS5zqRCwUgJnksCgu3rzUBj+Ile6SmlrblTKvYs+aS7LgOfwIdle1sI3+ZsvWF84aDuJ6gbiqAIIeH+zNMtDXsqoExJQMd8U4GOlvfjXluPzq2+Dm09GkIcUVJzHPJbwGKTnDYqWRyICNJM5YqCmB/+Y2gY9+Ce9XeZTpiBax6pMIfCp6wiLa/7opkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() currently mixes refcount policy and core
ZONE_DEVICE page setup in a single helper.

Factor the refcount-reset predicate into pagemap_resets_refcount(), move
the common page initialization into __zone_device_page_init(), and wrap
the existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 95808ab5cfdb..5fccfbacf855 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+/*
+ * Return true when the free path for this pagemap type restores the page
+ * refcount to 1, so memmap_init_zone_device() can keep the count set by
+ * __init_single_page(). Otherwise initialize the refcount to 0 and leave
+ * it to the allocator or pgmap callbacks to raise it when the page is
+ * handed out again.
+ */
+static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
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
+		return false;
+	case MEMORY_DEVICE_GENERIC:
+		return true;
+	}
+
+	return true;
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
+	if (!pagemap_resets_refcount(pgmap))
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

