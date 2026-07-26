Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A42C531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3936B009F; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76DA06B009E; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D3C6B009D; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2461E6B0098
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7BF2A0565
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
X-FDA: 85031640456.07.E9765EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75263120002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwueIUNx;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087587;
	b=Zr6VCdqlBUKZUF4xhbJrwLpxHjHN1LVAq4gkg2gdU0ctzVPb6AUFt6qTBGm6SPQLx2DI58
	lFPpvbBOWYhXFWkbLvporFGG1tv87Un2D+NdDYuLlkE7fhLC+0hGn+C2sxOQH7A2KYJdpB
	ydulyW5pT4p8fQCX68zRo94fOmkb3K8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwueIUNx;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orUmWJfivc5NuWXSfNpxR3gihoLgZa1C4mXxNXYJ/08=;
	b=h01Dfm5hnbMpjU9ltTI86Rdbrqfj5asLoq8bKqxSSs1XCK9qzQqB/GLZ8jSh83JlW+HCV1
	lFxFcphonVXFiwdvAEiBjSOfesqxSlXSSj7HNcG3EQgAGSNFkR4h/hd8ZYeMrWARR7qNNW
	gYSs4Wx34jkx7JwTnsu2IB6CWsxksJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13FFE60A6F;
	Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B4E1F00AC4;
	Sun, 26 Jul 2026 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087586;
	bh=orUmWJfivc5NuWXSfNpxR3gihoLgZa1C4mXxNXYJ/08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UwueIUNxxuaobnaz9kqKPah/yMCNFJ2l08rRXpIDqPgTNeGZLwz3PRMFOrgKKh+ex
	 2Htz3KHUAvO5pbRdXM7Zcu93N3DInSFctBumVnS3bHXBVZ6hfYT2ijRFP4ym7+gb4S
	 iLyWuRExpRUEgafPxpSuGS7y1jV4eospBiai4Y56XVBVKArcnZkqRZd1E1/kyfu3LF
	 uFIywRRlV1+7Xfd6BGBpf6BAs426KB0WQa0vqqyyYd6fZMWX0SZnlISfg3zAnFDIiP
	 lFWCmDr3SUNaUDFNA2vf4m14yEaDseilHneVwPs9q7D2/MOwvkSi8uZF+bNQnF52Pe
	 V+iJU/l7Ssqow==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 07/17] mm/damon/core: introduce damon_operations->prep_probes()
Date: Sun, 26 Jul 2026 10:39:23 -0700
Message-ID: <20260726173935.94046-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 83pn5qr6crqo1namddp1zcd3kc7crboc
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75263120002
X-Rspam-User: 
X-HE-Tag: 1785087587-97995
X-HE-Meta: U2FsdGVkX1+5jVz2TUC8SmYbcPbHbaFyioCdHPpfjh5eq6PxMclqn+pqOsUXggE0dv+onntyvOq9Y4iqgzc9FI7ITOzYKTcTWpLklk5rzSCW/xV2aYGHmwm35y4KoikeRnUFjrUB2W9eCwSQvnRfpgYcL30UB1e/pEtoUzkvg8t7RSfjVAXQGkyqtBqlhzoCAoj4K/yfov6zNSeEY4JyIN19UZOzS/fO/yVllf245GlLlCs49zwqNzDj+iP0M4SKsmUSld5zDdFoAEEpp21dDvYMd9vrpa5t3XGiYB6/DNVn5jre2t5UskGgNliFikdoKE8QSlzCE8ku2sXR9+7d9uNLgPP660QLvjngrRKwGQoTilFPRDzrqar0Nf4pvSIyNxKLxsnkG7qskqQiGrWm2qLsJ1Abs8OmC6K1LQK/RSyQh5UEkSVmmDY1H7baPUCd6UKOElWo7dblJqheGF1nkoM1PX05ErvkjiqZJafrSeOjxjxZiAo7FAEmlNFRqyTGK6nzXW7wjRhUEbzQXrdkBS9j6zSNsU8tTI25GgrYSOPpIwZ1ai8WQqjIe3hwvUoVSiEH99aSht2XJ3qoynkBsNZK+6U4EgZUOtPV8ZtGKErnnOnDelJwcYY8/4ofBXkr6TzuroCG1OoCJ8gEXynOm83JBGFlt7I6AV+dc3QPf98XASdlNKTCbUm8ycXAUxkmla1ScPjAbYpkpTKnH5brxPaSKZxJ0YdOyF37Qx7Jhd7GvLfcDjF5KSR6JpBHIfOd/iRI00cVGEMpUuNG3MipkUaCWtjh+KHtoZ7QR/Lfle0FC/HJ05ZTMQ6oUCZ9fNax9nRTqC+QR3lvEVTwAAZVSTgVpb2cHc4MfGYkERj7Y0hcQ92SjdVG8El6xdOgW5g7bHmRKuQ7kynF7Uz0M5P9EG7AkM0LhpGs7ic9QxEnQTcxcNpyK3zm6vYYQPD20xvo5nWmNBRYp+wxpj3vzO4
 neFb98/I
 opFHzjXpLpxkvg86fVyn0ZCTTxT0QOJ3bWK3OptMZBB0c8O2ZxSGkFJF+GwD9N9acR5ER0uKjJsrRf1vXDQg98+7NYyyINXRHWh+wHU+PgX1EvQQRTgEYYjAaj4XoU3gg16jqWYQf/gmtY0PWpLrnOv2gfcv2xOdAg5UnaedE1dVaXJkJV8lSP6BNCxhfqYxflfrkGplpFvP+6vyUmcuR1ZuSi11HnoqvPhKzMpTh6tfDb5T54NiTfywxTOydyNgDn4XaxN/V17d78IxAbXApxNEL2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_prep needs to be executed by the underlying DAMON operation set.
Extend the operation set callback list for the execution of damon_prep
actions.  If the underlying operation set implements the callback, DAMON
core executes it in the monitoring preparation time.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  4 ++++
 mm/damon/core.c       | 18 +++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 255b20e44287f..f5b0f16305b30 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -629,6 +629,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @prep_probes:		Prepare applying probes for each region.
  * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
@@ -656,6 +657,8 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
+ * @prep_probes should execute required &struct damon_prep for next &struct
+ * damon_probe applications to each region.
  * @apply_probes should apply the data attribute probes to each region and
  * accordingly update the probe hits counter of the region.  It should also
  * set &damon_region->sampling_addr of each region if ``set_samples`` is true.
@@ -678,6 +681,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*prep_probes)(struct damon_ctx *context, bool set_samples);
 	unsigned int (*apply_probes)(struct damon_ctx *context,
 			bool set_samples, bool return_max_wsum);
 	int (*get_scheme_score)(struct damon_ctx *context,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index c74dee56efee8..bd2dc702a9811 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -156,6 +156,18 @@ static struct damon_prep *damon_nth_prep(int n, struct damon_probe *p)
 	return NULL;
 }
 
+static bool damon_has_prep(struct damon_ctx *c)
+{
+	struct damon_prep *prep;
+	struct damon_probe *probe;
+
+	damon_for_each_probe(probe, c) {
+		damon_for_each_prep(prep, probe)
+			return true;
+	}
+	return false;
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -3868,6 +3880,7 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		bool do_prep = damon_has_prep(ctx) && ctx->ops.prep_probes;
 		unsigned int max_merge_score = 0, max_wsum;
 		bool get_max_wsum;
 
@@ -3876,6 +3889,8 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
+		if (do_prep)
+			ctx->ops.prep_probes(ctx, access_check_disabled);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
@@ -3890,7 +3905,8 @@ static int kdamond_fn(void *data)
 			else
 				get_max_wsum = false;
 			max_wsum = ctx->ops.apply_probes(ctx,
-					access_check_disabled, get_max_wsum);
+					access_check_disabled && !do_prep,
+					get_max_wsum);
 			if (get_max_wsum)
 				max_merge_score = max_wsum;
 		}
-- 
2.47.3

