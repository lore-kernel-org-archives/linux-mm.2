Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78561C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7722F6B00AD; Wed,  1 Jul 2026 05:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7496B6B00AE; Wed,  1 Jul 2026 05:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660156B00AF; Wed,  1 Jul 2026 05:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 369466B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:08:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB07E1A029F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:08:39 +0000 (UTC)
X-FDA: 84939632358.26.B1F3EFE
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC90F1C000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:08:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=N3uTd82r;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896917;
	b=yH8hvW3w538pa2EDLUhqgCA8NASU0juhq313YlgZtPhhmaHsQPoWXzvLsr029qc0Rqt6SI
	DYmup2rCTCJ8p5IycPjDtZyaCSJ6SQYCb/IUCXlt0rbA6eiKi/Zhc7JuodhqkpPGByBYW3
	5rI1Y+COlFoHmRAXK5YpbDyEtOzT4ts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhC/iGsiRai6AMLFSR8WX2iRwDXXIEDlLdd8uNqjgTM=;
	b=Ao9e4/QjmrxZi9Lc7Wr+yUuzbSj8+Ls8Gby77V29XqHBP9oy/sCpX+i2VXQtVTBm6YeAsI
	TfabDh864P0yXBCCHkZqv4bJFRYwiWAXl9QEj1GWl7nymW+iOAz1GasQr4aa6rosNAS4ti
	1SF3dED0Uaa5JHjPmZDZliqL/KcQ6jc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=N3uTd82r;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782896908; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=WhC/iGsiRai6AMLFSR8WX2iRwDXXIEDlLdd8uNqjgTM=;
 b=N3uTd82rd6AhkwEGWT43AwwPlgPAIuCbcb0dX5rm5QXgOm0626IzHCQvo6wIqzg+Nu4xuB
 438Fc/IRUhGx+X8L8Mw4wGozwSZJY8TliARUqvOvx5vakkVLrQ7uTjWfBmhOu0C3HGcSOR
 V5qcskpjvOsiaW9DG0cCm0ifNorzIvosU1Vr1juK5t2D77OydXIuoSbvsXLahg3saC+ldQ
 k1+u0DrYbrb2ymyyYAXggnxkaOEra69+2dcPiL9YdWDZXC99lubSCoY5OxhIWyHtwb4NBs
 xSzAGRqjxzaH/H00mTQEy6iO1q5Ptt9ZCmwEgcbG+npQV3M5d6bcrpfd5VdWPg==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Date: Wed,  1 Jul 2026 17:05:49 +0800
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260701090553.62691-5-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a44d90a+8c384b+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20260701090553.62691-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: [PATCH v5 4/8] mm: add a template-based fast path for zone-device page init
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Stat-Signature: 7bmbbct54wbi636uz4ygwcfdop1rpe6r
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC90F1C000C
X-HE-Tag: 1782896917-671229
X-HE-Meta: U2FsdGVkX18rqWtY8NcY1KeHe0GQPsTEPXs/s7RsmoPlNCZZjXN3tc0HpqRtiELVJuujw+NrR8bcwGCAwviOMsIbmpdYwaMfdnSCXFnUMMvt4hJsOm3qZgQjpsRYTaaCnOBIeNj9ueW4kUQHzFulcG4ypg0LM822E/gSJGR8p6tVtmAA9EKGgtYG8uFdzZO8SFdx8GhsRu//DjDgsd5WmGakKIJDLtS02dOLkkD2UnAbbdfT77SZuHIUAd30JjoX6T5z1jxxb5GipaDyZ7c2lG/8ggmdqyRzwsGpIoRuu0jM6BUHRpRvC3UzmyZ6JqHsUagDWojzs3ki4NnNuzjY8KFDOS2u/Wf3M/a+OfzfU43vWW1wTJCOU8g14fHIEe3ednQFX2Og65ziovueIUQQN2gemFsdUZA6Qe4qbq9m2UAHhwqKInDynYO1/eEt4R6YpwOtFi4T+kTd4QREQ8SdTY3rQOpElDjvY3Zy/PNVT2bHHhbfhlfhbbrThRzR5PJ5jc3oMwoq3VKHXSoYiroTIjiicd+eUd8tA4V0vnfU7cEhbNQKBCdU1CZpeIKzxyTCjdc/JL+9YuTZTKZNo0PIiK5+M1I5sAc7zE2umxYeLpymossWc6VEtgGR2dJRSH+pWm1t5f6x06+KP626PdQPezKqYCh3IJKiGnP5+pWWc/Ysw9lbc+kceVBDMlOkNtcJgmsDq0NPG/h+RbXmV+JkbLWtIqhGaceX1knQhm2RzohclDNiqgLObgT/V9sYMZe1ZZUMw+Dt+ZBYOUC9ZPk5XT4z5rLkjy1FCuFo+SDQ4iosL8vE134W6zrhOHaXPUrkYSh67FIsEpt6BPaLpvmeA7FQR3OvpkOuxgec8IpkPCiUM1wh+O/Jmb3kfZox0w85wFtgLHIXI0ntfDEillHfaQeLmNoJSxtSN0cpVv6+m4QPYdTFikV1LnWVyxLXD11nhgT8chyGhl+HhHa5aEa
 6l/C6YU3
 hnHHYO6Gx4o9zDfzXih/UXUUbMRBbE9SXqDWHBDcXakgQKUGUMK4VFu1FfWhcAOfm2AEbclE/bGlZsYyqMZvdS7FoqhYKMeAgkhwbCe0OmrTcmEPJQNSlGVf/iW+BjsNR3bNfCXkQDx+9AWcywuv/YzcECoQ1m6otzhZpzNVUmP9aiK0izwjddAER8Sk7wFXP05qshKOYh04J49RzC2Xy1MElgTt7C4J1tufFnS+AiFluYA3L/cu7gji6Zev3O+ICbPci
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

This reduces the average rebind time from 244.28 ms to 217.19 ms, or
about 11%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4c7fad440c2a..cc8417951467 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1066,6 +1066,50 @@ static void __ref zone_device_page_init_slow(struct page *page,
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
+}
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1121,6 +1165,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
+	bool use_template = zone_device_page_init_optimization_enabled();
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
@@ -1128,6 +1173,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1142,10 +1188,36 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		struct page *page = pfn_to_page(pfn);
+
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
+				compound_nr_pages(start_pfn, altmap, pgmap));
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
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

