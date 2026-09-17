Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86DAC982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0066B0095; Thu, 17 Sep 2026 09:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70DA6B0098; Thu, 17 Sep 2026 09:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A856B0095; Thu, 17 Sep 2026 09:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C76B6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:26:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D29C71C22BA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:26:42 +0000 (UTC)
X-FDA: 85223329044.24.EE2034F
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0612A40007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:26:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b="axsQs/qc";
	dmarc=pass (policy=none) header.from=starlabs.systems;
	spf=pass (imf17.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.76 as permitted sender) smtp.mailfrom=sean@starlabs.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYqy4JvgQiRzCuvqvHp97HhL8V2ft2LLYeHwmXteui8=;
	b=CdNoYvG3abGvRF46qcD9yFh4c1SBAt/NLd5oGNVPAx/6qo6Tu/oX72QSXplHT2IIuBHw+Z
	/LT6qCM+rkLUcq/6VOzZUqJ0prZPipMj6RFtYwG+QSZqh28FYb+ezNU65Ip81NnUZ8keZw
	5Ju8U5AQREnAgwGwrTL20O8PVOtmDLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651601;
	b=6GBUzGynSVSLMFVZ1qXr1CZVDhNjkEg8Ab2AQ9wpsjJAkCDxoxQxtNlyoop3ye+zD32q4c
	XsVEkh8soGklQ+uEYwwg7v5PSKWEr0LJ2T2OuIMzA0IgDAi0M9cCRy9Zqa0FuoYOOI0ipL
	AyJENOyb8GGbwVZqrE4XLNtzI+Es/UQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b="axsQs/qc";
	dmarc=pass (policy=none) header.from=starlabs.systems;
	spf=pass (imf17.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.76 as permitted sender) smtp.mailfrom=sean@starlabs.systems
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f91so589582f8f.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-systems.20251104.gappssmtp.com; s=20251104; t=1789651600; x=1790256400; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYqy4JvgQiRzCuvqvHp97HhL8V2ft2LLYeHwmXteui8=;
        b=axsQs/qcRtLLUru56b+UGiwlNd47nwe3+0/X8fCvgOJIfAVbuSc8DhyugOWYAzyq02
         /XCz/SU0oMScPE9zVuQ5XoARQL3g+X5dxvwQwEqkET6b8x0wAgAQuBkgLZoRntTqVP4r
         Fr7ORtDmPITMxA7/C6bawrTFZDdPA+W42udnPCnil+ou6nbsEFYNCrRyRs0KZ7+b4ocK
         K4bkFiTQ+U3clcJd2vOXcCUV8xCdh+q30wIRQPZOpelNNSlGMMnDidcrSZY0V6J3wRLd
         eglDVluX0mDO/6xhdD9oONY8dn7hkOAA3Ecia9eMb0bOo2nwU3jjhQKWqR7wGN54MyBk
         1nwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651600; x=1790256400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cYqy4JvgQiRzCuvqvHp97HhL8V2ft2LLYeHwmXteui8=;
        b=J0OvT+6Lejmq5Hb/3ygpSdpucMpZQOV0WTzNULyMjHVBPZiY17e4BcHX+ceK73unYk
         R6+ejg/qITaoir0JVGLezu8/Cxh/mfmdJ5iQx0RGT7lBl89Niu23kTBbWDYyMnHPKKF1
         94fzwGfxkxcOh41SFCeNVfetBE/iGnFnv/7pnrwGISXoLzQM46SBlbUrb2ePrNuf+6G0
         mZ5Bi0fU3unZynTJZBD7kPrT0J0ZCtilzTqPa/AyTC/S1F/Q2XAMQrr26mn0/8e3Da84
         tYjdn2mZd76y1nIvzaY38L64UqzH3By7Z2BaZekJy9EiaWPvUp1Kgi03okzOzXP7utX2
         xPAw==
X-Forwarded-Encrypted: i=1; AKwUvByEegYqQTKrLCKE0NyxugRHcXUkHz5Xrx4fqCiXy8jSMVoh/yrLHSql/Kg0cjTrQnWr8y6N5maNdg==@kvack.org
X-Gm-Message-State: AFuF++l28T/7ELpPtdkHBUh4aXl+R/tjrW9tuSumfq8burU6Z0XjnlIq
	2LVgye15oL1Ew5on+z6IOT4Te/GiNUtcHyIxqTESLczTawUn6I1YxJZEN/AgQvBi6w==
X-Gm-Gg: AYBFou3QMGIuolubr8bbhd7x2pD7j8wKtxZc4kXcrcrpaTr2eyYjl+EZi1SKxrp8iPQ
	LezV3UMOZExnrxk4+rv1661BwWVMiz50DYqv6yV2xm7v8rVAM7kKIm0EbZ0W+e2zSdYvtYQDD1r
	r9k4VkqFkyYlYfaaQesu25odGXxcjB1bawUiMvEa2XjtJVUkmjGgQ2s5VtRXCmzCfgSOa8/52Pg
	q97uQg5N3gPMs5MF9mQQ9wyBms+Vk4E0OL0e45kMoKkIbKUEooSHJIvcUwuet6CIQAZOLLoA8cJ
	LkHS6FzI6Wyr5KI1nhjcxdbTQqaOJKwhHtxgONNug97h1bfo8BjN272imyxV2tikqMMgY0sXxCJ
	3PejOCcO791K5oU0Xyh7hIGolsuuUtQTNyjL6o35ZRCWwF1DwYJNRERes6deF7udv2aVhjJ3Jd3
	5JuNxqq3ygirjUhtgTi4mg9rgziH9VPwJqyJc9TwzG7t3h5KVJOhSTWC+uVsmfjCOdmHTAeRWN9
	wD9Ql+FXvK+veLW7XSUa2eYnc8a
X-Received: by 2002:a05:6000:4209:b0:487:77c:f6c4 with SMTP id ffacd0b85a97d-4870d0667a0mr8425263f8f.35.1789651599627;
        Thu, 17 Sep 2026 06:26:39 -0700 (PDT)
Received: from fighter ([216.128.28.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1f6cfsm15879947f8f.13.2026.09.17.06.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:26:39 -0700 (PDT)
From: Sean Rhodes <sean@starlabs.systems>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Sean Rhodes <sean@starlabs.systems>,
	Evan Green <evgreen@chromium.org>,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>
Subject: [PATCH v3 3/4] PM: hibernate: permit encrypted snapshot device under lockdown
Date: Thu, 17 Sep 2026 14:26:30 +0100
Message-ID: <f237b56e8444ea7b477dbcf4aa6dafd2ff0c1dc7.1789651581.git.sean@starlabs.systems>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789651581.git.sean@starlabs.systems>
References: <cover.1789651581.git.sean@starlabs.systems>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0612A40007
X-Stat-Signature: i5zb3ogkrdz1bjm35nw4j7iej7w7m8nt
X-HE-Tag: 1789651600-619452
X-HE-Meta: U2FsdGVkX1+ZivjXO9H01Gk0myYKCZQufgiZr8Cacj6HsSM/VEK+uFleOqCYjWLj8vTbRlNOlwlFSjfAKgJEEY/4V7eYOHjHxQ7RediEDUeODP9mPWB8RF1nCvkPq31DqwzGFa0Ry+SxUBSLSAHA6h57ugjpdnTEA3jWbf9PsT7WBcDrKUlfvM20apmguiJ7LEoC5fSIkfyQMvPvXC3ppgq5zR8rNSBRRB7lJhYjragE6AsYwH9CF0jjDCEQpzXAAbQBhbHtF9wvGGGaaCpsTfykfb7oPo4s/IyJHp8fVHh9gcYpsoysPu6cPxOOChxqdqYZpXT7XvuyTy0MUNFQzXJLNFBEE4QF0up2L7l0z3z43UoCkNF672G/q+jO6K+XPDrR0276UPOO/IF3nudshJWKT57RBO49QBezZdaFMhxU9I+mlVkujC0G0vucWWhgjZLNMzw/I8olI8TcnC9VhxCKNeBMqO3O++kpUFjc8L+iYrTScwlgYFJqSgRW1vWjG6haWuGWOFH3RaEqDnXM7woHOaclLhmiNsAUzpn+vU+jodIBEweyRWahzwzql7AoK0dBJoeUqE058ak9KU4ASN8TreLVbn8jv77Brtpp8L8J2yeSUFhrc9WXOLHXggy3BAo+B8SB37hOpivTYnEWToQu9Ad3zsMvDXUbGVSSa+eeWOeDqD3gxqsQWXEDId1PiIvrmx1VBKPiXQO4vn1vr8GLTIB6rDNBmzTMM4FcgNFo3cpfKqvDcL7MCsHBlalwIzUGKNVVOdFQW7TB1TboW4z+hyxcgGIyfsq8Qcudusw0hQcC/AaOLxLK1kuAsKvFSCrdH85URvQz0UiR1Xq9MkO/YpGgrs0S6YVy8Na6CabrkiEwPDD1HNIRp7+Ws1+kghYGfVSE/o2G8kyW4pLfBrYMMftToRbMhFx7axu/12PI4jTFPc63QFESOAlELMwseY4+aIsB8t1xUpfrzPM
 WQiPHQZU
 sgb7qsQk+7XAMnbbgookJ3dTyKQG4tL9OXqe0ocVBwyM9IN4+Apb07mpl0AdyMZO18ZXWbPGDuMBcoY6l+yaiETzEHRJ0kbp6vXeOH25Lg0cyvkvtZxXjRb8SukEIdZgUqR4E0gpIgxhipgryc3O/iVT0+xJ4CZE+rB45Rh+RiXrjhmITv5pJoFcDQOC2JYNsdolXhZdEqPr6LGd9/r31XxVBAgAwbt8+SPabfkK7siYVv/nmw3a+ji2Kfe6FpTAKChPVw1VAT341GAVPlND3KVNCApfuM8gY8aD++CaF5iWP5pzMP6n93JObRnRVfCfLUzwjbOCbz9dgMst7xws7hx3WvoKKYI0MTBTgDP+BSbWrnoPUoYr8flDaKYSVMg72gnlpPqek0coobWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lockdown disables hibernation because restoring attacker-controlled image
data can modify kernel memory. Permit opening the userspace snapshot
device under lockdown when encrypted hibernation support is built, but
require encryption to be enabled before image data can be read or written
and before restore or power-off ioctls can proceed.

Tested on StarFighter MTL with lockdown enabled: encrypted uswsusp
hibernate and restore used the snapshot device path.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
---
 kernel/power/hibernate.c | 8 ++++++++
 kernel/power/power.h     | 1 +
 kernel/power/user.c      | 2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a95cb447a13a..0b8626bdf81a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -114,6 +114,14 @@ bool hibernation_available(void)
 		!secretmem_active() && !cxl_mem_active();
 }
 
+bool hibernation_snapshot_dev_available(void)
+{
+	return nohibernate == 0 &&
+		(!security_locked_down(LOCKDOWN_HIBERNATION) ||
+		 IS_ENABLED(CONFIG_ENCRYPTED_HIBERNATION)) &&
+		!secretmem_active() && !cxl_mem_active();
+}
+
 /**
  * hibernation_set_ops - Set the global hibernate operations.
  * @ops: Hibernation operations to use in subsequent hibernation transitions.
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 815c84c1e0dd..351b5f68bde3 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -168,6 +168,7 @@ extern int snapshot_image_loaded(struct snapshot_handle *handle);
 
 extern bool hibernate_acquire(void);
 extern void hibernate_release(void);
+bool hibernation_snapshot_dev_available(void);
 
 extern sector_t alloc_swapdev_block(int swap);
 bool swsusp_swap_range_allocated(int swap, loff_t pos, size_t count);
diff --git a/kernel/power/user.c b/kernel/power/user.c
index de41f590c98d..b8d3342f1548 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -184,7 +184,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	unsigned int sleep_flags;
 	int error;
 
-	if (!hibernation_available())
+	if (!hibernation_snapshot_dev_available())
 		return -EPERM;
 
 	sleep_flags = lock_system_sleep();

