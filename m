Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F39F5CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A39C8E000D; Mon, 22 Sep 2025 04:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5545E8E0001; Mon, 22 Sep 2025 04:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C2D8E000D; Mon, 22 Sep 2025 04:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF618E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:20:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C883659363
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:20:41 +0000 (UTC)
X-FDA: 83916189882.25.23767A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 61C3C20009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:20:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ECEGrfCR;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758529239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTSpYQLpgM+WlNuI8Mgb7BwU+wlgVRKKnQKSWw8SEIo=;
	b=v8fjInhjAfcrUDvNqT720Pmf19I2eUdGwmXVxQR7KR0d2VaYYfaSaFDB6feKPHjU8sItqn
	X+rc1lXb8RDBIZBp/8zUSt70Srkw39IjTKRjVE8+u4/mgsHGEuAMva/IByuZ8C+M9jjsmq
	vGGCMFpv8sJQGl2OnQBva+EwYMnDvEQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ECEGrfCR;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758529239; a=rsa-sha256;
	cv=none;
	b=Ec+pHJq15Lp+1DqKqdocRjdWAtrEJJf5G5iZHHUy5hC6zaYVwhiUMXIdSxkDnbGtu5h7k+
	dpYSlqhj7M+VlMMUuyAoButMFrO6pD+quMbxxxvLXdxhN12peuWW2ERWTkrQ4K+4OzIIUf
	U+nEm8uPF57olR/m5GlRH/6tJe6zdFY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758529238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cTSpYQLpgM+WlNuI8Mgb7BwU+wlgVRKKnQKSWw8SEIo=;
	b=ECEGrfCR2NiwEMZFtiiedNzkTTHXgFcliwaivko3t1AKzN0XZQZX7pbRtCPjLsCY2A/71v
	JKDaVJPBVEpRoL+YW8HfYvg2g+y6o2XnSrLDSrY2DvOmD0TQnUuyAxucY6Xb1/19eVCNF1
	wvOTZnKaAr4hy7A5dfu9QQCblT5IRD0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184--_NpN3b5P2GsvyK4lagpJQ-1; Mon, 22 Sep 2025 04:20:32 -0400
X-MC-Unique: -_NpN3b5P2GsvyK4lagpJQ-1
X-Mimecast-MFC-AGG-ID: -_NpN3b5P2GsvyK4lagpJQ_1758529231
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ecdfe971abso5341336f8f.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758529231; x=1759134031;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cTSpYQLpgM+WlNuI8Mgb7BwU+wlgVRKKnQKSWw8SEIo=;
        b=nmECi5+9ahJAZb4hvypuOHBMFJpJTPHqfGmg6meARvEupC0PKac9jdLgvkwcKkZEmE
         uhi1hDQNRXmbtwn70nWxNzyw5C55iTCTaG98GXJj0sYkUhvf18XA+uBeFqAN1xGASKQg
         q45N81c5JtRpT+A/ofQdlqlCQzbD+Ox/YawuZGjV0WDM/3MUwk/I2sxNcV7AUsQ000Xz
         Y+ZXkSB1liVjnhc3xSAwuKv+lEFLqnztIQX2CTIjDaKnA6jRllTRkAqDRBiaOB2Efasd
         oFm72AI0wDwFEkXr8BAeL9+aHsU3y7q0vjtr3I7fSdiheeHlnShk9ld+URUB+iaTt6eS
         afdw==
X-Gm-Message-State: AOJu0YyqFcOj/Nn8WvYJDcFvI6aMCMzjAmGqtY7Ks6NAd7uUBNwNo4yc
	2TR15e/pxImPwSQ/lDMApqISL0tBv0VTle7hU9Zcx2DkAgrStnh8jKFJ9bj1Eu88/EnFseZsE3k
	uyICly0f4ebhKltwnUk9ZS2OmOBXtuWqY2Uy/76AG2sqBAxfdVbux
X-Gm-Gg: ASbGncuhw5C9bzvlfCvyLKN1N7LDieZ3+XnzSP5Y3b4spE8ITMitrv5jsYu3BL4+KgI
	jiqS6RWPDNq243UDAz9P1eOYN9MlMm5y5Y31TFA2CsPLpWmjH8hSSNIjeiuE9E+LRogSK4IPB1D
	9026UgESZEjhkRcJRMK3cMFizRD2GGzIilBRNFUT7ESPRSLhHcWs7jcgRegZlNIztVer1ix/HL0
	+kArSqEHx4bfEHiHmzSw/G+cSrUaR7FnW2usomKSpVM4qb7w5l5X/qfwbxzn5fmEk4HRRhDUK/M
	Mptzyl0MUM0vFO54ysI1KZO6PueKLKboUIgaKG5fHm/zVGq68LBVL1iBf9jzfOJLusbjgd6m6Cu
	+Hjr6kwTZfzhtd4d/ZR1ERh1FrGmt+DSbB4t1hEZrr+GuDsOml3xzAbc300gQ/eQ=
X-Received: by 2002:a05:6000:184b:b0:3b7:8da6:1bb4 with SMTP id ffacd0b85a97d-3ee86b847d0mr9158654f8f.58.1758529231162;
        Mon, 22 Sep 2025 01:20:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEazbIH7Du/DsNo7NjTJHkKOkoTzV8fJz70pe2Vh7GdEk0mHUE3AUP3Fk3uP3f6E62YKDdVFQ==
X-Received: by 2002:a05:6000:184b:b0:3b7:8da6:1bb4 with SMTP id ffacd0b85a97d-3ee86b847d0mr9158607f8f.58.1758529230671;
        Mon, 22 Sep 2025 01:20:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ef166e62e5sm13959503f8f.40.2025.09.22.01.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 01:20:30 -0700 (PDT)
Message-ID: <835caf4a-0218-4f02-8459-e11757d36e51@redhat.com>
Date: Mon, 22 Sep 2025 10:20:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: thp: introduce folio_split_queue_lock and its
 variants
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
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
In-Reply-To: <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fWImBLJxMazRilrZ_mxia3l7FqHzsKMbr5nYV-cNLUA_1758529231
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 61C3C20009
X-Stat-Signature: 9qfgmwqe9a1by71mxsnkqzu1o9m86iqp
X-HE-Tag: 1758529239-266730
X-HE-Meta: U2FsdGVkX19WZ0MGah9J5VOXPyXHeQ3OxMKq/iavcisoqYdh7eJikdiKKCK7VyD3m9nIh1Z7aC9Bjau+KFYWOXrY+zPbc2Zkz0IxXUiYOFaMNjuyskHDJbmA4dovfiphYc/Yc00/vu/vgrqzPPxNlpwxKG5Wl74tNo6VT3ZTEBRlhj9CUn2bkbAl/z0XZyvvhv96iOw9eTJL7mkANtDTzsWl1BrFiKNKhsAtW4CPgN7rSy8UH349n1/64rE22tXJcyWB5xrtOgh5LPnaYasir2TLYc/eh4oMQtWIPmpnGupSbaoUaPsowRnDJ70y5EFrgdB/DIY8V5JDmbGf8yuipeO/ZLsB7qsLXtNipPPjcIXQ9t6P2wBgigvhV1epMgbGnReYeOgWSI2DmPKce+ivc+jVgvXJeLI8lptNJ42Pzm+PCm8pax1yNc0oTOAWs67MFYydNBF+lMx4lOhhoUfJFcXnJmYaVt9vvq6C2xPJqZJTe6U2lIR2pbSoP51PNUwLRGKDgJDhhM4YckCyz9lz8AK4SrgUQ4RWTzKNig4zPG4RMrM5ssjyA1KLxVj6bf+46s2Urg137DUN0WWqr5iyIDWh1npsZQn/TS+W+vZA/Ovv3bgTrchwg05KWIxnc/AXcsO+TGxVwRtVN8jztIkYOYQTNEzMJKHEs3kYFvXgAuKDaYO7lSIhmitEnkZ3mXXs5gXl6D9w7p7qTiDmqHlBA6h+BxIUMr+ANV+VDVHqlFWRUUIi81rYZPUzixWfaqrlBB9gWW/DPRlucu0RhhJzNoXwm//SoKD4z4lJVNEt+jrFxaYC7PAqXJyZus5T1IX3kh64FLOuRjaPj/WvqfL8h8vAZ7XcnHvh6ZoMDagGAT37I6Cpe12RsMYsC9I7r+z+ogiOGUiULk5oJLdtd8MQklvABr6/NrYCHSNr0q53WeL+Rh1kBIZJXcJoXlhwsyjaOzRnaUNRJiCrgQ64WIW
 iJNGXvDi
 iilMHmgX52dS75qMSNVTq6niO+XmLqshMe89KIhuxWhXFXOgGucGwnNIUjqzaaQ4qIc3ER2NHN4nHYNh87sWcFd8UQSiDWUAw1JVpwtrqdXMawLVAZ6W4oZQqutgBt3My0YXHTk2rK6VpswYJQm02ZXrPNBfv7VCHU3RNJzHR7tg2TsRFqVll+9qWG0aLt+yOvV1quuuHHRgfnzbzxqDV8bP7sBUaH9W+bxCGZ6pZTa3wHNPgeqylGc6iDN5oDJ3idTWvNGOJF+ps8Mi2qL+fW1a86vB5cgZhpThMOTuVy9/IyxhjPU41usr/4Eqv9q4n7ToPxSUq4h9jIHtvUFFMolDdlwfzrK1/7qVtxkKl4lHbczjD9MVg9Er8m3HOSnkuxEYlCtLo6W5TAieFep9eEpt0iy1FGrTJOgKonNBpX+IDcwWoyYuGQz5XcaYU9Z64RPDT25hxOLSLKCKYFpRVjEo9LFs9Or/x22KSFq6afGFWsth3lDj0uU6p62qw+tDxL94WKpWl4yAsHgPmQ2iSgYEC96XCknPCRY/YVYmDGk8wE5U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 05:46, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In future memcg removal, the binding between a folio and a memcg may
> change, making the split lock within the memcg unstable when held.
> 
> A new approach is required to reparent the split queue to its parent. This
> patch starts introducing a unified way to acquire the split lock for
> future work.
> 
> It's a code-only refactoring with no functional changes.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks sane, I assume the build issue is easily fixed

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


