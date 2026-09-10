Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61F2C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD616B009B; Thu, 10 Sep 2026 13:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794CB6B009D; Thu, 10 Sep 2026 13:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635466B009E; Thu, 10 Sep 2026 13:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 303956B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA6931605C4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:42 +0000 (UTC)
X-FDA: 85198507044.26.B97D4B1
Received: from mail-yx2-f11.google.com (mail-yx2-f11.google.com [74.125.224.139])
	by imf09.hostedemail.com (Postfix) with ESMTP id BDC1F140002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YKoibNpT;
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.139 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33JbaTzVaS9WwHfpEPKLTYlvXLw2aDfEmaGs4zEFu2Y=;
	b=8RXt7z/cVz7GHnPZld1ckZW08XzuJlaLAflpv22eyT8uEufu63dYPM0DDVU68GoFZ6rsYl
	Mg4IJh4bM4aCIQyVa/8yVT0ce1jIShCgrUjXXYawat3zQoNY5aZ+A1tT7R3amuGDBnBwBB
	l9hEv6Keydsr57e9Whc0j7J0VJBeMLo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060600;
	b=SdNCuYdawCG3xkKRJpf80NnlClDF8GeDX0BzLTczJVzt0etFfCaE+QYGPiKRVbWD6nPNLv
	PHsPWloK11tEKc1K0vrTbVfxmpBR4qopFmEmQ3l2tr0/aD7oQ/DdzhJ2LhoWycqAX31dYw
	+NaLsL7FeDl7MnKEvlmPoxSpQxUbyOQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YKoibNpT;
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.139 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f11.google.com with SMTP id 956f58d0204a3-66c70f7a790so2343462d50.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060600; x=1789665400; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=33JbaTzVaS9WwHfpEPKLTYlvXLw2aDfEmaGs4zEFu2Y=;
        b=YKoibNpTrhr081RZp36T9EQEoUhUHgUkpeHfW3nX1eepz6QEVU6qopJkqhMhImpvQ5
         HlPumVoAe2/xtS/QtmM3c+z1+kdoAixNEi7ivDgrVxnztz7/oJ4ucCdKrhf0XP/xzcJw
         vx73Mhay5MLDbqDL/Ca9915mEzF6/MKTJ5IBwyg4wKpugzQpv9Q71F0uNX8SY4ZvM2ru
         WFY9yTLHwBLH8MSvy4R5f+wCeTRcJ50EdBFET0qMExTu56lkLOzqg/BKf3NBQTKOmMhf
         FtF1dCdgv4s0wisYY+Vq1rl8KJ10QrG7RWrV8fc2tMvHj3k8orwxITzrOMM50qZarJQU
         l08g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060600; x=1789665400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=33JbaTzVaS9WwHfpEPKLTYlvXLw2aDfEmaGs4zEFu2Y=;
        b=ibXMiKzxchOyIVHJx8tsV30hoLupzJkdoa7HlwK2B2qiVHpBVKkncECxtWw417snDi
         e8/jQYWlGbYEy1jyjAkegOwiBYx0kvxi3lF8izZsghQR2pZe51RNz/qUfWmLQAb2oglh
         CGG1u98rY4kWMeipPhVPDYDpIQOQ7P5Q1rJzA9AAHq0+KY72Umrdev/5C8S/gcY02Rjf
         z61XwoHezvU+6ExpYj/vjLk0+PfPtVQJ8+6y9li/9rPhPwp3VBaoydHeUb+ZZwOn07Z1
         Z98TStzhpduRma8lGqcP/fAITigVrgY0mPNpIj1K0KqWA8MGXqL+pwnSr9Roahp9tGFs
         2Whw==
X-Forwarded-Encrypted: i=1; AKwUvBzqXu5QZD02bYvGcRIc35diXhptdWkGQPESgaueujkiZnhGcAGyJ1B+pRw4iEatcIvpc7tZ0Gua6A==@kvack.org
X-Gm-Message-State: AFuF++nNZzZodcglPEiNtUQA4qQStB+2aylZRWnoL6i/jaZfpwm93yHy
	grglXXJL/sTzCe3FIg5gwdwP1nVHBLSL3oTF+QEa6qm8fNBB/rPx9M8=
X-Gm-Gg: AYBFou0UBZEKEh6vL9znIkyuuoKDUcJTqUg7veCI/Yr1UVSfHNAL8L0yJ4gfKM5agCV
	ULKKyb/VCoDUA8w9OrBSNNeToRiPgQdxF4X/bZOY8GvIcoyfa05Ieke/ZQzzdz96Dgj0nh1T4e8
	DpMoUcId2MZciYtGkph1eZadwgO3dJixV+NnmPUFw0Ozt9549wl2ZmSSlTHzFENWdMl2KKW7LcC
	7rQB2WPw23bkVkfb30ozJm7vB1/fN7eMp9ca99OqJomp0oNdzDkwsg0C2hOOl7e+gb//kHy48TO
	K/1+VF8/9B3CMJrzdi/49M0f0hQfMTHIujOo1NNcVrOBo+tAET20v9C5oFiwNYXN4NVWnzfulNU
	1BnmTwFmpcp1oTXYroMpLf/xB5rvMbGruI0k9lx1KZDYcAAplXSCbV/Cav+ovZXms9Dn2dHDYEK
	rCOYk37oR8EWDYdNr6md+q8T6gZRPyrOHCvpqBHOdT86ivYv3pcTZOOAMYdQ27RvqKUqnRMlx8E
	GQaj1Xsq/QRvMTPUvugT8bJstOerYO5FM6nfa64fmN6oZ4W9A==
X-Received: by 2002:a05:690c:6e87:b0:873:5ddf:d870 with SMTP id 00721157ae682-884b423a43fmr1497757b3.59.1789060599401;
        Thu, 10 Sep 2026 10:16:39 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-88487ea38e1sm2327237b3.30.2026.09.10.10.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:38 -0700 (PDT)
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
Subject: [RFC PATCH v2 6/9] mm/damon: add perf-event overflow handler feeding the report ring
Date: Thu, 10 Sep 2026 10:16:20 -0700
Message-ID: <20260910171623.6638-7-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bdqsnjyw4mff698c7bmcrcmtp9n8diyb
X-Rspamd-Queue-Id: BDC1F140002
X-HE-Tag: 1789060600-668814
X-HE-Meta: U2FsdGVkX19km9rdezh0KqXrwkZ2XJcE+kST13S7Z9zUqI7TbvjKTdcnrF1/gFH4UZo3G5QAUrJa7SVlKnVcogn00R6/X4YNWhdbk68bvGXv5CZGbOvM8i/y246uyb/tCR01XRaUZiX7WIpFvFvBs7s9SUEi77dxke9TKuWJkbAt8A+xR1WToIPM8LzHlAfDDfZEkk5V/6KUeZmXn4zLFhqpTQAOW1Oj3e6FCU0Pij5mmrjYkfp4ePHhFcALQO6uYODU3d7QOioxAzWJwFQ+lLjDn7UhlQWPVqiJPq1AILx0mBd9/Rp+tqIgmizkW+GouiJkpAWk5cU8dYY+rTaUhYCyolPFXbLpYwThLALE7mUix+hfqKQWiV6m9n97QU84lUAh2y+ihlz8XsDuss1w40InTGW36Ji7qOyWYy2OMTXmKbbEOV93sH5BqyZG7fweioOTr3gIno7XGZn8QVjElANzjPhMkCfkEPoCFjV47N9zlmiO46yYL/crNj7TT/Yk4ffNTQa+xcMcE5jSdruWRPp4OoIlipXc+t3vn+FeXVi/Km5lk/hf8F6mw6oKlNMy9Ym8V6/uPbjNkuiT/gAd3JY3EBuTqQ6VMeCO1R0oOzIbjPKyZ9yHHr0IqTULgkibwNnXbUELUOdeTJ/brAfX2VFQc7L+Bbqxw8zdytiPVGfkGPkKXsBBtxyGLnxWgucOEs8XnVOStVrz3fmFZ+EBBjjzcPzbccU2K98c4MKLdyPLDOaFyif38+Ts09JBvKJ/jFpGc2ELMMXhsITsmm1Y4FlnUTypHyRFtqGy97xQ0f/DJox2N4gSgCaxF9E6sXY+nUVcp2DYyBKE9t0SjCfx/h/SMKLj4zcMflvYvcF/01vi/v2vxYTYda7OgY30k5mWJRQn6eJ2nn1eaG/fLU//hu2EkP/ajCbbuu614yPZDCV8ig2FR9V95medeJa+tyXljjk1fe7esuRwFb8ugPt
 QoBWYWS3
 gpwqFxkUvIekq/XgzFgFu0u0VZfMwJ4xUdHlYk5AL1mbEQ4pJ9cSR92G5vny1GVqMoaNu1dzmexEuTJaZJk29bJucQwI7jwx+ApOwMZwNnOXlxFUtUnhjHoSTREZrRCZoXT6a5bB8VZoO7o9ICe0wMQjcDAUgcFgEtnlU6og1w9tYriW+Quk3CVJY83gZGCoT+K6vMNNnaHAWsSBUznFYrFOVlbTjmp0o/l+IK259x7A3uYcXlBLuT3ZhLXw+A9fHv3/V+oMLRjNUU91W0rVNQPbmc6F7nnSjWS4BipiqYB96cc1d2NxdMeXxzGhw4YlCpS7E7giOwgwOvPQt3XYLb0pnL3yEMLGtX9sU76WHe/Tqs2Qjsd7UOfoSIN1NAdoXsdhwnYYfXjCU/DMx3PQfBcmUzl7ODTmY76u9ZnZnJPDx+s3fCbXJguCtrVUe+8AYdL1mi/yAFj0kgwKr3XGic5aSvTq3s9RBCxUImlWOKDDMvYTP/rZmZrzNP6sPbwKo6Y2K0ufngu+lQ447LllSvY2ifA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mm/damon/perf_source.c, an ops-agnostic perf-event source that turns
PMU overflow samples into DAMON access reports.  The overflow handler runs
in NMI context and reports through damon_report_access(), so it works with
either paddr or vaddr ops.

The handler sets whichever address fields the PMU provides: paddr when
PERF_SAMPLE_PHYS_ADDR is set, vaddr when PERF_SAMPLE_ADDR is set, plus the
CPU it runs on.  The unified drain matches on whichever is present.  It
reports both the thread id and the thread group id, because a VA-only PMU
samples whichever thread of a process happened to access memory while the
drain matches a target created for that process.

Per-CPU perf events are armed and released through cpuhp callbacks, so a
CPU coming online while a probe is armed gets a counter and a CPU going
offline releases its own.

damon_perf_probe_alloc() allocates a perf-event-backed damon_probe with
event_driven set, so its hits are credited through the report-ring drain
rather than the apply_probes vtable; callers set the perf attributes after
allocation.  Both ops sets honour that flag in their probe vtables: an
event-driven probe has no software prep action, and is skipped in the
apply_probes loop, so the drain is the only thing that credits its
probe_hits[].

damon_perf_probe_setup() computes probe_idx by walking ctx->probes,
assigning 1-based indices because 0 is the zero-init sentinel
DAMON_PROBE_IDX_NONE, and the overflow handler warns once if it sees 0.

A refcounted per-PMU owner tracks which context owns each PMU type: a
second context claiming the same type gets -EBUSY, and ownership is
released when the last probe for that type is torn down.  Module exit
refuses to unload while any owner remains.

Co-developed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/Kconfig       |  18 ++
 mm/damon/Makefile      |   1 +
 mm/damon/paddr.c       |  19 +-
 mm/damon/perf_source.c | 402 +++++++++++++++++++++++++++++++++++++++++
 mm/damon/perf_source.h |  26 +++
 mm/damon/vaddr.c       |  18 +-
 6 files changed, 482 insertions(+), 2 deletions(-)
 create mode 100644 mm/damon/perf_source.c
 create mode 100644 mm/damon/perf_source.h

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index c7b6f3125e79e..4a4f4381dc3b7 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -64,6 +64,24 @@ config DAMON_PADDR
 	  This builds the default data access monitoring operations for DAMON
 	  that works for the physical address space.
 
+config DAMON_PERF_SOURCE
+	bool "perf-event source for DAMON probes"
+	depends on DAMON && PERF_EVENTS
+	help
+	  Provides a PMU-agnostic perf-event overflow handler that feeds
+	  physical-address access reports into DAMON via damon_report_access().
+	  Required for DAMON probe-weighted tiering with any address-sampling PMU.
+
+	  The overflow handler is NMI-safe: it writes to a per-CPU SPSC
+	  ring rather than taking any lock. The PMU is selected at probe
+	  creation time via perf_event_attr (e.g. AMD IBS Op, Intel PEBS).
+
+	  A given PMU type may be driven by at most one DAMON context at a
+	  time (hardware constraint); damon_perf_probe_setup() returns -EBUSY
+	  if another context already owns that PMU type.  Distinct contexts may
+	  each drive different PMUs concurrently, each draining its own
+	  per-context report ring.
+
 config DAMON_VADDR_KUNIT_TEST
 	bool "Test for DAMON operations" if !KUNIT_ALL_TESTS
 	depends on DAMON_VADDR && KUNIT=y
diff --git a/mm/damon/Makefile b/mm/damon/Makefile
index 22494754f41e8..1abf6f2a5133f 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
 obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
 obj-$(CONFIG_DAMON_ACMA)	+= modules-common.o acma.o
+obj-$(CONFIG_DAMON_PERF_SOURCE)	+= perf_source.o
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5fcef3005c536..c6ac44561ee46 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -179,6 +179,16 @@ static void damon_pa_prep_probes_region(struct damon_region *r,
 {
 	struct damon_prep *p;
 
+	/*
+	 * Event-driven probes have no software prep action: their hits arrive
+	 * asynchronously through the per-CPU report rings and are applied by
+	 * the kdamond ring drain, so skip the software prep path here.
+	 * Reaching this for an event-driven probe is normal (prep runs for
+	 * every probe); it is silently skipped, not a warning.
+	 */
+	if (probe->event_driven)
+		return;
+
 	damon_for_each_prep(p, probe) {
 		switch (p->action) {
 		case DAMON_PREP_SET_PGIDLE:
@@ -268,7 +278,14 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(folio, p))
+				/*
+				 * Event-driven probes skip this software apply
+				 * path; their hits are counted asynchronously by
+				 * the kdamond ring drain.  Only sampling-based
+				 * probes credit probe_hits[] here.
+				 */
+				if (!p->event_driven &&
+				    damon_pa_filter_pass(folio, p))
 					r->probe_hits[i]++;
 				i++;
 			}
diff --git a/mm/damon/perf_source.c b/mm/damon/perf_source.c
new file mode 100644
index 0000000000000..1102426152eca
--- /dev/null
+++ b/mm/damon/perf_source.c
@@ -0,0 +1,402 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON perf-event source
+ *
+ * Provides a PMU-agnostic NMI-safe overflow handler that feeds
+ * physical-address access reports into DAMON via damon_report_access().
+ * The PMU is selected at probe creation time via perf_event_attr.
+ */
+
+#include <linux/cpuhotplug.h>
+#include <linux/damon.h>
+#include <linux/module.h>
+#include <linux/perf_event.h>
+#include <linux/slab.h>
+#include "perf_source.h"
+
+/* PMU event attribute for perf-event probe configuration */
+struct damon_perf_event_attr {
+	u32 type;
+	u64 config;
+	u64 config1;
+	u64 config2;
+	bool sample_phys_addr;
+	bool sample_weight_struct;
+	bool exclude_kernel;
+	bool exclude_hv;
+	bool freq;
+	u64 sample_freq;
+	u64 sample_period;
+	u32 wakeup_events;
+	u32 precise_ip;
+};
+
+struct damon_perf_probe_event {
+	struct damon_perf_event_attr attr;
+	void *priv;		/* struct damon_perf_probe_state * */
+	struct hlist_node hlist_node;
+	int probe_idx;		/* index into probe_hits[]; set at registration */
+};
+
+struct damon_perf_probe_state {
+	struct perf_event * __percpu *event;
+};
+
+static DEFINE_PER_CPU(unsigned long, damon_perf_samples_total);
+static DEFINE_PER_CPU(unsigned long, damon_perf_samples_filtered);
+static DEFINE_PER_CPU(unsigned long, damon_perf_samples_no_addr);
+
+static void damon_perf_overflow(struct perf_event *perf_event,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	int probe_idx = (int)(unsigned long)perf_event->overflow_handler_context;
+	struct damon_access_report report = {
+		.probe_idx = probe_idx,
+		.size = PAGE_SIZE,
+		.cpu = smp_processor_id(),
+	};
+
+	/* probe_idx 0 is the zero-init sentinel; a valid index must be >= 1 */
+	if (WARN_ONCE(probe_idx == 0,
+		      "damon-perf: overflow handler called with probe_idx=0\n"))
+		return;
+
+	if (!data) {
+		this_cpu_inc(damon_perf_samples_no_addr);
+		return;
+	}
+
+	/*
+	 * Populate whichever address fields the PMU provides.
+	 * IBS provides PA (and optionally VA); PEBS provides VA only.
+	 * Gate on sample_flags rather than testing for zero: the flag is
+	 * the authoritative indicator of field validity.
+	 */
+	if (data->sample_flags & PERF_SAMPLE_PHYS_ADDR)
+		report.paddr = data->phys_addr & PAGE_MASK;
+	if (data->sample_flags & PERF_SAMPLE_ADDR)
+		report.vaddr = data->addr;
+
+	if (!report.paddr && !report.vaddr) {
+		this_cpu_inc(damon_perf_samples_filtered);
+		return;
+	}
+
+	report.is_write = !!(data->data_src.mem_op & PERF_MEM_OP_STORE);
+	report.tid = task_pid_vnr(current);
+	report.tgid = task_tgid_vnr(current);
+	damon_report_access(&report);
+	this_cpu_inc(damon_perf_samples_total);
+}
+
+static enum cpuhp_state damon_perf_cpuhp_state;
+
+/*
+ * Per-PMU exclusivity: each PMU type may be owned by at most one damon_ctx.
+ * Multiple probes from the same ctx sharing a PMU type are allowed; a second
+ * ctx attempting to grab a PMU type already owned returns -EBUSY.
+ */
+struct damon_pmu_owner {
+	struct list_head node;
+	u32 pmu_type;
+	atomic_long_t owner_ctx;
+	atomic_t refcount;
+};
+
+static LIST_HEAD(damon_pmu_owner_list);
+static DEFINE_SPINLOCK(damon_pmu_owner_lock);
+
+static void damon_perf_event_init_attr(struct damon_perf_probe_event *event,
+				       struct perf_event_attr *attr)
+{
+	u64 stype = PERF_SAMPLE_TIME | PERF_SAMPLE_PERIOD | PERF_SAMPLE_ADDR;
+
+	/*
+	 * Gate PERF_SAMPLE_PHYS_ADDR on the probe attribute: Intel PEBS
+	 * has sample_phys_addr=0 by default; forcing it triggers an
+	 * NMI-context pagetable walk per sample and sets entry->paddr
+	 * unconditionally, which prevents the vaddr drain branch from
+	 * ever being exercised.
+	 */
+	if (event->attr.sample_phys_addr)
+		stype |= PERF_SAMPLE_PHYS_ADDR;
+	if (event->attr.sample_weight_struct)
+		stype |= PERF_SAMPLE_WEIGHT_STRUCT;
+	stype |= PERF_SAMPLE_DATA_SRC;
+
+	*attr = (struct perf_event_attr) {
+		.size = sizeof(*attr),
+		.type = event->attr.type,
+		.config = event->attr.config,
+		.config1 = event->attr.config1,
+		.config2 = event->attr.config2,
+		.freq = event->attr.freq,
+		.sample_type = stype,
+		.precise_ip = event->attr.precise_ip,
+		.pinned = 1,
+		/*
+		 * Created disabled, and enabled by the caller once the counter
+		 * is fully set up.
+		 */
+		.disabled = 1,
+		.wakeup_events = event->attr.wakeup_events,
+		.exclude_kernel = event->attr.exclude_kernel,
+		.exclude_hv = event->attr.exclude_hv,
+	};
+	if (event->attr.freq)
+		attr->sample_freq = event->attr.sample_freq;
+	else
+		attr->sample_period = event->attr.sample_period;
+}
+
+static int damon_perf_cpu_online(unsigned int cpu, struct hlist_node *node)
+{
+	struct damon_perf_probe_event *event = hlist_entry(node,
+			struct damon_perf_probe_event, hlist_node);
+	struct damon_perf_probe_state *perf = event->priv;
+	struct perf_event_attr attr;
+	struct perf_event *perf_event;
+
+	if (!perf)
+		return 0;
+
+	damon_perf_event_init_attr(event, &attr);
+
+	perf_event = perf_event_create_kernel_counter(&attr, cpu, NULL,
+						      damon_perf_overflow,
+						      (void *)(unsigned long)event->probe_idx);
+	if (IS_ERR(perf_event)) {
+		pr_warn_ratelimited("damon-perf: cpu %u event create failed: %ld\n",
+				    cpu, PTR_ERR(perf_event));
+		return 0;
+	}
+	per_cpu(*perf->event, cpu) = perf_event;
+
+	perf_event_enable(perf_event);
+	return 0;
+}
+
+static int damon_perf_cpu_offline(unsigned int cpu, struct hlist_node *node)
+{
+	struct damon_perf_probe_event *event = hlist_entry(node,
+			struct damon_perf_probe_event, hlist_node);
+	struct damon_perf_probe_state *perf = event->priv;
+	struct perf_event *perf_event;
+
+	if (!perf)
+		return 0;
+
+	perf_event = per_cpu(*perf->event, cpu);
+	if (perf_event) {
+		perf_event_disable(perf_event);
+		perf_event_release_kernel(perf_event);
+		per_cpu(*perf->event, cpu) = NULL;
+	}
+	return 0;
+}
+
+/**
+ * damon_perf_probe_setup - arm perf_events for a DAMON probe.
+ * @ctx:   DAMON context that owns the probe.
+ * @probe: the damon_probe being armed; its list position in ctx->probes
+ *         determines the probe_idx stored in ring entries.
+ * @event: perf event descriptor (caller fills .attr fields)
+ *
+ * Computes probe_idx by walking ctx->probes so the caller does not need
+ * to track it externally.  Returns 0 on success, negative errno on failure.
+ */
+int damon_perf_probe_setup(struct damon_ctx *ctx,
+			   struct damon_probe *probe,
+			   struct damon_perf_probe_event *event)
+{
+	struct damon_perf_probe_state *perf;
+	struct damon_pmu_owner *owner, *found = NULL;
+	struct damon_probe *p;
+	int idx = 0;
+	int err = -ENOMEM;
+
+	/*
+	 * Per-PMU exclusivity: find or create an owner slot for this PMU type.
+	 * Multiple probes from the same ctx sharing a PMU type are allowed;
+	 * a second ctx attempting the same PMU type returns -EBUSY.
+	 */
+	spin_lock(&damon_pmu_owner_lock);
+	list_for_each_entry(owner, &damon_pmu_owner_list, node) {
+		if (owner->pmu_type == event->attr.type) {
+			long cur = atomic_long_read(&owner->owner_ctx);
+
+			if (cur != 0L && cur != (long)ctx) {
+				spin_unlock(&damon_pmu_owner_lock);
+				return -EBUSY;
+			}
+			atomic_long_set(&owner->owner_ctx, (long)ctx);
+			atomic_inc(&owner->refcount);
+			found = owner;
+			break;
+		}
+	}
+	if (!found) {
+		/*
+		 * GFP_ATOMIC: this allocation runs while holding
+		 * damon_pmu_owner_lock (a spinlock), so it must not sleep.
+		 */
+		owner = kzalloc_obj(*owner, GFP_ATOMIC);
+		if (!owner) {
+			spin_unlock(&damon_pmu_owner_lock);
+			return -ENOMEM;
+		}
+		owner->pmu_type = event->attr.type;
+		atomic_long_set(&owner->owner_ctx, (long)ctx);
+		atomic_set(&owner->refcount, 1);
+		list_add(&owner->node, &damon_pmu_owner_list);
+		found = owner;
+	}
+	spin_unlock(&damon_pmu_owner_lock);
+
+	/* Compute probe_idx by walking ctx->probes list */
+	damon_for_each_probe(p, ctx) {
+		if (p == probe)
+			break;
+		idx++;
+	}
+	/*
+	 * Probe indices are 1-based (0 is the zero-init sentinel).
+	 * With DAMON_MAX_PROBES slots (0..DAMON_MAX_PROBES-1), valid probe
+	 * indices are 1..DAMON_MAX_PROBES-1, so the 0-based list position
+	 * must be < DAMON_MAX_PROBES-1.
+	 */
+	if (idx >= DAMON_MAX_PROBES - 1) {
+		err = -ENOSPC;
+		goto release_owner;
+	}
+	event->probe_idx = idx + 1;	/* 1-based; 0 is reserved sentinel */
+
+	perf = kzalloc_obj(*perf, GFP_KERNEL);
+	if (!perf)
+		goto release_owner;
+
+	perf->event = alloc_percpu(typeof(*perf->event));
+	if (!perf->event)
+		goto free_perf;
+
+	event->priv = perf;
+	INIT_HLIST_NODE(&event->hlist_node);
+
+	err = cpuhp_state_add_instance(damon_perf_cpuhp_state,
+				       &event->hlist_node);
+	if (err)
+		goto free_event;
+
+	return 0;
+
+free_event:
+	free_percpu(perf->event);
+free_perf:
+	kfree(perf);
+	event->priv = NULL;
+release_owner:
+	spin_lock(&damon_pmu_owner_lock);
+	if (atomic_dec_and_test(&found->refcount)) {
+		list_del(&found->node);
+		spin_unlock(&damon_pmu_owner_lock);
+		kfree(found);
+	} else {
+		spin_unlock(&damon_pmu_owner_lock);
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(damon_perf_probe_setup);
+
+/**
+ * damon_perf_probe_teardown - disarm perf_events.
+ * @event: perf event descriptor previously passed to damon_perf_probe_setup()
+ */
+void damon_perf_probe_teardown(struct damon_ctx *ctx,
+			       struct damon_perf_probe_event *event)
+{
+	struct damon_perf_probe_state *perf = event->priv;
+	struct damon_pmu_owner *owner, *tmp;
+
+	if (!perf)
+		return;
+
+	cpuhp_state_remove_instance(damon_perf_cpuhp_state,
+				    &event->hlist_node);
+	free_percpu(perf->event);
+	kfree(perf);
+	event->priv = NULL;
+
+	/*
+	 * Release per-PMU ownership when the last probe for this
+	 * ctx/PMU-type pair is torn down.
+	 */
+	spin_lock(&damon_pmu_owner_lock);
+	list_for_each_entry_safe(owner, tmp, &damon_pmu_owner_list, node) {
+		if (owner->pmu_type == event->attr.type &&
+		    atomic_long_read(&owner->owner_ctx) == (long)ctx) {
+			/*
+			 * Free under the lock so a concurrent same-PMU teardown
+			 * cannot observe and free the same owner. kfree() under
+			 * a non-irq spinlock in process context is safe.
+			 */
+			if (atomic_dec_and_test(&owner->refcount)) {
+				list_del(&owner->node);
+				kfree(owner);
+			}
+			break;
+		}
+	}
+	spin_unlock(&damon_pmu_owner_lock);
+}
+EXPORT_SYMBOL_GPL(damon_perf_probe_teardown);
+
+/**
+ * damon_perf_probe_alloc - allocate and initialise a perf-event-backed damon_probe.
+ * @weight: probe weight for probe-weighted tiering scoring.
+ *
+ * The caller sets perf->attr directly after allocation to select the PMU
+ * and sampling parameters (e.g. AMD IBS Op, Intel PEBS).
+ *
+ * Returns a new probe on success, NULL on allocation failure.
+ */
+struct damon_probe *damon_perf_probe_alloc(unsigned int weight)
+{
+	struct damon_probe *probe = damon_new_probe();
+
+	if (!probe)
+		return NULL;
+	probe->weight = weight;
+	probe->event_driven = true;
+	return probe;
+}
+EXPORT_SYMBOL_GPL(damon_perf_probe_alloc);
+
+static int __init damon_perf_source_init(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
+				      "mm/damon/perf_source:online",
+				      damon_perf_cpu_online,
+				      damon_perf_cpu_offline);
+	if (ret < 0)
+		return ret;
+	damon_perf_cpuhp_state = ret;
+	return 0;
+}
+
+static void __exit damon_perf_source_exit(void)
+{
+	spin_lock(&damon_pmu_owner_lock);
+	if (!list_empty(&damon_pmu_owner_list)) {
+		spin_unlock(&damon_pmu_owner_lock);
+		WARN(1, "damon_perf_source: unloading with active probes\n");
+		return;
+	}
+	spin_unlock(&damon_pmu_owner_lock);
+	cpuhp_remove_multi_state(damon_perf_cpuhp_state);
+}
+
+module_init(damon_perf_source_init);
+module_exit(damon_perf_source_exit);
diff --git a/mm/damon/perf_source.h b/mm/damon/perf_source.h
new file mode 100644
index 0000000000000..5de55a29785f4
--- /dev/null
+++ b/mm/damon/perf_source.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * DAMON perf-event source - public interface
+ *
+ * Callers that register perf-event probes include this header.
+ */
+
+#ifndef _DAMON_PERF_SOURCE_H
+#define _DAMON_PERF_SOURCE_H
+
+#ifdef CONFIG_DAMON_PERF_SOURCE
+
+#include <linux/damon.h>
+#include <linux/perf_event.h>
+
+struct damon_perf_probe_event;
+
+int damon_perf_probe_setup(struct damon_ctx *ctx,
+			   struct damon_probe *probe,
+			   struct damon_perf_probe_event *event);
+void damon_perf_probe_teardown(struct damon_ctx *ctx,
+			       struct damon_perf_probe_event *event);
+struct damon_probe *damon_perf_probe_alloc(unsigned int weight);
+
+#endif /* CONFIG_DAMON_PERF_SOURCE */
+#endif /* _DAMON_PERF_SOURCE_H */
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 1f2d923e569d6..3d6387d4ef7bb 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -552,6 +552,16 @@ static void damon_va_prep_probe_region(struct damon_ctx *ctx,
 {
 	struct damon_prep *p;
 
+	/*
+	 * Event-driven probes have no software prep action: their hits arrive
+	 * asynchronously through the per-CPU report rings and are applied by
+	 * the kdamond ring drain, so skip the software prep path here.
+	 * Reaching this for an event-driven probe is normal (prep runs for
+	 * every probe); it is silently skipped, not a warning.
+	 */
+	if (probe->event_driven)
+		return;
+
 	damon_for_each_prep(p, probe) {
 		switch (p->action) {
 		case DAMON_PREP_SET_PGIDLE:
@@ -656,7 +666,13 @@ static void damon_va_probe_folio(struct damon_ctx *ctx,
 	int i = 0;
 
 	damon_for_each_probe(probe, ctx) {
-		if (damon_va_filter_pass(folio, probe, pte, pmd, mm,
+		/*
+		 * Event-driven probes skip this software apply path; their hits
+		 * are counted asynchronously by the kdamond ring drain.  Only
+		 * sampling-based probes credit probe_hits[] here.
+		 */
+		if (!probe->event_driven &&
+		    damon_va_filter_pass(folio, probe, pte, pmd, mm,
 					r->sampling_addr))
 			r->probe_hits[i]++;
 		i++;
-- 
2.43.0


