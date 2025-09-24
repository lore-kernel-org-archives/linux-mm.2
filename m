Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71B0CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219C98E0016; Wed, 24 Sep 2025 07:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA598E0001; Wed, 24 Sep 2025 07:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0924D8E0016; Wed, 24 Sep 2025 07:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3F2D8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A57C3437D5
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:21 +0000 (UTC)
X-FDA: 83923980882.04.5C574CB
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC27B1A000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mRZUuwKg;
	spf=pass (imf19.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
	b=oI6oZ//QBO76tSdjzGxvt8S6RZB2vpottgcaxccRPBn0h+VQQUxwBFa2wyqLiYfjPcU7uf
	asdZ5iKdKdD0aW3RIpfHyq2qTQ57V5wjQ5EUHdfasSVGtXKsHP+f06HZF8x3CZdKUU9f8M
	j+29IW52mzHOy7NGnCFDZyTel5T/czU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mRZUuwKg;
	spf=pass (imf19.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714739; a=rsa-sha256;
	cv=none;
	b=yfLWmESyejcagz/x+CqvpvJAkvnglqG1JBTfpEYHQoQ5JvZF4OGdXI5GakGfh0c7Zieglq
	9kC0lLKJOl7VTHGQMfCs2Jr7HTv6uGf5T8wO7RpLzN8C+razXmrREWkh5AoKRYsT8me03y
	mTT/ZO5gfmWpSIizh9fDP7manKmtbu0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-25669596955so59534685ad.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714739; x=1759319539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
        b=mRZUuwKgp6Iu/C/YjD5eVXi/xAFNbsoz59IuHskrEpbak2+KW2g4qmtQkoYdrlOoxT
         PLDhAvsVTyojijrk8XA///fwXZvrsAOWeD5cDr/jJyf4IbJQpg1heoNUkV7IZaPoTgk9
         iN+Iosr6vWb6u+Ojn7ydU8ngLyCMoucQS0YNOoQVYIAB53LKkWFHDA+5E2G9t/1hhwSS
         Cl4/dZf7y+4Zh9jK6/A5fgajmCTYZe1Z+yiwG2ygZS1hObehv0qUGofFe0F6TmBvMeUt
         pocQXUDn9NbICbSUgjqKfxu4J+0w4GII0aYGcVqKVJitsjb6b0uGe7CfP6wUeupMgG2f
         e2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714739; x=1759319539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
        b=n3dPDP4wnP7Uaev8+kL1sD++pFQRTuLG061rVjHwxtuUgVMlDspf14zRSznwtdgE4u
         ApOf2lBvfTRQLBPVMydZmCGqMgoK7nLxF2z3GA+F0Xgh4SzaurOVmK9ndvEg0MjshUHA
         +QhhdlnG4bgC1J+Dtwh1HePn2A+3b+w3OdxjCGaoOkkH/K6dXHnWczqjvPsuzFsZYWgV
         4/XQcIhqpIiillaasV9JTLlHvkGXLu8BlNL/Xxr6JQl4EIB5kzC/iV2AMUHUMRpiz8Yg
         SZaIEg8TnlgcJGsJjgwXJ0h+NWmkqQGMHVNV16W88lqofRP9TjHRKPROQ9x8ihkgT5lp
         i+uA==
X-Forwarded-Encrypted: i=1; AJvYcCXaxmjW0wYwDW/YryMAr6BJSEYP0t5XLThEtcQ3sRQTBX1AcBoU7vhDaKykGkx5Ur1FDrYd4QdXRQ==@kvack.org
X-Gm-Message-State: AOJu0YzJgAkL4XquFg05BGLqQeCuLYFisj7MdBbqjxv46bS/PL4xjQAs
	iY/DeLIN19QJCVmzFefLH/EUUDgcxZUbw6TtQN4AuAQMLyKChWwCWk05
X-Gm-Gg: ASbGnctDaLUs7hA1+TSCQYvMjIGL17T4tg9ASfSKUwYcyoqAA/mSW1li7rY4ERUhE/R
	djSVsBu6bayvvsRj/7fJL5al7iF1Dycb8dATA5lzNejbLnP+arM0yUlIogYE2H5Fcf9Ouw4arel
	vS+kJstCvK6ac1g1RLKpvZCIWjqBqSgjzr6nvmmVkPiHEqeW9dw5Zx20GgKnNPNspH4yYCBH02u
	3FGeKLgZUQX3LinANfbDt6c1Nn5/y8nURtj11/YNk3O897h1SPmi5bS1zYKqaxpgz37RASig45A
	sVIZ2//YkT2j8jpDAzEj3aXe088glBZd3iD7bRazajYZ9Bc3kRfyBUKSih8l6vP8YA6snnOavWS
	x9p3jBch9J6E5Fq2aSBiPQ7nrIg==
X-Google-Smtp-Source: AGHT+IEDDMc95VZgHrJ2bAg4UbEi7E3pBoXcjCjpFvkax+6hzWgfw34rDBIIXWBy56pkk1ir13aqcg==
X-Received: by 2002:a17:902:e78e:b0:270:ea84:324a with SMTP id d9443c01a7336-27cc5624e4emr73742285ad.38.1758714738650;
        Wed, 24 Sep 2025 04:52:18 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2752328629fsm101241105ad.106.2025.09.24.04.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:52:18 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 12/23] mm/ksw: add entry kprobe and exit fprobe management
Date: Wed, 24 Sep 2025 19:50:55 +0800
Message-ID: <20250924115124.194940-13-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: coh6c5ph7gpjq9xc5b8ufqi3m5jfrbx9
X-Rspam-User: 
X-Rspamd-Queue-Id: CC27B1A000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1758714739-648286
X-HE-Meta: U2FsdGVkX1+9MM1VrHxbKvkDWpfvJR1a+6H6/lDDnTZAWsb4L621ZueKAfCUlS9/Ti2J//cumksn9nJ26jEnDBWgttU0ld8LnoaDPTCpYvXinK3HJpekpWPMQF+KFOneXdnn/NwrYPxRaf1w1jagwLks7wRZMnvWzNl0CmaF0fu+ZxGtrrkAH+yEeTs3Y7zSGsU7oRkWgmqIhsh6fFb6enWkV/a044woMUw1v3c/JgoJE4qoMumf+lFmKkpjtJCo6I96wdBFIT0juVBhr4PApBKR6R2kFBbxU73b6w0CL3HXH9AUFx8+DhQgXAFtWh7SgUOpIgLyMPvcWEu2U/FTU/mUdNgylWFPPSp72yZv0RTFdlQqM0k6QvaKEBv/q1Li4UEhJm+00Rq9RDSSZLXU7hWS51HE/wQIn9dy7CauAd8c1egpxYuxhNnGMUq6o+s10MG8Uli9lZRewalA5CZBfcPOOPt6lLrseA+x+iO7294l0T6MoXdwmAJUdxvfi0qsnkrJOCFMvxszT1rYcaa5TYpe4eP12MnyM/LPZ9ccr0HamgHz2m60P7sddpavhdb153oKCTE7/U6/ijAcNMqt3crr3bR8D/1VOqGS0ZYkmfEh5OCLnS+iSYB7uTTK1fQMyqwEXfmZVLczjsJpUm2BqcQuVD17pkbKsNhDIlXB4NQPo186H5aApIKlvOU7GPhR3hg361DRUptuyhnd5yhz+nqNEA7Jl52ZqC0cUzywoNrINktuyX0TWkG2mciU70dqui23nmCZlht/mQ8XPir1SLeJLzrliNMmfJSZH8qUqHwqnXjLfe8dQkxrVNMsjh8s+dJ6YrKCXnGfT7qvF1vD8oBFjkoM9Ufn88YFgkyn5pyUw0pY5eybu9GaME1sAbkMNpHq75JSJ+TWb/5xV3OUESVCDuNBLNmMivc9AEMP+SCu3O9C1QZpnGOkEfcjH7IyRRXwxVNr/3HLtCdWu6W
 Xd8ytAdJ
 VEXAcVdzYgsDcrGFZtM1kIv/TAFNfmYv8osAcRu51xYMZs8PSZZoFjN9zVjuouLWUwnudqhWuM/fiU8TVTpOaeZIMED5xW3/qbiJ0T5mmHBW1340Lpjg8BNjHvU5TwHgiYm/UB0A0RqHUO4OmuslVxoQayt+981xsRwSn9dJXsQE3UqRw/gutqOPWJVx3mzF74blCWXvny4si/QA2uayxgepKvXBMldL2l7FNlgr9Yz6nq7grSAuAnYtIuh7VgrrZopX+5ql94QpHyudkjnnV5EHpFaOpPU5HZZ/gSf31vnzQLLgR1sPxwZnjdYPeXNWZ5lzDJda3zkFu/AjTSmY0W/XHkcwQ24WVw1C8Rdv3NwWcnKbFjF4V2MCCNGxYX6R8fHwXeuy50Tr09AVJfj7Le3bP1ygeXve4GgWFHXJXoSfyFfsKMuDoeS/EYRPwyLowTkckeMFb6Po08e/C6OtN8f3u6k0Xee+4sVWz+johYn6WbiFY6MeGwFdzS2fvItwGPKLNBLq7Jkf8iDL/2PX4YHXI9HSnuIG9xYjGARPu7y1YanxYnFvq8hrOJrUegJ6vTo8i184GUpvy4hXG1uXxRO3CSA==
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


