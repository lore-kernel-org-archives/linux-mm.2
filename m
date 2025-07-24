Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7210C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF728E007E; Thu, 24 Jul 2025 09:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2EB8E007C; Thu, 24 Jul 2025 09:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0EB8E007E; Thu, 24 Jul 2025 09:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8F8D8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A80381A035A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:43 +0000 (UTC)
X-FDA: 83699308686.30.FF17639
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9AAC120002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=moDG5beF;
	spf=pass (imf29.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.43 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ay6ISBVXr4RhwBg6A2t7OCdYp+NqRXGL2jP3qh5ffs0=;
	b=j+hJJ/7N+t17IqTOhcMLHtmPZKuoGEDdsvzbPn4io6tV9ElJRiGLlOQraNmnwXrk6Egfx3
	2qcJ9kbXurqRGUEPJLqcv4aYGSkq+fL30FQiqgL+0/lzI44pWhuxlOkZ44K4Etgqj98jk0
	ePsq4Ilek5ZPn82v9T3pojwlo878d50=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=moDG5beF;
	spf=pass (imf29.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.43 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365401; a=rsa-sha256;
	cv=none;
	b=Awsue3gU84ltnxQHvM2WxU/HyLifj3dAnORIbEojf4oNvFFhmtIkFoBWJ9nyiPKLMLM4XI
	1PZh6uDAQUFLps+OJwZqiTiusb8ZU7M9KKnQGlM92UkokDUmK2m2RS2YHoLx7FwYrjZ97u
	7MGKOjs+5O5UYOkU5AZi1Zapi5U4AOs=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a4ef2c2ef3so809558f8f.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365400; x=1753970200; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ay6ISBVXr4RhwBg6A2t7OCdYp+NqRXGL2jP3qh5ffs0=;
        b=moDG5beFlvNfp8Zs8fMaWv8CAXBjre5ZJV832IlEXmbSsGsY8JXOp1lc29GwdDBIrd
         DD2cdr2priH78e/m1JmGHiJ0rxmGN+yyxSAImi4hTcWRvNuluOTcYfbvKcFxaSDwWHSI
         NB9nnfjVfSmBeC9Aw7O42MvT3aUs4vgs3Tm7t3cFh8L7ZHDZugwkw1L0LPDxPb8SJiEd
         J1tA84TMkJ1LA8i5QCrezKYTy/4cY7NenkyKfRYSG9U+hPKYokRAVye2ADSRked3Ujlv
         8Zp0qIKCqyh/DMsSLpPWg5AU8IjKfGeAw/mJNh80eD1oLNmeHsKTKw9AdHvpU3QKIGew
         +tnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365400; x=1753970200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ay6ISBVXr4RhwBg6A2t7OCdYp+NqRXGL2jP3qh5ffs0=;
        b=g8cUS4VkM1z7KrtWp9Y3AawwmWxsEdXBPs4gIUcl8RimqKjpo+CErEI9BIV+2O2YVJ
         rmhUuXESoVFCLl1F5KkaxbmhcLVsvywi1RDs6zxe/JiB7zWNcE4lfQRrktPTlc4Wqo51
         FwyvNerKLDBVhm0tdgmNGdsdaV9TksdnI5mkjj3ycALjENhH66emqiCyzGt/20+/+Hfz
         NOWm43p9iXXft3agqj+gBqVDjVgqNMNuH8fMsbY3miDp7Ga4PV4VKr92FKc+XOYZp2zg
         2H1PnWsvHnDI6g2rqZ2DKufjFnrgg9us3YxWF8e42XCRoX9nFPUIRHhc2vkZQZKIknEU
         klzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCM6qdUDeGw4VQiM21QjyM/Kfmo9EBwU8/Aje76+W9rDh7gAi05kZ4u9xak4OWPX+JoJpnbiaMRw==@kvack.org
X-Gm-Message-State: AOJu0YwNdxbxQXigbVCmOQi5fWqhOFO8pA0XVTd7FpVfTXEF4LZMJ9yh
	eUNlKSaXAUcGopIUeoEHx6w4j+SI9vYwURV04xYQnX5fT+27uEqrsEJMrHMRGbvxR+M=
X-Gm-Gg: ASbGncu8e0IvQXAKpKH7EigU+6dYLWGI80nm8VXtI8aCaMY4SXA7gR8IrYSBlhdI9ym
	r2YPEvQJuY2/JpOsRp//aQ1j2C78ZpSrDbHKOPBYPnbObg2ztR1zF1PKetUYgPyLpLFGfdR4+T2
	fUkLRqji6eTCYfLN5pT5+hZJA4Oql4nuA57qfFT/Av/ATovJx6kqFy8b08O5EkrPiMTWfb24ycE
	aJgURbY4gghTb2M52kGXpt50nY6kMfGsbM5RVFLsWpYAD+Ye7cTrpO96/BIcNvAJDl6gUgQY6bC
	x0wRnHxF0VKAkqVhDBQot3aCmfby7rdyYAkihHlHcxr4v7tFcQI+PLpSPUgDBKfDVUIBSXj7qGi
	M4SHkP9qXnMWb5vAiJsfJSK6DyrvLR23PLIwPdDU0qGx8VLGsYfKDyJjRdbzYAnBPHoXHk++h3w
	+aDrcSYNsAcxUl
X-Google-Smtp-Source: AGHT+IGCkgT/Av7S5A2E0I2QQdMK0eQR1KK2t84reKZkouB15tDDQWfO+rh0+B+shYiLiz/J/iIBUg==
X-Received: by 2002:a05:6000:1882:b0:3b4:9721:2b2d with SMTP id ffacd0b85a97d-3b768c9c202mr6498976f8f.9.1753365400320;
        Thu, 24 Jul 2025 06:56:40 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:40 -0700 (PDT)
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
Subject: [RFC][PATCH v2 20/29] printk: Register information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:03 +0300
Message-ID: <20250724135512.518487-21-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yezgtii1srdgkb79bgc7iud4e5i49mka
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9AAC120002
X-Rspam-User: 
X-HE-Tag: 1753365401-665779
X-HE-Meta: U2FsdGVkX1/mr9sofBvYs3cRW7fn/gBv/nr2yFydkTKuqyPh15MUfnw4GzGONzQAIVyiuLwzOjyhhpe6UfY2qmWEdS+vVZ6fc5JOWhwerfirvw5OY8nCP34NTIbl2bmePTvEa/+QaLAm6xpOB2njlOj6GWQukmlkvokBwhbWVhTMsQby2DXU6YSq2ff1+PWLxs1C06Nhy75YSsztQOiaOtyg7FW/BTfNCf4pttg2TNGqHhN9+57bF5HPrBPqofaIqJpD+azqJC3rm199HAtLoxyJZph+fIgUeuyh6kewNd8QMZAWtucMZiRrXi8ps2awvbeY7CWk75gBxJosk3aQyJCu7FN+mVKX7a9hqB+u/5rbBIDFvOY46WK99ckkLBahW+ixnLn30yTvFC4nVANRuZp/fJhvqXEB1O7jCueeiimwPqtDgCmVKg4qBTY9sfHyUHIaFYLVgx4FbdgK0HlR80zam3F6hhzGH326FpMYB/plxWfgrAsEa0QDKxDbYYox9lPvEKHasGffRtqCrbO9HLw1Jy9gNjobjnnsUE90hzgwr3p987gtMeLOneQP7eDvdSUiO36w9hc66EJIBjmTmlCQQQw8UIh6O9AonS931Qr0/nN/rgGoAtHZMykje0jEsWNhmaMWJGOLuZM4niwcOQ0yXcxGfUychTC0pF58lrC/Me7LMPtxPbXUcUoOx9UEw28Z5W/5U9mLnLNXPKUfXAs7O+UtzF7XeFjHOJpQ1gx0MUWy30fRr2QDp5f+MFd9zB6NTryUFsGUTEvRL1Il3tHwZz3i/oMkftnk2O31RIzAOpzBDA1C74O3b38/OI/ou1JzZ2io3ZYGTvdZoopkCNqPDC8HzBrRcXDWLVIJ+ABVngLjAgUVD8jTjh2Ts4QXujNqh1DoYtc69lBJFeOYmFA+n178SWwq/oXeqFKGl+AjiEZKcXZ1g1DJL1PF6PU8bjHWEc8j6Ok2Ejef9vm
 /deRWkU6
 6K3E8VpO0CXmkSA7v56BP+Hy0XlPwyhhIzX3MIGcxiVCOevBXyksQTiDe/RVOvhRoYJJU2aYpoJjYIED0Gu2qfr4SkQVeQ+il+akDkXZaK2QZIqeX6FwsgIETCClUhleTZOcigXoRYKbaEQhvmap2DchikPe5hjUHcbgjvmMpSFuZAGxoIcYmcE+zTrMGp9vh4W2O1N1Tc/1qDZ4Gnm5220EZFaRPeNYT/bP2pr7L43b0dCkf4BwTwX8iTfC4NMm6b+B8q7FjkPlhOQU101hUo2yHofKu4VCN6bnO2iO+5bagROvv4rhfSnf1PwC5R4LVLP+P2rzub/AJ9hEMYaF9+FO2mxYS6DSRRdTsuLBxxziUcD/D7eGRtyn81yS+YNRkKNBrZzFvllSdycc5Zhe5ey5H+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - prb_descs
 - prb_infos
 - prb
 - prb_data
 - printk_rb_static
 - printk_rb_dynamic

Information on these variables is stored into dedicated kmemdump section.

Register dynamic information into kmemdump:
 - new_descs
 - new_infos
 - new_log_buf
In the case when the log buffer is dynamically replaced by a runtime
allocated version, call kmemdump to register the data with a replace
flag to remove the old registered data.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/printk/printk.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 0efbcdda9aab..f7d60dbe5e5a 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -48,6 +48,7 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
+#include <linux/kmemdump.h>
 
 #include <linux/uaccess.h>
 #include <asm/sections.h>
@@ -540,10 +541,16 @@ static u32 log_buf_len = __LOG_BUF_LEN;
 #endif
 _DEFINE_PRINTKRB(printk_rb_static, CONFIG_LOG_BUF_SHIFT - PRB_AVGBITS,
 		 PRB_AVGBITS, &__log_buf[0]);
+KMEMDUMP_VAR_CORE_NAMED(prb_descs, _printk_rb_static_descs, sizeof(_printk_rb_static_descs));
+KMEMDUMP_VAR_CORE_NAMED(prb_infos, _printk_rb_static_infos, sizeof(_printk_rb_static_infos));
+KMEMDUMP_VAR_CORE_NAMED(prb_data, __log_buf,  __LOG_BUF_LEN);
+KMEMDUMP_VAR_CORE(printk_rb_static, sizeof(printk_rb_static));
 
 static struct printk_ringbuffer printk_rb_dynamic;
+KMEMDUMP_VAR_CORE(printk_rb_dynamic, sizeof(printk_rb_dynamic));
 
 struct printk_ringbuffer *prb = &printk_rb_static;
+KMEMDUMP_VAR_CORE(prb, sizeof(prb));
 
 /*
  * We cannot access per-CPU data (e.g. per-CPU flush irq_work) before
@@ -1211,7 +1218,10 @@ void __init setup_log_buf(int early)
 		goto out;
 	}
 
-	new_log_buf = memblock_alloc(new_log_buf_len, LOG_ALIGN);
+	new_log_buf = kmemdump_alloc_id_size_replace(KMEMDUMP_ID_COREIMAGE_prb_data,
+						     new_log_buf_len,
+						     memblock_alloc,
+						     new_log_buf_len, LOG_ALIGN);
 	if (unlikely(!new_log_buf)) {
 		pr_err("log_buf_len: %lu text bytes not available\n",
 		       new_log_buf_len);
@@ -1219,7 +1229,10 @@ void __init setup_log_buf(int early)
 	}
 
 	new_descs_size = new_descs_count * sizeof(struct prb_desc);
-	new_descs = memblock_alloc(new_descs_size, LOG_ALIGN);
+	new_descs = kmemdump_alloc_id_size_replace(KMEMDUMP_ID_COREIMAGE_prb_descs,
+						   new_descs_size, memblock_alloc,
+						   new_descs_size, LOG_ALIGN);
+
 	if (unlikely(!new_descs)) {
 		pr_err("log_buf_len: %zu desc bytes not available\n",
 		       new_descs_size);
@@ -1227,7 +1240,10 @@ void __init setup_log_buf(int early)
 	}
 
 	new_infos_size = new_descs_count * sizeof(struct printk_info);
-	new_infos = memblock_alloc(new_infos_size, LOG_ALIGN);
+	new_infos = kmemdump_alloc_id_size_replace(KMEMDUMP_ID_COREIMAGE_prb_infos,
+						   new_infos_size, memblock_alloc,
+						   new_infos_size, LOG_ALIGN);
+
 	if (unlikely(!new_infos)) {
 		pr_err("log_buf_len: %zu info bytes not available\n",
 		       new_infos_size);
@@ -1284,9 +1300,11 @@ void __init setup_log_buf(int early)
 	return;
 
 err_free_descs:
-	memblock_free(new_descs, new_descs_size);
+	kmemdump_free_id(KMEMDUMP_ID_COREIMAGE_prb_descs,
+			 memblock_free, new_descs, new_descs_size);
 err_free_log_buf:
-	memblock_free(new_log_buf, new_log_buf_len);
+	kmemdump_free_id(KMEMDUMP_ID_COREIMAGE_prb_data,
+			 memblock_free, new_log_buf, new_log_buf_len);
 out:
 	print_log_buf_usage_stats();
 }
-- 
2.43.0


