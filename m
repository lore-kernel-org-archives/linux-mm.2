Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D0FCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B286B00DF; Wed, 20 Aug 2025 05:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7245E6B00E0; Wed, 20 Aug 2025 05:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5B06B00E1; Wed, 20 Aug 2025 05:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE256B00DF
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:14:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC9EF1A03CE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:14:17 +0000 (UTC)
X-FDA: 83796574554.19.0E31F07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80586A0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:14:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HslPXRuw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755681255; a=rsa-sha256;
	cv=none;
	b=on5B2BU88Vs1xjLoVMwCwDEZ/A6n6L+Hth1RQx6KYYYsUDB37L28GTEJ/q+Ng4tf/veRkg
	opjMcS6QF486KZ7n0yThhhxJYD7EceVoYruXLyEpzufc7sXRmwVDr1jmib7b6skf+s1ckl
	vvvF0QcA/UCG6OMpISh38sG2pw+PUbY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HslPXRuw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755681255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KV2kwuImpZS1M0b+LLJ3StXxExBhEfmetf7Bw7eVxpA=;
	b=uK2TTgnqslVpCNPqFsw6L2kCOC4CuNNk+P/MfXkHYapXNEoQmEQa5dJ14iWUk2BFdVyRiK
	RHMAlGcOTlkkFoJ1/LZjnsHYfm10slkKEYSzyxCBS+MzzMC7QtrZv5ODGiLW6COmwjnuCu
	bZounH52xdL+ljsOLi0BcLZk73V1TJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755681254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KV2kwuImpZS1M0b+LLJ3StXxExBhEfmetf7Bw7eVxpA=;
	b=HslPXRuwIvuui5Kl3zKkobJYin91+RZcaY2ZAiYGwQ4NKAYyiPasyFYQt3Y+4g/A4fawUF
	xTNtFpI6nGU14n82I1/KvkaLDPjw3dEYaY0UFW90sDhnGup0LTmSqnt4+kx/r+nQGfcFR7
	UJJtvGR8CzomFHbxRXIg6q1A6CKycEo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-OYoKSmgTNamjwTvLFATdYg-1; Wed, 20 Aug 2025 05:14:13 -0400
X-MC-Unique: OYoKSmgTNamjwTvLFATdYg-1
X-Mimecast-MFC-AGG-ID: OYoKSmgTNamjwTvLFATdYg_1755681252
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0bd6a9so28188995e9.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755681252; x=1756286052;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KV2kwuImpZS1M0b+LLJ3StXxExBhEfmetf7Bw7eVxpA=;
        b=Qqr3HKnxpHfW32qLQBi0Y4CgqcKzgoVpj/ABxVgvIxhTkYCHclmsZY7maV/GHmor/V
         /hd/Y8UeERL+nD4kzD+hTYUQwLBKrxG/eBzWEdeUDqlfdIVaV02J2FKIAbJSTcvYS9MZ
         cCtotxU/as62wiPxNANiNSMmD3qSHW9r1vJcOghMlmfTdJxeOcwZH7JrPVWQ7UG9Z6yI
         gN9A908NEsA6z8LtNO0DPhNpLNYShobqkVkV3dMydV9vJwB8aaJ6e9gsU0fUOub+PobP
         sXeGRmPdWC/0nK/ggIRgnr1ZEu1YvQqMpWTobOYNWpX/bVlMDfIwVNKIOdGHXxPyOt6q
         6huA==
X-Forwarded-Encrypted: i=1; AJvYcCUB+pQyrnF6bmi6fioRqRyAux0fmn28Yo9aJg1mHncYvFdxf0GKofAYnefLbnr0zI4gdkXaB4vh3w==@kvack.org
X-Gm-Message-State: AOJu0YzrjjyR0XDtrHxe7f91MipUOA2AXCx/I7JHJAuQR/e/GPKowXYK
	uIDyiaCgpMND19/MbEX6iT3OsEjqh/qfan8RnA7Jw6SOMPrdtCwql7l+gw2Bn5kCHXDTr9GVXc3
	aP41ioXmoAUvnxmhucj+hD+ckxzdyIBp3Cl7c2/CUvTLOEDerXmUq
X-Gm-Gg: ASbGncsPnPgM9+rEpbcUPphboAJ7iOlgZj+2q5bnlH3DVADCLcn047aYkMz3yylu5j+
	YZKPVa/BqGltMl/60mzVuEbVAt4Ff/HaRgQMUhvF/Q23OMdQwL9Odi8lQXxEb38a5w5ZcvgB6Lv
	6fvezAtTl2YtJTPtAf7EcMb5HUDoaSnbnvBK5J56STT1G0SAFxO3STbJQo8YctVNJsTvnMHy7/T
	KnCxnY3LucCL+rT8m62zSF7PlbqYU3Zo6VqB/Lq/UWMO7iZvDfxOLKqeYBPjFzSHU0CV6mgge9z
	5WKV7wtFohKXXoArcJUV2nQTz13C7I1HXMjL8ut/a3ZBDaA7+bTdx/0+IW+YhqjMDOTbRjUCNOy
	UaMJ2aDncuKQO7sPUC6HjtyIavIgMzlgtHhttIgeEuVcUyAH+suJuxZcPzOsRPZfS
X-Received: by 2002:a05:6000:40cc:b0:3c0:2f7c:faae with SMTP id ffacd0b85a97d-3c32d59d75bmr1500936f8f.12.1755681252314;
        Wed, 20 Aug 2025 02:14:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1ogNAYK45M7HThPL3z133V1jxi/C1YK6zyswt1JB+ty9xY7aaTwxzvDr8S+YygrsAqrQ8jg==
X-Received: by 2002:a05:6000:40cc:b0:3c0:2f7c:faae with SMTP id ffacd0b85a97d-3c32d59d75bmr1500909f8f.12.1755681251855;
        Wed, 20 Aug 2025 02:14:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f13:de00:e9f1:62b4:5bb:5d83? (p200300d82f13de00e9f162b405bb5d83.dip0.t-ipconnect.de. [2003:d8:2f13:de00:e9f1:62b4:5bb:5d83])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b47c54c7bsm23414825e9.17.2025.08.20.02.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 02:14:11 -0700 (PDT)
Message-ID: <24ed0c41-6ec3-47ba-8f63-94c521df995b@redhat.com>
Date: Wed, 20 Aug 2025 11:14:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/cma: add 'available count' and 'total count' to
 trace_cma_alloc_start
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
References: <cover.1755654367.git.gaoxiang17@xiaomi.com>
 <d30f91137e3a296152463ea65474e1ca56f4eda3.1755654367.git.gaoxiang17@xiaomi.com>
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
In-Reply-To: <d30f91137e3a296152463ea65474e1ca56f4eda3.1755654367.git.gaoxiang17@xiaomi.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3FLBwhIPqquOfQEnQ560OB5TQoKdTZoD67bTctHV90w_1755681252
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 80586A0011
X-Stat-Signature: zbrr1i9ittepaoxxee5nhgzasf58pfcn
X-HE-Tag: 1755681255-264013
X-HE-Meta: U2FsdGVkX1/C5HTDWMcxDDdyGAcOuIbMCtCbaYafD0GHl4x0BW7c8aDTwrvounfu93QBHMiL3XNZhOMnMr9BXzVFbC754uZdn/wNfMZ3A5VFXeiSbwFn/HOlg33Cw1m8kU9k6zyu9mmxP+yb3gSg5R3KY7sqyUaQDdaeFnCUrnx7O3Cyp/z3mDJ3gd3PjDlnHNQfshh0RiopUAzk9/iIgsIH2QjmBnITEFb1Wx6MEOuT2mhgZRQ91qcEf7cmRV66YdkFBio4xtNGUPYuxvJWoNOisAYIhYuPCSqupF+MQ+mG4J72tSDQ26fnpwKgp6prtVk8rEguMkehD5GygxjfCRH6zBWbB7ObjemLMw6hTFDQL3nh5bibAom4NFwuEGNFpM0eAIEQaVfr53gPRaGid8RTsxNoEoDcKjwmMEsojqzKNfZV/NYEqPulAJ28nQXD/kNhq5jLf5Jt2IMmieKxOBrbnNm1j6K2QXXaTMPDtAKVmZ/wiT1VzQwHOIxFdBjLyOfwpgjJs0AFV8NpKm0zmlUoGGQCO3G+m/gc3fJLQ9x3uVPX35uptlsHdclgidjKkqwB/HlaknbVvuv79gJ8Ok4XLZL9xF/SBZ/2CfeSJT6xrnP1M+7Vh/Zs66Ocxo0bSxR3VYKihL7Yse+35XPZgMhfR2LeMY+kJioMdS0+nPQtiGJ/WhK2lllOlLpcgdFebH0NdpQWurn5CO34dczha5P7Q0o6QKuFHWBSRHXHrqq4HqpujjoQqSxiyUtaDggmfO1Rl78hm+rqfQqvZgudzj9OArkgUjPRSlswAW5OoNHX02kVSQKlvCY9x25TZfxN+kM7wbwL7IaYSz5FC5vI0PlXm+dEgMmCUh/UHdO0pTPoDzKD0UhbEtvktsVJwOitkz5eeMOh//ZJysPW6r3nFAp9qAyQ9asmgR3IPLuK/73QUXTaLNNolmL289NeIledOTji/MiTP2MfBklHfmp
 5tlpFEYI
 N7Q3IPsWPwd5lFuPQH/I5GzBDttgw4saXUmzbMPWUyuI5U1JIvwnxKhQs1uAlF9m6MBqPg4XJV2dYi3P7i7KpRGFC+9YGOgVnVOcTU+bRHUwzrZFXjDEyx0TErzLcJiQaDS87fRTskK5dxNjjtbFMtlFu70FTcWlW0kdL2b+w+ygHTcIX5H3KeY+w9LK1hqQjQPNL6gWG+tXauKt9YoxXxeOv8kbJdCZCIG3+zhqqc2t6mVPakoH+2RtCEFB87bqV5rdf3m6mwK7fAzLoJK84nMJSrEJIaiX8K8P6h9c0Dj53U1jv6nTMYC/E3ScOx74gbSMNgbcFYMye4kV8oHZDT+W1IFWk/+oYZH2F+5HyhtUQ3SnxRXymave6eOLEjZkG8JQwKzZFbWXvZoUWqIDaVkxui2RXi1A4aPiIMjOsstMD51PS6T9PWEVgMzQ7rqMfaQG0mRi5qcvDTn6MJc2JuJMOzzmAjOSB7oQnBUu+BXLaIWowOzN4cABf5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.08.25 03:53, Xiang Gao wrote:
> From: gaoxiang17 <gaoxiang17@xiaomi.com>
> 
> This makes cma info more intuitive during debugging.
> 
> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
> ---
>   include/trace/events/cma.h | 19 +++++++++++++------
>   mm/cma.c                   |  2 +-
>   2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/include/trace/events/cma.h b/include/trace/events/cma.h
> index 383c09f583ac..5655ac521fb5 100644
> --- a/include/trace/events/cma.h
> +++ b/include/trace/events/cma.h
> @@ -38,25 +38,32 @@ TRACE_EVENT(cma_release,
>   
>   TRACE_EVENT(cma_alloc_start,
>   
> -	TP_PROTO(const char *name, unsigned long count, unsigned int align),
> +	TP_PROTO(const char *name, unsigned long request_count, unsigned long available_count,
> +		unsigned long total_count, unsigned int align),
>   
> -	TP_ARGS(name, count, align),
> +	TP_ARGS(name, request_count, available_count, total_count, align),
>   
>   	TP_STRUCT__entry(
>   		__string(name, name)
> -		__field(unsigned long, count)
> +		__field(unsigned long, request_count)
> +		__field(unsigned long, available_count)
> +		__field(unsigned long, total_count)
>   		__field(unsigned int, align)
>   	),
>   
>   	TP_fast_assign(
>   		__assign_str(name);
> -		__entry->count = count;
> +		__entry->count = request_count;
> +		__entry->available_count = available_count;
> +		__entry->total_count = total_count;
>   		__entry->align = align;
>   	),
>   
> -	TP_printk("name=%s count=%lu align=%u",
> +	TP_printk("name=%s count=%lu request_count=%lu total_count=%lu align=%u",

"requested_count" ?

-- 
Cheers

David / dhildenb


