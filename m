Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD956CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA8D6B0092; Mon, 12 Oct 2026 23:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527B46B0095; Mon, 12 Oct 2026 23:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9286B0096; Mon, 12 Oct 2026 23:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EED86B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:12:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 849A440A8C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:12:34 +0000 (UTC)
X-FDA: 85316130228.05.2991048
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62B70120008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:12:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=s0UbLUwR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791861152;
	b=c2NZT1amt/BQIgtC6ncAN+CD93cKcGds9tCWNaXQs0MAf5Iu5YQvjlf9Ef8k1ftjO56xGP
	GKzrM/a3zP7jULyWJlzBwDyt5xihNVQW0FyeAEp5CFI4cZltW+9YNMYQ8OLOrwWAtnUpxH
	NSH6C6z9BujITrXuk/zw64pR6zNCFXo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=s0UbLUwR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791861152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goZgGhsuDnXRMkG633Mg/AsrAm2B4reGrlV8Qh0TTu0=;
	b=O3V2z7u2/BfEH1FSfoyl072Si4qdqfDhG0sFd6P9RUfCDpPelt5l5Wy+z2882L/tpQFy2y
	yqoIM7EhM8CjVkZ+u3MZj6xfrCmzM6upJRFavtL3RMe+/wR0x7ouz/3yfxLsPHm7EW1/K1
	EEed+66U+puBaZ7d7MS96BkZszMn0Cc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791861149; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=goZgGhsuDnXRMkG633Mg/AsrAm2B4reGrlV8Qh0TTu0=;
	b=s0UbLUwReCj5N12USaGFhCx1XUzmr29LLv8/Si5yIgVM/BbvY4wby33bcvS6gZInSNq7gV3t6XdhWbn4wNozQKf3t3E02fjc3H2dAwvH4uC5ZZLO1LrxXDmCMtKddF/zecHYtWUyZ0fub+ygaYkaxaFDlTZW4/ZMZf9YSz1SfYU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XCkEjdM_1791861147;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCkEjdM_1791861147 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 11:12:28 +0800
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
Subject: [PATCH v4 3/5] mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Tue, 13 Oct 2026 11:12:19 +0800
Message-ID: <20261013031221.1997194-4-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u5sgfdaugu8sk981j5jiqud43imqzaun
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 62B70120008
X-HE-Tag: 1791861151-773991
X-HE-Meta: U2FsdGVkX18BjVNZea2u3srNdJL2mm/iSqdSujPtopUUqTNJ3q1hnhMlFn9uaD1bs9P1OcMVENqZv1k2b6DjXkbtEMcmu0FzLjJKkWldwIlljZ2LgmY640HTGxDD08EGprI37b+YNVMvu5KQQnrrWIdXloaSovb/wZaXoDEmcVh92MsfdqATOnLZBGI7zipeNoyqIKF+ai7moK1NukTlKggCtx78M9SrmRG/CmRixq9MSManRZJmnmlym6woxpoxWsI0Z9WxjH9955xxqjthai2c6VY7b2JVwXuo2rXoz0m/RtHebC+HxOdM9QCZgEMAXhvzZv8037O4p2NmM6zYENQaFOnuc/DuAFLAQnLVTQjBsaVPzsAkn2Ic84Gk7TC2rPW2flBbRVf/9g1VmAgZpstF8p2yLVHz1oqxZrDmSmaWFMgfM1ZTC++w+VPxT1EaknRJBMfnqp5fr79bjYNgq+06NgG3ZFAeJSd72W4w85BCPBUaj4i5vgepEWbToSQUBxMm+cgSRk2q8hjseey9QKc+n+mVVhqtAE1NMpQp4UHemOMwF5CwFxMwcj2vJ2PAJuRI6da0b3PRVGLmuLxivKLB+g0x03xc/Dk3kk1mkNwdCQIa3wEV1bET2SsO1VlQHa4Ae5+wd6kP7zL4RObx2HMivssCgH7707RXkux2Rr1/iNuG8ljI0uZglyAkhufW1QRu5ixfhlpuywRaUcW/yPR1zpZIRfiaqrrGUco3zINlmp73XFVxB6NPolxOu87QXOZlfIh/IQ6YcEehIdNcjmUdRTwbRR3nhk25zvdJFJIe8gevPkESG/Wn1O1EhhZPIu7tGqjMd97d4yisx00PSdN1DBQAt9PpH3rJCWOKUY8gFsXMvvQL1x9r+vud6ULG5BPFqZr8Lq620zG+OGwMh67JrUE1Ko44yRQloQrfv8tQ/4bKeepS7h9IcojIVzh+ObRbNa7S0Lf4vSRzD1w
 y7LCFhUF
 LOr98ljtq8Q8LkLAroaONqwgw0V0/7KzWp9UDKWGF0OJsQm0Vdw9bK4ZgrCLPWAew4evtsZ5A+1VKFcvOhT7n3d3uqBoGQPzN5jh+Wabl2IV98gqJNwNEzYXnVNGN8VrGeFidnugQpcNAgOJZuGgu22DpUzltaoX7sfK2A3Bcwz7ZAK1sdmLNAif0G1+357ln22L211cQkSjPpxCFhxhgNfxVRmTJklTA8Y1BLijW8Dg6CzNEUh5ksepR/CrvjSixofQQf8t2hUWI1bGyvWlciKgs5HNW+Ej9RLdy2W2DiXYbV03eEPSLKa5R9ly8KSXHU6CD6mZo0KUoWcewZtmuAB2sNSHUo+L2rQwEqes0RT2EhQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


