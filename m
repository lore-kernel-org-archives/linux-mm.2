Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC78CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E609090015D; Thu, 14 Aug 2025 08:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3883900023; Thu, 14 Aug 2025 08:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D006190015D; Thu, 14 Aug 2025 08:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B433E900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:59:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E9D1833FA
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:59:21 +0000 (UTC)
X-FDA: 83775368922.21.BCC60DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 15EDC40007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:59:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RHN4yE0Q;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755176359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3t0CR39RiS9bo6V+bAaM9oWX90Si1UImEXsrmk0A3lE=;
	b=rdB8XrDnBB3pO2gJbpCgF5W+0ZFmnMMKYMDx5/g1Rgr8PVm+BMVXWvpLJil8nq62BQc+0B
	1YQgp+PLnTICK5WSJJX/rKWp+Vit+1tMwwUXnuT3IBs/95MTNFHEipdEyyQaxNdpNchDr2
	+0k9g3gnI+FHkGpLXqeQAgG+tksH5rM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755176359; a=rsa-sha256;
	cv=none;
	b=wo/HBEBP6dZMnLS/E6MEwOohv3qOCQw+QvIgXLVYUBKSnN+Uax+sRGPSKfoxAcZPqr2PgC
	veWQFnB2fGX8/sU8V7uX6UR8xg4c52DPOZrv/04zIfZ0GhDoNqq2b7TZYJrKYoj9oC91Dr
	+9oabD8rnd79XitMTDMO+AqCoEcNFPs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RHN4yE0Q;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755176358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3t0CR39RiS9bo6V+bAaM9oWX90Si1UImEXsrmk0A3lE=;
	b=RHN4yE0QfKFsJG6aYupck5ZvYzKBKLpvGWq9O1nZ1GnZrl7wupONhz0w4BWzvnhWpJNfpd
	vnVVS1oU5I7qoPptQDikclbLREQnhmFexxhWDD0Ml5z+YTaCpKQHICo6PEOHWmque66a2M
	7PKcQrdut2y26pixmaR/7TV3OfrNbWA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-mQH3VachN3KF0XNaYoV9ew-1; Thu, 14 Aug 2025 08:59:17 -0400
X-MC-Unique: mQH3VachN3KF0XNaYoV9ew-1
X-Mimecast-MFC-AGG-ID: mQH3VachN3KF0XNaYoV9ew_1755176356
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso5806175e9.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755176356; x=1755781156;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3t0CR39RiS9bo6V+bAaM9oWX90Si1UImEXsrmk0A3lE=;
        b=B8rnE0CAC4/uEOZhpqdJv185jCIi/4SQtUflUOr8pnj+vTSf1RRaB81fo8bK8FjAn3
         EgrsJ1U2Fq6dKRRIFP54Envft52AUAq4hccE2CIiVD+rCdnIbBBRk1ur3DOfjFvTAHB0
         VRAaeZzCvRi0ArKKwOQ++pYXKh63w5NoapGf5d+0cPVHYG9vDWP8vhFtQYgTqgMTPW0W
         DY9zCv8cLvZNMPFEidT6F2ni6T1lVYrp2s9PffgjqZFZHCzmmoXY8HbMlwOo2cxS/Fru
         UNnBAckUt1tfr/6ZKybCFMS7dI/4oaiEzX6EF8tzK8TPnLfBMy8A2ItOLXFbSS+ZbRxu
         vd6g==
X-Forwarded-Encrypted: i=1; AJvYcCWzCVN+aOsDP6+Sm9OJxV+hkcb2k6OZDBsaYftbuGHMBxmDp8ZRimHBFTDBdrQCxsqpYaSNW7OoAg==@kvack.org
X-Gm-Message-State: AOJu0YyHjduYWZQuHzoJP9oe8jEdrdYOg9cdFLJMc7u5OaSDa6nB1pzC
	wRKRuZ8D/izhb9C2tlMfb2F/KLQ8UAucnKFkvh5yHlWrJZaoAF3jp23PeDzfD6p24SNAZPm0mCU
	ZqkRc/It30GDVvCx1onqY3XlgB+rUDFdCb98px3kMip4OoQGTnQaK
X-Gm-Gg: ASbGncvJyOD0ih7UCLpQPoWD7BpvoxHyYnnq/bOyvMDkw8j7Ui6JQQAz6fMIiYza8ia
	TMnM4d3ppk9QahwK5M1jR1UPLZDZOUS3syukmPSy53kQtj0vYYxa6f857m5ankRT8I2CKtAsAI7
	1ysIiFTV38GzSX7tKOXGV3aaM1nkXsLFJytRgG/bzvYCUssz8pssp9kJ+t2n4zq45PhwD2JfXVw
	9o8OZ7UYND/dbqsE6jlUy0wZOUD2ERpt7h3Ex0TwtbXwhKvOvC6EdCHjhpaHmt453rCHJB8WKT1
	GBTDqMMyF+Wmxdj8jYLAcDOJhm2ujmWNIMSy4L5ocKdhc7f9N/IcsmuBfzM7Taz8OZwU/RimKHw
	zNcdVMWDtxBKcVmXNV+uMy/mURQC6HAsSzm1ZHSZZIynzqoK698ZrudbGgSx+w6Gr/bI=
X-Received: by 2002:a05:600c:5491:b0:43c:fc04:6d35 with SMTP id 5b1f17b1804b1-45a1faf691bmr4202245e9.4.1755176355894;
        Thu, 14 Aug 2025 05:59:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCXUPq3MF/2LcfaRa34zIT915GKLnG74JH+H3ePtWgYmrBLGllfjQvCJgjkywipvIy1ObAlA==
X-Received: by 2002:a05:600c:5491:b0:43c:fc04:6d35 with SMTP id 5b1f17b1804b1-45a1faf691bmr4201945e9.4.1755176355455;
        Thu, 14 Aug 2025 05:59:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c6cfed5sm19815875e9.7.2025.08.14.05.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 05:59:14 -0700 (PDT)
Message-ID: <1387eeb8-fc61-4894-b12f-6cae3ad920bd@redhat.com>
Date: Thu, 14 Aug 2025 14:59:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Mark Brown <broonie@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
 <0b7543dd-4621-432c-9185-874963e8a6af@redhat.com>
 <5dce29cc-3fad-416f-844d-d40c9a089a5f@lucifer.local>
 <b433c998-0f7b-4ca4-a867-5d1235149843@sirena.org.uk>
 <eb90eff6-ded8-40a3-818f-fce3331df464@redhat.com>
 <47e98636-aace-4a42-b6a4-3c63880f394b@sirena.org.uk>
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
In-Reply-To: <47e98636-aace-4a42-b6a4-3c63880f394b@sirena.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OqiI09T1M1p4zLxXS9mBGEjq8FVVWHDAqALFjBFJzaI_1755176356
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15EDC40007
X-Stat-Signature: yasxiw6hi67pfgkqcjak7mzo5enh5qmj
X-HE-Tag: 1755176358-888568
X-HE-Meta: U2FsdGVkX1+qeowc/yMfCD5yJ8GX84zTZvdoAlpFGd1a7ZJKLBtGY9bOZNd7xLWiX13i0irp0AQpyjnq2ihmMbtEs6ej/tFsI92O0D4rTQnW+205Fxo7W1AYz0OzcHyFcItdfTtRZKvvO6+OnRgP5teGcJUo8lnVH6rAZyNXz3cdt+IOPNMXM68WC/LulhiPd9j4++3W2Qlrwh3e1AVCRbn2BgVW3BHdNyNTgc7rEBM6vgQYwrlRXt0SsZo7sABh7r7aYyS4dF/1hBISjGZrSjEqi/CO5FGh1ZlyQve2U8W/PJHvzaKzrCjf/eqrTh+B8APQQU7LWeZZmpStcU0QGyWEFRd1rDlXLYSnA8nVu5gSJtjPH5JSzepU9ZEeXneOmZDubjfLuPE9mFBAIkKSlK5ZjsDdkvy3+N6qnM1x0NAfArqPscnJbeS9GHNAnMmynBULKmtc+/J5+HHPNqyX4dkSXMl05C83O57FPQvz4/Z8dToIX7N1u+A+QxeVWVl3hIZjJAbUcvIpKYp6dF3+rExKO67680ccvzipo6AaYRSpWzBgOzR8wL0X52WtPwxy8S8QtPKuiZkuhspAfittBjQNrx+HKHHDo/auCiEYimHyANx0sFI63fGLr0nOXvrU2WRrFqbYQd9/J44fwLt1sIGL6nEg/SCVb/c8KZS9vMlSor6AiwZadt55JQA18KNHB9HF/iWMCse3QpWz4dV90bQBlnNKev/Yh/MtNXWqv9T4426ggY9wxvZtt/WdZpYw0pSpMxwDcFYawXaI5y/SR+/PwPYG0WxsrIDPTQXWGIEQGTlosOWJ8X3EDdj34XjiThtFdArFhz1oGuxWxKMTgkODkTuxaWvWURdQFf85jDzE05wztGfDuiRmF+yGwzh2uFNLBepUaLAWlWPrXA+15G/Rq/zJwqVRodQtQTP2QTBhvRPIias6Y8BFUYa+NqI+/TIm/Jr4165H8Jlanyh
 sgLclRIN
 12AYK5Iv7oJUbN9leesWr9T+qtCkNtytZTiQpCx7TnJKy3Ke59zk2RthsMPfVRYKMDgB9eLEsNW72Ii6dfOEBQmNRai0qUGb9nvkiaiC4do273jvljRZ+tzIyN089gzyHQ0oX7bwPGN6PonHbEzOppyNCJd91rkAc6kcXI1s4mxqAuD3K2D+NEgJZ/d1369luaLoml4Y1Bm7LEpw/HXVCBiRbdXVHTrcgX/b91t6VkrnIa9Jt+WPwfDdvjhPBWK7n+aIvRRoprZaFaLWibKF0xeERjSKfYuQRlskqAJwohqeiZVvYiF7kafr5BFEL4mn59NAvWYf8lFS1FMmRP361uiJ9MXCwIgKs1DvSOoMZex5xKPE9u7kRg4MoWUhymLmmY5I5cyPjQEKpBOIUWHhRuUexw6cTdpjPxzI6CURdrMyHFB1HYNklsvmk0lDl/9XjiK0lxQWmcRaGfs5EihfIcOBek09R4oSbaWPv6K2OlE53OwunZQVyhyZYqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.08.25 14:09, Mark Brown wrote:
> On Thu, Aug 14, 2025 at 02:00:27PM +0200, David Hildenbrand wrote:
> 
>> Some people (hello :) ) run tests against distro kernels ... shame that
>> prctl just knows one sort of "EINVAL" so we cannot distinguish :(
> 
>> But yeah, maybe one has to be more careful of filtering these failures out
>> then.
> 
> Perhaps this is something that needs considering in the ABI, so
> userspace can reasonably figure out if it failed to configure whatever
> is being configured due to a missing feature (in which case it should
> fall back to not using that feature somehow) or due to it messing
> something else up?  We might be happy with the tests being version
> specific but general userspace should be able to be a bit more robust.

Yeah, the whole prctl() ship has sailed, unfortunately :(

-- 
Cheers

David / dhildenb


