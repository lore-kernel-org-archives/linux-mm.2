Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3829E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 10:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0B46B0088; Thu, 19 Feb 2026 05:16:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD23A6B0089; Thu, 19 Feb 2026 05:16:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0FF6B008A; Thu, 19 Feb 2026 05:16:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADD86B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:16:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 584591C479
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:16:47 +0000 (UTC)
X-FDA: 84460802454.23.1B26693
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id EC250120010
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:16:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLaNkA8J;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771496206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHq1lJz2J+Vr0/qmakjk2n4bdY658r/yD35yzWNByno=;
	b=KAfvhvnzUw/wVd2ZQC7YEYcgVgH2V0AgMfB4x+6+Q7cv50jrVYZGc92fZpomcGSppSCwkc
	sOLUvY/6eu66HWgXaZryjiSSxGadtwRYt63dxu5HPTU1E2cCcoE4VbpLj9FhgB44ANcaXk
	3fZKjIvx2XPiK1yDDSgja5oWmIwx3vg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLaNkA8J;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771496206; a=rsa-sha256;
	cv=none;
	b=myUKL8Ie7h0bv/BbdhYkuZ+5qCLsLBmya8VFTm26fVjkC15OTMAPUXwyjp85SlaA/ETfXW
	uH0x1QTHQr8/3Ww3ZNPTKvf0FtP4nun9KYtEfk91TAhYBaDnLJZodbSvAJZu2w9+5QBek3
	L52vPIBbhQjvV84b+j6sTOzbquZSr7Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 311B260145;
	Thu, 19 Feb 2026 10:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA030C4CEF7;
	Thu, 19 Feb 2026 10:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771496204;
	bh=0g0IufzCaKhJCJrtzWjK2wHUvAmMA/mx5rbLjYPGZA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eLaNkA8JGe90LKOl0pNH5r61NHYNd1u/2vO+eJFmpRUL5FRFfXE2bge1UWKyx9yHG
	 PwxdArEo9ZxkZVa49N8wvV9YOfNYKkBd1+i3QH1qMl6d46YwNrSfXCrrVceJ4kVlAB
	 i3h0Q1yevXfXCLGP++wL46qrsR7gUDHdHkejfdxl76Z/d/uZrNNX1JdLMr0fgUkwrd
	 78Zuu6cT/EPSDBU5damNt1+1ezXXH1QOO3R0eSjZAMO9vA9Qaevf+TiJf2tG4b7Rgv
	 SYIWAbjPVlB3sGhu1/bRDWtSpCu3MwDZG6BzQlo0ZaAlgOVXIrj1j48fIDt22zoNj9
	 tqH+NX7UEVaog==
Date: Thu, 19 Feb 2026 12:16:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
Message-ID: <aZbjCFqlqdFwKSHR@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
 <aZVyxKVS8y-rqwrK@kernel.org>
 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: EC250120010
X-Rspamd-Server: rspam02
X-Stat-Signature: c11i4y4cicnmeow74uzydpfqa7xmwiq6
X-HE-Tag: 1771496205-18313
X-HE-Meta: U2FsdGVkX1+QxocSBugFw8dIUxAp5XFBGjt3gLmYHB6J3p7tK1l5re+uEsD0/IOMLyshdHZU7Hrz6PI0hbtQGfCFbMM/ORfkP5nXC7ENEW31ZrdUoPFuu31O8q2dyE39PiNu2ZGKckBSD4Wr0oIvfTlJaH5wFctCMHNpzsoJ2Kja/jxPq53E9LMUlz3CGCjJo1tUWfBD7x4ZO9cD4a/J96WLVAjviDfDMaengUXgHOLXmYtLR2sC9WhWBtK3PhPm6V22b/C40KN1NAt+RXr804ZLJok4W8YW5iz5/9Hnml0k0Zqgrrwqbs9S0E5V3jU+RZqKXbP7wEQzbat9yLqQnCY6wlMTZO23n0qR2G6ZI+2KwhonrTnQuApgyWFwZBPk4r1ARicOWdABnv+uh3gE0Bd3KwKr/iPp4C0b8+i5ljaRMceWOn09nMBAgEf8tDKZSsIBPfY+6DkovxlriAfbiDHezbHmB0hW3AKZ4jcALX5JcaX+PJe1Q1dGvv24dvvWPiE7lu8whQXUmSOzhn4hZFpwVYSAl05/zQftQ3BxFIWSr2s8v0ToGblfcVCYIx9cnoPUNQKpyDXHRDSmSzTNWNgzp4YPcqhQkouGznskVwzAMSK9uQk1x7B981yVmM4bsX18cx7gfJm0vC+bA+4QkNTN2L/nWnD4uqs+RLYdM1+dFKvbbVrGDAN9iH2h3gu9UI7rw8YCsJFP2XzrtPN3IOfQPjw0zwEh8veITKxCACA6y3QlCv0x8gb/GAYesnqbcq7Vc5cFpIJx/v0JP8SF8inHh1OlNF0C7JMFGryspb8yVOhDv/RDSIWvMSyqsvyMPyFiICwptsxmwCdLQKf514QqbHiTBaxyiislxuYCqDcefmLf2T4xbHSfabtyI2SWBLsgGFnx1NEKvbTvUXiP8xMtZ58Tex4hg+iXHmnVvN924pDR6Ql4+Wo55giHbxBKgNPsxilrfATuFOPr1PP
 6bfzrCck
 z0y2o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 01:48:16PM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2026-02-18 at 10:05 +0200, Mike Rapoport wrote:
> > Apparently we do miss some piece of the puzzle, otherwise you'd see no
> > crashes :)
> > 
> > I think an easy and backportable fix would be to make
> > efi_free_boot_services() an initcall, so that it will surely run after
> > deferred pages are initialized.
> > And since the boot services memory is not memblock_alloc()ed but rather
> > memblock_reserve()ed, it should be freed with free_reserved_area().
> > 
> > With the symptom fixed, we can audit memblock_free_late() and
> > free_reserved_area() callers and see how to make this all less messy and
> > more robust.
> 
> I will play around. The biggest issue I see with this is that
> efi_free_boot_services() also manipulates the efi memmap, and that's
> done without any locking whatsoever.
> 
> I'm semi tempted to split that part. We can unmap the boot services
> from EFI memory in the current spot, and defer the actual freeing.

Let's split it. EFI does weird things with memory already, like mremapping
normal memory for example.

Here's my take on the split. Lightly tested on qemu and recovered ~45M of
ram with the OVMF version I have :)

From fdfbda756d6107a7bc7c3ad4eb589af810ddba49 Mon Sep 17 00:00:00 2001
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
memory map is complete. The freeing path

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

More robust approach is to only defer freeing of the EFI boot services memory.

Make efi_free_boot_services() collect ranges that should be freed into
an array and add an initcall efi_free_boot_services_memory() that walks
that array and actually frees the memory using free_reserved_area().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 42 +++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 553f330198f2..bba1fb57a4bd 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -404,17 +404,32 @@ static void __init efi_unmap_pages(efi_memory_desc_t *md)
 		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
 }
 
+struct efi_freeable_range {
+	u64 start;
+	u64 end;
+};
+
+static struct efi_freeable_range *ranges_to_free;
+
 void __init efi_free_boot_services(void)
 {
 	struct efi_memory_map_data data = { 0 };
 	efi_memory_desc_t *md;
 	int num_entries = 0;
+	int idx = 0;
 	void *new, *new_md;
 
 	/* Keep all regions for /sys/kernel/debug/efi */
 	if (efi_enabled(EFI_DBG))
 		return;
 
+	ranges_to_free = kzalloc(sizeof(*ranges_to_free) * efi.memmap.nr_map,
+				 GFP_KERNEL);
+	if (!ranges_to_free) {
+		pr_err("Failed to allocate storage for freeable EFI regions\n");
+		return;
+	}
+
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
@@ -471,7 +486,15 @@ void __init efi_free_boot_services(void)
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
@@ -512,6 +535,23 @@ void __init efi_free_boot_services(void)
 	}
 }
 
+static int __init efi_free_boot_services_memory(void)
+{
+	struct efi_freeable_range *range = ranges_to_free;
+
+	while (range->start) {
+		void *start = phys_to_virt(range->start);
+		void *end = phys_to_virt(range->end);
+
+		free_reserved_area(start, end, -1, NULL);
+		range++;
+	}
+	kfree(ranges_to_free);
+
+	return 0;
+}
+late_initcall(efi_free_boot_services_memory);
+
 /*
  * A number of config table entries get remapped to virtual addresses
  * after entering EFI virtual mode. However, the kexec kernel requires

base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
-- 
2.51.0

 
> Cheers,
> Ben.
> 

-- 
Sincerely yours,
Mike.

