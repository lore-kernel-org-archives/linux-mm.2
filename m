Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E493CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E0A80077; Mon, 27 Oct 2025 12:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEBE8000A; Mon, 27 Oct 2025 12:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6B280077; Mon, 27 Oct 2025 12:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3301E8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:53:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E07ED12969A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:53:27 +0000 (UTC)
X-FDA: 84044490054.01.A1B8C3A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 38D4220007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:53:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NRi3VegJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761584005; a=rsa-sha256;
	cv=none;
	b=1bd7DLcu1ou+jskG00DCPtEMdvMRRaeFVlbuRo7cb83/cVOURKZwa2YLmqEMZ1IDrZ9KXj
	6XKgg2WC09tLyHpfEoAryEjrCav7uh8tfFSC+zFnIXvoyewPu3EA/f0LThVBrCkKlPWm48
	B8Oc2H1czJDdqMP+ZZ5PiFl9sNEBpiM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NRi3VegJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761584005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyrxsbS4pWA34fFEqr8sYK1KnLCfuGgdwv61SrYMo2M=;
	b=YxaJYsr5XOEwBZ4D89i1m3IXeucciDofp845aPlhoEwD+rjBCLNEZoiEeoyMK6p2oYL2pk
	h+xG0A+EeXbiSwgwhxtFjkclHY1Oclj7QMsagAbnLcHfOEgVmlOoT0vWK+hifcPHoOuYTp
	TAmiyh6UV+BiV08/UrYc5Lu6O9rLdtU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761584004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yyrxsbS4pWA34fFEqr8sYK1KnLCfuGgdwv61SrYMo2M=;
	b=NRi3VegJ/yaN4XegyfwK27Nz6EW2xoe+mtBeHfRXHhUlGl0ZyQ1O5S1/R9w1kEt20S3yWj
	IsITcI/jp04TNounVGCEVbkTIBfazfdwrizgCCTERDFfSHVgLJcdDKAskj1BzjgjKp8Mns
	UXJwlNsTyAQQYHCkpWRuk0E1VwDhfNM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-2HLwYhuSNGy5P545jTcKAg-1; Mon, 27 Oct 2025 12:53:23 -0400
X-MC-Unique: 2HLwYhuSNGy5P545jTcKAg-1
X-Mimecast-MFC-AGG-ID: 2HLwYhuSNGy5P545jTcKAg_1761584002
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-426d4f59cbcso3785922f8f.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761584002; x=1762188802;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yyrxsbS4pWA34fFEqr8sYK1KnLCfuGgdwv61SrYMo2M=;
        b=bURaiISl/puXn9KJ0rzF+/rurpR3wk1hbW6P6hMxCZ8iwWR+VeqIyfSCL/lPpZSBKC
         IS/cogOg0i0P9ymi7/ICIvgz1I4OalUEnzP+MsFQSp2ywJ9mcCV4Ag30R/mEw8NI45pS
         fwyOrSUzOZjUwNTghmhh69IDp9qHVCN3sCrGtwrP+hEf0LEf323ixDAcEkpg7Z/0n3ZQ
         9EjKqpkcfoFb53jRfKW5i9MUKy3WqzpyMotsslf5kzoiFR9k2KmYnW/E6mPHlqriiEaN
         s9pzNbUBmfo61VR/7UdGQpuFLKXM8obpwrC40ZOY/lOCMxnMlyVz/pn3mBZVKcTI6Bvi
         7h/A==
X-Forwarded-Encrypted: i=1; AJvYcCXg4lLeDNRKk9u9vxRlsIyzqGKzrrZ/rHw3Ry2jKwMMeAKakznIzCVu49zy9YS90tB2/DN0qKkRgA==@kvack.org
X-Gm-Message-State: AOJu0YyWR1/p/fAddPykCU6QWrBOvouugVBgC/KMir8vezKuSjp/RyAh
	fjzWNiJkX0L0eae63EqyV1yqKKli+EUWjB0O/D7RxqY32i2q4NOnYPkvJ32eu+lBg65iKp8GHfE
	0ET9VInhjClgzaAsJilOGBRGPNqQh57ZkIA+xJ92NDj/SwwxSS8Zn
X-Gm-Gg: ASbGncv+RAzJ7iF72IhQP5dUe18YEVykk3L+6jL7KgIK8h0ggoO+7nO4sG9ti14fSfC
	SkGGkllQ1UU7I2vuSfZUsoHDETuqM1qctKeiQ2w++lrRVn6PRS/XWYnzUdfM6SEBFbvEah6C+g7
	uoSlmOedusnmhBlro4GyeSqXkgr5S5+A6oEQ5Aa4QcdtHE6d+8VHGqjZLzeRe17Uep7Pn4laDqh
	xm7CVqEu33ADRiyiKHTtjfhd11azVouUEO2gWycfB9ukwRPdzsQpYE7COTGkKSfYch99m1C//eJ
	wQGOlASEgnEy/VevKlt9DUf97qwRus0XW61E0Ndd8dwYDp2U5DatdPSyWzqmm2uUyycBXW4Xmze
	27t9qyhMrC/x7MJAgpClO/ftnaiMifBdz511qbNE/03qhDCvWa18qgdVENStzQIflROEwl4rhp1
	LdnHH7tMPlkjq+UTuImX4khPm25KE=
X-Received: by 2002:a05:6000:2085:b0:428:56c5:b305 with SMTP id ffacd0b85a97d-429a81a8444mr148342f8f.6.1761584001718;
        Mon, 27 Oct 2025 09:53:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoK/qb57I2ph/yRYVVzOerbIGxBbhgWC3n/pibQjUkUWrAUSSMmKLj0i7DtxPcapcs/6SEdA==
X-Received: by 2002:a05:6000:2085:b0:428:56c5:b305 with SMTP id ffacd0b85a97d-429a81a8444mr148311f8f.6.1761584001271;
        Mon, 27 Oct 2025 09:53:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df6b9sm15906933f8f.44.2025.10.27.09.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 09:53:20 -0700 (PDT)
Message-ID: <b49e12b1-acc1-4150-9ab8-63c05d45ea90@redhat.com>
Date: Mon, 27 Oct 2025 17:53:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Yang Shi <shy828301@gmail.com>, Dave Chinner <david@fromorbit.com>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <CAHbLzkpx7iv40Tt+CDpbSsOupkGXKcix0wfiF6cVGrLFe0dvRQ@mail.gmail.com>
 <b8e56515-3903-068c-e4bd-fc0ca5c30d94@google.com>
 <CAHk-=wiWmTpQwz5FZ_=At_Tw+Nm_5Fcy-9is_jXCMo9T0mshZQ@mail.gmail.com>
 <7bfd0822-5687-4ddc-9637-0cedd404c34e@redhat.com>
 <CAHk-=wjgm=xTvbu4zEn3kFRC8bF8XXrOdK5fZj8iNbDn5bGB2g@mail.gmail.com>
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
In-Reply-To: <CAHk-=wjgm=xTvbu4zEn3kFRC8bF8XXrOdK5fZj8iNbDn5bGB2g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: quwdmhZSJuyAfYJ_sYmDqIXB9a44AlW6SBQkf7Gv4Z4_1761584002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38D4220007
X-Stat-Signature: 3ggydfzmapt1gh7bsom1ui5otnu3if7w
X-HE-Tag: 1761584004-120249
X-HE-Meta: U2FsdGVkX18Fm8D/hwmdLSeMv6KL2qUFKSjxGVOwqJkF851uFSPY/4BrInKdmoZrwvlv3zf+7MYMH18dIqwc7+O+XoChnmXt7/q6wSlryx5pDxFIj4xjDsagvxvLrK9SM43+XAcLARWxrZHQsSh2+wa3/3LMFlaRl+DQvKedqbdZzg4LLCxPAYBx8uP/LiW9HWjfXWXyZ6HBzribbv4tyAXm4if9SfE4vIXmHieDq4ogn7nowl3kqqHz2elXMp6DIHc9ngQXNHq3VKkHJk4zni4bNodIQv+DlCaUaq+JhJorRBnNepl/08yW9wYRZV2IxVh7fEcdT+e5k1wlhFpyje9m4iqTSbhesvgfpy/ibRYUJggOwhfKXQrbGAbYkOlVyWgXhCDSVfvgZboUlkpHvNRvdOiqlDqKY0X07uccELAd8YE2kCa6UFU2dr60WuVk1Kw+DZ7/LpsKAWCxPmScKq3a4lipvqa2Cg2V8IvjWlhgBfKrnBSmqOGcUH5DcRJ3dEvXvJ9MptP0C5OXWkleGMfXLOtlGf1NPgDRgEGVGL+nCJrl3Y0AMxcYOg1RQdzZAVQI0S7o4XpPlTB47c20ocSNe9DMzIYLp3/D4nYbVEYwD8T3KctOThAIT6HQk6VqCl7BAyQgsu//LlWS4F24Nwy2V5DBjmjkTtgo6Ib4Z/CK0Zbzl2Qq+78gfh9uWVQ64h2jlhTFUZNwaiaLRvPuQ+XZHMDK1U0YAWQSYUcUmFA4j0DmbxJWhLusXRmRt4VUTUJBVfUUhdHQZkQ7ebEo0Ol78B7fbtbxgNdOiTK2zUl406OffFSl2MTJAWPDqiAKlwRiX1nRf9cZGB38rwPMTgUd3ChncpictWfeWthxvd6yAsHNKAFAdUUvZmTewM3qu8tEUvFNPGc4bOuw+DnbLY/VFvNH9V1hgcH0paLcJjeoDn4+Ykq4tKnjz7aoST10fde0zkeZ5Kz42F0y1xt
 zH1laFr0
 05uB8kW/R8Rpk8VVkNknRB8Zfqr/tpGSW4v4oRwi0ssrsJB0b+zax7KLpihqX2XADEUpsgYGo7b5GqOSFAjyj0kd3FWss6k0wWQoYh9t7LKCf9gHiKMjGRfHHI8eVP4TUAdXJj2OPbwKj33IT7sX9myuq5eVHNVhH4O6zvQyKYgb7p7AiyJRmI5cUT5P5UI73KpD0jDlKKnvYIIsdOINybCZeOnjkHxoWxM5B1T0E55aOoNsVkb940+GG7/U4jqAMQVaRUkh7uRa6YnsyLTcVqvD3HwU1BhoMIYNpg3Ge5mSgD5PLveDj0EBO8XMUqvEtwYNXrFrdZ/3YcNeUm3sJUyhzbAqutHSCtwyYLeij0/VeOV4xsDJWpeCZwRPdTmC4JTB/V0+cZCGXvy4M6+Zj95ineU0pjDZHQLDEyzR++1DYPreBuZTgV91/T8JD1yHx9e9k5LQa6vteKBqbTQ9hBQMCZHUFwCjhhcwX1wqjcCeeCkS6vHGMR1eFArewF5I6uPoA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 17:48, Linus Torvalds wrote:
> On Mon, 27 Oct 2025 at 09:06, David Hildenbrand <david@redhat.com> wrote:
>>
>> So I really wish that we can defer optimizing this to freeing folios
>> under RCU instead.
> 
> So just to see, I dug around when we started to do the rcu-protected
> folio lookup (well, it was obviously not a folio at the time).
> 
> Mainly because we actually had a lot more of those subtle
> folio_try_get() users than I expected us to have,
> 
> It goes back to July 2008 (commit e286781d5f2e: "mm: speculative page
> references" being the first in the series).
> 
> I do have to say that the original naming was better: we used to call
> the "try_get" operation "page_cache_get_speculative()", which made it
> very clear that it was doing something speculative and different from
> some of our other rcu patterns, where if it's successful it's all
> good.
> 
> Because even when successful, the folio in folio_try_get() is still
> speculative and needs checking.

Right, and we only access its content after verifying that (a) it is the 
one we wanted to access and (b) stabilizing it, so it will stay that way.

> 
> Not all of our current users seem to re-verify the source of the folio
> afterwards (deferred_split_scan() makes me go "Uhh - you seem to rely
> on folio_try_get() as some kind of validity check" for example).

Note that deferred_split_scan() only operates with anon folios and has 
some nasty NASTY interaction with folio freeing. :)

-- 
Cheers

David / dhildenb


