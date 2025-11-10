Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A8C0CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5788E8E0041; Mon, 10 Nov 2025 11:37:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CC78E0003; Mon, 10 Nov 2025 11:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2328E0041; Mon, 10 Nov 2025 11:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28FED8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAD691601D3
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:19 +0000 (UTC)
X-FDA: 84095252598.11.D2C054D
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 087DD20012
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=En9K2fSu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792638; a=rsa-sha256;
	cv=none;
	b=L5y7lLB2MjOSfW+tf4IA2wBFxVDNWA8nTj4R47hFTxWUFrS5quSSNcjr/yx//d0Ec0kF52
	MdwybGAT3GtdPmqv9SRGPJI2Fvkn4lkkedxDuB1YYYG/nKxQGF3huMd1OPEC+scoAqQVg4
	wh3Bd1XKixpALBC5+eoFIUm2N/YCPwU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=En9K2fSu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xci1h+5LLX8h0ueKKgEGcPTmlGP88Cc5ZUWnC1Z7B10=;
	b=MkX53UxEaHcPB0/+ch/nWxCpUSK/W9kKINBchadQQboBdjtTQ6UK/GQvYUb5yvBvAN12EA
	kuVZJxMm3/H/wWZXh0mAH1zjm1CQZQsHT6S+n6D/k3vmLQqWC1Q7UXWy3SE4RrwDM03AC0
	Y2TTNRqq+/5GROodON0YTblSlrHKC5o=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-295548467c7so34484785ad.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792637; x=1763397437; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xci1h+5LLX8h0ueKKgEGcPTmlGP88Cc5ZUWnC1Z7B10=;
        b=En9K2fSuhxw7THCCbg1gMC0ON0gZb405GybdjLug6KOqEJaS0MRp5+uE0NwjZPjqW/
         0leYeznEjd5/v0ZaVEti2O0J6kJ6BT3gswkVR0Au3bS15ZiekKYph0/+vjYkeA3TRNpS
         1mAPsd7QvNGR0wAhkZO13Cj7CXLcKLQVQwmw3Q4djeagsu4SRioLaZ4Rdf3T0MB2JIoe
         QinpGGXE3x1gspJzWljHb2WIP3GnGMNbZcBR+X/dWNhCAJopkS+u98BHukLuIPdnj+Ha
         BcfAe8hvvfsEB/+T7MUQ1P8UYi2h5clLQNZBozG7YkFRf4vmK18LP/9IQFW87z05CB/o
         v8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792637; x=1763397437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xci1h+5LLX8h0ueKKgEGcPTmlGP88Cc5ZUWnC1Z7B10=;
        b=PMrgY15HTtjlXXjbMX/c3tMjlKH0+AjIPZfGM2vy6dINUBEuOeA7sSv1SnEj4Ly9CX
         7FzdZg4NQiOVHcjxBAU/tzQPS9i/Wy3FE2s0Xg/FtJJI1beXaZbwRUblqnr0lDwp8Q1X
         xjUJ3jR8VqPx74c63ZpOhxevsAyH/mCeLi/IJAIm4iae4jnfUwgPTiYiT9QWRTdAusGY
         9C/fOQY6ihVGl50B6zHQ3b7pOYsll2eWBSgh5+fU3/s5Hdp2rq+yy7wQ90kLhJ9/r7Gy
         UN6Vb+jIfLIfuANegK+EzcGgr23R7Jv3bnwxM74PNW4FBX/PwaAKjwi6rAxbPKShjyRa
         tVzw==
X-Forwarded-Encrypted: i=1; AJvYcCVr7sAoEZ1FINFVp8PZ3gtr+wQufXI8V3vQIjBxnt1l4ZZRrYp/4uqM1o6RgnKScS0YPunZ//8h5Q==@kvack.org
X-Gm-Message-State: AOJu0Yz5wtYkrvIcU3IXt3/njihrdW8AYTvjEB8hUHcTC+yxMeGVdUvi
	LGEHxUsMKi9ovXFmnmgKAxhmacoeeS3PFu6iyF/Y7c9GwxBbQcfG96P6
X-Gm-Gg: ASbGnctCLjk0itxEMoYNSzDTv5KFlc9W+YRZllcvNdrMOeugHKNB2pHrZ0HXlh6Ww+/
	v8K7hJnQpKkJgJSqyMCUkrR5yVWaUqI4pP1/rOBsjD22igSOz7TUemEX99Hi2yZVo6biIauwr4O
	MCbRLduqjEMy1qGUGc6UefeXhZ7Q6RjTBBVcXUWZx4MwqQZqMGqkg4yQLIbLr2k74RhxtXM7Ptd
	NtcZ/9POlG6Qjjai4oQLZ7oCl/PdnSZMkVjAxxKsBsuKRidtq1Top2K8ZUaRespp5/XQpD3Ic6u
	64p65MwoM5ogeSv/hCxPds1bhHjgrzBEr5jNNYzrip3LxHII5c28yqZllm7DI/vgbSz8ODLOxUF
	GIKjFG0aQ14/KbTQT4GkczdbOXVOotk6to5odfqSgxLD2CLO4WP+XLpBDGxEItbmzDeUPwL+Sft
	NZ3zWvy8zZnsw++zJAxkU439mRl22dXyr+
X-Google-Smtp-Source: AGHT+IEGWB34N8M9pAG46FEM6eUFu44tr8SQ44nAFlldnOd0ujaAQ7y38dVr1Lx0wQIkS529Z8I+TQ==
X-Received: by 2002:a17:903:1a44:b0:298:68e:4057 with SMTP id d9443c01a7336-298068e42a0mr86330195ad.59.1762792636805;
        Mon, 10 Nov 2025 08:37:16 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba901e312a2sm13029584a12.31.2025.11.10.08.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:16 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 08/27] mm/ksw: Add atomic watchpoint management api
Date: Tue, 11 Nov 2025 00:36:03 +0800
Message-ID: <20251110163634.3686676-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 087DD20012
X-Stat-Signature: 4ac8fim6f4b43aibhp1zrrdu4p86wbfz
X-HE-Tag: 1762792637-842086
X-HE-Meta: U2FsdGVkX18ESfn8o7K47yL9LIatiqPB1VlVvVGxU9W3XZIzsAZHou4YMCaqCa2GMHRgT/KCHbISER9J2e52wC0Q3KeiAx5XpVNBp3W7se7E5M5gsOKHEXZoHaxdtV7R/oM3F22wczTC/m+ZWf882+SWOY6BR/KMysa59rbWN1gk9YrYz+DfIVeP1Z9qoHE0qdGSOtlPdCsSsyCwLrpcVo7VCqGZwIuuyBXV31pZkPru9ptSI1S4M1gvBZXQgpx8zUHE0roQjV7fh1rL6PBME0q+kPbihMtbxGi3uFuGZ96kPmDuCQssNFVEGwgUZ3w96aaU0+L2elxtQ669SLOhfBkL92Jj0ob0kdcDxWUStWv+NbH2A6FF7EKlDjH417xod8WSDCu/udQC2SJTjcbZ+dsNC8TPA2app4m1DOg51TwKKJSXu9/2jdZfjBM8IMWykmQvjUKH2Dc4dqqPgFiftb2SfYOdY6OPAX2ULgdCg0RqXRKPdNlIt248jFocwuqQthUuuZ6gz2jPiMCxjsUYJaFXI3qrFh2WTsqpkIxwGxZ6ljpVq7iXkvG9Jd53e+0k2WkRacBNjAVdjx8XyVUprWaDU0ax+2JqhKrmcltrLDOD+SGVlX5f0GFNWoZEdY8MmDs8aUGcht4IMC+hIRKpL5O1e8HGs+6iBjNGNBfqHoEUJ7ygV8IwIoQJ65aGvYdQVyizplDfQ/5X9IcFFSaNICgZTI8cUO6uTgVrHzI7ZQVuCnxCFDvzhtMWE70Wh5N2PfEBKXaYV5rXpuE4xpy2nPBWP8zV3rVFt2e7k2p+Solbkxz0z46lLPMUFBbezSYCnzvoCVyzs1vcpb0B4fAgJ2jN3/XacPW05I9TkwZjXer0m+7deGth47H6yY/VYfpu/KzvlbM9WPqKEszZVbwmS4UN/2WJiqg8LZeVbHwTk4w8ask2yj3u35oxg8SysaHmLYoxrtHkRKZtmynWGTA
 7ACpGX5e
 FlM/hGCdEkzpvzXRFDePc1L9MfzEtLYGqJ7BUSgv8WCzWgT+ZWLpODA0sMB6hfuBOozCo/7wQ6o6CJ+jkE325vuXwe3a+WSshQVydW2XzvOdQGnPceiedETy8JtEbQVW+/KpAMNYeWYJEe1w4ORoILKWP8F72IWe6K0rJfq0+u5mzmAJPW6ewaVmHOqeiK60AiqhYc/lI1UFGTFcCSBwW/hbyGp295TlVRo/zWnx6jynfqGNBnjeMyRPZJogL5SP12OjoTYCcjCfT3N4M2q0aNHHnaAUi6pDD1wO0ofHCzzs1DxwogtlnEK7hTJ7Z3Bp9AjX3rCU2fIE1wlgFWM0CZ2Jpf+eu6k2Q1CWV3rpy7dC54bXdduHYDE3PHeDqDPUvIC+S63L3EhBQGkureCiCWdbqJIuEsGyqJEhRqXgzLjD9WlFHRw5QajV4bfzeMRL3vs8BBNejntdlSIHgUrXZnW23tQP/pn07u/xhRI0ptn4GWB8dXgCVlCbYBYK0QF7+LuijXWmsScx3EEifgbtLVzbKY2q3JWs8r8mvTIr+Ck3VFACvSnXimHiQMOIqwToxYRnKVIqLOeBp+mLp+ac3I0nI4g==
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
 include/linux/kstackwatch.h |  4 ++
 mm/kstackwatch/watch.c      | 85 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
index eb9f2b4f2109..d7ea89c8c6af 100644
--- a/include/linux/kstackwatch.h
+++ b/include/linux/kstackwatch.h
@@ -44,11 +44,15 @@ const struct ksw_config *ksw_get_config(void);
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
index 4947eac32c61..3817a172dc25 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -27,11 +27,83 @@ static void ksw_watch_handler(struct perf_event *bp,
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
@@ -41,6 +113,16 @@ static int ksw_watch_alloc(void)
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
@@ -50,6 +132,7 @@ static int ksw_watch_alloc(void)
 							ksw_watch_handler, wp);
 		if (IS_ERR((void *)wp->event)) {
 			ret = PTR_ERR((void *)wp->event);
+			free_percpu(wp->csd);
 			kfree(wp);
 			return success > 0 ? success : ret;
 		}
@@ -71,6 +154,7 @@ static void ksw_watch_free(void)
 	list_for_each_entry_safe(wp, tmp, &all_wp_list, list) {
 		list_del(&wp->list);
 		unregister_wide_hw_breakpoint(wp->event);
+		free_percpu(wp->csd);
 		kfree(wp);
 	}
 	mutex_unlock(&all_wp_mutex);
@@ -84,7 +168,6 @@ int ksw_watch_init(void)
 	if (ret <= 0)
 		return -EBUSY;
 
-
 	return 0;
 }
 
-- 
2.43.0


