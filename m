Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E76C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324E86B00A1; Mon,  7 Sep 2026 04:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA616B00A3; Mon,  7 Sep 2026 04:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C80A6B00A7; Mon,  7 Sep 2026 04:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED8466B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:35:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 796AE40697
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:35:57 +0000 (UTC)
X-FDA: 85186308354.10.F1B242B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C839A140004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:35:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GlDV0UdX;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788770155;
	b=l27UzbztOEMkSLsDzK9bptj9YzTPeSXFqdlvtA3hg2v2r7yhpkBboeknGmGJgaly5jsm1O
	roLkIC3JI2w9QlAwWk3URX0ZMY16MZWaBm2zaLbZ2+NQizbFD1EBGcYnFGXkJE/AHPqWyS
	7eF5BmSksVb2JxIj97uBSovycqZ9Otk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GlDV0UdX;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788770155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmRDoct7riDtBKsI2KwhHRknGPzx1klC4uVT+9xvqPI=;
	b=fTlsKcGNBCEVB+9g8akLZLvsUYI8clQgT/NKtW3Q5mJ/GpSzijb2yUhYl3pHCgE5Fu0wcS
	dhgD2MtW1MbGhkbBrrC0s0trt1+E0kLug65vY/ddCk88PPbI1kTMh1yglpo67KAdN5uUok
	5Sk0e4DcMnzuOG7JNmJj8EXjJN89aNo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B64C943597;
	Mon,  7 Sep 2026 08:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC061F00A3D;
	Mon,  7 Sep 2026 08:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788770154;
	bh=AmRDoct7riDtBKsI2KwhHRknGPzx1klC4uVT+9xvqPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GlDV0UdXoMomtP016qtWdfhBcTL8gmddP/0T8F0MWrDwpxDQN2f4ko1Wocil4V+4O
	 HDiMG6LHFKKijrMY/6TKhDx5a+XeTmjTLFpH0R+2E9I8zmfOpIeOP4jpVvD1J6oiqt
	 r4zAGJtuddnX283jMvfQv5eopopQhFXVQCU400y1oiJe42/dF2HXBZZCpIA4/dAma5
	 G+MTqCyVIBxJ6lyqxpV6OxjC1tom5XFf6lhGhYlL8trsEjwuKFseaDN3Hy/1563AfD
	 idwFSfRBZGSexeqpYIZYA+bgizGrZT+uFCrKyDnUZ9DJRIT+UUNAEz6HFLpSLUqWu/
	 NFtqaJWO8/eKg==
Date: Mon, 7 Sep 2026 09:35:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>, SJ Park <sj@kernel.org>, 
	peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, rostedt@goodmis.org, 
	jpoimboe@kernel.org, mic@digikod.net, oleg@redhat.com, tglx@kernel.org, 
	david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, rafael@kernel.org, 
	gnoack3000@gmail.com, rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, frederic@kernel.org, 
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, tony.luck@intel.com, 
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org, 
	pmladek@suse.com, longman@redhat.com, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, dietmar.eggemann@arm.com, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 2/8] mm/oom_kill: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap53VD4AW_pWyNcT@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-3-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-3-ye.liu@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C839A140004
X-Stat-Signature: kbueuemtri46f7j5xbwepnr4bayae8qk
X-Rspam-User: 
X-HE-Tag: 1788770155-862680
X-HE-Meta: U2FsdGVkX1+F97aegBMmpfbZD+4rrZg2tFrG/3J9/yo84prpdkvxI32d1FBsB0J88igWKvVGid3pyblRd5whJnEufDNWsWiWyjYyySVkIr4M86b4ApDZ4yZpLvy30pszd4zo6AWnsk6nrzqCmoLj4AnKylI1a7WVQ6bQT0GNFvbl27pfbA8UY6gMKblJdBLMpj4VgVW9G+tJzPB2Kz4KjPXHB8KjFM9/IOPu5msC+dHmDl+UHLVQ9c9bK7hbOcqX28avym9uzm2pif6Mmk7OaEpwnBuoNHbn9EywAYd7oEGRf1JG7htGZskGpP1Mn2OeV269+Ov/iSbi+OoPBvtpPJTH0AAqbX5SVUl4XSC1bM3OoCiXkMzg0edkhPLU4uGMoZkA2qaL07k/zidPCFWKkC47AX7GRqM4uRVylPv3R8qKSl0jnkaBzzTOzZOP5zOgTp1T0RmjN8MxP8acQiUfdIehs0/zxHGBe0aZzAK66UUr+TT4TeoICrx0qNFG8G/NQ1jGdgk1fAK+0kApOYa/e1ho/jF5DVjgobRplrr/AUmeROxH/fNWqxj+b+fLdK6JkndRIBmD+jhl9hPb0glgCEGzFhZMvU28VUssHxgh2SWPpQ7v/A9WRn8o7qzFIHTeRLthGBH+kUchhWoHpA4cI7mUlGhsjs38XYLHbwWpLL8Kli61k4lRettmtt7RiKFiAWMNEQ3Y/Ix5ZeM0PI1UoUJCKDiBRtuRQ8m9Np3uH5KCszVsW3tEnkiDahXYuVMkTaAy5mBLS2/pWMekJPZBFgpJl8KobvCMKaqZSZAF/0d7D9mu657vKKc+KJzcot2BBeZKOF2GxJDRjkqncp/uL0FJUjg/5MIst7yTZ4RAb4uYFTHw/aFIcjtX691c1+Zt/H68TXJlxf7KwQd7wpSyfcbVUSQYNv7FzV7a+4ZHtZh2mtmBIoGtiX6hbMXdIAFW1ZeUbJ/w8JqcHvRtfRj
 fSE4s4Md
 LmKUNZK0cXO89BkplDnJ0ajNWM3xAZTlQ9N5gV8LpOJ++ZgecIwTtm6IhEWLkTTF5q9nN5m+F3PcbOkHCLeQZP6AWCLr9T5/QbAVzofQxSttESH9oVkppLQJH6vpoNbCpgJgxAQ1Ju9NxHlg2sMs7Uq8z3mW5VflK8IgVXeueq0opnBOU4kfS4BPO1cF+hmR4T7qlcgrmXjmoY1DdkUErAKkpPlNha2xNSXR7seaJo++77jgjvohz3AcVA3y3ocbgsjvo0wfY0UbRaEPnH4RvtGb/GmCQiQre0prsntF4NX4epsbzWtTDITmldn+eVrLGheAdLXJylcqxMzbKYppb5u+LY4RWrA0ArR2DphRBWsD3UF/KZliW4z2ch2PgpjcDYSPR00fmGR5Jj47gmd2FLIIBE0A55XgPyCJzfWYmh8jUi5ZTaeJiU7Aq+wxfRwqTKrtZ/zA+R2Skh1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:28PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs wrapping
> for_each_process()/for_each_thread() loops with for_each_process_rculock()
> and for_each_thread_rculock(), which scope the RCU read lock to the
> loop body via scoped_guard(rcu).
>
> No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>  mm/oom_kill.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5f372f6e26fa..ef2e1c423c1d 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -94,8 +94,7 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>  	bool ret = false;
>  	const nodemask_t *mask = oc->nodemask;
>
> -	rcu_read_lock();
> -	for_each_thread(start, tsk) {
> +	for_each_thread_rculock(start, tsk) {
>  		if (mask) {
>  			/*
>  			 * If this is a mempolicy constrained oom, tsk's
> @@ -114,7 +113,6 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>  		if (ret)
>  			break;
>  	}
> -	rcu_read_unlock();
>
>  	return ret;
>  }
> @@ -368,11 +366,9 @@ static void select_bad_process(struct oom_control *oc)
>  	else {
>  		struct task_struct *p;
>
> -		rcu_read_lock();
> -		for_each_process(p)
> +		for_each_process_rculock(p)
>  			if (oom_evaluate_task(p, oc))
>  				break;
> -		rcu_read_unlock();
>  	}
>  }
>
> @@ -430,14 +426,12 @@ static void dump_tasks(struct oom_control *oc)
>  		struct task_struct *p;
>  		int i = 0;
>
> -		rcu_read_lock();
> -		for_each_process(p) {
> +		for_each_process_rculock(p) {
>  			/* Avoid potential softlockup warning */
>  			if ((++i & 1023) == 0)
>  				touch_softlockup_watchdog();
>  			dump_task(p, oc);
>  		}
> -		rcu_read_unlock();
>  	}
>  }
>
> @@ -894,8 +888,7 @@ static bool task_will_free_mem(struct task_struct *task)
>  	 * are dying as well to make sure that a) nobody pins its mm and
>  	 * b) the task is also reapable by the oom reaper.
>  	 */
> -	rcu_read_lock();
> -	for_each_process(p) {
> +	for_each_process_rculock(p) {
>  		if (!process_shares_mm(p, mm))
>  			continue;
>  		if (same_thread_group(task, p))
> @@ -904,7 +897,6 @@ static bool task_will_free_mem(struct task_struct *task)
>  		if (!ret)
>  			break;
>  	}
> -	rcu_read_unlock();
>
>  	return ret;
>  }
> @@ -960,8 +952,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  	 * That thread will now get access to memory reserves since it has a
>  	 * pending fatal signal.
>  	 */
> -	rcu_read_lock();
> -	for_each_process(p) {
> +	for_each_process_rculock(p) {
>  		if (!process_shares_mm(p, mm))
>  			continue;
>  		if (same_thread_group(p, victim))
> @@ -982,7 +973,6 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  			continue;
>  		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
>  	}
> -	rcu_read_unlock();
>
>  	if (can_oom_reap)
>  		queue_oom_reaper(victim);
> --
> 2.25.1
>

--
Cheers, Lorenzo

