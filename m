Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBDFC606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZvCOZJDe
Received: by kanga.kvack.org (Postfix)
	id 05A1B6B01FA; Wed, 21 Oct 2026 04:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031C96B01FB; Wed, 21 Oct 2026 04:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62DC6B01FC; Wed, 21 Oct 2026 04:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE8606B01FA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:30:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7629716049E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:30:46 +0000 (UTC)
X-FDA: 85345962492.26.5E201F0
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E0F4C0009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:30:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZvCOZJDe;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9/qG3hNPJNIGpwptQDGRFtRM3jaRgB/Z0bZ0bWRF/Y=;
	b=7gBfHkRWJEJiwZWEWYI2+93U5tvPPEtq1AdLjyd0jg75osQ0fBjHP80RaE9nQZyhhWh/2C
	FkQgndu54EKiuDmhALLY0M3mxbOe8JYbMFIm7qlgPSBr61A+wwQiDlg1MHul9aWwpiO8hA
	9tMKa1QRC01R+TRgH3/NHtvL9yVAfDk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZvCOZJDe;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571444;
	b=iUu0UJBXWHW+c5RvlTqkk9RewRXHUYbgzwQ8J2aDj5AKsbO3cIUm2fYSk7FhSOP/KwpLZe
	X7Q70swI9KNLEm6KPTn1tfDxTboSCusbZaZXkn5kzfKydgIvDG/D859vSZ6HwjjO3sb+hv
	JxkshOkViS03TJT+nxqiEWT0aqiThAc=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-cd63952c9f2so54358a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571443; x=1793176243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e9/qG3hNPJNIGpwptQDGRFtRM3jaRgB/Z0bZ0bWRF/Y=;
        b=ZvCOZJDeapnAwbdKD1xzPMSkJUDzGfZLLB0YHX+HyOeCJsZ/pBsEiHBwByMHbLbKT9
         AwfBrxHsRXDE4yViMt5co/AJe14Md+QQqBNgVQaFn3qYwOMTJzTcPcJpqahURKgoobIG
         HXRVRjd9G2/tsCbszwLVVREUsGVLjZMqnsNATj0XQ1xiVKOiJt/yGzmpXMVo11QUZB1q
         r262IsRoGIPxgr8eQirMNja+zBq2KTf5JmPz97ulGf5ghn2wlFMomqGUP0dbgNGp9v+a
         pJvvL5ks9Lcc3CFv8VIwmWxB7loZ9OgxgUKGyaKjj5jOQSHE5ODvKoQS5Fzh6OyqpXm6
         ppbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571443; x=1793176243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e9/qG3hNPJNIGpwptQDGRFtRM3jaRgB/Z0bZ0bWRF/Y=;
        b=0qPOkidrBLA0WhkSNEygNbFc2yyFGAZp02SYWesZs6s/rlscoWrwEsg/IWLMMDthz/
         Q5/HnLa0CMlRO4Qp8xxs+5P1emCpKc14mhD21AKz0mqWf6hoEZIeKbLqY1ivI/d9wK+P
         LzGGsIzqpH+VO7w5/Y7rVdVmd87tqZ0/q9ELZdRsc13GH/p0whHfecgHGB+isJgxASA6
         bcc5qKkwzJt5L8QE5Yl0hYb0IQZ8BtFywk89EPtIYiNkADK/Y7rK1mNvsrNBrXbTEGYE
         hNCVi7yq7y0mwRPruAG3zpq20QAbCewer7mqQ8hCH8Kvpg76AlYAtZPmtQdNvhz65NMK
         62VQ==
X-Forwarded-Encrypted: i=1; AKwUvBwlnw/LNVekrzVUSyEPTESygHNPRoRpOlwxN6vP0o2vVWr8bXEUVMZDO5yksDrkrJ1QqQAtCve6aA==@kvack.org
X-Gm-Message-State: AFq9FYKTnonEX9tJoJB6KNrGvhpsFEK1ZQdiBwK3MlBXFQ36rFMZ9Jes
	Ga6HHPkyFXURs1DCj54bowywzjVlyx2lbbu5x18kL377zbo8W7xA8kgh
X-Gm-Gg: AYBFou3FocZLc1s4Cnn3LXeR4PrRM/JvTlDDYxFMP2u+8ibfN+7BruRx+AbTkFpgDvY
	Uqdv01ZIV3X1YKjiJpQZLekzCAgQmDL5HzkUn/JiCTJVVLZNY0SQIvYieb2dGxWJMTOwKEI7+u7
	OiXQpLLI1wgrVw05RiMYLIENrdoRLPhOVJvEQJUxHpa8uY6bQlp8kiD+8IQmL7FXHjkggANYGjv
	TMvwxM64TJlK9uBpTFBN8bvltl4/TPA1cCYs0CoWK+yENpRS1JUTypUCcRRX3wWwTAzSOoYumM7
	rtQ914GoB1ibIXGoBS+WihXTYxDGuS+2Cr/Xgk51vEKn6xsfWaHoxaco7tpEDvoflNNaYSOvAAa
	Ja4Q+mYvh/WiaRBuE5F7dLGxV2MaOZryTXDBufylU4ziQ4BqL1PogIjtEeer202Jj70ItSGPoYj
	bpwnU0n5JpqLjk68T6mCABicwRi84a/r46piDnVhwMOKqn2GjA9dxyhmkZKw+KYBRyGJ2KePA5l
	skzv93eXgDsXZPjrUpzqc/z11ZHkCLq3lzyVFkFqy7hKYTnX+knVJKGBkT9+KrtOe7D
X-Received: by 2002:a05:6a00:a204:b0:874:708d:b620 with SMTP id d2e1a72fcca58-8a089d13a97mr1238939b3a.30.1792571443298;
        Wed, 21 Oct 2026 01:30:43 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:30:42 -0700 (PDT)
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
Subject: [PATCH v9 1/8] riscv: build crash_mem ranges from memblock instead of resource tree
Date: Wed, 21 Oct 2026 16:30:04 +0800
Message-ID: <20261021083011.2170525-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E0F4C0009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: yxzjbtdec637zeqw383rkczbtbn5jhbw
X-HE-Tag: 1792571444-206965
X-HE-Meta: U2FsdGVkX18g+p23zOLNBKEEGk9nUyJFanTZpIciThf2uAb6WOR0HIFipR0uQdmpLNJDf09zJzV2GBSw4huc3MedBTY7gK4pksZmq9AaxaIatGeNdY2Pa/5Iji4TGBauDveAlbnTAPGJkrmLL6ScgRhJhbCEmYEsMhYyY1c5u0hSnTVadj0zffqqcOSriNFQC6lqoDb4x/VOcii/5Y+fEhMHsFocq3znpfywy9g9XZ5LthiX9m2dNoqgawp9zTAi3G/pCWphcCVdoYO91XqT9mi/PlcnOov5GyU/I+lyUFyCpOdXIdZkVum6UcOi92jHr5+LBZLwfD1JD34PgNu+Lvd5/zAcYUYl9WyEdhT+uEQ2Th89FpG82UL5CQSb7o43weCKGUugrjB6O459pBGki9rK1btshNu7KsQe9Nvtt0oD2hYM6L3yH7uC57t2/VLvrLbk+Wl0oohaaVAQhhe9ALZYUY6eP0nGpUpq0VbEKrF757KxjIAobMXwuly7bmyAnWjNOcag4d/uEKbk/G/w0TyYJcp7+RXU2EZXhzrzaGFRRjuXnEjP1xBdJvV3Ggtkcgv5bEErUOYpoXPTe9du8YuDAkn2WQQfsEKJOGVXt9BKuaZ/A0YgYc057Li2YnUFDPfMi4T3tJfOCPkUuVRTBDh9f4jeigpN4eL9nzRoWAiPch0EjSSMG8BO6rfrl+2n+hjDaJQIoGAuyTQK5ljqWhFQp33gzwllAvMV7iIGmJP9jKVAUrMT4rcPAP0ewTZ7z9WTaPdH7DxSJsKEr+XxLSETA/0l+9PwFFnO5COeeHHVh2Jd4/HF8UCoN/ZpetNw3UJIdc1OAvdIE/EKYsG2Ort5TkrKSwossTUVxmcH42Fj32NYX7oNUQPiGB0uneQP3MQki2ug2HBY+k6BZHKrjgxV3T2NRvOw+LfGZpZuWQ4JvS6N2l5N8Ke+KmAeHs/HDFiGrLKKZEyg5ia0l0v
 VXQgi7Sk
 JAT2qA3W18FnsCdZMt9ScjcFn6PHaaKKAsi9Iadw+0+SoE79J3iCQqU/bA+Uxrzbah/qdAiW8yEdp67V0Ixxuhp+YITWr/C3AsQTRS7HokEUEm34Ih/EjErJv8FxdbYCLlmQpBC3QMYnWABcOBpLtpU3P2oIHbLId10LGovwnRi2uZTklqoiek7KpNAD+eWSG4kzddYw80c9k8vYl0GhqdE9JzVelpE1pzfVV8X/OtaX0J+zYMZ5cIpr5w3TpUxkDgpSuzPffYfxSJ/aVxQUgYHMc6preiRK9jxGydKJoAEQyH1DM6SCIT8oX9IG15xYVoJ+BAIWslUjfwCK9gy2FNmlVzIrq4tTUEQVjHipueLbncB3ZLDHJgDMoadvMXiCPEYCVHZR2bbDtl4BNNf4DJM6ma3rKXAt7yxeATkcUKmQJcFpc5Mp8v7CIpX8CyT8klL95rcudxbeA+G9HLDjQgq/0G94+88HwO7CIrU6RceXgj4SvizSMHBAdrDyc/0ZH/wU++bg2uKvQGIjl3u0h9Awjvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index e7891a2a89da..e21d0bab77ee 100644
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


