Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA37ED7B8B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DFB6B0099; Tue, 14 Apr 2026 05:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397B46B009B; Tue, 14 Apr 2026 05:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286896B009D; Tue, 14 Apr 2026 05:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18B1A6B0099
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:16:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96A43C1D5C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:32 +0000 (UTC)
X-FDA: 84656605824.13.928417C
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf24.hostedemail.com (Postfix) with ESMTP id EAB7518000F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bSzUWx5M;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776158191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUwHi+Ort/Ib9sz8toDLY7SUId44AzcYXWL5RjCYhJU=;
	b=rkszkaHvBssPVfw4ab7Diu0S04WuzJUtiOG+jOfRuSGsas6tXkoY5v4Pp4xQaepKXHOfGd
	9aVmvsqXXFda/b16mbZbDlKsgOhm326QUXGrZpqJ5dgKdghC0YidZM0JGY++ad2JlgdfEL
	1k0nY5AFwwDJIXqPps0IeRVM7GVP/90=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bSzUWx5M;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776158191; a=rsa-sha256;
	cv=none;
	b=s/cAh3UbXP4IfU1wYseVdmZ9x+OQBTUhrzjrUY6bRlvak3GaNytgzB+rgfBzOA3IHv+ZCy
	w1xFWxW0pm3rNbt93hqzASCj8TzhbSej3/a6gLFuvq5+htEqqaV731S7V+xEokKWwfwGvR
	8JyMM6M4b6Qo78WTqS9NvyPa/YRKMsE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776158189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EUwHi+Ort/Ib9sz8toDLY7SUId44AzcYXWL5RjCYhJU=;
	b=bSzUWx5MKFC5mvcnmpsT84AJ0+or8OtzZQhWDdciCAm54q0oDl5GeX3RJt4OyFGfgCc24o
	2iASg8NQc6TZdX2Cv3v71/uzQMPOcxhw+UX82Q1AvjbKDb4M0bDETBoRQ52+iXhQspfRpI
	Xu11Is5OQ36tweOrFYfGq0vi1dUcZ3o=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/4] mm/vmstat: remove unused __zone_stat_* wrappers
Date: Tue, 14 Apr 2026 17:15:21 +0800
Message-ID: <20260414091527.2970844-5-ye.liu@linux.dev>
In-Reply-To: <20260414091527.2970844-1-ye.liu@linux.dev>
References: <20260414091527.2970844-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 6q4mxxu4ex885t9fw9zb9r39zyhnusx1
X-Rspamd-Queue-Id: EAB7518000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1776158190-687492
X-HE-Meta: U2FsdGVkX1/DHTll487PaQmNKDEU69zj6OdbPWkHdBu9tzQgPYoVu0zDHuO39S9/BTosoGkFPXai7Ri03Lj5ybGwYdJ8EURReNEG7cEO8Ugx32UXtlc1K54uivWMdRpQpuvhXWMgez6X8HgR1RJZtvCChZkj83CEGNO/fCQ0xUNrvi/WFHo8uViqCIzmOk7COtGpM/edyWRGcKIxqjBgSU0U4fiLeoeW2BV0rRDVNmd0eDLonNvgzTMPRZM0/mrmFv0izEjexysEMDaPYtCaOqS3tEl3dT1XbQWDcrEcoTktw6BrQExyu+hPZdrbk+VCGkFL6TFJWugoarF1Zkc7ArE1uY8QEoQV4bHmf1eIo6kcSCjZWf/3Ix7pWhfKzaBTHMi+Zyn0jnNpmY3crskoavBmszz+zVWSmoNFmb3TCTpQPZ2dgGEdKWMdOESpJNakwxOE23anxdX2y30SbQHFkluY76asf67pQrY7YEnCE6QScAN7+QoVLxa1f+E2GxLl/R6el73GvA620Tx4UI9+iWMI/eTJ/IZ6BU82Y8bdx9UHg/8Z54Fu59T7IVzt9X+6nQ0OCOUqS0/ksEw3Nai8BkdPlE7usFGKwcBEYqoE++ZO0wDA5wr4OHUNDkxoc+7Eisq+qsRAWPsC6FcTtMtXHaeKnjb7liOqr13j+ND+tVlq4zQ0gK/963LYfV6rAiYcHP9djSAAHBD2FENpTjIOuV+CqhZpaylwE3JgW0U778kTBGdQ/IUjT+O/qJip/l/QrbjBY4hRrsg64ObV+ZBtXuH8xTgQOIuk4NwuBKhtis6Pi6pNKr+NBjN4nBpUfeMCRocqLPSJliHWmoMDWfhGRrxeibzrO0VqkndNH86yWe/c2VIepXlmcdG0DXgRplHRe5Q1up0h7BGV7zWUnbJ7EPlGHwR3jsUKyG7PTTboVNmK061Af/yuHTCEwwFPCKshX3wKNEjBjh0vzqHY2qe
 RSDc/Gp1
 HA8Ss6cF6MdVNduhCl2fyOVjz/miXlMMaby9sPxHv3rLURL2f2g/QKjcXNv7WL/bv04yG+nN/qjyLjjJuNX4IYbNwxBQIDg1lx21XzJZL/aOlSjc5LuB4zJNVHXCoQ2GdKOzT+O2dES6mzAPMC7Xsi8cK6u5hceS7GhfVbkITsE/+47gtUn9/8KXyL6sseFJ+6MZQRRikotFdwRGIRyUzfnf5uhGMBDarK5IVKnNl35Mr+LDRU1MKJt6Xk8JIesza1b1cxBZCeJbbA0ti9j0VYrU13A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the remaining __zone_stat_mod_folio() call with
zone_stat_mod_folio(), and remove the dead inline
__zone_stat_* wrappers definitions from include/linux/vmstat.h.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 include/linux/vmstat.h | 18 ------------------
 mm/mlock.c             |  2 +-
 mm/page-writeback.c    |  2 +-
 3 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 54da7d820f78..009b80e3c048 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -404,24 +404,6 @@ static inline void drain_zonestat(struct zone *zone,
 			struct per_cpu_zonestat *pzstats) { }
 #endif		/* CONFIG_SMP */
 
-static inline void __zone_stat_mod_folio(struct folio *folio,
-		enum zone_stat_item item, long nr)
-{
-	__mod_zone_page_state(folio_zone(folio), item, nr);
-}
-
-static inline void __zone_stat_add_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	__mod_zone_page_state(folio_zone(folio), item, folio_nr_pages(folio));
-}
-
-static inline void __zone_stat_sub_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	__mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void zone_stat_mod_folio(struct folio *folio,
 		enum zone_stat_item item, long nr)
 {
diff --git a/mm/mlock.c b/mm/mlock.c
index 0cafcb2f4e8d..654487063fbb 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -141,7 +141,7 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
 
 munlock:
 	if (folio_test_clear_mlocked(folio)) {
-		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
 		if (isolated || !folio_test_unevictable(folio))
 			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
 		else
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ed3301753e89..dc15d775761e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2626,7 +2626,7 @@ static void folio_account_dirtied(struct folio *folio,
 		wb = inode_to_wb(inode);
 
 		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
-		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
+		zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 		node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
 		wb_stat_mod(wb, WB_DIRTIED, nr);
-- 
2.43.0


