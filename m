Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 386CCC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC646B00B0; Mon, 20 Jul 2026 08:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3843B6B00B1; Mon, 20 Jul 2026 08:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C05B6B00B2; Mon, 20 Jul 2026 08:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0CDF6B00B0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:06:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88A6EA015A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:06:45 +0000 (UTC)
X-FDA: 85009028370.11.50C2CE9
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf22.hostedemail.com (Postfix) with ESMTP id C82E2C0005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:06:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EmVRSfU3;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxmgrDMAVpE6lcX28qNeYhL42ykWrhIjdDLod/Kz2Jg=;
	b=OHZNcc+ci4Rc7UVdJwNnvhvXJuwKqnlpXI/4oTVtOCb6/nwG9k7GTDbJ0bGiQDQJxMsrMU
	fO1bqLzxZ39kU2bToiqS4+p3X/p9TRD1BZ+n5162jmh7aBTLmIXP/qb0yUmuxoQ/Lb+l5X
	b3FSVcv4cggsUB4lUHWaCkJyFNrCUbs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549203;
	b=BmQO/yWtm/7V19nRZArgWmwSrJ7BnD/g3UsbNcHt+P3xChca76xOPr2kco6BxX/u7tra8D
	dKbjlRL8jAfHtNRwveSsSF+BulpSWT44fcacFzBUA9xPFXBx8eGhi2CBCkI+aWCP9iJbLD
	k++xOSj0KG9ol3S7LQa8FLc8ptALLHQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EmVRSfU3;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549198; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jxmgrDMAVpE6lcX28qNeYhL42ykWrhIjdDLod/Kz2Jg=;
 b=EmVRSfU3v31CQbYY/+rjRmt8s+ij584q4javaeE/ysNOMme5O0J/tB/pqT/xsML1+mcrbc
 577PUoH1joOV7Yc3tkhN2zTTEetqpZ6oLISrxKQ9HgAP5t7yBBdPkdmqJDAYFGcyc6M7UV
 W7d5e/zrsc8y8/CtB04WnRFG1/tl4eVMcxv4Q0G9nQscoCPIM8qP/6qZ1rtGYrRnus2BEx
 SUJolg4B6Oj0poeLoYdIaQQ9Ii/kbBC1gGm9PCZrHXeDsy2CBqYKDgtvV8blCixs6lq6p8
 +ZyUF/PEsJdRdR+b8+zweD6j/lZqqHUJ5FNEHAmhsaPkE7g75F3homnFf1iqtQ==
Date: Mon, 20 Jul 2026 20:02:55 +0800
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
Subject: [PATCH v7 5/9] mm: extend the template fast path to zone-device compound tails
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a5e0f4c+cd2a3e+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260720120259.1545-7-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: C82E2C0005
X-Stat-Signature: opswuwmnst1fkr5u3d58izr8hu8qm8xm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784549203-32208
X-HE-Meta: U2FsdGVkX1+1agZh745Aj/+1q93r841DgYEYwIBXc7YGUFWt9GG86XPaQufskw1Fq0H09M40N++AOBlFAuo4bFWzom4+C4jJUCY/HKz0IAy7bYvIIIc7lvzVKopBo3e4R/xUhDEWxFOMa8H/mM1D4+Xsn/kzsDxVuDHA9cHry/6MKWnvtXRvjSiclAitzaks0sFv0A5tSGo4lQQ+ThHkDK9LK48I5/i/WgqndzpLSN7Cze5ZDClqTNsHga0Y+QnUUWkqM0+7bT6P894bO8pMXIvR9xj3QSA7bk/6C243wqvLK6fmruJ41aWvan50nU1cqvLOXk4zm67SDUmzbcAWUshuuQ6eIac/uXMo1rXEBf0aRCO8k1yHntKvGF7iHteeDZ3unirZ73V7eqV7oCWqkI7ho/F3h0LlqFQSVCVLPsxoKPAzExIt+mkHHKZCp0nSptd2q6nkwA0pDjNf298LKo5hPhZDVpgeyGp2hpWZz5NRq6ln6xNKykB6kjX/81OCbXcfsbIebx3fdl6M7wbJ8GgoQhnx2n/Hrgc26u38dDMQZNQBlmq7fNgVngfV+OydITMcApuBHdpAIqTRlXW+spGRO6f3VmrCVq8OW0+eF3TcH0gS6eRGAzLG1U0YLf5YVafxWHZVG+0dNnxWerW2o5plBdnO4vPPgoHs5SF3i4VSyhgEG5/NOuQrZ6BmShxx/9+gBi9Kby8zKwe7AErKFCM4xmXSi1n3Rwdbmo+ilz+p3jcfhNas5I57ho2tTNr+T2tIpPmIVcB2uko5HqEYNQJZqjLsjv3oMtVGryDWunqcftwBLoFXEXEd+gQpilqYEwovzHYGwQ9bUYItkUX5RGqKNYltlVmuP6xwNec7Q5iL2E7/Q7vD14jDBux9+F+jE3Hvc/ZE8SPsVpwrZqxgSMnXPzixXkfh5kvr0KLowiUMuSiovordjkhsaI0bSPt8HHXy5xxv3NTeZNzB0ZZ
 lyhlpO6x
 dFHp14IXY8N09defnwrpAvhXDifgQF9ttngPKf1OoKlac8ktwVZhPojy0t9sAqdyE3Y2LGb5/DyZ7P1FEr4zJpsS1LlEgStYbrssY4FaOWG9/qNoadWhhEt36Vq1xzD9dzr/oclPWn730lfpRZAQAlmiUQc3Aa+0JIIhfF3IwLHbj/PYEEeNGPvTuxB5PTGmo2Z9I2wLhupGPEv9QmkPxTBlnbrSnVOIPVjDY16c49Jv8ApCMuBnVK2qPaWwOGy/zZX3O
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

