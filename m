Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0495DC87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 12:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9841C6B00A2; Sun, 10 Aug 2025 08:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9346D6B00AB; Sun, 10 Aug 2025 08:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC586B00AC; Sun, 10 Aug 2025 08:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 608616B00A2
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:58:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2E0F16049D
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:58:09 +0000 (UTC)
X-FDA: 83760850698.04.9EB9221
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id CEC0020003
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:58:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EGdbYQyf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754830688; a=rsa-sha256;
	cv=none;
	b=drgBGZMCQkRgB8F6Tm5SQ3PK0cqCexcNoUgrgyZkx0/5VSFeXPbvjHYXMIwmFotwEywcTp
	o+0IBZGW9QcsNKkAY1OyzkeELL2HY2+9Fp+G7slJ2gq0UhErbIoQDK4iuk4Ai4d5eLR/1V
	VvNHjPR95/jKgNQB7vjGnEv/ao25hWw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EGdbYQyf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754830688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKeR5uHoWIcIuAKYQgjQzhpWKD2jCeMi5KWikEai+a4=;
	b=KEODSQh3VQK6qKKfWQIT+h31relxzNY2u5C5APj/KZbY/pOzTnlxq9jPlJ1ta1c4EJq8zH
	lQ0TViCoxHGXnmfC/wHrjPs2HBu4zVcbDybuTYhkoiO/oCVnOpH9uZ9LRUVaPBp0cBbIc2
	abbTmTdR424sofFaXZL7QaNKjfrz6Q4=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55b8bf653dfso3857737e87.0
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754830686; x=1755435486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKeR5uHoWIcIuAKYQgjQzhpWKD2jCeMi5KWikEai+a4=;
        b=EGdbYQyfmD+uZNBSEwzmrAaBlw6L40UXWwSHHPfiNWPAd1c9pJSuQpy2COZPszdf5q
         dGZ9EAl/f4P/5AjwdI7rNK5NkhDZMWyEp2YnbykiG0xGBdGF2z9LwxbhX9tmeOKpPKdY
         hC2DRk4hS8SWXYMm9nd6gkxaPrOi7F3sLpAJQyrAmlOytMG3clRrL+tlLZY94VtKvCNr
         /CKshxI1FP63RDDdHDHetrtWkULl/1ecq16tkhJ11U9RvJaGQbb3co5W7yIRw6D9nnwj
         Wive080z8Wu9Qm2A6RbNNnD0DiGfF7TifFcc8tRM6vOtY/tqziHAPnR9h/XSHoU66x5F
         Jbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754830686; x=1755435486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jKeR5uHoWIcIuAKYQgjQzhpWKD2jCeMi5KWikEai+a4=;
        b=FakUlAgoGEpKGoo3kdmCShKnL2hh7KG2+wtPOcIwPQL3/kCFYbIIybMzeA1HoRH95Q
         rq/NPwgOygvodA8/tyO3UnfyGggZuTkMEKgnMCFgELFiYqilujYxvccGzFGKGmgXLZkM
         FfezhrvqJMhDdQTkitHS9JLndPv+EK858EL80ahVWP0PJTUngjTdMdt8ElmsCifjTqJe
         YhT7LPfLVo0wug2yQzo1OWo4+MA+QILV3uFPcXu9MaFe6hH4WM5UHkVxHGv6jbxTpn1f
         fi6IFUsO6037jBRpp8aiQGCUvMJQf0FRfDgnB2nH+meYT6PB8O7zGFbBqgminE2FLwDT
         omrA==
X-Forwarded-Encrypted: i=1; AJvYcCXvV+kxKX04MWPZ3EmcYHnOiAEzR40roun0oz4QYeR0+6oq2AqFISYw/kcZ528Hxk9q8wtqXbn8YQ==@kvack.org
X-Gm-Message-State: AOJu0YwsnY133MeBT2tgHe/AksU18Vl5gVc2ibvJiuoMfqx5hR5hXrg1
	x1b1nf8x0xFRvXWFUB3kcwOxKSMu95O76aYyMcLkGsnpORdMNriHmXqW
X-Gm-Gg: ASbGncuk/IyuMsWCwFPlanvgHH+v6I8+ncqWIIKW1GSHmpSNf3fq/gSMvoaIuloF63w
	xvvnQ5MhSa1SIZLMMMaRmjaXlx8HyoBNYln2PB/4M7Ri2CzXBKtjS9r35IzWntyHYrltaalW/iI
	kl8CVsLZN9X0uahKzpFQ+41LsAY7do78bjMjGZByaKjUwSR6YNcoNGzfIsKDHqfT5whs0DJ/HyD
	X+mhnEIcoQdHNX6GZnuOR4tbIKJp/nRKHCnZdpdjza2ocJvS2D9/Pj9Hf2Dwi1N4cKJJIJAvozo
	oz1OppDSx6cwWvic0E31B4OoeZQJF0mpl2rz+3NDCpP/LXj0Tj1MA8WZZ2vxLwKKH/BzFR4L01p
	MleJXAj5XsgcsnYCKAmewJdhtd3Th+2lMEgL/Og==
X-Google-Smtp-Source: AGHT+IErXkbMxszWeWK4iBKntLkDp5w8ZvgbUHZU1lvQV/xiB2iEZXUIzYb1B+mD0a2Z3z67sFMnHA==
X-Received: by 2002:a05:6512:33c9:b0:55b:95a2:d70f with SMTP id 2adb3069b0e04-55cc00ec563mr3184446e87.18.1754830685714;
        Sun, 10 Aug 2025 05:58:05 -0700 (PDT)
Received: from localhost.localdomain ([2a03:32c0:2e:37dd:bfc4:9fdc:ddc6:5962])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9908esm3804561e87.76.2025.08.10.05.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 05:58:05 -0700 (PDT)
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
Subject: [PATCH v6 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
Date: Sun, 10 Aug 2025 17:57:45 +0500
Message-Id: <20250810125746.1105476-2-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250810125746.1105476-1-snovitoll@gmail.com>
References: <20250810125746.1105476-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yghdfcx6ce9pt5zd54todirw3oj7omoa
X-Rspam-User: 
X-Rspamd-Queue-Id: CEC0020003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754830687-424795
X-HE-Meta: U2FsdGVkX18H/04tcpBmzCNDUByY0JNSsVSFfYK0fiaj9bqxad+WyBkvhIpcRwU27SvxHrsXj3UVTFjfFO08cZXjQeZmMKdUmNYYlUTvQtXmi+Kwishp2G7yb2zVvMmx0pDX5DPl8DuLOXF8yVOwtgj9eI++CQ2+b3cJMoc0fu+x589adO9ftCfeTqtyslD6Jujvc79lzDz0rIFdH93zsEQE/WknCUhjtBWdx3npE8HolCJKQ6Ci0P1IItt5zaUZ5YYKpM9H5lcw7UszEyQFf6hcyV5nZ9s2jNSM5zrWTyrZ5Q7rWzUfGkOd3f+eveT4TlxO7GoV/POjmLBh3EHxe6PdIwywF0MUO4L2TyginjhU/lb43YYAcnJeY0iG/HN6FUFL5YqyAXdK1YBz+BA0ZfZKBWYbGLCYHcoa67qg7Hl6nhqGBk9vj4oN7n67p5NBm9OI0feInRdw5TGpS9UdnBe5jG3gQCFIryrneFLF1O+118L9TpnEYnNfdHmnwct1gWHwa99AwFahrYDowl8NjuMy/p1X8VuWncA5CrL1bH2xyTsYZRB5fDTC8BJ+Kr7py+I1Hd5x2YrMnE/GpEMf8+ATtMApcxoUKjDWiQyG4t1pz8GG6KsCqsSnVkaKm/9+ZcLJCglV6/ksDn5P1G54tTU3B/ZFQJGGu7ZoVXo4pB8C/wk0crow47hlHKBBSpJAMT+k0XAzfXVbaAYzdQcijQRNEkefa/RQucG70emFxsMWBr6988svnFWNRjPXc1JjDC14CrtSYATLIazi7t1g21U6oy21ZEigTvU0Vaf+l36W7mmaZhIIZq7uCjn0J2NEMcjPR+ntQOaBO5HBtCcb0CgiW9xEX6PXNaeNZHfXuH8E5aCsQzY4Oy9PPXZcBX2SiMnqICLcJAFU1/XcopHiXNoOjNikyGW9e8LiT/eb33hJLQh0GUZQp+hl3sdx1FFOB5FBtnpGcspLFIowkZI
 pUWoEJ0v
 1JU3aJnJCQ512CO1Hgk7HkNr+VdU+LR8HjREvXhL+JAzmkbvUrSbbcQez0GtMI0ybADcvpxf+RuWN3Brs2e6VAp7sABooGyc5G6XZrKp8+zLkYvXK6AzpjlSE5srm/iORIG+acVI/on08ERyNsYtbEsqOHqBa2KiZFVVJ6UhK2Kgv/ADPUg0KPOPk6VCdesAsU3lZFzJfFxZFayRVxBmfYYZfiKlAC7Efxmd/CPxEgaURjN4N9SFJYOP5KHj1uwjfhUAzD7j1FslxqJDgQOc5bAUqY5Yu/hJ9uZvaD0N//DTXzLh2hD4yE8tV6vhYuZj8JqBqIbtIsykTP8dV4BvdcwDIb4g06qyr5IqZBdiCbLEJHoHVpx5oOJ3K8SelZqu+TiJee6CIKFY5bTSZ4kryEaK+ItKJMft9wl7E4khLMS6EKB3IglllZ4wv9VhDoi/jkdYfyZJ7NN2O+edCgAxQGTOpCtO6ffO/LOsHyxyTEHYoF/pnbQgzjBEWO9NLDFjHHwc4sQTWBMBwcL4S1bCM3Wi/tHWYFIxqv7pzNI4Y6TIe01jdcmM184h+3g==
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

The core issue is that different architectures haveinconsistent approaches
to KASAN readiness tracking:
- PowerPC, LoongArch, and UML arch, each implement own
  kasan_arch_is_ready()
- Only HW_TAGS mode had a unified static key (kasan_flag_enabled)
- Generic and SW_TAGS modes relied on arch-specific solutions or always-on
    behavior

This patch addresses the fragmentation in KASAN initialization
across architectures by introducing a unified approach that eliminates
duplicate static keys and arch-specific kasan_arch_is_ready()
implementations.

Let's replace kasan_arch_is_ready() with existing kasan_enabled() check,
which examines the static key being enabled if arch selects
ARCH_DEFER_KASAN or has HW_TAGS mode support.
For other arch, kasan_enabled() checks the enablement during compile time.

Now KASAN users can use a single kasan_enabled() check everywhere.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
Changes in v6:
- Added more details in git commit message
- Fixed commenting format per coding style in UML (Christophe Leroy)
- Changed exporting to GPL for kasan_flag_enabled (Christophe Leroy)
- Converted ARCH_DEFER_KASAN to def_bool depending on KASAN to avoid
        arch users to have `if KASAN` condition (Christophe Leroy)
- Forgot to add __init for kasan_init in UML

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
 arch/um/kernel/mem.c                   | 13 ++++++++---
 include/linux/kasan-enabled.h          | 32 ++++++++++++++++++--------
 include/linux/kasan.h                  |  6 +++++
 lib/Kconfig.kasan                      | 12 ++++++++++
 mm/kasan/common.c                      | 17 ++++++++++----
 mm/kasan/generic.c                     | 19 +++++++++++----
 mm/kasan/hw_tags.c                     |  9 +-------
 mm/kasan/kasan.h                       |  8 ++++++-
 mm/kasan/shadow.c                      | 12 +++++-----
 mm/kasan/sw_tags.c                     |  1 +
 mm/kasan/tags.c                        |  2 +-
 21 files changed, 106 insertions(+), 70 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index f0abc38c40ac..e449e3fcecf9 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -9,6 +9,7 @@ config LOONGARCH
 	select ACPI_PPTT if ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ARCH_BINFMT_ELF_STATE
+	select ARCH_NEEDS_DEFER_KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
diff --git a/arch/loongarch/include/asm/kasan.h b/arch/loongarch/include/asm/kasan.h
index 62f139a9c87d..0e50e5b5e056 100644
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
index d2681272d8f0..170da98ad4f5 100644
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
index 93402a1d9c9f..4730c676b6bf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -122,6 +122,7 @@ config PPC
 	# Please keep this list sorted alphabetically.
 	#
 	select ARCH_32BIT_OFF_T if PPC32
+	select ARCH_NEEDS_DEFER_KASAN		if PPC_RADIX_MMU
 	select ARCH_DISABLE_KASAN_INLINE	if PPC_RADIX_MMU
 	select ARCH_DMA_DEFAULT_COHERENT	if !NOT_COHERENT_CACHE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/powerpc/include/asm/kasan.h b/arch/powerpc/include/asm/kasan.h
index b5bbb94c51f6..957a57c1db58 100644
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
index 03666d790a53..1d083597464f 100644
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
index 60c78aac0f63..0d3a73d6d4b0 100644
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
index 7d959544c077..dcafa641804c 100644
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
index 9083bfdb7735..1d4def0db841 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -5,6 +5,7 @@ menu "UML-specific options"
 config UML
 	bool
 	default y
+	select ARCH_NEEDS_DEFER_KASAN if STATIC_LINK
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CPU_FINALIZE_INIT
diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
index f97bb1f7b851..b54a4e937fd1 100644
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
index 76bec7de81b5..32e3b1972dc1 100644
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
@@ -32,7 +32,11 @@ void kasan_init(void)
 	 */
 	kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
 	init_task.kasan_depth = 0;
-	kasan_um_is_ready = true;
+	/*
+	 * Since kasan_init() is called before main(),
+	 * KASAN is initialized but the enablement is deferred after
+	 * jump_label_init(). See arch_mm_preinit().
+	 */
 }
 
 static void (*kasan_init_ptr)(void)
@@ -58,6 +62,9 @@ static unsigned long brk_end;
 
 void __init arch_mm_preinit(void)
 {
+	/* Safe to call after jump_label_init(). Enables KASAN. */
+	kasan_init_generic();
+
 	/* clear the zero-page */
 	memset(empty_zero_page, 0, PAGE_SIZE);
 
diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 6f612d69ea0c..9eca967d8526 100644
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
index 890011071f2b..51a8293d1af6 100644
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
index f82889a830fa..a4bb610a7a6f 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -19,6 +19,18 @@ config ARCH_DISABLE_KASAN_INLINE
 	  Disables both inline and stack instrumentation. Selected by
 	  architectures that do not support these instrumentation types.
 
+config ARCH_NEEDS_DEFER_KASAN
+	bool
+
+config ARCH_DEFER_KASAN
+	def_bool y
+	depends on KASAN && ARCH_NEEDS_DEFER_KASAN
+	help
+	  Architectures should select this if they need to defer KASAN
+	  initialization until shadow memory is properly set up. This
+	  enables runtime control via static keys. Otherwise, KASAN uses
+	  compile-time constants for better performance.
+
 config CC_HAS_KASAN_GENERIC
 	def_bool $(cc-option, -fsanitize=kernel-address)
 
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 9142964ab9c9..e3765931a31f 100644
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
+EXPORT_SYMBOL_GPL(kasan_flag_enabled);
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
index d54e89f8c3e7..b413c46b3e04 100644
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
index 9a6927394b54..c8289a3feabf 100644
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
index 129178be5e64..8a9d8a6ea717 100644
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
index d2c70cd2afb1..2e126cb21b68 100644
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
index b9382b5b6a37..c75741a74602 100644
--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -44,6 +44,7 @@ void __init kasan_init_sw_tags(void)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
 	kasan_init_tags();
+	kasan_enable();
 
 	pr_info("KernelAddressSanitizer initialized (sw-tags, stacktrace=%s)\n",
 		str_on_off(kasan_stack_collection_enabled()));
diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
index d65d48b85f90..b9f31293622b 100644
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


