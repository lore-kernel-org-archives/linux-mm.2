Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 954F3F357D5
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 06:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001B26B0005; Wed, 25 Feb 2026 01:56:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04216B0088; Wed, 25 Feb 2026 01:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3AC86B008A; Wed, 25 Feb 2026 01:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D232D6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:56:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 675DA140340
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:56:05 +0000 (UTC)
X-FDA: 84482069490.03.7A8ED0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E7FE41C000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:56:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SkEd7g1M;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772002563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SMvqq1I9w5yHuM4iSRyIHCqh3C+S+Q6QAzoTW18r9U0=;
	b=H7T8GJ30U+BL+97BGtPW8/Okl0B4V2LWI1LmJSebUHnB8FX/2salSxP56HhNjwpEuymsj9
	lUeAy48yLe1Nu2CtukociAB4D1ckYAe45xe9GDxSXrhx3TZVlEks7Wv8ry08ay7WMZ8k+j
	GpXGqwPfNEzEF6R7mg+emrg8b0zsqFI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SkEd7g1M;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772002563; a=rsa-sha256;
	cv=none;
	b=IngEbBc+Vxl1ej5uJTA42uAU/d9hhh7YLI9nW6E5EaUApWYl1r6c33TIOzgaJNMunEP1Za
	UiLF5aSYGGwvHWOOefzliPkdanX+Lzaixj7s4ElM/SQ/wnwmQQBPA7IkuIVbJb2YNmZmeE
	/aX21Qi8+CX99JFZv5ZeTutLNTzV1eI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 294DB600AA;
	Wed, 25 Feb 2026 06:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFC9C19425;
	Wed, 25 Feb 2026 06:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772002562;
	bh=c8mFbnM9U8FHHhGL8ssz28X5TtDgBLCNoO42oAAqqbQ=;
	h=From:To:Cc:Subject:Date:From;
	b=SkEd7g1Mj5AaEydDMbFzILf8tBoIZJKGMp96yd43Y0MJCHTwM82ONmBCoNFtVZzHi
	 D3P290d01ENWEEEIIG6mu7AwkXcz2oytKekOZWQu+dD0ft0PXI3sQeWyIrx5I3NJwI
	 +ya5o+VP/DOq4cKJXsWxRf8sLm0ErJfFl0OB0gJ9TG3gfDFJy/QCpT2vHH6v4p+5tk
	 EjT2EPxH2vgE83Fk9bQ9nw6rQIXSrKgBhSSX4KXH+t6VOlPKfKQwLimrlDwFH6ZDSZ
	 bvZ/+w8VMNsmA9i9k2V2OryXWT4BtuDHTkp5B/HzSOdkm1DTUNIjY8tpr+kn7v9XrR
	 Ik6t3ZZdPL5fw==
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
Subject: [PATCH v2] x86/efi: defer freeing of boot services memory
Date: Wed, 25 Feb 2026 08:55:55 +0200
Message-ID: <20260225065555.2471844-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cx18ex3mrftodb8ezk73nzedxmcd46nf
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E7FE41C000F
X-HE-Tag: 1772002563-689081
X-HE-Meta: U2FsdGVkX1+Rm77LhQ6nh0szjd5OpbNiZhCyNRsq34JuJ0oGUlTQjlG2X0s2ABWa3ip/U8GdivbkgGqorVNf8uYgCm3A8JZ3z+btDPXSHIfpidH9oKZvowVh9/ihviC4AfzVqsGqUeKQtAaawNm69Q4WJ/4csR58pOf79D0/Ty1B20SAVdVg7JE9uJgg5g/hE7aAi6obXqEbAc1AHteP9kFRWitfBfsJ0OMmjNrRe2ZUEiGWn0F8ucBIssETR2/mv3NS2ldZAeOWSJZrJG8zVbM6tQ+J9F4l9Dp41fPCk/rUkyABj8GRpoURMUU2eEeJgJKv48+YFSnd3zfb8xwqZORc3/cR3lGFVNGy4IZC+YpgeWqMMzCYu/ItMUmnL24BY/48Glo0eDu+rToEJDvniEbNdwMSvYRckiD0GdRXqkj2IvIE36GKLd1fZXhG82Sa080NbVG9D73Lwv2hEGhv7ENNgisLDyiaeB8pTbHFhSrGwMyuLj9bq3XYk3LE3vHU1sYNhgUymCW7MOHt3UXwLTfMKQ3qw6kN/U5uOH4qjhlNgMzr25LjLU3EldASU2D7AO0WjWLfciZjBz0ip++ILPSVrQciCvbIC47JnvAi0fjHhsVtiFL2galpW/WVrBLTeeAMwr2EZwinbN/3WFmAfFLAlZSclnbKauLzt3vB40jIf7gybHfIau4+XxgxP2v9Pm5zShGsz12GWg8SFe+BRKbWrraaelkoN0x3+vtXMiepdPXgCgZ6AaavDDLXCRNfV4oSrDqPUKh5Fs9l4U5CtlHKHqjfcade8ZbH/7fIvik0QQDRFdzyIkkA60iX3IzOIn5L5GbfrP/wua/4D5k1NDV//49Bzs19sv5Ys2MxPq7JOZSeju1XMNcTk46sBn15DxRJn3qMhD2/u60g/qBTcVi5pqz2v9D1Ux1Osft5A5ln82zysLqe+Hvhg2ifAdCVXBHhbJlLLH/ST73vEp9
 JtztjmGv
 0akg+xcy2T2/0CU6qVWyGAr1BRqamEbwZgs24QqrmvwV1M/WLnkCCHFKRQw51KFg+PxTBaxVXHrMm6H2yTeptoaeYvJDZLOQyrkXWIejdDuNsaS4Ssm7Uuzslt+jnrPRcsQ/pWd67Mcl0f2ZizHSttU9LRglKf6ySf4oq3vK/6VgWp2ZAxUfPwtFRW93Mrj0FwHZzS4dwBgPZyP6UMxRmtJodiIOnJr9YM7sh3LmDL7walEGT1xHAMpF9T/qZWit0TghzoAobbZJcKej+59ehTQxtXGm9pE1+rlxZ
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

Split efi_free_boot_services() in two. First efi_unmap_boot_services()
collects ranges that should be freed into an array then
efi_free_boot_services() later frees them after deferred init is complete.

Link: https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org
Fixes: 916f676f8dc0 ("x86, efi: Retain boot service code until after switching to virtual mode")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

v1: https://lore.kernel.org/all/20260223075219.2348035-1-rppt@kernel.org
* update the commit message with correct function names (Ben)

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


