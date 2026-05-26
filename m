Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3773ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F756B00C9; Tue, 26 May 2026 07:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26476B00CA; Tue, 26 May 2026 07:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963B26B00CB; Tue, 26 May 2026 07:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88B0F6B00C9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:46:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DDAE1203CA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:47 +0000 (UTC)
X-FDA: 84809394054.07.34F1C6B
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 481D91A000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFfhMTBc;
	spf=pass (imf19.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyxgSUePtHx6I/zD41D6CDDvd5fSjKcBNMIc54wEtIs=;
	b=mrNG5LvLvUlhrMvWQbnNIRdeF7v8/adEQAD1zc+GMn93IsLDkMbynk5L2hZHLbEfeW8Io6
	EVzVak2An1V9IwO2Ok8yWKP9uL3M4au7CbVzItEteSEW95kBN4wmSwFqP0U3I07Uqpuwm2
	tSO9yBWy0CvHne/q3QvuBDCk+2xMDkk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFfhMTBc;
	spf=pass (imf19.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796005; a=rsa-sha256;
	cv=none;
	b=DYzEPjY/Xqto3P29sF4PlN6QPIhwwiFHNTEVfmg/3OqFhGPfr1eHktiVpU0CyzLviWzeFE
	RuA7mbHJgQk4uzLTytb0p7JjZO0FQrUr6V4/8ESe3ioQH8AobG1Rniv0d1rUYkq1kXj2hy
	+8IFKWPDL2zvGIL904EDevFqo7IWG9M=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3697c35eab7so6309800a91.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779796004; x=1780400804; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LyxgSUePtHx6I/zD41D6CDDvd5fSjKcBNMIc54wEtIs=;
        b=IFfhMTBcPJo/WMJDGHWNzcYji8KxdBQ1Icr7mH2zsvKwTrKtsIG0XH61d5eqs14ZYX
         gq22UB4lQwnYJAEvdx7SEPJIFa6iYyurYZ2hSKXwnSBsdbnK3ptr+NNHMnGlvHhUldmt
         erR9a5fMex5fqE86bVkF0eycRQwAOXu69okvGFhwaXY2PaxXrDpYBCFkwhhv+dS+X0HE
         NP2rDU27v2tUmeWGzx5NMj3TrBJsQuCMjM1XkchUdT9LTghOdsu0sLHg9l5H3/wWevPv
         HPNGTRVHYEq/0ukKx90uau8M24U/4EV2Z1MCObLJzbOL7qLaWH3gp4y4sE77owHWw3Y3
         /J6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779796004; x=1780400804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LyxgSUePtHx6I/zD41D6CDDvd5fSjKcBNMIc54wEtIs=;
        b=DUWzE5EY0/EnqF/qmpElvBlD0ZJNQTCUK0a2FhzRuXfVqConZQcij+GP5nD2OHBdzE
         4P3K7GI7wDh4r/qwj+/EL2wPyM/VvdLQ8LIsY1dFULJq5D4XBr7uHxh/OQoWM0kQwxYe
         WKrCF0C98EdOxOxp5c9BkZftdvjF9aMAyjnMlkYh618cFQfjYrGR2i3bmIkXMEj12e2p
         aag78T/wDw+oY9edVE4ujUrj6xgRFBudbtQk7tMAhNHi9gjH7VXJHo80XPqRH2oRDFSK
         sjMrygpz78FgfkX5xxQDUPcMUZXq4luxmFrnYq8HRl5xlZm/KC/n9zE6IEqG/rgIoKuZ
         Na+Q==
X-Forwarded-Encrypted: i=1; AFNElJ+wW6W5datej1aeHb1lc/Z99XLeluehASLIHDcH5WfYEnBr0RBS/FQ+UaRa80En0uhyOwHCNice0g==@kvack.org
X-Gm-Message-State: AOJu0Yx52JZatx4c6m4xSQA4BjCHtJQMpYX9uim2FNiLwjDQVuekVwZH
	MyWGUU/Jsp02MQNorZi88vqKpEmRX+C3hpV/ahm1ROijIExe/Q2jlNG0
X-Gm-Gg: Acq92OHYCWE/x2ppNyW3jqpgX0b+Wx6PxIHWZr9ZNGQZgmJDvBC/Se/a63BCL43GE8B
	lltW+N3BmNyHCB26kXcAxAU+jOMML7VXkGTxZuVwFYQcL/XKnLmLM6njfo9E6TvWF1wbFzbXhNm
	HlQRgb3vG5Oz23kOHg5ePfdj/THJe/8q7Cu5sw8zImKCOYA48RnFHls6RODbElaQKffnnRgF1go
	duyiW0u4yDM1IdmgPdVlm9OKUuqFDBscj3k3RAThNP5ldSHuFOPrnPeke1Bctg0RLAonaSbUSMP
	5uV9xHyov4aRqzhO7Lyf9bRVWoJlJdfJLkvJvLwp720US9KOI+0ESvKnGMb9WsxNAn/rXcO1Vmu
	5WCk7oNMhrknML18aHfUwppG5BXHBetpfGA2Z8zR09lp5X74O8Qmw2iB31C1TKbOlQ3RH8i5ZSy
	a0pIwmZAxmHNImwQPBEjWxHcfS5JcQe4JlCw0T05lTIn1+GvUcuzM=
X-Received: by 2002:a17:90b:350a:b0:36a:fcf5:64d2 with SMTP id 98e67ed59e1d1-36afcf566b1mr3550820a91.16.1779796003831;
        Tue, 26 May 2026 04:46:43 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852028fe99sm10304341a12.4.2026.05.26.04.46.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 May 2026 04:46:43 -0700 (PDT)
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
Subject: [PATCH v3 3/4] mm/zswap: Add per-memcg stat for proactive writeback
Date: Tue, 26 May 2026 19:46:00 +0800
Message-Id: <20260526114601.67041-4-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260526114601.67041-1-jiahao.kernel@gmail.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pwwbx91phy3sicsaawcypdaarbofnfpf
X-Rspamd-Queue-Id: 481D91A000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779796005-349614
X-HE-Meta: U2FsdGVkX1+nO3lRcdFhy2CBDIowkBa9ue5yBBASq4kD/QZ4o9j9ZEc/Lv0N91YVwHW+89pD4vpdw5iX/BFDp4S+pNhTIE/ejjyWr6unsxmjCtdUR28KVCzY2t4ro2TNzRC3ONDkKuweBvTy9AJLVtgWkHO3jPprsJ1cIGDEFD4evunJyV+Yr1tIKh6ZwtfD12UiiLDkfpD3dTb0VeDYYnTUS7/nuIHmvzSzqvKUe2wNQwuPAEUGgTAsrFgnXWbwJxUCOU+2IQF8cGJkzSmkrZrXYhUO/eG1FmVh8iapIoTAlkLYbhVt6JXqftKIhmK/Z97fGBjwAxpPQUKYp9fCWQYHQict33XT1fqfwTleSpA44JRcZ5FZmvppD810bc75uPaQ9LWcQ6CB3nbWB+W3lSEBEerzvANFOIxeGYvQeGIEbAu0Zb2bg9HdJLdOA3mVoSLP8GJnltEWgXtNvdMZKysIB5EpVxF58wkHvvagJahX3qIMAVhBNhogJDO5cAWWjlXVMd+3z210CmAQ/59zCrM2bHRKrIpaOA0/iNycLvFvUA4jDOIG1O1p8a7deBLU257dTBtJYRHE7rVlYg4c9JyhHozftzqrnWrQe0hxoAesYUKLHIKHo8SrLwyV4dzJQKJsOch9zhrM3ZzmnE4cfeGvn/kFZV32ApbeElcHcToDoaaGwb+D4ZvSGMOosDp76xxaCKpV+jldEDiyDY1At5BkjOkgR0wDqz5OYBD4jabg9HHWCQjOlB2X7ua9Bx6u1gT0YDUT0SQdCtcKXAlrzrZdR1uNCezWIa9ggcPXYScDYjWpGrUa+jqjxukvGjeqhCE4J/pN+9NaFBfhGGK/wyvobXlvCMKu7T5FowFbnxxwXDUZm3dyRINEqJs9EDdnw87ujErgsRGFtm8IhJQfZ2ko5vgHsbnBrDudjKmkEQ3t/ejvAsguA6wQ3gPExB+oh/VY2v1ERGvLJwN1aQw
 w5Ny74TW
 vY1U7Psuft8wseMN1igczNwea4Xpe7sNV2le+u1auZyQuCszIArqZl71ZiV5AXg8hTeECZ4kD/bZ9ElkwoHcYjd4OCBukWB/Eu5wu7wSCgerBC7Zmv3dEBpdbZurziUtdvQXTfnllAHtQMa5l5f5patZctyUjkWALQ6lveSEKBeSrwPb1adDL5tAZ2SA+DIxb+L7iWEnXvrfkU++B2cDbFx3MdfHIa5XjET0egpYKa2+GFoDVjdYRdFiq+b8D7EO4Mibl8VnjVyP3gpwN7JQNvJ9NJbFMeYVPJXN8SPKG6o21DCfH+xqLrgRdP06ME4E9cL6Fe0NhobLxMh1PWCM6kVLRGT7RUA41fZFi5N5cWOKJa7FnytG/A/fYTsTqXFUkxkWFJFlHpDaD2wpKWhGpSHfSwwF+vhERCvmPtV9RVvjGu7WTeiUqByI13efTeyS1X4oCIFjXYX68UMWmIFsoqMhRICvpwbHa3TKF3WZE8zuRZ5L3Md0HAy5B1Tl1wPXBHer6kJExtXcxTvy54i1YaqWXyAtt26/z/Zhr5JeqvD/Nl2roWqbpru4ds3YCorovbtab
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
index e205e5de193d..7648b3fd940e 100644
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
index 7bcbf788f634..b45d094f532a 100644
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
@@ -1097,6 +1103,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
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
@@ -1146,7 +1158,8 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	struct zswap_shrink_walk_arg *walk_arg = arg;
+	bool proactive_wb = walk_arg && walk_arg->proactive;
 	swp_entry_t swpentry;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
@@ -1201,7 +1214,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(entry, swpentry, proactive_wb);
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
@@ -1212,9 +1225,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
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
@@ -1226,8 +1239,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
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
@@ -1236,9 +1252,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&walk_arg);
 
-	if (encountered_page_in_swapcache)
+	if (walk_arg.encountered_page_in_swapcache)
 		return SHRINK_STOP;
 
 	return shrink_ret ? shrink_ret : SHRINK_STOP;
@@ -1709,7 +1725,10 @@ static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
 		return -ENOENT;
 
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
-		bool encountered_page_in_swapcache = false;
+		struct zswap_shrink_walk_arg walk_arg = {
+			.proactive = true,
+			.encountered_page_in_swapcache = false,
+		};
 		unsigned long nr_to_scan, nr_scanned = 0;
 
 		/*
@@ -1743,12 +1762,12 @@ static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
 
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


