Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC61606A695
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=s9dM19ug
Received: by kanga.kvack.org (Postfix)
	id D1B1B6B05B6; Mon, 23 Nov 2026 05:53:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DCD6B05B8; Mon, 23 Nov 2026 05:53:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C386B05B9; Mon, 23 Nov 2026 05:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FEC16B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:53:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 079A8140847
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:48 +0000 (UTC)
X-FDA: 85466073336.21.8F1C8E7
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D691120003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=s9dM19ug;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795431226;
	b=eDLw3mK5Jey3j86yo376VElpAu8rox2Q+tCLcF4kzf+s13sY6zl1kfqm6EmeDvnTGOdq29
	Rp2Cl2WkWdF8/kwpCqZFPIdepEkWxZrTGT9FwKAcQVnONreQw6DYr7HdEZgXhXQ0PC0J6W
	yv2P0nodN4y/OYrr66Qu+7zor2PQMzE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795431226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3phjBExbUr81r3vxQBKTbLo8eDTIjhtFVnpEcO61Fc=;
	b=2bkYHmG6tJXSYlHzv+8LL3bYlEk7bUtCp+IBFc2YsDl4H7hJDXKzzULyspW6cLlJ4CoSVV
	8TJXg/lvrjm/1piNpEakqPVlx6zy774QMApvye+iN2sk/volZ/Xk8ieZy5Xr1E2nOqORMB
	O2z5Debyz1A6QZvZ6Xehllbo7nkUT7o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=s9dM19ug;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795431222; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=A3phjBExbUr81r3vxQBKTbLo8eDTIjhtFVnpEcO61Fc=;
	b=s9dM19ug2Bj2OrxWhgSFyjzQ4ixaCnpLz96K+8OLUVuCYcKrJ7OSzInUbBswLPadFVwWKimhqX+opsaGBMES8IEb18HABWlsSIQa1ergsgC+jYYtvvU4U7/34AHUyHPm3hk+J/mVTB5HfziFr0r2EgXeRXZKHyo98iYhRDnbEkA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFHJh.3_1795431220;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFHJh.3_1795431220 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:53:41 +0800
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
Subject: [PATCH v5 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Mon, 23 Nov 2026 18:53:33 +0800
Message-ID: <20261123105334.2524066-4-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7jmiafotuf6cy85qmxk9s7dn5cpgpafr
X-Rspam-User:
X-Rspamd-Queue-Id: 8D691120003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795431225-229544
X-HE-Meta: U2FsdGVkX1/7eJiFHhXeByxPWD9Dkww9IkqXpsgcndc8sHI+TdMyKdbG3iiuw6GjpAbm8XG5x2nmY60H4QF9XC42c0pnC0oycYpul+pDaClpF/sENeiGLQ3MTdWWK+0EmJCRm/fRNlu3odXPZXeYOuHTC+sypH/BXTTWCHqh6PIua9ZbU63oQwhqW1kZur8SR8a0NhVP87l44DbEdnB7jgfYuQVVeyKamMuuey9E6LEbLuroSBJ87X4Ztas9HmYGY/92jHmuUAgG60mmh2DfMXB0adsWHcpr6iLVs8Z4/ROpWhkoMXDCVxtNcO/shuepe3iySf4WaypPY6/ONu/76NL1XFufN3jwaUexyEVrWNZxG65IgYpItjbEQmO1VkPM2tKWhGVaT/XywtigE9cXy70jDEM3y2OD1h/rs9pE2QBP+OXB4R/Pj0+6sWHwMBZUAsZvSiTUEcbbky97GZKFqt2bi7H6suPAfl/+gQHn3xRQ69gHtN6C9W1TTG2ahE8jqF8RDkBKuJ826NgVxHQ+74xA4SxGx2w666DGhiL319GXVoFgWyym2FWstgLnQnzcbdI0q8OWI8C+SsoE7ciNHv4FRxJbiEiW4OSVoxso6EBHmP+/aW3k3PfH1i8IKMGLrsXfP0LxZFFany/ZM8Gup9jXa8hIpw6PRyg1ynQaGPtdceSp7JitAWjx03XNkbpzJRcVgcOPD2vRKu/mpSx64hbARSReSgHIF9WyL6xfiQNW9WSgbKIWW+xrCDbcVk309noBdLKccV5e1xz9HdRsm7zkqLr/TYABA3pw30TxPwyghWR+7aGPDJahRaLmMfq9YnMwGcLqwETzzp7LwcGzg9itIPs0FfXj2Gf1PWVHi5zKl2rDWex3eSBUqnCCjbCuD/Y/Bt2p0F7d6qH0fx+uwk8V67gWcgcbO08vkGr5c5roDRfHP9enPcjGAhie3UBL7JWUwtq+GEjtkugETIr
 pF8y2ix1
 HRtn4HhP5GvWhvR/6eBByjv37Ol0cb9IpTVftOZLzs8o8W8NMhVixs3yU1mppIlfI+Nvxl8ReKiYBcI+Opg4RJfQn6/Q8On2Zfp1sjpUBNjDdPubOt4ZCEsyv+LObdfm6E5Es9+LQYFzLJ0beDPv0km1sk4jwtzKeKCwQZWKC9hh2Iob69gGsryxRku7IlzBGgY+6gR10Q365tSJ8QPR6Nz14SQ8aa1Y16hxWneZeMjpf2sxEIqG2sZS4lEScTtOhGQmWO3b44Ut0Un428/N65hkYz9z0K9G3aT1JvXQZU1tmZx4p/NcUU9M4F6PamPbX4DFQl7o5bpCvZM8VjBFlG7CJNzZPJjg4b7WJgh9B9Rn+bz0gdzBKHPKI6JbNdNH+xYyQaPcS1oe+rSaKl0G//eIgx8nvv0WqhAg47vHek0W4f0L0iGqOG37CEdiuSgVE9yOxVjmOneKu0aGQsjG8Pt8Me5XQP7s5vreFBaVIq81T6b/1BdWoStTkx13XyfR1FUHKdYnouPwP8+63MGyLpcbBsREKQzLsMwHBzB8+PfGE4TBSXPJ+Lzfug8f8vbIKyRu+r63Ku0bIR5rUwlaXPNb0/nSEYdbDuv3X9Sh/kONhoEh53Q473cOmNreigPUbqREkj+xEwpQViJc=
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
index 75e8641bf9ff..0f1714b10614 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1058,7 +1058,8 @@ int folio_memcg_alloc_deferred(struct folio *folio)
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
2.55.0


