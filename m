Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9BECA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 16:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D6C280022; Fri, 22 Aug 2025 12:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E632D8E009D; Fri, 22 Aug 2025 12:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78A6280022; Fri, 22 Aug 2025 12:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C635B8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:02:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E97FB77C7
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:02:48 +0000 (UTC)
X-FDA: 83804861616.04.4736AAF
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F5721C000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:02:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lyZNvW7o;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755878566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+hhnaziEbvfcvK+nslqj/VWqrGu2JLJjIG2S0rWuqQ=;
	b=RPX1aBWHMS/GclMYiXgvP5QV3zfaZfEl3wu30GNq9PENM9KqSQsoy1hoV6CU/FISNisAZn
	gPG9cBxVXjbVaRlXcuOO8WkBK6Tp+5hJu+qCj8DXgatL/1ddQtcl86awJzea0vtXjeAVam
	2Daz1tq4AeFP+kO8rNaSMk4LZs73iqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755878566; a=rsa-sha256;
	cv=none;
	b=JK4bsL5oJJR5jrjEcF4vwfkYr+GNbT3b0yxNUsB6TsVQxkRNs45HXUKLD7tQ9UHcvjy4KT
	6z9vuCPVvaSBJiU/dIISYxvMidSpRtv/d84O0tpinzyhX5jR4V8PUHVjmIT77nz4Xpp8ZL
	oKieAqSaJxTsZfGCgs9Zi8ZGZSs00Mo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lyZNvW7o;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-55e00f938dfso336556e87.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755878564; x=1756483364; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x+hhnaziEbvfcvK+nslqj/VWqrGu2JLJjIG2S0rWuqQ=;
        b=lyZNvW7o/A8ItdqZX4M5sgtKCw+pTGgnvDS38kZ+Nii2Tmr7YX4nHcg1sjijBHa+YW
         FDAyEGNdcSL2uHx7AdwrwvfHN9aNo885faTYI83Vcf7W1iX706XvlkWgm8Q1dKZxBbxd
         4gWWOAvErAsQQENW7qSyc4eKM3F9kfoR2on6hUEJ9QCacepbGsDMN2phA0EntE4R7BvR
         dailgC6BGi3cK8QNdTozU32NZAMLoGsyDnMgn3M+GG/9deqoWqjVC5CbjK2KA1qRglSB
         6HVYsPR5gqZ2CEcjMold+mLH6Y0NwxagFupyegmnB4Zq6QltooO8No/BzJa0xgomY2qS
         UPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755878564; x=1756483364;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x+hhnaziEbvfcvK+nslqj/VWqrGu2JLJjIG2S0rWuqQ=;
        b=jnNWvGhxqWWjj09235zds3SkxQYhw5T+KwMJEAFaXg+fv30aindBSrZWwcsw3Ct0U8
         Z46o7sLc4uRSx/3FIguaYNdQgRQaYkDR6fpoRHTU6UwikSeMWzZNS+JiBVscSIOvGnNT
         Kg4VmEhQGb4RWiPB2CMsVTBmllfkkk/Lo4JUz8gZaTW4NRZGzpmydB3rU1mbggwLAsGH
         GAKDQQWVFN7u/ef97hYIypM4YSC1icklWBQ3v50nguDsBGLJdKSWJLIyhHYc3Y2ZB73P
         YA1c+NdSgKPKGZb7CX59+Qb2iaSc6bV++j8EWXQTmqyHwlUzEZAhc/tBm0PAJWkj8IUj
         hdiw==
X-Forwarded-Encrypted: i=1; AJvYcCUo3cZ72hH7edd4gKENk2xTPiMd5uI91XuVCEhm8Ke87d5XK7TKoUcWiBVDnRYtZFbZHK2yO63kLA==@kvack.org
X-Gm-Message-State: AOJu0YzOsAb68LHYnsbFoIimHXXv9dT0AFNVBi7yU5Cq4g3N+ed85ph6
	myN66ill24JuyTG5O1y0++Pbw3rJHcIuYOL618osA3Ie96y78VcFvNEQ
X-Gm-Gg: ASbGncuHZdmmJuwftXhzD19IADcoq0ZpXmJbTgWG/2cAkiV2cKrOU04qPp8SRG4caX5
	9UwuJ5XjApFNEQojD8Ams5NsuQfO5vExq4GwI9FyZt8JmFbuIped8cm35HvVWh7krR8k6uevNTh
	a88dG5pvRmmnf+k0RBHYNJpmXFH6gYer7qHnLQDMkqVAUUolqH0vSOeKdgeTUHQjlzzvJsoBNJV
	mFtpMofBlc46CbkiEcFo+UEskfvdBLsx97JJeOGDJwXX6lbprKQ2qVyYrS7+m57ycuJvzhYcJmm
	pmv51wK9n8F56P/o2N49zF5ite6Qxt6pJIFoF6VleYh+5w9mrlN8wOiuCfQISeHuTLRvP+Y0QBv
	RDd0XSfhzk0opI91zAuYcgpP2acuQ
X-Google-Smtp-Source: AGHT+IGQszajDGNQAKf7QN48qEfm9n4yUiAaOTXLuqd4oLvJ2QirlJ8t5DPSvNvccFn1KcRv53kJsg==
X-Received: by 2002:a05:6512:220f:b0:55b:2242:a9d8 with SMTP id 2adb3069b0e04-55f0d36fademr679617e87.7.1755878564032;
        Fri, 22 Aug 2025 09:02:44 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f35c02c89sm37612e87.34.2025.08.22.09.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 09:02:43 -0700 (PDT)
Message-ID: <2fb52098-3952-48f1-b6c3-bbc95ce00d8d@gmail.com>
Date: Fri, 22 Aug 2025 18:02:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix KASAN build error due to p*d_populate_kernel()
To: Harry Yoo <harry.yoo@oracle.com>, Dave Hansen <dave.hansen@intel.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, andreyknvl@gmail.com,
 aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 ardb@kernel.org, arnd@arndb.de, bp@alien8.de, cl@gentwo.org,
 dave.hansen@linux.intel.com, david@redhat.com, dennis@kernel.org,
 dev.jain@arm.com, dvyukov@google.com, glider@google.com,
 gwan-gyeong.mun@intel.com, hpa@zyccr.com, jane.chu@oracle.com,
 jgross@suse.de, jhubbard@nvidia.com, joao.m.martins@oracle.com,
 joro@8bytes.org, kas@kernel.org, kevin.brodsky@arm.com,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org,
 maobibo@loongson.cn, mhocko@suse.com, mingo@redhat.com, osalvador@suse.de,
 peterx@redhat.com, peterz@infradead.org, rppt@kernel.org,
 ryan.roberts@arm.com, stable@vger.kernel.org, surenb@google.com,
 tglx@linutronix.de, thuth@redhat.com, tj@kernel.org, urezki@gmail.com,
 vbabka@suse.cz, vincenzo.frascino@arm.com, x86@kernel.org,
 zhengqi.arch@bytedance.com
References: <20250821093542.37844-1-harry.yoo@oracle.com>
 <20250821115731.137284-1-harry.yoo@oracle.com>
 <3976ef5d-a959-408a-b538-7feba1f0ab7a@intel.com> <aKfDrKBaMc24cNgC@hyeyoo>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <aKfDrKBaMc24cNgC@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F5721C000D
X-Stat-Signature: 1uyd96z31wb7hdt7oxrehkwto5xxc35o
X-HE-Tag: 1755878566-881230
X-HE-Meta: U2FsdGVkX18+1AH0KLVXxgASXW9cszA4pNTAe0C2XSFMuiy0a5JI8UcuokMEfd+MFmPx4dslo8R3+vgVwFpWKEzZJQVVM8fWDoaKSxeFFCnQrE2px/1EWeivruMfmLqFe4B0ZfutRLHcde232Qq9LoUgcDhoDsZQRcXyltz6nSNHEjflA5BRHb9nfCQli3mr9rAGK8/blqHISuaEk8KUGGENa++T3FLBPhnppmHepCGfEJtcQbh0mYFd1IBmBb9mQgSYpSq3wMJSij8au5r53G+BedEsrq8M3tIs3rGQzlTwcMvS9fUKHddyxuNHFX90Mx1lpQEGabZenzvIFSVKX/q2RoyWQnu049np9TDzzHJc87elKKreAeXlrv7CL5w81AljvB+4C6E6RK1bh64oQF8BQm5Y9w5KViGrjGx6cPSQq89/PRwkSGDeHR8ZODUSaDXOwFgWI5jdOAELNCHnY8k8PdC43kJjLdQpSI7AjrncBQTBGHO65PvymGI4OKc+s6JuslL2OeXIPNe2jZj2JS1kPFBiAqXkd/3opBbpLMkgqi08WJRu9S189dCcRbZg3V23k79VACeysbhnG0+KyJ6Oud20RO1abyV7+vRpAuSKVLpMoqPeISm1LYdFqmdvMqMoJ4y023NThEPNjJsv1akL7HxmMiChDw70l7PDceCNJws0p1G5VK+WI6iOJlvW85OUVdsqX8fEOpEuOLjMSLe1toiLcFleSCw1Oqxh9xWnraopj1MREAh2ovW9z57raTDWA5FOjhgYEjHYLDcZpCS9eoHwNEPcua4aZUNG/fh1l3HhnuYKr5AgYI6fHK+zfMY+qosa5Vww5GeTHevXQKpVI66X+uV95PyBSOdeXmY7nniVWDty2Cpiv9TH00YvkyoV03Nt8848hNrntw3fJ8Uo+OnZn+VtoBj8UxkJTWbh0RMSb4Q+8T9HyTVn0AHzcrjLKnYv+auC85Kg4LJ
 m+zMvugt
 qC6VrKt6Onn2D9KN8B6W53Sc9SPsFvnYBaEzeBXQTAd6z6eo8lL+yRljjzRl6coGfArfnaZLxPagSpRIgultd3TvdYzeQOLSKtACNZ5vq0tpMgLjcZKNFb/rnyh2+7v/LsIE7ckl407ylxMCXIJoG6BBrmhyAMS29DQmCoBkrwDIW+ZKE5mpLut0MZ8eKruhRGInWfy2Jajhe4FKPCltMnikxZZBSeQo4enaLJP1NCQqKoYh+wIxXgPd/Pr75SqbYwg93L6/BEg859mWiA5XfDruVTvQIgM5zEjoASYdQioieorKlx2nABfiv7Ngx9akFK7htnhYgYqYFoLtiwutabwzzUA7jiTin0bMuOjCTZ3EK7iklTcPKfPnsSaTwZ0ZDNtPvvu5Ie0jFMpUuC5DVOWKxhzfTXhYy8PSo4YIli4JjV4SZy26W69PX7bSYgnEeda2Nlvo/1cGtkiFxcUpYwq+pCy+nXnJgqUY89eDTaZftYF5V+5jBmubet29BPRrWCVcT+2tW1ECmQpZ24rBjb9KSSpMiO8h0OA8YZWFEm/gjDlpDOkvrXgTzXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/22/25 3:11 AM, Harry Yoo wrote:
> On Thu, Aug 21, 2025 at 10:36:12AM -0700, Dave Hansen wrote:
>> On 8/21/25 04:57, Harry Yoo wrote:
>>> However, {pgd,p4d}_populate_kernel() is defined as a function regardless
>>> of the number of page table levels, so the compiler may not optimize
>>> them away. In this case, the following linker error occurs:
> 
> Hi, thanks for taking a look, Dave!
> 
> First of all, this is a fix-up patch of a mm-hotfixes patch series that
> fixes a bug (I should have explained that in the changelog) [1].
> 
> [1] https://lore.kernel.org/linux-mm/20250818020206.4517-1-harry.yoo@oracle.com
> 
> I think we can continue discussing it and perhaps do that as part of
> a follow-up series, because the current patch series need to be backported
> to -stable and your suggestion to improve existing code doesn't require
> -stable backports.
> 
> Does that sound fine?
> 
>> This part of the changelog confused me. I think it's focusing on the
>> wrong thing.
>>
>> The code that's triggering this is literally:
>>
>>>                         pgd_populate(&init_mm, pgd,
>>>                                         lm_alias(kasan_early_shadow_p4d));
>>
>> It sure _looks_ like it's unconditionally referencing the
>> 'kasan_early_shadow_p4d' symbol. I think it's wrong to hide that with
>> macro magic and just assume that the macros won't reference it.
>>
>> If a symbol isn't being defined, it shouldn't be referenced in C code.:q


That's not exactly the case for the kernel. It historically relied on being
compiled with optimization and compiler being able to eliminate unused references.
AFAIR BUILD_BUG_ON() works like that, there are also plenty of code like

if  (IS_ENABLED(CONFIG_SOMETHING))
	ptr = &something;
else
	ptr = &something_else; 

e.g. irq_remaping_prepare();


> 
> A fair point, and that's what KASAN code has been doing for years.
> 
>> The right way to do it is to have an #ifdef in a header that avoids
>> compiling in the reference to the symbol.
> 
> You mean defining some wrapper functions for p*d_populate_kernel() in
> KASAN with different implementations based on ifdeffery?
> 
> Just to clarify, what should be the exact ifdeffery to cover these cases?
> #if CONFIG_PGTABLE_LEVELS == 4 and 5, or
> #ifdef __PAGETABLE_P4D_FOLDED and __PAGETABLE_PUD_FOLDED ?
> 

I think ifdef should be the same as for symbol, so '#if CONFIG_PGTABLE_LEVELS > 4'
for *_p4d and '#if CONFIG_PGTABLE_LEVELS > 3' for *_pud


> I have no strong opinion on this, let's hear what KASAN folks think.
> 

So, I think we have following options:

1. Macros as you did.
2. Hide references in function under  '#if CONFIG_PGTABLE_LEVELS > x', like Dave suggested.
3. It should be enough to just add if in code like
            if (CONFIG_PGTABLE_LEVELS > 4)
		pgd_populate_kernel(addr, pgd,
                                          lm_alias(kasan_early_shadow_p4d));
Compiler should be able to optimize it away.

4. I guess that the link error is due to enabled CONFIG_DEBUG_VIRTUAL=y
lm_alias() ends up with __phys_addr_symbol() function call which compiler can't optimize away.
Technically we can declare __phys_addr_symbol() with __attribute__((pure)), so compiler will
be able to optimize away this call, because the result should be unused.
But I'm not sure we really want that, because it's debug function and even if the result is unused
we might want to still have a check if symbol address is correct.


I would probably prefer 3rd option, but I don't really have very strong opinion, so either way is fine.


