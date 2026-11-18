Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF8B606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBm1PT2C
Received: by kanga.kvack.org (Postfix)
	id F2ED56B05C9; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B1D6B05CC; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC276B05C9; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1A86B05C8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 230EAA064D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
X-FDA: 85446641238.06.E30C625
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 918AA40005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QBm1PT2C;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968557;
	b=vwUqmMynccTqOcJ4j29zgZupbV+VkdChEkWGY6tB/qiL+bjbDMLTSPbmCsjgYLFUtyQwrX
	eixxK0LqRH1d4CfHqf3H3Y9kbgtfsuE4ojvCKbjrSLbf20Bds61TFwcuS2nZSPtS6QI2e0
	NvIHgBgRpheLKsyxbcn3CZw2Dv+Xewk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QBm1PT2C;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2CJN5Z4knyWoRn+4HcxQAux1m0Ndp9v4aXp0+mY1es=;
	b=bkV1+E0ISRGM+9M1jj0isNYYmxpDp8RAc2JbLNa2PAVNeqfL5VMSSQZLOjSvaSq/9zTYTt
	N/5ETaNe3IVpuL3skirvJQM5zqZfCKV+C6e1QMlESre8mYHX/5i2knY/AnW1rhARK+r7ny
	de2mXCBL85/CE28trnVAUNlmE6RqfMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26E8261F34;
	Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9ADE1F000D2;
	Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968557;
	bh=X2CJN5Z4knyWoRn+4HcxQAux1m0Ndp9v4aXp0+mY1es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBm1PT2CZVlNnta4Yjgf2hz8Rhy1eICxrk9vhUOOR5D0IDgx/LDc/TUZfCaFQJFQj
	 wNFuXL8Rp5LhsOUzMkO9XrfC6H5oIxdvBQj4Pu3Q2I+5XIbggwskFwFDY9XXK1bOmL
	 A9BbepvVMFw2aMhq7l704S/1Q+DC1lIacrC1EX9mZLAP3UMfFhaMMslZZj/6Xniu1n
	 zEvgR/tf8o6gpTSrJlKbvHL4utgggelCtlKwiEHTU2xQAauK3qI7OflE0mJ4lkBcPK
	 2DdbIOvxHP+AbFLMWTdO/RpHC72TP2ErwvcRIZpRed5qC8vkujC0OVtKevUgpNDBFf
	 ETilah6IwObJQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 13/27] mm/damon/core: introduce damon_report_exist()
Date: Tue, 17 Nov 2026 18:22:08 -0800
Message-ID: <20261118022225.100659-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 918AA40005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6yry47o3qctguq45e8uzsj5n1jpjmip5
X-Rspam-User: 
X-HE-Tag: 1794968557-416417
X-HE-Meta: U2FsdGVkX1+4eQy0YKhV5XQyYEBWR6xvvEplt+4g/DS9kU01qVK3KBDIHy1NY7VkT5OVEL/NnqnzK9XlaFYQQX2LPhU4UiXvu+PtBE/Lh9udCeJCZRrq/mwVzK5UjP6ryiRLt074Cw9Q0y1wTnjenl41i96pfi2vc4vPeVgAN5RML2ByzMP+h1Bp+2pcihsUfbYV1TkhTSZ3c/cBbXwtI7RUjstChLuNs7JTjGsGYnQcUBEV2B3z2sv2oOwKP8NMfw9BxNLyKm4vztpyYmifm4hAUiBXMbwbuC6xUvBzXd2AyeX0mloSGRM1JDJ/Q4rWOeSZtHYMCklTsv5j5bCnlM0xTMTMQ1rbHPJyxFoIVVDnrwwKzM6CtkEJN+zDTw2cdykpDLETaIY/cDdp21FTCJP2mKclCHaunqciseKDKBROIcHNsy9bGre7OKoF8u4j+oriqerbgSgvJxRKgCVl+0/2U0uTfL6QYfGhCo1WP3eW7PLJ8L2PmS58fGwLkofg6cEeueQcooFmYbk3aMSXs1BIvfRsAavS0GkgjmN5PD6AAQHyW7kHkEf/008MpNG/CBvqfmnp7HJkAsi2eSX3CuMyp6/7batFPA6Vp5l8aaXSgp6kaIBT7ZfLx3ivDprAuqvsOYaOBDT03IFLwcyv1htbCauqNomzU0ZGoVZ2gOJoi7DZUeSMuUtV4Gq0TnkXkaTUcgfUNnl/afpjpfFniFLEN5hjeSmnNFaj7iyLBybfrdcbE8LwiTdbHWYYzxlbww3hFD4v25AvqLXGYO5P3z2QiAfNzs4nNlbQKbkE7cDJgwxP2pDkr4PHJiSPukv7R1jl+Mk8w1hgaQh4B/6ZGF1Enz51Kkk1dbD/rTH0yQZraCDFHlraTd4V4UXmeBy9EOX4j4Kk39GAQe5cUEDCH8l3iXJC146VWtI1JNCYzvilG3CpE0l++YjwB5pMf2quuhftu98KP1PAuxdwI9h
 yMa4zXN4
 LhH2Ak1tOtJbA55YXupEJgeTN25+WlFzle102PWHzrpaY8ilY/Fahfl5sfVfIACqmbLksuyikNUITp+5CeGH/bZiIY9GsHbbGLmGWfkV4X8UtiKrNYz+vSu601RcbHLb/xelg0IeiYeEAAkDcGrRADjHiZIPP1TgbIj7k48BYC14vesbRv1EUf6gG2Pmq1xYCycjGiPCPImxE6KLIQ1XFRRz2O51TDH9lWEgoVKZh4Fwd+ck7gBaqCm64ZSF8zjPjEn4R3Pu/5yqmN8zsrd8JNMXINQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement and expose a new DAMON API function for searching data
attribute reports from the report queue.  The purpose is to let
operation sets use it for supporting the REPORT_MADE type probe filters.

The caller can specify the type, associated memory address range, and
the creation time range of reports to search.

The function uses CAS-based try-locking for the mutual-exclusive
synchronization.  If any parallel access to the queue is detected, it
forgives searching.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  3 +++
 mm/damon/core.c       | 46 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 09f0dfbde8966..fc84cb9cf5bd9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1193,6 +1193,9 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_submit_report(struct damon_report *report);
+bool damon_report_exist(enum damon_report_type report_type,
+		struct damon_addr_range *addr_range,
+		unsigned long jiffies_old);
 
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 24729be5ec4e6..4aa4852f51035 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2389,6 +2389,52 @@ int damon_submit_report(struct damon_report *report)
 	return 0;
 }
 
+/**
+ * damon_report_exist() - Find if a report of a given condition exists.
+ *
+ * @report_type:	Type of the report.
+ * @addr_range:		Address range of the report.
+ * @jiffies_old:	Oldest jiffies to find the report for.
+ *
+ * Returns true if the report is found, false otherwise.
+ */
+bool damon_report_exist(enum damon_report_type report_type,
+		struct damon_addr_range *addr_range, unsigned long jiffies_old)
+{
+	struct damon_report_queue *queue;
+	int lock_old_val;
+	unsigned int idx, nr_read;
+	struct damon_report *report;
+	bool found = false;
+
+	queue = &damon_report_queue;
+	lock_old_val = atomic_cmpxchg(&queue->lock, 0, 1);
+
+	if (lock_old_val)
+		return false;
+	idx = queue->tail;
+	for (nr_read = 0; nr_read < queue->nr_reports; nr_read++) {
+		if (idx)
+			idx--;
+		else
+			idx = queue->size - 1;
+		report = &queue->reports[idx];
+
+		if (time_before(report->jiffies, jiffies_old))
+			break;
+		if (report->type != report_type)
+			continue;
+		if (addr_range->end <= report->addr_range.start ||
+				report->addr_range.end <= addr_range->start)
+			continue;
+		found = true;
+		break;
+	}
+
+	atomic_cmpxchg(&queue->lock, 1, 0);
+	return found;
+}
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
-- 
2.47.3

