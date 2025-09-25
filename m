Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0345FCAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 22:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42CC88E0007; Thu, 25 Sep 2025 18:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9848E0001; Thu, 25 Sep 2025 18:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8338E0007; Thu, 25 Sep 2025 18:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC7F78E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:11:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B504513B35D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:11:39 +0000 (UTC)
X-FDA: 83929170318.07.94407ED
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id 039D820012
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:11:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=InjnGNFI;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758838298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJH2ck5XEjk64tYSAUJ8Mmt99YWLK51DqiT3bpdAVPA=;
	b=j7ePwvGODA/JkQwabxVyswGzGSDGqRxZXVul9AbN3+hhbGU9teAEIijKg+5v6aps7lwy3e
	1cRh828L1h4wrBA/HvwVCJGIt8nMdykai88mfVub/DfJTmaOCvnl4J4edhpQX1dTbBgAOn
	oH4X8tfSVlbZTk/HG4XpElb18V6qzNk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=InjnGNFI;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758838298; a=rsa-sha256;
	cv=none;
	b=q7up1ImYVqLnh6MKK+BLfXSJqNk7+EWK6Csnw2EU0HK/jcU84wDeOyAiTCyCRAMh2xbMFT
	MwTZ9oBe2y8fH/YoJdJxmWgF/RhcxReppHw0ZPmFctsV7I7hnR4i66u4hXKYJAGDfYLkY7
	TcVtzPeCSEBjWAMJMnSNUlc+QqCM5GE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GJH2ck5XEjk64tYSAUJ8Mmt99YWLK51DqiT3bpdAVPA=; b=InjnGNFI7HfscQkEpKolRkt3hu
	WYjmhUaN3ewDzXN71Pe6fy+3RPTlSXiwC1oIxmDA6tx5Rxnc2mVK5jCntHB7WhtfqhsK9Pn+2Yyjo
	OTMaMNtCMI7k7yqr78xtQ9oiiWqx1Tw9ue1I3rBro+tgS2y/fdEZ+f+E+xs5j4Q+RAnq9kEQyzUbR
	+kYSOGF4k+pVVCQKcRkKVHTqrh3+I77Ykj1TP8IvNlk7vGLIDGSxt0sMn80+4d37RKMY1+7wHaKlH
	esASzAqtFJxvUqEYuNCEosGAoa9q9F+//5JVntfr6Fl4Ihn5M7DQLtLRWdXWwRLBImCbLWiyypxZK
	BSfGCsnw==;
Received: from [2601:18c:8180:83cc:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1v1uBC-000000008PQ-0cEe;
	Thu, 25 Sep 2025 18:11:10 -0400
Date: Thu, 25 Sep 2025 18:11:09 -0400
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>
Cc: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hannes@cmpxchg.org, david@redhat.com,
 roman.gushchin@linux.dev, kernel-team@meta.com
Subject: [RFC PATCH 00/12] mm,cma: call CMA balancing from page reclaim code
Message-ID: <20250925181109.11dd36e5@fangorn>
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4xgj8ge9kkanbonzz793ndgs96d1zspu
X-Rspam-User: 
X-Rspamd-Queue-Id: 039D820012
X-Rspamd-Server: rspam04
X-HE-Tag: 1758838297-375112
X-HE-Meta: U2FsdGVkX1+3mqpvL5y1/noeDlfvpyT21FJ3bWPFjGak/9jCo3WXa5uWI/evXNAd4+OKLNjR7NFkYepKGwfuHeZq/DDzKGtWLfKj1qI1Y+IxZW61cDo9Tw8V4vOXZ01AgcurrWqo94lYq+judJLSFh1FzMupoWwdlmKxnWbPAWFolcWDHMF12xFyKfMsRspaXnV+H1fgIGmtQE6hzg6eHImWEY5YC1i/oBQnrrOK7Exi76XzRrwwpHkgdVCF6ReOCi/acHEBBmXL+tDCF3qbUg07aQpJuZkNCNW4H/s9UUkfXwA5kjLcQw57Ko4OgZe4j42RIVGLQkYpXAWkE1/LRvn4+EuY1RZqALHVDIN6FXqOMPMDG5SCanQfGVNRqfLOwKWfDcialmG/x1UwwnWjcTt7uyTX8vmqejAzw417nS3skPqa3WF2enFW2iPHogf0kFT8tjCIdJ20wSK+ws1oP1LnSYaWJ2toMtWueXvlG9clJSx9QtgbDyouyFEGmmopgtXJ7TvOCIpcYTPQ9Gu8uexoLL1srwFWNW5qwU0KLyQuEj/4vGUDkZUL4gNY/4HWLo9zTfFVVGNRUprePALfv4VyZVRiSypm/kE9QBKDaOAstaICfqT5zqbvHQ5PUA7Rx23sd4AIlB3bIsoCpVRihCEVPtQ+TsQZTiBGksG4qorHFzxtCXwSbcNpuNfiP0PUjc7UEaA1aIX0WOunEWCcPJveVGHDfkGl+VEZSb1oOv4v5yJkYuNbhIp7yjavJztjdJTUKYlAgaVURpa4gHZYOCEG3GFqR7K0oVPyOZXUpp2yObI2lGkY9CMqjQ7GMnCwLJW5+pLTEe5ecwWJycwy4qYpADeBPVpWKhimTG+f7gBkcSmTjDTxitS03xq3d2e1h/P8Fsa+Vdyh0YoT94BnWiC63g+jRHJ02wJGMZJF3GFCA4vF7lpfUfcfTEYuQpNVlFHR/pYwRmgWUrZabli
 eNzVbwfn
 Z1AYy2mtqmdLdJVa5szrDW9HpmuZauElBGaYta6dFlg5OgAZmts0HXY+/I3R9Gwuus/DnmS2krrVopf7t/esqoTmV4knXPwXce2NgwgsJPFEAicUYyftFYHM4qekNJGzREIQ04V0LXfE69Uz+KOHel9EcJ27ndkq2htwi2V0P8Rt9EHlCPtcnLX6Itrb7yhehJH+tXQ0s9ExWPx+ihnmUczv732zs9y61/4JPi01NRSSd2qfahSvYVwb09a+sB6v00UefAZNykebqMpBdOiwKaipB92b0YG/TAZPCGZo34jnZ8dklT2VMZT/22g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call CMA balancing from the page reclaim code, if page reclaim
is reclaiming pages that are unsuitable for the allocator.

To keep direct reclaim latencies low, kswapd will do CMA balancing
whenever some of the reclaimed pages are unsuitable for the allocator
that woke up kswapd, while the direct reclaimers will only do CMA
balancing if most of the reclaimed pages are unsuitable.

Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/vmscan.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a48aec8bfd92..ec6bde5b07d3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -168,6 +168,9 @@ struct scan_control {
 	/* Number of pages freed so far during a call to shrink_zones() */
 	unsigned long nr_reclaimed;
 
+	/* Number of pages reclaimed, but unsuitable to the allocator */
+	unsigned long nr_unsuitable;
+
 	struct {
 		unsigned int dirty;
 		unsigned int unqueued_dirty;
@@ -1092,6 +1095,19 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
 }
 
+#ifdef CONFIG_CMA
+static bool unsuitable_folio(struct folio *folio, struct scan_control *sc)
+{
+	return gfp_migratetype(sc->gfp_mask) != MIGRATE_MOVABLE &&
+		folio_migratetype(folio) == MIGRATE_CMA;
+}
+#else
+static bool unsuitable_folio(struct folio *folio, struct scan_control *sc)
+{
+	return false;
+}
+#endif
+
 /*
  * shrink_folio_list() returns the number of reclaimed pages
  */
@@ -1103,7 +1119,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0, nr_demoted = 0;
+	unsigned int nr_reclaimed = 0, nr_demoted = 0, nr_unsuitable = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
@@ -1530,6 +1546,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					 * leave it off the LRU).
 					 */
 					nr_reclaimed += nr_pages;
+					if (unsuitable_folio(folio, sc))
+						nr_unsuitable += nr_pages;
 					continue;
 				}
 			}
@@ -1560,6 +1578,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * all pages in it.
 		 */
 		nr_reclaimed += nr_pages;
+		if (unsuitable_folio(folio, sc))
+			nr_unsuitable += nr_pages;
 
 		folio_unqueue_deferred_split(folio);
 		if (folio_batch_add(&free_folios, folio) == 0) {
@@ -1641,6 +1661,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 	if (plug)
 		swap_write_unplug(plug);
+
+	sc->nr_unsuitable += nr_unsuitable;
+
 	return nr_reclaimed;
 }
 
@@ -6431,6 +6454,10 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 
 	delayacct_freepages_end();
 
+	/* Almost all memory reclaimed was unsuitable? Move data into CMA. */
+	if (sc->nr_unsuitable >= sc->nr_reclaimed - 2)
+		balance_cma_zonelist(zonelist, SWAP_CLUSTER_MAX);
+
 	if (sc->nr_reclaimed)
 		return sc->nr_reclaimed;
 
@@ -7169,6 +7196,8 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	if (!sc.nr_reclaimed)
 		pgdat->kswapd_failures++;
 
+	if (sc.nr_unsuitable)
+		balance_node_cma(pgdat->node_id, NULL);
 out:
 	clear_reclaim_active(pgdat, highest_zoneidx);
 
-- 
2.47.3


