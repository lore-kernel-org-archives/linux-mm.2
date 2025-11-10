Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA5FCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCD38E003D; Mon, 10 Nov 2025 11:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4558E0003; Mon, 10 Nov 2025 11:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C3E8E003D; Mon, 10 Nov 2025 11:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B08458E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8170D12B477
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:02 +0000 (UTC)
X-FDA: 84095251884.10.B8F978B
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id A46BF4000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dCJRtQJd;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XURKXnAmZnyauprzc95LAi6JcC8IVZIZCwVkARWD9E=;
	b=yMwoLTinGJssxLhO7IGoGwhYt1WUzbluvKp/hxf90oFYYjsHqTWLAnIVmF57N5gVM71PRg
	0xXd+rnZDucn4MR+Ft8sEZauexLe27MeQ431lTryb0V7jkZjySRxXlw2YhdEwIGlqZdJNW
	akPdK0kcz+CUIJGoQI6ftO+iS/wHpEQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dCJRtQJd;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792620; a=rsa-sha256;
	cv=none;
	b=oHT+ouvootkQPhrd6ZgSMZOLMah8H8LtrVy200sQvFd8P8ZmAWxTIwTeqaL0yoQOQHjGDJ
	V+LlT2toT/wL9v9VIQAS+urSR+jA+D+HN7cFveBOKmzuevdbmSS3utaVe/h8hoC4znzmkk
	1ovST1csNt/CjYOXXHJuN+x/+OCIFa8=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7aace33b75bso3345964b3a.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792619; x=1763397419; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3XURKXnAmZnyauprzc95LAi6JcC8IVZIZCwVkARWD9E=;
        b=dCJRtQJd5oB4gUdRQnaYq8lD6KRSjb8TFsCjYrkBAbW22Po5K3xkTlSg/MsNNL5vGH
         GEHvhMmecCburVc//tgedO4W1rAMvqx6KloTlvirV3ejgW66ptlHoiNCgOEqJWtotrcv
         1x/dHpF0Hqu2dls5mwZAlBYLlkAD47QViHS6K/CxThK+ogLVIqDLgArOiPNmIlhCtAGb
         KShODOKmBEVFlIbipzKXiGQR3nStfQMkEYVGGHNYRREwEMAqdUt/+fZUojA41iWlHuTP
         ixZ+IPNZtnq7d1TQwpvy2pxNcG2af1lVwwtlm21bH0ArHQb+prtqB8z76GVGwx53KBSx
         ohxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792619; x=1763397419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3XURKXnAmZnyauprzc95LAi6JcC8IVZIZCwVkARWD9E=;
        b=Hi9AJQK9SqsPVdTAL/tbTyFG2+7BunFLHbqN04UaNKVsFM/AP5zThzXSoc1Rr7WxZL
         CEkGbabk453RjiR2Cm9IlglWIby3c/kjUKkVYJP9pzTqABfe4y536yI3d49wBYimMzIX
         RKsmaDGFgSVqK+0YOjugJXth5jOfA1fyBhbnY3grQ1aq01NvfkAZ02I8tfeEoE/2826T
         FBqfCSo1UEImnxuHuvBHkNCyWSYWBWZHIV9QSRtgvGDIntjNsL42ufamyaoip0N1aT35
         Dp9YU4y8WeFv9B9mQldBEcA0xxpyQ5VUph3KOeOvWZJUFL0IX77hyrienT4wV7uhPJg+
         5mdg==
X-Forwarded-Encrypted: i=1; AJvYcCXpoLkh9rDp/UN4XzYYM2gaIagGX0EAvTYGxSgaDm+li29rJLVpbtIkQLYIwcroPzSHVu4f6uMUFw==@kvack.org
X-Gm-Message-State: AOJu0YxK/Z/jr8SvKKQSaXj+rqSJ4iMKxXfoKIewNLJP72PavsoKzEDV
	fhD1onCs88SmuYvRomMBeDaSrgMKaGqHth9vS1i629Nq9N6tjMrmVUPQ
X-Gm-Gg: ASbGncvEU2EkHbB3oHF8f5OWYX1NIieoTsvOuqYXKkZwCoBtxBrIGFNImOdH4M4r8gl
	a5KmcEWkC2WYJwQUv12yFsRo3ZiaR08qFnaME+cPnXMHFupcKYkvJNcf/Ff4XjTRk7QeAHzr9LV
	0+qMSJphAwbFb/mjeldwDJZ1AlXgoxaSK3KT1o057Os17qN5qqQYB4HT1grSxW+MAhGGTh3oeu9
	baAtPf/Ox7peU7tkaD9nsMMgbpsNPB4Jqc4ZNkJiF/2jf5P9HpvEAVsLSwMNe911krSAFLrTU+D
	doFzGO8pF/HJ9Az2diW+neDGcBjLofLUsbcJdKv/MNVZQKnkWe4YEyWiU4upbErD63WMX5yyPg2
	jwFW23iX4rgrRBD5CTh/3FtLbbsN1Bwq8VF5+165HwGqwEj6uirl7wJ+pfe/xFmz03IbB3adslv
	42UcSB8fhFZvrnD8om6a/4RQ==
X-Google-Smtp-Source: AGHT+IE4ra3aOU6AC3VY9Gg6aAiRBbZVp1TeJobqAmTS20aSxV2gTSQJIElDd/SxyV53Mq4DKRR9AA==
X-Received: by 2002:a05:6a21:681:b0:334:97a6:17f2 with SMTP id adf61e73a8af0-353a18b7968mr11417885637.14.1762792619356;
        Mon, 10 Nov 2025 08:36:59 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba900eab130sm13106983a12.25.2025.11.10.08.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:36:58 -0800 (PST)
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
Subject: [PATCH v8 04/27] mm/ksw: add build system support
Date: Tue, 11 Nov 2025 00:35:59 +0800
Message-ID: <20251110163634.3686676-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A46BF4000C
X-Stat-Signature: spbps7rm6wfbpk9k7pn5c4traxoczuhp
X-Rspam-User: 
X-HE-Tag: 1762792620-33806
X-HE-Meta: U2FsdGVkX1/PP+/2X0P9XFIGNiqUX4oPrDRW8Sv2Xo1umyCcR+EGIJiLrWE1DMM2svrLx2CCcf8GQvpY5PMIsALmKMphGQc+Q3C8IjE2OJRTFIB9Lu6RcgEOeilaLExIZUd/1JPiDMq9LYi3MssbPVapzIZP3S60UU10P9XcwPPOIHbV2cBCqQQOHo84eJP1yoZRXZviz6WS+4Xvy1+L8Fzxz1xa6ae8eSX/8QU/IrEx5wxdo46SQiXg9mQqplXa+VPjuSZa9BqbuvacusdS/uDsZGiUbtmHD78sFnXKMS0zt5lOhTfPC/EFvm31FU2qDBDVQIMdevgQVuiSud31e5aCj0uiFQ3sLe4pObZya2hD9T277BAotE1bxcPGzuNjugNuC6My2btBNCKImOPcUK/utKpvxLPLrsF6Zm5MW5GKymw2kPVBkUKcQBU4qnhzCnW7k5W3ODrauZckQ+hzbJpW1+kF2HzIGa0Fdtk3IsHiCh1y+7RHJwyxId4UBRQ1Sk0MkN8NCPsGg+j1WoL18Nn3xYtELRiYYCbAZxzJXVP6df8LZkRFAFyhMKohvDkv1TDEB0qTPyInnwRyBtgktYMFhiLreeO734J+UqtEkVdCPRxWQ2pX8fT9JeB+TTTyilFRSdXVmlnK7frLXbQiptsvr6TXow30EbBRTm02NkcZAF071RIXirEb95p7G+DqMHP33H5M4TPjgIHX1Ks+oaWLnBFQW5XD2SVgJcDyyt9dd1tsJL6FfoLabsUPa9LxBbymdT1txtcPwCgbTc2CWr0nXTgugC2s3ZbdmtJxckDRUKOhXAow9rg6HkIBvnHwKpoRrl+idw01YJocgvUJvELCFgufF2x1TxxSNl1B7X694qNXU9jAGaC5r64RVseGlD+Uyn4s04zISQzMuwL1c+67StWVietD04oabtRCtK+EmsmTKz3x76OALNXxy9LJrJEhYarj6Ee+1qqUPOV
 /FPG8v81
 nI88cRbQWsdc6YmawiC0V12ffkYTha7fzlNR3rYNii23tnLVKpUBFJ1SQ5ss2w/L9gjA9a2ZRIg4VMnoRipiIVFPc4usnh54A1A5rk+5wIeh3OMXNrGnPaDB2KCkDXaJ0obFhDWSE5hJaj4KlHcl5QS5Hm/JotMBdLgkusmZwe49xB/mMp9kloriJcgf+L2c4ZXCM1BSoKh+bCunmtGHYFpn64mmSSFc51P18y/1Xv2XHD/ApsDoSI5V95z3s/rIf22z0nmcp+MDZP/1He/8ebMDw+b4A1HJOVNOcY6h381B5t3qQAJruY8RwSdp1Ci5MWf9rvyEgATE25Bmr6j5jvwz/kpm9ogawqRkE41F8KFo7D8zqqIv430Hw+DiwkyxUieY6Kz+NKBxfaQe4L3UhpLG4JNPJhvNnc0AKp421QE8h31dU6zBFDeAEBDuqh7AVelcmfAvxMylUml0gJpVQmAwojcLCF8OBd8e3MC2vHRewGdZf/hriGawLC43cCLF6IdXbbZt2T2Yt2bU1lW9R6LdQfo9R4dQRg0xMJysn+/cQeFAYKQveLOYPw9r96kdP/Ux+gEKxSwkzeyeK5NpX1yZ84A==
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
 include/linux/kstackwatch.h |  5 +++++
 mm/Kconfig                  |  1 +
 mm/Makefile                 |  1 +
 mm/kstackwatch/Kconfig      | 14 ++++++++++++++
 mm/kstackwatch/Makefile     |  2 ++
 mm/kstackwatch/kernel.c     | 23 +++++++++++++++++++++++
 mm/kstackwatch/stack.c      |  1 +
 mm/kstackwatch/watch.c      |  1 +
 8 files changed, 48 insertions(+)
 create mode 100644 include/linux/kstackwatch.h
 create mode 100644 mm/kstackwatch/Kconfig
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/watch.c

diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
new file mode 100644
index 000000000000..0273ef478a26
--- /dev/null
+++ b/include/linux/kstackwatch.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _KSTACKWATCH_H
+#define _KSTACKWATCH_H
+
+#endif /* _KSTACKWATCH_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 0e26f4fc8717..61d4e6edadf2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1373,5 +1373,6 @@ config FIND_NORMAL_PAGE
 	def_bool n
 
 source "mm/damon/Kconfig"
+source "mm/kstackwatch/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..efc101816f00 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_KMSAN)	+= kmsan/
+obj-$(CONFIG_KSTACKWATCH)	+= kstackwatch/
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/mm/kstackwatch/Kconfig b/mm/kstackwatch/Kconfig
new file mode 100644
index 000000000000..496caf264f35
--- /dev/null
+++ b/mm/kstackwatch/Kconfig
@@ -0,0 +1,14 @@
+config KSTACKWATCH
+	bool "Kernel Stack Watch"
+	depends on HAVE_HW_BREAKPOINT && KPROBES && FPROBE && STACKTRACE
+	help
+	  A lightweight real-time debugging tool to detect stack corruption
+	  and abnormal stack usage patterns in the kernel. It monitors stack
+	  boundaries and detects overwrites in real time using hardware
+	  breakpoints and probe-based instrumentation.
+
+	  This feature is intended for kernel developers or advanced users
+	  diagnosing rare stack overflow or memory corruption bugs. It may
+	  introduce minor overhead during runtime monitoring.
+
+	  If unsure, say N.
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
new file mode 100644
index 000000000000..c99c621eac02
--- /dev/null
+++ b/mm/kstackwatch/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_KSTACKWATCH)	+= kstackwatch.o
+kstackwatch-y := kernel.o stack.o watch.o
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
new file mode 100644
index 000000000000..78f1d019225f
--- /dev/null
+++ b/mm/kstackwatch/kernel.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
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
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Kernel Stack Watch");
+MODULE_LICENSE("GPL");
+
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


