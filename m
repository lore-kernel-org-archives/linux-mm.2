Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B904CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE38D8E0011; Wed, 24 Sep 2025 05:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC788E0001; Wed, 24 Sep 2025 05:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9B88E0011; Wed, 24 Sep 2025 05:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6E298E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:44:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5993711ACE1
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:44:28 +0000 (UTC)
X-FDA: 83923658616.16.31A3BAA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id F051D1C0008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:44:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ym2fl5Ds;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758707066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LATvy2V6SYrxON5S0ZwKxz6/ssurKvZ0zpsAbTZsXD4=;
	b=6w8EQaCSF7w96MFT+mKBNt2pJKfItgIsppY78/M27eGAs4I8gaeH5EpD5wLW0G7jkfuJc3
	FOLPoQ27GKuFRxlb2Ml7PTjR6l/RgK5QKG7xygMY8PBnHOD/ZCYZlEZc3eNMVmkil08g7a
	w/4nUR+WPxyzpxAUDJUxzMdqqSKV+Pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758707066; a=rsa-sha256;
	cv=none;
	b=PATIOm3JQIBy/GP2nzEfvKSIhvgo2ZiGZi3mOsRmutCWzaAa4sNUwChQXgcMgEQFLqfrjr
	esT9NfttBw6f6vZJdNxh26Ni2gR93BfIzfEM+k6dCC8IX/053pJeTOwHT3gkgy/9eeWW/0
	gxr9anUCuBNLRlBNgl0/JZkxEMaqEqo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ym2fl5Ds;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758707065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LATvy2V6SYrxON5S0ZwKxz6/ssurKvZ0zpsAbTZsXD4=;
	b=Ym2fl5DsEBP/zm3pmP3tCV37bPoTuhLZTx3SXhSRx/No2FLicoa8MslT2xHsSYV1flh3UQ
	YXJd4+NCoJt4CSDVyu3Ps1BMSK8bM+9oCcc2wgYkwWzICsFKdOX+dQ4QKprC5eRHoTotYY
	+ok7+B0AeZHI+t66KpmExa3j0ITYx88=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-N4uZ5oY_OLOkGDcE5HHtmg-1; Wed, 24 Sep 2025 05:44:24 -0400
X-MC-Unique: N4uZ5oY_OLOkGDcE5HHtmg-1
X-Mimecast-MFC-AGG-ID: N4uZ5oY_OLOkGDcE5HHtmg_1758707063
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4612d068c47so45928965e9.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758707063; x=1759311863;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LATvy2V6SYrxON5S0ZwKxz6/ssurKvZ0zpsAbTZsXD4=;
        b=oHQVR05BK26681XkHoYfDDt7reI/vxh+mHBGRSuucn9byo9Q0yRsy9w5nbKRk7C/Ec
         FY6Xl8oDV01D7hpzYHHphPtj0Uru2PTZ6nfSxGQLyH9q6Pg38SsrdLaBrsxBpwVshyQe
         5/6DCW+Pqshu/vaP1ph6i2pSb1eTJMnIHhkweHNZuuOTaz2zf+ZKc3hvrQETYxum9Jm/
         bwOF+8100mBsPeT32it1+TNUmj5ja/3SzxVQvq6n3yiwgMPFYbtPqUrdwhUj6HxMmVLe
         B8hrNz21uWiYUDRwkl1DDPfTjowmtAh9u+fJFh8qIakWPQuYe4f+rRNf/nhtmaeRmqnd
         +ThQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6gY5iSIE45JhDB1rezEYN3b8SEK4gU61Lkj03Y3jkV5dCa5R+BRei4qonDVjz8SiEpxBfe+saXQ==@kvack.org
X-Gm-Message-State: AOJu0YzVrLGxRsN5JsMx1kPJf+hscUbWsWytLg1vwru6ZyzfG4IUHqYM
	mNctu9VcZsFTFaJo1oEw+6sFLENaiKh7vnplKSgnwBdaMZrkCmAFQlpOsH9W6+2aacDyI5yf+5j
	Q6oBOAEB0n2z8ZFQscbM6nGkhMfg1Uabm0OelccxvKSZ4AYUmJfrQ
X-Gm-Gg: ASbGncsY+OUrSuwDT72KJWlVvTd575ndRpfeW8XXTL7bAxtkIlAkoXnR/MXjyvFebk3
	cdhoPpnfIqza0lSQ2q6bLd7hBquy7xgSBvZfCdSMCM4h4pWeC3x0ApmQSsZXw78t+2LhUrt62hl
	EmPdOInQA2dDb16L45hdDjok2msI2Ljf1w7Yh8JrKdvdIq8fREBizkWcomWYnb8ggk50rE0/HQV
	FZjNiJtSZEpDPjITtpoVMQtCqTGjr3nKK9JC9/mKR4UvdyOZLbyE1hQph6DtsR6vBYG6M+bFXE5
	hsI1UTgoJT3XmV49i9o+X+8WK3NMAadIaw5WXsqiLDBrxu2lxhB7VN25A2OmFf82PgYcyPcuvf/
	LbtqUyQ2EEsnHoRqrUZ+8kC/MwyOT+BZAdm08oxdYo4GJf2XfE39eDlfaQlKGBxxsJw==
X-Received: by 2002:a05:600c:8b4c:b0:46e:1ae7:dc1a with SMTP id 5b1f17b1804b1-46e1dacdeccmr60077215e9.35.1758707062742;
        Wed, 24 Sep 2025 02:44:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtajsvp/kDNdAlIZ81myaBdoqXgoPzgIMj71ym20C24BB7lOR6FEuJDw/hq3ekdj+UMiHTYg==
X-Received: by 2002:a05:600c:8b4c:b0:46e:1ae7:dc1a with SMTP id 5b1f17b1804b1-46e1dacdeccmr60076735e9.35.1758707062201;
        Wed, 24 Sep 2025 02:44:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2aad99f8sm25671645e9.17.2025.09.24.02.44.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 02:44:21 -0700 (PDT)
Message-ID: <791e0d59-0eb2-481f-bf8b-ba4b413d5ebd@redhat.com>
Date: Wed, 24 Sep 2025 11:44:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, usamaarif642@gmail.com, yuzhao@google.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 voidice@gmail.com, Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com,
 hannes@cmpxchg.org, kaleshsingh@google.com, npache@redhat.com,
 riel@surriel.com, roman.gushchin@linux.dev, rppt@kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, hughd@google.com,
 willy@infradead.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, qun-wei.lin@mediatek.com,
 Andrew.Yang@mediatek.com, casper.li@mediatek.com,
 chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com> <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com> <aNLHexcNI53HQ46A@arm.com>
 <f2fe9c01-2a8d-4de9-abd5-dbb86d15a37b@linux.dev> <aNOwuKmbAaMaEMb7@arm.com>
 <17dabd83-0849-44c9-b4a2-196af60d9676@redhat.com> <aNO7MrQt9oPT8Hic@arm.com>
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
In-Reply-To: <aNO7MrQt9oPT8Hic@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cvAd2Kfk004Wp119sqqYjO8b73S6R9C3U98fcg9hUaE_1758707063
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kecxk5f67e3unuybbuma1u7deamr6qqu
X-Rspamd-Queue-Id: F051D1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758707065-881700
X-HE-Meta: U2FsdGVkX1/9KvzOHFEG3wSOv4SdoXXgpfTQBrj2EbHJhRQIV7HNzORkuhSiPEEw3qmnNBWrmNIInqGDnSh/SAmYlYvuS4Lsor47F3o0bxfbVkkWiKU1FoczQ26/IL4tOuy9P1gDXPE8btDStlr9xBqENSQIKbRjVnBZPHxc34Ql18yUB/4sUmLHxU/EY52h3Ybmq+ul4bXWw7+RXAUCF8LZLkxYQiePnbDfJSV2OV5stskbYFJ1ZeEmdTEENCHFIAw7Dkaw19b9BInDpQlDl4S8TIuNnM+b/pL8i5s2Qtya6HS+J6IAYWYE9b//Bu3xiIF4qZvre8NnDud7wNAbIRYCT3jDY6i5tuh1EnmG/l/x1JDol+MNEopGGfUKq2X2yHHUFRpoHozbArJOTj/P24MX3MkzBaH01DIolRaQHBUK3SIh8xJXbBVmG+ATpdHrLtXOVc0WCTKL1zfoKSTDkI198g4SUOYTIOrw0/L49atjLWt7ZQx1zXI/slgYN+rDn1E7DYAA0K35c1jpClnCsEW7CeZXqwWjep07SfoDl3F4sWBPweorRjDuIkLnKbbcOAkbvxcy3rtrVTjkqo+eyIr0IwNQLVyszAvixu36Ob1NmughtF10kGlK1gPE2qbIzYx7gyO+zL/jKVnloqB8Fi2SWZ2wLlrUMr8uMDnCBr7O79W2Uk4QX9cy+EbDZ/MzYFFyqRT70yiycKBLJ33bJxSTaaBmnrgQ9i7RU5Sq2wrrdy7A5Tyfkn6ADMcvaTCsswOxBdQDziV6UwtCS4vRFMsLftAyYhyliGcEFXMpTbUO4SfoP1IBF+LQhc4P9Ph+i47DhOXadDTyX6YilsAkjtpYiiTJydwfUElwgmnaKnr90hXDEHBTBhB/7jdUXKMrEFWedPuQlvhOkE+YZy1t8EDnQ6iomQvexUUqTW3EDZrdNWRv4sbCb8UDc0sXcCcFhIXELQ9hrj3QcAdjVkW
 vLtfYlle
 MiJTFkX9OKy9lF5T1Y3/pnwC7YXS2pU3vvz06oPyoJQDQtclI9uF9sKUvmY3UjY41BEqGDGqRpxI+eI5bl/XQ3tVKUA5+sdJqZ9Ax/6Nj1mAzSllMlhRUtEFFIPoXgUljaWyE9fqDU8C5falmttHPArhst0pvK4zkyHxMvHC3f9ohrXVcozmiarCzTQo9QieiDSbyHIe6qc03kxLosbcsF/gTIcCDBUQnSz4DjSpd3aYpeiHVKhZZrgJg2ZA1LETPajQSGG6UipJJj1D5I6DUWVvBBlO2y16rOOe3LzGVzaEFMoZx7Wq9kVshR573uZMPmoYTi/ZJt5sOn6DjHK4q80epVMYBdUnTRohrz12aXLJXsyKrZdUaHVz/G0l+7hlh9nhyFGxcuDe8RwesZzrn37b+5HZem2b2ivH1mwQb44GhqF+DXYQUA7P6BZhZdCku2r7qUKBF+HLG++Ur3ORUGQca+Oo7xR38WuJW/VtPWRNSDiXtW7WOP7/1etx34shb4VG24EwI72S8h/55JZAFt+rN2pYqn8oXfWnMgUvA+PlKAkS1j7srYHAoUYk+23I8CP9zdvDfBOj8U0k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 11:34, Catalin Marinas wrote:
> On Wed, Sep 24, 2025 at 11:13:18AM +0200, David Hildenbrand wrote:
>> On 24.09.25 10:50, Catalin Marinas wrote:
>>> On Wed, Sep 24, 2025 at 10:49:27AM +0800, Lance Yang wrote:
>>>> On 2025/9/24 00:14, Catalin Marinas wrote:
>>>>> So alternative patch that also fixes the deferred struct page init (on
>>>>> the assumptions that the zero page is always mapped as pte_special():
>>>>
>>>> I can confirm that this alternative patch also works correctly; my tests
>>>> for MTE all pass ;)
>>>
>>> Thanks Lance for testing. I'll post one of the variants today.
>>>
>>>> This looks like a better fix since it solves the boot hang issue too.
>>>
>>> In principle, yes, until I tracked down why I changed it in the first
>>> place - 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to
>>> the zero page"). ptrace() can read tags from PROT_MTE mappings and we
>>> want to allow reading zeroes as well if the page points to the zero
>>> page. Not flagging the page as PG_mte_tagged caused issues.
>>>
>>> I can change the logic in the ptrace() code, I just need to figure out
>>> what happens to the huge zero page. Ideally we should treat both in the
>>> same way but, AFAICT, we don't use pmd_mkspecial() on the huge zero
>>> page, so it gets flagged with PG_mte_tagged.
>>
>> I changed that recently :) The huge zero folio will now always have
>> pmd_special() set.
> 
> Oh, which commit was this? It means that we can end up with
> uninitialised tags if we have a PROT_MTE huge zero page since
> set_pmd_at/set_pte_at() skips mte_sync_tags().
> 

This one:

commit d82d09e482199e6bbc204df10b2082f764cbe1f4
Author: David Hildenbrand <david@redhat.com>
Date:   Mon Aug 11 13:26:25 2025 +0200

     mm/huge_memory: mark PMD mappings of the huge zero folio special

     The huge zero folio is refcounted (+mapcounted -- is that a word?)
     differently than "normal" folios, similarly (but different) to the
     ordinary shared zeropage.


It should be in mm-stable, to go upstream in the upcoming merge window. 
It's been lurking in -next for a while now.

As it behaves just like the ordinary shared zeropage now, would we have 
to zero/initialize the tags after allocating it?

-- 
Cheers

David / dhildenb


