Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD04C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C9C6B0096; Thu,  9 Jul 2026 07:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3DF6B0098; Thu,  9 Jul 2026 07:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431F06B0099; Thu,  9 Jul 2026 07:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A45C6B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:27:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A30468916E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:27:22 +0000 (UTC)
X-FDA: 84969012324.24.D657044
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf07.hostedemail.com (Postfix) with ESMTP id 993884000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:27:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=OrSDs+uw;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9CZpy1rL9Q8Ha/0FdtpD+kuKFGiz/BvcuwBKqI0mU0=;
	b=7UNFx4MShMgxGleN6/XXc1BrXrqSzdjlzKfWYFvCYGzDTO4cTcKK6S07avgIHG2tL5NufQ
	GMDRPLtW/qkbpBrH0MEtYCbOBYfEfh6CGAzHbOeQEMhs1PEKirr/J+jiV8ou46PdgLHRdR
	sjS1DZ/qerT1vRN2gA95+HAIoN8JnBs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=OrSDs+uw;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596441;
	b=zfbmjRCF5NB6PMPHPnMhOUXMHsubQpzsw5gzFIehUxWzq0JDFO57i1NFI+TAf8ukRD/6p3
	eZs261EpAUvaRgzbeBD66JmlHd2cyTb0CtKbF2KFUgQVGpa1NybHXbHazlYGV2CmnhFtQr
	p8hMWi051l0DWxcWDjbfE/xcgo4fSDg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596435; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=v9CZpy1rL9Q8Ha/0FdtpD+kuKFGiz/BvcuwBKqI0mU0=;
 b=OrSDs+uwB8hCxnNYIkf56XmTfrqbCZdIAf2Z/8nw+e77gH7O1kYBGVpIt6PBN0Xp5Be/dQ
 ZDeG1+1yKsCoW5YHDFkZIvkbSddYdFOFR2K8NaBbnc7LThupcSaNJrQoathXkNZLmgMCJJ
 5/SzlKTWADOsaFBqwgKoiThGNxJ5Ak9fFl5SoHCZpvS0h8UWL1iqgrZa2YORqnDkhZGuAw
 9vEZFDh4G/LzzFmvmO2OwWfJ8RsSXE23hDn8KnvSDDPD68eIDIcuFY34F7EHBeP4Ssyhb4
 6RXCz9rY7bdm+DSieQ6MKEZI82pkftcmo5hnYIAUXTaFo2haf2hHiM3JnUjgzw==
In-Reply-To: <20260709112520.24857-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Date: Thu,  9 Jul 2026 19:25:16 +0800
Subject: [PATCH v6 4/8] mm: add a template-based fast path for zone-device page init
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a4f8591+62bb61+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260709112520.24857-5-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 993884000D
X-Stat-Signature: t8fxbnfbzj7fiafnyxqq4rqkoh63r9m8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783596440-925752
X-HE-Meta: U2FsdGVkX1+dEzucXyDzBVERf+527dn0t2ASdjqR9UV4YJ3v4+1t9p2utVn3ivJdF45L14R/EN/rGhmAB99tcCdc4leO8Q6oP9GfxNXTiR0/6xNB8MK61TT4kigz0SFYWpby/ETEHQgvCl/j9nnetc+WTdHexCszV6wIQHDkj32JZTuCpFMVhdsLl+IH8RDpM4Y3Ijn5Na+ie1PDDRbsqlOo57+JRIopdWd35ueZEa8A6NNiT/lI8Mz/4/7pqAmQ44OZnCzHudbx8JJ9ES4zh4swkXeclvwvphxPzqquccPzafXWcqV8uBrEVhe1tLneObz2fUBPhgAro5eYemVhNhPnEeKMBOQSv58TxkpihGKGVrb0f1+6lSuFw6dDnyhMStJwE5iSwWxQUqZSy7+gv5DVhcS9m1WPeFacyf8ayIWmLYi8EYng7hNlQ7uy0H2+KSIG+2xSZ9Zcip1zBE/BYFyqorC/lhWQi4bekApnlKkvyhYOZuTSH8LfASBLdMR1/obT6MNukPh89BivVk93GTItY3puthv+JLSXDYVX2NgSsD/z9/q+SYDcAoAVpX033/nNGzpD/B3M6h4eYOCoa3/Fo+QnYp5TppAU+/TpElLppye991GmAiKqZlySl/s0jiW0mahoPHja4Wzz7GvvVVjAjraVAp5njwRQ80kJquAPSEzRPCKPMLufCFBpISN8CDTc4KUQ5JWbQsbahpyhXcsB7fYnPINo8jX2VJs+HFP1ODgcrYJo932ibaFnAG06Rs9xcW73csYI56Ruzap3F+XaXxLDIh3x1Ft3uTFDT5Cd9qIJvgcAwwIYvXUX2N+Le/1MsbcmAF6lzaS63t0ANHZG1L8OfS9lj1uXLDDebFfKCjEAW8mesTR4OTu6N3VaqhVTThcrofPtnhOOlvqpVb7p02Z+zzdmzx9tKEKwvdZUHf9cwfzBIRVVSxS1ydAWMJ1CWOh/UUvLDYGKV7G
 5XbCq4vX
 Tz9ZOL39zrnkYR0AqWUdPRHRNiH9aE8EpN0qCvy+thTSdqjkBAC3051NsqplZz5TlfF//xqKTDlDDDlkrAmzB5lj7xBYlJSolm7CMdDXTd6AbVAG3HNIX23LY1cdMEGU2+XVaXK9jRo0fySNVBP9BxVeFg4ehrrH3q3ITfPzwZvInL37XyQZk0Gqt6AmPBPuBbCjsAsTQs0BAD+MIcI/NqBWvfLixAAWHOI7ykAMdNLVzGoHmBVel0nCH0C8P2bMiIzQ/
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
 mm/mm_init.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5fccfbacf855..170021e182e0 100644
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

