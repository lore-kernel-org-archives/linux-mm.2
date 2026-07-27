Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC92EC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5386B00D9; Mon, 27 Jul 2026 08:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74BF6B00DB; Mon, 27 Jul 2026 08:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8CF86B00DC; Mon, 27 Jul 2026 08:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A051B6B00D9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:37:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35DDA1606B4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:37:02 +0000 (UTC)
X-FDA: 85034506284.07.AD9BE35
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf18.hostedemail.com (Postfix) with ESMTP id 336F51C000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:36:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="EjF/FVF7";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxmgrDMAVpE6lcX28qNeYhL42ykWrhIjdDLod/Kz2Jg=;
	b=UewrULJ/bbru3llc74dqfK6TONMgd2GDCM3zU6wyfsw8zf97lpW9rGOQH3RrkW4gGsLeP2
	00k2j0EAORv7NxDXvQaHGc5EsCqkXEoiwz1Y3sTHOKkIpI6Fe9Wo1k8AIIqWuKX6iQu61h
	ePH7k+q9D5rpPWpigp4fFZ3mDwQIZhA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="EjF/FVF7";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155820;
	b=WUrCLEnYYkD8wzlP5UR3c5F1nl7fWZXgZV802rgQqD2ezSpvaZI4IBKNmQ0KdyVybtpZbn
	odmVDvGOlB4ik5ZVb9hLybV2a60e7hQZYN2oXXauWoUIcyJ75yqrFoSR5ZPspvM8pPb1e7
	VB6Pa6Sjqypx7NwHYM0MEkO4s8ABF3Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155815; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jxmgrDMAVpE6lcX28qNeYhL42ykWrhIjdDLod/Kz2Jg=;
 b=EjF/FVF7mERZudwuitFgmGJTzOcsR+2kyfboteYHPLcRUftOumgPL9J5EPdiiX6ZmTklno
 dOUES7UCI23frutQ2hDCJ8fArxbFszlbGA6M5N4Eium4bs5XpDhdZL16atStH7GVSyu5L3
 Go0iyZ04X5Qu++4l9/zTb182H7LAJFl9ztPorT2qC2rRFb83iVRI3VbSeuHeBRa0UjoZM0
 b7hj6+Hc+gvuA8n+NTZLJlP2F9XFKHP1USKvLwOxwaB6JigsZIzaZiD2y/OITch1ZBNqmn
 lk4nFxWyxUj7M7cRhQ9ileSR5Ctntc5RE1hCBoik9kZrgb6YLge2x9amfKBFcg==
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v8 5/9] mm: extend the template fast path to zone-device compound tails
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a6750e5+5c7543+kvack.org+lizhe.67@bytedance.com>
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Message-Id: <20260727123429.5673-6-lizhe.67@bytedance.com>
Date: Mon, 27 Jul 2026 20:34:25 +0800
Mime-Version: 1.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 336F51C000B
X-Rspam-User: 
X-Stat-Signature: tsq8cbyk91zypyz5x8trxhbrx3oeyyos
X-HE-Tag: 1785155819-768353
X-HE-Meta: U2FsdGVkX19kWy02EyAbFTl5jAgRCIWu+8QdCDK7du+wpzt+gT7/0BfUepj9eoORcULFMAkruuIsMlJD2xkMp3wuRjwUeU3Pbarm+mP3wkury3DbSoVah4JjjJwuOBf/N1Z3t4xsZ1H4ExexIfpG96xI7wzGghZ5OEbTIk4Gv+mv+UBQ3yEbHChbjXdrhqoQBL9JJb65cJwk1j4eY6u/Yf/QAzF7bBb7xmyCjE4Oq+T1DuIP0HSQlM5adqF8qFxuXIFUzDNulQyRkOW4k3N4wb9vdhBwhmE9VTLUHJKbc0e6z4O3uDcEOAl94ydd6+71x5URM5U5EPzND7e7EowkhpGl0V2eD9pI9Tc6QqKlpC3tAck1GmFbDoo4hDThgc05kobzBLi0UBws9BI95QVyED+taXNbW6Zook+22BgjYkJ95X74Oi+lYZswIsLY/JkmeSNefxkWeF9WtWxiWi2cAANtn3TOM2w+uF9OnI0KbPovDu2BzOMG1wzVSqv8cn3evkE0l5wY8fRDKk6gXWMg48VDwg9HCHRBnM60R/yt8ecuvDEBbX8WrhmEuByjBJPuHLpKIbGc1E8sp9lmDeMbsqrNCBouC1h3T29iJgrj90lTMPqNV4gVFpEkyYXQV0vLVApYQzQlzlMEwqjwEWuOBczI/eBZGMTNN1+iYysPAzc357GJBId5ZJG07/z51B0znG/3j+m4cogX9OgG+Evfm2BEeP7Odyq9BjV0lJJi9oQ1Z4tJFXabmi6IDKFuMDr7pw2KpPWc0KpUeViXNMHSKmtLVoF0yYPnk3UjPsyES7q+dTcH4hdDT94sD0Vp+kZEt5lAl8P5g0AFCYtC3kUrL1HKW1MxnWTZqaJiUyZV0SNjP7gRSxggtT+1fXhoZHkR2ZHRT1XrTWR+3kKKnJASzkP0fhCrIdlyQBo+//pbe0kPNDigNC/Xqon75bC4b+TgbHN4I6zE+E5XmbVS4ap
 gXvzMtNC
 iAl2/xXIXcBcoJFx1kpc0n4+0BWvWeiFXkXbw1AqicDTJAQ7KQ+A8ELXt6pE401M/lp5aT3lGAFd4cgf3JCLJjTMuu8Z7VPSHkU+UrnMQserFCns7/7C5VxSg7PTEw28v9eQpd+WDxFjXEQfsgePMvOBlNE8sJPDTlea6o+7divcX7BYMxCbkGrD2WvwohLX1D722A2SyXPDoePsVECsNaDjeFW+bFXQsgcbdrjgRQn/LXeu+YeykWYf4Zmo6RhP3r8V1p5sNNsKYmzhx9dboZyT6FX92aZxrgHNZmd4k97B3oEndTp4vmNCyonkwL5Q+6eHxFmzgGFypxys+DxXLpLwNXSMvzrCdJWjjJq8ZzBkTL5o0ov9haKyyOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path from the previous patch only accelerates head
pages. Compound tails in memmap_init_compound() still go through the
zone_device_page_init_slow() one by one.

Build separate head and tail templates and reuse one prepared tail
template across the tail pages in a compound range. Head pages preserve
the existing refcount policy, while compound tails always start with a
refcount of 0 after prep_compound_tail().

This extends the template-copy fast path to pfns_per_compound > 1
without changing the existing zone_device_page_init_slow() helper.
Tail-page PFN-dependent fields are refreshed in the reusable tail
template before each copy.

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

This reduces the average memmap initialization time measured during rebind
from 273.31 ms to 244.37 ms, or about 10.6%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index c2645b9bcef3..2668acef4fe6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1074,6 +1074,16 @@ static inline bool zone_device_page_init_optimization_enabled(void)
 	return !page_ref_tracepoint_active(page_ref_set);
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
@@ -1131,10 +1141,12 @@ static void __ref memmap_init_compound(struct page *head,
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
@@ -1143,12 +1155,29 @@ static void __ref memmap_init_compound(struct page *head,
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
+
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		if (!use_template) {
+			zone_device_tail_page_init(page, pfn, zone_idx, nid,
+						   pgmap, head, order);
+		} else if (pfn == head_pfn + 1) {
+			/*
+			 * All tails of the same compound page share the
+			 * state established by prep_compound_tail(). Reuse
+			 * one tail template for the whole range and
+			 * refresh only the PFN-dependent fields in that
+			 * template before each copy.
+			 */
+			zone_device_tail_page_init(page, pfn, zone_idx, nid,
+						   pgmap, head, order);
+			/* init template page */
+			memcpy(&template, page, sizeof(*page));
+		} else {
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		}
 	}
 	prep_compound_head(head, order);
 }
@@ -1210,7 +1239,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap),
+				     use_template);
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
-- 
2.20.1

