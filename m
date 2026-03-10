Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86C2FCC9AF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACB16B0095; Mon,  9 Mar 2026 23:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380086B0096; Mon,  9 Mar 2026 23:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6576B0098; Mon,  9 Mar 2026 23:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA786B0095
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:13:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6643B8D7C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:13:11 +0000 (UTC)
X-FDA: 84528682182.10.18D6AB3
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id E09D9180004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:13:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=BhDzZDrg;
	spf=pass (imf16.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773112390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsmX9IqTgTtiIKR5iSvwZiEzuk2SZ9FYiHutnUA3cX0=;
	b=3r3WjH5Ar+h8z9tv5ESRIxxq6HspKASB4HRUb/aMm9X9yhe2Hvq06sPt+j6lb0Cce1BFWG
	09TbsIVKNy4sZ/EQ+JstIoXg8gpsyW53KBLW6d1uQjxJmVd9D1GV9OLlLopovDnBU0wsGJ
	74V65IW4G3LUtnHnC5jA4UaShDFuKHs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=BhDzZDrg;
	spf=pass (imf16.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773112390; a=rsa-sha256;
	cv=none;
	b=6KmPdU5bTq638K2EYdRY69rxS/nGKSMLqkVmKNFT0Gr/N2TSliMzIcEwxAeZcCMzfv81y+
	bFvqULanCYLvRC/vcKD5HPwXy66YKQcm78ZYKCBy7Y2FeUyyg141wA7cc/qsN332QZJZuO
	GqfiQv1hV98CG+0XZrXRAfj3hhDs11Q=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-354a18c48b5so11186871a91.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773112388; x=1773717188; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wsmX9IqTgTtiIKR5iSvwZiEzuk2SZ9FYiHutnUA3cX0=;
        b=BhDzZDrgzIGNYz1gl/LJhFlQ452bx6OFMBkQH5nIcmnyhVHQ/6rfoakxRCnqjrLtu2
         x/z6IpYZsP0siWuud+zQq03m3VjOYChXePIGPCvM6KPqYKfjmrvCVRJZEN9iD4iNuSW4
         nIrLECSEqfuSfBYheB3SSj2VodEUqDtC2HmLQL21XzOAf4fltFiHETnKIf2d25slPiYe
         IRBr4ZLXt6AA/eefvHjBKegzO5Q1Uv5WQdpgBTsJKbKmnFQRfWBcZVbSSAYGjUovhjbB
         d33HipJFzy7ow/VyI9zzhSvDh9svEMsUHHJhGblf1MzxnBg9vTHCJkPP9yTYEoAZo1lR
         67HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112388; x=1773717188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wsmX9IqTgTtiIKR5iSvwZiEzuk2SZ9FYiHutnUA3cX0=;
        b=ONXDzmyxZo7s9INWEwmQlh1HaHmgzjO4j0dFqyZLP6+uVQN+v1EYKjYh/1Rq7WGDqb
         yDOPMjwidxVq1G9xKyDJeIpGKTZYJ4ZwpfXT/xavdOGMekc+3H5viV4lmIjLdpfq4KZe
         Uwbvl5cLVomW3cXjHPzNyVybpfqmjIeOxrfsIO2iv5bYdXjnvh9scoXTgD9XN+VCCV88
         k69O0VzfrLI4qIrXziSSZfiYv1KwLARteTXM3w9Gua6Jko7wX7LSpx5np7Ff4+29h0RM
         UgSHzMcP4lamGyZMdEF8ktmJLYux8XCgFZ6ZYB+qjsJnpWbBrW/G3EpkQJD40H7SU6Vp
         G49w==
X-Forwarded-Encrypted: i=1; AJvYcCW51/ZAcV8hmRsO9Mk90k90LXLQSmKP5rN7ZyBfN9WugpJTigBoXsov0r9QAlDRtutfY2ceQg23CA==@kvack.org
X-Gm-Message-State: AOJu0YzOvwatIw72H3JB97aEDpCNP00b7EIc6bcXSKM1Nj1hCJz52gnM
	/NK5eJbTFd07xTgpTpiSzqJj9KD8deLdC1CWXyNhJqIar6E4eWqaHFp4504h5/rjz2k=
X-Gm-Gg: ATEYQzxI6M2Dtaxti2/qE+d2njFgezkPdZdV4guhxwur2S5NDj10h6iGz8OELyXddx9
	laOcmPpZo3mfOlg3sYYp9Sixie7pW3dMkbv6gTM+KuGLCU79SNLC0RW0c7GLtNKJaAWGYFejKG4
	0746VwgxBKyMzjJeBHB7u7Z6PGTz0WuMyP+Vs7Tv00n/oD4a7ohyPUM3jLDN3kC3+8EI3hUoF3g
	xPEFMIK3vv3b1KHwphRnWghadkk2vgvHoBQQE8YGfNl0RFutcgnAntEX/rKbKTDjDmkNATX0RUK
	61Umt5r3asv9oD35q+rG/WZVdQTjsg6rwxF0Wu0O9M82GAsDL05mPsCWFSGWU7zAf4zPnMZrFUM
	vdZH0YQ8wjY7bcH3WgMct2YvVJFJboN7YsftC1ram5hxHMOTPe0qnxLPvAI6XQhQ/DcTFLfVq3M
	p7eXOer4B89rZUHX9kYMmVwkpzsUoucF3dtBqcCjR3IvjeujzQ
X-Received: by 2002:a17:90b:2604:b0:359:92b5:da70 with SMTP id 98e67ed59e1d1-359be2725f4mr11208013a91.9.1773112388515;
        Mon, 09 Mar 2026 20:13:08 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bcc28f0fsm5169284a91.13.2026.03.09.20.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:13:08 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V2 3/4] mm: shrinker: optimize the allocation of shrinker_info when setting cgroup_memory_nokmem
Date: Tue, 10 Mar 2026 11:12:49 +0800
Message-ID: <20260310031250.289851-4-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310031250.289851-1-haifeng.xu@shopee.com>
References: <20260310031250.289851-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E09D9180004
X-Rspamd-Server: rspam08
X-Stat-Signature: myn6qpxbk8ncpbckstfn9qmzg3cg4qry
X-HE-Tag: 1773112389-557519
X-HE-Meta: U2FsdGVkX1+FQi6OmeAFhrbDPOWAURbm7B5A0Zb1m5QP7BaVcxweUoO6BDkvOURE30IzFV6pNzbD4s9zIQmDrQ3QpK5wIUTIciwD3b+YPgAzpnQLObrPVUK6zI8OSKkhPRKPLLR6N1sk5xN//Ma995jsZJUjyj0tnKQ4PuZqAHQk/w/MV/O+R15PUXrUTGWaCj09ujTlJZ2xpeWK/UV+CjCXdBClTC9F8EFyF246pPV1S/8dF3y/i/GzWYQvbb/Ai6z8dATx+AOoej+gSGF6/bSMg6n2ZTviul0r13eCBSIrXnkEvyS+8G4t2cpW4V6fgLBjC3sVZFvYQ8ivfMwdxSOscfUvi20TwYMTqnDLPYs7QzzxbGDLyHHe2SWshd9uNX7iWU2i2EKzAm/FJCQD3xZZlr9kPfc3iceob029d9lANRyOy/6oa3T6kHIpnGbLAz8b7AvuZDGFFO84EpCDoKaRH/HpmOZIRMNBrgwTGiNHTAR9MNJHAQzz4becE6gE/uAUvx1+PF6NKh9EZJE1Ce+9HpzDLGKbyCEos7ez9gu3Zmb2oVEPrJvPWFptEUW+XXAfh0zDBQajL7d1SbUXncRF4NuKtNd2ffOplrsHRnJv0nUS8G2y2T9qH5s2wCiM+8gJ8g17LLPzohV8qpaxxSTYPAT2ARhbHqvXP4D9FXbj46h66C6DyocolDEIo38yGIZndTC/oxDBfoxk9fF4CWHnsSYYwkfE9a1eC8l/3K6BHUmCzfJM4EdneuWoFi/1xwbKzPlZg4J9pxc3GWaSUlILbpHkoRVSdjYF/5wQLBE7gd7IU34JDsNlhu8NOO5yk7N5xtNib/DZDR9H+hw5ki/1O2dlxs8uY1KV5Z/F1PV0LQdl413R6tcLPZFGg0YIQxE9xPCZ9XbnRz91QhFeWWJ48dbZGDXDPBWw9+VwFk+y262bPqURSvsPDHFyHZIQGsWJI92WQJ4DCgcTxIA
 0CafPCmr
 tY0iDn9ltudtRDEE6i92pdGf5WXA4wsj7hv78vhAYLCRGXnSmljOHt2J9K4/6vvY4B4tKNKkOouBONmEk4JazE9mQZSy1u3JSn6GS1EQmX7OM5fLXHhsorXtYaAZyRub4Vb0b8nMhE6xrpO/ELa46BQh5q9vL1eXjJcEUSSRYmQwbmPfNDlTEHNnLAoECx0oUMpTGLUdE15FAt7K+FGNCJhzD9e4YJ7QZD1IIopqA6InWuf/qLdSD1ikkCyY/r8wn2Pxn4Wr9y28sNJCat+mBOF+jYd9PWrimVf1FFG70p8LSO3rwPwotzFGVaZIZV3Gq6xOg5SZw9gurjPTDR1Nkt5qHdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kmem is disabled, memcg slab shrink only call non-slab shrinkers,
so just allocates shrinker info for non-slab shrinkers to non-root memcgs.

Therefore, if memcg_kmem_online is true, all things keep same as before.
Otherwise, root memcg allocates id from shrinker_idr to identify each
shrinker and non-root memcgs use nonslab_id to identify non-slab shrinkers.
The size of shrinkers_info in non-root memcgs can be very low because the
number of shrinkers marked as SHRINKER_NONSLAB | SHRINKER_MEMCG_AWARE is
few. Also, the time spending in expand_shrinker_info() can reduce a lot.

When setting shrinker bit or updating nr_deferred, use nonslab_id for
non-root memcgs if the shrinker is marked as SHRINKER_NONSLAB.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 include/linux/memcontrol.h |   8 ++-
 include/linux/shrinker.h   |   3 +
 mm/shrinker.c              | 116 +++++++++++++++++++++++++++++++++----
 3 files changed, 114 insertions(+), 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ce7b5101bc02..3edd6211aed2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1804,7 +1804,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 
 static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
 {
-	return shrinker->id;
+	int id = shrinker->id;
+
+	if (!memcg_kmem_online() && (shrinker->flags & SHRINKER_NONSLAB) &&
+	    memcg != root_mem_cgroup)
+		id = shrinker->nonslab_id;
+
+	return id;
 }
 #else
 #define mem_cgroup_sockets_enabled 0
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a..df53008ed8b5 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -107,6 +107,9 @@ struct shrinker {
 #ifdef CONFIG_MEMCG
 	/* ID in shrinker_idr */
 	int id;
+
+	/* ID in shrinker_nonslab_idr */
+	int nonslab_id;
 #endif
 #ifdef CONFIG_SHRINKER_DEBUG
 	int debugfs_id;
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 61dbb6afae52..68ea2d49495c 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -12,6 +12,7 @@ DEFINE_MUTEX(shrinker_mutex);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
+static int shrinker_nonslab_nr_max;
 
 static inline int shrinker_unit_size(int nr_items)
 {
@@ -78,15 +79,25 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int nid, ret = 0;
 	int array_size = 0;
+	int alloc_nr_max;
+
+	if (memcg_kmem_online()) {
+		alloc_nr_max = shrinker_nr_max;
+	} else {
+		if (memcg == root_mem_cgroup)
+			alloc_nr_max = shrinker_nr_max;
+		else
+			alloc_nr_max = shrinker_nonslab_nr_max;
+	}
 
 	mutex_lock(&shrinker_mutex);
-	array_size = shrinker_unit_size(shrinker_nr_max);
+	array_size = shrinker_unit_size(alloc_nr_max);
 	for_each_node(nid) {
 		struct shrinker_info *info = kvzalloc_node(sizeof(*info) + array_size,
 							   GFP_KERNEL, nid);
 		if (!info)
 			goto err;
-		info->map_nr_max = shrinker_nr_max;
+		info->map_nr_max = alloc_nr_max;
 		if (shrinker_unit_alloc(info, NULL, nid)) {
 			kvfree(info);
 			goto err;
@@ -147,33 +158,47 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 	return 0;
 }
 
-static int expand_shrinker_info(int new_id)
+static int expand_shrinker_info(int new_id, bool full, bool root)
 {
 	int ret = 0;
 	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
 	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
+	struct mem_cgroup *start = NULL;
+	int old_nr_max = shrinker_nr_max;
 
 	if (!root_mem_cgroup)
 		goto out;
 
 	lockdep_assert_held(&shrinker_mutex);
 
+	if (!full && !root) {
+		start = root_mem_cgroup;
+		old_nr_max = shrinker_nonslab_nr_max;
+	}
+
 	new_size = shrinker_unit_size(new_nr_max);
-	old_size = shrinker_unit_size(shrinker_nr_max);
+	old_size = shrinker_unit_size(old_nr_max);
+
+	memcg = mem_cgroup_iter(NULL, start, NULL);
+	if (!memcg)
+		goto out;
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
 		ret = expand_one_shrinker_info(memcg, new_size, old_size,
 					       new_nr_max);
-		if (ret) {
+		if (ret || (root && memcg == root_mem_cgroup)) {
 			mem_cgroup_iter_break(NULL, memcg);
 			goto out;
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 out:
-	if (!ret)
-		shrinker_nr_max = new_nr_max;
+	if (!ret) {
+		if (!full && !root)
+			shrinker_nonslab_nr_max = new_nr_max;
+		else
+			shrinker_nr_max = new_nr_max;
+	}
 
 	return ret;
 }
@@ -212,25 +237,58 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 }
 
 static DEFINE_IDR(shrinker_idr);
+static DEFINE_IDR(shrinker_nonslab_idr);
 
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
 {
 	int id, ret = -ENOMEM;
+	bool kmem_online;
 
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 
+	kmem_online = memcg_kmem_online();
 	mutex_lock(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto unlock;
 
 	if (id >= shrinker_nr_max) {
-		if (expand_shrinker_info(id)) {
+		/* If memcg_kmem_online() returns true, expand shrinker
+		 * info for all memcgs, otherwise, expand shrinker info
+		 * for root memcg only
+		 */
+		if (expand_shrinker_info(id, kmem_online, !kmem_online)) {
+			idr_remove(&shrinker_idr, id);
+			goto unlock;
+		}
+	}
+
+	shrinker->nonslab_id = -1;
+	/*
+	 * If cgroup_memory_nokmem is set, record shrinkers with SHRINKER_NONSLAB
+	 * because memcg slab shrink only call non-slab shrinkers.
+	 */
+	if (!kmem_online && shrinker->flags & SHRINKER_NONSLAB) {
+		int nonslab_id;
+
+		nonslab_id = idr_alloc(&shrinker_nonslab_idr, shrinker, 0, 0, GFP_KERNEL);
+		if (nonslab_id < 0) {
 			idr_remove(&shrinker_idr, id);
 			goto unlock;
 		}
+
+		if (nonslab_id >= shrinker_nonslab_nr_max) {
+			/* expand shrinker info for non-root memcgs */
+			if (expand_shrinker_info(nonslab_id, false, false)) {
+				idr_remove(&shrinker_idr, id);
+				idr_remove(&shrinker_nonslab_idr, nonslab_id);
+				goto unlock;
+			}
+		}
+		shrinker->nonslab_id = nonslab_id;
 	}
+
 	shrinker->id = id;
 	ret = 0;
 unlock:
@@ -247,6 +305,12 @@ static void shrinker_memcg_remove(struct shrinker *shrinker)
 	lockdep_assert_held(&shrinker_mutex);
 
 	idr_remove(&shrinker_idr, id);
+
+	if (shrinker->flags & SHRINKER_NONSLAB) {
+		id = shrinker->nonslab_id;
+		if (id >= 0)
+			idr_remove(&shrinker_nonslab_idr, id);
+	}
 }
 
 static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
@@ -305,10 +369,33 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent_info = shrinker_info_protected(parent, nid);
 		for (index = 0; index < shrinker_id_to_index(child_info->map_nr_max); index++) {
 			child_unit = child_info->unit[index];
-			parent_unit = parent_info->unit[index];
 			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
 				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
-				atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
+
+				/*
+				 * If memcg_kmem_online() is false, the non-root memcgs use
+				 * nonslab_id but root memory cgroup use id. When reparenting
+				 * shrinker info to it, must convert the nonslab_id to id.
+				 */
+				if (!memcg_kmem_online() &&  parent == root_mem_cgroup) {
+					int id, p_index, p_off;
+					struct shrinker *shrinker;
+
+					id = calc_shrinker_id(index, offset);
+					shrinker = idr_find(&shrinker_nonslab_idr, id);
+					if (shrinker) {
+						id = shrinker->id;
+						p_index = shrinker_id_to_index(id);
+						p_off = shrinker_id_to_offset(id);
+
+						parent_unit = parent_info->unit[p_index];
+						atomic_long_add(nr,
+								&parent_unit->nr_deferred[p_off]);
+					}
+				} else {
+					parent_unit = parent_info->unit[index];
+					atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
+				}
 			}
 		}
 	}
@@ -538,7 +625,12 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			int shrinker_id = calc_shrinker_id(index, offset);
 
 			rcu_read_lock();
-			shrinker = idr_find(&shrinker_idr, shrinker_id);
+
+			if (memcg_kmem_online())
+				shrinker = idr_find(&shrinker_idr, shrinker_id);
+			else
+				shrinker = idr_find(&shrinker_nonslab_idr, shrinker_id);
+
 			if (unlikely(!shrinker || !shrinker_try_get(shrinker))) {
 				clear_bit(offset, unit->map);
 				rcu_read_unlock();
-- 
2.43.0


