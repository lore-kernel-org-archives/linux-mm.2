Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA568C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859BC6B00A0; Thu, 10 Sep 2026 13:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830B06B00A1; Thu, 10 Sep 2026 13:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D24B6B00A2; Thu, 10 Sep 2026 13:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 313B26B00A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA721405D4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:48 +0000 (UTC)
X-FDA: 85198507296.09.1DFCD68
Received: from mail-yx2-f10.google.com (mail-yx2-f10.google.com [74.125.224.138])
	by imf18.hostedemail.com (Postfix) with ESMTP id 037531C0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UxVVIeRN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.138 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WkRPK7xkrKjdbYOxpzMt5VDcl8Se5vxYMQUOPmPxzCM=;
	b=gCf7Hi+qnvnA7SimwHi3QKLCrIRVjTX2j1z031CGr9sIBy8lO1VtJsEU58IL1v4yrLuivM
	7MyBmCaTiDOf+vscMq8rSd0r36h1BjvVPVoAItPnqKH7h28B97k/msFOgHC4KOV9fA+a7I
	FnzGUMBJg/twX6OPdCMvLN7P91UiNeg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060607;
	b=Gg1oMSGRjKAw4/HfZWToVZKICtYybyccZn2ZHJCF+rnNzz1fOSzpxFgewf3Ve2q45D+TLH
	X11yoPws+G6brD4yjdNnaPOWa7JkLE7W/I6cdgyfWGxjLH+Fy1DORCdZi656CpXWsalEJ1
	vCRZRO7jgh8zb/qB1zHEgFUXVLYnW5M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UxVVIeRN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.138 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
Received: by mail-yx2-f10.google.com with SMTP id 956f58d0204a3-66e56a1fe8aso2093974d50.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060606; x=1789665406; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WkRPK7xkrKjdbYOxpzMt5VDcl8Se5vxYMQUOPmPxzCM=;
        b=UxVVIeRNTKxfVOJOSByJpbBITH61PcPaM0rXTm10pUcc3Y0n4W9Civi5U9DAhmw/9G
         Qole6gnXd0BuiLyzTL/TpCXhepQzY9ZINWqrm1x1TV9gRMzO5HNs4u1d7ndQkEu1cJkd
         GD69b5dbyqY4UKbs+HrDpS1c/DmWdpsGpQ8FhCfRxtqJM2sGnqy0NM3OxR4WEwgrUVyJ
         Yj7zeHuJtMZdVkTAPmc5nbnn0Bpvzwtj54GbYcQ6bFfA0/gPJoDxjuQzLqX/xI/vulRi
         uL9zMraO9bRKJmier0zJt5LD8GSLUdoLYLZgpBg+6ULPBdOLwyuaDWedgMQKlH4oZd5t
         09Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060606; x=1789665406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WkRPK7xkrKjdbYOxpzMt5VDcl8Se5vxYMQUOPmPxzCM=;
        b=Tfp5MSqVgQE0pYN39kWZqSe1vrJTEbRqjsuv9nq43BfV8vKs5IUHAkVgRUe3H57+pM
         qEAIGRRI7rM2Rbkm4fsagMrACusV5ZGGklrZ1oYwYNgZbl8vQoXjKS6KahoOFUmafkR1
         jyqMNwhuuQRtnAy31svbI1LH0ZKKI0CLabsDJbyyuW+/sEVhc0Rk6LKYll/HMiYqkOMZ
         wXZcdD/uVlfxPmHJIO+dPpF5o5s33gG9rLM2suRsmsza1GEhQxsS6rZbkPuqeT/cK6ca
         0b1D9/SlUEzxxyF5LOcdYzypoy64Yy+k6Lrf/MydvNnxBqftJDvOymzvXhcfcs8Godoa
         7bug==
X-Forwarded-Encrypted: i=1; AKwUvBwl8KxUFVW0oRqzXmxU1V853Y4Xd2YVyybcLPX2dXX5UvZPCZCzylzhiJuX+kWFpgM6Chixkf9ZqA==@kvack.org
X-Gm-Message-State: AFuF++n0agj8qqtBMNtpf8KZGzB7N0kBTxxfJN2Z0vGicYZubC6AT8Ar
	LTgVW5ee6WdsfGW1/dMoWNkrhVDzpvhRRmuJZaZtwZ5P0lr7n42ce+k=
X-Gm-Gg: AYBFou1Gt919PErfb2hbHYwufbxW+YL6NAaCmQOza1xgajBI1FfE8nR9fa9uQMMGoJv
	xqWv8J4liNnTcKSwEZMm2I8Z+dNUjgsTWiE0CNaeirCgLQkbdiI1y2qYIA8bc07MJqrDvYBm6qN
	i+pS4oLF8u+GvN5oafZjS2ESTuy9TogXP1Ba+VkaIYZ7s55OrimKutisM2xNNQzCmSistP7Ea07
	/5GNFJNnNd0i1L5yMTfVjQ7hX4k2THr4qeS+LEbOvtfHTIfUnt+3aLsNbyRuecQwMdzJw8JwbXB
	P1ENOgXQTAv+Hh3xSc+hdPmUHqsKZJ62clOhknpmr2Sqn6lGi8+cblga3aS849IRiERkcK2IRKC
	ZKxHueBFY+BCjO56rVNECEsxvxzzNN71KdubAQLFrxTYPeZHLcQavN/+PtPAw4c4WRG2KkunIRh
	f8TjNSt6sOR6VELEh/uosC25gfhAj51D1C62LYJdqDAUeEc6qqLlsJvnsG1FYgpk3t/IHnIVSno
	WkW1qXI7eV3ekAgARX1GgCL8jpjXH1SMofsUJ/6+ocK4XXP7A==
X-Received: by 2002:a05:690e:204a:b0:671:1c6d:b634 with SMTP id 956f58d0204a3-6712477b2b9mr118682d50.75.1789060605410;
        Thu, 10 Sep 2026 10:16:45 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb48b374bsm14223678d50.3.2026.09.10.10.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:44 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: [RFC PATCH v2 9/9] mm/damon/tests/drain-kunit: kunit for report rings and unified drain
Date: Thu, 10 Sep 2026 10:16:23 -0700
Message-ID: <20260910171623.6638-10-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 037531C0007
X-Stat-Signature: mqpgeu31pbpqknw8dgeeeo3gcwiswtit
X-HE-Tag: 1789060606-610806
X-HE-Meta: U2FsdGVkX1+bztEmAiEVWeAmhde3qmP3qKtFP92IcdXuacRCc0T7DxV+pV7eo/KbfI05kpmhpSmRNkiuNICanGvcuGQ+tu7au7MUJdhr5fB7oEyfZw5OBUEtpH9S0kriSR1S5mHYRnVbWDqlqGc9jwW0V4gLEPZ5bmpFogPUGZLUb8l+66KLbAY+NO7f2mSbD/hACsfvJ/TXgQs9VWfidq+IylyhIWk3CuypBEY/ro6g071v7rWotKk0edenZoTkMK2TP/a3zdWq3nk1a3pYpT9RIj1x3irkItORW4S1bNr/nilI4GGXIqUovC1ALMZe0LiJs7dF+ExvTaehniL5dEePD0oCvU0NBarUnJioaAhnj9t1VRWIH8nSp3pVmil5G0leOQRLmyZK/bd7yE/8n+TYzMR2m/beOtGKBkRtSCq7DdHuOKewNZVVznyU7uqvfhExdmCfWSRTNAUqNTDyPLLRlcEpsMwvHODbeBO1PPFXO+nr7xtLkRlfAxi8LLKzf2fO2x6g9fdQT+wqaP5l+idrKv1ePm+DSFJz8dvQkxVzuCAOKkOXSUTPeQudyG3YIPDIUvLyvSnrTNfqoc5K5X0nScXORCZ0oUtLU654JPplsCQXverlqfnJEFZJAJ/oqEK0YxWFhucxT8tGkB6GYwIJhymD4o7+olfZQwGNCVaVqeNa9xbSzrLcIfN5i6jsXveeoOnZjCwLnNlauyCB8Iz/KbumIvX2n6F49Pj0Ilxr86OAhAXJ+TwJxSp4Mrkyg8m9EbRoGBVXGdpUdMo0dtPFOqr6hYaAJAj0WmZchkWjum5B0SM2SmBQg2n5xyEVCZ29SjF4AlmBfun2AjeGL2HDT80ZimNvNN+C6CnhVTFeZjf4lCYn8KkxDEGb9x+sjja6iKSu67qImNwDkN4ABeQGAQsEdwm4sbtmZw65LOh8nqd41nH4A7/OsrK69XM6V2OELTN/VGaNy2uprkH
 jb0TrTS1
 gkz1Y5T4pnXvj1mQjKWp09vmit3nyGGrevdwIUSU3u7o4ckx1B2TfT9eOwDyyKok0B1F8sUgsK6I2H8b40tPMguMZJRYwyxGQd1NMMLKXiQqFe1WnLwhdo/lBIW4oKLQyGalrUGjsfsDlQJmkvBInXF03Xb7kdpqpjzypkF1DHyr9EXMoTXoO16aW1y7ARpwO+ACIuEVreGA8758ZUBY3+NEAtwWffSwGouh4PFxItf+NoSf28H7BvllkfCxzxYJgHuyXSve3uLXW3WTGDmmszmXT4utXWpbuq/6A8uVy/5V9bPTu5vxnrcPH21E+0h826fVdjH2bwq9QLnEKXinR5JBOJ4AOIBm+5paqkJxZ05k9v6wzQcVbWcbXGM086llgAXrXRF1ZtVdrDolhJAsV5we/Q34Mm5hA9Euz0+pJ/aTez42WYoVVw8c9RgiLYC8tJeCIZBV75cHRtJIlRRTqXHB3PLzX6FM5bvTU8DT2dyFdaM6NV/CxRVYsE/hTJNnDf5kVYAsQxqHd0gJrficyevnwNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kunit coverage for the report rings (the global page-fault ring and
a per-context perf ring) and the unified drain: ring inject/drain,
overflow safety on wrap, the damon_report_access() producer + probe_idx
routing (page-fault reports to the global pf ring, perf reports to the
reporting ctx's own perf ring), ring partition, the pf-ring owner
-EBUSY guard, vaddr thread-group-id filtering, and paddr crediting left
unfiltered.  Wire the suites into core.c (included after the drain and its
counters are defined) so CONFIG_DAMON_KUNIT_TEST=y builds them.

Cover the page-fault primitive and an event-driven probe sharing one
context: a report on each ring credits the access rate of the region
while only the probe report reaches the probe hits array feeding the
weighted sum.  Cover the address-space match by injecting a report whose
virtual address falls inside a region of a physical address space target
and whose physical address falls outside it, which is not credited.
Cover the hot and cold sides of the page-fault signal by reporting an
access on one of two regions and aging both.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c              |    2 +
 mm/damon/tests/.kunitconfig  |    4 +
 mm/damon/tests/drain-kunit.h | 1091 ++++++++++++++++++++++++++++++++++
 mm/damon/tests/perf-kunit.h  |  133 +++++
 4 files changed, 1230 insertions(+)
 create mode 100644 mm/damon/tests/drain-kunit.h
 create mode 100644 mm/damon/tests/perf-kunit.h

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 37909420910e2..d14795993a888 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -5354,3 +5354,5 @@ struct damon_region *damon_search(unsigned long addr, struct pid *pid)
 subsys_initcall(damon_init);
 
 #include "tests/core-kunit.h"
+#include "tests/drain-kunit.h"
+#include "tests/perf-kunit.h"
diff --git a/mm/damon/tests/.kunitconfig b/mm/damon/tests/.kunitconfig
index 144d27e6ecc5c..8096aca135807 100644
--- a/mm/damon/tests/.kunitconfig
+++ b/mm/damon/tests/.kunitconfig
@@ -16,3 +16,7 @@ CONFIG_DAMON_SYSFS_KUNIT_TEST=y
 
 # enable DAMON_DEBUG_SANITY to catch any bug
 CONFIG_DAMON_DEBUG_SANITY=y
+
+# for global report rings (pf/perf) and per-PMU exclusivity tests
+CONFIG_PERF_EVENTS=y
+CONFIG_DAMON_PERF_SOURCE=y
diff --git a/mm/damon/tests/drain-kunit.h b/mm/damon/tests/drain-kunit.h
new file mode 100644
index 0000000000000..21ad90027eddb
--- /dev/null
+++ b/mm/damon/tests/drain-kunit.h
@@ -0,0 +1,1091 @@
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
+ * Reports are partitioned by probe_idx: probe_idx == DAMON_PROBE_IDX_NONE (0)
+ * lands in the global page_fault ring; probe_idx >= 1 lands in the owning
+ * context's per-context perf ring (ctx->perf_rings).  The drain dispatcher
+ * kdamond_check_reported_accesses() drains the perf ring only for a ctx that
+ * has event-driven probes.
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
+	rep.tgid = task_tgid_vnr(current);
+	rep.ctx = ctx;	/* route to this ctx's per-ctx perf ring */
+
+	/*
+	 * Region must fully contain the report [vaddr, vaddr + size): a report
+	 * straddling the region end is rejected by the drain (correctly).  With
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
+	/* Wide enough to contain the report; the id mismatch is the sole reject reason. */
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
+/*
+ * Test pf-ring credit: a page_fault ctx drains the global pf ring.
+ *
+ * Create a paddr ctx with page_fault primitive enabled (no probes), region
+ * [0x10000, 0x20000).  Inject probe_idx=0 (DAMON_PROBE_IDX_NONE) paddr entry;
+ * such reports carry no ctx and land in the global pf ring.  After drain via
+ * the dispatcher: samples_drained increments (access rate credited) and
+ * probe_hits stays 0 (no probe attribution for probe_idx 0).
+ */
+static void damon_test_ring0_pagefault_credit(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr     = 0x15000,
+		.vaddr     = 0,
+		.tid       = 0,
+		.probe_idx = 0,	/* DAMON_PROBE_IDX_NONE -> global pf ring */
+		.size      = PAGE_SIZE,
+	};
+	unsigned long before, after;
+	int hits;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	/* page_fault primitive: routes drain to the global pf ring. */
+	ctx->sample_control.primitives_enabled.page_table = false;
+	ctx->sample_control.primitives_enabled.page_fault = true;
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
+	before = damon_get_samples_drained();
+	damon_report_access(&rep);
+	kdamond_check_reported_accesses(ctx);
+	after = damon_get_samples_drained();
+
+	hits = 0;
+	damon_for_each_region(r, t)
+		hits += r->probe_hits[0];
+
+	KUNIT_EXPECT_EQ(test, hits, 0);	/* probe_idx 0: no probe_hits */
+	KUNIT_EXPECT_GT(test, after, before);
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test pf-ring cold-demote signal: complements ring0_pagefault_credit
+ * (which proves the HOT side).  This proves the COLD side.
+ *
+ * Create a paddr ctx with the page_fault primitive enabled (no probes) and one
+ * target with TWO regions: HOT [0x10000, 0x20000) and COLD [0x20000, 0x30000).
+ * Prime both regions to the same nonzero nr_accesses so aging is observable.
+ * Inject a single page_fault report (probe_idx=0 -> pf ring) hitting only the
+ * HOT region, then run the drain + zero-access-report aging pass:
+ *
+ *   kdamond_check_reported_accesses() credits the HOT region: it gets a
+ *   nr_accesses bump and access_reported=true; the COLD region is untouched.
+ *
+ *   kdamond_apply_zero_access_report() clears access_reported on the HOT
+ *   region (keeping its nr_accesses) and, because the COLD region was NOT
+ *   reported this tick, calls damon_update_region_access_rate(r, false) on it
+ *   (no credit) so the COLD region does not advance.
+ *
+ * After the cycle the HOT region's nr_accesses has pulled ahead of the COLD
+ * region's (HOT > COLD) -- the cold-demote signal a migrate_cold scheme acts
+ * on -- and access_reported is false on both regions again.
+ */
+static void damon_test_ring0_pagefault_cold_demote(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *hot, *cold;
+	struct damon_access_report rep = {
+		.paddr     = 0x15000,	/* inside HOT region */
+		.vaddr     = 0,
+		.tid       = 0,
+		.probe_idx = 0,	/* DAMON_PROBE_IDX_NONE -> global pf ring */
+		.size      = PAGE_SIZE,
+	};
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	/* page_fault primitive: routes drain to the global pf ring. */
+	ctx->sample_control.primitives_enabled.page_table = false;
+	ctx->sample_control.primitives_enabled.page_fault = true;
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = NULL;	/* paddr target: no pid */
+	damon_test_set_paddr_ctx(ctx);
+
+	hot = damon_new_region(0x10000, 0x20000);
+	if (!hot) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "hot region alloc failed");
+	}
+	damon_add_region(hot, t);
+
+	cold = damon_new_region(0x20000, 0x30000);
+	if (!cold) {
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "cold region alloc failed");
+	}
+	damon_add_region(cold, t);
+	damon_add_target(ctx, t);
+
+	/* Prime both regions to the same nonzero access rate. */
+	hot->nr_accesses = 4;
+	cold->nr_accesses = 4;
+
+	/* Inject a pf-ring report hitting only the HOT region, then drain. */
+	rep.report_jiffies = jiffies;
+	damon_report_access(&rep);
+	kdamond_check_reported_accesses(ctx);
+
+	/* HOT reported this tick; COLD was not. */
+	KUNIT_EXPECT_TRUE(test, hot->access_reported);
+	KUNIT_EXPECT_FALSE(test, cold->access_reported);
+
+	/* Aging pass: HOT keeps its (credited) rate; COLD is not credited. */
+	kdamond_apply_zero_access_report(ctx);
+
+	/* Cold-demote signal: HOT pulled ahead of COLD. */
+	KUNIT_EXPECT_GT(test, hot->nr_accesses, cold->nr_accesses);
+	/* access_reported cleared on both after the zero-report pass. */
+	KUNIT_EXPECT_FALSE(test, hot->access_reported);
+	KUNIT_EXPECT_FALSE(test, cold->access_reported);
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test perf-ring credit: a perf ctx drains its own per-ctx perf ring.
+ *
+ * Create a paddr ctx with an event-driven probe (which allocates the ctx's
+ * per-ctx perf ring), region [0x10000, 0x20000).  Inject a probe_idx=1 paddr
+ * entry tagged with ctx, so it lands in that ctx's perf ring.  After drain:
+ * probe_hits[0]==1.
+ */
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
+ * Test ring partition: a perf-only ctx does NOT consume a pf-ring entry.
+ *
+ * Inject a probe_idx=0 (global pf ring) entry, then drain with a perf-only ctx
+ * (event probe, page_fault disabled).  The perf ctx drains only its per-ctx
+ * perf ring, which is empty, so samples_drained must NOT change.  A subsequent
+ * pf ctx drain consumes the entry (samples_drained increments), proving the
+ * entry was partitioned into the global pf ring and left untouched by the perf
+ * drain.
+ */
+static void damon_test_ring_partition(struct kunit *test)
+{
+	struct damon_ctx *perf_ctx, *pf_ctx;
+	struct damon_target *t_perf, *t_pf;
+	struct damon_region *r;
+	struct damon_access_report rep = {
+		.paddr     = 0x15000,
+		.vaddr     = 0,
+		.tid       = 0,
+		.probe_idx = 0,	/* DAMON_PROBE_IDX_NONE -> global pf ring */
+		.size      = PAGE_SIZE,
+	};
+	unsigned long before, mid, after;
+
+	perf_ctx = damon_new_ctx();
+	if (!perf_ctx)
+		kunit_skip(test, "perf ctx alloc failed");
+	if (damon_test_attach_perf_probe(perf_ctx)) {
+		damon_destroy_ctx(perf_ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+	t_perf = damon_new_target();
+	if (!t_perf) {
+		damon_destroy_ctx(perf_ctx);
+		kunit_skip(test, "perf target alloc failed");
+	}
+	t_perf->pid = NULL;
+	damon_test_set_paddr_ctx(perf_ctx);
+	r = damon_new_region(0x10000, 0x20000);
+	if (!r) {
+		damon_free_target(t_perf);
+		damon_destroy_ctx(perf_ctx);
+		kunit_skip(test, "perf region alloc failed");
+	}
+	damon_add_region(r, t_perf);
+	damon_add_target(perf_ctx, t_perf);
+
+	pf_ctx = damon_new_ctx();
+	if (!pf_ctx) {
+		damon_destroy_ctx(perf_ctx);
+		kunit_skip(test, "pf ctx alloc failed");
+	}
+	pf_ctx->sample_control.primitives_enabled.page_table = false;
+	pf_ctx->sample_control.primitives_enabled.page_fault = true;
+	t_pf = damon_new_target();
+	if (!t_pf) {
+		damon_destroy_ctx(pf_ctx);
+		damon_destroy_ctx(perf_ctx);
+		kunit_skip(test, "pf target alloc failed");
+	}
+	t_pf->pid = NULL;
+	damon_test_set_paddr_ctx(pf_ctx);
+	r = damon_new_region(0x10000, 0x20000);
+	if (!r) {
+		damon_free_target(t_pf);
+		damon_destroy_ctx(pf_ctx);
+		damon_destroy_ctx(perf_ctx);
+		kunit_skip(test, "pf region alloc failed");
+	}
+	damon_add_region(r, t_pf);
+	damon_add_target(pf_ctx, t_pf);
+
+	rep.report_jiffies = jiffies;
+	before = damon_get_samples_drained();
+	damon_report_access(&rep);		/* lands in the global pf ring */
+	kdamond_check_reported_accesses(perf_ctx); /* drains perf ring only */
+	mid = damon_get_samples_drained();
+	kdamond_check_reported_accesses(pf_ctx);   /* drains pf ring */
+	after = damon_get_samples_drained();
+
+	KUNIT_EXPECT_EQ(test, mid, before);	/* perf drain left pf entry */
+	KUNIT_EXPECT_GT(test, after, mid);	/* pf drain consumed it */
+
+	damon_destroy_ctx(pf_ctx);
+	damon_destroy_ctx(perf_ctx);
+}
+
+/*
+ * Test per-context perf ring isolation.
+ *
+ * Two independent perf ctxs (each with its own event-driven probe and its own
+ * per-ctx perf ring) each receive one probe_idx=1 report tagged with their
+ * respective ctx.  Each ctx must credit exactly its own report and see nothing
+ * from the other: proof that perf reports route to the owning ctx's ring, and
+ * that two perf-driven ctxs coexist without a shared ring or a cross-ctx owner
+ * guard (unlike the global perf ring, which allowed only one perf drainer).
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
+	 * only rep_a; ctx_b must credit only rep_b -- no cross-talk, and no
+	 * -EBUSY from a second perf drainer.
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
+	KUNIT_EXPECT_EQ(test, hits_a, 1);	/* ctx_a credited its own report */
+	KUNIT_EXPECT_EQ(test, hits_b, 1);	/* ctx_b credited its own report */
+
+	damon_destroy_ctx(ctx_a);
+	damon_destroy_ctx(ctx_b);
+}
+
+/*
+ * Test pf-ring single-owner claim (page_fault only).
+ *
+ * The global pf ring is a destructive SPSC channel with a single owner:
+ * two ctxs draining it in one batch must be rejected with -EBUSY.  The perf
+ * ring has no such batch-claim owner (it is per-ctx), so only the pf owner
+ * helper is exercised here.
+ */
+static void damon_test_pf_ring_owner_ebusy(struct kunit *test)
+{
+	struct damon_ctx *a, *b;
+	struct damon_ctx *arr[2];
+	struct damon_ctx *owner_pf;
+	int err;
+
+	a = damon_new_ctx();
+	b = damon_new_ctx();
+	if (!a || !b) {
+		if (a)
+			damon_destroy_ctx(a);
+		if (b)
+			damon_destroy_ctx(b);
+		kunit_skip(test, "ctx alloc failed");
+	}
+
+	/* Both drain the global pf ring: same-ring collision -> -EBUSY. */
+	a->sample_control.primitives_enabled.page_table = false;
+	a->sample_control.primitives_enabled.page_fault = true;
+	b->sample_control.primitives_enabled.page_table = false;
+	b->sample_control.primitives_enabled.page_fault = true;
+	arr[0] = a;
+	arr[1] = b;
+	owner_pf = NULL;
+	err = damon_claim_ring_owner_start(arr, 2, damon_drains_ring_pf,
+			&owner_pf);
+	KUNIT_EXPECT_EQ(test, err, -EBUSY);
+
+	/* Only a drains pf: single owner, claimed to a. */
+	b->sample_control.primitives_enabled.page_fault = false;
+	owner_pf = NULL;
+	err = damon_claim_ring_owner_start(arr, 2, damon_drains_ring_pf,
+			&owner_pf);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_PTR_EQ(test, owner_pf, a);
+
+	damon_destroy_ctx(a);
+	damon_destroy_ctx(b);
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
+	KUNIT_EXPECT_FALSE(test, damon_report_access(&rep));
+	preempt_enable();
+
+	kdamond_check_reported_accesses(ctx);
+
+	/* Capacity is back. */
+	preempt_disable();
+	KUNIT_EXPECT_TRUE(test, damon_report_access(&rep));
+	preempt_enable();
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test that a page_fault report and an event-driven probe report credit the
+ * same region in one context.
+ *
+ * Create a paddr ctx with the page_fault primitive enabled AND a weighted
+ * event-driven probe, region [0x10000, 0x20000).  Inject one report on each
+ * ring: probe_idx=0 (pf ring) and probe_idx=1 (perf ring).  The drain
+ * dispatcher drains both, so the access rate is credited twice while only the
+ * probe report lands in probe_hits[].
+ */
+static void damon_test_pf_and_probe_one_ctx(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_probe *p;
+	struct damon_access_report pf_rep = {
+		.paddr     = 0x15000,
+		.probe_idx = 0,	/* DAMON_PROBE_IDX_NONE -> global pf ring */
+		.size      = PAGE_SIZE,
+	};
+	struct damon_access_report probe_rep = {
+		.paddr     = 0x16000,
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
+	/* A nonzero weight selects the probe-weighted score. */
+	damon_for_each_probe(p, ctx)
+		p->weight = 1;
+	ctx->sample_control.primitives_enabled.page_table = false;
+	ctx->sample_control.primitives_enabled.page_fault = true;
+	probe_rep.ctx = ctx;
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
+	pf_rep.report_jiffies = jiffies;
+	probe_rep.report_jiffies = jiffies;
+	before = damon_get_samples_drained();
+	damon_report_access(&pf_rep);
+	damon_report_access(&probe_rep);
+	kdamond_check_reported_accesses(ctx);
+	after = damon_get_samples_drained();
+
+	hits = 0;
+	damon_for_each_region(r, t)
+		hits += r->probe_hits[0];
+
+	/* Both reports credited the access rate. */
+	KUNIT_EXPECT_EQ(test, after - before, 2ul);
+	/* Only the probe report has a probe_hits[] slot. */
+	KUNIT_EXPECT_EQ(test, hits, 1);
+	/* The weighted sum sees the probe hit. */
+	damon_for_each_region(r, t)
+		KUNIT_EXPECT_EQ(test,
+				damon_probe_hits_wsum(r, false, false, ctx), 1u);
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test that a report is matched by the address space of the target rather than
+ * by which address it carries.
+ *
+ * Create a paddr ctx with the page_fault primitive, region
+ * [0x10000, 0x20000).  Inject a report whose vaddr falls inside that region
+ * and whose paddr falls outside it.  A paddr target matches the paddr, so the
+ * report finds no region and is counted as such.
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
+		.probe_idx = 0,
+		.size      = PAGE_SIZE,
+	};
+	unsigned long before, after;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	ctx->sample_control.primitives_enabled.page_table = false;
+	ctx->sample_control.primitives_enabled.page_fault = true;
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
+		KUNIT_EXPECT_EQ(test, r->nr_accesses, 0u);
+
+	damon_destroy_ctx(ctx);
+}
+
+/*
+ * Test the hot side of the page-fault signal: a reported region scores hotter
+ * than a region that reported nothing.
+ *
+ * Create a paddr ctx with the page_fault primitive and one target with two
+ * regions.  Report an access on the first region only, over several sampling
+ * ticks.  Each tick credits the reported region and withholds credit from the
+ * other one, so the access rate of the first grows while the second stays at
+ * zero, and the hot score of the first is higher while the cold score is
+ * reversed.
+ */
+static void damon_test_pagefault_hot_promote(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *hot, *cold;
+	struct damos scheme = {
+		.quota = { .weight_nr_accesses = 100, .weight_age = 0 },
+	};
+	struct damon_access_report rep = {
+		.paddr     = 0x15000,
+		.probe_idx = 0,
+		.size      = PAGE_SIZE,
+	};
+	int i;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+	ctx->sample_control.primitives_enabled.page_table = false;
+	ctx->sample_control.primitives_enabled.page_fault = true;
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc failed");
+	}
+	t->pid = NULL;	/* paddr target: no pid */
+	damon_test_set_paddr_ctx(ctx);
+
+	hot = damon_new_region(0x10000, 0x20000);
+	cold = damon_new_region(0x20000, 0x30000);
+	if (!hot || !cold) {
+		if (hot)
+			damon_free_region(hot);
+		if (cold)
+			damon_free_region(cold);
+		damon_free_target(t);
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc failed");
+	}
+	damon_add_region(hot, t);
+	damon_add_region(cold, t);
+	damon_add_target(ctx, t);
+
+	/* Both regions start from a zero access rate. */
+	KUNIT_EXPECT_EQ(test, hot->nr_accesses, 0u);
+	KUNIT_EXPECT_EQ(test, cold->nr_accesses, 0u);
+
+	/*
+	 * One sampling tick per iteration: report on the hot region, drain the
+	 * ring, then run the zero-access pass over the regions that reported
+	 * nothing.
+	 */
+	for (i = 0; i < 3; i++) {
+		rep.report_jiffies = jiffies;
+		damon_report_access(&rep);
+		kdamond_check_reported_accesses(ctx);
+		kdamond_apply_zero_access_report(ctx);
+	}
+
+	KUNIT_EXPECT_EQ(test, hot->nr_accesses, 3u);
+	KUNIT_EXPECT_EQ(test, cold->nr_accesses, 0u);
+	KUNIT_EXPECT_GT(test, hot->nr_accesses, cold->nr_accesses);
+	KUNIT_EXPECT_GT(test, damon_hot_score(ctx, hot, &scheme),
+			damon_hot_score(ctx, cold, &scheme));
+	KUNIT_EXPECT_LT(test, damon_cold_score(ctx, hot, &scheme),
+			damon_cold_score(ctx, cold, &scheme));
+
+	damon_destroy_ctx(ctx);
+}
+
+static struct kunit_case damon_drain_test_cases[] = {
+	KUNIT_CASE(damon_test_unified_vaddr_match),
+	KUNIT_CASE(damon_test_unified_vaddr_tgid_mismatch),
+	KUNIT_CASE(damon_test_unified_paddr_no_regression),
+	KUNIT_CASE(damon_test_ring0_pagefault_credit),
+	KUNIT_CASE(damon_test_ring0_pagefault_cold_demote),
+	KUNIT_CASE(damon_test_ring1_perf_credit),
+	KUNIT_CASE(damon_test_ring_partition),
+	KUNIT_CASE(damon_test_perf_per_ctx_isolation),
+	KUNIT_CASE(damon_test_pf_ring_owner_ebusy),
+	KUNIT_CASE(damon_test_report_return_value),
+	KUNIT_CASE(damon_test_report_drain_restores_capacity),
+	KUNIT_CASE(damon_test_pf_and_probe_one_ctx),
+	KUNIT_CASE(damon_test_report_addr_space_keyed),
+	KUNIT_CASE(damon_test_pagefault_hot_promote),
+	{}
+};
+
+static struct kunit_suite damon_drain_test_suite = {
+	.name = "damon_drain",
+	.test_cases = damon_drain_test_cases,
+};
+kunit_test_suite(damon_drain_test_suite);
+
+#endif /* _DAMON_DRAIN_KUNIT_H */
+
+#endif	/* CONFIG_DAMON_KUNIT_TEST */
diff --git a/mm/damon/tests/perf-kunit.h b/mm/damon/tests/perf-kunit.h
new file mode 100644
index 0000000000000..08e8b911f4d94
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
+ * it is refused instead of dereferenced, which is what an overflow arriving
+ * after its context's ring was freed looks like.
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
+kunit_test_suite(damon_perf_test_suite);
+
+#endif /* _DAMON_PERF_KUNIT_H */
+
+#endif	/* CONFIG_DAMON_KUNIT_TEST */
-- 
2.43.0


