Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE232CA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175FD8E000D; Wed,  3 Sep 2025 05:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125688E0001; Wed,  3 Sep 2025 05:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014BE8E000D; Wed,  3 Sep 2025 05:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E24308E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:22:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A030911A359
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:22:19 +0000 (UTC)
X-FDA: 83847397998.27.02A447C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4929018000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:22:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BsezCilZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891337; a=rsa-sha256;
	cv=none;
	b=jqbDWB8B63fkHOu1/HOSqPUJlVOpsXSSUpxGxQbgn4UAxEmuWwPpH/AEriUIGZQdF9igRJ
	EeLao8YsSWpkG3p+OR4AXt+++DnHF4Pg55ga9rhUJUybdZ7GXRxshLTI4nUAJlZ5b0LL+D
	R6WIdAb1r5roIl979xn2iPCdq739H64=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BsezCilZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0FPh5XZdEAd+Tv8vDi5Fj27lr8KTz0TZ6Jk5W1QXK8=;
	b=g+5UMX0OB5KNujbofQ5imRqs5a/86FMrOddB6RPVBfLYf8xOjFk6Sw0+zbq6ERhp2vzUK0
	Cu24ibuXQvYMLu/t9fZUus9Z331JuYMj5j/TTt1TiPjAwVbZBnuxyrC0wyqZqz3uwEbkos
	LRVKq2D2CTJt73QvZGLxBw8Oj/wSf28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756891336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x0FPh5XZdEAd+Tv8vDi5Fj27lr8KTz0TZ6Jk5W1QXK8=;
	b=BsezCilZ41Mo9SNGkqEtFJ+QLNF8htT09PJvfSduUnVGevXeu+uFnPw308UF7pSXgQCX18
	9tW2zDB8hDgMuphS65OZxKZCR8jwJucerFC+De/S98f2RIdh4tr8UoTFDPFT22/C43oeA9
	u5sZ/uoJZcW7s2nAiWZPHFo9vCZGH4I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-1S0gCUTZMSO-5uniyuJfVQ-1; Wed, 03 Sep 2025 05:22:13 -0400
X-MC-Unique: 1S0gCUTZMSO-5uniyuJfVQ-1
X-Mimecast-MFC-AGG-ID: 1S0gCUTZMSO-5uniyuJfVQ_1756891332
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8af0b8deso17957515e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756891332; x=1757496132;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x0FPh5XZdEAd+Tv8vDi5Fj27lr8KTz0TZ6Jk5W1QXK8=;
        b=SSOcgGD21RAZYyjiMGpA4sTpiufZRO6X6ODBn5XleN8HEXUEyOMLQFYlm+Mg4VO7gA
         Mj6MybFV0wXbi4dXAM+7inK8zm+sITXCXQXLZgnkORS5nx0JMoVp9VyAR35q8hGnTcAP
         9QVj8ZfPhAcGU20PDnj1gFljMveWQB1g7zRYkvYXPNW2ltb1UJPD0FKDSSgy/KI9MsTG
         j6O4R/C8uaKfJxaFXDTvqCPdjbpHbZWkZZvHL8lsfkN4Fka8H9Z8r79o5dSJoN/z/7ZZ
         21jAwZWCqlP5QjlACqYHfoyW8aBb1X7B+7hHrU3MCI85mtqbRsY4iYS579qEGmwuWGz9
         z2MA==
X-Forwarded-Encrypted: i=1; AJvYcCU+I80PDqa2zx+hvvmTH7F7ozGIPWzyFQVnavWUKrv1DQpCc4dug8or0eSajxgKPTpbSTxjztkDKQ==@kvack.org
X-Gm-Message-State: AOJu0YxQG2ScK4dtUDQ7e4ZLFQQtodI0TB+clueyazZHfoEosEWTeduj
	dZ4gW42tIDiR36KIATZU+d8h77jSEeIrFmJbLgaemzRFBIys+CJe9jU6kAnVCrp8LaoBOeY2/GX
	uCxtOhP/0PgwJXa8lTX+FTCzq5uCSnc6NF9sVIK/6F+96GfcIZKLF
X-Gm-Gg: ASbGncud8NLUw5boBf5mMEfWbya+KfXOdxOSmtzT6mpZyC9TpcWhV50+oKKJQHc2oDz
	CS9BvqBSdtnsgk5n7SDJ+C8IJsaebzRfZltyNXpb7EM+Lq/hPBIEEZhhZL78mf0cFZ+jeZ2BM21
	+PXqUqaTTUFixGNR9vzlMVhlH59zrmOgtreOnxF4SxLcPnOhjrGRCQnwVbj7EbfOHwKqrbdwu+i
	fj29335OqBoCrHafXtFoL/SQibS0ZIL5YhnSd8nKzmw/pKZldkj9TN/wnKRjHCM/NO4cihfjw5z
	m1RBbvmEZ1EugwCiYZYH9SxbdZOFXmkGWDS5XhvAMrm4/a1jXi6zNW4KdtVl2o8M6WDCybKtSpz
	ov7W7lh0d3RZVGGeIe4bF+KUEuuHhZrv0D4+BxUeYeeFyziTyTJlCtBzNpt3It+CpG/Y=
X-Received: by 2002:a05:600c:46c5:b0:45b:8477:de1a with SMTP id 5b1f17b1804b1-45b8553f190mr114776365e9.7.1756891332345;
        Wed, 03 Sep 2025 02:22:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyTITMyA6nVzMKbQzFQh0ovQa5Cva0N2A6qZKj+3NSqQ+k4TdT5orYCpErVlCrii0lBjSVnA==
X-Received: by 2002:a05:600c:46c5:b0:45b:8477:de1a with SMTP id 5b1f17b1804b1-45b8553f190mr114776085e9.7.1756891331912;
        Wed, 03 Sep 2025 02:22:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm231483255e9.19.2025.09.03.02.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 02:22:11 -0700 (PDT)
Message-ID: <99f8cb5e-828a-444c-b207-2a12e13a45f5@redhat.com>
Date: Wed, 3 Sep 2025 11:22:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
To: Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, kas@kernel.org, willy@infradead.org,
 hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903080839.wuivg2u7smyuxo5e@master>
 <0a52cb54-5633-4374-baa5-199194dfc2e1@arm.com>
 <3bd9ff5d-de8a-469f-a7b0-41c192b23993@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3bd9ff5d-de8a-469f-a7b0-41c192b23993@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eK5dPVY38BCABoaSBpsu1ZLZEPTNbRHD5N95zZo96ak_1756891332
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4929018000E
X-Stat-Signature: m8k5id7nbx8h9u5z6ayhg4oaj9mp1r4c
X-HE-Tag: 1756891337-324663
X-HE-Meta: U2FsdGVkX1/dALdVt4w0dISlFw+/pgVblsSuQkhZGINyn9rNXyeBKM0rV4eay6OixVXzzTdmU2Pdrr+3TbqdCFXZG51kCApZCRZUhzEJDdzZ23Lb90AXiZsP+JS6Te3u+vLly/TnvgqK+f4ilSsDHMcseO2jlVD+s5lHtfXV93h7/y8DdfG94+p4sJFI+bHGCETXQdVgGRVq+wpBd5pKWByjfXeZpB69Sb+znnQ0qiC4+/px8JVOtKyOJL4cMc46iuDcSHF1mThodzKZ+VmvB1s7uUlhq3e3ZWoH3WGcn+b2VNpPIehWY5CGpqZc1VLy7Wg9bkXEWHvq6PtBMQzavZQozjjj8DaR15BudxWcg9YEQZKXtBsnfCtTy9Da4AZOss1HXVByo9nzSBZ0GyV5SySHea7+PgexkTHriAPnkSRFO/ATNxNGOxawF+GLzlyXv1eDqw8BRYfBBCiXejmDLo9CeUl38VCVqq19XudRicz8qroK2IT3/BkQnTB834paF8ZvV1pu2Jr0+byJPYy6HfEcfniFBM50WeaeQ15tgNr+Sr1ZGOtZp9Sf1+7kBu8drB3zTPy7n6TIoiTcTRhz7IlS0p4ja2Cal+DyEfanXoLcNuBTfIBscKEY3bjI7a6TjfFOCRDmfy8mM48TJnM8EGgqcsenzCxCvo0VuBOuHFDnYGuyAxmFu7IeGkjDIfUhUnmnZWDt2qJZAxr9XQbebaH9pI9/svQObvV3opKv9w/R2J1SJXQG+sTNCSBYLzb4TVMdj9MmOt7Uc1HJv2qELa7evP15Y5rz3thXH+I5NtIys2lwZyRZ7MQ59QW9/3ZoRdRyNRQl5uqUF7hn8fewk1nYdBvuA76Yk7Ci0bhRjoMSCBq0tm9OxI3ua9XoQJqhC/OmUyPTMqUrxCy0KBHYCW0lr8nJtRKL0huJId8z7KUrEjLWNNiqGgGTWonjd/DzAqEM1R/kHmr5jzMUefi
 dCEVLcqb
 oGzvp26B4fALDEHhmiWiBCNP7jQLsDxbPhsUFTYnjaQcPCNNdj9n6GAP6GOFJVn+nkNxXbF10378L45gSrbWVJ85LkuyFUkTQlnCsSv28VWyAFIO7Zn5vFthHoJgnekeHrqnuc/OETuHtWVlSWmDms1+lHQ51w/XGE6i+g+b+Ka5EwsYD7nkBXaX10bCiKcLruyoJFveIl+CMfYu3X9Z/ZAmP4CLP0HviTx1M/S25MGsyooiZ4ZZuIurmBWTHfteeyqIy+JZjSUF0uTq1L8mcrk7KWDjAkii6RICF+jbMzkJO/f6rSf/Sze5ZDhhDb9yM7oKeZdMT/mYVccy4S5AKzmwET2zvM+iblNceZJae5L+Xr5SH2g/hNtbSH7tNnQOvjsh2Mgij0voC8doTPqXSR6DIog9x8/P22IToUaUtEArDs8L9+6irBzDFbVu6bo00xQ5xF87h4fRmC+7oJA+hUviELSTnWpBFD+sWGKLATHj6x5cnr0nJKMnkpNAbbs+GAb5HhGzPU9DM6xY1MMrc38BoE+B+mkzQhBGY6YEjFs23BnsT2N0VQ9Tql1Susfzk3CfKqzR3894mkgX4vkVGMbBGq+bFh1TPVfwSeY707N/2tAigcR85U8tEsn6wpfD5791TSFNvtLxB4xp8FW0O7VIn3vjtT6jOoWKHNzbNi9FLShQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 11:18, Dev Jain wrote:
> 
> On 03/09/25 2:45 pm, Dev Jain wrote:
>>
>> On 03/09/25 1:38 pm, Wei Yang wrote:
>>> On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
>>>> Currently khugepaged does not collapse a region which does not have a
>>>> single writable page. This is wasteful since non-writable VMAs
>>>> mapped by
>>>> the application won't benefit from THP collapse. Therefore, remove this
>>>> restriction and allow khugepaged to collapse a VMA with arbitrary
>>>> protections.
>>>>
>>>> Along with this, currently MADV_COLLAPSE does not perform a collapse
>>>> on a
>>>> non-writable VMA, and this restriction is nowhere to be found on the
>>>> manpage - the restriction itself sounds wrong to me since the user
>>>> knows
>>>> the protection of the memory it has mapped, so collapsing read-only
>>>> memory via madvise() should be a choice of the user which shouldn't
>>>> be overriden by the kernel.
>>>>
>>>> On an arm64 machine, an average of 5% improvement is seen on some
>>>> mmtests
>>>> benchmarks, particularly hackbench, with a maximum improvement of 12%.
>>>>
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>> ---
>>> [...]
>>>> mm/khugepaged.c | 9 ++-------
>>>> 1 file changed, 2 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 4ec324a4c1fe..a0f1df2a7ae6 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct
>>>> vm_area_struct *vma,
>>>>              writable = true;
>>>>      }
>>>>
>>>> -    if (unlikely(!writable)) {
>>>> -        result = SCAN_PAGE_RO;
>>>> -    } else if (unlikely(cc->is_khugepaged && !referenced)) {
>>> Would this cause more memory usage in system?
>>>
>>> For example, one application would fork itself many times. It
>>> executable area
>>> is read only, so all of them share one copy in memory.
>>>
>>> Now we may collapse the range and create one copy for each process.
>>>
>>> Ok, we have max_ptes_shared, while if some ptes are none, could it
>>> still do
>>> collapse?
>>>
>>> Maybe this is not realistic, just curious.
>>
>> Misunderstood your concern - you mean to say that a parent forks and
>> the children
>> VMAs are read-only pointing to the pages which were mapped by parent.
>> Hmm.
> 
> I meant to say, writable VMAs with wrprotected ptes. Maybe after this
> patch, people
> 
> can finally make some real use of the max_ptes_shared tunable :)

I hope not, because it should be burned with fire, lol :)

-- 
Cheers

David / dhildenb


