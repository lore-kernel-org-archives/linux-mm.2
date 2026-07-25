Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC10C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7256B00A2; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387126B009F; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1786B009E; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C46E06B0099
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 185E41C0072
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
X-FDA: 85028522880.25.B36E7BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7366880006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BX0TEy62;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013358;
	b=8Efw13rFi9iXmOspJ5a3QD17f7tHn4y4LIN3CGgfl/vNgz8Olv84aO78s+fbUETcJS5Rvh
	F5h+wTGbFOmAQn8c1Y1TBTLqFJEFxNsDPqRKAoCQtL1SjvMEevnAamzF8PRSq5R+ITuzee
	zDIGMLMGYOnf4VdXp8hQQN/HIoR/kAU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BX0TEy62;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnE06deXrI0slNd+Eqrp5ImjS8Zb6D21mxT9DSUmfyg=;
	b=aKEsL8MWCX/rchYmpg3eyIJicohPm6OobuYsQ17h4u6xiQWwzA+yc58y98UEobhHDrX9Ib
	ZfjJjnBwNKlhgy5P7qjzfbVhwh4WuiC24u4ME1xNS21v5e+8dfiZU4tHfKlmTltFsjicni
	dku7arBVupT+GFhZ0Zpdp9B2QpX0CVk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A3FA42A27;
	Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6B71F00A3A;
	Sat, 25 Jul 2026 21:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013357;
	bh=QnE06deXrI0slNd+Eqrp5ImjS8Zb6D21mxT9DSUmfyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BX0TEy62bI8Edi8K4sbFTmSYcLY18hx8RnHnVahzCCxwwMPbM7C6STlFtYLSPN7sn
	 f5iLeDeuoMDgvh5auBFcwwPUWxzNjRc83GkBfK3aYRw+5QALIbjnSFQrOTNrX0NkFZ
	 GhV1OakXo8K2mKr+ruXqnOCygwaS5ypnFuxvxVsrO0n7q0sXjaCXpwrpQYw88EEvo5
	 d3OzCYQ+fVYvNKa4pbaCrXabsmD3bgNSoF2vV9k9aQ+Q32K4J2eme2pyTiS3XYWis9
	 j3A7F9cNRqaQb8slaEubtp8tSF0582ZHO57j7rfe9P92cImmEXRRRpQuTPlAjwbC+J
	 TN9bnhvdk6lLQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/17] mm/damon/core: introduce damon_operations->prep_probes()
Date: Sat, 25 Jul 2026 14:02:11 -0700
Message-ID: <20260725210225.129944-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mjw4utbf4d4ppw1miodej1fiz73c4fue
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7366880006
X-Rspam-User: 
X-HE-Tag: 1785013358-364507
X-HE-Meta: U2FsdGVkX19HHCOrm7N+4ci7AL2QihfxYN8o3dq37y1tUmzN5DqXMcKc2ETBgpzuC68p9+Zw3SbhULMn+Bsq+hYD5NpCs7XTlFmK1TIyoVQ8rV6a2SKsxf1pMCQzc0mWRZY4ZG7qv4ZFWxsRszmleqr0HwSIKz7CPE5/vAUBHMiH8n8GCE8mBiIT3VRuIWLIoV/Naw6pBL/Wqe+6Gs+JbFGMmTTap+bQh4N+AwcoAUk6JT2kUM7j5YMvohG8oi9rVN9/EQt3oNY8pmd2nyKvH0aweTT+M0ABRxxxMEC7YHszWHIWW7VFkqR+l+D2M1rk0xWJB4EIrERgFoF2/AOIiatdC/UsErzl1qwujN7y6DAtFpwA/L8EN1aeirkKmoj9jlizFt3V9wrCwZUmknRiTq4NCeFVszIJ+DOI0RoiCt/odmNl4COL+RwhvlPhNgsdhYzUk3wp3ci9Q/KZVvxqtCxViH+H/UpyDZ2oN3RaB2h7rzj16YBOsh072OM3YVnrMCYX3bb7cz2W5nHgKFmv6MSAvFEGpaFagCKEBe3QPLb3wyXH6gB5ypm68XwAgxQxUJiMu+g1PnejDXbpxZYzHc5Yv7OgLkaobAFe23sUXXwbEmQaxVxpJokCXUcSkr1onVxcKLY8NVhHVsyIsXXgkBv3NNAc2DmV7p0N4vIYD7Uh1g+fcpcXNBS00/ZOZK4XF0C+wc2fRwQuqj2vHTqncz0/9S01rw4p4WBuUxyr/igpTZHNhqz9dV6TGKfCeOJPhILSnbaN9jZ/vifzrnD0+okwseumFrPhiRlKoc8TEuJI4nRkLRxmDGVjZonVaaQ5VFOdHeLP+2y5eKE4mAss4O84RbjWBo6BWooTw4+gZ/ca69ISefVY+FZ6I6zG1u1LEeAGCn87xoYDT236mf4NCEy+0aXsZkY/25EfdWsPmSfe9gF/j6YvTgnKAXORO6DUMEBLTSqXTEOUh3qlsm+
 vewsQ3jG
 bYBas2g5EHkS89meVHqjE+GsCx1tZRWbUG1WujD8jwFdYt6Ab9RYGVCKnUv0rUMA6go9D7lq152VaKpB/hrGN+pK7DmswV68X5+mWSnZNs53Uf9x6rE7m95+A526JgWfge9ngNtexIwBvIbsnVwTD6bdIPH9CQOUQ2OvPVueslopSZDFD7VcH28nRnvN5/2/ZavKLadlW/L5aqf5HJZYqREcWsYi2SAFgxjw0eyELqd70OHJNEU8fuK4ClXW7C/RcQy+omMZZXg3MJ+y54B0Mo9Sa7Q==
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
index c74dee56efee8..11d16b7104a7e 100644
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
+		bool has_prep = damon_has_prep(ctx);
 		unsigned int max_merge_score = 0, max_wsum;
 		bool get_max_wsum;
 
@@ -3876,6 +3889,8 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
+		if (ctx->ops.prep_probes)
+			ctx->ops.prep_probes(ctx, has_prep);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
@@ -3890,7 +3905,8 @@ static int kdamond_fn(void *data)
 			else
 				get_max_wsum = false;
 			max_wsum = ctx->ops.apply_probes(ctx,
-					access_check_disabled, get_max_wsum);
+					access_check_disabled && !has_prep,
+					get_max_wsum);
 			if (get_max_wsum)
 				max_merge_score = max_wsum;
 		}
-- 
2.47.3

