Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84122CD6E60
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61936B02FB; Mon,  1 Jun 2026 05:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB336B02FD; Mon,  1 Jun 2026 05:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7CE6B02FE; Mon,  1 Jun 2026 05:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 874DE6B02FB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:39:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EDA61C1AC8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:39:44 +0000 (UTC)
X-FDA: 84830846688.24.8E4895C
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8DCB3C0007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:39:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N1D+zJeO;
	spf=pass (imf22.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kKzOePWmOb72Fw2UAE5kwvihq4Z2qKpIQem7EU7FNE=;
	b=SXrWfAkhK8+RjQUDEqqqblN43Di/ORjddw69MINTBqCEI6gYZywdLl7qOBaPN9l2oa+XXj
	59rAB/13CEmfMhM6NfWy70Ualz2bfTJJpUrFP39En3QCBqOxURSfBHUSBTKkhTLEuG52Bx
	6iES79S9CUqcp1W5V8RqLeGCdAswad4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N1D+zJeO;
	spf=pass (imf22.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306782; a=rsa-sha256;
	cv=none;
	b=ygGVxS1gjuBvCS6nfF4IW/fQz+ZBBqC2xoErDsN6sbikAOeCF09XkKZDl7JzqNomevqG+X
	B9reK2VADRITyH4sednNR2XlEGyB7ZpfY4xScTEbZYkIUI86xdCSwZkXyj/kvIAjggYGky
	n6tVKoewhgqtgVTBYFAR7oa4CwiKcqg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780306781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1kKzOePWmOb72Fw2UAE5kwvihq4Z2qKpIQem7EU7FNE=;
	b=N1D+zJeOv1rRlzchItvYocwA5pUU/8XQMjaZhaeKiM9blyno+t6poIYYdn4aDYubX+crFT
	HKxDP5NP6FJO72SGwq3LGsvxgKSTANiaVfW1I24v88u8b+KGJqVjryGzJj4a+/H4mL1yLK
	2qIbZgCo97GzPf2GPpM0rAl7qwq73zw=
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
	linux-kselftest@vger.kernel.org, systems@kvack.org
Subject: [PATCH v3 2/3] LoongArch: kexec: add KHO support for ACPI-only
Date: Mon,  1 Jun 2026 17:39:29 +0800
Message-Id: <20260601093930.112758-2-dongtai.guo@linux.dev>
In-Reply-To: <20260601093930.112758-1-dongtai.guo@linux.dev>
References: <20260601092823.110362-1-dongtai.guo@linux.dev>
 <20260601093930.112758-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: koxcgab8d3e6gupw5atuap6or1a8yjpz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DCB3C0007
X-HE-Tag: 1780306782-148423
X-HE-Meta: U2FsdGVkX1+VgeUcjtuqoYESsPanAM6tcS5W9wEBO23YrY/HPxoE29zdV0vefvNRhPEJXW+3GMvuERXzJG8X+0lQG0EB3Sc4m9ZRHzmAYp6Hyemn9VpG//rrf//hQO2RgQxOqvfy6lC4oYak4taDdjqFgty68XxGAGcYZMODxouXBCSC7AHOh+e8wzmgBYqtKe/eOpiWvI4Ub1of+N53S9d8bTFNYkPPlICh37W9H3GPEzPzWbvWYakD0deOWQs7JCmqxNt8HRrQkPARDbE8eAp3zjaTCT04oezqjchhH+zZc07VzpbE1Dkjzem1BGf8Hf7YMGWZV5MrqkqoUj6xYHL/aY7lc0IV9iKju02LlDttHtRqZSbxvfMP8GcvtxWYJIJ7yCbcjS4A1syvxzcJSQLJbybE5SJ+TDj1NsrTYidUNvQxXWkgH44O2DaSLadDABsa2UYziW7bEL1hLiL/EErgcmCM9R6+/1VHTTqlNzkf10BKeeLd7CP9EWG87cfL6B1OECBI7pfyU98Cd69XDQy2DVjzmpWXdI9OogKTAZtIhznA3LHmWh7EP3JjjoHYnFPvZzS0sbGEvcskMLfDmWmTDTR8BPKFitURMjXViPzteSR66ZrrO4RmYz+GsZbyV0JQkemjkGufoQKiHGme6OqqAJxv/R+yuzYwUnVsPoFKMMPbPalJ4wu2OJTsV5eC4AaYggLjl9iu9TJamwlv3fRYYw0OKQP8g+U56It35TwPLO6MiLuJSuJc7B5J81C8s6f25SUTX/QkIRInNko3zltcVPKN2WoXG7KIbvP6hvvEJz6ee3+2qACo40ywsNsV9nzl7ejY1TbK237sniO00KADwZVV8IkVlq/YW5sdaboXW0434eVOK7iOM8+cRcZy60EQoJ/HJqTjfzSP43aQ3JbVA6UbDERTDe6obFGuH4/qD94m9X5E7PEAOA+UMjZpG2lVRJMa25uM/EV747u
 GHxnHMmQ
 fFrypEDu4rN2yzkVuBWXceZHnGE5zTkprT+PTjNaYhJzpV0lGu7mT/ZboFEYs+DOVxM5nTZ1yqw3zpvc3273w+tgh9Vl01A5TN2dvgCyUv+sb13SAK/W+3VhcJgR/SHaps3S3TSKgPmpRVhScXVzy3r19/p3JAZkbONBn3yOlLQEz2Q5SZ/JoCw23e6b3FUGyAdD1MmBzBUrNu6du+Ba5u1j5TD6YZ4fRYHuC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

On ACPI-only systems fdt_setup() returns early when it detects ACPI,
so initial_boot_params remains NULL and the FDT-based kho_load_fdt()
path cannot be used.

machine_kexec_file.c:
- kho_load_fdt(): add an else branch that builds a minimal FDT from
  scratch (SZ_1K) containing only a /chosen node with linux,kho-fdt
  and linux,kho-scratch properties, using the libfdt creation API.
- Since DEVICE_TREE_GUID is absent from the EFI config table on
  ACPI-only systems, build a new config table with DEVICE_TREE_GUID
  appended and load it as a kexec segment.  Store the result in
  kimage_arch so machine_kexec() can switch st->tables before jumping.
- arch_kimage_file_post_load_cleanup(): free the efi_tables kvmalloc
  buffer once the kexec image has been loaded.

machine_kexec.c:
- Before jumping, update the EFI system table pointer: for FDT-based
  systems update the existing DEVICE_TREE_GUID entry; for ACPI-only
  systems switch st->tables / st->nr_tables to the new extended table.

setup.c:
- fdt_setup(): when ACPI is detected, use efi_fdt_pointer() to detect
  whether this is a KHO kexec boot.  The first kernel switches the EFI
  config table to a new one that includes a DEVICE_TREE_GUID entry
  pointing to the minimal KHO FDT.  If found, call early_init_dt_scan()
  so early_init_dt_check_kho() can consume linux,kho-fdt and
  linux,kho-scratch, then reset initial_boot_params to NULL so the rest
  of the ACPI boot path is unaffected.

kexec.h:
- Add efi_tables, efi_tables_mem, efi_tables_cnt to kimage_arch.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/include/asm/kexec.h         |   3 +
 arch/loongarch/kernel/machine_kexec.c      |  11 ++
 arch/loongarch/kernel/machine_kexec_file.c | 162 +++++++++++++++++++--
 arch/loongarch/kernel/setup.c              |  21 ++-
 4 files changed, 184 insertions(+), 13 deletions(-)

diff --git a/arch/loongarch/include/asm/kexec.h b/arch/loongarch/include/asm/kexec.h
index adf54bfcdd49..e1abaf40b06a 100644
--- a/arch/loongarch/include/asm/kexec.h
+++ b/arch/loongarch/include/asm/kexec.h
@@ -42,6 +42,9 @@ struct kimage_arch {
 #ifdef CONFIG_KEXEC_HANDOVER
 	void *fdt;		/* virtual address of KHO FDT segment buffer */
 	unsigned long fdt_mem;	/* physical address of KHO FDT segment */
+	void *efi_tables;		/* new EFI config table buffer (virtual) */
+	unsigned long efi_tables_mem;	/* physical address of new EFI config table */
+	unsigned long efi_tables_cnt;	/* number of entries in new EFI config table */
 #endif
 };
 
diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index 98529c71d001..cbb7f8368843 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -313,6 +313,17 @@ void machine_kexec(struct kimage *image)
 				break;
 			}
 		}
+	} else if (internal->efi_tables_mem) {
+		/*
+		 * ACPI-only system: DEVICE_TREE_GUID was not in the original
+		 * EFI config table.  Switch to the new table that was built in
+		 * kho_load_fdt() with DEVICE_TREE_GUID appended.
+		 */
+		efi_system_table_t *st =
+			(efi_system_table_t *)TO_CACHE(systable_ptr);
+
+		st->tables    = internal->efi_tables_mem;
+		st->nr_tables = internal->efi_tables_cnt;
 	}
 #endif
 
diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index bf1e8c1c7e70..c1955d991061 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) "kexec_file: " fmt
 
+#include <linux/efi.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
@@ -20,6 +21,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
+#include <asm/addrspace.h>
 #include <asm/bootinfo.h>
 
 const struct kexec_file_ops * const kexec_file_loaders[] = {
@@ -37,6 +39,8 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 #ifdef CONFIG_KEXEC_HANDOVER
 	kvfree(image->arch.fdt);
 	image->arch.fdt = NULL;
+	kvfree(image->arch.efi_tables);
+	image->arch.efi_tables = NULL;
 #endif
 
 	return kexec_image_post_load_cleanup_default(image);
@@ -68,6 +72,13 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
  * segment.  The second kernel reads linux,kho-fdt and linux,kho-scratch
  * from /chosen via early_init_dt_check_kho() and calls kho_populate().
  *
+ * On FDT-based systems (initial_boot_params != NULL), the current FDT is
+ * copied and the KHO properties are appended to /chosen.
+ *
+ * On ACPI-only systems (initial_boot_params == NULL), a minimal FDT
+ * containing only /chosen is built from scratch.  machine_kexec() updates
+ * the EFI config table DEVICE_TREE_GUID entry to point to this segment so
+ * that the second kernel's fdt_setup() can find and parse it.
  */
 static int kho_load_fdt(struct kimage *image)
 {
@@ -143,24 +154,151 @@ static int kho_load_fdt(struct kimage *image)
 		 * once the kexec image has been loaded.
 		 */
 		fdt_pack(fdt);
+	} else {
+		/*
+		 * ACPI boot: build a minimal FDT containing only /chosen with
+		 * the two KHO properties.  No system FDT is available to copy.
+		 */
 
-		kbuf.buffer	= fdt;
-		kbuf.bufsz	= fdt_totalsize(fdt);
-		kbuf.memsz	= kbuf.bufsz;
-		kbuf.buf_align	= PAGE_SIZE;
-		kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
+		__be64 prop[2];
 
-		ret = kexec_add_buffer(&kbuf);
-		if (ret)
+		fdt_size = SZ_1K;
+		fdt = kvmalloc(fdt_size, GFP_KERNEL);
+		if (!fdt)
+			return -ENOMEM;
+
+		ret = fdt_create(fdt, fdt_size);
+		if (ret < 0)
+			goto out_free;
+		ret = fdt_finish_reservemap(fdt);
+		if (ret < 0)
+			goto out_free;
+		ret = fdt_begin_node(fdt, "");	/* root */
+		if (ret < 0)
+			goto out_free;
+		ret = fdt_property_u32(fdt, "#address-cells", 2);
+		if (ret < 0)
+			goto out_free;
+		ret = fdt_property_u32(fdt, "#size-cells", 2);
+		if (ret < 0)
+			goto out_free;
+		ret = fdt_begin_node(fdt, "chosen");
+		if (ret < 0)
 			goto out_free;
 
-		image->arch.fdt     = fdt;
-		image->arch.fdt_mem = kbuf.mem;
-		return 0;
-	} else {
-		return -EINVAL;
+		prop[0] = cpu_to_be64(image->kho.fdt);
+		prop[1] = cpu_to_be64(PAGE_SIZE);
+		ret = fdt_property(fdt, "linux,kho-fdt", prop, sizeof(prop));
+		if (ret < 0)
+			goto out_free;
+
+		prop[0] = cpu_to_be64(image->kho.scratch->mem);
+		prop[1] = cpu_to_be64(image->kho.scratch->bufsz);
+		ret = fdt_property(fdt, "linux,kho-scratch", prop, sizeof(prop));
+		if (ret < 0)
+			goto out_free;
+
+		ret = fdt_end_node(fdt);	/* chosen */
+		if (ret < 0)
+			goto out_free;
+		ret = fdt_end_node(fdt);	/* root */
+		if (ret < 0)
+			goto out_free;
+		ret = fdt_finish(fdt);
+		if (ret < 0)
+			goto out_free;
 	}
 
+	kbuf.buffer	= fdt;
+	kbuf.bufsz	= fdt_totalsize(fdt);
+	kbuf.memsz	= kbuf.bufsz;
+	kbuf.buf_align	= PAGE_SIZE;
+	kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
+
+	ret = kexec_add_buffer(&kbuf);
+	if (ret)
+		goto out_free;
+
+	image->arch.fdt     = fdt;
+	image->arch.fdt_mem = kbuf.mem;
+
+	/*
+	 * On ACPI-only systems DEVICE_TREE_GUID is not in the EFI config
+	 * table, so the second kernel's efi_fdt_pointer() cannot locate the
+	 * KHO FDT.  Build a new EFI config table with DEVICE_TREE_GUID added
+	 * and load it as a kexec segment; machine_kexec() will update
+	 * st->tables / st->nr_tables to point to it before jumping.
+	 */
+
+	/*
+	 * fw_arg2 is the EFI system table physical address passed by the
+	 * firmware/bootloader.  Use it directly here because
+	 * image->arch.systable_ptr is set later in machine_kexec_prepare(),
+	 * which runs after load_other_segments() / kho_load_fdt().
+	 */
+	if (!initial_boot_params && fw_arg2) {
+		efi_system_table_t *st =
+			(efi_system_table_t *)TO_CACHE(fw_arg2);
+		efi_config_table_t *ct =
+			(efi_config_table_t *)TO_CACHE((unsigned long)st->tables);
+		unsigned long i;
+		bool found = false;
+
+		/*
+		 * Scan the original config table;
+		 * DEVICE_TREE_GUID is absent on ACPI-only systems.
+		 */
+		for (i = 0; i < st->nr_tables; i++) {
+			if (!efi_guidcmp(ct[i].guid, DEVICE_TREE_GUID)) {
+				found = true;
+				break;
+			}
+		}
+
+		if (!found) {
+			size_t old_sz = st->nr_tables * sizeof(efi_config_table_t);
+			size_t new_sz = old_sz + sizeof(efi_config_table_t);
+			efi_config_table_t *new_ct;
+			struct kexec_buf tbuf = {
+				.image		= image,
+				.buf_min	= 0,
+				.buf_max	= ULONG_MAX,
+				.top_down	= true,
+			};
+
+			/*
+			 * Allocate a new table with n+1 entries and append
+			 * the DEVICE_TREE_GUID entry.
+			 */
+			new_ct = kvmalloc(new_sz, GFP_KERNEL);
+			if (!new_ct)
+				return -ENOMEM;
+
+			memcpy(new_ct, ct, old_sz);
+			new_ct[st->nr_tables].guid  = DEVICE_TREE_GUID;
+			new_ct[st->nr_tables].table = (void *)image->arch.fdt_mem;
+
+			/* Register the new config table as a kexec segment. */
+			tbuf.buffer   = new_ct;
+			tbuf.bufsz    = new_sz;
+			tbuf.memsz    = new_sz;
+			tbuf.buf_align = sizeof(void *);
+			tbuf.mem      = KEXEC_BUF_MEM_UNKNOWN;
+
+			ret = kexec_add_buffer(&tbuf);
+			if (ret) {
+				kvfree(new_ct);
+				return ret;
+			}
+
+			image->arch.efi_tables     = new_ct;
+			image->arch.efi_tables_mem = tbuf.mem;
+			image->arch.efi_tables_cnt = st->nr_tables + 1;
+		}
+	}
+
+	return 0;
+
 out_free:
 	kvfree(fdt);
 	return ret;
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 839b23edee87..c82067d1dc75 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -286,8 +286,27 @@ static void __init fdt_setup(void)
 	void *fdt_pointer;
 
 	/* ACPI-based systems do not require parsing fdt */
-	if (acpi_os_get_root_pointer())
+	if (acpi_os_get_root_pointer()) {
+#ifdef CONFIG_KEXEC_HANDOVER
+		/*
+		 * On a KHO kexec boot the first kernel builds a minimal FDT
+		 * containing only /chosen with linux,kho-fdt and
+		 * linux,kho-scratch, and switches the EFI config table to a
+		 * new one that includes a DEVICE_TREE_GUID entry pointing to
+		 * it.  Use efi_fdt_pointer() to detect this case.
+		 *
+		 * Call early_init_dt_scan() to let early_init_dt_check_kho()
+		 * consume the KHO data, then reset initial_boot_params so the
+		 * rest of the ACPI boot path is not confused by this FDT.
+		 */
+		fdt_pointer = efi_fdt_pointer();
+		if (fdt_pointer && !fdt_check_header(fdt_pointer)) {
+			early_init_dt_scan(fdt_pointer, __pa(fdt_pointer));
+			initial_boot_params = NULL;
+		}
+#endif
 		return;
+	}
 
 	/* Prefer to use built-in dtb, checking its legality first. */
 	if (IS_ENABLED(CONFIG_BUILTIN_DTB) && !fdt_check_header(__dtb_start))
-- 
2.25.1


