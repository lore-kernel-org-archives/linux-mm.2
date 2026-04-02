Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8EA5111227A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D116B0088; Wed,  1 Apr 2026 23:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDF96B0089; Wed,  1 Apr 2026 23:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104076B008A; Wed,  1 Apr 2026 23:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF9F66B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:27:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CC11E05C1
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:27:26 +0000 (UTC)
X-FDA: 84612180492.07.0EEB586
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F90040003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:27:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZOpCm0Gj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775100444; a=rsa-sha256;
	cv=none;
	b=2WeK2kCmthZVANVGP+DJC/liaTI2IGA452BMfQebqyGBjyyxm2tN+PbkLv6mRgazKwjrmE
	/pHEh/tCU2rx3F7aJfS2Tv7nBdEpJEs4o1GvDOssQh2Hp40DpYFY6sCGM6k3gGN7zbitwO
	j9nLIYCUp9k4DXr2Y/Ljz0xfxiHFTC8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZOpCm0Gj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775100444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KS7jUQ5z3QD/YU6KBR6Avx9Mssc8IPdaIaAR1un+fkU=;
	b=Vx82ghx5s3ztqhZSlkirCV5ZJ7qdjMwpmBM239f1rQTr2BlEeb+1Apa3zT278dY0NUBYmk
	KMblcbSLCcx1b53Q5thDAEAnPSJj4BAMN4QpRNDUhd1pRArKBn2Qj/0oAhR0NPILpiThyX
	/H9kPLb24BnWwObAc9litT1DBBm9Oms=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775100440; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=KS7jUQ5z3QD/YU6KBR6Avx9Mssc8IPdaIaAR1un+fkU=;
	b=ZOpCm0GjdR5FrxZg759N/yMkJcivfKMFFmiSEH6YeU9NZEXD+sdo2din0Ps8W47sqvQdGJcelrUWga2Gx+tVmd79J9qCBDQmmFXtshL1l1nNNbDrUu80MKwA8FSSHEg78wD3V6YiQ0Iyh1xDFlyebyv583Jg6XzoCJwP8oLIFnA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0FmuTa_1775100433;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0FmuTa_1775100433 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 11:27:18 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Ingo Molnar <mingo@redhat.com>,  Peter
 Zijlstra <peterz@infradead.org>,  Ritesh Harjani <ritesh.list@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  Juri Lelli <juri.lelli@redhat.com>,  Mel
 Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
In-Reply-To: <20260323094849.3903-1-donettom@linux.ibm.com> (Donet Tom's
	message of "Mon, 23 Mar 2026 04:48:49 -0500")
References: <20260323094849.3903-1-donettom@linux.ibm.com>
Date: Thu, 02 Apr 2026 11:27:13 +0800
Message-ID: <87wlyqt52m.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: iegi7ef1g78ne8i5yewym5kocp7s313x
X-Rspamd-Queue-Id: 0F90040003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775100442-146355
X-HE-Meta: U2FsdGVkX1/DOwG8v0swyilpFgOvmHc/ZlMNve/AXIK0G+rjqA76TC6ZHd6JLVbuwFAdIKY5UFk7Fbz1278G2q6CqSGdX8RqJJbJ0K4h218lQ1Pqkzs32KU9GadVuAJz7E1D1N9S4qU1ECPj+Tg+ivGkVwvfJ4D6GsRVjZWLzHHOMsdbttQKTN67SlawKMux6VzWVS0mS71LMsjU8RyTGFRbKFCJzNOhH72QS6XJ6XCZHXt6kYVyrOb1bhHhSglCqGxcrcLvU0GwuTYsvReKZnGt9aWSKwxyDcqJ27s2aeHqKauLsswwLfg0IIVPL/WQhRfAX4MNtkPLPevHCQ3efWxLdR32ry7zPnRwEqrEkS4qvufrrX/ALKGVyBSgPWHJaCUygReRQXTszr+3M9AsSuaFA+4pbO5gShEX25ifHfksiabDRx/fv08VSttzgJZFV2GTRccAlGne+gzPkgvFfhhW2be+zGXTELCX94xOBxxPBMdHmUGFSF2Vy4r70ynLJQOHM1yvcHzNsh29an1t5hfUPAhw/MgXdeM4x62xCzAc8U7C8uYO9bjZpKAF9R7gjsdX9cHAcxlexdZkAh7NjSWWnq5jqYwubuJ3sLpGpstMyFxPCj5cKJDZzH92sZ9XdME4r3SnrfCRkPUj+6fn67We6usrvGDUXOFo6Yf0wXqrqjuKQX8eCOiJfp1sZTBSJRE/l95kdH1Vg6eqTTSQ/K265pZh9UlM7xWIN76IS16CUbx8xWB2f2nn61gEVmvQ6e5MvN9wffRa9+5Spt961W7ZBDQI0fMIHG/l2DtunNLAT5UMuzoJ48zx+rUJPk/FmQ3xUL/jkiqms1rHwctws7CVb28V7xUWPovK5ojkgHr6wbQ19QHiiaJD+wd1ZZ9L7bmFVZfaUxuGm3MsXxlvccv3swN9nt7R93y88Rv5JUVXdcKRuoWwEU7iK0IquybCFaxupPyxBZFtGENZOEo
 tGBz4VJo
 n/+AiZuEkaR4t4qPjiZGdZGGE2B8xH5l0Yzz+TTCjhtdGQI/AljdT7C0GJx4V/SnhllEKGmH7X1ZgSGZqL9LfxHfbQyn6wWQ23FU/lqt679EU37lXg9BXYh/j25QC+EQ5z0cF02fd2BHD85Vg01t2jTVJRc9YCjCCnabAWr6BIp9p242uOyJrHdL1xMzD5nzHQAkQkB0DBZcWx/yjjmzkjSKJ7a/tLxGhHV4zHweO72853sJbyDrVb+c4D2vdgKpexX/Zs9+QrXyJT1UdlqwvIDAoWBbXgF5mOlQKJTWl6NE7kTNZwB7AmqNlYtMjq2pQn7sXJnJrGoeFZ5iCvV8inQlAtPQi+/x2YuRrBBqGPv5UVdjm7RMTMJLKTp0163MK2azPoRjonbn6C7/KVLWYrgcHmI9LQy9+OjN/PwU/oxEyZLpASOkRfiB42g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Donet Tom <donettom@linux.ibm.com> writes:

> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
> disabled and the pages are on the lower tier, the pages may still be
> promoted.
>
> This happens because task_numa_work() updates the last_cpupid field to
> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
> enabled and the folio is on the lower tier. If
> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
> can retains a valid last CPU id.
>
> In should_numa_migrate_memory(), the decision checks whether
> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
> tier, and last_cpupid is invalid. However, the last_cpupid can be
> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
> evaluates to false and migration is allowed.
>
> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
> disabled and the folio is on the lower tier.
>
> Behavior before this change:
> ============================
>   - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
>     nodes within the same memory tier, and promotion from lower
>     tier to higher tier may also happen.
>
>   - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
>     lower tier to higher tier nodes is allowed.
>
> Behavior after this change:
> ===========================
>   - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
>     between nodes within the same memory tier.
>
>   - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
>     tier to higher tier nodes will be allowed.
>
>   - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
>     enabled, both migration (same tier) and promotion (cross tier) are
>     allowed.
>
> Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
> v1 -> v2
> ========
> 1. Dropped changes in task_numa_fault() since the original changes
>    already handle runtime disabling of NUMA_BALANCING_MEMORY_TIERING.
>
> v1 -> https://lore.kernel.org/all/20260320092251.1290207-1-donettom@linux.ibm.com/
> ---
>  kernel/sched/fair.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bf948db905ed..4b43809a3fb1 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>  	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
>  
> +	/*
> +	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
> +	 * and the pages are on the lower tier.
> +	 */
>  	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
> -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
> +	    !node_is_toptier(src_nid))
>  		return false;
>  
>  	/*

No.  Even if NUMA_BALANCING_MEMORY_TIERING is disabled, we should still
allow migrate pages from lower tier to higher tier via
NUMA_BALANCING_NORMAL.  If we have precious DDR, why waste it?  This
follows the semantics of NUMA_BALANCING_NORMAL before introducing
NUMA_BALANCING_MEMORY_TIERING.

---
Best Regards,
Huang, Ying

