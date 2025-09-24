Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580F2CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F918E0012; Wed, 24 Sep 2025 07:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66EE8E0001; Wed, 24 Sep 2025 07:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55458E0012; Wed, 24 Sep 2025 07:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 908A48E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2268A13B09E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:07 +0000 (UTC)
X-FDA: 83923980294.04.979B028
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3C7B4140004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Toj2lwSo;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
	b=jlVptxeIH5PW2+hmHpZl39qwHPZhLHDoNV1kxDbW8PKBgWUG2hLxqEP1CCzSoY7yf2SC4K
	hdNoib2StTHLXGUQ3cvf0VLhQxS3pQUA4vWh82SvVU6Bkfh2bIu/ul/1rN84Qxl4Yay0xH
	jblq9aJlEQw6gW7Ij5ld/Jedjk3/qcs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Toj2lwSo;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714725; a=rsa-sha256;
	cv=none;
	b=ku0rJRGHcrOROMg5DvTrdXhXZPEY8Un58nBoifAnQuk/s0cWf1/gHHBzJqmWm3yTeB06X8
	le88/e7zSQawIFt9QT16mJBNnNr8AdLVsJlaM1cmQfje0uauQMo/J/6MSfXC9a1QlFJUPV
	w5UJc9OipGJtvv9yalNYALvCeSHxDc0=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so951764b3a.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714724; x=1759319524; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
        b=Toj2lwSoneYulGoSfFVBT8hVILBPSw3I+LnriOXXpT/QgztviUGTith29yQEliB4cD
         nY9FgNZ/3WXlHtJG/uuMNTzxpYOZZEBIkglcfT9odTW6zBt+px4F5Lr6sd+RwWpU8PHi
         YlbGgK9SoN29RbO04Affi0nLf3m9k+Qjezd25lZEw2jhxOGerURWJyJl2GDAudjtzJ+T
         c52eVGJup+Qc5O7Ge8jOg0dPtDLBckLYrwjauuul0bc1GAb4j1nDRP6xVEzRvZI1SbL0
         eLASnvGIYEi4PPgAmF5UWQjRX6DOn1+RKzCOurI+I0GSvKMLk++mfT1XJSg9ixGFqCUs
         /7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714724; x=1759319524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
        b=dNH2j5gHUKwkHC6kkURrYoM/7tImfxJ42YlQ/Y0/twrYAO1oXFaiGV+X3HxDH7Mnaa
         sFZgwGzxgFCfbxfFqJggjvDxKOOHREg+vlgARWvysVs0MTUMtIm6qDI7Ls++N4oOSPko
         ekm75i9k7tP4n/cN00Yl7yfP47KagmMwzMqtet/OJR3H3FvoJ5UM/SYbXj4DSIidhT9z
         2bY6H4OjlJpYoWe8Rl4LRiPYUEF4S2soBQJ7frs/Km33xU3ro4o3Vd6pcNpSoTAAK/pV
         fJ9cMK2HSLNffSyqNLEpyvOi7oP4yhLFPnEeCfdeS8gmzWDJC2oHZR4VeCff951RMKpL
         pYpA==
X-Forwarded-Encrypted: i=1; AJvYcCXzZXsQ9z1eiQUJzAJ2WmvWnEFgP5+4LdR269wWUBH05IOheMo3wxxSUmM8Ld1yyP0aT6PFdRvJzg==@kvack.org
X-Gm-Message-State: AOJu0YxDQcaKWNYDOC9V+QBAWWq18LXajHgwZHD2VNK5WUFOFaLKlvBV
	fkL+u4+inu9aXGBYz5uA7zLTnOJKm9nw4stBlvaEttR/BiHO+MrfRYws
X-Gm-Gg: ASbGncvHTzJoiYPcdWWMe8xM/VvHooAp3f5ZbNYiNj6a1xrQoedleNrZpVHou/XzEYP
	3hStL4bhdRu3UdL23yneOzT6i+S1raOgMWDMMrBJUti+XM0ZQ81VmYyHfPWTekX4hZr9oWB6ulN
	LqbR3k3IDyCSGyRgcmEItLRYw8S4XikpwOVpMXggKiSZroxF3jdqImZiv9ss3YU+DcOdHvEk+Xn
	4NEo55ZePZ2SyYO1bk6K5CRd3LNNpdyTDgW1WGCswNdxrCIboR3uRnjDUSrZWkjiU8iryISJ1oU
	VzLN6J+1NGMcm4zcrcSCuJ3589JCVP3IcqB8m+5bboIOIQlbQV/J9/t+A0ezE977Io+2WWxdD2z
	Bi5bdBKKNhv5Y/u9uvrVr8Nq50Q==
X-Google-Smtp-Source: AGHT+IHJiJ99zJ+zPViyXIexB8LjQlLrYESbH26Wyl2nhrehmiFBhk8Z/zxKNH7iKCEI35vN/jMr+g==
X-Received: by 2002:a05:6a20:5d92:b0:243:78a:82d0 with SMTP id adf61e73a8af0-2de961bb503mr1734537637.29.1758714724015;
        Wed, 24 Sep 2025 04:52:04 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f4190cc8dsm7514452b3a.2.2025.09.24.04.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:52:03 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 08/23] mm/ksw: Add atomic watchpoint management api
Date: Wed, 24 Sep 2025 19:50:51 +0800
Message-ID: <20250924115124.194940-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C7B4140004
X-Stat-Signature: 1m1bar16nfpwosc67wtdu9ooyydghbm1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758714725-435919
X-HE-Meta: U2FsdGVkX1+wcrDzrV5PvB7iScuLwrWj8GEQTdPPLmCWr9sr5Wy/RqvyiskEz9wZQjZrVzFVe3N1mEeqOynehatQqTd70cKnoCKURhEVuvmutr1B2oThQ1P0Sdt1vWPXQUGTR3Njz5g2XPY+IykddT6954y953PZ+t/VwROzbWaJevj3SoCJqZp5BXYA556Hx3mnOOtyV4/2Fe4QPsEnWvqw2BUXe3B9t1eo7GdMDUnEng4y6/U5A/EgiHxGUsVu+p+wrB/PqrmtrwGCMXYtSeYTR+6R+Rue58S7tCYzYmfX7Rr9EBp7oW14uABK3xrUo/CGClowI2hG9bTVgnxHxeEgn4VXR7qWXj4q3VQqxKVU/7adX88FysEwfPazxb6j89zXUxjiBxwxyzUClH6DeVLBB0he9HsgTZv33xX7aFOTcSP3cxiPFgZhQkHm8Qumibg0hfvn1qjzMHL+nXtBpFl/SUrddUu4TF+BPlzLCTtAZQ2RaYkehv/qTjNdSQQ+McIGI4TCFapDSpGSkHlQnosRTtLq/vLSGRryrf67UiAmoleNp11fHtfXmcdVP8qOOvucxJ9JXzpsiIoKiWGvqgAvPFQI6N0yuMz+2qdrG+sntftH6WxzD8RZJMGCh3r4Qw4XRD4UyZuzouEOSWmAKGum79m39ObzAJCZV+W+OxxtuN8iM2oXsTh6H6j8l+G/KmPHzTox30yqDxLaO7LXdshqxhZCkqkFB/Ucvb46vpe/0LWMXPri6TYNrMifLdgnit3Kz5JSrJ+qyJT8qmiEpLYL2CB1tqPy/rCJld3+/QdzuocGsgv5VNHJTltK7qnyyWnS3GzRTXhQHyZHuAaRgQYN0b0DmAy1SINnsSr18rfy4jptticnXrJM0osSwsGJ+O6cDg4gkP2iMaMWGWb8EovvGTDOhJskjPGVJ/bDC4HO9pEj+58BYDold//SQ6KcVGow8wJSVLvc0yL6Yqb
 zjGN0av+
 ilVMmXoyOgFnDJCf6GDJg1dF352hW4bOeKT/JEUggPtNobX20tfzXj9eM0KXrDcQ/QLjgPQhUuB3lGIzi1pKPkIZuFaYrpZYTwmvafWM+GkpaI4h03fFiX4JaRA7OIROAwK5/OkIHy9h7w4BLtXrc84clEWSpKLPjyR/kaL9Yfj1x2yOh/GKfA7Nnr8q//38tbtDl9FRLalcplQDgLFxVgEaUrPGoRmAEl3lWeSjX5dQho/ZtNYoXrwIxObCCGfMe0mIE8s1AV0gxLtnsvk+CSEKFhmBTTfTaubtlQaRKZJTFbwea+JOgzAmFUE8j6FLLukHzooa1rBSMUxbcmNx/975MCDNDrcm55mhT++l9xgB9TO6jtW/DJzR5sbQhfGb/MNFsPGd8KtTdQbCgfMqpcqGlIluHNG2lyqEOTyS3nN1neDxJk5k4Q6SYxBS21FJS2FzU3gzzBfdAmmDS5nZTMrb+K4DXpM5hJp8GAKfekaO8tBcNN6DhQdp91wAk8MY45OtQlUiq9aofQn4=
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


