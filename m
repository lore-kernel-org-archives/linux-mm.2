Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C7AC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAAD06B00AF; Mon,  7 Sep 2026 07:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82C56B00B0; Mon,  7 Sep 2026 07:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98C96B00B1; Mon,  7 Sep 2026 07:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 896F66B00AF
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:01:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CD321C002C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:27 +0000 (UTC)
X-FDA: 85186675014.08.0BFDBAC
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id F123B40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wJY5T8FT;
	spf=pass (imf17.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kTenwfhjwRZAsn2gE4kzIQoYtAxda9Qf9Jtbo1G+2k=;
	b=fYxikdzshHlQMPNw7simZgG2z1QioT5e/B5/ydNLzsIgyic3TYwSfgX2VXe+VgA3EX9zep
	sBP8PbY7Q2MVYLRZdyXhVnGEDtzEp7U9XWwnsGU+H38MPlvejRG1MPRSQE28VBe3l6YQ1h
	BO9m1x1EBYRGoKGQjK/3X1fHoQ0hOZs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wJY5T8FT;
	spf=pass (imf17.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778885;
	b=KrDpSuC02u3nmz+jN9xsBQr/zd9Fj36/F29GZhcTaaWizAABq1T1XQnrHi3fXG0NOTDoWa
	lymxDwkdXjm69zgpkMao5UP4viJt89gycz6M5qpmABrp0wHtWRd0RIVB4YGN4mKKx5GUzE
	cfdRLUxjNHqCrJiltWFXUCexpIGMScQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788778882; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=/kTenwfhjwRZAsn2gE4kzIQoYtAxda9Qf9Jtbo1G+2k=;
	b=wJY5T8FTg0WFaqoVnp4LoXV65gf9lviLlcMjIDiEoemAwcQRM2AZI1PpxiVZEGkTny3qp8O1wwCSpkXH1oM7b7cPmo25xGvGNLfCa9zDBkWYFcuB+ut72R8xqr4rgrk38kuQNzk2nIQ3Og0DrZ3xpI7HB+9HNdCQkErzNdDzQys=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XATsw.a_1788778880;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XATsw.a_1788778880 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 19:01:21 +0800
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
Subject: [PATCH v2 4/4] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Mon,  7 Sep 2026 19:01:11 +0800
Message-ID: <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a44j4gjd5rmhq8dkg78kbpoo7tdst85c
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F123B40002
X-Rspam-User: 
X-HE-Tag: 1788778884-658410
X-HE-Meta: U2FsdGVkX1+TsEeMGrf5QJHJ+gdQ7O60SG1xY37Ani22f1gOX5UW+yoWY1NjsFaYxKO8hc9T2rRvRr5TzCvyrLR/SqkHpBznVs+GlMjVboxZ/Dx1Ket205Wd4hVDgbrYUsEbuxOP7qYcmW7r1SOPdM1t6iuW5EKUIBIE0+jBdR+M+4F5XN2YEFQuV9UobKxt2BGQI0ijBq9yy3r3Sblx2JxLC5GEx3ubFaqMIooteTucNMX9G35dz/IlZvf3a/qizReoXtXZ/JhbxCRx9HFY1S6uW9KnHyqCz//HrCz9Y19aGWp65aHK6te3GN5yc/zB2AWjRoKnY946FmsSxAM4yx4UemVP6pb7U1xVEjs9Eoxeg+CizxTXDYeXRSpYINhzoOEEVz9pDwrhAsKQutwccRc/rVyt01xvW7EOmY/Fkty77huuS5Pk85xJeCtyHD+Xx+3tyF5An7sG2b7qk30xFJaSH3ro6giHOwEwR457WwQK3D6qQZQDSF8R1awL5IbeTZxdH+1+rKI5li1VZ1jwrqyU/o2sLVt3jxYjYwiB7w1A5o3Pk9+TcGO/8whHhX3EkZ8GNzbQYoCHgp/7HmIhL75t/nErMaBZHSaXgECqaMOrPeUpNyTUTL0aZl9mM3JoMRuahPYOSq/AqLC3LwwCMKPYl6SBK1Dp3QF6BfMN6m5XgVQ3BG06UFja4cpE/S27azpbD4eI50iOK+po4ndHvEEW2gqQNxTPrU3gONSE3avp92kKIhlZ+RiAwmCMVZF596G/yKMl/wgJvqjWzOO/qHbYpdSN26H9jwHb/IHyZY4WvrEH+qIbNyfYT7MIU1Sljo6AUz13NMDGUdZaaZU5rAAgzYrRoCNjwz6xtrXF/8T7xWrfk73abZxGD9fonWFqgJsKOS7b7QfPO00VUhpaWBGD7Ez0HE9f7TkBNDM7RS/YsuWplkr9LxGARBpLuyHATKFyUJiTeuQCs7I3aSZ
 uDEhI8OJ
 jkSg8A1GxdMI7LeMSNbSZnkfVJateG/xrQNWdPtRsQBh7qkBQR8s+G781JfwinGTXoKCjca8RcCDXSAwnpl9L3RKxLGy/5WducwAtb8u8WzqjICDR2fUUnXRZWimBVWTF2X40G9/efdRbDAACAPQivDrQQijnD1qzJCcTrfZKIqkvU07e0cgvIF+M4dp4tJPbs5KerMrmET/9a4dS16WK0Ag23ra1mOVK87JljrXxZGoN2l7DCPdNCmeh0aGhkgaBZzdfTnIuXU1omLPfFhxZDnR30X/A3aHLBwuDeyN/buMOmMWloAN43ecm7CNeQ1BRKxPYiNVpBIyKVak/QxqZf0gHytnVBztjhH37svFRG+UT8rJ7zbTNypaz1H5uMdGL6zD/mKpxR3/6QaN7Rx16EGyduTEJmtQP8HpW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim
never invokes the zswap shrinker: a cgroup under memory pressure does
not write back its own zswapped pages to make room; they are only
written back by global reclaim or once the global pool limit kicks in.

The zswap shrinker is registered memcg-aware but without
SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
before commit 03375203e1da ("mm: do not allocate shrinker info with
cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online()
check in shrink_slab_memcg(); since that commit it is demoted to
non-memcg-aware at registration.  But the zswap shrinker is not a slab
shrinker: it tracks zswap entries and resolves the owning memcg from
the folio's objcg, independent of kmem accounting.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers" [1].

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
under memcg reclaim with nokmem.

[1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/

Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f3ae3c81e48ea..032136942c172 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1252,8 +1252,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
-- 
2.43.7


