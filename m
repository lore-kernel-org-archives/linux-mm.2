Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C16C606A685
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=USga5qsi
Received: by kanga.kvack.org (Postfix)
	id 9914B6B05B8; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FAB86B05B9; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D336B05BA; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1436B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1CCCC0864
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:48 +0000 (UTC)
X-FDA: 85466073336.16.F99945A
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8B394140002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=USga5qsi;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795431227;
	b=RIMbjM/iz/T/N2+pZ6GJPeUpwSBndboV/aeoN6RZzzigZGtl/7Sjxi/u2D9iNDnSnWeqXk
	y45vuJsFS2Shjv15mpuzBrFY2srfQ6DeUCNKOB42ofHTQ7970UB9d6mL2WGFxqW1U3C3pK
	w6wqJjnwsjzaX0+l566EPdEiSFP0IXg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795431227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eweSWDSOsQOE27RcEvRysjLv1HR4X1mxM7SMOMd00P0=;
	b=KCfusiJ0ZGViCk2pQZMr0PmFktCn80L8Yr0jwzvNS0exTnqIF0TT6PT7Lvx5xvWzQHX6+P
	fKwApGJg3jlYKYx6JoOU4AuBn/55gA2U2IECrh4Mh6zo5aCTPEXHqv+RuwwGBZner4xwdS
	6jDTwsgucnJi6rEkNIJuLPzMXSkEHlE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=USga5qsi;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795431224; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=eweSWDSOsQOE27RcEvRysjLv1HR4X1mxM7SMOMd00P0=;
	b=USga5qsirAS3HY/LkQVWy4O1wshw1s7nJFqjIp3l25JoGtJGiUvbv5M39hjoAc+tpYIXZCBeYxFORXG0ye1OZ4KwZ5ZXCVjmESk632bIqMbm37U2AZofdTV/NuVuFfFLqQX1bSKIsqrfXrveMUvzaTY7r0/yQI34r/2rggqoASk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFHJh.Q_1795431222;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFHJh.Q_1795431222 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:53:42 +0800
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
Subject: [PATCH v5 4/4] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Mon, 23 Nov 2026 18:53:34 +0800
Message-ID: <20261123105334.2524066-5-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8B394140002
X-Stat-Signature: k1498cw6u6zoy46r4z38uzzpmb38jcfx
X-HE-Tag: 1795431226-820118
X-HE-Meta: U2FsdGVkX19yqLczd5SaoGQqVCW6Y11lrB2eB6uHWcKnq3o5pKapoZJlhd6UmNwNt+aTDSK/19pKfgfDsS6E8+XX9t+ayMhJpuCZgft9msyAt2ByOt+Ys/+CF1g174efuDNEMzZz9pcjhdEt0GXuXj5wIQAVlpQSr9OixMkeWPGJlr0qKyLGa54vPIsxlzjrDwuOhS8OhE5yqz5XYU4UYH2h5TnZdy57J5Aa3RilIzWqnUlZ15CbtKteWaHJLQBX7BUT59vecRAlemTw8xOP3aYgU3BXd5jlJbzax6+PZq5fFPxurDYxq95t+SFUHfEfYVZhWOxrhSk4y/r3kT0jisNJDVw1oU0iBLtOU6/VOcuIfjJH1hTH5yrOnLIvIfF3mGRpDm3Aebms1vokP4NXfyEQiJmzftV04fPQ/Wi2RuwDCq0GOot7UXy03a1ILmiBqHsuGXS1fmyMb3FWRCiPJdYctXJyb7Av8ms+f2ooAk7iynFRSjQ4COYaFO/9OmiGR4f4CoOTjdhXrFymS97HjyofYRW/om/StoRymYdKIvE8v1hOgngS8bBdlTuLihcJUWq6/tgtIRcw3jQCYy4dY3H9RAoboCRwU3oNo7C7a2pROreUiz8lP3ZEJPnYa97KutlvGjyaSEkj5F3iK7H/6g3LfKkUTBmTNB6jzNO3HAWJZU+y6QwvITvt9VmC86c7o1XUhzjpd6m0zi7xGaSValL52LGXpqoYR3xD06IEFZtrACoJ7f6oqrTYwBkIN7Na1jQyeKDTvo7aYc2gH1aniI/4rJO5Oi+OcWvBDQH6GNB5nMfzB2u0FCmebJif79AdXFwJYG0e3SN3t8Bj7CDSC07BBa3DB1vSmiUKRvHB/Lzbudj/P5YxHs+N9SfvP6yJKf+buYzmm7DZzGNKGOc25Taky8vrNLy7QbxyjeY/+KowhxZdhtkAS78OhEd79/1S5ROBfmnuVp3d8Ibxr5h
 KBafjWfa
 p5YSFfncmOu6KXm52XULRbcdjBhLkUAQw6OZ4Gmyt1G9udmuWCBAFbA0+bXXMlwnTT4U3z1x/F73iIQ/aKNFdeV2pyeMKRJh/jAFwEkSYHD6NY22Uj8Mg/CcQ3r1riml1eCHURlsMyxJYkMRnw0kRQlL4kq9eEetwo/zCxApM1dObGBy/3e89R8P0+pUdhXfRq1i6dIxe1gPapRFGSkDIZQjBLTeM8mrdNqgzUyOeONniHddzsB4h0o1I7GokFtO5hZhsNp+DJEJst5sxplI4jPUEVsvnSbyRCuAa0qgJ7rZcKoGJB/iu5+9abKlWwH0Jh2puBWpnK4gehbdO+oy3yA0b8EeJ1yQnQmmxzAvpi6Y7F3EFM9vHJgwXFJnGoA6ztKfIGGTjBARiJlCZ0xXhVrp/SVSTkVgyQWeA1nZCqCE0wNbYIfAx6TPkhKCbXCB4NtXoiB/Cr2M7KUCbbGOT9a9gsV2hhZx5o0xcvv2sbX2GiOKlqiJYnpSOIliM+UOBz9kS8KdVgevB+Ud1ywd2nPdeupJPBXHU8lMHcIAr0bxvzo8CYPTh/v798RwP7CDe+6n4Y64zsZFEePNe2OIfpNl3ln4+y+2nJcCR0RGwlnD3U/zMrsQXoRg4caW28sWvQMZL9gmXqlMJAOs=
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
index a2e0314db1cf..730ddf6f5005 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1379,8 +1379,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
-- 
2.55.0


