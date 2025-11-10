Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC51CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE5B8E0042; Mon, 10 Nov 2025 11:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6DD8E0003; Mon, 10 Nov 2025 11:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48DFE8E0042; Mon, 10 Nov 2025 11:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32A968E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F33D71A01D9
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:24 +0000 (UTC)
X-FDA: 84095252808.21.722DD27
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1732040002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HiW6vL5n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792643; a=rsa-sha256;
	cv=none;
	b=mdfeBXJWJS8KQUHyB8bCSKO26FtQxPrn/QHGXDQD9Ae8uO17L2xViXSbnRjoxSMvnfRxVM
	uUgy5SrYtj8pZuJUEGI6I6FaBY1aV5Y/BOoxA/8VO8BYSz7uehzSKY0yx+feKS+6qKUatw
	xrosIEXYKQt2htV1F9WJv5gBa9XoNkA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HiW6vL5n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLWfzYX4fFMPPLWMDyPb3KZEfyFxyFdWrCERfTSFQ90=;
	b=wQvTlx/0URyjnj+mm+Jl9VQLeicbp+J87qYzjLdnSZUTp88Ir9xSVxcke9uDQXZxrJgIYL
	XHN9YkL6b8uuRgciwAW70O1gOZiaYFKi+fZRC7NpcCDy0SGjjATMvEuIBxrEYiZKlO7L7U
	aRl3/6NqDdpTJ25bswYzJ/RoBLGtNCY=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-297dc3e299bso22252305ad.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792642; x=1763397442; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pLWfzYX4fFMPPLWMDyPb3KZEfyFxyFdWrCERfTSFQ90=;
        b=HiW6vL5njvszXroMUOQILCHX3QP216mIjmtRjg3qEb2YRDuMAIdsE0NUeSPOet7ZEH
         D+HgOE4da9hVTRxBhSqbAIWZdq/wlaBD9TPDALmlhCRuBMycIpznOdtoQyEDwol5fes1
         ty+2rFE6FH9xhZ92JjZsRdEDX6fRXLDj4nXXSeJfdWpttUZDp/kAksX2UJFV7H9q4wT6
         90BWWsuYT8nPJiqwedATiCZxojYiHfYln3zlTOnOCBxhGvPZHzuYTLjUAc6JbEcvdnTk
         jibLxaPGfPSrDO97ozBJUrvn9jkxbnEBWjllxehBWBBA7ri3klYsLzJmUNF32DHMFwFu
         KAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792642; x=1763397442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pLWfzYX4fFMPPLWMDyPb3KZEfyFxyFdWrCERfTSFQ90=;
        b=IaT/Psb0TNJCR/t8XgdbBuyRj7GsLMEt04YGS0USxpnSbLz1LrlSxwVhcGVRz/DlXv
         5K3EmQlFeFld7EVWkRL2R2dSaTq8mwtW2c59QtgcMs4LZi5OBnSef1JRuCvas3WeWsNZ
         c4/wsA0I4C2rhZpqBA/wu/SVD5ImvyIc8LBgVOlbNF9GOASXW8261k5aer7nQv19JO9R
         6DnNu/XF87PQSbQKnUsPjfYhZtITzxZMpVSsPWStveTZvrMsLq4+10Qo2QhBwj8RvMro
         EKVfcwpqphqPgzk9mdIHRGabWeF5LGsRBUAD8h/zMxyAE1vn8JDZ9O42O+C48goQc+4h
         acMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWE/pb76wBYEYym+W67UsrhChSwhjg/umAfIcjHc6+jHy6lEF1p2Hd5/f/jB4IoKhFGlk2E/zOixA==@kvack.org
X-Gm-Message-State: AOJu0YwsWZD7P/KcGd3plY7MTisAMoiN2xl5kz3/i71uCMFegdHqR3LR
	yGmrOPM+St47pOYeDwqqb/g+1f+s4Sl/V5dkqYXYaWtplQkk2JjxPlK9
X-Gm-Gg: ASbGncsDfKfX5c/Owcs0hxwdRJo8MMSGrRaH0RnOpPA8C8nSbbLxYBlizLibh+Hl1Yt
	CG3K9xSOvlvd3STAmK7YPLX7uzIaH5LNTTumfqUdR+KxyalEg9M4nzDWOMq8s0v1EU9uwAyELCC
	98e1Hd7CKY9mDViP8jOYbAAJzHlIih/NKPh51JpyRWskQgTQsLLdZ7Hc+u8BXX4xThnBtBRSOyx
	zxkCx/Mi5B62vwddVBiQ1AewfoEC1u9GusbA5iOjt60BqgOJ5l3KiwjjtXA4blwbkJDsljKDQ8c
	REirptyq5aeUnUSAo1rZj0ksD8d1JFgZ2kZOIJQBo+Nl+2dOsn4h/w9Y98H2qq/YxmchDp/QCtW
	2tka9/uW4kUgRcn7FG9OZV/2FUHXtS5UWvp/1oboiW9u6qwkcmC7avSP3iEA7eEUJjf+PD2b2t1
	iPaGOKYRsPT/Y=
X-Google-Smtp-Source: AGHT+IG/cFQI/lmXu5Y2kAApFRNeOGqv88LbladeQ9d14Tfk1RPsTiArc8xlLuvBlu4N/APLeeqQog==
X-Received: by 2002:a17:902:f791:b0:297:e267:c4c1 with SMTP id d9443c01a7336-297e5718125mr109122315ad.55.1762792641884;
        Mon, 10 Nov 2025 08:37:21 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c740b5sm154589925ad.70.2025.11.10.08.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:21 -0800 (PST)
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
Subject: [PATCH v8 09/27] mm/ksw: ignore false positives from exit trampolines
Date: Tue, 11 Nov 2025 00:36:04 +0800
Message-ID: <20251110163634.3686676-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1732040002
X-Stat-Signature: qr6js7u1ceb7xfu9zegb3kyzcw4cds9x
X-HE-Tag: 1762792642-478348
X-HE-Meta: U2FsdGVkX1+RJJv5DE+HGefyejAVc5tF5VCIRYCG+ZNPrPf6CFHno5TgIKGCU1nCkeG0HIjcLGRBJJT6+YMH3BIPsHet1a3+ovKeoEYKCwHGJ4j/Tzr+yVPPdl4fSagBdrBAIFqnfLHNaV3JuP2EQ3DiCEGf+KcKTUK7BWuRx6dKSQf7BtJnIEDFxOot1CweJupLjf/x58aVS3RL39bt8De2Y1DDFZnu1MJ1kcd8INDD+Vbo/DHkOXpC6kIoK8PeKR+HU4Ce8APF04O8Anf4WSb0Rv3ZK3Maxau/IYf75iUkHup92KQwvij+fH18R3VN5SoAbU5KhwWRmkK88qFbjQ5Xca98G8GrN/50SM4vYSBYWKwnVEQOIyPKI5l7cLnWEHsDPZfjDmdmu6HbVcfBCZMj8MWws4p+xkENhM+2xR5Yd3NMhwFIJgE3RXTFWmM37egeo7xf37SUfhDAPd+RC8YyrzNZXkYyr+xLsUrvzwFzCqr+jRgWjQbfStx9vJTvFmNKzAQ4DCCVNcjO55xiGwEd4Hi/j6wJE/acSzwTWHhVqFFISo3Ma+rRre5BUkxjALInCcz7BrLHtRNwKxrZZWWnBs7hKvSyQroSuBjbasBlo7+QQvTqhhDlOY+SLKMMJAET7eYSkjeIHUd/cGU4j1PL7FsNAXOP9XIZpJz0nZ1IKzVgN+lCHFpVqlNY4J7cykPsspt4wM9XPifZXkt9KUjZojjJ1vYfi4+mgc9ipwgipla8rXw+qRwETy06GqOKQ4apgiYtMDKQ50IEb2qccs1bji+lbIW7RAyF90P6/fSxiu8BCZkykbLCu8FNw51ByzleRnj/jXw7cE39OOYrP9cCvf1ZgIeXmiGeI6vxXywljGKBrg+RDHYWXV32UmTiWk60IgOyrb+IjFrMyLwO2vudCejfVGq3PBA61Gw6jSPXbStoxUi9jxlqiqPyeu0Ea34G/kf6A5216yElZeE
 gXPEQU4Q
 YDS8wV7pRjNXmaD47JruDBVWWnJGYwJvwb2L6cGyjr/TRIcHqYMzJAZXFs0WzLRMTJWr3efpjaJ/ubmGHOG6GbXO5nsgykizuhuRM/ZdH4iWRt9QD7m5fP5lBbVHpmNpHVJ4McrAcsFCC3WDHxR70ALUdVH37ZfraZRFNXhr9LSPALTBk6k+Lcd/lmso+8AeS3sH4NvY3d36VTPci+rLPUwvJJubWDt9d3Tj7ArwR3kpuUb7i7wMnRCAhs32hcMrn7b7k/HQq1FDBkNfT2crNiFGiTgjDxLZKyihDFhURb9VYSp2Vg30IAA2FFzNkHuew3FskzuWTHREVW0a/jstClVek7G1LGQ22QLk9O2WNt+5grIrhNMFpWJxy4mphgLhjZS6nkLINgTHulj6U/sFqTPc+YppmNXMaW65FWDaiJ/g73HaqTDjYvpORheCXEgrdRyft/SJE9ezkegvF6NCAWkHLGLYBUm2owEoOa5XpdhjfCAFM69WCLiUH096bJn3p29zYYlNWGHTjTGy7Q3e2nojEQTs00Otzoc/Mo+E8McnN3zNahJTFqlnU4A==
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
index 3817a172dc25..f922b4164be5 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -2,6 +2,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cpuhotplug.h>
+#include <linux/ftrace.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/irqflags.h>
 #include <linux/kstackwatch.h>
@@ -14,10 +15,46 @@ static DEFINE_MUTEX(all_wp_mutex);
 
 static ulong holder;
 
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
@@ -164,6 +201,7 @@ int ksw_watch_init(void)
 {
 	int ret;
 
+	ksw_watch_resolve_trampoline();
 	ret = ksw_watch_alloc();
 	if (ret <= 0)
 		return -EBUSY;
-- 
2.43.0


