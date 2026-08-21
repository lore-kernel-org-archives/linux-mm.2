Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7471C5DF8E
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB99A6B0095; Fri, 21 Aug 2026 06:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69576B00A0; Fri, 21 Aug 2026 06:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EF36B00A2; Fri, 21 Aug 2026 06:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A65276B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:06:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41DCE1203D4
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:40 +0000 (UTC)
X-FDA: 85124847360.17.42DE59E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8554118000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iGManAEd;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GijpPHV/MlnALkvostyEz/qvgq+mkhNTyT2lnEH+3cc=;
	b=GE+uD1XLl4q0K+aitB/hzIhyH5FkTVy9SeSTATwcFuzm120HqCQW5UCR2QJqx/q3hmn9qD
	sGuuoMJZF6NnDexvf9ElCtVCuCGgyoS51uRAObI7Q5PbrrlZcloS4uzPBZdDGj7GzElWCR
	MhMp8VWyUlWxTI0ve9Fvx1vIz9sw2jk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787306798;
	b=ATtDpiBKJTLXONsr1TUAWO3n+Ol0+NIBBKo36ByExkEV/OpBGXWy1GL3/l0PWKZl/+DU+i
	dswWsp1fMY4GArqCyzRypfSs7x9BKOyxDSnGkgN7y8o0YZ0cz4ZCKIujuCFiD0oRSawbC7
	HTr2cVRyX/GZvYrZNbWgm3MM9mgz8pE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iGManAEd;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=GijpPHV/MlnALkvostyEz/qvgq+mkhNTyT2lnEH+3cc=; b=iGManAEdaf1RslOR2kQtj60Uau
	2cPekOu/rvVOIMx+a/RdULWoQqOizOXh9q2ResBctGch27Ylb26QCtMYYfgmdE0XpZOAsBFzMamnL
	6BFmHMrcpmbyp1X293U+Dzi56na2S7mreb8TCnLeDRv7lIvfYUztITa+wd8S28EnULOIjsdp6zCz2
	ygwkTFKI7KZ1LE+ByVAiwUyKRgo+NDY87YkDiTYcgxtzTT7FUH1OThNQG2yKJFvJORcEbRjnbmn6T
	jH/d5KqWpDiJzP6Q6SQwrbQbOOIDievRHSFNWQHnRifdGuRIe3jS17kLLO4AF8VTd6MJ3x+TDNTWS
	DjHeOyLw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM8u-00BGBG-16;
	Fri, 21 Aug 2026 10:06:32 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:02 -0700
Subject: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=4479; i=leitao@debian.org;
 h=from:subject:message-id; bh=Z/vnT9K1G8JkfMrXbm/2Q9zXt1siFCixL2PK45FYBZE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMaQOgra0AgIH7Fhhk615ZgT/EKbr1P24x+f
 vcF/X/ROlaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bbwQD/9xKGVGX5YWvlXXOMyaxbNwxB6OkudoXxGeuMi480JxdrtEbNG9MKwYTTv+hBls5nFsxOs
 PCOU1GsJSwPEqeByAAOJUv9WCo/izqKh7nERh7ft/ZdZSwd8SroxpkL/5ZQ8U8HRRq7D6leBHUp
 eK7J1vgRdboT7WVSt4sU8iG9psRa35T4D++40LNwoH9WrlHsw94+tRils2g6fS2DmaRBbitQGDG
 0BVBo1RFRhYRxH8Fmjcb6Ll633456uZzbvD5KmUrH1bJRfvJeLHBn7cu345txlsZHRwWj4640bS
 R47Ayqj5pV/UCuBoUskVSeud8qf2bIr0Q3KWKxc92biz9d4tBTZOZ4O4JvX+r0OQ8qCu1q1bpe7
 GAf9iuKPhgjSHvozRIKj0k+qvmdowhOOt9gYieCf4WvuYp396iJ6xIOUptwyRURhZg1Ys7w5Yyj
 TPIwogIuh8fVqZQO6LaBQMcxVGvpkZSaOzw2kMwDFMRV2YXibFj9jUlZzTaGJBkso/dIe5AijRh
 yciexX3E9NOeG/eY9g3FHxM0vcg4JvyTaNdkxw/GR6S9LvTgDVlolK4TUmkFrbv/JmgJRkntw08
 2lznEos9GOe4K1+6lmLvcIlLKXZaGAmxi4tCyMoLhzdbwpne9cjplDV+9h0qLABHoxqIvOvpXu7
 5eFmHY2Z6fn+Eaw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: qufy93bkfgwxi71repmmimrdyrfoebs7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8554118000A
X-HE-Tag: 1787306798-1483
X-HE-Meta: U2FsdGVkX1/15wqft04YPA0kJB4l9yZQ5Nlmd+q5xozul+0zk3Wk5stmyPNyvqY0Hrt2uQX4i+o09gxcxeFqXUpiFa29/78pU2aqJNnME74P+aXgn6mgdKxcJV1HBysEg/IIBLSnO5WCsVtPmlY8Hwbi2nWtsv6H1Jrc5OrNhjPayAWx1242g5uuPvp1Uq8VTx2hOozz6gyXl43UBxb/JKB/WL2OmhGm+tpUFe/hrGpV+iAjDtS3tr3eOoG8gWjYEyrqX5ArLnDnRPY70mzZwHUVCUsnX7RymbDx89dnsyKe4bm01mkEEcpVoG/Gb4sfsX9sGewr1qlCoOunybpn/ubAb/64L/tTOB+rFt8ZHnRkFjeLpgRCMfxZkLo6CTwLPnVFFNdjZaVOceCm69QFAnqW+0PEpTI3hHjNu32KQUdp21i9FC9c3qRV0HZu4okkih9CsABURyHFYPzSKSGzNizfIlxC/lZ0VaUA47LFpRfq+EtnC8P/H9bkknL1dl4k+AaaUW8qfhzc9ec92xfBZIvdGe5oH1+PiVoWRjsgyx5GJdCGuxwVSrcPiokR8XBTftt/dNYR/pBFGi52KKRQ22xoJJn5JhPdswEEq3KyjQad2QPDeXLjdOAiwBvWzyf20vl0gEyW2NRmWm6/xtiwM+7PTLYmIwHd9yPAAatlyNFgVD7kGR3XwGxy0CSA03jprGpgiDsevEl/WWaupdELDtmCUlPeeic7S3j7ouzIP2QfdE9N17375zv1fPnQ5ssDpLLo0xxm/HZlCqC3s/hyw6oegTbNCGHlNR/u/+YJWOxQzdAjbkOCXoQiJfuTpZXaprCmc9yAhqv+HFRIUjIqe46YcRQGKOtCPyhaHTKtRpBeFDzQ2WppmdpR/cvxOs+g4sbTWR+qYGbfLP4eTZHujnYvfASRrURDKJelwepR5cMINeri08/e1S8EFCvVRMRmTVLGN/qtGof0iufNpEv
 zKKs5mVb
 o4fVRWdoK6/MEa2MCWfl1PUsKzp94+CshiHfSxki3iBZfWQT0qmd/eBP9bILRzIJ/5Hq3nkw2IY+JZHwR8ZP0jPjmQFFmC+CpS2++F8OFjNszky5Cjo5aFLlxaN9vmLFYU+kTPke1tX4w16fk+bs/RxYqcoPmRFhvOMrpFt5buTD0uRqXdu79sHub7b/36zzXbTqyVp2BCSjRgD6TsO5lZLxq3lTEMyGxUUAF6m59BO5RdFV9Y1ceI3oFqntbEFzjTnMver72Ns11W48x1KlzzQC0QjZtcTRsUw5ue1KwjYVp8YS5hNyKk5NHedNmKlGd5NLWZs2K/qjE7GSituUJLBbrhYXFUtVgnKyfOHZ+fawdg8zamNsVGOwBVjiRRaVjYrnIgyO9XV2yFpWNLeren64YnyTOArsP3qtIXETVfzeU16Z6soPTZ16M5A==
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

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/Kconfig | 10 ++++++++++
 drivers/firmware/efi/efi.c   |  6 ++++++
 include/linux/efi.h          | 13 +++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5b..69c0dc02bc112 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -263,6 +263,16 @@ config EFI_COCO_SECRET
 	  virt/coco/efi_secret module to access the secrets, which in turn
 	  allows userspace programs to access the injected secrets.
 
+config EFI_POISONED_MEMORY
+	bool "Carry hardware-poisoned pages across kexec"
+	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
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
index b3c83516593d1..ce0980a5bb81b 100644
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
+#define LINUX_EFI_POISONED_MEMORY_TABLE_GUID	EFI_GUID(0x78a5bf07, 0x7d2a, 0x2889,  0x16, 0x31, 0x63, 0xd4, 0x56, 0xf2, 0x83, 0x50)
 
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
 
+struct linux_efi_poisoned_memory {
+	u32		version;
+	u32		unit_size;	/* bytes of phys space per bitmap bit */
+	u64		phys_base;	/* phys address covered by bit 0 */
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


