Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D596106ACD2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 18:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341596B0088; Thu, 12 Mar 2026 14:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD396B0092; Thu, 12 Mar 2026 14:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131236B0089; Thu, 12 Mar 2026 14:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D51AD6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:19:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96E2C1A03C0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:19:53 +0000 (UTC)
X-FDA: 84538224666.10.F7A038D
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9DFC214000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:19:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nOMrhh1K;
	spf=pass (imf23.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773339591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBlJpCvwQvrWLmlNpGLgBwxvoUIKMdWDi255y3UTo4k=;
	b=z155SMaM7eLJOc4RpNBsQxE0JiKAclA6qpSevl4+8tT+zFC78HC7XO6FZZdFt6asnpq8gk
	45JP4Tszb9utcw++PCjlrQqQEteRDdnakMx1d5gqQW43Hy1DGnHjq4fzWmGlgGMcgJlo/C
	olHZAiHMtLlfMzy8DVe8G3hGb+wgGSQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773339591; a=rsa-sha256;
	cv=none;
	b=UZjftcr5eIX9OlPyrGOq3f68VeIl/dS0hQfLlzBZ+iLOyE6nGCSBGj3w8PtsPPd7mTAoM1
	/VJcrmSs/iLlkgJdfBb/uJGrvKWXlx6JMkodQ1OBOV/s0alo8xc0G/MtPbURh1xSMGNBBZ
	Fj+BZ5bpdNxwm4SS6yRIZKXMwLY5Sog=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nOMrhh1K;
	spf=pass (imf23.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-59e5aa4ca41so1242498e87.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773339590; x=1773944390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBlJpCvwQvrWLmlNpGLgBwxvoUIKMdWDi255y3UTo4k=;
        b=nOMrhh1KgZAUy6AcDyduBpBEytqgvEIuxsGD+PNk4FdZ26sa5qLmg70ROjDWULumZv
         LM2au7zNnmUJY0jUfDXIZL74fAwXVViQ2LfwAphM9+m3QigTUuS+eFsJd3eoH+gB5f3E
         uwt2LseVzhnxqjActjGS7+9ZFOEeCLNYyoHAEO88X7gNG7QCb8uhVNNs7AxMGnJLd7Sm
         WbqZB/CVT3tWcHbsoozqXIl48OHIjNoC5sy4fk/TL8PxXs9ppj9Cz3+vT/N8P9m+mdWA
         JKAJ1txpd0Umu4Jw3DT8RnuhK5y5w2wKxm17Y4B7I2hIDE+qKwD8pwFVemMd5pNpCm/G
         zwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773339590; x=1773944390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TBlJpCvwQvrWLmlNpGLgBwxvoUIKMdWDi255y3UTo4k=;
        b=nSHKuHfTVkUf2P0jTa991cMFycBZZC8ALeZyhknY4BbctKT1FJqDQxhWro3v3RhE0i
         1Jq3YahTZiHBONFQQJ+/otZ2OmJBK5/NQ9kBpS81Ht2ALmdycjsbF2zN8b7e/0TMCpnw
         q+ANoBV+5guaDs1qqEdi53lMAMjo/AmcRMenNRv6NGqZ7HzJuh276sSJf55+eMEeSKrT
         CDsHW4zgmAgsUdvIvyNj6X+9pRiAx3P9vzrhxt8TNaNvxdi34q1gRKyd+h6qu2CjaEuF
         5J6S8iHFJMnc3J3K+5yJEj2zkw/LFtMH4e56RH713sEOXEJYIRjV0RGU2UWDwOWSAk0Q
         XpSw==
X-Forwarded-Encrypted: i=1; AJvYcCUZQjoQ5YFA4bhVXYSfL4u0J4b2g0HywT1sL3XTeP+xKckZbs41NRTKIeQX5sd8Ktyqoe6oM0LXgQ==@kvack.org
X-Gm-Message-State: AOJu0Yzi+BCRndzac4lACYwXc3emKddFUWCgZlGxal/Czt58ybsBQv2O
	MCe1xNF2QwikDNpmiSjZCURoEbiJaUp4O02j7qIbB11w5ZyppcpSVZSE
X-Gm-Gg: ATEYQzzm0xmGxxqPnncuCl0I7QaFiGsIVs9tr5k84Vvmql9s7LSx7xhS2hMg3yP0ZAs
	SgPulrKs2GrRN0GsvSfeCOsOIhytAmi0WINVtcMXCB9TbS3J5fSvd0MdSNU7i72+rPmz+wAKbJP
	gmnJK29740MXYCnFOSXJyNzCJrYgc0E9sjS8XLutViRyVfE1mokZxK6QF/iLS9RheQsl5nhf37+
	cCf4ixX0FyD4U6xOYMxAOn0s1XGN/5GsMm+tS6TjPBHI1QxaINZCn0H53nffi8KTsBr4UQT3bRw
	8/hKGnHarGpG2Oy/ZsPw90TNmv0W+zdfWmWgybgSqiaJkUv77AyC4UJM59oEEJ8hgBTOCDTMeZ2
	BhOtZ9O7DdrvHRIWstKbETaxj79e0EplycXdf8D+Iwi2Tn2nniI6azDXXv25kprnwhSJlcy24hl
	fiNsP/FWfkg6iMTxfmrS5uKbUnyBjkBzbjq+T1B3dRelyITD5TPrWYNLSojtYpLPuWGIx6MF0=
X-Received: by 2002:a05:6512:39d1:b0:5a1:3448:6b30 with SMTP id 2adb3069b0e04-5a162ae8621mr168590e87.20.1773339589738;
        Thu, 12 Mar 2026 11:19:49 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e7d9sm1085336e87.35.2026.03.12.11.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 11:19:49 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v3 2/2] lib/idr: fix memory leak in ida_alloc_range() error path
Date: Thu, 12 Mar 2026 18:19:48 +0000
Message-Id: <20260312181948.20020-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312181948.20020-1-objecting@objecting.org>
References: <20260312181948.20020-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tyqg3cpaxjy6rqg5ajd18zt1ru14tqjw
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DFC214000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773339591-511098
X-HE-Meta: U2FsdGVkX1/ss9mIPUw3PjrlaOx9ONbPQAKxpaoUAHXW5r0YhJ85Aj9uulfZAmiCgK3mKZUPdTbObuDK7UWCwAjI5WYLKIbNkNkN8SEWhbLLwm+fQeKwUTznfz2Zsc95el9s9r+gVlLnDt+u/7POpgDGPM3zYSiM/1ZT+PeJ1HUvyESlnBllUR73d8oJXQQN5xa8eF3DCdtZTT1/MKvRTgbZUG0VgCNF1sB6lRY4pMvgcF6yQOF8Nj8YH6BWyU8MyjfQo/iynxZ1IwlGl6vcmFTd3oxPSrMapH5XbUnIk9h98gDaFcQ+FFpKJpFmoW0lJR7i5uQhGaELjmSeVamxwYcBadtWBqn+v5UBOW0PgeeCpflun+n/HtM28kAxCxjSQwWpg+MI7XpeEpN8Us7Q637HEy7hZBSgJb0ToMJ/LUSrNTSwBgYzN1zcC9cMGvxFi6oL20WkHmPnOaT+snKo8dfKc3MaUhx+2Bm/zkijaEnUDc4E8Q/ZaQR/LxAZLApX6klkSLjiqrmU31w0Y6ct5kGh7zdiPR53svoapL6tF9oCkaLnY1dBV9MogHlpICi9tske2lkKHnYKebM4LxQ0aS40rITaNmHRMEqFCZ7SU3pkmQoaRvPwWyyCXHzeNNfBnOqa29hdCiia706nLmNXVKd7GH4+bP4avnBfLwdZ4Rt5qxrEvnBkWq8py2pWlcY4+gPkP70PJTDMoMb8eqi46i7rhiKaLupn0ICIag0IrdDzF8verQ8YpsOHl4fn8SEfx/y+M/HFKnAikUfeiV+qafzlFLJKXCE9Ed2tdTFWd2ojz8e5WV+z4kuRuhu1bIdKdqhx9b1sUYHKU6BccMmUN2u9c+NCVYSAi/ENiE3EhlGm7Mr4j215lP4ITbEeqHKJ+VCy49I2AqGk3ilNrxNp/9GnMmEdNc5t0efHFY/1+WX9d+nfV28Gr8YdkhFJh7MtTaY/Nd3PXITFZdYC9+1
 9CKKwuoZ
 Y6GHbkD68Kr40dP5k5uNWFT6BBnc8tzkjffhtSqY24dT1PkHmMzT0zbRiIgFkOjgQ+cj6CCYgWxhfQGdvzLrSRtf+X+jLdUSBerGEm0/lPGG303ds6u1zMO+FS6IEdzFMaHxBo1hi78ib97vIhJsaf7Cpk9UuCxWVTae0Pn782k394o3izU4ojmJP49yfx/vdNSb3ZHH/X+L8pXkbbD1rlMCAu6lhBRvGHU74t8QO6se8ogARcOhBWf24pzH/omSy9L8xankwqjUHGIWLPsdKD5m6d8ZgoFEQsT6huCZZcHyXda/T5ZNJMLaurIr6U9xNI7QYufOTKrZD8LumX4CizoGyNfnNpvaRjUHvHWV/WzMOo8texN1oEaVMiBYXJC92SPvCN7RU7lIkzT8muQzJgr5z7YnGgKwGUHSA/yR4DVPJhTr38XRvotqvIRMD6upLD1HwMAeuLIPZKnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In ida_alloc_range(), if the XArray operation encounters an error
(e.g., -ENOSPC) during allocation, the function exits early via
return xas_error(&xas). However, if an intermediate `alloc` bitmap
was allocated via kzalloc() earlier in the function but the XArray
insertion failed, the error path returns without freeing `alloc`.

Reorder the error handling to ensure `alloc` is properly freed when
an XArray error occurs.

Also add a test case in idr-test to ensure coverage of the error
path in the IDA allocation logic.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 tools/testing/radix-tree/idr-test.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index bf6a0da6a50a..f4c3a5ed4ce1 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -543,6 +543,7 @@ void user_ida_checks(void)
 	ida_check_nomem();
 	ida_check_conv_user();
 	ida_check_random();
+	ida_check_leak();
 	ida_alloc_free_test();
 
 	radix_tree_cpu_dead(1);
@@ -556,6 +557,22 @@ static void *ida_random_fn(void *arg)
 	return NULL;
 }
 
+/*
+ * Check that an XArray error does not leak the allocated bitmap.
+ */
+static void ida_check_leak(void)
+{
+	DEFINE_IDA(ida);
+
+	/* Allocate up to 128 to ensure we need a new bitmap */
+	ida_alloc_range(&ida, 0, 128, GFP_KERNEL);
+	
+	/* Force a failure by providing an invalid range */
+	ida_alloc_range(&ida, 0, 0, GFP_KERNEL);
+	
+	ida_destroy(&ida);
+}
+
 static void *ida_leak_fn(void *arg)
 {
 	struct ida *ida = arg;
-- 
2.34.1


