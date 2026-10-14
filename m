Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F034ECC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832996B0088; Wed, 14 Oct 2026 07:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2D76B008A; Wed, 14 Oct 2026 07:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC576B008C; Wed, 14 Oct 2026 07:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 050A76B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:21:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 421BDC04E4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:21:08 +0000 (UTC)
X-FDA: 85320990216.06.B93B675
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44739120003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:21:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SCfs13W1;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791976866;
	b=GvujX6rWbh86vYAdGnonLMfd7OhI9kjNlweJcjNoH/WHrDhYS2r5CDCm1yy0gH870WB1OH
	SS+sU9yYN4+yb0ZXo9U/0uFw76tul4hL9Zcq75UWtjHLer74q45W5OYFJgIV0ZkSONzWmO
	3tZ3nFuUNacvpj/hrLqCQgvZgXcC+IY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SCfs13W1;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791976866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDrnC41SrQnoIWB3x7VgCSDF/VPgZxWskPROOodTSN8=;
	b=4VandFCDxmhskaSrBiefSN9UdgJWp6BNlKxEKpF2KlljuT8MJZDRys/AaxcUMhLdgBFmyg
	LGBZlR4Snq1rc+GEuytpnLXVF9LrEezJA/2mu1a44K/oMNAgUNRL04tmzdSkmf0NMuSy1B
	zBHaRhuNQeP/0JeUp+N1Xui7bWy1jWk=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a17baef589so7593605e9.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791976865; x=1792581665; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KDrnC41SrQnoIWB3x7VgCSDF/VPgZxWskPROOodTSN8=;
        b=SCfs13W1AUSRGDjLVb43TAMkJjy2LuIdayufr0o1J4HEDMc3WEbJesMNK7MBDIaXZj
         FDQMnwQ1iy+EjHhQq78OIR5dX02bDxOma4x0qfQ8NerdlTiKDkyN/SxMLChi3epFiWSr
         KS/yWSAzLOq+6RyzrBUhwpcELw9wHJk9eU/YDqYWdEGdw5kZaUGzTgYh9kAoXsH/0vKn
         k19yBqswzufKZ7heRqA+ftctf/lc8yzcYyCAnGe/KD5oXWrX4SLkqlrre3kovKdO0tz2
         ddKDnPXXmY4tyGHi20K6fl7sowgv421GVcHzaIDDZHgCkV0/dKVWwjHuTN7iMjJOjriq
         k8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791976865; x=1792581665;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KDrnC41SrQnoIWB3x7VgCSDF/VPgZxWskPROOodTSN8=;
        b=XCabmarUQ9FagHY/ukFIRLP2MqNsA0ecQEef7UIbCJPdLzLZ1mgihchkDQg63Yuv3A
         e45UFZ0UJtxhVg7qIafqmGxwjumHoOLc0ldZGZgaipR2Su54wrCvqWAsSzRyJjWwz9fz
         kTAbwVUeqhRdBv2G4lpp+4g76JBk1o17pVit2KC+PHXW4eaSOpNcMzOZpaFem2cZyL5M
         GwRD7ZN47lCneDZql89nVP97un0E3QV6fLg9NhkKPsud3NdM+xr/yGG7XKlBFCbCC4s4
         ixhB6fSZUJO5T1/AaJIHPJQhRAthkGMm6mcRcqrCp4prQvYzd3arwudIK7KjGY2vKWpp
         f/tA==
X-Forwarded-Encrypted: i=1; AKwUvBxOmS9JW+mCFkGLasrn4/UnCDdffwZK1Mz2bJVJOWUeDu+7q1jgG/AzcbXopm9rSkUnIf/KZ+mfsQ==@kvack.org
X-Gm-Message-State: AFq9FYKxXwIvx+Y0TtQz9LwVyjyYAieFTmBZj5Fd3r/ixuHLrBNRbxj+
	3481vughBSWKV0Qm1uAEajAT8LCnMxmPEMrf7bzPmTThi1AJvinWoFQDarlkp+8pzsM=
X-Gm-Gg: AYBFou3cCviryq205OcYE+QP8JTN7TeCnM7pXQbFHZmKJRXauwJoUoo6AnEJuOu84Ij
	4NflENc/+ZXIH1oih9/biU6/SGGVir5lmvE+oqemyBg9jNSlU0UN2LQsl3OZ54+a0ENalLrDh4/
	nIoV7Dl8AyV5yRbKQLvZG66FiBM8W9NF39N3ZviAWLe6x8jpWGC+b+jABFw5YdjmWOgxMHh7xoV
	EWPe9t96lsPvDRG0tL55Zwn6mxyjz1FCVWPZ/q3gH5/FC4q17aAtEH2erGASr9I36PMJXNiI3cA
	0KnnhzYzrNLaoxalUIf8ZHk7EpYPZe+IEPwed1o8iHNmN+bKswfHnir88ZsnFiZUHNBtkCPwkng
	Gak2fsxTyTg6gwlGIuZumS8TjrFKBaYnXrCgx6jNjoZnvLd91sm6kD13uEdsdKzrWACgq3QYhoH
	9aKh7XXP4sVxfSwvWWNW1n8sU85Y+WyXmdZB1mCExTHWHqnIFcYHsmIV9PxloYdFrxqcxwX5EmR
	e0YFo6ff/AI
X-Received: by 2002:a05:600c:3f0c:b0:4a1:6517:ccf1 with SMTP id 5b1f17b1804b1-4a18e47a844mr324249785e9.9.1791976864761;
        Wed, 14 Oct 2026 04:21:04 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ab6361sm9561760f8f.32.2026.10.14.04.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:21:03 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:21:01 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 2/5] memcg: use high_work for kernel threads
Message-ID: <as9lnTYY0NCAp-c5@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-3-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-3-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44739120003
X-Rspam-User: 
X-Stat-Signature: azizqbh6rh3o5z9fyxnhistq3azffgua
X-HE-Tag: 1791976866-37852
X-HE-Meta: U2FsdGVkX19umH5SJ2PvBY7Ys/kROCI9ZU/evTkxQOK4qHmFDUsX4oXOtTcpJhE0fQhddZEFjObHVWEYVoxwdZw6udzE7OvP3O5Q+e638hZ4rK/FOn7TE5wWhlDCntr+enmenvpPb3go+8s5Kxw0qhvmX0bX5qU2Rl4ElyOKtwMqJR5IFWDmoy9bAtetU3VRtavC4dvFE07ZqIHvoEBSJtdSANkUXF2ecgg1xFpOCBqWQ6jNCOvylft8pf6JD9fLx+EVZ0bx0kxFqq8yJNxZAQ2YOOyDu2ND6wnppvMYxivQIkR+cPATf0BwZZwgVUOktd7KF5FuZX9BANjicRvOuzWVKuucHKJynCFtQLYZ0rR1ZSJ6yX95Td3s+Kte44AhkfoCILxtkPikP1lh17RwYCBGKsQYFKYrnGanfCtKrkdUA/2JAV9++HkgWWHRINeZLa95AkpiZfUiR9i01y6j9pvKFRSoFnTK0K95/QFBj7cbYJwRUGoUE+ul8jQb84kAJeuuLePLVhoeJk+8B8SOYCPeYOCyyf43BHCCSKRpnTKpTkVZTbwYeQ/4A3ZVOJUg2nXI/U1NGDsvNAOfSSDWfEXHsc+pCy/jB5yhU3h5pJA6+J3Oy7uX+7phamS1T3qnd/0y/fEGHeWMPcG/qPK6yGv8xjmWupVFaLeg0lAsyk8qoCzyFplr50PH8eFBstb/YYUjtUJY02zsNeuOP5ahydzWsZTX47wCFSlpzPf7HbmsqLrdTBxgC8EyD0AdfOrMKh4CgjwNMrcuJHVCZWMjOe46vrZIxn+suNCZ/dVe8t9a7Jo3jTMZYO2hPB8g03mZtrkO/qEphtUxcKqNJrae5PdMiOYHZjxrA6JTcdNa/PssD+MRcl9yhycKzke99rXveY/vpBH//QpVJXFg+u0wGutUN+6ioN0M84HyIs5uoARPf0r1IntxnBpaLH/qSbMfve/qPqzLuuobd7dMB1e
 l2uGouE/
 uEohxi1arEiJIkGihrp9CwmheqtOQmIn6IbIiAC5c/fESVkhpf9IZ41ksXj/4d/rF3XcJN/7T/gm65ovwfXmHIU77UbNnj2Dml33DOTmF2/+9uFblnSjY33JA4UpFyb9uiNaAkUW/ZYPdXhhslkuzUZH0aMKZxfhFTn6Mc1MKbU0nErxBFzFEuZR0EBGz2wlypZM45QgnoBdLULuzrWMLFI5fyuKr2JYf1J0e2iRLpzdVPlXOU3EMuTyNY7juqDxtJgNm3JNSMIROe/7uItSiPOQfgdiKGe/Fl0j/wKc++VXKLfWMr0eqmk+TYp0EYBAM+CowkuOsinaKQ9zEANgqeJxSLQ+vpwnnvYvjlM7/BORIEux/ypXwWxjumx1o1kNoz7mLBr9Fo/iQk4mnfWSC1xDN0WBdZBoUbtPRIwDPEgaX1iUXGwvz2brjYfucYBLurJlW6q/c8bNaJtPp2GrmNEvvEK6Lgjbnvl07wQpjHkQUGZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 10-10-26 14:09:54, Shakeel Butt wrote:
> Kernel threads never return to userspace, so deferred memory.high
> reclaim does not run. Reclaim and throttling during a charge can also
> delay work they do for other tasks.
> 
> Treat kernel threads like interrupts. Queue high_work for the first
> cgroup over memory.high and skip reclaim and throttling in the charging
> thread.
> 
> User workers created by create_io_thread() and vhost_task_create() keep
> their current behavior. Vhost kernel threads use the new path, even when
> they borrow the owner's mm.
> 
> The worker requests a fixed batch of pages each time. A fast allocator
> can keep usage well above memory.high. Kernel threads also skip
> memory.swap.high throttling and its high-event reporting. The memory.max
> and memory.swap.max checks stay the same.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

yes this makes sense as a general improvemnt.

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
> ---
>  mm/memcontrol.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 20c5dfe1a894..8116fce6ab96 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2705,6 +2705,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  			       gfp_t gfp_mask)
>  {
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> +	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
>  
>  	/*
>  	 * If the hierarchy is above the normal consumption range, schedule
> @@ -2723,8 +2724,12 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  		swap_high = page_counter_read(&memcg->swap) >
>  			READ_ONCE(memcg->swap.high);
>  
> -		/* Don't bother a random interrupted task */
> -		if (!in_task()) {
> +		/*
> +		 * Don't make an unrelated interrupted task handle this charge.
> +		 * Kernel threads may be working for other tasks, so let a worker
> +		 * reclaim instead.
> +		 */
> +		if (use_worker) {
>  			if (mem_high) {
>  				if (allow_spinning)
>  					schedule_work(&memcg->high_work);
> @@ -2751,6 +2756,10 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  		}
>  	} while ((memcg = parent_mem_cgroup(memcg)));
>  
> +	/* Interrupts and kernel threads stop here. */
> +	if (use_worker)
> +		return;
> +
>  	/*
>  	 * Reclaim is set up above to be called from the userland
>  	 * return path. But also attempt synchronous reclaim to avoid
> -- 
> 2.53.0-Meta
> 

-- 
Michal Hocko
SUSE Labs

