Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC1FCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 17:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EF18E000E; Mon,  1 Sep 2025 13:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08ED8E0007; Mon,  1 Sep 2025 13:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCED28E000E; Mon,  1 Sep 2025 13:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C76398E0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:06:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 754D41A09B0
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:06:32 +0000 (UTC)
X-FDA: 83841310224.25.C2799DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 024902000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:06:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EVZ+yMWI;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756746390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eh14gSBsHlX8t4z8lOLowLFjFUmXdmvvFT/ssHquVjA=;
	b=DS3BhBhDTHcZq4jz+Ked8hmAFHRRdlY9N8vpXsIY4f1+WOpgW8JMxZgd4ryn5chBd8tnzW
	Mqy7q2M74xAn5UbLiKXbkqxTWl67mrMbScldZ6VV+PGVVneXusmHCZOYwY7kHYoa/xrMLd
	GAbTbd9R8DRT53JuseunWNFlsF8E18c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756746390; a=rsa-sha256;
	cv=none;
	b=gnIPSaKa73NzOAd/lmlKfW8SY5mfyunRfBUpWqepdnHtILYBhfl+L1bdg8HcK//P+ekedn
	jjZXi975frOeIFjcRLsR0FgNP5OZwFfGIgCzXLGOMvlZKdV5CEwGri3SAgMXhp838eGaUh
	Agsi07gdGUy/bkX7+H8zeQdJ8i4+WWE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EVZ+yMWI;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756746389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eh14gSBsHlX8t4z8lOLowLFjFUmXdmvvFT/ssHquVjA=;
	b=EVZ+yMWIEBsDn5NSx704/BTtHmcDel0ngrzfz8ZI6O8gWzgFJU6gD5evjWyWezO/140JT5
	qt4nM+dborf2TpYw9Q/3iodbe/UCbl2nmGD12W8C0i/aV1HNSYMsJHFKXkCINJlOIJxxQ0
	5/bxrGtOC7epVWcTGTwFUr6DXpXrG9Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-BoPjKKWFMWKflnDhoKhsKQ-1; Mon, 01 Sep 2025 13:06:27 -0400
X-MC-Unique: BoPjKKWFMWKflnDhoKhsKQ-1
X-Mimecast-MFC-AGG-ID: BoPjKKWFMWKflnDhoKhsKQ_1756746385
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3cbe70a7861so3274242f8f.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 10:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756746385; x=1757351185;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eh14gSBsHlX8t4z8lOLowLFjFUmXdmvvFT/ssHquVjA=;
        b=veraA1d17Ob7pJ7CfubC/v2rt6fhC6lCWTZeHx4qDfuFGFSf51LAEAALGlj2WIV3pk
         u1SF/aAye5Bmv4vdbC00Skt81xvCahZ2vpDf00zKqg2boDdIZ3309JtGXCGhhUIMVKPg
         RMmjVncXW3Zs2CUw0EF0c+oxBBYyprYUp+SzqnLxuGRubLknpzAuRNrf38ApWk1WF0OT
         2x5cBc5X9idl+8TnlOROn0Th5Z2OlazvTL/9D8SO4dW+WiZEzPl2XT81RvQoE72nef1Q
         A4ZRM5x+JKc0xqqfnt3l8eGQcYU1oeDzCDLwYN8NPvwAeA9K+I6GDg4nQDxG7uX+nWYx
         UkXw==
X-Forwarded-Encrypted: i=1; AJvYcCVT1VI5LSvFMk+aSBL47S9ZCQCX3Lh34ZGZsa04wjpVd2SqprkE0TUMSAlBwBmmtXpyQz/94OEaLA==@kvack.org
X-Gm-Message-State: AOJu0Yzs8kp2L7zKNgjVCyjLIk+jwJ5s3EijS3EbpuG7iSHKuEhZF6df
	gMN3Ad+GwtVYYorvKkEjqu16Y/vJewlIHrPoUW3jOGAtqpXb9A43cMfNTwqEm7Cf83j9v8QHpeJ
	QPS0GtbkqjBS48pnrlPIhKrOiI2Xt6Z3PEmoX2a2Yb0zUv44J4pe8
X-Gm-Gg: ASbGnctsFG2wR9pHbaJvv+iilYoHLr0i4H9SVgs2+kw/5RYoI5f44qSG2HNe3ybjnfv
	sxp/3NuYOH/NzEwy8xUwel1tKk8K3hNh09aaP1mwzAoXVCj5tNCUaKBkd/ZTKGAGyzKnJSsGN9b
	GHV2cdKVCSue0+ofMPqg+izetnBs6x44UaoqeoM6vGunzTTgtmw0Tgqu2AeXH8KtR/NA71Ewvwf
	V4MCD1SA95jRuw4qXC7Xip4Y7jkW1z2D9zCtBvVYh1FoPWjP5Su4nd7JxpAOTQ2TvzCPiaONeBi
	X+INNQIImle3M53RBtOylHuNyImRN3yFG+wGeBVEy1A2wWgCf/JlOzsq6/n5At5Ab/HlXTUc98V
	0Cv/CGAxBGbId0OQJ3Em+OoOo0iIXnjxcsQ4XB+94qBNkewTEbvGD4bRER4Z2y/Tnn2s=
X-Received: by 2002:a05:6000:4205:b0:3d9:415c:b146 with SMTP id ffacd0b85a97d-3d9415cb164mr902842f8f.15.1756746384875;
        Mon, 01 Sep 2025 10:06:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtXV1RpZ3Z9Kk/q7xvuAzJpMudeH+8bX9H5YuBYHQqIOkcUcfv4sOsuljm2RvZo8tcSQgolw==
X-Received: by 2002:a05:6000:4205:b0:3d9:415c:b146 with SMTP id ffacd0b85a97d-3d9415cb164mr902818f8f.15.1756746384422;
        Mon, 01 Sep 2025 10:06:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm247892275e9.14.2025.09.01.10.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 10:06:23 -0700 (PDT)
Message-ID: <bf03c2e2-66fc-4745-952a-de3fbf65c4ab@redhat.com>
Date: Mon, 1 Sep 2025 19:06:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
From: David Hildenbrand <david@redhat.com>
To: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <7d423d50-47e0-4c97-abaa-1fa865ec3e42@redhat.com>
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
In-Reply-To: <7d423d50-47e0-4c97-abaa-1fa865ec3e42@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ICLFMjQzY80XfwHVkb1EunUgPJYkSp_gKJpBTT4YaMA_1756746385
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 024902000B
X-Stat-Signature: zpxbndezrjdbjf5aq5hzyazpopnc5bon
X-Rspam-User: 
X-HE-Tag: 1756746389-335273
X-HE-Meta: U2FsdGVkX1+wwav5NXEQELJghj69v+3D+pToP1Pbcci1YKdLdS9EEDbQV7hdFpYabgodS3oVtEN+nZ/guG3hWisofrMmYjj3+I59/ekZ7gx3GdpNDah+lhRco53FjRHf5iRYFR3vEHz1XaBjSq+PLORSnO5BPtYfwe+PrgEH7OVWh4dO27y3NZv1eh77oLHyaB4sjABaJcslJ7K4Ri1MOdfxZ4W8N1dsYWynNyrf7KsWMf+CFLnwAWYjdbUjMGdo9tVc4XVwJCITVUbQYNh5FUqTtnoDhO6Q4jpIjTBvwmP+arKOtDUnkUhqdZAt2sq9me50CYrOcchhawaXxvDHPHL2/FzgV3PzRemXTP8j9CC86a1zEFBccI2DA1nWw89Y0AK8mBvnZwG1bFca2QsaPJuKlcflsIif7yWcNobejwCiHv4LwdXzl/1AEoHBnBIFbPt8sprM6be+bmPABfg/ZlVvJFiX3AbYuef3E4vI9i8B00fHafk+EAbUnY1FypYLCFoW7+F+urNLQzOKC7nhmFjL+awovTsJpRndSAXA7jOL0prl2g9SDIKPuFSBLGgTCrl5kqjBB1nUIDzt1A6oAjs+wqwpvHtR0WrcPq11Aff90WYOdnCBwgF67u5NQPZwuq1Es5VsURxVZQiUcY230fY+dEvRZz09CIrXkhMhZP6vd0+ciYlPpkM3A7woP71Hc55Fbc5yIXmfa1/g+Xs9ApAc1aHQelV5Cxt3Sx3zPBIdHyFueO4nUcx1+kQ6w/X4ClW2GhHR1pjzoCn6yu58zjeMpppsCRyYYbWhQqQJmqcvSdC+JiDYTdFU+lheLlhEJ4NTUfyeI0xTUV0+C7xTn/U3LlbK9O+lh3WzCOIRTPLUZ77/NdwZdLfVqnIeh/OtW1AT401B5GnMb+QKgKpDW5Ug/FWjUXQi7duFAjIJufbv8aK6H/k1pDef9939jAtyn0bPVsB8AhpuaE2GJZI
 vwiP/CDt
 Kzu13luHPFrRSnDA3cS0FYcx/UHw6STIVyI+WIWUL1dVT8yUyuhUHern9v/rDRSaDCDu5pZaaekJD+XydSKkY0P3O4DHA1onnuxH63hp5uDqrO5uhH5EfTOkC/vLMlNC5x8lEXkGXoajx5rDbHQc1M4Q5RCcju0Xd7e8RTTqw3RYVdip2ZVHXshMzRBUOxr9jBXFnhtQGdpU0wHrrjSpk/dcR89kutGvns2QcJX++HJYU9lEPBf69zSOqmx90SRE9+ntKJiEGRtykcC5sW7CYERIPRkXcJRqkZ3PF7SXxZXrLIPa8AdekYjwTx7jPp3xbpmrtRaHlG5CVftnC4ZIjKO4InQGydNbBHTntdwJ3dBVOIruXy7kO5r58UVCe+7CtQGPtJ6gvfq10EZ01NpRwaWXh4W6WjlvZoU6XXqEneMs1iAKNIIAhFWyCViRRF22QbJ+Ph/RV/4IyAd5JfxE0h4fPv0SbiC3C8rKIRmXjBPzaCPPYATh8Cpc/VML+wlcTfC1Z/DD2Iy0eX1J32EftwwTkgRAcsVZtvogfX2j1mL4BItflIjEXLqpr84aC/o56Eq4WjhDIFogk2PsPpqHKV0WSiNEGM0FIwyDyiQ+ICJ/TDNCbmahzE5K0w8M200SgmFRVUyJf5Q0L2R28YQvBNBK+DOs2b2QrPxss
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 18:21, David Hildenbrand wrote:
> On 19.08.25 15:41, Nico Pache wrote:
>> The following series provides khugepaged with the capability to collapse
>> anonymous memory regions to mTHPs.
>>
>> To achieve this we generalize the khugepaged functions to no longer depend
>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track chunks of
>> pages (defined by KHUGEPAGED_MTHP_MIN_ORDER) that are utilized. After the
>> PMD scan is done, we do binary recursion on the bitmap to find the optimal
>> mTHP sizes for the PMD range. The restriction on max_ptes_none is removed
>> during the scan, to make sure we account for the whole PMD range. When no
>> mTHP size is enabled, the legacy behavior of khugepaged is maintained.
>> max_ptes_none will be scaled by the attempted collapse order to determine
>> how full a mTHP must be to be eligible for the collapse to occur. If a
>> mTHP collapse is attempted, but contains swapped out, or shared pages, we
>> don't perform the collapse. It is now also possible to collapse to mTHPs
>> without requiring the PMD THP size to be enabled.
>>
>> With the default max_ptes_none=511, the code should keep its most of its
>> original behavior. When enabling multiple adjacent (m)THP sizes we need to
>> set max_ptes_none<=255. With max_ptes_none > HPAGE_PMD_NR/2 you will
>> experience collapse "creep" and constantly promote mTHPs to the next
>> available size. This is due the fact that a collapse will introduce at
>> least 2x the number of pages, and on a future scan will satisfy the
>> promotion condition once again.
>>
>> Patch 1:     Refactor/rename hpage_collapse
>> Patch 2:     Some refactoring to combine madvise_collapse and khugepaged
>> Patch 3-5:   Generalize khugepaged functions for arbitrary orders
>> Patch 6-8:   The mTHP patches
>> Patch 9-10:  Allow khugepaged to operate without PMD enabled
>> Patch 11-12: Tracing/stats
>> Patch 13:    Documentation
> 
> Would it be feasible to start with simply not supporting the
> max_pte_none parameter in the first version, just like we won't support
> max_pte_swapped/max_pte_shared in the first version?
> 
> That gives us more time to think about how to use/modify the old interface.
> 
> For example, I could envision a ratio-based interface, or as discussed
> with Lorenzo a simple boolean. We could make the existing max_ptes*
> interface backwards compatible then.
> 
> That also gives us the opportunity to think about the creep problem
> separately.
> 
> I'm sure initial mTHP collapse will be valuable even without support for
> that weird set of parameters.
> 
> Would there be implementation-wise a problem?
> 
> But let me think further about the creep problem ... :/

FWIW, I just looked around and there is documented usage of setting 
max_ptes_none to 0 [1, 2, 3].

In essence, I think it can make sense to set it to 0 when an application 
wants to manage THP on its own (MADV_COLLAPSE), and avoid khugepaged 
interfering. Now, using a system-wide toggle for such a use case is 
rather questionable, but it's all we have.

I did not find anything only recommending to set values different to 0 
or 511 -- so far.

So *likely* focusing on 0 vs. 511 initially would cover most use cases 
out there. Ignoring the parameter initially (require all to be !none) 
could of course also work.

[1] https://www.mongodb.com/docs/manual/administration/tcmalloc-performance/
[2] https://google.github.io/tcmalloc/tuning.html
[3] 
https://support.yugabyte.com/hc/en-us/articles/36558155921165-Mitigating-Excessive-RSS-Memory-Usage-Due-to-THP-Transparent-Huge-Pages

-- 
Cheers

David / dhildenb


