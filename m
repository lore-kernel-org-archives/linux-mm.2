Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58FF3CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5946B000C; Fri,  5 Sep 2025 10:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56416B000D; Fri,  5 Sep 2025 10:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C526B000E; Fri,  5 Sep 2025 10:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 978AC6B000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:47:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36D9685373
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:47:20 +0000 (UTC)
X-FDA: 83855474640.11.93B3805
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 163E9C000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:47:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cc4HLECd;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757083638; a=rsa-sha256;
	cv=none;
	b=B7TIY1lOBCRrkQPjDKkpxgyXsqPfM0sCxO46k4TUMkbCzi46Ec0YYuUWP5cJcG/TscuVHb
	FEAT5HgBm2Ak/jGaIyQezaHa3VWRcfZN7mp+c/OB45ls90hTLd7u+MqYxPawMuN0JNMnwp
	My+FWdfh1di3TuBievPIMupJm5eX95k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cc4HLECd;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757083638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SQ0Ro6r3VEH/SXK6+NjfaydDSDk6LrxamH9i5Bcmx4=;
	b=KfJgNE46QMil0cU96OQnhvG0D7co5UiSe/Wv9bSqUqL14jq770OLvkHeK0IRntz1X0S33r
	lTwsQdIYeAtvp4t4dqsNEhIckpTn8Z0wXixbbiz/yEeu8/dgghDHzNohGGuGdx9e+d0jCy
	3S0jedCkCnodYgsNtL7sLSk8IaWgLoI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757083637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4SQ0Ro6r3VEH/SXK6+NjfaydDSDk6LrxamH9i5Bcmx4=;
	b=Cc4HLECdGNpU0+lI/7N4meR3unUvZkJ277NdiOnGSD9brA+udvz+mfH0sLwTa8XsP4fDIq
	fee6uJV76BMBoYMVF3HTjSiG9ZJVfE0dqr5uT+SlIddNUf9+wI2fh0FbMIwuwXq7NSWy5g
	0JW8LZz4i+XqRpvmM4hY/enf0Exes80=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-V-5o8yQ9M_uaEzWSpcg8dg-1; Fri, 05 Sep 2025 10:47:16 -0400
X-MC-Unique: V-5o8yQ9M_uaEzWSpcg8dg-1
X-Mimecast-MFC-AGG-ID: V-5o8yQ9M_uaEzWSpcg8dg_1757083635
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3d1fe9ecd9dso1920468f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757083635; x=1757688435;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4SQ0Ro6r3VEH/SXK6+NjfaydDSDk6LrxamH9i5Bcmx4=;
        b=kE3/mR2V7uypHm6QNJgmLgvPmYnJFvGbOYR9wQBqfcWFFIRu6FPu1ZIbWnAHCnGnDo
         8GoAIpOtcyk31V8yQNUGeW/hgebuw4IQGo1UoLZFO/wxWMNhKW+D1hj2Cz5bNqweCSm7
         vgc5mNdmW61BWpmg7WlEcGfw7xxzKsQ8fMkoEwkCN+6NC/jXfUiQcefl/sEx1DmGPCjG
         8TvgUEsEHoKOko/w2vDZjvm8zVRYuepYPO/wpNLx/NYs/WOXhCIG/nsxLxEtpPnFClO9
         3Kqr0w6UDnFRXhAmbEjt+fdU3goK5RSx76PEBY/stdS6zdCWqV/f0BHL/Pl+bHC8JOKM
         xnOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmsx2vQ3vBFURRDRM1uVo4gAbiywb4TrkK6VofePqNvmJdwuJiQGH8sNNhevtV7TNRIxabF50/YQ==@kvack.org
X-Gm-Message-State: AOJu0Yxte4VThp1uuiwvhu0BFEYdj9m/scbWS0jyvS599q77G8JNZMo/
	dtsoDoUN78qvMBKgXz/ULxtrQpMPkcrL/bng0fvHUHBWX/gZ2cAstQjL2aEqdwUS/60hRXSsCr4
	TIV/AXKRSUEmQefdGxIXdvbJt76UF5pbOJrA8CFYXwNr5gUT7fUpO
X-Gm-Gg: ASbGncseNkoaCMi/QiQxEhDtgj9wHIRcK6bzQXif4Ccpk6m5brsGd+zIoLqvnFS7To9
	IRSjsnR5TTmP2k1LLAjlLdfG4r+7bTFOkNmEq3azbYpIhHSlsZBXABu/L3LQ4w0LXq8Tdxs7kPO
	X8mawpJ/Me8B+IFzVpj3MJ1Wil9WilreDbWpIz4QCFFXTopv6td/YwcGCo8HtKoTHX6dgRHny4s
	NW13R7al0q2kECdktm2i5eoCS0+9lIn2VFLgUgFc3ZwvAYAHGtxsx5+U9aaj05WQgkWRjf4VzZH
	ECywNpqjvj9y2ZlJ+mijtjdyH6CkZRJ05Ytzp13+hfABfv5mDpwg0+ZginWVNEdH5gqQNVXcyPV
	0HmpzLSTC4ZzIsBwUKkskNPpJIIau5DSOJo6GF12qCtqDexorK2ogWltL
X-Received: by 2002:a5d:5d12:0:b0:3e5:25c2:9635 with SMTP id ffacd0b85a97d-3e525d1dc27mr438660f8f.56.1757083634842;
        Fri, 05 Sep 2025 07:47:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsUupoJXbadFaOODLu7jEx9s5JVw11Dqu700eHEpd8jEbAgw1rjB4CH/KLDO9aKS3NLxFfjQ==
X-Received: by 2002:a5d:5d12:0:b0:3e5:25c2:9635 with SMTP id ffacd0b85a97d-3e525d1dc27mr438641f8f.56.1757083634411;
        Fri, 05 Sep 2025 07:47:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fba9fbsm31805962f8f.50.2025.09.05.07.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:47:13 -0700 (PDT)
Message-ID: <e50c8f08-5739-4b12-bb7f-85ff045800d6@redhat.com>
Date: Fri, 5 Sep 2025 16:47:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: Usama Arif <usamaarif642@gmail.com>, Zi Yan <ziy@nvidia.com>
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d5c34688-30b8-4360-bb71-8c85f01bc8f4@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uDkP23ObLKTFkXjnfXDyNuDj15y7S6h-lMTqv5QRgbk_1757083635
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 163E9C000B
X-Stat-Signature: np9fgmaywxakehrdyfkecrtufetmryr1
X-Rspam-User: 
X-HE-Tag: 1757083637-727749
X-HE-Meta: U2FsdGVkX18mLisaFvR5Uihhyz0AbAIVZuzLZTtT5nEd11D5Le/9DmhVPsSwt+f1sa/uvlNZDza1qoGLZgbGwrFYz6FNc7af6SgkiSmRsNBnIw0YHs8MOy9x6J/TlOiu+pN4nHZL6c1JjlLy7XnsWAD8csRAt3Fr71e+tYVYK2hazEV45TcS9mJuZMpwQfrz5Gbiy22HlLo1t0JelW68HJrGYW5/80Jk8VctUA7ybF3ZlwNQ/VpKsoCkRW51dpO+V8VRNUPaZlMCm1SnY0m4wlxNAJRQ7l/yR9Y/N1djJYrCMuRgWwUDdvh7TUGnO39rtHDMyUIQK3+4hTaHbd1PXzD/480zVLOoTXCCUUY7YRdjjNcaIiJw2sGF0vEr1J8mtNoyu+fxXn7LtYswHFN7fqkgB4XowyGQXAiIaqEvNSBu/Y/b6GZt4KP6+J6eGiVFWMmGRWL8ujSYBiQd8Z7AqtCQcLknwmdaw1M56NWUa1Wc9AGvi0Xj1AfoJ0RYwLb3y/A2f3T4S/Gyl4x62jSPeNhfDdllE1lIwFgq2aMeXeNbtSpj3V82MU/HpinQDvEQdW2oTIO1BrppvZKIbwYs8j+XWXKHMcx8MJlY1aZyOFMsob20pzIH9/qDt2v6zXw+7xUDx/o8DD8jXl+1/AycxZxFwDXAgOaXpllIo/iFAQvA9mv2jGbHsOMwPqRE5r3s1C+GfP/OfYFClYH3NEwLoFshvFiBxxqZC9N7y7zgwZTOFLdcwCbn9GXreUTuHC6J+hjiJYXscWl7sOexwyY5+h9xOfIXFPZNq3zUGx+F6DdM1SleUWz1mnA4gYeWkc6rrUJ7K+r3YsyUjJ/Xo0EoDkzZLyDOMOmaRTANNDSZjT+Atvt2VlCYlc9HB0bAPCMt6zC1jHznqhif5iknEEcXpvOhcrOvSpDmrtRmXbCsovd89PKvhWFX5C4lfU3TLOHUoATJm/qGQuxwSPGBQoS
 wYCgxpav
 +QFT0byKvsjpjuwsvy9mo2f6SjsdKMbiuUoa1yL9qATItyxiWNTUawJ1NwmbC0PUG/AnBM3raV+TtvRy1c8Uja0GdBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 16:43, Usama Arif wrote:
> 
> 
> On 05/09/2025 15:37, Zi Yan wrote:
>> On 5 Sep 2025, at 10:11, David Hildenbrand wrote:
>>
>>> We added an early exit in thp_underused(), probably to avoid scanning
>>> pages when there is no chance for success.
>>>
>>> However, assume we have max_ptes_none = 511 (default).
>>>
>>> Nothing should stop us from freeing all pages part of a THP that
>>> is completely zero (512) and khugepaged will for sure not try to
>>> instantiate a THP in that case (512 shared zeropages).
>>>
>>> This can just trivially happen if someone writes a single 0 byte into a
>>> PMD area, or of course, when data ends up being zero later.
>>>
>>> So let's remove that early exit.
>>>
>>> Do we want to CC stable? Hm, not sure. Probably not urgent.
>>>
>>> Note that, as default, the THP shrinker is active
>>> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
>>> THPs are added to the deferred split lists. However, with the
>>> max_ptes_none default we would never scan them. We would not do that. If
>>> that's not desirable, we should just disable the shrinker as default,
>>> also not adding all THPs to the deferred split lists.
>>>
>>> Easy to reproduce:
>>>
>>> 1) Allocate some THPs filled with 0s
>>>
>>> <prog.c>
>>>   #include <string.h>
>>>   #include <stdio.h>
>>>   #include <stdlib.h>
>>>   #include <unistd.h>
>>>   #include <sys/mman.h>
>>>
>>>   const size_t size = 1024*1024*1024;
>>>
>>>   int main(void)
>>>   {
>>>           size_t offs;
>>>           char *area;
>>>
>>>           area = mmap(0, size, PROT_READ | PROT_WRITE,
>>>                       MAP_ANON | MAP_PRIVATE, -1, 0);
>>>           if (area == MAP_FAILED) {
>>>                   printf("mmap failed\n");
>>>                   exit(-1);
>>>           }
>>>           madvise(area, size, MADV_HUGEPAGE);
>>>
>>>           for (offs = 0; offs < size; offs += getpagesize())
>>>                   area[offs] = 0;
>>>           pause();
>>>   }
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
>>>   mm/huge_memory.c | 3 ---
>>>   1 file changed, 3 deletions(-)
>>>
>> LGTM. Acked-by: Zi Yan <ziy@nvidia.com>
>>
>> I also notice that thp_underused() checks num_zero_pages directly
>> against khugepaged_max_ptes_none. This means mTHPs will never be regarded
>> as underused. A similar issue you are discussing in Nico’s khugepaged
>> mTHP support. Maybe checks against these khugepaged_max* variables
>> should be calculated based on nr_pages of a large folio, like
>> making these variables a ratio in other discussion.
> 
> I unfortunately didnt follow the series in the latest revisions.
> 
> In the earlier revisions, I think it was decided to not add mTHPs to shrinker
> as a start, as there are diminshing returns for smaller THPs and having a lot
> of smaller mTHPs in the deferred list might mean that we get to PMD mapped THPs
> a lot slower?

Probably we would want lists per order etc.

-- 
Cheers

David / dhildenb


