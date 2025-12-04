Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79381D1F9D3
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3DF76B000A; Thu,  4 Dec 2025 07:19:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7636B0026; Thu,  4 Dec 2025 07:19:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9906D6B002B; Thu,  4 Dec 2025 07:19:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 815796B000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:19:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29C611605EE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:19:54 +0000 (UTC)
X-FDA: 84181695108.30.783A65E
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 14A4580006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:19:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764850792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fl4kT8zZhIH462w4XhRA0/pHSglNGtQd+UoZ7YR5/IE=;
	b=DhewKX94IAfH8OaNofvNiT+Z2takkU1yEgd0BPhHC7D63GmyOyPvqEysZ9eLhIY2AmtmNI
	w89Zo46qAPSV97MGWOt63oXB0eL0AtN7RPZHdIPmUCJykwPaNZK2Sk5XVoBNdUTYXZreCq
	Egg/o2+Pl4Qxzn6SP6CbUfIVhvuzxKI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764850792; a=rsa-sha256;
	cv=none;
	b=0KjnsPRyFVNcex/gzqEEUkHF5/it5b3iBXTrn5BR0WBp6X2E69mCE4E0l/R2xpve+q+djt
	wZcl/n/qXY4BB/8zbPg1luV3GFZOitAYIu9Tfq3cGFDmOWbMwUkQ8r0Npl+d9Ue4v5gOYk
	AvkONDMhA1vrqoNa6hV4tm+81Z0CW/Q=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dMYT76g7tzKHMYP
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:18:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id CEA071A1397
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:19:42 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgC3l1FdfDFpEfVIAg--.29047S2;
	Thu, 04 Dec 2025 20:19:42 +0800 (CST)
Message-ID: <64d9517d-b110-48b4-9625-9d572a8325b8@huaweicloud.com>
Date: Thu, 4 Dec 2025 20:19:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] mm: vmscan: correct nr_requested tracing in
 scan_folios
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, yuzhao@google.com, jaewon31.kim@samsung.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251203094002.1745458-1-chenridong@huaweicloud.com>
 <98cbf348-ff21-4c90-af32-b8009c34e5fd@kernel.org>
 <75ce1699-2c5a-4aab-acee-cca5c6a1e37c@huaweicloud.com>
 <173a99ed-483e-44b4-9784-598464323a39@kernel.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <173a99ed-483e-44b4-9784-598464323a39@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgC3l1FdfDFpEfVIAg--.29047S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw1ftw4fuFyktw4rurWkCrg_yoW5uw1xpa
	yxCasrKFWrXr4fKF9Yv3W8JFW7trWjya47Jr15JFy8Jr9FqryagryUWr1Y9rWUJr48Xr10
	vasrWFs7uFWqyF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 14A4580006
X-Stat-Signature: 3kjpg6699xx8wxq6a66hc86m756jb4qx
X-Rspam-User: 
X-HE-Tag: 1764850787-919715
X-HE-Meta: U2FsdGVkX18HZSlSbTb30ArrzBqcoEUwE9t+s8ua6XBuFO/e0bmudsrdavL+crmraaqn40YMY8m4Ftdt6aXyMCvx8wuTcJ3jv8bS3k9R3LA28v3MOTa5ZeHqHic7knyyPL/qE0kS7AEoO5OOlqF7JlKr7dE6Jkl/8ncmzQog+P+db5bRU+EcShjuUze2Pt1YJwRA2xIJgvNdlJXckWextQq3zEb+9muLrhBrMdajfMRtMWBxd1IRQQ5fI+lv/MxmIvxW9ZGTA3WNSik5fdCzJTaC4YBzJaRhvmP6gsz1VLs6I4SOHVddlolTgyTaOwsKRu8RLQM180NPbLjJAlDS7Wlfbr5cqH103x8EQRJZh2HkP1rPKO6gpXjjDRdqGsNeZtCKMOYgLtV0hp8amO3sF8c/Vd3sC40PAuDZBqvahSGJlJqUVDVEmPrMYgDdr72ElUcIAFMBAMMabdk3+vPI5aRWHPvE2tM1fc72IPguppDbmMy7o0WrrDtPuk42JicyUopv2VfFTIcUhNQo2Y4tBJGbfCHLJbTMX1rsZ/Cz3fBTzyrZ9GkKrx6IVM256qTdl/ZmTF1XEwEy6+pUrq+gYCECwbWnlZAE4+DRi+FgCG8TsEy/3UGF47NUyclXZQ3Qxpz/nz0vYDRWF4VwWFJUg7J8kwlb3WKuxEEYkaboL5fB6kjJZMRg7uWE9OtJVGKKzLP9WqmALnb1MI6PPM7uCi+HCkGIOZN+M1n5YuZJdNPYf51I+eMCnmIqm6kdlW6xcLjen6liqT+QKAOMICBQnIfaWSplLSYV4buz3+AvNmuxbtB5+v35P6oZzAf3EC/7SvrPBpyyVtZ4UAArBhSKBy7gK0pGSkGA2niafRU8wCpykJAGV1+HwF24yZvhxXA6f36c+w8PLlhN6OQbrWIkpr6virYnHDyXjraZkJJ6a2/bhY8XzJFXQUEyoo+W4OH+dKmr9PioIH7e5XhUxkk
 HUf13xb8
 WR5G/qKiE9w17VEMojcS1MQqZOrJh7uKle4clH/WDPkg+X506a8sIvHPGjAobHprHXlhTAZlBwbyHrkhHpA6QeUo7LcqCNfbsl7vcmX9JkEv05T4owK1xc48YQbJe+/rU8SqL+ibfg0b6RAp76MUFBr4QhGudIkwXO0ywtHoSH4uqDamzePtTTLp5D5rFIhgfbyDbi+N+CSK/M0+i2C/zdr7nPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/4 19:54, David Hildenbrand (Red Hat) wrote:
> On 12/4/25 01:46, Chen Ridong wrote:
>>
>>
>> On 2025/12/3 19:33, David Hildenbrand (Red Hat) wrote:
>>> On 12/3/25 10:40, Chen Ridong wrote:
>>>> From: Chen Ridong <chenridong@huawei.com>
>>>>
>>>> When enabling vmscan tracing, it is observed that nr_requested is always
>>>> 4096, which is confusing.
>>>>
>>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>>
>>>> This is because it prints MAX_LRU_BATCH, which is meaningless as it's a
>>>> constant. To fix this, modify it to print nr_to_scan as isolate_lru_folios
>>>> does.
>>>>
>>>> Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
>>>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>>>> ---
>>>>    mm/vmscan.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index fddd168a9737..8cfafd50a7a8 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -4601,7 +4601,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>>        count_memcg_events(memcg, item, isolated);
>>>>        count_memcg_events(memcg, PGREFILL, sorted);
>>>>        __count_vm_events(PGSCAN_ANON + type, isolated);
>>>> -    trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
>>>> +    trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>>>>                    scanned, skipped, isolated,
>>>
>>> We do that in isolate_lru_folios().
>>>
>>> Given that we do
>>>
>>>      int remaining = min(nr_to_scan, MAX_LRU_BATCH);
>>>
>>> and effectively cap it, I wonder if we would want to trace that capped valued instead of
>>> MAX_LRU_BATCH.
>>>
>>
>> I prefer tracing nr_to_scan, as it reflects the original target number of pages we intended to scan.
> 
> But it's misleading, because we're also tracing "scanned, skipped, isolated", and one might wonder
> how it relates to nr_to_scan?
> 
>> Even if nr_to_scan exceeds MAX_LRU_BATCH, we can still deduce that it was effectively capped by
>> examining the actual scanned, skipped, or isolated counts. However, if we trace min(nr_to_scan,
>> MAX_LRU_BATCH) instead, we would lose visibility into what the original nr_to_scan value was.
> 
> Is that really required for the purpose we are tracing here?
> 

Thank you David,

I've seen Lance's response and agree with your point. Using min(nr_to_scan, MAX_LRU_BATCH) would
indeed be more appropriate for the trace, as it reflects the actual capped value used during scanning.

I'll update the patch accordingly.

-- 
Best regards,
Ridong


