Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78079FF886F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11696B0095; Mon,  4 May 2026 09:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2216B0096; Mon,  4 May 2026 09:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8096B0098; Mon,  4 May 2026 09:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE3346B0095
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:05:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8956C1C0242
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:05:07 +0000 (UTC)
X-FDA: 84729757854.30.63D0A99
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3256440013
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:05:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Uk4MfaOc;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777899905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCpIucwug7LQBxR+zBCSrNGWbfwlTlZlRpoANQyu5ws=;
	b=h8u+Y5gE6VW8qaUl0viwEKI/fwqh6HsmynvXLFkEagvQy8qziWvNahvRwS1IzAcTlnf2zR
	JMPSfWcRUCPl7Fd6RdgsKlGU8VFd1il731g2G8h7+8TA0jgROv20Mkfe0week/Defhi2vI
	skLqB/8j6lE050sTtOMkcGGa1owtKkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777899905; a=rsa-sha256;
	cv=none;
	b=2sz4R3WbJLiQDIDl7ZrvSlHX/Zs43h6MrTwtKt6+cMp0GwR38ESdF9nKAnyJeM0wjH1VyF
	3AZkC+4P2YIH3/5IwgMaqzhnclrDu9LGjMd+j2q38Zo76ufUlQTf2MVHLAxwgTXuDQs5P0
	4GZt/yzfEXHpdKNs/vkCGR2yWM8wsvM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Uk4MfaOc;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777899904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCpIucwug7LQBxR+zBCSrNGWbfwlTlZlRpoANQyu5ws=;
	b=Uk4MfaOc6YGOaHUHKnl3JLlKxZIElpEQRjv+wt84fkbcc2KXJDJqFxI/NscXiG8IX3weyj
	yVWHg6VaGoTwgEiNDLnCU94kYcz+TL7KR5D6ZIza3YDirzPi831KmTfAH4Ipi6R8eCVpba
	NuZUHNUtH2kIeJSL6MORsLB8ub0+2SA=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-SeLHejR6Nz6xvRdCGBW9vA-1; Mon, 04 May 2026 09:05:03 -0400
X-MC-Unique: SeLHejR6Nz6xvRdCGBW9vA-1
X-Mimecast-MFC-AGG-ID: SeLHejR6Nz6xvRdCGBW9vA_1777899903
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-423133d22a0so9271232fac.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 06:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777899902; x=1778504702;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lCpIucwug7LQBxR+zBCSrNGWbfwlTlZlRpoANQyu5ws=;
        b=MMhP9p1KyfBZRA0ZStWFMSlOY3CF2jUQl5/H9K3UqpI4CO2xt/khonJkhc7psje6Ml
         IZmDJm0UCIzF4HJcSOfUDgp6dRWG+9PGmNDH9ICJ0BZisGNIJXjUJ+j7znqNq0RIl/VV
         MFDpkgkDJW+VoHbgfSdaxOqCRvhOH4wDJrDk1lgagPOdviqxc1ZGoaCC7dVowjYaHL1T
         4s+zzxa2F/0PEfJ42n18rgEPUx/V3RTgNDmtnMdiVZH6E0/ZJSnvJTa5i2C3KpiqZ6nx
         h7eMtc7rY2HXJKB4tx1XjjLxO5+oe7sXIidU5ER92v5HdR42nDnv4hyV4ZIM/H7fcJIh
         MWZQ==
X-Forwarded-Encrypted: i=1; AFNElJ+rLqhhgEJ7vFjtHAzIx+9eXFf65hKV4wCEWuVK3sbrwuV7J7ibY+itPLEDiDm0BhHXc+O0Ox77rw==@kvack.org
X-Gm-Message-State: AOJu0Yz7bajRVUDrJgQE4BPLICDshpzz5eCgPPAkeoLv8Nn43fr59hp/
	uklLhMtEC7mYuaLFakQYh6pYnliulXcmO+3dLILuY9U5LCqOBGpt0CHOWvjCVGH8ByDJi7Nfh/J
	AqxPFJa/KbDQ+YVm2JA1e/4quePpzPlkfiP0fDiARK6iU8T5O3N+x
X-Gm-Gg: AeBDieuN9IV+qYzZoD58KTbHJYojcV0NGlHRHoQAO82N4ZIIthpLYqDR5dn+9BLr5ji
	jI40M/hnU4ZXab6YS0Z0ixU1lKHKwYRj3GhoCjlwa6NfcEwesHfPqqYpiWKTswyDDUT8j0wTASd
	4OcVXSZIlKztvJLar5JiHrJqW5JX0XN5rc9ja2MAziBy/cdhwrXi0YBpmTRcEHewhOgV5TYyv0U
	+c1HL9lOjF7wBt48SnB5gPcMMwjJiRCEhE76zaJ1NhFVAaIxdr8jyGmh/lqqVbAEosTztUxBx4g
	BHpgcEE3VCi0Lu/5O+TwCGumaE9Li+IE4NkD94h/DKUejxys5L1qT5iK2zUf46PMq5hxT9RCO5u
	weCSaKsoq9B4usZqldytYLs9o9Wg73CFYZvE=
X-Received: by 2002:a05:6870:1687:b0:42c:259c:6c8a with SMTP id 586e51a60fabf-43475f95c61mr4835386fac.6.1777899901370;
        Mon, 04 May 2026 06:05:01 -0700 (PDT)
X-Received: by 2002:a05:6870:1687:b0:42c:259c:6c8a with SMTP id 586e51a60fabf-43475f95c61mr4835140fac.6.1777899899273;
        Mon, 04 May 2026 06:04:59 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b5e8b4sm106472551cf.23.2026.05.04.06.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 06:04:58 -0700 (PDT)
Message-ID: <a393e215-ea5e-4b84-9066-4afef36489a6@redhat.com>
Date: Mon, 4 May 2026 09:04:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/54] selftests/mm: hugepage_settings: add APIs for
 HugeTLB setup and teardown
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Donet Tom <donettom@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-28-rppt@kernel.org>
 <2f443474-4448-462e-bc1e-55bc657d70ba@redhat.com>
 <afTF9RCy8eBoWYaj@kernel.org>
 <22b1cadc-4b0d-4e2a-987c-e7a7bc2265eb@redhat.com>
 <afV_WAK56lQKn_z1@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <afV_WAK56lQKn_z1@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6RiITmpGYBx9PIktGjZ7NOCZGjePdbhve53KFwZhQAA_1777899903
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3256440013
X-Rspam-User: 
X-Stat-Signature: k46dmwcbthc7jb5xft63dzs1hu458auc
X-HE-Tag: 1777899905-785815
X-HE-Meta: U2FsdGVkX1+23dPhZLqgU/wa7imqtlELXesPaUV2+9/ftX9m8b2ICf9LR85H4cZDpKiM+seGr/yIoAGjGdlu3caYjrLD31gTrU/GmM7Vr009SDFq66Z2/TUjUJbYQyRmxhoQT6nd1zB99tUQSIcEGHdnbStA47It+zrml4+sCn9UGOLwU5/GKNy1GZ9P+Ds2gGTL2gOTWsmrrZXUOW+zqCI/yONMduJCbsaS6RS5Kl79NQSEIMhujcp8sujAJEboIOa6ul3W4Iq9nJpmVkZEiwLwuwUYw6uv2x1K6s50NvgNjjb0p4K5ZTiwr20VRjQ29tRmgh5ZwvXfIt8daFXsB95vP5jvu7guVVxe9zX7lqmYX+oxhuqCK041LkkMJuvu4Ee05U+7SD2d7ZC+77DOUQ8IZOh5l7Zm6gGDunP2Ii+H//3siIvnJGu8IUYpheqxO4doC/oRTfzhR2y/Knv+iI8O8n4AMXJ7Kaxcojc781rJsKLdIATqJn+LFN5sI5wtQIwi+i9jK/rRrm+c0U5RUt4WrEAi2z6bCCow3a/5CzIP1TmmFDQSbjDe6vOqVofcl45VcRL4vMPrgw33N8dY9y5fkcFQ5cpDJSXb10iHtBE/QPM+bC9YblRWMX2ugKu/TOiSYn2A/Ws+2xqQII3cb6Re1ieb8BVCzRhJF1ShBIMD8cfvwW5v3luvmELZr14NFuG2UODy3IJqyHG5fjWgguxlrasDrJTGeC04RsA8LINrvShdzTHIfIVo5TYJPq8grUTutHy8uzVxQGfow492I01yYuWCgmJt3DAl86vNchkwfJiHfyIGV+PU4BCZVkD/2HYWe00cgwROleOk4/amux/kbboTgL5+QhVxdDhrDPcQJesAE2upr+u8B7ex7iGJmKWdXIHdHe2Byq1O11MqdlRi/t3VTJX9eIvHx5tCN8daZ7PmCJl7Zn9CTma/VvtoQkMkL06ZcSTgF2wSkfG
 UA7ZfKWL
 m9nxnZwraZwJZWRtC4oKY1VqZKzKU39NGbC+Cx0PPQ9Tnbq3YAghHCQgXQkLnWOWnF1qLevHPcdvWOFARD5M9kGUE++ndvidEMeWKfyie7CMC3n9gCyjrihWHhyE/rBLfnxFd3YE3dCNPQmzY+GPorbMCsg5R/RxIsapXT6SyWbA0gcgx3ui6/pVJjO5FN5bDvceIX0ABdRbw/iN4ntzpBCGCg9uBxGmcKiKWG58yg1XqA4mZX8+e2ZnrxT93+JNiWlFThVHT/Zy5579UvUcWfKycGxGd5bzFyOzuU3a+xHP/x72BqPKcFePxHkdXRNIlownKI8v0gC3vB6vJNP0AG3zMQUuhD7amKzdLEhg6g/P3EADU3YlKx6/aG8mUfPKr6zC8M2ijUZnk8L4u45iJ6h9+Kr1r5nFGRg7+iAZjXko6hKAa4DeYHwhpmkm8c0g2bRyPxQ+0GB3nzwAjT+fGMrH1dMfp1P/4s9Iq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-02 00:36, Mike Rapoport wrote:
> On Fri, May 01, 2026 at 03:30:18PM -0400, Luiz Capitulino wrote:
>> On 2026-05-01 11:25, Mike Rapoport wrote:
>>>>>     	return mode == 1 || mode == 3;
>>>>>     }
>>>>> +#define HUGETLB_MAX_NR_PAGESIZES 10
>>>>> +struct hugetlb_settings {
>>>>> +	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];
>>>>
>>>> It looks like we don't actually use this in the API or maybe I'm missing
>>>> something?
>>>
>>> Yes, it's used only in later patches.
>>
>> I don't see it, the patch below builds fine (again, sorry in advance if
>> I'm missing something obvious):
> 
> You are right, I misunderstood you comment and I thought you referred to
> entire API being unused in this patch.
> 
> free_hugepages is not used and it should not be a part of the saved state.

Thanks, I'll try to be more specific next time.

>   
>> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
>> index 097ba085f423..a023cfeb69c5 100644
>> --- a/tools/testing/selftests/mm/hugepage_settings.c
>> +++ b/tools/testing/selftests/mm/hugepage_settings.c
>> @@ -341,7 +341,6 @@ bool thp_is_enabled(void)
>>   #define HUGETLB_MAX_NR_PAGESIZES 10
>>   struct hugetlb_settings {
>> -	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];
>>   	unsigned long nr_hugepages[HUGETLB_MAX_NR_PAGESIZES];
>>   	unsigned long sizes[HUGETLB_MAX_NR_PAGESIZES];
>>   	unsigned long default_size;
>> @@ -509,7 +508,6 @@ static void __hugetlb_save_settings(void)
>>   		if (!sz)
>>   			continue;
>> -		settings->free_hugepages[i] = hugetlb_free_pages(sz);
>>   		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);
>>   	}
>>
>>> I felt it would be too churny to add users in this patch.
>>>> Otherwise, the API looks great to me. But if you allow me to bikeshed :)
>>>>
>>>> I think I'd do:
>>>>
>>>> struct hugetlb_state {
>>>> 	unsigned long nr_hugepages;
>>>> 	unsigned long size;
>>>> };
>>>>
>>>> struct hugetlb_settings {
>>>> 	struct hugetlb_state hstate[HUGETLB_MAX_PAGESIZES];
>>>> 	unsigned long default_size;
>>>> 	int nr_sizes;
>>>> };
>>>
>>> It might be slightly nicer abstraction but ...
>>>>> +static void __hugetlb_save_settings(void)
>>>>> +{
>>>>> +	struct hugetlb_settings *settings = &hugetlb_saved_settings;
>>>>> +	int nr_sizes;
>>>>> +
>>>>> +	settings->default_size = default_huge_page_size();
>>>>> +	if (!settings->default_size)
>>>>> +		return;
>>>>> +
>>>>> +	nr_sizes = detect_hugetlb_page_sizes(settings->sizes,
>>>>> +					     HUGETLB_MAX_NR_PAGESIZES);
>>>
>>> ... this immediately becomes more complex.
>>>
>>>>> +	if (!nr_sizes) {
>>>>> +		settings->default_size = 0;
>>>>> +		return;
>>>>> +	}
>>>>> +
>>>>> +	for (int i = 0; i < nr_sizes; i++) {
>>>>> +		unsigned long sz = settings->sizes[i];
>>>>> +
>>>>> +		if (!sz)
>>>>> +			continue;
>>>>> +
>>>>> +		settings->free_hugepages[i] = hugetlb_free_pages(sz);
>>>>> +		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);
>>>
>>> And this as well.
>>
>> We'd need a little more code to handle those cases, may or may not be
>> worth it. But enough bikesheding from my side :) the series is great as
>> is.
>>
>>
> 


