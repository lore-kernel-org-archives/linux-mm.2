Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41450CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6356B00CA; Thu,  7 May 2026 18:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AA76B00CC; Thu,  7 May 2026 18:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A276B00CD; Thu,  7 May 2026 18:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0696B00CA
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C4F48D1CE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:09 +0000 (UTC)
X-FDA: 84742050498.12.14BAD0C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id CA5D318000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OMsIBB8T;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzA2kE2SxyD+isdRkzcnXWm71tDaAigOtuMMAbID/Ow=;
	b=Mtryl4eqV1YNCQz0T+qhIhZPZv0GX522ch42D+GtTGuuTH786AyVFzM2rAMzAzfTraOtFT
	XLf66bUcLYY0j3Q6Hi1gdo9xljw/UV7YxhE2bv0RDGeBs13WPIoz94XlBlSviwEun6u0Vz
	VIs2THpZv1wFTyKgHJlL4t3rBoYC5T4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OMsIBB8T;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192586; a=rsa-sha256;
	cv=none;
	b=DS8lhhijbZxKm/Mw/1dsHjdIKTTHdFbAHRAw1tkBIy/9le/f8J+IQQNcVhWkxeP8ul3+Ij
	Lu1LDMAFv3z4pf6a10AxycrwIiJnfHTUqtOqxj4vfMSKaOpSv4RvC4sSBVW1dF6tgyRRYS
	m5yFb771Bqk/+T1BV4kWHxggHmOC7ZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzA2kE2SxyD+isdRkzcnXWm71tDaAigOtuMMAbID/Ow=;
	b=OMsIBB8Tv/qOyvW2GXC5gETH1FMXWbAijClhH5blkBW7HwUN+kEMRrHZkPlqX7tPhBgrbt
	MfMn7biPX1806Ph4PKRCWnpd5vaQkxIcUDA3CoIWMS8j7FuPa1Ndors2I1S171mSrvEs38
	0KMedi5M6pIF4hfLYRqplizch2uCTnw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-UV0pcyqLO_qmxGqfjmJGZw-1; Thu, 07 May 2026 18:23:05 -0400
X-MC-Unique: UV0pcyqLO_qmxGqfjmJGZw-1
X-Mimecast-MFC-AGG-ID: UV0pcyqLO_qmxGqfjmJGZw_1778192584
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-449b2a183d3so879819f8f.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192584; x=1778797384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzA2kE2SxyD+isdRkzcnXWm71tDaAigOtuMMAbID/Ow=;
        b=iOUC6mbC077/n272ETOvlTLjPK28dNMTbLA7CUpIZcvETxF+MJUHo0GvhwuLn5olK7
         VqV1IiV2Yw/djICpiIs4QS+C6BsOxrJzWMs0pxdUSEkuTyoRH9ugQh9PqHOFSXv58t+S
         +WxAFpgatJO9qAMtWBtlgfuyNPpYMIn/krKOnXu7UF5AhbHZ/XAOGhhpT5Ub5QLtzuAy
         VZj8lNk/f1Ns0/2+BX9zR9HdkcmAEBsAkT+6L1HLYFTXDLnYR/gvVhxJCbVO+P4jOEG2
         1mDE+tu7dkSvoh40D32nrJioAFxwRF7VXTCw0E9UJ3va38c3wmRfxWwjhcRJyhkx1WD2
         E9yA==
X-Forwarded-Encrypted: i=1; AFNElJ9Y0fuDsv7UabQKHBo7bmAoDpk7PnaA8n3x3C6MJUWYHTrY++XWW9EDhMP4pSFvqhmCLfRXaBIRzA==@kvack.org
X-Gm-Message-State: AOJu0YxNi4JWEw+pA/GbVoswecvT95lJn5n5OjIeCb7ZhdeDccWMpdx1
	4WY4SS5dEFhUt2YB4GrMeD950nHwHerNJz8zbgWbQhUctG+VIaVYGM2JiMTsenqQO07ncODB2zW
	glzbxW9pBWkiScgmYcSDIjmIuPTyI8zdlkaHrd6XD2aF/aGP4G6rq
X-Gm-Gg: Acq92OHgjJRY6ZxWzYOiz3AG8qxOeo9n9Lts+Tr5ev3lthYPr4q4FKRuJiAoQar2H3N
	sNLmF03yxJzJnMw6Yky465M2lEbAW7CEyeUwOAhE7dKxNJEp46H/7eThQ1ZZHBOkGf/CeL+dZzx
	VP6Wp2kjJltRjEwwbyucbryeSIMbj+CjFd+pF8vNwGOe2p4FmVWf7/Gq995bBMex9b3SFIDa5T2
	gKImLCQQR2yL9u3NlB0eQReT0DzFtoC7yxVo7T1jpw1PJySMzz42aWXPQVn28XrAqDPInJCoW/a
	WjWvkjwn8+WNkAWFCT5UGRKA7hH+cKfZkndazdKMcVVRy8csus+z54a7va+XqQh8S8xOhEsn2OQ
	55bMbI4Ls8ZcpCY2dClRYnpAwweEU1mkM7KtsYV2f
X-Received: by 2002:a5d:5e01:0:b0:43e:531f:720c with SMTP id ffacd0b85a97d-452e96d51bbmr7220455f8f.11.1778192583588;
        Thu, 07 May 2026 15:23:03 -0700 (PDT)
X-Received: by 2002:a5d:5e01:0:b0:43e:531f:720c with SMTP id ffacd0b85a97d-452e96d51bbmr7220413f8f.11.1778192582995;
        Thu, 07 May 2026 15:23:02 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4541721bab8sm1995822f8f.27.2026.05.07.15.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:02 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
Subject: [PATCH v5 12/28] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <d6e71df21e25ee49540571f7816a241cf5e00145.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O7kF-3i6s_M45-_qW852blKrr6iIbT0K8U4m1ts6KaU_1778192584
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA5D318000B
X-Stat-Signature: nnpuq4hhqz7dhhng64jzq1hanpjs7dkr
X-HE-Tag: 1778192586-807255
X-HE-Meta: U2FsdGVkX18G/yFBoVNBUpPYMEwk6sTIvCqq1tR5QyxHyDjLmiJK/fJ1la712m1eEQqZoY1dz9t52xEAXx6PMu2k6prb9ewFDn0Q7fgdeayr5E4A56GTuIkoaaxqFU4yElcoJOTqrCNH+ds0UMf51Q10U+OBzvd5YRXWsPeW07KoxRGi6n4p89tFPajfatF0KzBiRX/Sq50+NPp+mtmfEeDTLJFjM/nvgB5iJigJf54YJEhmmm4j6niShloZOB7UXEo8qbomJcyotdUdPtUvxbA22opjyrtNYGK1WEUPvUr2+jQfeAedagYrtxsRkDQoIyqhc72jt7+1y74RZRraT7hCn2QAMzMqJDykzPSmYS86LLKJ1Qrr7f8sBPWr6XrZg372OVZnPJzfORKBMbNGSRG+igOeyXZnC6QN0aYOt3hy3ECw5m3Yb7puc73oqhjKRY3vhwNoj74bMiB4PjHFiTp5SkFFhit42VOVupLspdOtkQM/u8LtQg2SocQdPJV85VUeCy6rtCh4YO2uklu+IyOmpLeja9WSifotNJYp7ZFJ9cD81meWzE2/FwaLcaD5zPWgs/Xkk1jLKgd9tu5o3IvJ6E9mbTstUhgmFs3ycLWmj79EafH11JRUGM2qmZRuMReky7iCGiE1uYed4720D3rdgP2/9UYjnd4EOL0jr+by3gCGQ6TvKCxZ7SKu9r8aZTYOct2H/XVsrluenSDY8xth7aP2dbVkoFaN3O9mCpyiWNFf0yhXWfeRyus/1+O3z1Vaf819AtK1b0yTnx1jLu3HDhkhy2qzeckNxYmfHUY7AhT2PrZK0S2HyJXprg1xR4BPAfur8kMBJM+Gh8g2g36anKv16HIZ/dLAeWCCgPzRiE98Tm8szretNmcvapqv5vH59bC3S/ATL8QU6QKNui6S1fgxIZmHpJUqv8x/1EF5I56MhdsO7Xcua/27nkmI9rSAd/tmPZHfIBhyVM6
 FSxRpvi4
 WRQvoWjCmy1CnVBTHjQrBAYaSUoQxyAtERyyQ77aked16Yr+KdplJevRQ7yccvObG9kJYdcMRN620tp+QlGtQ3w2gMCqVwsobm7TAfStKo7+leXUgNTYgLa1v2s2JLz/61Um166zqJ1cf7sFnmE3IRKxs4l9dj1aNkdGQXa0LyTjaCwI7tlqSEqpa8bLwbGWwo37dWLh0hUU0s+druweVD5yjQWmXj+RMHNGrlrrRumElnxNAe6qhudcP0BZVsnMm7JGk8HiPN+HDJ/NPy+H+CRLm3V6X1spDF14I8Eq5dZ5nIXSt//5g0wSmCU/dPARUSDSTb8z5oM8kf3mA1jb8lOifV1YQcWZJ0xKIFhq0etE4IaM3mtMcAb1zgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gather_surplus_pages() pre-allocates hugetlb pages into the pool
during mmap.  Pass __GFP_ZERO so these pages are zeroed by the
buddy allocator, and HPG_zeroed is set by alloc_surplus_hugetlb_folio.

Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
callers can check whether the pool page is known-zero.  memfd's
memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
when the page is already zero.

This avoids redundant zeroing for memfd hugetlb pages that were
pre-allocated into the pool and never mapped to userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/hugetlb.h |  6 ++++--
 mm/hugetlb.c            | 11 +++++++++--
 mm/memfd.c              | 14 ++++++++------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 094714c607f9..93bb06a33f57 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -713,7 +713,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+					  nodemask_t *nmask, gfp_t gfp_mask,
+					  bool *zeroed);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1128,7 +1129,8 @@ static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b5bc2a9f5022..ad536d7aee59 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2241,7 +2241,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2257,6 +2257,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		h->resv_huge_pages--;
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (zeroed && folio) {
+		*zeroed = folio_test_hugetlb_zeroed(folio);
+		folio_clear_hugetlb_zeroed(folio);
+	}
+
 	return folio;
 }
 
@@ -2341,7 +2347,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
 		 * down the road to pick the current node if that is the case.
 		 */
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h,
+						    htlb_alloc_mask(h) | __GFP_ZERO,
 						    NUMA_NO_NODE, &alloc_nodemask,
 						    USER_ADDR_NONE);
 		if (!folio) {
diff --git a/mm/memfd.c b/mm/memfd.c
index 919c2a53eb96..4026fda71762 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -69,6 +69,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
 	gfp_t gfp_mask;
+	bool zeroed;
 
 	if (is_file_hugepages(memfd)) {
 		/*
@@ -93,17 +94,18 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
-						    gfp_mask);
+						    gfp_mask,
+						    &zeroed);
 		if (folio) {
 			u32 hash;
 
 			/*
-			 * Zero the folio to prevent information leaks to userspace.
-			 * Use folio_zero_user() which is optimized for huge/gigantic
-			 * pages. Pass 0 as addr_hint since this is not a faulting path
-			 *  and we don't have a user virtual address yet.
+			 * Zero the folio to prevent information leaks to
+			 * userspace.  Skip if the pool page is known-zero
+			 * (HPG_zeroed set during pool pre-allocation).
 			 */
-			folio_zero_user(folio, 0);
+			if (!zeroed)
+				folio_zero_user(folio, 0);
 
 			/*
 			 * Mark the folio uptodate before adding to page cache,
-- 
MST


