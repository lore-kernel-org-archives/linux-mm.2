Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73524C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD296B00FE; Mon, 17 Aug 2026 13:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D696B00FF; Mon, 17 Aug 2026 13:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745426B0100; Mon, 17 Aug 2026 13:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49B836B00FE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:31:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42C0D8085D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:31:24 +0000 (UTC)
X-FDA: 85111452888.15.D1B4432
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 35C9D4000F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:31:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KmJNw53e;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdAST+PW7bd2DD1v0YjadB8+zi0iamo4AznH2c9tOUI=;
	b=0bHa7Xx6Al0EyKrTuKCo7IGmHOxSaiw90qdi/fzh3kn/PEcN6ZKj2acdOIi9GSACVWauJu
	LT1P6kMx8mrhKLAqua8gXV8dsyKLCwmPQaqxfS+bP63s+Q4Q9ZKnkeijazkysEJpTs9nsx
	zG3XBjZREakykdHbeh4KKvxmHJeRZ/I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KmJNw53e;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987882;
	b=UNgdty2o2fXVXDwqDVjYX+vgwG+ZktGbr7IgSgxnc3lUxf42rJcVp6Osr1tEC+hd1A5Tz1
	9EMogzeKRHEUHJnhHMn38iD47YcqsDBLT2iX5LU0CYAA552xT17eaJ5UlzzKlOUmwDFufJ
	zKOLBDh3k+Bak7kjEljzi1vR+Rhd1Xs=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aeb59d54b1so3725011e87.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786987880; x=1787592680; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gdAST+PW7bd2DD1v0YjadB8+zi0iamo4AznH2c9tOUI=;
        b=KmJNw53eRCWOQsufhaGYSuf+BF1Nz+5XRjEqJg+u8fSErQBfcDh2GYzRqRhhrSeXd8
         51gxVxhae/JPY+zy0/d5DjHW4wKNeUaZaukzAV1eM7xy1LfNcEDx0bjRFrt8XNx/Mqy/
         z8ba2SQKfPz7NVi52mdRzAd3IJqmkjbsZgHjLokctlXZPNpXRz1xwN7afJyJS1VbsQRx
         1KMG9asIxKoJWE0sl5s/BC5srzzRBkRCdo6MsjlLBufp/fpVm+U8GHcP+fYM+bkrAIxM
         Z0+V3wmFEKKfOL0jVq1QaB24OU5hIDEX5a4cP542FTOBHbkrvyAh+6NfkQ6BHX9QiGlM
         W4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786987880; x=1787592680;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gdAST+PW7bd2DD1v0YjadB8+zi0iamo4AznH2c9tOUI=;
        b=ADPjAS3S8eCn13U2ejfj5FxD8U+0F96YEkv75nvgEjVBEYH18oauKg0kUcvrkVHWk1
         uHgpgT5R39WnrXiuOD6GNaBpC3OEd0N/6+DwNC+pGdVnLeMoVXfrU6PxwLnonfN5iW8o
         mG3Y8XZoR6GgwGzrtyoZYQfvDTGe57feDNBeB+ULD9krC5R5P5QhERYnTNZStlx+t+gQ
         XpHF6FW1peZJZNJEMbDttF4KSZphvg/99vQ0Onld12xVB9YVbTfhWuF2IyWhBpDWuIEw
         +UWh5d2Tcc7VetgHw4+CvyUr/z2OYBLvAN3WjI8H8X0AYB+k5wioiugsl3m5kHeGGO8y
         4dYg==
X-Forwarded-Encrypted: i=1; AHgh+Rp16QBO0ZOMV4pEsHKdF5UvEqVY3ZB3W/ulJATypOWlUjcO+rrgk/hHi54+MajHejVGg9qK3Rskew==@kvack.org
X-Gm-Message-State: AOJu0YyjvcQuQ2SSvcvZ66Vm0cK8ZTq9O/gybbDMCrDORybrHjErl3c3
	xewPXUnT6fsTWWdIUiPK9s4YSoaZMmxFAmDYnNVaCI9nxiNFS8UzSEA2
X-Gm-Gg: AR+sD11Qf+q8BgAVaMsE8NNHtKyLsqSgwyN7PcDuSA+QGUdg29f42g++3KGAoueQFQV
	rSouJ6TtAFcfmpQfcU4Gs80r2a/ebIhKR7ukEh/gw2iwoNRADrfP5GMYtuepn8QNDMiU0/b0q2g
	gQdsLaSGQpe+zzz/rT6qEJ6S7Svo1vqICNl2JvfuxNqQfO640FVju93y7Q+soRVC1LoZ7pvqaBF
	GGP5KhnAffIFsXTKU/RDMtweZI9B2xXi+NnEyppMhZyBRNPS5sOMQzW+fD+bj1wyfaTbUQ0twku
	9Lm74a06HSo+sFWt1vK7pmP4Js4DGalhwnMYC4J2RjA6+GlkN+Z79LebowNsLv7hDUbpvX3A+Ub
	w5608GtBZ9hUaHUqsOy+3kxAAFgdyFDcexfV1Z/kCE+r423q9xyBIqZGFOH/XXMKEnyXqC30XVx
	oNCtSsdcokaQb2N5XyvooyB+RDNA==
X-Received: by 2002:a05:6512:1284:b0:5b2:9358:b854 with SMTP id 2adb3069b0e04-5b459142afbmr3869031e87.42.1786987880080;
        Mon, 17 Aug 2026 10:31:20 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a16b1f1852sm5885691fa.38.2026.08.17.10.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 10:31:19 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 17 Aug 2026 19:31:17 +0200
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
Subject: Re: [PATCH 2/6] mm/vmalloc: set area's page_order after allocation
 succeeds
Message-ID: <aoNFZU_QzghDBgbZ@milan>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
 <20260816-execmem-set-vm-perms-v0-2-v1-2-90944a3ad43f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-2-90944a3ad43f@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35C9D4000F
X-Stat-Signature: qqn1cgp8mhz5wmg18mnyfxf53k4w3idn
X-Rspam-User: 
X-HE-Tag: 1786987882-600053
X-HE-Meta: U2FsdGVkX18eiTSdaLu1dosijCW89sU3nLoEg0J9TVh8JG/Al92+9TTcyFyBcsmM3SUQdmvj5RQMW5tr9Mamap+gbQrurHM47p1GAL1Ptgjqiqe0BIzVEJNU70CiTv5VR/GPwTuNTxhbQCQ4cgpeljQ1wHwP04xylDHkB1mIk9NDFxHU7EBp8Q/wQdKuc/g4D5pFxHhan+vPdGRycZn6F70LQozCcjM2l3WQQB6akQoiVcxwLfqDIG3zdsAa5iq/tcsbUblb4kVqAZZHitX1rnxcdtm7xwb7HnkSHO6/HBxsiGJUEZRGNaAs8KBBTWgxI40pYmkLB1Rf85oypnoqpBDOZU9twxOpc6tpUhKseqX8O6nj4Pkd2mlQf3VRRDp7vwnQI3xW88nsjq+7Genywrt2wJea0QB8U/jZenYqxyJgsEzgnqo8zKV/ueVGieXFia6MmxYnMlNNTyL7mnbV2foFwi1hPnOWbqpwix2X2exCCkgcArlVy1liJuQ4vdnVKdi7KtbEslsJi9KBrgAOfSPL8bfEyCClaU8fAyK8pDIZ8Z6i0S3jaqVyk36lqEB363VVugJr4uKBlh6rd96gUgmUETPT4r61DMyKHLAfgrDo1uf2HEs8u7nCeJuhraQBB9IvY5JBoRrDfP/VNx8f73rtWWxHTgQGYIMWgK1c093Fyc2iZ3iu6EqKOkC1zt0k2RORJYJAs7jXraU21d6HCH+f82jL5GlBJ7vHA2xU9tbeNEZHuEDlUd0BckjbqlUSg+jjsNYP+MD4RIV71xHno5YsOVw7SmK/QyU2qh3ioBhNc8ErqjBwA50ll5lMP+Ncj7X2htR2eaXUU9QOzgPFLId0nziY8k76JUnYn4RlR2/QkU6SbQkgCpickM2/qn5Z70KiiAdC1saYSUxtH0MKbRi0sTGSxONqE0URzg8nBpaWcDufqlIz9V8bqkCrtskg052kgdloE0O+NDrL0Sn
 UTqny/H3
 r9eR3uq/s+h95c/QpKx7HYXXPsn8CmNFwfV56EtCf2lbkbCi7uJjPDofc/88tecH6Ns8Dm5X3mUz6or0ejn4F8o4LWLzLOWiVzt5JFK4rrfh/srpFGAE8DlQC4uP7hAad/z4GUwh2Tlx28X65FeQHM/zMQMTCD4cTjOulTbmDL9qR+GILlW/7U8QknZamB6RHJLTNxMSIC4kG5yzpDSkv2LzLRDio8KpzKppCVENsJLFYoPsrWaMUISYEp66k8lesF7KqGVtHBELXRbs9lQWQAHwhWpB8pEfNfHrwk4M1E/4w4L+gjqyNqbwjyjSqwcne1/J/frt3qRaGf/o+ihEBDw+FvgDDLdWpAS/aYsZ8fis6kmkMQ+K7cAPytytEWrmaM4ZSCvxiMaeHrdqDrUID2J0MCu1A/ecqVIWsbz0rzCkYGWejNOz5sWGF/qXQKnFj0BBDbKd7WYz34JP9tINacKAY94u3HU55KxhNuWBfEqVZut82TpG4sXgpEjeIHH7977Dr0QT60cwrdBA4DPKrorpw6EehjLVwCA/RcCmwfCMTmy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 01:59:25PM +0300, Mike Rapoport (Microsoft) wrote:
> __vmalloc_area_node() calls set_vm_area_page_order() to set area's
> page_order before actually allocating pages to populate the area.
> 
> If allocation of large pages in HUGE_VMAP case fails midway, this leaves
> the area with elevated page_order throughout the cleanup path.
> 
> There is no actual issue with this because the only place that currently
> relies on area->page_order on the cleanup path is the loop calculating
> the direct map alias range in vm_reset_perms() and it anyway skips
> unpopulated pages.
> 
> But having set_vm_area_page_order() in the middle of __vmalloc_area_node()
> makes things very obscure, hard to reason about and error prone against
> future changes of the cleanup path.
> 
> Move the call to set_vm_area_page_order() after __vmalloc_area_node()
> succeeded where page order is guaranteed.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/vmalloc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 22566e0b6e38..6822f0fe9583 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3901,8 +3901,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  		goto fail;
>  	}
>  
> -	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
> -	page_order = vm_area_page_order(area);
> +	page_order = page_shift - PAGE_SHIFT;
>  
>  	/*
>  	 * High-order nofail allocations are really expensive and
> @@ -4106,6 +4105,14 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  	if (!ret)
>  		goto fail;
>  
> +	/*
> +	 * Set area->page_order once it's known exactly that the order of the
> +	 * pages the area contains.
> +	 * Even if we succeeded to partially populate the area with large pages,
> +	 * still treat the area as populated with order-0 pages.
> +	 */
> +	set_vm_area_page_order(area, shift - PAGE_SHIFT);
> +
>  	/*
>  	 * Mark the pages as accessible, now that they are mapped.
>  	 * The condition for setting KASAN_VMALLOC_INIT should complement the
> 
> -- 
> 2.53.0
> 
OK, can we just set it right after the:

	area->nr_pages = vm_area_alloc_pages(
			vmalloc_gfp_adjust(gfp_mask, page_order), node,
			page_order, nr_small_pages, area->pages);


succeeds?

I am not sure there is a good reason to move it out of the
__vmalloc_area_node().

--
Uladzislau Rezki

