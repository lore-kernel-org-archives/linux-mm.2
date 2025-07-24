Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CB7C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843B98E007D; Thu, 24 Jul 2025 09:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4308E007C; Thu, 24 Jul 2025 09:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB548E007D; Thu, 24 Jul 2025 09:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 535228E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB6AC1603D9
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:42 +0000 (UTC)
X-FDA: 83699308644.26.5D1871C
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id E2A6D4000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ud6dL3n1;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf17.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365401; a=rsa-sha256;
	cv=none;
	b=qMWiCe694OW0YVvLDIrX8UzsuHhQDwEzmzpp/2qhXAHFhlBUOhxQVEDYAZZ5Lks8uDwXUm
	EOXDeow44qs3/I/b5cWouoQ1rBPgHXUQ2uK/U57J+x3LuWSfMGYu5zYViKKPJCQ2sYL/iO
	DlwY1gIxBWBABryi45JItas5j4uWlIQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ud6dL3n1;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf17.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYTWTc09XiaelzjVtYPzYhjlFtDK3ChqlxDovLkTtoE=;
	b=DQjQs7HQOEa+W6fNo8l61sNoYJsrafp4DVy1P6QcLNtRCZxh51aT2FIKpfAfBMwf7urv+3
	0cH3Jvh1zsX7wAAzqlqA5lm8dS1l37330pJFO5J9jrGuCrfTPrKvQn7DJLaRl6DbAdT+y0
	EZWuWNRyKFhieCu1G54oV2oxy1V81R8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4561ca74829so10973375e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365399; x=1753970199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYTWTc09XiaelzjVtYPzYhjlFtDK3ChqlxDovLkTtoE=;
        b=ud6dL3n1wXCHGxQ58NTZDJh4xaTaFyiDNkUCFyLDn9O5CMagfZARQVjiddljxBynL0
         ty7+q3slEhXqkRP/Ww46jSGduPGCfMDGf4G78ekOL03fEeiJUwil34tyPSAlAScDVV+E
         JZRceZ1LCn0uSiFKQQVg7fwjKNzcrcCK2ZMHLNREL4pvbkTLtC9aUaLPpN5KuNgO1wDc
         HkSVTZW8D91ZhMdTrUF7VG7AKXPWCSsD7taWk5zCYJ2mXXD4XnylqscNWqGm918eIyFp
         3R00bS+HJEjUBl/73qhRQ8ZWnGNzsxo6VFeCB4qeAnmc3XGowcTf3Xnr6Ti2Iwwb+Jfq
         YZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365399; x=1753970199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tYTWTc09XiaelzjVtYPzYhjlFtDK3ChqlxDovLkTtoE=;
        b=t/8j6LZxAtTiSBX1gwU1DVMwhkdWtq//PSCA8ipWkm5XFmArbowBCs7VRAsVoWJucI
         yqKDngDqVDAHzvS9TBrxuUvVGiLx3gikh4cWW8MSbOs9rvDhpHSJuo/E6/C7PAaN/6cz
         cva+ejMHELrpA23LUp5WQtn+APzBCZBbeOm3F+/BEaeoscKfneASukW75N0DmWRqpAGL
         tz+zIVZFzXvQhRt7KAORu/6GlPw+2UovGAFahBEAx/cS0wFbGm0uFMrS478gDAUF9Ol3
         upGXErAlmK8d30fHJc10RJM0f1dot4uAKiy0W9nRqBJr4+K7DY2mpRHfA4UZ9b/WAxQc
         s65Q==
X-Forwarded-Encrypted: i=1; AJvYcCVXg9dJdlYZmBEvTYVljGoBpArUlPUbSrXlML13PWhBi0NvFVpmiG1j7iR77dFUEVcWdTdaaS1Tcw==@kvack.org
X-Gm-Message-State: AOJu0YwkxHxEost3c1eAEe/ILV5U7ngMRJfhNsl4gE2dhE2tLy5foc8g
	PSYiZ6NGWZB1BCvdXKaUW2n9aCGzwecRc7ufkCydnOjRO6arNPVoL+M2nfZYchSVdV4=
X-Gm-Gg: ASbGnctx7wrMDldJT0wl83MBbfgtILa6xSPHGQw0FnnD+d4rnURz2aAzV8arw/BzGmr
	puFbv2nltCJi2Xi+aPhkvTsgmcoFrMOr9EJ4MiaT+v72y1220cCkOHsQ4tYw/pNGA68n3bJJFx8
	TM1miSJCC2YPZUXc0rPgNnwhIzF+yYMERRR0+ZmHaD0a3tKb9HUvoi3p4vRDyzwiukGBiIvgdhl
	CJXKfoAdafAjJqQTxYrgP+m4vglRG9fOuR8vHRSH9PNBd0/wqE+EXHwH2QMOwx04F1FRHL2+JNV
	graq2I+CCCFOpXxN9MxaLCv9VRpCy8qmMGMxiCz44coUdeuDiMcibNt+lnTy0QBvXlIS/uRsmPJ
	0bxb5/nS0BnPr9sZEWbrTe9GPhqwmpm+gw0RuDVlYDqbWV6GjogYvMFkbTCA1YJoePR6dftKeXk
	zZV5udTZdz7Y2P
X-Google-Smtp-Source: AGHT+IFkEigCZ6sJ1rjDkc3I8yrqrXhO4W8lU33Z9QEAlANeXLFiBfl+v0dIWKjOVtP26nHzmGjQhQ==
X-Received: by 2002:a05:600c:1d22:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-45872668487mr2491595e9.30.1753365399512;
        Thu, 24 Jul 2025 06:56:39 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:39 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 19/29] mm/mm_init: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:02 +0300
Message-ID: <20250724135512.518487-20-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2A6D4000D
X-Stat-Signature: 7scfscho5h3royx95u8gps538o55ith1
X-Rspam-User: 
X-HE-Tag: 1753365400-532378
X-HE-Meta: U2FsdGVkX1+ZSB6zM6Nz3M3HroGUR0laNCD4KSMjdNPMTLv9l+wowsNm3GIfNX//KHvCW5NaRfYNT06WFrtS3VK0wX0jw/glx6hJeFh3y9MVjTz0a10yIzItUdwIeO1FUyALiFmorDZk5GxVZjMKQ3UxFHWMfBJWRD9sK6B+k4FB1T6yqric+lNK6gN3CwEfRESPdzz0QpbYhlb3yjKuZ+AQ/dkcwxsAvQ7EnZjlq8Ep50DGsmTHWSHI+rkisIQUT/Fc3q7pI78+r5glxK4P/oYzkXlXkQj3ylSlNKeLs0XTsgyiG+LgmRkfNlCdyI1lgIQ2bxAxOlg5ynMVsN3sWhzsC+ftVvJAYxgVGf8CL5UZ7cFGg89ZuyMZD/w5Gtuz2/CRjX2vDPrZvCZE98XQUG1NLU7i/vI8WtvRSEzDqF44L0VWex/a0q1d8QajQDyPy5Q6dFeAYTswfcinRMsbcwV4bieXg/swxXWSVwdTlIXOWspt7a4aLwFCyhjhG60X0Z1Nlq9lSEipkKrWuIifus389jrvuBkgLdlONXblA9P7QRpi9fyYMCO9nQti+YoXgaZVcr2qgkQ8eYsSesZ8sidZ+/5Pu6QZNAQWsLDF/ARwuhQtDzk1mqGcyZZZKETLwez/MH1WW8DIuMrXlrfoQhFTOvjsacl1hWUJgY2GeJWvqhJ2Jw1vY0CDg4f6RIeD0KNGiSaf/Stu/lDr7eXBp8Z+sNWfDqMKz6wjdwUmCzlJgDlurgEPHBFmx30sgZUo/5ddcRAoe+lYzPnCO3OU4y8kiSXp9+E1Jd7toCyW6uUOOblI/JfnFHQW/9UyMMqB8KNKtV0rhA39VC0ka/69wPwfFFR4y665Badn1B1T6ThKHFBORnvXGw+OqIa2NrNwkzmyTepnjyXxU0IInmZXHHbt9rXH9RVYxIRtLx7iKLfMgtdW8FA0tO5MUyISNjLRc82AS4A3wYje9wfgE2O
 TJkNCraN
 FiutRQ2tIxEoFCsYGI1c96H7T57I1FMhCCF6rXnZzTxz8bGRg1OXaW4dvvBopO+XcZbeZF1G12KNe5hRIMZg/jmSUkJqpOR8BirnI4rt6hsaokRbn2j05vTMgZBl1rK2A8wNv1JIlNa8mfUsMdIae/rBWfPGPv1egB9H58pszloPiScugOSjxakiuu+wSqObdy+ILy5qPtmbjTbnZiyDXO+khEIY7zusIa2VDaUJaW8oz5XubNDXWPp306xbTE89Of9Xd9WOHt6tsj6v0kHpHz9hv7FV6HiafiAxfNAaMyACuK4YBy8k++PmkVujnvoSHaG82Gjqd4Ec61hjO0tF8Bq/rsUEZ4VagzcnuFVBkg1XzpK095to3E1th4ryGC17AEBE7ZC5dv7izVhRCQd69NDQKSRslhceMGa/zKBSp3J+Zj8gMt3nmD2iZS4xlmiPhYf4v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - high_memory

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/mm_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b..fd577f988f79 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -32,6 +32,7 @@
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/kmemdump.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -52,6 +53,7 @@ EXPORT_SYMBOL(mem_map);
  */
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
+KMEMDUMP_VAR_CORE(high_memory, sizeof(high_memory));
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
-- 
2.43.0


