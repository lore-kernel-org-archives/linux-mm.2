Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30512CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BECDE8E0003; Mon, 18 Aug 2025 08:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CFB8E003F; Mon, 18 Aug 2025 08:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D9D8E0003; Mon, 18 Aug 2025 08:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 930838E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CAD21A0944
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:42 +0000 (UTC)
X-FDA: 83789806884.05.5CEE15F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 740C8C000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QIfGHkCD;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520120; a=rsa-sha256;
	cv=none;
	b=UjkFEDyzGXT1TVm7CLhbB8J5X7f0LZXC8kBDnlDPw5j7iM+VWrFOUCuRxoSQCw5vrzpVzm
	Oo/CQ5E9a5IusfvkQ67jezivOKq7IzAj51PtdZb+f74hQnO2Def06MwkaEn/mDt9Ro578W
	5qOH1jGbzbGuGnGVNO6rG4ak0clFhbM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QIfGHkCD;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJOiI8uKFg1PMlS5jfewmtMLkNj4AhWzyI4e+6eTJxM=;
	b=rBQTnLi6YVxRuIOA542N5xUcfOOa0hp+EjasGIbD2fz7KbkKpb7fqgb2BkRYAC0OTpgYjk
	uCGqSXwVEnUpJuo+6HLtbdLm3TPXL6KBnf9WhINbnn3/SE5HcQ7olzc8Sdu7zmXLgSdJo3
	RQ0G/Qd8nr5wizyBZuH2SyfTqNTzKJA=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24457f43981so26171435ad.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520119; x=1756124919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJOiI8uKFg1PMlS5jfewmtMLkNj4AhWzyI4e+6eTJxM=;
        b=QIfGHkCD3AGwRC5VFKsVl8VSY9SkBss0o6NceurcCVqOTdQ9tnVYgFjTdPwO72YV2K
         e5LO/vwfRYhEaL3dQl6FlXFCQDuT4nyowv0xSJc09wx54VZgdi9n0pl96txRZJqDPLns
         gc9Mne7hguvGFFzSI+FKKfBFnQRM6GNwQErNX0GZx3qRKtVbUQxeWb10lDogD5ptMwpk
         2jtcpTRTllPPo00SkJxnLGyPDml/8S7/uMDmwL2tr+Xy61mGFGCmhmeqHMAY1iKMY9Vw
         0kN5Zl6w2bhXtS7MWvYxcWH4LxHvna/zUzFdWV1Ng28z9ZiZd/h1pWkJR931R1R7Swxs
         Acyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520119; x=1756124919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZJOiI8uKFg1PMlS5jfewmtMLkNj4AhWzyI4e+6eTJxM=;
        b=DyuyUxHCklTbGJgVRjyQBE5dEe/4/XmeQDZRs1YPiYNEQWBPYWQ15lqg+cgVCNvXYT
         Fok17e7pg+NTEvggVm+IYSIelPzBsWWXova1/CBr8oGy0o+6Lm+72i+BR21xHm7+30Y/
         vyK1lTdMISl1E9DCVDVHO7iqfZrNHS9aapdE+Li8Q6tKXySeWAegkNcbYJFfI1VgOAGD
         tFLT5fYridBJl9V8KW5SkcCpJcflegvduGO4ODd7LRrFNeFrEwM/Y5MDB+hyLmIV2ptS
         X2s31IpPBfN4+d7UeNpnzZzk6soX2V4qb6WqI3JRh1sldjM1sWBatWwx8jkKZUsqQd72
         QCEw==
X-Forwarded-Encrypted: i=1; AJvYcCUadnweRGPRRVfnZuqKOgV3P/AT5xsfkcEcYBSRpdYcjiHLVr0sc2m1TQOTIgErDndKpzLjUr4aDA==@kvack.org
X-Gm-Message-State: AOJu0YxIjcJ3SZMr+PD1Yywuo/A2bsTHmTWxqPhEDviRZbCPaYVfhU0v
	OhJLE8dgj47z82x0SXY5H3ZBBhARyg73IgOp7agcRR0vsX1xoVgzm7Ks
X-Gm-Gg: ASbGncvQc49ABf5cmhRiRn1kPDRa/NrvkGx+/NPaVN/N8RWnFrUssF53gUbaRxmIM7Z
	e2EQJf8ur8oFFPLaGdIUbWxqB1Fxww/AqwAK6b5/b8HimqGbfN7GCRIyIjji855+Mm6JaZgduiV
	phjtqcNbay4GE35tSO0REG9uO1yByZKsujZiyy0CfNJnBg4UBHa9zLocvcgGM3YzzWrlARyEOZx
	0lcBgSMyXrtCz3V5CU+2K4Xn3QhbqhpCs62WjgjtLSaNxxEiqyC9/L6X1SMwKZYlGCBjNZvclmH
	ScvhqR1RPnTcvzwS0nYNH12h3F7a8CnXCj1cLGTq2KGew8Poocpv7YCu66qlKRYtWMT/Tt/Lje+
	DV8ufGlqFApuy/LJSckWfEVBP2Aald3xn8w==
X-Google-Smtp-Source: AGHT+IF3xgcSOR7IQl6nyKuyM5+bsTV1yJleECFH4ZQXynkLUSFqvUWCjb4R/DqrQcfTlrIQi3kEfA==
X-Received: by 2002:a17:903:1746:b0:244:9913:2fe2 with SMTP id d9443c01a7336-244991333d5mr7043885ad.27.1755520118609;
        Mon, 18 Aug 2025 05:28:38 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:38 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 09/13] mm/kstackwatch: Add architecture support validation
Date: Mon, 18 Aug 2025 20:26:14 +0800
Message-ID: <20250818122720.434981-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-9-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
 <20250818122720.434981-7-wangjinchao600@gmail.com>
 <20250818122720.434981-8-wangjinchao600@gmail.com>
 <20250818122720.434981-9-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 740C8C000A
X-Stat-Signature: pn51rrt4xc7fdsmb1n6ui9qnntokn88w
X-Rspam-User: 
X-HE-Tag: 1755520120-678017
X-HE-Meta: U2FsdGVkX1+eHV9RAaNHALv8waAAKC2qnTV4aILmm3CELdbUmkntjrBH3yR71gGoRmM2JGi0zVDquDQnnH0koHsacZLkGtIlHRBvJI8OnaVfeNKuGpcjdeH7dveLeOX+wAXOW0zXMdbHpKl0Zwb5WxXK8tB9ZYcMthK1vp4x1vBEoIwRCB/2+rmlKYPeCa2h7Mkew82/NRsD1hM0LvLfrrKGAVHuTEKRslJx4d4sErRP1Y392siq9Ti9/hqJoEnm0i3pZSYAxYfE/YEKIYsUD3nTQuKwaGO+VqWc0UPcGpVVJG+xPyu+E4wNEUg6ZZoTlH+MxToUcAgcj3zb1qypp+n06gSKsOjgoTnNJt1pAhxv2tWJaPZonkEbSLnPiyytgPFH1gbuMtPR4hrdx+ah3sM5Cmz0j1Gh4BCNxhYjOB27K6TV0MYjLhU9Vg4H5z2Xaju7N7G7+8l5jbCKJhZlJ9ALAFsmWhahh+gTPyGFXOEdsFeVH3eUsxpqQ1TmIR330tLKjpSDTjDnnYpwUTftRwK6sfGekzJRHCfLlzq5vi77497e5zd5+uHFs7qGA8M4MHQ0XRpg2lIqVU7+5WukFp4h/EDdZ3G4TPeIfGNtRUuXPJtHoQpxtsOfC9sF2K9o/CIxocGMd1wW6cLEMiiaZ5QqAcuR7KaEHxPYTqtVQHVIIZTt9pCLMN3LKAd/U628IcUcEHDdj527v3mzPUo8peKkpLFwFlZcrggpmc7TWgZ8bA0R6lKcVbXEgYumOZA28a+/T8RMJ5KJivtMlqhizoDLFCV9V7nRRh3MvoNlZA55JzX0as/nrqRcct+PYXA3rL3ljXQFWXWdCI59SP1Pw6B8AXzV3kI8jz7qI6i66N4+2EXPv5R2DaZ5/KUJo+hexGL831C0eAP9hmhuV93ujnuQzc06ovMBaZf5lsPBM2nGW/yES2YpU2JeMub30pBWuMZIZZU6M1dZCNlz6Aa
 nIGEfMHA
 BMveITSEV+VMNDbJS82hYNmW0wyfseUXnvohhM2qmDfFGcInt/3lDLjqoetI+CXFQxLNiWvDiiW2DjlNlqxSVEdnm+GSCGUE2+5BlUP6yc1fXQl+Ol7FQrwdp1RJT92k06QvRjiY7q3PvzXNWYqPokoDsBpu3z+tBVIYVJHT7c5i7tIc73tTTwLAs17pHlaqdEpZdOUOT8P4mBhVn6SlpI8n0RpqhpWScDwCxrYcp+JpgVe2X0OAsKsN6OVyYSTEPyfDOftXChIEQGSb8IxGvqCV48cwFJWEtwg6zvvttYHqfpzneAU6VFOdqbhy8dSzQDouFuMl24AR8dZg9b+5aDreYv0KaONEM8TXWQtsK13qRFefDrmD8Mdb7+xQYM2zkTK+QF+sTiZ50FbbbrhBzzVQJXLWuJlSfpiKunomByTM/wFVw6K47TA2F0P8UbKm6GHCI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add architecture compatibility checking during module initialization
to ensure kstackwatch operates only on supported platforms.

Currently supported architectures:
- x86_64: Full hardware breakpoint support with arch_reinstall_hw_breakpoint()

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index b6366808e891..9f01e0222210 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -189,8 +189,31 @@ static const struct proc_ops kstackwatch_proc_ops = {
 	.proc_release = single_release,
 };
 
+static int is_ksw_supported(void)
+{
+	static const char *const supported_archs[] = { "x86_64", NULL };
+
+	const char *current_arch = utsname()->machine;
+	int i;
+
+	for (i = 0; supported_archs[i] != NULL; i++) {
+		if (strcmp(current_arch, supported_archs[i]) == 0) {
+			pr_info("KSW: Architecture %s supports hardware breakpoints\n",
+				current_arch);
+			return 1;
+		}
+	}
+
+	pr_warn("KSW: Architecture %s may not support hardware breakpoints\n",
+		current_arch);
+	return 1;
+}
+
 static int __init kstackwatch_init(void)
 {
+	if (!is_ksw_supported())
+		return -EOPNOTSUPP;
+
 	ksw_config = kmalloc(sizeof(*ksw_config), GFP_KERNEL);
 	if (!ksw_config)
 		return -ENOMEM;
-- 
2.43.0


