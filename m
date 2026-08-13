Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B7DC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43396B04C5; Thu, 13 Aug 2026 07:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A556B04C7; Thu, 13 Aug 2026 07:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE36F6B04C8; Thu, 13 Aug 2026 07:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6E06B04C5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:40:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A928120119
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:40:56 +0000 (UTC)
X-FDA: 85096054512.18.9452A4D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11411C0007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:40:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LITWw13m;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786621254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDI4z7xvtwPvzwcl/BrUgP03BBaO6PU0ELtLn2RsLHQ=;
	b=tjHkz0Wl4wLw070yWGB6GPPMvrsQdcEN/LEIfkAljOTS7LseXi/ey6VQD4BoYDcI7J82gC
	ez3SIlD8+3pFwRL0p2uTjb8DyhifSIKq+cyTDAhVmuLp2+cCGfw00ShiQnGVhJpTgSSMjd
	aGX8KOzot66Flue/Oe1yBKiNaL9z+Ec=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LITWw13m;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786621254;
	b=hIjCEFumRe6AYmuD57kwtKy1dEpW9+jqhqrUFBZBQ0qBFJ6aDgq0vfpnPL6n5nADrMP/Hb
	ekBBnwCaAOTEy9/Ks5MhueCqJ6HH9lR3zMuxUQXOVMgrGvOE/3ccFMgNYCJwwzKzi5keQ2
	TCza5LybbDz8qPkkxU791TS6pQobxrk=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49800c6a846so20944085e9.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786621253; x=1787226053; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DDI4z7xvtwPvzwcl/BrUgP03BBaO6PU0ELtLn2RsLHQ=;
        b=LITWw13mQtiOSfpRGkLL6JFKqpytpPH16EpEY+a3nyNDPdePG4XyZrTiwv1EzhH3sW
         QwCjYPFgTaPJ8Vdy/uMBXccUm0yDEozD8sxbijo8hZaeXeyPldDa7zvFuNpmkuPP/+2X
         EzzerVLI6XdbafdM17fPNYGVg029QQq6l00SUqCSnnf2tvdHnwsL9tM9II5+UOVfIuuH
         2zM9uF83opF+0xI7qaKuEGN6X5RfqTPhPwy9sm6lN9xmjb8kEl2f598zLPCqrU/CfOga
         FUE1EytUKVh5BHisadpZLbkSE/ntbEnMxQJywT8gR6sFXEM1xSaIfWno0am0SY3b0QYL
         zCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786621253; x=1787226053;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DDI4z7xvtwPvzwcl/BrUgP03BBaO6PU0ELtLn2RsLHQ=;
        b=Q+BXtqnVt/Xq16bkiAUo2qlYEz1zRSPNlN7TGTrmLSVU+bKb+3aJxVh9+sBin8cm12
         UPcmggA0c/AllDiT4gKUkMzk08bq2OyRKVdd5hYw3+L2WZUuE1HCPTSOpIWK+jVHS7cj
         QFyB7fEbmy9xnOmbXtSQ8qJnzLTj+pQAIi+usHbmq0uSv9r74kJokwKYsTMt2546uVxS
         AKYCfa6g0JCburoaayQ+sOkJQU9/S3feYJY8fbVx0DegutZhM6nhpEc7KICJ/zuzxm4x
         ujQmWbUQ9l/eSgGwEVlRNzo9oXft/NqJhEdlP0Pv67DyYxxjT9BhP5EzVHIY1ZsQQmYn
         9MdQ==
X-Forwarded-Encrypted: i=1; AHgh+RpYHYEOiMxdGs1r/VBrVFVIFZaHgFM2vJpfmTf9ZQWcvGWfSTfvMk7GvgFziuZHlMMdvcDXA+SW5g==@kvack.org
X-Gm-Message-State: AOJu0Yzk7NABlEH50V9e/mlimtP4iCp+j9xh70Z9TpRAZAMAoIA3zX7j
	fj5jH1FUKva40ZrjpmzK/124tmWroNgskd9cWU1s8gRAaF2SkKl0cZ1T/PzB9wVwa+Q=
X-Gm-Gg: AR+sD115ad6xbvMn1l7h3v7NmDmvHSlRAR2mDjM3NqCj7Mc3zld+Ben/3FxKMYIUWHw
	uFrom/se/wlYAivsdIVqzWf/7/LqANptg5NzTFje2FcG+1nLpTpP3gLbkFc4lVOH5JTu4+jzz+4
	22r3uuf6rHASOcjSxa0BUyHumYrYRGVTl4puKaoPxri9EOM6Jr0e8eWFjGeBAflxtaf+SLUunBQ
	cLbEoj2oIHjbmozGZAJ6uRQLYE+mlbZsjgMQtVib6CVkTX833N5JriLHFuuRDi4EXRg5LF139ME
	wVXZf0th2rBCn1acx45qhQMqzDqYtuVbS63TEzNXU+jdXN72gS2LS22x28oJT70VdZ5l5dIdTyO
	HEfapwNawA+5ZkCZwcOv+rjG1rcA602Wq6yRE3WLelN5236VEzn8SdmTLvLFoHCNT06Z3oahopm
	Zv3zaKt4Mxea+g4uzsPhVpivlpnE9fnWcZ3M0jopBBiRR9k9h1zQZ15QvhhsC+AuCMxH8ehzU=
X-Received: by 2002:a05:600c:45d5:b0:496:ca1f:a428 with SMTP id 5b1f17b1804b1-499821d26demr50094245e9.19.1786621252545;
        Thu, 13 Aug 2026 04:40:52 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49982121649sm55382155e9.1.2026.08.13.04.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 04:40:52 -0700 (PDT)
Date: Thu, 13 Aug 2026 13:40:51 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/oom_kill: simplify remaining RCU sections with
 scoped_guard(rcu)
Message-ID: <an2tQ90mloFCU9T0@tiehlicka>
References: <20260813092933.562028-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260813092933.562028-1-ye.liu@linux.dev>
X-Stat-Signature: rnfrsr5bxzc1ej593tfqh37wjhjmi6c8
X-Rspamd-Queue-Id: 11411C0007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786621253-645381
X-HE-Meta: U2FsdGVkX18LdygTVIyc1kwMVazx8uysT80RPdFgqJTqAucaJMt8rKTIVX6DD4YKCuS+lYWZxLmUvNQ0zSBSfrM4v6Jhfh7f02YAsEXv4nMNf90zaLDb7l30VHTcx0EjT1LJlAc0UaZGUHV02/5m9Z9e1m5z72sYai2xiepeH39afSNqU0+CiTKEfC4gN/g165BnNG0CALJRw4K6cnOTxfRNlptNpW7J/Yi/8rkptvG5iBzUPQfY1o5mt/kQz10gObXMpYHUNtkJpwG5u9wnpewi77j+x1BzYz0LuYfSJYb/3XGbzROj6wqV37IO8EYPAhHwq5zAjfHY2Z2Txaw4rbBut8gjPjLh5xpRkqQClTw7xVuoPOrJAVYxBBWeIbfBGN9rKonIhuTBFj2hXAe7XJDEMenLVeYoF6Rj7Bqb6ywTrqHUtANLpJww3+PiVEg0Q4oJIyXFgcxFD5VlYM/4gAFj/2XvXg9mWCK7ARpJsnQzJVViYAb0EmLxO6lWf19CLdGQhbsu1wRR3EY8BlgQk6CltaaXFOagZ5mgF2HKsQDk7mkD4wW0ChDH02g+7hYAc/TI+XDW1+lQe/AwrqwZnvRc0Y4pzahiaE8f1Udx2CSSVOno6o5HrGSy9dGWdu8LB8jmfC8IcuBuMmbX6fLJX7KkYKFJV713k7BafL2AWRoVsf9FXJNz6PSccGFER84cQpFVqbO6iBELqbEwg9e7WI7gwEiMzCVGAWbq6r6r4nrLBYO78O8n8CjJbBe/8gqqC3aub1Jbc2544PYgI/W8PEBI8HC6UCLqtFhBMLG022o43D2YhbCNy2erY7Qedpb4pOSLYi50HEAKWAmP1EGdqty4fIILosVwmA+PfTxO2lVncI+oTXXtSeZm4m0KgTEcZtpF6ti7ymBs4TlqL9ZBxG9aus9ijnOvhmR6o4iPgEuzQyvMB685B6SmA9Jz5g9MhozNuC5PoNFQ2d2jp3o
 2Pi5NY2n
 wX91ib/iTtiSlttuu23QuYxhqWmetkhTflC+jSu95d22HDrmP9bk44SKG0E7zoxeG5NWQBFPVMZnJcgV8fxalu40lAiDrR1qftSJL4wibIyvvgGMJlLwobaXEL7/i0XzCh48gJv5FBXuWHVu3D6UYBiBhV27+c7Pt0ZABOr/tLPfj+chZYgW5M2XoUhBim09QCv/8sdbIgww/jbEz1wtodEARz34r6W9UUToUW2HoeetOhrY4Y7yDPQEjBkl9xY9eYxcBrp+u05YDMjXaTHZurF8DfOgmjoBkrAma4l5Izeo15xq39i9UAoS+02IL2jFRvvGTuS4nCeo1x6/hpU4dbU6MvXimxi9m6Nwr+Wpk89UKNbUfrknv0BULIGqt4Sj0tHTyM6bGENnHaYutT7fwD3P6N/Xp29MRi/D7q209/EWyKaqJkhzNyj3WPZy7Oyz3uh9rEyEz3Qtvcxpn4HP4qpqK1p2QWghfpC9h9kSNOuJeJ7RQM2i6BEpPD24jJIe41Nzt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 13-08-26 17:29:32, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the remaining manual rcu_read_lock()/rcu_read_unlock() pairs
> in oom_cpuset_eligible(), select_bad_process(), dump_tasks(),
> task_will_free_mem(), and __oom_kill_process() with scoped_guard(rcu)
> for consistency and simpler control flow.  scoped_guard(rcu) limits
> the RCU critical section to the loop body rather than the entire
> remaining function scope, making the protected region explicit and
> safer for future changes.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

It almost looks like for_each_thread and for_each_process could gain an
rcu varian that would do the rcu thing internally. Have you considered
that? I am pretty sure there will be more cases like these.

Anyway
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks

> ---
> v2:
>  - Use scoped_guard instead of guard.
>  - Link：https://lore.kernel.org/all/20260813032634.344946-1-ye.liu@linux.dev/
> 
>  mm/oom_kill.c | 124 +++++++++++++++++++++++++-------------------------
>  1 file changed, 62 insertions(+), 62 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5f372f6e26fa..0e8982e5be51 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -94,27 +94,27 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>  	bool ret = false;
>  	const nodemask_t *mask = oc->nodemask;
>  
> -	rcu_read_lock();
> -	for_each_thread(start, tsk) {
> -		if (mask) {
> -			/*
> -			 * If this is a mempolicy constrained oom, tsk's
> -			 * cpuset is irrelevant.  Only return true if its
> -			 * mempolicy intersects current, otherwise it may be
> -			 * needlessly killed.
> -			 */
> -			ret = mempolicy_in_oom_domain(tsk, mask);
> -		} else {
> -			/*
> -			 * This is not a mempolicy constrained oom, so only
> -			 * check the mems of tsk's cpuset.
> -			 */
> -			ret = cpuset_mems_allowed_intersects(current, tsk);
> +	scoped_guard(rcu) {
> +		for_each_thread(start, tsk) {
> +			if (mask) {
> +				/*
> +				 * If this is a mempolicy constrained oom, tsk's
> +				 * cpuset is irrelevant.  Only return true if its
> +				 * mempolicy intersects current, otherwise it may be
> +				 * needlessly killed.
> +				 */
> +				ret = mempolicy_in_oom_domain(tsk, mask);
> +			} else {
> +				/*
> +				 * This is not a mempolicy constrained oom, so only
> +				 * check the mems of tsk's cpuset.
> +				 */
> +				ret = cpuset_mems_allowed_intersects(current, tsk);
> +			}
> +			if (ret)
> +				break;
>  		}
> -		if (ret)
> -			break;
>  	}
> -	rcu_read_unlock();
>  
>  	return ret;
>  }
> @@ -368,11 +368,11 @@ static void select_bad_process(struct oom_control *oc)
>  	else {
>  		struct task_struct *p;
>  
> -		rcu_read_lock();
> -		for_each_process(p)
> -			if (oom_evaluate_task(p, oc))
> -				break;
> -		rcu_read_unlock();
> +		scoped_guard(rcu) {
> +			for_each_process(p)
> +				if (oom_evaluate_task(p, oc))
> +					break;
> +		}
>  	}
>  }
>  
> @@ -430,14 +430,14 @@ static void dump_tasks(struct oom_control *oc)
>  		struct task_struct *p;
>  		int i = 0;
>  
> -		rcu_read_lock();
> -		for_each_process(p) {
> -			/* Avoid potential softlockup warning */
> -			if ((++i & 1023) == 0)
> -				touch_softlockup_watchdog();
> -			dump_task(p, oc);
> +		scoped_guard(rcu) {
> +			for_each_process(p) {
> +				/* Avoid potential softlockup warning */
> +				if ((++i & 1023) == 0)
> +					touch_softlockup_watchdog();
> +				dump_task(p, oc);
> +			}
>  		}
> -		rcu_read_unlock();
>  	}
>  }
>  
> @@ -894,17 +894,17 @@ static bool task_will_free_mem(struct task_struct *task)
>  	 * are dying as well to make sure that a) nobody pins its mm and
>  	 * b) the task is also reapable by the oom reaper.
>  	 */
> -	rcu_read_lock();
> -	for_each_process(p) {
> -		if (!process_shares_mm(p, mm))
> -			continue;
> -		if (same_thread_group(task, p))
> -			continue;
> -		ret = __task_will_free_mem(p);
> -		if (!ret)
> -			break;
> +	scoped_guard(rcu) {
> +		for_each_process(p) {
> +			if (!process_shares_mm(p, mm))
> +				continue;
> +			if (same_thread_group(task, p))
> +				continue;
> +			ret = __task_will_free_mem(p);
> +			if (!ret)
> +				break;
> +		}
>  	}
> -	rcu_read_unlock();
>  
>  	return ret;
>  }
> @@ -960,29 +960,29 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  	 * That thread will now get access to memory reserves since it has a
>  	 * pending fatal signal.
>  	 */
> -	rcu_read_lock();
> -	for_each_process(p) {
> -		if (!process_shares_mm(p, mm))
> -			continue;
> -		if (same_thread_group(p, victim))
> -			continue;
> -		if (is_global_init(p)) {
> -			can_oom_reap = false;
> -			mm_flags_set(MMF_OOM_SKIP, mm);
> -			pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
> -					task_pid_nr(victim), victim->comm,
> -					task_pid_nr(p), p->comm);
> -			continue;
> +	scoped_guard(rcu) {
> +		for_each_process(p) {
> +			if (!process_shares_mm(p, mm))
> +				continue;
> +			if (same_thread_group(p, victim))
> +				continue;
> +			if (is_global_init(p)) {
> +				can_oom_reap = false;
> +				mm_flags_set(MMF_OOM_SKIP, mm);
> +				pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
> +						task_pid_nr(victim), victim->comm,
> +						task_pid_nr(p), p->comm);
> +				continue;
> +			}
> +			/*
> +			 * No kthread_use_mm() user needs to read from the userspace so
> +			 * we are ok to reap it.
> +			 */
> +			if (unlikely(p->flags & PF_KTHREAD))
> +				continue;
> +			do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
>  		}
> -		/*
> -		 * No kthread_use_mm() user needs to read from the userspace so
> -		 * we are ok to reap it.
> -		 */
> -		if (unlikely(p->flags & PF_KTHREAD))
> -			continue;
> -		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
>  	}
> -	rcu_read_unlock();
>  
>  	if (can_oom_reap)
>  		queue_oom_reaper(victim);
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

