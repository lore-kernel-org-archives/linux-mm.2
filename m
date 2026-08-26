Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73921C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701B76B0095; Wed, 26 Aug 2026 08:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9446B0096; Wed, 26 Aug 2026 08:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF7F6B0098; Wed, 26 Aug 2026 08:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E86F86B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:04:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FB5D80358
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:46 +0000 (UTC)
X-FDA: 85143288972.13.4E1649E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95C7E100002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PyAz2+CV;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787745884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhikRt0HmqGxXvzztoXS5tGgSGD7w/+eDypjfVVuNCU=;
	b=kOrlK+1n+0JqPyfRHSjWV2yWyHnC3cl0Bd5hQMFHjHdLBVesa9FYZSiI6BixxDHePIQtM9
	Zrd+Or2EjWH7ueZf19n9npd1QW5Qn7rCgN1tvld8/GZEkE7JuWoTMNeQQRgBI5Pjfei/Gw
	EIfKOwgOSwUV6DuSY/vallCWO0vOXdw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787745884;
	b=XMdyXEuIHLDebWjyXE9tJIyx7owVJ//Zr6pHwV6Xg1gtNR9H8vl8O2qsC2CVKUDtEM+ueG
	8/Cq3xdxhQR0DitKabujDRxflqpjjwUdPTurMPAYd4T3m+qYvZzN8zgZ7y5Cn4a1PLcX6q
	m4Cih+fDUmJzD9/SqjZPPcG5vm91nsQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PyAz2+CV;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=UhikRt0HmqGxXvzztoXS5tGgSGD7w/+eDypjfVVuNCU=; b=PyAz2+CVX/MmA487mIUvti4/+X
	zDA4hLm7x0EkEu+dr1+T5Wmam3SKWWaSJ6cTvAT+FxzIu4ZOkaD43tFqMrOluM35SU2O2LtAY2H+P
	eQDeMxTeRUy8ho8AOqlrIqBGd7nqC2Ilt7ycp0cnQ1mwW1f2h/eWZW9jq1Z8r78nqpKIRaLe0a55i
	M1LZoG23NsekZL0h7bjuMdqOQkR75FohUp3dMvV4TQqqEtD71+E+Y3LGSn9XJtLMvB//VeNe1aCzR
	jpdggdqeZRaM5zi9RAYDm2AtgeOfg+NbiFSMWfmD7w3gxspgQGpdH4czTejkcb+4JnJuI7dvWhcYw
	L9AmG01w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCMw-00FCWi-2F;
	Wed, 26 Aug 2026 12:04:39 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 26 Aug 2026 05:03:52 -0700
Subject: [PATCH v3 1/5] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-hwpoison-kho-v3-1-6f79c4b605bc@debian.org>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
In-Reply-To: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=4813; i=leitao@debian.org;
 h=from:subject:message-id; bh=XZUS/f25dq0I8Z+98iNLJoB6vzCCwIuyygNx7FuPAYw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZKIy44p0OfgXtXkaiRAIy9xVaHpssqtdzOS
 lq7xv41s1CJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSgAKCRA1o5Of/Hh3
 bdVZD/47lVPd3xCInezUT9l7ojDgBYE3rG7/KqPxMTr7D26pl7QUZ5iRnmOa/oYXIODPtbMJNxP
 0AOlMnnBfrspZC6BaebOZMKGhL1fi9VwJ2VpShahrPm29UJG8CZ55YheG5Fq+tE+Uw5zrJHTYrM
 V0tpxo0LtP7Za7l/hFvgHJUmhoiHvKsEEKF61iaHuEFetuOAC/RiZjGLsl5r0Vuv6h9gq44dUZd
 NtIAbECTx05b6eMDlBbtTIVK1FStG0H4bL/M034ORA4zxC5SfGRXNFQA4EF2+MwyMHRa365bXkj
 +uOlUVIuo8nPwuQTiGryGPHzOvTQ9htIgEQQFM2DOFmg/K7tRU1YEiWoqjsz4nfoyU6stgzdUHm
 SnNP9vOsHfFaqQIhwKMRFIxEt3d2JvofMLuVvc84GN1hsb/tQF07t+LbNWphFk5sbdaxj1MOSlI
 hbYy7v6qRb6Ejz7wtOD7svHS1s4vzL0jyILVtLVnT9aKK3rosg5OEtQ0joYBsrU04gFa34UvMfh
 6VVD6JPtjMXH27vAEkmUlr83z31KG6+R5t+i99B4a4l7iyM+eVE9/C8MhKpiHUaYO8oxb+ZEGi1
 HWK2fRFU+2rQYnKQk8NmEvH1olCgdyY6LQeE8sG4DR1FWgTA18lMnr/0nROVTN1/EsddqeXn5Uh
 V2JggMOfw5h3XlA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95C7E100002
X-Stat-Signature: nzqpydr3kqpfx9wd35a5nw9hsixa3sej
X-HE-Tag: 1787745884-634931
X-HE-Meta: U2FsdGVkX1/xp5uphx405TN10PmGRtHMpyXO7tl7xsfypmDtZS77+17h+SFfcvQ2Qx7yYEm5to9lB+AA/uE4dBq0uXq+AZqxpWaToaiyUGNyamEdP05JycvEBzFLUmGzNycd0DkpCO8K7gYxuOtiiFOj3HuWgLT8fBbZeEF7y1qWSKL+EeDCr1jf+hZ1b2Oog+YwGSXeZq/90wkNc8oBPndsyxb85LQ0kdGyPHNUCv/8o/19zBQdGU5VKWb0gs2wCSQkWskO46j52Xc2u7lK6k4RBkU57unTCz42LCN6A1XzZIkFiWol8cuq9kKRtnfe3+jz5FdEGfOjxzk/ErnmNgpze5s+zGIvatZEnr63LJM6Tr4D2N3jK0Xsxb3FvZYcmFbLl7DY0GabvpPv1ykxjym+OQ26bjw7oO6vgGWQBRa5m/hQQ6ugVEkx3y7Mls/T0azw5BDJ0GkB8iK/z0spkBSvCgykJKFwrQbD2HWYVVxEuyYSrBmCM0IlVPxTlYNUoyOSv/2fwtPlUK8q/CjCNL7MiooFO3kK+mpL6YJ9xklXN6v0kGctM+cMyeIob2AjOGAkVGOe5N3Q9m5xB34LnNv251lfeT+ZKwnAgVkVqy/croThjRKRFWrjK7pGkcBcJ8g0RFw3s7K4Z8m8KU2QROhFWfFb18eggD61WVEB2DLx1/23IctpWfuscYrEhU7A7nDI/TQwD6mcz3IpQgb14V1HIZCHco55W/hV25e6FcEvjvRFupy2jo8r396RQk3YKb6Ki/dX/pXUXEeFgX1JcLXfew8naWvoA7FirqARBun+mNnyZCNJNAkCuR4a8fLSZehEHEbVNT7Emv8GENSNsI8SDgDNpeMimMom0FUZSEUgptvLtAmcLoKb2IQgVJ9XJKOHnwB4qFGNJswqk/E6H32DxncOjTG8u3RRTyQSJ20LnjF5DYbegGMLHULHLcMq75NSkQFZGC4Z1eXCq4t
 ohtZWK4N
 LHP9maWy/sBbt2zOZTMnp4f9TgUdmuG2i5kcPpw5iukzDuyp/44+T45KbWgayS/hM/CA+3SoEagR0U/NKa1ykGAvVMOzxC9L8SQz+vxj6H2w2YhRzdjOkmV/GZsOmdP1rjLOzy/o0Xm7WBTdTNGJEzzxVXEhte/d2wKDIlez8GFb5Zyr1iV3B5Fee2d8bBAbcBS5c+N5JGhkpzwog/KE4jhSkLChnbTvuTfUHNBzEUXqHd8F++aH3kMsgm0LG78TvIVV1qLVFZxQ8LIYy40JjFt643ytk2N/XrYGfd6VJPl5RjXlgUWk666giPQpGPkrnvqDn1AEiu1Bl9+G7oHXDArM7xVpmYfmJwNige8xlcSPWL6VyqWqtTDxenrC6DP4yndGlKgDDKpKVV7K3RIBfIvv0/DSff7Mhdz3DA3WIdwoyJbgHXFwn+KC/nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware-poisoned page frames are tracked only in the running kernel's
data structures, so a kexec loses them and the next kernel doesn't have
this information, thus, tripping into them again.

Add an EFI configuration table to carry that information across kexec.

It is a bitmap with one bit per EFI_POISON_UNIT_SIZE (2MiB) of physical
memory, modeled on the LINUX_EFI_UNACCEPTED_MEMORY table, and it rides
the EFI system table to every kernel in the chain.

The Kconfig symbol has no prompt. There is nothing for a user to decide,
so it is on wherever it can be, and it only costs 64K per TiB of RAM on
a kernel that already has the EFI stub and MEMORY_FAILURE. It is
restricted to 64BIT because the unit arithmetic would need div_u64() on
32-bit, and there is no 32-bit EFI configuration with MEMORY_FAILURE to
test that on.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/Kconfig |  8 ++++++++
 drivers/firmware/efi/efi.c   |  6 ++++++
 include/linux/efi.h          | 13 +++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5b..aafcd41bc0063 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -263,6 +263,14 @@ config EFI_COCO_SECRET
 	  virt/coco/efi_secret module to access the secrets, which in turn
 	  allows userspace programs to access the injected secrets.
 
+config EFI_POISONED_MEMORY
+	def_bool y
+	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
+	help
+	  Record page frames that are hardware-poisoned while this kernel runs
+	  into an EFI configuration table, and honor that table early on the
+	  next kernel so a kexec does not hand known-bad RAM back out.
+
 config OVMF_DEBUG_LOG
 	bool "Expose OVMF firmware debug log via sysfs"
 	depends on EFI
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa5..111e60479211a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -55,6 +55,9 @@ struct efi __read_mostly efi = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	.unaccepted		= EFI_INVALID_TABLE_ADDR,
 #endif
+#ifdef CONFIG_EFI_POISONED_MEMORY
+	.poisoned_memory	= EFI_INVALID_TABLE_ADDR,
+#endif
 };
 EXPORT_SYMBOL(efi);
 
@@ -646,6 +649,9 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	{LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID,	&efi.unaccepted,	"Unaccepted"	},
 #endif
+#ifdef CONFIG_EFI_POISONED_MEMORY
+	{LINUX_EFI_POISONED_MEMORY_TABLE_GUID,	&efi.poisoned_memory,	"POISON"	},
+#endif
 #ifdef CONFIG_EFI_GENERIC_STUB
 	{LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID,	&primary_display_table			},
 #endif
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b3c83516593d1..c7b4a37f760ec 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -23,6 +23,7 @@
 #include <linux/pstore.h>
 #include <linux/range.h>
 #include <linux/reboot.h>
+#include <linux/sizes.h>
 #include <linux/uuid.h>
 
 #include <asm/page.h>
@@ -422,6 +423,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
 #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
 #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
+#define LINUX_EFI_POISONED_MEMORY_TABLE_GUID	EFI_GUID(0xaf828a15, 0x0ef4, 0x439a,  0xb8, 0x6a, 0xd6, 0xd6, 0x9e, 0xaf, 0xba, 0xfa)
 
 #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
 
@@ -650,6 +652,7 @@ extern struct efi {
 	unsigned long			mokvar_table;		/* MOK variable config table */
 	unsigned long			coco_secret;		/* Confidential computing secret table */
 	unsigned long			unaccepted;		/* Unaccepted memory table */
+	unsigned long			poisoned_memory;	/* Hardware-poisoned memory table */
 
 	efi_get_time_t			*get_time;
 	efi_set_time_t			*set_time;
@@ -1271,6 +1274,16 @@ struct linux_efi_memreserve {
 #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
 	/ sizeof_field(struct linux_efi_memreserve, entry[0]))
 
+/* Bit N covers unit N of physical address space, counting from address 0. */
+struct linux_efi_poisoned_memory {
+	u32		version;
+	u32		unit_size;	/* bytes of phys space per bitmap bit */
+	u64		size;		/* bitmap size in bytes */
+	unsigned long	bitmap[];
+};
+
+#define EFI_POISON_UNIT_SIZE	SZ_2M
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*

-- 
2.53.0-Meta


