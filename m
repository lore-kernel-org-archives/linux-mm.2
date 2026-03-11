Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCAAAFD88E2
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F3F6B008C; Tue, 10 Mar 2026 23:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F251D6B0092; Tue, 10 Mar 2026 23:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2766B0093; Tue, 10 Mar 2026 23:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB7A46B008C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:02:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EAE8140539
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:50 +0000 (UTC)
X-FDA: 84532284900.29.ABE55B2
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F41E20002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=U3YBpXDz;
	spf=pass (imf03.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJuSJm3X4xhlOG3+qvokrBOrPsbIME05pWUjl43X0aE=;
	b=qJfHLcw5bTs8LRyrTM2XUlEF2hQJS/myee6BW3F/zsv/vpxcLBPOyCxijaVmI/QlZeMWrl
	47TFR4iqh1ZBTdXhflDn9ADxREny0WUMqxpMu7i9Z0v2ICaQ9yZrprl5TsAgwYNMFKELDa
	fAfVUvBCfwZ2ssDiMw9X3+eYT0xoqkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198168; a=rsa-sha256;
	cv=none;
	b=q2EAjtsYovXCDUoRQR3zwXhuWG+XlZzXPc2jHRGnmFZYPAdwfRJUWnZhiF1lEJjy85AlRG
	2U6OYGQAVJcLECUnhYUTupRsYnXeTjgnQX+OxVMfy8i+/n6g5kNmRx1/NDPeU/dxmP8cY0
	I9jdHncCG1Sl0IGr34wAyJBWODFGTz0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=U3YBpXDz;
	spf=pass (imf03.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2aaed195901so62468065ad.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773198167; x=1773802967; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJuSJm3X4xhlOG3+qvokrBOrPsbIME05pWUjl43X0aE=;
        b=U3YBpXDzh3d0+JLyq3efP07XvIfe/OowQIoDKN9X2AvoPlisPS1puY80g5ZyOvhC6n
         48ers/oU3FFYTfBMdkRrCLwEUGjw+fmCBIKCZl9hDHuagQOifCvpQaYcTXg0cq3hWe1A
         ZU85Ka6OI02Nk57XKvLeqWTO0LEgpI5CQwvzmrHJfhrgm9eWzk+1s3FQTEevGSuiyahR
         6llMD9rcsXYhgs/ll4ByIomKJCkfBrVkbBPPN/5JLkeAesnVWXKArJJiRSHL0wi5TT2g
         e1SCYTYktiuYcdR1zLRg3ypT+eFfEtc/JbDxmhd5vDdXpmg5EMFhljH9bdRmEcGeTobO
         T00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773198167; x=1773802967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IJuSJm3X4xhlOG3+qvokrBOrPsbIME05pWUjl43X0aE=;
        b=UL4stkLv6maGR62rY44t2f68BuSCouN8+6cuMMf1uCy1l8+zLpXYOt76qmfi/jJfDe
         ztrxGLX/JeXwA8oLBvHm0cC7NP0fkpGbj0EvI6YJdluS9YcNe7JfWv7lIO9gASvNUWDx
         qFvTQysBCtbvT/vkmk88rzMXAS5cSvdJq+1tLaG+M2kXNnfOUuYHuBSdxAl0htVXFVTl
         /5HBBPY79f+b2ie3gO9IXxkXYQ8it0rX3Oe+VjhIdJjn3sqIviPz3J44NY+Q6nEFaaXl
         yRrH/5XK3KQ8eP761WdpgLJ4qSxnEr42yhzdxKNQ0jClNXOQREztAwqwbMlc5thMsF4d
         M9YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdO9/S0QQ7NMNuNEuMvEmkPXi8CGD6ioxP0QxBfKO8zl8NTkDTagClsAoyr58rsv+iUpxxlZiDbQ==@kvack.org
X-Gm-Message-State: AOJu0YxSxNZL6cwrpGiRtD92I1WIvw8DsJQFgb6auDuCyjBZcKhW5hTF
	J2hQHZsrd7BMoiZeVfc/WS3ua41yXUPT1zX5yuKaTYiDzmMIQJHq2Iu/4zAdehaW7rY=
X-Gm-Gg: ATEYQzx9CkTBPr+zXVI/ekAUsYRETfV2TVzneMWJQdgBlrv6Q/Hoqj6YOZzl055G7O1
	hq7dVC+ZWfDNGlvJUhyz3jL1vSovBnRcVXNFcU4eSiJCAxeCH9yJ5tuckT58DUHdn07Kwd9K36g
	cWIPxnZLIBcsme9cEpvVJNNdQ2d/RsZyvvSZJlW7nbCgVy1HupWzC9zrvwg/6UbHr2J0ZqxSQrW
	Sp2MFF4wLkiE102UcvtdDPq3cKntN8x9Tz8Bt1qb+OSq1Nvm5mKQ/f5OJJ9x0IVOvC6iBNkOhlS
	Suxw/1vmV8FmJCGiaT44yMQa2PUUetpbHGktC6nQaIQ//DRHHdzo3glHSKfEf6b07Ia0HbTZSHD
	v7NeuiuaVGPkWIpCX4PCEeYn+ht6LodxL8Dy2YiGobToTz1VJ0TosVTFMYfdjID6GrFU0mkritp
	LjtVtCzZ3JfY4XMY8/4BoHIGeunj8yt2LNSyD4aQ==
X-Received: by 2002:a17:903:41c4:b0:2ae:4f81:2f14 with SMTP id d9443c01a7336-2aeae81642fmr10076395ad.24.1773198167284;
        Tue, 10 Mar 2026 20:02:47 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae378974sm6251555ad.82.2026.03.10.20.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 20:02:46 -0700 (PDT)
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
Subject: [PATCH V3 1/4] mm: shrinker: add one more parameter in shrinker_id()
Date: Wed, 11 Mar 2026 11:02:32 +0800
Message-ID: <20260311030235.240953-2-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260311030235.240953-1-haifeng.xu@shopee.com>
References: <20260311030235.240953-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F41E20002
X-Stat-Signature: b8t1584swcoi68mbb4w9tsdkk5sp75nn
X-HE-Tag: 1773198168-155479
X-HE-Meta: U2FsdGVkX1933dFHc9POGqSOkY70b+FyFdxbOWzoBfxxiUl1FoxVH2LZNTBrM61/4Us4BNhTnzQokwvj0m2pF20Ob5ywDkE3I58B4xkvc4mIvj8OIQCsczK7Dht12rb1btXwTl64K0MrZoN9aAVc4gxpUXFOX560hfpX+VQS96qZYZcSNfbSSpx9aiq2ia7UibEhaqxgnyX0y2dleZ2yn2YaCSf+xy1//EeOy16Hi2/nKOSjTW39RdYGgmMGX80v0QVPXjnPjQ73cpUVnqI2WuK/Q8RnXQIDU6gwC3W1Wn7DF+6qiPS9PKTp8e/OyppcRUSf17oVEPbr83f6b/NnE6iY7oWivmxEaguwd0QeQjSN/yBb/D5TjTLYATcFzUxUwIa45EVNdIAe9m6v5gOF3d+Goia/3dKruOJw0VwQDXja46ztqFOOFSyqRmwNuqpZSHQsOp9VtZklFcuPaZBwcioJLT4TRp41QkJKUPQuTMaCcUtA5YsYZk0kjmmfjt9jqS9Wf0oMHgPJC98FCXa8EyQCQS5t14vwY66zyE9AMSreHOcwVxIDs/66z1NTRCvP7ULbpWzg6VGqxxPwRaC9tfFI/wOp4eL60NpRy3tZUgum4PwexfkMJPJXXlQU7LgSYU4tDeeTJwNEO2fu5q8vnOAvpc7BU8cXLHjsXiihyi4xvj2uc1Tvnh633Om7wL97m4FVpjATjHPl6f2i74jto6BNj+5MxM2cgmlmeWIdD7DSxfWbvouNRrRkfbitlNLet9uV1UwByQPmDD+EiKJGldFLQVTGIhYUSLvK4VEWal9y+c7dfkcaBiiQXAqpSfP+f0g+qSt/K/7mVA8p29LYRnciTHKB2hEJDUdcMgxrHVtmRou2ij5XDlFIf0NLroX6gnCWrl2QC0G2+ar+gfQCdtmbc2qLqWUWPRsmB9WM/E0KCa7rfNk9UF1SyScEZRCphyEEscvG0EUxngRw5EK
 /0NEjeWl
 TDJ8E/7AlNYR8IPLMVIN4+D94b6Fib4vmPztwj8iKbfSX6uie/as8O7baLqP9ZIo5uFp/V1mLkFs5RUMFUReuZdv5KbSwiMU/KPLkVLH7U8RvAd5zQYfJy/S/gmJRrDX4lSHEAyQ3hVnz2TS84YzO95OcTJ+SfOsyQFLtrL1tEpgBHDFY0Fwz5+aydflDPnaLfHWKVl6TZ/Cmdq5LXM1SAkXiM/8QmYyF0xLZU2Sry52ljTbKK1G/zrJPB7II54jgt52+LUHfEScvtsataCKi8udKteki0hFXF3xwNuG0s0mrPnktOzzH9cCnlt7v2ibPVwodV2TkMaLPrTcQOWnajDEiBMBJoG/EgslsEQ7lFDwZV9mTkOtc/9veQkYIgAHpQCpqZFKV9W66l0p0Roa6N6uZdeePOH2lKTGN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a parameter points to target memory cgroup in shrinker_id().
The following patch will use it to decide the id of shrinker.
No functional change here.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 include/linux/memcontrol.h |  4 ++--
 mm/huge_memory.c           |  4 ++--
 mm/shrinker.c              | 12 ++++++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 70b685a85bf4..a583dbc0adcc 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1634,7 +1634,7 @@ void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 
-static inline int shrinker_id(struct shrinker *shrinker)
+static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
 {
 	return shrinker->id;
 }
@@ -1670,7 +1670,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 {
 }
 
-static inline int shrinker_id(struct shrinker *shrinker)
+static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
 {
 	return -1;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74ad..6050f8d71587 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4353,7 +4353,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		ds_queue->split_queue_len++;
 		if (memcg)
 			set_shrinker_bit(memcg, folio_nid(folio),
-					 shrinker_id(deferred_split_shrinker));
+					 shrinker_id(memcg, deferred_split_shrinker));
 	}
 	split_queue_unlock_irqrestore(ds_queue, flags);
 }
@@ -4509,7 +4509,7 @@ void reparent_deferred_split_queue(struct mem_cgroup *memcg)
 	ds_queue->split_queue_len = 0;
 
 	for_each_node(nid)
-		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
+		set_shrinker_bit(parent, nid, shrinker_id(parent, deferred_split_shrinker));
 
 unlock:
 	spin_unlock(&parent_ds_queue->split_queue_lock);
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7b61fc0ee78f..61dbb6afae52 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -255,11 +255,13 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
+	int id;
 
 	rcu_read_lock();
+	id = shrinker_id(memcg, shrinker);
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
+	unit = info->unit[shrinker_id_to_index(id)];
+	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(id)], 0);
 	rcu_read_unlock();
 
 	return nr_deferred;
@@ -271,12 +273,14 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
+	int id;
 
 	rcu_read_lock();
+	id = shrinker_id(memcg, shrinker);
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
+	unit = info->unit[shrinker_id_to_index(id)];
 	nr_deferred =
-		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
+		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(id)]);
 	rcu_read_unlock();
 
 	return nr_deferred;
-- 
2.43.0


