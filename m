Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74C6CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027628E000A; Wed,  5 Nov 2025 04:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A3E8E0005; Wed,  5 Nov 2025 04:58:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08B48E000A; Wed,  5 Nov 2025 04:58:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB5438E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:58:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F97AB7BA8
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:58:37 +0000 (UTC)
X-FDA: 84076103874.06.18DC925
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3EDAC0004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:58:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fYjhfVOS;
	spf=pass (imf28.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762336715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PiM5gwx7v9fuKjSNGU0XIbMsJHzNcD3t6sxDOvTigVo=;
	b=oh8mQlpgWffDoOQiQnVGN1hSE8ZEkA+DKO5SrTpNKZtllGDG9PQDYZ7klhV7A3TgfmqpyH
	CFVHc8Rsknuj4CUCxbMGnVNutm5VF5slkuH+mXJ75gH5c9Me1dyK7WwJ1Bxje11P6IDr4m
	tj5VPc7nLzFpoBRHuq1M/Iii+eNLDeo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762336715; a=rsa-sha256;
	cv=none;
	b=7MYPDPRcJb8c2o3Kp0iMlrLNDG/dQp75playMAvhCQd6GIGZ6y4V4z2GFZXeEqjck1EdjM
	wITBHulaVl+Vf/Tqu5i0J/4kppf3OvuzW4S0lvJPrALWC9Mb3W6rEtBX3yrNYDx4fcqAMN
	6xOKa3C2qrh/Lj8YalYjLutwaKCC8s8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fYjhfVOS;
	spf=pass (imf28.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-294fe7c2e69so61862495ad.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 01:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762336714; x=1762941514; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PiM5gwx7v9fuKjSNGU0XIbMsJHzNcD3t6sxDOvTigVo=;
        b=fYjhfVOSZ6y+Y2YpId0QDLdKORySpjrPYIRv9JTaa4Vb6XziLEgp1yXMwy7K59Yisv
         6mB9fLFIjjA1ZknDD4ic23We5LhWJuqCuaB9BhuFY/p0Tqb3DIUkoFcHTW7KcV3UFl3y
         OqEch0X1IaMduWo3N8Jxhq11irbDLXXRQz6OWOtyNwX5Ep/zzUeWOYuLOVwk9oRCgPiH
         D203tW9+tNgyDrC0fuOvm+oYdhiFdq07Yx6ylhCsuTizon2+wkN5GQq3mgFgwfAysD3f
         TCI6hrRiwvzWiPWRyFWTfIbmOieE8a5MvwMMw6u9wMR7kvu4KPo+xqSIEYd9U5jKFTjs
         fv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762336714; x=1762941514;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PiM5gwx7v9fuKjSNGU0XIbMsJHzNcD3t6sxDOvTigVo=;
        b=BvpRpRGrkusb7oijzYwd/rbPIdQZf8CSdD9AjLNYjEuHttkl6/F12+Q4k8une9PIG4
         /tBBF3eVb1qkArCXknL5WL3YDyM/r72DOt9xNnHgRDv61wNStOACNWH68f+Lbxp3EzeU
         15KLXxLPm3bheJBQmHk1PXkE1BiZ49k5EcxMz26RFlSgXB3FBof92TvtqTSPe+vh1BZm
         aHKvCGNq6m8OAP5mJuImSY7Odu8W7FoFP60r9wl+8g58dgOhOV0xFZu6El0Tt0kiPWOE
         4Ih874Zk9/WSRmhIgLsfEuY5wzJFgBVhxpYdtquhknCyTYw1yLiGIadXUhH3AfADcmAM
         vSdA==
X-Forwarded-Encrypted: i=1; AJvYcCUkTp9L/99EAoigeCf9hfNxKEu6On6+azaq0fZr+xerH0QDNlDc0upF2nWboS/My8vjjj1Zwppx1w==@kvack.org
X-Gm-Message-State: AOJu0YyxHwMykc0XYtsCmogoa5bu9uYsWE36J3vI8dbGfi/SBof3PS67
	Q8isFiuenj2utygyLKX/+87xlL3yA2Y9ufNkZ6gve7icUlpdpfCG0FSn
X-Gm-Gg: ASbGncvbpwzno9OMn8OQjkaO6i4WNnPIXrqLZbCND9lQAefGGDUJd/CxpAyvlANihZP
	dW6RE97UVZu3QZFPusdmPIq7urFU/iN96HaOrbzuRR6Dxc+0klXJo9R6xfqrN96znNUHGP0ukDw
	4QXmaNGJ2CAOqEIkHIV+J6e7D8VnMQjj/70Kv2Wgc22KeqcogoWRHlqjJoBM1oGL0g1g4Kmgb3P
	U/6oTgPIYFc+JgDAldHr533LyeuWWG8fiI7Vlh57JB85sIopQnlFv3Sh/EBBw17ZEgmnL2HYRuL
	94egt9lOEbf/Xm/yudWKiZzD+ZsF63Kjv2m8iCNxKxqOCX9AT1ofTmF9x12dCM1nURhJLF0jg+0
	RhwAJfq9Oofk4byxoW0ntMKEHQdexQoCjCzDsxvy1Y2slL8lBIo7zSGT961JgUawupOMAyg==
X-Google-Smtp-Source: AGHT+IHbi+0zqKpbA9V2mHcqMUNAu2olVZcwJU6s62eDD+69tSv+JW/d6KHzoaPAbvo+C4JRz5nOFw==
X-Received: by 2002:a17:903:19ce:b0:246:7a43:3f66 with SMTP id d9443c01a7336-2962adb2b0fmr33595265ad.7.1762336714441;
        Wed, 05 Nov 2025 01:58:34 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601972ad1sm55039695ad.19.2025.11.05.01.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 01:58:33 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, 
	Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v4 03/12] powerpc/mm: implement arch_flush_lazy_mmu_mode()
In-Reply-To: <87pl9x41c5.ritesh.list@gmail.com>
Date: Wed, 05 Nov 2025 15:19:35 +0530
Message-ID: <87jz044xn4.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-4-kevin.brodsky@arm.com> <87pl9x41c5.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B3EDAC0004
X-Stat-Signature: 7mih1rjnyicgytjd8asyo3iridtbanot
X-HE-Tag: 1762336715-582116
X-HE-Meta: U2FsdGVkX19HKN0Z5cwItS2rUdztWi3K800H6oAQUiSTkO9bITIKCCydA5kQlfnRf9MZmmhhRs0Uq+5nFaWJuCWVwsywI4/HUpnH/zP/VTuId8Qa9nCVQiN3x2NMcGF7oFZM8wz8A7mXgPNko2Ro0gCs+DQj+crfvX6flohNVcH9ann597rUzSQipjTHhnzqILr1vc4DwCjJfx0dycVmj/NSlQ2ihKmjg4z+fFh0GZ++My728bKF6OOw0Zxou509/n2+uzBPP4FU3DJwL7aBVWdT/xtLf7+Hfi6eduyHHUmjD+IsR5DmkserVNfYLs754RLR8JDi8Rl+gRQxlhZlvInJaN8XJdHqBBpZjteivuIlJmfqypnMW9uErM40+zWyj7hBzI1H/Fazl+Wepr2ZCKtewz+NlRHIGZ/ecyRGJRLXRcim2XbSxnGLe0lbXrSZ35pUlX49nOoSDpJLm+65MULPeUrucx3qBnxidtpUN96H/MYf4e9lsBPzoyhk5n2GzJSopQy0EAREfllemIP7YHHybiqzE2zHCbotZgDnOTuvZ/oFcEGrXdVvHXTRGe22GjFjStq+2O4m2qAMfWWPsf9ptO0r+yFmLYOcx1XG9ti4EjaVDSERL0YjxCl1y6b09n2M353dUkiNmAT1wqtwqiR36oCXwp8SYVPLusP3uvoIUj8VQWUIGqiTmMV31fV43mhlbeJBEjQtlmrIsxizDCN0/bM/N7wt40StWrWNaEjtuC1+oM2EWzvWy8WjOuXGn6dMIghRZOWUiRD+yBidSGSv93iiJwhXQBbO7KFijLWCVzQTtnJQwG6mTDINWiZ6Q1z6gpXOUEkfB5tnkUk/IYW4CMWonFQBHtE4rhGnEdA9hPkdvXc6Ss5ev7hGM9qxn1V5971JE5O6GIgDHl//t5QfDc9YSbL9zXZ/NL+KZgGUE3E1pNT7knQZRTywSchGPRarfYcCIOz90LhPosj
 QZVtS88S
 rVi08HVmc/L5bkYqexxoig7hpFHj0EK0wb5lLWNW3+Bbu4dfVMOecLTlYaoPaQJC7oKHyYWIUU+Tqqpcor592mNO6LFmQR622yibTjuf6HJYyLFu71CJHd8X1ODiHxfr/TgPq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> Kevin Brodsky <kevin.brodsky@arm.com> writes:
>
>> Upcoming changes to the lazy_mmu API will cause
>> arch_flush_lazy_mmu_mode() to be called when leaving a nested
>> lazy_mmu section.
>>
>> Move the relevant logic from arch_leave_lazy_mmu_mode() to
>> arch_flush_lazy_mmu_mode() and have the former call the latter.
>>
>> Note: the additional this_cpu_ptr() on the
>> arch_leave_lazy_mmu_mode() path will be removed in a subsequent
>> patch.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 +++++++++++----
>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>> index 146287d9580f..7704dbe8e88d 100644
>> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>> @@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
>>  	batch->active = 1;
>>  }
>>  
>> +static inline void arch_flush_lazy_mmu_mode(void)
>> +{
>> +	struct ppc64_tlb_batch *batch;
>> +
>> +	batch = this_cpu_ptr(&ppc64_tlb_batch);
>> +
>> +	if (batch->index)
>> +		__flush_tlb_pending(batch);
>> +}
>> +
>
> This looks a bit scary since arch_flush_lazy_mmu_mode() is getting
> called from several of the places in later patches(). 
>
> Although I think arch_flush_lazy_mmu_mode() will only always be called
> in nested lazy mmu case right?
>
> Do you think we can add a VM_BUG_ON(radix_enabled()); in above to make
> sure the above never gets called in radix_enabled() case. 
>
> I am still going over the patch series, but while reviewing this I
> wanted to take your opinion.
>
> Ohh wait.. There is no way of knowing the return value from
> arch_enter_lazy_mmu_mode().. I think you might need a similar check to
> return from arch_flush_lazy_mmu_mode() too, if radix_enabled() is true.
>

Now that I have gone through this series, it seems plaussible that since
lazy mmu mode supports nesting, arch_flush_lazy_mmu_mode() can get
called while the lazy mmu is active due to nesting.. 

That means we should add the radix_enabled() check as I was talking in
above i.e. 

@@ -38,6 +38,9 @@ static inline void arch_flush_lazy_mmu_mode(void)
 {
        struct ppc64_tlb_batch *batch;

+       if (radix_enabled())
+               return;
+
        batch = this_cpu_ptr(&ppc64_tlb_batch);

        if (batch->index)

Correct? Although otherwise also I don't think it should be a problem
because batch->index is only valid during hash, but I still think we can
add above check so that we don't have to call this_cpu_ptr() to check
for batch->index whenever flush is being called.

-ritesh

