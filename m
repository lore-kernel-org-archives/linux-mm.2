Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0044606D83B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dWqFK12f
Received: by kanga.kvack.org (Postfix)
	id 93AE66B05B5; Thu,  5 Nov 2026 04:22:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9136F6B05B6; Thu,  5 Nov 2026 04:22:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802946B05B7; Thu,  5 Nov 2026 04:22:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 572B66B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:22:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E183EA095A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:49 +0000 (UTC)
X-FDA: 85400525658.13.B28FAB9
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 49A091C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dWqFK12f;
	spf=pass (imf18.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870566;
	b=USqYA/pe0nKXEV2Dvp/++OOFI3VLG6VTqkIlk5lwWcA2WBw9P2mLQEJ0XwQ7zlkHH6U1Qy
	rYZ2UVSyvoZorz8ZbHqTLBVyxMnGKRDA5/lSCWQOWjonYLQKF3RhT5MbIr/wdwbKL9fREY
	xDIggpE8k8lycx9bbt65y9Xere8bDYc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dWqFK12f;
	spf=pass (imf18.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhdlXR8A75L7YeWWJ2AV4SzYhiaJarkmp87eHXPOcrA=;
	b=1Xd4J9nixicuI5dMidScpdolJV7PRfWWCn2N3r4AOt9L/o6dD337nnFLKOBtnjwY477kST
	YdRTwHn4XNsm3RK7OaEQyzjUYJ8MhgegZZ9sKDxzZnPXMcK8Z36aUdH0ySrAx8IP/fl/Mx
	2aTrJt96V0HCnYpwIbXpNxZt+re6EQM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870562; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=mhdlXR8A75L7YeWWJ2AV4SzYhiaJarkmp87eHXPOcrA=;
	b=dWqFK12fcHdB0yrHOLTumnr9Z7mGN2nweqmXaVmcXSV/H5XJMvG+Dq6tz5OYfhpSWyZReGaWN2zGfPdmFsmxVKN22Wu95OhIAybNxhg/lQiTUo2OeAqZf+HYWTMass9ZhFrxzdFSF9GNfMa0l8ckpzaLIlT+qx5dIrG6gfrcITY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-1F_1793870560;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-1F_1793870560 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:41 +0800
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
Subject: [PATCH v4 RESEND 4/5] mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Thu,  5 Nov 2026 17:22:32 +0800
Message-ID: <20261105092233.3558950-5-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 964yasmguk9z7rx6d4afixajmus7qa36
X-Rspamd-Queue-Id: 49A091C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793870565-362454
X-HE-Meta: U2FsdGVkX1/pKEi3x0pZmEL2ZAU32PGOrrZnLxVwjpMuX9829Ld87uHtiaYRT/vhktn8wT7zthUUwXovdVVqWGg+6eSosIfo4cZ6yucVi7hCXWrzjuW38U45CfnN+3TVhyJgJaE6B3iwrE1+HhX3R/YH/Fs3vcMqOrHvtpfVmOQRuWHG6VTwgt8sLys2vHVOzayAgy3QRJW88dcXzmC5pghi8+pvWhrEyCydXA/k/awhNvrxSUt+kz6HIYKhOf802UIXIrvB4g/hSzXAJsprR51TUasCFPh6eSBg7/u9nMBZNul6Vusqvq6woZDZoev1ovistwvdc35398WssuNHnjSas/OZzShyzOkL74CowMS+id6Dxhdtp1a6FONL4xml7GCLTW9EwU38w4W0vfYE27DnCmaow/JDuzEy6d8nAh5x/CWKCRkheQIPHZVepsQPDbPceBL2LrEviC2HfewBhY2dYgV+T+zE8m+T/ItmP1YG3dyiFmYb6EYntiMWisKxXtrOSnMrCX+7OFD3TT85ZBgzMcEoFLsgzyu9rW0EUAqJrUpFGxFhqNPAdQ8wDvDqqKB3/jFWJeZ7I+QNqxqybxPH1dswgHhNZOFrbSwdAoG8yJXB5fDgx61uUqTq+pRtdjoHoaSYfr3FKWNBJnEfNuzhdug0CPBxp8iqPC0EgldOZiln/GXQIHl0atzF+Db3mUFUpCTo+yJPtlrmy762WytE4dNHpv75K3dfzn7AoxqQz1Nd2c1reoN2bais1Loqjb+1kvoOK9CHX7ztHptIe2/kFsgtxjQo1hqwv3b123hwgR7y27pT5sRpcIQyRXpzDLhU4EMZxpXrqaun6vqicJGgE2zlWJcXQlFwR4hlahS3AEwgCchJcbU0hJ6LAnNYMpmZXZFX295s0ZOCJIniMuWjlzxk97+lVBtsMWgWV+Z4NsbeNb2K7E2s9jrONsZHSkWVogNPstYZPv/xPA9
 Jnxb8940
 D3t+Fq/Pw9bujZqCGgNm3tetlSuexlZIIPaHtPyNdZ+ET6m3Ra+XJPyEch2bJzeTysswReYhyaYJmoK/sY8VQ3FaYraN/IH3DpYc+ZHkMoui2s60ATf2e9puyiV8U5yNd9GGAvq9zO1CiS9u13MjKf+19l55eaXglDaiELCetrP28Xx5dV58gLX6g7JzNH6+VgiSX5ZiS4/MPpGlOGsxnGhsEonxScX4EJ6c3oHrYbDOXpAyGl5xyeNEWU3Q48Lz4Eo6+dQxqDsEam6Pg4QkPgqGL4tRVqyiNG7NSKoNsPMjmY2aBLhXvBWVXCQ9NW/lzU7x8XmU+cKy46DI1GXzEmazZP4OhWVET9ug8GRUpmzYAQ8/uDrlOZO6L6WibJkDrMUJdM8yJNTUnY912yKta2K7ddukVDfIPf7KdQmBrFNDzIg4cbn6djTTuFAS357VgBlkdfuL7myEmbI5++dcVi28LNwdtPollIY9Z4syB1/hlxF2RVfoH2Rrrrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
flag set the shrinker would run twice per reclaim cycle.

NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so
the shrinker bit identifies the owning memcg again.  Restore the
flag.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers".

Link: https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
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
index a62d6592af7e..4ddbbdbfcc2d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1059,7 +1059,8 @@ int folio_memcg_alloc_deferred(struct folio *folio)
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


