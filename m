Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE48C982F7
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E606C6B00D7; Mon, 21 Sep 2026 08:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38CE6B00DB; Mon, 21 Sep 2026 08:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74EC6B00DD; Mon, 21 Sep 2026 08:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A543D6B00D7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:31:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13B7E12016E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:31:39 +0000 (UTC)
X-FDA: 85237705518.08.518141A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5642BC0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:31:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hC26Q4qe;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789993897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hgW/FJkW3mwJCGKwE/mUcy/xjFFdmovY7N91WUWEFM=;
	b=MV3ek6gDuZhiZ75eaHuig+0NFosvME3boHpX9wo/PkdxCsjmG+a56B1sBDnMu0D+Q4FXLe
	5lCJ9Q5Mm4FjUG8+KsjarWMCKooAQp0l2u77Mfo1hFouyPF0iGhzE72LFupOPxka2/DUCr
	yZqS0CXB3jvNLy5+IfQQ/A24WsVfUqs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hC26Q4qe;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789993897;
	b=RNX7OwUUcYfBGdfEAuKDUCBBCEEzr+on4uFr2vx77sxq/FrNHlfBzr992oBWfHnwgN9d1T
	4Vudyc3oVUIACHNGoV/2f7KM4NRvD0S90qmIKyJN00tFP0V2cpUd9vL1fx6PBYC5NEulgg
	3Zo5DB+HbhSeLAWmRIWUzbsddaGI41s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=4hgW/FJkW3mwJCGKwE/mUcy/xjFFdmovY7N91WUWEFM=; b=hC26Q4qecCQvJ0tcjkj2v/tsuX
	qVcXeyp2OjNQ0RE6QFiHeSNjmbFHucskq0RJNSlO4a/tXIf4OIpDe2EOn5vKxmEFs0sbB4CKy5Z3Z
	R5FbZCYK7t6bfvrSzRG3lZkzqWdH2iV04tpFZ/gD/YScfwm74ZgMas5eXSOajgSJ95j81yjK7dAKY
	2VUrv+Fh74RgpvQigb6EMxSNZ5FcA36+AVx3vWFX+QIg/9QBgOq20dPr44rK7bfqEdS+YvM22r9gY
	wH6GqGpg+suQbdImjSp9YEw20Y2A7gVjdK8G+mvV7UNJGGqmssbvSjEh2rqTB8QEdUz+hUIR7Asxu
	6zOFJ2Tg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8dBH-002CbZ-1W;
	Mon, 21 Sep 2026 12:31:35 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 21 Sep 2026 05:30:27 -0700
Subject: [PATCH 2/2] mm: kmemleak: scan the struct page array in
 MAX_SCAN_SIZE batches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-kmemleak-page-scan-v1-2-fb97d4801b3a@debian.org>
References: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
In-Reply-To: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2932; i=leitao@debian.org;
 h=from:subject:message-id; bh=HJ5nwvE4BGwjNEPPGJ48wKJt/yd7AFzI93B8qcnsppg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqsSOdriwWS76lw2mmVu50YCXUKoW/8idyboDiJ
 HUO7c2CQZOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCarEjnQAKCRA1o5Of/Hh3
 bfwSEACgjjlP64qqLp9HIM9XrwDJpwy21iR+rcS8/Zaa2PBasil6vpvB4qpzQ+0NoUGhUTtTW8L
 CAH/mHe5ZAXEEYWEO5rsrGQuQ907IrNckn0dO8rRpq/hQihiughnGexmWju2jv5QB8Viksw3ELT
 1k5bPp6wQICRp67FYXFljlmVkpkA6dE13CMgFZ4zEfIK9r4C5h7zj6QEVrOrTOPUdpV8LUPwli9
 0L+vEiEQyHJq9Z0qEwx4QT//hld93MdLWv72TFhhJXJp9wFKlOEn/PkqXhr7qBRMqu6CT3MmuEX
 wyR/WQXwPe+JW/oYYep6vCJKiHLQVIRg4ZeFem8acP44UKKaX7U8q0dgYbo/i1aok4s45TPysHT
 M2V99jOwUdnBZclMOg87JYjGkz3BgeUs7EX3Car4YeMC7Zq3P7gJ8DJ21fJxAalKxbu2ghFH8OA
 XtPLnJeA77+JqE/MrfzBphMAiPWrG2at/SGHKzwOcyU+F1I50FrxhSDSgMqpyGDKazKrQoAuWdq
 0N2TBAPZKABDU4zeUEXt8WZ361DSbCZMkRYYbOmDeGT9zvAf+GcVH3xDz2byU7k4CclpPtab8p1
 ypNLqooJr9TP+NYbopVSWlBP/hz/QIxvvE4GjHUHymeCW52WfDB0mfbQVITHExZG2docK57XUPD
 uTYKxgRns17Tm7w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5642BC0006
X-Stat-Signature: anw33j13omojddj377xrooc4ae4sjpg8
X-Rspam-User: 
X-HE-Tag: 1789993897-503951
X-HE-Meta: U2FsdGVkX1+U3Rhlbr/alEoLlCU0/g64rliuaE72+LdNADY5pOzdA8nPSAI0C1LwteJp6cO5/c0ioutagWUcdamb0wB3hI7qmcoye6LstP0LPb93Egq+u0TxbEUyoaalsih/jwfoKhkgV8m1gMBrXmEDtD6rAj3Pa4MRwkpUWJunF7rDawXeWuYUQAv8pQ9m2JhVVwg1kZ8PLO1km6iEgTOq9SenbmzTC5iPlpbts0fRsoa8dGg1WHTNNQA1G0EXRLG13VgMu4bXbaLKpnkgH7S8w40Hrfmnu9BaaoYY38ZIkMLD+xGitRO1/h3nt4A5zyagM9kqHAjDPE8tSJYWHquAaw0EWfsFIF0yXHNz4nqpxw59V2i0/PX791OpsRJ4fu3Z6KLNNtglFIYezdNpyHtapGWGb4S35a2w9M3kFTaAVNc+BvUX2sQk8Kqw/BPtBrkp5lgd04EWCl+oGtaChPZVh5daAGj7IN7tBD5R1Hl4P9v5HMLIRMlNlK3v9DpzqqhvRrh05SKlp7pmFTeQ4MgsuSdwpPbc3bq7kuvVwA2nfySJ5ArPelqLEklQ3hB8C2i1HDtnBgWk//fE9gkey7iA9qcAfd+Rg6oXlePmXtjJJmZ9Cr1T0E3oF4pEhaVCexIctfP4/jvoVMh6CnJSum2vSHCFM6KOBcgnQ28U8fnkC154BQ/mPhYT3IgvMFC1D436TWO1WcsqvHoYGcpGIZYa+54Tn9jmDWpPXzuTjergA36h4fvg3MSQYHmnEnMzUvEWxjRRx1xmxfHC7m63qP0mHKAhuhP/nbNJ4XAhpTxNZGd4Kks6ByDu1Qv26bZUAK77VIDm+vV0RXFfD3p/E6nhh9INQqPylQ/JV/ajiLB4fiCPfKizJ6vTRKCAmWUaFHOzXQ3Yty6ayXm4XFkGbZnikkJzB9HyrAjtyQoBISzrWmBv2iarc1T72sC1WnLj5A1mviq8AzMiWHFAZe1
 EZJZanmS
 KwyKgsaP9oEMzJ1RBdJmFx9Di2z1FuW5XVy0NVJ5Pz/Lksm6UfksGnLcaEbTAZTvrvVbsJgeoPgj6gahbOJ8jKJEtwl2e46GUBkBX+lIMKYTVLyTugtA5G28NecjnT0z+0jHSevCMJRIEQYs8SuL/gGwAdi9ycD4m9J6dBvzHYkb/TauxluLPTPPl7yIv877aDLmDi37JJioNVqzfpAk/brogmnulLVVjR/qg0f30jFRBfNT+RBTY9xtzre0coCyYL9a3XYc7rNhiZG+rQorgQJfzWtym0ddltT6fBpcMRZc+gCZewlwkEr53YTC+n+GcTG08mBCFiQhWJ3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

scan_zone_pages() scans the struct page array one page per scan_block()
call:

	if (scan_block(page, page + 1, NULL))

scan_block() takes kmemleak_lock with interrupts disabled for the
duration of the call, so this acquires the lock once per online PFN to
scan a single struct page.

Gather runs of adjacent eligible struct pages and pass each run to
scan_block() in one call, capped at MAX_SCAN_SIZE.

The longest kmemleak_lock is now held is MAX_SCAN_SIZE worth of words,
the same bound scan_large_block() already applies to the data sections
and the per-CPU areas.

This can make the scan faster. On an arm64 VM with 24 GiB and ~17 GiB
in use, the struct page phase goes from 4390k scan_block() calls down
to 69k for the same 4390k pages scanned, and the whole scan about 20%
faster (on debug kernel). The win is in the per-acquisition cost, so on
a kernel built without the lock debugging options the scan time is
unchanged. I don't think it will be a problem doing more on
scan_block(), given we have the scan_should_stop() protection.

Coverage is unchanged: a temporary assertion comparing the number of
eligible pages against the number actually passed to scan_block()
matched on every zone of every scan, including while memory was being
freed underneath the scan.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4040547a0af84..cb953df3b414a 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1862,8 +1862,11 @@ static void dedup_flush(struct xarray *dedup)
  */
 static int scan_zone_pages(struct zone *zone)
 {
+	const unsigned int max_batch = MAX_SCAN_SIZE / sizeof(struct page);
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
+	struct page *first = NULL, *last = NULL;
+	unsigned int batch = 0;
 	unsigned long pfn;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
@@ -1872,19 +1875,29 @@ static int scan_zone_pages(struct zone *zone)
 		if (!(pfn & 63))
 			cond_resched_tasks_rcu_qs();
 
-		if (!page)
-			continue;
+		/* only scan in-use pages belonging to this zone */
+		if (page && (page_zone(page) != zone ||
+			     page_count(page) == 0))
+			page = NULL;
 
-		/* only scan pages belonging to this zone */
-		if (page_zone(page) != zone)
-			continue;
-		/* only scan if page is in use */
-		if (page_count(page) == 0)
+		if (page && first && page == last + 1 &&
+		    batch < max_batch) {
+			last = page;
+			batch++;
 			continue;
-		if (scan_block(page, page + 1, NULL))
+		}
+
+		if (first && scan_block(first, last + 1, NULL))
 			return 1;
+
+		first = page;
+		last = page;
+		batch = page ? 1 : 0;
 	}
 
+	if (first && scan_block(first, last + 1, NULL))
+		return 1;
+
 	return 0;
 }
 

-- 
2.53.0-Meta


