Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C0ED44C5A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029CE6B00A3; Thu, 15 Jan 2026 09:46:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFB76B00A4; Thu, 15 Jan 2026 09:46:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC056B00A5; Thu, 15 Jan 2026 09:46:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B50E56B00A3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 724428B697
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:37 +0000 (UTC)
X-FDA: 84334474434.15.C9AA7B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A6D612000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAelqERT;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488395; a=rsa-sha256;
	cv=none;
	b=vUFclqh28ABk/ous2HbDRbmBl/khG0G2VjDu68JUZYnypIxmb5+UHLj5QyXGsJx1aUdnIl
	idzazNApeFt0fFEg5VxAzWKmma1SRaJ0KhyQsozHC8fTNnCgadMejtlDlrUBMtfdanJdza
	0EZUAlhDF7GA0K0T6raxzgpu54rluQg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAelqERT;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wz4MBNlnHwH3bqPwVRbn5F23ABmEX3yOqEcelCTBQWU=;
	b=8Zv/Q1uARyhiMEyfXNPvRnVqo7S0sPnTFH2EB0SASXs2R9s8N3ZHiC7TFUHk4NiD9JB+iT
	Jxf8N1YlK7f+q6l8M6RrPekzSj8/O2dDGukRlTG6bURvru33mmbzZ+bHm4BKpxX3we6Evr
	xM+w2JF1tIsmyTXy2wJ+uVvYVcd3pNI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E0AF44368;
	Thu, 15 Jan 2026 14:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6875C4AF09;
	Thu, 15 Jan 2026 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488394;
	bh=HdI2DN25qqaNRHiMcOMwkD0s20/vCqB8MRYI0Frqk18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAelqERTWP5khOctgvKCsEaUvSTJhRUnR/A2GJLPL1Zj/Y+Gx8hJdJBONvZE+rbUt
	 FhW1M0qP4pkgOZv2Bh2emL8Vd/L2arg+xMAEsbgK/MPdLywF0lNRz6AeX3HRpnG9Kd
	 5CFurJIzXh0TUQ2DEjh6T4fdSkS2Y4DbJFifncO2c6e2E5yjh0kZdjZ0lGAVtdZLbX
	 RftmxQLWnsXK4K737qkUdieMPWXY1te+C/Qe5w6815IfjDcQIOpSMDCym+o7hLm6AS
	 sn71EWWDI+t6eEguPJh0FXb2CSd/k+2TI9pu6+2nrjbvXQc9yEfqs7lmTiZQJWlF4s
	 4h1/CbLntkQhQ==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id D1ACBF40068;
	Thu, 15 Jan 2026 09:46:32 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 15 Jan 2026 09:46:32 -0500
X-ME-Sender: <xms:yP1oaZNc0EUyTNlVNlYfWRuelrd_wAx72AMovzndnlCMgNhLcxdPTw>
    <xme:yP1oabO0HeMCwJfU22-BIu82he9X5QY509Iidl5EmhdYbe_bHIV7w4Jd86JE-vUCx
    WSeQBaQ3b8TNaj2U3nmSDBzBsDmwCwvlvC4yqGdk1Woy1Y0h301ig>
X-ME-Received: <xmr:yP1oabG2YU2Wc9wA-fS3K77PB9qXEsn0Tv7fnJcRZ25I34XAbPqzjhSEoWBGow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffkefffedugfeiudejheefleehteevtefgvefhveetheehkefhjeefhefgleej
    veenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhi
    ugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdp
    rhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvh
    grughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:yP1oadOmuyJyPYXAN-99pAySLV-AFq9ANy8yarUdWBCKHCePc5q2fg>
    <xmx:yP1oaVvil1mUmzg1t5zEgJWVDgMA89DfJMNZpmkj1fmjonSXnl6IUQ>
    <xmx:yP1oaaVx8Ay3QaRcngxup5Iv8g-92KxaCxHEl5MF4A76vpJJ3USnCw>
    <xmx:yP1oaUSIqmsUKTwOrekYGYLeBmuq2U2QtYwnYTye-XsESv7dYWnm2w>
    <xmx:yP1oaQIHLPh_8PdUSCY0UssyjtJ8BW3mkquu6RfQnhA5hrdacoM4Ap58>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:32 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 15/15] hugetlb: Update vmemmap_dedup.rst
Date: Thu, 15 Jan 2026 14:46:01 +0000
Message-ID: <20260115144604.822702-16-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zw5drcdu3ghb6k9888yxfzi38dcre96i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A6D612000B
X-Rspam-User: 
X-HE-Tag: 1768488395-392369
X-HE-Meta: U2FsdGVkX19LPetULUcC5qWyQ5OsjHgoGhhaYaO0Jt4sSGvrL2IaCDPcbgOJ9RugVQADaF8NGvVqNGnG1QF8czi/r+neKoR7qgwavP8yo/37JnGHzqEszY91bkDbw4BZ+dOSKMCYud0Ur+BVK0dHa2wd5i1kA53B3CQzsxlK27ZhaZIv0KMbqPi6/qA9/NYIVFLw9KsgDwaWzpxA3zOsXAKy4H6OK3veOjWZUa6ivDogAWTYpEMut+j6PI+I6zahaZg2JEu+166/Sy96ZDBv1s/VclMKbqTja/fMCDn31Q8IStyEB3a1DTZm3iUDFrrgYfYzPZ6wWhya4SvXkkAaA9lHN/Vp62cP4uPIN677r1/WhyMlJiqZqugwb+7N0rpRJ+cFEjlJaZ7WqyEvyP1D3CyIoAkBdHRy2g26/bB10JhkpmlNBR/Ru+MMqqVeTVzunx4DBB6gJfbU73C4jt9PSVF3s3a0E5PHnxjWLnMoiSXhigW2Wuv0PoDYkS1Qa6BNRtnRStwNeiew3Zix7iiL+SnbKkU0OM7ZQPNIuT6If3zdsMCz4fD1Tv1lHS1hPHkTFA42fzVcjdvWMK0F78oKlnpgOKHk5/+oPjMzLmHW8ywAl8DyL5CvSLMemxCUjAJNvLXnNKjmCg/p/PjqspmwihxjZfpSu3JoVuKhX8zs/gMYkTAutKr92bMIH8fGjYAugCtuj504yamAfbETxOQ5trtW3zTLHIx9mhQoFTB8L8uR1ZwBxoxwNckQnk2fRfkwEKYFb8ITcHW0BR7/dgCn6ZP8rR5zjb2zuVmPMbXx+wxREm30DOHqxfL6wFRvwSoAeQsthPR2bxL+b8Q1DauqdokmWuNBeqPGNArpveE3R2iJnJsPewpVi5cZCZTW8B1eTmVBwtB7NzuisniDRH7txfafUbVY33A/McICRww0B0tNSz06w6XJdVlbuMMZTvmgfNAqkl9bZITVW9HivkV
 J3rnT+/7
 fcjaCuNbp88fZuQgi2DBTE9Hwcn/hsmEryCZsj2xq4aVihfGFfcGgKHAj2ZDEUCUGOk6wZMP+caCaM1Z4p944WFvMO18AtAVejfzLUAQsWszk1ojeQTrbEpmEitlJlI/hcIPPkYQW7hL21grJ3jtBOjS2YyQXVGwgIurL2toEoaRw4FRgblAw8rHbKMiywkuSgYt1ZPcyIAI6cc7lgAyM57Ts+IP4fRUYTCroumJXdyA4Mm9uRZWl5K9EW0X5vbE3EJqvfQOqHFbfb5QGbpDQBS0bBakxG5BKxq7t7qa7YcCrADx1cYBRqpQ5WEHYk0Ssg3CfrBQj8wIa6MwcYovY0iviMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the documentation regarding vmemmap optimization for hugetlb to
reflect the changes in how the kernel maps the tail pages.

Fake heads no longer exist. Remove their description.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 1863d88d2dcb..fca9d0ce282a 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -124,33 +124,35 @@ Here is how things look before optimization::
  |           |
  +-----------+
 
-The value of page->compound_info is the same for all tail pages. The first
-page of ``struct page`` (page 0) associated with the HugeTLB page contains the 4
-``struct page`` necessary to describe the HugeTLB. The only use of the remaining
-pages of ``struct page`` (page 1 to page 7) is to point to page->compound_info.
-Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of ``struct page``
-will be used for each HugeTLB page. This will allow us to free the remaining
-7 pages to the buddy allocator.
+The first page of ``struct page`` (page 0) associated with the HugeTLB page
+contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
+pages of ``struct page`` (page 1 to page 7) are tail pages.
+
+The optimization is only applied when the size of the struct page is a power-of-2
+In this case, all tail pages of the same order are identical. See
+compound_head(). This allows us to remap the tail pages of the vmemmap to a
+shared, read-only page. The head page is also remapped to a new page. This
+allows the original vmemmap pages to be freed.
 
 Here is how things look after remapping::
 
-    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- |           |                     |     0     | -------------> |     0     |
- |           |                     +-----------+                +-----------+
- |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
- |           |                     +-----------+                  | | | | | |
- |           |                     |     2     | -----------------+ | | | | |
- |           |                     +-----------+                    | | | | |
- |           |                     |     3     | -------------------+ | | | |
- |           |                     +-----------+                      | | | |
- |           |                     |     4     | ---------------------+ | | |
- |    PMD    |                     +-----------+                        | | |
- |   level   |                     |     5     | -----------------------+ | |
- |  mapping  |                     +-----------+                          | |
- |           |                     |     6     | -------------------------+ |
- |           |                     +-----------+                            |
- |           |                     |     7     | ---------------------------+
+    HugeTLB                  struct pages(8 pages)                 page frame
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +----------------+
+ |           |                     |     0     | -------------> |       0        |
+ |           |                     +-----------+                +----------------+
+ |           |                     |     1     | ------┐
+ |           |                     +-----------+       |
+ |           |                     |     2     | ------┼        +----------------------------+
+ |           |                     +-----------+       |        | A single, per-node page    |
+ |           |                     |     3     | ------┼------> | frame shared among all     |
+ |           |                     +-----------+       |        | hugepages of the same size |
+ |           |                     |     4     | ------┼        +----------------------------+
+ |           |                     +-----------+       |
+ |           |                     |     5     | ------┼
+ |    PMD    |                     +-----------+       |
+ |   level   |                     |     6     | ------┼
+ |  mapping  |                     +-----------+       |
+ |           |                     |     7     | ------┘
  |           |                     +-----------+
  |           |
  |           |
@@ -172,16 +174,6 @@ The contiguous bit is used to increase the mapping size at the pmd and pte
 (last) level. So this type of HugeTLB page can be optimized only when its
 size of the ``struct page`` structs is greater than **1** page.
 
-Notice: The head vmemmap page is not freed to the buddy allocator and all
-tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
-more than one ``struct page`` struct with ``PG_head`` (e.g. 8 per 2 MB HugeTLB
-page) associated with each HugeTLB page. The ``compound_head()`` can handle
-this correctly. There is only **one** head ``struct page``, the tail
-``struct page`` with ``PG_head`` are fake head ``struct page``.  We need an
-approach to distinguish between those two different types of ``struct page`` so
-that ``compound_head()`` can return the real head ``struct page`` when the
-parameter is the tail ``struct page`` but with ``PG_head``.
-
 Device DAX
 ==========
 
-- 
2.51.2


