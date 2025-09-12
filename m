Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E347CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6628E0021; Fri, 12 Sep 2025 06:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657038E0005; Fri, 12 Sep 2025 06:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7DA8E0021; Fri, 12 Sep 2025 06:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0C28E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB831BB346
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:20 +0000 (UTC)
X-FDA: 83880183240.05.7E9CEF2
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 12A251A000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cl7ZScJ9;
	spf=pass (imf19.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPBHXhel7rMyKaWRDIHRGBdLv/zGRcLPaVcgqECt6eI=;
	b=IIT8dWZTRvhqrDD+7F3KIDmorKrN1O3NOCv5D/rOrAFxrvN46A5raDNunPON2Jqw3vWAl5
	0wisRJr3mPln0kctGCW9tqPAaiWcO74WxsRiU/oH5rcHFeTP4CdakkLanJ9/8pDi7TZzE/
	BBRt2Z4DWG2j4nKEPcvUMCVlm9+VoJU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cl7ZScJ9;
	spf=pass (imf19.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671939; a=rsa-sha256;
	cv=none;
	b=w7vfDoYVuuNb1VnMiqpuTrceDO/4hFlzM4SopKf3UTwSqLEsU1pHoiHnn7ty61Sj+vL3U3
	3xXvDxtT3+zKnMFl+IkHITbMfgVtwXPsypaICXbg7T8F0BUD+X0tkTLSzwP3pLuJUxTtwJ
	Nx8uJ0PeZUx+rBTHHmwzRpiNQF2tQsQ=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b54b2428fafso263024a12.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671938; x=1758276738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPBHXhel7rMyKaWRDIHRGBdLv/zGRcLPaVcgqECt6eI=;
        b=cl7ZScJ9+HQs5GdymXNLynZ0yj+U/K6gFX4rI2wEAHWmCK9mrrWh77Kl8euTTOpUVI
         HoLH2BXEyU+sOaNPZQRXdae6Z/yHYUnFQdVZM3NgT9tf8OjcxYvQRwlWgJHRmnsLi34l
         YWlIlvWtXKlQD76//4dEyOoOFwAPftCNsgrzqC2oZE+fs1CvNBCzxVNmx7MMwqu9xBfq
         5FRuoA4Lfg64yKb+rvSfe4Ftfg+65m2Gk9hrpL2flIt4YgRaSfCcu8f6TGoXGRwl8OQS
         G4locNFiGK1eJbIy3DbEb9HVoWzIgi3b/1ipqIfUNsp7rWmivvF26TcUysQN6XsbRan4
         fGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671938; x=1758276738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vPBHXhel7rMyKaWRDIHRGBdLv/zGRcLPaVcgqECt6eI=;
        b=VeThSUSEMyd5QZqXYhaoaqV78Mk8Xfae/VNcTlCwicn8TfQU0fPXQfNSH+mITBE3VF
         8/cnpeL86sWWi6azeIAnic8k9I0A06qVpMgwJA7cAGsOIogCJa2O8b95fL9R8eVlHQjS
         QSteieaLP1a4qQIdbt45N1u0trw4+2p15Me2IBGhmg5H49uJcUugjetpANWOOE1HDo0M
         A3j1HNTjAZhvkETMgGnTBF+H/TDT8kkrwGfDzfTNJn/BQweYgIJSUm82owiu6HZyvp5c
         +/SJMC2JXl2fo8g/jloBYQeNYWrvKcnxxHOVbhqdrB0gNAkLIrbd/DjkNQEF0kItfZGj
         WBCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXtbUMg76e3mAQaA800qShs9nWT8ylVm/xFaSSoG0zpkeldksSY1H5nSX/kg0UhFXmt22mOUZFhA==@kvack.org
X-Gm-Message-State: AOJu0YxN+DLLaizOODdy/y+rIRd+DNmwd9udZ8ec92SNiRzc+i2JblP6
	mrAcuSSLfA3cg2kCi7zxG1i+/PFf2366ET8n8SdDlOvPiTfAojV6+o8d
X-Gm-Gg: ASbGncuo9yVqqiCjSXVVQ1jLv2Ky4jt0X5femyUIark6lFi0e4iCaCjcDOWCh44554w
	LlLug3wdm5xP0ntFX6uRe99vaE43BiW8NPjJKoesdMK3SCyAQQBriirc8vGa50ij/FqNLQY9Jwz
	zQ7eLRCuQLJqU7vRYVGQAr23bvOCWDTdLMYxQulLrk2TCegP+fyYDDEEEYyCHyvwZ2hz7khRCxx
	54IgGSawIEZI0S3qDzOt+7SE1p4MiBshRXTbOrO8rT+Q1rSCiuhqTByP/VIQgyoFP9E/jDBjK0N
	dBMe5DiFOdVcF4kuiva/iawXLhs5I301I7KPCcddSPqRpwUvRhgwUEwH/v/fEHqSOHNwKsLePD/
	i45glS+CmPsQaKq/UV2akkRfDKe/BeIUmxNvHSqs=
X-Google-Smtp-Source: AGHT+IF0a8WwW7rBxRhd3Sx4BYYreRthYgFLu+D24YzR2HNtnMsrUN51Z/p+oaiQ/+b9L1Xt/Owfnw==
X-Received: by 2002:a17:902:f68b:b0:24e:7af7:111a with SMTP id d9443c01a7336-25d281077cdmr34352375ad.49.1757671937679;
        Fri, 12 Sep 2025 03:12:17 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3b0219f9sm44620085ad.123.2025.09.12.03.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:17 -0700 (PDT)
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
Subject: [PATCH v4 04/21] mm/ksw: add build system support
Date: Fri, 12 Sep 2025 18:11:14 +0800
Message-ID: <20250912101145.465708-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12A251A000D
X-Stat-Signature: pd3b9z6ox8gkc91xm8t7hyejxo3duezj
X-HE-Tag: 1757671938-941820
X-HE-Meta: U2FsdGVkX1/hEE+EnEugnmaF4aPtecyz+wDkSBpmQtUKCWuKt5+q8b0vFTs81HL6nrKmbdt6FCMX7AXQf7CYwPCraP12p11xmbsMYteUNAENkjd/U/D7opBmqhw0AeSo9r6pkV5ckLADwyFc4gZb44zz8RODqEWboilEhdhbespH1UmX2DWwu383kbUzM6cjj9s6h2r2yY3cV0p8bn4M/EezPV0wmgGFPqCoEWdsyEZeH9G263fGVWm2OH3sErgy+D25ox585gZOxzEjzD4/nvCpFdSX9km+BKc/8wIbqPqYnA4SqIHaHwRkK8UL1cMtT9UlkzQ1BAFPLfohLtcBQocZLjkZuQW1wsPx0XHfKLh3TW0IjC8/kzEiniJvZNehPNDBRYU9j2HXrMf2NYFJsogiTUbMzI9ixHeBX68yxp1iynjxbWcwyGY0EWWInaG+l61QrxN4osdEYI6Lk6+e91HyY1RIA6c2w1rN7HT2CsxMA9POxk3dvYQH4lG6W0vCVhT6kkMyiNZNxs6K4V6zFLvjA2WU3OTjZLO8uvNYRNMqLI25NkCjgS+Zpz2Kz7XlcytBA9lFYNoM5gMmFBgrfXxxRlFA0YDGTi/uxNby9Nnh6twk7TdnzG9tP01ZZupjFkDZi/fXvA0mLabnbDWyKS1q/b/PheBVHEku7UKO3sg+yynvX4vch0GwQWuYdffCqsEv16/WwB3Kif81DYj7EsMAePaXC9r29zWQedrXh/e84ACEXSZQPjfqVDogPnUFB0u0amgbklWwp5Mtdry05H8+jt9ShDxbYRBZn87EZXpBjbxQqrs6/DOoDrEpSsMzLd0A8P9/dxdtrPlVbFJHkinWBh2N5k18+dzjmUI+Jp3CLxjTO9KBXkVXHhAPHLXvF83fkF6jV4u1Mw9hQdkP8n1IGfwfs+ijM9UX9bg3d0WKK9zgIt+Wy6oGq8AuY6jQKCfjRLti8wbsvCyHiqk
 XipuGKna
 55TCFSIVGLepzGyDIrg5Nj7FcYdN/Dl1tBNg5YTYZCqnYf0ifgZPfkCC1N4zxWR4BgE9Hlwt0fKpdRD6Y1VoOCRjCEnloEuy8jfB7CmcFEGDjQc3joMH3FXgnmGFjgf8ZT50AQqNwHfqsBq8wu0DyS/PnjMkSLUc8GIK0UqiSRQwiqv93v5l3VOUwFWiroYesBdRnWVxPPW0EmDPXAKjSRO9L45UXFBMIcMpBofZpEETgt7PuwEPpyWb30vQ7Am+kEsbLL7TieWJzgDugsuhlwI9raNGLw1UPS0smtA0qGSNSeTcx7883YBS/Ghc5JeXhT+JyZRZZK8tGXlRz2VJX7OCdq4lekqvoMQo4h+4tjMu04Kc+oB3ff9kl5szEWwCgIPokFmfHj8dq4VAW36xYErpjGaJUhYxy2UJlXWEChx00WNmWebBfV2iu5PF3GHlKiHYBEJ7CUmrny2LKeqiCGAvg9oMHiXnUdPbNyI+riJki4/8h3/WmshPnMsxlv3qnEGNzIxccLwLvTtTAiPRCk+1XmpP7v7pg+9yVcAqaEd1XnpetS1FA+JxQefjXZ+3GsfFPYgndr7Do9Eykh/tBIAYN7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Kconfig and Makefile infrastructure.

The implementation is located under mm/kstackwatch/.

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


