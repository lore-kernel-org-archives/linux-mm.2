Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC647CCA46B
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759C66B008A; Thu, 15 Oct 2026 23:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732026B008C; Thu, 15 Oct 2026 23:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620C66B0092; Thu, 15 Oct 2026 23:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 402586B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:09:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB536A0224
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:09:27 +0000 (UTC)
X-FDA: 85327008774.27.88B2BD6
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0F7EF40007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:09:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y1Ucf6EH;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pI8cU+3Va0VJY6BQ+e7sBVT9LPRu4J+OFo4gOdjLJ30=;
	b=lkIabl9TA6JVleEvhYLn+3rSmYQG+LN9/XeR+ez5krxSr7pAlw3GM1B92UfGfeXEU8hq3Q
	CHeXzRL5U4DBQ1WOHWoguWxMfP+Qf+ghbz5LBAhOI26mY9vmKyRQ5Flj+x1DdN+gaNVqie
	wvmDz5zFivY7tFmNIRO9BAonWdrUeyk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y1Ucf6EH;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120166;
	b=BpbUQDSMM43PYnh+ZuxHWj4NFmRUhvGgWoBx6WwFLeomUnz/uVscC/rAr1tTnzhUl2ozBa
	tMyDYZKfWDI2ijuGVBtYM5GVMbBxUaXvrPMsf7AFp5SZohoodciwZMRv+7rXnV11RyG5Qg
	l/hi+E3vZ3x28DOJ6aCuCbN1u3X5GOc=
Received: by mail-pj2-f9.google.com with SMTP id 98e67ed59e1d1-3a51696a650so3488752a91.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792120165; x=1792724965; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pI8cU+3Va0VJY6BQ+e7sBVT9LPRu4J+OFo4gOdjLJ30=;
        b=Y1Ucf6EH9IYaT1/JRp2PbKpZo0fl9T3+aSF9IsP14HGNye2ng9oawbX+5dcujZPpDC
         vgJ7JP4T6ja7DScqElnLUey5u1btVmDrxTIHDy62NTf1JzEpPVrNsXgCFt0Iod906tpu
         cvkJ1ze/QfEiNYRhQPUF1H/pqiqp0n9LtO+lE07U/Oa0gZO2qVAIPhzso+zPyPrlnbK9
         a0TPuKMBh8xUIFmlH8MLrH1g5FdcFDOPxHNn/mAuyLWW3rQWKXhoa/sPt6OJAMRL3Zeq
         AUopm6a+LvtTG84ArBEyI6g5bUT45hIbpJgYa3C/XHFkkM54UU0gsxQHQMMWx51ncEP1
         s4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120165; x=1792724965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pI8cU+3Va0VJY6BQ+e7sBVT9LPRu4J+OFo4gOdjLJ30=;
        b=JhWBJbQ317/yl8bUaG1F3oeDcvjMvmhNDl41a/z7yZ8APlkm0vyXhPsWQYolG0JPDu
         ztozg/WsQpJpsEh9gr7EztCi3Uok6PF5NFI0b+FUkD83sO9EQykCmLtEeUHPKtvIlDdT
         vpMnR/6sBh8JwJvoQ47Ip7BlN8BhZgkidk3x8Xvcea7Is3cygz2KriQSESXx1cblxMY3
         oA6sktf6mWQPPfrBXLOKlRNHhrN7MzedhBeYu3QPr3hoRMMKfGmT/uowfpYtY/b/+s6a
         o3+PeaX6hgrMe/x9GGCclyXiI6FjUEMuVnOa9hbM3oUkLJpi3f7RVv8Zt+914ywyJytV
         JkaQ==
X-Forwarded-Encrypted: i=1; AKwUvBz00BSA4qCshCbtYx9jCqlQmb2tM/oP3wlES/lG4wMDcmco+F2e3B8h8A/STQ4C7058vF5+x1Heuw==@kvack.org
X-Gm-Message-State: AFq9FYL9+x6P78Wqej7exn4LKEnwQENwMoUyThhkn2hAKCLAfCFIERNf
	LU2l0osKxKnpxVahiCDU+vV2WRFwNBhjIWO0kCFzQw0CNgDz4T3CL6LK
X-Gm-Gg: AYBFou3GBzfM/cB3uDTV3JK11/o6BS6qARO6Z/f74KdaprJMugla1BLmdasa2+fqWnl
	zZQoa+2n23eHX3X9fipGjkN10mGxywmtrqZ9VVSE/Ke35VytfLkyHQRmuCKVVYcBtoinDJKsyti
	ebi3bDJ7qQsTeG2edxPwaeZ4oCxC/4fD6NPPyNs8004nB/t05JIMioGViWlfxzHicWY3Pyqcaf6
	Vru63diPIQWv0XT+zBKD+OOYOzurKytRjxCkKu/C6kDkopRWhJnQLmqpJHTxXo16lntrr3ldXwT
	KK4A157mfWO0Kwjk48bO23yelLDUzFJIfcECnquaKr+xxyIuVr9y43rvbW5Dp2AumS1aaaIAuvS
	PCZmDVZzHCMrGUpW1cXNbw915c3udp6AnUP55FaX/Oiq/QYc8SIQi5tDudxxyefWdmHnzWrpxiO
	HziVkMVVyK5/3pTC7RtFlX0rkMtowCEPuSDqg6reZ4G2sYYZVPLbhE1OjZBhOD4xtOdU3VaKINT
	IZUsbL/F9o=
X-Received: by 2002:a17:90b:5823:b0:3a7:9413:cfae with SMTP id 98e67ed59e1d1-3ab3ab1d561mr18240688a91.42.1792120164811;
        Thu, 15 Oct 2026 20:09:24 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm370085a91.4.2026.10.15.20.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:09:24 -0700 (PDT)
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
Subject: [PATCH v8 1/8] riscv: build crash_mem ranges from memblock instead of resource tree
Date: Fri, 16 Oct 2026 11:08:48 +0800
Message-ID: <20261016030855.4062882-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016030855.4062882-1-chenwandun1@gmail.com>
References: <20261016030855.4062882-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F7EF40007
X-Stat-Signature: 6yhrks348p3zg3498h4eki698dodt9j6
X-HE-Tag: 1792120165-837971
X-HE-Meta: U2FsdGVkX19eNKk879kTH6iEDwo+yamf485H77VKs3gLCe+ecPMVEN7xH3vLdJN1Ja6V2FtPtBqvQv2NQCEXUyV3ubeJXPoEMd2aQoPn8OQToCiFzdziQavihoSD7fpdG2xMlJ15ZDISGMGZxcOvi0mFhZSWrswlfJimWfFugBWfL/jXc7Hfrj9jafZkAdl6mqVz446Xfy/hNwESSowXcJHt1gV/KTEciEPxHSPTfPHHqZalREQzSGVpgHqxl6fPzjSBu5xErDCy6Zyc2Th/DiawUnOyKJvERCphtf9qYn6E1YxCpFisK7q7csmC2pEUV0GhXJ5pmyBpyKE77lZYPSju2OFg9Tl229w3bZwWDKoVUzOX+G6zNVrp157Bdie4+5KA7wpwo4N2xmPb1Lo7qsHUG29jpyJI6xxCdKbwk/FtP1y1uexQybNG5oYPRueHAMuSkQy9ynXba2s6sBwni3VLWLhquZt3AgT13DlTdI74GwitEqk4CfDoMp6ywtwxAmC3X0M2ZSALnYq9L+EXwiFj3wr96UbYKnZtslDc1nUWr6Du9AQIdWpydRB86uli+C0rAbWsGMECopJxo9PQ+oVo4PmKBOvXCYhzN1WNPBS1VGDr3WI8w+xImgo89eiUFa211D9sO4COnUu3wpqVIXbqb+Si7sAlNbo2hDDNaxEw1Wji3C4e2m1hM5AvI+nuRRRH4e1Zi8qbnLDQ2wVjKNFRpHenvVYhX1zYXmLgtMdyF47D/crl0YgsIYr1racUvwUyYfOMopLp+AeyENl7dk7f1qzZgN6yXaG1Pv2dZTFMAbNdkVT5vIA1iPZd47kb8eN5iX1iOiSC3TcJhoKPqEqSWKGeDKN6XD99/kVnXDKYJkbcLjN3VszD/rXHxPFHhtMJbuLOIVxxa+kSzfLjANiOcyBeWKtMLpOnacoyedbwG5ITx6s7qQkU3NmfDfJqDKMSkswb3q1OUC2XVLi
 YaopK1uX
 aooPQFLYeU4Yxfug1Vlfi+ShgpdWZFkpCgNkdbLVdoxHSFWGNth5TeFxjemOPAGKhk6nEl/lTn/WYgJ1MsBlR+HSb8zWQK2SO78xVh5oPn2nBoIPjjj/oyTfnF+dkcaLRaecIuI6VMPotz+0Fbr1Z7OZo7PSoih+y3y5H5dGHWG/NSQx9s5St53ZYC+nUuoIdPtGzWlub4d6y18a6FHTpZoJ6ZUMRqYvIgE3o0eHZr6IL9psfU148G9gTC53LRXyk/btnkRKFeR/7iBOmsKsrhQ6SmsBj/QNoRVf5VE7W+4uTw8oeFxCOLE2ZXFO0uxxy3tU05Qczx7lw0/S4TZ41p/iiZ9+MD9+nGT6bStY2A9LZAHoSnR4zhc2n9hT219yZwcWV909Q63oFhMRS3A/P9/hU/fgEPYxjQ8XIgxf96HamNYn1ucmf1K3SAwiJ9IDrhkm7hBhgEUGc25WNnxRJEaLEM+oYnKC2Wq2XbK1+lvb1Hg71hUAbltNe/oNkQ5bDzkoluAMub5SW3qi3DUjdN1npjA==
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


