Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102E5606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UFZ/WE6K
Received: by kanga.kvack.org (Postfix)
	id A11B36B05BF; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1CC6B05C1; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE526B05C0; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 693C66B05BE
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B70C1A8199
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
X-FDA: 85460344494.24.C3418A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3154A180010
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UFZ/WE6K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294826;
	b=xWkkdowIQ+wBQVhsmipX1CuzbN1qqnPl+AjiiyEXvxrnTDo93A6z9lTLIU9+jFHZDtvl++
	3/7pbspnCSNjPfYmjCEQgrcELI/dRQnvWu0RrxPsbamoHsI7aodttWv7uaG5SWCOQ5ZBQe
	G7taar1IVW483U+yrYxznGdP5Fuc7GY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMY1w6zCdZbZED46otQNO9VCdx7EIsblDhOC0YAAboA=;
	b=y6Ctf/Mk3482SEPes97C9dXnQ49rh7+zH36PAu5s1TcCmAY18VR/AjT44+HGn+6TUbtZUz
	q1XmGk3zDYZu6Tyd1I9lYlHG9TrE33xe66xd6wVCkN0jm9fhKyFUwsRUiU5vWy4AQPpJvp
	GFwZ8ttZdrmsvFD8nztlCqPb/JP0aUQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UFZ/WE6K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8A4D61CFF;
	Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7522D1F000C6;
	Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294825;
	bh=RMY1w6zCdZbZED46otQNO9VCdx7EIsblDhOC0YAAboA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFZ/WE6KhWtr9VybeKBqUIhhNCBUTgstyBIGbyOxgpFC960bXs5izLL/7toxJ3UM3
	 Ks/1xK6+gjdGqdFkMBF7V6DaEBPG8R2lJCBVOPgl238jkwNh5FDRJkDXon/rJQujmA
	 ldirllh7ZqxtIwH2GarZlme8Bt1oWg6+bP4Nb3C3CYUxOVOu8jIJjSfC2McnkGdlg8
	 NWahdZobWKc5jNsGRUX3KzDQt8HlAPhmcscQLKX+VD6bslHoJ1G82uhkCuel/0arWw
	 eiT2ZOW3DyWcd0VIFxiR8wSjOrvwHcYS64BQ67zkGwU9I9vkUWpVp0Fl2EprI575ha
	 An17lWc5uz85w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 13/27] mm/damon/core: introduce damon_report_exist()
Date: Sat, 21 Nov 2026 12:59:57 -0800
Message-ID: <20261121210013.130397-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eqersererydonijfztqzrwm1g8s9u3md
X-Rspamd-Queue-Id: 3154A180010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795294826-761404
X-HE-Meta: U2FsdGVkX199649sqGuHsjIov4aykQlJCX09Aa0oR9L3mGGZhrhgsuiRYUwWdxH/Lr/hCZmoHQWTB2Dv28W4RmfMJzui/4mgEADrIfCZZV1P0Bk6kapiJ0eE1saULf6H4HtzHY0vKL+xtb9zREh6NOK7oIVsWdNELY4gNr+4dfoEgXcXrK3T3IbBxa1hZteAZ9loifK/J8ovNr3Eyl9LQRBh/GcCcd6pL2aeXwKdhX2vs9xjh7Q/BJu+JCXgjh656Nz2i6YVEU/WzFQcsSqWTebMJjhospQoQy/hujaZ+OivjymferfptML4SkYbVlPaKmsfgime7uVoBr5bdSMxJA617ex7JUO4/QdGtq9e4b3eg5b1IR4qFNv3+Xc8mvXcDh/idOG4H4gMvGkC3Fw/80OV+CaNp9McM91+QRbL2LF3jAwdy2ODZSabv6lbtJnDvI3dqwAgn6U1LFDrnMa5KDzUBndSwSPRtXUV8BRPWFvM3SXDkSC7IuFmOmDE66RM+m+qwMTxNwC7EMDs2gK612yoO4o143HLC49eTH/wZsM4fjHX2ZPQUzMw9c1GAqjw1fm+PSis+ZxZJucVZwDfmT55ITmiOLAQTuAStWunk31fsEQTiYlafyFAyGru7G/Lgb5AoSfD2HfNDMCDFxhj64gQd5rH3UJxOcJNNQkgSRwOga55TvRF8BbCbae3odeNMcCYTDRpEVTbpX7qhBrajberPEqlU2uHT2LI3OXAh87/gEgRqDQ5IVWywjVaGvMek4X4dmMV2tkrHQHxs/7vJFwYLtQpNxnK5q3JBbsB1yoReB7Qpi6pbitrWeErTSJzOD5ZtDskJbT4GS/RKwgqZWWjXqF8j4DqMCZ9sKIM8d8FMZuXFObiCgufja4W9jAxcCGL7VIyEeQf4It/7n2ZkgG8RBDk/v1nw/+CQdPR9SZNGC2Drp52ppJ8qcTr0ht6ZDa3TxH7pINeLTP3m0j
 112kLuPn
 +mpSLwtsktviTczGDJklsDH4ixaX8kD9aCJhZxEm6jbaV6kRSeD//6bWx4iCHkAbdUcz0qES/5GgmZePfoFyCyA0YIbfYviFl2yKrTK8doPmYOYgelAM3BLEhcRyUOfTHumfgu8od9+KrjMfNcmvgXS5cYcJuRzqsDYl4CMzhYdrJC67ZyrR8ITfG1blcoh8gkxD8yX9f4WInU/uEowGa+dHaZnNF8FyXjxRGT/Y2VRGD+XQJyXf1S4CHF97yhgpk4eHZ8kpXrOa/IB0JR24/yKE2VzXsbqdik1q+vLOy3kruCdmedAemcdVZcDH1AIMdPRVJESf2hWtRfm4ECPrm9M4tKstr8dsTRkic2ge6yIrmUNsPLCk++YfM3vPLZFdKEIIKcFhk3Ph+dZyBTSgJqujByHLGAmwAJ0DtKizWCB4GgvFrgaWNrq+Y2InN9Jn559mxQKQlWVg6xajLBiPDOsybz2gYrDabrTxtfFu4Ymn4W9RDneog2zrYYKCZcP3bHjxz
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
index 54e0ed6561c05..22028cdc0f03b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2388,6 +2388,52 @@ int damon_submit_report(struct damon_report *report)
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

