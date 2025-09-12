Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73225CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 13:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D069A8E0013; Fri, 12 Sep 2025 09:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6648E0002; Fri, 12 Sep 2025 09:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC248E0013; Fri, 12 Sep 2025 09:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1FB08E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:28:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 857E91607BA
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:28:36 +0000 (UTC)
X-FDA: 83880677832.07.4240DC0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 156FBA0013
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:28:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X5I+cn03;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757683714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxCuVeKIYByX83ELv08YQNod/eiQVC5gVFgMvw8risQ=;
	b=BU99g9wzM5yt3WkwCnIwWU2YNSbwi3F60enSfgAgOONcGNnr1HobEG0r5zQPvfBYCDAJT6
	gjmJIGkd/c09KOTM6JC6pTRuswUtMqAD9OK0aeSrYb2m/BKSWpNRzq7VW6F/M+1ARxdiYU
	fe5fZOv3b5AgQl1T69G6IUSTr/WTIZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757683714; a=rsa-sha256;
	cv=none;
	b=Ac3UHVoC6v9y1ANAGRIX9i6o/ktoKgcqi9zNV0TfaLQvsgZkhcvXqMf5BAKHIv7xwJt0Gl
	5lE1QQpQyePnD5yjC9DFG/YteVgImY0tBCgBkDNTcDIqnBF4wc+c+CRdYWB4KJNkJE0Hyz
	uvl67S6UzOFisYbhfVCzEO+dJaovsR8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X5I+cn03;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757683713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TxCuVeKIYByX83ELv08YQNod/eiQVC5gVFgMvw8risQ=;
	b=X5I+cn03pwz0xcNVp/7hMikhRn748AoomX19RoC1+A7oqvRdb2LxD4CLdp4lPirEpWCEZ+
	DLCU66svhIsSGZazdXRfkUvMIvJIiCAt5+6d66EYr6QsWwVVSkuqvcjvme+BBiMazCra+w
	h0fvQqqP2JKXVEYsJH1s7/4uGeddQxY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315--ccGAkEGMJOVi5vXFFFVEA-1; Fri, 12 Sep 2025 09:28:32 -0400
X-MC-Unique: -ccGAkEGMJOVi5vXFFFVEA-1
X-Mimecast-MFC-AGG-ID: -ccGAkEGMJOVi5vXFFFVEA_1757683711
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e7696b36d9so383889f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757683711; x=1758288511;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TxCuVeKIYByX83ELv08YQNod/eiQVC5gVFgMvw8risQ=;
        b=ZDM1QcFztrXAXAfy9A8Zy+gQGjNMrKW9RCQ3ypjOU1yHhQiJd0JaBvnB4USaw762G9
         oF6JugsMKI2yHPKoFsopEWbb30xKZbOX+HMQ5pfk17OY+uNyzwv4ObiIpwolBIpSZcBP
         LKHGB8JaqC7v9C0GHCJ29+5npJB/fiNQcbOfRth55jq/Kzv9De7dHZh9okhx+/ObDj+0
         8p/jOR3K6z22ihzBV5qLJjR+QuSHu9VQErXKqvuao9LrSBz4tfV12HvA5D+X1qCUoRVI
         gtRXlFDedKYI6KPFxYE3CGa9B1C9osRmztnYcD6NVgnnS61a5yAB28626irLIWJefPOj
         Bfbw==
X-Forwarded-Encrypted: i=1; AJvYcCW9szBUGoqObGPnMBLjuEBtvVOz0c7cPSI75xiEY9EiiDukzmQXmc52wZFEQS6uQjPB99q4ZTXLqA==@kvack.org
X-Gm-Message-State: AOJu0YzYsCAc16JEZCwkUhooRk37c+H1RdprvxKzwmr9KsUbpSOHftAr
	wQBEXedRB8pxC0K8j2kZBptE5pXF8FGUSXvajowLwuA5tyhorMCoQLKcmC8jHS6eTiE/0997oOF
	QGq57rQDzg2fm5U3IAsO3e6WHcM7IfbA158WP/Uu9d5sFML3WfX/T
X-Gm-Gg: ASbGnctPIHdlf4snBnzZ3r54Ft/5j8ZO/thXp1TlqGcV8eUyHyB8YBn4qZuGY0BC9fQ
	sVq8cZeG6arex2xGXxuAr+uXxrMKNCYHnf1WcW+2wI5UznMaX1x489X93m/hDG5fCZzLQvkamJd
	Giuj7iEFjH2fQjDuJnHmgQjyjQupD1jRZzoBkNGz/pFh1WxK9aVnDg2YK5HHHDrbh7og5opqr5Q
	nPPB3+Zhky5KnWl8R4rI62J+f590m+7fDZ6M7w1KAHa2751nGrbt/2bk+bPYyTQUlV9z24J7F9w
	rq/UphJE5w5DlbjRQoxu65OovZzGx6J6NlwF2G/N7+7uAWkjsBePGktoGrhP92eg6w78pJa4UEu
	zqyiaOz4Q9fg/uU7Bnbm3wrxrp+4I3YbTPMiZuzLoolvwhRVZgVLeasCdYZUEeD+WNic=
X-Received: by 2002:a05:6000:2384:b0:3d8:3560:59f4 with SMTP id ffacd0b85a97d-3e75e13caefmr6723691f8f.15.1757683711142;
        Fri, 12 Sep 2025 06:28:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb2l7aN1/8HIAcICiml5mSkrzckyj6yy2pKIKfzYSogTxvyEF5XddWuqkJ2hocBG9MnDZbvQ==
X-Received: by 2002:a05:6000:2384:b0:3d8:3560:59f4 with SMTP id ffacd0b85a97d-3e75e13caefmr6723659f8f.15.1757683710722;
        Fri, 12 Sep 2025 06:28:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0156d40esm68008195e9.1.2025.09.12.06.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 06:28:30 -0700 (PDT)
Message-ID: <8ffb72f9-7d46-48da-833e-83ffd8e32a5b@redhat.com>
Date: Fri, 12 Sep 2025 15:28:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: centralize the __always_unused macro
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Antonio Quartulli <antonio@openvpn.net>, Sabrina Dubroca
 <sd@queasysnail.net>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: kernel@collabora.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20250912125102.1309796-1-usama.anjum@collabora.com>
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
In-Reply-To: <20250912125102.1309796-1-usama.anjum@collabora.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q653FwBobuWxsavUIgmfRJx5wN1MGFAlNSiqXKILd3U_1757683711
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 156FBA0013
X-Stat-Signature: nhiqmh3z4oncepfqwk3756mmpnx4o9qd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757683713-730060
X-HE-Meta: U2FsdGVkX19y3TRwaPhst+BgAPULiigaFrye90lT8LIWnRI4FE4w2Yl/V/R8kepuY/IfeOUhpbokksdP6KSrKfd4IdLUElW+gTuYxirSToH11gY3Cq33SUD1rTc1hS1Dc56LzFWH+m81QgNtFSf81leZGjmkEdOeTdXoei5FMawwFyKh3IYCgr3n4NZiaK2ZhPNatp78C+3BKHKJb04eQoOSX2IOpmZbFMbxBpk8RNqGoCqdJl3oY9MxioNkYPRvpAuEsi3njA6zRz4CPPxHz8KGjKNe0D93ZdVYybOiHPYzS7ZYKZfJM/utjHoJf3NwqSRBCNqGDSqi+HbtyYUtMmoa/ZxX8NU2ymNobQXXZflL0usaeVMd52alp5cpINt6c2L5rgVbpJYr+HoKGiuSTTqP1uCg7ovErgY0ZuZ7iwCXfMkA7ybRvEWpOIyoXOt0gl8WKHhuJMjwcwnzyL5kkP/MHPNroSZxXQRDhs7tzudc8beF1Hn9ZclThArtOrfHj2I+DCTJfN0h/mskmXE2xqoFiWhmN6nMr0Bdw6iZeEHN4PjLpG5Zoh+4PJnPZnROJNPaPppGjmXirAJyse8E5ukRDj/VRliHn0KtWuYoxuX1jLOGqZnuiQiKNJAP4g/iCr2f6UnzEhGYlshN4G7pjAk4n46R5Sf5FYHo1VyMvoze1kGGZcfWBW70/PX6w9tdJ3D5nmThp5lto/YdylWpM+YpBxsEICAHfxzd81yCC6p/yCkgfpg52SAdvFdsYl24WahWVQcUgpKiy8xoPOoyohDDRxqgTtMfVOf8kWGanb5wETJTklRZvmRHOQNoLOeQfxX2BGj91y0fj1yGZvBej/PHPnhnC/X2w9ardTYDvaH4TfNP1q4dHQ3rBx+K1Ztch1dXvkXHIp3j3BpWazeTnFargIb+Qh5YqmNO+KgEPL7wtuy3bPilAlewOZyU3+aLaM1rrcQU5v9wQFR0yz1
 r/VWWbUj
 L8U8SwSWwhe/a8ZTbdmyCSRaaCDCYVO6gT681CLlb9OEoSG6wBCceK3caMLXIvXs8OvKFz+aNV5kcJTA0r/kODWWwUJITUj27JyXgzYERIeXXXdo6ckrt0aXitPDXtvNPqh6dFjz8Bg52/Am+yAtntv/TWDV00VaWAB9i5o53u5sQC+HwMxOODu0s9XCq8Z2AvxPuvRhQEFzEBl76sdcdl87MVbXNTsGx3dlcpvJ8CR4F2avw9bH6mLd8fdqQ7kTLXatz7PV08YyV6xZ96Avk9OTcMK4RKHlxNvjQEM65GgZaxlZWxh//6rL21wiPwUeZccR3zLaH/X5jSHlm/TxBjesc7TZvr/Z95V18onPWOiNV/XCwXeauGcTp2Aky8+aKrGFmHUZWMwbvClA4HUSokfyAlwjPHHUAvbAkpLxv6SDLll7nCmS7ZUjK4rn/yV2Qap4yxOMIhp9GBhE3airtf0SFLhqlr9MKI4crzzqxQunguT5G2oZs8DAgWMYwg+gWlRzAfst5fdwo49A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 14:51, Muhammad Usama Anjum wrote:
> This macro gets used in different tests. Add it to kselftest.h
> which is central location and tests use this header. Then use this new
> macro.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


