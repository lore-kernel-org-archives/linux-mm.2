Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F9FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6CD6B009E; Wed,  3 Jun 2026 04:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE546B009F; Wed,  3 Jun 2026 04:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BCC6B00A0; Wed,  3 Jun 2026 04:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 520D16B009E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:05:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 251B91A0225
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:05:39 +0000 (UTC)
X-FDA: 84837867198.28.EC67D05
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6F6DB180002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:05:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZLrF88yr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yy6XV8hK8oauYu/xVX9D1lPDIbV+Br2ZbBHBJaftx+0=;
	b=lQ4k+XV88yUJjjWKay2l7pIX3yvNZC6uPJSx9BadPhZQZLPH9G8UmZLomcUtItRC9qo/dG
	PA4t7vKsHytGD8h0M1EUlLij67B0WlTrS1FyuKzgQAqMFP2CgtLhG5hwesTq+eBF3K3r+A
	JGRg0yFXykjCF9EqtWR5NEFvv6gU8bA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZLrF88yr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473937;
	b=yaoC7LHik5Wn1/gMDjplBXpx7R3Ig7hZNBGu2Jt5cKPkgAI3MWoK1OLP9KHhuawXA3uaGT
	fOod+bzrenDw1b2toHBNtEnzTPPdDJM3sY25MXS/haV7FsWw8PPk93/GwzfX3+VfyT165p
	oV5yxMrPwXiYmjIvjDcHKk5+sB0euS4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780473932; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=yy6XV8hK8oauYu/xVX9D1lPDIbV+Br2ZbBHBJaftx+0=;
 b=ZLrF88yrw0Nzm2arTnuzExC5kIY/vk+nde66tD5n4K7wAdlp8Y4KcqGSZTG+Ron/yDXItV
 GoEPagz8RFHgpXEFcKw8l44nkDsEnRI0f0h3Qy7Ke5b+k+3awfWUhUV7zyvZ2c6fK24d4E
 CznItthwfvCx5Di0TfFWL2mt4vyATW7tjB0kN8DokSactI8q1U7dKDmBMqMgvBrRVdVTpL
 PxIL4JmeIUKa9WLnwZF1gVlV6NvJjWdBHs8jL2oxj+fcwEB1Y5zXI5P0QOgHGpIXgonH71
 OvQWensr1Q/3a0Et0oPJFBj0FjKGp5noK19664J4PsS4BSO49ekAaIDU7LkH/w==
Date: Wed,  3 Jun 2026 16:01:48 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260603080152.64728-5-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v4 4/8] mm: add a template-based fast path for zone-device page init
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a1fe04a+7cf48b+kvack.org+lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f5tdz8grmwj6zo75dsswdjuun66er13o
X-Rspamd-Queue-Id: 6F6DB180002
X-HE-Tag: 1780473937-208156
X-HE-Meta: U2FsdGVkX18Na33GKb53xNUV9ZIqF9SVIEJcwgqWi0Kw6ZLIgSlubao/LEhvnoARK71UQOYiPHH7DWaCQVB0Ktc2/oFE95O2ufg49VKQTyad1g/m41QPrMMtz+HLvHCKZ+ED8ExV3nu4HIUmyxCQCKO8aaFNGyb0zsA58L8xGK5+qkAjvdoIcCYCwBxeNQRy+4Ft4aqMIQ7vmBbYUl8RuDxW7OXOeUe76/8EZpNSolHzmpfAaOmsD8+9pnBmKjYH6seuFHr5wIYZhmjcUiQTK+L4ofOelxw5w5h5/upt2lj8gGaCpaI8xLWKwG3QJ+XfYRK32tDkoAg8b2fd0uuH8bRBZbjR93N+rUwDlHlB6eEiyYIKDRvXhroTlY+GOrOY5H/UPfno0Q6nkX74WFOy+d4loZhJMLlvYYlnJuyMEI8aMCfaRFEo68ueqAmjorEYwEYmFUP1uDuD4X7+ZW+MzG8l9d4tpg6y1SwP7uKS+qR8UY3icsMJifgzyVv4baopQNYRbBdMVdAsnNPl3F+srMutocsaikYzq72dJZHAfO6Y/bUqBF8bGqIMEf7ryMmVQYXRIf+bMy6BOng+xjE6VdalV0RHxlMoG+Vnv4LXOil4+gvlbI7ttvEgNl9GCpe/OlVGu7mJcuaKkQ2WLfFVo6y2TRCvlXrPiiwsgk2gO79KdJFpBQeK8BYMuRPi+HekCTHvOO8NI8+WuDYl8UKkxsd4sFZOFxSQxzY6cQDojnmT5rBqcS4tcbqyp9UQPUoBA2TMemIQhJDX1lv4+203NYV+YVu3pXJ9jwNF4IURvtlCK7j7xlsdSYvImtf9VBLBlJjTD6SgkpJ9+EWomvv/cL5ijX8ANc9VkxuZDjX8ltRSYE6FAOdbLGx1UdYTOB6JLGct7++1B5GRFzsb7tN71INsx1RVIzEIwZa/FbK4M9GKqPwciHuQCPm+wr6nzKu9uzXyObyYnDCgj52L8tC
 lTI2T9Uh
 InGIMev0wGmGNB55UlQL2WpJH1PMWZ4LRy3wMecNyzZQJmUf/KGpJIfDqrkMIfq483kngVyfF9oIe5ImFzCnXoAsuc8gC7rcA8/iMseyxRSgiNkVOp8njdGMa0vLm82JKnpLi5V2dWtH9eG/dvZn3+UOnEsdEybsxlQPTB2PXNAnP+yGgCubZhOsOCBDf3YGQyZKBONAKRuboOzuvi7Q9AHaUTk51az1mhVjg5VRqxegVDijnoWK2HlrDkZ0sTfMAV/Vb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() repeats nearly identical head-page
initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
template through the existing slow path, refresh the PFN-dependent
fields in that template before each copy, and memcpy it into each
destination page.

The optimized path assigns _refcount through the copied template, so
keep it disabled when the page_ref_set tracepoint is enabled.

This patch accelerates head-page initialization. The pfns_per_compound
== 1 case gets the full benefit here, compound tails are handled in the
next patch.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
path (pfns_per_compound == 1).

Test procedure:
Rebind the nd_pmem driver 30 times and collect the memmap initialization
time from the pr_debug() output of memmap_init_zone_device().

Base(v7.1-rc6):
  First binding: 1466 ms
  Average of subsequent rebinds: 262.12 ms

With this patch and its prerequisites applied:
  First binding: 1432 ms
  Average of subsequent rebinds: 246.30 ms

This reduces the average rebind time from 262.12 ms to 246.30 ms, or
about 6%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2e5899c5cf35..56fe71e966ae 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1068,6 +1068,51 @@ static void __ref zone_device_page_init_slow(struct page *page,
 	zone_device_page_init_pageblock(page, pfn);
 }
 
+static inline bool zone_device_page_init_optimization_enabled(void)
+{
+	/*
+	 * The template fast path copies a preinitialized struct page image.
+	 * Skip it when the page_ref_set tracepoint is enabled.
+	 */
+	return !page_ref_tracepoint_active(page_ref_set);
+}
+
+static inline void zone_device_template_page_init(struct page *template,
+						  struct page *src)
+{
+	memcpy(template, src, sizeof(*template));
+}
+
+/*
+ * 'template' is a reusable page prototype rather than a strictly immutable
+ * object. Most ZONE_DEVICE fields stay constant across the pages covered by
+ * the current template, but section bits and page->virtual may still depend
+ * on the PFN. Refresh those PFN-dependent fields in the template before
+ * copying it into @page.
+ */
+static inline void zone_device_page_update_template(struct page *template,
+		unsigned long pfn)
+{
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(ZONE_DEVICE))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+}
+
+static void zone_device_page_init_from_template(struct page *page,
+		unsigned long pfn, struct page *template)
+{
+	/*
+	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
+	 * page. Update the PFN-dependent fields in place before copying it
+	 * to the destination page.
+	 */
+	zone_device_page_update_template(template, pfn);
+	memcpy(page, template, sizeof(*page));
+	zone_device_page_init_pageblock(page, pfn);
+}
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1116,6 +1161,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
+	bool use_template = zone_device_page_init_optimization_enabled();
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
@@ -1123,6 +1169,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1137,10 +1184,35 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		struct page *page = pfn_to_page(pfn);
+	if (!nr_pages)
+		return;
+
+	pfn = start_pfn;
+	/*
+	 * Seed the reusable head-page template from the first real struct
+	 * page, because the existing page-init and pageblock helpers expect
+	 * a real memmap entry rather than a stack object.
+	 */
+	if (use_template) {
+		struct page *page = pfn_to_page(start_pfn);
 
 		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+		zone_device_template_page_init(&template, page);
+		if (pfns_per_compound != 1)
+			memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
+					     compound_nr_pages(altmap, pgmap));
+		pfn += pfns_per_compound;
+	}
+
+	for (; pfn < end_pfn; pfn += pfns_per_compound) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (use_template)
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		else
+			zone_device_page_init_slow(page, pfn, zone_idx,
+						   nid, pgmap);
 
 		if (pfns_per_compound == 1)
 			continue;
-- 
2.20.1

