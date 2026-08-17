Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B68C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC566B0630; Mon, 17 Aug 2026 05:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C886B0913; Mon, 17 Aug 2026 05:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6826B0914; Mon, 17 Aug 2026 05:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 326626B0630
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:04:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC12580678
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:03:59 +0000 (UTC)
X-FDA: 85110174198.20.ECB1513
Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	by imf09.hostedemail.com (Postfix) with ESMTP id CD24E140003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:03:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g9+FHIJ1;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786957438;
	b=vCaPLrzAftJDELr7jIVfy+ltJJfrEsA4XHIGeeXSAIxZz3N3R+2dT3G8T6mju63MDHZ2j8
	E4yH3gkiHzmMFPnH5wXZx4HvyjynncVQ4LiXjml3Q/AxPcyIawc77MW239zMTYz4qmgYo0
	MzvZr/i93mnjs8htuzQs7VaNGSvHGl4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g9+FHIJ1;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786957438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhs4h0lxJDv/iNvOsweZCtQu1gyWvcZnjmbioGNLOYg=;
	b=YiEx3jJh2a1Xay4T2auUQDBtoP776kpNyg1nvplkZW2GJdMUSXBfG7QuXpX5fqwpZPzEhZ
	T43NKjqisW2VCCkET5GEZL/IdGA9eYfmqzRRhb8QOPZPdDnJp4PFDzsMBKDJ3yejCyVZmf
	1mVKDnorpgyiHX4viJzgwLfdS2so6Fw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9XCr4YD0T5VE0wZ5iIvs/iiwRl95Fjqj/a+tPYmfT30=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786957436; v=1; x=1787562236;
 b=g9+FHIJ1dZ4urhxpqamidQhLOJ9l5WLuOAy5RT/4RlOIneVU7Gkidp5YUmbOOCR0UL7tXvkh
 XCFm20tevD7Oj6qrTBM4erSiH3f2HrsTv6ew1sfbwSTbO/qS4Klwi8RkTgIVoaHpoOaGyfi1Q8i
 aH6VgLzK8lMAQDHu06TbD2jM=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (221.194.171.228)
	by smtp.migadu.com with ESMTPS id 3c06767a59067357;
	Mon, 17 Aug 2026 09:03:56 +0000
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 1/4] fs: fix missed removal of super_fs_objects_eligible()
Date: Mon, 17 Aug 2026 17:03:25 +0800
Message-ID: <3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1786955972.git.zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD24E140003
X-Stat-Signature: jdykf9go1k6fufj1sdupn9y1fpxi993e
X-HE-Tag: 1786957437-170273
X-HE-Meta: U2FsdGVkX1/ph8X1zIbXtA+zfI3ujLgCHAx0BOjUtbWBlPCFSQVVgG1+wBCjMCimCVpspvh2zp6As8gusLllLOxVrztC00vxBkNKRPs7iwvm22zzUYvo1Q8L491esEJliyuykcxEHl1htQddeksxeHEXVz/Gtw+b14TkW76P767CwWdiX3z5B0cmCejlddAAIR/5Mlhw16UHFT9NxYkvtTrm0E2NeRPiHte/tA/W0wYReEuMV+hQhNSFL5e/7KfVLsLSvuenyyxLXVdsIk9qohyhmch0+O6y0qqugZy3ZIpioKhQaST4NkIWisPT06cHoib/DUU/QmpwoFEiNMGdzrQaiFXWfM6WY8Dh3NA+wdbL7tvQ1hQb18SS4GompCQTayNpzk+eKj5ysLjo1ta+RMS7hiLl7NBRfsePgqnjhm1rCY4T3eNC0aXGvp0l+0+SHvf03+2dYQKgpsx6gq71ThTmaHX5GdA+3pqRarfMkyMVZZswyn/CBijyLdXGt7vV00v170nHc8vfbVDe0QAxgh29rYlOdrXFxfX3obgYGazmxGKuPMeXSlds8LBBIJNF+E7z4yhfll+/MIgJbYaTLdTO0YQXoNjbbT9QAQV3f14vhenoqNAy+W0wtNGXNTyFU3fkTRPmzHglhcsX4RFkKS2/txrMuZ931hY7OkkFDEHALSGE7TjF6LdyamoiCyE4vfaR759bKpp4hO8v4rJ6oYaUrFr9QsvuINoTMf37mvR0YoA77879m9INA0NH7e1ZnThSp//h/8VWqou7vJEC1Jsyx9Z4v9tXIH0i6lm2IzUKxRpAJuotnUHpNhdYod64B4MNzMkr2v4W6pXj5AavxpTuJbmMAAoFG52auAWrHKFz5G7EL63JDQc1JQF8CC5xDE1LpucPtAYkhWodOx8a/fITRMk8ep2Rv8Zf7DRhYwVzCcYEZQb/ppHToXs+IUKE/DAL44DRQmDXOxYHvZh
 0hvxCOCk
 V3B3Vg45kXrplHYmxbG4nihn2jxs5ISwuWE08F058wXX5XrCYgTvmcjeb6DeVXsUHdPFm29Kx+QsdEgDxAz71pZiJjSRI1n2ucEZI+A43H1qPo0KJiKXVCz6U5CTN/FKKoGBv+VB9xL/pmISBbGJK+334fUesEABw2PKOSV51VIUfH4yxnH/+MQ3ap49+CbY2l2xJnURMM2V0KOQzfQ1Io4lhuLp+iLxNNquadAVcYUXyopSYCTApNg9jpaaFa122iMLy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
individual filesystems") forgot to drop the super_fs_objects_eligible(),
just fix it.

Fixes: 0ef8faff490be ("fs: push nr_cached_objects memcg gating into individual filesystems")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/super.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 05e4431730387..3ecce24328f67 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -171,19 +171,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
 	wake_up_var(&sb->s_flags);
 }
 
-/*
- * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
- * operate on filesystem-global state and ignore sc->memcg. Driving them
- * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
- * per-cpu counters and queueing duplicate work: the actual reclaim happens on
- * the global path (kswapd or root direct reclaim) regardless. Restrict them
- * to that path.
- */
-static inline bool super_fs_objects_eligible(struct shrink_control *sc)
-{
-	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
-}
-
 /*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
@@ -213,7 +200,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
+	if (sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -274,8 +261,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects &&
-	    super_fs_objects_eligible(sc))
+	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
-- 
2.54.0


