Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D14FCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A189F8E0025; Mon, 29 Sep 2025 22:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFA88E0002; Mon, 29 Sep 2025 22:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE9A8E0025; Mon, 29 Sep 2025 22:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF198E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:44:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E82711A5D2
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:48 +0000 (UTC)
X-FDA: 83944373856.10.2D63333
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 606751C000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eDfB9UwW;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
	b=nZPM/F+C2p47TIZ+fXGigPbCMx9rA+A6xkSYQ8guPZU8Rak6meLNUm7T3mEDoGV5bqXdPi
	D/V32l8tBwgvorVGC0C8TrDE9O8real61cq5ItzjNw1fdq2hmprZKRR7cy89Y+fxljEze5
	tCV9cE/kvm4DAr8dsl+8EvI0egu7QiI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eDfB9UwW;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200286; a=rsa-sha256;
	cv=none;
	b=tRL6UmLuRv+d4/6/GQItYAsnuLE+bCPNFUuQLmQRM/05AMsTXiF/pohhwuMqWPFS26YKyv
	7bWQo7dkzMk13ZsfRXACH1m5MRT7MB2KMMZLMGtODU2oY03pUGe+8jufbIyljKYlCa4dwh
	UTXhbHwcViac58LPbH0Pl/h4JuusR8k=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-781001e3846so4979640b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200285; x=1759805085; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
        b=eDfB9UwW8iKTyu37oU9y6M71GfMGlCqEnA7PDf9BeS5VyKOsdmMUSBIk25EQwAyZ/1
         JWGdzKMImI/ZlRHSMSWCSktr0f1MP2uOoqJWkwVD1xI/veOLzk8H0ShSDwOqLt89IwYg
         wQFud+8noXxEtXTjPsENdibsrOYfenX9fk+fld52jIw4oBTvStF9TNtEp3epBA+DH7Tq
         mdIAtsnSRznxpgqfOiaULQsl2PvQY9w+g+iAs1T8WY+Rp2i42YdcrZbjJY9F3Lx39uE+
         +AEfIsqtFIsmZVv8GpgdwfvySPlKvbhf0vM2X/+X56dWuOWHCEBtT7KDqgO1ybHOkLaR
         1Pqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200285; x=1759805085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
        b=sx9XBaj7J297efqQy8NatabpNZegJ9Fky76jQRqCEBmIkC5TAHVR545jVvZf5YbHX2
         fqc9/MmvKfrgkUzyVk75XWQs+hWWOEPU/0QiZ6pczKhCymdKlwtynCOciYD227J24E4x
         LFKa4raWmuaTIRTV52/mTC7is0R5hWn7Oj6sbePeStyw09/8y5kPge+ZsbEGD85oZEii
         gCZYDpGzDf351uIkg7rN5TWRCFtzO+sIVODghasqWNV78IEFfEvPd4QovCiCSkybvfEB
         LC3WMyAhAEZ/7DcPPPvFq156rQAQOje9CDyrLidvdwjcf0Sp0tzOJtnkwERZ7/c4Txss
         0iMw==
X-Forwarded-Encrypted: i=1; AJvYcCXUjBIXZtTI5BtTmFPCYGjAXLr3sL0qOUG2V+LlCuyBlWsyAbiK0r3+zhhOnUPWSYvbO47YfDaY3w==@kvack.org
X-Gm-Message-State: AOJu0YwwACEV3NJPQ3YvP2KvOLemfoqtwXlpziajdAAHzWhdzdcT+vdX
	FC7WjdMhc/NIUr11D1DHlksLlG1VfP40SWl9AU+GLnuJXvU0Iz/NDgg4
X-Gm-Gg: ASbGnctgDsO6iIxltk6DCjkDxFOnrDIwwUhxE53UtkVh2IoKPACguOZXi35x+lZxx2v
	q/LmXQh9wtSy8jOeNmyXkUooUPlyirm7SqO+EZUfsCfGJSnuPTv3vtzs8jNJSn9/r5PT84kThfl
	eNHlZFcI+3lw6Wrc44dTt6cZSTlLGwkUPl08M4hvfMdnKDjXXTxzfOBiFX/IgmvJALixtVKMzP9
	eKcQiLkjInrnm98A2zIEq6UAyQVXyoi0EewclXwV03/BeVKef8FMsWobQMIOxGtoUf7CZiqhzY1
	QCFJIiAmw6f3FpkfVZFkZsCsMEAsEYrwSYrPoLAt2tloawmziQtdzMH4lslhBttN2q7vf7EhE+O
	BJe3p2Fph1vmnTgGK/V93LOensOTh39AbCZTzZlmTkvp8miPhkvdVOFwVaNWhrey1xsMwd0r1Xv
	LZ
X-Google-Smtp-Source: AGHT+IFCIxJ+f2ZP7/SRGQLtykJQ9skkyS5Xc4YM8nOS80KRWl9hYAY1JbghIyfFVwcemJPxzbxqqQ==
X-Received: by 2002:a17:90b:1347:b0:330:6edd:9cf with SMTP id 98e67ed59e1d1-3342a2b0f1fmr20209339a91.22.1759200285220;
        Mon, 29 Sep 2025 19:44:45 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3341bdac46bsm18593679a91.12.2025.09.29.19.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:44 -0700 (PDT)
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
Subject: [PATCH v6 05/23] mm/ksw: add ksw_config struct and parser
Date: Tue, 30 Sep 2025 10:43:26 +0800
Message-ID: <20250930024402.1043776-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 606751C000A
X-Rspamd-Server: rspam05
X-Stat-Signature: pmpbc3ymoiqneb39ix5t8gaje81u5gn3
X-Rspam-User: 
X-HE-Tag: 1759200286-17889
X-HE-Meta: U2FsdGVkX193WnGfSI05WXcgb3ypLlwSrApkfprkBgCzaZpHvYmosr4HIOnw0z4B9P49L7zkNA54G3SQL/+vQ/zxIN/ljUa829RBtdXbzD0e0ptUhfbAPtXBQOBItIJtOuBUljChMa0dPeT4K4YYK/vI4IjeMchU0Pl1nH4FZaK530oFkVGcW5PiwU79i31BWAGLAjWRT5yenCEpFJ+V/g6Dl1lTQ5c8l3OmifSCkaKhO1/ndrI4Oov6QO9jWM4ZXaLtpA7bX7OR2kyAmX/m4IqaKfMSyriamKeaRAVHVKaqbsUXemu7sVaLdeCsnI5Gnv7dVfCuZEQPV4UqJWGbhuEXhCxZvRn9euHzVjEV/RYFDUq83wsWRn3gjFm3gk0Fom4j1PTfr3kThY6X50ilRRaWM12V6ptBFEWVTZ4NqYCFmTyRXRVC7XQdIjzu9td5q1iCirWAQeDXyR7K4jStVQfzSA/9iVs2u0KYE6Wgm1dbZrv2OJu07S42B4UGEoHzXlE2TdHfL1W/cOLZJM87qOsUYbTi5paR1Pp+py56b7UE1IAe98a0PISPL34IDkiG/YjQ6xfWxXUq9j/PRJ/XUtxMYxwaSUAXEiVdpDyiX0vyYjUL/AYr0NKd3L8xbiSOVSTELIoWV5kzhMgBCF7ckR7sWRWye4T/dGcgVQT9sIPFpRD0+HNcJAc3c9Z7g8CU/1KpwVamUhmtDek00MWl6mInTDfrMHH9h8kMapxwDtncIv+G8n6RkEk+kVp9d7TO/I2nWbE4XGyq7kvvPohkYL9e7iG5NmGRDbEH3tKXUKVj4kXnp9Q1imaCm2v4Ab9vWvBvmxpTZ90GzEboyqgBgkyXUu8rGgcbYO4WGLbD6mLnngh+Y85qx0lI1U+onPLnZT+d7TAR2edkdUU4gL4gluycUn8TkWFYQLjfJQx7yBL+8dYnanijyVRRB/I0fXvJ2SOrAeYYrQKrgcmiJTY
 GxPWc5xe
 ie8K9yzbm7smPITqAC/WFBskdoOWPiCpmzRi4pVjmteLoCYo9jxV3S3+YfZBF3fbbrx9qBGwM1mHJLqckMd5p7pnOWWSKSPPyrRu6IMgmmhDzUL/Z/N0qrOfsTWjoh23uk+kvdtHCugJsDLQhxWcHV1prjmh8EcxCm1uY6krFQ7tBmTWrXT6EZ6x1GeLRFR2iKDsCKE6a/22vzIsPvLFlFvwaNuImdNQ5Jmx03YCIuZySYsjRIbcEkNozGq8t88yf2KJA5HV2KIt/qHPqcLCiNs92PkflaA/TFWTPowHjMhLNI1If6HsPMcTfKnWW14pG3pTfH56Pd+zcYcmo2bfkWGcANazD/ebEYX3YoTFRP6hXHXdpQhD6IXdqo+zbjSm6ORAmgiuhTKN3SHtJn4ohNEpPv1RvS2g4QAH6E+B/56ivGid6Hq7vdpVMkDo34EpmqnAte7cxvZ88oYi5qPJx+O5LpcfhnQApQdNzG0uBuHjwBuxzdyWm72kpobz5WiyxY10CVC4iJWloT4KNIyStLAUiRss6kKotVrlIhy8m5yJDrblNCPFx5HItm/P7OrGbwyWk
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


