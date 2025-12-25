Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5FB3E784A8
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 00:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348CF6B0088; Wed, 24 Dec 2025 19:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCD46B0089; Wed, 24 Dec 2025 19:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE4E6B008A; Wed, 24 Dec 2025 19:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E39A6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 19:29:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EB6813B11D
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 00:29:24 +0000 (UTC)
X-FDA: 84256109448.14.6EEA508
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id BB5F2C0008
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 00:29:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u0/s1HHP";
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766622563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a6/TuFgHDhkQPqtZC3cXUeXixV3IdjP9zJRQmDjzS7I=;
	b=jUQvisymNI8RHsPAo0H8Jfl4kWJoxRyWAYjSWPdJ2x4QONpBOuQ+HYrI0X5gtaQn6ya8kQ
	ey+v1KJC4GTcBxEMASmSFLQtvnNDb94aASh40D+/gFu4XNMDggjXv8HMIzaShI9FL2dRzJ
	xBWGqaXiQfhVBAvzIG8J3D8PBkNr7MY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u0/s1HHP";
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766622563; a=rsa-sha256;
	cv=none;
	b=kJMdpwA02kZHQV7o/DaC9QAd2+bMdE03i4QwiYhqhJaFGEq+GlNk3Hz64h7dbSwA/PcUx5
	/NfJlnn2fHxe8MF5RxL5JOgNo6igz4BaKIcuggtDI0A1R/sq9KmgtOzM6QTzviP2RqbupZ
	EkemW/WmU0BOVTrmNu+0v0Ufr18AeuI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766622560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a6/TuFgHDhkQPqtZC3cXUeXixV3IdjP9zJRQmDjzS7I=;
	b=u0/s1HHPacfKvQQHZLVvK3I8siddC98FD4MUpujV9KIwdGqDxzF+xqMNUFlJXs+Gtbvp1y
	XwvgQ/kDtVyG+BNBAtdFHUVBC21vcrcWZbpjMBG9DbaIvaDCWcmuab0iX1O7s3CVDvarSG
	WN2LsF682W2XPgFKuH+W7pR1o7RNxbs=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH v2] mm/damon/core: get memcg reference before access
Date: Wed, 24 Dec 2025 16:29:04 -0800
Message-ID: <20251225002904.139543-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: dycu18sbhg8d7t8f5h15nktrngkr8c9z
X-Rspam-User: 
X-Rspamd-Queue-Id: BB5F2C0008
X-HE-Tag: 1766622562-724339
X-HE-Meta: U2FsdGVkX18N+cy3kW06NZ9SJkX6TX9PvVP9P05Zaaz44UbGkWfmq1wMN9xiKM0eNjDbh4FoKz0pdp+T6foL+Gdgr3vhvd1ECyo3F8Ae12lsfb9ZIHqk4WNeHY0R9Nt85MP2fKAEega0k6Mo4yDxIYO579gZyyiLUoYcAwK8wZDb/98BXmoxVM0OjVebEkT22/+H2/HVaBdsivvBDTQtPavAdfONJTXWsYHg+zD/GCOaVDp8DSJ8HiJBFknigRjtBxcNj/AM0LQGdg2gvrhzTWphDYWZUaZJSVtSAjkPONvAqyrHIAG7KRUfhHavbg88asXRXaqeHw8tVjxqXb4N7b3ZRH/8QhCHKyepeKHUISTeI02AsYAi3nLNdjUrfIxpsYNN9UAzuI3JLVXug3uXZOjYH99Xn5F4LeVCTV5qozrk+17oq0jPPRpNOSE84zrcM7b+NXYCayts3NGhJdRYkgd6z4EGqYguU3J9+2BZtTu+90pCOmN25sosLlbk2plx/w3q4iatc0wIblbtPf7qykKzNCTgePkf2fzXphexb3Fij7dNekUzqXFboMeRGsSwVyhqB0Q/v7Hc2dmLGP8C9YJ/7y0B1kjQuuU22L9xMF32ouBWJ8EZ0y/ptLzlqgZwN6O55OPDMVRpbB/E60pjTM71Hqd91eqqVFyz0e4VqAH11Ef4GkCJfdMuP69C4m/CN4JRinEQ5/bi8j4cmYz9tSR0NpnP2fVPyoIp7mRi7Yx9rxccmimiL7cXRNX+5DH4/xW0q9DIm2IXgcCoFqct2VcYPWL1v1384HWxiFG8BHzeMGQbm3/qpYN/TxUc7WcD+QCtgQh9GPCSYtWbrr2UQY8EhzLSAdjUdZyC3qbnTd24WyZr8I6mcCaxeVmrq6ogRzNTYZIZLGCsP6UxJyZnisal1bSBlFgXJO86wpwNw+jFtAE18gHXhxVbENgt91rJ7PAVV/0CmswuoSYqrpU
 6hxqAQUf
 SfGI0Ra8upvEoLpVsbVpdUQaAkMeIRJByQ76BbZRQK3IFlpNoN4sQBqd7D7I+h3hcXTI2k3nEheLjKs1UwZcMcVPvbOhAV1CqqbGMt0RBmpjrOhvV8pca4EcfzKXuetJfCX+Y+CrgIFyJH2RnLNua85qf4Q0xjYVqGHCAv2tvJSoaNxPNoZUbnX9W/z699zBSlfaX4hcdn8RFtCVZxUtJ9Ks6U9Otdejy0mo6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit b74a120bcf507 ("mm/damon/core: implement
DAMOS_QUOTA_NODE_MEMCG_USED_BP") added accesses to memcg structure
without getting reference to it. This is unsafe. Let's get the reference
before accessing the memcg.

Fixes: b74a120bcf507 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
Changes since v1:
- Changed the subject as requested by SJ.

 mm/damon/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4ad5f290d382..89982e0229f0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2051,13 +2051,15 @@ static unsigned long damos_get_node_memcg_used_bp(
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(goal->memcg_id);
-	rcu_read_unlock();
-	if (!memcg) {
+	if (!memcg || !mem_cgroup_tryget(memcg)) {
+		rcu_read_unlock();
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 			return 0;
 		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 			return 10000;
 	}
+	rcu_read_unlock();
+
 	mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
 	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
@@ -2065,6 +2067,8 @@ static unsigned long damos_get_node_memcg_used_bp(
 	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
 
+	mem_cgroup_put(memcg);
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
-- 
2.47.3


