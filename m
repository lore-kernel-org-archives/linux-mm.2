Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215ED606D805
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Hf/ZmZfs
Received: by kanga.kvack.org (Postfix)
	id B5EE46B05B2; Thu,  5 Nov 2026 04:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36646B05B3; Thu,  5 Nov 2026 04:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5EA6B05B4; Thu,  5 Nov 2026 04:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 786846B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:22:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0CC0140900
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:47 +0000 (UTC)
X-FDA: 85400525574.14.C0301C9
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 161F4140006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Hf/ZmZfs";
	spf=pass (imf26.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870566;
	b=wiGEnf78RjQLhAmByBSyDpgL+unzjKwntbGh+EO2sgM822cafDz8oL9oMZ1Y95qyrs/xYk
	scjAFg0L8jjHvORTV+zSdMlXDq/R+JhWueEykl5MAwAxs5GTMmYE1QWoMiIK+hH8C8tzr5
	QnPKwA41XGJ/heNSPnCWy2w92XYoXtQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Hf/ZmZfs";
	spf=pass (imf26.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goZgGhsuDnXRMkG633Mg/AsrAm2B4reGrlV8Qh0TTu0=;
	b=DzCGae+JNP3eLCC/iMcU3dS08LiIM8k23TXdTpZc3J51rztstMzEdOEuRaQI1hvOG8L/CJ
	Foy/F7Z+WJ8smPQ8t7qwDnsltdbJCnG/IFCijHBbqIdXjC42nZeUE7/tczrplomsLtVz2J
	cglNT0ce1wtLZUteuqtxaueeGZE7vtg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870562; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=goZgGhsuDnXRMkG633Mg/AsrAm2B4reGrlV8Qh0TTu0=;
	b=Hf/ZmZfs8Bt7rqtU0X3yk6m8VruR1zcr+763I6MIe/J2UZ3hKSDs0OqpunV+kJxgu8cvaM1DussguJILE0dkjQ7IZnlLMmRBqSNHkkBATJHyOP1MH7/CoAfDSmZs5Y0hmA9Ntb7AgkLsiG1qr9n5GaBsWSCwfBKsaJmu+pWzfYI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-0p_1793870559;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-0p_1793870559 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:40 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 RESEND 3/5] mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Thu,  5 Nov 2026 17:22:31 +0800
Message-ID: <20261105092233.3558950-4-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 67n3m8wrhjfmi1ud9et9jj5xqez6uzjq
X-Rspamd-Queue-Id: 161F4140006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793870564-468284
X-HE-Meta: U2FsdGVkX19kwpG+074eNCgwGxYYPltpM8oFhVnaXtcVRwbo9mTSul7QQhIWXWzsPdgoXn82zUE6CGbH8zHvoDkyJC99Rm7p/Tbq/NCvtWU80mtsD7KkO6ZVr+bEmeU3C/LHgqtJ3NAH+g54smCideJTuoAb2A5Gzn3cTG0F9B12FRgjn/oprarrmKE8jjKZFoUA9vbzi8sCg1Np5vIbOCY2BYKXBsGrRAb91zm/easWDvXsknJivCWveHMICoUu01GwqZAOvF8OagIVfP2JLh+Pcc9M4u8EJTQlptJ0JkcQyKLFJo8Ao5bq2Tud6ehSezkPm9+s1DIwUlKZFCax1Pr9Zdnumdr6njwIrfkS4oWsEfd0a1rYiOZudYX3x5WyRB6qRzptMJwgVRbtzYgtqG7IyhFSbRbiTOKr7UA0t3EvMk+OgBdm2kdH/RnkOmi0rQIgfMbcsOpSURw7Az8aUi9Ar8vOlV+kKcV2PrdHHAw9dzJCn7y3kgLZsndS95sGZQs6tXwbv+nWyvR+Co1ig2BMsqhovfVVwA0tbEyJW2gJodBkRZWoIzbKoCUJjxuiubR8rWOUcLbLxpx1Iz/ECt+r26bzhPNTbS77EZNVOQTBHtVINcUynhdCl6RKkQ84z3KBgwSkBEq4TGwjcmJuIiTtsD7Yk3fXIMnMdU0XA+XX+Z0BtWe3FHwUg0bqGWtS3yHQbiB4g0tiVDBz4a/klCBeB/mcH8TTaCvXUolQMz25D3ZQXdhpCU77DjPVf3tQ53CgNpzmvmZWmmt+xXG42RBffPLjPvXLBVNTKEn5D8heYt2i9riCd95dmr3H8H8ktVjUwfXcgX/wtMbD/2P0Ek+VokR5EgozKa8z0MD/icOa3sqvbsYsdXAh4hweHu3rP4RfT1WcLDZBoMu5EFJaicTJ/sXB8PZYxGXVibDgoXdFTrCjR7owwLc/CJUom8pvrW8W+HcTEeX/gGC8uj6
 U93vFrEq
 lwWa+r0vrjGZ350iHfo7mdH14rr/E5WElot6L/BXc6LRW/0BWNYSBG2qZLV33slT89lPs8xARgcE3NGUQnL5shUYq2qCHm4M0THTew7pdk5/ReYjZjBeW89i9uxsC3wJttDKk4P7IPTj4794rYNCxq1qIri1aDjhesaLAP9XqwrTDxCYTpgzgvgpjcbDO4XwCGYQui2gZJor4Vazm0KhLBU+uIbNWu+FiK6weZwGbLJwrXUPj2J6gsTyjbuSF5B07V27Pw6oJhJ/WZSnpJh9sVkqsTGaxgCcLEjALTuYfxATNYew7mKQRSX5CluipZtqYCegi0KA+K6w5iojMFqBXJwGVqr0Wc3ney8N+Gq/yfsRk9d8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru
into per-node lists.  That is fine for slab objects, which are not
charged per memcg without kmem accounting.  But a lru backed by a
SHRINKER_NONSLAB shrinker, e.g. the THP deferred split queue or the
zswap entries, holds user memory, which is charged regardless of
nokmem.  Collapsing such an lru loses the per-memcg view of its
objects.  Reclaim can no longer target just the cgroup under pressure.

Keep such lrus memcg aware under nokmem when their backing shrinker is
registered SHRINKER_NONSLAB.

This leaves the savings of nokmem intact: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to the per-node lists,
and the per-memcg lists are allocated only when a memcg actually holds
such objects.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 8e9577c5cb19..7c8d0b959bed 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -690,7 +690,9 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() ||
+	    (mem_cgroup_kmem_disabled() &&
+	     (!shrinker || !(shrinker->flags & SHRINKER_NONSLAB))))
 		memcg_aware = false;
 #endif
 
-- 
2.43.7


