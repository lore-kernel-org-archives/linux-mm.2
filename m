Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A37E98DEF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699286B0088; Mon, 23 Feb 2026 02:52:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670E26B0089; Mon, 23 Feb 2026 02:52:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F9D6B008A; Mon, 23 Feb 2026 02:52:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44BC06B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:52:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D11A11608BA
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:52:29 +0000 (UTC)
X-FDA: 84474954018.17.A583744
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4694C40009
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:52:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eoffjR6f;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771833148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FNB+eU50o/k6BmwGTAwwLc59X60+JDE6Z0SKBC+s8iw=;
	b=pAONzVP+aSw4dVmQI+Spcrdt0+7+S2Ttczrvh15JNDTPT1J2VNmJAudCI086Y6pDR1PP29
	0bIKejWED7dYPq8uixePdgbajts5mq9KrZ/74F+HfV+j/+zYa6WSgGZZuXEqWTkEtkXOhR
	CfvCyMJPppGTWZh681+V5ZElUVnEyes=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eoffjR6f;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771833148; a=rsa-sha256;
	cv=none;
	b=3HV790VQwPzZ84b7la07GHubm3LbFrCTydzMuxwzGgFQD99u/iBl787zSL2A2xBVOVIlvg
	uinfZloxmgmvMX+CwJ5ZRe6pbRp0PnODLgLgubchZFTQofuuv8VmA93IVGTUeHdCjbckTc
	bDkJzUWjPTxQRsHDkUv9kr5SPP0AP4s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A369435D1;
	Mon, 23 Feb 2026 07:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D89C116C6;
	Mon, 23 Feb 2026 07:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771833147;
	bh=o6m22EVDJ5DpW7NSyjzseogj16NqUne7RZedNk2eh2g=;
	h=From:To:Cc:Subject:Date:From;
	b=eoffjR6fi3EQW/7y4hgpBpQau0BS5xtMXVzov8ucqDKVpzKe/QOEQUQkqti9Zn9WY
	 kOjj/NuyTtbnCuR0rFzFKGONb3W2JXUYyVriFhp9vOorb5T9WFJOoyxYYestXSSK06
	 ZQAqkLhmBkQyKZaINchtPFGuS2lYLiqrQiVHevrwSO9wnG8AnlJOb9QPesv8LGOf4D
	 cmSYTeK281Ft/YoVYAl1zycGnkQzvsKDVbqRl948NFfm3Pb7C5+SX3glJNMPDvBCUC
	 joCYFzYt2fdoF/+evnelaaBuPDSl8DsAzwZLgAHZxdnCWfQQV2xwgA08CcF+WsYjKr
	 DF+GdudoB2Bfw==
From: Mike Rapoport <rppt@kernel.org>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH] x86/efi: defer freeing of boot services memory
Date: Mon, 23 Feb 2026 09:52:19 +0200
Message-ID: <20260223075219.2348035-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4694C40009
X-Stat-Signature: ndunorydi8baqd9cfbkjgx7fkixidqww
X-Rspam-User: 
X-HE-Tag: 1771833148-680066
X-HE-Meta: U2FsdGVkX1+lkZFugWk8gWVPX3Ia+dNk6ogWWEVTMXZGZen/tOkc826yd3ejzvqibnCbmLCAVSXNJuGx53PJcprews9fJKFYfRs0PxTrMcqNR95dnTP8SeZdIqK59umsVpaBvN29kEzsg202haTNfjK9opAACQkvOcsiAyb53AQxfDivWogGoV29FJWPwa3WriYXpdlY93A9zC09bHDaT12xy2g5MtOpXjykEeVBd/98d4kObQjPCrbXCLCNyb6x3lsfPI3BZhRUVAnxZXZfl+IL4deN8MUk1QE6wJrwIDug3vWGmjSSC2HXMGSmwYNeSU/HX6SIUeFlUQWArQUIMiEtU/byKc4UIV4FID8qloXv1rsn/WI99fNS51t7n0942AzL0IIvd0S1DKOZ+s806oTd737iYAwAOMda8ifbuPOFLf3yNN7XjJEz5m1NJIhOuHjsf4/+beTq056Q9sLSSWLqMD0WzlBs6G5KPhEQUx3OiI7LFxebiGEw6BWjtoAoSyTSxNf4BfQc+gyhmAU0o6mab6TbmyMUb8yjk/c5sLeJfkn0ePayUe21Gj0DjcHUgLRBkH3v/f4jgl3CXFHxfOI+xgfjTBhbb+NOFH0nVu4Whgy2SbfRRdF1+HAk1X2OwbsYxVwfPJVuFETh0vX0rlZgXdbK45IGp5ktYYn8Xmnh8JEkIfOZYjpixff3HZiCcR4ZUyCaFi9vh3Bxf+DWZmCJh3jHiUEG80FZWLSWsBVo+naJPo7BO02jruUGZoGOyEDEuz/9eV/FKodsSDed4lXwOVtMMaSA/zci8GmatZamA+BuowcO2Iz+0wzeoel6HZhpcN7p5dmKRMBbGWhxgYEWNPGmiV8vEA0z9KaaqSfrcsZCrXj43s/dMITDNpxqyqP2nkdSZEItrB2oYh9VS3S0MgjoHF4YbKj8+rCxBGYOQ7AcKX2ZPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
and EFI_BOOT_SERVICES_DATA using memblock_free_late().

There are two issue with that: memblock_free_late() should be used for
memory allocated with memblock_alloc() while the memory reserved with
memblock_reserve() should be freed with free_reserved_area().

More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
efi_free_boot_services() is called before deferred initialization of the
memory map is complete.

Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
RAM on EC2 t3a.nano instances which only have 512MB or RAM.

If the freed memory resides in the areas that memory map for them is
still uninitialized, they won't be actually freed because
memblock_free_late() calls memblock_free_pages() and the latter skips
uninitialized pages.

Using free_reserved_area() at this point is also problematic because
__free_page() accesses the buddy of the freed page and that again might
end up in uninitialized part of the memory map.

Delaying the entire efi_free_boot_services() could be problematic
because in addition to freeing boot services memory it updates
efi.memmap without any synchronization and that's undesirable late in
boot when there is concurrency.

More robust approach is to only defer freeing of the EFI boot services
memory.

Make efi_free_boot_services() collect ranges that should be freed into
an array and add an initcall efi_free_boot_services_memory() that walks
that array and actually frees the memory using free_reserved_area().

Link: https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org
Fixes: 916f676f8dc0 ("x86, efi: Retain boot service code until after switching to virtual mode")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/include/asm/efi.h          |  2 +-
 arch/x86/platform/efi/efi.c         |  2 +-
 arch/x86/platform/efi/quirks.c      | 55 +++++++++++++++++++++++++++--
 drivers/firmware/efi/mokvar-table.c |  2 +-
 4 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index f227a70ac91f..51b4cdbea061 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -138,7 +138,7 @@ extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
 extern void efi_crash_gracefully_on_page_fault(unsigned long phys_addr);
-extern void efi_free_boot_services(void);
+extern void efi_unmap_boot_services(void);
 
 void arch_efi_call_virt_setup(void);
 void arch_efi_call_virt_teardown(void);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d00c6de7f3b7..d84c6020dda1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -836,7 +836,7 @@ static void __init __efi_enter_virtual_mode(void)
 	}
 
 	efi_check_for_embedded_firmwares();
-	efi_free_boot_services();
+	efi_unmap_boot_services();
 
 	if (!efi_is_mixed())
 		efi_native_runtime_setup();
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 553f330198f2..35caa5746115 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -341,7 +341,7 @@ void __init efi_reserve_boot_services(void)
 
 		/*
 		 * Because the following memblock_reserve() is paired
-		 * with memblock_free_late() for this region in
+		 * with free_reserved_area() for this region in
 		 * efi_free_boot_services(), we must be extremely
 		 * careful not to reserve, and subsequently free,
 		 * critical regions of memory (like the kernel image) or
@@ -404,17 +404,33 @@ static void __init efi_unmap_pages(efi_memory_desc_t *md)
 		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
 }
 
-void __init efi_free_boot_services(void)
+struct efi_freeable_range {
+	u64 start;
+	u64 end;
+};
+
+static struct efi_freeable_range *ranges_to_free;
+
+void __init efi_unmap_boot_services(void)
 {
 	struct efi_memory_map_data data = { 0 };
 	efi_memory_desc_t *md;
 	int num_entries = 0;
+	int idx = 0;
+	size_t sz;
 	void *new, *new_md;
 
 	/* Keep all regions for /sys/kernel/debug/efi */
 	if (efi_enabled(EFI_DBG))
 		return;
 
+	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	ranges_to_free = kzalloc(sz, GFP_KERNEL);
+	if (!ranges_to_free) {
+		pr_err("Failed to allocate storage for freeable EFI regions\n");
+		return;
+	}
+
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
@@ -471,7 +487,15 @@ void __init efi_free_boot_services(void)
 			start = SZ_1M;
 		}
 
-		memblock_free_late(start, size);
+		/*
+		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
+		 * map are still not initialized and we can't reliably free
+		 * memory here.
+		 * Queue the ranges to free at a later point.
+		 */
+		ranges_to_free[idx].start = start;
+		ranges_to_free[idx].end = start + size;
+		idx++;
 	}
 
 	if (!num_entries)
@@ -512,6 +536,31 @@ void __init efi_free_boot_services(void)
 	}
 }
 
+static int __init efi_free_boot_services(void)
+{
+	struct efi_freeable_range *range = ranges_to_free;
+	unsigned long freed = 0;
+
+	if (!ranges_to_free)
+		return 0;
+
+	while (range->start) {
+		void *start = phys_to_virt(range->start);
+		void *end = phys_to_virt(range->end);
+
+		free_reserved_area(start, end, -1, NULL);
+		freed += (end - start);
+		range++;
+	}
+	kfree(ranges_to_free);
+
+	if (freed)
+		pr_info("Freeing EFI boot services memory: %ldK\n", freed / SZ_1K);
+
+	return 0;
+}
+arch_initcall(efi_free_boot_services);
+
 /*
  * A number of config table entries get remapped to virtual addresses
  * after entering EFI virtual mode. However, the kexec kernel requires
diff --git a/drivers/firmware/efi/mokvar-table.c b/drivers/firmware/efi/mokvar-table.c
index 4ff0c2926097..6842aa96d704 100644
--- a/drivers/firmware/efi/mokvar-table.c
+++ b/drivers/firmware/efi/mokvar-table.c
@@ -85,7 +85,7 @@ static struct kobject *mokvar_kobj;
  * as an alternative to ordinary EFI variables, due to platform-dependent
  * limitations. The memory occupied by this table is marked as reserved.
  *
- * This routine must be called before efi_free_boot_services() in order
+ * This routine must be called before efi_unmap_boot_services() in order
  * to guarantee that it can mark the table as reserved.
  *
  * Implicit inputs:

base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.51.0


