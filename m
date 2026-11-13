Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3AC606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=M3I78Ut2
Received: by kanga.kvack.org (Postfix)
	id 596426B0604; Fri, 13 Nov 2026 03:20:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56DF86B0605; Fri, 13 Nov 2026 03:20:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB216B0606; Fri, 13 Nov 2026 03:20:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1799C6B0604
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:20:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80CC7A013E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:19:59 +0000 (UTC)
X-FDA: 85429397718.13.6370ABA
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC28A1A0007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:19:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M3I78Ut2;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794557997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylL32ZA+eS78yzSptteM2YgqxrCDp8OR2zVucYyFWyA=;
	b=XmFyNClVHjTisPjT9NWeoKHg7PsQdbHVlRilsmYEW70JGW27MyS2k0WHcMAaq1hCRWe1oO
	TdZPgwr5M0QSsqCRDF7RLubIQlSej2EEdkm5skcuw26tV2e4YGrqX93C90FxMoFnZ1vXqA
	bjv4ZcOsuEAlYMxLFxnWD56LyUS6fIY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M3I78Ut2;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794557997;
	b=UmdzLditPo4LCDgpPHoy+BNRAWLAS5q96cOaCss4R3lHs896W7yPzCHw1OoOztyVK1oM+R
	c1+pxYUfrOZEirhvCR03g83LUCBtaa1LkjA+Aew3CuHc7Y5umNevtfaGtwPMjFez/0tVwb
	UQc68zRvM828WxCQDZdeimrU1ij79tM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ylL32ZA+eS78yzSptteM2YgqxrCDp8OR2zVucYyFWyA=;
	b=M3I78Ut2h1XzAqRsE6LbAjmsrN6fR2fuGwcNvCl6wBD+WoVt+ymegCUNqBcsK57fm9atPMBpB
	J+I8PGKpQY35yJYinAI/nmqnhffoMHFKpwrAm7oxY6xidGyrC8s9TC6Z/Ft4u0UoCh6sFLOltCY
	HIPmxuJM0PIsqR/ryTQlu08=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jQqtf5FCJz12LJQ;
	Fri, 13 Nov 2026 16:19:54 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id B120140579;
	Fri, 13 Nov 2026 16:19:48 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 13 Nov 2026 16:19:42 +0800
Message-ID: <c900aca6-e1a1-4155-a900-ff4abc270427@huawei.com>
Date: Fri, 13 Nov 2026 16:19:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm: hugetlb: fix GFP mask propagation to CMA
To: Qi Zheng <qi.zheng@linux.dev>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>,
	<azpijr@gmail.com>, <lance.yang@linux.dev>, Qi Zheng
	<zhengqi.arch@bytedance.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<stable@vger.kernel.org>, "Oscar Salvador (SUSE)" <osalvador@kernel.org>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <1c5e8c4ae230dc238a16f2f42d65bffac6244ad3.1794379434.git.zhengqi.arch@bytedance.com>
 <7def88b4-cba5-4e8b-9e68-6069c492b582@huawei.com>
 <1cd3c151-24c2-4fec-8356-99853f8d6971@linux.dev>
 <9b46d8e0-104e-4659-8dec-67eb6f059dac@huawei.com>
 <dbfa9791-5a4e-4837-a2cc-ac506826761c@linux.dev>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <dbfa9791-5a4e-4837-a2cc-ac506826761c@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: g44w6dqk4moe6sucra1cjr8wfp7cdse3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CC28A1A0007
X-HE-Tag: 1794557994-985158
X-HE-Meta: U2FsdGVkX1+xu8rARwAroVx5Js/Wy4Zq4R4lg85SoetrdKTmXDij107kTo/crbuAecEHLLdVDuVHvXWhREfjJbQAbojSbcDwgCPPxK5nh/we+GgQVczMzZd9VVqJjYoWIrlI6Vj91RbjnCsOmOChM+inENCaVMhE/PguKU2uVEDXqDHm/9RCtY2k1UlaQbsyRXFSgPRwEpXnCIHlC0HRHKGXlKH/jgii5uV0qQy9FTs+aWXSnXSsUG+W+v7ZCM559A3Mn82OZu9vG2gg+vrXKq9n/r6PGpgNzXtU9oCxZekUKCPPfzzCw/PDRkSf9Wzc7+Y5uAYzrRNZ8AAE7yCLpVBhVZrOVmeO1/v2k8ZbvuFHcqbTJuWP9HkZ26q3A9XM/83vFhbpGXVEtP5TTzLMPasMEPvUqc2VmsQ1gOuU5EDvnUvpyOg92sjlJyZqP8YarpKe8AKprz8lqGKehbnOdCPxnd96A58SaB/G6jByDWuur3VreZh+Ce/Es2qGRC+k37OiLW+aTyxZeIL218o0eLD1aYNpUmlCTLcOzJZw9RFilQ2zU3l6iyLoT1GT0bEiyZKCJrXyxNHuudxZaChqoOPmDaSB3H80Yi0ZY1LGnhtj7rxaAThfdEmO8kcWoGlU2/NanM19Mh0WftCDwfNdCPvpVErNVSBZ2jyXoOD/gbDBsKx3Gg5+eEv7y6fi9O6jxKvqUM6c0WRX8oVScyWAcQgJfyW4YkW8Y41oRSoeZcwg0INRgAs9ZLk0GjIHvZPXF+9XIUB+lTgatgFwM5QToBJtbYr/aB5TTslQlnzFBcxrEU+9ep4Zycd9HLhFINEniwd7bwzPDPM15RLo6V/QLMVIka2BPxe4PCSwQBIG9JKhY96ioyFTZbLSiSBmhRf/1Z9YFjiqbzVRaqzQmzrseGVFad91AEnrYXxrE80p7qOlLxmkul3Yqy4R7biknX1Xg4lZJBvPkTrpMtfQQ3Q
 RLzOEQkC
 4NViKiQwhDwCMOocZeLbrZw5jRm24pcmc1Z5xX+iAUp/ewH0Sy+BBJ6z0QYYV2Bhc80Lfc/51pPy2d99StYVyxmSAy3SMq5+KsvhjLsDpU88yXkA//nYtfXB0M7hPYkd74Ft6fC2Df7fWInZcIK+Y6uTGBX1kZsBw+lyfMQqHS5YWM6u92iYYw1TMqtQjAEjLDdruRTmRqXHLNEZO50FNbujPpeWXU4fsVvACLHkqaMrCIYDGPk46PlZZw9sW3Stsn6sGC11qh9EIqljKagzFt7byrsBU1bMuviv2ceVMQPbXm/5UcaqOrq/nRe+wZSd0kzVHu8b7o5NF0lSrSyEgvuExvy6F4ZNiBqsdtvC+1eCTYvWPrSNdUXDkYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/2026 2:56 PM, Qi Zheng wrote:
> 
> 
> On 11/13/26 11:56 AM, Kefeng Wang wrote:
>>
>>
>> On 11/13/2026 10:30 AM, Qi Zheng wrote:
>>>
>>>
>>> On 11/12/26 7:27 PM, Kefeng Wang wrote:
>>>>
>>>>
>>>> On 11/11/2026 2:46 PM, Qi Zheng wrote:
>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>
>>>>> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
>>>>> during the first MPOL_PREFERRED_MANY allocation attempt even though
>>>>> the caller clears __GFP_DIRECT_RECLAIM.
>>>>
>>>> MPOL_PREFERRED_MANY is only used for the partner allocator. Without 
>>>> your
>>>
>>> It's doesn't seem so.
>>>
>>> Gigantic surplus allocations already use MPOL_PREFERRED_MANY, following
>>> eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages"),
>>> which predates 9bda131c6093.
>>>
>>> alloc_buddy_hugetlb_folio
>>> --> MPOL_PREFERRED_MANY
>>>      --> gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
>>>          folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid, 
>>> nodemask);
>>>          --> alloc_fresh_hugetlb_folio
>>>              --> only_alloc_fresh_hugetlb_folio
>>>                  --> alloc_gigantic_frozen_folio
>>>                      --> hugetlb_cma_alloc_frozen_folio
>>>                          --> cma_alloc_frozen_compound
>>>
>>> Before 9bda131c6093, cma_alloc_folio() forwarded the caller's GFP mask.
>>> The conversion to cma_alloc_frozen_compound() replaced it with
>>> GFP_KERNEL, re-enabling direct reclaim during the preferred-node
>>> attempt.
>>
>> Oh, I forgot about that commit. The naming and some of the comments 
>> are misleading because alloc_buddy_hugetlb_folio/ 
>> alloc_surplus_hugetlb_folio
>> can allocate both buddy and gigantic folios (which can be allocated from
>> CMA).
>>
>> Maybe rename alloc_buddy_hugetlb_folio to hugetlb_alloc_surplus_folio,
>> or other names...
> 
> Naming is difficult. ;)
> 
> The Hugetlb implementation seems quite messy in many places; let’s focus
> on fixing the issues first.
> 

Indeed. thanks for you confirm.

