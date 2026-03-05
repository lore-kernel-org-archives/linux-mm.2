Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 222DAF30956
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 13:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2A76B009F; Thu,  5 Mar 2026 08:05:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0B76B00A0; Thu,  5 Mar 2026 08:05:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDB56B00A1; Thu,  5 Mar 2026 08:05:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE0406B009F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:05:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F43B85E48
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:05:27 +0000 (UTC)
X-FDA: 84512030694.25.8464CD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 43A024000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:05:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oHFYoctb;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772715925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=licnEjSHV/BuhqPjY42F9oSAumn2232Av7szU80HoEo=;
	b=envPBI3PKC5FopK76q1JyKySequbwqYtgu2z90POOrv1AuUDWyYbH14oNMzVzK04sHoLJK
	eK8/7Adaow9R6s9Sk1BKZ1cDbZj0MNsr4wBQjZ4ub1L9wdJSqPttheqKQM8dXRfJDOhIXs
	DPb/Qxpdnrnji13MUN7yWOysuZwyajY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oHFYoctb;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772715925; a=rsa-sha256;
	cv=none;
	b=XUvRh/PJTmSsdwkM+UXcUR4Xw6ATroNo4W6iyfDMDV/SGNeNZwNxIKYYEGJc45dTvcK6P0
	ZEgdqpDJ40WEj3Aw1VCg4YiG4jHcwfH+knE0zBYvf0GIMQMFtmpo1VLj9qYIxA4Ew1G5jr
	3/bZOVwpAcyjjT1hHB66Sz9Gf8IZfbg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C59D41787;
	Thu,  5 Mar 2026 13:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6469BC116C6;
	Thu,  5 Mar 2026 13:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772715924;
	bh=5O3pdPqVxVHBOmTlIeryC54JgtIMpNS1g0GSO96c1I0=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=oHFYoctbU3ceTdExzWvMnxM3IXzij87OYgmV9QRWbf2fJ9tV98hJ+6o02dB3GtACB
	 uuLeNXfVUHAxkyoEZ69EGo1ltkkgDA4Gz41ZOHFg1lAHqZVdH3MC+M/iPPs2beREMa
	 CI/kbDG4DTR72H0+ySIyBry/YSJxsL0vXDJCK+/iC5NKGt0EBgr0S3ik/9g44apBv4
	 WJXU+8h9aJIx4AERVSz5TaF7pXqbv8NIdxHO5ozlLjbi73QfX5TH/92T8dfsTMXQeb
	 qloLxiQ31Za+1poigJz91Okk4P4FX+H+uG55dz9PSISA5BX+BlcApaDIfhmtk2O+Ub
	 3M4pMQwhtHC2Q==
Message-ID: <08db9e93-3d29-42e0-ae57-79c295d75753@kernel.org>
Date: Thu, 5 Mar 2026 14:05:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
To: Ming Lei <ming.lei@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Christoph Hellwig <hch@infradead.org>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org> <aZ7BbosIr2FvZFAe@fedora>
 <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org> <aaFinIsCmitHSP_c@fedora>
Content-Language: en-US
In-Reply-To: <aaFinIsCmitHSP_c@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 43A024000D
X-Stat-Signature: oi6gumdqxy5esc1a8krsfxbhx9nzk9g1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772715925-26055
X-HE-Meta: U2FsdGVkX1+ohRsDYHwf/gfXQv4Qcre1GzDcUxoOkTAoDHEXDytL1FnuYkkJ7jOFjrICe1lwOc7YSF3cqtLwlqDmyDNXrjJERIi22IfcM8d/8umQdnG2dnTsKKzv5ZKRZDbthpXF1jm5RkK9gU3pSQi90h8pY0c3QRqQW4OcngaRMv9v1uU5hSfB8rmwCkaOiJ4C2fkyNf23CVYpEvS3h73pABXWeNROs1kGluBpQ1GPnXkk+DDunhrNmKIUz+mNkHU34sD4Ah7NNXKH7W+TtIHK2WGW4KfRFfXCGTtFBfCEbxQ+O0RExlbXa7dM74rEFcuOXhh6bFMr6h9PmNALL9NKUQL6nnV3c+oLaEb1/D2kic8buNXTbOpb9WMFpF6yWtxdijGoupENVtLiwW8Qt1Lwqx+j2JgGO2rmd057hGUyjvi+fIzX9CKZpM695hx0AUXkWuBqd/VfbR/nFlViS3JAVRZxk0aAOqUKikFAUvjGOV0QPHzQpdDRDBpMDDQ2RqsemmWqBW/c+zT3OQXPLR2DB1nZ1RR9AkQJoHfOPU1QPh5NdvxISA+Al7Ox78CuL+AFbVnuoKuCXjYQPmin/V8i4iEDx5Qc4YFnvCNT84s/LCqj5Zw+Ur9zRv9Xoq5qVIZjNH7N9LPjHdg1e/fkr2XF3TQaX9JvLlmfu4ZoliuyZuzBQkRJycyXE9nGMqpDNrxGkfbX4t4xJqcnOOgMx4JB5d9ADpsop9U9AYh5v2f82ymdgCCrRtFhwk626mQJql8CamSzafflP97Z75Ca/pLskyo/YWIhQuiLZGwBVaVf9k5I5IQUjlMghHRiYothgI6vzImpswHS54LYileyQZ5HrjF7phEwU2/EEqvIYqBXpOb86L62R+OhmMKRS4wPtCBhtLsKMVT2ad+ZaQhRiyvut8mAYPCj068e66PEq88+scotlh6vazn0wNY5gyeAgFkRBeBvi/R8pSzPsy/
 doDlTpVw
 aWTtLK5QHYVWdAIXyUsKKzHWoI4M1L4VvN53h20Fjw4SNm89CuV814ZiMpUCKXm6nMTfd906D0OwLQdGWT1QylyyJeJlu6B2ywedSeuas7/78gvgB9QRrXctoAW5gM9+0OUjlkn8FxYymharZOUkq7Ok1a2VSvkZpjK5RTZ9kGA0MzWyQMI4z6XHHYuUqxlzR7DefezFv1mIX+ae2tKDRWju9G/P/3MviRseUNQXt1SOw567Zg5vK1G/k8wyt7QTZbBuz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 10:23, Ming Lei wrote:
> On Thu, Feb 26, 2026 at 07:02:11PM +0100, Vlastimil Babka (SUSE) wrote:
>> On 2/25/26 10:31, Ming Lei wrote:
>> > Hi Vlastimil,
>> > 
>> > On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUSE) wrote:
>> >> On 2/24/26 21:27, Vlastimil Babka wrote:
>> >> > 
>> >> > It made sense to me not to refill sheaves when we can't reclaim, but I
>> >> > didn't anticipate this interaction with mempools. We could change them
>> >> > but there might be others using a similar pattern. Maybe it would be for
>> >> > the best to just drop that heuristic from __pcs_replace_empty_main()
>> >> > (but carefully as some deadlock avoidance depends on it, we might need
>> >> > to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
>> >> > tomorrow to test this theory, unless someone beats me to it (feel free to).
>> >> Could you try this then, please? Thanks!
>> > 
>> > Thanks for working on this issue!
>> > 
>> > Unfortunately the patch doesn't make a difference on IOPS in the perf test,
>> > follows the collected perf profile on linus tree(basically 7.0-rc1 with your patch):
>> 
>> what about this patch in addition to the previous one? Thanks.
> 
> With the two patches, IOPS increases to 22M from 13M, but still much less than
> 36M which is obtained in v6.19-rc5, and slab-sheave PR follows v6.19-rc5.

OK thanks! Maybe now we're approching the original theories about effective
caching capacity etc...

> Also alloc_slowpath can't be observed any more.
> 
> Follows perf profile with the two patches:

What's the full perf profile of v6.19-rc5 and full profile of the patched
7.0-rc2 then? Thanks.

Also contents of all the files under /sys/kernel/slab/$cache (forgot which
particular one it was) with CONFIG_SLUB_STATS=y would be great, thanks.

> 
> 
> -    8.30%     0.19%  io_uring         [kernel.kallsyms]               [k] mempool_alloc_noprof
>    - 8.11% mempool_alloc_noprof
>       - 7.64% kmem_cache_alloc_noprof
>          - 6.15% __pcs_replace_empty_main
>             - 5.96% refill_sheaf
>                + 5.95% refill_objects
> +    8.06%     0.44%  io_uring         [kernel.kallsyms]               [k] kmem_cache_alloc_noprof
> +    7.44%     0.00%  kublk            [ublk_drv]                      [k] 0xffffffffc140c71b
> +    6.63%     0.03%  kublk            [kernel.kallsyms]               [k] __io_run_local_work
> +    6.19%     0.05%  io_uring         [kernel.kallsyms]               [k] __pcs_replace_empty_main
> -    5.97%     0.01%  io_uring         [kernel.kallsyms]               [k] refill_sheaf
>    - 5.96% refill_sheaf
>       - 5.95% refill_objects
>          - 4.87% __refill_objects_any
>             - 4.76% __refill_objects_node
>                  0.72% __slab_free
>          - 1.00% allocate_slab
>             - 0.80% __alloc_frozen_pages_noprof
>                - 0.79% get_page_from_freelist
>                   + 0.72% post_alloc_hook
> +    5.96%     0.02%  io_uring         [kernel.kallsyms]               [k] refill_objects
> 
> 
> thanks,
> Ming
> 


