Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EECCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B00E8E0013; Wed, 24 Sep 2025 07:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75EAA8E0001; Wed, 24 Sep 2025 07:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626EA8E0013; Wed, 24 Sep 2025 07:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7488E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:10:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6A72BB64A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:10:40 +0000 (UTC)
X-FDA: 83923875840.30.867AD6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84F51100016
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:10:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AfvV1JP8;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758712238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjizJOtIasCre17yrgz49+y54DCATqZxCDyv3+Ah6yA=;
	b=sez4EDE0tS0FY60r0vD0NSZxtf/rx4HYWde21Q39sbvCER8sD9PA5aVlUitzEzfr4bJF3T
	rQVGkVrYKkxteKmUiu+xx6xKOhQCvdSZ5wgHZ4Bm5WeN7ds9Sj+qQ3Nf7kbltY1jcPbey2
	NURTYfOskgaZq3letxelGzXkWQKxAj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758712238; a=rsa-sha256;
	cv=none;
	b=xzx/9TnJMRhIfxadBZWPXQ2UwdvxoCq7jq0rMSvwfda+bajjdRCztUHbcEwjXy7MdP5IFc
	/zikM/jxk3yCO2QLUnYvb6+USf56TIpUbbwOH8kXHylxtuQphheKiEppVrcTXDfcHlesEr
	CtkNYTnq+P8Y2P56BulJhBq089pf2tw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AfvV1JP8;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758712237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QjizJOtIasCre17yrgz49+y54DCATqZxCDyv3+Ah6yA=;
	b=AfvV1JP8eJoHkh/pX8QKSPmIxzbcjbKtMbDcUq24sgyvSNR4B+4bvo7H8khspTimN5Yg9H
	CbzZpQBgnO225qbyvFuI5+UXRG0qGnB8+SQbweTv7X92kW7i4zVFRK9N7lHaa0y1nukqVZ
	MW61Lxpk8YPlZoeC0+FB1QgubXu7yow=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-ExJijJftNu-gggxURjzJhA-1; Wed, 24 Sep 2025 07:10:36 -0400
X-MC-Unique: ExJijJftNu-gggxURjzJhA-1
X-Mimecast-MFC-AGG-ID: ExJijJftNu-gggxURjzJhA_1758712235
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45e05ff0b36so3808335e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758712235; x=1759317035;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QjizJOtIasCre17yrgz49+y54DCATqZxCDyv3+Ah6yA=;
        b=GRB+W52qgZb9jzB6/oD2WQB5T6NAyeflt7wWVqAj2z26e6K0gkh6BS/ZPJTI+mTM77
         xpyRCRBEk8Vla0a7kfu/Ox9s8X33/21d1SnA3ReNMCkjE1+x+/yCfmWjkwvg/UEEegVG
         mPsaq1F4GRzOE5nyE6wD/xU7U1h4GfKeT0TsaG/OWIdF06+eNcLzc5qupzZS6YEyIGPy
         +tr21C56i7IJPRicsrMO4mbMDYwc+GQB/6xcLn+N5zf7GkWOGVVZBqCvIf174Gw9LRTU
         R20gZHD9Vu0NAUdyVlrcp3nRoF6Jta8Oo5/s1gWcohmqiIdFioUv1+64a9Nmyz2L2kwE
         c53g==
X-Forwarded-Encrypted: i=1; AJvYcCUvXmUdkNISC13m7+K0xchJOaFt+kt9jYyjrgpdyhTrVZOjBTg+fUZzVLlU79EUAH+RiE4MTCEOEA==@kvack.org
X-Gm-Message-State: AOJu0YxzQYoFeHjmIw2dIyvsaBFeh3WjHVbJH7ADe8Q3Rn7RU6l+ZBvT
	V9+ANT6S6IGFqrQqrTGfeqFeWXMf3w7eLfsvq2HiJh4mxPMtu4DreaxRQvWvY2r92JKB4Pby1Pn
	u8D2Z/9Nb80Hv3/oHUcjcf3Aj1doiwOyB6ICDQFrWNM+7b7AdzBGQ1AxQvXJr03M=
X-Gm-Gg: ASbGncsg7pJwKV6GdORmWrCS0SIEWtSzlDOlXla/Xds/ShWyzSBr+dcz++R4Z2s6pNA
	gVFtKrUdx79z1gkwhxprSq0766SDi2FAXyAktMMPgpiUkuEPJKOu3i6HnX+wSBWv8lv9UVWRrrS
	+AEv5+2CKKaiHVFy4rQetGF7iaQoLe0XvpjJ2so3Bu03vNtSfoaWTJr3WzE6FkX+GZUO4NfeSRi
	hd3CPVJJ6aBvB7KvEfg8rxOCl5POaeU2K8RmAESGa51IRKnI0a9TZ3pLYavatTad3FAfc4aygup
	ETmkwivr7chJiK8XS0uptCzew/YWLujLct4mnf6qTJalEtLLaMCaoni1fl1jD+BPrZiE80sNBRH
	jAAr+IEy9IFO5S5w5o5xmYSgt1NbM962asBxCYbGBkFbYd97FRqmMFvCA/N6oa+Ealg==
X-Received: by 2002:a05:600c:a318:b0:46e:1b9d:ac6c with SMTP id 5b1f17b1804b1-46e2b5ae650mr15221195e9.17.1758712235543;
        Wed, 24 Sep 2025 04:10:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfjm0wZkVbwQ1ssygwylIahTNFeY9nCpNKyJLOIN5at81FhLNCYY61YbcAmW3vmCGWGRo8/g==
X-Received: by 2002:a05:600c:a318:b0:46e:1b9d:ac6c with SMTP id 5b1f17b1804b1-46e2b5ae650mr15220925e9.17.1758712235127;
        Wed, 24 Sep 2025 04:10:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2aaea069sm34696585e9.24.2025.09.24.04.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 04:10:34 -0700 (PDT)
Message-ID: <d03dd7ab-5237-4de6-8872-a8ae2e9b7c5d@redhat.com>
Date: Wed, 24 Sep 2025 13:10:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/16] arm: mm: define clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-13-ankur.a.arora@oracle.com>
 <d2dca02c-ec5a-4b3d-92fe-2b3a3614b5df@redhat.com> <87jz1obyd7.fsf@oracle.com>
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
In-Reply-To: <87jz1obyd7.fsf@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Up-zFiEXLuHKaZK5nwCW-HcAbKbSbzOD9WtCTDfcsoE_1758712235
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84F51100016
X-Stat-Signature: xi7xi5cro46hwytj3ojtwt51rk8w6har
X-Rspam-User: 
X-HE-Tag: 1758712238-672405
X-HE-Meta: U2FsdGVkX1/5qLLrvMkFhkfxRh6Bsq1dFbkW438wsjlJw+wdxsQG5Yq67+klFBeYK8OrZq2AuY0Uhb01lk6pcr5CvCfLa49X2+W4uTG/371Fq7PWSw6cl8oNvYzyZ5Gvd6x22p9WLVJYYnDtTG8cod0MD0AwDb6cf0usbMsflrdx/ZB36fZKvPJpYeKPTkLfACabOMrjIoiNEAZyErYRyu3WE1ShzBrJL48ighpzPMfDSsgb92Au91XsxaQXm5JAKnr0/wWx1OrdWBhzMIssuUhiszZT60mcBa3J5/DDrdYYtDF2FoPockrF7kTvgZvqCgAixqlgMKcdcn7+MmIaS9RMtvoEK3GPExCEZ0uHdVHFeAbHZeB7fdGPHT+fKjZDNyYwbwYQh72OHdEej8yT+rubBNcSlPvnlK+jDXvQ4pZfLPGbtMYcYA22bHyW3PN/Z9IvsPrNhVK9c7J6MAvUuYoVIgSb9DdHRQNcWwWqlon0gk8hPgLV8Xf3KWqECnSJ6UH9R86QBRmzYqSzyOKRu+eI3Vtof3xpiUmqp+6QH6IhI8VHVVTA3jABcaitbafz/WgqnGg50TEh/CaWUGu6wIUBWhUPbdP3I092/dceEe27ifsnf3e4aNc4URmUIr0JwhzvvcYBkSEaCJtzfZwUr1V6R8ZXK8RLkVYe5hwR/sjA8neJ7GfDwqDF2KQhemObR6bxeX/5RWQ5gEtC+yZAhxGxJ0LQR9Ioh1O4Im/4GfE8QF1dCuGHHgzquYZzo7U09RFoaMuirXhz00tQYx4pP9mIIv5mXhD9Wb+FmNs7wohX0ARBcL1pnpXeSLfxrLgmaTvmxl+EWISgGMpDKWncVV/PKUUhIc2VgK7eT1wAjT0Iim1EDCKhZAb39tp8l/ogtJTDry0WFMthajCD7URp7EEKNTYJLDOtoa9MeoaQ3arYlooOlnN8qLFGl1ihPUklAIt/wNiNYFnPvRXs+X4
 o4/mGTUW
 Kgzl7WmQ6Q9QiW5+wROhDOMEMS6t+hDWAEEZk5JdhxvRet1Km1+lhK7qEsZejhWv53QMFaU/YvdF9WkcCpkXtNpZckV85v386sXeUXshPPglvOD6jsVhZB3S0ZD4z4eh6Bhmvrlo6axj/U0Dod1FakOa82LuksGpTi64tL9mdq8F6afIsNlFCKG1cxajdxzeNd7EhNESnsXIabgWejBr/q0kRrZx+F0khCQNQfQwY7dpj+5Vgum1SaMZd7NKxuBzJdGvd5OuPb8x3IDeoviOhbupm1Pdhu9WrqySnNKP77oN0U67ccKoaICkxUZCpkGFns17XdoD28zUJtKsPp2cne3lohY0gu+8Ex74VrHlbPnm4mfpd7JQyhH04PjvGzYEyyMIY+urIPud1Y2cnZEsDnLGWMYaT1Ce92tQH/inK5xdLzEjOjvk+BlxcozAEGXeFswOwfAM2Z2fAXpaYq50HjDr9i7anngkArK7p52GZORK9wB6oAbLq7TDd/7oLVRYBGzphgkSftMF563XDqTU/oKBrA6Y8kGnx0s4hNqfyVvScyGc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 00:25, Ankur Arora wrote:
> 
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 17.09.25 17:24, Ankur Arora wrote:
>>> For configurations with CONFIG_MMU we do not define clear_user_page().
>>> This runs into issues for configurations with !CONFIG_HIGHMEM, because
>>> clear_user_highpages() expects to clear_user_page() (via a default
>>> version of clear_user_pages()).
>>
>> I'm confused. Can you elaborate once more why we cannot take care of that in
>> common code?
> 
> So my definition of clear_user_highpages,
> 
>      +#ifndef clear_user_highpages
>      +static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
>      +					unsigned int npages)
>      +{
>      +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>      +		void *base = page_address(page);
>      +		clear_user_pages(base, vaddr, page, npages);
>      +		return;
>      +	}
>      +
>      +	do {
>      +		clear_user_highpage(page, vaddr);
>      +		vaddr += PAGE_SIZE;
>      +		page++;
>      +	} while (--npages);
>      +}
>      +#endif
> 
> assumes one of the following:
> 
>    1. clear_user_highpages is defined by the architecture or,
>    2. HIGHMEM => arch defines clear_user_highpage or clear_user_page
>    3. !HIGHMEM => arch defines clear_user_pages or clear_user_page
> 
> Case 2 is fine, since ARM has clear_user_highpage().
> 
> Case 3 runs into a problem since ARM doesn't have clear_user_pages()
> or clear_user_page() (it does have the second, but only with !CONFIG_MMU).

I think we should look into having a generic fallback version in common 
code instead for that case, and not require the arch to implement such a 
loop around clear_user_highpage().

-- 
Cheers

David / dhildenb


