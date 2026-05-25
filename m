Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244C8CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6217E6B0095; Mon, 25 May 2026 02:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8B16B0096; Mon, 25 May 2026 02:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F536B0098; Mon, 25 May 2026 02:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 415496B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:28:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F293812016B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:24 +0000 (UTC)
X-FDA: 84804962928.26.9B314C5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5CFD7180006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NPvavMM7;
	spf=pass (imf06.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQwJVQQJjFYaN+yiFzOfDgwbwCm5RC8KKUcRaw9Pru0=;
	b=DYB8aUd6lVPsXCucLz10SiK10A9oyQD5utqMowtHEpvt0muEeonHtH1WazPxxgOq/Q1KqP
	fplrEeh+wcWU+LOfEaBjZI8ytKqkLgic+SQ4tlg3GeDWwLWKtnyiNZSM0qLa6Wd9v+CWgz
	ePztaJNqEk/xyMIh8FA0g17CGyqv7gc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NPvavMM7;
	spf=pass (imf06.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690503; a=rsa-sha256;
	cv=none;
	b=ZWMCI0W3QK2sL1Jh6oLxzxkimuwVfPN2BL+dnybkcSnEu95XS3yUGz3wv/XfwazDWOhhzV
	dZRtYxgK3pd5BQTk3JfZWKG6af0TfjRxxF0MZK4gNsdMA4JQZ+RnIvWf6GZ8xQ2AZucZQa
	/4huNDcvzV0n1MtrWdpzLijGDd4uIPE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779690501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RQwJVQQJjFYaN+yiFzOfDgwbwCm5RC8KKUcRaw9Pru0=;
	b=NPvavMM7LwpyRPOk7aLy9mf3jwBIuy2kBfc/x0X7+veNaUruj/PKBV9g3H44cZGIqQOtqN
	z5a7J/msPcok+wpXXNboGsyf/g3pC+OABmW5zuB0p0D1VJ/ZG5lvhGIBmzeBHKH3aQRs10
	96vEyP3OkIMyCnw1q7e8sKiXci2FbPc=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kernel@xen0n.name,
	graf@amazon.com,
	shuah@kernel.org,
	loongarch@lists.linux.dev,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH 1/7] LoongArch: Add KHO basic support
Date: Mon, 25 May 2026 14:28:04 +0800
Message-Id: <20260525062810.103367-2-dongtai.guo@linux.dev>
In-Reply-To: <20260525062810.103367-1-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cr3kfmyb89ic7idceuawrudxg9qbn4aw
X-Rspamd-Queue-Id: 5CFD7180006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779690503-680710
X-HE-Meta: U2FsdGVkX1+P9OoKM0YCmCD4TRpmr+OOpo0hR/Ag7OXVxMhGmyID7MhwdCvmRLbdD0NT6ZiJ92pW+HVRVRl+cmRwjmeriAl7Vs25zpDLNryewl7vhdX8dG7h7Toy7yRBPElW9u65RQqcg08rusxqa+Wog7YNJyZT4wGifvxJk2R8pZUnRkZFKSDI5dX6qRI6nm39c/VUUBBcE5T1qQ7Uk/X8DKSXiMIg9K9Bxqg+CYUTzzkTY4yGViQk8TWYJokohP+KAIcd+JnZD0Q3eCB2bEcbLxJeiuFpCvGvbzNMVSM52Rwn6ou7RSQlvTTLhxyHI0y/zuhZfy8hVxWO8kYrpWuHBLvdKoJD4oc34TRI5xEJa0gKrKJcISWaE92PnFtg1fmCb2nzKCC1Zn68nKBRA/OWMdtlbFJIFg/MorXG/TWF2CnhbB7Gb9W6LzaJdG8NNNyRgVOS5NAe8c865/DrS99ifOxpOGriVBS5jR1PedLI/tFsCT6g7OYz8pEASL1mXRDo1mguK2rv7Kkvh6Us8ugkXt3hgV4787l5GJLGHcFqIf5uiOMBOkfF5lbe4TYu9T7xVMpdJAnVvypnfhFkRKdlcRLDjXUi5SUapvOsOwT5gQwU15Sc42/FVZUbJ3ZhRecKsmdoNssqJTqLE4+8ftx3GdLk3NEenncqmmVW0znwpbhOB7sDUyga4ZM3CrGIO5NLkEU/Dmv0CEbe0UiXcFopY57H08Q+bDoY7ji6UdTBeMco6xi90SVo9MzBDf3sj/V+rVzHeau/yr79ENiLbqiw3mzH1/P9IYnr8dbxwmHdA13UigtZPKb9oaGmP4QbqNoEWch232OgfcghF/sGekkQdBqmoh2+JpJV1g7ty6wSEDfHYaNCqssOouVnSJ1Etwvoco/8+dujmCqDGFmaksAhmo+pErX6RJJVmiaAVFfvwa0sH/xoafczPS5PcLsz8ed8IgBOSqyPmimPiCT
 dT74dhm3
 oLtMAd27ePzXYjEIKQQDp2tBGLCnPaNFW+wLU36ZopM5gRb9aW4U/WMXu9X3YoqHjzdfwwu0eg7DPQst0zu266+yE9WNNhTBOwIkXH7IdgXgNqwxtdG7jDmQriI7OugvFkh3QwfqFY1fgvzokbkPyCa5SQXlwmlPHt1dGm6e8I2u+G7NFPrbvA3A00W6heTo/WtuC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

Enable Kexec Handover on LoongArch64:

- Kconfig: select ARCH_SUPPORTS_KEXEC_HANDOVER for 64BIT
- machine_kexec_file: add cmdline_add_kho() to pass the KHO FDT and
  scratch buffer addresses to the next kernel via the "kho_handover="
  command-line parameter
- setup: parse "kho_handover=" early and call kho_populate() to hand
  memory regions to the KHO core

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/Kconfig                     |  3 +++
 arch/loongarch/kernel/machine_kexec_file.c | 22 ++++++++++++++++++
 arch/loongarch/kernel/setup.c              | 27 ++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 606597da46b8..d494418545f5 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -684,6 +684,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool 64BIT
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT
+
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool 64BIT
 	depends on KEXEC_FILE
diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index 5584b798ba46..ddf4d0e0e7fd 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -55,6 +55,24 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
 	*cmdline_tmplen += initrd_strlen;
 }
 
+#ifdef CONFIG_KEXEC_HANDOVER
+/* Add "kho_handover=<fdt_size>@<fdt_addr>,<scratch_size>@<scratch_addr>" to cmdline. */
+static void cmdline_add_kho(struct kimage *image, unsigned long *cmdline_tmplen,
+			    char *modified_cmdline)
+{
+	int n;
+
+	if (!image->kho.fdt || !image->kho.scratch)
+		return;
+
+	n = sprintf(modified_cmdline + *cmdline_tmplen,
+	    "kho_handover=0x%llx@0x%llx,0x%lx@0x%llx ",
+	    (u64)PAGE_SIZE,               image->kho.fdt,
+	    image->kho.scratch->bufsz,    (u64)image->kho.scratch->mem);
+	*cmdline_tmplen += n;
+}
+#endif
+
 #ifdef CONFIG_CRASH_DUMP
 
 static int prepare_elf_headers(void **addr, unsigned long *sz)
@@ -220,6 +238,10 @@ int load_other_segments(struct kimage *image,
 		cmdline_add_initrd(image, &cmdline_tmplen, modified_cmdline, initrd_load_addr);
 	}
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	cmdline_add_kho(image, &cmdline_tmplen, modified_cmdline);
+#endif
+
 	if (cmdline_len + cmdline_tmplen > COMMAND_LINE_SIZE) {
 		pr_err("Appending command line exceeds COMMAND_LINE_SIZE\n");
 		ret = -EINVAL;
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 839b23edee87..5934ba6f13e3 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -48,6 +48,7 @@
 #include <asm/setup.h>
 #include <asm/time.h>
 #include <asm/unwind.h>
+#include <linux/kexec_handover.h>
 
 #define SMBIOS_BIOSSIZE_OFFSET		0x09
 #define SMBIOS_BIOSEXTERN_OFFSET	0x13
@@ -227,6 +228,32 @@ static int __init early_parse_mem(char *p)
 }
 early_param("mem", early_parse_mem);
 
+#ifdef CONFIG_KEXEC_HANDOVER
+static int __init early_parse_kho(char *p)
+{
+	phys_addr_t fdt_addr, scratch_addr;
+	u64 fdt_size, scratch_size;
+
+	if (!p)
+		return -EINVAL;
+
+	fdt_size = memparse(p, &p);
+	if (*p++ != '@')
+		return -EINVAL;
+	fdt_addr = memparse(p, &p);
+	if (*p++ != ',')
+		return -EINVAL;
+	scratch_size = memparse(p, &p);
+	if (*p++ != '@')
+		return -EINVAL;
+	scratch_addr = memparse(p, &p);
+
+	kho_populate(fdt_addr, fdt_size, scratch_addr, scratch_size);
+	return 0;
+}
+early_param("kho_handover", early_parse_kho);
+#endif
+
 static void __init arch_reserve_vmcore(void)
 {
 #ifdef CONFIG_PROC_VMCORE
-- 
2.25.1


