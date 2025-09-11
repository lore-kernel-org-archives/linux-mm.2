Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273CBCAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6952D280002; Thu, 11 Sep 2025 07:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64554940008; Thu, 11 Sep 2025 07:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50CDE280002; Thu, 11 Sep 2025 07:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA6A940008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:43:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8F6814033C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:43:27 +0000 (UTC)
X-FDA: 83876784054.14.5104080
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76B0814000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:43:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZ0GEpvE;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757591005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqK4r7gHJdP3vIjVD+TUIRV7/mQ6/Q899i9w/Vg00eA=;
	b=Rb09UfzY05lJdvrYC3xy8dV4vRmnEr3MWfjot+9GH+vatjRolyYpe53F0ZeRVUzNBhitEE
	f89aGKx/OCeNiPhctQUmsCawmiSXbK4lHf8To6THkrsIvJsOBsY1qhHXM3FRX8PbWigzih
	Q8MgLCf8kKUNkDwqoqjQX3MXmGWTSC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757591005; a=rsa-sha256;
	cv=none;
	b=X33QvtJI2P3g7iU0QNpoS5KdYlSMzuJzfvnmgyB3yVXgdEyW8jog1PokfyAfpo/TIthwRh
	9zCFd7Wp8mXX8IVHodA7maA8Ip4B0j/CKczVlQFhj1Rh6k3JrKkD4MqsJtV9RHqWbzjQXx
	/K7KxW/Pl3WuhsiFjTJi1h5o7WaM+H8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZ0GEpvE;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757591004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YqK4r7gHJdP3vIjVD+TUIRV7/mQ6/Q899i9w/Vg00eA=;
	b=hZ0GEpvED09ooFfWQiNpolngWTDyRa4m6fXKb05MVnV+HAA0EPsvn1uMqPxO3u/W2EEO8f
	Yeo5f4fv+skVe5IUFBHE5BuMv9sNNyOQjfMgrE+S+2ygAt265dzLjam1SUPv4ZMmgIGLQt
	BS6oOylVOasIzUMO1BRgnElU5DXjIBg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-E-vk8FL7PZaRoHFSklENqQ-1; Thu, 11 Sep 2025 07:43:23 -0400
X-MC-Unique: E-vk8FL7PZaRoHFSklENqQ-1
X-Mimecast-MFC-AGG-ID: E-vk8FL7PZaRoHFSklENqQ_1757591002
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b920a0c89so3464115e9.2
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757591002; x=1758195802;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YqK4r7gHJdP3vIjVD+TUIRV7/mQ6/Q899i9w/Vg00eA=;
        b=QqIrRsN9ZuRBGNLrtD80A2XrP+F71DYutAaYqouLUcy09YINN467niisLNUr+Sb59c
         NxhxZPdMB+GDnq8eziGgYzqXxXgbQV1ipgiYNEfb8lRhKULIpe1dSxYUyuxezcrb1R8A
         yfsUCt9m0uNOx4lWxM5LN36B1njLa+4V7xDuQAruEVnm3qN0qKkZvgbPtigHfq6RlAu7
         djghRHEpdqzeS864xGLZJ3uhf+p47q3YarNvRD0MnY6g57ot5cwAnI3mOZdWsDsDGPqa
         iiMuraV7MxMnpzT+sfQtx4voJzBZaOOzvGax+ar454ArbVnjMP61RvSw6DB0BDzPWP8F
         1mNw==
X-Forwarded-Encrypted: i=1; AJvYcCV6TmaWAT5JK9iSNLlEpuj7P+duiwwAzpcldOLV9KCCtWBEzMmsupnb00pix1ZKJg0p4Mic1q/zPQ==@kvack.org
X-Gm-Message-State: AOJu0YzyInY8/H0yOyaV3y5NUmIpv0PZJK6AZc/3w3zLVRy43jgfM2Oe
	mC0GvRBNdddqSdx8hHu2phK8r15HVXK/IeTw07XRc/SoP5CosQ0R6SAgfQ9PK8ATtPEaSdz8LuA
	eqdcjQGVrz0FiPeypJnuCH0FBa7Qsqz3uuEcPKsLVX06ofgLfndMe
X-Gm-Gg: ASbGnctHV6vXeugw9xrRMZeTtwmhjVmbbnuFxgXauPIR95lyTucSG2aWm8DDFDuLcRn
	gQak+TzFguB9/qdCnsKsROo817FelvvBpzjoEB5grijo5cJz3C4bx+v+WMOlEqjZEZMEuK2RVmq
	7jxFE0+yigEUXqeHHrh9zZMmBw1F6evPetK5//a73mdhJEi79M2cIWO3WPZpqhLv/PtLzQ+89Ua
	OsWvcLbx8EyOXg1HmuPsJ3I/Tib5EsRyhbufEHPWKwbwCycX3koOwU+x/ej+LNe4ogYuCrlc7lr
	EO2Ga4doXVPm4ATkhpdy1a47+zfuml/Vbfy3YZiSJqp8EFSEapcXQQtPeDyGqwdxqo5wjfaAXH2
	QDsg4aMzShIXTlE1TdKAoNbHLSqALOAXEbPvTgdj4C+fag+fsWUGZP6ATOzS76yQ1Lhw=
X-Received: by 2002:a05:600c:1993:b0:45b:7bba:c7a6 with SMTP id 5b1f17b1804b1-45dddef9cc0mr166604715e9.32.1757591002346;
        Thu, 11 Sep 2025 04:43:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8zfkESvPnwJLCN3cVn/BPh0cdw9cW0cigZqMLDMU0If2Z8bKvXz8EdYHTLAcu9AecaC2sFg==
X-Received: by 2002:a05:600c:1993:b0:45b:7bba:c7a6 with SMTP id 5b1f17b1804b1-45dddef9cc0mr166604395e9.32.1757591001854;
        Thu, 11 Sep 2025 04:43:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760776bb8sm2201804f8f.3.2025.09.11.04.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 04:43:21 -0700 (PDT)
Message-ID: <5144764e-1168-4d95-a4ff-76a51bc7932c@redhat.com>
Date: Thu, 11 Sep 2025 13:43:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 01/15] mm/zone_device: support large zone device private
 folios
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
 <20250903011900.3657435-2-balbirs@nvidia.com>
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
In-Reply-To: <20250903011900.3657435-2-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HjnbMxctzaoT3UwtJ2H1CRULsH6jKrmPcGeqECCGV7k_1757591002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 76B0814000D
X-Stat-Signature: eoodctxfj3ptbibamxpw9rm1qnuphwob
X-Rspam-User: 
X-HE-Tag: 1757591005-55875
X-HE-Meta: U2FsdGVkX1/sUQIQQRiYNhe7CvXvre8c1/yezXNVYZB4uc0bt5AySiu1doQOmRnLyYfEvGE10Ns0DMB4y/JfubXOFas0nVrfBMj/hYL0KlGXFOpTkaKrg4lEPLebH7jLew9mAyZe8BPhf2XMHi79t5B7cazLTOAbQA+cOSmaZoHPmlzjKb/Z+RgM0v5NswL8kRh/tfCMEgufTcZ3w8SYJ5E5l2Yhz0EPXO5Tja3kr9TqPfdMyR/Z5AsqxMTAotRxTjffF6rnNIvN5awH4eFcF/tQ6uZZWy2p5GDOU9sf9P3pA8gN4lSTmSjJCJRq8oFRnqpsDD0KFkHeDD4swKvSlsgQgn/FI1+/wznB8yQFd5L56G/xZieRFT1BfE6c6RBEiseotRvwmi7DgOmGgmpdKilLZS6fe4UfcRLTmkrCOnjHJC1tVXrIKOWfgym1rOtcQ+5CcQvcMDda865V5FnViVh/dyZKSjJFoIqkV0IqlKh5Wuo6ez+9nn0l84qYvZmpIKJZZmeWBtRcMwUZLoxsJwrIualWqCikwcp9X/xbMGzdQ2iwo9WD4zejT/X4eWboZ9hh4EFVQ82t9XBaT+C66oDy80BRSDqYc+jqUl/D/HzLSKQs0q8gKsXRJkTyQwNyHn/TufsIJCJ32PPlO/hz/2n3vCRu5bIjxE6zn2F6AFltozMI6CAvMfSOD2rfEQCykC4kY5JOk3P0l/dkTgkfxR3ROJmuxbi2xngZsZC2AqnlnMRKGAmpWQvsgpPMwofcUQYvP32maR1omncdMesW871He2gpI+5wQUzfd/7drkn5TrBm/Nvu004r/Cou9+a48s0ndP+JsmE6MebeQcBqfTYg7YXa+EhLii0jkZDXiNMaAswmkqb93urYXTvr7Bvmia8yzqkz657ywjEtAJmoSkqCf3dr6S25q9GHdftrABGwiwExhDfkPWlDUZwGVHyAjufdBwSEr+o67FQFgJA
 ryA7TwY/
 oC5Sr5vJqT2+5qBgt+a94ccgvPVzHUZf0xDqSUjj0wZFOFhUEW/oJDeV1E2aPJsEYGN9qdQHda0R+fReIh1/Q9XW5pT16POjcaDDkttRbMmd3w0pO2C9j3iVlZsmnn15o5atgRGe0dpCC9gG/yYAJFUHv0QK/fKDU4/ijEHkkPmZEhKEs4c0WTQuEpn/nf/0jaQLl8zZFLK5q/BxOfVaZnR7RyadjrehmNLeJDYEjHzaFsTKSAvb/LRH5dBjA7bnlDmKLgdOi+espWyxCK32IXs7irmUFLVE41aThzk724DowTOsaJ30DW/Y973keNmza5ygvzRoJeQdzQWZSJCPvFTGSxbWlD+CckLGAw0XTsLVL5TInUwgL3vmYMaxuxHqtv4t/Xu0c3NduJgoN0dlqeDo8/SIUxPp4XjJdoAk78I1gNhJVZI+OJggqaCf6orm6VuyOnc+pi57FjVH/Y97MzYkiSOPQPW5lo9JkX8U1h4v2onCfuAWOgVXTkiC0KD/ZCO0MCqP+xgD7TKPOwy8BMQJ25SjVBfnl3KonKTYUJ9OOJek2iJANwP22fgkeGsqy8z83W0K/6HAXgdFhHmRtN+ZEXyK3ehnBEd95/cuKrc/5IZLpbrklYrNNbZkGNZEytV9DB4L80RvzOyjMj8FUp+DEW7gj/oOud0q1frC+rCqJilXbIwSCh+r/kUYo2JH1+N5eaydd9NopQWqWJIDsMEx90yjgJWQbcMasZ19Sy4O1hqumCZnMWgd0HTrIEj6Gc/kfLjQHz/qL+KsfxKS9CRR/XbISgakXBH03SFyftiNyWrqSR1IAqLWdhwu6r34ZE++Nd+cvHkZlXvRFu/R6pY8RcvzbU/MXJHYHh2uy1zT2Bm3OQrGGVGJQu7WZt3XU3HgT84wnRctGaHvdmO6yxugUF5EkOGF7TgHDQ0IvCinQptEs0Mfp5uCJ2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 03:18, Balbir Singh wrote:
> Add routines to support allocation of large order zone device folios
> and helper functions for zone device folios, to check if a folio is
> device private and helpers for setting zone device data.
> 
> When large folios are used, the existing page_free() callback in
> pgmap is called when the folio is freed, this is true for both
> PAGE_SIZE and higher order pages.
> 
> Zone device private large folios do not support deferred split and
> scan like normal THP folios.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---

I think you missed my review of this patch in the last revision.

-- 
Cheers

David / dhildenb


