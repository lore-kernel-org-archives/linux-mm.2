Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4DDDCD0432
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288966B0088; Wed,  7 Jan 2026 04:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236496B0099; Wed,  7 Jan 2026 04:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE406B00A2; Wed,  7 Jan 2026 04:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F1B7A6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:29:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7FE71ACEA
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:29:20 +0000 (UTC)
X-FDA: 84304644480.10.34D2375
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id BE8EA40004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:29:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=il2NZgid;
	spf=pass (imf27.hostedemail.com: domain of seakeel@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767778158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wk512LwmO/uZGHz1Ojwhz3Ek5WphQWvtFTpjZjwnzlQ=;
	b=uSaNEZR+/6s/R2QsKNwKlUAwSO/2JcEy9W1b7v8va5HaWTQh6hd1CQ/HkPHPwal0Xi3xOw
	zp0wblPUTJWoIlI27H5BaXI/IVuiUFGp4CCEEsHL+bo1+9aRuVUrAb9sIh1ziY48y41OMg
	GDoHNU8XBuSIpQLMwgrh+sl1vmtR7Kk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=il2NZgid;
	spf=pass (imf27.hostedemail.com: domain of seakeel@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767778158; a=rsa-sha256;
	cv=none;
	b=TgLR3ExLGLy1Ms0BF7X+QlScJGTwZzzrUoWVWH1cOuBgFWX1fADg0TAMLKVQ/tOJqPKaBk
	g/R5CspIqUnj7jWZKQgP93/Yzr65KCPXilsmfBh00mtxrchr9b6wd3ra3Ku1NTzjLXSzd0
	6gClm73+jwsrlzsS6+DSoDDO9ABzWKY=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6420c0cf4abso1644910d50.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 01:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767778158; x=1768382958; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wk512LwmO/uZGHz1Ojwhz3Ek5WphQWvtFTpjZjwnzlQ=;
        b=il2NZgid0bLipzuHnKd+amYdcLt17Q733QFRJsbXoLZDIYO8Wu8DjvShZr9bHYNQe1
         GqlagMU5OxhTzeYWdoTNMIPAsVECUeT/t8hhIQeZNVKQmiUDTeYnRlRfeJ50aQ68mo1h
         6BNLE5zKoDvPblONuWjHipOXyLh44Y5EvJKhXw6camoanKgCFYAS6/G54/SU747xO+07
         n46Hafh4IuoPfkrOiESt/g38BSW+ujExzgrZWU7sAdvdiEDC0yjNYfm51eTinh7srh4u
         EbROrfPmzVm+7e7nhiUp2ae2lDeGyDTA4gh2L4ghH6r3hLX6mEubPThj7RP+P8Hf6G0E
         OyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767778158; x=1768382958;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wk512LwmO/uZGHz1Ojwhz3Ek5WphQWvtFTpjZjwnzlQ=;
        b=BwoK7T2t/p3sG83BC1P1WMxemOm9Lqx/e5JJYM96bgwpmDcw3eyKqtyDOyP560rXoX
         89WgXPnvv9tY4FBXKxGZgNmSDuikpp1FkUsLf7ovp2w64HniSutPhnlVnyBmav6avSBH
         I7Xy5MNcwwcMMyinxCLl1cmEUDCzu27GDcHvug1SZaqRQOG4HQEA4q00YAkwry4gpvgQ
         UQ2GYZPOR6jBvhMXIY+RxmVOLRmF94mKMINsswmBaLjGISUiaTBeCYrOFqIUWRmIvVTv
         JhDyz2SdKYixL3mhVwwjnqfLuRw/XLVJ4mEMv4u0FLgDkvQQzz70oeWEKRXx3L2HLQoT
         VvPw==
X-Forwarded-Encrypted: i=1; AJvYcCWeakI8AENDqRIAxZrmecZ12dLE2/gYzhNtggZJoQUj/zNw/qDZYrksyjYmBQyrrQCsmfXtoUnOMQ==@kvack.org
X-Gm-Message-State: AOJu0YxiPfW2A52q5L16HrZjUl1UMivIyJ6eX61QSmY8v4F+dSjjhuQR
	ZWrjxz0EWOa2EyCYs7yNncYJum4gVKVK0LHMFZgvnECjKisj2yQh7roz
X-Gm-Gg: AY/fxX781gtw3Nk46g0eg+5dkKD/bMFh3mqhYoQYEMXKZcb8+0XEYF/DWAAHe6rFrY9
	QttUuBukG/AHpmjygw19GiyiUI9nuuFagKoBYCnIZpzEsplVLtJAff0yPFkeN/qDfnYPc+kqXeH
	6eBWHiusv6AGN5pX7sS342rH7Knb0MO0ttGw2GdkvHMq310TLgkUG5zx2X4ZFfS7dfao33gmf6X
	W2zj91Aw5bbRMSBjjG6mIRyzOMV021XtuymoGAXalz/gRTDVQ+q/sXWs37KFJNJ+vBFriAml4qF
	WbI5uqWPSiT7NzLxF5H1lmyYJVCodl2Qp6Fn3Hk2f00C+APUbUpGOUdGoVzJgS1dxm3QvzNcOIY
	SUXZ/D83qcF/86mlvRnXIlDOq5iVxjC0FBYZucCRhqQN9vXaq73fJgMS4MFOvMlEUe8yfeNJYH0
	1dtSBbf+FcXyUfv07pb/IsRIihz2GhAuOF1EDhjw==
X-Google-Smtp-Source: AGHT+IGPYSkTJQTXRdeZJNO0Ptp1UF4C4ZvN+4Y+pwY9mfVj1KcuNobxA+hhEKXT47wj8D4Ny+QBYg==
X-Received: by 2002:a05:690e:1483:b0:644:60d9:8654 with SMTP id 956f58d0204a3-64716c69eccmr1598952d50.87.1767778157608;
        Wed, 07 Jan 2026 01:29:17 -0800 (PST)
Received: from [192.168.2.226] (104.194.78.75.16clouds.com. [104.194.78.75])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d80be64sm1865006d50.6.2026.01.07.01.28.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 01:29:16 -0800 (PST)
Message-ID: <080e493a-e4f1-4c97-a3e1-f76f126b5213@gmail.com>
Date: Wed, 7 Jan 2026 17:28:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pgtable: convert pgtable_t to ptdesc pointer
To: Mike Rapoport <rppt@kernel.org>, alexs@kernel.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
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
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <aV4h5vQUNXn5cpMY@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4trda5y9o65t9qg9hdb5phpx4wdfbt8c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE8EA40004
X-HE-Tag: 1767778158-566682
X-HE-Meta: U2FsdGVkX19m/+FaQJTjB6um2SVyvY8a6MNzJ5V0twGgyGlP4PXkXi3dEmSCiOVWZmcV+1yfiY0f/C4dMSxUJX0R6paQJQ6XpuE7JrosLbjUYOq/uX8WouGm5NIvMO1gC7QbXS9pCmNX9SRJhzowyl/yAtt9Dq9YAdktDLYF5GNrGIh+uIkYCbiK/AOY4zbGuI3NMTNz2KJjX9exJLcHOXsUg3kob6gOCLQj4bZ9jxhXtLpLn3doNiZ4jl3agkftYHb5HTk53Wxc5WcpXDRL1JgHzkwIYSmK886+3LJmfLD6tcrPYI4QdPuCK5poYsHsX7iHd58uauWfhTQO8yVeO8MgMFrvwfDY8SrtQS9exhVky7qKGhBGW+qXEjWyZbUde6U8TazBlADHdyJTXO+5gFMcs0QvgAOZN3R9WnksoHERowfwVcajdqPrqanLXkaMSf7CPEWsDuj2/gdoLkCbFiwjqV+jUOCaSP2OTSjIJOVjm2qsics1rOg5Lt3UK63b/Uajhun2M3Dn5tSQv16BfzQ7EBVs056fjySXvUYBnoLNqKZufjJ4yTQb5ndNJwGwzApFpAT26+suHr0WcA4dES583BJ0XR3HE1FU23K9kd66OQFdwVQkbeTM5FjhlQhXVpckot9s99D0Izq/skOKqgVV6y+YxCmAhhGNaD/oll13eQizMg2mAvrPY0vU6kortFC441weoeeKu0IwAwKBU1mBTF8ZK0pplcIkq+dRtxku5y1HEGcAjKa6hVEwt9lkFAXjyBvB1ybsvmQRHTpaet+CjrjL/2Gv0w3ImiItheQDcY8B6KBqcH4ElqJHqaPSgtzQSorAp89zmbxYMmM03tu/nvTydnRg6a3binQhVD4lYx8NTiGG0zo/am7sgdqCvOaRRQIY2jOEn7dnnbRAv8XsEYn8tcNBdVZIRc8xKMyTFRRi8aXFtCVP4OPy8nMiBOR4g1jddNg4xyLSEl5
 IlYiKBWU
 oaxmj56CIBsdSR0VzPjd7+zblESoDqGAxvDCO/RjBiRL+4BqDWUxIsJ7Tdr98BwT8ywnaVfRSIIFhdVq++Eet+6rCJjvm5g1cWlgpWCNBvDyW7njZZuAwxY+OCxxozIk7nYAf9JGW1yqaG6Nf1QwgmDPV8+uGzF09KSPmrXgh27IvNeHw1VzcO/wwSY68qk+UL5TBKk3f/McgI/wTqAR/7UIaJGZl8Vsz9OpgIQdMMePAj4g2X/mruRS3iXPkgsa443E/Lr8K7sKojpEga74bD6GuHyoW3+9rmHqXRwu8irut29TyJVut/VbTWjnKtSoMXJwRMxi3CjgxhqfDzilLTJLMZQS2KpIIoOdcRU6UP22JCScXMkmhFbdRYAA1Gp396YPNoNoOZ4pJqJgEeL8R5VOXQHiDVi3B0j6lRax3f93hjl/SauGubKsdrysvuFXca6yYOE6ekN44+Yp+nAp6ehcbzG0NJzSp5ykL+q5A5q51k27pSiZaCV1DS147tIF3j3S3AovCu8lEjN3n7UoALcphyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/7 17:05, Mike Rapoport wrote:
> On Wed, Jan 07, 2026 at 02:46:35PM +0800,alexs@kernel.org wrote:
>> From: Alex Shi<alexs@kernel.org>
>>
>> After struct ptdesc introduced, pgtable_t should used it instead of old
>> struct page pointer. The only thing in the way for this change is just
>> pgtable->lru in pgtable_trans_huge_deposit/withdraw.
>>
>> Let's convert them into ptdesc and use struct ptdesc* as pgtable_t.
>> Thanks testing support from kernel test robot<lkp@intel.com>
>>
>> Signed-off-by: Alex Shi<alexs@kernel.org>
>> ---
> ...
> 
>> diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
>> index a17f01235c29..1a3484c2df4c 100644
>> --- a/arch/arm/include/asm/pgalloc.h
>> +++ b/arch/arm/include/asm/pgalloc.h
>> @@ -96,12 +96,12 @@ pte_alloc_one(struct mm_struct *mm)
>>   {
>>   	struct page *pte;
>>   
>> -	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM);
>> +	pte = ptdesc_page(__pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM));
> When ptdesc will be separated from struct page, ptdesc_page() would fail if the
> allocation failed. This line should be split into something like
> 
> 	struct ptdesc *ptdesc = __pte_alloc_one(...);
> 	if (!ptesc)
> 		return NULL;
> 	pte = ptdesc_page(ptdesc);
> 
> 

Right, I will fix this. and sent the 2nd version.
Thanks a lot!

>>   	if (!pte)
>>   		return NULL;
>>   	if (!PageHighMem(pte))
>>   		clean_pte_table(page_address(pte));
>> -	return pte;
>> +	return page_ptdesc(pte);
>>   }
>>   
>>   static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t pte,
> -- Sincerely yours, Mike.
> 


