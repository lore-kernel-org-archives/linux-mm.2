Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F5BC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9416B00C2; Thu,  7 Aug 2025 15:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC06F6B00C3; Thu,  7 Aug 2025 15:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88116B00C4; Thu,  7 Aug 2025 15:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A382A6B00C2
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:40:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 582F1116E60
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:40:27 +0000 (UTC)
X-FDA: 83750978094.14.C97B4F1
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F8BAC0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:40:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d5K1YWTn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754595625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DbfBGTvZLLq0ttKoSCsFatguSHfxza7xfUfeZ6hh5c=;
	b=AM/VvVpF/DXIotlOCSFIh+2xz8b1az/VNBIzh65Bt3CpNigCgRJNZfvy+tG6ZBerFBajSq
	XZD441RBHBvT3hpscuFl5ESY3lT1v604wb+kGurRCdounfyrc9yOuH/KZSo92Bs++u6YTP
	Uo5ImfM6/mVLG3OO6Y1sHUd/Tw8KR6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754595625; a=rsa-sha256;
	cv=none;
	b=osMUwjhz+6/Vj3pS+gZdhV9UHLG6bWLeeJcMyt0WelXHKNBuGsWSeXK08jBZ8gxgvM7UKB
	TUZ+5AcJmZetMAp9jvf7r1kikCkkIas8AKhI81VG6hFU9s5YsyqsR+IQj7Zbrgb19E+iBO
	QIqjYLvDUkbQcLDnISZLGbJGLZUOKHE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d5K1YWTn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-55b8f1a13e9so1154962e87.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754595623; x=1755200423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DbfBGTvZLLq0ttKoSCsFatguSHfxza7xfUfeZ6hh5c=;
        b=d5K1YWTntSpkUbtsS/paLlft99e79Rhk0Pa4elbajDC3ccrc6BPD/1C/2s9ft3VBIK
         eauul7uhv35tAvTo9Q7yGJnJbTYiQTC2i1LoKpN+2F6cO7wV7cG2K74y2lsmAj1Xqm6/
         LS3MAeMjiuJCi4YMFV33PXMdnooHdYxItMZEEEeCgzDuca24UycNE7xHJDE9EPCI2/pw
         cFONqytD5ccvjyZ9sZfazT++5Oy0r0BUkhd0WdKtV0OnkEy7EGkkNnM1FS/19wFAOJwi
         VRpPWvN7+R9osYXnl3/APCIc/0k866gziVq1j/seVz6Gt2k33kRov/yCZwPHI+T/FUyt
         z8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754595623; x=1755200423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2DbfBGTvZLLq0ttKoSCsFatguSHfxza7xfUfeZ6hh5c=;
        b=feRoQD0jvEGOHsXblNotvnkZPS2KYybnQv6pBBGCwHVPbzXd6qCtVRIgK/cU0e3GDq
         raeBbg9bW0mynGxYT+SO9EBXS8hb+e+sBtNmwd0rkIjcu+PHL60JYWekGfZRE0FdHfKV
         vxD9BUpE/eH7DlyvKh3vR3MQHMv+3nr/eJnVnV2/DflKC/Z23gx3U2v0fRcFk8UJaqaz
         zKzfIPJYZ5iO52OBl/0HqwP9yu0kxO/tTXJQBNjivnduwATXOyk68OtkLjJ5p/LG1cFy
         QVwcUMycWy4vsnxbo4TeLSpkKzTXgdOxMvV1GJk+a7NR3MdH61o9+URRXUVoAgR30XDR
         /UyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWK9q6IBP+xX5UTarUKW23lk9hu31Gle6ZKgo01YW4WEnBCQMiqXCkhWXAvPIAJMnEAd11MbyQITQ==@kvack.org
X-Gm-Message-State: AOJu0YxuI13TvIDNolbR/6sw1YkLXeoF1Z+QXhVmSEkow1g/C7fhhcEu
	TOwWZsdLG3ihLYwEObLG/tlq7INhHBrPLDSADsiJLxBnVhgahj8j5H6m
X-Gm-Gg: ASbGncs3hNZuT2f2MMGbLPlA9k10vD5YQF7MqJe5odutlYmPbWmLritddvnQLHf4d/V
	o154jmNH4GKXtry3ax9rQ4dg1HWipjR/iNIUBt1v32bNUSYZRNtV7qg1YLfTL1ffndcq0kRfa3a
	si1n+wUUz00nfMuhmAYqyhjYZzh7ENOz1ppuBOsSU+HeaUrSA7lb9awVCeHZxwl0wwfk13avZDg
	KvAJ4jIz5uYH895xkqikiXfThhpcFhAjURTpges12WUf+1ESoxkce2Vnp5HTWjIA9z3YQ1AK9kR
	3H7Iu6W/lRUINzr26/4VYxr9+DvXU5YOhYd8Ulfzeww3dv4tCi1Mm3r6SUzU/pbsK99G8LC6Mty
	yQQFl4mpp7jxN1YRZyyM/pG8oQqm7uwT717nzH+Fege4cgNzOaw1XIaa5zEl4vKBnQLo+Gg==
X-Google-Smtp-Source: AGHT+IFRe5TH5UxPaXG4pwR+ZzT71hP9gkI3If4nREh0zO/0YhbgqAGusbPVyt1+sk+N384E5cIRdg==
X-Received: by 2002:a05:6512:15a4:b0:55c:bf3c:e7ee with SMTP id 2adb3069b0e04-55cc00b003emr12512e87.3.1754595622849;
        Thu, 07 Aug 2025 12:40:22 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c98c2asm2793570e87.77.2025.08.07.12.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 12:40:22 -0700 (PDT)
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
	snovitoll@gmail.com
Subject: [PATCH v5 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
Date: Fri,  8 Aug 2025 00:40:11 +0500
Message-Id: <20250807194012.631367-2-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250807194012.631367-1-snovitoll@gmail.com>
References: <20250807194012.631367-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F8BAC0006
X-Stat-Signature: qxjgdtsbjtgbciywhzo7x9stfifj14ir
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754595624-795492
X-HE-Meta: U2FsdGVkX19ADCtJeOik8XWQPvLeMYnC7VCwHGLvFnzBvywvOQov1am9QFHdDX0BMH6uwaSaWd72gA93Klz/K/HFbu3TbCNVKu6xa7eOqfuc6+pO3UaEAUZ2CEJ+cQ46+Buvhzr7DcexI68jL7aGh/UlD59IWm9bXEd2UeLuDGQvLye8gjDRaRSQlxcjLLgu+lo8u2WdeY29sv7GBzwuXhOumzDJZZ10X2okcuiykAXb0tKoMmMwmFFxr572EEXdRzQYbuMosw7CGIK0+czN0IRKp4h47I5rjzg/8DTbTP1cUX9LsVxeTg9dcgWA9RsBSy4udEaGwRkkktyjFhDZJb7M5Cej3anWbu3svndTU2913oDuyhnMqaERNW0DN6/6CzBV77fVGm7g+H3H+y1bVJ7aobHmJw6JNswbeJsl6BPvFAVRMatMJm80+0a2HPYrUYhAMcphx3vFs6aULv9KKQp6BHBbERBaAzjB3jx6HaDEuMwk5tFDI9j6+s9JO1GXVLO4pdV8NvRm1LmJRCWkNMH+BYn5zfBW0iDW/ZgIpUnGqcAmIX5cyerevxTH6Bvuxq/ng1sAbiC/eokDUQKzUX7nHeX95XuwX28TFt+ea27/zccIHrs/hLGmhGGGtkKxFSnoNs20qb+JdlfXr5Fru3wD/Unu3/pFThVjdZSUS/ajiOs560DCelafetDERmgMKeZsGbST/4KtZ0HP/62ofUAGUydnLtX18MP+zTV9M5RByVz0PFDO4gkScDH6jjqifTPYUZg53oSttFHs2UKcpL1V4OCoZPtohfE1MdRUmUzVBWrBx8j8sHJxZZI/hoWH8hoSQFbJ+GZ81fCpmIsSR37RTb8zFoooFdc98QEXkhjWjo3KQRJjdOc0npyqielpbBk+tH2MESglI6bkAPJ5McCNzVsp7GLCOwjoSlisHjSrwzg0PYAd+aCBqmIHDa3z0Tc5Can0T2XCOwDRbtw
 VO7C7Xfd
 KmTlBlYHsLOlcAU5httz+He16vEoboJm5QhLC9U23m4DE66PWJz/+ljF/75PO+tQ9nVQxZOZfdImv2DF7ygOBChwL2PaBO2Ul+p1T74usR8tLtAeW6gpWq3zY8kMrGr2/EF6FbsPxsBQxgDiSBYbwbICCdBu7U4eC7keDuP3ukjSN+ucfTaFjNk3ZRex5GMjniybFDf72w67eCWzCsrhAGQwj5HGfiXzMTIQK+EXWYNF9tw0mVETko8jt+i34ZRLteefvLzn0nOX54kSEk8lT1qgaYdiLNAKwuD0qwJMiizo8pCtqYP6904MuBq+yV+HnYHcc8ncSJ0GPUYlv/q5NvuP3YZR/Av0CrR0wDlMhj/+YAzf+Agf9eGA2VnJ5nfpzjNv6l8oAgPvSPXh06A3hbS0UG9Y0DhfhSOF1GYitnhA0xHWJJGPxD6GSatUBoUw6Hkxr2LnH2NeWcN+TDw/dCsvmBXdf4n8FmaQI2/uZDb0OlOQwvmKAVgsevHGvrlv9RzyjwDdkvJsZ7+PnyHq3sv/8SmkpR4JpMhlzbvOiwBcQF6iuZ1lujQx+MA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures [1] that need
to defer KASAN initialization until shadow memory is properly set up,
and unify the static key infrastructure across all KASAN modes.

[1] PowerPC, UML, LoongArch selects ARCH_DEFER_KASAN.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
Changes in v5:
- Unified patches where arch (powerpc, UML, loongarch) selects
  ARCH_DEFER_KASAN in the first patch not to break
  bisectability
- Removed kasan_arch_is_ready completely as there is no user
- Removed __wrappers in v4, left only those where it's necessary
  due to different implementations

Changes in v4:
- Fixed HW_TAGS static key functionality (was broken in v3)
- Merged configuration and implementation for atomicity
---
 arch/loongarch/Kconfig                 |  1 +
 arch/loongarch/include/asm/kasan.h     |  7 ------
 arch/loongarch/mm/kasan_init.c         |  8 +++----
 arch/powerpc/Kconfig                   |  1 +
 arch/powerpc/include/asm/kasan.h       | 12 ----------
 arch/powerpc/mm/kasan/init_32.c        |  2 +-
 arch/powerpc/mm/kasan/init_book3e_64.c |  2 +-
 arch/powerpc/mm/kasan/init_book3s_64.c |  6 +----
 arch/um/Kconfig                        |  1 +
 arch/um/include/asm/kasan.h            |  5 ++--
 arch/um/kernel/mem.c                   | 10 ++++++--
 include/linux/kasan-enabled.h          | 32 ++++++++++++++++++--------
 include/linux/kasan.h                  |  6 +++++
 lib/Kconfig.kasan                      |  8 +++++++
 mm/kasan/common.c                      | 17 ++++++++++----
 mm/kasan/generic.c                     | 19 +++++++++++----
 mm/kasan/hw_tags.c                     |  9 +-------
 mm/kasan/kasan.h                       |  8 ++++++-
 mm/kasan/shadow.c                      | 12 +++++-----
 mm/kasan/sw_tags.c                     |  1 +
 mm/kasan/tags.c                        |  2 +-
 21 files changed, 100 insertions(+), 69 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index f0abc38c40a..cd64b2bc12d 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -9,6 +9,7 @@ config LOONGARCH
 	select ACPI_PPTT if ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ARCH_BINFMT_ELF_STATE
+	select ARCH_DEFER_KASAN if KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
diff --git a/arch/loongarch/include/asm/kasan.h b/arch/loongarch/include/asm/kasan.h
index 62f139a9c87..0e50e5b5e05 100644
--- a/arch/loongarch/include/asm/kasan.h
+++ b/arch/loongarch/include/asm/kasan.h
@@ -66,7 +66,6 @@
 #define XKPRANGE_WC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_WC_KASAN_OFFSET)
 #define XKVRANGE_VC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKVRANGE_VC_KASAN_OFFSET)
 
-extern bool kasan_early_stage;
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
 
 #define kasan_mem_to_shadow kasan_mem_to_shadow
@@ -75,12 +74,6 @@ void *kasan_mem_to_shadow(const void *addr);
 #define kasan_shadow_to_mem kasan_shadow_to_mem
 const void *kasan_shadow_to_mem(const void *shadow_addr);
 
-#define kasan_arch_is_ready kasan_arch_is_ready
-static __always_inline bool kasan_arch_is_ready(void)
-{
-	return !kasan_early_stage;
-}
-
 #define addr_has_metadata addr_has_metadata
 static __always_inline bool addr_has_metadata(const void *addr)
 {
diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index d2681272d8f..170da98ad4f 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -40,11 +40,9 @@ static pgd_t kasan_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 #define __pte_none(early, pte) (early ? pte_none(pte) : \
 ((pte_val(pte) & _PFN_MASK) == (unsigned long)__pa(kasan_early_shadow_page)))
 
-bool kasan_early_stage = true;
-
 void *kasan_mem_to_shadow(const void *addr)
 {
-	if (!kasan_arch_is_ready()) {
+	if (!kasan_enabled()) {
 		return (void *)(kasan_early_shadow_page);
 	} else {
 		unsigned long maddr = (unsigned long)addr;
@@ -298,7 +296,8 @@ void __init kasan_init(void)
 	kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_START),
 					kasan_mem_to_shadow((void *)KFENCE_AREA_END));
 
-	kasan_early_stage = false;
+	/* Enable KASAN here before kasan_mem_to_shadow(). */
+	kasan_init_generic();
 
 	/* Populate the linear mapping */
 	for_each_mem_range(i, &pa_start, &pa_end) {
@@ -329,5 +328,4 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized.\n");
 }
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 93402a1d9c9..a324dcdb8eb 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -122,6 +122,7 @@ config PPC
 	# Please keep this list sorted alphabetically.
 	#
 	select ARCH_32BIT_OFF_T if PPC32
+	select ARCH_DEFER_KASAN			if KASAN && PPC_RADIX_MMU
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
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 9083bfdb773..a12cc072ab1 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -5,6 +5,7 @@ menu "UML-specific options"
 config UML
 	bool
 	default y
+	select ARCH_DEFER_KASAN if STATIC_LINK
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CPU_FINALIZE_INIT
diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
index f97bb1f7b85..b54a4e937fd 100644
--- a/arch/um/include/asm/kasan.h
+++ b/arch/um/include/asm/kasan.h
@@ -24,10 +24,9 @@
 
 #ifdef CONFIG_KASAN
 void kasan_init(void);
-extern int kasan_um_is_ready;
 
-#ifdef CONFIG_STATIC_LINK
-#define kasan_arch_is_ready() (kasan_um_is_ready)
+#if defined(CONFIG_STATIC_LINK) && defined(CONFIG_KASAN_INLINE)
+#error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
 #endif
 #else
 static inline void kasan_init(void) { }
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 76bec7de81b..261fdcd21be 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -21,9 +21,9 @@
 #include <os.h>
 #include <um_malloc.h>
 #include <linux/sched/task.h>
+#include <linux/kasan.h>
 
 #ifdef CONFIG_KASAN
-int kasan_um_is_ready;
 void kasan_init(void)
 {
 	/*
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
 
diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 6f612d69ea0..9eca967d852 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -4,32 +4,46 @@
 
 #include <linux/static_key.h>
 
-#ifdef CONFIG_KASAN_HW_TAGS
-
+#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
+/*
+ * Global runtime flag for KASAN modes that need runtime control.
+ * Used by ARCH_DEFER_KASAN architectures and HW_TAGS mode.
+ */
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
+/*
+ * Runtime control for shadow memory initialization or HW_TAGS mode.
+ * Uses static key for architectures that need deferred KASAN or HW_TAGS.
+ */
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
 
-static inline bool kasan_hw_tags_enabled(void)
+static inline void kasan_enable(void)
 {
-	return kasan_enabled();
+	static_branch_enable(&kasan_flag_enabled);
 }
-
-#else /* CONFIG_KASAN_HW_TAGS */
-
-static inline bool kasan_enabled(void)
+#else
+/* For architectures that can enable KASAN early, use compile-time check. */
+static __always_inline bool kasan_enabled(void)
 {
 	return IS_ENABLED(CONFIG_KASAN);
 }
 
+static inline void kasan_enable(void) {}
+#endif /* CONFIG_ARCH_DEFER_KASAN || CONFIG_KASAN_HW_TAGS */
+
+#ifdef CONFIG_KASAN_HW_TAGS
+static inline bool kasan_hw_tags_enabled(void)
+{
+	return kasan_enabled();
+}
+#else
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return false;
 }
-
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 #endif /* LINUX_KASAN_ENABLED_H */
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2..51a8293d1af 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -543,6 +543,12 @@ void kasan_report_async(void);
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
+#ifdef CONFIG_KASAN_GENERIC
+void __init kasan_init_generic(void);
+#else
+static inline void kasan_init_generic(void) { }
+#endif
+
 #ifdef CONFIG_KASAN_SW_TAGS
 void __init kasan_init_sw_tags(void);
 #else
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index f82889a830f..38456560c85 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -19,6 +19,14 @@ config ARCH_DISABLE_KASAN_INLINE
 	  Disables both inline and stack instrumentation. Selected by
 	  architectures that do not support these instrumentation types.
 
+config ARCH_DEFER_KASAN
+	bool
+	help
+	  Architectures should select this if they need to defer KASAN
+	  initialization until shadow memory is properly set up. This
+	  enables runtime control via static keys. Otherwise, KASAN uses
+	  compile-time constants for better performance.
+
 config CC_HAS_KASAN_GENERIC
 	def_bool $(cc-option, -fsanitize=kernel-address)
 
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 9142964ab9c..d9d389870a2 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -32,6 +32,15 @@
 #include "kasan.h"
 #include "../slab.h"
 
+#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
+/*
+ * Definition of the unified static key declared in kasan-enabled.h.
+ * This provides consistent runtime enable/disable across KASAN modes.
+ */
+DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
+EXPORT_SYMBOL(kasan_flag_enabled);
+#endif
+
 struct slab *kasan_addr_to_slab(const void *addr)
 {
 	if (virt_addr_valid(addr))
@@ -246,7 +255,7 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
 bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
 				unsigned long ip)
 {
-	if (!kasan_arch_is_ready() || is_kfence_address(object))
+	if (is_kfence_address(object))
 		return false;
 	return check_slab_allocation(cache, object, ip);
 }
@@ -254,7 +263,7 @@ bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
 bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
 		       bool still_accessible)
 {
-	if (!kasan_arch_is_ready() || is_kfence_address(object))
+	if (is_kfence_address(object))
 		return false;
 
 	/*
@@ -293,7 +302,7 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
 
 static inline bool check_page_allocation(void *ptr, unsigned long ip)
 {
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return false;
 
 	if (ptr != page_address(virt_to_head_page(ptr))) {
@@ -522,7 +531,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 		return true;
 	}
 
-	if (is_kfence_address(ptr) || !kasan_arch_is_ready())
+	if (is_kfence_address(ptr))
 		return true;
 
 	slab = folio_slab(folio);
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index d54e89f8c3e..b413c46b3e0 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -36,6 +36,17 @@
 #include "kasan.h"
 #include "../slab.h"
 
+/*
+ * Initialize Generic KASAN and enable runtime checks.
+ * This should be called from arch kasan_init() once shadow memory is ready.
+ */
+void __init kasan_init_generic(void)
+{
+	kasan_enable();
+
+	pr_info("KernelAddressSanitizer initialized (generic)\n");
+}
+
 /*
  * All functions below always inlined so compiler could
  * perform better optimizations in each of __asan_loadX/__assn_storeX
@@ -165,7 +176,7 @@ static __always_inline bool check_region_inline(const void *addr,
 						size_t size, bool write,
 						unsigned long ret_ip)
 {
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return true;
 
 	if (unlikely(size == 0))
@@ -193,7 +204,7 @@ bool kasan_byte_accessible(const void *addr)
 {
 	s8 shadow_byte;
 
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return true;
 
 	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(addr));
@@ -495,7 +506,7 @@ static void release_alloc_meta(struct kasan_alloc_meta *meta)
 
 static void release_free_meta(const void *object, struct kasan_free_meta *meta)
 {
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return;
 
 	/* Check if free meta is valid. */
@@ -562,7 +573,7 @@ void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 	kasan_save_track(&alloc_meta->alloc_track, flags);
 }
 
-void kasan_save_free_info(struct kmem_cache *cache, void *object)
+void __kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
 	struct kasan_free_meta *free_meta;
 
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 9a6927394b5..c8289a3feab 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -45,13 +45,6 @@ static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
 
-/*
- * Whether KASAN is enabled at all.
- * The value remains false until KASAN is initialized by kasan_init_hw_tags().
- */
-DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
-EXPORT_SYMBOL(kasan_flag_enabled);
-
 /*
  * Whether the selected mode is synchronous, asynchronous, or asymmetric.
  * Defaults to KASAN_MODE_SYNC.
@@ -260,7 +253,7 @@ void __init kasan_init_hw_tags(void)
 	kasan_init_tags();
 
 	/* KASAN is now initialized, enable it. */
-	static_branch_enable(&kasan_flag_enabled);
+	kasan_enable();
 
 	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
 		kasan_mode_info(),
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 129178be5e6..8a9d8a6ea71 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -398,7 +398,13 @@ depot_stack_handle_t kasan_save_stack(gfp_t flags, depot_flags_t depot_flags);
 void kasan_set_track(struct kasan_track *track, depot_stack_handle_t stack);
 void kasan_save_track(struct kasan_track *track, gfp_t flags);
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
-void kasan_save_free_info(struct kmem_cache *cache, void *object);
+
+void __kasan_save_free_info(struct kmem_cache *cache, void *object);
+static inline void kasan_save_free_info(struct kmem_cache *cache, void *object)
+{
+	if (kasan_enabled())
+		__kasan_save_free_info(cache, object);
+}
 
 #ifdef CONFIG_KASAN_GENERIC
 bool kasan_quarantine_put(struct kmem_cache *cache, void *object);
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb..2e126cb21b6 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -125,7 +125,7 @@ void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 {
 	void *shadow_start, *shadow_end;
 
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return;
 
 	/*
@@ -150,7 +150,7 @@ EXPORT_SYMBOL_GPL(kasan_poison);
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return;
 
 	if (size & KASAN_GRANULE_MASK) {
@@ -390,7 +390,7 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	unsigned long shadow_start, shadow_end;
 	int ret;
 
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return 0;
 
 	if (!is_vmalloc_or_module_addr((void *)addr))
@@ -560,7 +560,7 @@ void kasan_release_vmalloc(unsigned long start, unsigned long end,
 	unsigned long region_start, region_end;
 	unsigned long size;
 
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return;
 
 	region_start = ALIGN(start, KASAN_MEMORY_PER_SHADOW_PAGE);
@@ -611,7 +611,7 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	 * with setting memory tags, so the KASAN_VMALLOC_INIT flag is ignored.
 	 */
 
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return (void *)start;
 
 	if (!is_vmalloc_or_module_addr(start))
@@ -636,7 +636,7 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
  */
 void __kasan_poison_vmalloc(const void *start, unsigned long size)
 {
-	if (!kasan_arch_is_ready())
+	if (!kasan_enabled())
 		return;
 
 	if (!is_vmalloc_or_module_addr(start))
diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
index b9382b5b6a3..c75741a7460 100644
--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -44,6 +44,7 @@ void __init kasan_init_sw_tags(void)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
 	kasan_init_tags();
+	kasan_enable();
 
 	pr_info("KernelAddressSanitizer initialized (sw-tags, stacktrace=%s)\n",
 		str_on_off(kasan_stack_collection_enabled()));
diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
index d65d48b85f9..b9f31293622 100644
--- a/mm/kasan/tags.c
+++ b/mm/kasan/tags.c
@@ -142,7 +142,7 @@ void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 	save_stack_info(cache, object, flags, false);
 }
 
-void kasan_save_free_info(struct kmem_cache *cache, void *object)
+void __kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
 	save_stack_info(cache, object, 0, true);
 }
-- 
2.34.1


