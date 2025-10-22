Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0303ECCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1868E0010; Wed, 22 Oct 2025 16:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562058E0003; Wed, 22 Oct 2025 16:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42AAF8E0010; Wed, 22 Oct 2025 16:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7E78E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:13:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1EDB1296D9
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:13:16 +0000 (UTC)
X-FDA: 84026849592.04.E201B54
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8BCFE12000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:13:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dBHkGp6w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761163994; a=rsa-sha256;
	cv=none;
	b=EUlXFfHF/7WQgiYeF5s9JXGGoNkqF0Ky4u6hVTebSUp6c+YQelHonc8AWs3gBDeVAaZzSN
	4sdQn+5tUBBIFs594pMjtGeZFxrRtWDZVtamfotv+jbXOghpMyw8WZf4FdsUNe2AcOq9Xw
	t39OOrPqzww5Qcefb7voUyq9zNi46r4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dBHkGp6w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761163994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFSmZK4gFSd0PHQz/xlqwyuF7ltItWEnpq4f0/0wTQ8=;
	b=ApP/SoHT2bhnVVN7MpIOyzRRjgZaiX4BofjPOn61c/bd70eyxm8Zf90VvzdtiBBA4VhWWY
	IeRXNHpI7xh6lUWfABEOxxNkdj6ZEU76ou2PKTzuhrkX2lSHik9aALtll4cmGear34/HW5
	2zmHLtQx+KErEh8jkYAm8NkU5Y2EVac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761163994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MFSmZK4gFSd0PHQz/xlqwyuF7ltItWEnpq4f0/0wTQ8=;
	b=dBHkGp6wZO7MW1SM90dJIuGbXnlRKi51xQEWepbls+vqfE3QD7EIz+rKXBzA/k44WNYE8X
	wGjq36GEjZCAEweWZExTeYoonGLWgc8wyDUkq7lRW6Cw9cJyeR8G3c+DrboBoxvLR2tDf2
	BO4Xmv1Y+OkTMjw93heBrKA1ZsEzYIY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-8qMsAJOtMkmePCH7Ug3sQw-1; Wed, 22 Oct 2025 16:13:10 -0400
X-MC-Unique: 8qMsAJOtMkmePCH7Ug3sQw-1
X-Mimecast-MFC-AGG-ID: 8qMsAJOtMkmePCH7Ug3sQw_1761163989
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4710c04a403so39545e9.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761163989; x=1761768789;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MFSmZK4gFSd0PHQz/xlqwyuF7ltItWEnpq4f0/0wTQ8=;
        b=pG7dJ9+GNd90BLjvVFzXN4l/nclKg5k6F3jZnY7cgxCLoPC89+QxEgMYRuDUNuNk+6
         r9pspnv99NNAW6JrJE3UyQgnodZrS0yOma41PjfjZb9YeTDu7YSKCwm3J2hkFy5NVGbO
         bxOyxNEhDs8QXcoXJxqnwzXhUcFgxf4dYuSLhnuvcJYsWHKw/eqYQxZs9KhbOLxcz2A1
         kmRGf2pYAORTDQfG4rawjMD4n4HAv+HbEFpadE8AhMzfwTMxov3k35gKP8sIxUsURqDr
         6Mt/G85Uwm4kEnwOIT6MPFJj1LGvnMKh2oVBwKAytH5CPZBGYCnkp+N77FdKqjw+PpAn
         Y3uA==
X-Forwarded-Encrypted: i=1; AJvYcCWDdJbekVGyKtITDvpNytyZLrql6Bg6h05WVHiOIIB3C7ieXasQe7Bc4Iatj7rMQ4Oe2wi+0U2N4Q==@kvack.org
X-Gm-Message-State: AOJu0YxAFdqHDSWL31LriEul/JBtOxt+xEg9rtBaibv5w3fTcraVBQAI
	qjksNfTOaNqJ1wEqYi2bFwt+rva1hQNWsC0goGkQuuNzcsVh5wuQmv+q4Px3Je3welEyPgEJzeP
	UYnYZt/gflGrqeADCs7J3i53Zurn+n/DKv25AlAbSR/oXZ/tR9AL+
X-Gm-Gg: ASbGnctB7p+klugyf5+7kgkDq0KuJLdcXS/zFez9p+g41K9B5UI5FSXXMQMWKzt2tcX
	HjyJ5VweCScAVXR1FeAYpNZxTE0HwS+y3ylXhvKxnSA6+N9ck4JFdyfnCwgg51tafJX3BSw4tih
	4nIxmA4AjFw8KEnH9MVnNWKYKFvsiN1LqOR1FubKluQTtakTVaYGPjPP2j09XClL3I+FOxQh5bX
	CrLbMmVUTvfZwFWTr1FQVivJz185DjXrzvfBUjWXayCqPV8/CZiK4ORoKssOrNrowq/iItB4USX
	7mqhPfTHYKcFpKG3Tz8q4VnuoYVa8WyQ55Z8qoa5TkZ9wF1VWfI0lR3e6V1Zext1s34fuIcty4n
	RdAd3nyRHwAuMVKOnTPMy28W3J9QoMEymbssVPGLNS1liILRzYnlG72yqSayGU9A/quzFLWuY50
	fNHHy8HSQVQgdENQuWwxBPlt5A1xE=
X-Received: by 2002:a05:600c:1e1f:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-4711792a2admr156597385e9.40.1761163989345;
        Wed, 22 Oct 2025 13:13:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZxZ5g6TBCinUHJsu3ifBaIcG02y2noD8tegfqlqJZdwjDCU2wn8DQ8gbi106rA8kB0IfEHg==
X-Received: by 2002:a05:600c:1e1f:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-4711792a2admr156597255e9.40.1761163988959;
        Wed, 22 Oct 2025 13:13:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898ecadbsm173105f8f.45.2025.10.22.13.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 13:13:07 -0700 (PDT)
Message-ID: <b63f9223-4c5c-4e2c-9986-02052a3d7f78@redhat.com>
Date: Wed, 22 Oct 2025 22:13:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] mm/huge_memory: add split_huge_page_to_order()
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
 <20251022033531.389351-3-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251022033531.389351-3-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gtWXYgz4VWSxLa3ouBCnITp7KOEb27Gdo0ytY0zhq3o_1761163989
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: by4izipjz8e6oetsonpy13fjhiakspi1
X-Rspamd-Queue-Id: 8BCFE12000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761163994-581107
X-HE-Meta: U2FsdGVkX18GO8/66y95PkAQ1eCAHgvfDZj6R+EMoADZX3+X/oQ/oZSDj1z9o2jR+kmOksyUJaCP9Lu0NeJO37IuLGKu3s6WARJoz4CGWptRPqjRryQy2Ar6WmdEosSJlvOv7KJUJiYVhTLdkv85yQUAuQVPBYcmQFHE/x+JYE6rx+ZMPZ2w0YHJpHU7quHBq6E0zDq/OThFsrp60khwSs1rC8hkdL9XIPWsKbrX5fjtC7mQGKps8CPilOJW9yWj2ihn+N1BT+z3Pz62vqV70Qp19SXvo51e1XXSJmXryLEjXHczZuJQa71ywv7t3uuMheES5ytnN4OLrPMgEjleqUmNmQHNSVCo2F4/yyBpxsu7xJVDEPrvu18eNgm2lRgmEu3QXdvBa2qrvSabMiGVHLgw0jr2crKaIXEPJtiu9ixj95yflJ12R4P3F+eB9J1/Pr2mooJ2isWudtr/gmsYZTSKprU5UH5cbw99+9xN6RTZEklldgklVez+QxIkDwK15EyqYpBZ8V9hGNCStOYHeT6/anEmhfk168gRgSDDr5PV/OEJbew3sBR6Opa0lYEhMVNIH8K1vn9g2bLGb1CxRBQR/JQS4SgW03h60e5eQhfsKrCEBap0xHdjg/fsGWSVXP7Jg2WFPJKZRm92XfkqGLubFlRR4izoagn5dApRg3clrYBEOrDEiqaHnmWqU1QG0UaV4rf9gmmSQ/ATTdYDHGm1MUOvfjqwyzXQW1vDlJU+NGR0ZKRTD3do9iNU6hsD2iBAwulofZjTsdyLCoJZ3kDC+FnRNPVEKvYPevmsarx5T374EoAf2JFrYyGVHlchkf45VYW/W9qCC6pX9oCRc1e4RbogaigRPJnRw8ooXVXc0kvr+E61/0LQNo7ufsxZgL/AfdiM6sLzKbiN5Kq/1kuxVWbVUJu+vvP7E8IvixUuydOxIDwTB5/5nz20fwolQUhXUozfrqV0HrOiI76
 Hi8ivWLj
 xYeetpffqjtXlgUqwymTNxiggFpe4O1AnaLg50SQtNq30SJP4Qo5foAlwU7eqc9fExXnwCojFZjXr6Bs4oUS8XJvX6GMWvhMlrSybPHXYXsciZFKnd33aQZSSG/w46ZU9VH0JJ0rUAkm4XxDHBOzt/Rrn0twJUzm4GJeG8GRbqWFDDiLI+1U7klLyftIib4CDLg0Ks9tU9XmRqksXtoYcg+bYgJQifi/gvzY2eN2YnwJHMne9sNrmPJ3/DDsUp+aGg+D/kR+0FpACZRSUNE/2tLzknUC6W6pv/dBl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 05:35, Zi Yan wrote:
> When caller does not supply a list to split_huge_page_to_list_to_order(),
> use split_huge_page_to_order() instead.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/huge_mm.h | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7698b3542c4f..34f8d8453bf3 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -381,6 +381,10 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
>   {
>   	return __split_huge_page_to_list_to_order(page, list, new_order, false);
>   }
> +static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
> +{
> +	return split_huge_page_to_list_to_order(page, NULL, new_order);
> +}
>   
>   /*
>    * try_folio_split_to_order - try to split a @folio at @page to @new_order using
> @@ -400,8 +404,7 @@ static inline int try_folio_split_to_order(struct folio *folio,
>   		struct page *page, unsigned int new_order)
>   {
>   	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
> -		return split_huge_page_to_list_to_order(&folio->page, NULL,
> -				new_order);
> +		return split_huge_page_to_order(&folio->page, new_order);
>   	return folio_split(folio, new_order, page, NULL);

Much more readable

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


