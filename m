Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2DAC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1476B02DC; Thu, 24 Jul 2025 09:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FB86B02DE; Thu, 24 Jul 2025 09:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0EF36B02DF; Thu, 24 Jul 2025 09:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC7016B02DC
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A09FA132B8D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:38 +0000 (UTC)
X-FDA: 83699308476.29.2BE1C3C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id AB32D1C000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=qEyv5VQB;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf20.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQxVhQs93RF2j5r69/kyB3XsN/D2SLMeChyoBk7vwm4=;
	b=TRu7N7XLVYWV4QV9hUWg3p9WtdXwTtygZCkYW1X4s/4AbxG1FFhbbdIzCnsIaBs0mUQtH0
	yw+UYjk6RoZ2KlfoFYSzu+OwXEfINJt2lNRnrvJ5FkQtpSu/86yISIB6wVZS96Qt2h1Fok
	6IusxGqtsq5OCtBOrf+MXCtrhD7WKYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365396; a=rsa-sha256;
	cv=none;
	b=DAnNywnwFUr0rBk/yoEbfHREz4NYhDB0U7GoCJzPLWnzULtOpQwkwAuwwjIQaZdtgvAKLW
	LzF5B78R8+d/H9ctWBGOw9+lCkhMXWf8m3wA7TJ5Dwx1ngLQ759ZvZ7urEp4S8yfNAvm+M
	q52FnbCH0p4mnhFd2W2ySyxmSjRWbmo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=qEyv5VQB;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf20.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4563cfac2d2so10432185e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365395; x=1753970195; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQxVhQs93RF2j5r69/kyB3XsN/D2SLMeChyoBk7vwm4=;
        b=qEyv5VQBzhiG6AYaGsmUB3XlZPUJEA0RQwz+OgjpyKVcVHInfIslTAihQmF7Up7aVB
         QxlfWOBcXDSe9QOJhg5cCuxVmJdQwVtInd/MZJWn1YnantYkvAuyFbzKQC48ft8vIdRy
         rg7abuKVczMqBjLS/qhA7K5xOIo2/GBwiHGJvJNIsgHgAQ2rBTmmEBKnAnpHwieDuGRx
         We8E5MZbq8zFX+0Lgikp1DZmyOMPv0th3LSnveiIkUmPFY7P8JrBpGXe+8bzhareYg55
         44Nsg9t0cJtADURB70G3DCM/7BC2bR1QWk1X1tKWUdHvXhAm6ST/DxpD2NkSfCJgcjjW
         rNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365395; x=1753970195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hQxVhQs93RF2j5r69/kyB3XsN/D2SLMeChyoBk7vwm4=;
        b=vHN4dAI7nnPYuShp7ALFns/zmS9AUmDAeSfacPmRoK5eyVOuBCa3gcNYghb9TN5Ksf
         eFVWcjLphPN8BhYqH+X2XNpzd/tlyPUZUzrNr4l0AZz3IGE3P8rR28x5Qg1fpWrYM1WY
         kVKzdyiKHihfp9oUSRIHgS0rCT/kedVfVGOTQG6rWFwjoEKTDU9J7XbXDZ61FUbDbwr8
         pbnnNtiGiC0E15UMJ2DpHflbSi7lbG27R1Hlbp5gMvyppXvIjaDyyPcrb3Gy7he+E4m8
         HgJGUH/olP7TN5xL2tcoVijJ6XtgNVvYAeW8dRELL6pfQQcyIvQiQVT5SlOI+T+RwLRy
         yClg==
X-Forwarded-Encrypted: i=1; AJvYcCVlR1zK9hmWieYYSqUuMTO+mokpfgzhbpJSpPg1f4D9vmYC38tJo6EH4BmZkf341TFru4KnCmjcww==@kvack.org
X-Gm-Message-State: AOJu0YyqDcuwQrUSnOH4BUqktDxKr1b5ZsJVUO7IpRpt/TdDXCRyV597
	Fd+8YvT5HR/RqG53httig6VDyMAZPTncGabcDWMGIFGZHLaqlEz1csUZmL/qh/DVLQQ=
X-Gm-Gg: ASbGncu9gncna9CPFNix7P9CO2BKv5Ut9ngTNMMCffqXGdkuumt93rP9f3cuAS70xq0
	T4Vz3f84h/ysvz/X4+8OhxacBPOjoPcdYU4OKaFqTkiNlXKi04DJd7Wx2IBjKVMfyw/a5UlJ2dJ
	De0SKbnOWgNuyzN/M5QZTe6cJGddNT9boDzgRX/9lwZKsGumpmzJRsrb402GlVWswwdb5P6o7Y2
	QYrZuvnyJi1oXqhzb4RmwLJA8HTgrWogM9IbxYlKRfTqWzH1x/npvnkyRz7x0b+SortivRfEy5b
	uvI/OhS6tZ8i1wxQFfBY7uVnY1ihQBKGivinFi6uvdGIBymbv68KFx5/EN0miGNZBlxeTMrlVJT
	yRa8kAVkS5xATvzr0Y95uk3Gcj/QXvylb1HIM0r900mktWqKvzl3fkXcvtGsYKrFUKwShXqKWuT
	c15jIyhb19m7qi
X-Google-Smtp-Source: AGHT+IGhn2BhSHWFDoozkG8rL01GLeqFkYg2AyJwTWU+9+XF/fbe0VNyrElgCTmDYeBHx6jzMQbcKw==
X-Received: by 2002:a05:600c:4e4e:b0:456:1bca:7faf with SMTP id 5b1f17b1804b1-45868cf76e4mr72058865e9.16.1753365394813;
        Thu, 24 Jul 2025 06:56:34 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:34 -0700 (PDT)
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
Subject: [RFC][PATCH v2 14/29] mm/page_alloc: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:57 +0300
Message-ID: <20250724135512.518487-15-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB32D1C000A
X-Stat-Signature: gshmtt8b74n1gnxcoubxixjbkg5rommz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753365396-198583
X-HE-Meta: U2FsdGVkX1+fm0bofmB5UE6HkCND7TqfbdBufLNzjNyypgX0+3wBiYXwmp0i61XEiUhIK4X77Yrfxegj3DRkJ8wO56WOE+Ulm1Raq/xbf/juJ92NYp/gILvYJzUiNEVIsQ/pK8zuzV+BYmWmJnRmHNhfyaqHk96Gr+UTXHLW/U5gmjYbgHWGZYVjrlIRAfaid6D4ssDrVUfpFaqpx4EkW+X5sCx3uAgllRMgAnjX0OBMk6BNmbtcK7c4PpBS9PhfrEPlR/l/PzHV/w+7sWg4oI0sdy84plIxQ2g65XaGB8h0Jp+aTbLKcFkt+SSYBsnKvkd2mJYepTOf0mhojzkeuKjWB4Z1qmaJWrItU2KUBZH3JAFdgBw+n2+ClGnLqk1MqFC5BmHnMXQQCGlrC/zBM/PZXkpfjdDMUsTEfrwpAnM0yDlczZxW6+QIeJtehSJEo7wU7B5SMfpCXJR7MEGoXFlTbMd5gd9bpv/gV9f8BdZcuw1v/m4fhmlb1reZ6McZKaWdLK/xF5NC2S/Lu8MNjpgTGxMpoaqNbjcz/gFwi8rZDJCA+1lQRDfFzM3VG+cS3uVCSMjC788IR9XSftu8RAYtOHD+YvPsRt0z/brHO5nyQlRhLweno05gILa7ChisnEOLGLOuFLoFFSKTt3js5JH6sqTbia0kjB1vOetpARh7yJx2grSeQqq7BDphWirLKsWEl/DNMwvnePpL+846/fNL7dxYTQYtd4vQtfz/d97lr5gPY5MnmwCqLJAzWNnaZos8QfdLCXYCLbq+YR/oRUN9yGAqDgvmlTN6XpqH57h2vmvTQ0EzaQIJCqWegV0MOr2epgQU9Nr6KCDOiNjZNxtXbWKvGoCoGsDnxLEOWGR6jU9+jc4Vk9PX/9oODDwt3zG41673uGL6EsezvVkhG2NyjSxxh5zT6gQMKLsw55+51uQS++QWtfs/4CsLWQUq2f6FpuHMjErVtgBhydt
 mBtDx00x
 ytl8hQjRQaBqIj3/wDv8SGd6oiYpm9x7i6xOsTcFoeulzAs4lTHcSuMTJpfk7aYSzAdnN+MsPpu0CdrQKZ+TqOBFqqzY/E/eJF0ZtxUiF0SNUjd1W3dEclnGg967Gc57pCCTmNvpmSX6A7Gsx8A3mtl+yo2i6ksvxk45IoRDaHrFvZCwap1mxnzSZxAgVQ/ORQrWfmDbm60hdUORuxVuSRRLccIHhUvsMK2WQmm2tf+27JubEOPJyE9XeT+bpajDjtf09BzU/Dj4QwQYvOz6zcXgieXeO9Z7ah8fwCqWMb81a4nMGVky0qRgpFzX5xD6f3VvQ8KF4FOBgzolSyRMtEo3BDRwH1vI2k6drxsTcIhwan3cra28w4hw21klRmM1RGCQJbLkN0rx8rsSAKR4AATeJAD2Xhlq20pHejP+ZNkwOeJSjpW77zBdfWLZQd48HYxfp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - node_states

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fa09154a799c..5f0015e27a30 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -55,6 +55,7 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/kmemdump.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -207,6 +208,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 #endif	/* NUMA */
 };
 EXPORT_SYMBOL(node_states);
+KMEMDUMP_VAR_CORE(node_states, sizeof(node_states));
 
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
-- 
2.43.0


