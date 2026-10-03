Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAFA0CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBA66B0096; Sat,  3 Oct 2026 17:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D37C6B0098; Sat,  3 Oct 2026 17:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90116B0099; Sat,  3 Oct 2026 17:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8DB86B0096
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:08:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABDB41C381B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:31 +0000 (UTC)
X-FDA: 85282553622.06.7F27F27
Received: from mail-yx2-f9.google.com (mail-yx2-f9.google.com [74.125.224.137])
	by imf24.hostedemail.com (Postfix) with ESMTP id C403A18000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SzG7On7/";
	spf=pass (imf24.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791061709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihH5QoOWQsyO/U84LYAf5Q31ga4ia8Sph2YHBUkvsV0=;
	b=lz2LVVMn4CD7uBsrMaC278Pc8DI4F5mL1Gn7NhQGIbm6BfYWim7ME0mrjh3Ur0W6gxt3Jw
	L7UBwn9l52jkPwlL4NP9A+g2oZL2LXnm/CihewWOjiRqYps+dGHCg6bfHoSwgnpTuPcX9V
	X09G/4MiS3QzZeqP00osyUaHmFBgyME=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SzG7On7/";
	spf=pass (imf24.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791061709;
	b=4XWdv0yg/zj284xtPStt1eqVyt3h/dMO6ostP+PGKsoM+FEZ5RbgjJG+oPpjUS/ul7/JAJ
	o0urDVqfEWj9Yr/M+5qWj5UjCW+oTwUOMeh4ssdWewXLMKxvPFwMTh4mIt9JkUvwobXx6I
	xAJPnUFVblW4H5M2J3hcfgU1jAdUYGQ=
Received: by mail-yx2-f9.google.com with SMTP id 00721157ae682-8abae0db83bso328177b3.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791061709; x=1791666509; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ihH5QoOWQsyO/U84LYAf5Q31ga4ia8Sph2YHBUkvsV0=;
        b=SzG7On7/ziS8usCMmnWzXneYTc8Ls0N5IV8QKzk/S9GUpZ47VqmNNDWjsNaxjKhi74
         6zcRAOhldHdhjW+TrPPmzfgHAhwg6xOs2t2z6qrExD3yxS+hrEexiC55fZI7vUUgf4MR
         G50r9sFbzIYfDk74Dg9kkPL2V8ICOI6ZhsYdmpExFmY3T+PaXqQUHXcHH4OutswkVmZE
         OfsAJORcP4U4zllPyi7RWr0qJqbOGDwm9iASQdwofZYPZFn3THNDCSu2ZevLXRM+qAku
         ouUIAw9a/DwuCJfG29jp/zK9RhO5l3DYB2bvDxTksY0jLzPrtlt0GyYt0ZsHgfv/WPR/
         /rIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791061709; x=1791666509;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ihH5QoOWQsyO/U84LYAf5Q31ga4ia8Sph2YHBUkvsV0=;
        b=B8dB/nbEiWA72nbRy3pJnC4XGQnEmMQXfwd7K0mm2BL3yG/3gEhFGKb/4t5z811wOj
         FEUKvLUB+fw9C/UK7PHXOVm/It+oGf4w3gZoWMYvoHYrzz+dPOk61jwOzMSSeQjZcJcM
         MviW9X2j2bcbx/WpvZMLMVQ2OHy5rHa1rce20rNqBLtr7jpICSpAEesaeUqVXyWobPTf
         sPOptiTx5MdLlGss3e/5XxCtniUDPCu2qmbTcq6cH5XX7+fHaEItOu67xhTehkfBYlBm
         wMiclIZNZ1zlhAU7fNwxmPCK4EgQOPELRbLmyahfjeQjupCaIq+cX/7UZsya5B8x/Or1
         XkdA==
X-Forwarded-Encrypted: i=1; AKwUvBzX1kW2MpOP6fyRfRdskWgY4a8cbIMjMpg7XsEyMCVUUiFvXhJWdjQ09L+cdRZxHXVCIkJgBBsVhg==@kvack.org
X-Gm-Message-State: AFq9FYLCtMKA4bigQidbIiK+vy5H82l+knesxYPTviwC2W6USrLOQU08
	y5crdugA/K6F5H9f6elQPuZ5+WG7ui0dvp66jxaCHIfvhS7RTfZr5ijMY9aTSdyIDg==
X-Gm-Gg: AYBFou3X6s7tHA7M6UrEN8WK0xF0NYs/+oISaAkRlMiqLaLl+WXYw9X8cZFhVSDF2/p
	ZOVPCsHjBg8Pn5zqrF8HhixRBiRoJ9XlxxqjYICJYMQV82dCf4Lfw2X0OWNcez/CeN3K4qrCDD4
	R4qkLnrD22LHcLnzVbbuFXfbsn8mrNfpe8H4Y4HnSQCH2I/0GtDExXfgNjiL/6TQ3WowQPsTmT1
	WDC4ErKgnX3r4mONhMg5vn2QhHVL8i6jn1gxO4/ICzvj9FYGPJuXameas53uTgeq3BffJq/gClt
	/m6YQ58vVAR0tKyH62AtQK1yxehWCLPjaRxLnGwsn34mtOowF08pKO5fjidSvVpNW3QUl/yGSOH
	FdrVwkqNmm+ZkZm1dKtPEZWUZQJPkW0yr5LvYowzWmyj5fy7DGdkD6g3jqts84TXkInwvhpEZK+
	O5bTRBhnUDHs8NxV9G7VZt18e9cw+sZMQjyfRWhafbKltUVcEC+etmQ3Cf48OAks/NHXuK3xu2E
	cKgyL8jOnp3Px3O7ci60zpQ+v5fUfZxxgqvU/ljCsmSJtNYVTfOcLJgdYoyEfN4UZaX1rAS3Tb8
	FRU7KqJAvPTDkBptPjf9dND/5m6pRk34xg==
X-Received: by 2002:a05:690c:698a:b0:873:5c6b:a31e with SMTP id 00721157ae682-8ae3acd6cf1mr24556887b3.24.1791061708647;
        Sat, 03 Oct 2026 14:08:28 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af0d179d3bsm743537b3.40.2026.10.03.14.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:08:27 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sat, 03 Oct 2026 14:07:56 -0700
Subject: [RFC PATCH v3 3/9] mm/damon: add perf-event overflow handler
 feeding the report ring
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-3-0f00417b41bc@gmail.com>
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C403A18000A
X-Stat-Signature: ag3uiqro66sq7tnj43ur951abwm5gy4e
X-HE-Tag: 1791061709-357163
X-HE-Meta: U2FsdGVkX18uZuzxICmG2tbNUjcKXEw5DHexolug5bY0PK1vvdq4ao9iyFXaVKy4mRlWRezLdSWG83EX3RSkeGaGmypK82VlOXkE/bJS9x0Pz4QFsM0mEt8RnTcUw7ZPnbf9oYzx3waXB4ecbOejGVWVGAOCOF7W/A1KUFpkBDjafhrm1wjJsh8RG7ITTu7pby1rDNCVIj/a5pjEYArHpV/97JNv98Rurr4TMXw0iM2Ogwe9c99kvnzQEXjNWSqDIWTeNQSyn2h/GHDkarF+s4jFbf0xrXz+Qbr5yUVxKwq9IMXOCM9itcabpwLqkZcXSh8ISSRB09/KP5fs3X/h6sTQYIKZ5G0nkqamV3HfUkPI4BF6nEIrBnvcvkN6CZHxdKEGYJ+E55xWwm7kRj6AL4N1kIS/Uu50fpdkKRIkxh+KpGqw/fu8hjSeRRQHzC04jQILMzSE795NCQnUy+CqidjhhR3xje3z7Y3uxmuQ3AYe7wxJdkkbY+tfbEbNjOhS5zjRWs5LVa7vtF2yQEh9gJ5fp3/vV4ARvXUiOKLdrPsuE8anzqcDQlZ84QtHA7/H/YHHwFAgwZBv+BMMwbEwVVvA0GEV5OPVvRnMI1LC6UV44Ry373JxpEOvs3+Zjof1fcBQNZjAiil3cjG8nZTOhnAI6pMdiHZo6e6bfikCzmsD0RHHSSWg29AIi8LfqooxRKB1Kwsm4XL/xPN5IYwmsxFFzny7f18X0BgwtfyaCE98pbMH11OP3OYNJjQwvcDG2s9VI5a73GZ8f87jdmslUPDiYGXNE3ZhezYtkNc3k97r95m2htf7A2Af0/OaQioBNX72BsQHakm8jUkEIDZYawAcQppgfgrCrW0Po6mrSbevt+qJDdFAAsVVyK4LMU4ME8aNdxkiOTc0NkfoOxeok7ivarjWt4jmhhvFoWKCl0gTbJinO2U7fDf2Xq1BkbK6ZvFS3m5z2jBFu5tN5MR
 r2sW87eF
 /iQXTow8xRap18dCgi1vvw7y4DjOOvjdSSB7kg0Cqx3vmh1RbXxG4mkhTXDlGZ9XqUUxee+bI0lVO0tYZvQnJ1DTfas65JnOKsJ1to1iOgsTBPCAlvsD1BSVDuy8mMXEfW3Y2B9qEc2C7hObVs1DwPTe+M9v9dTXGk8jX1pElM4StsvWDiC0BFmOHC7kt/awHiogJKv9nY3muG2vVsL4i+AQR1lO+qWyV6H5g02m24WZ3j8ncJMQ63L74zLn9X1VhKH1yUGNu14Hi0CyGDyb8ATACpdMaitq6kKWJ6qwaZmuIzL0SxYgWx8REVGOzYr8am1HFp2IxBJpYRwTRv6TrXDI+IeIvR9JHtsaiJZgUBAs6np0AY1ZW97er8Rz0RE8jYl1Q9CVxo5V5/AtjmK2T/iHW5m8+u7kq//+RY/9FfwU6S/yTfFQ9d+2oljJ38aft5geXnzVBSxtU3iQe4kUUvY21Eomi9V1ZE1KcUUBJGRSbcIfnYIGLyR6Skpo+xSBAOCsd
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

Each armed event carries its owning context, set when the probe is set up,
and the handler routes every report to that context's perf ring.  Setup
allocates the ring before arming the first counter, so the handler always
finds one.  Teardown clears the event's context with a release store
before releasing the counters, and the handler reads it with a matching
acquire load, so an overflow racing teardown drops its sample instead of
reporting into a context that is going away.

The handler sets whichever address fields the PMU provides: paddr when
PERF_SAMPLE_PHYS_ADDR is set, vaddr when PERF_SAMPLE_ADDR is set, plus the
CPU it runs on.  Both addresses are page aligned, matching the PAGE_SIZE
report size, so a sample that lands in the last page of a region is not
rejected by the drain as straddling the region end.  The drain matches on
whichever address the context's targets use.  The handler reports both
the thread id and the thread group id, because a VA-only PMU samples
whichever thread of a process happened to access memory while the drain
matches a target created for that process.

Per-CPU perf events are armed and released through cpuhp callbacks, so a
CPU coming online while a probe is armed gets a counter and a CPU going
offline releases its own.

A perf-event-backed damon_probe sets event_driven, so its hits are
credited through the report-ring drain rather than the apply_probes
vtable.  Both ops sets honour that flag in their probe vtables: an
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
 mm/damon/Kconfig       |  19 +++
 mm/damon/Makefile      |   1 +
 mm/damon/paddr.c       |  19 ++-
 mm/damon/perf_source.c | 411 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/damon/perf_source.h |  25 +++
 mm/damon/vaddr.c       |  18 ++-
 6 files changed, 491 insertions(+), 2 deletions(-)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index c7b6f3125e79..fd3a29f6c161 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -64,6 +64,25 @@ config DAMON_PADDR
 	  This builds the default data access monitoring operations for DAMON
 	  that works for the physical address space.
 
+config DAMON_PERF_SOURCE
+	bool "perf-event source for DAMON probes"
+	depends on DAMON && PERF_EVENTS
+	help
+	  Provides a PMU-agnostic perf-event overflow handler that feeds
+	  physical-address and virtual-address access reports into DAMON via
+	  damon_report_access().  Required for DAMON probe-weighted tiering
+	  with any address-sampling PMU.
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
index 22494754f41e..1abf6f2a5133 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
 obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
 obj-$(CONFIG_DAMON_ACMA)	+= modules-common.o acma.o
+obj-$(CONFIG_DAMON_PERF_SOURCE)	+= perf_source.o
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 65a5b3269d1d..80da41d20195 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -118,6 +118,16 @@ static void damon_pa_prep_probes_region(struct damon_region *r,
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
@@ -207,7 +217,14 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
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
index 000000000000..51e8957aed8c
--- /dev/null
+++ b/mm/damon/perf_source.c
@@ -0,0 +1,411 @@
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
+	struct damon_ctx *ctx;	/* owning ctx; NULLed at teardown */
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
+	struct damon_perf_probe_event *event =
+		(struct damon_perf_probe_event *)perf_event->overflow_handler_context;
+	int probe_idx;
+	struct damon_ctx *ctx;
+	struct damon_access_report report = {
+		.size = PAGE_SIZE,
+		.cpu = smp_processor_id(),
+	};
+
+	/*
+	 * Teardown NULLs event->ctx (with a release barrier) before releasing
+	 * the per-CPU perf events, so an in-flight overflow racing the
+	 * disable/release observes the torn-down state and drops the sample
+	 * instead of reporting into a freed ctx.  Pairs with the
+	 * smp_store_release(&event->ctx, NULL) in damon_perf_probe_teardown().
+	 */
+	ctx = smp_load_acquire(&event->ctx);
+	if (!ctx)
+		return;
+	probe_idx = event->probe_idx;
+	report.probe_idx = probe_idx;
+	report.ctx = ctx;	/* route to this ctx's per-ctx perf ring */
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
+		report.vaddr = data->addr & PAGE_MASK;
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
+						      event);
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
+	event->ctx = ctx;		/* route overflow reports to this ctx */
+
+	/*
+	 * Allocate the ctx's per-ctx perf report ring before arming any event,
+	 * so the overflow handler always finds a ready ring.  Idempotent across
+	 * a ctx's multiple probes.
+	 */
+	err = damon_ctx_alloc_perf_ring(ctx);
+	if (err)
+		goto release_owner;
+
+	err = -ENOMEM;
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
+	/* Stop in-flight overflows from reporting; see damon_perf_overflow(). */
+	smp_store_release(&event->ctx, NULL);
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
index 000000000000..8dcb128936ef
--- /dev/null
+++ b/mm/damon/perf_source.h
@@ -0,0 +1,25 @@
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
+
+#endif /* CONFIG_DAMON_PERF_SOURCE */
+#endif /* _DAMON_PERF_SOURCE_H */
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b549496ea8e2..690da51758f2 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -490,6 +490,16 @@ static void damon_va_prep_probe_region(struct damon_ctx *ctx,
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
@@ -594,7 +604,13 @@ static void damon_va_probe_folio(struct damon_ctx *ctx,
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
Git-157)


