Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 773E1CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 08:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955E18E0005; Wed,  8 Oct 2025 04:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92DA78E0002; Wed,  8 Oct 2025 04:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843978E0005; Wed,  8 Oct 2025 04:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7277C8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:58:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0176113AF39
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:58:32 +0000 (UTC)
X-FDA: 83974346106.23.3A58F95
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 89DA6140006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:58:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZRgAPuN7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759913910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCkfyt5I/VmtvqgtnNAWpB9LnANN2vnP/klB7sFCMlE=;
	b=HzKxHJQ0qGF/b/PA4Z1KXmusVSC9ME6/co9kn3pzwR9W5gN5JBWlhSbZfGSZj8Kn4Vm+cr
	CpXa+QHIiFQykaLKkg6EjHaXC7lZhD9m9Zi/oNKBj+tvVinl4xWiKVvgKu36aZdhwlsvEW
	fqhcvjuHwPrSKeD1akP1ZK4IuAJQhJU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZRgAPuN7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759913910; a=rsa-sha256;
	cv=none;
	b=VbthVUVoWRL4ouQ90B64iINc1izRvdzHTbHIj2yxpP2S64KKMx2wrgyUT/CpxWgR2leDdr
	YWc3mcGVigSMswQEDPyb8EDIc9/W2Nzu1ZNBltk6wxIm/rOpHg8Ehh/GTXMnEFfamDzhH8
	dYbP02bAD0pKwz+VaSAUiKRlzfzATWg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759913909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aCkfyt5I/VmtvqgtnNAWpB9LnANN2vnP/klB7sFCMlE=;
	b=ZRgAPuN7SpqGjjc4JIZrYjSnFScHvehXZZFBibMTTMRP/JmpMz67lxet7mAr0PaRFb5fOp
	u/jhWctbl58JtYiwBDfrJ+780FvbFupl+KU1c/TDE1pZ0h8vkzSbPDe2O8fRdCd6QtDGsq
	pfFRROmHsAnhg6CScgs0lWtxRIgekpI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-si-HmgRYMci1QVaS9kQMjA-1; Wed, 08 Oct 2025 04:58:28 -0400
X-MC-Unique: si-HmgRYMci1QVaS9kQMjA-1
X-Mimecast-MFC-AGG-ID: si-HmgRYMci1QVaS9kQMjA_1759913907
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee13e43dd9so4220569f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 01:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759913907; x=1760518707;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aCkfyt5I/VmtvqgtnNAWpB9LnANN2vnP/klB7sFCMlE=;
        b=MYzw3bgD733HuLmrrWxuuKpMEPpVhbVFXttloO9uXY3JX59c+TR0J0A4MHgsFSWLj4
         Xpxb7PJH2vVnSlK5SlmpZIJjPqJ3nO1g2YNKBHABTrXC+yT1vAoGSQfrWu/k+c3hVOZf
         WuGkUpGpbRFVhg+qN+08M6sGtDCg6G+YYCEPC8uSLc7uL93oVb0O5OzsKH2Ih6nAwtIg
         Qbo9R49JluF56rJjNm/wL4m/rdohaFQqos7FCqglrhI+ZYOdxd3+kKE1by+LJWt5E7Z6
         GcvjopeCNu2kjAPG9ENadjy8YRx69Ox7GLaSjYYdrFOMcyPGB/Qi4DvXd/MqXc/dYpFY
         npdg==
X-Forwarded-Encrypted: i=1; AJvYcCUajLUQaqwYjgo+2GWJ3Ogu4O8lrP+EjcB5p/50yQ3D5X9N58Hpnbvok6afczc03dR9YxflUmX8+A==@kvack.org
X-Gm-Message-State: AOJu0Yxf2dWgfdgwmKA1vZXWWu3VQ0e79RNXyByQwkEK7jB5kV8ZBB82
	sOteDCK9EKa190hKAEKJzOmStl+qXws3Y68vAGBG8PC27PiLW7GwZXUosl/yCK1h9BTiwxPuSfS
	SPqaSeZQK5Xq09U/JRsHVNs9Cmi3aCgHrYy5B/F8g1eClGQ2JXjMX
X-Gm-Gg: ASbGnct5/trlouEwZKtSzKHiwHemyGuQvlerRPGOzAhAGIBPbf2JBQ6GSDYVlWETPBU
	dP+QWFtaQ8GO5R6DY4Y5wMDO/IevuEsSqFRC+ifbl+xbdyq8FZDuO8aDx/EQaayGJ0/QYA4l7Qq
	AE5zhy503fBCsqMZbwL7jjRGpQxMWRaQ2c2gEq2k4msFWE3Bn9jjdhzMaOZDgQ1QAbQUEBbAI/q
	lOb1uIJgCHv+c0jJkuUN9jqcWU3WmJzpjkzcUesr32KRLHxmqeN3Xgwewk5kJbdnnVPC4M11jYj
	3lG07OfhnmlnXi7wpQ/Z7POuZd0uqqYUZWPHDwAP7iIsnrCfCGrXFOqmO+KBrYn2WG7parStZ1j
	ZBX0dFHcy
X-Received: by 2002:a05:6000:40c7:b0:3e7:68b2:c556 with SMTP id ffacd0b85a97d-4266726c44fmr1368226f8f.26.1759913907322;
        Wed, 08 Oct 2025 01:58:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeKz3b4r2qfAkjDy90jbChwaRK5kUNQF21Ofr8oD6OHDyol5EbgRMerKt5zFgrHRyjWGc/Ng==
X-Received: by 2002:a05:6000:40c7:b0:3e7:68b2:c556 with SMTP id ffacd0b85a97d-4266726c44fmr1368193f8f.26.1759913906885;
        Wed, 08 Oct 2025 01:58:26 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c3esm29244385f8f.1.2025.10.08.01.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 01:58:26 -0700 (PDT)
Message-ID: <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
Date: Wed, 8 Oct 2025 10:58:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: corbet@lwn.net, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com,
 brauner@kernel.org, mclapinski@google.com, joel.granados@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, David Rientjes <rientjes@google.com>
References: <20251007214412.3832340-1-gourry@gourry.net>
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
In-Reply-To: <20251007214412.3832340-1-gourry@gourry.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JFuguDMVhEHSfrS3dXLJp6kWHvFfCV-bZlNrqRpEV2Y_1759913907
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 89DA6140006
X-Rspamd-Server: rspam03
X-Stat-Signature: sngdpim7n8ycosx87yfq3asy1x8oysy1
X-HE-Tag: 1759913910-846264
X-HE-Meta: U2FsdGVkX1+hh706y5MduSR3mCLj9ccgpQ/sksg8OedI0NZCusKC0R5+8DL1q3/bD/tAeV5t6FMof9FuK/i27hYyZOoeLi9rCW9EH8IbO+J8eWfWBnGq5lVbmY5KuN/LZWWkTXgUfCaUFqJy3cnj6jYK4HlDKxq2M4od+qQwjAFvcXD6Z+z9aVmuuOWzSw25hks0c4S1ms1SdsyZxjyRw0QEANIJKfo2JHJBUEnU29gWVJKzdYUxV0i9i5qD5ojzCOZ/9o4O429WGODqCW/ENyVR/3IKhvyZQezz60QmOI3Icu/PINrfwrGPWcq7q4qbXrDiaGkjXQCUDA6IyDMIGEXGKY5WEHHDEcU91XeH31PL5VOKA/x8hwwVVAPPjtAdJ1ZDNCUM/od4ztZeNwBL7cctYHsCAlYhWsDch6jR7oTlDT+rUoL4fU9Jxewt/pw+NHiPFp0fT5V+GLHlQuYQdIxbDHz1wQtCQ+aT5ZYbw7cUcsNipqt7ICyanJ9FB8auSc73OOuZAhzvjO5MShhDEkgXFSnQ8yDYKrA4D/WmFov9k6s5dY0W5d+XEof+o6bHVvkCI5QgCzyDTOjU83WWDmQvxFiLdIgf4pbE/8tQpSSOck3gtC93eVC4lfmAzHcIx3bB+DFc2JXb6TskW7Sic+jZofsgb4ZC07ibA6VYXqjqGfwi8GY0+tpGZ/NQBh5+JYV4wosY87zC4H5EBNfLLLsa8aCghsVk309GIRTN9vMnpQmsJBw4t8yE5KoTwzLFucMX/y1DU6OoDoTBvUw1Axm0fNEdttPcWmfdQZVISZ3L7N/Ds1+uPKGe8VqtAKfoD6JlNj6WD2fUEWk7pFvLu9x1M0CRVi//swq87qZG/Jte2QybGc6XLffb6xF/8G/23+tnYuDo/BA1AeUHJSGsuvZQ5NIhdsHhDelwy/R7zobxB3Ba5PeKVat8ZtzNwmTbievEcq4K1Z+g6nEblUv
 CgYe+U4N
 yObwKEPJT0BF6+fyNQUrZDJFTv768clxpbiwAi2qgxYNZtbg6xZdYiCJ8rhHMYXyF+PsuPMbZFtT3dub0WznyMbxqs8L8SEXxLuwzhZkPVNd7uV9FarW4xj3zIeQQCUPizTC6qnuCS9OgXNgIo2Vwa0tIilosyK9qXhI3cR/DEZFz/wlZjV0Gmc+2sqKjlMrrhsjEjbeetaehlyIV7coV2F0+ZhoJoHcLL39TSUaGqv92IBj9PtOamSDITbGs8tx4p22DLIsdZSKVSMG2lXz/IJ2rAd46hC/Ef6kw2jeklAlguVnS7MhXuG8/KLi7X8BnO3uRODlY3QccWCKUItOE/4P7LoSjWwFFfhVQo+cCU2jTdThba1Bg9bNeMzeW5CkGv68E6vNlREaiJ2WX08SQpbOi6TXv6+nEDvPM5GZu8UvV94tagw2oIj+vfux0fm++2qS7TUQmMpV4eEAS1a8MiXogvUc8RRc26G9DEHeCWPfYI+Qq6wcLlaf9gQ0VG8IJdy2UH+fzaqnOscvc66sjsxYI1OIzWn0lRB3X3SE7pg9PtRRd6XPXG6A7hOJ104f3yF0e4ECV+mkDaka3G7QOBkwDnUDtDeL9W+E1zFlAXu8gVXI8tBlLhVcvMZwt/voy+9KrLqR5HNMkvAhgxWAy2UcYnk25Ro45hggj9PUZgVOjyKW0/5s+c6yqzoEUkUnGtTJAjFR/0ZroH5c8T/Y+u0NqpaBqRwlWD0xJqbYfnMYEr+9K1ahD6AiPIdyllQZ/8Z8T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.10.25 23:44, Gregory Price wrote:
> This reverts commit d6cb41cc44c63492702281b1d329955ca767d399.
> 
> This sysctl provides some flexibility between multiple requirements which
> are difficult to square without adding significantly more complexity.
> 
> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> 2) onlining memory in ZONE_MOVABLE to prevent GFP_KERNEL usage
> 3) passing NUMA structure through to a virtual machine (node0=vnode0,
>     node1=vnode1) so a guest can make good placement decisions.
> 4) utilizing 1GB hugepages for VM host memory to reduce TLB pressure
> 5) Managing device memory after init-time to avoid incidental usage
>     at boot (due to being placed in ZONE_NORMAL), or to provide users
>     configuration flexibility.
> 
> When device-hotplugged memory does not require hot-unplug assurances,
> there is no reason to avoid allowing otherwise non-migratable hugepages
> in this zone.  This allows for allocation of 1GB gigantic pages for VMs
> with existing mechanisms.
> 
> Boot-time CMA is not possible for driver-managed hotplug memory, as CMA
> requires the memory to be registered as SystemRAM at boot time.
> 
> Updated the code to land in appropriate locations since it all moved.
> Updated the documentation to add more context when this is useful.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Alexandru Moise <00moses.alexander00@gmail.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
> ---
>   Documentation/admin-guide/sysctl/vm.rst | 31 +++++++++++++++++++++++++
>   include/linux/hugetlb.h                 |  4 +++-
>   mm/hugetlb.c                            |  9 +++++++
>   3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 4d71211fdad8..c9f26cd447d7 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -40,6 +40,7 @@ Currently, these files are in /proc/sys/vm:
>   - enable_soft_offline
>   - extfrag_threshold
>   - highmem_is_dirtyable
> +- hugepages_treat_as_movable
>   - hugetlb_shm_group
>   - laptop_mode
>   - legacy_va_layout
> @@ -356,6 +357,36 @@ only use the low memory and they can fill it up with dirty data without
>   any throttling.
>   
>   
> +hugepages_treat_as_movable
> +==========================
> +
> +This parameter controls whether otherwise immovable hugepages (e.g. 1GB
> +gigantic pages) may be allocated from from ZONE_MOVABLE. If set to non-zero,
> +gigantic hugepages can be allocated from ZONE_MOVABLE. ZONE_MOVABLE memory
> +may be created via the kernel boot parameter `kernelcore` or via memory
> +hotplug as discussed in Documentation/admin-guide/mm/memory-hotplug.rst.
> +
> +Support may depend on specific architecture and/or the hugepage size. If
> +a hugepage supports migration, allocation from ZONE_MOVABLE is always
> +enabled (for example 2MB on x86) for the hugepage regardless of the value
> +of this parameter. IOW, this parameter affects only non-migratable hugepages.
> +
> +Assuming that hugepages are not migratable in your system, one usecase of
> +this parameter is that users can make hugepage pool more extensible by
> +enabling the allocation from ZONE_MOVABLE. This is because on ZONE_MOVABLE
> +page reclaim/migration/compaction work more and you can get contiguous
> +memory more likely. Note that using ZONE_MOVABLE for non-migratable
> +hugepages can do harm to other features like memory hotremove (because
> +memory hotremove expects that memory blocks on ZONE_MOVABLE are always
> +removable,) so it's a trade-off responsible for the users.
> +
> +One common use-case of this feature is allocate 1GB gigantic pages for
> +virtual machines from otherwise not-hotplugged memory which has been
> +isolated from kernel allocations by being onlined into ZONE_MOVABLE.
> +These pages tend to be allocated and released more explicitly, and so
> +hotplug can still be achieved with appropriate orchestration.
> +
> +
>   hugetlb_shm_group
>   =================
>   
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 526d27e88b3b..bbaa1b4908b6 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -172,6 +172,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
>   
>   struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
>   
> +extern int hugepages_treat_as_movable;
>   extern int sysctl_hugetlb_shm_group;
>   extern struct list_head huge_boot_pages[MAX_NUMNODES];
>   
> @@ -926,7 +927,8 @@ static inline gfp_t htlb_alloc_mask(struct hstate *h)
>   {
>   	gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
>   
> -	gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> +	gfp |= (hugepage_movable_supported(h) || hugepages_treat_as_movable) ?
> +	       GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;

I mean, this is as ugly as it gets.

Can't we just let that old approach RIP where it belongs? :)

If something unmovable, it does not belong on ZONE_MOVABLE, as simple as that.

Something I could sympathize is is treaing gigantic pages that are actually
migratable as movable.


Like

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 526d27e88b3b2..78da85b1308dd 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -896,37 +896,12 @@ static inline bool hugepage_migration_supported(struct hstate *h)
         return arch_hugetlb_migration_supported(h);
  }
  
-/*
- * Movability check is different as compared to migration check.
- * It determines whether or not a huge page should be placed on
- * movable zone or not. Movability of any huge page should be
- * required only if huge page size is supported for migration.
- * There won't be any reason for the huge page to be movable if
- * it is not migratable to start with. Also the size of the huge
- * page should be large enough to be placed under a movable zone
- * and still feasible enough to be migratable. Just the presence
- * in movable zone does not make the migration feasible.
- *
- * So even though large huge page sizes like the gigantic ones
- * are migratable they should not be movable because its not
- * feasible to migrate them from movable zone.
- */
-static inline bool hugepage_movable_supported(struct hstate *h)
-{
-       if (!hugepage_migration_supported(h))
-               return false;
-
-       if (hstate_is_gigantic(h))
-               return false;
-       return true;
-}
-
  /* Movability of hugepages depends on migration support. */
  static inline gfp_t htlb_alloc_mask(struct hstate *h)
  {
         gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
  
-       gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
+       gfp |= hugepage_migration_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
  
         return gfp;
  }


Assume you want to offline part of the ZONE_MOVABLE there might still be sufficient
space to possibly allocate a 1 GiB area elsewhere and actually move the gigantic page.

IIRC, we do the same for memory offlining already.


Now, maybe we want to make the configurable. But then, I would much rather tweak the
hstate_is_gigantic() check in hugepage_movable_supported(). And the parameter
would need a much better name than some "treat as movable".

-- 
Cheers

David / dhildenb


