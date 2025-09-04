Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0426CCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61A208E0010; Thu,  4 Sep 2025 13:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CAA68E0003; Thu,  4 Sep 2025 13:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508108E0010; Thu,  4 Sep 2025 13:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7CC8E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:55:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE57B85AEF
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:55:54 +0000 (UTC)
X-FDA: 83852321028.02.9E5FCB6
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id DC0664000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:55:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b=HlugBi4I;
	spf=pass (imf11.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757008553; a=rsa-sha256;
	cv=none;
	b=TzaAfpbuHVXJNBxofG7/5CXOCgEkC0uiDUzxElTQM7zm9lgOFXfEgqYR59pjBhLUdfV1S0
	0Puii8TEvdqFVy/LlV9RWWJaMxgVMPY28Brl5PTbx5udLqXhUqZ65nXEDS03WShFWeEA43
	ijhEFaMoQTuPjc+7I0SembZEEF/AbT4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b=HlugBi4I;
	spf=pass (imf11.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757008553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zMtbznq3tl66msCReaOp/sA5Z6pLqOTnltPjz7M8pLk=;
	b=DXBITStpPe6dfWdBph9Ms/B8VoqcRy2BMNp/zuqI0nhA9QEKT07aY4G7d7k/OjSBBjp6tK
	YF/LGZpsJgxg4xrqeIo+aaQXDQBMlgvH94+fK6ZXgj73EwyImgNnB15ane+DfKP0e3m1Ui
	K7PmBxV3k93gJ2DsmenkekjfwsphQiE=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7ace3baso246895066b.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 10:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aisle.com; s=google; t=1757008551; x=1757613351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zMtbznq3tl66msCReaOp/sA5Z6pLqOTnltPjz7M8pLk=;
        b=HlugBi4IkXUmouHq9Qq8GRjbuTupkOA9Bpcwk0uj0WueCIEDyIeBK8hRDBV8pHQT6y
         jiYSkYxYbHukMj8BRk5+lkmo7y/UvYxgYUXrWK47RKNMsN1gUJvnOXin7uxmBIwDXzCU
         iFee0AU0hNNTBbAVju/J0wHUR4o5qItzKkJtZanK+ydGUQrPw7b4l5VjgqNh/lgqBdMj
         HkfOFatapOJfbIOKNUNIORFxyx2QCrK7OkTD7qNf/8n7kn/QPC8McI7+dJy3nDQ3LU66
         B0NE270NMz4xTcAKSACvf4jF/msiwgf4f5J+Wn/m0sKq3tGrfEgS44wCULW0zkmqrH+Y
         7Dag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757008551; x=1757613351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zMtbznq3tl66msCReaOp/sA5Z6pLqOTnltPjz7M8pLk=;
        b=F1sFeMf4o7oBEaV54Rsa01UY3FiU2AWHY/CsFRgYtK0xFmSJ1ppfyGkuED6K02t2vL
         lbZzRJpZH7xYW300WosvviXcWCeKTZWSPorxtVmX2tJn8i9yqaDpM7LK/9NpkQCj24Ir
         ZwpMCY8iVKc/3ylkUe4IWWBvV8rYNJU+vW173GOuGZ0myqr7CBab3QZ4tCEN/esk/f2S
         CPzds4eUTQwyiEufPODG7wQP6BohR0x1seS2QCNVv1K9KSPB7yD4fx1Ia1z816pUSTLu
         EKuTWxJABCH3xzOAhv/yE/x/unmqlmCAYUkJxuwUzMBzeGXRiiL6At9GI8pI3+CvnQLD
         Zp3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXauA0ZkQvP0n91OAJQQ19xc+A4Rl896EiqWXAeXOazqUDxcTYfPzO4NoOMJZ80AhtJW7rEWRTkwA==@kvack.org
X-Gm-Message-State: AOJu0Yzy9ynXaFo6Ez9UA4inqvYXpybnFsvECSu9LqyouPbSEzq7IzNj
	66esF//iSrXN3rQw9o2JlGJxQKLYLQwuGPCALmyURhGcb/wViRI24cBsm4EZkaBjnpk=
X-Gm-Gg: ASbGncsCjPE6C6gn7VpPHy3K3X1RWY7ZPLMvsO+zRmTlT6wU+Y80VYK/aBqruuUKjz9
	UQIKSjNjCQGuDeKg84UyN+hyK7XVNZxjz09udDK+3iXdVxf74m25dG3tLqNpBc3Wt/afXifksJ7
	Z3s+KJQQUCbIeyM4pFG/83COEL1/MUtvuQXOK3ssdksO5HpbV2gY99awNoqHqBb7wWI322dIBiQ
	qL/AsTuUljFS2lRVYbil75LXxDKz0zgX+Sm6MaMvkcMKT6hrSc9qSaf7e1YSumm4Th/XryER422
	9yVtnttqDiHHYCGcuuw86Nb+Q74codKgNpyXzlBBhYZOVISjvH8AhTh6Q+zwb9koxIlfFnt//9f
	TaZ/po8UP1QFaIR+8CmA48RKnYCclDPO/hiFG2AYn5Ce84zUs9ZLPmD3bKg==
X-Google-Smtp-Source: AGHT+IHHwye8S38M+daTlQY3u4C4GqM9qagbcu55Qj4nHECI21MQC05GMM41j4Ip7X73DFZQRvUF2A==
X-Received: by 2002:a17:906:d54a:b0:b04:2049:4c5 with SMTP id a640c23a62f3a-b0420490836mr1656559866b.6.1757008551138;
        Thu, 04 Sep 2025 10:55:51 -0700 (PDT)
Received: from localhost ([149.102.246.23])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b043d6c2f6asm883392266b.62.2025.09.04.10.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 10:55:50 -0700 (PDT)
From: Stanislav Fort <stanislav.fort@aisle.com>
X-Google-Original-From: Stanislav Fort <disclosure@aisle.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stanislav Fort <disclosure@aisle.com>
Subject: [PATCH] mm/damon/sysfs: fix use-after-free in state_show()
Date: Thu,  4 Sep 2025 20:55:49 +0300
Message-Id: <20250904175549.88928-1-disclosure@aisle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DC0664000A
X-Stat-Signature: 5zqhewh185x4sjhi8e936s93ko1w3yj5
X-Rspam-User: 
X-HE-Tag: 1757008552-145726
X-HE-Meta: U2FsdGVkX18g7PIcVNU7ofeT395qo7G2fQPT6P5dgh+3QMEenknM8Mw4t9McKhdkTRgHwJVSIrBz+/nmXDM6hrF0EsMa0XDXAyyKYVFilBORvicLUeBa0ozMkN7E6JhQrUwxuc4zoQbv+99BZECa6U+v3bn7XJ+tsBLH9uqZY5JF7Yh8mHGy3Cais86xfXyCQie2GjEAIvwPkjMve1TzHDN6XgQ3DxztzawE2FHuvKeaUO4A7f7DQxK55a5oYoBq50lnDMcJhxKJjexlfD3lZuVsBHbu3Mf+XjZqT8/JmBqb4+HnIgXfDqdL17NnkdK969V+t/RThQgnNKvyvPtgp/RQHCFUIBABhLaPuM9fXbIB/Jv2se4DdZkvzJWdxyGMJtPR6EaQZerY7TYv/Hn21EX0uJx2Vd4qOpcu/sJSUp+8OhAFZvsVsbOCMWPwILBGbyQLGESHfg5PyeGt7dHPjbGWbUHY+4kvWjNsVU2Zz4y9y03X5t5QnEMFfBLJY1aiX2RXIfKQiwK9rOrcNcYvQv7b80CxVT/qucVod8DXj2hw3aEps4AduX4LC8ybxcElUn4orrGhyNfA84nSCz0M8FUxQq77S9lb1jvAd1pBRlPDNIbe2sig73TCnucIL1Fd53S8CIX0XfDA9akN7eMs5+/yXBsO2LzYMHBqUKRfaFUrc+t5Oaw5QlMoK6ww+ySsYqwWMV73tNN7L1V2iz3YzLMTaY8rP6LRWlIC48XCJDSgdee4i+e+NOEx6SylupqLgTHoiNTWP/SEjgXKoRguJXtDs7Khs4fqC99VGOb8NaJjyY7uEboC/N9gsZAxxwnMX6JeXXmQLqptTQ67Pje2NZt1hdlOE2UlqVBKGmjmj7UCN95iLnW5nm/Zqkk5bhhaLi7KWu7trZLf/XE6WylmT8qaX7CRrcY5GpxrVLmioSLppVraQ9eO5ty+PkYT3ZNpJm89IHO+6SoyQ27HYtL
 rVgLGx8p
 WmAaRXaa2k5+ixCb2668AVYc7o9mTYpMZDT4QMNxh6vQpgEHyUzTrlqzSqFQZ+NG+WP1rsomM3cyZPnE5mb1V4ahHkJFno+FkX3TmCMCLSvCy/fx7RKYeDaB7aZo6yvxjmbwL2aWZP6TyqqdYcmiNjs02d7ZM5mYp+3tQDAZZ/Cm7sSVwM3Lb4apQfWclb1MKdRi604qXVmmmJ+fn6xHrkg/lAis4u+nAM7Ruy3PlqolIO4ZS6Ze0scR5VFtKXVZKKhugK82UfTXeP9/TMKm+v9KesTvyxy+H9XlErkT3tJUgwF4ttSXWkLKygATOrxCXk5qvlQnJ/UnixfdQSgHyh2Al1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

state_show() currently reads kdamond->damon_ctx without holding
damon_sysfs_lock. This creates a use-after-free race condition:

CPU 0                           CPU 1
-----                           -----
state_show()                    damon_sysfs_turn_damon_on()
  ctx = kdamond->damon_ctx;
                                mutex_lock(&damon_sysfs_lock);
                                damon_destroy_ctx(kdamond->damon_ctx);
                                kdamond->damon_ctx = NULL;
                                mutex_unlock(&damon_sysfs_lock);
  damon_is_running(ctx);        /* ctx is freed */
    mutex_lock(&ctx->kdamond_lock);  /* UAF */

The race can occur with other functions that free or replace the context
while holding damon_sysfs_lock, such as damon_sysfs_kdamonds_rm_dirs()
and damon_sysfs_kdamond_release().

Fix this by acquiring damon_sysfs_lock before accessing the context,
mirroring the locking pattern used in pid_show().

This vulnerability was present when state_show() was first introduced to
access kdamond->damon_ctx.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Reported-by: Stanislav Fort <disclosure@aisle.com>
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
---
 mm/damon/sysfs.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1234567..abcdef0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1258,17 +1258,24 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
 			struct damon_sysfs_kdamond, kobj);
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-	bool running;
+	struct damon_ctx *ctx;
+	bool running = false;
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+
+	ctx = kdamond->damon_ctx;
+	if (ctx)
+		running = damon_is_running(ctx);
 
-	if (!ctx)
-		running = false;
-	else
-		running = damon_is_running(ctx);
+	mutex_unlock(&damon_sysfs_lock);
 
 	return sysfs_emit(buf, "%s\n", running ?
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_OFF]);
 }
 
 static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
-- 
2.34.1

