Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D47CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 19:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB81A8E0058; Mon, 13 Oct 2025 15:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FBC8E0036; Mon, 13 Oct 2025 15:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5708E0058; Mon, 13 Oct 2025 15:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA6438E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:48:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51BF5BA432
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:48:25 +0000 (UTC)
X-FDA: 83994127770.25.762AED4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0B6710000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:48:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cx4HrWj+;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760384903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoIiVq6q/zPf+hFpTGPfYJQvuytKZqbr3TYJ0M28dGY=;
	b=zIYsyVMWnIeFgteG+Y01Lz0GuPHBwhrKCZN0BEvbrFE5CPGcWM00tB2GanzAOF1NAyzeqe
	Fgx1NCAjanfm6v88dARuc7GZocBLPO7SoIncebBh0wq7RrlbwnCsytezRYrGFRwD/craEB
	NoL3u6wSKfn/2+hc7Bws91+keSrF8ps=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cx4HrWj+;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760384903; a=rsa-sha256;
	cv=none;
	b=tGwfR7D/u1zvci1sNzWqvL5nxhPYrfNK9WKQN1qPuEyTqqb3yJwED5slk7fDzoX4iYXF2Y
	w9oJ8Nn9uZmRwok8ELdDLiCFGDPIXqQurxHi6gepTP29YhXXTbi7fsFOXwNz5RuN855981
	56um+BM9RQPiLHRjlb4A2YdfYRiRn3U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760384902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OoIiVq6q/zPf+hFpTGPfYJQvuytKZqbr3TYJ0M28dGY=;
	b=cx4HrWj+qliFh/pB+xtlGeRvwPZHoWWGV0DSwlsfuEdBp90xv9yOYxX+SfnRw15iBbApz7
	zeuGT5ACEUPrTxMd1QDbYGvJn6Msj/Oo3JP26D3O3v9numhZjIC0AnTN9/g/vMJ8Xzo90u
	m6DFinyimhX1yByE4w4XEl7+D+Fl+3c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-ID7RhD9IO0WrkI1cgAaVow-1; Mon, 13 Oct 2025 15:48:21 -0400
X-MC-Unique: ID7RhD9IO0WrkI1cgAaVow-1
X-Mimecast-MFC-AGG-ID: ID7RhD9IO0WrkI1cgAaVow_1760384900
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e36f9c651so31722565e9.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760384900; x=1760989700;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OoIiVq6q/zPf+hFpTGPfYJQvuytKZqbr3TYJ0M28dGY=;
        b=Ib2g3OjsaudjvvCL3/C7XboGEQ4wSnY7S9RoIhJCa9gKpkJSp5TgC0wjl5XmLT/VcV
         aW7AOuOgE2q0TZwDwULVX9POf3Jz+gjdjsxTpGp565pk6HsCAcNCF9d9fWiNSl+bc1nX
         WGb1HbQbCj1l/rpZv3PUF00xrXFjLnGxCgFxHNQCmbDM4f3/RnOI0Z31ZXdesLAJsZ7E
         pAMMU1jQB9m2E48/xsBvmvcIgOyqbZpQ5ly2b3izzfZgWce38qq8BxlDKeh524dFoGrK
         BsrBCg+ZAlNDkiiZ1fOXmoFbJi4OSYYaowM+0UzgHJGm0Jbdqku2OobNJKLCpcjhq/qq
         S3CA==
X-Forwarded-Encrypted: i=1; AJvYcCVaDYsBXxtpQ1br/bUjGnwVL3+zj/0+6xdnpbokASt4JYJVHLmex9MQqDFAnTNzljYqR+gVWbzvCQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2oaduLktw7DUKRisxz3mKEdj2NmhRyaBQvfg9OFugxFbAr0bm
	0oGdXoQvySJtytPT92jIabKP8ZM0xZKGi5dmeD2wW/+QUOm6/XAmTHQE1dRvmwqF9P7M/Y/aHSo
	Vdy+Rm6rU/TBWh9worlqyrLiRIhE19QeHRLUpD/mWdgJMxdCYojcL
X-Gm-Gg: ASbGncsQCTp4Ar1uGV0JpN38hjf0pNfct9OmX9ZLJGvQ58ElSK/pJYuhy5eKqoPhoZQ
	R4nzh3ephhNV2XgmMINSrcwWPCw0YqboGS8ZbxFNZ453Ul6ksPBXodDiNvoda5xxo4mITHgrVlq
	178sDXGocW4s40o6wQZQ5M1Py5DtUWrqJQLGvPkIuDnlcVUfB+Ks09k9vJzX9UaT5TJE/k4OT8+
	qxxo1zFEtnmHDDjurLcim8xd7vRoF/tCTpSSCd9if4tl/dAykIF6EOCfKD+7/5Zk04uo2o5ZUsQ
	6v6Xj8B1hQU5pULnrHbk/GQTWjX07W2Iq+h96LWdelO0v0/AhFyFg6wllP+6PIkwrqIaksPBXmy
	Oxbk=
X-Received: by 2002:a05:600c:c083:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-46fb32e5338mr86095715e9.8.1760384899832;
        Mon, 13 Oct 2025 12:48:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbNw6YsZx8cSXfnUugZnTxcwqmuIwmVc7WQ4Zcnny7E+x+vjbOMkcyC4iU6iRN+IeO8VMqEw==
X-Received: by 2002:a05:600c:c083:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-46fb32e5338mr86095535e9.8.1760384899394;
        Mon, 13 Oct 2025 12:48:19 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb482b9easm205867875e9.1.2025.10.13.12.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 12:48:18 -0700 (PDT)
Message-ID: <5c1fb165-cb99-44c2-b274-09419f156ad2@redhat.com>
Date: Mon, 13 Oct 2025 21:48:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] mm: cma: add __cma_release()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-5-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013133854.2466530-5-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 17CgI4DfgkTtfrpvJu2aMOtyhgbzm8huU7yd6wbAtLI_1760384900
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E0B6710000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zzywqfpb5j6bws84uiqczeg5w6ir8hw6
X-HE-Tag: 1760384902-847274
X-HE-Meta: U2FsdGVkX19tR/2GPOobtDdlzWm7VL5pddBr5ZfGtB/2gC3/06EV5fi5aw/0LaOhk62bLQPq6QCK0Gd0eZajs2taRtWIKbRIVOu+rUY0SyD7bKF1OKt3WRTwcPca8I30LFUpZx2DTKjWkD3mCeOjADWcH1uh9CllVI26DlGRDKMM4owacMc1/C0jI/TlAdci625qLNsY4sna6p0GnKXGKy27lA52gFiz8TsTvFoXx3lknoFhzalLe/nmePrUIodA2ip8zbYNXkpKGWLf4ztqJPXE+CyNbDWYVM7NC7nsvwAqNaYsuKaLuORC4c0GOnXx0ZN2qVaiC9QVhiuy6jy7VCoPDDZfla8EMd0rACLEiSjwSLdSFdPtjjJ+UiIKX9fB5ZwRfI4dlBKW3L3IjfFgj3G5iTdse4xnD2ZV1ZEKtr1kYz4O94mISaEgz2E2MWATW/nN/et0VuDzpkJG9q4onCxrnQ0fZjhagV6BKNg88KwO7BpSHUtRHPm83bwBHNYOGcI3jp8bFzsdTQkFzZIfnibGsy267Hp21TSQkKqZYUfsRBoKG7d3oWNxdkoavFxkKKIDoVL37gvE90YIlbRxj3fmG0fwFhWvDpaQ1VE+kqsdS37T3ykLFPEleU+vF3XtvfchARxjJR2QZCR+Kw3rZreF2Vj9F8L4hK0dLeNYFz+nn0VslfMGQyYoatSIARX78mDD8Td5UvJGQCNnHJTdlvXot/JAoVbdU4dS6cb+uotAfT4PJFg/pQlc+t9Fv9rxjafDKPcozKjAxAyg/HnYKUSVVZ9M0+Thm0BxZLojDFW4u8/S75TJP81OKpJxa+89pJ3Ed/2y7ZCqjYHZsdGJykWEIgCQOLntpPllg4KFh9FiXru+t0OnEO1jOnjDursGuwb+dx+AXpdIMbnYFlHIYKPWACSlnGUma+IhLmqc4QfycWBiiURuDi3i2EmrbW61EGa5o0LYiYYptIOen1g
 bvelOHF9
 drZV46lGECDtdAtCJMUMvJgLWr+20UE/L4c311PvXGVhnAEOL77NQSHLMVqiJeuqbbRtuqTzTDd43yV5FXhPRfmY/1QYP7Rzn49GimT6Oap9810E84m4sRVytpI4IRNTPx/dzx+9Oo03nzROqkIZq3g2ZRk2VujxUlD71Y87sFPsPfHA7KRGetVoPwVIRCXYjsaWwXHqb3n5L1dC7LWKnuKbSE/CuRVM832YUXCYLBOG9SFxcH8afk1qB/AUZRxN0eYf0iqGdwDCrlUMEwnw5c7nDHiiekBe3o98X/Tfwft9quyb+9L6HufV20f92ZNQ6duNe8Em+rwAMjW6YBNsBmKuagMEGkUuMSgE7Z8ve2s3C1SmpJbBqm3YWSwSVd96ISxX2RoM98ZQrZwPiqwavvYE1dzrAYwve7odf56H32hfYY+TonwLeQJUUSUy42RIEldedMPWFqXnfAzLG8JawpXlrkpnVUmcxAnw4v+KQcMlkJcF0HnCvqomjWyRprwqWFHkKjtj4L5iADZJpm6ZYFO48JQNGg2lCSVJ3e4EJ+QVEwx2M3DWh+2VufkBKDmyV1aepWCjxDNHOHjx3FvEFjtnKCd1sODumdgvgZvwO/Uq77H7sKWoBK6ZeAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 15:38, Kefeng Wang wrote:
> Kill cma_pages_valid() which only used in cma_release(), also
> cleanup code duplication between cma pages valid checking and
> cma memrange finding, add __cma_release() helper to prepare for
> the upcoming frozen page release.
> 
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   include/linux/cma.h |  1 -
>   mm/cma.c            | 62 +++++++++++++++------------------------------
>   2 files changed, 21 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 62d9c1cf6326..e5745d2aec55 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>   					struct cma **res_cma);
>   extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
>   			      bool no_warn);
> -extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
>   extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
>   
>   extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
> diff --git a/mm/cma.c b/mm/cma.c
> index 813e6dc7b095..88016f4aef7f 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -942,34 +942,43 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
>   	return page ? page_folio(page) : NULL;
>   }
>   
> -bool cma_pages_valid(struct cma *cma, const struct page *pages,
> -		     unsigned long count)
> +static bool __cma_release(struct cma *cma, const struct page *pages,
> +			  unsigned long count)
>   {
>   	unsigned long pfn, end;
>   	int r;
>   	struct cma_memrange *cmr;
> -	bool ret;
> +
> +	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
>   
>   	if (!cma || !pages || count > cma->count)
>   		return false;
>   
>   	pfn = page_to_pfn(pages);
> -	ret = false;
>   
>   	for (r = 0; r < cma->nranges; r++) {
>   		cmr = &cma->ranges[r];
>   		end = cmr->base_pfn + cmr->count;
>   		if (pfn >= cmr->base_pfn && pfn < end) {
> -			ret = pfn + count <= end;
> -			break;
> +			if (pfn + count <= end)
> +				break;
> +
> +			VM_WARN_ON_ONCE(1);
>   		}
>   	}
>   
> -	if (!ret)
> -		pr_debug("%s(page %p, count %lu)\n",
> -				__func__, (void *)pages, count);
> +	if (r == cma->nranges) {
> +		pr_debug("%s(no cma range match the page %p)\n",
>

".. matches the page range ..." ?

With that

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


