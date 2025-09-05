Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FBACA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183188E000D; Fri,  5 Sep 2025 10:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133F78E0005; Fri,  5 Sep 2025 10:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D928E000D; Fri,  5 Sep 2025 10:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DDC898E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:58:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BE011A026E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:58:08 +0000 (UTC)
X-FDA: 83855501856.01.C9D0AB8
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id A240C40002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:58:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EmXK7Ht3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757084286; a=rsa-sha256;
	cv=none;
	b=IP9AB+kynS7pXoMkiB3qoAnQibMrMss4Lr0HJM9aEmb8VNW/bW9PRlh5O+0ak0RFbRaycf
	VnbrjMPKwhMTURNm0Hx/vNRWmdtO/PLEHsPro6sraydtD2LfjZCZ03Mq41siBu9CiUiFZe
	0kGKqtKad7NIncp18KZDCKc+7gNN/wU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EmXK7Ht3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757084286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIHMAPIeT27Jo7B11YJpwPj+3fw+ijnx3zKE5eN5gTk=;
	b=b2n+Ao+Lg+MDbEkrZlR9sOLnG2bbuJkhITQ6lU3W+WzwZ2vysRHhsk7mD30C1ZeaKcfZTe
	0kkQafOZC0Q9SHjh6f09Rk7QirXNvileMItalbYBojNJ95c13E3cbyK8NQ3i07I6g9w1fq
	BHYMLX16bfNU2BCOjU8AxHf15YRZhLE=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45ddc7d5731so1920275e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757084285; x=1757689085; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zIHMAPIeT27Jo7B11YJpwPj+3fw+ijnx3zKE5eN5gTk=;
        b=EmXK7Ht3cnS6UdhB7s4k6xEap+pr4XYOGQ2WYyJRd+OJLNymQ8kkfxcA+JBpAe+PW6
         llComVnR8rVwypJ68dQmaOc0S3FjDlvAb2mbqIT7y0RZiM8sLlfEyRImdID9+YOprEKL
         8eluz8uN05fH0XHyJ9wv3zf/6XcDhpKhMyneQ4bs5vkkK9DEwqLpTTbuogUEv1Xm36m7
         hA5iMclma/JP7llLwG5WVq7hT2INW0va4/D79p9fr/1X8lIWhpGGjxdoh/7YkdDG3yV1
         y/4lcFdQLJskgSQztpHrcq4rN+6lQSN61BLGc/iNzwxmU0Ler/NJSSyxpUhOwQhMZW56
         g3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757084285; x=1757689085;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zIHMAPIeT27Jo7B11YJpwPj+3fw+ijnx3zKE5eN5gTk=;
        b=gBdU9pidAxMCTAYUf4VKMO95mJQyrJobctiDHq9tPlYU6G6ev7ZiXrFEDmJcMbI5nr
         hEUwAL+y+fnzM7P/gG4hWex9iipi7P6RIQJBCTDEDJKi5UDSkulgX0qE9YoAN0gnyTIp
         sfV9pdkIdAthuR8sJAmzce35Byx5L4XZFntPfqK2sVRawGn40neP7pcBIg7ldg6B5g9S
         z4G93RSQC97PY77AyBJr5RALb54spnro1ECS+VvQiejMZeK/BdtJPHe/WXEcNLbIEMS7
         77sv9f0LxfET3/GFedq70Ekw4TGOO0maJP3jsAYu5tdgYOAGIpwMcoyf7pVOpe5K0hWM
         EmLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0UElscie1uFlCs3v1zAc69nTjU8t5SgQ1N1p9YkuPRpr0VD+MdG9r07Kbt8/8FlSSTf8QhuSTjw==@kvack.org
X-Gm-Message-State: AOJu0YySsOhI3LWxlGaNc9kjgnSxmlJ5Ev6d4Q09VXPOymRUnCBI3u96
	4kyjljjwb8+lcl7H2Kucnw6zohYJY8lLkZzaPqgsD5Bb9zmxLx0uIypl
X-Gm-Gg: ASbGncuYuPYfSQj4b74VjJNWyhkT8oCISZWYnrag6QdDIneujTHh/I6ARLEsFs2B4kx
	ky93/kCzglRLd4xU33zNJBnw5guGXxFxY1EugA2QYkpzYWYWOYHi/r3Pkr0OcKzk0YHA5/SS7vW
	+ijvZEAPvVi0YXOH1ekbh3ofOrxhZsQtoLDIzzggbbrIvtpXSit82zXQEQCEuH8Y3/NQHVmZ0lz
	4VQekyGoTJL/vry+ECZbTEPzS1SFWKZ5JrpohiYalQi6CMQglozDofW/ra577ztaMD7aoXm6hw8
	JR26sg5mCqvPs6y3f6Y7EysWhKv9HJ/rZV+XbdXkKvJzi5kMXQX2z3xHbM77FC+82Q4LsEHDMax
	Y4zCMGCQUDFILgZZOcKciylca10W4oSSSVfiorhK10JdXs2LfJxuigg7DVdkYkF0Z5Qz+RJEQef
	EtaX9Yig==
X-Google-Smtp-Source: AGHT+IHEZqg2PpFyPMX/8YqcR+J/39bEuy86qTsdqLp3CwbzN0a0HOm/VofRaSah3z6ZjRQ4/NaO+A==
X-Received: by 2002:a05:6000:310c:b0:3e3:59cc:65ba with SMTP id ffacd0b85a97d-3e359cc6eb4mr1968245f8f.50.1757084285026;
        Fri, 05 Sep 2025 07:58:05 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d6cf485eb7sm21775367f8f.3.2025.09.05.07.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:58:04 -0700 (PDT)
Message-ID: <deea94bc-8497-4f73-bf0a-7f3d61f9cc94@gmail.com>
Date: Fri, 5 Sep 2025 15:58:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <7B0B1E09-5083-449F-851D-FD63D32D2B3D@nvidia.com>
 <d5c34688-30b8-4360-bb71-8c85f01bc8f4@gmail.com>
 <e50c8f08-5739-4b12-bb7f-85ff045800d6@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <e50c8f08-5739-4b12-bb7f-85ff045800d6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A240C40002
X-Stat-Signature: aiicrushbppnw7fhtzob1cj47wrd5htj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757084286-608207
X-HE-Meta: U2FsdGVkX1+upJgtDK/I9LXkDYyE0fBZGpzU43HhgklaS+P7E+8jhdDw/hrGzkqzQigxPcLEmo2n70pYmwozatkic5knuVKCdDny6Ci5QcVMYvsZ8AEKmVTZB4GltLk9oqvAbVawzkW0xZX5CGYe87qPDD1YlEyi7BFsgQRTZQBWjvoOxcUDBTfILm6csP17F30XVa9htf+A/VB7tDYCKW4PU/MQ7j0warhsUlyGO+JnHJNp4Ix6CElLKroz0cbWdvz/CIslIQnhKVXckJQLkCEnbSmOwMyDp8A6zyrsyTwMcbocl3XTY26bDzRtgGmFUBN74bZX0+ZrKD/kFOHBT59RIyOP9AJ0cexW4in5KHq3i9kBATXaNLrOJTnr0KIn9OLquu1B/DNcSnEImAWzUaFvCk8ZOH1buakLeuIzEbiOeMTMddl0Q1T0q6Vo5bAdunseVRY5ATWO5k02+VB9BhhX0/4/SHPSeFmB9zRIh3if1gN6zLK20bLTgKJPvJ4dHdXa9wV3fuvgDNaBjoz5kmjLv8qKwDfHlz7qQHAYnpwThpLK2pRMMnIdnEJqCqSfyoC2hHa2/cOeDHvi81//wedDEhO1Nq5QGlNSOHunQ08EXrRdpyNV9MbWHX3wKdQPWG2Q98YucU4mXy19QLhxlQBMnXtMwXJ7lk/v63cm02x5T/ksMkE6uA7cl7eatKkHrJsNntjAuMHdkIO3+UCq33ET8UZp0eP0q0aNBTOUR4oKVpCNPnIwIpnpFCCOimtB5y50yg+pCm6L80Gt+EHR8mHKIwT1dlJrQ4frezKcHlNS2XwwuWTwyQnisdAy6JaOawf6DDfr7U2te7jp/hO0U82GRAnyxI2PvKhR+DfcPrdXo/vJnW/7npAZ5+L7U1RQ1v3O/AqPrQyvq0IVzq398v+brj+s0tdqFnnRq4WJ+TUe9XHuojEMZiSpsKhx9eJ3yxl58afxA2ClVt6h1Zt
 UGPPzo01
 glWyXxQVmYvxpIYkozsIBneqcmL7zNdSFR5CTT1COuSwcs837l2nlcgOWBmhtjXwrbtTnE0J0Xip/loplu1yainiinxkhAlRfYJX7G58ho4MzTjITEQTYZu4I+FC3Vro74rvmDUFIKlouq1J5iC4vStpbhlkYG7YLcGoB3cgBgAsGJjzN9hlb3hWIxFuGSeodqWYH5bAKdrc4abxDr0jkSH0ZYOUCg3GgmrDjoW6lM+UgqZImxcdyBQz1mVLsyDShoeLaH8+uxXktQ+dyN+hJpMwrUpkKVbDkE/7Ev/B/SVBnS4KXYhrEoDRYK23HEUlkzjV0T4CLXXC/b7LTon+NE57BYn0Mdi4BP5qAmC0AOyn1ucB4vEHRQPaUwm0Mb6N9E473uqafrH256qXKccVT+6jyxZDIbT63t6t5/QjDNUFaXMHbIgxxF8/wnQrc5o/EnwPklSeGOWTLd8iDjIGsJX1/XrNscWYBBpI5jwCMMF689X+Ts+Wgo2uERyjA8KMhX0wp+Xr65FVnuhSR7hqd3HCrXIL/E+Ljd1YbXO24K1sy4raF0WDFKba051iM3iXANhPEFmu9FXofJbgxPSD1DVJfQwIFkqV4Zm8Ve01+yqkRXWjvEbgx6vNKDH2fpcBSi4L2pDJDO8NEduR6Q38nONoi2XQKyjDojIph12J8oaqNdotx7haAeRmkrOAr9+Cwp1JwCj80wTsCLssHD0YeoLdBfFtn0yvGDDRakJZh2blyp3beC78GKEDlkL9Us2Wd+tzjyQ+KHsuOa+PT6/h2cnnPgRd+hM/XYX+SVFXT7fzxKho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 15:47, David Hildenbrand wrote:
> On 05.09.25 16:43, Usama Arif wrote:
>>
>>
>> On 05/09/2025 15:37, Zi Yan wrote:
>>> On 5 Sep 2025, at 10:11, David Hildenbrand wrote:
>>>
>>>> We added an early exit in thp_underused(), probably to avoid scanning
>>>> pages when there is no chance for success.
>>>>
>>>> However, assume we have max_ptes_none = 511 (default).
>>>>
>>>> Nothing should stop us from freeing all pages part of a THP that
>>>> is completely zero (512) and khugepaged will for sure not try to
>>>> instantiate a THP in that case (512 shared zeropages).
>>>>
>>>> This can just trivially happen if someone writes a single 0 byte into a
>>>> PMD area, or of course, when data ends up being zero later.
>>>>
>>>> So let's remove that early exit.
>>>>
>>>> Do we want to CC stable? Hm, not sure. Probably not urgent.
>>>>
>>>> Note that, as default, the THP shrinker is active
>>>> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
>>>> THPs are added to the deferred split lists. However, with the
>>>> max_ptes_none default we would never scan them. We would not do that. If
>>>> that's not desirable, we should just disable the shrinker as default,
>>>> also not adding all THPs to the deferred split lists.
>>>>
>>>> Easy to reproduce:
>>>>
>>>> 1) Allocate some THPs filled with 0s
>>>>
>>>> <prog.c>
>>>>   #include <string.h>
>>>>   #include <stdio.h>
>>>>   #include <stdlib.h>
>>>>   #include <unistd.h>
>>>>   #include <sys/mman.h>
>>>>
>>>>   const size_t size = 1024*1024*1024;
>>>>
>>>>   int main(void)
>>>>   {
>>>>           size_t offs;
>>>>           char *area;
>>>>
>>>>           area = mmap(0, size, PROT_READ | PROT_WRITE,
>>>>                       MAP_ANON | MAP_PRIVATE, -1, 0);
>>>>           if (area == MAP_FAILED) {
>>>>                   printf("mmap failed\n");
>>>>                   exit(-1);
>>>>           }
>>>>           madvise(area, size, MADV_HUGEPAGE);
>>>>
>>>>           for (offs = 0; offs < size; offs += getpagesize())
>>>>                   area[offs] = 0;
>>>>           pause();
>>>>   }
>>>> <\prog.c>
>>>>
>>>> 2) Trigger the shrinker
>>>>
>>>> E.g., memory pressure through memhog
>>>>
>>>> 3) Observe that THPs are not getting reclaimed
>>>>
>>>> $ cat /proc/`pgrep prog`/smaps_rollup
>>>>
>>>> Would list ~1GiB of AnonHugePages. With this fix, they would get
>>>> reclaimed as expected.
>>>>
>>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>> Cc: Nico Pache <npache@redhat.com>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: Barry Song <baohua@kernel.org>
>>>> Cc: Usama Arif <usamaarif642@gmail.com>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> ---
>>>>   mm/huge_memory.c | 3 ---
>>>>   1 file changed, 3 deletions(-)
>>>>
>>> LGTM. Acked-by: Zi Yan <ziy@nvidia.com>
>>>
>>> I also notice that thp_underused() checks num_zero_pages directly
>>> against khugepaged_max_ptes_none. This means mTHPs will never be regarded
>>> as underused. A similar issue you are discussing in Nico’s khugepaged
>>> mTHP support. Maybe checks against these khugepaged_max* variables
>>> should be calculated based on nr_pages of a large folio, like
>>> making these variables a ratio in other discussion.
>>
>> I unfortunately didnt follow the series in the latest revisions.
>>
>> In the earlier revisions, I think it was decided to not add mTHPs to shrinker
>> as a start, as there are diminshing returns for smaller THPs and having a lot
>> of smaller mTHPs in the deferred list might mean that we get to PMD mapped THPs
>> a lot slower?
> 
> Probably we would want lists per order etc.
> 

Yes that makes sense! and we start with the highest order list.


