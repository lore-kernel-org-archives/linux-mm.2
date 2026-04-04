Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D1CCE63FE3
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7C86B008A; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3985C6B008C; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F876B0093; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8F96B008A
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38FF413BBF2
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
X-FDA: 84621435234.10.AD18C46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 554DB2000E
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta9PmKot;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWzarqvAvotMSZ1LlqsEYQLQ7cYlt4fKpXxmmEt8sUU=;
	b=7/lU1ObBIhOc+TJTo1tqsL5Uex9I147cHZYYvvIwo4bp/alcubyZUXmeGtw9JpWi2Wi4Y4
	qpATeHjiIfoUrUHqw3kJf9EuIgrh9vUJHdwkKvE6jbmj6VGvYTrLXLa4YCfF8ONqkoIiiN
	AM7q+LC32oq42CKH4iA4gm4Ix6C6dkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320795; a=rsa-sha256;
	cv=none;
	b=7awRSXC3BM6uiEI3VAafhyqH2KOqRqNVJVgPb7QY2aE0kU8+FbxQwxB74+TRSfNorS7MuN
	8C2jXUx5hK+F81Mvhe+GgVoC1s5JZ4mWjTgUWCqMIOi43/ZEX7HN9EWoB3FzHj1UL6oZdl
	00KjkFi0Si24fZJ9wzhy6nPTs1//flE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta9PmKot;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60F9F43C46;
	Sat,  4 Apr 2026 16:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA03C2BCB3;
	Sat,  4 Apr 2026 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320794;
	bh=LD+Gu8qGFIg85Mqkymtw5F6uEv4cPpFyAPwSqtGapaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta9PmKotJNVWvjCGct+sfbcIjOx9c/DZpn+LjzzrMYZaGdz5XVIPkIZmTyq7obbCX
	 ZUIAbN8NT94KDVyx7L0wvPm68Fzy5A/2Dm+Yk0KjMDbgAFNhCy9+resE90P8pjQA1X
	 Fgo7u6QS5IkKegPxt/QiCCpkPAxdV/dhnaCnAXjfZBoAMbQ102S46BPxY8GFZjs6HM
	 aWFoTm+2/pYU4Gvivpa0uBgG7qGAIOjGvvH3ikaRmlmPmFZYH/jYp3Ovc+KxmXHdeG
	 PgaSkWihrHLrDGPuIfCMq8ZqfOtXidzTNzUw57RWtMT9c8ste/RW0DMWEy2A07RrwU
	 mmsJzL/Wm8Vgw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/9] mm/damon/core: introduce failed region quota charge ratio
Date: Sat,  4 Apr 2026 09:39:31 -0700
Message-ID: <20260404163943.89278-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 554DB2000E
X-Stat-Signature: ij4jp15nu94xuu5ghh9azx8xhp5hk8qx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775320795-650739
X-HE-Meta: U2FsdGVkX1876QgerhEKzf+pDfitsh29r4JC4nusxhzZJCfpug12dGwdiAOq3r+pV+qH1EvUyc8izRbQn8G9WXt3XtbImjYXCCrKHn0lIvA7zYWIeoFUsZP1fS09+QUkWQDLoYNfDkKlyVEPlA9vQIqaDnlZnwHdQOtfObVEbanuR+8CVEig2QVokRtxarEb4BkkX8RNTS8DEqxJnwyPsHJsUhyXk07jj0pVnsTd+L3nycWp1UvzyhXPgs1CM92MffBJRUoV8mBy7nRXdp8OLRBGh4pkp49bY2eEyOYwkkEVY/QOMMMr18bpiulq2eFVY1AyI/kMjmlqLQCaGKhjmmpKMj77Fj05DvuPNfNFm8WjhcYTdD0vT3HCbXf51vgodOVZhmJZsVFDOQhBJbM1PVBut8Y2mjhgUufzzOe3rarAk1Q3tqBdH07k8b8z1zflrI9tPB4wjoFpyvZPNHlHyrw5bhVe/b+ew/4A2l3hFfRxBnW5cGVwAw8YZyHbUzn/riFMPGaho9R5epuWVn7t8+qCYUO2RkUe1izbxV5AV0NrUvSsTLJFYlNH4Y0gEVt2R4grJEdKi9KCCgGoP8GdqgzYK3ZyBjDlkkPtXlR6PZM6AN702aJddc4mvvo9alQCr+5hS+BgMpoD7dlEPunQxoXbST/M7oD4fHJI4z9xvLBS+3/8rApqI979c56RN4G2K4UYQ29vLLatiz8HKAG1Jqf606ASo1EWk73apvwsOoF9DVYgfQpIEQqV+vzU/eV7AupWjv1rN9ufIAen3vu3WpKyDVtf3PgK/1H1UNGgDu80vKX3d3lGGUpFyC5Gi9hB4OQ7O9FiBkjLioivJqGp4s45PX92uJoMKtAaCpwq5VPGXiAWA3tBCh2snT2jBbib+e77f0QRGLU6r4T2rEDpAIYWb1TWqXPbGiN1epSqxBRvxnmHrrpR39EFREJQP3xiLuueCrsmMS/HQnZLcTl
 tsaRoPx7
 I7h2wI7lBhd35PR5QFEhq299Igg7PGG09ULh9Y2Y4N+gfyYug6y1eLxi1S6qCxfIZx2awoWU8XjjpmnImGj5IeSyM5/w8zNnkvMiO1vpovUJX63IJdVikF9LUz+zokMlC1sC7kzCGzrdCYxQTHQOEUxdkVGdaK7lmg+PfJbVKADJsrio2waVwIuf8vi2Dbs7cjInaS9NnAsKlNtDi1tqJ13garzz7El2RPKtNiLtg+/P6xBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS quota is charged to all DAMOS action application attempted memory,
regardless of how much of the memory the action was successful and
failed.  This makes understanding quota behavior without DAMOS stat but
only with end level metrics (e.g., increased amount of free memory for
DAMOS_PAGEOUT action) difficult.  Also, charging action-failed memory
same as action-successful memory is somewhat unfair, as successful
action application will induce more overhead in most cases.

Introduce DAMON core API for setting the charge ratio for such
action-failed memory.  It allows API callers to specify the ratio in a
flexible way, by setting the numerator and the denominator.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 mm/damon/core.c       | 9 ++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4b69f4553267d..9ab7331775b9e 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -233,6 +233,8 @@ enum damos_quota_goal_tuner {
  * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
+ * @fail_charge_num:	Failed regions charge rate numerator.
+ * @fail_charge_denom:	Failed regions charge rate denominator.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
  * @weight_nr_accesses:	Weight of the region's nr_accesses for prioritization.
@@ -262,6 +264,10 @@ enum damos_quota_goal_tuner {
  *
  * The resulting effective size quota in bytes is set to @esz.
  *
+ * For DAMOS action applying failed amount of regions, charging those same to
+ * those that the action has successfully applied may be unfair.  For the
+ * reason, 'the size * @fail_charge_num / @fail_charge_denom' is charged.
+ *
  * For selecting regions within the quota, DAMON prioritizes current scheme's
  * target memory regions using the &struct damon_operations->get_scheme_score.
  * You could customize the prioritization logic by setting &weight_sz,
@@ -276,6 +282,9 @@ struct damos_quota {
 	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
+	unsigned int fail_charge_num;
+	unsigned int fail_charge_denom;
+
 	unsigned int weight_sz;
 	unsigned int weight_nr_accesses;
 	unsigned int weight_age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index fe5a4a8d5b294..4cbf664c52021 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -918,6 +918,8 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	if (err)
 		return err;
 	dst->goal_tuner = src->goal_tuner;
+	dst->fail_charge_num = src->fail_charge_num;
+	dst->fail_charge_denom = src->fail_charge_denom;
 	dst->weight_sz = src->weight_sz;
 	dst->weight_nr_accesses = src->weight_nr_accesses;
 	dst->weight_age = src->weight_age;
@@ -2098,7 +2100,12 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
-		quota->charged_sz += sz;
+		if (quota->fail_charge_denom)
+			quota->charged_sz += sz_applied +
+				(sz - sz_applied) * quota->fail_charge_num /
+				quota->fail_charge_denom;
+		else
+			quota->charged_sz += sz;
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
-- 
2.47.3

