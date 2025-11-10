Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C06CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C89E8E004A; Mon, 10 Nov 2025 11:38:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0378E0003; Mon, 10 Nov 2025 11:38:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F6F8E004A; Mon, 10 Nov 2025 11:38:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 386F58E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00AF986815
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:00 +0000 (UTC)
X-FDA: 84095254362.05.1B3F3EA
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2519A40002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EukluAVS;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoYSCz9IZK+WTJVuSJ5kdqWuXYPyBcWSfVrsNGbuyIk=;
	b=xRKdb1BQeEm/+YveVsZ1FFfNjsBAKO9a8EktCBH90zJ5Fa+BwGaD9ei0Vxy5vku4fg0mKm
	cm1zzb83HXBNLLHYQZGJqAuFTo+Ys35PDkVyEmbxWhrePv0Vczf6bYIL7zpkk+ohNT6YT3
	FE5YU9gYB8LwC6yEI/DlRhRqboh0R9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792679; a=rsa-sha256;
	cv=none;
	b=jmR/qi05qv/0LRJLgKz53w2BhxraJDHRY5FJZn8Cl02sX4v2XxK/rNgC1YCGrykbUpMAcG
	im/ZOgMSdaP97UWdya5zPj4V6Rwgs61M4YMv3hK1EjezZU5H/EJL23oi+r9evpUQEhHXrg
	Kn0cOAkpEUvfjZYWXjVo8pBrc4zmPPw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EukluAVS;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29586626fbeso28271725ad.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792678; x=1763397478; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IoYSCz9IZK+WTJVuSJ5kdqWuXYPyBcWSfVrsNGbuyIk=;
        b=EukluAVSbEsM91lp5WwmF5U1J0TftYCFMNaJXJlxK0aZsslRgqdSOGkogTdaKzyU/N
         jLE0+8Z1ZroUtJ6d06xrVV+0RPh1+YQg8SGu6w9da4tTuAuKUj/eJoFQRvnBZxmWisYV
         D+lQBhQYwDU2nT+ZunlgUHTc8F/iNpDamDGdLuDfq6F+0ExtYVpMNVx7/vZVKJx31AkJ
         ttHfrq6A4Kgi67bYLZSs6Dl4OmqdeqShEeu0w2bnYmwID+I6pGNn2KX1xxUinqEoHsPq
         voML5EG8ARN9y6v6H15iu8xaohQOrxlnNwcOVBehTRryrXIpSRxQgWS05sFC/PuaC/8D
         Ar9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792678; x=1763397478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IoYSCz9IZK+WTJVuSJ5kdqWuXYPyBcWSfVrsNGbuyIk=;
        b=O9uuXnX3+9RBecMnlZjaRqEpeCNM60UdyN92o6Qq3iU2nR+TSgg3n3toZvT/cbZ06E
         e3vWizEvAkI4Fgx6KdtTfjEtOrRsMCEj6CzdjA6f1TCZ4HcfWfac68nGsWZsg2utXdHP
         qTi73riAEscRNbtQlknitbLKa0VT1JjRWMbZhKrsjOT9hbODmihg4yuPnT/vAUXIDXpf
         pBIf4x1ro/bWbkNYToOl1ebOZYdLE2hxsHMDkraEQEVdT5T5grgfW3EoKa5jsjYuiif9
         YGpB+K09XRYzWLuj56CioN1XPGWkwVFaWUnjlP6gRzGBNkSjWlSn7pEBeoZVAh/ge4d7
         hiVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQjrNaHr2nWBp/nvsyq/5PQinvrrb10HkCxQ+IhcMs3V+t9ilhADVnKr4/vGVkow6o5vuo1Q68rQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4Tcj+rwOWOiQNKrlPpGHaymr3DnnWdNfkS7oYu7Xvitp50WUx
	ubQFTKFqzLNNzot/sH1CfHs4/OOpeBKVO+t7vCqqQevr+2zGFtjrpIhx
X-Gm-Gg: ASbGncskH9baFmlejWz5crxIvOB4tcDljK6h5x2Ts3w2s/YO5IdHv6Fb6/OTZXyY9Pu
	cMQOlQzsoSQxJ+bRRvWmy+eglbn7XJf1AJRO9QGvqc3H89vNnH33/fi0VDTzoWhqjr0LRHxs94c
	IvjEwilQXmz+kLTYnHanWXReBnNJci8Zj0hct35XXwkA+OoCIXI1hO2ojOaOqilJPFFLkzS1l1v
	4O8taTVd/+/a0WH+Oz3At7OPimfbQQe+pQWL4Q9GBdVzuKkrK4BHivNWiwnN6bpwaeGHqhMCgZ7
	zRpjmhU7eoNJADb2jz7enBphC6IG6fNElEbWjIDJvKdEoiq0Z62z+DRNkl03kuhTGh14PjXHl33
	mRdQx6bMgJubZVM4gzVNnIeCdBWleHfD4lWx/rqqFNm70dCaKvu+UtIBttC/K/lhFAqY93eNRrm
	HgKr5aC5QfAkU=
X-Google-Smtp-Source: AGHT+IGNkULY4KbMreL+r3C6zKYa6LAZ6HejhCC3QQjkk4WrB7CidoZ7O068kW/SdXYru/ivG/AiRg==
X-Received: by 2002:a17:902:e80e:b0:271:479d:3de2 with SMTP id d9443c01a7336-297e5624c9fmr126791755ad.13.1762792677804;
        Mon, 10 Nov 2025 08:37:57 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651ccec88sm150510135ad.107.2025.11.10.08.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:57 -0800 (PST)
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
Subject: [PATCH v8 17/27] mm/ksw: add KSTACKWATCH_PROFILING to measure probe cost
Date: Tue, 11 Nov 2025 00:36:12 +0800
Message-ID: <20251110163634.3686676-18-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2519A40002
X-Stat-Signature: knjpa6zocgdcw383f176rfhmiojqyz7x
X-HE-Tag: 1762792678-191064
X-HE-Meta: U2FsdGVkX1+wS9vl9H9036qu0J3aNMFmNgFJiBC9ocSTBPkm0g7CkSPpOQzykX+lCutQIOvowLO+MZcfXSKGP//TuWaC5Y6i/zZxGyzaoXlOL6QTiGE3fe7a/Mwq6CQeiELAzTbEAG6VG/wEoLjsBKsF+hMrtfFzHcVYuDZ6qpHd5uAqgZcG7PWq1P/LJIE1TbBGLOwEk2ZB4HpUhX4S2CiopuoT4QaqoKBUz3swN+ifvZjYv4K4I7mLzGNFcf/lZADL/a6Eh/3Qn8yYdasf7l+5fDrFsUDFj+q049a8YPE4mXPheUhd5u9ki5AzRyUQaE38tosZX8A1BGtY4eSb5JZWJaW8V+J10X6Q/n//jbV9183t4fv326n34O1y2L8f09fW9k2XWgAuXKyVTYQBNJXQexbuj8EDwi4Vqr3dXv5Oji6urAkRcR5M8rqQSuoRUvmMdkCJZJqvreVV3NFPI+XHNpeaSScXdNxnt8OlE8AJc5lRyCgVZMuhTTe7vudiP+EhDz1ZtZAMSWZk/r8iqobJhCmcsYF6dTvnC6YBSbW+bdIM1Nl0I9rzSPoy+qDkRFeYxpMrvR+dJUROYvnhj2cqTbyWEbafWstyA2jz3l8E/6ER+Fr5QpVgrvVZTmdFtqoTqMZEtba/0VhvpJz5HA7nuCk7Lh7/TQqtHixaFOHnYMyeaXRnwGo5jwI/UOteCwkqqEpB7QDjecJrPE84d3ekJF5NDS7davmAim7KqlRB7VmtkyIxEVx9P8M2AiFysIbnOu1rp9EYOD9QESV1BZrz5w6o/5gT9g2HsDT05nC9YuCEne2jENU0iNlARbZZUJo/U78zs6OALR/awP0+krzCiHMFYrtiJlkqLUPhv5WxhXRpJ1AH2hjRSVCBmHqmztmTgKrAFM6G3G7KEXRw6OrfY7aL6zWeIb/qCqtvup4zYcbN6JXHVq/b8aghPlWuJfXR5346Zc104VapYLn
 gl5WC4x/
 58PMOzbnBcRT5Od/ussXtePgLXlNKhYHTQL/AB/ZwWne0lRB2tJBosls53I76Qm+hSlbe6kU0ijaVBJsoh7kJJ6oTNBMOa9UIFQ1tVnvYo1fTLKZ9WAmcuXdM79C9WGznJ3/ax6iE2KnzIIascbeKSemFKzkMxznw5376/Mta8JrGfCHww5OV769pCgXWvPBFK/ECbGd32blJ4sgWjWjXipflqiK99CcJEq2kC+3NRPNQZAzXkM6D7wKQvbdeu1NqMvFkTz44sT7iCp0Ys5JzyXVzcfShWIIOQJ/T+Aa+wpgeIE7WhycNiw+GWQu9zs0UyDHh6gg3MbMHTb2CQAS7/8/CR43LIaynjWh8wvrxdyAbf9x/eJJHfOaODuSTUw+fQCLP94SYegy/Q8atamIZorMZ/EBNhVkb2cL/XiZ7KCl4D3QS0OAYOpfJMKyw1bTaM8nmkcjywg8RmNpcmQqTQyXIGcgsp78M2mW0x/Dc3LTyBa0ArCp5fDGQH3FBKVfru+vSO6oZHA4ifVJntAuhGhSIOOpPdQNUigU+p66p2+nQNJEgpkkabsMGU1gITm2HNEs/wwdqlmiKsDj5g4UXVjFj3t60qVReWq5ILbZHWkxF7Tk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_KSTACKWATCH_PROFILING enables runtime measurement of KStackWatch
probe latencies. When profiling is enabled, KStackWatch collects
entry/exit latencies in its probe callbacks. When KStackWatch is
disabled by clearing its config file, the previously collected statistics
are printed.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/Kconfig |  10 +++
 mm/kstackwatch/stack.c | 185 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 183 insertions(+), 12 deletions(-)

diff --git a/mm/kstackwatch/Kconfig b/mm/kstackwatch/Kconfig
index 496caf264f35..3c9385a15c33 100644
--- a/mm/kstackwatch/Kconfig
+++ b/mm/kstackwatch/Kconfig
@@ -12,3 +12,13 @@ config KSTACKWATCH
 	  introduce minor overhead during runtime monitoring.
 
 	  If unsure, say N.
+
+config KSTACKWATCH_PROFILING
+	bool "KStackWatch profiling"
+	depends on KSTACKWATCH
+	help
+	  Measure probe latency and overhead in KStackWatch. It records
+	  entry/exit probe times (ns and cycles) and shows statistics when
+	  stopping. Useful for performance tuning, not for production use.
+
+	  If unsure, say N.
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 3455d1e70db9..72ae2d3adeec 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -6,7 +6,10 @@
 #include <linux/kprobes.h>
 #include <linux/kstackwatch.h>
 #include <linux/kstackwatch_types.h>
+#include <linux/ktime.h>
+#include <linux/percpu.h>
 #include <linux/printk.h>
+#include <linux/timex.h>
 
 #define MAX_CANARY_SEARCH_STEPS 128
 static struct kprobe entry_probe;
@@ -15,6 +18,120 @@ static struct fprobe exit_probe;
 static bool probe_enable;
 static u16 probe_generation;
 
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+struct measure_data {
+	u64 total_entry_with_watch_ns;
+	u64 total_entry_with_watch_cycles;
+	u64 total_entry_without_watch_ns;
+	u64 total_entry_without_watch_cycles;
+	u64 total_exit_with_watch_ns;
+	u64 total_exit_with_watch_cycles;
+	u64 total_exit_without_watch_ns;
+	u64 total_exit_without_watch_cycles;
+	u64 entry_with_watch_count;
+	u64 entry_without_watch_count;
+	u64 exit_with_watch_count;
+	u64 exit_without_watch_count;
+};
+
+static DEFINE_PER_CPU(struct measure_data, measure_stats);
+
+struct measure_ctx {
+	u64 ns_start;
+	u64 cycles_start;
+};
+
+static __always_inline void measure_start(struct measure_ctx *ctx)
+{
+	ctx->ns_start = ktime_get_ns();
+	ctx->cycles_start = get_cycles();
+}
+
+static __always_inline void measure_end(struct measure_ctx *ctx, u64 *total_ns,
+					u64 *total_cycles, u64 *count)
+{
+	u64 ns_end = ktime_get_ns();
+	u64 c_end = get_cycles();
+
+	*total_ns += ns_end - ctx->ns_start;
+	*total_cycles += c_end - ctx->cycles_start;
+	(*count)++;
+}
+
+static void show_measure_stats(void)
+{
+	int cpu;
+	struct measure_data sum = {};
+
+	for_each_possible_cpu(cpu) {
+		struct measure_data *md = per_cpu_ptr(&measure_stats, cpu);
+
+		sum.total_entry_with_watch_ns += md->total_entry_with_watch_ns;
+		sum.total_entry_with_watch_cycles +=
+			md->total_entry_with_watch_cycles;
+		sum.total_entry_without_watch_ns +=
+			md->total_entry_without_watch_ns;
+		sum.total_entry_without_watch_cycles +=
+			md->total_entry_without_watch_cycles;
+
+		sum.total_exit_with_watch_ns += md->total_exit_with_watch_ns;
+		sum.total_exit_with_watch_cycles +=
+			md->total_exit_with_watch_cycles;
+		sum.total_exit_without_watch_ns +=
+			md->total_exit_without_watch_ns;
+		sum.total_exit_without_watch_cycles +=
+			md->total_exit_without_watch_cycles;
+
+		sum.entry_with_watch_count += md->entry_with_watch_count;
+		sum.entry_without_watch_count += md->entry_without_watch_count;
+		sum.exit_with_watch_count += md->exit_with_watch_count;
+		sum.exit_without_watch_count += md->exit_without_watch_count;
+	}
+
+#define AVG(ns, cnt) ((cnt) ? ((ns) / (cnt)) : 0ULL)
+
+	pr_info("entry (with watch):    %llu ns, %llu cycles (%llu samples)\n",
+		AVG(sum.total_entry_with_watch_ns, sum.entry_with_watch_count),
+		AVG(sum.total_entry_with_watch_cycles,
+		    sum.entry_with_watch_count),
+		sum.entry_with_watch_count);
+
+	pr_info("entry (without watch): %llu ns, %llu cycles (%llu samples)\n",
+		AVG(sum.total_entry_without_watch_ns,
+		    sum.entry_without_watch_count),
+		AVG(sum.total_entry_without_watch_cycles,
+		    sum.entry_without_watch_count),
+		sum.entry_without_watch_count);
+
+	pr_info("exit (with watch):     %llu ns, %llu cycles (%llu samples)\n",
+		AVG(sum.total_exit_with_watch_ns, sum.exit_with_watch_count),
+		AVG(sum.total_exit_with_watch_cycles,
+		    sum.exit_with_watch_count),
+		sum.exit_with_watch_count);
+
+	pr_info("exit (without watch):  %llu ns, %llu cycles (%llu samples)\n",
+		AVG(sum.total_exit_without_watch_ns,
+		    sum.exit_without_watch_count),
+		AVG(sum.total_exit_without_watch_cycles,
+		    sum.exit_without_watch_count),
+		sum.exit_without_watch_count);
+}
+
+static void reset_measure_stats(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct measure_data *md = per_cpu_ptr(&measure_stats, cpu);
+
+		memset(md, 0, sizeof(*md));
+	}
+
+	pr_info("measure stats reset.\n");
+}
+
+#endif
+
 static void ksw_reset_ctx(void)
 {
 	struct ksw_ctx *ctx = &current->ksw_ctx;
@@ -159,25 +276,28 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 				    unsigned long flags)
 {
 	struct ksw_ctx *ctx = &current->ksw_ctx;
-	ulong stack_pointer;
-	ulong watch_addr;
+	ulong stack_pointer, watch_addr;
 	u16 watch_len;
 	int ret;
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+	struct measure_ctx m;
+	struct measure_data *md = this_cpu_ptr(&measure_stats);
+	bool watched = false;
+
+	measure_start(&m);
+#endif
 
 	stack_pointer = kernel_stack_pointer(regs);
 
-	/*
-	 * triggered more than once, may be in a loop
-	 */
 	if (ctx->wp && ctx->sp == stack_pointer)
-		return;
+		goto out;
 
 	if (!ksw_stack_check_ctx(true))
-		return;
+		goto out;
 
 	ret = ksw_watch_get(&ctx->wp);
 	if (ret)
-		return;
+		goto out;
 
 	ret = ksw_stack_prepare_watch(regs, ksw_get_config(), &watch_addr,
 				      &watch_len);
@@ -185,17 +305,32 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 		ksw_watch_off(ctx->wp);
 		ctx->wp = NULL;
 		pr_err("failed to prepare watch target: %d\n", ret);
-		return;
+		goto out;
 	}
 
 	ret = ksw_watch_on(ctx->wp, watch_addr, watch_len);
 	if (ret) {
 		pr_err("failed to watch on depth:%d addr:0x%lx len:%u %d\n",
 		       ksw_get_config()->depth, watch_addr, watch_len, ret);
-		return;
+		goto out;
 	}
 
 	ctx->sp = stack_pointer;
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+	watched = true;
+#endif
+
+out:
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+	if (watched)
+		measure_end(&m, &md->total_entry_with_watch_ns,
+			    &md->total_entry_with_watch_cycles,
+			    &md->entry_with_watch_count);
+	else
+		measure_end(&m, &md->total_entry_without_watch_ns,
+			    &md->total_entry_without_watch_cycles,
+			    &md->entry_without_watch_count);
+#endif
 }
 
 static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
@@ -203,15 +338,36 @@ static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
 				   struct ftrace_regs *regs, void *data)
 {
 	struct ksw_ctx *ctx = &current->ksw_ctx;
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+	struct measure_ctx m;
+	struct measure_data *md = this_cpu_ptr(&measure_stats);
+	bool watched = false;
 
+	measure_start(&m);
+#endif
 	if (!ksw_stack_check_ctx(false))
-		return;
+		goto out;
 
 	if (ctx->wp) {
 		ksw_watch_off(ctx->wp);
 		ctx->wp = NULL;
 		ctx->sp = 0;
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+		watched = true;
+#endif
 	}
+
+out:
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+	if (watched)
+		measure_end(&m, &md->total_exit_with_watch_ns,
+			    &md->total_exit_with_watch_cycles,
+			    &md->exit_with_watch_count);
+	else
+		measure_end(&m, &md->total_exit_without_watch_ns,
+			    &md->total_exit_without_watch_cycles,
+			    &md->exit_without_watch_count);
+#endif
 }
 
 int ksw_stack_init(void)
@@ -239,7 +395,9 @@ int ksw_stack_init(void)
 		unregister_kprobe(&entry_probe);
 		return ret;
 	}
-
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+	reset_measure_stats();
+#endif
 	WRITE_ONCE(probe_generation, READ_ONCE(probe_generation) + 1);
 	WRITE_ONCE(probe_enable, true);
 
@@ -252,4 +410,7 @@ void ksw_stack_exit(void)
 	WRITE_ONCE(probe_generation, READ_ONCE(probe_generation) + 1);
 	unregister_fprobe(&exit_probe);
 	unregister_kprobe(&entry_probe);
+#ifdef CONFIG_KSTACKWATCH_PROFILING
+	show_measure_stats();
+#endif
 }
-- 
2.43.0


