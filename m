Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C59FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D9C6B0062; Wed, 27 Aug 2025 14:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62DDE6B007B; Wed, 27 Aug 2025 14:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543446B0088; Wed, 27 Aug 2025 14:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 437B36B0062
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:11:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAC091A05ED
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:11:10 +0000 (UTC)
X-FDA: 83823329100.28.CE8604A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 45FC240025
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:11:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ac8i/0HZ";
	spf=pass (imf17.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756318268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xd7UFS7CawmPe9GaZmY0KVeI3w3v5+q2sGdZeCqVHOg=;
	b=XMIVa70suFzBKP0DeNgiZtp5xfnFvrmu9sGSS4xLLImTbgyh+FNvn49SNnyf7GPAkj/fHn
	VpeVeRVTa0yvP8Bn0LKuoaN1zdQcinvsBry9EUZGGc8wQxll+vDNKVIOn5bcHngZdaAPJ4
	Lmp8wohwYXndU6YcbgH1hFT7jnAAmJk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ac8i/0HZ";
	spf=pass (imf17.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756318268; a=rsa-sha256;
	cv=none;
	b=KhZYlsNO4nu/HUjwCdkTnBHzr6W0z8xaFC8LtC0C6p8IwJK5QyFLWFRdPR5Jm8TTBXdwpc
	EtzukxgferRMPcDeOazOzfve7Eq1UlfXhJAZRcJsZ+pemQnHRYEtP/YejZPm4/XeZOWQiR
	sGvz6ZXgwwyUYjq9283lCcVuPzlv3CA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756318267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xd7UFS7CawmPe9GaZmY0KVeI3w3v5+q2sGdZeCqVHOg=;
	b=Ac8i/0HZan4af4Vv03iJnKDGMN5lzMq85aUdOYKIV4WXoKjxe6Cgwgz+i6o/NqSLpJJgSQ
	lq+SXqKK7F+MEp3JHd68gAVjJCRw8qdkixaPtOZc4jOhixMmFQ97dooJSbxysQZdiDwJ9r
	mQl7tqVeWPR0AlxsXGXOCmX4EN7VkL0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-OCFwnIAQMD2Y7qrkNScvHg-1; Wed, 27 Aug 2025 14:11:02 -0400
X-MC-Unique: OCFwnIAQMD2Y7qrkNScvHg-1
X-Mimecast-MFC-AGG-ID: OCFwnIAQMD2Y7qrkNScvHg_1756318259
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e56ff87095so117845ab.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:11:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756318259; x=1756923059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xd7UFS7CawmPe9GaZmY0KVeI3w3v5+q2sGdZeCqVHOg=;
        b=QcynAtsrbTs3YSvHfPh/HttJAuAzshlUgQ3hcBCj64xKmewfn9bZID8HCwW//UIRS6
         uAyHMXjiskcpzKsEqFHExbM4mnf0RGEz9hrECtmf83fmcwBP1sg8Y62xFcovm1U2LmoL
         hIsxqTpBEsiUl6HJVEcwoiPN7906F8J/5jNQcEEEI649BA6E7UlEtHMtTkDY8LmEsX3u
         C1iAZXNGM5z7Vapx6EUn8YoXQWTxZ0xFw7YrEeqAYKmmFe6EZf3WCIU9qx3pVSUZD5nk
         uLkRySUi1EXN3g1FF24qiuqJsoYn+SBfiHwOSM26m3fk8m7TjNcPYfnmJKQr+oJrOKFT
         B4qw==
X-Forwarded-Encrypted: i=1; AJvYcCVOFFtGc+pHxBGvuurbEOX2ea0IU70HDEcJNtjpWvdZzKIUFk1h6kZQ/FQNGDiACmXOnWV0Eb2B1A==@kvack.org
X-Gm-Message-State: AOJu0Ywm9B1S80Hqf2+HAuZ4A9JnaKbdt+MhXdNYDLgqlY3ARLFTKKkZ
	UdjUzmvkRq42erE3nNrRpT91ugs/9VY+McUwx/U3zwsd40mCnC42ref5N/Q63uNAMx8PdbSAVQw
	JFBBFOe3A6QjMMppyqtSI79OkDe+JLDCHCY7KDtLontP6IUEqHI3u
X-Gm-Gg: ASbGncvNWPANVokyb/nwLKX1ntAlEL9uQ0F2k6jJkE7i+xV1S0FVJym4lcwPMoIHEwT
	7KQYJWwRn3Fm53rsUBKTJaLQW0bjP2LwUo687O9aEgYTVUw7u0m/GrCUOV8pqKKvK3ovPpv2Szj
	BxXY1r5nGr/vkC2z4oNvEWAJxqj8XeuLG/qNXuXZY+p3FJNHQh3NQ+QP8xAOIjXD/QTIJcoQPSp
	MX9VgsQOMe1zCr9/V9jwv6LdY8i4jGBappS+xw46BOD0CN7ASujhZyyR47j8K9Xq0m+8qvGDACZ
	CRUWBdrFv+HxkqIMM9IaoNnOaUyD/O7iOpv8vYS66d8=
X-Received: by 2002:a05:6602:2c81:b0:881:87de:a336 with SMTP id ca18e2360f4ac-886bd25af01mr900981439f.5.1756318259016;
        Wed, 27 Aug 2025 11:10:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTlE648ZK5gyCMDjdHdH6z4PdCJTq6ON80zAHo/j9xVmBTNqJqZ6LVO/BK3pOeKZu3YTgUBQ==
X-Received: by 2002:a05:6602:2c81:b0:881:87de:a336 with SMTP id ca18e2360f4ac-886bd25af01mr900979439f.5.1756318258537;
        Wed, 27 Aug 2025 11:10:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8fc6d7fsm862725139f.21.2025.08.27.11.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:10:57 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:10:55 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, jgg@nvidia.com, torvalds@linux-foundation.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, farman@linux.ibm.com, Jason
 Gunthorpe <jgg@ziepe.ca>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Message-ID: <20250827121055.548e1584.alex.williamson@redhat.com>
In-Reply-To: <20250814064714.56485-2-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
	<20250814064714.56485-2-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zdycgPBGb_bQyYp6N7MOpGnorMNHUWsrph66sqNdpHY_1756318259
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 45FC240025
X-Rspam-User: 
X-Stat-Signature: csk5gu8u1575fy5csiyut6pzpr68u6p6
X-Rspamd-Server: rspam09
X-HE-Tag: 1756318268-431646
X-HE-Meta: U2FsdGVkX19PolpRIxIRiHLarczXDZF9VCQ5gFi6kuQwa72c7ZCP4AnRDW1xWRD/evIKiULkhBjklE8JzY2AahVK4TjWkSDcweJJcH8hyKZuAZajotFeQkEDutiVo2VeB5eo1fHxYtb4pTiY7hhoPT+sYoLDLGO/q68IppQ5iQc7U/xzEBMSOaCIGjz4dcpOD07FKT6/IscNXkTjg1h3/v4g8uC3sFMOrsPV4q5/Vbq938PNZ2SwAizcVe8E7C1zF/YdRN129MSbhXZi0FzktO2iHCL2zpQOfRwwLhgpXus0ZuyrVkiCIrrJ62tAfOI+W5X1sv8xXDDvtX901mgssq5rv/9r9nU3/nKML3WA0g905dQSbNE3f5LKGErvFZE9oTLnDsv+9LqZhEWjTPY7FzdusISfUVnkkzuv2/MFv0fcup+OYzpl9STBcqs7pQPPW1omemVaSguFqY5SjrXr8CbY7t8nMZSy6bEXGdnj+0ZppFZXG+rXbu/9X5K5EcO9Bq0qGrRGM+/noBerSZxxxkeyPHnBhNrK6wFtknJXMCMB/pP0Lr3B5/Ls+7YDFAm4yp1nw/wG3HBB3Rp+vvNfC+iFa3ubFeLkNZp5n+hEsCElyF2cm3M9e3nihygXUKiIL9rtti3zhFSmQldpdAHXkdmKU2/M4Sb+yq+E8IU/mNJdKkDOghct62M+Y5Y9QSRgzcitu4ipuFhH/xMtykx2FrYDu44UbqoPcPzXBmqqMc08INfiilfpBx4y2biLZo2JWFBANK0hBMujEnU6sddXa2M4J04oPpqF+hciU4cypdOmWT3GftufdSBXmrHqRUXqradoyCO5ktqx5FiuO3p3y3iSEQ+TgYHm3L/3OfAy1NnFEV0r4cZ8Ap7cK3MYi64w8+F6M+JRQIoNTdkv1tTZsknSoIxzgqqoNC6WjpZtBKAm/uj4O53h1bzb8pA1B4oPfEbuqZOScw/YIctPuRK
 uX5Ro2zE
 iQesPeFYBtF7nwh2A3XgrqSQB811lqnTK3c6oLvXbcFadjccKf5LkxenjCb76cHUOWP9cy2B6aZSLyDrgh0FdSJ4/aD46YLcSefsd83JB+hXx7/JPLzemRFb72MywTzlJgIHFVayBhfhPn/Wnx56gEK0vjcIyoWM1N1gR3HiFVRsoSVKjCkCwqmXQHC3gKHQB/hJ75eO1dXpsZcXf39rSHADtNU5v361yq0J2Y1Nfc8FnPDgWpNyjwvTT1Tezyw5e5OJHRI75tVNv/NyUf12mDvd2FlpC5sIxLS+BEjWTBVfD0ByV03c+VEJQEgDELUg1qF+9PFBZ86XpNMo2LZvNDQwkPNanN/jQym4YL+m3HHNx7iR07SdmR7ogT56no8lWgFx6Kp809zJkGQ8ko7aM9fD7w+NXHPE+5q0m3ZXdcOcO//TfeQZlgC8kcvVZslDhqVtj1edv0yUxgpZwVz7s9TfAiL7Bj3BBnLtfDQCqbLhhPlzeKOsQcmuxLXm3gYAlR94D9ki07ARqjSptCZ13eHK+6/kbt+L3eaZzO2qYkpPJSdaI8Y7PqNtyntchYDclUeQocLjfvpku4oVKTi/Yf0re8FLcd9LTrhXLCMaOzuYmFruXd1rrzWWLV6E4KVa8qWA2gkDHDXOV6YW4TstkGEfy3b9M6KsdHWPLHadZLPZXCxo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 14:47:10 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Let's add a simple helper for determining the number of contiguous pages
> that represent contiguous PFNs.
> 
> In an ideal world, this helper would be simpler or not even required.
> Unfortunately, on some configs we still have to maintain (SPARSEMEM
> without VMEMMAP), the memmap is allocated per memory section, and we might
> run into weird corner cases of false positives when blindly testing for
> contiguous pages only.
> 
> One example of such false positives would be a memory section-sized hole
> that does not have a memmap. The surrounding memory sections might get
> "struct pages" that are contiguous, but the PFNs are actually not.
> 
> This helper will, for example, be useful for determining contiguous PFNs
> in a GUP result, to batch further operations across returned "struct
> page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> process.
> 
> Implementation based on Linus' suggestions to avoid new usage of
> nth_page() where avoidable.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h        |  7 ++++++-
>  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 1 deletion(-)


Does this need any re-evaluation after Willy's series?[1]  Patch 2/
changes page_to_section() to memdesc_section() which takes a new
memdesc_flags_t, ie. page->flags.  The conversion appears trivial, but
mm has many subtleties.

Ideally we could also avoid merge-time fixups for linux-next and
mainline.

Andrew, are you open to topic branch for Willy's series that I could
merge into vfio/next when it's considered stable?  Thanks,

Alex

[1]https://lore.kernel.org/all/20250805172307.1302730-3-willy@infradead.org/T/#u

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..ead6724972cf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1763,7 +1763,12 @@ static inline unsigned long page_to_section(const struct page *page)
>  {
>  	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
> -#endif
> +#else /* !SECTION_IN_PAGE_FLAGS */
> +static inline unsigned long page_to_section(const struct page *page)
> +{
> +	return 0;
> +}
> +#endif /* SECTION_IN_PAGE_FLAGS */
>  
>  /**
>   * folio_pfn - Return the Page Frame Number of a folio.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 89b518ff097e..5ea23891fe4c 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
>  	return true;
>  }
>  
> +/**
> + * num_pages_contiguous() - determine the number of contiguous pages
> + *			    that represent contiguous PFNs
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array, at least 1
> + *
> + * Determine the number of contiguous pages that represent contiguous PFNs
> + * in @pages, starting from the first page.
> + *
> + * In kernel configs where contiguous pages might not imply contiguous PFNs
> + * over memory section boundaries, this function will stop at the memory
> + * section boundary.
> + *
> + * Returns the number of contiguous pages.
> + */
> +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> +{
> +	struct page *cur_page = pages[0];
> +	unsigned long section = page_to_section(cur_page);
> +	size_t i;
> +
> +	for (i = 1; i < nr_pages; i++) {
> +		if (++cur_page != pages[i])
> +			break;
> +		/*
> +		 * In unproblematic kernel configs, page_to_section() == 0 and
> +		 * the whole check will get optimized out.
> +		 */
> +		if (page_to_section(cur_page) != section)
> +			break;
> +	}
> +
> +	return i;
> +}
> +
>  #endif


