Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209A6CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37318E0010; Mon, 18 Aug 2025 02:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B102B6B00C6; Mon, 18 Aug 2025 02:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BBC8E0010; Mon, 18 Aug 2025 02:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 904B16B00C4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:46:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D1AF16076F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:29 +0000 (UTC)
X-FDA: 83788944498.26.4B2C47A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7DC75A0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+XFnarF;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WlRsynIN5HAwN4RgC9dOMXqy1cX7SD7Ew2VpLaZuWo=;
	b=Al6w+j92zNtfaWGjzoCaQodQbjvz0ZJ4QHrIFUdCoO53RJPbMHmqJ9Mu8WeAS9KSo5JHP8
	75iac81cT1jXDbzQoBfeAVtxCQG26w/GRgFACOWpWyuXkULLlD1mjvARIJUgzLYXNNIQcj
	oyQGJpWNea8ve52iZBamJ1CwoXu9uFo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+XFnarF;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499587; a=rsa-sha256;
	cv=none;
	b=Yk6gn1zR7ib9NiHQgJiDpQFcg4rcGfDJSsghNmx6sx2TnOhu4TBdAGici3pHJGYG4UKvVQ
	I3kDq1ci64NZhI55H0GfVKuKNvLIXvuRMYEQ3WCZFnwr+psvzR8p7mgDf9/ls9YQ62v0Jo
	B9Brmg6XjYNrTVuxjaGbAEd9lnb9jZ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9163D45CB5;
	Mon, 18 Aug 2025 06:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672F7C4CEED;
	Mon, 18 Aug 2025 06:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755499586;
	bh=ToPABIT8QK9PCW9+WkqU/491rrTUTTVEcOSU5pzOhyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+XFnarFgko6oqbL2InH2xpcouOfZmq8dhXw2n1dYcgxlqdklKMK26ttMOjscc/Ii
	 8SsSFXJbsnFLbOWyXC/dkPDp8N+OUGJjai17davlyrFyQm+sgjfZU06MuPCTkcbGWs
	 ueBHZNPFmLMMyET/B9l1AOkSAk0yF2H6uigdq40qxcQvHhPIQ526VKbKXVy96PS2SZ
	 xkLc6fAOAKMMORb7nzJiijwQpgG8NhDAb7ffVgaL8vDCLNYoU4FbM1BW24vLnYernK
	 6muOvZmHPwGsDBj/3HtlhJ8OxXbm54tiQ5b8aNRLesdGAEy0jas8VvOhqtcLZcFzv+
	 SaGKf8uF57bGg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH 1/4] mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()
Date: Mon, 18 Aug 2025 09:46:12 +0300
Message-ID: <20250818064615.505641-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818064615.505641-1-rppt@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7DC75A0006
X-Stat-Signature: bhzg1fp9fcqdmqk5zpzhg1ohcd59m9gi
X-Rspam-User: 
X-HE-Tag: 1755499587-563881
X-HE-Meta: U2FsdGVkX1+OJGZqpxE3YsrusPaPuoQn2nLZjm4UHKtbZVBXe4hj8MstkIk8Vlzms34HXL1c6ThocNB4L5p2NuViVmz2YBKlDfWrAWRhlvDUklscngP5zDlEG83VOtkk1Vp007UyhgL1byBVNgtOQ0lcdL95ErQSwtQARXkBjAKlhkYIG09FrLkYsIWZuYn/pomLYMEG6znERNaWflXaDLSrNIwokEea5iGymHQrwmpU5BbE4bTlYzMpn/Q8JEhSyJXYbgv4ygXbY8KCA8YKXxw08mfJtEh4wPXG6OHrnAKuQ91a8f9+DFYNKcxbHEc2+jFHJC/gh+4DvZIySZ513RfWGuV2j0+4o5v6LtqCXmBDXLVZjY2+87peTMf97DFibSm7F+TcmzOFFjV7/6qnF+yyBlGZBxvXIiIE8ypTGq/VuDW73pnMUoH7z8cuVnoldXnXJknctHriB7iWQZNZeN5kTTnLNxB9fKC3GgnMu+g8WzTAoL5Tvj6NA2pSbX7WGI1izaIy85YRwm7dG1E2RJ/shZ1l9aG1nb5zR3tBcYW3SDplLpjazpzCYpMTxFFmblZmQKefKo5Eja4shFftFhLR0nHQ+m7zE9ykBoByk1hL46wycJeq5raQL9LH0OB+SOJlRQaJTvICkd9wa/Kno3v0ROBBpiYJ/uFyPHLACfh4pVX1KYy/7RZVAZx2mHBJ/55OR1zKXH3iQD401MmMHbDoueS3TACXQF6e936LdoIZc/sWwYUDck6JIGQQOTpQn4DaPVOWl5p8/TGq5WCd2GjIBFDEanaVqk23AtOideKgLle79CSLTM5MSCqSy3svxTxUz+WFNDMlczSB4hXSKvVpVKHkW/0/4Xahr6dmJVfxHDO5OyjPRSWO2IVWjDMbELXm5Wc9DuYlNNmt+RQlsD90Ov53UKMfkbzsZP14shrA5y8UHeJlIftLkhkdTXuPqXB2B50ITJnJOdH0RhW
 72MsvehW
 LyuaJVhziqHzEhANGbEg589jzVBP9F7+HL7cae/JDIlJfndsBPiwbZlhhHP2atZzQXJuBSIyofh/YEm6x1KiSkEi7wX1FfLVzwvqNsLLs94iwgvP7HkOb3pwamhFwBEmbWD3Lai117G3lrUCQ85ew9RN6mAS7ejCk2QZ2gTaEUujnRYvwIHIe+/1b+3M8lEvKDa/gcb7sTTC8PwHpHQe5NE4UHEnHk2m8t/7t2gXk0dkkgw4ZgDYEWt/vpKo/8gMdCRRjRAXf4lunmgtJ2/FeEScG41Rfv4nR1wTSlZVB+3mQf0HhyMQRBoz6tDno0yKbklVBjUxBZ97NzpAG0enL77wa9JOLNG21qSlssL4+OOq1Qm4=
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

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 65 ++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b..81809b83814b 100644
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
@@ -2149,9 +2149,20 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 	 * we can avoid introducing any issues with the buddy allocator.
 	 */
 	while (spfn < end_pfn) {
-		deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
 		cond_resched();
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
@@ -2204,7 +2215,7 @@ static int __init deferred_init_memmap(void *data)
 	while (deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, first_init_pfn)) {
 		first_init_pfn = ALIGN(epfn, PAGES_PER_SECTION);
 		struct padata_mt_job job = {
-			.thread_fn   = deferred_init_memmap_chunk,
+			.thread_fn   = deferred_init_memmap_job,
 			.fn_arg      = zone,
 			.start       = spfn,
 			.size        = first_init_pfn - spfn,
@@ -2240,12 +2251,11 @@ static int __init deferred_init_memmap(void *data)
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
@@ -2262,37 +2272,26 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
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
+	 * section will be also initalized.
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


