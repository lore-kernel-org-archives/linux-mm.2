Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EDFCCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761D06B00B0; Thu, 21 May 2026 00:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7126F6B00B2; Thu, 21 May 2026 00:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6022D6B00B3; Thu, 21 May 2026 00:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC996B00B0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:03:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EACF81A04CA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:03:49 +0000 (UTC)
X-FDA: 84790083378.30.B42FDA5
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id 106C84000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:03:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oP+cCJ8d;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzT6rgRltF1pu1V66u6WO6GZ1NJSxQBmJVnmonaqWWc=;
	b=kQsoDyd8YbEU/9M9w/3wqsipjt9hpM3VBcbnGJcB8rt9cqDBIvlExBzttpvgQl8D3nn37o
	Leq01s3+pDo0S/6EDDKP8t7LN0YvL2Y7zWWx0DEalDm2tn8g2696ywZvpeDRUlIaAJwEgu
	J9o7l58Ziy8iVgohhH68bEKKOiHhgzA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336228; a=rsa-sha256;
	cv=none;
	b=ugd7n/1KKm7qxqipJ2BLBpQpKH1l6xn2JSMOsoHXdV2LFnQwms44vyCEDv/idWGo9AH8+n
	NYOsdsTgvW+kJNxU60NOX5/Y986Jv2lWSKnMkLfvSKHT88zFYER89rQIBYcz9ca1JR+vB2
	97CLFfk+A2MycMXT42Fx4VMPOg5eKvU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oP+cCJ8d;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779336223; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=WzT6rgRltF1pu1V66u6WO6GZ1NJSxQBmJVnmonaqWWc=;
 b=oP+cCJ8dMsyfbEgYOTRLckiA3oy8+w1BUJHSGMskJ/XDSL48xyyYEZEQf3M4HukHjSZ+T1
 H+2kwrHIeYpb/2RiUdGW5vsf7cuVF+/V+XjuG+OH3ZkqLtaNIiq3E6DpJn9/wPRpD9yvF4
 sfhF6TBnKmHHyF1HT9naohF3VUdnBKc40YL5E/WV2919o7CYM7HD0Jrdg7U9BW0LqQAUZj
 05oCLQ5Tp93LQoBDHFzOCCZP1vzTooGGnBsmbMqWwXK6H6/+5IB438uJDgjtdzKw6jOAtz
 JHtORZM6hhFoYnVTnUj8rS413VzCoO/a2ryL7LVaCoObJyFiVvxghZKHEmMZnA==
Mime-Version: 1.0
In-Reply-To: <20260521040124.10608-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Thu, 21 May 2026 12:01:20 +0800
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <x86@kernel.org>, 
	<linux-hardening@vger.kernel.org>
X-Lms-Return-Path: <lba+26a0e841d+01500c+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
To: <apopple@nvidia.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<kees@kernel.org>
Message-Id: <20260521040124.10608-4-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v2 3/7] mm: add a template-based fast path for zone-device page init
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 106C84000D
X-Rspam-User: 
X-Stat-Signature: f5cqy7snwsekob9rautxtppbkj8sy4e5
X-HE-Tag: 1779336227-647571
X-HE-Meta: U2FsdGVkX18wsKxBR/Z/9jwrdP70uLswbJ1D29LdAhAeK0ztq9myRZO3gkhlC6ZD6r+QqrRCqMO9wVgjcr3y/UOo3SiGgWMxBfuumI/+cirSUfxGnStPRZuiUKgoCTzVy/XKdVVfvH2HUM3NMNZ2MoFQ116S+/Sd7D82+PY6SyeohuYpxrmAaoG++ihIssEGeEy0M2yHkixsNpn6VE/IVMGOT6DJxKpz0MK5Y+cFX3h3VRmGR88+fFg5jLFu8CRrlYQ4qqxi5tNnQ2P4tEMs0s1anX5w7/wrpmoQY4NTALqIeBQCoLVB0PhmNdWvW8YnG4+zjepKJl0t4+mC3jnGDEYRAF6FPi4EEelKl5XCLke12Zen+cdWxO+H16Vew2EodRh+foE6GU7Gp6w1XvSx5cw4H80RUO8uqDKKJfo9UBtZ0FTKRygrpi6o+AZSCtqpm4T+MVBd8TAcsjcP03bY6ukH2VdYYM9Vd8PbTxR2+VxWJirhtDqFsTZhcEWq/J/atUT3LDsv7MK/xGKENqWYdM+iWh7ZdalhOhnRob5Jbb8CwsRsJiHQX/cH5oHnCiuNlsvNM99S1GqKm4eOZcL7bHOQJdBgt+kqzoKdIa/+/BxLXXgjMn3o93sR3kHSEwMPaVZpxCpzVF8lefmWj57OnZhH8AAhWaVdzl5mwsKjt/Pv9Y/PXV0bSVEj1GFw50+QVVo69oLzVBfxrVfz3ymokt++08EE23zF9Z0LUfPYqo0jRAzzKSitV4p0kEbH2NjwygUKKY3E2rY/7wYXdnkp57N2OKNszd/1l6lIl9fDcfYnAWmAPXiI5i6OjopOlK/4jLbCRsCkCLLEsPwhJuA+2hVl/JYeUAmAVgKB28T5PoskyodwXupUeZjuWJNy2CORgRPoqFT/cATFn1o/n0TPvTy7qvZL/Bj+Vwr4c0+vkRYIY7iwnTMC7/3UiFaFeZxrfOVyqzrGb2N7YaImHxC
 //nm47SV
 cL6XqHVkqj7sT9jNxUD3xSKYcOJmVzg9HR2YevjgMuBKQ4JbRCV0SdGARlDNQU5in5EZR/+LqR403piK6C5v1Vl9m/7e7BVU+8yXPAxuq8vmlzFRwU10NatXy+0hzVlUX47aJ/45ptzWp3bAaEZiKEX13EvYbEHmH0DCK12tWH8hZP30llu+CyakS0DeqlkiDsd4dnLvHW7bwcnJUbB0onOQSQFfxEaDCLDIToVfbR7kIclAqlBFKW9+H94KVpyUEwU6v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() repeats nearly identical head-page
initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
template through the existing slow path, copy it into each destination
page, and then fix up the PFN-dependent fields after the copy.

The optimized path assigns _refcount through the copied template, so
keep it disabled when the page_ref_set tracepoint is enabled. Also fall
back to the slow path if struct page is not an integral number of u64
words.

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

With patches 1-3 applied:
  First binding: 1422 ms
  Average of subsequent rebinds: 245.73 ms

This reduces the average rebind time from 273.52 ms to 245.73 ms, or
about 10%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4ba506df93bc..2992711351a0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1066,6 +1066,63 @@ static void __ref zone_device_page_init_slow(struct page *page,
 	zone_device_page_init_pageblock(page, pfn);
 }
 
+/*
+ * ZONE_DEVICE depends on MEMORY_HOTPLUG, and MEMORY_HOTPLUG is 64-bit
+ * only. That means CONFIG_ZONE_DEVICE cannot be enabled on 32-bit
+ * builds, so this fast-path code does not need a separate 32-bit
+ * fallback implementation.
+ */
+static inline bool zone_device_page_init_optimization_enabled(void)
+{
+	/*
+	 * The template fast path copies a preinitialized struct page as an
+	 * array of u64 words. Skip it when the page_ref_set tracepoint is
+	 * enabled, and fall back to the slow path if struct page is not an
+	 * integral number of u64 words.
+	 */
+	return !page_ref_tracepoint_active(page_ref_set) &&
+		IS_ALIGNED(sizeof(struct page), sizeof(u64));
+}
+
+static inline void zone_device_template_page_init(struct page *template,
+						  unsigned long pfn,
+						  unsigned long zone_idx,
+						  int nid,
+						  struct dev_pagemap *pgmap)
+{
+	__zone_device_page_init(template, pfn, zone_idx, nid, pgmap);
+	if (!zone_device_page_init_refcount(pgmap))
+		set_page_count(template, 0);
+}
+
+/*
+ * The copied template already provides the PFN-invariant portion of a
+ * ZONE_DEVICE struct page. Fix up the fields that still depend on @pfn
+ * after the copy, namely the section bits and page->virtual when present.
+ */
+static inline void zone_device_page_init_finish(struct page *page,
+							unsigned long pfn)
+{
+	set_page_section_from_pfn(page, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(ZONE_DEVICE))
+		set_page_address(page, __va(pfn << PAGE_SHIFT));
+#endif
+}
+
+static void zone_device_page_init_from_template(struct page *page,
+		unsigned long pfn, const struct page *template)
+{
+	const u64 *src = (const u64 *)template;
+	u64 *dst = (u64 *)page;
+	unsigned int i;
+
+	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
+		dst[i] = src[i];
+	zone_device_page_init_finish(page, pfn);
+	zone_device_page_init_pageblock(page, pfn);
+}
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1114,6 +1171,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
+	bool use_template = zone_device_page_init_optimization_enabled();
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
@@ -1121,6 +1179,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1135,10 +1194,19 @@ void __ref memmap_init_zone_device(struct zone *zone,
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

