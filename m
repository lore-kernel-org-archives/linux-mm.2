Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E081D20682
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0276B000D; Thu,  4 Dec 2025 07:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86BE6B0026; Thu,  4 Dec 2025 07:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC47A6B0027; Thu,  4 Dec 2025 07:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BAA4D6B000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:59:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A1A216011D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:59:18 +0000 (UTC)
X-FDA: 84181794396.16.4690314
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 939AA40004
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:59:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764853156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QmyHVapKsLdUwTu1s7mD/DhhF74RgqpH43jx1YXm4m8=;
	b=GUj31fArNZ1nw18B+Y0NmvPUuoPgDofBVBzmtH9Tc3Q4AP1Ehcod8KlyniIe26s4pSOujt
	qpxvqArM/vp4MsaINNaGhfko7WYc9xckn9MSDaxBoD0yd4qIdtYHkH2xR7zqGUsxf+4tmc
	mlSP0CxPS54Zbul1/G9XneqecfrabOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764853156; a=rsa-sha256;
	cv=none;
	b=Uefz97cJd5QMvQC/pidJwBhZwn039URW8Xr6iInEfXX+iPe3+bQZwUX6hfTy7YiTzmPnfp
	HokxiVydMh6csrBJZzCuqXR8ZxPxx+VjfCFFRdDcfgp9PxdgJhKv8l/YyEzuSmjiqmb+SD
	v/tEndCSbirnv/Zpo8HQHZ2K4XYVGiw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dMZMW1Tq8zYQttG
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:59:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 42F541A08FF
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:59:08 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgC34J2ahTFpEBNPAg--.35828S2;
	Thu, 04 Dec 2025 20:59:08 +0800 (CST)
Message-ID: <ef8f934d-6792-4b6d-8f47-81f78edc1e93@huaweicloud.com>
Date: Thu, 4 Dec 2025 20:59:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC -next] memcg: Optimize creation performance when LRU_GEN is
 enabled
From: Chen Ridong <chenridong@huaweicloud.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yu Zhao <yuzhao@google.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251119083722.1365680-1-chenridong@huaweicloud.com>
 <20251126171513.GC135004@cmpxchg.org>
 <665be804-6575-44bf-af0e-63736442af0c@huaweicloud.com>
Content-Language: en-US
In-Reply-To: <665be804-6575-44bf-af0e-63736442af0c@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC34J2ahTFpEBNPAg--.35828S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1rtr18GF1DGry5Jw47Jwb_yoW8WrW7pF
	Z8Xa4DKa18Jr90krs7trZIqFWFyw1xArnFvr4DKr17Zwn0vr1UJFW7JayUuas5tF4kuw42
	vFWrXa4ayayUuaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUIa0PDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 939AA40004
X-Stat-Signature: wee76ztjudzaajae5toi75wd69goad7t
X-HE-Tag: 1764853152-789602
X-HE-Meta: U2FsdGVkX18SN2xy3UHZSN6+y9BBmEiztGgYlV6kjfwEJtD0EzG+yI3AFEEffjCQuAnoEVan1Co8W8SpTo5RN2/tfYysjem+gWrxJHMjLKPKcmXeSuFqVhqeQDd4zGvm9Nf0WuKiMw/8yzfJzdkAH2iJ2f3MjeWRExCwXS11gGn5wRzeezhnGLeTrGj/sktkuFxx3aFalTPBIM6n6/phXU8ALiRlFpTVWFPq7rxut9WFW7vt5NpoM8v+nLsmXo2wqymXFaInuOJ+VWsnQXefkn1CYYCxVrzRDoithDIMBT7EU9lJtGj8BhRZcDtAkYfejN+AA9g1iEuVvL3kENVHWovO7gPe9ouzsXDweFA2CmaeODMe7QOG6mgwZzLexzUbnki/Hz3qb7IF3rquT8bo6vCpH2OJ1JVfBM3iwygWtpvjj8Ncz4aEZrLlFjPSd4P5ZjVEwAhViux/zaQ13AbBtStI7plGdYnuk+H+wRQCfFKRLrsS+NKlthcmSM138BCbIjwKCTzFZ4e9wxX5TDknMQNa+Uo1/6E7BgsCca3uWhkDmOwmN/dkdwWPg/r2Ax0H5QMLJfnwPTTCLOdO7DqV9BLEY0RTjXj2Z5xrjG/uLwmiUkB2fZ34JW7qbLGYCwU0r9yeBAJ5ASU+7G1bzNMx8ppcjOQngYYW8rpIvAC5RC2juJyHzoSnczDiqKBfp3vBhLR+QwrYLbHvhZWh1H/JEzhId409d9jqLuEjBZFZ3z+j2GMe9JelYK1VW18v4rvy4bCmOwQARxq8GVIqm9hY9JbIEHyDD9pwa5jPCjWNugNzeR+MiRGAZ0CSLy+UuKEp4q3Rptsi5dvIbxbDfvKLoKezQw0gNz3gazZG38inEU6o2gmj7QKfHCWJVX2BDcmAzVv/KyUDTxcHVTE7jU3vlA3qK7hlU8NdYLPUKApGXYRso6kPgxGkQidvbI6usTEGkTkpsBPTuy1KsSEvlmN
 sH6A07J9
 EKHZM1jqpRq0HZ1xJWx2Pnbe6AhmJMqOfEFAeZw0pWcLEVulnjwrdsJ8vc5k/6sPaxa499Ma8ue4Aiy02fvdnb5FSnWqUQNKjGRFfiQXfrNc3HHtmJeaPk66KZcOFY7ws1N0rTkWY21cJDypyi5yXVCpT5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/27 17:04, Chen Ridong wrote:
> 
> 
> On 2025/11/27 1:15, Johannes Weiner wrote:
>> On Wed, Nov 19, 2025 at 08:37:22AM +0000, Chen Ridong wrote:
>>> From: Chen Ridong <chenridong@huawei.com>
>>>
>>> With LRU_GEN=y and LRU_GEN_ENABLED=n, a performance regression occurs
>>> when creating a large number of memory cgroups (memcgs):
>>>
>>> 	# time mkdir testcg_{1..10000}
>>>
>>> 	real	0m7.167s
>>> 	user	0m0.037s
>>> 	sys	0m6.773s
>>>
>>> 	# time mkdir testcg_{1..20000}
>>>
>>> 	real	0m27.158s
>>> 	user	0m0.079s
>>> 	sys	0m26.270s
>>>
>>> In contrast, with LRU_GEN=n, creation of the same number of memcgs
>>> performs better:
>>>
>>> 	# time mkdir testcg_{1..10000}
>>>
>>> 	real	0m3.386s
>>> 	user	0m0.044s
>>> 	sys	0m3.009s
>>>
>>> 	# time mkdir testcg_{1..20000}
>>>
>>> 	real	0m6.876s
>>> 	user	0m0.075s
>>> 	sys	0m6.121s
>>>
>>> The root cause is that lru_gen node onlining uses hlist_nulls_add_tail_rcu,
>>> which traverses the entire list to find the tail. This traversal scales
>>> with the number of memcgs, even when LRU_GEN is runtime-disabled.
>>
>> Can you please look into removing the memcg LRU instead?
>>
> 
> Thanks Johannes, this is indeed a promising approach.
> 
> The memcg LRU was originally designed exclusively for global reclaim scenarios. Before we move
> forward with its removal, I'd like to hear Yu's thoughts on this.
> 
> Hello Yu,
> 
> Do you have any opinions on removing the memcg LRU?
> 

Hello Johannes and Yu,

I've sent patches to remove the memcg LRU and replace it with mem_cgroup_iter.
I would appreciate it if you could take a look when you have time.

-- 
Best regards,
Ridong


