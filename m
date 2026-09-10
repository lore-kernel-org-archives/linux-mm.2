Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD34FC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6FD6B0096; Thu, 10 Sep 2026 04:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089146B0098; Thu, 10 Sep 2026 04:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08326B0099; Thu, 10 Sep 2026 04:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCCB76B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:07:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C3B1140472
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:36 +0000 (UTC)
X-FDA: 85197123312.14.5FFA605
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA35716000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=i1Rehiee;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789027654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOGxmv+6Opxbs9N7PyJbTc7/4fbErynFF1JLR/lLM04=;
	b=FBOkp896zKbJJLtVkXa73LUocqWHtd61cqHHCKrDxKcprBR8ZXtrT/wPFIRjCsrVcilGBK
	BQiItT2P/TBAZbHLQOw5SJfmxVtnD+dJecUveKftK/0P9TE2R3O5BhkIZ6FJaVZFkqQtsE
	Y8/yGJ75fLIrhb+p23Ec2g4oxIKS+u0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789027654;
	b=5BRMDqVOMkTV20qQjfZNEsutT/N+Pl1MbyveipMI2WXwFTeH6XlIS9CrO0gLKwEUUyWp2h
	Pi4xEtky+aG6ZFV/Qvt+fzWReY+6gxYVId3K0igHKJ+Pm9JP+lVDi5KijRJygEIf2MAihn
	SKwMQEoyfelx9XKJM9WPIEMfa4XWpU4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=i1Rehiee;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789027651; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=yOGxmv+6Opxbs9N7PyJbTc7/4fbErynFF1JLR/lLM04=;
	b=i1RehieeneJ++lY5bwdAwff+/HASGOuQ/7E3NNurAb8UKfMv7k/Rp9jK1T3xkIybPIYHJp2vLsm9EF8m7b+2gvirUg3LUyP5+hXgpJg6toomPx5YVZNthNt4ZNatX677QG5zZBTvmGDOAt2n0Mc30Ni/BNbOJXtD2QFvi9jlRU0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAh0I06_1789027649;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAh0I06_1789027649 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 16:07:30 +0800
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
Subject: [PATCH v3 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Thu, 10 Sep 2026 16:07:21 +0800
Message-ID: <20260910080722.3961351-4-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DA35716000D
X-Stat-Signature: ojw31hau8khjn3b16ngigzkhid49qnx6
X-HE-Tag: 1789027653-435183
X-HE-Meta: U2FsdGVkX1/dTr0brOKKmNXdEyrXoczzVMTbUQX/NZZApvWt0MIPtNPRnT2f89bJqtCNu+rxfWAefRRzL9hqfrtNEGRhs+OiEPqkkAGegIuYRxgZp0YDxV9WGDlwEAGuaiirvp+CQHRfqWwuFZr5LW3FQRE2mNhkTnbP+nu1mhfGvi4njZH+ii81JL5gAXJhisV4WHoNdppXya1urI5cMyZg0v5wC7mnG5lERXiSvfS1FJYCtBnnEpDTjiPYekKNCc8hBhn4Eg9NuccbAahpE2WaX2fx85uR4yPwBGkihZexF6pLW2f9seP3AbHJf1W0CjTOMod4fW2aocA/BPiflwZ1qGt/Bl6fqsJtVg9PfQZTtSqiUXQG3mKni/j2i8KqGRcJ6yT8qcBjJt9XJa4Wzm/hXymsiST3u8GKnaSIb8sFtTrHGqHmx43YwC6GlfaUNGjeQr0ODeds8D+GFMQJihZmYdr5yNmIapiaKXat5ZYsNelIBFXoFKGuWT0gjuyw3cFIqNCv3DRySfXm/F6soa8PNkQblH+9+Tsule3QSfAB9kbq87EzqP7Ycm9PrZpjVjsoJqGxhaw9LBu62sLrxl2H3+Zc33/QWYjwHilD/ENLy29GEeRSr9dz2OOZObMgC8WPEyIe2rG+c8hBk83FiSEHkhV5TRcV3IZUPnoORJtP+LRM1Su6mtOZqhwjwLWaSCHNXC9ZkLhSFMgaBMyqqV84eP6cQorDlkEha+SLMNLclBU7D4SGK75Z4cpbEqoowAaIGzmfmJh8BgQU76xRWEQi8fXy7K76B5WBRyicqoGy2y2+ZjXGOM16KOi2qVEZNM/2AwmFqAHa5GCMtlufKcpW5MFtznbSoFVdkiNC47ceZaWhFLqJ5FH0gZ4zSTa7FEAh5VkY2gP49mbrt/qryLSW6l6bk88BkRz46L/pVgVasJGM+jd8w+W3hnScHs3zLsRG1ydYJG8KPYMHjID
 uVtIbQbj
 Sys8g8HJT1vEkY9P8mjFBxO0yCJJhdoJPmyDlfErWdTCAm3Rvi2zfo17CQ/Al3eMzm5rbaLfSsDKFq1g1pxrInBrgRpvOeZ16zRkHffglAPYAmbY4sbnuXWiQ7G5LWSAXkVK1kd3/G1O6zlZbelj14M6++eyDYNOVIlIiC+zT5/gwiF+rrBrf2Rl/u9RDHdE02DXoi9bO3EFJxFAwgh87+toklY3ASufTQiTp0MHfxLGcvkqm6HfQggT8VqdNgf7abHKw7grMtwAA7AzQq3lsbCKjEMuv2Bb2ogkvLGlQrymi5cGNM/NoExX0RzxEPDwq0Y5jdtj0qoZWfCZ3u+Rtz1Bc/pdQFB9I6TECSETAOOv7bFaZNzDx20FFc2Owds1PUW1TBHdm5IgdOADxRKtj4PF1PgsRlxZ6qjbmGLsHI6IE7joMm0nzqIgCq4BMvrZYZ+fsj5vylm550vfeXIi/Nm2MBbxq4wsFP7fCVEcCA2Lu9vP8+Ilp8l7yAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On a system booted with cgroup.memory=nokmem, the deferred split
shrinker is demoted to a non-memcg-aware one.  As a result, partially
unmapped THPs are only split under global reclaim; memcg
(limit-induced) reclaim never splits them, so a cgroup under memory
pressure keeps its underused THPs intact.

The shrinker has carried SHRINKER_NONSLAB since commit 0a432dcbeb32
("mm: shrinker: make shrinker not depend on memcg kmem") precisely
so it would keep working with kmem accounting disabled.  Commit
fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
dropped it knowingly: under nokmem the list_lru collapses into a
shared per-node list while __list_lru_add() still sets the shrinker
bit on whichever memcg happens to add the first item, and with the
flag set the shrinker would run twice per reclaim cycle [1].

NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so
the shrinker bit identifies the owning memcg again.  Restore the
flag.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers" [2].

[1] https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
[2] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
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


