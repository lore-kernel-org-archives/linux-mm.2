Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AD1FD88E2
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B63D6B0093; Tue, 10 Mar 2026 23:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169446B0095; Tue, 10 Mar 2026 23:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C8C6B0096; Tue, 10 Mar 2026 23:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA82B6B0093
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:02:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6787C13B1DB
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:59 +0000 (UTC)
X-FDA: 84532285278.05.3A9515B
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 82CB21C0009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=gcSSAESC;
	spf=pass (imf18.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llSFVwpJUq7vN+RyIjB37GeQ61RCDZGes5EfnEaTg+0=;
	b=4UW34GKaSdmh83HZHcelJkj5b52ve2Zl0JWV0X/E07BCT5BJuuCkgMttPFgKeghduSG65n
	QhA1EbnIwYVRZyv6kPSPigLPZoayBOEv00nsoUX1NL9hxqQv1Sh+xJ2T1d8EtHr/fCuLDI
	iuXYZ+YQBqg56swP6APEDeqa5BfErqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198177; a=rsa-sha256;
	cv=none;
	b=ygwfMb4LswdzwTEYGl9y3EJOrhdAb+4EocDAymBRjF11DpG38D31Wj1E07PLEyTd+KegNc
	/pLMHBRYqRuj9taMWHBcil0DmxjvUQBXHREA92FwYi8h1EzIJC5i7cINXUOqUFG2+RG/kj
	rFN5r6D6LLd0ZRQIDeKeMtGL4ayJdwM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=gcSSAESC;
	spf=pass (imf18.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ad9a9be502so88515045ad.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773198176; x=1773802976; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llSFVwpJUq7vN+RyIjB37GeQ61RCDZGes5EfnEaTg+0=;
        b=gcSSAESCEft7cB3AB9gMPmA7lcDzzu0cgV+3b9gOuz0qKF3kOCqx/2qsl2JIS8Vp7Y
         1O3mfBkdxKtTog1hEvlePbkYfU3EXPKRla22+3NGx9+B7KqMUxAhDPphgit0heBBHzm8
         Cql1hY928QqMKWaaoby0gOmjYz+kylGGHhPI0Jukt9R6d0p0oz7t96JhUjEbPdltamvD
         06rX3/9SIakRmRlOTczBSQma+EpeudXqXF9ys6PD1hCSnj8gMfE0h1Mr2w4lvmBOCyDc
         Lv8qmlAl0D8HocqoWW3lbUtQLxo5XKGKGgUAwBJn0ewLvZ/JqKoYRqx5eYBuAZHgws+B
         x4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773198176; x=1773802976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=llSFVwpJUq7vN+RyIjB37GeQ61RCDZGes5EfnEaTg+0=;
        b=Xu3c2CFAGLhI7LhdoLJmWJQR4ooTt+sMvcC5ZvEjVRN/Ib5tD5T/FeystqrfLJEFiQ
         khrBrM0HaAcTmbsX4tRUl77oKy9/iw13vWhacYsN7LzKqp7r930BVm4rnDo5WzUCELBt
         iXc2xTQ1lrvyJoBZwoctCEznQ6jwOe/bmbI09sTwJt4cZOSzo+rUK/slr07nSmtW1Pv6
         9vGemuB4EygcBoDFU5B64ZicrDbofM4OmVILdAXTxNtC4fKYrwZNavywbCOKDs3Grzy+
         tDz6sPz07jVjcEGMlEtYy+/TT9dR6wxvzopbRmqflBsrtY8wMWWKsvY32LgUZQCfbGUK
         fZRA==
X-Forwarded-Encrypted: i=1; AJvYcCWmRgsjYhmyXo2MhuVZiERH9yH01qYwS/gCqpnnBtSlDyxO7dgC5WOS4ceKRF+2kY3KCwbP6pjzww==@kvack.org
X-Gm-Message-State: AOJu0YwHdmKwr+bu4yv9cNIRi26r+ENlE/wUAhe/IwTfqlU4XtuAIFUY
	g/ZYIOnJwDSK0xc5tUYgR4UcY6EqfiO1r0+JC7nJ3yOGDdWEEfj/Z0UyP8mu9GOpIqg=
X-Gm-Gg: ATEYQzz8z3XeVDPU6DdnkbMtU8FheFTwarjwkyxJ+rqqYarWvnNCtMlPBn+UHAh3CTI
	o3Gb2Lh4lyDPqNP3C2+VQ3+uLf4CySFJT4RJIiJUmeNpXN0Td0jM33CqUw+YRYvtcqH/gWs+MLH
	ifEN9iBuXoy1YkbV8d4SW4Q8T4YpZ/TeuoMzny54SpE4/u8J/nF9WQjsGetgfAh1mJFgsgaRrQm
	QtRTGYGDia2VsGbLmECI/hEd3GZCV9CD1GGbNE+164nxi+wCZZZvP7tbOlVLyRClJooj964Uq9q
	2ZtyWs46Rm65N1RWG0TBWYvjFf3tyWnlLcuKNZAuvsnN/j8tKJ5BhzgWio81VW1+N9lCK3BXs/Q
	Sbcy1wue9HyLssICw+p0O4e/SewNMTxLOwwSlXd34/VoHVC5zISwRKYBg4D4cZpJLr5+O9ZosBz
	svWXBFEI7GWfVB80Ae9YOzU1pjzBP8p4kfSMbWkg==
X-Received: by 2002:a17:903:18d:b0:2ae:3dd5:c69c with SMTP id d9443c01a7336-2aeae858e3fmr11351905ad.33.1773198176279;
        Tue, 10 Mar 2026 20:02:56 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae378974sm6251555ad.82.2026.03.10.20.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 20:02:55 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	shakeel.butt@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V3 3/4] mm: shrinker: optimize the allocation of shrinker_info when setting cgroup_memory_nokmem
Date: Wed, 11 Mar 2026 11:02:34 +0800
Message-ID: <20260311030235.240953-4-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260311030235.240953-1-haifeng.xu@shopee.com>
References: <20260311030235.240953-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82CB21C0009
X-Stat-Signature: 7y89y1838s6otecgargaiiuwdmezqruf
X-HE-Tag: 1773198177-2096
X-HE-Meta: U2FsdGVkX18/SV6ueo0MP6rQLMis7AcdDedTWcXlE4B0AT1gYSPTCxEGkrbj9n+IfSfzn//cFG9zPYX8uO4ckTpjx+Hg2XDvAKUjtxwQHwPsJ8PuPU7wYcLLQ83NAMmP91RQinA5oRkmbKfhyDku7qonWKriu5kxUQ0KRYFlit76Om2KJaUXdE6bBHGMiKkApSbOAeF3cmy+ZIZOzhQfj19vsB5U9m3ValwvrzUWhmwFo5xjoNbUtl0+ZnYlGa648kQyUfly09bhYp5nq3h2lvRk3Ge/zYpi9pA+hRBa8232Qy43urumHgySF4r1fvvir1y1+hMa72cqZN0KnJA4ymFlj3+Cfx5foifEVhiZ2kSaj7ctf0FxE3vXQO4DMp1Y0g4Qnahp48iQMO1AXpLtRsyKAxMbloS+dOthNrJxCWLN6eRE2PqlUDblYuTWkmHObFvVAZ4B+3bXw2hXsOZMMNjLXaAJcbMmpbMGzHBVlgaaxbezNqs1ueObaadoV1SyNrwW/qzsTBb/PQdkUZB5tO3xGOmOOjjhHEV0phQwkkCxznLHrORgK7k0o+ZkZElDkkKXDGjDIp4JoE564ix4yTL9IDLkSiCLrzcOn3NUjE/WxP8gtWh8K+EDUp5qCCJ1YtDxZyudgNzXTza+XCRctNQf/KftfW/5N/WA9laLE13go45OwxpHA1Tn09onN6tAN7799eTx4FYHTgwxD9Tec4RNvTH9LxQ+f4BfIKRYktl/mzDkvRSvXePOyPuxgg8LPYVUZOgDzrFpbXl8Ifvxv3e6uKlQKi3xApw0OZpBmyKrORBObIVnETkcVnbmX9KPggxYUigRIgwfAvH3FjFUYqgbe1j8M8mE6PcN2wRBqY7BR2eh54kZHOOviM7/zTnbOErdd4pwJKMMbGhZsiatxzCI2cC7qLKiZo++YNbf5I49zM9+7Op/k8KIs75wBoWFNsrOxSXq7+2fWy/ppfJ
 DFpoVOK/
 0x3MwWlxryBLLGQ+/WNO0yNW2uZuvAM4Bey2fD4ZfjcUyrOwDGs5Zz9APkpsGClqgpVRXnXnwi+Y9Ufsf/pAMbys+FoWgUr4pSqfqdJZsP8tsCHbToCATi96YFqLJU9vWVPV4Up/hsSewvYNyFoPLYkfzbN6VY5VygKJqDSchSKxOz262iYRF0MWn3CKwArQYRWMO+U55CL+RXrXnkA50MLfiYxyib222iG+408G46vHOlWlIWW73BCUW8LVxi5Ikhytxq1oyS8Jrbms/fj9c28mfzT4Fmc9ZgLI7Z4ln4X1Dm8dyUnL7dr3eUPNQ77uN8Ae/OUjg4RO8GWucV/DDkYANGA==
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
 mm/shrinker.c              | 117 +++++++++++++++++++++++++++++++++----
 3 files changed, 115 insertions(+), 13 deletions(-)

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
index 61dbb6afae52..3137518bc746 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -12,6 +12,7 @@ DEFINE_MUTEX(shrinker_mutex);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
+static int shrinker_nonslab_nr_max;
 
 static inline int shrinker_unit_size(int nr_items)
 {
@@ -78,15 +79,26 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int nid, ret = 0;
 	int array_size = 0;
+	int alloc_nr_max;
 
 	mutex_lock(&shrinker_mutex);
-	array_size = shrinker_unit_size(shrinker_nr_max);
+
+	if (memcg_kmem_online()) {
+		alloc_nr_max = shrinker_nr_max;
+	} else {
+		if (memcg == root_mem_cgroup)
+			alloc_nr_max = shrinker_nr_max;
+		else
+			alloc_nr_max = shrinker_nonslab_nr_max;
+	}
+
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
@@ -147,33 +159,47 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
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
@@ -212,25 +238,58 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
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
 			idr_remove(&shrinker_idr, id);
 			goto unlock;
 		}
 	}
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
+			idr_remove(&shrinker_idr, id);
+			goto unlock;
+		}
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
+	}
+
 	shrinker->id = id;
 	ret = 0;
 unlock:
@@ -247,6 +306,12 @@ static void shrinker_memcg_remove(struct shrinker *shrinker)
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
@@ -305,10 +370,33 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
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
@@ -538,7 +626,12 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
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


