Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64751F531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EF2C6B00A3; Mon, 13 Apr 2026 14:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650796B00A4; Mon, 13 Apr 2026 14:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566A16B00A5; Mon, 13 Apr 2026 14:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4A26B00A3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DBBB8AF01
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:44 +0000 (UTC)
X-FDA: 84654426528.13.6EB787B
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3CD02140008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fVXDAGZ9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkNvNu/MJWuSgBE0j2meDc1C2+4gt5AIv+r5JMtH/i0=;
	b=TOv60nlpbNRxH5ZQ01SnKOk7p8Af8Y5cYxWP3YJMzU+k7D93xnxIbM7xOyStvsoRtqYgYm
	qriBoG4qjs8f+mxXQ6p5e3dqjSALm7WuBMxI1PBGdgUNs/o6OXg5LvWKKiyrgWxESS9KPn
	/IzAnSeBSrLK4wOPKzS8VgZAu97xJfc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106302; a=rsa-sha256;
	cv=none;
	b=c4cHJmLC/speVZIrLK981v54k+rtT1mQuw575hXdJ1IHO9MfPyDC53h2c0VHThwo2Z008a
	WOsRVmmr/Grf9x+ei/c20SFnrsEHk8pbRr7/kBPA9HX9+U5a23ZTOg78oefyeqEF6P4fWJ
	SqPGMffUUNTbnfawd+CaZm4lRd98zQc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fVXDAGZ9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8d560ede296so553458685a.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106301; x=1776711101; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DkNvNu/MJWuSgBE0j2meDc1C2+4gt5AIv+r5JMtH/i0=;
        b=fVXDAGZ9ahD4aT8xgRLtOXTxsC5jCDKlx+jCTKiIBHEaJoHwYU2N1nD3EFFdl7HkWa
         NDyo/xgh25eW0Go2UcM9P3nlA416siwarCIXaDxzrIN3EVHweDcUdLvj2O1VEbXG2egC
         +eqx6sVknPxecfSWBTN9ep1NPMqoUL7ofxvBmwhOwIQH3TYP3oTQM6JNZGs4qGKzHQks
         mjfy2xYgY5dg6B73ecxslD2cFowSKEGQD48LObzC+nmHDHX9eyEi4yPh3lruzBTA8SXK
         CNF7flKJr8pktTAW6pF1LKlBF+8kT6JNzQBUFqc1zns5Hy+bSsbw+LVspCPItwBHVY05
         g4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106301; x=1776711101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DkNvNu/MJWuSgBE0j2meDc1C2+4gt5AIv+r5JMtH/i0=;
        b=Mh6kSF+UWRNUgA5ICFNUWNgBUzOX/uqa7fnMwufDj1za81jc7pygCjDYTAJUP9aiWX
         /EyL56W0adRfHT/rA1lSKDJgufxWIZAEjq/Fqp7GV1UW+SNo5+vgP+0cTG3C/1Dhqocw
         FvuEdQkk/OBiKPrtfKk1XfBtAmS+8urQjR2bvTmsQJ1FHuGUmoOzKorC5u+w42jTKBlC
         LmOBL2EitR10CXk54Pmun1WvM7BmuiLujxf3EDmOEqMz4d1afl6XeZ4r27+QJ2wls5p9
         nitPNp4LmgtOVF9Zh3t0e4ldt0F88fM2OtdUE7WquHb8NcDRGmz8zQhibjcQ226Vx7vZ
         2IpQ==
X-Forwarded-Encrypted: i=1; AFNElJ9V2jvXTTguN0epRAlRv3+CXlQ9n7kRS2VFfCb30vg2w3HjSjCJGSxPEL63DOVIq9Z6XQygXaDWAA==@kvack.org
X-Gm-Message-State: AOJu0YxwymETNt0/7IBbTCV4AYhR361mBAe5lEbD8Yx/JdudjX6PPaaf
	kPPd5t+22Box/XpckIJgGupDN7eMQPkhTRzCDuZnBCVhqX2xwvJgs6pOw85PUI5TMOU=
X-Gm-Gg: AeBDietnlby0mTAfFO8+us9AtXt1erd85OIcaoVYMrprJbKIM/wWuW1SABUZ905PP/m
	/HlzO280yP1un/KlEDbgf7B/ojez+jAVBTmC9AdjenGnC258ExiKR0jh/RR8zMu9+F8EB3Uwyh9
	Wr1+nMRbt+cd8r+EYpEhtMeT+9UMmd5tDSurmKp/0Ig/+h/lGn1pammlMPrnY4ysCPrbD35bvQb
	dsSA+ClZPFa2sTOx0IgrWZOjSZ1uUpdpiA7HisiebLioiiRdw/xVI+2INl0SOaBhGV4zdG+y8Cu
	P7Ms0qF34VWVEyNjmNahnFaOZoZZj6p/s5lxvQDYDzmNoFquDodYsgqYL4zg7sFbEydyTsM6nVR
	tFot8DTclQMpkCU8MsBMu78WJP6IBaGN69IfbWALukIWWG17SkJXpbBxkJt+LvOHQEjKwn38ZTM
	kMsD78lR2Q6Me4bv2iFSwjnaLH/JY3wdPo3EbF4jgGFV34IQU/8hPPvBZ4AHq7au1eGg==
X-Received: by 2002:a05:620a:1a11:b0:8ca:2cf9:819a with SMTP id af79cd13be357-8ddcf1b8f35mr2243567485a.40.1776106301168;
        Mon, 13 Apr 2026 11:51:41 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:40 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 09/11] liveupdate: Make unregister functions return void
Date: Mon, 13 Apr 2026 18:51:25 +0000
Message-ID: <20260413185127.128180-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3CD02140008
X-Stat-Signature: 6jqzfj919wmfxoz3yhf9shspfmz64b8h
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776106302-927092
X-HE-Meta: U2FsdGVkX1/n+2gmPTs3wGHmu7lGaiFShj44jdsXfpz3Fqz8AmpdyuQ9nDORI9g3kzdBjF2y2T1zf05DPTWGl6cIyPCaSQBeOh/9TlzafIWuSJ5UECX1hypuEvvMoh3emsZ8v+eCGgv2/pDFC8vkfvk/ANvs94pYqJa2DTEhqFtAV0BnvezC32yf6NxpvD2BBKcfu43Xr6GrGUzQoQV0NpXT/wbrxBfzo/1oHFo7jBOvzy1A1Mief0TNviAc4e5EE0OfYaAKmTANEjGoUN00ILMT81P8YXMK5if8ySSYqg7OwtkcXJGxa2p00jtFavwrDxuuj/76YTlQdCO/U/pfkfqsFL+17abxLtMDST4jyqwdeNuj/t1oBMJqWLZoGp54x1G+yIdXpMiZWLHQc5OgCmm2azRLgyhbE2w0yKQGybkiXM4ILF7hlXcm8lpq98Zc9g7ZYCEqmZVm4m9GOjBvSYGPfBpsU4Mw1nQ0KT1PhBX9HlEMEIIvSrRk+kAn2sfI4C5hWueoiq55ovvs2Ec/OER8DGzd+Mcs9Md944Qs71vlawKTO8rJWyXAhvv7FFajzomb3KCsjPhv8rqyRmSgjutA1Lxdv+bJEEk41kmiyvBEoUN8r73eRIrEdQnVPh46MrrAoMQinKnZ0XIBEisKQRHk8+13psy71jKMTosL/8WuknSEuhjsflpj8NxX2OdM69ey78k3VFIcU80GOygj0MF9Xq9N3fh07iOUGXzlDPNbVFLauAgoxGpLiBDqOPGri0NTE0drmV4vEBLoU23RlsSI1NkcGPLfDri2htlXe6hxs1rHO9aCnq9O0J6D26hYbymaE4kcdRYH1Cu83dqDl2FC0JsQQinb1mvjhRwSihZAJvco5DmluxqOTRPtjK3Q/OYvmSKk+AZLCxUHqT7B3S1Y1kQ/v/hzBHWWHcq0Rgs22vezlHmgIklp7RTTDfngldEJHLfuMFQmclc9qXW
 KN1+wXDp
 OFHvCnd+7JMBJp/8rloBJlIs/Q3COomLmrd5+dAz/RVxtonFs6M69BLCWKAXpRg18U9GnTo/GiSDaCMRnfH7YWDbln0CscPnFqxLyJqN9b4bqlRrvHPao3sFcdZt2EU/s/Ui7ZG8Q82IAumdBRmzPoAEHPQIYYp+Tf49I1icDKxxdWJx8uDpp4Oo7qrTTJaNrp/G31CMKJZ4UPm0D3HtatLYYYnOzfxGaWet6OOpPTo76P13eMm6ERxJrloLpbIXwGrAvK3g5IDRd7park9ik4rJGIh8UfJbsHpcGZZcmn8H/fqdPsapUg2vJ0mUBW6APHMPFMbKTRPuV6+9ueN71mf5n2K48vsQ6Pr5o2Owl8VtRexDLDfBSQnsrxOsP80v/58/j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change liveupdate_unregister_file_handler and liveupdate_unregister_flb
to return void instead of an error code. This follows the design
principle that unregistration during module unload should not fail,
as the unload cannot be stopped at that point.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/liveupdate.h   | 14 ++++++--------
 kernel/liveupdate/luo_file.c | 14 ++------------
 kernel/liveupdate/luo_flb.c  | 11 +++--------
 3 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 9c761d9bacf8..30c5a39ff9e9 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -231,12 +231,12 @@ bool liveupdate_enabled(void);
 int liveupdate_reboot(void);
 
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
 
 int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 			    struct liveupdate_flb *flb);
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb);
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
@@ -258,9 +258,8 @@ static inline int liveupdate_register_file_handler(struct liveupdate_file_handle
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+static inline void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
@@ -269,10 +268,9 @@ static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-					    struct liveupdate_flb *flb)
+static inline void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+					     struct liveupdate_flb *flb)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_flb_get_incoming(struct liveupdate_flb *flb,
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index f3b7bb698d3b..f8e098858c62 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -915,25 +915,15 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
  *
  * Unregisters the file handler from the liveupdate core. This function
  * reverses the operations of liveupdate_register_file_handler().
- *
- * It ensures safe removal by checking that:
- * No FLB registered with this file handler.
- *
- * If the unregistration fails, the internal test state is reverted.
- *
- * Return: 0 Success. -EOPNOTSUPP when live update is not enabled. -EBUSY A live
- * update is in progress, FLB is registred with this file handler.
  */
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
 
 	module_put(fh->ops->owner);
-
-	return 0;
 }
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index b9f5d452a998..42c37b3c2101 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -476,21 +476,16 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
  * owner module (acquired during registration) is released.
  *
  * Context: It is typically called from a subsystem's module exit function.
- * Return: 0 on success.
- *         -EOPNOTSUPP if live update is disabled.
- *         -ENOENT if the FLB was not found in the file handler's list.
  */
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb)
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	guard(rwsem_write)(&luo_register_rwlock);
 
 	luo_flb_unregister_one(fh, flb);
-
-	return 0;
 }
 
 /**
-- 
2.43.0


