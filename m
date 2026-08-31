Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134D8C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD486B008A; Mon, 31 Aug 2026 10:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D736B008C; Mon, 31 Aug 2026 10:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7516B0092; Mon, 31 Aug 2026 10:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3BD6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:47:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CAA0A0190
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:47:44 +0000 (UTC)
X-FDA: 85161843648.18.E0A497D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD0D92000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:47:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ayKS20LB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788187662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7QxbQi+gC20oHgrgxjKQCFyg8T7bvReTsftzDUfUgA=;
	b=XQjKMjWgZ4N2uqU8nQnL5rdlxbdGuRHtjkU1DDO29crmZdqB809kM2L+32R2vs8crqAtfL
	hdDgzI+TYWw955hzXHr9MiHULjNZuTeBOSZWnL7D71GPsAaitAhVJAKX0CVuloqizzR5QE
	Qpox6odpnBral8YUKhzSXYgaPikWT3M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ayKS20LB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788187662;
	b=fx8myKCodCyak5gTQHRdkXgHyo/rKEyLqjetQc+A+TvK1PzM+esJHWqeSSDrHHB8FF/CHZ
	DWUOfMkdv5X0ehuHxiAiiJ9qLYOfeQwo/IL6Ad+wtMZarTOWY3PsWrPR3ZyFnfEap6ef14
	vNgGrs5rn1BXv7gBF+7Nsnca3P1yD+w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB30C41792;
	Mon, 31 Aug 2026 14:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCA11F00A3D;
	Mon, 31 Aug 2026 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788187661;
	bh=y7QxbQi+gC20oHgrgxjKQCFyg8T7bvReTsftzDUfUgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayKS20LBXIFl8eNB8eN8Ldo+Xx6A76IS7z/PhNTKyHRafXBFPrVQRCb5g/RSPghgQ
	 HRUqWyhztebBCMmmrxbWjs4B+ZNnQuNdtkVGFWkSv2RTJ23zJC8/v66iHXb436s7Ft
	 FttTfy6Y/XFrVrznJBcvlpNj6xkSe9uaCmabeVB6FSYSQ+BmeGRcYbJe28X6yk6gWB
	 oRHEJ5iSDX11osGi+YUCxlNtKx4/VVJvHORmAd1IDkXjw9Wlm3gejpibC8c/2ZGzmf
	 71RfK4ZigJQvcPRq2NqCD2njbNgCxxI0FgKE+HMCzmigvQnE2JkExguDLrQ4Cdting
	 lRWNHznwyaOFQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Mon, 31 Aug 2026 07:47:28 -0700
Message-ID: <20260831144732.80910-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831144732.80910-1-sj@kernel.org>
References: <20260831144732.80910-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3qoqca9k7bh8eufnqgjg7shg6gryywcd
X-Rspamd-Queue-Id: CD0D92000F
X-HE-Tag: 1788187662-155745
X-HE-Meta: U2FsdGVkX1+OW2l7CABGCpSAlxT+Ue+BnVqET3pJWlMAhcRskwL0RovKAiHVaQpwVqxjkpExXukHp5oafTeJk7/c1KzRI+C3Bwo/6+KqXEa5fmwwv1Mox1Xtnz7kO6IhrEdxnlY+TusNTPlGooox6sSEucDBNU4WWzCp3vkGYjxhqLqiiKYbL6nGSJc0K+jNvJT6QV0H7teNv9ZvDs8RRxORGr9H6eGULYCRMKNRssqUpqEjHTbpIlM4tzHZWqV1Lf9RvNDgohoFonhZk3r+4/7GYFVO2lDwbdnxTioYbUmVrjFVbV5PQcLz2XLiLSRvyl6Ij6OUVcfqgy5MjZNMSMOsxKtK707HFr2Ttpq2XvfGxpDK4mk9bLRPvuYYHIOcC1e+U0RpJZVPGYuoCE5YuHB2aNQk9bM49AGcDccLB61KFjU4ScOU+4Qxfd5GZALhBV1xTmFW1LPrakhd7Bc6bUzBjq5h+WMVxVhaYqyzedbMzVOa3ioEY6eKQNXrNy4Wvb/xfU4UQQX2Gv00anxD8UhGDT4OuMBdpFiAh7ETYlHO6BE/egYWv6AM5vew2/fqoWx1dlnt8ULpikukxZWT7WUdYdPM1ZZjz44EpHb1YVNMRihTFDCfjQgd4I3vHLfhk3w1P2d0xK6XANH/JWoTko96ZZFtC63c8R1gbBl35oP59+zlSVJuFoOg4Hur2rozZLXzLMz61NR9mWGWBTKi9EZ5mQffdpviZCv7z3R82wyk9raeHZP9/sEDWhUtaEYWvIFRooNLec+dygsLHzzETe7dU9o4dOxj24Z/VU9uJqSp3/uXPqogReC6xUhufXYi/xjqwK6yYuCq2qiw+qm5qWdT7OcsOmX/HZvzKMQjkWvnL8y3LS3p316arw/mp4KrwGZgXnlrl7o3cn8HrpupdwX7PMDJtFu8PoP/XGfLoMZzBdfYgsMXC1HR2+PgUayuwejCcOuLq6aZpldll+q
 Hjf019QS
 F/KMxCB5znSvwe5KuiGUPz6H5OwJtrDtAiPTni53prB49FfbMjVB6D8tLUiHRg3hfoOlOpxvkzpguXPClOWWgu65STQawJvOOFa//b7ADX/GdxNQbm+rSmnaTYwHzoVSpz7D9uehUs5RzCW021+Cmw3rIjiun/mZbDwH5g/fg5j9Dk2+EXY7BxraZ/h0hu/7t4tSSfCsAaF6uuNqyicNzgLkr1EYyyijDIeu4nrgeXHD5lWaePAtxLdA3VE8GSY2JErXPZE5hpGvdb0HQzFytw0upr50XOCV+W5Bw3dfs7U8ZTH3XjpSMY+Y4a0IHAg59B1ri/gu2jFEkNm9qacfzIuuXug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP auto tuning. Add a new DAMOS quota
goal metric to measure the amount of huge page consumption to total
memory consumption ratio.

Vmstat may lag, which in some cases may lead to NR_FREE_PAGES being
greater than or equal to the amount of RAM in the system. A guard is
added to avoid the extremely unlikely case [1]. In the case, return 100%
(10000 bp).

[1] https://lore.kernel.org/all/20260715151615.99767-1-sj@kernel.org/

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 5607f98ec6306..310509455db13 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -153,6 +153,7 @@ enum damos_action {
  * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
  * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
  *					node in basis points (0-10000).
+ * @DAMOS_QUOTA_HUGEPAGE_MEM_BP:	Huge page to total used memory ratio.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -167,6 +168,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+	DAMOS_QUOTA_HUGEPAGE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index a5ea3e61e7f41..3fa1b096c8330 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3038,6 +3038,22 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
+static unsigned int damos_hugepage_mem_bp(void)
+{
+	unsigned long thp, total_pages, free_pages;
+
+	total_pages = totalram_pages();
+	free_pages = global_zone_page_state(NR_FREE_PAGES);
+
+	if (total_pages <= free_pages)
+		return 10000;
+
+	thp = global_node_page_state(NR_ANON_THPS) +
+				global_node_page_state(NR_SHMEM_THPS) +
+				global_node_page_state(NR_FILE_THPS);
+	return mult_frac(thp, 10000, total_pages - free_pages);
+}
+
 static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		struct damos *s, struct damos_quota_goal *goal)
 {
@@ -3074,6 +3090,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
 				goal->nid);
 		break;
+	case DAMOS_QUOTA_HUGEPAGE_MEM_BP:
+		goal->current_value = damos_hugepage_mem_bp();
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

