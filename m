Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F5CCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 04:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869BA6B0096; Thu, 18 Jun 2026 00:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841796B0098; Thu, 18 Jun 2026 00:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757986B0099; Thu, 18 Jun 2026 00:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 461596B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:49:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A80E4166733
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:58 +0000 (UTC)
X-FDA: 84891806076.30.48EB16A
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0FB8A0007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jg3MzZRE;
	spf=pass (imf25.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781758196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyhAjkY+9Qf6fDn3TYWufq6sYQTYoNNz/JFLMgng6yM=;
	b=4GTpOUHh/lstKwjakVpXWMuH+aeID0wMHK3PnQRDEpow2SGG/ixp4qqL5XeAMpp4Xg6R+/
	JRhclAQZDTE8bh7scK/xkV6SLJHuNhbxDFZzcfLOWm3dAT9J6kUsIrOxXqOJuhAe4ztju2
	7tjcDybS4iNTyZERvS0wptxBDFF/sBE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781758196;
	b=3dsSOe4+nT3INjGZ6ombfiJ4ZY/mADlMR5QlMTvC1y8POAxy7hu7pHVAuPdY4h4kLR3gHG
	7/+xCLDLADpGjdBN5shhjyKBh0yVmgBzHyoB413Eb4S/ZXvTze49RgktpjBbT27+5Bkimz
	Dj2TqNJYemqgCbl8e9HtZmEWlVSn2+c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jg3MzZRE;
	spf=pass (imf25.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8453b56ab74so193375b3a.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781758196; x=1782362996; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lyhAjkY+9Qf6fDn3TYWufq6sYQTYoNNz/JFLMgng6yM=;
        b=Jg3MzZREagnsZjU/xt5nYegz/gOyR3foZKX+FGB0JjfXV/T2vN6VjCLGQdFz+EU2w+
         EO0zz5aoZNB00Yp3o62Us75iZ1yAr41X23EoidF+ns4mvXJgM29iqFmJ41me3lb5nu2K
         W4PmXpdBpSq4TjKEsw5gLaG5ENa6HQPh6KQYzPbZ0evl6jIj3FnaZCwd6SalBMr24UsH
         C+By5XS46Ezmq0gNMyxOG7KSVykdZrZb38MdzhO+aXaEmQlk19o5FZ1pZmGOB7i62afS
         VL82dK/nofL0cj7nuNJCO0MJCsv5kpW/oyLfvlRcF8oc+dEAsOCHEWaxOsY0YAFlTIaC
         ny3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781758196; x=1782362996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lyhAjkY+9Qf6fDn3TYWufq6sYQTYoNNz/JFLMgng6yM=;
        b=OwVIU6r7fUd4tcx+sGvsJisXMBwTZnrGA3rKvsHfA5cYbzOdcq3VgYveW/MW+g3Uv+
         TwNKLahD435jEzoKI++5Fxv2pZCTs3uCMMI+LvDjYW/dTq/XY+AmXHCDE3/ci4DbaCGM
         BlNYwOII4KoMszMW/YUzWwon6GdWrfIKqdrbCiz6vDRSJNNwOu4Y9uwqx2BE69BSdZW9
         oja646AU4/6NpDmA7I4VUvdPbWrWV6LtPsNLzb7iTF5d+f6tWl47nNU+0vb0zfkKkhM8
         6RVozWFFTy3l0TrHNzZLCjQxYq7KZ4zYull/VA1/b4wzS/WeRILjodOu+/Nzq1LHg2hc
         lARg==
X-Gm-Message-State: AOJu0YzL+yoIcFJ2RpbFnAURoPrJVTpLergvGfxEdDQjpCmJyZwyJwO4
	Iu/OInBCuhxjx2feMP+R5xHoVHMhvI+4iLAHCWiJ+0v7yzc2SX7ETv+F
X-Gm-Gg: Acq92OGuvh5q1VpCyyfcodMU+c4DvxfwilbUsFsFWBt9IoorpH7KzfVZ+cmo0bLCHR4
	uv6BhpvmGD098c6MxOAUoTnAQIf9NYEWH5ubqvouVilBDmfQKoOlu9cHO+aUnFpVa5BdoMPQmzy
	6ovFpSrEbR42QJlZu0DkniztVhOUdsqJ00t27PEGwdjUOFohWTlMKG9GkUkUyBZaACxatJHFl9n
	KeR70sFPwhBhBqMjgRgbWiobrZesMKKmOEHaNENp4h8FhnBW6e397KqAebOCXaCQAHYw/1PdWji
	CdTZMTToj5nRR/G0ALjlH1/CdNVtKZSp7wgwhElU8xwPLl2T8GqHlbc8RdwjRRyr3f/uU3Mq+dj
	fbPYtltV6I0N4s45nowDGYw11cknORLYAWgtoBKk/8+R0RMNH2+4D2FJ6pNHzVPr1RROMajrrlv
	yeh6jN0mVz4w4/3unjpCSyB2xLfjeJA/KD8MOkXrT3
X-Received: by 2002:a05:6a00:2192:b0:845:3ac5:1b8a with SMTP id d2e1a72fcca58-8453ac51e2cmr2039626b3a.0.1781758195707;
        Wed, 17 Jun 2026 21:49:55 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b020b53sm17214781b3a.47.2026.06.17.21.49.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Jun 2026 21:49:55 -0700 (PDT)
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
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v4 4/5] mm/zswap: Add per-memcg stat for proactive writeback
Date: Thu, 18 Jun 2026 12:48:56 +0800
Message-Id: <20260618044857.69439-5-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260618044857.69439-1-jiahao.kernel@gmail.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D0FB8A0007
X-Rspam-User: 
X-Stat-Signature: 8fezkrqifoyag7gt8u51omfynja1z1dc
X-Rspamd-Server: rspam08
X-HE-Tag: 1781758196-261606
X-HE-Meta: U2FsdGVkX18fsZvRF90k+bC7miaPIAK4O5wP5CCdJNLuZ0d9x31m3JhERKBYV6/qqYQ8qYMoz9gW+FEXJZR9+3TQTpQAk79HtrwXekQFjKHhG7Tzy/bJ/F7aHnX9Bp5hORiw+P3xKZV2EQT++eJqxwnG3cr4kIiZ2zVF1MghRSn0ynLOuhEnI2K4FESfbbUldvaaUSg1r87O1o/MlprIw0p00BxARkd2Z0gEeYuyVIXdVhmV9Zs99aBj9CKIV2I5AZS5cYjhSSKAhRlSzMv7HBuXXouHmEJIs5QQcR0Pfhfq5xnjpKhRmePYddLrFpFmt5Wv4R1uuTHF51uEKT6rmb0jEvcW88DybdKeOATocxSBia6KoqC7nbbv9KnxvJtkU6GzMpcohmG69a5vQY2IGZmFrVSIcHpQ5sLQ2RTFJNk661OwjmfkIVjaErAt0f15yB2PBtM8WSLEjEWGxXjcMzK619p31joPc+yNir9wUwcgiu8qe2rlQ/2X0osiWlFihw3Hnz2IV9mIkga1lyoor0Cc0TizJrdwJegPtZZ5p12x6lz2LKd2+6dodabBgzkNADv1mTLVNpzc4vLNKe0aiXYp3p1ftlXKq2eibtnJM71fpKq67GOAkzlk76gsnnveJVbKZ4VvqQ3I++xrhxRqoMu0tw+CedgFaq1kllOc95E9FTtk6GcFQ64GukQu/uJiYp6tQHGWcBkufy/OblnO9aDeTcjoBAm7iohQPS+k8VkxvbrotRt34SsFjSMuwSq0GDQfaQbOFcB7Dl90O70yg4rM8WBkKtqGjanZFQE0vQbivgUGcyR7aKDKcibHld/acD+PV90OE/0djuRf5D5Ed47nmpYVw7lxv0AYxmWTLuRzhohe0WJPTnkYG93hP2Drcpbcy8LiSOkJRxZiHKowKYKhh0nkT0TeD4hRC1TsgDcA78lXCA76pucjNRha354ZxJN1X3jTDpP8+DegXw/
 EZtlAM3v
 A+sT8RQPrkuXL3G/UlQvkguxSwIKGLQOf6SWIpd7cRRGKWO3pM/GU2sWPKLJm4m4E0XJRuurl3jTvgQjkXV+NwWURlYYBNWoq3Wb0GxqL/O5xLra/eQuWrjEBg7mOGq1NPL1d5Q2P+GcNp5mMV5HK/YY+CJrLi/3QRIrg8cOKGiPfbPbHe00p41psPBbFczmLhUSnYAIHUbNoag5Qrodx1GuAEIH+Dihh/A/NvF/AXBfHebU7GDt/+6vVeUi9IYn9HzGhLDZWlCKu7PAfP7+54U5HWwT5qfzRJzyLrooQg4JhuEjq6wmWIVbdZVNSGcqQSxOJmrYhx1BdcpemaZedCqOOp9mrGUd1MUZVUTDfmBOQRT4VLg1utH7YRgjxemXRyqtWB4SfNi1dRPie23OXpQsOwM0MwlbDyp34a7Rg7QZliQxbiE0+2eJLld1121HzUX7oQ7rNW4Tb9CZ4Bmb+iqzwEOt7F+3ReKbp2kaX/GOWWBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Add a new stat zswpwb_proactive_b to memory.stat. This counter is
incremented by entry->length during proactive writebacks triggered
via the zswap_writeback_only key in memory.reclaim. It tracks the
compressed size (in bytes) of pages proactively written back from
zswap to swap, allowing users to better monitor and tune the
proactive writeback mechanism.

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 ++++
 include/linux/memcontrol.h              |  1 +
 mm/memcontrol.c                         |  3 +++
 mm/zswap.c                              | 23 ++++++++++++++++++-----
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index e52d97e8e9c6..c164bb415002 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1748,6 +1748,10 @@ The following nested keys are defined.
 	  zswpwb
 		Number of pages written from zswap to swap.
 
+	  zswpwb_proactive_b
+		Bytes of compressed data proactively written back from
+		zswap to swap via memory.reclaim zswap_writeback_only key.
+
 	  zswap_incomp
 		Number of incompressible pages currently stored in zswap
 		without compression. These pages could not be compressed to
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..56580b264dc4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -40,6 +40,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_ZSWPWB_PROACTIVE_B,
 	MEMCG_NR_STAT,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..5ffb5095f0ee 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -433,6 +433,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_ZSWPWB_PROACTIVE_B,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1558,6 +1559,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "zswap",			MEMCG_ZSWAP_B			},
 	{ "zswapped",			MEMCG_ZSWAPPED			},
 	{ "zswap_incomp",		MEMCG_ZSWAP_INCOMP		},
+	{ "zswpwb_proactive_b",		MEMCG_ZSWPWB_PROACTIVE_B	},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -1614,6 +1616,7 @@ static int memcg_page_state_unit(int item)
 	switch (item) {
 	case MEMCG_PERCPU_B:
 	case MEMCG_ZSWAP_B:
+	case MEMCG_ZSWPWB_PROACTIVE_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
 		return 1;
diff --git a/mm/zswap.c b/mm/zswap.c
index 28200552dde3..d78bacf80209 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -163,6 +163,7 @@ struct zswap_pool {
 struct zswap_shrink_walk_arg {
 	unsigned long bytes_written;
 	bool encountered_page_in_swapcache;
+	bool proactive;
 };
 
 /* Global LRU lists shared by all zswap pools. */
@@ -990,7 +991,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
  * freed.
  */
 static int zswap_writeback_entry(struct zswap_entry *entry,
-				 swp_entry_t swpentry)
+				 swp_entry_t swpentry,
+				 bool proactive)
 {
 	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
@@ -1045,6 +1047,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (entry->objcg)
 		count_objcg_events(entry->objcg, ZSWPWB, 1);
 
+	if (proactive && entry->objcg) {
+		struct mem_cgroup *memcg;
+
+		rcu_read_lock();
+		memcg = obj_cgroup_memcg(entry->objcg);
+		mod_memcg_state(memcg, MEMCG_ZSWPWB_PROACTIVE_B, entry->length);
+		rcu_read_unlock();
+	}
+
 	zswap_entry_free(entry);
 
 	/* folio is up to date */
@@ -1155,7 +1166,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(entry, swpentry, walk_arg->proactive);
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
@@ -1184,6 +1195,7 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	struct zswap_shrink_walk_arg walk_arg = {
 		.bytes_written = 0,
 		.encountered_page_in_swapcache = false,
+		.proactive = false,
 	};
 	unsigned long shrink_ret;
 
@@ -1305,11 +1317,12 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  */
 static long shrink_memcg(struct mem_cgroup *memcg,
-			 unsigned long nr_to_writeback)
+			 unsigned long nr_to_writeback, bool proactive)
 {
 	struct zswap_shrink_walk_arg walk_arg = {
 		.bytes_written = 0,
 		.encountered_page_in_swapcache = false,
+		.proactive = proactive,
 	};
 	u64 bytes_to_writeback = nr_to_writeback << PAGE_SHIFT;
 	bool memcg_list_is_empty = true;
@@ -1492,7 +1505,7 @@ static int zswap_try_to_writeback(struct mem_cgroup *memcg,
 		}
 
 		batch_size = min(upper_pages - lower_pages, NR_ZSWAP_WB_BATCH);
-		shrunk = shrink_memcg(iter_memcg, batch_size);
+		shrunk = shrink_memcg(iter_memcg, batch_size, proactive);
 		/* drop the extra reference */
 		mem_cgroup_put(iter_memcg);
 
@@ -1642,7 +1655,7 @@ bool zswap_store(struct folio *folio)
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (shrink_memcg(memcg, 1) <= 0) {
+		if (shrink_memcg(memcg, 1, false) <= 0) {
 			mem_cgroup_put(memcg);
 			goto put_objcg;
 		}
-- 
2.34.1


