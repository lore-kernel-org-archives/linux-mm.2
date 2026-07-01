Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55741C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5018E6B00AE; Wed,  1 Jul 2026 05:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9116B00AF; Wed,  1 Jul 2026 05:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416A76B00B0; Wed,  1 Jul 2026 05:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE1A6B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:09:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB6C4A02B3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:08:59 +0000 (UTC)
X-FDA: 84939633198.17.88267AB
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35352A000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:08:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Z2axJOc0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896938;
	b=b7mepkqTTrHj6oFE4CJipZJsmlE8sk8jgg+jLhG05QPbWFoQspvC54f+fyX1PjxJzxM7ar
	bB/n9Rt+LLmzjAWGYeErw3FGfzCFFam9tBY+Yw2ZT8wLMarlqT8/p731MsfFgtN5vl1YST
	R5hXMFHN7NQ9NrSBV54qXMQ+UPwU8yY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4LpGd1s160eDq45kTLayWuXfCywKUfCzxMxs45e1/A=;
	b=hcHjEyaVY5ZzgMJcWEpBpdLnmzvFJybbKIEGUn7xutI6OQmrCcfH8aH3HMFZo2dkltM+xN
	TR1vkj8+7VQfoZHqTFUe9ROMKbaGcgBOhHED3Yta/VQ89dEOU678X53CdsfWnv9oEFmLNf
	Adl7tzuZ0G9R2N5RKNFXCW08TMFBShM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Z2axJOc0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782896931; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/4LpGd1s160eDq45kTLayWuXfCywKUfCzxMxs45e1/A=;
 b=Z2axJOc0VO7AxiEyvJIs1079BbQWS5QAKOqh4D16BOKQED38V2mn+wp3ryfn/04sCnqtO3
 n4hyoSzvFfATOSNW6c5ISjiJAAHsUoTPgtjI5M7ZFznL1V6odxPRi/Lc+Jv4t4yJpi6F0R
 tcBFQDTn2AW2ByiWyeJgEHJ+Y10CaW29Lpi60NNF4OpVHORPrJbDEeh4DvwKWKoKeF7KEi
 noIcFSxXZZqCHDfzW/Ru2/zB0y5MXsYeiomAgeK3wD4K4+IjD8186elRGdJirZ+/3+gHmz
 Ff3fV4tijmXfIBbJauislEcwRHvnyWhut0cwqptt5s6eIDsV6FcF+jBrc38uPA==
In-Reply-To: <20260701090553.62691-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Subject: [PATCH v5 5/8] mm: extend the template fast path to zone-device compound tails
Message-Id: <20260701090553.62691-6-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed,  1 Jul 2026 17:05:50 +0800
X-Lms-Return-Path: <lba+26a44d921+0493bb+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35352A000D
X-Rspam-User: 
X-Stat-Signature: nxp8ep1zdk9kzazyuxyusck6smjbh4hz
X-HE-Tag: 1782896936-681893
X-HE-Meta: U2FsdGVkX1/bHprTOLmYPKcsAtUUzji84wUSByeliCUNSM/bZfv4fwP0HlbRS+vZucbcGCZq7+LBPvXg2XAjPpxY/+hrzMUvy3qAv6jnvFLmDET7ZGWvhZZi2Rad0EH8rNK5ubgx/NUt28iki4mFz5FGdtsEGH9N1sXOpyym8zleyM0QKj7FQh/nUj69gWObs1IDiyDYvjwHeLnFoDXDzxhx/eq0Y6EXFlT4Lgw3czZ1ngZvyVL9V0OVnXnthlPyCvzwg22sWDphayjXVNuTdzvMQP9oWhDgzeLQg4nW/RscQKsHpFwJg2RtqbixWyK+2QLIWQS8NYd5CnSvtIC2hxx9/wsq2mCFy8L/JoGF6VMsMm9dZKUyXTXG60st1nyvdbe7VYXevNYT7zaY1wfXXNZ7JIVUO52P8sY3A0N91FS2NyqWKNjEdJAC4QN4XRK9ZcHBKRZX0qLJUB9YZAboYlNIXe81Gu6/IONJw/XIRDnoc7xD9WD4Cb1PB/0kWyGQlLCA4J+9jMO/3toor/l/RFGlimVJt8g6npfCStOMdumkjiOAqjSOaAHPncav5YjlS48UOZXZL0FjE7Hea6uREAnMWjGkJfKX6yBbNmYk3md9dbJ2ou+RYH0GgDLW0wIFbF6veSC418WaO/DFHuExgEeIbiAh6HGRzcZaorm/ahZDeSH6Q/ehU7FBe56tiBX532SbwB0TyisiLbhCHkOz8eKhpHdyteFLb8g5+OQdujwSfxONcFFJs2A26fTb3eWi68dlWgq5bwRhRBwjAxMc6RX0yvlvUgFvKq/9+CoWdc1eRDksnLOKX0vp+vGwNq43J3TcT03Y/GVqRL6mwAEKqLpdSQ4ayT353hEQ3Ioq4/YjqJkQdq2AOmMeX+Dr5vUK27XAcP9/le8482lXGtMsCrewTcC2EPGvbtm5OYbQg2f0Lw/sgG+al57l247EGncZESdEg2D0w4euifpyog+
 dHeFnwEP
 rWgP5uccVkGIYeBs5NszGPsO4L9YJHchvgfIKntr+gGya8PywbM2pSOYzvESP8vThxexU6yyvcKTaK9xGy9JCj+bQp/AjKGojgdF2CqrAu/0nTZNcwJQsqHhLP4Zh2U2Bhi8v6dgjoPhxFgpAVIy828MGaqkkboN+GJokMbsMHlqrlr49rJfVWHkMlykoPCAVnrVyi6GUkOLJMfjWYClOEZsKvvEkcL/O838R3OF0tkf3JGbVOuiV0kxcBlW0SVF3KlFO
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
template across the tail pages in a compound range. Head pages preserve
the existing refcount policy, while compound tails always start with a
refcount of 0 after prep_compound_tail().

This extends the template-copy fast path to pfns_per_compound > 1
without changing the existing slow path. Tail-page PFN-dependent fields
are refreshed in the reusable tail template before each copy.

Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel
Ice Lake server. This test exercises the dax_pmem rebind path and
measures memmap initialization latency.

Test procedure:
Unbind and rebind the dax_pmem driver 30 times, collect memmap
initialization time from the pr_debug() output of memmap_init_zone_device().

Base(v7.2-rc1):
  First binding: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this patch and its prerequisites applied:
  First binding: 1403 ms
  Average of subsequent rebinds: 244.37 ms

This reduces the average rebind time from 273.31 ms to 244.37 ms, or
about 10.6%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 47 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index cc8417951467..60794050bc07 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1081,6 +1081,16 @@ static inline void zone_device_template_page_init(struct page *template,
 	memcpy(template, src, sizeof(*template));
 }
 
+static inline void zone_device_tail_page_init(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap, const struct page *head,
+		unsigned int order)
+{
+	zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+	prep_compound_tail(page, head, order);
+	set_page_count(page, 0);
+}
+
 /*
  * 'template' is a reusable page prototype rather than a strictly immutable
  * object. Most ZONE_DEVICE fields stay constant across the pages covered by
@@ -1138,10 +1148,12 @@ static void __ref memmap_init_compound(struct page *head,
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
@@ -1150,12 +1162,31 @@ static void __ref memmap_init_compound(struct page *head,
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
+
+	pfn = head_pfn + 1;
+	/*
+	 * All tails of the same compound page share the state established by
+	 * prep_compound_tail(). Reuse one tail template for the whole range and
+	 * refresh only the PFN-dependent fields in that template before each copy.
+	 */
+	if (use_template) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		zone_device_tail_page_init(page, pfn, zone_idx, nid,
+					   pgmap, head, order);
+		zone_device_template_page_init(&template, page);
+		pfn++;
+	}
+
+	for (; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (use_template)
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		else
+			zone_device_tail_page_init(page, pfn, zone_idx, nid,
+						   pgmap, head, order);
 	}
 	prep_compound_head(head, order);
 }
@@ -1205,7 +1236,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		zone_device_template_page_init(&template, page);
 		if (pfns_per_compound != 1)
 			memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				compound_nr_pages(start_pfn, altmap, pgmap));
+				compound_nr_pages(start_pfn, altmap, pgmap),
+				use_template);
 		pfn += pfns_per_compound;
 	}
 
@@ -1226,7 +1258,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap),
+				     use_template);
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
-- 
2.20.1

