Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F038CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA1C8E007F; Thu,  9 Oct 2025 06:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A678E0002; Thu,  9 Oct 2025 06:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943968E007F; Thu,  9 Oct 2025 06:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 808FA8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CE8F16080E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:46 +0000 (UTC)
X-FDA: 83978275332.08.B8218CD
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D7401C0004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M70petIx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007464; a=rsa-sha256;
	cv=none;
	b=Y1Pg6pMXcCfcE4DaKATl5uh63QiLXaJnkLpuF9qZlMX4QHCk/u/bRXi8TSBUvUqRCE4I+l
	HpbBLasL6SvHGPRopq/Y2AY3ek10NkETcaWM3RURJUfr+rPp7DDKlksiD+H/V7ytlWr6ng
	56fZ4SnRVUtCfXanWB1jpYmNgPJka/E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M70petIx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
	b=YVF0m3h+f+6hoxGNYCszr+dmIojCn+0LYOS3cdglV8zS+KlfYDp7lgrYz+mY6PO7OiSAKF
	pSGqvidlRRFDpZIc1l787ESTCvtAr4h7u+rImk58xU8ZylGc6j6zG7LGYmgEeNFrhoCXmz
	juOehMrfpztyEd9TbaRw1A70jGKW3k0=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-33b5a3e8ae2so508841a91.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007463; x=1760612263; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
        b=M70petIxaBXkxJ0ZmrPa3rtaXHpwcqr/bbL511Ra0whiBC7LYGvsHEWeXl/eC4cJG9
         a9mQ8HnLR+cWm82eFC/iLbxNc0O9eDzoSbAhtJAS5FhDUia61DzZgH5nxAYwq1V63573
         b2RwUIvlIN/HoSw3Gmw+x8mL4JFcD8AT+xiwIHVleHmT5D/pY3CjVT/hz3Vc9vZqZCdY
         BVqRVXzUJQ6mDmcszJPf8qktlEK1KGWEAollhTZcKLvgueNA3WRZXWVpRrTe1VKHnRIl
         6wVo5gS8dM3ec5AwjEW0EOCM6pUf+wfnPOm8tqkaZ3qQlUssCc8TSD96QbiqD8p1EV0G
         hFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007463; x=1760612263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
        b=GSlIpsUlp6FqiJBSwCY5cKe01MfsZSx23mt5m7rSdmzitLsIip7a47gMn1qmaBrjjp
         r/op2MN2P/9en4nHaAfIKVMN3S1+JF0pcPjh+w3ouhIKNtSRP4V7B7ZAyNR+4yehIre1
         Q7EhNRSxuj/xLw/pgLekXg7bc2X/SsVshq8eWfvrj/EehaIy1omhKRxlJggnnLQ1y2xs
         RdLJx04n3yIPJKouV+AB6EF6RivPcNe6ejy9b7N4rzepzL7ZjM7bPk2tvJ11B9ryxLrE
         chZri9lhLfG8MgzEQWVg/fzMpsuqCQxaAyZZv/kWChpatlOPW7VvtBYTT1zGZnpRHIgL
         oLrw==
X-Forwarded-Encrypted: i=1; AJvYcCV0r05QQLWV3S1SVIvDD60Onnis9gTjOtC/+Hnr4isNULc81Pj31A3u4TSETm2CjcHxMv9wv58KPA==@kvack.org
X-Gm-Message-State: AOJu0Yw5ONYDbt043HT+U3Odo+thRzC3tdcQPBOF7D/hTjbWsERblaU7
	Sich1WAevjnz8wgr5yadtZqHBaAgV4+Lz3L0PMtml0O7UHmcXVxKCLMx
X-Gm-Gg: ASbGncvCfGPzsmRyoffbpLUMsUq4+edwchL+dM6Sq/RH3M0233JBVHasM/c//xgV0Aw
	kBB3qn9gNNQIoB1s6pL4LhkYaEFp8wbv/HgjEaS+QxyNkS1G/Pn5ScZRiv1CJvvslWXy8DhpA/P
	oqWy41B/47AI8vcfQfFrhQjkx3o5Fc7KKzvATEIgc1CHWwaZkFVXEDJIM0TJoxM0z9I0dIzauLc
	OavEhX6oDNYK0aiupoDyc2QWswuchu3dQgw/ndrfy1z/iM0/lpkJcqPWPmFx+Tmt76LaT+8bCMV
	TXw2GDLzbkFlhORuADupcYugiXdqiwkYpD7B4jCw56dv10bAKN3XpznISbKci4b9vEna4U01aOP
	FRgJlgo99UbzuScU3ziov54SD0Yppw/6NyzoGUQDw84guWSZHtK+MAePOdGU+
X-Google-Smtp-Source: AGHT+IGh87PYrVHyXpdGI3lpiqctQ3hOQgwGz+QU0SKFptl527HtAxTN0ZxVB5GZOA/u2hsAdulJlA==
X-Received: by 2002:a17:90b:3e83:b0:32e:23c9:6f41 with SMTP id 98e67ed59e1d1-33b51676ef2mr8250254a91.5.1760007463200;
        Thu, 09 Oct 2025 03:57:43 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b52a4f8bfsm2196325a91.10.2025.10.09.03.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:42 -0700 (PDT)
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
Subject: [PATCH v7 09/23] mm/ksw: ignore false positives from exit trampolines
Date: Thu,  9 Oct 2025 18:55:45 +0800
Message-ID: <20251009105650.168917-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6D7401C0004
X-Stat-Signature: oakippjf6mzkqywrtjsnwncqwzbazqk4
X-HE-Tag: 1760007464-862319
X-HE-Meta: U2FsdGVkX1+8vLYjvaL0O0011Q5D2cEu5yoZMJx3WMLOFA9wVTH2WysoGDl6n4LCqKIMST6EelI51GmqPKjpKf/zfamWdiove7xkPwt/u4JTtAyi91F8kcVnZfEYYwgI2IpI6myoXe4Y03EUPX7LzpDq1aTq/hQbSPhVxJ4Aj8xMbD393RXJDWrD6BQ+ZAONHcSKnYaTJ/71uKNuhQqV9rPZArQ7NG02qv8ghhVUuIW4UVLRwU7FKHrhD5NWpFB75+556DnxXFwu1rNuT0KoZqTUozadIw24zr/PLFYfasNBe3Xh1+SGGI+B/WOc6GHU4RIyzeBQNWekrNUFdBZ7RHbFjT8R4mukXrUALecJ2nYLaVzoBK8WSD1vPIr73B1wkildbOjlPFcuhtqVTDRgWEH67SOI2iQYvIcDI/N/1Zwx4Aip7qssToSm50OI5ZsTM7Z9HeJeCnd0HQo8fKxhd0Ien10H+PVY/+gdWU4Q8r7Vkpdr5UJETNXi+ChhvSOCEDYMMPHwTILBG9ShuHaJfVdOe03BNjzgN+s/5lgN2UXpnFyDG4IrK3GeVf5yx5Owrjt7xHawsVtk9xtFxTSWnhDSzu1wpVvOvRITo8ieEpmwiXoPbM3tbrT8a8/y4TuBO0KOAnLEiBkslY8rfMJmIfCIJRgP4gtCBW5okXghSry5sfCywGMR1/GwpMYdk0ifxsipwdQQm411UU6orB0nsEYp849dVbC0thlbg3tZuTzwa+SSzUaEu1KOaBurlP78ADCMg8Esgnthzw0fOoApdqKOC+ZHvaENlKRnWpRSIkGUdhac7qljlU4zkA3U6PUZv8L/JDVlpu4WJeLfG+OB60AGkrKZUq/XPh451TZ8RRKBdjzgoxdfW9vTIh7sOoutmTIV0RLCMt7y3g/xB9lZRwMwETLTSZhv5t3ea3zMAoQFhGZLN87eBH+UhPYJU4c8MKfrHX9kWqlRYTSEl26
 URdr12GZ
 1tCXwXvU8D6bJj8UzQqOiN8zZ3W6o7h8WFBAWud++JSOuP5U8Pl9RzSqgnSwcYXMZkX8GRwmbFKBoqGaVEh8bpV/1AihJ0toP37JJFAMHJoQNgYhT0P5fiwdXOQiOY0ZLqWyO0NV38vQxpvKgPb8MMTchANbOPvaku7Rm54pX8vmGDY3IfP1SA2/I2mYvAeZD3wl6X+CcII+6HkbGTegw0fJw+z0MZBZrUIbZEj/VB1ah7btliLSgLQXdiM+kHnTvJtH8bi6rrDBKAuaV5wBDxFN/VggkLfdPFQd25dvmCjxzNj9YEbsS0wR0ggkay9Q+4vGnu6vPiw7VavbJdT7YqAB1iqkE+xNpK0vnP+RQ+DDmwnGno11nnyXyXNlS2XPSsXyxkqpRYWu4cvp5j6zYCP7Q5OwbxOX1f3HDn4hOdL7hkvH6MuFg9dOE6mhUEbw80I7uJGPSbe/lCFKU4GZJXeh1mngSMSk7ddQMYaCP8ds6Otz3K3dI0GG0IkMBbOL6mXSrkNACpDpuAHzDew/KPuPimBCc52AuFqyqb+eLOZMm2v7fTUiDb28Oz3iKtd6UwyOkOKYHy285whUeXuCVp+vrVQ==
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


