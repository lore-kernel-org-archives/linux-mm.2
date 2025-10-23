Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88653CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 19:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39E18E0008; Thu, 23 Oct 2025 15:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11838E0003; Thu, 23 Oct 2025 15:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9A68E0008; Thu, 23 Oct 2025 15:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBA028E0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:37:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7322140C17
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:37:50 +0000 (UTC)
X-FDA: 84030389100.09.600683A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E1BF1A000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:37:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fB/vulMy";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761248268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPouUhrqRxgjcMBstonzlhFIxQsnreNI+UXdXwtR76k=;
	b=dadbvaGi3fHPCdiUF+ZR5WsBxyWeZIcp1TovPjcAlXOnD4t6/Mub4cUzd2FzNO+M28RaJw
	FXK90fbqk7nnuNoaUFPGpw4K6qxvfkGWNQtmtvsKxh9W4sYp8Ml2fwR+vE4Ij8zAOSz/7Y
	g5aAbAlePaMCuuRr4qomAuVeoYLH8ow=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fB/vulMy";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761248268; a=rsa-sha256;
	cv=none;
	b=pwdcTCYOSFf3aJPMJMjvd/vYAMf4pqUiHloXAm/LgBD1mVdtDo0sNivNsKNVP7+jK010fC
	w/kaZD5jA69b9xZvRvOcVrvd6Jo8XhpcYmGAP4r1cRL1wqluiM50rdgyR2k4rQhJfbd+NU
	UZHduuX5JmqR9FhUkhR+JL3xgvzpkLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761248267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mPouUhrqRxgjcMBstonzlhFIxQsnreNI+UXdXwtR76k=;
	b=fB/vulMybcS1QvpLuxNhE1RCX5M3nl9ysjs96MCObN/xoQbaYeLGQCY5Ld3Nqxbc+Ozq/Q
	I3eclPd0loHQkMesuGaOLY+GLLHLKjg+zCE1brxZaAj6BkCHWRm39mNz9XtXEPDhd0Rn5M
	J4t/i7rKdPNp23BcDNbzuPNFl6t9Gr0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-uzS-0V1POReVe2Q2fnRcCQ-1; Thu, 23 Oct 2025 15:37:46 -0400
X-MC-Unique: uzS-0V1POReVe2Q2fnRcCQ-1
X-Mimecast-MFC-AGG-ID: uzS-0V1POReVe2Q2fnRcCQ_1761248265
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471125c8bc1so16183665e9.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:37:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761248265; x=1761853065;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mPouUhrqRxgjcMBstonzlhFIxQsnreNI+UXdXwtR76k=;
        b=RaLFqP7/Zkaf1dvVsvBXJfYq309hHd6CLCOS1BdWn+AUujhLto9ANemcfoeLQ35B8p
         UkbUAW0s1je5HuqMRv+BWhEXq5KtSUnluhmAme9T6aHUkg906BAxjj5amJKVC0httv1H
         rdID5ieY1nP7H4aGqMnGQZWFvU4hYTjzL4IxXuySJcWknhGoh+MPyZe9zB0p2hyoe8Ao
         YFBEeMg8Kqqn6lHIZoROS7YlWx09OwtfE9tixuGi0dzpbSXctjKsuN0eRzV3ieV1XiaU
         XIj3gOSk10w9gWDKa0cO4YmA3nV5/ZsriFKNRg/2hV7k1tfczFa7fV0R3TpqYJvdxNKx
         0yzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvC5ydUtFk3qpPc1IoCSzqJahPO5onoj6YITMpKdoueOcIGdWACe2WReMiUcMOfxhgmpYdKux9VA==@kvack.org
X-Gm-Message-State: AOJu0YyKrsD8SAcWVS+QuuioZqrm4jWYzU4UkgaqinaEZVwFwpp6rTKF
	pSXLSSpnm7SY1Rml7qL0BmI21xVV2D74q7pIp/Zq9IHbTySBqz9zWSzL9zRyd1VuEfhQNMjy5V9
	1h8t/Wax7Q1GAM1FRkAq8r5UL902azmjgrNEoHvOACOghYT/vjRyT
X-Gm-Gg: ASbGncs1iYJ76aNl0fP7CNYyrvA8RfMn5NC0nsioIc6KBfHRt7YB5tVAp1G88csS2F1
	1S7GiZzIKJztwWe+KkEOljBHWuJlAZS4JpDkAw8Bu75dt/bl9G54ZhrSQJzKI9TjGykknm1ddV1
	RPV+l6np7hDOOOVgkORqFmGBXSakvVcinItZdc6WtACeXMRIiH+PSIFsdn8HQtd964u42nzQpNu
	aGezlpVlV7pz1C/TIw3P4hudWj0VzpHQGVu0TBWr5Air0Coqmy7nemx4M7EPATsdmo9SAOdSuIJ
	28athdRs9eae8gvByN8Ix6A/M3is1OGqqZFsVuBXdpnuYaBKmoIxls3vE17BUDVtbH2+N7z2byz
	pZVqouANsvHga5nTGwTAvUoyvdNlW7feSz2DOA250JOWnEiEq3w7EV3f4esi5DMpjzvMd+0ocw2
	/mOgT3fFHQjouqauoG56f6mDL7wa4=
X-Received: by 2002:a05:600c:3149:b0:46e:4b8b:75f2 with SMTP id 5b1f17b1804b1-471178a7ea5mr175792315e9.16.1761248265277;
        Thu, 23 Oct 2025 12:37:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZq8ETk/dxv6lw5okKbvprrCeAKa5W7ysoK9CYeQHAr2H0Pl+EqcgQ1cUF8EEIwcu7bpKOCw==
X-Received: by 2002:a05:600c:3149:b0:46e:4b8b:75f2 with SMTP id 5b1f17b1804b1-471178a7ea5mr175791855e9.16.1761248264842;
        Thu, 23 Oct 2025 12:37:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4369b5esm130845595e9.15.2025.10.23.12.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 12:37:44 -0700 (PDT)
Message-ID: <b0373792-a7fa-41c4-9bf8-979c10be49a0@redhat.com>
Date: Thu, 23 Oct 2025 21:37:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/13] sparc/mm: implement arch_flush_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-5-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015082727.2395128-5-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qPvrW_osctg9sxli0rQM1pTedp627BnwpzhUQDrkDzs_1761248265
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E1BF1A000D
X-Rspamd-Server: rspam03
X-Stat-Signature: n4mk9azzrwefywkdjboz757oywfjy4yp
X-HE-Tag: 1761248268-443157
X-HE-Meta: U2FsdGVkX1/RxTxGj7dC9MO3Punrf4W2fP5Js6L3w3s/U0CiKuhBcgXYc0RoMd2KOkCrhLHKBeMy4mHOwqLr4azNrak5s9Jveso2GvYJ9LU2zKnK7vuGi7/hypQKzqdrAojbB8UdJ/uhnAByZB0a3C0wRUyxdaDM+IDNtHgXWMxnlmIYRKyDkKuKt6cVG+0h4D8lt3HFtmmdrecFW0Cd52qB7Gb+QijbvBffac5D16HwXqGcfpV/X9PLFy0bZMAT6cqt4xiaBAtClhtLpF731vUlgVkdHDDN6DhXO7OzdrWNeDETlHoRdrAfdmAnHXyP9qPc/C/SK1S42Tdl/Q/dlsvm/3anyABzu9EDTxfinIUonvuxFIlRZetWbcHiBZZUpShf1fFG4kYTwKiARHtwb3yp0RvOONUXcpjNLGccw0yrzSaUBDC/yjy/v+WmYCDBKNV1ZdINFJMDR6RYUla2Dd+ygGXWalPwkWPG8Gn1EsHUASXgpT7kOyHfF4MqGooCkX+aDqsPr1EHa7IWV1Yp7dzV1j7+B7Llio88wqeuhIlgxYO4HDENlwr9939nr6wwTSJE4vq4paaoBRQI/hKRRKlZwVdqi/iMwnWk32jKa+c8PgUUUa5G6ocygGE2L5freeg4+Rq6+VWEid3Ec1mwDrwD6LbsqUAxbeAB3H5hScdJ8JsjyONh9VyYBU8x8cH27Z/rWkCZEH0WkCTk9ZnWScffgxYE+tbdjmT5NFinxXFs3NE5r5fC8fJ0nco1DzJXIeyErXbfB/x4rH7X+EnDLXIRVva5SEZfRz2l8+VkCmek6usFWt9FLXh9WZ1qaaE9zw1ckYkapoTpzb0y3ocP0sdykJpmzbntRTWt6tN+vHPPiwtUbwmNcKlFZSHyIAuNS/vWO3MHuAhrx/aopl3hJUvW3zTm9x6Yb+JSUGOvqWMrKFXJ6xAZK2c7Y4VU0R37Gyhf2+8uwLORY/Sn1xW
 VFMqx7WS
 5R7dqxIQQ1APCDs+zjvz8+VmuNXnhgd371BGRoufXfDVm2pfupwvOjx53LTdviPVvGmHH2yswRFMhTXa/VtdgRikwPyF61yB3Yp8TBQ5fMxtSAginf8PPaJ/X3l0v8O3t6K9RSEt6gYx/45LHfgFZHB56hxK5BiocZ8y2jLJo7qfSvhG+acdICqiHLlp5dvK6cR9wXdkxnNS5UWW7/RUcAT3Gp2jZtNXx1DeMZUC8VCVzYXpCkmrscfYAT7ep1LXne4K9roUPKBYTIeRVCN5z4RHy/AAcQmhQh6kQC5ErXWITWbGzYN35dYzlZGsEiqmlY70IgUd1FoXHShJU+geprA3DELMK1EwBjYMj8UtBTtwAprB64OBDcIq0zERlTev8UH4UzttQUKgbAlx1Od90n/F1ufYyG2lmIW7cRpD6axDqqwGvrbiXwK3Vc36LWfU2DJc5COo15hON52Hdszb2O08dtN8KbzUteOvv3nJrQPMsiCNCMUCHDy0x4mx0iTjVaLVdLriznrHCI1F7XkYDzHFDng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:27, Kevin Brodsky wrote:
> Upcoming changes to the lazy_mmu API will cause
> arch_flush_lazy_mmu_mode() to be called when leaving a nested
> lazy_mmu section.
> 
> Move the relevant logic from arch_leave_lazy_mmu_mode() to
> arch_flush_lazy_mmu_mode() and have the former call the latter.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   arch/sparc/include/asm/tlbflush_64.h | 2 +-
>   arch/sparc/mm/tlb.c                  | 9 ++++++++-
>   2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
> index 8b8cdaa69272..925bb5d7a4e1 100644
> --- a/arch/sparc/include/asm/tlbflush_64.h
> +++ b/arch/sparc/include/asm/tlbflush_64.h
> @@ -43,8 +43,8 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end);
>   
>   void flush_tlb_pending(void);
>   void arch_enter_lazy_mmu_mode(void);
> +void arch_flush_lazy_mmu_mode(void);
>   void arch_leave_lazy_mmu_mode(void);
> -#define arch_flush_lazy_mmu_mode()      do {} while (0)
>   
>   /* Local cpu only.  */
>   void __flush_tlb_all(void);
> diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
> index a35ddcca5e76..7b5dfcdb1243 100644
> --- a/arch/sparc/mm/tlb.c
> +++ b/arch/sparc/mm/tlb.c
> @@ -59,12 +59,19 @@ void arch_enter_lazy_mmu_mode(void)
>   	tb->active = 1;
>   }
>   
> -void arch_leave_lazy_mmu_mode(void)
> +void arch_flush_lazy_mmu_mode(void)
>   {
>   	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
>   
>   	if (tb->tlb_nr)
>   		flush_tlb_pending();
> +}
> +
> +void arch_leave_lazy_mmu_mode(void)
> +{
> +	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
> +

Just like for ppc now a double this_cpu_ptr(). I'd similarly just 
replicate the two statements.

> +	arch_flush_lazy_mmu_mode();
>   	tb->active = 0;
>   	preempt_enable();
>   }


-- 
Cheers

David / dhildenb


