Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F2BCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690158E0008; Fri,  5 Sep 2025 10:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666038E0005; Fri,  5 Sep 2025 10:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C038E0008; Fri,  5 Sep 2025 10:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46A138E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:40:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E78AD84F64
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:40:46 +0000 (UTC)
X-FDA: 83855458092.23.7D4DA64
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id D986840005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:40:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyDHJWrD;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757083245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruv15YVZGd+unn8eyN2kDSKfSxE6YIH+rd+SuV6Cw4g=;
	b=PTHGfluhL/AjrSk/wKALIw+ldoqTCXF8O2sS1Q67erwISa+6XHD1YUr0XDcYoVhgjGa1A6
	ZLdnPylIzcOV1GK+LMA4eQCeDvarDYgBxM7vcn1pGePW5Qn2dOoBpGp6daMTQb08/57Qf6
	691u1t3TvILbwJdtKdpl6x39X7dvz6A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyDHJWrD;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757083245; a=rsa-sha256;
	cv=none;
	b=A/TlAb2WMd+GknQ43OnlxvqEjp3+Z7aCjLCCdcKdxS5tmFPs0PGbxoCfgCyzv5Esb9YDWR
	b8ftDh8Ldc3vyeWlThrpujaDgDWscFHb8H5c48ExBYHe4WXAIaMMGEpd8ej27GjU9Pp+gX
	OLWSIUKRzMSQhklKSPRaUC90vcHfc/A=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b8b2712d8so20196225e9.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757083243; x=1757688043; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ruv15YVZGd+unn8eyN2kDSKfSxE6YIH+rd+SuV6Cw4g=;
        b=kyDHJWrDxfiEN/l3CwIFQCUuKkEsCVzKOxqJ+V5PBEBkc5PK5M270FVOe+xY2X9Epi
         DCXYKX6Lo9FQF3u3/lOGSZSUiejLKsSWWImtuD3znXSNe/vsxCQg/z4Y8uoUSd5vev0R
         nyU5jn9gAzu8l2a6xDsryd3ITPGynMptlwcF10O15NctMFUQ5IUyVXIdnRLQoin+k1FG
         jkQhv0OSOwK6Lbs/0/uGfuaaoiGkMYV/zi3qjy2i+6eXU//fFZl1acEc5BNyuh8YZT5k
         ZQY520EnGZnGtpoM1pcWMx1w2WX3JVDXw+z1ZHE65DgU1EG+4TCG0lXw4CZaQv+a65rm
         X+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757083243; x=1757688043;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ruv15YVZGd+unn8eyN2kDSKfSxE6YIH+rd+SuV6Cw4g=;
        b=Jd+rdGvUwTXNXXsuGQSGoGYLdi5RbuJ7fGKK3hh6jhj4+T3sBA9TX4I9Dko6PC5Tmw
         Wse7671UoqRMHFZU1FZfx+ivYKnRjx+5WQB990+YHUCGy0LOfR/Q8Ne7pbkwBtwglDGh
         EKRXBnG9nbtY2fHxRgOykuI1dSRBkDEEzOn6JLS17xpdQ7WaHrskCXeXiCd6cxn8nkEY
         OQGvBsuMs0DqSDCt8ALHrwJQ4XvlJlg021hviAxfaQxtnWiWIlpNbTSy1nhjbpjvEn3/
         RGOlo1DNKD102CrPXtIO4k6H6bTfNxy1OAtIqq68MsIDuijhvM1ojXq3cKKGmO0QVH0w
         yoog==
X-Gm-Message-State: AOJu0Yy22f3lDAM3g92TtE8fiZJbcr91P/Esax3PVg6ZDWbQ1MB94eLI
	eAx6d/1vcKPVZlvEFj6nBk6wVHpuOP4RV0yng1ukznmRxrXOgtPx7+2t
X-Gm-Gg: ASbGncs854YXX4Dwv2r6FCVBW3dM4rC1gtP6xkyN7Ab/6LPPod+buCoGIT23GThOxCf
	MSgpK9YxsIu/zGVVoMW5hIs5kjgSUvHtjsMNCp0aOK406p96v94oRa2f+QUOBb8VL94QxRfAJze
	gwmKo11AyaDMjGXKfXSzSamJPf01VH2NQN9T88eWpDNOJS4S5/O/gy3jRPVkreaqTL53QOJBVdv
	YZf5pnwKyMJsGR+bgFw1xXfarhPkFZEvoZiNjQE15Th5/z5chYa0B3HQWq5mqENwSXliT+s2yKu
	OdItRGHGRXXY6FtRRcaUK6Nz0Pqn+IQ/n2DOOilKNXXiTE9XS8FeE7I1yPItci/gNczZJNM1J4Y
	6YAtCWy7Ric4vNagzMiYFFJn6Ile1sFHr2Jyl0ukO/Kvw/fsp+DIYvE5AbY3aR5pz4xdiKi+bKG
	+ePUABqg==
X-Google-Smtp-Source: AGHT+IGu07r/gZnXoPunBkFAHKSx8jyMa/2Jlap3WzA+NjHvNOW/3Z9J7vjwq2h0Xwukh0ua1/Kj4A==
X-Received: by 2002:a05:600c:4513:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-45b8553365bmr200220705e9.12.1757083242842;
        Fri, 05 Sep 2025 07:40:42 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd60b381csm37364505e9.17.2025.09.05.07.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:40:42 -0700 (PDT)
Message-ID: <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
Date: Fri, 5 Sep 2025 15:40:39 +0100
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
X-Rspamd-Queue-Id: D986840005
X-Rspam-User: 
X-Stat-Signature: jw3e7id3wgskocz7qwt4nfrswibtefey
X-Rspamd-Server: rspam09
X-HE-Tag: 1757083244-669978
X-HE-Meta: U2FsdGVkX1/pjUZwUiyATJ7XJNmeu1VQjtclbeZY7xb2RdjrYKqF8SIUcphrsOpT8rCZqbYCW/EKa+3Vma/if/poOBDJnGli2o9i0NeiK/6u84Bkc4m+lHThIVFzq0b/hG2+bUuAPOU8j4PyK9MSVSeJUsau2KrJP1EWrOePYw6m6uk+pR3oMCfReE0Kzzc6zG/HRAvcyrOB2r/k1eUNmw6szwfg/jRCy/U09nem8LQmevjAUADkZYhecVejomCLztn6ylSl8xE0lmVOZbR8YfC2Lvp/TJZyBuHtk8tjb683205gmh2EV5XLByKrATmI0h8hyv4TgzfMXftPRtpc4YCVy9m3cEoSnXv6cAZgtuxZmhHj+TdNiopmLp2RI0q/ZVryOmg0kw5IQGGafkvuWb3P5qmEIQHgBHx1UGiliYwfixuyaOW7IEvvOOXL5qk2wrR0apnddooS3gEj+rNT6cr4d5uxV1AaNmP2yt8/tGW0yczOmAINSsLCOj1FWScs5gf/VVOLaWKf7hD4s2IrH5gXjNRldhw16PZz+/1WhCqjKUlPmMVkeJb107CzJn/qQyiLWsflXIAMpQame3J7UJlPEylQtRIykRK8pIvygAQN9Tgo5FNz97S4x01quftXoQSTjReui0296k9XdUIHK6TA7ZwriVKUBpaOQilmm2KvyCOK2RPpUXqF8ceAWFpwtlbgaMJGIZ4T2tPvM7qSY/RJH5IYqvw7xJbPo1fS5n5Lq3/fPAI0iSrtqkhWdvbu4+DcmgB1Fp+PA//RtdbA2E8F+qEXQqVweXfPZ4OBwZBCPjVTGRj7G7hypvJyWD1Swnb2uJEpwvxUWE9XZ/A4xi39aEwFB2kNC9aWDC+T2XS9aT4QygnRtICJtEp8ve0ayfwyWQ0Z+LT7X1BXnGC4LfrXEvgHaG0gwX2TeUNuWXxe/UNt4az8QFBSy6qODnnT9R9WGywd/FfQI1MMmgH
 C0kYmzwE
 M7+A5Fs6jTsOglV29cbo/O8qvM/plNd9wNizSOhUgunP1zsCujEl5Czw21GW1/Bk+VCmGrgufX+Nry6zrh7EBnQBzAoUdPlCadJ5bFXDqs5+joQPv+6NTb9F+RMoA6HCHMmVPDS4ojw7wQF63q+lu9U3PohMOdeleT4sn9umTPlDaakHYl5xZ4RD4qAfPoH+ChxR90/nqSuuevpjxbxWND6TGd4lkGLSkpHbd26WIL/RSAIRZNeSvEhBRWHRJVZ1Xx2r0HimrE3FxwQl6oUNecG4SuBWeVDq9lzp/HfBG13jk7GFsG0aR1XponIWsnGPB0DaGTgWBYOaOLYSuXF6Iz9Ou1nej6UUlFxjw5shV3YGgs7uwfp//XpJUArl/jI2uB3Pz308gwFYSqG9HLoitcRSPJ3ms0mROszWAbqKHk4IrqcmmN36Ouz7DGGEU/SMF4tMZ3NyBRw9k4Uj8xN/0LJBU3ShpuC/d3n3olNcfQSr4C1nsnCexm435JRswuncwfDEYzNyzH6QQeUvAblxIlygQ/iYd+QuCs5kMR0RNubl6mFguV4OhOGU6mdmDUYr7vvOJ3CaUAD1RutyMyXKuMs1+R4538j5r3b6HUInx8agpkHzZ/oAnkwYnFCfx60sM7I7hDMn+7DY1mIk+PEmKO6bSY+4rpgMIvMC3mprZ99l39s1fmsj2qMBSRtqhqQdBgKi6cqRvEPVjiMKtoZw6bx8npCVseIy0WZkOLbzwj90NF4sz89V0RpzZ+e6eon99QQJ7I267IP9rvjGwbiPVb9EXcA==
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

Yes, that was the main reason.

> However, assume we have max_ptes_none = 511 (default).
> 
> Nothing should stop us from freeing all pages part of a THP that
> is completely zero (512) and khugepaged will for sure not try to
> instantiate a THP in that case (512 shared zeropages).

Agree with this point for this patch.

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

The reason I did this is for the case if you change max_ptes_none after the THP is added
to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
so that its considered for splitting.

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
> ---
>  mm/huge_memory.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd74189..aa3ed7a86435b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
>  	void *kaddr;
>  	int i;
>  
> -	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> -		return false;
> -

I do agree with your usecase, but I am really worried about the amount of
work and cpu time the THP shrinker will consume when max_ptes_none is 511
(I dont have any numbers to back up my worry :)), and its less likely that
we will have these completely zeroed out THPs (again no numbers to back up
this statement). We have the huge_zero_folio as well which is installed on read.

>  	for (i = 0; i < folio_nr_pages(folio); i++) {
>  		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>  		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {


