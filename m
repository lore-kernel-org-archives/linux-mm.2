Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 492A4C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C3F6B00A6; Tue, 22 Sep 2026 04:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DED76B00A7; Tue, 22 Sep 2026 04:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A966B00AA; Tue, 22 Sep 2026 04:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6246B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CAC71C0669
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:38 +0000 (UTC)
X-FDA: 85240759716.07.79C521B
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9106A20004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kg3wndmL;
	spf=pass (imf13.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnVDZ+yI4npNCIQQqlxZwSFoW6YUe6LE24tWXfIE9sY=;
	b=fbxqevmzvvch6VS0bFdteeBgjpj6/N0eWAP92BvLg0lhkwuKgxGSiZBnk9mStBkWaq+fUf
	1dEKc8p7uuL87lgvQ3Htil+LcdOCVQv70ZIs+PgfwaAUHqWQYvSxVUrQ/EmSLI2bbbb1FY
	HcRZAYnJL/sdD6n8gXOoztOMkozw68A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kg3wndmL;
	spf=pass (imf13.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066616;
	b=5u5wkbLXPW5hclo7uSH7h3BENI5pjBNaK8O6cxM34sD0ZcTgbWbiJLgfwL5Q09fTC1u0Kh
	y28ECJsaU1ZDD09vcHD4Yq8ASQZX2GTgDR4qpN8ttmDWXpXcurtenjQ+xtqpK32E2P3mxA
	rRo+n6gxOvwlzIoHqPS/u4vccuMOh+g=
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-398b9f722abso2011200a91.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066615; x=1790671415; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KnVDZ+yI4npNCIQQqlxZwSFoW6YUe6LE24tWXfIE9sY=;
        b=kg3wndmLWD5xfq1d9lwXHENBPCv1S00am4mSlSNdnXPRJlrUAqSLlTfwyiPGz4f1x8
         bbCt5/gGT/J+suj8IsiAuWO1QohU53p1sDu2++euMrjw9VS1aKVsGrkCjERe1InEFRzD
         q6Bav5xJqcCWXAfg6YbPEX7pnSAitj4yyY6/ar4/txojZ0AA9G/UleuBg3ppYdETMkKW
         3KMowKwbXIBJrtFY8VZ+r+yU7RlGlRxNxZRn6fMWDb+ivOYpn8rdwKqMcIzPVTe3FlbG
         hAyFd8jVhEWI4kTv+27Pl2qYNRU2OsYogJQJJRu4+XMLDNbhvI/QtEiTjWO9HnX+Qx1I
         QlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066615; x=1790671415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KnVDZ+yI4npNCIQQqlxZwSFoW6YUe6LE24tWXfIE9sY=;
        b=UEXJTtJHp5Uo/us+PezhcZVD04tzDvF5Bg29QLvPIbx/W9TBCvDtcCuifFFUonaVNN
         c+ljFLmXPSB4GaJDLVWV2nJv7N46QRArzgqoRJgAAKeqZLGBo3GA7/0nPHc5tW9MZJxh
         3gXr++QUIuyKyc4yoV6XYUgAdGBQ0rf5Hg3p1DvnHLwPLACx49Z5iHYRTVyXKM91ZAlJ
         86HAbkTxHzKpMkyJAyXce1o/VqZb3zXyf4Irjz+BKeKxwxN7+7r19TOMcNIOYt2hBbPj
         sLRlB9DwRui1XsaOMPxlx/rYTdZuRLUqvungxP0YxBmtjBqtZ5uL+FKZju9TvPvLeuVC
         5K3A==
X-Forwarded-Encrypted: i=1; AKwUvBz1L83FBuxA3P7Qa50U1nd70bQ7dfyQ+6xJGqARVXpSPLvetIBEZ/rOcQGHFNFTCTnSGb/OY2/6Bw==@kvack.org
X-Gm-Message-State: AFuF++kTVyI5zwkVOt5SW6C7VlUvdRbOEDMrh/r2AnAs1+9xC7Se9uRR
	ag5nUkZcrd7hgIa1BZgiGNs5jKtq72zVvFZy98g3hHMGDioQ2jfVQGfP
X-Gm-Gg: AYBFou29fWo2PM1TgCFgvPwA+3mgjTxHKcxP6qtKeXqcMnTeEku8eqUiV2xDxgBwnk9
	Ehs3Gc7PrAkqEWrP+okSSsGiMhcutNRig5hG4WfHbBO/5jY1IEoYME8vqPB7i0nTd6BDsKJjY0V
	ZbRKogBmqhyajJ2C+powFF09K9662lXdtkWIJzVriHw8IvXh8KhZTf1WV9h7bQ7rIFTGloOVQxJ
	s/9tSpl9IDCGb2yVeyTWz/TSCv4mqe5EYDHiQ61kuOTI3B5p//yA+vWsejPGK03yg9Uc7Na3GB4
	N/QgRTtcwntqBVeR7gIN9VOUuAQv9XbnswfSBsHXp9IG23LUlKGz6Vp+z7r9TUwjU1QYCzynv7/
	UCkJVBgkS28065NBZRvA2ZGzQAoqJkx74qAWLmt7+GtCkFpbJzMfLQy0xPTPhFKwRt1dx0gfWbk
	91hABooJeqKZIr7b+WCy6bDeN5vGW9e44I34L2/LG0K+m897vyVC6Ja+9CMFHfMAHBzbN48270S
	jiuFl4H/XDetArOJtBSNQ==
X-Received: by 2002:a17:90b:1a88:b0:39e:252:ae4d with SMTP id 98e67ed59e1d1-3a073112d3bmr471304a91.17.1790066615322;
        Tue, 22 Sep 2026 01:43:35 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:43:34 -0700 (PDT)
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
Subject: [PATCH v7 2/9] crash_core: fold duplicated memblock arch hooks into the weak default
Date: Tue, 22 Sep 2026 16:42:49 +0800
Message-ID: <20260922084256.1515554-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cnt5ienidrasawhwupzkw79pgjnntkgx
X-Rspamd-Queue-Id: 9106A20004
X-Rspamd-Server: rspam07
X-HE-Tag: 1790066616-48082
X-HE-Meta: U2FsdGVkX1/uEIFYZFInHo3rmYJ+vB3SlZthevKU4rM0hRsGkf68TgjzGmAxP9js3Qob5uwt0EkRezt41NIkG1eJEGuG5lFkMiU4nuh3M5+a8Gs7AkLJFEHjaekgONBR0wI7kOtd59muQzssm87+RTnDSCR27QhtQmFo2Bs0yX7bN6rySTJ3VDV4n/SRofhLgJhxg7KsO1aAK8ZLeb9QJcbBu8GYBUeK11fQevTMDozaE1+ZlrQZDt1fnlzNZRF+Us1a9NxsUnq7R9P2K0yYah2VwBCzl81bKtdKBcMpIycq7fQf72Rp/5ZhHFSI77D7bJ1dmTnUbzhVmON51D2QTZ17KOV+5mIKEi/hSMX1TAnUhAOqky2h/iyq4Nunh/NCtph7pe/lfLK0DDPoANtyk6xYdPOUHNLV3xo0dB1/NSfMw2Rh/fDDTOSr/UL+zdlajpLGUt/uVKt2XIZ5NWhtYD8WH8VXV1NktAHDRgKaJAVPk/LU01kNCYJc9f8K/Y7R3Ld3JLsiJXTvN+l6X/R4YQiOEYdULdnz7r73sOhUGzKMCMP3MkGL/9rwSjMF2+bCHTOdcH9cZsvK/VrRz1ptxgsOuvCQOCogpFdhKM5wvpeohoCIpE2roNQW8IWejdy+0qVmDhaE5USRHXBiCkP80eOkvGNYzMt19ZjBYz3q7u1EAwhKFWJeajuZltc5ehAqO9oqCK7UyZ5sWnbwN2UQd9VrRbleQiHBo+y/cojDxiQyIJlAlsw8RXWaQsCV78xUNVHwKrcY1sAUJwfsYO2qV9YNpUK3LOhbFF/LuUTBfNxGgJYb5sEzO9PfFI4crOihgseI9BmVcYuAL+voH3oKiCsBOS6drSpd6XseOhfllQ6kRirNdlrQcElNsLluxax1Vh7KsuV5Pz1sOXICvQuYLM36B/6cCvOOdUsa9h2StRiwR4dC8m9yG0mmxkutlHIjyv4y73yY6VbOlBApIMT
 x1M3Z4ot
 TJZCkQmsSh/mBsSRkx835vZz+KaYuUj1FghwQTwqgFufdVsh8Mujd1f/jzJH6qcVTHguiNIsZI/GFiLUQeRIFglb4n3o8k0wMw+SApN19rV0JOnY0ZYbsPHyCBhyk7T+7qZg/RjbDpwV+rWwm4qcSTJZe/Y0K6StBNDHKdMvASZonDTbYCaOUu7qmweFY+wwypcEX60xfwzuTBcNqGZd4l95nmA6AcLrqpq6sjzhqCXqpTGDTorQdZgBcQavx4UJJdO+s+hBgSb1Ex/DVQ/1IE9dc3Pl5fF5ZP7uy6embIaw0DMhTo3uMtF9Q0otzKBVSvGsW9VFVot7A5SLVcndnz3kFwzs8emdYBCmHwWf9eLaJAZIGh5BubaYiX70LQ2RdFZAVQJAF8kNqbJqWXSQAmOi5iDzN6LeABJcAjWXWF+/MwGb6f1k9hL5l5K4maX2hHL6O7sviFRPWhjF4eDFfjM3+AL4PknSW0stzreF3GI/PoFM=
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
 kernel/crash_core.c                        | 25 +++++++++++++++++--
 4 files changed, 23 insertions(+), 84 deletions(-)

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
index d0bd2d0cf899..d201638d11f3 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -281,8 +281,29 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 	return cmem;
 }
 
-unsigned int __weak arch_get_system_nr_ranges(void) { return 0; }
-int __weak arch_crash_populate_cmem(struct crash_mem *cmem) { return -1; }
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
 int __weak arch_crash_exclude_ranges(struct crash_mem *cmem) { return 0; }
 
 int __weak arch_crash_exclude_mem_range(struct crash_mem **mem,
-- 
2.43.0


