Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 383AACA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71196B009E; Mon,  5 Oct 2026 04:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49566B009F; Mon,  5 Oct 2026 04:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C123D6B00A0; Mon,  5 Oct 2026 04:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE746B009E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:47:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06755801A8
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:13 +0000 (UTC)
X-FDA: 85287943146.27.B8D2C29
Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 288B4140007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d8r+7RSZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190031;
	b=4+RDILKQ42hOW0nbjZ0+1V1wibZ0GTSXgNFIVieInhRlJZSQb7pAqszok3+vwvSd8rTM87
	sc3sH0Tul4HyAe7He9VNQR1M4TRT4bT/DVzmJ/cJpOhjjGgtMfhn+drTSzS/7qWGKtHJ8U
	D7LF4VXb5X7boGrzNylvCgczB1ehlcQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d8r+7RSZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ibtzv9gb5AW2tmWxz49jNf8G/kwr2RKPf8pg9Ek0x80=;
	b=zCYh7OUwY30ydRauyy5Y5iOH7lFTEF+cWUCDbYrSpYbIeYToEeNUKvHKj/nL6gWeKpQtNF
	jC5xLJqxNrlxdxU6lDZC7+kY+oeKETAFZMbwCYyFRbX8eLBpQfGfPhWhDnfhD/SNYeM3Ac
	vNUPaPhptaUHigofwvclKz0i4q+SmRs=
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-677bd24a602so634186d50.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190030; x=1791794830; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ibtzv9gb5AW2tmWxz49jNf8G/kwr2RKPf8pg9Ek0x80=;
        b=d8r+7RSZdLCipmENCuB/+oAfwFOCqM4EQQZwNXprwbauQgM29vzivqMUYFyLewcIr5
         f2zHQ+L8CL61Vle4gQjcsW6yaemKMbrxs8DApYBeKHU/F4DQuKP5uv8XSyoZLsZxLGBZ
         TIWbjuBgYHD2S4OUar6ptBFgKIOYLVwR51FfdN65oknB2YNp+yY3xG8lTpIjIzQCECIF
         Bt3tYpeS/dcLf63sJrpOJ8oB5WeFeOPUSMiCKNtgU9sOL4hULI82mDxMT3j25MeBKMOy
         Dk7i1Y2hL/9uMxrHR8Xl9zw5nwgyIR4ze0W9WVbunqR82fnM/1NR+NjlSs4Ny33NT+pD
         5KMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190030; x=1791794830;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ibtzv9gb5AW2tmWxz49jNf8G/kwr2RKPf8pg9Ek0x80=;
        b=CyCCapPqmkpa3Ek+qZRYrJZvi00cYO5IMORCALu7vuQa23HsTE4/Udc5ky2mF5TeTM
         dBUPxnd37kz5JwOWblKo/MGHo6cU0Wr/IL/FWCPeh2vyuWUM/nZTYf1XQK6mYbhFl+S2
         s6Cfix6qiyIEhsXydx2aoc7CFf8wVSr2gqhNYHuaWhtCllWxMVItshAOJrt3h+kxIrDL
         uopcETQkhALI0I8dD/k+f9FcC1FBApe9VTmSPzyd6SOfvpD/PZetY8HJu2m7JuZDtqsC
         +g1EiLdUM+UBUyxh731ZCb/FI+SPXeAcDyZfD09knhhvuUuEhZxi+IHrEgK5MebwHlSZ
         FbTg==
X-Forwarded-Encrypted: i=1; AKwUvByoYluDwLBA/jBcF6E4bmGfl5qM502d4nfsN+tg/KOfKOYT/YHE+pBRkIymI/hSsSm/glKM0hlMpA==@kvack.org
X-Gm-Message-State: AFq9FYI67JYPW3G13AzrXWxlF3oEQMa2+XrxDjxOw4cSaarB6KOUSKXh
	Ky+WJx0FoJDVra6gYEY1OLCYx6M2TmkXChtoySBsN8VAZAPFRecPIHU=
X-Gm-Gg: AYBFou3V74gu+INJFXhRrAUZlmJZCTcw5bXpNeJVlKZTN4fUFod+arf9MESxzfHvBrq
	h4D79k098KHo5EAw7JL7WFQ7a2vJPA0qtnb9vpq6kYbdnCG/DEWx2R+kst2WcnYdUAqAYn/5oQ9
	92LCGD4mMoIfgICldlNnexz+bNM/YaiQOnAW1ed7vvTRRwojRxjXoIVNvrQjOcpKjQWpE95szVu
	Figd+BQxdYtO5w3ilkS9GE+Yrxh0mrLWOcFMOvZjGNg4uoj0339mWV59yTEFRWVkZEMQ0m7wHVL
	0BSMZLjr8nLldRn9nEIJJJPQ4qGSjL64bHtt4z5bm+YUidUODc/YEuUQ/3o6KaboCWtjmP1DVYP
	NbyPqLzydoWg1XF1bSnop2lemVY5Xv7G0qLLDnAoZJaU63gi/hJGCcX1Mj6doNFd/PBFIDLUk7n
	0LIGkCUrd5MOzumcEFFiCcXDINVWapR1l4QG/PEUYEO0iS+JZE6eVxc8Kn/CuIsEcntl6WQ55Xq
	iwdQYj/YTghD0rfdYTV2kfuDpBKt7ZCybpjmrEh8GEEntOKG+r6Q6S6XtpePa5rDXrl88NWbcXb
	RMOdSfLfrQp0eZbYnc03yEj4Ecxzi95x99uFGmUWizAgsw==
X-Received: by 2002:a05:690e:d07:b0:677:d034:899a with SMTP id 956f58d0204a3-677d034b44emr1253856d50.93.1791190030013;
        Mon, 05 Oct 2026 01:47:10 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:47:09 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 05 Oct 2026 01:46:51 -0700
Subject: [RFC PATCH v4 7/9] mm/damon/tests/drain-kunit: kunit for report
 rings and ring drain
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-7-b03452e137f3@gmail.com>
References: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
In-Reply-To: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: omd8papyug4x4b4bsmkyqqoykmq79gdk
X-Rspam-User: 
X-Rspamd-Queue-Id: 288B4140007
X-HE-Tag: 1791190030-902155
X-HE-Meta: U2FsdGVkX1/KYZsGpzHfZsWsqEZVxVNhwbvJuLyUk/Pft2Zv1zRQdTRML65ahnZCkhBwNjcyPt5cLiAkwCqbuUhPyyydFqo6r+/d6PVmNvXh/r6InGqm57/2UmrE/R4eHdi+JVE2J8ueMoamjxxC2Z0L6N1SJ2qEOStCQPbL0Wey4v+2leN7G5raj1K+ixu4RmPwCfrGumAD+zVH5FJXSkjbnFseVBXTINwNpldZu42BNJdNwKHo2taK0G/WcZVROJKUOU0/sOnToHu0ZQYvn9m/nUdWuNDrkUefMnQVXffFHJEdmt1YyUBUAUsiQztR0yvThChML2bMdbEQaKDvDMGRMbyzlGfsz1L4lr1hRWd7IUPeKfVOSQ5N8cXAP+UxOYVoVuo9JedtUaDzzjb99O9mmnWnsGzxVA2rCDr2rC+7RWba6Fl+XpxM8p/HJcZcTBh0Rn+uw6R8kOsrA144OCTBqKw1rJh4GX5o3JDQvC1cBPMtsLRjGpCBn2GaxSLkjehgcZ6nYoWzPcdsv7RdZ6ndneDQkibo8AmOkzfD+CNG1/umaOuybR+6gz+nSd8q6CgiDW4hDPRgU+iYxl40yp6WfEid/QF67sXJW46T4iMHkgkaoVXESKFarz3w34kOuvWzLrwkfKxKUKRuXQ4WOXnj2DPbTKffpNjCcLDZBQuEh5F2kF84fAjJB/tsp7BLzkSoXmedEwpGBkAb9gbPISdaAflLSS8bKBsUWfLBFE519PHKQf1z8DLG5iPygxCqvGBBV/BOquZCT98rGo0h3T4M0CEhc+Zdfapeo97ezPO0SIfEnNr9m8ULtMRpNMOn37XHsyEuB8ja8Y0cxrkAadpIBgxIMfEqRm2O5FjELdugoUtFnvZlLd6TwScbYARkojvd13dHFxtT9jTqHU1f5kEcOg/Kk1nXHTCLc7UJBcS+iMCiXiAIZ5QElJW0BXwDRIYuB5zx1LWhZfOzOAx
 mx0Ejv85
 tWl/4Y9ibfnGFx8ybO/Nfv+WktD21ZPsrCOLWntd8WxFA4Et1IFFrkdtyHsGk3Xih6mZr4GVlmxcvrS39s1H7D1dS566mAhNEcdnevupa2s6fH00Oj1CoVCAy/9cWmFi0jtQXumX6JTcE5h90Z88F6jD4g1FHaj9Gbq4diCIgBfUUVV9qzdKy2RANhfIyO5BSrwXvk36pWy/XUSFtNpZXX8DK7hWqH/6UBwKT1xNFBIY6EJcjOIOi5KXAWFhT98mtKG06AmKKxNSyOYfFR1akmGRUeJH9MlSw1XAH9YUakeBWPyd5+DP9aUu1llHKAEmHrcHdQar8pebPmvUS5mdTax5s70ziDUmkzU2O1YpLE5+dboiMKsI8GfzF3HCvos7bUHjj0MqjRDTd6VU9vfahxFWi1X/lT1EWFPdIDYZXbjDfJfC6h46PfSJWQCo3ZZpwiZcCVzpfMgUI6/R/vl5wRy9leyqjGhMJS5CTyP6p3UMH7oTkmRKSny9PVlDD46Xdi7sW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kunit coverage for the per-context perf report rings and the drain
that credits regions from them.  Wire the suites into core.c (included
after the drain and its counters are defined) so CONFIG_DAMON_KUNIT_TEST=y
builds them.

perf-kunit.h covers the ring itself: reports injected and accepted,
overflow safety on wrap, and a report that carries no owning context
being dropped.

drain-kunit.h covers the drain and the damon_report_access() producer:

 - a vaddr report credited to the region holding its address, and not
   credited when its thread group id does not match the target
 - a paddr report credited with no thread-group filtering
 - a perf report credited to the probe hits of its probe index
 - reports adding at most one probe hit per sampling interval and none
   changing nr_accesses, with and without a probe weight set
 - per-context isolation: a report reaches only its own context's ring
 - the producer's return value, and a full ring counted in the ring-full
   counter and freed again by a drain
 - the address-space match: a report whose virtual address falls inside a
   region of a physical-address target, and whose physical address falls
   outside it, is not credited

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c              |   2 +
 mm/damon/tests/drain-kunit.h | 786 +++++++++++++++++++++++++++++++++++++++++++
 mm/damon/tests/perf-kunit.h  | 133 ++++++++
 3 files changed, 921 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c2acae6e19ec..e3c29d7cff23 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -5208,3 +5208,5 @@ struct damon_region *damon_search(unsigned long addr, struct pid *pid)
 subsys_initcall(damon_init);
 
 #include "tests/core-kunit.h"
+#include "tests/drain-kunit.h"
+#include "tests/perf-kunit.h"
diff --git a/mm/damon/tests/drain-kunit.h b/mm/damon/tests/drain-kunit.h
new file mode 100644
index 000000000000..d6e576724421
--- /dev/null
+++ b/mm/damon/tests/drain-kunit.h
@@ -0,0 +1,786 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * DAMON kunit tests for the unified paddr/vaddr report drain path.
+ *
+ * Included at the bottom of core.c (after kdamond_check_reported_accesses
+ * is defined) so the static function is visible.
+ */
+
+#ifdef CONFIG_DAMON_KUNIT_TEST
+
+#ifndef _DAMON_DRAIN_KUNIT_H
+#define _DAMON_DRAIN_KUNIT_H
+
+#include <kunit/test.h>
+#include <linux/damon.h>
+
+/*
+ * Reports are dispatched by probe_idx: probe_idx == DAMON_PROBE_IDX_NONE (0)
+ * has no ring to feed and is dropped by damon_report_access(); probe_idx >= 1
+ * lands in the owning context's per-context perf ring (ctx->perf_rings).  The
+ * drain dispatcher kdamond_check_reported_accesses() drains the perf ring only
+ * for a ctx that has event-driven probes.
+ *
+ * Attach a dummy event-driven probe AND allocate the ctx's per-ctx perf ring
+ * so the ctx both drains the perf ring and has ring storage for injected
+ * probe_idx>=1 reports.  In a live run damon_perf_probe_setup() allocates the
+ * ring; kunit has no real perf event, so it allocates directly.  Returns
+ * 0/-ENOMEM.
+ */
+static int damon_test_attach_perf_probe(struct damon_ctx *ctx)
+{
+	struct damon_probe *p = damon_new_probe();
+	int err;
+
+	if (!p)
+		return -ENOMEM;
+	p->event_driven = true;
+	damon_add_probe(ctx, p);
+
+	err = damon_ctx_alloc_perf_ring(ctx);
+	if (err)
+		return err;
+	return 0;
+}
+
+/*
+ * Mark @ctx as monitoring the physical address space.
+ *
+ * The drain matches a report against the address space of the context, which
+ * damon_target_has_pid() derives from ctx->ops.id, so a context whose targets
+ * carry no pid needs the paddr id for its reports to be matched by paddr.
+ * Only the id is set: the drain reads no other operations field, and these
+ * tests call it directly rather than through a kdamond.
+ */
+static void damon_test_set_paddr_ctx(struct damon_ctx *ctx)
+{
+	ctx->ops.id = DAMON_OPS_PADDR;
+}
+
+/*
+ * Test A: vaddr entry with a matching thread group id drains correctly.
+ *
+ * Create a vaddr ctx with target pid=current, region [0x1000, 0x2000).
+ * Inject entry: paddr=0, vaddr=0x1500, tgid=current tgid, probe_idx=1, ctx=ctx.
+ * After drain: probe_hits[0]==1 (probe_idx 1 stored 0-based), samples_drained
+ * increments.
+ */
+static void damon_test_unified_vaddr_match(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr     = 0,
+		.vaddr     = 0x1500,
+		.probe_idx = 1,
+		.size      = PAGE_SIZE,
+	};
+	unsigned long before, after;
+	int hits;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = get_pid(task_tgid(current));
+	if (!t->pid) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "pid alloc failed");
+	}
+	rep.tgid = task_tgid_nr(current);
+	rep.ctx = ctx;	/* route to this ctx's per-ctx perf ring */
+
+	/*
+	 * Region must fully contain the report [vaddr, vaddr + size): a report
+	 * straddling the region end is rejected by the drain.  With
+	 * vaddr=0x1500 and size=PAGE_SIZE the region must reach >= 0x2500.
+	 */
+	r = damon_new_region(0x1000, 0x3000);
+	if (!r) {
+		put_pid(t->pid);
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(r, t);
+	damon_add_target(ctx, t);
+
+	rep.report_jiffies = jiffies;
+	before = damon_get_samples_drained();
+	damon_report_access(&rep);
+	kdamond_check_reported_accesses(ctx);
+	after = damon_get_samples_drained();
+
+	hits = 0;
+	damon_for_each_region(r, t)
+		hits += r->probe_hits[0];
+
+	KUNIT_EXPECT_EQ(test, hits, 1);
+	KUNIT_EXPECT_GT(test, after, before);
+
+	put_pid(t->pid);
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test B: a vaddr entry whose thread group id matches no target is dropped.
+ *
+ * Same setup but inject with a thread group id no target carries.
+ * probe_hits[0]==0 (probe_idx 1 stored 0-based), samples_no_region increments.
+ */
+static void damon_test_unified_vaddr_tgid_mismatch(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr     = 0,
+		.vaddr     = 0x1500,
+		.tgid      = 9999,	/* matches no target */
+		.probe_idx = 1,
+		.size      = PAGE_SIZE,
+	};
+	unsigned long before, after;
+	int hits;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = get_pid(task_tgid(current));
+	if (!t->pid) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "pid alloc failed");
+	}
+	rep.ctx = ctx;
+
+	/* wide enough for the report: the id mismatch is the sole reject */
+	r = damon_new_region(0x1000, 0x3000);
+	if (!r) {
+		put_pid(t->pid);
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(r, t);
+	damon_add_target(ctx, t);
+
+	rep.report_jiffies = jiffies;
+	before = damon_get_samples_no_region();
+	damon_report_access(&rep);
+	kdamond_check_reported_accesses(ctx);
+	after = damon_get_samples_no_region();
+
+	hits = 0;
+	damon_for_each_region(r, t)
+		hits += r->probe_hits[0];
+
+	KUNIT_EXPECT_EQ(test, hits, 0);
+	KUNIT_EXPECT_GT(test, after, before);
+
+	put_pid(t->pid);
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test C: paddr entry drains correctly (no id filter for paddr ops).
+ *
+ * Create a paddr ctx (no pid), region [0x10000, 0x20000).
+ * Inject: paddr=0x15000, vaddr=0, probe_idx=1, ctx=ctx.
+ * After drain: probe_hits[0]==1 (probe_idx 1 stored 0-based).
+ */
+static void damon_test_unified_paddr_no_regression(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr     = 0x15000,
+		.vaddr     = 0,
+		.tid       = 0,
+		.probe_idx = 1,
+		.size      = PAGE_SIZE,
+	};
+	unsigned long before, after;
+	int hits;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = NULL;	/* paddr target: no pid */
+	damon_test_set_paddr_ctx(ctx);
+	rep.ctx = ctx;
+
+	r = damon_new_region(0x10000, 0x20000);
+	if (!r) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(r, t);
+	damon_add_target(ctx, t);
+
+	rep.report_jiffies = jiffies;
+	before = damon_get_samples_drained();
+	damon_report_access(&rep);
+	kdamond_check_reported_accesses(ctx);
+	after = damon_get_samples_drained();
+
+	hits = 0;
+	damon_for_each_region(r, t)
+		hits += r->probe_hits[0];
+
+	KUNIT_EXPECT_EQ(test, hits, 1);
+	KUNIT_EXPECT_GT(test, after, before);
+
+	damon_destroy_ctx(ctx);
+}
+
+/* Reports add one probe hit per interval and never change nr_accesses. */
+static void damon_test_report_hits_only(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr     = 0x15000,
+		.probe_idx = 1,
+		.size      = PAGE_SIZE,
+	};
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = NULL;
+	damon_test_set_paddr_ctx(ctx);
+	rep.ctx = ctx;
+
+	r = damon_new_region(0x10000, 0x20000);
+	if (!r) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(r, t);
+	damon_add_target(ctx, t);
+
+	rep.report_jiffies = jiffies;
+	preempt_disable();
+	damon_report_access(&rep);
+	damon_report_access(&rep);
+	preempt_enable();
+	kdamond_check_reported_accesses(ctx);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, 0u);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], 1);
+
+	/* a report drained in the next interval adds another hit */
+	ctx->passed_sample_intervals++;
+	rep.report_jiffies = jiffies;
+	preempt_disable();
+	damon_report_access(&rep);
+	preempt_enable();
+	kdamond_check_reported_accesses(ctx);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, 0u);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], 2);
+
+	damon_destroy_ctx(ctx);
+}
+
+/* The same holds with a probe weight set (data attributes-only mode). */
+static void damon_test_report_hits_only_weighted(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_probe *p;
+	struct damon_access_report rep = {
+		.paddr     = 0x15000,
+		.probe_idx = 1,
+		.size      = PAGE_SIZE,
+	};
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+	damon_for_each_probe(p, ctx)
+		p->weight = 1;
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = NULL;
+	damon_test_set_paddr_ctx(ctx);
+	rep.ctx = ctx;
+
+	r = damon_new_region(0x10000, 0x20000);
+	if (!r) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(r, t);
+	damon_add_target(ctx, t);
+
+	preempt_disable();
+	damon_report_access(&rep);
+	damon_report_access(&rep);
+	preempt_enable();
+	kdamond_check_reported_accesses(ctx);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, 0u);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], 1);
+
+	ctx->passed_sample_intervals++;
+	preempt_disable();
+	damon_report_access(&rep);
+	preempt_enable();
+	kdamond_check_reported_accesses(ctx);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, 0u);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], 2);
+
+	damon_destroy_ctx(ctx);
+}
+
+static void damon_test_ring1_perf_credit(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr     = 0x15000,
+		.vaddr     = 0,
+		.tid       = 0,
+		.probe_idx = 1,	/* -> per-ctx perf ring */
+		.size      = PAGE_SIZE,
+	};
+	unsigned long before, after;
+	int hits;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = NULL;
+	damon_test_set_paddr_ctx(ctx);
+	rep.ctx = ctx;
+
+	r = damon_new_region(0x10000, 0x20000);
+	if (!r) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(r, t);
+	damon_add_target(ctx, t);
+
+	rep.report_jiffies = jiffies;
+	before = damon_get_samples_drained();
+	damon_report_access(&rep);
+	kdamond_check_reported_accesses(ctx);
+	after = damon_get_samples_drained();
+
+	hits = 0;
+	damon_for_each_region(r, t)
+		hits += r->probe_hits[0];
+
+	KUNIT_EXPECT_EQ(test, hits, 1);
+	KUNIT_EXPECT_GT(test, after, before);
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test per-context perf ring isolation.
+ *
+ * Two independent perf ctxs (each with its own event-driven probe and its own
+ * per-ctx perf ring) each receive one probe_idx=1 report tagged with their
+ * respective ctx.  Each ctx must credit exactly its own report and see nothing
+ * from the other: perf reports route to the owning ctx's ring, and two
+ * perf-driven ctxs coexist without sharing a ring.
+ */
+static void damon_test_perf_per_ctx_isolation(struct kunit *test)
+{
+	struct damon_ctx *ctx_a, *ctx_b;
+	struct damon_target *ta, *tb;
+	struct damon_region *ra, *rb;
+	struct damon_access_report rep_a = {
+		.paddr = 0x15000, .probe_idx = 1, .size = PAGE_SIZE,
+	};
+	struct damon_access_report rep_b = {
+		.paddr = 0x35000, .probe_idx = 1, .size = PAGE_SIZE,
+	};
+	int hits_a, hits_b;
+
+	ctx_a = damon_new_ctx();
+	ctx_b = damon_new_ctx();
+	if (!ctx_a || !ctx_b) {
+		if (ctx_a)
+			damon_destroy_ctx(ctx_a);
+		if (ctx_b)
+			damon_destroy_ctx(ctx_b);
+		kunit_skip(test, "ctx alloc failed");
+	}
+	if (damon_test_attach_perf_probe(ctx_a) ||
+			damon_test_attach_perf_probe(ctx_b)) {
+		damon_destroy_ctx(ctx_a);
+		damon_destroy_ctx(ctx_b);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+
+	ta = damon_new_target();
+	tb = damon_new_target();
+	if (!ta || !tb) {
+		if (ta)
+			damon_free_target(ta);
+		if (tb)
+			damon_free_target(tb);
+		damon_destroy_ctx(ctx_a);
+		damon_destroy_ctx(ctx_b);
+		kunit_skip(test, "target alloc failed");
+	}
+	ta->pid = NULL;
+	tb->pid = NULL;
+	damon_test_set_paddr_ctx(ctx_a);
+	damon_test_set_paddr_ctx(ctx_b);
+
+	ra = damon_new_region(0x10000, 0x20000);	/* holds rep_a paddr */
+	rb = damon_new_region(0x30000, 0x40000);	/* holds rep_b paddr */
+	if (!ra || !rb) {
+		if (ra)
+			damon_free_region(ra);
+		if (rb)
+			damon_free_region(rb);
+		damon_free_target(ta);
+		damon_free_target(tb);
+		damon_destroy_ctx(ctx_a);
+		damon_destroy_ctx(ctx_b);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(ra, ta);
+	damon_add_target(ctx_a, ta);
+	damon_add_region(rb, tb);
+	damon_add_target(ctx_b, tb);
+
+	/* Each report is tagged with its owning ctx. */
+	rep_a.ctx = ctx_a;
+	rep_b.ctx = ctx_b;
+	rep_a.report_jiffies = jiffies;
+	rep_b.report_jiffies = jiffies;
+
+	/*
+	 * Report into both ctx rings, then drain each ctx.  ctx_a must credit
+	 * only rep_a; ctx_b must credit only rep_b -- no cross-talk.
+	 */
+	damon_report_access(&rep_a);
+	damon_report_access(&rep_b);
+	kdamond_check_reported_accesses(ctx_a);
+	kdamond_check_reported_accesses(ctx_b);
+
+	hits_a = 0;
+	damon_for_each_region(ra, ta)
+		hits_a += ra->probe_hits[0];
+	hits_b = 0;
+	damon_for_each_region(rb, tb)
+		hits_b += rb->probe_hits[0];
+
+	/* each ctx credited its own report only */
+	KUNIT_EXPECT_EQ(test, hits_a, 1);
+	KUNIT_EXPECT_EQ(test, hits_b, 1);
+
+	damon_destroy_ctx(ctx_a);
+	damon_destroy_ctx(ctx_b);
+}
+
+/*
+ * Test the queued/dropped return value, and that a ring-full drop is counted
+ * as ring-full rather than busy-guard.
+ *
+ * A per-context perf ring is private to its ctx, so a freshly created ctx
+ * starts with an empty ring nobody else writes to and the counts are exact.
+ * Preemption is held across the loop so every report targets the same CPU's
+ * ring, per the SPSC invariant damon_report_access() documents.
+ *
+ * A ring holds DAMON_REPORT_RING_SIZE - 1 entries (one slot is kept empty to
+ * distinguish full from empty), so exactly that many reports are queued and
+ * every one after that is dropped.
+ */
+static void damon_test_report_return_value(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_access_report rep = {
+		.paddr = 0x15000, .probe_idx = 1, .size = PAGE_SIZE,
+	};
+	unsigned long full_before, busy_before;
+	unsigned int queued = 0, dropped = 0;
+	int i;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+	rep.ctx = ctx;
+
+	preempt_disable();
+	full_before = damon_get_report_ring_full();
+	busy_before = damon_get_report_busy_drop();
+
+	/* One past capacity, so the last iteration must be a drop. */
+	for (i = 0; i < DAMON_REPORT_RING_SIZE; i++) {
+		if (damon_report_access(&rep))
+			queued++;
+		else
+			dropped++;
+	}
+	preempt_enable();
+
+	KUNIT_EXPECT_EQ(test, queued, (unsigned int)DAMON_REPORT_RING_SIZE - 1);
+	KUNIT_EXPECT_EQ(test, dropped, 1u);
+	/* No NMI nests here, so the drop must be the full ring. */
+	KUNIT_EXPECT_GT(test, damon_get_report_ring_full(), full_before);
+	KUNIT_EXPECT_EQ(test, damon_get_report_busy_drop(), busy_before);
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test that draining restores capacity: fill the ring, drain it via the
+ * dispatcher, then report again and expect the report to be queued.
+ */
+static void damon_test_report_drain_restores_capacity(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr = 0x15000, .probe_idx = 1, .size = PAGE_SIZE,
+	};
+	bool queued;
+	int i;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = NULL;
+	damon_test_set_paddr_ctx(ctx);
+	rep.ctx = ctx;
+
+	r = damon_new_region(0x10000, 0x20000);
+	if (!r) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(r, t);
+	damon_add_target(ctx, t);
+
+	/* Fill the ring: the last report is dropped. */
+	preempt_disable();
+	for (i = 0; i < DAMON_REPORT_RING_SIZE; i++)
+		damon_report_access(&rep);
+	queued = damon_report_access(&rep);
+	preempt_enable();
+	KUNIT_EXPECT_FALSE(test, queued);
+
+	kdamond_check_reported_accesses(ctx);
+
+	/* Capacity is back. */
+	KUNIT_EXPECT_TRUE(test, damon_report_access(&rep));
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test that a report is matched by the address space of the target rather than
+ * by which address it carries.
+ *
+ * Create a paddr ctx with an event-driven probe, region [0x10000, 0x20000).
+ * Inject a report whose vaddr falls inside that region and whose paddr falls
+ * outside it.  A paddr target matches the paddr, so the report finds no
+ * region and is counted as such.
+ */
+static void damon_test_report_addr_space_keyed(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr     = 0x95000,	/* outside the region */
+		.vaddr     = 0x15000,	/* inside the region */
+		.tid       = 0,
+		.probe_idx = 1,
+		.size      = PAGE_SIZE,
+	};
+	unsigned long before, after;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+	rep.ctx = ctx;	/* route to this ctx's per-ctx perf ring */
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = NULL;	/* paddr target: no pid */
+	damon_test_set_paddr_ctx(ctx);
+
+	r = damon_new_region(0x10000, 0x20000);
+	if (!r) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(r, t);
+	damon_add_target(ctx, t);
+
+	rep.report_jiffies = jiffies;
+	before = damon_get_samples_no_region();
+	damon_report_access(&rep);
+	kdamond_check_reported_accesses(ctx);
+	after = damon_get_samples_no_region();
+
+	/* The vaddr was not used to match a paddr target. */
+	KUNIT_EXPECT_GT(test, after, before);
+	damon_for_each_region(r, t)
+		KUNIT_EXPECT_EQ(test, r->probe_hits[0], 0);
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test that filling a perf ring beyond capacity increments the ring-full
+ * counter.  The existing damon_test_report_drain_restores_capacity verifies
+ * capacity returns after a drain; this verifies the counter side of the
+ * same overflow.
+ */
+static void damon_test_ring_full_counter_increments(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_access_report rep = {
+		.paddr = 0x15000, .probe_idx = 1, .size = PAGE_SIZE,
+	};
+	unsigned long full_before;
+	int i;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+	damon_test_set_paddr_ctx(ctx);
+	rep.ctx = ctx;
+
+	full_before = damon_get_report_ring_full();
+
+	/* Fill the ring to capacity, then push one more to trigger overflow. */
+	preempt_disable();
+	for (i = 0; i < DAMON_REPORT_RING_SIZE; i++)
+		damon_report_access(&rep);
+	damon_report_access(&rep);   /* this one overflows */
+	preempt_enable();
+
+	KUNIT_EXPECT_GT(test, damon_get_report_ring_full(), full_before);
+
+	damon_destroy_ctx(ctx);
+}
+
+static struct kunit_case damon_drain_test_cases[] = {
+	KUNIT_CASE(damon_test_unified_vaddr_match),
+	KUNIT_CASE(damon_test_unified_vaddr_tgid_mismatch),
+	KUNIT_CASE(damon_test_unified_paddr_no_regression),
+	KUNIT_CASE(damon_test_report_hits_only),
+	KUNIT_CASE(damon_test_report_hits_only_weighted),
+	KUNIT_CASE(damon_test_ring1_perf_credit),
+	KUNIT_CASE(damon_test_perf_per_ctx_isolation),
+	KUNIT_CASE(damon_test_report_return_value),
+	KUNIT_CASE(damon_test_report_drain_restores_capacity),
+	KUNIT_CASE(damon_test_report_addr_space_keyed),
+	KUNIT_CASE(damon_test_ring_full_counter_increments),
+	{}
+};
+
+static struct kunit_suite damon_drain_test_suite = {
+	.name = "damon_drain",
+	.test_cases = damon_drain_test_cases,
+};
+
+kunit_test_suite(damon_drain_test_suite);
+
+#endif /* _DAMON_DRAIN_KUNIT_H */
+
+#endif	/* CONFIG_DAMON_KUNIT_TEST */
diff --git a/mm/damon/tests/perf-kunit.h b/mm/damon/tests/perf-kunit.h
new file mode 100644
index 000000000000..de4472b54224
--- /dev/null
+++ b/mm/damon/tests/perf-kunit.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * DAMON kunit tests for the per-context perf report ring.
+ *
+ * Included at the bottom of core.c, after tests/drain-kunit.h, whose
+ * damon_test_attach_perf_probe() helper these tests reuse.
+ */
+
+#ifdef CONFIG_DAMON_KUNIT_TEST
+
+#ifndef _DAMON_PERF_KUNIT_H
+#define _DAMON_PERF_KUNIT_H
+
+#include <kunit/test.h>
+#include <linux/damon.h>
+
+/*
+ * A report with probe_idx >= 1 is enqueued into the ring of the context named
+ * by report->ctx, so these tests build a context with an allocated perf ring
+ * and point the injected reports at it.  A freshly allocated ring is empty,
+ * which makes the accepted and rejected counts below exact.
+ */
+
+/*
+ * Test A: perf ring basic write
+ *
+ * Inject reports into a context's perf ring via damon_report_access() and
+ * verify each one is accepted.
+ */
+static void damon_test_perf_ring_basic(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_access_report report = {
+		.paddr = 0x1000, .size = PAGE_SIZE, .probe_idx = 1,
+	};
+	int i;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf ring alloc failed");
+	}
+	report.ctx = ctx;
+
+	for (i = 0; i < 3; i++)
+		KUNIT_EXPECT_TRUE(test, damon_report_access(&report));
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test B: ring overflow is reported and does not corrupt head/tail
+ *
+ * Fill a context's perf ring to capacity and verify that further writes are
+ * refused and counted rather than overwriting live entries.  The ring holds
+ * DAMON_REPORT_RING_SIZE - 1 entries, one slot being reserved to distinguish
+ * full from empty, so the last two of the writes below must be refused.
+ */
+static void damon_test_perf_ring_overflow_safety(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_access_report report = {
+		.paddr = 0x3000, .size = PAGE_SIZE, .probe_idx = 1,
+	};
+	unsigned long overflow_before, overflow_after;
+	int queued = 0, refused = 0;
+	int i;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf ring alloc failed");
+	}
+	report.ctx = ctx;
+
+	/* Pinned so every write lands in the same CPU's ring. */
+	preempt_disable();
+	overflow_before = damon_get_report_overflow();
+
+	for (i = 0; i < DAMON_REPORT_RING_SIZE + 1; i++) {
+		if (damon_report_access(&report))
+			queued++;
+		else
+			refused++;
+	}
+
+	overflow_after = damon_get_report_overflow();
+	preempt_enable();
+
+	KUNIT_EXPECT_EQ(test, queued, DAMON_REPORT_RING_SIZE - 1);
+	KUNIT_EXPECT_EQ(test, refused, 2);
+	KUNIT_EXPECT_GT(test, overflow_after, overflow_before);
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test C: a perf report without an owning context is refused
+ *
+ * A report with probe_idx >= 1 but no ctx cannot be routed to a ring.  Verify
+ * it is refused instead of dereferenced.
+ */
+static void damon_test_perf_report_requires_ctx(struct kunit *test)
+{
+	struct damon_access_report report = {
+		.paddr = 0x5000, .size = PAGE_SIZE, .probe_idx = 1,
+		.ctx = NULL,
+	};
+
+	KUNIT_EXPECT_FALSE(test, damon_report_access(&report));
+}
+
+static struct kunit_case damon_perf_test_cases[] = {
+	KUNIT_CASE(damon_test_perf_ring_basic),
+	KUNIT_CASE(damon_test_perf_ring_overflow_safety),
+	KUNIT_CASE(damon_test_perf_report_requires_ctx),
+	{}
+};
+
+static struct kunit_suite damon_perf_test_suite = {
+	.name = "damon_perf",
+	.test_cases = damon_perf_test_cases,
+};
+
+kunit_test_suite(damon_perf_test_suite);
+
+#endif /* _DAMON_PERF_KUNIT_H */
+
+#endif	/* CONFIG_DAMON_KUNIT_TEST */

-- 
Git-157)


