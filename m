Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C96E606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ym04wGz1
Received: by kanga.kvack.org (Postfix)
	id 2B7BA6B05C2; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268EE6B05C4; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6E96B05C5; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D812D6B05C2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DDE2A8357
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
X-FDA: 85438492818.16.8607429
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A4CF210000B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ym04wGz1;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UD++Ozuyu/iWISz61QHAnkrLOx0dOy248fDd7IudnkI=;
	b=qz9hB1l0tGQRSjaNNwSYNkR5kI5POTDZL67hQPbi0SayGKkVY+Dfe6PHO8VCbcP3MD9/eH
	tar1Aj33CdRgt1kS+nJuG+CM1VGQliKmWjK0H9ket9ApaSOlnJCwlDDblAUwJzOfaYSo/8
	WYTLPpWOgPaTUuY/acz5KwnuxS1F48E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774547;
	b=KJX0wkfWZwCfk3Ut6+w60tbq9W3bfwlUfNB2A5MgVTa0SqDTDHDJwWDDOny95Gu0GYV8m1
	8//y4aJnDoRiIahysghegsq+P0xVRooiq8WX/8d0U/58L+r85voqucCzg8sTWluULgzpEV
	g7grZ+TY9yZ3gaTUtyw9CC3n7Hx0WNw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ym04wGz1;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEBD845736;
	Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7531F000D1;
	Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774546;
	bh=UD++Ozuyu/iWISz61QHAnkrLOx0dOy248fDd7IudnkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ym04wGz17gKjtf7xt+k0YxBVblaCQX8DJGWWHHIrKwMjz3E9fwzjh9KC/4UYPeozv
	 bpVAonJI+hSeFcTZo3DidLCvpFrLQhSmNDgo+/Oakrnmm1V1dMLsqmRBQCO9wTGkoP
	 o9ujbNkeXGyKIEda4YzfYv5j+2Cli7H46mqnSIzHDBm1m4jQlYdf/oHFbbNk82aPYB
	 01uXCLmdZWAfJgN8z/5aVE40Ft4QWab8MBeIO9ks/Ir4ss2L1irp9pFdkbxwTAsSId
	 nxjFENt0/RrGXdzLcTqrAQHel5v0D3a0W+UtVEEhC1BsItHu+0kkOrBO3m/0h4fmw4
	 6R6uDglQv9PQA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 13/27] mm/damon/core: introduce damon_report_exist()
Date: Sun, 15 Nov 2026 12:28:31 -0800
Message-ID: <20261115202849.99134-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 5g7p754e6sd7ocigaewimtsa4tcsufnm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A4CF210000B
X-Rspam-User: 
X-HE-Tag: 1794774547-211950
X-HE-Meta: U2FsdGVkX1+uF3gfiSYxR22+9hduHmjJtLz0ZQX+jZYi2ThjyHB7jTQFPXsBXeyWigHFrbgUiLC5FBA2kuPcdbbzExVpZcOyF3VJpEE9YiloEfyC1fO4ryT2vx4kkVtyReK0LB4okuWhqAdEMUxOOAqEopvxwpcX7HQzk2w+aoWXbu5CEjqKcSAfPPvf5AmNzqXVfHqP4L512u4Vn0LRps/25ge7tM73UWJjm/KTqJxtZv3q6XPjKtl+VVMY200q7m35pB4nE/bEsM+3Djclx4zIeoUEjUlAPyzN2rkZrFdOJlrLdid/P4cCyspv8S2atmkfmcYJztdtB46iylpVZMoqQfz2O65jBu4w+zxYrhFRaD6EDQBYC0zmwJccIDJ+gn/wXr6K9kU6EOlUClUb3REUJjAc66Jzp1FCEJzcr0LcYiG9M0MjMbVUdNJBKIlPxos0qxqk6SvasPpfqBJkEbWrm0wmWOUzK87722B7V7VqreOLWeOT6u9yJ2+Vu3+VHoDBMMh3Q1WrIiGKDs36E82GLcAqCf5ybewjKBYUN7+NwTJCKxbAV0YHCtz2FtNS8xrEKqlNGfvHV1uJZ7jx32P01ufia7Nb//BStsR4is57dAiNiUgDPllU1rliyDzXTsATD/1O67+YhrCI+x8G3zLEyjfAWbtC4NwzZ7Km/Py0jjAva9qG2GmncjUq65f1XWWh271SCdIw/K0HwtvHYtyh3Nnj1PRECi2AfWs7aZjWcspgldRgtkYSP4f+MKdFGXkTKsScktnC/GudMGfD/8jn3PyHH5rnvpeHCqILXyPXPtUK34v3CkTnA9/LRGt2x3mj6Lv25XumsBcWxR0CJC4gHu0nG3M+4/H/cYUYgA7v3dm/rfRIUH6xcPxT7c2apLU53Q/AiS5gLBuTu4xSgGx86hC0Rfu7FIQN3cQKFb9XRlJa7oF/3e8OhI0ecLKL8n4aUz2eVF0SGHbgphV
 nK7M8NP5
 4Z5P9ADPoJP6C1IanVWFsEvGhpzHzeM5NkTevhaVEldqgROwmaQYQTE3bieC4PRgaA+3JXCF+DwM9LC6b8ahuCQj30lgSAJiHjvvPbnNNkQ/ctQ4ZoKlpwuXA/APEI1N2yZdDZRZxIpCrCpSMjgNQ0/e1jVyxIEu/P9R8XrFNX81jjshKE88xELzTWeG47zo9LWY0qAdr9udXwvh2C+nt+GWhXbCBxYzv/YUWhtF39SUZ09ZWxIow+6vanM52yGyzHoNN+xB52uyInF0Av4kFAIXvUw==
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
index cce7d344c585b..0e43b669dfc49 100644
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
index c02c7fbc1d864..c60a6504d0a15 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2386,6 +2386,52 @@ int damon_submit_report(struct damon_report *report)
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
+		report = &queue->reports[idx];
+		if (idx)
+			idx--;
+		else
+			idx = queue->size - 1;
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

