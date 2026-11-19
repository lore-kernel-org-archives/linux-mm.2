Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E859606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 23:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O073Ola0
Received: by kanga.kvack.org (Postfix)
	id 3C4D36B06E0; Thu, 19 Nov 2026 18:31:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374BB6B0700; Thu, 19 Nov 2026 18:31:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263FD6B0702; Thu, 19 Nov 2026 18:31:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E605F6B06E0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:31:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73339A84BE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:31:28 +0000 (UTC)
X-FDA: 85453467456.16.911A927
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id C403240005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:31:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O073Ola0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3zIb_agoKCDcgbeTroTblaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--nilayvaish.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3zIb_agoKCDcgbeTroTblaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--nilayvaish.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795131086;
	b=qOQXsjJkN4w//zyGptRXkryRJ8IKPerC/XAvZ9lRRJn6xtSX90mSk0wfI5p963bFxOVzkE
	bsZGpv548ORysop8viy7WHVebFKjsH2MWCJJ06aFpu3U6OkVc3LAFVkQ563SUIep9ZjnMW
	6K0LuHPmnUhveFeO0qFG5TY++JaBz+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795131086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Aem+HyjchlD9dlMnLoX3Rsa3iep8drYmdRID51i88Fc=;
	b=Iq3bqQTDgECuiAc+FMnQZsewZVpzAOqFQSlI6J5dF/xWcYuj8ex4vLBq/D5yFHRtFqwOQ8
	Tf8H9htDpoCm+FQiFuBSIo6HmeVkZWk0xbLGoXnU6O/Dn+PnQwi0bKDkqhfg3Wa+xgKBZl
	BDb3rfVxAOR4IB0oMHtpYYZp//0qoLA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O073Ola0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3zIb_agoKCDcgbeTroTblaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--nilayvaish.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3zIb_agoKCDcgbeTroTblaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--nilayvaish.bounces.google.com
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1b3a348a6dbso562289c88.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795131085; x=1795735885; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Aem+HyjchlD9dlMnLoX3Rsa3iep8drYmdRID51i88Fc=;
        b=O073Ola0kgxmRXxIEgUK+Cp6sX9XuHBd2QtGkgLKwbE8x2hnUcbkznT9Gw8KqXroKV
         WQM3pkeWT4e34tT1WDF8f2clzWplg+ClrQo4/MieIiad8Bw00Ga31DMna4Ude3LX/8NM
         s781qnmTJ304Hsgwjx8oyhXbDZ7rit/AtXsIgx0CaiFgNttKGPARE2GhBor4/zBehm5w
         UJ13JFsxxdJYDbNwCBfy5fUwf6kJqOqG4PQTwCdl897gD5wIptfYO+0RTaNfyI51vsuR
         ul0m1xDh8+9QK2alb9XVP4CaZbMXINnTZFpkIFiphA2MUleYCNxMzfZ3mmOePgpMw4qK
         ipuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795131085; x=1795735885;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Aem+HyjchlD9dlMnLoX3Rsa3iep8drYmdRID51i88Fc=;
        b=nZ3mlq3iI08NjYcM2jDCy9dq73e+HmtBJFgoCaKc3BFu+OFYui5SmlNTsN7jryL03T
         e44wu0ia2YtnYThkiMPqiTRQFTL4Zgxb0hcHqfeDVIfQ3sjBjDgWrk8LtwfM461lyLFT
         qjLkaboZKX7KMs3nDzMlLvuc4Nk6XkFZeaqLmeEGEu/z7m85+HS+XxiDiDK/zuEHRVcX
         UFIgk4zMWcFhMAboCK1fRJoRDwP07+XP/oZiOQOxKKu1iWC0pkdzVPveUoQ47mkQMKpF
         jFTWFPMaZD4ZsEPmNRWTj76W1Yc5nzP71fXWpYoqnP2c7mxevMQk/yUYtoYSWkPeEAb0
         ywTA==
X-Forwarded-Encrypted: i=1; AL+hErGjJKuC4+JQb4mI4CBA06H/g/qptm8zR2z7Vp5VQh8yPOlQzkPqD/GAfUVmbj3Q13htpMkfJY5JQA==@kvack.org
X-Gm-Message-State: APuU4Z8GgAkSJ4bD5sOQRiSwpHf+dcH/EdiODbbVSHE2XtChrhxpuBNY
	nH+ngpQPl8YizjgXTfxs1HAR06q/IqOO2tbEvnaENKnoVIjNC1W1WT+PgCfX1TZuyWUmy7ixzS5
	p3PE6y31uF4A3I4YbsE/sSw==
X-Received: from dldyq15-n1.prod.google.com ([2002:a05:701b:454f:10b0:1b5:1d0c:b35a])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:2806:b0:1a4:c892:b130 with SMTP id a92af1059eb24-1b5568bbebcmr918980c88.15.1795131084783;
 Thu, 19 Nov 2026 15:31:24 -0800 (PST)
Date: Thu, 19 Nov 2026 15:31:19 -0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261119233119.1721789-1-nilayvaish@google.com>
Subject: [PATCH v2] lib/test_hmm: fix alloc tag leak when splitting
 device-private folios
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbirs@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, Zenghui Yu <zenghui.yu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
	Zi Yan <ziy@nvidia.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C403240005
X-Stat-Signature: eeu3rg4oggudno3wqbxr4ty8kum4fp5r
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795131086-575329
X-HE-Meta: U2FsdGVkX1+UKKul/u64ExASd4SMcvA6h2tGnaB9nHQT/u5TXAf9vWIz+OSjm2db5Kh0VkhEZ612fsbKDfVhHvYbQck5LDviQ1v7baDr+IwNXwgXngv1/9s+/8+/F/PeipRmI8JMXxzFwUVbRuB91SyWlFoHP9QGtEecjnGNXtzfwa8wNbRibZi1SiwyrO/U5Od0cyIwq5MUajHshdB8cjkBHU7XKxDtJost9vK55QFOgXpByDDSXj6CTmSMXJj93cU/GhGi/xN+UJWoH3LU3Mr5ja43tQwg5QINH44FqghCBVJIZxBoYyx1i6ZbVBEBAZdqjvIJPV8qf66JL0CcQEw31CbjxDIrim6IaHmTtlDC8Y7t/FaKjYwS9C542RcvoZmsO1WdpsM+qV3+9uCPxRFVAY3NGIeRS/iGKt8bMMAhmc79RPhKTCtAbq5oyFi7uBDbghxcAfrrUCMI04kA2v+k3f72U6mOuXsqd7O1jIer3hedo+itIN7bffH95TuAaPo9joajLWyIwWYtfuc3xnziuaJE47D8mlMb1pjUV+WhgUr/gqLJpFTRII0V3m3KK+Tsp+lo9nwZwYqH5SfBjmrKeXb52t5pvU9Gcr7ijhkStCwpXdWGivY3Z9j2A7SvENhJ0d5WGciU1EdkVEh1GJrLqGYJFPc6SrM+9cgFmQd2mAo1N01+IPrXKP9+xQzVCb18dkm0+FJqhBWDOD8Zf/p064AKiv8uYa2wdg09vShrpAHBBEEa+eHgpzJ29XrRCEYXUad8ezBLMDaM/5JK2ByW7WUz241MShHhltXYHNexOkIyKQDyw5iTCulm7VJnnRsgXxrTVRJryZH12iTeL1/c8p2hQMlMO9U+C5b0O6wShlDu8O29e9HQn+vZjH8KmrnJ4IKLwr6rDSLTj7x9P6hdAQu1PyoJJuzTHSeDCBwmfFhlGBzLSkiHei2Hf/fXUzMf6nDfFpFlNav8R3s
 8ipMWtn6
 glEP6orIkcX38ujeLOItD5W65o9G9/3M7k8zWbcRdvA90EWx3lFmHUGJ5oqX8qvduBIv9tJMzqmRo/tg/M/7mveiz3rZ163op3OdwjajYu7be65S3+WSHwfE2EhTba396bKfpol7n2FKr8W1UU+hlROZo5JsKBHyX80OOYeKiQm39O8XqXdVgr2hxkyQEkxRVQ9r8VqsDSwMm4Af/iONk5mU9R0Hp/CRQyc4HH6I3SQih564P3KoF4cvpLI3emQdL+ldBmKoE4+xRnhLa484ljLpnqbELZXpFkA7Ta8D1Dg91f6M0rxVN906Vw/nuU1qjRF8inNQM4Bphbfns49/ut3x7Egj4q/b6YkdSgQjKQGGT8mCIgJz2LjJFk+1WLpn9xdtAPcNq/gSdYqYpnLq9Yo4ovlis1d/ZXkhKyVBeergORAUm6En9VuUcwyYXV3KB9cyFc6Bmu3FKScCn66yojtG1t1/Qz3LbHVZ+t4IKq1ZAhYxxtEvpaj0SZUqmE0jn3gmr4E5DxyChqZsIfY6Qxd2Pg1CxpyvA9OPZ922YPAyC284jjVpMZ7rvF6D0bF7+9rzF6zv2vnUoEQ5u9rb7JppnMWLjGSF5Gb1kgSyRWNMDo+wgX6hfutTR7y6DngrkSnPsgjI9+xnpjZXJePsMmd872plg+YU+r0UwvK5HfagF0a0MLSOWOTiBORyvSGjy3+CRpsCN+WDVTpu/pQYp5yAGczUFfH9525YLzm+NwSWs/PmSPdNUhq/Dg4Qeu3ofdMEEvqDJvEZ0GrLqP8a0auyMDaWU9Yr+cHGHHSWIgKMwiZ5GDX1/RNo71Ja8F9ITUpPUn9RT1rkLIuaydTDhZSQZE9EIH6V0nT3E+8gezZifCH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For device-private memory, test_hmm backs each fake device folio with
real system RAM of the same order, allocated with folio_alloc() in
dmirror_devmem_alloc_page().

When the core MM splits a large device-private folio, the driver's
->folio_split() callback, dmirror_devmem_folio_split(), has to split
the backing memory as well. It does that by hand: clear_compound_head()
on the tail pages, folio_reset_order() on the head page, and
folio_set_count() on each of them. dmirror_devmem_free() then frees
every backing page as an order-0 page.

This open-coded split does not split the allocator's metadata. The
allocation tag and the page_owner record still describe one high-order
allocation, and PG_head stays set on the head page. When the pages are
freed one by one, the tag is debited for only one page when the head is
freed, and the tail pages carry no tag at all. With
CONFIG_MEM_ALLOC_PROFILING, running the HMM selftests and unloading the
module reports the leak:

  lib/test_hmm.c:808 module test_hmm func:dmirror_devmem_alloc_page has 16744448 allocated at module unload

and with CONFIG_MEM_ALLOC_PROFILING_DEBUG freeing a tail page triggers:

  alloc_tag was not set
  WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0

The backing memory is a private buffer of the test driver and nothing
requires it to be a folio. Allocate it with alloc_pages() instead and
split it right away with split_page(), which splits the allocation tag,
page_owner and memcg state and is already exported to modules. It is
still allocated as one high-order block rather than as individual
order-0 pages because the driver finds the backing page of the Nth page
of a device folio by offsetting from the first backing page, so the
backing pages have to be physically contiguous. Every backing page is
then an independent order-0 page for its whole lifetime, so
dmirror_devmem_folio_split() only has to point the new device folio at
its backing page, and dmirror_devmem_free() frees the backing pages one
at a time.

As the backing pages no longer form a folio, take the order from the
device folio rather than from the backing page, and index and copy the
backing pages individually instead of using folio_page() and
folio_copy().

With this patch the device-private HMM selftests pass and the module
unloads without the messages above.

Fixes: 56ef39899643 ("mm/memremap: add driver callback support for folio splitting")
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/linux-mm/be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev/
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://lore.kernel.org/linux-mm/8ef6e92d-4cb3-444e-857e-fdbf88c035ea@kernel.org/
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
v2:
- Use plain struct page arithmetic instead of the
  pfn_to_page(page_to_pfn()) round trip (Zi Yan)

v1: https://lore.kernel.org/linux-mm/20261118230044.683221-1-nilayvaish@google.com/

 lib/test_hmm.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index b409c42bfe6f..15db569eb721 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -201,6 +201,7 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 	migrate_device_range(src_pfns, start_pfn, npages);
 	for (i = 0; i < npages; i++) {
 		struct page *dpage, *spage;
+		unsigned int j;
 
 		spage = migrate_pfn_to_page(src_pfns[i]);
 		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
@@ -227,7 +228,8 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 			dst_pfns[i] |= MIGRATE_PFN_WRITE;
 		if (order)
 			dst_pfns[i] |= MIGRATE_PFN_COMPOUND;
-		folio_copy(page_folio(dpage), page_folio(spage));
+		for (j = 0; j < (1U << order); j++)
+			copy_highpage(dpage + j, spage + j);
 	}
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
@@ -805,7 +807,7 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror *dmirror,
 	 * data and ignore rpage.
 	 */
 	if (dmirror_is_private_zone(mdevice)) {
-		rpage = folio_page(folio_alloc(GFP_HIGHUSER, order), 0);
+		rpage = alloc_pages(GFP_HIGHUSER, order);
 		if (!rpage)
 			return NULL;
 	}
@@ -827,6 +829,9 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror *dmirror,
 			goto error;
 	}
 
+	if (rpage && order)
+		split_page(rpage, order);
+
 	zone_device_folio_init(page_folio(dpage),
 			       page_pgmap(folio_page(page_folio(dpage), 0)),
 			       order);
@@ -1029,10 +1034,9 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 		WARN_ON_ONCE(end_pfn < start_pfn + nr);
 
 		rpage = BACKING_PAGE(dpage);
-		VM_WARN_ON(folio_nr_pages(page_folio(rpage)) != nr);
 
 		for (i = 0; i < nr; i++) {
-			entry = folio_page(page_folio(rpage), i);
+			entry = rpage + i;
 			if (*dst & MIGRATE_PFN_WRITE)
 				entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
 			entry = xa_store(&dmirror->pt, pfn + i, entry, GFP_ATOMIC);
@@ -1130,8 +1134,8 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 			goto next;
 		}
 
-		spage = BACKING_PAGE(spage);
 		order = folio_order(page_folio(spage));
+		spage = BACKING_PAGE(spage);
 		if (order)
 			*dst = MIGRATE_PFN_COMPOUND;
 		if (*src & MIGRATE_PFN_WRITE)
@@ -1722,14 +1726,12 @@ static void dmirror_devmem_free(struct folio *folio)
 	struct page *page = &folio->page;
 	struct page *rpage = BACKING_PAGE(page);
 	struct dmirror_device *mdevice;
-	struct folio *rfolio = page_folio(rpage);
-	unsigned int order = folio_order(rfolio);
+	unsigned int order = folio_order(folio);
+	unsigned int i;
 
 	if (rpage != page) {
-		if (order)
-			__free_pages(rpage, order);
-		else
-			__free_page(rpage);
+		for (i = 0; i < (1U << order); i++)
+			__free_page(rpage + i);
 		rpage = NULL;
 	}
 
@@ -1833,34 +1835,24 @@ static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
 {
 	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
 	struct page *rpage_tail;
-	struct folio *rfolio;
-	unsigned long offset = 0;
+	unsigned long offset;
 
 	if (!rpage) {
 		tail->page.zone_device_data = NULL;
 		return;
 	}
 
-	rfolio = page_folio(rpage);
-
-	if (tail == NULL) {
-		folio_reset_order(rfolio);
-		rfolio->mapping = NULL;
-		folio_set_count(rfolio, 1);
+	if (!tail)
 		return;
-	}
 
 	offset = folio_pfn(tail) - folio_pfn(head);
 
-	rpage_tail = folio_page(rfolio, offset);
+	rpage_tail = rpage + offset;
 	tail->page.zone_device_data = rpage_tail;
 	rpage_tail->zone_device_data = rpage->zone_device_data;
-	clear_compound_head(rpage_tail);
-	rpage_tail->mapping = NULL;
 
 	folio_page(tail, 0)->mapping = folio_page(head, 0)->mapping;
 	tail->pgmap = head->pgmap;
-	folio_set_count(page_folio(rpage_tail), 1);
 }
 
 static const struct dev_pagemap_ops dmirror_devmem_ops = {
-- 
2.56.1.750.gf70dc682cf-goog


