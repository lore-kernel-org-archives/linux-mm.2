Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B77CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 11:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA448E000F; Fri,  7 Nov 2025 06:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B2A8E0002; Fri,  7 Nov 2025 06:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2496F8E000F; Fri,  7 Nov 2025 06:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4D28E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:45:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A09A3C0459
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:45:19 +0000 (UTC)
X-FDA: 84083630358.12.1ED0D0B
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id E796F2000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:45:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FZap4wm3;
	spf=pass (imf13.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762515918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3UolEFy3bRdP252sm4YQ2agYywAUHuWFJXJIEy7jek=;
	b=lgYsNg8fpXg0OdjgMQo50TrIKbGGJzDs5CIx8P4z0UVIfldZi6+s7chi5Yjc92BPAqYJrs
	Uy0cJzBp6V2igVxWyGoJiRaOptX+l/nRasKEvFqLjZCm7z3Hx7NDsqXbks5FbZtu7aWyK4
	Kkz6MX+FqD6mU0iOw/jij/Axpm0MSro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762515918; a=rsa-sha256;
	cv=none;
	b=N6m2a653ExgMs19w/5g9FhbxbFGYH7ZqBpMe8gZhcYjmsff2ic5dUn+MF2j6BwJcBlVRGo
	xlNAnjslnnCdss1LunMLSawSScIlQ3fspNdGGpDmJ7Agtb7YpvBjrr7xJry23fMxF3htYe
	dr7fLJPAhszHQJ8jdiqhwzIRZK3ZrM4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FZap4wm3;
	spf=pass (imf13.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7aa9be9f03aso606932b3a.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 03:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762515917; x=1763120717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3UolEFy3bRdP252sm4YQ2agYywAUHuWFJXJIEy7jek=;
        b=FZap4wm3nfjYOBV7pYFsleSy13YIaoQzdXGmQdZ6iP4IOeKwBsXZJW9qrg78tvbZEV
         42IfN38aMOO+VztbqQMrowd4BGdQQ6NafmDfUYGu8ekWoCbuJ9ANNpT2RKsHB5y25n6k
         dDcA4hkHYeihQ7SQWi3JGzrn9zvErDssv1f6frsn4SyujKBkd1pvlzCC+9but7b0Myr6
         eQcZkFe0jo8j9upOCQOApc4ACQF4aLezgFu89tT7nzJ23/Y6C9kA4iNEY99mJrclYA7f
         chwdl4VbGGhl3qL6PngVtRlqdDImD8rINktlvXPU+hk7wAFvSVJxKqtTsb0ZL8iRhjm5
         rltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762515917; x=1763120717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P3UolEFy3bRdP252sm4YQ2agYywAUHuWFJXJIEy7jek=;
        b=Iq+wA9Ur4JCX7G4JnfWeJFSbTW6vdMpCMLBzMGBBNEPTWOkaxmqWDNTlrvKDi7/pCB
         nczOUNror2YM29lqXMjBch3uOZTDuj0+xclZalDhX1h/ZQbIu5jD3Ipqd2fYttq4l2nC
         QmiOZTy/cyYcX7i+0EzKCwfxheKC+CQBn0skcpez/1yJRChcNoyMSVYXS68bL0LujeNa
         UOxzEp0xmG9IDxUFdQA0IBjZUL1J9GtAA4fSf/Og/RSTgqINeZM4Ng26Sm+dRXQ8eQ4v
         vDCAX+9PItXpWwNzCbe1tzfrj/aQNVImBA1nMiCGSlHdSTSH89nHUUELkFPs+SspFLXr
         fpOw==
X-Forwarded-Encrypted: i=1; AJvYcCUoEE+o3baXiSlbbUERwryfXIFtGVg2n3tqVi3GbC2OeYfjJHlBreNzDQ3LeoSLPNFDu7CIxqEKUg==@kvack.org
X-Gm-Message-State: AOJu0YyQC/X9qmXmDDK7iBQLqaHKEmuAq/NsdUGLzAl6kwFj/66jlmK8
	NWcGdd9aZhiIKjGfeawhmEu/vv99sc6ODcKl0rAazTDNhuNqc9Lv0EIn
X-Gm-Gg: ASbGncuuzFrXA7nbe3h8MXxE13MU4ADbc3u3rNxSP6zE5fo5kKVaW5nDHZNYvHxIE7r
	wTP0+WkIpykdkBgObIb+TStyzy3+QlWuETEfJRU58YEeSU+ibbm+ej73apNVtyZFNqD4Cu9ZD73
	qTpskrwb0FC8++H7icGctJpN2WAAHMsVUXw0YPCqR2TJpv3IbPhG5S0HF71fIkTvdBXugDiZqag
	JVFkI0DZ3atjOimgHID58rdT8/1shYO+3SCOSKysA+hFESvYTnr/G9C+qNajDsblOyRRXmZv6WQ
	Lp7QGS4SGztRTQAmBjrIPbqUVMbuWXM9PTOP8Mcs04CQ2iAM3qMDsqnfJmmC6PM97SPf4+i736v
	iFDeulUrasbmyV26pVkWCmNiKXQUCZuVeriNwTi+QxeL0D9R4m5VpAJl5qYKMYENPPmadzaGsum
	TjldVu
X-Google-Smtp-Source: AGHT+IEgK3+y79M6QAxgxitqK9nN+XnGR2GDAi2/FrE6+S2IrZU3wlJefPhdXptP4GRU9s4WXBb9ew==
X-Received: by 2002:a17:90b:35cf:b0:340:e8e9:cc76 with SMTP id 98e67ed59e1d1-3434c4eca56mr3374514a91.11.1762515916704;
        Fri, 07 Nov 2025 03:45:16 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([43.129.202.66])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ca1e718asm2717145b3a.30.2025.11.07.03.45.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Nov 2025 03:45:16 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: chenhuacai@loongson.cn
Cc: akpm@linux-foundation.org,
	arnd@arndb.de,
	chenhuacai@kernel.org,
	jack@suse.cz,
	kevin.brodsky@arm.com,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	vishal.moola@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*() about HIGHMEM
Date: Fri,  7 Nov 2025 19:44:55 +0800
Message-ID: <20251107114455.59111-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251107095922.3106390-1-chenhuacai@loongson.cn>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E796F2000F
X-Stat-Signature: haxbiouucqbp8rkyr6ec5axzquq6c19p
X-Rspam-User: 
X-HE-Tag: 1762515917-315580
X-HE-Meta: U2FsdGVkX19o7ULD9P1KnQIi2CCVJ+3sMatyxuijufflddL6PQ24E/Tj04XlvPbd9phwvcIzfU/mefhR1g7s9dsZZpUsdQGYapDSfvBu4OMo1eZeiAI9SSMHXEVvwhA3pPzgbruUa6fvqv+0dAvIkIOIAJbN3OCZLlgLOGDASYzGiS+vkWYjBZb3dkCAbApJ208VoNDHPHKrMSm6Bnw5wUzmkFu0JNLY8gss6At0qRJfEE4GF5GzT2HjZyD/kDarPp0cUXNUOu8cstweTyWnn0+TeV0N2Scyy8ZiATicgRyF0VhqA1KFDteGFKySevNS0vkeBd4qPxCgWiEYEp/svMkf6A3xRUs6JN5b5Lc/o8xjFoWUU0VWBOQrr656rDPyYJd/SlKRV5cFn5mj8l2NMbdOlpQPhEslCRfeVC02Ync+b095WlWFSthsXunRuMygHz0juxYwZHngcY6SDAiaw9/EfOMNTc7umU8VvmqKN2zFXEG27Al7Ry014G2FWhj2mQen1/iV2pASbMbFSd1rvvJvzSGexAZdMRF6Mq7se2fs9AeFyRxlqM6r4OXa5WD4xKGcYMsMAaGLsrDXneiZ3TsmV2r5dhfU1sMijuDWrkXJz0VtCdxivwG/V6rR7DMboI1UvXnA3jbgClFDp1tNv+7+LWBUzEuF+AH3Q9lN8BL0kxLd6jzjVzUZvndz2htSeGX4TEYCr14fW3/OfYYqRT8V/n4snZWzABdjtY8kEG6ZkGyG0LAbZ0Ig9gB//FmEi7qouJwJNvkTaiq1336S15WQ26+O+8A7viyB1Q5v44NhGhNfzPRGTrtCLWLEzEV3vs7QXohMqcAXGIVUVDCGdCBFJ43odtpLwY5a0tJqJ4WX4BgEIws7mdAdEdiP7xaMqsgeSAwZhlhlJ6cCfgdLBh+mfXiKfwmWl/RswyxmFwYv+sriFCjkyo6zQPMJRSabgiXRsnAUbRaWPhkbq00
 9Iut95PN
 +AYVYM0HEEL+VucEZskrrkXjH5e7oeUSL9i1HISUxZLYWsztDia1RP/RoaPvOd1tUw13OHzHl8iNlSgpNjaciuX6JFz5K2KJhoJbnB07LHSR6BLKEXwTB6TiHfhdBtIlEuvfZSYD5HxRiEPIpUb567/tPCnUDxDAydD+JSvA8aeFkh0N7Q7lBe2JESlMRmSHp70ZmK8kcCMQI4dt91baialu9jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Fri,  7 Nov 2025 17:59:22 +0800, Huacai Chen wrote:
> __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> as follows:
> 
>  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> 
> There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> explicitly.

Nice cleanup!

> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> Resend because the lines begin with # was eaten by git.
> 
>  include/asm-generic/pgalloc.h | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
> index 3c8ec3bfea44..706e87b43b19 100644
> --- a/include/asm-generic/pgalloc.h
> +++ b/include/asm-generic/pgalloc.h
> @@ -18,8 +18,7 @@
>   */
>  static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
>  {
> -	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
> -			~__GFP_HIGHMEM, 0);
> +	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);

I looked into the history and it seems you are right. This defensive pattern
was likely introduced by Vishal Moola in commit c787ae5[1].

After this cleanup, would it make sense to add a BUILD_BUG_ON() somewhere
to check that __GFP_HIGHMEM is not present in GFP_PGTABLE_KERNEL and
GFP_PGTABLE_USER? This would prevent any future regression ;)

Just a thought ...

[1] https://github.com/torvalds/linux/commit/c787ae5b391496f4f63bc942c18eb9fdee05741f

Cheers,
Lance

>  
>  	if (!ptdesc)
>  		return NULL;
> @@ -172,7 +171,6 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, 0);
>  	if (!ptdesc)
> @@ -226,7 +224,6 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, 0);
>  	if (!ptdesc)
> @@ -270,7 +267,6 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, order);
>  	if (!ptdesc)

