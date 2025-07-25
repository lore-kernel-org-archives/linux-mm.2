Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947EAC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270DB6B0093; Fri, 25 Jul 2025 13:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247EC6B0096; Fri, 25 Jul 2025 13:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D416B0098; Fri, 25 Jul 2025 13:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 050846B0093
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:20:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89C3AC079C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:20:00 +0000 (UTC)
X-FDA: 83703449760.29.4FA624B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8887E2000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:19:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=zRafmHiR;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753463998; a=rsa-sha256;
	cv=none;
	b=Km+A+Z5x1Nv8Ef5wIxf/xk66lL60z1Zzdd/BMB7N9ZECLY+UxKL1RTu6IrdSP0YXqtAe9r
	O5IQxkGn/+fm9AATGShybMPVzUNXcRbRkJQL3cKtTRWqdOOAycNnCHZ6R2H25zuE953bJN
	FfXGe+Axe4MOKBsP2Gg46NGTca1o94I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=zRafmHiR;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753463998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GB3HN9rENNt5w+QmMp5DXorsMPRr7NrQ810NGI8rf3c=;
	b=QRtWWPHUBfnrxoBU57GNIZ1+7WlQBUOujFcEHhtL07lPoJtbmYGUFN2Xe3cNYGBeLEufCx
	5WF6M4A1FGyOxaIIFSzN+8AR0r80l1s2nlLxfSpMrXMjzMGaKJo/H5A9g/qbAVxi1Vq2qT
	wElDbZj5fmYqfvRuf59YzKASg7uxBWk=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-234c5b57557so21557455ad.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753463997; x=1754068797; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GB3HN9rENNt5w+QmMp5DXorsMPRr7NrQ810NGI8rf3c=;
        b=zRafmHiR9lwe3YEj6cGu22SqFVXbq6aC5vN0/vMMfYjA4vyjka5gXk1prf5wp0/sWx
         3aNwghW0V2OhxXUavuWf35sQuGBRyGyJsP3blTpTlei2bG4dXcICbgbNFHRdI6xyG+eS
         XdElsR6GED9KeQKH+XfOgICX9HSd5hcE7T4ImlPKLAABgnzApAfOCn1t9jAH/4h6Jafr
         PETF2juvHSwbbRfMIexcePdAMhAqIJui1bTOf/5nSixjuXO1Em2HdEpc2ZMGHAwUzYrQ
         9p3HWRpEI2/0VFl9rsT34GEFfqwuPMMds9J4ufuUYyMVEo/UQp35z1pObGjNnuhE2kTG
         nKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753463997; x=1754068797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GB3HN9rENNt5w+QmMp5DXorsMPRr7NrQ810NGI8rf3c=;
        b=V5fx4D1bEYpWJeiBHmMzLrMT/62Tq6TDN3DN3KBflohkQbOaCfLVyECh9DVzae637l
         55Le27rnvg1pXec1ufNoszg7pwKfehhc5dbkhm6c7fuXHTTh5MVNBa8/+H8VYFs6wOtE
         iRg/dslJ3XWVSlLiZ5ethMhmISVgXcGGAK5MhIs34Rr7W4pxPgeSvPhZVhKogMwZu5mz
         388SftuuEjJPDIRXntfhbPGUVTY/ciHdLWO4Z9HJBAWZft6i7LbPaewUAX76ApicUaSU
         IvWe5wlTYYiUyNPXcbEjoTdMmQ84anvE/Bsq4XrWLvjzXdS6rVid8p+W5/uueZTTMrJB
         i/Uw==
X-Forwarded-Encrypted: i=1; AJvYcCVVYA3t9Z34uAS0HHo4IgszyjZOcDtaZlyMTrXKc6r9HgQWfL81jddx6XsHy1MdHjainM0rT0guWg==@kvack.org
X-Gm-Message-State: AOJu0YxufPIcgVIxzF6uwWhPdrs7QZXa522PP+R5qxo0wbvxw8jcj1h3
	yuyTlpcxQEFFuSovfzHVD9jbMvRw074n7+X4+dWAGaSQhDvWCk3hhv3vSAb3lOlQqX0=
X-Gm-Gg: ASbGncuCU6SNriRtbe26jH9i8yFVShRN3SGLm31oNAFlkLAyAh1jh2U6xEJ2jQ80+Ds
	jW5r2o/qQIQXmL4bWhDmYrbykFY1A3ZgoTWcHGFFFFTrif/oshJqIPWuDSWcaC5UaQB7vLkj4Rm
	dmL1Vcy/p0I5oyu1JLcTABtWbsx0ZVgc+BFmCUhIU0adAhSjUDO26vkj+SFDT+ZFFH96z8441JN
	9spedP///imXAGKYnf5iIwhRZzrzuzuMjMTU4q+sATFZt/BLoNE3jOEpuu8IxlhZ3F343VgxmBR
	lUE6kC8Un/TQuB0xYDlS0LJsDNZ2wCwyZAM1wi4JSHpa20chgEM2IWcq14h0wKEDR/9EQ16B/Yd
	75KkJXBgUU1S3B9fOOqXk5jMND3ft55LZ
X-Google-Smtp-Source: AGHT+IFjom9VggtiV3miU2IzukS6s/Aukl0lHveBGocFoUm1oY8gb1MVFBAvHIxhtqVqK5CFl4GXiw==
X-Received: by 2002:a17:903:2f8c:b0:234:986c:66e0 with SMTP id d9443c01a7336-23fb2ff97cemr42397075ad.4.1753463997175;
        Fri, 25 Jul 2025 10:19:57 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe536c19sm1459325ad.162.2025.07.25.10.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:19:56 -0700 (PDT)
Date: Fri, 25 Jul 2025 10:19:53 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "masahiroy@kernel.org" <masahiroy@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"justinstitt@google.com" <justinstitt@google.com>,
	"nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>,
	"david@redhat.com" <david@redhat.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"morbo@google.com" <morbo@google.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"nicolas.schier@linux.dev" <nicolas.schier@linux.dev>,
	"surenb@google.com" <surenb@google.com>,
	"monk.chiang@sifive.com" <monk.chiang@sifive.com>,
	"nathan@kernel.org" <nathan@kernel.org>,
	"kito.cheng@sifive.com" <kito.cheng@sifive.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"alex@ghiti.fr" <alex@ghiti.fr>,
	"andrew@sifive.com" <andrew@sifive.com>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"cleger@rivosinc.com" <cleger@rivosinc.com>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bjorn@rivosinc.com" <bjorn@rivosinc.com>,
	"fweimer@redhat.com" <fweimer@redhat.com>,
	"heinrich.schuchardt@canonical.com" <heinrich.schuchardt@canonical.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"conor.dooley@microchip.com" <conor.dooley@microchip.com>,
	"ved@rivosinc.com" <ved@rivosinc.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>,
	"charlie@rivosinc.com" <charlie@rivosinc.com>,
	"jeffreyalaw@gmail.com" <jeffreyalaw@gmail.com>,
	"linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>,
	"apatel@ventanamicro.com" <apatel@ventanamicro.com>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH 10/11] scs: generic scs code updated to leverage hw
 assisted shadow stack
Message-ID: <aIO8uSqiplnyyNOd@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
 <3d579a8c2558391ff6e33e7b45527a83aa67c7f5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3d579a8c2558391ff6e33e7b45527a83aa67c7f5.camel@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8887E2000E
X-Stat-Signature: c3kdma9p34g4z4h9b6zpjq7x7khtzzxx
X-HE-Tag: 1753463998-307673
X-HE-Meta: U2FsdGVkX19cPVHtPONA76X+iF0TOSOtokEVgLC0v+LWjLuM/aenpTv0HcdsOKdUqUsP+lytyPdq70IZS5wdj6JTIbO+Tydv2kmJWgRtK1JTU613GCr2pQ4WGBJq/ZGjzE9F6PX0UNx+1j6JGbwGBQsEmomuyb9QL/hskC3uurElCyTfQxwucupss9pR0oaAj+sOOhzfn2jGXv8Qql+PwvQYtYNMK8bfjen8EDp5HTfZhU8KZoIeT8t5qaA+eAreyEYxZrW5ZIN6T8gS3X/qqM2FURP4xhbxefN/12rok5iAjjU1zIcc+XgH1BM3E4LMvPPEbAz8a5H8/LpLF+0z0OIq7Sf/RLOSU9OjbSnnbtYMv7yssNmx0HD6TR2N80FCN+cN6TR9DQf6AyWZ//ephG60y0v+G0iJ9jOymnlfCNu1K5uDFiUsMEVpPyJHzKOKzThK1DvOtS12N+2xIXEygEhpePNcvxXldQ/L8LreMX11c0xXxoxLDJqfmqW1g6F1995AJ5/34jeMlKnymzVMff6suM4qr4GYVTjopNdRlE3FriHSqZ/5lovx+L+3Q8sGgnS6ho4zBDNAtJ6nFVqV9ZGp90xrz/nDdijd5a2Q8SiReSCTcHpq+V40dJV/HI5wdKedwzOuMqx14BwVuD2/HDLec6JYAvminsT6/4R/gBLAakXxLcfF3noGy9rzO5GpN4aB3IDO0SfYim/+3y5938JXbw7s7l6v4Bgx+vxGh+j5MzYWAdFBXpfkgWFjaZnlxnHxzSkup5ZfjYi7vytvBN2QHHrTeTKwcZQ78GvXGdtS3OIS9LGmxWmz82yeoYDB16oPnqcezpLbb3JtsaRihdlIiDatIgOglOYei69Z2BOiyKcyGhBkFxxP5V1dMJgaWMfyhDB2PYenXv86z6um8R33gejEwgXsRiPGa2/Bx3d266ipk656VFHTuakdseHi1B7rZUjWAGlgezAQ4dP
 qIhfME8t
 vRxvDZ/cyrTFo2N5UXl+QxVilXV/zYEl9/oFxc6jWcFo+W3Bt8RUbEIqaKKaOBnimIckGhvRzi3mSmLOdI6iE57VvsdSP/TqpwjQPqj4Qpj7Ubw7Q9A4Pc5idNoQXoybPjN8PWz56Htp//mtt52QdUjurUNq7K9DBT6YIICBLr3eTFhtYamhvM1UWms0cCLNPUzjoMOv6L8BNJ6fxz/HHbdGwu6LDiZMNuOrgQn2fjo/HctI02gOUKTmiuSHQWuYVrAFopC59EgAuqzqDGZK+SiIWniZGymEXvY1p/Ev7Nu1sGaQAMf7pfw50bgsU6fx616csdD7yaxL1g3dhnHeSOxBEZOHF0jfqE5oAEeJ7vz8zHCIOJ4MHkT9HZhH1ZQhJTCLRH3+YdveM01P3DoLH8F1qsXE1Sp2cwRnyZQBMgAn0HqanvJi/rCJBifNynv30pqnz+68Mwf+sk0dAWWUiX28LcAv60fx4Fa0Aa4x1ed+W0+AwOBpTLWRu+fPpeLTs7hxoEHJctc1QRo4aZcxfSZDK8Tv0l1BmoEs+2m98xgA8uY+i6G6Gw8mIcFI6SUSmRFUpBGpe1IxvDxxj43yJz0a50ljJKKeRQPNmRDgaziI5tdcD9T6A/zrGzOhW6n2FuKy5rtof87fe1yw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 05:06:17PM +0000, Edgecombe, Rick P wrote:
>On Thu, 2025-07-24 at 16:37 -0700, Deepak Gupta wrote:
>> If shadow stack have memory protections from underlying cpu, use those
>> protections. arches can define PAGE_KERNEL_SHADOWSTACK to vmalloc such shadow
>> stack pages. Hw assisted shadow stack pages grow downwards like regular
>> stack. Clang based software shadow call stack grows low to high address.
>> Thus this patch addresses some of those needs due to opposite direction
>> of shadow stack. Furthermore, hw shadow stack can't be memset because memset
>> uses normal stores. Lastly to store magic word at base of shadow stack, arch
>> specific shadow stack store has to be performed.
>>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>> ---
>>  include/linux/scs.h | 26 +++++++++++++++++++++++++-
>>  kernel/scs.c        | 38 +++++++++++++++++++++++++++++++++++---
>>  2 files changed, 60 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/scs.h b/include/linux/scs.h
>> index 4ab5bdc898cf..6ceee07c2d1a 100644
>> --- a/include/linux/scs.h
>> +++ b/include/linux/scs.h
>> @@ -12,6 +12,7 @@
>>  #include <linux/poison.h>
>>  #include <linux/sched.h>
>>  #include <linux/sizes.h>
>> +#include <asm/scs.h>
>>
>>  #ifdef CONFIG_SHADOW_CALL_STACK
>>
>> @@ -37,22 +38,45 @@ static inline void scs_task_reset(struct task_struct *tsk)
>>  	 * Reset the shadow stack to the base address in case the task
>>  	 * is reused.
>>  	 */
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	task_scs_sp(tsk) = task_scs(tsk) + SCS_SIZE;
>> +#else
>>  	task_scs_sp(tsk) = task_scs(tsk);
>> +#endif
>>  }
>>
>>  static inline unsigned long *__scs_magic(void *s)
>>  {
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	return (unsigned long *)(s);
>> +#else
>>  	return (unsigned long *)(s + SCS_SIZE) - 1;
>> +#endif
>>  }
>>
>>  static inline bool task_scs_end_corrupted(struct task_struct *tsk)
>>  {
>>  	unsigned long *magic = __scs_magic(task_scs(tsk));
>> -	unsigned long sz = task_scs_sp(tsk) - task_scs(tsk);
>> +	unsigned long sz;
>> +
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	sz = (task_scs(tsk) + SCS_SIZE) - task_scs_sp(tsk);
>> +#else
>> +	sz = task_scs_sp(tsk) - task_scs(tsk);
>> +#endif
>>
>>  	return sz >= SCS_SIZE - 1 || READ_ONCE_NOCHECK(*magic) != SCS_END_MAGIC;
>>  }
>>
>> +static inline void __scs_store_magic(unsigned long *s, unsigned long magic_val)
>> +{
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	arch_scs_store(s, magic_val);
>> +#else
>> +	*__scs_magic(s) = magic_val;
>> +#endif
>> +}
>> +
>>  DECLARE_STATIC_KEY_FALSE(dynamic_scs_enabled);
>>
>>  static inline bool scs_is_dynamic(void)
>> diff --git a/kernel/scs.c b/kernel/scs.c
>> index d7809affe740..5910c0a8eabd 100644
>> --- a/kernel/scs.c
>> +++ b/kernel/scs.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/scs.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/vmstat.h>
>> +#include <asm-generic/set_memory.h>
>>
>>  #ifdef CONFIG_DYNAMIC_SCS
>>  DEFINE_STATIC_KEY_FALSE(dynamic_scs_enabled);
>> @@ -32,19 +33,31 @@ static void *__scs_alloc(int node)
>>  {
>>  	int i;
>>  	void *s;
>> +	pgprot_t prot = PAGE_KERNEL;
>> +
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	prot = PAGE_KERNEL_SHADOWSTACK;
>> +#endif
>>
>>  	for (i = 0; i < NR_CACHED_SCS; i++) {
>>  		s = this_cpu_xchg(scs_cache[i], NULL);
>>  		if (s) {
>>  			s = kasan_unpoison_vmalloc(s, SCS_SIZE,
>>  						   KASAN_VMALLOC_PROT_NORMAL);
>> +/*
>> + * If software shadow stack, its safe to memset. Else memset is not
>> + * possible on hw protected shadow stack. memset constitutes stores and
>> + * stores to shadow stack memory are disallowed and will fault.
>> + */
>> +#ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>  			memset(s, 0, SCS_SIZE);
>> +#endif
>>  			goto out;
>>  		}
>>  	}
>>
>>  	s = __vmalloc_node_range(SCS_SIZE, 1, VMALLOC_START, VMALLOC_END,
>> -				    GFP_SCS, PAGE_KERNEL, 0, node,
>> +				    GFP_SCS, prot, 0, node,
>>  				    __builtin_return_address(0));
>
>This doesn't update the direct map alias I think. Do you want to protect it?

Yes any alternate address mapping which is writeable is a problem and dilutes
the mechanism. How do I go about updating direct map ? (I pretty new to linux
kernel and have limited understanding on which kernel api's to use here to unmap
direct map)

>
>>
>>  out:
>> @@ -59,7 +72,7 @@ void *scs_alloc(int node)
>>  	if (!s)
>>  		return NULL;
>>
>> -	*__scs_magic(s) = SCS_END_MAGIC;
>> +	__scs_store_magic(__scs_magic(s), SCS_END_MAGIC);
>>
>>  	/*
>>  	 * Poison the allocation to catch unintentional accesses to
>> @@ -87,6 +100,16 @@ void scs_free(void *s)
>>  			return;
>>
>>  	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
>> +	/*
>> +	 * Hardware protected shadow stack is not writeable by regular stores
>> +	 * Thus adding this back to free list will raise faults by vmalloc
>> +	 * It needs to be writeable again. It's good sanity as well because
>> +	 * then it can't be inadvertently accesses and if done, it will fault.
>> +	 */
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	set_memory_rw((unsigned long)s, (SCS_SIZE/PAGE_SIZE));
>
>Above you don't update the direct map permissions. So I don't think you need
>this. vmalloc should flush the permissioned mapping before re-using it with the
>lazy cleanup scheme.

If I didn't do this, I was getting a page fault on this vmalloc address. It directly
uses first 8 bytes to add it into some list and that was the location of fault.

>
>> +#endif
>> +
>
>I was thinking someday when we get to this for CET we would protect the direct
>map, and so would need some pool of shadow stacks because flushing the TLB for
>every thread alloc/free would likely be too impactful.

Yes pool would be useful per-cpu.

>
>
>>  	vfree_atomic(s);
>>  }
>>
>> @@ -96,6 +119,9 @@ static int scs_cleanup(unsigned int cpu)
>>  	void **cache = per_cpu_ptr(scs_cache, cpu);
>>
>>  	for (i = 0; i < NR_CACHED_SCS; i++) {
>
>Oh! There is a cache, but the size is only 2.

Yes.
In next iteration, I would likely increase the size of the cache if
CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK=y.

>
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +		set_memory_rw((unsigned long)cache[i], (SCS_SIZE/PAGE_SIZE));
>> +#endif
>>  		vfree(cache[i]);
>>  		cache[i] = NULL;
>>  	}
>> @@ -122,7 +148,13 @@ int scs_prepare(struct task_struct *tsk, int node)
>>  	if (!s)
>>  		return -ENOMEM;
>>
>> -	task_scs(tsk) = task_scs_sp(tsk) = s;
>> +	task_scs(tsk) = s;
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	task_scs_sp(tsk) = s + SCS_SIZE;
>> +#else
>> +	task_scs_sp(tsk) = s;
>> +#endif
>> +
>>  	return 0;
>>  }
>>
>>
>

