Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB98AD44160
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 10:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1095D6B0005; Fri, 12 Dec 2025 05:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA3E6B0006; Fri, 12 Dec 2025 05:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11EB6B0007; Fri, 12 Dec 2025 05:15:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E09436B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:15:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7E821A04BB
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:15:37 +0000 (UTC)
X-FDA: 84210412314.11.D541ED4
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 30EBF120014
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:15:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765534535; a=rsa-sha256;
	cv=none;
	b=IaFETTMHORtxqG1keNBWsENgftk7IgbgA0wLR/cQddv9cjyhpEDYEv68pe+AXHnlIHpnlI
	Bq3N1Pvv0p4QoMacj60s3xs7Sc6VNUSB/HDmGjzm83BG4ZJZCfuX7pPRLGbG3ZtOrcAg3R
	bn2iP88uJaJjwGUHvPKyuJ7AnLPpNIw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765534535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNvmySt7X8q194zRoeeRFkFhmCkwpWfxUHT2QHcboxs=;
	b=RspYmIvhYgm+TSy6iTWlFAl0nA+QA7RtJEP0N+IXf6MWXNJC57fDBGfhXZOdBZGZ/EJcPC
	dayHgMM1LG7UuQ68pks161BkTcRxcpckLeKxYVIRwWIX+VhGUxaH+Ia23OSFUR/sbaDbBq
	0ZrnjT/fVdHYXt06ZuNqGnokceEjWVY=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dSQLk2Y6BzYQv5w
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:15:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A551B1A1A5E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:15:28 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgCHwX096ztpFD3hBQ--.55276S2;
	Fri, 12 Dec 2025 18:15:26 +0800 (CST)
Message-ID: <3eefcf06-e33f-4f5f-bba1-6d53ddc495d5@huaweicloud.com>
Date: Fri, 12 Dec 2025 18:15:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 0/5] mm/mglru: remove memcg lru
To: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com,
 zhongjinji@honor.com
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251209012557.1949239-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCHwX096ztpFD3hBQ--.55276S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4DurWxAF4xJFW8tF13Arb_yoW5Wr1rpF
	Z3WasIka1rArW7X3Z7KayUu3y8Za1xAw47Wr92g3yfArnIya4ktr47tw4rZFWUCrWSqry7
	Xr98u3W8XF1DZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Queue-Id: 30EBF120014
X-Rspamd-Server: rspam04
X-Stat-Signature: wag8yh5ozpm6bijygryzmhek13e7hm6i
X-HE-Tag: 1765534532-308233
X-HE-Meta: U2FsdGVkX18dZxSVUx8wgsDhi5Xe8GpMTspQVlppr0uhr/Geinry2NYEIfrS6VpGE4pCQDsX+2rO2mYCit/G+554iRMH5xQb/Zyk8JnTSJHRPVzQ1vr6WIqoRc9sro8Y/Z3dgc33nrbcIvt9fmzIXuvWw83nFMeXwaBL2cUFAI0KOy5g+USeKUM0SvvFn6Ghy/9D61X6rtTxqEv7l+yjHL8bPGO4O6MbjI43kdGSDzdB51PN8Iq68PTcvnr2lrYbPsUYG+TGPxJA8JcIEJrsdH7YUZEOAqCW6xyla1sgsh8Ny1BwaUk+eAJgbK/uZdtzeWRzFHKBnUeQz2yKpIChbyIQM78+iO4MDRDyk1AXcEKQIK6jxJgyeoIvV6TBariWtNnkm8pFIe9MtF7yLpKe3LBU1ngHBbVet6SyDGrpq2HSvtcWHON0SNW86iWlLnuSDlEXs4k9tOxCyF/aMf46VDHXgtB+OcSScMdIp2LB1JUCJzMHTSAheSwG/oX3mf3cQT8bKoawRkyq39SpWfqyMqPkaj8zelN0lm1rFSvc+S8SFVOzE7vbVheLhCnlfD7zXKyOlAvajQmgq5INBhFkcskGP90MaNPh1QOWcxvT8eN78rorTmEvrXbXKH4u2QOx3kTbKEbYIgrmkm0s3AIV/CJpmcMfBlPemwOdbUX+W5NysRvQ8bd68qC8bx0qGx5/SiLWUB+2RZZcs62B3aiLQ4pU4RJsiZ7KJpN3zweqF681DMYvoUi72yzPu+QOM54YuzykyL3Zy88G+ajzyHfYFHrxqI5bcn+JubXANCn5iEAG1WzrVB4+HwbKzQtdlr+VklNKazr4d3MvkFbbQ8IAmudkA/PtQ4/F0VB8MNK6YPmWfK5nOgc2D5ggrTr78TNLSswVcRnrndFj3kQW/LUlHLHprI7P3kyLkrlvQviS6hzMXdEnoeVYvS5Aqyr4CSXcBI+YKYe+rdSvqFuq+QM
 UjYpFUM8
 mhc1cHIdrdpAkfik50vR1FohmQS0WklgumwUMhLQoI/4uZTJAcC6j7Hittx3hXzcp5rVu5vGK58RK9QcKoXGjmhM7mQYvJFeLWayS8ouSvMxsL+4wX+J0UKe9XSOY3o2mG+2qAnYMDTAlEmyu4gIq7Pfs3E3QIjarUTVA3ihwO8bJrFii158btr7y7oW9geKTeI3DZwUvnsk/bgq5sHe7DL0DNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/9 9:25, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The memcg LRU was introduced to improve scalability in global reclaim,
> but its implementation has grown complex and can cause performance
> regressions when creating many memory cgroups [1].
> 
> This series implements mem_cgroup_iter with a reclaim cookie in
> shrink_many() for global reclaim, following the pattern already used in
> shrink_node_memcgs(), an approach suggested by Johannes [1]. The new
> design maintains good fairness across cgroups by preserving iteration
> state between reclaim passes.
> 
> Testing was performed using the original stress test from Yu Zhao [2] on a
> 1 TB, 4-node NUMA system. The results show:
> 
>     pgsteal:
>                                         memcg LRU    memcg iter
>     stddev(pgsteal) / mean(pgsteal)     106.03%       93.20%
>     sum(pgsteal) / sum(requested)        98.10%       99.28%
>     
>     workingset_refault_anon:
>                                         memcg LRU    memcg iter
>     stddev(refault) / mean(refault)     193.97%      134.67%
>     sum(refault)                       1,963,229    2,027,567
> 
> The new implementation shows clear fairness improvements, reducing the
> standard deviation relative to the mean by 12.8 percentage points for
> pgsteal and bringing the pgsteal ratio closer to 100%. Refault counts
> increased by 3.2% (from 1,963,229 to 2,027,567).
> 
> To simplify review:
> 1. Patch 1 uses mem_cgroup_iter with reclaim cookie in shrink_many()
> 2. Patch 2 removes the now-unused memcg LRU code
> 3. Patches 3–5 combine shrink_many and shrink_node_memcgs
>    (This reorganization is clearer after switching to mem_cgroup_iter)
> 
> ---
> 
> Changes from RFC series:
> 1. Updated the test result data.
> 2. Added patches 3–5 to combine shrink_many and shrink_node_memcgs.
> 
> RFC: https://lore.kernel.org/all/20251204123124.1822965-1-chenridong@huaweicloud.com/
> 
> Chen Ridong (5):
>   mm/mglru: use mem_cgroup_iter for global reclaim
>   mm/mglru: remove memcg lru
>   mm/mglru: extend shrink_one for both lrugen and non-lrugen
>   mm/mglru: combine shrink_many into shrink_node_memcgs
>   mm/mglru: factor lrugen state out of shrink_lruvec
> 
>  Documentation/mm/multigen_lru.rst |  30 ---
>  include/linux/mmzone.h            |  89 --------
>  mm/memcontrol-v1.c                |   6 -
>  mm/memcontrol.c                   |   4 -
>  mm/mm_init.c                      |   1 -
>  mm/vmscan.c                       | 332 ++++--------------------------
>  6 files changed, 44 insertions(+), 418 deletions(-)
> 

Hello all,

There's a warning from the kernel test robot, and I would like to update the series to fix it along
with any feedback from your reviews.

I'd appreciate it if you could take a look at this patch series when convenient.

Hi Shakeel, I would be very grateful if you could review patches 3-5. They combine shrink_many and
shrink_node_memcgs as you suggested — does that look good to you?

-- 
Best regards,
Ridong


