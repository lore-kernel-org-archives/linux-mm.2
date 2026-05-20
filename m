Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B59ECD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B3F6B00B4; Wed, 20 May 2026 11:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1700E6B00B7; Wed, 20 May 2026 11:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03A06B00B6; Wed, 20 May 2026 11:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D97756B00B5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 976BBA03A4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:00 +0000 (UTC)
X-FDA: 84788110680.19.6966F22
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id D1831140019
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ng/wS2QP";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXkdeLHggCi+vFtKz5fxgfs3r4RSBpj9N/haZRnpGWk=;
	b=vPybfna1YJX2QjGrpU5unvacV3cvJgoMBk36SnV2VP+sczPLC78Dmewehh9mNRnjosYoxw
	3iJt6sN5qKCkTWOaIJM2tAhnUO9gVDJ0+LIFU8ZmPpurffg9/a+Ez8Jz6Pc2Wu4o9zcIna
	bpJQRDR9H+pp4/67c9lP2Mtuk3RaPwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289258; a=rsa-sha256;
	cv=none;
	b=fqPsHgXXkdUKN0jz8WNG/cbHanyOTgm2a+MQlW1BkqVvvWiNs7hfKeAdcY8Hy782Fr1UPG
	eWBG/H+ovJlIdLpAZbIeUH8RU/PIsKl935sfhlMMIbfXKKfSygXOjL6rnkIs1j/Dnbdb79
	2EBDBxVX+aO0JuFfnfuYZXGWsccmFQE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ng/wS2QP";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uXkdeLHggCi+vFtKz5fxgfs3r4RSBpj9N/haZRnpGWk=; b=ng/wS2QPNAoNUjMcCITdZpjGyD
	5FSsZe/eW2L4IzCJ4dBed+n/ZuJgwwDcK5k27IpNliI4efJ0rTMwZsxebn5ApXkaRFEKF2j2fzxXN
	FZGQQQ6hhFLqg6buA34BNF3c6KpNJp6rKfCpHD2+KGcG4KNWZ2kn/2hbXmaFcSEUqwdcqs6AFKe4B
	rML1EbV5LyxbDuBBJ+75iEnBexLzik8nkGdV+r24uNX1sut0FK3H88VCCfEwouZacXecmm48xQiZ5
	1yvZak5ph2d8ppyL7MfvQZ9Ee44A+Aejdh76bUOuKfiRNK2TmJL1tl6ef5N4NlQhYUz06d3BBZBpR
	sXawct+A==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPN-0000000024Q-0ZBm;
	Wed, 20 May 2026 11:00:29 -0400
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
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 38/40] mm: compaction: skip empty tainted superpageblocks as migration source
Date: Wed, 20 May 2026 10:59:44 -0400
Message-ID: <20260520150018.2491267-39-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D1831140019
X-Stat-Signature: qwctk7i63tz75gu3ybbhzy6boqdrcyzs
X-Rspam-User: 
X-HE-Tag: 1779289258-144656
X-HE-Meta: U2FsdGVkX1942jbqcqrFl//yzWAfeem8zSi2m8uZmXb3RuPjar8C1/VwGlZD+LcO/zKTfXKUucWsKsO46xO0/iRzVeCKSNB1O5qnKYrqWL6+nsGwB3yz6e7Wq4Bf0UZXnlNqu28cB8tMSgHk2tTE0rNMhPXmx4qhLpOPYAjVnZJCm8ITwvqyFwFv6+x7/PXiLKLyW4jaaJfme0F8kXJ3grCk9JxYqQitBeVOe7qhhJafSnMC428bhgBtOs0u/lIKMP6QcrpERsuYGwBC9B3OrbKa20FqOCA8vHTjK5GbcHPhvgNubKlXiHrT4O16l8wlGNtGwcKE7V0elnaBGOzqImAGg2bSUr2ZIF+dGm4/URKelKvEj/Z6mMpNz2SU4x3habV5E0XlAHClvBlXx/hitVIiwJ55qHtBCVEPk/pfZfh8rCZ+q91TP0gZvb9zOT4cexYeNqaFd2Z5ekNEcw6/M23YFo+FBb2t8M2XctPKxXJwwpDs5yQ7QgOYdiRZ8mnIZQ/fZxA4jiaXorBJ5aCrOoKu6OtywCDZXwcJrwbEYUEspE3s+E93XTyNtfqqdQhf80Iz6KIrpuarBzGARFRiDHLe/JbY8HhdGwxOnBQ9BCLs5C06ZsvV/11p5rWo9CdTDhopJf4shxoxXmJwtmN/oBV7ChMqwgKkUiYOifm9YUchGszDisYtV/ebdrgfJ5V0YoHqk1UZEAjZTxj7YPfRCa92PgVa51OZvsgEV6eJ1Gt615+zJNaMOO0vv1LP6QI7v+hpW+V1T+TSdKaEEO6Wl3lS/YlMiMeOBkCwvBxeF9++hxv8VcHDBWf9znnmHEb6vZqMqL/qSbFQUAkTF21kPxdL1g10G7TE3297216Je0vZv7m+m5Mn6azN2QwOHlKU1bmmQxqhDeZcef3Op9Khsc7rTyjR2m4936CMe7+BMUS+knlmkzvc8lQIdt7Xxc+J4MFVfta6YyhpNOglh7a
 9PCGWTWC
 QQzFfAREdwLBLOslYjLBWjeOOZzefvfAw4uPiwDTeeZo98Nh9ADxRYFn9P2EG2Wnwu6nsym3B3nGfpW7W4Q6rOu70LMZ8Saf3L3EL+HaS4S/5vbscVPo1xnWxIyKCLM6a9ttA9rt3gE5iUoNLH4Vs9NkRV5gCCLcXTjgYVlFn4egD5qnPhX+cJGZTbokTSOifJfg5b5CiPmZY52PJ8q4mFRuANPZd+1IDRvWMfoShujaBhU/KuvdRjPoqtcsyCU+GQR3AjyEVLWA82Dm5LmVq+FWRBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tainted superpageblocks with nr_movable == 0 hold only unmovable and/or
reclaimable pages.  None are migration candidates (compaction only moves
migratable pages), so scanning them is pure overhead.  Bail out at the
top of isolate_migratepages_block() when the current pageblock falls
inside such an SPB, returning 0 without performing any per-page scan.

The caller (isolate_migratepages) then advances to the next pageblock
and re-enters; each pageblock in the empty tainted SPB takes the same
fast bail, so the whole SPB is effectively skipped without per-page
scan work.  A tainted SPB with nr_movable > 0 still gets scanned
normally, preserving correctness.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/compaction.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index e4ba21072435..f9de52875c88 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -873,6 +873,27 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 	cc->migrate_pfn = low_pfn;
 
+	/*
+	 * Fast-path: a tainted SPB with no movable content has nothing to
+	 * migrate from this pageblock.  Bail out immediately and let the
+	 * caller move on to the next pageblock; the caller will re-enter
+	 * this function for each subsequent pageblock in the SPB and bail
+	 * the same way, so the whole SPB is effectively skipped without
+	 * any per-page scan work.
+	 */
+	if (cc->zone->nr_superpageblocks) {
+		struct superpageblock *sb =
+			pfn_to_superpageblock(cc->zone, low_pfn);
+
+		if (sb && spb_get_category(sb) == SB_TAINTED &&
+		    sb->nr_movable == 0) {
+			unsigned long sb_end =
+				ALIGN(low_pfn + 1, SUPERPAGEBLOCK_NR_PAGES);
+			cc->migrate_pfn = min(sb_end, end_pfn);
+			return 0;
+		}
+	}
+
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
 	 * list by either parallel reclaimers or compaction. If there are,
-- 
2.54.0


