Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5CDC87FCF
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 00:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4BA96B00D0; Sun, 10 Aug 2025 20:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23AA8E0006; Sun, 10 Aug 2025 20:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60926B00D2; Sun, 10 Aug 2025 20:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A39806B00D0
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 20:54:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A16E828FA
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:54:04 +0000 (UTC)
X-FDA: 83762654808.04.ABFECA7
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0D75180009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:54:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AB4xnUZj;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754873642;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfAL7OHNRL+yQVFuu/NKw3SqTIftsb3HWCW5RjqtI3s=;
	b=NVGTMCHEJifSFISAJd0Je74h7s2zsCKyNfixmE/+JRsVe60pTkm1RB89cc7JQSF0BXD3Ia
	GOVNdY5wCrcUHwly4GeZtF2/8sOFCuAvEkTije94PMVN4x+yHvOi+gpX252OY0ZYnPng7R
	AlxYmpcdSO1jNH3YHru11IjJqcBIiGg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AB4xnUZj;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754873642; a=rsa-sha256;
	cv=none;
	b=cgi6RHo2PLQ7ghO6XXD8/qjFiV9+Dgbjsqd2LLLV/y/ux0QNqhbOmF3ljmJ0TN/s8eRhQm
	lMde8OwmorYeH9Bnj0CbCPpfI6ShM8ngK2Xqaa8W5Rla8IgUgSQ55S8puVulhgBOOQPDoU
	rGlHTm1xIhBfenGmMLkpWOZyXMEXjMc=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ae0bde4d5c9so725357566b.3
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 17:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754873640; x=1755478440; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GfAL7OHNRL+yQVFuu/NKw3SqTIftsb3HWCW5RjqtI3s=;
        b=AB4xnUZjUqAzeZmLIR8bPmgSoxKaLP0rAr2ccLHCynEOPDMl9aEt2TsF3oZloY1P8H
         jMoWfB2zckv3wm8whXK3/YIv3mwUspWDHWic0EXLkElzGVs3kxWK6x6EWbddWThzdTkO
         u3op+Lwez47oCD1BYke0SIVBeF1oxIyNSHWop+Xmto1lXzTGnroopu/ji361r1zxgcLk
         jFbTjZ/gZr791Q1Hd0PoIyyqBu6PmiGQJzLRqXFvOnovvbH4ruVL0pLGNqZyrWWELC9k
         eWS89n27xZG20VgnTQJQP7M8XCXUJALVWttZ+pm7nJ+LLYh5CyZRHWIJEB7WrSL+98Ux
         /0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754873641; x=1755478441;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfAL7OHNRL+yQVFuu/NKw3SqTIftsb3HWCW5RjqtI3s=;
        b=n9DWzptowC9haZiLwAf+fzxugH2W8JA0o1otwOokdoMAKf38aQnY4nIqcIQOFxMjqA
         9Y/saiLRwl9W/qrgMD6y89ttbYmh5RBLk+1GCc2mEIdiAsSrE7IB170X6l7iLKRoDXJ6
         kMqTESxy6SGVaGUOXTlbCUiq2NdJ89UJUV/6sZEgPcX8qpTF6evxLWbq/hGgO0bm/Skq
         GJZMtUIKE98Vq0GQ9QWJtnkGkLA6EGUZrTUM58uCYNfIdLYLPYhSWWyFvDGjdbs28h6K
         Y9FFI/CWaLRiF2tLxTwvrLB+Ir12FjO6z0AOQAZGjq7hfJfdzwkiRXSvDjRio6RBKaTc
         XTrw==
X-Forwarded-Encrypted: i=1; AJvYcCVZUzsxPJgSo6WQTI4642WIfepcU5DX4EYJBXWeEnoCGDBB/6nErk/br4ktTNcJJsk9Qek+kEYVVg==@kvack.org
X-Gm-Message-State: AOJu0YwUubZr2fzdLMP0/Z46kPMVq/eoTXqqpjGysb7S5SQE2vE+zYvn
	KzI4QUu9JojeyhbXTi+I3iKOmEVuph/K3sErL42uDKtYXAjFfyxxrdNU
X-Gm-Gg: ASbGncuQmW9j91IO/NUvTJTCN7D4SwJW8zUorqF/tHi4ZLGyivaMBoDQF/pGHRq5gpb
	lrpeZNslIsrLeHbQqY0iwouup/TURsfqYpspEfCyxQ6Po2LRS/BMW3PQqe/FkxFELC80maOj706
	9BD8ddErfkTTgF/yoZAg/rul8xZwD/m3nML2n/aOpBykUtcuZeQIFrweM+hSEk4cMM/EK191u6j
	LyJHB0JYhKb5t5UhyG9uljKJVmSLZ03bWWb9pXMBVD3ypMo96jsVo5mG/8kUUVlfoimFAnifqaE
	m+NrNqWyToYsFGzoHf37dFtlmd2EjMhUq6Qhbe47KfCRXJ7EU3PsqlKM+qZuXhJtRILB7qmesYN
	ot6Lfi6CAIkRMStAwnuqpsBwV3EMXBEl6
X-Google-Smtp-Source: AGHT+IHsZZagdZ0itwRFvyhRDe+O+TNUaFNVRpyXMyyhYSYQr24NtQ+mE53tiy6Fn8fRXKQukvzd8A==
X-Received: by 2002:a17:907:d87:b0:ae0:ce90:4b6c with SMTP id a640c23a62f3a-af9c650d656mr997922066b.49.1754873640428;
        Sun, 10 Aug 2025 17:54:00 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a218aa3sm1940459066b.93.2025.08.10.17.53.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Aug 2025 17:54:00 -0700 (PDT)
Date: Mon, 11 Aug 2025 00:53:59 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [Patch v2] selftests/mm: do check_huge_anon() with a number been
 passed in
Message-ID: <20250811005359.v2t75i4nhdyj5ev7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250809194209.30484-1-richard.weiyang@gmail.com>
 <7fcea8e2-4393-4a21-b6fc-39b853f07d3c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fcea8e2-4393-4a21-b6fc-39b853f07d3c@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D75180009
X-Rspamd-Server: rspam06
X-Stat-Signature: gz7rmbqhyswb5wk55ch6bosugnxeu7h3
X-HE-Tag: 1754873641-764076
X-HE-Meta: U2FsdGVkX19HFzAikYp5Rx6IEW1Ao58B1e9ZQVU5QF2Cy9x7t43K03KT5fJQxKlXfKO1PhxE18X5/geLU2/J1Hod6RsQCNAKuiozcxxCI1fGPrDtZ+OChoOvSC96Twm5U9z1LCxj1rV8OpMdIJbZ17ZRNPnOCm1Eq8Gv8zsRWnq68qK0Sy+RzFn5xqJ91a8W7gvqeXGdy65FQQzO7n3EncjUJz6NXYOgf+zPsinnqJ3108GfragRHqbKzBc3w8xtE1lCcF2tV1qh6uw69BXz4eE2FgXWbQyM+Kb/D1CLzHLptUeDypCNFpx0VxzynvRgC1pcLz080gi4XylljtCVQk5EsH7eH659ekxulkuzVGyzn5+aLVJz2IH/2+uKU2XgErVTFkSD+L7cYyI8ZvW3eZLvbeZ/oDG6mjUG0QVxTdJU0z3D1vEhXeJXuex0xxsjic0mj93Zy+FuMk5jn+Kr5HhYJLkwexCfCWw9pUddtdMegQahBBYjQ07F0j+Jen6g3dr/dRj9RkNs4JHQSVulnNTc4XnW46DzUT5L7vQkyjZeeJ6NsD+zgJSYONAF7YswSz235dRHPlIkKvg25Vml5BRdGf75H5H9Qp36lFTDrSbvaP9OM5H9dREpd5p767eP2eDj0140AM74/nd3ajCQE5V2nKZEYqvlvKsc2hv9bBJgms0xrXXhUDQIKDmbv+iRMfgPdcnfsKQfMMLcMp1fx1Eg7q9+imfX/oVLMFsA1+EqwGDaZR2JJcqDJRuyOzeZKLN1wrrBrd0s23ZxDHPouYRzh/Q7foceGZz9HYE+ei4CJwXzx3GfwH7AQLJCzxHF5QRo9//XSIdbAT/F4gZn9hlnvPqlvV3M/t1Z8KA0ZrqQDC1sIIlJX/0Kwbmp+6uUgD9IueLRYil0u7sxNX1T9we9vWZUxkau+GlNY9AKLDc+6H8gfxZ+HqoWY0MJKrTidPQpDG5qM6zqvgEF8X/
 4fHeqE/u
 sQG4poJBggQOI9aJ53KvvairWLoo8TNXGUPy/C9LE9SpovIM/1n9y+0Epi3iBWW9TJ8Z3kjF7L2gArjO7s7bJIPa4yIJEbkMqPRurmCpek2UZMuyTt3x/9ksmVQomjrulQjVW0dk1sRKUixoP25eft/sErjeJBxjcJzCTapMWung0K5tOCQ5QZJHNCycDiDBF42vZJFwP2ZOf8JbKR8SI6cVK6dPXNnkz5YpWGSzGIDFwuQV6PweHvKOzqrGsb4MD6neg5NPoiIU/N/STt7ZvQWqCHU3wSXtrSz0xtQn2oY+iC1CY2axRVzK3toPV9iEBaSmox6CGC63JCyi6MX6jRgbaQACOYYxxPT0cuyOEE3I8imQGlem90+Urmmm+Gd3/bTxlWckML4Sz96r6+FJhVG3k6r5S3RVOfocPIbnmc3nabdRggIdF8gMvzFQ2aggq0AM9HSE/E27vYHstHpI01yDIJkca9CWYHMb+7UhUEDBT3DAG53NFvPH+JtEy7JwYlFZcSdGxrdc4/dFpdqMWyotUK3ti65xwT0vi+ofuhpcHJPmBaq/i3N+Jrqz4wYlh4mloK9xpX34C/ZgJ6N2TUBz+UemT7+smadYD9JKQk7Ce1GbNI7LlI854uqeZ8VMJ51DzV0NmY5ovWbVtcVrPOmi2sgWXVQWl5Zn5iKSTa8HP7MUDmdxHzNt60ylyB1LgDhGuCB/r7Mp4XsaWsqS6HSGVLhDKLllfiYfRGcn97u8tPdrd0AEAj5zugrmT32TRL4NxGchvV7uWnMOG8aHAaycuAAP+/sq1e0+LbqHk96DUPdLufmsmCVe0AOE/irVMoh0AdYI0ydeH6cCe4aXqWLBmA9lkbQIX8FSt8rPq/D6SjXfchQiofOxL8uqrC6RPhOmmjMTbI6nkTVcWMS2t7OVGdzCkuSrC5q7dPR5zWg+IZ20V6+0B8+RmmB1/S4Po9EuhH4HBXnRhWn+pS2G2p+P6bWls
 ibawqwAR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 07:07:47PM +0530, Donet Tom wrote:
>
>On 8/10/25 1:12 AM, Wei Yang wrote:
>> Currently it hard codes the number of hugepage to check for
>> check_huge_anon(), but it would be more reasonable to do the check based
>> on a number passed in.
>> 
>> Pass in the hugepage number and do the check based on it.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Donet Tom <donettom@linux.ibm.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> 
>> ---
>> v2:
>>    * use mm-new
>>    * add back nr_hpages which is removed by an early commit
>>    * adjust the change log a little
>>    * drop RB and resend
>> ---
>>   tools/testing/selftests/mm/split_huge_page_test.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 5ab488fab1cd..63ac82f0b9e0 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -105,12 +105,12 @@ static char *allocate_zero_filled_hugepage(size_t len)
>>   	return result;
>>   }
>> -static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, size_t len)
>> +static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
>
>
>We are re-adding this argument because nr_hpages should be the same in both
>split_pmd_zero_pages and verify_rss_anon_split_huge_page_all_zeroes,
>correct? I was just wondering — since the value is currently hardcoded
>in both functions, would it be preferable to pass it as an argument,
>or keep it hardcoded, What benefit do we gain by re-adding this argument?
>

Thanks for your comment.

It looks the correct way to do so.

-- 
Wei Yang
Help you, Help me

