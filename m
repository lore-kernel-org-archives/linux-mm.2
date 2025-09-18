Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 969B4CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E522A8E00B9; Thu, 18 Sep 2025 01:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02528E0093; Thu, 18 Sep 2025 01:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB598E00B9; Thu, 18 Sep 2025 01:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B929B8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:56:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B8B4BB321
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:56:16 +0000 (UTC)
X-FDA: 83901310752.08.307FA65
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 13B72C0005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:56:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ki/D0B4y";
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758174974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFodLU7WRNoR8rMYR2p+tFACfC6CQ0VFz+XaBvWZe3Q=;
	b=K/hOTLqmTLbkS3gKI8MZCHxegkYkEVC0P9InKF80gSVYx7XcWOMJShpQ5XB6yCaJD7U2ZN
	SCPzfOm3sOFf3+4R1i/xuZaIlcR7st/03vwVlIgrpzg9bUSxbGbq8fin3gb9iAZP5vTYvQ
	kuBpikudHRNTMLq7X5Vug/Xvd29SGTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758174974; a=rsa-sha256;
	cv=none;
	b=DJ4snlNAYhk9Je5I2WoArfRXJqaydBvG9IT+lWHYqxyM2J9n7chOQUvrUz3Ca4aBT1t47y
	W2dftfkdP10RI0ivnJw9ycd+7tFEztmImOCdpAJR6az0EogTYU0hgt3dlVYqtnMgOluVmy
	2L3DL/SEFRakaiCka1IWlF83QLEajVs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ki/D0B4y";
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758174973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iFodLU7WRNoR8rMYR2p+tFACfC6CQ0VFz+XaBvWZe3Q=;
	b=Ki/D0B4yQdEX0vaN+W+iDy+CNmW9kkMZ3Ba3WWzGaRNxchvfaNb9dbeQ4Uio345UOUa/qC
	egG20utAjyQw9NfcvmJMQ2i2wPugQ3ceXanXl2LJsAHOp53AG8JQ8HrkNOzhxX5RStNb2m
	4AlEof9J38EIZ9Je1wHcmoUt9BlS+Jw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-ko8t7iGEN7WYQW-aKJdNow-1; Thu, 18 Sep 2025 01:56:10 -0400
X-MC-Unique: ko8t7iGEN7WYQW-aKJdNow-1
X-Mimecast-MFC-AGG-ID: ko8t7iGEN7WYQW-aKJdNow_1758174969
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45df9e11fc6so3187135e9.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:56:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758174969; x=1758779769;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iFodLU7WRNoR8rMYR2p+tFACfC6CQ0VFz+XaBvWZe3Q=;
        b=MWTyIT7vj4JUaOr0oVq68CbUNI15wDQRjD+h5Mju6W95M8YF/5/sAZE5zRLZ6UK0Ne
         ZrLWq1ivslyy4zc7CHblTUynVJKdqdk5FcoiYxc3T/UjoZXQDuE/GcjmGdYWgAMz34n/
         YuaAUh9zmL2ln8aU9PVfJl798ci+/kyMP0TBKBSde5so8TPecTuHTUvR/C2xLqqFd3t8
         Oyt/49N2c5FpsGn60JJmcBStJJJaJYb9XrjZnMI7DK6mbKn7mHLsQXhIxOYrY4MM3e6R
         YvGN2FplV4dUkKjIUSUnoI49QEC/dS2kFhDRoNSjJuvqZ/fy7ol416OJwr5KfkhXJdEm
         kEFA==
X-Forwarded-Encrypted: i=1; AJvYcCVcbGElStQ6PjUAlgwjV0vCdVcQWYXIF6uAdPshlXUmnBcICRvfqfZkdtg2G2hPSYzVIjG9l9fiXQ==@kvack.org
X-Gm-Message-State: AOJu0YyDb+nCxKfPEwM4mX/Ep5K7jGiMdOVGQLtMeMEzOhhNDsiW/5zS
	E0khgNmuY8nunnFTkS4lQrUwhojkgWmPWIL5Ph9hfqGtJ9uqB4fPR+JkDY2eBXdII1Le7ogxNla
	c0cUefO6MUlxsFC+HgUM6Obi5honhbx2H7yIRgJde+V6Fd1DR+vtR
X-Gm-Gg: ASbGncuqe4rmiG8i9YcXvmlQ9ngxlw2N9cVX1zI/9G4Zy+gH1Wza9KgQp4+uxM0M8gG
	EkC2rHgHoDVtMHIxM1yXp/3HZDJJqEBZjqCPs1eQjA40iFtNqW1atMc2ehsuRPWM/bqj7kWU/qK
	Pb8dGLMX4SEVpr+e1axtqvJJNlKXdcWkIGhr+LMHftIkU5PYxHyhYkN7wGvAbbji8ss91F31ebY
	tGkfA5ZwDhCDAGryZtAJdUspllQoudzZWUJL2+wIkke96Nx+7l/NWB8/CjjprK+kdnKU6iuQcfB
	FZ6c5ytVBNYJhgWPyTFh+zIdg6+EXQFJS/BLz1/YuqkPoHDdbhAVQyj+m3hNS0hO2tDCVgwchMA
	ZaH6byororWjRoN9Uj+FVK3g2THzHKNbMjslxDPnBgOlh2u6eB0RVu656jmRJiD8K44d/
X-Received: by 2002:a05:600c:5486:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46205cc8444mr47905695e9.24.1758174968855;
        Wed, 17 Sep 2025 22:56:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHa5cFLROHCThsOI4QlMKhK4/G9ymQhSNCWrlhpgmZpLNsf0XK4hUNh/ELW+ARX9uKv36toQ==
X-Received: by 2002:a05:600c:5486:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46205cc8444mr47905405e9.24.1758174968484;
        Wed, 17 Sep 2025 22:56:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46566f72354sm16617495e9.3.2025.09.17.22.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 22:56:07 -0700 (PDT)
Message-ID: <7c38e725-f6d5-4691-b211-a22fc67db85c@redhat.com>
Date: Thu, 18 Sep 2025 07:56:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/node: Fix double free in register_one_node()
From: David Hildenbrand <david@redhat.com>
To: Donet Tom <donettom@linux.ibm.com>, akpm@linux-foundation.org,
 clm@meta.com
Cc: Jonathan.Cameron@huawei.com, alison.schofield@intel.com, dakr@kernel.org,
 dave.jiang@intel.com, gregkh@linuxfoundation.org,
 kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, osalvador@suse.de, rafael@kernel.org,
 ritesh.list@gmail.com, yury.norov@gmail.com, ziy@nvidia.com
References: <20250918054144.58980-1-donettom@linux.ibm.com>
 <5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com>
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
In-Reply-To: <5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MfICKOiD4O9Pwk6CuhqjfsNmsOXBlZuAzkusqbr5bEo_1758174969
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 13B72C0005
X-Stat-Signature: 86p6m7mwcq55pcmwdtt4ta7w8o5btmek
X-Rspam-User: 
X-HE-Tag: 1758174973-385575
X-HE-Meta: U2FsdGVkX1/LTYF9JMooLj2fcuS+E1XlgQbjhPlrDapLB05cr2hea8itC4wZ0XK5tTQz9V41xLyrSZ/pndUZga9QPMcnnPHRtCPIOGnZuYG72KZIPerxL7dDDEAhAgRRk81AIN/NM/SloiXJOJDv9IbSC1jDH4XQHhwpR9maEi+ksPz1eAQhSeJ9PcX5Je13EOQIBgESf3kba5JLgxIb/30669KryU/9PcIySwH71dyYQCxWcBZcRLJlJnDtWbXTA6SMDpovqLWjxAGNz7gt4EdOhHgbjsCkD/gliwHdiDIJ2F4GREggqSBk264vMMcXj+3gwmoWJfAWsUFgLi4nuAmKyvODhtSHnQAf640Ui3wqyarntWu8fD9U0vXL2rnLTtm4htUjt0nrxLdoVvevlRTqyHpBC4meHsr7PY+xq9pXm9rlydqqo+9VmdmeaoW+Uk2aG9LL/T1FVW2sqaEOhIhzqKllsGBJJpwrrW9JjAKqAtDFhvgKAipv7P7uWu8666GrbnPmkAvOqwnrTqanPlh/Ri8kDEM8eC/kpsvCeJjbS7LwxHE/8826JFsOJdAMryO6OFIz47jkjIIRwxdMSu2JkBg43Pg7rxyND2vMNjJqBpavqsBXjsq6oX0JC0a5hMEEceW9P9dBIZ74vQrw7Od9exrfD+oVACzQny4EFfXTOUHvlFJD+WYmLTnlYYU78hB1acc0fMueydJEHCka+3YjfDUP6IUXe9HY3AAMahtG5k8VVnGt1loLUvpOvNvO3Ubse1EWKZsAtdZJRbQe1xK3t0HqGYrpXmtO4G0teeKU4mC12VpS5i2IGeilGANHg9Lmv7XZTe6wYB9JUZvxZZLW4H5DZLt3Uuy/9rYFBC9UU8B1g7xm5ZhDD1lTKV2HNsHOMdR5YiDwQXRns38slUp813vZ9DSrralAxH/QD6/+tgFB3pxIZLYNiUqJJL3FS7QoTvlXA9MjNRIcftO
 MJrPfJN2
 /G18qCJGo9cyFZjHJdV6hSUXyutK/nNCwNb3fEnq1CkOV4CZXsOeIws/VWGqUDJ0X/HHvQXKLdVVsDWabsCGAbiLoiTpyvI2S0LVranJLMDNZWX9zIUb1Ap/LRYl53V+l//P4dIEDcJcWjGd7MCIrwHcMwBjs6kXZjWQmyShgVpipVVSwNB0CShQV1u4ZdaZFdRMchcAFU+kdk6Zgu3Dw3ueIjV9q8JCQV3jU0cnOVOvNAAzRfPGrHj7lCTpF8zOl1krfTP1EPm4l3Kjy0+lA47DOHyuI6dODj636UWEkRO8IH6I9AaU4KEBSn+Nt5b27VNVnDge0h3UrQW1/TJ3QVWM2T98k5MmUJDVJt24rXApxsQ1JiCJA8c1OorIBi+4s2cdsbyseFHsgCfdfBdpnbrFEb2sqlK4y7ArxsSRPCom376CdatxfX71PAb846WC2ivZzXPURZE5waR4gxks3XlMnGjKBBZdd9nuMezDAIwIFxHgNAI9bweVZk39Gw5GVhstaAtRsKmmXhlzNSOXbNkDNLNrOywJh0eETxJOZHWKACfXMr9rfKJozdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 07:55, David Hildenbrand wrote:
> On 18.09.25 07:41, Donet Tom wrote:
>> When device_register() fails in register_node(), it calls
>> put_device(&node->dev). This triggers node_device_release(),
>> which calls kfree(to_node(dev)), thereby freeing the entire
>> node structure.
>>
>> As a result, when register_node() returns an error, the node
>> memory has already been freed. Calling kfree(node) again in
>> register_one_node() leads to a double free.
>>
>> This patch removes the redundant kfree(node) from
>> register_one_node() to prevent the double free.
>>
>> Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in register_one_node()")
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>    drivers/base/node.c | 1 -
>>    1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 1608816de67f..6b6e55a98b79 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -885,7 +885,6 @@ int register_one_node(int nid)
>>    	error = register_node(node_devices[nid], nid);
>>    	if (error) {
>>    		node_devices[nid] = NULL;
>> -		kfree(node);
>>    		return error;
>>    	}
>>    
> 
> Yes, that matches what other users (staring at mm/memory-tiers.c) do.

I forgot

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


