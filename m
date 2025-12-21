Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA11E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740CE6B00E2; Sun, 21 Dec 2025 07:47:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBBD6B00E3; Sun, 21 Dec 2025 07:47:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6846B00E4; Sun, 21 Dec 2025 07:47:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49DD46B00E2
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:47:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F02CA13BAA4
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:47:37 +0000 (UTC)
X-FDA: 84243454554.19.97336FF
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 421E61C0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:47:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=g0ABuD7O;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766321256; a=rsa-sha256;
	cv=none;
	b=4wLgPOL72fBj/eH/hdOF3Mk/oHlhO8dAqPGsqvIC9KMSVnfI+OxGgWtHkg0mfHBKrcTtOM
	l1g6ur0u1FvrR2XMF5tSQz/a+otPhWVV/xRmSbPGxkiEkRYctuRwrVw/M1lp/ZNGLf0ILt
	hfUQ2nA1lO8ey+1oeBILQJeXEmFkzWM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=g0ABuD7O;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766321256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FF+BE6xPVTJjX20lPRgrjzLZlKI8Qc5ScIMSD10bbno=;
	b=8WFY665v+/rxH/2nzgXYviU2lfIuoTRruCOIMW51z582jaBo4wzM4HarkLdZQu97/5F/ft
	EsUPdTS9Sw/cSKHfr4TmHmPgb6Jb7mJbOgjEyFgdrnEjx2vF16EDbT1cwgQgVMzS5kVAo7
	Hr9mqGhg+Li2hiVv/Fplg9QpQNcrUDw=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee13dc0c52so26311411cf.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766321255; x=1766926055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FF+BE6xPVTJjX20lPRgrjzLZlKI8Qc5ScIMSD10bbno=;
        b=g0ABuD7OW1aKV0/r1zNVfQALKLegBipxdfPD46V1bSz4N3Q/eQzs4mUn5qX23OQN9z
         T8dTbHuEfmzTYG5JRWPx+CkxAM5Fmhr2awitElPSA+LWYV27Wq9wljdjwMryJOoat/JA
         y4TOpI5AZDtE7s86eQ26Fg2f4pOtOqOmNtIZH817VwhbjH7apTqukzY9Bc2RE6mc2aIS
         JdmUuqgHzO/Cq9aH5aWMfOuFMNDB7uKxH+1/MgXyCgAPsFoxQfRsv1SkByDzLKWcv0xE
         gCv0IBf6nE7UHEjQfI6jgh6t6Fj9mlmPv2TEYPXo8z2iy7aB2Wfv4E9kjvdGUGYHiUvS
         PLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766321255; x=1766926055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FF+BE6xPVTJjX20lPRgrjzLZlKI8Qc5ScIMSD10bbno=;
        b=Wsy6viO5/FAZ2TPr93serN+Me+JlYn0xK/tL0iea8TAjleAK2gdcSMgRh+IuBApq7D
         49IZgIW/2v03xTPMm3tiaHlVVRIkB7K+ZsOe9uYYWYe2bNFj4TRT/lJozYzEuadIAjGA
         P6noZFjTWsSFQaVwd3wc8CYgybkGfD7foAB14l6+v8GoSepQuvkZLHYnHBd3xkUkXLeZ
         HN88cVKOtNArbimbRx8r8Wx5F3GQzgP6rHYB24MbNb89MrPwRfTNG7eK1ImUKYlG2IAP
         xWdImPmHUwolFvIl+MLmEeZHYAHhHQMHbI+HZFaEAHGeHVKp3EwhUp3GgI7A2erBuio/
         q5PQ==
X-Gm-Message-State: AOJu0YywqihuWGncI60/j/CkAQGrN+h0E0Her3N1waMkSPpv7vHDzjWB
	pOHLu3hE99zfrU8TTelHe7FM0xq5FviBKMBPk7iifMUEZJF16pV8W8Oy8PkPXDDhtK3KK6TRlW+
	RBLIE
X-Gm-Gg: AY/fxX6nvW1O4Vxk71iiCAmOqJT/+BzZZG/LSvMQNtJCipyzXkNPYwjhoeN8biR6DMe
	vKa9Ss8x8KxJKG/NkLgwykqGDMdzCuWt5dlE53D4FHjKvDMk5/iozeYbdqZyTmJEyvhgr8ZnuOl
	gioIcSwjUi5UTwC9lNTmlT9R2A3iDWvm6th9uyBlfJ9t7ZZwXKCdveYvx6q2NsC8PKslIEefl/z
	0D/wh2n/EdLIHqGgQQB3ymDD0+qiqV946PqHl2WDQneKV7BoHRKjf+LDqWJUB674so2LApZKwmb
	Uf/8RxAKC1ajltPaCR9Jd5dw6PSotbVNGTKVt73jzkqkH3LDAbUbCYdi3BNTQ2rC2pw0vsyupeq
	hBgjf//6NL8TWCU/AazkbwZ2eAPbMiEnmS5fIYEYFeKrSIpM/etGLVSaElnT2qoR3sZWGXs+BWn
	0KC0TTQyNcSrEu5pait7FbrjWrEiz/LjUY3YRf+JCDNG03Gdg3e/IYlkIKC2Ih7FqtXPRFC3k5C
	Rg=
X-Google-Smtp-Source: AGHT+IFfDpM50iJ98LsRskGa80nR0EXRlUUC2Og1kXxCLzZjAWWZkzaUgH7NOi0CeHzJfK4e2sDVMQ==
X-Received: by 2002:a05:622a:4a09:b0:4ed:1948:a8a2 with SMTP id d75a77b69052e-4f4abd75322mr125510121cf.40.1766321255085;
        Sun, 21 Dec 2025 04:47:35 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac5649besm55982091cf.13.2025.12.21.04.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 04:47:34 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	richard.weiyang@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v7] page_alloc: allow migration of smaller hugepages during contig_alloc
Date: Sun, 21 Dec 2025 07:46:56 -0500
Message-ID: <20251221124656.2362540-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 421E61C0005
X-Rspamd-Server: rspam04
X-Stat-Signature: dcb8is55pscz3xtqxuzksasnq3ow3cc9
X-HE-Tag: 1766321256-43684
X-HE-Meta: U2FsdGVkX1/EyolM3K6ntJxXnfeu6Gc2G1icEBgESVNLRkeCKgu2Zo9+8Kqr7e/naY04rK/W+DRwWn45Cp42Dmq6j6cSJD+IJnXvAT86tgZ0nZ/VV4/F1rvFl4U6DdZLTwic6L77VPpTB8bjggWBYd8SEDtrY6G95GaxFEIkdrB42GRGC+tvqAxipUJ2AlSGabk5dr0VYXXLnfRUCdHLMSwZmQS6SJ9i5hN+RH7KUDYcso/bVtdKICiQxgA9FAf0HofEeTV134AGQegfUJKiWkPyxaQZsGgoVVri6y3jDVI9ovbmGp4GzZj1nCd4fOEu9f/Sk5OUVXADzWg7eB6aXQQ8bnldGyBFgJQyqAZqopsACa/gErxSKFNc+Qb/FOqKBiy3Ia7J5D9L5X+rfanSo48L/czuQJL4l+N8EKLrordjItMqyCDWteJD774JcYqwlfwhgQGo0dbWHtxTMD7DPYYP+jpxCyThZFkEZKoJD5HRFuuXXa3EA4OFNgUx309usphjsJazoPKbPFQXxhiQ893gL9cnmhe4N69RDMqy7LUs7ddW7/as30NOskOQOZV2XnDhsCwoRAdGZ0pvRb13fy8ICPc6tEcU2ddr9wS7FSpp4CuHeIG++dhcgrmVzr/z9ScwIq7EyuxCfWNU9v93QicdgvpEmVhvPoAP/nmeXlDO7WaiyHsXc66N+C4Oxb/HIzHMU06T/FMb3msDac6FTNC1mqX+Mu//ILueUDkzpopxFCQeA+uF40U0znfadMOEUXYZNWtlaXeCibV5ynU6cK11C5/ytDVnXoQVNr85iPpyrvTWfjOexAXUjqMpc14gLHSSBctVrntZlleiT9e+sK2cWMgtFntd5JHLLQuR4NwawCG2wrBQ6x07Qz6CHrvqfkgsAO4OmRQzJGkEcwsABub+UePzz2Sae6iWT/CVcdUh7mLjuAcHTY4bD7OMX1orPmTr7Bw746Thlt5GeLZ
 A6CcnV9q
 njPHK1UdGmOHzEV86L2XDBcHZAlPIZaK/OuFaxE5YBGZVxcVJOQKYFIj1d15GQl4THsHxR2Y+FFikm8HBTbTHpFLuibTwlxOAEwG2ImoYfmjZzWAm68q4AlIBbypf2MAc8QBE+kvQSSD8l1m0oLborQfK0Q2G0fpMTrFAR28/skDFjXJS8y6U8iV0Dm3bjMUlsQuiBxcEzshAvrLjgfaZHTctuAPjDY8c/AM54HHftOtToss+SCPaZlDZCvjVY1/ZEp3lxCtpO48AbPhRLjnkM23DiM/VcC8bBaZ0OO3UcuVwOZK7KRKc9Lm9dtbPqrLjwVGkReQFNSckqAcYpCUsm27qEfXNM+xQmBvwNhjTBfZzkW1fjZkMOwjV1a7SOWxCdcQtbZz5CyStBkbhraPesvnauURQMMeM2GqnFE9d8WI2CmYiKcyHi7qYqcONEynCpgDmdXRoweFRhCiU45TkdANGx57KqYSIck1EwAS1q0ZECDX8slwhmiC78a87MadUiTW0P6WYopQUois=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  This will cause otherwise-movable
2MB HugeTLB pages to be considered unmovable, and makes 1GB gigantic
page allocation less reliable on systems utilizing both.

Commit 4d73ba5fa710 ("mm: page_alloc: skip regions with hugetlbfs pages
when allocating 1G pages") skipped all HugePage containing regions
because it can cause significant delays in 1G allocation (as HugeTLB
migrations may fail for a number of reasons).

Instead, if hugepage migration is enabled, consider regions with
hugepages smaller than the target contiguous allocation request
as valid targets for allocation.

We optimize for the existing behavior by searching for non-hugetlb
regions in a first pass, then retrying the search to include hugetlb
only on failure.  This allows the existing fast-path to remain the
default case with a slow-path fallback to increase reliability.

We only fallback to the slow path if a hugetlb region was detected,
and we do a full re-scan because the zones/blocks may have changed
during the first pass (and it's not worth further complexity).

isolate_migrate_pages_block() has similar hugetlb filter logic, and
the hugetlb code does a migratable check in folio_isolate_hugetlb()
during isolation.  The code servicing the allocation and migration
already supports this exact use case.

To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
(Scale to your machine's memory capacity).

echo 24576 > .../hugepages-2048kB/nr_hugepages
echo 4 > .../hugepages-1048576kB/nr_hugepages

Prior to this patch, the 1GB page reservation can fail if no contiguous
1GB pages remain.  After this patch, the kernel will try to move 2MB
pages and successfully allocate the 1GB pages (assuming overall
sufficient memory is available). Also tested this while a program had
the 2MB reservations mapped, and the 1GB reservation still succeeds.

folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
other users are debug or init-time allocations and largely unaffected.
- ppc/memtrace is a debugfs interface
- x86/tdx memory allocation occurs once on module-init
- kfence/core happens once on module (late) init
- THP uses it in debug_vm_pgtable_alloc_huge_page at __init time

Suggested-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
---
 mm/page_alloc.c | 59 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..c3054e40b95b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7083,7 +7083,8 @@ static int __alloc_contig_pages(unsigned long start_pfn,
 }
 
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
-				   unsigned long nr_pages)
+				   unsigned long nr_pages, bool skip_hugetlb,
+				   bool *skipped_hugetlb)
 {
 	unsigned long i, end_pfn = start_pfn + nr_pages;
 	struct page *page;
@@ -7099,8 +7100,42 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		/*
+		 * Only consider ranges containing hugepages if those pages are
+		 * smaller than the requested contiguous region.  e.g.:
+		 *     Move 2MB pages to free up a 1GB range.
+		 *     Don't move 1GB pages to free up a 2MB range.
+		 *
+		 * This makes contiguous allocation more reliable if multiple
+		 * hugepage sizes are used without causing needless movement.
+		 */
+		if (PageHuge(page)) {
+			unsigned int order;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return false;
+
+			if (skip_hugetlb) {
+				*skipped_hugetlb = true;
+				return false;
+			}
+
+			page = compound_head(page);
+			order = compound_order(page);
+			if ((order >= MAX_FOLIO_ORDER) ||
+			    (nr_pages <= (1 << order)))
+				return false;
+
+			/*
+			 * Reaching this point means we've encounted a huge page
+			 * smaller than nr_pages, skip all pfn's for that page.
+			 *
+			 * We can't get here from a tail-PageHuge, as it implies
+			 * we started a scan in the middle of a hugepage larger
+			 * than nr_pages - which the prior check filters for.
+			 */
+			i += (1 << order) - 1;
+		}
 	}
 	return true;
 }
@@ -7143,7 +7178,10 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
+	bool skip_hugetlb = true;
+	bool skipped_hugetlb = false;
 
+retry:
 	zonelist = node_zonelist(nid, gfp_mask);
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
@@ -7151,7 +7189,9 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
 		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
-			if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
+			if (pfn_range_valid_contig(zone, pfn, nr_pages,
+						   skip_hugetlb,
+						   &skipped_hugetlb)) {
 				/*
 				 * We release the zone lock here because
 				 * alloc_contig_range() will also lock the zone
@@ -7170,6 +7210,17 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
+	/*
+	 * If we failed, retry the search, but treat regions with HugeTLB pages
+	 * as valid targets.  This retains fast-allocations on first pass
+	 * without trying to migrate HugeTLB pages (which may fail). On the
+	 * second pass, we will try moving HugeTLB pages when those pages are
+	 * smaller than the requested contiguous region size.
+	 */
+	if (skip_hugetlb && skipped_hugetlb) {
+		skip_hugetlb = false;
+		goto retry;
+	}
 	return NULL;
 }
 #endif /* CONFIG_CONTIG_ALLOC */
-- 
2.52.0


