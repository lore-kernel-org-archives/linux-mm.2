Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F59C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65BA36B0099; Fri, 18 Sep 2026 11:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633506B009B; Fri, 18 Sep 2026 11:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571326B009D; Fri, 18 Sep 2026 11:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9026B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:56:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 932A0A0714
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:56:25 +0000 (UTC)
X-FDA: 85227335130.23.06E1FE7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id B5CDD14000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:56:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=k8+yX0WZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789746983;
	b=PoBMIvuZb/6C3lIQCnFZWL8ocHIWFjnvTuKfaDUN0+H8KO4iQHJAEJtjDIrW+wqQHqEUKw
	9Oj7oGhG2wRU/RjMMA5G4hTNXAkQARtdqOapeIQXeAq0sd+SaVjID9DhpXE27tjWHAvhkU
	lyEN/H/b2iqhhuPxh90/XmCWIMZpqnU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=k8+yX0WZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789746983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhGPlXYSIo33J7nYUvrp3043PHqrzomzJnIGNB3f+cM=;
	b=LWjcVA/S5cf0cpD9+q1VKumKkD3By2AapcL9UTgcGOH2ofypgUtEQyxpKNbEmVleN6GQyi
	Tpv90YGu1SvxsOZwkrhQ4e5nhUyE9lvjIsGSLxpJRVWa0D9VzGlqOIg55zxr/bzaP1vBP1
	He4jTlt7z4j3T3gqqI4LonfwJDhNXqk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F24BC168F;
	Fri, 18 Sep 2026 08:56:18 -0700 (PDT)
Received: from [10.57.83.108] (unknown [10.57.83.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D24E43F7B4;
	Fri, 18 Sep 2026 08:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789746982; bh=Yztiuro1Xc4OykaRC7nI2YhmfOG7q71r/xjUWYC+jiY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k8+yX0WZ+rqA/zHh0tPVeR+rCnkkhVppK+TFsnAsx1MVJp9p/INl8Xqdh1PFciqLa
	 Ht6MB/DHCzgmdORKU98cHJb5LEiEMSNgI53Sl4eu8dgPwvgZaI1gJ2AGYSnqO9pgbW
	 3zEuzJlYEW4yLfB4bv2Ny6h1LJ1ATOXA1EjmCQik=
Message-ID: <37bb7c39-f16b-494a-ab96-771b2d4f6b85@arm.com>
Date: Fri, 18 Sep 2026 16:56:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] arm64: convert between HW PTEs and SW PTE values
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5CDD14000C
X-Stat-Signature: b6b1ck7cih139gddncgwppbcdkn69p3o
X-HE-Tag: 1789746983-603073
X-HE-Meta: U2FsdGVkX1+erKmTX1hfisqmmQMJo6VJGRHjKy5WGOCh6MMO9agXePKjsDNG1ti3HIGf+8TuTIgTSnLMpgYE7+Kz5wB5JMRpGlwvh1xOAXPzhqX+mRM6RvA479zjiGnosChaQz2BCIZxguqWj09Hf2OcUibf/wU0Q18EmAPQuBcdspvSPL594w8F9GTNc9IPfPXCVgs5/1EcKPKOwcz3MpCw+5Rm5q73tJ5aV/+08rPkqv7g6jlz2mMr52mJD2UyqCB4i2bSUyhQrmo/N/3efyTihH0f6jQ3JMT4TkjNPHPuXB07yh1xBunom+xEmj6yYGZYeDdFsysDq9JbUswTTVwB7iStel0TRUBsPQMueaYjqQE91pOYUk60Yz+n4+RoYpVXJwL12Lzb6N5KDIOyIPiDL35aWKu149/GW/GVCZY2JkllmSczAJRcMbXuDRdLeRsN6A7rqSbbZGRi4WgXkdiTU/jJ/nmMXwErEc/3F12CeJDt1uVC7HRVopQzKxIos7zXqPCGEEBjJfMEVW6+x2wZMq46cQd6sqPWjc3p8yW1Kzo4zkCXa8Pk/Y+ORQ8ueh302pzMyFh7rF5osr05SM0uyaJ2p+DrlA50faV+m0AKFQFtk7pbmgNIWOBlobLXJDYmNaw05NBPdg211lP79clX6+JzPBmd1aa/fVKEb8NwTNIA5ghIqacTdhZQpwRB0yZvpbmaA1e/1QBLdWRPMpuFKDxk+WaO1kuRzUWODy2LLGmn3jajEmeWaimybi2AtvogOBuO5evUg1z2XAWBHGUXSEXqvcgm1gppgz4cLWjFLqUJCo6acRCGt+Dm2rkkz5UBabemeG1wpQd7OhzE1ichIFDTdO2PcmLNnN4gnn4SVxYxrK++lwgEZsYX9tJUd1+4AnNX2B6Wy/MKqp+LXMBPQgR52lQkp7EukNbAkFVsZX1nAV0M1sqaW23zWRFOAY1TUTgz/JUoR8UJ+aP
 92Fi4uA7
 O9n0PsyMeOULogYRjtfFuQmkOMCUKBt/k8CsYS3Ok3UzjZhS+wBpNaPH0lKJ2rwcunTxOerJPQ9IfLfC9WOqsa4PsmK678N+S6oWCTZZrtL6EXjoD8zDfiEZTmvEgSwYe9wlsgNGDBFEbVYt1qqheoXRTs34OK7sKWihjglKoPEis5Y95KKbSwS+OIU9a6bJsIDigJSDeJKJNWiV58HFeNvVQW+H0vRwwrTj1BtVvRUSQ6cuhJV1SzekOfHym38mxhcJMcNl6PyHE29JXlVbSIFmRuChFiROLmYY/I+NTRIb4AbEA7NLUbYgJmQRCzyg4HgQFSOX8BmrhyivDw39Mdwcnbfbu3NvZNuL9g+yrZqS81u2cH4Yt9A753g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> __ptep_get() returns a SW PTE value, and __set_pte_nosync() accepts one.
> When HW PTEs use a distinct hw_pte_t, directly reading or writing *ptep
> as a SW PTE value no longer satisfies those interfaces.
> 
> Use __pte_from_hw after READ_ONCE() to obtain a SW PTE value and add
> __hw_pte before WRITE_ONCE() to form an HW PTE.
> 
> Define __hw_pte for both the wrapper and alias configurations so the
> same accessor code works in either case.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 4 ++--
>  include/linux/pgtable_types.h    | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 4768ec59de555..67c4a6179e154 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
>  
>  static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
>  {
> -	WRITE_ONCE(*ptep, pte);
> +	WRITE_ONCE(*ptep, __hw_pte(pte));
>  }
>  
>  static inline void __set_pte_complete(pte_t pte)
> @@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
>  
>  static inline pte_t __ptep_get(hw_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return __pte_from_hw(READ_ONCE(*ptep));
>  }
>  
>  extern void __sync_icache_dcache(pte_t pteval);
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> index ee4eace5c3e1c..b5862a16aa497 100644
> --- a/include/linux/pgtable_types.h
> +++ b/include/linux/pgtable_types.h
> @@ -9,11 +9,13 @@
>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>  #define __pte_from_hw(pte)	((pte).__pte)
> +#define __hw_pte(pte)  ((hw_pte_t) { (pte) })

same comment as for patch 2; wouldn't this be better off in the generic series?

Thanks,
Ryan

>  
>  #define hw_pte_val(x)  pte_val((x).__pte)
>  #else
>  #define hw_pte_t pte_t
>  #define __pte_from_hw(pte)	(pte)
> +#define __hw_pte(pte)  (pte)
>  
>  #define hw_pte_val(x)  pte_val(x)
>  #endif
> 


