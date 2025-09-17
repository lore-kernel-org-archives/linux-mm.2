Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39FB0CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76BB78E0008; Wed, 17 Sep 2025 03:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C248E0001; Wed, 17 Sep 2025 03:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BFD8E0008; Wed, 17 Sep 2025 03:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECAF8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:03:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1BD411A16D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:03:04 +0000 (UTC)
X-FDA: 83897850288.16.EE1518A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8DE728000D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:03:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Rs/0kaYy";
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758092582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nawTqrlEeqSv7zVujc+JzfalbuSXfxtcl1SSEsQficc=;
	b=Sw0pbnXn2NFIa1MEYiIoe3oPOS4jC8IjLXWv8GaTLKFupxv/BF1+93T9KeFlKBm8Dr6Gyf
	maBMEq2tli2wkMmOFar+pkEROGYQXGwGq6WEnZoe04iK20XBf84ZltZm8EI5ujsH9VJ75j
	prqd0Kq/OjWfapqyvKRtR7nSRuHOHM0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Rs/0kaYy";
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758092582; a=rsa-sha256;
	cv=none;
	b=K2PtbCET/RUMEbfXed32L/ld5OEXUrbPPjvDBKtk2oqp5579Zjsd370v3kqnWUr6TsC3X9
	Kp1+DGHMizP2yeUEwD7bzhfv1I13subuohFRCf5TFSjcY8BNzJV6Lb/JiP9NoN5fZnBObL
	U57ZSshFlfGKWR+mbzx/zQWeHymODMo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758092581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nawTqrlEeqSv7zVujc+JzfalbuSXfxtcl1SSEsQficc=;
	b=Rs/0kaYyBONENmZNXCGrPlFtnbnQCTHQYIfwwsI5JjDhsUmBfBQ3i79UEqWXu0/s5J/cJY
	uB+ZVkZr6jizbMQJr0hUm9nsRuPkeyeWPFTgQMnN7lXZQe4AoA+hx5GPqy40vnjCQY1Z5W
	iP5gPf6ZPcUdGTYxJXO/7vs02ZuJnVk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-y8ewnASpNHiJxwgsAhNUKA-1; Wed, 17 Sep 2025 03:03:00 -0400
X-MC-Unique: y8ewnASpNHiJxwgsAhNUKA-1
X-Mimecast-MFC-AGG-ID: y8ewnASpNHiJxwgsAhNUKA_1758092579
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45cb612d362so39170185e9.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758092579; x=1758697379;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nawTqrlEeqSv7zVujc+JzfalbuSXfxtcl1SSEsQficc=;
        b=cgPnbrO65ObprQQ8LUuo1WV8I/ii2HDBZ3FUjDPGX8/0jC+JwDmjCF+vgS7ajp0cVG
         pV4U4aSqcSfhReiJCvSImBW7co84uivNejFmwxezy08l842rXwTiV04HpbRzqyYhWaY6
         +GfnpYXT1mWt7zutHF7TsLe4TnhGSuZceBAPpECsq+t24TFg2y9urNwIH1VB/rWf7Z40
         ka7D8Y3N5ICPxDaAUlOaR84FtyZB+DZlgCiuB6jLrELlPdDjCB7E0EmkaEXGfw/QseIN
         bsVgxRaKZgwsxAyiR2JDRstmH5wLYkXz+PdedrbPhThmitbXspuIr1WuzuXhbItdkaWo
         oyrw==
X-Forwarded-Encrypted: i=1; AJvYcCUHKZMIUb5EYuiyvKyYpoJoNulBCn6Lv6sFEyklzyTKGQ0sljcPq4fQ/X1xLcAL81zU7KdcAOK12Q==@kvack.org
X-Gm-Message-State: AOJu0YwxUIqLjDRDURZ6dSYmUCnNzR/BQ7Rkz+fs3jp8HZbkZr6tGT+U
	Tjfys9SNyZPlUx7fV9HzOpYLFZxGvDtLaeA9J4lQuxSVyUVRPbo3Fo0aftvgzSSNLPL6TS443NU
	pLPkcS33rVQwmKU8ioSXU/qrkCNLd4DNU6abAcXABHWDj0/pEm26H
X-Gm-Gg: ASbGncvfKiflOdTQgA8UUcIFOuTWx+OK1dYfnJ4IO6H4sNytylhFHZJpwQjXEW2R/un
	22t0/VVla/izkdJHFHZ33Zb2df/v68QpO8e/YYbneF9EHxEc8j31BpodcOjGLWFjOJ2mnLAivAc
	UfGQjghy16rznrJx7cmTPN3UHVQXYoHRrMOWKTnzbDau/qCw87ATyP7B32y0iHFwu8efclhsNI2
	qFBbiQRb6POoc7kq4yr8cKPqr+EfKHPk5FvSl73jHjXtIKUqqXKbC2cW9ThSBPaKS3brqW6i2jX
	4J4Cnskkjmjq3Q97iHUrHpJACwghLaws9sUUUel1PUi2GF73cfxF7bYyyc8wSmKaFHMGlAqMoxn
	as4dYfxBqiEwEjKfW39KTQ+6KIBIojFXpnfF6C9W8Xi3vRzDwlcwbRruPrkKB/VlI
X-Received: by 2002:a05:600c:1e88:b0:45c:b56c:4183 with SMTP id 5b1f17b1804b1-46205adf753mr8271095e9.18.1758092579179;
        Wed, 17 Sep 2025 00:02:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCHXqLZgubOsFpSEryXy6qEwTu5TBAMNWT2kDUAPReOb9ESdWMxgF+theDpncx+aIUqSILpQ==
X-Received: by 2002:a05:600c:1e88:b0:45c:b56c:4183 with SMTP id 5b1f17b1804b1-46205adf753mr8270405e9.18.1758092578660;
        Wed, 17 Sep 2025 00:02:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46137a252fasm23338645e9.7.2025.09.17.00.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 00:02:58 -0700 (PDT)
Message-ID: <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com>
Date: Wed, 17 Sep 2025 09:02:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org, corbet@lwn.net,
 linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
 jane.chu@oracle.com, jiaqiyan@google.com
Cc: Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
 joel.granados@kernel.org, laoar.shao@gmail.com, lorenzo.stoakes@oracle.com,
 mclapinski@google.com, mhocko@suse.com, nao.horiguchi@gmail.com,
 osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
 russ.anderson@hpe.com, shawn.fan@intel.com, surenb@google.com,
 vbabka@suse.cz, linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
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
In-Reply-To: <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: foimNXA_4q-apJm5alKv0VwpAaI8_pnwX7Af0-7yxaI_1758092579
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e8brrkybsunjywjmmmzxiu1zcaa8ez5b
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DE728000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1758092582-697975
X-HE-Meta: U2FsdGVkX1/YgTdnWJ3qyEyO6NRPTJmG3tflCUoc+BV/zm8H8u0+EzT3LsxCiLf47k4HFJSlnx9NllYB6qzN/mpm3JE8Q31vRFi6qKzO5hy844vedLFxt6Vd5QKBK2XEfB95+QuxtGWERzDBktTC0n2fRHWf9owllAIzIpIJvvWeCfuaKE+/7kA4fHtJCvJZf6ZhTd18dl3xV1kt3+k8dgAqCUEk+OEGh1SO1Yrg4C9RBAbDnsGGW13vzB7gJJNEJfgwmCZ/1PkD1esRD5e+1msmVMz+mYfri62VXU9k2g2KB9e3NQ3ytDp6o8cwsQz3d6E996JsC5exeas/B3EBtH0LlE01DVJquaaFZLau8caz5Vz5TAj+f/VG5jP9p2JJV/u5kxE+9JU83S1KWE+sHkHrouisrlNFbXbGsdg7XZ8fW21dRYgoby5o9lFjdzjTOOAApTcoeaehGfwEybYMvJsE3RGGxFvqKT0sq0ZYnZXU+s9dVy93b+RMist/AGXgOt5vwuuLKv9Et17pHXHQOb6X00VZEwdZLD/aVyVolaDSYzVLQU3PaG/IVCxx0PrYUMRVPJRJ6GOdKlM0gobppQHyfSXjSvggowZz7PVFafEaoa0GGuiYSwJ6zbRJeXZhVERIlncjmqdjL7nuiaM5ST+25ULXC8iVhjO5+xv4da+dRX5HAU7EbcA9rlbzo9Xd10Ij2zgVcGj6RnK2/QllOpxrwPjlnOtrNE4TirmJm2zqjLPKqXeMyPDaATOX2vkci6UDPg3JteuBr7fCoaPPpe9+YcWBzCUPRI1UZwmA7/7xD45aTo5T/qnCGYWZSMvVq6UA0mvPAAK/QNUynFcNXnFMaJbyIveM3eSIQ5FKay8vvW4BgGSbYXExr+vGi/OJFlGDHL1tCNFXlU3w8bsQCX8GdttBm/KuBtmSyrlk+I0YJpu3U3ER1DnxHDBukRgaTIlKl1ApovqtFvHAShB
 WC0K2S8C
 m7VCNkyFexQGsS3f6oWeFn10M0QhaX4XlZQSYvFVJeagyk0FYbYwDDI9hHBoPRmBnmkwAPKmgkLVTBAAPPUtxW9LFRRaD0LXGuq6cRZ7NweJE2fIaik6OKpgfecCHV6ie/KV0cecsUYWwoATKXKu5gFyUoGaV8Xy9Es/FeVhFrTJOFHGKM9IF8GNzi8uZONpBXbMDsM3qDfzd2KzmmxEBf6SkSPRNbvevSmG+1ZKlFLcxJBVklUaPMm7lK824et5wcOI1+hJVVC/eJXWbZsV3QPcFQBycZuC/eXlZgti7u3txcAy766bsML4oIRpf6nGF9m9uPIh+42U2GDc6dKNGNGfA8cErD/TqwpFF2AQMRhLWfdbcKh9WMgGjJkMNWhifI2eUYl39ReWRt3JveCBlItYEktw6Exdo4z5x4EL9QyCWymAQe7KN3rc4J0Ef4PVSyBxTINRC5aa4TidocizA7gszmnLz+3DQytdaOf5nXpSg3XznKS6nDvqyMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> +
>> +	0 - Enable soft offline
>> +	1 - Disable soft offline for HugeTLB pages
>> +
>> +Supported values::
>> +
>> +	0 - Soft offline is disabled
>> +	1 - Soft offline is enabled
>> +	3 - Soft offline is enabled (disabled for HugeTLB pages)
> 
> This looks very adhoc even though existing behavior is preserved.
> 
> - Are HugeTLB pages the only page types to be considered ?
> - How the remaining bits here are going to be used later ?
> 

What I proposed (that could be better documented here) is that all other 
bits except the first one will be a disable mask when bit 0 is set.

2 - ... but yet disabled for hugetlb
4 - ... but yet disabled for $WHATEVER
8 - ... but yet disabled for $WHATEVERELSE

> Also without a bit-wise usage roadmap, is not changing a procfs
> interface (ABI) bit problematic ?

For now we failed setting it to values that are neither 0 or 1, IIUC 
set_enable_soft_offline() correctly?

So there should not be any problem, or which scenario do you have in mind?


-- 
Cheers

David / dhildenb


