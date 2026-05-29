Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E04C9CD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1BF6B0093; Fri, 29 May 2026 10:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053866B0095; Fri, 29 May 2026 10:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1BA6B0096; Fri, 29 May 2026 10:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAA1E6B0093
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:33:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99116401A9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:26 +0000 (UTC)
X-FDA: 84820700412.09.C585C4B
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf27.hostedemail.com (Postfix) with ESMTP id D19EF4000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IxBWZ8Gw;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eo9FrKG4xWr+2YP1w34Fe4mj/8vSxbGckKFB9ZC88xs=;
	b=EvEPv7i19Ch/jWswF/2ukjEreaacgEM28+Mla57Yy6/DjC8UdAXE3SSX2FtJoCMoLLAcU9
	reUklD9Sal49fHbn9+iu5liUeIIgvWCli/dqjrl7amppol7WTarJdRHl+7CqLCfEdJCq74
	I0k+lrpaUjgcvM2tzIdhWJ1yUq3NFeM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IxBWZ8Gw;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780065205; a=rsa-sha256;
	cv=none;
	b=Fuy3nz/zwc6e81oYQDZpV7UWOry6Z47Kf5cBexCTqtzovCYFaAfaBrjkPOl7mBjUG6c1A0
	1s1haB9BIdVYwALQJuOKMjzndqzXE2bgN15rZGgzG7VgmLf+OmRClms00v8F74XeJvejr9
	JCqHy2SjDV+45OlHaf5eq4uXYnPbqfA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780065203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eo9FrKG4xWr+2YP1w34Fe4mj/8vSxbGckKFB9ZC88xs=;
	b=IxBWZ8GwcqAO1R98EEvHogCzIy2No/Giskd0DPr9RDk6ugoPh08IDR6OrosWCLk2oRKQeP
	ne7tbQ7A6mEAACj0ZVgzdpseGdPmrJmdyojLicn3Vdevnl04N+jDXPnPz0bLRxy9J+1Ygz
	+Ae+bgczNtcRz1eyHCW2tIc2rKVNIrE=
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
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH v2 2/4] LoongArch: kexec: add KHO support for ACPI-only systems
Date: Fri, 29 May 2026 22:32:36 +0800
Message-Id: <20260529143238.169169-3-dongtai.guo@linux.dev>
In-Reply-To: <20260529143238.169169-1-dongtai.guo@linux.dev>
References: <20260529143238.169169-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D19EF4000B
X-Stat-Signature: 1a958bm8o68qkcqkd6443mj7is14kzrd
X-HE-Tag: 1780065204-852582
X-HE-Meta: U2FsdGVkX1+NYBu019UVi2f4XYgI5rPRFPRT4OFW6N+HFoiKAtfspnyOudt/kEgcnZ7N2zY+HNpjRkGXhTObPJWvEnxGy4KVlxBb0s9daLj5HLXjl34ukf9wsk/mVxK7aUTkZtzMSnCXP93QQakd/do4KME0mD0yO1ZA5gJP1C8OkyxTxc5KArkOlcfQwmp68cVbOjra23gqOKPO/VMCze6D4ysu9FW80QLbUix6Se1BjTwrjlDaTQknYv1tZ8rSLuhBkaSbHIjKIo3rfIY8SwZq9CdtOOHS1UxbfUCnMffA/pl4GTX7Vi8c4ZgTCH6QyopehwG3xKujkohnKvcq7ZgbDxjDXSpLD17yizJcdndV5HlHaU8fvPuPJyx4QvsRTlTR1ZFFhfho6HwGUXYW9Ndd9vc3r0pJ4aHsQtfjNIYJyEn+vVdDPo6Iq+ca5wYbifW/pfSdLSSiGcn6cdem3VK1mE7p0RIhe4lbjc+rgBx4FepefAgyANykp1Npw1nUbpyxjR44xjPWjLESjvcevSaApnQuTMWBclsLsnjVdoaTIUSydW88d3F9kQZNp1hQ+2l1M2aTAQfpR6fEkfGAo/s8wZiDEFBYKlgMr+wbqBJ3T4tQq/ie6wWm4prVxPve3rRolQhXEcqedp6HUCxmotSwBBzPAk1DO8fUE70OL7+LkcJ88l00jzLP0nGYfOizN8DaLy2S8WdtYLWrkGuWGND1cBEhg8wXX/94BhWZy/HQoQwBajm2gdomX8yd8znacEt2nABege2lkg8EYvQQwxwqO7cnTCkVYRbfMLMlGbSfjJB3UGuMXbGmMsmu/KsHCQPX3DltO6ND20MP7T3tzif9aKOwBJqNEtskXWMsSBpqlgRMm0m1fddKhb75z7h8xqCiJW7jZ2GI8a24IExJg5Y7z5WMc8ZkZsQY5gxSsx10hKrsbzFNVjUXf8tvCKE3da7hQ5YzM2sD1xaEW/f
 whWoVl6c
 J5UMBh05kmRWgomGfAG1Tb3kUbXAx/ujsXN83WGi3LwOtEsmv7xSqYU58PRl2sUTECZ9rAtpqmyi18S13+uBbm59TvOVarSFPqE/8HiVPxvtoxRRvBd7KJe82YQtNZCUSvLrqa7uzzCPttelA7Qi7DlzkLrcAjxzWHIa3w3MS9W7oKowz3tZ+ETZ3cbsOaoyh6qxVGLmN94nuiQgji3711xg/81JAnYV5nsZC
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
index 130f1adfa515..4ee9a433d2de 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -308,6 +308,17 @@ void machine_kexec(struct kimage *image)
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


