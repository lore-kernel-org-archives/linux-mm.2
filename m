Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59ED3C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5594F6B009E; Tue, 22 Sep 2026 10:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530CD6B009F; Tue, 22 Sep 2026 10:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4463A6B00A0; Tue, 22 Sep 2026 10:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19BD46B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:50:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC14C160519
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:50:47 +0000 (UTC)
X-FDA: 85241684934.25.BD9AD79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B6538A0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:50:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FSaftz0z;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790088645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4B4e9pkP/2OIfhwM8t+V/pamQCMxifJ3uHPJlCoXKI=;
	b=lK2qjjmeD2GWyJNmCRMWdSABnP6xuq+i+H9PjajcnC1WgcAq1rOcVRJajVFssU9k+My30C
	pUCKLvkrsAHtUwsRUHuRKgdMxj5dBgqpNORjcoGECl/pP5JC3XwtTRYbqIa9z5CK0ZP5UF
	4c6/ydXDd0jx8zPu911m2SVLuwoIvJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790088645;
	b=p8N4Gl0jxH05qflZPor/WhYu3fQ7gO/uLQ0IJ8qgGrNj/tjBYPMdIPvMbm6L32RfQBb0Tr
	3Qef2ObIECFprssKcGXi0mAQ3H7L/lbjYC8G0ZZFuFhYUQN25vrQjijT2AXj6nlG3ti0mM
	TF1tfj2xfhcFBTdxb/FwBlcTJiEKkqw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FSaftz0z;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E425E429F3;
	Tue, 22 Sep 2026 14:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C881F000FF;
	Tue, 22 Sep 2026 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790088644;
	bh=k4B4e9pkP/2OIfhwM8t+V/pamQCMxifJ3uHPJlCoXKI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FSaftz0z7Ca2JC85GN+pnNtC7365d9jO4ySUnHAUIIiFI3LhoBvvOa6xXiShc8kF/
	 3zGM061MNtCZEI3BsRH1uzBGy79j2SQbrBhWJ1wcknkPz86Ew1sRslSvvJY/naVhe5
	 QUwNjtxmrj1GOWgevjKLi0o+FnjlJxfDF4/RFATcvHJt5dGRw0DZFPIVg6KCDyG2IU
	 lyATMVzXfPxHXQBviVWrF0e2SQiD+xM2+a04f5FSRhXy3/WkFBj4cVueDhPj8HsslB
	 i9/glDSSwWT6mSGDkWk+wNMXJ9vXU+vt0GpC9ldhReTuc4HOyqnl79QJ4hkGYSripI
	 fUsoMBKVXBnRw==
Message-ID: <2b064cfd-25af-4934-ab85-1018140b76e6@kernel.org>
Date: Tue, 22 Sep 2026 16:50:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: refill prefilled sheaves from the barn
To: Hao Li <hao.li@linux.dev>, harry@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260921094521.141665-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260921094521.141665-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 77aaegqs1536o9bw8nhga5mrbos4nz61
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6538A0002
X-HE-Tag: 1790088645-936893
X-HE-Meta: U2FsdGVkX194+TFQ/EADT3HWypRq93XHV/YcfsWpVZ1LzHz67o6AKIXJ+R/wzHsY/k9WrvvUzIrATVv/cOT3qPvWUtlQVV9SpyeRLrE3aV48gyOrLFce2+ebyovq6W/0Oit+EeNX2MBxXF468fO9eXPxiFLGuT0u5ALjHBP1ZhfITjdb/G0/oJUxgvABDm+odl+ZZQZtTTScFMyDdNPN7DnNZh4IB7SFZakWHDzbsMHQWfNVWfL7FsLsRtFpY16cRG39mOR9C9ORfZbCmnErTTHtI3roKG27xzIGT58wPUpXBZqIv/w1WwrCegzyzx5bMbsqnx062dQSL4AOtTy8oWNWEbg7ke0kjzbrsRPr6chdmqsCYwsroCY++oLeWVSE4quMC4PdplnnNxgvzTm6j91aqLu+0rKhLpn/1uxK+NWqcT520/8RP3dQLjgm/dOl4dthfTJWzdUy0lfw7CtPcFFiEwB5Y7W0eqPpLrjkESthDsmBjwd3t490hxzNiQjeA2hk0KycGPeYXc5rGvgKRUb35Vjm15PCFxC0FZbjvjlH4tNDl4pYjlllyg9KAngTJ/nj5Qqe/KDM443W/SZCUrBaN9nEAxy9Py7/4K+Bdjo3utFurZCaRKbclMRHPpzdJJCRe53DilR4Svj7kZn30xT1rbsrpWgTBglNxqxUpOPCuFiQnLeyVRsrgfnVV4LUuig2mVQ7PL7HtzrelL8A0R9Z/NBZHhIMaS9cQZOKzk7QBUeeN1g5lFgYEBDhuykpwfXJ6Ek7mlGonTgoMsSI3pfQqwjpPtjDr4QVpqySgI3dXrEupYnfSclA8SQaTZWzMGIzmf341o1VtHpCMCweJeL7G/CmtDDuhl+Eooer5Yp9FIeFoRP3qjl1AjMUFMC00r7mYpylnu39pioX1wtf1MmnyBPnqaIJqm5VVVfcQguehg8t91MEqUSdRc77+JrDUIRaX7A6i0OURXEX9K2
 Ve5WBJzD
 l3Z27Wn8m3/JTKqwArQ/LhsyFmIbgEHP9PC5gWIrAjsEi1/A7VX4JfCjPW4Yw8YJmgPOZ4iX4TKDx+VifZLLig2yOpWH4/luLH1NX2XpZFhfEC7P8ZwNEvBuJD0c3MnBHCiMVvEz4+cXm28ssCHGiXd2JT9QGy6g2kAcLQQQYMktqqNPMcYB+SLoBdESe5GR2q/nrAXFH122+jTEvxqKLm2kaGnRwH8TN16Aoxb/+N6rHGXUhprpQnaoksAFlJ5D1zzse4tt+4bKrMTRLycsC5VqdoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 11:41, Hao Li wrote:
> Currently, when the prefill API refills a non-full sheaf, it takes the
> objects from partial slabs and never from the full sheaves in the barn,
> so once the barn's full list becomes saturated, it stays saturated.
> 
> For objects freed via kfree_rcu(), every RCU sheaf then has to be
> flushed to slabs because the barn's full list has no room.
> 
> To fix this, let the sheaf refill from the barn first, and introduce a
> partial sheaf in the barn, which holds the leftover objects [1].
> 
> Only the prefill path needs the partial sheaf. The generic allocation
> path (__pcs_replace_empty_main()) exchanges an empty sheaf for a full
> one from the barn, so nothing is left over. The prefill path refills a
> sheaf that is not necessarily empty, so taking objects from the barn
> usually leaves leftovers, and the partial sheaf is where they are
> kept. refill_sheaf() only takes objects from partial slabs and never
> involves the partial sheaf.
> 
> The sheaf is refilled by copying objects from the partial sheaf, and
> then from a full sheaf taken from the barn if it is still not full. A
> sheaf that objects were copied from stays in the barn as the partial
> sheaf if it still holds objects, or goes on the empty list if it is
> empty. The sheaf being refilled is never replaced.
> 
> The gain comes from two sides: every full sheaf taken out makes room on
> the barn's full list for a future RCU sheaf, and refilling from the
> barn is cheaper than refilling from partial slabs under list_lock.
> 
> Note that putting the sheaf with the leftover objects on the full list
> instead would not work: it would occupy room on the full list, so the
> list would stay saturated and rcu_free_sheaf() would still keep
> flushing.
> 
> An earlier version of this patch swapped sheaves instead, to minimize
> the memcpy overhead. As Harry Yoo pointed out [2], replacing the
> caller's sheaf loses cache affinity, filling it directly is more
> straightforward, and testing showed no measurable difference between
> the two approaches, so the approach he suggested is used.

Yep, a memcpy of a small array isn't a big deal.

> Tested with will-it-scale mmap1 (192 processes, one-minute runs) on the
> maple_node cache.
> 
> throughput: 27778727 -> 34500556 (+24.2%)
> 
> metric                       baseline           patched        change
> =====================================================================
> alloc_fastpath                 54,124            56,696        +4.75%
> alloc_slab                  7,100,651           159,739       -97.75%
> barn_get                          849       194,460,392    +22904539.81%
> barn_get_fail                       2               217    +10750.00%
> barn_put                          851       182,306,701    +21422544.07%
> barn_put_fail             260,400,484       145,522,675       -44.12%
> cmpxchg_double_fail         1,029,204           334,228       -67.53%
> free_add_partial          326,694,687       181,935,790       -44.31%
> free_fastpath                  13,297            15,611       +17.40%
> free_rcu_sheaf          8,332,839,104    10,490,535,227       +25.89%
> free_remove_partial         7,099,788           158,297       -97.77%
> free_slab                   7,099,788           158,297       -97.77%
> free_slowpath              10,969,156           782,851       -92.86%
> objects                        15,295            14,849        -2.92%
> objects_partial                15,295            14,849        -2.92%
> partial                         1,604             2,336       +45.64%
> sheaf_alloc               137,757,895       141,208,076        +2.50%
> sheaf_flush             8,332,823,922     4,656,725,764       -44.12%
> sheaf_free                137,757,883       141,208,072        +2.50%
> sheaf_prefill_fast      3,337,502,163     4,196,506,116       +25.74%
> sheaf_prefill_slow                685               400       -41.61%
> sheaf_refill            8,343,794,364     4,657,509,724       -44.18%
> sheaf_return_fast       3,337,502,411     4,196,506,382       +25.74%
> sheaf_return_slow                 437               134       -69.34%
> slabs                           1,604             2,336       +45.64%
> total_objects                 102,656           149,504       +45.64%
> 
> Here is what the important metric changes mean.
> 
> barn_get and barn_put: refills now take full sheaves out of the barn,
> and RCU sheaves are put into the barn again. Before, the barn's full
> list was saturated once and hardly ever consumed.
> 
> barn_put_fail: more than half of the RCU sheaves are now put into the
> barn instead of being flushed. The rest are still flushed because they
> arrive while the barn's full list is at its limit.
> 
> sheaf_refill and free_add_partial: fewer objects are taken from partial
> slabs to refill sheaves, and fewer slabs are added to the partial list,
> by the same percentage.
> 
> alloc_slab and free_slab: the partial list is almost never empty when a
> refill looks at it, so slabs are almost never allocated and freed again
> only to serve refills.
> 
> After the test, the maple_node cache holds 1604 slabs without the patch
> and 2336 with it. After a manual shrink
> (echo 1 > /sys/kernel/slab/maple_node/shrink), it holds 485 without
> the patch and 563 with it. So most of the extra slabs are held only by
> objects sitting in sheaves and are returned by a shrink, and what
> remains is a small difference, because objects handed out from the barn
> come from many more slabs than a refill from partial slabs would use.
> 
> Link: https://lore.kernel.org/linux-mm/aqPlMzUIw-4g2iOX@fedora/ [1]
> Link: https://lore.kernel.org/linux-mm/aq0ylDidEHa2kg4X@thinkstation/ [2]
> Signed-off-by: Hao Li <hao.li@linux.dev>

Very cool!

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


