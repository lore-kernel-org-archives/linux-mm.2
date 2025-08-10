Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C082C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 12:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCDF86B00AD; Sun, 10 Aug 2025 08:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5C46B00AE; Sun, 10 Aug 2025 08:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC1B6B00AF; Sun, 10 Aug 2025 08:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9752C6B00AD
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:58:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3932A1604B2
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:58:15 +0000 (UTC)
X-FDA: 83760850950.08.6BACE95
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 42E0620008
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:58:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HnSxRUx8;
	spf=pass (imf13.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754830693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPUEdIdCRmt+MYJsQtBbxjY1GnPuX9CU1RwbVybqcDU=;
	b=uVFOqrSHaLS/ijRD+8HIWigNdrYzIsbjC8oUljwV324MALnpnsVvJBKmNKIReAWcIhk8Eg
	jAkhyOQy/Bo2aQY5K9lrY2HPgluIhWMBkJEE4m257oMgxwX2syCSgjVKXUkOd2SoEcEdzS
	9S06AjoEkvK3ypZKH23pFr+vDV9gEc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754830693; a=rsa-sha256;
	cv=none;
	b=qbQXtSfO1eDNjIMbnCv2DL2nvo9MUysalOc0BhME+aQ9k9WZ6WKwa57FiPcerSpElkm/yt
	hXQwRTHzJFD8tH4IEXA4dnkx0/vWmnbpN9+R2kvwflPl7ZZbJSBp8ytiVWLjJBhugjbuty
	9Bi4GCToQ/oAsyc4GSiyQX/OD93gZuQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HnSxRUx8;
	spf=pass (imf13.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-332426c78a2so27844691fa.2
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754830692; x=1755435492; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPUEdIdCRmt+MYJsQtBbxjY1GnPuX9CU1RwbVybqcDU=;
        b=HnSxRUx8ey1fDtf8Znl52uFftopAQ4nHMPTQOBaskOWQ8Whf9deEfmKp2mH5Y5e0Ta
         1/L2eBtsW5vW2tLArlD5RiTOgTxkmSS4mEyKTirOPuA5b7wZMO2t1A1U8osAgnyNJwbi
         ZCIEpwAXcqBvcw7ubLaR3de6DT3fiChRJzLEiFcBQ9GNH/vc4gU9/4LEx2dOXwNW3wcl
         8BZygdtv6IURCro2eQSAeHOXeXczUWOL8HpLl/LW7xP2433cZEscmd4Q7mF2iqdp/bzM
         v2jdGLNT4Nin/48lAi527QRRInxH01u77Cdz84XCgHNSaSrC8FsFY/b1W/E11Q/2VxYe
         Ovtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754830692; x=1755435492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPUEdIdCRmt+MYJsQtBbxjY1GnPuX9CU1RwbVybqcDU=;
        b=n3TQ978oQl2HKcrX2SRCgklf3GunYCM9naChVZ4LnpbI4ReAn33Ql9lEardHlWh7ls
         D3LkCGN/LNGDClQnRUigWsQHGGKbVOpPQd0IgfYhUPBzM1rUJEPV4DK5xBQ49K2PcJZN
         /7u5U1otHHez3KHHhbm7ujd8bczdnZNDXRFJfB/s5o9DuOOulvLt6KonuM/yD1CPCtAt
         XKpc7QY9Nf1JIlj2ywZdHZ1uesw+GCFjDESZ9lKkZMzH2dVNHuhZkcGNbh96u4HuRzKM
         qJV8tP+GE11siOIY3kFYnL/xZDs0+PKzEaOCWP+ZP4uByWJWGn3jTcfgtEDpxuVmuDYy
         IlIg==
X-Forwarded-Encrypted: i=1; AJvYcCXTay609KZJowkVt0ByYrWJJUmU0uNy8demfhOSstxhlCS31/XJW9SxobU1faVZg5ISLn2ce6y7FA==@kvack.org
X-Gm-Message-State: AOJu0YyIjGM0GTGhgpCOH5loxv4hVyUFpNmpBcxRqRXvOfq1FqEz9n0V
	tI7D4Gym5gzCQpvJzy1P5UFx0+kgTmS9OSXgSO2A9iDxzXBNRyVThxsv
X-Gm-Gg: ASbGncsk7IiPs9VOBJ/p+i/SOdcINH9lN8FGMcCLz0uFur8X2GJH7h8p9lDsehDPPxV
	B4sKzNDpvYK6ut/sfpLBzwIwRTwStjmXIn9FtMyy5n9REEdD3ICCPvoJhGSx21eflxPi06mH8Ry
	bQ4Xj9SW7I/Z9zFafZ91WN00GZ0RZ9jhg2+XOkHlsrkfFPO0/4NBPzd4ucyoydunu0wfZSytTA5
	RrUGXfBDCnY9ItbXdQFUeUdc9CK6350FqM+H5GiRclG2+ahBxMQzTa2Ftcup/wGKo+Nz62tzeUy
	TwOkd4dHCMiaNdxcX3TqK2nISfuXlfvCLquyeG+9b+8Dh6QE3APsYLyigmrApAb6/PMOWRPMND9
	c4oWHarTaL5vgGRsd9ZGIsl5RmpGPNQR2z/4vug==
X-Google-Smtp-Source: AGHT+IFrIl3eJCoqqHt0ANltzYIq2yL9Jka0mZA2tOEeoGsTnUPJed1OxDGIgQlZCm+SP4loyYZbRA==
X-Received: by 2002:a05:6512:3502:b0:55b:732d:931 with SMTP id 2adb3069b0e04-55cc00b14c8mr2560689e87.12.1754830691289;
        Sun, 10 Aug 2025 05:58:11 -0700 (PDT)
Received: from localhost.localdomain ([2a03:32c0:2e:37dd:bfc4:9fdc:ddc6:5962])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9908esm3804561e87.76.2025.08.10.05.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 05:58:10 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	christophe.leroy@csgroup.eu,
	bhe@redhat.com,
	hca@linux.ibm.com,
	andreyknvl@gmail.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	davidgow@google.com,
	glider@google.com,
	dvyukov@google.com,
	alexghiti@rivosinc.com
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
	snovitoll@gmail.com
Subject: [PATCH v6 2/2] kasan: call kasan_init_generic in kasan_init
Date: Sun, 10 Aug 2025 17:57:46 +0500
Message-Id: <20250810125746.1105476-3-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250810125746.1105476-1-snovitoll@gmail.com>
References: <20250810125746.1105476-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 42E0620008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: bct1wgw73xso6u1urrcsh4u8saj6fb5e
X-HE-Tag: 1754830693-575681
X-HE-Meta: U2FsdGVkX1+JJGzhQLkoKE2kuhz2tf7OdzXUWWLuGncqt9V5f8QSEgaCmSnQYQKMBDtw/HMEpr9cHH/CKjW61CLwyT2zI49GssA9FFkMjZGwA79Gc0gh4TJL6NPwopr00Qm7RF0zDYwA3/mmLHeUME4fWyn2PVJC7+f2PTl3WjnD8qvf6ljTEbVoYVfp9NvRK113bEjHtoqrKciv+j8OapsNZzAJWqv7AoTDGahbGcaEIJ7BrwmNwAAYk+iq7iQ8AzSLx20+JWA/Y/9S7FtFVfAcLMvzo7j8Y50KvbRdZZkL3ebJokGmFjpXV8pEewPF9gf9Mt18tN106Hf97OTuNNyawMUBhCX0aBojIlDwgSUZJQlk5s3j93EMR38Bz+oMeTIZKDt0wDjCEn9koMuiOZAx/MtnQG41P6TS0Jv8Ia0gOM/kGyv9XQclXa4NLZ/ivv6T2X7TkyWUMNYhKuiWlP8yy2FQ8qN3ZnJRzUZnZ7QdekE8GbWfqqt+QzJ1cJlGjhOSuiESMeKX2GqwFnCi6InKWDCiBo+zek/iTwstokdH4sSvfjvHE+IP5jpHs9KU+0E+RpYjlPyYdDfy+XTuytNS5ZE2Q1C0BsSP/g8lWzMYLfGr5/lUFNGOQrokpdd1OFGK7HWmMaitz3yFlEcqFzpmKH0D7yyPbqRBIqAOgNBDqasZQ3QqApq3ABi50/spU8SdVyMPCtfc3i4OuEkcU6xwK9NKPb2GBZkfcaE7+CEhwiOfdYPK8qiYjb6Tke+jZ+82ZhwjFFc/9I+SCgFe6S27nQSaVqRzO2OS6IMvx5dvgWXLulC/vlFJ8+Wn6e6+r9lncbnLtiw17Smvy5yhL6oqkaoHs7J5/qxcGenSEDAzXpxC/lUX2X13i/m6nrjG8VY0ahlJzf9ubFLsIa9sdJJteNF3z/fcFSBZVQOG7LU43unfDp/ZR4Gf1wgArsEhEVrAfCTYZECr5qrpXC4
 0WwPzxrX
 5Q6QbSK/f04+IxCOg6WDJ8uaX6h5QkK1/iQA3z2rMIdJc6fb+8Vj1y9WrIcs9vHnQb54XVyy+DT3xQZ87ZsAhcW/I2tDVp1L4odtcqr5WdkrvDyhzDiZIaRgAbYh+y7qKbJyxIBQL8VUI2Ws8uTjCGrR8jaLCke4tjISO6YQs0+nr3clcs/7x5WEs4ZSxa52AdfYK6z3fcHY1gsXY8UW52iAIcfB3V2fDCFbl7LkYDEm+X8HQ8LgzDuSuv69ElkMR7CL8Wq3QxKA89bKIMAu2VgaQIHv93WQ2J3+ThTKRFoduyPR1hTF2/eI/ImYjHDLiy67mIashZN++ga5zfbelMrWtCjIITU4+E/z5/06msIbqxIl9jY5pUiXAQMZ0Vsf0dDoxCcmZ4VKTlNho4Jm5mMBctm8MzCZD/1QmT2kCu++4IUo0hSrUsLQ/goTBytKV870X70M+HKnQm2/YmD0F3avsTpLhVsCu9eOTNX6C50kHNqy9tu2+MisZWZb4eTTSygxbtTsHy4e+dvJy2x1XQQNgKv1SKwXYbn8qEXhqqOODSIFAYPBSipVRVmDAd/YJBVcMjort1H5GUFXeVzecc4Tet7kRjlWBW7Zez7ImU6cRrKtubNsBCt8TdrKySO4OX1qtd6j9xn7SZfQ=
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
Changes in v6:
- Call kasan_init_generic() in arch/riscv _after_ local_flush_tlb_all()
---
 arch/arm/mm/kasan_init.c    | 2 +-
 arch/arm64/mm/kasan_init.c  | 4 +---
 arch/riscv/mm/kasan_init.c  | 1 +
 arch/s390/kernel/early.c    | 3 ++-
 arch/x86/mm/kasan_init_64.c | 2 +-
 arch/xtensa/mm/kasan_init.c | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 111d4f703136..c6625e808bf8 100644
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
index d541ce45daeb..abeb81bf6ebd 100644
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
index 41c635d6aca4..c4a2a9e5586e 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -533,4 +533,5 @@ void __init kasan_init(void)
 
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
+	kasan_init_generic();
 }
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 9adfbdd377dc..544e5403dd91 100644
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
index 0539efd0d216..998b6010d6d3 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -451,5 +451,5 @@ void __init kasan_init(void)
 	__flush_tlb_all();
 
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 }
diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
index f39c4d83173a..0524b9ed5e63 100644
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


