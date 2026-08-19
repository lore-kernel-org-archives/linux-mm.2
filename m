Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C68A8C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 11:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4346B008A; Wed, 19 Aug 2026 07:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB426B008C; Wed, 19 Aug 2026 07:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1826B0093; Wed, 19 Aug 2026 07:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA076B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:50:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A907D160521
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:50:07 +0000 (UTC)
X-FDA: 85117850454.08.5A0D706
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id C896320002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:50:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ka3lv9fq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787140205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qb8vbO35I9ReDoy08LYZaOcpJWIqiGdFJcRUGNTu904=;
	b=mqIPrJiEDCeVu+lQ03hEh0rnL5A/AbOssbjwHDw6sSkM0IHGTTOo4JsATDpbDZhO25IQxR
	usaIIk/qk67YaJBwq+ajwZrGfaXr8eTQHMUclKtmRuiQsJKJoqf3Fjd+Zq9FEM/zaDtJnF
	XZoynNq8QNul3Hy/0UBG6+UF9Xi2f0U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ka3lv9fq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787140205;
	b=T34e6aYHUBkppqy7UHEzSzA2DVnbtQrBZXiVowvd2lJiWbkAH7m5cua+/IG2aDFttUhG78
	UlmFmEuZr6/i95Haimpg7eb9uTkkNH6xrd7K+sO9ePddoP6iGTc7NOb5L6mtKJZ+A3XROv
	P0OMr526gdliY0acMvgVEBeJzOLmjh4=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-39faa67fabaso5944661fa.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787140204; x=1787745004; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qb8vbO35I9ReDoy08LYZaOcpJWIqiGdFJcRUGNTu904=;
        b=ka3lv9fqNQHy6EBm9EbYoRnL4mSnihH5mwsgMBrbAzdtGulpGHgRltDruppvDDFYvK
         dtDPKY1nqEtAqfpl651QfD2zLMH5dXY12QFp/OrN+y1lic8Ch7Y6MiHnbuZmf3jW05JH
         yCobqoPBN7kq+AGoZxzf4M0HO7UlZL/2Enbp1COshofMWVUyetuA25mQHUX3o3Qnp1ET
         A4WewjTHZEGlMceVaDPUyuSGZLI3nIsaHt2CRH0XOnnQy4l911mGYNSWbtXqv6OsEB1G
         MSHe3iTTwYz9AGh6s+rnj5lSUVgmcFb4rdgYGpKhYco/xJeMPrMAsD5yKrLekhotnqsz
         9BBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787140204; x=1787745004;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qb8vbO35I9ReDoy08LYZaOcpJWIqiGdFJcRUGNTu904=;
        b=YfkwFEOOoF26Xc3Y0L5bHbdkm64K5//TfiFsa2hW8826PTzxUwUYkDXYuzTsMQtO13
         yOlPzI5OMff7tiZfwj0P5nS1cWc3YDGo4jJwe/OoVKuMXO8wCo8NjHaZt/RJdc4+PhVn
         jWG2JU7EZZGisl8nQ8+i6Erdk8fVldyswCee3rdCfdUgjY+kl4q/TUhKEX+lyEL/v711
         UuS5sot/36zbzQqN0ERzNmbbP3Fmc4IwvUNJigj0PmzKFP7xtDlsJipffx2QqjBos6uB
         rVi/DfDK5BXkfna+lwJdkcH11A/r/fcGdkR24FxF90lnK7FeSzrZo0IcRiyTh3Gg4n8h
         X86A==
X-Forwarded-Encrypted: i=1; AHgh+RrF1tJFjL5ojSe4HnS09ti7t09a79D9gU1/Ztz4m/W15hsY9aHofSCm+K7bK1jDiMaAJndZQzm9fw==@kvack.org
X-Gm-Message-State: AOJu0YxuTGP/RBNHwhIr8yKXzUYTNnPCqpgHIItvf5/tT/IuE6YuNShv
	R0TTg+RWmmHKIs9HuLUYiwZQ/MQ4P2mnzhkyvL8Ofrx/3SbzzaSsNTqG
X-Gm-Gg: AR+sD11FQbhLVGWYF7hWg1cnlj4qZSuig8VKvrH5Jg7xZUWazHHU6xPMP4ygD8Rctz5
	xKoPpN6I73ghAxcidyOp7mBaALaB4lmwWk+N55zGg09TAFK03IeEePjHcaf8qvp0sdAKHPBdxVe
	CoXjY/yLTefOHnxWlJfMbCPhvtGARv8Tw+dBJjGu7NqKwntzU5PSsOo90zGJTeQICV532t7XiwG
	T9yYlxjENKRVy4o06DKIld5QOXyHw4k9580gsxrC24SZC0bs/GqvrHh0vIVg1h0paO4yJhrXY2J
	w6WJfRqUJHl12ypUkmhzuROTXFowddar6sATrea1B6hRcj/zSu1CsgtUG8G128tXoiIEg2hp4e+
	ENontHIj/DhIj5W639ElXHykehyZDDvirKkJ/CPs5j/inC7GE8Y49Q+bFbwTs4GypwhYrHIv8iu
	OVR7MBFrlwoM/uc/ZeLsMO2D+DdAm46u9Y/rxLGF2zHksoCtiU+jAcUL4Zxs4ooRXVSwONpNsJp
	7Gmy6GGLJN1ay3eaEY=
X-Received: by 2002:a05:651c:3135:b0:39b:48c1:8cd4 with SMTP id 38308e7fff4ca-3a18996bd7dmr7858151fa.7.1787140203900;
        Wed, 19 Aug 2026 04:50:03 -0700 (PDT)
Received: from pc636 (host-95-193-137-165.mobileonline.telia.com. [95.193.137.165])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a18a8e8579sm4123321fa.0.2026.08.19.04.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 04:50:03 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 19 Aug 2026 13:49:58 +0200
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH 3/6] mm/vmalloc: constify vm parameter of
 get_vm_area_page_order()
Message-ID: <aoWYZk7xNfjwuzQ_@pc636>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
 <20260816-execmem-set-vm-perms-v0-2-v1-3-90944a3ad43f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-3-90944a3ad43f@kernel.org>
X-Rspamd-Queue-Id: C896320002
X-Stat-Signature: pi3yt5gjwkmsbh7wez5s65pkmf7jzo3e
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787140205-729287
X-HE-Meta: U2FsdGVkX1+KcVCTg/wRWtnyJEM9eRjgGk4/Z2p4APdpbyIAAjLkQKTaQc5alO6wXZToAWSjc1YgWA3WydruGNP9thR5th9AgagWxGaujgV+YJcSusagFfTLGHzOeyOSMVQAdpkFaDWy86DT/4qUCMBcIFXu84Z3BLcmK+AKmemVAN3oustPNJ2BQJ74Bv7kinSGpUlDMcBwzGDEtrmD8ikR7t1/7ByICGzEa02LyRk5lczrfnLJNFsL6GQLYJCcGfOsXzgxJz12hTTT3jTocR8AHUvWRHQrmvDrRX2pWrMUj5xy3xrT1e5NeVT+X4WKNetC116xMUlrHOMhxc8xq2MdQkCs/jRF3Vwv9TcqUw/9lLrZlxww9WNbOap9ojOIQrgo1RVwlw6rP3MuXyyY5jHmm9jz1Yz1H9jym9ZAytfBnENBlMZJZAuTIMrAl4tOYnAYFAFoE+X2B3fuLpHizOt6tOICpVqwlbx82IQZDVi6NoslJpSoSzPjKTK57gGAsJ5ln2HOcjxkkVB+6Spslccd4foXDAV0c84kl8/Q4uF7CotnGB2KQW+RrpGZlQ68oZEHEqr0zbcDgRHhNvI6160tgIkGz/I0hI9YQiSzIcoshU4x+ePkB6pDEPcSjWjpS42rVN8NijOqGAkhmJBET/DNcQFbDkI4Gr7vFWyN69d1d+VUgBZhslB3rTnA+ucvFl5aT3t5AIeHNwcTPMLxx/dkqrSZpzZQQzDRZAy2MTWMqfQzfKgkEVSyQEuOuYOy6Uhph5cs3beFLpqculimQumBj7WgDZRr7uzfk1SzCSgn6dhoIJJm2YoZ6ss7A9XHdV5mmQNrkRLMIhpdRubDgl+9i2uSu1Z2F7OuGhv29Sx5oz9KHBvpgDFp8o7eWS3Sn+JOjqgJ4ugdXFkB4t2HckuKgNH1RlpTIzefDDkwO58nJOBOxYMgxCiMwrc6N/hMZMgvuTVTFAkuI9Z6blg
 fcxFAiWw
 HQX86wWPkIwYYHENhgUSzCPcjY83e1x7Hk5FjAfJtYZ5BN9Hdizt/h0mb9ez3mYClc6YgvxjgLvZRahPGsG47gyMjQa3OGzfwx2Q439PHwS9DqvgcGcuOvO1tidVdZPK5Ixxax4xW5Nfz7VmPUKg9HjVfrpD/+9zOnpeki8kEN+WTwEqugR6ROD3jNbLkFbgjzQ+ANR0E6/4UopvW1JZwafzFqrVJDsHC43wAL77kJh6m503zHDGXCrMbO3H2rlqeiBZML/GihNWgYOU/QFjUbEcnftne9XVOtSJBecNEnE/EJzYpeyZKpnt3LvsN0JqKin4H2jp/B1W5IoaCgQVwcHS++bAorjTFhgjM3mUvNnuGxMAG8TFj9GQ0rgKsCEgZ+nw5vOtK8l/bxpfs8CmSJ3aUuFXie4yN9LqXOddsGBNXMoTXyAjRzV8zFh6TtguPdMMOienrXEv6Tm5TBnRKGEXjh5P6BVSDny9QaALlgjjra/iQKX5SX3nsv7ZzWvIJaBA94ZFyGbKRfxaeYOLtL7y6mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 01:59:26PM +0300, Mike Rapoport (Microsoft) wrote:
> get_vm_area_page_order() and vm_area_page_order() do not need to modify
> struct vm_struct passed to them.
> 
> Constify the parameter.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/vmalloc.c | 4 ++--
>  mm/vmalloc.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6822f0fe9583..fc7993db4152 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3124,7 +3124,7 @@ EXPORT_SYMBOL(vm_map_ram);
>  
>  static struct vm_struct *vmlist __initdata;
>  
> -static inline unsigned int vm_area_page_order(struct vm_struct *vm)
> +static inline unsigned int vm_area_page_order(const struct vm_struct *vm)
>  {
>  #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
>  	return vm->page_order;
> @@ -3133,7 +3133,7 @@ static inline unsigned int vm_area_page_order(struct vm_struct *vm)
>  #endif
>  }
>  
> -unsigned int get_vm_area_page_order(struct vm_struct *vm)
> +unsigned int get_vm_area_page_order(const struct vm_struct *vm)
>  {
>  	return vm_area_page_order(vm);
>  }
> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> index 8866ddcff668..211869f36509 100644
> --- a/mm/vmalloc.h
> +++ b/mm/vmalloc.h
> @@ -12,7 +12,7 @@ void __init vmalloc_init(void);
>  int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages,
>  		unsigned int page_shift, gfp_t gfp_mask);
> -unsigned int get_vm_area_page_order(struct vm_struct *vm);
> +unsigned int get_vm_area_page_order(const struct vm_struct *vm);
>  #else
>  static inline void vmalloc_init(void) {}
>  
> 
> -- 
> 2.53.0
> 
LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

