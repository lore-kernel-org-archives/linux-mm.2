Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812D6CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB01A8E007B; Thu,  9 Oct 2025 06:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87708E0002; Thu,  9 Oct 2025 06:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76178E007B; Thu,  9 Oct 2025 06:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B54C08E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A110140829
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:30 +0000 (UTC)
X-FDA: 83978274660.18.EA67832
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id C37C318000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUOqNHiK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007448; a=rsa-sha256;
	cv=none;
	b=kPTcOBvdX6GL84q0atxeIoFjnj1EwQx2oP1yA/jNfzGFm7jLX69TlD8fE0Xu0c+KTIyS/c
	C0t/XVze6RX1W5DNsVr8yBFcLx7MsDHGPHAq8TeIc32irwnQf9yOhNdAUEbRF0uPFukihY
	jnJdObEtT3Edx/xHVUVNNr1DYCpynIc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUOqNHiK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
	b=rZXG/ufWGxqIuNhh9AVnj0wpDIG5Te7LIDCSWdz1ki1tNCdu8TmtAxg7+PJvNbhn67NFTX
	LsRBDtIfN0Wwo1dObBpo45RddpLU0jOe1G+B9koQqccO5WROjNC2R1cXl3e6qGb2TSk16S
	WbnVIxeEGvjMG37Fj7dSAuFAaecUecs=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-793021f348fso734993b3a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007448; x=1760612248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
        b=nUOqNHiKg6s9upuELsCHXZlNG5hj55ndPSHbi8+TJS0Nxial2wjkkHd0zLsNo21cRg
         hLMCZD/TtO+WUtY74jiHZqcvGkGA/v+W+PTBlm1/KcmIgFwYXJ2AGZ5/HbEKWTdgUdW/
         dds5l2GPIkbFrDbaAhp+3Sci7ZWp/Pdy6oa3xZSNV0MnL4AUM6tj2Y4jDR/cK2e6Ufnu
         nBLsDhgTWfJj+fL5g91qetvQAVuX5lvOyN4eW5MAM6RfHcIcilGZ2b+bqxC0XPveZU3g
         xEaCGIAEsNh+ghbROeoUutMMI0A/IzTanVaHrsRAs4v01pAOACc1CtcNyknmIXd5W6VT
         LTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007448; x=1760612248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
        b=W9jizXLecHk9vyjADlRrxnfQd5LwxBwL5OjRXj35boQa4n6ze4yZxUaywIz8sEn2eO
         qCV8Di31aVkjxMQbUnNjhpTCcN+aBnYXzOs3gt1o/a14WFfIBtsN1T8Dm6iQQl3355DJ
         eYKcnpDXbYP3MPNu2iwWGoBMqS680kZ+FQ5DGzi4RfO/WMWY+48/c+A6G9z6SdioDHsl
         M7wH5SGNog/L3l5AiJ/qNmOOn7TdScU0b41Ej7QelS/9LoxVkk3kV4w8KO/pTbAEj9fB
         E9Wd821k7AtHZop12Cer8R17hM+hRJOzMvzOHK7jt2XdXF6J8R6ZINvoYQS2Kvchusul
         Pngw==
X-Forwarded-Encrypted: i=1; AJvYcCWHwtoWKYgY+KV+Vof+Skdg8NafT55gDTpFqCqcznCiV7Eh+q+fzmYK9WLIhKJIexAMTSA3vLbxOw==@kvack.org
X-Gm-Message-State: AOJu0YycFk7PPcEzrMn4t6SAOn69oLqecdZx4PrPc6LHTYxy3qWlNfVk
	oITR84hYNmEFRqgWuD+F5ifgCJfhVFN5iQpE9Eq48E2IbWHYVmUxfL1r
X-Gm-Gg: ASbGncsuRpCmdX6DXDDF1F8XT0e72XrjJzUBPfoc+RsE+QwjpNeMAx2koV5n+GvlIEG
	Fu4AjYLK60NSjcsowDUAxR17SY+Yw9Yit+6GBBLQlllWnfwUB/83KZWthyjjo4IanXjyAqwjSZs
	Qv68veSl0JG2vQHThlMpJ+T7xt/NRd7B1in0XoClPOflzu9fh1PZdCTl3r3P+HcsqDuINJSUgk0
	oL6pzPGSnH258GOp+Xx0lIRGt2MKDroDHEx8r1aI+wiQ8xqQA3wfqeFeqsd6G4S2ppQo4lYV4dl
	KI4oMF8nCL0szZyeiuaPPovVNPZHFBD9PIQAYPJSE2Aalm9CEzq9lL3OZ7AFRuUEhGmnI0RJXvi
	Fo0Td8/gBjv/Wkgw4NFieaMCjjg0m9yxGsITFcgDcFd4G7UXXBrlfsqqvfsJ8
X-Google-Smtp-Source: AGHT+IGWNtwgxrnJqlblecBPueROlKrcqfaFV5OES8QM1cCcFtVSEQ+YPcggBPgem+pzIyfM0P8xmg==
X-Received: by 2002:a05:6300:40d:b0:32d:b925:74ea with SMTP id adf61e73a8af0-32db9258839mr3446528637.11.1760007447507;
        Thu, 09 Oct 2025 03:57:27 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b61ac27c74esm18963329a12.33.2025.10.09.03.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:27 -0700 (PDT)
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
Subject: [PATCH v7 05/23] mm/ksw: add ksw_config struct and parser
Date: Thu,  9 Oct 2025 18:55:41 +0800
Message-ID: <20251009105650.168917-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cf7iazu4bjmcowxjrikqbo81xz78i8ja
X-Rspamd-Queue-Id: C37C318000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760007448-718307
X-HE-Meta: U2FsdGVkX1/EMzO9v2DO7b18ibSoYZMwYhOkVePN2V0OiNsdSfDc1ieONe0weMyeNfjtQxQWZaUfHNPWMQzQG/2gpRxIeSp/9ckUdFSXQRH/lMV2vNQrGNsEl5D7UmpQQBFhVIVxIRTUphk6GTYou/cRht70p5fjGwcj+FuAYEJA6fM1gMx83Yi9Kdcj832j39i041f+WrlBprJuc4QuwE4VRhsbSlBuaQRAjT2Kr7n53DSYGNj+Lo0LGZzDvNBv2/Sx/X9EgQEaY6Lb3f2jvBsdFVJoQUW8rAPk/0WQwntjWDOWCvtEN28rJ1Tx20D9Hp71m6gGyuvYutcR0tLa1ZF0A49CSRgHMILNfODjUgTW6RQzXQjCqUt7MpMmq+w5bumrqjh6nDCfrDGtyjdjvfqHixcvCAPztONN1pLMCsmOYH6YJgsfkmBLfWzIiXXuoVovDMhGzJ2BNQNLATXcEDcr5v0DvL3F2188310y2uJq3kDdKVG6b4Q6lYqid/zdtoJ5fmrV+EETDuOgF/IPwfCZgCVfGlAiICUWNLG2L7N+t9B7WkBZrZqQGOtKLFtsPDuQp9ZESxRJqRdoU7nGrMHTk/NbO4CuDEUcAyf5WWyikvdgV4/z2x8TgQHzljcPct65TGrF8EYriFg16Q2X9DtjMx3vZK7Gxoi1hdjjPZrNuzojaFxEAPCq4b6HKfGy7rImxLxdQAp1mPC1pbG5pu1pGUUPBC4XUiW8aJIcODJMb4JTIDvYJSAN5LW3+teFULGcRPt4iRlCFzoc+stR7YLXExfO0nJLI7xlh0HhiL18SnC0UopTycAbjUPFnVSmqDPZ3riNhWkmHlo1ii9K9owc73J29F7O0IJLyD6pkpwqlFCmtfX+YsuqpyAUbMncPuusYVla9xNq/JBHjCwI4hYunXYWrm4uPq5WMOizK9tubWbrpxteHz0bEqS4X2km/6NAvfBysubQnLtCad+
 bedZQICn
 ZJejV1np+DGCM6QZVMVMhd1bpgbpjPbdEE1kV0No1oOi/mDu1EYu2J1A9ADhE2JE/2GVMTIdFSdf6FwkweVXNXNcryGWGvvJ7YFK1O9qtyvKxUJe5kpu9hIJv52WNcczvuvLE10SEeLYKQSNNSWJbWXLlhAVUkcRq0GOMefcyiVq+MKHjhQQhuEDxBH2SNf6V9yUixU5fY55RAo2DU/aak28zRCLqr6+p0lGU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add struct ksw_config and ksw_parse_config() to parse user string.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c      | 112 +++++++++++++++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h |  27 +++++++++
 2 files changed, 139 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 78f1d019225f..3b7009033dd4 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,16 +1,128 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kstrtox.h>
 #include <linux/module.h>
+#include <linux/string.h>
+
+#include "kstackwatch.h"
+
+static struct ksw_config *ksw_config;
+
+struct param_map {
+	const char *name;       /* long name */
+	const char *short_name; /* short name (2 letters) */
+	size_t offset;          /* offsetof(struct ksw_config, field) */
+	bool is_string;         /* true for string */
+};
+
+/* macro generates both long and short name automatically */
+#define PMAP(field, short, is_str) \
+	{ #field, #short, offsetof(struct ksw_config, field), is_str }
+
+static const struct param_map ksw_params[] = {
+	PMAP(func_name,   fn, true),
+	PMAP(func_offset, fo, false),
+	PMAP(depth,       dp, false),
+	PMAP(max_watch,   mw, false),
+	PMAP(sp_offset,   so, false),
+	PMAP(watch_len,   wl, false),
+};
+
+static int ksw_parse_param(struct ksw_config *config, const char *key,
+			   const char *val)
+{
+	const struct param_map *pm = NULL;
+	int ret;
+
+	for (int i = 0; i < ARRAY_SIZE(ksw_params); i++) {
+		if (strcmp(key, ksw_params[i].name) == 0 ||
+		    strcmp(key, ksw_params[i].short_name) == 0) {
+			pm = &ksw_params[i];
+			break;
+		}
+	}
+
+	if (!pm)
+		return -EINVAL;
+
+	if (pm->is_string) {
+		char **dst = (char **)((char *)config + pm->offset);
+		*dst = kstrdup(val, GFP_KERNEL);
+		if (!*dst)
+			return -ENOMEM;
+	} else {
+		ret = kstrtou16(val, 0, (u16 *)((char *)config + pm->offset));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Configuration string format:
+ *    param_name=<value> [param_name=<value> ...]
+ *
+ * Required parameters:
+ * - func_name  |fn (str) : target function name
+ * - func_offset|fo (u16) : instruction pointer offset
+ *
+ * Optional parameters:
+ * - depth      |dp (u16) : recursion depth
+ * - max_watch  |mw (u16) : maximum number of watchpoints
+ * - sp_offset  |so (u16) : offset from stack pointer at func_offset
+ * - watch_len  |wl (u16) : watch length (1,2,4,8)
+ */
+static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+{
+	char *part, *key, *val;
+	int ret;
+
+	kfree(config->func_name);
+	kfree(config->user_input);
+	memset(ksw_config, 0, sizeof(*ksw_config));
+
+	buf = strim(buf);
+	config->user_input = kstrdup(buf, GFP_KERNEL);
+	if (!config->user_input)
+		return -ENOMEM;
+
+	while ((part = strsep(&buf, " \t\n")) != NULL) {
+		if (*part == '\0')
+			continue;
+
+		key = strsep(&part, "=");
+		val = part;
+		if (!key || !val)
+			continue;
+		ret = ksw_parse_param(config, key, val);
+		if (ret)
+			pr_warn("unsupported param %s=%s", key, val);
+	}
+
+	if (!config->func_name || !config->func_offset) {
+		pr_err("Missing required parameters: function or func_offset\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
 
 static int __init kstackwatch_init(void)
 {
+	ksw_config = kzalloc(sizeof(*ksw_config), GFP_KERNEL);
+	if (!ksw_config)
+		return -ENOMEM;
+
 	pr_info("module loaded\n");
 	return 0;
 }
 
 static void __exit kstackwatch_exit(void)
 {
+	kfree(ksw_config);
+
 	pr_info("module unloaded\n");
 }
 
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 0273ef478a26..a7bad207f863 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -2,4 +2,31 @@
 #ifndef _KSTACKWATCH_H
 #define _KSTACKWATCH_H
 
+#include <linux/types.h>
+
+#define MAX_CONFIG_STR_LEN 128
+
+struct ksw_config {
+	char *func_name;
+	u16 depth;
+
+	/*
+	 * watched variable info:
+	 * - func_offset : instruction offset in the function, typically the
+	 *                 assignment of the watched variable, where ksw
+	 *                 registers a kprobe post-handler.
+	 * - sp_offset   : offset from stack pointer at func_offset. Usually 0.
+	 * - watch_len   : size of the watched variable (1, 2, 4, or 8 bytes).
+	 */
+	u16 func_offset;
+	u16 sp_offset;
+	u16 watch_len;
+
+	/* max number of hwbps that can be used */
+	u16 max_watch;
+
+	/* save to show */
+	char *user_input;
+};
+
 #endif /* _KSTACKWATCH_H */
-- 
2.43.0


