Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CBC606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dRSiifnu
Received: by kanga.kvack.org (Postfix)
	id 0A7C86B05BB; Mon, 23 Nov 2026 05:53:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0F06B05BA; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14066B05B9; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0106B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 249C3A08A1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:49 +0000 (UTC)
X-FDA: 85466073378.06.D025392
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8343414000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dRSiifnu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795431225;
	b=YlGKQOEUktJIMiMf3zPWVVB6xuDI5fsw9KUhRo8IcKOovrZKcIoENBjrkIGtkqxW6hCFlw
	8LujdZVFSYFgYP9f0ri2Az7HPyrzs5ngn7pjXd9ptHJXjp2dJYWsH8EoLxlenYmrzvKgbH
	MG7LRkdrLzqzxNFEpDcqrb2NX6Yrr3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795431225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9L6jvOwGrAP6YCaPZASj/kNscePV1aVd/8CkGJVXlI=;
	b=jUvhJhNXIQ7nr3UXeqXbHd2YuMSgRKoJrvrOaVV7fcvBfnYitILxKVIKUhMV2QOLuvGXEx
	FAzSbT+5H2s9715NH0GEWf8sPgDzrAJhZDQKNs3TTu+EXiJZvAb2UkWB/FXKXJT9gdedm6
	mLhdSN5f+9OKG423TZ7tMWbTjVWXZ8w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dRSiifnu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795431221; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=c9L6jvOwGrAP6YCaPZASj/kNscePV1aVd/8CkGJVXlI=;
	b=dRSiifnutECFeYiDF25cvuXZLTnVN7a4PMZglPNUWw/epIsmobsfNNCiaEs5tyXj8fnkeDq6aQC7lnuXYUpoKTKyEt0oYudP1ashsdifwsy+SKS+ZTCIaYEw1Lde7mteEV6iIBLpeSOCMxQ1vNEk0tYYA/DcYcqFal3sp54pMeM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFHJh-e_1795431219;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFHJh-e_1795431219 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:53:40 +0800
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
Subject: [PATCH v5 2/4] mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Mon, 23 Nov 2026 18:53:32 +0800
Message-ID: <20261123105334.2524066-3-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uf8hjgaft8amdwr5qed9bck6kt4tdt9n
X-Rspam-User:
X-Rspamd-Queue-Id: 8343414000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795431224-309474
X-HE-Meta: U2FsdGVkX1+IXSnZI/YIuiCsrCNUmIizCm7E1lz48ZrLZJi+FAGniA1HL40vrzbSWoSHtl2kfy+LgQUWMrqpMYVfG8et9MTbT0eJTwuUBg0sPeW93maDJAbrJEkkZ0u73ziiaT6ViphRFtya8TsPGkBbNYfi6jiA62Nhe61IXCOQQYDzCkAMiFVGCOesiaIlCHD1T48MN6gQdW0/BXAE+ikZI63yzdXMYn30EnBFlrIQ7hUDJa8fVYXbBFWcCVQqsJC4padAnQxjbHKKp06rg4CcF+zbL4XRxT9nYdAFHhbadRu5LMTuCInmKlUOWkWrWCvkQdXXvO60Zv/9BTWoxTr9MnkXEY9NWaW7Anm2aeJk16AKypGphCL8iKylMFmKjsiZZibOm/LP1KvK6QewaFPC0mYApx860WB0wo/CRJnnyvIMTgP4exV4LaaICIM9ABBcmw5iJUztzL55PrgNHj2zZ3UDN7zdTkekPcIpY1rQbS/TcZY5kavRJ6VdEWpc6G9A5XE+Qx+3WaT+D8Uq4gTl0mBPY8kdPlR5rsnE2b8PT5FosoKEhM4U0jeoeSffz3P9qoL2hyLrlrEhRYwLZtEmsTB3LHY45podWTeCt4saO3MARtS2fgULJpF1fcbPznT/pniKkNr/tzKoCHxRKuUhgR2zLBQgD+x31Tj2fj10ldF7IjJB9Q7+2SCcaPd/17YRnBEc4FnNFobNaCxDWC2NKYCoAhIBFebvzuhwR/rhacrXGSnzTfTQ9Xj/sGiQWGW2QTe/RpmCvdbTH9CRFHNb9d7tqqSyR2sbUe8gUmcTmwXvWlraf1/jcw+kha/yibpwHxaw6JFgqp8Mj70sIKLZN36oFh1fBrEECerG/yLS4bzbeWC6NDL6GbYItUAJyBcowhNByahIQeil9VWJKE6pooU6joKXbNptY6qskejHlELOB7Cgx5Z1YVNaiYlWSB2jM/0DbZeem5R0qxz
 8Hdk7C9u
 t9sbARldXt0HUHzrvJa03f2ostWT+LmdzXgLrkc2x00Iyu6lyLVXDWuC+trWCrJUgHFnOLRYjKNKsme3OmXvX64c8Y2UlrMAZKMu2alFlJpKiNhuVQpI2Qp9IlS2KdMUsWXq6y4yFvu1sWI8utJpsGJL/XBYYrgSwr7eAKbdrsXqxUmf4OlxUNtN93Qm77YPn0uEOrGs8fjb4otK0vtLf4bFbO84v2u/6Ih5Vc5RbDaOiyRidUT3xpGRzThIQ/nEhT6sPdwruAHcd0mzCPfsDYYCqie87UUk707qa0r0wS70gvDxnwyVAzV0rBdqJqIxsELbtiJRiAZVxEd1qONar3UwFN54AYCf6BH/qlDcOfZ0iBpjSs858GY+PJCKlKh+DECcJRHYZ5hi1ARLZvafZenIEhLBN089z7ZUxOKDRqXmcHXmVs43UbBYFtmoOXbiWvQyILugi4ZF2HKolroGQooTu2OJI7XfMAmpe8u2cfI8u4tapk7bMbjIb8GYerDyVT+3x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index b4c879d7ba01..78ca07bbc3a3 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -712,7 +712,9 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() ||
+	    (mem_cgroup_kmem_disabled() &&
+	     (!shrinker || !(shrinker->flags & SHRINKER_NONSLAB))))
 		memcg_aware = false;
 #endif
 
-- 
2.55.0


