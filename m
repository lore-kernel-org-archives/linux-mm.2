Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7777DCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D528B8E000D; Wed,  3 Sep 2025 20:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2ABA8E0003; Wed,  3 Sep 2025 20:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40B28E000D; Wed,  3 Sep 2025 20:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6D828E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:22:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5325B11AB07
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:08 +0000 (UTC)
X-FDA: 83849665536.25.9AF4762
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7714F18000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F8/XgCJz";
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oy0C0swglM9nhMs2jJeQr2J+ATypwXUQHvq+zmKtZ8o=;
	b=T0XX7nBhOULjCNRDb9F46IOvbwVQWRMXDiTtmwj19ZJ6671ibmPG8yhsHOWL9fWuGRXF9b
	oM2XRSGi0hHvPfIQ1yb49ZxMU/bX/G+BRUcjS5eEYyb3VwCMNKQabwEN/jGbAjFDpft2P7
	+MIfVMVWF6B72Y/BHZL23k5XgxBU2UM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F8/XgCJz";
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945326; a=rsa-sha256;
	cv=none;
	b=A8RBPEX8/X3dt4fNCO1aV5tN8CVpHEpaZ3MEFbB0QnYFhU96Ni/c1HtfQ7sqXXsrelA3AY
	+qEihTU539x49tvlFb/tTz90ntEb+t1TCYm7VsmMWKEPHDNXzHgCkzPbtNCXb8618enzZ3
	CcjB1uoaExtv94kSuiIh/K22HJ9bAvM=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-77251d7cca6so416911b3a.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945325; x=1757550125; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oy0C0swglM9nhMs2jJeQr2J+ATypwXUQHvq+zmKtZ8o=;
        b=F8/XgCJzKk6TZEjEMl9vcTdosikhDjInzBmYovSh7prmN0C12GYLwxduNzv1GxytQ6
         pzVj0Omx+a+vEa37zbbdyjkuqL8hAPIhOWlNjAUHCxI6NwleJosAkECcnCjEPWoFhXrd
         gJQirw6YzDIh8LnXuDlcXP2P8XLf+VC4DqEdFa3eLAC3MxQTlBvshtIBJuumT9p17211
         CtoeNiwaZm3tzDVlNrtt8cGxv19aAxluuSo0NobcdltJSlCcaPTpiG6IVFxjqgYmA7nL
         RVeouzKyuXmk7waPLa1wUCLI5uNAiRDN21vggrEk8mZexfnqHQBh1QQF64p/uop1ErRr
         TUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945325; x=1757550125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oy0C0swglM9nhMs2jJeQr2J+ATypwXUQHvq+zmKtZ8o=;
        b=QmjdmvibI9aUW8CZS7ARA2H//4XEXoMSdZ6EEZXHLNBAZLwenE03hQXh3VI/GQw7np
         YsKh/rqLuMV89tXOeSJ7nTziBXxxxm0AN5NngiwpaKfquLUbWYQpJrUoy9nwlZ7CeIoD
         iyPSYJCnMFVe98nLT8mAYvLXvHDc1f1qoXXtK0kdMN3TpxMHMxKb3tAlHpIbxhqmibvD
         CZq5VwXih8KF0G0eVFIjBjE7UfeMiv2tmZUEq4UKqUrzi5FubhVKY7qVluSHJf1GfxS0
         QC2ZmQKnkx3qqGsh4QUdotlWYzxGKzN4XO5pSTXQifv2aYL7uwvebobev3srEEKWkvFj
         WN8A==
X-Forwarded-Encrypted: i=1; AJvYcCWpqzf1Ov8jNRna3jxD0buYn4uUDa1ED1eBga/d5iXgHH7R9o9hWjHb8Dr3ACULzfBb7vIZDNEqgQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4Ioh76or2LyH2BfsZSalGgsgwLbvjmftzW50RTYgAGAxFiwmC
	jlCG0kYVRgJshmEm+wiIfXJQUYjct6RXV+1QOcGISvGXi4r1jJRGh2oQ
X-Gm-Gg: ASbGnctKq6E8uBme4ozC8zC6XDQEo07EiysuQj1t6ZCK+sGcUaJ7UaKarOiWZodljE/
	Zii+RQBhGc4AgwaW2Psz8bF4DNKoGHGeTylFriSid5baGYpYhaOGThsBvTh0A1KojiOPp6kZ8yZ
	KtaU9mZnOX6/NKQKSH45/6uwSw/pCfVmFggWtG1nuWFLLks1W37yQ6CE0bpZJ5ye8Sw8mGK49jK
	NahuaW8T0pPZBcIZ4INxKrV2RwNUqeqvT2firqMHQz4fI82Wh/+JSFzcE+tmzreHJV4PqnlT7Hr
	PSkupCRp4M7tK5Qd0SuLEFY3zstIEPKDRGkx5spRcxk8LWLA9XXJMGm8fmwZOW27Sh9jCC7byEw
	igH1T3i2+SuCj8udQDWDLQpez8zPhhBMEchrAaUkgZ7eZVXnr1GZou3Xk37PcZQo=
X-Google-Smtp-Source: AGHT+IFybxLzi3RhG8G6E0XW25a7NBfoJQUABi3RBwpHwqaPA2H33RcEs3ZAByeGLnEmBrGiX7iCMw==
X-Received: by 2002:a05:6a20:4c8f:b0:244:58:c147 with SMTP id adf61e73a8af0-2440058c3f7mr9480142637.21.1756945325307;
        Wed, 03 Sep 2025 17:22:05 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:22:04 -0700 (PDT)
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
Subject: [PATCH v2 02/18] mm/ksw: add ksw_config struct and parser
Date: Thu,  4 Sep 2025 08:20:59 +0800
Message-ID: <20250904002126.1514566-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9y7jgbut3qsdsmaibzgedh13pxo3qkdq
X-Rspam-User: 
X-Rspamd-Queue-Id: 7714F18000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756945326-450636
X-HE-Meta: U2FsdGVkX1/qDYbf9QwJyywWhilVD97SNMwAJYjHnlDEwup5E7ZKhsEibtmnI+r7dH9kAB+G8CThq+9pZ5S9nIru2GdNiuKnrm9TPBK0unwUPeFRgJDBYr8N6YsBG2+4DaXuSno76baTSiacHAaJuMbiySqc3tREtNx7oMrSlDFuDipA95w2+05iLzVFyIhIr0X7mLxMl5mp+xinhqiIK6MNfSiIMepgzyV90vyQ8tTGjiXZ2ODhVucwG3EoaiAxJlQb4o+7WUXRgjZMDFGK44/CheTkBrzhCvpJ5MK+YUI8e2wlUarTBcHt6EhS28OVH6iTKjJtga73l576Zg8/JP5oZrlicWaE1h2hvhbMsn+9oJUCgrV54KW3Q2E+BA1psHTAJ0hH8dFAwoo+wbCwrJUbzZHYWjW+BKl5C2aNoilhLXvzpH65TBl8p8LFD5JCP22K0SofqVLHT10obR7UrhlZy310BokGGa1TouCzIp6hsbjyVf+Z/9vdRw7p85dMmXVL4jfUuGxO67I8Y+qJnlnCAmwYzY9/YCKSyV6cRRlv75U6t7mgStfE0RtlQWbghtSAmxKr4Z/5PZWLqr2CJbB2xridWhseMCoI0hX1v0/dSbiBgmgd/1IuaCz3E53U0Oua/JPYJGYrh2iPpb/RE8/E8bqhkyFd1flQjVgeLiTV7CObQJipMkq0yeYAe6PkFSOiHNxI2DVF2YNQVpVNe+KtvjcxuHTQi6DW6Qj7fUFsdWlqa+FH9xZcT2l9tmaZtmAOcwjZQbzFHRRycgmIuCdg8hF69np7mYepOEupkgwJFF/RsCeKmVU2Z4HKq9fd24c2eklAK7S6lS0m1SwvQIbcZ5zTBNlNOzK99iEeGA7we7XvqIdVrnUPisU/rkTfJWGcO/ao71r1suSONOvjEkoJpgT6oyibb+Uhlu0YxY25cYzC5OIxzSY5txs4TWSNPPVQkd1QIfQ4IocvF75
 RTDFbhaz
 oaKk81G4d2oThr80aHrADNMXeF5HlxVFpKpRPjSBTYr/paNwuclJxZwHtTCpccV9pjI7SU10Xt+zpvcTvJzm/URwMMIA+kL/4hWS8zqLTH0kwpSgvVGK98eMgbeRF5gkaZ4KzHZqg6alBxO1lnWSa8rYp5+opr80S/2Gpu/tOi87H3IFDfS+zGSGAdY3ryGcNLkrhJLFVe4YIX2JuzJMKVjame+GYi658McsyOu4oLts8WwwywPERu1x6UrivArPmr8equMsF3aSqOTN8OBPez5BYgKslYvJCKYaJFEss9m9yookGmBugSUvcekEnGHKFdFI4pgRkGaz8i4uee4rymCj271IYbROnu+gUP27Cm6fWtvrovFXYTYFGgiuj8oNVZYsgN9d43lVniphcBqElIe6php49TUX+oC+4DzxhDBiOoPmyksPmzQvwtvtsEUmvXNr9HzMoGNfUqyXnuyGr7mh0ijEIEXHluY6Gh2M6vnsb2gVrgslDz29a/4G6lSKKvBGtOSR0Pv2vE5Ei02CInoTpsP4C0PIpmHd3Xjx6reEShL8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add struct ksw_config and ksw_parse_config() to parse user string.

Update `Makefile` to pass compilation.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/Makefile      |  2 ++
 mm/kstackwatch/kernel.c      | 70 +++++++++++++++++++++++++++++++++++-
 mm/kstackwatch/kstackwatch.h | 34 ++++++++++++++++++
 3 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
index 84a46cb9a766..d422f0e114dd 100644
--- a/mm/kstackwatch/Makefile
+++ b/mm/kstackwatch/Makefile
@@ -1,2 +1,4 @@
 obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
 kstackwatch-y := kernel.o stack.o watch.o
+
+CFLAGS_kernel.o := -Wno-error=unused-function
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 93379a0a0f7e..4a6dc49449fe 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,11 +1,79 @@
 // SPDX-License-Identifier: GPL-2.0
-
+#include <linux/kstrtox.h>
 #include <linux/module.h>
+#include <linux/string.h>
+
+#include "kstackwatch.h"
 
 MODULE_AUTHOR("Jinchao Wang");
 MODULE_DESCRIPTION("Kernel Stack Watch");
 MODULE_LICENSE("GPL");
 
+/*
+ * Format of the configuration string:
+ *    function+ip_offset[+depth] [local_var_offset:local_var_len]
+ *
+ * - function         : name of the target function
+ * - ip_offset        : instruction pointer offset within the function
+ * - depth            : recursion depth to watch
+ * - local_var_offset : offset from the stack pointer at function+ip_offset
+ * - local_var_len    : length of the local variable
+ */
+static int ksw_parse_config(char *buf, struct ksw_config *config)
+{
+	char *func_part, *local_var_part = NULL;
+	char *token;
+
+	/* Set the watch type to the default canary-based monitoring */
+	config->type = WATCH_CANARY;
+
+	func_part = strim(buf);
+	strscpy(config->config_str, func_part, MAX_CONFIG_STR_LEN);
+
+	local_var_part = strchr(func_part, ' ');
+	if (local_var_part) {
+		*local_var_part = '\0'; // Terminate the function part
+		local_var_part = strim(local_var_part + 1);
+	}
+
+	/* 1. Parse the function part: function+ip_offset[+depth] */
+	token = strsep(&func_part, "+");
+	if (!token)
+		return -EINVAL;
+
+	strscpy(config->function, token, MAX_FUNC_NAME_LEN - 1);
+
+	token = strsep(&func_part, "+");
+	if (!token || kstrtou16(token, 0, &config->ip_offset)) {
+		pr_err("KSW: failed to parse instruction offset\n");
+		return -EINVAL;
+	}
+
+	token = strsep(&func_part, "+");
+	if (token && kstrtou16(token, 0, &config->depth)) {
+		pr_err("KSW: failed to parse depth\n");
+		return -EINVAL;
+	}
+	if (!local_var_part || !(*local_var_part))
+		return 0;
+
+	/* 2. Parse the optional local var: offset:len */
+	config->type = WATCH_LOCAL_VAR;
+	token = strsep(&local_var_part, ":");
+	if (!token || kstrtou16(token, 0, &config->local_var_offset)) {
+		pr_err("KSW: failed to parse stack variable offset\n");
+		return -EINVAL;
+	}
+
+	if (!local_var_part ||
+	    kstrtou16(local_var_part, 0, &config->local_var_len)) {
+		pr_err("KSW: failed to parse stack variable length\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __init kstackwatch_init(void)
 {
 	pr_info("KSW: module loaded\n");
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 0273ef478a26..b5f1835586c1 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -2,4 +2,38 @@
 #ifndef _KSTACKWATCH_H
 #define _KSTACKWATCH_H
 
+#include <linux/types.h>
+
+#define MAX_FUNC_NAME_LEN 64
+#define MAX_CONFIG_STR_LEN 128
+#define MAX_FRAME_SEARCH 128
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


