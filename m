Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD037C5AC79
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55486B00B1; Thu,  6 Aug 2026 05:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05E36B00B3; Thu,  6 Aug 2026 05:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1CC66B00B4; Thu,  6 Aug 2026 05:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88AAA6B00B1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:36:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15723A2432
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:50 +0000 (UTC)
X-FDA: 85070340180.15.3C0237F
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id D8F03140005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WqqO/4LU";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786009007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVDvUsuVz4fOLoguLRCQrGgJgNWPqJ2TDc/OI8CtAH0=;
	b=jIw4GHCNPczvABy/8cBwfoAOITdV0oJBpEE+JAGJIfrt+ahDv85h4TdFsoiF+GrIC5woOp
	norT6okmfuERtk27JH+VVhXMhkAQ5NXsK1whdXyLQoIhEhEXPPDxkGcZ3ffTWOvQJHAYJc
	h83QMEjIECnOPdJyeusQckiCn2U/Dg4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WqqO/4LU";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786009007;
	b=50UQQlcHRVJ/yiSzHtQ3XUKGP6Bm9WwcmaPsNoszw6IQqKmA4QUBMdxRVTtNl6GENxXN9g
	4HCj40NBHD94mSsv0emalDtpafP4OZSOib91pDMV+ujuT33l5wl3oJkKMq9zoXEYqkKlWq
	qH+zfbBrNHeEv8Gmveg/uu74UpmAAUM=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca7a25cd87dso1606682a12.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786009007; x=1786613807; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wVDvUsuVz4fOLoguLRCQrGgJgNWPqJ2TDc/OI8CtAH0=;
        b=WqqO/4LURAOOi8FU+eUATtC/IEv/c/gR7fDIopEn0CNREID85cT7HJTlUPM9MtIgr3
         VstIEuPGTYnAjtLHCnxfSsto4vM8lhDd4sF3RCfyJb8xWtClmrurdRlP6yzFMA3nCKEI
         14rpv+kKs3rO7/T+ZGkgKR2JjX3xUWaXwmr72PsHWkMUF6WPEMM0pds/d1C6oZbeg7y1
         BX6E7f4cTnqJfuN9IrHEWEY30zevn1jLmhXnOmNFy0rgj7unVpWd480xobaPR2RJYmy0
         CdwPiu/QDbBW1wRVCPbLtuPvxpfVJokmsGUcmmbIjSSsAIOdxWGkr4dZTwNw1zkAwqu1
         diZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786009007; x=1786613807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wVDvUsuVz4fOLoguLRCQrGgJgNWPqJ2TDc/OI8CtAH0=;
        b=SCZ+fLcIjO4O0yBo9DjflcbXmlo5kjUiPfexx09RWLOVHGxtKQiJhPdK+UyrVm/JSn
         I4PP+WNbkyV64OX59G9ueP8zdLPW/0Gt5DNGwtzfK665KDmXr9Kiq1E/FsSFeeeJoX3z
         P3t2SBCrGkf3LQyFc7FlyVSF9cEcGW5YxDjcAJlAHQZy6Xj7OhLOwwaKYB9eyXAYvp96
         kkWVxgL3mxmnjHE2Zyhd7FlXqYa3QskQGW4Vki5039jQqlm1CK3Qta7VT2up9qDUOoA4
         PacVTHJq7hOy7UuCI0Mru2qZ+ouovJ3fpyPGAN/sZAzQG/tynF3+Aw5xOwxJs8J2j8mF
         5RCA==
X-Forwarded-Encrypted: i=1; AHgh+RrqiJu1oIp8FLWGAIn6rGJ8FJ71X6iZLciSGUyR1Wnycxtn7oUIlB3WtrEeb0CsRTbxxLAdzAbpLg==@kvack.org
X-Gm-Message-State: AOJu0YzfYj5oRRgSDqvKLxPDbJc5I1DaRxjS4KA/EFCx7UjewoqPzKW9
	6onOv0V7RuFyWpy2pATf04ZgxO1qh4AezH/xd8u6mFGF0MjuFKvGgyoA
X-Gm-Gg: AR+sD11UUzpiG1dBXUyYrUS2LgLY8x1phcusKUt3BbMG2fmNWNv2JjiTNunk+hVpKcT
	L/AuuGCXNuwiAZhZ/gnA5W1uzE4Vsh8OGeTWsAPjmUzlkXZc5fFqylcO3eEN4gMhKJKFjzQsL/w
	qoGzPGi0uA6EIjBFdrdTx2HQk9GjPTQFUpoiz46LXrcaMs+yPLmx8QmkS/Dpdw253t3o+WDI6PH
	v32lWfW/oLCEYsbtHO+s8b8wSBlq/dnqfUoyoCywRfdUmW+F/5rBP67g5zp1EQuzr9D856wnRHh
	k9644Mic2kjln8zOCOSsPyXYXYPo0XmrKV/dSE4t7cjTb+4F/POMq4TUzd5lmalD+4xTth3W1s6
	NjW1ETqv1VR3mPb2hNaxrVfsPjeyFWTx2/311ywjonfhctkSw9E5rW7aDk6Zec4w3cSY4bn2djL
	WS3cDaIrBYrHBnb8XuNiT9IavDycrKnXXMosFZLsjROjdJJJEyG3u8u6ShO2DPrhDSFPKyVM37x
	WIrXocdGTGH
X-Received: by 2002:a05:6a00:3687:b0:848:467d:293b with SMTP id d2e1a72fcca58-84f2dfb4e5bmr16809060b3a.11.1786009006714;
        Thu, 06 Aug 2026 02:36:46 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:36:46 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	iommu@lists.linux.dev
Cc: kernel@xen0n.name,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com
Subject: [PATCH v5 6/8] crash_core: fold duplicated memblock arch hooks into the weak default
Date: Thu,  6 Aug 2026 17:35:17 +0800
Message-ID: <20260806093519.2907771-7-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
References: <20260806093519.2907771-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8F03140005
X-Stat-Signature: johaw51qg5eibyk5133m7ry3rgcbh9mi
X-Rspam-User: 
X-HE-Tag: 1786009007-406233
X-HE-Meta: U2FsdGVkX19lSxCRUSRDwgmFUGPXhCX2uUG4F/mkrpVz4OrZUzFdbge3JK9rGJaUONEIp0JaLMctWuFxBviF8Iq8ebKK5fRVeXLl6+kZfMEFNaiByL3xdUHMvri4TVmluirSErlB7iTnPeUZjedaD3SBJV8ty3rDvFlZinBDAFBvNTcmBNCcRS2gGBZBqzoYAzh6tvqDIMcrZ4KjyC92dPowHEZi91uDDBP0mMVxSwMIi0cvGZsWgKjc1HIySb4522FUyrS7JPnqfNAVsaBqkI2kw10hO9HLjpk46h/509wunwcUXwzQ5PHN5OHvU4zegoJI2NU8ZanbUV4BekIP1T5eCwIvOUABmX3HRGq/c9xOrNquyasfeD4lVKhp3rB+9ujjOHQiCigaOEWBh8kYD09fTjcW4CP5d6+3z07hVGp5jXb9nE1Kqd4Rpy6DadHaNQDlJ1hS+oW0mQAb2W7HM3HpYD/1nKwRF2/WoWsDpPvhp1+x5C8x3NOsltZ/jKjzZ3mxra/eNSX74dlzlBpwwTiDI4atsbZjFzOD/adK1g6WenuzgQ+VWBrnogN5G5xyK78uJxs7wHPUt10hxyU45JxPcQngiKsIvp79mafQgk3xeNCrIyGe73x3LofC7oY8TC8++INr14niHP7r14jFEzAPM1ku/CR7WpvgtzyfYYRCbA4WUvTGZbo02y4lbcw1iS1GH8kxqi8f3mIgAO6GlFpF29yyDUV5mJ1HkNbRXEGoVrCdDqmhR32f2B/h5yFd/6ehknK6tRWHjtrqo6yM95oN+y9JbPa8VxCYtLIQRkCnYODqJimE0FWGHybdVUYk0mDXc0JEtOeI7ZlXF1GHe6kFRn6l+zAxpIflPvcl/ki4c8bU6SxcGgnVF0InWfL8rONX24nH4DxKU9NA7EfrFvCR+us2k/HH7RZ6EAQr88HO+smU6AqzOXivV+r5gMee0+p25CqDvnXAJjyK2Is
 a+QpbNr6
 lewGf2OOvH0br5RVVefKCnsmVNkX6nQvfVyyYoUZEbQ/dTb1JqVbAwzcD8JEInfUUF/x8Ucxn6Q+yGoQA113E8lu0FX9cMmyTpMTN/zWIRljNWsGm0EO7VHO4ceu/PtF2q5/LnSE6fQi6AVFdEssvXWUK2Y/aKa7bEW24NIPmk8E54XcJP2QeCp8C/dYHrzv1+qxKAX+xp/Xp37znCfIjojlHRI5GrJPCW965OBw67EZFcZyX02n+WnkKmtB2jDlEmNbshGuk9fd9t3sH5XDuMu3XszQ8Jrv8Ki76+bwG+2y8JbcFP9c18uzma2oamX260kbSbVZFtlCIxv7dqyYJz+o6sSr5xWyZCLJbjifVn6A1PtRs3LtZSW8MMee5nIVFJ40JzGLqnI2i+V3QQ1MgS77cZGziKMY/cf+0IcmDLfDD7VHngxcCgjW9dDFbeacvbbyyUXvqIpiOGxmuGHlU2Aq3G9xlnsmX/EOmRIa5WF1baBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

The weak defaults are only consumed by crash_prepare_headers(), which is
called only by arm64, riscv, loongarch (via the weak default) and x86
(via its own non-weak override).

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


