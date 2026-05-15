Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C969CCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374BB6B00C8; Fri, 15 May 2026 04:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C536B00CA; Fri, 15 May 2026 04:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289826B00CB; Fri, 15 May 2026 04:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 174E76B00C8
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:21:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4C5FA0876
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:21:58 +0000 (UTC)
X-FDA: 84768961116.25.B334A26
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8087A0003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:21:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZownNw4E;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778833315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYCBjnYEKsIsIlLg+PNgaRy21lWqkR++g+DLMmjalIQ=;
	b=sgLLW5kICGyYrI3a9RQ2n18myvDdzZqxTEoTzZxpRd6LibHYIqt1zFWaNXonxBVewjvev2
	VToYg6kpcQunz2j+Rwv9SX9cV5XQ4MWfgl1g41kcMjPwFvUp8WDsnV62cyUVDBiOnTeGjt
	kJOoaiy1JLLTqvcUb1DTEe9idJ4SRq0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778833315; a=rsa-sha256;
	cv=none;
	b=7F6Z9zp1EWeOvpD+xx1fgAAGrourbyZ3zZK8S6DRwv45myBhozQhCLJo9T/eVOwqwSubrv
	6Iqfc6yqcZufTcljZHTMqjT95bGaKC44T6/b6/ALTK2hKJxy4x8dirv6ToI3MOX+2IYp8Z
	ecpJ+6JHSybwrXhb/z1d4KhuT5XCgaY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZownNw4E;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778833311; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=HYCBjnYEKsIsIlLg+PNgaRy21lWqkR++g+DLMmjalIQ=;
 b=ZownNw4E13Cc0p/oxGHEh3k98nfl4IUBsVpQt5EySV10B7Qd1SmchQIMegOtgHFkB9fRqV
 ytvY1aIaYzD0xM/93Esv2zZ0ha3Yq1C5TRD4IVlAMOFSJQcNlLWOb9TtdinTp5xozvLUpv
 i8XSWafUORMqNhqaNfzxgfrRzhmPePpo1I7QGeiNva/NKAEpBHHV/yKSwxZCmCN9WEsrgt
 ps60DNlHiwfzcS7ftJzcbEv/J4ecv8BL+vCxR5P/W9HPJcCec4Z0poB3rMpuLujMmMD7Ao
 gvNllXB3YhXudZnhkSAyXJC0A8pygXDckvdE62PzjPrxd+JGlryc37StJ7sFvQ==
Message-Id: <20260515082045.63029-4-lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a06d79d+3efac3+kvack.org+lizhe.67@bytedance.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <arnd@arndb.de>, <rppt@kernel.org>, 
	<akpm@linux-foundation.org>, <david@kernel.org>
In-Reply-To: <20260515082045.63029-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH 3/4] mm: extend the template fast path to zone-device compound tails
Date: Fri, 15 May 2026 16:20:44 +0800
Content-Transfer-Encoding: 7bit
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D8087A0003
X-Stat-Signature: zieug4f1j4prp834ucfobz8q9mu6iowk
X-Rspam-User: 
X-HE-Tag: 1778833315-120342
X-HE-Meta: U2FsdGVkX1+ETCWJd3RIzYA7ypRKGzseD1/lB7AkHQTZ+brWjJHrGhUE4PvdhGxoar9AkqMIKgj2oFOl+DIknMn3IsaESr2F/XCVpyiwtIWrkMiCC911OG4JTA2AiTPSt3tsCgTueWhZGgNrYEd14GG4f37fgyUonuLQCNUBWdsXXRbOcspzmlItaSK526crgILCS4ZQM/a2k1XtDLOgH4kV4Tr/S+Aip+As61KrbJ7oCR25wcpYQ5qItv9kGeI+qRgoDH7oKrcbSorVZr53el5pdJj3Y2jD6GtF4G25N70lyeD1Xk6r8pIUr3hRQ9G97TdS26+qgKi1BudoiUmbKimBsVCwqlu8ud3oNtNAGbyR21rofJshUNjjn/NDu9WTUr2+COOvrGgHW6qijE9gWDAZttY+vnXSjVL2UYKKMndOG7WbP5tUV1HebgKslxxJKKjsoyh8ShL9j82B3oBP/52kveAapc8RaD6HFbSGaB7OzsDiMiv9rId+d8u9k1Sg6KqKJouLGbXDdUYKeTugFFUzD1KOuT51EP7u9s0cbaKvb066mlcMbZxkiUmQGBKSLL1EO+4FfLiAKfQxi8/QaDDJYI2hf019HzlMpHmiZKs+/btpHZtyXM1w9F1cQKNd8Tr5TpaSpT/YFmJPwOCiwyUUOrU50stAJW5Oza4NtjuxA5yMlFui5sb6Ibjj61o+zo6D8QGAcsdjRildt4rmxqktXPbF9s6zlyp7IkCv38dbGibPTD6sF92SKfIQDgdYs4xu5Gb7EsbWTUmwjJ7tu7jO5by0uOIfHPP5bor00fS0VCdKSpkmhLTTmLHsM+amZlYtFkDhbng5GKlHwcahJHa1riJrBVmQ69PerQyflco2y8CokrCmW5wQgga9dvGfrEROqJ4Ajk09/O4DTI9LeDE0Pyp24Td4F2k/xvgkJZAoPph8SBNL+4mFXXodhfOfp786cv7scW6XWI66XYC
 Ov0t5bXB
 /XqDy3VnzTgWrqS3+I2ypFgm3I4RC1VJQN+CGMzW9Z1jU4BUBqvnBvj7ctJRFcIND7nVz5e411Cbi2GJYH6DetXY/tAZ54GuTb8BBdCI5ZQCMnIJ/r4YP2u+3Ke6GOvXd+m6QKR9Wob8O+adtnh0onZnwNnUYdEqwzKRDg22OgE53eJ4NOHa5wVGRA6LQht8bjZQJ4e3nMPzbigIWfMPWLpDK8an4tZKDPH2h89nz0ijf91c9kmTiwB0mYcBTzvtgYF2E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template-based fast path currently only accelerates head-page
initialization in memmap_init_zone_device(). Compound tails still go
through the slow path one by one in memmap_init_compound().

Add separate head and tail template builders and reuse a prepared tail
template for all tail pages in the same compound range. Move the
head-page refcount handling out of generic_init_zone_device_page_slow()
so the two template builders can set their different initial refcount
states explicitly: head pages follow zone_device_page_init_refcount(),
while compound tails always start with a refcount of 0.

This extends the template-copy fast path to pfns_per_compound > 1
without changing the existing slow path.

Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel
Ice Lake server. This test exercises the dax_pmem rebind path and
measures memmap initialization latency.

Test procedure:
Unbind and rebind the dax_pmem driver, collect memmap initialization
time from the pr_debug() output of memmap_init_zone_device().

Base(v7.1-rc3):
  First binding: 1515 ms
  Average of subsequent rebinds: 313.45 ms

With this patch
  First binding: 1425 ms
  Average of subsequent rebinds: 255.47 ms

This reduces the average rebind time from 313.45 ms to 255.47 ms, or
about 20%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 80 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 19 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4c475c71a9d6..5a9e6ecfa894 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1035,9 +1035,6 @@ static void __ref generic_init_zone_device_page_slow(struct page *page,
 	 */
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
-
-	if (!zone_device_page_init_refcount(pgmap))
-		set_page_count(page, 0);
 }
 
 static void __ref zone_device_page_init_pageblock(struct page *page,
@@ -1064,6 +1061,8 @@ static inline void __init_zone_device_page(struct page *page, unsigned long pfn,
 					   struct dev_pagemap *pgmap)
 {
 	generic_init_zone_device_page_slow(page, pfn, zone_idx, nid, pgmap);
+	if (!zone_device_page_init_refcount(pgmap))
+		set_page_count(page, 0);
 	zone_device_page_init_pageblock(page, pfn);
 }
 
@@ -1084,13 +1083,28 @@ static inline void struct_page_layout_check(void)
 	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));
 }
 
-static inline void init_template_page(struct page *template,
-				      unsigned long pfn,
-				      unsigned long zone_idx,
-				      int nid,
-				      struct dev_pagemap *pgmap)
+static inline void init_template_head_page(struct page *template,
+					   unsigned long pfn,
+					   unsigned long zone_idx,
+					   int nid,
+					   struct dev_pagemap *pgmap)
+{
+	generic_init_zone_device_page_slow(template, pfn, zone_idx, nid, pgmap);
+	if (!zone_device_page_init_refcount(pgmap))
+		set_page_count(template, 0);
+}
+
+static inline void init_template_tail_page(struct page *template,
+					   unsigned long pfn,
+					   unsigned long zone_idx,
+					   int nid,
+					   struct dev_pagemap *pgmap,
+					   const struct page *head,
+					   unsigned int order)
 {
 	generic_init_zone_device_page_slow(template, pfn, zone_idx, nid, pgmap);
+	prep_compound_tail(template, head, order);
+	set_page_count(template, 0);
 }
 
 /*
@@ -1125,11 +1139,11 @@ static inline bool zone_device_page_init_optimization_enabled(void)
 {
 	return false;
 }
-static inline void init_template_page(struct page *template,
-				      unsigned long pfn,
-				      unsigned long zone_idx,
-				      int nid,
-				      struct dev_pagemap *pgmap)
+static inline void init_template_head_page(struct page *template,
+					   unsigned long pfn,
+					   unsigned long zone_idx,
+					   int nid,
+					   struct dev_pagemap *pgmap)
 {
 }
 static inline void struct_page_layout_check(void)
@@ -1139,6 +1153,15 @@ static void init_zone_device_page_from_template(struct page *page,
 		unsigned long pfn, const struct page *template)
 {
 }
+static inline void init_template_tail_page(struct page *template,
+					   unsigned long pfn,
+					   unsigned long zone_idx,
+					   int nid,
+					   struct dev_pagemap *pgmap,
+					   const struct page *head,
+					   unsigned int order)
+{
+}
 #endif
 
 /*
@@ -1162,10 +1185,12 @@ static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
 				       struct dev_pagemap *pgmap,
-				       unsigned long nr_pages)
+				       unsigned long nr_pages,
+				       bool use_template)
 {
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
+	struct page template;
 
 	/*
 	 * We have to initialize the pages, including setting up page links.
@@ -1174,12 +1199,27 @@ static void __ref memmap_init_compound(struct page *head,
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
+
+	/*
+	 * A tail template can be reused for all tail pages in the same compound page
+	 * because shared state for compound tails is pre-set by prep_compound_tail().
+	 * The per-page page->virtual and section in flags are fixed up after copying.
+	 */
+	if (use_template)
+		init_template_tail_page(&template, head_pfn + 1, zone_idx, nid,
+					pgmap, head, order);
+
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		if (use_template) {
+			init_zone_device_page_from_template(page, pfn,
+							    &template);
+		} else {
+			__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+			prep_compound_tail(page, head, order);
+			set_page_count(page, 0);
+		}
 	}
 	prep_compound_head(head, order);
 }
@@ -1214,7 +1254,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 	if (use_template) {
 		struct_page_layout_check();
-		init_template_page(&template, start_pfn, zone_idx, nid, pgmap);
+		init_template_head_page(&template, start_pfn, zone_idx,
+					nid, pgmap);
 	}
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
@@ -1229,7 +1270,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(altmap, pgmap),
+				     use_template);
 	}
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
-- 
2.20.1

