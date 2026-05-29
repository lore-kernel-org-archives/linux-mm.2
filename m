Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBD0CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22B46B00BD; Fri, 29 May 2026 12:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3AC6B00C0; Fri, 29 May 2026 12:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1DF6B00C1; Fri, 29 May 2026 12:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0D7E6B00BD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:57:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 733D8A0101
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:03 +0000 (UTC)
X-FDA: 84821062326.29.5529025
Received: from mail-oa1-f66.google.com (mail-oa1-f66.google.com [209.85.160.66])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9481B1C000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1n12qLq;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.160.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBG7U8aH1ARs37G3HmZz4dhZEB7morx48iJcdEwFffY=;
	b=jDrzQJO4vCPsm94gwZOkjcNNZpng27ST8cingaa0MoA0wz2rd7i5/nfA0FEPISOo5lnHRl
	F7HVPEBiA2JjbjQhjd3rB232GH2j6Hv/4nQNLQJYZAKJVKDocCnkjgmNkqBAyIMffS+d3K
	t4w8aZ3JgFlRquKYWwcfzB10jE/xDuE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1n12qLq;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.160.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073821; a=rsa-sha256;
	cv=none;
	b=wVWI01rig3rNFs1r6knV8Dk/wJLXaSdtBXx2jeixFC5QMG4i/Ji5/aEORKj/Lx+Cj3oyOY
	mcwgt4U41wN90x1UiH0hujYmMQ89vv6ny7UzKuJarGKKtBSsgxFWGwnCEVZTJOKd9EooMm
	BuHTRp7feazhz04j6LS9nBoks5F+66g=
Received: by mail-oa1-f66.google.com with SMTP id 586e51a60fabf-43b53f048beso6107045fac.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 09:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780073820; x=1780678620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vBG7U8aH1ARs37G3HmZz4dhZEB7morx48iJcdEwFffY=;
        b=B1n12qLq+uEY13aETEL0PE1i6W+Dnp7ej32+4LXDFp89GiYTnC2+1mw1jxBojv0iU8
         T60JEaaxtAk+QSZcQ6x+U1BMmyGsTu+D4yjF8tsxpHo96MMGdCzpBTydYynjDS4eDX3W
         rPATXkoYYTqtBf+bsgqsr9e6ztEU8zSXXqrJCeAu2YEYN+ZvdflLgOLRYpQsoc02K1Gr
         N4C4lsm1C9t3YLLeGxFJ5DLR8ThS9VJZD7x53Bb1OfiO78f+wPjUuH3uU6Xe1NtUD+YM
         VFsTwnH1h0NNP3jty9Uh9vaKw00H+hVdlZoUgxVRvxO+Vh3wx+AD4ucytffeKHTh2pjd
         lBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780073820; x=1780678620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vBG7U8aH1ARs37G3HmZz4dhZEB7morx48iJcdEwFffY=;
        b=XZgNNYGf4BJ3zIT3xQ3vMryxYJ1uXjy8b7rex85AcTIdsrmolIxxD/1uxk/6sHPF6I
         ahgz1fPB9V8xWEebufLh9ltEMOlKWWqY+YBtTBwmmvbb6HAZ+RtzWjyamCggveccEJqm
         s8fi6A7TPShVkT45xbnVvmbnvKKscqHVs+TaMzmVf0cLK5BjeFXy8z7QEzMahklYxkd8
         9k4/mE8U9KB9a2TPVQ81QrM00X9P8Pz1Z07cA49QO5pfN5aUDfeMRK5LArDiEJtz8f96
         twsB6S2Pztc1zBreHQMtiBCIj+SWUV72D3Y5zXfPlEG7F8IYg5GERWU1QSatH6vSwP3o
         raSw==
X-Forwarded-Encrypted: i=1; AFNElJ9y10m+7poEtOh7HoqjXOwWk1QJmQXejqIb85wAFilDySod3X4N7/qEZM/1pueTQ7qfUorEAh8j5A==@kvack.org
X-Gm-Message-State: AOJu0YzjUc//P5GYJp0ZfNFqDxwi93zODxjqnN3FnM7rNWlPY9MSySQP
	N1laA/cRjCjbUtI6cfbNqOUy7EYoRtwgCdv3OTR+I9Uk11DAhzOtn0I=
X-Gm-Gg: Acq92OG76Biy8GH9hjDow5Wf6A0G+HxBdhZT372Djb+bOGKR4gIc3xjcWWaT0Zfoqo0
	TdXOdE4EWDNgrWVegiwnYN135SvLNtEoySPwrVVIaFE2PX6T25PqDM4HcQcblus/uhi2IgyC5Ba
	RhQpv1UX8ZE9gEGRW/ccjs1cyqD6ein+oPl8v3nUhtUok2jBEf4G242j/9AQZXY+7efNpWsF033
	u6Djcl7bF3KcuzJlolTP+XcMHW0aUnejzvKe97ecahm1oMcyCi3njDQ9Eggoli1Sxe+0niNpNKz
	mG3e8qVKyegWcWCnjH1g4eA9lB7m/Shxl7qU36ayvSJXKBBozivO+kX4+WMIvWJRSMppX/Y3xIg
	fE1yLNye0nVS4ZTswBxaub8HC2lB8MMySB9GgTLBjk8lDbuppfXJMN1M6wIBUDVpw9XoG0BefYA
	M7dwpR4tzWSZnxMYxyvdPNtbOHHh+LUzIcrX7JBmReNbfKJnU4Ur6RZcYD9JpN/1mFEt9I+SEun
	3jbPEaU2CqO
X-Received: by 2002:a05:6871:890:b0:423:4260:2e0d with SMTP id 586e51a60fabf-43c891e473cmr1659989fac.8.1780073820507;
        Fri, 29 May 2026 09:57:00 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43c93ef3ad7sm1403070fac.9.2026.05.29.09.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:57:00 -0700 (PDT)
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
Subject: [RFC PATCH 1/6] mm/damon: add struct damon_perf_event{,_attr} and per-ctx perf_events list
Date: Fri, 29 May 2026 09:56:35 -0700
Message-ID: <20260529165640.820-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260529165640.820-1-ravis.opensrc@gmail.com>
References: <20260529165640.820-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ffzwcttq3ddr8w7bgajkee4stws13nj
X-Rspamd-Queue-Id: 9481B1C000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780073821-619521
X-HE-Meta: U2FsdGVkX1+Y7pWUgwb1GXvZTE3L9JBlsN6sOPr+rzlUCU5nGCCQ14NLiMmODMOuyTgVMwJN8LnrgXyZTTjb+GP3yMzg81slLb/JCgwQXAzKCAS8RksJHtxkv56u8oBoLvwEHHcWT17AZA0U6IduZdA7mqiY7Qbm2pCJmeWyBwvNzaVi7ECUAvJ7EsoNlV5wW+YqojeVCskCag+DKg9Nt8gWc1EylX/CxAXRofaT1Dqko4GK/ErqGOkpjJYIi36ODt0vuDiECMBnRXN6CAjVhSb0i8fC2MBUyukADSB+e6g4R2/9bq0bh0azfYtV3LGvy3dBfoxuiKJgGC8Qd/teRNSUfB+xhj7ebZ3Pq2LF5oz4FG9RfCmJJFofqmPBvGrIpGd7gFZI1XuccjveRKHrxeB9Ff3xuix3Zd2XLiUvlXcLUTajta/MOtNKxcJRKtXVCvNz9KAoWV49cuOdxaGTuv5AElHVRxUWBtzYRXs7VMSmCxMikJabJ2bYCGI8Pri5pDqXGVMHnI3RUeYBDpPCztRP6RcWtAU6bNMUxiq+wdXCaDZeaxQ5HpsomymJMg5cnto4OvrSeKs1KGDvbUfBIY00Gl4aIIG4ru7LTZ7XUVVWAv/TdPJxbc9Wm/zmDmF0eaLOQ/nmIAN0B+GfMvV4/g2x8fFB4SSViX9n/iVwV1wK05H7hEyRq+6TahKejcFTNwQBQi3mbd844tdL9T+iZrchLsxnXoF8uipL3dPq/Jk8OwhU5pEupFVEvaD4EkBK3NBZBCJWRqs/auITyiImLzB4/LIYyj0qMLYoyiM0Yy3PHLajUk/ZLpE1kpbNgSgkzw+8vnoEzIcx/CD3Qe222IB6e9Tis3a5HpjVjeYb64K/+cAP89dM+v73a2kkmhFx/OceSgT0mf6+Thp8q0o+cbOH9qQIePsQTaLw7a7S84s2X9m3yWfm/4fkaczicrKO7kZe6ORpB/a/chTJN7Y
 B3hP+a9w
 qiH0EAXpAax29+2RQAA9FGr1MGTtiYSOSFhpAdTACR1x6PD1trFicXxXE5qLWpUf+W/oCe8/ShP+C3lOFkQTjKUH3vpnpd0h+DyjoD5AmBHCDysqdiph4o7BIBzeuU7xurFvBih+xAcboE6aQxgr1fzoxHBJ/ceoiggMACkQrByDFdNc8M8lyG3e4oOZfcPcc79k/BRWiamYQqrsJAGrwlk7ypVeBtSBk8zcxKOtQgqIz/1mwbVLHMSc93kZ8HonyciZMeoJM9PLGOavgBoqxJbiW8R5jvyo5QllOm2xH0hXGna1+xvoZ8caYH1m/TcOgacS4hFdqEM2bNiiE4Y3dcAeQRbRX+zdN2COizpIq5Siw9zvUsZhZln7CEFrT78OmnvjRnq2dpVobO/qBNroEcXDU6SyYgo8ZR06DJ4vWDndMDmlZQev4l7c4U6tMYSapkdOl5s8EH9uWESLd7Wo2c8rjFW9PEH6dqqyDNqNQKM2NnhzzlacU/JoWVRHj4Pq4QTvbVRPoCZwLD+PCZB2Mlwg2WNruMr+6QW3sCV6i7Fr5nAmkoO0unVaFDk8fpm5Rur24lN8FPfsfZ4MSWJorwFRWYQ9yGOvNXFPRG4xnWdSFn0vl5ZsGlSQEDr0UQK5Z09D++5j4w+upfKd3JOL76S/W/2kNsEp8Bk2Cg+fjB1PN4Vp81ADjP72Jqv2paIo00vzNqzDCnYMpSbaoFUhfsPXMe71s6yxRm0Ua
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the substrate types for using perf events as DAMON access
check sources.  struct damon_perf_event_attr carries the raw PMU attr
configurable from userspace; struct damon_perf_event is the per-event
entry on a new damon_ctx::perf_events list.

Declare damon_perf_init() and damon_perf_cleanup() in
mm/damon/ops-common.h.  When CONFIG_PERF_EVENTS=n they fold to a no-op
returning -ENOSYS.

Suggested-by: Akinobu Mita <akinobu.mita@gmail.com>
Link: https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h   | 80 +++++++++++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h   | 39 ++++++++++++++++++++
 mm/damon/sysfs-common.h |  6 ++++
 3 files changed, 125 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c0375035a3a7b..11f1c1071b9ba 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -123,6 +123,7 @@ struct damon_target {
  * @size:		The size of the accessed address range.
  * @cpu:		The id of the CPU that made the access.
  * @tid:		The task id of the task that made the access.
+ * @tgid:		Thread group id of the task that made the access.
  * @is_write:		Whether the access is write.
  *
  * Any DAMON API callers that notified access events can report the information
@@ -135,6 +136,7 @@ struct damon_access_report {
 	unsigned long size;
 	unsigned int cpu;
 	pid_t tid;
+	pid_t tgid;
 	bool is_write;
 /* private: */
 	unsigned long report_jiffies;	/* when this report is made */
@@ -501,6 +503,7 @@ struct damos_filter {
 };
 
 struct damon_ctx;
+struct damon_target_lookup;
 struct damos;
 
 /**
@@ -966,6 +969,67 @@ struct damon_sample_control {
 	struct list_head sample_filters;
 };
 
+/**
+ * struct damon_perf_event_attr - raw PMU event attr for access check.
+ *
+ * @type:		raw PMU event type.
+ * @config:		raw PMU event config.
+ * @config1:		raw PMU event config1.
+ * @config2:		raw PMU event config2.
+ * @sample_phys_addr:	whether to set PERF_SAMPLE_PHYS_ADDR in sample_type.
+ * @sample_weight_struct:	whether to set PERF_SAMPLE_WEIGHT_STRUCT in
+ *				sample_type.  PMUs that do not advertise
+ *				weight (e.g. AMD IBS Op) reject events with
+ *				this flag set, so it must be opt-in.
+ * @exclude_kernel:	exclude kernel-mode samples.
+ * @exclude_hv:		exclude hypervisor samples.
+ * @freq:		when true use @sample_freq, otherwise @sample_period.
+ * @sample_freq:	target sample rate when @freq is true.
+ * @sample_period:	period (samples-between-overflows) when @freq is false.
+ * @wakeup_events:	perf_event_attr.wakeup_events.
+ * @precise_ip:		precise sampling skid bound (PEBS-style PMUs).
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
+	u64 sample_freq;
+	u64 sample_period;
+	u32 wakeup_events;
+	u32 precise_ip;
+};
+
+/**
+ * struct damon_perf_event - perf event for access check.
+ *
+ * @attr:	Per-event PMU attribute (configured via sysfs).
+ * @priv:	Monitoring operations-specific data.
+ * @list:	List head for &damon_ctx->perf_events siblings.
+ * @hlist_node:	Tracks this event among cpuhp multi-instance entries.
+ * @init_complete:	Set after the synchronous online sweep finishes; gates
+ *		@any_cpu_failed writes from late hotplug callbacks.
+ * @any_cpu_failed:	Set by the cpuhp online callback if perf_event creation
+ *		fails on any CPU during the synchronous initial install.
+ * @ctx:	Back-pointer to the owning damon_ctx; the cpu_online callback
+ *		reads ctx->perf_events_active to decide whether to enable a
+ *		late-onlining CPU's event immediately after create.
+ */
+struct damon_perf_event {
+	struct damon_perf_event_attr attr;
+	void *priv;
+	struct list_head list;
+	struct hlist_node hlist_node;
+	bool init_complete;
+	bool any_cpu_failed;
+	struct damon_ctx *ctx;
+};
+
 /**
  * struct damon_ctx - Represents a context for each monitoring.  This is the
  * main interface that allows users to set the attributes and get the results
@@ -991,6 +1055,11 @@ struct damon_sample_control {
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
  * @pause:	Pause kdamond main loop.
+ * @perf_events:	Head of perf events (&damon_perf_event) list.
+ * @perf_events_active:	Set while kdamond_fn has the perf events armed.
+ *		Cleared in the kdamond_fn done path before the events are
+ *		disabled; serves as the gate for damon_commit_perf_events()
+ *		and the kdamond_fn drain dispatch.
  */
 struct damon_ctx {
 	struct damon_attrs attrs;
@@ -1046,6 +1115,9 @@ struct damon_ctx {
 	unsigned long min_region_sz;
 	bool pause;
 
+	struct list_head perf_events;
+	bool perf_events_active;
+
 /* private: */
 	/* Head of monitoring targets (&damon_target) list. */
 	struct list_head adaptive_targets;
@@ -1054,6 +1126,14 @@ struct damon_ctx {
 
 	/* Per-ctx PRNG state for damon_rand(); kdamond is the sole consumer. */
 	struct rnd_state rnd_state;
+
+	/* Reusable drain-loop snapshot buffer (avoids per-tick kmalloc). */
+	struct {
+		struct damon_target_lookup *lookups;
+		unsigned int nr_lookups;
+		struct damon_region **region_buf;
+		unsigned int region_buf_cap;
+	} drain_snapshot;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 5efa5b5970def..35da400a67ec1 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -23,3 +23,42 @@ bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
 
 bool damos_ops_has_filter(struct damos *s);
+
+#ifdef CONFIG_PERF_EVENTS
+
+/*
+ * Per-event opaque allocated by damon_perf_init().  The NMI overflow
+ * handler does NOT touch this struct; submission goes through the
+ * shared per-CPU SPSC ring via damon_report_access().
+ */
+struct damon_perf {
+	struct perf_event * __percpu *event;
+};
+
+int damon_perf_init(struct damon_ctx *ctx, struct damon_perf_event *event);
+void damon_perf_cleanup(struct damon_ctx *ctx, struct damon_perf_event *event);
+void damon_perf_event_arm(struct damon_perf_event *event);
+void damon_perf_event_disarm(struct damon_perf_event *event);
+
+#else /* !CONFIG_PERF_EVENTS */
+
+static inline int damon_perf_init(struct damon_ctx *ctx,
+		struct damon_perf_event *event)
+{
+	return -ENOSYS;
+}
+
+static inline void damon_perf_cleanup(struct damon_ctx *ctx,
+		struct damon_perf_event *event)
+{
+}
+
+static inline void damon_perf_event_arm(struct damon_perf_event *event)
+{
+}
+
+static inline void damon_perf_event_disarm(struct damon_perf_event *event)
+{
+}
+
+#endif /* CONFIG_PERF_EVENTS */
diff --git a/mm/damon/sysfs-common.h b/mm/damon/sysfs-common.h
index 25a6c28abdea8..67c7545fd57d0 100644
--- a/mm/damon/sysfs-common.h
+++ b/mm/damon/sysfs-common.h
@@ -66,10 +66,13 @@ int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id);
  * sample directory
  */
 
+struct damon_sysfs_perf_events;
+
 struct damon_sysfs_sample {
 	struct kobject kobj;
 	struct damon_sysfs_primitives *primitives;
 	struct damon_sysfs_sample_filters *filters;
+	struct damon_sysfs_perf_events *perf_events;
 };
 
 struct damon_sysfs_sample *damon_sysfs_sample_alloc(void);
@@ -82,3 +85,6 @@ extern const struct kobj_type damon_sysfs_sample_ktype;
 int damon_sysfs_set_sample_control(
 		struct damon_sample_control *control,
 		struct damon_sysfs_sample *sysfs_sample);
+
+int damon_sysfs_add_perf_events(struct damon_ctx *ctx,
+		struct damon_sysfs_sample *sysfs_sample);
-- 
2.43.0


