Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37A6106FD85
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 06:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDC06B0005; Fri, 13 Mar 2026 02:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BCC6B0088; Fri, 13 Mar 2026 02:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787136B0089; Fri, 13 Mar 2026 02:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 694E76B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:14:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 126A4BB6B3
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:14:52 +0000 (UTC)
X-FDA: 84540026424.17.36D6B68
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0C308160005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:14:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uAFdS55K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773382490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTOLkQVeVRERnDaN2DY/VOKpnGSBVqeHDpUKHThv08w=;
	b=b4NiiFeOWUdeuJkNjYfUZRlwIzANd0H+Dyr1s6CGYmCDtP/USo+wOZgF9CcHwX8lFLhLkf
	qX1P7kHBDlsTxDruaE/s8ByVxcsXsUYnsE0QLFAIWVZcTTCtdiKIYlIepIYyC/D5hMDoUq
	4+ol3QO+0qOz59Kt7G3xbDLNQv/sFZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773382490; a=rsa-sha256;
	cv=none;
	b=L92iGyvjO+eU1SMxUEHnE81NdzzNL8Dm6tAirgaEPqk2vWClthil1aVpJGWM+0+PFB/8lk
	IzQd6sBUoNyqV3dh575OD313xKmMHfwfv1vSk/nxIedB4Gf7SyOGzz+6UUeSTcO5kusSkL
	YnSTEJEHv4vemhF/fZaIaCuvrlZWnvA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uAFdS55K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
Message-ID: <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773382487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTOLkQVeVRERnDaN2DY/VOKpnGSBVqeHDpUKHThv08w=;
	b=uAFdS55KeRCswjq75c2XPetMdLBZz02PMZndCgnGus7RcpkYRA42aQWgO5+73Z48XT+QNy
	goFei+e4hH/qigznuSXoYYNL6W3QKa4gIO+u47sTlzngo4sHrD4fcv3iyLO3QODXGRMxgX
	lvTyN830y+LMTKxFJU96X0nsOAQ57sI=
Date: Thu, 12 Mar 2026 23:14:36 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 akpm@linux-foundation.org, mhocko@suse.com, apopple@nvidia.com,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
 <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
 <874imkpba1.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <874imkpba1.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C308160005
X-Stat-Signature: stoskg6nf15h13z1sis8qditeijih8ed
X-Rspam-User: 
X-HE-Tag: 1773382489-122024
X-HE-Meta: U2FsdGVkX1/SvsT7OrHcPn7N9HEGrSSECKVao4cH6Ht5cCbQ9iZWuG1AHPheXExP9diLHb25IRIbLCuCVGm/OjqNvWwhT8YIV3b2jW6k1FiU3HcmeYhNTgh/Wp+TCso2OynmDkR74HbDuFr0oiS1pDyVjJsBcLlkS6ocnw9YWf2Oii3zZk8KPbf1UaQjvh9JgA3Za5MDL5czc3goQVDc5MNc+36wA4psAvEMhclrX0K5Q+9hJnP2L6hYUAyFcuO5fpmCZwb2iPH2YE85JcSTC8Jp3VJhouJ3aPZJmpf9KgRiTuozo/As6zsQxh3wt11YZr9LA2iOflDEKu2ZkDEuppYfBS8BO3/yj1Wr/Sb0Sez2g35fGHBhTKeajggbc55gfcunJL0b4Cg7U/1mqr8o24io8qSm0dqxKr5fALCvdcQZ5e86QGhy8P/If7c5g71OrNZkI/rZh8+YSDF36elgod9ev6f2xEZ8I4l1UyT022PaelkEldrBKTbnKT+VS0sC/FK6xitQ+8Hu5GU9+7mqzK8Rzm+DIKwqjCgNLaVkgOxV6Bne4j8b9xVi6bcpiYQb0vKBSg64I+shM8PF259tsmzvX0WchAJjlrtfiOCUwOner1e3jXD/mzmSCayRcBjFuCt85oFy/QiWY0QN6cd6+6w1ReUQ4NF6aq0WC3AT/EEgA00pZNPJvjiuVmxrA1qCaDPSjS2pkKcjrFs7arpdv4GmDCXbnQ1OZMZeMf6YM05ENGubf0hOsIKrzPDWUusaD28UP1tGKbPcuki0+5oXd9+FaNO9jnskw0Dw11+qjsg9vNw01wqZkphAAjCXCUo3ez3rHW4WeO45K2LD8lRatCIocisupD7ccVuj4Hl649d5dDEFdrPN3hMMF+XlXtOT9etaJemwLGXvTyZcsDHTFNi0F0uMT82mfnKIm+InqgeYbRUZ1OZrZT7N8NHbelOD7d9E/j8+gjtbMOTGlZq
 SMoHpSp+
 2KfJcCqci3clvn66R5E0/Ea7EroAU/AV1wljQdqEecarDUdScZMTqZjarE2prIfbOFHc4cMFzo076hcQx6321Wa93gkj0fVIvLGoFVaUrXLoDaWNxRy8pfZyu24lHGMkj8Z4yF/v9EL9pRJssuN3RcctplTBENE3dXjhhbirGDa6Z1jNhvl/7f7iyFoWltM+SuOt/YGOiXG25Wzpp5ZVovadZkzML47S1r04ThTP9LRYu8m9sU2GBYsfxFITUSPO8z+lD0SCcIuvwVirAgI7N0eN9ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 10:07 PM, Huang, Ying wrote:
> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
> 
>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>> On 3/7/26 05:55, JP Kobryn (Meta) wrote:
>>>> When investigating pressure on a NUMA node, there is no straightforward way
>>>> to determine which policies are driving allocations to it.
>>>>
>>>> Add per-policy page allocation counters as new node stat items. These
>>>> counters track allocations to nodes and also whether the allocations were
>>>> intentional or fallbacks.
>>>>
>>>> The new stats follow the existing numa hit/miss/foreign style and have the
>>>> following meanings:
>>>>
>>>>     hit
>>>>       - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>>>>       - for other policies, allocation succeeded on intended node
>>>>       - counted on the node of the allocation
>>>>     miss
>>>>       - allocation intended for other node, but happened on this one
>>>>       - counted on other node
>>>>     foreign
>>>>       - allocation intended on this node, but happened on other node
>>>>       - counted on this node
>>>>
>>>> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
>>>> in /proc/vmstat.
>>>>
>>>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
>>> I think I've been on of the folks on previous versions arguing
>>> against the
>>> many counters, and one of the arguments was it they can't tell the full
>>> story anyway (compared to e.g. tracing), but I don't think adding even more
>>> counters is the right solution. Seems like a number of other people
>>> responding to the thread are providing similar feedback.
>>> For example I'm still not sure how it would help me if I knew the
>>> hits/misses were due to a preferred vs preferred_many policy, or interleave
>>> vs weithed interleave?
>>>
>>
>> How about I change from per-policy hit/miss/foreign triplets to a single
>> aggregated policy triplet (i.e. just 3 new counters which account for
>> all policies)? They would follow the same hit/miss/foreign semantics
>> already proposed (visible in quoted text above). This would still
>> provide the otherwise missing signal of whether policy-driven
>> allocations to a node are intentional or fallback.
>>
>> Note that I am also planning on moving the stats off of the memcg so the
>> 3 new counters will be global per-node in response to similar feedback.
> 
> Emm, what's the difference between these newly added counters and the
> existing numa_hit/miss/foreign counters?

The existing counters don't account for node masks in the policies that
make use of them. An allocation can land on a node in the mask and still
be considered a miss because it wasn't the preferred node.

