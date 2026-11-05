Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424B8606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Vj3dQbbD
Received: by kanga.kvack.org (Postfix)
	id D328F6B05B6; Thu,  5 Nov 2026 04:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A7D6B05B7; Thu,  5 Nov 2026 04:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBE66B05B8; Thu,  5 Nov 2026 04:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9896C6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:22:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F36024099D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:49 +0000 (UTC)
X-FDA: 85400525658.18.908AB89
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf29.hostedemail.com (Postfix) with ESMTP id CCBE0120005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Vj3dQbbD;
	spf=pass (imf29.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpf5QsizXx9EkATcGnWqX+gyIM8QWqLtiyYMZfErVsY=;
	b=nLn+cEAwpbnuzFouhQx1Ko6aSO5bPp4uNy2353e3SMp3vDrp+/aZJp9HzZeBQhdiTAwNw1
	MYDGLWCNgyj8HTTgBH9rQvnoiveTvK451UHt09LOYxe6EsNb4Tck6D9u/U+3Wujxco55Lx
	Y9b6yqgItAh/hlDpA9AAmvsHtxw7A54=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Vj3dQbbD;
	spf=pass (imf29.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870568;
	b=uCUBgiWKOm3OWM8B+m3RR9fR5WmIAnFFxWu8Qgi1Oa5NrQP6BhdlIcgaLcJCIpbdDjm3aw
	rb88n8kjaIig4hVsek1jNE/PSUUG58Wm9gAySbvgWDrhz0G+ibf2+2/bC+Hb97UMROmAsf
	9nIuQICipYLSwIP2rU5wiKMbgzoHUtg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870565; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=zpf5QsizXx9EkATcGnWqX+gyIM8QWqLtiyYMZfErVsY=;
	b=Vj3dQbbD0jPo9FrVjHeGVZrINhrPCajOk3jn0zta9nE5c+F2yvzL/ArLSIQApsOaVJiY5p7+1RXzVWl4S9PuCeyqjLy0fBgyzx6vP2qxO98uZRdojOZBUVoBiTJUgybQAb5BbGfxOGVeN4HptS8NP26nAYMliW5Z03QH0CKctDo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-1w_1793870562;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-1w_1793870562 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:43 +0800
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
Subject: [PATCH v4 RESEND 5/5] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Thu,  5 Nov 2026 17:22:33 +0800
Message-ID: <20261105092233.3558950-6-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wt5e73gjfiai5gq3ja8yy7njb4qh1xfu
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CCBE0120005
X-HE-Tag: 1793870566-460311
X-HE-Meta: U2FsdGVkX190dDIV35e3tyfOPHavrka+A7AHR3h1cl0DEBydISLJKr73CqDEFkrUtbLK08rTp57th1+vFwB2WaSMMy2aAM2FJimfdsZ6tL76FDR8pOYpaT+c6Zn9ezSHs403/i6yhH28IPwgYVuRVxZkygZHAuy+RfhzONM+yLm3u+x7tAX7kOZ9rL0rzHC4Z76SSglOE5B8UNsWPYbQjH0EpOlnpK8TWJW+pPTXpmzZayYR22AeV7YuLu35bJKeVn7TAYESG/kXBMHTGLXNw3IUZLN/FHDK6OquM2A9x0BUglH0SNlGSHY6a6os35QP8xaKNq/kGyZKYOI+Rgvhk2+Ibtf9uuPSKp9JicpLcNgS402WpvPcFIrRRGC5gWB0ghZ9KFWEpKpfnJXP+pdfoyoACjCEd/D7J+BG6OlNDF7Kj17HKevUmL6M03OwVpzSNZFVJmbzzmneglga8SlrEfMkwkPX35BW8v3wDlEjkmsdf4YJbhJucfNulM1Re5qN83viw9V+ZH/wXyT6lpxH8kYSoPon+IjdtWpv0Oa5aRQlJKLsP1GU91u9qJjsKq8SmVOmxrkIt2F7drFOVcaAG/Pdf4SaDVsBK113hQRFuqJwUkdstkk0WTigK9BdpFiCe7jO7pABoXls8tEpUBO78f3acLyuvdq8dMfL6r5goiEfz0qY9muU8ZS68IP8xjOaF+zZ9R2cJh9ScS891qoZbwGoT0fH4tuHTYXGRIKORfWzVibjqRmSZ2nuBHVX1jsw6mFYcnZg3ZBwDizDoDIUb8PtTB9z3jeSlnh3ysf3zsJNS7KoMOm5Xk8FOgS+yVYGFsOszeZiVNV08qYfURW4XdQ3/0I/LRyt//V7IV6zP2V9+CzVfrYasWopHR87F67iVAGDodZoYAYEKJi9PDsDu0m/lXOa2r/zrIi30RKesvm4hozbENpxdrXiXG9gSUOhIcJ0l86DNJgBdcZgE33
 vaxtGlHX
 RtcR4uf39OD9bAJqgXUDCfPFE+P+1+3QYl6MOjLbJOQ0AT+YntvWaK6FzBtZRd4lxxG5S+yrZ8uF32rlrDaenLqCl8Z8IAPhBmovugR0ELgQlKohIaUtyYaJnWd9hUu//4Qci+izNKbGTyFdJ7WQorcuXuVjMH1ZnrBIllC/ALdkwvk2fiPc0zSbfofjN2ka0K7B6ucz+ROfQzLyiUjF+Z6r0Ea8Z2UceOJztoOiq6Sr8UNqtVi4HYXeAw6AEFZXhZ8O20je2WZZvJ/adhLbvlcbUumjC0HRBZgdmUw1GAFYb+OqxvuTwXm1aD5mpfics/jtawtLqc7ufvxQlY5Bm8JZo+s46WsvrnFN00585JN8nqm7icMbU2aqhLqRLchPYdRYrRHJeM+EhEsMbZKCl2UK78tdfMJNWYrJAWvEjeVVqYPAr8siQ50ptxKbQrrlmOduLtDH6IlDhB6Nmvz5aDNUwoARauVGf1V7RXyPx4MPByCSf6rl+yoC1YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
don't copy stale shrinker id from non-memcg-aware shrinkers".

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
under memcg reclaim with nokmem.

Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 572075bb1c1c..382ed1fb2847 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1348,8 +1348,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
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


