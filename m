Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88116CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAEA8E0052; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185FE8E0046; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2748E0052; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B36C48E0012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 781D314017F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:17 +0000 (UTC)
X-FDA: 84008892114.01.638930E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D717E20007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+yN6taF;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJnPl/XtL/eWblix2z8kDT6VVCic57F4iSZUfJ2UUjo=;
	b=xVRYeG5oQ1cwtuHdS2kTSpmopRcJFNsiHW/fVGeFYqOGcPdOQW+PSoCurFEWtos7QZrdOV
	0byaBziVxLN2CyUhVHFGRlbQCsEahc4xSv5Ag+MPT+GYWkAvTbUO40XT0qvHPltlKNGi6W
	RCFS8baRiaBReP+fSch4qv8hfayEPDA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+yN6taF;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736436; a=rsa-sha256;
	cv=none;
	b=OX9/SG/nlgYLMN3bKCSugFktGB4j3FOtj6A9K8VquPoAKhonTCLWm9q8Mdoco5d/4Lo3e2
	+fzVt+aotkraEekUt7XR/HT2c4S+ax9DqJiNSQWHmJBRp9ol+jLgcDLqJscgh6N+B5vxdQ
	4dKXw1tvjNbn4jXjdoQ39zkE59PHyKA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93BA24B495;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B48DC116C6;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736434;
	bh=TXnOxLHlQsz7DpkuFGQ5HlVDsoXT2xlK8gPHnzDuxz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+yN6taFSUqSAUEhHtyGiwsy1LGNCf4WWkeAhIcHgVhg0aGsOCyomXhgzmIQyipes
	 3NrAJ+BHdIx1HLjpRkT3VtrnIpPOAmBEQxtw6Fyku1mXu01mSRV76hzup9JESMLldh
	 EoTlJUJkGaM/fupQiVl8U9ukruUe+mn0ZZq955LA+X5TWQnl8GSV+o8QOuk65o7TUY
	 ZPJeGS4IycxdPsPRfefZ4qyY7efkfNnszCFoNtifsZEVNLaHS605y8GihFkkmImCfJ
	 YXiSj2lMD12yJCrKOP1luw3pNEVPzQdMK0q6dAOrpumYRBvdEFPF256fas3AcqQSHb
	 zmu1aLnJSUiWQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/10] mm/damon: add DAMOS quota goal type for per-memcg per-node memory usage
Date: Fri, 17 Oct 2025 14:26:54 -0700
Message-ID: <20251017212706.183502-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4cm1bhzheyz8q1tnf55hgj7zhhnx8ydf
X-Rspamd-Queue-Id: D717E20007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760736435-436269
X-HE-Meta: U2FsdGVkX197aHLO+fNwM3rqQIfgC44y7hn4zz7mROZmJI4Wm5dMDnzTxjCbz30Juvt9u/m+U07uDIHKQmla8w0wK4n/xYKr5hhLdqvf4hIGXGXO5GQ1VZuq00/knXeWsKTJg0f7JznRUcdrVLt6D+vtf40NFxXeACOmNykXna3W7TQ0N3jcAOlpSTu6Fj4lU0w8HBLORbj2jadBTFQTNKUueFxA5hK/IYcZcJCeLVz13DmCWdqkqGfe4OE+yVB402dLzX7gyxCicarimzvITmkbovycIsM3ku/sXPiOw953NndjDLxBrnFyelgW3Tu99ZxW1sfttjtN3orIV3Jbz4N1eq8HTcUp1SzB2gKeoMVc/O2zgzjmfw8hT61T4hVd0m+U9FU1lhtV+FZwuRWXOUDTS5OEytHUzMx1HqKPSFHr+oTkJNyAR2gGwZXzVPZZZlXvvvzzBFHe5MWr5MtZLcU7X8zPR9X+VECauEUhEgtcWXYuVbwp7L7cHDYx0ssiwVikuDbfGgEebLoAqtm54j9R29dn3QyZeyamJT0uVQVnpr+Gsp/DDhr8Tw0QzVVsJsrjYLGDqJHzPH66yyMGKoTJsbDZ1ZxCHbpLMaAsYbJUuEnBThAl/xYVAKQySeh3+3Y8mEKh520F30DJu3Ka4fMkuhAuWQXQfa31PfeCx7rwJBiymDgl7wtIzdW5tZ08qhosFuClVb+XpGQcNmdqTFaLSV68q7toGyMbfN5cSSb5BX8608zIg+Q1ugKL2crvRerdq5D+/okP4JKH2Z9l3AxbQ5TMUzjROnpQ54I0D2Q4++fcUK+xzC+tANCs9gsqVVOYu+VHh5+bk9rqfBxeFTkrFq3ZlcWJttNA5lXIKQsVSY5OWvTzGen37hUXDQdD2UnWZoeoJl3zVM03ecPoDjzWy2JQ6vhFRr1Mn5chq8AGAj3WSOd3ljt76UF6hTz0HbMeJ+Sf344/6GaB4xk
 4oSM3L3d
 AXCK124/0l11m9hG0rhiz/3n9ykAeGYIGzLRWdc6AfZvcxDBpxKL1GF4Z7A6MhW3sG4NwH5e5T8hFfwquWwkY2CSEMFAxNZSq7rFcoCH8gs2Y0jG2wePiOWR5NbYNW65G0SlNDX88LMOG+qbaXDCA3X7DdKnck7hnXa30+5Q5FZdDfjPGK+JwlZQO3mgzTITVpdNHBKArCdRo5+xZRY7hvtns2c54A7g7lQMUbka1PwsekT3kUpErtrhXVB6BWHhEf5niMY9xmgUjLyw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define a new DAMOS quota auto-tuning target metric for per-cgroup
per-node memory usage.  For specifying the cgroup of the interest, add a
field, namely memcg_id, to damos_quota_goal struct.

Note that this commit is only implementing the interface.  The handling
of the interface (the metric value calculation) will be implemented in
the following commit.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index bb92c5f396cf..862531f1a379 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -147,6 +147,7 @@ enum damos_action {
  * @DAMOS_QUOTA_SOME_MEM_PSI_US:	System level some memory PSI in us.
  * @DAMOS_QUOTA_NODE_MEM_USED_BP:	MemUsed ratio of a node.
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
+ * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -156,6 +157,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_SOME_MEM_PSI_US,
 	DAMOS_QUOTA_NODE_MEM_USED_BP,
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
+	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -166,6 +168,7 @@ enum damos_quota_goal_metric {
  * @current_value:	Current value of @metric.
  * @last_psi_total:	Last measured total PSI
  * @nid:		Node id.
+ * @memcg_id:		Memcg id.
  * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
@@ -179,6 +182,9 @@ enum damos_quota_goal_metric {
  *
  * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
  * id of the target node to account the used/free memory.
+ *
+ * If @metric is DAMOS_QUOTA_NODE_MEMCG_USED_BP, @nid and @memcg_id represents
+ * the node id and the cgroup to account the used memory for.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
@@ -187,7 +193,10 @@ struct damos_quota_goal {
 	/* metric-dependent fields */
 	union {
 		u64 last_psi_total;
-		int nid;
+		struct {
+			int nid;
+			unsigned short memcg_id;
+		};
 	};
 	struct list_head list;
 };
-- 
2.47.3

