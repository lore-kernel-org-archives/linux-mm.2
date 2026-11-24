Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA29606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JyRfAap0
Received: by kanga.kvack.org (Postfix)
	id 647246B076D; Tue, 24 Nov 2026 10:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F186B076F; Tue, 24 Nov 2026 10:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535626B0770; Tue, 24 Nov 2026 10:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28B436B076D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEF5940C27
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:56 +0000 (UTC)
X-FDA: 85470415632.20.AA9ECE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F004C100005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyRfAap0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534615;
	b=JSk1oEOmh52KGagVz0V/rCO0lv21Qc1mT0hjzhfCZm2itFdC6Euoi+xPThzJGQz+dVLjtW
	gDaV5LnCk9M4gPlreBG6r4Xuko8BNvH9kfSUusSIFR1SmnUAXRy9IIoNcq0144Nb4yGKKZ
	tEXWmvY0VCPosYUozz4Ej/XvsaE5U9w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmuJ9Iv+Y2OebgTPBnuX4lcS/RA/z9b2R8kNSGeSvs0=;
	b=25OxiAnxJbSq1bVckvY55pHhTkElpVAnsHp5oeTVKJx1AhDES5hkUNW7FeIJ0jKeyiMQxZ
	N2c43mlc4k+8+C3duEBzlkkPyKflp9JapBWSWt/zlZ47OnL2Lf0gw4A+FPmcEIotF4ocL/
	i3b0LYUA/xQG5qyUcZoLUicc5TkpnLo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyRfAap0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 492D140166;
	Tue, 24 Nov 2026 15:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4E91F000CF;
	Tue, 24 Nov 2026 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534613;
	bh=jmuJ9Iv+Y2OebgTPBnuX4lcS/RA/z9b2R8kNSGeSvs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyRfAap0A8L/LEIQXuaPvqvCJJXmBfce9s5HRgtnImaTQYDcikV4AVBzGjr+Orxyc
	 p0WaC1dkD0TFLyh/noPb8Svz4XltcfcmK4yYv6GxDwWOcOrgsQP4vubHa1XIeHuVHG
	 tJZamSUjIlWlbRQG+/Qmy3SRxGiH0iqXxRFAu7rDco0zTSeQVuL/4ZllqKOEKWQJgI
	 V5YzlWQz0jzg/qHZkLnqUVbSil7mqAQaW04S6VJSQapGnKlLkOi4TwI/QCDUB8G8mc
	 ezB6z9NbwlQRwWg6uGyispwvNLXEjC9NJxqSt5JRch0gH1WSJWdcUMY4F9dwSAgE11
	 6B9bkEo/Y1tgg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v2 13/27] mm/damon/core: introduce damon_report_exist()
Date: Tue, 24 Nov 2026 07:36:19 -0800
Message-ID: <20261124153636.91854-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: F004C100005
X-Stat-Signature: q7zw3yrh4fdnm3hnmjfcy4et9y9hqjcn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534614-451502
X-HE-Meta: U2FsdGVkX18D4RN2nbUmrdZJIr5ImbvWGaXIIF4+1S7NdMyv2/9RN5QXd6w8HuNocEXZaupO/Cj9QuySe4lMNMcXsfx9UmSWoNkGnjNZR43e2v/sY/EtMUWN28YXiMd6RnWK/v7dUUGT9iSM5EP9ITQVuqz5RETKMGl8UfdMsLotL/SR0koM1/Zow4A53s3MUi7tdfLcC5g6yB8zLo/TVeLvospbzeL0BBsnQfWMSXccAd4VbIGirotr+TlZhTdei4Of1xuHSkZcqcztFnBu1r4RKHUxJA0ee642gjt94rW+fqs4ZqfUTka6KlBdscAOXBZr1nR7A9jE/LpD1XQVEDcJbGpHk/HdNfr56fLydkfdFPxyVeE1CN25WIbGu5u21J2d3Qrfti5dZIwEHwgMb/sHEhk+xw2RinC9QF/PaEnRStsFsffNe703lNmfZHHLLWkEgoroHnxCdJ74Ao1GRI7TNtxKMAwRjCoGL6/dIMfC5wuQY1bE9YZ1ewVjmUm0mvypS+7av+F8E7xOd7+VFGUbI3VJz2ZUbx8dMI1GUE5LGRGZADAhOTPlxjBOomk3zPGfMeNwFkwKGZSDOpBdOJkni8y2NeNIs1mVxPV86g+wktM7auuG1wZTNxlp9hr44ykvnwsabVgyBCLlfPC6Xew4JOk2X6C01x/APWpsXstkWVYXrm4hvRpcZL6T3TjtHGb7Z9zXIwTqg21iDBtHH6YaIczs2ZNsUi/PRmkm8CWfXgrdVcGvYiqJ1ebmpRGioluP6SJvPuMrNHn7IUycw5gZFKkZS6a8efXjPx6hXFNzol1MBCtJ70KbJoP+pCIiJzGUcbPUyVt+Y4D7gWukEBz5j1rhKI6gBx9ENK+eg0RGb4M3hm1EgCn3+mJ4UIe5ywuwTTRqJyXXsjlQlZcdeu1v2pcT88PfpNhySAxQlDOfrVCePVVacszYd1B8qsgqJtwnOVj70fjrYz4Us0L
 nj3gXsgQ
 o8P1jUpH7C5x8KQhlXguVxi+vCNKXKeGkE6ZnDhxXZOvnyVdRynMBRWwpE0Oei0MT4P3atRsMZyt7BgywP6Esy8lgjSiwf6Mxwfn7ZA7+7a79ctpN4mY5++hmCF8gHjQHIM4kw10l4QTfU2Xp0GgiLNMDLr2LRSNCV2EsQymQJ1AfmWxcxJZBMc+ZxE5H4L3vkq9V5NJEoAffsxUEhexWEQEPf+yGUyI+CHCbXIfLB3Mmmp8lQxjxB36zVKqZoyl+3m/UFYorZU1SrOaiDtjDUg9VR7W0pCH1FJz3AqtGnwYonQGiYxrxLCNJOGdznecqbdIj1zMA901S/p2L6gpEoErjhxXKtdb6AomiMBHBr0GMZgk67s0aLWPuaszRRoDEk6C/gX9+H2z9VXR0vHbQULWC8zvCATaXjZTlca36MKax0G1/NzxwVWVWQckaAsWwLhlxuBijy+gEmOZqTqxu/98wWKyQTe8AgRp2LMaornaL7q/0l06u2FsG7Gfzccsr953rWwc/e6KJqtXqCLIKlEtHHQ==
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

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  3 +++
 mm/damon/core.c       | 46 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9f48f17969d03..38efa41b3d1ab 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1199,6 +1199,9 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_submit_report(struct damon_report *report);
+bool damon_report_exist(enum damon_report_type report_type,
+		struct damon_addr_range *addr_range,
+		unsigned long jiffies_old);
 
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d4a4aca4a831b..9e4c2f7fb5aa8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2392,6 +2392,52 @@ int damon_submit_report(struct damon_report *report)
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

