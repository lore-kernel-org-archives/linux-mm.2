Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A86CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1AB38E0003; Mon, 15 Sep 2025 03:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1F58E0001; Mon, 15 Sep 2025 03:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08728E0003; Mon, 15 Sep 2025 03:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCBEC8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:32:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58D68B9A9A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:32:37 +0000 (UTC)
X-FDA: 83890667154.20.BD80A09
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id E8AA3C000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:32:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dYli9kSt;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757921555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAbPh1a5baGVSu+RJeevuoCfQtg1HT4gp6QhkNOLtQw=;
	b=m+ansg1rVHq8qwnlrbHCrZTXdBHnuKuF3lHcR56mMiFL4I51mimevOBhnN2lKGo9eMzRof
	W+2Ftr/z1nTIINfNdPHppAgc3LEtX1Lb2HRdym7HF/K6No8lU+D3rbFhxjhUtLqdn7ISPL
	MUdBxgrZR3zoy6fD+HGX6Tqe/k8XDVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757921555; a=rsa-sha256;
	cv=none;
	b=6lhxwUII0QRHRrRCqh/VDrMVZhG6SDNT++ILI6Qdg5PnhgmPpjp7eEhyWGCMlK1FOnCad5
	21yOYmEWWYqxqruLbFnW4ggRhT3cXlwDQjXamOXkbiOFajBcXN1RnjG9jezrKZi9GlsBSJ
	nxKBoDzyozfDBCxqFcWr8v++WbcmBTI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dYli9kSt;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757921554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jAbPh1a5baGVSu+RJeevuoCfQtg1HT4gp6QhkNOLtQw=;
	b=dYli9kStnWk93UAIf37IN/U8My5kpbe0ipRmL9ljdNAudyt5S8W7YZtriP9cTBd9KqHJcP
	/bexduVjiknAsi+iHPc2gUZSzw3SqcRAYx6fQkXRoVz/YuL5duV42ltSc03pjxZBAxHSj/
	CoYTQmPhCOxNRhHwXLVGiqp458181Gg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600--4xpmnMyPombRSwkYax3Ug-1; Mon, 15 Sep 2025 03:32:31 -0400
X-MC-Unique: -4xpmnMyPombRSwkYax3Ug-1
X-Mimecast-MFC-AGG-ID: -4xpmnMyPombRSwkYax3Ug_1757921550
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3df3e935ec8so2087530f8f.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757921550; x=1758526350;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAbPh1a5baGVSu+RJeevuoCfQtg1HT4gp6QhkNOLtQw=;
        b=P/lvVv2NTQXlquxy10QBBjnsWlPOx2ZpEEpkd/+HNf8/tHPZTlglpZoFqvA5ZCG7/o
         RZWWiXIr9hZSM1jiXSJ7xUJmBV7uEc3iMfBbh00JlK+azjYf7rkn8cvC/RT1mwn86W0S
         2jL6HG9C4lDOQkx2+IwWLkKq2Vmj+jjI2YjbwG/50UF5MiZmj+MJP5qQ3IXZukPEYl//
         Poj3fSv7PHpPJiMVb4kh3EuafiZcgcNvVbCAbkdoQcLwONpbeNjEsLhlyT/NPR9+b14V
         s17JP34Gv6BK1AcTY/beuECZ+a1w0m/1yYhaY4rr8q8055Ask6VNOIqNULOvJWiVqKch
         09/w==
X-Gm-Message-State: AOJu0Yx+O5PC8+DGhFp/L3otpgWlAjXvw97HBJqSTC2++/jzZ2P+/3OF
	ov+igp711kvkwnvs5vpnrYo7MvydZKgtEfQ0PDzz7InUZR/DynWKyn/3zD+Uo35nS8g2U4oOj+u
	YdBq/jby07E2iHiigHmjZD4XQ5fxxZcUtnLIHZmYGSwGPoauWMFwl
X-Gm-Gg: ASbGncutvpcgZ7ypH2jgUV4WqjdSUhMmbcWlIJq40Mjq89k3zJYPOp3bZedzIF2Mc1j
	HMn8oQ3K9qAqxKZ6NuNTq29uuDhEfDnLlOejkagAt5pyQAVdDxmaxIZbNdE7b0NRhshGosarMn3
	gxtWdrNO0WYFrEH+h5K0YVW5NXpvzNpAAzR6th1QG89NnIWcT7ccNubTqQ8qpW6ClC8lEuJMQ14
	uVc353ntvaYQOitwzMxWf//Hb0qBdY5318q0k9Buli/1O8MXZly8G1QjrmGTn/FNarMUx2W2ub5
	7U1wW68k2Ahqpa9/Y9g7qwKQdx9/yL3scN67fg9PHSc5OiGN/oOVjnHDhRl7O7m2KfCLl/diZh4
	BrC4lFWn5Rys/pZu9NibzeC06aqhgaCONDVS30FoEFneMfjPQGHifibQ2+RDqOH1NYAg=
X-Received: by 2002:a05:6000:4026:b0:3da:37de:a38e with SMTP id ffacd0b85a97d-3e765a3d9f7mr12086527f8f.54.1757921549878;
        Mon, 15 Sep 2025 00:32:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLXhVOZLVLWPoIDNm6PCIMpCLkLEUR1ZovqbAnnr2wpuDYH0528VDTPu4VwH/oWQsFGE8DvA==
X-Received: by 2002:a05:6000:4026:b0:3da:37de:a38e with SMTP id ffacd0b85a97d-3e765a3d9f7mr12086489f8f.54.1757921549402;
        Mon, 15 Sep 2025 00:32:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e84de17f9bsm9513768f8f.49.2025.09.15.00.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 00:32:28 -0700 (PDT)
Message-ID: <e368ffcc-0de9-4c8c-8e9c-6cbf8cdd22ee@redhat.com>
Date: Mon, 15 Sep 2025 09:32:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, chengming.zhou@linux.dev, ryan.roberts@arm.com,
 baohua@kernel.org, xu.xin16@zte.com.cn, dev.jain@arm.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <3a1adf4c-9931-4cdb-a024-37c856b1702b@linux.dev>
 <20250915014738.slkw4nwihb4aavas@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915014738.slkw4nwihb4aavas@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9afZRJvSEe4-Oivyf65kAEbPVB5A6cJUe4Mk2h4j7Q8_1757921550
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k6whypsto58j6iqsm4mpwj7y6gegb7cn
X-Rspam-User: 
X-Rspamd-Queue-Id: E8AA3C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757921554-63335
X-HE-Meta: U2FsdGVkX18pS9Ac5ofmoKvtPIxFjddECORDZsVfEixfY4Kb1M30md1WfbBBLFVYaPBkcNd6ar9PIYEFtwjt46r8el4RQioQFosIjAJ9r0XOEymE/CVsZ422b3IsE6TN2CcW077F6/lZJ46s00YK/1MQK4WNpPyEzrym3wfKsCt3hPhiVmxOS9fJ4aTHjoxzJf/Y4kE1MSdZgvGq+XrtHhi2l0KgzPulxoJZi8AaPGTw1ImLh1rU4eTBD0SRIaYtFfjMS4KVC0DADgSjmnzdhGF3riCNGq/2O8PWOx5tSMYfRYDXoVGoe2jssJskcUwcFWsJN5VH4Ogha+9Og4+tQWTZ6Wz0oC9Jtizn+FLHglWGdewtbGzfH6YI8kHTJOp3aiVuAEdMulyQpZ33mHIKTFrCq+OUVMnRYo//zdZbCD6ob85a763Tpk10wBpqiGpIuMik4Hu5eZKw7ZOtQT8RhUiauPRJUaiRk7+HWt6izwdx0LGqcfDxvIpUTuX3xFRtbxFspesw5AkHvTfGE2l4cW3ih1xyf85lXTxY9UGPpV17uxLX+6ZyKR9vIzA7kmxJ7H1Xxcn7Odwb5Y0W66DOnYU430tp0EdLAUXkagSgNE1WxPsRpI9qAcfzXFew1yu8hFUXsj+B8t3K6FtWYfDw+GqdcIMj5y/olgmQ02ObbU3auTDLDyCcH+c8RzMIcPH8geQZ/ReEV3pA46h4oupRiaq6Ui600oiCU6GnrdMwuC77uNSXxenMFhc7Er2ya+c8wL3GghcMMM7b/JLw+HEqh0sCHsGbOUv2WB+SYMQZH/qadvZvJ1Un3Oq1hCetC+FKgu/mnbaD0fvNCWVT4cl6X38eZF1oWyWyhQwXlI1KKQ3A0wHnzfyOjXfPn7+/27VkwikoyFvxRO2z+fy4Y96DxxyNXvFIq2vDTHZanKCvK5CcrBdpigJSKGhsouqvkq9fo08AVe8ernxTOjNPHAe
 qy+moZuZ
 K57p/GTraKqHFkO7VuVDss/fdL1l18wh/DF3iYnzS3QFeM/E4K2EPspuC/m8rzMvbuRaJsyHBWUhAVqIjyTPBBUxsoKcBWonSqaZZTp4TJX2FXEaaOajlUE6ryNxdRQs8+iIQEbrIHno6nvoFrxE5aPv3BaT5tuFEzjaqupPDxSAVb3Tutjf3PrS0b/aagQuAbZdlHjTHSlr6NPdZVclRAsD2TWNa7+I1B1cknGqRyP5tywJ8vNapFOTKB27782n8WUcMW/7yna+ZScr/qymHApM+U/G0Solhr1XJbOeA5yDZpzP3djpCp5yUFoXwS1m5ue5mTrFVad8bbVSF57IHMP3iPe19XRKUwhptpqeDBJhB8Tg0FOglvo3jwvlSHkGlTNKtGKwSg/7J/mg2DZN0MWCoou5VSDIfuQ/DMsNnl7L2K36bBaBbgi5ZfR8aw5Ckm7OKLIyDotFfow3gCTtslCSZ+vUZAYvcbYhsRttu0VA78A3Zf0QP6/UxGsMqCdFeTmS/vKQBXi5OrMT2TTWGSlQtk8ysgyxBAzBh/GMz3WBUQLQ1T1Cjyne+lHFSrbdiDFYcAs/nqFG1WnhQlB6DJuMm6fpUFDkH3qV8BbUenZ1J9PN8FQV2SisXp/mhqJzwqNKK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 03:47, Wei Yang wrote:
> On Sun, Sep 14, 2025 at 01:05:48PM +0800, Lance Yang wrote:
>> Hi Wei,
>>
>> On 2025/9/14 08:00, Wei Yang wrote:
>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>
>>> 	slot = mm_slot_lookup(mm_slots_hash, mm);
>>> 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>> 	if (mm_slot && ..) {
>>> 	}
>>>
>>> This is only valid when mm_slot is the first element of its wrapper
>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>> negative value. And current code thinks it is valid and continue.
>>>
>>> Current code works since mm_slot is the first element, but make sure it
>>> won't be disturbed.
>>
>> Good catch! That's indeed quite brittle ;)
>>
>> Just one nit below.
>>
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> ---
>>>    mm/khugepaged.c | 5 ++++-
>>>    mm/ksm.c        | 5 ++++-
>>>    2 files changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index af5f5c80fe4e..668e74ad33b7 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -108,7 +108,7 @@ struct collapse_control {
>>>     * @slot: hash lookup from mm to mm_slot
>>>     */
>>>    struct khugepaged_mm_slot {
>>> -	struct mm_slot slot;
>>> +	struct mm_slot slot;	/* keep it the first element */
>>>    };
>>>    /**
>>> @@ -2382,6 +2382,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>    	struct vm_area_struct *vma;
>>>    	int progress = 0;
>>> +	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, slot),
>>> +			"slot should be the first element");
>>> +
>>
>> I wonder if this BUILD_BUG_ON_MSG() in khugepaged_scan_mm_slot() would
>> be better placed in khugepaged_init(), like you did in ksm_init()?
> 
> khugepaged_mm_slot is defined in khugepaged.c, maybe we don't want to export
> it.
> 

We should probably just use a static_assert right nxt to the struct and 
make sure that offsetof(struct khugepaged_mm_slot, slot) == 0 ?

-- 
Cheers

David / dhildenb


