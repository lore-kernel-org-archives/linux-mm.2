Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D1ACA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB798E002E; Mon,  1 Sep 2025 05:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2AA8E0016; Mon,  1 Sep 2025 05:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B3B8E002E; Mon,  1 Sep 2025 05:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A7D8E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:32:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34CDF5B05A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:32:20 +0000 (UTC)
X-FDA: 83840165640.29.3E8DF5F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id AD48620008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:32:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fMTI5kSg;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756719137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CyiHJMde4+JA7nIu8EIckcMpRgflKup3jCqjGGNXb8=;
	b=1spHBvfPcVCz0nXOkChZtG/7L1p15bIwwydTJboH/TeKyGBz2IJloLiDuJD0YzidpaQQ1A
	sAjuLZWBrGpurWBhI5PEqGuzSD43QVnXydZu/dxSkqIRNBHKY26/pUjFGhGZ5SLmNj6guX
	LzIVMPw0u/2HQXviyCLbBrtarHOsKa8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756719137; a=rsa-sha256;
	cv=none;
	b=39SHaBsLteIAUNwwbo9X6lkOcp3bJIp324JsfkbZquhxk4LZry/pF5F1CduDeVC27SkcYx
	aO8vJA5V6H2KsAPoecjvkR8Cf724cMft6sVdt9nB8I2ssW/mcMg4zPEBFjtmjKoN4soUQk
	ciHA5dTsLmJ+g62KmmqoxXtXHOfop78=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fMTI5kSg;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756719137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0CyiHJMde4+JA7nIu8EIckcMpRgflKup3jCqjGGNXb8=;
	b=fMTI5kSgMQ74hroDK4EJnUlGtBjbufcND2trRyhDVRkmT24TZbQy4VCREEug+AGUY5jG3j
	3ZWuwTVwLsGmGAZgIczdgBApWREaDfo6vIoBnyMhqMCRTDYFjKAhPHqw8aIW/Bt5vChNwC
	w/bcUw7VyXcpH7zOqtWWat/oN2LzITM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-cj4tWpGMO6qi6Inn-FImFQ-1; Mon, 01 Sep 2025 05:32:15 -0400
X-MC-Unique: cj4tWpGMO6qi6Inn-FImFQ-1
X-Mimecast-MFC-AGG-ID: cj4tWpGMO6qi6Inn-FImFQ_1756719135
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ce059e3b83so1620131f8f.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756719134; x=1757323934;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0CyiHJMde4+JA7nIu8EIckcMpRgflKup3jCqjGGNXb8=;
        b=Kzn22wuqmtm1v/hiVHPd0Wc3pSxCrycRGpDzHQnIFpKaXAjQYY4TU10Ar7oGD5ynBN
         JoKO6RuHefpUVwmtJMhfpO4st3qPrcllGHX9fGjrIw6bt3Pf2IsCPxAO+fPy2CBXkHZh
         OCnYcfMiZLK6eAzI2Pi+5T4+UbL5BNZ8VgiNLp7KTrzqWPWXkQ4TBUI22j+5YDiMTkj9
         8Y9RIXB31yOFE61CF3Op0wd5joylrxA4tePPo+vIvoEwL1yGE9hgnKPe/fuX4xoEHd+t
         UFC7n9wT1VTRin8egw4enn3hDwsOJSAcb6SEQDJjoZ5soSzrPuHAdvC2wSIaNl9OHIXc
         WJFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLG/fPaoHSse3O8M+/zHAghrSbxoftKf0TtqalqRNqG+UjKtyKKf9GSAIEsYDkwlubckrw21jnJA==@kvack.org
X-Gm-Message-State: AOJu0Yz3r5x70nVgT4hePXegoma/tBp2TCvk/cV+QNBKkrRSrEIYhgzp
	yT7u831kwjuREkyQzLOOfJhGKd1Y/dMSxlhYtVyi/OFPgLygPLJyLmhXIilwhdAnaX2Ai1SlO6O
	pj5R+JDsAfO7fL8vJp6x1DmAnUQMtkVDyZs3xrwKP6KhlygYW7BYU
X-Gm-Gg: ASbGnctsNIgqaZhg/x7sNxKDtKcGui/xnrHR8TJCNq9U4syrajhLpCF/AE2vpcx6BnS
	YvK9l0p1pvzcPR1Ccmdwd62fp4/JpK0xH1f1zNyqbkNlRhrlrdxA4mMDWOj2VIPUUStNuvZk0sS
	48L4KqR/PQNp0jS1qNtNciSPdBLeEmJSXJuksVAa7MrlWQc5j18zuLECU3rPi09N/YKWIPioAf6
	/bxVaK/zwKmemY2c6Oxc6XbP+ujuH/22bJXQ/a2D5n3nAc9VmPDLh9/34pMqEAimTxmd0i5+bJN
	ybvyIUM9yX9KPwADgQ3JgpiPkjdJBMmrXGGTc36oG64V5nbxmgoeWiaqnepyQOMuM0sa4R8QTit
	bHuksGIevc1H4o7k/GQIsIZTspxFokkVLmS7W1Q2xSwlII0uEwVdPEESYQSwN9dto3CA=
X-Received: by 2002:a05:6000:2408:b0:3d1:61f0:d264 with SMTP id ffacd0b85a97d-3d1e05b8de7mr5930704f8f.54.1756719134229;
        Mon, 01 Sep 2025 02:32:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbVWUoZyAg1JX17eUAf7Uwo+ahqZ4/AjwAvSEK935UzqpqzJwTEesLyNbMeD6Ijvs4WaOAOw==
X-Received: by 2002:a05:6000:2408:b0:3d1:61f0:d264 with SMTP id ffacd0b85a97d-3d1e05b8de7mr5930604f8f.54.1756719132526;
        Mon, 01 Sep 2025 02:32:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d60cf93cb2sm4808744f8f.12.2025.09.01.02.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 02:32:12 -0700 (PDT)
Message-ID: <c89a9096-716a-4bbb-a911-99096ff8f0a0@redhat.com>
Date: Mon, 1 Sep 2025 11:32:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: directly add pagesize instead of increase
 until page size
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20250830023102.14981-1-richard.weiyang@gmail.com>
 <E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hkGUqB0glblBFXIlLFw6-dF8SqkDbB07evjPy6HuuAU_1756719135
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD48620008
X-Stat-Signature: qnta9yebi8n7zjx9ruu3oecpugzuboid
X-HE-Tag: 1756719137-840136
X-HE-Meta: U2FsdGVkX1/k7Gu0Rrmo3+9bfNulTPlI5CrzHZpsZqqusbPCHv4iBalMns0vjVIQMnPCM4qPwCMlX4PviQrQCmhxOxWTW5vbXUoRvSjiK2rU/Y6+x/0XSP1msBCAmkdNtPSVXRcmj82fYeF2NwAg/w6HaGK186ENJNBnezWYcj0cq8CI4w35fKPOwZBqzTnL4zlZyPds5UorhZDPcObDY4EUn/S4iN7avJVM164B4xLhdDOqfB27oEhF2IxBOUkyhByp/tzb11707pOe7HMkzw0ZpHgTjMd6xq3vPgo3n9AbbMLoaQ+z+Dafd4lLDRHB5j1SJwJkUHvS2lryWOdeVYCEI0P/vymouIzV/nYw6Nx/fYIfDvH1tXRk1GYyKercKGtErLDEhHQsckljPF8+8yvW/lFLL0fg1y4DmrD24wl/iMMv+6R2+RV+c5yXS1o+aLiwE2LVxfXm3YNgauPd3HnST2PKcfH0LnsAI3ip16hqVlMZVhFeqyN5IBFkZYvXeioqVIJ4aFsM/9CwVsdpW5dL259b8274DsoS0OPXCUAOgrD52zVm27b/JsGF+zUhV/GnUDUxizii+Vle4lO+5A/Bdu/cYtDgTmyrbmg20z5I7obMm545nfzARC1o9enJlc93YDv+J1QOVCKf9lFWnjOkebitIljWuRScUmPvk01LayZ4tPACw5eXi7YF+vmATM9vQqG2GNK4s8wfrW+c1KexCLpWPIjEBUT7FnuJH/d2CZRoGzF23PVK4B5cu36kVqmbhgKu3zzglrBoOw5eInhe4x9KrHVrwpq/3eXXbPrhEwOT7u5aJhMM9F0gt+xtATrww7eTuU5HzVm+BW0T02iZ7Wr/WEDwmohpYMcFR3aHmhysLtm97OWO6R+cfjwJ28rYTNx662Kg5htdKz+UOqcYwskgMwX7i1UA7a+8XIEipB2E2V0az9oNWFN4/EmxbVur2wfUEJcplOAGUa3
 Vvt5QDQg
 uYiovSiTH8GeUTAUJEtHbYhb89VzTURnnUpRjVAIhK3BgyHygV6nHr8G0gMwOIaxzcIvEnvAE5R7s9deesXJtvL6tPBWcks3BudKPwQcUHtLEREzMeQurTUf6ZNWiUgJN5asj54yWT2t7G5ZUUJZPn/nypup2CPcgCuYBJCQ6DjXYDq3gAW3Kexg3B7233hKiuXinVsvl8RP/5cOn/XTVGr3PrXmOtzGN1TpyT9/opCuLcSa+CP0ECH9m1qdAF79jQrK1mjoCOHyIvnOG8aJRhp0LuVm01cQDCxmJUzAckQEIC5bKXV6T987Je/su9YBrgEjJ5rtYMnq526ECccEaIJZK8lVJegdDZELmPjCxoRhMhxO/lZy68B1K4WRDYWiM76fxIyGXZM05u48M0QWNN8MSfWX/dXnUqbMioV8JCISz8CaRL/8qIDXTHZcb1QmfQ799AMdOL/U+1pbXvwzISlWHROMKmyC332E2TVChSxkq1leHQNpQedsoku/PTWdE5agD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 03:32, Zi Yan wrote:
> On 29 Aug 2025, at 22:31, Wei Yang wrote:
> 
>> The check of is_backed_by_folio() is done on each page.
>>
>> Directly move pointer to next page instead of increase one and check if
>> it is page size aligned.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>   tools/testing/selftests/mm/split_huge_page_test.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 10ae65ea032f..7f7016ba4054 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -423,9 +423,8 @@ static void split_pte_mapped_thp(void)
>>
>>   	/* smap does not show THPs after mremap, use kpageflags instead */
>>   	thp_size = 0;
>> -	for (i = 0; i < pagesize * 4; i++)
>> -		if (i % pagesize == 0 &&
>> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>> +	for (i = 0; i < pagesize * 4; i += pagesize)
>> +		if (is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>   			thp_size++;
>>
>>   	if (thp_size != 4)
> 
> It might be better to add
> 
> if (pte_mapped[i] != (char)i)
> 	ksft_exit_fail_msg("%ld byte corrupted\n", i);
> 
> instead to make sure mremap() does not change pte_mapped[] values.

We do have a corruption check later in that function, so I think we can 
just keep it simple here.

So this as is LGTM

Acked-by: David Hildenbrand <david@redhat.com>

As noted, we should just move from mremap() to mprotect() or sth like 
that which has clearer semantics.

-- 
Cheers

David / dhildenb


