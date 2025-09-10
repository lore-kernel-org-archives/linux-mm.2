Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3C9CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0538E000C; Wed, 10 Sep 2025 01:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50E78E0001; Wed, 10 Sep 2025 01:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A675C8E000C; Wed, 10 Sep 2025 01:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 972968E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:25:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41E1916071A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:02 +0000 (UTC)
X-FDA: 83872201644.06.A7ADE79
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57E79160002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XRi3ShAZ;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHbowSqCEXMKo5URxnvlReujWCnQ6OEftSHn5bkAAuU=;
	b=YQ2lzVJj/IIwhpL/IfQeky3mnZwmEB/DM0orR1uGLpYfthCT1E5obDZEfTNe5a3oxVAw2q
	r6QsbLEaRwN8WA5HmDsrnN3bP1NgVJDQFx9BsCvkYLK2DQbJX4TPphf1pj2QIYAQTaB/MA
	4r0td4V5DVk92FI9m0TWN+p0MydpckM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XRi3ShAZ;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481900; a=rsa-sha256;
	cv=none;
	b=WgPnod00Fvy1sDVOlmvVPydBcTa0m9Mi8T1GA+ot/rSfnqkmuAV3GMiw7LZl5EHo7ure+k
	Mh0G/da5Wahtfly2Hrm7VCdbjHrxWrB7m0qZEuXBJkctOkGUYItuELjxistOTaTwmBybTo
	H2VE1qxR3mOmbkuJDYO3nN8U1rCsnbs=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4c72885c8bso5309421a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481899; x=1758086699; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHbowSqCEXMKo5URxnvlReujWCnQ6OEftSHn5bkAAuU=;
        b=XRi3ShAZMZrfBO9UgNYsqDin5+omthvBxHwh0kssaPM/yxBySZvuactfASuLdp6RNC
         iYpZxGBFdxrn+oISyBRgugFvLLGetFz77517prRdUIgMyreV4uaAvOR9jCsHCmy7Qh4W
         +9iz4YDdp/SLHO+bw/lCWeJ1/QcYpCigYJvDQvrMgA4GGs7hcgLtJCdInpxKRiRjs/5j
         LPLRWSiHwr2Ay3nz19VRaVOppqNPatQLkZH8+ZsQRJjH/hdhjjrrXzSP5Czrv/ZqGOX3
         iUrgUkCvsxsZjZWbBDEDpchBa2ytQeRbRKbQOuw02Q/GG8vVJS/1f3S5TLrN5/SfWHfA
         s7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481899; x=1758086699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHbowSqCEXMKo5URxnvlReujWCnQ6OEftSHn5bkAAuU=;
        b=RxTBo8aPJP71kuYtj0WylKCn5H37uj/lJCwL37AJ4tLmeSb02zW8bQGFgC+J9R2NFz
         goUDeSnxIgV/UolkKc+O2f5SxjRH2LqOkemlpKleI+kL8gn5RMHu14w72UIKGbsvB8lw
         h0yu8LrFB0FGNQ8PfRcZIMZrvLwXY0NdCQgdSWIwnyN5Mt98fMOIJwbLsT5sQPQ7yx7m
         OdkgvBsCvQJTD76DO9AcaCOwmveeRc/I/ZlOl5YtV/e2Z/hNKFbsoff9d9D/S8T7ny+B
         9857KbnQeks55EtUSZXJpYoHd8+nHnS5qBUBh9o/DbCgrG1LCSue8tCk5LfNMs4bomdV
         QXwg==
X-Forwarded-Encrypted: i=1; AJvYcCWNANFBJWwZVEdJR97/G9YfsSiAZX9XCT314J4qkT0ZbJG5ZeoQIpxjlHft10t3wJyjZSVPb6GgQw==@kvack.org
X-Gm-Message-State: AOJu0YwqU0SB1EkI/TZuOVXpmXW/McxIkKbNduCdlIH9Mb1KzR/ygc09
	hF6DApW505VL2+bvrqNXciBZBwn2tMmpq5AmBKeWQVsb6YuEiyIoKiut
X-Gm-Gg: ASbGncvO1XDvqlnRtD/eXFRcpfbu+MCkH9j6GyyBp5jSGDgUrf2Z7L2GVHaiD7va3TY
	YYRNlMlu3rN+39ZQsT7ZZMHj9xYYAy/RLWR5cqNvGhXSUPHNhoAukqwXoOC4n3JB+ckfDj0u8RK
	DG7kuj+DqAKqDc/8W/b5OjJxxF8mDAvYL7s4Yy1600gtoAjerwjIxS616OWPmT35xVy8SaIS9w6
	QBN7PXC4INatnf6SXFky3FieFPrSWqyqfDy2L8+gF3mMRW3uCyiLDYgG2JkvvQ/wkjIEjWDICQR
	VsTBFnpJSS6gXkzSQeKyjWIVd4MD5eoq0mbZ5cw5KxLvaMLpJdcrrWksipnexYo72WAiWawb/7w
	s1Pja82NOg+Wu9zZ9YBTaEWGY6zSEiEk5Gw==
X-Google-Smtp-Source: AGHT+IFnARFkczLWUmMFLlSc0N6UFfpoaihRfxkgeMdDrbimMHZoHGnBjY9ltFHgpchLFFWHUqeu0g==
X-Received: by 2002:a17:903:22d1:b0:252:fa17:bc95 with SMTP id d9443c01a7336-252fa17c03cmr200824935ad.48.1757481899190;
        Tue, 09 Sep 2025 22:24:59 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:24:58 -0700 (PDT)
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
Subject: [PATCH v3 03/19] mm/ksw: add build system support
Date: Wed, 10 Sep 2025 13:23:12 +0800
Message-ID: <20250910052335.1151048-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57E79160002
X-Stat-Signature: pcc8bw67euqdqsrhb7ye1emhiamxfbg9
X-HE-Tag: 1757481900-654261
X-HE-Meta: U2FsdGVkX19ou/382T7al2FRCSLSToV/REVIyIbEJ5k9h7G9nC/2zy8ekaPhX0cZSWdBpqfYSYGMTW6Nz7f30kbpqwUwSOXHXVu9eb2IS40GDadEEGIuqF4lVufdm9BgHaADtS2sPTwS5sZRthxbjCyJUPzL7emTSoVQInKw5SX0W8jGLAK24ocSJpYjiLWMcRxygXxsV2Bfe5k1yf/Ak0CRVNtcWGOxRf5wDWbzZIUSOJCPx1qfq1TOFTNTHlkA/7bw7Jwce//pPmjw1AeGJ7QGoy9m8bHquUw+I662QoU/hNj6enCVJ0g7C59Ps1CcE6zZcnfY/CiaZ1O4GXe8hMMWZPkKqkvi6+SnSxlt4qafG67fI2XNye7f/O3kpE+ze8bLcZUKUdfo0ve2xZBIl4LT/DKuuGFx/aghvd4jkMScg5JvAITSruuxX44T4YmCIVGCNAM91Laqra0i6ZbNIVh+r/UKBMm+Q141fcD3gF+YgUrBuOeWdMVr/5feMYO3A8s1XWIBRrl0V3P/WxUeQ/Wj2MYNjG/v51qJgbXJ5Hcqd9kD+fMrZUhyHX0xebkql1ADdHOS1UCJYRZ9aAqv+/HXu33UVNv8CN/V94KK6hL2JdrgnqSjN8KNuIqHL50MxHxZWfX5YsyMDIICEfrpeoBFeRb8xk2EuUoFYqpfFhPMjwaY9N3c8AYHP597yyR6MhPGTsuWy8LpEAcVRI6urlb+eJP9jOTQMyCecwuy+dBO/HRXnkUjL/nhsKeeG+gl6Xh5bpGE+QNvH5wHwmwYk5Tsslwj6xagcfTeKaqYJesNoOZ7tMREujsVAw/bzTHz25O3PTJnODh2UhRRuCNe+82pK1BYz+2GFcx+zZHZO28YfDJ48pV6esxqRTq05aLhVp+2GGsN1ueiSxdgqCwRWawg0SnbGkuh3sZZ2V4XKJNlpznKOSI4brfO4OHrqxTlUSD6JfWRp/h1R2Ys437
 bbEhB6mT
 zg/N2h+S4eI0m5khxlB5FEc0KD6o2oM/0re23KCG3SsQyfY4HWD/Ht301P30+H0nYOON9o2uz83b98Th98S9IyqDKGAoIQAh2eJ4rjZTrXosGhd8GFLZce5aLLfSKA45vKWntdcXMGUFY0k5huM8iacgvmMzvgd9LAVR0jlg3cagqRHuBpVI3SutGEOcdpjGzxB2SvJ+xRZM79QX9pkuKFmbBjHtnsdITAoko3TWXij8/0PXXXvr+bCbo7jJlQNoIodH94hzVrvFO6B61xG0dI9xgOjXs0BOavhNUowFEq0w2jY1CgEJsGfAUOBrnvc6P/M2TOy2WIxA77REZs2ZqPCyI8IhgdbE024hVP/uyO2O6Vl5XDzlsoW3+4qsb+fkkqPH8XoBsPwtk1nzcFjyLzFPs68sHoTPDSFTf+zoYHc+QppPw42QhSfKhBjWZs7vH2P6//4b7MJbsz6XjOaveUFFj8s2lJPOpRBDx2r8zr8sczquNLoVkzslFhj6dMNYa8CqpwSTOIyK9MLqa+iUKZkfQAY45fgennuMR/o7frGvjFq0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Kconfig and Makefile infrastructure.

The implementation is located under `mm/kstackwatch/`.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug             | 11 +++++++++++
 mm/Makefile                  |  1 +
 mm/kstackwatch/Makefile      |  2 ++
 mm/kstackwatch/kernel.c      | 22 ++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h |  5 +++++
 mm/kstackwatch/stack.c       |  1 +
 mm/kstackwatch/watch.c       |  1 +
 7 files changed, 43 insertions(+)
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/watch.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cc..fdfc6e6d0dec 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -309,3 +309,14 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+config KSTACK_WATCH
+	tristate "Kernel Stack Watch"
+	depends on HAVE_HW_BREAKPOINT && KPROBES && FPROBE
+	select HAVE_REINSTALL_HW_BREAKPOINT
+	help
+	  A lightweight real-time debugging tool to detect stack corruption.
+	  It can watch either the canary or local variable and tracks
+	  the recursive depth of the monitored function.
+
+	  If unsure, say N.
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..665c9f2bf987 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_KMSAN)	+= kmsan/
+obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch/
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
new file mode 100644
index 000000000000..84a46cb9a766
--- /dev/null
+++ b/mm/kstackwatch/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
+kstackwatch-y := kernel.o stack.o watch.o
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
new file mode 100644
index 000000000000..40aa7e9ff513
--- /dev/null
+++ b/mm/kstackwatch/kernel.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Kernel Stack Watch");
+MODULE_LICENSE("GPL");
+
+static int __init kstackwatch_init(void)
+{
+	pr_info("module loaded\n");
+	return 0;
+}
+
+static void __exit kstackwatch_exit(void)
+{
+	pr_info("module unloaded\n");
+}
+
+module_init(kstackwatch_init);
+module_exit(kstackwatch_exit);
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
new file mode 100644
index 000000000000..0273ef478a26
--- /dev/null
+++ b/mm/kstackwatch/kstackwatch.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _KSTACKWATCH_H
+#define _KSTACKWATCH_H
+
+#endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
new file mode 100644
index 000000000000..cec594032515
--- /dev/null
+++ b/mm/kstackwatch/stack.c
@@ -0,0 +1 @@
+// SPDX-License-Identifier: GPL-2.0
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
new file mode 100644
index 000000000000..cec594032515
--- /dev/null
+++ b/mm/kstackwatch/watch.c
@@ -0,0 +1 @@
+// SPDX-License-Identifier: GPL-2.0
-- 
2.43.0


