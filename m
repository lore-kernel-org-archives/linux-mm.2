Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E45CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 11:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C501F8E0013; Fri, 12 Sep 2025 07:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27EB8E0005; Fri, 12 Sep 2025 07:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D908E0013; Fri, 12 Sep 2025 07:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A368A8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:36:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EA9AC07BB
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:36:11 +0000 (UTC)
X-FDA: 83880394542.15.AA5BB56
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8A1374000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:36:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XOj2mOFZ;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757676968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4WTNdMCGh54uRDM/L4Uxaq4pm+e6gS6JQHYqsqi25s=;
	b=wttq7EQvmWFm1K+7o4nYw00sXQjIb++HgY3KSDza8XbGIABBKX1cVtffoEeSaZvecvvlUv
	plEq/3QaIkNg5A+h3mknBzANQn2q+MqEs2DczvSXNZtCofWJkO0Yzjr6vK76S8xz6FCn7k
	e3YAj/mTY9aCiM76nBT9vO/AJnfgUPk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XOj2mOFZ;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757676968; a=rsa-sha256;
	cv=none;
	b=HJNB3ucP3bFgLx61TwBkGT9Novyn2XhiHp04BitqMLp7A8kZa0kQjQ+x58TV8k6R4/1q7r
	ZtKaoqH8o0M4fRSi/C/oDkLRvYEKOMrEqjlDTKup0vnjCkUqrNcBVhzLBWwz6fSCGXVv3X
	Mc+YK0s5nP7926ugQg6VdHcL5ZVR+ZM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757676967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L4WTNdMCGh54uRDM/L4Uxaq4pm+e6gS6JQHYqsqi25s=;
	b=XOj2mOFZ9fzs7SqurF0FUpLkugTTqOXC6JTSoQFXQKKtK2P3cqUH+hv52Zroggs8OUAMF8
	ztYhs4ieaq5bdY+745oMRqnWwkNZlmEXVIWz2hQzf5OyEjAG8r+/wlgthu/hD6/qLMSqdS
	ZRCF/W7TqAdtY9be0lSkkE+4B2VSHFY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-6rJqPVBUPTaxjr8xShhaOQ-1; Fri, 12 Sep 2025 07:36:06 -0400
X-MC-Unique: 6rJqPVBUPTaxjr8xShhaOQ-1
X-Mimecast-MFC-AGG-ID: 6rJqPVBUPTaxjr8xShhaOQ_1757676965
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de27bf706so8772275e9.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757676965; x=1758281765;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4WTNdMCGh54uRDM/L4Uxaq4pm+e6gS6JQHYqsqi25s=;
        b=Do54UYDXi69vERZaj0MB3wG05WCSwn/zm6djpKp+pT2q522rhNrciXTrZtAQqekUkn
         cZfRQqp1P6WApxA5LyFy0WCAsAI6ZgQip6RkrKvuxoF0blwGArcJozYpc/o6TTk9EWgi
         hi/5cFWnu2wHQEY6BgzTTgmfz39er4iHsry35FybmW7dTBffCfsKDIOBIqjjB+O5Nzxr
         PsD3AHVuAgSkYYl/33pR+8cdHGi1ZF/yttV76ueFaIs7ch0A3RmfVaJErIquhyJTdvpO
         GcZFaLAQBl6ATIEbXw684nr0AdFYJ3BDXJy7jHU4lS4lTEDCKp4yk9luWvcqAYW7i2C0
         DmoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkyPkK9mMtZ51ftSmA3Ji8yXp9i4/pwOzbRqXjYT+e1M6h/rYdyEo8u/nHxSCyykAOyDbUEamRsg==@kvack.org
X-Gm-Message-State: AOJu0YxtOclWqlB9mY7mhuAG6EVXSuojLuxkKEQZfI4iGSfZKPXHLsKi
	GAKLdFt3XIMLKRF81kMkOZpwo8YsKUdw4w1SFUnOt0lRKwBNZc5MU1twG2masE5CraWKnXCZpzB
	7QyhUsVoFrrqgVPrG4cCLBz28UUoC86JIUXdcfhSp6kvKc6DZc0EM
X-Gm-Gg: ASbGnctA3+zMtNb1Fwwa5ks4ME2NZUpW6Hnrd7aX1xPcsqyDKYouhCn8kMP8NBDROB/
	o3gEt5phMsHD4iwB70yBATEmmYgtW9Ygeg0lCeNB3X6XCMGvJ9b7IGoRIpEFT4sbyPBpUFhReGB
	0m5M9JCbp3OmD5BfdHefklwf7wNxqwSZjyZKApiwsqIyxHuoGDNGG6sqrbJi3p2/Yyfnrc3QNVS
	anIt3yEvQ56JQpMm4u8+aVMGkiOSx4CLUtZsZZiaodpNkY5NOEkY033tvF7NxSSYAHDm62BFyL7
	nlve5GafZHTeMw+Hs2saMBTvKflWLe2ggGvE6d8/K/mFvOPb+gy/peVueji1s8hNhxq60L4k6j/
	HsorIbf4Hi+nahULpwcCGLi9Th54Iyus/gOqfnJ1e6k/JUQzWSjhS0txZnnbXUmh7fxY=
X-Received: by 2002:a05:600c:4e4b:b0:45d:cff6:733f with SMTP id 5b1f17b1804b1-45f211d517emr27953585e9.11.1757676965172;
        Fri, 12 Sep 2025 04:36:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEApCot1i+5m775BUiDD6WRxTCaO0+qykFG5pVRf5Sw41hSYWcT5lrn+50Nw2D8nJepyAo5JA==
X-Received: by 2002:a05:600c:4e4b:b0:45d:cff6:733f with SMTP id 5b1f17b1804b1-45f211d517emr27953335e9.11.1757676964784;
        Fri, 12 Sep 2025 04:36:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760775842sm6503959f8f.7.2025.09.12.04.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 04:36:04 -0700 (PDT)
Message-ID: <3f739d3e-f6fc-4a3f-9bbb-151a6dc6c083@redhat.com>
Date: Fri, 12 Sep 2025 13:36:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: transhuge-stress: fix potential memory leak on
 realloc failure
To: Haofeng Li <920484857@qq.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: 13266079573@163.com, lihaofeng@kylinos.cn, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com
References: <b6f38984-5f89-4a9d-a905-ddcdbd7510a3@redhat.com>
 <tencent_43768D3DB24034B62C249781C1DE7359C807@qq.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <tencent_43768D3DB24034B62C249781C1DE7359C807@qq.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1bV5IxS07F92IyQCvYotZ1FuATyaIFREhVyhEfmUv9Y_1757676965
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A1374000D
X-Stat-Signature: zojysu4ic59zu3ea3ig1op673muthg9p
X-HE-Tag: 1757676968-35699
X-HE-Meta: U2FsdGVkX18+qCVPtgAZ68tXMSJqESyyRV543sXl6v+yKdnq3HgAlmn8pkcw7uDCyqgfDqku8/LphApvd5K5mr3xU+lSMkIL0YjluysXyz9a3AfN7OYk768Dy3VhMhagt3IJIZnL2zyoP+UT4a9kydO3NwVMrVS5pOHbaKTllrSQs92yt5JcZav2BCNqTbZY/0qY48IbhyobnfWXihnjtvUDsVKdUwUJVMQQ7NB7sayqPrcX9TMEpfgrlsfWN9hv2lOff37Uh5hOwH2OU6BvuOMVsFDd2Sh24nGk/7nukaEQnVqMChDL4qdU0C22UbYIYtddG8Qsamo51mnl2l/M2Vw5MpnzqRy1zrujByby4xrLhIhpb5CVDab5E1F0eCo3t8Ha8OKJygM2EFGNgauH159+cZ2/T4IEnCyOS2J5COk3cVjDsiRQK5ZDqZ4OnPpt779xPda6+bSDzm+R3tamhfa2yF6J4Lbyi5ClaNErU+UcIz12lg+VX78INQUYU6Jr2m5lB1TZnAm5j1MfMCj2qZEzidyAltnSg0GGNsyakcLFqzvc8WpfU0KZgffDlGpZWNtMPVoIUYgEx6VvWMMBm9L/2lFgdAU6W4pR5cWKyFKXeCwdfPttniYxDZ6PB+xez9Ixe4ZnhX7bhcFiq52XJcY0y5dpD9jp6lxXO2Yo1y7QNeAYPIh3E0pdNjKNHKmShN0vKfy+fOkVIDEnBnRh60ZyxAH5Jorqd0P40iklkwMtobGANUWQCAATmgay3Y3lWF8mHxSPS/8a1B8F/88f1tvJYafJLrpByQX/uwwU8Md+7REZsEsaaU4Evus7/jgHl/22Z2bhK8H1fakQx5a1N1hDjEQxCs6bndQLfCQ0QhnvdOdHHDgddySDChJ9mtGRiN2tWZSQfR1PynAD+3P3RJ5+hnrK1KEOInBs1Q+KwkDvdQzv+hlqUQBq0j8RNq2KFnfYSG51O2UPlSJIyoy
 hsr115SC
 50x3bpBD6RGJE8oLJTLyziSQkMHTWVvBMrsbPSsvNNarWuWqB1iUamea05EFUiTZkQWDjAk6e/s8of6Om5+K2Qp79a5M6Rmrco1MgAybF18Uxeq/jRPjGpphzeB5laFwYgV2SWHIZWVwK3aNQKh02FZ052u6kgOHFVSmjJuvd9jyBmX0LQYB2FCLwrFfy0mNAoCdrOx5FE1QZg7RBWkgCdGpC6ccU4AF8T+4RG8diCUpAlybPWSSViUHhXIKvKeibPxb5TdiqiJ1jqmygmcpFbxdiCqmr3h5+IcK5PcYBPpcmdq5fK0TEPmidTf8RC/lRkZ2pJXpT3lw2OUoZBu7UMs6n+V6I7YwY9qrRgJ0kJceCL6JpeRq2H/woWthmTQbpnrttjGFRYI33hm1VCY1QVrUhR3Y5BXvYD3EF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 12:10, Haofeng Li wrote:
> From: David Hildenbrand <david@redhat.com>
>> What do you think happens when a process exits? :)
> 
>> Correct! All memory ever allocated to that process gets freed, avoiding
>> any memory leaks.
> 
> Thanks for pointing this out. You are absolutely correct that the operating system will reclaim all allocated memory when a process exits, so there is no persistent memory leak in this specific scenario.
> 
> I opted to add explicit memory freeing in the error path primarily as a practice for better long-term maintainability:
> 
> It ensures correctness if the code structure changes in the future (e.g., becomes part of a longer-running routine).
> 
> It maintains consistency with other error paths in the codebase.
> 
> It prevents false positives from static analysis tools (like valgrind).
> 
> I'm happy to adjust it if you still think it's preferable to remove the free() in this context.

No code changes are required. This patch adds more complexity without 
any benefit.

-- 
Cheers

David / dhildenb


