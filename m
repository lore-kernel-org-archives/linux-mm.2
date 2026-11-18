Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3318A60A5BE8
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7ogZmjJ
Received: by kanga.kvack.org (Postfix)
	id BFA366B05BB; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9DC6B05BC; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6D36B05BC; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7976B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D20A1405D7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
X-FDA: 85446641112.17.211E214
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79735180002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7ogZmjJ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968554;
	b=lC23JFpVvnypv9sThXSiUIydrvh0ij57ewgjt0OUhpRCjpVM26552J+xZhK2tSuyZCucjF
	33IpHf6IzlC22gpdUPHB5UMts2B4Q7Ogt7BfDi+vN18Pet1NFiia61Jip2dLPkZVk2zMJU
	MolmSNtpOpMH+gNZDT+uR0cB7o0rtNs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ki1YfSbeSA9MKlcLCTk/glJl7KkUIkyI9Al2InfuFgI=;
	b=HW2Lxdxs78vKu7gDBdTcyD3wZj7p+7n9+Dta4L/TdgFPsKJEloM7hE0OPly1jsiCLIbYnU
	6fCJP01Rzn0LwvbDPVcx5CxR5MN4GETbIuSYM/QeOkx/eHvYsw6zc7z7IJe8QzwP7q7g1s
	GSUcl2WYjcZJg6/R7uQApTQ+Ps1W+b8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7ogZmjJ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1AD845BAB;
	Wed, 18 Nov 2026 02:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CE81F000C9;
	Wed, 18 Nov 2026 02:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968553;
	bh=Ki1YfSbeSA9MKlcLCTk/glJl7KkUIkyI9Al2InfuFgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7ogZmjJ/ZB8aJR3Q7GUxTz0cb4qh3s/GFbJK2USDaOILuJeglry3P/iYVr1W8F4r
	 NUZJ/FDH6lyEmvs9xIa/QAhMAIIJssMzQnTsaUqA0u73qGJOO7UqGkd38aj78ZMkbr
	 5t4FfIlk1VrBI8coL4XSlHIyJDp++bkeuIS/FaXT5WlsTS7w2ZkmcB30vZOvIYeTXx
	 PVOWpPwI15q2qnWHzEsl2NP/hB+6YRlbdgaGFz8fR8+hSzn4eI0ynTMQLdAwTMAM1P
	 cETWpsBM96y7qcZAQykBg2tnsR5dLbxAfgBEBWlhvavTb2Kj1WApiNHZmv/pAVNSuM
	 n5+856BDBrZbA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 03/27] mm/damon/core: introduce damon_submit_report()
Date: Tue, 17 Nov 2026 18:21:58 -0800
Message-ID: <20261118022225.100659-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 79735180002
X-Rspam-User:
X-Stat-Signature: cnogawo1wqwujejqh9er5uu5zeqeiz7f
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794968554-556002
X-HE-Meta: U2FsdGVkX1/8VRHDB0E9dk27hGFutPEBFV0XUTNcalmcDI29rn6e0+eIBJaaeEt/CSJL/NWGUNqS/urQe9IPivbTtiMgPHQ9V+zoRn5ws8GGjMquzgu8i5nsCEUOWWSZki3A60hha42WSQ/AOpysejd77+ZafaB8DQas6O1C1GxYUU0sj1ko+eO7FbVWvBoRPfqX95UmfT7LucGmv4QnqVugEKFrNTrONpCOSEnqn7ykcFXg/ehg4JifNSz6kvF1/WcWUWDuaBAEUGqQ0CS2hz24PlZtCvz5GWH65QjU+kmvcULkSqFRFKscnJFip068QKKNvEtcFJ6tCYQFNef8BlkCk7NhouerJ60A8lWwswIlh7DTKp+XP75U7FsGzWKVrjfEqCABt89aOZNJiv+3hxytCswacYS83HkIhr7Lw71zuovjKfa+CS8Xyos5Rp2WeHcV/Snbm1J3MnbB/B34RqEo0Di7/mdi+Z6Bi8BzmkjFsDjq5L+NZURsFqxoux0pHO5KSC5VEPAoV+n11GriQb+etkWB/6vemj+UPQiKcEJq1jFgMwO7eKiEIOuPSWV0ZwUcQxi/ELj1JDv8q1X0P3PyZHZ3stD6YcnIGX6+B+rdL5XN0EoHbHKDItLWHmoDDCRa5JU46iGFzjHvDiK7sv0wz45MFA8etL4Frt1fFzjmU8EypZJ6zuGY5vovCIS3v2lz7cg36vbzSLmDqLYBKo375MMxALvewe3Hpvdxkfxbxa4HvgsuOCXt/NuPc+Vy/crB0qsPGXC8ZYE1Jsnhzrk6neKiljl8ybUL6gL60KTgV3vLbc8+vTAs0PPQwnE+p9l7Bx0OEZ7p4mKV350G1k6S/JTKjCv+hu9Mz0t84tgm9xtX1UG3dcmFke6vtF8hqkfyz/3z7DUNdmrcoOjWJGq+IeQsk/um7ajW/Mi64zYaV6oBLb2W+jphYRwc7RAQWHErpq0hzrxKaSZB8qv
 spxSOnr4
 Ubm52364tX2T0quQm/0KCA8V49+uSnafEyFMB3Q3Wsce6nMSqREClSQhb3MUx+ssHD9p7caJVgQy3amOeZ2fkonnkf5IN2BVKsz54JtuR5/1MKgxK62jSYlS29aRt/etIhSoEMPpNsqxYjGRaX2D3YyW1HdvUaKNLkqC7hJ+oQ+0xK6YUv3ekU7KminVIFfYtxSSRo2xmUZyoJbDx3SocPlB9MzSTEd9fhZtIxlPrsqTZv4Kfgf56r5xFD4l8xluJAGmrIvrdmU5UQjzIXwynoSUF2H5LOZ9jjgLwbocM0qEf397W8g3C9vMPYKHD0apzG8S/MW10h4U3Wupw5Ywl2fUzfAhnE6NEASHVhz9OpBx2DirSmitnaRB4KrK0dFNRmOL/f3YpHH1rfGo=
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
index 0e9c1079fdb22..9d492a9aaf550 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2353,6 +2353,36 @@ struct damon_report_queue {
 
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

