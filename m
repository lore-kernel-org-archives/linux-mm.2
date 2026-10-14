Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692F0CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853826B0088; Wed, 14 Oct 2026 07:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803D36B008A; Wed, 14 Oct 2026 07:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F26A6B008C; Wed, 14 Oct 2026 07:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45C9E6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:39:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5A94120264
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:39:12 +0000 (UTC)
X-FDA: 85321035744.15.6A6C67D
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id CC74340009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:39:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AVi82iiV;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791977950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUzFoE445IVWsVK4aBCZAsC064TGifdEV4i8h8KnmvQ=;
	b=seYCavSalZXctEnpXQ3DCnu8zsyrgOxvdIN/T5bXqu26i7Ux2hLedChVMXYwUphERZJOZ9
	SsWqI2kO6bZQvlGLSXQceBDT0SuoA4/Vjh+IqyPt3E87lA5FkHj1tddKvmaeTK9Tpr+x67
	BasQQNpsXfY0fpi2Aojy46BsgfeLZm8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AVi82iiV;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791977950;
	b=6DgSB4X9IUAs/hqQh+UwCgPp39J+dXlM/1hBvzU8tsdj7Apk2vGpyZ6l2smYQt31X8u+Gg
	JVRJwj4EDkZ8yQook37xlib44Izj9ArarID1y8d5uqvL6d2m4wyIO4WjF9F7tCX7Y+gvBe
	ciMkP/mwbYbpHa3hhVDpjLoCFU+R2ms=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49e73611928so37502605e9.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791977949; x=1792582749; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QUzFoE445IVWsVK4aBCZAsC064TGifdEV4i8h8KnmvQ=;
        b=AVi82iiVFPUEpDLJ6kSCmfnN9ckCwsMcyITcMi1qlZMUZJq12nb9G+mAkdMBa4J3wu
         Sfgb0CtgBiLIMAusAoVn/3racef7xhw+JZPSLAHr5lnFh/JIM+HV8cbiun7W2OMtquQ5
         BYY/vAjncXmrAvmGIaYT/wfZBVsB2mINDL8pLvY7wRtDfeSaoMWJEJfMMV7ep5+UWy+W
         Q4BwCLFwgYbHUWeCj/J3wS84i2+6hneKBqjlZiX9EvteSJC/CFMUVtjKb301+g/Wxij3
         XUbU8L4sV9LHWubL3KRMMfjN0iPoa7xpDmTmLAbeTNC1eoK74t4kQVhCQI5spV0PdGJY
         Xm3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791977949; x=1792582749;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QUzFoE445IVWsVK4aBCZAsC064TGifdEV4i8h8KnmvQ=;
        b=tvPKurg87Cs2F++qI/dVUD0RkZmE5JZ65AdiJrHjbo50acRy9DK5C8yQUWKWfpCrMu
         /r7NBwRmLQ5vGwnAIrcfGUZGcQy2tgRIXjvNzGVpIpFM5kMIrcdlgrikTHi+lWORWv/G
         wSMHQt1OZ2Qv9a8+RGgFm//L57PkH490hjVlxVZS1Ew/WVa2KhV1+jGX01ttbEnP8sWH
         l1syGfvNkUz7kcFI52MjQo8/t2DE2Q5BvEl6cfMWytvfp8rBKGe5LiNs0y5v97VhYPlk
         KIX3YAUSEIwx7q6TjaCSoDM4XZxC5KIYfAkjGQE9Bqjo3yfiZ89w8kVu/sUGOUWEO6vt
         SPaA==
X-Forwarded-Encrypted: i=1; AKwUvBytr0CWiFLbhgEc7ZeRY/ErVlCN/7T8dYkZCFm5Zes+MUWznD75FyAhlq1E7cDpND6L1p5r1YOYjQ==@kvack.org
X-Gm-Message-State: AFq9FYLXMZq7Gn8x/chpnukV4zjveCgIC9eTQgSjO7okI/AMBWD+gutT
	NHXDAFP3Gaqryun/cyJRSLEMkIsFXxD5W9VInBVExp80SSrUYxzDbJmTFWUXuGTps9MSO3H4ske
	KZYFj/zs=
X-Gm-Gg: AYBFou0tcQBqqEZGwq7MqgSrarVCb6lQnva7t+zQChzdloyToX97CTj8r2+vqiFCt6t
	J3Vv0iBCWGcY1syzjhPeonGAmgAS0Qqdg+PkM6r0i7ZlDCa1Nt1fcCXK00Vr2qCfIxJ/WFg3Uj8
	nKRGipn4jKou0UBjCYmrSWpP1kWULJvr3qMm1OU5y5D7KJn1relGtzaDTjqRrn/NSXirIs1weUp
	r68rRy89oIMV3vG6gYu8CCTihngnFQBmheVO69nMUOX7swR9mTupvKYv2t3gjmYRkdINee7LXr4
	feFx7Uho5Z1244StnDtNQsOis2N6Q6QK9kSdmyhBVwNq2QDJi1tZnPqAPvterrf9/O675H7ut4R
	YC06ORd5clJ8AqoqcQ4JX7Z07nyJo7Cfbo10+J7QV3tbEd8BiBjVvV1t3oAYpH4x7k/ZqrOnukz
	9DlXnyLqq9DTbQi0GsjlnDrVp80fqm77QpWcYPdRRIEi9Vi5Bk+38zj4e+l0bHmKyvQvcFsxIei
	9zKqQWl8Lys
X-Received: by 2002:a05:600c:46ca:b0:4a1:7a1e:6910 with SMTP id 5b1f17b1804b1-4a18e48363amr313361525e9.4.1791977949379;
        Wed, 14 Oct 2026 04:39:09 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be97d1esm688508455e9.8.2026.10.14.04.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:39:07 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:39:06 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as9p2uFqCQprwdnI@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-5-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CC74340009
X-Stat-Signature: h848q4wq58hzg67hds46wchdfu5arr86
X-HE-Tag: 1791977950-868026
X-HE-Meta: U2FsdGVkX19k+sR+qpdasvJ1z06xrbwRjm1QRzRA2EJthfLRcLh0oh+pXxdyyHxsw0qGtkToyNZmU6OsGBQKWmceVvC2RWIZLOBmKF/kqgwFQV22xUjgbc4yPBC5DE4uKcsU/1yEXakzln6M9g7Zs099Nh7eCm9AjFKoHwa04tde7kOndHlmR4wHWt2IcwZgSK1H5fCO5rxMhg6TgT240NDINN0vsXb37mrye0/Nvy2SwJpyhqkU18lB0xSdy9e/g8J70q7Tp4v1MRlmAis3vvfJh3n6CzcZzyLs3f8WveH3+y+TjQNR4p1Ai+EdHYoraaUe26doB8CG47wHrLNScQ4hqD1tgD6kzPXdMtov0hIQwDPGArInU+FCNt4NzWNIK+iCUXfkS6rVhHJnOZX8E5J6UsHkBHLmlPifVdNo5FOF/lT+G6bFwmGF/+Tch95fC3VTGE1L7QJRv6jNwflmJCtQ+AZFWcJp7PBh8jUnPyehIQMEmxMGuFXps2bAkLzhPcn1mNavAqTWQ7J/BQnANtU5P44vfLcifGSqKLfve8xDHWp8fnKHTIeIu8hiszuDrU7seh+sRRefk1tAs10SJfjiG/+sdcO9nCUT7GkZQKg7JTCWdlZOwQ0V+kg75qmRT7HuglCV7PA1CCH9H8K5xWsgpep8A0VW5rK8WIYZwuz256DbXmheDrefSdzKR8I3xC/kEOn5dTmCXvVogaGUqvrjdes21XPu2U1xqzjCpZJD+TcPb3V5DOZn6tPGUqcuZuhF9Js0jztv3CPqnT6qxdzcCvR5ZaXfQekVE0qei8aPpYPKGpS9ahkrO2SoAtU4/E5pdIPWJF/PbSJqFluQ4FpFM/P0OYCEQZfA3VGTS/KM2eKI0KkWfiJgKmh7lDEGgwBpZQP0+m5xUM6NI6helRpe+IAl/SzvK6PEpvfPCx4ouiNI21YkFgnluvMLVzzXUqwF8f+01N9/ppMDfGo
 XjIj7Mlu
 NbvS6cDw5DATU3cAw5fwy48+pZIwOdO5we7E3zpzZOMSpopNWtG5qNOAGlt9C6UIcVq6uqeDTtmL0YDbeT7kR51t8xUSuichn8nvjfK0v0ZCK+isuXRqok2UylEXJjN9+cRjie78wYEEZ/HlCSIOusiZunutT3ffMwjmJ/UIBNOFbZktZdoZfLwWLPZ1gBYq7pP1MFMwkERH6GNthmqNA6Wy4bNnIitY3ns1CoWUYFYplwE2gYCZqAogqFhzUswbvZMRgcdz45fqSL2Uf/de2dOd2FyDaUaR2YuNpCl4I4hqVOQvPwDt+W4r0U+B0MPFs7ROFiwbF9Gk81Ksdy1NniC/FdjnGKebgGAVzmX0h4p6bARHqpb0Ruh4tZmI6bJyJfRi030BA7J8hDkQ3hQz6XrF2pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> Kernel threads and remote chargers use high_work when memory.high is
> exceeded. Their allocations during reclaim can also charge memory,
> for example when zswap stores a page.
> 
> Without a check, the high_work worker can queue itself from its own
> reclaim. The pending bit is cleared before high_work runs, so each run
> can queue another run.

What does that mean really? Does this delays the actual run?
 
> Skip memory.high enforcement for charges from task context with
> PF_MEMALLOC set when they would use high_work. This covers kernel
> threads and remote charges. The memory is still charged. Interrupt
> charges keep their current path.
> 
> In a VM with incompressible zswap data, the worker queued itself 163 times
> without this check.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

The patch itself looks OK. I am wondering whether we can unify the check
with the existing one which forces the allocation through in main
charging path.

> ---
>  mm/memcontrol.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3456960cbe68..d1e022e6572f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2708,6 +2708,14 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
>  		!current->mm || !mm_match_cgroup(current->mm, memcg);
>  
> +	/*
> +	 * Reclaim can charge memory, for example when zswap stores a page.
> +	 * Don't queue high_work from a reclaiming task, or the
> +	 * high_work worker could keep queuing itself.
> +	 */
> +	if (in_task() && use_worker && (current->flags & PF_MEMALLOC))
> +		return;
> +
>  	/*
>  	 * If the hierarchy is above the normal consumption range, schedule
>  	 * reclaim on returning to userland.  We can perform reclaim here
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

