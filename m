Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E91CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A966B0088; Thu, 21 May 2026 05:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222FF6B008A; Thu, 21 May 2026 05:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F816B008C; Thu, 21 May 2026 05:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 083736B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:30:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B6044055B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:30:35 +0000 (UTC)
X-FDA: 84790906830.25.38C8386
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84AA310000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:30:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CUvCsjqp;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779355833; a=rsa-sha256;
	cv=none;
	b=7J/BM3o7+52yhb6dzhwH8wms8qzEnKOPR5POeEEx8Spu+WsZ9+RD1k3sMnvYq6jBauyH3h
	HGaDAUgAgCm4CTpMrMseprml0gKfrDknm+FB80UB+2mZM07s7I2qDFydBDL3T4eyIQY0zF
	gOADGdgU0r0OEa4pv+H0JPt9jLUADIY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CUvCsjqp;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779355833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2x948EksUL7oS2hqJXHVyG8J9H43lWRd0Q/10yG6uQ=;
	b=Wm/WxjXrDV/oJlxBxqCzpfSS94f/2O6exbSFYGq/laCWrMLAF60BG0aTuZG7bVe3Gv26PW
	aTd/RkxW6DVPf3nsQfqPd265rSRxNda+xuRdGDGeHMsw0CJPWwQSnHF4+GkTJqxBpC3g6U
	V6jfBRsgbHeG5lTgdqjOTBDpytiXkL4=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49039a8851fso3637385e9.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 02:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779355832; x=1779960632; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2x948EksUL7oS2hqJXHVyG8J9H43lWRd0Q/10yG6uQ=;
        b=CUvCsjqpvYfRDCXZFTG6dqEHo459CRIqnlKHhdmknMd4xv8KdQ0JP7XHA8Iu3qXf+j
         uOwsuBLmtMaz/sDwvWw1tZl1oxR2EzkNfMWmr+U/KiD05J5T2xNp/5eNsvaSi+zDnr5C
         T41lcf51ZQnhSQvwGADIXLWDYqIsnSkZLX1eVmV/oKlRAodI0MMF0vX8IsmniysdEjQj
         ocVlwdFNGzItpLJfjfsfsNN8s0ThwFBRklfZhe/zGRpAcfeDZRMZQzo+UurGtU+lFzZA
         QmpTdkGeWOWnXZ/jahibujhkVchJWxptrfp6CJSM9ROj2dIkaPylaprqAOAWv4+psSkk
         sqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779355832; x=1779960632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p2x948EksUL7oS2hqJXHVyG8J9H43lWRd0Q/10yG6uQ=;
        b=ZTes8IktK3ANmeJxtfcUtZpmMwqbEgnluqY+5ZVBVpTwzGMaZb7WCMW6f82p5PwGQE
         Rh+sbj8ojF97b32giZqLN+SRyoTeju8Wk4Qk3X7BA1a/cpSSISlyoeQvYSU9ttaVu2cv
         4qqYloJ5kNd7avfcYNzzSciThiicH2hwnVRdtPOgy1c5/FA/452apEm/z9BlDf0oEw/R
         9CsfkJQDp4l65/pqCIz7KZtIvEsuuTN0HfKn2uet/uj2jvWKYiY0VqpbEcMenA3v2XHd
         +s9S6BMKp3PfTItBJ7PKlK24ve7S2XXWYwLurCuNNdj1pH5NPC6y/wyNUOnYJUX8CMzB
         TtSA==
X-Forwarded-Encrypted: i=1; AFNElJ+NNmMtTK35mrkWs8tXDJz7v4mgfYdgDuxUl/NYndyD+fNoRj3X0K0p4cvc5EtaWAcQHMGF/bo7vw==@kvack.org
X-Gm-Message-State: AOJu0Yzec7iMxVOQsgywNt2AWoi1gpAw9VRXXwx10eAdsqHhlYlolrVA
	6Zas1rKXt1Ef+eHQ0yHU0R7K1TYYxlbKnSE19szeU8s2BdvPCmoY32YX
X-Gm-Gg: Acq92OEpDeoj1CvX7xNYZuo/MeiEHejPSL1IRF/OvV7oT+5Da/Ol+MhEdYoi67Gm/D+
	6nb/AA4DuMBbHFzomGEjuFPtb/QNIDQ9rC60VRmFvxyX8QxpVvBscGzRtR8rOuvO+q3h38gtgPh
	P2RV6EN9nlPovOe6CO3J8qax0tG2V8vhD+mxe0CiBT3y3U/78ozWj/k4HzUIV3HjeW+05JFRhh2
	LHKaxcdgid5fzPLN4A16lozQAAWko6xvOiNmH9rNHPLflS+dUtJIL6zLiyAOFNcHKUaIzx6vWUj
	8ZVRToj9iaflm6YGtjFvTRT7bG7HsJz8z9pO+QVYnARc2NPuCUnSWbmyOcDkj/T+uEemONYtKLh
	Qe+1YoKSzIb24lwcdgdsRIgznM9wJhQm7l+X1S4WK7zjE4Gnj15CQsAsKTZcu2M7oJ0HrtKRV8i
	qnNY/jpWVCeK3dTHxb4pfHR4Mx/Ep3vlA/WfQVOHHRqL/bLVAwCuqsv8fm7XgzTtIj
X-Received: by 2002:a05:600c:3d96:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-49036024e9fmr30007635e9.5.1779355831775;
        Thu, 21 May 2026 02:30:31 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903caede9fsm14126955e9.14.2026.05.21.02.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 02:30:31 -0700 (PDT)
Date: Thu, 21 May 2026 10:30:29 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner
 <tglx@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook
 <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, Yury Norov
 <yury.norov@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
Message-ID: <20260521103029.561d5c02@pumpkin>
In-Reply-To: <20260521090655.160282-5-thorsten.blum@linux.dev>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
	<20260521090655.160282-5-thorsten.blum@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 84AA310000A
X-Rspamd-Server: rspam03
X-Stat-Signature: wdkjpah96c71xxozcteoahshmrp38mqb
X-HE-Tag: 1779355833-581534
X-HE-Meta: U2FsdGVkX19POwQSBaZAehiLxYfRRJO9X+4nNidOF8vHyGAZ81XL6fmAJyphtpv75uo/ufUsXWKQX2xkjMqo9zo8fuI6+Wdq5MamkaQ57ez5lhBdz/9w0VDMMEyjHeqcPJxmqI0mWJ77vQf0GOugh55sg1S7qbvpg8xSzff4qvY5JK5Dv5PB2M4IvE4PpmA2+MJJak5L/bDfwvD11qUMmmQ2RAYezyc2gzZtPzRZgYnj0RtlOnNZwRZrQaCJjD65PeSXq03ZmrzqveWno3F8C5uTh+BuPt1fW+Zyc2xXXXUkqO5naa3ryxclHDK+1kmSAB2n78QpyLc61m1y8vtVVDfAM3LkRegxsSLru5HG8ccQ9EBwiQp++4PSMQRPgMeaHVf/IPwo6JdpQnHHJVKzDb1HQ7p7nPHAH9HxxTqFZujSaoCAracezTBZs5DmTJId2uUsMw2ysa35pnBZ1u1feC6w+FPqqgMse/0DK/BHhmArmtFIIDScZkkng5wP53n4bQE4IheqFO6L88YEUnhfh/2HZgfevljnhRjLEI3MlSvl2QZdKJGMsVhmwlnpr/Lw34NPMJYrBEJG//3wj8IbZtdT2x1kGXDG4oY9yPsuT+3gm+W9f3J9+CvapFJe0qmUCz3gnCVbRfghj6GR5W4l15C/3vKQKQjFeb8SwRZ6pVZnAN0lCIY4nXdHX+TDEs90hCV64Z8iFKW2QMxTjpcK6WwUklwFNyIQaZp8C72vLscwVEz4rXft1EUy8xUV1Oc+M73YNZTKCnax6XCVWZKNCe6pSJKNYz/hFm0ct2+9aIerGwQujiEj6XKfxRUpgY7dgrLQuhe+eafmi5HUAk0OY/w06ueY2zbgYKpSPqyhpVQETpqm9HI9niQ8xPNvXGwHPzM7onW77CDrZ1wA7BLOulsL8llMxzd0wtZXMLV4uOjTJz8v3Vbc+A2D4eHq+YqyWZoCVPw94O25cq+L1hk
 el1nqoYR
 36V5O9kEA2HncCc5/8Jz5+XVtIj8PppbWBC3i2PifsmVaMPoMKDFzn3pAIQNpXkhFSWMq8g/zU/+O3O8czAbUlord4r0dmkiGi5krImBRMjAsxnjNvD6IuTXz6fmzp5Y8E0ycfBqGIWLWL+HSQLvcl7GmaK63HnsJSroFC5jLnrLFBwCe1msR5iQ2AE+lk4CFpoBCRPkN5n/uIw+2vTMfS5K/GsSs9/Ao4fdFy/cAYe24mCw9SzLH0FGwC65K4sRfKLL7IRmjoBa9TT6viRPDiIqO9Rx7LkkOv/Sv1mgLWyVC0uC0lCHuKT1OZJDLPj3R8mBxDEqcgC1o6OukWD6SNBPFhToxRUJmf64MpjRSKUvkNaKMYXgh/5N/PYaIxnOVevTdKId3UzzWUVFWa4R2oZzzrkNjREESgx/R2jr1GCnXxAvd83jJWY+nEVVLFXz70RQ30vckBucxZiiUFhjYZbnNtUF5dUC/Bt8U/gPvdCXf7aqkCVC8W0T2reCVs+aFehbCQ6oPfVHv9Gmd3sVrLRGRONhAN8vCviXHX4MyUxBs4NYGGN663pBtL0E2/Tz21V2fJ58DDuVxr0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 11:06:57 +0200
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> Move offset_in_page() out of linux/mm.h so users that only need page
> offset calculations can include the lightweight vdso/page.h header
> instead of pulling in the large linux/mm.h.
> 
> Include vdso/page.h from linux/mm.h so existing users of
> offset_in_page() continue to build.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  include/linux/mm.h  | 2 +-
>  include/vdso/page.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9cedc5e75aa9..d5c7f1ca80ef 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -37,6 +37,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
> +#include <vdso/page.h>

That is already picked up otherwise PAGE_MASK would be undefined.

The whole vdso headers is a mess.
I moved one of the definitions (to do with bitmasks) back into its main header.
The vdso compiled fine because all the 'normal' kernel headers get included
in vdso builds.

-- David

>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -3023,7 +3024,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
>   */
>  extern void pagefault_out_of_memory(void);
>  
> -#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
>  #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
>  
>  /*
> diff --git a/include/vdso/page.h b/include/vdso/page.h
> index bc47186c07fc..948b13091084 100644
> --- a/include/vdso/page.h
> +++ b/include/vdso/page.h
> @@ -28,4 +28,6 @@
>  #define PAGE_MASK	(~(PAGE_SIZE - 1))
>  #endif
>  
> +#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> +
>  #endif	/* __VDSO_PAGE_H */


