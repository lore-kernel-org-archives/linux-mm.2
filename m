Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD07AD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 08:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D4D6B0005; Sun, 18 Jan 2026 03:14:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA9C6B0089; Sun, 18 Jan 2026 03:14:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2B56B008A; Sun, 18 Jan 2026 03:14:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5DD26B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:14:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59FA18BE9D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 08:14:15 +0000 (UTC)
X-FDA: 84344372070.01.B66C7AD
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62252A0003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 08:14:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ciVlFyaK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of seakeel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=seakeel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768724053; a=rsa-sha256;
	cv=none;
	b=sUnPl27T5gKwlB0tQiPLDopMo6Wzt+EqlH4SiKlSVcISEuYuGjl/t2zl/puM1BUBwruFLp
	6ZHhqqUDkjbHkLf8s1QYdIiXfNce0inTSP1ZDldzH9KQqMXph5A+xvkn3WsFV6zcij4GDu
	dJaWkpPilZcL3pCktmC1KaPzcMHwwjk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ciVlFyaK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of seakeel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=seakeel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768724053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+fhLmMt6EbvGWzllqZJVhmHGvaT37bdUz8irugZaMU=;
	b=STT8ey6DyXsmCKBnq91IvZTqOj77799sAEE22jReqZmX8G4ujh7MBOxGjT7y5RCaV9prIL
	Q4gEPdpYEGoTe4DxaNWs60tMbZjTFME3nW9voiTgdmVz1MslswRQ/aqHyXgJtlLhX3QU+e
	dXaL+Kt5RhRo3vR4raSMMV515vfh0f0=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0d52768ccso21781805ad.1
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768724052; x=1769328852; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X+fhLmMt6EbvGWzllqZJVhmHGvaT37bdUz8irugZaMU=;
        b=ciVlFyaKQfirykFNLOkSwj/xovppx4U6/Wg+gKaYvpOPrcJq7ErPZWn2DaiTdlyVWz
         bRx8JQAvZ7Bnhj663zNCRd/mK8mfKzTX3wV8jWZsm++U6XxszWVoIzYIYc8nj1zp8OSM
         gU5vcF5w5usyVERjvAriobeSTY9nnN+6rJBxVAv41wZNJVR6fuP9t/xRYYRj1HfnXgVh
         YvOCfvSvWOGdIy7gH+URmo0bV/CLhyc6J/MhV/3g3ZmXu+dsxOfD/mcmpasfm+TR01et
         FskkC9ZhoYnY5VcPAcRQjq6yaiIRyX9k6Yv6V3pxHwVsngr1P6jaw2GqxM95vH725tfE
         quMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768724052; x=1769328852;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+fhLmMt6EbvGWzllqZJVhmHGvaT37bdUz8irugZaMU=;
        b=D0O8lH2iAEEMkQmw56aU3TQmMTptLWHz78u/JgGjbzcCBjCV5peRVjJx518WEBA/hY
         6HhYRBZm6Gds8p0fqYI9JSBh2tPuP9+CdsmcOLiR9WacD0wfVwMiBwS7n2upiH+brQoS
         5disxKagh7cW6lr1Kk5sbGkWsrqHhO5U+iNOgQNM1ft96QU2GfbCW0VqZSEWZHb/XFlv
         VpoLS6vhGHi/VNmObF3HEp0Y2tovD16sSrpFap8mEKELiqnYSB1dyPaIteMxF/f7R54I
         /0970Cq3CCK0LChOsena4LEj73YN9KOorbBOQaRZLoxc2BBlg0zj8N+mKc7BfpZYw7Yd
         hhMA==
X-Forwarded-Encrypted: i=1; AJvYcCXL4/CtqPD550vMsy05fYK84eRDbdU+pPXS/Jl6+dD/O4OxjqBbBI3rVLzkO/dFnQnI9P6e12V4lw==@kvack.org
X-Gm-Message-State: AOJu0Yz13hZUqqTAk2AgfNeUv1xUMAo6S9FhQT1adG9K79XKq+0n9umX
	NnMsKrFx0vv9CH5o+Ii/Aj9qGK86LIYua2RlhRsYVhp97ScA8NhxX+Ah
X-Gm-Gg: AY/fxX5abKwoiTJjglvXelDOvTsPZZdbQ/4QzJ85gpZ/TIpHUhh2tPvEaESRj+pwmws
	sEQo5Li3WOKArWosZjiBBz21IWDg6ZwQHxOgc0tTKuINiyXVoTpYFNtoLXFuWhNn70XufzwWRDZ
	wvVPoIbmErLacFMpQ2BtIoZWxmFPKj4DtLbXCyyap+/p3PzgdFZPa76Jt562FJXSAtTnsTYqhK3
	xiZJJekR488aBpzM2WjOH95UvJXzFcITX6d39Ev+KVGNT1WZhHLcngal8DdTp+QZkDyFr8FSj29
	xqQ0hrsZUHUuYCgyqtqTsIWZEiNqQyYccYRbqRTMPMhQI8S2OxSPM1Wl9gPePjgQkojC4Doq5hn
	Yp6XJoBLirQWbUXL0rqiUq/8b/IkWNx8I3eOeS3ZoPOuJ31Y7jhNemGvGnUXsrQYNml0DjJWePf
	Cs05rS89kq
X-Received: by 2002:a17:903:40c5:b0:2a7:3dae:de9b with SMTP id d9443c01a7336-2a73daedf5fmr2287485ad.44.1768724051933;
        Sun, 18 Jan 2026 00:14:11 -0800 (PST)
Received: from [192.168.2.226] ([114.92.45.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190abcf0sm63240195ad.12.2026.01.18.00.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 00:14:11 -0800 (PST)
Message-ID: <85a0be43-3598-435d-a50e-9403b7e963f7@gmail.com>
Date: Sun, 18 Jan 2026 16:13:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pgtable: convert pgtable_t to ptdesc pointer
From: Alex Shi <seakeel@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, alexs@kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Michal Simek <monstr@monstr.eu>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "open list:ALPHA PORT" <linux-alpha@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:SYNOPSYS ARC ARCHITECTURE" <linux-snps-arc@lists.infradead.org>,
 "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
 "open list:MMU GATHER AND TLB INVALIDATION" <linux-arch@vger.kernel.org>,
 "open list:MMU GATHER AND TLB INVALIDATION" <linux-mm@kvack.org>,
 "open list:C-SKY ARCHITECTURE" <linux-csky@vger.kernel.org>,
 "open list:QUALCOMM HEXAGON ARCHITECTURE" <linux-hexagon@vger.kernel.org>,
 "open list:LOONGARCH" <loongarch@lists.linux.dev>,
 "open list:M68K ARCHITECTURE" <linux-m68k@lists.linux-m68k.org>,
 "open list:MIPS" <linux-mips@vger.kernel.org>,
 "open list:OPENRISC ARCHITECTURE" <linux-openrisc@vger.kernel.org>,
 "open list:PARISC ARCHITECTURE" <linux-parisc@vger.kernel.org>,
 "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
 "open list:SUPERH" <linux-sh@vger.kernel.org>,
 "open list:USER-MODE LINUX (UML)" <linux-um@lists.infradead.org>
References: <20260107064642.15771-1-alexs@kernel.org>
 <aV4h5vQUNXn5cpMY@kernel.org>
 <080e493a-e4f1-4c97-a3e1-f76f126b5213@gmail.com>
 <aV5yIuGi9Ni5YP5E@casper.infradead.org>
 <1d110134-89ab-474b-bca6-cfbfd4b5057f@gmail.com>
Content-Language: en-US
In-Reply-To: <1d110134-89ab-474b-bca6-cfbfd4b5057f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oiu4azegtne3p9dk5keh1yjh3uqtcce9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 62252A0003
X-HE-Tag: 1768724053-337987
X-HE-Meta: U2FsdGVkX1+ilw5Ifk++dsguvzihv4PTr57Ba+cPbtoBYt1puXTRe0W7EBi1VZZEwNVwaeUdTRzh7X07a76QINIqpxzVVn2YgJbVRs0302QPzMt0ExHZBrdrHB2HLwxnVou/CBiW3YUg3m0H6tKU1adhGEQ/+MuOBd+I9NQNB2oq6JjONU1Y3jYpcm+jA9tVUn4Pi0nuZ2l3uf4odd+/9289aRPFzRCgSA7UOa8zBCJ/Qgk8p7A9dcP0KEF22xkDkKCNxO6y19RyA5zOP911zXdCE8TE6vU/qK/a3uB/iPWIUMurAh7Tq/Jx55goWzSPzXr68a9B86hUyD3K33ciAfIgeoZlwFsHMsKiuMho/3m9smISO63hXfsyTNt9WOp9iip0AAeCGPkwUzGMReOkzTFMjn87nmiM5WyGgte/TrQKzbIhV6YIWq4nWqOzWPXLAh09KF00DsGsSYHT73Oy2OJsOEoVDgJPPvT3t2eY1fU43MNNe2SccPy/9Xky4Fk4ihJIlWSiZw9icN2gNBBW8E6OtmuuZHpSdpoTbYEIBTNUG4TVsXpkfbp/nzVzcwl40eL9H0hUfaeWITTKZRRpB9GsVr84kGP4yzjQzZgC8mEjMTy3kriJAbWBImA3cf8ZfLQ6u0ZPDMQL1ElHJnp/GRClOr4tPlH+E6yueOLO2K1eL/caAKs5a7B/Y59yVPRfKe4nayOSExCTgxlCBFCm2gub4s28U6QWN1NKzOjecmhhgRM/QRPmunopr/jA+QStzkvQpf9CTA2I/QMtaXyAi0MjnH8UJ1+JrIIJZ0hOoXh0nqDJVSpN/YhhDxhvLWQtpqJVbT4rAd+/q+VqrNdNUN5YVe34nAY0T1Qg7QQ66sHcrAOMrfSWiCGEYsZogtQQ8U0NwBWZzgNvYcdr90z4u0UUI1/AFAWpS6xCuDWss4E7HVGZmnStQ30uvGhPoXU0sQid4h28/thagQJGiGR
 qCtd6Csi
 tAyKQf0opxr8EAoTyJo6+vkXKF9UNtBZoYn5T/WBL8fiF5k/Sp+4w0MHzrfr1mVAIhI3yKYVlzPrqbNhf7pEGKyy870ijFox4HLlQRjNFZe4Zr11me+kQV/HK0W5Gr46gbJ/Ce5EUt/J63kY9zQQ7g2vy0Uxk5JToGl50uuZi286FOBdcHEDVI/1OdJKMGlXm8RVv6p6dvtp3qFQZDsowJx6VLwlPIaNrXnBYNA35/kIRP9vkz+l/g+CPpDd5HmvcVqprZ3k4Zst1o7ZMLf/jAyIO9MGn6QVLCsZQ5wMG5vmaRZvluvwcN9GbKG2HHMqDGZbVJAcV9aeiqd5dUbpdlV5FpePc1MTNYmBdNV3bk52Fprk+ng3Mo9Egqf3QBwXYIo6OwGpH9IqSIfZ9uMVQjnxBHfByam2TSIjfQXIS7ClMGw62X1qjQ7pSDZ5njaK0IHfes2iAdM0XeVNG+EAkUlQWfTCeDnazlZ1gQgho6Wo5D6UcvDfRyN8v2sVcjDeGNKbn0yIFXBIEUjdSS4h0RQ3aVUgJPwlkBEyoY9Y+wfygNCqBtWk9dfhbc/UoGBTo4Ifj9WTIuuaXa+rsB4KL/a8sbBIdIfdWy0AC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/8 10:23, Alex Shi wrote:
> 
> 
> On 2026/1/7 22:48, Matthew Wilcox wrote:
>> On Wed, Jan 07, 2026 at 05:28:36PM +0800, Alex Shi wrote:
>>> Right, I will fix this. and sent the 2nd version.
>> No, the patch is stupid and wrong.  Don't send a v2.  You seem to have a
>> hairtrigger resend, so I'm trying to prevent a v2 being sent instead of
>> sending a patient reply.
> 
> Hi Matthew,
> 
> I hear you—no v2 will be sent.
> but sorry for a bit confusing, what's your expected fix? is the too 
> quick resenting? or the direction to alignment pgtable_t with ptdesc is 
> wrong?

Hi Willy, Do you mind to share the detailed concern for this patch?

Thanks

> 
> If it's the first. the new change for review address Mike's concern.
> diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/ 
> pgalloc.h
> index a17f01235c29..a204c3ac800a 100644
> --- a/arch/arm/include/asm/pgalloc.h
> +++ b/arch/arm/include/asm/pgalloc.h
> @@ -94,13 +94,13 @@ pte_alloc_one_kernel(struct mm_struct *mm)
>   static inline pgtable_t
>   pte_alloc_one(struct mm_struct *mm)
>   {
> -       struct page *pte;
> +       struct ptdesc *pte;
> 
>          pte = __pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM);
>          if (!pte)
>                  return NULL;
> -       if (!PageHighMem(pte))
> -               clean_pte_table(page_address(pte));
> +       if (!PageHighMem(ptdesc_page(pte)))
> +               clean_pte_table(ptdesc_address(pte));
>          return pte;
>   }
> 
> @@ -141,7 +141,7 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, 
> pgtable_t ptep)
>          else
>                  prot = _PAGE_USER_TABLE;
> 
> -       __pmd_populate(pmdp, page_to_phys(ptep), prot);
> +       __pmd_populate(pmdp, page_to_phys(ptdesc_page(ptep)), prot);
>   }
> 
>   #endif /* CONFIG_MMU */


