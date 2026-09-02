Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CBEC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB9B6B0096; Wed,  2 Sep 2026 03:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0936A6B0098; Wed,  2 Sep 2026 03:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5BC6B0099; Wed,  2 Sep 2026 03:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C66F46B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:32:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 353F8C0780
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:15 +0000 (UTC)
X-FDA: 85168003830.28.05150D9
Received: from mail-pz2-f11.google.com (mail-pz2-f11.google.com [74.125.228.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6820340006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bnp1kfo2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.11 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1lPJGPvZxlgDVbSkkI+j7mcGDHCDt5YKPntydBISgc=;
	b=5rXxnfX2gXPslp4b87TK5ZcIZ+BnMVo80MzaJHLHwHrToxdH5+rql9vjJU/MUCzcWkKegF
	FF6ZAkthF927K7zZHjsx093S6h9/RsIHAKT8VKiWmkOnFDXVQWsN6EZDUdyE9UIeHL3e+S
	ubAL1oaFRV22HcrWGizdzjlLuXe3yWg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bnp1kfo2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.11 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334333;
	b=PDTu7uMY1V7uFhmW41AMLflUZTsqgLwf2Y5mCATfS/rl6BguUTcaGPevBSEOFBR9hG/WFx
	66uEJTcxm0L64k6U5QnMVNX1MYgrm3NOE24GifOa7aFb/hn0zbsSnrKbIZQ0qOwo5+G3oz
	Svnn++ZQajZWxkaXASHc1BxED1eA0nI=
Received: by mail-pz2-f11.google.com with SMTP id 41be03b00d2f7-cc1c2963c92so224516a12.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334332; x=1788939132; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+1lPJGPvZxlgDVbSkkI+j7mcGDHCDt5YKPntydBISgc=;
        b=Bnp1kfo2cQUDfP2z/w0C1RMxjEIvnK3T9f536OABVgySGbGs8VHO6LM8ozstvGJO7M
         q4wPqBpyyeOJ2tcoM2VFd5T8EtPJkgKl0V0+TQHOqL3S6qeLbAKcn6iH/6IFbdYLmN4/
         LnfevO3bVh0V6jy2BZNdBBhoQTGhL7cbPxryHHTscEsuerrNprpuiebO/sUdOzcY73zF
         PARd82xh45Nr0Hqtu9ZoScYURNHE0EaQzJXdvGpgy4VBB9rKcUwSIm+4sa7rKh/4eWtW
         rcQyDCrxNC3ymXWv8lnv5prc3ipWXYy6dtHP7s22aeXRn+TPYXJ8zfMnOMVyxyv9PeUE
         oHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334332; x=1788939132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+1lPJGPvZxlgDVbSkkI+j7mcGDHCDt5YKPntydBISgc=;
        b=jiMA+diKezwDSiiUJuHTJd/14cRVAq99nQYmovyxwC2R0ioUvriim6ezQrEnLfxS8h
         EuEJdeVHOSIwRvAKL9aHHIcOG9iKT6fpG/Ij4NipTOXRzRkp9lT/CnLbF3uorUPYGkyk
         G756itbz0kgZVbf0hJ4pe+WuUMnGFHq6SK9XNQEHIU4PK1Fx3VlSpXUfhxIyFTyHKJgm
         Vqvl8moZUQFlNReoRSYngwWIbXtArDO/Zl7Tv0lmV05anHFubLYudHLvS+A7SbXRHOxD
         GuzLQcYecGo3n8SYxGeUTKCbbOT66xvhguHsCSWFlrkuhqjW2afhofI1U6QlRQsyIDPz
         TboQ==
X-Forwarded-Encrypted: i=1; AKwUvBwwR5uK4EzCi1BP1+ARRG0ec9lYI+FM21kVgzwwLp/CXe7L0SZJsL2rsY7KsXQwmy/jmkBV8NyivA==@kvack.org
X-Gm-Message-State: AFuF++maByhJUsfFaxrBlcwW/B6yt65cDBhprVHqlctpYOmO8LoRjvEQ
	9pClClne5wUqf5Ghk1ACvXH91LTU7gP170jRM7EidwI0JXH/8PNKESYG
X-Gm-Gg: AYBFou18sX81iTdVJSzUz3dZDBMNSJT/P5PYRyZhQY9DxrsyVLj6HgiNN/M2Ysnrppq
	r4x7wV4Y0uCf5V3GpyN659br4sFOkDlzUcml6cTZ0DxOvOg3nX/Wv4ja4INHfyy/0GFaXv0pWpK
	o0ErOocctdOvj74xC7mep+66wqIvpaoO8sqASIwldA3qD7OnykgBiNLa9+ThRsw67CmRdd4CZRI
	2n6VQFQSnaL9urp2LVOOJonsxQTcYylgIq+1sowgtVn8PiPrajuGFMsGvciR3kjWByxxVbuCxEO
	FsrBbYT+dJurwtSY6ESFZz/ugsjMyERE22IhUyPDLQCws/D3o4gPCnJiRz8rJdGEZ+mfRUxiKMl
	dSCyu04ffQ8v/kAMPltxQDUwH8351P4ssgRaG4oDJ+3Z7YWO1axTYyCjKcmBjJpPS8yXpUV4j9i
	zjDx3NH0/i2glQXKw+qJPiJxwOy6NM86colBy0I5SC4IkK0EQ/PMviS/5AOTeKmJUfSNjNM2n5b
	WlBcAFwXBg=
X-Received: by 2002:a05:6a00:1c9e:b0:857:73e2:9104 with SMTP id d2e1a72fcca58-85ed94bb41amr4709226b3a.20.1788334332169;
        Wed, 02 Sep 2026 00:32:12 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:32:11 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v6 03/10] crash_core: fold duplicated memblock arch hooks into the weak default
Date: Wed,  2 Sep 2026 15:31:09 +0800
Message-ID: <20260902073116.802752-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: u3e9qx9a83kk1wpatrojqptqugrbna34
X-Rspamd-Queue-Id: 6820340006
X-HE-Tag: 1788334333-745648
X-HE-Meta: U2FsdGVkX190OYnPWJzfDIq4O4SgHqBpvgP7fzjv7kDmhyAX065biL2K+Np+0FHwYwQid3fbpPzJDe8eWSeqTUyfMr/SAHi8RHnst7IZzoS9YPCC/6fLYAS8Yq0v1q+zQOl0bzShqOwKYMf+JcMb7p9eHPSBD9VCjShlgvdLY+GwC3aBuGTXJ0PEZXGf/ZVEeAQpONBgkdjju/ql3V2Kkm/VfxfCNY6eV6LGWzCsA8iKxb8P7mcz6acpXbHzQI5o/QEw60uSB0v6Fw08kd6CVblgSWPQGfNcEUar3mfEJ+CZaJ/HYcTp2D3efbg994J1Xn6tZ1XSPjRBdzmMPiB7V8xWXPSlV78CsY2uLka1Ilg2qWfB7I2qo/cMNF0/++Ql3wfOuZloI/cMSLut2NIRGPYYyxt24BW2JDrMHA74lTjzUjwdfyVAhkt5S8xkD+GcfAyrl7uh372AkHvO2i3MzD/y7/ki7mCJVUY2nnP02dPSQenD9Sxug125bPVQkjT+ob5GBuKRdZ1gztDd0BMskVUcSQMe4l00Q6RKnOrCa/BmG6gY+CP/35MA6jRiIVgyGMSgQTXUosq0YtPYC3kBW0TJ3fhigorzo+/SyTmFLRvElLuv9oC+wK1X/LYUm1W7qAQ087Sv08g3JH10j/ubrAz75NsImim6T5n2SXNRS7rLQO4UBUEQdBRzTp1tEacEfOG223BpEqxHRudW/iwmTCtWjm+JpKAoImmA3M+BQ53vpvD4CfvbHg3mApsxsTtQkbyHld9r1iSnJPu7hRFU8OXYOzoo9VnahVJ1QEGUkfhu9Qn5nv6vqD56eZ6xQr0koqyh/QyIgDueVggU8gxGT2O70KiUvIlOYaZAnXlV1N9EZEDGIPqkcSWXvRo0KVyBg9SzrPOrcyR2YYo/DryePfkzU+QHhguTx/+ZWegpGCu+ylpyOryIETqx1DDwPFPQPJlemw/ym0is0Ltmpqp
 XWND/1xa
 yWd4D68b9LuJd8L5GKxexhtGobxigSI3Vt2ExJTEl3KEhsYseZWjiElHMEODkq3LUf445DkRoIvThYId0Fz5fJbuMHdFsKy6xWBEyW7bOEa4eKtZxQZELy3YxvI8HAfxLVtlzzWfhp7v85xptO7YhIP3x/RUo9FqwiSdRj9qkqXJKArOc7YDd2A1+SHcxBqh9yCdrq/iC3HQ9MWcexPqNI2lFlfgAFXHcIXdLca5J6mZCWz8u4HqtzaNVZFEGwzlcu8Oc13KWtAIp271vRPfv2UNbCMzct/KM9vBrZsfqShwQL5+9saQ0Wr8SOBooxQR/2gFPMfMkJnQ1WLE7MWRvDgXTEx5dV+A2bf4l9F22J0wy0Op08azHbbZT5ZCEeN/E0TbUN+ZMIjYC81YfoUYkz1w+q8aCV7JDZaLHkXeLsnPnkadHVRQTv8cbRKc+WCEp45g4YEIGVbpRoYRzF7ZdWHb4Q51y25e///3XhBxSP/1uOIIs+oVH4Usg5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

arm64, loongarch and riscv open-code the same memblock walk in
arch_get_system_nr_ranges() and arch_crash_populate_cmem(). Move it into
the __weak defaults in kernel/crash_core.c and delete the arch copies.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 arch/arm64/kernel/machine_kexec_file.c     | 29 ----------------------
 arch/loongarch/kernel/machine_kexec_file.c | 27 --------------------
 arch/riscv/kernel/machine_kexec_file.c     | 26 -------------------
 kernel/crash_core.c                        | 25 +++++++++++++++++--
 4 files changed, 23 insertions(+), 84 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 854d872dfd0f..34d944d3f22f 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/kexec.h>
 #include <linux/libfdt.h>
-#include <linux/memblock.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/slab.h>
@@ -39,34 +38,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return kexec_image_post_load_cleanup_default(image);
 }
 
-#ifdef CONFIG_CRASH_DUMP
-unsigned int arch_get_system_nr_ranges(void)
-{
-	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* for exclusion of crashkernel region */
-	phys_addr_t start, end;
-	u64 i;
-
-	for_each_mem_range(i, &start, &end)
-		nr_ranges++;
-
-	return nr_ranges;
-}
-
-int arch_crash_populate_cmem(struct crash_mem *cmem)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
-		cmem->nr_ranges++;
-	}
-
-	return 0;
-}
-#endif
-
 /*
  * Tries to add the initrd and DTB to the image. If it is not possible to find
  * valid locations, this function will undo changes to the image and return non
diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index 5412aa9f3568..481b8f906a56 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -13,7 +13,6 @@
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
-#include <linux/memblock.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -56,32 +55,6 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
 }
 
 #ifdef CONFIG_CRASH_DUMP
-unsigned int arch_get_system_nr_ranges(void)
-{
-	int nr_ranges = 2; /* for exclusion of crashkernel region */
-	phys_addr_t start, end;
-	uint64_t i;
-
-	for_each_mem_range(i, &start, &end)
-		nr_ranges++;
-
-	return nr_ranges;
-}
-
-int arch_crash_populate_cmem(struct crash_mem *cmem)
-{
-	phys_addr_t start, end;
-	uint64_t i;
-
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
-		cmem->nr_ranges++;
-	}
-
-	return 0;
-}
-
 /*
  * Add the "mem=size@start" command line parameter to command line, indicating the
  * memory region the new kernel can use to boot into.
diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
index 808e872f4063..fdc6695e8588 100644
--- a/arch/riscv/kernel/machine_kexec_file.c
+++ b/arch/riscv/kernel/machine_kexec_file.c
@@ -37,32 +37,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 }
 
 #ifdef CONFIG_CRASH_DUMP
-unsigned int arch_get_system_nr_ranges(void)
-{
-	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
-	u64 i;
-	phys_addr_t start, end;
-
-	for_each_mem_range(i, &start, &end)
-		nr_ranges++;
-
-	return nr_ranges;
-}
-
-int arch_crash_populate_cmem(struct crash_mem *cmem)
-{
-	u64 i;
-	phys_addr_t start, end;
-
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
-		cmem->nr_ranges++;
-	}
-
-	return 0;
-}
-
 static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
 				 unsigned long cmdline_len)
 {
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 2b36aa9fade0..77285ae3ce60 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -281,8 +281,29 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 	return cmem;
 }
 
-unsigned int __weak arch_get_system_nr_ranges(void) { return 0; }
-int __weak arch_crash_populate_cmem(struct crash_mem *cmem) { return -1; }
+unsigned int __weak arch_get_system_nr_ranges(void)
+{
+	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
+	phys_addr_t start, end;
+	u64 i;
+
+	for_each_mem_range(i, &start, &end)
+		nr_ranges++;
+	return nr_ranges;
+}
+
+int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
+{
+	phys_addr_t start, end;
+	u64 i;
+
+	for_each_mem_range(i, &start, &end) {
+		cmem->ranges[cmem->nr_ranges].start = start;
+		cmem->ranges[cmem->nr_ranges].end = end - 1;
+		cmem->nr_ranges++;
+	}
+	return 0;
+}
 int __weak arch_crash_exclude_ranges(struct crash_mem *cmem) { return 0; }
 
 int __weak arch_crash_exclude_mem_range(struct crash_mem **mem,
-- 
2.43.0


