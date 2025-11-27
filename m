Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06038D116F3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 09:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4656B000A; Thu, 27 Nov 2025 04:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56AB6B0026; Thu, 27 Nov 2025 04:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94266B0027; Thu, 27 Nov 2025 04:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A97BB6B000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:05:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57521C0931
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:05:08 +0000 (UTC)
X-FDA: 84155802696.30.DE8CCF3
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 07F2CC0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:05:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764234306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+kjiejpdXIFnZImUPZTUYof3ZIm4VzrM7HNG8LaTieg=;
	b=eaFVd2vMx7+q3GuiagFjcHeHZym+Hq2nULZfnEABsQANIvFhDYAkK9JnYuvmJ5IVfzEOl6
	JJM/bXfRUy1d/GOfB6fODEAIMKMnV6cE15M0JXNXXU8NDy8FIQCybWHLrD7Xa2VNg162cJ
	kqKltcoRqoHMoHsJsQ9Aq0DhQ+kwN9U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764234306; a=rsa-sha256;
	cv=none;
	b=V5lH3QAAoJvkHtlMCn1rYOQerhAemrT2lir5YTqvjufe+PH10064ZW/WKptG65KO5vHzpf
	uf8HOGhewTAAky6q+Mmvbg57Ufi6xDJyDyt0hQbZIQUBW6yfRd4q5KNrC8xtA/cSkNaB+J
	4i6Rbnv0hQNfymbHbBWBonNXyoHorWc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dH9Tb1WV5zYQv39
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:04:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8457D1A0359
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:04:56 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgDXTFo3FChpFTu7CA--.60042S2;
	Thu, 27 Nov 2025 17:04:56 +0800 (CST)
Message-ID: <665be804-6575-44bf-af0e-63736442af0c@huaweicloud.com>
Date: Thu, 27 Nov 2025 17:04:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC -next] memcg: Optimize creation performance when LRU_GEN is
 enabled
To: Johannes Weiner <hannes@cmpxchg.org>, Yu Zhao <yuzhao@google.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251119083722.1365680-1-chenridong@huaweicloud.com>
 <20251126171513.GC135004@cmpxchg.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251126171513.GC135004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgDXTFo3FChpFTu7CA--.60042S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CryDXr48tF1xKw1rWF45Wrg_yoW8WF13pF
	W5Xa4qka10yr9xKrs7t3srWa4Fyr48Cr1Yyr4qkrnrZwnxZw1UCF12yFyUu395KF4kurW3
	tFW5Xa4Yqa1UCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Stat-Signature: d7z5t7rqtomy77ksmp1dwz7ei4unbqke
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 07F2CC0011
X-HE-Tag: 1764234301-76100
X-HE-Meta: U2FsdGVkX1+HUhoWHvU3JWIawGoyBXs1w57mxluz3IEcK4M39hlzs5FmDHHUmCx2jrypi/gJFJxRNiiP50c5SKQOxovWczWPlVolNMyg01CKUkVNeHy2KBFodLGb+qPRJnV3YuRQ5oKCXb2LBoYeLBtqqnmKt/SSBC0widNW26VHMmyvssIv4Q/yqUrJPHAguOdQOsexeWGtwMg0hw8D+59V66axrl7oTg39jva69HkDNkYUtHxVI/6YFeaHTwp+31MJJ79ExYn/sse2jntQyPOadcTWioEfUPLOGldW9addvfPQzWN6s6nzIGBUqjbZg2wbrPQupvap45yLxD1Uig99QzuckA/f/Y/avxWQojf2G/ufLYylOEUOLFEzezlmLwavn2XUGkElJEs0XAb11mtq7SwJcL7xAUNToVoUdNlRSdX3E/R+xuFnRuvJysDP898GtHTZ56cE1iDKkiFLso+5b0c3wjfFlTGjEd2gH6OttSczQUQBQIzVUkiEeLmMgLbQRlLlKWlh0K74MLnjpz4Q/4A/wTm795bCraaLm3iX2UexmO+jg9TrarLrCKHhp2TMXGTrJWDOmSYP4DRuKI+K0LQdiLCPpwf42khrJYZkiU+O8Sw3SeiKDnSEb2cdcWrBabFZcThFzaGS1k9xDWHvZIX/St+RNVnBF0ZKla6klplB9cgtorLEpdOSRtaLf9kzoJjug+/GQ6whFzFpDiXwtUlejnB1jo29RU6EqBzFtPeqzDrb+Z9LnWiNEpIsNZ0tj1pxSVnuk1YAwZrNmlSN6Un/0TYwQ46ErzUg3Jx0JJnc3Qdh1D1SUX7UButCrbOrdQelM0T6qX0dU4ODtDxL7k2TCxuT+ofCBkRUHLazXvz4d5sqSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/27 1:15, Johannes Weiner wrote:
> On Wed, Nov 19, 2025 at 08:37:22AM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> With LRU_GEN=y and LRU_GEN_ENABLED=n, a performance regression occurs
>> when creating a large number of memory cgroups (memcgs):
>>
>> 	# time mkdir testcg_{1..10000}
>>
>> 	real	0m7.167s
>> 	user	0m0.037s
>> 	sys	0m6.773s
>>
>> 	# time mkdir testcg_{1..20000}
>>
>> 	real	0m27.158s
>> 	user	0m0.079s
>> 	sys	0m26.270s
>>
>> In contrast, with LRU_GEN=n, creation of the same number of memcgs
>> performs better:
>>
>> 	# time mkdir testcg_{1..10000}
>>
>> 	real	0m3.386s
>> 	user	0m0.044s
>> 	sys	0m3.009s
>>
>> 	# time mkdir testcg_{1..20000}
>>
>> 	real	0m6.876s
>> 	user	0m0.075s
>> 	sys	0m6.121s
>>
>> The root cause is that lru_gen node onlining uses hlist_nulls_add_tail_rcu,
>> which traverses the entire list to find the tail. This traversal scales
>> with the number of memcgs, even when LRU_GEN is runtime-disabled.
> 
> Can you please look into removing the memcg LRU instead?
> 

Thanks Johannes, this is indeed a promising approach.

The memcg LRU was originally designed exclusively for global reclaim scenarios. Before we move
forward with its removal, I'd like to hear Yu's thoughts on this.

Hello Yu,

Do you have any opinions on removing the memcg LRU?

> Use mem_cgroup_iter() with a reclaim cookie in shrink_many(), like we
> do in shrink_node_memcgs().
> 
> The memcg LRU is complicated, and it only works for global reclaim; if
> you have a subtree with a memory.max at the top, it'll go through
> shrink_node_memcgs() already anyway.

-- 
Best regards,
Ridong


