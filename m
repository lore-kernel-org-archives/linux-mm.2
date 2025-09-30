Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BFF3CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEB18E0018; Tue, 30 Sep 2025 06:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F6E8E0002; Tue, 30 Sep 2025 06:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37918E0018; Tue, 30 Sep 2025 06:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 957EF8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:06:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3BE865A12A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:06:56 +0000 (UTC)
X-FDA: 83945488032.30.4185812
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id CCF5714000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:06:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LiZiDh3H;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759226813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fTfzX6psYUT4OkchLBIQY85g/NkmbhOcB7C6va1ds8=;
	b=SVGd/Gpm3vEkEnRAPa81zVh45gyS2z7vi9Hxh26ezgK7s1iaiKDJ4GtkXvklLGfiF1dLFo
	Vln63Vbrn3n0kDCpbmIQ72lXRxZtmC6r4AzpWZaC6bYBKcdsPVwaZkaaubtrKaDeTlYEvR
	riDduybALxr55WGuhrsWxLzjLBwWsS0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LiZiDh3H;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759226813; a=rsa-sha256;
	cv=none;
	b=UnzJTIZjO5fj+HCYp/vtb+5y9eXYfnd1uwv/t1FG/LmB49djuEZlym44uj2IliWoVaefXx
	RpwElAykeeNerkzAMUyeVl8kzD8kIgvNgLdkivjQnvPFnjOLC3uyce0UPJ0Sn9wrW8aaCB
	dEByHbpKjgCtHdE8BnwfrsuO2dLRuiU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759226813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7fTfzX6psYUT4OkchLBIQY85g/NkmbhOcB7C6va1ds8=;
	b=LiZiDh3HPzyXe8HIMzQ3Ld2RDdpKE778rZs6HMhFugg1b8i1bE0OhPWFHbjt1/sOvihseW
	hhZ199KmCRauhGlnVZYozcZhHjYhVxgkeOGnwzNMvG2ESw8cVJ+/oh0SrIfVh++/7x5spS
	L4EZee30V3hDfonek4NxESVJ76BwNcM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-ByqzgxQeMI21xyP0rwJevw-1; Tue, 30 Sep 2025 06:06:51 -0400
X-MC-Unique: ByqzgxQeMI21xyP0rwJevw-1
X-Mimecast-MFC-AGG-ID: ByqzgxQeMI21xyP0rwJevw_1759226810
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e473e577eso20982475e9.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759226810; x=1759831610;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7fTfzX6psYUT4OkchLBIQY85g/NkmbhOcB7C6va1ds8=;
        b=VTEKc8QrtqwLsNG7sxwznQBWyWYLS6fdPbSZhBh7wLkJ4k8SZgexrHZkmrQik1Ck0S
         HzqkxRYT/vqPzWeWPwyYK5+X7FiPpRpef/s/k4IucLBfC+ArkrCWNXIJTJ7atF+LldVF
         LMC2Tv7uKRISk5TkU7WoX55sRRJKg0cto8gTORp6GG1YvbS+VT8IFxp7MA7BSKdz5Ypf
         Yp7tstRifFThAykvqhdmxhzn/dZVDeUYDmZ8XgU/syr01vPjBW317h58FzrPWfSd1AYE
         9tKFAH0c1KTg1BqPJsFNqdUlmfC1ZEHblAkEUMaL8I9zWCX+wnpkhII9yG/e2lO3p8y3
         h2PA==
X-Forwarded-Encrypted: i=1; AJvYcCUEZYh5+1VxgayDMF8L+/mtNjbMdWiVB4gTIoEU97OVP2qil9W3BR+hY4I9gqSA9Y9cE8Fsl0DN7A==@kvack.org
X-Gm-Message-State: AOJu0Ywt/vu5Xh7f9GvCrwaSv2k56pkGlBNEt8xYAJmz7hYKA3S9Zr8Z
	garO/ADyPR6M8ItEV3vy+mpaNbXYn4d9nKACeTf2jk8pp/SwDSkPdd+4jdl9sv3eSgc/W9picnw
	x1KW+E7teGBRsHTLiaGGjLFUt9rQASilKcSPPUai5LoDGxCSKvsgr
X-Gm-Gg: ASbGncvLBJ+dwQEk2KOU8gspv5oVv+R0SoabUhGkoEKw67vWCNEcRRzQFJNn7Q3F2vv
	Si+UP7b9ZXmVEnO2PUQOFgns1IWMnIF+IbmE0geeuSLXcb5d94BM6hvZtO6s8R1FZ5/ueX19Cxj
	d9/jqI/BKgZ9w+H9UovTcCI9Ctcctvf3PHkbNNSTUE8klAKUUOCsTjB30XRl3wVDm01tPWKSBtj
	GFRVGDIASZYOOAK4R3s8Z+Cv2XrXzuxOKa5NnDH+0me2TXDf1Tn19kfQ8co0R34pmP+9hUSJ2rP
	YdpUccCRiqNtRRC03wNJNAW2RWFBoegxq7wiBkkGy8V+zqTM8RnajofSr3VBVYt0vbfRSfH3RUh
	0mMnbMAYU
X-Received: by 2002:a05:600c:6303:b0:46e:37a3:3ec1 with SMTP id 5b1f17b1804b1-46e37a34304mr171263655e9.24.1759226810032;
        Tue, 30 Sep 2025 03:06:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElXr7UtGhHOOqmnGXgS3DIU6XD1GGKEBJPjIRNitjHPUMTj+j0+YLqSrDlUr+2K0hhWhIOlA==
X-Received: by 2002:a05:600c:6303:b0:46e:37a3:3ec1 with SMTP id 5b1f17b1804b1-46e37a34304mr171263405e9.24.1759226809627;
        Tue, 30 Sep 2025 03:06:49 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e3bffe67asm175528505e9.5.2025.09.30.03.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 03:06:49 -0700 (PDT)
Message-ID: <d075fb47-5f87-44e1-8d04-b3311c7b7bc6@redhat.com>
Date: Tue, 30 Sep 2025 12:06:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] mm: page_alloc: add split_non_compound_page()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-5-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918132000.1951232-5-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yTJAet3fYWtYx5ZMxKssy4SgSGUJCOc4q3IIBSy5ce4_1759226810
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CCF5714000B
X-Stat-Signature: imddak5b8g4ane7besroyksg6xom9oog
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759226813-668705
X-HE-Meta: U2FsdGVkX1/vL9BrgUpsYJwJPcUmPrpoRJRvNhnmmEwV2jteqpgzYbG0wlZ42KaieO91d7yCMoWShLo9IwiM35G8QqXepWBuDWzEeFkSwbl266Cbf0IVg4Vipg9AzyjAdKxKFPFUovym/2biQF9xy1csdcGD2UTujAhSslPlLKtMM/0+hezJQKLMr2OYaI3JUF08kaQX8T24c7gWe/ffaGJ+sosNQQy6vZWr57PrcPJm+KoauIRFPPuCWxIvU4Wa+rBmdNBqASfTxBQI+y45WCm8i8tkC9E/10c5lc5Bqr/smJOkDj4+18Ki5o7qrcmQAWa/4haeb4cDWnSe3A1m4VGf4CNZ6F+mNS95xy1L3hK0FviH3d5nbUPy6gjrb4RTYp6rPzuG9nvJ1kCIhyfboqhUuUbUfq/zmtrA/1YPpqX4j6rV9E/YDx1n4b68bsFrjCha4iVhl6lSdgDtUiz5y9DmnMioFhnGM+jq+yKj3DaD0vJES9RU8k555be9WGpbPHBOK3YXZZ3kB3CcLGOGgcBInfwejN1w9K3Mf0Dh6dUUA75OlUstIxBMbGL/8uHDQ2CB2Kr7pi72Hj4lZxg9rNIfA550HgQrjv6Vsa3vCxEgJFju38heky8ZZOY3orIs71ARgdJU53pr2dyAMUuqALFY/Y7a3+twytqvfcHfYDS6UfDlXTWHfW0lTxM/TJ4KpsvlLkYBNgAm4JuuT+h/u40oUIrMQXopw3vtWb6UjuOy0iP4a2l+eQCSyxnkPUIt6rPmUDTxdYQtnAP1J7hhn08Hl9fuCGa0skBnStXlzpy4P2lxS7LYr4LmeqvnJI7QHHuylzptqjGoVOFgnFAth+OFtqHIAgztje14FE2V54FiQ+6cvSxBElP3+yCw4rxqTFTdcFwP6Oc3RKI2yhoNSlqh3hPv12eNkH8nTkcKDe9G/vZwhZSVM02Nax6v7dxjh4pvnjBflezFTALgdR3
 sJbPbnje
 eLKVM78aBRmj1gP0tndk8x9fHEci9H1fiTuBUOp6NQOy7ioLlR0O8N+APA9gsEX8WLNVVcXy2EQok7nPFblWNF4FQdAp0UIA5ZDb3IJ/aPiz6YKQq/bIPkGcDywbeF0MWr62S/PHo/0lhjKkRPKdWKkQCHcBYTqzdTC3uVuEcOpe3diN5CwjkjthOSN/LYEmZQHYOWiVysWdACYXvCQeJh3J5pv8HBZdZbzkh3s02+scm12BIIR/Y3bo2OXVr3aojqlw28rWEwHUTLXJK13dwWU5hMxF0YtBWwBhscvNZMLDUUIFUO2UKSGTNJ6VByE7sVqlosb4ML6ZzTkQnpTya3PoJssQ4spKKqiKdBwoYaVnnR5hU3QSvY+y/P/fPbi6NbgFjXwG8JX0hrZR3OnLsfjLKw8yWX/0YqqTR0psvE2XaJrDbY5uEZBlahg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 15:19, Kefeng Wang wrote:
> Add new split_non_compound_page() to simplify make_alloc_exact().
> 

"Factor out the splitting of non-compound page from make_alloc_exact() 
and split_page() into a new helper function split_non_compound_page()".

Not sure I enjoy the name "split_non_compound_page()", but it matches 
the existing theme of split_page(): we're not really splitting any 
pages, we're just adjusting tracking metadata for pages part of the 
original-higher-order-page so it can be freed separately later.

But now I think of it, the terminology is bad if you look at the 
description of split_page(): "split_page takes a non-compound 
higher-order page, and splits it into n (1<<order) sub-pages: 
page[0..n]". It's unclear how split_non_compound_page() would really differ.

I would suggest you call the new helper simply "__split_page" ?


-- 
Cheers

David / dhildenb


