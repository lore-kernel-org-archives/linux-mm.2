Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693AACD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA8C6B00C6; Fri, 15 May 2026 04:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC13C6B00C8; Fri, 15 May 2026 04:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD75A6B00C9; Fri, 15 May 2026 04:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB42B6B00C6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:21:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 477FC160F3C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:21:42 +0000 (UTC)
X-FDA: 84768960444.07.0CB4839
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id A66ED4000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:21:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ikEngAOe;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778833300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYb1xv6fWKLs8dME6r+hxjVFSc26mPwlUU+4YrBCihU=;
	b=6XLwKeJj5tDjNo+tZrA9DltWL72RavlNmJZcdycKaX1djtes9DFGsMJO7v47XIT1kb/4EG
	jAQiUAUmWeXj0gbr3vFemArM4IBfAWYlY8yWL4TZQzrbihhWaQAesYsTH1Wt6ESKo/9zdF
	fXiWiIb0hhD+nSa7lHgaXzc5a31u1yU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ikEngAOe;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778833300; a=rsa-sha256;
	cv=none;
	b=SK8wkFXhmyPyAbTaIcoTERZQ+WJtlJsujAQHEt59pL8AY4pqOVbKL1B/i27cf4RxT/YrPn
	lg41H1dB6mHOJIJl+E2EHlhabg/uHhTe6MU4jSpc8iL/E45hCqDjp6aXeM1qQsLRnb11/x
	6xiu2Yg+OEH0zhOTcxoWC7KjF7uLreQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778833296; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=KYb1xv6fWKLs8dME6r+hxjVFSc26mPwlUU+4YrBCihU=;
 b=ikEngAOel18imdYLdMQmxTJ4kLHkc6P/0fmNIJB/ybRYYrnA6WDfFwMInw/H4JeSoPA1Jg
 h72QGwtYr5a7SQ6LHiPs+te8719/kHvTYdHJoRgtRUjfU2mt7bNVik49NYuRnI0+ccyP+F
 gll7JjgEC05N/nE3pBFnccLfoac+42eAzJwygxsiyba//hTywmbDNoVcBX3UVbK2ofRgYU
 QuOqyhVXd5EaBbb8zfBvr/1rH83MUJeoJ9qbnCj4WnEUcYMrbiLDX3nH4yOU1qu6AGCioC
 uBw+Gxj6ZZooBlrhvGwEB/34tJt7to3DiupxpnFwINTyRRhYblT2GJIzQg4B2A==
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <arnd@arndb.de>, <rppt@kernel.org>, 
	<akpm@linux-foundation.org>, <david@kernel.org>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260515082045.63029-3-lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 2/4] mm: add a template-based fast path for zone-device page init
Date: Fri, 15 May 2026 16:20:43 +0800
In-Reply-To: <20260515082045.63029-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a06d78e+db504d+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A66ED4000A
X-Rspam-User: 
X-Stat-Signature: bfjrbxt1ozmp9ot45shczrnmogbcywbd
X-HE-Tag: 1778833300-737628
X-HE-Meta: U2FsdGVkX18ilJpGlGQfq7KniATG1Gv9xpBqtjwHw2MQD3PgxsDrVwCa6m00A4QMQtQaE/w4UlN0qkny+VkxVvkLyJOP5+Ix8QcTac1f0d+QnwVgQT0AHWQbGFFRROvnnYhV40QKlbiW26pBFgff5lixljqIB30ZziO1l/jGLB1mx9sWuGx6UT7mYQkURdCiC16w+qY/r2MYMG+abK7n2jKbwKuvXK/KUJSaaGOZeTQ+wEHMC6KTZaPiRyvg3MFE/TdpSMw35Gxc5YLZM3JChPLe0DT15Vy1AncKYCgopTDvan1lY6sgkzdlgIkICoTejLxGO2NGmYMcJiu2hGwedcXla63NT0VFkq2nW+STd4zqM5qggmxc7l+Mo+NmgfcVBDVSV/BZKiNxm5WQzp16WWm6TZVOVtu+U8ilq/+iEBW03AXAny0gTK0Vd1Ya1weuuxMyDrMOIFMZ+wULG8g8h8pned/KP61JNqTFvhOUMi2pe4kcrXH7Y1RwzDtnNnLcEwPkfiGxE3kkhYRMgWyuQMNnvHKB3znpDN4a1W0MDpnvqwX+9Gb4BsOKlMG+ye4HQk62m7mljlTy1a5YTSV8OgPnmLSCIx8YlYJLf2c591wtmeH1zsDSx5jrwwNCQd+L9A0GMifZeiBW/X1ScVfAkMSHHMeRFHSFR0C3S3GPM9O9ZFhYxJrqMCXddEs89Pe51XKF6irEqIQrvCiMu+ueAQUuYVmwbJCpGurJjSp4PQTZoTFyQNEo9MDLZsdEts5Tsq2UBKXa9B5MEgmuA9Nx6GGEeMSlhvhqa9wh3NHiH1haypdVSfpc2hOyYtLGROLRf5VHDXHarrqBXr8ay3X3wanN+adTh6OLCqSYbedqT+MEtj1U02ZKhP94Wo+6jmnvaAtDkIXwOrZ+r1I8+ZA4Yt2fNfVBb1Y+54yjVQciyFixV82CGgAHBrcP2aIZs4avTugd5KtoZpfCmrklkud
 hjU1p+JF
 /2MkIzFMxv3JSJ07K0IVtSrTfdFV6hf4QCn7M1cXUxxpnFayy+PnzWNyQkL7hcfLEtMrdZZ/3p0YDCfQtub9nuZzU8hcJitL1shj9Uw7mm9IRTz6JJ9R2OYG5OxhC6V0xRAO8A0UMZxqSuNlL8B0vjBa+ldvy61EQ81TOweALJTM+1PMeRkpdpH5qRjhrynB253dhH2MhzTtwkRSxhfvQ0pY5XP8IcVijf1fXuxl9LXgp8RHElYkI1iIftacHdavmBmnX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 64-bit builds, memmap_init_zone_device() spends most of its time
repeating the same struct page initialization for every PFN. Prepare a
template page through the existing slow path once, then copy that
template into each destination page and fix up the PFN-dependent state
afterwards.

Keep the optimized path disabled when the page_ref_set tracepoint is
active, because the template-copy path bypasses set_page_count() and
would otherwise hide the corresponding trace event.

Non-64-bit builds continue to use the existing slow path.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
path (pfns_per_compound == 1).

Test procedure:
Rebind the nd_pmem driver 30 times and collect the memmap initialization
time from the pr_debug() output of memmap_init_zone_device().

Base(v7.1-rc3):
  First binding: 1486 ms
  Average of subsequent rebinds: 273.52 ms

With this patch:
  First binding: 1421 ms
  Average of subsequent rebinds: 246.14 ms

This reduces the average rebind time from 273.52 ms to 246.14 ms, or
about 10%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 96 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5244acb96dbb..4c475c71a9d6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1013,7 +1013,7 @@ static inline int zone_device_page_init_refcount(
 	}
 }
 
-static void __ref generic_init_zone_device_page(struct page *page,
+static void __ref generic_init_zone_device_page_slow(struct page *page,
 		unsigned long pfn, unsigned long zone_idx, int nid,
 		struct dev_pagemap *pgmap)
 {
@@ -1040,12 +1040,9 @@ static void __ref generic_init_zone_device_page(struct page *page,
 		set_page_count(page, 0);
 }
 
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
-					  unsigned long zone_idx, int nid,
-					  struct dev_pagemap *pgmap)
+static void __ref zone_device_page_init_pageblock(struct page *page,
+						  unsigned long pfn)
 {
-	generic_init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-
 	/*
 	 * Mark the block movable so that blocks are reserved for
 	 * movable at startup. This will force kernel allocations
@@ -1062,6 +1059,88 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+static inline void __init_zone_device_page(struct page *page, unsigned long pfn,
+					   unsigned long zone_idx, int nid,
+					   struct dev_pagemap *pgmap)
+{
+	generic_init_zone_device_page_slow(page, pfn, zone_idx, nid, pgmap);
+	zone_device_page_init_pageblock(page, pfn);
+}
+
+#if BITS_PER_LONG == 64
+static inline bool zone_device_page_init_optimization_enabled(void)
+{
+	/*
+	 * We use template pages and assign page->_refcount via memory copy.
+	 * This means the optimized path bypasses set_page_count(), so the
+	 * page_ref_set tracepoint cannot observe this initialization.
+	 * Skip the optimized path when the tracepoint is enabled.
+	 */
+	return !page_ref_tracepoint_active(page_ref_set);
+}
+
+static inline void struct_page_layout_check(void)
+{
+	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));
+}
+
+static inline void init_template_page(struct page *template,
+				      unsigned long pfn,
+				      unsigned long zone_idx,
+				      int nid,
+				      struct dev_pagemap *pgmap)
+{
+	generic_init_zone_device_page_slow(template, pfn, zone_idx, nid, pgmap);
+}
+
+/*
+ * Initialize parts that differ from the template
+ */
+static inline void generic_init_zone_device_page_finish(struct page *page,
+							unsigned long pfn)
+{
+#ifdef SECTION_IN_PAGE_FLAGS
+	set_page_section(page, pfn_to_section_nr(pfn));
+#endif
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(ZONE_DEVICE))
+		set_page_address(page, __va(pfn << PAGE_SHIFT));
+#endif
+}
+
+static void init_zone_device_page_from_template(struct page *page,
+		unsigned long pfn, const struct page *template)
+{
+	const u64 *src = (const u64 *)template;
+	u64 *dst = (u64 *)page;
+	unsigned int i;
+
+	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
+		dst[i] = src[i];
+	generic_init_zone_device_page_finish(page, pfn);
+	zone_device_page_init_pageblock(page, pfn);
+}
+#else
+static inline bool zone_device_page_init_optimization_enabled(void)
+{
+	return false;
+}
+static inline void init_template_page(struct page *template,
+				      unsigned long pfn,
+				      unsigned long zone_idx,
+				      int nid,
+				      struct dev_pagemap *pgmap)
+{
+}
+static inline void struct_page_layout_check(void)
+{
+}
+static void init_zone_device_page_from_template(struct page *page,
+		unsigned long pfn, const struct page *template)
+{
+}
+#endif
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1110,6 +1189,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
+	bool use_template = zone_device_page_init_optimization_enabled();
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
@@ -1117,6 +1197,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1131,10 +1212,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
+	if (use_template) {
+		struct_page_layout_check();
+		init_template_page(&template, start_pfn, zone_idx, nid, pgmap);
+	}
+
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		if (use_template)
+			init_zone_device_page_from_template(page, pfn, &template);
+		else
+			__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
 		if (pfns_per_compound == 1)
 			continue;
-- 
2.20.1

