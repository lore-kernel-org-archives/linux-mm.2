Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08ABFD3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00F86B0007; Mon,  8 Dec 2025 01:29:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8286B0008; Mon,  8 Dec 2025 01:29:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B076B000A; Mon,  8 Dec 2025 01:29:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAC76B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:29:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C8CE1A095C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:53 +0000 (UTC)
X-FDA: 84195328266.06.405B3BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74C17180008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rVfo/zWF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175391; a=rsa-sha256;
	cv=none;
	b=MqzQ/MWCd97J4NHHbGN5qYcsKG+nZukNElGDUWjAyGZP6tV7sudeiaqZ/nEKFCsR0U0rJz
	b5gtnVaFp41mznCB/gP1uyFXYfcqkDl1QIsCKWhfImOAHiH24dOrYqPoYrA0k1ViIZBUuo
	MluIKvCn96xDfjVr99DIft6gFSFZ5Us=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rVfo/zWF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDceMF5uWD7gybheGJZ5fPtf0heRIRyNAkUJN4RN01c=;
	b=NOO0/ZZNTxjkKFW/PZ4oF3wNZA/cmQ/YPmALJwv/o7qJbNDHWq7oZrYayqimC1id3hNAxA
	ku9Gp3ZfR/yAmPcvqcvhLK+GNaom7s50ovqi4VksuYcj/4pG9vNh/9IbGWsHThJzddtE4W
	2Fezgyauihd7P4o8+/ZlZZ4q+MpphAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A373443F2B;
	Mon,  8 Dec 2025 06:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD43C116B1;
	Mon,  8 Dec 2025 06:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175390;
	bh=ZxPuOve16IrlwUTG5ESII4iH+1SrqZ6IkyUiguVkjLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVfo/zWFzj33IhJkSn+EyozYUUTyO623/XtYnG369BniJsYKzB4HGum70XDruWtdN
	 ojCFPbh0qcnhxVBagiY2tJE0oL4lrOLicZTXRC89eew0ch4PnE+j4YZYtK+ILS8/kQ
	 CxBv2zBRlHx4FqOTslKi7vkvI+tx+h5jJRNg+BAukN/0A3kHAJzUsxYZNHXlTd85k6
	 W9xdhrHRmqTSD86en4WZMI/e8McaIUmwqpgXCxeJul/RB2DOzfi537YDBOQ4oawV++
	 mG8vVzKh1IMbPE1N6kj8UvVU+FbD2dyM7rGJxDRekmosWf58pUq16xKx/g+cQKUwaL
	 cWkwZNoS/3WKA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 01/37] mm/damon/core: implement damon_report_access()
Date: Sun,  7 Dec 2025 22:29:05 -0800
Message-ID: <20251208062943.68824-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74C17180008
X-Stat-Signature: s4nkjaed9wm6q5otuf3jkxc5syrsyurs
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765175391-134643
X-HE-Meta: U2FsdGVkX19dDHgG8X1Vt+o9jFQ01au6BipPsDnNrIqV0/IX/+M+kYIBx2fJngCcuD9OogWWxquIZvc1spTPaTkiGklgtDzUGmElXl7XbtYteN+xT6WOygO3EPq/TD9BoUVcxR7akGYqQYGTJu+yWTbvl+r1tsiewgI5HNGTStrLF94z4zZZRn2zNFE+xre/0tDmgITPDCpsP8qk+NRTg3xmlHtehaYW3LnwHtJcKmf1KErY6hv3HLPzyEOQApLhLDD3MI1yHokxZHvKnI6E7rhHOUEnuONosbQyuDATrx31vMD4GFOvciHj0im6rNt3hRGF88gUDWuiwMtuzs8t2FHAL4W/na2WCRZE7TXHkWpBAE7IJ0zjXNink4GyMinQhFzDUUrlmh8CfNATeUwebupJzhZZa8k2rvGZPOJJybaKyXWNJk9eHS+1Gv8oJ6n+9SBtA93v3dvHuaEhCPYbtPfXVH9nCIbptgbeER9uiH1zp8ORgrtunGzEjVeWuRRgJk8RXr0kkp/Mo2XyQ5YhqXcLzs+5bHFpmouB7xnrpXWBh4yTdsAWcT98Gp5Iz9edTjhY2K9BPi71raT+ZQqEUQNVUmh8P/ucZnQ7DpTMOo/HGUSUNgkvUPb6t/83pyxhTT576RhJ8HsPr6WvdkBrZveZ6M/PxxaQByqaeOssFvESdPeQee7vE57o6/SDv/JWV+Q04wDF0CqBWLVtAS3gRcOe5ZzpsO3q86ycJns/oNh0gD3HGPpMfiEG9ASPyFP32CG5lQuH5hVRy806QafwVpLkUuXzUI5YYulRgB1Tz3678HlqamwqQT+TCDRlkipmNpRmAcIZKs0bdLZZ6W1NNwDhF6rMuZlox3R6P46QMJ+vUrVpNa+Oc+G8gEgvJSAkrPwtvQYNZn8qH+VzuP+x5EAiQdLiN493mDnMfdK96fZKm3BfAY0oyWld3obpTDB7fOdqsSpCERwTs54Ut1g
 MV3f8qBI
 q7EZB96NfxCj7ykYIOuBf+MIPGIdLdgtvrcd2RrlbZdWChIFDAzNwO05RsvCpmxcD08mtM7w4miLNidNCjKBV3RNCkiJ6iGm5krUPZFj7ETb/+er+aS2rC1jYKwliAgs746yZayby59i6ZV5e31FLD5QhCDL/s6QDqe0VjFUyJ+cA+juOavBHYDZHpOp6HShf1SI5stL6qB3VFNSvha2OGSnI8m9FKbqmEMkh+LegFFrx5upovZ8vLU991pFZ8GYBOZb/Hbkwsiwdj5Ejsk5maV3qQrtu08Vv1R5L+9VEjGGnpM+TOP3HxpO6597rvSNbJDw725tH3A+5yLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To report access information to DAMON, DAMON API callers should
implement their DAMON operation set and register that to the DAMON core
layer.  It is a burden to do such implementation and registration,
especially when existing kernel components want to simply report their
observed access information.

Add a new DAMON API function for simply reporting identified data
accesses to DAMON, on the reporter' schedule.  The function internally
uses mutex, so reporting kernel code should be safe to sleep.

This API was also discussed at LSFMMBPF'25:
https://lwn.net/Articles/1016525/

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 24 ++++++++++++++++++++++++
 mm/damon/core.c       | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a67292a2f09d..1bee6e7fed1d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -110,6 +110,22 @@ struct damon_target {
 	bool obsolete;
 };
 
+/**
+ * struct damon_access_report - Represent single acces report information.
+ * @addr:		The start address of the accessed address range.
+ * @size:		The size of the accessed address range.
+ *
+ * Any DAMON API callers that notified access events can report the information
+ * to DAMON using damon_report_access().  This struct contains the reporting
+ * infomration.  Refer to damon_report_access() for more details.
+ */
+struct damon_access_report {
+	unsigned long addr;
+	unsigned long size;
+/* private: */
+	unsigned long report_jiffies;	/* when this report is made */
+};
+
 /**
  * enum damos_action - Represents an action of a Data Access Monitoring-based
  * Operation Scheme.
@@ -972,10 +988,18 @@ bool damon_is_running(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+void damon_report_access(struct damon_access_report *report);
+
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long min_sz_region);
 
+#else	/* CONFIG_DAMON */
+
+static inline void damon_report_access(struct damon_access_report *report)
+{
+}
+
 #endif	/* CONFIG_DAMON */
 
 #endif	/* _DAMON_H */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index cc15d8ec9dce..7abd8c550c60 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -20,6 +20,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
+#define DAMON_ACCESS_REPORTS_CAP 1000
+
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
@@ -29,6 +31,11 @@ static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
 static struct kmem_cache *damon_region_cache __ro_after_init;
 
+static DEFINE_MUTEX(damon_access_reports_lock);
+static struct damon_access_report damon_access_reports[
+	DAMON_ACCESS_REPORTS_CAP];
+static int damon_access_reports_len;
+
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
 static bool __damon_is_registered_ops(enum damon_ops_id id)
 {
@@ -1271,6 +1278,8 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 			return err;
 	}
 	dst->ops = src->ops;
+	if (err)
+		return err;
 	dst->addr_unit = src->addr_unit;
 	dst->min_sz_region = src->min_sz_region;
 
@@ -1521,6 +1530,34 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
+/**
+ * damon_report_access() - Report identified access events to DAMON.
+ * @report:	The reporting access information.
+ *
+ * Report access events to DAMON.
+ *
+ * Context: May sleep.
+ *
+ * NOTE: we may be able to implement this as a lockless queue, and allow any
+ * context.  As the overhead is unknown, and region-based DAMON logics would
+ * guarantee the reports would be not made that frequently, let's start with
+ * this simple implementation.
+ */
+void damon_report_access(struct damon_access_report *report)
+{
+	struct damon_access_report *dst;
+
+	/* silently fail for races */
+	if (!mutex_trylock(&damon_access_reports_lock))
+		return;
+	dst = &damon_access_reports[damon_access_reports_len++];
+	if (damon_access_reports_len == DAMON_ACCESS_REPORTS_CAP)
+		damon_access_reports_len = 0;
+	*dst = *report;
+	dst->report_jiffies = jiffies;
+	mutex_unlock(&damon_access_reports_lock);
+}
+
 /*
  * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
  * the problem being propagated.
-- 
2.47.3

