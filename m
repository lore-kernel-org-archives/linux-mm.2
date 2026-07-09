Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D605BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E4C6B0098; Thu,  9 Jul 2026 07:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE806B0099; Thu,  9 Jul 2026 07:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CF66B009B; Thu,  9 Jul 2026 07:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B51CB6B0098
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:27:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AF75A0100
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:27:42 +0000 (UTC)
X-FDA: 84969013164.06.089905D
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5DE3C180004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:27:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BYvV94v0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkruUotUpYotmWNBhi+IQ/cN55rHKdD+MW/eLLud6s4=;
	b=bv2MQyVtoZ21A166RhGJhKpxFpGoXhIosvQ+VMilVoiUXxK/Nls4yfOBKXGOfCMk+K6OVw
	afyTVa6Lv+W0nf/lSU4kUoePqFkPrRF61YwK0d9Pde2mAC1AokqEqF4cPidXiQX88jjjV0
	Zo/ZJzBjssbkMgvyJfpn+uGwK276ujA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BYvV94v0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596460;
	b=JnS59ufoQige1aXbdLtgaeYWIjKBBfZZH9GGXbS8OOWuGdmG4ZT0+0D1X3r5PhZbb8Mn+V
	FwUkMfkE7tBq6DhzJ5AiTvPGtUHmk13Hf4wv2QYLTQVGjpT4GUsqXPiEnjHFMjSgqVHgZq
	W30d2bnBxH5PR1h9ZdkOuRnA6rDBDCI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596455; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=VkruUotUpYotmWNBhi+IQ/cN55rHKdD+MW/eLLud6s4=;
 b=BYvV94v0JMmP+yNdPSONAEcCZASSt84hTUZ0gNRx3Cn4P+bdR7AsTkLjyPqQKiDlsMB1xj
 DRC07PyRFdwBh6Q4OQWBSYSDYfEMInXPkEwOVQ6aH9K1XYfuI+1SSWWZgCfc9tfXQqLhVE
 BcFWxYPcWxYahJCLXQBBf7aA/W8USz8qKLKjcbyROdoSkvc5wimnaSsehy+Ed1KNHexyUO
 k2oFHFfPUF3XQMZxmMR/A4ykceSF8lxkq168be0H2qzWifh8+HH3u9m3E736JWQ5DscVYz
 /qcGczTZS4ZphCJbQY6fPLlMhi4d3zclxQ6CCmiIYNswnve4SAw+nYenOnHd1w==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v6 5/8] mm: extend the template fast path to zone-device compound tails
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260709112520.24857-1-lizhe.67@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
X-Lms-Return-Path: <lba+26a4f85a5+dfb477+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
Date: Thu,  9 Jul 2026 19:25:17 +0800
Message-Id: <20260709112520.24857-6-lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DE3C180004
X-Stat-Signature: n8i95noobdowb96niciw5wdmmgkdk95m
X-Rspam-User: 
X-HE-Tag: 1783596460-202651
X-HE-Meta: U2FsdGVkX1+C/EisDtMiaH0VKBJLrpfXyvylzKnw05DHZ+tSuzve6DJ4Y4nYmWOGRPOPG0HwB6BZjCQHX+llv8P0pWJISoQRdORxmNNTD7jARFUJZtxPXtivYMOrJSA8kM3odXDaGcGFb/q7Jqy6IIsmjIg+wZkPIVJOtwmE/OaAy/smWvOsHug1t73MXW8ekKLUM/Ght2IBKVXJWTxBHpvnuw41qMPSeXeIm0y7m5hmW8KI4/HA5RlpeTx6iym6MlMgZSFzvU7S7K3TuMhsa7or/6u+RFSgem1Xku0T96GbLR5EwbyD+qr25nU22+ZFY6IhEpH11XTjWLFn6YgaXMvqLoV/BWAS3UN/sdjxf7oY2u2vfqJYoIMs9nweRr0mEFuj5Ys0eIwb8c5NELa69pIM6L1slyvqXoCg1O89AiK9Dk8mfoKm61Cd8fgQxoEu6C0hkoCa6QAazBHxL22OdlGivz1u9ydOj4QTNw0Jc/BvF+HLA2CwxHNPFNK6Xbq70jfADmy6J7WQyBzDPYRqdz2nRiOn//6eQ8YJ/hDKwv+HG2h3AAAVXnK4WRK1NdOyq5UpQXsa6/KQl3gCLVjBWnaxkrM8kjbXG20Su1H+QOYr8HyAgkvZO4aw3E76gkVF2R1X46W1rqMA2MltxM9SM3jyNG2tVx5n9m06553pJ1bE5w+1ol8q49C4vzRQOLxWK68bTrUK4shvjvxjbDx3gHLCCDeJhXoJrjToBwDHO33M/N9H7mhN0yLIYCq7h/6dWWj2eKo7yAWjZq2r3cKa8wGMwHRP6+IabXotCFUlk3GCiOyynhuBB6VEWXOJbSr/Yvwl61cm3sXefLa/k8RtXhVTJlfsMExxo8C6W4QqnU1edrOI82ajVWsI1aghEq2mqr7mtVtjr7FvLmqIOUxee+rZ1KAVYdCAyjH3qiX6zKxDNcK/RDVVtJ6Z++YmcDihK2PBbwH8tReTP/n8m0n
 7wD0Y0Wn
 PIhXEoGF/Nxpfv+HoU3mZLMXftOsqAORcW0Cgsy2zpezwJdtXjfsnU6cMmoG7LTjrBEGDEndg9OwhgM5FCn7bMmF5W2SipofA/oZchlEcDnkaFMoHaW2tvAdueAgGHOPkOIMmB8JL213LsIlRLV8Cqixp+szjDjvtAp35+yE5t2XivcNW2pzuG3P8b7p66feeu9F+fuDgbk8bMa68y+IvwHydNHiku3ehQRDtRA/8AAF/taRFlSx0sAh+6jmtJLTFOJTR
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
 mm/mm_init.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 170021e182e0..fb855bb0437a 100644
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

