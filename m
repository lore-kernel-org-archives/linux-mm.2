Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6090CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54F58E004C; Mon, 10 Nov 2025 11:38:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04B18E0003; Mon, 10 Nov 2025 11:38:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCCF08E004C; Mon, 10 Nov 2025 11:38:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B44778E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 785A5C0198
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:09 +0000 (UTC)
X-FDA: 84095254698.07.EA8C967
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9179AA000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mB08fGB4;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbxG26SeCS0bD0vh784LPkUdC/dr0BSaPzCrIbaXc1o=;
	b=2DIsQ7EoJWnY8RA99iiL2ufPfPQ2u+OYY+146UQ71IInq+KoE+MpNwSzws//jLsYpePVBp
	fdlcL6OPCJv53JUAXdbU4NIus8j9PlDVnjIwy9uW8+iWfQgSQ1F4V/zA0ywgjHqDjhyIXr
	7FiDWLnq8CsVYlBJ578A5G1or51J+74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792687; a=rsa-sha256;
	cv=none;
	b=55XPfSvC/Amglk8mPtkJp4/KNHcLQroarg0xGHYar6PPQwVx3D2TsjDPfVscXhNfoJm+BG
	cIMTV096AJzImr6hJV7nnpXuAe2zaNyTN5VKoohpa4p6I/H5iRoZ0O2uNJL1CsD+PxXzKB
	ffCddK5IUJut/NWKjpaXZM2jhRPIYvE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mB08fGB4;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-295247a814bso41664665ad.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792686; x=1763397486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BbxG26SeCS0bD0vh784LPkUdC/dr0BSaPzCrIbaXc1o=;
        b=mB08fGB4mytriGVA2Igkysh26mDyHCg3GcHg4JpcxG/35ot2YOZmfV2cy3A44nMSNd
         jVXayuXxlHjid0N6pnYSa0AWYXIiDfy6UvSqIqaojImVYdoCouURPeuB4q/SHUArYVSC
         z6otWw1GHQgVH01DsjTW7bmcUME2tZnxbZxHJsSy/BitiCJoSgKbQ+4z8xuYZvpyiQo7
         KMmYKd/Q63r+cpKON5WuI4j5TVjsekTlAVV5pOeaRcmCFEMa4uEElf+nqbjVFn+4BSBT
         wg0Dzfx5ilbRquEREyfIQ8etrD/CwCkhokO9HADEZxogRG9Qu53N8qkbLwDr8GXWF5jb
         ojMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792686; x=1763397486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BbxG26SeCS0bD0vh784LPkUdC/dr0BSaPzCrIbaXc1o=;
        b=kQ0M+FFug5/dTa/+EbZ4vznKTA37DJgCZtB6pYgGCMv7AXC7n6nEFM1sq/+/xJt+LH
         JhvtzPtmNq9qJLXF5WUvLibfMDFxHJqhHUj26yb9ShWHVfPBk8erw68Ijei08NOHIN9R
         4abPnSUz0BWQIzJwdSsa/tUimdnKVbAxFvaqxNsyu8XmU5ddsRErwHpRZpIjWUrM0q6w
         Lqt7F2vtx+NvFNa6xqMCwdxcZk+SYIfuUvbqTX7i5nEFCmE5xuV0ntV2RZ7C8ewuZ99J
         y0vwxHRWi5tlU9NXYUJrpTZhuK8BADb63MFYozffy6lhJH4YGwCYqFL3np1+HfaznFz1
         29sQ==
X-Forwarded-Encrypted: i=1; AJvYcCXd/M68A6SFTS+FP9Ej7DGdZViv24QImbkil4Iau4h7uCAdBcWBg/WfVq5y51eFKqBn/q5s8NKQyA==@kvack.org
X-Gm-Message-State: AOJu0Yxsrv874krhxRgTYQ6wFvv6hhUIAbZspvHdk7kbVRkhR5vMzOAi
	XmWexSqAhERTLWGA/W2Lat7XslDztctko4v2uE+BpASKOnNa+jg4dHGh
X-Gm-Gg: ASbGncv0C0Fu0wRC+dBPw54ZTrvrO3xZyvnyZVPYwQz5ioVUL47qHLSVvtXGvRNESVx
	lBZRZZ/GN+kLext1CdkrVEn31kBK3tv7uehvuIRxGDrqkdR4HLHttJzu8wfWceYKRccRQWy6D99
	A1RjJqsOg0jDQ6h0SsdqtuOBKcd9F+scH0Q2acuxpw50tsdBn3GLuaao3cBE01fD5HkCqy1bJ8J
	1V4exGZntvZvzJzg6Kkm9THCLh2MlIOBwPo/tZSO7UIMSYZA8wltTwIuC4YVHwmkNeLMWodeqI1
	wu98s+h4KdS500dxTSqFGmMLhgyp578Px8aY1qJEBXMh2PPhJRr/RsORDY3an4hSUgq9RY4vrGQ
	yTYrgWbJsBIPeW1GdLEqZD/Xxfkksh+T22ZriiZ5nMbEOluyqEz7y47VOYE+yvD5bKLFF0bk5WV
	auB0InmmRNz/U=
X-Google-Smtp-Source: AGHT+IFGVJoow1/cESxoE1b0elhSpiXpfiC9HmcofENWA1KFmQBzVRQaX5Wyx8+4PBNdomOGrCwPww==
X-Received: by 2002:a17:902:ce10:b0:295:596f:8507 with SMTP id d9443c01a7336-297e4bfd91dmr122302855ad.0.1762792686313;
        Mon, 10 Nov 2025 08:38:06 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c7445dsm150531925ad.62.2025.11.10.08.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:05 -0800 (PST)
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
Subject: [PATCH v8 19/27] arm64/hwbp/ksw: integrate KStackWatch handler support
Date: Tue, 11 Nov 2025 00:36:14 +0800
Message-ID: <20251110163634.3686676-20-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9179AA000F
X-Stat-Signature: wmz6ntqtxkxof1kpa4fha7wdsne57oyh
X-Rspam-User: 
X-HE-Tag: 1762792687-485864
X-HE-Meta: U2FsdGVkX19egs9CzmImZoCBNgkBvVir+ZMAlBmAa1sixJ6fb7j9xoxAhJqaEhCJXglccG4uNGTYbY3cqd0tLxcTyodro92JoDqa2gtTVnIA7lTQsq0ZbIFk/x2EU7021PM1Ex/p2J/Tp7moOmD8lnzj2d6SyZAc8IcKvslzl8HejRO7IHqP6sFagfa5XH3U7u0v++LlfaSRlKpwbu2/SWRar4S9O2aRFYrOnlkavg0H0YDagXeA7vA+O8ZrNCOPOMA5K9C0xfjwOmaiwRTr3GuXZyFQJvegMmsbc0txc1SiCjdLKMkmF88dd16IfNtokIFYMS+l6nyYqvfxpyvmZkvONr1ozoCfxwyP1uxbkDHx8yncQwN03S++kQog2Vr+ulzeThApo85HVoCZZcPbG+UBC/uWV7eYTBmRiVkwLAVSywGo0mMHwj3L/B5nUv99tYwlv0gLQ9nle++nYWpH9LaS5ZZFtDDM0Pry9HqcRyPV1XfqP+c2OHvF6U4IGmkm+xoy/NiowFh1WkBhmHY+D+2l5Y4pncp50kb6hFxs2qiUFRj33oVsSKJD5BrcOhQ98tq6ZPDWdppYtMqZYPF3syQ9d74hyZZKp3b7fzxO/0frmmRjutbzjz7aV8X7HIqS8kQ+IWjPkH1sfuAlxUSBypUZTMQ217qZOO/deBQYLtQimzKqM7H43krmxq/HYzq8GfOAXaaQXO1kF4T5l0Kom2Ba5rR0CLL7XJLwmkobSXcFdenGY0+rKR+Nx8L5MP/NWxkQfSjlSeJOEMldBfrOKfC1chLlmLsC+LrZ5R7tIZCoM/vY2/WU2BsJ2fEmneyfVP7rDfhGv+N6U2K4a/RckZ5pxPZMNl0tw56SAZsDZU3ZzH/WuRSr45J1GP85p8XatC4YQb7/ibuBoypAKJkFJ5y3x1oFA/5ZH9tQIg/jk91n1XvaZTOjFh31OdfD6CbfaVwKWawEKpxgz2l/47i
 tFmavlIE
 mCkQFa6KLUBfKlU1ncp6tx4YSc00gSfKZ0vJ6BWSVPD5VoOkWimKJYP1fYn/AL0A4mN6vZ6nwltQr6Mcp0muWEWGVI+ZDv0i6TM8ITkkzm38cc2GYqAI1xqsOAd1TfTypd1mgL36yb53jwyPR2aj95uPcq4Zm0GNS6CPnoU20WH+S3I602KgXR7+UOIWMNhBdN7MjyqB+dVfnfiSrtUwX4ejQifep8KEeRh0DYKdu8aOPTfSnXpa0ZGLgqBS6KU6Dc2HAFGM35N9Rw1H8wvd6ANDp42PoLw/X7hDBAZkvEvKohwvYaBimVZrQKCVpw8xQ/o+ri3A5Drg9cZmvVhhdrmD0daIJcy5j7tFY+86DmkOz7t9JkQ6tgAmMb6+An0nvGdAkfPzcbBgcdCMy3X9za41fFJ6b8Htkau025l9gkjDOxjR1VKzcyQInYXMFDqN0zPJHi0IZiGQO8ahlj4bF9IRnn2uJn2afF/Maj26o+fM4CUNX+TmTeDfRW8cZBiqjEoNmq200NqGst9xlzofUt2/e3UR7fUcpjvWSX8OAN3fissKhO5FR5IZd2taro1XsIMNLMhN3plp8l9UpVedk7NDCODEz3KHEdw+xoyZiulijvEDSRggeHSpiz6KvSkiZ0XJ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for identifying KStackWatch watchpoints in the ARM64
hardware breakpoint handler. When a watchpoint belongs to KStackWatch,
the handler bypasses single-step re-arming to allow proper recovery.

Introduce is_ksw_watch_handler() to detect KStackWatch-managed
breakpoints and use it in watchpoint_report() under
CONFIG_KSTACKWATCH.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 arch/arm64/kernel/hw_breakpoint.c | 7 +++++++
 include/linux/kstackwatch.h       | 2 ++
 mm/kstackwatch/watch.c            | 8 ++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index bd7d23d7893d..7abcd988c5c2 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -14,6 +14,9 @@
 #include <linux/errno.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/kprobes.h>
+#ifdef CONFIG_KSTACKWATCH
+#include <linux/kstackwatch.h>
+#endif
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/smp.h>
@@ -738,6 +741,10 @@ static int watchpoint_report(struct perf_event *wp, unsigned long addr,
 			     struct pt_regs *regs)
 {
 	int step = is_default_overflow_handler(wp);
+#ifdef CONFIG_KSTACKWATCH
+	if (is_ksw_watch_handler(wp))
+		step = 1;
+#endif
 	struct arch_hw_breakpoint *info = counter_arch_bp(wp);
 
 	info->trigger = addr;
diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
index afedd9823de9..ce3882acc5dc 100644
--- a/include/linux/kstackwatch.h
+++ b/include/linux/kstackwatch.h
@@ -53,6 +53,8 @@ struct ksw_watchpoint {
 	struct llist_node node; // for atomic watch_on and off
 	struct list_head list; // for cpu online and offline
 };
+
+bool is_ksw_watch_handler(struct perf_event *event);
 int ksw_watch_init(void);
 void ksw_watch_exit(void);
 int ksw_watch_get(struct ksw_watchpoint **out_wp);
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 99184f63d7e3..c2aa912bf4c4 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -64,6 +64,14 @@ static void ksw_watch_handler(struct perf_event *bp,
 		panic("Stack corruption detected");
 }
 
+bool is_ksw_watch_handler(struct perf_event *event)
+{
+	perf_overflow_handler_t overflow_handler = event->overflow_handler;
+
+	if (unlikely(overflow_handler == ksw_watch_handler))
+		return true;
+	return false;
+}
 static void ksw_watch_on_local_cpu(void *info)
 {
 	struct ksw_watchpoint *wp = info;
-- 
2.43.0


