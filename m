Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A548EC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6DF6B00AE; Mon, 20 Jul 2026 08:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A881A6B00AF; Mon, 20 Jul 2026 08:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DE36B00B0; Mon, 20 Jul 2026 08:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EDFF6B00AE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:06:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D90DA40156
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:06:16 +0000 (UTC)
X-FDA: 85009027152.21.83AA1EC
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf27.hostedemail.com (Postfix) with ESMTP id A752140011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:06:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=g3AQwYTz;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OXSJ03+XyIqi02GqEj3ajlM+g5iP3d6qhTy7H8GWxg=;
	b=T4OnYstDqFF2LT3vfrYy7bS1tegX18S96ikLOJlqtCXYa/U+KU5jaMftabvTqEL1K87h/O
	0t55lZSGbURw+3TzuqaFGnC0/oHSfSawl7LzAwYJ482z/jVpKEJd+etznBuaQ7Ny/b1CME
	iFo1sFO/K5ssK5gHoE2p1E453ctK8Es=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549175;
	b=QH9Fn0S8YC6f0tXgBD8u9PnEpcWr3VsVouOBaCu5QvFS6KIT7SXghdvkkXhwicvaeJZNCg
	e8E22yM318lFBpAivFZPY/UFBj1kwYAidCzsTtTMcsNMOMP9KsXuDrlbL6ksjZ0XFUEhpq
	ab0sia/FS0djz9acp1ILpIjh8/hvN1A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=g3AQwYTz;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549170; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1OXSJ03+XyIqi02GqEj3ajlM+g5iP3d6qhTy7H8GWxg=;
 b=g3AQwYTzMCsotReS2bPVjKGI9UDq/bp5hW2wjSfUJ7bdtGu4/08SsgOOVL1Mp6Pdj6vbqr
 6xQzE3M84/J5OwlFCQWy2XWio88dc2cotCm727QtOysazZnH/MI3oplNrzApAWLGZ8NnUQ
 R/pq4jeyARcLNOrEX1SQ1zzDV0SGxUyAtAYhNVXFq1uQ1fSGn4ZDK4pppw5TI8xrtWruIj
 xoVXr2xPLKjP0alNZ4U6Ak+/VR+8vBmbZILX8YKnqoXOAuYZ8MwgBnDXG2OgnXD0GBdW1N
 GXUqRCiOLeKiuRHAQz5pa/ywmHbVNk/NbJs1qGogTaOsCafuXeITa8/Z2rA8iw==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
X-Lms-Return-Path: <lba+26a5e0f30+0dbd8b+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH v7 4/9] mm: add a template-based fast path for zone-device page init
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260720120259.1545-6-lizhe.67@bytedance.com>
Mime-Version: 1.0
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 20 Jul 2026 20:02:54 +0800
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A752140011
X-Stat-Signature: w5dqxfhhqs61kqbkrjf9fogrm8t96z5d
X-Rspam-User: 
X-HE-Tag: 1784549174-977121
X-HE-Meta: U2FsdGVkX1+PtoAP3CXwEw2R8J9J5YuEwRJQUaFe9kNZ3mMZMTIpfrbwvM95rqsiu5EXsG+Fu2b/FE0+4rdpipatBbHOrs9THU0mq0GJ4y1bcU5XRy5WqsaNf8gdyud71sxcJvEmCyrFrzlEMpAXzzytgjrpY5VVwVqM5mYVbMR/2L5Xg15lmowHez/9iLEJwMMNlW774hvgrkuue4MsDT//EHTZZ19mpQTXisY9eptdDrc48XFOtyMzSzmiJBFx3PJ1ZB5TBtyPxZZjAl5wDluxYCWFeC//2L0ib7J5Io1KgCG55Er0MTXAg+29oTZsCzX1bxu2temogLoCIavdI/4bWhF6lomBJLvuW5G47MxVvcVsPC6P4dVWd29F9Yg+BipewcS9Jzz1D/wIpnoigmZBsU+dY61z4ORIZt6QJJVAiddKRd5hcRSxbaUJm60fZTsqrWINgiYhLkwBHA1KqwfW+VbpXCzlatVW6MNaJCqMY2tG+xhx+wUf3IeN4oN1R4pwGZcLwB/g4gBLAbNxLb9YV88rsLofLwWt2aQpB1D3idvFP8SS3Hei3/9AtWb7ZNblTz/SrPz3QGOSRzvTbzI1xxvuieiJhSjd4VyrVDqyMsUXGWugLtYIQ4PvXsmbGrdd9T8uBfoXr0z9CGpi6U56R/Kw1u5X/yE0wvUG7y5y2aWUCX6X+ONVaWoXN+vzPoW+jfjIhOhwsHuwPPvLzbIgdz4Q9w9Yw73mgP22C1DyFQRWPa1IRcNVQixbObCAa4gChf3YYfc1iDrR7oinEZATmrs2nu77daArO+p/zl0SXabc17e7USSNz2QRY+pObqAwg+5RtualJdSjJ9JSCLWaNFHyJSyKyRyn+Gt3iO+UDlm5wi8O9iV2Wo278jlUCboC6lUFeWraIItttKCIey6683kxXml5N+ODVsP6FbiDOrd408jK/OcMTihToR7tukXqGmiePLX1kbJgFz+
 0OwYvIxb
 AMq9DNoXNmA9JdlR+7jnFHyJ6LOs08ZuLneh8eiTvNZkXnvBKjwgcOQ3K+n0Sms2uqfZ7riRDDH0uZbjX9V8tjZ18SQjleGWWpkBJajM/Jz4cxvgeNfJY4d0hHaBlVk/plWeiJA5QSOirO71MhqwPx2UsFCw1VosjZHVGYojJGO1mbT4GPc+/2FQ8brxw6s8CpwQK0yy7FyVuaZJ26tjBvaEAJl0bxpkShFdYSMK6BAUK5/oZXImtBttZGoJjnwX4bJiE
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

Base(v7.2-rc1):
  First binding: 1456 ms
  Average of subsequent rebinds: 244.28 ms

With this patch and its prerequisites applied:
  First binding: 1440 ms
  Average of subsequent rebinds: 217.19 ms

This reduces the average memmap initialization time measured during rebind
from 244.28 ms to 217.19 ms, or about 11%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index a70acb7431a6..c2645b9bcef3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1065,6 +1065,44 @@ static void __ref zone_device_page_init_slow(struct page *page,
 		set_page_count(page, 0);
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
+}
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1120,6 +1158,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
+	bool use_template = zone_device_page_init_optimization_enabled();
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
@@ -1127,6 +1166,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1144,7 +1184,24 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+		if (!use_template) {
+			zone_device_page_init_slow(page, pfn, zone_idx,
+						   nid, pgmap);
+		} else if (pfn == start_pfn) {
+			/*
+			 * Seed the reusable head-page template from the
+			 * first real struct page, because the existing
+			 * page-init and pageblock helpers expect a real
+			 * memmap entry rather than a stack object.
+			 */
+			zone_device_page_init_slow(page, pfn, zone_idx,
+						   nid, pgmap);
+			/* init template page */
+			memcpy(&template, page, sizeof(*page));
+		} else {
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		}
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

