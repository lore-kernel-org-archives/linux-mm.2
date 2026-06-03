Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51DDECD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEFF06B008C; Wed,  3 Jun 2026 04:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0676B0095; Wed,  3 Jun 2026 04:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD7D6B0099; Wed,  3 Jun 2026 04:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90C776B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:06:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 211801401B7
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:06:31 +0000 (UTC)
X-FDA: 84837869382.25.28F690E
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf19.hostedemail.com (Postfix) with ESMTP id 715341A0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:06:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="CkDYJ4X/";
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+pxu4QONrexAlpcc34zjw3GPn7T+Jri0V38RE3OFI0=;
	b=cOgkREG9JGb0gAz7EFk8eLvJpnUJKABPa3mCB9vlA9e9JgzO3kODsc1UuYDlGTmk6ezFTq
	dg7kiAQYjLZwFYupx89VDNdivKO3kAsrbkenz2pOpchU3j1++6mgeP16fWRBxbuEBOsXkn
	U8z+LK6Am4Fyi8osX1m+/RSWiTD7oOk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="CkDYJ4X/";
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473989;
	b=L41esz5NCCkMrNellv1goV1fggTcqzseJ3cf7m52Ab1F4aj0vnzwUwMIRmPHDGsmDON8yA
	gbdcaTqFnBliSFdhvnTqX1xBPF0pR8KhiIKQs57pPSWmBE8MINU+iLnPGCMoETMYTmov1m
	xo4Gt8KID2S/mSIoL5aWKv/tLNPn1UQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780473984; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0+pxu4QONrexAlpcc34zjw3GPn7T+Jri0V38RE3OFI0=;
 b=CkDYJ4X/V8qxLlchNcKL8fTOAaZ4SJAT0AeDzNjKgbuv+HwOZ6ihzOAovB0owB1QkxfNZ9
 tVTJ+gDHEMddKMXnFvr5PEdiSqviN+/Qwp92BzlD+geecV13gUF6GXs8PxomqT5Q6FmIuH
 8lhCJBHPh8aiUP74KkseSaQNWo6YD9dSLRfcPyIA/utuGYqg289KZym8pAExSH7WA3Kpmg
 RNr28bCo97u9isEoHZKdEhQkuY5IZ0xppZ9IarAIspLg6VDJGPnSsj69S2A7zTmJ8mdkuH
 JDWLImM+rCaaHlxbRn44RN2opAML2ZrfR1DoqyebT6FMrVkZdFhNcXZo3owtlQ==
Date: Wed,  3 Jun 2026 16:01:49 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v4 5/8] mm: extend the template fast path to zone-device compound tails
X-Lms-Return-Path: <lba+26a1fe07e+398489+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260603080152.64728-6-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 715341A0005
X-Stat-Signature: 45r8p1xo41og6pbaa4df3jhkh9bdgmae
X-Rspam-User: 
X-HE-Tag: 1780473989-689579
X-HE-Meta: U2FsdGVkX1/ZxqqDLQ2qXCRmYzVCbsdit8etFpNZPRjricAE6wIcq0WJrMN59dQmgr2Tyhe7stbQYc9IK7kFUq9Azzh4mt4+t5+biobc3jvUgiQ2HPTkr+vtVtKqgmm670MMeWS6NoEHxR5GM51gOs8AdE9KCyjfIqpo/odY+QXkmA7d9/5iqstR1J3Ffkd1MgVVDU62hJGdWKbvMJKAiDo9hps3bEWlshncddujt/a7GuX8G1omGXgIeHEdqe/gJc8j0nHU4gvLfFwIttetfjszTx9DjYpOJtMS0f+9V3UCitQiom/l1o2Xc9br0G3pfp+VkmAoNvtTxrPSFA2rcRz1Wxun+NxZYCv2Smv83NLTxdvZHgvEM2mOhu7bNVkRvznJzcaWZVqjOfk4fl5ZDvj7fo+rqTv3GOmfBc5NyZtB6AgbJEj+4J9jIXDCDHXbS8G32Vc+xfvMdFGOA2BwNC8wpmNlo2ymqQ41VhT4wrsQ/qai4ZHJV2wlnTlDZidgi2PrAc3r3cjNZwgpyGduPbortWb+WpWaPDfZ1n7ok5PkgmAYQfST7mX4wUVyVn0HANZEEUyo9+BYQgv8ndz5sHYiju3tndfDUdY5bsdx59YVQWHahJhy6gfiNCfE2wFFyeGNuWTO68jWPraC68T8ijmgM2q2AcqckZZp7XejJKIxw4omYHGtXgLoy4D7N+ZVusBTL2C37446wyb/PChz8PDR3/Hy/ncIQAw3ZOSsKSZu2tVKBsMwwF4/h3OCwUAiYvfXpnNiUei+O3tr7Xdsu6WHecUkz/W5QyIgcdLgkSEiZJcXWkKFu9yprPwzKzSjEpWDI8psdPS2FK/rwgDIsjJ4sHL0b9VxYHgBliE+4ZFUo9BF9X5xbZ1A/epbxCUqXxQEa7PpBPVmicNcWST0CUBm6cP22mcosSRbOIqmUyshpc6mQDJskrKv2pWanQ2MXXC4wPQgNR0pz4MJBPi
 RxLYTNbh
 KgNoNQOmww/8gPuMwyJ9t3A1AiwU2FB7PWa3JVJBTRS8+7yLAUVu4ieSLC7TPzyZhgzV+ivbkcWxIJBWkD1hE4HPMcmH/ii76Aq36pRXd+hjwceFuoPkwhy2os08Pg+lgUWgZthhDuxHw+WpXoaQylXn9Tf1IFaFdTWC5cRq2md37ucEKR1g4zmjq6JRe3lPUiltB1SSj3QNotwmERXlapoP7rm1v0NZ0zxJdvPk04xAPzb5XRbncLQGO3YjDnOLyiyWe
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

Base(v7.1-rc6):
  First binding: 1430 ms
  Average of subsequent rebinds: 229.12 ms

With this patch and its prerequisites applied:
  First binding: 1336 ms
  Average of subsequent rebinds: 180.00 ms

This reduces the average rebind time from 229.12 ms to 180.00 ms, or
about 21.4%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 56fe71e966ae..ad078ee354fb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1083,6 +1083,16 @@ static inline void zone_device_template_page_init(struct page *template,
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
@@ -1134,10 +1144,12 @@ static void __ref memmap_init_compound(struct page *head,
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
@@ -1146,12 +1158,31 @@ static void __ref memmap_init_compound(struct page *head,
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
@@ -1200,7 +1231,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		zone_device_template_page_init(&template, page);
 		if (pfns_per_compound != 1)
 			memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-					     compound_nr_pages(altmap, pgmap));
+				compound_nr_pages(altmap, pgmap), use_template);
 		pfn += pfns_per_compound;
 	}
 
@@ -1218,7 +1249,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(altmap, pgmap),
+				     use_template);
 	}
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
-- 
2.20.1

