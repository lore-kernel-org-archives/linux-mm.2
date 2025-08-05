Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91505C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3418E0010; Tue,  5 Aug 2025 10:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C048E0001; Tue,  5 Aug 2025 10:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4818E0010; Tue,  5 Aug 2025 10:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA998E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 721AE114815
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:46 +0000 (UTC)
X-FDA: 83742930012.27.01AEEC2
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 80574C0012
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=it6owE0O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404004; a=rsa-sha256;
	cv=none;
	b=L1Hmp2MU3O/4SlDBZBbxzJeqKz2wgojlm765PszlObzWTeBycy0fTsHtpUwD9OEQsAhpoi
	TX5KzFRXRIo3QxyGURQuhtT6JEeIwb91Y3yuPSXaSCRzc2KB053dkIFLjXcHvXZh2aTQiw
	QNbyoPf1A4KBuTlvX1jUZSAszrqw3T0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=it6owE0O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pl3xBvbmXoSLjMyBTIqb051cyNY5upcj2qfXScxGTG8=;
	b=57vNfllgnuQ73ylG7k7gQiuwNZaQQs6NcHB3zoYJ+rCQWziRALmsD1Jqqz/w8ujR/9i1Oy
	My5XRuzj+6kZPXzvuPes+QvniJ19fWzYSjk38PvTpVKsLorcpuRrFoMwXozwWuyVWEm6sK
	5Xr8kL91Sdq/MArmOsLaTxdNURI1tZg=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55b8736b1d6so6108227e87.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754404003; x=1755008803; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pl3xBvbmXoSLjMyBTIqb051cyNY5upcj2qfXScxGTG8=;
        b=it6owE0OE1J53x29fSg40CDjogmlHRIWW17fZ7BjD3pRNRuXCmjsE+wlsGc0z1AdQO
         IolMhFcHP9/h+izpFWFNoPgWE7HFJc4x8ycLkAMvQdP0X2W3PDDW7pBxrY+HT0CbZEkD
         TCyaVhtKG+T/IZFQuwcT2bUVWUSKIIddtQV2fnn4Uk+snsS1X3+33HKcorwtIoR4GWCk
         7GpeU4wHQugoEF5h0eIY0rtnwbtmbSzEUAEKeY/QuqjAZB+vFsriNCrodqz5BsLC83It
         6y3c3hRiNaXRrzUYTNrwGQy0q5TFqpZPHC0AS1hPKPJOOFErTyoUFGfl0boFI8w363gD
         uElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404003; x=1755008803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pl3xBvbmXoSLjMyBTIqb051cyNY5upcj2qfXScxGTG8=;
        b=V8tqUkIT1c2n8VlWHfSXWExlWYmCTYCmGUbbZAU7TamMTQHITmCsOQMCA5juJ8EPCV
         0oSWJ1EzRP/b+qnVCBLSZ2BeCxufpsHyIHNq1240BAuyhIGYNMES3A2A2HFev5EcXHqC
         NAQFHttBiA6maP8mQ8nUrQ/Z1Ghc6rH0cnIyCFno7RDq3AR0fR1jZ+cxXtgHUx9eYEip
         SJzMx2mzQ2crxn3MNdsDnj1g/UDcnvXxKd5VEfQ2mbOoYzcNMxnTTBV2vh0JBCVHZAgq
         qgxJEahJrYPB1aXEMMSH0wCCY1k77pMVu+zNGcB0KNpTtj4XdRIt4hYpjqV56meL7K9G
         yYWg==
X-Forwarded-Encrypted: i=1; AJvYcCVkVTxEQG5/cEyQit41PQ3Qcqmw5URj+AbhfpTzbMQB1gbUf9V0o/yx3zWO8I4Ga1Qt3v+F/j0gRA==@kvack.org
X-Gm-Message-State: AOJu0Yz6hzd0E9BURcbA7pqp43cXhmajJ/azu9yPjF+c8W2mpytCEpuC
	Ci5n1VWaZ3LjMT7i/OdS5hmDMYuCCAORWCg80objFjDGgd4+48IYcL8s
X-Gm-Gg: ASbGncuJcesLXzTNTaEMx1pmwl5pmM1/igWrmrVTVNxfewcR8Vub1VXLxif+MGtlgzg
	tK4GAq8oQTTxmsTukR1snomIWr2BTsp16LzBKJ3Zr3DFDZ7n+pA7sips6jxxKv7nAEMA5x+7ba4
	U3yE3LaroSgiTaJImipN6KIBh3nJodItm/Av4XfehK3kJgXf9o2B6etm9kzbA/lsxlH+shPtgXJ
	+a2LPCqLjHKiw4oBk0uNgGJKicPaoWPDsP4LFJMmJT/heaU8E2P9tnQAkglJibszLkunLFr6HXZ
	99H6AwXMpnEkNVxo6DRpXnsj2K/GES+i4wSCcH0StSCl4U3hwO56B+tU8f8FBSl4yxA/w3k43Af
	LVT9OBHb9atLpMo8mfS2YAJh/UOpK2ns5odO364v7cmFpVaKfyEhytRH1NIJW++jCOm83/Q==
X-Google-Smtp-Source: AGHT+IGVveeqR4Cp++JX2gYkKHclckYO0JnGR061NIJDmvQ7jhspWng2d4EVRtNzF0MnSLGE8X42Dw==
X-Received: by 2002:a05:6512:ba8:b0:55b:8e3e:2be6 with SMTP id 2adb3069b0e04-55b97b2971dmr4253074e87.24.1754404002655;
        Tue, 05 Aug 2025 07:26:42 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:42 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	hca@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	andreyknvl@gmail.com,
	agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	trishalfonso@google.com,
	davidgow@google.com
Cc: glider@google.com,
	dvyukov@google.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	snovitoll@gmail.com
Subject: [PATCH v4 6/9] kasan/um: select ARCH_DEFER_KASAN and call kasan_init_generic
Date: Tue,  5 Aug 2025 19:26:19 +0500
Message-Id: <20250805142622.560992-7-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805142622.560992-1-snovitoll@gmail.com>
References: <20250805142622.560992-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80574C0012
X-Stat-Signature: 63rtk151uie16ohzwxdmaas1ir5sjpjx
X-HE-Tag: 1754404004-342562
X-HE-Meta: U2FsdGVkX19MEJw7IGW7oWspJ4CVQ2sHO7+T9FT9zwXrXpZtKNhF2bx1a8An0mNkMgz4jzXRVMHGEYKq7d+zpO96cGZ7anwijaxKRmYDIT/5FWKYf6waWgEHdbGu/kmsBxo1d+YuPiOIZYTMsqDZgz9JNV2jAMxJCu0RyTqSuLFjAD5999mtlcZ3WQZfFFWPOmqEXNZ2DBfdHjvreFGe7lz5WPSmbpwPOSx7vaNVKggKLS+4Q1Jasn7LWLbfTi5abqZk77ChI0xokwhMKAODbODxVUa7a8ATQe7VAjJ+oTqQG2s9WBVljKyxIOxL1uooHqsMLtaPSUoOecsXEcwWIkgaDN0IFv6q8FrB1VrB4Z7lNJQR9Aq4qHUh0RDVmp2PRXfaO/MEpSeLbxw9QAnjEJMKZJQWB1D9Q0EjW5pIXdCk8d9SDGDGi82nEA4uILfH+5CBm6+WP1JVrOnMGl6NaohlmG8a7aOd2nrRuk16y7/mRxMQbkybWqBCDIa3fLwbVJ/7XuuJhPvFlqWFhygk4jMq7GwwtqPQ4qf9VyoSR9SQaCx6JtCYNUPPY5ZyS8uMtBlQXap86+yakk33OSO9nYQNCHM4lpZ98UAkuzzJ696KoJpKEG6URcMF33eEtIz7SSbSOO1VQI5+pE55nT/L4+o9mpRIbfie4rXOIOP1HElOwt0JcPZegoGgfAicJFwKo0BToINWt8x8qmfvzWoRrW6ybxv/tic0W0PseXUMgGf/2x6OcmVki2SDg+lm72yXN4/KKcYx9Jy5XeIGtgrrx4FGby8N9sBf6S6M3VWCsB462pIB2wPY+F2LKiNWEdlxpFESaSd9phFZVJK7UvuBmpTK/qbfQm/Pe7izEw1T/XSCixtaLtMbWkpwbwZua9s4N8IPEu/oo4UdcpqwuKZKLduarZN4D7VVm4KItiUqDLwU0e4I1Wlf37Z/IEzmd+Gbkbhv7SxKJ/75KbkwJRw
 KyRj2upu
 81eNb5WW9GyO3n35STL1fGwOwCZFWVW3T4PrFq6ZECFg50kQSQcRod77vDugY8QdjdzmJmLsLvQj+4chxCnAWTyUihe+6jlyOTr8GUEh3mbe8dQAAUdwW9F5sBKhws/xc/QARIgQ+bVJt95FrxlLkss0LTPtqsa8nGG8jqSKx/BdEEOGPmQnE7c2sUMBZNR+Gt9ozComKgt2D1/14KVLTHSfp3g1+wNvZllwFk5y26QSrRSM65EMPdnjydR4E5YN30dpzK0vj32oRSibiyhQ1N/2RmE6whAFh7z0jZpAIeoBShxgWn+qcSinjps5dPSHju7XLMEZ1XaOVp2+3KT7AxEInxVPcHp2FiBZL9BxbFvC8mrdOuq/2FrvrFLNcAz0+I09qfi35F30hgEnpl5fdVMO518HtoyJslBPsXqj+kn5UwJIj7Oh9Y1uFp7h9/NnDRAVX55+w02xV0TNaBT+L4XX8/71n/aPDOMPQ/zfk/9UuRLHBD66+r2AG2axUVy6CLzh90wN0x7F+6+mn0QFeHc6dtfzpAY4m2RE1cUIBosmKBPCMxwK7h06RDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UserMode Linux needs deferred KASAN initialization as it has a custom
kasan_arch_is_ready() implementation that tracks shadow memory readiness
via the kasan_um_is_ready flag.

As it's explained in commit 5b301409e8bc("UML: add support for KASAN
under x86_64"), if CONFIG_STATIC_LINK=y, then it works only with
CONFIG_KASAN_OUTLINE instrumentation.

Calling kasan_init_generic() in the end of kasan_init() like in other
arch does not work for UML as kasan_init() is called way before
main()->linux_main(). It produces the SEGFAULT in:
kasan_init()
	kasan_init_generic
		kasan_enable
		static_key_enable
			STATIC_KEY_CHECK_USE
...
<kasan_init+173>    movabs r9, kasan_flag_enabled
<kasan_init+183>    movabs r8, __func__.2
<kasan_init+193>    movabs rcx, 0x60a04540
<kasan_init+203>    movabs rdi, 0x60a045a0
<kasan_init+213>    movabs r10, warn_slowpath_fmt
	 WARN_ON_ONCE("static key '%pS' used before call to jump_label_init()")
<kasan_init+226>    movabs r12, kasan_flag_enabled

That's why we need to call kasan_init_generic() which enables the
static flag after jump_label_init(). The earliest available place
is arch_mm_preinit().

kasan_init()
main()
	start_kernel
		setup_arch
		jump_label_init
		...
		mm_core_init
			arch_mm_preinit
				kasan_init_generic()

PowerPC, for example, has kasan_late_init() in arch_mm_preinit().
Though there is no static key enabling there, but it should be the best
place to enable KASAN "fully".

Verified with defconfig, enabling KASAN.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
Changes in v4:
- Addressed the issue in UML arch, where kasan_init_generic() is
  called before jump_label_init() (Andrey Ryabinin)
---
 arch/um/Kconfig             |  1 +
 arch/um/include/asm/kasan.h |  5 -----
 arch/um/kernel/mem.c        | 12 +++++++++---
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 9083bfdb773..8d14c8fc2cd 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -5,6 +5,7 @@ menu "UML-specific options"
 config UML
 	bool
 	default y
+	select ARCH_DEFER_KASAN
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CPU_FINALIZE_INIT
diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
index f97bb1f7b85..81bcdc0f962 100644
--- a/arch/um/include/asm/kasan.h
+++ b/arch/um/include/asm/kasan.h
@@ -24,11 +24,6 @@
 
 #ifdef CONFIG_KASAN
 void kasan_init(void);
-extern int kasan_um_is_ready;
-
-#ifdef CONFIG_STATIC_LINK
-#define kasan_arch_is_ready() (kasan_um_is_ready)
-#endif
 #else
 static inline void kasan_init(void) { }
 #endif /* CONFIG_KASAN */
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 76bec7de81b..704a26211ed 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -21,10 +21,10 @@
 #include <os.h>
 #include <um_malloc.h>
 #include <linux/sched/task.h>
+#include <linux/kasan.h>
 
 #ifdef CONFIG_KASAN
-int kasan_um_is_ready;
-void kasan_init(void)
+void __init kasan_init(void)
 {
 	/*
 	 * kasan_map_memory will map all of the required address space and
@@ -32,7 +32,10 @@ void kasan_init(void)
 	 */
 	kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
 	init_task.kasan_depth = 0;
-	kasan_um_is_ready = true;
+	/* Since kasan_init() is called before main(),
+	 * KASAN is initialized but the enablement is deferred after
+	 * jump_label_init(). See arch_mm_preinit().
+	 */
 }
 
 static void (*kasan_init_ptr)(void)
@@ -58,6 +61,9 @@ static unsigned long brk_end;
 
 void __init arch_mm_preinit(void)
 {
+	/* Safe to call after jump_label_init(). Enables KASAN. */
+	kasan_init_generic();
+
 	/* clear the zero-page */
 	memset(empty_zero_page, 0, PAGE_SIZE);
 
-- 
2.34.1


