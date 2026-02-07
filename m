Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AE0EE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 20:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9973D6B008A; Sat,  7 Feb 2026 15:16:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A626B0092; Sat,  7 Feb 2026 15:16:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2686B0093; Sat,  7 Feb 2026 15:16:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1CE6B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:16:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18C111A0483
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 20:16:30 +0000 (UTC)
X-FDA: 84418768140.04.2887AAB
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2BC8540009
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 20:16:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NjzKoL7b;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770495388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tgEE4qPRK7pF2tP48CJlGhSYjJKIgdfs2GqYMm8p6Y=;
	b=q9w6+bGlEGdrGYnYxO9cEtVvdoeeiwxikBIvdgvVeQ9wRkaImh9t4H35CbZuQ3ZnU7eXCl
	O2DWp5k7cZxk+5JNL+a1XRoP+TpVsDQwCWz0RpODwcCCzqq8gCMlayLTgHkhCO2casxcr6
	bp9jOXHnCdMKacs7O+HV6+sveoQQ7zY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NjzKoL7b;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770495388; a=rsa-sha256;
	cv=none;
	b=y4SbLWqSSgeVx+C3Ew7HPQVV6Rph8tCjAPrhXj55Ew5FAZOCcvrAU83jw/dvmPkARCghuX
	CNtM2ZnwJz5GiHBONdn1Pg7FZVJVJTEV+kr7xkE4+QXGWNRsKFueRIef3RUB0CLPh3QIbH
	FqTC5Bojt9haNMerB6//LHh8dF2y+TA=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47ee0291921so16264835e9.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 12:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770495387; x=1771100187; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0tgEE4qPRK7pF2tP48CJlGhSYjJKIgdfs2GqYMm8p6Y=;
        b=NjzKoL7b16rs8DZWPJEIMqlXyxz4wslAHUJleHy7V6thNcw9bnMjZG3qjxdqKYiAAl
         r6ogdrGZx848QDgDWh6uuWRNXzs76JGW6SqYJwcB22k3vVNc1rqEFmr4Y4uyE60Dz15j
         3HfKyBYyJSpFX46xjSRjCmzBhcwzapvt7MPsQ5fjXPZR0QExEubNCADXvMAXXJ0XjTYf
         CD0xFvHlR2Jtq4z7A2xCxvnQ14PGsjn8DltAWAFWkbS5xOLC0Jd7H5iz3WlzZpKfNEBa
         zdnS0rC/lO3cD1UtOtxs7WZunxW2fVC4yTFh21vnZUjo4qg2m45r/gxn1ORVRnBX779n
         1C6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770495387; x=1771100187;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0tgEE4qPRK7pF2tP48CJlGhSYjJKIgdfs2GqYMm8p6Y=;
        b=Nw/z5KyRFp7ks5LbwrM+ot75F5q+4MU5CyTkrvRSZDCHauN0ypAXk9n5b8MNzeWru9
         JCHunJES56aAAObESeuS9fGA24/LEZjmGtUFSb8rWaihHI2EIAjwRAwSWCHk/ACPkcvj
         5DOlISLJsSClvueO4C4OB7F1NZ8bFFets59raPGBZaHPBNWKVsGqWNkOQtlLdI4BKW3m
         XYWXldmBqr6UGNlZ93+14EgXgAx4r98c0LwVrfBGn4/8wM/yv+kkiZ5u384T+pB3TVYl
         XF8ZphH20JGPSh/Abw+ISIzjhzi+t0cPxTWbtZ0iGhevPHuWSCfpQUqi3SY22iXPXI+3
         O4ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQMu/Ud0QI8KTQpPUUzpCDdh5IupXVjtL8rmu1g7YidLofkBc7WFAJYoUzI/sxnnG641fTzT+YXg==@kvack.org
X-Gm-Message-State: AOJu0YzeP3VCXmu+hdeW7g8jeBz1k9tintUK1qcjJIiLDePS2AUufrRT
	NGitFhHtcNmvF76bLtphGllaf+hBBn7UkOMyZYUrgm/Hd15zVBrMWS/B
X-Gm-Gg: AZuq6aJNLwUbea2y7+sqgE3Q+tOt8Pc8LXI9Em7ak1kgyzHcc1Ro+U996jZ68HLrV5k
	gRZf8TNlI8sIvVT+GRaho0pYUYtnT6Z/M0jultLBLaxg7EGtfw5jt+E3vKcIqeStRI5XJr/lKAT
	4js6hS1AkclFItrM7dPJ5SPjq2nqwtkTgC97JM8YYSIrWwLe5bVz780DmvgvW/hcpl1fM7+90bw
	uyJHFQ3YbaopW87UcaA9YwA+DHVbE1k2nJRGAf0XpInmQ6aQYirRllaOTQJHhO/mS8/EKApm8ut
	EFxfdjz2MOu+ltG7btvRf7lHNEyafnMFY0CWoMzoYbSmOacVyp9sjIeBIob2Db+kdePbhaWjDKs
	M9qXKQsY2UbQjCBjGGwJ75RyWRSa8sf8PEEycJg8KF2t/ODP0lHEDfmDfeJk0BaO1NqsMod8iyR
	mI63PLqtmiDrRGm5SbhwpMhWuwnHrIDczehVvod/lEi6OZEJzRsmJip4Erp6gQnjw+BKuScny2n
	KcjgghIjW2h9X0=
X-Received: by 2002:a05:600c:3e12:b0:476:d494:41d2 with SMTP id 5b1f17b1804b1-4832021d67dmr86909015e9.29.1770495386585;
        Sat, 07 Feb 2026 12:16:26 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e752:9400:18cf:c773:ee86:c436? ([2a02:6b6f:e752:9400:18cf:c773:ee86:c436])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48320719b8fsm144010445e9.9.2026.02.07.12.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Feb 2026 12:16:25 -0800 (PST)
Message-ID: <907ff793-9b02-4a22-a85e-2873246f6402@gmail.com>
Date: Sat, 7 Feb 2026 20:16:25 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 11/17] mm/hugetlb: Remove fake head pages
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-12-kas@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20260202155634.650837-12-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pd76bdqwai9acaargpu714xmrhf3r8o8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BC8540009
X-HE-Tag: 1770495387-654152
X-HE-Meta: U2FsdGVkX1+gc7WnoQxDqkb/Gm7wrjvHwueAq3o04Pb1uyFlIQWUJD9nnI4DBHuV4qXDKDEfQN4npijzXdYnvc87+MJi0UFuCfkIlsv+lf770/fv5+yxDauneYFB8biG1sTx9Z43XaWvBAu2jMMH5j1uieFsS38SEvg9U/RwtTgKYhwIz+xq31tvKy0IgQCW8GfT3DWNY9+ET57cv7aQthxEn5ZZCJ9tRp7X6YCqe5U0ckwkAI1tn/EOC670abH9p0UVeq3nSWWo6xbruX3GrUo44WjI+sawJbgeBbg7MNrkre+8lUqgOdtcj03C6WzEny1TC+UJO9nugjRNsRmTY+niP4BfdXjYjoEm9Fmz9PrIGR5ZPf/0tIep97QzVHluCauHvKNDPrII/S8iIhTxHAR+g6yrwyI8XhqGIXyWFPV6bmpBIAmMhylkWf9w4djXyP+INenliU3B8AnlMpMb54hYIDEm3ADK32sDpzmyTQXyHNI5WLQNJGQolGzGuOSYpoRJ/2LWlYsnLlEuB2o9BFea6gUXpuFL/I2GPD0ckeioGrFUxLkRZE5ONKqRcZFoLgNWXHAFfutbvhaTPf+6HjVFQOMz7QRe0151DlrWyIpV4LExv184KMOv7JdG1HGE17/9O6jS4hnsYFCOSpihY0hNQAObUA/K83ifZ2CkqsAw0JThE2il5wXU9pdg0bP5M8To/Km7dSDFiDrbTD/EDBThUh8cQprJrmy4L38f+G2zKznga4pQA/EzBegYfKAVwqSjYr0SeblTQYyn5IbqCfjzLxooyHWxqgfOqYbk7/abqBA2W3A2my9y9YapBGyCI1hsLZX6kZArhTAkNUTko263ixaFbvVLYA7Bk/nn9+gNVHE2rmyrB1DWr02JCRRUTGddILLGX2bgOhIJ77QgbK1K0mW99zhXk6bJtFu1UKZ+hMVEzIbqwOMjXJJYlZ3RGcY4x5Nl6EL7k6YA8KX
 HeWazuqU
 HKsso7pnyouXH3ZzQ/0KIaJZetbGwV717kXKCVgvGNvtmm+gHoDMQnJLPiHyek3wbDzvCTof957m7qdmhC2ZvTxQ9+jdCjCMPu65ZV3mtV0f4jk17TN+0ga1/Bf6jJi8VgsB/ckcvu2/5SIW/15E3N2ZF1joOVKDVjirKf36ODgzMlHzOhsapZ4orxqQo/IJBmGKHiBtTUUAJHLNIUEoOqIKtq3oPPWffUUZfz9wUOGnYahkQG48xONoqHSBJ12LRZi10G/2DdodAU52ddIvZbTBO+usOALg30KM363oFMlKNq9x6xeN7MBM3KNxmvBDQ8hr6coIpkuiA1vcWnqPcgyDtlpjrZN6XIMxvzbDNrwOoVw78sFpA3y4F7wJI48jAVDmBDXDu8D+R/caNTkW3FH/feEZCvoMb0vMcXNScm/SsmFwbdgChLyhmWzeZoZK4iC3S4mb8vY2wcVPoFtjCVI++9PfRrwKdR+/1qt7UU4/bu24IU/8V3hIu88AL877vlkkH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +
>  int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>  				       int node, unsigned long headsize)
>  {
> +	unsigned long maddr, len, tail_pfn;
> +	unsigned int order;
>  	pte_t *pte;
> -	unsigned long maddr;
> +
> +	len = end - addr;
> +	order = ilog2(len * sizeof(struct page) / PAGE_SIZE);


This doesnt work for ARM. For len = 32 (2MB contiguous-PTE hugetlb on arm64):
ilog2(32 * 64 / 65536) = ilog2(2048 / 65536) = ilog2(0) which is undefined.

Is order = ilog2(len / sizeof(struct page)) better?



> +	tail_pfn = vmemmap_get_tail(order, node);
> +	if (!tail_pfn)
> +		return -ENOMEM;
>  
>  	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
>  		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
> @@ -398,8 +426,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>  	/*
>  	 * Reuse the last page struct page mapped above for the rest.
>  	 */
> -	return vmemmap_populate_range(maddr, end, node, NULL,
> -					pte_pfn(ptep_get(pte)), 0);
> +	return vmemmap_populate_range(maddr, end, node, NULL, tail_pfn, 0);
>  }
>  
>  void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,


