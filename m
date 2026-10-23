Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3518F606A320
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 08:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nAzBZwsg
Received: by kanga.kvack.org (Postfix)
	id 5AE5C6B0B19; Fri, 23 Oct 2026 04:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5854E6B0B1A; Fri, 23 Oct 2026 04:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C1E6B0B1B; Fri, 23 Oct 2026 04:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 291EC6B0B19
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:04:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 32377A0370
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:04:41 +0000 (UTC)
X-FDA: 85353154362.02.751FA4F
Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 24BD5160003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:04:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nAzBZwsg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792742679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1aER1x8VPZMKUcSsoignSKfToUokcEBP6tnK+zyf6o0=;
	b=PysNHrI3B3CsXi30XjhzMXtfffv59QUUmMYPDTtDcifCcPOUraYLpWeZ2nyHhviLImGPcG
	vL2WY8QapZXebP/F3rwi5lBHPo7fgiESfdgBrF0tsvmvdyfEOLCnOD3jWO6NldUhXyQLfG
	EHHV9h8QMSb/Tx2yHEXrJUnSgHowBps=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nAzBZwsg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792742679;
	b=PocGwmbVznmIoxq96sUKL0uRAQtVhvEGh76rV7AZCrQaRS+UEf3NH24PvgZ4vPz7wbhHvN
	iNBshh4/SDC8mhsvkfyPwjx1V+9yOtTlIT1ibBIJW0ZqCR/r8f8ateJ2G8tOo/dfl6Knfy
	5G3cU75OPEaHkY8jg+vhS2xCCsx8ruM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wjMZ4gCT6bzoDVek/8Cu8ceb5A5pr2WKbPw8oouSwcE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792742677; v=1; x=1793347477;
 b=nAzBZwsgeopV6uQ+/Fn0Kx/w+ClYMIN84t4plX6nr/fcM67GO0JuTQEaboP92JQsLx5q/Cs6
 xyjRvNAbPabgq8bJ9cqIX5FQf9eQkxRJGIFgh1dWIqYi91F0mACjm02MEDCvRUftXYW4UCUHyON
 eIjWD82mwJDMPprCAB8DeNFw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 521efba9aa20a663;
	Fri, 23 Oct 2026 08:04:37 +0000
X-Mizu-Trace-ID: 521efba9aa20a663
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Yu Zhao <yuzhao@google.com>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
Date: Fri, 23 Oct 2026 16:04:29 +0800
Message-ID: <20261023080430.465305-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24BD5160003
X-Stat-Signature: 94yw4d4n3gsgqmzgorb187qtyy1fpdpq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792742678-203064
X-HE-Meta: U2FsdGVkX18+xQCm2dZidmUi0d1Xllq65pmbDxjWx26FBE5aVkakeBsUFuBYN/vseHBxNvHMfxDTiRLNaHeft7G/SpFM9u236ESHQSzzBth17LG9xuwFwv1o5ktSfDpfk9OWRx7dzvtWF99UIXWycamVJ3zF9MKci/4dj87pkUtYrOKudh297KEO3Br+J7ACfK8tzoOd8BvKG/bR0pv1afMijXWR0EESS9LztEHZTTIBFZLz7/IewcXlFxTfZ0UZ5s7EWfkaXaRUadzXL1EGozM7lD15fzZmcBGfcgXnuySERai3srOIMviaYCkv2fSfDLs5GsT52qqLfdgpq/VzdLtemqpw3vhgAyzZz5ahuXHrrXQiHJ8MK3RFENf5pkFRpru+nMWhU9f0ICDcgt4h3d5yfb2SGSLuU+85+chpGFF1nHuE69saizyAXmDqjgB+dmC4z/092iUMNJKKB0pOmhLtLRO5zay07/IxaNDBBjg157ziNZ/o+Zu6cza+fXWp1tOLp20WkweAjwdqquMh70byikohsSOYMaOSNQSDHBE/lU+suNfdnaiM68ao5QRI1U4RONwqmkXz+3ac8UIvViTHirSSkexjvjdps+iceNDNsO2/j3cgOgn6cFKrgDTg/yMzCQzAQvXmBDEVfK+iYbEttSYlmXSgy0D7FNCFoZ/SPRVfPKJLP4SI5Lr6jReUBmE81LYxk96hgjsXwZ0yt9VWZsOT6nKQ8xbxgRQiu2WWw+gnjgM7SpYBySU/ht1UG2A0nH9nRmDLAc3TD4HdbHv/wAo//drkSlhyOGlDTQJD3z5Hq31yXo6CJroDhnp3lKhntLOAP6WT9U/YXSxkD8Eu/oax9neC84EHvwjh9IrY/AMkLbN4DMkEMO5WL/llJzr5KI53lo3UysZMZ9QXTmuffFbNUB9lkszxNhG5KMsZ8fDi1DVVVuCjaUOGz3iV87ncls3a1jnjPmbNipF
 pUfux5MB
 /xCkWsQYCbwBsH2FYOKx7QxgkRZsyf1kCxo2wTMo0ZKK5tCyWq7fwHT7yfJu5WHdj0t0QpLuMadTN7iYB2KYHZ4PJoVM2fCXUU0WqbeiVpBtKX7GN48cm5rd+Zgv55eEbt6XZdA+AC1kY9Lj9jBXbHgyGj55mY3rZ8Zub5H9Saxl87HroZaOdiy9qvbAXlKLSYBCl6e25bve7+fsPOwFEs5U3yaDG7whxfLQG5MdxciuDfGC/NcMk6ZKUlsi9m52TJr/E7exXS2WtN4A/hmtw88+CJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
clearing anything.

A MADV_FREE folio therefore keeps the refs and PG_workingset it had
before madvise(2).  lru_gen_folio_seq() places it one generation younger,
and PG_workingset puts it in the last tier, so sort_folio() promotes and
protects it instead of evicting it and charges it to lrugen->protected[],
which read_ctrl_pos() uses to balance anon against file reclaim.
__folio_inc_gen() clears the refs but not PG_workingset, so this repeats
every time the folio reaches the oldest generation.  If the folio is
redirtied first, ttu_anon_lazyfree_folio() keeps it and
lru_gen_eviction() packs the stale state into the shadow entry, so a
later refault is promoted to the youngest generation.

Clear both flags here instead.  lru_gen_clear_refs() only reports whether
the folio is already in the oldest generation, which lru_lazyfree() does
not need, and moving the call up would still miss the folios that are on
the classic LRU while lru_gen_enabled() is true.  Use
folio_clear_referenced() rather than folio_set_lru_refs(), which is not
defined without CONFIG_LRU_GEN; PG_referenced gates LRU_REFS_MASK, so
clearing it zeroes the refs count as well.  PG_workingset is cleared only
while MGLRU is running, which leaves the classic LRU unchanged.

Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/folio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 47a437e0f7fd..03be101334eb 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -599,10 +599,16 @@ static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
 
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	if (lru_gen_enabled())
-		lru_gen_clear_refs(folio);
-	else
-		folio_clear_referenced(folio);
+	folio_clear_referenced(folio);
+	if (lru_gen_enabled()) {
+		/*
+		 * lru_gen_clear_refs() skips an off-list folio, which
+		 * lruvec_del_folio() has just made this one.  Left set,
+		 * PG_workingset keeps it in the last tier that sort_folio()
+		 * protects from eviction.
+		 */
+		folio_clear_workingset(folio);
+	}
 	/*
 	 * Lazyfree folios are clean anonymous folios.  They have
 	 * the swapbacked flag cleared, to distinguish them from normal
-- 
2.53.0


