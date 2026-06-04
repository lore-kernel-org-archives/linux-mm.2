Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C4CCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57326B0005; Thu,  4 Jun 2026 03:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08046B0088; Thu,  4 Jun 2026 03:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E396B008A; Thu,  4 Jun 2026 03:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C07ED6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:43:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D72390461
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:43:29 +0000 (UTC)
X-FDA: 84841440138.10.1F637D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B27EE1C0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:43:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FP8b2xGD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780559007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcphQ0Rw2o1L4ixWXv1z/UyHZdPxmHTlt/k525r269U=;
	b=ipnQv8fCB3iANau/+mGKkK0aTwjYxEyxGqZs6xmeqAc+/JLVTynKKMEhlIh1m+vvEtZ/ac
	Lrkaymezw03Ff0LF0f5rjEukpuFDczw3Y3q/1AsRGqEUK2FdJiqS9xt0wZxHVrO3HxuwzE
	MSFKQpQMC3ayPEQn+R+gKrREfJtUfEM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FP8b2xGD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780559007;
	b=1nRRb8iSy5KLFPY/lwOHP1GgxsDE42bAt2N6rJp8Gqx2PvRHMOQ/Sbx5xnmvzo4CeLajP1
	gWzstd6hr3e1egUTOp9OzGm4dSgKkd4WdywjUyJ4XIV3pVHD69EgHWLG23O7r9WYPYtWpy
	d2zqdApvA9kwmYtxiCSV4MIJCOpEH+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E62760126;
	Thu,  4 Jun 2026 07:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BE01F00893;
	Thu,  4 Jun 2026 07:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780559006;
	bh=FcphQ0Rw2o1L4ixWXv1z/UyHZdPxmHTlt/k525r269U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FP8b2xGDkzxHJ7n2qYYxpH1CybRl8kL3CD+0OVxwkPI/nHpC05YEnca4gvdN7gNb/
	 lNynqq4CtTAoVYy5gcVYxgxcyR+ySL7wGXlUJl7SXYUt+iBE7iVmXvpBBM+2ZqjF6g
	 S6HCf1RdhXjHRVgAnWsNT2IkrrMof03Tzon8NrSOG7oG6Q7iIrM9GW/GzpfWV+Z0QD
	 x0c9tYofo+wlJFnOT8RyGrdU6BkUBheELnytF2mQlTwMYTlA7KUDyyB2PVRQFlSBgg
	 rBdpIxXTBVVqbhtHf77+iowcjPoA1Dv5MyERvxzSPC/DKi6Z0ThqJoDesIlgePnZYK
	 2LCn5WB81zLvw==
Message-ID: <11d2f0bd-baca-42aa-89ce-328a9d555f7e@kernel.org>
Date: Thu, 4 Jun 2026 09:43:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/15] powerpc/code-patching: Avoid r/w mapping of the
 zero page
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Liz Prucka <lizprucka@google.com>,
 Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-28-ardb+git@google.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260529150150.1670604-28-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B27EE1C0006
X-Stat-Signature: ee4sbxs3g4z6ysm8f6hjd35dionkn5tb
X-HE-Tag: 1780559007-30296
X-HE-Meta: U2FsdGVkX1/AjwlpHTptDHmTRLAYPBxdWGxmepnOJ0uh/eCf65Eap99czm08wiZHllI4toWov0tHidkWnT/xaM6B87zxMO5tBYk/87EsROw1Y4ZJw+krk6JgeV/vFOaBVEaQkrOLnWyssGznr8iAQcfI0/Wyel/Ufo82V5zJoMefzFjsb85ogsAfADmegVZg+6OWKg1c7AklDfFaqn4OJl5x9kSVsAEUFwsWV6CDrMjfrPFoaQrDGSF3e5nDn2TNfKqu9KG6xCKEsEZg+uIP/pE8wkqomyQ5ReWqlNdbFCdEbJgBg7o7oBjGVF9JDYO3q7NwSe8JyAPCM/RteAsk9LTyzeDe5sfmUyPq6Cq0sZICLpRCM2cZs5/aFVPsNQrSL9FW6arwQ8MOXNf6pp0/+401o8haUU+Bv5NpjZlJrX4pvXMFWt30j2kN7O2b4hji0kDu+RIIx+Gtk0q1a2sT5FErMhQX6mO5dk39arusr5MLSBlKoZOMGWL+hSHJ6RfjtcPUDbk47fOAFFpppT7nc3WaB8SbrQcPcqAmVBSWTPM35ZetCTzQct8KARbbpfxc4zhNrIz5mtLV0jZfno+8tYITw9f7Yfdkd2KtnDI8sLXsjiJJPSTVGmd7vjISrl51iqwQfdEHTx7iu9q0jq9tNa+K7brMzVjqMsVII1kGWyiXTacjkJRkFF0yMCj6+BNopzLw332otBXKvT7Umu+0n1E77PBZwgO71UXLmtQP0hhp2tbf6UhYSQvbpnqV3DyFtUnvoNp6I3xc6B3OHwC4um49JgAErxvGAtf0XKFz423FPKq3Mnw2+Yh30JOJhAb+Pwrm66CLQJU3zB2+goxf85BjLVMGjeVjTf+lZ+RN1vJ0E81JLmymaiPr0d2r8k2vuAr6xl52BHZS7/aNCiO1aDGtlKRMHyHfQoEK82bjAHytk7N/G2W7j3wiE194aYajmTln8t1EAAUKptCXjPa
 2L/0vaz5
 6tWojJI8GLwezUaaCuWNMOY1F2i8SD4oFEoRWh1ueOQKSJI2F31xDv1YdbtWAX3XF5X5eBm65nJr/ewMo/JOjhO+B+JrG98iYdkrWDX9ki+ksI3u5J347BYS/2CCr7u4mgs9LJX6Sbh9SB3NKQ34qoQHr9c/mfloUbasK8ff80xxsZbABgriIpXHXuYq896onXjMOVfxiy0hUFzgJZl/LZ4Pk1knK7/GwZTJ17LFfeFY5nFGW/E8gKdjixQkUZHSqoMrJcuaLxOd5Ohqy6OV74TJV+zfKonAoJxmWnul4pLOuN1D9zlht1ItsVj1tYihAdQ2DmNi8gkaNWYzRSFKc+LNOCHfmqxFlAssiL2/A9SEe1CW2SBAcbjoAjmC3ml/mviu9W3pCSq8AnF2ud4hL6IZZ0rEnvxBHj2vzu/jgx6OovhSf0dljATF7TYhForEvrzx4aWEaGjBPrPyYter6jPveSMvibfAr0XgPvJpu6KWNy0jFHvD5FYO9yQQ79h/aTx1JbNoE+gjnah/neHacDQlBLt4pIiSuU30awdDVgeZ6SMAYYEUBy+EY6WbXKn+8070o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 29/05/2026 à 17:02, Ard Biesheuvel a écrit :
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The only remaining use of map_patch_area() is mapping the zero page, and
> immediately unmapping it again so that the intermediate page table
> levels are all guaranteed to be populated.
> 
> The use of the zero page here is completely arbitrary, and not harmful
> per se, but currently, it creates a writable mapping, and does so in a
> manner that requires that the empty_zero_page[] symbol is not
> const-qualified.
> 
> Given that this is about to change, and that map_patch_area() now never
> maps anything other than the zero page, let's simplify the code and
> - remove the helpers and call [un]map_kernel_page() directly
> - take the PA of empty_zero_page directly
> - create a read-only temporary mapping.
> 
> This allows empty_zero_page[] to be repainted as const u8[] in a
> subsequent patch, without making substantial changes to this code
> patching logic.
> 
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Link: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20260520085423.485402-1-ardb%40kernel.org%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7Ca75a9b5e25f14d0d9b2208debd935266%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639156637598013085%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=Q82ykchJOsuWlbmq%2BKFb2cTWIU4wGXbR53VQjNvgOCk%3D&reserved=0
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>

> ---
>   arch/powerpc/lib/code-patching.c | 52 +-------------------
>   1 file changed, 2 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
> index f84e0337cc02..44ff9f684bef 100644
> --- a/arch/powerpc/lib/code-patching.c
> +++ b/arch/powerpc/lib/code-patching.c
> @@ -60,9 +60,6 @@ struct patch_context {
>   
>   static DEFINE_PER_CPU(struct patch_context, cpu_patching_context);
>   
> -static int map_patch_area(void *addr, unsigned long text_poke_addr);
> -static void unmap_patch_area(unsigned long addr);
> -
>   static bool mm_patch_enabled(void)
>   {
>   	return IS_ENABLED(CONFIG_SMP) && radix_enabled();
> @@ -117,11 +114,11 @@ static int text_area_cpu_up(unsigned int cpu)
>   
>   	// Map/unmap the area to ensure all page tables are pre-allocated
>   	addr = (unsigned long)area->addr;
> -	err = map_patch_area(empty_zero_page, addr);
> +	err = map_kernel_page(addr, __pa_symbol(empty_zero_page), PAGE_KERNEL_RO);
>   	if (err)
>   		return err;
>   
> -	unmap_patch_area(addr);
> +	unmap_kernel_page(addr);
>   
>   	this_cpu_write(cpu_patching_context.area, area);
>   	this_cpu_write(cpu_patching_context.addr, addr);
> @@ -233,51 +230,6 @@ static unsigned long get_patch_pfn(void *addr)
>   		return __pa_symbol(addr) >> PAGE_SHIFT;
>   }
>   
> -/*
> - * This can be called for kernel text or a module.
> - */
> -static int map_patch_area(void *addr, unsigned long text_poke_addr)
> -{
> -	unsigned long pfn = get_patch_pfn(addr);
> -
> -	return map_kernel_page(text_poke_addr, (pfn << PAGE_SHIFT), PAGE_KERNEL);
> -}
> -
> -static void unmap_patch_area(unsigned long addr)
> -{
> -	pte_t *ptep;
> -	pmd_t *pmdp;
> -	pud_t *pudp;
> -	p4d_t *p4dp;
> -	pgd_t *pgdp;
> -
> -	pgdp = pgd_offset_k(addr);
> -	if (WARN_ON(pgd_none(*pgdp)))
> -		return;
> -
> -	p4dp = p4d_offset(pgdp, addr);
> -	if (WARN_ON(p4d_none(*p4dp)))
> -		return;
> -
> -	pudp = pud_offset(p4dp, addr);
> -	if (WARN_ON(pud_none(*pudp)))
> -		return;
> -
> -	pmdp = pmd_offset(pudp, addr);
> -	if (WARN_ON(pmd_none(*pmdp)))
> -		return;
> -
> -	ptep = pte_offset_kernel(pmdp, addr);
> -	if (WARN_ON(pte_none(*ptep)))
> -		return;
> -
> -	/*
> -	 * In hash, pte_clear flushes the tlb, in radix, we have to
> -	 */
> -	pte_clear(&init_mm, addr, ptep);
> -	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> -}
> -
>   static int __do_patch_mem_mm(void *addr, unsigned long val, bool is_dword)
>   {
>   	int err;


