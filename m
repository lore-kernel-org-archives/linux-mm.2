Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 199C3CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8919B6B0092; Fri, 29 May 2026 10:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868656B0093; Fri, 29 May 2026 10:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7099C6B0095; Fri, 29 May 2026 10:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56E926B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:33:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CA73160C39
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:25 +0000 (UTC)
X-FDA: 84820700370.13.3AE4D7D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B9AA10000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LeF5J0Sx;
	spf=pass (imf05.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtSMl9iP75hamPW1BlPVg98M+VxyBwhIOvWuNPAUfKk=;
	b=UaDG44l6JTx+hXMf3SeR81VPuWNs9Kei78E68+MOKvrbRqs3HICp1BRfxuuw8LjXDMMHd1
	gRUSXFeO3HCPf0zau99UG8iJiRU1pJw4rsKhFF/iM9B96WVmInZBxA3uiy+mdTkDhm/csS
	Wl0p0sh5RpxM2ms2jNTZMIZuiVAAan4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LeF5J0Sx;
	spf=pass (imf05.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780065203; a=rsa-sha256;
	cv=none;
	b=S3akdWqBlifUnvXf4oBcj6twJwA4gxty/ivvrWv5Fwla6lnCI3MbYcRpZdrt6Cc2mRIFzk
	fi2XOTaG+mGH626CoJgfBniMxzKd8HQ1G4DMS33bA0Vc0mpyg9UZFAOFBI5DcZ2+aomNs4
	765rJHqoBQzzwt5EnhB0+Rv/SNv32lQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780065200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vtSMl9iP75hamPW1BlPVg98M+VxyBwhIOvWuNPAUfKk=;
	b=LeF5J0Sx6mHM5+Vq2Rq4vqmOAs6z7rIDMvpuVz2lUTqFomo12Z1iTQeQg9cyskI2iZa+UT
	SqsWvi8s/sY78ZfCZg0QNwWRUHOZO24qhpntXtjJOXBhDxsWHGy18tX9BgtDr4caG3Ydnm
	/0mRacf7RWN0P5IsFC5YRs76uidlOis=
From: George Guo <dongtai.guo@linux.dev>
To: Huacai Chen <chenhuacai@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Alexander Graf <graf@amazon.com>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH v2 1/4] LoongArch: kexec: add KHO support for FDT-based systems
Date: Fri, 29 May 2026 22:32:35 +0800
Message-Id: <20260529143238.169169-2-dongtai.guo@linux.dev>
In-Reply-To: <20260529143238.169169-1-dongtai.guo@linux.dev>
References: <20260529143238.169169-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B9AA10000D
X-Stat-Signature: bdroeda7foepkkrxqnki18zyjocxj8zd
X-HE-Tag: 1780065203-80591
X-HE-Meta: U2FsdGVkX19rgJg1lVlqLyUPBZengexDwrG5IKXq5e830Nrg2sgxqmQ5WijiPZcfdmtlgoQ4SdaFin3oQG6jV9LBcH9J4JHqJRPaeFGC1uvf1zFp+RF4TX+fOJltjsUzUJeJVL6exr6rNnmcwiG7dZOpfxRg9rAnebLFZpSvcgsfmt1Vy/1npl25e2lo7oHbyzouBIA73jVvDizUEZqXt0nbUmfXAkBcSseOULnu4JfnsuJkwg8e++iH7Gzff5QiIeHYKfV9D4KHMe0tzApUaXk/yWQyYR9e6d8/hPtWYz1ugkRqUUP4HduVh7qjNdo9mC/ymErVVRIwxKhxIwvJDLlhnLjTLJ3kch+ytJmUkwH8+OQc5hF6vPhH9o4dMhoxduIQE8hcTsgvEQHUDH4yKjMSNvNoAlloKmXWGOEI3v0Vn6cVGoLaH5/jlYRK30wU+K6yvqFNc+vjBtj5s3kyEUjd8epFbtOngQBWTiHS1mTVJrQKunPb7a1Nt5lc1gBlrJfWpD2HwL3vjsoRcsAfx4jxUeGRsgzKJ81YB+tQEHxODnxRonJTmDEditD7B22wSYTfzEbGDWCPv2fjbdaMYMO+nsyUY4KedUh+Mej26jekKNA7JCkjmsM5PDKVZZiywtu1CQaeIwXYKOkPNLCr6eINTVLmVyLMgzR8xtjg8hTjDvdk0DkKOMiz1/iP7ZiO18dlknhs/Dp+D6ZmlqE6JwNQ2RIELbBhcCa0Abq/GPmELxPD+5jHDlqrXqJ3IcGo5zzK/s53l+gPTXQ+aIgUwUTsmOW9wCBNn6jZIetoL6YMmr9Zu7hp5Iw0Y6uUQDxwkWccK37db+oTLoGtGUdWYi/vQpN+NGtXXngriDG6qNcU5U3A9HU8YqBg1UrwDZVJKGhCoBkW7JmIGMV04Sud0YMqyXMuOGZzcGIIK8zQG1V3aaLpPaRiVnjQpcnzaGcNSyynPVAH2/VH9gEGreB
 +QAZFdOZ
 bTJwVw9CXGomTPM9Xc+ZFSQyJrP1Dqx+0FAxCmtZVr/DM6Ens3w2EaFnuHjx2auyfEqLRxZFooRe9NcA6/pEWRYFHKScaIxvLUqHL7CBqnxnSLmtp+h//ckozOycYYbe0cDYEIDYMZpu8tSBrH61hCo8Z9rbTHNSkOVQ0TmJ0QzyyEkBut4UgCaMURNtFq/TZv7EPKOSHW3pULfu8N77Jkcm1KwFRx6dB+6iY
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
index d7fafda1d541..130f1adfa515 100644
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
@@ -284,6 +285,32 @@ void machine_kexec(struct kimage *image)
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


