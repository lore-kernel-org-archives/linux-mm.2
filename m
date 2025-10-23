Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3742DCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C538E0011; Thu, 23 Oct 2025 08:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8948D8E001A; Thu, 23 Oct 2025 08:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735488E0011; Thu, 23 Oct 2025 08:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536028E0018
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:08:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F23A140AEF
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:08:51 +0000 (UTC)
X-FDA: 84029257662.26.837707D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 47C591C0016
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:08:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SJ3NKsMb;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761221327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDORFIj6LWJd6SZ2RygkaAff/6awra6AFeTsMtEbgKk=;
	b=4Xs9f9G36NFJT5mfOaIPzdf4q2UpH48vlMcF6J5zO0P6HULLNmkMm/iVSkmiaIwM+U7XZz
	CbIyk7f/ONbEP6Y3YgvcodwlWyXv/WvV5dGtPnot+Jui+D4J/LgUcQ3fYDMpz//7Wbva/o
	UdpIe7iWtqHFa351o75rOuO4WwKYHoQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761221327; a=rsa-sha256;
	cv=none;
	b=i7m/jpOJr5PXA7Cn+jX6U2OS8as7CYnCYDZ0mGyikUfljtzw0ydEREEciiMJ4nt+RSaIaP
	azOb6P++5OUpHhoGaWaVwdUCw0Ox8P9PBS3T8fUPia3xVtZquEHU/knxe2pjt9TkgH8xQJ
	eZOYe6yYMQXhEIH4pyiUqYfdVyHyKhI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SJ3NKsMb;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761221326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UDORFIj6LWJd6SZ2RygkaAff/6awra6AFeTsMtEbgKk=;
	b=SJ3NKsMbUzSsqH4YkqBIxOUlf0P5Fd5YM6clzR/cXP0/BCbaO0bq3UsnkxFo8gflwOwxkJ
	Ym+6DyA8ptWE2TD4Dg58Ny2l3LvzGufBdKQNVS16ii8fuIuwkLK7KFjzAOnKn/o32delcf
	lzPFs2C4x9g86KQo0zWVLE1/sfQB7v4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-5Veo_gAZOnmfbWUMp6Kcig-1; Thu, 23 Oct 2025 08:08:45 -0400
X-MC-Unique: 5Veo_gAZOnmfbWUMp6Kcig-1
X-Mimecast-MFC-AGG-ID: 5Veo_gAZOnmfbWUMp6Kcig_1761221324
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47111dc7bdbso4063895e9.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:08:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761221324; x=1761826124;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UDORFIj6LWJd6SZ2RygkaAff/6awra6AFeTsMtEbgKk=;
        b=PU3g2s8sMYXVK1czZklhe3nqpNu4SXq2jmxYq3gOVVFGUsyCEcRR/rXMe5Axk4xAon
         KG7GfOMn9ZHX/yRIzWLLB1sYEbWRl9a7sSYoiTvia42U7kfb1mFuWBgnWkDm6FgjRxjG
         n7wIRrYIEwtKOX8ZIgy/K1wWodMCx895jHlnyONe0C0pMr0Dh/QypmAEeYME7TKow+qt
         /CX/svOBMjxLO5WDSXBjyCrRGOV2NLYo8R959c24ITOHc9+Y3UGJ+uBKRfi4mIyZrUDj
         y3i2bZLEhMZQq3iv1oX6S/1Glo3mzEeoa1/p/PhLX5whMLGu3a+VPvdeC6tAsJ/LU63O
         R7qg==
X-Forwarded-Encrypted: i=1; AJvYcCVxfARSSnRbFjVU3WmZwdG/h8vxGYDwadGzGmc5K9jPA00W4qLLTVyNsbaSQWC5H38gwJS7QYklSA==@kvack.org
X-Gm-Message-State: AOJu0YwjclUeqPSLiKusTJddoNcBZvoZ1NDVZFErTxpxQrtnwy7hMw+F
	CQLcotyvr8+wy81ruPIc70VLVIE604ANpCud7WTVh270+3Rdg0Uixb0oB7t7zxfWEMdTKFa85aQ
	yE6L/jiYwpZA6Ud8GGRjYxbkDfTtAfXs0HGVoRRSpUFDH3FvrMSIn
X-Gm-Gg: ASbGncuN809CgAZRrDTPRfGrZLnL025n7/QIoomQcJDsaHVHlYlBGNQwDOeBTjfSZgr
	+0mo/Io/lTH0TKt/xexW1jJzPv6NjD5R+MGjCA14tL/Vib42Fu+y/uGGAcAK12YsigKKtmkqNS1
	G5mRAbMKBrPxfyNT51tatKNcelYDJkHxM0HIyHXZr3qG321ilMpYqUwA/qHhRdKdRLGITTV5LVc
	FQK1mjOwFFYKsmeB71Jf0f9e6T+Zq4stUwQCMcUPIltkLeUvmxic34/9fZY+WwuQCN2HP7QEMCE
	/ebIJjHoFyPC6JqM6R92QGCeFP9xfh90GsRKiVWLsDcCRO/JD/n+OLv3EAALYRFoWwH+Lco1Olb
	e88NHTm5zGmDsbYb5qLd3x2jWOwG9gRQVE1y3CCEtBLq9aBSYJyzp1aDxlt+j5cFxlf+1OXJ7rJ
	KktIujY6TmGAQpWbttIY6AWYkgYh0=
X-Received: by 2002:a05:600c:4707:b0:46e:506b:20c5 with SMTP id 5b1f17b1804b1-475cb02fce7mr12688215e9.26.1761221324063;
        Thu, 23 Oct 2025 05:08:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwFlVD02zNNZKZxMPA4Md0aHRgMaon4ljV7uspd378BaUZtl/HGGLI7YbTAQ1YnzBymb0WvA==
X-Received: by 2002:a05:600c:4707:b0:46e:506b:20c5 with SMTP id 5b1f17b1804b1-475cb02fce7mr12688025e9.26.1761221323642;
        Thu, 23 Oct 2025 05:08:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4342860sm93120155e9.11.2025.10.23.05.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 05:08:43 -0700 (PDT)
Message-ID: <0fdfd2e2-6b4a-40da-a303-87233f8a53aa@redhat.com>
Date: Thu, 23 Oct 2025 14:08:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
 <55p3kov54tjf5cr2sm3h3z7hv5cq6nlcqihlyxa427pz5mtkuv@nddjx4onw6mq>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <55p3kov54tjf5cr2sm3h3z7hv5cq6nlcqihlyxa427pz5mtkuv@nddjx4onw6mq>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z_SjbSvz_uQTGzN72br5Of91ufRFeEi-kc_1DkcLtJk_1761221324
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 7wxpcaphtwt5sh68xpax1436etikrkq7
X-Rspam-User: 
X-Rspamd-Queue-Id: 47C591C0016
X-HE-Tag: 1761221327-573095
X-HE-Meta: U2FsdGVkX18g2E4+4y6Ykkz/tuJMwsy3dP3/PoDEWntPQekLDPH8Frii/WKAv5ebTDEbscrB5HzL3W4sgojJEz53MZaZTME42kjA8JBKQ8Ipsunj2o5KFkbzD7ktTsw5wL6lCjyBmfduX5SqDCkJYEm0ZLcW5jho5gOWkuNTjVy3yC0XzETqB/eo5pPK9VATMN+fmZISLTl+Pm55GP6IB1nhi6J4xDSvrWHxAArlTYxMTVWfEALlOOn4zb11hAQIKCzqy2fGV30hixbeAhyfVa204A0Jh9kDDnWWz9K4VCj8BwaLqRruv/829WwAA8u5yR/qbnz12NKlD7lp+2KuRL+5Dqq4+qcIwiwBq36tOIMJikUI/3cEzPHSfHuHMMR5ygzegyayUC2w2a13jzBhUsLa6JqxOqgsMsthZqL6qB9OPArnEVKzuf+3iftRCOjJ+Lruy0VkL8yuYP9Q+cNX4eccA7K7t6cCPjQVWYtXzeoz8B7FBoTwH/OCMLPd7ITKB4+qveCOD22TSPS9nsd6DU2M85AA4UPZQOQ+5e+OLuzo//BATgNU80Wyd8+jHJ/cBrge3Z2rU93m1vqf8GlePCq7x7D5Xc375/A9JHRapb6xbYJUZMo2VJWOopHfXITZXOjLILoNce96l4R5sg3jplLGnORJ+ESX8iJq2G2GrmqZrd/gF7dO03ty2PCNYVNZprERATn5atzgs8q90rlOIxY29QtbZskmk7ROKN8EWMRwL0F7BmWIMyNrLhnqNhkDXpZTzRMC/SVa/XzBHztcFrx0f3cNiaOOSw8sD+KldKmCh8eZw7NRr9w4onaC6QI8PZT+/9tm/sgVS4ny+Fed1USeQN/7olrdCFY8qftlyNVz+KGY8V//EmF5MeSz0Pjln0NZE5sw8bdlCgSUm426IAQ+gdp4bFrXmviMS/+Wp0ldx0aVVCr3yXsp5CvrCUlnT4JbHG8G0OGIfYkUYHz
 EkVs4+h1
 TIODuwhYWm6Atc+nxQ6H3NK8tlB+EkLw0jmazMvVoSAjk1wvvdDARZm9NyGBQmYE8xe3pZeO46LXClScKl2Q2jWeJs4ZXt+iTLy88jb95YK9vvyAsiIbZmgJRWivG8bJ/oJQP9C/Tjz3qF9u5OUMkxaV3GKMe2C27XLsPH6Jajt5jU2OEtpttp2Mrkgkz5sX/D1S00OyXZNdbdDDrwQOq+hGsa4mZKyR5DE7fPRcED2YNuB+31BmxDiABbGkku4bqRILOvMHUntNx6DzCqMuO/L1p/NU1/ftMNoQL35tt/z8lohedntoYCxHprU/tSfdymbvki4zyTa0qlm4o03F9KyPfYdjLVwCekcLR5Y2USuWIfKrgHMpXokp6FRmlkK7v3WQOUHA4aY+VcUiSjBFyIl29wQs7r0Q7c+HpE7WXF6gSV8Hk9JA93IS3sA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 13:09, Kiryl Shutsemau wrote:
> On Thu, Oct 23, 2025 at 12:54:59PM +0200, David Hildenbrand wrote:
>> On 23.10.25 12:31, Kiryl Shutsemau wrote:
>>> On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
>>>> "garbage" as in pointing at something without a direct map, something that's
>>>> protected differently (MTE? weird CoCo protection?) or even worse MMIO with
>>>> undesired read-effects.
>>>
>>> Pedro already points to the problem with missing direct mapping.
>>> _nofault() copy should help with this.
>>
>> Yeah, we do something similar when reading the kcore for that reason.
>>
>>>
>>> Can direct mapping ever be converted to MMIO? It can be converted to DMA
>>> buffer (which is fine), but MMIO? I have not seen it even in virtualized
>>> environments.
>>
>> I recall discussions in the context of PAT and the adjustment of caching
>> attributes of the direct map for MMIO purposes: so I suspect there are ways
>> that can happen, but I am not 100% sure.
>>
>>
>> Thinking about it, in VMs we have the direct map set on balloon inflated
>> pages that should not be touched, not even read, otherwise your hypervisor
>> might get very angry. That case we could likely handle by checking whether
>> the source page actually exists and doesn't have PageOffline() set, before
>> accessing it. A bit nasty.
>>
>> A more obscure cases would probably be reading a page that was poisoned by
>> hardware and is not expected to be used anymore. Could also be checked by
>> checking the page.
> 
> I don't think we can check the page. Since the page is not stabilized
> with a reference, it is TOCTOU race.

Indeed :(

-- 
Cheers

David / dhildenb


