Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4478CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41268E0002; Mon,  1 Sep 2025 04:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4668E0020; Mon,  1 Sep 2025 04:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997788E0002; Mon,  1 Sep 2025 04:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8014D8E001E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:34:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 41EE91A0705
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:37 +0000 (UTC)
X-FDA: 83840020194.19.626534C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5C1F14000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ccNbs/L9";
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dv7lsuIJZIRBm5QDytCKVImcWOXPmXFLiaKyOBFM/fY=;
	b=PH/91uRfJuNNMAWx0477rjJ3Jb3GiJUTGLnEyJdtZf9ULTEq5G7z1RhW7dbcojOxlVTeHZ
	Nk1s1q7WGVqF6WErujrT85bVsybrQsLQQnKm4xKCREsT0GTpze+CvZbj9rXIrL+U0A6Ylq
	Fw1y/d/TadJEEdqKW98hZZmATeS2wqQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ccNbs/L9";
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715675; a=rsa-sha256;
	cv=none;
	b=PNW19ByaGi0N3+SeiyT2qVK2gytDvwHAdTEVs1MrPxBQL9dMqnPsy/unV7p7nXOaa6jCIX
	Q1NHz8n/AHUMg6ejGYBNXEsc6ZdRYvVP7qOE79mz/1POQi/M6vDnvYaB+LMDg7S20iOm43
	Kw37TOU5No5cpM6Rhdocbl85mOsFFV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88321406F4;
	Mon,  1 Sep 2025 08:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D79C4CEF0;
	Mon,  1 Sep 2025 08:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756715674;
	bh=mvEQOsEFmQKxumWhkG3GRFqxyOYNW/2qLceb9dOfvtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccNbs/L9dVqFOOgoQvr9r40GsGBiyS+d0rxD7ojEapK7eBD3HEkPqKAvaYYkNgDu6
	 mMU8sqZ7o7T5wdPyCDHApLqAMv4Q19hB/+ZxY+6kay1Df0zwYwNXZLeZE+x1EiBVdr
	 CLZT+ln/eWuAc57ZofXTPMknYKRNPl235FoIeOoiKnl8I53dkZ9ko2mxb+IC3cvk2K
	 oDBgtSKP6+35016qAt9J/OI30vFGezRB7YrZ5JScYbIy3+A6M71aKIl2SWPCy32iyB
	 RRvaobo43O8CbuNFK+Z3MMAuVjbBuvpxTgj+VSWQ9XVpIZUxuC+xmLlpYF/ZxNFZ6j
	 wfIrTSHpObmqw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 1/4] mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()
Date: Mon,  1 Sep 2025 11:34:20 +0300
Message-ID: <20250901083423.3061349-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250901083423.3061349-1-rppt@kernel.org>
References: <20250901083423.3061349-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A5C1F14000F
X-Stat-Signature: edu6u8iopx8ff3az1try97dx9t7jhc6s
X-Rspam-User: 
X-HE-Tag: 1756715675-217992
X-HE-Meta: U2FsdGVkX1+6iul41ujqi8M5O6uLkwxnb5y4WmFn2jsS5Ice65ZDbXm1VMAuxfl1c69FUENsWwG8S1AEtnxIUnbM3hpZfUg5i/kkJgZu8wJXe8GXHvoA84aq9Gkjkgj6tNJqWQfpdK50/O4N+oF4tPWMRvtk13Olr8+AJq/4GwlGI7KeCNiPhuWgTRa1ffVPFvodr2r98RszUPLWYuXUhnKlGXmzsEeZ11mawnDNj1X7sJYxte0X+IEQJCmYCK0zkChuveKCtEBbapu5om1Q+ZkJZSXm5QYXVoY0ceqws6cN0kfSIz+prpMMx4yqNMW6XlKMfUxPX3CcMMIh027ug+MI4KNCp44O2c1Wl5mG8YrDGFaN9n8QmbQoNxZPu83of1JIX8Ye9xCqX2DObY/VuE6AfsXv4LiTz+1RRJQOLMi+sO3Qj/+3ll1lP6wJ/p9syvf8Oj0n/gs6fQQ4DPQ2taBrRL2zE9Mnk4+pr+pT1DPX/64/DngGgQ4ou9mblQX1eMSCrw3Mj+N/535bF1T/Irx3SgGhD7HSNfEUVz+w2JzrreUZJoUoJhI7IQ/3YIq+fnN+Bpuao+HgvIyu0bgH3QHp8ePgYQk1mqgOW+E/jSgeEdFhXBYNcgasEAigbEO/c253ez//bJzvGez8eE2ySlwJaypAHbgARaZYyJJ1lF4RONGFt29K2BO/gfoEf21ece9ic8LbgcaeW2bttvBXgTrg2iUHDZBfP10Fs1xFjRh1lPfa/A60iHuuQBMRIYlhePRu/kobv3ucbI8K06kaY2My/hkKfxWN6KJNMqrq3d2gyGlSJfncUIgmApCvQ4JPKwpLO9y1Zz2EQNAgVdGN9NvIjQtMMR06rXyPBImApI9pcx+TGdWPtW3LI3GyIRY8cVk4IeQ55UHjSJBNKpddqEzfrI8+neoRf91KDXDqpC2nvJVHadtbjURmfVXmx+MRVd2vUzU4OXzVGpT1dww
 kIEcMoxl
 r55ob78MOD6SmOEqlgcr1IbPujfK0Ozg9uM6Ju4LLaY7p+0C4XElpOdC9fHNFLJfZF8NDn3hTcIo8Y433fJZXkfYa2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

deferred_grow_zone() initializes one or more sections in the memory map
if buddy runs out of initialized struct pages when
CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled.

It loops through memblock regions and initializes and frees pages in
MAX_ORDER_NR_PAGES chunks.

Essentially the same loop is implemented in deferred_init_memmap_chunk(),
the only actual difference is that deferred_init_memmap_chunk() does not
count initialized pages.

Make deferred_init_memmap_chunk() count the initialized pages and return
their number, wrap it with deferred_init_memmap_job() for multithreaded
initialization with padata_do_multithreaded() and replace open-coded
initialization of struct pages in deferred_grow_zone() with a call to
deferred_init_memmap_chunk().

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Link: https://lore.kernel.org/r/20250818064615.505641-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 70 +++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b..e73f313dc375 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2134,12 +2134,12 @@ deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
 	return nr_pages;
 }
 
-static void __init
+static unsigned long __init
 deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
-			   void *arg)
+			   struct zone *zone)
 {
+	unsigned long nr_pages = 0;
 	unsigned long spfn, epfn;
-	struct zone *zone = arg;
 	u64 i = 0;
 
 	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
@@ -2149,9 +2149,23 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 	 * we can avoid introducing any issues with the buddy allocator.
 	 */
 	while (spfn < end_pfn) {
-		deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		cond_resched();
+		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		if (irqs_disabled())
+			touch_nmi_watchdog();
+		else
+			cond_resched();
 	}
+
+	return nr_pages;
+}
+
+static void __init
+deferred_init_memmap_job(unsigned long start_pfn, unsigned long end_pfn,
+			 void *arg)
+{
+	struct zone *zone = arg;
+
+	deferred_init_memmap_chunk(start_pfn, end_pfn, zone);
 }
 
 static unsigned int __init
@@ -2204,7 +2218,7 @@ static int __init deferred_init_memmap(void *data)
 	while (deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, first_init_pfn)) {
 		first_init_pfn = ALIGN(epfn, PAGES_PER_SECTION);
 		struct padata_mt_job job = {
-			.thread_fn   = deferred_init_memmap_chunk,
+			.thread_fn   = deferred_init_memmap_job,
 			.fn_arg      = zone,
 			.start       = spfn,
 			.size        = first_init_pfn - spfn,
@@ -2240,12 +2254,11 @@ static int __init deferred_init_memmap(void *data)
  */
 bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 {
-	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
+	unsigned long nr_pages_needed = SECTION_ALIGN_UP(1 << order);
 	pg_data_t *pgdat = zone->zone_pgdat;
 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
 	unsigned long spfn, epfn, flags;
 	unsigned long nr_pages = 0;
-	u64 i = 0;
 
 	/* Only the last zone may have deferred pages */
 	if (zone_end_pfn(zone) != pgdat_end_pfn(pgdat))
@@ -2262,37 +2275,26 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 		return true;
 	}
 
-	/* If the zone is empty somebody else may have cleared out the zone */
-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
-						 first_deferred_pfn)) {
-		pgdat->first_deferred_pfn = ULONG_MAX;
-		pgdat_resize_unlock(pgdat, &flags);
-		/* Retry only once. */
-		return first_deferred_pfn != ULONG_MAX;
+	/*
+	 * Initialize at least nr_pages_needed in section chunks.
+	 * If a section has less free memory than nr_pages_needed, the next
+	 * section will be also initialized.
+	 * Note, that it still does not guarantee that allocation of order can
+	 * be satisfied if the sections are fragmented because of memblock
+	 * allocations.
+	 */
+	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
+	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
+	     spfn = epfn, epfn += PAGES_PER_SECTION) {
+		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
 	}
 
 	/*
-	 * Initialize and free pages in MAX_PAGE_ORDER sized increments so
-	 * that we can avoid introducing any issues with the buddy
-	 * allocator.
+	 * There were no pages to initialize and free which means the zone's
+	 * memory map is completely initialized.
 	 */
-	while (spfn < epfn) {
-		/* update our first deferred PFN for this section */
-		first_deferred_pfn = spfn;
-
-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		touch_nmi_watchdog();
-
-		/* We should only stop along section boundaries */
-		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
-			continue;
-
-		/* If our quota has been met we can stop here */
-		if (nr_pages >= nr_pages_needed)
-			break;
-	}
+	pgdat->first_deferred_pfn = nr_pages ? spfn : ULONG_MAX;
 
-	pgdat->first_deferred_pfn = spfn;
 	pgdat_resize_unlock(pgdat, &flags);
 
 	return nr_pages > 0;
-- 
2.50.1


