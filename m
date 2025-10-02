Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F76ECAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5559B8E0007; Thu,  2 Oct 2025 03:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D408E0002; Thu,  2 Oct 2025 03:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BEA8E0007; Thu,  2 Oct 2025 03:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3125C8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:22:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE2A358A8F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:22:56 +0000 (UTC)
X-FDA: 83952332352.22.4D0FD36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6E4DB140005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:22:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cwcz3EwQ;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759389774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePqbaydthEocsmnJLS2wDGAhTjEi1sfC4mhZpJTfPls=;
	b=SzaMWjbArHKc9Z7VLx3uGPOt0PI7TyIqWM3w3E8Fi/M411MNca+4OL2AQVMUIl89Oub3/B
	87yfl99YNFCHODo/Fe0JheP7AXItrgtkLmfQQs8Ag0BOZsWN4rSYaHkYfu2Mph1MrOUAwB
	VH7SDyibTvI/4v5R9LsXCALPaTwto5o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cwcz3EwQ;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759389774; a=rsa-sha256;
	cv=none;
	b=LINYpZqzkOnNNbiq2XjWGNTVbIBtNJfY7faGvWoe3u3zZ6GSeSqLnkCDzlxoUvtIfq+1qX
	vkynFqMJ9pePvFArZEwVJfk1KxoqoV7u1RB+N6h+3Z+8B39zdaW6pPOlYY9guIHMSW1w9t
	frFlV2WFWAw6VkuRbyIt9bj8RqERTm8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759389773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ePqbaydthEocsmnJLS2wDGAhTjEi1sfC4mhZpJTfPls=;
	b=cwcz3EwQXn66uXuBUh+3z160itpR0f+A/PsJodle3/gZHOM6SOZq5/ve/jgjxdCjlTi6qj
	J1pKCBAUCDoymnXAmD8R0REGU/2whDKd3MRxus8c81gbv69bWa42FGGZ5uvEjMANcoxvyw
	Lo6uSDYiGpeEr4kXhUlMYQQJCmg9z2g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-KYoYk-iaP3-jLNW8_tSDEA-1; Thu, 02 Oct 2025 03:22:50 -0400
X-MC-Unique: KYoYk-iaP3-jLNW8_tSDEA-1
X-Mimecast-MFC-AGG-ID: KYoYk-iaP3-jLNW8_tSDEA_1759389769
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ee10a24246so448127f8f.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759389769; x=1759994569;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ePqbaydthEocsmnJLS2wDGAhTjEi1sfC4mhZpJTfPls=;
        b=lY1jfsCn5PBX548Mr8uAgWAvJegXWgZfDyXqeqPx4kAhwDReg5nLORk0ni86lhWOfb
         mU5XfHR/uM/YB6zJK5jPSL3/ztF/eX26KWxDImpSaCY8F2zQU7Z9BuUn1pKpHhR7i9LP
         uyXkUTw0KExR+IR03UdBLDxmMTGKN7JchU6TmbMXj79ugVc51Zy4QGGwkvl+uweQPOXw
         wKmr1JBoL36Y7MN5ddklZMsGek2r4pE83QC1c9xqHtyA7PN7n5TQJ1jeegUWy32MRbda
         1mXhQQxGR3i3/8CEzOlBcRN2d72zSxiv3xBmqnqTJw56gcZ9UMSxzU40CxWZqFXMZ4dK
         PG5A==
X-Forwarded-Encrypted: i=1; AJvYcCXOKp0q2TpRD6PvI/6CfFM0UyPNglat5UgtQ5JScvzjO3tPPKNI2+PdqNH0IoSdmZpY6Kd5vMDMpw==@kvack.org
X-Gm-Message-State: AOJu0YwW+6XA2Mj+JxRL9y96tbvUHJBCTuKH+xoq2aNcfgPlkClARilm
	hJHXcROoxkD91smdIGYOsFon8ksXXaScKNyAB7mzQpncVr967gME+ao8CftJUh5uWWfiUPRV16c
	g6pifNwglwZCp8H6ajJvLXgdp9bIuLW2R/XehAwVL6dKr3uJY0Bd9
X-Gm-Gg: ASbGncsgay9P3U4vr04Y+QILdiU7Iq6qgkknrjC0ebNc5UkHKykWh5xpiEggfIApVzN
	l7rmWD16LsytuluSI1L7RYBE3hkLCL2kQd6Ye3v8ZMcL0mkNTgG2eqSNtHIiVzV//OdUYI+M8s2
	VV9KHtRXaf+ACuVXoJ6cTRoPXm1v7v4EIzc+v3jDDytw2ZqxQXD2tHCpmFWxWXkfQjg/Iin3Qew
	AqNGzKso/GOCGA4au2D12ysAMyAHTdjeipn78kL9PTLm3CpwDaN0yqWPkLCCjhI7a4P00HrMAi8
	giiU9lnZL/MEHKQS3//u59b5pNcyCjkpTxr6oSFXCie3UAXKokp9s4fsXvPv/DU57D2UB28PhKm
	PXC5Ygkqf
X-Received: by 2002:a05:600c:6215:b0:46e:6d12:ee4a with SMTP id 5b1f17b1804b1-46e6d12f02bmr5223725e9.20.1759389769368;
        Thu, 02 Oct 2025 00:22:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEdZ1p4zjHZKcWedi5MTyt9Bmyncmz8VJi2HODdrmvI5c5NZ3mhFSBDI92VBHB/MGxJ62slw==
X-Received: by 2002:a05:600c:6215:b0:46e:6d12:ee4a with SMTP id 5b1f17b1804b1-46e6d12f02bmr5223465e9.20.1759389768947;
        Thu, 02 Oct 2025 00:22:48 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e693c9828sm21809955e9.20.2025.10.02.00.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:22:48 -0700 (PDT)
Message-ID: <4909d194-58b7-4e94-b730-f916100238d3@redhat.com>
Date: Thu, 2 Oct 2025 09:22:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>,
 Dan Williams <dan.j.williams@intel.com>, Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
 ngeoffray@google.com, jannh@google.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>,
 SeongJae Park <sj@kernel.org>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
 <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
 <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
 <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
 <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
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
In-Reply-To: <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nLLbHZSnL2EFrUh2RHB13wJnYv0U2-AQ37fJeFFMxvw_1759389769
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6E4DB140005
X-Stat-Signature: rhm8fj9p9gnp9jryoyu9pyw7gfswmyw3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759389774-335431
X-HE-Meta: U2FsdGVkX18GJ7SVJFTdRBHGoHKu5JIYC5OHZNe2Z+gbScWqM53oHVpcVV8rSbNIXLeGWQkpDjWKXionkw1LxJ39Wo7opiFXI49GTaSGaOGvw2HJbngPKlrpKVGAebuPljrZOZhux154NgvcI6LFAqhx9313ZCO+KYMnQ/ewq/jLq0MoiqH4nCBbt0PwOZLkhPKTTZcs/fDuajmiW7EebMrU7hzRO5X8Hjdch7d4+kfa5SuaNxxO7ukCVqcgifUJJzkVP/Hikh5IIGXnB36TKeKkj2K89QVQXJpUEPib+w/dhckxSJE8mJbbtr778s0bkSyIxlBQ5M2Mhixkrqefbhaqa/8iDmwuYdeuyqwsT/MMjw3HO3Hu+i0yB2o2//LAhmo6Zjy3ZSS9WYNCWL/GbPfYIzKgSouxxaOMvf9lURfcOos04RsJ+Ktb8KPUYgUgcmGiXfq66Uf0ICXvZtm5L97pPGDqrlNVTO5geAS/lJKlFlqPYOmbHNcUiDnlqp2gwSgmWEVJFNbMcVy5ebxvNKpwyzn3ZmP48i9c8a+1H/cDxQrAJai42JLVrqFBl3VyUvrLatIx0b8SBaWGAsH0fu1aXmbKxeTeLp9HBa8p5rmlGQ68zu6lOQ3R50ParybrC0QRCmINAzCkIRQVy4vwIqijhV54wYmqRKDIAXOOvU069IkBn8Fo7N3boWAycbphVcU+cqcoyAFRMNRytzW5peXKa7jNg4UhjU0Z3XDbFF0RhQYMYQ/m4Y7z8hmOIYCnZIL4EOM3M5dymu5k7dgP67zqyrCYsMGt38sEE7vrrAtZfFBWzL+AoQ50WivesLFDI0TgsBG5CEWSZR2IpEc2E6tkfhVq9VGebo5J9t+PJSVSlRIU36HcUgdEhXL5ple47i3avpFTK8/HJf6cqofZoo6pKz+iY02TsIPVJdqJmw+CkHXJmGbIZxvbhQCDKlzaBljaHBFxd8WQA926LM5
 zeFMNjPd
 CuAtdltIzVm6eZuGUAkNfLCciZUVCd4JRXrUOirvioh+n2qOvpAFthNosbo2UuRV2DtrJI5BiXQ9gOYkAS1W1m2Zn0O/g2HennSRYn5VwBYrSHWdrb86KSh3MR7B4lNJH7Tv4D2flBuJ5nV818URZzdtEP/VC8mvCVXy/dcLIck3RRo/xYSnZ5dImZXdil2bIQsZ+qnc4wptUSTfiygOVQyvFDHesGqGwPmDxpCbS3mPwJRmEXi80GJvq4qPYFdfcaNyliMGz6Wk6bSbaFAu6AYxIjMRkjBPgo9VnauhCcQhxCwGtur529DUdaqFEu8LZ9p2xqwkPjzM1wyXjxRZy/BE0xlYp9CfPXVC+NkRTGSIvPWxy8rWSnQZphFVzpSt6IRxsIYoyfWJEFw8t01a8z1AIAAbp1F2sjMwI9Aff8t1mGQT3684lggj2IjNHJb1EmiV98/EvawETQfnT4Ka51Trwq72sGhaol5at
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 08:46, Lokesh Gidra wrote:
> On Thu, Sep 25, 2025 at 4:07 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 24.09.25 21:17, Lokesh Gidra wrote:
>>> On Wed, Sep 24, 2025 at 3:00 AM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>>>>
>>>>>> Is mf_generic_kill_procs()->collect_procs() problematic?
>>>>>>
>>>>>> The dax_lock_folio/dax_unlock_folio part confuses me: I think it only
>>>>>> locks an entry in the page cache but not the actual folio ("Lock the DAX
>>>>>> entry corresponding to a folio")?
>>>>> Yeah. The name dax_lock_folio() gives an impression as if the folio is
>>>>> locked but it isn't :)
>>>>
>>>> Sorry for the late reply, I saw you posted v2 in the meantime.
>>>>
>>>>>
>>>>> IIUC, a dax folio can't have an anon_vma (folio->mapping is actually
>>>>> an address_space instead of anon_vma), right?
>>>>
>>>> We have these weird device-private dax folios that are anonymous and
>>>> should have the anon_vma set up.
>>>>
>>>>> So, I thought it wasn't
>>>>> required to actually lock the folio in this case. Please let me know
>>>>> if you want me to still lock the folio around collect_procs(), or add
>>>>> a comment?
>>>>
>>>> I think we can end up reaching memory_failure_dev_pagemap() with an
>>>> anonymous dax folio.
>>>>
>>>> Not sure if anything would prevent us into calling
>>>>
>>>> mf_generic_kill_procs()->collect_procs()->collect_procs_anon()->folio_lock_anon_vma_read()
>>>>
>>> I must be missing something but dax_lock_folio() dereferences
>>
>> Maybe the code is missing something :)
>>
>>> folio->mapping (to get to host) without checking for
>>> FOLIO_MAPPING_FLAGS presence. If it were an anon folio, wouldn't that
>>> be a problem? And then in collect_procs() we obviously check for
>>> folio_test_anon() on the same folio before calling
>>> collect_procs_anon().
>>
>> Right, if we reach dax_lock_folio() with an anon folio we are probably
>> already messing things up? Not sure if the "!dax_mapping(mapping)" would
>> save us, likely not, because it would be an anon_vma.
>>
>> Hopefully Dan+Alistair have a clue how this works and if it already
>> works as expected with device-private anon folios.
>>
> Hi David,
> 
> Any suggestion how to make progress? Should I upload v3 with
> mf_generic_kill_procs()->collect_procs() in folio-lock critical
> section?

Staring at mf_generic_kill_procs() once again, we have this

switch (pgmap->type) {
case MEMORY_DEVICE_PRIVATE:
case MEMORY_DEVICE_COHERENT:
	rc = -ENXIO;
	goto unlock;
...
}

IIRC, all anon device folios are MEMORY_DEVICE_PRIVATE, so we should 
actually not succeed in this function and just abort.

We still call dax_lock_folio() earlier, which likely doesn't do the 
right thing for anon device folios, but that's an existing issue.

So regarding your patch I think we're good!

-- 
Cheers

David / dhildenb


