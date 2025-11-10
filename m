Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80054CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60A48E000E; Mon, 10 Nov 2025 05:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11908E0002; Mon, 10 Nov 2025 05:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00CC8E000E; Mon, 10 Nov 2025 05:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA7F88E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:48:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E5E589DD8
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:48:38 +0000 (UTC)
X-FDA: 84094373916.09.445AFCF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6F2E3180017
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:48:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762771716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xJe9RrZUlICJVKVCCId7WIyPyCMLhCd5HXbbl2Kr8tY=;
	b=NXKYM+sz+fBS4ALAtzFl2xASMZFBWH53IUy8ETqhR4WEkF6UPpj7svZI+dAqXnQdEryzl+
	zGw01tFNagnSsjOOtKZ/jBWE/ghsnIVGRwtQKU6MOCQFPckTjCuoCRHSu1y/oNt5gU/GCR
	geAOS8SvekrgtOjUSvRV1YsEQnE/aCo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762771716; a=rsa-sha256;
	cv=none;
	b=crbgOZBH9kNm4G/NvLDA9N+4LTy3uBxiGUWxbLlMnE3+UocKWsFu4Sb1gLq5hxHGJGDq4D
	w0lrLf4ZTYTrAMNgW2kz4RwbKA+TWH+ez+CTnSd8i5ZOflfl2Vz3XrSTimbrJ93L6LwlS3
	qqsFnfkcSqXiYMgkRNPeiYFDinVBHIY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BB20497;
	Mon, 10 Nov 2025 02:48:27 -0800 (PST)
Received: from [10.57.39.147] (unknown [10.57.39.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A51E03F66E;
	Mon, 10 Nov 2025 02:48:27 -0800 (PST)
Message-ID: <f7ed51e6-c3f6-402c-b328-8af5f970006d@arm.com>
Date: Mon, 10 Nov 2025 11:48:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/12] mm: bail out of lazy_mmu_mode_* in interrupt
 context
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org
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
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-13-kevin.brodsky@arm.com>
 <8a38db66-4d1a-4296-a2dc-e0276c6cdde8@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <8a38db66-4d1a-4296-a2dc-e0276c6cdde8@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6F2E3180017
X-Stat-Signature: mj1itfhtetr89djdkgkahywyjxdp4jpk
X-Rspam-User: 
X-HE-Tag: 1762771716-146835
X-HE-Meta: U2FsdGVkX198A6QYnWGuaDT1MRJSV2SBncrj527m8UB2u1nQ/XEs10SvhSMytlvYg1W709IAaIjBb1nHgEBcxTBPUBEUt89iZSIUB2r3I4FcUlcXLpJ8zBuqYRas9NMsrTs3lEIXqx2wtcsePTn1Iken1i+hsF68UcC4eMSAD0YvCQdycC3IRs6aEmB5EXvFjFimVAYa9L6Zp977iaHAxK+XejGHfZUiX2Pp427BmRFNMBhm6NK8caCLKbuDqU+2yw195jqPlu8WlowHPZ+o5x3bD+F29jFmBOWwRiWT+uITa694RGho94dj5ZV63UUy8aMu6lb7eur4vKlEmm/wt80VK3SDHDPwciwuyf9lvHRyaaWfv+r9yMY5zfYLUcUevE96nGFJUWcVvxYGYh1yWtwDuC1CltqLH2JyUfsmFaEG+AMQsgDkY1pPD3WyRWa/HeMoWjS+ftG7TOUGrR64w0fUFhGFyIXddf8WZrabpx/H6WO9s1g/NkhPA2aI63SuUwqLiA7A/+kfHLysapaJd7UxEq0A5VYhe/CqXBgd/1099CI6SWUuucK5daiHWOLMqbo2cfc+BO79EmDQLCAwPuc53KwXKMeNOT13F1Vzr8ek/bJ/zNsSRG+WxbORoRvG+Wws6QxZox0CQNMeUbDXH45XvNBpUdB+pOZsQrng/UK9+NYPdOjZ9a2HZkfw8hpFckyDe3UXuVPbFHsUzYK9rKM7la+STfaMaZmWr6K0o8ZPDetDSRfvUSy/ZcMFslh5Zm++Am4LWl/w3IZwmjXWemsXmWEZVbe57oibVGr+bDQXYxxQgc4O80EAHBjiJN89mQSeyx8naESF7s9gNfFtB+QYouRHFs8SAZIfa7OihW+ZCrs35/WDfZsbsjkEGgmS8I8HkPeSZs4SOHiiT6nOXWdKaOjgwhu0oA9Bo7jxpCap24Zif/GD8+ybYIZZwdXPBO3BB13e2wWyGALgNtc
 EgeWFhze
 wGLtqgafDTpjc2Zkgy6//ErfOw0NPpFhLsA2nmHJubX9usTFoEQRnxYVdVAFN8DNRxoBLYt2HsAlieImEEduIfoASOgalMCgW60w4Bthr93vbyc9J/rwvAcQyEQF61eeKaGwKTfNhPfE/NaCPCX2XgBuvQCuMsvr2a9x0Lejv6aFTzHn04mSN2falKJn+PnIlDXhIxoUeBkF4U4oPlOiKzMRowEfFQG+ckWQ9SmjODXEqFt11kvomODTe28V4bRCNfhSVsZC0XwaiLynIB9K7hS3Tx6zVnRUUP3W8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/11/2025 15:42, Ryan Roberts wrote:
> On 29/10/2025 10:09, Kevin Brodsky wrote:
>> The lazy MMU mode cannot be used in interrupt context. This is
>> documented in <linux/pgtable.h>, but isn't consistently handled
>> across architectures.
>>
>> arm64 ensures that calls to lazy_mmu_mode_* have no effect in
>> interrupt context, because such calls do occur in certain
>> configurations - see commit b81c688426a9 ("arm64/mm: Disable barrier
>> batching in interrupt contexts"). Other architectures do not check
>> this situation, most likely because it hasn't occurred so far.
>>
>> Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
>> disabled while in interrupt mode (see queue_pte_barriers() and
>> xen_get_lazy_mode() respectively).
>>
>> Let's handle this in the new generic lazy_mmu layer, in the same
>> fashion as arm64: bail out of lazy_mmu_mode_* if in_interrupt(), and
>> have in_lazy_mmu_mode() return false to disable any optimisation.
>> Also remove the arm64 handling that is now redundant; x86/Xen has
>> its own internal tracking so it is left unchanged.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 17 +----------------
>>  include/linux/pgtable.h          | 16 ++++++++++++++--
>>  include/linux/sched.h            |  3 +++
>>  3 files changed, 18 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 61ca88f94551..96987a49e83b 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -62,37 +62,22 @@ static inline void emit_pte_barriers(void)
>>  
>>  static inline void queue_pte_barriers(void)
>>  {
>> -	if (in_interrupt()) {
>> -		emit_pte_barriers();
>> -		return;
>> -	}
>> -
>>  	if (in_lazy_mmu_mode())
>>  		test_and_set_thread_flag(TIF_LAZY_MMU_PENDING);
>>  	else
>>  		emit_pte_barriers();
>>  }
>>  
>> -static inline void arch_enter_lazy_mmu_mode(void)
>> -{
>> -	if (in_interrupt())
>> -		return;
>> -}
>> +static inline void arch_enter_lazy_mmu_mode(void) {}
>>  
>>  static inline void arch_flush_lazy_mmu_mode(void)
>>  {
>> -	if (in_interrupt())
>> -		return;
>> -
>>  	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
>>  		emit_pte_barriers();
>>  }
>>  
>>  static inline void arch_leave_lazy_mmu_mode(void)
>>  {
>> -	if (in_interrupt())
>> -		return;
>> -
>>  	arch_flush_lazy_mmu_mode();
>>  }
> Ahh ok, by the time you get to the final state, I think a most of my
> comments/concerns are solved. Certainly this now looks safe for the interrupt
> case, whereas I think the intermediate state when you initially introduce
> nesting is broken. So perhaps you want to look at how to rework it to prevent that.


Agreed, as discussed on patch 7. I might split this patch - first add
the in_interrupt() checks before patch 7, and then remove the
now-redundant checks on arm64.

- Kevin

