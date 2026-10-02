Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A357CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EBF6B00C6; Fri,  2 Oct 2026 05:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426506B00C7; Fri,  2 Oct 2026 05:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316136B00C8; Fri,  2 Oct 2026 05:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2F26B00C6
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A969C06CF
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:36 +0000 (UTC)
X-FDA: 85277234112.22.7AA711C
Received: from mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	by imf12.hostedemail.com (Postfix) with ESMTP id A831240008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NTZ8NaY0;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVOEs0UcnC8st4giq+Aux3d9TWjTh9uJbb5sZsEGd7Y=;
	b=0fw/aG1RZT4pV2PI3wc38eQP/Yv42P5nXVbTCvVJ90gojp4PpUqLbxS02KyDPDkqn+Puze
	ytXLPVPdpYIEDFOjZRaHnkHwf1bc4BFPr7o5Sse/hXFm62Ai3bjbrkyzbneiI5T5l64jDj
	xPJhOlCEZClVZqS+O0V68NBsVyg5wgs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935054;
	b=SN4HU2R7iwAaZZSRF3lhSAfLKrbdeVDy5Y28OUPOGP+CF8tiw+c6HR+31woSH4i4GiaLlX
	AF/NKiip/8AKlt7yK+g464M79zFhbbe2WgDsg75JXGIinO2E2qLXI/CzHHMiYd8fLvA43I
	AM4zct9jcqVeyclMVh0ujgdT7BuSwXY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NTZ8NaY0;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=b+tkZeQJpq6th21l2hoOsDbnBBxFt3Z2ambcft4iB68=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935053; v=1; x=1791539853;
 b=NTZ8NaY0BLYSU29hWiPClz3kmeT3yI2pYrYNuQg+uu671WgUCJut6TFXOatc5nWYMB4vEjB0
 Ia5JYsGg0rR2gPl1AvPiaemApoAZnL02nPtTg+N2m2jBNSQiCIjL8nsQGAgn6eQiTLl1E0/PrpX
 oBeDKciqxvMgL5DDI/1Gy3Cw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id adb5c5ded8e6abd2;
	Fri, 02 Oct 2026 09:57:33 +0000
X-Mizu-Trace-ID: adb5c5ded8e6abd2
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 27/30] mm: don't PTE-batch a swap-in over a hardware-poisoned subpage
Date: Fri,  2 Oct 2026 02:52:41 -0700
Message-ID: <20261002095503.3585565-28-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: omkf5epnt43weaf17sga7aj3py75z4z3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A831240008
X-HE-Tag: 1790935054-989047
X-HE-Meta: U2FsdGVkX198y7Im9HTc/vkZp+xtBmq/7X6fwzPGeT/MxkFiTRF3us8BpCZWevAGHWSwsAM7QxS1BZpxEBQtlo7OsSxibQSQd366TMTn+j4e65MJQBnfC38mYlBdvN6xh0VrkPgG5w4hstlpk6bY7WQkN4c0qMQrjnWZLnjfrEhXnoWXngCWL/nFILg5rr8lAVAO+wY0i0kqjCyewIH/XwPKicGzXgy39ElMLYja9dSj2KQbMA3zX4rrKo213axsZRORFIw4ADPKWdCXzAN/U8vIgUuNBU1Y/5PmJdTG7P33wQQK24C4f50modnOmrqzYBWSTzfhqPzuNel6fHIqluXycEIHupIEUuCV31jQrKFUrqA8w7wg2T3Thv8lJH2a3Dqj3FE3WHwMX5D1fHM/TKJVCHzRFA4bPQsLuqUoCIWOvfMQaqpDerRO3QQM9NwFlPxfcJw3Ayos9DjyJMv4p77+G0T4YYMYg8vxaj1ckUfCAoApMFnNqFVsOtxO4w7MbvoszcR2CI33KCnapvn8eTcn7xhYx3PyLPgNJzJ+flRL37q75tTo/5FEi0EzFxejQceerv4ZKdCHV0gLG2lCnSP+/IJfGEkgp9Y6HaFC6J7OdLIseZ2z09SWeWNAu5tXvP9CIkgQGddNb4eUgLhtTN+8VdqfsJpASeCxz4a88eF/rxfFBZnoAEvF/5abbwMTZU8v8DWB467nqinriE9PwyEuuhJMXdjPhQ+m+Z61D7RwCshkYHp7EzKnCnI8ufnzCMlHZM+Kfr8QxSGNl+qvym9EEH7WB+og+zCi0MwTIvTzuINRWZKiihT7wPXpSyTSxuHfYzzousvHKzi29SnD1kg94Q8Y9MTJLrPVHASdAqG2XnQ1F7MW/Nbez8T5RVJ2D1iJRUvo0Wbml0EubLi076AZ4yJZBfMl62jPh6RXdbvSfVaJsxh+iUfYwrtclJrqMtfb+XaoCSdeTGJcHP8
 oe20HbvI
 6e0MzZMccPQA6mg0s2sJ6H+gWyAjlmTrlEejT8GeFXZtPJZXzQbdQhW8MkISAREagQ+z5ISwoUOLlIQXfmUQYtUiy4g93rWOaHHQyoYkAdydfWLD4KaAKO0WG/voJMho11eU9qL26YTaYaSRiea+pu+a/XMv70unKULqIzrMRqSo0MqGx421KlOaowsxjggiwrPHzwqdenH9T1cedxhHVuiagyOYp3i2xBT2s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_swap_page() checks PageHWPoison() on the faulting page, but the
large-folio batching path then maps the rest of the folio without looking
at the other subpages. A poisoned subpage that is not the one being faulted
gets mapped anyway, and the fault that would have reported it never
happens.

Skip batching for such a folio and let each page take its own fault, where
the existing check catches it. Test every subpage rather than the
folio-level PG_has_hwpoisoned: memory_failure() sets PageHWPoison() on the
subpage before it acquires the folio lock, which we hold here.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/memory.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index c0ad446d0cea4..428a156ae15f7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5030,7 +5030,14 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	page_idx = 0;
 	address = vmf->address;
 	ptep = vmf->pte;
-	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
+	/*
+	 * Scan every subpage rather than testing the folio-level
+	 * PG_has_hwpoisoned: memory_failure() sets PageHWPoison on the subpage
+	 * before it takes the folio lock, and we hold that lock, so the
+	 * folio-level flag can still be clear here.
+	 */
+	if (folio_test_large(folio) && folio_test_swapcache(folio) &&
+	    !folio_has_hwpoisoned_subpage(folio)) {
 		int nr = folio_nr_pages(folio);
 		unsigned long idx = folio_page_idx(folio, page);
 		unsigned long folio_start = address - idx * PAGE_SIZE;
-- 
2.53.0-Meta


