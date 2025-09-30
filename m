Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6842CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1668C8E002B; Mon, 29 Sep 2025 22:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117748E0002; Mon, 29 Sep 2025 22:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA028E002B; Mon, 29 Sep 2025 22:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB3348E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CB211605AE
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:08 +0000 (UTC)
X-FDA: 83944374696.11.825DCCF
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8A9BF40006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MIwVchGj;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
	b=3eFgxQpHUW/1KrAAxIT+boDwTHyTpilPG8Wl+qqOPigAs4W+1sYEgKCGHZKXfa+e+abovN
	eRXBrhicLk5EzHOuhLEn/8nPhouhJ7S9+DEAh/E+CwZ46yOrYQTBGqNoQYNQFfdUMOF3ao
	QtWK7Ub3DSlMvc03o6a1MmSWUPnS4co=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MIwVchGj;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200306; a=rsa-sha256;
	cv=none;
	b=44Bz76CEKaVqcJwPPVIMT5ZrFoD5UDy3FD/sP/WoMgn2wzd8/C4FuYh3MqOe/S/GWfkdrL
	SXkQQm00W5xSyHSYhdy2SqqnS6JelryCHQunWsd+RWKC9pMwMEZOaRTbkYSrL7lUZj3pZq
	t5FbLDnbkvsI/Fs2q442GupT75lnPqc=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso2301833b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200305; x=1759805105; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
        b=MIwVchGjAKm+/ie3LFxwPw8kwdYdOC/MJNoUrowppsi+dAVc5TUoFGYiWkNNrmIMRc
         LqiypiytSawstLwnaSlurNHsACp6qlcC4JVa+QSfmhfmmdQ11Kqv8RA0cuKatLu5iDdw
         BnY2HoXcahsTMBT5EVS7YmeJ1cZ+OAeTier+tXp51BXhSlBAiL7owIEqOmM9UCBn90+s
         T99gzCje2y7gj0r9qJXjEwaVHXIBjdt7QFfbun+A5+pluwu92+O/hfW2mhutSv07OaFk
         wRenX0v/E9lSQnpWXJUefhN6JhpZnWVyr63uVaV6G6FDAgyN1EilOfRKqbTVvoezGqlD
         YxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200305; x=1759805105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
        b=w0iNp/67HuHCx7VFkdg4rETPY6GK3UdgXFI5dLLnvBXiK5AZreirFoi0OZ1mcGnwCD
         3NmMPr9SoU609+mMZgABBgbwJG/Klv/JwxVvfdYCBKPuY0aIlq6D0idHvNeAV4Mh44cY
         xNJUu5aZ1m9WJTE+xerZaZRj2O7pdoZ1OTRhfr6v0LplFtuOmpo9RnleFZShUg31VLt4
         Saujj6IgU2i//qJbQ59DcUHc4Z8fqQrsufsSWJzk9nr8rVdGmgrpdLSAeIu3j1+0WvK8
         nYb8o44VXdGYMdfGFqjIEhEZnVuknOQuu4NjclJ4JrH9Oncb7MftlIcHYwmOPR19KLkf
         TJ9g==
X-Forwarded-Encrypted: i=1; AJvYcCUMEDvglX+XdpLE/0ApgKEGsii65uPTUnl1XX9MyM25TAiWTigI8ENkJUoq0UFJSGJkWQbLbq5FpA==@kvack.org
X-Gm-Message-State: AOJu0YxPfh+7B6p7eOxNUHveu9t0JqlHHJ8u3Di2DdlrLgl970sqgr40
	K1ubIfs7wjkKWqeXdDjR0857J7AnXWBnrkcPzLtosOCIS5+1qWR3ICbu
X-Gm-Gg: ASbGncvwTSElzVqOcHEYEzGwn1PN7s7rvZ+hX5sLqeWwLO6rqMwMLVGgRW8lRlOEqVf
	sldTpY/R6Bj5PJ12M/jYE6mP7YkGMwB2foYYWbu/81rxx+pqaP30+WflgH2BFTVaw2xljjTGFYR
	pTO7geWSea1gGey/ZeFUObPPcwgeTYrcz6zrejB1e3Dv8XvSRNmdP4PWT+n7qfdHxFhrCx54asd
	g4PYBaPRT8LUIMlSZOpGnyeYhIUsNQxUI9OwsbTO/nfwk77gfyOKwV77xOWeb9OexpU2RWwMwl0
	fVVUF7nuKMYnBTqtjnIsr5sRL9jRKctp7AWGYvFqioyaX2eZkH7qXHvqe+029xkKDI50HBOHMfK
	pEuz8WjWKBtgXyXUwVpaIXrMs3Rqw36hzLbOsKCPmoFx6v2K2bAIbPB3WDhh2VQu2vg==
X-Google-Smtp-Source: AGHT+IGPdLJDAcFgGXBMapnRTLkbwOuAH98GZaW3SdGH9OxArUIFVK7BxMIb+p319lKI1/5kl2O6lQ==
X-Received: by 2002:a05:6a00:1404:b0:782:d4b6:f5e5 with SMTP id d2e1a72fcca58-782d4b6f88amr8934209b3a.13.1759200305238;
        Mon, 29 Sep 2025 19:45:05 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7822f628080sm6431314b3a.89.2025.09.29.19.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:04 -0700 (PDT)
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
Subject: [PATCH v6 09/23] mm/ksw: ignore false positives from exit trampolines
Date: Tue, 30 Sep 2025 10:43:30 +0800
Message-ID: <20250930024402.1043776-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A9BF40006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: peip7bbq1ce934tn7tg7a7cw9sjwomqq
X-HE-Tag: 1759200306-230399
X-HE-Meta: U2FsdGVkX1+1QAB26kq/DkPMmJjcRFqZLLv75AiGESnns3r4ZnWrVePxnKJn2KZ9f1I9dNDv5xNKJ5vYcMYTLAHN/iEkpk/6xsOYcj5+HgSx/Xihiw4KE7HAfqt0YcvfuATZOo83h3hEuBaW1CFXTy0RDkCU/SzqngX92zMXkOq6HCycb+O/psa3/hOyfFP1zQmfDqrkherSk9EM+rAar7JX9gTHF9tD+cg5zENx9Cx1PRhsnfFoP2fRJ97STVcy3wJO5bbH9buJNZKcYp7x6BXWtH6CzJTbULZE9XGq86kRYlkyTieFg+zikT44S4Et8DP/hFjnGHWRFYRNZw9bhgqHe5C5nkJFj7U+Es/RzPvLYt+Wn/9hO6Ctepzq/0P/B9nnrp13mZBitF5CM1xoNxhAU/RM4upMhJsWUkayw4fmHk9K7F/Y65QFgOiX6Xalq24qS4C6OLXEJ9f7P6GG82SNunM+EgPOgGo1SK/BCD8oYo5jERgHB7LMwdyWrZfkaetVPxbiNCaabSHg2IDQxoMi452bXdwuUeR358wTfZrkQ87D1dgvTWgL7Hc8qbtHGPqyR60ysbvx50Wi60bKjqi9FKE2oR8dodn/PhkkxHHf9/RkkkJPu746oozhgHnP6/6NEj8NG/C0dXiEU/yE2FGZh1HZTbUhFc3ayU83hwE7ceilAuj3ZbHHpJVaaB+ZgDAqdtB7APHxkvTGmMdO5Z+0CYAcTzFYZf9Op8aJ20GK05rnEvRzIfpxBrkMME/e/6it3ZnRS7/+EvZBzM/Nd6agtZGExx5joVOZBl47OKCJ4yZvXseY6DMhIeMRoNGveaz1/g0WB1SMYpYH79npF68kpOP86hWmVw9XKn7fszTlAlp1IpDOVfPTqqfz61SIGHhhvqXJ/mtLizxr2I0Dv4fWR361ix+MydiCZsuH0wV6pDiGejRgkJdshobxCMNZHcEUT0JEURkueePgApq
 wsd2fo8m
 AcNjLeKxsUDszhtjTTby00UXmbnM1rThvxWLrBYm+T/uN9wt4VQbSt6cvpOXEmkOWewC4CVm8i4ESFIbNe3Hn2eC0Mb+t7tdMR2XxST1ylHsQ7I9sCoSFgaJ8hjaokfHpC5LhTB0XU8m9g3sifsRpByUw3sjNWk3sj+mtK6Io9+zs5FA9GUBeGpEgnRFswC2R4V7/pIrUM586P1EcKfYNPr2wAeJPaI5NPgtjq0HENk8B2s8AnmznthLUKDoYAn124BQEDiSUSdBAXp1sg358xACgyyz5FKDBmI2nr4hJ8myo49be8LsR2GQ0GIRp3eFQPJsnKKC4lkI2wYielwOzfCKBRZwba/6/CHTF3OZo8YLHdOMoqJjbx2PvmkmekjW+rz0P9GhHel7hhbeqGVqODlm2cjAJJHNDNwcr+Xex4lt4Uf9oBNMTlf+mSfZIbaYhUf6f4doxDskXXonfSbITlHzTLMiOxZU9DZ2kR0PW7A/cPETnhU2W8ZqsKM/Q+6wqUygfulsHZTL1D9nJpP0wYqdfgmyzURV0Env8T8aSxd9bnlpR+BSWTpAHi7YF5G11aZiJtOfSludCnBBLUpoownpe6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because trampolines run after the watched function returns but before the
exit_handler is called, and in the original stack frame, so the trampoline
code may overwrite the watched stack address.

These false positives should be ignored. is_ftrace_trampoline() does
not cover all trampolines, so add a local check to handle the remaining
cases.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/watch.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 887cc13292dc..722ffd9fda7c 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -2,6 +2,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cpuhotplug.h>
+#include <linux/ftrace.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/irqflags.h>
 #include <linux/mutex.h>
@@ -18,10 +19,46 @@ bool panic_on_catch;
 module_param(panic_on_catch, bool, 0644);
 MODULE_PARM_DESC(panic_on_catch, "panic immediately on corruption catch");
 
+#define TRAMPOLINE_NAME "return_to_handler"
+#define TRAMPOLINE_DEPTH 16
+
+/* Resolved once, then reused */
+static unsigned long tramp_start, tramp_end;
+
+static void ksw_watch_resolve_trampoline(void)
+{
+	unsigned long sz, off;
+
+	if (likely(tramp_start && tramp_end))
+		return;
+
+	tramp_start = kallsyms_lookup_name(TRAMPOLINE_NAME);
+	if (tramp_start && kallsyms_lookup_size_offset(tramp_start, &sz, &off))
+		tramp_end = tramp_start + sz;
+}
+
+static bool ksw_watch_in_trampoline(unsigned long ip)
+{
+	if (tramp_start && tramp_end && ip >= tramp_start && ip < tramp_end)
+		return true;
+	return false;
+}
 static void ksw_watch_handler(struct perf_event *bp,
 			      struct perf_sample_data *data,
 			      struct pt_regs *regs)
 {
+	unsigned long entries[TRAMPOLINE_DEPTH];
+	int i, nr = 0;
+
+	nr = stack_trace_save_regs(regs, entries, TRAMPOLINE_DEPTH, 0);
+	for (i = 0; i < nr; i++) {
+		//ignore trampoline
+		if (is_ftrace_trampoline(entries[i]))
+			return;
+		if (ksw_watch_in_trampoline(entries[i]))
+			return;
+	}
+
 	pr_err("========== KStackWatch: Caught stack corruption =======\n");
 	pr_err("config %s\n", ksw_get_config()->user_input);
 	dump_stack();
@@ -168,6 +205,7 @@ int ksw_watch_init(void)
 {
 	int ret;
 
+	ksw_watch_resolve_trampoline();
 	ret = ksw_watch_alloc();
 	if (ret <= 0)
 		return -EBUSY;
-- 
2.43.0


