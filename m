Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC89CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017CD8E000B; Tue,  2 Sep 2025 05:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B188E0001; Tue,  2 Sep 2025 05:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9B18E000B; Tue,  2 Sep 2025 05:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD8EC8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:06:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6DD7AC0BE2
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:06:27 +0000 (UTC)
X-FDA: 83843729214.12.3DB13AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4771F80006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:06:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fj6UO1+X;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756803985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lw+TgGPA9m83rrPJxFL67Me2TH+0qzayEhRMRZt18Jo=;
	b=RIJDSQMov5XDVkT3TKo3iBzsXav19lj+KdPxGW3IfbiOwQ1UlF/Mh70wow3/9W3Dyu86vi
	RlGzBJHZcW7AyAYA90APAttld2KCiHPfjh4b9RKiKQmvW8PMv0ZW4F4Uz12aoTzD50AGIk
	3MSPVeIqm7HcrThU1jHupt/q45r8+/I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fj6UO1+X;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756803985; a=rsa-sha256;
	cv=none;
	b=LMq6YiJg6yoZpAmPCxV4oXGzd9gp/P/yMUdZEv7//QhQJE/ujqMXULD1NhzWvt3qfPbEU0
	K4n854hBH+HZXTuzaH3J6aT0k4iDvA18YSDuIdRwzqTWwyq5VAgBS7wR/FJ48WvFapKmUb
	481j+aniQikw/NjHH0onHAUffpL6GZ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756803984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lw+TgGPA9m83rrPJxFL67Me2TH+0qzayEhRMRZt18Jo=;
	b=Fj6UO1+Xzcsl4lE1S5Gy1QSzlkjO98eWmeU6MG11AI1fDInHrz0rlLD7M0QyNRXRseZBIc
	ROGAovw+hetIHM1XB3JpGKTwe8iyUJFAWEbWymSceYMdEZkLkOMnSyJAc8PxfHjOTqv6rH
	s2r7mUY03+6XODyDj1X4QTNktzCkA5k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-yxxX1JnvMAqkSyDTL7U4vg-1; Tue, 02 Sep 2025 05:06:23 -0400
X-MC-Unique: yxxX1JnvMAqkSyDTL7U4vg-1
X-Mimecast-MFC-AGG-ID: yxxX1JnvMAqkSyDTL7U4vg_1756803982
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so46715515e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756803982; x=1757408782;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lw+TgGPA9m83rrPJxFL67Me2TH+0qzayEhRMRZt18Jo=;
        b=H8pbQkQbAjo+Vm9HUTsUlXQyk0UgiWB0+DZavLwoWbDogSkXqM7UWtmHUcFkFAJU9S
         I5cwfYa7iU7Q7lqadF9BrGnovJppzhWtpnm2g8ikBiL44LOm4UnVBJSaYkZv0bJLsqlC
         Ej/o9sdHLt1amD1WOH/eHVNhAppSkeBCvqg5yKgNGH5ILYVfN7CUWOaITnhW9ri1m41q
         vRJCUWC5q4ELKNudwTQdsrfruPruPgmHzSgzyZu2KXC7jyT2Pfn/uZbNakB1Gs+jGrBT
         jpLhBhYgk93P96nN4cj9MszhlZAJVOcPjffbVcJ7c4xS0IBrW8bFy6oDJ9xaisWmKCZy
         sZzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAN2yvSkMPcL55/WNy2tU2TiN9gh1aTwuiheWPj0hAeIinR6wkzlBJrVzkqMqeaapK2BEbtzASxw==@kvack.org
X-Gm-Message-State: AOJu0Yw/LCVChzamRV/89MlAyszfLqBKFwMHF0g6BcnS1t665d7o5plr
	WfEN2Sm1wCmKeX5PUSXWR42luuVzhwxBtqZkIW9NqHaXdsN4SA9KlswwiGxambcfBeh3kk/jU9k
	ub7cvNQ40RQ2nQYmUmN/tFlBOE+aC3QO0lNFXNORaldMNz424WdrY
X-Gm-Gg: ASbGnctKVAbeZV0EqyR2GTWPmffbSDkhNQkG5IvJJ+qRzeg9cNF5xUi86v8NQxfCmqv
	bTnwUphjs5b7kYv5XH/C58niQ++Mu9mQ25Vif6Zm1/LMSR3v/UMlpDUh5r/61Blw1F/cGpuDnFr
	d+LDGjARHp6dMb6H7dRUsYjM4AamZbxzKBRAWkvNoJO/gKh4nutNvTFtctuHoTcvEHnCuQm4cy2
	qE1BEiBDzFur2CUeVUZPU6EyDlDXmbGAc+pArLOu1LEYyuhcOjU12QJvUDtqXO8q4/xojsqL4s4
	BsfX6lO5yWy4ErB6BZgE1DNPNPagbzxH+LbFdn7Rg9//lwahh2wGar3JcC88g4PUMJmkmL/mxmP
	ExPUsNv7HJItoAFODedeDrpFV44NRdLjk2lUiJBJEq4LTf+VreeyDcD+qjKF2prgx0sM=
X-Received: by 2002:a05:6000:2908:b0:3cf:3f1:acd8 with SMTP id ffacd0b85a97d-3d1df8281e9mr9399424f8f.28.1756803982124;
        Tue, 02 Sep 2025 02:06:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyW9riAT2iFuFssRMjNWNJBp/HthxIq7RSmrdziyCSMPX23wcSGgenXtzWkh/pnL+2k3HStQ==
X-Received: by 2002:a05:6000:2908:b0:3cf:3f1:acd8 with SMTP id ffacd0b85a97d-3d1df8281e9mr9399394f8f.28.1756803981694;
        Tue, 02 Sep 2025 02:06:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf276d5816sm18703055f8f.25.2025.09.02.02.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 02:06:21 -0700 (PDT)
Message-ID: <40f4a688-42e3-4556-979a-209f0ab24c2a@redhat.com>
Date: Tue, 2 Sep 2025 11:06:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions when
 THP is disabled
To: Pankaj Raghav <kernel@pankajraghav.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
 <1acb705c-4846-4a12-9e90-f7853da8a295@redhat.com>
 <cdbc4c22-7a6f-4c01-8d2b-550b643318d8@pankajraghav.com>
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
In-Reply-To: <cdbc4c22-7a6f-4c01-8d2b-550b643318d8@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZaG6OoUbqbAMK4vB6ZCVItCCoMVRUuqyAaKVLAUw2Kw_1756803982
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4771F80006
X-Stat-Signature: hm7yws85nh9y7swxh5jbzt51s7mzyhtq
X-Rspam-User: 
X-HE-Tag: 1756803985-389657
X-HE-Meta: U2FsdGVkX182vj1BUxqcqQ8aIHSNWwUN988WHBkCO4S8xzXzF7gmw/EzMPLreD85TLuyXcaROrjOokom0MnYHFHmjr9abh1FNgifuA/NDBRbLWzBjO04S5HPvuDFsqATXV64dYuQgZntecZHLuOdukPC3LKzFHimdRsf840GdGnJdf2b2JvwsE2PoQ001plxHsG2hVDpWavmWa8mnEc1TGHow/IOMulX0WeHsbF/9aNylZ7TBZqM5DbncIjnuVZtH8p5gj7FZEQVYiFa+SMm/38/4ReigM2zDhVFcpS3YQNxcYk/naXn+8gaXS2JIXE5FBezXby7TFgK51gKKiVjekMTHEOqg/D54XQRcPPcZiWWXsJj72frLA7VRAff9nIA+RUbpqgNmuilEGyQ0hrS8TLDzuIBP0mHPAV2Ub/XlwoY315GU8eWJbrUjiFkAa328Ic7wX+Z69n7AqM6uvCAHCMT0wm8qgw2acWzlV8/2dx8buct3DP371vLK4xazN2iYDJQSs187tL53UZSkQpl17RQE/qJZIteL7rjFyVDRuaY/fqRH/14W4McrlcP3ZuxdX6ITbvDmX1EbG+RSeG4HEw4YvlEopHUSK+EMGzige65/GLciHmvCXTIfY/lTejZc0wC4QPFKATzg8kavcW8rf3BzGmWBZ799Fo1LjmpKPikDtjsdRDHtua7j1U0OTNmMYA2AmdIlE0bIenzLLKMkcKeUjsnPgAmd1Q39VChJKKYX4nBxWomR3Gg44BuSM2EwfphE8+yVdfiJtu29LmOyfdqHYyJHiSKSJf/cek0MT4INTXbj/dCNe7nd4RPegklm7d2Fgcxc7/gVYZ7ju4uZoim5aVVcrbJZPfmuo6V7PFCO3j2/ipMyVFuXqCCF0EFCKOCOa35yJZYwyBg1q4F89Jgd/gsf+PdGGzWlf1cfAGymvGC283u1x1RB6b5F5uxYJeLw3sQYawaxouxhPf
 f6pOHfYD
 htLxeTUeK3q6lKFpFQu0AHKQzg+lMX2Hdm7ecmRItjR9xMqkTCACF6W2Ix0u26UehxKDCfdln7unaceZNL9CtHnmKvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 10:59, Pankaj Raghav wrote:
> 
> On 9/2/25 10:43, David Hildenbrand wrote:
>> On 02.09.25 10:40, Pankaj Raghav (Samsung) wrote:
>>> From: Pankaj Raghav <p.raghav@samsung.com>
>>>
>>> split_huge_page_to_list_[to_order](), split_huge_page() and
>>> try_folio_split() return 0 on success and error codes on failure.
>>>
>>> When THP is disabled, these functions return 0 indicating success even
>>> though an error code should be returned as it is not possible to split a
>>> folio when THP is disabled.
>>>
>>> Make all these functions return -EINVAL to indicate failure instead of
>>> 0.
>>>
>>> This issue was discovered while experimenting enabling large folios
>>> without THP and found that returning 0 in these functions is resulting in
>>> undefined behavior in truncate operations. This change fixes the issue.
>>
>> Currently large folios that could be split are impossible without THP, so why should this be a fix?
>>
> I was debating with myself whether it will classify as a fix or not. I have had people tell me that
> I should mention it as fix even though I didn't feel like it ;)
> 
> But I agree with you, we can't hit this issue in the upstream kernel. I can remove the fixes tag in
> the next version.

No need to resend, I think Andrew can just drop the comment.

I'll not that I assume with any large folio support (except unsplittable 
things like hugetlb), we would require splitting support.

So calling these functions would rather indicate a bug I think.

Fine with making them return -EINVAL.

With the Fixes: tag dropped

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


