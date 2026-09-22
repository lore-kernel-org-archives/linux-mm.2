Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1627AC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2FC56B00A5; Tue, 22 Sep 2026 05:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D016B00A6; Tue, 22 Sep 2026 05:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44B46B00A7; Tue, 22 Sep 2026 05:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1EF6B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:52:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5E09C03F7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:52:31 +0000 (UTC)
X-FDA: 85240933302.23.6793B87
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id C08D3180003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:52:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zw2JRtKc;
	spf=pass (imf16.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790070750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLXPio8neK/XWQ24/aYWgPbiu1ZOhj0GPf/ayqaAKLs=;
	b=LTYTTiaPMGLrG00VjkvJ2MJq6DDd8QE0GGr/EVtijYc9/oqWKuH6AzST+ctOX0qyFec/19
	mZ8C3DX63tviicOO+N39hT3yVJYK4AkTiS777gdK6DhbP5hcbn/fiC//zgQAopyRX5PxS6
	xr82qAIYX2wrR5ZD8i14uJHMROG7bEo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zw2JRtKc;
	spf=pass (imf16.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790070750;
	b=rXeAiUW+MD50E6CdURNvcDYKVOzD3FCLH9CIdtw7rG45YdSXuGBedwSH3M1iAhY9BBgMva
	Gf9UrbvghNgwAdRB0Tse/NNfXI9jYEWtFrVi0ODwAaaFydMQyz5br5ZWma3bqgDC3wWRPH
	wZdFvJXGgD3S1OHUAn5yrJ6PuJ+2yWA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790070746; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uLXPio8neK/XWQ24/aYWgPbiu1ZOhj0GPf/ayqaAKLs=;
	b=Zw2JRtKcF2dO5xYO9nlE5Sm0UvcVuflk/uSSou3gukI4XsuDIMNdJQlgbSJu/iGaD8QZ9sfBN38joaLq29N7XXE9zNxgEyglAYzUAXEa/Pq9CzXoX10/yhb2Pmmf5Qi7K0GYaGM+O6pQ8olECrgtjpYGNL4IfAJ6HgVHa0DXBOo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XBTMM3c_1790070738;
Received: from 30.178.68.4(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XBTMM3c_1790070738 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Sep 2026 17:52:22 +0800
Message-ID: <db317551-0b1e-40f8-b265-d00d65653089@linux.alibaba.com>
Date: Tue, 22 Sep 2026 17:52:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
 <20260910153418.e818710d3c35aa075f1156ab@linux-foundation.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20260910153418.e818710d3c35aa075f1156ab@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C08D3180003
X-Stat-Signature: po34479s59zqwpn7bzcc9i65gxobfanz
X-Rspam-User: 
X-HE-Tag: 1790070748-879614
X-HE-Meta: U2FsdGVkX1/EkDA0VmVwSVClN+yJBL0Anr8b+BIaoubmupCFObD6fvwpJ4soTKlh1bF8MR32B0RhLOBt6WKXVq5COqNPIfJ3aBWNdW062pvL7f6DSlqq1BHOb2owMeQ4tiicemnRX8MgrNVGV0yQXV+MOa+6xCAVRBlxVELWKLdHzGVthXZwouMmPTZDVm9gmcdMEwUsaMm8ftsi37cJkkjNMHyjxZu5En7X7WPHcKznDrfSuxU/W6Ah8eNER+u24Lm1fv5/lXnCl06NVt0tHBNOqYENbYLYM13rW6b7mpD1ze0kQMIbD4aZVUwYIBpct2zMq+WBQ7IB8TFLrgiI6zQ7VqAxuytu2R6REcOsAuOKbxj4rWq+t0caNgByUx31qtqkApKBh3b6620ttSGCGkDJb43wHTu5ob3uupKJyL+OS11zL6tZ/7s+DxwUGfqDTDElalzew/mKpN+0BulaWDwpnDEo+hUq6vWm9FzubqcuuIXZNdWXeNidaq7S52uh2Li/790CGEbvIFaujnyvJmllcPfBcS59GPr1/gDjhQMJ5xeCIvHOMyrKRcjih8FCfWEkdAwzjfnhqmC7/pdwPELM+E6st5CNuJCGk5SEF5H0EHP2eh2mTWmmxoiKasmCyFfXXJx8eF9f+OQts2JprX/F6m9cbcGwzYISTEYTgrQwX5S6yLsQ9j53vNsqDpfIsa/hzggFA6JOSy4iEdoBXmMBXpSx4e8nBpcJKhqu3iTEbGJYDFTteuGxdZcOmJZG4WomSSNSF2ZsC8WrsFwR39EKEwgvlSfHUzREpWjiEBmkkTEz2Qn7Xe+z5GdzUjvLtB8SNGEUc8KTRi5Gex6JdRJuODSJZgOCMWsc+q9/iy8TWCTD5E5gEw40nLZr5YcPqHFQrKobfylYK5pR/wlNVo36I40ikq4VRsE/OEeTqYIJCa+yySSUqqclTMVaF83Dg5Ncvf834a1Tt1hKJ4A
 KB6G89xM
 1dDAovNju6ENhLo3Oevlnp2+RDcN7D5xeEzbgMavIObPb8ye+xtr7ivo7mKXYynPGkroMZ19ojS3+y/txmOBIyLY90jgZWvC6V5qS1IdcdECHxstHGHRXhgTodszvFMEIRzyqs8RZwR6BZqVr46y6kh4r4HRSzh/MzC3QHv3vdfMB0tRVOMeecCeOdikZbxPjp5GrRduYuQbIN1ryC7WbUYZHnR24BYP1yV3BM0q52VrDAB97Y0aHzw0+lEpmyElWWpADEKcVpgvYO98vBbKF/x1cFvpcNcXQvkAbR+g+PU4osyc8/JYBaX4O+mNr2UtNLehmRKIJ7/PQ+GwGUtX/KrwY2vi6TKBYclee0dvqpw2uo6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/26 6:34 AM, Andrew Morton wrote:
> On Thu, 10 Sep 2026 16:07:18 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
>> With cgroup.memory=nokmem, the THP deferred split shrinker and the
>> zswap shrinker are degraded in two ways.
>>
>> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
>> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
>> limit-induced reclaim of a cgroup neither splits its partially
>> unmapped THPs nor writes back its zswapped pages.  v1 of this series
>> [1] restored the flag to fix that.
>>
>> However, as Sashiko's review of v1 pointed out [2], the flag alone
>> is not enough.  __list_lru_init() also collapses every list_lru into
>> per-node lists under nokmem, so even with the flag restored, the
>> objects of all cgroups share one list per node: the per-memcg
>> shrinker bit is only set for whichever memcg happens to repopulate
>> the empty list, so pressure in other cgroups may not even trigger
>> the scan, and when it does, the scan walks everyone's objects.
>>
>> Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
>> list_lru"), THP had fully per-memcg deferred split queues embedded
>> in struct mem_cgroup, working independently of kmem accounting.
>> nokmem only opts out of kernel slab accounting; THPs and zswapped
>> pages are user memory and remain charged to their cgroups, so
>> per-memcg reclaim is still what these shrinkers want.
>>
>> This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
>> memcg aware under nokmem:
> 
> Thanks.
> 
> It seems that Sashiko still doesn't understand that memory allocations
> in __init code are considered "can't fail".
> 
> 	https://sashiko.dev/#/patchset/20260910080722.3961351-1-qinyuntan@linux.alibaba.com
> 
> otoh, failures in the functiond which hugepage_init() calls might be
> caused by things other than ENOMEM so I guess we shouldn't zap all that
> cleanup code.
> 
> Anyway, that's unrelated to your changes.
> 
> I'll save this patchset away for later and shall await reviewer input. 
> Please poke me in a week or so if there hasn't been any, Things are
> crazy lately.

Hi Andrew,
 
Thanks for your time looking into this series. A gentle ping, as you
suggested. Please let me know if anything else is needed from my side.

Thanks,
Qinyun Tan

