Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A1FEE36A0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 09:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39476B0005; Fri, 13 Feb 2026 04:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE76B6B0089; Fri, 13 Feb 2026 04:54:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6536B008A; Fri, 13 Feb 2026 04:54:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA67A6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 04:54:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 748428BA5B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:54:19 +0000 (UTC)
X-FDA: 84438973038.15.4170261
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9319A0009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:54:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1Qlumhvc;
	spf=pass (imf15.hostedemail.com: domain of 3x_SOaQYKCEAinkfgtiqqing.eqonkpwz-oomxcem.qti@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3x_SOaQYKCEAinkfgtiqqing.eqonkpwz-oomxcem.qti@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770976457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LFs1D2cDtd6f/aAyQgYmfXZj2j/U+wImXIancDSX5wo=;
	b=JLpGMjzAvybs8YL/drfqk6quuF482lXkSqui+fcAa5JhFVrvJrXINC7XBW+EE/bX66946f
	a/m7yluXOKzPnbQ9/Emt9MRsi3iRyJP15JmGeeLcjJCkn33E02smC3c1HO1s/Ngvy4MXYZ
	rJNR8Ok1fZQylFCQJEcGcoXhZU3G2P4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1Qlumhvc;
	spf=pass (imf15.hostedemail.com: domain of 3x_SOaQYKCEAinkfgtiqqing.eqonkpwz-oomxcem.qti@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3x_SOaQYKCEAinkfgtiqqing.eqonkpwz-oomxcem.qti@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770976457; a=rsa-sha256;
	cv=none;
	b=XC6rfXI2c3J34BGHHd75uXD7erMZBRqCmNpXzHE3ZVEseT2Ij8h0xOB304muA6DDmPigIT
	FUokmPjcGXwICplXoCP3vSEOIAxk1dt7TKnDU3DoyxbIm/hB9ZxuEFuGSdwkWO9j3t8mDK
	WgvUok2vy84FUvVXh5vXqygVF4r3v+Y=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47ee432070aso5230595e9.1
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770976456; x=1771581256; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LFs1D2cDtd6f/aAyQgYmfXZj2j/U+wImXIancDSX5wo=;
        b=1QlumhvcCVUpcc1DXRpGrekjhVp4lXtzRSCTaaaf2SjnfB5/pDFW3lHRtXI+xu80qc
         ccJLQHhIEZE3JdntEGLAyt995IEczFMkrhtWN2g/GV9vcJR2GUqnXtTmXu89Udp1MzM3
         fDZtWBDP5eRgcunsEWZowitzdCKHwv/brgeSfNC92OVAqcedX36jJtQqIKAs5McdesaD
         h75D/klhX59dHBpgG7h+kwlFUoDn0GhcfGyvr5etBCMTWcbXIJVoBe3D+kPxHzid060q
         XHBAYWU0nmg621pixW1DHwk8LslzvXkkL+WXEQdxuAcdYf4aulisN4IAgNz/5k1co4gA
         h0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770976456; x=1771581256;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LFs1D2cDtd6f/aAyQgYmfXZj2j/U+wImXIancDSX5wo=;
        b=jZSPUJHUSNx0kcYJ9dHUYzP573ILVZOUnuEv6A/9tPmMWYJuozD7LlVAxxMZuRd3RW
         2/FO0MLJvumFGUO2jn9y0BwoCSOX99r4P+i2gZIDZkkqbCfn2OHlPI4yYWQHL2ON4RdE
         NQ0CFlNnkxK92SHfEVN/VXsRacAFYssdvJGYoYF1jAAJ0LbdICCOCNgRKLEGvlXwU2st
         IvQTbapzhqW6Vmw9kfnwoa//SXIlDFzr69X625CVYyg7yXnM3ZN9XqJIZIUYFnd4ANwy
         AkqxyXpuDzje+pEUenP4V+pJ2dvy8j987DeN9xju2hVt5n8Le9nJnnh6pSc9p7JTV6BN
         WtGA==
X-Forwarded-Encrypted: i=1; AJvYcCUfxBLggofQKL5gXSs7cJeA3nUo2odUGL0RxblDyRgVBKuDwtJ2junsIVmJxGJEIoV/lBDuAw7LrA==@kvack.org
X-Gm-Message-State: AOJu0Yzb+o3Z1NpXXQiDMgb7QJRV1J8svrimzLX7xU/R5J8s7+xasGRZ
	7Ew9VscwtOq6FMlcDkPOvPW27tdjRADzo4wmXuvJlHy6xLI6IVMjDuDBkNyVFSCeSXY1Ui6219J
	ZCOO+5g==
X-Received: from wmoo19.prod.google.com ([2002:a05:600d:113:b0:483:6a60:3501])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fc8:b0:47a:814c:ee95
 with SMTP id 5b1f17b1804b1-48373a234fdmr19866675e9.12.1770976455591; Fri, 13
 Feb 2026 01:54:15 -0800 (PST)
Date: Fri, 13 Feb 2026 10:54:10 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213095410.1862978-1-glider@google.com>
Subject: [PATCH v1] mm/kfence: disable KFENCE upon KASAN HW tags enablement
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, mark.rutland@arm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, pimyn@google.com, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, 
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>, Greg KH <gregkh@linuxfoundation.org>, 
	Kees Cook <kees@kernel.org>, stable@vger.kernel.org, Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A9319A0009
X-Stat-Signature: cw9komzy7yoxuihjxzyp7uhmq3kpd8pp
X-Rspam-User: 
X-HE-Tag: 1770976457-39381
X-HE-Meta: U2FsdGVkX19r6CZg+IPrn5ipdN7f1o8FADCGn9CNF+8Ka48bPJqOEiGf77PjURPUu08oIRKmDzZPGZEy+ePRkxZanCLr5zqnfpcAGH8gO2Xzq6J5h9gS/inbVXl5zhJ+YUpOZwwVxk4ST6m2XApgayexJBzEyHjtZeoCDL1xuzs40CO1MxWCuRkqA7/WA5SHD0onj5RD9Cp3oT+lgkEfWhX57ZAcwyB5F3Ifeffwu+/xzqUBtQ+bS6fUKHlh9ycZeYSZRWfe7Djsg+jZZsecq8idkSuLdo+4WaY0b2Xz/laAC6O83Dzve85qY2qDdq7v0e+EnvmGbdezkWhP9WhCJKP+fYnUguzQvETdurSObAmKxy5DSIQLffG/pyzFp+qddnFVz84WcwUhbxo/D4RuqlOLPxfx48ef8GtkoONsf8gKqRSaKGmGKkMx08RU5ZDi1q1bzr1CD/pXaZSMkVcEepOlArs84zP7IxgWJ+E/IkHoN4p5bRfhE+5S5qZkn56H0HJW12u+TYZQAFHB3OoLpLtQpD9ct+A1rUAUmwfJnIygkUDJT8imTOSezN3R65dm0jGJksYE4d7sMZaqh7XAmsj9pN+B8n53xHYXXFHAeUdb/WS0eSllOEJQKbdA0CvUECloK/41CFN0+/CWCjjbnxVunFhuH+Ql65QijbrW/1auzjaU5bE7r2G3NT1hgFkP7osR1rNgoSXvY9tUr4NcxlxuLI01XRKjfeGLpVhQa2f7X9ildvhFjZGp5tPh6WtfOhaWR+Vjb9bvWV7cx1bapyCd6obXTQmiJJVxZv10V/soBmHMkuxzDmmRYrQX4gjeQ2uXNhfXzkrxXMpNW7AJyYnhyoZ2BXpJMjAgrvIGzlnzIiRe/RGQMDUmYOzEssa1LU0cqepCQiIyTu6anXRVmSfZZOKbwuNDjsv4GItM/hzxlsXoACZ8857yeCA87ZOKt+IuUsVf8ITYcABasVc
 pGjZie2N
 s17KtDT6bKJfCuh5jMhabGohFIvRUtrDHXINkBIQOPRTumMKaTHmiNGO0+QYqtAmqD/C5w/ji7YfcCG8GVpdE+Zk/L8ud8cH+fi1+6DAKv91cZDiwyK+kEaehIcc3/2xpg/wTJyOa8jsRHi6sIHPWkSwJvumb6T3Sfx1FYkG26aa/30BuIrv+vwNksGBV7kyzLRh4NKKe7wKlk4+XleMrDaMweMIXvFX+B4OsSgF5L5wTCMiAjn0b7pmkcxyhic9ZgBu8oB7PmmhOK8rAAhOa8oALR9PFWGwx5FM7RKuXfYCyZ1VK2kljbIxvHa7sj1ojiZ/URZKSjzzvUMAtM3cXYitTWRwSW5rOJPCEgZMWze9kCGJupYXJG85mvYK6BioYHvqkj5j4XsF1G1FOW1N9kUBDZH+/txidL+1AFLqgzKjK9BSe/SAc5tiKi6cPVr/QsXOvXe6ZeEbj8oLi0zP3VYcoV8j1+8LnCdLOXfyf6es4zgYQ/xpwXptOcZpyZzBD5uu6AI8IeYjlQLruUsiL6KJ5YcUesRRg7N1mqdQojvx9IIEFpftVf+hsgv6VVUEP6awUs45+4I8NIwCE77qr2UMj4rJqcUEjaUjmwACYQoACFoEw0Jbv1K/eBd3J26Qh/X5AV9bYk5zUxMWWD3iR8i2AsJVsdM//8Spcf3EpYkMcpHz0P11G/qW3jrmZLNrpcFuwObKtW7/EaXUgDeuFZwoT6a2RlFVV7T+0TJvtvbtEWvjmD72XKaouLeMJoPzAhViO2kvB62XHuibQFkrLhtzAzZ6KDFLw/+fmZPXAW986IH/zRS+R7Sgkk9lY0ZkMOy+CEVzLXYwJWV88mH8QroVfolIY6F4/di+HGE0+nnLafMY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KFENCE does not currently support KASAN hardware tags. As a result, the
two features are incompatible when enabled simultaneously.

Given that MTE provides deterministic protection and KFENCE is a
sampling-based debugging tool, prioritize the stronger hardware
protections. Disable KFENCE initialization and free the pre-allocated
pool if KASAN hardware tags are detected to ensure the system maintains
the security guarantees provided by MTE.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Suggested-by: Marco Elver <elver@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
---
 mm/kfence/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 4f79ec7207525..71f87072baf9b 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -13,6 +13,7 @@
 #include <linux/hash.h>
 #include <linux/irq_work.h>
 #include <linux/jhash.h>
+#include <linux/kasan-enabled.h>
 #include <linux/kcsan-checks.h>
 #include <linux/kfence.h>
 #include <linux/kmemleak.h>
@@ -911,6 +912,20 @@ void __init kfence_alloc_pool_and_metadata(void)
 	if (!kfence_sample_interval)
 		return;
 
+	/*
+	 * If KASAN hardware tags are enabled, disable KFENCE, because it
+	 * does not support MTE yet.
+	 */
+	if (kasan_hw_tags_enabled()) {
+		pr_info("disabled as KASAN HW tags are enabled\n");
+		if (__kfence_pool) {
+			memblock_free(__kfence_pool, KFENCE_POOL_SIZE);
+			__kfence_pool = NULL;
+		}
+		kfence_sample_interval = 0;
+		return;
+	}
+
 	/*
 	 * If the pool has already been initialized by arch, there is no need to
 	 * re-allocate the memory pool.
-- 
2.53.0.273.g2a3d683680-goog


