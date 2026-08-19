Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8634DC5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E856B0093; Wed, 19 Aug 2026 05:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF7D6B0095; Wed, 19 Aug 2026 05:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5AF6B009F; Wed, 19 Aug 2026 05:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA986B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:19:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E232CC04DD
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:19:00 +0000 (UTC)
X-FDA: 85117469640.13.2DDA3B0
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf30.hostedemail.com (Postfix) with ESMTP id 89FCE8000E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:18:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TN1QU1po;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787131139;
	b=dkETFkVmvlswkq2ku17fNl229GQZ5nYu5qzFU8IMouM9kiyV8XuMj7I6YWkMXfzESBy+IS
	XIiWs2L+hmWfzMVdgQrWmkLCR3eFgZy21TsRYVSkjoH2HCJjnUOBqPSdN4eo/5NvFnpLDx
	ALf/KOcGI++rkKrULPnWfhDLeb3VXno=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TN1QU1po;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787131139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUkUEVNocOa8i2pwhU3EAXuYAIwF7UnAwk/Wn4nSKBQ=;
	b=c4OwUeVjHZCFvefaasmRmsoyxPHcLSdydcg+jd2QUCf/EI8eYx+7NjUhICOc1LtPHD9KTw
	31NF0u3gYk/uoQ7swNjCBcdcJASJTAKqxxl6Z6s9az0M1F/ACCoqBo4gIa9t2zNLjV2pg2
	7cFvB09YsMyu5s3xWlo31TucHHXuKxM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787131134; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UUkUEVNocOa8i2pwhU3EAXuYAIwF7UnAwk/Wn4nSKBQ=;
	b=TN1QU1pob6/xlvHoA16lx5JrcDUboceEvTsxFd2i6mNEvu2TXWYOyu7vjMgSMDhGmxW27UC+xq6Cz+TTx4HlY7VyBOMwYiP1Ri8OlJCIKzIgAp5SuDrTlxK7D4j7ktyH79N7mJzYyx863xKcMS9bAkCStGt44q4fc56y27Thiss=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9GGcxy_1787131132;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9GGcxy_1787131132 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:18:53 +0800
Message-ID: <52215f41-9297-4197-982c-bec01b485bb7@linux.alibaba.com>
Date: Wed, 19 Aug 2026 17:18:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm/mglru: move max_seq read into walk_update_folio
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89FCE8000E
X-Stat-Signature: 81xacc3ubr7yfko9i4yw9nwyt4bqyihi
X-HE-Tag: 1787131137-942194
X-HE-Meta: U2FsdGVkX19REg1dRpHIV0kXXEipbVvlia4PH8iqFnwu+SQb+gvnfzJknUGT40k4jOYrTQU3yCiuoTFsIuigiDTA2ZzJUA87O8V8HsHxdaLgZKoxjGpV533HBxYGqKBjj9TyV/hXxZoNPQjub/YOkQCLMJDZECO3WK+kodxRBV0jEeVh11hTBWb4mL2uAYuHllZ2peszW2k5kmOBJBgASC7wO+dLJ98ttzw++clTuyKeuTdzNVs6fnJoLlSWnUzuaMqsljqPObqiNmrBDFdwnI/YPQSpofNRoz1S7sTbEJcvtEtUnYK/5zoA5pIUMhmTY3Zq+dAXpcblclavyFLQ0j3EbaqJkxS90/VWtiHYwogOQAE04FSsfVrhViO3/fy+7r5JLcaFc4fDi3AHg/boS88wj5sT73qJyfeZkVHE93Ch57OjnCpX+2pOFMQ0PRTRv7h8JSpaiciFDHWmXfjVFaD6hQ+MC02O7DG7WgkI17fx0160mTXk0SiHfjO3xTNABKWrqTYvEIcktJfaNb32UIkIEuGnGrW0YfQ80YlD7LI0Kt/CQsWEJOcpQtyg5XjklYiYQLahhk2W6kYStdsyH534fgLgQmv110hy6sX7Xg/bbgwUwvHJSOXhGLR3ajN98BXabwO8kmQ52vuyWNwzgUDIMIIJZ5uT6ec9SrlMIePVRiALeGuvtAHKlu2y7v1eLiMdfRSCyrT+pjTNBzACY9721DvCLh7gxcVfuxtAmVkErASkcQ2jdF3I5YwBUIZIWNApB+HmfT9bLYfPtCFyM0WbKVyNsnNgGQDufazFFwqmpA6iLcoCkLxt/uQcdQBmkBRyvvI+iadh1S8FckauvhxHl+Za8OZRj3VMavO8tXkFp8S1pEqBxjknIndRhLUixPOU6Pqhyxqy/iL47ElfDDeukd7C7wQfqgj9m6rfPVOjoPU3w9JubOALpdi8sW9lLWPUQfbNV5vcOlgq/HK
 OB970Tsi
 2Mte4Klf87awMvyhyeP4OYGioPSH+Ue0TjqcfPKHZAjj6bBZWmvyZBytDZdYOheBRJEcQGHjX3cjCQ4tVKnFZ+y5dAtLLd78dYxiisZi1lhKfjYxrEllKTPTdQW01xzKWZnvbPO7n2I8cC0sGgiWd4ctlh6KpzF1zFAKv/cqm6PpuYK1MdoaA9hVZPkcUPOKO2lVEJyGD+8qrR94YAroLRFy+DdKgxQjCgyNJtnrVsoSlN3KcH6uukr/4hdzUHLENB3PArFf322/JG+sXeZo/5eaoeRoUm9ibrSWgpfXgdlHD1sV8Yw/yd/mzH9b8Mz2GQoEoEreGFdqRMNxS/FrZ8G3VPrs4kBXfel6smHdKfZ+X7BNkGZDMInmRzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> each read lrugen->max_seq to compute the target generation used by
> walk_update_folio(), then pass it as a parameter. Move the read into
> walk_update_folio() itself so the callers no longer need to compute
> or pass the value.
> 
> The max_seq read now happens once per folio update rather than once
> per walk range, so folios always get promoted to the current youngest
> generation.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> ---

LGTM. One nit below.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/vmscan.c | 29 ++++++++++++-----------------
>   1 file changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 080132997d87..a819be6b7ae9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
>   }
>   
>   static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
> -		struct folio *folio, int new_gen, bool dirty)
> +			      struct lruvec *lruvec, struct folio *folio, bool dirty)

IIRC, MM maintainers prefer 2 tabs, which is why I changed this earlier:)

