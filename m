Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497BBCA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F548E0009; Thu, 28 Aug 2025 03:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9558E0001; Thu, 28 Aug 2025 03:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791608E0009; Thu, 28 Aug 2025 03:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 615518E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC7511A09EA
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:18 +0000 (UTC)
X-FDA: 83825352996.25.064436A
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id F117E40011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QCmNIH0u;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oy0C0swglM9nhMs2jJeQr2J+ATypwXUQHvq+zmKtZ8o=;
	b=KeOHU/HKcLT/e8/bl9/Qv2bLImR7QEyEAUsX0PuPHgGD7NFgILD5HnTd4Jw/QWqI9Gh7CH
	qPlefQp8YATNjATR5c8fdxqtxMFUBU2KOrQUDP0p5zyhfxgXIchLv96XjDe7+85pQ6UMBo
	zgl4aZJ5noc3f2DwukZaGZlg2bCrP5g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366457; a=rsa-sha256;
	cv=none;
	b=466KH22o+4yldUYMsmfiHEPhsNktQ5LP6kMx8qBoiOMjr21fmIXMDBdtS00rgFc+kMvRdp
	+2LBQxunpDlesc2St+v6NVJq1iIcjyXBpDbsBdhiWpfRxpGuejdwyjmZQFOngcmhgGZKU7
	yHLg9QBbSjCHLlQTl+6/sSzvFmmU7pQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QCmNIH0u;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-771facea122so333806b3a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366456; x=1756971256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oy0C0swglM9nhMs2jJeQr2J+ATypwXUQHvq+zmKtZ8o=;
        b=QCmNIH0u1O0t0gc1OdatzG0hyw6D7nXLNZvNwo5iAxDVMTeFnaY3uqL10pEyUAiF64
         Yzcj0197603dxompkWZgLuvqiXv21w/kesESfnvO/2hCVUYvwGIayCioV5NAThO8PdlY
         14JnpplztA8ebqQ16yqSt5s93F4BIu9k0eFeW76zJZsXr9qMN9tEqJOdkQlf2XwUzic3
         DoXdRlC7q0Ekt0i4GJqkj0hSLAPRODFcqk6LhUPr5y1pACwOHrEY9gfRS4Nhire+AxrQ
         j2P9GNwG08n3DCDisqczRTS9cgIdVMt6lXVngVcSO4ZYTrDaBBq0aMcHeexY/slt6WQq
         2i9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366456; x=1756971256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oy0C0swglM9nhMs2jJeQr2J+ATypwXUQHvq+zmKtZ8o=;
        b=xFj7/mXFHWT7limsi9NSglNS5eZE0abS7B/QBaJ9GTKbVNGr6rQUgQhBLlagKkLTvj
         mIE1cb+F9N2CU2s68bGkrs477bPHo5ICAA9rlJMbIzxfGr8pV/ir5cqbGSEtDM9CLddk
         NMvm09OybWlErrcj+JJQXjU0Wxmrd83sf5BA+DvdPoaw4TEgQMfRInygWbgFspFmNo5i
         sq25m8+bPdtLdZPkrRgNUWryrd6ZlrcYPpMEOf+iY9yZzA7XqA1Kr6Ii+/XuqbpPye+5
         PsduwZVOJ4y7AycjhcBtNzJ8Pf3Ua726WilLHmxhx2tkO3EiMmCxXWLCq6NxJi4e4fTs
         wU4A==
X-Forwarded-Encrypted: i=1; AJvYcCU74sFk7muTWPkxkWDzSgWL4lFjRKIxGy28Jn0J4Sb08zTNLr6uf5xn5ulzLiMFZh+bHMLfm+ZwqA==@kvack.org
X-Gm-Message-State: AOJu0Yx8sYjFq/02F4g/GHTecTDlYpFnO7QGm2+zXfcH9rp0iN1xY+gf
	e9KAkeXasRk/gthPK0ItyZnREUiCxJ/DC7+a7t67ZhiPqAxbIR8WI0jb
X-Gm-Gg: ASbGncsi8Ps5qiaPirQHsLE3hIpwBTMDxk0OZGVQxLJr8XJy9A7W/zUtITHTgzZ5g+p
	wTZnh8gaSjI3u5uSelyhfTdd2/tQF1OO6N9+/XzDwhwH3WPFQoGA8EQc1M+IXyvlrN3mleJ7Qkg
	GHSuvykUp26hC8K71lyVcDEeM61DDpxItJ7BAgMHCAv7wVHB7TNHewpBzt8ayEwf/1JQtNy9omw
	d9iNK04fOrQaRsMDghZ2d+UsDRcqcLOjEdj0GzNic3dFeSOvrEvqCmP2kzliY7CyV6qvxdJUlHM
	3VoYBoxo7LYv3VWHkWJApe1fyaTmML8e0gk8pZJDevbF6VoSW2+yCV+vx72J2u4Z5udeGUYJFV+
	FKLK4GJrzEtVFra9cdL/oqqlQuYcwA0byoY1k3rnGLH0APL2xYDidSg+7bKZw
X-Google-Smtp-Source: AGHT+IFHzBxQakuN1JXsJ42RsWWWZRkns+BK6Z0QAL9Y0L/arSVa3U2kDuosHVpFKM1rO0HaGrnViA==
X-Received: by 2002:a05:6a21:999f:b0:240:116b:cc41 with SMTP id adf61e73a8af0-24340b2757bmr32060790637.16.1756366455717;
        Thu, 28 Aug 2025 00:34:15 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:15 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 02/17] mm/ksw: add ksw_config struct and parser
Date: Thu, 28 Aug 2025 15:32:35 +0800
Message-ID: <20250828073311.1116593-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F117E40011
X-Stat-Signature: yxkairjhw1d6hmnyrqqfn7q1see6rnay
X-Rspam-User: 
X-HE-Tag: 1756366456-739000
X-HE-Meta: U2FsdGVkX196KV0BTQ+PgsbK6vdwmNZURvXcnzEp2NPX05OnYRss1P8I2dT2ehz53KHWB7CGb5yh4G+Liz1+8KLRvBempACiAgB+ThYMF6Nkj3AbnBV6BMbY2wNbB2NBxg2Xya46SLSDiiT4DWx0V36WFgyMdBKkfI8TVwzWviEAHc285QGPxLUKGbX2bqooKvafLbeErPNurT1iPArNl98LjOyzcwJYUb/fEp+j8rLcRzUEVNvdolojMzFbLa9KGMrFkiNQR6H6ZsQICpdijR09lv1xs1K19/WrugxEJ9jwFYVlrvFWCXZ/V3zFNoYmTlXe/QrAcDtHlacKsblrf/Orvpou+gaFm6o4xqUgCjjx/r17D/l52EGb2ZqzvTEAZ0wxRaFcf2/Zn5M5Vl90iWn+9EgnDDmBWjcUH6oWzkXlBoXkPKBdMpjpRAPkeP5OsKJlAd7SXW0S0R2qSqVjnjO6W6YkF3YfJ3Lh4eTVpQ20j8R4k7Bnekd8yXYDS8vA8YXOeFWOtxXozVszTM6ERlk7zvjHUthxZyHGGhE1QmiF5I8thA+futtZKBez3uYWeJaGyA8UoaAm7pslUT5f76M+RWLWHwhVSLvrHKxG3O8KGJ/2BL7J8+9dkG5LK43X0B5Wlb/1DuV+HVccmy4RWPi4+u4Y3PLX+voELBrxtoqY8BobeLp6T68xmVLXkls7MmQIYTWklk5Wpru18drsXpM+EzD88dOJHChg4aF0g9ChZax3aPwoGbi32HiQ8+l6RsjVq8O59w86LH+tS+7GbXsKK1P13/BxyeAO92tJFQ8nDPr5QIhcjtP8NYtig7Xwz4wG27t7aVRYp/ALm3rjaYx4tiFncciS2wGtMA4EQdcffQdxSoZ1PKMfTXcU4K2V+aMjxLbFFbbhEXKZlcYDJJvRlxoB8s7yzQl86Df6qnZnLujKgyfHcW9OpE9QkdApMNXWP6XO7uTpJAFpbR6
 agobAvcW
 OI5ut6ApDWXRMcPIZUwGCqY+kVc4ZCFYBk5JEVFgrOP0Ls0ApiKrh4W/SZntMOB+WtUa9zOZquWGVn5Cp5JsaTpEOOd+orG44mQwLnz29SEE9IfxowXi1fEuIbUBY2LsCg4EqSIJMaYC9ZtODhkOqK9bx6CTQrhxnakHyKoSL+5L7bYgLhzpL8Xb3Cd9TN2iFJ8CAtjaRsKzcbPWKSIO8KGVv4muMjJKWfSqePbM/CwWC3wCNhH2ztvfHUrn+FhjOFSWBtLk7O5e0sFJb5kbT142ZJ1dhrxUX9cvSIHyRbeC9oQCLgTM1MaBuOR4m/tSceW6zolFdZnITlbqQPxwJeZNtEcOdyOXfxn9n3sFKjVJJcMMziXVUGe0uhacowXSRlPzBCsWyWErhcERtLQ2U4X64MTUADgkJ3pcsVlKh4mFLWvzof8DP70MO30Q2mqFovUvM3ZIwRsWvXEr3u41eZh/0HM1WHFdR9sdLokGDE4gSeZEUHw1qoHt/M5BP1QrR0YwSH2WaIxKXnZo3ElTd/1LnxQnkePNn4+iFlVonyQvz0tc=
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


