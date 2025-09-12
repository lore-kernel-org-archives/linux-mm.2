Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96AA1CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E208F8E0026; Fri, 12 Sep 2025 06:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1BC8E0005; Fri, 12 Sep 2025 06:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99968E0026; Fri, 12 Sep 2025 06:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2A948E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7368813BB18
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:39 +0000 (UTC)
X-FDA: 83880184038.14.0AC349B
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 962E64000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M1udOMuE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671957; a=rsa-sha256;
	cv=none;
	b=xKwm/Cm2IGUUlhw93kzf7CEjA0hjtYXd5k1m1VHOM+AadJj7cIe3HlL23GtP7vnPblBf2m
	0RZ/zZ2Ke8+t2eYKZ2Tj1sRUU38+KeyU8Bf6+Hw43kX2+wzDrxBM1j9sRw9FHroV3MkH3s
	cZUwaJorIYBGkPNgM6ldB7TiNd7C7P8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M1udOMuE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBWUZGT7AQZjVN5sSaCPPhxiXndvcDbF8VJhhLu7a/o=;
	b=mJzLxa7v6yuzhgYajOyixzb6CAK4LmrN2o+LDchhaYUKaa8cfImypXxXjkyy/Po0IC34ys
	gsvY6VUnzB2iZAbj2A76rySupoe24LWvyIt80FE60YIHghmqPAiJezC952rIj3poE4oksc
	xZUhdPH+Xp6N5eRyq3dto3YY/yVaxCY=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-772843b6057so1578293b3a.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671956; x=1758276756; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBWUZGT7AQZjVN5sSaCPPhxiXndvcDbF8VJhhLu7a/o=;
        b=M1udOMuEB2n9w29/SorCVl1zWK75YqERIwvEdmXMoqiezIuOY9Le59hqvVTRCSw6+r
         H8osTTMmWraqEerQJrFn11mwfp0leWElMsUX4Htj9ngCtgvuIAmqv9tCwd7nvHVaju1M
         slLGEQJE5Dxpwpn/BuzlHgVQ7TkNUBz/PhM/rIppOx8MxTeTb9YC74cJXWR6x8gGwiVY
         Qu9SQwGY254Be4VNPgL5DkaJ5Dzoruss+KEZGGsJ959J2nhKGE+AZ9+ZhJBRBgZzFf50
         s3xhymdxOy4RLWd1xV4OLrs4i4vsqGTP0Wg4TqCwx33KFpk/4ThYU0+TRPqPhkKwKlp4
         R+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671956; x=1758276756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jBWUZGT7AQZjVN5sSaCPPhxiXndvcDbF8VJhhLu7a/o=;
        b=sSOXSKWx4V5cJMGxUZcdYESRgYPbbnCn4lwpl9gsxiP6mw8bSsKmjeW2HaY/VJ53Ke
         jf8xq9X5aibkKRDjuzIATyu89M4qW3iSWJU1gIaBg+jmvBVwYYddiJZ2t+cOMCsqzAlK
         +1e8AP7GPb2CJjnPNPtB8e8lubdD8beLUeSP9qS5y18YL1wpLwsdTHRxTG/uT4D3dm/O
         tjr2d+jj8wgXLymOoiUsnPt1S8emzJym4w3dHVMWT9/1ax0BAKroEsl8dNmq+M3vvVPI
         bt1CPBLofNjyN1FHr38fVQ4Wqn9bbpUsitU+59ZUNg87J7YrjDUO3ZE6rkZwb+AfaPEa
         Ce6g==
X-Forwarded-Encrypted: i=1; AJvYcCVrplqT7pqM8WEkpF2aRJUrNnZq4b9qAitanG6snnDnPDHChD0BR6M19V48ffkRqzYpd/1mdm96ZQ==@kvack.org
X-Gm-Message-State: AOJu0YywBjXaRQv9ivcMAZALFm7GNH+SkW8/ZDf418yUwY/wthwjPD1L
	X7jNyPexiGCXp3SMXKzndKQhyzyE3uWE9wRL4SoD+wUs3eMwgdgbfX5S
X-Gm-Gg: ASbGncsghI/eRlyRce8ioj1AXXG39n19I9SGG8DqciP6vSTZiD4p2jk+DZqukcW0Zj8
	avxCZFvts2HYuyHGD6SzkYwrV+3HW17lJEFqPQmMdH0L7iXqU0iHb7KEW2vXTvwTAxq3ZIw48b0
	VoUOHybi9wE8jKmACFaeCJo+TRuk3GU5RKd8RHp6BY571rbU4fnB9XO0htoQ6ZHIQjjUd6d/SYY
	Ule1B4N3I40TpulVdDXUtJYdjNEHZ+MQDBsi+TWGwCwo3CR3Phg2DXt/1aPUIsx26zKy5GQyQp5
	Q0V8udSYWDqDw5dD8SKmkbnB1QSlNkoL1dB3cihBBo1Ia7+p7g2aqOudhOOeum9iya3P8p0dV4R
	E4JZNflJCecW9l2I/AzaVKb/da/kni9ZCylHfmd84yCCVw6lxUA==
X-Google-Smtp-Source: AGHT+IE0smHKx/fxxESUMD26AxoS7YeR+pzOUZ9t8bbqYrL6zePDghHY9Bjvt2Dlrnb+iBu56FBUDg==
X-Received: by 2002:a17:903:3c4d:b0:24c:cc2c:9da9 with SMTP id d9443c01a7336-25d24bb3201mr28288785ad.14.1757671956234;
        Fri, 12 Sep 2025 03:12:36 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3b307073sm44099805ad.144.2025.09.12.03.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:35 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: [PATCH v4 08/21] mm/ksw: Add atomic ksw_watch_on() and ksw_watch_off()
Date: Fri, 12 Sep 2025 18:11:18 +0800
Message-ID: <20250912101145.465708-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 962E64000E
X-Stat-Signature: zbrbidirn94oz4t589absb3g6x3wf7g5
X-Rspam-User: 
X-HE-Tag: 1757671957-794947
X-HE-Meta: U2FsdGVkX19/LYnsGqQ0CteJdCR/5ddy7YSLinCqMrlYmI2G2AUeMhTKBqPftrPGK0oMfgHZNOKX54M4hsuuos2p9L3CCeq22oLGJYBm9fazJYzYNCmKrsF9Bb3CParYnta9SRuwnhe8nX1GgZu70ZCHrUUt2HuCrwOauiij5FYvoxJfhQtjanbQoiPQqTtRhCJqWnqVRYp0K2gcekMnFIAtG/1a0x1le3FkXM2X0Pmajxu89CW/WvdsXRnZypQPTXbAgEz0t4DAFxtmeTh94AiPc+wSGkLfHn12esZWeayiheo123O3hwVrgUJT1D48D6KJZMWrjlMtYgPgZfgkvOSd75wUSJzX5w8Vg4LyqLbpk33pmkKVM5mRNhvnHsFgsEyvahBmski4jxJ25csKq4MsP5aoG3SPB2iVDyliP8mQhCiiewjbkmDbzqPjlKelhtRUhb7hjcEfABigApMmN146lC7rgj9sibmAIpCHcDR64wJUzkOeT4VorwNlMFdmCD6Hpedx8LHJ5WeZR7Aik2fvPvvGlx5cNumO93Wgsut0f/4RlIk350snYSfQBtt08ODP+twx7knV/3gTM7RCzzFmZ6/t4+b2nMSjBZ5nyC6DjihPQcYeq4WCZ7mEgLnXM15hPDe19JWQpxwQWfOT0juhiQp8RFCwc9dxZa4smOUSemy+5z/1tWg4clIC6JQ46rdGRLDW6uhQUVCMyfRquWibOtNy2Zg+O+d8Z9Kmgrd2Whh2/08MY1oRTraKA1GKcQxgWxLNnjjBLibVGmth8qZTq1NLP5p1ZKNnA5h9CIB5KraWzXVCB9P0mXx3bIvzEEs1zi+v7IS8BKohKbvFu7Jwc03NM7Oi/GENdZNZkjPbuPMGhgLNoBHTUIA+KpRqq4gcUpOb/n5A2YefRujlZ2sbcY+55xCdzKodOwo6ZlMzCLM+AGAoIAP9nXSl5XX21U4vwLMQuwkKJ3e9NOq
 +s0IzYbt
 8nd96+ZowNFo5xJWg0nNbI2UUzMVIwpqoKhvLkSMCSXF+Z5arYzAH0Sv9Dyq6frPOJ7jmArdVekqNXGnZs9ZlxNoFgdM/0S/KVfoxGlEU5DwvRbg3wHh3gNXwI9iawHrW/rfanPui0LRLh8OxOhTRGyXrO1Or4We/La4nFcAXKEQrEFkC0dyJgmBtGi7UEmrGcIIGwfIWvJcHU/VHd/lQ8Cmbv5dccVTCEE8EcDKS+n89b+nUI0uHbb9SNP0DK4ES6x2alitfsdy8/uiiiIfV1GWZN56+ZEib8bZ530I2kPJH2FpMri4WRBoqWKryoPX77ZzkVFUqVxHZDuR1TR+O/t6ZAN4TcXqgUfHbv+RRzZtZPvKNG2rJVPbM7JN4+1vvOl6paaZPk2f2Zxp3m+COpLqSY/Rwnkyp4elni9Q88S3R05hvaUtgQVloKtPB/aZd1FJnACl6tBcjYa2DrExzCj2V8CEoBkg8wix1p2JFGLoSxHgpM9G+h9UvWfIJpLWdOJjZGBmfmf+GmK0aJBzPDnQcCwjIKnnWuzoCXbz8dR/MxODHnUS4Y9oTrPQcDuUBMHoBKoEpC9ka6xeLFSX6z9pf7Hmcn0IXTuXM3QfV/cETe4rDvzDwLtCZcXqVkY0sN8pBcAe30lAx/hAXimydNzCv3mtrpVgGGv93YgMMKmqwRlk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The atomic_long_cmpxchg() ensures at most one active watchpoint exists at
any time, with ksw_watch_on() succeeding only when no watch is active
(current address is placeholder) and ksw_watch_off() succeeding only when
the caller knows the active watch address.

For cross-CPU synchronization, updates are propagated using direct
modification on the local CPU and asynchronous IPIs for remote CPUs.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 +
 mm/kstackwatch/watch.c       | 73 +++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 3ea191370970..0786fa961011 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -41,5 +41,7 @@ const struct ksw_config *ksw_get_config(void);
 /* watch management */
 int ksw_watch_init(void);
 void ksw_watch_exit(void);
+int ksw_watch_on(ulong watch_addr, u16 watch_len);
+int ksw_watch_off(ulong watch_addr, u16 watch_len);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index d3399ac840b2..14549e02faf1 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -2,6 +2,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/hw_breakpoint.h>
+#include <linux/irqflags.h>
 #include <linux/perf_event.h>
 #include <linux/printk.h>
 
@@ -9,10 +10,16 @@
 
 static struct perf_event *__percpu *watch_events;
 
-static unsigned long watch_holder;
+static ulong watch_holder;
+static atomic_long_t watched_addr = ATOMIC_LONG_INIT((ulong)&watch_holder);
 
 static struct perf_event_attr watch_attr;
 
+static void ksw_watch_on_local_cpu(void *info);
+
+static DEFINE_PER_CPU(call_single_data_t,
+		      watch_csd) = CSD_INIT(ksw_watch_on_local_cpu, NULL);
+
 bool panic_on_catch;
 module_param(panic_on_catch, bool, 0644);
 MODULE_PARM_DESC(panic_on_catch, "panic immediately on corruption catch");
@@ -29,6 +36,70 @@ static void ksw_watch_handler(struct perf_event *bp,
 		panic("Stack corruption detected");
 }
 
+static void ksw_watch_on_local_cpu(void *data)
+{
+	struct perf_event *bp;
+	ulong flags;
+	int cpu;
+	int ret;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	bp = *per_cpu_ptr(watch_events, cpu);
+	if (!bp) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	ret = modify_wide_hw_breakpoint_local(bp, &watch_attr);
+	local_irq_restore(flags);
+
+	if (ret) {
+		pr_err("failed to reinstall HWBP on CPU %d ret %d\n", cpu,
+		       ret);
+		return;
+	}
+}
+
+static void __ksw_watch_target(ulong addr, u16 len)
+{
+	int cpu;
+	call_single_data_t *csd;
+
+	watch_attr.bp_addr = addr;
+	watch_attr.bp_len = len;
+
+	/* ensure watchpoint update is visible to other CPUs before IPI */
+	smp_wmb();
+
+	for_each_online_cpu(cpu) {
+		if (cpu == raw_smp_processor_id()) {
+			ksw_watch_on_local_cpu(NULL);
+		} else {
+			csd = &per_cpu(watch_csd, cpu);
+			smp_call_function_single_async(cpu, csd);
+		}
+	}
+}
+
+static int ksw_watch_target(ulong old_addr, ulong new_addr, u16 watch_len)
+{
+	if (atomic_long_cmpxchg(&watched_addr, old_addr, new_addr) != old_addr)
+		return -EINVAL;
+	__ksw_watch_target(new_addr, watch_len);
+	return 0;
+}
+
+int ksw_watch_on(ulong watch_addr, u16 watch_len)
+{
+	return ksw_watch_target((ulong)&watch_holder, watch_addr, watch_len);
+}
+
+int ksw_watch_off(ulong watch_addr, u16 watch_len)
+{
+	return ksw_watch_target(watch_addr, (ulong)&watch_holder, watch_len);
+}
+
 int ksw_watch_init(void)
 {
 	int ret;
-- 
2.43.0


