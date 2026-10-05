Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF05ECA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951696B0099; Mon,  5 Oct 2026 04:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5646B009B; Mon,  5 Oct 2026 04:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CCE6B009D; Mon,  5 Oct 2026 04:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D23E6B0099
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:47:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE443A0194
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:07 +0000 (UTC)
X-FDA: 85287942894.17.03F7665
Received: from mail-yx2-f2.google.com (mail-yx2-f2.google.com [74.125.224.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id E52BD140007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PLw43xFf;
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.130 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dA+OexKPMrSlq2+SgZHzPJd4bfphbMQrkGFgIYWBztw=;
	b=LO4uQRGijkBuA2BLU0EFDdx6fxJqiTSIBxR3D9blhzKVidVYHoXqpvKmiWTBHX20Yqep3H
	32a1NYZwpULrm01rFzu3wMODZtHbtBQTxVIAPAo4/5Kg3EnUTYIk8c9/ni+GIisDBoCqw1
	6oUH30uNz0+0+cCsxkO8RlcisYPA9w8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PLw43xFf;
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.130 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190025;
	b=vd8Q1VGgHHNCMNzOApN92PathSXHnDIOaA9tpDY/+ezHXenv4MumfQUl1ywvpKkb1AWwMU
	Yq2Zi9Wht2MxnTZ+WhZ4ZNYkihek3CIs64sGda8MQH9dxK0jT2K9ZtuotQBxmvX7lZk5U/
	J8uNgKXPLnkyqRfFYIMbXH7wXd8ow+U=
Received: by mail-yx2-f2.google.com with SMTP id 956f58d0204a3-67569b8cbf8so297262d50.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190025; x=1791794825; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dA+OexKPMrSlq2+SgZHzPJd4bfphbMQrkGFgIYWBztw=;
        b=PLw43xFfWWzCpw8xj7jGrNGUX/+QsY6nhIbOxBM9aZLs30wzuKHW+x5UfeH+TEjAFo
         KrxkLIeCm09gqHdxx95NXy3yih/2dSEJqUYHMxPg93NXhA0mtk6buK8JWbAdMHWxFwAh
         re8zWrUhrkGLf7ES/LgU2xtnEqZRS1UTwMndBdCbcYZnaHrNBbet/E2lNj192Hl1W1U1
         we70v6qkW14j0VAZw5ETFEvARk5E2HJS7oBnCH5lhFWTsKfxF+y2DGOrL9gxKTIdFchJ
         XvSyPTP9ja4Nn+aD+x0db1/pxMiGwpTZv6Nsvfvwq4Lp1W/i0V/hCbFu6Xa1Dtv9JE03
         Bmyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190025; x=1791794825;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dA+OexKPMrSlq2+SgZHzPJd4bfphbMQrkGFgIYWBztw=;
        b=SfxuRfCBDrXO73AFtK6/vJ5rcZpHPsLbL3hly9k0BOpeRcTwkvVezLmU+0qzNpQ7YR
         OJtPJro2ZdnZfG/qGo90DJYmFPed2Usi2m6Gpdd9hoFeySS9Le4mI2PiUAXCsSRtycT8
         3iYkpon6p0hRAF1KSDpNS7SLFUQrJHahIBYQIDrfwXbxA2we31zwkgcVUumEpFTn/aX5
         zstrgEcK5Fsfnw3q2OxFZ/SDztO7ay565ARiCsem9rUFVRv790lpmDlaEPCIdTsspLU9
         vMDTalA7ylHhX2hKbr5GGuVpTdb3VaRvvJ5S6eykVYMr7zjW+NTpwEHZHyYTs4hZLYqC
         Ex9g==
X-Forwarded-Encrypted: i=1; AKwUvBwAUVTMLIBwkdE7gHwaF8ZkykFcHFNyJbp/L6aWSWOUY/sPz3YIW1/dNJx0ED08Tlcw0ghP09HaDg==@kvack.org
X-Gm-Message-State: AFq9FYJbLIqXUC/uHiSQNbSyw5LkvsdPOMCxP/U6MUNj8pyRuEu0IdYV
	LK9kLiPTPVSXRkYk/HFykPRFnqxTqb9+PFVQRmzevA+lBKVzuvt+bpM=
X-Gm-Gg: AYBFou2Wh2varbeWK/nTS1WmaiiwksBBcIhw+w5vV0SeOcmxAG91n2Z2WPiq41PVFid
	hwAHc7hORKmRUg3w3/XmNXpk3hO7GvZ9rVLD23IH0m0UsdzoP90geaSuS9wACESuyH28t2Axyu+
	W233VJYZi2OK2fxI6icnIW77xoYjx++dkqqlcKdYD8TPLn9/gKgzJxki+jsyNpG2PDszhHV6Mb1
	Zf4Dx/ujqFJ5DPBa5MVqiMXREAFREVO06hV/A63D877uQ4WYsj4YcvFQIt6jKVVYr1UPIWdTr03
	/EB3wUFZlYhRK5l8j1VmomaUWCEJID9NQfG2F3FqFIntBTxHiYnpjVagb5F4vajg7ejpJb+uM4K
	a5wOLnmFzM/6FgBdYFDVA/3YD/EXwHnSWgtYhxsYD8pHaR/7EYu9Rlqrb++nvaR3xavoia4frJi
	6YSBCM/B/+dA1ReUdWiWNL4G3gQoOzLi/Xmic+0vB/OVkR6cAIHsSnFfreAgFzc0+29rUjYTVw3
	3N8SooH6I3H03mhQ3tR/YYUSBdeQd+WrTMlFY2WVWK/61wY92D2k3ve08mDnPwkUwtHUo47r+a/
	U2CodulCKvLP2rnOar270SFnxZnX11D8qQ==
X-Received: by 2002:a05:690e:d07:b0:677:cc34:2f4b with SMTP id 956f58d0204a3-677cc343138mr1603278d50.22.1791190024778;
        Mon, 05 Oct 2026 01:47:04 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:47:03 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 05 Oct 2026 01:46:49 -0700
Subject: [RFC PATCH v4 5/9] mm/damon: add perf_event prep type, core
 lifecycle, and PMU arm/disarm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-5-b03452e137f3@gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E52BD140007
X-Stat-Signature: wouj8tuf9t8uwyqbed6am1rp6iu86yoc
X-Rspam-User: 
X-HE-Tag: 1791190025-321284
X-HE-Meta: U2FsdGVkX19sd8jS+JtRlBALMdqhiGef299k73Fnbf0vrhR0pUWuU25uqtFNRfMhoUK7tVd0IsvmhxpOTE9WvDz6BEYqLTyM6qboaPHYfcbX/uvaMONF1vJf4AQl+kaLpvgqs3hyKnzuIQWEVBab5pEJHa70T5zHwErjTcXzY2zp5i0rIy5cJFP8u4651ghe72I9wqwfME3P+SBnYY5kC2bQ1YniwffEtijcDyFZtBWdt55tZsqN/RuZqFF6bPpYx7H9aAfEBBYMlozpa45y6D4vLpOjUIo88CGEH/MToT0E88eKqStNmRB2DwfcKTDrHgF44OUcpiOUeFcVRj3dhziPyMBrgBXkUBEvVQ8QWW/ruQQkq0EGzSBfNsO9NQG5zZhO+bgnC8k8dUb/34Lnae0UEsZgZybhzQiJKzCMZu7BifgnIJYRGU3ksaxmrNU6BQi/k9MX/BSEcp5yvqK8mTVCGGNthrNxpgCYazvTWcy0cuZwL/YpqKwI2ZGkJXls5wekc7MyQivhCsbyJvuxqNidhTKFLAaxg5C7egecOjgKbb/CpJFCkK/Dsj5ceRHLjAtP3B2eH4nseCHB0lFLvkeTeLQjw3EhzBMVevuYqCcYKfe2AA+yWp+wDW8aLZkL+4GIG/dpLsd3m4ymEVChNnHrHMigns8TIRwGCKxUdoChTf5BQFbd3NXS+EEr75hvaCXmaxj4bb4KvuiLIXVkX4SwSpe4K/zRjxMHWcSL63akFpUREVBBlxPAYucEtIufThCXlHB4GFcJ6olCQAHPQCD95SfGQYcxMwud02Bf97N/A06Yi1pbEC2YIUFSYMG7uR/h+uha5QHHftgcrQNFa3LhtatrPGWTiE1sns7DSUcIhGpMKIQbrBmEFAY8ubmAvtp9lipPfRMj/SsRrT2Y1d2BOPPbgCMy2ejIWbLcc5zJi6zRiblAqOaC6iZw5PM2s69JakJYc13m8tjywF0
 dvRd4zyy
 phqixJFje/MtWE5FL2i3ZBpu91eAGsPW3vhnmSJFvw9y/URJ82yMo5C25oDR8jWxmLJvrgvBffRi65UdTcu3YKZlAtulS0a9MOrEJXj0u9/ClNmt4bNXFR1oCTgoGvMdZeYROPkTSPZUvpm4sPdiAC/CT4Yd4fcED4aMMZZRWs/OI3MQ9vyM1l55Zn6g65Rk1z4lSSQLy5hHCVc1TWC9FOjCMTjOlNvg1TFQo6QBSMBsTTywHd4nhBIxacUaryWnrj/rhdaNDPm337Y+52jiWy+zPrDYZ12qwpJCXecyqycl5wh3qOMLTGeSBctouXJYP0f+sGj3i4bybz7wlWhHxC/EiUSOWwEKsd85ELUTcSf8E9z/xF0OoRTxLCa+V4UmfcHxV3NlxAhAYSDs6Jlse+1qf1ZIZekuLcy77acpATU4TKki9AuQ+Ps1dGAfpgImXD/AC+3ECBZZ16CHQt9qqcrOHmdH02pqM5SVKtBPie/zl2Jc0oW4DOeTJn06V+D+kLbyLnEiIb18eSFtknrtlBqQpV3IGa5H9kbomkpxAoOeMriA=
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
probe built with a perf_event prep is to be event driven, which the
sysfs patch that follows sets: DAMON does not walk it in the
apply_probes vtable; instead the PMU samples memory accesses and feeds
region hit counters through the report ring.

The prep also carries how many counters the PMU needs.  A per-CPU PMU is
armed by adding a cpuhp instance, which opens one kernel counter on every
online CPU.  A system-wide PMU is a single hardware unit served by exactly
one counter, so a single_instance flag opens one kernel counter pinned to
a fixed online CPU and bypasses the cpuhp fan-out.  The pin names an
online CPU because a kernel counter with no task must be bound to one.

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
context is destroyed.  Turning monitoring back on through sysfs builds
a fresh context, which arms a new event from the probe attributes.  The
teardown barrier the overflow handler pairs with, a release store of
event->ctx = NULL, covers the single-instance path as well as the per-CPU
one.  damon_perf_probe_teardown() also frees the event descriptor, which
the probe owns from the time the descriptor is attached to it.

__damon_commit_ctx() and damon_commit_probes() gain the commit_live flag
described above, false for the validation and test-context passes and
true for the real commit; its one existing kunit call site in
mm/damon/tests/core-kunit.h is updated to pass false.  Wiring these
attributes through sysfs is a separate, following commit.

Co-developed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h       |  29 ++++++++
 mm/damon/core.c             | 154 ++++++++++++++++++++++++++++++++++++++++---
 mm/damon/perf_source.c      | 157 +++++++++++++++++++++++++++++---------------
 mm/damon/perf_source.h      |  32 ++++++++-
 mm/damon/tests/core-kunit.h |   2 +-
 5 files changed, 310 insertions(+), 64 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b0895ef477ed..f84cdc583880 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -868,18 +868,44 @@ struct damon_intervals_goal {
  * enum damon_prep_action - DAMON probing preparation action.
  *
  * @DAMON_PREP_SET_PGIDLE:	Set the probing memory as idle page.
+ * @DAMON_PREP_PERF_EVENT:	Back the probe with a perf event.
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
+ * an event-driven probe: a kernel perf event (e.g. AMD IBS Op, Intel PEBS)
+ * samples memory accesses and feeds them into the probe hit counters via the
+ * report ring.  The @perf fields are copied into a perf_event_attr when the
+ * kdamond is turned on, or when a commit changes them.
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
@@ -934,10 +960,13 @@ struct damon_filter {
  * @weight:	Relative priority of the attribute for this probe.
  * @event_driven:	Whether the probe's hits arrive through the report ring
  *		drain rather than the apply_probes callback.
+ * @perf_priv:	Perf-event state of an event-driven probe, released by
+ *		damon_perf_probe_teardown().
  */
 struct damon_probe {
 	unsigned int weight;
 	bool event_driven;
+	void *perf_priv;
 /* private: */
 	/* Preparation actions to apply to each probing memory. */
 	struct list_head preps;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9fc536238c2f..c2acae6e19ec 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -18,6 +18,7 @@
 
 /* for damon_get_folio() used by node eligible memory metrics */
 #include "ops-common.h"
+#include "perf_source.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -285,6 +286,13 @@ struct damon_probe *damon_new_probe(void)
 	if (!p)
 		return NULL;
 	p->weight = 0;
+	p->event_driven = false;
+	/*
+	 * Must be NULL: damon_destroy_ctx() and damon_commit_probes() call
+	 * damon_perf_probe_teardown() for a probe whose perf_priv is set, so a
+	 * probe destroyed before it is ever armed must not carry garbage there.
+	 */
+	p->perf_priv = NULL;
 	INIT_LIST_HEAD(&p->preps);
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
@@ -1177,13 +1185,29 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
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
 
-	/* No-op if never allocated. */
+	/*
+	 * The probe loop above has released every perf event that reports into
+	 * the ring, so no overflow handler can still reach it.  No-op if never
+	 * allocated.
+	 */
 	damon_ctx_free_perf_ring(ctx);
 
 	/* Free the reusable ring-drain region snapshot buffers. */
@@ -2016,6 +2040,7 @@ static int damon_commit_targets(
 static void damon_commit_prep(struct damon_prep *dst, struct damon_prep *src)
 {
 	dst->action = src->action;
+	dst->perf = src->perf;
 }
 
 static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
@@ -2110,7 +2135,73 @@ static int damon_commit_filters(struct damon_probe *dst,
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
+ * @src->perf_priv carries the attributes @src was built with, unarmed;
+ * ownership of that descriptor moves to @dst here.
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
+	 * reorder with unchanged attrs must still be re-armed below, or
+	 * the event keeps crediting the probe_hits[] slot for its
+	 * old position instead of its new one.
+	 */
+	if (dst_ev && dst_ev->priv &&
+	    dst_ev->probe_idx == dst_idx + 1 &&
+	    !memcmp(&dst_ev->attr, &src_ev->attr, sizeof(dst_ev->attr)))
+		return 0;
+
+	/* Attrs or position changed, or dst not armed: re-arm from src. */
+	if (dst_ev) {
+		damon_perf_probe_teardown(ctx, dst_ev);
+		dst->perf_priv = NULL;
+	}
+	err = damon_perf_probe_setup(ctx, dst, src_ev);
+	if (err) {
+		/* a failed commit stops the kdamond, releasing the probes */
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
@@ -2119,13 +2210,29 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
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
@@ -2139,12 +2246,23 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
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
@@ -2242,7 +2360,8 @@ static int damon_commit_sample_control(
 	return damon_commit_sample_filters(dst, src);
 }
 
-static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src,
+		bool commit_live)
 {
 	int err;
 	struct damos *scheme;
@@ -2290,7 +2409,7 @@ static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;
-	err = damon_commit_probes(dst, src);
+	err = damon_commit_probes(dst, src, commit_live);
 	if (err)
 		return err;
 	err = damon_commit_sample_control(&dst->sample_control,
@@ -2312,7 +2431,7 @@ static struct damon_ctx *damon_new_test_ctx(struct damon_ctx *dst)
 	test_ctx = damon_new_ctx();
 	if (!test_ctx)
 		return NULL;
-	err = __damon_commit_ctx(test_ctx, dst);
+	err = __damon_commit_ctx(test_ctx, dst, false);
 	if (err) {
 		damon_destroy_ctx(test_ctx);
 		return NULL;
@@ -2341,10 +2460,10 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
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
@@ -2465,7 +2584,7 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 		if (!test_ctx)
 			return -ENOMEM;
 
-		err = __damon_commit_ctx(test_ctx, ctxs[i]);
+		err = __damon_commit_ctx(test_ctx, ctxs[i], false);
 		damon_destroy_ctx(test_ctx);
 		if (err)
 			return err;
@@ -4913,6 +5032,23 @@ static int kdamond_fn(void *data)
 done:
 	damon_destroy_targets(ctx);
 
+#ifdef CONFIG_DAMON_PERF_SOURCE
+	/*
+	 * Release perf-event probes here so a stopped kdamond leaves no event
+	 * firing overflows into its report ring, and holds no PMU ownership.
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
index 65bbfe850e70..4baa8aebcfa8 100644
--- a/mm/damon/perf_source.c
+++ b/mm/damon/perf_source.c
@@ -14,33 +14,17 @@
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
+	/* per-CPU probes (PEBS/IBS) */
 	struct perf_event * __percpu *event;
+	/* single-instance probes (system-wide PMU) */
+	struct perf_event *single_event;
 };
 
 static void damon_perf_overflow(struct perf_event *perf_event,
@@ -104,8 +88,7 @@ static enum cpuhp_state damon_perf_cpuhp_state;
 
 /*
  * Per-PMU exclusivity: each PMU type may be owned by at most one damon_ctx.
- * Multiple probes from the same ctx sharing a PMU type are allowed; a second
- * ctx attempting to grab a PMU type already owned returns -EBUSY.
+ * Multiple probes from the same ctx sharing a PMU type are allowed.
  */
 struct damon_pmu_owner {
 	struct list_head node;
@@ -224,7 +207,8 @@ int damon_perf_probe_setup(struct damon_ctx *ctx,
 	/*
 	 * Per-PMU exclusivity: find or create an owner slot for this PMU type.
 	 * Multiple probes from the same ctx sharing a PMU type are allowed;
-	 * a second ctx attempting the same PMU type returns -EBUSY.
+	 * a second ctx attempting the same PMU type returns -EBUSY.  A commit
+	 * that changes the perf attributes re-arms through this function too.
 	 */
 	spin_lock(&damon_pmu_owner_lock);
 	list_for_each_entry(owner, &damon_pmu_owner_list, node) {
@@ -285,12 +269,51 @@ int damon_perf_probe_setup(struct damon_ctx *ctx,
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
+	 * A kernel counter with no task must name a CPU.  If that CPU goes
+	 * offline the counter stops and is not migrated.
+	 */
+	if (event->attr.single_instance) {
+		struct perf_event_attr attr;
+		int cpu = cpumask_first(cpu_online_mask);
+
+		damon_perf_event_init_attr(event, &attr);
+		/*
+		 * Pass @event as the overflow context, as the per-CPU path
+		 * (damon_perf_cpu_online()) does: damon_perf_overflow() reads
+		 * event->ctx via smp_load_acquire() for the teardown barrier.
+		 */
+		perf->single_event = perf_event_create_kernel_counter(&attr,
+				cpu, NULL, damon_perf_overflow, event);
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
@@ -326,39 +349,67 @@ void damon_perf_probe_teardown(struct damon_ctx *ctx,
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
-			 * cannot observe and free the same owner.
+			 * Single-instance probe: no cpuhp instance was added,
+			 * so release the one counter.  disable() also quiesces
+			 * any pending overflow before the release.
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
+		list_for_each_entry_safe(owner, tmp, &damon_pmu_owner_list,
+						node) {
+			if (owner->pmu_type == event->attr.type &&
+			    atomic_long_read(&owner->owner_ctx) == (long)ctx) {
+				/*
+				 * Free under the lock so a concurrent same-PMU
+				 * teardown cannot observe and free the same
+				 * owner.
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
 
 static int __init damon_perf_source_init(void)
diff --git a/mm/damon/perf_source.h b/mm/damon/perf_source.h
index 8dcb128936ef..12ca61be7243 100644
--- a/mm/damon/perf_source.h
+++ b/mm/damon/perf_source.h
@@ -13,7 +13,37 @@
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
+	/* system-wide PMU: open one counter, not one per CPU */
+	bool single_instance;
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
+	/* 1-based probe index for probe_hits[]; set at registration */
+	int probe_idx;
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


