Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A08FCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB178E0006; Thu,  2 Oct 2025 03:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB998E0002; Thu,  2 Oct 2025 03:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9ADC8E0006; Thu,  2 Oct 2025 03:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92ADE8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:15:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D53C86D4E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:15:08 +0000 (UTC)
X-FDA: 83952312696.02.8FC9AFA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id DABFD14000E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:15:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KoANV70f;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759389306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5Ac778AheL7NpJNRSTMLehCP0Q4ZljNAYBSiaX38qE=;
	b=G5XpH9hMqSRvEB0g0S3Orwi/VoqZKllui2hgKicUVXqiUf3xOcb3CacSWilLMfgqpWmylN
	aRW0fwryfJQrbNx1d5U4El0w+MYEry22l+MvXKFn/W29mXxmt7dxVusPjwtOj/yYOtQHnl
	OqpIZ1hFw9Cpw4sG4OQFFTFBlfq2rag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759389306; a=rsa-sha256;
	cv=none;
	b=bTxCkUIPEQU705Th73ykHcUMoXHYvus6Fndcf+8k1uKVH//H32E26gcBWUL6prBtKDeYrz
	1bRJ1XtIQGdyhC0+qbNbNiEmqI5dNn/eQ/j6pX5QZTAia5JKWqhEyrVKFvPU2fzrgSMQa2
	1pQ0mdQ1yve7eF5aTJfnXa2Lhejs7zs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KoANV70f;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759389305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W5Ac778AheL7NpJNRSTMLehCP0Q4ZljNAYBSiaX38qE=;
	b=KoANV70fVlX0yGCYJMNk+CZ0oHkTjwGhQm4eNlau0xP1wH4c+y7VKExrOsWUH29M8iWx3H
	0OQVgE2scgu1sOAiVlRx5S1fhE0J+xipuR+sofujqPFCEQNKCrQiSc0OR84+00W+b8aZM4
	ZZ1pTMUOwO6DFns2e3gQ2VUBxN54kB0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-M8PrYX7nO8Wz26hUZI_N2A-1; Thu, 02 Oct 2025 03:15:04 -0400
X-MC-Unique: M8PrYX7nO8Wz26hUZI_N2A-1
X-Mimecast-MFC-AGG-ID: M8PrYX7nO8Wz26hUZI_N2A_1759389303
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e4cc8ed76so2023955e9.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:15:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759389303; x=1759994103;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W5Ac778AheL7NpJNRSTMLehCP0Q4ZljNAYBSiaX38qE=;
        b=qg9dW4DnXivWJ4Olmm8w3eJXeZIRjA4MfuXdr+G40eHB1r2xoxNP4g/VzHnbLyKjNA
         vSwL66B1rS0Ov32LoUATjFBRKeQohqcomHyGhVQTRItTymp7xCAPvetJP/qbV3+cf7G1
         UeDBzEXrEPSKySZLUKYHPeWak3Hx75XHjqcR4o6664XhGG2e9pMsY/LkRfdn7fZJArJZ
         VZOGEmIl1nFygfFMtjHcRa6u8XcxlFQ83DUXC9ZnNo+hX0zsLc7siTMt/d4EgZTZDanU
         g7bXv1BgjO6Y/tfrAgkNMK3bvKqFrgiGNTbCo8lYIPW6oszhNFRpv0+wDD1U5YMNdTND
         pfSQ==
X-Gm-Message-State: AOJu0YzadtT7A5rDEyd7CGYRmOQuRc7EMDKDK2oZkrpn/nUdmOkUH4gS
	0n1NFV4zFTaihfDfR63Xn6cuiVFnUPsFNkOQy7i3nMlTHIUTe69yWy5voB7ZXyLu/2CvlC10cOg
	mY59hdcSviVLwQrGWLgllEdobjT6LOe63JPFOZErwxISt/alhN00j
X-Gm-Gg: ASbGncslRNL6PTeDeU1rnwTRMqaPH1PhfluGiNE8JRk4zp+qJoryXMIrjdiWpGfK+9u
	NyX1Q2e6C1AF3elMQ0Qc1PNg9iNUPS9CVz2qIcu5zHdLhFKUT9cB5rlwt5jBe66duLoB0Bhv+g6
	1dVv2ZIWseyyAVaYymHO0nsXTZotvwBp8pU0ubjgMtOhB3xyojXpEUa/gezA46bw0ZReXVg9za1
	9vFTH3vG/NnGbLgEnUeVtRbfiGR3l7RvF7/GxRgV8ts69/1o2IJCeQFFeLyVVI3vjuZyWD9R+ou
	/Gth4hNyfTCWYeXnn9yHzdcCeKlXZ3vk0KUemuz1rLTBiHeUN6SW3hZHo7Y9dl1vtrxgIJrlK6t
	w88oalzbA
X-Received: by 2002:a05:600c:1c95:b0:46e:6af4:ed83 with SMTP id 5b1f17b1804b1-46e6af4efffmr7952675e9.23.1759389302753;
        Thu, 02 Oct 2025 00:15:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8ldnTz2JbgHQGaCW5pgTHhvepIXyjeIE3ouCdne2DyJMLKZaH3KmUT6eErXmw4mzjZSH9zA==
X-Received: by 2002:a05:600c:1c95:b0:46e:6af4:ed83 with SMTP id 5b1f17b1804b1-46e6af4efffmr7952405e9.23.1759389302317;
        Thu, 02 Oct 2025 00:15:02 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6917a279sm23052245e9.4.2025.10.02.00.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:15:01 -0700 (PDT)
Message-ID: <4cd8bfef-c726-4097-a694-1781898c1d26@redhat.com>
Date: Thu, 2 Oct 2025 09:14:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org, stable@vger.kernel.org
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
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
In-Reply-To: <20251002013825.20448-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1Kdw0nZ0HMloFgPnLBVPoeoKaMUklko030lEvNKCH7s_1759389303
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DABFD14000E
X-Stat-Signature: qcycy6ze8k4p3a5p7x96trdjpwycjb7j
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759389305-899451
X-HE-Meta: U2FsdGVkX1/LLWorFR+VImS6PDPlPaMuLYwWJzqSbpahGWX0IKRyGPdSngRGY/QR1miUe5OdhA1lv7yHwwZi+59ZoV5DrBxadhtZi0R4bqdwoRwSaKkANkaQMJ+YUxgRmr/Pd5xaLFwi3ICJoXeqi/FXxlK6WM8+/aSaazFe4prPPrHZ2Vm7Nd6h5+0u/y4IdwcSZo2pKTNugVGdW1GOXZdZPRQbjDefizr3j68XLsnA+6jmNrj8SzRxxx4KWz29DCW3Dl7U76UvXdIB4bmqfoMS3TcUmEnfQNFejJusmWimEsAlhXJn7UiJxFaz0SZkzRtxqMzRLPGsDGH6TCZjnADDJ7Xor7D1I9z6V85xSB/2HA7mAk/oBaqmX6nPl8TweiV+6BQuv/hbPdPvLq2W1WRXxLElop8N9KsUbd4HrniLmxPlXUCci8ZlvnP3YCfOfO8qwQLp7wSxFqfv7tWnLKIEPwKPQEkF+gRvH6NSSwMv4zZCmwIbBqxdEHvb2yurMqOG5L6xHT1X73gntBKgjTI9cMZ6nGGcO67/JL8HEn+/YXUe4tou7VOjWlILhmLIwx2b902VQccPVW5XWHErPeYYpP+iP7y3ncdkM1hynVm1d6HJbhPZROD6//TCY9EiLezad3XTsbl/v3uzK5OvaW1Bbj1L5nYatx4jHxfewKXzsU+Qpwwxrd4I2w49MKxg/+tPJv/lmWhxZ7v3aauPQu0XMi4IpdgACsM6W0pb4ejBaMMGEvo3FlIcFmmqwHAUlBZZV0Gn61jLLydUu3ocpwVNDmr/d/W2PDgr7LIWGAGjiWd1irTb08JSUBgpD0uWZl7FWFMCJE/ObhBUWsgYIebtAA3FG/VF0QGNBkYQx+/GWpRAe61kwqIz8GXUUA7ybjUifKK4Wufid2o/lhH4BZo6I1xyKdnDwW5hhtZU8WuDxjwUIqwGX4k1Yt5/0iT3TaPPJ4R+Rx3GmDb3lsZ
 pbql+2L3
 JvtPtUxi7Wq4RU9bat6M/rP6/VvRTDRCOXbykGdMyZ3lA20BghD2bU3fmsXoCkvPTn67v0m0OzcyNTygsrkHsCF7GXH8BFcHMA/5NNbT+dbW3SJnjTgKqRKWDA4WKnFOhQQG0uVf15aW7XCR1rxHAU3sMtF3TV8e8PfL51RtD429o8AtMQMFqH5rrgHnFpFbQqcTUEbgB+V9EAWfGUVw9HCluMqxsRLIozwHSViQffzX2WrhFWLqx3rrXGYeN1oXtqdEKLxaBDag8tl6hpWv/Li6ndAHEd12bvzMkbJa/+n6IGRVYoKN5A4nYFFeZsVq1rJtSoebk1jqqZUuYrvHwaoJwejTlqGsItPm7tU5Mn6/6XBFCq3OQtIQrlyAMJK9rUusKsTlOI1QejLZI3VgPLsjUcESLTIlR0i5hbtgsN0Hi0vbL57hxlG8vlVGziUiSh4vzawjkRWSYd5CpD4iDrNgv5UXqZohCIMJdgCLAPkYY6n3TojpllBaU9/bG27X9k/yPqq6jbYaFU412oArj2k8EWobGX/mNSuX+toQhQaVvg0dfLBi4xMnQt1r3SG9yMvQriO5nJ6+0wRFC/LdNocn9DWYxx0gwl+fw7FHz9eNfcjRZ4+4yMdA1Jnmt7v1/6dFW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 03:38, Wei Yang wrote:
> We add pmd folio into ds_queue on the first page fault in
> __do_huge_pmd_anonymous_page(), so that we can split it in case of
> memory pressure. This should be the same for a pmd folio during wp
> page fault.
> 
> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
> to add it to ds_queue, which means system may not reclaim enough memory
> in case of memory pressure even the pmd folio is under used.
> 
> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
> folio installation consistent.
> 
> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: <stable@vger.kernel.org>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


