Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C150CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 15:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B196B0096; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472B76B0095; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DC3E6B0098; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 253836B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DF51160153
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:04:38 +0000 (UTC)
X-FDA: 84842551878.22.A2C9BBB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 674D214001B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:04:29 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780585469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HudAFG/Ern9fDRlBBQ6m2/knYAiLXOw0v8RTPwWCmtk=;
	b=LvfIulPB7Ak8gY0sy7Kktj+0rAmLFtEo/5xi6VdmaZnjpsE7KNgVnHRRMo4qIQm10BjhpN
	6C/Ue8hYvMZwdB8qpWqOq9l04RJHndXzYoIxZlKgvkBBBdftFuMQamuonm06pY3a5770oy
	v72Domz6RPGDgu4k82xg0WyqKA84xdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780585469;
	b=VpMYEUtZFWG1U5pwYk+jK6vqcyUa+GSU12dmMr7capGEKfexoCKe3dADql2WN1opm72dTD
	6nhnx7V4dWaIV07fp4HL1Q0YNR8UQ9AtwgRMAa/Ao9Z3oIwNxkQYZKRWSSSovgTZt97VAL
	V30hKnioXvB2jFb3tw1OL70Tb6onUtM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gWSW75cDQzHnGjF;
	Thu,  4 Jun 2026 23:03:31 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 78C9A40569;
	Thu,  4 Jun 2026 23:04:25 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Jun 2026 18:04:25 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 1/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Thu, 4 Jun 2026 15:03:34 +0000
Message-ID: <20260604150338.501128-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604150338.501128-1-gutierrez.asier@huawei-partners.com>
References: <20260604150338.501128-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-HE-Tag: 1780585469-944968
X-HE-Meta: U2FsdGVkX18kKg9f4zmuWF3NIgSqJDo3RLc2fNVQYvfcXwx+dFVjIJaHpk4rhnu0XLM5EFrDQ42vjrnyHSNQD8PWaYWgPHBrXk2UfWndi4nNQqZRoyz2kGI6TuxjM1cGkFKnhm13hO0LsOhEpZHeciSsjLM67GD+SIXwgk/wo9XZhFIjrWxvi/M0oyco0M15l+dJ1l2TU9OZiAtEVPzaXzfQnfdhLQAA+Dg7M157n0zjKQw7tHRn00Uu44cdbe/qt8qQ/WisiMK9QeFw84nKHmhBzjxtssRwJtFLEe0xOtQqPzZRrcSyCN3q6TSETcGeVFuHXrO5Ngw5D/tB1CLL3K/mF7GCKK1jvJScYLEzjOcAerYfSxSif1nb14xDlORSWi7ot90VlOwilAHlg2fNz09d18v8j76A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a
new DAMOS quota goal metric to measure the amount of huge
page consumption to total anonymous memory consumption
ratio.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c7a31572689b..8e15a674e893 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -177,6 +177,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+	DAMOS_QUOTA_HUGEPAGE,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9f38deddcb30..7fc7477a353a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2536,6 +2536,17 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
+static unsigned int damos_hugepage_mem_bp(void)
+{
+	unsigned long thp, total;
+
+	thp = global_node_page_state(NR_ANON_THPS) +
+				global_node_page_state(NR_SHMEM_THPS) +
+				global_node_page_state(NR_FILE_THPS);
+	total = totalram_pages() - global_zone_page_state(NR_FREE_PAGES);
+	return mult_frac(thp, 10000, total);
+}
+
 static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		struct damos *s, struct damos_quota_goal *goal)
 {
@@ -2567,6 +2578,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
 				goal->nid);
 		break;
+	case DAMOS_QUOTA_HUGEPAGE:
+		goal->current_value = damos_hugepage_mem_bp();
+		break;
 	default:
 		break;
 	}
-- 
2.43.0


