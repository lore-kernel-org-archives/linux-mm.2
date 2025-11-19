Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4BB6CF2566
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4A06B0023; Tue, 18 Nov 2025 20:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACE56B009E; Tue, 18 Nov 2025 20:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B526B00A0; Tue, 18 Nov 2025 20:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0B536B0023
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:18:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E619F1291C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:18:44 +0000 (UTC)
X-FDA: 84125596968.07.2A1C1F0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1611A40005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:18:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QC1tunr6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763515123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEWakcvW1TnAMoV+h8ZFjseo1NzKkn1k3ld14oxm230=;
	b=vyw4hQD6++21cBDzbk1wsoFXSzqO3tWzhsk8zKBnn1jp/XW8Gt9/vHP2vQWtWTvZSWsK6r
	IQDI6el7LoVNLInlkOtaAxAspBMuIXVEH66WudJ/Vval3yNktrkrkKJG7fHYn7sPya9Uid
	oluc72pYpDWgZDpLY7r6KW4QIgMTtGo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763515123; a=rsa-sha256;
	cv=none;
	b=ikSP8n/n2/K5+ZmcsANeaBEshC38h13G/d3Our4M5TXYnFT6uNxVhve7/9+HVwXWP9HQh4
	35vnoEDv2jfrQMx68s6As1qkEtRu43FprgPfZLWvCYHsRf/jw1Oy5QdJ3e1gXDWYGilVqH
	2UmPWjqmYX4hxmVee3IjGCK++o3MsMM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QC1tunr6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=jEWakcvW1TnAMoV+h8ZFjseo1NzKkn1k3ld14oxm230=; b=QC1tunr6eaQovDaqvqIBwr3X+/
	C3C5mLb7Pa22aUwA2v5Fa6Ah0VeP6F5VFmTRWqBPTqD0qJqZ0fFlPrCq6bhhkG1jA0YTxGkJaUBwi
	GQkwuUOualXgI8nvNDfrZZEwbffMu/1H2i/6cwuef4EsvzFYIzGipzrky8OkwVCzRZOpxybG/1TzI
	NhRJtkYVP1+gbltlQKPs1SuTkbYcWXrjwLS1XcMN8Cvaxk5vtIdYcqZZ4YH+fjMgc+o50wNVoyCp+
	l8heA9Yu81ccf5Z2bwICTGnz4TXBZCY9VEDbV5p6HemHQ4kcT9TxY/pIPsmLWD7eBJBUuYTcpZU1W
	5typ2JHQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLWq8-00000001L1B-2Eo5;
	Wed, 19 Nov 2025 01:18:32 +0000
Message-ID: <2241d985-0e35-41e5-93b1-1e8d4e7a84bf@infradead.org>
Date: Tue, 18 Nov 2025 17:18:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/7] lib: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
To: Jonathan Cameron <jonathan.cameron@huawei.com>,
 Conor Dooley <conor@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-cxl@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 Drew Fustini <fustini@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, james.morse@arm.com,
 Will Deacon <will@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 linuxarm@huawei.com, Yushan Wang <wangyushan12@huawei.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
 <20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
 <3bf1793a-2ffd-4017-b4bf-dc63f3a2a7c8@infradead.org>
 <20251117-definite-uncounted-7cc07a377a71@spud>
 <20251118093041.00000c9e@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251118093041.00000c9e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8jkakfj7ttaaa78jgy3f1u5d1coext5j
X-Rspam-User: 
X-Rspamd-Queue-Id: 1611A40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763515121-695768
X-HE-Meta: U2FsdGVkX18F+oSzAikJc9Go0oiNRufhXNTmc44vG9yYLZETYUcNwt59NBQxGaThTyZBFXCuElIROCtc6ZaB+nU07uIgIkxEqEMkX5E/prQw7n0BMJD6PsHWS2rTPVBIFwnSgr8W+qCXnFh/mC7eNkYaVNYqG/EffyCYibWlbUndsrgkdhdbGTp92zAC75bNZOr6WSR7AC8SWu6kXakeflvRz2l6HGo8a0fkV6LNb+AUmK7EUrvXQosXZqFZ45Y8bNfKQgNfpuqsFuhi7yHnTyecRKuskuElj/H6vWRnKZeci3H1tlioRv6kz4Elj+zBnZ8tTAHCWMqetb1+TrOvHMb6ZiJ+XWdnb5+/Xb9yW95QBVKIEN9J2v7GkdyIIaFocwqcmIxCqlNAFPZVxEwRH+KVbigYrX1Iqm5hBtTGUZeWBcjSJAZdX1qhRAI1lHJh7TIs36VVE03LUx4AuBjwd+So7gceo1DZdXbzDru7lecEeqi/02M7MnHo7Jvyi3hNXZuuNBRqPYi2jF+TkJd7Fqji/LznVtbPmlNF+nK7biLPV0iM0TezUxaa9gLoAEsYHkU+FwD7JQwhCVnJS2mlD+33k2JweHhecUBuSIjMsE3dBimOzpODNQdtgEPFKrMNZiQOJcOtZ6Q88/ud6db3j2Q0lpbdmHE1g37/Y8rId38KhFdqj2o51zF5p2FrC7Yugsw6Rj0emOGTnuQxH/q23cyjelWy/wzGPbiESQ9j9qGxkrE0S2YF0cOI1hxzsXZyfCUANAvzhMVJ+vNzaZ0IoUDqtGxUiRPR3KkyaoPLoE/41vxiq2/v5mdJgzY0+1Zzc5M7dTTj6wX9IHIATdp0ToCX6sl5ccD0H5yCayPPlVTNXoOArsVdJ+ZjrKUZ0WbrZ/hXNuYK9KN8U7+5ry9LF9E5sB3rfRvAYPJHv/JuuZgs7DsIqM8BFt21rRogLEM79a3V+pTcF0wREq1jxUw
 dF0Kqh61
 w3y45oiiodBphDHckn8SIcoVMKdm0F4gHeN8DXxFo092t37YcotwYSy/zyvH1vAtfqRgPACocle/bOAhyioqwiJnTFXKWlMM/NCXxc2EB3xQF/9IkAb19kMqOTJKPw359dY7ysYcSz1zsa0xwPszhSu9veS/OIHJ+KabjfI+vjRfqJq8EfUU3kR0Tuwc9l8DSPaQrxv/HgotzcGPOcy0TWb3LlXljNE10oHMrKE/iqtFaneovO/gWK2B0WVg0XZYWmHpnBv9+1ssfmwh6JdNouHvsSMzXmrSWQnlnUFXS1Fu8F1oIkhW9xEBrkaGYMO3C7YsV0ssvTrK07Qe4SyaW6haXXNj2pNr4h9/3EAG4HKBWpvo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/18/25 1:30 AM, Jonathan Cameron wrote:
> On Tue, 18 Nov 2025 00:13:07 +0000
> Conor Dooley <conor@kernel.org> wrote:
> 
>> On Mon, Nov 17, 2025 at 10:51:11AM -0800, Randy Dunlap wrote:
>>> Hi,
>>>
>>> On 11/17/25 2:47 AM, Jonathan Cameron wrote:  
>>>> diff --git a/lib/Kconfig b/lib/Kconfig
>>>> index e629449dd2a3..e11136d188ae 100644
>>>> --- a/lib/Kconfig
>>>> +++ b/lib/Kconfig
>>>> @@ -542,6 +542,10 @@ config MEMREGION
>>>>  config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>>>>  	bool
>>>>  
>>>> +config GENERIC_CPU_CACHE_MAINTENANCE
>>>> +	bool
>>>> +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>>>> +
>>>>  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
>>>>  	bool  
>>>
>>> Architectures and/or platforms select ARCH_HAS_*.
>>>
>>> With this change above, it becomes the only entry in
>>> lib/Kconfig that does "select ARCH_HAS_anytning".
>>>
>>> so I think this is wrong, back*wards.  
>>
>> Maybe it is backwards, but I feel like this way is more logical. ARM64
>> has memregion invalidation only because this generic approach is
>> enabled, so the arch selects what it needs to get the support.
> 
> Exactly this. Catalin requested this form in response to an earlier
> version where arm64 Kconfig just had both selects for pretty much that
> reason. This is expected to be used on a subset of architectures.
> It is similar to things like GENERIC_ARCH_NUMA in this respect (though the
> arch_numa_init() etc in there are called only from other arch code
> so no ARCH_HAS_ symbols are associated with them).
> 
>> Alternatively, something like
> 
> I'm fine with this solution if Randy prefers it.

I do much prefer this alternative.

> Thanks for your help with this.

Thanks for listening.


>> | diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> | index 5f7f63d24931..75b2507f7eb2 100644
>> | --- a/arch/arm64/Kconfig
>> | +++ b/arch/arm64/Kconfig
>> | @@ -21,6 +21,7 @@ config ARM64
>> |  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>> |  	select ARCH_HAS_CACHE_LINE_SIZE
>> |  	select ARCH_HAS_CC_PLATFORM
>> | +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>> |  	select ARCH_HAS_CURRENT_STACK_POINTER
>> |  	select ARCH_HAS_DEBUG_VIRTUAL
>> |  	select ARCH_HAS_DEBUG_VM_PGTABLE
>> | @@ -146,7 +147,6 @@ config ARM64
>> |  	select GENERIC_ARCH_TOPOLOGY
>> |  	select GENERIC_CLOCKEVENTS_BROADCAST
>> |  	select GENERIC_CPU_AUTOPROBE
>> | -	select GENERIC_CPU_CACHE_MAINTENANCE
>> |  	select GENERIC_CPU_DEVICES
>> |  	select GENERIC_CPU_VULNERABILITIES
>> |  	select GENERIC_EARLY_IOREMAP
>> | diff --git a/lib/Kconfig b/lib/Kconfig
>> | index 09aec4a1e13f..ac223e627bc5 100644
>> | --- a/lib/Kconfig
>> | +++ b/lib/Kconfig
>> | @@ -544,8 +544,9 @@ config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>> |  	bool
>> |  
>> |  config GENERIC_CPU_CACHE_MAINTENANCE
>> | -	bool
>> | -	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>> | +	def_bool y
>> | +	depends on ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>> | +	depends on ARM64
>> |  
>> |  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
>> |  	bool
>> implies (to me at least) that arm64 has memregion invalidation as an
>> architectural feature and that the GENERIC_CPU_CACHE_MAINTENANCE option
>> is a just common cross-arch code, like generic entry etc, rather than
>> being the option gating the drivers that provide the feature in the
>> first place.
>>
>> I didn't really care which way it went, and was gonna post something to
>> squash and avoid another revision, but I found the resultant Kconfig
>> setup to be make less sense to me than what came before. If the switched
>> around version is less likely to be problematic etc, then sure, but I
>> amn't convinced by switching it at a first glance.


-- 
~Randy


