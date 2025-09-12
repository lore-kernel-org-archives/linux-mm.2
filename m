Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51954CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE2B8E0025; Fri, 12 Sep 2025 06:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3DE8E0005; Fri, 12 Sep 2025 06:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2F28E0025; Fri, 12 Sep 2025 06:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8922B8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3992EC077C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:34 +0000 (UTC)
X-FDA: 83880183828.20.6823EAB
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B0A0180004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EDD4X52i;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0CmyIyII1+MjAJi7HJRtv0YVAXaAwAF3MNYXoEmi5A=;
	b=WoNfUBDRUgqcUUzcveG3cU4yuFytrmzUD4TmSwwrM5ripCaaL942f3L56inh+knOc/DqSL
	cA9zvy25bHV9O3eQFCLDGGLEwAXC6q0tWYk4eRPZJmWp7FaaRKWdWIt8ZdpPdkkoTI2XME
	VClo9gYjlzyZNM4SCNNvPCDh5yGNSPo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EDD4X52i;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671952; a=rsa-sha256;
	cv=none;
	b=EJfnn96RX6jNbzTZpHyIRxqQ/p3t9DoCt7KABkDDJH//bZpBAVZpY16dj3x8pWDZ2xGpdW
	rUOOsVVTdt/0BJCTwQPPId5abpXWZq4vSqmfPTWoaMd3Y4auNcTWW4kur3rDgBSj9zuWhR
	bdlMJt62frM+LS1T1Qn7Q3ltxwG7wOA=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-25669596921so16096675ad.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671951; x=1758276751; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0CmyIyII1+MjAJi7HJRtv0YVAXaAwAF3MNYXoEmi5A=;
        b=EDD4X52i2AutlgSgdcokvqFUlZwA1+EMKBHDFkHlbuB6buzdnxsVq4KT0m+UxfiPBa
         Dc/GEgLLcshZ3D5kFA1Lut+6U9IxjYAIhTnJD+hlF9rOxZtQ1YQmdGZqHu+/Guo0x5Zv
         86d4lsW3EjaC9SZ8HB6jVi1ny6q3dC9XHq+cisOPc0t1BvzA6WbiWwHGTo03S640PaQ4
         ZH2uqslgzNBgI/iW3b4y5Zly8yBWFSxkiv/XrUQT1O+Z0WmM9Wr2w24eh9/Mjs6mFcuD
         HUf+McyJ2fP83uq2YGthdMvBpO+XaCJne8SHDG/3lw3dnG4tuVDfIeMnOM9RWhl/4rf/
         XCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671951; x=1758276751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0CmyIyII1+MjAJi7HJRtv0YVAXaAwAF3MNYXoEmi5A=;
        b=LOHWjmpo3hfZtjchKJv8QaWwT3NHsBqgWcXJxlGpJ45IZGN9dBYwYqXGMiZ4O6R87P
         qxvnrGc6IU/+wdwniBsay2tBEb13oSmePOZlAYGrzdV3KD7KyRcWxOdBa1TMlQmjNpH6
         krIZdHEamHNwElTryLr0XCpjaRZ6OSfMPWCK8l2RTAZuuPKjtK8ZVs1KqFSL2HR+dM36
         hPyfFDp6FvTIHpMQ2zPTdnEgJkxEdnuwdvJtaPOYHUSbMwBqBFt9luoAHT/iQyRl+L00
         IyhE2vk8d7M2yxcVbq+9a9myyYJk7WQ60H0pLZVXd+U0A6gvKkBsDO9nIh9tazxUAOJS
         5pRA==
X-Forwarded-Encrypted: i=1; AJvYcCV2mzcLkmgCEL5YLfUQLKgNNHzLtQB18NfgB+SSID6uOkYCIZw1xOvS7u4JKXKdNBvsOWkdUEtuzg==@kvack.org
X-Gm-Message-State: AOJu0YwIgykaXrisl38fcAV1+mwIfGYnCdellBm98aNzBHhM0YdznSSS
	EnMvPsXzK9u8YxvkpAeDGFaQYLQMq844hRUlWCXWWA4WAxkrOcRaqWpP
X-Gm-Gg: ASbGncubjr/kERIfIDm33RxX18mTQchssWY7R1gN3so/kxXyNvelDKfP8SGgO/b18SN
	dCkZKJE+q+LV8OemLFkNjQxapIdv7LmtVtdvfuIAHDOBn09NZQudLmZx4XzfBFm8kih/9PaVtn5
	G4Gy9ezs9zzYk36T5GI6MPIzEYxZ6A75KUwtX9Lx/l9GK9YPtKR9/znvT6PQzgsGZ7fXwlBdOPq
	cOihyufF8jsqjrfJoa1iTpV7v2ffuxM+zK01Qd0sAUT7QbJ/sHyJ+41z/3T2gMu8xqX8vKBbUSt
	JsPN/4u8B/IsVTqorgF2nwf1wEITA8z8SIGEOzDLjCfC8NmMDA2YUAnndsN6YbsmXBMNjsYzMd8
	IUs1wzDs4Kvrd6DE1IPFNoo2WXO+JTa6WCTMloFs=
X-Google-Smtp-Source: AGHT+IF00yk89VG+lmEZt4lMLX0bbsabe7ZkX4XQg7tfyuz6vAWZHryAYuUydwk9sktzZqpEFk926w==
X-Received: by 2002:a17:903:3c2c:b0:24b:2b07:5fa5 with SMTP id d9443c01a7336-25d26663dcamr29087525ad.29.1757671951122;
        Fri, 12 Sep 2025 03:12:31 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3b4f1127sm44400285ad.147.2025.09.12.03.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:30 -0700 (PDT)
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
Subject: [PATCH v4 07/21] mm/ksw: add HWBP pre-allocation
Date: Fri, 12 Sep 2025 18:11:17 +0800
Message-ID: <20250912101145.465708-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4B0A0180004
X-Stat-Signature: u43kfysk1dtt5zz1td9ay1yf3hpkciac
X-HE-Tag: 1757671952-851510
X-HE-Meta: U2FsdGVkX1+OI5QlFYVKCZiu6j+z8LoUrgWAkLfnJ/xw5FMWqVPttgxncTreCWBXDD3l8kHqRXC9Xy4uf5gxO/t5z3I3gTQZpWLuY0Q3ZI1srpa7DpqCLkQ7RjE4NaBuerfUo5/qtobhw7y6GSWe/fea17ocQkn25kzpZjUCl111c56cnOlXA/uZFEdJ1iiIyL5dUXB/FuaDvbnQ7j+xrIBNC0MeO6HwDLlfZtOc3zZaurADNP3iln7pQ3eZ7hIv+LSup+86jukJL7k5UWEfevINLcDiSArfvuuacVdoziIrp9pwMRU6lFRQMGGagaDj9kYc5SLudM7znQgmIkDB0KEFdEpKFU8JAdVTOgN6X3iaJZGiDhQ3bxtHy4SQmBkrh8PbzfHkJbfJINxm/1uC7JWeZ6ayTA9dvJ+6dWRLUVw0qj4FxE/GhF1QJ1NqCGCOqpTtJOa05Glyg1RTKoGQaBcJrfdWDl9liRusB2Yl+s766dbGASe0SYULAlahivRZqTFNpdHGdq7xTzFCPSF4j4ZLumzFNsLzsBQ5C+h61WnLHnCfDgBA9ZZ2bZ63vvWbrUxzRWyZmxpuebac2YVOPEzq8eMMxU+DEAPE+RPaY+Ckjkcesu6o2nV5BKK4LNYEmjvrwvDQ3Ithdd8w6AiEfidgsC6wumm2/ef6CbZ2YMpHonorrH7+/euy137PPUqxmRniZXxCt7Ll+OmUDRj08Yf6hdart8A3q2LyqWKHLU17H9s6gO5CvriOuMue0cTsniWgMK4cZWhow/cy0RIhTD4UYru0Akx56UEWp5nQnSjfrn3bgzo2j+x6wCSVVW8d5queLlozTB3wMLrsa2gr0iR2F1h7askM68B60UN9mKQzRViIItt1ZwDlCaKQPpAd8GS/XhpAXAtEfuoqOaOCZsmvczsb2pL03/iSb6Yu7/Q69/WISIq123gXNlgLuVd+KtoV/6OBL0jjsYrqf5w
 9/UR5SMv
 WrhJs4NQ9/Em2ZiX2uRDp/WMKLISJWOV+NuHEfZqe000hNn+P5RrdyMGELWHpmRRPPPe7MqRdeh9fqYliv1Q0EpELShjqBZJxXarWStm7Pw9feF6H5dRJehPlJd/WFWztfjPvXcAk2oXI3WMF5DmM8p40A17H9AWgiUXi5V76AsIHL5C35HUY3F/zeW1fZmxG2eDJo8rmhSHcHgUqrCfOvnuDoAQduZlVlEInvIISPCsUaJ3St+wPHbUoEeTPH+yG9u1wNKYRpUELr5r21opmjEA+PfRwIfBSkGct232v1FrhapCMKfaBHuzD1aNC5BSvLDP4FXLtdhUi5GefvuVfKVIbLQcQcs6D8xQ+78g7li+7k0dw1HAC9PqcmuX+/t7GKWfSzjRpqL+6p/JlSw/CFJb8b/bF2jbGmUF9gt8OWCwOXryJaEAJOlhpSpiCy9rWJDztU9V/Tf+C5lsceMbMopFDN0YA84gJDod6k+o2a0ZjbeMfIIxoF0g6FMXsBzfNbeaqcKl//tXV07TTfwH0j3Y4nOMezNN7UPDvOtC//cXncpDaqC2/PoUxzSIkzHfZLSCx4a4IyrUxQdFbdAR/RuxfkRc/88aoIc88eQaExqOUJo4EelS4RkDhS5m12cIWbzzS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pre-allocate per-CPU hardware breakpoints at init with a place holder
address, which will be retargeted dynamically in kprobe handler.
This avoids allocation in atomic context.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  4 +++
 mm/kstackwatch/watch.c       | 55 ++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 277b192f80fa..3ea191370970 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -38,4 +38,8 @@ struct ksw_config {
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
 
+/* watch management */
+int ksw_watch_init(void);
+void ksw_watch_exit(void);
+
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index cec594032515..d3399ac840b2 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -1 +1,56 @@
 // SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/hw_breakpoint.h>
+#include <linux/perf_event.h>
+#include <linux/printk.h>
+
+#include "kstackwatch.h"
+
+static struct perf_event *__percpu *watch_events;
+
+static unsigned long watch_holder;
+
+static struct perf_event_attr watch_attr;
+
+bool panic_on_catch;
+module_param(panic_on_catch, bool, 0644);
+MODULE_PARM_DESC(panic_on_catch, "panic immediately on corruption catch");
+static void ksw_watch_handler(struct perf_event *bp,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
+{
+	pr_err("========== KStackWatch: Caught stack corruption =======\n");
+	pr_err("config %s\n", ksw_get_config()->config_str);
+	dump_stack();
+	pr_err("=================== KStackWatch End ===================\n");
+
+	if (panic_on_catch)
+		panic("Stack corruption detected");
+}
+
+int ksw_watch_init(void)
+{
+	int ret;
+
+	hw_breakpoint_init(&watch_attr);
+	watch_attr.bp_addr = (unsigned long)&watch_holder;
+	watch_attr.bp_len = sizeof(watch_holder);
+	watch_attr.bp_type = HW_BREAKPOINT_W;
+	watch_events = register_wide_hw_breakpoint(&watch_attr,
+						   ksw_watch_handler,
+						   NULL);
+	if (IS_ERR(watch_events)) {
+		ret = PTR_ERR(watch_events);
+		pr_err("failed to register wide hw breakpoint: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ksw_watch_exit(void)
+{
+	unregister_wide_hw_breakpoint(watch_events);
+	watch_events = NULL;
+}
-- 
2.43.0


