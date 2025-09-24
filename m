Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE15ECAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EF58E0010; Wed, 24 Sep 2025 07:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBE28E0001; Wed, 24 Sep 2025 07:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D4E8E0010; Wed, 24 Sep 2025 07:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 122218E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:51:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CEE111407D6
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:55 +0000 (UTC)
X-FDA: 83923979790.14.D01B33B
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD8D3100005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E3oNZHk5;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
	b=e+2oAsJLFkpCu9jnM7VYlu5v0sS9vC7ITxRKQRcmwb58fyvAPqlHpSoc3HXUfQ3IuS5weE
	0HpsBtr6RxQ4sTEafmYwB47HfqRT0JpinrKn5QLQluRk3e0WBx57ghBIhPdMCLPVZ3F9H6
	ZCMYpXPusd1kZB6hGX/KMLfCfiqh1j0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714713; a=rsa-sha256;
	cv=none;
	b=0+gRjg3ScLHDcc7UoaFCccVzLKKCcGFA7/G6Sn5bybWEGEf8M/zephgAT62mr3g4EBykgL
	LPG7CS9/F3PRkCit1xGojhSTgnD02qGR4MbEC7595EEs5wwaUC9NHDrJSgu6TIBJEoZrLa
	CcBvypqgysjtQrk08gZYwLzO1Xv7O+k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E3oNZHk5;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27eceb38eb1so1435765ad.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714713; x=1759319513; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
        b=E3oNZHk5oSTZGbYRmlTdkOpBNt0PTdBAyAenkk+btXtuH94k+Nm/wHyk58LBdlCO9u
         JTrP/Qvf0Qhg9bl42IJ+dh63wh2jaasIwvmSkXBHTritP0sKvg81HSFGQxJ3N8sotI+C
         klgs+3/ZtoheBQf0ymrJrpfNnfHMuo1jOxllH4lx+RChnQr9/Xx3jpMOtQwsR9csvuKD
         nJrTFUnHrvj1PIqu2VwSFLU4wG0LIpPuDXXv/z9haTIbe6Ippzc+zXEJurX42JSauAXj
         GXL00R+RO01AyCpHuiqteA/+J2otXEoRA8L9JVXRUV1LfAboT9E9g0QrIwUGN3kceUOu
         cDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714713; x=1759319513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGY4NXn9SYrwp2MIROIAsCXd8mHWC2w3iRZMJXUxzyw=;
        b=qGX2Wi1O0Ys+v8H4E8heDfjKU9D0M7zqxstXko98s2R7odOMHiW7KabdHD04arbG9E
         lB0kxQr65Ui4c5hkYDZr4fOVQmqAALKtSX4zdLJwhb3694Pa75TPvHOAOG3XoD8cNKjW
         bZIFQbXBdo2wJOEt/eQN/sHE4tVB3/iR9DsyGZGnRCp+73DFxDkDWsvIJy8b4yG8eXLM
         B7DQWVH4M0x9DdKjGKwZxayMQ6YySrC3vTGaZl3HcSt2d3/R4a/TQ8bPKhRkgQ9W3T4V
         5qF3R5WSBWYK4arJjSBVULHqz001ne4tYpYOJsS+iF3XXXFjlHI2+g0ZBlJCPa9GJ9uL
         7IkA==
X-Forwarded-Encrypted: i=1; AJvYcCWyA8r8teC0J1CbfK6y+h7OFJptZEmnmOA3GZ7X5AUJBLrT5Gq4D+rns5fKcQ0IWq5QnQ/N9U/YOg==@kvack.org
X-Gm-Message-State: AOJu0YwaoA4Yj5rXio3VzcOJDTJIaohg8X9VxafCocCrXpwcUDlsHEiU
	ePpeY15VRjVibEbvW9VF2zY0HV+YIuu7n/W6zVEM8McJ2ykJW6luEWTb
X-Gm-Gg: ASbGncsCYzHTikcMoghz5w991X6CREaN0HyM3zz2cdg/Hx1ht/ZQcjSIlAVnqh3Scys
	Er65ri4gUwfHhFwosuU8N8HSXOGsTlGWHJgiCwMqfCojT1PNWaOXb+k2As/Kf9wAGCk/HXsR48n
	M1pyCKjZBEu2HYUy+po2uoMItnFYXZh6s0sowgByI8Gha8H0NCSu1MPpR+g4KRG0g/mzvhfDeeF
	BsImK291UjMAlsIvXgWR+wtwzYJJANo7KhetScWQhFTA64Farm6e3vCejqdArX7YV0gDOPrt3ab
	93rGOiVScFK3Om7syncqZ5KVK/svvY39ePX2xnWoHxETd1iSn1pIPljYOjpjRu8f76vLotXSrHt
	nq8joY9gZokltvX224nZ0ErqPKqZD0csEq2IQ
X-Google-Smtp-Source: AGHT+IFMNctGW9Lc2RuLDimMt82FyjBUd6I48axMdmkX53huq+gu8b3I4mIDqyHLSeX7qGzL0isVyA==
X-Received: by 2002:a17:902:e885:b0:25e:5d83:2ddd with SMTP id d9443c01a7336-27cc678336emr76685615ad.45.1758714712744;
        Wed, 24 Sep 2025 04:51:52 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ec0a7f443sm19635565ad.105.2025.09.24.04.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:51:52 -0700 (PDT)
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
Subject: [PATCH v5 05/23] mm/ksw: add ksw_config struct and parser
Date: Wed, 24 Sep 2025 19:50:48 +0800
Message-ID: <20250924115124.194940-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD8D3100005
X-Stat-Signature: dfpauxqtfwp3p4xinrkyhxxbd49i365h
X-Rspam-User: 
X-HE-Tag: 1758714713-24274
X-HE-Meta: U2FsdGVkX1/WZ8Odfnt7eXiWQsNKLN4pUeCHhQJ6txwpLSS9xgS57TtHgzsHsBxCqt3/UViOsPo6GvoCoH9Vdz2xUGaIHfgubFp1uuOdBi4X8VrxouocxH5Xq7AQFPXmD9jHDASH1nvFN19Atr/ygRa1EN5TLVT1ZhSeA/OPP/mYcEynFCuPmYDCXnC2fAHTuTagHRB732s/XhHH06BdyCuvKye2RbGaFl8T6Ud6eDVRdVTo1EjrxORe6iNEdFQUy7polrAYXibJML6ptspD6TkgK70olRYbmC1Ip4AVI/o4WovVetfStey7a5cz/V+W1a30UOOWmVE9R/HLpPdc9X8Tuv/sfeQtNgg2pHavUUqsLdKdNqtIJfJEStjWwWhHHaky0E8B4SlTmrcsBPiSu3UXc67AUXse0r3v35WjLTRmjRD8PRbeJEVzQzcIeMlI2SvrsI7Q4HZ6reF/x4Kg7ZXUFdDjRa5P24Z8BSsKYmrAbxlTivbbeG38cjTfFeb8x2tEts2fKzk/fUDv7zaBUflmbLkv26ZGY/TnoF4qorZLqGNbp8pVhFpw5eyojmryQjIATvJadG6Yx+YckMctT+3BR3N3AEHp5HxnHrELXWzMS94y3cn40mk+IBNP24AKAuDHL2ocaDKnJtIykD8h9W2xpfxua52IYgO7qt4ZE+2Qy1d9qc16vdu7BZyS/yfF6CCCKzZcYb0AE3ySGu5bjHfKPav4/p9Gmq7uZ360R5h3CtFByuuOnRS8S4bF48DehNKguWPJk33XoXoptwDjX3oVaSFJk9Nuw7XCpbklfolGKIRsqQ6D19ARMPt2g+5uKMwNbgGqgWXRhJXL/g33PKfY7vZyVSZ573Fsn0fXUgpJRsUZnWAPj2a7jAy86sb/OjUNhx0lLhIUw4+VEaFtv58hwzi+1xBe4aei92nWl/FyCXuc5huh1R8R09dO3UHbcKdZTJNTUOVGBOtMFDQ
 eFynwWIB
 bWOGeXx26TyA5L0DPFMURhUgSfBI7k8S1QYJ5oe0VS5xJ1zTO4S7moPXoVMZzxJ3xj1ccxPI5Kp4PPw+g9yx/EfG/lgLa22p/rPeoqPF6vnkhWN2wM0j01tU7/tonthCDawxHa6AfvufHhQDyDEx+v8x0wOMamz72jjz7hZxgG5P4EpY0ltB+7JVe1g1vZFZNAGXdHeleu3Sl9k3gSPFV3wUNwZQSvxmimO7VlurJvIV39vihYN1pLMhoGr59lmpM0OFw6n8Y5nrKTcuIo5mz0X021W8SX+8BQMNqMxmwsxIFfpAOh6CnQrxIkHdFVT2OKmCMRtmCQfL/xQRCKpDEac8zZdGqbcgxeTCTjUX9FtSXaxXe+Ko+FthUGFXFLIg+0wLT3vTdsocPNFyeX/gSWisH0tHtMXV8Jv2KHOQ86dPt5AiegSH7Y8wEsn6i+Ig0PHE8Ds6oSpCrzdPMjsece0KyGPMtEER17U2vFwPHVKRxM+eitOgqexvVFKiSk2Vno++0OXGvMIl/FtgZo56CW9ywcTeEKwStsKY93st0cIPpwMLCSA/mIN9y9sPyAhgZh0/o
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


