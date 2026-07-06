Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E956C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6076B00A4; Mon,  6 Jul 2026 12:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDFC6B00A5; Mon,  6 Jul 2026 12:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBDF6B00A6; Mon,  6 Jul 2026 12:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0E756B00A4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:39:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65D1C1C6C5E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:39:07 +0000 (UTC)
X-FDA: 84958911534.28.F6EDFD8
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C55F18000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:39:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gwv1mqGJ;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783355945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUdu/4xkrp4af+ENG/+dz/iliEwP+6UzwIHbpWo5uXw=;
	b=JGKyZ5NWHAc2DevBA4aAqad91FbJy2qLhF22WQs7l8rWh/siONf1KhgaINVepe1EsMZT9v
	4mZ7aSa3vsFFxFtXsE1W6RXeIpVD37TtbDwHvCpZo6TLVad6OdTY7Sg5nZZosbqBxQxQ2c
	Tqmr9WChdvHC1UIv8X7RixmNBquyg8Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gwv1mqGJ;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783355945;
	b=6r9wV7+UqQITfE9jMq3LOmpSl5C7mWI//qezvgHXEKDQzDVoYklGB78i5Jr7y3V8EN09BM
	maiQycCihRUfrqndDAlwiainLQP9EFz/VB82WnL+5jpjS390tlL4dlE4rLW15RDg2HM+Vr
	DAwgAMGOzSZ54VYkJ02TlavVcIY9DAs=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cab973140bso40062395ad.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 09:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783355944; x=1783960744; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iUdu/4xkrp4af+ENG/+dz/iliEwP+6UzwIHbpWo5uXw=;
        b=Gwv1mqGJ0qD5bXIXnESFZPnn9wAkbyV3tZGupJP0Il4kBGKa1c5My6/XkDM2D4y8mi
         xrgt7+nJ5eFSMhNkVvercNwM1gATEt3ERhL7gU8BUL2+bNmFjdN2x+H42gR2udsdPMgT
         heweRop8MgJ/6hQ5mD9bBVMrK8VAr+Wyx5IEPrTK0BgXP7AvNXgboCkukQMVep/n3c3+
         ctaxURh0Kt8vdUbTK87Ulnjt6b72g8q2IKzIfz+cmN21f+FeKrZANASQTiPz3WMqCTWY
         GQEzbw+X1OM8ySLD0joj3gmarJQG/KivzPGOHodZY5M66kdS+JboK56YSzDTxT0dA959
         MUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355944; x=1783960744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iUdu/4xkrp4af+ENG/+dz/iliEwP+6UzwIHbpWo5uXw=;
        b=gF0cNJfBKUWdaeEx3/PPSreoBzKQHuWR14ZEq114r+zrajifC3alToMUAaJfRfSCt4
         5pEhOS5Q4lQeIyVQaRWKlCACorU8Hds7UhZgLU1nrpPYmuZwHpU23F4m9R9AFMqNsObh
         3VxBk7LcPeqC3puBlrvUXpp9A9eyR2RZv1HiDHjiaAG+Aakq2Q1ExgOsiC2P9cPfoVqS
         NSB6cQSJosQP13iDkbbYb5y3sWt9idW+hGFI3aOGRmzeSymGk/jwyvTHL4QW17hQCUvz
         cewWqwLvWFzSCEfcL0ubrM2J65M5+oSOjqCsTIqgi2SxeoKnnDLZVFcpxeXTmBEL9Tqb
         fO/g==
X-Gm-Message-State: AOJu0YxxFWEfw5QFBt/waaNfW0ZrgT8QIvmpD9bv329kmG8V3oyFF/Y2
	hdpBp9mNNEgQ70sSfe7Kc8nuopYmzBisQxgeLgbwr2m9qFc921vGO5SE
X-Gm-Gg: AfdE7clnJuf1wCeClRUDyX2xTnErfp0EXADR3BJ7167zNC8H/4TAVVSjP/lyj10Kais
	g+CtEwUgBJJde+fymYBpM8r6fZNbZm0p7GYSjkdyPGHzBalwHstqzScHZWh4aGpHZB/mN7xUPtI
	yGPZ1t7LMZbcKVXGt2IoiIqIO36/laXJ6Srjvc370iUTpp0G0bW2OOCR4Hfx3dBnWLowl1sOJeV
	lnIVtEqdXqC5SSQl+j8WUGfCoNx1sJ4w1ezk7lYoeDx6Bs69d1LS0mt6d5ohJQ2Ho3CLAMAxkhd
	07OgxQPBm96ohfIw+J47jgHliZJfeSnLtkg6W9mDTySwo0f4o+IZc5BuTj6ou4ov8lDR1KFy76G
	m7JxA+NKsQhoDwRTqXFNdo3ti+fzjBsvLrkhauyz4Y3LqWrgCCsZdHZqWOuf3aZVOZ9oItp17/Z
	nZWjO8uII=
X-Received: by 2002:a17:902:cf0b:b0:2c1:f262:4962 with SMTP id d9443c01a7336-2ccbe7297fbmr13433165ad.20.1783355944425;
        Mon, 06 Jul 2026 09:39:04 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7893a8dsm53103305ad.73.2026.07.06.09.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:39:04 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v2 4/5] xtensa: remove unreachable memblock_reserve() return value checks
Date: Tue,  7 Jul 2026 01:37:52 +0900
Message-ID: <20260706163753.193875-5-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706163753.193875-1-ekffu200098@gmail.com>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C55F18000D
X-Stat-Signature: 9fffw54673c35x66c3sahzq73jkq5h1s
X-HE-Tag: 1783355945-494720
X-HE-Meta: U2FsdGVkX1+OwkvK8Fa365gZWQaJq8P9gAIZR0bvmU0mqF7RYv+ZGMHKLg0JtlAopUB1tZ7aW/oPTmNvSUYiDImX95L6umfm/rFssTzFFSrkSc0fS6m+b5rzYVx7Eie8pwy5u5oXdOifbQrWwrBEO2e40Mm21iRzy15RTGwsDa+ESotRSvOULu0rInwLgGYHUVFJQXv3l1+ZkU81p8/8Yw3AvP8uRE17Nh/r/rugDPceduyjR0cqb3AbGeQmOJ/+gXn5XpGtfyige0WJX4R2FiGP1xJ1oGK4/Jcf1M86UIhr+6rjKkTdUPqZ9v/57TOT5u41mPp92nLEEWKZqA0mO2j6vlunJ/ZTVlUoufgGWG1YNY9HMsmLkMsZCK4QoZM0OsZahfQKIasCzbYadoEAaoNziq9oSE/lTXnp4kOnP7fI+jWZB5m6q4T5yWU31Sfl7ZrfGUfqrBxpwsEki8myjT/HZpBfNgxO7I2AvcB/ddAc0wa2RLoUPiwouLAyey8VMUULKsE7sHlDnLG11NllcRjr8JSZmP8xogZqFWE8c+vN43gBBudarGbGv1G1iUQnD1yRqCx/4Q+ds2vSJphXB1XdBcMoVlcStas1wlUpFXiS+ECEGXIgH74DHTVrW7+MEDSBQcLLxr4bfmiFY/kNIreXoYKF8Cx5kR8d5Zp7J4Ql4Fo/T2bc7s429CHEEU3G30CYxKrsL6n9UJPYL/D6Pi0fZuoFjA3Qb2RjBhoY1TeOGKQA3kvCU4ay1M+Nm0bGwGKwXVWeI5armMFuP4+BZssVJO45CcDIWcGZmtxnmEb2JecYM5B6ku9JQkeBOFVTaL81dPGTJpAiotvmKrEwzhF1ezSr4T/s7buTLKqSpGwPBJFHThElaT5u9GrYHfRDfl6MchmBp1gEJJhQY6Lz4D8V+BS74/UTW8jmYaNHqBDnXBml7aPmNpDlnJ+jIbdHUzs8zOcbzAK3xw6/MdR
 5anWvDR+
 KR4n+r+cAZ+Wu3j1ge8kWryJNeaq0PRcXMeVi2Sl8cxJY/bd+KF+EuxDq1FcjrAKScZviXCxX/NHPgzy/vv2mNUogbnhn2w7wWoGIbu3hNR3dCNq0Lm1Zis+FJguf9xxBPIO5mYOhpnAgLY2KyGykSEt3rh/8UDGp1GfZYkhfZeFLSiaeKtQnchk3L5qVfAfHfyDzjAL8nK97IT9bLlO5+8aTKCf/YaC/QrETQLB3rPd/Xq8Htfy3TN/mC93P2I9xNfguSwXUt6jik53AfV8IVoqadP/wgt/TlcW+/Q8BhhlSkyDRJlRsegDSE2VLd3RxthIgXhkc3mfSuw7+mO9xk1RlXQg2MncnlkRYFSXKcgcPelF5zYfKDoSNpYE3XkOPkQ3VJVGAlMhGxENt3MR3ddeNSEQoV6Fx/lZQidX55ZPS1cw8l1n7DX/NuT/JldS8fS8siqhfShFF0fI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_reserve() wraps memblock_reserve(), and its callers check the return
value. xtensa never calls memblock_allow_resize(), so memblock_reserve()
either succeeds or panics, never returning an error.

Therefore the return value checks are unreachable, so remove them and make
mem_reserve() return void.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/xtensa/kernel/setup.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index f72e280363be..c7367b81cc36 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -268,10 +268,10 @@ void __init init_arch(bp_tag_t *bp_start)
  * Initialize system. Setup memory and reserve regions.
  */
 
-static inline int __init_memblock mem_reserve(unsigned long start,
-					      unsigned long end)
+static inline void __init_memblock mem_reserve(unsigned long start,
+					       unsigned long end)
 {
-	return memblock_reserve(start, end - start);
+	memblock_reserve(start, end - start);
 }
 
 void __init setup_arch(char **cmdline_p)
@@ -290,11 +290,12 @@ void __init setup_arch(char **cmdline_p)
 	/* Reserve some memory regions */
 
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (initrd_start < initrd_end &&
-	    !mem_reserve(__pa(initrd_start), __pa(initrd_end)))
+	if (initrd_start < initrd_end) {
+		mem_reserve(__pa(initrd_start), __pa(initrd_end));
 		initrd_below_start_ok = 1;
-	else
+	} else {
 		initrd_start = 0;
+	}
 #endif
 
 	mem_reserve(__pa(_stext), __pa(_end));
-- 
2.43.0


