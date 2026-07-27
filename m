Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BACC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511736B00D7; Mon, 27 Jul 2026 08:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E89C6B00D9; Mon, 27 Jul 2026 08:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1306B00DA; Mon, 27 Jul 2026 08:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9066B00D7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:36:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 733AB806FC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:36:39 +0000 (UTC)
X-FDA: 85034505318.17.57FD797
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf06.hostedemail.com (Postfix) with ESMTP id 102D4180004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:36:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="fDQU/xTj";
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OXSJ03+XyIqi02GqEj3ajlM+g5iP3d6qhTy7H8GWxg=;
	b=LloRf0JBN2yjME3+OvKvtLlVhOjtHKVKRA9cmSu++HqVM/4IUr+1qsgpWjKVw6aeYKJhFj
	Mg2q7fJhyeAFRMfcdD9/yiAh18k668LNQJfgkjIFIcP9bGb+APiK3pi+81oSWAch77aCBW
	DkSP2ktnOYUPvlmCrH750rxmLAj6bro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155797;
	b=0JEE04UokLDG9sp3pAfYftMXeUBmc+/ri1CfTzhldYcMANgh/fWxf2GN/MsqgALjapICmw
	DWup3/1M/rKu0Ad/jNHWlNWtsWg1/dZBIJnOr87EDNdJcBg56zOwePTP4SyXsDl5jSjtz1
	TTZevTeCLwn/PyAz/U1W3cYZBhpBrFA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="fDQU/xTj";
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155792; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1OXSJ03+XyIqi02GqEj3ajlM+g5iP3d6qhTy7H8GWxg=;
 b=fDQU/xTjRXRvHzm00RtjJXifoTKo/HY6KHFE93o6Jsxn1Q9J1dV1wQfrHTnBxStcTJMpWl
 pvvSXcZwXjHuqpRuMmHoFT9qzMERP4PGct734jfV85ZEgcSjzHqsP5ZIOfplsxs4KKWOld
 7ahFK0+IeJawzafxzuytopjGCyKyTQldKFac4Njq4jnYjXexxZNhvPKl94ObVxAixB/z6s
 N8ITLirPTSB+7LcKDgztDP+50G5gl3sPvNUe4eHN0vEGyvLuGYMO+dCNQ6L/DBuJHXfI4n
 UugPwt89X9jkq21cFHG+ss+PNuDjHW59xlVLblo14Xwf0v4yuZ117fIOdbBClQ==
Date: Mon, 27 Jul 2026 20:34:24 +0800
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a6750ce+ce110d+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Subject: [PATCH v8 4/9] mm: add a template-based fast path for zone-device page init
Message-Id: <20260727123429.5673-5-lizhe.67@bytedance.com>
Mime-Version: 1.0
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 102D4180004
X-Stat-Signature: zxa9yztstpjd47iz6af9yi6sjyeij1jd
X-HE-Tag: 1785155796-338067
X-HE-Meta: U2FsdGVkX181+4ZAOOr4ttN5WfrfHOuIUqyAZe9JNAL+M49fQxlRnEX3u8N0I4CQilsSlVV5FeqDx4uA2tGNVxqCMYtV7TvQgXlnLxZ+yl5Ia/Za8h/fj2ZLFzMbLFT6ecB0VqkEhAPIsAl8Shmrh5vD5aEJc1KvXC9M+Dc+YLxGRdBs4W617a6NiE7Aqqw/oP6WNJjFwmE3TAMCXS0ajY5MM9Q1Syhl03EZYhsxeU39F28peBcjlBwIYnLv/PQKFiqNs4hXAQasIA/r9ubyxFkOWtNXieYphsWgeZXZA71dKlM6HzbunX/91FfOjGOnMCGQVBMPWNz2H7SaIlP2Anw64E7Ztks+ZZa2QIbuqhT0/t94wu9OOkivf9guIUACIrB1l2H3wevwj4xsrVvE9lqUQQObaBbX4vgyVKHv3usvdcBQEQKrcs+xE+5yu6mc+2TTqzBr9805qpBHL2RBY86Iuty4j0QvCVGOnI+Q1twqXUzUnXy7MTVPmctQlv/keK8Tqe9jRjDjPU5uKHZ2GVhMZvhFiFd8winj4mzFssutG6SHcq08gXNqCD/Gstp9G2+WXhMVjADBMmnWGN8iIuxpuSApgolOet+tOffRSKhdV+MHVQjGKBxpMt4UmaLT9Q6iM/v9LHJ4f7gSBPU4ISWRnZ8aik7rgatzMWqtEukb/L+adtK7Q5nhe/dnsqzkH5Eh6Fi7bdJewv6AsEVm1hkmnrCYQrxOoR7pljyd0VT6him9vtGDg1vVEIkyxK4i4EGytDJ8jb4ZiwVAQ8sW+ikG9hVmsWivHvGqlXcsAHa7NiKiWdkLyOLuOt6jip9jX1YU3zg6Dhi3SYyuVbws2oLxoUr25BB3x3+AXm7Wl0EZtTCqywuPqd3z80untKAm8YBl2RALbQyj0pTUazfRG3A+ucJwXU424jY5mCzHzHfu+wyq1jACd3S+2uYZi2fBDTE2J6xr7J4TNxnPQK9
 T+Tlacvt
 r4Qq6mnO2in9JTb0xHK9w95e/7JBckSp8zhONyht2XfHV9LFTWrUSIqTvXaeXir6kwfxPSdMGl0dPYBQfuyBeReDX3s4K8pnMht6nTLtQikNnWpFwJRFBx+3W+EbhkXMt8StHpXTgizgMKPBnxLD3kH52mZ5wsneFWLqiDLcMlhlUxItYkTvBgJlT7BBjZE/gyO03Dtxk9ptfIoGQA5YhVS4NeRtO+QjzERv9axr5IZR/yLQopa4RM06CAp32u4bEkLBxJlhFqmkGirEIwJ3KQZ8ZC2GIEZcBeNCTBUrYpqlCecvKePI5EcaVxOpOL5DpLJ0WIogvXEKn20OgN9LJQvOhIFS84mR5NbRPJF7mvBHIA/QNGXmDXIPC8w==
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

