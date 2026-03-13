Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123E3106FD7D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 05:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267D36B0005; Fri, 13 Mar 2026 01:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215776B0088; Fri, 13 Mar 2026 01:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6F16B0089; Fri, 13 Mar 2026 01:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2EDE6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:08:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F0EBC27D6
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:08:04 +0000 (UTC)
X-FDA: 84539858088.24.9D1E665
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf10.hostedemail.com (Postfix) with ESMTP id 12906C000F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:07:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=K9+yRy1m;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773378481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2fdojMM54qSgNsuFhPwacfFSNjW/hMMNErtovdaSec=;
	b=biVkG9U355ylp1KD0MXpNFnXTvnnfTDxfulyreFZqcxFGxtWQTbMXuxJyt6hXC3+rw0cn3
	hCBT6KA2C6/zokHr/o1DJLJU/RU1oWMFdYF8M/ZZnbVfNwILg1qaoDQ76DOuFELrrAmSAR
	oMY/haJxsq6+zD61FgadmC6QDM2D4qw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773378481; a=rsa-sha256;
	cv=none;
	b=GCFRtNf1KzNmoh+acKQdfySHRFTn9i3sbFKiEXERr0m6mtnrBkHMfueHGbWNFN89dPLgkl
	zMawoplTaxkLzltuboSEnAzIls4eFrf8lOpDiyGjQxrrAJeJscyyCwiazSlU3BP7dX9Yp+
	TFq7xTiaVGbYR2V6XqQf90aSzfijWvs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=K9+yRy1m;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773378475; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=T2fdojMM54qSgNsuFhPwacfFSNjW/hMMNErtovdaSec=;
	b=K9+yRy1maHL6dE99fG6FnmFTzHdPeR/Y2U5+rMAnH4ssIC2H0Y9pCjP5Q0tjqYR8eRmHzQIRbNXmbGWmA9z7fnpP/UDXYUg2a6pfR25aO1iHP5ymkh9cqxtxLxjSJqrNmF/+KnQXj3VaW9Ub+UtPRX2xYfXY08jHFkBsAKQA9Mo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0X-r.uEE_1773378471;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X-r.uEE_1773378471 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 13:07:53 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,  linux-mm@kvack.org,
  akpm@linux-foundation.org,  mhocko@suse.com,  apopple@nvidia.com,
  axelrasmussen@google.com,  byungchul@sk.com,  cgroups@vger.kernel.org,
  david@kernel.org,  eperezma@redhat.com,  gourry@gourry.net,
  jasowang@redhat.com,  hannes@cmpxchg.org,  joshua.hahnjy@gmail.com,
  Liam.Howlett@oracle.com,  linux-kernel@vger.kernel.org,
  lorenzo.stoakes@oracle.com,  matthew.brost@intel.com,  mst@redhat.com,
  rppt@kernel.org,  muchun.song@linux.dev,  zhengqi.arch@bytedance.com,
  rakie.kim@sk.com,  roman.gushchin@linux.dev,  shakeel.butt@linux.dev,
  surenb@google.com,  virtualization@lists.linux.dev,  weixugc@google.com,
  xuanzhuo@linux.alibaba.com,  yuanchu@google.com,  ziy@nvidia.com,
  kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
In-Reply-To: <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev> (JP Kobryn's
	message of "Thu, 12 Mar 2026 09:13:49 -0700")
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
	<3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
	<343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
Date: Fri, 13 Mar 2026 13:07:50 +0800
Message-ID: <874imkpba1.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12906C000F
X-Stat-Signature: fe3shmurcakqien1w5efski1k3mie4xk
X-HE-Tag: 1773378479-754143
X-HE-Meta: U2FsdGVkX1/cW0dzo5p0R4vzI5d4hXKnHmaiOJKQl5X0RPU5QhFUJM6NQIhr3ENrorris/XR6Mx3A7LAxqyAnrwDd5L84awZZs7T+sOmUpU1fY/SytEUC7LYteJzz+DPEKluWS+sIhGj7jUaHA1tBNB12MZ8opqo5suktJ4ErUZKCcExK2phi6IO6j7ih6ZlccYZuP9r/BlpdDZZtw92iMkcz6WLDU+tgm8aZzYDk5Swqq/qxSZvRGaUv58JMdZbE5vcmvvVTWa5JSfW/BhW96NEYDJidKTSICwTKwN36q57Dk0HFHghPzomgnMv8CDloOVxyEdTnvaYqI9xlFK6lRC7mcDVZ+B/wFeK4al17Dh69qwVglI3r1ZgnULMy8gBCdCNJlKy7HmCo+Zfy2VYS2ziXJ66pfGp/T5S3+34dhb+UmWPkcHqTcOCSl7IgtLlKKt3wdANGQ2SgfSLnpWLrjHJ/LWsVyTicvqQc1fHeqj/d58EyqmN/Jhld6nXYTygPP73C07yrpGGLD/d/Qq8zh8i8r63yGIbXc9Y0d17kPIl74U2vIrmluX1hSvVIUL2unnK3LWLLmZKxSiFCZY9CJz6/Qlfqo0zw0R0+xhcNFYkPrsbSLdYtPtErIvbYt84ciiY9TtSmVxP/5FdjTg6vn6r01wxqVUPUMtjBtFs7axP9rGMxyJ2KO8HxAgNKAfK6CoYC0Ak3M2dNj6l1z5aUBojqcThA4mBAFpZ20f5DOf8CWacK2CFsSCZz8fWYh2dPtcNVIW8nxkh6UuGkRqVNFzBAdjUnA3AOLIH6wJ+tEveQH8uinCafxzzlVaCZtB/FPWSPvU1Q5Qbnnc5UItxmi1cuqZ9icolrGuuzztLxTbNzm+xUQUuDqc/4fgaNrxI7mbLrlgX+oJsU4J+SfNzSTuR/TLibSMvk5s/Zrcf68n3p6sLbNKW0cxJ8iNX6zNTh9NBN03LDIVG9rOfSJ1
 fRW6ywV6
 GSzRILQWh7Ibjw9dejDa0FzrohynlWxDvh3K3EUGOox1sMhqRWduBl+9izXS8GMW/gPszF6IvdhNpY7msNZRY6GvkOYLRV8WodQ8bZQM3EUPzi5rFTataUzbOssGqukjKoJ9JuugVN4HphXJAt9SZKXB7gGSRe/oWL4TIFIAq7+vAyEIhiW22+/Jl5S7IBwEnKJcCmL6rxPigOndcD+XHsrj9irDMkiPnE3PyjDDb9sOr0OTBvKteor/1zaxXPr6j6peYG/Pwfp3+R4z/Vdjl1r4qdh76LMewoMYW/fiteXS9j/BNFEdBhq0fP1WhrF311zaJqEthOmMFCSZIMWGf2u9zTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:

> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>> On 3/7/26 05:55, JP Kobryn (Meta) wrote:
>>> When investigating pressure on a NUMA node, there is no straightforward way
>>> to determine which policies are driving allocations to it.
>>>
>>> Add per-policy page allocation counters as new node stat items. These
>>> counters track allocations to nodes and also whether the allocations were
>>> intentional or fallbacks.
>>>
>>> The new stats follow the existing numa hit/miss/foreign style and have the
>>> following meanings:
>>>
>>>    hit
>>>      - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>>>      - for other policies, allocation succeeded on intended node
>>>      - counted on the node of the allocation
>>>    miss
>>>      - allocation intended for other node, but happened on this one
>>>      - counted on other node
>>>    foreign
>>>      - allocation intended on this node, but happened on other node
>>>      - counted on this node
>>>
>>> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
>>> in /proc/vmstat.
>>>
>>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
>> I think I've been on of the folks on previous versions arguing
>> against the
>> many counters, and one of the arguments was it they can't tell the full
>> story anyway (compared to e.g. tracing), but I don't think adding even more
>> counters is the right solution. Seems like a number of other people
>> responding to the thread are providing similar feedback.
>> For example I'm still not sure how it would help me if I knew the
>> hits/misses were due to a preferred vs preferred_many policy, or interleave
>> vs weithed interleave?
>> 
>
> How about I change from per-policy hit/miss/foreign triplets to a single
> aggregated policy triplet (i.e. just 3 new counters which account for
> all policies)? They would follow the same hit/miss/foreign semantics
> already proposed (visible in quoted text above). This would still
> provide the otherwise missing signal of whether policy-driven
> allocations to a node are intentional or fallback.
>
> Note that I am also planning on moving the stats off of the memcg so the
> 3 new counters will be global per-node in response to similar feedback.

Emm, what's the difference between these newly added counters and the
existing numa_hit/miss/foreign counters?

---
Best Regards,
Huang, Ying

