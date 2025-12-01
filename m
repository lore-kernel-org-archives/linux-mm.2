Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5247D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 344446B009B; Mon,  1 Dec 2025 13:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDC36B009D; Mon,  1 Dec 2025 13:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195A46B00B1; Mon,  1 Dec 2025 13:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F295E6B009B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:36:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95E27C02DC
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:36:09 +0000 (UTC)
X-FDA: 84171756858.28.401878E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1EAA740004
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:36:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pMhet+Fq;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764614168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMC9QNpmBCY2Pr27MZQErfA+KIssT8JJTsLdkmEPWWk=;
	b=jhwgrmKsKz6VNCxxRVRs48qsWy9R5IOgIWFhckNYVWgCav8m3dw2pJ2i8X+WWB2TR0/xjC
	ZAtwA3b4EJHepINNBQvKzJCXnoKQ0FCndWJfSiKiDlsqKTGHKnWpKkC3jdfw21M0d5yD0G
	iHcTG+/cqoVdN28TcN+jCZnJO/73BWA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pMhet+Fq;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764614168; a=rsa-sha256;
	cv=none;
	b=zwv/uBXr3fb+wqWrz/nR1mK4fF6/sb7bpl/6cEwFLiSbwK9GHtpazm9EHC/tzlyISWFAGn
	3mnfEuxSXiLBBlzS/DkQ1lmo/+ZxqqkklBjWCaqMxHe/shzo8HeIqTRkq4wkhxsEYPLemY
	DfGMuWmjbXbZVn5dNIl4Ncsx/rF8Wfw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 77E636014A;
	Mon,  1 Dec 2025 18:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0FEC113D0;
	Mon,  1 Dec 2025 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764614167;
	bh=GqUZ1tJI5oUYnsMVH3ZG4nNrDtR+42m3Jo4JWGTzt6I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pMhet+Fq3OUu5XL3bsQM2Ut07cJpCsYst6na1zeB9QV1LVueGKMNZVJOejLK0OW8u
	 eeRhAG8QCMeEIUdr7zEbNpDwSNbzmC2xc3TOAkRVTXJud4gK0Clqqj2FuZuKvsry1M
	 UZZWWPt4xmJ4XzQL0kwBzFXfsWFbPF+JQR8T/S/q20nRzpnyBTzanXMBGmEptQD6C/
	 Y4tTk2vYgkF8g4GXqo+JpuSce9pLJTEjw/gjuWc8P6vULU1p9h4vE0E159Fqj1sG59
	 dm0JbRXbwJoJSOnA8CuDKZRqRS2KB+Ehjn5WDu80qLF+9kH4ZpFh+1cHTRPIF5obsy
	 mpI1pbO18G9cQ==
Message-ID: <938a7948-7882-41a3-926b-3d2a8d07620d@kernel.org>
Date: Mon, 1 Dec 2025 19:36:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <ac479414-e0fa-49be-8a30-8f9c0e7b7d32@kernel.org>
 <73a69c03-feda-4c56-9db1-30ec489066fb@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <73a69c03-feda-4c56-9db1-30ec489066fb@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jsg4muh7i5tr7bdicwatj5p1grpzjkgc
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EAA740004
X-Rspamd-Server: rspam09
X-HE-Tag: 1764614167-847975
X-HE-Meta: U2FsdGVkX19q1DPe7+VoeCSGK8XKEuPyRPk8oFPsXTC536UIhJe5Mw2H7aHRm7EwL6wBBlx7rwu3KnHJcZOTmrYmQI7CF6xhN+r9+ij6al1JNUvb6YxBCb6G1Wm1vaKwfh689/++veF9MJGVOaKOy7FI70ARgMHyzDVPpoJ6bHIdhkkaQrDygh57j6m1OsfhGvvsYa/Tbguho9Aht7Ke/QbJ1/aQFfgIcdDyeZTfuij0G4/oitUYrjRhB4+R1mYpIgOKU0pfocZ9Qt+ROJU2ghrTZCgGizPauxkuCvVaHRGe11IvhO05aqptsqIs2eFctSwvEm+nYhK4+zum7IWriNwkAVjnC8tS12/LaU2AGpVSFalrUJplzYqDK6Fss/exOR//HWn+G2gIie49G3jMy+THSwiWS/QKR6Oahtf9llPWBk+xATRFAr6w2/ikk77LzWL3DcjmPLHpWITXZvlaRJRar3SxVvKt7TLF7+Vu+VinwIOaRxuZYkptUWimc0GbRlmFfaeIMQSE6BSri7nutymxx8iyvxP2wrnvIw6ZsvD5S2wQRt1lPpIMCvi7NGDXiEXp+QKtwMZXpKZY0K1goj9JfaWKuVl/GZ98Q4MVN4m72HL6clweCaS6ityekxfAVmPQsSomTb1j73tbELaq9046KKI5+PseojDGeaccknWAR1DA/GxHTHAEuCg3Ikb0AzOfeir1P5n2hThmkEPtBC282oV5PtQx/8Dcl6ata+m/MsUTrG0H0ancyIoJzwY5E3IZwUoae52s0PHdEjYzLaiR1PRnjBxOc1CAlZAFl+oKBAnADpwxYwbpOWNN+aJy8zrp+NsoJt8Fj0I5BBIh4ZfRwdFJnfQFgCoSmH+obh4SHEpGBefjYMGSgvmIF1FSq43K4HZoerwfuSekyyUXUy2HgwoB6U8uByqHZwPrxruwwfMWwcCxgAMrV8XQbhBn1TBpG7q9xOBDTIW++rp
 qfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 18:21, Pratik R. Sampat wrote:
> 
> 
> On 11/28/25 3:32 AM, David Hildenbrand (Red Hat) wrote:
>> On 11/25/25 18:57, Pratik R. Sampat wrote:
>>> The unaccepted memory structure currently only supports accepting memory
>>> present at boot time. The unaccepted table uses a fixed-size bitmap
>>> reserved in memblock based on the initial memory layout, preventing
>>> dynamic addition of memory ranges after boot. This causes guest
>>> termination when memory is hot-added in a secure virtual machine due to
>>> accessing pages that have not transitioned to private before use.
>>>
>>> Extend the unaccepted memory framework to handle hotplugged memory by
>>> dynamically managing the unaccepted bitmap. Allocate a new bitmap when
>>> hotplugged ranges exceed the reserved bitmap capacity and switch to
>>> kernel-managed allocation.
>>>
>>> Hotplugged memory also follows the same acceptance policy using the
>>> accept_memory=[eager|lazy] kernel parameter to accept memory either
>>> up-front when added or before first use.
>>>
>>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>>> ---
>>>    arch/x86/boot/compressed/efi.h                |  1 +
>>>    .../firmware/efi/libstub/unaccepted_memory.c  |  1 +
>>>    drivers/firmware/efi/unaccepted_memory.c      | 83 +++++++++++++++++++
>>>    include/linux/efi.h                           |  1 +
>>>    include/linux/mm.h                            | 11 +++
>>>    mm/memory_hotplug.c                           |  7 ++
>>>    mm/page_alloc.c                               |  2 +
>>>    7 files changed, 106 insertions(+)
>>>
>>> diff --git a/arch/x86/boot/compressed/efi.h b/arch/x86/boot/compressed/efi.h
>>> index 4f7027f33def..a220a1966cae 100644
>>> --- a/arch/x86/boot/compressed/efi.h
>>> +++ b/arch/x86/boot/compressed/efi.h
>>> @@ -102,6 +102,7 @@ struct efi_unaccepted_memory {
>>>        u32 unit_size;
>>>        u64 phys_base;
>>>        u64 size;
>>> +    bool mem_reserved;
>>>        unsigned long *bitmap;
>>>    };
>>>    diff --git a/drivers/firmware/efi/libstub/unaccepted_memory.c b/drivers/firmware/efi/libstub/unaccepted_memory.c
>>> index c1370fc14555..b16bd61c12bf 100644
>>> --- a/drivers/firmware/efi/libstub/unaccepted_memory.c
>>> +++ b/drivers/firmware/efi/libstub/unaccepted_memory.c
>>> @@ -83,6 +83,7 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
>>>        unaccepted_table->unit_size = EFI_UNACCEPTED_UNIT_SIZE;
>>>        unaccepted_table->phys_base = unaccepted_start;
>>>        unaccepted_table->size = bitmap_size;
>>> +    unaccepted_table->mem_reserved = true;
>>>        memset(unaccepted_table->bitmap, 0, bitmap_size);
>>>          status = efi_bs_call(install_configuration_table,
>>> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
>>> index 4479aad258f8..8537812346e2 100644
>>> --- a/drivers/firmware/efi/unaccepted_memory.c
>>> +++ b/drivers/firmware/efi/unaccepted_memory.c
>>> @@ -218,6 +218,89 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
>>>        return ret;
>>>    }
>>>    +static int extend_unaccepted_bitmap(phys_addr_t mem_range_start,
>>> +                    unsigned long mem_range_size)
>>> +{
>>> +    struct efi_unaccepted_memory *unacc_tbl;
>>> +    unsigned long *old_bitmap, *new_bitmap;
>>> +    phys_addr_t start, end, mem_range_end;
>>> +    u64 phys_base, size, unit_size;
>>> +    unsigned long flags;
>>> +
>>> +    unacc_tbl = efi_get_unaccepted_table();
>>> +    if (!unacc_tbl || !unacc_tbl->unit_size)
>>> +        return -EIO;
>>> +
>>> +    unit_size = unacc_tbl->unit_size;
>>> +    phys_base = unacc_tbl->phys_base;
>>> +
>>> +    mem_range_end = round_up(mem_range_start + mem_range_size, unit_size);
>>> +    size = DIV_ROUND_UP(mem_range_end - phys_base, unit_size * BITS_PER_BYTE);
>>> +
>>> +    /* Translate to offsets from the beginning of the bitmap */
>>> +    start = mem_range_start - phys_base;
>>> +    end = mem_range_end - phys_base;
>>> +
>>> +    old_bitmap = efi_get_unaccepted_bitmap();
>>> +    if (!old_bitmap)
>>> +        return -EIO;
>>> +
>>> +    /* If the bitmap is already large enough, just set the bits */
>>> +    if (unacc_tbl->size >= size) {
>>> +        spin_lock_irqsave(&unaccepted_memory_lock, flags);
>>> +        bitmap_set(old_bitmap, start / unit_size, (end - start) / unit_size);
>>> +        spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>>> +
>>> +        return 0;
>>> +    }
>>> +
>>> +    /* Reserved memblocks cannot be extended so allocate a new bitmap */
>>> +    if (unacc_tbl->mem_reserved) {
>>> +        new_bitmap = kzalloc(size, GFP_KERNEL);
>>> +        if (!new_bitmap)
>>> +            return -ENOMEM;
>>> +
>>> +        spin_lock_irqsave(&unaccepted_memory_lock, flags);
>>> +        memcpy(new_bitmap, old_bitmap, unacc_tbl->size);
>>> +        unacc_tbl->mem_reserved = false;
>>> +        free_reserved_area(old_bitmap, old_bitmap + unacc_tbl->size, -1, NULL);
>>> +        spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>>> +    } else {
>>> +        new_bitmap = krealloc(old_bitmap, size, GFP_KERNEL);
>>> +        if (!new_bitmap)
>>> +            return -ENOMEM;
>>> +
>>> +        /* Zero the bitmap from the range it was extended from */
>>> +        memset(new_bitmap + unacc_tbl->size, 0, size - unacc_tbl->size);
>>> +    }
>>> +
>>> +    bitmap_set(new_bitmap, start / unit_size, (end - start) / unit_size);
>>> +
>>> +    spin_lock_irqsave(&unaccepted_memory_lock, flags);
>>> +    unacc_tbl->size = size;
>>> +    unacc_tbl->bitmap = (unsigned long *)__pa(new_bitmap);
>>> +    spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +int accept_hotplug_memory(phys_addr_t mem_range_start, unsigned long mem_range_size)
>>> +{
>>> +    int ret;
>>> +
>>> +    if (!IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
>>> +        return 0;
>>> +
>>> +    ret = extend_unaccepted_bitmap(mem_range_start, mem_range_size);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    if (!mm_lazy_accept_enabled())
>>> +        accept_memory(mem_range_start, mem_range_size);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>    #ifdef CONFIG_PROC_VMCORE
>>>    static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
>>>                            unsigned long pfn)
>>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>>> index a74b393c54d8..1021eb78388f 100644
>>> --- a/include/linux/efi.h
>>> +++ b/include/linux/efi.h
>>> @@ -545,6 +545,7 @@ struct efi_unaccepted_memory {
>>>        u32 unit_size;
>>>        u64 phys_base;
>>>        u64 size;
>>> +    bool mem_reserved;
>>>        unsigned long *bitmap;
>>>    };
>>>    diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 1ae97a0b8ec7..bb43876e6c47 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -4077,6 +4077,9 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
>>>      bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
>>>    void accept_memory(phys_addr_t start, unsigned long size);
>>> +int accept_hotplug_memory(phys_addr_t mem_range_start,
>>> +              unsigned long mem_range_size);
>>> +bool mm_lazy_accept_enabled(void);
>>>      #else
>>>    @@ -4090,6 +4093,14 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
>>>    {
>>>    }
>>>    +static inline int accept_hotplug_memory(phys_addr_t mem_range_start,
>>> +                    unsigned long mem_range_size)
>>> +{
>>> +    return 0;
>>> +}
>>> +
>>> +static inline bool mm_lazy_accept_enabled(void) { return false; }
>>> +
>>>    #endif
>>>      static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 74318c787715..bf8086682b66 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -1581,6 +1581,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>>>        if (!strcmp(res->name, "System RAM"))
>>>            firmware_map_add_hotplug(start, start + size, "System RAM");
>>>    +    ret = accept_hotplug_memory(start, size);
>>
>> What makes this special that we have to have "hotplug_memory" as part of the name?
>>
>> Staring at the helper itself, there isn't anything really hotplug specific happening in there except extending the bitmap, maybe?
>>
> 
> Right, we are extending the original bitmap and initializing a structure
> to track state as well. I added the hotplug_memory keyword without
> much thought, since I didn't see anyone else attempting to extend these
> structures.
> 
> That said, I agree the name is awkward. I could either come up with
> something different, or we could eliminate the parent function
> entirely and call extend_unaccepted_bitmap() + accept_memory() directly
> from add_memory_resource(). Similarly, we could do the same to
> s/unaccept_hotplug_memory/unaccept_memory too.

BTW, can't we allocate the bitmap based on maximum memory in the system 
as indicated by e820 (which includes to-maybe-be-hotplugged-ranges) and 
not do this allocation during hotplug events?

If you search for max_possible_pfn / max_pfn I think you should find 
what I mean.

Then it would be a simple accept_memory().

-- 
Cheers

David

