Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF48CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 19:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C3C8E0007; Thu, 23 Oct 2025 15:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D408E0003; Thu, 23 Oct 2025 15:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4EC8E0007; Thu, 23 Oct 2025 15:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED478E0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:37:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09BD188F5C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:37:01 +0000 (UTC)
X-FDA: 84030387042.22.46530B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6D4A6C0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:36:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YYr/t9f8";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761248218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAR+zcyIiLP0EmlRcHQPsRsm2ZVMdnZLABW6LHegPGk=;
	b=gn2BNBXmO/ewkmbBVvHeN9ahjtf3dQ7eta1Rsi7TeNglvCuHZ4tfldCwcZIlxZAzZAaiLx
	7g00zHBG9sykcX8j+CsL9YYwKpND3WqI95P+WOG75xaPYnU0ItULoa2+WArHLJEPyVQAKp
	xkHB8LYo5/65iUeKu42k9UCfKrSHzTo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YYr/t9f8";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761248218; a=rsa-sha256;
	cv=none;
	b=g4LZdGfLNF3n9DhVT7UOjAjXpwf3A/VZEbE3PPGwIpc1oga05ieQeqDRYejKF0Rj/MMFq7
	WLEqCR7XxGkGcnPKvDWq0hGPvEwYorSqhB4c4TajItXqlXYQcf8otPBD2DqtgtoWOwYET/
	gRbXXuPzh6BOq/OeksQVoaSTKuX06Cg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761248217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GAR+zcyIiLP0EmlRcHQPsRsm2ZVMdnZLABW6LHegPGk=;
	b=YYr/t9f88DnfRGtalD5RRA3EJOwyBFx2tqF4AsdZj2aulW97W4kocfQxs8R+UFqKUQFgxK
	xOIwzVhEuE+Bs/SPO/21gWS4GzYciF1a9N/18FHLBpd0VNi+zxRtq0sYa/0dns5B4MWzaU
	a7dh0ggzzpPG8UUbwMpNevka400Js0s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-WlzipXl5OPijr0uBB3KBJA-1; Thu, 23 Oct 2025 15:36:56 -0400
X-MC-Unique: WlzipXl5OPijr0uBB3KBJA-1
X-Mimecast-MFC-AGG-ID: WlzipXl5OPijr0uBB3KBJA_1761248215
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42814749a6fso619568f8f.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761248215; x=1761853015;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GAR+zcyIiLP0EmlRcHQPsRsm2ZVMdnZLABW6LHegPGk=;
        b=gnNpK436eS2U+K5zH1trl9jyM/bppJhJMWAA0LESU4Mw9L/8mBJuSYZTsqtT+x1Dqk
         aRQyuCMh8Gun3vCu8e0B3z/V0KYhDSvynIWs46TrQMSYdW9Hm03iJMZ8vS5IqGk/XHzj
         GOBeeMgpWocUgKKP777wn6A0hhwYvL8804syNwRC7gCgmNDZaH6KNtvGUk857xc+X84L
         Ph3NSjlq6fM58Cf0DBS0hcL+TdrADmV5D9OYQ5RMv8ANwuhvGmQ3OMFy+hKD+eDG2YXM
         WNwjCc7JiOxTisRfRKFtNABP3xfDcmdJXfTgCpMl9XmOTHVWeYImYfuAq64KS2nSfYuc
         PGGA==
X-Forwarded-Encrypted: i=1; AJvYcCXIdP0Haw8Fg3H2aKoLRC1mPxAy9+qbdY9wH8rmzKiW0pDB/GBX+8buz+aRjeKUu1yL7Kdz3Qo13g==@kvack.org
X-Gm-Message-State: AOJu0Yzys2Vm0ONKdoelXH+z2MrMXfis297Z0mtATWQ7Cd+CERp4vTu2
	TWn8bkvCSorfhC37Ub3xOpW6DrDHJ0ySGdJw36y+yCMgQ1jv/KM0NBSXqb7RNmWhLKGzY9xgY3E
	6QObRtvoEKG0ugZhWOFXXALDYBesy5kKTShBUfrUrnjnlnN2o5sedi/gbSJGZ
X-Gm-Gg: ASbGncvHVGcT/DhDTI31F+L2eD1J0vX/jce/z9v00GnbdX29tFFO0hp1VY7rBS4RlyD
	+AjPwCrade1WKGStASIzLL5SGPlohGsuSINYrS96+iiZSPkVZeZ7vNRIyWeHF6OzpSJHnuZGX1b
	bE1IPIWMwViGT6GvmSnMWaNhtt1hqvc8qH0M4sEdkF6DRoaa2ayNzi5eKnwEzeAeGVdpP4Z0PxC
	6s5I/vUPU4WN5hnLwxZwlXT8XenYKPSpQF+oeRcX/jaV7eFBawbHH0Q5BdxGDHhw4YiYLjFhPlO
	xFEUeTdkTBgRV1w1KjPqpvVgwDaG0FmOzEtKAlhcmBwaiDvZtD+L0ghFEb2MuXhEZM1V2wo2AHW
	OX4765aALZHwWwLQJeszZlke4YYI2H8TivJXMp56vxego6IbpxOsz6kNzXwWKWswb3JiLI1oqX3
	iikkNA1cjxq/5FnfvjkXvQka8J744=
X-Received: by 2002:a05:6000:2910:b0:426:d60f:746f with SMTP id ffacd0b85a97d-42704d94458mr15755889f8f.30.1761248214806;
        Thu, 23 Oct 2025 12:36:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLONoaoN3j9k7k2WPBjhOeKfFc12IEn3iCcAu7lFYqr51oTxzPTHNLcPx+/xVbrYtjrgs6YQ==
X-Received: by 2002:a05:6000:2910:b0:426:d60f:746f with SMTP id ffacd0b85a97d-42704d94458mr15755849f8f.30.1761248214388;
        Thu, 23 Oct 2025 12:36:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898ecadbsm5715926f8f.45.2025.10.23.12.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 12:36:52 -0700 (PDT)
Message-ID: <60c55686-87dd-46d0-884e-80f7d423663b@redhat.com>
Date: Thu, 23 Oct 2025 21:36:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/13] powerpc/mm: implement arch_flush_lazy_mmu_mode()
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
 <20251015082727.2395128-4-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015082727.2395128-4-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 614m66ko4CrRgAtw6NGf5CyslQfeyh_glYhen-19si0_1761248215
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j9bpbntmnccy6ko7o9r48zbmarttkr93
X-Rspamd-Queue-Id: 6D4A6C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761248218-838931
X-HE-Meta: U2FsdGVkX18BN+dwXDH1Pi2IpWqG6jbQ+bj6im/h1zXRS6orNle/hdE5oFGmFzPspPJA6QY/w7VQr/xRiFKEHb3w9iQ4WgP2pdt+Buh3C5Ff2iRf4PX9V43vFFiwx6rCSu4sfGq/K8jaBdt2FiAyDrMsEPOeLUHQWMfzTFEQc7Ky95VQauUfKHKTHeJiNi4zLJyML2xUtNxlMuofm7RtYRhyDVKKJ2lYq5+kpu5Y2lg4YjvhamN1keOFfA4PXKXVYcI8MiNx1zibJgsrV4MqqVLyEqpKdvLqwgxO+MSpTtwvLfoATYgZQPizSOdkKfLUYayCDPoktt28Q11ifw6s6cnnX6vu9th7dFPaVqZwKJnl4XS/Wpk02oUuEALrGQK1Z7dPNTB9e/G09POOWRl7qWPbMFhyUN40lT5SUS8AObHNJKu08MSQM4vPorjY8OOF595iztLw80ZCYkQDSKq8Iibt+CmNj/reXCt+ExxjJAeQfFiwLvUKF6Y7tDOsSojlENMygXHgD5pzJW66wi2jnOWSlsBpkoTlH4jHi1nIAIbzcEG5s24nnDQVj+v816V9/4fouk5uJAdEgR64Be1eVe9xacpruKuUzxprrwp6hQn0yIpkr122Hjuw8tFsDxHU+F1qw9AE5cwyh52vRNmooMpJRGCZc+gFMBpUxObDCAh2w8J1KR2Qm8qiu7Cp0IcNaGmEv3LUjMql4noXzAORbKZAE5w8Qqyvzx5lMKRjs+4gfK2+1FjI5G0h2RFt85z2BtUqPzpv9jj9Eg+Xjen0RXESzkHgzIvSb3rdLCBuxDYF2RaBgpcgsRkQADLKMZtB9vrVWFVGAl6nVryxihNJKEPLqFR67ReGEiyXuBmsNh+6bYptDJ8Zqg/CNTSYUqlfLZrDMxQlD0QqGBoyQhxmi/Tc22ekpyETvxE9y98Q5BtPl9nT4hJH7/3202enX0EYbYQnvAFjJtjaMcw+CM5
 dSm+d5XZ
 +a2NTX1cVgYcj+yOvd8rQc6e1C2w0K/FmPbcNnp2EUxPEV/71TDm/RjIetgC0PxtF+PHzfOMMyth4oddTHc29nZe17AsttjeFIh7zQzDUtHs2yA2C8VW7xB49dbWEd9dwevCJW3QUfPxiVN8jB19XEbwpr0A4EhTosAaqdPi8gO2VfoOqB7i1+nt1pgNV0GpSxkk5lOT6ENLHy05/DaLRQzJTc0DZoUQI/CX5Kw5e13NqJL+XRypDQz9TA3fBPLomT923wgnK9FlSwC5+zUTLnk+ON6oS7IwBLLZo4dqtkM3s1pbH6FtJ1xQjUPm0aRRyVjzqENeXBAr2WqEnIDMblyUdo0CGAvCrXBMEJR/se8yEnkpTezaknqADsC6bJQ8TOc5T+yI8hfeMThKypRn9drUeo5n4qoTjHYie7fHoRKcUgnAhTFiSt8YWTcj3AhqTsy1oezZZmUuEZzqtNRtenKKETtrMOyUnyoacVBW8J+N0C8b38Y9FkcZ+ZvSSPuOpeC5+OUoBp5iI9cO/9aO9KFn5Nw==
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
>   .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> index 146287d9580f..7704dbe8e88d 100644
> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> @@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
>   	batch->active = 1;
>   }
>   
> +static inline void arch_flush_lazy_mmu_mode(void)
> +{
> +	struct ppc64_tlb_batch *batch;
> +
> +	batch = this_cpu_ptr(&ppc64_tlb_batch);

The downside is the double this_cpu_ptr() now on the 
arch_leave_lazy_mmu_mode() path.

You could just have a helper function that is called by either or just 
... leave arch_leave_lazy_mmu_mode() alone and just replicate the two 
statements here in arch_flush_lazy_mmu_mode().

I would do just that :)

-- 
Cheers

David / dhildenb


