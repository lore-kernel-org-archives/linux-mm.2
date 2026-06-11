Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52757CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36116B0005; Thu, 11 Jun 2026 11:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0DF16B0088; Thu, 11 Jun 2026 11:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B4C6B008C; Thu, 11 Jun 2026 11:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 846F96B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:03:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 287E0A0655
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:44 +0000 (UTC)
X-FDA: 84867951168.17.7B5A6C2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 399CC12000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf29.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781190221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fH3mu04ua5VasazXQowPEwUFQ6OcLf026KzqG24CILU=;
	b=FAyLjNOsQyDQevYuKP+nv5esUYAILSVYIWqPWZi75AqSl/rGzEyB2PZH5LHlh34Z/679/h
	goL6fklaiQDCxpJqkDuUNcgtxpOfaAXAuBDxqlxYZpzAx85K/msGMMzpaXaU9VOpVcDtpN
	2IspntOuw20zVzl/3eyamA+b+LdwxlI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf29.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781190221;
	b=zMPcl9l5MZpe1eclR/xUMwcEimy6rA52ArCEoD0T8rnEWgQALQZTbGIRDYDpSFO3A5aSIK
	waqxIIc6HwHyAIFxl6VlYvMu5jGww34oWGK38Q9ZLVl2AW7h77VHZ2VuLT55Kgkh2dQrcF
	q2XPq7tgAUiHQ9JA9EAsWDotaxT7Lz0=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gbm9v5G6nzHnGkJ;
	Thu, 11 Jun 2026 23:03:31 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 53EED40575;
	Thu, 11 Jun 2026 23:03:38 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 18:03:37 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 1/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Thu, 11 Jun 2026 15:02:41 +0000
Message-ID: <20260611150244.3454699-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
References: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ubwij6yah4ydwjjc68p1btmzr846aaxp
X-Rspamd-Queue-Id: 399CC12000B
X-HE-Tag: 1781190221-204692
X-HE-Meta: U2FsdGVkX1+K3hWqA1t+GwGPNX93WcNP0VpNduL8rEvUAaDpGTviKjgMYLyWM8sY/AmyLUItcHQ0vyE6D20jFCgM0mU/VX6WRA7OLIW4G104xemay0UbvJb4sARBRsP+Ba3L2zKZyyprzOjjYrEFnhVhh7rgIA/iioz/dagpUchuue6RuIas/JujwouTNvgqyprko9i6XxqCQ/iO/zHlPdiDB801CQc/AvubMNb/sr4eCSC9RuvlbRCluByNerTMbJLJHbZEpdZ8E+WA3c4Evt9QgZ7v6YkQGTB01iqhJfW35RFi0kRBTp1ctvACww2fStG4XEaSo2q0r4LujVEIiE3zrPdLqXzpmJu68xhBov8nIsKtPfAW8tNOnKJ+f5gd1r3gUCReZna6Iul6CsAcXj2wnsWe499cntDtFiSFFNPi/lgKKgIJMWeqeUBlhxehKda2f+B7XySficsEv+ffCD4oVQ2b9KXd56gmFfhrzZOo4m2/GEp3IBswv9QD3XxQdAHn5bpbaeS6V/ObIbNljDK7vyQH3lWUW2GktAfWv4JwMg8F4hlgwQ7dsWwGerkihqQG7Qdg7SKDtGEKVlIj5PQSGNyH8s0RVGocQB6/REMa9vYGZzuAGIMU6meaqWf3SVogUhjVgVHefyFr3+K/2QReHDavkYJc9GwgQeA1yWKyyGAU/FJUke+7eauT0707f+1L2Lzh0u/XXKDmQ4mUIHHUGXAb++9GvmKHqRDP1kquJEGbPm1CWKJGSftnFFfFlwU29vU+QTVEl4+wfQmoEPKs05De5LKGgZevmnfusM+u2ibREvy+bhPCM9zmEg9OfhD5IdUWAqY4H7neT4qWdhDel4L4z9FNnMOqiI/Uan/0rxP4oSHGTBFkWZwGB59Uw4j0BZG3iDJ2rkrI6XH4Noji2igpLT95a+X+A11bz0AluKvs4lXPRe8hf6n5RQi/D1qIRtG47tA0fEpBi0Q
 AcbkhAbN
 Fk1un/uZ01AtAxUDy8sQ7aJv24+Xw+zZOyrIAsoLpK99+IJDb2jDFm/rYcLY58Y+f7bEYFIk0ToriJ9NsVyre4hX4U55avfkj32tH4PBXFAqQVKljlNA6gkiQoKoLBLBdOWdY0ovZSqFCQgp+haoiQhoju4cJXPhfk0OIQQKx75HtXuYZ+/LEAV4xb6a7R+VZloqW4mEH2fZQZMTxGisvma57nYNIF32ELUmlEGgzhTuxwrNHtJoJJqCSY5iXWDdEiG7RSVpTuXtPOPaTDpwTYeCk//Xkreh1IaL49r9Snh7nCl2WezKUdFKMIMEa0lHLOfDw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a new DAMOS
quota goal metric to measure the amount of huge page
consumption to total memory consumption ratio.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6f7edb3590ef..23a9cec05033 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -162,6 +162,7 @@ enum damos_action {
  * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
  * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
  *					node in basis points (0-10000).
+ * @DAMOS_QUOTA_HUGEPAGE_MEM_BP:	Huge page to total used memory ratio.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -176,6 +177,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+	DAMOS_QUOTA_HUGEPAGE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e4b9affc5b0..b001f80681b1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2795,6 +2795,17 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
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
@@ -2826,6 +2837,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
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
2.43.0


