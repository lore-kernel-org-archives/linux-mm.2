Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F1BCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6163C8E000C; Thu,  6 Nov 2025 05:31:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE328E0002; Thu,  6 Nov 2025 05:31:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B888E000C; Thu,  6 Nov 2025 05:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43DA58E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:31:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E30B7C066C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:31:57 +0000 (UTC)
X-FDA: 84079816674.12.6478CEE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 326C214000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:31:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762425116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lxG5Nj7vA2GY+pfuaL7Y4EXztLcXNaDp/nJB+qgTjiw=;
	b=SfhyRhOoVw/IoDf+K1GRNo8wJToXQGx64NInsdttuuwgWyTT6lbDVpFjqyPZ30Adm0kYpz
	ywho1hGmumpyImsBeZY5dKezKB1XLvr2Y5iCujpn/PVN7RkiK3vg8CIwZtsQAIYo5ge40J
	PGSUFzbuZf11HdIwZAccNEDoUvUq+7g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762425116; a=rsa-sha256;
	cv=none;
	b=rTFjZtjGdPFRpi+Zb+kTL/wm+2Rg/8V4GXZQvr6Y3ujfJYzKuHdXh1rD51uvybphIJHA/N
	uSxvPjRBkP8GAFPYSqeZrlrAp+/zOKXZaQqruSDhdX4Hs3GoYvs0Ug7IpXSPH0ufWDYNbp
	N5zrK46DWek8US7rwkDPCGHZVdJlTBA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87B131596;
	Thu,  6 Nov 2025 02:31:47 -0800 (PST)
Received: from [10.1.34.75] (unknown [10.1.34.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32C3E3F66E;
	Thu,  6 Nov 2025 02:31:49 -0800 (PST)
Message-ID: <0276c749-9418-47ea-85f1-0b0ab93b0225@arm.com>
Date: Thu, 6 Nov 2025 10:31:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/12] powerpc/mm: implement arch_flush_lazy_mmu_mode()
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-4-kevin.brodsky@arm.com>
 <87pl9x41c5.ritesh.list@gmail.com> <87jz044xn4.ritesh.list@gmail.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <87jz044xn4.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gnphxscuqw1mr6hxgoft3owjzo49yxyf
X-Rspam-User: 
X-Rspamd-Queue-Id: 326C214000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762425116-587608
X-HE-Meta: U2FsdGVkX1+F/dVJu5qXwEACOVjX7W/Gxab+BKCXudK1NUNG1lw5XzNJJJ51QN9tuTZSVeQD/703npTRj9uII3hichGMtOlGB3o0pewgZjrcWd1BOtHUChVYx2159lKdVrk1NDwYXe7eC5IM21H0oHqvFGnJmW3MexHGOdCnUVAuoR4z/5a0TDyWHu1SjAwVCqOqechGgDl7Brpo6J5w+VG+MSRFgSkaZIobOw5pvBC5obrTTG0W0UrP46WeAhY7RFkfIp49Fx+wbojjqBV3dn80Luhs2d+VpZnzwHf9feP6hGN33eonrcqnRGYG1W9jHyyqc1vCHMp9bY3J6VqNJfAJ7ND+3TeULOOxeGkpweeB0ziJBr0stM9VI0+eq1CkoOklWEpXJx8V9vNY/ln8oTtYHsYsKCjdgzH16xkRARglG64EsW1XofbXjdRf9ngysZqMahWA5ARxFobgmSB32KAUE2UHau+jeExa6GKNOJFf9ud2cYdqV1MqAhYgZhgvkZMw5r7KR4F7vnm/JnsoQqXCOti/NMycU8Qh+3MCNEp1ttppBYiHHTor7u6nZSx95eHuggEYv3+bBOD7D9GgTzTLbi2vJdOP5ltLgglO3J7vZyTiEbirBDGKQ7If8OdQfVee/VCLl8hMaWcSB0CGB6LNw1bd2xUciv8q9Zbmqv1+74OalYDENDxHiEykCMWVgsx6OTgIqHCVJBRMhNDdzI/f7bRdkSM+WRpQRV6/nt8NntO7e1g8bGLFkEK4ya3EMxsrCuBboYggteLP9zu8bh3Xnw2hzSQdoX1O87d96zqtI0OyeZ8cJBgYNIrRYzAShOXzyzj43TWgD2fOjfnjt9qznCStElf5XBLnQZ7jfVUnj+ldrx9lTtnog+aiLrWVZlPOlGCcF/ejMANu+eLhYAOTRyMTnFNy3iOTO2KHKz3rxQbUtqByHElP13jIAE/3p1koBfwpHE+CZI/1Opr
 s9DruSWX
 cHQyDXKfNof0MZdzDG9YK8MXhNVpq5md6MPdQ5QRFQcI1CcAtlN6goC90WLb779hNYB/kAztXbcrADyP6cyMaiUmSXCcBQ7NvkApGzAHGniQwF7UMpJ5Tdd1qINXMgLRXotmt1Mp0eI6qqfkWjeNZUZpIIDIY2wlrttE8pR7mOI/9IVbG/ncl9dMOfU320HiBbHvko9/wESLCWDkFh7aacBCZXupKVG1tjRbwuY4AE83y9N6S33vRoUvifi3EqdmjIjDOfmQ0J+u0XS8N/PboaWuRBABA9/B1x6mbAeYkTuUkLu3B3VOk3Kruzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/11/2025 09:49, Ritesh Harjani (IBM) wrote:
> Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:
>
>> Kevin Brodsky <kevin.brodsky@arm.com> writes:
>>
>>> Upcoming changes to the lazy_mmu API will cause
>>> arch_flush_lazy_mmu_mode() to be called when leaving a nested
>>> lazy_mmu section.
>>>
>>> Move the relevant logic from arch_leave_lazy_mmu_mode() to
>>> arch_flush_lazy_mmu_mode() and have the former call the latter.
>>>
>>> Note: the additional this_cpu_ptr() on the
>>> arch_leave_lazy_mmu_mode() path will be removed in a subsequent
>>> patch.
>>>
>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> ---
>>>  .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 +++++++++++----
>>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>> index 146287d9580f..7704dbe8e88d 100644
>>> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>> @@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
>>>  	batch->active = 1;
>>>  }
>>>  
>>> +static inline void arch_flush_lazy_mmu_mode(void)
>>> +{
>>> +	struct ppc64_tlb_batch *batch;
>>> +
>>> +	batch = this_cpu_ptr(&ppc64_tlb_batch);
>>> +
>>> +	if (batch->index)
>>> +		__flush_tlb_pending(batch);
>>> +}
>>> +
>> This looks a bit scary since arch_flush_lazy_mmu_mode() is getting
>> called from several of the places in later patches(). 
>>
>> Although I think arch_flush_lazy_mmu_mode() will only always be called
>> in nested lazy mmu case right?
>>
>> Do you think we can add a VM_BUG_ON(radix_enabled()); in above to make
>> sure the above never gets called in radix_enabled() case. 
>>
>> I am still going over the patch series, but while reviewing this I
>> wanted to take your opinion.
>>
>> Ohh wait.. There is no way of knowing the return value from
>> arch_enter_lazy_mmu_mode().. I think you might need a similar check to
>> return from arch_flush_lazy_mmu_mode() too, if radix_enabled() is true.
>>
> Now that I have gone through this series, it seems plaussible that since
> lazy mmu mode supports nesting, arch_flush_lazy_mmu_mode() can get
> called while the lazy mmu is active due to nesting.. 
>
> That means we should add the radix_enabled() check as I was talking in
> above i.e. 
>
> @@ -38,6 +38,9 @@ static inline void arch_flush_lazy_mmu_mode(void)
>  {
>         struct ppc64_tlb_batch *batch;
>
> +       if (radix_enabled())
> +               return;
> +
>         batch = this_cpu_ptr(&ppc64_tlb_batch);
>
>         if (batch->index)
>
> Correct? Although otherwise also I don't think it should be a problem
> because batch->index is only valid during hash, but I still think we can
> add above check so that we don't have to call this_cpu_ptr() to check
> for batch->index whenever flush is being called.

You're right! I missed this because v3 had an extra patch (13) that
turned all the lazy_mmu_mode_* into no-ops if radix_enabled(). The
optimisation didn't seem to be worth the noise so I dropped it, but it
does mean that arch_flush() will now be called in the nested case
regardless of radix_enabled().

Will fix in v5, thanks!

- Kevin

