Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815C9CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD36B8E000F; Thu,  4 Sep 2025 06:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83E18E0001; Thu,  4 Sep 2025 06:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4BEE8E000F; Thu,  4 Sep 2025 06:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B18418E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:14:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AAA5160B08
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:14:51 +0000 (UTC)
X-FDA: 83851159182.18.F48B362
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id F31EAC0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:14:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RRSGsgrv;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756980889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bq3+yZ1Iv8UyqQ7bH3U37W+QYS6AmVPIi3j4M2P4Y0Q=;
	b=stjFwg23GGek5DxNDAXWisxbvtbQoMYsIz7YkmokmQ6ptwdXbiYpOYCf8j/WipNyOcKvCb
	SU98IBAdSuv909mDIPHWF9Hr0RjHmTWx0ZVn7Chp9dABc5iP+j1pWG9K6b03WiJ2uIp6TB
	Yg3UvPK6mZfhoymOwnkqVttW5f3FJ6s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RRSGsgrv;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756980889; a=rsa-sha256;
	cv=none;
	b=SLWp3N/SF+7h4FvMtdQIb3s6MFct6gAlOpHiZkcBC8tOEh4TsC/7EP/nigTlUK9lPvTrpN
	s6arRlQZ+8CmxF01ThXKqshxl0ioFwOMc4AG7hN5Vle8XcpB+NHaqEIox9OEeo/7DuFAvE
	sKqpiqEY4bI4feqVIRkHSezDJza4Nr4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756980888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Bq3+yZ1Iv8UyqQ7bH3U37W+QYS6AmVPIi3j4M2P4Y0Q=;
	b=RRSGsgrvXn0fec53iL7abEiZfy8A3jvDHbPm3fFe/+eZMmsafGE7HEXSZvGv5e2kvo+EUU
	sv/hNY9ob8t9tjVO80kp9Xw97PV/8IDO5+5kZfnQxWF12CI+3e5a9v18HMEF547bCJuV3m
	iuBGQnbTSRq8SE6fhN52ajfcUq+gfP8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-qiDTgV3qPv-KS67oOa6W4Q-1; Thu, 04 Sep 2025 06:14:47 -0400
X-MC-Unique: qiDTgV3qPv-KS67oOa6W4Q-1
X-Mimecast-MFC-AGG-ID: qiDTgV3qPv-KS67oOa6W4Q_1756980886
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b7d84d8a0so2554315e9.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 03:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756980886; x=1757585686;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bq3+yZ1Iv8UyqQ7bH3U37W+QYS6AmVPIi3j4M2P4Y0Q=;
        b=E/Nv/vcVMxcpX9ZB1XBFh7uhCsEd7+EE4WSuMTSbRQ+EOOhxgvj3o3jJ0qyvCnVK/W
         z6Y5iSp3bsvY170iN0xEnq4VJR+yFlSFq6CUDOX2fs+gE/05ZhsJQmDcT2pqhFezTAh3
         SIDXA+vQbRkrJ+RZB3kZTRLZjWJ4ux/W5BFLlal4Nf6hrOmpMYDGnkWWL1+BiZ2w9huJ
         j1IbP9BUoIw+WCVyP1bjGe5QJ/X4b+iXdsvCHHT+mbi/vVUQ4ZmJKc8Lb1v45f75ivkQ
         cbntVYBd5q/naUruB/mh181a1UYPpvQ9T9f7bihmD6jj2nWbLEoonuukCwGHxQzwJTvK
         NuVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeHIB6h+PJpyHJQ6mHCt4wQDvfxwNT4sPvqi9rlx+qzV1y8UKsXiQopASUYzcnFEQLEzn8mDzaJw==@kvack.org
X-Gm-Message-State: AOJu0YwdEwojV/mMksAeNdcOeHsYIgBoxh/tRLKfNo3lNFZYLebs5hj+
	0W+IbrKN6jujcImUqR/uezzu4DDyzST8ogeliULm/MFe6GjUEDy+QmhtwOP0GViYG+Q1QxtY/3u
	RouaQ6nig/g2vA8NT0qN4hUhT0269InJlt3CExYN75iX2nnxv+YYk
X-Gm-Gg: ASbGncuMWMjSRQBv9lsAZQH4eJSV+MLEya0Ap2AibrXIJzDcbE9/MbnohZs25lMZhgY
	2kChqW4VAulRE1oFSkblvf961R/DMuhSvW+WlBqfedkDUUzt/iCjRRJzAfXOWUkEIvNkTN96Bht
	j2PPVDRH4RjxFqPPU4yQUHD1uL6Qi6DQV+q308TTj1proap98D3ZvsyUshpHTtP0PZ/JU/O/HKz
	lL1utEVXO9Z3eWghi+EZ8sFUAe7xRuD8SbvHuEwY0V4PDLWsxE2PI6Sed69GBVWKGV19RermZBb
	jO7do+9sJ3U9UdcNORw5cBWbvbdcIHzeY/VSr7YBQXIeMxq0BNwtBDgwErObKI1M4FBzqqpvbls
	eDCGn3wReXXfvIKNoceYMJ/lnZObEVXtGBYDU07ivBrwBkbuey3OEG29KuyZR/R4v
X-Received: by 2002:a05:6000:65b:b0:3d4:a64:6758 with SMTP id ffacd0b85a97d-3d40a646c13mr11675673f8f.3.1756980885754;
        Thu, 04 Sep 2025 03:14:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoV8B0ddFyYBgqKe2A0XZ6K4brZeQS35NUh1Kk9RoGnZ+inndQam3GisCaFoly+ljkesvlfg==
X-Received: by 2002:a05:6000:65b:b0:3d4:a64:6758 with SMTP id ffacd0b85a97d-3d40a646c13mr11675651f8f.3.1756980885372;
        Thu, 04 Sep 2025 03:14:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e21e4c0e6fsm584448f8f.17.2025.09.04.03.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 03:14:44 -0700 (PDT)
Message-ID: <3997965c-4cc6-405c-b6fe-a70b4e75afa6@redhat.com>
Date: Thu, 4 Sep 2025 12:14:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, lorenzo.stoakes@oracle.com
Cc: kernel-team@android.com, android-mm@google.com,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903232437.1454293-1-kaleshsingh@google.com>
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
In-Reply-To: <20250903232437.1454293-1-kaleshsingh@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pXC_11AYEUKDbxOlRPmB9ifts783DENIdrKSPRUjHt8_1756980886
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F31EAC0004
X-Stat-Signature: ttwy7q31gx3wg5bj4k8abzw668djhfxw
X-Rspam-User: 
X-HE-Tag: 1756980888-146702
X-HE-Meta: U2FsdGVkX1/5C/vANsoQc7vSsAjXZRPpsmod6qoCt8q9+bMKJJcLNzflAjlYMB0Fk3z+geGasaK4gJypUN+KGe6dnDDbuVnL7SIP0JGALfOiTPmcyR9nTNd4ZDDbsfhdEos4gh4DFLKoLZwJ8vnbLUo3Ni+eqwyJty6/kwmhyTrJMf/vCzg+fFr0YiCQSRuoyZOjxKHqf8tl+pKhuwQFpQB5bW9M2A4/hueLkwbWdP6ETETwKs2cfKGdHUjDPaZlac1rKSmlXq2+qwUEWKhf6s4ofKtkFuqu9L4NVsdTY03rY6OxVWL15cerEHl2DmL9oN8rHsCNgAI+ggW1FCVZxgrEhyDMpeX7FX5MaJ0DkbhPe6/EDjYuP4BPjHZ/F1s8ltMyfDLVIQu7ud2UY4qSeaDs+22hjUmawwwAokR0k9Do0ebQPa//lkSMoAZ4pSJngF9dGwt3kIMEACn7BfBfhwOQbL3WinXtMiZGwORrWUfN1/m8KhqEx/VyVXz9t5DWK/xlK3OyCWMhPopph3Ix5ToSOwmh6niN4UmYENTRRzSvQKEJ+O1doNWcYehqO1rOTdz1jllAVsczus8N2Db03abQEwvNbM7SlOc+8rZaWxUrtYD8DvXMX/yhTL2PJUEPKyba+XZk8GkpvheFowO+X9HJiOb0eGLviMM/VkvJ1ZosMQuItk2df/uTUW2PGWe+iOB2Re1Y+Vd/DpApQaU8QkAnWoNwEQmHFJF/iXrrKI5raqpxePWz3dwDForDSP7BZCrXcoav4ME6UxjEZtSMq0k4x4/x/Z7tEbCuxo37hKTBmzHz+pJ/1X80A3bhXgDms3c3Hqo97VH4Lip8j4yaCEvYkVCOlEOxkZCfC7F977Qe2Bx+1CEfhpfGS2NEv5z32TrV22W3yePKoY69/4d08N7lAz3EVN9/Wb6GXK0UXkodCXqb5y1LaSvgyiddTRBw4hCe3tm4aYb8LRsfbXJ
 8RWKWzZI
 i11guuvdOjgXNJISBsqvJu7fAaReIiweFU+3NznE/9pnGeuOyCBkOlUFFqr35Gkgq3CLap4n6omPsGatySa1PaigN7re+yoASSO41A//8ks+T1Wl2ut2ng9mm9ZImpdrIykaxE9BWBv1k+Gz6hIilxFAUo11mwdVXYI4aQ7J8mcx+9An0TlgpGnP6S6yuoFvlBhPmJvlru8D6BgR+AZcDyZhJyJQQn6yXOEguqR5bmTKA8/5Yp0L4pp+Apgec9yTUeSTYysqLrF8tGie+cGBPdsRVyJ/nh6IUsWYDUOmFWkR2BabrrtnLogo0T1qwWdy4MMe7+I28v/4Oz1RCNSrOTmEWsXyzOkOFiG+WIn//WTIQlq+GsVSsYl2MXIuxMtxky4qWBMvGVgWkcWKfXT6UG8vfuSsILaf5aFuwbWhcozM2oc1He46tp5tk4kF+wmG3ZF7rscLg9d82yexfLfuFy73SETS12luFOOfY7wl/45EZ6HcI48zHsltEPcEFLeL59E+rwdf2tz/5umSPu/gY3elO3Vrj2IxOZbX61bS5R6pUYapM/NK01qZq4sz8jdX/4j/OOQhCLoQBJFy3Lk0TUs+laQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 01:24, Kalesh Singh wrote:
> The check against the max map count (sysctl_max_map_count) was
> open-coded in several places. This led to inconsistent enforcement
> and subtle bugs where the limit could be exceeded.
> 
> For example, some paths would check map_count > sysctl_max_map_count
> before allocating a new VMA and incrementing the count, allowing the
> process to reach sysctl_max_map_count + 1:
> 
>      int do_brk_flags(...)
>      {
>          if (mm->map_count > sysctl_max_map_count)
>              return -ENOMEM;
> 
>          /* We can get here with mm->map_count == sysctl_max_map_count */
> 
>          vma = vm_area_alloc(mm);
>          ...
>          mm->map_count++   /* We've now exceeded the threshold. */
>      }
> 
> To fix this and unify the logic, introduce a new function,
> exceeds_max_map_count(), to consolidate the check. All open-coded
> checks are replaced with calls to this new function, ensuring the
> limit is applied uniformly and correctly.
> 
> To improve encapsulation, sysctl_max_map_count is now static to
> mm/mmap.c. The new helper also adds a rate-limited warning to make
> debugging applications that exhaust their VMA limit easier.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>   include/linux/mm.h | 11 ++++++++++-
>   mm/mmap.c          | 15 ++++++++++++++-
>   mm/mremap.c        |  7 ++++---
>   mm/nommu.c         |  2 +-
>   mm/util.c          |  1 -
>   mm/vma.c           |  6 +++---
>   6 files changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..d4e64e6a9814 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct page *page)
>   #define MAPCOUNT_ELF_CORE_MARGIN	(5)
>   #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
>   
> -extern int sysctl_max_map_count;
> +/**
> + * exceeds_max_map_count - check if a VMA operation would exceed max_map_count
> + * @mm: The memory descriptor for the process.
> + * @new_vmas: The number of new VMAs the operation will create.

It's not always a "will" right? At least I remember that this was the 
worst case scenario in some ("may split").

"The number of new VMAs the operation may create in the worst case.


-- 
Cheers

David / dhildenb


