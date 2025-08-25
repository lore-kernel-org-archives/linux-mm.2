Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B2AC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 21:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609298E0080; Mon, 25 Aug 2025 17:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9E68E0038; Mon, 25 Aug 2025 17:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8BD8E0080; Mon, 25 Aug 2025 17:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 394368E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:05:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AD91139151
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:05:37 +0000 (UTC)
X-FDA: 83816511114.11.DE3DE85
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4417C1A0004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:05:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=eSf1Fqgg;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf19.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756155935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZcPPbu+aYl9Xu1jLxey4/WhZ40S4z542awI5r/G6Sno=;
	b=rWzjUuf63+hrBUqTmMSo245E6n+FbuX74vWEtFiBtv4LyngB1eCS+QxJz7J0Buwt6K6t6i
	VUMFkXlvUL/RZnmCwLll4euBgS8Pxwj4KPodGIXi1aJ2/XhJk1vV1ExA15ubvu43EMYFmV
	CDBe3lju5yq9/TaebaIotl3gdl8TUcU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=eSf1Fqgg;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf19.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756155935; a=rsa-sha256;
	cv=none;
	b=6rAljrHegfQGDI9+F8muMzvpA7Vm+TxgKkZSWGLUJh65RUy9SbEuDZr7qXFu2sKwe8oUPS
	gvtrzkGVSx9Gq9FK1DWftVDnIvDzN8Wg4UZDqG5yIKthMniGFwGpUUBgHywglBXvK2IYA0
	iIXvBIgYXcH57BAIumObhzpOUhlUkps=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-89018e9f902so3451856241.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1756155934; x=1756760734; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZcPPbu+aYl9Xu1jLxey4/WhZ40S4z542awI5r/G6Sno=;
        b=eSf1FqggxQbxww99B4eHFtegV41WTYK1zOc55p34YT7p0/B0DvmrBJUHfNTlPmC6xR
         Cl9yht2JF8dgIKC0b8aId6lLn8+MRHwfPHGSKxQIJEAPhscPSGNKDyS/uWGTWr73IoWY
         Gog800vsU2IOqGJJt/0AGR+wP+neNwIgpE3EQZEi5C6/wpv6QxjL2HFnfp51MZ242+bi
         hOAtVyXmwL6TSvNuRiVfcD7EiB3W4a/e/GXgwkWSuq72EwuxkiAPDLIZdXNFOYSuNAsd
         iYlZOt+i1mBdcbOcJrDr0Zq4zWBaYfD9NWkEJikHE3KjVwgncuqWbphN+8KKsd4FdqJs
         fk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756155934; x=1756760734;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcPPbu+aYl9Xu1jLxey4/WhZ40S4z542awI5r/G6Sno=;
        b=Y/Kiv2kZCt9yZY1HLoWuoDHlWONinMe3TrwbeVNYm77UNpb0g4X4OoJmmyLj4vA1Vt
         jbTx9u8cVNz2mpjnbynMZIxwcDkb97D2zsK4LdI3SsfcNOhTjR29vaod3XonOpIM4JYa
         3IwA9oe9pzhdBvmKN9bYWB3ZFMg+5a0d7WtMnPKaO0iqn0Lpd4CR3YXRtQNENi8vqt7t
         +RX/3n/VVHevTexzS60DTBlwnqPdWccyy+djUjb5+cYgrIiSXrARORD837nMLXEGsc+h
         WCV4uDgGzUbbUtzmbZtn3ot3AbUQLMsoqUrCB3yXi6uLfwxf96tfGaYR09EL+0vgK4eq
         pJLA==
X-Forwarded-Encrypted: i=1; AJvYcCVi2qEdoto/S0xCdyZKcTIizYDyghne9Gboc0DzJ1wEs3ftNN1aFLN5g2mjnoL2dREq0kSLEAwZLQ==@kvack.org
X-Gm-Message-State: AOJu0YyliItvVXhlgKfxTmSIkrkUgc7wFr4Slfmswfp8jTwttcRqyvPN
	G5EDbjqrgWqaeRJtuQm2y9OxuEy1bk4cpPGR56fGRwfSOrGd2UQxxGP0MCUGVqH9Ha4RUIwVbsa
	OGyzfKzk=
X-Gm-Gg: ASbGncsjB1RCYKqwXwVqXwdlktZssgKQgNncPEpbJ9PR9S/99CsimnfvIUlfiRjeeio
	9Ll5tpJJhliddnaSp1sKrVPbu24V7DeVfD9w5NoPAd3YZU8VEJ5i8nq5wLS4cyEWQTlhHGpnVe/
	WSU4UtBjW6wO0ONvxKn8Odnp3baYoxFQZZowVdGfm7wm1FdMBWVQhiqOIsF4Yqr5MPgXfc3+5fR
	O920cx7qR+txXeIUDKzWRnGL/LJcoMjtDeUf0yPG4K90ZykUTheHmapoiRe9u+/VPdD9bE2ju65
	erOxV57aEVSpCJoEJT+/PSkGGTi+GOkpK47e0lO+mGIabEhpzy/qRTgOyWuMhlSpL9OJhZZAXBk
	0F2aZvX9VSIQ+UU+iEIUcE3GBI2LWn1tIb3ZIPadQqnsPJfy85+wh0Q==
X-Google-Smtp-Source: AGHT+IGl5YyJO5cNchW3hMpUrsJFnsYaH0jFB/UnFZkvzedPO9loSjPBh1OzNXyW8MzaaJOPsbW11Q==
X-Received: by 2002:a92:cdad:0:b0:3e9:eec4:9b5a with SMTP id e9e14a558f8ab-3e9eec49d85mr152368845ab.25.1756155593789;
        Mon, 25 Aug 2025 13:59:53 -0700 (PDT)
Received: from [100.64.0.1] ([136.226.102.202])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4ec1fa3dsm54724275ab.45.2025.08.25.13.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 13:59:53 -0700 (PDT)
Message-ID: <9ae927d3-0a66-4354-910f-155ff9ba3e0f@sifive.com>
Date: Mon, 25 Aug 2025 15:59:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/19] x86: LAM compatible non-canonical definition
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org,
 llvm@lists.linux.dev, linux-kbuild@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, sohil.mehta@intel.com,
 baohua@kernel.org, david@redhat.com, kbingham@kernel.org,
 weixugc@google.com, Liam.Howlett@oracle.com, alexandre.chartre@oracle.com,
 kas@kernel.org, mark.rutland@arm.com, trintaeoitogc@gmail.com,
 axelrasmussen@google.com, yuanchu@google.com, joey.gouly@arm.com,
 samitolvanen@google.com, joel.granados@kernel.org, graf@amazon.com,
 vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org,
 thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com,
 kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
 nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com,
 justinstitt@google.com, catalin.marinas@arm.com,
 alexander.shishkin@linux.intel.com, dave.hansen@linux.intel.com,
 corbet@lwn.net, xin@zytor.com, dvyukov@google.com, tglx@linutronix.de,
 scott@os.amperecomputing.com, jason.andryuk@amd.com, morbo@google.com,
 nathan@kernel.org, lorenzo.stoakes@oracle.com, mingo@redhat.com,
 brgerst@gmail.com, kristina.martsenko@arm.com, bigeasy@linutronix.de,
 luto@kernel.org, jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com,
 mhocko@suse.com, ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org,
 peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com,
 ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com,
 ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org,
 akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org,
 pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev,
 will@kernel.org, andreyknvl@gmail.com, jhubbard@nvidia.com, bp@alien8.de
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4417C1A0004
X-Stat-Signature: n3nnc9om69itum6h8waxzbrfaq3zbpy3
X-Rspam-User: 
X-HE-Tag: 1756155935-639746
X-HE-Meta: U2FsdGVkX18OhqyEPhdSMDc9bh1TvMMBF62K3zIJLN99sKBkMsRBViPS5saNNervDdKss7KJUCR3wA4E1icUWmRegVumZNgXWtmHtYqrZkcSXzyLNv1ywQiPCjWoV2NCtgZd0t9tDPcun82EjdRU0ZbGaFfdxKD0xfxuyFaO0zK7wA50aO00WPCmGYl5hoRAka7pRNtiyY66SLRDzUfmBNW+jVrW/qKmuHa2NcxsTp5lo6kkKlEI4vupVEo2JEh8qrWKXEoerQ3uKIZp0tUGCH82mCL9Wnu/epWgn2/+C8mWwCMgPKsjBL/+/UuP8Ve/6LBXhOEQC+5oJr02qHUXL4kmhuG0Jh7b5Y3LcAPM8ZrZULk6NcGnm5gzljXB4K1s2MI0WJh26WS0ftwlw8B0SdesxPFs8z15FzWDa44tQuN84nyaeDGVvWIGs4ouZl2JAeJard9hIipAif96quIaSQdO/miPhL0nMKJ3X99kOPOw/GOcUYjPRoBDPq8+ug3cCkko8RMy80LbsTz/ETOMaejYWxHOIrJmgxG/9NKanUXECiqKCMJ4B7GCd64/hAYb4fKXUr8XmYgOiRQZJ77avGm/rGQxreQe9zYvQzXcQ2jzQEvDV1hSWpTcA1MDTBHJZz6q9LkAxw2WLoUEE92s4lrPu2+SGCtdUtOQ3RcEG41ObgTxETb5P0hy2RF31NNkWZ8YtfRPAftcn/8lXW0+kQsoTJHilOMGVuc3khYgBaEPxN6iy6E0SbM7d9LVjv8lm6aIc9+OFpTl54/7Ucj2bWKfCjJ5XZA1//Vsu+bguE+fU7tJ5FbY5cZXcinRy7c8Thq/5Sf/Trldcj/rwuM/UTN5IZzqL6bpj2DEeR8Z5aRJ7bYlQ9y3GPiI6miLo0ush7M0VpCvIvOy73g3MMwHx2VRsxIkYmnhQFsLkl/KnR4YVWfXU11hdvPHFIkvM/79kNus37YzNCxNmouhiLE
 tJiGAEBV
 qB+zVcoreBwvU6uZcM3k32QeCMocxESoxz+zuANraLzZw79YBiLo1DsX2sXZPYe/kC1bJ89qdzvpZaV0brriwtiZALQWGdAE9uAwKnj8Hh65BRpMmOAlgtWbBCQ3CXXNsAfe4gwF4ehD44xLDGKqcAkObUlMqhzEXI3e0j6qjt2wEBhbVIC6WTsvyKQtA4ZiBG3zqPLa5P6I5rVjcdVh5u3gZpfyDUsSHIzG4LNohzE2t5w+4O4twaM2NXAD9MnHl7eO5ZjsjoEzTmfsJF5wvKLfvQsrTIeDDgdlLKRbpIR68MOojzciH+LetAtiMUHoy/U/XjysuFvV0P8f/Bmr3c0n7ycG8VpC24tqJnIn2XdaieOQHxu7VbPeaTisUF9gzWQbmxdaUj68SkJtspN3Kd9bSY81kS9I1ySV+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maciej,

On 2025-08-25 3:24 PM, Maciej Wieczor-Retman wrote:
> For an address to be canonical it has to have its top bits equal to each
> other. The number of bits depends on the paging level and whether
> they're supposed to be ones or zeroes depends on whether the address
> points to kernel or user space.
> 
> With Linear Address Masking (LAM) enabled, the definition of linear
> address canonicality is modified. Not all of the previously required
> bits need to be equal, only the first and last from the previously equal
> bitmask. So for example a 5-level paging kernel address needs to have
> bits [63] and [56] set.
> 
> Add separate __canonical_address() implementation for
> CONFIG_KASAN_SW_TAGS since it's the only thing right now that enables
> LAM for kernel addresses (LAM_SUP bit in CR4).
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Add patch to the series.
> 
>  arch/x86/include/asm/page.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index bcf5cad3da36..a83f23a71f35 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -82,10 +82,20 @@ static __always_inline void *pfn_to_kaddr(unsigned long pfn)
>  	return __va(pfn << PAGE_SHIFT);
>  }
>  
> +/*
> + * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks.
> + */
> +#ifdef CONFIG_KASAN_SW_TAGS
> +static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
> +{
> +	return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
> +}
> +#else
>  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>  {
>  	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
>  }
> +#endif

These two implementations have different semantics. The new function works only
on kernel addresses, whereas the existing one works on user addresses as well.
It looks like at least KVM's use of __is_canonical_address() expects the
function to work with user addresses.

Regards,
Samuel

>  
>  static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
>  {


