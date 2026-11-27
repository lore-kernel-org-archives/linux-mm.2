Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4076E606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rQ+hW+t/
Received: by kanga.kvack.org (Postfix)
	id 331086B05C6; Fri, 27 Nov 2026 04:07:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3089C6B05C7; Fri, 27 Nov 2026 04:07:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E666B05C8; Fri, 27 Nov 2026 04:07:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1CCA6B05C6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:07:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7852B80295
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:07:56 +0000 (UTC)
X-FDA: 85480321752.01.189F1EE
Received: from mail-pi2-f9.google.com (mail-pi2-f9.google.com [74.125.227.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC2D8C0008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:07:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rQ+hW+t/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770474;
	b=jMfP+n6sZ6c6wo7PdWerb/4RW0DbIp9n3RXbEHumV/gSx2zM8IptqWzmMIh1KBQUd5tG5t
	ke19fZIMig/vUocsVqCZoqD7q0ThHLbt/+rIHQDNvPEgE4qur0pgfd7n20nQlvKNPBZd+G
	WRw6dTAiLpjo2+aQAiR5HPq93RKJj2o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dn1PH2ygUv/59VEsbUK76gNJjYdjlSTbo9l6L4HVgfw=;
	b=C4gt29teA+WrWUT/Afbgr8nOcd9ZhsFz7Vdt44rQrcO/Qc8x9LwxVhdL3DVY4iwZ/H8GGw
	Qbhu9UeH3sD07f5eguLEFmzUox9pwBgYymUXDQzqOw8bAUguZ25Qk32RhduSxlL3Jfq0IO
	WtFEblDb2NqYKLUbl2g+wtYAQ4xtmd0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rQ+hW+t/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pi2-f9.google.com with SMTP id 41be03b00d2f7-cdb91898fbfso3539370a12.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770473; x=1796375273; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dn1PH2ygUv/59VEsbUK76gNJjYdjlSTbo9l6L4HVgfw=;
        b=rQ+hW+t/bO8U/IdjXoBZKkyydedF3pnX53xnt1iAfwSuAdrIOSWQqOjA2ZKe2+jPvU
         BQyO4yFAV8qQSpkRu4waFmhji4wGUXQ1CH026Of5J47s+qxbifRPIHtiNPj+p+sUtqFg
         bLTCFLzIsYZTzu05QuBp9kNgbFuVedJ08lYc6ircRo8hXhNNs+byy71Zc4KkfjcdlUyf
         yJwGVinqE4bX3CPZWIX0AG9KFDXzyiFMfSAZqJo4+8x9AhJmtPF3UiZSfyVWujsrWpJW
         JpowAQiRxTre+fcU6JIv0SXI/xqwanW7DZphXfbyYwa+CKMDEydLyUTodC6Lm5sD2+KV
         yfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770473; x=1796375273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dn1PH2ygUv/59VEsbUK76gNJjYdjlSTbo9l6L4HVgfw=;
        b=i4BJeNTHhNkeOb/sb6tUSWDh40pjMuypv3gxVZCt2wuznyl/o7ThxTWoIzz9DrQQc8
         01jKk6FabdxxR8ektjMBuphhuAvRQaYJkxxwcQ5xkoPm3qL3xRmPpzG299kn9qPQLvVp
         63llQhPudHrcSBo6SLTIQVf9P3BMJ91URHo7nDUlCWli/+M8ywT1o20FoSD0kjrHVD7q
         t/GoZAXWZ8oPZQGpGXrsohDaYs5Rxb1rhtvtjVqeXkrbj0o4AnEanC/2nj0l166oqJPp
         p+YHb84IukBF+7FTjFIllhUuveHCHmJarfy2jC8f/18besZl0tY4rWs9rmJD/Eob429m
         nzzg==
X-Forwarded-Encrypted: i=1; AL+hErH6xl8Wqb4UyrRco4xJ5jsAo0o/jnxp4V5z3MzddZ/VpLEp5GwZl909UMg5QrRw8VpP1m5Mak/xgw==@kvack.org
X-Gm-Message-State: APuU4Z+vFL079nn1tQowqnq7cnun+ehwpAhSEturx0TRolnHiR0vF67y
	alOzH8ohhxYhk/nPPtuR2nHPaEqLrAcbJvm8nAdLlf/FYYmMLSFBXkEn
X-Gm-Gg: AZFdTZd8pHliTNYFF/RTLT/FNV04cZ3bBqVNW7nER46hIs4IVonqjfBxVv/WZTXX1jz
	ow2gcxVYFlZEbe/RCXucrpnKK9O/9OMAKHF0f5XFnze5Q3AT/EVZByAXE/ljnCX64+9KVikgtDV
	LUhH2pAlDtgf+93sr7DrnrG0xEq7WuvbByQqvdxXSFGLodfkxJdHG3MTiUjgCY88MlaWY0C990P
	q9NcMkSBSUjwL7x0zTeQ/gy6QIQROvUDZ1zwRgi7hXp4RbnrW6CCNQjICvsGwNE3ZTWsVyXYJJV
	d2zuVlzTMCFySs50xzaPu/ApvUOmUj2+T3PgfDLTuRbBZa1WFtp5plDfmVGfqknQ9HGSqHr3uhn
	7KeomgVun58adFzSKClN6AP75Fz/XQkhvzja4APR9jCIS2eZ4e3bcPL4g6m3jDZ03f4yH0EMnkO
	pfvMWI0pLi0piQma9J/6D7DUhSOr0A6O1uaoOi/25/AjLPF/mwmcrhah8SlE/aOhi8R0HokAVlA
	pVQ9ZzqvKCg/jZKJRoUkeozh93xMl0tR5OLOM0T8H5EiaAZc1h1vc/VlbnOvofA2i47OmYnO0gZ
	1WDe1Jx4BBii4iZBXC7CPSH9eZFp7xtIFTqF2kmlqg==
X-Received: by 2002:a05:6a20:7c20:b0:3de:557e:5ea6 with SMTP id adf61e73a8af0-40283cbd05cmr14085693637.27.1795770473349;
        Fri, 27 Nov 2026 01:07:53 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:07:52 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
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
	ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v10 1/8] riscv: build crash_mem ranges from memblock instead of resource tree
Date: Fri, 27 Nov 2026 17:07:16 +0800
Message-ID: <20261127090723.741253-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127090723.741253-1-chenwandun1@gmail.com>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC2D8C0008
X-Stat-Signature: k9dm5nzhdrk7ch3pjpmdny1efs53o4qr
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795770474-787781
X-HE-Meta: U2FsdGVkX1/n2gFDVOMNeCXyRUqr7fDy0aDog+gSSP/CO7xl/JOcuP+ZhzWOfP9KC+DDtC4ZpNtulPluhY0Mkkg82gyni0JH9zDfy+5P/1K1A9uTS7G8wzDpvCuAPS4XJOTUlvTxp1F2ZX7dLEXrey3AdoEJSqYCuIM4VZCCq6JLHA6MZg4VaNVI5tCUkmj5Csjsx6r4zwlhJX4glaT/zzgg/0GcOH1gag3UHJLvDF4+5zI4Ku7mx15IRLjhNoEMNI6enAQY40QFlOidthrPsd3fej4szZvwiKUK07LV2aNJwJZ4tb9Elz1QcIQEb3TiXHMxXzj3PX+A2dZhzs2RtkABi8NRHyu2zeHcDAdKagAxQmJYsHsdp4yFpfMtkgQVSRA9MDf9tP8vtKzJFckb8IB6BF2i/c4qK7PVX9p/KuG9aTSuJaeSbl9YF5Ef6gai+Z30T6tiEJU4iikSpciBacnTToI4tdlIWN0sTkeOaTsh1aWNYmdUlqIdCV9PrXkb4Y9Oz6gJ3JCnoj7spIvxLZjYaoo6E7BkmFXd84QZDDD0Cy71gZcioXQ+ukmPKo2ogzpCEAldc1Dc1woW7tpuQuSq9cK7b23r0eUL5MumNYwilEayWyuwaC9xuzvRZZ6Qon8MEh8un7UmJO6FFY9Ks2ALKgoQJX5kmkr4W/UlTKcywlMcQ/cizi++rhz1n/NQlxbXr1O8C1xfgT/sllU+598zztk9JW6NIuo4QMcym/E0+IN1FOJY8b9WRaxIUCqoLVv/bAP18ZQ6w59kEYWBt3yMCR4TP99cVkjiGB4vxhVuiiFYaihFLFUZBgyDqDcuRBkfm36FsKci7qxE2MXrV9ovIjEAZtFmILnExm6qcfodEXzDRUG6Bgyu1CdXNrSpepXvv6u1Ivqqezfcb0yKGTeCQasdnvr1jmQyARh1LqTI11s3Ln8IEpZMzcQIxrJ17xg+4On6EWWXlJg3i5c
 8PFie75v
 BsdR6572tnjnI6rmS2WNgCs0zvp/GXEcjyFWHUyQCXvK+AOeRH8EyVGtMDfJsV1jy1nic9PgJ6HvFlTDQhYhFJa3GlsZjCHctVAZuVWFQbgFRMOMXX3mq35n3v2jyqXmtZDuBo0YWx6OPeaA386lMlHppGmVQyr3s6LO84emocjI9T0Lz3+Xy43Y1j9DLqGUFpMHwzHNdIxfi9MvKmWHp/8IEKBraRSF4oN5i/gW1YcY0pM8Gntw882VDOc0CiqgugkL2v6VQ2kge1osajrXomJVqpt3ouetaAipIzdGyTc8s48H5SOX13xTuALfaC3WhZPSJP+sxLwOV3Q8SPBaSGhwrEkxvvFx1x3iXp/tXppLpDUJzg3xZGMFHDbZ95xLbm95i3eo96V1iTyZ1+dTDltxKi5oUlrOSmjoWwkKZYQOOr89N7HAD2IkAuBb9phqLOea7wMmHRIWi/dM8U3RTdk8YKEhxhStV71GyikNb5yEn0NrlfpQDTHiL4HeHEEIzuKpdm6LrMKeY9QekFw0gWCxamwhPZEQINlMXyWPHp9hAVTTk8/2OoiN6rbHKPhw8tzDGxzppcNJLajU86p0YQRQ43OOEqkkzf/8AEtvjfodO+KdSx+yf9uJYR8WvQdcEswUPilZVjv5A7mDhhgMVG/nt5eGbV0yhWEyRZl+5zgfYUf9mg+GtycB5WU3wRf1G2God0czVfZ2hkkR9aDJKEBLJFBzJE3HIojQibJM5J+jP8+5EOmI7OEgS9A==
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
index bffef6b903e1..0a426475a9fb 100644
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
index 26cd2a8bd0cd..dad7f02365d3 100644
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
+	phys_addr_t start, end;
+	u64 i;
 
-	walk_system_ram_res(0, -1, &nr_ranges, get_nr_ram_ranges_callback);
+	for_each_mem_range(i, &start, &end)
+		nr_ranges++;
 
 	return nr_ranges;
 }
 
-static int prepare_elf64_ram_headers_callback(struct resource *res, void *arg)
+int arch_crash_populate_cmem(struct crash_mem *cmem)
 {
-	struct crash_mem *cmem = arg;
+	phys_addr_t start, end;
+	u64 i;
 
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


