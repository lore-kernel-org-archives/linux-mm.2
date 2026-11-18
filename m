Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40525606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ib0br6qo
Received: by kanga.kvack.org (Postfix)
	id 4457C6B0628; Wed, 18 Nov 2026 18:01:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFA96B0629; Wed, 18 Nov 2026 18:01:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305A36B062A; Wed, 18 Nov 2026 18:01:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECA076B0628
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:01:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 728651608FB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:01:00 +0000 (UTC)
X-FDA: 85449761880.01.179D5ED
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE73080008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:00:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ib0br6qo;
	spf=pass (imf02.hostedemail.com: domain of 3KS7-agoKCNwLGJ8WT8GQFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--nilayvaish.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3KS7-agoKCNwLGJ8WT8GQFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795042858;
	b=ZVY5TYrozPc8JTDE92BxrPHwTJOT6kH99Kf7UmT24SvwUViISjAM0LyRA3uLrgEJrkeZU8
	eMHggB//H2vyusRXphiRXjMirfDGwxJXYaEm8w80ztDzgcUmflGX83FeCwgk18AsN1zlvF
	p3dBt6gc1B1CkcL45tvXLJxDKsnUL+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795042858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wtJqh98lptU6ZJP4oIh8FQUdThkTquo5a0UcLNm2kK4=;
	b=yztgsVsA5SA+TsFMzr9Ejg6VxIVVfFKnO1vhCG+dcCDNhORAMaeZnRDWMSMA4aHuJ5hIlQ
	IhzyyQnEzIg/782hFghKZBMqi5LMeS4TWP4wfus00N6pNYwFm1UvbUBfG7rs2lsOFvnH8L
	URLI0V9FAwGit+CgZ2/OLsq1w2VxCkI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ib0br6qo;
	spf=pass (imf02.hostedemail.com: domain of 3KS7-agoKCNwLGJ8WT8GQFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--nilayvaish.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3KS7-agoKCNwLGJ8WT8GQFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-86155a5b1c6so360785a34.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795042858; x=1795647658; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wtJqh98lptU6ZJP4oIh8FQUdThkTquo5a0UcLNm2kK4=;
        b=Ib0br6qo4OEaRY6D7Rd71QY+oYjTTPmvnwdnQqeXu4ns6KALOF+NVtefT/Lv7PkfE6
         r6lC1EVXHomvxma1IRGApJKhe6eBMybFLGhJYeH9ZYTcdCX/HHf0wvvQROLc/GcwNOIg
         IAf4Nh8SkN6s0U0R9Gwfwd09aha0oi+cpCUGxQsJIMceopyRqOzvdp2imB0BQ6otgv/u
         KQs/vqRBSmqbj3iHq9TJjfGM0PZQvQYVNrw5THaKo/q182n59llAzF5ar00qAwl36tW7
         Y+FIuoOIswHxCAtbrKgfTAj/13CYKz7EsnK9wQ4TU2KQ4lvQS+QhK/07zem28fco+3r7
         USvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795042858; x=1795647658;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wtJqh98lptU6ZJP4oIh8FQUdThkTquo5a0UcLNm2kK4=;
        b=bnu1R81dQ9+R/v8lLcReVNzq/5PUGivJ0gixKd7Pm4MIVnhby6H5gqldTqhB72Xr5u
         bWtiwzYPsXzCdABgM7eWlG8ztzWTZU81Z6SxFzvKEzsw3ueYiFlwGLExcFJynyMjq7jK
         wBQMu9LKfuHbgkSILvT0isbo/zG9b4gJRPjiABYvF6iKYW96Br0Pw0XCrO3QvzMB6E3k
         3pUHYlpftvIaT30JUx3ctwOJUxVEJYPQSxZORaTIZO0/WfjVtUp3Tw0qw8yq6cKA5SQF
         xB7YB/ymLEz1RChIe4rCg6Q8ntLScRqC+Ivh8KAMaoYfeV1O8Um4dIxRcXx2I9/qLoVC
         wuJA==
X-Forwarded-Encrypted: i=1; AL+hErECaUpQcKcmH+mh0fUEN2Vp8BPatnSZmh+5w9ndWQG6ELoV90peUcjzBqRGGjjcqzMN+uW4FoJisw==@kvack.org
X-Gm-Message-State: APuU4Z9tJCGXFhxCMw/gxXtLr0m069WTzNooZOSNxkxieimhJAbT8Iar
	ZCEPSr4ma14ssCAEPwkbu8cVeqwhLSXNs48miiFFEyVfK4Oea/KFNMJvUI17F70RExu2+K6Guhx
	JxotbO+qxZQ2j6XdC6G7XUQ==
X-Received: from oajz19.prod.google.com ([2002:a05:6870:3213:b0:4a9:9e93:8ee0])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:e84b:0:b0:71b:1c76:150f with SMTP id 006d021491bc7-71b2e150d73mr175490eaf.5.1795042857188;
 Wed, 18 Nov 2026 15:00:57 -0800 (PST)
Date: Wed, 18 Nov 2026 15:00:44 -0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118230044.683221-1-nilayvaish@google.com>
Subject: [PATCH] lib/test_hmm: fix alloc tag leak when splitting
 device-private folios
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbirs@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, Zenghui Yu <zenghui.yu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
	Zi Yan <ziy@nvidia.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4z4auc5psmab1a3oxuezoynpa4sqa116
X-Rspamd-Queue-Id: AE73080008
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795042858-735548
X-HE-Meta: U2FsdGVkX1/c9P4yDq/J/slt0zb+vemivNy1LEBn6sMvzMwu9AoJ9KIqTLB9r7VWcugx2bCawBYqLJQXL0W5DfcV3BSnz+qqiouIIQ3bfuxc7SJHP8RnPeELVib2cBWmjKllNt89gENg48tFVa7fqNB5mnATVTG1mSBq8PY7g/GTc6h60sQx/5UpFPKs9rjfb2FZF+pt1sGUNrQBhvnxFL8K0zAc9N82Sf7iGXr5R4XdXHPwi49/elU0ePN5/hUR6YUAeylPZgE3lPms3EYUYX2JHWMlz53QY1raO0ioeFEHwlVCK7y2LY8puzd98TlVMqG4CkFzOjuFeu8WxclNC3RUnUbIBMf0c63sKyqPAMumM/Ko7eM3nBlOA3YM7kEEMT2zelCAmVqQbiBZO7e4LsQhIPAgz/bciBbjhHo+MM8nPU0ZzH/fFBvj4jUOdVVLnFHWmf1p1deEyFR48W1MfDyhrPNs21BNRBDJrTz8LI7L+u0hYe/nhN+jjlKKDzmuIyVc5RB1g5EPd+g5M1ZiIq8/dSiaMVqdq4ZnK988rY+FtINyVFP3o/qq4wXztqawX5CYZY5NlT5NrUVDYUYtBRKjwA/+v9U5Mce+tqIJkqpMXlvw5D1Soy4HHUGEyegZR1DlvauE2to3xyh2Scqj9JJYdrB4zNVkhvWwbhRSUUqAmSEp1EJQXxq2NbLVrCFz/QxAHux1af6TC57cf952uZmL6v7djMGcq4NdRIrXe4hAj0RinJIxmz0Z27jHpvpnEoIXFHIH3lLChpUXPsC8FVWFZOjKNNSQ5vZ6dXcvWiou3Aravb/Xs0UCDKllSWVNu4Yxxt1CYbfekYPjpgdajGQ5/kZ/upmjRDZdYLqzpSpB51Wx/w8LWJFYjbm5sLZ1EFypAveBhpLsrvMdLUmpsPfKNwx+FRT4GXrzwNxmR1Dli6c2sCCS1u1Ma6cQ9HJ98LhheHKdALnZrQ4O+1p
 dXtm/Mmx
 yBNkTeqj441kac0MK+RhzBKwXuOewZZxWMUQYbDDmMR6PkQvIjnr/V4//jOdFyInBODYCVu5tfbne6gZ8/xA9Ri3dxg73Lva1jbTEm7DykwIxOn2Sq6cJeig1S62uVwDSC1pQhse2mXjhhpx/nt1s9CiWl74VCVF6yclSaVPmRg5HjUy7lwo+3bvXKULIOPGsFEVptqi0XC1YXmn99ox8oG4+T+1TmWlE55uLO98jmPCw45isEohvr98rEjNIe+BCCDYdXKgONkD2heRZdm8kblsHZME1F5c5g6pNbMfiAQC1M+Tojg58WIKJWWlhub7DcacOGmSiX3OlG9+0J0LHm3ERZ3MBtIBSRyei1eWeT2G7vaQxO2i8r9c24XcfkRZe4KOGZVqeZuH28ycAw89KfDECsud1sq7Lx/5uWnQruaR7xrjn16iBKG2AbWhS8g1kUvTiGb5HECTtLpiWO/e7u3yoN+K1BNRfHVswDx1hT8utF4WlDLajv3yAtpUU/GY656Xdg8jscYhP/YStPp46ybeyEKWF0PMeeVJYjZAAYGUkKEuXhPCBABfdT7ixlwzqG0eTAxxk4JL/K6vVrjAO48890n/raSOF7RXid9xOyH7lP/qKoSYqhVBBBefsJVBfZzTLHDW31zN876eCoa6vMIYhCwJRDSq0KQDuRkIsUV8Ssjmx5mN1Xf+5Eeg65oquXCVl10bLhLH+CZJGSuxQhYIupXLaIWoyTxRJAucG8dIZqgtZh6Jgn2Bh/QR7S+AvhJo6sGl++o07rrIwryjA/GQQfZdevva9JAQWzCsoZ2b6/yU=
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
 lib/test_hmm.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index b409c42bfe6f..371ead009f8a 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -201,6 +201,7 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 	migrate_device_range(src_pfns, start_pfn, npages);
 	for (i = 0; i < npages; i++) {
 		struct page *dpage, *spage;
+		unsigned int j;
 
 		spage = migrate_pfn_to_page(src_pfns[i]);
 		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
@@ -227,7 +228,9 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 			dst_pfns[i] |= MIGRATE_PFN_WRITE;
 		if (order)
 			dst_pfns[i] |= MIGRATE_PFN_COMPOUND;
-		folio_copy(page_folio(dpage), page_folio(spage));
+		for (j = 0; j < (1U << order); j++)
+			copy_highpage(pfn_to_page(page_to_pfn(dpage) + j),
+				      pfn_to_page(page_to_pfn(spage) + j));
 	}
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
@@ -805,7 +808,7 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror *dmirror,
 	 * data and ignore rpage.
 	 */
 	if (dmirror_is_private_zone(mdevice)) {
-		rpage = folio_page(folio_alloc(GFP_HIGHUSER, order), 0);
+		rpage = alloc_pages(GFP_HIGHUSER, order);
 		if (!rpage)
 			return NULL;
 	}
@@ -827,6 +830,9 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror *dmirror,
 			goto error;
 	}
 
+	if (rpage && order)
+		split_page(rpage, order);
+
 	zone_device_folio_init(page_folio(dpage),
 			       page_pgmap(folio_page(page_folio(dpage), 0)),
 			       order);
@@ -1029,10 +1035,9 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 		WARN_ON_ONCE(end_pfn < start_pfn + nr);
 
 		rpage = BACKING_PAGE(dpage);
-		VM_WARN_ON(folio_nr_pages(page_folio(rpage)) != nr);
 
 		for (i = 0; i < nr; i++) {
-			entry = folio_page(page_folio(rpage), i);
+			entry = pfn_to_page(page_to_pfn(rpage) + i);
 			if (*dst & MIGRATE_PFN_WRITE)
 				entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
 			entry = xa_store(&dmirror->pt, pfn + i, entry, GFP_ATOMIC);
@@ -1130,8 +1135,8 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 			goto next;
 		}
 
-		spage = BACKING_PAGE(spage);
 		order = folio_order(page_folio(spage));
+		spage = BACKING_PAGE(spage);
 		if (order)
 			*dst = MIGRATE_PFN_COMPOUND;
 		if (*src & MIGRATE_PFN_WRITE)
@@ -1722,14 +1727,12 @@ static void dmirror_devmem_free(struct folio *folio)
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
+			__free_page(pfn_to_page(page_to_pfn(rpage) + i));
 		rpage = NULL;
 	}
 
@@ -1833,34 +1836,24 @@ static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
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
+	rpage_tail = pfn_to_page(page_to_pfn(rpage) + offset);
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
2.56.1.708.g77570a6a1d-goog


