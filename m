Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8420C87FDA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549966B00C5; Thu,  7 Aug 2025 15:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9FD6B00C7; Thu,  7 Aug 2025 15:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2D06B00C8; Thu,  7 Aug 2025 15:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 227A76B00C5
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:40:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2BC6C0BEC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:40:30 +0000 (UTC)
X-FDA: 83750978220.05.8016436
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id EEE32140002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:40:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CTXq5D7S;
	spf=pass (imf26.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754595629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNdBwl8v2OqAa3v0ByxYoV2FZHtZfSuaaApNKvSqvMU=;
	b=P8AJdUQg5h+t8vc3+DGBdabb95GATgTQwYzr4vEF2/MmWUIE2AnrAQe0uhA0dUQVvlYEiA
	2lcVaD4ECr+x/fiHRqtzFYtv+gEi2mLlwSERNNAofpANMAXI/7/WXZRAkziQisuzoP8zyp
	OcloJxCPYR+F2VqhF1n4mY0xaTdajV4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CTXq5D7S;
	spf=pass (imf26.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754595629; a=rsa-sha256;
	cv=none;
	b=ioLDaYA3Y5gb4o/4GHBNohwAhXWrpK0HIvgipnQt79KWsuXV0TsEHG1uZBGst8EkjqVc/k
	DR3FSpvNvDHWvWx1/KWgMFwB4l6+z8Yp9JN7E7DLTaLRnAcsD3ll027+TBcAsZY5cKBZOc
	KDjsUs4buvXXS49W/XfYZXok2A7kjU8=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55b829c7f1aso1496422e87.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754595627; x=1755200427; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNdBwl8v2OqAa3v0ByxYoV2FZHtZfSuaaApNKvSqvMU=;
        b=CTXq5D7S9gGOuZriivhZYm/f6d1KAqwITsJk4f+ZiCdkJLBJoQL+ZnLvHkJbp5HdRX
         DXsK3RbaO4EOEJOnOK+owVtVOQ7BvtUV5heK+28PCLtfFIylExXctndEfZl+msIlGGMm
         PsDf+nZ57CX9D3UOTGItIokzexaOmp/WDBsj6USgwjUGiF9xjYeJ9Ebyo3c813kU1v9W
         bHDRzR2JZbCwMB25aIAW8de+0WqcdBN9seskVxtE+R2A9INF79RaMo/u3eUFlrAqo94J
         TKuL4PuJM5tZe4WuxRJmJk/bLYk9CUN6qReii5qj5nNr0+wwCkXNhAZJy5XIeaTklwAR
         4Z+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754595627; x=1755200427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNdBwl8v2OqAa3v0ByxYoV2FZHtZfSuaaApNKvSqvMU=;
        b=Sn6eOjLQ8SAuiKtSBdc30xKlXdLmsvi1thuED3mul6ea1s98/HFJaBd8qxSCnTXDZX
         3TAEcO+/w3sapLWwXM2xNpEkvYD3ykf/BRuZleHx09j67z9XVlMm8lS6Uj0bOpRSYWXW
         ZZMoqZwGNWEfqZNT/H/rWALliG1d2ozmtBEwC0wEtqJBkB87p9sSh2Uhk4KqTpedJlks
         Tr4AG8WDP94pOo8At8HODyanf1sHUtp0E0+p/HA5b/xk4q2o/fpGUy1i5MuPh4qVU/u8
         dIlz3AlL2rjuioLcM1ITl30ma933Uov3agyveCwcM+ucVr5qSktBvScMAmfQT5bWSfIr
         AQYw==
X-Forwarded-Encrypted: i=1; AJvYcCWAYVPUIviTD7dZDH14H1H9p3dIQwnNpJmo+EaJgWb5nI5Ftjnq3WffRV096QZWJ7NDdbfa/WgvJw==@kvack.org
X-Gm-Message-State: AOJu0Yx22VGPjl4YKuXD0oThmrrzpECCFehYvdriSjNj6G7BzmFxIWW3
	Im+eQg/5bZhqlcd0WZ9xWB9Jb7JC2HorIVkwczn9nzosOCBss7L4VYuC
X-Gm-Gg: ASbGncurY4306T5S0k9xftwoG64ME7htpn1ZIsNB3ncE644rXgDn0SUYE1f8RzPLz3p
	WIBO+AjhF5RP9pB/8kESOhQDwnGLv4DBsCyBHcF8B6U4Ap1XgOOixos6T1SCPBe3UDJLhRNyKiO
	YG5o9wfcG1EjPvTx8bEPsyAP1gV6KuwRX6mOtDQUGZQEmBlyDmKSywUqjEFfgE/fuRFKEcDzuKD
	aJTzNkyl1roMPM+pEs8tlN3rQMiPePqrH78pN6hwafhV795U3jCaDm25LEsefvjnV3XX4rT3UA6
	SYAFGzbHFNR+GbYMFBkUBaC9rm5uIjzdYCodMDSDg/n6GaO6KibCJHCN22DH1O8yR5/BEAEy96c
	YHAlnzJ9PZ7S1jJ3ukNx6nA91WTsSW4rGnbsz+Wa1MFnB9nzOyJsgKICx7PRDXKNKuH9ZxA==
X-Google-Smtp-Source: AGHT+IFy1K+04TTf6HeQynR9tEb65FcTbYVkR/07BpvyTspaDpSD1TTrgV/AzkLRIY/TwnnFAN629A==
X-Received: by 2002:ac2:4e14:0:b0:55b:8f46:80ed with SMTP id 2adb3069b0e04-55cc00e3a66mr10263e87.21.1754595627098;
        Thu, 07 Aug 2025 12:40:27 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c98c2asm2793570e87.77.2025.08.07.12.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 12:40:26 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	bhe@redhat.com,
	hca@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	andreyknvl@gmail.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	davidgow@google.co,
	glider@google.com,
	dvyukov@google.com
Cc: alex@ghiti.fr,
	agordeev@linux.ibm.com,
	vincenzo.frascino@arm.com,
	elver@google.com,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	snovitoll@gmail.com,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v5 2/2] kasan: call kasan_init_generic in kasan_init
Date: Fri,  8 Aug 2025 00:40:12 +0500
Message-Id: <20250807194012.631367-3-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250807194012.631367-1-snovitoll@gmail.com>
References: <20250807194012.631367-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EEE32140002
X-Rspamd-Server: rspam06
X-Stat-Signature: xojb338n56h974kopu8otguh7fjbgu4o
X-HE-Tag: 1754595628-654856
X-HE-Meta: U2FsdGVkX18H0zjC/9vkbaSYUSUcSTDXOz9YqMdJ0BVXk00MsF5xI1jKrBZPCTAwTPZQCpDNI7LsXh3Sb3bQTw2k1GFNFr6NgFFhfxH/wtHjnVWMEY2zzI524OUSBzaE845uuPer/4hfhpjZMgVovRcXxZFotQy/mCDFT1VIwT5jY1a8LCTM4y0GIeS40kNCavjqIgf/PErr7y8g009Q4SKCENSA/ztmz8BggRA+TsY9Di02qDqW18CNkrMnePev81d8Aywv3Wfl5fQ12H+kq3zeBWNMacLP7TY0PWrnKKwy6iWzNiiw5F4c/fOQBRTVV4Lao/E1b+ZQiePWenjdlYEraptSe6I0j3/ZBYGbCBnxPjZLZOeLF1qeDEoSIx3hiVdl76351PUda95567Z0lPd2aBZ01skUVwMRTfb2wRvh+oMvRASI/ENdWDwvE5C4QQ6zGq1a/dnLFPmgRVEGogovXJ96kjXJyuL2omJQF4Tl9b/Q2EnTD47+5l5jNGM4WS4VBmjx/Etc8SHKZJvAbtX+5hV/D3xBBADrKa3hzegbbNB/45sNDRtxlgc2Eyh+wv1R+avm2fBGImXh7D7nbRzWkmQWMt8GciwX5hVmWtB9ycNxCDJJ0Y6p1EABq8d5b0FtcwMxY35BdionjFjh5XSd/a+fy6xRfxOjPfmIW4PtlgnzmIB649jMepW2aRVgI3CjfQGB2n70W99ALHB+1x9fCCZB0mEhbyG1uRfEWbmKXJjZfu8NYuFdW2uY3beCS3U72C4JJXJ0Ex6LOuZGAbNjnnUqJLffgYTecOlii0BxC4sOOGsE/FPpp+VXJuoEgAcLhwoQC+9RGmBxHoUiPtCAB/f3I7RTISnIFZhNm6s9gJO0E5PUamBkTGlTDnB3dQlQdYqHbw94AkjBEB9NYyIQTCPFGXHVz/u6o9A4BGJVHFxCDCX1a8kI55lqg7dJoZO5QPMeajJZvyfPe1u
 BU06O9Sq
 A3w9bCCon8XHQmV4Ing3gqwMtzSXPkn/oYmNxsxxg0fTgp1YLdIQ7Gg5Xs9vM5u/jPzexPsqJ2e/BSj8zno4rJyuE78lZOoiI4fFSX8jD8SQk/5BcWsB3gxFEPSLuAK0a3Kj7ERPmkmzX4O/C86vNtjnHKXriOkCVNWWFsrq2faOgNbtKeBIS0D2lcG+7slZ2qhp2mtNjf13Tbu7mNzJA2heGkxCqEq3FOpVjS2tR7+ceb1JtWZvrRr64A1rimpLqKg9LXG1IekoLEW+lmB1Avfu98dplC/oWhGJFSG9/B+GzV+IYMUMLNsYh+HsHWMxSgUAL2QgiV9pZGQpbJicfFGuO8n/6/nb6d6el8XPJY931BGIGReiiyWT+Y9RWSV2f6lLuWUYS8ljWh5EaataLtTlvw5HLQV0Tu/eZACppari5ucIvgnBXYQr8fePLSLbJ9M78ua4JLc/+6KoDxBSojnpBW4KwtlTB9vtw7howhNNGNopHSy/WwZTSvTKDgttHjA41z1Y8tJpgIOZtjrYrXHjj+tFKsvrkF6KSvl0PFPl8DLc4mZlalW70/nUYkzx2/kNN34/nYXYsjioFHjVADpsmJtzg1IVY8W9h9vDgpljqbQyeHnsyaNN14Q99uiHwOt1w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call kasan_init_generic() which handles Generic KASAN initialization.
For architectures that do not select ARCH_DEFER_KASAN,
this will be a no-op for the runtime flag but will
print the initialization banner.

For SW_TAGS and HW_TAGS modes, their respective init functions will
handle the flag enabling, if they are enabled/implemented.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com> # s390
---
Changes in v5:
- Unified arch patches into a single one, where we just call
	kasan_init_generic()
- Added Tested-by tag for riscv (tested the same change in v4)
- Added Acked-by tag for s390 (tested the same change in v4)
---
 arch/arm/mm/kasan_init.c    | 2 +-
 arch/arm64/mm/kasan_init.c  | 4 +---
 arch/riscv/mm/kasan_init.c  | 1 +
 arch/s390/kernel/early.c    | 3 ++-
 arch/x86/mm/kasan_init_64.c | 2 +-
 arch/xtensa/mm/kasan_init.c | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 111d4f70313..c6625e808bf 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -300,6 +300,6 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
-	pr_info("Kernel address sanitizer initialized\n");
 	init_task.kasan_depth = 0;
+	kasan_init_generic();
 }
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index d541ce45dae..abeb81bf6eb 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -399,14 +399,12 @@ void __init kasan_init(void)
 {
 	kasan_init_shadow();
 	kasan_init_depth();
-#if defined(CONFIG_KASAN_GENERIC)
+	kasan_init_generic();
 	/*
 	 * Generic KASAN is now fully initialized.
 	 * Software and Hardware Tag-Based modes still require
 	 * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
 	 */
-	pr_info("KernelAddressSanitizer initialized (generic)\n");
-#endif
 }
 
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 41c635d6aca..ba2709b1eec 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -530,6 +530,7 @@ void __init kasan_init(void)
 
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
+	kasan_init_generic();
 
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 9adfbdd377d..544e5403dd9 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <asm/asm-extable.h>
 #include <linux/memblock.h>
+#include <linux/kasan.h>
 #include <asm/access-regs.h>
 #include <asm/asm-offsets.h>
 #include <asm/machine.h>
@@ -65,7 +66,7 @@ static void __init kasan_early_init(void)
 {
 #ifdef CONFIG_KASAN
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 #endif
 }
 
diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 0539efd0d21..998b6010d6d 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -451,5 +451,5 @@ void __init kasan_init(void)
 	__flush_tlb_all();
 
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 }
diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
index f39c4d83173..0524b9ed5e6 100644
--- a/arch/xtensa/mm/kasan_init.c
+++ b/arch/xtensa/mm/kasan_init.c
@@ -94,5 +94,5 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages. */
 	current->kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 }
-- 
2.34.1


