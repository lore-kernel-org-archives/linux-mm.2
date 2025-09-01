Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 194E6CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D568E007D; Mon,  1 Sep 2025 11:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E368E0079; Mon,  1 Sep 2025 11:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6128E007D; Mon,  1 Sep 2025 11:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3752D8E0079
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:08:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F290886091
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:08:11 +0000 (UTC)
X-FDA: 83841011982.25.6F49575
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF5231C0015
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:08:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ag2oCQ3P;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739290; a=rsa-sha256;
	cv=none;
	b=Pc8Ns2fr3dM1HX/EXZ2m8Fy9R+AzUSFKffWhdHwQiT32v8lCzq1Z1t/8CbrbKvb3TFr6rZ
	dDCRTtp0B4KVUIwYSJWDSripEfrZR0jIpX/l4K9A9cbNaoiPPdb3y3A4CyNHcKHiJrwcpi
	msGvFozC2nJgGC7aDzx0x/mz3uAQzi4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ag2oCQ3P;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELSebXAokPeuwfrjxvlrywVw1FQ39DJ4AGa2Bi31LpI=;
	b=uGQBjZQlpbqW8KPNmSlyo1UR3mSH+XGaq5wWbYnKKUkTvoYmZnpOAgsw3HoIFN5HYZ2IF4
	sDeWsJFyWe5E4Zis4OpgH73Kuvm7qxoedYKjOOtnWEL6jYT3nbmuDQZVb93OlNZse8bn+x
	LPe6wCiGtO46O+cWWt05Kf+xJHejj0M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELSebXAokPeuwfrjxvlrywVw1FQ39DJ4AGa2Bi31LpI=;
	b=Ag2oCQ3P6jDAplQrcT/FADdei4ekAuv5kXXzOQhnI+twMJ7+eu/TWC2PZBL7FAps7Xe5BU
	rHMDnLv3fNagyDc3gb85mVgsG23Sq/6rD/kteuvHXSgisG5R9AWSrJIW8VHBaQqY74AHlS
	wC+t1hfCKqvlh1ShY51+VokysQ2MPBU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-Hz9nJ24_MAmhMNG_k-jiQA-1; Mon,
 01 Sep 2025 11:08:05 -0400
X-MC-Unique: Hz9nJ24_MAmhMNG_k-jiQA-1
X-Mimecast-MFC-AGG-ID: Hz9nJ24_MAmhMNG_k-jiQA_1756739279
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1600C195609E;
	Mon,  1 Sep 2025 15:07:59 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A66A118003FC;
	Mon,  1 Sep 2025 15:07:44 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 13/37] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
Date: Mon,  1 Sep 2025 17:03:34 +0200
Message-ID: <20250901150359.867252-14-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EF5231C0015
X-Stat-Signature: b1t873gg4peax9kahje6bzazrnajreh9
X-HE-Tag: 1756739289-549497
X-HE-Meta: U2FsdGVkX19uzszVLZLXndf2ITSLmX0e2xMkVqRsNW1s4FBZ4G9r410LdmvBLZvUgXyWL2IUQixl9lBM6/XFlRqBUMiehXGyEgdoskkwDmTpPAdQ8pC6Ydkc7cLM8t9vDy7jQkVbcFZ6upsA9JKvM2Jw9A2GU8DkzFKk2Ykc7U3LIzQD45suhoqlqVs5PVu7Z146ZHNpN89xRt3U5JQQoWj7i2i6MWx5OpTrulBnd6nUeT6uiPGMwPmheDFJAuwfHdRwsQbavhxePLp/KC+UDS7xaGNYDgNg5rgVONuKcFj37W/u18UrnrORsiHbrWuTttL/B9tUjMJ6BcySsUqVCTBu7kP75QIYns7RFUnQBtk/nf743t7lfFpZAHyzuZmBjdrYLe8mMEDDnbOiX1PduRYh6r6YJriN3pflJvCzux3nDCamacjD/1zWjkED3oxls1mlfizp5XwpCFfJmhAgTRvFDAiWNi6m86sVQhxZQrf2epbFhbNGH5eYnTPVjzzWWvXNjTFAj31KWfPBP6s+/vSf1ym36/zsf6WEddXPwrV6k2zWiDavlDVLAD/q29ykTUVSe2DBpB/VksUPioDk/V+dfvd+WIV3UnwAnYKrMMEN63h7catq3k5Osf6W+M7PBcxNklH1ZJpICECDPQz4mWUaIB6BWLgI6ztY1rTX7IGgCAwzCj2nNHK1Ac8ZzZDDVIO4TUQeK4BMx+Idr3OYHyqz/CsPCneZH5f0WFfiS2DLspvJNz8TMjIQTGXP7DP16ekvtLFdyhIzbuSQNGsy9RTmwrB1mIt3oF71n7vRBQdBu/R64Y1uXDv+xPSDw2UvO5PTDQKF3tou+2id6kKdmoz8EWBtd6XKKV0s2Wad4iZOG0Kt0b54GFrU8WUbBfQgHJ+bl5s3GHgJZ7ftZZyDztQqt55rWmSVzWhHMdsknCSTALOWzsRCL394BEhXce0uyMB2/we2sJnv1rf9Kq8
 iVQW5oGa
 3u93Xn6BrWXJn8hy6kJd+QeZAoWPbRnmadOCJduyU6kmdrAkH0JeFuSqLlZo8VHz7jJrfzdYDPZ+BBEE0Tdhy6hqqHpoZy1g/pHAYb/eqqcyq9MH6fqvMzn0qQLB1h32kbCUByeM0MsWFMNpdiHAc/vrzlIgaDINw4T8A4k+lC3lrkxVz4dxZKhS1Rt2JmAbn9O/g5tyNJv771fY9qhyCUp8AUxR1z0TvSL4kUGZrYtByklUWxR2kCXlxfXFNoz8krsAS9jdVw5TNIICyYPHTC1qHqCA2GdOkOg5m1X1Nyr7rFpKXgH71Vk5TiPV4rb2z76c4qsAKVcehVbwTjHfc4zo8vTmkL2cmDNL9wysi9VLnk+CvIoBiNydlFNTcEcRoFcbt6DbwIphWF/3V81/alcVjQEsJmu8NrlqfXG+bXFGoJGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can now safely iterate over all pages in a folio, so no need for the
pfn_to_page().

Also, as we already force the refcount in __init_single_page() to 1
through init_page_count(), we can just set the refcount to 0 and
avoid page_ref_freeze() + VM_BUG_ON. Likely, in the future, we would just
want to tell __init_single_page() to which value to initialize the
refcount.

Further, adjust the comments to highlight that we are dealing with an
open-coded prep_compound_page() variant, and add another comment explaining
why we really need the __init_single_page() only on the tail pages.

Note that the current code was likely problematic, but we never ran into
it: prep_compound_tail() would have been called with an offset that might
exceed a memory section, and prep_compound_tail() would have simply
added that offset to the page pointer -- which would not have done the
right thing on sparsemem without vmemmap.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d3542e92a712e..56e6d2af08434 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 {
 	enum zone_type zone = zone_idx(folio_zone(folio));
 	int nid = folio_nid(folio);
+	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	int ret;
-
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
-		struct page *page = pfn_to_page(pfn);
 
+	/*
+	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
+	 * we must initialize them ourselves here.
+	 */
+	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
 		prep_compound_tail((struct page *)folio, pfn - head_pfn);
-		ret = page_ref_freeze(page, 1);
-		VM_BUG_ON(!ret);
+		set_page_count(page, 0);
 	}
 }
 
@@ -3257,12 +3258,15 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 {
 	int ret;
 
-	/* Prepare folio head */
+	/*
+	 * This is an open-coded prep_compound_page() whereby we avoid
+	 * walking pages twice by initializing/preparing+freezing them in the
+	 * same go.
+	 */
 	__folio_clear_reserved(folio);
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	/* Initialize the necessary tail struct pages */
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
-- 
2.50.1


