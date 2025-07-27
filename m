Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEDAC87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 20:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A5D6B0088; Sun, 27 Jul 2025 16:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAD86B0089; Sun, 27 Jul 2025 16:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0676B008A; Sun, 27 Jul 2025 16:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 900986B0088
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 16:18:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FD461DCC84
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:22 +0000 (UTC)
X-FDA: 83711156844.11.ED08708
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id ABB23120004
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KQijjcRc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753647500; a=rsa-sha256;
	cv=none;
	b=3v0EMv09DNO2RjbdOfwS1rPm4a0ijxNUaiKqCxBkzNk/KHdgt6OeaZxxgyJubzYIpt0Shj
	nxz2oc4q3Xn+Pjxqr3wZKQ0PZ1yOphaUXDC7dE9BCIK6kBF0xjeur8BKHPEn1JuOSqNQ49
	h+5Q+25kgD5slCbelKx/jPpBhy4JBmU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KQijjcRc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753647500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiuGyccFaIU1vSGqbjlUpS/LyZ2k31IzzsYhLYpcIOQ=;
	b=XzW0zJG5n6fIAL4N2iE6MxXzsfWu2Fez62HfossSIwiHuAEng0ov9nJ6Z5pvkv57AFWwVV
	JVnGSVZWsAuyYdTM+vFg587W2cld7h/99xyHLKNZ1/rGeRNGDHCrWbdAGmoyIU4vpZU+dF
	LI75zXAOKc1nlUiDnistLrNehmyxhpc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A63955C58E2;
	Sun, 27 Jul 2025 20:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3A1C4CEEF;
	Sun, 27 Jul 2025 20:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753647499;
	bh=HqUvAgrhD+ZVNsGThR4W3V9E1/zbZYx/FHOFDYmdj58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQijjcRc2uGNxF3ZV2oGZ3kGwkNsro6aw8jQX9xkOJFU36vTddqeevRmebA1/jTpa
	 mAg48nqTRpMUIqSR1FNP2zE7og5SkioWdmv8ZP4C0OGAz/h06AtOs3amG//Q1ZbEIq
	 Aj2khGAnzV7oJIdWgvoQS+H4/AJtm5o2xElqvP6dYAC/dZZDeZE+9xZ9RbwfHufvYd
	 JkyUcUX0fHJB5O9Ur39tgOmbJnU2mIP2Y166eRMV42C/fyGPVqnIjL2rL/GAFgiVA5
	 HQIu7zzcdGn/zrP2SDqhru2E3C6upMrE1/9xcRDVnIPQsvTI32rey5qyM+CmFtESGb
	 BtXrwFiIcbPVA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 1/7] mm/damon/core: introduce damon_report_access()
Date: Sun, 27 Jul 2025 13:18:07 -0700
Message-Id: <20250727201813.53858-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
References: <20250727201813.53858-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ABB23120004
X-Stat-Signature: wakfkce9y3ht4jiprj8ehcofsxqce31s
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753647500-764753
X-HE-Meta: U2FsdGVkX1+DDJypD2hdnWsuxQnz07OTbZPnTvUFa2GXHI6RFmyOAeyThiwtdxuUJqvP1FrFv3Sz0YZXieEyZEr0GQjqT/G9LNY9AxAxBlhfjlx6LDwf1N0P2rrUEb3YjqhwAvyCmco3ugUpspM0iJreHzng0W5B/ZbzUibrZEajbVkySxIYU8vQanrGB05JitnUW44gDzD/0d8gK1PrwQjKe7fRSK826BOzmqI2hNq6esF6ZZ1CVQ7R3jnxX8xeI9BEqEtEdqZ4Yn4WvOMgBeKNXFFrf8rIlHp9pWYLAaT8RqlyPLvKn8mqzl2N5tpjqratSxRLcg6tV4MjevTH5DILinWvE/L6TGYLEe5Nl25bPQN414Rxh/VFW8cRopZ/Bgwnyr1swSMV+cgRvpFhChadrs5lwMZQYpTo51hlEubxrvCph+NX9z2v8eQs32yG8GjQYiGCUW4c6Vjpgvdy8GhSbWlxO6nfdDw6XGkjmloXWK6Ir/fnlINziyBIGpfqJAtCAHO+AA3Ccl4FTPIi88d16OgTg5MmIjBy5WVUzmf5EXe04tfWPCuRk6yyUxjsgXLXVXr0XQEsdorp2qifBJu6kUFF+vYvnv0CnR762Z5Emsl9ae96cq/sjh4pIynL6HZFI31sD5V4yCyPVr71YJ7Y3gyNyoxV4x8AjQCgIM65S4fFUmvROLL7r5GrajvMmtUPEo2XPli9kyXqXr5ouGXMZdKPySM04LUIaJ2nJzlwZp/gAU7rDl/8yJB8Q9QJCWFs1HwgddWwz2lMqCoMG06wFiAbR9n2QlpT/9GTYHVBBaowxrfzsuqe3s8xsQetZ/czOANe3VTGpgRNXLnjFxmi75SK7aJqmgc1LFHMlLbg4ucFEIBPLUvLur6rHKBt61YsqykqUgjEQL1u5YWXUvLbmd2nq0PDm4vNvrxJRUQmOa8YMmY+7fKhA/S1OwFGYF2KHiUBta8KxgNy/gH
 i2jjTfzF
 9A+blATEjviFTkIMSnLjypThjnx8+KvOQ0FkGN7P2KMg6CADL3UvVYUA4pkEamO4T93aGWntHdup9Xc1rlNaYU+WjIAzGV6614p9jeaq2YDrFaZPYAXH/qzMpVEy4bySH5iuqSLtXn3gHurfeu87eMuH8RtafVi8FNmT9BnLtttptB77FpToey9Ms9896zOqcvTQbLBX0wTZXjCjxMPNo98pZtsfv4aUqkTo2siDA4W1dqDlQeuQ5AKLHGsc92BWJ71HiC+CwM4gouyfhCzEpnrO0bf92t0tGU5yKpBe9lzV/lIqgSUnAtKryhShTPIOWLCGXITAR4uIcH+j1wHPlXObxpmzH5qayW64+fudAY/cTFSZFaRft+cpXVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core layer asks operations set layer about past access
information, on core layer's schedule.  In other words, core layer
"pulls" the information from the operations set layer.  This is
problematic for a case where the operations set layer has no time and
space to save the information until the core layer queries.

Add a new DAMON API function for reporting identified data accesses to
DAMON, on the identifiers' schedule.  In other words, it lets the
operations set layer to "push" the information to the core layer.  The
function internally uses mutex, so reporting kernel code should be safe
to sleep.

This API was also discussed at LSFMM'25: https://lwn.net/Articles/1016525/

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 25 +++++++++++++++++++++++++
 mm/damon/core.c       | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 479ee52b79e1..1f7592147d92 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -104,6 +104,23 @@ struct damon_target {
 	struct list_head list;
 };
 
+/**
+ * struct damon_access_report - Represent single acces report information.
+ * @pid:		The PID of the virtual address space of the address.
+ *			NULL if it is of the physical address.
+ * @addr:		The start address of the reporting region.
+ * @size:		The size of the reporting region.
+ *
+ * @pid could be stale, and hence shouldn't be de-referenced.
+ */
+struct damon_access_report {
+	struct pid *pid;
+	unsigned long addr;
+	unsigned long size;
+/* private: */
+	unsigned long report_jiffies;	/* when this report is made */
+};
+
 /**
  * enum damos_action - Represents an action of a Data Access Monitoring-based
  * Operation Scheme.
@@ -941,9 +958,17 @@ bool damon_is_running(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+void damon_report_access(struct damon_access_report *report);
+
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end);
 
+#else	/* CONFIG_DAMON */
+
+static inline void damon_report_access(struct damon_access_report *report)
+{
+}
+
 #endif	/* CONFIG_DAMON */
 
 #endif	/* _DAMON_H */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 64e59d15043a..4e25fe100b56 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -24,6 +24,8 @@
 #define DAMON_MIN_REGION 1
 #endif
 
+#define DAMON_ACCESS_REPORTS_CAP 1000
+
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
@@ -33,6 +35,11 @@ static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
 static struct kmem_cache *damon_region_cache __ro_after_init;
 
+static DEFINE_MUTEX(damon_access_reports_lock);
+static struct damon_access_report damon_access_reports[
+	DAMON_ACCESS_REPORTS_CAP];
+static int damon_access_reports_len;
+
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
 static bool __damon_is_registered_ops(enum damon_ops_id id)
 {
@@ -1461,6 +1468,34 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
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
2.39.5

