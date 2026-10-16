Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3934ECCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D17C6B00A2; Fri, 16 Oct 2026 08:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A88D6B00A3; Fri, 16 Oct 2026 08:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE696B00A4; Fri, 16 Oct 2026 08:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA0CB6B00A2
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:17:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DC7D4041B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:17:11 +0000 (UTC)
X-FDA: 85328389062.25.C32FB8F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78D40140009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:17:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="f/AdlHhW";
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792153029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTUm7qXbyCgsHTfv9HEJxOPBCHA1vThvC9ghrXwjpTY=;
	b=ldTOz52XKMgTPFdKcKmnmkHrdMMbM5/cBGpET56v1Fv5xUNCD5OfIcUoUn1dFH5C9kPF9e
	uQ71P6Mc4DK3M6SMH8IzgdaQ5QFLv0VuNMR/6XTcFD1so1AbuM9ofKQeOq3LMICHXuwmGn
	lGIRUxYrHyJ1MITWgw1d77//XYxhQZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792153029;
	b=1jFwAlGwkFoxQkxFS3/pI9LmjGuLoGtEsPCpuVbnqfR3tOsV4zDJy1Prz/spnAfgpOMPdx
	iVM+mOkO3PUMUHIBApt/eanP1xKa8ePbzaDv7IpXw/LjTD7EI2neDZXfRZfieJaBUW68Xe
	WCMzdIerZw6PXLuR70bJMjdT23j/6g0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="f/AdlHhW";
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=kTUm7qXbyCgsHTfv9HEJxOPBCHA1vThvC9ghrXwjpTY=; b=f/AdlHhWVl7/iGMWhkaixUOCvf
	tkB+Ae+Jqyu8J2924KvdguVieG47XfGceFxrFOouqEQenHCCn43BJ/hTQG5aIccUIRY6Q8JMYx3Kn
	C/b0AmbMY7ySg9aPXWGIrEYp59DuNW+o1Inkts3akjT2sUDagIxPorWDx4N9v/I82uCGa3gqf9wrY
	6XLF4WYbBJsAmwpG2u1dngQVExer5a+rvbhj+xm+Mpiyu4Q6qNFeNjbTV2FEjFL+truux3/p1F2dB
	ZZcfbVCvG+H3LbhDOirC8oPLzFaK4F30Yb/GlgnpvR3NmVP72Zm/lsR7f9Ttca9yMptimFv289H37
	Ki0Y7GlQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgrb-005xUR-2S;
	Fri, 16 Oct 2026 12:16:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Oct 2026 05:15:46 -0700
Subject: [PATCH v6 6/7] mm/memory-failure: efi: reserve the inherited
 poisoned-memory units
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-hwpoison-kho-v6-6-f304255147da@debian.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
In-Reply-To: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=10257; i=leitao@debian.org;
 h=from:subject:message-id; bh=7/Mb5ZDQ3fdWOMz9QRVgdFVPWnvwUVfW55lYAEasddU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV0inb/er21jKoWgmCa5saxpAqyVkQC7njpK
 fYkeff0BOmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bX6gD/4nSUwvF7C2f21LaU8RRSKN4G17EGdVT1EpWIydo8B+jSJuQrWWwRi7LuIxAyc1EWL8XNZ
 8oltwPMd5Bkki1UqGkZ4hTtRkyyvUWHiKlMcb4zcLyAMPgSrWsaMXaUCZxNeJ+jgEveRFkh7O+1
 qLVyQakFYs/uI8P/Xj11P9SoWJL1awNNED4TmjYrdqnpdRGVvCH0in4lwoWGpvA73q5LAjugN2Z
 iQGq5hSpq0DeWcrxwnQc4CS8+V7G+9pR0AkER8xr8UQQJ/LOypgN5wYgmimGBGFlNTsOIgkfHVj
 t0kf86HzycHVJGeXWy2iViKCN6PMIiMICz9WDdqzNg1NDUSCXzLFD2sJ1rzrRPoQHmEgqZx1Vn6
 NbhDxvDR+k+0pNQU1Beb6+kveJuaDsRLefuhDVIFuoC+3sHd+7C6lUDEp4i8hwmqszSEMZGIQ4/
 Yh47BQ05MnEbOZd7I6q5LtUDsSgC0je6L0R2F3KWxMTB/MKFGm6NjgVyzydYXeL3L8JoQdCNcy5
 TWlsKk49UCzX/yR5bzh1qnTlN5yW8FxtyOSlCqAXAaDvL7zP/a6aWuUEu4eQ3dhKZbT07zIgm3g
 mGFGWozHhasyvLCpohJpAKr8DjU0HPax4HvYiEF6uSmvXLyYDgkbEp9+GTO0i4/KBZfG/ieV6GU
 UZUpRg+3CLqkAjw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 78D40140009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4o5k9yy7d6pf1mwu8b73ck8cn17w1m3w
X-HE-Tag: 1792153029-741000
X-HE-Meta: U2FsdGVkX1/0NdEVzdSBZNwSBwX6Cshc6AQ99FH1qJKugYH10bwf9mSLRObaxLfr7Is5NEA8e50by+2JLUlVdw1lmpf/LmJLSmny9uXEF6HPET+Wj0c9vFK8Ri9m5lOA1qOvmRir5jb6b1agtARf1A6YP+pBs+J/0EaJTy2zyYuJlmgZDK8/NJykel/iySLlMbHe2IS1l5i7wz4DzW7jzIeTarUC3onEFmibvJ5obZoOkaInkd7qwovYtuyLKV/juXiHHEgEtvEsLJ8O0rPLVxeN2Ko9sBus4IKxOi8rjgfq78YGjWLLpDly5Jb8dqJVoA9kxCvT5lfYnFe/2XgJn1EoExW5hh9i3LFoaN29ls49A/aOWBFVa+8QyC1d2q01BwUs13TZ8gZF9S2NNHetFWv46KJD1skwafrOmfUrtpXhYJ9Tp25ouSZfp6LDwrohqdL5xWghx0YD9g8CEePL/fuP03cuhqRoRQImBoXru1vSetTAIesKNiF7XkRImetW1WtYzptgiQ6ZW/j+3UQWeAa9d4GzF+DAQcgZSup8VpvFi9Pw8wO7+Kf0hSSt+Hb+pVHDSU+i35eLwZsYOvw4ZSQODXLAQ0aiq/JJPL7idQRv28m4KGSOjzht+0+sgYhZ2iWdY7Vb5ZctVWwMQ9Jbu3Ncxswg1mEF/jcHlHiKVizrXYXdqjg+m809agBE6CPRMQWGpEpClCFdybeIYaHY/93pdEMhv92nVTt0vdiwTpsu0ZTlWY8cOCXizAPRwApk9RAkYMdMaW4hXyUKonGXtDPjeVMwK9Led/mxJujdhtBVQROb01nbQ6WNO0jigDMOYJriQC0IeQ+sTra/TUBk6TtH5ELiW6oSL6r1RpcVtGpw4zM/HEr7k3Y7istDuRBZtawNqfc5CpwOs5fz/w8nOUTBftTP5rbso8M7IxS+JSNKitbmLuZ+qPPIaeyzIBQXufUuWq8HA0eZqNUteQL
 MVxMq6bG
 dIfMUNPVsj/fIJu11p88llk9Rqe503qXF/qiVozcsQwXqsYngSqMYmw0mm0IQ+GU86uUeX1rrec6NbJftg/1angB6ciTWH+7tpBmmEo+EW5B/g41BZL2WBQJUAM2WVk7/4AsZo9hctI/DAl7Bs3PAuxMmy3KbvPrdXAWx2os4U73JRM08MualnMcAQNRKHSAYzYSZr1NriUeTJyivmF2vZ+K7c4XvSkgMKvSGb4tvOsh0+Oyypj5SKhWEQPil0sj9mtQixKMgaq/Ix1ZkD/aBcDnMnyFY47rkoOD4qaXf6WBuNGlR6doBkp1xSNBOnrmYD9aBZ4hbT63+JZtnhzVHzJHnzmVVm6a5k3NNtRFQGOw5Fv+S9BTYwRwhC/5W187j0hiE6g3L1LItOFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A table installed by an earlier boot rides the EFI system table into
this kernel, but nothing looks at it yet.

Take it into use from efi_config_parse_tables(). The table can come from
any kernel further up the kexec chain, so vet the header first: the
version, a whole-word bitmap size, a bit count and a footprint that can
be taken without wrapping, a power-of-two unit the base is aligned to,
and units that stay inside the address space. A table that fails any of
those is dropped rather than trusted.

Reserve the table's own pages so that nothing allocates from them, but
do not add them to memblock.memory. They are EFI ACPI reclaim memory,
which x86 leaves out of it.

With mem= trimming RAM, adding them would leave an island of memory far
above the rest. A CONFIG_DEBUG_VM kernel then warns while it initialises
the reserved ranges that share the island's memory section.

Then read the bitmap once and reserve every unit whose bit is set with
memblock_reserve_hwpoison(). That has to wait until the kernel image and
the initrd are reserved, or their frames would be flagged poisoned. The
architecture calls efi_poisoned_memory_reserve_units() for it: right after
efi_init() on x86, which reserves them earlier, and at the end of
arm64_memblock_init() on arm64, which runs after efi_init(). Both are
before the page tables and the memmap are allocated, so memblock never
hands those units out, and memmap_init_reserved_pages() flags their
frames. Nothing reads the bitmap after this.

The reserved array cannot be resized yet, so a unit that does not fit is
skipped. One that overlaps an earlier reservation, such as the kernel
image or a kexec segment, is flagged only where that reservation leaves
it free, and skipped if nothing is left.

Log the number of units skipped and the number that overlap, as a
recorded frame inside the overlap stays in use. An overlap is expected
when a kexec placed its segments around the bad frames, so it is logged
at info level.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 arch/arm64/mm/init.c          |   3 +
 arch/x86/kernel/setup.c       |   3 +
 drivers/firmware/efi/Makefile |   1 +
 drivers/firmware/efi/efi.c    |   2 +
 drivers/firmware/efi/poison.c | 174 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   8 ++
 6 files changed, 191 insertions(+)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index fbf215ecc7d061..6f74020a92be1d 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -298,6 +298,9 @@ void __init arm64_memblock_init(void)
 	}
 
 	early_init_fdt_scan_reserved_mem();
+
+	/* Poisoned units go last: the reservations above keep their frames. */
+	efi_poisoned_memory_reserve_units();
 }
 
 void __init bootmem_init(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cda6adb9f69c42..2a84b5c7db7063 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1007,6 +1007,9 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled(EFI_BOOT))
 		efi_init();
 
+	/* Poisoned units go after the image, the initrd and setup_data. */
+	efi_poisoned_memory_reserve_units();
+
 	reserve_ibft_region();
 	x86_init.resources.dmi_setup();
 
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
index 00000000000000..fa84df55aeb469
--- /dev/null
+++ b/drivers/firmware/efi/poison.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Kernel side of the LINUX_EFI_POISONED_MEMORY table: one bit per
+ * EFI_POISON_UNIT_SIZE, set as frames go bad, and turned into memblock
+ * reservations by the next kernel.
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
+	const u64 max_end = PHYS_ADDR_MAX - PAGE_SIZE;
+	u64 nbits, span, top, end, len;
+
+	/* Whole words, and a bit count that can be taken without wrapping. */
+	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
+	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
+		return false;
+
+	/* And a footprint that can be page aligned without wrapping either. */
+	len = sizeof(*pm) + pm->size;
+	if (check_add_overflow(efi.poisoned_memory, len, &end) ||
+	    end > max_end)
+		return false;
+
+	if (pm->unit_size < PAGE_SIZE || !is_power_of_2(pm->unit_size))
+		return false;
+
+	/* Every unit has to lie inside the address space. */
+	if (check_mul_overflow(nbits, (u64)pm->unit_size, &span) ||
+	    check_add_overflow(pm->phys_base, span, &top))
+		return false;
+
+	return IS_ALIGNED(pm->phys_base, pm->unit_size);
+}
+
+/*
+ * The table came from an earlier kernel, check version and geometry,
+ * otherwise bail out.
+ */
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
+ * Reserve every unit the table records, so that memblock allocates nothing
+ * from it and memmap_init_reserved_pages() flags its frames. The bitmap is
+ * read through early_memremap(): the table is not in the direct map yet.
+ */
+static void __init
+efi_poison_reserve_units(phys_addr_t table,
+			 const struct linux_efi_poisoned_memory *hdr)
+{
+	const phys_addr_t bitmap = table +
+		offsetof(struct linux_efi_poisoned_memory, bitmap);
+	const u32 unit_size = hdr->unit_size;
+	unsigned int nr_units = 0, nr_overlap = 0, nr_skipped = 0;
+	u64 off;
+
+	for (off = 0; off < hdr->size; off += PAGE_SIZE) {
+		u64 chunk = min_t(u64, PAGE_SIZE, hdr->size - off);
+		u64 nbits = chunk * BITS_PER_BYTE;
+		unsigned long bit, *map;
+
+		map = early_memremap(bitmap + off, chunk);
+		if (!map) {
+			pr_warn("Could not map poisoned-memory bitmap\n");
+			break;
+		}
+
+		for_each_set_bit(bit, map, nbits) {
+			u64 unit = off * BITS_PER_BYTE + bit;
+			phys_addr_t base = hdr->phys_base + unit * unit_size;
+			bool overlap;
+
+			overlap = memblock_is_region_reserved(base, unit_size);
+			if (memblock_reserve_hwpoison(base, unit_size)) {
+				nr_skipped++;
+			} else {
+				nr_units++;
+				if (overlap)
+					nr_overlap++;
+			}
+		}
+		early_memunmap(map, chunk);
+	}
+
+	if (nr_units)
+		pr_info("reserved %u poisoned unit(s) of %uK inherited across kexec\n",
+			nr_units, unit_size >> 10);
+	if (nr_overlap)
+		pr_info("%u poisoned unit(s) overlap an earlier reservation, only their free frames are flagged\n",
+			nr_overlap);
+	if (nr_skipped)
+		pr_warn("could not reserve %u poisoned unit(s)\n", nr_skipped);
+}
+
+/* The vetted header of the inherited table. */
+static struct linux_efi_poisoned_memory efi_poison_hdr __initdata;
+
+/*
+ * Vet the inherited table and reserve its pages. Called from
+ * efi_config_parse_tables(); the units it records wait for the architecture,
+ * see efi_poisoned_memory_reserve_units().
+ */
+void __init efi_poisoned_memory_reserve(void)
+{
+	struct linux_efi_poisoned_memory *pm;
+	phys_addr_t table = efi.poisoned_memory;
+	phys_addr_t start, end;
+	u64 len;
+
+	if (table == EFI_INVALID_TABLE_ADDR)
+		return;
+
+	pm = early_memremap(table, sizeof(*pm));
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
+	efi_poison_hdr = *pm;
+	early_memunmap(pm, sizeof(*pm));
+
+	len = sizeof(efi_poison_hdr) + efi_poison_hdr.size;
+	start = PAGE_ALIGN_DOWN(table);
+	end = PAGE_ALIGN(table + len);
+	memblock_reserve(start, end - start);
+}
+
+/*
+ * Reserve the units the table records. The architecture calls this once the
+ * kernel image, the initrd and its other early reservations are in memblock,
+ * so that a unit sharing frames with them leaves those frames alone.
+ */
+void __init efi_poisoned_memory_reserve_units(void)
+{
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return;
+
+	efi_poison_reserve_units(efi.poisoned_memory, &efi_poison_hdr);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index efaf63f9a54edd..396e0d61112205 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1286,6 +1286,14 @@ struct linux_efi_poisoned_memory {
 
 #define EFI_POISON_UNIT_SIZE	SZ_2M
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void __init efi_poisoned_memory_reserve(void);
+void __init efi_poisoned_memory_reserve_units(void);
+#else
+static inline void efi_poisoned_memory_reserve(void) { }
+static inline void efi_poisoned_memory_reserve_units(void) { }
+#endif
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*

-- 
2.53.0-Meta


