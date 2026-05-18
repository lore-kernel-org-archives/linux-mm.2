Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BC17CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2A66B00B9; Mon, 18 May 2026 19:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30416B00C1; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9DE6B00B9; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E54E06B00BD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA0BD140ACA
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:31 +0000 (UTC)
X-FDA: 84782164782.18.B76AD63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D97DA1C0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtqJ7PSm;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSz3d5xykQnNeGmcD/lE0U6VUxJFmoiPC3uVUE7lQYQ=;
	b=SaRJagvvnhqo3SYCSUqZHN9/mc0kzvaX2Yfp42UDBrQLV2UNKmrkIhH02pd1chII1BozlJ
	b6ZKuvgx4fKzTWT9hKuaUNtWjSAM2h/1pfxeZROzdo/YRGhkOCTBw7h1MGJ3wuDxvzSfsV
	z9UVZXwDgOo6syo3rAcVjAe7dsEnXjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147690; a=rsa-sha256;
	cv=none;
	b=qVuwsWT9qyHxFNOqSJ+gWRSAstZVNyl+9qT4aZKzyG26eDYdHgqq5O9jzSUYKZvfrBM7/7
	8H/Xqpu7G5d43zQigZgjn7W/N2Icd80jHl+HmIZhS55o6OFBZ9MLHTMp6j4qkDSYm6sI5j
	pLLbKVKlsiEqMOHp5cRbTnVlVBJ16ro=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtqJ7PSm;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF29244508;
	Mon, 18 May 2026 23:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1A7C2BCB8;
	Mon, 18 May 2026 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147688;
	bh=foWtH36Q1RoAgy2NDpXfRZA2kQ9BRRcIQByE1JbM4RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtqJ7PSm6gqQlw+wraffFbAk4b2n9djCzxehALH8UETbcdW2RBd7zxyqfB/x7ca/4
	 m04k2OXrkOjnZwQbBD9P37fWEQRPS3d7NuztyzJawfgqE5BzJem5BQfjLpXjsdQlGZ
	 ELS3ibL5Tcg56X5oVwP6FmddbGxLgrDLjvhFcu6Nzg9rd7toJvDd1dniqS+U9kMMMc
	 dnVBXJqtYO9GzXd7oxJEep42QNklP5zBpyEstNJXBg9I8kDDgIEqjXHfpLL7zw3nbw
	 +ghKd6OZ3dY6p3yIzBooc1TcDQaVNPHkGHvHxysgumly0hauXWuRVtxqgiIRMQqjs6
	 vbKX098uCoxAw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/28] mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Mon, 18 May 2026 16:41:02 -0700
Message-ID: <20260518234119.97569-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D97DA1C0005
X-Rspam-User: 
X-Stat-Signature: oqw6u6ny3jnxdhgizfx7yr4u1pgyufdo
X-HE-Tag: 1779147689-924301
X-HE-Meta: U2FsdGVkX1+7zdqDMdRvYSyLIFsCEZ2hLM+YrZKRyfinDZGltuL4u6w9Or6g1XyzZm0fOJIpVMhzVT/WacRQD7pZebLaLJUNb6mXVS7E99pfCo1/ubMKfL16f9a5YC6yoIROls/BD0/lFeWlPCa0dmnRH1G0WK8GcAQrsvIwjQfI3A6DHjZyaCyCvnKZkcbmptGFtll22U18pgiKWC2IhkK1upv/9iZZI6v6EnD63SAq5Cy72F7wRH/VqXpNUXxRCynanYXOBZkqMp5h0PzAB9MtajzWIMOalmoPhawgJoRhuAmwJU6MOpnAceeokSdt2xkZ7Ku2MLxBOhrZUhJaTlkaV0fqhLvPqRSkHfCOdUAS3ekQpoEJ6pp5ewCBXmtbKBOyCwnE90fsdTkKs0TctZ/eB56sMdOZxURpnfnwn+Hdn65H6n/KThK8piLDAPoz7Ck+tdXq9bpA5raT34KANWONzxr2kVBGPNGIprDxG2DGAD6VSJgK3U99kkLlxJb7w9oXnbL7NXVvuoBSVU30SnsDhoKpQcLsEW090guF/nbPtAgomltKVbfHSqn8ITHcsi+C2ueGw3uLf8822axRQof5oV+Zd7vpVcdCjtHxLXdHVv1JYwsoRq1TVq98QE7RLiZnt08bgfxrce4eJC/pPAoyLHMFQrvnbxR9JcBvmkjSdLIYc778a/HsTLOkcEJtgU15XYdqo+awEEam5Cru/9V7qW7rn0avyO4/Bat84y48boM0TR3sldfNPbRR5wPJPAX8lnaRaiqCKpmtjZb7/zCnV6INT74qm7uujlbfWciW/Y62kF9LSQwLWpJK8Kb1aFCAl47/WTBNeOfBc9W6yHewBQXVxuWktiv90y+iNYJbB5Ae5gpH3CxV7PyGKlQVPqJe4tx1zKQvV3uVTMum9g/pYnO6VwIhAdEGwi+J+tk2Vhzgkt09+3lwUBgJv7S+0aC+1RBWD/FNhLUZl05
 56UKKhyw
 S4mPSwHmSUuas/m4OTxuAY75waUzJINqONm3mObwjyUYVZokAC5iFrGWi8iePM+cfq5O6EKKdk34j57wjKLhZPm+cfHdDr2GJ88dVM8O1iUY7hlqfZho7XfxnSG8wKn5EoRWYlDcNhwMoTW/42kdOPWHsM28g+9+2Nm36pXNXwXatm/0SWBTVEmm1fhWVxuj496YDVraIyZDlk0myM7405YAzUER5A6YS7xOhPvccHscokg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add user-installed data probes to DAMON core API parameters, so that
user inputs for data probes are passed to DAMON core.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 51a4f05c9275c..eeb7fdd030cf0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1855,6 +1855,40 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_filters *sys_filters =
+			sys_probes->probes_arr[i]->filters;
+		struct damon_probe *c;
+		int j;
+
+		if (!sys_filters)
+			continue;
+		c = damon_new_probe();
+		if (!c)
+			return -ENOMEM;
+		damon_add_probe(ctx, c);
+
+		for (j = 0; j < sys_filters->nr; j++) {
+			struct damon_sysfs_filter *sys_filter =
+				sys_filters->filters_arr[j];
+			struct damon_filter *filter;
+
+			filter = damon_new_filter(sys_filter->type,
+					sys_filter->matching,
+					sys_filter->allow);
+			if (!filter)
+				return -ENOMEM;
+			damon_add_filter(c, filter);
+		}
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
 		unsigned long min_region_sz)
@@ -1967,6 +2001,9 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		return err;
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
 	if (err)
 		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
-- 
2.47.3

