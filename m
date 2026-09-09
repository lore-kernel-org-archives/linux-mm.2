Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B25C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08866B008C; Wed,  9 Sep 2026 14:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92A06B0092; Wed,  9 Sep 2026 14:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A516B0093; Wed,  9 Sep 2026 14:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4A416B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:16:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F617160302
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:16:58 +0000 (UTC)
X-FDA: 85195030116.16.6044AA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9395C140010
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:16:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F84p0yyr;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788977816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmS7BNxOqmi+BeNsZ4oZ5oXHisCR+XOxA/iRVryaknE=;
	b=7UY0hEjtpu8gf/ukD3ucATz69VoffN36Eqs285/grVQBGvFLruwLka7tE3UNEjMvF6YwdE
	+AAyFP0AjJHBJAQaHhCbxidmdqzy34/YzHvr91sHb7v/lMjNSJGzZ1Qfwf3PkEguGQbffx
	1v3IrLQcPERkVWfL9PPjRDblAoz9o0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788977816;
	b=x8Dts8DsMSULnkwPU8sv18rJaY4Z+hr5gz2/TwGQJ2w2F9QHa1l/XQ9QaS6VVznGJn4alv
	UB67qK4dEiesNh3rJBMlVCJCOWYZPBoJ8lS3rAyogr1fuzIlGBesMMyZB0kn/0UJveGMYO
	Lp81dOrwEbDp7sQ/I9QpPSS/RnVSlcs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F84p0yyr;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BE54600CB;
	Wed,  9 Sep 2026 18:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962401F00893;
	Wed,  9 Sep 2026 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788977815;
	bh=rmS7BNxOqmi+BeNsZ4oZ5oXHisCR+XOxA/iRVryaknE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F84p0yyrHbvT3bpXj+VWGL3evahoR6zG0wTE9+bL32gjOuuHYOcp5jRBCTbBmoesc
	 nUKlyiNo9zgpaA1uQE+puCh0ulCe9TAqCoBisChJDtgib1rgRlKWc7+knS+n4fuz4S
	 7nSvSwwxqSBsjpa10PXbYDQrFUAV4uGXkFkb2cegO3tPzaqvJNFR9GsDup3MBJdb/o
	 fei0wlIm+cnIeuSWoNfnkZ1S+pAZI84YMz6dsergpXxLlscYpxsi9ZysTp12TVyTtQ
	 b3Y46Ko+oZeGMBiX61KqHlpy4oI7w2IMj6zZPs5hTSlM2IzjYjJGpK1FxVMWDoLj8y
	 b9Pscs7SP3o2A==
Date: Wed, 9 Sep 2026 08:16:54 -1000
From: Tejun Heo <tj@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
Message-ID: <aqGilhgcEd0qaHjI@slm.duckdns.org>
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 331tscyym5rwzhc5uyzoxmupj7d6mjgu
X-Rspamd-Queue-Id: 9395C140010
X-HE-Tag: 1788977816-103036
X-HE-Meta: U2FsdGVkX1+obqBTYbgX0bhJmd1s4Og1seAZAH37wmHX9UlmPcSwM7MPpcYYPh+HYxWUU6bEfArw7EfTpiqzk19PHjdJgndeHlIwrOlIqSR7Io3DURo5hrHibAHtZXKdNUlqJ1NaSMCQzQZLO/r4HQ8gxHzwFSghWDc32Xh31EfhLDmcEtHO5TdwihxHU0mve1qyZdH20ybdK+D+M42a5wJ3wDjIQD22w11/RoEi7GkS0y7ggGICPtkJlVRHpw4hs9TQ0ZtOHKMevJXk6pL9YsRLG70CSj6C9OHzY8WxN3+wizcC3w2D86lI89fxacUhf8Lui4MpfGYyVLOzZnNBmxWQ1E5bO3kd4QScFs6oyUUN522EwCwWQ5ljXECXTo5AH9ZkKu7D+OVfybWs9iR+j4hjKep0G4AznNk6+L6Rgtf8+dytm6R0IFsfSPNXHhACw+RzkMIGoccr7/EoE1+uLXj1TJTWX2z9/OwbLmqDxSRh8CL8uvfPFDvGPlxT3czUHSKczKaCIGIJVH+GPKsQ/XnEJF0pRjWqwdwwWFifT41q5mi8de4/kWmeAQtigAQG3Wy/jmja3Cq7X5zZAwygjOc6dfb/pFsaS1/3fgkHHbyXSftQo0Q3p6byKE5lL48UO/U8aLcMj17mQ7VVfpTUzdeUM4W+FxIP9iCeICLyK7oPlY2sSAEO63eK6lPkuq0VZk5s2njTISrgtMQPrrvzWBt81X5IL2sFECvdZdQNiqN2E/IG6ogCBeCUsH9tiy4rAqUQae1kkVOLMN3VwgcexUBijQI8CCWl0/Kgb8qwOdDKyAMpnmoaVt/Ko/N95G2NpM4AkRq8ivN3tPehkD8vQAlSkUhZF3fM0SGV1WNpNWCn4zWGWizrV84yQtHdFmIFY/VpBHLVHa1fIk14UoGULmM2gKvkw3tut1cPmYVnoPUQqZ45sMLzTU+wGPRsRlmPHwQ5ynYEONoYtpW+IwD
 7fJZabBE
 zjqpGd+uORDVwQJ2oAbHoDUrOD31WPqC4OQ8HbVkVgZVUAphdz8Nwaq0oeY0YPp/gi3Mo0ZQUf2aS7+kMSZ5fafJQnL3mgM0kAtA3FPTWvkOuE8ASMcZd6G4bmXm4ptCEcPRB3RWgoohqkbcUbWz4Y/kfDOGRT3gmW44yzkUfypqxqQh9mKUEpBUvI/sT8cVex06/d4YbOR0H4ze7alUg2K+rVSkOeuEppLNrciKaV2N8J5XjfkKxzFNIJgt59q0qF7xSOQmbsgMdYRiSXXUpHbAnP+YBo066jE7J3b7ViI2Yypg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(cc'ing Paul)

On Wed, Sep 09, 2026 at 06:01:07PM +0000, Josef Bacik wrote:
> cleanup_offline_cgwbs_workfn() drains a dying cgwb by calling
> cleanup_offline_cgwb() until it returns false, with a cond_resched()
> between passes.  On a CONFIG_PREEMPTION kernel that cond_resched() does
> nothing: _cond_resched() is a plain "return 0", and under
> PREEMPT_DYNAMIC the full and lazy modes disable it.  Since commit
> 7dadeaa6e851 ("sched: Further restrict the preemption modes") those are
> the only two models on the architectures with PREEMPT_LAZY support,
> arm64 and x86 among them, so the drain loop never reports a Tasks-RCU
> quiescent state.
> 
> A worker draining a cgwb with millions of attached inodes runs for
> minutes.  On a 6.18 arm64 host in lazy mode the cgwb worker drained one
> dying cgroup's writeback domain for over 11 minutes.  A BPF program
> unlink (bpf_trampoline_unlink_prog -> bpf_trampoline_update ->
> unregister_ftrace_direct -> ftrace_shutdown -> synchronize_rcu_tasks())
> waited on that grace period while holding the trampoline mutex, 42
> tasks queued behind it in D state, and the hung task detector fired at
> 614 s and panicked the host.  Any BPF or ftrace detach during a long
> drain inherits the drain's length.
> 
> Fix this by calling cond_resched_tasks_rcu_qs() so we do not stall out
> anybody who calls sycnrhonize_rcu_tasks().  We put this in a do { } while
> loop because if we have many small cgroups cleanup_offline_cgwb() will
> return false and we will never call cond_resched_tasks_rcu_qs(), creating
> the same problem.
> 
> Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Acked-by: Tejun Heo <tj@kernel.org>

> ---
>  mm/backing-dev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index cecbcf9060a6..18e999053bae 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -910,8 +910,9 @@ static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
>  			continue;
>  
>  		spin_unlock_irq(&cgwb_lock);
> -		while (cleanup_offline_cgwb(wb))
> -			cond_resched();
> +		do {
> +			cond_resched_tasks_rcu_qs();
> +		} while (cleanup_offline_cgwb(wb));

The patch looks fine but this overall seems fragile. cond_resched() was
already marking "stuff that can take too long" but we need to use
cond_resched_tasks_rcu_qs() if it can take *really* long. There gotta be a
way to make this more maintainable. If always doing tasks_rcu_qs from
cond_resched() is too expensive, can it be be gated behind something cheaper
e.g. some tick based test?

Thanks.

-- 
tejun

