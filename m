Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAF9C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDCEB6B00A7; Tue, 22 Sep 2026 04:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66C96B00AC; Tue, 22 Sep 2026 04:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5CE6B00A9; Tue, 22 Sep 2026 04:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 468076B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C0D01C26E4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:26 +0000 (UTC)
X-FDA: 85240759212.11.0276EFB
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7B84C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XFbYo49A;
	spf=pass (imf22.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1ZOEGC6NTnorBW1vtDJTTSNUXHaycEwYALUJLCTDV4=;
	b=1ug2iYzHjwFRNDugD3U/m5AgSXtAg0QWaBb5MGzk2lbHbo17rkC2ZDGXRIcQsvfyNR5jzg
	RyxX7TwypWTz8RR8K1wdS6rKIuexGT6hMF2TBaCubfx5A1VStYgBWdBOiMX3gTZ84L7c6x
	k0VDPKABoi2nXe65c4lp4wS6eGFzNec=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066604;
	b=7WXkaciG0JtE0Zzc66F1z+s6HoJPC9ZHi62zMCb/jhxkFhbjnWaNFA608/UXBn77wP6U/+
	aSSvexZn2mP/XPbKy+P3znEtjCpzEidrRVLm7TWAt02F1o05SIhKgpa+ATkFsFazH9YhUz
	gmQczfqm/XOVeVswszm0BKX8ixNW4GQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XFbYo49A;
	spf=pass (imf22.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-398e10200a6so2418312a91.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066604; x=1790671404; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M1ZOEGC6NTnorBW1vtDJTTSNUXHaycEwYALUJLCTDV4=;
        b=XFbYo49AHYkInA/qtZuTxDKGAgEqk+ZpdKYnvIP6p9R1sFPuhIgQhjMYtfN4623ZDh
         0eKuBy1ogiDSsydmH/2CoN1NV81K/PVmw30OlP8U0pnVFwkVqniMDahEnzBVX0+J5zgX
         sOuVGvhERIJ5/m59+CBG8i/ZqXIY74Yiu5fiEJOInf1kSM2tCqIi3f2sQTyd1ziPTORn
         y6bhBCyl9cc8ynPZIKop24Xx9wiZ8Dz6fLr8luIpeBq+CIDmICfj9JN13+A8ljwRlqnR
         ri7LXcYqi7KjtINfQOaOCSn2dQoKZ8QHFyTd+PyfZtjNA2iVRdUjtKEGF0zeiASqdK2m
         UEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066604; x=1790671404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M1ZOEGC6NTnorBW1vtDJTTSNUXHaycEwYALUJLCTDV4=;
        b=qW1i2NGvT9U82ekzwse3KoPYULJCk5mFgXONO1yBSJAYKugr1NGIA/uYD6W5A9+8XW
         DlZPKsPX7gkrTh2uLa5xH5CeVLMhiLuGMsbuoBHkwZmH5zqQXS+ivGL/hh4tGHR3737/
         VXJzybDKfQBfufdC99v3TOayhy3ZRV61OPS4UQ26juhsIulQ77OcnxLEqlF6S9SJ42rq
         Oua8Be1D3m2q4rdHrOohRDAFUCcaPA1X8pv2k+/nncDYj9dedcXeVwG8d98qC52pc6ah
         k4YgaWQ+btAuM1Z3rcweMRMN4rJYOICvAgfIhnXHYDmpLolitQiydE3RWtXDrFt79W3m
         y9Eg==
X-Forwarded-Encrypted: i=1; AKwUvByhc9aMa8IMqP72FdNmNoxee2WdKLgTERgjoWr2+sX6v/K7aCj2fHj6BeUa6hPS/662cRYoNU3ewg==@kvack.org
X-Gm-Message-State: AFuF++mEIeMa/BBBJHY9JNbol//Zto/gGa6X7iQkfDtl+pNdSvCkntc8
	SCoGuo/g4svfU9GTFzi/Kkjs4gBhebio6eKgdSKpLF/C+ewd+ncpDkv+
X-Gm-Gg: AYBFou3wPmCHf6YGig/bgtxuWHxKbxbdTaKkFtKChaKX0m7j6OaC5fZcalHKETsefAL
	D4TQVIstb/T1F/zhOGOZmVHOc8TC8dTsQyeURq+bF+u5vDFvyzTtmnpeuCG6Hxx9RKqj3955+S4
	ZvL/jkMWFCZVYOoSduyd8CIqHkMghM0NyHB0ZSAPimPA91im6/NMzRldl+GPqPQB9OkxvRR2syL
	+b6p1NNuvW8+cEtJk4d9a6UrgMKgshiab/AHOtLiPK+uqVoMXANU23YQY7GNrhSvScnf7IqgXM9
	Jh47RV8ibuvyI2OftWkuKpsaNIGepLy1Eh7rYDErXp4T5ka9Wz5r6Ok3q6sH9CMUgKXDGg1RoKV
	XCfIN9sRGLWPsbTjzoVn9I26pK21wk0MBBfktv4SClRL4z1YcuPby4hzan4c0PJTMgpe42Xt958
	yZp/xUzGMC0EJLtmDi0zpNYus6r1F8HOi5FChboYFEzfr9IYOXXuYB703VUZoWi0Kd896PfRaHt
	hZ/R1yHLQM=
X-Received: by 2002:a17:90b:1d8c:b0:39d:f4fd:8075 with SMTP id 98e67ed59e1d1-3a073182cebmr482494a91.19.1790066603666;
        Tue, 22 Sep 2026 01:43:23 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:43:23 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
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
Subject: [PATCH v7 1/9] riscv: build crash_mem ranges from memblock instead of resource tree
Date: Tue, 22 Sep 2026 16:42:48 +0800
Message-ID: <20260922084256.1515554-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nsjta3mg6wgemf1nkipimnxa3tqmfpgo
X-Rspam-User: 
X-Rspamd-Queue-Id: C7B84C0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1790066604-486488
X-HE-Meta: U2FsdGVkX1/EkUH7LX+8Ehl9iqsLWq2XvCtv7JlexVbKccIs/ikWjOP/3hUjn/GT6Ckh8b2RD29uz/IlFqcSR4dzhFMXQS1jKsckXVbdW+wphKaH/Z5aiSvxvEEit8P+7yyVKjkA7ItjxWJz6GwE5s+dsaoBPFjnudfRpepGEFRBcdl9fLrWCu0av3lRy+3xAEM3QWvof4qAF0E32pg4sH1SlpcDFOH6tFc3gMcRbqiiv9rksEyhiY/55wxRQL3rdOqie3T5F6k9AnBig9nxo+CpDVixc6/IF1Q/XKxzXte2eLkfEdgg5el05ems3zl6HreUo4DENllcOUEl2NWIjA+c2D77GbqVFyGIGmrYo9qL4ldOB8Xv/Q/fpIIVMKLt3d8uE0rnqCWSxWhR0XmmkuemJO3uH4OpMcFzjSq99BujTfGTALTmmnsvGB97cx++HxrUa2JbjgDCCImWBVABT8tvsmCLCW7YSjMf6cJLgCzAQWpBnU37W+nNXXmDuqw1ALWm+A+YUrM4yxVnsOGaRdXELfIFmBEducxhOS0UfUTB4T9QEJWP5YDAYF0PXDqGpImo8YOHvvjoDt3UtdJ8q9ZEYcI39kOg5CgF28re1v/vgyVb92ncw3CUqhMbksoGzC8LzKp9Pu2Vyu9wExt07PCUwWfxmiNFOU9XfByzB7dy+F3zjvjYBljkRfwy4zj1Ro74cdA3Hc+oJw4QjViVkO+MWklGVCuO+QqyePM41ckcoPTRVlrOYF89J+5j0MfNa22reoMSdILOwvww8T0A2agStZAlk51YR6w4cQ3dz71/1vLFlw4ku9GiIuL7oiTfI95hqTXvyQ2iP3KcMovv1QJb41fPxeo7sb1OXCKohROJM5hT+X0GGHJVRrHIztlvZiadaot3qhcntxw6+3uO4LPHnkVK2+icTWvyUSvtnhz6DMod6l9CUsoVst2x+eWcBpqyTD9ByZodK7sPdzb
 n2L0X1Lv
 1CNSlscI9CTgXg/V4r+sH5SDdDjDlHRrgVGfK6+pmViOgYVJ9kqDGYAKCPd0RpR0IJ/8n+5HZgz85GaEeVDquLm0qEji1LP19/7GZvZn048yVWVRQV0QIZA+uBC3AmJmUNs3nV689gMRcNmgsi+D9+d9uboOwRWRFwita6GgvClWCFGZ0mIR979iW+0IadXPnqq68MkPLW3EB9++9Me/3aCtG0Eoq+lVi0oLE1wpwz9VACgD88ST0Kj7y0yE/KrPprXjQYtG4IH5xJgYFAQc01tzdgoGzu2c+bgl6ym5XkE6NQV58m/VPiCGAb6yMVKgJ3FMuE/ouZJcgTJhl7dqVdy0ry0UNFJP6NVtMRMj5yH7EBQT0R3N9NBoNtEbdn+AtCGN3hL6SFOi0TIlcu7J4K8lGHK5satWjQ74LX8epAKg9KcGzgbbGmPVenJ4tKihKRhFzVpxqLc4aIrungSz7BG4BFtfn4RCRdKOQYnHusitW9xr3gH2ahH64/EcXaSsFCGDM3SErO+P+xK2skLyLjrtKbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Replace walk_system_ram_res() with for_each_mem_range(). A later patch
introduces MEMBLOCK_NODUMP in memblock, the reserved-memory regions
marked with MEMBLOCK_NODUMP can be excluded from the vmcore by walking
memblock.

for_each_mem_range() iterates memblock.memory, which is freed after
init unless ARCH_KEEP_MEMBLOCK is selected. riscv needs ARCH_KEEP_MEMBLOCK
to filter reserved memory from the vmcore, so extend its condition
(ACPI || KEXEC) with CRASH_DUMP. arm64 and loongarch already select
ARCH_KEEP_MEMBLOCK unconditionally.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 arch/riscv/Kconfig                     |  2 +-
 arch/riscv/kernel/machine_kexec_file.c | 31 ++++++++++----------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index a590db7687c8..991657b2465f 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -58,7 +58,7 @@ config RISCV
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_VDSO_ARCH_DATA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC
+	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC || CRASH_DUMP
 	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE	if 64BIT && MMU
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
index 26cd2a8bd0cd..808e872f4063 100644
--- a/arch/riscv/kernel/machine_kexec_file.c
+++ b/arch/riscv/kernel/machine_kexec_file.c
@@ -37,39 +37,32 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 }
 
 #ifdef CONFIG_CRASH_DUMP
-static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
-{
-	unsigned int *nr_ranges = arg;
-
-	(*nr_ranges)++;
-	return 0;
-}
-
 unsigned int arch_get_system_nr_ranges(void)
 {
 	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
+	u64 i;
+	phys_addr_t start, end;
 
-	walk_system_ram_res(0, -1, &nr_ranges, get_nr_ram_ranges_callback);
+	for_each_mem_range(i, &start, &end)
+		nr_ranges++;
 
 	return nr_ranges;
 }
 
-static int prepare_elf64_ram_headers_callback(struct resource *res, void *arg)
+int arch_crash_populate_cmem(struct crash_mem *cmem)
 {
-	struct crash_mem *cmem = arg;
+	u64 i;
+	phys_addr_t start, end;
 
-	cmem->ranges[cmem->nr_ranges].start = res->start;
-	cmem->ranges[cmem->nr_ranges].end = res->end;
-	cmem->nr_ranges++;
+	for_each_mem_range(i, &start, &end) {
+		cmem->ranges[cmem->nr_ranges].start = start;
+		cmem->ranges[cmem->nr_ranges].end = end - 1;
+		cmem->nr_ranges++;
+	}
 
 	return 0;
 }
 
-int arch_crash_populate_cmem(struct crash_mem *cmem)
-{
-	return walk_system_ram_res(0, -1, cmem, prepare_elf64_ram_headers_callback);
-}
-
 static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
 				 unsigned long cmdline_len)
 {
-- 
2.43.0


