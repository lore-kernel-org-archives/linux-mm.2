Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658B3CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD72F6B02F9; Mon,  1 Jun 2026 05:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60B06B02FB; Mon,  1 Jun 2026 05:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A294D6B02FC; Mon,  1 Jun 2026 05:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4396B02F9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:39:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EE31404DF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:39:42 +0000 (UTC)
X-FDA: 84830846604.19.F24987C
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 506BC180005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:39:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lt0+zFjE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZJJJUWM/UdeM9EpxSsLVE41gZLrE+ZKIyNNK6qg31U=;
	b=crQcyylXAuJ38Buotd4Y5e4jJFg1FLTKlpAW6FtA2Xxg81HSn2FU2hQhiLsmRHuvpuICpC
	C9Sjs2q1lLELGOOlPyqscYf17TUbvzmNioyO+29x4S4AmFwHyGDRpl+mvM9h4bK4sn+SHe
	0YgrhBbdNpc4C1Ix/rF0x2STRLWkwus=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lt0+zFjE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306780; a=rsa-sha256;
	cv=none;
	b=vn4E0ekulQAxnj91/GvVAqhA2D/g+LNfGzNgvlYxD8g/m8sVf7C9Qyve/rvBOtsQwri52u
	GEcIgWNteJjSOTNyJKER3LPrWT6a1XN1mzQwasACPoihLJW7tulAPi5ky9OyrSChbZIgln
	TgIJMCQe6vBcCqbPFJ9XAlq5Wi6S5BY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780306778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ZJJJUWM/UdeM9EpxSsLVE41gZLrE+ZKIyNNK6qg31U=;
	b=Lt0+zFjE9CvRxpiXw93TaC39I4onXUXiD2gVk3pI5jSwa0eIamXRmsHkCB2YePTOPpN7fC
	pkkqqtxE1FvwLrCDmR98YFpg34ZXtWmQi2CZJGvukLnGkqsKxKy7jrnKMRSBsbeqbVxSpn
	eOeRjkvV27He+bjo9Llb/UvNmRbLRK8=
From: George Guo <dongtai.guo@linux.dev>
To: Huacai Chen <chenhuacai@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: George Guo <guodongtai@kylinos.cn>,
	WANG Xuerui <kernel@xen0n.name>, Alexander Graf <graf@amazon.com>,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, systems@kvack.org,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH v3 1/3] LoongArch: kexec: add KHO support for FDT-based
Date: Mon,  1 Jun 2026 17:39:28 +0800
Message-Id: <20260601093930.112758-1-dongtai.guo@linux.dev>
In-Reply-To: <20260601092823.110362-1-dongtai.guo@linux.dev>
References: <20260601092823.110362-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4zd91k7r3x1ctsistbph4wsemzx48kcg
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 506BC180005
X-Rspam-User: 
X-HE-Tag: 1780306780-457724
X-HE-Meta: U2FsdGVkX1/lrUx4WwDBknJSsTy7iggGwBmq1gwhEJOGJOi/Rw7J8AxWxwE60ijADXB+J/aJ63cpnBW23tdxzFq5JlDmcu5MmWTJwqfgN0lWlyxxNIbKKun2z+DjsdJhvMOgWMXcPW6+ye1MBWas6NPl1vxk9dAfZKLtdw5qOxTr9rzyzQ9tf7h+1WtSi0dkFefKeCo9rorgCodhiOqZoJSgHPihgR7CRPEfk6KXtPkvdOKLa1/ip7lQjeIo64Hyiggg/kmTddcCZHoe9oG7CvPv31z5KFvpYmssLGM9dR+7sOgrINz6N1OfcDwVNpvePpuDSTSn5+soVqmBvWzcN1JYIW+VN1cX3/f1bgEoMTs1SwQvcJIP103FWSahZy5GVA9/aTiuZYvRL0oAZk9hO7ZXLC3Zgg6ZYeEq+3o32z6kKzUxSLB4wqe8NFB+CxqDfwlQ3QyEa4mYDYxx2DfG/oX8aOaVI0xLsTi1m/i78p4wzBItFsnpQzpROm7Z3/IpP5JcSn2IsvL4v4WHndkK2srxv+P9Dmqisy/kQtclyUUQIYEEa9AfE2oIAWEOrpUMFAbbg5Q1DdwK859LxE9BumECamujZ0f8ZjG0S3Y6TCgnDc86dT3YPxPD8P8vlRyphJy6CbF3rfe1dDsBKal0tWLk8+nnEjUwOrgBbRkHRMl514GSQzfpQnWHSGoEoWAgSMzXwnpvBzzstcve7VI8JYAytOs6gd19K9oqCjy+8n05L8um3oalxdHwZf875MroQ/+GYZMN2k5suwVk49Lk6dcBC4npX4cYmlzkz26JCkDpCskGudXw3kbgH2rt1I+N/PiPpMM02eu+BvbK1cEIFzMBJBdlUitk+2b27PDny2hwLK+LeTcH/2MnDjS2lEMEtsqtDJRf8RfU2bzcJjVGurCp7m0doqKM4sgRkSqn/rCBfeddOWTZ90KFPXqwXGwoYsk5ww0X1YtYGvHIQcX
 qC5UqKiu
 VrlMsZH0aJDievxOXxeT7qAfTevPPoel582mlZElwppg3GoCvwBG9msDZ06FJKY2YdApS++PppOZsrrBKHTCmkZhJEpwDEJmNs/xtcNcWl7yl90sK/wh63PDQlYzs+jXxqepktfHUGNdFcpUgcyQHBb/IniKvGyDPRSBy1kP38RSjsy3G88IeNShRVFLw1unt8KTGG8xbgkeT7RK7sAgVcQ5EwrbItJwsrdpQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

Enable Kexec Handover (KHO) on LoongArch64 for FDT-based systems.

- Kconfig: select ARCH_SUPPORTS_KEXEC_HANDOVER for CONFIG_64BIT
- kexec.h: add fdt/fdt_mem fields to kimage_arch to hold the KHO FDT
  kexec segment virtual and physical addresses
- machine_kexec_file.c: add kho_load_fdt() which copies the running
  kernel's FDT (initial_boot_params), appends linux,kho-fdt and
  linux,kho-scratch properties to /chosen, and loads the result as a
  kexec segment; called from load_other_segments().  Returns -EINVAL
  when initial_boot_params is NULL (ACPI-only boot) since that path
  requires separate handling.
- machine_kexec.c: before jumping to the new kernel, update the
  DEVICE_TREE_GUID entry in the EFI config table to point to the KHO
  FDT segment so the second kernel finds it via efi_fdt_pointer() and
  early_init_dt_check_kho() calls kho_populate()

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/Kconfig                     |   3 +
 arch/loongarch/include/asm/kexec.h         |   4 +
 arch/loongarch/kernel/machine_kexec.c      |  27 +++++
 arch/loongarch/kernel/machine_kexec_file.c | 118 +++++++++++++++++++++
 4 files changed, 152 insertions(+)

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
diff --git a/arch/loongarch/include/asm/kexec.h b/arch/loongarch/include/asm/kexec.h
index 209fa43222e1..adf54bfcdd49 100644
--- a/arch/loongarch/include/asm/kexec.h
+++ b/arch/loongarch/include/asm/kexec.h
@@ -39,6 +39,10 @@ struct kimage_arch {
 	unsigned long efi_boot;
 	unsigned long cmdline_ptr;
 	unsigned long systable_ptr;
+#ifdef CONFIG_KEXEC_HANDOVER
+	void *fdt;		/* virtual address of KHO FDT segment buffer */
+	unsigned long fdt_mem;	/* physical address of KHO FDT segment */
+#endif
 };
 
 #ifdef CONFIG_KEXEC_FILE
diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index ad27fef098f1..98529c71d001 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -6,6 +6,7 @@
  */
 #include <linux/compiler.h>
 #include <linux/cpu.h>
+#include <linux/efi.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
@@ -289,6 +290,32 @@ void machine_kexec(struct kimage *image)
 	pr_notice("We will call new kernel at 0x%lx\n", start_addr);
 	pr_notice("Bye ...\n");
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	/*
+	 * Point the EFI FDTPTR config table entry at the modified FDT so the
+	 * second kernel picks up the linux,kho-fdt and linux,kho-scratch
+	 * properties via early_init_dt_check_kho().
+	 */
+	if (internal->fdt_mem) {
+		/*
+		 * FDT-based system: DEVICE_TREE_GUID already exists in the EFI
+		 * config table; just update its pointer to our KHO FDT.
+		 */
+		efi_system_table_t *st =
+			(efi_system_table_t *)TO_CACHE(systable_ptr);
+		efi_config_table_t *ct =
+			(efi_config_table_t *)TO_CACHE((unsigned long)st->tables);
+		unsigned long i;
+
+		for (i = 0; i < st->nr_tables; i++) {
+			if (!efi_guidcmp(ct[i].guid, DEVICE_TREE_GUID)) {
+				ct[i].table = (void *)internal->fdt_mem;
+				break;
+			}
+		}
+	}
+#endif
+
 	/* Make reboot code buffer available to the boot CPU. */
 	flush_cache_all();
 
diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index 5584b798ba46..bf1e8c1c7e70 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -13,7 +13,9 @@
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
+#include <linux/libfdt.h>
 #include <linux/memblock.h>
+#include <linux/of_fdt.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -32,6 +34,11 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 	image->elf_headers = NULL;
 	image->elf_headers_sz = 0;
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	kvfree(image->arch.fdt);
+	image->arch.fdt = NULL;
+#endif
+
 	return kexec_image_post_load_cleanup_default(image);
 }
 
@@ -55,6 +62,111 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
 	*cmdline_tmplen += initrd_strlen;
 }
 
+#ifdef CONFIG_KEXEC_HANDOVER
+/*
+ * Add KHO metadata to an FDT /chosen node and load the FDT as a kexec
+ * segment.  The second kernel reads linux,kho-fdt and linux,kho-scratch
+ * from /chosen via early_init_dt_check_kho() and calls kho_populate().
+ *
+ */
+static int kho_load_fdt(struct kimage *image)
+{
+	void *fdt;
+	int ret, chosen_node;
+	size_t fdt_size;
+	struct kexec_buf kbuf = {
+		.image		= image,
+		.buf_min	= 0,
+		.buf_max	= ULONG_MAX,
+		.top_down	= true,
+	};
+
+	if (!image->kho.fdt || !image->kho.scratch)
+		return 0;
+
+	if (initial_boot_params) {
+		/*
+		 * FDT boot: copy the running kernel's FDT and append KHO
+		 * properties to /chosen.
+		 */
+
+		/*
+		 * Only two KHO properties are added to /chosen (linux,kho-fdt
+		 * and linux,kho-scratch), so SZ_1K of extra space is
+		 * sufficient.
+		 */
+		fdt_size = fdt_totalsize(initial_boot_params) + SZ_1K;
+		fdt = kvmalloc(fdt_size, GFP_KERNEL);
+		if (!fdt)
+			return -ENOMEM;
+
+		ret = fdt_open_into(initial_boot_params, fdt, fdt_size);
+		if (ret < 0) {
+			pr_err("Failed to open FDT: %d\n", ret);
+			goto out_free;
+		}
+
+		chosen_node = fdt_path_offset(fdt, "/chosen");
+		if (chosen_node == -FDT_ERR_NOTFOUND) {
+			pr_debug("No /chosen node in FDT, creating one\n");
+			chosen_node = fdt_add_subnode(fdt,
+						      fdt_path_offset(fdt, "/"),
+						      "chosen");
+		}
+		if (chosen_node < 0) {
+			ret = chosen_node;
+			goto out_free;
+		}
+
+		/* Remove stale KHO properties left by a previous kexec load */
+		fdt_delprop(fdt, chosen_node, "linux,kho-fdt");
+		fdt_delprop(fdt, chosen_node, "linux,kho-scratch");
+
+		ret = fdt_appendprop_addrrange(fdt, 0, chosen_node,
+					       "linux,kho-fdt",
+					       image->kho.fdt, PAGE_SIZE);
+		if (ret)
+			goto out_free;
+
+		ret = fdt_appendprop_addrrange(fdt, 0, chosen_node,
+					       "linux,kho-scratch",
+					       image->kho.scratch->mem,
+					       image->kho.scratch->bufsz);
+		if (ret)
+			goto out_free;
+
+		/*
+		 * Shrink totalsize to the actual data size so the kexec segment
+		 * allocated by kexec_add_buffer() covers only the packed FDT data.
+		 * The slack added above for property insertion is part of the
+		 * kvmalloc'd buffer, which is freed by kimage_file_post_load_cleanup()
+		 * once the kexec image has been loaded.
+		 */
+		fdt_pack(fdt);
+
+		kbuf.buffer	= fdt;
+		kbuf.bufsz	= fdt_totalsize(fdt);
+		kbuf.memsz	= kbuf.bufsz;
+		kbuf.buf_align	= PAGE_SIZE;
+		kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
+
+		ret = kexec_add_buffer(&kbuf);
+		if (ret)
+			goto out_free;
+
+		image->arch.fdt     = fdt;
+		image->arch.fdt_mem = kbuf.mem;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+
+out_free:
+	kvfree(fdt);
+	return ret;
+}
+#endif
+
 #ifdef CONFIG_CRASH_DUMP
 
 static int prepare_elf_headers(void **addr, unsigned long *sz)
@@ -230,6 +342,12 @@ int load_other_segments(struct kimage *image,
 	cmdline = modified_cmdline;
 	image->arch.cmdline_ptr = (unsigned long)cmdline;
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	ret = kho_load_fdt(image);
+	if (ret)
+		goto out_err;
+#endif
+
 	return 0;
 
 out_err:
-- 
2.25.1


