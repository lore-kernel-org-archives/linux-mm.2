Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F94CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69046B0098; Mon, 25 May 2026 08:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B405E6B0099; Mon, 25 May 2026 08:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56C76B009B; Mon, 25 May 2026 08:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96F786B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:23:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63D2E1C00DA
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:23:21 +0000 (UTC)
X-FDA: 84805857402.26.BF7434C
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7CCE318000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:23:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n9FoH9Ti;
	spf=pass (imf06.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779711799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCgp1DVd9xo2joxajci3qyEuXkTq0+UzE9J3t6+D+hI=;
	b=XOEHirnv4vpb9R0d/dzw6NFJSA5OdSmw8GT0jZ8qSck6+xlPPDdKLAzkB5Ft9VIeY5LymF
	gx/LcXBuYDPg649VfjPp4ikL7bqJq42Y254Cik8en+3qaQiH7PCjqJdKcnuM7umaJT6nZa
	X1iAjnywUJznun9wG5uwDasZmejrnf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779711799; a=rsa-sha256;
	cv=none;
	b=nCdTFFBg4sPgCh2mMytBLRofjsH6XCezKTgVqZE2cthfO5m71jn2zRkh/TZ8WPygGxV2er
	ZIEWXoSBcYDql5uCLQ4I3ktaMm9rwXKez+hKUoStHbjbgsmnrh4C8jkWbzQsv77mnQwl7J
	RSE4jr9gHOLBSOa3CSA1lOpduR4AUvg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n9FoH9Ti;
	spf=pass (imf06.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36608b2f2dcso6283336a91.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 05:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779711798; x=1780316598; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCgp1DVd9xo2joxajci3qyEuXkTq0+UzE9J3t6+D+hI=;
        b=n9FoH9TiUJiPVWkKynSlJN2EcLgXL6hyeB8HD66jmuvDwYlVTtQBop9tRw2cyi2Pyl
         FlUGdN4yaUUWAm1TtZtGVRF/0nM0glXTjbnzhbKhg5Im80pwQ2oUcwWUCvYrR7Mvt4W/
         rym70kGwGOz7zz3lMAYRw+7Y04XpTqhJh+ZuI7Yoj0Y55vt531J/icqNC3ygFFe/851o
         Eog6w3Pppz2GBxA6ZA/vm7eeZ4vZslAIGejW2a0nB4Qj5isWPrHfbm2UUQeRGSa5iARh
         hBcImTyhUl609imnOK+jy5dI6QD7zbGRKTyXaPNYxecH7M2etGSmBdQB80AcHuSXg0WR
         2NXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779711798; x=1780316598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dCgp1DVd9xo2joxajci3qyEuXkTq0+UzE9J3t6+D+hI=;
        b=LJ3gTTpRTa0DFpUBettpmi0EaChN0uZY27VMjFEgWWaTZDiXL0NU2EEaqijzLM39UF
         sNH7thjQuuzphzUdwPRQ0J6Iztv6KnGSbUbwVv10aoafInq3WEDoeLQzWZ31JhzMQ8x9
         olkisdglgpVBZLtV/a+Oi8crfejvWTyT7rwjRSEUHbwkNjl+BRi6IbJEzGMbplE4Ipsq
         AzcpWw6WJlvaCBboSbf7KjDpCgUHm2j0Z8LV1palo+gnNcurl0A1naI+tW9AdRqUPbr6
         UiFutb5cM0vR1M3jzNuAk83NOUcmgWGUMvMtC0r9vnXImN3kjwO69F9Iq1uZkAQVucRO
         0ofA==
X-Forwarded-Encrypted: i=1; AFNElJ/EzDaE4wrIn6XeN+XSVkGoE4cnMcmUg515fvUO+2a0p2rTgItTKQgYmpTptuuhDCc3dcvEVUSHHw==@kvack.org
X-Gm-Message-State: AOJu0YyTiCt6YrJ0LeP0vlM3fPQvajd8jFmMg/afsVCIKHPBV1hYMMsF
	HpoWTGGtFnwB9DnUP6fYWU70BHBNW4qJidRGz1flNMZzDx5U7hi5XUnp
X-Gm-Gg: Acq92OHJv5vgHza+KiKsQK7Cwz6H7WSh65fq87J6s3on/GY4voQXX7eIjpAO45M1Vpw
	vn8wgF5kQIQRbuepYKOrpNxxEeQ2p44DnyxyQMBX8xDzTZclmF8tiFoqyVA/7FDOemicGLAPDgp
	+vrHxmk2XnERsCPbsz2AcuP6N0Gww4Ufet5PEhLEjb1Qu73032SxjSRkesrmDuKqXp2ePDPj+L4
	V2+zHUZSuY88hZP3MyCs4mGZ/DvoqLA9dVJF6R3bWXpU6WcBaPU/zVV3qU1v6Bb9Uzb7OqVOJt2
	d4p5EYa4nRI0wmWtC4Se3XBjcnDyyPdsn4MB0PDQTNywCeslu6iG41uHB03BT0dWd19GOuXB1tP
	ny0Erob4TtzIT0S1mZIxq6pZ0eXIy1xaZvbP2Vq0aYCn6kbA1dqpRmg5jJD22xZW3DUsLrksNhP
	JpcWYDJLKC6Za00nmCxtR1lOCo3YAnlwm7X0+3on+4lS/OvLcaJws=
X-Received: by 2002:a17:90a:d885:b0:369:e4d4:79c6 with SMTP id 98e67ed59e1d1-36a6782a785mr13015019a91.20.1779711798253;
        Mon, 25 May 2026 05:23:18 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a72c913a1sm8999131a91.15.2026.05.25.05.23.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 May 2026 05:23:17 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v2 3/4] mm/zswap: Add per-memcg stat for proactive writeback
Date: Mon, 25 May 2026 20:22:41 +0800
Message-Id: <20260525122242.36127-4-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260525122242.36127-1-jiahao.kernel@gmail.com>
References: <20260525122242.36127-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: c6qs46h5mh9xiyfuxqx9twwbwtmopau6
X-Rspamd-Queue-Id: 7CCE318000B
X-Rspam-User: 
X-HE-Tag: 1779711799-986937
X-HE-Meta: U2FsdGVkX18PmpGTYkMaS9qfopvmWAquKzHsft3LuR5+6kc+S+lVp0Xr2yFlRL+zqe2lQxZx2i5EUgJoA8Th0MZP4WyS3E7Y51TehSb+64twUIWapEVhjvMiHDSrDBAN/6nyhCVgN/oxndQJmWV61JoogOguRQDS8kcRvElEthoTe2CyqVOKJ1X+xdCezPxKIQOjJmvctujsV/ywWVwiQshyMCi2tQg3rrJgt0ioXO0FXfQJvM5g6TpNiMCRzV+u5OnUTj89ddJHUtbbuLGiGnbgnGjzp0pQJpyz/D3l8nXYysXKTsE+Jhvh0Y64MhxU4RracpBk7jEvkeQuM0psTI7UStzamw7TyxNPOw/qj8gjRq5wewCITUYoXO17OmgrLfVOVtDX3oGoX/GsZ8XnY5vLAan7mhEg7FG+r4AglYcxiQ2T64pY6yrQVm4JIuH1MpQ5s9txj5UXHCdwyinhQrFp2OnHh1yypFRzqFsgkiblXQkTTB4pPmxzn4cjUcLA9+7DYK20Zi8WKdAqAMNjgqmhb2apxFinwv5r05fB1gJS3FcMHQegrP3VUVA21c/AEDwxmpxLOdfGld+cPR0MaIY8x7XAAFglipb0kXNgoQOwqACoj9NzVSqqGn2akXbvBedwFGTcFFZhkrZsjVHY/K6iBzDqfeWweVQXVGDVtlIHVrUd/HgoDyWeVTM87Kzwc5Rm7jbqyqoX80tjmTGSclF322qMfZh5TkiOyPvRAphGRw+l+AR5sX2zcg/deN2+LeR6nsTZcK5tO5QTgQV6Do7Tbq389wN8qFRRTw/sobyM3tFeoGozoSE401kosFXg+AxjUP3lwjkkm4fMok8ZOycu+jWqmb/3D0wMFNHP1wmvZiA9RHpgJlT3yuuzZCioq4ExvKU5PccB0jz+vb8dtqtT7GXIZsQUO4WqF1Kjlbb2Xc0Fl+RvaU/4KsyCed2JRsxrWR6vEMULHTKBN1+
 DTUKqXQp
 khkrA9mLiQni+nU9HkewID8ZOq7yP2/p+cxHtDIDGLkY2I1DPCJ3ZW/dZmd74xYqqyn5SMh2zAnwTJgA/eKpzATtlGWSiDhaFsAR9r8LuJc98/NdASKaKl8hkjVl95CYrBxPvZAtM+6p7QBCw9h/lpqj/iY4OrohSzy4mgTUhkRSqQAuvRVSmcRMqSk4uBSNfp6C8kcAnKWXJCLCUKDMJJI783CREGTEcLZO4lpzRdUlFCeErlRjJ9iRcnM44lXUn5QXWVjuz/yW5OMzlovN3TmgipKe9lhWn24LHjK5TIqduJCYDJb84+pMaHNw7KU6dpz+LdHyr7/62Ci6bp+5ht5AM4aTSStmb/ylfmijQhKqr+88ESQyC3W1kUqpuS3BSTU8HtssLvvuV6UP9TDe+LqJUYViZra2isJzRKUvSB5rAmf29NYZPZeZO7rXceqSPkH+rxwGhoSIsqCDiZ9lwe7LZAAlcgYiNnGqt/l0PyztqdyG6PEx+n1g9EX0tdxAJnhPZN1KC0qUsuxzpdLDMwxskfz8sRLU8dgAW4eDniEOCNWJrv1eo1vfko7eksQ8Ivjoe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Currently, zswap writeback can be triggered by either the pool limit
being hit or by the proactive writeback mechanism. However, the
existing 'zswpwb' metric in memory.stat and /proc/vmstat counts all
written back pages, making it difficult to distinguish between pages
written back due to the pool limit and those written back proactively.

Add a new statistic 'zswpwb_proactive' to memory.stat and /proc/vmstat.
This counter tracks the number of pages written back due to proactive
writeback. This allows users to better monitor and tune the proactive
writeback mechanism.

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 +++
 include/linux/vm_event_item.h           |  1 +
 mm/memcontrol.c                         |  1 +
 mm/vmstat.c                             |  1 +
 mm/zswap.c                              | 41 ++++++++++++++++++-------
 5 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6564abf0dec5..7d65aef83f7b 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1748,6 +1748,10 @@ The following nested keys are defined.
 	  zswpwb
 		Number of pages written from zswap to swap.
 
+	  zswpwb_proactive
+		Number of pages written from zswap to swap by proactive
+		writeback. This is a subset of zswpwb.
+
 	  zswap_incomp
 		Number of incompressible pages currently stored in zswap
 		without compression. These pages could not be compressed to
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..7a5bee0a20b6 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -138,6 +138,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		ZSWPIN,
 		ZSWPOUT,
 		ZSWPWB,
+		ZSWPWB_PROACTIVE,
 #endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 409c41359dc8..67de71b2a659 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -571,6 +571,7 @@ static const unsigned int memcg_vm_event_stat[] = {
 	ZSWPIN,
 	ZSWPOUT,
 	ZSWPWB,
+	ZSWPWB_PROACTIVE,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..66fd06d1bb01 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1452,6 +1452,7 @@ const char * const vmstat_text[] = {
 	[I(ZSWPIN)]				= "zswpin",
 	[I(ZSWPOUT)]				= "zswpout",
 	[I(ZSWPWB)]				= "zswpwb",
+	[I(ZSWPWB_PROACTIVE)]			= "zswpwb_proactive",
 #endif
 #ifdef CONFIG_X86
 	[I(DIRECT_MAP_LEVEL2_SPLIT)]		= "direct_map_level2_splits",
diff --git a/mm/zswap.c b/mm/zswap.c
index 947507b9a185..78190631e2c4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -160,6 +160,11 @@ struct zswap_pool {
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+struct zswap_shrink_walk_arg {
+	bool proactive;
+	bool encountered_page_in_swapcache;
+};
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -1042,7 +1047,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
  * freed.
  */
 static int zswap_writeback_entry(struct zswap_entry *entry,
-				 swp_entry_t swpentry)
+				 swp_entry_t swpentry,
+				 bool proactive)
 {
 	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
@@ -1102,6 +1108,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (entry->objcg)
 		count_objcg_events(entry->objcg, ZSWPWB, 1);
 
+	if (proactive) {
+		count_vm_event(ZSWPWB_PROACTIVE);
+		if (entry->objcg)
+			count_objcg_events(entry->objcg, ZSWPWB_PROACTIVE, 1);
+	}
+
 	zswap_entry_free(entry);
 
 	/* folio is up to date */
@@ -1151,7 +1163,8 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	struct zswap_shrink_walk_arg *walk_arg = arg;
+	bool proactive_wb = walk_arg && walk_arg->proactive;
 	swp_entry_t swpentry;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
@@ -1206,7 +1219,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(entry, swpentry, proactive_wb);
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
@@ -1217,9 +1230,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+		if (writeback_result == -EEXIST && walk_arg) {
 			ret = LRU_STOP;
-			*encountered_page_in_swapcache = true;
+			walk_arg->encountered_page_in_swapcache = true;
 		}
 	} else {
 		zswap_written_back_pages++;
@@ -1231,8 +1244,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
+	struct zswap_shrink_walk_arg walk_arg = {
+		.proactive = false,
+		.encountered_page_in_swapcache = false,
+	};
 	unsigned long shrink_ret;
-	bool encountered_page_in_swapcache = false;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1241,9 +1257,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&walk_arg);
 
-	if (encountered_page_in_swapcache)
+	if (walk_arg.encountered_page_in_swapcache)
 		return SHRINK_STOP;
 
 	return shrink_ret ? shrink_ret : SHRINK_STOP;
@@ -1714,7 +1730,10 @@ static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
 		return -ENOENT;
 
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
-		bool encountered_page_in_swapcache = false;
+		struct zswap_shrink_walk_arg walk_arg = {
+			.proactive = true,
+			.encountered_page_in_swapcache = false,
+		};
 		unsigned long nr_to_scan, nr_scanned = 0;
 
 		/*
@@ -1748,12 +1767,12 @@ static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
 
 			nr_written += list_lru_walk_one(&zswap_list_lru, nid, memcg,
 							&shrink_memcg_cb,
-							&encountered_page_in_swapcache,
+							&walk_arg,
 							&nr_to_walk);
 
 			if (nr_written >= nr_to_write)
 				return nr_written;
-			if (encountered_page_in_swapcache)
+			if (walk_arg.encountered_page_in_swapcache)
 				break;
 
 			cond_resched();
-- 
2.34.1


