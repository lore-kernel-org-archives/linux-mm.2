Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97ADBC88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97EF6B009E; Tue, 15 Sep 2026 08:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41716B009F; Tue, 15 Sep 2026 08:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58346B00A0; Tue, 15 Sep 2026 08:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9396B009E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:54:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1380C1602FD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:54:36 +0000 (UTC)
X-FDA: 85215990552.09.C0297D2
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A5B94000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:54:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=D165baFu;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQYv3IK3nKz4VGXfXkL0jqV1c+L3rNS2Cu4FByGZSzQ=;
	b=WkLHoTwmZA4yrvuldBhel2reGNEK6VjYjHzV0Hr1AH0qufn2/MOeZ1G1pParjk2rnz2j2P
	kPE4+r/SRTmoEq/FBEPboQKen98dqvrtVjzbyd34I+45pwsuiCQr9mZuUOZPPWTKRT8wG3
	6KYfSmJ1NwVt1sm+AY9mktu3ZD0W0Lc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476874;
	b=Cm5MaX2BasW8QFiTq+5W+yWBYmarwlNss5NRp65Pw5CMe84UpgcYn/fXdXMg/3HJoK7qlU
	COTJzG0WJqMn/p66M8LG6Dl/7XZDn97YnTjDn9MrdJ9AhV2CkZeDUIcYRq5GHIITfWSikK
	z8tfn3h2B3lW8RvMDnpJ3lSJZ2e/OPc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=D165baFu;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=vQYv3IK3nKz4VGXfXkL0jqV1c+L3rNS2Cu4FByGZSzQ=; b=D165baFugE5ebahFxkHKeCtu69
	isvlYunXRrZ/8h5RSqDs/k7VkHz6E1lmtMvEeE+ivLExqwk8r76X2r2ATXCDPUDsWFkhVjeL/fAI6
	iZmtLQbG04bSv2LbMeFhi4IBYwkpl5gNsbVtxaVNr0I9swAzDTh1uYcrYqHOtWyZ0Z4yLCQBt6dMi
	q9hbn+HbX5q5ymNepSaFJRWx0+VFm4fmaQ6VRmNYhkNVz6JSQV85WknT888e4QEuVvNnYl/fI5qbW
	0z3LXQ79Iale7SbpKC6gAdYX+bXSlx8PrLKmc75gAZOFoVzmhcei1RHe5ueUSIKK8NESIuB23E5gf
	EiIsdYCg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sg8-004P71-12;
	Tue, 15 Sep 2026 12:54:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:38 -0700
Subject: [PATCH v5 4/9] mm/memory-failure: efi: adopt the inherited
 poisoned-memory table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-4-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
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
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=5602; i=leitao@debian.org;
 h=from:subject:message-id; bh=p4TA3mGY17xjFk2/w08zQcue/vtEofhamWwCnuZ5N5A=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/e1t7ibvkUKJ2Ehd30snyR4Ejp44hDVq5P1
 Cmn9fCJS+6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bVMHEACluIfazKFZBsLVFzWJZNmi4R+tYXhf7Y8Ou4PotT0vf2Jfg1Anf637yriPAyRYiYw2VI8
 +tXqoWdTDh6rNDHzGNRlQTC3ICpfBaEORTg07oCS1SItgKpBYajALVtu0QJdINjz8FDCPFSRSuP
 rTcWZTpUy0VWRyCxGp9djsnQaXIxIJ0977vocCfwDfBnVdyYmx9XppOYol6bADrhCmVuMR+m64Z
 dbWiol7VMlBKGlKpbHfQU1NQg5f1PpdPc2sOTUBzS8Vk0cGkeuLRSTGU/Mz3P8tCfUMpvCBW9m1
 aKNwiMoFygDnVi/qYdiy8FlxAT88V4gcPlHGxfd6dvGg1w1j9aebDpz+fSqdZFVn+uPf2p5/YdY
 gCpm0ZA5lh8aYev08tibz57fqhc5jOT18sofrI5/uY1yMYPuX052Kdpe3SZlzBIuDU36R63Mqju
 5Lr6EhgQwL/ypaPRB2ppnVu0YdPUjZvH+E+x9++OJ0/U06fZ7/2fTCuE9S1Gw3j92cLq4hJkaup
 qq/0W1WEKnUdbml/vFnDSgA+AZlWFOPyd1KaTpbufF3OUSDIa3erk7h9oBXVORZKP1sLs4iuIzv
 /eCjX0tehKPXuyV/QfyX/M4lmuY64i8s7qgiv6M5f7DIpG0P5zmIq/wqoU4lJWKTCYoh4/x3lMy
 9g7PPs96Q6n7AFA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: exs5ntuuhkxtdskq1pa83z4jhpdknhmt
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A5B94000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789476874-817812
X-HE-Meta: U2FsdGVkX1/bTSCdMhdzVKEX8zeYuHEYlOQFs15tl2ZIKzyrp/pMy+uljQwz9tfmUK8dV5Kme1UpIIHHtHFPFgFbbxKJUTHlP+h9w1ZgZH3+Cgn2XbcE7wtW99ZVqL2gpv/83ueolGlGR3Nijlzb1Ig8hh2lOXMM4eT2ybHElBVFUy+NLS3lxMEGGcP0VTlw2iOaE/vcg2pMQKlxUaVmjXcGM98AaU6xe2cU+H42cYXDHwQdCUjaNejJuCDQvsh9eR0Avf/5WMsB4hxwqifUyJZYzSLcaLAQajkU+LM3bh/UdyTKic2odMhHRucAz3+EgdKCDsqbrFGoPLboPevJg4KKb6rhxwhprnswY378A6FNlp7bqEpyyrkhhPtL3P8NQnB9iBUVqMtuoM4N39p5fj7c50byeQT/rXRBzR/ga0F24qEcx8t1aks0SoLbJmCgPkiqxog0lOGJqKyHYOGe0xyGBAnQrr+GjJkJNxVBnqiLmxKMOjG3vbMNF65JsUMwWxVCS8+mMgXVgwk9LW13WPADD8qvXJRSR36351xbXmIQMy5DpakgSRkNyuIUFB3mkNDRRpvFx3OkEscQ6H66fXKvLaxlR92BFjFX7kzwVyQz95dnwEYHXDqvXUiyvyZXoVHltvc8mBMRyE6bwb7Zpy1dNTYkLuArULT019Kn6Sqy4hNMxdfggwSTGRuqz7GWjrVjJzo4StPEcqm+gv7DZrYVSzmvNFPt+E0tHg13DPJZmO2fV2lwdfJ9L5vX/SrhXQVhuu3OWphUt1XxHzt6Uige3FPNDwtqhgonS1CK6ifIR/dXcxowpN5x3Hc37up7KqSKxAFn8LTxdvY8lTjaQUrDw5vcRH87O/75oh6VkKyWj09vDlf1ok7JJ4zxbXGDadDDGqLqvr1wYBZ2peg6PKEHQ13x2e4vp5QZR5Shn+uOtURE4yYS/JaHFcXme/nhIaq5b4eCJSTWSxZDCDr
 4Z++isjH
 xVHqR8h1AncDyjFRp8O0A3dMA/wHMsd8OBq1wdnOK0+b0yNgsDgrbLP1rykCZtr0o+yWNPmWnYS72Qjp+QEfhwB+kMtszQf08n0Ml16T7d6kP4lZQFILGKUcxFeFt48PhLhMPBf8uHgh8gzrJXmr+nbWKd3yHtFJmCPhmG24pG4gGqq4iJ/fCSveCsoXteCFOZVkSML/CpLZK+cxLYECFjriS69gGcNWzqVZnp3vaSiLciabcg1ROzczcHtyjLG+iOS6kmjc/RwRZ4kDejIDyyDJ/rYza8rsus9bUz1ij5q/JEHNu5fGYuGempj+rVZpu3HZVAB0Co0iaksCGDAMr1Kxsffu0u/hm8XuM2msfFTIksayhCtIy9RNnrNWp8p6N3FU3GA7J+3e5bCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A table installed by an earlier boot rides the EFI system table into this
kernel, but nothing looks at it yet.

Take it into use from efi_config_parse_tables(). The table can come from
any kernel further up the kexec chain, so vet the header first: the
version, whole-word bitmap size, a bit count and a footprint that can be
taken without wrapping, and a power-of-two unit the base is aligned to.
A table that fails any of those is dropped rather than trusted.

The table is EFI ACPI reclaim memory, which x86 turns into E820_TYPE_ACPI
and leaves out of memblock, so it never reaches the direct map and
touching it later faults. Hand its pages to memblock the way commit
8dbe33956d96 ("efi/unaccepted: Make sure unaccepted table is mapped")
does for the unaccepted memory table, so everything afterwards can reach
it with phys_to_virt().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/Makefile |  1 +
 drivers/firmware/efi/efi.c    |  2 +
 drivers/firmware/efi/poison.c | 93 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |  6 +++
 4 files changed, 102 insertions(+)

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 8efbcf699e4ff9..05d0a490923e56 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -43,4 +43,5 @@ obj-$(CONFIG_EFI_EARLYCON)		+= earlycon.o
 obj-$(CONFIG_UEFI_CPER_ARM)		+= cper-arm.o
 obj-$(CONFIG_UEFI_CPER_X86)		+= cper-x86.o
 obj-$(CONFIG_UNACCEPTED_MEMORY)		+= unaccepted_memory.o
+obj-$(CONFIG_EFI_POISONED_MEMORY)	+= poison.o
 obj-$(CONFIG_TEE_STMM_EFI)		+= stmm/tee_stmm_efi.o
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index af1fa443839c4d..55b2ee53fc2688 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -883,6 +883,8 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 		}
 	}
 
+	efi_poisoned_memory_reserve();
+
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
new file mode 100644
index 00000000000000..3f12db3dc9b844
--- /dev/null
+++ b/drivers/firmware/efi/poison.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Runtime side of the LINUX_EFI_POISONED_MEMORY table: one bit per
+ * EFI_POISON_UNIT_SIZE, set here as frames go bad, honored by the next kernel.
+ *
+ * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
+ * Copyright (c) 2026 Breno Leitao <leitao@debian.org>
+ */
+
+#define pr_fmt(fmt) "efi: " fmt
+
+#include <linux/bitmap.h>
+#include <linux/efi.h>
+#include <linux/io.h>
+#include <linux/log2.h>
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/overflow.h>
+
+static bool __init
+efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
+{
+	u64 nbits, end;
+
+	/* Whole words, and a bit count that can be taken without wrapping. */
+	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
+	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
+		return false;
+
+	/* And a footprint that can be page aligned without wrapping either. */
+	if (check_add_overflow(efi.poisoned_memory, sizeof(*pm) + pm->size,
+			       &end) || end > PHYS_ADDR_MAX - PAGE_SIZE)
+		return false;
+
+	if (pm->unit_size < PAGE_SIZE || !is_power_of_2(pm->unit_size))
+		return false;
+
+	return IS_ALIGNED(pm->phys_base, pm->unit_size);
+}
+
+/* The table may come from an earlier kernel, so vet it before using it. */
+static bool __init
+efi_poison_table_valid(const struct linux_efi_poisoned_memory *pm)
+{
+	if (pm->version != 1) {
+		pr_warn("Ignoring poisoned-memory table with version %u\n",
+			pm->version);
+		return false;
+	}
+
+	if (!efi_poison_geometry_valid(pm)) {
+		pr_warn("Ignoring malformed poisoned-memory table\n");
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Vet the inherited table and hand its pages to memblock, the way the
+ * unaccepted memory table is handled. It is EFI ACPI reclaim memory, which
+ * becomes E820_TYPE_ACPI and would otherwise stay out of the direct map, and
+ * touching it then faults. Called from efi_config_parse_tables(), so
+ * everything later can reach it with efi_poisoned_memory().
+ */
+void __init efi_poisoned_memory_reserve(void)
+{
+	struct linux_efi_poisoned_memory *pm;
+	phys_addr_t start, end;
+
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return;
+
+	pm = early_memremap(efi.poisoned_memory, sizeof(*pm));
+	if (!pm) {
+		pr_warn("Could not map poisoned-memory table\n");
+		efi.poisoned_memory = EFI_INVALID_TABLE_ADDR;
+		return;
+	}
+
+	if (!efi_poison_table_valid(pm)) {
+		efi.poisoned_memory = EFI_INVALID_TABLE_ADDR;
+		early_memunmap(pm, sizeof(*pm));
+		return;
+	}
+
+	start = PAGE_ALIGN_DOWN(efi.poisoned_memory);
+	end = PAGE_ALIGN(efi.poisoned_memory + sizeof(*pm) + pm->size);
+	early_memunmap(pm, sizeof(*pm));
+
+	memblock_add(start, end - start);
+	memblock_reserve(start, end - start);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index efaf63f9a54edd..dd3263456dd4a3 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1286,6 +1286,12 @@ struct linux_efi_poisoned_memory {
 
 #define EFI_POISON_UNIT_SIZE	SZ_2M
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void __init efi_poisoned_memory_reserve(void);
+#else
+static inline void efi_poisoned_memory_reserve(void) { }
+#endif
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*

-- 
2.53.0-Meta


