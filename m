Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CE4CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C9E8E000C; Fri,  5 Sep 2025 10:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD628E0005; Fri,  5 Sep 2025 10:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB7F8E000C; Fri,  5 Sep 2025 10:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A79A8E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:54:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1E601601D6
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:54:06 +0000 (UTC)
X-FDA: 83855491692.15.3B1BF8B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id BEF0140008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:54:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YcbNhIgV;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757084044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1ki06iYpj+ewE6s7Y+9ZydcBaRBzNiVkNilJgQiAH8=;
	b=3hxcla5oAADl3lnq5vxbAmxqkSvLA7Id05jyS8C0oaQNyPbAFpnK+VQJfhg5ruLJ5Xwr2J
	3ZVVrQvSVeLfit1dB/Yp8jgi8a4/BqlQCUOAqpeqxCSeZfX06ZC1FEzkzCKCLqx2KeW6Cr
	umYKe4iWGmS31AtZF9jqrplcBHiMesg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YcbNhIgV;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757084044; a=rsa-sha256;
	cv=none;
	b=gcYiRMLCtviDd79QyuL+ebBQ+0f405BPfgS7PKLySkTSilVFbuWIySXTwHlkHQk0te0/JF
	ILnJcz3vGIeBk8PUyzwUOYzFz6gG2IZagrplE0pKRVgLNKqYhGuH8Z77NbpdEYzMQpRVCn
	QEWcs2IuOTbZhXanYkiAnGsihjgpzmE=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3da9ad0c1f4so1528816f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757084043; x=1757688843; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+1ki06iYpj+ewE6s7Y+9ZydcBaRBzNiVkNilJgQiAH8=;
        b=YcbNhIgVxWqq39Y5rdJoW8nVkBix7OlDwjKheDzdFPicMlpJy4JOAqtqTFFo4D4Rho
         lsjK9nbnkgYFJGCmLciM8EeKzncWvl/0zjqTNWxtQOksOBYmJzi67NIx4TgMXS9VR9Dr
         3sbQV1ilW/WNi4TnZyhgEOxam/gk+M1/yUurCXXm0elqiCTeSrPCYqqU+5Q7S/Q30Ywg
         DuNTWC9PtTpWxKihvzDTSy3CNyTTy1XsY2izlTOfG/FzptcquviRq0HPPokk1AjClErA
         TKjYJEoA4IbiCGwZ9ccMaVgYKjf+bzYnNe2Ps6rtJGcmGPcfVd0te3vEVPu/HzW/fm1S
         dKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757084043; x=1757688843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+1ki06iYpj+ewE6s7Y+9ZydcBaRBzNiVkNilJgQiAH8=;
        b=UQhHaN6esTgT9Ap0XR0/BVCoO5yexV1LiQbKZf+MreOFzSMc8PRD+Ghiq/QT4k3h+m
         fQZvShIzUZCDMhBDvvZwEBkOMO5wx5l7M4jWXrdFMDI5+g+pNd/Cx4aLnt5fkcsbMFiK
         JQ56UNLV4DJTVrBrDnH5333kk7UEgioXHjox5V12dNeBIbEglhBEASxyeVj2St6LUIAP
         MQyihuX9iqHZxv+ycffE4Kz316mM0KlPf9eRd6iclngN3aH62ttA4f0jI3AqQZHkppKQ
         bMrJctjLvlwFCRX69IZ/13Vmp8NFnVUlN/3kP9kjqIr29q0MVq2zqqyZL/luZpHS+77u
         wyEw==
X-Gm-Message-State: AOJu0YyUmUHI3xVzRYGOI7L3tWxy8FlDEZGMMgPlNclJiF2IH8E1osFI
	h+GkNC0Kv0PAw25DrKkkBHM7TftuEElQIY3B1TexTWrh40ZHbN++kJ3p
X-Gm-Gg: ASbGncuNHzcSsdXhwEbRTNSxHpkHYHUM+gCP/LFoCgx7tmIviStc4T1rgN84Zb7/yRh
	7TNplq5fvUgvMlwL8L1SuB93CdTNRgr5tQAfpNdVZSg30Gx+YGWEU+RgCFonScOGfXQ7OvI2icR
	PWJW9+GXr28ME930EVmqgJUJyuQ1PwLTNQgHvoOPC4sprc38OWEzGE6XgzVHZhC4L7Tu5MCseVj
	tMQwfelBTuYFcKq8mNLV8k2yv577G2EZ43ErWxNWae0V2lSeg7YNyZuHBIi7OIvJ772nhUJq2US
	dWhQXLzSWP/5BHmIapM9ybPTYsVIvkEWIk6ovouOkDkj1LDZJAu+9fOcz3w0QwUsNkmjPNIpXS9
	9p62LZuWSt2oxufajlq3dOeN9AVL4MapKFrs20MlUjqvMMeQiXZuQ+or8w7jzFGN+CwlF3QihsJ
	bTXyVYyA==
X-Google-Smtp-Source: AGHT+IHGutNFXBpxj8SMepvOz4hjsxKNNsZIUg4ENk/gO7vKInJCsTI+b65PQGjSrF51dESUxTVGiQ==
X-Received: by 2002:a05:6000:2f84:b0:3e4:74dc:a3bb with SMTP id ffacd0b85a97d-3e474dcd583mr1734804f8f.40.1757084042867;
        Fri, 05 Sep 2025 07:54:02 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d95df59e50sm16689769f8f.23.2025.09.05.07.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:54:01 -0700 (PDT)
Message-ID: <8b9ee2fe-91ef-4475-905c-cf0943ada720@gmail.com>
Date: Fri, 5 Sep 2025 15:53:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
 <1aa5818f-eb75-4aee-a866-9d2f81111056@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <1aa5818f-eb75-4aee-a866-9d2f81111056@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BEF0140008
X-Rspam-User: 
X-Stat-Signature: kc5c9taxeeo58uekhbcqaej8bm93931q
X-Rspamd-Server: rspam09
X-HE-Tag: 1757084044-127107
X-HE-Meta: U2FsdGVkX18EeEcK7Zmhr9akNEmLQ4ZDxvmmlCjM9PEcBsEPGqyit0b4TSwIolySfOOwLa09GoY1Li7bfjiTRNx0iJjhDAVfGm9+RpDjOeoPSPoIIXKwVfV0oHTDVdYRR9DG+H2WGquJiFxE6UUtMDMw8SOT6uQb/xnvWbSnLmnYcL9M8YJ4j/xafI216mA42a/RdjcznpULSs2+gog3G+AwfB1ArvFvmMOlq9Nbh9u2StZII1LPI6LTSeePkiVtoexe9/NOSP5feDu1bDLXyTf0vT9g3z/ZMtlRiP2FKUwYmLqYg8wJRRGrPiuaNYvtTP7SL+S+mVlGOn0gaTy/OSMf/Okhs9wejj1yh3Z2RqoAef/8m5QF72JlCt+HicUVUA9q/P3KVx99gselJGv5U++SVDLY6oQLpZM1op2bQfTxpXMLmNgCWt9K2BVpTDR0gMTMkzA1rwppnz+JbtUJjprjrI+Zpr9zvU0R3nAwhKCXkOraFQ7sTbQtmhoyZodntAjCv/f5hwXpY5RevhqlY8c4qQNBHvV65KlcU1r4xjkTFluavOL6u/8uOxjqcuI22czrQmKQegvQQs1hjsFsVtb4e1zRNsckFM3nzOASgTTzw6dom0GPHulvwNfqQcwLZCUdcDeVDk0C6XiNRmdibFyz6CqsIKxAKuC2x6o2p8eMLm7Fb2fRIR89N42CYYgtGWflHN4qjSSna436sJzL8K3ciWFJ9e5KnAzmAfqId/to1y2y9vMrZ6kJ+ROt2l/JklPo3mLP/yb3viQ/Ynh31q9uV+79oEmiw/LLQGBxyt1YgAKLCikmM1azO3GYZRwNjkM/EIOn6y6F+1Z7xA3VORE/+4GUbVT5SY4hYVisVMo9J/Ezy7KBZ0zVpbb+JQdqplZjItqWE9aYGiMxK+eFT031A6NV57PNiBw61shqSGzk9PV3JsCVI6PZ9B/Fv/rcFEZnUFU7wlTCN6Rzkqt
 wNVY5cwz
 mTCi1SP/U6KgdrT3qgsAZv80TuUP6XekVgbrxp7dk57/w9Si49L9Jen/VBYMJnmaj7OQLX7tA7D7ZTvO7/BeZ8YUpPSDhR3VkEc3yx3UabXGp2MA4kR+GCFf3iX3tm8Gm9JpElJnIp2Pg9HxIj2kY/RbUgO0UgNSmwkbA/3/J3a3pCqv2aVkYspkAQqF9dd0Su3xTZ0E7B/ogyA8pk7gJru8YqWXPTNUUz0IW8mCRqc7kkOka4ZLswcTiV+y0Q22jeBGGQfhBt1wCVklzRhSxpfZ9buNK46FvcwUH0UpMES8Y8VG+42ujfiHxZuvxoakvqSHipny17tVnpr0RItRy6fBmYZ0x0fB0HKqeMhO3UVZNHwHdmlAbqSSgSF2BOS7es3doZH+Qk3TYE3ltcKHRzD5NrmHudsHykaIVfWSjPKh5QFuDbWZMdl/6pJNooVVRu3rjiMmshNaDA9BkD4yBDaYaEcBddy/PHRCu7N/ca6VzWKfOWyvDkTNfFPgCNwn3PSlsbWYWxHj6KR6aUoLrWc8Q7tGrXe8hA+It1A/p12O3Dcrli+F48TbqYlC/XjCR8nRxC3R0/M66z3t7Gj/mXIfkjQ/CEEQbrhdc0UQRLCg8dMYW7iOonpxmg2v1livKdEoQQeUTTk/AdoT8biEuIkk5jGi1FVDvg6UnZTF9vqgrVuxUpp2gyNAmPx5cTSWnilTIhdQ7QyixVi1obJPXPUeqaP4SChcCh4P7y2eixkoHir0xwkgoAZAGgwMWKofPqLFc5ZFa4Mqz7/SdipSS/c2V8yYZcW6NlWQYLnIB3J+OQBM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 15:46, David Hildenbrand wrote:
> [...]
> 
>>
>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>> so that its considered for splitting.
> 
> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
> 
> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.

Yes, I do this as well, i.e. have a low value from the start.

Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
the usecase you are describing below, but we wont encounter the increased CPU usage.> 
>>
>>> Easy to reproduce:
>>>
>>> 1) Allocate some THPs filled with 0s
>>>
>>> <prog.c>
>>>   #include <string.h>
>>>   #include <stdio.h>
>>>   #include <stdlib.h>
>>>   #include <unistd.h>
>>>   #include <sys/mman.h>
>>>
>>>   const size_t size = 1024*1024*1024;
>>>
>>>   int main(void)
>>>   {
>>>           size_t offs;
>>>           char *area;
>>>
>>>           area = mmap(0, size, PROT_READ | PROT_WRITE,
>>>                       MAP_ANON | MAP_PRIVATE, -1, 0);
>>>           if (area == MAP_FAILED) {
>>>                   printf("mmap failed\n");
>>>                   exit(-1);
>>>           }
>>>           madvise(area, size, MADV_HUGEPAGE);
>>>
>>>           for (offs = 0; offs < size; offs += getpagesize())
>>>                   area[offs] = 0;
>>>           pause();
>>>   }
>>> <\prog.c>
>>>
>>> 2) Trigger the shrinker
>>>
>>> E.g., memory pressure through memhog
>>>
>>> 3) Observe that THPs are not getting reclaimed
>>>
>>> $ cat /proc/`pgrep prog`/smaps_rollup
>>>
>>> Would list ~1GiB of AnonHugePages. With this fix, they would get
>>> reclaimed as expected.
>>>
>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Nico Pache <npache@redhat.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Usama Arif <usamaarif642@gmail.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>   mm/huge_memory.c | 3 ---
>>>   1 file changed, 3 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 26cedfcd74189..aa3ed7a86435b 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
>>>       void *kaddr;
>>>       int i;
>>>   -    if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>>> -        return false;
>>> -
>>
>> I do agree with your usecase, but I am really worried about the amount of
>> work and cpu time the THP shrinker will consume when max_ptes_none is 511
>> (I dont have any numbers to back up my worry :)), and its less likely that
>> we will have these completely zeroed out THPs (again no numbers to back up
>> this statement).
> 
> Then then shrinker shall be deactivated as default if that becomes a problem.
> 
> Fortunately you documented the desired semantics:
> 
> "All THPs at fault and collapse time will be added to _deferred_list,
> and will therefore be split under memory pressure if they are considered
> "underused". A THP is underused if the number of zero-filled pages in
> the THP is above max_ptes_none (see below)."
> 
>> We have the huge_zero_folio as well which is installed on read.
> 
> Yes, only if the huge zero folio is not available. Which will then also get properly reclaimed.
> 


