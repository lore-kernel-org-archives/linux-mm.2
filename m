Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 583F0D10F51
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 13:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185EB6B000C; Wed, 26 Nov 2025 08:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D3F6B000D; Wed, 26 Nov 2025 08:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0732D6B000E; Wed, 26 Nov 2025 08:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED4AD6B000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:47:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47B33BA376
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:47:31 +0000 (UTC)
X-FDA: 84152885502.30.3A13AF2
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3A9C8A0017
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:47:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aLGsm8w0;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764164849;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOcN8utXBvCmBV1D6iZJFhosr0VxKSdczfYTYogMAeI=;
	b=J9614fjr4BbpBzfCzPDjhBhu62eUbEB17qIAJV0lY+xuNrLWSyjVLK52MN52VpZZ+deER5
	Teic3wcxy0QwDkT3+K+h2inUgyHS6vdKBtf82hhyNDjyE6aIIR52P+nSO0ltPo+K/MLNE+
	RRSyOGDbNk9xYhfzECOcDoyYLiLa57I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aLGsm8w0;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764164849; a=rsa-sha256;
	cv=none;
	b=8aHoSi1hffoxUqFNHrh0tR3mlbvh9CI+zfqqMln45odTboefMkVXiwiKRYrhtivRFIAedN
	q1hFgFkB/qrpJm4J+o8SpFaFd2M3swiL1X3f0jFDNoo+OQVQHsQRsO1x3LLzopPSExoYt/
	dKDnHPoaX5giI5ghZIRiSikRY+xmgBQ=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so8908194a12.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764164847; x=1764769647; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOcN8utXBvCmBV1D6iZJFhosr0VxKSdczfYTYogMAeI=;
        b=aLGsm8w0NTT/F1dj9JLh3J/kplwTizo3LeiR1VhV1NO60gsFv1QFK2DOv1sRGdBq27
         da1YGVL2VxOYENpRKS5cS9ZpKnNJ0q8QSpI2VdURxtKOpNtKPh5KAgDawHUj2sE/0xi8
         wnbCiBUXfxZjEUVpgH7OE6HblIpT1bORLJl6dNxzUORt1YwRWk/cNvPc1Q6CXGlHPdCn
         v4KPTN+oMSVQcjZAtMmt4DulljE8wqeGpLDAlGh8A1WyQS1NHa7C+OiIa19ojfFscJ8l
         MSQbuXTrKab56ZT8aStZB9zaCirBgn+pn8DzOTiEnIBWQsabC8TNWPsjYoQOAbQ1aO6h
         O9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764164847; x=1764769647;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOcN8utXBvCmBV1D6iZJFhosr0VxKSdczfYTYogMAeI=;
        b=dxuyedCYUXpmSwRe0p19Zx/gG7A8V+czbd594mJciBwP/5ZpMiA57hNfRbL6SDWKc2
         Xqbucw9GjAKtGMkPAhwQtSP0oAwRH0w888DFuPptkzcGuymKX6gA/nRtzvHL9kiuv3k9
         bBLkHaWNGPvwJnMUc6ZcwizHK+DhuGpoV23BsSFBg/Y/H9iunbDtNRCHiNc+IMRWDfU+
         r3Vb4+8hgo5xHv5KgASEtCcAbBvYeZL9TuJ1/AVp9aZ2GA8XN9NXbdN4OdFy8TXZjlJ2
         vGYACWXnkno1IYpjZ+JLL5wWo6RedX/VkJ1s8zSNX2CzvFphU9gLnpwTXrMib+HDQa05
         cGEw==
X-Forwarded-Encrypted: i=1; AJvYcCWgZMC0CSK7TDZFTUtjPtMmjF/nxrUTy0EI1gb/aaI5mYVHazUY2YNjoJig75P/tXvUgb/1ZpZCZA==@kvack.org
X-Gm-Message-State: AOJu0YyDi10hja0RWwSAgK/hg/zFMFiO1e73z3c6Naik18OHmLMrKiYc
	iBqJ3cFwDjv9DICY+1QTqtNQk1bN4MZKqMQZUqLF4bs4+6DqZr1pdzNT66YT5IZ1
X-Gm-Gg: ASbGnct4VczduZD75A8+2G4O9DetdNDuG2gUuA72fx+ukblt4Gut/85VKq7BlttW/rO
	voHoXu1M2FNjM0fUb2E96qVPMgwBwZJFdau98jkMox5B6qhhiEjb4esBv07d3Ol2Z/EL9J3tCop
	JT9MNr26s7uf8DI+93xgUYLIY3WbrgQS9TGPW3Mmn9txGEVYpjVbFPNkNIRfzWxIOoMgbQWoTle
	B1LKoxAqVkJijGCXpSxO8ZQWvgn2idmfR7z1KGWErzZ+B16PvslaB3QPQYYMa9ovNjs+v4LYVfX
	fB8kWtFQD0mHw+ANm5MI9CBMetv4ihsMSR51Mzqa14VLCO4Ts6+khX0kB1ySZSLbTsZTzhEqRkb
	ZSqvoBNlWSNKKLxaWgbXBh3e+hxGJgyBt+/kbV5SmG/RNYpcaHO73wV8AdIf9g+1sObwIQaW6xn
	IAhZyDquG1Ow==
X-Google-Smtp-Source: AGHT+IEHPtR4zyLqNCyvJKPqlt3PqTSeJMo8/BMvDE8703ct4FKH+8I7ByzjstUJPqKt7PJP3sWJCg==
X-Received: by 2002:a05:6402:50d2:b0:641:3189:a183 with SMTP id 4fb4d7f45d1cf-64555b99be9mr17506130a12.14.1764164847223;
        Wed, 26 Nov 2025 05:47:27 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363c56a4sm17704368a12.15.2025.11.26.05.47.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Nov 2025 05:47:26 -0800 (PST)
Date: Wed, 26 Nov 2025 13:47:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Message-ID: <20251126134726.yrya5xxayfcde3kl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-7-samuel.holland@sifive.com>
 <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
 <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
 <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A9C8A0017
X-Stat-Signature: 75sw3wa3yzmtuj7x5do1uepdkd7jyh11
X-Rspam-User: 
X-HE-Tag: 1764164848-805768
X-HE-Meta: U2FsdGVkX19CsZRj9zUNlPCUWyp7C6qPVOXaAU0pr4fN1/JPbHAJ7DDPr8fRgQi5ZpPfchKqqoGTTWFxArBMm5Sft0jnC8fgzS/KaXxSf0N3ZuL8A9kBAEwAcjUIEP/uD0tCfshgdaNuskOU6k/N0iH7s8v5dZnkYm7ZIbv13izwgYP4ur5sGXF0EsNTHTCK1CypL4uDQbb2IgAEVTwfd8x2vqwIvVPYqdIs3WuFuH6MQyW2g4tgOpTi/pY5ojG2X1GTVhgUM3PK2VSxosBtIiOExbJIUiWXUA3t39JFoqS7VznK2lex8AtZj9u4JdYRrnpe5/Jow77zz9bN0bv2N3NGgcTrmEdJ8am8ym8qp3ViCUwAKeULZFhJJru/qPx6n3hTl8FayAS7Fq85nDld2vu8ViVhL0fbd20WgI7uXBawXP5wxDZm0r6edgPAKuThtLCgY4Rcl+26xaU70vIb6o5qVERwF4Xs6iYY5Wgfy2Olta2DaBorvlvnvORKmV6nQ7diLE8QG8mrEcpgwTMqIxLtGAKut7gHLb+ghhJGMnOH7Webrw37Ho/Vv4cLRkBaB49XkeWVXl1E8jS0LLKgy7vmuhYYHJHIGPckwdpb3iVFNTHaCAIvlsFIo5v8JKxtLdXtnZwi7Y6O5PAi1sP23WWBEGwYurSmxYNCVBiVwtAwhrHNgNwssSwI9wFa2SG/4CSr7g6UQ7zLi5uY8ZSboLtKMccCQkECXTFXZiaPoVAkSQiOQ/PmHeAmoIQILYOUOXHIL7RbLXSS3TkmYTfCQXxf2UkYQKTZIw7ENaI4Q87jDfpyOdvuqiTByZA8GJGHhag0IvjcG+/Kq/EdBrJmZWNaPfkn9IW5625uJxwmxGKnfNZgm1h4E96dYn7PBa46218F/AwmimT9CoXJ4OaZHAroOisoI7QKgJ5Zj3/e3RMDqm2KQvd4+a96g4xSkZZVWukVg1cAusUmAuE1p6Y
 Dl5f8bY5
 GeAOfxZeUiWqNfUi2QgOiT3PIq5lQikHynBwawKsd0qpGup8cexvlpQk1VcIyJrUeFRZzMT8y6BpGAOw1Y2SNnKFkzQzBPh25MNalWG5N2jT9WZlePjLMcb9PNew4+UxYnrhj0tUTerWuAnqr7m5Hs6s5TW/FKwcwJ8ZFa75/bNdat+Oag4ieJu6ONfGVGgnJGvLW9kqYi8SLiREtZmFOpIo1NYEfNPnXcuoE5V5pze6zvDv8Qcx46eNlqFI/ySxbUh6VJLgsjlBKj5uNMGOcInHMQY8F6Fp0oLG7sone6OW82uyvEGbly1dg2wPBLHNAIo5FH7BDfr9GodpxgaQ1pdKcurPmVV8N+CmRAOX+ty3Yw0l5dCcBVtLfb1lWFvuvzwd6xWP4oShx4yYTopIOiSLigh+hNzL4muQ/cAqS4dijkYwmeHKKeJ077SXHihDjCkysNh5uXJSvS/9CutXXKZ2Khb8pY9j9gnJkwn6GpgUNQDUsLen4zJfgOkHnfZozIWpLWqM0PyYHO1P9FFTluLvE6h17WEbm+2V/oqG7Z8Z6gfjf8dHubgi4FbeEg6GhfybjtWfaONqYCIRNV6uFfZw9ltF9PlFRoHYB4EtaUGaDMtx9CaVskXKtLDpEpx2I7LxZLIHNoMzqM2QLyL1J+mo2gEit6an59WMEU95WHntEzi53dBqoAWPZEWpWTmJitmsd4as8yP0KKLkSymOQfxKhGzP/0tlXSh0znRxzAy4mTos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 01:03:42PM +0000, Ryan Roberts wrote:
>On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
[...]
>>>>>> Hi,
>>>>>>
>>>>>> I've just come across this patch and wanted to mention that we could also
>>>>>> benefit from this improved absraction for some features we are looking at for
>>>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>>>>>
>>>>>> The main issue is that the compiler was unable to optimize away the
>>>>>> READ_ONCE()s
>>>>>> for the case where certain levels of the pgtable are folded. But it can
>>>>>> optimize
>>>>>> the plain C dereferences. There were complaints the the generated code for arm
>>>>>> (32) and powerpc was significantly impacted due to having many more
>>>>>> (redundant)
>>>>>> loads.
>>>>>>
>>>>>
>>>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
>>>>> this out internally?
>>>>>
>>>>
>>>> Just stumbled over the reply from Christope:
>>>>
>>>> https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
>>>>
>>>> And wonder if we could handle that somehow directly in the pgdp_get() etc.
>
>I certainly don't like the suggestion of doing the is_folded() test outside the
>helper, but if we can push that logic down into pXdp_get() that would be pretty
>neat. Anshuman and I did briefly play with the idea of doing a C dereference if
>the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
>helper. Although we never proved it to be correct. I struggle with the model for
>folding. Do you want to optimize out all-but-the-highest level's access or
>all-but-the-lowest level's access? Makes my head hurt...
>
>

You mean sth like:

static inline pmd_t pmdp_get(pmd_t *pmdp)
{
#ifdef __PAGETABLE_PMD_FOLDED
	return *pmdp;
#else
	return READ_ONCE(*pmdp);
#endif
}

>>>
>>> I find that kind of gross to be honest. Isn't the whole point of folding that we
>>> don't have to think about it...
>
>Agreed, but if we can put it inside the default helper implementation, that
>solves it, I think? An arch has to be careful if they are overriding the
>defaults, but it's still well contained.
>
>> 
>> If we could adjust generic pgdp_get() and friends to not do a READ_ONCE() once
>> folded we might not have to think about that in the callers.
>> 
>> Just an idea, though, not sure if that would fly the way I envision it.
>
>

-- 
Wei Yang
Help you, Help me

