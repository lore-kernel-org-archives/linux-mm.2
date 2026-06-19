Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70251CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659E16B0093; Fri, 19 Jun 2026 10:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595BA6B0095; Fri, 19 Jun 2026 10:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB036B0096; Fri, 19 Jun 2026 10:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 131036B0093
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:59:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B3BCA046B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:59:29 +0000 (UTC)
X-FDA: 84896970858.11.2D5C828
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id B12331C000C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:59:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781881167;
	b=mufmJjNgwyna31DhSXDuS+SpkKaND3SZuIXKi3bH4fk8q/TH1f1A5mDKjCp6HCpPNzFsas
	1Z76TQb40vuL+R+MCyOQkXZ/qtOTBHuU8GOoHddP5pwy8m7ZpF5Se6vIMp4LpFUf4xnGVK
	S1PZA5WewZuPqCeflOPPqPB1irCdgB0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781881167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dyoptq84kbiYGZxXdDTNQ4jsK0B91qWmdg3zEG4tts4=;
	b=RVN42+Q4iLDqk0dGFvCl7u+zkINViraS3ogKVHM6jNRuEELUziZwTn2r2O81KVf6kmvk67
	mOuvjGntXnqh9IN7vXnvGerndh9H2gcha6SpWdH1n/zrjR2ogif/cErEBa1Cd41H0+FX+B
	0jfGuhr5XA97HF+SECTycJwNA2M6KVQ=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ghghz5kTjzHnGdn;
	Fri, 19 Jun 2026 22:58:59 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 4AE5840571;
	Fri, 19 Jun 2026 22:59:22 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Jun 2026 17:59:21 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Fri, 19 Jun 2026 14:58:19 +0000
Message-ID: <20260619145821.2109933-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260619145821.2109933-1-gutierrez.asier@huawei-partners.com>
References: <20260619145821.2109933-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B12331C000C
X-Stat-Signature: r5t8o7ny34wxyza3x3e1sjmcua6w91ut
X-HE-Tag: 1781881167-38176
X-HE-Meta: U2FsdGVkX1+5RFUyopRs2sCrHnm4JzfIdoFymFFeikB9ysP0M019pSswV1B1/4SBf5MqZC/2ynnCNr6oDUPW8oANUAPwsnRnWVMW7aIwl/q1GrH6WcSmA6yGr72KigapmW5IFjip2vKm+Y1opN1wkEUfNLLlL2NapKGawEF8yzlqSPOzvfiiZ9Sf1RLLhKiohOknycXBZfxaryvaEY//NonBzbBLpQBJQPpZZZ8HDNGFEB4pJYK0OYTqd+vWpobsfcFeC2NW2kvDsC9GNxWJP84hRPZoTcXqSWL/FrBSnyT++iaqk1DcT1mtoh3hbdj5xz6zk3VYXQzvkuRA4tU6e7I3pcSFKQkRks7Y+IRumDvSsGjBUpze0UZEacDJ4ZGubpsMrYQSNUpBCCLZibNDFy4gVQUkvqVbdVgsP6gbtahtrWyYfiBuYvSxekLjvKHT5Dyh+QoJPNrg7b5cJluULwRinL+AG6ZV/xw6U4BSK3zFAr2R+sxXwi0czfl1Qt399td3KPM/Mt30Ikrk8oo7hnHG1GyhfB5GIn25R6NBItH2EFgwGONuRu3OjV21dsLLRmMYl+o1ZAwjJzuD8Fp8zEXGe/D3+gHccrpuVjhxD7HKYCULx8hjjHzgyIA66sCkPbhPG9qJRXbiOxEEgpa4q7qOfdWJEBgzqhs/7I7gavgMfhzJs2AgX2lvp6M2OUfIRtEjRaqo68D9DYwNMQZHm3Zl15/RxcYLK0M1uxkLYMZlD43U9dVm5P1xsgt21VryS3GuzSFjZ2TQ+VKppKbs6zf22SlA1zs8/N+lzWL/jVk1AJ4ovBtbtvql00nELqa3JxTK0kf1GYssY/q/v+vtwuQkje3v8QP2tqQ7TUDoTpVJSTM/A1Q4egmXGVH0xw0ODuskatUIhM1IMeKCxfFgJjPX0mc6QG6keRQz7wSowdqT01zGwoXd7BYyJr0FeOngpZtzo2SVoQANeXx7Zgr
 zvnNLAXh
 LJncRPABNyy2vuc72IPHmJMpmLMFpwC9lyoIb22EMULQ9Os4wztoLx+SQ2jw06/jIKwGHCD69xT6sQDtjAxrqKSiF+TP05M/iQgldsxZ+A36S3dGkgeJMdEv4Wjtc+NAX/pd5ZeDWKJleXfGVjbb5SXWecvyQH4pX5fewJGVz5KWdJTtAwMjPaUPWUtkdOES3fhNpvkvidqwlS4YGDJnDByU/BDODhgxAGjobVlxoRwuUoLzoDBbxmjJxqIjoS3mg7y7WNKQx/0yYA58palPtFcLPTX8mQFQPLWSFsZNLwlmEq0i1ZVYejq56M8X1TAdGpb+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP auto tuning. Add a new
DAMOS quota goal metric to measure the amount of huge page
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


