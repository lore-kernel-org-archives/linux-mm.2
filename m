Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B0EC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F9F6B00AE; Mon,  7 Sep 2026 07:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9626B00AF; Mon,  7 Sep 2026 07:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE72C6B00B0; Mon,  7 Sep 2026 07:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91DED6B00AE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:01:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20E8FA0125
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:26 +0000 (UTC)
X-FDA: 85186674972.21.DC582A2
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CEFAA0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ufLa2YZ7;
	spf=pass (imf15.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778884;
	b=Aw4JYxZ+T6h9cQ/0aXzFkCene+XyRClc1RREE8uSl0i2+BcYPrh6oXO33/BTR/itZn39bO
	LmpuZsUteNeLRVKvslF8RXvP6/oXGnPfougbQOukWznpiDrNvf1WaLilkQaFruHxwU76NA
	3AofEkMtTVAwYRIKAGbI7rbLUO3Zeko=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ufLa2YZ7;
	spf=pass (imf15.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmWYNJGIXxazgZ5q5HpJHBhK6Ac8N304N8jTgUaL0cU=;
	b=DR7CYbJTqOmK6aGI02FQRVONwjrpLLhYfT0hT8GjDljJBlhtBj4bgXsKxIHyc2FUQ/6e//
	p9eW8QoF3lpV6y7LTDT4bA9xDpcKz6jQTOlegsy8RGg8KBMFxA11Up6ppowV+4KPsHU5wM
	mnBo80dEWeAVkaBl5XYeiOipPWFEvgY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788778881; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=cmWYNJGIXxazgZ5q5HpJHBhK6Ac8N304N8jTgUaL0cU=;
	b=ufLa2YZ7Va6TgXA4VKxj1Yvnk9V0zZmF0Wrtd4Ysr9qH5kWh1VCWS50KEjw1Vlv4sWzV43y4/gcOH0Jqfn+HjAiwLGSHVW0s0NxcT+quvL66X4p9sclfJYvu27/+OuhJDncxVrohPqKgzTjwkwUMf7OzWghIutEyHJC12ZbflD8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XATsw.3_1788778878;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XATsw.3_1788778878 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 19:01:19 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v2 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Mon,  7 Sep 2026 19:01:10 +0800
Message-ID: <20260907110111.2286932-4-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6dhtmjyx5hsknyhzhyzga1q77ancx6wh
X-Rspamd-Queue-Id: 9CEFAA0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788778883-250207
X-HE-Meta: U2FsdGVkX19yDth4oorApq0VWE5I/rJDXbOJrsyCZ+4XU0NUF1hCbzLqq4bGj3JebqDYOFDC8CZHDPZbjBkmUwNZXi4WVwjJ/bEqLgX3TNUriZ/+VrmxZZ1Y5TqdPtcIqLp8UglhxEdGYj3KlLKqghWI8lmCZbjKdYV4rjI5bBmtT8qhnE0beuoqOYGaZpJpBnSS7Bu3yLgFeL3UdurXS9ent0EzUdnQ2TVRXKwi3JiaolT7SVxjoRoGW/+CTFqofXsSK8/nfNfy0q/thQmq0pVp6R+R4L0TIH7ywOF5Q2pOlvphacellf7wW3XJXI/XkRsBvO77qVkKFMi1/7GWKTc8fnCcfOVn5F+/EX7rw8jRM/bnefYxwM+1R6PHkOWP2fl+aL3wqczA5DKL/OiRfTvF98UUduVSl5FZlmJJrsG4lPQwv80Vvvr+i8a98/hnKBgdr1Z1nd+r4zhtXoBAgdesQU+k0BE32vNNcC0Od0RKboZkFs/L/ZypbJouOQH876XBPDiSPxeJZv6EBcY0wjjJ2zQVL3VWGblbXmNdq3tJ8BkMUsNxlYHqernJOiM64deXGMsuoSLerY0nOWGto1MXirldwPZIrB09DFrxHJ6ip1caX/46obvZCuYcyijN5o3RckjuIForj4Lhf1z0TlcdWKSrCOw5IWHHNtKcA9UDfcFjvKZ8FjJl3kAbrxMOd7Kkmqa9eml6u3eFy+dud8WbIbkVXmntfb7buHJcvIQU059YAccbvCreqL0tkZfM2aQFWV3X/uBkxMrqpDAq86uQvRvXL5zQn5XfYbWHsH1ZmV7VGJnAzpEXpxa6CxyRrvikm9+x8lI9RMgBr2GrRroYYzXxSue2Iw/Y1hHe7BfTTPrN46/83i9dOmmSOjsQyN2mfcejQjRKmc66LJyxF/JAvZbTezSjKEo2tQ2l63X3Pc03E783HflstIOBJlY/2lWYYDFn65nzd3qpF5o
 1UuOFDzG
 j6V6kuh5vJJFkAQp2j7qVLZwZrJd9zb6Ypii2krt7tBPsPAArT4OLJp6VHoHbL1BxEyJhQH57y9Tuzy7phr7iYzeKUcz9WOZ6m1ZP9+WQJFzlFBYBtoSXPXHVKZc8K0sa5n5l3D4ueUJx9u4HImBz+Tp+0sCvtCfxbRkjLrdIC1Vl+rui9L6xBaH8ekrrZe4CEkvIy6+JNf2BSxqgShzDR253J4RFiZ+MOEYR0+DAxFjvBrdJNLq2x1qwrrUV+4r6jcsqlOzXEjyuMsydO0XLYyTP3mZL40Mrmb0M5yfKstlGjn754GiWz3v1fJFRLDpjipzGk+H3wvkC2ft8DmbI35Py0j15qvDndT9pR8UmWlmwDuJSLghToSlFElO45OurbnHedgL+FXIuiIOmxNE16QqbCQjyVBtbkNSg0lLXLMPd3d3uOzz+R9+j1n05yCjsXJsF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On a system booted with cgroup.memory=nokmem, the deferred split
shrinker is quietly demoted to a non-memcg-aware one.  As a result,
partially unmapped THPs are only split under global reclaim; memcg
(limit-induced) reclaim never splits them, so a cgroup under memory
pressure keeps its underused THPs intact.

This is a regression from commit fafaeceb89a5 ("mm: switch deferred
split shrinker to list_lru"), which re-registered the shrinker without
SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
precisely so it would keep working with kmem accounting disabled.
Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
nokmem and the shrinker loses its memcg awareness.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers" [1].

Restore the flag.

[1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c5d11147b69ae..87c9fc48b7cfd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1064,7 +1064,8 @@ int folio_memcg_alloc_deferred(struct folio *folio)
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
-						 SHRINKER_MEMCG_AWARE,
+						 SHRINKER_MEMCG_AWARE |
+						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
-- 
2.43.7


