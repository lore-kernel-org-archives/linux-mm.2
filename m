Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CC6C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86956B008A; Mon, 27 Jul 2026 12:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D766B0095; Mon, 27 Jul 2026 12:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B006B0096; Mon, 27 Jul 2026 12:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1B386B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:15:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A9FD12011F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:15:07 +0000 (UTC)
X-FDA: 85035055854.11.0BDD6DA
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id E65DFA000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:15:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FnZpP/tz";
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785168905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lN+gicp6TmdEB+moqhp8rFaHd1rM6s5nX6VZv/lpYx8=;
	b=YO52/WyM17EiqU2b1kvHHtwKGA+iWXH/JCwlQFYgYg3/FTvAMlIt2n6mcP9wbnKJnPdIky
	pv6Z2jokH3xQFLj7SQGKJPTYrVWuzhJhzl+JDhSirKkVNiHQvAb2VeWyCAF1s9c7LOSLCN
	vUQ8cpEfq15LYx9J/6kNbLKg74DozPE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785168905;
	b=BcyjOqVzIfnPzPMG2XJSUaNH2ChCoFWG8haeIMV1FccPnMYKNU9sxChqWV5ggEgFQ56uNV
	6/Q+1nkW0Vii1lHP8olgOfIGTY40VcwaqTVq5hLo59QnAkFWTJWv1cPBf3yXKNLPHd0HWy
	h43iJuzT5f9pki66c7alyQ2X4kpELWA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FnZpP/tz";
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785168903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lN+gicp6TmdEB+moqhp8rFaHd1rM6s5nX6VZv/lpYx8=;
	b=FnZpP/tzy/4qmdJ6mDKchnITOft5YnUO2sgPXEL82M7YRE1MW+qCbNuidx6w4DFV2r/e6H
	yU9w8tEe+95F9demBD/7RYkhyRFXIQgt2FgDGvA1W7zlUXtNWg3+aKtOnmetUUR1I3d2Uw
	SXJr4XSqBdAuWnujRXxbgNv11jUBOQs=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v3 1/2] mm: Use a folio in the softleaf_is_device_private path
Date: Tue, 28 Jul 2026 00:14:30 +0800
Message-ID: <20260727161431.13455-2-hongfu.li@linux.dev>
In-Reply-To: <20260727161431.13455-1-hongfu.li@linux.dev>
References: <20260727161431.13455-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mxzbyiwrfqa4i4ze1d3i1jrqmt6u8w46
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E65DFA000C
X-HE-Tag: 1785168904-292834
X-HE-Meta: U2FsdGVkX19WbW34s52HnVLDB2sVDN9zaKwdhBO3kybCnieZYntxxrAhyX/bKFY/Z2kTdW5A2mj50Fu+7rU7yOpRxQ+JfMF5tgj7K1vzJ2u5sV2OKstESbQL2eQ2KaRvvEVcN9TM/DP4zYUxudV4pGeY5WTKDrS2FWF/FALc8dPkJ4HeL7Nt/N8hMYHkOig6VaRRHwPMUbPQUD3itew5Wlpb76Ls/7YGSzH8jFJvOoUjPh+yplfpMB40EegQBEjOAnbcZ841Mlcv4gRGPq+mK9lEeqxvlAVgU6WQ6+8JoJjnuD1YoTaQyEE6mn9hvCoLk235CGEHU3PdJf9T5vFjwW7HJ+YknH02aLmP8DwdLoFTkXCquEzZPe6SE7X4Iza9ht1CUh49P5liaUp0Q4P+HRiOlvSmplJJF8vfj334UNIYMa95sSaSVcfab77z7+u+hdXGgUOqIN46r/OvjwfXBbNKDBqYzlYaLXfEvMz3eNMvLVH+zxJdOSrKhoJqNAVPaQshGBTZXUhdl+FFH+30xy+39XCrhy/7nHW0LsmTVcXVX+a2z8hmqXox20tEkYNGfu/bcVLXrmgfQt9W2FTIy9Sy/K1EAkj6bdkvnSel9ZOWJ77VlZb5lFC0ODzNAoE2dvfTsUl2Ye5ONGqREzOBDvsKeuDHHLH8OQ88zE6JZd81Pa/YpUpomb436cnT/z9D0tXmiKLnLwgLgUvhU5BamkXZEQEC+nk6/j8suE3B1gQmaBI017yuaeruA2JUrHmUPtT1syKLZtMvnFd66RESalGOn6n/XuvBWwJCVDeqOY3huUT4mgrKzS3EvE3N+Coc9imDip1swFTPinm+JIF2WseqOnxs/KuE88ZaZkzIlrOB8xAmUlGODEf/SAQoLYMkZvB4R9vj3bJ0J49/2ccikY4SGGusswPaQEerGg2LLRCsJxt642NfCyqHffb2P/EeMmDDKUpRl7DhrmDHjb7
 0+VUovM+
 TNZ3cjdk+IM3ZC/REsww/7XyyN51AqNesWuR8l4C1mbbIdY1MtDwkDdFFRpN6hIghWpssT+ubQ3yvMI+HD7i5twrEXy7GF8W1LBl4krg+husPqUf8mgGRNnKI1HjV0bPD5rgM0MkUAR5GPIsGRYKseuA4ttlZQu3vDkz2Cs0ebzYRu7Bh7IHGecTatHgTs5GCUkh/0gIJU1MUMDNx/zta2V+WDN8IkBcKXbhF3WBFuS0SiQPGke2ESRokj5oWJvE+LR2g6Ie/O1RR9WU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Use the folio APIs in the device_private migration path of do_swap_page(),
replacing four calls to compound_head() with one.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 56b244552f13..bbb289ba09d3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4873,18 +4873,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				goto unlock;
 
 			/*
-			 * Get a page reference while we know the page can't be
+			 * Get a folio reference while we know the folio can't be
 			 * freed.
 			 */
-			if (trylock_page(vmf->page)) {
+			folio = page_folio(vmf->page);
+			if (folio_trylock(folio)) {
 				struct dev_pagemap *pgmap;
 
-				get_page(vmf->page);
+				folio_get(folio);
 				pte_unmap_unlock(vmf->pte, vmf->ptl);
 				pgmap = page_pgmap(vmf->page);
 				ret = pgmap->ops->migrate_to_ram(vmf);
-				unlock_page(vmf->page);
-				put_page(vmf->page);
+				folio_unlock(folio);
+				folio_put(folio);
 			} else {
 				pte_unmap(vmf->pte);
 				softleaf_entry_wait_on_locked(entry, vmf->ptl);
-- 
2.54.0


