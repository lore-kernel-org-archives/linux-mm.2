Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4751DCCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBAC6B008C; Thu, 15 Oct 2026 23:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2436B0092; Thu, 15 Oct 2026 23:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0D96B0098; Thu, 15 Oct 2026 23:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 246486B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:09:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 268F31A029B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:09:40 +0000 (UTC)
X-FDA: 85327009320.14.BCC8E6A
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5B7B920009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:09:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NpJw81OU;
	spf=pass (imf13.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
	b=XJagIRtsXExtkim2kpD2YJTgvZUwjoRxJB1wMQxWbeFUpmJWeGpdD8NwqtL7QoW8t4pYe3
	rUwXf8OjLAsIWr8nmPsFHWjXsk4Vnp8WfcfGCMxjH2XhTB5AUmkzXRcbGpnaO4tpD8MrvO
	Fx0TfNFSzEcOEsyLS5FjVhRY4Sy0S8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120178;
	b=G1TEzC9t4a2CQIoqXaKmP1v8wTwQs25O4569ezWBwHSgEIweNMMvllBN8sx3U9Ji73zEcD
	o+xAPqCXeowBi4G9cBDh60EHXlKrj7Gw02bCf95m9A2ykg21/uyj/qNUknd3I2+SC/7gCs
	g5F80y/fbQ6SauNuRUEi48efvlHoq1Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NpJw81OU;
	spf=pass (imf13.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3ab37ea4798so1983253a91.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792120177; x=1792724977; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
        b=NpJw81OU25EDEjSS9uh2BnlJQDC8baCFphwf2jyovM6yjck1LmQayATYU6rMYsstCx
         ybofnhOkzzGOdSZVmNCuRd/ClKT62l/0dEAudpZi2wR8L8jJw4snCa/G6KkyGJAVaTq9
         c1H7eqieFgTftqm2TIk3UQwYcISC7209Icw+1V4EAHj6CpPue5P7pUsQ3NzGu+jBFrmp
         XmLoz8LkwO4VtFtkp6BBfesjiH/QujbQfSbD8bLqwwTv4LLSXO74OP46LffyqBFJklIp
         CCBARZVfFCtO3M3UuQbxlMJ7EkQouofNjNaSUOTNMhjkAZ5sJzu6XP2ZURG+ldLaoIyR
         QNnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120177; x=1792724977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
        b=VGCfV8muD1pTr2km+Q7trFkHJ7kFHRK9gqu1UB1IUPJfvXbV0855BymUGSUNTTGXvz
         gHrCEZD6G40kBaD6gY6uX1LUYy3PoW5THiwbTBvkiV4FdyxV5qN0WJrBlAbySyAyrcL2
         llHFtYEvta/ubKswOo2bbZc1RSG1JNgmj/uvW6EYi7TENqBQ3OSM/Qs+09hyq+OLobR2
         FVG6E5vbxd25ZF51MiMWkEmLSS2WvbXEW10E3TH6Ug5KyZPPCsR9EzPtFmcuOP6g7a3i
         erv753F64zUrMKJbcHzgEsK/ddvb4liAhp8x+xqI7sfgZdXsDEmFFtB91L/K5Y27nXaa
         Bvew==
X-Forwarded-Encrypted: i=1; AKwUvBxVRhr3A+ezXp0/7J9GbYrg6laARIxUFf4fTUB7Y1z/6Dd/VF3rw3XAB7sn1Py6EXs83puo9ys36g==@kvack.org
X-Gm-Message-State: AFq9FYJGst0OFNBo2nT07gGg/1pRjBqKG2+EaLCDwN0IP/qyByfazDl+
	klb3NhnyirKCqAiCzWWIWmJ8eX+L5sZJyP+9NPxUlIzll08lQMaAGiVT
X-Gm-Gg: AYBFou0XQoLNocjXnlXQiM3It46AFZH3r0KBuMh1xwPJYAvR2qYruVIVIe7QAeNo/uk
	wO2eTnr27qAsgEjnuDENHaQkUg3NNEDt8XklPNUq8eJVJfcVm5MhcwwE5cBNhZzLLOPZOm2qQNB
	WoYZg+qfs4JzY3qRtvQRNLU7pkPY2Krj5yjijjYOKCBVbZQLvcn5kN1q5mzBul6rxOBwEGDXh+/
	TXbnrgqBZPNgpcQqqKcLeMqQr7r+MKCJOlIXstig8kAr65ZCGzeWjyNXsWoVFvULkg8eOejHWHI
	uvN1VgmA6Y9K63kl2d7DJDZ1ePysBntuHWMuxQLQWUaP3+INo46YMJnqkEjCWMeJzjxgYLpJb5P
	nZO1dJ7Htefc/GG0GJmXDl0X7Hd/e65cETEKBPqwkoGLrDK0m3oivec33G0LyX8zoo7myo12SEv
	NrODtN3e258+B0GaVLi1vnlUGD5mOaSydHWA1RmNiT/OvqzwM/bgHibg68/xqgv1PrS7RQbOq3w
	74Z70oYVAI=
X-Received: by 2002:a17:90b:3c0d:b0:3ab:b39f:41da with SMTP id 98e67ed59e1d1-3abb39f450amr14169913a91.11.1792120177160;
        Thu, 15 Oct 2026 20:09:37 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm370085a91.4.2026.10.15.20.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:09:36 -0700 (PDT)
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
Subject: [PATCH v8 2/8] crash_core: fold duplicated memblock arch hooks into the weak default
Date: Fri, 16 Oct 2026 11:08:49 +0800
Message-ID: <20261016030855.4062882-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016030855.4062882-1-chenwandun1@gmail.com>
References: <20261016030855.4062882-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5B7B920009
X-Rspam-User: 
X-Stat-Signature: tnsw99n7a57r5ajbm4xrsp1uuumgqr4j
X-HE-Tag: 1792120178-303237
X-HE-Meta: U2FsdGVkX18Nuip6/2lOkFe2d0ciLgwJ1qnvAZtedJWpE/CLF5JkYk/znTPLbLVViv7n4i0C1/Zn6SaspcOe4q8iqmJA6sTihOoDRqzVR2HMojkKpkZYYx9I11FNjoRMeeGUqi0kXM419D6+azvkziWsFfowFniRS8C37S3c0zqgjVWg7Zo8EjYydMx5wlyTNX+k4Fv6JPz4O+VKC5bzHQU4mgz7lSU/YkjBeWK7qS5dwvV7hsD/F/gnk2Afgh/4ALyTC4fbsas16LcSQAcQC/DaSHK5xDGUdR+judyjYvH9oPVSX81LIJiMswRfhLZ8xJHyA1d4EDjj8Zn3i5lqh35jxzX3iAMyKwA/UZIfLG/+cYcq2Ed5nyUv5w7VhaxzEzjGlz2GqPT0BlivIbJYU02evI2ZSUBd0PMxGSdXFKO+FTZFBjpB5royDQAZLAjj8K2fW9anHgN6mE5jfMD7PehydIBNgg8hkqtlQqeVAWPQPQAuLsYFQCsHo2jig1A+CjViCP3yh829KKfkm6iNAha+febe6hcdV2bBlPsem08kibswEnMR3DDgxr/FfwhbG6d30yzTSqjjfUZsUrqrk6FcaH8C1xds4BXNU9C2lZz2ToYwgAkD4lrSDQbFoP2Tmn0hcqHpboJsJcJU6vL506O5KrYiTkZ4Pw3Nn11OBacodZHjlfCw/8irwELYVWuKG8uydpOHZuF7xYK4m6LB5sGiaz8U11e9HPcmDCyMA23EhowH+d96l/IL+XAnM0Rayj1GPRF0YFvdifNm1krqq3mNRbWn9tPDvrz9blXUCJ0erpUKuAWmldSr199QPSjiRd4ZRs9Ur49nqKOdoYUqLtj5g2lQw8t9swdV1d5nQKlYpYahxLlEKS0cwdgWscC6F0IEsdt5GvP5s/ArZzWd18N/dqTZS82miBfopTPepb8FYX0qT4W3n9SN1xwtZoeyllKED5rWHfWfLnNUk8R
 pqZcD6cq
 EF0a65hQBodOWe3lgBVBHpIbRY1W0zcqzkjDhwxKr08rqDWgKKOBer0QiR4nNf81eeYNsRrEAmQgZdI8XcqHRLaTAFfrYu4RVeRW8p6SOUEWsz3U534xF40lig2uVhF0bkFz4NH+zJqDuD0NQqhanbhpis8m40s+8IvKM1KYyNFB01VRZgEEj+y+95iBuZ/gIVg4IQ8rWipbmSH9vwjitVE52NY9+NAzzqJWmaXk0H0BYoD3yepTjMVRygf/i79dvmEKpu0K17TwDW1j9A359OsHLbsSN78HcrCpBgZb5OAm5xJCR/x2e9Obwqm2u5SrSEieEU0P+r11sFwHYr9vzd8TDmXKXim7UtXwbb422LefGC+tug3o9nbb/EcdDj+rLNvJYU0MoHN/aNu6Y5S6flg6gH2G2YLpMonziJUBn8sGP7wYfRvBHhrdaPEMPEx29+cKBdqDlY4Z1XzWh9FcesFccYQ6RFMcwXFC4qjewI+zmAVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


