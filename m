Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2CEF54AB9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8EE6B0095; Tue, 24 Mar 2026 09:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90876B0098; Tue, 24 Mar 2026 09:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32EF6B009E; Tue, 24 Mar 2026 09:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0A776B0095
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:35:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A46013D001
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:35:58 +0000 (UTC)
X-FDA: 84581054796.28.D24166B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id B72864000F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:35:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ivgdL/dm";
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774359356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6QDqr9IzmNmsxfqCUw7XQcy6Z4ZdfW29udJjZ6wndY=;
	b=h3Gfu2gsuqz7B2HKE8wSXezxV8l2vsbA1ryBmB6zoyA+3quS5QPM1/oHW7FPinbL4qElno
	6wBqxXagl6rLU7Cpjo1v8ZH5treTLyyWFWSG/Zf6LVm2KP0u2Da9znc2MLFrwu3zdm9DN0
	lBrSy+4ijMyzmAHZW41eX4tmDs6wJqM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ivgdL/dm";
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774359356; a=rsa-sha256;
	cv=none;
	b=WGqZB47BUL5jm6Cwjcr0dxc2SoxbegxKHX1ddCYQw0kTxaTHknuVdflUlQWwlunfEM7wA/
	siitnX+0IEDLD+x1HDB9J8TUeNFIP2TnUoIPEyKaj1ao6xoytgblQ05nWhtYlNm1msgRDn
	IKWLytoiY2OqZWlFm0nmDR+2WYpquiE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B22D71476;
	Tue, 24 Mar 2026 06:35:49 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2F9023F836;
	Tue, 24 Mar 2026 06:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774359355; bh=2yrw+lLfo/BogFmVsodILJdp3TAUbIBVR0xAm1sWA3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivgdL/dmSS3Jn+K5nKU580peS33oNsxwe8ghuggBEI+MGtQMWi+anZMA8CcmUclQB
	 uLJClBxcuJJR5dFdGnJJe3Yrlv6OOJ1YhlHzC3TNN4m74fry6X4jSyj9+9Jt+QE6O3
	 m8Cg9iRm3tZBsIN/eXuJmul1AlGXqAUme7bCSXuw=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	usama.anjum@arm.com
Subject: [PATCH v3 2/3] vmalloc: Optimize vfree
Date: Tue, 24 Mar 2026 13:35:33 +0000
Message-ID: <20260324133538.497616-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324133538.497616-1-usama.anjum@arm.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ixxbngwci8syqpjnpwr9edmxpbka6tiz
X-Rspamd-Queue-Id: B72864000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1774359356-407450
X-HE-Meta: U2FsdGVkX1+u7XkgrnOXbAWWsYiyctXRr5KmQRWQRSA0kNgRdzRZfM8G61N6BEG8AWe3Xgl7+I5EJQlBggs6l191e4qWLYYsoBvmWVTUx78b8QnyzAGW0+NGN9mXOKmmNTP5nGj90mUCi4syV28jSnPAwWT8etjrcv6U2Cv4Fsk/13B8s3yNSXtJiQ3zuG4rl+GXsDWfJ2fwbfNgKIpYJv72fM2tGccI1sgTJzIR+0gHra9Eb4QoRyV8WooiB8CEIVKGK/uKndpIsaY6lLPbEj6qttqrQkSohMfhKuVSpo6diTyS/7F8fh0Fmayg/sO8VMDg1m5ijmi/P0iZeSqSEGc/0vodCqNi+ajekrgVjZ92+8Cg0KUAkZYIrGRInzPDUeOyPFotpDy3u0IQomzGLElYMMrutk4bDncg9ZetwnIllbgC6ODMAnl0/Xy5W6+cyvL+qf9y6JxkGB4OLghJxDYRa87+HRr8HwLmePxho3bXVqDjaEfuVpEjGoU5QtIU5wNWm99KH8wdJGdzA8ncbrYAJE3oQA+HKT82HN1BqGAW524pez790Cp0jvBPTIGB+DOJ9fLeu3jdfXGpY5kzst0nmjmzw6KC9Yy5BbP4KAK3V6D2LARXF3TmaAFBbYWKX5ExK4XrU0yrhMFjui6yt01R0b4+Il55FtceozAKnASdOiTxE9AcAcfgZAQ1mk2dLqsDMwa1y51aubI37k09sqhwxZMZGLqpACLtuGz6XrytKjD7cPIv2caEbElxvXgOUzJZ6xH5pTWQlDWrWWjRSEsGNu3+umX7qPlHdFAcmv4bgZIPXaO7Obt8Nrk8AqZHLBq+YHtI/gqbTEtTnF47BNDwN2jADgKXooX39i2EyOdRk+ViV2sYnOvJpy/hqKChAGnq/WRiKg3wenXkh4os+19IiKJLyM3pjARfUnxLDq8z3B8oLxw/cr1g/LH8ZqRW0NAQ4VNTg3/n/NXg1Cy
 ksvBWgjC
 KxxlDItc4tia7H3pa3yREkfvm97UW+1QZA2CqLCnhwek6hKpN573LrOzJp3nU183kwf590Oqbd4Cf+p6Nx/+o29ab7Fgoa8FRTwc1lV0JBTc8rjum9gii8aeBCPpn44f4FbHqO6SktG8ZwiJPfLsI8YjYeMapixl/m6+C9V45TIWaTQuHJ88r92x3/4XlvOqZSFd/FOYnHJqo1EyIK2wPQF4wvn1Irb7yZIv+pkYLE7pz7oBYNvoc/zSuhna2hBi0RpE2D0vvvleL5HEbmTKiTHZjpJ8ynUT2A0cxSKKF1l6oU1UWUWtxJaG2OPJ/ZxxK3FNxm/oxmrnKehmE5KDPYNOqTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ryan Roberts <ryan.roberts@arm.com>

Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
must immediately split_page() to order-0 so that it remains compatible
with users that want to access the underlying struct page.
Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
allocator") recently made it much more likely for vmalloc to allocate
high order pages which are subsequently split to order-0.

Unfortunately this had the side effect of causing performance
regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
benchmarks). See Closes: tag. This happens because the high order pages
must be gotten from the buddy but then because they are split to
order-0, when they are freed they are freed to the order-0 pcp.
Previously allocation was for order-0 pages so they were recycled from
the pcp.

It would be preferable if when vmalloc allocates an (e.g.) order-3 page
that it also frees that order-3 page to the order-3 pcp, then the
regression could be removed.

So let's do exactly that; use the new __free_contig_range() API to
batch-free contiguous ranges of pfns. This not only removes the
regression, but significantly improves performance of vfree beyond the
baseline.

A selection of test_vmalloc benchmarks running on arm64 server class
system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
large order pages from buddy allocator") was added in v6.19-rc1 where we
see regressions. Then with this change performance is much better. (>0
is faster, <0 is slower, (R)/(I) = statistically significant
Regression/Improvement):

+-----------------+----------------------------------------------------------+-------------------+--------------------+
| Benchmark       | Result Class                                             |   mm-new          |  this series       |
+=================+==========================================================+===================+====================+
| micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
|                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
|                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
|                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
|                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
|                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
|                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
|                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
|                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
|                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
|                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
|                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
|                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
|                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
|                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
|                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
|                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
|                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
|                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
+-----------------+----------------------------------------------------------+-------------------+--------------------+

Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v2:
- Remove BUG_ON in favour of simple implementation as this has never
  been seen to output any bug in the past as well
- Move the free loop to separate function, free_pages_bulk()
- Update stats, lruvec_stat in separate loop

Changes since v1:
- Rebase on mm-new
- Rerun benchmarks

Made-with: Cursor
---
 include/linux/gfp.h |  2 ++
 mm/page_alloc.c     | 23 +++++++++++++++++++++++
 mm/vmalloc.c        | 16 +++++-----------
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 7c1f9da7c8e56..71f9097ab99a0 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				struct page **page_array);
 #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
 
+void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
+
 unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
 				unsigned long nr_pages,
 				struct page **page_array);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eedce9a30eb7e..250cc07e547b8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5175,6 +5175,29 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 }
 EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 
+void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
+{
+	unsigned long start_pfn = 0, pfn;
+	unsigned long i, nr_contig = 0;
+
+	for (i = 0; i < nr_pages; i++) {
+		pfn = page_to_pfn(page_array[i]);
+		if (!nr_contig) {
+			start_pfn = pfn;
+			nr_contig = 1;
+		} else if (start_pfn + nr_contig != pfn) {
+			__free_contig_range(start_pfn, nr_contig);
+			start_pfn = pfn;
+			nr_contig = 1;
+			cond_resched();
+		} else {
+			nr_contig++;
+		}
+	}
+	if (nr_contig)
+		__free_contig_range(start_pfn, nr_contig);
+}
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a6..e9b3d6451e48b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3459,19 +3459,13 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	for (i = 0; i < vm->nr_pages; i++) {
-		struct page *page = vm->pages[i];
 
-		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			mod_lruvec_page_state(page, NR_VMALLOC, -1);
-		__free_page(page);
-		cond_resched();
+	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
+		for (i = 0; i < vm->nr_pages; i++)
+			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
 	}
+	free_pages_bulk(vm->pages, vm->nr_pages);
+
 	kvfree(vm->pages);
 	kfree(vm);
 }
-- 
2.47.3


