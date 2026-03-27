Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5482E10BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06A96B00AA; Thu, 26 Mar 2026 23:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF67F6B00AB; Thu, 26 Mar 2026 23:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7506B00AC; Thu, 26 Mar 2026 23:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3EBF6B00AA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 760261A0BB8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:49 +0000 (UTC)
X-FDA: 84590423778.20.4B4F38E
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id B1DB214000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WY5ApQYt;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WY5ApQYt;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582427; a=rsa-sha256;
	cv=none;
	b=kPWAbFhXbpvsjGgOpVRoHYuuidiqiGfa+zqrxQ7v3p+GlvDQgJMPIe80wcw1rJHDcTrXrm
	xXm90vkeo6++YykBJECIYkF2XcLYoPX8/jIFJoYW22Gkns/rOnrI606D1zdKA3NT6/OKEU
	76ZfUGvmi/6+vidxva46FFiZhY7h8jI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niK9b97p+Uodq6B81NUl3qD7iaGbf0m6LGlP3YYxUso=;
	b=09vAs7kzKizY8XMWLkQyUGuxDxv0JoNPou9zwoN+Kju4uDCgyNJcYRwMfd8wncYedan5ni
	ZMcuAg8B3BP1pbV53T2EbdEGUCeTaT0q24Y7kcCncy/UwhRRx03c80dOjIErNCPdr8ieNN
	JOo6HIKVRa6l/zVZ+s0ZGKzNxWUv3jY=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-89c43c4c383so20467576d6.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582427; x=1775187227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=niK9b97p+Uodq6B81NUl3qD7iaGbf0m6LGlP3YYxUso=;
        b=WY5ApQYtqbt+VIos7oCxRgZXp+kkwJvXns8nhi/GaAGSK/Dd/LOSboJipO9LVSp0Ce
         sloKGv5PUeQSEUKkO4P7B2ux0uY3eb9UKami4+Y970uT9HmCetAkm8iSpKCy1AldyO+B
         imW57fgfOkNKQZ86KquJjwMp+IIcan1oGF5v71wH/hKTtOuKte8lSQtzKSVO0Ea6XODQ
         RDlY55LkULCPIyfAXrItKIdGh8AUfU8gVJrlOZgOvF31TfVnLNYoIdFcsy3yrqGhNZ0G
         C+3c2PeMRAPbJuvKkIATe4zJLyNkuI6lfIhfrHJw9ggXFO3psnkwvZmVlPs1onmPbCFh
         gwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582427; x=1775187227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=niK9b97p+Uodq6B81NUl3qD7iaGbf0m6LGlP3YYxUso=;
        b=Gl5oDA0ccsx3Flx/rHC/EtuQ/DOtG//oWlq07ASFc6StMulNp04ko1qzSIu4npj1kF
         Z1chNYH/jGlmJjEgxKxCnE+raJdiai4JrdCD8dc3X08YFeX5q1/XafcemHlEdDbQ0Ve0
         pocZwR7NKMmwHhrp2JSSlJ2sUImB1pn2U4cbXQ87HXp5Bg/3kDa5S/680mJuLwlvnKRk
         egR28uiMGnUHQCqUN+laFWCsjdKYDhz7tMEnou45cfMjUCCiFQfn4nwQ9O1tc35fRWGG
         ZzkL/T9aqOF6HM3ZMLRrccXfCUdr48aj4T+zmlWqoPeLUq4m/p3RymONSKfPkIm95zF9
         DC1g==
X-Forwarded-Encrypted: i=1; AJvYcCVDCn1T7ot12cNwtsk3JMATKc853owEcxuhh0Kt3AqnIfrPhKfqPosrcIDOgSRCiC/nTG7krE5bDA==@kvack.org
X-Gm-Message-State: AOJu0YxwOiXwjU067OJP4gTUNpCiENKr7K4L+zZmmJypLkdUvJEsz6rK
	od6DchBko4Hb3fgIYq6MGNOpvsUSDPEe8/cJi9URV62CuhaNmiaTZN4EWgOTvxCjSSg=
X-Gm-Gg: ATEYQzwTBm25i44Htzv/52RAgILdBUsAbcnW6O/j8k6VyaEJCix3pisn1QahQXMC2RI
	6n4jxREW9Fx0UNecKB0FOVGz8PyPL3VTTO7KeMFXBBAiSBp/Gy2NNZWMgjszHXf8TJRMq6QKxnW
	wt9fD+eXJfIi9YTW8J03vkEgeFIsAC0AAisWBnuRfyv71/fmMWsgK2pAVK3qMzsSTUsPtX5FQAV
	Iwfxeu9h0zagtIS7rxeEA+onpN5fwx3I/Oa17CPQEgl1mdN+j180oqgQg9fkgl5A/ijqsYnYz0H
	JVQ7MBnl49xfwN9TL4SZwUvA7hlmGg1Eks2QdOVaeBMVKiQG4hfcI1NGG0r6oSHz+mx8JxrxFX3
	3mJsesxha2KNG2eWSKqURIBx2cLyINNOviteL7LaON1WhISqchTaccOt9HMxp3zOoqiEpf956oI
	oIoIpwuIDu07BiUZgZLZDrF3AUREQDeXaiM8seoV0A89xW8HqsiUSyOcsVKoOlnPvrIw==
X-Received: by 2002:a05:6214:2b0b:b0:89c:d592:3a97 with SMTP id 6a1803df08f44-89ce8ee0c69mr11196086d6.30.1774582426820;
        Thu, 26 Mar 2026 20:33:46 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:46 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 09/10] liveupdate: Make unregister functions return void
Date: Fri, 27 Mar 2026 03:33:33 +0000
Message-ID: <20260327033335.696621-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B1DB214000F
X-Stat-Signature: 9ee3pazfmnycse6dcmi5oq8pxgj4pa35
X-Rspam-User: 
X-HE-Tag: 1774582427-264020
X-HE-Meta: U2FsdGVkX1/DvhQEc3r/5W0FKS5XRHkdx9UdlirARs6ysvyg1JcDrWc0usk8q7Vy0TNTNi1yxb7nDpWgmS+M5GPgAc5dOPfHuhdI1qGejsjXb7XYB6UGfbH+JneMlKAcC+WtlVBCFP+N66gGAQsTeaitUHJrShP+dTEDnBcp39d11m+vn75Aq7jM1Gtel56hmm/hV+rC5zWHnRjKxULXLeQ+Di7vPIGwnT4HBmXpj5P7j3SLIlmBNzY+UG1O9lc9CWbuTEctzol3kUzEA+zn6D56AVBQ7vt6i8YAPiAMGYakXA3K0tw0Se33+gRLpXr86sEj98ggPvl7gBA7KFbzczCgTvMRQikmakcF+U5i1s1t8uPr8hhbMlRwiwQtGcoRvrkjidGeAToHSyWCBtvE46ONXKe8G/H1SEKqYt82RoA0YshWobe2x3xs8twSiTyQolPyDYQ1+6Am1X3MmHwLwSXh1W+DnfL+VpQWJ6eKvY3JNNuU5OH2ATDgSsjukel64kvEeQ6QYpAHzMPDqCfNorwrzHfdNNMsBYaF5ZaI6qhCvYdy8LSCFHj10uNZ9O7UNfohd3q8nC11ahbyuvw0kvwtG2BXGIqlg+UjK0HaBbpkzhEvxI+OXiOGU0jMAWovMOksdrPJvFGtRrn7MueDrycAnwuN7g9sXf2DxGaPYu4laMM9tfxum0CdD3dWKXBDhIKwmGu8ukGNBOiknf6+SKu9NmtKfjxPlVyp1DZ7oGzF7D3ZfM0Htnvwp+ZIgAOuGsRebgwnWo6VwH+TbzNvTAR1bijwxsVQDFnAoH2AVWOS/wFX9X7Zzphws8MfnCu435Iq7MpPBhLDRm7WotZ10MFcfV7iK9VyYUDb6hhLawb0seK9WDQg3mObFxcoIQs02YqUz1kF8rCY9f3aQLVchxCfZKoDIohugmX69TPHz9uR4SrKBcy4iTs6Gj3E4mehsKsR8lz4N2jlVrBrlGo
 HvTYTaGU
 kXWxlBoKMq0zaVL1QuO+PwUChJ1t6KnIGlrHM+toxxnwR54KK/7RYE9umjH3W8qU/CNUF13NHSJZiv5RLvnRLrfoNtjdyMlt/F4kpwbbjclJp1g5bF2wWid7OFP8uxdyiuH3wGthEKbBKixrU2Zr87T0YdYBn1xm3j93GjBjZtZdFeP6jBvwPOxeW7MGFdIyzFHgj0Pc6e2QQoDVNW/luFPgP4VDY9zoJvgRqcGH5ALUSi6TS5C+EFcLi3KCiO9v7whk5X1yLYW8Nu+YOVr8HCUiyGixbfs5xlOIOUUu8Vk991/wcd/of+i75rqnxq6N5/gOynEmMLGfH6Uhv7k4kph0d7uTZWxXbQXFn8zjJnowQVwgXnM4WEV1UkX36W6wRKKTH+ipswWAlKha3VsOprBRBxQ==
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
---
 include/linux/liveupdate.h   | 14 ++++++--------
 kernel/liveupdate/luo_file.c | 14 ++------------
 kernel/liveupdate/luo_flb.c  | 11 +++--------
 3 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 73ca84de3eae..2ae27711ac41 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -229,12 +229,12 @@ bool liveupdate_enabled(void);
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
@@ -256,9 +256,8 @@ static inline int liveupdate_register_file_handler(struct liveupdate_file_handle
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+static inline void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
@@ -267,10 +266,9 @@ static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
index dd55e5e74d69..761e8f7cfc82 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -884,25 +884,15 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
index f8348138de70..8f3c9c63e320 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -492,21 +492,16 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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


