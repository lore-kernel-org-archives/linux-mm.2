Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AE0C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC95C8E000C; Tue,  5 Aug 2025 10:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79358E0001; Tue,  5 Aug 2025 10:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41248E000C; Tue,  5 Aug 2025 10:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D25D8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 504A81358C6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:37 +0000 (UTC)
X-FDA: 83742929634.20.1BC487E
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5BEB01A0007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AtcYQDAe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44Cef9kvp87sJdDYN0I0T3XW3v08YaC6etU0qwyWC00=;
	b=hCuGNoJJa5hgLGXfjn7GsKgguM4U+0W6v0XhJ/UjBzKt9QAA2UiS2WQpK1JfZaf67vp0mu
	w/WAlc0c+QVlSqMRWJ2lwmZGdHpIVfEeVMttfIogVH+xOlAzMRjRwHrmFwj0iVrEawIgFu
	0kE2mwyvfzaqzEwlEHKBUaESUAL/yPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754403995; a=rsa-sha256;
	cv=none;
	b=DPKh1I4ysx/mzTV0qsPVx6v6sJ6O4CDue8Ci31MMihnY1PiePCDBP+N0z37ctkr/OoDOSo
	jStiUAF9pNTameu1kRzhcynwS6EJNdUD9896vVg0vG1amxvsW0M9xTkUYFDpCDNTvBDtlu
	/yDBtydLEx9XGps7wgaRUXOFeLlPmqU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AtcYQDAe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55b859545c3so6105037e87.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754403994; x=1755008794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44Cef9kvp87sJdDYN0I0T3XW3v08YaC6etU0qwyWC00=;
        b=AtcYQDAezRY66aGvhT4zAtQLXAKP75myayCcM+FTvpf3fgwjWVWt2bwDdIdHaCtbQI
         PlFXIaqbJJhJ8QACkJq4/AH1A3TRqz0Getji93Un/dvuJC8BqMKFBqNb1UoCTuC0oeN4
         wG6Cxpe4AtZ+9fjtqBVW7yhh3+m4+Ng+neORYDpXUcQ4oLFtrJD/TdtpKDDjr9FPhfJG
         0vW6B1x8zzsLYfjtFTR10yOteFD1UOU+N4JKX+s8FLhJM7gpQFO3LwiZFGaw3vxXRVbI
         c3bYmQDPg84umQ+47BkFnG6BdUVLB880tgIfI8wzwoiwp/Ti1q6jEG281HLKAdeNpZuS
         r0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754403994; x=1755008794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=44Cef9kvp87sJdDYN0I0T3XW3v08YaC6etU0qwyWC00=;
        b=RXIexjueTg/nlODuFBakVaiSYZ3zBrglfd0IN7KSIJFYJIVeIvHxkL88Db8IPOpDYU
         nrcCDM/V23/leoneOpVeFhd/vTCKBQu0gagVaidO4jIAurHJ5V9c7o/Tq8Uy00GyWwHw
         +hDmDkJmOAtmXhEKIWBe5OfXFX4Iif6NCdHJFb7DeAUfVQQDD0iRgvW+RSUpl5jhwe2p
         WVEXC2/WVifrJ6BqPq/UQxsir8f61TAhmW6BItOiL4FwZZuVNode2XbdgIvQvAPMRXRl
         TKRPxVwzpWA85etmfJJWdo3VIdo49UmgcVLxps4zkDvKTGroO4r7d+gYMC6DmNtuBv1x
         JBow==
X-Forwarded-Encrypted: i=1; AJvYcCXll1TZZESLpMsLaol247wV7Su29mCMw5C7U/8Hkit+bazVoaPPN992pzXiQ5PDUH0A6+YJrhGL1Q==@kvack.org
X-Gm-Message-State: AOJu0YzBz5z+b9jJoinrmg6RuDrjcaP7fppC1/BBeTQW4ls0B6nv48yI
	gWphsGhLgQNA/SzZhzspTq9VpOO621fiqGr8Mn1myGk7OtSQZZ51s+Ty
X-Gm-Gg: ASbGnctfu8HuKO9aS5/EV21DGA86SnpsdDWcWt3HR3tqimxzwzJvDyT4ZKlgxz9wIM+
	cV5WIoQ5oE0DJpswo3yOdZw/AdN+xPvvfR/zn7Otz+PN0IPTJjGOOn8/pmUxBu7iRH2FnsQSdiX
	SdW5SNEhz7oQ0t7rZiTBQ/D+BvehlVncMj16DZIOrUL3ccI5wb1VfIVUv3GbXc8CYrgN9Yiitg1
	vKMbDr3PpUvhruH56wQJkSz+1J1UNqGeK/OzSEIPN/Pirk8Y3ofEA+NeQM5MWy534zvfWqoUp/d
	TvuRnRpNUHeQZR32onHmyjiQzW0vM7qjeqMyo/conhEERsP0FdhZcCwJYYvNCDmKd2i0JyAA/qS
	EoyrMPI3a976zwySgBpoc3faQiGS22jb1AOIfhEfnLoXSvkNYzSMmfT/CiNpaeZ2xTjldEw==
X-Google-Smtp-Source: AGHT+IG3IvKFDzWW1UJXkvwSM56EKK5Kb8nNkpLL/WnL+raFeiYW6aZ7Xti28XnaNJYqXW0SrOWKyA==
X-Received: by 2002:a05:6512:4023:b0:55b:81de:3576 with SMTP id 2adb3069b0e04-55bab40c2d5mr1298432e87.24.1754403993514;
        Tue, 05 Aug 2025 07:26:33 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:33 -0700 (PDT)
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
Subject: [PATCH v4 2/9] kasan/powerpc: select ARCH_DEFER_KASAN and call kasan_init_generic
Date: Tue,  5 Aug 2025 19:26:15 +0500
Message-Id: <20250805142622.560992-3-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805142622.560992-1-snovitoll@gmail.com>
References: <20250805142622.560992-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g1p57bjor9mnaye9tyyr7pfh9zoixgwe
X-Rspamd-Queue-Id: 5BEB01A0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754403995-195989
X-HE-Meta: U2FsdGVkX1+qHzlXXBdV7Oe8A1wL+qp1mHBRwx4FA/Z7LGpwhlksygNLKjEGUdvDGBMag0GHJlupFmd8CGy30b3UuFv2Y3z9LZqb0DOybHdSrPcfdTd9D7zmwJjBNGL37tmVqUAuRG/17Oc2aPl/a7VgMRRGPO3VQutOlL3zzYEbG3aVQTng86nZdNYv05h+ej3JuIrdNDXP7dTbvt7wwm2Dsms0osPtpMpFpcAQ7wsXSh1Tu9hr9PB54mV+ShA8YT6lzzL7xvx3fKULgz2ygSmg+x3Tsq+Th1Bv6U6ZuDOQXxEKp+1m9+JdaIVKIxiRyQpO+Zwi41Ax+19D3jxuROqKnA1ik1CF7jqtX0vDfgkaVRfK3/P93iBPipVLe8fS7VFSVBzFbarYFVZtMDv5zztewQ+mUDf6t96OKM1f/GIQ1t15tVLg/PSuB3djAVBMMyZwtQnxglkPxFBd0hFxzi4Hu5g1hZ+zIxlib7lehVkNNxdap9JC0Ms46/3x+N5DPVE0IYHtQbKsuYsQKtu8f3zzUfd6dUlLBG3QFWA9Pf5qi6u7SOPlL+dx9VbVrcH2wsWRYM+VLgqGwU8VRVC+3hcctNW6BKDpG6QgfCbCFN5AEJlmwMLyM9FAaTVOKvpkm2XC5mm/1wjSUHhwiHoWoyUECy7are7cFKEE0YEOY6RJ+HGIvoPq80qZ/cHSMNwyyBqrnEZX1BWO3ryBzB11aMYcu0ddLRQM5x2MtUe6H4amGiGbIeg+BITcSfJ4pD5f6cI3Q6S/wY3D4JCiH09mrp8gq8NnZ4H7Nktm8QLk6ZUMY5mK9TLHcR++JQigc3PbYb2OkkhG+yWKDujig7REB4H/kcvE9hqZinavwla+YpPIrHMxDmLLtjTR2zLv9e+YMfjcVysode8C3wVdqsHC/yXHcgmxJR/vxgM6hGQ3yVTwiK6tNW3qHljSdECsZcztvLsORJbno/WZCjmHfcM
 cBNiS+4+
 hgLF4QVfFzqkvUA1M2GSbt3V5ipSJKvdQOAhpxeKUA5r2UO1hFAY1qcnLE0N5igMGDBBwSkg7NCfw6pWcAeSHgcgEa5l4TaWIYDkRcUCzv1uJp9qfZ/ODTI6RWZOkuNYhGVgquuaHPU8l6a3EbbJc5OomfCA67xqUqAUi4JJXkP069Uza1FTcpc2KBioAca5DpWVLAfKE4cHOG7dHLju3DPFqNuYP8T/slduU5y7ULyqajW0q47AemcvBV52JrAFvoiFbd9PFxaH+oZPujabm6U3QGh3SecukEwU7Fqp5N+gtjIn28zPV9LPalxUCQQlksyc9xfMBwkY3qSXjNhbN2cOzLBgcdGhNoFx/VCTkkPAVZNjHSuVikWuHLMF+Aei2Q5YG/3wa9GKj+MVFlsLEGkD04GoBtVv1XrcCmrgkLpcEfF/AuXVYDtVxYHcoRFrevZIKj2q54Isg4rW/GC+wRa8LS5ybOfZl/CZh48ag6/VQ9O1CsaEUDDG7hnnEeC87hant8xEcqBuF1Se6PaIzVTubsb936kCuu2yFp7dUbFi9U35zWzmupcpqVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PowerPC with radix MMU is the primary architecture that needs deferred
KASAN initialization, as it requires complex shadow memory setup before
KASAN can be safely enabled.

Select ARCH_DEFER_KASAN for PPC_RADIX_MMU to enable the static key
mechanism for runtime KASAN control. Other PowerPC configurations
(like book3e and 32-bit) can enable KASAN early and will use
compile-time constants instead.

Remove the PowerPC-specific static key and kasan_arch_is_ready()
implementation in favor of the unified interface.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Fixes: 55d77bae7342 ("kasan: fix Oops due to missing calls to kasan_arch_is_ready()")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 arch/powerpc/Kconfig                   |  1 +
 arch/powerpc/include/asm/kasan.h       | 12 ------------
 arch/powerpc/mm/kasan/init_32.c        |  2 +-
 arch/powerpc/mm/kasan/init_book3e_64.c |  2 +-
 arch/powerpc/mm/kasan/init_book3s_64.c |  6 +-----
 5 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 93402a1d9c9..11c8ef2d88e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -122,6 +122,7 @@ config PPC
 	# Please keep this list sorted alphabetically.
 	#
 	select ARCH_32BIT_OFF_T if PPC32
+	select ARCH_DEFER_KASAN			if PPC_RADIX_MMU
 	select ARCH_DISABLE_KASAN_INLINE	if PPC_RADIX_MMU
 	select ARCH_DMA_DEFAULT_COHERENT	if !NOT_COHERENT_CACHE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/powerpc/include/asm/kasan.h b/arch/powerpc/include/asm/kasan.h
index b5bbb94c51f..957a57c1db5 100644
--- a/arch/powerpc/include/asm/kasan.h
+++ b/arch/powerpc/include/asm/kasan.h
@@ -53,18 +53,6 @@
 #endif
 
 #ifdef CONFIG_KASAN
-#ifdef CONFIG_PPC_BOOK3S_64
-DECLARE_STATIC_KEY_FALSE(powerpc_kasan_enabled_key);
-
-static __always_inline bool kasan_arch_is_ready(void)
-{
-	if (static_branch_likely(&powerpc_kasan_enabled_key))
-		return true;
-	return false;
-}
-
-#define kasan_arch_is_ready kasan_arch_is_ready
-#endif
 
 void kasan_early_init(void);
 void kasan_mmu_init(void);
diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/init_32.c
index 03666d790a5..1d083597464 100644
--- a/arch/powerpc/mm/kasan/init_32.c
+++ b/arch/powerpc/mm/kasan/init_32.c
@@ -165,7 +165,7 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KASAN init done\n");
+	kasan_init_generic();
 }
 
 void __init kasan_late_init(void)
diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
index 60c78aac0f6..0d3a73d6d4b 100644
--- a/arch/powerpc/mm/kasan/init_book3e_64.c
+++ b/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -127,7 +127,7 @@ void __init kasan_init(void)
 
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KASAN init done\n");
+	kasan_init_generic();
 }
 
 void __init kasan_late_init(void) { }
diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
index 7d959544c07..dcafa641804 100644
--- a/arch/powerpc/mm/kasan/init_book3s_64.c
+++ b/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -19,8 +19,6 @@
 #include <linux/memblock.h>
 #include <asm/pgalloc.h>
 
-DEFINE_STATIC_KEY_FALSE(powerpc_kasan_enabled_key);
-
 static void __init kasan_init_phys_region(void *start, void *end)
 {
 	unsigned long k_start, k_end, k_cur;
@@ -92,11 +90,9 @@ void __init kasan_init(void)
 	 */
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
-	static_branch_inc(&powerpc_kasan_enabled_key);
-
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KASAN init done\n");
+	kasan_init_generic();
 }
 
 void __init kasan_early_init(void) { }
-- 
2.34.1


