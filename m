Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0010CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D248E0011; Mon, 18 Aug 2025 02:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CDD76B00C7; Mon, 18 Aug 2025 02:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC1E8E0011; Mon, 18 Aug 2025 02:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25C426B00C6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:46:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF926C07BD
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:32 +0000 (UTC)
X-FDA: 83788944624.02.13F67D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 59110180006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JIZVzUMH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499591; a=rsa-sha256;
	cv=none;
	b=4o/vSYJcbJY71KbeZ8VWQjIMKDg+6KDtCeZlHnTqvEi2Cic3UCrfD7LUfHZ/sULR0uxeVX
	YUsCKX72lHezfTXbgLInmDSip2TvqRCZYKdOjCv5dDxVGDsCduk+wDyz++jfsllSaioEo2
	Aa5aWpPjyyw9oj2Ppw2UvGiDYuWMVHQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JIZVzUMH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EzNpkpIGkSJN6CtNeINrNelFdKIpzSK6MLh06nPRmTk=;
	b=vNADBtxOLCRznFbjP8ptrQRmjrE9c/uVzTwtadmthlaXFcVlDx80whQPKPePLtu2V9BV0k
	DyRoNdiL240qxo+mbYG7LId3qgja0/aoyhHfqXAfDg+WVYyaKH5OjhiUtdEWhGJ4XILFtH
	etiiROMoCuxm/HlSCKylWjE0mPbElJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B80E601D4;
	Mon, 18 Aug 2025 06:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05165C4CEEB;
	Mon, 18 Aug 2025 06:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755499590;
	bh=5eSfCtdZloXF8ewebFcesyIx+wEpCfgf7oheGJfpmyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIZVzUMHBOjxEJIsAsKLJVaP/k5p0NKfh9iQouzhRsaNWKVfLpr4A4Hn4ESMremCr
	 U/eytjBACZepXoOYyenDDEZluSvgj5g3bZI3cInpMUYHz8Db+Y49P7D/ZTFy4Qs2WE
	 5ds52Bni3LYsuNAv+sqjdE8uhnOuRYwc2BfoL0ynhD2aq2inEhY7zsmwfoHJulgfSk
	 XrnHUrqOUWsUxdMvLqo79rRZbNTN/Gh4ErlL+CtzOrxRLMoj/0F6iVu6aQHSs9Umvh
	 4erND4l+1nYMW68x2BY2/gudB7atMQNNFslobrMsAUcb+BAG+ljpBaItW/uGLvySMN
	 TSRnHX3GWdUmA==
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
Subject: [PATCH 2/4] mm/mm_init: deferred_init_memmap: use a job per zone
Date: Mon, 18 Aug 2025 09:46:13 +0300
Message-ID: <20250818064615.505641-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818064615.505641-1-rppt@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 59110180006
X-Stat-Signature: s9gdcwcmdknnsgchwpddsdyanza461iu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755499591-132388
X-HE-Meta: U2FsdGVkX1/65zeyNJZrfe7Tsfy3/myso6sNNymv+1de9AvOqyPDYtRpqejoPTRFWxp8UG49eqQ9RadlrPAYTkULPmIVeiZlSf2eB7Mgbk+QcxeyY1Bg0PoRoymJMESbcJnaLKsbh4HVK9rQjeh+S+iDBJO6ne3elbrvg9q0s3YHZ5XUZVat+SZ/uA1Qlk5pPbdTYFba3FVImz0jylMTWJIy2BYmOKP/O6X7jp/JysK2ixPhZyGUMC84hC5mCvNiqhwYP1jU3bcWKs4+8jhAtcLQXa5xuz53VQMPZoqM0HSNiuH/4vLQkDBTEElkYVdikLLMn4pHCgKvqqQZVrm6klLm7grI1cmHWUycI29SgdvxHOTdFSZNup5eED4aU6Wu5NfSF6MKGAyWF/ed+y7DSVXv3Z5cBuzue/T3J+idNjqouotP64KL5JHa32cMokBC1RY7Een9GeM/po6kTL20Z24TNL/NEozyVtQLwRitu7BnKmqp7ffjBek9krfEUdor0nJnk3FlOKVkqen3MrPDZwT3V7NyOVartSXhSJ9nyltYUDx/A4JrXdOih/EujqppAnWWmt0v4Iah7nzU6KFL9mVjlxsVcdsq1JJfSgeFPnuAmjJtUyqOykUChu+LMt993cH8liMFJhnbVkzlFupK5kJqfJ5r2r4Bl9Hp8k7b577JDVVVo+PwLJ1HU9iLnuBE5nQwENSfYqkNoPU8lG/m7ikp1dYmKlsui4sL7rpwVMDZDehMcTKa4s10IVo5Ogs1XCSKTpWsxInbUTd0Em6g9P3zrLPdaPOq9xLQedoFWUcR8+4xQh1N33r6cvJKkGDgtw8WkyLiXP3GSL1FpJVxNLo2+u8YwuDaOgMFNF8W+xtYcbsXzDoXpAdIQcuo1lJRG+V0yD9qjoL+vZCCuGp98xMNbEsd/wFcvIKzX7vWbkOrM/N7KVqw5Kl3rvBI/D1FcYpVD0Y6UdR4FkRL8r1
 /H/L6r1s
 x2qSr/aU+Mq1kMPWBRGz5PGVsOYQkrBKB/nfUsdmYAOpuJMX8DTaBtf2SNFMA3hh3tEoVAdMBX/q/ffqLRis8GsyF8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

deferred_init_memmap() loops over free memory ranges and creates a
padata_mt_job for every free range that intersects with the zone being
initialized.

padata_do_multithreaded() then splits every such range to several chunks
and runs a thread that initializes struct pages in that chunk using
deferred_init_memmap_chunk(). The number of threads is limited by amount of
the CPUs on the node (or 1 for memoryless nodes).

Looping through free memory ranges is then repeated in
deferred_init_memmap_chunk() first to find the first range that should be
initialized and then to traverse the ranges until the end of the chunk is
reached.

Remove the loop over free memory regions in deferred_init_memmap() and pass
the entire zone to padata_do_multithreaded() so that it will be divided to
several chunks by the parallelization code.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 81809b83814b..1ecfba98ddbe 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2176,12 +2176,10 @@ static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
-	unsigned long spfn = 0, epfn = 0;
-	unsigned long first_init_pfn, flags;
+	int max_threads = deferred_page_init_max_threads(cpumask);
+	unsigned long first_init_pfn, last_pfn, flags;
 	unsigned long start = jiffies;
 	struct zone *zone;
-	int max_threads;
-	u64 i = 0;
 
 	/* Bind memory initialisation thread to a local node if possible */
 	if (!cpumask_empty(cpumask))
@@ -2209,24 +2207,20 @@ static int __init deferred_init_memmap(void *data)
 
 	/* Only the highest zone is deferred */
 	zone = pgdat->node_zones + pgdat->nr_zones - 1;
-
-	max_threads = deferred_page_init_max_threads(cpumask);
-
-	while (deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, first_init_pfn)) {
-		first_init_pfn = ALIGN(epfn, PAGES_PER_SECTION);
-		struct padata_mt_job job = {
-			.thread_fn   = deferred_init_memmap_job,
-			.fn_arg      = zone,
-			.start       = spfn,
-			.size        = first_init_pfn - spfn,
-			.align       = PAGES_PER_SECTION,
-			.min_chunk   = PAGES_PER_SECTION,
-			.max_threads = max_threads,
-			.numa_aware  = false,
-		};
-
-		padata_do_multithreaded(&job);
-	}
+	last_pfn = SECTION_ALIGN_UP(zone_end_pfn(zone));
+
+	struct padata_mt_job job = {
+		.thread_fn   = deferred_init_memmap_job,
+		.fn_arg      = zone,
+		.start       = first_init_pfn,
+		.size        = last_pfn - first_init_pfn,
+		.align       = PAGES_PER_SECTION,
+		.min_chunk   = PAGES_PER_SECTION,
+		.max_threads = max_threads,
+		.numa_aware  = false,
+	};
+
+	padata_do_multithreaded(&job);
 
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(pgdat->nr_zones < MAX_NR_ZONES && populated_zone(++zone));
-- 
2.50.1


