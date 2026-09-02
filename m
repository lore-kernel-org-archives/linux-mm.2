Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D8B1C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1302F6B0092; Wed,  2 Sep 2026 03:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109266B0095; Wed,  2 Sep 2026 03:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01DBF6B0096; Wed,  2 Sep 2026 03:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC6846B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:32:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5647EC0787
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:02 +0000 (UTC)
X-FDA: 85168003284.21.FCF2427
Received: from mail-pz2-f10.google.com (mail-pz2-f10.google.com [74.125.228.10])
	by imf15.hostedemail.com (Postfix) with ESMTP id 890E4A0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UtKINoHS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.10 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEYvUbaRHsvrLqexK6TwRNN/GB2ra0YD4DknJvJHsJI=;
	b=FGM0pzNwpN1kpDgllc6V4MKqX58+E5SEiCPoEUyjdFWLFkfgYWXhgCBkaMWpcQAKD6AO1O
	rAjr6ht9gEen7smOZBULT535YIBEpd0LbHcqA+uNF2TZT1DfK61YBg1e7mN0c3H/p8QMLN
	EHDgB331RNOFPcrKINt4hDKZqehVap8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334320;
	b=oJgfVXDgUzp3kaP+cbX26JM/fBLeSqWD4XxUsRjUkJxSUvbj9i7ctyJBsPe1Fzy80WZz/e
	tvPLrlp8BGDaQjFRgO/VtldzDu1zdmc49Vh3e0NLy8TZQKZx5mUusLa2SjfIsSAc5rp/dp
	fkd2w2poTK4xqRwvh1bKwxPjQZPjPqY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UtKINoHS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.10 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pz2-f10.google.com with SMTP id 41be03b00d2f7-cc1c753b1bbso175884a12.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334319; x=1788939119; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cEYvUbaRHsvrLqexK6TwRNN/GB2ra0YD4DknJvJHsJI=;
        b=UtKINoHSNQ14b0Cuh7KueDc/dOCZmY74YIe9NSQNDm62/+TYX1/oB7SCi2m8Z+XIvt
         JqS+H6N7JyfvE5EgdJs8BRciJJqa+pYg2Z48rh79WuOnRGraucgFvWGwIif6DOs4aGR6
         tbDVFh9vCYFaLtdqT98LXhISRfuaMZMBG+7KW8WjqcFVfUiLtZflKa7XzOteKBUVCcj1
         Hv+TI8QGZdxwwguGgapdwRl4+x6wOsLpXYItBrsfMNmFYiR3PeFBFk6gZSYQ1svWk8bx
         qCU+r+I+LI3eepkA56A+hwKXd8xmw8r3KnaSTA/NLOPe8+bMIGJqdyaIdgE90EBYQIiX
         Un/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334319; x=1788939119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cEYvUbaRHsvrLqexK6TwRNN/GB2ra0YD4DknJvJHsJI=;
        b=Mx4PqErjwCcTn9tvelFgz1UA21LCm4WH6JasldZENI528HJs4y5GRJQWXmDwlNcrP8
         lA0Yp2Aa4LMzBpC1KRjeEe/fAHr7IdPOS29N/ZmRz0hnu3+EFqJ34BP/AMcKU8zCOmI+
         LuDZNetSGJYkTCcCqc8zYS6CmZlt/EONtLYp5SC9xGTPs66xHaS5mS9JIyIufibK7cyV
         o12/GjzEA9OfUWmTpS2js6TKOfV3OYq37QX2UiFNlkUFHsq7gj2vmy925CXp7+KsKgQD
         OHy3IBTEWuZgQgOmi9XqdBuawy2htdB+A2h3BuzbBJRp+T+3XgZkdQddnAVZljBzS+Pi
         GrXw==
X-Forwarded-Encrypted: i=1; AKwUvBwXERxSdvHCh+iBumjHnCz2IxnQWDk8jVGHlSz63nAUP2MrmauS6Tpnit+OETQLFLpqetOSO9bxmg==@kvack.org
X-Gm-Message-State: AFuF++lASDVt4VOiehIP961QYv9atdnnNzHFZbahr6VxE2Wnxy4rPqJe
	inYwKWyJ2Tr0t7unc7DSvSZd3OgKyliA54uCsJ0I1XMMfmLKkIdj4pe0
X-Gm-Gg: AYBFou2i55MeqN+6Cga05lC42dWoc1LkUQ9BbIeCWum+1GFMFkhl279TCSfwMsw073p
	FXrBnWlYwwlC5F1tc9oypB9AwCEWcVyhmLGjnqoSr6qdcSwFJ3uDbpBA0pwx0XA9Ab17ghR9IKK
	JSxJ9QgzW636VHbIQjJU4AmQ3L2bvZUeCgODDCs2+FTaUxQuZqbCEQ9ymm6CXaS87+Z1n58Qw/d
	CDob2QK0tQOdAmIUA/8jCGmVtWfJyJNvybOxS1iEQDPuxc3qS8K+IOamjRH30BluD8cM8xkNU8e
	edOLog8vlxIfBtP2iVFYOlOp4HVrDgRRfelv5ID+8JWK9JsVXXi11fC+0uM+IpFnfkpR9r/EzeL
	fTF0hlahX0QlHb6PIrZF0wVrBhpwgDupdFawsifDwUpvNyE7JLSkfufaEYODFtFSDOvzkd6Ny6R
	ZsTq1H0MIGiW8DtVA6gyBiuFAv13nbRXBQm7yzHo5MxOt06wCdMV9q5R+L457sy/3dReei7RKA
X-Received: by 2002:a05:6a00:4188:b0:857:7384:b5fc with SMTP id d2e1a72fcca58-85ed4d137e7mr5136737b3a.24.1788334319386;
        Wed, 02 Sep 2026 00:31:59 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:31:58 -0700 (PDT)
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
Subject: [PATCH v6 02/10] riscv: build crash_mem ranges from memblock instead of resource tree
Date: Wed,  2 Sep 2026 15:31:08 +0800
Message-ID: <20260902073116.802752-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 890E4A0003
X-Stat-Signature: sxztzf3phuxneh9mi4p71a6fokfgy7gd
X-Rspam-User: 
X-HE-Tag: 1788334320-897956
X-HE-Meta: U2FsdGVkX1+uKtNIww7UgwfqfOQePvYOCFu8nnwnv0dWvkfoIOiTzc6h4LDMJBfaeXFFMYb36BwkO5gQbfW15g6jm1wowUpfoEWtxx1QpinxTFcGIkoo6vbWrpQPthAsyFO70fJHGQ1VhnxIPzpkVyUFZL3gpT6grfhJhuLnXMMcqTV2WEla3VZmMHlm20yRGRUwiiZGtyDcCTEA+L7fJCyUISfhcEUTsHRKVmEiNTZrt8T+lQ7cBl/dDwmSnqYrgvSNjTGNwB9pMBJ2zNXAeY9e171aMDA68VAx5z7WPxlFrDMTbQo1TKb7sC5LdfqxE55OCVG9TkrWhayJ1IQgG47naE8Xx0kHEZtnSC1CbYTapcNZ1DWdluoP8E1FBbQFCijmjwX38YEEHFkE2ACo2RmNFaoh628qt6W4L38RYEbnZWzsrJi1v1CEh+tGA5zfaQrxWRILsE2Qd263PQ19tg2c6XRLrb7Ch192HYx8Xzhmssp2VXrIowk4cBaGx4RUf3yvaDNtzBR5j4zBj0BG0a6tGHEMFcNz8yumWGous67Ek1pACeZD5tkV4qKz8GT0bXgqWmbi7UXk7O8Naev1f627nWYUjqAcYeP0I0fw90x5yWKoWATONtMPODNVM3VTyUSlEyTqBkBEvEFK4eK2uXBhbDHdPv6iEAxypLn2tktHTtt8NRZqKYIiyZEIwUgv49mBuqer2x13wlkK9Ufk3b8OACtj6bSfgFkCm4xS0awZG34UxlFzllD0WL0ic7SbHoQehJotltX5YldeHPdrek3/w59mN2DRsxBRusAKY0XAI1AuZFwTgA0vwaLCPYWesinD6i8WxDAqjs4Z1aQBZJvsjzcnYFyHpVt+nZwNEXwqd47N3dnfPMQfgul66/VKZxA9IvkatWoXGFV1uzRtBRnJXIfBhNvoVCTLNgSoUkPZqwkDCK5XU1R1IZ1Q5Pdes3+ZGvcl+7sHYnsVXEP
 ICeaqJHC
 ciVn+/K/NjWh6SPwalGfqsesbUF1CtNuRjvEONMdbOK5cg/K5sJ6VjZhY2nll5F/+iWqMIi7d8qkAHsyNh5Oq3eo4a82M1quPXTMo+/6me2ODRvZxoGeK7RZdPeNdBt3BdFdlRg22RRcjSmOt/tEy74zZgD35DDUpYAV3xITBvhlHds54MMdXAYwrAVx9Udp5f3uKtn9jW5xJpGzGwxVustY5PrVD0Afdhn0DCbv+Z0wI0TYHFtrqecUqp1BFbdeZUBPblFlxmNwCCJtdZP626k5cZJ1VGYHZNqVMSFkngOMsOG/yokB+XBgyoAFThVoWMUJ/vUQvFuJv3lCTU1bgJyLpygaRpsr1F/yUGT7FMIaWerD4weUmmlQ9zRVKTSQplbnw2CtWlUfs/d7ELOvKB5SC0FKNcxdVprVlLIvPT9aIJ6GzYSOPTBVrVe5/I0qbggFOaxOhose7MWUj6LhuUd8kRcSK/wzTnHm42TNWYcRJCuK02BqA+5SDsJ5xmqZJgDX7GIaTLGzIlxcXRPmgK6Wxaw==
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
---
 arch/riscv/Kconfig                     |  2 +-
 arch/riscv/kernel/machine_kexec_file.c | 31 ++++++++++----------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d6c2dbf8455c..1de14a2d5aba 100644
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


