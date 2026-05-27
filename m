Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0EE5CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9DF6B008A; Tue, 26 May 2026 23:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1136B0093; Tue, 26 May 2026 23:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDE56B0095; Tue, 26 May 2026 23:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD03E6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:39:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76A6712048C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:39:39 +0000 (UTC)
X-FDA: 84811795278.08.1E3C938
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf07.hostedemail.com (Postfix) with ESMTP id 83A134000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:39:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=YwdUF4vx;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzkylVMxN4y+4R6jlaSHNSlINGBpPYCeLuqqe59IvVQ=;
	b=4ssjzW5zjNbR8JAT4iWvJx4Pc4QPsjPSciIc07vlN4Syphk5H2rVv/Z4mtG6tKdhxf75MT
	G+7SA2qefe5pOr6L0BZChYno9hrmaKTD1dOwbaaaykdfWFPNnfjmbq4BsIG5WoaGOQ/4d0
	svBxeOrI2eI1DZX+jnw5nDhnyZpRw6g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=YwdUF4vx;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853177; a=rsa-sha256;
	cv=none;
	b=giSlGXQSf/LPXJsqRCwJ/Y2GGT72kk5TD+1Y9OwYxwNE1xpLPZ4w0coMKVOWrSf7omP3B0
	MU3iOOpQ5E83cSRdhawvTFgKWLzpoewTNGyqjX8eVlsI9V+3ZuE6jD/udT8XljFJXIuvZt
	OtZfw0PqX5UOe83Yk9fxx2HHLa3NxDY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853170; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=KzkylVMxN4y+4R6jlaSHNSlINGBpPYCeLuqqe59IvVQ=;
 b=YwdUF4vxjEVMX3DVK9cFUXxI5I2jq/+n6ZCTldDEVU1vZQ7APxXxPD58Ss4VT1IMID7njM
 aQ3RpUkw1wXtTU7oAzFze26P6dCHoIBQ44klBbBvv6iL1JDKe3R8J7Y13uTbBE7tE7ZYs2
 DhUPY09hXKDM5UB8B1GXm15mUZ0iixXuGY8tHCTiFAWUsYHUE9PeIZLo9C6oO5uBdlzTiz
 /7VqGcXOcDB66qNIfziSjqd52VFFLBF5317VSA+apSLkq+ZjPE83od1W1uoyqeBfsoiO5Q
 Y6BMWpzo6hVjMWrodwegLamrX0Jddpm9EAqxaW0JIteZ7YYmcQAAl7AZ3zSqag==
Subject: [PATCH v3 4/8] mm: add a template-based fast path for zone-device page init
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 27 May 2026 11:36:32 +0800
Message-Id: <20260527033636.28231-5-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a166770+660a23+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: jh7f6r698fm7x4fdw7bjtubkp3jcnhh6
X-Rspam-User: 
X-Rspamd-Queue-Id: 83A134000C
X-HE-Tag: 1779853177-788436
X-HE-Meta: U2FsdGVkX1968H87SFIvDaPjegbGxRDSGzxQBTRTOgriwna9c+jWqnT4DXFhUF88bzP6p3hOhJR0fBxOM1vjnqhdCR2qTS4W4E/OtsswMboFXvC6ZkxNRiGqshUOhGq1KOCznBMeiPMjPNG/Yc7u+TCU6jxPIOXCw1Z/Lf5az3RSn/brXNK6v1jvgdl3pozpNA2srfRMeSvsLVDmidoZ+ZuJ5Ml+/bcdyOnD6LZsZ01gJ6QI7kpT74e60eHuXn4yaL5nn4aX183UEKwsGShkJM7mOaQfmv9w7tDZgOck5EMXKKXhL9NcqHeSstRE+3EOyFwFEsVvmTgjqz9K827+0Y+xaPS82J3jXVzSexlh9mu+Mr7VAtQTtIYBiBm4McNBaZ7m3cLtiO4qyVc/oc0HJm/UY8QCeUCyScfNtauWiOZtzH0wBRvR4V4AGQNOYJiMHUKUGTx+I9nQh92jABEC2s1Nz2hG/fYkJW76KC+MdMHlknzEtip/I6pRZLzzPSTTbYJfUgxvFO/AgX5opK1xuOjqjWA8M3a1yr7L0FaaqQWU2jWyIJnv8NOUCZBk3TiJB8tVJETnzFlNAM5tDlQkMMaLiBnHAYbUpomBoETwSDufzwHYJn+siVmTP2mOuuYqmdJYWWHGNJo0OYgnCLRZh1XoYem0p7B6rrvQR0PP9qdmqqIhU4ybGVWE+q4/+AhRuGwxWU1PTNNPY1ChkUhcfpZ7MULNZ1KHMV/a2BoQRmJZDtKJmH+0vrQb+sG1++PgVFlxRzADv08DhWbDKCXBByeD03SBLByy8lHDueNTBNN9nUpI3LRfxYu6cDffnJPqCbU+dlFz36nbAjniJ76vUUH3qY6f8csTeGk8QS+/BsMOzO/P8n/HWrc+NhWqhHDFL3o82BGlPK30OZLG2rtjDEeLT383tFFsYG4zLWrVe6LHr8xAsoNn1dSwNXH8zH8OUBH6O6+g/HN1cAXEApW
 tRhBRrW4
 MWoDT+gWqpasFXcokDHI+A0H2iwklugx5KjCP8rcwjU53o+6GAzlNaoN2YZtadVaXufHgKTLrm1Y1HICvBuTIAFYZQceL6IVf7tMffPgxtkf4j5y13sxYLgzIF1tOSGLF/nOkRt41ZVZb1gLaF+3X/RHNSxvxSeZAcAazn5cYZ4j/sQOsuyppvvNejG+MikXPy/vrweJk9caQ89WOzmdxH5O/ElTNciQpipka8LamXxwWW7yUyVKSxxXed1FlYnlvcAKpPfNV2TzSRMFhy2EEgKrPFr75BaSwA3Xzk3vOJwdekHA=
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

This patch accelerates the pfns_per_compound == 1 case. Compound tails
are handled in the next patch.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
path (pfns_per_compound == 1).

Test procedure:
Rebind the nd_pmem driver 30 times and collect the memmap initialization
time from the pr_debug() output of memmap_init_zone_device().

Base(v7.1-rc3):
  First binding: 1486 ms
  Average of subsequent rebinds: 273.52 ms

With this patch and its prerequisites applied:
  First binding: 1422 ms
  Average of subsequent rebinds: 246.65 ms

This reduces the average rebind time from 273.52 ms to 246.65 ms, or
about 10%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2e5899c5cf35..53c0241c66b7 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1068,6 +1068,56 @@ static void __ref zone_device_page_init_slow(struct page *page,
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
+						  unsigned long pfn,
+						  unsigned long zone_idx,
+						  int nid,
+						  struct dev_pagemap *pgmap)
+{
+	__zone_device_page_init(template, pfn, zone_idx, nid, pgmap);
+	if (!pagemap_resets_refcount(pgmap))
+		set_page_count(template, 0);
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
@@ -1116,6 +1166,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
+	bool use_template = zone_device_page_init_optimization_enabled();
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
@@ -1123,6 +1174,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1137,10 +1189,19 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
+	if (use_template)
+		zone_device_template_page_init(&template, start_pfn, zone_idx,
+					       nid, pgmap);
+
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
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

