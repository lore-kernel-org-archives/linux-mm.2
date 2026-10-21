Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2FA0606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kBoaYINL
Received: by kanga.kvack.org (Postfix)
	id 16C756B01FC; Wed, 21 Oct 2026 04:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143D56B01FE; Wed, 21 Oct 2026 04:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0331A6B01FF; Wed, 21 Oct 2026 04:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0F456B01FC
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:31:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38E4C804A2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:03 +0000 (UTC)
X-FDA: 85345963206.28.4D70316
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FBB22000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kBoaYINL;
	spf=pass (imf13.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571461;
	b=FYBtaAOOwo5j4USviJcTuImpk6/JjHunqNjUmks55gH1c1a2LsKhifYe+DsCXBZziqAdun
	Yf5Sfp+W/1juQ2IzwG8kva7DYc8Y7CvaVWNO8AkS2u27TPIjGK5KHXXbfN4HzJwnGsIuGj
	a5XlpYXTKRKB/fJvi6nf5Upi39+1KSQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kBoaYINL;
	spf=pass (imf13.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
	b=FAeOLgWLvlXQeU0fv7on6QoWjp8/6UNQ9djmmPFW9KVLc9USObktgdKwhYPvZbYpykbXci
	8IMC49xLEt/CECvQXhtfzQIjzrskAdlx11znKvoW9klQjm98TZZQ79qKwi0KOZxfdQQFNk
	ARlx5c9YtAIE1Vgztm2+UMR0jvXHuHg=
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-3ac803d3bafso67300a91.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571460; x=1793176260; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
        b=kBoaYINLcXS+9/+CNvE0eJEHvuc6H7A5C8z7HEkBl4G8nbZtqQ2kYrkMpqpYQQfHSN
         qHVbX1/zNvk3bY8ZSXzQ/lVnNifVc8mhQuaogebDQjBbC2Lnlw/JyXZWixiijlbcJ7pJ
         1PxnxHOGePMnQPgn+/0uPMTGigEGH5ebQqJk3E30xyJdlt08fPYiK3bpMepDN+WnEVSt
         D4E8BEUURD9xCD/SQcvDBS0NVrEJuQpSqsrHsCQvq8l4jymAtFhlo2EvXGT+hZfUOg0i
         geTCH0Nt6GEtxg0PrZG+EuDM98mFjKxIaFvGL+ePXtIaarkfrCR4xMb2QT0K0Y7lPiNd
         8uvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571460; x=1793176260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
        b=LJXM6MOMLC4NcYo4EZXkUs1iWbcNfmg2sLzKqCkjv8iwlwoRCUNVwUObYjXFo8snSh
         s4N1q/dTXuos81c2vMkNeHtZBt1+Zeq01XtWTi4j3V01FwlTh7shBMYuvJyl4+ZBNn+X
         uomoR4r3VOXOvrfo9ODK39Wv0UsHPMF7JIuNvbwk/NI8l4ktL6t3m+Zqy2NLbosNmtW5
         B0sGDuSDhLouC9IiONOBly9J9+4tSa70Wm7+QgNoBb2ZBkIOSY9YxcILagJHnLkotBhk
         IbAS7se0KJMcbgD1jiQDcwSdzvp4JG3tLl2llyyObjH7TgGL98j+PDNgjuh3rggUBbco
         BYbA==
X-Forwarded-Encrypted: i=1; AKwUvBwSIV9qlzBSPPIzMZ03J1arCGpFTaiZJdVeO96Jt6wAYXPilcL9QV89HLHzRzukt39FkkhwbamjUw==@kvack.org
X-Gm-Message-State: AFq9FYJvqJls5wGLrPmwMU9+DcElaODwfCHKVW6YQz8qpIYa9ibsgWtX
	WgdNkI4HnByzdRory+jp90eU+KQ3DxdOv9uiBLHOCkI8Ba6QthkyRO1G
X-Gm-Gg: AYBFou1IrabWu6qtnD+Tf1m+/zjvJ1+WHc7hjj5E0VvrcAwUZT4Xd1XBPPEV32uw7iv
	DBFy/afvrNvG8kXmIpcLI6M8d8srZ/KtG94LZajFX90HlOAwXDEliwVe0an1skc1H5XJ6bo5Aq8
	7aLjYgkp9EKBBdURfTx9PDHXrnFq2nu4JIR45OP4aF+9kL8qjUTHI+PtDSBw6l/QpNPs+jYmetc
	lb+8Hi12KlYe9xw0x3Qlwy6DCOUEH/865DTtWIWxpQOs7xf1/TxC43Jt0ANlI+E6epvGuyUxLNo
	2PW33sD+Xyb5zGoNoOFsAJWgI3t39zvfU305xUOsmxfCzG0sDWPl2fnUFMbZRMLoPp2gFXf96yY
	iu3PyTJDGRUeYEgQRZkBj+jnX4r0UkmbKz+sZFSgdmMBWbvPfm5optCkMb5l/JaVNbNk53PG6yi
	i0zpFp7MV8NR1gWUjyZYarwumMTUolXkEla2CO94S1rB+E876Z+oOJgXti+3gDEJ7y3eQXA2f0o
	I5ygAKG3bPNmvIIDZ6yXlareNyBupPLIT/OrCdWi5Mi7jZjXQoWp5mCKef4DpLdtDrI
X-Received: by 2002:a05:6a20:c78d:b0:3de:48ab:3b90 with SMTP id adf61e73a8af0-3e287d66c98mr907694637.26.1792571460149;
        Wed, 21 Oct 2026 01:31:00 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:30:59 -0700 (PDT)
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
Subject: [PATCH v9 2/8] crash_core: fold duplicated memblock arch hooks into the weak default
Date: Wed, 21 Oct 2026 16:30:05 +0800
Message-ID: <20261021083011.2170525-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FBB22000A
X-Stat-Signature: tgwjrcyu9m9qu6rcg8ncn547s9y38io4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792571461-296247
X-HE-Meta: U2FsdGVkX18wIwYELh27Qk+i9M5YmhnyJ+M88m7UAe/0xrRUtSAW7i8eqzKC+YejjuaYMLUGh3nywM7bA6lDLIzlFptEshMXpjMjA4GpPc5I9r+BO3jpV54p7SQEj1cMSKR5aEMXFoHkE0HktKNHrEMKPCLLqoVbOZyK09+yyRbNjeauHJYPpn+qCJKOSk6VTJckQ2JvCiZfyJRo1qfOqMTLVhJh+w50G8y+88xOkAtAszvEFti3Q8A9uK38TqIRRYPt7jjVqZmZIQFqSniMzi6blqnIZBNC0Jo26qz1Wj5QJZKs3fTcc4MyKPPHf/JMkBhfQ98n6CPk19pYFOzPOGyDK2xnF2wPVk1OHoRdn4kCmQNIkR/2kMgh+5Y2EF7gnkuYaqhqJ6X5TIScHaM6sZkCi3chm/rWsm/JKmvbr8DZV6OM1g8f+EUDlq6SqfAVOBGgfyrDjmFakLcQaxVl6wX408ObCHpp0JelX/HSK4u8N1aw0OpbKROShlJWCoEDeoOvbJTiEDdF11ZTBbeiw/POk/LATDzVohd9irB2YI7l6XZLxtstwTTHY+udLtbG/w76ZDgrFuQ/TuZGMRv/naj8lGdSGNTENP8mZLZmgxSXtZevhwmKj/hrZmdYiCeqJaULV37Gh86mbOtfnOcL0sqo/mZVIbMgfZAejal5bUEVkXhvQ6jkX7sk6JzTjvvSwiFsg/W4WOVsJIJdSh4O2guH2nSP273qI0fhrJgcdaiy8qATex6ttawr24y/Bvdd7xItjZ0KUBq/5JBzJEfWYhy5IovRSX5bsLoWfTxYyYhO6TT+UUBM+SfQoKR3dn3zFXwyejANSt0uWFJH2ALPK7tpNA2es8Nndxo85OIdO4SiVJWWzNevpm+gROuH0trNgx++BZY3p71Xn6A3NvwEsADtU5r/PIA9HM6b/Io4iAQD2UFVh/RtOQ8lwnaSZJ4lfqxwI9d8MDFJSvbZ5MJ
 deMgKY3V
 bNUpFs1fbt9jcsUi4hEKQPMes2qBLWTGEtAI1N33OELGAqGVQ5FTwdIMS3r9M8ZQfbY3Ct7TK2mmGFtq3+ygeTn9ND3HBz6iO4WjLH9Nwp0YV5r2320OjQcA0D34dQP8pM+lEw//bPzXUrdAlP4WBvrUkQJrgZdxqe1Ud2qSWKDr3bxC8mh6vDKCj6iwOlK2I2G2sh9lpXhFNSNGKKlRw3jgveq1q1Q6JEwYlLgp+Ymz4S5a7FkdfjKvDI0PpCcS3Ecg0DDzDcsbFKyWCYFZnWRVw8IWMgrfG81SMKSOUeEPnYq1ncj3YqhefEjqI5VfxsTqBrgNfCcIC9DnI44BuYFPln3vlZUESo/eFkdHveoS8GlLOcb0xagSqcQNthniAZYaI9OWpKS6eYZMHoqxRJ6RtPEJNBiWD971+ta90JZRrhY5wVuX/nScy2mwGdLzUfxYK2XEyZb7IloeNkCdzVB5gnQApROmaOJiOBG1cB+gPNfT1Y136cnEi9P071E+C4qdpJcJGiTOMusSW5OLQ7MZF8UlrWsadvv7eO56EXOPQIOlkCC8H0TZMJ2fFMp7qUsXJpbU2V1IatiaIgHL3xSy0Xjt1jCUHSuAfC8uSbGxF+kk=
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


