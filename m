Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1D2FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE7E6B008A; Tue, 28 Apr 2026 10:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895726B008C; Tue, 28 Apr 2026 10:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1FE6B0092; Tue, 28 Apr 2026 10:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8876B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:16:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5B4E1B720B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:16:31 +0000 (UTC)
X-FDA: 84708164982.07.C7FAD3F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8268B4000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:16:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KZBlPQ1s;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777385790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZEU/07GfSdYREJIL2rDIO5TdGrwyJUemGVRj3FT+T0=;
	b=8RmVGWqFIlFyJEnpCuLkSEsXklSnhvtnqsJPaDEAzllrEFuwERArParvCDiO9+0vM7Lsiu
	2ad8Blc19DE6EHQ4Fy30bL7ZZMrRGvVnnAhSWQAgG0wfnpaSC2dKGQY/jm/sfB4DioFG4g
	TItcQl0CMOI2LE7mtrSJ6hRNUz3nLdY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KZBlPQ1s;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777385790; a=rsa-sha256;
	cv=none;
	b=z7twxRnzkHRVDcv5cBzNroq6AmU09w0hb/44exUcDaFjS517d1lXMVZ3MFeB/JYEpFLW2/
	ldWZSG6Xcu70Urn/0xj6jn8xIKTC2QNA8wY/JstZvau6xYZusosR40AhkfyqKiEkogOtTb
	+WEKLZPqE+yKyUmPnhagk9ItMCoL7pk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD7841C2B;
	Tue, 28 Apr 2026 07:16:22 -0700 (PDT)
Received: from [10.57.63.26] (unknown [10.57.63.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48BFF3F763;
	Tue, 28 Apr 2026 07:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777385788; bh=btCZZuKZwDHwegac4lZwAmmkykNullD5FLtTtCs4fM0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KZBlPQ1sPDbrJhxD9GJVH5ERW4UKB3ReLaGE3w6Rs7y5sqoZtBJxYyDPoySmzUimS
	 O2W2ca7Bx0rNnlTgvtXYIkX9i8isJ3q6U5bEoSdMuy+joC8i+kcUX/Pz9lnXt+pwSX
	 DREPzwlNeterBeiJ8pRPWspZwsPTrQUst6s1cJdo=
Message-ID: <82091dd4-9d11-4054-89ec-99aadaeec7b2@arm.com>
Date: Tue, 28 Apr 2026 16:16:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/15] arm64: mm: Map the linear alias of text/rodata
 as tagged
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-18-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-18-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xoyau4kkgfydzqsirf95txg1bwkpwd4t
X-Rspamd-Queue-Id: 8268B4000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777385789-274322
X-HE-Meta: U2FsdGVkX1/Wt/UYYFB4YdXs6Ez2eLVcyhRqBtXd4ih6TRKLKMnNvexImrjmceaXOoRquVB68qxz5LiHlb4LYtFbRjCtYWQeuSjlRVSYDhQN2+BOzIG6tj1H3TKwljYfkehcK5esEbKyKzVyFu7R7565qBq3tQfC0fo4ZlledJvLAgL8asDYcf+xRLGwNGDndRCuD7DCSMUAJa7D8KC22wRBJkjfo5FGd2jz29+YzQv6/GN3YAEVV358Cz7rZyz/BUKb+nM4Z2oMNFdi+ZnnuNE+Pv+u7LbEkhNnukVOeWlLyj1syLQC6ffz/u/fUOXF1ANaU/dmEY2coFpOCdbAXxJDFcPATO9MrOnhUrlkCBIq9wdoSO8u3yy6R2yqI9XKHqzql1/us3w5yC4hl8ATikelydstIeez599q4SGQPXYRm4MlOo008XIQmb2bd6/OhMpzRYRHO1MWOgJC1v6ySZPWn9OyPHWr1C4MZOUG/AT8lGCAYCw9Iod22/siB8bTX66iYaan6CEnh9eS2ZDdbQ5nqSZiq9v3YVn5TM4w0sZay4sgPYfdcQXbqVpLpwqkeFyLFmWw/kMcuqms9mdKC2BMD1AFUlNJ3agsuurL+Nb2swiULjnObtVRErErYbrGdnREUpQRi4hCFVT0YrS8mDppkR/6l8BiyuhHaIdFIBkv8l2c2D3CfmIoWC9HGSsE+qzyFavyHkiEep3862/Ghlz7y/B0dxdIm8RyMjSryhPoF3/teDvXfM8Glu2JkTUvlzokgRbk2a8JxDQkxn2jBlxMkKvNHv9ejOzpnrBKVPVlTlGv6khLOD2tT9ojtneb8FewStKudcgUondVSahtGf+k+/Z1chE5KxqZQVkcrtL4Sm2awGTS4GeclKnxpt5yTnoABNrc2GWkrg4A3xmvO2L+Z4E4bokAcrfet6+0y80TcvNXx2ePMMK+U/98BJCidmxx7312GDiKkgH2LcE
 SYkTgnsv
 jzYGnsQt132RmEObpi3oDSPdiGiBkel3qsJ6T86sXCjn9JH8POmhnL35B1wuXjoXThnzHanWwkcdb2Lhhj7WjUG29CdnentEQoQPmXKeN+pSVmHIWC5ze8Y7dwPxnw0VZ4FV0iSvwsdHyE4WhtbGnXhl6qAicQvfnmyYxfabHKd7OnPFzjmDA8bspM0DAT5F7i1RhAQbwldmYgEQhR2zvXAqOuhQ8lbrUVr8pjYyeEp57mnGEKSWBMEIboyI2DSmmWzSaN5Df7rWUOENEenC+bBB1WxWMKQfTy7ULoO7BgwhMtUVtKeG376mE7pxi3r3TkaQuuAebNVxQWUPXpvJbjT+SkLkAzLifucyF29H6t3MyssI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Before moving the empty_zero_page into the __ro_after_init section, make
> sure it has the memory-tagged type. This is needed to ensure that
> cpu_enable_mte() will be able to initialize the tags correctly.

mark_linear_text_alias_ro() is called after all features have been
detected and enabled, so do we actually need this?

AFAICT the lines that matter for cpu_enable_mte() are those, in map_mem():

    __map_memblock(pgdp, kernel_start, kernel_end,
               PAGE_KERNEL, NO_CONT_MAPPINGS);

It is probably this call that needs to be changed to use
pgprot_tagged(PAGE_KERNEL).

- Kevin

> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/mm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index dd85e093ffdb..f084993024ab 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1049,7 +1049,7 @@ void __init mark_linear_text_alias_ro(void)
>  	 */
>  	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
>  			    (unsigned long)__init_begin - (unsigned long)_text,
> -			    PAGE_KERNEL_RO);
> +			    pgprot_tagged(PAGE_KERNEL_RO));
>  }
>  
>  #ifdef CONFIG_KFENCE

