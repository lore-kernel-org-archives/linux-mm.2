Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E7BCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1138D6B008C; Fri, 16 Oct 2026 02:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB066B0092; Fri, 16 Oct 2026 02:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C766B0095; Fri, 16 Oct 2026 02:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C460C6B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:16:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A41B1602CE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:21 +0000 (UTC)
X-FDA: 85327479762.20.6049F90
Received: from mail-pz2-f9.google.com (mail-pz2-f9.google.com [74.125.228.9])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7C2FF1A0002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VH4tMw3j;
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131379;
	b=NexQ7W8OyXQKZyA2XAx9Fy1xfi6hJeGzp0taKq2zqcS7fkaMV6SYFKfQvDLaAR+I74tOcF
	2nhU5/HtB7B+PdDQYASPtVLmtcW7Zc67Sh7yUPPGmEkDMfOTow7U5I/Qdg/R/RFrxUm4sP
	41E91V8BLNSKfH1SA0/OA59YzEctP10=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VH4tMw3j;
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pI8cU+3Va0VJY6BQ+e7sBVT9LPRu4J+OFo4gOdjLJ30=;
	b=TM8EFpYxp3u7IW2td3zUhUzpZMDjtlRSIufl3Uts7NdQKOD/RbZ0O4Da+gIm0z0O7Nk8jG
	kSIAGBbg/d1AiiXYipHV9JOa3gOEVQXq/9Xi7oBVTQgP18fshLFeBQFoBHRw7mvlT5e+7R
	FbIMDsUMxx6jIe2Qtlgkh5kdwRg9jbo=
Received: by mail-pz2-f9.google.com with SMTP id 41be03b00d2f7-cc1631a57d2so1161648a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131378; x=1792736178; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pI8cU+3Va0VJY6BQ+e7sBVT9LPRu4J+OFo4gOdjLJ30=;
        b=VH4tMw3jGNm9QMXWeSzulY1hC+hkrzruo0cP7euDBmobJUULe6R1fuAP0g4tF5C0b6
         nGzvqZebfJxuczmYC6KNL53LaPLIXv9owMrg+HccP2AJhpqDtCW+OArrreXAC6E/VHu7
         ySCzFv3EyBv5dihMlmi9XKyl6NLOD8PZ92EOtmuRHTtlAGfiAzeVEJq263o6C7G8o8cW
         9GtXu1Tznz+HFEHjroC9OGUrRLcfMjohU+OTY1RJhzSMmiL3mFcDyD5P6mFl5Q3FR2Tm
         hjENCREDfNWjxCsjGODJlsl/ahFsdKSe5ISa+NjVUeMdm21K5S7ppmGmg9mRfAq6ZKoD
         LGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131378; x=1792736178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pI8cU+3Va0VJY6BQ+e7sBVT9LPRu4J+OFo4gOdjLJ30=;
        b=EhaKxIqXu51di3iVDF5vF110llLE2hk0Ue/a3/PXYhHP9FkYuGdZ551WTb708/odcm
         qOhgRWzCCL1+OjXfUvOsEFD80yGRqe1fLhad07CwjyBeSDEXgk3GzXBUOB2nYxiou9a/
         8Uw1ak9rRnC4uty1c7brrDnVdftY7JJTlWEHFoiSU/FtQ6zQLnVu/INGolwwMF4XfBKd
         TFokdkxMFBw+bsaMBRdAlDRIKnGN10e0eyDhpPx81+Q9oyggYBhT4oKy4q38YoTKgW8y
         hmVesiV8GWfltkwvayLLGwPPHB3CXaGgJ9Vww7drrqoudOyjPBg9FM3F77Dz7SaZG6LS
         xGow==
X-Forwarded-Encrypted: i=1; AKwUvBydkrD1k46z5WGYG0G+cFhnC1iFHwwE9H5ydtdc8774I3WlocaCBp/7isrEUODHJ4Q/9T11x6VHPA==@kvack.org
X-Gm-Message-State: AFq9FYLcDYg/OqcK9zqSp5LVgiEvOQctYYEs+qusfa23cTrD66+iSw7R
	9Bs2KD+A1K9KdxJnC9nbRgFwq3w+3/q2Jtb2SV/V//9fhI1NoopRloDf
X-Gm-Gg: AYBFou2yK5Z2RJqrEYPmqgF3ec3YFdPnOOZFTaJ7q8ijCxOD8Il58rAsEkhSIPa5lqX
	vbjVJa/IEl02nEauLnTNtj9V0oFF9HQ6PkORwJTdnhqgxBd8VkpniPa8/0cWHVz/rUR8rcA/k1q
	sXxziCWzuz2HHrjd44Ea1xQudOwjLQ+n/qjXphoGIE8880t2iZNuqqB1IX/TD0TVbrVmyFpQe83
	4kL9WUu8mJC/3ZrDNJ+m7/EC9RsaFmikjdfVmal7k7zkV0WJ3mEUlMkbdhq6jvkNPUzK7j2tt9K
	p9O6x1xIJKN1robQEhaK1KsDOdQ1aj1hTtptlilgbWge3VyoanUN5GwIvuurFdIpKajA3f3/hhx
	Jz3iGuchvDcT8yqALg1jeDjkH1pcWbXbgaTi+0hjC3Wmkv5lgtut1Fn5hsmR63ovfZG62BI3vCg
	oq5+XYViHqn8kQhRO2LUEqjB/L171wyP7dFrTio9ZWXqr+g+RNobagEIb4cUVlB7eMPS2APa/kp
	yhcHu25UKk=
X-Received: by 2002:a05:6a00:2996:b0:878:3538:8f7d with SMTP id d2e1a72fcca58-897c79d707emr18459260b3a.43.1792131378226;
        Thu, 15 Oct 2026 23:16:18 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:16:17 -0700 (PDT)
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
Subject: [RESEND PATCH v8 1/8] riscv: build crash_mem ranges from memblock instead of resource tree
Date: Fri, 16 Oct 2026 14:15:42 +0800
Message-ID: <20261016061549.4181390-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061549.4181390-1-chenwandun1@gmail.com>
References: <20261016061549.4181390-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C2FF1A0002
X-Stat-Signature: 33efdrxkw1ipbn1aoc4zm5h36eb1wm8c
X-HE-Tag: 1792131379-885291
X-HE-Meta: U2FsdGVkX18hDk7bVaxQ83Rlf2pRqkKr67cwcTDPFCvdH2IDmcHTmpXoXpYt1CjYmIqrG6/M1NArR3snRoVQxhpzs+5zhUMVzsvKIvDs6L+EvaL7PMdyUtzGPhZyovRqBdW3Wr7BaVgN+kvSe/zYG1zyf+PQOk1OqnNay4sw7AAiVCkDT64SrutNILwFmcvIoBmjlyM7Z1dGgokJeY8kj/tfc8K8aDVaULRHFLkBIO05QGMLVMIrt7ytQgRQuY33WNdA4QA7NKlhc2tTGWKC7s2Gyccujp4GJoMBVtFfCWKsJNNx8V1z42Spy2lIU9CGNHFyXlpuf/+zUn2dNPvXVWqAVet7oPA5mME8kqJTw/ffqdwoYmJFwZxsdzhVmSwn1X0SA9opueeSuDQPXM3KP6JLCn6LGK+4HDkIF3/T4t/iKDBcsuCjTVC8uIejwLzTfbzRyHKhsHupMTZtg1mnzfJlLVioaSKHBxGTJaUpT2baNkwqdnvQC2aoIYFhH7T/ITunN5qEeod1vxz5BcLp/ZSzfM8NowZeM8Gf8PUbD62JSgp1iwf2id1TyxebrdhGvWU0lgN7v9I29L2vBANRNoPpEZmbXL+DF+xmrT4fRQt44CYEXxb9iRcWtBF4F29dbn5PyionHpvPQSC0FHu0p55L/16ZoD5O3/skjiFqP1kBzSwLLrcYHCOtmBqfkIyqW4tqkFJbGOiErE9shxv/6EYqFDUezRCCoarr/2HTvdgR1yZFD8eHe375/np9wJCkBVtVbNE80p3vH7rJ1Tg+SeGYxWwLlwUBUjhX5uFbsnKp6IGiYw2cF30gQWPawrY52kI13Pp5REU3PUBEjUK9DEpOZvUhHhntFXet5hDXjD1vmG6f9UzXV0qCOKPjSJ5xcdyY4T0dM33Cg/BdCDpljCX0gHbsg+BnuJD5rNLUfjof0NHOUnzINGZy/c2GLbF0XG++VEsjjd4DhH4SpGH
 blt4pqlD
 bJFA3NGKoEqiBrQ1cdTsz25Mg9X1lTK/Cn8IxjMGY10dT48EITA9HHw88KchNOTaawUklMLY4Gu+1WjRHQK5RIgF/014XNYrL7YL9Iz6U2J7ni7SCgDPJyd5LZUPQoyuBseLV/xX+2QsQZIj/l+ynLWv27Y+mDTNhpFhQSdJn2TaGCVv0CcfXYKD8QmZq8UBX45ESKTqIhCHXZlJ1pr1W00NkHR60OSGH39/5VT6itQzXIkGXTTW4Q8NNLUeBz18+6SU7Z1fwha3bjjMmBJOpPBbCaKCMjbYXM0cEmUZkLO13Ku8WDsApt2Y6qodm8WXKSVM9zhwD/RJfdwWZXLYyFkbm+1i6IV7hEcjCSqYSA/EYCZi1m7MbkQLDKhocSAndrw/DnnB4is34tSWQk83jFBiyczF6k2PJ6JLNglFsBlEb+D3q3x9yGeCLgqjFOw3kyaHa8h6gXdrbhEXc9CKcqwmYRIYC+DxeS5zVvTdOqAfLo3pxgSu68zg3vQNmMwbA3mUbwDkruH59a8sE9CA3Tjor5A==
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
index 62a4be0474e3..529310e3ae1e 100644
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


