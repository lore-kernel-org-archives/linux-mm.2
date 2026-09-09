Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31EA2C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFC26B0096; Wed,  9 Sep 2026 09:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A9D6B0099; Wed,  9 Sep 2026 09:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E2F6B009B; Wed,  9 Sep 2026 09:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A57BE6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:05:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69445A0202
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:05:54 +0000 (UTC)
X-FDA: 85194246228.16.A5FF971
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 80F3F140008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:05:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=DYC+Xp5c;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=DYC+Xp5c;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959152;
	b=1HW/ZxXhUNOwe9SOro0mOlZKixwUXUgR7Wtf5Z/1r/AKmTurHVyFdSyETFJJ/pz+Oy+3Uf
	YBGfAr6sL8yYNLL6e9Mg2myS1T7kgOIMOkg1+ZExDvLnskAMV98+cEwRqr46Nu9qW9phLV
	o3mb22SE5Uga+Ze65FvdMz6wQGfPZys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLp0/6osqzYu1K79RxqaODeJezxTORDI/HZWm8RTcnE=;
	b=Mtnv8UpnspP91zKZoTx9NONZbdFdsRtNGXQetw/9lwltMXq8szrWWFmeaA8NEUwsf/bLTp
	3n2kp4Mz3AGPuj48GWwbuUNANZtgltkWMFC8f0Zr/KXzb05yfx3YN8SYHgEeyDwqflpKXa
	gYlDMnfrVCoiOxLa9gWJeOg7JX67wuY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=fLp0/6osqzYu1K79RxqaODeJezxTORDI/HZWm8RTcnE=; b=DYC+Xp5c43ihxjxqgyBzUWuGvH
	OvrZVuEMqQGQgQaImD+gdQeUa310L9Q5m3jEu6y3giBi+QYcNJerc3cSPP/EXUXH2aL3FHh1g1vu7
	nXF0SVYaltmLCxKobKfzZPIXB2MkY+opTT/GjLak9UQodGHA06dmqWww7s9HBInF/2iLj9IRiRk5i
	rPk1CFQ2JItFsGKL6o1cc+iZhw0n2hXEc2j6IBjMzdc/3pJhdN/DDqH6RHEGlHVFCp01gIChxSla3
	pgDo4yFsvC5V8KnQsJ+KGz29tvzDm7/UszGGAJSPzGy9TyKnU2D3hb1nkfTdRH/IddFY8+T0r752W
	LYudlCfg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4Hzh-0034dQ-32;
	Wed, 09 Sep 2026 13:05:42 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 09 Sep 2026 06:05:20 -0700
Subject: [PATCH v4 1/5] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hwpoison-kho-v4-1-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
In-Reply-To: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=5629; i=leitao@debian.org;
 h=from:subject:message-id; bh=ctiHNkWke05Q0iaiTEl4WUQNecfiVhJWf2TuHJC4Tno=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqoVmYv6/F2rp5R0pqzLMUowHz37sQM9qWNR5x2
 UuJzfxpaNuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqFZmAAKCRA1o5Of/Hh3
 bfNHD/0apJ2TYY/PkRtgB2eQI58aaL6LZZSdIvSHzd5ZQG3H/NgtttpYjBPyQ5g3FNs0bGo7NEM
 9+zRqvaatJOs8qOLNakhUerv/PJNYpZKHji0Nm/qok+8Qk8eSVwyC1iCg6oNwYN09a4TbMb8wc7
 3kZgwEQYBtEylUQ42+a4P0TXQgCzIFk55ZH1vVM/5vcLrTENg5qa8n6OnbbCyDVwZumfiLd2/3F
 Rd7olMYEJKE92ZCWRP1cGXohvSGxUfJA1DplypSNwcusEsFSwV7YVc+rlBKpOvby/KYt7b5Jcw5
 JvF2ewSM2f576xh6R4pTenjcZVcBfBji8d086jQ7EFqkLCIDQsU6QAo15LQZYCJvHuTD4CbYFuo
 9ykGUChQq9HfUxGzVyuZEcZZK1DcVjWv8uJHTK8W5I63pLBt2RdSdrRhT8rYg8wMjdJ2NPyu7rN
 8qSHc5s1e/adnS6JBLkK0We5xHNaFlber0z3gULBMD5D2W1b7xn81PwynMwtrrNIRsdcKPcCOmi
 IL9oFYTZRoU7WOIkNLwRPrphx3cpsL9L7zReLWaVzt2uXigRk+SajgHza5wMMt9akA3ljDpFcvR
 llSWuV9hAWlbz0k7nbB1c0MGCa6qo31FFQLEKKmrkbFnZBp1N7E2XzF5grQOcVnEIBud5sNjtjk
 ZhRCZ8I8nSt2Wpw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 80F3F140008
X-Stat-Signature: wbw3pw8bdwrqjm6wn8dofki4dzo83hwa
X-Rspamd-Server: rspam01
X-HE-Tag: 1788959152-296880
X-HE-Meta: U2FsdGVkX19cnh8LIsgLP5kDmTCeiJa9EGqbnDAOZ4GPytOxgTp8U5VIgWDvmHdLlWSeqeKsaHwmlo+PLPLJH0FAxFPrvo6f2mp8MU7/pB379SFY4+6SC9EExrceYI2VYAwC6DxOrbLzQWO/uw5u9SbRhWg97LjvOY5cG13ZzSKEb4NQ50KBBDUO9QfKUcHj/wIJ5YvBRiIT+eF4dBD+bGd4C0X4KpI74/GN1piWwFfnszaMe+iubiPpv+PagAfnK40fMc4tZwZWWM/84JNvgwdQrPa8xTJeLzvJ7soYxON9C/uwieF/goZJYUDUVKYheCV05yZ7l12HyCQlWg8JwqF8SrxRItHuVIaY0qT4fiVfui+wNve88Ql5nkRsqelJZ9fsLlp+GAEy1VASRcZSu0vKa9Si/+xQ94QKoCw4xyBlUoMI7f21SGWlHgXuPinvyZEYWplSyfyBa3ByImSUhMcG7syM7QVNnWakOwlcQJnlEPtr7T7rMZeXFo7J0FpxXYivuIjb+MyTFPfs1g7dPX+xei2pvd6turtxQTUFB/cHmWlo//DWLgI91vDk0T6aGV4y8XwzLVL0F7h0oBMSlQvHu9MmhO4/AREZwtJNf4CxidnpL/aEoH8lU5Alljva0B2uzmOvTdgOce6YTeEqVEtnm/srIRSmEkYx9JtqLZkIO2mtKfSpG5iaVpzOfMyPOeq/fqzWEQDFHBQt1Twsv1gt4Ty/8ED+CfViu0JyBWMW/r14gO9W0asfPrLrFzLxQshpIuBtwKXCKnxpremZZBxe6yNBvd+NqvdMAiyB6o6rdxmzGgq5/pXbrgderQEt5X+HFgPBuGKIO4/fGsZbHdUf22mTLGqcJto8/Syq/pVSclBCUXQ0Yn9bL5yWdLPfqpe46ORdm+9KVgUPZVviiwf4kXxSjgO2RdRRFnycL/SoGa1olFQC3lBhPRhYO6VWGOU+/qD84xjDJVI/pBg
 mwMi8Uzp
 lPphN+OJhfZQH/QceIvt8pAnQuIOG7FkN/iVbNEWz46cLScy1dXbSewaOjxemgpBV+ZsOm+G/SMRXoLs2XZCjT13zQkJFgj1n4jI0f5EBCyzefwQ/zlm13+R4RSm32XrKomaT+xFpuigiZ7bsP7uF+L3HZ28YL6tmG0VCqOE6PF1oFd0EpHSlCrJ5kNMrXr1Dx4P47uAWfnenMcrsy81SE5SEMbUbDCPS+R54lcBCsPJkiT66VfB8C2F6Em8Og9EcYW7f/tN2KFETn67gSCCUp+1phh2y0ioj9OW6gBxyMMkXclTmqvHemYca6XAKC/gA9ezDUbtGPaZD7+ef+jhJVj1+ZVj1H7YFMRNlfMVY1D+dkJmROFFid3UnCrjdGqa92lciWCamYHWQqMYZLlnVuFZB6IpmrHw46SxkWR4SKY9BCEa+HdvbdNHbag==
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
memory starting at phys_base, modeled on the LINUX_EFI_UNACCEPTED_MEMORY
table, and it rides the EFI system table to every kernel in the chain.
Basing the bitmap keeps a machine whose RAM starts high from paying for
the hole below it.

List the table in the x86 efi_tables[] too, so an SME host maps it
unencrypted like every other EFI table.

The Kconfig symbol has no prompt. There is nothing for a user to decide,
so it is on wherever it can be, and it only costs 64K per TiB of RAM on
a kernel that already has the EFI stub and MEMORY_FAILURE. It is
restricted to 64BIT because the unit arithmetic would need div_u64() on
32-bit, and there is no 32-bit EFI configuration with MEMORY_FAILURE to
test that on.

This is a similar approach as used as unaccepted memory.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 arch/x86/platform/efi/efi.c  |  3 +++
 drivers/firmware/efi/Kconfig |  8 ++++++++
 drivers/firmware/efi/efi.c   |  6 ++++++
 include/linux/efi.h          | 14 ++++++++++++++
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0c39adb96b912..2b37b96a36e09 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -93,6 +93,9 @@ static const unsigned long * const efi_tables[] = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	&efi.unaccepted,
 #endif
+#ifdef CONFIG_EFI_POISONED_MEMORY
+	&efi.poisoned_memory,
+#endif
 };
 
 u64 efi_setup;		/* efi setup_data physical address */
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
index 6d987d7f97781..af1fa443839c4 100644
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
 
@@ -677,6 +680,9 @@ static const efi_config_table_type_t common_tables[] __initconst = {
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
index c35446a0b66fa..efaf63f9a54ed 100644
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
@@ -1272,6 +1275,17 @@ struct linux_efi_memreserve {
 #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
 	/ sizeof_field(struct linux_efi_memreserve, entry[0]))
 
+/* Bit N covers the unit at @phys_base + N * @unit_size. */
+struct linux_efi_poisoned_memory {
+	u32		version;
+	u32		unit_size;	/* bytes of phys space per bitmap bit */
+	u64		phys_base;	/* address the first bit covers */
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


