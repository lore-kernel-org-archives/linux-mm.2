Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32358C982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138546B00EE; Fri, 18 Sep 2026 21:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7AF6B00F5; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68B86B00EE; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8750D6B00F1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D10B5140133
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:11 +0000 (UTC)
X-FDA: 85228740702.11.0EC46A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3772D160006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLiqC8bt;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4oxXYRuQjWd+sGDrw6IwSBotjvM7beQln0V1eFRUVk=;
	b=g//7QGCtXFTAn8SbhpZJRpqvPpxVU4uPDOjsliWgBeumOAwkMXQYoWPTUoxwwS8XlAeEOX
	gS+aYz+YMvyakF7q/rLOQeEwM/zLinuo957k7+Y2JN8YluILHdfrsL88uu3jeOlfUnTQww
	zLFuSnoQB0n5XxCUD6aNCR+0CfVsJL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780450;
	b=UJtJ17YIWxOEeQhC1Nkn8fUo/5VtA4pNCmdqzSBJqU0ZEuJ2x6jMDtoTszokAFxdLQ1uRM
	9kertQ6AUeKEQ9k/sMaI+e98qnvC1qunjLMiXkmOL8w+qrLs0G6B2ve5NOTVyFPOCkJyO4
	33WF50qxkBaYLcMK9xg59sp03nLqkbQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLiqC8bt;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 740584400A;
	Sat, 19 Sep 2026 01:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237081F0089D;
	Sat, 19 Sep 2026 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780448;
	bh=r4oxXYRuQjWd+sGDrw6IwSBotjvM7beQln0V1eFRUVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLiqC8btuCHiDoIaDtMK3nKE6F8yr4kzmUZVcBu16PG+/5FQiVNJbfveuJTwnZus4
	 LpqIA/K6vd7gtuCJ9uEp4Kmi6a40P4fvVJX3IOjF9eZrUJisET45Ps2Fs5wIY4aFIq
	 Sl0abzUnuR6ctFMct+7B/XjNSI64r8ZzHf4BqpZ61u3bwCfigyZqH4MmUpwhFZm2yt
	 Sy8Xr90yFlsZ5s/+Wcb1NrvtZo8leVc/BirD4h2fWbGyaILlFo0nmA6Cv1uz2IH1Qe
	 g9p288J2eNqBXLWsVeYHWr7lla9DhN8nsG4OxMmlKWaDIF9xzOhCZJjHNbCAiCc8aK
	 74/fjYzQGt13A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/7] mm/damon/core: introduce damos_quota_goal->complement
Date: Fri, 18 Sep 2026 18:13:50 -0700
Message-ID: <20260919011359.88921-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919011359.88921-1-sj@kernel.org>
References: <20260919011359.88921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ru1w5z8jqfqqhxc46i7heci13deitwp
X-Rspam-User: 
X-Rspamd-Queue-Id: 3772D160006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789780450-944843
X-HE-Meta: U2FsdGVkX1/qecyADcqt+iX5g0Hn0gUcD+PdNdxAF9xtg2jU+9G99dAyE290/kga6w4P3DUDl1JEM4X/HXfCOmwsuEJUhyC1OEBLhJzVdAZ7XsOtRx3ePMAGwxgYDZ5W3bkJVa3y9ClfKRODgjUYW8B8mFpBnsxiyVINOws0gAMDp0IB5/CZinyiJ+dpzfZJFMiGD5ZhCGBdq7Ctr3++rC3cUSGUS9cpXU0BEru+d8beyOUGslUn19woq9jIl2nt3fkwLPgRYNEfDG6kHtJklD/3q4YUdwz54LoZB41JmP0bhLL3QbvlTlMNyygeYBliPPHmwQgecumuEU4g8959D88qJ+W38OHZv91vZMHVhr5NqnabjJDG7NK9ZDH44GdlD+nDcGK2wrCMsQ5QhdwAoPWU+riyJy8euXhzonPR0LOb1jPesXg4+feB6Vn/djYqDQqo9MIyFA4kWBzRLOC3MkVfkYSnXPJv4+/gn1wprUR0CyzZr2Ma3bY3a6BEnOMW88v89zZUDfWuCGQ5ejFWtAVER8i/QdlZhdMN2FWQgkV/nD81MbY4nC7rwV7S4lj+RmJ7lCVfxAF+NSx8qSDu9MfkWI7nODPPAtKgd4Zz3wI5NwohLmLLv9iHVN8GbhLv3eWJBFqcfKFAutwR4Z/fjyNggrErQtJnvobVFkvy7nMJWmUPd/XcNS+Cde9Qhxdl2v3vBvEcURIRDeQG6cGPn4HCQ8am189w/9+vFwV1tIQTdWqJXbUZnwNVDoXF+aMijSXbMpTFLv0ZmHuki/aNMO5KKdCuHpQUQdSUtY+bMjsgCZv5oJV8N3QJ8hPuBFd7ZjA0cN8y5ySVq7r20AXqdHxz7atCLNvNAa1mL5xOozu6eLeApaz7x1dsT2kAkeWsgVF8iaKIKxfUtf6lDOpip22y0nOuBgeNR/j1IfVqlDMT/p+7YIpP/OVZ22BWLtf+749lcQsmcG63nLb10n+
 cP3Bq59i
 5o8JiJeromwycdXGJlW07dhM15OYVYzklRiBFs1pq+5lCLHCGOlRzZhAuYI9mKkyqIyLwYB7AIA+VrtJEruDcWIYNNFheWkqY5OjgrIIp6A0eGDNRbzTQ3yrG7xSIf56kkpHJVEAvx6ZuF5XNNkfODg97mChq+VAtNGeH/9namoISX6sI6lXDGu2EcbdpNV2QntfR+wt4cKIzpfdlT86RNavGfNOyKe53Bq4MCF6AHBFDnNNjT0V3NmsUPrumg8yN33b++bjBCHQNBFMG9M/X2uPMNA==
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
 mm/damon/core.c       | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 844b175120f09..78b227875287d 100644
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
index 4687b909d42c9..05d1df3746e83 100644
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
@@ -3239,6 +3240,23 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
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
+	if (goal->metric == DAMOS_QUOTA_SOME_MEM_PSI_US) {
+		goal->current_value = s->quota.reset_interval * 1000 -
+			goal->current_value;
+		return;
+	}
+	if (goal->current_value < 10000)
+		goal->current_value = 10000 - goal->current_value;
+	else
+		goal->current_value = 0;
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-- 
2.47.3

