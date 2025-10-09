Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86A67CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842778E00B3; Thu,  9 Oct 2025 17:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2438E0002; Thu,  9 Oct 2025 17:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D288E00B3; Thu,  9 Oct 2025 17:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5380D8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:20:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1A4313C12C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:56 +0000 (UTC)
X-FDA: 83979845712.14.409112E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5014D20011
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JEVumExa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfTTX2jpVow8mpLYoEU42UDGQtVWJ7AWsBWZa91puX4=;
	b=5ftka7nL3rhxUBllezTsC7UOpc8hCJkkfAXGEGkNFH9mSWX4SLd0P6ZDY6Cpz2MbGJEe3C
	cf+XC7DZR++UtenM2fWuOpX+tWzyRKDYVt+VPt/boptFQjLt7Hb+yIK658oBL3r7ytIk+J
	xVkhiLzICjgILD/FdsDsfKNYUEWUyBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044855; a=rsa-sha256;
	cv=none;
	b=luLmV0whP8iw1gcztG26Fpu/ou91F3Z/N66IFTZcfkJM1V3/D+f75uvzdHuDUVe9ZvsiLg
	kzB9/k8nJRRhkB/veECjFdQvCnCpZM6EViuLqgI/TTtD00N0JnTotsTRhsob7U2he8nKcn
	aySElkh8LW823TY1whkVzQO2rMZmBvI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JEVumExa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD8EE62426;
	Thu,  9 Oct 2025 21:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8266DC113D0;
	Thu,  9 Oct 2025 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044854;
	bh=CkhTLsuJMtU34HmXX0O02XR+nCAeXgrwHrAqstQf9yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEVumExa/JemdD+OCfcpdTleOjTbQhH/UBhfCnnG/kq3lyQD+OIVN1PzJI9YBObXs
	 dCvMgOALWBGYu7MNRIRSWRCq92x1JKNgQzcsY6mXS9bVXnMRYQXi0Q+vowzSeJH3+o
	 GHieqAC4FdPUcc+yDKyJT4pMxYChEl0x4opfEqPfylL2IVAP/O1f6WeADIPIbkxoND
	 pa5hslqk2R0ZH+mRkQK6mHwZT1IPPQb6sFIlW6KCs0crcbRm9IUlyOoPwgcIq9Ett2
	 kZLNGw0z7wxyKMr7HWxtkIVk+MoS1AsB/b9gC8Lw76dgANzwsLsqnEdZDN/mKTsDM1
	 rbwC3AYpqbybA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 06/10] mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory
Date: Thu,  9 Oct 2025 14:20:38 -0700
Message-Id: <20251009212042.60084-7-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: gdussbomrjoppp7bd3cfoz3wjbbqkagk
X-Rspam-User: 
X-Rspamd-Queue-Id: 5014D20011
X-HE-Tag: 1760044855-823732
X-HE-Meta: U2FsdGVkX19Z/+QHHfJpfAfCV3GzPJWPMjBof//+BTO31abIzS85Nusb9Amgms2GUiDmaN0cabavj+M6ftf+HN+DbrJOwyFNC80mVkbv4FoaEKKFohaXs5HFYJTrsr+0RzVpVDO1s7Ocn/9Y7gOxSwdF9LhvC2xHkw7Ow5JeXRWTnBzO7QM0dTJdzQHdr5yrH3FRpdjpXPl9J3B2L8DULmW+x0DnTl2LlA2bmzL2/olnDak7khfL33yL135nCoC5pwI4T+NaFpeWWTHmqaWzhzBSAeaW6c32HbPuPDPM/abk7dcKBfk2l+xXmY5muXyi9AGNqRhmuZUSzOtOzR26Zz4jV1ieFg2JvONCtxLWqe9zFF40O5ja3eVtJ6AHFrl3SgO7QdtwG4RR8qTz2Kb0aS8JjzIfluHaRua/iHIl+ffqvNGieKzq1aTKAoCb1+KMrNGiwnwOcGukiWMoruat8khbFkecE3PEXGeWEsc5cHfQG0i+4X6GHZ9/gqb+Fq6z5Z6kvLXUTW/cmcDME0ZelIeZuw6+an9OkFNgOSG6SC2hzbnvdc0d9fcwmwu3nBnAIyoPVQOoN0wxN840oT72tbxtwpfeUXW1R+mk8bpPbtfRCLVAk9myNmhasonTgO50typXMzy6vDd4VNDG2QGuHRAbfcVgbmJa8yAuiiVzCPqzkRep4w7CL0nRW8nz1rp/xCvdOCK/dkrWY/usIvUWPTA9ASwhZkDVOrkgq4+dQHLvX41Doi3VjXuuxNHTAZ17rZ62a0Jaz222B2xskbiGdGhARmFO/XxLsVQT11Jv+itPGg0lxryBMx9NNc60hby1kJomXf0SQeDhnmJaSBa5b7dx1pLleREaMlz/9o0A2h4nuEUArwsbBe/TxcDJCO2AVmM/YQ2quIIX8We5voEc4Ulz6E6UW5iti/ske+Z/xnYT1bZx7+BqI5ajx9W5hgafUY/HR5460ezDibUPOM5
 kdJJQKAw
 b5srrjiVymL2wqNi7CPAauqYejFqguJ66XamZFxiQWozksg8gn8NUsf+VhokWx1TZVm/NNX2Y+k13A9/CtibV2rIbp7EKbuN8RH7IXatPXWl2KjXEXxqQDuIZ598Kbh7iCvRk/WWORM0aWO+ehTOYcDYYy5u4UNMSdllujWUPChIZatlPCedWqABZRYv+ni7cW4xsgczkAZJTVBKNcmhi7ZTRhI12vOBwC8Tq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a variant of DAMOS_QUOTA_NODE_MEMCG_USED_BP, for the free memory
portion.  The value of the metric is implemented as the entire memory of
the given NUMA node subtracted by the given cgroup's usage.  So from a
perspective, "unused" could be a better term than "free".  But arguably
it is not very clear what is better, so use the term "free".

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++--
 mm/damon/core.c       | 9 +++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0d63ceb7e6ef..0edf41d36ea1 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -148,6 +148,7 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_USED_BP:	MemUsed ratio of a node.
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -158,6 +159,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_USED_BP,
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
+	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -183,8 +185,8 @@ enum damos_quota_goal_metric {
  * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
  * id of the target node to account the used/free memory.
  *
- * If @metric is DAMOS_QUOTA_NODE_MEMCG_USED_BP, @nid and @memcg_id represents
- * the node id and the cgroup to account the used memory for.
+ * If @metric is DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP, @nid and @memcg_id
+ * represents the node id and the cgroup to account the used memory for.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1eacf78aa358..a31ede50906c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2039,7 +2039,7 @@ static unsigned long damos_get_node_memcg_used_bp(
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
-	unsigned long used_pages;
+	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
 	rcu_read_lock();
@@ -2059,7 +2059,11 @@ static unsigned long damos_get_node_memcg_used_bp(
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
 
 	si_meminfo_node(&i, goal->nid);
-	return used_pages * 10000 / i.totalram;
+	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+		numerator = used_pages;
+	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+		numerator = i.totalram - used_pages;
+	return numerator * 10000 / i.totalram;
 }
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
@@ -2094,6 +2098,7 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		goal->current_value = damos_get_node_mem_bp(goal);
 		break;
 	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
 	default:
-- 
2.39.5

