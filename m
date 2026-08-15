Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AA7C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 14:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45456B07CD; Sat, 15 Aug 2026 10:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5556B07CF; Sat, 15 Aug 2026 10:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4926B07D0; Sat, 15 Aug 2026 10:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA266B07CD
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:31:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22A351403EE
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:31:29 +0000 (UTC)
X-FDA: 85103741898.16.A4B7D06
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F2AA140002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:31:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Lp/9FzaL";
	spf=pass (imf23.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786804287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vgs6AOcx4CaUB67rv6dy2Cg2Qla+WNDbQRNX2dCqX6U=;
	b=Fk6foaQ0XICZLJVY+RyWZn1LQIQihW0kXIB8qDxpKEQ9j31cy+maTbgZDqPL+xCczK6zOB
	um6FBX4Vq2VGSmaP/a9ruxiU3Tnv3Kf0E+gKX75OxKTzSDDQRwunSR9+PCfgz2aywN4ES+
	c7bn9BpvT6ANBACqF/FVsSIbisk3ag8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Lp/9FzaL";
	spf=pass (imf23.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786804287;
	b=J8h65tuvsiiMzbhwhh2PQc4Dm0kQiEjOqXztPscUpPWBd0uiA52Ui7OG9Q5JfXeu+rfk3Y
	Nc30R3n3aI7ppIYg667TQ8cn4l8PMYa6MzUdwe8jGXaYVf93uSUwPLMQPTIebX4Oi4uEOB
	Qnb1DOqmbXg4cDAwJe/jrJhzYHiUJBA=
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-495459712d2so5219215e9.1
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 07:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786804286; x=1787409086; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vgs6AOcx4CaUB67rv6dy2Cg2Qla+WNDbQRNX2dCqX6U=;
        b=Lp/9FzaLPamOHnvmZ5KED99D2baaEFCzvM17VpJO2Tdw3g4cHmDy2484ta78RQO+Ar
         tTIapG7TZQilKSycA2DeMPVtHF+VBRyTfI9rFh6+ihlsaKctIZxx49vDPCpZy8P6aNGF
         0knw5ia3CQNfA0Fxaw+wHYMt6AOx6FYTUNRvW7s80LnK0ntOPPfD8WagUuHDqNWUr/ZL
         RAmHn0vG5CAOjSaMQWA7id7UBBmlr9VwlHQ30p561LVJf7jkkcqUV2mmpnsZWUVs7LQj
         b/2AFPSoHTXyHsL2SR5ekVMwHy51p/R1jyA7ioPwLDRBXdKlnd668H2R1NfhQipIkWOB
         H1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786804286; x=1787409086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vgs6AOcx4CaUB67rv6dy2Cg2Qla+WNDbQRNX2dCqX6U=;
        b=TlQOQSGsx/ZpVY4B2tZ4Sn1XQIkt1A5s/XMaaR5Oh35YxaiCvOW9VpClSDp7YUp405
         QvHIbFfQFWV3mF2ziyUhU8gG5AohnAj8ITRfi18sMufaBVzZBl0J8pZzlYsfCJZuLXGN
         ahqB1mqq93bM7ou9TGQms2/qaGj7d0WQT2ZoBqwbhIbrsOgNQRyBnLWrVMydHMOTrEOt
         bMxN9/Ck3DdjTsGJ5YgSTYXpwWo+b1rs0FlBg1A0/CEH+dVekTNRYfchr1oqw3sxNvid
         bVMaccoFGFgH9Wc2aeVBrG7qZP8ilVmD/RYVAPW3dvwASRQmie1nnWQtc4yiAJ9rb5ZE
         q2vA==
X-Forwarded-Encrypted: i=1; AHgh+RqjvebE34O23h4uwLO126T9HxRbR3NbXhQJVowR8vDvBUPRX1X8H2z+o6CTldT/Gvc3yhgCA/Oi2A==@kvack.org
X-Gm-Message-State: AOJu0YwD5g1St6oB0vQ2nOpOhHe92sQhKH2LbKWyklet1VvTbXMsY9I2
	RIu4GhWGXWJzjyGt858i+y4x/vSOaO6K3lzgY8VC2FR/jiCuyvHlPyMq
X-Gm-Gg: AR+sD132WLLYZPQEVm3vdS6bVIWjaXpejn9F/j18t+jkOGvh/xkB3aS6eSg1iXm1bxx
	W+x52xzgPbFQupYJ1TnkwDdXUbmuROP/4z9qyA1/RMOZBgZuU5Rqu5NUFh60Npziqmj70d1XmeD
	jmJumEyZrAimY/PKw9NQ9wQixnsyyRclg47+qISQPb+V43SjwPtV2ps4IFurQFybArdTDhRJcDd
	bvDwZ7ypGvL5QFWSmDm0jguHK26c84x/ECji8BDo5RhBwzjyP9UF2EgNa21AEzP3Gkt/axRjgKX
	VJj4wstsmruVQG3j/mfbw5Qfz3roHbItMQ4ILum5GTx0oWcBrAn08TUTPJWNSD3f0YGTpYqKfhy
	PaAvVvjDfjvgDb9CHUs/Y102niODA4CnMZrfe73N1QV5XcdFuj/SX1m/oPg1kBjQFSRpF7AIsev
	VG4brP/dYUt2jSYFaEXObS0CzSt7j8Gq5S27bgaCFQlq1pCGlX4CbrbyaGXGJcY4S7DLCuW8GzP
	G9VO+bzYSNyj3UMCcv5PdZYt1KvfZpVq+GH6XPKXeXmtZBCHYgZt7ll8pOkRJsWF4R0eIlnVO/3
	9lKuLthrYEs2p79slCc=
X-Received: by 2002:a05:600c:4e04:b0:499:9069:c2c9 with SMTP id 5b1f17b1804b1-4999069cf2bmr75580105e9.11.1786804285834;
        Sat, 15 Aug 2026 07:31:25 -0700 (PDT)
Received: from lima-kernel.telekom.ip (84-115-221-9.cable.dynamic.surfer.at. [84.115.221.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49988b24746sm251357515e9.12.2026.08.15.07.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 07:31:25 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	jaeyeon.lee.dev@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon/tests: use scoped_guard() for damon_test_ops_registration
Date: Sat, 15 Aug 2026 16:30:39 +0200
Message-ID: <20260815143039.17291-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F2AA140002
X-Stat-Signature: gb3yaziknz5mcdx9mkjfqji4iqcuu7pc
X-Rspam-User: 
X-HE-Tag: 1786804287-109421
X-HE-Meta: U2FsdGVkX19H3Y4hQC2Je12S5vljucorSqxltUTabmWUInzhl3g6+M+FtzeBuaag8pQEHGqeCaHHMPkdJhJdkDwEN3V1GK2/4IcTfdpwJMsK0ppFu8IVdt2+mr+WPHNIXbk2tcdEm7I8sYiVcUXqmVekYJDkCbziWICcu8WBjlXQZVLb8kBQ7oWEoB5ZxTrV/k509bYL66i8Ozc1WIt0OFWK3uk7fs5nn8Ib2d8rfGceUhqDtx/7No2ym/hmttKEXh2b+QN6evq/zEPsTBMeaBuRdwsCVVg+ZVvzISJhB0EC8iw5AtUW+OGFAWWkW5aRa5yr/6MALpu/wz3QLc1+BO89pGrVxSuStQLRVs2TwVgbIQ0pbA36a8kb7PL/vKzpjB3OrI9LFWpeQ+b2SklX6+REJv/ooN3cjJtxxJJUYsEvKZZxnbH+EX0Gp5oCexGEXbuMdJ+C/kHUWI2StGBMjmmM8bmG9r84upzVFJKTTN2XCjIIC3mAFZ1zQVwlEDopNmcaEqxYbonk+mtQ4JpgzRMf03NTVxGzB8W24w0kChmkJE+3wVmKCnSwfvGkierXqMQXcGbpaszp1ahZorPAcR249BzPxL9iK3hhw1TQxoU6NzwlOPPQzPuqGJDC9DmbBMNRsgt0p4a5YvrruoIzBr7VB7oJRz12KztEy2nvkFmsTSxvts9qiaDAV7jIFpUBG4HQe+lRosjUjfmOl2Ainb54PxFMFUCPJNSBr7TrjdA7X8rYc8Utjy8VtjxXDEv2E+CqC7LeczkvhqxqsSdcp8I9gOH8jg99EEfBfeOluT6MJH6VJvUR0HbGBYlHhcerEJPOoPbC1ptJ2Ksos5Kv+rE1AAFGy59a7I+YfWfg21PeQ+/rBPqAfG8TmhGHUx1bfrSt/jeMiz6XM/KRqyx/22LxQMajEimd3gR85lJsWvqGsRCweiix0cw2rr9WWIeNt9FJlswH7zUtfF0jZI9
 /YxCZV0M
 E0t9qk9KlUV6fuQvuzJkPwfTwUh51fACQmUrgL/5+oPQ5+FXaPTe0WNND2UdDyZ+1Fp2/tI+qT1ZVLljxiZFexRfLJ/C1wD/VVx+2bhklVlkBFnq2dE8vQJudUsFC/bxmd57XeIKZiXlEgzGAMdqV2A5Z/jr9zV53cKyGMQr22ff9ydjHZ9E0evZ72wB/TKdXGTBcVz1oQCT0XwWXXjzxgQQV9cGt13clxVaFmaddZ7cVPrX0gwXQxIqYzoNqqmWuOxCI6/EFMxBPNEDRJSy56g8RLl0kAnj5ToFZYS3UmYNpGoGOdU/bs6x5x+P3nDUK/CoQIdLXyBjpLfDWfRF3JPjSRUQmAgMDZ6hZ+Q2nvDHrh1DyMEpWTa9sDIRusIWZNZ6BCHEsDFLSqlCk4TJIvS3Ecl8ozhlXzqjCb7X1CD2XKO1DZ+Q3RewahTho2aqGmUZUvml/kbWKPrahvm8eHGV6eKrGvVEZ6kcbMGAbTHgwDJHhRNcNd/mMGT302PcuyoKOzmLDpOikzjnZ2JeHBRUWvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace manual mutex_lock() and mutex_unlock() calls with the
scoped_guard() macro. This simplifies the code, improves readability,
and ensures that the lock is automatically released when the scope
ends, preventing potential lock leaks in the future.

Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
 mm/damon/tests/core-kunit.h | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2..770927a30021 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -434,17 +434,17 @@ static void damon_test_ops_registration(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, damon_select_ops(c, NR_DAMON_OPS), -EINVAL);
 
 	/* Registration should success after unregistration */
-	mutex_lock(&damon_ops_lock);
-	bak = damon_registered_ops[DAMON_OPS_VADDR];
-	damon_registered_ops[DAMON_OPS_VADDR] = (struct damon_operations){};
-	mutex_unlock(&damon_ops_lock);
+	scoped_guard(mutex, &damon_ops_lock) {
+		bak = damon_registered_ops[DAMON_OPS_VADDR];
+		damon_registered_ops[DAMON_OPS_VADDR] =
+			(struct damon_operations){};
+	}
 
 	ops.id = DAMON_OPS_VADDR;
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), 0);
 
-	mutex_lock(&damon_ops_lock);
-	damon_registered_ops[DAMON_OPS_VADDR] = bak;
-	mutex_unlock(&damon_ops_lock);
+	scoped_guard(mutex, &damon_ops_lock)
+		damon_registered_ops[DAMON_OPS_VADDR] = bak;
 
 	/* Check double-registration failure again */
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
@@ -452,10 +452,9 @@ static void damon_test_ops_registration(struct kunit *test)
 	damon_destroy_ctx(c);
 
 	if (need_cleanup) {
-		mutex_lock(&damon_ops_lock);
-		damon_registered_ops[DAMON_OPS_VADDR] =
-			(struct damon_operations){};
-		mutex_unlock(&damon_ops_lock);
+		scoped_guard(mutex, &damon_ops_lock)
+			damon_registered_ops[DAMON_OPS_VADDR] =
+				(struct damon_operations){};
 	}
 }
 
-- 
2.43.0


