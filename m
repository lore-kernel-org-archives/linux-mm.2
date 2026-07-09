Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B156C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767D66B0005; Thu,  9 Jul 2026 13:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F116B0096; Thu,  9 Jul 2026 13:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C9D6B00C2; Thu,  9 Jul 2026 13:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED806B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:47:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80AC81665E7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:15 +0000 (UTC)
X-FDA: 84969949470.15.2273EF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D7DF418000E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NgYUfxJC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0TyfHDGp9MFMmZhGlGKvQfEHqtuRGyQhEAHo3riGeA=;
	b=jxX06BcXuTzeW6w7sCQiscPvulqDR8eTXrjLYzdLrdIyppxQtLqMfOxvZo0IJHFBTNJXUl
	hV8YnWgP3z+M3MCJ7ie6jlxBhScmUZYRupdyGjGdOA3RkuMlSmehmmMEkmwIIIy1tVxQ7S
	DOb4kyqUYwyZMTwuMyFEEmuwZz9kbTA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NgYUfxJC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618754;
	b=NcEQFsqwo/4nbcQvnc0JB5sBr0L52v9wjI5WJbOIYenLI5SGmfeXUw8lzRsqZtnVbBmTfF
	GRv/woRPp3yT4lj3XxLJvqtz8Nw1iJdAclRHiluj5aca2bBPd8rr/9yrjrkmvb0c3kuxHN
	w0I59t2pDlxkyIBrz+Qh9zfil/3g1U0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C033437F7;
	Thu,  9 Jul 2026 17:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1111F00A3E;
	Thu,  9 Jul 2026 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618753;
	bh=s0TyfHDGp9MFMmZhGlGKvQfEHqtuRGyQhEAHo3riGeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgYUfxJCriwCprEgHQEZJJpPIibQJGmufQxvjuMW7DlOy9/xHqorXKwDUOzWSnDya
	 yiHQPp3Idtq5IrWbUxyb8URxr9iTPsMQerVZwgUMEDto+TQOnX/i98EsP803g0nbVV
	 bi3yNedZnxPX/iMhIzJFa09S1WlQpNuS7CYWP5LNGVuMFDRrk7JWe8B82WUBvhcv7b
	 osmv5mmUmxDjJ7+kBleFRTbACSv6vSo8Pn+eN6t0zvelZHH58zIaOUedzzIQwSQgcE
	 UgQik0N+HAdHdFyF82VDCEmbhaLC/QdJVcxa6yHicokMfyFEcBVAYR6nakKABVtZSn
	 1FWEwzCjzHq2A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 16/21] mm/mm_init: init deferred page migratetype in deferred_init_pages()
Date: Thu,  9 Jul 2026 19:38:05 +0200
Message-ID: <20260709173821.429921-17-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D7DF418000E
X-Stat-Signature: bhi3i67nmupkpdhwx1grpe1okux9me1m
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783618753-455697
X-HE-Meta: U2FsdGVkX1/VCu2iz3WVgjiliFm17un5XiQ00xq/jIYHCngu1kxBtJ7lQc6V9PsfJXitHgSodvw7IAGog55R70+mWL25rXol5kR2EwxqwemzwUAHKAM6ZFA7oCeGBAsdvBv19P5CPyGZSRBYns4We9WUuuvAVqUFNvMQ1Ki+xl6XrbnjgNNViRH2BvAcdkj9yGa1faboUNSc6T5kuwlpuNgNLgN+CB/QSz3yEUC68D5lYMNzFyeMgTy1sBoFC0EJO9FIOp7QaBxMXHmDjduRICG8m2xSOU9JJVhMcy7ZD+zeuHNn0dBed5eapM4cUR00xrL4mUmi/QQvoSIAoPvK1xxYAwr9gyNWJu/ARSH0daof4l6T/0+DfnYLAfl+aaEm936DA81XFvBDGST7wpEYEiPCenxoZy1WGTfeBwRk2w1G1dbnjAFD/wejRDf/yOUSZYB3hobzs01pejj4Fqufr0tsbFaZMZXeNkpd3kDJMeIiz4A9zOCj7JD6quzQbLTUjU9xAsUnKgmlDVOlho+lOwzqP6nItg+YYzf+FmxwrGc7gWYSeShm3zHhGJbF+jiTxV9eQuP4HekUHvjQba5hSDGIDDGZwVEDp5nYgK3O9JwDzMHRX07dYjsZeXd+N3/OQAD/6fw+qvNbpHcd57akiQN5glDpn/SnreV7eNXozJSiWIFBFY+N5sH1EihPbeTgjzXEatBddwwJBrd2hwS3l6157jL5tsUFjxH27+9uhSHUbUdhhKKd2mzbeGW0C8+bOkkgqLWBm2TNi+XLX9wpu3Mm4R4ZBIs+J3/0CslosD4FjvdoMKfy2yNuARTYuqcnlrdZtfHe3/hjLSTXYqmG1pJ9Sw0SakpEl/Qypf2QpplmID4BevakFkGNpcoBJVZyh3a3hPpExKb2DZzZAKhXkro7fITCyqpnE9G+uM42Q08nAm5w5fAsoEUhe7f+PjuJHdd/GuHu7rGupyrwAUV
 nTL9GVSg
 bg4/R+SNMQhreBs0M67JsIj28H3IjyJ0u21lEq/luksDRcxfKAW+hkTMz13F1509xTwub0t//s8QVELFOIO3MpGNIHdKetO1DO3Qf2O8e87zU8rcYBgnBKikqgWrrWiCQXfnV7nXMKBt93SzOkvrkCqhr0YAUUcV0SnkoBNJTtf6iO9FCsqmI02YovtYrDRQSCyEz/NgPWqD9kiQU6tqk8N74DWIG89iBWNvWN94+XymZtRXlyyGqcU8csHeZDtp8X874mFHhwNgp7arfVSOjM6feFt6IuOHBuZBD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The deferred pages are initialized in deferred_init_pages(), but their
migratetype is initialized later when freeing them in
deferred_free_pages(). Setting the migrate type is part of initializing
the pages, so move it to deferred_init_pages().

This simplifies the logic in deferred_free_pages(), which now only does
the freeing. For non-max-order-aligned pages, it also drops the
if (pageblock_aligned) for each freed page, which in theory should be a
tiny bit faster.

Another motivation for this change is that in a coming patch, KHO will
need to update the migrate type for its scratch pages. Moving all the
pageblock init in one place makes that simpler.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/mm_init.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 84d4b1c997bc..bd9dc1829005 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1985,8 +1985,6 @@ static void __init deferred_free_pages(unsigned long pfn,
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -1994,11 +1992,8 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, mt, false);
+	for (i = 0; i < nr_pages; i++, page++, pfn++)
 		__free_pages_core(page, 0, MEMINIT_EARLY);
-	}
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
@@ -2017,15 +2012,23 @@ static inline void __init pgdat_init_report_one_done(void)
  * Return number of pages initialized.
  */
 static unsigned long __init deferred_init_pages(struct zone *zone,
-		unsigned long pfn, unsigned long end_pfn)
+		unsigned long start_pfn, unsigned long end_pfn,
+		enum migratetype mt)
 {
 	int nid = zone_to_nid(zone);
-	unsigned long nr_pages = end_pfn - pfn;
+	unsigned long nr_pages = end_pfn - start_pfn, pfn = start_pfn;
 	int zid = zone_idx(zone);
 	struct page *page = pfn_to_page(pfn);
 
 	for (; pfn < end_pfn; pfn++, page++)
 		__init_single_page(page, pfn, zid, nid);
+
+	/* Now initialize migrate types for these pages. */
+	pfn = pageblock_align(start_pfn);
+	page = pfn_to_page(pfn);
+	for (; pfn < end_pfn; pfn += pageblock_nr_pages, page += pageblock_nr_pages)
+		init_pageblock_migratetype(page, mt, false);
+
 	return nr_pages;
 }
 
@@ -2067,7 +2070,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
-			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
+			nr_pages += deferred_init_pages(zone, spfn, chunk_end, mt);
 			deferred_free_pages(spfn, chunk_end - spfn, mt);
 
 			spfn = chunk_end;
-- 
2.55.0.141.g00534a21ce-goog


