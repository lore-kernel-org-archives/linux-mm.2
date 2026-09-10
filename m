Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A913C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991C06B009F; Thu, 10 Sep 2026 13:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942286B00A0; Thu, 10 Sep 2026 13:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809D56B00A1; Thu, 10 Sep 2026 13:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 507996B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A13C80586
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:46 +0000 (UTC)
X-FDA: 85198507212.26.0B7D5C9
Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9C9C92000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ts0PCRyS;
	spf=pass (imf13.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOvHup9C0XaAXooEjdeLjZSBZK4fqqEBYQqdHWMr/Ls=;
	b=tJuzCqY9ZDR8K/PP+d96eNY89fPLB5QWDZF1uuD7kAzvofwQ4yCHta5UbKjhWkEbjimS26
	hQqrcZrufhrOPPvrFmnsVZJrQ+DvkrklVyLlU/UvtHyM5UK472ZSdhuG6rfoFr1+ExSYDy
	LBw9+XAUhS2XaU1ZbatlkI0xVc9ox5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060604;
	b=Ea83tInmuzovFM/3i+/ouKV32DXWjHi4aURN3n9vdN2vsLuNpFj7Ew4GWFbTd5ZGZlwn29
	YePJMb+BCmBw8L6DCroDlP2A2eq9R0GEFyMIru7GRs801Uhs3t0dffsP0Vg+tKSPQTwgJi
	qoW9KD7Y+TTfi4vQ7lGRvbkfKVRJNq4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ts0PCRyS;
	spf=pass (imf13.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-66f2399323dso2058500d50.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060604; x=1789665404; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xOvHup9C0XaAXooEjdeLjZSBZK4fqqEBYQqdHWMr/Ls=;
        b=Ts0PCRySC+kkt3VNGjAhg++hUuz4RrDC6Qn0MAWhF4XTZOab2dnJYAVbVjZQQ9I8ZG
         WiCB399IxJ1jcOPb2gsQst3bsiNCNLtPJzMjllMhLu8uqB+D67CDFi7cMdYdYzHJhDRu
         +n9x/rUf+jRkx5oCphnFyMvnE1HdvXTGIaA2I49L3ij3lJnrzwvyEx0b9eB97P7xSzJL
         IK4b9AKrTvM82mHYbKqFmTuqpPjHLEBVJUIIloL5EbJR4Huv6yJBY7OYONV0HRlaj5nM
         b3L1YW+AGr3tn1xPkPK8YmG31ykMziuc5kr6AfBq6GbMHmUp0vQEOeV2sl7lhMtiIXb/
         SuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060604; x=1789665404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xOvHup9C0XaAXooEjdeLjZSBZK4fqqEBYQqdHWMr/Ls=;
        b=JDuV2yCseVWD55Acc6ZBbvrKL/08dYepllzx3fNDtfy/wUvCMNyz2CH8LsUpChPVgN
         j/5QxP4MT/sipyxA7mJbq+gNBZ6f7XZs6UkxC+UO+D6mf4K9RUu+G1ZL/pZl253tuCCj
         QYd9QM3j6nubt6bE6viD499RIDbb7Z22ZutxBRTeMPu8wWaCu1Diw2a25DNoiJAodsSR
         SsLbv3qALJT6BGdSmrJS7akAbXjWQUF4Vyahjnv3Znp3poPqArcSUuGjAJW3rZIumEj4
         Sukt9eb7490v6sMfy0EzzAIrYMyfRkv2yqKIlGtVRCN/qt5HuIRYchbzRpxtcnE62ndi
         rV/w==
X-Forwarded-Encrypted: i=1; AKwUvBx98UrgY+Tjq5jjm0PZtilo48PiItxUEUINK2Xu0MtH7/KihtN4zYdOQd7ZCBEsk7NL1EHV1mQ4tA==@kvack.org
X-Gm-Message-State: AFuF++kyXhgQc2IjCdVpd1EJZhrViyReE8X7NDAd68G4+41DxLmNHHr/
	DWS5EaHuUMpc5bDEcmKi6uiTmv5lgywm1c7tOh9rfIoALkdjL1Rz70U=
X-Gm-Gg: AYBFou3gAS5L8zw5CVbPR0970l0Gyw9VK6c2dkEp/5/oKA1MDr1jdc8WVoW3LXHxlFs
	ltAj2Z0lfppy2caVslU/UddSWdT8BTGT6lhNRKfIzGkinwBvBCTtbPIw8avxkT8qyaPQzoe21h1
	eWC7/CqpQyUZEAGXnIxauuRLQN5h4qR4arsM/njMsrPZWWKBu3ln8UQgYR+dy38H3RWYcNc8CFo
	rwJfMkobMAJhfycN671VRmD0fljz5cl21PBkrPZZPJy0ZmP9c7faYHOl7UdtsmrK54CY3vtSWfU
	/ZA2dzBn2nxcPqLNE1oeB6MAAWswZkPYS4RnrU1jOTax0NOwuqVxpvG/YCDBupz7JjXZzHOMWK8
	6326SZeM60ueRXgRrdgwy7yI2G2lYo/CSDpGqmBVQgIQEExpG8QWoGcvx8XJWZaMulFd+gzZXaP
	2qRbNf9LoUykL71CT60aLa2PIHipwyhUIOAI4Y/djvnkEfjKVWPVIRjChJqWkIpxHTOsHIVb8AN
	5AHNfJvaujDLQQriBJ96A//nbH7i4IuJmM4YVH5BkcGoR1mrQ==
X-Received: by 2002:a05:690e:d48:b0:66f:c2fb:ecb with SMTP id 956f58d0204a3-671248cc3d3mr88848d50.41.1789060603254;
        Thu, 10 Sep 2026 10:16:43 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6711805f71esm1158123d50.17.2026.09.10.10.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:42 -0700 (PDT)
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
Subject: [RFC PATCH v2 8/9] mm/damon: add perf_event prep for PMU-driven hotness probes
Date: Thu, 10 Sep 2026 10:16:22 -0700
Message-ID: <20260910171623.6638-9-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bqrra6jot78prujogzgqjrye3ngfubgu
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C9C92000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789060604-113215
X-HE-Meta: U2FsdGVkX1893EMXBOAUAn5AGbuXZ5D1zErH1acGUVCrPzrJXp7utxM/7CHI1FjYBR71gqjBz00Ulg+IikP1yQlyPa949FhUnEn8kfHPxbGrLqgO0HbblBsHqhHNawyu54cVQ9pzilZDT0wmQ8BHYEIpVToU7dWnaZSM06e1M0am5ywkNTf0sjkccdgDztEiO4hn6bVPYIoLi1VHq1hY6ICK608zIlSednST8KzAzB8wSssqWCi2+kjxZFWVwDv05VsL5Umo2gj3CHwTR5FTPlFEwsQLDhpp/WW2W8L0MRxNBSShNLQV4kZQy7c1xLRvSoPfvS+qjXdjPqbqPEp/ziOWKRdM7V52kERcr1SSOV52r3+1DOzCBqiVf2kNmsFt8uLyo9MptI7FyQJ6uNOC2Y18Uv/7kmoiEwjPK3vevxDAbSShr7PhzhNV871nfs8wTlRk32P6v/8Rkbtk5W6ihE7BDTUsABn9bCaVsuYsTreFe7VFQX0NEWNz2l0+oux6hL0Q1PQeSUwSchCXoyu85z/A6+EYj98+VjuAOCuGuNRvn3VGl0ISkMF3BELfn5ndS6ouwhd+nhALfoXXw2TqWzuuoCq9blm19UxhDhwHzzvbJ4nGJJiSUsG0OJOo83jtf8l8VhlLVS3pvTnVHIy4VoabykKsBQ9xKZFKHag3DJuy+BvfrRO6Ho4C2ekLYW+PqYOgEVK2OMvHOYscETd94kVtWJLD7l7f3r7yWQBOC7Dk9qKpkFdgWsoWDwj9yEVMkS1FwkD6e/z/IcEPZ7PIEIstObGMXVvjllB+zV7XSfx+GkxqzkIsNRtIOI4SiK7n9uLCRXXq2JLPP/DutH/2Vzo0c8qo2DF0oqPnbELQPLOwGlEanJ2dYKc/6D9qV14XeFv+8swd6Crmoxy8kj80kqjkf5AB3z+UDL/atPEaZmiLE2kr87WAz7NlEsUKOA/SfaGI0UtQ/SXatXvs1mK
 EQgLswjF
 brOwX2lzu+S4o1JQSBmEPiPw9ZwpcWKvCNLmc2ZstFmew2+XjQSWQWGpv3l1e82kREG2nrqhZRAW14jbVE1ERUxMUUPrAQOy5irboGd/3HHre7kpCXeoOWOSB5a5WIDdgN+DongybN3iDKsl+EeNOVM4s9xBgeApa1kfQmLqkGuaKLiGhfpuSMEuxa5FrxangDrcAi4mZhwa5Wuqhe4nylQKdKNqFomJWZLEwVJJw6H4fuoxmEM+6/4OyGRFVRXrBB9GOJzxuh9OOIPIrzIJcLSzOA3oKnX195w52MenkZv5bsfsXwCsYUefHECDLI4mUuAy8e7PSn0PviOoFfaeCBlWvlvNSyXkH4suLCy72OMvXmNx2b7QSyKexyB8RtzEqBi3id+BzQAa9VK5OLlf1AiWZD9zHCyeV9eyE/hT7rQ58VY7TeROGbyMFFqZOlLFwfvpJoC6O9N3E0cx9z3iGuyoHjoNS/wegxcbP9UdQshDNrq9QCNjhfaOPOKL52BpfU83qN3QFn8/9A9yT+sZWOCikes4mmuXuXa8nO6b7fXfI5FhvrBNRU+U0geBnA2Pq7ozyaIDstEC6jx4=
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
include/linux/damon.h, mm/damon/perf_source.h, mm/damon/sysfs.c and
mm/damon/core.c.  A probe that has a perf_event prep is event driven:
DAMON does not walk it in the apply_probes vtable; instead the PMU samples
memory accesses and feeds region hit counters through the report ring.

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
re-arming only when the perf attributes change.

The armed event is released both when monitoring is turned off, from
kdamond_fn()'s exit path after damon_destroy_targets(), and when the
context is destroyed.  Both run outside NMI context, so a provider's
sleeping teardown is safe, and a later turn-on re-arms the event from the
carried probe attributes.  The teardown NMI barrier, an smp_store_release
of event->ctx = NULL, covers the single-instance and per-CPU paths alike;
the overflow handler reads its owning context with a matching
smp_load_acquire.

After this change user space can configure a PMU hotness probe entirely
through sysfs, for example:

  echo perf_event > .../probes/0/preps/0/prep_action
  echo 8          > .../probes/0/preps/0/type
  echo 0x100      > .../probes/0/preps/0/sample_period
  echo 1          > .../probes/0/preps/0/sample_phys_addr

Co-developed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h       |  29 ++++
 mm/damon/core.c             | 134 +++++++++++++++++-
 mm/damon/perf_source.c      | 195 ++++++++++++++++++--------
 mm/damon/perf_source.h      |  30 +++-
 mm/damon/sysfs.c            | 266 ++++++++++++++++++++++++++++++++++--
 mm/damon/tests/core-kunit.h |   2 +-
 6 files changed, 583 insertions(+), 73 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3147ce30951f5..feafe58b60b24 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -876,18 +876,45 @@ struct damon_intervals_goal {
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
index 6b3aa86386b76..37909420910e2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -18,6 +18,7 @@
 
 /* for damon_get_folio() used by node eligible memory metrics */
 #include "ops-common.h"
+#include "perf_source.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -345,6 +346,16 @@ struct damon_probe *damon_new_probe(void)
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
@@ -409,6 +420,8 @@ bool damon_has_probe_weights(struct damon_ctx *c)
  * Event-driven probes (e.g. perf-event IBS/PEBS) populate probe_hits[] via
  * the SPSC ring drain rather than the apply_probes vtable.  Callers use this
  * to decide whether to arm hardware sampling.
+ *
+ * @ctx: the DAMON context whose probes are inspected.
  */
 bool damon_has_event_driven_probes(struct damon_ctx *ctx)
 {
@@ -1216,8 +1229,20 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
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
@@ -2038,6 +2063,7 @@ static int damon_commit_targets(
 static void damon_commit_prep(struct damon_prep *dst, struct damon_prep *src)
 {
 	dst->action = src->action;
+	dst->perf = src->perf;
 }
 
 static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
@@ -2114,7 +2140,63 @@ static int damon_commit_filters(struct damon_probe *dst,
 	return 0;
 }
 
-static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
+#ifdef CONFIG_DAMON_PERF_SOURCE
+/*
+ * Hand off the armed perf event between a running probe (@dst, in the live
+ * @ctx) and the committed source probe (@src, from a discarded param_ctx that
+ * was built without arming).  Keeps the running event untouched when the perf
+ * attributes are unchanged (the common weight-only commit); otherwise tears
+ * down the old event and re-arms from @src's carried attributes.
+ *
+ * @src->perf_priv is built by the sysfs layer from @src's DAMON_PREP_PERF_EVENT
+ * prep before the commit; ownership of that descriptor moves to @dst here.
+ */
+static int damon_commit_perf_probe(struct damon_ctx *ctx,
+		struct damon_probe *dst, struct damon_probe *src)
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
+	/* Already armed with identical attrs: keep the running event. */
+	if (dst_ev && dst_ev->priv &&
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
@@ -2123,13 +2205,29 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
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
+							      src_probe);
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
@@ -2143,12 +2241,23 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
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
@@ -2293,7 +2402,7 @@ static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src,
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;
-	err = damon_commit_probes(dst, src);
+	err = damon_commit_probes(dst, src, commit_live);
 	if (err)
 		return err;
 	err = damon_commit_sample_control(&dst->sample_control,
@@ -5064,6 +5173,25 @@ static int kdamond_fn(void *data)
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
index 1102426152eca..e3c6783f45a54 100644
--- a/mm/damon/perf_source.c
+++ b/mm/damon/perf_source.c
@@ -14,49 +14,49 @@
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
 {
-	int probe_idx = (int)(unsigned long)perf_event->overflow_handler_context;
+	struct damon_perf_probe_event *event =
+		(struct damon_perf_probe_event *)perf_event->overflow_handler_context;
+	int probe_idx;
+	struct damon_ctx *ctx;
 	struct damon_access_report report = {
-		.probe_idx = probe_idx,
 		.size = PAGE_SIZE,
 		.cpu = smp_processor_id(),
 	};
 
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
 	/* probe_idx 0 is the zero-init sentinel; a valid index must be >= 1 */
 	if (WARN_ONCE(probe_idx == 0,
 		      "damon-perf: overflow handler called with probe_idx=0\n"))
@@ -94,8 +94,7 @@ static enum cpuhp_state damon_perf_cpuhp_state;
 
 /*
  * Per-PMU exclusivity: each PMU type may be owned by at most one damon_ctx.
- * Multiple probes from the same ctx sharing a PMU type are allowed; a second
- * ctx attempting to grab a PMU type already owned returns -EBUSY.
+ * Multiple probes from the same ctx sharing a PMU type are allowed.
  */
 struct damon_pmu_owner {
 	struct list_head node;
@@ -165,7 +164,7 @@ static int damon_perf_cpu_online(unsigned int cpu, struct hlist_node *node)
 
 	perf_event = perf_event_create_kernel_counter(&attr, cpu, NULL,
 						      damon_perf_overflow,
-						      (void *)(unsigned long)event->probe_idx);
+						      event);
 	if (IS_ERR(perf_event)) {
 		pr_warn_ratelimited("damon-perf: cpu %u event create failed: %ld\n",
 				    cpu, PTR_ERR(perf_event));
@@ -220,6 +219,10 @@ int damon_perf_probe_setup(struct damon_ctx *ctx,
 	 * Per-PMU exclusivity: find or create an owner slot for this PMU type.
 	 * Multiple probes from the same ctx sharing a PMU type are allowed;
 	 * a second ctx attempting the same PMU type returns -EBUSY.
+	 *
+	 * NOTE: damon_commit_perf_probe() updates perf_event parameters
+	 * in-place and never calls damon_perf_probe_setup(), so the owner
+	 * table is never touched on the commit path.
 	 */
 	spin_lock(&damon_pmu_owner_lock);
 	list_for_each_entry(owner, &damon_pmu_owner_list, node) {
@@ -271,16 +274,69 @@ int damon_perf_probe_setup(struct damon_ctx *ctx,
 		goto release_owner;
 	}
 	event->probe_idx = idx + 1;	/* 1-based; 0 is reserved sentinel */
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
@@ -310,44 +366,75 @@ EXPORT_SYMBOL_GPL(damon_perf_probe_setup);
 
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
+			/*
+			 * Single-instance probe: no cpuhp instance was added, so
+			 * just release the one counter (process context here, so
+			 * disable+release is safe).  disable() also quiesces any
+			 * pending overflow before release.
+			 */
+			perf_event_disable(perf->single_event);
+			perf_event_release_kernel(perf->single_event);
+			perf->single_event = NULL;
+		} else {
 			/*
-			 * Free under the lock so a concurrent same-PMU teardown
-			 * cannot observe and free the same owner. kfree() under
-			 * a non-irq spinlock in process context is safe.
+			 * cpuhp_state_remove_instance() disables+releases each
+			 * CPU's perf event; once it returns no new overflow can
+			 * be delivered for this event.
 			 */
-			if (atomic_dec_and_test(&owner->refcount)) {
-				list_del(&owner->node);
-				kfree(owner);
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
index 5de55a29785f4..f2dec17a5e026 100644
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
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 768b6b49f0b0f..54ab3bbe8cdbb 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 
 #include "sysfs-common.h"
+#include "perf_source.h"
 
 /*
  * init region directory
@@ -756,6 +757,21 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 struct damon_sysfs_prep {
 	struct kobject kobj;
 	enum damon_prep_action action;
+	/* perf_event_attr subset; valid when action == DAMON_PREP_PERF_EVENT */
+	u32 perf_type;
+	u64 config;
+	u64 config1;
+	u64 config2;
+	u64 sample_period;
+	u64 sample_freq;
+	u32 wakeup_events;
+	u32 precise_ip;
+	bool sample_phys_addr;
+	bool sample_weight_struct;
+	bool exclude_kernel;
+	bool exclude_hv;
+	bool freq;
+	bool single_instance;
 };
 
 static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
@@ -780,6 +796,10 @@ damon_sysfs_prep_action_names[] = {
 		.action = DAMON_PREP_SET_PGIDLE,
 		.name = "set_pgidle",
 	},
+	{
+		.action = DAMON_PREP_PERF_EVENT,
+		.name = "perf_event",
+	},
 };
 
 static ssize_t avail_prep_actions_show(struct kobject *kobj,
@@ -852,9 +872,123 @@ static struct kobj_attribute damon_sysfs_prep_avail_prep_actions_attr =
 static struct kobj_attribute damon_sysfs_prep_prep_action_attr =
 		__ATTR_RW_MODE(prep_action, 0600);
 
+/*
+ * perf_event configuration attributes.  These mirror a subset of
+ * perf_event_attr and are only meaningful when prep_action is "perf_event".
+ * They select the PMU (via type/config) and its sampling parameters, and are
+ * copied into the perf-event probe when the kdamond is turned on.
+ *
+ * The sysfs file names stay bare (type, config, ...) while the backing C
+ * symbols are prefixed to avoid clashing with identically named attributes
+ * elsewhere in this file.
+ */
+#define DAMON_SYSFS_PREP_PERF_U32(name, field)				\
+static ssize_t damon_sysfs_prep_##name##_show(struct kobject *kobj,	\
+		struct kobj_attribute *attr, char *buf)			\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	return sysfs_emit(buf, "%u\n", prep->field);			\
+}									\
+static ssize_t damon_sysfs_prep_##name##_store(struct kobject *kobj,	\
+		struct kobj_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	u32 v;								\
+	int err = kstrtou32(buf, 0, &v);				\
+	if (err)							\
+		return err;						\
+	prep->field = v;						\
+	return count;							\
+}									\
+static struct kobj_attribute damon_sysfs_prep_##name##_attr = __ATTR(name, \
+		0600, damon_sysfs_prep_##name##_show,			\
+		damon_sysfs_prep_##name##_store)
+
+#define DAMON_SYSFS_PREP_PERF_U64(name, field)				\
+static ssize_t damon_sysfs_prep_##name##_show(struct kobject *kobj,	\
+		struct kobj_attribute *attr, char *buf)			\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	return sysfs_emit(buf, "%llu\n", prep->field);			\
+}									\
+static ssize_t damon_sysfs_prep_##name##_store(struct kobject *kobj,	\
+		struct kobj_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	u64 v;								\
+	int err = kstrtou64(buf, 0, &v);				\
+	if (err)							\
+		return err;						\
+	prep->field = v;						\
+	return count;							\
+}									\
+static struct kobj_attribute damon_sysfs_prep_##name##_attr = __ATTR(name, \
+		0600, damon_sysfs_prep_##name##_show,			\
+		damon_sysfs_prep_##name##_store)
+
+#define DAMON_SYSFS_PREP_PERF_BOOL(name, field)				\
+static ssize_t damon_sysfs_prep_##name##_show(struct kobject *kobj,	\
+		struct kobj_attribute *attr, char *buf)			\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	return sysfs_emit(buf, "%u\n", prep->field);			\
+}									\
+static ssize_t damon_sysfs_prep_##name##_store(struct kobject *kobj,	\
+		struct kobj_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct damon_sysfs_prep *prep = container_of(kobj,		\
+			struct damon_sysfs_prep, kobj);			\
+	bool v;								\
+	int err = kstrtobool(buf, &v);					\
+	if (err)							\
+		return err;						\
+	prep->field = v;						\
+	return count;							\
+}									\
+static struct kobj_attribute damon_sysfs_prep_##name##_attr = __ATTR(name, \
+		0600, damon_sysfs_prep_##name##_show,			\
+		damon_sysfs_prep_##name##_store)
+
+DAMON_SYSFS_PREP_PERF_U32(type, perf_type);
+DAMON_SYSFS_PREP_PERF_U64(config, config);
+DAMON_SYSFS_PREP_PERF_U64(config1, config1);
+DAMON_SYSFS_PREP_PERF_U64(config2, config2);
+DAMON_SYSFS_PREP_PERF_U64(sample_period, sample_period);
+DAMON_SYSFS_PREP_PERF_U64(sample_freq, sample_freq);
+DAMON_SYSFS_PREP_PERF_U32(wakeup_events, wakeup_events);
+DAMON_SYSFS_PREP_PERF_U32(precise_ip, precise_ip);
+DAMON_SYSFS_PREP_PERF_BOOL(sample_phys_addr, sample_phys_addr);
+DAMON_SYSFS_PREP_PERF_BOOL(sample_weight_struct, sample_weight_struct);
+DAMON_SYSFS_PREP_PERF_BOOL(exclude_kernel, exclude_kernel);
+DAMON_SYSFS_PREP_PERF_BOOL(exclude_hv, exclude_hv);
+DAMON_SYSFS_PREP_PERF_BOOL(freq, freq);
+DAMON_SYSFS_PREP_PERF_BOOL(single_instance, single_instance);
+
 static struct attribute *damon_sysfs_prep_attrs[] = {
 	&damon_sysfs_prep_avail_prep_actions_attr.attr,
 	&damon_sysfs_prep_prep_action_attr.attr,
+	&damon_sysfs_prep_type_attr.attr,
+	&damon_sysfs_prep_config_attr.attr,
+	&damon_sysfs_prep_config1_attr.attr,
+	&damon_sysfs_prep_config2_attr.attr,
+	&damon_sysfs_prep_sample_period_attr.attr,
+	&damon_sysfs_prep_sample_freq_attr.attr,
+	&damon_sysfs_prep_wakeup_events_attr.attr,
+	&damon_sysfs_prep_precise_ip_attr.attr,
+	&damon_sysfs_prep_sample_phys_addr_attr.attr,
+	&damon_sysfs_prep_sample_weight_struct_attr.attr,
+	&damon_sysfs_prep_exclude_kernel_attr.attr,
+	&damon_sysfs_prep_exclude_hv_attr.attr,
+	&damon_sysfs_prep_freq_attr.attr,
+	&damon_sysfs_prep_single_instance_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_prep);
@@ -2252,9 +2386,40 @@ static int damon_sysfs_set_preps(struct damon_probe *probe,
 		struct damon_sysfs_prep *sys_prep = sys_preps->preps_arr[i];
 		struct damon_prep *prep;
 
+		/*
+		 * period and freq are mutually exclusive perf sampling modes;
+		 * reject a config that sets both before it can arm a counter.
+		 */
+		if (sys_prep->action == DAMON_PREP_PERF_EVENT &&
+		    sys_prep->sample_period && sys_prep->sample_freq)
+			return -EINVAL;
+
 		prep = damon_new_prep(sys_prep->action);
 		if (!prep)
 			return -ENOMEM;
+		if (sys_prep->action == DAMON_PREP_PERF_EVENT) {
+			/*
+			 * damon_new_prep() does not zero prep->perf; clear it
+			 * so any field not assigned below starts from a known
+			 * zero rather than kmalloc garbage.
+			 */
+			memset(&prep->perf, 0, sizeof(prep->perf));
+			prep->perf.type = sys_prep->perf_type;
+			prep->perf.config = sys_prep->config;
+			prep->perf.config1 = sys_prep->config1;
+			prep->perf.config2 = sys_prep->config2;
+			prep->perf.sample_period = sys_prep->sample_period;
+			prep->perf.sample_freq = sys_prep->sample_freq;
+			prep->perf.wakeup_events = sys_prep->wakeup_events;
+			prep->perf.precise_ip = sys_prep->precise_ip;
+			prep->perf.sample_phys_addr = sys_prep->sample_phys_addr;
+			prep->perf.sample_weight_struct =
+				sys_prep->sample_weight_struct;
+			prep->perf.exclude_kernel = sys_prep->exclude_kernel;
+			prep->perf.exclude_hv = sys_prep->exclude_hv;
+			prep->perf.freq = sys_prep->freq;
+			prep->perf.single_instance = sys_prep->single_instance;
+		}
 		damon_add_prep(probe, prep);
 	}
 	return 0;
@@ -2291,8 +2456,71 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
 	return 0;
 }
 
-static int damon_sysfs_set_probe(struct damon_probe *probe,
-		struct damon_sysfs_probe *sys_probe)
+#ifdef CONFIG_DAMON_PERF_SOURCE
+/*
+ * Build a perf-event probe descriptor from the probe's DAMON_PREP_PERF_EVENT
+ * prep and attach it to @probe.  The descriptor is always carried (so the ring
+ * drain and the commit hand-off recognise the probe as event-driven), but the
+ * PMU counters are only armed when @arm is set.
+ *
+ * @arm is true when building the context that will actually run (turn-on
+ * path); it is false when building a param_ctx for a commit, which is
+ * discarded after validation.  Arming a param_ctx would collide with the
+ * running context's perf-probe ownership and return -EBUSY, so the commit path
+ * defers arming to damon_commit_perf_probe().
+ */
+static int damon_sysfs_set_perf_probe(struct damon_ctx *ctx,
+		struct damon_probe *probe, bool arm)
+{
+	struct damon_prep *prep;
+
+	damon_for_each_prep(prep, probe) {
+		struct damon_perf_probe_event *event;
+		int err;
+
+		if (prep->action != DAMON_PREP_PERF_EVENT)
+			continue;
+
+		event = kzalloc_obj(*event, GFP_KERNEL);
+		if (!event)
+			return -ENOMEM;
+		event->attr.type = prep->perf.type;
+		event->attr.config = prep->perf.config;
+		event->attr.config1 = prep->perf.config1;
+		event->attr.config2 = prep->perf.config2;
+		event->attr.sample_period = prep->perf.sample_period;
+		event->attr.sample_freq = prep->perf.sample_freq;
+		event->attr.wakeup_events = prep->perf.wakeup_events;
+		event->attr.precise_ip = prep->perf.precise_ip;
+		event->attr.sample_phys_addr = prep->perf.sample_phys_addr;
+		event->attr.sample_weight_struct =
+			prep->perf.sample_weight_struct;
+		event->attr.exclude_kernel = prep->perf.exclude_kernel;
+		event->attr.exclude_hv = prep->perf.exclude_hv;
+		event->attr.freq = prep->perf.freq;
+		event->attr.single_instance = prep->perf.single_instance;
+
+		probe->perf_priv = event;
+		probe->event_driven = true;
+		if (arm) {
+			err = damon_perf_probe_setup(ctx, probe, event);
+			if (err) {
+				probe->perf_priv = NULL;
+				probe->event_driven = false;
+				kfree(event);
+				return err;
+			}
+		}
+		/* At most one perf-event prep per probe. */
+		break;
+	}
+	return 0;
+}
+#endif /* CONFIG_DAMON_PERF_SOURCE */
+
+static int damon_sysfs_set_probe(struct damon_ctx *ctx,
+		struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe, bool arm)
 {
 	struct damon_sysfs_filters *sys_filters;
 	struct damon_sysfs_preps *sys_preps;
@@ -2305,13 +2533,21 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 			return err;
 	}
 	sys_filters = sys_probe->filters;
-	if (!sys_filters)
-		return 0;
-	return damon_sysfs_set_filters(probe, sys_filters);
+	if (sys_filters) {
+		err = damon_sysfs_set_filters(probe, sys_filters);
+		if (err)
+			return err;
+	}
+#ifdef CONFIG_DAMON_PERF_SOURCE
+	err = damon_sysfs_set_perf_probe(ctx, probe, arm);
+	if (err)
+		return err;
+#endif
+	return 0;
 }
 
 static int damon_sysfs_set_probes(struct damon_ctx *ctx,
-		struct damon_sysfs_probes *sys_probes)
+		struct damon_sysfs_probes *sys_probes, bool arm)
 {
 	int i, err;
 
@@ -2325,9 +2561,10 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 		damon_add_probe(ctx, p);
 		sys_probe = sys_probes->probes_arr[i];
 		p->weight = sys_probe->weight;
-		err = damon_sysfs_set_probe(p, sys_probe);
+		err = damon_sysfs_set_probe(ctx, p, sys_probe, arm);
 		if (err)
 			return err;
+
 	}
 	return 0;
 }
@@ -2426,7 +2663,7 @@ static inline bool damon_sysfs_kdamond_running(
 }
 
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
-		struct damon_sysfs_context *sys_ctx)
+		struct damon_sysfs_context *sys_ctx, bool arm)
 {
 	enum damon_ops_id ops_id;
 	int err;
@@ -2444,7 +2681,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes, arm);
 	if (err)
 		return err;
 	err = damon_sysfs_set_sample_control(&ctx->sample_control,
@@ -2458,7 +2695,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 }
 
 static struct damon_ctx *damon_sysfs_build_ctx(
-		struct damon_sysfs_context *sys_ctx);
+		struct damon_sysfs_context *sys_ctx, bool arm);
 
 /*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
@@ -2478,7 +2715,8 @@ static int damon_sysfs_commit_input(void *data)
 	if (kdamond->contexts->nr != 1)
 		return -EINVAL;
 
-	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
+	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0],
+			false);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
@@ -2536,7 +2774,7 @@ static int damon_sysfs_upd_tuned_intervals(void *data)
 }
 
 static struct damon_ctx *damon_sysfs_build_ctx(
-		struct damon_sysfs_context *sys_ctx)
+		struct damon_sysfs_context *sys_ctx, bool arm)
 {
 	struct damon_ctx *ctx = damon_new_ctx();
 	int err;
@@ -2544,7 +2782,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
+	err = damon_sysfs_apply_inputs(ctx, sys_ctx, arm);
 	if (err) {
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
@@ -2596,7 +2834,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	if (!repeat_call_control)
 		return -ENOMEM;
 
-	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
+	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0], true);
 	if (IS_ERR(ctx)) {
 		kfree(repeat_call_control);
 		return PTR_ERR(ctx);
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9ed182ff38804..78c2cb145edce 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1477,7 +1477,7 @@ static void damon_test_commit_probes_for(struct kunit *test,
 		kunit_skip(test, "src alloc fail");
 	}
 
-	err = damon_commit_probes(dst, src);
+	err = damon_commit_probes(dst, src, false);
 	KUNIT_EXPECT_EQ(test, err, 0);
 	if (err)
 		goto out;
-- 
2.43.0


