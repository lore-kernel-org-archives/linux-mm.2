Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D6FCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7736B00C9; Fri, 29 May 2026 12:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE2B6B00CC; Fri, 29 May 2026 12:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3956B00CD; Fri, 29 May 2026 12:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34C476B00C9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:57:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA6888C520
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:12 +0000 (UTC)
X-FDA: 84821062704.24.E85A794
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11E4CC0017
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oIxvKHZL;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4H/yIMAbtX2q0bElVklgb86re8LM0PVikJCfYxPTsWQ=;
	b=XWT23g6EbUEJlCC/6lf+zOM2gimZG49wvFDW2FDqe6JMOOX3R/3yDH+Wp0DgoPlwMjgumc
	GbC6kczwUs5J/x7nqWiuyHQojp5r1u2UrSM/1WApESG1psx77Yv4xG+c4I8hn/C+PLGwPO
	cp1haR0ZP4ltOO2eMHdXzjiSS8E8A28=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oIxvKHZL;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073831; a=rsa-sha256;
	cv=none;
	b=4jjxsuGGPiAD9u1xePYR4bjVXmeohObSjynsq8mjmeOqQ5Cy+pyabOtq/y2pIuLmBarK5n
	HrX8BWWuWRCZT6n9PF5iXfKfcKGOBgSHsO718DgExH5G5rWSYDEmO1UY3fF6TZ6YizjhzG
	rnJCPms511aMJb089qKI5lde871xAlQ=
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7e61f8d3cbfso3479896a34.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 09:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780073830; x=1780678630; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4H/yIMAbtX2q0bElVklgb86re8LM0PVikJCfYxPTsWQ=;
        b=oIxvKHZLNWHKPGH1vEVvBo4yVah6Q8nHcFAPaw1dH8h1nHsQf9NHqrc328PVz5Vf8v
         WMMRVoV7liBTO4BlQ8seNvMko1ts15vDRNa1Je4r5WQwebdeyLzOZSCRN9dP4tGrurcI
         U/UxyRpszPHuLLbzFfTCBASFx/oMkkiHT6E0kpSK4vTCCfyW0ahy6P2gaiIdtd1ZW8j+
         apPL1HaiQD5vUfnT4p0RNYs+JSFUlZNsei8YvZDN/9mjkW2/tiWcMFjq328IXDE/OKuM
         VBUJ2ndSRXUSFEQLB6TuadVmu8l4hBd/qM9wM0TxkK13bvv/Gmqce3EtMgn/+H02YW50
         RLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780073830; x=1780678630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4H/yIMAbtX2q0bElVklgb86re8LM0PVikJCfYxPTsWQ=;
        b=cKoFfnC2hGzAYRqqHelQCOeELgM/hXf0/pnaTaXst66H82llBZcTvJtSPz/qFHC3bA
         4kAx921UeKV6oRtDf0AW8QzQ3RO0QCHoviZrKUoCuzlWc/3VSOt6vUfCTTTzP66N/aso
         WgunTvdlRU8QChvdjXAK2WjlPrUpoM+l1QQrC6CVs5rTxVXW+K7XbDE8/vpWG5VQHjAw
         R1V+YdpJpk5AjEtbEXrMVELwsU5LC4zhlAMKTEXNAbYAW9DsczPLnwCiapOCfkzSYpXC
         pJXIcww41mRw2x0vUwEZNOekNtGxrdO/kqAO4pHyCNWW0HpOdhFPxifrUUjqD05RM0Tm
         HFqQ==
X-Forwarded-Encrypted: i=1; AFNElJ8J//3riXEO1ugW2rj/YXawJJrVt2tWTDJk5eKtvHrO5GlndyE1blCB2f3Ppe/f2O6py5hg09ue0w==@kvack.org
X-Gm-Message-State: AOJu0YzpazDHW/ax+Y0+y/egtdUApNGlrKVje+QQRJ3yONudRbza+AuP
	h9Yr/IF4QoFoUZj4NN4pW87dgiP7pZus9+PStKlYXLrMBfH5b4ksijY=
X-Gm-Gg: Acq92OFcKP+N7SnI+55EoVpup9LgZRuaHF0g/Cq38iUKT2yHV/JsNSjDmd/lgoTqhkJ
	v34z/d9MR1n4MTzAxMYjogBmBJDwEErzLFXiBaUK3VY1T05iqz3R34VwfKChCoNtQ6qMWZNPuBs
	VzaXPQThu63b/DKgl8fAOFHmN94P7lETvJw2cUQ9kMixQcl9HXjgJefhA49Ce4jt+DmSkyr2XW1
	QvG/A1+VzfWjRsaDDufKnL6lU+lDgkbgiukP27dzTr4vj89O0PfWWb33LufAUR2GWH0mzvLqX6H
	8IW5R8fWQ7gi5tDcUH04by3VcJYyfaOnTa4/ZAxgcrEO/wYMiIly2fFAPdvto2cgmdKwKNQ+anw
	J/uTjpL4aNFZDptsWq3n2+/J6VNT/KvLh4QKHj/suAmf146hbD7BKJX7WvFOOr1A0I//syIKp54
	g98asWGIz94CV3yg+IQ2hDRZAKQ4DkDOw5/9uAfw6RGw8Js66DhlafDygwd6kKOmkRPA70WeXuH
	SS7qU9zTgtP
X-Received: by 2002:a05:6830:348a:b0:7dc:cd0b:58ba with SMTP id 46e09a7af769-7e6a1d33c27mr359547a34.4.1780073830039;
        Fri, 29 May 2026 09:57:10 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695da86e1sm1785786a34.27.2026.05.29.09.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:57:09 -0700 (PDT)
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
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 5/6] mm/damon/vaddr: implement perf-event access check
Date: Fri, 29 May 2026 09:56:39 -0700
Message-ID: <20260529165640.820-6-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260529165640.820-1-ravis.opensrc@gmail.com>
References: <20260529165640.820-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11E4CC0017
X-Stat-Signature: suktpzptefq8ojrp58gg955tz1459pj1
X-HE-Tag: 1780073830-775097
X-HE-Meta: U2FsdGVkX1+4lfQ938lt4yuVaM60J4+c565sg8kazLfdZ15+kHaWb064trWcB6fhfxb0vofkhDPowtCFYSx200DsS+YnfV5/+44QAV5Aq4FdM6+tWthRoFo/44nl0RUXXiipEkPjujkujZb0Lk6sQDG36daIwIhxdILdXXnBF/NSImYuV77Qz/VCMyvEylSDkV9zOUpzAYV+HKtVz/IcBHZ79SApZRnV6pfGILh6RAuQLsyeNRwEt5d1CjV/IxaruQffMW1Vf/k8ITsKYRm5PEbEq6ndRX8oBRpjv5OtkQoe4HCmHruRXHh2vYn8IjrlKKD4X1vynH6Vls1dGizkepoSUClw8wcnVTZwxN2nHzSTGzr6RXZ9Pvy4unqYpxrVYpLSP2muuSbgT2WAHn49z7RhaRsQOLf33kfYClHFAyrId+qrFFSxt33ysuRXY4eKbSd3cjawYGTHLuvHNPbVwGUQZnyb1YB6tBvJ46/S7c6X+w+J0cZloCkia8RxWG/uK+k2yWO0eQff+W2aCSRoxwT7M1a7FFqrIM5qs9YlA5ynUndkV9xqNmqwDBCDx02njq11lPESs96PebQrcDA0opPllhM6jQ2mt/Vd6eR5TVZQ1pVhR9WVdAAG5aypA9qFA6NAPd9xr5tbf7cv778stFyJKZKYekpFrE1ojAgbpqvCS1CZAzujupFrhVs0ki3JqpB38VNzE2BKY/73SCtibZwFARDG4sM/FIUq09SBN8Nr2v7uAAG9h3J6LqYj1gNH0gkMfvj2Mq7udRY6BOJfA5qG7kY+4mmu5YuXrOEJZ2cFG1S61Oq0vFDSR39F1WDSj9Q4ckOnLSMAGe5cqRNAbplThEaIaUCkKzhF6Kef8TD9X5Apf8CRlG9BR2YuidMEUMGIqkJfRJH7tAZfSeP8xbBj0oxcQSbEYFQly3n5bGkCHrbA1uE/+GcuE16MNybhi61WHs7qS48SVjU6JOz
 rAImin09
 T9xz+kQNwuG4rEVNTiiMbkoICC5EtzKdDJTG3cZkgVbMI8/V7nU0zSE2W59R2DpwPWzYTr/ZEAIG9H+AJrIikl5Wch8xFEEa9wFKlEHf+JSk3exp7OZnD6eppCXGVuuwLKVYoWSW+6dgGg/6VMw9cw4WsxZGMfWdzXfB754ubnCh/75GxEig8PAQBAzSOWJrl1CgjhjAUMXKDUtxbHS8Ussue8Gv6OhXrXvOJYATlzH8EZL8t4LBF69AwvA5CWX/W3KT2h2maJkHa8bEQvrtZ6SodCqoKhmllJc4VLiZj2d/Nu2HJ7FBplk71g3yHWeAbWMSSLQj6a3LxftMJuDZ/m3pobZEOdSJ3fxjYculrcbR1fcXEjNYZmus0yQLkeSteLb1aHGsScQozVTQmixEBZAksgzjZuCuWuWoP0NwCUN3Hf0CWx+4dwaJLk6Z6D/7R9c9M9TxTRhvTvVUc8e2SHtS2BDSn0cAEB4uN/ZzdJED6EnWoqeLcXImWFAsXox8HC2BgrNW3eAbZRSLh1ybocITCm680AXRbjrJTAbhgZE746+yNBo/BZaRPZOoKKLKVAPRMoSw5wMoDU4hxaP0dxSH6osE17BLtzV11N3v6rsYzwRTpDYn94FGdg/JBxgrZ9rXHD+X4n2xBW7i7/77glhQE7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the perf-event backend used by the substrate.  Two stateless NMI
overflow handlers are picked at perf_event_create_kernel_counter()
time (paddr- vs vaddr-keyed) and called with context = NULL, so the
NMI fast path never dereferences the per-event struct.  Each submits
a damon_access_report into the per-CPU ring.

The vaddr handler drops samples with addr == 0 or addr >= TASK_SIZE.
The paddr handler gates on data->sample_flags & PERF_SAMPLE_PHYS_ADDR
rather than testing data->phys_addr for zero (which would also drop
legitimate page 0).  AMD IBS Op only populates phys_addr when
IBS_OP_DATA3.dc_phy_addr_valid is set; gating on sample_flags is the
documented way to detect that.  is_write is derived from
data->data_src.mem_op.

cpuhp_setup_state_multi() registers one global state at subsys_initcall;
each damon_perf_event is added as an instance in damon_perf_init() so
cpuhp drives per-CPU event creation and offline-time release.  Events
are created with disabled=1 and armed by kdamond_fn() when the
substrate is ready; per-CPU init failures are surfaced via
init_complete / any_cpu_failed so damon_perf_init() rolls back the
cpuhp instance instead of leaving a half-armed event behind.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/vaddr.c | 267 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 267 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d271476035641..73fcea91afa07 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -7,11 +7,13 @@
 
 #define pr_fmt(fmt) "damon-va: " fmt
 
+#include <linux/cpuhotplug.h>
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
+#include <linux/perf_event.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
 
@@ -957,6 +959,263 @@ static int damon_va_scheme_score(struct damon_ctx *context,
 	return DAMOS_MAX_SCORE;
 }
 
+#ifdef CONFIG_PERF_EVENTS
+
+#define DAMON_PERF_MAX_RECORDS	(1UL << 20)
+#define DAMON_PERF_INIT_RECORDS	(1UL << 15)
+
+/*
+ * NMI hot-path: avoid every heap dereference.  These handlers carry no
+ * pointer back to the per-event struct -- perf_event_create_kernel_counter
+ * is called with context = NULL.  Submission flows into the global
+ * per-CPU SPSC ring (damon_report_access -> kdamond_check_reported_accesses
+ * drains).
+ */
+static void damon_perf_overflow_vaddr(struct perf_event *perf_event,
+		struct perf_sample_data *data, struct pt_regs *regs)
+{
+	struct damon_access_report report;
+
+	if (!data || !data->addr)
+		return;
+
+	/* Drop kernel-VA hits -- only user-space VAs land in damon vaddr regions. */
+	if (data->addr >= TASK_SIZE)
+		return;
+
+	report = (struct damon_access_report){
+		.vaddr = data->addr & PAGE_MASK,
+		.size = PAGE_SIZE,
+		.cpu = smp_processor_id(),
+		.tid = current->pid,
+		.tgid = current->tgid,
+		.is_write = !!(data->data_src.mem_op & PERF_MEM_OP_STORE),
+	};
+	damon_report_access(&report);
+}
+
+static void damon_perf_overflow_paddr(struct perf_event *perf_event,
+		struct perf_sample_data *data, struct pt_regs *regs)
+{
+	struct damon_access_report report;
+
+	if (!data)
+		return;
+
+	/*
+	 * AMD IBS Op only populates data->phys_addr when
+	 * IBS_OP_DATA3.dc_phy_addr_valid is set; otherwise the field
+	 * carries a stale value.  Gate on sample_flags rather than testing
+	 * phys_addr for zero (which would also drop legitimate page 0).
+	 */
+	if (!(data->sample_flags & PERF_SAMPLE_PHYS_ADDR))
+		return;
+
+	report = (struct damon_access_report){
+		.paddr = data->phys_addr & PAGE_MASK,
+		.size = PAGE_SIZE,
+		.cpu = smp_processor_id(),
+		.is_write = !!(data->data_src.mem_op & PERF_MEM_OP_STORE),
+	};
+	damon_report_access(&report);
+}
+
+static enum cpuhp_state damon_perf_cpuhp_state;
+
+static void damon_perf_event_init_attr(struct damon_perf_event *event,
+		struct perf_event_attr *attr)
+{
+	*attr = (struct perf_event_attr) {
+		.size = sizeof(*attr),
+		.type = event->attr.type,
+		.config = event->attr.config,
+		.config1 = event->attr.config1,
+		.config2 = event->attr.config2,
+		.freq = event->attr.freq,
+		.sample_type = PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR |
+			PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC |
+			(event->attr.sample_phys_addr ?
+				PERF_SAMPLE_PHYS_ADDR : 0) |
+			(event->attr.sample_weight_struct ?
+				PERF_SAMPLE_WEIGHT_STRUCT : 0),
+		.precise_ip = event->attr.precise_ip,
+		.pinned = 1,
+		.disabled = 1,
+		.wakeup_events = event->attr.wakeup_events,
+		.exclude_kernel = event->attr.exclude_kernel,
+		.exclude_hv = event->attr.exclude_hv,
+	};
+
+	/*
+	 * sample_period and sample_freq share storage in the kernel
+	 * perf_event_attr (union).  Select based on the freq toggle so
+	 * frequency-based callers (PEBS) and period-based callers
+	 * (AMD IBS Op MaxCnt) both work correctly.
+	 */
+	if (event->attr.freq)
+		attr->sample_freq = event->attr.sample_freq;
+	else
+		attr->sample_period = event->attr.sample_period;
+}
+
+static int damon_perf_cpu_online(unsigned int cpu, struct hlist_node *node)
+{
+	struct damon_perf_event *event = hlist_entry(node,
+			struct damon_perf_event, hlist_node);
+	struct damon_perf *perf = event->priv;
+	struct perf_event_attr attr;
+	struct perf_event *perf_event;
+	perf_overflow_handler_t handler;
+
+	if (!perf)
+		return 0;
+
+	damon_perf_event_init_attr(event, &attr);
+
+	/*
+	 * Pick a paddr- or vaddr-specific handler at create time so the
+	 * NMI fast path is statically branched.  Pass NULL as context --
+	 * handlers are stateless wrt the per-event struct, so the NMI
+	 * fast path performs no per-event heap dereference.  Submission
+	 * flows into the global per-CPU SPSC ring via damon_report_access().
+	 */
+	handler = event->attr.sample_phys_addr ?
+		damon_perf_overflow_paddr : damon_perf_overflow_vaddr;
+
+	perf_event = perf_event_create_kernel_counter(&attr, cpu, NULL,
+			handler, NULL);
+	if (IS_ERR(perf_event)) {
+		pr_warn_ratelimited("damon-perf: cpu %u event create failed: %ld\n",
+				cpu, PTR_ERR(perf_event));
+		if (!event->init_complete)
+			event->any_cpu_failed = true;
+		return 0;	/* never block CPU online */
+	}
+	*per_cpu_ptr(perf->event, cpu) = perf_event;
+	/*
+	 * Late-online CPU after the substrate is armed: events are created
+	 * with attr.disabled = 1 and would otherwise stay quiescent on this
+	 * CPU until the next arm walk.  Enable here so coverage matches the
+	 * already-online CPUs.
+	 */
+	if (event->ctx && READ_ONCE(event->ctx->perf_events_active))
+		perf_event_enable(perf_event);
+	return 0;
+}
+
+static int damon_perf_cpu_offline(unsigned int cpu, struct hlist_node *node)
+{
+	struct damon_perf_event *event = hlist_entry(node,
+			struct damon_perf_event, hlist_node);
+	struct damon_perf *perf = event->priv;
+	struct perf_event *perf_event;
+
+	if (!perf)
+		return 0;
+
+	perf_event = per_cpu(*perf->event, cpu);
+	if (perf_event) {
+		perf_event_disable(perf_event);
+		perf_event_release_kernel(perf_event);
+		*per_cpu_ptr(perf->event, cpu) = NULL;
+	}
+	return 0;
+}
+
+void damon_perf_event_arm(struct damon_perf_event *event)
+{
+	struct damon_perf *perf = event->priv;
+	struct perf_event *perf_event;
+	int cpu;
+
+	if (!perf)
+		return;
+
+	for_each_online_cpu(cpu) {
+		perf_event = *per_cpu_ptr(perf->event, cpu);
+		if (perf_event)
+			perf_event_enable(perf_event);
+	}
+}
+
+void damon_perf_event_disarm(struct damon_perf_event *event)
+{
+	struct damon_perf *perf = event->priv;
+	struct perf_event *perf_event;
+	int cpu;
+
+	if (!perf)
+		return;
+
+	for_each_online_cpu(cpu) {
+		perf_event = *per_cpu_ptr(perf->event, cpu);
+		if (perf_event)
+			perf_event_disable(perf_event);
+	}
+}
+
+int damon_perf_init(struct damon_ctx *ctx, struct damon_perf_event *event)
+{
+	struct damon_perf *perf;
+	int err = -ENOMEM;
+
+	perf = kzalloc(sizeof(*perf), GFP_KERNEL);
+	if (!perf)
+		return -ENOMEM;
+
+	perf->event = alloc_percpu(typeof(*perf->event));
+	if (!perf->event)
+		goto free_perf;
+
+	event->priv = perf;
+	event->ctx = ctx;
+	INIT_HLIST_NODE(&event->hlist_node);
+
+	/*
+	 * cpuhp_state_add_instance() invokes the online callback synchronously
+	 * for every currently-online CPU; late-online CPUs subsequently get
+	 * an event automatically and offline CPUs release theirs cleanly.
+	 */
+	err = cpuhp_state_add_instance(damon_perf_cpuhp_state,
+			&event->hlist_node);
+	if (err)
+		goto free_event;
+
+	event->init_complete = true;
+	if (event->any_cpu_failed) {
+		cpuhp_state_remove_instance(damon_perf_cpuhp_state,
+				&event->hlist_node);
+		err = -ENODEV;
+		goto free_event;
+	}
+
+	return 0;
+
+free_event:
+	free_percpu(perf->event);
+free_perf:
+	kfree(perf);
+	event->priv = NULL;
+	return err;
+}
+
+void damon_perf_cleanup(struct damon_ctx *ctx, struct damon_perf_event *event)
+{
+	struct damon_perf *perf = event->priv;
+
+	if (!perf)
+		return;
+
+	cpuhp_state_remove_instance(damon_perf_cpuhp_state,
+			&event->hlist_node);
+
+	free_percpu(perf->event);
+	kfree(perf);
+	event->priv = NULL;
+}
+
+#endif /* CONFIG_PERF_EVENTS */
+
 static int __init damon_va_initcall(void)
 {
 	struct damon_operations ops = {
@@ -979,6 +1238,14 @@ static int __init damon_va_initcall(void)
 	ops_fvaddr.init = NULL;
 	ops_fvaddr.update = NULL;
 
+#ifdef CONFIG_PERF_EVENTS
+	err = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "damon/perf:online",
+			damon_perf_cpu_online, damon_perf_cpu_offline);
+	if (err < 0)
+		return err;
+	damon_perf_cpuhp_state = err;
+#endif
+
 	err = damon_register_ops(&ops);
 	if (err)
 		return err;
-- 
2.43.0


