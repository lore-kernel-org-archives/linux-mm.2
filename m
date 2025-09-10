Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A098BCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7668E0015; Wed, 10 Sep 2025 01:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EA58E0001; Wed, 10 Sep 2025 01:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6698E0015; Wed, 10 Sep 2025 01:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA3508E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:26:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A37F1C06F8
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:26:07 +0000 (UTC)
X-FDA: 83872204374.11.04DE616
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id B97751C0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:26:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=adnbJszD;
	spf=pass (imf18.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cGC0gkaVd18/Lxr4eoS+A1o44ByCYajfvvOspb3trU=;
	b=qX8AbKci7VervEClRLQvjtTbx1FsfFD9zHq9hcwZkp2YOsg7XGkBL1yD8/wx+kMQVrjYua
	EhfcTWmPtnX0/ey7/XRJT4cyitiBIGWLnF1EZtJhscWUQZkKYzn7kqErw90n6t1bA/a824
	EQ5LbZFqWcFnguTuQinrSI4RvuqS8G4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=adnbJszD;
	spf=pass (imf18.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481965; a=rsa-sha256;
	cv=none;
	b=T+taaP/0B+RIA+UnGaBoH870FJxW4Fe8gdhny3BkNBFY66uWdHmCpOAhkkbbErrVFqkUXP
	xrmkVN0AlzOjLBxaAvB3ah6TgEJLuW3jiNXGuUP3k9DyGy+2LZkjTvBmTgY5N6z1lbobwg
	FnvrkYXUIY+TuWWIt3qyGGJutUcQSRE=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4c72885c8bso5310313a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481965; x=1758086765; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cGC0gkaVd18/Lxr4eoS+A1o44ByCYajfvvOspb3trU=;
        b=adnbJszDQvygz7G4cWfwotbmXr35Fkx4ZkPs+Tjqk3ESlyWKiMc/DDknhoqsa4kQ2Y
         Fh+QgZFLXHc5o5Nia2XVKivSNECLz33KpmaJCQ0n65qKNMa4Z/lKyiDMu8og2njLEsCs
         ppH+udaFzZIhAlphFsAC1/GU7lXYiKglMt/qCBTrewqP3hV5qouNeFcJjfAq1zyYnmbP
         XuTgkMu9wGSARFNbNOCFyO7297SEWIiCO2Y3+6oRzQDq0sLTixSzj0UPNUpu0y3lIGk2
         XUpu3hho/l34VvtQseh/dvTk5cwtWtHPRo+xz71k5ceXFYcT/DQaox/g01/rw+a/k07B
         xCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481965; x=1758086765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1cGC0gkaVd18/Lxr4eoS+A1o44ByCYajfvvOspb3trU=;
        b=pK46o/NIvB+KtVC+fmdZ5sxUd6ZWOFRzOs3hQ0pSMi60Fo1N5rqOw9eFRt/4qjo32Q
         R9hwL+pG5qAz8XJqpp6EPEVykkGWBh870aaTDgnWgFg9iarfBuorzQcZsqs4dlwrwyfo
         U3gEUXie0EQ1DqYzZjFN7a5TOscCn8rxvSEg9VEOzgVpFqd4GlVVT3wQkA3MsCD73nSf
         sPg21iO2g4tN0FIchmv5P3eVd8moNru0vCBaRLRCh+vz7Sajsp88NRfc2W/mNoJFHQiD
         wtyll+23Gr8lDYE8WXEV/A9BVg/LhQnU3406MDi/QD287opTC2vM0rnXCmf8GVqxca2T
         T5kA==
X-Forwarded-Encrypted: i=1; AJvYcCVgu54ety2EzgTsCYEEDxFafhroMLcaaXr1Q/L825XsnvqQXhvI67BGDflFhhLnBd6ZxC4jBiooMQ==@kvack.org
X-Gm-Message-State: AOJu0YykIzj60ki3KzQVdZyF7cQVGLhmOQFGjbwiw+ae/0UrRlJSl5tH
	rmm4FNcf7wzKwuxlUQ2AtKch+32OzhGyn6TWGYfvj/WO1ceM0y0x/1lP
X-Gm-Gg: ASbGnctsPtpj+mssmiAqTzrMXhzahy6jOcNkHxxceU3FLLHkRlCR9CofySqXTHTDiUE
	F5QOdZFtxNNTRlmI/o6oy3tAl/rLDUYFkgyGwVIWKlXoqUSx3FZmzaP6gR2lljMPbT4UguITde6
	RGo1dzYmFVf1bA8leAyyna6+YNkZBvyDF0UJ5QIsux5VLIrE0kLlhwIVvzoRkGIuv9Blcp3+xAA
	H0XAEfH9AKvGxwTwSqfqNeRgMhTptRPu52+9jQbiqhqv5qCCmX3O+BUDX3/68spHy9dJJdjta9F
	L63hqwYZtKoUJkU2Ta96/KUJOI2lWWADA021gUdovV0r9LJnvOSq+Y8MwZNImvaZdRdAc/x4mcq
	tQJNxSJU8A6skluo9HYxIUP5JZOtGyY6EjeWKjCDoYHo0
X-Google-Smtp-Source: AGHT+IHRnW0jqK60RBaX9CyGZ4rbkLTldty1zM/NNrTXrRROO0CZyvlymHODufDpMyz/pY0YLm22Nw==
X-Received: by 2002:a17:902:fc46:b0:24c:d717:719d with SMTP id d9443c01a7336-251761615a7mr159790755ad.60.1757481964506;
        Tue, 09 Sep 2025 22:26:04 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:26:04 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v3 08/19] mm/ksw: support CPU hotplug
Date: Wed, 10 Sep 2025 13:23:17 +0800
Message-ID: <20250910052335.1151048-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B97751C0003
X-Rspamd-Server: rspam05
X-Stat-Signature: qutc3stdyc789kmzt3amtk96qdjbenfj
X-Rspam-User: 
X-HE-Tag: 1757481965-270544
X-HE-Meta: U2FsdGVkX18kWp+yTU2tLnwdpkig2YHpOBpLAEzlWWj/GPyswSajlGY4pjgz5lUmKAttwGvavse7EQ14GjB+7VNuLpT3tDzp3XXdHGpSL/7p40ByFpj0Dq0qS4AIQ1ho3i+KVyr8aU9bt+RJFZHRymnUci7CG2KpHL9/3zjoPkk+0sUMaWwueOaG9IEkMedtcZIFqDMkATO2Uaxle99IWuzI9TDxtojGTvq7LRCUNXbXE4IrkwhjHqUXG0pdsg4nP2NTaOBxpUfg43ooWtJwfDrZ1aoPH5f8HqETR+VXvfeNuuxCvzYvqLdaiggdLRKHhCbP3e5hIU4iGk2WygEuEGPLOVVvKbEbwHkYIHmVuF6LohxeG6OfXZZ1hG55KXlussIsHcNWPEprvTcKX7FWYSXar/k0wvmHlHrG5J4DNufyxP3TB6o4OOMzN+26pPEUyCV4p5lfK64fhH+HTtxXMNlj1Aje6cq0GkVBAtbQfly3ZXzHVS2fQw9tMHHCOUOBVQvo0UYddTWqruzydBvkgM7hY4Dkvzxn/NYpF82KxTdZ10N6YnNPbQfn4BdH2vhqWGOTvbDI05N4Zs4Q5A57B0ySIzP6UDacaozdOMc8+oVd+kpbGpXhiO8QrkjV4gCoxdsCa8KQK1WIrTBhZkgkK9B9xraHjxA/QYc3k2iGpnf3jMyjH4P7cjHipr1RdymLohZC3Ipt3BTa7C0TjOjQOxwKVt4jrTzJWjS8z4LYoGpnl1kVOIHq6emzNRwrL/1z9lJ8F9y66fEUsoV/qCLdFtyc09k5bVpNBj4zAQL7hdkuPkHXMXacTlz4wvpVK7YT1bL2h3UatL7CYU9PKtbXtMRk4BzMBTfOGKWXeJUXeZ/38BzPnqnSiK4NuO7lHxsR39UMl6yRM3R+nKK9QTCgzaWJ0gFqS6hzs2oDCm0NBeG8dycAxWhclR0I/dIziP6Zbyt8N6GTu0FFDA7um1M
 2n71j6Y8
 DzIxVHLDAk3XI9jti4ra20IKz+ZOSihXzWaju4us//s8b5ZaTJexChjlkvQu9vQT/NXoroGDeYwCXddSYZi6YeJpbcm25MEe/GC9PEpzxgp/f9KP3zHGWb2ygUiqif2N2mTy96oIBeXSG3Xd650hzXeqrydCev2qsRUFh+NNTBMrJfejg7+ATdHLtmH/C5qirl4Zo5c+fS4dze5wxgnPYB2EvKSENrIg327zkoXfwUNloC6b73pHRrYThcFksIw9L98iS1DWH8QyZDSRWR09/3ZXlAuorSprfJdDa0DEKbwdE0o0AVGkQzSx7cTKgGpGjz3fzcrdtL/06RveeT0zO6R3HA7aOQc2sDAU20XP/sslFVVF58/HRuUBd2pCM3nKuH0rw7YVewBYKIJDPQ9A296H3pgOTnp3abvbPW+dcr3prkgNPztw9jC+mVVYhl+zIg+NHlpA/aEdHjRkarBCD0h6KON3q+s8dAxuegD0QeQiwOvbqO3KYHjTbvjEgU01hum9KpQkC8paryxp74EjX5jkjudOqv6yqSn7/5z+nFTZsV64=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register CPU online/offline callbacks via cpuhp_setup_state_nocalls()
so stack watches are installed/removed dynamically as CPUs come online
or go offline.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/watch.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index e02ffc3231ad..d95efefdffe9 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cpuhotplug.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
 #include <linux/preempt.h>
@@ -67,6 +68,32 @@ static void ksw_watch_on_local_cpu(void *data)
 	}
 }
 
+static int ksw_cpu_online(unsigned int cpu)
+{
+	struct perf_event *bp;
+
+	bp = perf_event_create_kernel_counter(&watch_attr, cpu, NULL,
+					      ksw_watch_handler, NULL);
+	if (IS_ERR(bp)) {
+		pr_err("Failed to create watch on CPU %d: %ld\n", cpu,
+		       PTR_ERR(bp));
+		return PTR_ERR(bp);
+	}
+
+	per_cpu(*watch_events, cpu) = bp;
+	per_cpu(watch_csd, cpu) = CSD_INIT(ksw_watch_on_local_cpu, NULL);
+	return 0;
+}
+
+static int ksw_cpu_offline(unsigned int cpu)
+{
+	struct perf_event *bp = per_cpu(*watch_events, cpu);
+
+	if (bp)
+		unregister_hw_breakpoint(bp);
+	return 0;
+}
+
 int ksw_watch_on(u64 watch_addr, u64 watch_len)
 {
 	unsigned long flags;
@@ -141,6 +168,15 @@ int ksw_watch_init(void)
 		return ret;
 	}
 
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					"kstackwatch:online", ksw_cpu_online,
+					ksw_cpu_offline);
+	if (ret < 0) {
+		unregister_wide_hw_breakpoint(watch_events);
+		pr_err("Failed to register CPU hotplug notifier\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.43.0


