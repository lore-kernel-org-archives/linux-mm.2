Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7857DCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E3F8E000D; Wed, 10 Sep 2025 01:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF058E0001; Wed, 10 Sep 2025 01:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14E28E000D; Wed, 10 Sep 2025 01:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD9018E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:25:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 600491A0746
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:13 +0000 (UTC)
X-FDA: 83872202106.28.82E7E51
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 748211C0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XiTroMBQ;
	spf=pass (imf18.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWZ0kuFk/JGga2KckHsx8bbCMGd9rBXEdZWbqFyn8fw=;
	b=IaaUlAHMVpzT0z+ZD3vvtUxazcodHFs9mVVoi1i+AXdgSFPYBN+8K3NncGn6oqwBk5iJDH
	ifZ5/7WD1ts8/MwkDi9CHyibEFQx0laHL1JCJqsbN4NYhIRVcSedIKP9Ql2PONyF/Ho9i3
	us+JAv+43YHHexaiM1DhU+0XLmnbrwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481911; a=rsa-sha256;
	cv=none;
	b=SPw2shLb6yzKKf0plIERxNaysVxmKh0yTRZNyZdrKwCZRiUZnPoE2J3859GF/uPv/ATbK8
	RaroSlq0nAEW/4kxzBzzGxOzdPRxVhoMX+WM8Kyf/7yLR8sWrUGUt5qu1NsHy8dWDsaL6h
	YYcFQfqPs65clhiiMaXBRY4AVuT13JQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XiTroMBQ;
	spf=pass (imf18.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-25221fa3c9bso2352535ad.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481910; x=1758086710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWZ0kuFk/JGga2KckHsx8bbCMGd9rBXEdZWbqFyn8fw=;
        b=XiTroMBQXybo7P3z+nbhxYCFgZu8gnPSzQBTHSAgl+kAJ0WjWOYKt75Xf1qCxjKqiq
         Qh+omV8X/bJmpjMas+npfmvMPGd0sjZ1qB0PWayb7yf8W4GLcbs6lnhhZrmN0kryF8rc
         JV/3n8cetYimJMRQCbU5vZ3M5yhz5A0kRGG3i0rY+6SGMzzPJQk+jnRk21M5QjA3rLfg
         CF5S9htvSBMmntionvt1ikG0rm/4ihG7NEzhaCBF3btwk3EebUyTLulU15NAbmmFFtzC
         dpJ2t2cO7fJEJZqvFA88ngNoXqFTQcH1l57O2ko5ApYFUZD6oI1yKYgAoygjyaSyB7Qf
         +aJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481910; x=1758086710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JWZ0kuFk/JGga2KckHsx8bbCMGd9rBXEdZWbqFyn8fw=;
        b=HXqjVlt7jW3zk1B3k+gwpSd2Ezr+w8zffcdExYf9+4ta5EywHGWx31ESl+wIcTTpoK
         ru/xyRHA10zB1kf4oTKAbiY8++zWQqGRB06KbtLBezHM+xaI3nWJCo9nqvr+SbucZDuU
         57hQUpwJCma9IPYAQM4y+kQKVAAYQTzxwLHfjNKc7bp/pJAhaLXaH+RY2+z1gMJWBgLm
         Q9rvtXIZ13/7SiN1TyC11EujQV9orcLyw6n1NBKd0YHJxa19xAaKHW/NemjXT/RwbX4v
         RNMQBp+RD9RTZQQRa/SXGRTc+tCx82MSA1ZEqgLqMuBpN4YcMAhpxBn8USdHvUt03sL7
         DiSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZvhnRdtQTHw7y8qq4KnWgtagWF7EF/RmOy88fO5s+zt4wFZWkxk/EEx0XXig2SMP4VLun9868Vw==@kvack.org
X-Gm-Message-State: AOJu0YzwP5S37sA8JC+4hDhuLrk8mjEdAfkQqXNBUvDRkBW/pTRD/zvq
	7g7AzobdKbZnK0/PgXwwUij+jL2xG1KNPmELtHggNCrgI1AbXk/WVJkb
X-Gm-Gg: ASbGnctDJa3fw22I49ke+nTDRHRXR1InlxDjlwwLzi8p91uralTB/jg8I4lzgxaJ2y/
	eD8nuPK/44cQ5SLE211bcMXfRWzIo5XHw/QNsrMt9xK8LI7caf+YMlHi19aLXUyN1Nia+x8oDWR
	0xue1P8JlmaSEM5ljKKN0rFqgtzXGGKio/ry6bof1pkBxCdlZ9B/FsQswtegzEhWvJKBM+gEEAJ
	KiRWSvhnKravOkjTKYlb62FvXnfhjW7bW2AnBU+IYDQs/d5W0UKRYUgIb+bcSxPciFS4NEQvDYK
	iYpwK/kesQHlkW71KLxhzk69ctCu23BsOv7Uz1cQaw8SPLjpEnOOS0gbTteO9e17tFuWlXjjAf9
	5nt4x9bI6rYViDBCCB6MjLqPa/qjbwoEauw==
X-Google-Smtp-Source: AGHT+IG95EjfmArTGKA4Yy6wwIVaXBUIZfTy9kHKEqCt/V+MK+/id9OZOKBsB4fgqQKzyzs2zL/CxQ==
X-Received: by 2002:a17:902:f78f:b0:24c:e9de:ee11 with SMTP id d9443c01a7336-251788fcff7mr180480145ad.17.1757481910286;
        Tue, 09 Sep 2025 22:25:10 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:25:09 -0700 (PDT)
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
Subject: [PATCH v3 04/19] mm/ksw: add ksw_config struct and parser
Date: Wed, 10 Sep 2025 13:23:13 +0800
Message-ID: <20250910052335.1151048-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yskyu4ci3r3g5pjm6gwss5te9rjxaomw
X-Rspam-User: 
X-Rspamd-Queue-Id: 748211C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1757481911-916888
X-HE-Meta: U2FsdGVkX18JU0oxCk8TXtUW2QPlYv5md9DmClH2ws1mvig1+pNqv6sktg2MZ/jSV1QM7cBO9yEkegknaM5g7R2wT38jX8n/KgwzdZsJnK57aQjd4ozgsw0nrbdnPvl+CH2Bi0dH4ySoxodMPTA6ExWghIayLrHEwq6By7346gVdZXxmvo9h00tcEliPpH2lhyjMTXP2stYxvwIpxlpCynXoah3KWXOX6eXy1TZxH8ddFShEl+6jMAwyyJlmtAz0Jb5sHP9bHvjKbkWvKxXotVsmeW4HJam3cBugkhdhoFhwn3tBhKdV4g+IEfHkFretXF4rw82PfspPR1WCD+dbaPTA9AtGa/R735PSHDD8CooNkJwUrSvjA5q2euQwcHZlQm94WA+OuxdSfC7NR4XgKUb2JUQJcKYpVSXoALUgP+DyhETCfLcJiZglncy8ULlhrPvLE/+WAv/bv7oqZfJdMBSPUUphnxdfSXGlnsuI2E6yrSbfhEOjtWcSYw5vYup0lrr9eaMxpWzoe/m3LZaG+1uHYYIDFFyn/v8+Yd7vgPburNFF/BZ/SDoePTEmxkGSc6B1W23H+yW6Dd0zxkS+1OjLOexr8Zo/S8oTdnv8yK+e3g244HonLcbha2DN/s6QubGiP3CEiPhheTPpIqHUaMKZg0qK+CBCOyHlic+bxiwQL8Ydk8oXxYQyr6ibvSj2mwHM5v5quQ87LJC4/3e3HU1kMkF+UWZErpqxEFcmUob6frG+Ga7rVYYulqRb+neQRNqSTkAbTHrNN9H5gOA6xMz0ElvNTb5H1XCVAHaBgjHWjaIDe4n4/mXdP6dRtalx989+nF4UgsH/eiXOXX6pu+kyI3Q0VDR2SOCUBsEnmamVpg2Cnne3Fglj6Bgeoel6ghJmo/Xf4sLYTsdJwPkMwAh1slhetDmEZ/Eq6CAdIRn5/Ig8W6zh7VTGURPRVFpDDId/g5Aos1QHDUulOnM
 86/Kh7hO
 ZNajBkBisCvqqvQWiTkr1+nuhQuQyyYflTOMoODeRg981GEcD6DI6XvuCnwwc/R5WBuhWb6+TmeeKqQWjhE81GR+o7oZGc4DeNrve+bgmTQtBGhBdQGb6U/ndN5Y8BDK2M+pOYNWCv2dNA5x47mrzjrA/rK4sMYzNpWMAVxfPlzj3V1/j/GtmoULpI/cfoVlmBW22KMaS0XC88M2HenbAa/aafWY+lkI0XTov2OW8neinSMWVsn6QzMPUispuHdatX4LJ73xuXvy1dng1YUFd7eHyx0AcX/xCHJAsR5m74BSCVZ18TpjoK+KNmoHmWrspweuBG55f+lVUOPmLrUWcinAvsJpoMLKENg6+h8rpRZWh8BmoZ2D1PH+IcoA6iHuqokaDyvKMsFEKwXHWHptBOkwJgcx3vDlVC1B45fT9h0X/KC4vqrUAga9CeXF+TEUx83gL0tD+qJCtIhFiuZOq/T19k0dRGnMFPnIQrmllNrXCEI3ZOWrtRNK5hNuPwMA7qXUGpGxzWW8Mlc2J6tctiNht0zpvT3ZAC6/q1J6O0/J+bIm+ZdOn75WlUkfyH5Y1yyOblDv7NYeM29NizWKvJOYCNMdOm/JH2BbjGELTLhI4FYgFfw6pk880955evI9Ge4gN
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
 mm/kstackwatch/kernel.c      | 91 ++++++++++++++++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h | 33 +++++++++++++
 2 files changed, 124 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 40aa7e9ff513..1502795e02af 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,20 +1,111 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kstrtox.h>
 #include <linux/module.h>
+#include <linux/string.h>
+
+#include "kstackwatch.h"
 
 MODULE_AUTHOR("Jinchao Wang");
 MODULE_DESCRIPTION("Kernel Stack Watch");
 MODULE_LICENSE("GPL");
 
+static struct ksw_config *ksw_config;
+
+/*
+ * Format of the configuration string:
+ *    function+ip_offset[+depth] [local_var_offset:local_var_len]
+ *
+ * - function         : name of the target function
+ * - ip_offset        : instruction pointer offset within the function
+ * - depth            : recursion depth to watch
+ * - local_var_offset : offset from the stack pointer at function+ip_offset
+ * - local_var_len    : length of the local variable(1,2,4,8)
+ */
+static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+{
+	char *func_part, *local_var_part = NULL;
+	char *token;
+	u16 local_var_len;
+
+	memset(ksw_config, 0, sizeof(*ksw_config));
+
+	/* set the watch type to the default canary-based watching */
+	config->type = WATCH_CANARY;
+
+	func_part = strim(buf);
+	strscpy(config->config_str, func_part, MAX_CONFIG_STR_LEN);
+
+	local_var_part = strchr(func_part, ' ');
+	if (local_var_part) {
+		*local_var_part = '\0'; // terminate the function part
+		local_var_part = strim(local_var_part + 1);
+	}
+
+	/* parse the function part: function+ip_offset[+depth] */
+	token = strsep(&func_part, "+");
+	if (!token)
+		goto fail;
+
+	strscpy(config->function, token, MAX_FUNC_NAME_LEN - 1);
+
+	token = strsep(&func_part, "+");
+	if (!token || kstrtou16(token, 0, &config->ip_offset)) {
+		pr_err("failed to parse instruction offset\n");
+		goto fail;
+	}
+
+	token = strsep(&func_part, "+");
+	if (token && kstrtou16(token, 0, &config->depth)) {
+		pr_err("failed to parse depth\n");
+		goto fail;
+	}
+	if (!local_var_part || !(*local_var_part))
+		return 0;
+
+	/* parse the optional local var offset:len */
+	config->type = WATCH_LOCAL_VAR;
+	token = strsep(&local_var_part, ":");
+	if (!token || kstrtou16(token, 0, &config->local_var_offset)) {
+		pr_err("failed to parse local var offset\n");
+		goto fail;
+	}
+
+	if (!local_var_part || kstrtou16(local_var_part, 0, &local_var_len)) {
+		pr_err("failed to parse local var len\n");
+		goto fail;
+	}
+
+	if (local_var_len != 1 && local_var_len != 2 &&
+	    local_var_len != 4 && local_var_len != 8) {
+		pr_err("invalid local var len %u (must be 1,2,4,8)\n",
+		       local_var_len);
+		goto fail;
+	}
+	config->local_var_len = local_var_len;
+
+	return 0;
+fail:
+	pr_err("invalid input: %s\n", config->config_str);
+	config->config_str[0] = '\0';
+	return -EINVAL;
+}
+
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
index 0273ef478a26..7c595c5c24d1 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -2,4 +2,37 @@
 #ifndef _KSTACKWATCH_H
 #define _KSTACKWATCH_H
 
+#include <linux/types.h>
+
+#define MAX_FUNC_NAME_LEN 64
+#define MAX_CONFIG_STR_LEN 128
+
+enum watch_type {
+	WATCH_CANARY = 0,
+	WATCH_LOCAL_VAR,
+};
+
+struct ksw_config {
+	/* function part */
+	char function[MAX_FUNC_NAME_LEN];
+	u16 ip_offset;
+	u16 depth;
+
+	/* local var, useless for canary watch */
+	/* offset from rsp at function+ip_offset */
+	u16 local_var_offset;
+
+	/*
+	 * local var size (1,2,4,8 bytes)
+	 * it will be the watching len
+	 */
+	u16 local_var_len;
+
+	/* easy for understand*/
+	enum watch_type type;
+
+	/* save to show */
+	char config_str[MAX_CONFIG_STR_LEN];
+};
+
 #endif /* _KSTACKWATCH_H */
-- 
2.43.0


