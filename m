Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604FACA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FDB46B0022; Fri,  5 Sep 2025 10:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D52C6B0023; Fri,  5 Sep 2025 10:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3836B0024; Fri,  5 Sep 2025 10:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 697366B0022
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:39:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1874B1A0119
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:39:58 +0000 (UTC)
X-FDA: 83855456076.25.E046AA9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 99569140010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:39:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=faKn7Yxv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757083195; a=rsa-sha256;
	cv=none;
	b=MlGJdOOZDou27ABf9ufnSOYVC/FMDI25goqexOae0WKxLPCJlzksd2c1MpeRYkv1dZnsC9
	67l21MMhegu1VHxZfj4Z7aF3azuAYnNZHZKfJztzYk08aQPJiWtkvDAC+K1Cc79Bo0FuiN
	rNd/AP8qwkdTvVoT/xcpS7mTuDGV8d8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=faKn7Yxv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757083195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIT9xzzc+wUHcoSXTn8cF4h16Jg9VDVb8x+KwFayKkE=;
	b=zSjmn3cQt//f1ToayJGxJ+jDT+59Kcyc7+56/rr42Afn12hewLF+vd4RO4BCQjWxKHuB+U
	/sw/AsK8vt0nlKJ3/CU937Z40ryIWkcG+o5Ye0UCMZsad01yWvECIF0PuELk7cMVtIwF8Q
	PS5Q116Bxt9wTxv+mvFE8FX+27LpKLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757083195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aIT9xzzc+wUHcoSXTn8cF4h16Jg9VDVb8x+KwFayKkE=;
	b=faKn7YxvRZCy9gR2OXmL4rih6O962ZFgHHfttK3dekHqFB6/2jxi4loCcIxL5ciyrtden5
	8ZJjQUNhm3GwOmSkbwV11PRVoWw3a1p+y7TTUNGQfnmw4L6w+S5ab2msiXhhc3MmBa8I+b
	IHRmYeqWXS5n44tnWyGEtitNQze4ztE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-mxukenXBPsOPmidg290zVQ-1; Fri, 05 Sep 2025 10:39:53 -0400
X-MC-Unique: mxukenXBPsOPmidg290zVQ-1
X-Mimecast-MFC-AGG-ID: mxukenXBPsOPmidg290zVQ_1757083193
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45d6c770066so12508945e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:39:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757083192; x=1757687992;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aIT9xzzc+wUHcoSXTn8cF4h16Jg9VDVb8x+KwFayKkE=;
        b=gf9ptNgRfHKopzz8gqgszmUAWQMVtcW7zvOXeaAFcYxKLjp6O3zdxB/0THOF+EJG7S
         FDsBc97FfaBNOSGrsrMzGVqh7Zj4R+SE1KIpCKskqoi/DY+wUpahjDzaRgtryb5TU0VC
         TOits6mcdbDltk6sdAD4VX9eOOw4IrKaqVLyvBAWQGSEQPvJ4OMIp8M4N4kFag8eF7Nz
         kCc2fXkkoRCHwjx1XKzxfNtCwK3IJOPfGPxos5LqxTcSvjwSptCe9KB8QzGG337jHD87
         9mStrnNuIKm9Y7Q+Ez0sNTucEdcmTe1LDAxKb/mF7DBcuvG7aEEIM+aFcHy7wEj/MDeN
         yq+A==
X-Forwarded-Encrypted: i=1; AJvYcCWpckHTUSBF0Wn480LEFBhsoEU2tXPddWoKzun28fFrc0i964IymdP8oWV5Xxi3l2hvZS78crsRsg==@kvack.org
X-Gm-Message-State: AOJu0Yxh8VZRygIgSHDUjg2AYAti7E7LRJTMclzcmBgedBdG+cjeKeHR
	ZcO7beFTbbOnd5+nc9QPItdTpvaCi5Je7kQmjuW0qvXuK3ZLfCjeaQKfJsT+Q7X81pE0E2UYqdj
	j0kkJyIpAXIlkyxnhOI91gFy4MEJBR7jdOBr1Cc8I1yEuKN4JKt+l
X-Gm-Gg: ASbGncsXQs6QFoieIE77TRN//HURtHw8LSh1u6wZ/db6CBnsyFjUMdjFSPL+cAmDSly
	+3QRBSEW+ONbJQ6+kD9SHnfNrRgM7TWUJ8s+/BKAJr35RKdJj/yjvEvkdrpWamfSVEe3A4X1AwG
	u6Fs/3jp/ewem51YlPwTQFv+1lfSVKkQfUtH1ia0jwVSloTQwxp7ceu5V7fL+52S5ae7AptYZzO
	ghE5KBqagxQrIPqTWlLrvwNr2yxgFHAW1cLX/94tIt1kAJfx7QG+IrVQCwibl8ZRKoo94/Z34me
	5dtkPqIcosYfwC1W0IamTA6RdVN/PtalJ+7ex2o9aQ4jmK1+jGNbt+H+UIpuaNJkk5MkWPd4OZJ
	Kp9szy6JcJIUqofev1+vJwkEgdlpteO++X8H9yObh20WpkE/zmoEI4HjR
X-Received: by 2002:a05:600c:c1c8:10b0:45b:8600:2bcb with SMTP id 5b1f17b1804b1-45b86002ceemr144363255e9.7.1757083192412;
        Fri, 05 Sep 2025 07:39:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG26zcOGnTmxYKa5prpQ7Q60KpZl8OLelQjav2gH1ZzrBU5kkMMVuaTq4kp2txxfMeIMOp07A==
X-Received: by 2002:a05:600c:c1c8:10b0:45b:8600:2bcb with SMTP id 5b1f17b1804b1-45b86002ceemr144362905e9.7.1757083191951;
        Fri, 05 Sep 2025 07:39:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd0869b33sm84743155e9.9.2025.09.05.07.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:39:51 -0700 (PDT)
Message-ID: <2f4141b3-bd66-415d-b2ff-00544b03b908@redhat.com>
Date: Fri, 5 Sep 2025 16:39:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usamaarif642@gmail.com>
References: <20250905141137.3529867-1-david@redhat.com>
 <7B0B1E09-5083-449F-851D-FD63D32D2B3D@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <7B0B1E09-5083-449F-851D-FD63D32D2B3D@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GIzmhxvfHFWOgiwKFgPGcmA5N7VlxdC4h-XNdQsgib4_1757083193
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 99569140010
X-Stat-Signature: qut1b3so36t89etyurp6mrs7ekfo19bp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757083195-872973
X-HE-Meta: U2FsdGVkX1/YWUeby660xCyjBk3NTArKNOjA85hRm8p7gNP7opsQDxhUICqV/lmPAklnffZwGU9OyRvd8G9TlOyYAm2BePVK/OLW2vjQx6u9W1T7VZ1AfjhNBT/44khaqj4+TfkXvkxavb0RsPtRQMo+A58L90HahLnPwlminIAmQfEiC2wGUFd71p+R6+puHRot0nFIC1FZlR36kpIpUAV5kl+CmmDw+kfFWJ2ijyGdC7zOpdiZi1HbL1o6uaGRMmuCBPLaCjtZ3P0/3aMSTN/dD9oKMRtmJidEPyUSYAVG1SjzT8vYRdXwlyQDst4SRHzrmjI9gDz+v56ELHCTVBfwS1WoAmSU6v0ibu1/oHPTEUq1rtfaMfswbC4RW7luDRaQfdK2AwX+cj0RZTQ5pu0Go5XIVN/lCZ8lzZUkdkowhGBf1iqMuXJ/HveFYZQ7uYPsyXy7/Y33+fjCRl5Q/qVQWm3+6yy5Y6VrMs2HPKVngMYItl2G1nbczmcK2YD0Ji65/Il6sOZX4mBBTZTuy2og7c+7YsS+UCVR3K7YZkkAg67g4J8rcQ3wLMsXMh8fs+/hkITHBdvGhm8AWQ1dJf9wjB4PktQjXuYVpXzrTroGBzJn+fmqyH2lDHp/BbRpG+RL3EbxkWTnaT4QYV+27SMnC8g+o1GSQ9DhE2H9fWVMxKMcFFuGkpXiCKyWf+QGaoCjo7c8Zttoe65cowYTcjrw57pvDUry/2k/fRRqpXYNFfjZB0cMDRqgejo5P2/Pfn40tsNE/y3+AFR17CoAEoIcvL6FWw5mKk+v7+7kxG3uJtrmU1MZA4kPMPYoRdLwHWMm4h1sH/aLVADfaeuJoUXcJNcsDVXqfRMgwqQwJ3jaz3mtGVUuKxKWQ8ChY2DU+6TsMU6MLqhJOnVx/Litvb71z7CDHgkyML2E7U/AEGzpsTzTa+YvsLM/i0mxpR1fbL4NFwKh3Xk0g+a8vdx
 T9QvK5d4
 x0FqlPrfmj7fUOplEbNA+KaAQIS7psOqjeiYf0uf9Ylf2IqduuA9aFQU1hOOaRvr3c5lBoIoTbUbLY1Q6EbOFZlcWLxqpwp+KtdpsxNpkZLgRIDenrNmKbl2wOZ82XjtmKvjFU9xxsB4vcNvUD0wsjevXIeTBefb8113VRYrjyotvNerb7JFyMV7X3kdcloLJ/dAqR/lqdNT1fdas+urO7HtGErR+jJOnZd7mSUKGNA3sxWE1a8EYmnmx7P8vzvr8wrUNukKQxWY3pX6YvjrJhmGe7hpbk5Mrr32caPTw96bi0hVPoEeC5STea6r89h7AvY5RY4Cn2SepIRgcnwEUwMqK2ruM2wazWnDF0B0aTM0qOATijRzGpyUUcadYmqRY7hRLEIucs3y/bpUPNY7h2Zeo0IQsb3NL0iyoRU8AkOiGRZXNEgmAOpFKaYALeymvRoPt104qYg51jdSRv+UObuRannyz2stEfnOMJzsZojFNjGFt7+s0iBz3BesElpE6AW7N/oxkeo37QuXigO80DlsWIzueHiiq9ZhQc2x/5H/3ynD1HIC3P6V3T1T7vICjSiPWgtk78ICahaX5yYXrEofd4FrSh2U0WvKceu3bPu4eWpCwM1uW67c7qX02a5QhwxuC0E5ZfUWuM8uDNr/BfnvZ+sPWYNdc5Mz3+ip+/14yFIp6CrQcttVHyyPpadSCHPeVJ8FgnVpkL8zIC00MCvz6tA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 16:37, Zi Yan wrote:
> On 5 Sep 2025, at 10:11, David Hildenbrand wrote:
> 
>> We added an early exit in thp_underused(), probably to avoid scanning
>> pages when there is no chance for success.
>>
>> However, assume we have max_ptes_none = 511 (default).
>>
>> Nothing should stop us from freeing all pages part of a THP that
>> is completely zero (512) and khugepaged will for sure not try to
>> instantiate a THP in that case (512 shared zeropages).
>>
>> This can just trivially happen if someone writes a single 0 byte into a
>> PMD area, or of course, when data ends up being zero later.
>>
>> So let's remove that early exit.
>>
>> Do we want to CC stable? Hm, not sure. Probably not urgent.
>>
>> Note that, as default, the THP shrinker is active
>> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
>> THPs are added to the deferred split lists. However, with the
>> max_ptes_none default we would never scan them. We would not do that. If
>> that's not desirable, we should just disable the shrinker as default,
>> also not adding all THPs to the deferred split lists.
>>
>> Easy to reproduce:
>>
>> 1) Allocate some THPs filled with 0s
>>
>> <prog.c>
>>   #include <string.h>
>>   #include <stdio.h>
>>   #include <stdlib.h>
>>   #include <unistd.h>
>>   #include <sys/mman.h>
>>
>>   const size_t size = 1024*1024*1024;
>>
>>   int main(void)
>>   {
>>           size_t offs;
>>           char *area;
>>
>>           area = mmap(0, size, PROT_READ | PROT_WRITE,
>>                       MAP_ANON | MAP_PRIVATE, -1, 0);
>>           if (area == MAP_FAILED) {
>>                   printf("mmap failed\n");
>>                   exit(-1);
>>           }
>>           madvise(area, size, MADV_HUGEPAGE);
>>
>>           for (offs = 0; offs < size; offs += getpagesize())
>>                   area[offs] = 0;
>>           pause();
>>   }
>> <\prog.c>
>>
>> 2) Trigger the shrinker
>>
>> E.g., memory pressure through memhog
>>
>> 3) Observe that THPs are not getting reclaimed
>>
>> $ cat /proc/`pgrep prog`/smaps_rollup
>>
>> Would list ~1GiB of AnonHugePages. With this fix, they would get
>> reclaimed as expected.
>>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Usama Arif <usamaarif642@gmail.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/huge_memory.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
> LGTM. Acked-by: Zi Yan <ziy@nvidia.com>
> 
> I also notice that thp_underused() checks num_zero_pages directly
> against khugepaged_max_ptes_none. This means mTHPs will never be regarded
> as underused. A similar issue you are discussing in Nico’s khugepaged
> mTHP support. Maybe checks against these khugepaged_max* variables
> should be calculated based on nr_pages of a large folio, like
> making these variables a ratio in other discussion.

Yeah, factoring that out and cleaning it up is my next step.

But note that mTHPs are not a candidate for the shrinker right now. (see 
my explanation in reply to Nicos patch)

-- 
Cheers

David / dhildenb


