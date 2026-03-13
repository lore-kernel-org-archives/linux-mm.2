Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B936105F784
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED426B0005; Fri, 13 Mar 2026 05:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5236B0088; Fri, 13 Mar 2026 05:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC84E6B0089; Fri, 13 Mar 2026 05:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9E366B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:31:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63C8F1D17B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:31:22 +0000 (UTC)
X-FDA: 84540521604.08.7C9CBD4
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6CB851A0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:31:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HUuvNVg8;
	spf=pass (imf19.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773394280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRDofVhihDUqLLlkY2UqqccMvr5aO/FD17akQhcyFyg=;
	b=ojFdV/cf7LIFnX4wMC2p+Trjw+hQb62WG8Rv+fJSmgHFWZwdb1U6CdBtz07ht7zO1EhxiC
	Xt474XhkZDTKuKxqo4qNOZLVrw+txm6R41hIPUQkK2SRboz/BmRONBK78sNLQaIEA6Mldh
	0Fcaf6RdC3vsHJWGxkCOcPCgCdBvH8I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HUuvNVg8;
	spf=pass (imf19.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773394280; a=rsa-sha256;
	cv=none;
	b=KxuadYnCG68tRt5LMb8uJGcIkGuiaz5UJQzi6DOg1AD8ZPlC0Nd62u3TtN9gRVbbU2YKLX
	MdM4EZE4ZrXawIY9/bAZ49YCude76fmqYcmAc46vcqNI7+TP39F1yK9ijBf99jxZ0rUI3B
	n+lm2DLG/ORTV64jr41hSPSDSHQY+NQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773394274; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=yRDofVhihDUqLLlkY2UqqccMvr5aO/FD17akQhcyFyg=;
	b=HUuvNVg85nTI5gjewat0rwGlmKVM13/ZyLKLP6n8ntGK2ndKzGdhQ0uKwmQ4Rk5H69kvvirU/CsCasUemQF7WuMm5XAdy0nWS8yAJA/oyfiDUmiFXikcfNfK+d7gVtltt2IzUDBBPYHR6HRUxkLYZ0iel4FHUU9rPkdJepkfS5A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0X-rqO9W_1773394271;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X-rqO9W_1773394271 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 17:31:13 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>,  "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
Cc: linux-mm@kvack.org,  akpm@linux-foundation.org,  mhocko@suse.com,
  apopple@nvidia.com,  axelrasmussen@google.com,  byungchul@sk.com,
  cgroups@vger.kernel.org,  david@kernel.org,  eperezma@redhat.com,
  gourry@gourry.net,  jasowang@redhat.com,  hannes@cmpxchg.org,
  joshua.hahnjy@gmail.com,  Liam.Howlett@oracle.com,
  linux-kernel@vger.kernel.org,  lorenzo.stoakes@oracle.com,
  matthew.brost@intel.com,  mst@redhat.com,  rppt@kernel.org,
  muchun.song@linux.dev,  zhengqi.arch@bytedance.com,  rakie.kim@sk.com,
  roman.gushchin@linux.dev,  shakeel.butt@linux.dev,  surenb@google.com,
  virtualization@lists.linux.dev,  weixugc@google.com,
  xuanzhuo@linux.alibaba.com,  yuanchu@google.com,  ziy@nvidia.com,
  kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
In-Reply-To: <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org> (Vlastimil
	Babka's message of "Fri, 13 Mar 2026 08:34:58 +0100")
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
	<3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
	<343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
	<874imkpba1.fsf@DESKTOP-5N7EMDA>
	<cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
	<60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
Date: Fri, 13 Mar 2026 17:31:10 +0800
Message-ID: <87zf4cnkip.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 6CB851A0005
X-Stat-Signature: t84zwy3qg6s1fezsbc85h3jcsm3hh9mk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773394278-750331
X-HE-Meta: U2FsdGVkX1/bWyAQ/aXWnmLNMpyu2GJTW+FPzbzMSdgu/moe67ebii2RLXbRfyvbyjyXwSN1UGqiP9q2Zj91+tQwFlBAKHh/0GnMLdAxhGtkbSsI3rP0kgky+zWR3kJyL1dKq/5bvI21vnY+C//SJzJRz6l8vPN9kxLJPs3LUjDeD2PDf5TwBbSnkOWE9ra8gwiJ3NGxOIWtmGOK/p9Jnpur4J1Gy4zU7wtv+iznI/+KZd+SdbY3qdykkpEInWPk48yeQxJeyktjAhvAMn2hhCNoo8kpJw3o/BIP9SYasi/9rK5miHFlSn8xH2l6EjlywuxybCkdzpqjF1jzY+jYFP6iYhv6FPTFjkyjJN3jUW/x7m1nM99x+BJQ6gCdd1rGc0u+CHrtG2LkWQm4I2yiNk+sYQY97GSOJJBSXXBOchsLblMkC92BX4g2jzx01mx4c+8GKlnVMIwlNpQmIL9ih0kRP+YtAzt5PDVFl+njlFYIhovQmq70yuk4k4eWbvYcpJ2hrUJ6Ts0NLoJnmX4cqBGW4C5oUzAypeTjB7hKr3uumtZcyA72jYA5w4WaTeJ3HwBeZEMPtPGF3k12usOZ70ru60CPaH4cY0SEneMGpqj5vA1Ih3ih5HzI24xV1HTlF8krYRvUFD8SzY0L8zCaifA6D1jSbZdlTSSMJfP4TheEKEgSXokXaUcUZ+faC7M54j3haah2AoC3oM6D3Gc3eDRItW9a5nIil6FjXtK5XPU5JherWmorgYLh4xfzxz5xI09u6QhM6OWhJJjcysWHcm4t4GnH7RmNWe3zR6JtKsfg62We+VZ1ptO1kc/1w2mdJkYwUH5ACyWzi7JlYVzseU+vQZ3Rn0JGuwDh0Y6PxDx01PMgJb19cKkbRSz/mfzJ68RKMe5Nnk8VgNLus0IJnzR8HSI+HWSSDYsrz8KR9lQ2338BhoaSXoZBM5yteZBNX2P7stZIlM+4LnhByj1
 M9B3A489
 4iLEz9PnucshNRfginRXeoltOb4j1QVErce+cDFNVTQo6ymC+KiDulsDgJqc/33byuNWBmg4ktt3n1XRG2ztxVbj/PQUWv72C0Mti0hkPlFpakzjd/TkjelL4XliwffFlhsQO0B9jO6GHBAmjEUHBc7XnCjtyfibTZOnFYtOZPT/0vS0IJtLh0P/aY1XXE2mpVbw9gtvu/AZne2geddRFJwKObWMOkncN74NEPyJi11zBqwlgZBv7ESrc1uYfpYsHwyFMsc+lI1tO7uaMqoFnbBYOLnK1MDyxzxYArL2sU9MIeg1IM/TVOsd8CndzlkNZZQ6MHcyZ77R1Afw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Vlastimil Babka (SUSE)" <vbabka@kernel.org> writes:

> On 3/13/26 07:14, JP Kobryn (Meta) wrote:
>> On 3/12/26 10:07 PM, Huang, Ying wrote:
>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>> 
>>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>>
>>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>>> all policies)? They would follow the same hit/miss/foreign semantics
>>>> already proposed (visible in quoted text above). This would still
>>>> provide the otherwise missing signal of whether policy-driven
>>>> allocations to a node are intentional or fallback.
>>>>
>>>> Note that I am also planning on moving the stats off of the memcg so the
>>>> 3 new counters will be global per-node in response to similar feedback.
>>> 
>>> Emm, what's the difference between these newly added counters and the
>>> existing numa_hit/miss/foreign counters?
>> 
>> The existing counters don't account for node masks in the policies that
>> make use of them. An allocation can land on a node in the mask and still
>> be considered a miss because it wasn't the preferred node.
>
> That sounds like we could just a new counter e.g. numa_hit_preferred and
> adjust definitions accordingly? Or some other variant that fills the gap?

Or can we adjust the semantics of numa_hit/miss/foreign to consider the
preferred nodemask instead of the preferred node?  Is there some
programs to depends on the current behavior?

---
Best Regards,
Huang, Ying

