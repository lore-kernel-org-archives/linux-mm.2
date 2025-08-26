Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAFFCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B866C8E00DE; Tue, 26 Aug 2025 09:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37478E00DC; Tue, 26 Aug 2025 09:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D868E00DE; Tue, 26 Aug 2025 09:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0B68E00DC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:34:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1412C119080
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:34:24 +0000 (UTC)
X-FDA: 83819002848.11.4780DBF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 452BB40013
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:34:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X8DdOywW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756215261; a=rsa-sha256;
	cv=none;
	b=IZ7Y6kUDr+YB4Albwgsq8m24q7qf6mT+VPjhS6VQX4zRLF6gu4bD1hlKQdAobrrTspXoEZ
	vIxhdpNB7ihmGczVrEmCwpRGfEtvsev8189zSOORnu7w9eAdnRK7nJhmAFbN8CeLDx4YRm
	7HE5dbVwW0cQw/KnwbVVwxyOWaMv4Rc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X8DdOywW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756215261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ix4w6ST0tWCxAoFdkSUl0OQgeaQwu4PKmZq+PBuVq4Y=;
	b=AnHQ3E7htrizV/OIOgVLu3M3BRgoc1VK6vP2NH4rp6irk7GYWE5/wAPMf7RAU76XqWMU0o
	P2EgXthz4NRwDVm/xgq6iVao3iZfuyrGpG4JUkxo2JSk/ANeYm/UBNhqw7IgN2Fv8rfVXE
	OEQkIPQvpbAIJe64LXRqL2P5zjPgzFo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756215260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ix4w6ST0tWCxAoFdkSUl0OQgeaQwu4PKmZq+PBuVq4Y=;
	b=X8DdOywWRWQ+GwQJIzsyhR2eB1ISGNMu6YgYiK1t4rE9icstrkVmJe0iogDQdU1Nf3QFi/
	Ul+atpROqmnLRn9flET1vMv90ztlkJ48J9zOSsEYM+dYWrf+tCmYbvcua+AAB5xcE3m6qz
	l5lu3eaKBEb8c/+MNhknYKu+2LQd2Cg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-vxfKmoTcOveL2tfSAs44gg-1; Tue, 26 Aug 2025 09:34:16 -0400
X-MC-Unique: vxfKmoTcOveL2tfSAs44gg-1
X-Mimecast-MFC-AGG-ID: vxfKmoTcOveL2tfSAs44gg_1756215255
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-afcb732ec92so529205866b.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756215255; x=1756820055;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ix4w6ST0tWCxAoFdkSUl0OQgeaQwu4PKmZq+PBuVq4Y=;
        b=TUSxoDlfFQ5z9hhkA7pMnExdy/q2O2vfja5239QImXGfGsu+HLwYxJetwnXO6jKDSX
         2Vgnm7hUOkiBGSWe5xqZo21vFTkYcXILuOCaSIh11te8pysIp2uGlol1EyAV5KcGi0HQ
         jfAkmpzWQleJ+dslpSjedJ4y7OxcTS+whT1kQNuOLyLyo2dJbq2FEcwMWqSAIM4UIgxA
         WqEEYmAASu91Deu0Pz52IO6M4zZM7hiMGWsOpfR6Ox9qgHKS74lRqDx/NcDnCiADpW2L
         eNYTkUNFQd0feS+BEV/n7zGaxO5k8s53IhNlTO8U3GbqihsTAh+eg949qWYGd9ZVqoHV
         5BlA==
X-Gm-Message-State: AOJu0YwwaUkNLmT0/8xyld9TPbGUG7ZF4HGkAWUVfU6mP2xtuRyzgzTa
	UO4VKzpqod1/L3cEGjm2krWoPWGQ6YdMhYxTNazuf3c3zYAffI4HhjmepHMNvEQaeNyuSunLo64
	ZKBcpzIjc7Vw4x8exPqe+5p+HUWOe+vm0zqUhGF8WHJME11eZTbE7
X-Gm-Gg: ASbGnct44oTylpM/xOI3bSea5JFGdlv3azF8ooANFhYx4m93oe3Q6hJfE+RbabYi8ms
	kHtN34bnAQ1jx4P24bXOJmXIKlANQYev/66fwOxnTHYmvjHeMtDHvbnFH+6aZBYFUPv0XYW4ptJ
	AIVXsPkcuw7rO6RTyDr6PaLAqNAx0u4UFiAfNZvo1TvAtg4rXe1rhL+NaEsVn7TB2/9Pfh9vFY8
	18Qfkvlo/D9DEQfm5WRMhKG+sdi2+sUKpOBa/d6FZZwJ2Z/bF2VyqeTnZfaf+QOdeyfhCLC7WC/
	z7xMamAB0+9Zxe66ahGzl2jqi6wFKelQ5llBFixNh8L4L+uTV7pQVASoOPeriqLu8k4V2xGH+w=
	=
X-Received: by 2002:a17:907:6d06:b0:af9:2bb9:ea36 with SMTP id a640c23a62f3a-afe28feb8eemr1311204766b.7.1756215255044;
        Tue, 26 Aug 2025 06:34:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIPasR8WGRnyMgXjmWR2NknnpiIIrZ9MDd9rQP9vuhjwsUiE9RON3KyIeucsJ+0mpG1CKuKQ==
X-Received: by 2002:a17:907:6d06:b0:af9:2bb9:ea36 with SMTP id a640c23a62f3a-afe28feb8eemr1311201666b.7.1756215254647;
        Tue, 26 Aug 2025 06:34:14 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe98cbf721sm232500666b.30.2025.08.26.06.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:34:14 -0700 (PDT)
Message-ID: <a78883c4-5b71-4880-8d6f-ebaebba7d1d6@redhat.com>
Date: Tue, 26 Aug 2025 15:34:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/pageblock-flags: simplify MIGRATETYPE_MASK
 definition
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>
References: <20250826093148.30190-1-richard.weiyang@gmail.com>
 <20250826093148.30190-3-richard.weiyang@gmail.com>
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
In-Reply-To: <20250826093148.30190-3-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ctO2KK0ZE9ZGDsGfBR9beSfnmKLcjPAmEeLzC1NEpHI_1756215255
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 452BB40013
X-Stat-Signature: j1zd8gp6nkuz4wm1ydctq5j435y9k49w
X-HE-Tag: 1756215261-564019
X-HE-Meta: U2FsdGVkX19bGU60d9kIdGZYqJB/teE3EcpFQn8RVDhy8X2UZi4E4wKeyMPM8x57HQb+Pgfl+KrQsPqYTQSmkLwysKb66+INd0zr/S6tH+4zR1wKRZXow1dpIWQBJPDZZQylXfFRQWVbZlf13DGdBT3B23ba2DNn9kcZ+oOYKvsuzpq/+DdGNkshB1HT9wrmfA019idIkUs3aLi3oNz1KrpTvM8u67hD5Dm2AlQxDsQ52PVSfOpDQXZqAFjcMP0YIeuAkTpmnqFr3ahjkNBQxvQPD5d0Q1/7o5qzGJG2dD6/TUK07UQrdxRbzHOifD02zzZyH99aCsE1UC1okJ98eSUcOzkfGfqKcx7Hx8uqPZKa1DcSFeyqWQsewgVPbHwXGJBKzyHzM/gVWwpivrJup2+nbW9/FULwit9T1kNR7/hvOi7lG0Wb/SeMPLJOKSyhpulFWfVkamU8Dc5uzaVPyjmWX7cvUpJfvxukacPJ7ASuxzKqh9HQAUk54qwKBF4VMu+5jahoS6OHIeXaB8ZoOf5KD76pta+vHnl9vAQPZQXmzMLVot138TAOwvkF+3snIUjI8nP0mcmHIH3fxS+BGuVfbfrwLb14aFZeYsI1eggraycAQGm4ej9MWtRMIzd6t2hV/VXCCHe64t8qYuXty4y7o7SkIzEVl9+MUeq58Dg1RkdZnVlA7ya0rNryw0tgBtYNwECs4GK3HTOdKq6/n8kRF4G8keLK8NdOkPSx7eBqvFvdD4BGrj8pHcLBHY+u8UoHgRRgVjIMrLubVeaziZCHI03B+Uk4md/nnefgQBcOD8W1o3bXP9LvmBs7r9LUw4ciweeV1W4t/eyyKLpL2+BlT12AMwFMXpkeuh3EZXgdL8ep7WZ5ZZrJGu8mLsVQJ7xKex4kXqXezGow2tqOsQV6sM8rf/3eqMGxzEXicFRBrpMl30GTIbN1S2f/bdMiwTaH55IyFPfmag5pq9h
 i7/AMYsx
 oaxkP55Ct+SOXIE5pAdWqRK70HiD+0n2lHxOjk6sZQ/coXpyXobPrUZQO/GrgER2UhxajOs+sd9kEtILits1Ilx1LRtv4ah8XjtnKIg6YAm8kt/bdTNG77m7S0zkiJ/KTvyMpoCAfT9j1lxcinQ8L6hnq8KpKjh82G32MjkLmxXzaP0mB3F9oh+/HorCO9Stl4WNNM0jE81t7thdMmWPZmF+LNwKcy8ZU13oDf5Q5rm2YKxsLUN9bX2OGjRAy36S6b4P3hNYxacL6QUreUsq7j7IFugEYrgrb2yIvUedkJs0QXCdEnHzwGfgOJHSuQfLNE5Uop6kF/zuQRbJ+6YLLZDBMAeaEdf6TIXXeAFqzn3tuGQKh9h7yJWmXJ8rHxY064tL1iEw3Z2HcFYQOW1F6BGgQq5sQYlZuk20WJKPNfT6TBGNXe2phs6+dvml0fzbChPKBrAqbrGcqhuVRFxgpwlXimIDdptj4ogRDprPNdKA47YdxxL4C84kJxE4ZkXDxccoYJIN8ehO65VaVDVt7mxuJkwZtymmsg9AmWD9pnYBn98CrNhPl17fQ+vxVtusnUrg7V7dF3tC3BmtR47JqBUpLpyEr3B8cXVWeqPnHYqoNKUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 11:31, Wei Yang wrote:
> MIGRATETYPE_MASK is defined to be the mask of possible migratetype.
> 
> Define it with PB_migratetype_bits directly would be more clear.
> 
> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
> cleaner.
> 
> No functional change intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> ---
>   include/linux/pageblock-flags.h | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
> index 6a44be0f39f4..1489c062a5a7 100644
> --- a/include/linux/pageblock-flags.h
> +++ b/include/linux/pageblock-flags.h
> @@ -37,11 +37,10 @@ enum pageblock_bits {
>   
>   #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>   
> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
> +#define MIGRATETYPE_MASK (BIT(PB_migratetype_bits) - 1)
>   
>   #ifdef CONFIG_MEMORY_ISOLATION
> -#define MIGRATETYPE_AND_ISO_MASK \
> -	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
> +#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
>   #else
>   #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
>   #endif


Hm, I wonder if we can get rid of PB_migratetype_bits

diff --git a/include/linux/pageblock-flags.h 
b/include/linux/pageblock-flags.h
index 6a44be0f39f45..70c988dbdddc8 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -13,12 +13,11 @@

  #include <linux/types.h>

-#define PB_migratetype_bits 3
  /* Bit indices that affect a whole block of pages */
  enum pageblock_bits {
-       PB_migrate,
-       PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
-                       /* 3 bits required for migrate types */
+       PB_migrate_0,
+       PB_migrate_1,
+       PB_migrate_2,
         PB_compact_skip,/* If set the block is skipped by compaction */

  #ifdef CONFIG_MEMORY_ISOLATION

And then just work with the bits. No magical computations.

-- 
Cheers

David / dhildenb


