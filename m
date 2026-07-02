Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8161DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6056B011E; Thu,  2 Jul 2026 20:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7564E6B011F; Thu,  2 Jul 2026 20:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693756B0120; Thu,  2 Jul 2026 20:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD246B011E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:44:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38F2AA02EC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:12 +0000 (UTC)
X-FDA: 84945069384.11.CB073F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 866B612000D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuI1itK8;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026370;
	b=UZuCl8VM55Z39pLZTx3Dlvoo2O8KMgpROLcVK/T+R50D4JRrQ39ZA6dJGdlOsS5eXaaF3z
	Gvf09kwm7jPIcHM/ij7+DOW50ptkgo2kuhUEn78d75sWYHLHvOWlmHm4m/7dmu3sdptz62
	z8xgHoohcwaFRl7/XfDMPmafMN+mpII=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqypLn7HBMPm5n3CjY0saNzxrJSnEmu/vZcmx6jzwgo=;
	b=nJSRLH4PKO1TNn3jaD9CAZu+ncXgY3+P3LaAw2Eci6X2Mi+CyaF2hxd6o30qDKHA+uVM+J
	/8JrZ5lr0MOCYz+6ef6i59rAU6MIaFC27gusrStWUXG8tis5JgGBOpkh1qiB1fr8bQpd7h
	noIkIVdePTcjMTf83dspl+kwCHe50fU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuI1itK8;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABAAF40A45;
	Thu,  2 Jul 2026 21:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51A21F00A3A;
	Thu,  2 Jul 2026 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026367;
	bh=AqypLn7HBMPm5n3CjY0saNzxrJSnEmu/vZcmx6jzwgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuI1itK8HF3c06LJaFwrLbI4GduWCzH8T3TrDJNGEvVZy4LsgjQ3bPf9Ec1TJ4/8y
	 afQAItrlz1rEguTeHdMw3RVdQ7fXHtP8v5hnDVIrYuv5k9sYIKMEAlR0kokdODrHWm
	 i/rzbb20qKNA8etI7hFpUFbV1PBCcdTRy1qhoJgBw8gq0Q8oJ74rzTztA4Eyry69kF
	 oiqxmHPMvEs5Ws21E1MYvKuCiN2CKIcEi0aaBBvxgr51uHO+kI4hPgr6dreCtNXx4s
	 TWxEmNHaZyeT23H4H4/lVc6GzC47M28udVsROjZoc2R6MkrybEKcx2I2laWBv08CgM
	 aKpV20orj1U9A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/8] mm/damon/core: safely validate src on damon_commit_ctx()
Date: Thu,  2 Jul 2026 14:05:43 -0700
Message-ID: <20260702210551.95167-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702210551.95167-1-sj@kernel.org>
References: <20260702210551.95167-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 866B612000D
X-Stat-Signature: hi7n61unz1gm7dbi7h3brrcib6ns5ajz
X-HE-Tag: 1783026370-304809
X-HE-Meta: U2FsdGVkX1+74gm/oa/reD0+X2w8b8O9yDKATcPzsS9T8nCvM+3bQ9sCdFMXusElc8Jsa6DQa/GcTk7vbDaD1PuEHtWd1TYJ7CRf3C3g0UqL2TLFfZvHvr2CEI1bg9MmaNIeGEX9tbTOfHQs4tYtqziZihGVWzjOJ6BDhHXLfe7rlvizL0rGcOBrL5ha8ANh6N+xhdWtkRMY0c4nvQfaLkpinOw4eD4eJPtiddfPFsxUfDdeY+PI07KuKXud1e1splZEyxQpw1t25pHH5b/iSnUGLldh520XItPBIxwnc2dn3Wz4te+OUWFkrIo7q1qiQPdG3XNjfyiqobgrmk2YXTMtu3HgBJz/6/UEmy95ajdDTeQETAszPWj00y3RYsj4OS/3F2oG9hpSTNonuQwZpDADRY3bIgD2xal/l0DF1OQwujRKBbArP7JoK+ueuuW4UjEHDTE/1M15LA2Opz/f/xSbz5flSoq9rkIpJQk9H5kpyqUZyd+knFoc8XeIb0fIwPQpE1ubbl2jfZ0zrT0TyuUnAeER+1lBN9q28ffBsc661tSLIaJqep2XYLfuK/Z3AvIej3SbozocJ27NAHY8d6bvUgGFpsILL3EafLpfqVH+0ESJCDnjy6FGzqQOdblFvHgMtoN8rdUrZWIYsSHRhRf+4P/a8J4+ekwrJfbGov90KmVjEonlz/cuWTYPLp3r8QQS3E0j/ncg8ysXEw7HnduKLJuOHOWdIt6CnTLiA8d7eoXcBQasAWdXhsgsv2AGd5KKYHl7mrS+AftMRrFG8jhkvfv5sWVS0nO3ZS+X2X6htMrBamYqCbLHyc8647MGMc4CYFMSsHB2wrA0GOcKGh7wEO7hW4Yv8oGs4qKhmk8tV028YrKCFSqUpN4dRJ/xFsRLzxLS+2sL+8R1hd/aaht1ckeMHHHYjWclSP9ZqfWuMqkMpli6vfq7YVKdPuKCxD+pru5xzzx65oF9IgR
 mRor7J92
 rIA3HMEGPpXygw0d+UIQJOmYj95Cb+ZF+kJbc0Q8DlC4okMDu35z2i7QOtlJL7Iw29GJaWjdL5oSR83EEgjq1/qzlTgj2mfT7Qm/x+lYov9eJVhiq4w8IFyODTi8HJbc12WcPZ5MeH8AABaCCCUr4JX/0nsbeupI4F635O+q/J/Gumdlbx/nsdBNHklnLyzj8DxDiFN4V/6eBIm6w2JaRbjYMy+N2WWYoN/89KmvzvTZOTr2bsRH2DZRZw/px8kfKyTfwN6khCseBIPrf3z+hr0CQ2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_ctx() does its holistic parameter set validation while
applying the new parameter in the set one by one.  If it finds a
parameter is invalid, because some invalid parameters may already be
committed (it is called "commit" but not atomic and irreversable), it
stops the running DAMON context.

The callers of the function therefore have to validate the parameters
before calling it.  Because the function already embeds holistic
validation, DAMON_SYSFS reuses it in a safe way.  It creates a
test-purpose context that is not running but mimics the running one, and
calls damon_commit_ctx() against the test purpose context.  If it
succeeds, the parameters are considered valid, and a real
damon_commit_ctx() call against the running context is made with those.

Other callers such as DAMON_RECLAIM and DAMON_LRU_SORT do not expose
full parameters to users.  For efficiency, they validate only the known
set of parameters.  The efficiency gain is arguably small and doubtful,
though.  Meanwhile the maintenance overhead of the multiple different
validations is clearly high.  We actually found and fixed a few bugs in
the class.

Update damon_commit_ctx() to embed DAMON_SYSFS' safe and holistic
validation approach.  Callers can simply call damon_commit_ctx() without
worrying if their parameters are invalid.

Note that damon_commit_ctx() can still cause an unexpected stop of the
running context, if internal memory allocation fails.  It is arguably
unlikely since those internal allocations are too small to fail, but
theoretically possible.  It should also be better addressed, but not
necessarily a blocker of this small and incremental improvement effort.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 61 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 871c6f5257c9e..018dd5ff80324 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1664,20 +1664,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 	return 0;
 }
 
-/**
- * damon_commit_ctx() - Commit parameters of a DAMON context to another.
- * @dst:	The commit destination DAMON context.
- * @src:	The commit source DAMON context.
- *
- * This function copies user-specified parameters from @src to @dst and update
- * the internal status and results accordingly.  Users should use this function
- * for context-level parameters update of running context, instead of manual
- * in-place updates.
- *
- * This function should be called from parameters-update safe context, like
- * damon_call().
- */
-int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
 	int err;
 	struct damos *scheme;
@@ -1732,6 +1719,52 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	return 0;
 }
 
+static struct damon_ctx *damon_new_test_ctx(struct damon_ctx *dst)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return NULL;
+	err = __damon_commit_ctx(test_ctx, dst);
+	if (err) {
+		damon_destroy_ctx(test_ctx);
+		return NULL;
+	}
+	return test_ctx;
+}
+
+/**
+ * damon_commit_ctx() - Commit parameters of a DAMON context to another.
+ * @dst:	The commit destination DAMON context.
+ * @src:	The commit source DAMON context.
+ *
+ * This function copies user-specified parameters from @src to @dst and update
+ * the internal status and results accordingly.  Users should use this function
+ * for context-level parameters update of running context, instead of manual
+ * in-place updates.
+ *
+ * This function should be called from parameters-update safe context, like
+ * damon_call().
+ */
+int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_test_ctx(dst);
+	if (!test_ctx)
+		return -ENOMEM;
+	err = __damon_commit_ctx(test_ctx, src);
+	if (err)
+		goto out;
+	err = __damon_commit_ctx(dst, src);
+out:
+	damon_destroy_ctx(test_ctx);
+	return err;
+}
+
 /**
  * damon_nr_running_ctxs() - Return number of currently running contexts.
  */
-- 
2.47.3

