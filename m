Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3901F3D5EA
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 04:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2768E6B0098; Sun, 29 Mar 2026 00:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163E26B009B; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86B86B009D; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A12BA6B009B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 492E1140387
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:39:08 +0000 (UTC)
X-FDA: 84597845976.27.2E047F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A28674000B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:39:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XChBkQOo;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774759146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2ge1nGUitjlU1VPlTZlLswDTMb2yC9Uxj7K60QX6xw=;
	b=M9T+PFxJu0OHrWxRpY0uaYgH8RVLqmtfelNwWfqvCnWocwBIK/LJbhZvv+mEf5qazxg3J4
	8e+nzj14TWt1vzZKK5PhGWJFpqu/oE+98UOobcYnkimSQXIP2bnia14RJNx7lFjoHTCniA
	jpDm2uZ0l7lGz3DLwSH1XGk9RwLzqoE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XChBkQOo;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774759146; a=rsa-sha256;
	cv=none;
	b=LlLIZM+KKQonoT9iilRM3sanY6GQ9MyytgcIsFMuqzFAKigml6SvyS1828GNsXXaUyOQya
	wvPjeozYvwhtZ7Hz76QKqv7OPjVxQCuSxmyx+KanpAthrFSYMR+4p+YJyheTPfMk03LOKC
	HMd0zLq8cn252/U7I+x6utprJGO3Iv8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C59D943D89;
	Sun, 29 Mar 2026 04:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF28C2BCB3;
	Sun, 29 Mar 2026 04:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774759145;
	bh=ttX/WBJeOO5bV2yGUUqpXlkbrsRo8Ww/CGazpxwYkZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XChBkQOonLLysPpNeMwNXE8rqDIpdxSGiWEmDkwSQvYrS1hRMVTt+XXymvGrq7JcL
	 1gmDVKLtsPesEATjEVqiTBB+zZxj1BLcvV3bPYR+BydOIUIRXH72D5pdRBwd6zm7Ug
	 xduSvbtfgw/DDE+cUBPkwgHr6IwSQgENSBL8C5/Jv+zAqe3dygpBB+FcVdmTda/kGF
	 CUDREzx7OEQqe1J3sD1vcLe2zMNn9wR5S3CDdeOjmRYuyZ/YHz2ij1zDI5Gi8642pv
	 hq/eCRYGLPkwZOhum6a5+z+IhdA/mEJR2OAYghdO2G4k3gbFGoyR1wrzFQLKveAFYx
	 7BywCQfdX1oAA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 19 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
Date: Sat, 28 Mar 2026 21:39:00 -0700
Message-ID: <20260329043902.46163-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329043902.46163-1-sj@kernel.org>
References: <20260329043902.46163-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A28674000B
X-Stat-Signature: ia9ioweeqh37bzxujdw4gm9iw4xptgth
X-Rspamd-Server: rspam06
X-HE-Tag: 1774759146-999699
X-HE-Meta: U2FsdGVkX1/P5zYbyuuj2tgnSGhLPMS0b8NR8yMsysqj9wZ8J77/MH+MeWc0Vpmv7nOETmwpSffv9F5Jmfor5iYnm4E4vDu/dhWBFq/tnnT/f4Roj0NC30EzoO0ne/PnuvIfTRtOTShc4SYnYmyKNiiheNjUWgHMaCqwSMiw8knVmNbCenl8CvREHzgL6VnEY4kLr+pz5fRwPQLCN7+pHFYiT4xrjtI0telxqqYTvbSYr/etcRm2QWXAem+IJDGJtL9Aa042hb4e6h8ytqYpvmrOVQkwh3vtxGrje6F7IwqovlenMvZ1P4x2Y52KO++tVPZltuFhgC29G8ozCgujL+jHiT8aMU32gYfX46IFzlHRGDebWcfqJqZHCxbbr3fbna5S0gZcCldY5TDunRJaPoCwfpiO71mVaD722t9z9F02U890bqRpldgvId4rYapDCT7lqSbb5HKyZdNauGhyGTsUrDHWLFeD8ydkiRW3gJjPdJHL0aYHwfFYGbIDwM0rcO2UO4nuEpBpAbJ32tTy8OYPH3kvLwxJ6na/iLmPIuvVRULyCjarYqM3gD2aBsj2qzkjA8AVh+6N7k9GN/7vkbR7D8eEXya+lsIA1sPC0hX6azuTnM7ateatyzMB4uxF5gv9kXkC3IMcrwdMB235fy/3imiC45lh5atfIyH6t2KfByr4nEI5ur+49u4qLIhW51TMJpL9NZBzcAes5DlE6sj4wbHZJA7x6kUnaoXDoXJORr3DFe/ugZqrmk04wkkRRsjBHUIeDeVqaMgMTq9dixyUbglBVzwB8QMA2nxKxoiGwY7wrmhc57teDU623+LwouPjVky50BMUFTg32J+SmmcKFgNXmLjH7H/QU6xCyf6Cje0erhoFwG0ZQzD0Dm+SaSqVYYTWksZxp9rT1JGg/0L0T2vtWxfoG7BWNo+mHptpssb+it7OAvF1imFTQGGhPfePYe6kbZ7YaCu3xLa
 R5lEJ8Ay
 GWdsLuRV1NX06paJ4H6jmiJO/2fXlnvTdeCi77fA5UNUjmX+BluWInoQEql2UX/2FNCJDoxLU8CJeOvVw+yeLW6AsYFyLMigwqmOnGmd1JQ3pRqPWuoKPHfjm/qdizUQ2yFY8iKyjXd7HVSGmD5jZ9IDMvRsrTBMnpzbqZKxzA7zhudQ7NFbwzK63WaQKiMyO5FE70xGn08wYKgrlAcato2JdSFVu4EFg4q8Eh3gY8itV52JDoXE8JqAP0hWq/pvIqpDnZ/ohObDfVpt+9qugiUBbrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users can set damos_quota_goal->nid with arbitrary value for
node_memcg_{used,free}_bp.  But DAMON core is using those for
NODE-DATA() without a validation of the value.  This can result in out
of bounds memory access.  The issue can actually triggered using DAMON
user-space tool (damo), like below.

    $ sudo mkdir /sys/fs/cgroup/foo
    $ sudo ./damo start --damos_action stat --damos_quota_interval 1s \
            --damos_quota_goal node_memcg_used_bp 50% -1 /foo
    $ sudo dmseg
    [...]
    [  524.181426] Unable to handle kernel paging request at virtual address 0000000000002c00

Fix this issue by adding the validation of the given node id.  If an
invalid node id is given, it returns 0% for used memory ratio, and 100%
for free memory ratio.

Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9a848d7647ef..19642c175568 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2251,6 +2251,13 @@ static unsigned long damos_get_node_memcg_used_bp(
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
+	if (invalid_mem_node(goal->nid)) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 10000;
+	}
+
 	memcg = mem_cgroup_get_from_id(goal->memcg_id);
 	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
-- 
2.47.3

