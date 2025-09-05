Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3015CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DE66B000E; Fri,  5 Sep 2025 11:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362216B0011; Fri,  5 Sep 2025 11:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250856B0012; Fri,  5 Sep 2025 11:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 137C86B000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:04:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B86971DCC21
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:04:37 +0000 (UTC)
X-FDA: 83855518194.30.68860CF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 69AFA40019
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:04:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gaInezx7;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757084675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMnPF99NXruBPX41y4ErkZbUcg5msJq/UQbSen7bhTY=;
	b=BT+p8IFAzkkVbXacUqfDG2hbEuBaZ98rmoRi76qEpw7qI/EJ0OzSqrETXdWYGDtDh4VSEX
	dLuVhS4V4yTe5c7AEczAPCYoMKi2B/8AAsaxR/YUDXFFX2fubbN4r0rQbFXjluB5FhKU3e
	2q6tP2Jwk6SIwKGbepYzpxoXvJrlBAo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gaInezx7;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757084675; a=rsa-sha256;
	cv=none;
	b=xxhAdBBWI/voFE7+xs5eOKt/HWl67b2ECN3TXSSPgB9f/YlQUW0daKiTYvRv4Fj2e0Gf2U
	YJB1pO/NKc6HoeMu/IKWpKWRMwKM81fQe7a4P8u0Ndf4ij5imWLnMcUrLlUdFHI5JUXaUr
	jHYGNVHhXmVKcVza1UKbxcoXFNNhMuk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757084674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PMnPF99NXruBPX41y4ErkZbUcg5msJq/UQbSen7bhTY=;
	b=gaInezx7D4hYBkeq981X2PxHfy0/7MBgjb8wLGdwqbNPGGxo8boTj8YhUc3aMKXmTeofRv
	nAq/T7bXL9Q9VgrZ2txD1nCNG+WosfkQoI7nbSNrwD33F8PduL+Bi8xns+FBEaFRgl2bZh
	tvbfDNoOiC24VBdWWrYdbmdLi/aYVvg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-7bzkxM56MIuwwG8j6QSqlw-1; Fri, 05 Sep 2025 11:04:33 -0400
X-MC-Unique: 7bzkxM56MIuwwG8j6QSqlw-1
X-Mimecast-MFC-AGG-ID: 7bzkxM56MIuwwG8j6QSqlw_1757084672
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so21449365e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757084672; x=1757689472;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PMnPF99NXruBPX41y4ErkZbUcg5msJq/UQbSen7bhTY=;
        b=ph2A1nz3YuOBNs5KANCu/i1SIZxIsIB88NvHFGSgkCjOyw8Qzkj7xfbkStUL5tvOkr
         vKntFylX4ttAG5iPOLw4f1+RBE1INa1I5hXtI77HTRkc1bEk5dNSzgqCJGeOvNaDPS1W
         0Lh6zB2Jly/pqqK1hv7/59GBpv5wYWkzchhBSbGeaz3Ma6Px79T5LVNoar+0uETuyd0x
         aF6sIH73k7MgN1mbRWZDJ3xG4yRMR4qIzHkzLTw5WN72rXMTf4+4ZK4gmdIk4Fn/9FRh
         tUcxmgtM6qXCP4GmWFXic/ylyL19f/W2es177xa8QrSCbjY5XHbxV/YtiPhxtZ99alji
         /+yg==
X-Gm-Message-State: AOJu0YyIuxfUr3msIHYZesDaBWj/hDMeFKpwLbnCivcgrpFsVD0N8eOO
	/BrHoTsKNpH9v+c9CJLoTs4vA7ry0vt0ZyY7NuWHxD74ixtv3Ertf/65U13v3ZEN5DnYJlEBV+0
	Dv8EKpBIpeliLvBPlle+xPwGQ5pNiHTUoSh4oPSjI+S44H0w1frSr7VZ8GGDX
X-Gm-Gg: ASbGncvRqoi/Dmx5KalzL6fhziRArZ7LhfJWk4FC6v0wTCwGKNWYprA05RpS4Xt5Dpk
	0/eUMRtW2Iy7qPSxQ/LwUrZlVYALVfJ6t5RCphe0fHpurfndds2WHcYC42A6fSS4JZM0jJ+q0gg
	1QEMpu0+1SoEDcYf43l1fO1y6fQNQsBFcBjC+E4+O6/2ZjTnjqk1WFmwqiqcDMzZ029tjFp2ALZ
	Su9svdoE5ANrUTQKkCDcqoP8hYdTNIqzd8jgSVl1uyyaygvZFz6rDPcBkgAqtLKWk4poepmdpSR
	lZv51TBCfdZWKvFsS2yUeZE5YD/IfcxPjJc4fBj2uOoCXgE7vvfclzGVM7nt1OB0thmJ9ij3oz7
	5aVHT2S6fGmZ1PzqsGBpMkqFFC6mrBmmVs+K5SDN1LUfcKVYJiyLjb6ZE
X-Received: by 2002:a05:600c:5251:b0:45b:9c97:af8d with SMTP id 5b1f17b1804b1-45dd5b2f7b4mr40271205e9.4.1757084672388;
        Fri, 05 Sep 2025 08:04:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyTPaDcucOBP/kSmYHv9UTJktIXdM1NsbPCLy4BjRCaedanRNd2ruqH6gwNaw9hHMFpc7wLg==
X-Received: by 2002:a05:600c:5251:b0:45b:9c97:af8d with SMTP id 5b1f17b1804b1-45dd5b2f7b4mr40270835e9.4.1757084671852;
        Fri, 05 Sep 2025 08:04:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd5098292sm51762955e9.1.2025.09.05.08.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:04:31 -0700 (PDT)
Message-ID: <3737e6e5-9569-464c-8cd0-1ec9888be04b@redhat.com>
Date: Fri, 5 Sep 2025 17:04:29 +0200
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
 <1aa5818f-eb75-4aee-a866-9d2f81111056@redhat.com>
 <8b9ee2fe-91ef-4475-905c-cf0943ada720@gmail.com>
 <b56b43c1-d49d-4302-a171-9b00bf9cfa54@redhat.com>
 <8461f6df-a958-4c34-9429-d6696848a145@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8461f6df-a958-4c34-9429-d6696848a145@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kKuFtoJu1HFiso4XdhF4Xfd9-pZzTfKuXBTlbAHM8zo_1757084672
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 78sejwf3tqm3m5mosc4e3guqj4j11j8f
X-Rspam-User: 
X-Rspamd-Queue-Id: 69AFA40019
X-Rspamd-Server: rspam05
X-HE-Tag: 1757084675-163645
X-HE-Meta: U2FsdGVkX1+o4Y+VNiOh/g0AhDipE007gPNf0mg6VMWHzb9bqvdb9iZbRNEM4W5ltosEvpTdmSlyaCzk1jqn9WzvyUJMe1QD5cyA6P8NAH5e/0prJpBBL32Y7Gp+DtBlws5ndIDf4Qmssl/bza81lEJjYA8isLPBRHvXrT40UOcwiuJAeX691YfVmfNELaZEZft26/R9aRLMql3kqEpTdIjBx1XQh9D9bbXYOJsdbZuygJ6Y1+HJHaSMx/yU0YuDedmH6hHiCgL7IMDpy5PDHvzVifagN6IOyy7dHJftmy0EL8dFw6xvWP/2g5m6P8YvuQ/dp2NsGjlBL1n2qpP996Cp7MomGgB+HCCEIqnTiXMib42nB+MosANpUX3KwbP7BjIomXVM+kF8O3yZMvi7zdGjn5odVwnfmgGxtRza6rbNlFoDS0ZZcHT5RYa4H02404oSvzf9boehqCJKBGRJkVBmrjxgfI7GsudCVoGEGAF9vWvYwrC9Usixv7/9j26NAw6ad1SVodGCIXsBSVBcy7wKxhoWhNsF27HLC76RkpfYId3HjeJ9Sxpb/DVxPJ6pxHjWHCjEOlrNdUxFAoaM1Vdrn2co0p1GpXqWtb7ULUJzDroaUmmHYmfsae26wq3p+nDOb/I9yN/5/X6guSVQZPCW9KxEhQ9sXRAess/KvBAy/NzkZwbTOetTMRWZ3N3nY2GV/t9Zhw6voKB6PD2UjN8XJSwbNjOdnkf5mIYqv70pLoF87zUvcekrPGbcdn9a5V3guzcJdNEr661Doe/IRRWup6SX8Jz/wJp8cLKj35NddKHenX5hoORdsmZIRMGWYeoUjY5u4+I+tUKO6WjLC16HMZ5oCTyQtSqSilZZSRj6UKRwi4uV4tNJb4xjg+KbMdxMuZQHe2V7ahXKDZK8GMx4TRMHvX+aw98PkL044rtauh/AC8Q/FIIY6/nU0ScNf52NLblFIxkrEtOcoI/
 lKymBCX6
 S6uHRVKDcKha0pbmpWdtwcV4/IYaJpdIb0tgS8vCCCLw+ZKaAxFdvj5fuqWdB040h+anfutxXSvL6Uk+60a176rv4jIJilGIubLaQeU9qLB9sa8IH+bHDBKnPZbK7DP3kw7W0dHX014ige80N/7oZS8dUaOmz0oykSK2BMM9cN3209ZFbYJTDdSFxx5N37mjwCzyEDkzHMtMDy1N9pgSPyUs87svZVNukGVEvu4x8SYoISsedEuKa6Wp4THjnp5/Usv9r7Vc7IY/HzPAZm+EZ1W4NcfBAx8vcqGqDcPttMrk4NERTEfewp8gFFV3d7lP08UHTh8yqDuSbAEFNLUQAwI2RECsjZWw5ZNeXRWXkBg2f5eue/eGh7to45w3zP6spLMwDE2GLMmspm09eLv12RwSdFCp9mP9ycWCsECBvn8xmuJQOTJsHYwosKATscjsFl47N5d/euiEWjxBSBVFkQt4FOvZbo3r1dj9x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 17:01, Usama Arif wrote:
> 
> 
> On 05/09/2025 15:58, David Hildenbrand wrote:
>> On 05.09.25 16:53, Usama Arif wrote:
>>>
>>>
>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>> [...]
>>>>
>>>>>
>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>> so that its considered for splitting.
>>>>
>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>
>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>
>>> Yes, I do this as well, i.e. have a low value from the start.
>>>
>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>
>> I don't really see why we should do that.
>>
>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>
>> Without more magic around our THP toggles (we want less) :)
>>
>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>
> 
> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)

BTW, I was also wondering if we should just always add all THP to the 
deferred split list, and make the split toggle just affect whether we 
process them or not (scan or not).

I mean, as a default we add all of them to the list already right now, 
even though nothing would ever get reclaimed as default.

What's your take?

-- 
Cheers

David / dhildenb


