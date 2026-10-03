Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D6CCA5FE6
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345CC6B0099; Sat,  3 Oct 2026 17:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6756B009B; Sat,  3 Oct 2026 17:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170436B009D; Sat,  3 Oct 2026 17:08:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D08D56B0099
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:08:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5069F1A0A03
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:37 +0000 (UTC)
X-FDA: 85282553874.20.E2C3713
Received: from mail-yx2-f4.google.com (mail-yx2-f4.google.com [74.125.224.132])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6EED3160009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i64afZ9f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.132 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791061715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hePhCjMY65/KywEMFdGZzfbAB7eiRBwTUjeBoUNRhb0=;
	b=u5kL5sWdJ21KOSrGTO5CjZKjwU+d0VE5p6J5uhVXKla/cjdWh3w4kMAQgUZipjPYo3tNs+
	EzLt5P0ONepbTH7aIozE3AchugQzzvxiZyRI3g0b/mterC3jhCDYOmjV5RD7R/PAcLFu1X
	FM5n5XFBdQo6Bbq3g0eD/UYvSOO5dAU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i64afZ9f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.132 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791061715;
	b=ihRntasj9FJRnyFhrAgilvJ2hsVH1N/hxGMEXxoAPEfvjsvUlH696+7ghA5TY3VWze8vNa
	kiutOdqz3/rskCbqGHzkUk/OwkfmoaS0tWsNGJzcdKP6Jds7fUNS4GOPXbrbifpV5GqtH0
	YVQ8K9Opm5Imvp7vhvvkxJ5IsjufX/c=
Received: by mail-yx2-f4.google.com with SMTP id 956f58d0204a3-66fb34fa3b6so248472d50.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791061714; x=1791666514; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hePhCjMY65/KywEMFdGZzfbAB7eiRBwTUjeBoUNRhb0=;
        b=i64afZ9fDd5F9/ElsaGskn+xNRwFtnom/1dzV6AdX2pDeqtqnJ/tkzjnJj9mzF8TJJ
         iA26CZMJID6bZQ52orqwRJEQE31ojBRhaYayLFpLGhfELUJsJS22bmzHoCMARWadNtBZ
         EwGoimPWMVG6RpjeVl7bb58rTcfUXTLKv+NS+67oYR2in7NDBAS4Vpg69ro5JxmYTYjm
         H05fS3Tm64rV+7zhdKayO88Vj4E8lJtL9K/YuLWsXnb5F/vdTHWMyk7R5dO6kg7Y7+WN
         ckHXbEfgiv33x+BIGbV+GQvMlFY5Xz5rSGt97PHv25yjrKrcRlC2rAe+1jgj2JMxtIpJ
         5KXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791061714; x=1791666514;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hePhCjMY65/KywEMFdGZzfbAB7eiRBwTUjeBoUNRhb0=;
        b=WfJU0mWSdWbjiDuUimLA0Cj31wZlI0btTmbZcprY1r2ko3nY6ouGKRRAlRfDEY0H7Z
         JJRR3WaaOFeeN1+VqIHMiHEQJCstckZNKZTq2ED7+psYuej0Ez9AEtZ1i11JMFL8SVuX
         WhIObDkPUORS1QzQJHjwmkJIQrb91oOeT6xewqhA8YwOTTzKh0qzLoLiRM4ba1WDnoi1
         lzXs38RzIBUqIXACU8GAx0NtXH5F9YJDrTQcWITxDpn3ba9qDcL1O2E5W8/d33yFjufT
         heg3xvqEHtqo2XQjTRBnW7ubByaToDfdCHnoLiVX+SKp7MCoxFQn4N8d3KulFbU4E+3+
         FAvA==
X-Forwarded-Encrypted: i=1; AKwUvByPKbvc4nnR1jR7dUds+kpOlZMtFH5IA07jkYvsRb5lCuTwUhrZEFLsxcT35xD6Omh1LiM8I1bupA==@kvack.org
X-Gm-Message-State: AFq9FYIV+Gb00/4nWTABTc52mc5mGi8VpKPDP6PnUL+6R2D04QLQTNHc
	ILu5IHdD0xBf5oMlhhZiy31KQsd0vXNwz62S04xF7nqhM6vIlTQLNqk6TsIxNEK2qg==
X-Gm-Gg: AYBFou0pG23qQK31+gBur+sfYEospQ56UupFOvs6RJph8y0zygcLz24sCQoV6RC8OY5
	2MmYdGfNBthpQU9glqlMFt9TALtd6nc7RCa7r55N/ZxLmFFaZNiht3MCxpNtQtkLhNLV8i4P/mb
	tyQlx7XWZptcUO8IWIcZZfWHNXNjw1izC+TRDo7OH/V21vQ6PGj0psOV0KRqTKs5g3aUnIbV6Ib
	NjPxlpOE/F61dKB3OWiDg9lfocWx3yVyWvLL6QOXoiDN4H7m5N1a3q0xGTAU37gEqfQ4D3PUcQb
	79u8m2b3SVF4G0nL5JB9konvdSDPfMpQcDzEMKQMWowAGwabcvv+ZUTNygDDH8BoT4ZkRtukjTF
	PWI3qgUfyGHHEH4LC1XtdZmQQ5VNULx/DsV6kfM1QtDpI40QP9UmsM2q+sFboqn3//nBe43cP8z
	MULOdgsCVG/GLs44dQW2VT9Se2A3i5mBPWk3MY5mPbofopFKsrO83SgLxWizR8WIRDAio0LBhbF
	PHzNfTMJAnSa07DamB8NS9McJlWSIFIg+LcQgk7BG9gCIXS7gaJ3hIuWa/6hIJ83JJtW/zCWSh8
	taZw09zyg+ubCH1x8YC4U0iaL7gtUJNoBQ==
X-Received: by 2002:a05:690c:5805:b0:8a9:d5f2:f5a6 with SMTP id 00721157ae682-8ae95ae16famr9401937b3.67.1791061714039;
        Sat, 03 Oct 2026 14:08:34 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af0d179d3bsm743537b3.40.2026.10.03.14.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:08:32 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sat, 03 Oct 2026 14:07:58 -0700
Subject: [RFC PATCH v3 5/9] mm/damon: add perf_event prep type, core
 lifecycle, and PMU arm/disarm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-5-0f00417b41bc@gmail.com>
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
X-Stat-Signature: stknpmr38r4kx3tpqtbgq9ywzjkfsywz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6EED3160009
X-HE-Tag: 1791061715-489702
X-HE-Meta: U2FsdGVkX19VdlD/d92mOwhGtVnFmWaj3rlEFRuza7M1TxdmNyBYuKAty5XoNRvZd9qlbMUY688jVAlGnLKmlK0GlTfB+t/rWebxzmwMj4reTHESgp9z1ArbStyQA0GTe2uG448vnxKQKU9bpcfJUqJrqXznDGoWnzPSimuGQAu3zhQOo+yhUkwCPVdrdXb9GyOLLhRJdRAo13b4jOxw2B7ocayhU3kLqeCSI2Fv6E4Jp77L6F/uW7d+rOKNO7ju3Kf0l3zWx93kPWzz+GaLJAV08kh9Db2giOJE3LCAPVk7dbHBZ04/NjlvRNIXFT2JvxgPoOWJh+jcpNhWR0UJLGzVX3JRqNKyp7zNnKRCgm4WGVfaFXrscGRYrjJupOgW4WGhDMM1qL9q7pYJUFRb58dZw4r/LXZTU0RX2/X+eNLRQcG/0aYggU2qjvQAvm/Z55IW1kVC24zvldvNivwLDFHZNU+YnsUL003mujJ4/XpjgF6trI99g2zvnUZGOuPSd1xcoN9K7CAd1FNtJrRScxsURF9SZ+qQ2ohW4DVz0tdUGPr/TkzWKgv5qq2Wu3lTe43taLwHSRq9c4SH8xoCIBM5mSfm+waLimXq502/k8rB5uEZJqSnTk+KM46b5UnsJJ0ldO5vHe45h3KRBpH0xREBvDB6jnJUgYXBDfOt6UmyampHVNhBCnE02tkRgpm2MC3iXyZBALqhbzjxa1MbraZ2INi7aL3VyudF/mvsUmQI4+3z5pEQ2paFl3HkN76nmwUJOYqPRe1jWpVz7Aw10Sn3DFmuMd+tcQvBZMOMRPiGNuHVa+sbuaqilBfZkY5DpJvAJ+UUf387ZAt9qsracA0qYm4ptXJzdK0+M4Kd34UrKAtRGlg6a84l4tRuKzrk/6Q6e64m5eXG9HfTE/egxQ9DwazrpdBSP+o/fzBGnNlET0ixBjImBNxbFNDH1ZaFQE+6H+XGrQRK/e+BXvr
 86EkF/5J
 OUOlDPn7YjsMi9J+EqmY/AxBSRF2vLXcz5M4VPJP8M6szc2EeL2YiyFvZeILYT/8onZ9+YWoqlLRlYFbVXvsD50Y6GqFlIT3NR5yk+8iSPPlZO9E2yyeDPmV3l+m6AAD9HeTpapLZJkCFZ+ZO0Sk5M+R1MecnR9cfUEfK/GVOOlV3ZtV9QX/E0R6Y9q4ZJEnmL0QR2qQ0AmJhUMGg1hS7suKizp4tkBn71OiV2d50Ku6BYWYPwgc2uNCTaiW/ZG9MbEhJAmgiNvrQwQTo/jzdWlb8ckoh4f7s+LryOChE3Bi3hm2/HiaXpqsFZ+lsRJJEACQgAU5PLQY6TJDTvW3l9/YeiDQhmiVIunxp8Yh11o93FYTrDJYHo18wbPrE8px8zoB8rZxSk5kPUUj2z+K74jfqchlAns2OI3MsE0yOk2Oo16wNZ4J660W9pGpSF9DpWIjk1UHNw976jO2zVEmth0K7JUW1xZ5IRmQLnepfxVa0+PfD4qEH7ogRkjqzo+9sKG4ecvvySrR07LRohMIIPrxkRfrPXlTo6LirelTSg54d+Ow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The prep interface exposes a single preparation action, set_pgidle, which
arms the page-idle scan used by the software access check.  There is no
way for user space to configure a probe whose access information comes
from a hardware PMU sampling facility, even though the perf-event source
(CONFIG_DAMON_PERF_SOURCE) already provides the NMI-safe overflow
handler, the report ring, and the probe setup/teardown lifecycle to
consume such samples.

Add a DAMON_PREP_PERF_EVENT prep action carrying a subset of
perf_event_attr (type, config, config1, config2, sampling period or
frequency, wakeup_events, precise_ip, sample_phys_addr,
sample_weight_struct, exclude_kernel, exclude_hv), and wire it through
include/linux/damon.h, mm/damon/perf_source.h and mm/damon/core.c.  A
probe that has a perf_event prep is event driven: DAMON does not walk it
in the apply_probes vtable; instead the PMU samples memory accesses and
feeds region hit counters through the report ring.

The prep also carries how many counters the PMU needs.  A per-CPU PMU is
armed by adding a cpuhp instance, which opens one kernel counter on every
online CPU.  A system-wide PMU is a single hardware unit served by exactly
one counter, so a single_instance flag opens one kernel counter pinned to
a fixed online CPU and bypasses the cpuhp fan-out.  The pin names a real
online CPU because such a PMU registers with perf_invalid_context, for
which cpu = -1 would route to task context.  If that CPU is later
offlined the counter stops and is not migrated, which is acceptable for a
dedicated monitoring host.

The PMU is only armed when building the context that will actually run.  A
param_ctx built for a commit carries the attributes but defers arming,
because arming a throwaway context would collide with the running
context's per-PMU ownership, and a commit_live flag distinguishes the
dry-run validation pass from the real commit.  The commit path hands the
armed event between the running probe and the committed source probe,
keeping the running event untouched on the common weight-only commit and
re-arming only when the perf attributes change or the probe's list
position no longer matches the position its running event's probe_idx
was computed for; a probe reorder with unchanged attributes still needs
a re-arm, or the event keeps crediting probe_hits[] at its old index.

The armed event is released both when monitoring is turned off, from
kdamond_fn()'s exit path after damon_destroy_targets(), and when the
context is destroyed.  Both run outside NMI context, so a provider's
sleeping teardown is safe.  Turning monitoring back on through sysfs builds
a fresh context, which arms a new event from the probe attributes.  The
teardown barrier the overflow handler pairs with, a release store of
event->ctx = NULL, covers the single-instance path as well as the per-CPU
one.

__damon_commit_ctx() and damon_commit_probes() gain the commit_live flag
described above, false for the validation and test-context passes and
true for the real commit; its one existing kunit call site in
mm/damon/tests/core-kunit.h is updated to pass false, matching the
dry-run behaviour before this change.  Wiring these attributes through
sysfs is a separate, following commit.

Co-developed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h       |  29 ++++++++
 mm/damon/core.c             | 156 ++++++++++++++++++++++++++++++++++++++---
 mm/damon/perf_source.c      | 167 ++++++++++++++++++++++++++++++--------------
 mm/damon/perf_source.h      |  30 +++++++-
 mm/damon/tests/core-kunit.h |   2 +-
 5 files changed, 320 insertions(+), 64 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d7baa6a58d3d..317df4a1e5be 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -868,18 +868,45 @@ struct damon_intervals_goal {
  * enum damon_prep_action - DAMON probing preparation action.
  *
  * @DAMON_PREP_SET_PGIDLE:	Set the probing memory as idle page.
+ * @DAMON_PREP_PERF_EVENT:	Configure a perf-event hotness probe.
  */
 enum damon_prep_action {
 	DAMON_PREP_SET_PGIDLE,
+	DAMON_PREP_PERF_EVENT,
 };
 
 /**
  * struct damon_prep - DAMON probing preparation request.
  *
  * @action:	Action to do to the probing memory for the preparation.
+ * @perf:	perf_event_attr subset selecting the PMU and sampling
+ *		parameters.  Only valid when @action is DAMON_PREP_PERF_EVENT.
+ *
+ * A DAMON_PREP_PERF_EVENT prep turns the containing &struct damon_probe into
+ * an event-driven probe: instead of DAMON walking the address space each
+ * sampling interval, a per-CPU perf_event (e.g. AMD IBS Op, Intel PEBS)
+ * samples memory accesses and feeds them into the probe hit counters via the
+ * report ring.  The @perf fields are copied into a perf_event_attr when the
+ * kdamond is turned on.
  */
 struct damon_prep {
 	enum damon_prep_action action;
+	struct {
+		u32 type;
+		u64 config;
+		u64 config1;
+		u64 config2;
+		u64 sample_period;
+		u64 sample_freq;
+		u32 wakeup_events;
+		u32 precise_ip;
+		bool sample_phys_addr;
+		bool sample_weight_struct;
+		bool exclude_kernel;
+		bool exclude_hv;
+		bool freq;
+		bool single_instance;
+	} perf;
 /* private: */
 	/* siblings list. */
 	struct list_head list;
@@ -936,6 +963,8 @@ struct damon_filter {
 struct damon_probe {
 	unsigned int weight;
 	bool event_driven;	/* hits arrive via ring drain, not apply_probes */
+	/* perf-event probe state (struct damon_perf_probe_event *) for teardown */
+	void *perf_priv;
 /* private: */
 	/* Preparation actions to apply to each probing memory. */
 	struct list_head preps;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6a90cf465d40..de7e0f4e3225 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -18,6 +18,7 @@
 
 /* for damon_get_folio() used by node eligible memory metrics */
 #include "ops-common.h"
+#include "perf_source.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -305,6 +306,16 @@ struct damon_probe *damon_new_probe(void)
 	if (!p)
 		return NULL;
 	p->weight = 0;
+	p->event_driven = false;
+	/*
+	 * Must be NULL: damon_destroy_ctx()/damon_commit_probes() test
+	 * p->perf_priv to decide whether to call damon_perf_probe_teardown().
+	 * An uninitialised (garbage) perf_priv makes the teardown kfree() a
+	 * wild pointer when a probe is destroyed before it is ever armed
+	 * (e.g. perf_event_create_kernel_counter() fails and damon_start()
+	 * unwinds via damon_destroy_ctx()).
+	 */
+	p->perf_priv = NULL;
 	INIT_LIST_HEAD(&p->preps);
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
@@ -369,6 +380,8 @@ bool damon_has_probe_weights(struct damon_ctx *c)
  * Event-driven probes (e.g. perf-event IBS/PEBS) populate probe_hits[] via
  * the SPSC ring drain rather than the apply_probes vtable.  Callers use this
  * to decide whether to arm hardware sampling.
+ *
+ * @ctx: the DAMON context whose probes are inspected.
  */
 bool damon_has_event_driven_probes(struct damon_ctx *ctx)
 {
@@ -1177,8 +1190,20 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 	damon_for_each_scheme_safe(s, next_s, ctx)
 		damon_destroy_scheme(s);
 
-	damon_for_each_probe_safe(p, next_p, ctx)
+	damon_for_each_probe_safe(p, next_p, ctx) {
+#ifdef CONFIG_DAMON_PERF_SOURCE
+		/*
+		 * Release the PMU counters before freeing the probe.
+		 * damon_perf_probe_teardown() owns and frees the event
+		 * descriptor.
+		 */
+		if (p->perf_priv) {
+			damon_perf_probe_teardown(ctx, p->perf_priv);
+			p->perf_priv = NULL;
+		}
+#endif
 		damon_destroy_probe(p);
+	}
 
 	damon_for_each_sample_filter_safe(f, next_f, &ctx->sample_control)
 		damon_destroy_sample_filter(f, &ctx->sample_control);
@@ -2020,6 +2045,7 @@ static int damon_commit_targets(
 static void damon_commit_prep(struct damon_prep *dst, struct damon_prep *src)
 {
 	dst->action = src->action;
+	dst->perf = src->perf;
 }
 
 static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
@@ -2114,7 +2140,74 @@ static int damon_commit_filters(struct damon_probe *dst,
 	return 0;
 }
 
-static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
+#ifdef CONFIG_DAMON_PERF_SOURCE
+/*
+ * Hand off the armed perf event between a running probe (@dst, in the live
+ * @ctx) and the committed source probe (@src, from a discarded param_ctx that
+ * was built without arming).  Keeps the running event untouched when the perf
+ * attributes are unchanged AND @dst is still at the list position (@dst_idx)
+ * its running event's probe_idx was computed for (the common weight-only
+ * commit); otherwise tears down the old event and re-arms from @src's
+ * carried attributes.  The position check matters because a probe reorder
+ * with unchanged attrs would otherwise keep crediting probe_hits[] at the
+ * probe's old index instead of its new one.
+ *
+ * @src->perf_priv is built by the sysfs layer from @src's DAMON_PREP_PERF_EVENT
+ * prep before the commit; ownership of that descriptor moves to @dst here.
+ */
+static int damon_commit_perf_probe(struct damon_ctx *ctx,
+		struct damon_probe *dst, struct damon_probe *src, int dst_idx)
+{
+	struct damon_perf_probe_event *dst_ev = dst->perf_priv;
+	struct damon_perf_probe_event *src_ev = src->perf_priv;
+	int err;
+
+	if (!src_ev) {
+		/* Source has no perf probe: tear down any running event. */
+		if (dst_ev) {
+			damon_perf_probe_teardown(ctx, dst_ev);
+			dst->perf_priv = NULL;
+		}
+		return 0;
+	}
+
+	/*
+	 * Already armed with identical attrs and still at the list position
+	 * its probe_idx was computed for: keep the running event.  A probe
+	 * reorder with unchanged attrs must still fall through to re-arm
+	 * below, or the event keeps crediting the probe_hits[] slot for its
+	 * old position instead of its new one.
+	 */
+	if (dst_ev && dst_ev->priv &&
+	    dst_ev->probe_idx == dst_idx + 1 &&
+	    !memcmp(&dst_ev->attr, &src_ev->attr, sizeof(dst_ev->attr)))
+		return 0;
+
+	/* Attrs changed (or dst not armed): re-arm from src attributes. */
+	if (dst_ev) {
+		damon_perf_probe_teardown(ctx, dst_ev);
+		dst->perf_priv = NULL;
+	}
+	err = damon_perf_probe_setup(ctx, dst, src_ev);
+	if (err) {
+		/* dst old event already torn down; nothing armed now. */
+		dst->event_driven = false;
+		return err;
+	}
+	/* Ownership of src_ev moves to dst; the param_ctx must not free it. */
+	dst->perf_priv = src_ev;
+	src->perf_priv = NULL;
+	return 0;
+}
+#endif /* CONFIG_DAMON_PERF_SOURCE */
+
+/*
+ * @commit_live is false for the dry-run validation pass (a commit into a
+ * throwaway test_ctx) and true for the real commit into the running ctx.
+ * The PMU may only be armed or disarmed on the real commit.
+ */
+static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src,
+		bool commit_live)
 {
 	struct damon_probe *dst_probe, *next, *src_probe, *new_probe;
 	int i = 0, j = 0, err;
@@ -2123,13 +2216,29 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
 			dst_probe->weight = src_probe->weight;
+			dst_probe->event_driven = src_probe->event_driven;
 			err = damon_commit_preps(dst_probe, src_probe);
 			if (err)
 				return err;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
+#ifdef CONFIG_DAMON_PERF_SOURCE
+			if (commit_live) {
+				err = damon_commit_perf_probe(dst, dst_probe,
+							      src_probe, i - 1);
+				if (err)
+					return err;
+			}
+#endif
 		} else {
+#ifdef CONFIG_DAMON_PERF_SOURCE
+			if (commit_live && dst_probe->perf_priv) {
+				damon_perf_probe_teardown(dst,
+						dst_probe->perf_priv);
+				dst_probe->perf_priv = NULL;
+			}
+#endif
 			damon_destroy_probe(dst_probe);
 		}
 	}
@@ -2143,12 +2252,23 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
 		new_probe->weight = src_probe->weight;
+		new_probe->event_driven = src_probe->event_driven;
 		err = damon_commit_preps(new_probe, src_probe);
 		if (err)
 			return err;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
+#ifdef CONFIG_DAMON_PERF_SOURCE
+		if (commit_live && src_probe->perf_priv) {
+			err = damon_perf_probe_setup(dst, new_probe,
+						     src_probe->perf_priv);
+			if (err)
+				return err;
+			new_probe->perf_priv = src_probe->perf_priv;
+			src_probe->perf_priv = NULL;
+		}
+#endif
 	}
 	return 0;
 }
@@ -2244,7 +2364,8 @@ static int damon_commit_sample_control(
 	return damon_commit_sample_filters(dst, src);
 }
 
-static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src,
+		bool commit_live)
 {
 	int err;
 	struct damos *scheme;
@@ -2292,7 +2413,7 @@ static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;
-	err = damon_commit_probes(dst, src);
+	err = damon_commit_probes(dst, src, commit_live);
 	if (err)
 		return err;
 	err = damon_commit_sample_control(&dst->sample_control,
@@ -2314,7 +2435,7 @@ static struct damon_ctx *damon_new_test_ctx(struct damon_ctx *dst)
 	test_ctx = damon_new_ctx();
 	if (!test_ctx)
 		return NULL;
-	err = __damon_commit_ctx(test_ctx, dst);
+	err = __damon_commit_ctx(test_ctx, dst, false);
 	if (err) {
 		damon_destroy_ctx(test_ctx);
 		return NULL;
@@ -2343,10 +2464,10 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	test_ctx = damon_new_test_ctx(dst);
 	if (!test_ctx)
 		return -ENOMEM;
-	err = __damon_commit_ctx(test_ctx, src);
+	err = __damon_commit_ctx(test_ctx, src, false);
 	if (err)
 		goto out;
-	err = __damon_commit_ctx(dst, src);
+	err = __damon_commit_ctx(dst, src, true);
 out:
 	damon_destroy_ctx(test_ctx);
 	return err;
@@ -2467,7 +2588,7 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 		if (!test_ctx)
 			return -ENOMEM;
 
-		err = __damon_commit_ctx(test_ctx, ctxs[i]);
+		err = __damon_commit_ctx(test_ctx, ctxs[i], false);
 		damon_destroy_ctx(test_ctx);
 		if (err)
 			return err;
@@ -4925,6 +5046,25 @@ static int kdamond_fn(void *data)
 done:
 	damon_destroy_targets(ctx);
 
+#ifdef CONFIG_DAMON_PERF_SOURCE
+	/*
+	 * Release perf-event probes here so a stopped kdamond leaves no event
+	 * firing overflows into its report ring, and holds no PMU ownership
+	 * or provider module reference.  This runs in kdamond context, so a
+	 * provider's sleeping teardown is safe here.
+	 */
+	{
+		struct damon_probe *p, *next_p;
+
+		damon_for_each_probe_safe(p, next_p, ctx) {
+			if (p->perf_priv) {
+				damon_perf_probe_teardown(ctx, p->perf_priv);
+				p->perf_priv = NULL;
+			}
+		}
+	}
+#endif
+
 	kfree(ctx->regions_score_histogram);
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = true;
diff --git a/mm/damon/perf_source.c b/mm/damon/perf_source.c
index 51e8957aed8c..8af20b4eb074 100644
--- a/mm/damon/perf_source.c
+++ b/mm/damon/perf_source.c
@@ -14,39 +14,22 @@
 #include <linux/slab.h>
 #include "perf_source.h"
 
-/* PMU event attribute for perf-event probe configuration */
-struct damon_perf_event_attr {
-	u32 type;
-	u64 config;
-	u64 config1;
-	u64 config2;
-	bool sample_phys_addr;
-	bool sample_weight_struct;
-	bool exclude_kernel;
-	bool exclude_hv;
-	bool freq;
-	u64 sample_freq;
-	u64 sample_period;
-	u32 wakeup_events;
-	u32 precise_ip;
-};
-
-struct damon_perf_probe_event {
-	struct damon_perf_event_attr attr;
-	void *priv;		/* struct damon_perf_probe_state * */
-	struct hlist_node hlist_node;
-	int probe_idx;		/* index into probe_hits[]; set at registration */
-	struct damon_ctx *ctx;	/* owning ctx; NULLed at teardown */
-};
+/*
+ * struct damon_perf_event_attr and struct damon_perf_probe_event are defined
+ * in perf_source.h so that the sysfs configuration surface can build a probe
+ * event descriptor before handing it to damon_perf_probe_setup().
+ */
 
 struct damon_perf_probe_state {
-	struct perf_event * __percpu *event;
+	struct perf_event * __percpu *event;	/* per-CPU probes (PEBS/IBS) */
+	struct perf_event *single_event;	/* single-instance probes (system-wide PMU) */
 };
 
 static DEFINE_PER_CPU(unsigned long, damon_perf_samples_total);
 static DEFINE_PER_CPU(unsigned long, damon_perf_samples_filtered);
 static DEFINE_PER_CPU(unsigned long, damon_perf_samples_no_addr);
 
+
 static void damon_perf_overflow(struct perf_event *perf_event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
@@ -111,8 +94,7 @@ static enum cpuhp_state damon_perf_cpuhp_state;
 
 /*
  * Per-PMU exclusivity: each PMU type may be owned by at most one damon_ctx.
- * Multiple probes from the same ctx sharing a PMU type are allowed; a second
- * ctx attempting to grab a PMU type already owned returns -EBUSY.
+ * Multiple probes from the same ctx sharing a PMU type are allowed.
  */
 struct damon_pmu_owner {
 	struct list_head node;
@@ -237,6 +219,11 @@ int damon_perf_probe_setup(struct damon_ctx *ctx,
 	 * Per-PMU exclusivity: find or create an owner slot for this PMU type.
 	 * Multiple probes from the same ctx sharing a PMU type are allowed;
 	 * a second ctx attempting the same PMU type returns -EBUSY.
+	 *
+	 * NOTE: damon_commit_perf_probe() does call back into this function
+	 * on the attrs-changed commit path: it tears the old event down and
+	 * re-arms via damon_perf_probe_setup() rather than updating the perf
+	 * event in place, so the owner table is exercised on that path too.
 	 */
 	spin_lock(&damon_pmu_owner_lock);
 	list_for_each_entry(owner, &damon_pmu_owner_list, node) {
@@ -303,12 +290,55 @@ int damon_perf_probe_setup(struct damon_ctx *ctx,
 	perf = kzalloc_obj(*perf, GFP_KERNEL);
 	if (!perf)
 		goto release_owner;
+	event->priv = perf;
+
+	/*
+	 * A system-wide PMU is a single hardware unit rather than a per-CPU
+	 * counter, so it needs exactly one counter: the cpuhp fan-out below
+	 * would run one redundant sampler per CPU against the one device and
+	 * corrupt its shared state.  Pin that counter to a fixed online CPU
+	 * and bypass cpuhp.
+	 *
+	 * The pin must name a real CPU (>= 0) because the PMU is
+	 * perf_invalid_context, for which cpu = -1 routes to task context.  If
+	 * that CPU is later offlined the counter stops and is not migrated,
+	 * which is acceptable for a dedicated monitoring host that does not
+	 * hotplug CPUs.
+	 */
+	if (event->attr.single_instance) {
+		struct perf_event_attr attr;
+		int cpu = cpumask_first(cpu_online_mask);
+
+		damon_perf_event_init_attr(event, &attr);
+		/*
+		 * Pass @event (not a probe_idx cookie) as the overflow context:
+		 * damon_perf_overflow() casts it to damon_perf_probe_event* and
+		 * reads event->ctx via smp_load_acquire() for the teardown race
+		 * barrier, same as the per-CPU path (damon_perf_cpu_online()).
+		 */
+		perf->single_event = perf_event_create_kernel_counter(&attr, cpu,
+				NULL, damon_perf_overflow, event);
+		if (IS_ERR(perf->single_event)) {
+			err = PTR_ERR(perf->single_event);
+			perf->single_event = NULL;
+			pr_warn("damon-perf: single-instance event create failed: %d\n",
+				err);
+			goto free_perf;
+		}
+		perf_event_enable(perf->single_event);
+		/*
+		 * Ownership is already held via the per-PMU owner->refcount
+		 * acquired at the top of setup; the single-instance path shares
+		 * that slot, so no separate refcount is taken here.  Teardown
+		 * releases it through the same owner list as the per-CPU path.
+		 */
+		return 0;
+	}
 
 	perf->event = alloc_percpu(typeof(*perf->event));
 	if (!perf->event)
 		goto free_perf;
 
-	event->priv = perf;
 	INIT_HLIST_NODE(&event->hlist_node);
 
 	err = cpuhp_state_add_instance(damon_perf_cpuhp_state,
@@ -338,46 +368,75 @@ EXPORT_SYMBOL_GPL(damon_perf_probe_setup);
 
 /**
  * damon_perf_probe_teardown - disarm perf_events.
+ * @ctx: DAMON context that owns the probe (used to release per-PMU ownership).
  * @event: perf event descriptor previously passed to damon_perf_probe_setup()
  */
 void damon_perf_probe_teardown(struct damon_ctx *ctx,
 			       struct damon_perf_probe_event *event)
 {
 	struct damon_perf_probe_state *perf = event->priv;
-	struct damon_pmu_owner *owner, *tmp;
 
-	if (!perf)
-		return;
+	if (perf) {
+		struct damon_pmu_owner *owner, *tmp;
 
-	/* Stop in-flight overflows from reporting; see damon_perf_overflow(). */
-	smp_store_release(&event->ctx, NULL);
-	cpuhp_state_remove_instance(damon_perf_cpuhp_state,
-				    &event->hlist_node);
-	free_percpu(perf->event);
-	kfree(perf);
-	event->priv = NULL;
+		/*
+		 * Signal in-flight NMI overflow handlers to drop samples
+		 * before tearing down the perf events and freeing their
+		 * backing state.  Pairs with smp_load_acquire(&event->ctx)
+		 * in damon_perf_overflow().  This applies to both the per-CPU
+		 * and single-instance paths: a single-instance counter can
+		 * also deliver an overflow racing teardown.
+		 */
+		smp_store_release(&event->ctx, NULL);
 
-	/*
-	 * Release per-PMU ownership when the last probe for this
-	 * ctx/PMU-type pair is torn down.
-	 */
-	spin_lock(&damon_pmu_owner_lock);
-	list_for_each_entry_safe(owner, tmp, &damon_pmu_owner_list, node) {
-		if (owner->pmu_type == event->attr.type &&
-		    atomic_long_read(&owner->owner_ctx) == (long)ctx) {
+		if (perf->single_event) {
 			/*
-			 * Free under the lock so a concurrent same-PMU teardown
-			 * cannot observe and free the same owner. kfree() under
-			 * a non-irq spinlock in process context is safe.
+			 * Single-instance probe: no cpuhp instance was added, so
+			 * just release the one counter (process context here, so
+			 * disable+release is safe).  disable() also quiesces any
+			 * pending overflow before release.
 			 */
-			if (atomic_dec_and_test(&owner->refcount)) {
-				list_del(&owner->node);
-				kfree(owner);
+			perf_event_disable(perf->single_event);
+			perf_event_release_kernel(perf->single_event);
+			perf->single_event = NULL;
+		} else {
+			/*
+			 * cpuhp_state_remove_instance() disables+releases each
+			 * CPU's perf event; once it returns no new overflow can
+			 * be delivered for this event.
+			 */
+			cpuhp_state_remove_instance(damon_perf_cpuhp_state,
+						    &event->hlist_node);
+			free_percpu(perf->event);
+		}
+		kfree(perf);
+		event->priv = NULL;
+
+		/*
+		 * Release per-PMU ownership when the last probe for this
+		 * ctx/PMU-type pair is torn down.
+		 */
+		spin_lock(&damon_pmu_owner_lock);
+		list_for_each_entry_safe(owner, tmp, &damon_pmu_owner_list, node) {
+			if (owner->pmu_type == event->attr.type &&
+			    atomic_long_read(&owner->owner_ctx) == (long)ctx) {
+				/*
+				 * Free under the lock so a concurrent same-PMU
+				 * teardown cannot observe and free the same
+				 * owner. kfree() under a non-irq spinlock in
+				 * process context is safe.
+				 */
+				if (atomic_dec_and_test(&owner->refcount)) {
+					list_del(&owner->node);
+					kfree(owner);
+				}
+				break;
 			}
-			break;
 		}
+		spin_unlock(&damon_pmu_owner_lock);
 	}
-	spin_unlock(&damon_pmu_owner_lock);
+	/* teardown owns the event allocation */
+	kfree(event);
 }
 EXPORT_SYMBOL_GPL(damon_perf_probe_teardown);
 
diff --git a/mm/damon/perf_source.h b/mm/damon/perf_source.h
index 8dcb128936ef..8abbe5f63df4 100644
--- a/mm/damon/perf_source.h
+++ b/mm/damon/perf_source.h
@@ -13,7 +13,35 @@
 #include <linux/damon.h>
 #include <linux/perf_event.h>
 
-struct damon_perf_probe_event;
+/*
+ * PMU event attributes for a perf-event probe.  A subset of perf_event_attr
+ * chosen at probe creation time to select the PMU (AMD IBS, Intel PEBS, ...)
+ * and its sampling parameters.
+ */
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
+	bool single_instance;	/* system-wide PMU: open one counter, not per-CPU */
+	u64 sample_freq;
+	u64 sample_period;
+	u32 wakeup_events;
+	u32 precise_ip;
+};
+
+struct damon_perf_probe_event {
+	struct damon_perf_event_attr attr;
+	struct damon_ctx *ctx;	/* owning ctx for ring routing; set at setup */
+	void *priv;		/* struct damon_perf_probe_state * */
+	struct hlist_node hlist_node;
+	int probe_idx;		/* index into probe_hits[]; set at registration */
+};
 
 int damon_perf_probe_setup(struct damon_ctx *ctx,
 			   struct damon_probe *probe,
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 3fbb4e4e36fa..43432ae5f68f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1590,7 +1590,7 @@ static void damon_test_commit_probes_for(struct kunit *test,
 		kunit_skip(test, "src alloc fail");
 	}
 
-	err = damon_commit_probes(dst, src);
+	err = damon_commit_probes(dst, src, false);
 	KUNIT_EXPECT_EQ(test, err, 0);
 	if (err)
 		goto out;

-- 
Git-157)


