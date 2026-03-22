Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78AC8FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 14:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42E66B00AA; Sun, 22 Mar 2026 10:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3956B00AB; Sun, 22 Mar 2026 10:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9099D6B00AC; Sun, 22 Mar 2026 10:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC1B6B00AA
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:40:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 335FC1E5AB
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:40:37 +0000 (UTC)
X-FDA: 84573960114.11.E398DCB
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46CB1C0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:40:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eBt7PEsu;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774190435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/IWr5vfvomOdGiQWFAG7XW5alVFwR3rmlBztzuDjME=;
	b=jpLHi0RrwvDDGbPBOuDiuAbBpRgII75ovLXVxHAOehEzGem4DDyjq7QYrXeKkoRrfuTpHy
	utMYHSIyMbIO6he97+XoLg/fshkKt5EnzTvsYbGUW6GkYq61ZsizIUToHn23X14SV7MOb6
	fy10Z0IjbUzqcuSz04Rxo6sJbtOAhHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774190435; a=rsa-sha256;
	cv=none;
	b=ryj8rPg4DrFxAq75OaMrs+/tbVPGi/N0hXI3XEq/km8MNfZxhzUbeUgRMPmVPoNQBO54XB
	vHmxfnYl3S3xiCFSI3W7ENUYmihhH2X4utifyJiW3O+2snRWiLBOu7C3HId6lbouSIjcTD
	oUBi2YfuUKND7+13N3i+QsHAQtaj4Ic=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eBt7PEsu;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso18201205e9.3
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774190434; x=1774795234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/IWr5vfvomOdGiQWFAG7XW5alVFwR3rmlBztzuDjME=;
        b=eBt7PEsudfBOPnevY4pCZU1xif5pzbQCtkkadltDX5bWKIDH5vaVt0jd7ta1MNO9p+
         o3djJX+Ki1OGcTCzVW31ffleIr7UMZRWDj4Amc364Vd6bX7WHwIGeN3YkraeYPj3i8hH
         K/lBL01r13ZeZV4G1sQDKUPwxQQNYs3wuBNlfFy50HMiMFrOwipwKQLQhuZBPtkDpdQo
         BZv9l+L9wHHODeR7QbFHI6zwAa1NCwA+5onZSB7bjGcVs7YzVFWFtJUt0hKdFUds6yof
         9eHecBXwQD98CaK4ek1qs28oE6id09o6ssrO6j3U1vfc83c0YO69nVwaFp4eNzkcuu4l
         WTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774190434; x=1774795234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/IWr5vfvomOdGiQWFAG7XW5alVFwR3rmlBztzuDjME=;
        b=pl8Drn8K6JhLsec8U5Dke5EOOGGpqx80MHNS3Cysr4FXse47VmC8C7/q2uoa3arEAA
         RzwfOSQhXN6xbgkUfSSBXUQm89SO2fVcvWO9/RX+QwH2ytpMpp10d6iIf92l+5yUV9tX
         pBfjfoB/i9aRi2Py7m5Oqmq+OjkbSHKK8vLzr1Q/+yvRyPytWbpnk7rbcB1LpBrg7vRM
         g5IdizebN3q/Q8Gjo0uLm2zX/ISSjbLPDIFs2Aifphg+PtYyKJIH8Y0wtlhRtFgwjrwA
         4R9Yn5mYWHoLZNijXb+oa+ryT+kBBs5ZXsx0UFoK0SWH1Uu1IEDLduyQt9VKYXtWjjPH
         jFEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMFcMl/5dDcH4k7VqPX80QnSuMLMrfOdLmBs1AgN9geFcRLqbvpmI+Z9jKGQ9Bn1wBVE239IC+0A==@kvack.org
X-Gm-Message-State: AOJu0Yz8wys3gxodhIcd1iU1EozdVfU7wMVPDck/RXEBEy19p1r7lCw+
	WsypgjjbZ2FWEENFyoinHowCX3hFOyswDZ9s0bRerevl56l4TveEYaHd
X-Gm-Gg: ATEYQzworU916JkhB3D9MftNv2i7OYQJMJl1gnsqIFuGMBuRU3jNFYB6bmChpj9G+iZ
	lJWM8xj7YZCtA3JojwR/mm/05l01BGwjJ7zlJ2XjnYrtKidBED5JeBRMRKyihoyRoQs5GYgRDdv
	4/FnP9I+cMYWGHB4fXcX7mG253nAWJoRKEi8ie6zwB3c4xOQdfqVn9MeBN8/1RmBcp0x4gZC4mC
	9jlvvtbljGzmL+oAPdr9Skgs8R11inrBxYnoAEfY49vGVIogLi1wb/NOewfVB8li34/fJ0g38Z6
	e6Y/8Sa/t2g9bRLlZ43RnHsx0y3vBzRmBsPpRz6mhfL4ImC1VKZBjH37VmY6WAALRxRkcDT7zJ8
	pA1j5UOjUkBivtQ00XbGWhRQXKJiJSIaLTQda1Kvu3Yc/N1owlMB3hLoeGEQr+vcDADm8o95XSm
	2BTsUlB38OdyZehuPlJrAhk1E1387oeEhjmXmRdiCEtsQRsNDC1n9nGOB4tIoW1OfA
X-Received: by 2002:a05:600c:4aaa:b0:477:7af8:c8ad with SMTP id 5b1f17b1804b1-4870306720emr48296925e9.31.1774190433483;
        Sun, 22 Mar 2026 07:40:33 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe68ec05sm319287775e9.0.2026.03.22.07.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 07:40:33 -0700 (PDT)
Date: Sun, 22 Mar 2026 14:40:32 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Min-Hsun Chang <chmh0624@gmail.com>
Cc: arnd@arndb.de, msalter@redhat.com, akpm@linux-foundation.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-ID: <20260322144032.7353997c@pumpkin>
In-Reply-To: <20260307092119.20733-1-chmh0624@gmail.com>
References: <20260307092119.20733-1-chmh0624@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kapxkmw9xeuj9yyafmyeegxai71zbyau
X-Rspamd-Queue-Id: 46CB1C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1774190435-222885
X-HE-Meta: U2FsdGVkX1+swQ/9XhrwxtPU9rC3HwcnmFtL2TbCWCsscPEhRTNiWJskgIc5S2xd4sVf1y27KLlPR4hSeXIYxwTJ9tt9b6rCNOAEYXQiIWnDvCiXEuTTcc7oEnMjPgdqyMJviNA5LYuXfDIzPFQXrKY4rkIvyd9LRgxrwyb1FCodoVJcYOdIq8fOInNmC1UqGjyQuCm5TccxgQo0hByw3ikkxD6ljgP68OTqPqEP7bauWDiXdvkZN0O5/4vwH47nK47OZrMNVlJZkVNSy+e/Ge/eIDlwcW0Y0AJUxC/WsnuBmgyWlI9O6aXRTqwiT/9Q9r/EkGqzyOMPw6NsvJdtlFKI32JVQWIM5YGOZ6t1DAWjfy+gcA1mfDLGSCUtFj1WYF+s0sM3JG5/77CMAMsEBqFEXNy1yteQQO5bTVG6HQY7ynxt4P+BPvaFD6Ef2XuGx0UFVpInTF62Qy6Ype46EBaU0gCmsQnEe0m753SZLNLuN2Q71kX8p44RdLzRZhXsIsp1YIZpz9rqgDQQg10SoruMr86o7+b7UacAKAj+y4otC6dmo81YnQ6nUKR+vkPOS1LM3eFgkEu4pPh8xEcfnMsfAxSM7NupvUjDDQGA6NPRK6LzUO7pZo2FhqHAO4JOfCMHCFqFBd0ZOd7Ofo37dEcqDrypVqZ9w8zGfWVi9jNkGN+o3hDLp0F5Gn2KTi6UYEV6EStb6gXTYSez9zIQiKig8XopqfvlVsrc12ttiCSTgZsZ0x1X03S/2DymQsxqceVY7MdA5UZiBu0wG0qmhXF4V8Sg/vIg61VQyCHf/0LHIMsIxTWzMasKNibeSG2qHav7ZkGZOJ6Gaa1efHSMxN060B64navUPdkmJgAzAz/naqWcg/tug72LAhqlNSaRkHy5yvEFYDtO+hDIuvdQ2BybOIZwpby6rN/UI4l0GOX+FQyKznXQG21LhvxrEGkMibk8Pqy7mgbulEfEufm
 K9KcwgPK
 JSygl6Dokn+HWyWsyQDXMiX5Zi+vJTHSbys6v4DG3Wyk5cwm0PU9WSyYh5Y+jhJ4mMoItMtxFD5k664XQy+1aslhtPh97PcvbTzZaAm1H3iGhiozyfClKpK3b1coHjKK9/cEKNRTCv6NoLEknJadGxAR5sagd+lmxfJ3CeAJ3AFZ2BnNKmXz8OEe9hGIeC/Oo/4FLyEQ7/Meum7D7CT2nGxxbtJIVH2GBgPwyJFFa1+YrLu7kCsNKGX69KL5sSAqAmAJzjSgUwKOQRpLXtReW8EMKPL+InwEeBJDq4r0cyviNBK5e7MCZdGbj7cj1/olCL02rUQBHhbMWJ6I2Di+Sms6XQ1A6ySkCpdUl7CpaFvS70CNA0vD15UASKWIwJCnWcVXXNLzPoMtA697cfnE7+voPigjtN1K3/vm9QMpJHMaO4ln/bZS0Z2bZ++lvPEhbeNuJOMRHeTB3Wy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  7 Mar 2026 17:21:19 +0800
Min-Hsun Chang <chmh0624@gmail.com> wrote:

> The macro __set_fixmap_offset() uses a hardcoded identifier ________addr,
> which can lead to variable name shadowing if a caller happens to use the
> same name in its scope.
> 
> Following the pattern in commit 44238e82670e ("rcu: Replace ________p1 and
> _________p1 with __UNIQUE_ID(rcu)") and commit 589a9785ee3a ("min/max:
> remove sparse warnings when they're nested"), replace the hardcoded
> identifier with __UNIQUE_ID(addr).
> 
> Since __UNIQUE_ID() must be expanded once to remain consistent across
> declaration, assignment, and return within the statement expression,
> introduce a nested helper macro ___set_fixmap_offset.

I'm not sure that is really relevant here - nested use is probably
impossible.
It is almost certainly enough to prefix locals with an leading _
and an abbreviation of the macro name.

But see below. 


> 
> Signed-off-by: Min-Hsun Chang <chmh0624@gmail.com>
> ---
>  include/asm-generic/fixmap.h | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/include/asm-generic/fixmap.h b/include/asm-generic/fixmap.h
> index 29cab7947980..2d1e9a2c6a3b 100644
> --- a/include/asm-generic/fixmap.h
> +++ b/include/asm-generic/fixmap.h
> @@ -16,6 +16,7 @@
>  #define __ASM_GENERIC_FIXMAP_H
>  
>  #include <linux/bug.h>
> +#include <linux/compiler.h>
>  #include <linux/mm_types.h>
>  
>  #define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
> @@ -71,14 +72,17 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
>  #endif
>  
>  /* Return a pointer with offset calculated */
> -#define __set_fixmap_offset(idx, phys, flags)				\
> -({									\
> -	unsigned long ________addr;					\
> -	__set_fixmap(idx, phys, flags);					\
> -	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
> -	________addr;							\
> +#define ___set_fixmap_offset(idx, phys, flags, uniq)            \
> +({                                                              \
> +	unsigned long uniq;                                         \
> +	__set_fixmap(idx, phys, flags);                             \
> +	uniq = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));       \
> +	uniq;                                                       \

You don't need a variable to hold the result at all.

The real problem with this define is that both idx and phys are
expanded twice.
So you either need to copy those to locals or use a static inline
function - which should be ok here because the types are fixed.
(Assuming neither __set_fixmap() or fix_to_virt() are #defines
that modify their arguments.)

	David


>  })
>  
> +#define __set_fixmap_offset(idx, phys, flags)                   \
> +	___set_fixmap_offset(idx, phys, flags, __UNIQUE_ID(addr))
> +
>  #define set_fixmap_offset(idx, phys) \
>  	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL)
>  


