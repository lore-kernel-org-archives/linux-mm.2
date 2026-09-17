Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B6B9C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3796B008A; Thu, 17 Sep 2026 14:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054C46B008C; Thu, 17 Sep 2026 14:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85D76B0092; Thu, 17 Sep 2026 14:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD6DB6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:11:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56E521C271B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:11:39 +0000 (UTC)
X-FDA: 85224047118.30.4B3D66E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 33C1A40007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:11:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oz67M4YS;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789668697;
	b=C4rcxhqvkXFIKpTK9S5qRyLE1Cpv9W0AHWtQtlToIXSOGR56YCZLki78PrD+jSz0hTKY1R
	LxIjjOZZ1uoBo1LHnPsHAM0lWESF+7g1B5bSHLEC/yi3dU8QoIP+cn6E/NZ+6Y8b9UB/vt
	hYDgz+HpuntCR0O6UV8Z+WkIBVGKjzY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oz67M4YS;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789668697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIr22LU1BYbVNjY9Dz7AcISZr0rlTdwozp3Q/IVZlMY=;
	b=jQz9ABJEZr9Ri0f2/2gSMxzIC5dGU+AWTarMla6K9DI/aR47t1Xry5SKc3YmnA+hA/ipO3
	jFofXBCneUX0W+j2/POV9/nYTfiKJIzSYRW+b2lpsNu7drdPI/sbr6URAFSJwvfqbvCoCD
	AuapiTVIsZZaLPYUwUDkU5biVhxeJqo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D27B1476;
	Thu, 17 Sep 2026 11:11:32 -0700 (PDT)
Received: from [10.57.7.135] (unknown [10.57.7.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07D443F86F;
	Thu, 17 Sep 2026 11:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789668695; bh=TMD2k65kuIFXRf0q/E0tlyDyciozaJKv/LfOROsWlhU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oz67M4YS9vKX95bPOvJjG/6IahhL31r2yGk7O81dt+sjjN414ZuuZ1xCMa2au/gHH
	 rXUcqtwGrQvFQ85FYRDPTsgIv5sPS9YSZzFPZz/TWW1k7YQuQdJ0UPTrn4SrhDiV3s
	 CGukra9E2ILOT0R0PDF2smG+O2IyEGDjkvUSbT20=
Message-ID: <d299f7c5-6c71-499a-b8cd-aa69c4c81dd1@arm.com>
Date: Thu, 17 Sep 2026 20:11:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33C1A40007
X-Stat-Signature: 6ak66krdor39is467wrwfajuhmtna7es
X-HE-Tag: 1789668697-324079
X-HE-Meta: U2FsdGVkX19seY3co75Nqzokjdcs+9kGb9/7k45GDNoAkDLlWUeH1JAVlEE/SsEPOUHiP8nZvvLqnpSM7wLlYB0XYc+acVfgZWqPDVNSrpakZanrYWqAMGwsFxeAf16PkRjPliZxOWCDronWEjiWCV5vV8L8qS970DIrJ42TPL5F91OFTVNsylRt3wMKSz+C6S25+ZRguMTkC4am6dwPNOmpv/v6tdo32ygo0Mdj5LQAcZsEM0oedr7aiVoBclhQQ/vK+y+zF2CGgtpsQbVf9Bd4r+VcUaQ3ePcyYySsrpmv8nWXTTMPaI33t4VKe1RAUscfuAss7zplSMhi3jAkbT2YGI9PziCx1j9XC7d7OcAoEhqxBpuQMvb6bZ+Wkk9LqJibp5eal0KxanftuEaBixSA0oe/IkbUmAjXvR6PvEzGx5SHzmptiZ6SEFDyqB8WOUHH8w/qdfu8h1Cy5wh18dsLZvyfEhCXa+kLtVQwiVzxleYHeHfYAdsnIG/OjaDUvYOYxXF0kUAyPw6b5ojTbyvcCMtzerXjMA8D588/s6ZPBlAo1psMR5GpNzN9b/JFJjgAAR1shJydHcY/DBX9NfdkSDXlV0DRQy+VtZCoRAkI3QdJ4Hi50lhOT8xdraxb5l6DH4vMTQ7ZaxyFzeWt1GSO35ziZEz1BWJnafaWMFgL9B2NfhJDKvBVCCAr//Bwe3t2mVafQKoau12fWEcGk+ZvgWTExZM2zCcoD0pMxyMP58GXJ6UF1XtDb4j9bOGgydROuxogjUL3ZNmSRrHnZD6VdjJaFCE4iEAvL2qK2HPsAFCArw2LpiN07VMsEigPmezAkiNCaQpw03IHbFynjXWLOKSzXbfmpVs1CET8wQrhxZ+794rWBdWdzETAev8V7dBexl7F5uFs0ZHkC3p9jzuKzk86HuSpXJIPEO2KwUf3nLbRtk3RXTpR4r+HM9l4PhTRJSUSrFEzmb9tH25
 I4lWyz/L
 Zy7rI6EMXK+m8q91VbdPkJKaDHwiLsA0maTIEW+u6fuLFFEKYl/bjg/Vpq4VStHVsSYkbra/rc692bzS/6CAVps7tK0xHw2rsX/lpDMhBUkMRPBIXGcnR/jjrNYqFJIVvpfzv1sNlWci58r30A51FAaNzJiLc6T52sBSeX3UBPDsN8qtYT9TlTTnMtVxWPCnXGhXqj/3mErgnpHueFbuzkgAW61MKrTqW54a2GA4frz59SRcuHZMu4vTaDjWCweyCI27w4D4oAhXzy0OQD+Xdwe+k/bNr59Zs433S//QDonGtz6eBagaMhAb6n3WLwHwJGJG+211UOOfLvw1pyv8Na0HCnxbNOnI8bFZ/a6VKrHIbSzzWG5bYv+FMsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 11:28, Mike Rapoport (Microsoft) wrote:
> When set_direct_map APIs were introduced by the commit d253ca0c3865
> ("x86/mm/cpa: Add set_direct_map_*() functions") the single page
> parameter made sense because the initial callers (vmalloc and
> hibernation) had sets of unsorted struct pages that required changes of
> their mappings in the direct map.
>
> Since there is an increasing demand for direct map manipulation and it
> is also desirable to be able to update larger physically contiguous
> mappings, for example an entire large folio, extend set_direct_map APIs
> to receive number of pages parameter.
>
> As there is still only a handful of callers, change the existing
> functions directly and update all the call sites rather than adding
> wrappers for single page case.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/arm64/include/asm/set_memory.h     | 4 ++--
>  arch/arm64/mm/pageattr.c                | 8 ++++----
>  arch/loongarch/include/asm/set_memory.h | 4 ++--
>  arch/loongarch/mm/pageattr.c            | 8 ++++----
>  arch/riscv/include/asm/set_memory.h     | 4 ++--
>  arch/riscv/mm/pageattr.c                | 8 ++++----
>  arch/s390/include/asm/set_memory.h      | 4 ++--
>  arch/s390/mm/pageattr.c                 | 8 ++++----
>  arch/x86/include/asm/set_memory.h       | 4 ++--
>  arch/x86/mm/pat/set_memory.c            | 8 ++++----
>  include/linux/set_memory.h              | 6 ++++--
>  kernel/power/snapshot.c                 | 4 ++--
>  mm/secretmem.c                          | 6 +++---
>  mm/vmalloc.c                            | 5 +++--
>  14 files changed, 42 insertions(+), 39 deletions(-)
>
> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
> index 90f61b17275e1..b07fd4e026eac 100644
> --- a/arch/arm64/include/asm/set_memory.h
> +++ b/arch/arm64/include/asm/set_memory.h
> @@ -11,8 +11,8 @@ bool can_set_direct_map(void);
>  
>  int set_memory_valid(unsigned long addr, int numpages, int enable);
>  
> -int set_direct_map_invalid_noflush(struct page *page);
> -int set_direct_map_default_noflush(struct page *page);
> +int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
> +int set_direct_map_default_noflush(struct page *page, unsigned int numpages);

I don't have a strong opinion on whether to call the argument nr or
numpages, but we might as well be consistent across archs :)

Aside from that:

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

