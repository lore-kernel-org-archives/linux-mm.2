Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F11ACEACEF
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6698E0030; Fri, 14 Nov 2025 21:35:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56EE8E0005; Fri, 14 Nov 2025 21:35:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46A68E0030; Fri, 14 Nov 2025 21:35:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A15518E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:35:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EB5FBA68C
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:19 +0000 (UTC)
X-FDA: 84111274758.08.6607F53
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 501554000E
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bEP8ntrh;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763174117; a=rsa-sha256;
	cv=none;
	b=FW6MaWu7YOPcmvFCUhricFRxyhjQailExDXYPzWNmz6Yz9RTc5dyQZ4zy3Oc6fd2LuJD+8
	0Gn/8AiqvEeDi+CeuELBc2FE9JdTvJaTRuzXjxe6763DvFWf3dWIqfNL+efdb8QdnVQucY
	pBIwgPgMdb4eYXCGy8N9SYoiTEKu0qA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bEP8ntrh;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763174117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BmRdC0cwQA4pj06ZuctEpCj+oY9x0ty4nsQhq6sVrM=;
	b=Prjwyhaqv3uLT9MX4E44yeswkjtI9jlqgoFKd97fmP8msbeD953RcDzn5yI14YHnbc/V1L
	B6FT2pn1ry/16Vw3SDafhFcrB0IMOriIDK+liezob6yaQGwdRm0jnih0oqQPmicYFLN05w
	GOiKfDdU7um2uu8C9CbrX5ovTxINZ4U=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29516a36affso28003775ad.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763174116; x=1763778916; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BmRdC0cwQA4pj06ZuctEpCj+oY9x0ty4nsQhq6sVrM=;
        b=bEP8ntrhRfhOF9G+/7KbYc+lNXAbwPnC/23XN78GxxwhwKXAHniCs5dS9H2mx+S/Ov
         NRH2kpQjrb6ZijOv9v0FrbGeGaGsA3smuIB/cvRdeodtEAMXsoqNLZYOlO0yvYdvEBHk
         NLlqnVcXQN5La1YmpjcpkxA96Ys1Z0EhkoCu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763174116; x=1763778916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3BmRdC0cwQA4pj06ZuctEpCj+oY9x0ty4nsQhq6sVrM=;
        b=TRzgbgzbKjQKrUdcJcjus+70P8bW1B3IpUIIutGYJotuV4/F0ySATonUnBi6ysuaYN
         WIy/4IBiuJHnLae/chH5+XMiXgByWlEEW7dP8Z1bj7rdolD41uC8zwMvboN3LSamC2BQ
         EOk9lonM0BS3jkO5AvF9ds3Y0VY9wLejiEuKIfT5eljO0AY1lmSSbEw3R8jetbgzFUGY
         NDOpMe95q53ncvQr/A+dBu+daLRl3hYRJbrbvtToxc6OLy89KXzIU3dBYVS8EKrnKgbg
         igbYsMovgGot0bU9SsSGhPBzA2axMaJRb5s378uQm5zCYdkZFuiEoy7ytoUjr9bhxfhK
         xVkw==
X-Forwarded-Encrypted: i=1; AJvYcCUCEgW+774GPkdA2jDgSuWGLBYKt6l++ZwExwmH4QnH6s19ha7K537TuD2y81oepaQ+E7mHtaCQuw==@kvack.org
X-Gm-Message-State: AOJu0Yz7tFUISAjdooKVXybW5ckYYQ3Yi5yk+wFO3bc7M168StMrxcmP
	mBsx7/o/Q+NfzKraEg/77PGmZ0hV9cWFhpM4/2D3nch+IuI/rJdZ+k6KYlpJjS9Lhg==
X-Gm-Gg: ASbGncsefmyAwosF3j3zaIgeZSaSOleb9klFUlVuah1dv1hn6AQCXwn3ViMJnQLoJbY
	N1LxoKIOJgCrJsbVtXJTFcwMR5rU32Bhod9UsVBxzLbXkIDNw3V/K0GKmmlD/FWaJL21oYAqRi9
	p4xkdugjT10FWRT0TU+h7tJjLbH17ce4kk4XrZYIPX/PJGDfJgF3YasOfhmL6K+7MfUXZD7pg1D
	XzZX1xSzF0kIa/wh6Gn64EkwBow/DbvlR6VXOt7tTaYOC+M/jvjr3lmUL1W6MAaYiS5fbjo66Q4
	ELegcaUKPCGMowPUumFNLx11m4cf+h0Le/Qlm6G5rDEHLY/uZoeiEV25SZEnc/Wwa7Juf8WJ43N
	/KZQRO3bD4YQi+/QEwF1HaUTIszMBnV/Q4ZBsTSmHoTYO6ff4zfcANUJGK5KR2oehWcve7K3dC3
	yLFJhPGtegnqlN+5CMD/ZvP4fTSDqBaAo82VMQfw==
X-Google-Smtp-Source: AGHT+IFf4M2Jlr3ydfB8URUmeRZ7uLXRnoh0xgPbDTGtZRUhasECUQqD8sDuwxAjOhCBrWOAohHVfA==
X-Received: by 2002:a17:903:3bcb:b0:295:1277:7920 with SMTP id d9443c01a7336-2986a72c34emr63213455ad.28.1763174116118;
        Fri, 14 Nov 2025 18:35:16 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:b069:973b:b865:16a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b1088sm68641555ad.57.2025.11.14.18.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 18:35:15 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv3 3/4] zram: take write lock in wb limit store handlers
Date: Sat, 15 Nov 2025 11:34:46 +0900
Message-ID: <20251115023447.495417-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115023447.495417-1-senozhatsky@chromium.org>
References: <20251115023447.495417-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 501554000E
X-Stat-Signature: rkzioywo39zuoh7ekek5hg71eb3eh4ph
X-HE-Tag: 1763174117-886022
X-HE-Meta: U2FsdGVkX1/O7Om1hegszZynykThm9HMd1FELiBWwgbvUzo96Nz2usAv3PhQBCg+JKCFT+fbX9k04kCmXxtMVKIyQeRvoOilIWuQqs4lTu1TxtuToa5oC9j7l1BZVbsXn9xUWHSkaf+mzkd2zrwfKAn9feTu8Czcsii3RsTknmbRhaM07EUNj/91zOpVKMRq7D9/ImRxUdQM52heR3SFyTJG1rhoIo5Q5Mzk1Pg1SXWyKN8vKRAPo3jcbRjTroeSjnh+VIf+CIfaYpl81xQK1qJ44Bss/cZVjn4lqJF8s1UxqbmmjZcQ7acgxPwr3RerIcQ6pbt9Nma5B+xHWFIo1ZVG26/95D0hWVgg19OSiE+z8wXgbh8aV7POe1xiQ3HFeLMpCtukNtx/vkknO88Na4cBQOpAhQIcWLFYUuRd1osaIKl1yQy0iPmCNuBRoSySa6epMkWBbAdIbaWfQOiJvBDcAUOOE2vn5saNeH8r0wsVIiXWyIAXXi3Vh/h4K3xZJYANrNjXVAy2B/+O3sMu+hnM0V+fWGfo7SFlv4zff54DWtdOBkc2OOZx/CUSgPbnJoNPycSrOGyrCuaHZ1Ape0f2p+OJUB4f4dehLvYUQm1rl3K+6wPLd5Rxclkqv49hGLPRUXS6eXtOCJo3AlLFIMK9Swh5FEEPYu8d33b5Jy8rlcCiPuYIhiTl64KBKn8tIyw8j4iIJLfNupitoVDaQYyY/hN4AN4Q78Apq4mPaE321OYX+Eply+JW2JHWZUT2tknLjlqax5mKxWK3CoKlaJT18DYPcI8hXzDDu3xl7LwitmKmqzY1eGWqiiq9266pSdQfo4K3e6Wnh2cv8ByGUJIGyzEPRT1LN+59i9BgoM5EyYNBoWQdYmxNqTHusVeYkGDHxg/LpkD0IZzcRe9QvTZvXQq2+Kvt25d4/ngMmUD5uZNdr5gzl02kFFQ2shSJW0KQwQk/0jBdUUtWpf/
 K/OfXthH
 jcZGxsTcMuShtqJmEvfItTnjbvxHmm/X00j7DGtLIugfODE9r54DOXEMUulJheYl7ABNbWo6Is0mRsKyw8aBSGZY5yQnFoYvHmGj3gH5NVGXtTiTScJXbj2iyVCKsyO8E1yN6E3ubg6+wq2f0rJgWot8fd44baqFAw25EnkXVSH6OeadJkJfgZBXTdfMwuFJA2Qyutv8cMn4D/drKOXf97765/sDzvl/P/a29loXajkmOAKQe0l4b0Br4EjEld4WCVgWtxJp18JYv0QOUnG2oCfsjTV3/+5Oz82gGdQaTS+etVKEH3HAJq8zGlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Write device attrs handlers should take write zram init_lock.
While at it, fixup coding styles.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e6fecea2e3bf..76daf1e53859 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -519,7 +519,8 @@ struct zram_wb_req {
 };
 
 static ssize_t writeback_limit_enable_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -528,18 +529,19 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
 	spin_unlock(&zram->wb_limit_lock);
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
 }
 
 static ssize_t writeback_limit_enable_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+					   struct device_attribute *attr,
+					   char *buf)
 {
 	bool val;
 	struct zram *zram = dev_to_zram(dev);
@@ -554,7 +556,8 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 }
 
 static ssize_t writeback_limit_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -563,11 +566,11 @@ static ssize_t writeback_limit_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
 	spin_unlock(&zram->wb_limit_lock);
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
-- 
2.52.0.rc1.455.g30608eb744-goog


