Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A4F0CD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD686B0096; Fri, 22 May 2026 10:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464C66B009E; Fri, 22 May 2026 10:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290C56B0096; Fri, 22 May 2026 10:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDF36B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:56:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6A0640AAB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:55:59 +0000 (UTC)
X-FDA: 84795355638.15.8F8740F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD8C5120008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:55:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779461758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B5NjIc5aSMhkiDPWXmT+gZJN2lVyLKf/TmrAtxIfc2w=;
	b=Zj34621trAnGEMdS6x+NiMp8AZT+9fpXgIqpjJVSE0DTMRZxWCnN7dPiUK/fmjUSsoDLe9
	HKM+zapzJ0u/B9K28/DAQiBz+GE1xLMJKs0VdmFdSI+yP4x8qQFd1urlyIbJhRK0F5rtgO
	jqsOCKJ562QOhnscoR7G4hJ4aWXv+hE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779461758; a=rsa-sha256;
	cv=none;
	b=384DPvwbnAtXaFgkgXUFolTvZNF1RP9Wdrrgnpo92hoVEhvfLaBrMh6XsaJG3DXq19+ASp
	TxIQMcn5gXaxTrDGwRdow0dKPmuUnVlWMUy2cTtldB7iIsoeRT0tpM+CRoWIUgaHCBiG2Q
	TU89bXGG8nTEWfYktEiKdCaLS2BtSek=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gMSxW09mfzJ46DW;
	Fri, 22 May 2026 22:55:11 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D36D40569;
	Fri, 22 May 2026 22:55:54 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 May 2026 17:55:54 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 2/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Fri, 22 May 2026 14:55:16 +0000
Message-ID: <20260522145518.158910-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260522145518.158910-1-gutierrez.asier@huawei-partners.com>
References: <20260522145518.158910-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: kqh3u1spiwpa7m1czryyjeqy1gsbgf37
X-Rspamd-Queue-Id: BD8C5120008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779461757-995349
X-HE-Meta: U2FsdGVkX1+lpqtixtyV7l5xq4IoXNb8KSmzCdWpmXTiBTJG7nJIjoXosOnwt3X6sPpNUfw1uNg2V2vIDJEwCv4qJtP2F1cG0y6q9rAgO06ok6TCeUZ9gQ+PtuiJD83TSiDpGRmzFZILR1nd9fZSvtKrHoYMcD6ofgVsBiE0SxQyib1crb25dm985XmDRl5Rf3xt2y3sOnrKy+H8plMdjD2962pYTnk3Dt+tPauqXjFWb1Q8IEarPfaQMwJv9um5gbHoyqlppWtHhmDNul1dYs4ClktyiqMTQNu+F2rRB0M5W7l/lz6kJmCwqonQG9I0ngVDLjJVjteXygSn2KDiGQ+kz+h76o0vrVaubaBUuh8kst8NMsMrhn8aLPsqmo4Yq8nsxMi2MKivvDV+n8J3AvU7fHjD+mwh1dcRXUCxFPHJ1kXm5PEQJh3l3+RnTtIodcqBi3MiahEjEoWo4g+nrJastIWQtw9s9ABiRNyOYYcONinnmyEMNsRJlmESUZ6vDSxqPn7DeLX+u6pgtfgxhW/Akelk8pXApmqM6ClRGtxu3C9zLqj1Pk3XNvYm5GHJZ6MwDmirjaV5NT6zFO3rnA4fSkLe5XVTxEnC4pdViffeLSD3I7GlNkmhV0as9PaXyMDLHmSTlxZxDqtBUYlp7nKoLDi6YWEm39ed1lFJIAD6gBJnLek1/mWSDh+F3J0tMkFWui6+lTB2eAz53DD2Xaw579I6eSJKywrXCrjL2u6AMIpRmO5DF1q7meUfC20JAJ9l/UAG1SBgtxBBMppMEouNsAwB/jU+I+M8UssDcCrMJ2O8uaJtrivMY1UpfBLMfxnI9vWYmmB/TqaJ+8vm4+WRXlBBvv9gvrz0eLN1dlXvPePIbtLS3kfsn7hPUQIuTgM8hX13YqRPjNhUUT54GQxQFLlubWvi88P2o4pJuU5RMhYs0TUFrqZdont0kzjn/0cRhvnrUk8Qti8qhbQ
 1LCSPXM9
 +rNrb+RAajTYtI4iNazo+Tr+7kDN2b492dd634ierTmEdvFIQkS1PF/zM/F1blfIhKEyaiT0uuVOzkmY/s+vhiM59RZ5VTBvV5EQDpbRhoERkNMk5oYdyQSRgre+HSxb1JE4u8dvJXtTiL2WdWozbEI+jfaz8EqjKp3KQdPOw7vXdw4PURoCgSAo6NnQ0YrRO35OkJ5IBYulHlOnGqBe/U4KBSuy9L4ux2AO4XGNaSKwJ/YjjNItY3F4IQ92gZrdjarMPfFkqGrsIb9xxyDuN1wyMVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a new DAMOS quota goal
metric to measure the amount of huge page consumption to total
anonymous memory consumption ratio.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

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
index 9f38deddcb30..1f1cf10aa241 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2536,6 +2536,18 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
+/*
+ * Returns anon hugepage memory to total anon memory use ratio.
+ */
+static unsigned int damos_get_used_hugepage_mem_bp(void)
+{
+	unsigned long used_hugepages, total_used;
+ 
+	used_hugepages = global_node_page_state(NR_ANON_THPS);
+	total_used = global_node_page_state(NR_ANON_MAPPED);
+	return mult_frac(used_hugepages, 10000, total_used);
+}
+
 static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		struct damos *s, struct damos_quota_goal *goal)
 {
@@ -2567,6 +2579,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
 				goal->nid);
 		break;
+	case DAMOS_QUOTA_HUGEPAGE:
+		goal->current_value = damos_get_used_hugepage_mem_bp();
+		break;
 	default:
 		break;
 	}
-- 
2.43.0


