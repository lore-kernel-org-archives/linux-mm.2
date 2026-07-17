Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D99A5C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C5C6B009E; Fri, 17 Jul 2026 12:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEDA36B009F; Fri, 17 Jul 2026 12:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB6A6B00A1; Fri, 17 Jul 2026 12:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACB26B009E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:32:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D4D3A0170
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:03:38 +0000 (UTC)
X-FDA: 84998436516.16.9B74F2B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4D68920013
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:03:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="YI//dAPL";
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784297016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2GaxUYWUCDaIqy8gzSpgejxnU7gdQfT7g2QywaFwc0=;
	b=x2FEPoUCg/RPadJ+8+Fir3GeqySnzU2gUsDCpr0kGuir1S0TqSUHVppKdZBwg1QYMwEU0w
	a9lc7cDq2D8Us14JP9midRmLeWk2QTXmaFRgTxherVnQKPDdr6XNzPZgFx2mK2XQKNcBPT
	q3bR/2kT72/yq63EUjpOj8OmRa8SDOI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="YI//dAPL";
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784297016;
	b=eeW3bOJTbDK4fxWUeGAdy8cikvrjLsVdaL/EC4b0D33+u6WVJr4gRBh5dpxUkLdGkTVPoI
	YEBeDxK7d8+ziRfX0za7cyvj3HwXXqUKI4tjjehkEKhCWfWJy0XoGo5GzoCxHrSSRgG4Ti
	VQTffrI0pGn1RCRwETs97MIUvG6iGV0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=J2GaxUYWUCDaIqy8gzSpgejxnU7gdQfT7g2QywaFwc0=; b=YI//dAPLZO08urhp+sC6FCsYiC
	0Crami2wSzMhzH+KTpLRmVqsdCQF0cv5zpjgDEROVcDlKdzTMJefzk0nmtJ5oKx2bMZSl8VoLrJyP
	Q0brojTNScDL0sVT502iCpHkcWX48ywvESEIugiNtLwtdPqDG3fK/OefVlh0TFTdGvW+fqrmX08UQ
	/AXhZ6mPtW6o4OSTGF4HAX9qI6MT3khN3u34t93xdrUZF35Nw/Fc23xb/PiHAsHouuOBTSbSebfun
	kCTje5dWsHkzVr/bOk5p6mcwtjOV8zVtafC7jZLEpjb/Tibgkm+j0neXYM80Kp1dUUWlmDhRFkjty
	LcCoVwiQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wkj9x-004eBz-1K;
	Fri, 17 Jul 2026 14:03:25 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 17 Jul 2026 07:03:03 -0700
Subject: [PATCH RFC 1/3] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-hwpoison-kho-v1-1-9c5eda551998@debian.org>
References: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
In-Reply-To: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
To: kas@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, rneu@meta.com, riel@surriel.com, caggio@meta.com, 
 anilagrawal@meta.com, rmikey@meta.com, linux-mm@kvack.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=8189; i=leitao@debian.org;
 h=from:subject:message-id; bh=vPgMXj6UGLwZDbnDtUhmkDsnpbNc2LeXNI0jdCRgVV4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqWjYjczQ45fPZAD6kwZTh8FpTKfnCNKqQPecz7
 LXC2bOWJ2yJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalo2IwAKCRA1o5Of/Hh3
 baowD/9k1854+gfCADDCiFqbZinAYv2jC1klsAWapV0aHHY5Gw9J4Oxk3CjrmW1LcrN9X54gxoc
 24DZci71mTERR0nlS2hEF0PObEoqLOFuAWY2cIwN9DuJCKb1g2hAiF++Namyuk9/Mu3TZuvnuwC
 ylqORXCB8RqgPf4AGwCIsFjTOI6AGoVF4paU6bnBnXVlLiAwVlts0m7R3OQDGOCm7TjOmThcLVD
 CS2fYk2wYDQNELc/GjNV0N3Zn8CFOxgmny0/Vy1jYSUDJH6kxqZWFR1JU7/FcaFSl++ZAiU0jDt
 +1PqyeIhvznP+5bvPLaL8JhOve2r1GCoVndTl/sWGUHRlh7oRuReSaLafOnUFlm37qv8ePDDwKV
 F/RFO6JXhwS3G1ouuyScF+tCv+yPdDBd3dfzb3qhHA8GKpQShK02BS9YGyAxu9rytL9hBegqxCk
 gcE3BLz+hYBIVUmb61aeBR0RbR7eRuM0bgJLq+4RAIv5KzsdV1k2avklBvB4mWCQbvW87H6XQ/6
 mRRNLGXlbU+ffq9lQ+pXhoM8j5+JslSxxlLczxQUaclqNLAGfYsrng8rXJJyG2lvbalqLUFsTz+
 rB0QASjJjz07IkqNixEGcGIAuXzPnRd32cJydPYwrUFuzVdEl8OZpcNKLNUPQ0LjS79B45dEiD5
 cF4e/U/7xdm1lUA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: qmfq7fgz6gz3ib44e4xrujkoqqnyk653
X-Rspamd-Queue-Id: 4D68920013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784297016-501665
X-HE-Meta: U2FsdGVkX1+M9vNs+r5/cPg6OTNP5tfAfXdTixk3+Cr2lI7vp49pRehfpWZxY7DeJ2t2YW++sBKFetVzLj1RUhJ925s2asX2w68gR4gAy1qUT/AVBLFoZlSU4UaaGCJym+D0jgJ0L8tzKgxpKpR2GCdxZh+PrBNyQ8PiyKN7zOjjIRpRPaAGC0MKIov8kcxkC5n+qzzIUKUFfhRTJYWOyaMJPb3XU9encUeMCeeeuJlY6jW0Q+T5pe8fw4WEIBulbDErycRd9WSNwMGtJkA781Gzi3h6iyZwYXK6zNV76/C6RG0sKAlSx3t/CPEeDWh9OMQfqW4GxQmFaX5YOWXg18C8/zdhXA/xsKv1dBQ89Nlb9/aFc4W5N1+6hm/ZzGcWLcGPpdesOQbH0iy5DWxUGQ8S4KflxJbXeajZlD4miOtxXHoOd4tgEx4Y5hMncD4C8BaDkH/u9S13UEPZppwBYV0n6yyqbY5Hc3oWphhduUNm7QBNGunUvW5j9JDJSRSkjdlyWepADrN3AhlkuytxqD6Y4H7kQkDFZKwe32sD/32qgSXLec+xaA6v9+GYbek6g7RhUknGTzeokQfY409sCFHSoUrOlrerhw1qM2cgPByhPP/1xFh3cj3tGMzzGfJS7eU7SHgRvM/PCQpknBq/liHqXD31VoHwNctdBkBkO7487OsoxNM+SWrsysDD7TgTuFr5BigyxQqdz+f3y6g3GiNdMjRuoOKLqQzf8qZfYqcIW9HFIDbZbAfcYTIHJOKKQD6g+APkRVV3xwsf3jSmmjsIk2Z4F5CZG8RzFL0buckoHcd/DC3Twz/SfgyxUhaz+/KGKeGf8BTCKU1Aw+E2ciRQSUjGaA+mIk7cKc7dfeuRss2U1WMk2WYMuhNi32+U/DhuWhBbwjKidX4ybexOgg3VpIBJ4LMbf4XLeiTEN6DKCm6JaqAq0+PuXVs25nucZT/SOQRsNjs+FHsVKjV
 urxW3/X3
 1+/X/XGwUbkUH3SZGphaZJ/kMF0T7teZI5ZSBETuss/DQQncaJaRESRG1faP5d0BM391/nP38kJpzBH7y+P8oaINLsc6IvrZegI650ovA0/PsfJ275nEwDaFnkqHOln8bvr3T0GuA1BBywUGfSEVPyuQmtUo5gVdpRhRbY69ffGmquMcbxm2MUlPPcKXXTOhcEs8kHgpMUkNLEHi/1qsrmeIpoxYgfd3bwZrz1CD3Pi1LSgdqAgQtpxA06EbyD9ET1ejdu/g+rD4NJjmx1T2KRLHy6v1/dfvsnxL53nglCUYPBnKvq/HzOmKznS5ojifSBr6OlsSZxNy6FlspAszcHpqR7BsNzYx33EwGJvS92R0rgEta/9Wvi60IXvPuXdlqlRwKj3m+wcJ03nHZl8JbGEH5UmnmIOtvqRxt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware-poisoned page frames are tracked only in the running kernel's data
structures, so a kexec loses them and the next kernel hands the known-bad RAM
back out.

Add an EFI configuration table to carry that list to the next kernel. It uses
the same growable linked-list layout as LINUX_EFI_MEMRESERVE and, like it, is
installed empty by the stub while boot services are still available -- a
running kernel can only append to the list, not install a new config table --
and rides the EFI system table across kexec.

Define the table and install the empty root here; the record and reserve
paths follow.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/Kconfig                   | 10 +++++++++
 drivers/firmware/efi/efi.c                     |  2 ++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 30 ++++++++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |  1 +
 drivers/firmware/efi/libstub/efistub.h         |  6 ++++++
 drivers/firmware/efi/libstub/x86-stub.c        |  2 ++
 include/linux/efi.h                            | 21 ++++++++++++++++++
 7 files changed, 72 insertions(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5b..0e4ccfd968b87 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -263,6 +263,16 @@ config EFI_COCO_SECRET
 	  virt/coco/efi_secret module to access the secrets, which in turn
 	  allows userspace programs to access the injected secrets.
 
+config EFI_POISONED_MEMORY
+	bool "Carry hardware-poisoned pages across kexec"
+	depends on EFI_STUB && MEMORY_FAILURE
+	help
+	  Record page frames that are hardware-poisoned while this kernel runs
+	  into an EFI configuration table, and honor that table early on the
+	  next kernel so a kexec does not hand known-bad RAM back out.
+
+	  If unsure, say N.
+
 config OVMF_DEBUG_LOG
 	bool "Expose OVMF firmware debug log via sysfs"
 	depends on EFI
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa5..f3b799930be44 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -55,6 +55,7 @@ struct efi __read_mostly efi = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	.unaccepted		= EFI_INVALID_TABLE_ADDR,
 #endif
+	.poisoned_memory	= EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -629,6 +630,7 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 	{EFI_TCG2_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"TPMFinalLog"	},
 	{EFI_CC_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"CCFinalLog"	},
 	{LINUX_EFI_MEMRESERVE_TABLE_GUID,	&mem_reserve,		"MEMRESERVE"	},
+	{LINUX_EFI_POISONED_MEMORY_TABLE_GUID,	&efi.poisoned_memory,	"POISON"	},
 	{LINUX_EFI_INITRD_MEDIA_GUID,		&initrd,		"INITRD"	},
 	{EFI_RT_PROPERTIES_TABLE_GUID,		&rt_prop,		"RTPROP"	},
 #ifdef CONFIG_OVMF_DEBUG_LOG
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f27f2e1f00199..2d873bccac481 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -774,3 +774,33 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 			efi_warn("Failed to remap data region non-executable\n");
 	}
 }
+
+/*
+ * Install an empty root for the poisoned-memory table now, while boot services
+ * are available; the running kernel can only append to it later, not install a
+ * new config table. Shared by all stubs (x86 and the generic stub).
+ */
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void install_poisoned_memory_table(void)
+{
+	efi_guid_t poisoned_memory_table_guid = LINUX_EFI_POISONED_MEMORY_TABLE_GUID;
+	struct linux_efi_poisoned_memory *pm;
+	efi_status_t status;
+
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*pm),
+			     (void **)&pm);
+	if (status != EFI_SUCCESS) {
+		efi_err("Failed to allocate poisoned-memory entry!\n");
+		return;
+	}
+
+	pm->next = 0;
+	pm->size = 0;
+	atomic_set(&pm->count, 0);
+
+	status = efi_bs_call(install_configuration_table,
+			     &poisoned_memory_table_guid, pm);
+	if (status != EFI_SUCCESS)
+		efi_err("Failed to install poisoned-memory config table!\n");
+}
+#endif
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 42d6073bcd062..008635eb5027a 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -179,6 +179,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 			 EFI_RT_SUPPORTED_SET_VIRTUAL_ADDRESS_MAP);
 
 	install_memreserve_table();
+	install_poisoned_memory_table();
 
 	status = efi_boot_kernel(handle, image, image_addr, cmdline_ptr);
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec810..44436869c4efe 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1169,6 +1169,12 @@ efi_enable_reset_attack_mitigation(void) { }
 
 void efi_retrieve_eventlog(void);
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void install_poisoned_memory_table(void);
+#else
+static inline void install_poisoned_memory_table(void) { }
+#endif
+
 struct sysfb_display_info *alloc_primary_display(void);
 struct sysfb_display_info *__alloc_primary_display(void);
 void free_primary_display(struct sysfb_display_info *dpy);
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8f..f90de11bc8855 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -1023,6 +1023,8 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 
 	setup_unaccepted_memory();
 
+	install_poisoned_memory_table();
+
 	status = exit_boot(boot_params, handle);
 	if (status != EFI_SUCCESS) {
 		efi_err("exit_boot() failed!\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b3c83516593d1..7787eb8d4e4c1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
 #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
 #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
+#define LINUX_EFI_POISONED_MEMORY_TABLE_GUID	EFI_GUID(0x78a5bf07, 0x7d2a, 0x2889,  0x16, 0x31, 0x63, 0xd4, 0x56, 0xf2, 0x83, 0x50)
 
 #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
 
@@ -650,6 +651,7 @@ extern struct efi {
 	unsigned long			mokvar_table;		/* MOK variable config table */
 	unsigned long			coco_secret;		/* Confidential computing secret table */
 	unsigned long			unaccepted;		/* Unaccepted memory table */
+	unsigned long			poisoned_memory;	/* Hardware-poisoned memory table */
 
 	efi_get_time_t			*get_time;
 	efi_set_time_t			*set_time;
@@ -1271,6 +1273,25 @@ struct linux_efi_memreserve {
 #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
 	/ sizeof_field(struct linux_efi_memreserve, entry[0]))
 
+/*
+ * Frames hardware-poisoned while a kernel runs are recorded here so a kexec'd
+ * kernel can keep them out of its allocator. Same growable linked-list shape
+ * as linux_efi_memreserve; carried across kexec via the EFI system table.
+ */
+struct linux_efi_poisoned_memory {
+	int		size;			// allocated size of the array
+	atomic_t	count;			// number of entries used
+	phys_addr_t	next;			// pa of next struct instance
+	struct {
+		phys_addr_t	base;
+		phys_addr_t	size;
+	} entry[];
+};
+
+#define EFI_POISONED_MEMORY_COUNT(size) \
+	(((size) - sizeof(struct linux_efi_poisoned_memory)) \
+	/ sizeof_field(struct linux_efi_poisoned_memory, entry[0]))
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*

-- 
2.53.0-Meta


