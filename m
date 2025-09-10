Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15929CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735398E0012; Wed, 10 Sep 2025 01:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70CD48E0001; Wed, 10 Sep 2025 01:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622A38E0012; Wed, 10 Sep 2025 01:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5201C8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:25:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0269213B971
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:40 +0000 (UTC)
X-FDA: 83872203282.02.A7C3959
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 23A5840004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QM4NcFXo;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RI10mDfREFn5Rx/uTs3tJDtAseKlBmy4SikYDBaNSc0=;
	b=m6aqvG5waVAhqrNO1lnp9NBGwnqQW1QcgVbG3GYpaCYQOfmp73dThAG6sric5NkhSBgUAF
	HB7gNblDLA3+bzz2d7HaLA+yxbEbeTI2HSPqCe7wFpzZRX9c9fgbZqQ75VOCV4Lsol5r0O
	e1j0clgFzzno7+hw08q5BlG4Mdk61RU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481939; a=rsa-sha256;
	cv=none;
	b=J3pJVdxEmCxXe+5b8bP89YFPsIESpIW6HFOqt+4B6Nm36PXy7AO8W6K/CtXy9E1Zfn1M0w
	3FvsJ3lH5Xi8zKaWxM9RLv51ptJA13CHAyP+l/jgMP9ZPfmymfszW7WCJiYuU38RyTjVgM
	9zaVeVbMpKJtbQZ/ocJ6SKl7u3QdYMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QM4NcFXo;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24c89867a17so64319655ad.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481938; x=1758086738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RI10mDfREFn5Rx/uTs3tJDtAseKlBmy4SikYDBaNSc0=;
        b=QM4NcFXoDl+rr2a4HL6uV5+86yqUGOB47l3izu87lxdyFmKPpFNNscY3+rJXee3HVL
         uyVt7FQ7vWcjxYfZAWKG6/50Hk9miopYExF3g9WkUhhpc6GCa3HCEBT07+i0t28D3IYX
         6VxzL7bdtRVlkoZ3XkLZvLqJeJTP/rhGHHOx1kN53hzyq69WHyaDGYHpUY9XOXcfr+bb
         chPMBK3L0sy6SaUyu8X4frNJ7rxWbYz2ZjWDK9Mqelj2fcG4sse5z9c7qPerXL48bcAK
         Otevm4LSxbAd+O4h+2nepBJfBVtXVDbaZaiXy6c4EHJ7ug4+RCRqDeldaOPKMLN5Mz0h
         XYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481938; x=1758086738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RI10mDfREFn5Rx/uTs3tJDtAseKlBmy4SikYDBaNSc0=;
        b=gggLYvscBWDoZCCZOZ/vYcpSJovJi6ue2obWlbt6a1Upjs+ix5dOOJiRn5uDY+Y559
         8exn0ls5kr7LPEr+8ACE1qtF3WVbAz3ySt6eqGPSalgkTYk2QwZgrlmC9GPju8PiMjWu
         FkHcpSJg3ltOJEm+hb9CkRpFYbL8PVOmyu26Ddmdd8jtPwMr1PTymfIr0PYuzHiczOnN
         UGiymoZt5ggN9OPjZCgueQqTWs1ZXm22pK+HU2y6kae3BMi3cVyhrJlj6laFJBJSREK7
         6tbwmjJOgZwLM1EHdcR6seY3VlnveMkfp1PKgvD491qW2hrWO/1krembzG+SvbvauXUP
         YjGg==
X-Forwarded-Encrypted: i=1; AJvYcCVeDYCvAlRs/zwDj2RByaqR+CweOTgYNhu+XA4ldca0Dd236hLhZ92E81TwNxiw2mMR0tjXzTsOng==@kvack.org
X-Gm-Message-State: AOJu0YyjL3wHKJGEdKwYsIvnLS1qYUhkgHiUyMZtSt6ZiCWzi65yKOp4
	Hoq+s85fO3Wd0U4upOdfmceeXXG7CMMDL1rlUKCrMUgKtfpNe75T5ttJ
X-Gm-Gg: ASbGncu15mXkQ1NhtmNwqZVJ+gybRX7SrSWmiV2fAD3E95zlsjfIqd4ck7yoPZSZiA4
	mdK0Ba8MJkt02zYjM2QeMlPJVl8HB9WWD4mYtPABfhpcE1k3q0kmz8b2u5ErF9qbrdDRAr3ZUa+
	+CHxyUUSPtoKE6bBIaEQOQA0M50r89Cn7e/ft9T/563KYamRydejGzwigZ6kP3FLB+O/GoYDRH6
	o2NB4M7DM6IuH1rq8fzKM+iAnP2PxU2Md1GWm8ROMiRc+4DS9ScMTNdktucSkjEh07ATA6KuUwO
	OSUOlTEYrvO0FF2UFst/YY02ZWnt84b/8MpAiTXj0Xl0iRn4dlR/3i22HOQuJirLxJPtLM61xa4
	xOb/BXMRbIqzNVBo6AkL6tOA5UdA0ZrfbWw==
X-Google-Smtp-Source: AGHT+IGA+Aha8Lgq4/YHb8bC+D+e+AQfCwDSLkoSj/ul/ONnfZ4SFI21gPvhy1l9BFhjs6AI1wYwTw==
X-Received: by 2002:a17:903:288:b0:246:cb10:6e2f with SMTP id d9443c01a7336-2516ec6f1c3mr207113305ad.26.1757481937933;
        Tue, 09 Sep 2025 22:25:37 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:25:37 -0700 (PDT)
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
Subject: [PATCH v3 06/19] mm/ksw: add HWBP pre-allocation
Date: Wed, 10 Sep 2025 13:23:15 +0800
Message-ID: <20250910052335.1151048-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9dhuwct6mpeu7pcnbh6y985qoj1aw3ze
X-Rspam-User: 
X-Rspamd-Queue-Id: 23A5840004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757481938-774413
X-HE-Meta: U2FsdGVkX18LZAXdyoXEtTEFILwuTUMT1KKI228WOfmmzs2CHplsy2YQS52AQIChCoKa/+MJC6mWS++rvYmCXUZKSqXWCgUdd8MCIwJrr42Dp14J2n7xZdYCTRzlJPnM+8UfCYZCTb59cS0kSJrm+wwjF79iW3kuna/ztQu539fE29JHtg3XyMYByLX+TfOSh9jwYzKCZ+Jg/9wrV56sD5JSncsMGyz8oNbEsQDjpyeXL0lKxkUY05nCLpy3SERP4FBC3P1vAKighFY0MXtSw4CISoGk6mvKuIoV2H6fgH38jIMsoRf+tveh+FSuhygXZksxMR5EuXcaySxd2sLEZtyiTS1e9+hp44urRE0cAh3Sade3vQ1KpXsrVmNEqEznnRSPQbOo1Se79UTWaBCADp15Gj4e++lFHNA6UUOcPp9FNu179SQg7H9OvVDWZceGl63tOYTUc4z3ewePdlDjT3dNw5Hy2T001Ssv8yXvyUJlmFEZmDJtmbqVnhca7fIAdxlbx/ynspZfWIE+LyGRptJIjo4HPi6zpOa6OaRUsukO816JMbAXE4X7D34JGOd6i4EaFnBsQcar+ShE4dBpsWOOMwgcP2ns2lrdouLxY78iDTBUQ8QsNjAdq6tSt8iEI+aR2KLtzipYj9iS1Ji36ZCsU1d2xCfsgzViVIo1+SermoK342fEPB0d1eU0PpcjnJF942w8N6Rht0bHpD4LktPtB1rnPQ/nbAfTXovEGpZ4a9lw/T9W5LerNRquFK2ddYRxeP8Nrd7+2VbPeLKLo7MI5LUmzEyjvFejgO2L6w6w8J6KiBMUs1ZkyfAtuVyLI9+Lnh4RLSYhE0rcv14J4wybRO0jWET4LopKsMs5RwHaI2dB7XeyFkL6JDqWwDqnnNPk5ZgwEH4GA+Y6U3pSsMQTAytOQOBU/yk6/jboY3/MBOfTCJwKRB+c12Gd7PyL2urraAVkzgK7zCQDZoK
 GVb6G49M
 ZZyjKQQlvivqLIdlWtGi/UCvRyriLmvWfysOgIF94f50j/Y5KfV0nP90Dinkmd5YcIxx33eMqxfVQE/+aVp0I+N2F/Ur3tMQuZ4RMdznoJaiEyH7naEUiaJABlwkNxqAddRHRHgLbJQzWh+UF3cp44/nkXmD++xMAkET94toMxAw4o/qpD1K50jIIRDxAujenUBhjibiLH8gkgSxHJ9yjdWt2NIBbaimiNw2n+kcnPWVoG1UMQiYGyMUq5PXFKQUE8wJFg1aOoP6xvvqf6FKrxAKuOXn33l33/OM7J0yp287ThrCr/adCm1NqyawSbUkxo2q2+SWCxjadLbvTDKH7oiIgV558vwiaKtkebZTf7vJO4rGJY5JIr5upZsh0zKxezAQQ2UMW8eFgTXbRhinc8KOXcmm8JREwKp1sooPWM7gSvWtvPK9FSIJxC9KlHdHAHSTMaSmwjwAP1GC55Y+4hG3yK9zQi94N08DKUFOqdvWe94l3DvRpt8uo4wQahcPwi6lBYs54guYlFLVGzpY7zUBG4f9lZp9sO9pQsTq5QXlZ7foZldC5ElX0z0QxiJmGmBjoHT35dy/V7sg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pre-allocate per-CPU hardware breakpoints at init with a dummy address,
which will be retargeted dynamically in kprobe handler.
This avoids allocation in atomic contexts.

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


