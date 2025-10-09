Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D70CCD18C
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF198E007E; Thu,  9 Oct 2025 06:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB18D8E0002; Thu,  9 Oct 2025 06:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB508E007E; Thu,  9 Oct 2025 06:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A94688E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55AED16080E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:42 +0000 (UTC)
X-FDA: 83978275164.21.B58AD1C
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7574740019
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=biDM032o;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
	b=RP30pcivh5cSYWGdayDucnUcL8v8APu62z9SZWqarEHjHwDCYUiiqCBgEc9RggjJKsEujy
	UYoj2sNIeJGfklMGFUKCIx384CTodeTx0C79X9EL/+ttZr6IQnf3aoMf74ublgaZQQTn67
	rhEUvYmbg1wEykdPmwzHx+6kwt5kLhM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007460; a=rsa-sha256;
	cv=none;
	b=2u6/tMd4Jrt7sntT7cu8r5yMzsJz5gBnBq8TUi06k2l+I6yjvhP+4vI8ry6SFZ98ZaYbbt
	l+Wx5QvwaXeA22bherBuAH9QczTQ5AE+aWkExCEx/AeFyf7ak3GnFKlsZRAIGtkMVW77Bx
	KvNv2Jxsozc+qMIqfERtLJSdfyHUYJA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=biDM032o;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-781997d195aso575777b3a.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007459; x=1760612259; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
        b=biDM032oLRERC44iMnezQ1SN7ghGmLENVx+YBUmTekGjKP8G4kUBPrQVQ3rScr8d5b
         dOJnpV82aMUWfmpO6QXetpLgZvDU4/hXV/vmU8HJtsmsCtRivZsSHQZKcxpNp1ujk78w
         EQl9eXrkwdYfjnmP58G1Rx7OW6xV2gyxN+QZ4+UgNW+yFuowfc5jcL3gLWXWWiYcrD0E
         RJ5/XHjWHTqMuZFDCvtI/rlZiXWr11Dk+f+SzjGQF+lJgZjroBpNaeiUKRiY03s3g/kw
         g6ezZlsQXmyvEFYOyq8VpByywkKIjwQffPt6E4nd6YQIrVIBNGIyuCMX8NaSj3+5ByBb
         XHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007459; x=1760612259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtGUQc6HOhuSXywhIDZ+AUqHUInlRCKup6JfN/4+ZEc=;
        b=YCHYtT22REFGsi8ORKSNevJkdBsG2iUTrntF9Oj3c7f009amOD+cp9H3gr1edDxARg
         BdhQK6T+MI8MbSJRSuIoZo6Z0T58YH7h7PTpLv9Xe0d/1FGCx0VO3rBU7TRoDuRsIA9C
         vbE2HW90KQtZ4e3E3R9Ho1RgIJL3CJaVP6y02R2IGOsGM9SExAkOytydhkQeGir0qfAt
         0k2igmg5h6i7OnrLt21P39Yj7fZqnHwlvNRwLOOPcd3nNvvoccxDheDYP3CEErHGZh0A
         85CD53bLt0q78UASo2OA+L1a9RYJ/YU4tUWCEInO7oc26EljpHBttYksIvjgmMKZQ8sr
         Y8rg==
X-Forwarded-Encrypted: i=1; AJvYcCW6Uy5eN65yBrhuMcgseCTSH5nEXkbVkY4ZYw5HJMEg3T5B3mmYdRPJ10kD5U1Ft06cwfy8CoKPEg==@kvack.org
X-Gm-Message-State: AOJu0YwnuIM61zLkhqfWr2abmYFSoSw38IXJBOfWJsQtQVyv/OfS+BrK
	Q23lh/f+0rDjFT8ujQkkPJk3yqhfziWVzonqY0C3Zwo2MK2IkxZPdjo7
X-Gm-Gg: ASbGncsEi6hfCIjVHFVDPtjxDYILd/T2YWNpMpuhQrker1vgyW6dhLyflOzamBcTNrr
	h3h75lLDpJqoGcJ8JM7nTZuytTmFo6VhD98WnMvpqv204pISI61ZrcIOJCbeXr1yIkiv90SRsaO
	3qV59Cf6OTit/UNgxaMyAwrJZh22W4IvG2e49DkP4ZuYPb0aab7P3gAATq0NNk/F3nHx7TdmpOH
	kqHyKAAFBazozgtut8ND3fh5DEWqjFAJlnaF1qL9Rz+up8qwuNTRpCJsIyglYDphA+fBqoF4p51
	pehuF1+LnXO58TTTv4OtDPQOE0f57S/TVG2aXEPPfxGB0Q2beWLxQ/QaJwDoLZ1FUUlG0vVVa0j
	6R7aXkdp5YMtHYaoAk+tyOr8EGlDCoqcuPaizP4gjSlysDwigfZJfWCPTrV6u
X-Google-Smtp-Source: AGHT+IGScwOqYQkzfr1btEBby7JhcFialvxPDnR54idjLQKUQn1BKVR6wxkZwyfRnUOrnLGfKhhFqw==
X-Received: by 2002:a05:6a20:4305:b0:2cc:692a:3a30 with SMTP id adf61e73a8af0-32da8154253mr8702045637.13.1760007459212;
        Thu, 09 Oct 2025 03:57:39 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099f3b041sm20710766a12.24.2025.10.09.03.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:38 -0700 (PDT)
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
Subject: [PATCH v7 08/23] mm/ksw: Add atomic watchpoint management api
Date: Thu,  9 Oct 2025 18:55:44 +0800
Message-ID: <20251009105650.168917-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 3jwdn1jys6qfdz46xrhq4jr33yhh1ipr
X-Rspam-User: 
X-Rspamd-Queue-Id: 7574740019
X-HE-Tag: 1760007460-496337
X-HE-Meta: U2FsdGVkX19kbIpIaUOpvsTFS3usDLMji13+zxhnXeVdTCmZI3I6RPtcMtDzA5DVpMkKA9yKyZWb/9nyDLTLk3N+TqjoE+tddEHB2/S5TZPcgBhnB8HlKsGi1cvmfERkcHJaJkjlRwjDdvCEIi4D4OVrDZxDPVLG7zyMx6i5EYX6/Q+QaGKCAGGX4uSawM1txQOet3iZ4+HcDFHoiPQUXDXc57Q+zzRzmYIoV/qKH+v68kc+YTBygsVN8gifqGcWsoM0T4sodpU/evcXA5UU8r5FBy/zEll03PfSmtfCDAZtxxF+jqtHc3XOBrkz/jAeuC5PgZst4/SSsgGOTpKdEIVVgdTAEI4DltgJ0AysiG4n2ZTzBV4P+aiJi4EfgH3mlECzpz5tU77/mCbGkq2o/FmyIGhfKlLPKNpAT1AiQ2HBYWGC1WiwBPIReondYevtLdC0iXZghBgwY6Ho314pwhFskZCEpm+6+DFqHPTvogaHngcDwIIXK8QvxPKVs/CbpnL/JmDyxMvPS/CE/QGRY5j2CDOAwUNNnbCYkTLR5eetNUpiON2miOPkJGWxuI5SLAgM7ptKaMQEMeyvVXUdkdniNwOZyp7E9Lk5FanUzmBW7vHmAYjuNhhupOO3j/NYkkDSPUd3JWNALPcwOZKIktfUKrDKSNIhG8eQeuJljaVeP/vAshIMaLCcgJhnPVZSgA9KPK+/RvlJljtsnZyeRdHe2RneD5v/WXI1y+oV31aQH/OlyVr8coOZPjQhhN2sRDsogk3dip+gMwH5UQF+m6Ya8ow1rkDaSGSQQxZNQZZSLhLpjWm7i0adsNVakCz2V5kF+3XQRL+BlXB0obgla6NyKDDcSD7VG7dP8d1C94K1BFmZJaR9/cEtQS7auIjZ3/DWeGE65avnlbqPpki60LZokxPhPLdRhd5aIG7P7vH52vnbJJkXuLPoErrPPQM+7zyi6qy19jofrMZGG1H
 4fkyIO5f
 7zvxVY3H9Z2cFFrCanDaF/JsWKO3TQ3TmP7Lb9wbQcBjNYOV8TC45h9P/aFlC6opnjH4lTlvBM5ac6D/Zk5xdmgE/X6Tn2/m6K+EXg2y5PseL7SXFxL+D0R1l2JM8Bcz037UDJC7Lu4lRkZa4T/fxh7gil2/2V6RPJCkYipB1ElqPJoAfYWoF7JrYgUso85D6KYSaxvQkha7se7nSlvFOf1p+OKeDOUUWefTMp36FLarM2MwigEf+XRpQmtkIG1ZrZdwJseAZ7RqiIWxmf4Qyk/zEB7ck5KLA8uTXDY02doCfBe7FsAKL414nYn8uq0/FXl7s60iITNX9Ys1+3gyG9tu+Gbq4Fv3ZI2bAqedlC+AHfvoUvgj1eBf8XTcmGWyqdkO7NcwXViZxs2O4PNF8lnVTzeddBcrf1OcRJdhHWWaZBzGorp8detK1OCVKQIXjm+kj2ywzhNVYUXKO22ujMPzi1LLDyptI/SqWPsIEjAVLKJyY8ZF5laidsxg2XmZ63DGRk2foVAMsTRI=
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


