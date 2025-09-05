Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3414FCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932FF8E000B; Fri,  5 Sep 2025 10:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A978E0005; Fri,  5 Sep 2025 10:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820008E000B; Fri,  5 Sep 2025 10:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 706998E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:46:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0388CC0219
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:46:30 +0000 (UTC)
X-FDA: 83855472582.15.7B64C15
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9DDA7180004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:46:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D3cz1Boz;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757083588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StuuOmRSI+HpFIlfBf87jbL35E0EZeBKXFAaU3wBprM=;
	b=hx2OxCuCQlOhyQwhJiMExG0cbw9NpnJCG8cC0j2c14mum0Ltw2p1PgJ471CRDWoTRhwGL5
	015LGR3a1gPvoo7BHZV0kpRdxZFCgTd4kfUYl73kU0rv9w0x4PWaxSAp3P7XcaNGTAw18o
	5C/3WpM3PGJFPHUphKsML5fFyWt+ZFM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D3cz1Boz;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757083588; a=rsa-sha256;
	cv=none;
	b=xdeDfEcUi3qLgmzUSKQ1NxzVrVX/vxIkfz8fBFMbFwhhcLX7WUxLGQIPG8Em7QANEnXjEF
	gLCPHGnFv8dxRBef6yeu2mmhXCxQKKbiRI0UDCv8pe9bepUOebKijWlL/941V4E1JZZXsK
	WnoIFX7azeItVvmEW+8kz7i1cFzt9oo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757083588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=StuuOmRSI+HpFIlfBf87jbL35E0EZeBKXFAaU3wBprM=;
	b=D3cz1Boz/WqC0ernR38K4YvrJ9T22x8iGGTDTaCNUPZXsoHpdN4a80V0MeUuguuwo797PU
	ao7PeuxJVlvWD+4LwGChLOhBpiwJ6OU80IeffB/Z97x/Z6xaBsF9H8kIRLrE3TAhxb9HUy
	L2tYxIPPWfq5MSegTq+JqXGnMpwRAeA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-IOpYRqAhMqauHp4rW8pLJg-1; Fri, 05 Sep 2025 10:46:25 -0400
X-MC-Unique: IOpYRqAhMqauHp4rW8pLJg-1
X-Mimecast-MFC-AGG-ID: IOpYRqAhMqauHp4rW8pLJg_1757083584
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45ceeae0513so12211765e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757083584; x=1757688384;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=StuuOmRSI+HpFIlfBf87jbL35E0EZeBKXFAaU3wBprM=;
        b=vkiTO0xMnlYTwhql4juTAPIbieuTIZN4j3t7pE2ZhAjgX+BFAgyRaLBmwsdJZHuxpD
         xQUZXwklzYiwoPo30kXIPQ5644E8NUXKAZLQ5EHGFfZ2otJS6LFqm76t3iODvIBr2HI5
         RJfOBcyj+A3FHzqgYniMMnIZr55YmdwE7lsEFGWT+sxdkd9C6lP1M3Y6rqmeb5r6TTDC
         tP0r7xKxlNIpqbbygv0xmwdCkBLf3bv+tY0OVnZwuCpD8TgvNKXOjdOuGJoGF+i5ncG5
         YSVlhYdl0fiMcucBDvoFhqbPWmYWAzWNo+xvR+e6oCoiNsC3ws/wv9oBpP0TK3Tw1x7p
         WVsw==
X-Gm-Message-State: AOJu0Yx7MPYWSWNTFIs/l+5lrL9ycXx3/Ethfvpj94VqFSU2zs3EuvQs
	4eDOsIEWWduXa307rAN3SsaT42vIc7PiyAhyXOia3aQN96EurhHZg366UFKzxwr1ImMyZeG8YKz
	ByEVVLuaY0ejeF7wdKdkHaxgRpmSWxAIFXnea7M51/HRvMhnBxQio
X-Gm-Gg: ASbGncu+n7goDPIxasnRmTx4HRp2lemmHDxrZqBocfr4NkIwsysvVGXmGXO7BkdNDOW
	KJleiDHeCH9E6cvIhPGKCf+8pkhVpHbRHtvbVA5Rba+97DBVEatZAzLV8xYuwvHW2eEnylIaOFG
	t/qZhZh6rtumtRlpOO7oWHfBqHjTPsYtvSGphSiFBlZk/b1fVtRj16Hprk+6uEeO2B4AZ1zioul
	IqolpwvAwrBGZukb5JRGtbre9RjDJTfLMfdPc7cgEsIcpdJbqsrKnBOodYVX+Lyfkxt+dYyZVuY
	QzcXBqc4UQ0CYYDXFjmoZ0YuEvicJZLA+b/FY/h6TFBjaFhHsFAGxN7cpIA4CULiodAuNCq4+Lw
	25q4VGvzMUME/5veof0JbDt/CxeDXLCelLWAQk2Adwj2wnXkg33I4o1/J
X-Received: by 2002:a05:600c:1c91:b0:45b:8795:4caa with SMTP id 5b1f17b1804b1-45dcfa6b946mr55933465e9.36.1757083583802;
        Fri, 05 Sep 2025 07:46:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtXL4u6qBiUj5sGS3/tCmNMUG503qqTPgghxO03yjWUc3pS9QYk0Gb9OCJXy3McmpNlPvBbQ==
X-Received: by 2002:a05:600c:1c91:b0:45b:8795:4caa with SMTP id 5b1f17b1804b1-45dcfa6b946mr55933115e9.36.1757083583290;
        Fri, 05 Sep 2025 07:46:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45ddc315d78sm5319915e9.4.2025.09.05.07.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:46:22 -0700 (PDT)
Message-ID: <1aa5818f-eb75-4aee-a866-9d2f81111056@redhat.com>
Date: Fri, 5 Sep 2025 16:46:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: Usama Arif <usamaarif642@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a10-RJyXbJZ-cMxkroioSGYA7BxeXpFIeFzZyOcG5MQ_1757083584
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 67i8fdb4greusbzok8iiaopjjyoafrh6
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DDA7180004
X-Rspamd-Server: rspam05
X-HE-Tag: 1757083588-717712
X-HE-Meta: U2FsdGVkX1/vMyx8Yb9+15o72yWNMRz6PSzXkmvVNOBcZ8g5LISAgNf2i57jtcd/DO4dOGnhAG6mRzX8AmdPLi4W8LNz0YHoGTTZpTK3SLCVYZhLxJyjf+xTfJlL9ONqYIwkuA9ZkDNA1ZLkUi9x+eijunKWOhhfHuti2zwxjnM4Y4Opt9gUcEf4mbhbg4q7pW63jEFzFlMb6RzmA8t46ZYCgzDl+eqnrfVRcnXDalyDQFf/H6IRZQpm0uBr/qo7odmKunJ6xIRb++ojk2Qt80rOfpblcfQEa9nlBFoWIYoKbX/TUn9VRwpb3cFMI83PsxD+gfdxNi2ZT40/L/IXBuMx7ny8aMCNrtlTj6rAQ8NIYZGZzwo/w7cde8egIfbnIZpzHaV4ZCZyy+iGM3ewafI+G6EBRIq08h22iEljG8BVJGgYPEwrKcB208yqoDlWYJKklczKAxrPS2V8plo+D8n6WFfD/9758cFR2DvPvkjN/o2/lD6XNjkb/TkUzDGA40jf1oW4r8IvwYOmXTyXWk0UNNoRcg+wQgCWPOGj8V1H69VcwBbyYdoj0KltWCfj2cuJq1drcvnAJi9C4Q6jr1dl3NXePmn/JVmS1ZZXknR0hmXhACvhxASSuH2fEN4LLL0cyykLsZDokvKU6pwy24mhm7zC6cwSU90gVw/jWihAJblLswVmENpMaWeSnV2yvDmPgwUBDWzfiqnkQznEAB22IXHpPnYOPz9GMMEmI2xSUuIkUWVUPbHzaknPXiapAc0SCR1KsjSAyT8ggo/hrcu5kgQcuryBu7y0+UjXQCzxTcV6m1rfFpyHQgVbRqI/elIfJ/DoKDFLzgalepHu9hZdP1zjZt4jANV1idrenhJAajLkqVrP4D8oXphdic2vHsHMiXFw7zt38FcEJdIVV+jMdmWsz9w1XcpkqLq7C4OjfZhrAK2BdTTGDoLHz8686EhlvaCihGjoOqt+/uB
 g5o4g8Zp
 Sd3IYd62Fidj8E8bRUlUbA04U62la5f/DRISDPXlbKff0zwDIIPViVkIA3aqAFt0sW63HNDdgw7ZrY6jzXNy1aYNARgBsuBOymPX1NJjLOpAq8D3ieyLNRTjx+XhEVpmufrGNSAvXsNp9FGlrAliwWgdQWJL65EQAnRl1DWsZ1rq+cqNFifzQZ6EvhwWkS0RCUxEoPHlbJSWHI+1uxs7I3/ik6vFMoIkBbJ8pQqE8n3FNhxdj552MF67yHPYyTuzcd5IEZOFRAt5YbZDgFjxzonp0mBq+ZIUdUVJd44WHZaRa6XuQ/BFYXpJhXIC/U02gjxdGStRz6NRWydJ9T/1CLtn0RRXIz68h7yT60MWo/3GsJTncfXwEQRTuLEpRKZm6vlW6I4OZGP0kE8ySXvGTexeoxrDgsKjWNb0ehc4FN7gTBRkmXNPBxERzcFM7kHgz5gy/WCSOwRSCOnYh9bw+ikToyZ6N73iJn8fvtaWjIhgoa/GeNE2dACWt9J8lVqw2YxQm2stvFtJkB+G4WVvMiOGQ0EEQckXaQrnoF9l8DKdCQ42IDaZH3aSzYhinrw3AuPb7xHrnJeSAwbqnNbUecJZKFBGFcBiG69GuBDd52gYNlKVxc/2TWepMyTOcNjNXAUM6xz9X80i1094WMydbWk7KTPD8vE0xdkpDquh4G98P2jFkiXsv/lpM3bFgRF1O5n5k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> 
> The reason I did this is for the case if you change max_ptes_none after the THP is added
> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
> so that its considered for splitting.

Yeah, I was assuming that was the reason why the shrinker is enabled as 
default.

But in any sane system, the admin would enable the shrinker early. If 
not, we can look into handling it differently.

> 
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
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 26cedfcd74189..aa3ed7a86435b 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
>>   	void *kaddr;
>>   	int i;
>>   
>> -	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>> -		return false;
>> -
> 
> I do agree with your usecase, but I am really worried about the amount of
> work and cpu time the THP shrinker will consume when max_ptes_none is 511
> (I dont have any numbers to back up my worry :)), and its less likely that
> we will have these completely zeroed out THPs (again no numbers to back up
> this statement).

Then then shrinker shall be deactivated as default if that becomes a 
problem.

Fortunately you documented the desired semantics:

"All THPs at fault and collapse time will be added to _deferred_list,
and will therefore be split under memory pressure if they are considered
"underused". A THP is underused if the number of zero-filled pages in
the THP is above max_ptes_none (see below)."

> We have the huge_zero_folio as well which is installed on read.

Yes, only if the huge zero folio is not available. Which will then also 
get properly reclaimed.

-- 
Cheers

David / dhildenb


