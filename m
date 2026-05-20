Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80940CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF67B6B00ED; Wed, 20 May 2026 11:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA68B6B00EE; Wed, 20 May 2026 11:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995FD6B00EF; Wed, 20 May 2026 11:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84E566B00ED
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:11:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 529461A036E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:11:33 +0000 (UTC)
X-FDA: 84788137266.01.062F040
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9EFC640019
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:11:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="f5AW/Fqk";
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgTR8MXGEfuZkiCxXrjBV2lPgK1Sp/fx+wzmK8Ohvys=;
	b=z1VFE4fid3Wpbm6LyvkzXw5xZsdPlKRxvtuhR9sg6y4kEqLdDVeESHrrCPZsa07EminRtr
	CbVQeKgN4hCuTiXYKzDtDVD3x5diMbXeCtXpnT4yvf6BrnSmHbWNLWEkxXmVxkc8ud8lgF
	uBxTvGkfk9aJIws6K42pZjKBZUCx43A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="f5AW/Fqk";
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289891; a=rsa-sha256;
	cv=none;
	b=xj2fv9Zi6FyfhcN41zfiOWnRWh3u9WUc0NghFyUlQvrAHpdWNvWW4pas3t1e/wQRsHPNgM
	d1xG6mM6r83kqpaoQl4fa1ympkKq7uaNO2MhkWJPTKValWoKbG5BZYAPp9rtI9mxE/yfxR
	IYt2xByr4Q0ITziLrgcHfgEaRuUHUjE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kgTR8MXGEfuZkiCxXrjBV2lPgK1Sp/fx+wzmK8Ohvys=; b=f5AW/FqkAgj7z0DGFu9w4cBw2N
	WcrdccVsn6mnShQ3g+LF1B382noR9hBdYJxGn2eAt8L+SrCyApBFclSQV+UcMOEFo62dnI6hwc8M6
	KEIegcWCFXj4oFpj4WW7RW7A2hmyIiz0pIEx0sJzTVKVDfSM2TZWBjCa8WqwzSzmYaGsLBICkVHEr
	RClmwLZr/1msvSbgFj+2fhtj6LXzNBAhcoIuH6P8IW1To04EhBbRJa/tFv7ERy5EP1AJRpbqTqI35
	8FJMQtiQKZ+VO6kHdehJgW+gCdOWvXTFr0tcQHRcVGWMpYiZYgJiqHq8wEXb1OUON+kH4t0c1l95x
	kkRVT+sw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-3zfV;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	linux-pm@vger.kernel.org
Subject: [RFC PATCH 33/40] PM: hibernate: walk per-superpageblock free lists in mark_free_pages
Date: Wed, 20 May 2026 10:59:39 -0400
Message-ID: <20260520150018.2491267-34-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EFC640019
X-Rspam-User: 
X-Stat-Signature: h43tk8e8p3jxeq6xibanc5sgg4adjfzf
X-HE-Tag: 1779289891-810283
X-HE-Meta: U2FsdGVkX1+Bebm0PE2PkWl7CmVZTTwEZK/zKD10v3bdBKzkiECB0vw2jIVVi9coA+6XHWmaC5xWFFc6HxiRJHZMwRTmGPvHqvnAN0OYxTxumsuhlztyUtlcBp3FE20Uze5gb4CulGfTMuCKvRWxyKxdr1lqOuirXItZBb0vOE4ub3XgBGh4nWPw0XqsPTi6Fcn/TMyhKoL2CHP3vj34YctEm4uzXgiYFsFSw1ErfYRippcFPahIHNW7fXnuRcmvus7Peh/Im6fRLCJgMGEXh6QwdmDwlDk0pb4AbNW2ds+zrn5XQEEeSumCM4Gr36zF1RixOyXOmr1Pkmr4lFqdROFz9hQ3pzwVeM5Zg49G/zwPXwIeyaar0GY9SQ9h6u4yUkFtHZ5fwviklR9PoeEc4V4j2NFP5DQBHRlgGTF2cPDgjlKolvRkp5of+sSzPVz6uHFwI9cAujH2wI+r4BBL2Q6x26xrKvI5wn2udeVAk7CsVdPmF/I+B2vTVNUObeGNdxDfxmnDp+JXZj680uN/BlysCyzTMwME4INy8P2sEjmtuaem2Bi2MHnvR05+1h6QwhFrnmJkrdoxqcaIvhpOtPJ9VsWaILhcJX2huCqMUoHLp8xAR+0ct1rZnicIyw5ohupy7vfKS1ysQrl9K2nl+9nuQIqLCOe0ccJxoI6dV4T3zvM2DOxOlxopwE7f2lENnZRA636a8jB24aduNThmtviXhCi/fPOcvgiL9PYJTNxAL+z180N7tjK9wJlZ+5x5kcwjtlnfSmkar4zJhyYTivdU50TCoG7ES9Y5jC3pv9mh6rIyAG+cEpq/ntBgFA/uiW43Xu/P1MTX1RFfxmU/UaY1xaO6jXT0gkqgxE8e10OLOV/ewhglehxfBegY3zBgbC89IX4BEmRhnNZ4jLh9td52VBudhaBpz3LDGKQhO+9Cyy4UFyyI/YPdGtS1545xVbl2YFKXpHi5QyFg9/l
 l2AisJ6W
 4qlDB35GTRLi+uTYGELWrAdZBX3XCQb29Xo7bsvG+Ox053NRAOQx81bAXfy4H5TY8gbVgNK961daplxgsEt+SNktCeCOzCP9+kioUsb4cboUfT4XN/aEZQvnDW6CVhQUmy8siB30U2kVFVFBBMlyPy6TY58+hBggdiiBRNKtB93DQ6m+SdfjdRrLilt5O0ZmCHsFj2cd4AnlhinBt9SynFeDbv6ZQomOUJTKmP4E4FUHswQZnGulw/H/HqHC7mEWJc6iygEUkSTJNaffXP8DSkiRxR2vJvUPOK/PqdIK18P+3af7RtrqMfRL5yv7UlUYHfousSubWvSUWSGkw8rPf1QLJaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mark_free_pages() walks the buddy allocator's free lists and calls
swsusp_set_page_free() on each free page so it is omitted from the
hibernation image. After the SPB rework, free pages live on per-
superpageblock free lists rather than the zone-level free list, so
the existing list_for_each_entry() walk over zone->free_area[order]
.free_list[t] found nothing. The hibernation snapshot then treated
every free page as needing to be saved, wasting image space and risking
OOM during the snapshot.

Wrap the existing per-page walk in an SPB iteration loop. When the
zone has no SPBs (e.g. an unpopulated hotplug zone), fall back to the
zone-level free list. The whole function still runs under
spin_lock_irqsave(&zone->lock) without drops, so there are no lock-
order or hotplug concerns.

Build-tested as part of the full mm series; kernel/power/snapshot.o
compiles cleanly in that build.  An -Werror=return-type warning in
enough_free_mem() exists on some configurations but is unrelated to
this change and predates the SPB series.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 kernel/power/snapshot.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index a564650734dc..f96885bc46f8 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1270,17 +1270,32 @@ static void mark_free_pages(struct zone *zone)
 	}
 
 	for_each_migratetype_order(order, t) {
-		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], buddy_list) {
-			unsigned long i;
-
-			pfn = page_to_pfn(page);
-			for (i = 0; i < (1UL << order); i++) {
-				if (!--page_count) {
-					touch_nmi_watchdog();
-					page_count = WD_PAGE_COUNT;
+		unsigned long sb_idx;
+		unsigned long nr_lists = zone->nr_superpageblocks ? : 1;
+
+		/*
+		 * After the SPB rework, free pages live on per-superpageblock
+		 * free lists. Walk every SPB's list for this (order, mt) cell.
+		 * If the zone has no SPBs (unpopulated zone), fall back to the
+		 * zone-level list head so that any pre-SPB pages are still
+		 * marked.
+		 */
+		for (sb_idx = 0; sb_idx < nr_lists; sb_idx++) {
+			struct list_head *list = zone->nr_superpageblocks ?
+				&zone->superpageblocks[sb_idx].free_area[order].free_list[t] :
+				&zone->free_area[order].free_list[t];
+
+			list_for_each_entry(page, list, buddy_list) {
+				unsigned long i;
+
+				pfn = page_to_pfn(page);
+				for (i = 0; i < (1UL << order); i++) {
+					if (!--page_count) {
+						touch_nmi_watchdog();
+						page_count = WD_PAGE_COUNT;
+					}
+					swsusp_set_page_free(pfn_to_page(pfn + i));
 				}
-				swsusp_set_page_free(pfn_to_page(pfn + i));
 			}
 		}
 	}
-- 
2.54.0


