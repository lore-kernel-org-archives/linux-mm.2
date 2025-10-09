Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29064CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4A18E0082; Thu,  9 Oct 2025 06:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC7D8E0002; Thu,  9 Oct 2025 06:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2EE8E0082; Thu,  9 Oct 2025 06:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4F58E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CAE2140829
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:58 +0000 (UTC)
X-FDA: 83978275836.11.4D30DDF
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C455120009
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XirVbruS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
	b=xUdtuEr+NiL1JJerDcVgp1Cb8nA2dEvVRvqChtT+CFfZepPV2zZKXZh2O+lTPYWVkZgfuR
	K0/651jYE036rsgbfMmQJ8jsE1KEJE5SJAXN3UkoKrvbGsuLFGgP6FwIwpKeCi+8AhvZIG
	XNTbVWWAmbbUL6LrX/ZLIDtUzpVVglE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007476; a=rsa-sha256;
	cv=none;
	b=VClnB9Y0COPLDpJBb3WbCX9pHtSZiCVLFgUN9TnJn2Oj00wgsQoDzFlAe+xHHbeWdXs8tu
	J00+PGcRL343LHz5fN3axt+Z15tLbqlVJ3QlToZPI7pOycW9YLh8Fv2oBero7d8xJvBCBa
	SpdxCIhPaSmOV85tNZEaNxCR8PnEp+g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XirVbruS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33082c95fd0so1078047a91.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007475; x=1760612275; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
        b=XirVbruSq6L/+C5ibo95Cc7tJRPFDu6t2v28IoLJq7VHEbI/3LEErMMvBgGgZggCS3
         TElrWoRAP0hdaOrxb8AY06HNsFhvGlP6aujriKY1efO/df4UBPt8R4A/tDRPgy+yYpNd
         Q4oHgzpuwMPlWLBXxh4W4aLTFUrFR2hIZRknsxD/nKMV1avIZXLe9jbbgUbpoho84MUA
         myIbTmPCTl+NEhd3pVxQ+uiSjvGxlN8tzJMv3Rh4hms2cdZW35i+8qXzmiZopzVy8dD5
         OcTMmaFnoYKRBoy/hgrQuqms5ZTG13PDtqac+HxFT21ZGKIj2AOGAvPpBfviIrSs2dg7
         9Ihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007475; x=1760612275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
        b=SSongLWoNMU6Azo0GH6tpv+jk4TB8LikPfctBGo2APmskf5ru+cFIMSMx6OrYQ7IpM
         Pg9ur+KUDcqO+1wkkcaENPZqg1hiLIabPiIVN2KQKU8cxeCBUUbZq2VJiaLkCRXnUQQ0
         OTRF0z7L/WuxWLyhmYuGN3/Ai565BTQbRLxDhXFGkV/aY0PN/Lz6KUQKgqsdvvbchrwg
         B5SJpFuVsT5wHkvBsmbJEn9w0yiBi4VFngvcb3lwd3kojZIFg1jbGnq6D5dq0gITHjxu
         otXQk3+Y7zSBQVycf27AJa153Bu/pTjm45qbAHTyV8iXwhgDU+0Vsahs5CfWj0VwmA5S
         E/9g==
X-Forwarded-Encrypted: i=1; AJvYcCVX6qvff+tCUuzBOl7aDha6aa8CKhy1bh70Y/H+Sc0vFh9QCK6DP9PfE8G/jPqjSwEN1NMuV3MOyw==@kvack.org
X-Gm-Message-State: AOJu0YwjTWIQOBBYCcrOKzhmAFlUNd815dMDM3SDetb+HTzfXkU1lfqw
	6es7SqNaPskZRfyS4kBS3XANikgYuhniykmUJpEZKJTZBY5tDhtyQ2vp
X-Gm-Gg: ASbGnctOUgTjAXK6zpN25pJjjRZD7P9S9+/JFyaBLI1M2nnbrgmkEvY4vt4J8VbtSY0
	xfRaD6eCfZ49QXMkS2m2iY2JqUUNuCauaV87RWqDmPnaFWIfOUObtChrOI8sf14fgJAU7uPhMuh
	lP+kSz0NzOT0H0/kCCZYKLDzwo0wyJrapFHr21oI8IzLyyU0pprHRPRaFnylUc2DqXQn7OK1+h3
	eYqohprwy0T01mb6XjdJxr9K/9iqcqR7nSW2t6pxTiM3OfesnRkCl7svnr42SzSI33JNk8O75Pi
	EW0My+IUD3Fzqa4rSx5xQtnQqr/3kIYJMJepiVmokB4GEotKUR5beL61+o9bRAU2+6iRZgA9Zhh
	D2pipBt5q8/xbAN1CH1ccXeGyS4unPiFoUyC3kKkz9dcmr+pCg6OOIfxtBFPi
X-Google-Smtp-Source: AGHT+IE9NnpcMWupwlw2d16VoEQWRKCqW2Bel2NYXvT1Gf2U7ZL3QTEBs97P3B1zPpdcUzC3SQMjYA==
X-Received: by 2002:a17:903:acb:b0:24b:270e:56cb with SMTP id d9443c01a7336-2902739b362mr90085425ad.27.1760007475016;
        Thu, 09 Oct 2025 03:57:55 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034e1cc53sm25234015ad.46.2025.10.09.03.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:54 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
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
Subject: [PATCH v7 12/23] mm/ksw: add entry kprobe and exit fprobe management
Date: Thu,  9 Oct 2025 18:55:48 +0800
Message-ID: <20251009105650.168917-13-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: dkx94p3o3559odctmpj6gukddjaadomz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C455120009
X-HE-Tag: 1760007476-963642
X-HE-Meta: U2FsdGVkX18sJaZz+/LJS8fNL4PCr4XAhm7V9ehIxVxccOwGRVGhgOTFe6h3El+nbHCfR6QHpUyglkIopPEVASTR+NDQW0RMyJl3PXpzJx0sJTf5MdaClk19vGpsgTyY53lrQmJrLMNbcPmlbqvMau6O6pGVleBe11+3qQBxsBY+ScXhv/cEALJ1fiCX/AK47ZY438uqDAfaoWrxbujTBy4Z+TjRN3BKlv7DbRKglWWFd1Uhenv63RxvUhNF4koMivk9QWO88+zXTo2k2GH5wvOrln808PY7vbzepCgZrtyfiM1P9cszps9CsfEh7gRyK/ThBAKy/kjW4FUjqSJ1ahy5/Akh/5wt2YDsmo3ulxE2Mgfs47vLvLZQgl5hb/+BjAvu4+QnXnfNSvGIQTs5ny2lW/VIkDEkaKRz/0hOsn8sVYm75sBiI4d26KyUrWwnUa2syiDDx6GpIDVAY5HbiMXVMV74QDmdPyiOUjFxzjCpQHx36FqLzbDwxOpL66qHnYCnUJjtKdmrAVp0FHFFCLwei8taRWuBNRaXBzlRdOe188V27g6QOFeLXNPF3Xh64WrQIizvuRFdjn11h9DxJKP8tkYRbHUi427cOz87iTg7oxLLOIYio7FxlLvreSjPDDF5S62QhojObfr8XCc83GerrmRn1nVxJYgUOOmstPhl98cV0tPkcFj+Ld9dQtSXCpKt2aZpg+TuFHQ04oIWU7a7Z+Olv0T7Qt/ixr2ilCiBP0we0U8wcs69tCsnY00hZYUTLscmW0wuHPD1iXZ4rWJ5RBq6J9tr0x0Hs5YXXGDrdX+mMTBpwYUNJL8f1/ADSK+ges613O+nbpZbwm1Z+Rnb7bOIUuEi2R3GVGZI04/zCDX7HPjN51F/9c1/6zO8Q1wkTQaqKfJ2KbcOQ/lVpt1O0sTFZ5dnhw62sBbf/9u7HyTuAnoyJ9PHflm6Jhljs/bm71HDpKE8lfjaNsV
 S/fEYpDw
 QGy0jt69k/jnpNWEs5PNtShaOOPCL87U+5MKqbDvGmuTTX6EjslfJadawmrX2QXQqR+tWtSkHGbGYGZrQgpPOeC0YjcSzBHGg6Y9PvIaPU3l/VfV3cYQBj6F9h/lXpVBEA2LRZGy5Z5nEdi6OpMDg804fqGnq5+9+WAseV5b6ilgVO8FIkLQdesT7kfn+YZ0HORmTk5xhmgHFAwnf0N38Slp5G0n9wBy5mbrc55EvEJXqqhYUZpauoL6+yC2yhpzLe2yjbzxwzkldCzMeBEVPzPskVxlrWVuekLvu65UFKrLtnNMUoFFG9g2B6MmV+HDho9iixdFs7K1jJuujH2JWfAGNpMCDjukqlQrClZXJm3zboaahMJgmIbe5hvcZ+Ap8kedwydbg6VqIbCZen1uSIfCPDTUl4vsLbHsnqxRlnbFoU13UrVHP3OdiV4OB0av4Capm+Ujgqfen98rgkCPb2Bub85ggRkzhu3WSt9IFALS+hGLIEzj8Tj1ISBpGAx1xbPdxFEPOWdbNbmTp8UajtByUkQjzYhey7H5Zubadh5UZbTvn7DeACEGEShoQ2sXTL6X2MGjPmw8MxCqPOmOj3W0bKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide ksw_stack_init() and ksw_stack_exit() to manage entry and exit
probes for the target function from ksw_get_config().

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |   4 ++
 mm/kstackwatch/stack.c       | 101 +++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 850fc2b18a9c..4045890e5652 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -35,6 +35,10 @@ struct ksw_config {
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
 
+/* stack management */
+int ksw_stack_init(void);
+void ksw_stack_exit(void);
+
 /* watch management */
 struct ksw_watchpoint {
 	struct perf_event *__percpu *event;
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index cec594032515..9f59f41d954c 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1 +1,102 @@
 // SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/atomic.h>
+#include <linux/fprobe.h>
+#include <linux/kprobes.h>
+#include <linux/kstackwatch_types.h>
+#include <linux/printk.h>
+
+#include "kstackwatch.h"
+
+static struct kprobe entry_probe;
+static struct fprobe exit_probe;
+
+static int ksw_stack_prepare_watch(struct pt_regs *regs,
+				   const struct ksw_config *config,
+				   ulong *watch_addr, u16 *watch_len)
+{
+	/* implement logic will be added in following patches */
+	*watch_addr = 0;
+	*watch_len = 0;
+	return 0;
+}
+
+static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
+				    unsigned long flags)
+{
+	struct ksw_ctx *ctx = &current->ksw_ctx;
+	ulong watch_addr;
+	u16 watch_len;
+	int ret;
+
+	ret = ksw_watch_get(&ctx->wp);
+	if (ret)
+		return;
+
+	ret = ksw_stack_prepare_watch(regs, ksw_get_config(), &watch_addr,
+				      &watch_len);
+	if (ret) {
+		ksw_watch_off(ctx->wp);
+		ctx->wp = NULL;
+		pr_err("failed to prepare watch target: %d\n", ret);
+		return;
+	}
+
+	ret = ksw_watch_on(ctx->wp, watch_addr, watch_len);
+	if (ret) {
+		pr_err("failed to watch on depth:%d addr:0x%lx len:%u %d\n",
+		       ksw_get_config()->depth, watch_addr, watch_len, ret);
+		return;
+	}
+
+}
+
+static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
+				   unsigned long ret_ip,
+				   struct ftrace_regs *regs, void *data)
+{
+	struct ksw_ctx *ctx = &current->ksw_ctx;
+
+
+	if (ctx->wp) {
+		ksw_watch_off(ctx->wp);
+		ctx->wp = NULL;
+		ctx->sp = 0;
+	}
+}
+
+int ksw_stack_init(void)
+{
+	int ret;
+	char *symbuf = NULL;
+
+	memset(&entry_probe, 0, sizeof(entry_probe));
+	entry_probe.symbol_name = ksw_get_config()->func_name;
+	entry_probe.offset = ksw_get_config()->func_offset;
+	entry_probe.post_handler = ksw_stack_entry_handler;
+	ret = register_kprobe(&entry_probe);
+	if (ret) {
+		pr_err("failed to register kprobe ret %d\n", ret);
+		return ret;
+	}
+
+	memset(&exit_probe, 0, sizeof(exit_probe));
+	exit_probe.exit_handler = ksw_stack_exit_handler;
+	symbuf = (char *)ksw_get_config()->func_name;
+
+	ret = register_fprobe_syms(&exit_probe, (const char **)&symbuf, 1);
+	if (ret < 0) {
+		pr_err("failed to register fprobe ret %d\n", ret);
+		unregister_kprobe(&entry_probe);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ksw_stack_exit(void)
+{
+	unregister_fprobe(&exit_probe);
+	unregister_kprobe(&entry_probe);
+}
-- 
2.43.0


