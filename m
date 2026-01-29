Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B6ED61006
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651DB6B0088; Thu, 29 Jan 2026 06:25:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5B26B0089; Thu, 29 Jan 2026 06:25:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1D36B008A; Thu, 29 Jan 2026 06:25:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBB26B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:25:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DE0C13BEA1
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:25:24 +0000 (UTC)
X-FDA: 84384770568.03.AA70DF1
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 581831C000F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:25:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769685922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVdwBllqpMJBK8t9LgCzUd+8mmdq576sh9lBHPQDA0c=;
	b=hXmY5i6S9Rq8XTplPplJ7xuA8Z6RqjE1GVNRH7LoCOzcgTsB11sNlKN14Rq86CVuzCKvkr
	vpymqJVhhfXROkc8/aR0KTFs2ZXQg0TAC36ehZgUUAJMddThgI4qYiksECytfQ57XwrPNm
	rMYf1OSLk9KkwZmqf0E+zx9QzIpAmmY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769685922; a=rsa-sha256;
	cv=none;
	b=kTwcMaNdgVzSO7+htKLN4TW5MZXcZiCeUcdpRwGR+kIm7rUefxoNPIcNG4S9fZyZX5OjOv
	cnH70HSsaVyeEZR1KCiv1EtGYz09VAvH6QNGEEXtqX1uDBcycO8GhoCXX0bfO2OTRNxq3B
	MTXmEZSBmgpry1OwuCWETpjTs338LDA=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f1xd06QdRzKHMj5
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:24:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CF41C4056B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:25:06 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgDXhfaOQ3tp9fodFg--.5236S2;
	Thu, 29 Jan 2026 19:25:03 +0800 (CST)
Message-ID: <bfba09cf-89d8-4ec1-9299-7128d79569ff@huaweicloud.com>
Date: Thu, 29 Jan 2026 19:25:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 0/7] Introduce heat-level memcg reclaim
To: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com,
 ryncsn@gmail.com
References: <20260120134256.2271710-1-chenridong@huaweicloud.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260120134256.2271710-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgDXhfaOQ3tp9fodFg--.5236S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXFy7WF18tFykKryfCw1ftFb_yoW5ZF4Upa
	93Wasxtan5AF15Aan7ZayUWr4fZrn7Gw13XF90gry8ArnxAFyvqr1Ikw4rZFWDCrWxJry7
	XrW293WDWF1DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: e13bz1mz8wz9c4nc8psngzqsrqtj8r41
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 581831C000F
X-HE-Tag: 1769685913-330519
X-HE-Meta: U2FsdGVkX18sZ5A1OAJwikc1IhByxcIr3iv+NIvd11Ks67wBhtOYrfteL/wChkvmQSaJfjl1BDeDHn9AdbafSGmTGiSPlmx9c3/ndY++1zumcCcysqx9vbH3lq3Rh4ziY8olZ56tnZeRau/R7Zfns9F1k65rQIVZU1zHHC3LrNSjFzhxd04AiSk7wqwbxpDXWKzBTNNF39u/9Q4n2Wcw7aZv/GGmDdlhgcDc+CEP4XYJXjCzkE2ELPTfO0mpA2/LEiBBS5IDNAZ4yZ5X3O8G4P54y3FHKOpEi0pClpiBA7sogDYRePRbGqD4oUopfzuz+4wztMwaOVudgwzRrpycnEQVzw0L53wh0S7FzPNAgVYCQ08z7vNV2vSjgWRZSoVSjpS9VsJiygxZstZps1FSozeCvDk0PU6BTa8RKL/SmQiquJcMFRXfUTFkyjcKDKnea5GdNXyDKW3SKXtLBr5vzymdpFt9wnLQczgB7JuKMj5MJo5XSXs11UTg83qpbikFVLzt9PP1M/yJeExDZI5e7POfdSE3/H92r/2/0R0Bd8z/jEOIli7Flf4HHXTwRW8gQlfUcf++A9b6595gSdvctQ9KfZojZX2WQPLCxF7JE2zWpya9v+w34mTgg8WLtNRwPLgdk8QwKeawQNtMxDPfCz0LUh8HOfzQ/di7ITC3t4ckesukORFsz3+kD2dwOvFni6q7xpSDvTdaIH1Pt0cPJixjHj2TQ9zldxHXj+B9cTC6pJjBdT/xnl/lZnRaylWR7WzYuySNKB2r92hBVQ2K3E4XU43W0WrM4nbJzU/jydBHNu4aPJ3FDANpOXyuAA4v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/20 21:42, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The memcg LRU was originally introduced to improve scalability during
> global reclaim, but it only supports gen lru global reclaim and its
> implementation has become complex. Moreover, it has caused performance
> regressions when dealing with a large number of memory cgroups [1].
> 
> Previous attempts to remove memcg LRU by switching back to iteration
> implementation brought performance regression [3].
> 
> This series introduces a per-memcg heat level mechanism for reclaim,
> aiming to unify gen lru and traditional LRU global reclaim. The core
> idea is to track per-node per-memcg reclaim state, including heat,
> last_decay, and last_refault. Three reclaim heat levels are defined:
> cold, warm, and hot. Cold memcgs are reclaimed first; only if cold
> memcgs cannot reclaim enough pages, warm memcgs become eligible for
> reclaim. Hot memcgs are reclaimed last.
> 
> While the heat level design can be applied to all memcg reclaim scenarios,
> this series takes a conservative approach and initially applies it only
> to global reclaim. The first few patches introduce the heat level
> infrastructure and apply it to traditional LRU global reclaim. The
> subsequent patches gradually migrate gen lru global reclaim to the
> heat-level-based approach, with the final patch combining shrink_many
> into shrink_node_memcgs to complete the transition.
> 
> Performance results show significant improvements:
> 
> Traditional LRU results (2-hour run of test [2]):
> Throughput (number of requests)         before     after        Change
> Total                                   1,734,169  2,353,717    +35%
> 
> Gen LRU results (24-hour run of test [2]):
> Throughput (number of requests)         before     after        Change
> Total                                   22,879,701 25,331,956   +10%
> 
> The performance tests are based on next branch commit:
> commit ef0d146624b0 ("Add linux-next specific files for 20251219")
> 
> This series has been rebased on next-20260119:
> commit d08c85ac8894 ("Add linux-next specific files for 20260119")
> 
> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
> [2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
> [3] https://lore.kernel.org/lkml/20251224073032.161911-1-chenridong@huaweicloud.com/
> 
> Chen Ridong (7):
>   vmscan: add memcg heat level for reclaim
>   mm/mglru: make calls to flush_reclaim_state() similar for MGLRU and
>     non-MGLRU
>   mm/mglru: rename should_abort_scan to lru_gen_should_abort_scan
>   mm/mglru: extend lru_gen_shrink_lruvec to support root reclaim
>   mm/mglru: combine shrink_many into shrink_node_memcgs
>   mm/mglru: remove memcg disable handling from lru_gen_shrink_node
>   mm/mglru: remove memcg lru
> 
>  Documentation/mm/multigen_lru.rst |  30 --
>  include/linux/memcontrol.h        |   7 +
>  include/linux/mmzone.h            |  89 -----
>  mm/memcontrol-v1.c                |   6 -
>  mm/memcontrol.c                   |   7 +-
>  mm/mm_init.c                      |   1 -
>  mm/vmscan.c                       | 547 ++++++++++++------------------
>  7 files changed, 231 insertions(+), 456 deletions(-)
> 

Hi, Johannes and Shakeel,

I would appreciate it if you could share your thoughts on this series.

-- 
Best regards,
Ridong


