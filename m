Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2DBCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF5B8E0015; Fri,  5 Sep 2025 11:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D969C8E0005; Fri,  5 Sep 2025 11:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CACB48E0015; Fri,  5 Sep 2025 11:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B87F88E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:02:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C634119369
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:02:15 +0000 (UTC)
X-FDA: 83855512230.20.50FC80D
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id C0180100023
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:02:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TDOuUv6b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757084533; a=rsa-sha256;
	cv=none;
	b=c8HdSLEfz0O9oZgt6ryr4lSvQH5W0RqNUFgYVPbCBf2+J6I3Y6i0XDHSBvfzz1RfCoT1e9
	EB9mxjETSh4BkQsLb4PXn9HRb22wjUdhZUsjoEq+uh4Myv8akk3Y3Lq1G4759+1H4r3jP8
	2OyqEjmhtAY7sBd9VNnXKbxyjM32oCQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TDOuUv6b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757084533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaoMsxZI8Yhjr/Cd8wW2J9rqvrFj5skzpXLsWrxWtPM=;
	b=nthKD/KRtuH9fZ8WyCn/yeESrXturZU8Q/geBvcSc138QBs6eFLJcuJCc8Eutcv+kcDOjX
	oRZfDffYTjgvy8XXsy9hkfiZ8hAIVipjaj37pztQydOw5Yzn1cZORNXdBug+lJyy2DYxiV
	Mos0WSYgba2CoH2AfFrN5yBKATR0UHo=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45dd505a1dfso10426905e9.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757084532; x=1757689332; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EaoMsxZI8Yhjr/Cd8wW2J9rqvrFj5skzpXLsWrxWtPM=;
        b=TDOuUv6bEgsE3UwIfktcB7O/SHG2E+FH2bDrDdAiWsxRuPPKj2eHH5MZwH3fSX5r5K
         N5cBqWz7jR/PK4O2ulvoQAUcYLiqP+NnWdEgYlkYPuMQdW2d4EKlGZtmdWSU8IWKx9LA
         dUGFFY18wcz2LnmlO4zWLnSi71pdBUNbmjHW1vcspB4g5pGUkv8F80RV2SxQ3t5472Sp
         XjyutXeiMkWPbKaXfjhlWJEv/8kN2qjlF5r1nYYbJOzwHw0WPxI6MAEtUEd9qWH5Ay8J
         4WbjJJewm+lJlSIQbtoRim77mxKAS9FUV5FJDBSNxS62iFVTtMibJRU/LC1UV5mLUfqZ
         kByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757084532; x=1757689332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EaoMsxZI8Yhjr/Cd8wW2J9rqvrFj5skzpXLsWrxWtPM=;
        b=hTANLGyHGOhZKYxr9po8W/Uop5QBsTu6EjnO9gJcI+GgEulMTGZCk67oNORvk51TLh
         EIqPP51JNadyPH4LZNpFSrUdKI7bCwlx4EI+7Oo+WizpUtRsdb2f/o62oeiivnYr63OQ
         wgdqIA2NTBEtnyYnmEwtdnoy0w174/NZulgqDxJ0eyfR8Gfri39jnM4mu4TkQW0XHSxe
         u8aUlgJexbQVkAGhLy0QNAfAQkqXPtT6L+geDBnKU017dBgSpgUk36/I2mgSVnvFP4pZ
         wnMUJlZyGUQm8YfoZTlztdxraMxfRMj9hC1gKbGkPwwl0uXldD7Vn8vagGnf+ZSFkG2S
         +5Jg==
X-Gm-Message-State: AOJu0YwXkBIP4mNy3petbOVCi7Kaffs0vJ+oOfgYXsYnUcNjrDYfdGAi
	k5mEou3mJ/kPi0Wei8igE/AawBI0Jt1IDOebpC7rfxFw8yCn9ZyXctdv
X-Gm-Gg: ASbGnctCeLIXNSbfDWCndo2Szd0rey3iU0f56WVLBHSQyjw3Manhoi297f/j0KwJE5P
	u4Ij2ktdwzqOKtPxt3aQGw0Oq9Va1VkQ421pgFRb+oWqIxoNLWaFLTi8F2az+zkFMK41AeY31pE
	3IGQG8VesQHWsKlTgGx2OpZ7QfZ2WG6PyzkNrDStAkAm/nwPmUUgzdrlNRvE+zYiafESMSvZX2T
	cv9DYYiiqYQU4GKctn2f0oVTcPSjlYMWxdgHE/XDzlPKZeTF98ypYwv3awuuk8yAzxJlmnzstoB
	BqPcOo0cAP+/uFm3fcZ+irGH/Bn3P6Z3JoGzg8vE8md4oxuR8sarO3s6ISFUSYwUXhgyFb+m6eK
	X8gINgWNvy8uuReRIL+WDRYLjbPIAqL4OubT844UWDf9BMXEio8HaUFPltURuQ0Q0UvSuUnBW7e
	nuiMqykg==
X-Google-Smtp-Source: AGHT+IF52tc+2jGHfWNG+jCjR5B3XPESudwQYDdGn/o+8RZIPAE7fMw1zT471GgS3WKZBqGf9FluDA==
X-Received: by 2002:a05:600c:3543:b0:45d:d9ab:b86d with SMTP id 5b1f17b1804b1-45dd9abbaf8mr22659165e9.31.1757084532079;
        Fri, 05 Sep 2025 08:02:12 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33add504sm31413426f8f.30.2025.09.05.08.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:02:11 -0700 (PDT)
Message-ID: <74906d5a-a838-4f0a-8f07-532c787d3540@gmail.com>
Date: Fri, 5 Sep 2025 16:02:08 +0100
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
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250905141137.3529867-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C0180100023
X-Stat-Signature: w7zaj1yuydd3k171hfhccsnpqmh6d6pq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757084533-268367
X-HE-Meta: U2FsdGVkX1/b4se/HoNUjh/lb4/3hpweOKW8lGEsMvyiW/ypZDA0x6YigLiDJ/6mGDDSBktxxOgR6lHaBFKwizIQwtWEvX2jfaW2vEwwgjL/7c3YULKhWqDxGBRUBnAafl6TcuMKn4mUGRgXqXHVsdTh+G7w729W/7sn2y7JTftsM+y5XLG16GrLODBjAoTjjA/XOmPNAZtdJYxM1b+j4yAhLeum2M6zTOSNjMrR2j/9LOhjgU1d5qbmD3W6CfxoIbFiia91iW/eT2jf+CGDa/iHxUadLplA3aucDkT7K+utknPpQ9IKBcM4K1OcjjBnbdoWtOs/+uBJGeLPUYc+91W0bXhbt18Kate6Hxn2OIH2jmPFQrI2IUbEM+J5lOBnmlTqj6LQqmpnQq91LB55jTs4Oy9cxslb+14waTqyKsN+PoYzTA03P9TNC2ehqvU42FSmqSmyAkRH414e8ZxfJHbS1RGBhc83LuWEIIfjpzVsHAlv93hrgey6/kE6AUA4CLMZ3IRkK65uHwo4NH4dTEwgMlK+/EJIHQypcccFC1FN6pVShtGba3TSOA5tef3vNw9NdG7UbmgHpr8PG7S9GuMm9mSuLg1MvkkJnW5Yaf33lfywuI+iWe1vxU7tL3xrzJ5vQVdF+WQrihnPPRW0xqOXtcos0tPbXfSoqj6cKmzOb9IPlgXDstgTIpIK+V6viuIqQfH+cCcebKBZRa37WhhUTggaDJKwlIXYy+EM0PDAIms/OdBgDhktd2CB2Zod4/u+wz0qTtsrFss3kkIC1xqCSP54drR2s2UKs8aRh4X6TX+eg2iUlUm8i+SKd7mUTOf3AXLOm7XCzd0V/8hz5Ec33P5uidXwJnaGuas1um7kZnYdKW4xdgfrAqif8iB9jBCo7UB4Lmq7d3i1D52qCw9SR/55uVnxTwkuIjmUwy5HvVexjs1yfmgPZprENehNF9l/ayIVJLh+E6vjZ0a
 UkHsGnYe
 8D0WzRjWrUOui0aD3Fk5iFUten4vvtADiqeOqhrNMV87DqSy39HvmCYKhTrur48hJQgSbvTtLJaUl9EI9gAhgSiZFh88Hb7ce57RfCQ+4tOqUwJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 15:11, David Hildenbrand wrote:
> We added an early exit in thp_underused(), probably to avoid scanning
> pages when there is no chance for success.
> 
> However, assume we have max_ptes_none = 511 (default).
> 
> Nothing should stop us from freeing all pages part of a THP that
> is completely zero (512) and khugepaged will for sure not try to
> instantiate a THP in that case (512 shared zeropages).
> 
> This can just trivially happen if someone writes a single 0 byte into a
> PMD area, or of course, when data ends up being zero later.
> 
> So let's remove that early exit.
> 
> Do we want to CC stable? Hm, not sure. Probably not urgent.
> 
> Note that, as default, the THP shrinker is active
> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
> THPs are added to the deferred split lists. However, with the
> max_ptes_none default we would never scan them. We would not do that. If
> that's not desirable, we should just disable the shrinker as default,
> also not adding all THPs to the deferred split lists.
> 
> Easy to reproduce:
> 
> 1) Allocate some THPs filled with 0s
> 
> <prog.c>
>  #include <string.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
>  #include <sys/mman.h>
> 
>  const size_t size = 1024*1024*1024;
> 
>  int main(void)
>  {
>          size_t offs;
>          char *area;
> 
>          area = mmap(0, size, PROT_READ | PROT_WRITE,
>                      MAP_ANON | MAP_PRIVATE, -1, 0);
>          if (area == MAP_FAILED) {
>                  printf("mmap failed\n");
>                  exit(-1);
>          }
>          madvise(area, size, MADV_HUGEPAGE);
> 
>          for (offs = 0; offs < size; offs += getpagesize())
>                  area[offs] = 0;
>          pause();
>  }
> <\prog.c>
> 
> 2) Trigger the shrinker
> 
> E.g., memory pressure through memhog
> 
> 3) Observe that THPs are not getting reclaimed
> 
> $ cat /proc/`pgrep prog`/smaps_rollup
> 
> Would list ~1GiB of AnonHugePages. With this fix, they would get
> reclaimed as expected.
> 
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>


Acked-by: Usama Arif <usamaarif642@gmail.com>

