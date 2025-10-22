Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42ACECCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C0F8E0006; Wed, 22 Oct 2025 16:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903738E0003; Wed, 22 Oct 2025 16:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1DB8E0006; Wed, 22 Oct 2025 16:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6F68E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:09:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC5C188C71
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:09:36 +0000 (UTC)
X-FDA: 84026840352.25.60FA8B8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 978AD180006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:09:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EFntzAbe;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761163774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUeO/YtpBDjpNP+/Rv4SHJERka//cgw1906gVbxjijk=;
	b=CRHSCJreOBcLGFMdYIdpllb6+6qAxwrpLUBkl7qEpFXO6IBCvqoGVl7jnwYG0AyFAs+HaE
	uJdm+KCik5K2jAF8OfVuDvxkLXkQRVgX9E+ZJaR3DqZxbaDpbq65VbH9WFDsJuTUZsLVA1
	H/hyOOnSwMNtaQYO+Nk4zDsrR0L+3dk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EFntzAbe;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761163774; a=rsa-sha256;
	cv=none;
	b=xvesRQmXSrIFNX0BBFKTjR2DJX0ry9VRWIUSN7fJ4/uFZh1EpCAs/276VEFskeytDiML1l
	A2YqkUPDUF8+dnW0jh+92AHIqXaTb+1MBitLYrBNe8NNjDO+kCf2sxDsU/S8jEKrQ9dxCE
	DlF42g2xgGR26LgHc8MuTbQ0UxYfRZ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761163774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dUeO/YtpBDjpNP+/Rv4SHJERka//cgw1906gVbxjijk=;
	b=EFntzAbeBVxsj+CELu92lIsJatLSSzc2L8vbyGA4VNb7jtQKqnRycB6NfafRlazGZKQNPR
	Vj7Hv5P5FVfUH+th1Ac9Hg5zZTaXWFPH/0FyMlUeOSQDxpVnXzvft57PyrriprHqm5FZo1
	YT97UfeC2OJ0ATjkbkYSdCzVNg9sNnE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-gZzB_VNqNMeso3Osm0hMdQ-1; Wed, 22 Oct 2025 16:09:32 -0400
X-MC-Unique: gZzB_VNqNMeso3Osm0hMdQ-1
X-Mimecast-MFC-AGG-ID: gZzB_VNqNMeso3Osm0hMdQ_1761163768
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso30515e9.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761163768; x=1761768568;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dUeO/YtpBDjpNP+/Rv4SHJERka//cgw1906gVbxjijk=;
        b=MEg9WMwitmwEnJ4eYbtMsWa1ggZC5HaCZbUkrtAPTGH4Ic2rigZyPv25FmUH9sTSQc
         BdMCjBNlfnmL4NXOts6dUndxdnARWamhKhMwHE3pzTfui40TxivI4yweHR4ACzTsLhXi
         meN40JohFsmhEOkWXMXX7QJ2iDY7952Y8YFuWpwvG5OXLlwMgV+l9BdLz7YffXul8N9e
         OkF50eJhnMhtwGguo0030vgL+p6Ri8ipBIm5+CizDyqFK2YKA/xz60W80J5IUYVSqGYH
         fLsBbQ8OYrogVFC1M8gEMIknHLeg01lYxcidUZshJy7VmoHazK00Vkxeg6yJNKCaZFEH
         wGSw==
X-Forwarded-Encrypted: i=1; AJvYcCVcajWrPddy9VWh3aT6ZO2prDg5U5IEQTKcXTzN9em8MS5fsMjlOpuGztPu9V42SIez0ULWPSMlFA==@kvack.org
X-Gm-Message-State: AOJu0Yzg2ikfiFP6xcl7kj/E83ivVPSynSrer3EnpxkOz1tbYL2QB8OU
	r/sPu8IV6PHdoQrMEvD8FFC76cvDEoXgc8Zxq0IvwB5f3pU8X/GIw1meh03zZ+i0SnjIHszm09u
	3Ph4ysZhsyVrTBIA/PB3nojEmXBChJDhVjYbzbXsDl+K8mUsN0t03
X-Gm-Gg: ASbGnctagTKPzHnbaz1mdlbabu2GMfpfJ3R0D2eORn0DqbzgrqR//kfZGpkaPpaJWm6
	bQN6JRQ2T4b6HFnCfjc8DAOXulWzZ0tEEaoujFD4FBdPyd0tp8ZHzljA7X2LgfdvPNEppZat2yz
	XXLaderNqhw409mZP7AuwUdGCtUp19gkt4M6s600Hi7EVBQPSLzaDRzUJbnO0nLtk0HxPxIrqXd
	D7uAeyzQspzf/+LTzR34TLVdwXUgkVxZ7bn4Qy/ZI/Vco3m7c43C/3yG7yb5EoUqMXwZolAqrOD
	6LX6KPhO8uyw9iG9SNCGVGPe7ekz3IIWgSqtAWuwmdXe6KNZLINCsACh/0BnkaZcpwUevFLD5zK
	TL5OSU35P4UDOyG9jpR0OUzMcBtFXe1sKX8Z3rnEI0cNVW4k02O2+gOoHVu/ipSLU0Qr0kE5HYe
	efcdqer628QphPnaIWVMWdMRoQfBc=
X-Received: by 2002:a05:600c:3b04:b0:471:350:f7b8 with SMTP id 5b1f17b1804b1-471179017damr146055605e9.20.1761163767945;
        Wed, 22 Oct 2025 13:09:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFeJmZJAMcww8F4mWD3Mdmim44dMWfgL8QKaixUaVMVlxDl0JJqaHLVxenWhQsfEAEk9uyhKQ==
X-Received: by 2002:a05:600c:3b04:b0:471:350:f7b8 with SMTP id 5b1f17b1804b1-471179017damr146055395e9.20.1761163767473;
        Wed, 22 Oct 2025 13:09:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898eb549sm144198f8f.41.2025.10.22.13.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 13:09:26 -0700 (PDT)
Message-ID: <d3d05898-5530-4990-9d61-8268bd483765@redhat.com>
Date: Wed, 22 Oct 2025 22:09:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/huge_memory: preserve PG_has_hwpoisoned if a
 folio is split to >0 order
To: Zi Yan <ziy@nvidia.com>, linmiaohe@huawei.com, jane.chu@oracle.com
Cc: kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251022033531.389351-1-ziy@nvidia.com>
 <20251022033531.389351-2-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251022033531.389351-2-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zjzw8lbbcl_cXs0ZCmFM8wBadxDfPyK6VYN-q241EAY_1761163768
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 978AD180006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bqybi43micrnyyfk6i5wny9jn14dx9oq
X-HE-Tag: 1761163774-679275
X-HE-Meta: U2FsdGVkX19M7eJFzrhMTCPFlvznQj5k1Tl0AB7pdsvgJ1xqrumMuzM2FUCiLofm/GX0bsOFvMxpSP60Ch7U9i1+EhJQkzi30kOoC9PUOxmlY5R8gbCRU6/bjFGj5gLC/5gsC64RNkvYGBKvcpxaxd6TAO9vfZj+Kl58agb6ItHqfmLuTHnkDu1MwA8HSUD90uFPQWiwv60hjGRQ0e5QO3By9rdTLjjxMA+A0PGoFiTfOhqieW6bfW0LwFy5x1H0t3su9ph1Bb+k+MZ743n7eO+O/O47JMf31pmn8aTGLMe8g+/PTyNnndYl7uOUwSYLaC6KzSjb1vbjLdssJa5LmALUesnBCwe11uqkSRcuJyzsmQQaCoHhmbyeO8quoSxI5EQx7dFPknMlxfsyEcykL+T68O3EvBnEwdDvC75Rf2uZOj4U41EEuB+yE5ipxMBLmbaplBUPeRg/TGwazTpl7kC+MXcWWSiQJDzCy2h7tafk9MAx1W66EtWOsXN9HtcQTJBLKsT4IjwLnWCps5pLZgy4vuklB8j7BNVLcFQIe6nOE8QDqo+ctcQJxY9IgDmJJL/UHe+cooUwqGmYhHb56Fu9Ai52wyt/qLdu104q5lL7qgwSKmfSuqz8m7QaOvKgl2kpKShoTnPKNSoPOT4SzD6Uw4gs+4PTlQaWkckHXPTUGAmRvcGav9Vuq+uRvzH2euM2L6DbeXad/+50VTG0kweJCogJq3saCt2tX+dxtcsg8jrsZZElwT3d2IbugTnmxzUHwCLJuxFcN4cyry5cXRzNAWRp9DY9bTawOHvwPpZvlitGq/kGjVoA1V4IY2aU3OSEu7zanVSu7ES0FoDbLYZqQheqmnL4lw3ohUcpMnJOfJ01zyWTnDizPHed56UzKlcSrO1BGAiCOKgL+AbU1/Toe1SjuX0zV1Pk9vj3KRL4bCFFBYo0hSjo0/WCZShRTaH8eOrpJB/vAqvPhpk
 KFNvQcbq
 RgJVWzii3KTidjHiy2PzXIPl/cyxJqUvLJunIIHjCqwk/J/5GoR2Ivd8fBzcjJNKPRgbwP4pLC8skTDcEQL4kF8+AUtr8BKOiEOvr2fnJKVz5CVu67NYSjwiFjjoqAIHsC4qq8/0uxeuWTfd3GUPBWHzYmqIfjsr4KLgzwLP1GdLWHfDcwKXUsbSlUW37G5YZX42O1Fc68qcPZ+u/zqQEsGdErgPlLvPcZ6mxl97jkoER8ln+VXFlthG8aei3sh7l0E+KgFcDIXPTon6y7pEzq2qT0aKiUgfxg67JlaPoJ71qyoz9ydmQ2pj1J9iOujhwXyO/p0nLlZEPFVJspFMd1TJgL4H8bP3cbK/U0NFn9vi2jnlsDw4I/vOgqe3KMV63rwLgTA50MY104FUSUO/ne5sRU2JERa0XT4wUdXap/AjMBqxj9NEM1rSHwkYV6tgwtOCoHVFyoEt+iMtgIh9kNS+MP4omDDvUfGYxLWb8M9ZpQiX5M5vRex0awwoHxTP9v6z9qN3Q/YATyfwlba2zvl/9I81y8LuX2zAiK35oAB6GZ5Z9ygeNKN5k65a35JXOofjc1yUL/j7+moNxtPJm22vhqNLrIJcolB23NsyqMT6+9salS+R0adCMQnPWC+1YLOJD4HqPterDNNhGdcjgVeyLd38JuONxsT09HaVMNSAsZSV0zQw/4A7X4lCtynhbwGYXG8fZAieNRS2b/iqVNyuVLpyvYP9KRxNmwYIsNFieaYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 05:35, Zi Yan wrote:
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio is
> split to >0 order folios. Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
> 
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact. To remove false positive, caller
> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
> do the scan. That might be causing a hassle for current and future callers
> and more costly than doing the scan in the split code. More details are
> discussed in [1].
> 
> It is OK that current implementation does not do this, because memory
> failure code always tries to split to order-0 folios and if a folio cannot
> be split to order-0, memory failure code either gives warnings or the split
> is not performed.
> 

We're losing PG_has_hwpoisoned for large folios, so likely this should be
a stable fix for splitting anything to an order > 0 ?

> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 28 +++++++++++++++++++++++++---
>   1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fc65ec3393d2..f3896c1f130f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3455,6 +3455,17 @@ bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
>   					caller_pins;
>   }
>   
> +static bool page_range_has_hwpoisoned(struct page *first_page, long nr_pages)
> +{
> +	long i;
> +
> +	for (i = 0; i < nr_pages; i++)
> +		if (PageHWPoison(first_page + i))
> +			return true;
> +
> +	return false;

Nit: I'd just do

static bool page_range_has_hwpoisoned(struct page *page, unsigned long nr_pages)
{
	for (; nr_pages; page++, nr_pages--)
		if (PageHWPoison(page))
			return true;
	}
	return false;
}

> +}
> +
>   /*
>    * It splits @folio into @new_order folios and copies the @folio metadata to
>    * all the resulting folios.
> @@ -3462,22 +3473,32 @@ bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
>   static void __split_folio_to_order(struct folio *folio, int old_order,
>   		int new_order)
>   {
> +	/* Scan poisoned pages when split a poisoned folio to large folios */
> +	bool check_poisoned_pages = folio_test_has_hwpoisoned(folio) &&
> +				    new_order != 0;

I'd shorten this to "handle_hwpoison" or sth like that.

Maybe we can make it const and fit it into a single line.

Comparison with 0 is not required.

	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;

>   	long new_nr_pages = 1 << new_order;
>   	long nr_pages = 1 << old_order;
>   	long i;
>   
> +	folio_clear_has_hwpoisoned(folio);
> +
> +	/* Check first new_nr_pages since the loop below skips them */
> +	if (check_poisoned_pages &&
> +	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
> +		folio_set_has_hwpoisoned(folio);
>   	/*
>   	 * Skip the first new_nr_pages, since the new folio from them have all
>   	 * the flags from the original folio.
>   	 */
>   	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
>   		struct page *new_head = &folio->page + i;
> -
>   		/*
>   		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
>   		 * Don't pass it around before clear_compound_head().
>   		 */
>   		struct folio *new_folio = (struct folio *)new_head;
> +		bool poisoned_new_folio = check_poisoned_pages &&
> +			page_range_has_hwpoisoned(new_head, new_nr_pages);

Is the temp variable really required? I'm afraid it is a bit ugly either way :)

I'd just move it into the if() below.

	if (handle_hwpoison &&
	    page_range_has_hwpoisoned(new_head, new_nr_pages)
		folio_set_has_hwpoisoned(new_folio);




-- 
Cheers

David / dhildenb


