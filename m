Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E95606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FXCOndxr
Received: by kanga.kvack.org (Postfix)
	id 70DD16B05C1; Thu, 29 Oct 2026 13:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE786B05C4; Thu, 29 Oct 2026 13:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4BA6B05C6; Thu, 29 Oct 2026 13:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32A306B05C1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:30:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0AFC1A050A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:23 +0000 (UTC)
X-FDA: 85376352726.09.D0ABF09
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	by imf12.hostedemail.com (Postfix) with ESMTP id C878A40012
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FXCOndxr;
	spf=pass (imf12.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295022;
	b=d36F+k6Be9Sh32ryvhODN3xCJApoJ+b8ThneuaYDtqCTzO3ire8HtBV7yqZT3d8wb5frdN
	/L2XJ4T3BKZ9W2CpdfAjRuz3C0+oYwIjDCJJ2Yqm6eq+z1vO4wqv5rdBH68KU7rnJ2Z+Mn
	/q8l+GLvNIckDMr3glYUe8OsARvi880=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FXCOndxr;
	spf=pass (imf12.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAtuW+PmqcIRrD32GU2FmHnRSvRZSE8WSvkIZYFlqEI=;
	b=1uT38rg7nz3emuv5YdyoYK7cMDN/X0XjFlSc8xJHtPOpJgxWct0wamRyiGQN6+5PyDSgSh
	WuIQDbQilMNKx6Z87EZUniGseyg12GRwAXxky+ORWU/9niNB7SmQ8+WVwcKNQKroE3G3Wt
	g1BAwHtwgUg3WDbeVO2T1swdx7uX7Qw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BakrBcWbSK1C/V/NJmrPg1yKTLbeIP3Nrz+xI4DnuzI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295014; v=1; x=1793899814;
 b=FXCOndxrulaEk0PxCyRH3ODvX5d3H9KFQ/BLQhZ/42tZQJIVurIT+3imfuqAwzD1q+Y1BJnD
 4JvTGc7qolIhrjWi2jfh9huotl7MPypHZoqmKTMBsCMiCGKHpNDFW9Gf6EAizwVBp5O0s/yPpCn
 cySA8bh/YyZjIdDq9yN5mPho=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0e3683f53b12271c;
	Thu, 29 Oct 2026 17:30:10 +0000
X-Mizu-Trace-ID: 0e3683f53b12271c
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration table
Date: Fri, 30 Oct 2026 02:29:48 +0900
Message-ID: <20261029172956.20791-2-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dj1o1cw53o8mscwnucztk5f6kennupgz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C878A40012
X-Rspam-User: 
X-HE-Tag: 1793295019-855506
X-HE-Meta: U2FsdGVkX1+aPFb+s+un+IQ6/TuUw8BAN5CJNRamk65VjIR5jBPx2ykQzHzo0MrpWcziFj2gHoHLaRqgLF/PpiO/ARnw5Jt+3O6AF4Bj0XgxVu9YGvK86Gr0xK84u21yg138q6Hrv2K7tnwcDZvnDCN+ZekieEiAwVxNwsIUZL0DGl03zXB1+D3GUyp+6pN5R2I46/IQjUL1jKn2O0pIPehNfNLX3w9l63MQ+OMCBjTZXnlwVs9UKIjMheP9+SnjECY/wRZOWmlSatTdUtRawXMdJ/sgPZxYydeF2ZFJJDo/c4srKnNC3hx2DnM30BzwegmMOhKvNQJaefNH1IE55+6xplYiQL5kUsSUEj8UosCotZ3F+8jX7OIFpY63ocFuT9v1R4Gn9l3bsvAelalR1xjMwOrO0HghlvrdReDf3foAzC74OYql/RGf5rTiNTk0cj/LcQGqUS+p6RHucLA0hxyqKOwvgMcugS7Suf9YDggY6M/TmHhdEkTsz6wp18/ZJy+8SiLckfjNHYmck+8yoOuOdnI64qvqUrVULcB1Y7TYMtBU/6gOCQR8UK/biXvFtsIvAadfLm7ptB1+bJ5MJPuT/PR/lfajCBdScDqR8x1RXMBKr1w7tJza8I1Z2q1zNJXiwVkzd/4nhf6cGucnG2JlmYuj9DjS0EIraBT614hhXfqx178nvb1YBxNHwicVu1TWoUIU9kdHw0NcND1DYeKAfejBwjWmABBBaFJCCmdhne6TBOYMYHwmSfbEPZGq708Pa0EqUxPAGucPeTUedHRYGvaWEUpJT5/pccLAaNuNEmhQfFIVh25k9JYLrTx2Zn9G36DjGomK8RL5AigkCPFh9V8Zy83hsabvPtrQZ9ySBgq72+HT2aAmPMAM3JQXvU/9RIhVkY/gs+lRtj714qWXLwl6xRFgS3AyDWjK/I2NjLX9OfKT/2Wcvssdsh0iU9AYJb51a8b4kf2cYvF
 W46iqbab
 uTkDCTkBnikXSW7Ng+oOis45+kw2VC97H5uda8/5MKYTDPumqiylkpFphCCY3W3zfpbizngtVIey5EIeABfQ6G5DX9k7KPumOnFs/QVrnukOEmr2X8ca/3f7M2VabHDHnXGyj/cikgjCpr2uQtI6HarpytTCx159DCVMuJnv3QHg1u7QSyc/quU8g8erKYTSY5P3nTlzyWC3qdNdNo03Ml7i8KJN8zTY5avgSqsWKNk0n5HsgzJ+vpo6EGoN+YCIGvEjM5yKzEAhfCu5mA1CpQh85E0m7BUqb+5qY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

KHO has to give the next kernel two addresses: the KHO FDT and the
bootmem area list. arm64 and riscv put them under /chosen in the boot
FDT. LoongArch systems booting with EFI and ACPI do not require a boot
FDT, so KHO needs another way to pass this information.

Add a Linux EFI configuration table for them, under
LINUX_EFI_KEXEC_HANDOVER_GUID. It points to a struct linux_efi_kho_data.

  - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
    Each kexec'd kernel is given the same EFI system table, so it finds
    the same table.

  - In early boot, efi_config_parse_tables() reserves the table so
    neither the page allocator nor kexec segments use it, and calls
    kho_populate() if the table holds KHO state.

  - Provide efi_kho_update() to update the table before kexec. Map the
    table during boot so updates do not require allocation or mapping
    at panic time.

  - efi_kho_table_found() tells architecture code whether the table was
    found at boot, so it can turn KHO off when the table is missing.

Only the LoongArch stub installs the table, and only with
CONFIG_KEXEC_HANDOVER. Elsewhere there is no table and this code does
nothing.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 drivers/firmware/efi/efi.c               | 68 ++++++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c  | 22 ++++++++
 drivers/firmware/efi/libstub/efistub.h   |  2 +
 drivers/firmware/efi/libstub/loongarch.c |  2 +
 include/linux/efi.h                      | 40 ++++++++++++++
 5 files changed, 134 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa..e409e4a57378 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -24,6 +24,7 @@
 #include <linux/initrd.h>
 #include <linux/io.h>
 #include <linux/kexec.h>
+#include <linux/kexec_handover.h>
 #include <linux/platform_device.h>
 #include <linux/random.h>
 #include <linux/reboot.h>
@@ -62,6 +63,7 @@ unsigned long __ro_after_init efi_rng_seed = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata mem_reserve = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata rt_prop = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata initrd = EFI_INVALID_TABLE_ADDR;
+static unsigned long efi_kho __initdata = EFI_INVALID_TABLE_ADDR;
 
 extern unsigned long primary_display_table;
 
@@ -629,6 +631,7 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 	{EFI_TCG2_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"TPMFinalLog"	},
 	{EFI_CC_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"CCFinalLog"	},
 	{LINUX_EFI_MEMRESERVE_TABLE_GUID,	&mem_reserve,		"MEMRESERVE"	},
+	{LINUX_EFI_KEXEC_HANDOVER_GUID,		&efi_kho,		"KHO"		},
 	{LINUX_EFI_INITRD_MEDIA_GUID,		&initrd,		"INITRD"	},
 	{EFI_RT_PROPERTIES_TABLE_GUID,		&rt_prop,		"RTPROP"	},
 #ifdef CONFIG_OVMF_DEBUG_LOG
@@ -806,6 +809,23 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 		}
 	}
 
+	if (efi_kho != EFI_INVALID_TABLE_ADDR) {
+		struct linux_efi_kho_data *kho;
+
+		/* Keep the buddy allocator and kexec segments off the table. */
+		memblock_reserve(efi_kho, sizeof(*kho));
+
+		kho = early_memremap(efi_kho, sizeof(*kho));
+		if (kho) {
+			if (kho->fdt_addr)
+				kho_populate((phys_addr_t)kho->fdt_addr, kho->fdt_size,
+					     (phys_addr_t)kho->bootmem_addr, kho->bootmem_size);
+			early_memunmap(kho, sizeof(*kho));
+		} else {
+			pr_warn("Could not map UEFI KHO table!\n");
+		}
+	}
+
 	if (rt_prop != EFI_INVALID_TABLE_ADDR) {
 		efi_rt_properties_table_t *tbl;
 
@@ -1171,6 +1191,54 @@ static int __init efi_memreserve_root_init(void)
 }
 early_initcall(efi_memreserve_root_init);
 
+static struct linux_efi_kho_data *efi_kho_table __ro_after_init;
+
+/* Did the previous kernel or the EFI stub pass a KHO table? */
+bool __init efi_kho_table_found(void)
+{
+	return efi_kho != EFI_INVALID_TABLE_ADDR;
+}
+
+static int __init efi_kho_table_init(void)
+{
+	if (efi_kho == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	/* Map it now: the table is also written at panic time. */
+	efi_kho_table = memremap(efi_kho, sizeof(*efi_kho_table), MEMREMAP_WB);
+	if (WARN_ON_ONCE(!efi_kho_table))
+		efi_kho_table = ERR_PTR(-ENOMEM);
+
+	return 0;
+}
+early_initcall(efi_kho_table_init);
+
+/*
+ * Write the KHO addresses the next kernel should use, or zeroes
+ * if it should boot without KHO.
+ */
+int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
+		   phys_addr_t bootmem_addr, u64 bootmem_size)
+{
+	struct linux_efi_kho_data *kho = efi_kho_table;
+
+	/*
+	 * No table: either the architecture passes the KHO state some other
+	 * way, or it turned KHO off at boot because the table was missing.
+	 */
+	if (!kho)
+		return 0;
+	if (IS_ERR(kho))
+		return PTR_ERR(kho);
+
+	kho->fdt_addr		= fdt_addr;
+	kho->fdt_size		= fdt_size;
+	kho->bootmem_addr	= bootmem_addr;
+	kho->bootmem_size	= bootmem_size;
+
+	return 0;
+}
+
 #ifdef CONFIG_KEXEC
 static int update_efi_random_seed(struct notifier_block *nb,
 				  unsigned long code, void *unused)
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 42d6073bcd06..0fb0d4041d1c 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -100,6 +100,28 @@ static void install_memreserve_table(void)
 		efi_err("Failed to install memreserve config table!\n");
 }
 
+void install_kho_table(void)
+{
+	struct linux_efi_kho_data *kho;
+	efi_guid_t kho_table_guid = LINUX_EFI_KEXEC_HANDOVER_GUID;
+	efi_status_t status;
+
+	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER))
+		return;
+
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*kho), (void **)&kho);
+	if (status != EFI_SUCCESS) {
+		efi_err("Failed to allocate KHO config table!\n");
+		return;
+	}
+
+	*kho = (struct linux_efi_kho_data){};
+
+	status = efi_bs_call(install_configuration_table, &kho_table_guid, kho);
+	if (status != EFI_SUCCESS)
+		efi_err("Failed to install KHO config table!\n");
+}
+
 static u32 get_supported_rt_services(void)
 {
 	const efi_rt_properties_table_t *rt_prop_table;
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec81..9e0034c1260a 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1057,6 +1057,8 @@ efi_status_t efi_exit_boot_services(void *handle, void *priv,
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 			     unsigned long kernel_addr, char *cmdline_ptr);
 
+void install_kho_table(void);
+
 void *get_fdt(unsigned long *fdt_size);
 
 efi_status_t efi_alloc_virtmap(efi_memory_desc_t **virtmap,
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 2b0c87dc9908..c2df097771e4 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -74,6 +74,8 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	efi_status_t status;
 	u32 desc_ver;
 
+	install_kho_table();
+
 	status = efi_alloc_virtmap(&priv.runtime_map, &desc_size, &desc_ver);
 	if (status != EFI_SUCCESS) {
 		efi_err("Unable to retrieve UEFI memory map.\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index aa15ff88539b..253e98bf9922 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
 #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
 #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
+#define LINUX_EFI_KEXEC_HANDOVER_GUID		EFI_GUID(0xc941b6c7, 0x7b3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
 
 #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
 
@@ -1273,6 +1274,45 @@ struct linux_efi_memreserve {
 
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
+/**
+ * struct linux_efi_kho_data - KHO state passed to the next kernel
+ * @fdt_addr: physical address of the KHO FDT, 0 if there is none
+ * @fdt_size: size of the KHO FDT
+ * @bootmem_addr: physical address of the bootmem area list
+ * @bootmem_size: size of the bootmem area list
+ *
+ * Pointed to by the LINUX_EFI_KEXEC_HANDOVER_GUID configuration table.
+ *
+ * The EFI stub installs this table zeroed on a cold boot. It stays
+ * in place across kexec; the running kernel rewrites it just before
+ * each kexec, and the next kernel reads it during early boot.
+ *
+ * The layout is fixed. Changing it requires a new GUID.
+ */
+struct linux_efi_kho_data {
+	u64 fdt_addr;
+	u64 fdt_size;
+	u64 bootmem_addr;
+	u64 bootmem_size;
+};
+
+#ifdef CONFIG_EFI
+bool efi_kho_table_found(void);
+int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
+		   phys_addr_t bootmem_addr, u64 bootmem_size);
+#else
+static inline bool efi_kho_table_found(void)
+{
+	return false;
+}
+
+static inline int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
+				 phys_addr_t bootmem_addr, u64 bootmem_size)
+{
+	return 0;
+}
+#endif
+
 /*
  * The LINUX_EFI_MOK_VARIABLE_TABLE_GUID config table can be provided
  * to the kernel by an EFI boot loader. The table contains a packed
-- 
2.53.0


