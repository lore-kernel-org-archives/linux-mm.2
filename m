Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F762C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C32C6B0092; Mon, 10 Aug 2026 11:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D1C6B0093; Mon, 10 Aug 2026 11:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414C96B0095; Mon, 10 Aug 2026 11:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3766B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:38:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F87A120193
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:38:14 +0000 (UTC)
X-FDA: 85085766108.19.AF561C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 06408120007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:38:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYA+p6dL;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=3uKn=GD=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=3uKn=GD=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786376293;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UD1jUU/Xp6ZTbXB7QP7I5IDt9vAd1Pf4TVWzTUto5Uc=;
	b=AqCyGvXmlRRNCet9FkPp4snjoLs4P8ajp/XurwTuCNk8A1FJekKpHLO65RWeP6Kc7DA7O3
	La9+pmkVjkenPqdPpRhrWIaj72x4inr3LjBmGICmXi8P8mNbyyu4nrXGgHClPFohhRe20J
	T6fk4AMYd60vRYs0s9xd76eQ6t+ADqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786376293;
	b=8bPE4GUUP+TSjZ1EtPibwCfqpeUwWqpHhYnu1DSMPQnZIiHGABJ+SQw4KpU75t/gzPJpim
	XvcDB5Kv7UiE3XsCMKgC2/ep6GtF8w4WX71zPTnQzbs3QdqUJRUSvNYQkbXGcLlTmWezsp
	Io++boklIF/ZL1eaCRX6v2xNvwMY564=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYA+p6dL;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=3uKn=GD=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=3uKn=GD=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 859B160052;
	Mon, 10 Aug 2026 15:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387DD1F000E9;
	Mon, 10 Aug 2026 15:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786376292;
	bh=UD1jUU/Xp6ZTbXB7QP7I5IDt9vAd1Pf4TVWzTUto5Uc=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=KYA+p6dL02ZGEdXx7zR35VtI8zyVtbLlfzKYRhERDFrrcBsfy+pzO8JmcSh8Qz/7y
	 MalDzJ+rVHBIlJmqjYEHaO21ZPbtLOqYV9/CazxEgNhDDOAtPKdFcbDKeXh6QIa6MM
	 Sqk3gFjMruWaaUNVdydE/bHwggT15Z7IzjlyrTm+aP0254CNoTFIuFupBzUW2+1gF8
	 i2+o3nQhjeNpz5PezqMlngimWvIwFoYh8VKJhSMiXm1KMW54L5ipjBzuivRKc7u9Si
	 8P9bmKAascdq6qv1IaU0S15GwJDUKj2VdowYiv4l2Pj1hqKze9A98+75DIHDODPviD
	 rV0Z5YRvj9SnQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id EB5B4CE0B65; Mon, 10 Aug 2026 08:38:11 -0700 (PDT)
Date: Mon, 10 Aug 2026 08:38:11 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: report RCU-tasks quiescent states in
 shrink_lruvec()
Message-ID: <0d6559c8-3b47-4300-bde9-9275e452d32a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06408120007
X-Rspam-User: 
X-Stat-Signature: i1i8fwnbxhoe37mckgwufdbzd91e1dx9
X-HE-Tag: 1786376292-702596
X-HE-Meta: U2FsdGVkX1+Gc913Dp7Vu4dgArpcS1df/Qn3j025+IZcmkWHkyGj3i4+j+TJMhdLnzDouCKPxguRZRLRGwu9tfDQk0mLkmw0uVvL4hJF6T3gvbj4kSIBqKjfQBBkbpuEoi7gbkBoTnYYxdaqkmbMpQtSIFT8eE2eFcLgEkUClTXY4yEqumtwSVmnITaWY56yngH93unFwTTWpJ8cLCE+KZGvdT+pnRTCX9lvPqtVU75yHk9p1zYL1lMcdOLANGzAZTtq9oRqj15+oszG6+YADHoxtehN5ppmZGWkkZDt34C2WwHx4Crgfgl3++Xb4SJhSK3k7S6Fal+uESJUu5YEzPmjKRLhu3qeRdRSylvNnwX3Lsq4x5dKkgfbuxoMIlBAhpDdZMR/oXLLd+HewvjVemtYIjgWS55/lsHjNDPwVlMRCHmi9gHulJYwyi6GupSQs0S4rexYjP6xKAuSffb5UvZ4vXz/P0BbuizgnFwXxvFVixIGfSTiRMb3c5Fc6PLXUsBDda8NNtCQe5ICLaKo6r2hh5XHjFE1u7f8Nxh6JE90ZD9B/AmTfZ3SeA3eYUugqjqoTYHAbqiGulRiEXAYvjBpG2hLAnM0drxUhtWnYcvvtOwXU2B9ylx+/WqBCmgR1k4O9ieH7tEaUYc2WqeN2QIWatK3w2lv5nSD6XZ8FD+2w6AJzLNRk/D/STlReLOG6hIsBdA1nQqte6qBxBtIKtWx6zLvesmmMACHPIT8LI5eQiD464SoBTfQh91XCTasqkQWNtSPDBL19iNuQvISynqFerJggm+XuHCJApPdH+NZThO0B6LRaiPRMGlaanhP/SZFQQWbdCkqBkqDsKIu13Oxxdy2lTV2UyGWYdB3y3Gvv+oLlQDfwnKhwKrY11tmHbPYE3IX8qH2AOvzfE2WPl100KnnuOALoyg76alOW+7MqFFf80zDzjpsVWua4q2hPkjipRmN2q9ZObyL4tH
 uTDis/t3
 Rz5Z74DcDg++vorFDIOrbQemsdZfLHDB8fSBko1oamlGZ2A+lvgnTrNUlC5GuOmTKJY3U2kGLuvu5xoYBJNeBPrP1HNQadgVUNvTl8BEYz4ynqxB8SDMouRI5B6HQyvFZsPChF+hDzWSjLL/EIl679vRuIJfWbt79jWhDgrpaV4w5h/mUiElnKABEjtfDF8uoyRHv2Sh82KmGUkNKaAdF572CTXDjeos21Z7qMXiiYKYSivEef9U/yQ6jcazD+qd1Or0IREeZK/dGrUzZf0I+AmBNYwcITDM88NK2vU/VkjgNaD7C5xyjO0GN2lm2WuCMKvZiz2iTFFf0ITAhRxoTp0YHcCLJCvecUklM44j+PhyuYVK8trjmER4zIBjXbWrMviG1NV87UI9WOxDyszh4LAbDad56aELqA/4DnhByzNFsI3qcKiGJj70FKShlfD3a2qwjarSTZGYoL7c0QJdulmZCrYHF39j3DlbLlCWhUFebZJ7if1+jAqvZdmIfSJNEQ/ZL6H2VnfNmxtMeHSpR25rm8IlDrCgGwU46FQoSGPS4Rk2JexrPq6a0iEZEcdvUhTVJQkDE5AGHR3c9ZDZIic3TcFCfhLnEUD0M37I0VzLF2SSQd0MafJ2mToG4PkaqdcJsA8PUJY8UpJzLd00TUA5Zjdjw1spVTQkWrdP/yIxVB6PFGUJNG5rxBpaIATNSedOltLnfMmulHwGKZn5igTvwae1sgC2JiSPlM0zHbm1KGejm4JPL3GQ/w/pQ9GG6GsnFqMDKlhM3CIRNBFhZJkSk4snTj1LKQjIOrMn38BWzKx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 02:57:36AM -0700, Breno Leitao wrote:
> I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.
> 
>   INFO: rcu_tasks detected stalls on tasks:
> 	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
> 	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
>   Call Trace:
>    shrink_lruvec
>    mem_cgroup_iter
>    shrink_node
>    do_try_to_free_pages
>    try_to_free_pages
>    __alloc_frozen_pages_noprof
>    alloc_pages_noprof
>    pte_alloc_one
>    __pte_alloc
>    handle_mm_fault
> 
> Nothing promises direct reclaim returns in bounded time, and the scan
> loop in shrink_lruvec() only calls cond_resched(), which is a no-op on
> PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU
> quiescent state, so the reclaiming task never reports one and becomes a
> holdout.
> 
> Upgrade it to cond_resched_tasks_rcu_qs(), which reports a quiescent
> state even when cond_resched() does nothing.
> 
> PS: This has been discussed in [1]
> 
> Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 26436059ea394..6ac2fde137b89 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6023,7 +6023,7 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  			}
>  		}
>  
> -		cond_resched();
> +		cond_resched_tasks_rcu_qs();
>  
>  		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
>  			continue;
> 
> ---
> base-commit: 6b8c8af514d739d0335f5579b585e02babe8a727
> change-id: 20260810-rcu_task_shrink_lruvec-711112e87de0
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 

