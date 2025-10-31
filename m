Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D56CCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 07:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7173D8E0077; Fri, 31 Oct 2025 03:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEFE8E0042; Fri, 31 Oct 2025 03:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE058E0077; Fri, 31 Oct 2025 03:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD198E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:58:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7B8A886E3
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:58:23 +0000 (UTC)
X-FDA: 84057656886.09.9066373
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26DE9A0007
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:58:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aU97ZAEW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761897501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2eS52tk9i8Cbqs2+QfmKwdWaz22X5NSaWz8+XqnQXE=;
	b=WLCJqF2O9XLiHKk4Y1FwRk/sK54D64UNQsiyWahmpaIlViw1tUqtcAF/N+42/Jtna77oT/
	MksbRtG+RQ3Ghsm++CxtoQu0OEIn+vRS2ZhyRUScirdsOtZwRtoo/Z8uIZXjMS8FEZQCP9
	uoh72sDDFy5gIohmvmbSucQqnjv4Gno=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aU97ZAEW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761897501; a=rsa-sha256;
	cv=none;
	b=puzortALKy3iRrOtduIuR5wh5PohiZxmkP6OByuSdi2K1r78J+Ams9hAQhZitIUFH0Txao
	L/pBhn1X2GU5nTGQj+vvAcuJVqKCHDLXrkpKd8Bv5Wc2IACNZG0i806pI3Wjtdt5XLsN61
	n/fPqyQG3EGKkJiefDj8L3QlLNIQ9lw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761897500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S2eS52tk9i8Cbqs2+QfmKwdWaz22X5NSaWz8+XqnQXE=;
	b=aU97ZAEW312FMy+0zH2yE8DfdvhI6wtp+wmJK2cva5R86im2VXibUJGmcpAcS+75CvwJ1g
	p6y84Ky7TdaDqltAcafPRmpH1kIJt8Aw/f8M5T9rPTdymsUNNKE3jC6G1XRKKjmSJUiySW
	tO1CUEfNat2oZqfj9EXt9IISL16hJ2o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-ABrZq0tLMKeY-EPJzrJJNg-1; Fri, 31 Oct 2025 03:58:18 -0400
X-MC-Unique: ABrZq0tLMKeY-EPJzrJJNg-1
X-Mimecast-MFC-AGG-ID: ABrZq0tLMKeY-EPJzrJJNg_1761897498
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f384f10762so2083646f8f.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761897497; x=1762502297;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S2eS52tk9i8Cbqs2+QfmKwdWaz22X5NSaWz8+XqnQXE=;
        b=MG1BdaxnqMJfcgTKJvn7lgaGU47ZqxVYV5upRI5Q0Tvtz0MP8awAGEXxmD3MBQmxHb
         cwhe3M7c0MaXQDbSTcDarv+VLyC1Q28anl2z9NHmpRmhUn9jBYtb40TBeUNa/wAiqzk6
         95IQJF0HBOgJ4iDD7nEBCVsuAJiYGLeciN+PnyktZfid2SpU7AK8+mVYTzrtzYyn//Qi
         7TP7GR2Y/P7G64AX6xhKNm8Nf+BSoVavL+VNE+uUa+O1GUMS19tyGXDYj9oPN63p7mWR
         z+rkgrb4j2ySnsXvVZDxEtmG4aFRnK3bFD0om2b9PPvcbvPX8dMw8HOJT9IEHnHto9yu
         tniw==
X-Forwarded-Encrypted: i=1; AJvYcCWKG/S35KjlLbijtduESWTw7DbLIhiBCQ8n4YdezWLoFiWf7P+JmY1VG4pzdvzkCc4aYgacmmUx2w==@kvack.org
X-Gm-Message-State: AOJu0YxZtPmHYRQ4Z+SZ2UFVsJJh9Ka2w/5kGY307Kp+cUrvugFF+u2W
	fKpfCJFMlBr0vXaWpFQx9nT6s9bO1q/Vpy0Pz0ntfDfCq/v62LY05bBseCjd5oHwNLrbFc+eCfT
	0YuRhli3+YldbcuUnqqkTZO1UWB+xzImE485lWJi8zkGTIifFxvdD
X-Gm-Gg: ASbGnctOxs7EXO7ERjI5HriGHBLojslYlTHtR3ua8tnC9/WFpouo3W+lan4zUomA1Yq
	/DiDYXJ0w0woS604Zb8YqP+ng/18zzocYigPPTNE/nSg7hEethJHyNMfqf5Akcz3hCogWEX51nk
	Lv4DvZpj4nISU7V1AxAddWnKwkQ4ZwksUY5jrBKlpzVnI91OKWaEZD3aGS44eI5b3ZxqZKrujr3
	9v9Qc1vEj8hBvTNi9+/L+ufre/F5ihEktC92cklsjnVWbc9+crNtN3bxjt/kM9vDY2m8WqV7L0i
	VYJyeFVTHZ2dtbIELqvgQhELhNjNkxSW5SJcINJrsbbQ6d8Sf1AS/wwAY17NvnD/E5Pqu8+h8+o
	RzFWj+2Mjk3hqmEGE2XiTyhHIpVFiJbw=
X-Received: by 2002:a05:600c:c16b:b0:477:f9c:67f5 with SMTP id 5b1f17b1804b1-477376d769amr4379295e9.16.1761897497542;
        Fri, 31 Oct 2025 00:58:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNwemgOiv3lHzYhEufVFBAYrSQqe//rYSzgVvmn4tkq7hUvG4q9BL5K3qCkZTsiEl6FUiWFg==
X-Received: by 2002:a05:600c:c16b:b0:477:f9c:67f5 with SMTP id 5b1f17b1804b1-477376d769amr4379075e9.16.1761897497158;
        Fri, 31 Oct 2025 00:58:17 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f1cf.dip0.t-ipconnect.de. [79.241.241.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fd280fbsm16398705e9.5.2025.10.31.00.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 00:58:16 -0700 (PDT)
Message-ID: <e1562980-b9df-4aa6-a44f-185a7c586b33@redhat.com>
Date: Fri, 31 Oct 2025 08:58:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm/huge_memory: add split_huge_page_to_order()
To: Zi Yan <ziy@nvidia.com>, linmiaohe@huawei.com, jane.chu@oracle.com
Cc: kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-2-ziy@nvidia.com>
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
In-Reply-To: <20251030014020.475659-2-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pwUAP9BbbmQmIHDaSyBZWGzeOc3zgtdanxWxLhmkMY0_1761897498
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 26DE9A0007
X-Rspamd-Server: rspam03
X-Stat-Signature: nqhwsiw59ju7r47ppar68u4n6wkzrz46
X-HE-Tag: 1761897501-869015
X-HE-Meta: U2FsdGVkX1/szqNzxYyKeK0BONQjji1ZT9IeHUsN/nAH/WmDz5m8MTMvaO8Jb/EHu1ZL22LeeldzyC4BdAGSP7ZiX4Zwd1OX1yWgzzW2JUveG2TiVEfPszqBSLRdUULrl5Rf0KtrNrcDiDkkObnOtqNTAwdZnp3RKhrvl/zWkVrNcMCCMvLCrEcsSYZ5t8SkijXFBmkT4zq6n0uylsbIm2AHw9Gki+wW1vu5OtEDUfjJ1ACU4pX4dl7hn4Zr/1QLev0bJXtcdZjYHoB071Yo9vbSd55H2hEHTgmF3Xgob/N3uUZAnfIQ6sgIdrt5gqwOWSMHwPMgNtXMU6cQHqxg+/cem3WlAoIOgbFzT5IY30ruvnUr3dJ36J5Td1nwUW49FYi2p3Js5ElXMlasYI0LlXBrFWnTxPhmCqlSCjSCoR7P1iDKUzEMo+QWbax3xplVE0bks8bNepnT7LNN0SzbtxJwTgcdamHBr8R/hTe5jyd4vhf8myUg8tf1qyZUaYvdgUE7oln83vXi5TDobdki42aeqxAC7qP8ektInnra/1b2bUooyqAgHfVn4kMWxt4Ke55irVs5yudG/xGsWStIk0fjHFVWAny+k6+6jZFBh60aZNqbcoC0mzWrg7aN3VAA8kM5HImOZqKBFiJG7ik64+hfiRGgh9fvvnOPaIJ0Yad6BxivIN6qki1/tLMQDuRwNQLfzQEvkj60Mc4B+vZA6Qpv4LDmSGMCRnJCs07CjTSlrd04zL8+vsJjNLZb+b9esF8fsjuhGYYuJ8O2jyz6YMR2MtG6vZLOEopgcpJSdd++6MiUHdvzG68Lh1Bs/3XOjn4Afxiqp862XybKSRhh5jQ5oyPELuvW+LVNEyCriAw3B3L+oxYvz0sjgDNVWwXrrTs+H0hJlrpK6WUF51VnZC6+DSJkEzeMyj52RQ5gU0ecAaI8MF48HrYQiyi/Z7CkVxsKVcIEvEpFQAh4KwP
 66fvBBMJ
 Jpp8H3fkWhQOMJ0McInOPuwGoRopVweo1C9+GI10eok/uRdLxQSJ15hWumlycD8OeEA55OUI9CXvYyBj6JlJVSPLoTuQzkV+qaXYu3zapSipvIwgwDhTFqVKgTXGP2l1sYcHIvH/BeeLb/v70QzIIiHaf9TpOj6D9OE6Owi5fkzr484DwOzUcsrOhr57bpz+yCAW0CBguwNkgu0TojwEf+YObyjiCSmES/UpEUmIUkWYkJfzqbwvasVDRKjzWphqzecxrNjA1hzu9siH8YqRhaZ2GTQvtzhQoWLK9HzkJPEsX9yZ+sWlWEz9ogCetTbZwJVHJyZPphG2xj+PS6GU98FPck/gJkasG3v+ZUEhB09JKGIyMO6GrP5sd5ud9Aidfsm6J1NiP5wl5RhkdGqx2UWOjMh510zak4Q31sbNY1RZrc0uGe1gwsqb85NcgvA11qJsu3sNzkO6a0Gn6BlBP82XO/o0yTU0veiNwmhE6vkpHKULHr24ejp8i8c7GgwnBSZLO1jn7mD8LmaOsLocr65oHjWOwUa5BLkqi5qQaFbHUABKU/S0KOZUvsB2fTx1aMvgJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.10.25 02:40, Zi Yan wrote:
> When caller does not supply a list to split_huge_page_to_list_to_order(),
> use split_huge_page_to_order() instead.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   include/linux/huge_mm.h | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7698b3542c4f..34f8d8453bf3 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -381,6 +381,10 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
>   {
>   	return __split_huge_page_to_list_to_order(page, list, new_order, false);
>   }
> +static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
> +{
> +	return split_huge_page_to_list_to_order(page, NULL, new_order);
> +}
>   

Scanning this once again, I guess in the future all these interfaces 
should rather be folio-based, and if we want to split at a specific page 
where we want the reference to be held later, pass in a page:

int folio_split_to_order(struct folio *folio, struct page *page,
			 unsigned int new_order);

With the hope that we could end up with all folio split functions to
look similar in that regard ... and remove all the "huge_page" terminology.

Of course, that can be done as cleanups on top, because there seems to 
be quite some inconsistency already.


-- 
Cheers

David / dhildenb


