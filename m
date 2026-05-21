Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A27DCCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120D66B00B0; Thu, 21 May 2026 00:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA5E6B00B2; Thu, 21 May 2026 00:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB906B00B3; Thu, 21 May 2026 00:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCAF86B00B0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:04:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D523C1D84
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:04:09 +0000 (UTC)
X-FDA: 84790084218.16.EF1B419
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf29.hostedemail.com (Postfix) with ESMTP id B073E120006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:04:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=lLkvFm22;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AofTeM9rzRb3Y51PR5zzdSLZE+dFDRAZqaps3o2hj6g=;
	b=FtGms9i+JzWDHuXLUt7EB3Do7x+C4CmuYUfKviXN1ItBCnK4uGr7KHALAwZt6tsuF4RcFo
	MNJPQm40lzfbv+9qs2PkqTDrOa0MD9MCKlawl5WU/oqZX1di/mgabW7yR8a5tgopIcSdVm
	duAzWh0dlheciYLkFnA0Ilok8YqV8YU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336247; a=rsa-sha256;
	cv=none;
	b=IkzCQGCIZ5cGOd7AUz8pjDk5XzXERZ/UaoTDmfUIFcYO+Os1Jv6D8lrbve79o145813OOH
	qOk90dTOp8DZquC0m0dQ6hKD3sCK40k2CXVq9e3SmFoEKf1mjhBKLG9P6TG05/c3peGWel
	UNZCR9JICd20YPJ+yFH4iL+QCEwsC0c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=lLkvFm22;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779336243; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=AofTeM9rzRb3Y51PR5zzdSLZE+dFDRAZqaps3o2hj6g=;
 b=lLkvFm229mLzQjJtQzLIywMtrv1W3GLcKSZ2rNjfYNeB0jku+lLJtcVxDN1RiZ7dYRhlAG
 xxunFHHFU7Yu0iPrfd82omJ247Ti24r6mysFBzV3Far1OMJF48Ja/9goxB5AAJHNzJ4ysh
 7kKrKa9uPGbkImacrl2FWg+wCT8qFCKDXYYCUWzWpae3hlo3Uij6D7+Hy4BRSSdr5YE/xo
 E3lLETxV2O9X4vQz/bMz49fJuiBS7OoF6sCUc2zQSq3l0FVviRuSErK94UX/X13/pYbeGD
 5RoJvN3FrKQcB4wWdciqTUBY4ghlJ9mektmcGTce72gXQNGTCg2Bw28Ac+rP8Q==
Date: Thu, 21 May 2026 12:01:21 +0800
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v2 4/7] mm: extend the template fast path to zone-device compound tails
Message-Id: <20260521040124.10608-5-lizhe.67@bytedance.com>
In-Reply-To: <20260521040124.10608-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a0e8431+e07fcf+kvack.org+lizhe.67@bytedance.com>
To: <apopple@nvidia.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<kees@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <x86@kernel.org>, 
	<linux-hardening@vger.kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Queue-Id: B073E120006
X-Rspamd-Server: rspam04
X-Stat-Signature: jpaca7gmwh5gd5cketho793dwo1op8qd
X-HE-Tag: 1779336247-170872
X-HE-Meta: U2FsdGVkX1+3Tkt547tyx8jh/toooPo/kGc3TNNba2Djv/5tKgzzgIvjIG08tL3aYw383jjl/o+fQYczJ15L+iR7KjsoZXHAIyhQzlmjN62XTDof+Pbi/Z+beO7V4bKMZa6cMZWWJvXtHZsV8PpXnPaD4oxSB3JWYgbPrbIK4HyjecKwMnWIBzmutAlbLfT1ggdCEbWoLXq6hhKxnDrzVd6McCp3FAoGpyn2z4FpNegrH6BXhXgY+BuxYPRDX5iqAAthJ06jfzpaXZWz8BZSGU4b+3rxeVRm+XxWzRHIHSJ/6UN7tAaB70r0LINxc2fCX8Q/o3pmd7qZeH8h9AanjXVHREp8Fo1ocNAX7eEG8SnsOZAwAaOsG/AmRt4hwQ18tyhr5JbzQGsP/DF4N6DZtz2b9Sb0AYKzcsTaYpJMwgZZSQT2XttUT08WEjxGwuiZDJ45d9rO20HW/HZDrY7wrnvYm1whiVblPCP0xbnBPc3UoxAGGtsKN+P0kqd8pKjGeiWciemO87oaduYhNS+8J+Ai2ELA/x3u2tbyLUkF/gaewxp09tkkiRIuS/pQBAVYBaLI/OYqR3fc4DNv72wpiE3jhltd1gBbzC31cvrYrUhtqRH7+mf59TtJmio29I1IXjCyMxIXiI0TUDgOFpOPQVGkxSJcNv73mIKqgvObC1P7d4Z4CGjJ5D9HZ91V7w3NQvCj1dZGMUxzGVdrZQAbpTTD2MH3M7PyHG07bqPwklpyFMY1lhpRQxhA0ty9EAU0ggcA528gLyhzNUOTpxJ/YaekjvGeLN2OOrkGQHlzIDwJg/CCaqcMIvQcgjQXhSvgDDbTSP2vRiMtiTYZU/dUidA1UmAMoe5NKZtkYKdvcwYXXsYcfewrTBxmeTGQ45PN+jGVowPIWVmrINTg9zF6FcO5MGhSRQxeRUUIbvb+E/X+lpTEFmXgH9/FmgNzuPIWfroX1LWNJAOas5zv16+
 eHlumkgT
 KDeD9pOLz4OlCa+NKLMX77hMzInFA/6paNGv2AhD38+cK9kTOZ8pKQMDhbIBKRbfflBEWDKtJLgCwX2hnKdqO+fxljUjAfr0vjMbr4oYUPjWQrmj6NpqUbD0rYASh4Xb+dU4ltkvKOzFKwsjzRyI/JRBV7LcfeCh2mnipPhc5MlDYvsnyZyO3TWKNDHsAoBZpPvM/DZhZjWyYKWEFBS4giJxduhWxlSvEOd4eP8fiLj03iVysX4c3iyVos9KwApU4FP1O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path from the previous patch only accelerates head
pages. Compound tails in memmap_init_compound() still go through the
slow path one by one.

Build separate head and tail templates and reuse one prepared tail
template across the tail pages in a compound range. Head pages keep the
zone_device_page_init_refcount() policy, while compound tails always
start with a refcount of 0 after prep_compound_tail().

This extends the template-copy fast path to pfns_per_compound > 1
without changing the existing slow path.

Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel
Ice Lake server. This test exercises the dax_pmem rebind path and
measures memmap initialization latency.

Test procedure:
Unbind and rebind the dax_pmem driver 30 times, collect memmap
initialization time from the pr_debug() output of memmap_init_zone_device().

Base(v7.1-rc3):
  First binding: 1515 ms
  Average of subsequent rebinds: 313.45 ms

With patches 1-4 applied:
  First binding: 1422 ms
  Average of subsequent rebinds: 256.56 ms

This reduces the average rebind time from 313.45 ms to 256.56 ms, or
about 18.1%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 51 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2992711351a0..17a84d4cda01 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1084,17 +1084,25 @@ static inline bool zone_device_page_init_optimization_enabled(void)
 		IS_ALIGNED(sizeof(struct page), sizeof(u64));
 }
 
-static inline void zone_device_template_page_init(struct page *template,
-						  unsigned long pfn,
-						  unsigned long zone_idx,
-						  int nid,
-						  struct dev_pagemap *pgmap)
+static inline void zone_device_template_head_page_init(struct page *template,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap)
 {
 	__zone_device_page_init(template, pfn, zone_idx, nid, pgmap);
 	if (!zone_device_page_init_refcount(pgmap))
 		set_page_count(template, 0);
 }
 
+static inline void zone_device_template_tail_page_init(struct page *template,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap, const struct page *head,
+		unsigned int order)
+{
+	__zone_device_page_init(template, pfn, zone_idx, nid, pgmap);
+	prep_compound_tail(template, head, order);
+	set_page_count(template, 0);
+}
+
 /*
  * The copied template already provides the PFN-invariant portion of a
  * ZONE_DEVICE struct page. Fix up the fields that still depend on @pfn
@@ -1144,10 +1152,12 @@ static void __ref memmap_init_compound(struct page *head,
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
@@ -1156,12 +1166,28 @@ static void __ref memmap_init_compound(struct page *head,
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
+		zone_device_template_tail_page_init(&template, head_pfn + 1,
+						    zone_idx, nid, pgmap,
+						    head, order);
+
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		if (use_template) {
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		} else {
+			zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+			prep_compound_tail(page, head, order);
+			set_page_count(page, 0);
+		}
 	}
 	prep_compound_head(head, order);
 }
@@ -1195,8 +1221,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	}
 
 	if (use_template)
-		zone_device_template_page_init(&template, start_pfn, zone_idx,
-					       nid, pgmap);
+		zone_device_template_head_page_init(&template, start_pfn,
+						    zone_idx, nid, pgmap);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
@@ -1212,7 +1238,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(altmap, pgmap),
+				     use_template);
 	}
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
-- 
2.20.1

