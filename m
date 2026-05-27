Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CD1CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E13E6B0095; Tue, 26 May 2026 23:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1923A6B0096; Tue, 26 May 2026 23:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF546B0098; Tue, 26 May 2026 23:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFB2C6B0095
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:39:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B53D161882
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:39:58 +0000 (UTC)
X-FDA: 84811796076.25.F930BAE
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD444C0002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:39:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VDBRTUy6;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFCgbSTStAjZ31U1E/z3VlWcowp913bpgnmrB6tBGlA=;
	b=LxNcdfivQINMW1ABXIU8Ck7Z6336F8nrg65h3CWL9kMYUG/N4wAWN+5+BaVbcWLKr4FfgB
	H9XTvP8UomXdZBJbTjrGfeAZkJAKYFbMG0oquqoZfTShToVRawniS9/gPtY82NrWtZDO19
	SyoqHy58HEu8/mb+Y2SDY1MG2BQE35U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VDBRTUy6;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853196; a=rsa-sha256;
	cv=none;
	b=K+APu+8z+9gdVzNXvK2JMyS0dcDYqAy8O5Ujidco1r+gADUeccJ5WQH6tNeZFkBgC2QIlB
	VFQPfICU764ciK0n4hVbpyLQQuKNl+ycka4ApTR+YoNdl+Sj9B/tVhrPxpIYxXvbFRfFO4
	EiH5AEfoBXgc5bqpsAgJexNlth3xku8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853192; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=qFCgbSTStAjZ31U1E/z3VlWcowp913bpgnmrB6tBGlA=;
 b=VDBRTUy6wTeRvedsk63DIVKDHdV91v5VfNxab6UMk/we/EWYeA9cDX9OvInP4kxIDXqock
 kdVqQ77BZzfG/PoVSNxWUMByu9yDsJXWu/C8yAQ8q0fJN6wXXj/ldsW/xGcZCxytMQq/ij
 RFlA9L6zsT5EjamwCwiURQpmJM3zkg2EhB6MZw+MoJ0Y/kVg875aHrYSm08Vy6lDUn+wrj
 WFOg2YhrPKvXmlPpaX9qAfS/FAbKpa/Xxzk0EKrxxAy1nxKmkyySwkjH4K4iNxxd9MIX4E
 s6O5zYuhHK3dZqInhXINxZI5NfjRuwTOFPNhfCRV7sUI7YKYFZNx27hgzOaX9w==
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a166786+cf5a33+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Message-Id: <20260527033636.28231-6-lizhe.67@bytedance.com>
Subject: [PATCH v3 5/8] mm: extend the template fast path to zone-device compound tails
Date: Wed, 27 May 2026 11:36:33 +0800
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD444C0002
X-Stat-Signature: e4qiewktyfqcdanfi5n8w6px9ihbohky
X-HE-Tag: 1779853196-331256
X-HE-Meta: U2FsdGVkX1/nW/Qaer6mPpkfzDkfjKVQFkOiiEUgZ8tiXpWieBKQT8gnu5zDbk64CjqQobO0AB2r6QH3yJFdHwKNJ7PvQk3qp50nya8flyujKE5caEiRYHBVaD1LQSrQn0RbbWTYgmq1Q4AU0fzB/VT8WqusTadPY0yAwTw+iijUY+coGTIIbVpj45R5gDQpRRflPKGA02eitWh2oRReZipL2gQOCmHq4yYevETzEn6CVEc4joH5fnZh9m23oW8622ZMABp1sWQbr5/N4It9OEoJa+dn3ZHc04vMub7DdVBGKtpYu8y7vczo5BbZTNPuJi8XIA4QOouisE8HtvKCMVlsV5wacihYPnNcB3dAVp1eS8DzutYNJcgdQylxMvuww3nKRkj4Au2G2S/R3irbV4Ig5vf0r+1gyssl/5AZgRDuYtWcyFsRuMm+P2Anf1NfgZFbS3nv45YQehlJEwlF0hSem28ik9DnmloZoUUecWEcqCnt3Iw8fquT2hsOpB6wsbeuhczyahqgt/23C1Jfbr7pyMhNUgdibwX+8YSaCCNgznT3cKmgoIUMc5wyLe/wlfx3b2DO8f5kn6tRt7Xzq0F47zC3smq4fl0sAaSKjnyvtsa3MOWnevnSR+cnFhRzUioDj/MwZMeFklQJcDhKpApxpKL/1SojbYaMaRN5xsBftUmBCDl3v6y4sk6UFV+WSAz2HOO3MAtNEVo1UqvUlqwYRuPQpV/F8R20ThwZ4sCAcUbS6NgXGaO3pSAxfCbs3UIEqDlgfpTDwpieV4JgvKj0oI0Y+ZSwmG/7MXy8fi/5C4siNzfNmvBdyQvLFOGpVAhJDmhvisu/yYCK5pTV3UE67a9hzBHxKP9BPlhC+8NpQJFCdgO77bDi8ihmYa4OaK26XNFNlF4252TALFQX5ZXxcMkh1GPgCBGm7iOKC/ZINmaamm3NuA2CjZJak7uqK7ewrYOVJGRQr7Aao+Z
 VaznTbBQ
 ZCmQPYH/imCJCfQDFmMLnPHCd4Qwgv3EbvxRvr0LlguvleOJWoRlGrUnvjRtVAchr6WVPEAyGBfUA01VCXSFChA8hNm+sk8Az8AhiK7D88g++PGtiEoBwphMAlPi/dFXEBpP01DYi2jjrOrrfzpfK5N7dNZwtkTH8g9EFZ+BVYCjpkGA5X1+0XGxjj+pQEhe5isppfIciQ6RiWQfiOust4ThctBXnsXNBT7qRQ6pFFKgwZ5gBV6YQsgBoo6Q/VGZK/Tit48gsVYHSf/ABDlOeb22TLQ==
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

Base(v7.1-rc3):
  First binding: 1515 ms
  Average of subsequent rebinds: 313.45 ms

With this patch and its prerequisites applied:
  First binding: 1422 ms
  Average of subsequent rebinds: 240.42 ms

This reduces the average rebind time from 313.45 ms to 240.42 ms, or
about 23.3%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 53c0241c66b7..d5ccb49a048f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1077,17 +1077,25 @@ static inline bool zone_device_page_init_optimization_enabled(void)
 	return !page_ref_tracepoint_active(page_ref_set);
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
 	if (!pagemap_resets_refcount(pgmap))
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
  * 'template' is a reusable page prototype rather than a strictly immutable
  * object. Most ZONE_DEVICE fields stay constant across the pages covered by
@@ -1139,10 +1147,12 @@ static void __ref memmap_init_compound(struct page *head,
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
@@ -1151,9 +1161,25 @@ static void __ref memmap_init_compound(struct page *head,
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
+
+	/*
+	 * All tails of the same compound page share the state established by
+	 * prep_compound_tail(). Reuse one tail template for the whole range and
+	 * refresh only the PFN-dependent fields in that template before each copy.
+	 */
+	if (use_template)
+		zone_device_template_tail_page_init(&template, head_pfn + 1,
+						    zone_idx, nid, pgmap,
+						    head, order);
+
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
+		if (use_template) {
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+			continue;
+		}
 		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
@@ -1190,8 +1216,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	}
 
 	if (use_template)
-		zone_device_template_page_init(&template, start_pfn, zone_idx,
-					       nid, pgmap);
+		zone_device_template_head_page_init(&template, start_pfn,
+						    zone_idx, nid, pgmap);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
@@ -1207,7 +1233,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(altmap, pgmap),
+				     use_template);
 	}
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
-- 
2.20.1

