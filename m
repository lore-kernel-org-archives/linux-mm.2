Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB7CCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99958E0003; Wed,  1 Oct 2025 04:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A0B8E0002; Wed,  1 Oct 2025 04:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39008E0003; Wed,  1 Oct 2025 04:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6FD8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:26:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A0651602FF
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:26:19 +0000 (UTC)
X-FDA: 83948863278.26.D1BABE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id D2DBF20013
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:26:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZHYKIpJF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759307176; a=rsa-sha256;
	cv=none;
	b=wUM0QGYMwcS3D8DEWOvaF99OwzWyROIqItIprF1uo+zrFzF+K03UipS5aKILjCObv3hNcr
	r4gy+eToeKEJsxfHk3+NvIevLkGJlO7Ljl6oDI0tfXAY43+T2QeZc4KSiUh4KSf8ymJOMf
	DgOUc1x9DKNYx0GRM+Px8/4KrEVGE1s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZHYKIpJF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759307176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdG0H1LFNriLh3ZlcFo5ft4E70L57tbhhmAQFZNzD6E=;
	b=8jVUVV9uMseAojKHAt9fCKy2LwH2qHaKZLzFV/JSaNNMzWPd6dsO7L+SBWdsP+xJjWbkVU
	8n3no+7vKkW7V3QIVw2MOKx+AOqHcO6hLzIA8zozmyLEt5brE7SKUR/Eoi12R+yL7/iCQR
	16qZoLvtpE6de3IrPQZxwJ9Y3ksD3WM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759307176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DdG0H1LFNriLh3ZlcFo5ft4E70L57tbhhmAQFZNzD6E=;
	b=ZHYKIpJFbaz1cuiptb4OeiKcnshNbqPaM/quQjdQnEI1KyQl34um4NYL0LNCzi1atXavl7
	FY+YXRoz7yTkXmIF93sJoGKEjp0iGex9CrnFIUIIB7WLdA2riQUUgJywJ2qnSwomyH5LcQ
	Y9cNtjuJolSPBXJS46XLxxe/4e1MIUk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-CnzFAsnnMkK1XtYslo5WHg-1; Wed, 01 Oct 2025 04:26:12 -0400
X-MC-Unique: CnzFAsnnMkK1XtYslo5WHg-1
X-Mimecast-MFC-AGG-ID: CnzFAsnnMkK1XtYslo5WHg_1759307172
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee1365964cso4870852f8f.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307172; x=1759911972;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DdG0H1LFNriLh3ZlcFo5ft4E70L57tbhhmAQFZNzD6E=;
        b=hdMmxLcRXKaAfmJ/nmuqwxB3J4YtEp6nvIdthfgIvIlgNIV2aFO7L3hmjUGK69tgsW
         inqAGtvd2cVsCi5dye8mcu50o0SAKcuJMu/dnTIghxpM6UNxeaCnOb064hd3AKgdNe4B
         VXUbLgNu+bwYnNbi2NjGNf3e1mDeoSk/+OmW6saQkzZYeWIe1apRghEy7XBfpYJ3u4nQ
         XB/zQ2cX4JHg9nZmUpdLDybKhvrU1CWhExcbu4bL4MNc8LmfXCOXMKZcy8W2GkScoGS0
         04jqBox38PrEQDskyS2m2Vuj1ENE/dVvEJClhWxLsIAwV6ARseB/HjOlTHU9ek58B1Ib
         u2iQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDKAH51YeuxeNqeL9Ezp1cPbhLYe61QgrDgIlQfB6uHfokgyVJqx4+wowtxwwWc3+Pei6UZAa0fg==@kvack.org
X-Gm-Message-State: AOJu0YyU8ydoH5W9g3RNnxZeLDiPr9gcZBO62GGiOxyvulxbaUYNu2vS
	NSeg8mg9ivdT6MZUZhcgTb/4wE1+HafEijbZJsyKSOr7FryPbq6RNRT1pJ162zdjo0z/9ertjLX
	nBZeM6vV4/C/iUOttz6kOq8X3nQPYN8icJJK/CjIsxCYcDPhBcYGZ
X-Gm-Gg: ASbGncsL5vOSgfFl8ReiqW7lgEYV5ZR4o8FEUPyfBnyB76SWa9nB7BubwoKy2Prrlfs
	euJS5k7jjndW+XstcUNkCxYvHvQSQlzxv6xz6tPTXEYzblpk+T7rgBrt3jQw4CYWM/6xzRPw5bD
	5rhsdDNuqtU4ehAyxq1c4qChcJnjQO7kZ41pNx1uoIqEQM5U9XqTawGcja3zuuu1LBlbr/yoDaX
	IUa0ER9bdKpMMP4tyiyjT6N2O1A9iLyJax3fvNfjl4+kJbuXZ1LR34N7iu/QvKKRQReIUR6/2RQ
	5oF1AJtDUV2ad2GOuEiGQMq7vQ2GB8x7EK4jDJ7jhGmf4JRWf11AALIysNMhFboBPoKbSV9pF0B
	iA/epNa5f
X-Received: by 2002:a05:6000:2203:b0:411:3c14:3aac with SMTP id ffacd0b85a97d-425577edc22mr1697142f8f.7.1759307171736;
        Wed, 01 Oct 2025 01:26:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+iN/ZmAXQbt/O3P22KBAAONySBwbA+QibBf6jryIwEPS7K+rmCZozV1Z6dOiDLe/RQdUPew==
X-Received: by 2002:a05:6000:2203:b0:411:3c14:3aac with SMTP id ffacd0b85a97d-425577edc22mr1697122f8f.7.1759307171329;
        Wed, 01 Oct 2025 01:26:11 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619c3ac3sm29058725e9.9.2025.10.01.01.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 01:26:10 -0700 (PDT)
Message-ID: <43703e04-3edc-4121-9d52-9852648971e4@redhat.com>
Date: Wed, 1 Oct 2025 10:26:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/ptdump: Replace READ_ONCE() with standard page
 table accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 SeongJae Park <sj@kernel.org>
References: <20251001042502.1400726-1-anshuman.khandual@arm.com>
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
In-Reply-To: <20251001042502.1400726-1-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ddnxfovo3aJ94Qs7cM3YxI5pS28VhzO_C55TzZZmksA_1759307172
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2DBF20013
X-Stat-Signature: o4omprtr1kucmk7r4h5tjtaz5g6wajkf
X-Rspam-User: 
X-HE-Tag: 1759307176-191442
X-HE-Meta: U2FsdGVkX1/YfjYln3+ky/rAfoqpYMQTFMgK0xBJx+4EsoJa4PIvu5jckfi+pAgIpAQXChDvahcul4Ds7Uo6I3QEVF2Qlox71nwIuLV7jCxNffGatTyeRxbRs+wUoZmRrXoVAdOpjqWV3p1O50abakkZCpkqXQZwDn/xNZvTRAgdqyACYc/m/HqoXhe5vk5A/45gwHKOsGBLQ6prfWjlWU++fAZk37B0GBm+YGu3+hCvkn35NJBXk0lJa9hk0FfnlxtN5Al1guz5OcJT5ELldCHKjKdjybSjW7YrfPVwmFBMNN2DiL08C40GjXbIU+R4mWvpdsPU3krkcXhGWhM0yPg+waC202IKCDqc/A8mzuj2IgU7gR3frVdN4WN5VOGH97s3AsdpwPGdGto62xwxwG11Erbego/1Rjy/iIfmBJSfe+B6DtYFz9DorVyVBugDSOWDOpQ+RNriC7umR14IO2fPne9C7MiPsAIw2PmhMIxxeJucGw/LjH5MJqXOKbnkXNpDKQ9oQfV6jTfZ1Gw3wVDpRGbKaleun5Gm17JxuUBIcKJlCYU7VQCjwAM6wCo0sgeycgoORBW+HZKftURAU9ScLd1ES19R0BpsbgrM+aOd64yHQ06vo7XNyk+zktn0b0LiPZXF/a7TrHyEhVc2S/hCFtmvRhGt/Xnlx+aQhnBCL6s7wi0Z+sYj9n6kojbtAdyswZWRZDLP5ybNJFrXC8FSq3+W9I9bJXSo7U4LV8MwQigvyZ4KvEO8GbSVfPNo6X++u38GudzU+d2v1GE4a62kv8stxNO9YydzRu+wKyll8bOUMql5lyZuPYHNBZqlW/0wCiTOCKO/a7FyjVK4dZghS5WIBtTZ/GSust04wbqk2LdVXm6NuEQAw2K73dUOxcx3YkXP535VclZvxIuqqaoOB6uSPwqSvpEGLKB6vLrVTNmcYWUYNzTvzunXaP03qt0EK2DC1swqZZUbmZb
 G0b09wr+
 rcJ14NZ69+EiH0Pblz7SEHhLFmUMjtKUkib00ElS25W7SQhaaj1+aUU9PLl6b8HQVTPLspMKwJ7XDPklDwCrsL+1Z+FaXfIkk4afQnwu4/n7H3NV/lCFmnlca2dzTHnKlQ+nU5uU5ntFXfNRgsXxOav0dfRKN1rY1wkuPnMGpuUr2jUkQYmUxV69lyxy4ZxB5m03HnM29sxG0bku//5Qwwk+7nN07tXbowtorRtiL8pVuuJ6irsaq7sA2K90vlEpCHuTbmqjTeGMqmBAPXBNoWtTAK1jom3MskqdO2XZrM8Z12pcTY+3f5bGZfE5p5xQ5H/JE/Ox3Q/m2bFxGM+H8/E7/cjM4JGP1MuxPjbZR67ksnMp63X5cGHQgGbMRC/hD1jpt5BXfRK7nm4NuddWr10HW1NTE4WLbxshS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 06:25, Anshuman Khandual wrote:
> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
> anyways default into READ_ONCE() in cases where platform does not override.
> Also convert ptep_get_lockless() into ptep_get() as well.
> 

Could have mentioned that no config that requires ptep_get_lockless() 
ends up enabling ptdump.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


