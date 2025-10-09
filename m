Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F48CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31988E00AB; Thu,  9 Oct 2025 15:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9AE8E0002; Thu,  9 Oct 2025 15:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760EB8E00AB; Thu,  9 Oct 2025 15:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9FE8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:25:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B9B611B2B1
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:25:41 +0000 (UTC)
X-FDA: 83979555282.14.C274883
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id C3A581A000F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:25:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cwGOFNb/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760037938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J56L85qILujICEJg2uEZiptIUMagBg9oSpxwF2SjTtM=;
	b=yLq2IwKxt7544HE+anSfphPxb3GQuTfHgPKpyUs4iItfDiqT+DSRoe+i2/w1hkYlV6n3UR
	ZFN6jyFGBD1aCNy4SyOZBETm4K0tAlnHWmU8HaaA6hL+hkGYvFSVKTSXszsrG/8/ldNqpi
	LvER7h9DQ9iAfvUHnofaM1ECbLFvFwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760037938; a=rsa-sha256;
	cv=none;
	b=rNml0twXjazSQlNmfdc/TEqDIqi4l5GEfikW5oPc2mDLYGRTcIXIjw+h3DZVzpH9F3TYvA
	gu88Up0GsI5YBIXRqbOFn69n8C+yppAcjb+AueFn/JNQpzzmslH1B8fZnuaeLGUN4jzfAZ
	hJ2bDt+LKXvTb1s1vKWkll9rbZYAuHE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cwGOFNb/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760037938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J56L85qILujICEJg2uEZiptIUMagBg9oSpxwF2SjTtM=;
	b=cwGOFNb/0ryJqESiEQniG0SKTKnhwtp6GO0QYTnK/56AGTqjpxLE6O6bn2qgC5GAaK+UWB
	wmucJ7rmYsskazXxKSfQ9Xy9EqaKVTX/ZbHxs1xedFsd8lt7QxmGNlXA/JdmZEzv193x4g
	FTRhykPbXDkUDijv74AcgWCS1GZB1Io=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-5YMmBepVNNaltiKpsoZLTw-1; Thu, 09 Oct 2025 15:25:36 -0400
X-MC-Unique: 5YMmBepVNNaltiKpsoZLTw-1
X-Mimecast-MFC-AGG-ID: 5YMmBepVNNaltiKpsoZLTw_1760037936
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso1242013f8f.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:25:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760037935; x=1760642735;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J56L85qILujICEJg2uEZiptIUMagBg9oSpxwF2SjTtM=;
        b=ZJrLuPO0YBNKRRxn0c2pY9r1g+pArp+Mj24L6gzfZDPfTXaIFhn/Yg98KbHLlOdyaY
         AjCTk5vvvsR/2o9li09HSuToZd7uQNTr2nqXP86NRWDHBuUqQdK3knIkr1xsCcKjj44f
         q3Yf6NxNbq0hjXwUU0cIiNYk14I8+zq54PCkB33P6b5sPohxW/kWFw+F11o5je12vTzO
         fAAMzzeBew+8dMA1iDK8wpOXoZo9Y3c4Pl7oFf9DYtcexdJ72ZX9zVr3eBCPGkUONVVj
         6Jlv1AXKnbUHS5lQSQcF4Gx4WrRprgYrtdqync5X/HHuFi0oN31ikmye/tsijDDyH+ga
         3cqw==
X-Forwarded-Encrypted: i=1; AJvYcCUqVvyDbQJ+x3aJ+rhzgt+yreJgRppGK7DfbUKhsvJJvnLybfb6/gYcP0+9lqcMa3KLeN7eekWa+g==@kvack.org
X-Gm-Message-State: AOJu0YweH2pbK8tkhBLkAcTzcrtLUDtH4KlnRnz6cmvuPR+HeF6r9Piq
	oAX6P3VAqS8E35tBzGH1m66xUJ1nIatRA7mLLG7oCm4wl5Orx4KwbSygEC1UZDrNuozvEUZB3oD
	gbpWO5LNlQcMST0Y4SmBXyPtq3q4upJvcBB9Rd2R2IZ9GD6gUnjJV
X-Gm-Gg: ASbGnctYWXLUR2DKHGKm9ltAaBfYvxh0K9GKqbu2pB+jldBvgE18g0aeZASyK6pK8qx
	wsd9rSpFsLlr2cngztfgcSAfg7G8VKfTKxzFR/nC24aK3SHxNOcV2BWSlRNcUjNAJCL1wqRNHmY
	pEg33BFY2AW77ty1hmn/gOcz/Rru98XLya23SXBZX27/1jlUnLG1hHe8Gd4ukpwgfnyB/sH/NHQ
	bJU/fcNgUb0cZCaeB8V+7Cokl7PQxtu62ke3gNcPTzkDfTUR1e3QTQKTJD91VSivBaiZX21pN5R
	rjCSJCCX3m8F8jDO37srp03E2gdZYoIR4Hk6u1VaUStkf1C5/2OsJBqR7JBuvmb7GbbVq1BeKEW
	lx+X1oeiC
X-Received: by 2002:a05:600c:c16e:b0:46f:b42e:e392 with SMTP id 5b1f17b1804b1-46fb42ee476mr11435365e9.39.1760037935646;
        Thu, 09 Oct 2025 12:25:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJj0GjP35rwfopMr1VmBMpaViGUOZdOXTQQua3M5Gtjm9FcAJ1nsP6TwIVPFYuGHNQxfRy8w==
X-Received: by 2002:a05:600c:c16e:b0:46f:b42e:e392 with SMTP id 5b1f17b1804b1-46fb42ee476mr11435115e9.39.1760037935176;
        Thu, 09 Oct 2025 12:25:35 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5d0011sm440707f8f.31.2025.10.09.12.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 12:25:34 -0700 (PDT)
Message-ID: <9648e990-18e0-4aed-8110-b02f4b45aa47@redhat.com>
Date: Thu, 9 Oct 2025 21:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/8] x86/mm: Use 'ptdesc' when freeing PMD pages
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-4-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250919054007.472493-4-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R2c3NFEK3iafKTHXXya2ucs5NTFQvb1JHyWrTznz77Y_1760037936
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: xztpap5ces4yrejyn4ga8d1nq67bj9wm
X-Rspam-User: 
X-Rspamd-Queue-Id: C3A581A000F
X-HE-Tag: 1760037938-420123
X-HE-Meta: U2FsdGVkX19ps5V5JDD1GmrNq9DoBVEOab2PPXg851YA6Iq34mUaZ/u7KWc10FI42hPYAyq17B7udaywOkGcLBknwmX0XqRaMRYCVOwTF4HQcyaOVCmwMOeJ71H5Ks2SkMRSPNVza1YF7aG+1FMjCeDpcUn+tVgEOA21MzLRMWAaIS3mbS2ePd4KJRky0iL/TzIVuSPXsqpVXKc7yVLAJGtTHWAijmpkfNNfsTJAbktVJccR4bfBkAexFmLh/M4+A0v2DP76+NJV2V1d95+3VUbJTmpq2dSzOGuBMjM04+op8p+V11GHVyrEa4nYd/ePKDG0rG/Mi+E5l8lWqsGZOam/9LoJTLr8H2q3cmhYEnU7jSy3T2X0p9s0uU9DK4n6q/Bl+pqx0GkV1dh2tiNOMeMv3g1S8Zyg3gOPIm9kXtJzKyQpoqLK5dj7uLv4Uz8NSIklEhykJSeRQkBxSheIrS747Wl0ELlot7WEDFQEw4NL+2MtEHc738+T4VWu3dfRh6edi9OOX9t1YHN4tEwV9FvKVZTNLDh046beTYeWXhpze118Kbvu1ZX0XalzGvuobjIJetxkwHFKohPjIbSYcGYFIZA11pORVeKJ8qFdqURfj4et+iZ4X4OUX8MrnEBy6f0KDOKWD4GEzGeONQoe3hBBInWaWf0NjxIcTo0kwWM9rApXVNzyql/xv/t2SatmI9KEC39GdFsj6T8I8vv404SLbmSZJ3W8b+dwxGcW9GHzQ/fNDevPl0CjaFIqIJ1ArPPqlwh88fd7MlBtfCyAiT5Co3L6bHcSqFMhkmt06teXWb4tdkPXnFMRAogACsiOmELmyv6dWahRcodEw4nfAilMaWahL5TeBqoTk+B/uzFueP5/zjtFYU6Z7ENT8I09d+ukRemJNUcnJ8C7lSPPCI/RHqCvByRRU02+6OC8KtsOVVCo6eP/9GOTkFjjPU4QvgbByI9Jx/f8YwX6aQX
 eMQoXKY5
 nOn1zHkHz4BvHdm6xETO+LBjnI9NyZou0Bs8poC5aSCuZIUp2JL4ui1UClDh+4kgzey5G4FXIC8bt/qDTeZpPiIcSnsKIaF7qGafhPZHTSi6t/j2WWiT4p7uXaJw5LTK8LRLrQ/XbH4378nLIbw860RP1dB8wRfgQzkNzenbw/fi9ldeE9OhMVwD637eAq6o7G5SU/Uw8OHJ9Zdx7GuxgNUfA07m/zPDw9EXC9ASsd2WYy5BCKf0ok1Uolh3a3lEPFJjdZ+Wwt4lJyYbAVqokcJOE3WUX42iT1+XhypjPsmWLkAlCjZjaQWJYeMhUw5yAq2m33532UILiceB5QLpNBXz3gmwO2D4fEL4e2/0TsJV8MZPXMft1htfEByRYkmEGgQjxDrw/GMh6XDSKI24DDQQHmyHDbF/pem/PMAL9nRLPoJGC8/CgfCrnZh7xxch2U/V45xQ4xUHxHIoHSzVMOlOe46zqZoXzzijq1K7x4q8q74lHQvLykoAdsZgrIRvfrwOggVYf4yKF9ZgiysUI3JPlSx9VEiP9kjgPnym3q9utw5ficfqwfywfrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 07:40, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> There are a billion ways to refer to a physical memory address.
> One of the x86 PMD freeing code location chooses to use a 'pte_t *' to
> point to a PMD page and then call a PTE-specific freeing function for
> it.  That's a bit wonky.
> 
> Just use a 'struct ptdesc *' instead. Its entire purpose is to refer
> to page table pages. It also means being able to remove an explicit
> cast.
> 
> Right now, pte_free_kernel() is a one-liner that calls
> pagetable_dtor_free(). Effectively, all this patch does is
> remove one superfluous __pa(__va(paddr)) conversion and then
> call pagetable_dtor_free() directly instead of through a helper.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   arch/x86/mm/pgtable.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index ddf248c3ee7d..2e5ecfdce73c 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -729,7 +729,7 @@ int pmd_clear_huge(pmd_t *pmd)
>   int pud_free_pmd_page(pud_t *pud, unsigned long addr)
>   {
>   	pmd_t *pmd, *pmd_sv;
> -	pte_t *pte;
> +	struct ptdesc *pt;
>   	int i;
>   
>   	pmd = pud_pgtable(*pud);
> @@ -750,8 +750,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
>   
>   	for (i = 0; i < PTRS_PER_PMD; i++) {
>   		if (!pmd_none(pmd_sv[i])) {
> -			pte = (pte_t *)pmd_page_vaddr(pmd_sv[i]);
> -			pte_free_kernel(&init_mm, pte);
> +			pt = page_ptdesc(pmd_page(pmd_sv[i]));
> +			pagetable_dtor_free(pt);

There is pmd_ptdesc() which does

	page_ptdesc(pmd_pgtable_page(pmd));

It's buried in a

	#if defined(CONFIG_SPLIT_PMD_PTLOCKS)

Can't we just make that always available so we can use it here?

-- 
Cheers

David / dhildenb


