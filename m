Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5E3103E18D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6DA6B020C; Wed, 18 Mar 2026 10:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB35F6B020E; Wed, 18 Mar 2026 10:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B586B020F; Wed, 18 Mar 2026 10:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74C9A6B020C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 271155ACAE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:00 +0000 (UTC)
X-FDA: 84559385400.04.9306B3F
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3C66F20003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:16:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=H1yXRCmo;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+V1BCFfyUcKpfQV+w/+N7aUNd6NuLnsp5FVuX7GX7E=;
	b=V64FQJJu6CceW/Njkqze/ss65IKeelcmh2e23QhBYb9JmyMoTWfkVR0k4S0tUxCmz3AXAV
	BVvmPMWMYJvmRg9izdFzl7jlKO5ABXxCpOKQ3RSt+o9hQbLiCJbTVdKTOa3gufWN4icqH+
	buEmbN0wwZzof4qniFYRKJgT9cy4yXQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=H1yXRCmo;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843418; a=rsa-sha256;
	cv=none;
	b=g5c1SGBysXHMmb5AgJiVq0Nw/8O55ICB+qeEiHsmXVyq3mv43h04d9f5tgYfH9fqmse7/V
	aJpAPOilofQRSezCiPJbU6wUOoPrZ+1V2LMw5zGCY/CSNfO3GjEsmvd6HILuyW5WSTS1n2
	c21cHvj9gP/QSZzul4yTAhvcMVnILYw=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64c9a6d68e5so5958029d50.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843417; x=1774448217; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+V1BCFfyUcKpfQV+w/+N7aUNd6NuLnsp5FVuX7GX7E=;
        b=H1yXRCmoW5gUeeeoNg6zYTPqrmqAoW6lMVTyA0GlN5Q7NLo6Chf6nKZE97vRbK0zuE
         v+LIrkbC89lbyV4BRywo7Eul0XmA0HmlUwbsJxdzFoiUrOoRXPUAHNxbg3nPZhMl4IAx
         /Woog/vcE0o4Fy10Vt01rohiRa/roOkyQKef1uElClRGLYjBE9nUekuzpAgt1Da8po49
         /CPAe1cASf3WgrQKfiBWH6SL6wuP2L3TTJ0rxCrfr2IOUzbmMD1DvtbO8nhq4BC7qN2p
         q67b2xCi2Bu47ReX6G9G/bUcXnflV1HqLnjrwobd+hK+n0WMkFylqc1X878kAoXKpQbG
         67nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843417; x=1774448217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4+V1BCFfyUcKpfQV+w/+N7aUNd6NuLnsp5FVuX7GX7E=;
        b=OYJn3gZ2V3ecRHjZYmd+QR8B+MmZS/xUJ0fAo1pP8XWW5xve645nVGTk85xCFcjdc0
         fbXcvFnxtl+k+XvIZ/6hzslvzhtmb2oUMhQSk8i5tqwtFmg91CZJRS7JRNtrTgC7vuHk
         SqFWhztGWkY8cqy382QazmaZ9PcnZUcOEMkH4fFMwqARfvgrQo/U1zmailMpKDvxSCAH
         uuf6Zf2v0wmgcws1Fdnc4Vcpedmmib1CpFXCS6cqBrEP4K41l+M6SV4Kk92TURXD0p5N
         SNDZ/mpFXFSDQRh1m/jJ0ZF/Pb95ylbhohue08T2W5yeqJ2dkqZ2TSBe+AgRxwxpmrCI
         XEBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtRpEXlwHxATpTD6KC+XqLb6k3gRR23tZKkSHNdwMzWC62lP8+Kr1vv6slZPzCF7rtOkuGFq3LJQ==@kvack.org
X-Gm-Message-State: AOJu0YygmmyjIZV2PLTRHIYrDJcesAmwrL1pR767PzV85iSeeO6XDBnZ
	8lKeEiOZX2jFo32TA/y83ZQMZ7rLCm4duLnSnQJIFo6Z5krKqruM59Oq3g0G3BYnWVo=
X-Gm-Gg: ATEYQzwUtRWOdwIM3kuTjaRjGmDzw3sdxji0G3TFMT0bZPRvi8RlwjBPUPcyc8jRICz
	EFJ4Wb5p7//spbRlp/Gnxbt74dwAtVS2PeDCgfZsAHTfy5C1DQklP/6/3UtdzAi+0OjyXUQQ86U
	LfPQl3zS4ekvrbKoSIE6SLCsqOsCv7ecD5P0AsIoJ1gGgTAZtYGHdFjXg5pRAdP8z+68W6OWNcu
	A47gMZJN/0+ZoVqRxlZc+06MFSuY7ibZQNgCNA8FRZAelDhSsYQwt6xOCtZ6XBjKGWdBQ4NwSaH
	pl55HtCmtKRUo/nirhujMsxB7I5Lu585jSFLj4LJEgXhxm9y4hKXrXbXl1cKmpbNRWreCzi+kIg
	hh1DR0HA7RFmMxli5i9Mr15t54xh5dVzOglapROE1g6Hl9G/0WLmEglbpXu8cnEV5trK7fWC3c4
	135kkskJMiczv27A4jyaGR+Y6Rp4IyIUev2huh/GZQeBPmSmn1zy7eAZDDB3RrywxgDWV/yPhYH
	dRPw63Y1SHkdOD7kXfXWCs08s68d+/1M8oiQzk560IyhmSzKw==
X-Received: by 2002:a05:690e:b49:b0:64a:d6b4:1e90 with SMTP id 956f58d0204a3-64e9184fe10mr3640996d50.79.1773843417014;
        Wed, 18 Mar 2026 07:16:57 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:16:56 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 1/8] liveupdate: Protect file handler list with rwsem
Date: Wed, 18 Mar 2026 10:16:39 -0400
Message-ID: <20260318141637.1870220-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3964; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=y4zQEtLWwPUjJBuJnMG9ipPgnd1TGVtuadyV/PXw3kM=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPHexu5NubYp4ky/9rJqctDslv7e0bZpiVBP
 geJyNZcDy+JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqzxwAKCRC7dyhM23N6
 3ncQEACgbfKyhS2517kV+J7FpHssgHj7Rygm8NrV8N5J7SOsbyW+HRGFXlgKDnhQDtPBudPIBVZ
 OE9cMlTY9fosxPgbImZkFWE+vlmF+QqifXjZefrELyzf3tCUSjtjtZekaG0bnMYhV9C+hrY6Nzx
 sW8PqqvojO/K9gv2VwiRxxQeOAKIszRGmN5LTSspgWzuF5naOjpcmm1rCxOF+JiAIFV/hwoiTuU
 gjjmBJ5g399kqOVojt7HYwJNfaGZWNr2sN+4M2kGj96qrHywiiqMmrrSGGFGxF35IBS3Ig1adwv
 x/pSGDuIuMbRIRzKFG9dUrkH5zRZ996/ity7qUWlvMV2NwbLksAhBk2HHwNaRc8M7MMajozxXcu
 TTtlRs6NW32cyUeFto+jL2cvy/QTqsMLhdI5AlXfeeGg841aS/RkXrqzv6I2GfuC0Tye58sBqSq
 0sD9FO8rjs2BFk3/vvHC+eW9Sp+4cHdKUmzWZbMdNVm/lsxr1IORJ+KX1Uze1bUZygyw/fwxVlJ
 PPtA91LH8LHevlsl788x/UwHy333pjf5Gnsh+e65Zo32G+JgZRu07M13ezaKwedNnUbc3UBbrSK
 2Oa63/ineiN0LroMqW6BzWWaBs3OpxlfVE3q0s/El8aZZ/IFvsehoYInkOCYPVGqy4DjaxpgxNI L++MONdyV7GQ6+g==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C66F20003
X-Stat-Signature: jp3p3wrdp3jx33hfntgrzoqjcqne63u8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773843418-615686
X-HE-Meta: U2FsdGVkX18aLBd2yNE53OEZ3z3LDr3zhgc+XOBFNQVRH0df6RBqnkGnq7xXUHLjH257Qxrwt9a9/t3ehFXZNAsdEYwUuSvILrZINIYqrJ1cBZn97Uu62ssjmTQal37rcXSdtzX6rz5oQQ2aBqHpxJPWvs0z+0SE4HzT6VD4dRPLOfKmk1NpXuwNRBTjylOkt/hH6SRDY4prIYfFYIgfbgtj0H7LuvVuxHMSg7V0BEQ70o7nemCv7jxOVbLfelQxIBps+lJP41nbgN8DbMtNZwEmS84OpYj2IoKh3M+dptgPRkNvLViMlchzC1+2U9BwXoIUjxeBAcpxea9Ft9iZtk9PEBRWGN1sW18uQ/zwcASpwGK/vP3XaQ0nFH/9/tXuSI6L+Jrjs+9qWQVWvM3WWc4UfpQG5cRO5V9nyOps/H1FwBzeVqvlPQcfXXbdJ1sip1lXRG6YbHkQrgtcizekKehL8jPX0qqVB5mL++on2ckxNbNoMBpj2plhQtuHft9IKPdUlzmMNEBEByCfdviY5xjqi9V9NfX7XUMq55bn6rC6r46jQrR/LHA8jjE0rmjQ6rDN+VuUjQnc5wvqRY0BrM8NWwymv1tWTL5CgsUk9VTGjWY+vJwScO9IKr6UjWDQ7pQUSb7MnKarsZaLOKyxSU34EjBTMO5J2CtlulMZkap8XC29rMkelrSKqqFXr0XeSDV0wL7WHb8Jsgp/7NXt3EhqqD0RHwzVoEA+j/fkL9j+p1wFUIZ0WJTTEDfnI/56nvXThqJj54RDrQ3X5Rzik/lIXngFwxf+8A76EHpCuUrfDJvb3t1cSnv+qiFV8ArMquQBhmuM+/Ai9dO2Hkgx4ofRY4j3d29djTpF5BA2emr3L3kaHy0Bpqb/6UncOEmEgVSRLZ4cRAPXeAJoQZNzA5niQOjvurg4AcjSExDOa4K622MZka2UFQ0Hyl9lSEdb++cfhuOo8vz4tpHwX5e
 x7lFOB96
 OJHoGDkqx1taeHi8cZ9P/8eEEls4fumch9yGs/nkkzgvSevNjFqUsIJNJzU9qRo1E0UeUYlRLS9sbcZ6o1O2phTEv41xL4x8QygApI97AQMVw1M9j4Vg5WttzObO4v1B6zAZuHxZpoRUJVyK4PfDJHLqQDDlcspGfy473zD1tKtlpGC2YCE22f1ljED2NvWNVsdZPU6Nd65YTfYM0FWE4eFMv2XvOoFG3a8QTe7pF6WdI1s2ck3pcPZBdnEVi2WLtpzclaPQa4cgfeUFpIrzduCAH+RLRs8V84Cwl21BO4+1SI0jHH4QhSYKJCKwIspHefzUz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because liveupdate file handlers will no longer hold a
module reference when registered, we must ensure that the access to
the handler list is protected against concurrent module unloading.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 61 +++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5acee4174bf0..6a0ae29c6a24 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -112,6 +112,7 @@
 #include <linux/string.h>
 #include "luo_internal.h"
 
+static DECLARE_RWSEM(luo_file_handler_lock);
 static LIST_HEAD(luo_file_handler_list);
 
 /* 2 4K pages, give space for 128 files per file_set */
@@ -277,10 +278,12 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 		goto  err_fput;
 
 	err = -ENOENT;
-	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-		if (fh->ops->can_preserve(fh, file)) {
-			err = 0;
-			break;
+	scoped_guard(rwsem_read, &luo_file_handler_lock) {
+		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+			if (fh->ops->can_preserve(fh, file)) {
+				err = 0;
+				break;
+			}
 		}
 	}
 
@@ -777,10 +780,12 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
-		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				handler_found = true;
-				break;
+		scoped_guard(rwsem_read, &luo_file_handler_lock) {
+			list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+				if (!strcmp(fh->compatible, file_ser[i].compatible)) {
+					handler_found = true;
+					break;
+				}
 			}
 		}
 
@@ -850,25 +855,27 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
-	/* Check for duplicate compatible strings */
-	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
-		if (!strcmp(fh_iter->compatible, fh->compatible)) {
-			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
-			       fh->compatible);
-			err = -EEXIST;
+	scoped_guard(rwsem_write, &luo_file_handler_lock) {
+		/* Check for duplicate compatible strings */
+		list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
+			if (!strcmp(fh_iter->compatible, fh->compatible)) {
+				pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
+				       fh->compatible);
+				err = -EEXIST;
+				goto err_resume;
+			}
+		}
+
+		/* Pin the module implementing the handler */
+		if (!try_module_get(fh->ops->owner)) {
+			err = -EAGAIN;
 			goto err_resume;
 		}
-	}
 
-	/* Pin the module implementing the handler */
-	if (!try_module_get(fh->ops->owner)) {
-		err = -EAGAIN;
-		goto err_resume;
+		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
+		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
+		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
-
-	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
-	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
-	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	luo_session_resume();
 
 	liveupdate_test_register(fh);
@@ -909,10 +916,12 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!luo_session_quiesce())
 		goto err_register;
 
-	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_resume;
+	scoped_guard(rwsem_write, &luo_file_handler_lock) {
+		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
+			goto err_resume;
 
-	list_del(&ACCESS_PRIVATE(fh, list));
+		list_del(&ACCESS_PRIVATE(fh, list));
+	}
 	module_put(fh->ops->owner);
 	luo_session_resume();
 
-- 
2.53.0.851.ga537e3e6e9-goog


