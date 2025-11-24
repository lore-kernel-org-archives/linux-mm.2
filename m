Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99B7CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E90D6B000A; Mon, 24 Nov 2025 09:03:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299C06B000C; Mon, 24 Nov 2025 09:03:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFAF6B0010; Mon, 24 Nov 2025 09:03:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 071E26B000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:03:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C7EDB84E5
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:03:00 +0000 (UTC)
X-FDA: 84145666920.18.EDEDD63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E75040002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:02:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tk0B7VIl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763992978; a=rsa-sha256;
	cv=none;
	b=dCXyErLjqbO6XcnIyRfppSPeRACaKTQNICKQKe4rFt4D2V8+KNLNJH+FAuCYprLjFZHtp/
	2XT2bAY5XRc8f91fohPH/mEEi9ZLA0HYlYeK7H9hE6QPDsc7/MNUNIlTAG/WZ+tC8vTctw
	G9enyX+O1NRiDReoMs+fm4Hm+J1xBoU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tk0B7VIl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763992978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrrhBEvBnsSAF7PLd01zY2WLon58h0T57emDhSOGsp0=;
	b=p4BReORdsXgatkFFk8ajzFrMzZNji+iU5UXubjEJ/zc/bPgt3Z8wfGUZcX2aS3MV6qjw5D
	ph158yjnmDyixV88UAPL18ARfI016PTUiVSrCss+qSE1r5XR55dsfGoDm1UsDUgOuFMJdC
	RN/Nzhm5RivDl2m02Pq1wPGDLFATfMA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69425441F0;
	Mon, 24 Nov 2025 14:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255FBC4CEF1;
	Mon, 24 Nov 2025 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763992977;
	bh=YqylCEeliEvlrC1kKw4Lw3JI+SCsfpARExAMAiItCrQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Tk0B7VIlEUDDN2U3FV4pUKTeQsuTqvT4R/mnOJ2XNo00BuWSlKlsxf1vc63Mbl1j+
	 tl9lO2sIHAiPxITXujuPruVokMbX+TW8F1K2MLEETyo1PQomIyCT71jNp43MdSr7ii
	 DsiY2IoMnfhvQ8qs4u6S88ewRv60/rfWkl+zMX7tz7jYsAdnAf4hqRF1RoGrHSIIv4
	 LFBqPbdfWO9gRktjIkr+weNioG4P7IXJO8N6A/L+VWxZUJBMtcVI6L2dQf0Fqdg9a3
	 bEeI8vd8tI36SgIpIWy3UdqbRkYks3Vng4EsuztKrjfNmZCm13/fJr7/JSnwFNXvyp
	 wPtrQFAItlUrA==
Message-ID: <ff7b2ca9-d4d7-41b3-acd8-2d90294e59cd@kernel.org>
Date: Mon, 24 Nov 2025 15:02:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/7] treewide: provide a generic clear_user_page()
 variant
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-2-ankur.a.arora@oracle.com>
 <189bc218-8f19-4686-b2ee-5ddc6a0b4684@kernel.org>
 <d3d68f78-bd76-4cf2-b20f-a0f7c838124a@kernel.org>
Content-Language: en-US
In-Reply-To: <d3d68f78-bd76-4cf2-b20f-a0f7c838124a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7E75040002
X-Stat-Signature: 7hap7orzgsrcd6jjbaftjsfqtmwxjfsh
X-Rspam-User: 
X-HE-Tag: 1763992978-66647
X-HE-Meta: U2FsdGVkX1/XpOxSqJuOIGrBcFnOCxar3SpsQBOKQm54oFZrw9upQBGKWrBTpRaLHO3gVy2YckyKswn+X2orjt59too2pD66HRRtsVkEAl1nPiWqxhv41s0BQFAn8axZ13Ayw4pk555bxWoEouYCJ2RrKxlWJqs4tjJ49c37f3xnsiFmsBcZRRzmk9o9wKS5Z6/ochNpOuEloIFYOVFoTeavM4GNyyj2U7JN5j4NHsVBV1aWeIAG0PqpSTlvZAk7z0Ecy3O0A9K3PgpXRRI6BVgy/vnYk/6bmS2r6s+QnQpH/pZjYjc5qf+HUAuxQ45LxpdRtbYu8GLAEQvYRhiAwH/4KUqO1QAkookTorTD7Yia8TujXpvFyOlEU2VKFxQqWES+l1bdyz01SEV3IhyExqGfs4Jzoe9cZ0/r0XyOxAJ2fj38U/zSGQ218S9cNY6eQtDy3KJDILWmYLl7WJ9hagN1Lthxu9Ay8xce1HvmL5jp1BXcBFd3z8NIX7qKUU/Ah4Q/cJR31vneRZtBP5Urs4qGw2Nn7dpfMLphVdJyGBrw4UYrpy73ixGqOLG7fswdK2SoqH2xSGA2E+SwdWoeeMQj5cDYp/fYPwL/9lFZmArJHXRQ0/JHc1fasxoz+yNpUXosl0k3Q0bFeldwwRr2hiAJAIiFYefYeRHHTxO10O7I2NbQ16fuSXfbXGRccgisJAUNa2NruWyGU/hHnd1YcpR9p8hjeYTqSo/AxjdLrzMtnCseLNLDciEQ81wLl8MkBaLLLtOc1CpUoq+z6osIACxbWZBsPyZ3oLNEA9Ol+JjdXzK9LggaFft0ZovmEUG05bJXZzT0W85P32FoKZZHg80OzhXFV2lkl36IFFyjwWaHoh8WHAOloTAu7XPTCcF3PrlUt/KHWHXGVD/ehRQFGYV+KbERvxMx8epq6CI/NyaPKo1xLh4vWfBTUQLFcVG6tyfz3hNn0FJSP/HPjbv
 drf03eDZ
 wyG6pNKi53Jx/k9Mg7ueXmp4VzDC4Zb5vgZiqiS43y0KPSD1vy1AkkHthrVlM4lmmui/ZXSbS6QhidqfNAl2yvn2YWefIwsKg8E/tq0hBLH3BTavPAgTaB4ERYZagu6yI7Wnj/rJ7Af+3p6/XZSpoRw061VmO3G1MS+KOwv5N6d9K7gQ1Gs9eLxKFToMn4Lg4bHpaDhhBNdk67ZFMLU9lGUzMudK0z0RpvJ9IG/aWgyVuRMKcr6y239Q7zxzCzrle+XFKtffaTmoYzQVrPq4R6neWjnJ7gS0FhRsug+QS0WXMaopuO8aOvMLyVUOni5fgOf/2yxgJamtGHIEL3QPZy2PXa6mV+A7wXyLyeyar1MNddHQrPuYmmq09vJKTyq0GMrC+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 11:17, David Hildenbrand (Red Hat) wrote:
> On 11/23/25 12:53, Christophe Leroy (CS GROUP) wrote:
>>
>>
>> Le 21/11/2025 à 21:23, Ankur Arora a écrit :
>>> From: David Hildenbrand <david@redhat.com>
>>>
>>> Let's drop all variants that effectively map to clear_page() and
>>> provide it in a generic variant instead.
>>>
>>> We'll use the macro clear_user_page to indicate whether an architecture
>>> provides it's own variant.
>>>
>>> We have to be a bit careful if an architecture provides a custom
>>> clear_user_highpage(), because then it's very likely that some special
>>> flushing magic is happening behind the scenes.
>>>
>>> Maybe at some point these should be CONFIG_ options.
>>>
>>> Note that for parisc, clear_page() and clear_user_page() map to
>>> clear_page_asm(), so we can just get rid of the custom clear_user_page()
>>> implementation. There is a clear_user_page_asm() function on parisc,
>>> that seems to be unused. Not sure what's up with that.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>
>> ...
>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 7c79b3369b82..6fa6c188f99a 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -3879,6 +3879,28 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>>     				unsigned int order) {}
>>>     #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>     
>>> +#ifndef clear_user_page
>>> +/**
>>> + * clear_user_page() - clear a page to be mapped to user space
>>> + * @addr: the address of the page
>>> + * @vaddr: the address of the user mapping
>>> + * @page: the page
>>> + */
>>> +static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
>>> +{
>>> +#ifdef clear_user_highpage
>>> +	/*
>>> +	 * If an architecture defines its own clear_user_highpage() variant,
>>> +	 * then we have to be a bit more careful here and cannot simply
>>> +	 * rely on clear_page().
>>> +	 */
>>> +	clear_user_highpage(page, vaddr);
>>> +#else
>>> +	clear_page(addr);
>>> +#endif
>>> +}
>>> +#endif
>>> +
>>>     #ifdef __HAVE_ARCH_GATE_AREA
>>>     extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>>>     extern int in_gate_area_no_mm(unsigned long addr);
>>
>>
>> Isn't it chicken and egg with clear_user_highpage() in linux/highmem.h ? :
> 
> No really, because we make use of clear_user_highpage() only when the
> arch defines it, so the highmem.h variant is ignored?
> 
> Not that I particularly enjoy this way of handling it, so something
> cleaner would be nice :)
> 
> (in particular, relying on highmem.h defines in mm.h is a bit suboptimal)

Correction: there is no highmem.h dependency, as clear_user_highpage() 
comes directly from the architecture helpers in page.h

-- 
Cheers

David

