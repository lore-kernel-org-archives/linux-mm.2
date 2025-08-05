Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AA6C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888028E0003; Tue,  5 Aug 2025 02:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FD58E0001; Tue,  5 Aug 2025 02:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775E68E0003; Tue,  5 Aug 2025 02:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6751D8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:24:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 362B4823FC
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:24:09 +0000 (UTC)
X-FDA: 83741713818.17.E4BD953
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6CB33100002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:24:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cbvTCB/E";
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754375047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+hY2uT3rtX0jxqTDwr4o0wnNu5PQr3WJ9i3CgsATwQ=;
	b=vkFikTFRTJEAQXY1lRpzerZkCfmx6CehKHwgaSGxn7TwZrLYPQS3qxbZ8Dhvbof1vJDp05
	FrSooIKPhguhxGPcHBOMNEjqNtGshjrdtaBMiLPzNeMxbQ38B/0n+Xi2ofc4gvir7Ymu1V
	yyT3nRkdJWyCi2lHDflEqTnHtY2q4r8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754375047; a=rsa-sha256;
	cv=none;
	b=LUlE3EV382wYn2kIJZcTJ6fRd37QBPcRm3xqbMv2n0yEw8c25ckycfs01fZeQH1aVp0487
	sKjNYNtzsEDD+p3Fk0BKJecCzCWN9OUQsqJp6tu/jFFgyDIzlWTl6kC5T2/PB7rLaUrk8u
	eEN4yL4/fEsMQYY05kbWnt3wS/Qpslo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cbvTCB/E";
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754375046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c+hY2uT3rtX0jxqTDwr4o0wnNu5PQr3WJ9i3CgsATwQ=;
	b=cbvTCB/EDbbtLRWrbNLKpb67tA/vrRqvxGQPnL/erqIeZH6w7Lo+z6ok7j8zY7lvLGl3EN
	R1lm7xU42kYCplSgTzTltfn9+IDOADew3TWwdsJmgz4t3qSn1DXX2QSewqjwCHk9DH/Qha
	1S10H/Q6Km9iYZxkDkoGtyWqQn3wVhg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-zuByUt8SMlOb-KzlFOuhUA-1; Tue,
 05 Aug 2025 02:24:03 -0400
X-MC-Unique: zuByUt8SMlOb-KzlFOuhUA-1
X-Mimecast-MFC-AGG-ID: zuByUt8SMlOb-KzlFOuhUA_1754375041
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C4B71800366;
	Tue,  5 Aug 2025 06:24:01 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.136])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 55DDF1956094;
	Tue,  5 Aug 2025 06:23:55 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 3/4] mm/kasan: don't initialize kasan if it's disabled
Date: Tue,  5 Aug 2025 14:23:32 +0800
Message-ID: <20250805062333.121553-4-bhe@redhat.com>
In-Reply-To: <20250805062333.121553-1-bhe@redhat.com>
References: <20250805062333.121553-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 6CB33100002
X-Stat-Signature: gqtfrhc7o8g5ucgu1yrzn6k6tewn8gfi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754375047-750651
X-HE-Meta: U2FsdGVkX1+vRoqG05isGxtYLuZQQoODK+YrTsE3wHb35SpBbCdnYIt1Myli50EWLgF2QHuVSXAI+c+QdRW8bqfsHm7VDlOczkXnJmWymWBqksF1fceh687Tn51hOsm7XZP/CEUsxDk6hq4PdSt07m+Toqr1+a5+EEFbxHhH0+YpIYXW/JAwIla91qKER2+tb3/XSUP/admYxfXVkRO7AIdTORPzGLEkWle/aCjuL+DJLuXObAhrIGorpbk7PzGa9tVk7xm9wSaLlnKDnkqnAL5vxgk1zyauaE/OCn5RfNTZ/UFpArtx+amBJjNFJG8xxzGVTF3pVa87YhJFU53geSGFbwqqq3GUPAWy28w9qCI57Ew1S5XC+Li51Kvv4tdhzDHamchaPM24kF/xIrzzJAPBc+AqpgVnp3ZLzfvxTFN+AvYBOxkngqzCy0jm70Rgcen4k1RDVL/7dVobozyEZEge8gPRBmhWtJtX6RZtazNtOLQEGl5Dgn/JBP842z3tK7VEJKhjhFFK/j2tzsm0gFnK4vvfY1jJNQlpLGO0VSLA7ZaPI3yYlYR9oELMQrGVd9lfnViOZUonlCP57Gt0hB89ljmlBid7USb5JgMe3+ibFi42NViD73egOBgNIpf56dqmqLhK3AzIyzd+2W4J06m6xFIjyl3UCzw0zVphMQXycEUz4AT6jnXhjekw6IhJW5iCJB4LAQNZY9XZ6FvX9J7KpIetojuOPPWiC5tJUPP+kpUuyMNkejhJSMpZl4VqsLrckkH8wwBGhi2fSjJZ84PkRZ4tEK9QgE+fJBVKNTZnrAZoAGti9OELEK+JSjgafhSyyIYIL7x6oW3lcxIGEfz1k1f/S3q8sSrf25BdAzl6Axsb0hSFlqHZ8fH3QeYQmkH4LUnnjcwkiBiMpVTF1pgU7CgdHFMIDICEkKTCXaE3yBg9szP82bn/liEK/GDGX8b+adPXK7XqlTVNrtg
 kJGwEove
 reQ1hEFk1pw/DW9/jN5IVRnYcwes5ljEC6CYBuheV7IGNRjc+JkUyQtklNSY/rb6kbvLBj4naZRlq1OKPDfXxh3tyRma4wiQszhvNHWkWIaXKeoU3QvbnnreY9ZnMi2OaQD9SKbL3S7LSMW1Hw6bgt0+ocZJJOROEJhHMcc9bWFBGsA5WC4E7Mj1A41Ug1p/LisM/sRklXtjtH8seUwxAge0EEe8BP1uZQkyCI6VgfND7kZSR2ppK+QaxsoYjDCXhX4zytk4XO+GWJ+0bxbj3x+665wRdtsYbLOKMQ2mTS5hNiWQVlwTbgEDf/oPHaXqO+6SE4ZnRLsZHDJbBoNLEH6WuLU4F7HF486U3ODFe+2SMk4qtrmdPULLzCshQ2GsNBAoZI13iJJciSETbtpJawxmxpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is mainly done in all architectures which support kasan, and also
need be done in sw_tags init funciton kasan_init_sw_tags().

And also add code to enable kasan_flag_enabled, this is for later usage.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/arm/mm/kasan_init.c               | 6 ++++++
 arch/arm64/mm/kasan_init.c             | 7 +++++++
 arch/loongarch/mm/kasan_init.c         | 5 +++++
 arch/powerpc/mm/kasan/init_32.c        | 8 +++++++-
 arch/powerpc/mm/kasan/init_book3e_64.c | 6 ++++++
 arch/powerpc/mm/kasan/init_book3s_64.c | 6 ++++++
 arch/riscv/mm/kasan_init.c             | 6 ++++++
 arch/um/kernel/mem.c                   | 6 ++++++
 arch/x86/mm/kasan_init_64.c            | 6 ++++++
 arch/xtensa/mm/kasan_init.c            | 6 ++++++
 mm/kasan/sw_tags.c                     | 6 ++++++
 11 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 111d4f703136..c764e1b9c9c5 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -212,6 +212,8 @@ void __init kasan_init(void)
 	phys_addr_t pa_start, pa_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * We are going to perform proper setup of shadow memory.
 	 *
@@ -300,6 +302,10 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
+
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("Kernel address sanitizer initialized\n");
 	init_task.kasan_depth = 0;
 }
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index d541ce45daeb..0e4ffe3f5d0e 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -384,6 +384,9 @@ void __init kasan_populate_early_vm_area_shadow(void *start, unsigned long size)
 {
 	unsigned long shadow_start, shadow_end;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
@@ -397,6 +400,9 @@ void __init kasan_populate_early_vm_area_shadow(void *start, unsigned long size)
 
 void __init kasan_init(void)
 {
+	if (kasan_arg_disabled)
+		return;
+
 	kasan_init_shadow();
 	kasan_init_depth();
 #if defined(CONFIG_KASAN_GENERIC)
@@ -405,6 +411,7 @@ void __init kasan_init(void)
 	 * Software and Hardware Tag-Based modes still require
 	 * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
 	 */
+	static_branch_enable(&kasan_flag_enabled);
 	pr_info("KernelAddressSanitizer initialized (generic)\n");
 #endif
 }
diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index d2681272d8f0..0c32eee6910f 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -267,6 +267,8 @@ void __init kasan_init(void)
 	u64 i;
 	phys_addr_t pa_start, pa_end;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * If PGDIR_SIZE is too large for cpu_vabits, KASAN_SHADOW_END will
 	 * overflow UINTPTR_MAX and then looks like a user space address.
@@ -327,6 +329,9 @@ void __init kasan_init(void)
 	csr_write64(__pa_symbol(swapper_pg_dir), LOONGARCH_CSR_PGDH);
 	local_flush_tlb_all();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized.\n");
diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/init_32.c
index 03666d790a53..b0c465f3fbf5 100644
--- a/arch/powerpc/mm/kasan/init_32.c
+++ b/arch/powerpc/mm/kasan/init_32.c
@@ -141,6 +141,9 @@ void __init kasan_init(void)
 	u64 i;
 	int ret;
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &base, &end) {
 		phys_addr_t top = min(end, total_lowmem);
 
@@ -163,6 +166,9 @@ void __init kasan_init(void)
 
 	clear_page(kasan_early_shadow_page);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
@@ -170,7 +176,7 @@ void __init kasan_init(void)
 
 void __init kasan_late_init(void)
 {
-	if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
+	if (IS_ENABLED(CONFIG_KASAN_VMALLOC) && kasan_enabled())
 		kasan_unmap_early_shadow_vmalloc();
 }
 
diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
index 60c78aac0f63..1e1c10467a2b 100644
--- a/arch/powerpc/mm/kasan/init_book3e_64.c
+++ b/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -111,6 +111,9 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL_RO);
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &start, &end)
 		kasan_init_phys_region(phys_to_virt(start), phys_to_virt(end));
 
@@ -125,6 +128,9 @@ void __init kasan_init(void)
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
index 7d959544c077..9c5cf2354c8b 100644
--- a/arch/powerpc/mm/kasan/init_book3s_64.c
+++ b/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -56,6 +56,9 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL);
 
+	if (kasan_arg_disabled)
+		return;
+
 	if (!early_radix_enabled()) {
 		pr_warn("KASAN not enabled as it requires radix!");
 		return;
@@ -94,6 +97,9 @@ void __init kasan_init(void)
 
 	static_branch_inc(&powerpc_kasan_enabled_key);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 41c635d6aca4..ac3ac227c765 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -485,6 +485,9 @@ void __init kasan_init(void)
 	phys_addr_t p_start, p_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	create_tmp_mapping();
 	csr_write(CSR_SATP, PFN_DOWN(__pa(tmp_pg_dir)) | satp_mode);
 
@@ -531,6 +534,9 @@ void __init kasan_init(void)
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
 }
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 76bec7de81b5..6961841daa12 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -26,6 +26,9 @@
 int kasan_um_is_ready;
 void kasan_init(void)
 {
+
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * kasan_map_memory will map all of the required address space and
 	 * the host machine will allocate physical memory as necessary.
@@ -33,6 +36,9 @@ void kasan_init(void)
 	kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
 	init_task.kasan_depth = 0;
 	kasan_um_is_ready = true;
+
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
 }
 
 static void (*kasan_init_ptr)(void)
diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 0539efd0d216..d7e8c59da435 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -343,6 +343,9 @@ void __init kasan_init(void)
 	unsigned long shadow_cea_begin, shadow_cea_per_cpu_begin, shadow_cea_end;
 	int i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	memcpy(early_top_pgt, init_top_pgt, sizeof(early_top_pgt));
 
 	/*
@@ -450,6 +453,9 @@ void __init kasan_init(void)
 	/* Flush TLBs again to be sure that write protection applied. */
 	__flush_tlb_all();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized\n");
 }
diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
index f39c4d83173a..4a7b77f47225 100644
--- a/arch/xtensa/mm/kasan_init.c
+++ b/arch/xtensa/mm/kasan_init.c
@@ -70,6 +70,9 @@ void __init kasan_init(void)
 {
 	int i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	BUILD_BUG_ON(KASAN_SHADOW_OFFSET != KASAN_SHADOW_START -
 		     (KASAN_START_VADDR >> KASAN_SHADOW_SCALE_SHIFT));
 	BUILD_BUG_ON(VMALLOC_START < KASAN_START_VADDR);
@@ -92,6 +95,9 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages. */
 	current->kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized\n");
diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
index 01f19bc4a326..dd963ba4d143 100644
--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -40,11 +40,17 @@ void __init kasan_init_sw_tags(void)
 {
 	int cpu;
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_possible_cpu(cpu)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
 	kasan_init_tags();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("KernelAddressSanitizer initialized (sw-tags, stacktrace=%s)\n",
 		str_on_off(kasan_stack_collection_enabled()));
 }
-- 
2.41.0


