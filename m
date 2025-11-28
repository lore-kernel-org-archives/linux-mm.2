Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B80D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 10:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A2D6B0026; Fri, 28 Nov 2025 05:13:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4321F6B0027; Fri, 28 Nov 2025 05:13:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347806B0029; Fri, 28 Nov 2025 05:13:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2241C6B0026
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 05:13:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0F791A03CD
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:13:49 +0000 (UTC)
X-FDA: 84159604578.06.ADE2BD3
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0CE0180013
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:13:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hsFW/JJ6";
	spf=pass (imf06.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764324827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TF1TVmEV96HQsz0MmZJVIJp9RiSijpMUr1apSsU5F/E=;
	b=GQA7XZMTemwr3nUf/4PELVFEfKj+7Fl3Ij2TgW16m8uHoNvYuz/ZUb6NAhpmzmbCiXEfYc
	OrJPkz7nDc+OHSDbsVZWEkAcgd4Fgb3KT/D0JZBzCSmW1aQG30SQdLPvsCj1Zunu89HP/c
	IGwD+zOwxwTxyQVFSIwZ+HWm3EuLp5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764324827; a=rsa-sha256;
	cv=none;
	b=oEZqN6fAdHEz5GS6/w+J5RytwiBqm5GVdM2CtLP4tFksvJkuyc1Q0Rs3UZF8JWm6z/YfgU
	5tB9P1GF6tP9UY3lu2bg4p2e98QeLljVTSGMvR15kyQvNmRuBl2Z4OwsJ6eNaBLkOtzB6p
	mhMf2mnc992gD4f8IR//BoIuCntebhI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hsFW/JJ6";
	spf=pass (imf06.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29558061c68so21904215ad.0
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764324827; x=1764929627; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TF1TVmEV96HQsz0MmZJVIJp9RiSijpMUr1apSsU5F/E=;
        b=hsFW/JJ6MH76M82+/hUG0QnLPW31H2sc3UHzH4gJ9IhdpvgysJg2kJkYQSbGF/Q0GS
         hYohJO1G2F2DqwVBRVzeXHh6gTRFTwdLC8GV/hIOLrNNToeLuTEWMLYKWK5Qj8WSyKuu
         5i+G6zaUxuVZvMcCVVROp1gOZkm1ccjdG+dDIV23fJP2sokmhGH6J1PLcNUnGncCQqOG
         p4fJkaDYhQY4qD+VxRLQ6X3x92+HPhO2IpxOtSPmcOo2EIqx3md0jU3liEms2fRBio/A
         JT3rB4IfgK6c+Jpq+8CEutaqeSP58k5ZrzNOO4RBSmWQvWUxSoCX7CF6MzyM0BrB2vtX
         mNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764324827; x=1764929627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TF1TVmEV96HQsz0MmZJVIJp9RiSijpMUr1apSsU5F/E=;
        b=QpwUQj8B8yP8KUCjpDeUAqgA1zL/iJgiHNWKCCxlV4DimhSGx9NLwrhpWZKhb0XN4P
         DjeV14XkoWmmSqCj4SE/nyw2JqExIOK108BPYy4SquLLraDvgCfA2chXc4BMidYc6mIk
         SyPiZhdCnC0JPdul0gXgTMof2v3Kh/IUDD9q7RhR6qpxK98XjYmQst8J6gatXh+4COc4
         l5iPrqkSQa0mr8Xabnj/VgBFIYYer47t/Ltngg3f2ak0P4r7O0Jhbp+3q7lbiq0frOxS
         FXSIm068Sry6ySf604IuUaxjygsiNeyBy/r87ZOsgxuwLCY7rnKbYke7auh1DT+JSkHx
         k2Pg==
X-Forwarded-Encrypted: i=1; AJvYcCU+E5tgSeAKbeZibXLIjVu+1m1KLe26+cTtqxQwKFbZJ1SqlbC1Q5Cb2B+Bii5L6J/ymWtkrK/2OA==@kvack.org
X-Gm-Message-State: AOJu0YyPBxpNpK5dYP2bSMWq4M9pip/l8797Y6GT5sDkrJhw/2n0yHAU
	8xvq2RJcqrlshhqGQoudQfjUnDP36xMgTncYxFQ3tNZIDPfJfb1zPRBj
X-Gm-Gg: ASbGnctWsWzLTjcoqP5nP55yjtXZhe65izpcV2fGx2expRgs32zn50a6G4bHBqXZBeL
	oUxuEJKlk20SatAzJpwZ9utfw9C3R9WwpQsre2CtLgvJUJMZ5r7+cW2VeRvAe2fkhpsXkJvCjJo
	dwn3zGaSwfFANyKPEEfoepFAiQ43hnpDOPEkIzYL/pEnqFjst05DpBuTgh45DXzu7GPm/hPf5Md
	7GsZ/C+XVIWzhdlXdFi/eb5IV+sZ7aeAATXNIh3KzMwumXtxIzeqI46eyOyuxU51j0n7bSdmSAs
	i31/bLtW7vcOB/Diea8Wki2sHmbTrrdqiWdu+68FVPI4/vNkHd7DqTdF8zJ+x7PuAWZNGLXOdMG
	HAg9Crxomjs+HTEtBmvAZN/MfMUH7ZMBP3QQP3fRJrt+R+16hzoJXp8s/Gl/oK2HrQJvF/B9MAN
	1+vg==
X-Google-Smtp-Source: AGHT+IFfPZt6tf+2hnPx4fpBVD/lhnrTvIZnWVU86KRnNT0ZMPToT4zwqgBG/WyBvvA9f2XZf9zocA==
X-Received: by 2002:a17:903:947:b0:28e:a70f:e879 with SMTP id d9443c01a7336-29b6be8cb2dmr298158685ad.1.1764324826660;
        Fri, 28 Nov 2025 02:13:46 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce41afe1sm41236035ad.1.2025.11.28.02.13.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Nov 2025 02:13:46 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ankur.a.arora@oracle.com,
	boris.ostrovsky@oracle.com,
	bp@alien8.de,
	chleroy@kernel.org,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	konrad.wilk@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	luto@kernel.org,
	mingo@redhat.com,
	mjguzik@gmail.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	tglx@linutronix.de,
	willy@infradead.org,
	x86@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v9 2/7] mm: introduce clear_pages() and clear_user_pages()
Date: Fri, 28 Nov 2025 18:13:29 +0800
Message-ID: <20251128101329.86934-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <c9c75803-c8d3-4f9d-b726-d0aa19926b88@kernel.org>
References: <c9c75803-c8d3-4f9d-b726-d0aa19926b88@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E0CE0180013
X-Stat-Signature: bcd49n5xoi3mumwy484ma4sagunkqsjt
X-HE-Tag: 1764324827-260325
X-HE-Meta: U2FsdGVkX19CL4YjRfJy73EUBn/ARPFLNOhsh0ops37IESZ81a5352fOiIrTzBM2hyFUyXJXQKw6hFAoMj8Vxt3e6GcL6r2yRzYvHMDJYOjvITkm6tMfxk4cTq1F7jW+25lcFBfWGM+PkknwFwJE1uMFw92l4sseqYgRQF3DktvvW95wQFdTfGuj3qxtrns4qRU3pQzR0jMdDFjv8yOz+HOqzOcZ/BNquboJ1JoBSPxdxmggUSUBPvgrUpX/FLcTciXHugnsfTmULkpWlmsXUiLLjny8UcaS2cTvWEF6YQjBXh/wYWf2XcQpTQE4WGAivtAQdeHLiIvWcgWgmseg5HxcB8+EmLWuTTTh8h2GQlGIwv6dTHCqrlsLzOOSPX57N95JAw2BKTjsyfSip/b2aA5jnO9v9ahXZlLBZiHLIXh+IB/W40vThaYp2+CA/W90uhXG1t6utOuFHXYsvVpTPF//f7ELP4XrUiMbW97/WNSXQO6a8s3GDcI9bEhR6Bs6U4YknaiYj16NsH7RleGWVWiTJ6cJPodrVWfpNGJzhR7cCzXZerdb/T1G+IGoqXycnmn1r4ogAwEmXtSvLrrmV1JwlfBx1kWMzbzYEcgb+vSMAOpjZUZXX0dgVf6Qrl+qhhp6jQ5+/Bzm3250Lg+rX9wF1JxrRc1/PHpuDI4KplFCqz0EvhDBH5hRHo3Oz3FTclax7mKL1h+stTHGPiVCakHJK5u7J3AU3uz4uySqVzcXWjz1b/0LkPmo8u8x3Ck+tNIymnI/SO1jMBP3If2vTa7T6hS+RB7OlweYrcl9xoc8jRq9YK/2Jj+Xn3afQ4adoOuj+D8hKMmFcpGUmo98ktGbvGdO7E9RyYmC5IPRE856cs2Lh1KX3kgy+oLuj69UFE2tknA8EwFyUys5HtZQGWxCNFn9bwGkwSHpPw7ZSVXUXsV1tm58NjTeWNwk+3n30wMOL4itnjCwFWZBszu
 CETh4D1r
 REsjM35CJNY/TxufimwM/yohP+tKJHzyGWdUhsTKQg2P8MJoovi5b2ibm7vlml1XbaTOiVY9e2RUPq4T5l/7U9VIG7eWKQ4rijPpc6Z4CVsbKdZ48kwQyir756NicZKekyaitXTXIpatR3ixH+m8i4Dkh08gq5ZQz6SHdLp/ZE4rUlSl+ohwWjgQ+/HjodJxSZ/FUw3vffQ+ObQHo2v8RFwxWI3yEDyY356duLiie6dUxTtVuq2qIs+lR/3AYzs7QO7JkHf97izb03qdaxMLp0h11NeyoVt81DZIRnMelRBtHEQTiIUkvHjgoBDqegDgCU5VZGYDlB8wLB1U0RI6PqCa6askU7fqyPwE7I/HY6ILka6RwtF5lHcgYbGD2Xz9n6boilBdQXcJFNkZZgD74heNxqYk3//3AscRFoVHuiDaOEad5onuKzG1g+QcCMOFP7Tfx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Mon, 24 Nov 2025 11:26:56 +0100, David Hildenbrand (Red Hat) wrote:
> Replying here while I am already at it.
> 
> >> +#ifndef clear_pages
> >> +/**
> >> + * clear_pages() - clear a page range for kernel-internal use.
> >> + * @addr: start address
> >> + * @npages: number of pages
> >> + *
> >> + * Use clear_user_pages() instead when clearing a page range to be
> >> + * mapped to user space.
> >> + *
> >> + * Does absolutely no exception handling.
> >> + */
> >> +static inline void clear_pages(void *addr, unsigned int npages)
> >> +{
> >> +	do {
> >> +		clear_page(addr);
> >> +		addr += PAGE_SIZE;
> >> +	} while (--npages);
> > 
> > Why a 'do while' instead of a 'while' ?
> 
> More efficient when we know that npages > 0.
> 
> > 
> > Are you certain that this function will never ever be called with a nul
> > npages ?
> 
> That is the expectation here, yes. We should probably document that 
> expectation.
> 
> > 
> >> +}
> >> +#endif
> >> +
> >>    #ifndef clear_user_page
> >>    /**
> >>     * clear_user_page() - clear a page to be mapped to user space
> >> @@ -3901,6 +3921,27 @@ static inline void clear_user_page(void *addr, unsigned long vaddr, struct page
> >>    }
> >>    #endif
> >>    
> >> +/**
> >> + * clear_user_pages() - clear a page range to be mapped to user space
> >> + * @addr: start address
> >> + * @vaddr: start address of the user mapping
> >> + * @page: start page
> >> + * @npages: number of pages
> >> + *
> >> + * Assumes that the region (@addr, +@npages) has been validated
> >> + * already so this does no exception handling.
> >> + */
> >> +#ifdef clear_user_pages
> >> +void clear_user_pages(void *addr, unsigned long vaddr,
> >> +		struct page *page, unsigned int npages);
> > 
> > By doing this you forbid architectures to define it as a static inline,
> > is that wanted ?
> 
> Note that this is not the intention. The intention is to either use a 
> direct mapping to clear_pages(), or fallback to the variant in mm/util.c.
> 
> The architecture is currently never expected to provide clear_user_pages().
> 
> Wondering if we can make that cleaner.
> 
> I'm wondering if the dependency on highmem.h here in mm.h is rather the 
> problem.
> 
> How I hate this macro crap with arch overrides.
> 
> > 
> >> +#else
> >> +static inline void clear_user_pages(void *addr, unsigned long vaddr,
> >> +		struct page *page, unsigned int npages)
> >> +{
> >> +	clear_pages(addr, npages);
> >> +}
> >> +#endif
> >> +
> >>    #ifdef __HAVE_ARCH_GATE_AREA
> >>    extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
> >>    extern int in_gate_area_no_mm(unsigned long addr);
> >> diff --git a/mm/util.c b/mm/util.c
> >> index 8989d5767528..3c6cd44db1bd 100644
> >> --- a/mm/util.c
> >> +++ b/mm/util.c
> >> @@ -1344,3 +1344,16 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
> >>    }
> >>    EXPORT_SYMBOL(page_range_contiguous);
> >>    #endif
> >> +
> >> +#ifdef clear_user_page
> >> +void clear_user_pages(void *addr,
> > 
> > What happens if clear_user_page is defined but not clear_user_pages ? In
> > that case it seems like the definition in linux/mm.h will conflict.
> 
> The generic mm.h variant will not set clear_user_page() and consequently 
> we map directly to clear_pages().

Hmm, I suspect there might be a subtle issue with the build flow on SPARC ...

Inside include/linux/mm.h, the guard checks for clear_user_pages (plural).
Since SPARC doesn't define that, the header provides the static inline
fallback.

However, mm/util.c includes that header. And since SPARC does define
clear_user_page (singular), the .c file proceeds to compile the non-static
definition as well.

Wouldn't that result in the compiler seeing both a static inline and a
non-static definition in the same translation unit? It seems like this
would trigger a redefinition error ...

Thanks,
Lance

