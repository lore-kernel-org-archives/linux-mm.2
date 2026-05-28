Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97C0CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 15:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF29E6B008A; Thu, 28 May 2026 11:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9F26B008C; Thu, 28 May 2026 11:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07166B0092; Thu, 28 May 2026 11:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D59FE6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:31:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77463408BC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:31:58 +0000 (UTC)
X-FDA: 84817219116.10.CE1DDA4
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id E869A1C0017
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:31:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cx4hFQ29;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779982316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1oUqKehXs+Ix+t66SPeM6NBPV9gb1+9jfmojtKA5LI=;
	b=aVmDRtlV0tX+jwI1ePguPXXL9jfCUYZ5jPz4m+zq9eJ4NNfAGojw767IxS+eXd6ZdIccQO
	mUEMle90iSTmoAg8VSVEL6GFf7ZVoc5MWj2LqsAv5/wCF2JjPF+oTkoaUlBSTzMFHEFXt5
	itllcV5rZL9MxV8ne8smUZs4JAwYw3o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cx4hFQ29;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779982316; a=rsa-sha256;
	cv=none;
	b=7EWMN2Zckn4YDjeW15KpD7tiPo3wnbFwad1LAGumw5kHyMNm++74zrAi0t+121baTLLzYT
	COjhu5bKIyWgpon5k2vmCsB6WsLG2bdS0hb/OzQ4sh7QAllXfJIkq69GZg63Aa+wQUKPsi
	y7euAYUpUc8jaB1kbCL3VFtE5RoPB7M=
Message-ID: <6c138c46-9ef5-4dab-b65f-53f644b507d6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779982312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J1oUqKehXs+Ix+t66SPeM6NBPV9gb1+9jfmojtKA5LI=;
	b=cx4hFQ29ac85axRefP3M5Zn1R7OcYorIPr7yFgQnJSKJP+xteuaLDNny5Wlt35GhtLJprE
	tYA/Fs8ehAM4OMZWLWihC59axuJa1+jn4WFbuVBq1573THJ7V92ueZ/8f7B/zqhTqx5bW9
	WiTQyUk1NeVjWUfngkYaAwp3pIhOysE=
Date: Thu, 28 May 2026 16:31:32 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-10-hannes@cmpxchg.org>
 <6f9c78b2-3846-4f75-bcc2-41bf91230513@linux.dev>
 <ahhK3AKksNbJ4zbY@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ahhK3AKksNbJ4zbY@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4ghbn3a5pi116tsfoijgidznbj7f64tn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E869A1C0017
X-HE-Tag: 1779982314-99033
X-HE-Meta: U2FsdGVkX18+JPEWXeSaDleM/90qJryWPeXj4m0nmapQqRUExvdKTatINgh/Dn4rhgiZpZkFy2c3tsjWeKMG/gMrGdjnnK0Yg2nRbz65zP6AfPkC9X5L+4TuAB4e0+86WAhB0wCqqkmZ26E1U5zFpPLgZldNX8DAVCnXKYnZV+QHImylJrMtKFKtHeO89Y/o7wpELY/a9n5b/EK/PKrCRBuq3m/yk8KhfB3tipLenwhc3Q+ccaUoKfDuLbgUrkRyDtmSdZaQgZsNQAP1ZIRj6tv5PnMB2OoNYUyTp+Xu6W7gxhn+NiVjAJj1xH5f70EuRq6w6Kes7pclGQPsYz3WlHhlHzYEbxvVk9+BB3BWl6fTeSIf7Z10TaHt8WlbuviSa2KzbYgL63482ntrcgpWxj7yrA9znCx4VXI+bDEnPwtTWef1YskgMW4Gd5ze+xhmdUKX74Er8BOthi3kaVym9MDXJloyU0ManRbxUQwDPq31VOsMj30IAcfSlYmhTyJsaVHbdn/qoO7kBe4m41+4XyNNe8BPPUOH/XLDpHlEMJMdNNhJWJwPB4nLgLB4zfwBhozhW9i9nbs6VEuatJp7TlreBX59UusvhgePbsqDh3Nmzy8Xp0vPCJO4hYHkyTAJGd1a0GUWYhh0Ef149xuvNI/VERqGWwy8K8w79w2h9FfP+O3AyfotyBr1wfYM6FiHPOoSCSx6KuIwoAjSmycZSZe8VtodT3D/SRqJk5gTqYdyzL9ZjznHex2e2Ow6REvSGxN9Y6Z+Q+EmXP+kF+fYtF2DS4elqNYlNQCavd7g4alUtVrsbChR1gQIgsKxBphcw60lAifBNic229GQ+khg7f37hwnsCo7YPOHPEVW+Ahsv0dagseq4HowoBbLcKdfXb+Bx3B/Sju5A7+uUoUh6LgbwFgRr2a8J0rOMzTgx8wC6l8kRTP0fL+NmfleQBZH4jwP7EiYPNaKpUvZmg9A
 Z64UciYY
 lEA6SL8gAOIR3bCkC04hvrq82iNKWvzSJm/7SUlxVuBk703Isqoz2r/rV0zUOxvKJmnrhHULk0kWUVVjm+uqU/TnV9FIrEqI8bsvBhiMdmQlsmzXIlSICA0yHhwLJ8gxEcLhQ9Q8AHtftIdExiI+iuTVK6XWBURVrkAAbvtepD3lAh+thsbK8SVGAjaziW4YDLcf6DKfgrXJonzogd6i8UU2l8FEwuiTe1FDbyI+n8F0R2WavckPHhWUMUWpogWkofK8Lef+PtM0fC4hf4yzZ4gcs15NwcfICmekAh2Uw95clZjusWnAjpl3C1PyI2rPpNB2rdcOlo4UAH5PGXZsnt/c6XU/5tCKAgq5+BTSCgARCVSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/05/2026 15:02, Johannes Weiner wrote:
> On Thu, May 28, 2026 at 02:32:06PM +0100, Usama Arif wrote:
>>
>>
>> On 27/05/2026 21:45, Johannes Weiner wrote:
>>> The deferred split queue handles cgroups in a suboptimal fashion. The
>>> queue is per-NUMA node or per-cgroup, not the intersection. That means
>>> on a cgrouped system, a node-restricted allocation entering reclaim
>>> can end up splitting large pages on other nodes:
>>>
>>>         alloc/unmap
>>>           deferred_split_folio()
>>>             list_add_tail(memcg->split_queue)
>>>             set_shrinker_bit(memcg, node, deferred_shrinker_id)
>>>
>>>         for_each_zone_zonelist_nodemask(restricted_nodes)
>>>           mem_cgroup_iter()
>>>             shrink_slab(node, memcg)
>>>               shrink_slab_memcg(node, memcg)
>>>                 if test_shrinker_bit(memcg, node, deferred_shrinker_id)
>>>                   deferred_split_scan()
>>>                     walks memcg->split_queue
>>>
>>> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
>>> has a single large page on the node of interest, all large pages owned
>>> by that memcg, including those on other nodes, will be split.
>>>
>>> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
>>> streamlines a lot of the list operations and reclaim walks. It's used
>>> widely by other major shrinkers already. Convert the deferred split
>>> queue as well.
>>>
>>> The list_lru per-memcg heads are instantiated on demand when the first
>>> object of interest is allocated for a cgroup, by calling
>>> folio_memcg_alloc_deferred(). Add calls to where splittable pages are
>>> created: anon faults, swapin faults, khugepaged collapse.
>>>
>>> These calls create all possible node heads for the cgroup at once, so
>>> the migration code (between nodes) doesn't need any special care.
>>>
>>> Reported-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>>> Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>> ---
>>>  include/linux/huge_mm.h    |   7 +-
>>>  include/linux/memcontrol.h |   4 -
>>>  include/linux/mmzone.h     |  12 --
>>>  mm/huge_memory.c           | 364 +++++++++++++------------------------
>>>  mm/internal.h              |   2 +-
>>>  mm/khugepaged.c            |   5 +
>>>  mm/memcontrol.c            |  12 +-
>>>  mm/memory.c                |   4 +
>>>  mm/mm_init.c               |  15 --
>>>  mm/swap_state.c            |  10 +
>>>  10 files changed, 150 insertions(+), 285 deletions(-)
>>>
>>
>> [...]
>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 135f5c0f57bd..f22e61d8c8de 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -5222,6 +5222,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>>>  			folio_put(folio);
>>>  			goto next;
>>>  		}
>>> +		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>>> +			folio_put(folio);
>>
>> Ah sorry, should have caught this in the previous version, do we need
>>
>> count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
>>
>> here?
> 
> This isn't an allocation we expect to fail with any sort of routine
> that we'd need to capture it in the event counter. It would warn in
> dmesg if it did. But in practice it can't happen at all, since it's a
> sub-costly-order slab allocation and the allocator would loop and OOM
> kill stuff until it succeeds.
> 
>> or maybe we just goto next instead of goto fallback and trty next
>> viable order?
> 
> Again I don't think it matters, but fallback seems a bit more correct
> because the size of the list_lru allocation doesn't change with lower
> orders (until we hit 0).
> 
> So I think we can just leave it as is.

Ack!

Acked-by: Usama Arif <usama.arif@linux.dev>


