Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70693CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4AE6B0008; Tue,  2 Sep 2025 04:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C5C6B000C; Tue,  2 Sep 2025 04:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B368E0009; Tue,  2 Sep 2025 04:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A057C6B0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:26:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6847216081B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:26:16 +0000 (UTC)
X-FDA: 83843627952.29.D404B50
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 100A4180008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:26:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IThPTPjl;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756801574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NT4cL3IBvSM+KsAgVhY9PNAtIvcQOi6uIxGIHK9QqtY=;
	b=pH85RaLnpPpW2naEV3m82PuNupCGbrbn5b0YhwhB27fXdpUsjbX7P2ULYFiaMztnUzAjQC
	FSgRFCZrovgZVX6f3cT6y4hROlx3YCDkujmXAAFvzzl15fFSOzaB6Y9WaDMQVMDfN5Ufso
	sH5rRN6hgQks45gp6ov/k8bm3wcL2TI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IThPTPjl;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756801574; a=rsa-sha256;
	cv=none;
	b=UihDIQkBdVGtRgRrgq5p4pBl414x3H5ceCPUsP1ui+IKmnqmVRtbtbTLGauiqVpqbKAAY1
	gN6E4Brw6aDx14d+BuN6JTpZXVsuisKTp04/8Bx6OVCAJ+w1u36QaqyWk+/tQJCBMOFTQH
	Q8Dm+EKeX2+4KekBuwhNtakb7c3Yt/0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756801573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NT4cL3IBvSM+KsAgVhY9PNAtIvcQOi6uIxGIHK9QqtY=;
	b=IThPTPjlwYSKsm90MeQZPiNXrOLvoRY/TfTYBNGeK39ESrZwIYQ9JaIXC4BZLZmJmO/DQy
	FNBSxBlU7/m8A3gZFU36OgeX45NvHOkEp0JYB20zA8Qf1WN7tyrqJZnLzwWQE3PmbI9jDA
	XGSMbpAEKnTIk425jPAWIgDFr9ZsBfU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-uWY0WpmDMFmhOswqND4nOg-1; Tue, 02 Sep 2025 04:26:12 -0400
X-MC-Unique: uWY0WpmDMFmhOswqND4nOg-1
X-Mimecast-MFC-AGG-ID: uWY0WpmDMFmhOswqND4nOg_1756801571
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so2417115e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756801571; x=1757406371;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NT4cL3IBvSM+KsAgVhY9PNAtIvcQOi6uIxGIHK9QqtY=;
        b=TVwPeVZyuDemyxrg71AIx3MHEK/cidCdMCFnQxErj/GrQqbUag7ahyBAhxoi9qIaWB
         1bVFYUBftyhZ718Z9Mf45D9L8091z5td1haikN+T6gcuyd3nOD+gABAoBuuYObjMjxA0
         A2VVPsVECMIxvrDe+dRYeHvWX32tinBTv8VAmW74RP8fMhWQJOWwM8hzyJl6J0Ho3h0T
         Uak/PYY6fNSEKQYKDN5V2nFVGxByHwggWSJuLXJqGITZmaHtbe2sZ5NACyVxRevBvAOY
         68KWWP+fUM59g21Y+7ZrhJ71tNP8er9LDmIjqG99RQFxuZZZQWffWBrlP3ihAST9G6rg
         E/iQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5vEgBmd+PDYyvHWl4nT19tqDzNINl+giPf4Y7sU8hS7chyF4okTESoT1JRlDj2s/SxOpTe9EY+Q==@kvack.org
X-Gm-Message-State: AOJu0Yxr9i9gdhf2BZETSb6zWBM+9GeSOzxw3iJvOOA/Ou/Oh+wHpT1f
	Dr/7SU5zpMUN8iZfoiCPTHJdYYxqB9cj27yCymmOM7QW/LdzHetL2S0WwElMi0nfmAijuDsijkZ
	NuByTs3iLVU1cr0MrY8jaz0QDJ4/G7pPbVZZm/VGBlaKSpz8bgvyn
X-Gm-Gg: ASbGncsCHVkQjnrybwD6LQpKQ59Oy7NeGPyP+fVW/CEcaQOj0cgafAEd3cqZzVn+bHH
	KKvY6VCoMRlE9TQbandQZMAgqY/LnIbkHkrv7Hix/7fkC4nibqxuEWjQApUtNol1FqftCq+ENrw
	8/l3EpH5nmCNz99BPc0qhpr6RTneBz7rejIlq65ta+wjB9uXSynnQcvX8xPlprEmvuFtn2vw+b+
	sO/3rccHR2OGekygMwmmqxtjmIFEsXjkua9+3aGVZlgoEMRKF+zFGrmu6EIAm6Ts20sMg3ShATN
	Krjp5F/oUBO++miWDUs8h9+pkFyQ8DpEhR3F8nkUBbnpRUJQaiF0zgW+BpsYReqfkrKqA3VfLw2
	3AlZD0KGByWKyVz1tFLYHnXcg89Mye56dsBMAW8nH7CM5mrKJQwYM247IgWkbZXchw+s=
X-Received: by 2002:a05:600c:5303:b0:45b:86ee:415f with SMTP id 5b1f17b1804b1-45b86ee43ebmr82879595e9.6.1756801571121;
        Tue, 02 Sep 2025 01:26:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHM1cxF4JIXl8kNx81ZZuv9bKqY/543YOwc/dJB5l0AuAAHxnmf034l5+/Y8FWgJjfldXBlOQ==
X-Received: by 2002:a05:600c:5303:b0:45b:86ee:415f with SMTP id 5b1f17b1804b1-45b86ee43ebmr82879405e9.6.1756801570675;
        Tue, 02 Sep 2025 01:26:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7271cd01sm259793375e9.23.2025.09.02.01.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:26:10 -0700 (PDT)
Message-ID: <0c163e18-3684-4b1a-b379-be82fdc288fd@redhat.com>
Date: Tue, 2 Sep 2025 10:26:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
 <20250902081632.mopnwlt3stpijejj@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902081632.mopnwlt3stpijejj@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FLtWE5ssTKXgzFQ6YSE9bjP7oN9Up1fWeGOkrTIcR_M_1756801571
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 100A4180008
X-Rspam-User: 
X-Stat-Signature: 4891cwiymczicrzzs8urw17jgqek731a
X-Rspamd-Server: rspam09
X-HE-Tag: 1756801573-576087
X-HE-Meta: U2FsdGVkX1+5fjMQLdm9EDUtTyUDrV6JY2yu50FbbVRmvZfwdCIjwBwUksNpBddlvn36vAr4YOfuuCZLpSJN9n7julkFx3aDUqdaOnQC87PxyA2qO6LRTptaDUPaHOP+Jz0gur7D1wZkpjGr6/71F8QqVzWDsVTACl68eDew0NMK/RNsNOeA8iltRYbLEvcItAveWc9dKO0mCltrNlhvjJILM11DCpnS/QjIWUj6Z7JyNzafv375Xt/tUKEQ4a3kojb5eOYRVDHDf8M8cH4ykFvADIpGZ/BEEI/J/MXAZfcOfiE9y9rLEEGE76wrpMdi50nj/WFOuxjJ7j38L37le4O/MO2xXD07DhRhXutkEMeUGdFAhwHdQ7rXbnl13v9jAwxPlnRKf2J/yR4Nb26xa5Pu83fODek6sXn4jSSeZ5MgH5vGrhwMKKPGqYXhFQGTqxVvn50X5ybog4VZO16i6/L/nPvJpDKSZ1MYjUN4O4F30cDQ5mJGftgsqQLP/oHi1uJGSTA6TeZKsQIIOJVWdZNj//+rzC27Gh2ufftbGr7ItNqShQKFXrsKM3/MNQ/O+OAjR0EbfQqgwclN9E92Xz5moYvG015jnqqUKaL2N54O2nQDNgtgt65v07GdzmalJ9JUO+RlqW5qJh1LNm9hER4qJ54hW5443H5ocofXPa6dasW7oOkeDnUV7KIhtj3AgRjjU40rEuSDlQdxhX+Lw9uO7BKJ1DqMy72P9geCHSgydp0J3lOcbdgNGKFPghI3CRQp6rQg3avxX1CDgt/fFWuxeyJjtE9cB21xinjCDosCnAr0G162poslHfwoovBhsi0xLM8ugDUfSwzg6V1OQWbey8mYH85DViaS43675WBTfYcHToyxpyVyl9XwsDqFl+1lJKpoxxLCZkMVAlFdf+us8PC+YZXrsy2MHe4QgI4m6RLb0x6ja2vLyLKvZlAfvIKQJPQRGGJsM7vA2Pv
 kde0+6tR
 gNEvlq3r98JHsvYEXwCt+fIzzWiYHj7yUKv+A7PgoEM+je+1x3XIeJHlzmJFgbE2pKueZYanUzpwVHF37d0c5eadqZZxgmu8pzvcy/Vlo1a3rd2fOP10TH6jpodjmHMiqi88bKFpmVOa1wwp62SAo9rLxhB/hFReg2LUxQIUkN5lZkFRNVRie0u8svqp3gNCJeYsCno0Bb6vvFEZ6y+xuAVG571rKOho2X97K64cObS4lj5GuZ6ZiarOAm+qqc2L/k5nmPHqiBMYguXmIRTzulFXYS8YaKfWZqlb6F8V1oKETV8IHyDUDKggYJPLan5p5z0hfqdyXdWTJ7LgCO4rTPkl0ld0KCBHyuD60xzhpN/d6KWbbgCjQc3st7RURoLaWRrXT2bmQlNtTgZnnWsH9DehJ1DvVeA8541H4Nca2IXXsqrvaIR7uDbrtrYFtRyX/71PejCpshf+6UNdBeuGTqwdcgnQ20E9IfxKxRNnpLTpWxtIcU5ElCkCRjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 10:16, Wei Yang wrote:
> On Mon, Sep 01, 2025 at 09:10:57PM +0200, David Hildenbrand wrote:
> [...]
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 10ae65ea032f6..aa0f0502efa06 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -390,67 +390,88 @@ static void split_pmd_thp_to_order(int order)
>> static void split_pte_mapped_thp(void)
>> {
>> -	char *one_page, *pte_mapped, *pte_mapped2;
>> -	size_t len = 4 * pmd_pagesize;
>> -	uint64_t thp_size;
>> +	const size_t nr_thps = 4;
>> +	const size_t thp_area_size = nr_thps * pmd_pagesize;
>> +	const size_t page_area_size = nr_thps * pagesize;
>> +	char *thp_area, *page_area = NULL, *tmp;
>> 	size_t i;
>> -	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
>> +	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
>> 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>> -	if (one_page == MAP_FAILED)
>> -		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
>> +	if (thp_area == MAP_FAILED) {
>> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>> +		goto out;
>> +	}
>> -	madvise(one_page, len, MADV_HUGEPAGE);
>> +	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
>> -	for (i = 0; i < len; i++)
>> -		one_page[i] = (char)i;
>> +	for (i = 0; i < thp_area_size; i++)
>> +		thp_area[i] = (char)i;
>> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
>> -		ksft_exit_fail_msg("No THP is allocated\n");
>> +	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
>> +		ksft_test_result_skip("Not all THPs allocated\n");
> 
> Not sure why we skip here?

We usually don't want tests to fail simply because our memory is fragmented.

If I'm going to send this I'll comment on all changes in the patch 
description.

[...]

>> +
>> +	/* Split failed? */
>> +	for (i = 0; i < nr_thps; i++) {
>> +		if (is_backed_by_folio(&page_area[i], 0, pagemap_fd, kpageflags_fd))
> 
> I guess we want to check (page_area + i * pagesize) here?

yes!

-- 
Cheers

David / dhildenb


