Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB605CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750A26B009B; Thu, 18 Jun 2026 11:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF1A6B00A0; Thu, 18 Jun 2026 11:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE966B00A3; Thu, 18 Jun 2026 11:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCA06B009B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:05:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B44601C0046
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:05:36 +0000 (UTC)
X-FDA: 84893357472.27.30A9F2C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79EE72000E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:05:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="W/898hXf";
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twN8ACZ9Aa/wKni6yp7we6+vMuHS1QTrgX8POUv0AIQ=;
	b=BE+LmbwX59YGyNAa1DXIm7xeLvYne1lYOgieLEqDATx1XZZZ+tLjl4/0xvBesIaEu5k/jm
	YVRru9FlgNHkVMICx4IbvEPAQEUCgv3ZjYDAVa+NlYNjROkpaL06ZnI6Dhl9v60EE9wY3N
	ogBRnXCOpKCHBCPfERJTegq1hksETg8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="W/898hXf";
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795135;
	b=1/G+lQZg/rskfIL0E3NzSL93KPKPK72gS7s26I/NG9XSlICgk/hPB1zx4xvgfwl34rt4X0
	EelDlLVBNVB4ezwumJBizdDXWJV87d/Z4ViPYa1/p/Znh2kzO5Y33185Pbg+RI3DV+eYhn
	S5WJwsd7YeVrJsdZTsxHfeAoSUs0vh4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A90CB2BF2;
	Thu, 18 Jun 2026 08:05:28 -0700 (PDT)
Received: from [10.1.25.219] (XHFQ2J9959-3.cambridge.arm.com [10.1.25.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFE293F62B;
	Thu, 18 Jun 2026 08:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781795133; bh=zSiCWB4wVmuwYgvliAtv1Bxz/LsfufvrGhKFPRWgIkM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W/898hXfxrGKOb0NnixwXdgQOv9P/CxQKTFjW3YCgEetxpYkeY1TFUYkdSTjAWq0u
	 qVVsA4mSccbwF41YvGrgM31uJD11z1aWRp7UwLyTIQeqNTAkUnuVcGZY1fX/JuhTBc
	 647RbOuA5w6kTr7rdg0h1CSQLGlfBTrmof3aS4hQ=
Message-ID: <402e247d-1eb9-4842-ba9a-712a3bb9b438@arm.com>
Date: Thu, 18 Jun 2026 16:05:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Content-Language: en-GB
To: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260611130144.1385343-4-abarnas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79EE72000E
X-Stat-Signature: bf7n5wc54kej5wwyzyfarfffxb35gj35
X-Rspam-User: 
X-HE-Tag: 1781795134-126046
X-HE-Meta: U2FsdGVkX1/iFAD0MkKX6TKCrqAHoXxU0bxuziAsEiyZWffA4wcgqeNlO0S7VuaeMZ8WNDRvB9ibg5CrxHv7XDlvA14nLntxTKrPM59YEVpg9VqnHgsNHmWhzLeVBJDaaYHvEH/GO72q7FW+jy3NtIY3NKhMEtq/A5UqzEY2gieV/WDK60nN7E+wDmI7Acz21rZqAL2n9o/jBhba6Fwnw9nNCezMPrFuy1H0KiqY80qrtTXZOvm6bS71ekUH6bSXW7SBKWRK6DjKsLlZ1W1SnkTpJszHFEgndq4jKBqvD66711ED7kH1DC0AvM8C98sjzvMo3E7a1TJBsV7zOmC0SJI5gTfZTX5+fdeCTU8VeElGBC3xf4qzS/PDsk4N65zGfpb5IlfFbgCYb3MkTXDao0rvCtgVhuT1T+2MT5pF0o88UTEF1GD8PIRogyxpcYbKhy3L7WuYl1DYGau/tpZIlNPEFU09tkyG1wfJpkhu37Nb8fP5lpJn1AXd6zBwOkARqsvmZ7GNEv9M+FQRydXeXS+IO3UidzwxPBab82SUsxECr9U25rEZksdz8z+FW9hsXMawGwxFOmiM4LB1KYvOEX8Y7vuMgikBNsAPWTk8eKEnsQSySmRkngvSmgVs0G17fv/GEAi2ZsK57T2zq9u8MGUMEG4ORParrruM6vnutPi+6snXGcRg3Z7HbAH0gPdGXHF1l/BUUl5G/mkY+UqPMF7Vv81NGIb19gAgl/2zwYFpGxJc9ErD1N8+XpY9Efis3A50G6eN/Rd2nG1iOX/5O9dmPFuanlRlWW7v783J027Mk5PcDbdNxKIEG/YEKYkWYHy6yQ3TC9ctGSa17DvGlrycvk5hDYB0qujclI5V6Q33fMIdLvf5DQYgi5F9Fio1W+185uCpkKFoIFthuPr4/i/i039HGfmvvG+DCs4OeQJKP320UaW+oJa2jO+XsS5HpsfZHgr4wjFEkCPiZC+
 /JO92P2x
 rh1e5KKshGXIRrijEwtLNUxAZsLLr51lfD8J/Fmmn6l90eoAHKclW6EaCqy/cjEUXUSxJv7zWJ4pNtuK/1VnfBv+ZUN0stN6sMYe6SN40dRE02o4XK0nJtjHTPaXXvGw2QGIVBABlzQ3zT3naeeDsdro3KKjiSE23nGHQKE2yYbQuhQukPIcXm1u3g6VHRU4KHR01y/r8lj4a4Im6UwFm3ZNqkG+AiCbh72CW/Eb9L07aiwN8gQfsGuO3VFE90JMJze/GnHBSuD0uut0eze9F2IiilQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/06/2026 14:01, Adrian Barnaś wrote:
> Strip the read-only attribute from the selected memory range when
> restoring the linear map after an execmem cache clean.
> 
> An execmem cache clean is performed when a cache block becomes empty
> after unloading a module. When making the memory valid again, the linear
> memory alias must also have its read-only attribute cleared.
> 
> Without this change, the linear memory alias remains read-only even
> after the execmem cache block itself is freed, which prevents subsequent
> allocations from writing to that memory.
> 
> Signed-off-by: Adrian Barnaś <abarnas@google.com>
> ---
>  arch/arm64/mm/pageattr.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 88720bbba892..eaefdf90b0d5 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -239,6 +239,13 @@ int set_memory_x(unsigned long addr, int numpages)
>  					__pgprot(PTE_PXN));
>  }
>  
> +static int set_memory_default(unsigned long addr, int numpages)
> +{
> +	return __change_memory_common(addr, PAGE_SIZE * numpages,
> +				      __pgprot(PTE_VALID),
> +				      __pgprot(PTE_RDONLY));

This is not sufficient to convert an invalid entry to valid. As well as setting
the PTE_VALID bit, you would also need to clear the PTE_PRESENT_INVALID and set
PTE_MAYBE_NG.

e.g:

int set_memory_valid(unsigned long addr, int numpages, int enable)
{
	if (enable)
		return __change_memory_common(addr, PAGE_SIZE * numpages,
					__pgprot(PTE_PRESENT_VALID_KERNEL),
					__pgprot(PTE_PRESENT_INVALID));


> +}
> +
>  int set_memory_valid(unsigned long addr, int numpages, int enable)
>  {
>  	if (enable)
> @@ -362,7 +369,15 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  	if (!can_set_direct_map())
>  		return 0;
>  
> -	return set_memory_valid(addr, nr, valid);
> +	/*
> +	 * Execmem cache uses this function to reset permissions on linear mapping
> +	 * when freeing unused cache block. On x86 it makes memory RW which is
> +	 * desirable. On ARM64 set_memory_valid() just change valid bit which
> +	 * leave direct mapping read-only so use set_memory_default instead.
> +	 */
> +
> +	return valid ? set_memory_default(addr, nr) :
> +		       set_memory_valid(addr, nr, false);

Surely execmem should just be using set_direct_map_default_noflush() if that's
the behaviour it wants?

I think that the current implementation of set_direct_map_default_noflush()
doesn't undo the effects of set_memory_nx() / set_memory_x(). That might be
worth checking?

Thanks,
Ryan


>  }
>  
>  #ifdef CONFIG_DEBUG_PAGEALLOC


