Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705B3C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EBB8E000F; Tue,  5 Aug 2025 10:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91EC58E0001; Tue,  5 Aug 2025 10:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8358E000F; Tue,  5 Aug 2025 10:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1658E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33E32C05CF
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:44 +0000 (UTC)
X-FDA: 83742929928.12.E39530C
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 345AAA000B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=etjU2I1d;
	spf=pass (imf25.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DndoJEoEU+djai/jF18bii/cwZvYONRQ0C6xs3DhJyU=;
	b=fH2NHwVyFYvjr4569MztBpwqIVN3Ul+pYmEa6pvcXDorltccBgt7TrHN8Y0g251knv30KQ
	M5yrVKI3hk4uOwIifDpFZHVlvFX/D3zdZJm6rJFY/48vihw+XChkAifnPM6RH2fksRo77j
	FOFwzWAVaTi/vYg9VcexwiDTbSS5WKg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=etjU2I1d;
	spf=pass (imf25.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404002; a=rsa-sha256;
	cv=none;
	b=jXuSYrPTxUvJvuFgidh6cfPB/KzpE/joRxkP1EoSMH+cBzzcaykQ84C+GWf3mHWKjBnsT9
	lfYpooc+fV63ISFVad0M8EIxqCMzqPCcZ+YBcRcbLy4ELscCMeY2WjFyB7Vmu79HdaM9/n
	9OZO0Ec3wzLo4Ytceo/JYrTz1tThwq0=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-55b797ad392so5690514e87.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754404000; x=1755008800; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DndoJEoEU+djai/jF18bii/cwZvYONRQ0C6xs3DhJyU=;
        b=etjU2I1dJw2dH2Nx7cCBBnf7g6oIhQBCWlmloxcjoeRYkslZMfsoY/zQwtLWC2GyAQ
         GN1rAIB0ko4nlWHagHPiXHuUcSs6K62U6Kj4HhVWRH9PfaGiOJl30UK+As1S2niQaDOc
         hQZCDrwNRB6pDQMd8xeSA+c9jbSG2Tj+xsDWhLX3SPrIq7hgSSWMaPpXdolkr28msK86
         UZembaXNcdmFD1hHJ0IayMNF9SMt0mLxPn/ABCfNOTH7l7be5suC8n/w+XE+SZ5RpnAN
         R/1LIefsX1E6xsMYT/vAKzh7Gl28TmI1PCmH9va9WtPxsPQuvOpCp1Je91SdRyMFjQ5U
         kTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404000; x=1755008800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DndoJEoEU+djai/jF18bii/cwZvYONRQ0C6xs3DhJyU=;
        b=OdNQibdbu1CJ9l/YKwkoQZ0yeAP+YzaESsJvruK1K9b9FB5BafHUXNWxiHqWJtuzkY
         viFV3/U3sZlnHhLKJAoGeztzVKwLYu2sc/q7HGhGDiueGkG2BzWbJb8OqoRPrVTGakP7
         /Uqem9hpYrbfAoQi8a1IF15IdmOuvylzvHYmv9SAz569scC1jexRLbe33zYxpomVjYxl
         UN+p4Ks0nkGggwlKXSzG1w6z4pE0J24muNLy3ShCqlp/lvdSxon/6YGSqFx14jMucy++
         1ZVUfar9n4BWxsS4tW8NLcB9KEvhIKxIIsIm18FlX6M/DD8NIEfe5JBtcLxObiAbhw2y
         iyQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLwZqqjTznjSQL7Jx4avEyGqCbeH+s2EmAy1nYGwSUD/8bh1CbVGXgB6l7JUo6O5yem/RyAGqyfg==@kvack.org
X-Gm-Message-State: AOJu0YzGZfBVCUuB651KTEUPWeGfFi8EAAy8RBu3Gtmy0OcJv8wE1vSH
	xUtu3+6mHfzu7uxyATZJYfG3YGeBbh7bQs5IiDHjQMZn0ec+ek0+x2tT
X-Gm-Gg: ASbGnct24CfkKnqFI9GuL65YSykGIiqRas9VinIV8W6kXMDrmudEKfT3pDD/cQdrWzl
	y3SbGWPeMISZ2DtTWAH+VdSr8tqfi7l26kmjpZXvMuwUoVLYwz1zpUjmHC2uC60L8BvBtBdHB+5
	9ljlsGxQxT6u1N9nvVPpEHm1zwcN5h7d1/zCk2zp2pjFcUCc3KBV35qK+nIkK1Yhp+ZsQIexnOl
	YkaY8njEcwSMOHzamESDss+vZhWiFMHxGcELuQ4K1+PuLF0mBYnggHV4a0vtY4mNIuJloGe2tkI
	eQgRwJ4Aj0lQSfqMG28hyQAIkb3ZJUAqKo9ydF0OQzPna1sN+KlFqqL/yjAfujBW25FLgJDlsko
	B/OkAzk3OfpXF+0WJ+AGmbK6DZX6SPC4r4dzctrvmZyR2yXDzHUk15FZmKsFHfd4FMVn5LQ==
X-Google-Smtp-Source: AGHT+IG8YXFpsfEvWLWpJ0j6eFW8/n9npKWJxSkpHVdxT2hyDgxCfNXo+mPOdolEzpL3+MkF6IOdvw==
X-Received: by 2002:a05:6512:1387:b0:553:25f4:695c with SMTP id 2adb3069b0e04-55b97bc54b1mr4200362e87.50.1754404000307;
        Tue, 05 Aug 2025 07:26:40 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:39 -0700 (PDT)
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
Subject: [PATCH v4 5/9] kasan/loongarch: select ARCH_DEFER_KASAN and call kasan_init_generic
Date: Tue,  5 Aug 2025 19:26:18 +0500
Message-Id: <20250805142622.560992-6-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805142622.560992-1-snovitoll@gmail.com>
References: <20250805142622.560992-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 345AAA000B
X-Rspamd-Server: rspam06
X-Stat-Signature: xyb7oss6fhxjkwt18q5t5rpyrh5snyyh
X-HE-Tag: 1754404001-142842
X-HE-Meta: U2FsdGVkX18O8AgrWEgz+SCSaXT2Dh5dq4m2FOPzxjQmVzg++pvvX9XqBNZBinI1+6DFwUveQFaPCcL5OzILcJxXCejDI5LQvM3F3CdjF7ji/wBWk3e10pHKA/IjPU7f6/DQ+Eus9m6ToZW+svnhmd4M1SU1VnfEJLfov3BX1tv1qCeKR4qt1PcD/FLwYfn3fsrC5A27BfudJtUdK6nkYpztzlA9RXTfueLpeWkVfrVjc9WGQX0Um821Ud7ayRM5Q8VUBh1mbpVhywlbmsYzKU8Fm5U7f/ITEf6LaJUIUwD0tNOIGmUIXOTAOSUFvlYm6EeQCnL0gOzrwDb85d9GIj77BYXelRRzy2kmcSSKYWlqeUuh+51wRGhnxxJLPb1KqKlRPbQ2Axh2EiV/zTiSiloW/0MSoIyo2QCcU28b4ngMRBooCxDnX6piYcJOlXCv8yQqdeYrqzibe5bwgBsFpPNAfnQULCKhudCaqZkLijjEGKg1XUIcy5Q19fcsRdhMlTpX0DE5UstA3iv/m61arSwWXN1p9yyHPXW0BUg782R9Z0ZRrKZOQjvBUPzPQjFAI8L0HiO132zn/Ab2Xpj+BOlXNVYclxe/VJhX7FOgPn60EytU+EcB2pPsOfURdnj2imDJ2tb32brSfeprkw/NGHKpEobM1K0N5TNpumlY5gAuPtFLKPHydX2gRaTRnCULzgEc4YbhVB1ffyMsh80/EmxOBfhDTCPK5GqAagiJguS4IXVWGD4Wy27RO9iEIiGCm9o5MNvHfVS9AaJGFwRAOkS2MSnudEFa0t2/3LznNpy6n3z4pQYXPb9Ood2l7rgb3WUzdpqC6FHjHp1y0FCWXczJ4wlHg/3G1FTERpG4+VcLUUXWevBtZ/A5VcJrYMRNh0GAzoqhhM6g8V8GoNgXMdT6ckSPLGxnF6WkG2xGboS+g2FLHjC2nWBKOSMSjuFRnwphQMmInrlGEo2h1oO
 qsWFWYNu
 WBb2It76O2Zl9QzfPeScIiTuqJM28k0wNPWWxEuZMgRJuA5h1RVB61abyDai5QbOFQEUfiAZdeHBkHxyzYX2VCQ/PvkOd8H7hTYOw+bw+tV17w5k3HlMIg7fr6XHTkNLusdbcic4Z+ElSYXOZuM3gu1igzjq7iXWHr42O+NWzaK1+T3jGlz44y5G/ILZBzS5xYCfR17+nLlZg+R3YJkZHzfX7wMy/g47bY3ueESUTheHV6MATwa0YpXaM4Noqe5R8WULyBOtVX/7leTFDFDZGoCQWWkC0IKxUjVPM6xItGokhNH6lH3CQqhwDQE/9d9Vn6ziiC73A0/271ngo/dEG21xIrf8ISlxQqR3/IqAXL9DXTmT4Ag83AAi6GW0IdY7nF+U2V0tVYbN+1YCFy2G8lPcxQlUOIWsQMJvOFrq4A+NxuGUrPJt3wvxXl6KkwLwhiYfxDS6NIx+/f684zYJFhav/YcpzvLJ/AxDxYeYhScL8axrFM5Lh1l7Im2wL1DpfxOocOcwdamXvtczV5hhW+xUbFay0a39ItuTPYkNau5R/QplgCXETSdH6aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LoongArch needs deferred KASAN initialization as it has a custom
kasan_arch_is_ready() implementation that tracks shadow memory
readiness via the kasan_early_stage flag.

Select ARCH_DEFER_KASAN to enable the unified static key mechanism
for runtime KASAN control. Call kasan_init_generic() which handles
Generic KASAN initialization and enables the static key.

Replace kasan_arch_is_ready() with kasan_enabled() and delete the
flag kasan_early_stage in favor of the unified kasan_enabled()
interface.

Note that init_task.kasan_depth = 0 is called after kasan_init_generic(),
which is different than in other arch kasan_init(). This is left
unchanged as it cannot be tested.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
Changes in v4:
- Replaced !kasan_enabled() with !kasan_shadow_initialized() in
  loongarch which selects ARCH_DEFER_KASAN (Andrey Ryabinin)
---
 arch/loongarch/Kconfig             | 1 +
 arch/loongarch/include/asm/kasan.h | 7 -------
 arch/loongarch/mm/kasan_init.c     | 8 ++------
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index f0abc38c40a..f6304c073ec 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -9,6 +9,7 @@ config LOONGARCH
 	select ACPI_PPTT if ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ARCH_BINFMT_ELF_STATE
+	select ARCH_DEFER_KASAN
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
index d2681272d8f..57fb6e98376 100644
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
+	if (!kasan_shadow_initialized()) {
 		return (void *)(kasan_early_shadow_page);
 	} else {
 		unsigned long maddr = (unsigned long)addr;
@@ -298,8 +296,6 @@ void __init kasan_init(void)
 	kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_START),
 					kasan_mem_to_shadow((void *)KFENCE_AREA_END));
 
-	kasan_early_stage = false;
-
 	/* Populate the linear mapping */
 	for_each_mem_range(i, &pa_start, &pa_end) {
 		void *start = (void *)phys_to_virt(pa_start);
@@ -329,5 +325,5 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized.\n");
+	kasan_init_generic();
 }
-- 
2.34.1


