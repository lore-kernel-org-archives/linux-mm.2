Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23175C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F1F6B00AF; Thu,  6 Aug 2026 05:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFB66B00B1; Thu,  6 Aug 2026 05:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305D06B00B2; Thu,  6 Aug 2026 05:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4F96B00AF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:36:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95CA0A070A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:38 +0000 (UTC)
X-FDA: 85070339676.27.022946E
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA1931C0007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pih8DKTj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786008996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuSw8PyHR5EplcrqG8+HZ+85Dl0Ckz8ecCi5UKpH+2g=;
	b=FcMYSOpdx6UYP8zstvsaVE+yql2L3ig4iqMMmGXWEXnOKp0y5XR19MT54KLz1yrbS+Eogc
	uLePFQf2fwCu+QOCPpB0r/JBtZuAfRvQ0X6IS9C3ZmognIFNJFEgXIKlmozme+H4zGCLXp
	nAXXXWzTijw+aXNbGlUCe5kkGzD/bsk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pih8DKTj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786008996;
	b=uCBDOJKP9BOYM8VsrtVJKRyzIiMSwrxAuN20sd0NK7ecxhyYf2A+YmIg4g09xiNczR6FHj
	mwt9Ldcqf2IOO7lRJFBhD63kFmzX8Dl3X38bVHEjlSeV2dbz9I0995rBojT2e2LQQzrO9R
	tnA7ym3PTU03wk046FsanAmXFH1H/2Y=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-c888c001628so1207865a12.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786008996; x=1786613796; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LuSw8PyHR5EplcrqG8+HZ+85Dl0Ckz8ecCi5UKpH+2g=;
        b=Pih8DKTjnr6Hg+sEIgPwwGf1Stu8hhCKONWzIsJCDZWScyAnH//y8/1zt9Stg9yf/+
         1RW7EljLrjPM0wgqurrnR80VF7JxnHye0wijHkMRIhBHDRyrAEnMesjvewVadOn4YCdq
         OOOfFF6TdXxWW+Nh9qTznn/2PTaO8j1/lBITNqjRWvgNZvGrQ78gOFe5W0m4qOKU6OUD
         PwUE8thVoHBn+pZk6kZ42D1K8A6/p4E7YZb15SaRcptgwNwNVn9IkwxewMBv3oChQtqs
         NC5ceAUuPOArX8v8nHZ36W+Lj5IvGo7oVzxGRSmoLPBU73tBzz4QbYCKhDQH5+NhegZC
         YdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008996; x=1786613796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LuSw8PyHR5EplcrqG8+HZ+85Dl0Ckz8ecCi5UKpH+2g=;
        b=NZZBgoaoEqoMZO8G6OWRfj+mWbnvEtsDv4qGJX2EAJEirjv5+DLZgguG3nxjBfiGKo
         8TovlqlTbRP2AN7zZ60Iw6Ug3y+jo5ZLVHqjQd/Xe5T4dW0114AjeIyk6Rv6HdBztlXt
         6+yxGdckX2r7HYGfz/xElAEdJgEk4CIesrcnWj82e1JCaPGbgSWe0+BqFpKJtMk3MD2m
         KSAz04QzGq1Mssu8rdsgRl94r8Gpp7QiFRGxYbFQ8b+BEBplNMobSLqNk+n3eTgEpXPo
         0yihfyNpCbHiQMKyBUBkxi1bEv9m/3nkTmXTAoBCJBL1YlhbGpG5mQf/NxFyDoXauldv
         99ww==
X-Forwarded-Encrypted: i=1; AHgh+Rqez+wn7NAI7K1xoZKDb3K1sjvucJEPX0YuLU62WmqHjclkbQU48nYh1EWxRvnWZ6xtK4bA0yRPpQ==@kvack.org
X-Gm-Message-State: AOJu0YyCbcVu4qaKSfjV9poHfK2nBa+PTDpWpYcCs98JwzIO3+VomV+t
	Atn9/nwdCoV0kXKIIHaUrYfjZs5nN9Pt6YgbH7cYgkHS5Wzq4s3feej7
X-Gm-Gg: AR+sD11eQWFccNnRMUC3YZavPNzHMTkNDfp14ERulLQ00l67njDcq3OoYxtfue1bN3A
	kfpewYUGni9sPrZEcCyn71Vrc+FfW6iiQojsocR8VAiZlkQgigDERPsDqJI5Cfsh9+Z7LIw/i5j
	ZTcUhwGylNGwFIAvGSYdcM+vTTf5YatMxzbs2Am6EJU6BEHLJ/W5905ppvJOZLDdcBlVi3jSkcB
	rExOE66Oc6IjBHjCVE+cRXgiSkJnYixvARi8L/oEN+P10lAXS4ZRGfGneU4MSSYnzu3cUs9IqIv
	zNAwTV2dX4vTcJulQtDfWWcLHEMkq8kefNGEO0p3Jo99e0TKvX2Qp/MnBCHc7pkt9a3SI77hTJV
	qN7G2+XUF9jXAIxLYBCWG9ICJasdNX42KBF1QhSz3jMfNPWH4BB/z2c8Iz1XQCVEC2OqSxxFpxk
	FA5YC57OO8EKDFgsGZ8OxGQ5gbfN6DxjafQAWCGkVcpo4qRSFgEAdxBPI/pXNILACjpFZmn0pS3
	Q==
X-Received: by 2002:a05:6a00:298e:b0:845:dffa:3740 with SMTP id d2e1a72fcca58-84f2e0151aemr16066036b3a.4.1786008995542;
        Thu, 06 Aug 2026 02:36:35 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:36:34 -0700 (PDT)
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
Subject: [PATCH v5 5/8] riscv: build crash_mem ranges from memblock instead of resource tree
Date: Thu,  6 Aug 2026 17:35:16 +0800
Message-ID: <20260806093519.2907771-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
References: <20260806093519.2907771-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: amdg6zyjauieiuyr4rhzng4nfgad8cwo
X-Rspamd-Queue-Id: CA1931C0007
X-HE-Tag: 1786008996-488507
X-HE-Meta: U2FsdGVkX18neInbcETtf84uXig9SR+dYaQv2HhtWjNxxsGXJVTBD/Ef8QbNoXu2vxOdv/jIcM1gMqk4Uv0UaWvdYDZC+bKxDYQC2CoSesDY6dw7BvKXruxx5nS5Jl1t/yekxwoZnuhdwbC0IySnKw+W2EnTeOx7/a0YVeOo1JaalETxnFYwHbNFPStcip60sZZC82oX0mGHX5G78TFTat06Nir+qoFg4Yyn0Gl04IewDkAd72ch/njVCOgIfn9Ux1JhobmP8qRXQDoqimsVWEh4iTTqhqtdAZaf9q/4K8qeWULXpda2LbRdqnvis3XUjmA2OQl0H4XFCHTtvT++1EtxbklevAjNXU/zyKcvjFSvdwSrWEqzKLvR7ZToV6yG1xldKEChbPhr6M956CqXhYQUWUtCFMtx31mUmCibGPrcxgTHqx7Dphw1OuYMHKXVQWGp9sfGXlfYce2Opw1bzX4yivJhRHAVLu+co3FgQo2Q3bIYqZlYk848+R7yoDz1ObpkJbETTwyPaSiSJmMWQ3jdhAsu8cNgz+QMqhioLgNOMJu65jr2RCXyFp2W+JTNTq1FQ33KMfLdylsWqp3UpWsotLyGTYUnWEsyUzmU4n13XLEYp/ZCLJ6nYbA5eUHmWaR62XIg5Lhz5e3Nic5325GI/DM6G+tW9vwu4l0FaKfBMqFTeDmYOW4TsYJQ6D/G50jQymx5os/CsOzFNqafk5NoUtTauYB3IEa7Tnjrop4XDQM4V0YGhOImCqIB9f3VJk21jGO45pRZ6xQN0rAq+S+XtaFZLYYXTdaWMwMamztibikOtJ8nGbNuAFRVWaFZPr9wd+ZfjSEgnQUNGF2vm6Xmnnxkr6bjb6qCRai2amBSFl0L1c0cB2q5FQ73kpcMY5gJOP4BKyPtSc3H34oMa2gj+79R/ySz6ICrwX/a3efhaL+La7E3O44QyFo/tFugA8RrnDuGdiqXQ6dzjI6
 qfDTih5L
 LarrbVxS1CLNrnbOMucVP0qq78ZXU/TShDqljrh5rT1b1M9hv2ZM0vaCde7mJZt92cLm22GlRNxjr+T4YsYvfjK4WpJg2VeSogYXMs6tNt8h9sRgAQIES/2HX3c9L01i7X5STG7jeACDD+LBi+zCfS6YPO8cqW5+SjoqeiyT3TVbqhleiUIcf+q1XRvEyy3idQ1buvR/jeLBhiTIIF7WVfgxYXCTBpYmkP0EqFOuFbY+J6ksVM8ToZAcHXYKp2VXzkY6Kkg8EHfognFX5aKNxjygjKgETthEvWpvWRaKCDQc5zzqv5QpP0xhgO6Rv+ESIYgubOyxe77DpCTKyyzpwxxq+DNED2Bs90S0i8y9XXP+epgBcGVxPeIUS69r7iE3trNLZxXVdvxSgutfb9QdUd+Ad0pdZvhdJUvmqjx34RRQ4j6c3XqNZO4i3TLCMyqlQVWXQY4/Te8oGe5IlCa5wniSx9gg+xu0OHhLBV9ZDreSalWvvF6UPPZyqsHNAqQ2Pp9vvLjJbG8tyr4bm3FHl/Cqlxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Replace walk_system_ram_res() with for_each_mem_range(). The
MEMBLOCK_NODUMP flag lives in memblock, so only by walking memblock
can the reserved-memory regions marked MEMBLOCK_NODUMP be excluded
from the vmcore.

for_each_mem_range() iterates memblock.memory, which is freed after
init unless ARCH_KEEP_MEMBLOCK is selected. riscv needs
ARCH_KEEP_MEMBLOCK to filter reserved memory from the vmcore, so
extend its condition (ACPI || KEXEC) with (KEXEC_FILE &&
CRASH_DUMP). arm64 and loongarch already select ARCH_KEEP_MEMBLOCK
unconditionally.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 arch/riscv/Kconfig                     |  2 +-
 arch/riscv/kernel/machine_kexec_file.c | 31 ++++++++++----------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index ef1101bec76c..bd8726b4dfbe 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -57,7 +57,7 @@ config RISCV
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_VDSO_ARCH_DATA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC
+	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC || (KEXEC_FILE && CRASH_DUMP)
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


