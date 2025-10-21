Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8D5CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10578E000B; Tue, 21 Oct 2025 09:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0C78E0009; Tue, 21 Oct 2025 09:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF958E000B; Tue, 21 Oct 2025 09:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 865D78E0009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:37:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EA8811A337
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:37:17 +0000 (UTC)
X-FDA: 84022222914.04.721A0EA
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf21.hostedemail.com (Postfix) with ESMTP id E2D721C000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:37:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=trS+cXFm;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761053835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwIV9nB10oHgThzIZ4IOy7ti1VL87gRtBTwjrvABd0M=;
	b=oulsCI7+Dq6SSk7jLnHaTZMvpbanbKdOZTanH6784RWeJ8fMhjDnjqfBN+WKLr2WDgredZ
	ro2uFkS9bPz3U0a1VXo1nZPKEFGNxkc162kwZM+uxwlo8WL/K5DUslFb/JG3Jch4KQngBm
	XSFYlxobH8eVg6LLqLpTCFpBDyoNJJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761053835; a=rsa-sha256;
	cv=none;
	b=sL6XWiANnngQGRYfGXQ9t61X2lxdgycYdc63LO9/qvJTTjQa9kgFnKPpq3cMOxky1dq6Dy
	x5syXgtfMlLHQ9VUq4X6MRY673ozeRLDiW8nsyy9jSZiHXrBBNEl+1nJjXoOvgRvzNyn1g
	8Ep1JXHK1H6m9j/c/owEUZgBBhNz70Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=trS+cXFm;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jwIV9nB10oHgThzIZ4IOy7ti1VL87gRtBTwjrvABd0M=;
	b=trS+cXFmwWQQjG4d3kCdquPeZ+xM1ogYnL1tO9CNyADGr/IbdidqEdJbzND1SvO8r9xuzkE3s
	rdmB9okGumragco2sHK22zqGuamiFasKkyiJ2brJ4t43q6JayE6vb+mGCRTVs0OiGhfYnDHp07Q
	d6kCePUdEnArPL0o98UJvzk=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4crYHF39nCz1K989;
	Tue, 21 Oct 2025 21:36:41 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CE2B41A016C;
	Tue, 21 Oct 2025 21:37:04 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 21:37:03 +0800
Message-ID: <8ffb441a-d9a5-451f-ad39-5689acea13df@huawei.com>
Date: Tue, 21 Oct 2025 21:37:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
 <4d9b5a05-5e1a-4a99-b8df-bd61b336392f@lucifer.local>
 <a25e1292-1110-4534-b7ee-b3398b955236@redhat.com>
 <2436956a-d5d2-476d-9117-a06fae5d788d@huawei.com>
Content-Language: en-US
In-Reply-To: <2436956a-d5d2-476d-9117-a06fae5d788d@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: 58by8crix6pfz7yz5q6ektb6juym81ou
X-Rspam-User: 
X-Rspamd-Queue-Id: E2D721C000C
X-HE-Tag: 1761053833-867301
X-HE-Meta: U2FsdGVkX1/WQ7XgvzSogPHHoW4n+RGKgeYCVolVSbF0/85jCXBi0jv3LQawdZF0WlVyFDnhQm1xahNPK0mGoum7ZnZWB+FEuUAUGnBqZlk6am3DNgpErxWlbXBhiOvdZMUsVof+ZbSUlq9qg/TQmAI9EHe2PL8tMA1ZzerpZDezXTWcmjUJYCZPJlCVt/NtLSGql74DjauMsUDXqy5+mFC/f/Q/Oylz3cwNMaS3f3D+Et6UOksWiWOEMULum+vOmTAPLz6VehRZS3I9r9udbLdMkuY6/I5MLGoXTHeKB9wQMXZY6jEjdlYpZd8JHTeL3mmVrVJ+oE72UjBmxAFXLAZOfab0bcXxuTE39pJg71FliL1tZ/Fm9qeHxUYXAD7FC7MXjvwfsmTF8NqaICPLWnHgpvrfVoK8dvmzFbSb0OV5o9SntWe861Lz/l/Ix/gvCKoo/50MDJTuvOP7sEHfQbfex+4j59BfxVvNkhH5vfbEj3vYt2cLSwLOry0QUkRy9ms/20ZFLq565gj3TXdstQ+2bTC/7zi3AdxDIzLqLtyuEooQffzwDBIHavb5p8Mu4ANsfqg2EYihJoyBsLLUNdos+kdWQL7d61Q8O2V0rlqcfQTN1XSHWvlmDdm8m9Yzec1ProRYvKQoaropp7c99qW5PaTyNA6pSVfU+KVfAwJJChSjiiyPRDSHpgFdhOqG+lvNU93dzpCoevbQmreT7AdAg3iezmLeSdQ/P6Wxn/Bzl2jISMiWGGGheO2wZgRdTE8js5G5uO/ZFcfusmKkXElp9IbTofECTZjYlFW8gaC7U/9rrswbYfxpr6hqQIkW0UcxZrxB1SCTVvL9/klxRg7TAu+s7x6zDVJbVY7ijakikMuc6ehFbNNISZFCVSoVy1wPKMz2CfIfX6L2D74omKDdlS32MlIq7C+JD2R1SGdEbGRuqQAg/6MPB9xht9FAfDwr89El90jNObG44Yn
 E8GG0cJu
 idMA09bVNphK9eA4q4v18PP3gvhfioDNNqUHho9CByXf0YZo1ewnNRQMkze/A4SPsULShzpWWXui4Foi+xpc97t7AbRxxaUf7wpk5QSJDtMBM4DA8UEp6ddHb5BrkPSu9I147TVbDmUN4iRYDaX4aPIYKbc5lyK9Lf3memPM2E4LFL3knhdQipYJVBqB5GrXZHW1THkWOHb3A0aIPezOj1wA4rIBInzcJLF8RKHj6k6D78B/QBwJLj5NNm7fOsflp6oiaODXE9fpHaP2R+unAanSwicdFauKbyENRV3hp5dM0Re/X8ZAr2mRfEaJbv7z6S4losYLI28tgdYSxIvL3FH67mioQPhaWQ3iwzZG1LWQsG7MfAVDmAmZ0o1ugyJnuiZvhTOW3swtH8HU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/20 23:18, Kefeng Wang wrote:
> 
> 
> On 2025/10/20 21:23, David Hildenbrand wrote:
>>
>>>>           /*
>>>>            * Avoid trapping faults against the zero page. The read-only
>>>>            * data is likely to be read-cached on the local CPU and
>>>> @@ -2490,19 +2490,13 @@ int change_huge_pmd(struct mmu_gather *tlb, 
>>>> struct vm_area_struct *vma,
>>>>           if (pmd_protnone(*pmd))
>>>>               goto unlock;
>>>>
>>>> -        folio = pmd_folio(*pmd);
>>>> -        toptier = node_is_toptier(folio_nid(folio));
>>>> -        /*
>>>> -         * Skip scanning top tier node if normal numa
>>>> -         * balancing is disabled
>>>> -         */
>>>> -        if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
>>>> -            toptier)
>>>> -            goto unlock;
>>>> +        /* Get target node for single threaded private VMAs */
>>>> +        if (!(vma->vm_flags & VM_SHARED) &&
>>>> +            atomic_read(&vma->vm_mm->mm_users) == 1)
>>>> +            target_node = numa_node_id();
>>>
>>> This is duplicated in both callers, and only used by 
>>> folio_needs_prot_numa(),
>>> why not abstract this to the function also?
>>
>> There was a discussion on that in v3 I think where I asked the same 
>> question.
>>
> 
> Yes, it is in v1, for pte, we could avoid 512 times check and the
> numa_node_id(), so we leave it as is.
> 

If no objection, I won't change this and will send a new version with

1) kerneldoc refresh for folio_need_prot_numa, per Lorenzo
2) update the changelog of this one, per David

Thanks

