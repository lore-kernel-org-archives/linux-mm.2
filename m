Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBBB1606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LP+9/YQT
Received: by kanga.kvack.org (Postfix)
	id 30C736B05B5; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCAE6B05B7; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D766B05B9; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D75666B05B5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C9E0A819A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
X-FDA: 85460344410.20.DE19DE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 88410C000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LP+9/YQT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294823;
	b=48FcyEENo2aprHEdWZ8ymgSeMmT1UgMVySc8xKS5eCzNQlHyvATZ0LhSbkGu3wsCKY53p5
	OR3J3XK5qPatAJn54ylsONJCOBza3IMpwhW6EsaXO0m+kBZ4dWKhbja3yDGofuDDZyT28P
	V4a1SJZHm04T273RwM94YrAVlnGLlzc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrlcgoNsiHbXM316FFVBzg88Tme7dmxEQRaz41WAXvo=;
	b=Sv5ALJmD+kcFa+77LnIty9F8/ZhsLUqzCL+ByzOoM/P19EeaQ196VjYDTXUysZclS+id47
	Duc24AKVrNMHOtVDBVa9fP8eVXI5n0yS4ISnbqnNX0DL2E7Ib9DtQhPSoZ0VKO/b3cNBT0
	mi2ri8kYvSeRSu5+sDtVDhb2mbYlaK0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LP+9/YQT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6507D443FE;
	Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2839E1F000CA;
	Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294822;
	bh=LrlcgoNsiHbXM316FFVBzg88Tme7dmxEQRaz41WAXvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LP+9/YQTwNjUojdvaPg8a1cItTq11n9fYIZ1tRroa83a+rHCeCakUW5Px9gxLfqCT
	 Z6SkF3yQohknQSrSMyBM1impB3lPaEt4RA7Ov7iOorr1RR2yCoHPGvvjzSw1hUMGHh
	 B20FQSX2pV2+FY/CAW+y1UNozT0Zt8fMX0g15mHW95fHKh9DgvNsJR4eHT1e5QAMST
	 ZByV90x+DdynMb6j0rOowkDViOi6x+gAtp2A4HoxvVAIY82oUOafD7YZ/2FUhP+xdb
	 /v/fR3zVqoiiPWlMDkFtzNI3n0cBk4EP8bXChzQJtrl2UdaffU61SWFqrwGcw9OhYu
	 VUiMfW+FOmmjw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 03/27] mm/damon/core: introduce damon_submit_report()
Date: Sat, 21 Nov 2026 12:59:47 -0800
Message-ID: <20261121210013.130397-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88410C000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: iqrr7ypo39h9fyotpwpcqrmnxbrq8ywf
X-Rspam-User:
X-HE-Tag: 1795294823-998790
X-HE-Meta: U2FsdGVkX1+ZTjxbjwkTyfNNZJizRmke02P00zqHx+/G/geojOZ2ibGpSuM8wvCesk4q+IS2qvhRCVoYdM6+JgdPgm9IHxdCX5U8iNasIFHKvvmjmVz6XWdAbfKk9YfnW6R3ApmpjS9kbgsG0dATDDdUHeii2ATjP0ngIiTbXaieIQGrqraS+dMcxDsxaTliEKvNr3fnAYbbFJPIHMrNSaqWNVFztlnoZ+uD38Akm7bIVh5LDGmLVPj/m2YyP3eRZ/a79f6TpZddT/0y/kDt+Vq2WzEdZ8BoAyGB00CXI7g/PPxEmUg3dr06F9q3qQCBapIwRm+eR5L1fuXpwHRIWpEfKme4RLhN5UAxIHNy6s+Gck78GysHnV9LH4snTdWOLpJKKf+BFBchP71ZDVnJ5xiAd4zRoRC/y+RVFYlpd0Jp+tWI8SRgaKXsE4HjJ0zy2HmVr23PNuZzeykYejVqkIgH+dW90AbUEeyQa/5jRjiIeu2Kt1PODRtXk0slz9XWa1yzKKMb54N7EJu9+H5+d1jGCRhbw1UGkIJzOvF+5RT0ZKhCqBQxtGREZC16qpUAXIDHk6KPRYKTv7g93NKHwJ7SXTXktwdoeEyJW3O7cx2Zossmh2aEUrcfjQD1NdmNQUzrhWW89BFOr8RG6/eW5zsqA5DQYI+Oed5gWfruNtyBPnkq3xrlsyiPL8fZBIpLu5ZO3gP3hm1F4pEaCaXRDIVqL2De6oVexmtaw/9caoEJgz0baT16jE56Btift3BeIgjlbcEeuffJougLsPQN1YCtNvLko6h8HKvGDZ+reMWaY+I28q9beaM8GfJm8hsQYO8NOcGj4VjFDlr4n/sexrM3U2tBYyC13W3zgc2ceUC7VBDmbUefviVGpceNZs8dqBfSWW3YwgdLK2Cd7bvJ43kX6/3ih5Kg3lLMlEa2RnM3rBYQCP/Zi0GEBjk8/dUmem5Co0NINJRxjeHdmqL
 zJWuMtnn
 g9GdKCGiS8whaIdKNddD8UUUD27OBiT8/NTAoAEzOa4rVZYeshBtNKw7GDuDYPrPyF1Qbih29cC0jOi+auF6y8AQzi8btLs9gFVtzTc0E8Ptco7VYT5FDsw9MEGUs/0J3+zyhH+dznZHucyRJaRxQsM2aGfJFTi3DSg1kSpeL8AyqkzpfrACfkqkKqPW4hY/rSA2rYCOElLR2clp9/1bxS4GCzawnxDfjP+eOAHhs7hEcEiqfxJPFkRM1Cm3GTOqBEBlydjyMlzI95StXqxx0Ac0Klhcuytz/JYVsX5gFUstEg5X92VvqCV5Tx9Bw5l4v5ZPO5VBPRPM47b4TYNZq3G4th9jhzPK4jsSgbUrgRrDtMPM1hEeRWw97tuAU1BBffsuFRgl38v8VdtRpS4ja/SjlnrHWctaznzYmVDT+Eccd/oRdsf1+ktBeE5hT9e5k7HqE4iKDUsfaevsF1fUcQlI7tl9mw0Ax9BM486z5P4RDmZhR1eyBmPCsGjMvBFvg00nJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement and expose a new DAMON API function for submitting a data
attribute report.  Any kernel component in any context including NMI
context can use it to report their finding of data attribute information
for a given memory.

The function copies the content of the report into the DAMON-internal
report queue.  The copy is done in a ring buffer-like manner, without
being blocked for consumption.  As a result, the queue keeps the latest
reports up to its capacity.

Use simple CAS-based try-locking.  If any parallel submission is
detected, simply forgive the submission.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cac1329397a4f..35ad002d1536c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1187,6 +1187,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+int damon_submit_report(struct damon_report *report);
+
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long addr_unit,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index b51741bb60e26..61ff3adcc69f4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2352,6 +2352,36 @@ struct damon_report_queue {
 
 static struct damon_report_queue damon_report_queue;
 
+/**
+ * damon_submit_report() - Enqueue a given report to DAMON internal buffer.
+ * @report:	The report to enqueue.
+ *
+ * This function can be called from any context including the NMI context.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_submit_report(struct damon_report *report)
+{
+	struct damon_report_queue *queue;
+	int lock_old_val;
+
+	queue = &damon_report_queue;
+	report->jiffies = jiffies;
+	lock_old_val = atomic_cmpxchg(&queue->lock, 0, 1);
+	if (lock_old_val)
+		return -EBUSY;
+
+	if (queue->tail == queue->size)
+		queue->tail = 0;
+	queue->reports[queue->tail] = *report;
+	queue->tail++;
+	if (queue->nr_reports < queue->size)
+		queue->nr_reports++;
+	/* cmpxchg is known to be faster than xchg */
+	atomic_cmpxchg(&queue->lock, 1, 0);
+	return 0;
+}
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
-- 
2.47.3

