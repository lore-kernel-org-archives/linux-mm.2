Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF46D5B87A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 00:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73D86B0088; Mon, 15 Dec 2025 19:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6FB6B0089; Mon, 15 Dec 2025 19:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6306B008A; Mon, 15 Dec 2025 19:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8766B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:46:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F9B5601DE
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:46:11 +0000 (UTC)
X-FDA: 84223492542.15.96862CE
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5B3491C000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:46:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765845969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFwf0Cz8Ds/9SlIOudAhlLkA1I+suJ0nQqlbDp0m040=;
	b=ICDvQquo0QPbeq7fGLvwcXZdRFCSBmHfajPOd0hyZguimGDyrJWjkti4ys3aGf++TKxCtd
	9NqBsCsZmLlcCdRlb9xI+oUeLXEY4ix0LQeqhjK1UUhKPiOlzA/0+N7DBS7V95yia+7Jjp
	KmyX/+36cQxLmymF6/RB8koAARoidFw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765845969; a=rsa-sha256;
	cv=none;
	b=0zU7yRkXFODWtPKuD9nPM0lmo62zFcNME6toiYTdubyhoEt7AFuOe2kg3KkieB4f1aAUGG
	ENrLMqMrgvqTqWI7HWcHjWaL1UBh0HUkMI8CwpheNpGKBoWWXgVhpKeRVOrLg9BMsltrPi
	n8YSgjiwiz4ou+dwfE1gxdZUUlw6nw0=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dVdWg1GNxzYQtkd
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:45:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 865B91A019B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:45:59 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgBHYH_Gq0BpmudUAQ--.49701S2;
	Tue, 16 Dec 2025 08:45:59 +0800 (CST)
Message-ID: <9c5a5020-107c-4521-9402-41e614bd2803@huaweicloud.com>
Date: Tue, 16 Dec 2025 08:45:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 0/5] mm/mglru: remove memcg lru
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com,
 zhongjinji@honor.com
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <oa62a226nagmrqbc23kys3yw3ouxkn5spcizyqqevsuhkurbsv@tvvwqlgu5yum>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <oa62a226nagmrqbc23kys3yw3ouxkn5spcizyqqevsuhkurbsv@tvvwqlgu5yum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHYH_Gq0BpmudUAQ--.49701S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4UCFWfJFWkAryUGry7GFg_yoW8urWDpF
	Wvka48Ka1fJry7Jrs2y3WUZayY9ayxAw4UAr43GryxA3s8ZryFgr4Iqa15uF4kCr48Wr1a
	qr1q93ZxXFs8AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam02
X-Stat-Signature: 9m5gxkzm6cnpy88pempuyc7yfajr1t6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B3491C000E
X-HE-Tag: 1765845964-431165
X-HE-Meta: U2FsdGVkX19dhiYYTD0duUy8OjjtXDL61UfeyZs//MzpMkgITPe8Z1LeZwWWTPpCOxIydEdiWycqzMAR9ARNU9thD5KD9fq8crJIAZy52jZVzbRA3MuPgFvMa973RR34gwJOoV3/qhE6jlbx1/xhIexXr//nx8p1bXxNpFg1bmp19PO0bCLlz4WkQB1MmoN4YNr64jiCl7W/iYh2e2jqS7n6I8lyQ41EJyo7Jjxc1S0qJyXzfW9h0fjocIs4Bca4FayuYxuqdjQUXCMIKw3ed+LLDjKGD7/lDtVaM4T+00dxBGhFZRucD3WHZ/sAHiH1CTgENkb3ezH7++S9gk08enCo2LwWYpCvkrMVQNm4qDc/1tFAA3nsL9BUcGJShqnU8szxxtos+qDrsV1JOkNVn3ClMv00hOTZW9GZYqazaexZwHBhOiZArWB9XUWtdH6WRQdPlKSDiQfPUAn95/esg1rTlVQdwTjjhaiLv94vo5TFUnVz0+Z1X4ShDHaw01X7/gr5DvabKRPmcLW5BMQfu4XnS7crANIkelTtmBwIi5AGIOaGaV6+4r/Ai20eUewHNIziKFg+Lp3LAKLGAhZX1aL353uxLxKq4yXQjRDYFiTD8sNLfI9YXpu439/ZBGDRujzsnIa1q8rVtTlwtkkNR/dIY6pa5IXQ5zZItbSIjHMtyUea7WakG51jtTR4j98jUhit3TZCuc/y+nxlMuTVA7bOdBai5tl8psDY3xRiFpZDKWHY0e31gG/28BMqMSW/k27/ZRPaZHsmpPW7qqMzoWOqUJRFyX7uY+V+xPbt/Sx4bBI0AAC2bzddBChUuM6f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 0:18, Michal Koutný wrote:
> Hi.
> 
> On Tue, Dec 09, 2025 at 01:25:52AM +0000, Chen Ridong <chenridong@huaweicloud.com> wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> The memcg LRU was introduced to improve scalability in global reclaim,
>> but its implementation has grown complex and can cause performance
>> regressions when creating many memory cgroups [1].
>>
>> This series implements mem_cgroup_iter with a reclaim cookie in
>> shrink_many() for global reclaim, following the pattern already used in
>> shrink_node_memcgs(), an approach suggested by Johannes [1]. The new
>> design maintains good fairness across cgroups by preserving iteration
>> state between reclaim passes.
>>
>> Testing was performed using the original stress test from Yu Zhao [2] on a
>> 1 TB, 4-node NUMA system. The results show:
> 
> (I think the cover letter somehow lost the targets of [1],[2]. I assume
> I could retrieve those from patch 1/5.)
> 

Hi Michal,

Thanks for the reminder—I appreciate you pointing that out.

Apologies for missing the links in the cover letter. You can find them in patch 1/5.

> 
>>
>>     pgsteal:
>>                                         memcg LRU    memcg iter
>>     stddev(pgsteal) / mean(pgsteal)     106.03%       93.20%
>>     sum(pgsteal) / sum(requested)        98.10%       99.28%
>>     
>>     workingset_refault_anon:
>>                                         memcg LRU    memcg iter
>>     stddev(refault) / mean(refault)     193.97%      134.67%
>>     sum(refault)                       1,963,229    2,027,567
>>
>> The new implementation shows clear fairness improvements, reducing the
>> standard deviation relative to the mean by 12.8 percentage points for
>> pgsteal and bringing the pgsteal ratio closer to 100%. Refault counts
>> increased by 3.2% (from 1,963,229 to 2,027,567).
> 
> Just as a quick clarification -- this isn't supposed to affect regular
> (CONFIG_LRU_GEN_ENABLED=n) reclaim, correct?
> 
> Thanks,
> Michal

That's correct. To be precise, it only affects root reclaim when lru_gen_enabled() returns true.

Note that the generation LRU can still be enabled via /sys/kernel/mm/lru_gen/enabled even when
CONFIG_LRU_GEN_ENABLED=n.

-- 
Best regards,
Ridong


