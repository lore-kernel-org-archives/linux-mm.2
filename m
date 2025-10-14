Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203E8CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9EE8E0108; Tue, 14 Oct 2025 08:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579428E000D; Tue, 14 Oct 2025 08:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441DC8E0108; Tue, 14 Oct 2025 08:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC818E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:27:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDAD3886BC
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:27:14 +0000 (UTC)
X-FDA: 83996644788.30.4A52890
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C9F21C000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:27:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SnvBhIjl;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760444832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZXFr5KfRNnRAUwcPkoZ2FdzZWPO0u88EnCDpNDOJ2w=;
	b=UF11e0EdWr88Ukhp/fcEj8r1fvj7PyC+GnMCiprt4TLK2Yjx+4OZ7qOTV/NSvoOJCdu5+N
	50vmpWVo5kva3qiMo4yFmbbs9Cc74MwwrXXSaTXzJiepPdTANpLfZGOXPp9Fg9OJklhFt2
	okkgf3wNS5Xm2eZ+5DO/SJAjHW9aujo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SnvBhIjl;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760444832; a=rsa-sha256;
	cv=none;
	b=YPbEoZcYBeKxMSLZY++5UcsjnHcbmbGcWFFJrfNOZSAHi035/UGcR54mQIHZYzymZ1R5cl
	VG2tzdfW90NOaYUpJNana2TWapeQcGk94Xk6VvZXtnMTuyFWTFYJh1UOqMKlZiKhGE/+dt
	ao27tixrbLAn7jTAYUoH+cDJWiRIBJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760444831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HZXFr5KfRNnRAUwcPkoZ2FdzZWPO0u88EnCDpNDOJ2w=;
	b=SnvBhIjldj/YfL8QgtI95WK+X/syIJU6tB0hk5BWlrLJQKG61MLsxUOMs2FQCS3Q6QHyw8
	i+mna/0Ookw5Hgdh32PRQS+eM5zHP/hpvMvlr/b5wryxMHrnW2vmvqH4y+9fakITnvhu9O
	ATeZezH6EfrcdmnHTQ7MEaLidrDUvCo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-IVybqAStO6C8GPSb5m34Aw-1; Tue, 14 Oct 2025 08:27:10 -0400
X-MC-Unique: IVybqAStO6C8GPSb5m34Aw-1
X-Mimecast-MFC-AGG-ID: IVybqAStO6C8GPSb5m34Aw_1760444830
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3efe4fcc9ccso4555452f8f.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:27:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760444829; x=1761049629;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HZXFr5KfRNnRAUwcPkoZ2FdzZWPO0u88EnCDpNDOJ2w=;
        b=Wv/pQdz89ulQH2u4vvXmSdXZK3fmrWVFHXvbdB4pPUVR9eTXqYof9yp+SejzmgWu61
         fk75L5VqF4Zs28hzh2RBw8Rj2g5s45G6sVZb7BGZAz+P7bl286Tm74/EOiMdjdFX+I7s
         ZpFyAl5NnGIcQ9SXMx4ZBEDE8rYgmBdr/Fsh/TS0VHueoU84O1BLmiLPunM+bl8mQkW0
         cYNfM+M+cQA4oY1Vwxanc9QWZtUHAJ/hBzTWZpXxiD7ua7eE1Hw4nAgApd5DOdZzhqtI
         WHp2MCPoD4XVW+NupZaSJpYxjaMjpBEd4HCLxjlsaXRRwg1nSzOwfKJBzBGpJjyX/VbY
         8Aow==
X-Forwarded-Encrypted: i=1; AJvYcCXWc7mGbE5sAZYXqfGTVJN4OFRYEV3dpcK7ZxGMs6RXOlk2NDw6dqDk8SaHa605bjKPnw4m9UqXMQ==@kvack.org
X-Gm-Message-State: AOJu0YzhS/ZUZC/sw02g9xBEkSxgGlwVkrb/wY0muaTLF0f5/3BmtHZU
	MbuJMtdx0FmCU6E5kuHL/JwHmqYKY2KMXYol6u9NX+kVpmBxfsBpa0GKRthhfTt+JudbWOudJ6u
	Q/EJw5ufORbYcdBcb6C6lKKQ+8c4juP9hAoiR9CSO0VAp75u70Rhp
X-Gm-Gg: ASbGncvrZWwm+z6OD3N3oC0d15mCHP4Yxi4Db6R3IpZyqgsjQQDWHNSRcX/ht3nJxIX
	qYJNc+1HPjR/5sqUOoWJE/xVE2jvFkCMGFHshu6S9r4Q0wbfimYaGCEKYdcyxJXrxhvaTjiLpYh
	NXC3+iefzRJRnZFqg8F01H9YQbVQOvulBaynxGYV4IR356Tq+GPoX+hA38JHZ7bF7pd00FZvZft
	QzYe/b1zNJoyQ/+/OR2F3tn1xWsuJpq8hqSzvM6XbRJciA05CSA/Sjmd+go8Lm9HtO3wZDY4YdD
	cACs8LugpL2LcjSWwIsdhnfmvxMri2kDUKzXZRQA1AW0/LLnlAnDKpxaGs8=
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:e365 with SMTP id 5b1f17b1804b1-46fb42ee3f5mr106213995e9.39.1760444829046;
        Tue, 14 Oct 2025 05:27:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvJYRneb0mqhfEJogc5WjuIbEc8spmQmpHChaTcpaaF0hqmSPkzGROCrzFQ++irStZBWlARA==
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:e365 with SMTP id 5b1f17b1804b1-46fb42ee3f5mr106213725e9.39.1760444828650;
        Tue, 14 Oct 2025 05:27:08 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb48a6069sm238539115e9.20.2025.10.14.05.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 05:27:08 -0700 (PDT)
Message-ID: <cfbd4f48-69a0-4ba9-bce8-f578d9602125@redhat.com>
Date: Tue, 14 Oct 2025 14:27:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 1/3] mm/khugepaged: optimize PTE scanning with
 if-else-if-else-if chain
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 richard.weiyang@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-2-lance.yang@linux.dev>
 <3982686f-908f-4f92-b3ae-e6f141e617ef@lucifer.local>
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
In-Reply-To: <3982686f-908f-4f92-b3ae-e6f141e617ef@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: haCemeoQWjv0kwcze_VMleGRBDn9E79S4suwHC38Sdk_1760444830
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9aqn4otkfpcwq8owq8i58h65136zez83
X-Rspamd-Queue-Id: 4C9F21C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760444832-620786
X-HE-Meta: U2FsdGVkX1+frj8xNaEsgZ+wj7WPJzm/px8LyUqldEq3QXTPTcdFPwBJHAu/dye5sBsHApxXqXIOjuxHaIbRGyNgFs3KhTlOkiJi6MW7DSikWEbXPap/adiEfSj6nHo2cmdHpUBmIPnuEzxK74lPk/kK0Qx+JNbNrVqHffL3h8u47fNrViwj+ORzNjb3aRzecQUS3DoYcffsH6zG8PhAw4iI3WoYyW3z7WJsZ09p+4+Pnbmd7GY7VawwO/oeAz9TKRBlLD6M4OPWW9IlVoztSoOCeTKvrSsIOKt5JMJNJEmsYUo9XMdOJkHyovUh4iDmbT4CdWyWwQaZbaftZbPtj+ShSBw6K9rYunt+Q/DIogITDfBlUDJZo/1GCwQkfLWo3RmhNM00M+mqdFWSOHXg0oPSF3BqmXz1JkuoBf8W5pUHN/BCSlzgnTLqw5i+wbjc7FuAxocdys0zSFHMQIO8lcYAM+Gnol11dOAEWt8YUrFtSA1fRmoVNqCUYmZwDIu3K0JGcEDzg5ZUCAYb6o/NKdnUnZ7dSuspntV2E6J81XgY4svDAno8/eSOvVMRMCALZewicGUYuLRuz/un7luJjUcaBnRAevQedYMl0aTkhOgkKjLXLMS8YN1oEj4Hf1ugLWz5TrPtholGBIkP/c0guOkl22Hre1UOz02RdWiDhpj0VQJFFYTClqSfdJj+EuavLmirjm2OMMFnIyx0Iuj2PCQDKN62T9ttJyf8Po8Sn1V00+uQwJeys0NWjOMYoQZoAL8cBxHtBVa44hc2isRtjubccgb1SkS9iVd+oh2hLqRHu7p3bVP8hgG0XB0ZwNg5mwVRGYQt+P1VRzgYTBAbeNWJePb+XgDKfX9kfMV0kyyWfRdXoyEjO0sZsNoFqslXccKbSA89lv5NZrE91azql6kE/yArtBfNgACTT/wh2KGqiPc917tBxNQCdpOUggK2bFbhOwcP1pVNKGIJ0Hv
 HaMk+Upp
 qOpZkZ1t/3gnWl180tgdK8AWR8U1AklS6+jGOzgC/2FyUSGSgELojP5QlEXNLJ5sCNox9VCgfChF/4K5hfGbxG5L8JtUvjubCTGCVtFInAQ1f9xTCakCDfkt6+Sp8kLnKcoRSFJLN0if4krRaXy62NDzQed+HACfRZLvTNR/xatNYhuE5cyYf93y6rCLapCpGsfDpb1OJf8LKn0V54npr7OSkMnNkJpnqRqIRlnD99zj6byOed8FWD8Igun7uzkOaVTAg8dIYp5fITLsnGriPj/U4L/4evSBDezQQvsLr3U/7EAbjdqlZPH7AqTDj8cWivWJIMMF2/LNW4lR5URA3iwZkpwT1HHKpi2/ts+BPkn5y9w+6bfdTjYcZl6YGU4kMzbUvmZC4F+MPOuJUrxom/X4+qTYiDeyfheqwoGayGh0iKtkq5BgL9CXKE+jZ2udaoT7A0SyzZUS95EAHFZWfnq+XiIi/b1Bn7EhsBJhXsDQfbD7WC3Af+/inOySgky51OPQm47TlSj06rgw8zLGFJ6Dbgiwizr4CE0+FCqUeDqML0DRe1pn2Kln4TRHNh2y3qVSYMo59o6KKkhnS1ZSIASAGFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 14:17, Lorenzo Stoakes wrote:
> On Wed, Oct 08, 2025 at 12:37:46PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> As pointed out by Dev, the PTE checks for disjoint conditions in the
>> scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
>> and pte_uffd_wp are mutually exclusive.
> 
> But you're not using is_swap_pte anywhere :) This comes back to my review
> quesiotn on the series this is dependent upon.
> 
>>
>> This patch refactors the loops in both __collapse_huge_page_isolate() and
>> hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
>> instead of separate if blocks. While at it, the redundant pte_present()
>> check before is_zero_pfn() is also removed.
> 
> I mean see review below, I don't see why you're doing this and I am
> unconvinced by how redundant that check is.
> 
> Also this just feels like it should be part of the series where you change
> these? I'm not sure why this is separate?

I think Lance is trying to unify both scanning functions to look alike, 
such that when he refactors them out in patch #3 it looks more straight 
forward.

The missing pte_present() check in hpage_collapse_scan_pmd() is interesting

Likely there is one such check missing there?

-- 
Cheers

David / dhildenb


