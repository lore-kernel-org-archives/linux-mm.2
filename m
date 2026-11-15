Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BE3606C41D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owhdubng
Received: by kanga.kvack.org (Postfix)
	id B68A56B05B8; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2C86B05BC; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8706B05B8; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 519036B05B9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B75871A0821
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
X-FDA: 85438492650.16.FBEAB6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 327C21A0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owhdubng;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774544;
	b=WgoYFbFiuEirdm/zGQQhbusGjxFHnmfrrdP9Tu+WJv2VpdyNbMtRyw8AoZvjNeKn98OAYs
	lfhC6XES1shUAGZOi9YaBwI9+4vaCyEdEBTgXdMhkoMX+IIRO0PVygPnkBL7i4DJLXz/8O
	6RpYTQ/BEP4fqsIIaY4oVS0TkXL7wEw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owhdubng;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOEWifhQB1QprRyloMm/qb+7W0HlNjxuF07T5a4HNeo=;
	b=mMJvVLKDUOEeN6OnJP2rcglzLTJASYcJM6xN2wqyC68p8L8oW9cYhNHjT2J0rX7dNPqjv8
	Ku90gSHiMOqZIbukj7XyjIuVPZFqLvFPcpogG9wYC04I/vqzcf1Wtf7ZrJ+1qOP6Dutv2H
	BBA0U56CnuXVpxEzqetSfB0ul8g/0sw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5E8861891;
	Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C811F000C9;
	Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774543;
	bh=lOEWifhQB1QprRyloMm/qb+7W0HlNjxuF07T5a4HNeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owhdubngAEBRyye7lsJBXZuHgYIy+DIrcSCdyAYNSz2tYJHRJmpsbMgfD/uPupBdq
	 gcL3ft/+KD4rTiTWbIo+KlNnuIFX3wq41Sv0eadPZwYRbOolQeX3YjffcV3zuUh0fL
	 LGXxTZFJ6v1EX1fMCMQD5pfrkm9HAc8DZd/D2UgYHILUuK2C3PsfDrn6f3+61cjW12
	 Jf8/C/F/9sr7G65oYL6dtHBMSGxOgTRvhe3CM7RFZdTMTH3viBzPM/dABXsCk2J3AP
	 cCw+8YltMidzOox6IPZs5lHyX7wIyJvgw7DQ5coEG9+3ktxOMy6tL2d4LlIR7dIyNK
	 c1zMf0LZ8SYkw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/27] mm/damon/core: introduce damon_submit_report()
Date: Sun, 15 Nov 2026 12:28:21 -0800
Message-ID: <20261115202849.99134-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7okeyt6qzyykixbjes47tdjrhtymh7ci
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 327C21A0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774544-947312
X-HE-Meta: U2FsdGVkX1+Kqm0lG9dFLIbD/7y83A1sKloJxGcG/K32ZGqD5rXxYq4r+zI3QDpEzaX1Tqs4CqsQnD3hKIZPdQH5EuIalGg+ZCDaKJZPJ8xiA9NN8DIzuMF4Cc+81U/Ept+RlIbBeGHyYPhBqcGEMHlmbeFasUOzInO5Bm9OTtwPajzitkqTTGqYuE6gxEzRwQMN3cZkIwMNEiCWI0fKvPYm3w28w1gVFMLSTMx6pIW2jONlxxY5sr7O5StDlMBJzb1/9WMwx9OP1vW5mz5TEj1cR29mHszQEDXvmepX5VqOvYvxB1G3J81tKiozMqz5X2sSeUODsvVMEGKz4NygZO0RxZrRqTWVbQvU86slUMyMyLwqYeMVXMJhDkFsowC0LSVes6Jvli8pqF7PdJ1uQq/plI4rc69RubpnUghUJb/UpYLJVSsRnTcG4A0kDTLBeoNd0dAEVSiE2rAHahMjb9orWYvhhHqPGAhNXKLU+DdIuCsSgmPcFi1ZWmfPjgDGtm4cApnW6pHO8Wi+k5Aw6me6EfrYi3vdYSjTsGXsAOn+sfjnhZCB+WbPoqiRX3rAbqQ9pF81lqC2Z3/Z7RkAcn+qpIc4bKgsUoBBRf+oMlEmcXjynluZCw9Fc8lUOH80WTdq/UW5z7fGjC8ze3v6MBAfvBMI8VOwqYh0RoTj8kMRMuBGJ7TwbqcfoGSgoUBZ6bUbbxrMAzdPmUp0yVSvGB6iEXDeKwkpMiv0VQz1o8dPoDlDbm1IxEkIVGaOhK/Grb06AiQmwohCoqCspgfVhASPNyiu/Pc+yqPWL4T56bRnxYTJI2TBaIYQMU+SpTuYKGL9Hg2j773soQSqvU/5ZdHz0kXl396kO9vrS491Rc3bPlGAUjFpw+l3OjDtW/Qh2dvPfxujXDE2vvCUdRJK1T25JNcdhQx2r9U2toOXXidJgpHgxX6fW0BKLop8jOCApvzu4GY2lsqFol+JG6U
 Q6GNA1Pp
 v8jsGJ4sh9nkyvMCIKRKA86Pl945eJJhiRvogLTNmaLBj6R+Xy83Bapeo0y/MnjE7yBqlVSby7qUXGwU10743oyXwgCZcStJn4uCFNTjm3J2zPen6oxfRQKyPVnwwaYYOssXy+zMOnNv2HbL4kVmA9Zqvf16RVcqEYBetUSPYOvO/NmhEpxeZtt+GPZ4YhbxQphGx+lK+qfZ/Jti2EnLbEeVOIZtWpFIZ/40T+3mO/uPNY1mpj6Zvf8fewKxPoWnlurp2zNDhsf/sGc9sEag9Q3OpGA==
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
index 5c32ddebf4625..ca0135c6f6700 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1189,6 +1189,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+int damon_submit_report(struct damon_report *report);
+
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long addr_unit,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3f87a7eec442e..06b85d00e38d9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2353,6 +2353,36 @@ struct damon_report_queue {
 
 struct damon_report_queue damon_report_queue;
 
+/**
+ * damon_submit_report() - Enqueue a given report to DAMON internal buffer.
+ * @report:	The report to enqueue.
+ *
+ * This function can be called from any context including the NMI context.
+ */
+int damon_submit_report(struct damon_report *report)
+{
+	struct damon_report_queue *queue;
+	int lock_old_val;
+	unsigned int tail;
+
+	queue = &damon_report_queue;
+	report->jiffies = jiffies;
+	lock_old_val = atomic_cmpxchg(&queue->lock, 0, 1);
+	if (lock_old_val)
+		return -EBUSY;
+
+	tail = queue->tail;
+	if (tail == queue->size)
+		tail = 0;
+	queue->reports[tail] = *report;
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

