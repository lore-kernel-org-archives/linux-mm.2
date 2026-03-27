Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F144810BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B876B00A8; Thu, 26 Mar 2026 23:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3805E6B00A9; Thu, 26 Mar 2026 23:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2536B00AA; Thu, 26 Mar 2026 23:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 002506B00A8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C82A85D6D1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:47 +0000 (UTC)
X-FDA: 84590423694.27.57A6A7B
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0C3754000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AdEYgOrv;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582426; a=rsa-sha256;
	cv=none;
	b=thO8EOiAgUCoKxVwWtQ9KIHfI9ruPRi5IWFg0h5gzyp4z0m9D6y4sILnfqzvPbkTVKmPDH
	sLDAbe8cqh6whFsS/XBAx6g6F8hL6mKcyOz3aBd2BI9aJT9dpUdqIR4z0MVVuVEPPBGrkj
	T67v6DgAVAPVO7KZKb27DCDtZQoR2+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJqonmTTst2Q8Xhofg58ZntO/52vNNR445BtBTCxCrY=;
	b=6jWz8X9zpfmnKFtDjTlA6uHJq6IrY8VP3v04QAUD2P0LgEiyFsgFNyOwYmmp7/pV5jUrEh
	t24GZB3KRkshwf/XuIouvnKA3h1lrLF5EOLQklTPpUf1SltJ05es4fNfadgVo+zPfLCI+4
	GxY+ziNhyfH7QMPV8z2ONmehOMT+Wuk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AdEYgOrv;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-89a0ecbc713so19512636d6.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582425; x=1775187225; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fJqonmTTst2Q8Xhofg58ZntO/52vNNR445BtBTCxCrY=;
        b=AdEYgOrvjJmLGpzOCHbFvuDF8IanBDU9vE/2023aHepx6T+28v/VBtTGZSkPmOkak9
         F6JaqKcLJQpcdywvI6cUERyH8Rmh7qjrpjZui93JYI+ranYMqXfyrHYyzBHy0ieRKbyz
         GwqeeOXuPo/YVrbFtGv6Axn51XSxsZwKmYfPLaVOzgbd/RmXti8s5euZm2SrWs0Jl8DC
         03kMNUIU3bV5AyHtz91EcU+6e7ulSZDbgmDLwOz+fpFzB3skBRMRWBlMNGrqqyaUy2aK
         MJL0pbGFKjTRUizyIvTL8xVPOA9dsUATjiYAH2FNM3u7E/RRhRoxc5Y61gtzhAUv1VOl
         0D1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582425; x=1775187225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fJqonmTTst2Q8Xhofg58ZntO/52vNNR445BtBTCxCrY=;
        b=dq09QD1Ei5HCa1iOcLitfPpBlheYn8UoCDUCYqwhjUunZIN9jJwRf5my2R+uBKEkty
         M+x7eIHaFquKZTc/5ic9a13Yoi/4RQFoLfZXbbisTc4VhKQXcvdH8bRLiVK8FB0EBAjS
         EVoitoEchGkJyKFIqxG/2e7cLJLc9KhRxRJzlHbbnNt5enCCBmMeP+7YKfs+MWgdmVCk
         tto5wGU/gFtOuQjtFVt1kGFQAGBDeSRhqT+IzUaTs0cg6ByxLaqEcyNCTJJ3Rcs+wKfz
         HRaZCEIvBbHepsL/P3FVFfj+Ggc+nKOf89Lc+lipeK8X73fb4e3jLCU1Lf5dcF4CMrPa
         jVbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6sDFio8jBTFXHI825z6mARkBV4NAnDAYq8uI94ncqLQlOiR/4EV5aeVhJbN0MR8kqvFmvyzLYJA==@kvack.org
X-Gm-Message-State: AOJu0YyHEMEfG/EY5hYVpwwZHDtX/S1zMEOUAyoNn+Wy2IgpUSWdBJ32
	Lt2b395RgiKfPd5SKq4BJiL01D6lr8uHymrjnsOcmR9mG9G8jwGS1o7WbW2Cv/5F/co=
X-Gm-Gg: ATEYQzwfnKOYhudVEFhrrNSgKsN5B076efep/pr5mAKECMq+UVclT8XkHIv3nMM1UdP
	Mg96+slXtTJCQUrIs2GilcaT5kTbmVg4Xth3FmXF6vziAoFp8+Wg0EbVwgkst+d1ZBWvjipED7N
	/SFJ5vE52dtIYwXMDQYuhUvM0hMiu0+IaaOSBYfAktzpemq7lNDyw3RHfsVOCvBfs7xER0hChbX
	Sc8tLF00T28FnDUSOPAtYp5LMnkuWYes7UJhPDraz/buprwjrpJWbHbPLBcrb4JK0GWtzAe+sXQ
	XRDo5GwVJ4mOgwBHVo6LaJxSYvyaCgvy17c/tMSdtzTAcqvFh+/+M7YW/NinNGfvIepdMm41gdR
	PeUoQ1B7yHbiadqkqt9+Eg10B0qEYqYzdIrRVy/fDARhOdeQGLVkqSe6VBLj4uNt0MWM7Ha44Cz
	VYRTzj5AdXYOwrvk4dsWDEdn/JqOI76+LA6OlSibq/NzOrxPZC2CEjW0kLMaETUte+sw==
X-Received: by 2002:a05:6214:3d9a:b0:89c:7ba7:c081 with SMTP id 6a1803df08f44-89ce925f8c5mr8627426d6.25.1774582425218;
        Thu, 26 Mar 2026 20:33:45 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:44 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 08/10] liveupdate: Remove liveupdate_test_unregister()
Date: Fri, 27 Mar 2026 03:33:32 +0000
Message-ID: <20260327033335.696621-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C3754000A
X-Stat-Signature: kie6o144y7ca8ikti3c1bortqi1irq5u
X-HE-Tag: 1774582425-650955
X-HE-Meta: U2FsdGVkX18fI/Xv5QomloBjLZ7qcsOLHByAcdlZJ1VPdoiCjyxtZc63gHn9+nkNTxwmcp1tDEn+z98QVjoIsms++M4eTnCoKrhHylrnWBiSCJsIQzrT1UjznO6ER2E92Fl518OMmXNc81SM+wrfJJsHP9D6hbjD6ObXvWw9AhQpKQMb9gH//qbdrQjBKVFSbjpO4697CVzxj2UqlXzZ+7r3vqiDEBBbqM+kBeM3T+wivQgzwUc9QBgH+KSmF5/DmW4zu9Un518sF6H5SjCAgIjdlNqnRLU0cDCO+MVYDjJI3Oei80X7LvJcUmVSmEZ4yOT8TTGyXBjG/r/50JMAX7QqTXofPzUTCUkMo2AeDEG2Hi7B65FA5sNHVMgiinclPX6zezjJJE6g+erqL+maURAPlKXbE0Oc0SPTbA7yukmaHKc1jAl8y47Ybwn21ytMoWNJUA9yMPFA36OhnIwcYcM+Mcxv7J8/JTzSHOE68TtLdhYSWdx86r+Y4PL2G4TA5sRizpLjJWuBEFT1d0lKrKaLVnkwuhdGOjwTRvZWwUj3VsiGivORKR0Lo7z1QDy6u9YZXlMIsrXKKXG8M+ouRhMJ9bO9q7R0D/DTWuYjGVpQvr92aqCeSK7FsNev60StXOKqrd52RpCf7cVSFU/tD3jAETs2MvSmVgUjOmiBxxYoC8V10BwfDapdYwG9JvH+XSotDO10clQwoYOkWi9FgOj0aDO0pa+HtYIrqnMSGiiQLaMhvO//X/5FLvJ6fK720tFlDrEYghyEb+Umyc2wwPjpLr2l2Ks3KVkyN6DXN9A2B0Zj/GNYWqX5V1K2qXbAz18FjBbS/aI2cIKUiCHU8uKv1f13YI4Ir/cWlgP+tSdjcbVFyC3uWIGDSfFWHEvjYWsQUHMK6z7xsEEgksCm+JaJJpaYIoGGT6AQ9FV35kA76vmXg+rKaSRXeC8tVegxwIcgIPPQI0UchK0xauq
 EfTPKpDK
 DpUMTZQZLNZ+2EYXZfPA2MndbpZS2qy1cSZ+c7QanzzL0QS46a26aK0kRsW3e7rYBd2W3lYc+0CnK5ROQVGL5i2q4BCmVXqbWZcomH87LqLrbO5H8v0IPxX9NlxEuAWWjazZiGZQsYnQiCU+5YIY0RwjTPrfG9jVs1bXTh5j0COP8fX/9NCYgaweJz2ZXTM2XyXnSxi12HSRQByYbPay+5oSrAduvCi9PgI2B++VRNp4J1lkMctkyT8L0c39tVcgPIoOvkGO1WTmYgicIoU0bL7lI8atFfCD+/nGQA8MA3Ov14/akAAj7ZusCy73JrgLGsVXtNCT7Oy2ZZmxeejWq5Iuhc5uBOtjurjH7Dd2p/G1RCcZC0Aca3j6jGHVoj9LDGSln8Jfni8Ij3XRVoUK52QfldUmDAHpir4PM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that file handler unregistration automatically unregisters all
associated file handlers (FLBs), the liveupdate_test_unregister()
function is no longer needed. Remove it along with its usages
and declarations.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c     |  2 --
 kernel/liveupdate/luo_internal.h |  2 --
 lib/tests/liveupdate.c           | 18 ------------------
 3 files changed, 22 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 80f4e3b796a6..dd55e5e74d69 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -898,8 +898,6 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	liveupdate_test_unregister(fh);
-
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 22f6901f89ed..875844d7a41d 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -110,10 +110,8 @@ void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
 void liveupdate_test_register(struct liveupdate_file_handler *fh);
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
 #else
 static inline void liveupdate_test_register(struct liveupdate_file_handler *fh) { }
-static inline void liveupdate_test_unregister(struct liveupdate_file_handler *fh) { }
 #endif
 
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
index 496d6ef91a30..e4b0ecbee32f 100644
--- a/lib/tests/liveupdate.c
+++ b/lib/tests/liveupdate.c
@@ -135,24 +135,6 @@ void liveupdate_test_register(struct liveupdate_file_handler *fh)
 		TEST_NFLBS, fh->compatible);
 }
 
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
-{
-	int err, i;
-
-	for (i = 0; i < TEST_NFLBS; i++) {
-		struct liveupdate_flb *flb = &test_flbs[i];
-
-		err = liveupdate_unregister_flb(fh, flb);
-		if (err) {
-			pr_err("Failed to unregister %s %pe\n",
-			       flb->compatible, ERR_PTR(err));
-		}
-	}
-
-	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
-		TEST_NFLBS, fh->compatible);
-}
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
 MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
-- 
2.43.0


