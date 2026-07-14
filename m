Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 572D8C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530AB6B00DA; Tue, 14 Jul 2026 14:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507E96B00DF; Tue, 14 Jul 2026 14:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6BE6B00E9; Tue, 14 Jul 2026 14:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D24F6B00DA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:31:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 684181C048E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:31:23 +0000 (UTC)
X-FDA: 84988224846.30.06D8FC4
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8363B4000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:31:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=roNpbHb7;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sIaGf5EzkbjI19/agb6agMi3UfIlX+gCu5QJjKxqwU=;
	b=1crtUWhXNC7EM8i8TLf3NH9cArzEHIXMov68AWJ/UwU/E1T00NParhduFN64iOP5NF98uV
	9J+MIbaLhTUD7CpyraTAnyXdaKDsTRep4RjXc5rj6L3obG3PtHoVIZTKHnUyrXj9n6bY//
	1Wyj9WMfTEdZAIiwEYSjWXvJtabQoWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053881;
	b=G0maUaFU7UOvFr/FSIP7GkA/4nCY9R8hvTmIGB1zIiwvNm5lA457g7ZQXiyi8pDEA4dLuV
	wvy8Cv3xdAryjmpCUFzQUsah8vm8HWBWZW1wpGMhkclUhl+nBXOUgrqOSgRctS6fahztAn
	6D8DB0hW1K9dqhwIeOaGBYX4+o2yjBM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=roNpbHb7;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c0a81d286so8915061cf.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053881; x=1784658681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0sIaGf5EzkbjI19/agb6agMi3UfIlX+gCu5QJjKxqwU=;
        b=roNpbHb74GfjMNlUEKizNehojRvZvp2CRxuN13NlpG6cuQ8hQFMvsS1hcaJEFm6wrA
         H8p/uN4rTe1OzxFSln+oXQcQFDilmYlh9eklnc+c2SUeUPyOXG+0m3DNtRgTkBb/fCyQ
         DchJNxBzFg/Bpbcbjef2rLt7wc9dLru1BrbbHwPruldurSpag3KkHmUuCBWKlDQ4jKNa
         elMrhAHUWkD6jJRsi0igPFqb2McXMjdGnX+rjoCi0+zKyHVwmps9nZ/kVByqa3feHlgG
         t6o0jMz0aGcYstxNzdUsV2K/sVrMcjayKzGQLM0hacOWB33PtZIyl/QyuT2yufR2HxDS
         6v6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053881; x=1784658681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0sIaGf5EzkbjI19/agb6agMi3UfIlX+gCu5QJjKxqwU=;
        b=K3Pnt4BplejQgzK68nJNftuIxHLXlPMiXRnctCy0GjdbI3cdX1m3q2VKqArmPJJ65o
         XwOcxPJ+llKPDXUa7JcFyfNQUqgiGFIysjG65tQ/Y12SjV+3PRwJNYp8Sb8x921FFzQn
         FRCYU2oATbmoC9KhhI70+ZoAdEIT/AEjW3dVaBY5arTyFv/q1qnO6jZKw6Z59FQDWhqq
         MVGp34IFockV/rrDhPzsCKvRc2v4JXltDEZsgS/78DImNct6t6D5WJH58LKYBDukHpfd
         oKsk9PQNS/LYUdRbGgjNANYDKdXfhT6R7iKMLPes0ni630QdSFIrYThgJDPWdSUjpEIH
         3/GQ==
X-Forwarded-Encrypted: i=1; AHgh+RqjQyONxvJipitzJUVK741HmyqDpiLSDUOce542iYcyppIOjJCrHZKKzh+YRADY2V8SGNZLgBk3jQ==@kvack.org
X-Gm-Message-State: AOJu0YyxB8XX9EYVIhzEie9tQm8a/lfphxJFaDjeKVNQLa0yxG/p3wzJ
	WMoxLIBvs6CKXdmFMTh6oWl354DvL+sJTYmSYz3VJcXd7vwX76/xDS56qt0SkQ==
X-Gm-Gg: AfdE7ckgYB8slF3ZaBiXC0L0r51/tHT4IpC5Jj6vzSrBxsXQ7kSvv36Dt3j1jP2l+w0
	NJRMssAjgm/msRf0SS1ey8UcjloK4V9mKP8H6nrQWnPYKYsH2wzG5rgFAN+aJOJJcMndFaz7dHi
	IW6gH0QQY+RSvLhV5tyzLEOmBetg28BSdGn69j3ckOQZfSxOTxHMeeEmRDvv2+LLr3gV0pczI4J
	zBpA7cqWXIk6HE75fedVaSoP3TJJ9GGVK8i7llGFVtIC9a7ko8vMhqnN/Su8Kq++rhEg9Qrdkgc
	AkZJvGydb1YCxoRm+dkZdncQyUD1NhHIHj1PWcCVR+9xn8RNBLIUbIRN2NlRw/e8uPu2919X1RY
	P+DScs2mnV68fIxIWkgBvwU2U4sqglGyRuW+5+Wj7vJrPwsp/Y8bHxMiim+hZREramlw/cn9gxY
	iO6FCVDfqjDLnDnyMlYqlJlhH/+xmm9zyKQ1DNn8mJEOxYibdF62k=
X-Received: by 2002:a05:622a:306:b0:51c:f64:bc39 with SMTP id d75a77b69052e-51cbf741118mr134331951cf.3.1784053880463;
        Tue, 14 Jul 2026 11:31:20 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caae24d04sm117196081cf.18.2026.07.14.11.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:31:19 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 05/13] mm/kwatch: add watch expression parser and dereference engine
Date: Wed, 15 Jul 2026 02:31:07 +0800
Message-ID: <20260714183107.12463-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8363B4000C
X-Stat-Signature: 63r8n6zuann7jiqmhi44jwrbf38t5zgd
X-HE-Tag: 1784053881-692767
X-HE-Meta: U2FsdGVkX1+Lj+hSDou1zteEXgd5xG+QRxHVjEq5uVVzSuVRGFUIEWRfBx0ySAhxuujkhW6et2vxDBp7Svf00EnE/UWGU8ZJdNVYTH6FonRwnfc6HpC7bmsgf5s5aafxDpEam34yiaZFcCzKUafmXvQGdTEC/nWIywWMgcA+YMEo4nb/5jcQcpeChy4xpoeYZ59dEjKY4al9TSEV81pFhULVVcEfNtwrZq7hMnwsWz+67jMDj7o4ahWtc5PAdsOejKRx0MWipqzULB//zlrDwnuQRAdquXKFPbrnS8nP7Jl4WVJ4vWO8BaxITUt1TG9tEJwr7yAq1FCLsVm1meVM38Y4ntqyyemshbm6W57BWO6BgQpCXaf9LO2YgAZP6Q+u+XOhDAfQ9D18J0YTjOeYqySttM5Otzz7v+N6j3kW9kH5A2+s4eWRp6jBpgwVwZTOCrkRcJZ9rGMOcjIzPNBGhdTcRJzRE29834A+OpaST+ssLgVOEun+jCGwh7XFQlqDc4A62snb2muo/JCQhC8px4e6FR1B0hHhc5OQZ5YqRTdlQgKMlthG54YUs/nJTsM7foXdGdPhExcTD7Vj34AiXUWOMtYIlv1dnGkSfdkG/HVKyeHgVffZF4EI9NVDPd6hZAkvOODL5X3T9H00ocGmq9j46eDteQB/YM4qdXk97urfFqegl+ScwQk8+zFe8zH6w2gR3VgCFRLKPS7nkTVwCbi53PAO6mfc4ZgUULNmmmKYAdRc1fJhZ08wcU+tVAfSpJDu/8sJmsqhu5SXFFKURVDt8dcwGPruS1qAEJ9mWeOO3M1e8VvhYe7TbuD2JmUh+xzIr+GAtLFX5Q/6cR+KjWUPI1X8sK2iOIR+rMxnvh+One/vjzC8xAd4WHJJdxcPTQixgKaKY2smege5d4rXGzXZHDKyNN0teCP1V1ZueTOpWt762IrauhAZXoZCCZT425Mk05Kx6LGFO3WRbsc
 Et3cCwWa
 nmmOT4Tog/Ckt7MlED/Va8G8EleQBLyHjoOWueuog/ygnvIjzs6B3PVYpWH+aiwqUZ6Sol29B7pTZI9HWHxEeXaCgWaHZmYmzXW1sxzaV8ILdNtsnvDS9b2tRd6WdP6B3QlvQVaY9+ob5mA08vlknMGOq67vwsCmNtk7D62i4+u5UAcTQ49CeFJ/tOrqIYT5P1NLyJZiXzqgN+2rxPY1ePenHj8UaXs1DhfC88+KoQBbIFf1b+qcwMsh480pA2lUBk71eI3JzsXt2Y3AvgxBGfB6d/4g51O7BdjEh8ET8oFynVTES4s8YqukIUb5hG3ctoEiuIeZKrTf7rULFNw9B6sM956ucgW3tIJwjlLl3DeEPr6OURr1Ta2gGXVh/vOWa1JYxmh/+0zW80GfXyyYIjqdSfVZiCONaLzBHt3GhnBWo2p9XjSI3tPzkMhQ0z6M5eX1g1cdUltgdOfBLCSwMHsxl3os9RnsPvo51aqpQuYDOrBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KWatch watches a memory address that is only known once the target
function runs, e.g. "argument 1, plus 8, dereferenced once". Add the
two halves of that mechanism:

- kwatch_deref_parse() turns a textual watch expression
  {base}[+-off][->[+-]off]... into a kwatch_config: a base anchor
  (arg1..arg6, stack, an absolute address or - for built-in KWatch -
  a symbol name) plus a static offset chain.

- kwatch_deref_resolve() replays the chain at probe time against
  pt_regs. Every pointer load goes through get_kernel_nofault() and
  the final address must be a kernel address.

Also add the internal kwatch.h header shared by the rest of the
series. Nothing is built yet; the Kconfig entry comes with the
control plane.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kwatch/Makefile |   3 +
 mm/kwatch/deref.c  | 174 +++++++++++++++++++++++++++++++++++++++++++++
 mm/kwatch/kwatch.h | 107 ++++++++++++++++++++++++++++
 3 files changed, 284 insertions(+)
 create mode 100644 mm/kwatch/Makefile
 create mode 100644 mm/kwatch/deref.c
 create mode 100644 mm/kwatch/kwatch.h

diff --git a/mm/kwatch/Makefile b/mm/kwatch/Makefile
new file mode 100644
index 000000000000..69c21ae62123
--- /dev/null
+++ b/mm/kwatch/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_KWATCH) += kwatch.o
+
+kwatch-y := deref.o
diff --git a/mm/kwatch/deref.c b/mm/kwatch/deref.c
new file mode 100644
index 000000000000..a93c76139e7c
--- /dev/null
+++ b/mm/kwatch/deref.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/kallsyms.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+#include "kwatch.h"
+
+int kwatch_deref_resolve(const struct kwatch_config *cfg, struct pt_regs *regs,
+			 unsigned long *out_addr, u16 *out_len)
+{
+	unsigned long addr = 0;
+	int i;
+
+	/* 1. Resolve the Base Anchor */
+	if (cfg->base == KWATCH_BASE_STACK) {
+		addr = kernel_stack_pointer(regs);
+		if (unlikely(!addr))
+			return -EINVAL;
+	} else if (cfg->base >= KWATCH_BASE_ARG1 &&
+		   cfg->base <= KWATCH_BASE_ARG6) {
+		int arg_idx = cfg->base - KWATCH_BASE_ARG1;
+
+		addr = regs_get_kernel_argument(regs, arg_idx);
+	} else if (cfg->base == KWATCH_BASE_ABS_ADDR ||
+		   cfg->base == KWATCH_BASE_GLOBAL_SYM) {
+		/* Zero-latency load of the static symbol location */
+		addr = cfg->sym_addr;
+	} else {
+		return -EINVAL;
+	}
+
+	/* 2. The Pointer-Chasing FSM */
+	for (i = 0; i < cfg->offset_count; i++) {
+		addr += cfg->offsets[i];
+
+		if (i < cfg->offset_count - 1) {
+			unsigned long next_addr;
+
+			/* Dynamically read the pointer contents at runtime */
+			if (get_kernel_nofault(next_addr, (unsigned long *)addr))
+				return -EFAULT;
+
+			addr = next_addr;
+		}
+	}
+
+	/* Enforce strict Kernel-Space boundary */
+	if (unlikely(addr < TASK_SIZE_MAX))
+		return -EINVAL;
+
+	*out_addr = addr;
+	*out_len = cfg->watch_len;
+	return 0;
+}
+
+int kwatch_deref_parse(struct kwatch_config *cfg, const char *watch_expr)
+{
+	char *p, *sep, *dup_expr;
+	char type = '\0';
+	bool is_deref = false;
+	int ret = 0;
+
+	dup_expr = kstrdup(watch_expr, GFP_KERNEL);
+	if (!dup_expr)
+		return -ENOMEM;
+
+	cfg->offset_count = 1;
+	cfg->offsets[0] = 0;
+
+	/* 1. Isolate and Resolve Base Anchor */
+	p = dup_expr;
+	sep = NULL;
+	while (*p) {
+		if (*p == '+') {
+			sep = p;
+			type = '+';
+			break;
+		}
+		if (*p == '-') {
+			sep = p;
+			type = '-';
+			if (p[1] == '>')
+				is_deref = true;
+			break;
+		}
+		p++;
+	}
+
+	if (type)
+		*sep = '\0';
+
+	if (!strcmp(dup_expr, "stack")) {
+		cfg->base = KWATCH_BASE_STACK;
+	} else if (!strncmp(dup_expr, "arg", 3) && strlen(dup_expr) == 4) {
+		int arg_num;
+
+		if (kstrtoint(dup_expr + 3, 10, &arg_num) || arg_num < 1 ||
+		    arg_num > 6) {
+			ret = -EINVAL;
+			goto out;
+		}
+		cfg->base = KWATCH_BASE_ARG1 + (arg_num - 1);
+	} else if (kstrtoul(dup_expr, 0, &cfg->sym_addr) == 0) {
+		cfg->base = KWATCH_BASE_ABS_ADDR;
+	} else {
+#if IS_BUILTIN(CONFIG_KWATCH)
+		cfg->sym_addr = kallsyms_lookup_name(dup_expr);
+		if (!cfg->sym_addr) {
+			pr_err("Failed to resolve symbol name: %s\n", dup_expr);
+			ret = -EINVAL;
+			goto out;
+		}
+		cfg->base = KWATCH_BASE_GLOBAL_SYM;
+#else
+		pr_err("cannot resolve symbol %s when built as a module, use a hex address\n",
+		       dup_expr);
+		ret = -EINVAL;
+		goto out;
+#endif
+	}
+
+	if (!type)
+		goto out;
+
+	/* 2. Resolve Base Offset (if + or - exists) */
+	if (!is_deref) {
+		char *next;
+
+		*sep = type; /* Restore the '+' or '-' for kstrtol */
+		next = strstr(sep, "->");
+		if (next)
+			*next = '\0';
+
+		if (kstrtol(sep, 0, &cfg->offsets[0])) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		p = next ? next + 2 : NULL;
+	} else {
+		/* Jump directly to the first dereference after '->' */
+		p = sep + 2;
+	}
+
+	/* 3. Resolve Dereference Chain */
+	while (p) {
+		char *next;
+
+		if (cfg->offset_count >= MAX_DEREF_CHAIN) {
+			ret = -E2BIG;
+			goto out;
+		}
+
+		next = strstr(p, "->");
+		if (next)
+			*next = '\0';
+
+		if (kstrtol(p, 0, &cfg->offsets[cfg->offset_count++])) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		p = next ? next + 2 : NULL;
+	}
+
+out:
+	kfree(dup_expr);
+	return ret;
+}
diff --git a/mm/kwatch/kwatch.h b/mm/kwatch/kwatch.h
new file mode 100644
index 000000000000..e1ac8ae312f6
--- /dev/null
+++ b/mm/kwatch/kwatch.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_KWATCH_H
+#define _MM_KWATCH_H
+
+#include <linux/fprobe.h>
+#include <linux/kprobes.h>
+#include <linux/perf_event.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/atomic.h>
+
+#define MAX_CONFIG_STR_LEN 512
+#define MAX_DEREF_CHAIN 4
+
+struct kwatch_watchpoint;
+
+struct kwatch_tsk_ctx {
+	struct task_struct *task;
+	struct kwatch_watchpoint *wp;
+	u16 depth;
+	u32 epoch;
+};
+
+struct kwatch_watchpoint {
+	struct perf_event *__percpu *event;
+	call_single_data_t __percpu *csd_arm;
+	call_single_data_t __percpu *csd_disarm;
+	struct perf_event_attr attr;
+	atomic_t in_use; // multi-consumer safe get/put
+	struct list_head list; // for cpu online and offline
+
+	struct task_struct *arm_tsk;
+	atomic_t pending_ipis;
+	atomic_t refcount;
+	bool teardown;
+};
+
+enum kwatch_access_type {
+	KWATCH_ACCESS_W,
+	KWATCH_ACCESS_R,
+	KWATCH_ACCESS_RW,
+	KWATCH_ACCESS_X,
+};
+
+enum kwatch_base_type {
+	KWATCH_BASE_STACK,
+	KWATCH_BASE_ABS_ADDR,
+	KWATCH_BASE_GLOBAL_SYM,
+	KWATCH_BASE_ARG1,
+	KWATCH_BASE_ARG2,
+	KWATCH_BASE_ARG3,
+	KWATCH_BASE_ARG4,
+	KWATCH_BASE_ARG5,
+	KWATCH_BASE_ARG6,
+};
+
+struct kwatch_config {
+	u16 max_watch;
+	char func_name[KSYM_NAME_LEN];
+	u16 func_offset;
+	u16 depth;
+	u16 duration;
+	enum kwatch_access_type access_type;
+	u16 watch_len;
+
+	/* Unified Deref Engine State */
+	enum kwatch_base_type base;
+	char watch_expr[MAX_CONFIG_STR_LEN];
+	unsigned long sym_addr;
+	long offsets[MAX_DEREF_CHAIN];
+	u8 offset_count;
+	u16 max_concurrency;
+};
+
+int kwatch_hwbp_prealloc(u16 max_watch, enum kwatch_access_type access_type);
+void kwatch_hwbp_free(void);
+int kwatch_hwbp_get(struct kwatch_watchpoint **out_wp);
+void kwatch_hwbp_arm(struct kwatch_watchpoint *wp, unsigned long addr, u16 len);
+int kwatch_hwbp_put(struct kwatch_watchpoint *wp);
+
+int kwatch_probe_start(struct kwatch_config *cfg);
+void kwatch_probe_stop(void);
+void kwatch_probe_mute(bool mute);
+bool kwatch_probe_validate_hit(struct pt_regs *regs, struct task_struct *arm_tsk);
+unsigned long kwatch_probe_nmi_rejected(void);
+
+int kwatch_tsk_ctx_prealloc(u16 max_concurrency);
+struct kwatch_tsk_ctx *kwatch_tsk_ctx_get(bool can_alloc);
+void kwatch_tsk_ctx_put(void);
+void kwatch_tsk_ctx_reset(struct kwatch_tsk_ctx *ctx, u32 new_epoch);
+void kwatch_tsk_ctx_release_wps(void);
+void kwatch_tsk_ctx_free(void);
+
+void kwatch_global_anchor(unsigned long duration_sec);
+int kwatch_anchor_start(u16 duration);
+void kwatch_anchor_stop(void);
+void kwatch_anchor_cancel_work(void);
+bool kwatch_anchor_has_expired(void);
+void kwatch_anchor_clear_expired(void);
+void kwatch_auto_stop(void);
+
+int kwatch_deref_resolve(const struct kwatch_config *cfg, struct pt_regs *regs,
+			 unsigned long *out_addr, u16 *out_len);
+int kwatch_deref_parse(struct kwatch_config *cfg, const char *watch_expr);
+
+#endif /* _MM_KWATCH_H */
-- 
2.53.0


