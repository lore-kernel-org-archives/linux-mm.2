Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFD2C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A241B6B00AD; Mon,  7 Sep 2026 07:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4356B00AE; Mon,  7 Sep 2026 07:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3EF6B00AF; Mon,  7 Sep 2026 07:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DBE66B00AD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:01:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 079EE1C002C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:25 +0000 (UTC)
X-FDA: 85186674930.15.AAE1300
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5A4024000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=T1V3IUr5;
	spf=pass (imf11.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778883;
	b=VXe6sAmIPbcIXc7pL+wceoIC1qWA7ktZKjITEVQ7Dq83o1oGJ/wBPRorPWf5mwHxsdHEID
	vCmuVA3SiIIKa4HoqMBdQwpXljn/aPXbH9NYEFrIupjbyrttv8G0tNSxZRYHdBX4sxu82d
	J7dqd42BHXpKAtWcNdPvYFEX3taXdjA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=T1V3IUr5;
	spf=pass (imf11.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwR9RFSxdLQeFFx4l5snm8ZYfxhsC29aBhmlxjFMRxc=;
	b=4sXGVNDQl4033xKb7F0au/MQDQwsawpfoVge7CQXrSryRoC3LqL3TShmyM+uD5it8IklhQ
	xymZkRzdJf5IdLfjlwDC/c4V/XA6uDcEdP9CcKclXE8qnBfQcgrt2J41PdIFtjya6t5SJv
	hoa80lyXcri9vhQSklIXhR/oBH4sCqk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788778878; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=wwR9RFSxdLQeFFx4l5snm8ZYfxhsC29aBhmlxjFMRxc=;
	b=T1V3IUr56y9iSd2OCzZtj0VQwc/lpA8x1oXv+yGXyOVoi7pX5LKSjGdLuBRmD++TWT1Ns7GpQ/sWOb33jfB71fxGzuAMxNwX77+IY3zUajFm0j01eJpCEvitgTiyev5hLV+5SGCn/A+98OVk7ch7bP1EQrzBI3fBy69OXkOdsUQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XATsw-l_1788778876;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XATsw-l_1788778876 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 19:01:17 +0800
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
Subject: [PATCH v2 2/4] mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Mon,  7 Sep 2026 19:01:09 +0800
Message-ID: <20260907110111.2286932-3-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5A4024000A
X-Stat-Signature: 9abi51rcsu9ggjw6nwns4uk3pzj9qagp
X-Rspam-User: 
X-HE-Tag: 1788778881-89842
X-HE-Meta: U2FsdGVkX1/bo7R0W5uka7op5auFRUxThO9BydI8j7jnUvQcVTBjYxah41tcUkJSkBPOcZIsjlYfGXvNS9k1Xz36jgQoicJ6V8nP+fbuZtLX4REeMzo4DZrMRb9cv+UUHB2/P0+uknchG9R6qfUW46kJOwBHuXjTXQMLi26kCwQK4XUzbc97/+2r5vBUk+ouOJnO2lYUQkuhZAVBiyBlK73OOUwT1HBLS0QmCSxbTRHYbdYbEJfYHtH3u9rmJHLM6sg673llaZOyBnQ36HlIa5h6C16PjLlqG+3RwIQ7OaZyCoA0DXMAiYh6KX4JDO9bdmafYZq9WBCy/2iQRx7C6fOGoZhYYhTqnnK/iQc8s80DQpwWt81YjBesqKSZmXQoxGC51RGY90PW617s9hHPsLzIzk4Ly9R7DK7NgxXgQkIS+EFVdaootuZG1T1KgeEcObV4zNimaiFDHr/mjaN+/bnaTIuRV30QI5HOVKEhSGvcwsZfxzNAVMF3uOl+fEKq9txfXUETO/rHEosXyn1ATyDPO2Cn7ihCHQAE1tB4AquYpJvt7dLPKTAconO1K5EQMt0G/OcoNxRGOropmpRZ7blLNlZcW29j80aEclyJbA1e7jC6rlbziRfpF/ivE4ofpZXf6+xJQybw+uJ/QLOV36oTIPo6rDpH3JkH6y/A23IoUMc8Nzev6gWjpsmvM5RapPqgvxeVNmV6vXimQtziuSn7I95XtfjFjx64FsY6e0/tc5fs8CCBroU2eqA+H/13LZxWxJLfXXYE+d0fGYQ0KK/4nwrgphW8NR3P1AV5CSYZkxhFMrmfgjdMktM5tmuWcSKPMJTKrik9hJ0UJQGO4feFttIJ24JFvwexUVg+GaWjaIpPfX0cuuFK0Q70JcEIOHYUOA+fmOQoZX1cHm/6jAk1gfSTviwCCBfR/LmW22gDQjpcNgfLSjWJDK76nGyfNh40RZoSO9Ld+CYydVK
 gJRC9J4V
 fSRr63H0MNWr0Ytdxzzbc8ME7dXq5CVx0IG+DXWR8U9F2DiBC/2oD6DEBCg7KFj2GDs3Sa5znIBehDENkJzzrZsBGhEvO3fR+WgMelJNato9cdW4y0ObokBIF1MGIi72p1L4SsO2hRIa4wkYBokgKwVjVnvul8KcMFRVkirdNGPkFU8EZLGzTWdX7mOEZebeUHr8epe0YCKBjRzo6I3e2SGEr1LwKYmCRRFGT6I6/ug9g1XxODkM6PHH24srfQYM4EXcR2WZBZbAxMDWjeCKPdH2D4V6Vg9+/lTCSu9D1PqVO76E=
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
---
 mm/list_lru.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 6fd4e9af84396..e84eff313a683 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -671,7 +671,9 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
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


