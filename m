Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7D6CA0EE8
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 11:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2AB08E0002; Fri, 15 Aug 2025 07:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4D88E01EC; Fri, 15 Aug 2025 07:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAC28E0002; Fri, 15 Aug 2025 07:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6B6B6B0099
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:11:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1857014011B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:11:31 +0000 (UTC)
X-FDA: 83778725982.13.5FEFB0B
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0181B40012
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:11:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755256289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Gql3grWctAD9kAoPHIz8LeiAXnZHKZ+fqWnLH+g66A=;
	b=rVn42LdaMWwxHEGF83fyPdpJ/NhsEt3aiQ3pl1Duv1F0tFKjnwC7zTQCrVQKQzX2xHWgUT
	Ixolc4HC6ilUxuvhA9UWNftolLOROjta12iY7nUBE4ck8zzWUjLG2F4BBd2DnMOmtaw/7x
	hZwEM2ksaMnidAjUixlIvwbz/Rg/V4o=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755256289; a=rsa-sha256;
	cv=pass;
	b=gkOqm3HmnSsvSL8Mq33eMbazUl4VGyzMNDVLUltHJgjEtuX5KAaE1YBcjNatjJ54B/Q0Ag
	5s+oTxw23bKelmpXNYWrqOvnqMcQjPps1cpLsHoUMAF0/RF7vukr/xYEpmC6hYaSBviHGG
	BuI459GxLti+53f10qCFUqZkgJPboX0=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9E1050FB3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:11:27 +0000 (UTC)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB1F61D3520
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:11:27 +0000 (UTC)
X-FDA: 83778725814.17.3B1583C
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf13.hostedemail.com (Postfix) with ESMTP id 22EB920007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:11:24 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755256286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Gql3grWctAD9kAoPHIz8LeiAXnZHKZ+fqWnLH+g66A=;
	b=KqkSg8JLM3+yZqU0LZUR/rq9j74NqYJAZrZ4433V7qCI6SD5MuuiKrP2lk3o5lwdSdFKJR
	7Dd+9+AdNNqjFrJKq3pft26hOsuOm+AZUIXHCPPsS++lKZaFGpzuZ9Tsg25ieYceZUXExd
	ivCMGlQY3el0Wt7Jh0I7XpEr4YC5o7c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755256286; a=rsa-sha256;
	cv=none;
	b=cn4d0mP+tfN2IGMHw9fndgRuFR63TS3IdE6CqSeP3FF+Ad91uJae+skPgJxoiuQDl5vS0l
	KdjgpmDUpxdqU28BXqov6PBfK1zykSMc8Q0hIiTIZustxZr5fGayWE+dC4/Pkf7BDgoBZs
	bp+Z5rQ1teT4NBhTV7iqGjI5ZG4PMyQ=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c3K9B2y9mz2gKyr;
	Fri, 15 Aug 2025 19:08:30 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 4FB6A140145;
	Fri, 15 Aug 2025 19:11:21 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 Aug 2025 19:11:20 +0800
Message-ID: <dd536c65-0f00-4b29-9042-f1e84c374c81@huawei.com>
Date: Fri, 15 Aug 2025 19:11:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa: fix uninitialized memory nodes causing kernel
 panic
To: Yin Tirui <yintirui@huawei.com>, <akpm@linux-foundation.org>,
	<rppt@kernel.org>, <david@redhat.com>, <Jonathan.Cameron@huawei.com>,
	<dan.j.williams@intel.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <chenjun102@huawei.com>
References: <20250815103040.511627-1-yintirui@huawei.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20250815103040.511627-1-yintirui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-HE-Meta: U2FsdGVkX1+aS4Uhvz1Knt6nM6qSflJvO3C7xtosF1RWFGEzl3VOg30hTkE1kFc0aXd+TSRU987jPwIHdtmfobw4RaQPn1kPU+tRxC+yZOX/DT3LLFr2qgFXPP/bNXTnCvQuXH8FogbtxqHbC6JgEC9z7RTw5EqRv0lyW1nnN+MqxkfCV/hWH47Jx3EAtWYf4K+IXDiCq24XFS2a8DZFYKu4yMJ372JSJIbI6LfTTLWCj11DYYx/qzhrytCSJ01H47gQPzxFEQXUylPuggZ4AiM/wsBl0oZExigwwWQlVWMOl39JVDyoPzYOVbRywZD+49GewO7D1IYKAsqtxyh+C6Ldw0uTJt1Lt3RUKRxDqJjdqGjq3NVibeh8Yms3aDH5/lyfcPnuk5eWjcDBGeK80Ems17Ocmt1qVJWsa7PP5E0CA0TMS4gG9wrvcFv26wUzto5yi90osoyGw1DTHpnlEL0lj5ZyI5yQXn4uTj8pR0TGIayiXCm4hugJJ0g6LsbPKY+g2Z6s3gVvPMGtjeA5Z3IOLUKuq4T3EIXQyAovQylYM54GrO59xpxIp/gqvGi65M53UjQApKxXKwvyF7hEuO/FV/ophq1Ed/JB/mVKTnHKZ+rM33UsloO/jxSAe/yvPtfzEypyCCEmRkDUtI5iP2zLYYEMSrnb8PvEfV5H+/L/c1/Sf0C4nJ7BznXmffZzsIgaBcV0ApgfLBFSE6kXoiqSCl30gxGi2ymS9dilzvEH2XhUYIdX8/bfkcQuR1xpj83p64AHd9BK73yrEXRdxYYHZ91C+BIE/FXaUgbsGkNu+1jcMNn6X+AcyC65Dw118erlN2Mc4iP/TwgyovCWUpB7ikfZap8vzB9C5zs/AF/FL0w/fBJN8zgOgyvovdqKLXxs61ZZsZI=
X-Stat-Signature: oqf5qhboxryws4i35bd4zfsym5etxz5y
X-Rspam-User: 
X-Rspamd-Queue-Id: 0181B40012
X-HE-Tag-Orig: 1755256284-737261
X-Rspamd-Server: rspam01
X-HE-Tag: 1755256288-840820
X-HE-Meta: U2FsdGVkX1/BnWExbFGRgMMz/mfWtpkunOQMyQ9Wz0tWo7vFHocQjNn8iRmwLYGuVs5zw3hCFm7uHXT7AFY2oWam7Vtf8cZz+mXxje/BLoY4gL0p7tCAORyuX99d/+PCjCkiJgHLp5m0pTz/xZanoQUfzytEa3HSlEhgeQgZg60JVt8yDVL5HEXORAQajWfykktEOqGkJrRmqAKuWmXLbJc2EBYwrZtVbj2UB5O2j4iE16h5rxUbrbKBBQ61xRHbwnNkdDIVpAffCLAq2ErsQKzQxV1uJOfPHQADQWJ2M08kiyrU+QKg4NTun29qqykE9y7hOrN3l3gJByM8inMichYFSIEQXVNFiF7170vQZ+y9K8P0Cb3xDcHUOUHvlB4XjswXs8iRViw/JosFNw/GUD6L0a52rxsxOKVzrdey1ZeU7mmTQ2kSYxHqyIJ67GEyTPbUd/Kxd8/fGa8w2lyGu4WUXUZmGY+CAQ4ZgNDM+2GdK/vfubnxOMRZIYb2CPC2lbeQRYuQTfUN98GOG1oyFdo9Qu4SBNOh//A4XW6DF3ai3JZkNGb4SNq7EniQz5Orx364KiiqFfeMUMgSpDZw93SFLIwwALcvxgXfhu+2+Wa5VAWLWrdw6Qz3U4gnAyUbY3nihHRBXeRgy7aQwkRR+sLk6sH45JJJ9HYC9UGBIsBfGPzywmafcOk/xLVxy8cHF13WZ3qGa+HvGKdGWS13tvMWmrCNZzkcU1uaBgIV1FStjZxXIkfd9pn8Vksrow0WayUfwYL+zZxIsCYIae6N7UPN7117T97iX14vEPfkSr4MF4d+P2h3noO02d+Xawp0Rrvlu9isB3m5yUsRA8vCuUKGkmKRWTR+Y1Ue20o8H2xDefkUdqoUS8leYWNPXIbRntf9OK9rd01PuvCFnc9/pXkaUbwSavMCVyojzQx1ztMnPX6+l8vt3I6bQT13i39aEG+3YaZt0NBUTErtFE2
 sNRww0HM
 sxjtaZC70eMdziENM+UAfwJxWK67Y34iPO6Q/Mm5wzHWptulRZKNfdBMlN6GpLRM6uQmuo7U25U+tWvAOP0hvafL3aNP8NElG0Js4JZaBCTuf5SRaEs3P+h1td0BPR3kzYKSquf5xggspUERuHVagNEMyvOtW2SUzk018lw0mCMYHG7j5V+zBHOVq4OOkphSKuEt4YfY3ch1jsvvBQirHs3yo7exAxdZqKfH70B5QdkVCoaMFPUNeJ/i+Oa3wEXZ9bAaR1oRjoDfVPN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/15 18:30, Yin Tirui wrote:
> When the number of CPUs is fewer than the number of memory nodes,
> some memory nodes may not be properly initialized because they are
> not added to numa_nodes_parsed during memory parsing.
> 
> In of_numa_parse_memory_nodes(), after successfully adding a memory
> block via numa_add_memblk(), the corresponding node ID should be
> marked as parsed. However, the current implementation in numa_add_memblk()
> only adds the memory block to numa_meminfo but fails to update
> numa_nodes_parsed, leaving some nodes uninitialized.

The issue is not existed in ACPI NUMA,

     acpi_parse_memory_affinity
       numa_add_memblk
       node_set(node, numa_nodes_parsed);

so we only need to fix of_numa_parse_memory_nodes(),
> 
> During boot in a QEMU-emulated ARM64 NUMA environment, the kernel
> panics when free_area_init() attempts to access NODE_DATA() for
> memory nodes that were uninitialized.
> 
> [    0.000000] Call trace:
> [    0.000000]  free_area_init+0x620/0x106c (P)
> [    0.000000]  bootmem_init+0x110/0x1dc
> [    0.000000]  setup_arch+0x278/0x60c
> [    0.000000]  start_kernel+0x70/0x748
> [    0.000000]  __primary_switched+0x88/0x90
> 
> Cc: stable@vger.kernel.org
> Fixes: 87482708210f ("mm: introduce numa_memblks")

I think the Fixes tag should be commit 767507654c22
（"arch_numa: switch over to numa_memblks").


> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---
>   mm/numa_memblks.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 541a99c4071a..1dfe434e71b5 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -197,7 +197,13 @@ static void __init numa_move_tail_memblk(struct numa_meminfo *dst, int idx,
>    */
>   int __init numa_add_memblk(int nid, u64 start, u64 end)
>   {
> -	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
> +	int ret;
> +
> +	ret = numa_add_memblk_to(nid, start, end, &numa_meminfo);
> +	if (!ret)
> +		node_set(nid, numa_nodes_parsed);
> +
> +	return ret;
>   }
>   
>   /**



