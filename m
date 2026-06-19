Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE571CDB466
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8B766B0088; Fri, 19 Jun 2026 04:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3DAA6B008A; Fri, 19 Jun 2026 04:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9527D6B008C; Fri, 19 Jun 2026 04:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 716A76B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:33:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F4CD16601D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:33:29 +0000 (UTC)
X-FDA: 84895998138.26.E45765B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id D477520008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:33:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bsR/1HKu";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781858007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTLg7a9T7vLFjvhZRDB+o2OGAASgk5HvL1NzaM2+pbg=;
	b=B7fa5xicy9orMM8TvEEHEc2/qfR7e92ETuDFItnuqGBubQVw1zsjDODlvhZipvGuqg3HAn
	YL8F9kLGT5qZ5UfBeSA4UxiFVR+3CCErd2nOTmDHMETz0cGaTHsuG93O41RurCSEv7qWf3
	VeCWZDb6OsSLv+BKENNC/+36Eyf3QPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781858007;
	b=5TXdkmPtTUGu/C6f+yc6XliBGVlQcbd8vqojcdA5+S5lOpMshwcQGlR3QOBgLtlNdO6PtC
	nCC2I1+ncAMziZ9tJUq84SKvKaPCin5tZ201MApegTzo1DNPwvN4fTXqRA0vGK1Y7wqUNf
	Vhm/BHBnO+6+fbGzXu6m06BoWBCK4Lg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bsR/1HKu";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09A681477;
	Fri, 19 Jun 2026 01:33:21 -0700 (PDT)
Received: from [10.57.95.87] (unknown [10.57.95.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 340C43F62B;
	Fri, 19 Jun 2026 01:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781858005; bh=Hrk+6/DnZcxM+M2eVKSxAoK4z5tossxKNNplMOj8TrY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=bsR/1HKue3QS9KepixhOf1guhmeHbx+E9s0jSIC6kQsph2i85sH6W64YQfzhz/CX1
	 nEp7YOnbHoSIFGSbBJzx3oFwy/wCr587QVpEIQk+CuLdjsXenCOkF57Z5KqQZhXm0i
	 Bx1ARwx4TbgapomUOkIW88t/P4+ESPemsYr9dQTc=
Message-ID: <751c564b-d6c3-4bd5-a269-e3de89e8cf13@arm.com>
Date: Fri, 19 Jun 2026 09:33:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
To: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
 <402e247d-1eb9-4842-ba9a-712a3bb9b438@arm.com>
In-Reply-To: <402e247d-1eb9-4842-ba9a-712a3bb9b438@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D477520008
X-Stat-Signature: rbjhfojsx3fqsjfgsjry5dn3dq5cr8ru
X-HE-Tag: 1781858006-536280
X-HE-Meta: U2FsdGVkX1/+jJm7HsAEMrjKuNRaTy67cBYaNT5kuw0my1Ra53rDtTJ9K23RwdXE3LvvUOvvJHUmnNdhsFZRz/zAEaRi/huUnXFjtrTXht+Ukj2XQbMmUionwrO4yFycCIjpMFFEtPaL5oO7xBbF3FbADceTiCIolg9qIIo2OhkMHooUFrhT0l8ME/ehlrUfSl42amuCUJPif8cJbxmezE87wBR2P1zWyfUaehVF58gLuxyMQeHmnYPzDb5URLqt90r/4Ab3TIvqz5Sxwginssn2rF6Y9W+uWeQGCUqcjmfv/PdpqOYLDG/4iBoNBmts8WvONWmVFs2a0Cklus5ELqIZt80cYrwQOQDeArg3veR0dm7EJseqi9FRYIrpN4kbU5PSxny6eE/WCvFlKKfrnGPJ7BSjx/+WVAfpNaumb9Acv8Y7i60ic9u+uKjSC/+eB8y4cDnAy7BGRbE3BkHUTovu8nrk8xaqAGsrenTbhuPSQpliReHScR7lbe5h93A/Ys5RsmKTNWm43VyX4P+3lxp003P8hQLyLSqQtLJWu+f2/NFZehCBvc8K8jMd+CSvhwU934sIcQNIBgjr8XR0PYN3p0U7TiIRwKMA4DWTdDV9xX+3RgZM7NEkIsDZgOed4eeRFNk48UhlI/VynLL+ArbaGk7gUh/sVPUiFkdN/I2FmWle0ZxVmFyFfCyeOHojsm/DwmffBEVZ5+/f7Bqudia2qDxYuQCmTfA0LFcSPJkkNLbQAqjqjZ7qkyOB+Vwby7IKfV0PNeoanvByye6QyxTR9cKUxHEdV+J6mb8PsYQN/bzLmg/P0tsh5cZbmEVUgx6pKtSRlX5tIEOWn6AFOoCp6kuieruGlG+FJSJ2GtjaPbVgqrkq0o0DhRfa0HDacpSxwiDslEHnq8GrV8lcAA91zovm7hnLybEtubRD6wAqxqUL+20g9WrPAthg0q8/0UVIrfuELr0cVsSBYQC
 qxwFngvS
 Xb6s1TEVNaTaNXqkSVM/GXb4TjGQ01SbCHxDgbc+1Ci+kLIq8Ou1mVaTZb3FPHlnMhgWvZQnTmDyT8Gvp6onsTLJdEA05WGud9stHogddxLC9rMRgzmasJgcNc9wuWMfd3jZMbNqtlSoLQG6xKXFdpXV9MSk+RBKA82TS7RkeAsQ4WBVSaKi1cfx1H/GrMWbEmUPr3WwIxGvSZRsZgGaoKRALUHDIcn4jV4Hr6bppbNdcIGpcGBLrzZDOYm2mr+t+d0t9OITF2wN8XtsJpoE30CV/nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/06/2026 16:05, Ryan Roberts wrote:
> On 11/06/2026 14:01, Adrian Barnaś wrote:
>> Strip the read-only attribute from the selected memory range when
>> restoring the linear map after an execmem cache clean.
>>
>> An execmem cache clean is performed when a cache block becomes empty
>> after unloading a module. When making the memory valid again, the linear
>> memory alias must also have its read-only attribute cleared.
>>
>> Without this change, the linear memory alias remains read-only even
>> after the execmem cache block itself is freed, which prevents subsequent
>> allocations from writing to that memory.
>>
>> Signed-off-by: Adrian Barnaś <abarnas@google.com>
>> ---
>>  arch/arm64/mm/pageattr.c | 17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index 88720bbba892..eaefdf90b0d5 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -239,6 +239,13 @@ int set_memory_x(unsigned long addr, int numpages)
>>  					__pgprot(PTE_PXN));
>>  }
>>  
>> +static int set_memory_default(unsigned long addr, int numpages)
>> +{
>> +	return __change_memory_common(addr, PAGE_SIZE * numpages,
>> +				      __pgprot(PTE_VALID),
>> +				      __pgprot(PTE_RDONLY));
> 
> This is not sufficient to convert an invalid entry to valid. As well as setting
> the PTE_VALID bit, you would also need to clear the PTE_PRESENT_INVALID and set
> PTE_MAYBE_NG.
> 
> e.g:
> 
> int set_memory_valid(unsigned long addr, int numpages, int enable)
> {
> 	if (enable)
> 		return __change_memory_common(addr, PAGE_SIZE * numpages,
> 					__pgprot(PTE_PRESENT_VALID_KERNEL),
> 					__pgprot(PTE_PRESENT_INVALID));
> 
> 
>> +}
>> +
>>  int set_memory_valid(unsigned long addr, int numpages, int enable)
>>  {
>>  	if (enable)
>> @@ -362,7 +369,15 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>>  	if (!can_set_direct_map())
>>  		return 0;
>>  
>> -	return set_memory_valid(addr, nr, valid);
>> +	/*
>> +	 * Execmem cache uses this function to reset permissions on linear mapping
>> +	 * when freeing unused cache block. On x86 it makes memory RW which is
>> +	 * desirable. On ARM64 set_memory_valid() just change valid bit which
>> +	 * leave direct mapping read-only so use set_memory_default instead.
>> +	 */
>> +
>> +	return valid ? set_memory_default(addr, nr) :
>> +		       set_memory_valid(addr, nr, false);
> 
> Surely execmem should just be using set_direct_map_default_noflush() if that's
> the behaviour it wants?
> 
> I think that the current implementation of set_direct_map_default_noflush()
> doesn't undo the effects of set_memory_nx() / set_memory_x(). That might be
> worth checking?

It's also worth mentioning that set_direct_map_valid_noflush() has "noflush" in
the name, implies it doesn't expect/require any TLB flushing to occur. But the
implementation will perform tlb flushing for any case that is not just a
invalid->valid transition (which for the existing impl is the case when
valid=true and for your changes is never the case - see __change_memory_common).

But execmem doesn't do any tlb flushing so it looks to me like it actually
requires that set_direct_map_valid_noflush() handles the tlb flushing? All seems
a bit fishy and probably warrants a cleanup to make things clearer.

> 
> Thanks,
> Ryan
> 
> 
>>  }
>>  
>>  #ifdef CONFIG_DEBUG_PAGEALLOC
> 


