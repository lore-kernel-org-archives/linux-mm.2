Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF724606A327
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TX1Hz7Qu
Received: by kanga.kvack.org (Postfix)
	id CF51B6B05C8; Fri, 27 Nov 2026 04:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC936B05C9; Fri, 27 Nov 2026 04:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2616B05CA; Fri, 27 Nov 2026 04:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99E1B6B05C8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:08:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37E1F1C2BBB
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:09 +0000 (UTC)
X-FDA: 85480322298.13.F39106A
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5BD471C0004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TX1Hz7Qu;
	spf=pass (imf21.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770487;
	b=3iNuRnNql1A9ilgu2CUYRNY9pUKWQUG2VPHdFuRXAWqcyv2ManmU9NDnJ8mcCdUWx7zale
	L7x1a0pboBIljgOlvVl8yKDCq+AMLpihOwmMWnSTL6mljDFSnBcB3E4Dr5UX6EAQXzox4I
	PTCX7kRGVHdeG2iFrPb6xV4wYuxdsic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Yac15kv4zUJMw/dFjjqld9TLsvrPI7GRE4h7XfVDwk=;
	b=cyw1e108nB/ucg+y88bHWTKXKJijPdAhSUPWrgC8A6CxJ/J6JcFJhFJ+PIkUOGknUFnD1Q
	kWtiD6FKi3ilS9tizyo/tbdwdDHaojxY96uoLrhVkV7ehxGOPxgKtOlyNCbWuDKr6qLnR9
	XH+2qGvp8KFZHxQXn3kqB2xmkELdIn4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TX1Hz7Qu;
	spf=pass (imf21.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f0.google.com with SMTP id d9443c01a7336-2efd15c7545so26514245ad.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770486; x=1796375286; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9Yac15kv4zUJMw/dFjjqld9TLsvrPI7GRE4h7XfVDwk=;
        b=TX1Hz7QuSG7V+RMLxmqZqH2eF5FYS5ZkqPaY42EU2DjFa2g1uZvjHykwi6MQl2DmWP
         9F8gHIwzhlPO3bNNVPqMZEPJoeKxXvOYaMSOc46gV8Fm6F9V2GOyVIOroI2zhQpCiSX8
         pHx6KMxk0RUWDJmOq3EregvpRSNwnaxTtWTRD8pZFZ9Sn7s5SgJYb6cpNeJv+xr7IWXy
         FR1/9H1eZ8WOVXKs1DTPvBDJM22YkLeetGnJI0szH21q8vloEVxqp2oZosiAF0+eu7Me
         8uNVY0fXGxs+B2iuhzERDKDiONS7JmdJ8LBsGGwL3Il3uKZ6opuWr46svMnxm0UPg5Ah
         /DJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770486; x=1796375286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9Yac15kv4zUJMw/dFjjqld9TLsvrPI7GRE4h7XfVDwk=;
        b=svXw/h5TrvuH0Gofa4m+Mpngo26JavsbUZfhfYTRYHzVEjachx21TaBO9+ee/cf9Tm
         nKufeJuIbkPh7A7O0mSOvCRlyENpfvwlGnmPaKU9RC0txglKE/rr/qX76+NrLCcqPkzH
         wHyvw09idEOi6EXxyzcxhA9LQwwAiuhWdG6JKTJj+9fQ1ipF+YeqLCNsd9QJGXqwWaN7
         5yLesN3LTFUNV94/uIFXMYZ2SuElKAATrMUR604u39g5NDfYpx7NkE2vCe08Z1xV+8Sp
         36fqwv6uzahHYC/4Psc2XIC6l2+CFM/5deZsTRUy/81FCtViOSheetEzsA3sMzH26uDV
         8s9w==
X-Forwarded-Encrypted: i=1; AL+hErH31nkZJA22+UYClHJa7K3c8kgSdvflP2uyJgJEaqpmlKd5l9YtqbbGsWo5pPfUo39sN6sVBCsSIA==@kvack.org
X-Gm-Message-State: APuU4Z+1fSieMYYdGawOTXz6QnOPbodaP7JPGcYSmPGY4TgG3ZhUaErd
	E6jHlfveep0ZJpCQmw6uWE1O7iisfalV7hd/yKyJ3htXOAlIuOWNTKIE
X-Gm-Gg: AZFdTZc0pVjiboDSYe5r1HA752EfYFStFFnxOPvX4J59seQQJQdd8soXshHjgL8nzpy
	weyNj6XpuZfkspUNCpT1zgVKadsYuz2+GTg2rDu62+TFcUxM70u8McwySMgcmryhe8I6znSmwXu
	VKM/650SjJkX1nQtOQOeqh22RG4bTnA5n73V6I9sIRf3zRt8uXVDxjBnwMkl8UMghVxp8MapZBG
	91MxhfLbQWcAEaLaOckv7Ukk/Mq4UK+DzpsQnVsFU3yHBIHSahFjQuySTSYpci2aG5709SlXMCc
	8YduD7msCoSkLYtfzP2fTE5k8ETui5JXDJl/jDO+n2Oo3zt6hu/PMWcRVkNI7+AVvFnMOnLnzuC
	8Fsd6n5PNTg2E+gLpizWzn3kVOI3ESu5r+UWKy9kNJMES9EzYaXhBtRN/DUapy65mb+eWbilb8C
	GNAcBkTX4ev17VELCy3+RbKjvgh6Mwu772D9ZiPVqfJTMLgZSQAbF9AkbEtRwk+EmF8SOYR9EAA
	1jGQTI8JUxqCSG4JuYvgpunubBh3CjEcArZ+I84+joYEKNQ+IDFS5w/rqhLQq9jlZPM6y1/2xqy
	Kob/ozUUMl2/AxrZLXAbGRFp1bo4xaXYrlISCTjaPQ==
X-Received: by 2002:a05:6a21:8803:b0:3f9:292e:775d with SMTP id adf61e73a8af0-4014bc4b4abmr19459218637.49.1795770485952;
        Fri, 27 Nov 2026 01:08:05 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:08:05 -0800 (PST)
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
Subject: [PATCH v10 2/8] crash_core: fold duplicated memblock arch hooks into the weak default
Date: Fri, 27 Nov 2026 17:07:17 +0800
Message-ID: <20261127090723.741253-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127090723.741253-1-chenwandun1@gmail.com>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 5BD471C0004
X-Stat-Signature: 74qazu7butewjrd9hfwepfbahgxphnca
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795770487-139725
X-HE-Meta: U2FsdGVkX1+utf/vxAHEduWUGCCleAd8F5e0t7WAqslX0cN4/l/okobYph3lNefDKhSHd9C1oX6VAd2UGT3JNRHkUQHzkWPvPcfjYceLpO0D9in8X//isw0lnS1xHR0IPP72qQvWllDm6qBj3VxiAAIwmF059wwwU95nm0rR5fmNOLRgwNBjFbbyXDHJq1EPHcZAEePoDrbkNIGvSye/TlzESCehg5gUIta7HlhYde+QcuaIfmpnR7Qi2vfgNm5PJpV+SS5X+Da2yG9Sdi6eY2N81zH75sNpsURkmN/QCTtOfODwATbqBPkL/AcRhoId1NwOI4M2N1ynhqFBne0N6jHLtRSd+WDv2dJCcrhA9VZvJAWjHkzEOP/fpb+X6iYk0zTJXLiXoVYn66XKpxLXruKQQ1sqyJd4iAvC2rqshiHXsu96pQulsLIeuPsjaLpwGJtbWb3BsjHxMBfeGOqXpMrLKBdvbV6k9WIhyo7HntSNwCJ4XwMsrPlhoxBjCkpLAyOuZ8LPxu34H1O/nWYWIrWMBrOWdqlNKfsRSIEN8kRQI69PtfLQrQP2abMJot03XixOh6M9SmCdanGjZvJXB6NzwSZOo5bhvA2G2PXOey2HNCqlSGyH3FaM2hnj6wlXWei0gmFJB3UF+5nrlcF2XezJmOXY4nBJlsJfYpan+nhbCsDookj3BFMTSpc/qV8gmpUMuiC/Gd6Tmp6l3YNXMUZpM9Ho5hNgO4PsCZqwFqAttcSDUv7iTiBSMq6MPYzU3h4Yz3p5AzuxVYHLjk01thZDeMsOD2kTxDDDJLHZoknX3NxW2a84S0kUFQHtvJChx0oLLgWrt3PRuJIXZreHOHVozksv3zpuOWKnFUQ/8opV52mhEmZPGlFWgMEjXhPg8WijZezd0XcY33EHYJ22tqoMNZICFInP3p+qgyw1IZHuvOoHZ4rulXr9nalMqOXRFouCtCVpJUulDNZ8ywa
 e1sLwvqZ
 vzWCbZiRcytSXm+ZgudQDjlCDvNoB9caGIicq6vnLBsOsMlVm5QhnY0vTGE8IUWJ7RfKndGS4bjs0A6p1LHMy9JQS5kkuOIcfn4lnUIS0prQNzXRhfsoSwWhDIR79R+a4YqPpkv89WboWsFNObNVi78mb2Qq9u6vecTTUpUOcN7htlKQzQCCCsaqk3R/EmjVk5pbfirmWVi0PNCtSr7WQfmcz3ksjB14aGcsDPeKEu1A/LLeLGznRaO8aVuCjZstoPAN6kCbU1ZVGMIyPoov4UZEw1PkgNz5WAvGIOtLksgwYoAlf90cSB2sOaunwF2gEdeHp0JhXcIjXGANyZRsl6IqBzOXg1HSahThhb9rCBNcbvyGitezZvXYc+9Ik0URQEqlOlCFU5bjdcBQXrbevQp4A3gUt19Jq41Qy/q0yK5Vm3DzXe1WFIqd3Hn0ECV6TmcBN+7yXOQaefNcsv57IypRKKaz/oM8RHIvdFavQrIkg9QiZHWeUbHsJj9HhJm5aZAjofrLx8ylV3lJ9i7i9CKlldj9Kr1UTSrqCaDOV/k8cdyL1+NRR34OTa2MpSh+VGCGTEp2q/HEwNHrLUpG8f4rmC05u+IWGIoG7G2TJnC4317dIDmUTjD8OMMNzf7WaDlnShcxj/smavrxW0B9UzS9ZoOWXzeHFr8+itCnP6ixr/w1i+XkjO0AwmdFFrmgpsaM4ltOsgrCAnJj8R6HX764BjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

arm64, loongarch and riscv open-code the same memblock walk in
arch_get_system_nr_ranges() and arch_crash_populate_cmem(). Move it into
the __weak defaults in kernel/crash_core.c and delete the arch copies.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 arch/arm64/kernel/machine_kexec_file.c     | 29 ----------------------
 arch/loongarch/kernel/machine_kexec_file.c | 27 --------------------
 arch/riscv/kernel/machine_kexec_file.c     | 26 -------------------
 kernel/crash_core.c                        | 27 ++++++++++++++++++++
 4 files changed, 27 insertions(+), 82 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 14f453dd0946..18695f01043c 100644
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
index 0fe60907b97f..bef459287683 100644
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
index dad7f02365d3..fdc6695e8588 100644
--- a/arch/riscv/kernel/machine_kexec_file.c
+++ b/arch/riscv/kernel/machine_kexec_file.c
@@ -37,32 +37,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 }
 
 #ifdef CONFIG_CRASH_DUMP
-unsigned int arch_get_system_nr_ranges(void)
-{
-	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
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
-
 static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
 				 unsigned long cmdline_len)
 {
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index d0bd2d0cf899..faa0f22dbb41 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -281,8 +281,35 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 	return cmem;
 }
 
+#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
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
+#else
 unsigned int __weak arch_get_system_nr_ranges(void) { return 0; }
 int __weak arch_crash_populate_cmem(struct crash_mem *cmem) { return -1; }
+#endif
+
 int __weak arch_crash_exclude_ranges(struct crash_mem *cmem) { return 0; }
 
 int __weak arch_crash_exclude_mem_range(struct crash_mem **mem,
-- 
2.43.0


