Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0083C54FCC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD006B0088; Fri, 20 Feb 2026 04:09:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B076B0089; Fri, 20 Feb 2026 04:09:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6598C6B008A; Fri, 20 Feb 2026 04:09:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC786B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:09:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADB9D140BAF
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:09:09 +0000 (UTC)
X-FDA: 84464260818.24.8A1B1CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E950E18000D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:09:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s0zy1ncy;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771578548; a=rsa-sha256;
	cv=none;
	b=7L8FSbDBIhasxRdMgRsbnasEa36RYTRbuzINQhV0fnlDBXqAn0vaULSsZg1xs5q9Ag/DEV
	oaaiKhMqkVFVheDFtM8ygycrybWr5pR1Z8UvnM45X2+pi6+otonXqViyT2OkwChFQiNLZS
	rzYQZYWNYyYSJjdBOrx50oB0VYRmCT8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s0zy1ncy;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771578548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnkA2NvY+go3wBJZILUsu/sop4KBsapASaE6PUzXl90=;
	b=As6D6f354nkPu4cu03WNFPnGkc17d+W6G4cspMC+P08r4J098gBnkmPwYvf7Qn804EHfzW
	YFHg+ivmz4jIYL3A5uEy2uyrCgQAQI39LUDY+dDsnpaCQJVxesk7Fv9QWO6M5zDquWupns
	ob73boTtPLCJsJufSADGHMciFJNfrus=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6DA643B24;
	Fri, 20 Feb 2026 09:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A544C116C6;
	Fri, 20 Feb 2026 09:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771578546;
	bh=PrMNWmQ8PwMexj3Hg6lRnNzgGle6McQgz8GY4whJqLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s0zy1ncyYICduTFiX5ilSEiq2eMdyjPOee5ijMZOYmsZUuTLwUy6/bga0bPehXPhB
	 ajlrza0tvggjrvqXjZGEYkHDOfaM5HKbfTr9Gfdj4aKLhQuNkDpH8LLBFlPQgu7E8w
	 oq6iKAbDi9Fw77W3h5pUtslOrKbGyyyTwerH+Zc36nh8VAqCy38ahu+Bf2CEv7OPY6
	 pisM8tfcLib7OpGVcijWr0S+LKy2OtA9+xSA6HuLbkdJyu1JZtgEoCAn+FNtGU15Ye
	 pO7gHLlfLURULlZWWTB6KWVfoiFmwB6q2JV+noaeY1zf6qO2p8J1l1WVMcizVIGdy8
	 tYsRX/NlawLiA==
Date: Fri, 20 Feb 2026 11:09:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
Message-ID: <aZgkrVWmcz_mcn6b@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
 <aZVyxKVS8y-rqwrK@kernel.org>
 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
 <aZbjCFqlqdFwKSHR@kernel.org>
 <39289588fddb4844264546cd103ba4595430f313.camel@kernel.crashing.org>
 <1ef0f899dd03928651d2e07cff14e062be25d5cd.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ef0f899dd03928651d2e07cff14e062be25d5cd.camel@kernel.crashing.org>
X-Rspamd-Queue-Id: E950E18000D
X-Stat-Signature: g48i7bdgq3zh9dctrm88wm6r8xrwuway
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771578547-488094
X-HE-Meta: U2FsdGVkX19Nx23V5BTk7pEJQhzkby9+ED1impag2PBZjmf4tEInH6uBYAeM2ie7Lynia1ek63P/cAVIXsVi+ljECTyJyPrqe6m+HSpqARhF87YOeXErkB3DVJ5Me+9dHXTenmcgVTXUudZZf0eDSpc778G4IjGGXDcUlI5F2ylp+MU44vLbs4PAiOA/ffe8Rn+6mcmSTcj8Qysh+tFzK0JErzlfHksy9b0ROHJHo80wTew4f6bibvGbv5dXFh6fyPwJ5DthDZTAq7DHO0+PXvn7AwchOt/njq5/cn+8BcKG3vnJJe/SvWsrY+WQd6AtChZGrz4ZPZpDdhtwUF9mJ/lfBoY3BYWmwRbxX7Jpdzm20RzeWs2PrwL63C7lRidD2iOQQ9NGCQLcWefvsexV0vsNI6lW+rDl3/C11SP3TW4pYrH6v4h6i3gRlCi/IsYAcRglVRmhKzUf9yxdm5GdbbzGddeWWYPlNlqLdcP677BfXTkz80kfhvEbA8/Wlg/MgH4yf/MMhjLB3nshqOWTnDyHi7Qky666E9UnYp5PR5dN6vwyU9yYG1+IL4Ps+63fNJnRjBjBFqFwzyKX9qU4cdNd7JjeZ49hE6qXvuAJQw+B/SxdnrDh6jGYiJg9ZqUwXpUpVh06pIhK44kFunZmK6gCeZjZOh+jKRqyrq118hpoNyTIproSHNyq18GL/aehhc7Vz5Jwv2wFidjwpDpsKHBTrdAa9u5rwTyM57z2iwVbz9dHm7VJBOiPLjRURYXqZWy0Kwcm/KQgSpLzHVMPAMansvKDADNlZr7UoQCs8z9u29xclpwJvQKPJ7Pcv/SB1MeGj+AaPbyWfmjQ5n0MoBZxnrGJ4CFRd4ZoYm4AzSdGs15+qhg0YQleZR3NUVV30ZfverEACRY8jBKizS2svKZUGr2xg7sOlDBQ9Sxu4R9P80XCYblnGVaNbRYtymPopqGHwnmvDq9JM+Tn2ML
 3P12LquJ
 mFmKY1bxSrXZGNSrz7CsI8/c13kCobmQmbV5ufKtWG3kkCtYUhliZofYrFQqI6jMJnNic2HsE1D572YkBn6wg3iXsjuOA3KS6lkWtIxAyNUPWHwqQHJXc5Bo+XvdGL3PrObVa53XxB3DqsB24eTB3NUJmxXEOVRPUV8reOH6xNeZloJKqWM6CnuZONQlP2wvNJbmQ+sshSiGFUQNfpDbMP93c3dAnYU8eZ4hlRH4el/pFOkiYUEUt9kzN03TkGcfAdjYEYqvCrYSlDqhXY+Sv2eus3IHyZL8JxBJCnOfNVMp/yai8abTFrn+NWZOkWjGLnFKztZzlgs5+o0W+Unhs938mCV5NJpuokdaX9h1KsbV/rzK80Tp86QOhFHj1i4hjxH7Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 03:57:58PM +1100, Benjamin Herrenschmidt wrote:
> > > +late_initcall(efi_free_boot_services_memory);
> 
> Why late btw ? Any particular reason ?

It does not really matter, but then I thought that arch_initcall would read
more nicely there :)
 
> One very minor nit (but it kind of is annoying when you gather logs at
> scale and some people do look at this :-) ) is that the memory isn't
> accounted in the boot message:
> 
> Memory: 224440K/483372K available (16384K kernel code, 9440K rwdata,
> 11344K rodata, 3732K init, 6480K bss, 254088K reserved, 0K cma-
> reserved)
> 
> I'm not going to cry about this, but it might be nice to have the
> __initcall display how much extra if freed so it's just a log grep
> away.

Sure.
 
Here's v2 with fixes and updates. After you confirm it passes your
regression suite I'll send it properly to x86 folks.

From c05e37b848cd281a074b18ad28f0717a81649560 Mon Sep 17 00:00:00 2001
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 19 Feb 2026 11:22:53 +0200
Subject: [PATCH] x86/efi: defer freeing of boot services memory

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
index 463b784499a8..791c52c8393f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -837,7 +837,7 @@ static void __init __efi_enter_virtual_mode(void)
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
index aedbbd627706..741674a0a70c 100644
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

base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
-- 
2.51.0


-- 
Sincerely yours,
Mike.

