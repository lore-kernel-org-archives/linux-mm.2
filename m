Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD8CC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79FAF8E0095; Thu, 24 Jul 2025 10:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74FC68E007C; Thu, 24 Jul 2025 10:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA518E0095; Thu, 24 Jul 2025 10:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48FC68E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:57:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA667160406
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:57:50 +0000 (UTC)
X-FDA: 83699462700.21.C0EE7C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 689FF40003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:57:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eyNrH9EW;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753369068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1lGxamDDy0opgT+qadzIayrtZVqdkgT47I3fgf4aIkQ=;
	b=XtjV8LG+vKED7K5qIfEpokjVaRqR7hox9FMWvw1XahlPZWNPcu0qIJv/sk73+rEWom+bp9
	7G40cxp+PcBfodBBEyQzsK88W0Trf3F9xbZP5oh12HBctQ8B/QhxfbVo+R3zkZ16yN92Rq
	F/dFaX7pCdTEVaGz2U/23mNuuSJhLOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753369068; a=rsa-sha256;
	cv=none;
	b=M8HXQWRFgtX54ygspCySTVAp+Jr9C4Y9b7HffQVj+uoHxeIfdxjrzMPIWcwmR+wOmSN1S1
	Xs6v0Fw6A74AoRnwJS8OCPWAsnzx8OAPQx+Fi27s772TKa2Xp+RzxrWhrWDHj3QVeD/6p6
	16nLWQJDQ7LTNkoB3q4SLfVDQagGRd0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eyNrH9EW;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753369067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1lGxamDDy0opgT+qadzIayrtZVqdkgT47I3fgf4aIkQ=;
	b=eyNrH9EWwm+6+MwwcrNGjXX8OFA77aEF0QtmESrqdwRVk42lnJInOIN9jl+mt6H7MKva8y
	MAPMkGXlaZEOWDua3UzCa12oulv9LlqiwU57WN7XWbmDJDQVDmsIjE5kAhAp/PLkyH7lVP
	ez/PfgLACo2IOaCFEnTOaweZIK4TD5I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-aI849Fg0MgeB4C3T8H2wNg-1; Thu, 24 Jul 2025 10:57:44 -0400
X-MC-Unique: aI849Fg0MgeB4C3T8H2wNg-1
X-Mimecast-MFC-AGG-ID: aI849Fg0MgeB4C3T8H2wNg_1753369063
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4eec544c6so594964f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753369063; x=1753973863;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1lGxamDDy0opgT+qadzIayrtZVqdkgT47I3fgf4aIkQ=;
        b=ma1jtU7JhnqCjtZ9FR8ir5+dNGkrZyv0XDFAwCqMSeCnmM7YcGINmzW8SeTdzXhLVU
         +CjMIWuxVbcORXYqb1bE5SqquzNG9ELLYfty4Ig90/6MWl/PP3M7h0GTqSNdXUZdK3fI
         H4LxH73AIDGIgh11AvNn63Av2fLP+zilsyYOjvxXjDfitXpZ1jQb5rZYexH5r6U7m0Cb
         Mf6cNnew2zdH+YUBnxBwIOXwQpoR7Gpe1qo892EDuDBKh9d5cLVPtywbsJHaaPTI7eoB
         ZPVTD8IHr4fk+trAX69thh8k/0v8Cz6NWwiFQRKsH3ABSA5zUUcmVS1S371bWmeGor9b
         gobw==
X-Forwarded-Encrypted: i=1; AJvYcCV/qh9hsaqI7vshh7k2+dg4Y2DNosCvGfhSVqXTlU2/0/pK7MUwQPc+1tKS4z2c6re9ywQ51Y6pLg==@kvack.org
X-Gm-Message-State: AOJu0YzUbl31z4HJos5IxNZC0OPEjd4gTJUKTc/G9ChpLl2/XvlZc17s
	Y0ti9bnB1cco1tDeHoZk6mPPKFw+HtL0ngoswF4FaNDa9XwnNhATOFXLm1Gyp8Frm0XVGdavVo2
	E7+enKo2Aba77GFP1xCVQCE1xdePSN3RUCFwlk97TNWxb57IXMQZi
X-Gm-Gg: ASbGnctN8izepKenRwnraX5StwnXCgwv6xdThgtwdB3SGjaRdZ4g8VZ0ZiO3kb/wusc
	OEQMeHJzQL2qxp140IU9/WVse6Kv95LC6xx+ojC1bmkq7AYzLrCnEdPnEzvJQR9GUGJqv+sZxFz
	xvtd/CXEE3hqxPuTCY2EGrmSlSjADYzwP1GrE+EAhxcjM9oVMQK/2WSMs2IcsBh9ElgGEzMcHGq
	r4Ujb0kzVt6xc9GhmvC9AWXAoSNHYcJfKiuUkFBYHe4w1GL8jWL8xrT4rZKkAUT0B7EN5B4JkES
	O1jES37+vKEdbJx7Kl970S84rJWsoOR2MavJlOhxQSuKXk2O/vuA9xaDTxvDET0S17mMcDfQ+yX
	AsLJqbR50Eest600yoA7e3LAoCcAI0u0Hy8M3cJ8c96PYlC+gYtHUb10MGiQhuhUv
X-Received: by 2002:a05:6000:2307:b0:3a3:6e62:d8e8 with SMTP id ffacd0b85a97d-3b768f27a20mr5858271f8f.55.1753369062991;
        Thu, 24 Jul 2025 07:57:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2atFpMErVT16ItrzQcgOWerx2msamlrVtc7HzqwG7fb/dpPWEMAcFfJa7kucnZsr4O4rALQ==
X-Received: by 2002:a05:6000:2307:b0:3a3:6e62:d8e8 with SMTP id ffacd0b85a97d-3b768f27a20mr5858250f8f.55.1753369062456;
        Thu, 24 Jul 2025 07:57:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:5e00:c941:d6fb:3e30:b42? (p200300d82f1f5e00c941d6fb3e300b42.dip0.t-ipconnect.de. [2003:d8:2f1f:5e00:c941:d6fb:3e30:b42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc6e5e1sm2507906f8f.28.2025.07.24.07.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 07:57:41 -0700 (PDT)
Message-ID: <b2060498-d724-43c6-9e36-9b571eabc541@redhat.com>
Date: Thu, 24 Jul 2025 16:57:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove io-mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
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
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmgsLPQFCRvGjuMACgkQTd4Q
 9wD/g1o0bxAAqYC7gTyGj5rZwvy1VesF6YoQncH0yI79lvXUYOX+Nngko4v4dTlOQvrd/vhb
 02e9FtpA1CxgwdgIPFKIuXvdSyXAp0xXuIuRPQYbgNriQFkaBlHe9mSf8O09J3SCVa/5ezKM
 OLW/OONSV/Fr2VI1wxAYj3/Rb+U6rpzqIQ3Uh/5Rjmla6pTl7Z9/o1zKlVOX1SxVGSrlXhqt
 kwdbjdj/csSzoAbUF/duDuhyEl11/xStm/lBMzVuf3ZhV5SSgLAflLBo4l6mR5RolpPv5wad
 GpYS/hm7HsmEA0PBAPNb5DvZQ7vNaX23FlgylSXyv72UVsObHsu6pT4sfoxvJ5nJxvzGi69U
 s1uryvlAfS6E+D5ULrV35taTwSpcBAh0/RqRbV0mTc57vvAoXofBDcs3Z30IReFS34QSpjvl
 Hxbe7itHGuuhEVM1qmq2U72ezOQ7MzADbwCtn+yGeISQqeFn9QMAZVAkXsc9Wp0SW/WQKb76
 FkSRalBZcc2vXM0VqhFVzTb6iNqYXqVKyuPKwhBunhTt6XnIfhpRgqveCPNIasSX05VQR6/a
 OBHZX3seTikp7A1z9iZIsdtJxB88dGkpeMj6qJ5RLzUsPUVPodEcz1B5aTEbYK6428H8MeLq
 NFPwmknOlDzQNC6RND8Ez7YEhzqvw7263MojcmmPcLelYbfOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaCwtJQUJG8aPFAAKCRBN3hD3AP+DWlDnD/4k2TW+HyOOOePVm23F5HOhNNd7nNv3
 Vq2cLcW1DteHUdxMO0X+zqrKDHI5hgnE/E2QH9jyV8mB8l/ndElobciaJcbl1cM43vVzPIWn
 01vW62oxUNtEvzLLxGLPTrnMxWdZgxr7ACCWKUnMGE2E8eca0cT2pnIJoQRz242xqe/nYxBB
 /BAK+dsxHIfcQzl88G83oaO7vb7s/cWMYRKOg+WIgp0MJ8DO2IU5JmUtyJB+V3YzzM4cMic3
 bNn8nHjTWw/9+QQ5vg3TXHZ5XMu9mtfw2La3bHJ6AybL0DvEkdGxk6YHqJVEukciLMWDWqQQ
 RtbBhqcprgUxipNvdn9KwNpGciM+hNtM9kf9gt0fjv79l/FiSw6KbCPX9b636GzgNy0Ev2UV
 m00EtcpRXXMlEpbP4V947ufWVK2Mz7RFUfU4+ETDd1scMQDHzrXItryHLZWhopPI4Z+ps0rB
 CQHfSpl+wG4XbJJu1D8/Ww3FsO42TMFrNr2/cmqwuUZ0a0uxrpkNYrsGjkEu7a+9MheyTzcm
 vyU2knz5/stkTN2LKz5REqOe24oRnypjpAfaoxRYXs+F8wml519InWlwCra49IUSxD1hXPxO
 WBe5lqcozu9LpNDH/brVSzHCSb7vjNGvvSVESDuoiHK8gNlf0v+epy5WYd7CGAgODPvDShGN
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GxjEAoBF39bVWjvr-784bDKwuqx48r2sWYloaDhdKNI_1753369063
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 689FF40003
X-Stat-Signature: ipsp9fmhithk7h1h4texyng6ye6f4m71
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753369068-267713
X-HE-Meta: U2FsdGVkX1+jf45F9Oik+MDQe8azO6Pdiw9bvDi9m1RVM7KsNJacNjRpEc5C6vWiWMHGvgFusNOU9nYVKQtuy1YqvVpooe3UZ1NM3GyqBeWf9UX57WdsF3oSAxyzVEj1kHsRo9vDaQd9DwHmMOgscEmaj7vodC+xWkSeSZJWz5lndrx1i3kkBKOSEJMivJ+V+4kALIy7ZUn+glqgoWpFQeXMTkutXhoMVrq4f7nRXjIN8hS+FM0xdPP1U7u8kQRPwX4BxaXrMLosVy7UX+s4OHhkvhRwk7pYKKJZsBUg1W1Ryll/3nXEyz+M55T2UvPD+gGaHf3LfJi+5jbzNTgbjccD0aqYElP0NmRPrU5QrBzHa2OVV2G4jU0017/Rv3kMl/N4TJRfL14RVo7+WJLb9sX4Y/xAP1kr2Fev3EkjeGIu4d4kxM6SInOGFacHJ9WnuDQFCzH27ZtTZW3tHVDRJ8tGzZOJ28NLMiNdrgzOIJbTYRPYuclmQwJqmSx1aoVAiEh+QGH0NfRrIqqdTNVCUVCtdt2MK30MlCNt/WkjXo3PqAPlWFivTqyemc7rfKn0FYQncAUR1dQqf0NGBxTmeLw1cVMj2LpfA3pksPppCyzqPn7yiVhc7H95lvZzcWI2eNzP3zg99IhccMnxNclspcQFl9IF7eoegwv4LuX9wUZmBnwmNOZeaIHvNZ6WVYcu4Ns0I4cNLxLKBcMOulpgUQ5S9vL6DMreQbKPfWwvSjOIY6xdpMcKiu9S0sXK/Mey+P1QMt8gUgus6dUliH9j8b74lMvTi1FJwu16K4sZDl7g0BiK0jWrdprMVx/si8ptcG5AqDC8PR+bQivcyaj8RlvPBSWqSF0nqkoDX1++rRLc4s2AxL2CuKoD2hMaWLO2IBjA46WzLC7u9HE/aq4C2ksU2NMkNjmBFoeuXw6SoamiF3902+bhmjUW1+9JT6QkbXsjUFME/Dd939KUd5+
 neZuGbYX
 WWc739L0ylB1yPLIhBQtZM36uvEOlGgNpY1kephDSx1/ivcrT3MQFSrhV9OBeE60xvu3lOITqcAzcCq5BoqJ2MQfL3J3yUtBHfsSEP4rgf8fXpKNP43dv7Z6gy6NpS6sZWKwtI0hPf4Wo85aczCUahRAUUsYLw91leqc9u1QeEjiwRVjkAGVhifQQCRPteiK3pGrw44bsy7H+FiDzzOXFdMMtfYfdsdosLC0E9esHaOSh/dVmOKtpyMHTnrWURQgLKjqQjTStvOlYoys9uNrakbyLkwd1aLb4BgiurnerHhLFZZoPANbIi5ZMrFUWIncE+TxUXSig/Ax7tOULfK1qB6tKtEjGgg1k4uSH8yPMTUYXJZnzZMeO80TuhkKfR3sviauYfAqOG+Vr0ofO7Zx0noAwkz4vZI6GkzF77fiDtunzruQwyFSDpT4mw8WQrg9Z37WUagdHBYA0D3NmYvrYIl1jXV2WTcUvubO6DqDnX2XENV8WNebH14Mzs5QEjlz6Jh01
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 16:53, Lorenzo Stoakes wrote:
> This is dead code, which was used from commit b739f125e4eb ("i915: use
> io_mapping_map_user") but reverted a month later by commit
> 0e4fe0c9f2f9 ("Revert "i915: use io_mapping_map_user"") back in 2021.
> 
> Since then nobody has used it, so remove it.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   include/linux/io-mapping.h | 231 -------------------------------------
>   mm/Kconfig                 |   4 -
>   mm/Makefile                |   1 -
>   mm/io-mapping.c            |  30 -----
>   4 files changed, 266 deletions(-)
>   delete mode 100644 include/linux/io-mapping.h
>   delete mode 100644 mm/io-mapping.c

IIUC, you're dropping the MAINTAINERS entry in the other patch already

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


