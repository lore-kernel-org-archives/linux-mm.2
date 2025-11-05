Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A38CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 03:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DAC08E0009; Tue,  4 Nov 2025 22:42:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764148E0002; Tue,  4 Nov 2025 22:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604498E0009; Tue,  4 Nov 2025 22:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A84A8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 22:42:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D502485E00
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:41:59 +0000 (UTC)
X-FDA: 84075154758.02.E8FCEAE
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0391E180002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:41:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dzergMpN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762314118; a=rsa-sha256;
	cv=none;
	b=hVxzECIuCC3eWM3IghBuQd8qlba/asvsDg4VMX8puerbH+GsyCsAe5MEkYm8/O5PoeDO0F
	1/BpKBNfYTXNdyIXbjj8lMSJziLYIPdNZtKZ6sWD2xiePwWfQOvArmbvuM9ceTlBd1L+Et
	4re4hJS0fLD9LdrQedfW2LuRLvHSpdw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dzergMpN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762314118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PpcYW9rXkka09Jy11m9xJQRt/n8jdZMdqOTeKYVeZk=;
	b=M9n/K+vEqgmDGdQnOu8cYgb0bNBWnCFwFLTwC6BkMqbN3CPeeDX9TH7LkMUi4tbpkGqr/U
	jnDMMqVOzpJCxuScNOmrAJuJ7+oBwV95c0mETSrcvjSkE/8R1ONcgIzVorkk/PcppPtyGi
	PIHAZNTsgHrBYUUDFPrKgp5yTYO0dMU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2952048eb88so68096615ad.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 19:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762314117; x=1762918917; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9PpcYW9rXkka09Jy11m9xJQRt/n8jdZMdqOTeKYVeZk=;
        b=dzergMpNMC0s8mqXHPnGiOHqfa5v/eC7JswCaCyiUJPXuzJdQteB9DeJH4X4bmp7xK
         +T37ZMHjmo5IfhErb2VS3oPvNgyVELDMRviZRSqXXWaxFRnweKYgo7Yn14Ml7vGs/IX/
         IFw64PwUOe22GnNnCrEM+IGmNUePpIgMLfCc63RYn6+D1L1k9lIb2jqvtrfX33x9fXr0
         oy0kZYmT0ny/+OUILePFvOJ04B9eNMMfj7Zg3TSHfFzsVOhIRB2Iv/pMiud9sg9mgnGh
         W5HFLf8RSzSMdNrCbqrtAsLa3JPOa2bY72jYaBhwdRBdz0WK85L/IZRTq9UHUquQ0gC/
         rDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762314117; x=1762918917;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9PpcYW9rXkka09Jy11m9xJQRt/n8jdZMdqOTeKYVeZk=;
        b=AzubmEE3et3DVa9mlhX2ippirXIufwRtqRbDJN2Iv7l/QQqcAbI2sQ6k5T2LuZxgTU
         Pa5cK4oQ7qHmO/JdH8xbI5mGH5WTqWYVFE1K3TYoLje4rHVaB4AlsoMrGVd37YFmNEfW
         1VycFh7WMzeT+BaRC4Qo8BlZyY2Hla02aXkmMvNrhQNdg9emBm/X9mwej/584Nmp+Yml
         PGEOxwvAsHiKxcqBscoyeH/R3OvCzBTy+Enx9eImo8UnqyE2RE57DriQXv/8wxvRUhDp
         iRbT4HKvJo/Z5o69KCJmtLHrRuqK4a8flcyL/yyJa4G4La1zJoPIht+IU/f5HkFJszNc
         p2/g==
X-Forwarded-Encrypted: i=1; AJvYcCUzU5G+btuH1T5Oeauac3bULzwxXuN19z/XoRdC6hKrYbUvx5L+nDQKKBacUNvCsOp1c+/5OlKAPg==@kvack.org
X-Gm-Message-State: AOJu0Ywhw0ek1cR0y41TSnEXbsu4+ch02B1oKzxbYHewbXiRgKyFnSGE
	3T8ljRTG/j+2PaSbOgUrWKrCyZIE4gTydaeI+fNWWxNANHpjFd55SPZ8
X-Gm-Gg: ASbGnctMGK+tOjFNuBAPR8HpyrWCWfd638kdmXGzCH++SbomIOck9Lc1J0dXsbdYUrT
	ulVlKQxgVTmZSYDFynYEYaeUSy3QsNacvhRNodZA5RB+zyIhfOukVHPhh/FuLDO6o4c2M+n3vZs
	Xl8wHwFtO0HO9vYO1TybacGr4iJb+cQj87yeNCNfhZGhVHWcxhtdSxD4j9GvV2yDCxp1WTSdnKi
	0Wzhm9N1rF70ZXIT9+TbacXIrX6ZNfAJc9O8yErRjoyk4BP4qdUa4WgaWfkLqoDVxjWhMkDlb+B
	XnXKNsuZ6hMoBd3c27/RYmm73uAFl1Bj4fQYSLNJUHNCdP7HJGcq1vHD1wY6bAKmUOHZuVekvVW
	fVvyaGc5OiINldD0OaVj//+yQo9wH2wL4TViH6d0GHFYA8AqU6XONvqPLprZ2nduXINBLbQ==
X-Google-Smtp-Source: AGHT+IHU+u4c4m70sp/Km2qphWV2GETQaiqBJlBLQ9oH8KuDbSRxjLHzXNgoB+GOOUcEEs7QOw2HMQ==
X-Received: by 2002:a17:903:944:b0:295:7f1d:b02d with SMTP id d9443c01a7336-2962ad3340fmr26429125ad.22.1762314116721;
        Tue, 04 Nov 2025 19:41:56 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601a61418sm43663725ad.96.2025.11.04.19.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 19:41:56 -0800 (PST)
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
In-Reply-To: <20251029100909.3381140-4-kevin.brodsky@arm.com>
Date: Wed, 05 Nov 2025 08:45:06 +0530
Message-ID: <87pl9x41c5.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-4-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0391E180002
X-Stat-Signature: 5yn63eesdu7jnjpaizqgadr13edy6gxx
X-HE-Tag: 1762314117-893261
X-HE-Meta: U2FsdGVkX1/5uGp+sMacMyP1G6LIrFdafOlwxtzMA4THS9gftIIT0Ay/WYyFsnyGAJ2sSeKyakl/9svAWwa3etKD97w2SRr4CL50d4YwaK7Wr2QezbO6DA9TZpMuqCs4r7wpvzZUyJaFttsjh19IC5A2x0N/Rkr8EpQkCQbf+V7mfXgMZ6dSMeaYmQ3naQ9mtXqqYZ40VWhdOSvzMh+QHLsr+RDaWGvfuOxWhA1rYhHaG3JkwIWHKAjZMG8eR/Z9qYY0cWtJ4fBbqNbyLDVYl1W6Txje6cHIy6nkb1M3uQNUVMeTEaBhwnRJAsZkGtTxddSx8xGnmkQc50b0zAlctw25a+YiHbKEQ/3fRTGhecXlS8GTUs12o1r6f1fn0c0RHpye07euxV4J79aFoIvBYHIa/3uPDVGJjGo8qr49exTmrh5EpPH/4RcLp3xT6NBWjEp37HO7Cg/bRysiwRXdUZeFnWIHBq9ygqDCJjGS8A4+61EpFLfH4s5wutXdJ1mukslFiPYnEfICCQ4w4S9Lmnjy1kEVi/KOaI5L5DRoYWy33aY9hkatwVd7sCWliYOsGiY67p23Q5Y+BnKJeZNA+yh+/8ndPG21qvr7a/OvZmSHawWMdXBbo4IxcFVu+ULSCsOri1Dz+/iVOXldWS5mz6KKwDTmufoPXJ6xsH98+SPp0dM80J4d8w4b/idMtADANoa1Dry0KoqqRZuRIcBhyn5vz/XbPCLfAlZhjvg1Hv5aiTvWueFcXoU2f7QariG3fppMIyoI+2BF6i9DWzS5K9scINd5LElZswMzlof3MRwi+2aPAbBOhXAXXQ6yZDwzwg6lPrTgal289lSDsY7cRjRPi1ZAb/kFZsMVy1A1E8Akx0z8nDvfFibmvNl8kFPt1nks1qV7y0iPpaF911C/faaOEth0eGwySfAm5xCl3W7W8COpKkXPHHTT27eU8vVrbAZbNSAdEt6DN+WXyEl
 FtQyGFer
 VKimv4+9gJrQY/lJYqnZh3Eguk6RMfGd7mS4cUddA3DrMIcIg7o85iJPHu1Bz7Fzp4f5nWnnc8hWS17+FREgOpTc/TqHlwL5f9GsNddCQhABw/POJwkhp8y5XG+93ytxfwSQxDYKsEf6Rtig8k0sn3DRf7q+rQMDYuia6YtWFnIlWqIVjZf7NqaFE5YJ7T+RabSVRH4IcwKCMr0sVIDPgQeoveszgsCxTdyQ3I5ykEM56u0/gEY2yt/YXd704z6RBz9xfeK18/fwuw7eXFY8LBhSWObSIL5F7AlIAIxn5Cq2/r4cx00IJmikZFod7yVshDXkB2z1+95/wFN3lU2y6Emv0X1HxwxBHFJI2+zMW6KgCJ3TUALzKu8DPZ4FoYPU9H6NR5+3K1hqzpbn/cbH21bI0tfclRcQRrVU89VlGHYpGULCjJaLGqW5eprnswE2OZH4Cvo3q19suxjx6FWE6ho9j9pwHaMJ9om4pparRFPLQC9MfeqAxsZTBiNI93zMyqdc2Hmnb992qh/OiMx/5sumzsld01MIPPF8pLUbFhQDITFofsW3RKqaZ3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin Brodsky <kevin.brodsky@arm.com> writes:

> Upcoming changes to the lazy_mmu API will cause
> arch_flush_lazy_mmu_mode() to be called when leaving a nested
> lazy_mmu section.
>
> Move the relevant logic from arch_leave_lazy_mmu_mode() to
> arch_flush_lazy_mmu_mode() and have the former call the latter.
>
> Note: the additional this_cpu_ptr() on the
> arch_leave_lazy_mmu_mode() path will be removed in a subsequent
> patch.
>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> index 146287d9580f..7704dbe8e88d 100644
> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> @@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
>  	batch->active = 1;
>  }
>  
> +static inline void arch_flush_lazy_mmu_mode(void)
> +{
> +	struct ppc64_tlb_batch *batch;
> +
> +	batch = this_cpu_ptr(&ppc64_tlb_batch);
> +
> +	if (batch->index)
> +		__flush_tlb_pending(batch);
> +}
> +

This looks a bit scary since arch_flush_lazy_mmu_mode() is getting
called from several of the places in later patches(). 

Although I think arch_flush_lazy_mmu_mode() will only always be called
in nested lazy mmu case right?

Do you think we can add a VM_BUG_ON(radix_enabled()); in above to make
sure the above never gets called in radix_enabled() case. 

I am still going over the patch series, but while reviewing this I
wanted to take your opinion.

Ohh wait.. There is no way of knowing the return value from
arch_enter_lazy_mmu_mode().. I think you might need a similar check to
return from arch_flush_lazy_mmu_mode() too, if radix_enabled() is true.


-ritesh


>  static inline void arch_leave_lazy_mmu_mode(void)
>  {
>  	struct ppc64_tlb_batch *batch;
> @@ -49,14 +59,11 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  		return;
>  	batch = this_cpu_ptr(&ppc64_tlb_batch);
>  
> -	if (batch->index)
> -		__flush_tlb_pending(batch);
> +	arch_flush_lazy_mmu_mode();
>  	batch->active = 0;
>  	preempt_enable();
>  }
>  
> -#define arch_flush_lazy_mmu_mode()      do {} while (0)
> -
>  extern void hash__tlbiel_all(unsigned int action);
>  
>  extern void flush_hash_page(unsigned long vpn, real_pte_t pte, int psize,
> -- 
> 2.47.0

