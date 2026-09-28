Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4885CCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393F36B008A; Mon, 28 Sep 2026 05:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D736B008C; Mon, 28 Sep 2026 05:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1986F6B0092; Mon, 28 Sep 2026 05:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E7D556B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:33:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AAF8C012C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:55 +0000 (UTC)
X-FDA: 85262659230.04.6EF15CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A529B20005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WW004KwN;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCUk6L1aWaPzrTTzvJ81KlDjiL0II5tx/S//2fpxpwM=;
	b=K2tQcitraZkWV2vU0olKinhj3Gfb92qZ/y9jpSjC66JuTECNLVdYvPEBAUP6RGV+6WHIcq
	wZSQ29hXwwjb6JPCNHULQeKDPQ97hrimvbbtbvIE83SK0ol1CUowfMeed6dxlbXzai2AST
	PCv5Tfyb5MRiVo4v2FI01zfL93XOlnU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588033;
	b=X3GMSZ6khorrhisATvJS06PPBFn7jx/Psh/T0lVJcE2jEDwKGkWlvefiJv7pmW9t5hjfMr
	WLffAuAr1nnJBGkmdMNWroMJoqSWxIrm9beG2YQNQReFJ6VZ7EmszJ06n9yt2nMZnV6tLK
	84i4jFUqTnH5FfHpMh0QvdigpxRA5sI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WW004KwN;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E569C41830;
	Mon, 28 Sep 2026 09:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF9C1F00893;
	Mon, 28 Sep 2026 09:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588032;
	bh=nCUk6L1aWaPzrTTzvJ81KlDjiL0II5tx/S//2fpxpwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WW004KwNVIYEXrtmQWam0faQScc8OeqZS7bPF9E74Zy09MhziQYJ4gsX1jnNF6y2s
	 w9YqHiKaVWMJdHqULM8+anbdnlj2cpSaUBwZNlBl3dZuIPs27e4q1V0hwqGrTC/95K
	 bisOlITQDUpuHABxhq1qfK+A/X+Srpmcj5OrgfyB6sO5dXykjqWFi3p3fTS0O7TWZa
	 JPx9sRR0oQPXScUWMz0xk3aPxgzBnQHawHJXNZ8HmWST0CBcWZOcwQtElllwYeasTw
	 twssCp4r4IsR9NlNU5tma9iR8CLez0iywCIxU+uJYRVC7Pxx5hxxdhg9uTuPQ75jN0
	 zjfJS1LdXQPJA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 1/8] mm/damon/core: introduce damos_quota_goal->complement
Date: Mon, 28 Sep 2026 02:33:33 -0700
Message-ID: <20260928093342.16584-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928093342.16584-1-sj@kernel.org>
References: <20260928093342.16584-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A529B20005
X-Stat-Signature: itparkbb66no1gqqpqa468nhudt6qa6c
X-HE-Tag: 1790588033-856386
X-HE-Meta: U2FsdGVkX19P++yJVfufz4ADKR8T1xQKL+toS60dFcNOrE8U4ktCPMjwm59SzEVXM4hwGxTj60ehYN10ZjagFElyTGQ51fPc+cig/FFq/s7HKBbTzkBdugPnUV0gl2/12oUUyNolV9m19kAtcx6uZq5ou6kIivfFS+UjY5QMoNbPdpafMV3gmqcj5pWqFSD/oT+1/YlQfXLe1baYehmN+EsPuZB1CVwpWaRDYRyHuPgekwrPkyPQSgEssZAvoXPZ7RIppqra5wi7NjRKUHJadCqV09KE5V1jxdGma2n9AeCsymaepDOpFRkkc7jVZfOavdFIn4FQ+0yF8mrOLbLx5/fR8nw5y/uwd8ejoR2aB4O5sRbMyLKlOEDZvCGEQcvEoNzwNHewJF1tkuVKPtSHjNSNhDaO+MrpAhDXkiFlgy88LpA9M1S7tJTbFFQEMZ74SbkcOZ5QGqrxXU4ASeKr5QCUZymNIfz0j/NgmZ1eY9ibzRvd4LriCWSPcNpG/h2zFZbgS6dkd1Fzsnn9s50LHZIh9/CCm9rLeU33jFBw9DuBzxEgTd91hCQnMSBbkwrsBP2VHZZq4aiobKqap3IJuuUQDnBswbtMasaEh2TJhtIw3ZTMOf+OHNZODy3BG61yoxkLMQWQJvdSGWa7L3Mxqvf79Izic724IK8flbXb8MWJnBEaHzDa6gYNrI0VOPvI0/Ev7y6l1d1UnDqtPXOzwwRVqOKtSxsEM3RfsqOolGU3N8W0Df7OSR9s3IFvZZEK35mR5RcbY2wAS2LgcYxu8eYtsopkIk2LgWWudHNUOycsT+B5SGaSeysF559ZBrGCIYZ4BvgkjemfzvkDZF00IfUtzJXJVCh0UlNSyP7kf+gCb6ibEtM0ctGRAW8LxZ2CZWn27e0hMs+p7Kgb3ZDWx212+4lMBS6KjJrlD13278VSJx+EtEyfKPzyU2XoWpj9xdxvnly5xkHRUYUbA69
 6jcn8oXN
 pVvat3N9JPYaq2JMPPz8s150uhFf9Cjm1ABiuEsPRjkebvMewtXn5RkAEZdvwZvgdr8OkfgFQGPQDaka1upMgDyK20zcPMJmEblV5k+GllL0W0/aHcYrFL3MPpoS++Yn+Q6PkyNZsZxfLWG3T7O/odQW8vkGpcYX7lFTVMNeb39DFbUIX8Dl3QcV2YgCF5I+2FYjDQtNQ7xegJAlnzJ2YuV2L/w/yeQ6HQ3e7kMpafe0g8GFcpRGXVPEC4lsxlzV0agNGs4ntXEHNEaYFFqpqlSh0yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce damos_quota_goal->complement for specifying whether to use a
complemented value of the given goal target metric.  Add the field to
the data structure and implement essential core support.  Handle the
flag in the quota goal commit and current quota goal metric value
retrieval.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 26 +++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 844b175120f0..78b227875287 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -175,6 +175,7 @@ enum damos_quota_goal_metric {
 /**
  * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
  * @metric:		Metric to be used for representing the goal.
+ * @complement:		Use the complement of the metric.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
  * @nid:		Node id.
@@ -197,6 +198,7 @@ enum damos_quota_goal_metric {
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
+	bool complement;
 	unsigned long target_value;
 	unsigned long current_value;
 	/* metric-dependent fields */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 733025b36745..270ce9c85a2c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1224,6 +1224,7 @@ static int damos_commit_quota_goal(
 	if (!src->target_value)
 		return  -EINVAL;
 	dst->metric = src->metric;
+	dst->complement = src->complement;
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
@@ -2960,10 +2961,18 @@ static void damos_set_psi_current_val(u64 now_psi_total,
 		struct damos_quota_goal *goal, struct damos *s)
 {
 	u64 last_psi_total = goal->last_psi_total;
+	unsigned long val;
 
 	goal->last_psi_total = now_psi_total;
 	if (last_psi_total != U64_MAX) {
-		goal->current_value = now_psi_total - last_psi_total;
+		val = now_psi_total - last_psi_total;
+		if (goal->complement) {
+			if (val < s->quota.reset_interval * 1000)
+				val = s->quota.reset_interval * 1000 - val;
+			else
+				val = 0;
+		}
+		goal->current_value = val;
 		return;
 	}
 	/* uninitialized last_psi_total; make no effect this round */
@@ -3255,6 +3264,21 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 	default:
 		break;
 	}
+	if (!goal->complement)
+		return;
+
+	/* updte current_value to complemented value */
+
+	/* for user_input, users set complemented value on their own */
+	if (goal->metric == DAMOS_QUOTA_USER_INPUT)
+		return;
+	/* damos_set_psi_current_val() handles complement flag itself */
+	if (goal->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		return;
+	if (goal->current_value < 10000)
+		goal->current_value = 10000 - goal->current_value;
+	else
+		goal->current_value = 0;
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-- 
2.47.3

