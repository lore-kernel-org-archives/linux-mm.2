Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4128CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F98A8E000B; Fri, 12 Sep 2025 11:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAD18E0002; Fri, 12 Sep 2025 11:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDAFF8E000B; Fri, 12 Sep 2025 11:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8DF18E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:49:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AAC81408A8
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:49:23 +0000 (UTC)
X-FDA: 83881032606.26.BF2C441
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 90A7E80012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:49:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H3eLYBv3;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757692160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a06OtopBSfhX5lhpDNYUFFeXKxatnjbMpyicog5pOn0=;
	b=xLp06KStWiudpTpGvCWtidGb9euSfrqkysoeGa1zsg8HIrsXHLvG/V9RYGx/HLkzK6DONL
	cnIU8tCzeX2vftX2jGu3kP4NaLHl/4G5I8g48veGq0GuUIkcYrR4LDP7qGsK1XAXaDPava
	OOkAWvyK9TUEeNh+qauadKIM8mI1ZvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757692160; a=rsa-sha256;
	cv=none;
	b=o1fZmGF/P4FcZ9iIEi4Jlf2Rifjj/I5cJearZJTZCsSNeZQ8OJpYoMslTLS7UsRwJN7lgO
	1OSOup2B3KVGl5Z5h52atlm80C7RK6zlM9KJJbIRlDSBJbyJqr4Qc/KCIXUTMhKeqOh/h5
	r+m8WVVnrc6w7Ul6C6T8tPE+GfQ1FWw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H3eLYBv3;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757692159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=a06OtopBSfhX5lhpDNYUFFeXKxatnjbMpyicog5pOn0=;
	b=H3eLYBv3i6wpuSIVFgLQ/m5J2fjiwSQxpvvg3Vh70R/aJikiYrF+WrCfwR/iPH+mTOjL8u
	O8C56CWU4Yd4ZMedPbtWuVYCHYW7JXKuHunLBObeKHKaDRhm7eWg9CXKwDlK1nJ0PC7IfY
	K/SN1J4t12+253coJuJtfezznMnYv/g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-t_Npkm9IO_WQlctlm5ZTFw-1; Fri, 12 Sep 2025 11:49:18 -0400
X-MC-Unique: t_Npkm9IO_WQlctlm5ZTFw-1
X-Mimecast-MFC-AGG-ID: t_Npkm9IO_WQlctlm5ZTFw_1757692157
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e424a186fcso1099113f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757692157; x=1758296957;
        h=content-transfer-encoding:in-reply-to:autocrypt:cc:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a06OtopBSfhX5lhpDNYUFFeXKxatnjbMpyicog5pOn0=;
        b=YH60iJE6qPmiAs0syBnmovtpucwyEQSBVUuGVYydHp8J2Q4/nxpXJ+Pyn20vdt1JSN
         NxghHg7gWvjypg5b6cQJ3ZQhFx+TBBs7BDH26/x0RAQT7usJUZ9He1tBasIGzWrwPGT1
         O3dG6eh50+8Kxw9o0P8U5UFCz1TtFKmvPT7+glAU6m865BZ4wUX1DWNp4WjtkJ6vlQNM
         cZ5fOGmgpP8qmYACcE6g6E0f1NiVf8dJrzzpU57OWj1RUYUeGStyxkmfPCjPqL9DEZ/X
         1escd8vVUGShs1dr8tl2uC02ZVd3QmqmRVpIhwa9ePw00vH9KEjhDRKxxCxyb4xLe4+k
         FEqw==
X-Forwarded-Encrypted: i=1; AJvYcCWlL7LNYY0hOVMQmn2IfpJSpXaDYsiyQM521c7sEjvTYSwE3GDRth6myejL95APcnlfDODlkDZ89Q==@kvack.org
X-Gm-Message-State: AOJu0YzSa6qCwLa67VpZsXOpU0sbCq8P1QROQNBQUb8kYIaUqGhCZjm/
	woa5G5UHbnmp2AsA4SN3pletwrIX+FR9HsFiNHMdaBSg3ncEYsTrKretGHTH4//+Zp6d+N1F+Kj
	AuoMk8GiwAFSWYIZrjBFg3OhyrfZJPwnBjzwtAJbg/TQINf4+qNeR
X-Gm-Gg: ASbGncsLvri4hLNfVthb5IxTP7BZOBn6TQgIUjcj2VNdrcNDeBzrQBW+ocOu+tJKoWO
	j5otaQydT7/j69IQ3BLwrGwGE4VKGQlfZyTSZ+ga4ivvOcutyZbCB2uweX8db9aTYpU1xB+nws3
	fHiXd9zXQG2YMh7RxAmVP/JRTVeuRNiTxUW3+LWdkMN6cYP2zZ5dqypeT9IFVzJT/giXvbjDhK/
	kbPt58siHKtUOKkDJ/b+UGj2fjFT5R5sCUMU/1IXmtcuf0UtOANpa+PYZdyiR7GptwMl7OJ/bbe
	bFbfp/CgtlS092hsezGE1iZuSRkZjeLIWKrEFPm6w7Tj/fSC0WY6DMKtKt+Di/idR2yjaMPtQha
	zhqeC4tQCTGu5utCGTkhHneycbMbWQTbhi0rgtzVcJ7WLY0wTQ9ZInYk/QAmOlhwvzFk=
X-Received: by 2002:a5d:4708:0:b0:3e7:ff32:1ab with SMTP id ffacd0b85a97d-3e7ff32024dmr643931f8f.50.1757692157445;
        Fri, 12 Sep 2025 08:49:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGl9S+wAnCCxDRaW4xWiSnXeBRS1RCaVsMhAEEDftlMbaARMa7MEMEkEWpkHwU6BaD+M3Gp3A==
X-Received: by 2002:a5d:4708:0:b0:3e7:ff32:1ab with SMTP id ffacd0b85a97d-3e7ff32024dmr643916f8f.50.1757692157053;
        Fri, 12 Sep 2025 08:49:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760775b13sm7174457f8f.10.2025.09.12.08.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:49:16 -0700 (PDT)
Message-ID: <cf235550-f29b-4f22-b5b5-c3e7a576239d@redhat.com>
Date: Fri, 12 Sep 2025 17:49:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
To: Helge Deller <deller@kernel.org>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?=
 =?UTF-8?Q?sen?= <toke@redhat.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux parisc List <linux-parisc@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <aMQ2ZjZNyNwAiUk-@p100>
From: David Hildenbrand <david@redhat.com>
Cc: Byungchul Park <byungchul@sk.com>
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
In-Reply-To: <aMQ2ZjZNyNwAiUk-@p100>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OwX64-oGhtMb4iT_038Bo-7OJLG3QSMBLegBK8lVuZo_1757692157
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 90A7E80012
X-Stat-Signature: fggi6o9joq3jdzjnp4gjt3ymrzpx5qhx
X-Rspam-User: 
X-HE-Tag: 1757692160-913243
X-HE-Meta: U2FsdGVkX19eq4wVlLP+KMqBfj3jIc+1aUz7QneAJ/QP0BAFEzAtb5bYAwUgmyslMuPxFrgRwC3O4dYeAckGqIPYRdbt6C1V8a758lqa/nGhTIzdxyPSi0MNq4ILINYDOenHia+iUtzYtKzbD5LRdyh9jQAnC19AtvJRwECvPDyMnLfy0la6+uhaEPgYFlPbSl+s3rq0qOuR5wpCMp/Kess4birxKdIdhPHYUIliuIsDC8IFDs3LfFROyH8N3dCbHqChq97YYHNBGSyap//O39zasZpxNPP5qmw7Tpzqq6rFnVd8zPiN3MBFvAE9YAyj6nNvI8ZV1t1rB1EHiCXFTNrIH2xrRGesDPyaYlpTQBExNVtNaUL/KF72913vnK6GhmWyue6prEGT6KQ8BNPUk3qlcnNyX+PDcUEJffGmgrjYQeMWsktZLTfGfmj7fu2K33d9u/8L36pQ0w1RSCGKAVBZtK9GiIoSjjALxmL0UwVMUoZQXJEUC3+4R+3uzt+SLzhg3oJsECD99X4XXSgsolHipCI6u2IIuAsfXHU09Vc0NSOnpy+cv0WCPoRDicenc0ZhXmRtRv058Nvt2+WsoLpqxWymqjtYQwd28vcKerdeXErhEu3oeDTiyGV5AGHblDrXez/7d+IVBqof4hsiNpbiCQSzUOTwhjKRE3wWh9NUyq4ZbjwZy5seFX9XwBfbD5yf7Ido72PzkY63TbIqKim9iZGH1V6v1TC4u74UpjLNyQKA882Askr8I2+6Gdhmpb8UalmwEa+iemTath+yBBvZ7OurPY7DstbCQnTxmGSfDXO4C5jGmgwA4h3UtJJpgBLYS0N18vDQwId7C+6iX+srN5P5LZ1P2idYfkjUr6Nvu/ZDQMS+MP/poip52Kgg2qORdwPd8DZvsji4VfH1VPfSn8fWPLf4kt3KGj3BT9iBaV6xy2TVIBFcIYMcCLzolAecilooEVDAm3QPWQD
 /ubCPO3n
 XzZprQQUTNAvoeHCjW5n7Njd+mkPSYwyD9Yi1Ya8LuupNT6YjG2MhK6fJyWGHtNyquyEYPTax2Pg57qGbwGhnezKdoWLu9iZOT1dA+wM9M1DaPbdLQtOMwvOOVbHCXwZHFAAyAHbGlquxtgpxIa/ymZoZY55SQfD+chAeYfER3RQuv2w0FBEQfk3UlKPATuWLP7nkewvYTARi9zFWGlfsNGnfehJDtE6sLuoXXGS2VXLmYfed1b0Sh0Zg0xy3P/hKItraf3qCQH+O/dSn877Kt6/sPY8TSfTBlElteqXMy5BDLAsBrO3vzK3hRSNUd3ZfRV5U/fDfcnwgAZFXSIfjVnu9iU0pdfxqDGmRnniSW0sgJ5wEaxmhoxIpwTA55/zRAI66l/L2OqZfVcFX6IbLxZ7/9TWuXl04MRIYq1L/VtQIzJzQ6YmSMJNxwWakfZ4nyoV/xYhr9w8a36dtvH9uW1YLYdoa/xM6I1PNfXRlxmjd7fCRGP1VfwhYupMIJD0Oh5vNntwbrK7KSIPOy/FljiffWuCiqwOOMOFYBMksjnTDPBKmifb87wrbhku9WUimVjlQH/YIoxwfvwUycyaETznP2y/s3gPlVfqhITPUfu8xkGoMIyfy1aPDl70VNck/NTEbc2dJajXtW1X0TJvBbEqYCy82FgoVn9WzQ+Fcl0ri+2bkdbQVV2E0fYZVHLrVyyqK9DXtN2a8dxU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 17:04, Helge Deller wrote:
> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when
> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c on
> 32-bit platforms.
> 
> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify page pool
> pages, but the remaining bits are not sufficient to unambiguously identify
> such pages any longer.
> 
> So page_pool_page_is_pp() now sometimes wrongly reports pages as page pool
> pages and as such triggers a kernel BUG as it believes it found a page pool
> leak.
> 
> There are patches upcoming where page_pool_page_is_pp() will not depend on
> PP_MAGIC_MASK and instead use page flags to identify page pool pages. Until
> those patches are merged, the easiest temporary fix is to disable the check
> on 32-bit platforms.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> Cc: Linux Memory Management List <linux-mm@kvack.org>
> Cc: Linux parisc List <linux-parisc@vger.kernel.org>
> Cc: <stable@vger.kernel.org> # v6.15+
> Signed-off-by: Helge Deller <deller@gmx.de>
> Link: https://www.spinics.net/lists/kernel/msg5849623.html
> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..f3822ae70a81 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4190,7 +4190,7 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
>    */
>   #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
>   
> -#ifdef CONFIG_PAGE_POOL
> +#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_64BIT)
>   static inline bool page_pool_page_is_pp(const struct page *page)
>   {
>   	treturn (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
> 

As a temporary fix this LGTM.

But I want to hear other opinions.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


