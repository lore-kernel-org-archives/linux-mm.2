Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38EAFD111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 20:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485F16B0062; Thu, 27 Nov 2025 15:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D826B0088; Thu, 27 Nov 2025 15:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326356B008A; Thu, 27 Nov 2025 15:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 161716B0062
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:37:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9C4A12B9A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:37:42 +0000 (UTC)
X-FDA: 84157547964.10.FA18A4F
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id F044F1C0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:37:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HPLMJF6V;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764275861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAo/zLdFSCy3ZivNRUcyPkQKSGvTdHQmOTB6uk6YR/E=;
	b=aFVrHcsqkTbjVnv/3yYRWWEuM38+NZwSRYtSevAIKcQ7NOEIGpU7jUuBacIxw1KgEIKtqb
	uQwxymtdNpqdKeuydtb5tAqmBZtBlkAfioejHLt981awvM1i6FomdQIetdqFvT5LoaaeOg
	0qWdXjtE0LcQ/EjMmwDi9n7wqVnQS0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764275861; a=rsa-sha256;
	cv=none;
	b=nTMBLFH5IXTmMZTr2YEnD728Q7/KGcKFHAqKFS5em0e3Mu2hB2WIH1DBa06kr3NAtjJ3Xl
	f7f5/tjtQLbRAlmYV/P81q6+XrKzrClUdn2RnHBkKRv9irBpaFWhTfLetXLUNqOEgKWaDE
	9A4NcvP3q1aiG6IODLrohVUP7jvlAa0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HPLMJF6V;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c7533dbd87so855237a34.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764275860; x=1764880660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAo/zLdFSCy3ZivNRUcyPkQKSGvTdHQmOTB6uk6YR/E=;
        b=HPLMJF6VyBSvhINEH5QSQ3mzzdiplOkKDoQXSwTtdcpuU3L1qT66nQNm6RKzjmRQSR
         Yr1lUHtr6/FEEwmTxNSUv6q4PlGhuV0eflmPoCb1U+IOzGZNGdW6etXXg3a6rGZ3rmIb
         k3OrFzdY/tMGdkiAb8a2yZUjBPnkqTEwCUwH9zXCt4V0eAxLtFQMVnsp/WGoKAzYU0Fu
         J7NXnkfSXM9c9UBO7s//D1PZqxpP3FaLRHKx1msrdmGo4MIzD6LvhxLFKmn0Wsybq67/
         Qo39RkizwLbmhXVStAFeJkthE2t6E8s7+IwvgEgvCkHytVjOHkhAXSRhf09ktw4YWziz
         RsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764275860; x=1764880660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VAo/zLdFSCy3ZivNRUcyPkQKSGvTdHQmOTB6uk6YR/E=;
        b=KtpRakk1ELCV8LJ/EJ6NCmtWYsH7AOfZxkdZlG+RqE1cbUYiJH1OZfp22ipx3QPyGD
         wDGxvW8ynZFO+vvHf6zX8jY4ODrfM2Pm9ixor//tfSLArSJwAsUki/8F/w67dcu1VtmK
         P4mEA7ePZz/nkuSi72eVWhC8jTcRPMNP+ZIW6Vhc6uTafPI63WvFt6I6lIk9KI/HOEWx
         eGvDg7BH31hIWiPwvUWW6n9EXuqdVHetqKv3ux3ZUjjnJ+eNUUpEeBmZ1Qs9GZ5FCXNP
         E2pGg/ruf48e3ELbQYgpV4FTnK2Z/sm+BQDxcRMRIoLSh6lag/mDBRxUsHXc9qPF/pSi
         lo8w==
X-Forwarded-Encrypted: i=1; AJvYcCUY+36yIEcG0jucaQXKLIpuI58jOkocVpCQrq442Y9jWsnYVBp2a2gVcI8FWbwgBaIjqA6HeDR+xw==@kvack.org
X-Gm-Message-State: AOJu0Yy+zPijDf1OdK4Tyyo/rTBCqK90KkZ2OzdzCnn+V9Tm0vTUDdQY
	3+l5KTndM4NIlHLSGSgLz0pjer4mzjsIljU8eBT67Qm6msMJYDgYjwo5
X-Gm-Gg: ASbGnct8FmUo2OXVrbbtfaZh8XWFCabReCpDlVx8kQJuJ9bOze9HQS6gTtNyL9IgGa2
	H59JC88wmDJTn3lHS7AvUxCGfeM00ZX/WIasQQDv+caKWAcH6aY1752H8lSXAIvm203bf/WSbMd
	17pVWrlisVrvlRzIxdz7+xLrsAyGcnb3UgnVRrfnsydjROtBS2puupyJW2FFNNV0kCCgLLSrfso
	FklwRZCgutCOSAQhKU/UgTF2ZfYQo8T46Kqjf3CeQYfV12nOzduCz6J2iRxaca7dztvklIxCnYI
	UIq2PWPyQhtHpAt1mWaM9Jm2d5GkHfxjNrDFu4lKIHc7Ag38PLpLDeJgYpUUeEseYUQEB4umnAP
	J2ZKKK3zyHqqpOwd8AifRYBF82Oct45Ne4G5NcAK/UGFGQBJd9fEhtS+Z2cFPU/sK6zF6Rrq62y
	erjRU/fDOhzpeqFiAb8LQ/
X-Google-Smtp-Source: AGHT+IEITYWy9i5DwKGZeqsAnMC7fmhTam9fuM6t1EFIYEodQWt51NIFnOdOlkyNhfNj6pAmkAkyQQ==
X-Received: by 2002:a05:6830:7309:b0:7c7:3416:ff8d with SMTP id 46e09a7af769-7c7c412baf3mr5820407a34.9.1764275859847;
        Thu, 27 Nov 2025 12:37:39 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c90fe15847sm871772a34.25.2025.11.27.12.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:37:39 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kas@kernel.org,
	changyuanl@google.com,
	graf@amazon.com,
	leitao@debian.org,
	thevlad@meta.com,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v2 1/2] mm/memblock: remove CONFIG_MEMBLOCK_KHO_SCRATCH option
Date: Thu, 27 Nov 2025 20:33:19 +0000
Message-ID: <20251127203724.3177621-2-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251127203724.3177621-1-usamaarif642@gmail.com>
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F044F1C0012
X-Stat-Signature: sc7fpemjztwfhfog3d85t8zn5sk357q7
X-HE-Tag: 1764275860-177693
X-HE-Meta: U2FsdGVkX18D7Eo8+jXUEPN6I1B6lZgJdNKbot/Cfkn+lJi5hllBH2KaOEr4N2K/KjbPjBYqE5kVD8h9N45DKozriMsjNaa7J0IIO1QZt3Zoqnl5/2bk1JbsMXfgF3Z147vG6XwJhTbId/07Yz6/V28hrCkymjF7MqPZSc9qzq4VulansD3hIDHXj1iHFyYkVr14DlgwzCv1TH8uUi6+Dy+B+Zo1P5Cz6PpgaLA82RM/5sP3KLEwNFnIdJUXYPmLAOLAEphbxflqIrIslFpEA6IFG4ecPJZErBY6rGeWH0QiFA/jZ70KzLQ3WA98hzqXyxoIl3Sut17IMJr7GXrn3phAKnpSwdoNvCX3GaVMu4g8Tze1kD1kvuIhRu66hF3Ssd9+PZfIaAlFijpygjfBrp5pgYFFtN4zLCe6/VdL06vEI0SQcSwJiyY94ltE7eU/lGJVnPpm7dhTYweRZ778f6NJI2XnoJ+PVK3n3Kyg+5B83hO/GjZmIKO7iImxEo3aWkPg2cW0g7ya66Yjpcyk6DP+inLlu7bJklIOCawGSLncmQNlgqLb4bsCq/HYq8DsSrSvg5gBq7MUMqrfgg4sxWOFSarpFeYLRFa02BG8nK4C04nPR/QOaD2LGKwkwfslb0h2mXvWaxGtMh6kBYkyrBMI4X8x6Cm9hQBF3hyh2VwQolSB3nY1fayXz7S7J2zLcw/ekuDKytxi9LSfcUjytEygp2WYLWGtRocwh4vftjR+/I4snGW8csWbh/h25sxPaJboAkK+WuQBPmJKflW9U3dySFxZjsY8F9AdrUt6Ed7nti1Rhdg/gdkIqQfsTWsBZfRR1UllugK6CE934jGrJa2F98JGSatET6ZdK3DTypmoG6ks1UVKfmFfCahGlz+zRK9aS82hSRe3phi+LJ0zY/yl3AV6RA/xmzQneYti9tDu7d6rAU1FZ6oxaHDy2znV7LTxHOnQsn3KXsf6e+M
 6/bRJzyQ
 qgMj863HF1V0PsL8TwNpfQGtII8otyhCNI0UfJdnjErGWqdouF4Eyl4/iKNgG0dDo9XdK0NbgBCIRJ9lnI1UtuwaXK0BCJ4eibuoagC2DzFI4016f5pt4nTGJNEHS6Y1H4NAUIUwDsHPG9Zwd236RbE2H7bV3+lj6rbWyDcnKMBHY6CeLm6NkdU9Q081ZfQtSlDpCTs3NqjzYLMzvqz2fs5uAKVYBuKp9bUQ15Oq+ijc975IybsiTV2cEqlrRuwXsjcbSUpM623K+Xq7OgsTesxdDtTwGaX6RQFx9epiguhgDOnXfzs4GYsVTD6l/bk1sB70emxxKLCUAAIqnCqOcVb6IPWlnwgA3ELNTlqxDAqA9m/K5JaGUtmid7W/NvjxH5Yu5LUsnknSmGkYSsgaTtM8iQuixz9CjZxR4d/St3abStMojrPFJdQBpnhzatCBBhWTnyRRioFfLLlS6jjUTSuJfFLliE4dmXVpgW7QGyrplDS4R2IbzvJoUmkRA6dmC8oOJJMHdceqwk5b3DyEW3gGywTxUTn19Tcvix3jYTB4A6gkVj1s13akTT/n/FiEXBa84CKN7pkg4s7tiKMQeuBEJcCqrkPep90Qp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only defconfig that selects this is CONFIG_KEXEC_HANDOVER.
Replace CONFIG_MEMBLOCK_KHO_SCRATCH with CONFIG_KEXEC_HANDOVER
to simplify code.
No functional change intended.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 include/linux/memblock.h | 2 +-
 kernel/Kconfig.kexec     | 1 -
 mm/Kconfig               | 4 ----
 mm/memblock.c            | 4 ++--
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 221118b5a16e1..8bd9bcaccceb8 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -611,7 +611,7 @@ static inline void early_memtest(phys_addr_t start, phys_addr_t end) { }
 static inline void memtest_report_meminfo(struct seq_file *m) { }
 #endif
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
 void memmap_init_kho_scratch_pages(void);
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 54e5810726176..06a7c43652cfd 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -98,7 +98,6 @@ config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
 	depends on !DEFERRED_STRUCT_PAGE_INIT
-	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select DEBUG_FS
 	select LIBFDT
diff --git a/mm/Kconfig b/mm/Kconfig
index bd0ea5454af82..6d6002f57c18f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -442,10 +442,6 @@ config HAVE_GUP_FAST
 	depends on MMU
 	bool
 
-# Enable memblock support for scratch memory which is needed for kexec handover
-config MEMBLOCK_KHO_SCRATCH
-	bool
-
 # Don't discard allocated memory used to track "memory" and "reserved" memblocks
 # after early boot, so it can still be used to test for validity of memory.
 # Also, memblocks are updated with memory hot(un)plug.
diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b3..8b13d5c28922a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -112,7 +112,7 @@ unsigned long min_low_pfn;
 unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 /* When set to true, only allocate from MEMBLOCK_KHO_SCRATCH ranges */
 static bool kho_scratch_only;
 #else
@@ -948,7 +948,7 @@ int __init_memblock memblock_physmem_add(phys_addr_t base, phys_addr_t size)
 }
 #endif
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 __init void memblock_set_kho_scratch_only(void)
 {
 	kho_scratch_only = true;
-- 
2.47.3


