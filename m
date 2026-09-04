Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A0FC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4556B0088; Fri,  4 Sep 2026 07:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5136B008A; Fri,  4 Sep 2026 07:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6106B008C; Fri,  4 Sep 2026 07:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1CDA6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:04:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54B8080A5F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:04:14 +0000 (UTC)
X-FDA: 85175795628.27.725E803
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FAF94000D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:04:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MtPjOBV0;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788519852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hx1MJKR10ulwIc9ONtxMhWx5TvezeBCB8mZ2l4Tg1bk=;
	b=QOPo/ykO/TAABthgyIr5zafXcS5t95noZcObh64u1IE7OFUZLWof1bmW8bpnvbFP/HqGNl
	zdHm66skBJMilBeKRxwg2emveKqATI4pAPawBSCxcWzg6DkfDPXhDUrAqgbfGMlM422qkq
	I2vreVXpxqNlL8VkrvuzmjBnyXzw/Q0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MtPjOBV0;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788519852;
	b=lNGrMVFjESDToAXQSMrFX37579EQMx67P5ORQsdlaFzJj+oDM/Bl9uTh4HFTqpBXiarDcx
	G+NPIJ9N7RbGzQPFkeTEuxfk+aK09OpTOqoVznq0a5LdtB4UZWFDyAR6hU/6kZ1k24klLp
	IghHyDLIYyx7iY/4Zl1T864BYP4/egI=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so9083795e9.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 04:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788519851; x=1789124651; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hx1MJKR10ulwIc9ONtxMhWx5TvezeBCB8mZ2l4Tg1bk=;
        b=MtPjOBV0OzjS4bCwTTHUYuLFTAq9nj96ZnDlgsnN/XI1ZBttVktwFwYGXB8Ixb06j6
         cQpwOXlqIAhjIGci5dRwgDKbU8sIvpP/JLIBh3+QzIgYHYyotI9yfdS5Yw4zT8L82N6J
         aJf2Q+biPYlL/FcnkqhaDbYHW7NDS5ZqkMxRJA02Q1YAMHZAGqRt0eoRh+WRK4ssi7SH
         FCZSjlZh2PcKIatK2QlnqnLXaUrdKW6tndMAfDmo0L9nY5QXxk8CT/qeyPq06L1iCa5K
         P7xfy/ZHNZNhmFyT5phSc6cHXCs5sYdHmZapgBPmpyTy8mUuUqq4Gldxkuja6ttqZqSs
         HvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519851; x=1789124651;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hx1MJKR10ulwIc9ONtxMhWx5TvezeBCB8mZ2l4Tg1bk=;
        b=lsipA5iuWxMY7tsUc0C29P6HJjKgsivnstkv7iR1wQN8H6l6wJraNG6wwvjZkhaWII
         ILDo0y4gE918It00KXoIh1cIauEaSb4iM0TZLR0NI3hDgHtTgOAcbqJwRD6oD9QiJCgi
         C4dNhOCvexDTt1iXnOh5vi+hfV5sT8e/YXmpqjHvE0ck7r+4sX1oPy3S0kyj+lYDNtEx
         9UwI/vNy/c6UDXJj4EwwAniFs7tVws3j1S1jB90vyNOFR6AV9C+HOL1NZDVhvDDyU4W5
         qalQT/VgrFJ7UMD51xy4HKWBFvMeBH6C7ks903Zpz6zono3xL2VRQ7qImMqL2ysIDD1G
         C5Jw==
X-Forwarded-Encrypted: i=1; AKwUvBzTYnjZRPMX8j9FruTsygoFlyhOBYzAkYwlEkss9MUYB71ReeM0ai2DSXYE0Qoxj6KszLpoMPQ6eQ==@kvack.org
X-Gm-Message-State: AFuF++mmavzwrlGXENF5fh+1oQ+JsFiw/+FNnel5N9/D0Od+4P8wP7aw
	lzcG7/vh82w2+xjsZHGfAgtrsGGzJPO0cvTUnZau1AXyWkiRDEQt8Kug+bOHckq36+g=
X-Gm-Gg: AYBFou0xSeolDFTUJu3z/JQxaAOG7atNLkS+T9qc1daT71Unn0yj7xyXmcOXZ6lPssi
	Vv4bCRE0PREbvE/6WsCD5M7BfoFTefGJu5G7lqNAx0dcUgp0+zCzoTSrWNZHCAsRT4kcxxwcedG
	DZeFe5+gz6+FF10oOQqw2d7Z+ElwE5ZrNBx/+QzfqO/fwLzRHG/olF4XSKU1CgzX0/4w1xbAPIU
	5BBwV7tRGVpDdHDE9luFLJcblAR1ryW3TNFUDzFFymmboXecY3773aU4Gr8ZODQVzIVv2EQd9Q2
	/zS6hjo7zMrJshLueiYaIdaOGGGNi2YEi0MTbdc2iFRX/Nn/qK06xrAT3dRCk3oE3UHh3q2mkKv
	6xLIjyqvr/GVKKRY2PjY/hXebylF/etXU7R8EUkBWh0N/3LdUmR4/zDhLcJaT2961sC8eyP94AG
	KheUbqhgJk6N7QPqjSr3/KvYP0syn6nexSVXQrl4T5ZpJoCHJ1Oy6iMlQrJrt0yvyQ8agOuI4ZY
	g==
X-Received: by 2002:a05:600d:6445:10b0:49c:fc6c:be09 with SMTP id 5b1f17b1804b1-49cfc6cc00emr18769275e9.32.1788519850918;
        Fri, 04 Sep 2026 04:04:10 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee60d8a6sm145447675e9.10.2026.09.04.04.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:04:10 -0700 (PDT)
Date: Fri, 4 Sep 2026 13:04:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] mm/oom_kill: convert process/thread iterators to
 for_each_*_rcu
Message-ID: <apqlqLeCyS94csaH@tiehlicka>
References: <20260904083001.553587-1-ye.liu@linux.dev>
 <20260904083001.553587-3-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904083001.553587-3-ye.liu@linux.dev>
X-Stat-Signature: i66wij66xzg6ze89int3z15hogokf78x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5FAF94000D
X-Rspam-User: 
X-HE-Tag: 1788519852-742016
X-HE-Meta: U2FsdGVkX186ZLCYiaPtTAMrjjDCkSayO7TBky/fL7+kd2eI73B3r9v4GARuLeDvI2wyJRhaZXoHNRaJxIZ1EesN/vzrlsPlj9Q39XzGuEOFjJPVScmHShscCx+FCLNDYoQJhgvznH6jrg51Sl9/1lOLgt9Cao52LIiUt4iae4kmheP5/KdRwZ50f6qWMuWK5sR9OpHiMNCYzn5vnhvgh2N3HvcOdxb6joEgzbqQ+Sm+M133ZjOrqoogG9clJxZ+PS3lQi3j1hfE1vaprt/7gJMcDLXKO17sSF+iq7zCPwOhiS9veDSvw+h81pf1Otjl2H0fLC91Xt12557HfChGVlbwtBGCpA1k++0brCOxZjF/CYms85XuQacA7G+f2mFYgRgxHCJWcnSb2HvexA2uj5SDqxxxQS01l4dhJ6iuiqHsujxnGxfpvz7+uNSFwrKjdHU4U3kxcpvWUK7xWouozlwPuTUKZieMrjqatbtMmMLFtzj+z1j5A9M1trudqvTku/BlUgs+xjpjXdtQpw73YEky7ahP6ueKv9AkFCriInJiCAy0mgWjhls69P3rH/0gDcVqwBjpNT21/kNw0s8XycgOiPq0acL5wBm5Db7Z5dM6a3MMlN2GyuPTHQ0j7PF1XH7UoYjoxBP0Ts3r5OVklpu2do9jEXc1nLrJwPFWqaSnHkm3+pJZzSf5eMJ7lu8QWcKpkrq0m9f0eTSqQYnxQvDNJXV6gQndH7CpLU3XUyIyKfwgMB1vUCFtlFpqA0vovsLhn9NMB44HlDLBxrRrgeJcc9KnjDn4fEwouRfHhggv2ASXmuHjIRmK8TnQy6G6GsmCqkJ/TKEf9yhmKcrib/9Xhd872Vg3LBY27fvGNZz7xFi1SWO5BjuXj+vq1RGzKkeXALsuaXx/y76CtwooPtg1Abj++pxEFJMajOboqaiHZBwCyYR0iMQvA+8Pkml+eeiWcJlUZJPVtfpPbCR
 jxgsO8ed
 xCw/7Kdbi8Ssa6g0UFVx2DljVIL5i+UXx4KccHxIWgZGi/YMObYo0cTIEA8JVnG9DQSU7GcYHF7hjgVDQUU4+sDsSv1gl7XH4FFiXup2bHEnJTYB36k+8d/WXayrLW6MhZQkHUQmmGP9X+Ri3RBZWSA+mbyUvgw/wSkwo75ArhHZasPWKk/GfKYF2g7nu0/ydvkbllYGMb7gG+sTtC2xtOc688nK9h9rUATFbkzG1qq3ml/M4FVOHnoEz+akIcRk+Ud7yCKFSYPLo6c2+O4fgD1b5P7vN85k1hrZr6RhFGG8jAQhC7Mb23xnf0SE9LhnXxGNTRCYmTEwmqj9MimkA/u9StGW7LiY+hT06B5Rz/T8x+x29TVmnvWDs3hhNkFpBpR0qTXmcIYb/ggojzFgBAZxW8dtupJOE0c678bh4f+gsE9nZLKiMvt0kkebIrmJLQ8peyrVp4Ej5rAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 04-09-26 16:29:54, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs wrapping
> for_each_process()/for_each_thread() loops with for_each_process_rcu()
> and for_each_thread_rcu(), so that the RCU read-side critical section
> is scoped to the loop body.
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/oom_kill.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5f372f6e26fa..8dd025965810 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -94,8 +94,7 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>  	bool ret = false;
>  	const nodemask_t *mask = oc->nodemask;
>  
> -	rcu_read_lock();
> -	for_each_thread(start, tsk) {
> +	for_each_thread_rcu(start, tsk) {
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
> +		for_each_process_rcu(p)
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
> +		for_each_process_rcu(p) {
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
> +	for_each_process_rcu(p) {
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
> +	for_each_process_rcu(p) {
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

-- 
Michal Hocko
SUSE Labs

