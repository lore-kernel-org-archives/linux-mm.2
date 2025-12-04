Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C04D20682
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D3E6B0027; Thu,  4 Dec 2025 08:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DAA6B0029; Thu,  4 Dec 2025 08:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A3E6B002A; Thu,  4 Dec 2025 08:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 634876B0027
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:02:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0270A13839B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:02:00 +0000 (UTC)
X-FDA: 84181801242.19.3EE61B4
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 59F1812001D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:01:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764853319; a=rsa-sha256;
	cv=none;
	b=DL/YyfWO2vDSRVx0wH/bjVgNsluoU1r8x18K/cTAgiyEd+ENyz/rjirmCUpMcTm9LbKLAm
	FxiigIWwzmr+i0H+lTWFW0bwhCiSH5nEQdyR4K9TLSwBTV1bKAWVkmhGULAjcWx/wutyFR
	48okzxIA7N4ZmWruVWfUnJWDntqhzzU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764853319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqSrXw/tjTO2+C7r2DvV7Qs529dibCEW9VwZ/UOWrcQ=;
	b=DCrYnTaexyP1lLB0cR+wrlvX4VBK5MrLs4pdth7KsxQJMku5XMlBfgoylBGf3MTfPYO/Fk
	bKBHAhtRCj9RuqTfw7OohiXzdMOgAJ0FBlIQvSUO/vBc0K2YmOqYResG5oDlojCKYSkaTB
	YM9Fjl/i2GvCapGD88Ljd2lYwPeyJkQ=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dMZQh1xLdzYQv4y
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:01:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5538E1A1712
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:01:53 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgBXgZ4+hjFpGU1PAg--.34698S2;
	Thu, 04 Dec 2025 21:01:50 +0800 (CST)
Message-ID: <b2b20f83-6785-4410-82a7-506c594e487e@huaweicloud.com>
Date: Thu, 4 Dec 2025 21:01:49 +0800
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
 <ef8f934d-6792-4b6d-8f47-81f78edc1e93@huaweicloud.com>
Content-Language: en-US
In-Reply-To: <ef8f934d-6792-4b6d-8f47-81f78edc1e93@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXgZ4+hjFpGU1PAg--.34698S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr48CFW5try3Jr4UCFW5trb_yoW8CF4UpF
	Z8X3WDKa18J3s5trs7trZIgFW0yr1xJrnrZr4DKr17Zwn0vr1UGFW7AFWUu3s5tF4kuw42
	qFW5Za42qayUuaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j7l19UUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 59F1812001D
X-Stat-Signature: 7d1rhntbpszfkgbqb8mhtij8ocqbiwzc
X-Rspam-User: 
X-HE-Tag: 1764853316-625162
X-HE-Meta: U2FsdGVkX1/SQ5N7zDcODYtdAt6/Qg4EydQ3IHyDPah9/Xzl719/zGQRocYkZrB8h26dBdeCNKsCKCoNeDsdmK3oSIcQxVGqn9hrNXGS2+og969w7of2cTm4SCTHEeIsHeZpmdb6EkR/z7LXkUtjEVt1e5UxrmHSyrwx2zs0r7iVkIs5VxBRGZusZT5C+RCFGI0wUghlOzdIL3dyUwkIdHkisX3UX7ok6m5XugjC7quDDBsi1Zoi1Qb2cVVbRYnxE+sX7vHuGRhW+MJ3P/wPsoT+fYNbpJRZOK+tpuRzvQU6zYJJPbfGeUngr6GHAJjxT/RBFsR2XYI3FMa3RBfvhxzcffj8bHekkAaQXdNUGEHyzKm0OvjyUj1LJRp7tTracTf3n1CDehZnSLIv1qPvVFTtVW4lNmvQb4+cCy8Bzp/sU73tMPddq8Ayb5cRxAqV5ncp+JvdZmlHflZazp3Pd/CyDJY0nkZtF7cai//mRFOg7WClb4DXQi25D2m5ZWelLjj+RanBHunXuI89qW29ZLlBFknULBg9DSPQXzVscw+w6am086qxpPXhZIS4UGxZE9gCdV7TaujwIMQpiHe4wXqPD/aDkG5Ha/xTiEpZH0np1nYled/nogST3gpF43GZRftVZJVwS5GXVGg/WnqyXFBHsaad2gRm9Kuz3zk3phqkBx4JX5q3gfUBBNI3oy5MmAYIjZzlnDb/xLOgfU+NLwMziypNEYHH1kJyXQO59/LtHQ87FEHZCTUinJUrmHHKbMNbJb2VA8+PkqxfdXWmdiKhtXjdD2JdNrpcgl9PKYFsf5aj2oWiyfcd3tIsnJXQOAtQ39LTYPPK2S390kHhS+PG8btbk38dZbvJ5SRRiA1ZJEq7Twvakui5VJGg1hjgxjUrizrgEf3+CU/3IXbrJvzOcszPbGKpi7j3psEWDdXrQsAPziEzGvy47YsDjxCoM9KkdZRwiThBeTj7R+M
 HwtSi/vK
 oSllmfVr1Kg9B26iljwkZBxjnu6cFXsj1xISV4RSclRDt/GpebXe8NAJDEWGLdRUNkpPFCizbCh9IhSa8OW/JXCMqhWVBgCiOK7VxlDr8ZUGYxvpdzKi1eDq2psoDS2hqORR/q2KjC74u2ejS/9NINO0oqhW0ubq1SuJEVNdEFuvDblb+Kq0MmuaE1tuBAgg80TuAbPU6Z6EfD9RVyPaZJguu2RSXAzpFmFzT72u0oV8Cdbs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/4 20:59, Chen Ridong wrote:
> 
> 
> On 2025/11/27 17:04, Chen Ridong wrote:
>>
>>
>> On 2025/11/27 1:15, Johannes Weiner wrote:
>>> On Wed, Nov 19, 2025 at 08:37:22AM +0000, Chen Ridong wrote:
>>>> From: Chen Ridong <chenridong@huawei.com>
>>>>
>>>> With LRU_GEN=y and LRU_GEN_ENABLED=n, a performance regression occurs
>>>> when creating a large number of memory cgroups (memcgs):
>>>>
>>>> 	# time mkdir testcg_{1..10000}
>>>>
>>>> 	real	0m7.167s
>>>> 	user	0m0.037s
>>>> 	sys	0m6.773s
>>>>
>>>> 	# time mkdir testcg_{1..20000}
>>>>
>>>> 	real	0m27.158s
>>>> 	user	0m0.079s
>>>> 	sys	0m26.270s
>>>>
>>>> In contrast, with LRU_GEN=n, creation of the same number of memcgs
>>>> performs better:
>>>>
>>>> 	# time mkdir testcg_{1..10000}
>>>>
>>>> 	real	0m3.386s
>>>> 	user	0m0.044s
>>>> 	sys	0m3.009s
>>>>
>>>> 	# time mkdir testcg_{1..20000}
>>>>
>>>> 	real	0m6.876s
>>>> 	user	0m0.075s
>>>> 	sys	0m6.121s
>>>>
>>>> The root cause is that lru_gen node onlining uses hlist_nulls_add_tail_rcu,
>>>> which traverses the entire list to find the tail. This traversal scales
>>>> with the number of memcgs, even when LRU_GEN is runtime-disabled.
>>>
>>> Can you please look into removing the memcg LRU instead?
>>>
>>
>> Thanks Johannes, this is indeed a promising approach.
>>
>> The memcg LRU was originally designed exclusively for global reclaim scenarios. Before we move
>> forward with its removal, I'd like to hear Yu's thoughts on this.
>>
>> Hello Yu,
>>
>> Do you have any opinions on removing the memcg LRU?
>>
> 
> Hello Johannes and Yu,
> 
> I've sent patches to remove the memcg LRU and replace it with mem_cgroup_iter.
> I would appreciate it if you could take a look when you have time.
> 

Just adding the link to the patch series:

https://lore.kernel.org/cgroups/20251204123124.1822965-1-chenridong@huaweicloud.com/T/#t

-- 
Best regards,
Ridong


