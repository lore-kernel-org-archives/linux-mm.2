Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B7BACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7444D8E0023; Fri, 12 Sep 2025 06:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F37A8E0005; Fri, 12 Sep 2025 06:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D838E0023; Fri, 12 Sep 2025 06:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 430198E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 208BD1A077D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:25 +0000 (UTC)
X-FDA: 83880183450.01.E94092C
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FFAD40013
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iPZeUv03;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWZ0kuFk/JGga2KckHsx8bbCMGd9rBXEdZWbqFyn8fw=;
	b=SkwD+ISsqwrX/27DG/fut61SjRdi2CQ4ceDrCamFYScXaqtB7oFosrLko27xcksgVKsAFx
	5ktJyhL5wnQNelzKzFopwITi8ARBkQQ41tt4f9i7wr4a4OtAth53wrwrTdZJeKTNCxhq41
	2STq+yijhXqV6vaFFXyImq4zVw/VhMY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671943; a=rsa-sha256;
	cv=none;
	b=iNd61s1S1ZH1D6Pjygs2JjVObTa8eTRk5WTPw5ZmVuSMwzQHGLeXieT6FrgD89Hc1ADMvO
	3ISGFNwrGoVVgJh8gOyLQ0cPIg8ABFTyoDkwetToKWCdf5y+qA5biOnr7W12fya6cz+QZl
	dbh8cgbE6w08oDMUVp20vCYBUdvV7VA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iPZeUv03;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7725fb32e1bso1780795b3a.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671942; x=1758276742; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWZ0kuFk/JGga2KckHsx8bbCMGd9rBXEdZWbqFyn8fw=;
        b=iPZeUv03tZetURZ6wdVcBi+NtbvJsI1+DEPTxLqjBuoF47SMDRTZJCfhgnuXVIkeIH
         xP2Xq1YVt7k7jiw7x2sjwhOJCDmesfDhqBuxos7h8WxCUMdIrBov+xTlAmhT2hhn4kKZ
         RsDRqLHCIZaCxmzHTz6l25yMWR0TK4ttH3tuDed+40VEPJ9MwYLxgBr5aGbmtk7ykihb
         N8+kIOjbxCakLa7JwuYlDVBz8C3wjWvC6Kls9WSRL3DjzG5NXtFezDVBmO9rlbjHsFIJ
         qwfA1X2oPxPDNm5+FsHWVinv/U2DBcIW0GGsiG5Ce0xZfqiTpmkcoSyMRgcY3clCnJ/b
         ZnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671942; x=1758276742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JWZ0kuFk/JGga2KckHsx8bbCMGd9rBXEdZWbqFyn8fw=;
        b=oPCDA3gt626jUIv65ttdq38C22Q+C0+yvnG71KTj6yQmmBdEPyIjR1AS9PPSYSULiP
         673koGf+6GObghjlNftNxGbBj5YD41aMe2JFJu+/cB+mwMW6FBJTl4flwBE8nUtUW0tg
         24skGI/oiP2IWeSV2DpBbG/iJWyV4YYJN4nBYykEfR5xrQQtCSx6Roz/Zq6AdEheindJ
         C33+2KSqNqfr+NF2b7hNERWH6j2jRAj+jeZWLuo2He/4Zlifx/94MzSLvNcupaJaM3fy
         fyh78XXHCSeIWyp/tWGWxm3fZi7YPgSDPV7UGWxKGZq32/RHC5QjaSaFkD6DXquj0E5k
         zDQw==
X-Forwarded-Encrypted: i=1; AJvYcCWhsJwUuC6IVsaMtlncGYSWCUz6RWN4ufz4lpZavUgS9u1G8h2SZNeFBrtufkVt6VZaK6d4Pk9jyw==@kvack.org
X-Gm-Message-State: AOJu0Yx7VZZxIURpncXqRYFkou+H9EmADceSUEy3SFGX4c9y8ZP/4mnO
	eQDDBscjDpogI11boU+BSNGjhxd/2R4qsY+CeBCs0lN/3cmcOUrjl6SP
X-Gm-Gg: ASbGncstitx/wBlpillqV90FFCgXH69JA7dowxZIJeNbRM56PbNEFPDNgp2Yv07vNS7
	C3IFKB3pn2XxctOSRmqDq8CRxZSIJd8/gIDr1Ypk9Z0jaPR6TSXay8Zmq93UcKyVXTRZgc74mG1
	0rtfnRCXiRv/L2wcg7cvNL3h1Ga7LxG6RJex2X3RakC6rkk+0IDdn3ijrUmYa9EUsEXb1Xyg7+J
	IaAm3FWZr4uzxUk+Uy4eutbuPAzJBY04rpBFKlzdYY1N+8+LHXmjuONvPXI8H3eNb74qNzwuriv
	3GVehEOhqT/d8+W34P1eRjjOGA4tzL9q2r2xtDo/aB+GO0hyTERaj+p/dH9ih7PEjbO2vUtS+k5
	e/Uey+kdyh8CoSncaZ9prByydvij5hKeD79+8SHZvjRhDtQ1bVw==
X-Google-Smtp-Source: AGHT+IE8+93TdDPnsE4atda/JWPbNWLLDtzQ/rRojiuKNJS4zwHA9ycGi7y7HjIuRi4Y0KG1ZDhRqQ==
X-Received: by 2002:a05:6a00:812:b0:772:5899:eae8 with SMTP id d2e1a72fcca58-77612189a24mr2770987b3a.27.1757671941982;
        Fri, 12 Sep 2025 03:12:21 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607a46eedsm4969144b3a.30.2025.09.12.03.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:21 -0700 (PDT)
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
Subject: [PATCH v4 05/21] mm/ksw: add ksw_config struct and parser
Date: Fri, 12 Sep 2025 18:11:15 +0800
Message-ID: <20250912101145.465708-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uy5t4upfudfc8y63za83mjdigs55tp1y
X-Rspamd-Queue-Id: 5FFAD40013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757671943-689511
X-HE-Meta: U2FsdGVkX18Putn+3w7s5qi5Z2B68cRw7yfRlEicN5Y/0dXqbvHYhwyWESqpLxjOLnyNP/uMHBKGgXdc12pg8MZM0pZehj6DeD2+bYHNY6XHHDt8qtM6LkLQ2TwriOd37goRbCvpcLse27icaYTvt23BJ3ubdPn0YMhd3WKYBDBYVYm54WSuIwCuSIab7Fb2iUVanpJr1jzj1KTs6UcXy6rAG+JaRCHqRA+8+iP6WHOQXnN4MuzjrwA5GpUWiq0qI+pwdZIcLiANbNSITZhiFLkcib2dgtOnMuoD6c/1pZzgSPTtGmtqLdpFyRnwJkAY3kKq7Yb/VwN1WZOa6i46H5TuF+EjVOxcQ3Bq/uELurBB4AVhIJRwUKtQlzUklS7cQhuluvKl3YFNIJdZ3bHGyON/9agbeyMSknzDcZmhH4QVlz3B3Y5Q8XPrCzjIc98tIpStaTo1XhOcxqT0QqAiqNB8c2K/DFqgxDUlU8nn+CZmSrNjxj7x7WCvJ2vr58saPElrSFVMFggKX1N1sYxSF5dPH17bE97+0o7iUAsDmCq4YtWudx3tGhZdYLgP31RSnk/p/hosvLle7DgrH5zWr9cml1cTnEuKAQypfDQieXGC40lYmpYb2/60bcdpOo67LUPKhC+iksrDTitSfEJSnISldtSPMbF+Xm8KCHl74arqBbrbwG/jRmtDhwMzvdtNBGwIFvWw6rbl5xx1ys9l+kg0KF2cm5JpYGRLM9cBV3YSAtXYNq8C0YSGm9aazY0SZ+IrH7lafhDPGOBS0Y4a0mayo0hzeePlj0M3q04VlF0gCItZ40cQPf9JkR87SFxhDK8J1TnKBtniMWu8Tcwi2aSGcAXgNRZxCkpCNJYKzTyeIxAr6p6K8a/eFJI8uzupbQaSKNzIEbD7LabqytqZs/rNFlYcCmh4Pmlkd2dQnAkpYjhDgq+ZfJB1DyEAIc1/R/Fv4cCUeZB72mcBwcy
 9GeG96vo
 3MUlulqHmfS5BiXvJ23pDmk28AA5ZABP7UxCXglJiAvfhEb2vP3Ygggn44VEA2G/B3sFPlPtXLysJNE7iVbFQNEIjuIWdShKdXG9vk0+kmaFhu+iYJRqP8xfhujeXj1Fq4LiLL6brA18qZ5CR/xHAORxv/aogj/aIIOaIKJ9w6Mt0dleRngNYfsLMWP0dfH+/q/KXqHC0Amrzpl2q0eAdcvGedmq8Vkx4qNx/E8xL3ugMXgvz4IntCOKaHEMORhK0In0nawGbqz4dEOM=
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


