Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC776CAC5B3
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352868E0013; Wed, 24 Sep 2025 07:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303278E0001; Wed, 24 Sep 2025 07:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A36A8E0013; Wed, 24 Sep 2025 07:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 044888E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2EDF1407EB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:10 +0000 (UTC)
X-FDA: 83923980420.24.1BB0A70
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1156A180012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XP54wnU6;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
	b=HwrHR+ZysUNGfBgAD150YDGAJxBshivwFjbdeYPph4b4gMXhr+3vH9/PLfph6gpHdMh+AX
	4BCqIm27CqjQjd4mM4EbO6ZF1Vvyhpm6QnFK9UZlCjDtythxnf3BuiZ9BBDW2zEcnRe4Au
	eDVDBgqBt027d3FLIhSxbq1DhIdVuog=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XP54wnU6;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714729; a=rsa-sha256;
	cv=none;
	b=gRGWpHinLYb/Wx00+QfVtBC2DhcGAG+SbzkmqIcBduGfOdG3HpB+6hLzAhugrDcxUTSfU5
	SHVCzqmJFVKMUl17atCBVhKa5nol9Fwcd51UezdPvmoQD8L2H4vyBO7v/1ACpVMHn/j2Hi
	NP6c6wLw1ssfVAaCXvNCnPro/WVOZKI=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77f1f29a551so4642293b3a.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714728; x=1759319528; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
        b=XP54wnU6HmpsdPB+8oRntibGusY8JUJWko35nZOX/QPlwPJis3LGP2ALpoCNzXbygn
         eL/fNF91ArykEbVyQuSTJqTAfiY1FV04qjBiYsE6niZfQ6Ldw7FNUMIkZ5Xu2EZROJQq
         zAzS+EmhI0DXX+WrKraTvRPa63UAtsc2U6oTcttVEZiFh4kcf9sYaZQLA7NRdFxWiw1I
         COjTBl1OsPm2a5q9YwV+ec4x44EVU8Y3WmZ0laO/fjPos51g+0TGG5Bp6+wsncJzu0q7
         tkJUGWmqPEUwFBR+HZMw3iI81N9JHKr9znGws3kVN+0ZN65jXn1Ool/cDhm95IqVaFPN
         A1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714728; x=1759319528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8p2Xfne7CGpLjN/MkaU3Ee28S3aCNgQ2oxnJpFebIbs=;
        b=pyV5qOyFpm4pDCzu97prNXxVIu6UZkuvWKxBbcLTzHsYztyPfBy3ESEOU0hmScRg8m
         7XxDdDiLEy95bmAslwWai6shzLcudb3flgW19lyxmekcOcoMKIW1L1yZJLCFoaevmUfm
         8rlRC31n5tkFcFCI3YTa+RD6ubeZWpXzo+eZhLuLABhEcSwGbrf1tJ8qwlAZUgFnveem
         W7r4MOHD8caKWe90FbKgIU+tWJV/FmQLmYaafaqKUNStDtCYkY4rCHAHwBf7FSqbc2ZV
         StEpnsMOTk7Ca/SHQJe+tSQkRPnYZ7KhGLC6TjroXpYat/lxNNWg9QHdkIaZG8mBDD5O
         rjwA==
X-Forwarded-Encrypted: i=1; AJvYcCVjkhjaQ1HseoMEkwijnC9lXgaDMYsUJVVgKg3r+2W7nL80bRErt8VwvA8jP2IBEeog0t1v+EoMIg==@kvack.org
X-Gm-Message-State: AOJu0YyEms/brPHYjJNf0aAf8yh2ALA5XAmFIYAXDDGCH5niCJc+DZpk
	zcwZXl4UotUQ3exUUWjzTr/lclRPtYojz7avWCgRjRhxXYaASsFwyaOI
X-Gm-Gg: ASbGnctTEtqqsu1c6u9Svy/neK8fLYNSst9akqBypDpXFKxZaoaV80dv2DakURitDYw
	rOIp1nR8SKuhLinvc+efwdlmIhV8Efh3J04J2ESPG3VqFv7yiwzZS0++grANUvE+eV2tBb/nRRV
	uZoeZVX6ejURtoRZTFWVRrfUAFr2gOb31CNfhZAD5MY8Xy47Nm5gImpyIEbhJrqk/fcDE1kKCXr
	MfdyiynEjQof2bWl4aJ9B+C/v8d+hp3grQs8wASOR0S5XqLGHlHoTLbxKwBqGVVogRLN5BJ14jq
	Kewr6l6lBJLRJJXub1Bt688rYpKMu595cICxTkZnF1ghvCcvwbokyVNGWvfm2nwCqYUy4gV/YlF
	rhims8aK+fuM7dtNCQ3fXmDOrJA==
X-Google-Smtp-Source: AGHT+IFvFtl/EyZ7iXrxXzX/exhl4mgRDo22qwkFSgnKL3W11UaAqeIdwbc9uDs1HMk5jHchDAVYeQ==
X-Received: by 2002:a05:6a21:99a7:b0:2b5:9c2:c596 with SMTP id adf61e73a8af0-2d0009e2f3bmr8556644637.6.1758714727810;
        Wed, 24 Sep 2025 04:52:07 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cfbb7aad7sm18582634b3a.12.2025.09.24.04.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:52:07 -0700 (PDT)
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
Subject: [PATCH v5 09/23] mm/ksw: ignore false positives from exit trampolines
Date: Wed, 24 Sep 2025 19:50:52 +0800
Message-ID: <20250924115124.194940-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1156A180012
X-Stat-Signature: auqo4p37hqz8ebbmibhm7bswpqp9dy8g
X-HE-Tag: 1758714728-302572
X-HE-Meta: U2FsdGVkX19wpWVWnj/wQyd6EnZEhEnUjUqNymVGg0Sp/K3OBVW+dpCPDqe0LcG0YcNHGVnkSdJpSbB3dWehZ8G/ZP2yHsggKqy2poXnJO0DfoxaV+hvIZPM4vT8sR81k4FwVEanbVV4cednz97Cf6ivn777ithN6g5O9tGAHL+YVo57RZ5FF35OeIgPrsHo9ZPvBO+iT++cuHeqDvy2vqLXbOJzWA9MdVrqzuCtffryJvG1QSDRMxFb2hDq9/ijQnYRmTGsQGO+276uZLgXuTb147R1jSOZwzg8bR7T5jR8e0JeEpGEsUGwe8RX8ossqcD3DwP+KVFMdw5GY3w3HTziWNDNrhU9vswyrqZy2OTMbiwwzXLViqK7gai0k2PyYfvpekOhtw5vrNJ4+KQl3N5sq3RF5i869QilWBdKfONjfw+ZEgIrkpYqeHGNUvHaJ7OsxfAr0r7r4Y2c97UNEAZClR1xOtzIzB3oQgjcPz9myEhTqw4tLqJbwGo4L5okGjK74n9TnWMqUNGx7aIcJe4TJPOvE8L16xaoILqmN6w66/8eRjdqzp/Xpj0XTNA/TBFMM9YnZuWBKLzF5Q6tO+wm59qQtP7h480NknF2hl2OWbYAqgM6KMIIvDDgMAMpc7/bDZRs0TD9vK+hvOsQWmC7irlbTNrI9RvubiBo1ZvyVrYfvM2tU8sVInf8hDAua6EBuQpJ7bDmIxdWDCH7RnF888JBDQZjgooPyAhk7S1igyLkxeu2nDxLVv2VCd17Lu/C3MTXL76qUam+ga/Gg8mO6LzxHCSnwWLL2KToSEAI6fIqghZokWYLZG+JKgBcqY4hN65+B1McyecgXNQcbE4umaAJKjcwSIWpiltwaWHx3tmdX26Lr8PMJbbOhMt7vzP88WsXtaY2iiKuS+a9FxGXJ4UyayVJzQh2KVKoKokcd1FpxeXnaCcRZUkVXfDTZgGpNnxzJgmUSwNhxU6
 N7+2W634
 14ph8hlWP9hWxOBpWajktAei7XoB1+snMvP4vrEe8RZxSQ6jJAglVd7Ei9Xcfn7b5lwv7i5fV/vUwSm3+cSK8LAZm0LAmwlDr9AhreL1XYOcJCs2vk6uYmYD0aWDUTczu+szQU+Sw4+koa0oxWmDyfESmFl9VZk8Gn3PYfe7NeieX6SHUZhfXYz1QyeACa+r0oBC4bAmghCrlGiMxcm3azwPOAg==
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


