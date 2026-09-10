Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA28C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7456B0092; Thu, 10 Sep 2026 04:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1733D6B0095; Thu, 10 Sep 2026 04:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0586B0096; Thu, 10 Sep 2026 04:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC69B6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:07:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C3061A0496
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:34 +0000 (UTC)
X-FDA: 85197123228.07.5400DC4
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf07.hostedemail.com (Postfix) with ESMTP id D938340003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fxAKKe69;
	spf=pass (imf07.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789027652;
	b=oDwmByRuDEeixjJyIOr/BCL8rowHTzNOgeoIqPpNL++qSAgPZQrj6NrdQa6aVOqi2UzAvm
	9yMJAtxsyHIlg1/0X2iSVmPMuXgWjHMmd4Ki1x6TVsVOq18IOC6XcEuq7HEW3C+o2cr2oF
	+x8McOJV/irSdmtDc+pNhnTjZZv7A1w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fxAKKe69;
	spf=pass (imf07.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789027652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odM12/YIoq0YjT8DIJyO3FoSw5OF0hQ5pi5E6fmeHeU=;
	b=SlgTOrJuWlLV4WmVO3yjBhRBM+2ivJeBTyfSbJ7U4cGxjcjlrfzr+PIdTSpawoQU/OredF
	R62vxvMP+vTA/5rIOs2V0NdzL2aie6kDIXfyxPm6qok7ZvJNfywRK9aGMdsVqcsriAH03M
	bhTFN4XczWNrdlsM+ZTFGclXLZs/aGw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789027649; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=odM12/YIoq0YjT8DIJyO3FoSw5OF0hQ5pi5E6fmeHeU=;
	b=fxAKKe69JN2zdiStEMtZHOOg/Ag45wnWruUIrY5Rc21xv08a722Phby9wsMyytmhJusqgiea6v9DR4nfw9AVysTMfrHnmrgu62SAaqsB5KSyu7zEzTrspKk5tJR0pxrn4A872hPavUpPba8sK7TaTpXXn/mos/rq0aa63/DVGtU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAh0I.Y_1789027647;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAh0I.Y_1789027647 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 16:07:28 +0800
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
Subject: [PATCH v3 2/4] mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Thu, 10 Sep 2026 16:07:20 +0800
Message-ID: <20260910080722.3961351-3-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D938340003
X-Rspam-User: 
X-Stat-Signature: jdoj79iidcppcnngmwtq95fgjycw8rot
X-HE-Tag: 1789027651-714368
X-HE-Meta: U2FsdGVkX1/3dvfSODghBJ1dsjjMBDOOGoTqJovl3vlGXll4yKpaUJfinQFPsJFgXEuc04ihhl0p8mLDoAUihd8fONVzrHbw+pOTTLQP+G1BJkAAdA5QLJbnYVR4wf6ot697dTUIRd6e7vccE8nKcKuWeuWq7ut21sCge9x5CCrkS7UEV04D3x4mGLVQIF/TUXIINo8TkCYywsUClwp8uARtWAI+oawncd5KnjP4c/RaKzOdhntup6UFDKroHZRPTq96O3rfteH68YIfGXoxC8jhbWeIt9xddMNfiONOe+UpvckNVZ0YXL90Yuv4ABkWu1frm2XtL6x5grpK4alvMytZ28N9/KWg0d7doyibOANUfFASKb6+s79/bYv+5ymuu6aFSJ0Lvsq01EEk0YZGCSu+fDXDqNGbzEY2bBXHqV40C8c4tOBx5jnMXEWnDgMYr5gvZCw4NCpzUkJpOccb7TsmHO3GYbW9EBO5YNfHX229mvSiQ21zzf/byefcs0E1wj12MohJuy+0IoxeWUYIKrI81QPPYnPkRcwrzE1NLMDodx7f81CxuQ1yq6ksqp889ZIqyrSQbjglkDZ5UxK4qXWsb9pVOB5aAogSp+U5DXkM7QYn587KQUqGFT2SbHcS4p52LNoSSTh4PhWAhVYuAsZSOIO4EyS4g4UMwX+mWE8Flb3CrLCB4Ps587InytSqI8OsrQHPFRec0fl+4WfKZeqNQhewlm0ivOv1zNA79lZAymBBdAFPcVLprDiPVqvRlXGaIyKoX4C7+6QfAwwBi3oRT6eeXoCmBAy8sepsa8CWPPFhvI0PyoJmbvbRmMxyoEeT8a7Rd47HsLcADwzwWt0z/eaQKPNmAMzXdutTQqq1VL/ZeoyFwihQD5lxKfW7AZohR82N5Mu50BTCMjEBHr5qkVpbBEOQPC6xvavycPIyd8mWl1dNb8t90Lgqp0RZn3nGAIBMeWbbxKtJ4J2
 Y+vujpwm
 ArBEqUdn0YJf4sMv5Rv2FkaFJMq6kFoR2OeXVCqCnuvcHH1rerVgKdn/BrNnWKkb1MWDGkY7bWXqAhqUXu3ta0rNyfvYFfMLA5gM9tAkLe7trzMUBaSX6aSy/OnkSAN9cZkL1bXnr3nvUSIj73d1yV7GLJq4GSpokMIWENKhgAzeEZFq26Yt8ySmyUDK3lhDFdGZmPwZrBQPwAYXFyJ+MGBJ0Ejk5zkU8YVpX2d2bNYUhrjxZ8yyf3mLeyoo9bjRy6TED0SVP83YX7TndEsxSA6NNfruZ5f8W3/NvvGZ+SarvKCNjn5AZ+u7vb8K83gTBneK8YvNw4JGMzeKtTLk1U/LyFTDyW61cwnOuNi9wpaDVZoY=
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
index 9241d17de4388..d20faa6de6c02 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -672,7 +672,9 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
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


