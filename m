Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2D4CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E390F8E002A; Mon, 29 Sep 2025 22:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE82E8E0002; Mon, 29 Sep 2025 22:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0018E002A; Mon, 29 Sep 2025 22:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B58218E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7649DC056A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:03 +0000 (UTC)
X-FDA: 83944374486.13.002F7D8
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8347C120008
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=akXw8T6+;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
	b=IQG3fR4EsuB3lG0CX5Ae/agRbrVw9DZ80l6fDjjFB/5AExavTPCrelgNs/JfRqEnND2dmw
	MwqqWifbQ8Juy36aSMlTbWvNrPnNges98dAy1wuOQX5JY3w/bokJt6SScxYcI3f65on+RX
	TTHYLHMZ/HjMD+J7CT3Vyf/+abWqqrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200301; a=rsa-sha256;
	cv=none;
	b=zg/0GMrv3wfJw3OZGegPdiPtUwJkbMv01m29ok+mgqV+CzjTmEpfB3uSgG8a4oY5bTpz9j
	kKsC2+KzlcV2aMniKUvYdhWvpZIwBy92LFXfiBgKkE/AeilYBVQXDrecYdPaaNMDqb8Y19
	GA6JuwyE5z1gX7FRc5mFxHE96d1V77s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=akXw8T6+;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-33255011eafso5341756a91.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200300; x=1759805100; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
        b=akXw8T6+p2p8jadHvqX6tMHS0juZ2f4Os628AqOjh7PeV6BF9sSQdCzeo6u/C1qYbE
         fYlDorYRaXH86lju3VCv3L/bAM7Jnx+99Nf3gqeL4VJ+OdbVERzNPvD/ixh8wcU9XvbL
         EV1h1PlG4nR5HkCPDVOcCg4VVxAZ14xAwcRQhX3W0KiEMcr5LJpJUSvARiSiFLGonwfN
         bZE1UEO2hZOQiyWoyLhVDvGoNPtbWUqcbYnsTdZl2n/U6sBK6Ooc+F4kFua41YZqNLop
         ANsFt1DJPspWoiEkbatRkrYXXzAPnX7FdgTz1Gel5ysg6f6p3S5nRfIqDnZW9UZH6NgL
         ileg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200300; x=1759805100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
        b=ZYvsd3IWb7tHbc6XVtO15UH/4NQEKiemwbaT0KyAt+v4gpWRC6QEywjCp1tQyY0lZr
         9OTugD828jCslwlxIQICmT5bpdt5M3XlFHcg9BDAC3mF/DocJR3RScpne52VmlDcD9KM
         GqoTh96+eM22DhCDa7LilIfHY9h7RB1gFb8aKiuj3pVW3146Cnv49nxMrCJl+SMGepX+
         A2vipzsr0K8g4h47OTZxNexa9ITOsraRMbMfmDNTc0m91ADTvr7SuyHSpZnDVSv8dAob
         wK88b38O9v7nf+VbrYHs5kdVguheWEzTUC+3+jxL7XtVZMDBMyBFdpkdYnP7DlH5NpS5
         nNEw==
X-Forwarded-Encrypted: i=1; AJvYcCVuqMLt1ROr2RcFGaQ12sZpa7bDAzkX9+o0Urj4xMXz00ljL+60aA6SWl4bLwpgGe9s6iOIQHgFLg==@kvack.org
X-Gm-Message-State: AOJu0YwfpQ17ABZhmNM8vTkmm98ZNir9Jje38UOa3zxz00jJbrr7VLDM
	cJFXhTyo6JBt93prjPW5iqY17rnZ+swt6O15+0xe7zjyRK5bccN5m5Dm
X-Gm-Gg: ASbGncsCswb1Gm/qqNJvO4TZSjcV3jq9opg1LYVuUAPcoZBdc3v3DbGHawrVSbI3euI
	5GHDkHUgWhisZcRpvzFYROo3GFY60yd/JeqXummeeTTeizez6+XahVZYVz6qV3NOXpzupEXnjg0
	r9fp8jlIdRFxyW2Ji4tKuMm9pr6MCN/8W/MVP+iUyrUJs6/PH1eP3geuSpVzx2vemLo7eY0Yo8y
	serBJg73DzbvBqZY1H72JpQ5yLwxBIK1fITz9PJRGppzptG5hSwM4sMj5CkND67feXv7MqXgx5B
	4KrcytPhlnnM4HvXiqB8SwtUHpTmOO12pQzzv0GfmielICuRALsBJ9mUmFSnOBAHHGstDtiWxIY
	WZovIMEZWSMRveChF1EB2hip7uNdCdA9kuYOrRh7x1RZq36zLKASOk3btxwscEhHSmQ==
X-Google-Smtp-Source: AGHT+IE6QAYldFReTbNhwKklFYNdCEVJpgfxwTpvKILLxf8DP4CkMPu7V/vifWE/k6I2u8vpWc3E8w==
X-Received: by 2002:a17:90b:1b4d:b0:330:797a:f504 with SMTP id 98e67ed59e1d1-3342a215b70mr18813357a91.3.1759200300239;
        Mon, 29 Sep 2025 19:45:00 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-338387255adsm2766677a91.19.2025.09.29.19.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:59 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v6 08/23] mm/ksw: Add atomic watchpoint management api
Date: Tue, 30 Sep 2025 10:43:29 +0800
Message-ID: <20250930024402.1043776-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8347C120008
X-Stat-Signature: ber8pqtuf9h6dxqfwnqs9jg3nofw3ccm
X-Rspam-User: 
X-HE-Tag: 1759200301-835504
X-HE-Meta: U2FsdGVkX18MSOc26Io08xjqxqG2+swSn3s7bpsY/JCFrvPp/kgI8FsgwdFyn97doNVd3w1r3hwVs/Ete0SA+WKsDu671ClkXAX8py7kTo30grR+eoMlZOkw9Ey/By1v2DD1dk57t4A775RVb35FhhuaphrMpyHof35I9M7kjbQEbpQO8G3G5OvVetfYLqvfrJmHtcsEkbczWx3fF2ZUdtijVFmbGNHcWFhVksG2Amm2g5fElGrJEWxKFKlbxYKZP042S+xXhcs9QOInQ8HUskdVutdog2R/TULVNMd8P0mop+5NhYabZJwG8sJ3iEgk5DRR5HDAIPfTAp+8xfSIt9DI1tfTtTi2MmdhMKXE8Hh+alQkOX7gzAunHT/RNYDXbcT0iRE673ZhnhqHp4eLM1QR9HFhiy8dTdh+lXoRkwvRRTQQCEG/q/CBIB7/RxZtHXDXevdWk33qHwnf5Cchtl9gNUWAKL28xsBERc9Z4f+VMLRDo/i/NVbrSaIndABA4mItFqB9ZrhzRfsydB57uh71EXBCslvjknNAGWzVAcDwGbC9r+Axv4fLxL3kOu1eFLWm8bNYJHsbDHB9YXj7jAq/FyVdciopW3K22mxMdCNp2smOngLXl2D0whn2nDgk/EmmaC44wOsSwqWd3ER2QWsrzuifEGnb7cck9T/tEcfHfNNodMmsgiIFCXHaNfI282sef4MvOtjYeU9aDKNqPpfSg0QVyNHCrMjspFul1+KA7rwyLmZc285u4rhuWp8wwoImGMneAwCJ7JGGwjV5RRmR/WsImxrA+htfaWivgWvHUEPVkOcs6BJHEmpdsRHeuX6zK5MS+OjtyCP146cQ554bV12fqyP6Ey07i7O1dRxwUlZNqPZ5q0eGK/J4TnXW15+shM43Xr90pHs+7ToKyopLSHWmFVkkjhvN/NaKcpY5MDgWCZ5Pbt2ABedFuTcZrzPh4GmG52iAMD3n8Zp
 ySL1j0al
 H3VQnZTlYeI1iqRZo7yzE0T4IEudkPWq5M281Xd5DuhDDN6jiRibJnmp/GnaNfATl5+TO6CZeNPbcTm6/RmvTPFWZDocG6DZKqqmPvna0EgbOkGDud64vUkE1M/g37deXmLQC5CNe8BWwo8CIVNPsXRj/u22XYdBu/LgXfoVYnEB4P2qcAiPx1HJ24y3W37ThVGo54Y+OrU5uJWfgrejD3MWLMoK/7ExHB9xeyXYNijfT6pfUoDDrtnVIo/cBYF+oCc1pXAU77S0qqXWtdOQN4hP8DiNOw5GgNzG0jcW98+cwnz2lHM05elxdb+XQA9w98pL5NYfPc4QAtpq3kLIwsOyvtgE592wJEt9rkmwP76TIDCyFDz2oLBQerIWnqTvUn/9VVOavlqvDUfmVvXY943npAyeLVkEzfSl8IvDqk9iuUi9GyAOpIzPvil/Cw9V4djEnIKn5O4cgxo9e97a1inrL9kjK5q60rjuDKbiIvkIhuLd3SXeECnyouvV1ZVt+OMeKiYGy6qBgpIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add three functions for atomic lifecycle management of watchpoints:
- ksw_watch_get(): Acquires a watchpoint from a llist.
- ksw_watch_on(): Enables the watchpoint on all online CPUs.
- ksw_watch_off(): Disables the watchpoint and returns it to the llist.

For cross-CPU synchronization, updates are propagated using direct
modification on the local CPU and asynchronous IPIs for remote CPUs.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  4 ++
 mm/kstackwatch/watch.c       | 85 +++++++++++++++++++++++++++++++++++-
 2 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 4eac1be3b325..850fc2b18a9c 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -38,11 +38,15 @@ const struct ksw_config *ksw_get_config(void);
 /* watch management */
 struct ksw_watchpoint {
 	struct perf_event *__percpu *event;
+	call_single_data_t __percpu *csd;
 	struct perf_event_attr attr;
 	struct llist_node node; // for atomic watch_on and off
 	struct list_head list; // for cpu online and offline
 };
 int ksw_watch_init(void);
 void ksw_watch_exit(void);
+int ksw_watch_get(struct ksw_watchpoint **out_wp);
+int ksw_watch_on(struct ksw_watchpoint *wp, ulong watch_addr, u16 watch_len);
+int ksw_watch_off(struct ksw_watchpoint *wp);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 1d8e24fede54..887cc13292dc 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -31,11 +31,83 @@ static void ksw_watch_handler(struct perf_event *bp,
 		panic("Stack corruption detected");
 }
 
+static void ksw_watch_on_local_cpu(void *info)
+{
+	struct ksw_watchpoint *wp = info;
+	struct perf_event *bp;
+	ulong flags;
+	int cpu;
+	int ret;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	bp = per_cpu(*wp->event, cpu);
+	if (!bp) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	ret = modify_wide_hw_breakpoint_local(bp, &wp->attr);
+	local_irq_restore(flags);
+	WARN(ret, "fail to reinstall HWBP on CPU%d ret %d", cpu, ret);
+}
+
+static void ksw_watch_update(struct ksw_watchpoint *wp, ulong addr, u16 len)
+{
+	call_single_data_t *csd;
+	int cur_cpu;
+	int cpu;
+
+	wp->attr.bp_addr = addr;
+	wp->attr.bp_len = len;
+
+	cur_cpu = raw_smp_processor_id();
+	for_each_online_cpu(cpu) {
+		/* remote cpu first */
+		if (cpu == cur_cpu)
+			continue;
+		csd = per_cpu_ptr(wp->csd, cpu);
+		smp_call_function_single_async(cpu, csd);
+	}
+	ksw_watch_on_local_cpu(wp);
+}
+
+int ksw_watch_get(struct ksw_watchpoint **out_wp)
+{
+	struct ksw_watchpoint *wp;
+	struct llist_node *node;
+
+	node = llist_del_first(&free_wp_list);
+	if (!node)
+		return -EBUSY;
+
+	wp = llist_entry(node, struct ksw_watchpoint, node);
+	WARN_ON_ONCE(wp->attr.bp_addr != (u64)&holder);
+
+	*out_wp = wp;
+	return 0;
+}
+int ksw_watch_on(struct ksw_watchpoint *wp, ulong watch_addr, u16 watch_len)
+{
+	ksw_watch_update(wp, watch_addr, watch_len);
+	return 0;
+}
+
+int ksw_watch_off(struct ksw_watchpoint *wp)
+{
+	WARN_ON_ONCE(wp->attr.bp_addr == (u64)&holder);
+	ksw_watch_update(wp, (ulong)&holder, sizeof(ulong));
+	llist_add(&wp->node, &free_wp_list);
+	return 0;
+}
+
 static int ksw_watch_alloc(void)
 {
 	int max_watch = ksw_get_config()->max_watch;
 	struct ksw_watchpoint *wp;
+	call_single_data_t *csd;
 	int success = 0;
+	int cpu;
 	int ret;
 
 	init_llist_head(&free_wp_list);
@@ -45,6 +117,16 @@ static int ksw_watch_alloc(void)
 		wp = kzalloc(sizeof(*wp), GFP_KERNEL);
 		if (!wp)
 			return success > 0 ? success : -EINVAL;
+		wp->csd = alloc_percpu(call_single_data_t);
+		if (!wp->csd) {
+			kfree(wp);
+			return success > 0 ? success : -EINVAL;
+		}
+
+		for_each_possible_cpu(cpu) {
+			csd = per_cpu_ptr(wp->csd, cpu);
+			INIT_CSD(csd, ksw_watch_on_local_cpu, wp);
+		}
 
 		hw_breakpoint_init(&wp->attr);
 		wp->attr.bp_addr = (ulong)&holder;
@@ -54,6 +136,7 @@ static int ksw_watch_alloc(void)
 							ksw_watch_handler, wp);
 		if (IS_ERR((void *)wp->event)) {
 			ret = PTR_ERR((void *)wp->event);
+			free_percpu(wp->csd);
 			kfree(wp);
 			return success > 0 ? success : ret;
 		}
@@ -75,6 +158,7 @@ static void ksw_watch_free(void)
 	list_for_each_entry_safe(wp, tmp, &all_wp_list, list) {
 		list_del(&wp->list);
 		unregister_wide_hw_breakpoint(wp->event);
+		free_percpu(wp->csd);
 		kfree(wp);
 	}
 	mutex_unlock(&all_wp_mutex);
@@ -88,7 +172,6 @@ int ksw_watch_init(void)
 	if (ret <= 0)
 		return -EBUSY;
 
-
 	return 0;
 }
 
-- 
2.43.0


