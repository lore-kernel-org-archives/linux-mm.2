Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F7D4C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6320C6B0093; Wed, 16 Sep 2026 11:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E23E6B0095; Wed, 16 Sep 2026 11:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0856B0096; Wed, 16 Sep 2026 11:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 297506B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:40:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4383A8077A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:40:03 +0000 (UTC)
X-FDA: 85220036286.08.B91F7A2
Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 074C1120011
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:40:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2GkJ7ud;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789573201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rNAbUEn+P2bvvYOlZ5debpHxHDk94L90O6Ky42mqxw=;
	b=dzFvkV3lR0++fjkbdTFtQiIwwKFOIxmmmYW/D0MY2SSHyblWXE7CuhjxP+hYgKerQqUlMS
	77jGZpZOIYu00szaLkHUvKt4jwFNW1JW2hR1qPC+rvY3WBP2YFlHcqVNr+fdMKp7+GPtRX
	NSzSY4fU6MsKTNq9Q14XScyZAbINAPE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789573201;
	b=h5/b9M/DqRSH/EvnkdOD3SSCWtUy338erWa/xx5zgpYx+Nwsi7SgEYgHUh/Ik9LzAwmcfo
	SNlsLI9t9IK85F+R4j9IjqtFoncYvYyEX45ALVex/uiZAFTCWTiCk9rFvBwhMRxhIjYaLY
	oDMUG5fBX0vTaq8+TMf+3WCzMCYZ3Ks=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2GkJ7ud;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7tSYx1YNaVm49StAg6iVU/9rtvR8g/9RYPq4x+SxYQs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789573199; v=1; x=1790177999;
 b=S2GkJ7udYAy1rj1ZYrcWezocAALqVdwo5zRefftGOE/6y8e9BIQ8quM0fEIK/i8Fhw67S0qx
 DmkSoXzNoaR+J6Pdxt5NHzZO0Rqzt3f6ZHlrS6EXXu6qoQfEDG65gw5mWOEiYEBwCRW2qmGUbZk
 HCslw6VmCq3AZASQkAAn4yfI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 55f1b8f3b5fd4211;
	Wed, 16 Sep 2026 15:39:57 +0000
X-Mizu-Trace-ID: 55f1b8f3b5fd4211
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Breno Leitao <leitao@debian.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kas@kernel.org,
	kexec@lists.infradead.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	hannes@cmpxchg.or,
	shakeel.butt@linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rmikey@meta.com,
	riel@surriel.com,
	harry@kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/9] mm/memory-failure: libstub: install the poisoned-memory EFI table
Date: Wed, 16 Sep 2026 08:39:53 -0700
Message-ID: <20260916153954.1054456-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 074C1120011
X-Stat-Signature: 9qj36msg91zk7kkrkcn8g3dgqxfabxu8
X-HE-Tag: 1789573200-432185
X-HE-Meta: U2FsdGVkX1/0lSIu9Z/P0DYt2slRq5cWPItjHGR2skyINvIOd/0QfiRku4gj23GZyH7zfyFPru4k20tTTS3B5N4ljf9bWDE3WWgRlSreOQazGDbfjElFFfvUkknnlxyZCZUwwQsfZ+87xJqWqzSQ2b7b13QFplWJWR6rT6WfEjJ/BH98y7vyosfvfmjQXGzChQNooZlQEmz8XF4RSU2dFO8A0jIw90DaUgp05mlFjgkwL6sDxaJoXpg2c8TovR/5opKc7VJtTnER9u/Otm5Gd2Saua3OaEIYEXLt7hm4YYa8VAkl9BR0ipvzrMsUrpWx5KEhKgypXWVwIq9y7pzvnzKXSoCcQMV2eb9Zf+6SeqYqUUZuF6lUMWwVaSmdZCTeAogmZv+USoo9MK8D8bYwCcvlNk3z6iqriw5p7gqo73ylqvrYgjHGmYgksuYttk/KqHUufA02bmsu8w/LUcb0JBN6wTS2fRwQluXoi6366qoiY1mR8MAE0R+HXKy7fqAFBdChZ/9fAYsFRmgPTFpM/ejc2Q89JZZLkvdiCvWqVJoHTGnXviMZnSZ2vD4N9+s4rdyXvbL04eaSG2BQ6IF/eze44qf0dPXUhr09Mdxa1ATq5AVytadANbbAzND0WDKe3pSo9+cBx+JFZFzzqFdMsrilQ4XNLM04g5Pwcx43KXk/IuchDMGONtw75B9RYpUJbvELdP06eNWy09aSK06fbRnhSbU62NGut+pxSEFefsdjv0KkFCmcW1kAhCyitCf8QhpzN02rZ4do7rPRja3Hy8sGkMOtKtKlYlvd8oFrFDVEWPrilmM1BAw5do90oTtjwmnlGebZclhrNw+edczGLrZU3Tdoc9seSu8KcVspjY/TLlMEALoeT6mIHVdVIrXmWmo42W3w1vvUm/UmRRoLKIjrYGx3/zB3livRuFl+oFYO8ecpCzZmrcn2JGt16+sGnF8pRSNwojg/ohmXC+R
 CY+yvqZr
 ix6RHosnP7L/FBIbLJRvgvKDQ5+A4ezOyD57qJmOqruwc60UpKkSXquwPtSAKTRii96Sz9hfEwOborr371K68U+bKvJWkoqznDkIZPvccSnDWV2lqYsNzByjgOt92qULV2tWFuMQuY11C/YndvIz+Kl/75ha08LKLh9u7DNNWDRq0OmlSzdBDTC4HYGXmWA09z0ikoqVyXb62JhAm3QVcR5tLlT1ex/sagiatUZmlBYlOKWp0GwqCXyf8t17gIey02iO3FeaTWdNrjRs1LSpAYWXDXhyho/ZBLgK74ThaPCZRg85cbNDaZBKQit2xpcDeGsbYYOfsZVovHBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 05:53:37 -0700 Breno Leitao <leitao@debian.org> wrote:

> A EFI config table can only be installed while boot services are still
> up, so the stub has to create it; the running kernel can only flip bits
> in a table that already exists.
> 
> Size the bitmap from the span the UEFI memory map describes, which
> efi_get_ram_range() walks since the stub has no max_pfn. Bit 0 covers
> the bottom of that span, recorded in phys_base, so a machine whose RAM
> starts high does not pay for the hole below it. Memory the firmware
> hot-adds later sits outside the span and is not carried across a kexec.
> 
> One table has to serve every architecture, and what they agree on is the
> attribute: setup_e820() takes a descriptor as RAM only if it is writeback
> cacheable, and so does is_usable_memory() on arm64.
> 
> The bitmap spans from the lowest to the highest descriptor that is
> write-back cacheable or unaccepted memory, as discussed with Kiryl. That
> leaves out the MMIO apertures, which sit high enough to stretch it far
> past the RAM it needs to describe.
> 
> At one bit per 2M that is 64K per TiB, and 256M at the 4PB x86
> architectural maximum. The 2M granule is called "unit" here, and the
> table carries it so the granule can change later without breaking the
> kernels already reading it.
> 
> Allocate it as EFI_ACPI_RECLAIM_MEMORY so the next kernel does not take
> it for free RAM, and install it empty.
> 
> A table installed by an earlier boot rides the system table across kexec
> and is reused as-is.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 103 +++++++++++++++++++++++++
>  drivers/firmware/efi/libstub/efi-stub.c        |   1 +
>  drivers/firmware/efi/libstub/efistub.h         |   6 ++
>  drivers/firmware/efi/libstub/x86-stub.c        |   2 +
>  4 files changed, 112 insertions(+)
> 
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index 48f93f7758e9e9..9c66e06c972c5a 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -774,3 +774,106 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
>  			efi_warn("Failed to remap data region non-executable\n");
>  	}
>  }
> +
> +#ifdef CONFIG_EFI_POISONED_MEMORY
> +/*
> + * Find the base and top of the memory, so, we can create the bitmap for
> + * the full range.
> + */
> +static efi_status_t efi_get_ram_range(u64 *base, u64 *top)
> +{
> +	struct efi_boot_memmap *map __free(efi_pool) = NULL;
> +	u64 ram_base = ULLONG_MAX, ram_top = 0;
> +	efi_status_t status;
> +	int i, nr_desc;
> +
> +	status = efi_get_memory_map(&map, false);
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	nr_desc = map->map_size / map->desc_size;
> +	for (i = 0; i < nr_desc; i++) {
> +		efi_memory_desc_t *d;
> +
> +		d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
> +		if (!(d->attribute & EFI_MEMORY_WB) &&
> +		    d->type != EFI_UNACCEPTED_MEMORY)
> +			continue;
> +		ram_base = min(ram_base, d->phys_addr);

Can this use the architecture's full RAM predicate?  On x86,
setup_e820() maps EFI_LOADER_CODE, EFI_LOADER_DATA, both boot-services
types, and EFI_CONVENTIONAL_MEMORY as E820_TYPE_RAM without requiring
EFI_MEMORY_WB.

If a non-WB descriptor is at either end of RAM, this code omits it
from the bitmap span.  efi_hwpoison_record_pfn() then rejects a
poisoned PFN there, so the next kernel can allocate the bad frame.

One possible way to preserve the x86 behavior before applying the WB rule is:

    if (IS_ENABLED(CONFIG_X86) &&
        (d->type == EFI_LOADER_CODE ||
         d->type == EFI_LOADER_DATA ||
         d->type == EFI_BOOT_SERVICES_CODE ||
         d->type == EFI_BOOT_SERVICES_DATA ||
         d->type == EFI_CONVENTIONAL_MEMORY))
            goto include;
    if (!(d->attribute & EFI_MEMORY_WB) &&
        d->type != EFI_UNACCEPTED_MEMORY)
            continue;
include:
    ram_base = min(ram_base, d->phys_addr);


> +		ram_top = max(ram_top,
> +			      d->phys_addr + d->num_pages * EFI_PAGE_SIZE);
> +	}
> +	if (!ram_top || ram_base == ULLONG_MAX)
> +		return EFI_NOT_FOUND;
> +
> +	*base = round_down(ram_base, EFI_POISON_UNIT_SIZE);
> +	*top = round_up(ram_top, EFI_POISON_UNIT_SIZE);
> +
> +	return EFI_SUCCESS;
> +}
> +
> +/* The size of the bitmap */
> +static u64 efi_poison_bitmap_size(u64 span)
> +{
> +	u64 bytes = DIV_ROUND_UP(DIV_ROUND_UP(span, EFI_POISON_UNIT_SIZE),
> +				 BITS_PER_BYTE);
> +
> +	return round_up(bytes, sizeof(unsigned long));
> +}
> +
> +static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
> +							  u64 bitmap_size)
> +{
> +	struct linux_efi_poisoned_memory *pm;
> +	efi_status_t status;
> +
> +	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> +			     sizeof(*pm) + bitmap_size, (void **)&pm);
> +	if (status != EFI_SUCCESS)
> +		return NULL;
> +
> +	pm->version = 1;
> +	pm->unit_size = EFI_POISON_UNIT_SIZE;
> +	pm->phys_base = phys_base;
> +	pm->size = bitmap_size;
> +	memset(pm->bitmap, 0, bitmap_size);
> +
> +	return pm;
> +}
> +
> +/* This needs to be done while boot service is still active */
> +void install_poisoned_memory_table(void)
> +{
> +	efi_guid_t poisoned_memory_table_guid = LINUX_EFI_POISONED_MEMORY_TABLE_GUID;
> +	struct linux_efi_poisoned_memory *pm;
> +	u64 ram_base, ram_top, bitmap_size;
> +	efi_status_t status;
> +
> +	/* A table installed by an earlier boot rides the system table across kexec. */
> +	pm = get_efi_config_table(poisoned_memory_table_guid);
> +	if (pm) {
> +		if (pm->version != 1)
> +			efi_err("Unknown version of poisoned-memory table\n");
> +		return;
> +	}
> +
> +	if (efi_get_ram_range(&ram_base, &ram_top) != EFI_SUCCESS) {
> +		efi_err("Failed to size the poisoned-memory table!\n");
> +		return;
> +	}
> +
> +	bitmap_size = efi_poison_bitmap_size(ram_top - ram_base);
> +	pm = efi_poison_alloc(ram_base, bitmap_size);
> +	if (!pm) {
> +		efi_err("Failed to allocate poisoned-memory table!\n");
> +		return;
> +	}
> +
> +	status = efi_bs_call(install_configuration_table,
> +			     &poisoned_memory_table_guid, pm);
> +	if (status != EFI_SUCCESS) {
> +		efi_bs_call(free_pool, pm);
> +		efi_err("Failed to install poisoned-memory config table!\n");
> +	}
> +}
> +#endif
> diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
> index 235c9738da2d63..22a315e2814a1a 100644
> --- a/drivers/firmware/efi/libstub/efi-stub.c
> +++ b/drivers/firmware/efi/libstub/efi-stub.c
> @@ -179,6 +179,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
>  			 EFI_RT_SUPPORTED_SET_VIRTUAL_ADDRESS_MAP);
>  
>  	install_memreserve_table();
> +	install_poisoned_memory_table();
>  
>  	status = efi_boot_kernel(handle, image, image_addr, cmdline_ptr);
>  
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index fd91fc15ec810b..44436869c4efe1 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -1169,6 +1169,12 @@ efi_enable_reset_attack_mitigation(void) { }
>  
>  void efi_retrieve_eventlog(void);
>  
> +#ifdef CONFIG_EFI_POISONED_MEMORY
> +void install_poisoned_memory_table(void);
> +#else
> +static inline void install_poisoned_memory_table(void) { }
> +#endif
> +
>  struct sysfb_display_info *alloc_primary_display(void);
>  struct sysfb_display_info *__alloc_primary_display(void);
>  void free_primary_display(struct sysfb_display_info *dpy);
> diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
> index 0bae0f06b6763a..3136132b9628ab 100644
> --- a/drivers/firmware/efi/libstub/x86-stub.c
> +++ b/drivers/firmware/efi/libstub/x86-stub.c
> @@ -1024,6 +1024,8 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
>  
>  	setup_unaccepted_memory();
>  
> +	install_poisoned_memory_table();
> +
>  	status = exit_boot(boot_params, handle);
>  	if (status != EFI_SUCCESS) {
>  		efi_err("exit_boot() failed!\n");
> 
> -- 
> 2.53.0-Meta
> 
> 

