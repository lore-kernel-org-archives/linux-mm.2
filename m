Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DAB1CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13006B00A5; Tue, 29 Sep 2026 17:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C25A6B00A6; Tue, 29 Sep 2026 17:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1356B00A7; Tue, 29 Sep 2026 17:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 538AC6B00A6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C36E0140618
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:39 +0000 (UTC)
X-FDA: 85268152158.03.5FC2A72
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0397F4000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R132M7+h;
	spf=pass (imf27.hostedemail.com: domain of 3YDO8agoKCBU836vJGv3D219916z.x97638FI-775Gvx5.9C1@flex--nilayvaish.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3YDO8agoKCBU836vJGv3D219916z.x97638FI-775Gvx5.9C1@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Wm1IURbc0+vf3diG/SgSb6OtcSfp4vt1b6dn62K85s=;
	b=6c8e3Hz+m/h/ggXqMyAMK+5t5xOfbIsKsa/Cm4s9IqfkhZZOYL2ifFMW65yUfL9kKWJpqt
	r4HPITZQwutkfv0lKacYIblX0VUPi8/a/tb8socH43b3STWEDKRjm1WQtjMWfOp1RdW/MH
	4++z7frMDWxBu/50VJnaYSRD/uXwwA4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R132M7+h;
	spf=pass (imf27.hostedemail.com: domain of 3YDO8agoKCBU836vJGv3D219916z.x97638FI-775Gvx5.9C1@flex--nilayvaish.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3YDO8agoKCBU836vJGv3D219916z.x97638FI-775Gvx5.9C1@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718818;
	b=R0dCJPYOTuhOvJjL/bPvFFXvhukWlUVP17etuu/r15wymlkeon0qw8fB867+SPXKrN/lTF
	bATcXvpKsQN6wS08M9J01NkycoI2/aB6Laysr5LHWf7PrfbU+dnItgB4e2CxV+8x6xGjYB
	waJ1BUfeAjfuEiTpXWI7MH4WF5s6dEI=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33713e5e6daso6925254eec.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718817; x=1791323617; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Wm1IURbc0+vf3diG/SgSb6OtcSfp4vt1b6dn62K85s=;
        b=R132M7+h+VS3WHc1SFaDh/yaRKqMpKLBXYgt5PXUZjk512j1RkJZG0V3R/ly/EXRyA
         +FX6Fu0aw1+S7dCKqCT9mZVJoFFvgv+tPOjxWa4f6SvRTBmnU5pj4t2mRgZ6FBoHwe1E
         BWIZlYJXhhb+7K9iV9kdrhSNsWf85QssFlyQ7NpbXo1nKR5vjc9871TF6DHFd/spc+K1
         Y1p9pSgnI3juUJmlO7mFlkfkkbBvNlz0quNPmCVr+jlESwdF+3ghjj7vxN+v+iYiDLWP
         j2mg079NsaQDZBdWCiFaqzO7Pws2XXGBKBKuy+vpuPo1QzGyHsuKd8Cs7gFyqxtDs70U
         sB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718817; x=1791323617;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Wm1IURbc0+vf3diG/SgSb6OtcSfp4vt1b6dn62K85s=;
        b=a9rnrFTSVrSeFCH2b6zIagsBkjcl9v6OAjL01o4MwXm93dV/vmJLWkoEmOwRsZn0ei
         I4QL2FsF3CuELPCvjekli7+XuWcc1p9uBV9i1QH40He2I2ZjTfWyQJIbV9s3Brh81hVs
         Atm1F3J5jhyQrDZax1ydx8EYV5xe11LW+w3H7/fpSIrCUrXuQNGGxnbtDIuE19lBDtUn
         MnSSEA9gLvja5z36UsmXJnyQF4NBVQtAcmHzm2mTxVI+EpjzNlmfXRXN/OxBBPT13nEe
         VB8z7bZ5Wy9hZVdnAaf/7D5F4XXYtcJ+JJT0LU0CDBoU+bQVPyo6Rchp5QZinKA9Wfd1
         Yeyw==
X-Forwarded-Encrypted: i=1; AKwUvBxp2uXFb9LZonyYAXKRJL2Nl50XLrk1u7rLKGp/nV1N1bPPlkJBPbKDcZkrhrH8PkddtsVcva04/A==@kvack.org
X-Gm-Message-State: AFuF++kqD31zisoxEHYtcE/JW6G3OfZmi7YieXkYU1C0uMj9iLZlKWzw
	DLytWBjV6qwPM/4jGfpBOyowPSnjetkaSDF0qI5QDqYau2uYkfNXP/r9QfZ0a9asiKwz9rsYJNS
	+CGw4GjwXVP9uJL1qHRVLDg==
X-Received: from dlbef6.prod.google.com ([2002:a05:7022:f46:b0:14a:9017:9767])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:ed09:b0:14c:1f57:3e86 with SMTP id a92af1059eb24-14ca066e61fmr545721c88.47.1790718816389;
 Tue, 29 Sep 2026 14:53:36 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:52:04 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-14-nilayvaish@google.com>
Subject: [PATCH 13/15] mm/page_alloc, folio: use folio_page() when freeing folios
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0397F4000A
X-Rspam-User: 
X-Stat-Signature: 8afgha6sny8ge1ftq66ceojb1a83ampw
X-HE-Tag: 1790718817-841839
X-HE-Meta: U2FsdGVkX183AFmLgfgGmBlAHsZwPSkDTSJURf0CG5zPEfPYT2LIZAASd8I1gX0JUU1z1J5TCwVLGOxQb5/3IjXDPG8aftYaPlV/Z0r6S6JbUeXBtN/nPik98CkFC+Op6Eee1TDlrXe9v8c1mz0mSrKtgAi6nd+Qda+XDYX0l8x5xm2G9zk6gHKT6kT8fspL6LUi8Q0Iy9iD/Vb2HxkJI0ZksWxySuSqG/ZmKhcxmG/kdj3wqR01d5HObEEVDut191bMJL6uuFSAorNy7ZeWEExZDMp/N6VtCsGnBflO/eU0SEeaCp3Lht6eqQn5dqmh+Qlt0EoM0tD0lNIBV7VaPfloGQ+Jxp/CtIJezbv0AuinYd4bi/htyGumD2xlVWGw2y4ZCy7UC/aqY62PkJj4tcFOfpNbjfj3a6NR//JZM141ozYixhS4K4e1AMJO27iNrLkrYFekXAFascN4wU7s42uXq+ExvUpyvaq/kOwkbdmUT2sH+hPCp3hMMD050p/begytfCU+4Z2e5kjR2ieXQnV+67iEYk4XKyAkTI2H/M0sFgV1sRZ3TYzkMMoQ9zUDasbilot5NZ3LYz4BqjiSzLteJ4GQhyeU+vj1hy5EB2SgnAbb/nCXx/SbHnqeAL2iujBG1adUG+tMyAkszoMxTGsZwFHOoNzplw4C1YMvHeXxAS5ZvCOG5PcDF7CWKtweLkTdNTXgAOVn7o8md1SHYZZBnaQHDuHrb930LWBmbar9ruR6YLg9LwuTK66b7RiZJcvJIqBBEDxXBR/C3N/Xb8MUKZq3SsElnknkiO+l0s0G11pKRHfcbelf1GvMe0iTzOs/rpfBSP7YctzMja14UcU+Ia8s2uDF9MnijQA115Ry8PNiE/3RmYFe/HnvybzWlZyXwOO8G9HD3OSAk5+ipql3UTrcGPZXpCJFkF6ANqp0kuNYCJ96qKqg0hso4WjzLWb9UeEynUCU983BvIf
 q25CJoYx
 DD2sgQcr1QepG8KEGH2mg+cCyXI3Osym/AJsMVLBReueXVV4b/p32RdGBeqh3wPfCCyl8/ULNXXcClHCGdCewDLqSKmrv15jUPrZsf59EQdXsEAQd7g/HYZr0RwT7LgM9qZewu3V7k/H7F5xH8paqwwv4svCpngRRRfI15P1ou9kaeyqfN7EpMWykXUxOzzYVg5ypp5Qjvn47Me7GDoi+IBdH8917EIc6anC5U2+TpAMZHa1tewvaoxGnuN3qLwX8ThjoNO5AtBjkQ8lIX4MkgnMfUxEt9vgycNfQn7w9NaKpbQHiQwGH40O7hYdxjfnShsNri5MoQWe/vGL+jk4eGiivL19XQI7dnM9+E00xISu7zc+7fA+axv0RKh7WU3IBgpUq0bKVwwZYakyVh+19jxoY2AMIkDV94pSJHXmnvjQOKzxHncOm36rOj5Ux3i2C8zsw0Xt1pZQTJFgGMXRMqT6IyiDbWGDNeg10OEt48t2EpDIm08QO7JfonOpvrcx2+qQVc82sHRqPDTe1gB6p6HHIitO9Dwxkniha5qeD6y9ZuRBTG4Exd9cQdWYKjvxW3d6DP4FZ77Wz883O9DB0WENvyvC6J/J80ReeZNBAIfoCjmMa5o4OAosB92DfTB9w9A1pPm/uAdUfJLxjTyjAnEcupA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace &folio->page with folio_page(folio, 0) in __folio_put() and
free_unref_folios().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/folio.c      |  2 +-
 mm/page_alloc.c | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..978565add078 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -103,7 +103,7 @@ void __folio_put(struct folio *folio)
 	page_cache_release(folio);
 	folio_unqueue_deferred_split(folio);
 	mem_cgroup_uncharge(folio);
-	free_frozen_pages(&folio->page, folio_order(folio));
+	free_frozen_pages(folio_page(folio, 0), folio_order(folio));
 }
 EXPORT_SYMBOL(__folio_put);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 07e03c7c7771..2f8cd3da199d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3006,17 +3006,18 @@ void free_unref_folios(struct folio_batch *folios)
 	/* Prepare folios for freeing */
 	for (i = 0, j = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
+		struct page *page = folio_page(folio, 0);
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = folio_order(folio);
 
-		if (!__free_pages_prepare(&folio->page, order, FPI_NONE))
+		if (!__free_pages_prepare(page, order, FPI_NONE))
 			continue;
 		/*
 		 * Free orders not handled on the PCP directly to the
 		 * allocator.
 		 */
 		if (!pcp_allowed_order(order)) {
-			free_one_page(folio_zone(folio), &folio->page,
+			free_one_page(folio_zone(folio), page,
 				      pfn, order, FPI_NONE);
 			continue;
 		}
@@ -3029,13 +3030,14 @@ void free_unref_folios(struct folio_batch *folios)
 
 	for (i = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
+		struct page *page = folio_page(folio, 0);
 		struct zone *zone = folio_zone(folio);
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = (unsigned long)folio->private;
 		int migratetype;
 
 		folio->private = NULL;
-		migratetype = get_pfnblock_migratetype(&folio->page, pfn);
+		migratetype = get_pfnblock_migratetype(page, pfn);
 
 		/* Different zone requires a different pcp lock */
 		if (zone != locked_zone ||
@@ -3051,7 +3053,7 @@ void free_unref_folios(struct folio_batch *folios)
 			 * allocator, see comment in free_frozen_pages.
 			 */
 			if (is_migrate_isolate(migratetype)) {
-				free_one_page(zone, &folio->page, pfn,
+				free_one_page(zone, page, pfn,
 					      order, FPI_NONE);
 				continue;
 			}
@@ -3062,7 +3064,7 @@ void free_unref_folios(struct folio_batch *folios)
 			 */
 			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 			if (unlikely(!pcp)) {
-				free_one_page(zone, &folio->page, pfn,
+				free_one_page(zone, page, pfn,
 					      order, FPI_NONE);
 				continue;
 			}
@@ -3076,9 +3078,9 @@ void free_unref_folios(struct folio_batch *folios)
 		if (unlikely(migratetype >= MIGRATE_PCPTYPES))
 			migratetype = MIGRATE_MOVABLE;
 
-		trace_mm_page_free_batched(&folio->page);
-		if (!free_frozen_page_commit(zone, pcp, &folio->page,
-				migratetype, order, FPI_NONE)) {
+		trace_mm_page_free_batched(page);
+		if (!free_frozen_page_commit(zone, pcp, page,
+					     migratetype, order, FPI_NONE)) {
 			pcp = NULL;
 			locked_zone = NULL;
 		}
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


