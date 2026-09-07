Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22AB8C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26E36B00A1; Mon,  7 Sep 2026 09:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFE746B00A2; Mon,  7 Sep 2026 09:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14CE6B00A3; Mon,  7 Sep 2026 09:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B24CC6B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:44:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 358EA1A0173
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:44:14 +0000 (UTC)
X-FDA: 85187085228.23.92B45B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F311C000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:44:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f2qRhLmf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788788652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFTz4fJohh/eWO0oQLVrARc/1ZYQ0OUd3e4e7elLKrY=;
	b=fmUaVsIGawCeX4zUiG3lOjNWcQyXSPR/Le7wUppEx1FNZ8aPsMBBykv/Er0muzEBwro2ku
	TQ4rS0ruyrpjA/FWYVF7/+JF0XHPZOBowZSufkpfKWQbKkVqxwgBD9fvGyBTJHC7k0Sucw
	7zqgljkXvbYohhueBfDEBDyUfa3JMys=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f2qRhLmf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788788652;
	b=eHPL0iZR3sMLzOX4dsqxpwE41Y+IRji3zJ/b1B93FiOFpb4CEbDmmF2CTS31wVvSAx+EIW
	jny/zTHfsjgls4qG28lPcVWhTIJC2oO8/kjD3GOSqwCnnkoxIxgwUIL/BRNzgPrNh207cf
	91515ZRBq/9O1PDYvuPSTQ+WIuoCXtA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7599343B6C;
	Mon,  7 Sep 2026 13:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B8C1F00A3D;
	Mon,  7 Sep 2026 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788788651;
	bh=TFTz4fJohh/eWO0oQLVrARc/1ZYQ0OUd3e4e7elLKrY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f2qRhLmfPJz3MBfjy6Gv/nvD05R06jlEeB7IkHD3iz7ch3jVUvvKUskQ12Xz5A8Wa
	 Eu1RDrYG+/wlsnBx5YmBWHh2Z6MLmDBlquGNv4gOlUk41OFwRegtQMLiRLM/O6AkBm
	 UCmTb3Lv8+St4P1qY3gmqp8CgRM5cJ3LpjEO1NfFePgR24WGQ4nJ65GLRkyCdyoapv
	 4rkgkDCuDvrdeMF3VDkW4v1mCTw9pFqogD8SoxfcmOA3SG6BKkPdoN/bC2sGFXSN6i
	 EWwcY5X0xkYHeSGf7yHxQxA8BJ0KM8w9raNouOCwMsYKxRacqcvAFt9bDrY1Tp2mXR
	 myv/awKhraMYw==
Message-ID: <a3e5581a-e039-45bb-b570-a01158b154bb@kernel.org>
Date: Mon, 7 Sep 2026 15:44:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm/slub: reduce list_lock contention with slab
 parking
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, harry@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pedro Falcato <pfalcato@suse.de>
References: <20260824122004.3652-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260824122004.3652-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6nuyc4hbq9ijm5a8qjwztd4fkhrjiibd
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F311C000B
X-Rspam-User: 
X-HE-Tag: 1788788652-398714
X-HE-Meta: U2FsdGVkX19suT6HAev46PplXVtVONDljCjaSnuEYrI5PPErgpGn97lWXEjeZOo8QBxMxsZ+LW4azCNPp712AwqtpJT4FWSeDxH2nEh4H1iJhWUjtNmS2R8d4m7V/rsadjUUn9VDyGiSU//dWfiCtmCNKvtTdhWwa2CHIl8AETNmmfIVycjJ56S4Bq4q14C8cNLyWGUDnvVnhY8iulBFwu+iCsfob/2uS0YbvheKw4IrpxAgTPUa+6Win7M4kzkNo0hoxBSkBsWI6vMubauGNHcjPddYnHJhIc/KTIKixnqcRQYksMu+8TWPVebkHNZxZWBqMLSeO4L4PdFyid39v5w+5q8N8I0QcuJq38lk6ouNKH3Q9eqQNyT+Qr+3H3ozmDH4p+OrZ1Dz37R4K0tU+r5qSNu8gIq+CGYkHfcTGWQPGfIQBvSt4DJmK4n6uBM69isaddWiB9n9+dGH18hN22cfMub9P9p60lHzJYehxiLtRlkFY/rFzNlWkrIuJZV+sK9PDexLrciBuxWRxbg/Tp/d4iX+d2Yw0tyFyT+Lwrr05J6Cl3wJR2gS4HUEQmKfYB0ba/i9Gww9QAqghDQBdWb3SCRizYmXs9FPxKb2vMEcV2+qB4eIirCU2uIEARPL56BICcxp4XMDuSHW5ALWJzZWgpP25QEbCCJb08KmjMQgsOBOrwAEkasHGaLolC7ZPZLkxKkfngFIjHJiHyORqcsFnEWUfnuDJgbBuRwvAoQPGJXctadebuqKvesw9C3JtOjBaoEoP4lp/P0GgTSrr+8HbRPn6RSQxatOJDpm6dpXZyoCzh4SVms7qk3NYyHRvGtFFVbq8vA6omy23QnssRy3i1XvbvAPNeiyWIMLkFbzqzCG0Pc1f6q3lNu5RoSoGNmLH5pOLEbyUkp0Qe41/jRzfKiGSdsfzi0CpsYrZWrofVDbC8fieZwbQ+jH5Wrs9Uj3caIVu0aJaUfROny
 9ZR85vPk
 MKmW+Zl+0gf5BkqNGjDF8dcDu1CECkzFi57xDlDpa9pMb4n4ya8vYRrKrBs4DaYpk7C7Dr6ZZRnrgD2mEvLRsMrnQGMMA0mFvloqIQ+yps5EGgptSxtKZe7jvehWlFiz/6UkE8ofqoK2+wfkpsKMLmBBlUXyHGnKAX4+IggCacHjsSFgUs2kI686GzGqj77RybumUWzLmQH/E6N5IBEv42ldStW0Dnkb+tOAzlAmtUuUl2Z0qxrkvNsyafVkdFqO/2tgePIdenGHxh2F6T428LgolBN+DDfJD6AKesViYFnrwEoe3PBRsy/ubJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 14:19, Hao Li wrote:
> This patch series might sound a bit wild, but the initial numbers don't
> look too bad so far. I would really appreciate any feedback and
> discussion :)
> 
> On a will-it-scale mmap1 run with 192 processes, list_lock is the top
> contention point: __slab_free() and __refill_objects_node() together
> spend 44% of cycles in native_queued_spin_lock_slowpath. The free
> slowpath takes the lock mainly to add slabs that became non-full to the
> partial list.
> 
> By adding extra instrumentation to __slab_free(), I collect the following
> data for the maple_node cache (in counts):
> 
>   partial->partial    843017414
>   full->partial       550719384
>   partial->empty      17459564
>   full->empty         2
> 
> We can see that full -> partial transitions account for a significant
> proportion, and optimizing them can help reduce lock contention to some
> extent.
> 
> This series introduces the parking mechanism to address this issue.
> When the trylock fails during a full -> partial/empty transition,
> __slab_free() parks the slab on a per-node llist instead of waiting. The
> paths that consume the partial list (sheaf refill, alloc slowpath,
> shrink, cache destruction) unpark the slabs after taking the lock, and a
> delayed work covers the case where none of them runs.
> 
> Patch 1 cleans up the case handling in __slab_free(), no functional
> change. Patch 2 introduces the parking mechanism.
> 
> Tested with will-it-scale mmap1 (192 processes).
> 
> Summary data
> ------------
> 
> throughput             29237910 -> 35585663  (+21.7%)
> alloc_slab,free_slab   -52%
> cmpxchg_double_fail    -85%
> 
> perf data without this patchset:
> - 44.22% [kernel] [k] native_queued_spin_lock_slowpath
>    43.48% native_queued_spin_lock_slowpath
>     - _raw_spin_lock_irqsave
>        - 23.80% __refill_objects_node
>        - 19.12% __slab_free
> 
> perf data with this patchset:
> - 30.39% [kernel] [k] native_queued_spin_lock_slowpath
>    29.82% native_queued_spin_lock_slowpath
>     - _raw_spin_lock_irqsave
>        - 29.06% __refill_objects_node
> 
> Additionally, the number of partial slabs and the number of objects show
> no noticeable change before and after applying this patchset, indicating
> that this change has a negligible impact on slab fragmentation.
> 
> Detailed data
> -------------
> 
> metric                              before             after             delta      change
> ==========================================================================================
> alloc_fastpath                     155,417           168,534            13,117      +8.44%
> alloc_slab                      55,679,646        26,702,510       -28,977,136     -52.04%

It's interesting that this is reduced so much. Is it because parked slabs
cause more slabs to stay around for reuse, despite they are unparked
immediately when trying to allocate/refill? That seems odd?

> alloc_slowpath                           0                 0                 0      +0.00%
> barn_get                             2,715             2,771                56      +2.06%
> barn_get_fail                            2                 0                -2    -100.00%
> barn_put                             2,715             2,770                55      +2.03%
> barn_put_fail                1,370,488,457     1,668,257,974       297,769,517     +21.73%
> cmpxchg_double_fail              3,827,935           549,427        -3,278,508     -85.65%
> free_add_partial             1,684,340,964     2,161,921,625       477,580,661     +28.35%
> free_fastpath                       31,766            32,979             1,213      +3.82%
> free_rcu_sheaf              43,855,689,417    53,384,314,553     9,528,625,136     +21.73%

This metric (and others with similar numbers) should not be affected by the
change. Does it mean the benchmark has a fixed time to run, but manages to
do more work in that time thanks to the increased throughput?

> free_rcu_sheaf_fail                      0                 0                 0      +0.00%
> free_remove_partial             55,678,459        26,685,274       -28,993,185     -52.07%
> free_slab                       55,678,459        26,701,099       -28,977,360     -52.04%
> free_slowpath                  107,771,739        63,197,344       -44,574,395     -41.36%
> min_partial                              5                 5                 0      +0.00%
> object_size                            256               256                 0      +0.00%
> objects                             14,504            14,336              -168      -1.16%
> objects_partial                     14,504            14,208              -296      -2.04%
> objs_per_slab                           64                64                 0      +0.00%
> park_slab                                -     2,147,963,530                 -      absent
> partial                              1,398             1,367               -31      -2.22%
> sheaf_alloc                    743,660,288     1,284,618,991       540,958,703     +72.74%
> sheaf_capacity                          32                32                 0      +0.00%
> sheaf_flush                 43,855,651,858    53,384,274,983     9,528,623,125     +21.73%
> sheaf_free                     743,660,280     1,284,618,967       540,958,687     +72.74%
> sheaf_prefill_fast          17,585,335,850    21,378,958,833     3,793,622,983     +21.57%
> sheaf_prefill_oversize                   0                 0                 0      +0.00%
> sheaf_prefill_slow                   2,060             2,051                -9      -0.44%
> sheaf_refill                43,963,424,505    53,447,473,167     9,484,048,662     +21.57%
> sheaf_return_fast           17,585,336,335    21,378,959,334     3,793,622,999     +21.57%
> sheaf_return_slow                    1,402             1,277              -125      -8.92%
> slabs                                1,398             1,369               -29      -2.07%
> total_objects                       89,472            87,616            -1,856      -2.07%
> unpark_event                             -       315,397,838                 -      absent
> unpark_slab                              -     2,147,963,530                 -      absent
> 
> derived                                                  before             after      change
> =============================================================================================
> PARK_SLAB / FREE_ADD_PARTIAL                                  -            99.35%      absent
> UNPARK_SLAB / UNPARK_EVENT                                    -              6.81      absent
> PARK_SLAB - UNPARK_SLAB                                       -                 0      absent
> page allocator churn (alloc_slab + free_slab)       111,358,105        53,403,609     -52.04%
> 
> Note that some metrics have very small absolute values (such as
> alloc_fastpath, partial, slabs, and total_objects) and are subject to
> noise. Across multiple test runs, their rate of change fluctuates
> between positive and negative, which supports the hypothesis that this
> is measurement noise and demonstrates that this patch has no noticeable
> impact on these metrics.
> 
> For metrics with large absolute values, their trends are distinct. The
> data indicates that the primary benefit of this approach is
> significantly relieved pressure on the buddy system, with page allocator
> churn reduced by 52%. Additionally, free_slowpath decreases by 41%, and
> cmpxchg_double_fail decreases by 85%.
> 
> The PARK_SLAB / FREE_ADD_PARTIAL ratio reaches 99.35%, which indicates
> that the vast majority of partial slabs are added back to the partial
> list via the parking mechanism, reflecting that the lock stayed
> saturated and nearly all additions avoided waiting for the lock. The
> ratio of UNPARK_SLAB / UNPARK_EVENT shows that each unpark event
> processes roughly 6 slabs. PARK_SLAB - UNPARK_SLAB being 0 confirms
> that no parked slabs are left stranded.
> 
> I also observe increases in both sheaf_alloc and sheaf_free, which
> could currently be attributed to faster allocation and free paths
> resulting from the overall performance improvement. However, I'm not
> sure about this, which is part of why this is posted as an RFC.
> 
> Based on slab/for-next.
> 
> Hao Li (2):
>   mm/slub: make the case handling in __slab_free() easier to follow
>   mm/slub: introduce slab parking to reduce list_lock contention
> 
>  mm/slub.c | 326 +++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 274 insertions(+), 52 deletions(-)
> 
> base-commit: e7f630142df2afccce90555e4972e60008222311


