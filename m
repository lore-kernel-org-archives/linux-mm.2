Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8CAECCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 07:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5608E00C4; Tue, 14 Oct 2025 03:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC498E0005; Tue, 14 Oct 2025 03:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD958E00C4; Tue, 14 Oct 2025 03:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCE188E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:24:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A4935B07F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:24:52 +0000 (UTC)
X-FDA: 83995882824.24.3513189
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1990B180003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:24:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=imjZItOE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760426690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWVRMEm11rNZj8S0erLvsCvAhmyyCMMtTFXiGsJH80c=;
	b=lNwtgtN+Ik5G24p3YsfauQ7vMGLGH0c8XzstujgzIw7FrxqfOA3vfUvRMzMU+Jpmuz1kxt
	padAcrc1PFebWFbStoxa196ZXLszy64L82firlVTIDKTcXmgWCFLF8HP6ebvMN/rh1fYQY
	5G3ApHrcbxIMg4nA9XHPGID2CXCzdA0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=imjZItOE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760426690; a=rsa-sha256;
	cv=none;
	b=Xv/4vhlQH0cUfS7BVSivxfsrihf5TtKxEBcU0k+CRb8fuVTLfKnYd3WKHX5X7sgLW7BjRs
	++S6OeEF/CchKhwwyokjakIj+ZXR9i7G5FxEMKQsirjDSBdgNmVaC6QhFrBwL8oeKjALpw
	nsXdHTKx5YXctS4QVkZjt2ULKzsrNU4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760426689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dWVRMEm11rNZj8S0erLvsCvAhmyyCMMtTFXiGsJH80c=;
	b=imjZItOEGATXEmry0y0Z/BsPsHY8fnrUrSsGZsDKyX1JnqxHFKRyxIcXd6may0o8rfoB10
	eAXnBHPOI6A3ZNT9CMxpxDjDHBWauE+RDDdGjOIn89Vn6rFyjsUftjGHiv8krKiLWUG3e1
	PSrkBhFPrRS5+qp8QolT4ur73ELZKd4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-lNTmD4azMqmgmgsf_kNyvg-1; Tue, 14 Oct 2025 03:24:47 -0400
X-MC-Unique: lNTmD4azMqmgmgsf_kNyvg-1
X-Mimecast-MFC-AGG-ID: lNTmD4azMqmgmgsf_kNyvg_1760426686
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e3dcb36a1so38797605e9.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:24:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760426686; x=1761031486;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dWVRMEm11rNZj8S0erLvsCvAhmyyCMMtTFXiGsJH80c=;
        b=aGAYfBtHoBNk/zz4juiuthn46WiGYCmjF2l3dt1D0arHBUesbngp8HZipVO2aH2/6q
         hMq/LEPGnlVqtb3OnADCwSSnELzjWwfrgxeYUS7Vt3ZinDXH25LXaR61mFFWW4EsnzR5
         fMuhLNGL/IDBXrVDtuItqBWbId6CvYA/0ucktsZWayLirzIs+cdSZuSW3pp+1sIVuW+z
         xECCChStlFywBgUMyeWFQJxG3u9CTcSU+4sLi9Zj+vDJ+5FFpZ1eqbC4uKli17so9KrF
         R4/u+ygbpOlXXck7RN/PjU3CX3tPw6f/BA4GeFzc/vCqk90L/WhbBMXqPMnZkLQwQ7E/
         Xdfg==
X-Forwarded-Encrypted: i=1; AJvYcCVC9/sv4jnAm0NBGvYKm5Lq5DXCVo6HCmmtc/1siYLYQ1+DaCwIN5YsQk1npecpdj9Jf+xI/k6qtg==@kvack.org
X-Gm-Message-State: AOJu0YzyR/ZYhIZJj+8viJT0tX1T4/YoCAXkWeGcIkf3uydVL3YDOF8l
	9ONHq/W0DNPKZciIA4zVI26P+GPW7lEI5f2YRQb+8+uDaR02dnElYm9PoxpfPuZFhAnIdmBnY33
	OcqOQOE8wg11z8M9w0oJeRMdOQo15US4yKgZYYkdA1BkJiC0omzJb
X-Gm-Gg: ASbGncthaTpw7RB/JpGd6RxPVEHCOF/NwmGiCYxf/ONubz6+xS0yey3xz5xh6cajF4V
	V21074JhG746NnbbMjvy01CJjt3rm7zXGo/qKKmaQV/3vQE6IQQtAzgP7K7aekt0XXPfjfLBMqO
	GBtVyFmimgR3A1LMe+kPpHWh8rCoPOKdj4xuUUMVD25YzTapDJ8ADfj8WX0CHnqmOXCd8XssQ0D
	Z6iuuEQVzMgmez94NOplZdtfjwZb6zGYwtl8Bs345/dC1Y+dzTPFPy0FgLUK+YsKxLMGNOrHAVd
	BJF4ywdBP6lGvCyoyXiJ8LfMPvkArmJ3PaSqfdUWG2DQyUOj1wIlcP/pvZWw2rL8emNYO6ilew=
	=
X-Received: by 2002:a05:600c:34c5:b0:46e:3d5a:d15d with SMTP id 5b1f17b1804b1-46fa9b064bcmr146297115e9.26.1760426686135;
        Tue, 14 Oct 2025 00:24:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGC8FI5kSvwYT/CgzZ/QfWD6LZL5gZynJwlCP6Ew1X9IcwxCSDa9KcsHDZPMzIBrxy028sWwg==
X-Received: by 2002:a05:600c:34c5:b0:46e:3d5a:d15d with SMTP id 5b1f17b1804b1-46fa9b064bcmr146296865e9.26.1760426685693;
        Tue, 14 Oct 2025 00:24:45 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4982b30sm222538135e9.6.2025.10.14.00.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 00:24:45 -0700 (PDT)
Message-ID: <2a48209c-13a4-4c55-b35a-6aefd4ae92f3@redhat.com>
Date: Tue, 14 Oct 2025 09:24:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: huge_memory: use prot_numa_skip() for pmd folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-4-wangkefeng.wang@huawei.com>
 <c31abe19-f13c-49e7-b305-d899536ce9bb@redhat.com>
 <c4feff94-ea84-4610-a836-e1f2ebf800a9@huawei.com>
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
In-Reply-To: <c4feff94-ea84-4610-a836-e1f2ebf800a9@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V1tJRG5zmTo-N0PWm-RzGtF6a4Y7PBOeX1p2V_EQ4sU_1760426686
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1990B180003
X-Rspamd-Server: rspam03
X-Stat-Signature: rb3nwd7a38pqoja3qrfcionqxqw51ftj
X-HE-Tag: 1760426689-802005
X-HE-Meta: U2FsdGVkX1/qYFUK6+yjkGPEgq/1ek+zxjOCpt1FojDETYdcysTgG2leNhHMxqBQs5gzrSe1PGDgxCMt0EZdJmKGQHakvjahtV3AJaKxq0xuB5dwIi3JB1KSQWk7a9lIOyu7hGSdNrMEHjGdiXQFUdmrv60CeivIlKVux+qU+jJkdk69TaBozDEF57lZMVuDaskmpbp54JHgSas9LAe9xVx4PIlWGdTTxJgGLQRh4xwWKu4lQbuulf2V2BPeuXJqz1G5dxuK7rGyBArgvrQXA65pXrI4RlW1jBskTjCbsCfOZblMlvnUI2XygfrtRp8RwKw6FTU29l4Odr8JGX7GDNfgWq4nutE0CqkrnisAKUZ15SK3c2fEYmAovT8iAvR5oNdkV2lVojluYjcOlbnodXXQazeUxsRll7ivqli0w0xjOjDUL1vQ29KeOiIvlHjanPqdh2fbrX/nDah2pUaRpNAF/Qr5Cw44hFZvb12MN2mtvj5fDpl63fDHjcjFxxjRa52qbE9f7iXKwkoChSOsrp6maZ0P9A6naSRrPGvlM07Phj+BuHoPYryw+CVx1U8W62pKlvBI6RHZ37tOUlGdEw65X1O4SSaHU7Uq7Rlp39bjpWV/boBw/+ovHi2sRxoPVZ+pIgaCFrsh1OsxEbzj3VUIiTF5E9sDWfvnxDMNYIC14JoWu11IU3QMnIG1JGVM4TgPtXrILBLhqtcaGlK4TXbDmm6bhLPcfMjV0lH6XvElzN5nisBGbanCKq4juxzQXly4AoPGz//yU1YmXaI6Ljz1bhHGnzl1QXysagiB76e23JT2WZCzcPxpCW3/TUs2SFfyYZFh6nwkiUPN+w9rIMxpY/nmWuMqFeu1Sb5GGYToZY8Da35c5ED8rIF2r9J2u5aKJOywiWyYy4EO3AWc9S2YHOck/bQKXCixXxpELvhGyv6Mn2TgMT8R3syXW/gY9H3GYSG9jmN6O8P3NpJ
 sC6Lv2na
 M4c/yfQn/gOEMStDzTrTNe1X/Mj37wMnc7uJ7OBxFCxM27QxyohdD/6pM9QPeDqGd7QmPj3su/PQ2hUX2CpAQGP4HCe5Y0sgBV6Jp2Asbdhb2HcSfmsrXN/AIek5KXkgLql/62S0FO8PqGk6hAVkfTaaazE3/8WJZLsN3B4fNHBfbEAR0lNpluZ+6fjDYkavyYjrVqKW5uCZs2r7yucRISEJp3t6IetppB9tk+OrvMYbJUbylyFV7843gpbneWFph7zBcLlZVvs0AZ0k2C0UxXJ22xECmiqoduJSdOlPGLHzLFwwrn3TSSLS3x7c87U0w4/E5ADqWg8+XvliHxDbz2bD/9nJCwhvNRVAf0564N7BYqVvRi3rJZ4gTm/DSZA0Qbxcss4s0V6f+NcpxZ2skxz0NOiC9mpbOgPEPGVQR4AZ+sqtbDsNxDnTsNp6/stz71ZXR3jQiYLuSUCSiMJta4R5DAaDnleKkhkcC95Ldyje8t11ocg7QlAxlWGcCYM/a3cAdgW9mOv84MUSWGPmeT80PWtiwM82sfxRMLRwi9huvgYw9CQSUrq123ZQEB2TTKWSrYF2RU1NZrQlfWvjfH7WN4Ph137B+6TzfJDQj/4T6B/OCbNRHFkfeKmXc8+3HaVMUaRuroRLhDO4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 08:10, Kefeng Wang wrote:
> 
> 
> On 2025/10/13 23:58, David Hildenbrand wrote:
>> On 13.10.25 14:15, Kefeng Wang wrote:
>>> The prot_numa_skip() checks should be suitable for pmd folio too,
>>> which helps to avoid unnecessary pmd change and folio migration
>>> attempts.
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>>    mm/huge_memory.c | 21 +++++++--------------
>>>    mm/internal.h    |  2 ++
>>>    mm/mprotect.c    |  2 +-
>>>    3 files changed, 10 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1b81680b4225..feca5a19104a 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -2395,8 +2395,7 @@ int change_huge_pmd(struct mmu_gather *tlb,
>>> struct vm_area_struct *vma,
>>>    #endif
>>>        if (prot_numa) {
>>> -        struct folio *folio;
>>> -        bool toptier;
>>> +        int target_node = NUMA_NO_NODE;
>>>            /*
>>>             * Avoid trapping faults against the zero page. The read-only
>>>             * data is likely to be read-cached on the local CPU and
>>> @@ -2408,19 +2407,13 @@ int change_huge_pmd(struct mmu_gather *tlb,
>>> struct vm_area_struct *vma,
>>>            if (pmd_protnone(*pmd))
>>>                goto unlock;
>>> -        folio = pmd_folio(*pmd);
>>> -        toptier = node_is_toptier(folio_nid(folio));
>>> -        /*
>>> -         * Skip scanning top tier node if normal numa
>>> -         * balancing is disabled
>>> -         */
>>> -        if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
>>> -            toptier)
>>> -            goto unlock;
>>> +        /* Get target node for single threaded private VMAs */
>>> +        if (!(vma->vm_flags & VM_SHARED) &&
>>> +            atomic_read(&vma->vm_mm->mm_users) == 1)
>>> +            target_node = numa_node_id();
>>
>> Wondering if we should move that hunk into prot_numa_skip() as well.
>>
>> I'd assume numa_node_id() is not particularly expensive?
> 
> There is a atomic read, it may be expensive for 512 times atomic read
> for change_pte_range().

Note that atomic reads are usually just ordinary reads.

IIRC, the relevant code is

	cpu_to_node(raw_smp_processor_id())

And raw_smp_processor_id() is mostly either "current_thread_info()->cpu" 
or "this_cpu_read(cpu_number)".

But yeah, we can leave it as is for now and cache it in the caller.

-- 
Cheers

David / dhildenb


