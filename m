Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FC1CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713CE8E0013; Wed,  3 Sep 2025 20:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB1A8E0003; Wed,  3 Sep 2025 20:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6010B8E0013; Wed,  3 Sep 2025 20:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF658E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:23:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22AA01A091B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:04 +0000 (UTC)
X-FDA: 83849667888.20.D600018
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id 455BD12000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MemHJsdD;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bG7HgZbRDL9zQbYB/rpSIbCyKAIzwo1Rr8phODu9KXc=;
	b=6EGJWIkeyW9Zzs/6d80Dv2fNv2zY+mylxDnQRmTQ+8PuPR2uXaXutGa5G9YTGvo1PW220J
	Flqt9g+hMwJ1E1lKUhsKM0ITVa8DojqWtNNLZP/J2QC8SThudJIVdwVgP3BkvpQFvlViov
	etuq8MLX8wSSz5RiathXF/TCdB9aZ8M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MemHJsdD;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945382; a=rsa-sha256;
	cv=none;
	b=O2rksIdoUn8842GLqB1Qqi4E5nEwEeWnYDzc2eEcKUzf4T/uvaZfKYJVoLvWbeC51h8R8i
	tDKI+8NZus6WoYQJuvSppFsn9gMJ2oBKsk2AH9/uL4VRv4G8X0JJ6tBW+5u3YH/qVhinpH
	WfFkvRrQQR7pX0FdsOSD84skF9ydJpI=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-77256200f1bso480010b3a.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945381; x=1757550181; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bG7HgZbRDL9zQbYB/rpSIbCyKAIzwo1Rr8phODu9KXc=;
        b=MemHJsdDi3jLH6tv9bOCIurk3iKiT0NXxmOppP2vRggI+sZ1Q/zREnctjoptnjqbww
         C1qfXdFueimVNU7Lve1Annn47cWYGlm8KA9ha6uSD5NEwKCGs+XYvloUHBgaSN3JCPwN
         h7AaK/NfN7s84hnBgzgJ14z312mOCpv8qjkrkiMu67Ua7JBehb8O8RUdLJfyWfnLGliK
         Eu4IrBAq0eQUFGXB23u7wSNE1s9HuRe8LoWwqwJfKgtXWpvo2MJdK9wA6jAArgKmISbA
         X6+7y0Q42j5LTtxcpDzqAkCyKK/VQ3ytS/MKtuRjEKxBFqgk4wdDSzvNz/DtDvjJdgz0
         FTaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945381; x=1757550181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bG7HgZbRDL9zQbYB/rpSIbCyKAIzwo1Rr8phODu9KXc=;
        b=pmjBWTdMYQmH8ViZEO1ObeD3Pw5DudAExclb6sxRALlwLD9uKUVUbyAoyZYur16Ake
         f2euBpYv53BbJfLU6V1ALNzYF/Pe7NEa1d1pJlPzene6qFa00tHkFclXK/u22xLuaic0
         lac9ebN/mYfSb7KQJkVUvZaRo+f2ZFTIAvuOjfZ8e97xZdRzTtP6bWShMYwY1CfcFh/5
         x5pOVimNtvNUhcCJW0h7LWUmGiCE4Ig43oIYeLKo6Bx0ZxPAAaqqr4bX0FM55xwS/T4Z
         7DQoAbgr91TpKO/z7uTdGNpFN2hH7dymjwlAcHUXOMrnAl3qRnebrz2cf4WxTYGWbBJP
         c/wg==
X-Forwarded-Encrypted: i=1; AJvYcCVFH3BDC+qahLyddBX3mfyCc/7vZB2AloHFOfVBan4ivM5yQD3M76SQQxlIQlJ0CrC8IEJfLEKELw==@kvack.org
X-Gm-Message-State: AOJu0Yx01UDEIxexulaWmrEQHwzy6Fkuh5uaCDqgoae86Ae1LtzGR81T
	YOI9wHhOmb6c2BLWf3KDL8stocsvgTD2R3KAGCQTHdDCWhdVymGMBI1Y
X-Gm-Gg: ASbGncuOGRZcAXVws+a1XN3HUAnqafHLPMMZ4w3yfrrQeo5cn0USFgAMtlsjfl1KfzZ
	Wwn3ygS7PycMwJlCFrWe5mrC7TAos/VSIhsUbUf4oyJcZhTpCuWd2F2D9vUs3J84xwzYaSNIy1L
	70BRQHf657GMWDiuk+FMAzCbTaq5Nrpxlsq7ykVTu/ye/5DxK/Z6l9gSiz3CDhd/Gn6VvFWNYEN
	+cAwqXL2ln2cw+YQ2rFzqPz7ucfAacQaP6CcBAyizLXoWs6MjH7hp9EVx/srRQz2SlqolYDAbf8
	zHqDPou2V7rHrYRr0iKSwXmkZZKzDeH80vDRAkp0Tjacj/asuhCRYVIgLIuhOBFUZaEfUlUa/LM
	+vRdO0YCwBvH3XwBD3Qv3lITqklkjz0QU03hu5YWL/9FbeAY/3VOnc0dF/79I3Z8=
X-Google-Smtp-Source: AGHT+IF8vif2SMyS7b0Y14u6occzXKi/v4yy8ICXoht40V0het8ir2qpLWqnkYrrTJFAlnnbmVHg9Q==
X-Received: by 2002:a05:6a20:3d87:b0:247:65a0:822 with SMTP id adf61e73a8af0-24765a008c8mr6727769637.40.1756945380982;
        Wed, 03 Sep 2025 17:23:00 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:23:00 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 08/18] mm/ksw: add stack probe support
Date: Thu,  4 Sep 2025 08:21:05 +0800
Message-ID: <20250904002126.1514566-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ir45tdu968sa8nb17ysymak11jfk4tuo
X-Rspam-User: 
X-Rspamd-Queue-Id: 455BD12000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756945382-481667
X-HE-Meta: U2FsdGVkX1/MEqYJYJez2jbmk1QqdBts4FksuQksK0WvoNK2OYPbyu7uEI85GzFhiA1gtM58jaUVC0itwDikLhs2q6XbyHYb/CCYMYYtksi1vfvdANWELKVxenjSmezIJ/jjfkSDlWwUT6nBUVQqMPnWEOB1ZadEa+WlrQfN11elwyj9C9G9ysPEWERqzkPzz13Rb8fQoiD1z0lRa4Gsxhw2mtnB1rBejnMyqyeQf+j4acoGYPPuQNTYo/17G8lcA13egbg9oRPABUF6Dn1vIrkvPPA/HILcAzkgJcp0qUO85ipt/X6M86m+xik6FUc4ixC3v2lG/pDr26JuSP6sqc/ew/NNlN6c+vFhx9Z2xhM1fV4INLNXHK9UPSkcbbLD4Q40BKCHoQE/Err95q8WhFUSiAXmjs4oi0lPUK+7IlAd6ZuKsMbxuWyaWqE2YYh7TCnpSS87CEfuameH1PCHvbWSDTmH7DqwB/9kSvEXqqqteOBkvLxa+qLalBfc//SHiv6KVptxhVDW7Bi3mKTcy8cvabJWeKdsLTeue/52d35FV3iRkk0U4vm0GysnpwKM5fAcxPW0tfHsGBqjpqp4nr2HdWyoi1gmP9HoH59SHqPal42zANQm6qYTM6fQnMMhugZ5nHwH6NjVHaJULk0pFUPiXExew3ymC3RnvF1j63rBWHzzxJKB9nnJZCoag2F5HvzXMyClLxzsvzUSTxNEfDoOyMNNK2lr9hk9mqUIOOUoIWoGRS4kglXLtd7+HEerfQwP//r4E3G/E5774h3jSj0GLEu72nIwFvKmTOwif8hroHWnJgwcVfikfwBd+ssl+C260czWwhMoRbiVpUXS0J4TmSConvjLoI8akqV6V8LUCWBWuiYAHxfQkMx/Df5Bm8bVKkas16QCaAHxMi7FD/wkDqQC1Dn0cP/bs/pkq9CDe/dpb6m9zz9xrvzF/eTdz4EL/26pJciL4ZVN+0T
 qiOjcdh3
 dhWAc06mhx30vS333JraxL+Zs3iznrtXdqSn41Po8HCeXeRsnpc06lvPolGJjPzyNSkhlMSMeaXDnTGWgjx/fm8a/W3kn2F2dzhJK6JWtMlrxgTJ1dPMkb2/c0P7GD0vQfbJ+MnohMyJn//goUHFPZJ0wus61V8v4zyP/l30467mbBfoO0hdkRmWtxSK34ASO4YJSnEamqIoslqpJXUhEGftYfGiFvAv/5yUbyu45xLbGBMVJfZWYplXVTBkcEMpacT2AaqZyiZaBL40qmvhOGbUrZdBdNufMqwIqKO192CHKyqONoyoRDi1iQJUZfgBzkCjEAKpsbxT5zyGJlaKRojlkr9dxANZym+G7Ck6VDG+d0OEV9DKRTPypF4m4yGuBpIupN5DtV0N1iEOmeGhUwPefeGz1pFXIqINKkzZZLLwxIJGMv/BNitT++gP6XuyrHun4kMR+KwA088HzJwFqdHaRUUxlZh/cl/Tm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce stack management for KStackWatch using kprobes and fprobes to
enable dynamic watch switching:

- Entry: prepare target address/length and enable watch
- Exit: disable watch

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  4 ++
 mm/kstackwatch/stack.c       | 91 ++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 13ef8c79f855..bc8664af4fa6 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -38,6 +38,10 @@ struct ksw_config {
 
 extern bool panic_on_catch;
 
+/* stack management */
+int ksw_stack_init(struct ksw_config *config);
+void ksw_stack_exit(void);
+
 /* watch management */
 int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index cec594032515..3b72177315cc 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1 +1,92 @@
 // SPDX-License-Identifier: GPL-2.0
+
+#include <linux/fprobe.h>
+#include <linux/kprobes.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+
+#include "kstackwatch.h"
+
+struct ksw_config *probe_config;
+
+/* prepare watch_addr and watch_len for watch */
+static int ksw_stack_prepare_watch(struct pt_regs *regs,
+				   struct ksw_config *config, u64 *watch_addr,
+				   u64 *watch_len)
+{
+	/* TODO: implement logic */
+	*watch_addr = 0;
+	*watch_len = 0;
+	return 0;
+}
+
+static struct kprobe entry_probe;
+static struct fprobe exit_probe_fprobe;
+
+static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
+				    unsigned long flags)
+{
+	int ret;
+	u64 watch_addr;
+	u64 watch_len;
+
+	ret = ksw_stack_prepare_watch(regs, probe_config, &watch_addr,
+				      &watch_len);
+	if (ret) {
+		pr_err("KSW: failed to prepare watch target: %d\n", ret);
+		return;
+	}
+
+	ret = ksw_watch_on(watch_addr, watch_len);
+	if (ret) {
+		pr_err("KSW: failed to watch on addr:0x%llx len:%llx %d\n",
+		       watch_addr, watch_len, ret);
+		return;
+	}
+}
+
+static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
+				   unsigned long ret_ip,
+				   struct ftrace_regs *regs, void *data)
+{
+	ksw_watch_off();
+}
+
+int ksw_stack_init(struct ksw_config *config)
+{
+	int ret;
+	char *symbuf = NULL;
+
+	/* Setup entry probe */
+	memset(&entry_probe, 0, sizeof(entry_probe));
+	entry_probe.symbol_name = config->function;
+	entry_probe.offset = config->ip_offset;
+	entry_probe.post_handler = ksw_stack_entry_handler;
+	probe_config = config;
+	ret = register_kprobe(&entry_probe);
+	if (ret < 0) {
+		pr_err("KSW: Failed to register kprobe ret %d\n", ret);
+		return ret;
+	}
+
+	/* Setup exit probe */
+	memset(&exit_probe_fprobe, 0, sizeof(exit_probe_fprobe));
+	exit_probe_fprobe.exit_handler = ksw_stack_exit_handler;
+	symbuf = probe_config->function;
+
+	ret = register_fprobe_syms(&exit_probe_fprobe, (const char **)&symbuf,
+				   1);
+	if (ret < 0) {
+		pr_err("KSW: register_fprobe_syms fail %d\n", ret);
+		unregister_kprobe(&entry_probe);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ksw_stack_exit(void)
+{
+	unregister_fprobe(&exit_probe_fprobe);
+	unregister_kprobe(&entry_probe);
+}
-- 
2.43.0


