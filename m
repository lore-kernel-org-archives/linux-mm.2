Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 073BACA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654C68E0006; Mon,  8 Sep 2025 03:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BFA8E0001; Mon,  8 Sep 2025 03:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541BF8E0006; Mon,  8 Sep 2025 03:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CCBA8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:46:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D80DD13BFA7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:46:26 +0000 (UTC)
X-FDA: 83865300372.02.3FEF02C
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id CBDB4A0004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:46:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EGuMIQZN;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYj/ayUPJ/GcG/yhk/W4TtpLFkkd4AJkMaGQjPHzq6U=;
	b=xog16R4nDh1nHqoe8nKcETxysqPjxSEmBW2G1rHiqKSXo7t7OQzbQrX0AwFE96Fm4Eb8tj
	b+IpIPER4EMPk4KqBrORxqKrx36zKUvJr8VP9ChT1QJ0WmznJRn6osG+g8A8lu068qT+YH
	23uscaR4Xb65C9qW2gYbzytUCwVODEY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EGuMIQZN;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317585; a=rsa-sha256;
	cv=none;
	b=DAFr95ApFcnHVJ/TTWRh/Vm9vliCAZHJsskYP5IPhoX4cg9bVoYHucuB4d82dWeoelRACU
	ZcIekZIdN3t6eJoXbrzvo8PAlHqhcpUayDaBxV8dH3WdTbtw8+MBXg0gPpnC85jtTtrDIu
	/W99wnw1lSrvS0i+7OpRZah6F98XHc8=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3dcce361897so2602045f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 00:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757317583; x=1757922383; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yYj/ayUPJ/GcG/yhk/W4TtpLFkkd4AJkMaGQjPHzq6U=;
        b=EGuMIQZNF7ZkBgTrkE6mDoDDkodhzZkv6gJO2GvRPw5078PgnZf8IkMDk/mHwYz6vr
         UcKNmJDFGUb7CE2+IZucvYFjSpO3ihRxu97WQ/T3im4a5JhX0FL8m1xqQy1FK0iVNaEm
         4F/5xIfOM5N2GXIIORVCdPqbTbY7zZZGDt21YvXPw0Yb44ziocndt/Bt7WX/psK/FuEi
         JII5uCFOdM/oz7ca0GNw+1MPsHH2c6IDOAjs3a1/DhVaKaAuYiQXa1Fye7hE+Pp3f8hu
         OA8kQhoUaXqD6scH7HFzORVdO5rWg091AKcIgYVGWKgiuF+gEmG9s+M69mYHvvBpNLSg
         njRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757317583; x=1757922383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYj/ayUPJ/GcG/yhk/W4TtpLFkkd4AJkMaGQjPHzq6U=;
        b=UW6+UoFhWMEQT3DZ2DFDBySPFnPWqd/O/VMRHTy2BOx4r3v7K3NIbN6RywbYKBfGHe
         dj0bARV/mpIQ7JaU9PGiY7RpsG/EeoJvJhKa/o1dZLxoILwPmp5D2jvElT9dOdKnIWne
         pTbLz1GZ/fTTptIjQ3uCtDDycdKF4mqL78yU3fvl0IoXelt0fwlqNSS3yw3HWt2k/rtx
         cdIsdY0Wiend8Dfs6x1XIIfE3Vi8NVRWgNfMHw6QVkMEeDOxqaduSt6pLbqfAOkFc8dv
         i/oZE/gzKX5j9YaTmPoTBjQ3cYBdAyzD+QYs8dFYVfigX+x0ausnQ+CN6NS0fldTsLCA
         oIWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWz28fOH1+EdFe0ftyumwSWPP52nHIJSgDJhorqc+qBneLXcCS+E/ZZAjxLR44IHGkquOj/08BMxA==@kvack.org
X-Gm-Message-State: AOJu0Yz9atvZ2RMSCF4eSXXPf98c7Q4OFIFjE/dnHscvU0YeDlrbPRF1
	V1lER5lOSCM1vlB7uaJ4U4buH66wos4ZPsXlN8E8VZsy/HX0VHH+1DEFKJ64XJCrS+k=
X-Gm-Gg: ASbGncvpXRh9BCcdIYcejryFQ2DiC02Y4/6Nt23AVifC8uEIhAHT86gwfO15kF5bFb0
	r0V4Dh/77FMFODitsUA+IIriSYU6XNcm+y3lGElwT1+mbswJ8L2tV5b/wLKnaVGEJSxJeEicWFp
	1eLmgp3HMXK1MQeWBB6TACDWWxXwgSgGV0QjJ+q9xz8c/GAyPCSFoqdjPzxXxH8vjGfzCTYdM6Y
	KIjzWAUMqPFiy3qFh2pZvYfFrvnTBVGFojnWbr06Sb2R3ciaqyNH+HdBU1dNeenkGCsgLWw6a+0
	49kspwtOjAYJQv9z8hkIZrfp9RTlI0t1e62+2D+AjOFESpquv/nfNR4nuiw3uGk3/NE2W0qwvAZ
	qccYDpgpmYMV4gdyebOShAj9q6XP3DQ==
X-Google-Smtp-Source: AGHT+IE8KtVLln0DMxGFFq0XGHHmupgsUtSsFVOh1UiW+u6Q1gADEVRO7v/b3wFalXLzd3lMZtKUgA==
X-Received: by 2002:a5d:5d13:0:b0:3e7:481d:7a6b with SMTP id ffacd0b85a97d-3e7481d7f17mr2245993f8f.10.1757317583293;
        Mon, 08 Sep 2025 00:46:23 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf276d5816sm40271474f8f.25.2025.09.08.00.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 00:46:22 -0700 (PDT)
Date: Mon, 8 Sep 2025 09:46:22 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aL6JzhRjQWFQB0DI@tiehlicka>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
 <aLmhbjtF0Sp75XXE@tiehlicka>
 <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
 <aLqadzgmyGGjSck6@tiehlicka>
 <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
 <aLqo9NKQ-xDfJ-14@tiehlicka>
 <69180098-9fcf-44c1-ac6b-dc049b56459e@huawei.com>
 <aLqwcXHzsaTxN3dM@tiehlicka>
 <8616715a-fa08-47d1-bee2-2608a5c4d9f3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8616715a-fa08-47d1-bee2-2608a5c4d9f3@huawei.com>
X-Rspamd-Queue-Id: CBDB4A0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rdoqq8z79wynbrk94i79azauwx64pm55
X-HE-Tag: 1757317584-29831
X-HE-Meta: U2FsdGVkX18JBcElpA5XH4AywLqViBJhb7AZkWvqE1dZ3XyfAUNDmwn/ntidY7U/a/lKMkrM6J4VMhkMQWmavrUeBDQhrXeqao9ksJl+68GNV09+kComfpPoo0gPyU/JrWchUqKMr7qyaxQf2ep72TfqOP/DNkjUmrRskLJP9yQbOiBUu1FTD4NLwp+I/d9enTKkjRSY80oXwNpVzcfOP9zm9wFoGJlCbdyXFtC0obH4Ny1g5rRfOXQNyVIq45EJUZvlTul48eghpoa3JrAhOyTYAoN6e3S3VlBsiDpn3I/jU4ofFa4LV3HAwOo+wFTRUIx/i6PTZbWHH57FbShmKzSnQTFVfT3w8s1Qgin3abJ8K1tFiYV/Gt/iSvDmUK9QO+pkpoZRg142J6PicuMrE48/rm31c/H2fJ6rBWGCKhlzfeaKA7J4BH8Ys4exCOkUozck0hW0gcb3Rev9XJoA2/hQYavVeV3XNjBTUkxDArfByVAy++40aJkChd8JXKcgRBL+7rUPzVbBQi7SCaheCfqKhXj/cD6/lAiLQVDl9C8lPTA/th8Z/7rmdhf8z7v+Y4e185PCQ5pyjVh9H3pf0TqV6cSyo8vAENxygOEpyc0aHQZi4xSIQz2c2Eig7FXr+JMHcqBCtO3PT0tiyItYtmu23hWdGCdBKuinlb/eeXAUSzZdJdwHntlUIqkEIXAZGnwlX1qbjkrnaU+CYMpQGSyYyujs5Ln8VoAUiqTt0KtL4XZAHrlq3c5N3t2H9HodRSUQrSuKyUIN/iDV97bKu7shIDqc1w/mW5r8+lh1wJXvqcfenEGH9Nsp0n3/AewKWx/60IRkHtNrb0SKem4U2jB+jWwBB9flBqNvWIg7IbQ61Crj2s3mpoJLSVT+C0YYVvjmWoBenkOOQCupUc/VabXehrBRF14hxe+S+XS5K7Xavckv8ZqzOzifVgCPg6u8tOzXfxemVqmMQ06puvu
 usNk7bwc
 MJhfWkdqhyNLNwlblTP+iKHL6IG4BgjoxNsyrDnwQvFjeBOm07DsawrtxyKlm5t5xD/lx0AFijcqcetaClXacfUjkkG/AT7Fh8qGP0N2CL9bCOGqgUTOUQiHIRbUP6Nulb/FTNSPC6aRcMOhZN8GPuWZHs/Z0BBcrqtYqj8na47goqsu9npGU8iKt3bGJdjEK2kOEg9O7BrDHljhcc38TRBmlZr34pyjImefAKhEaZPYj8oKglLynDlwq3MO0RcXcMLyxCPQuZwa+wOeWWlxGzzOaJGj13jX0sDwMI7oS2OLlyTqZ6TsYcqRW22OqqwSmc4LbmQ+VBOW0d7xsrV1KvQPigZSKaALpfmD8leb0Q2c+nlV0++QdzguRGQUdsQmRyZ3wsqF39jqdxQSrW52WPR2mWONkXb8RSH7tVbgxw0oiZrNzfE1j2b9KpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 06-09-25 09:56:16, Jinjiang Tu wrote:
> In our use case, movable nodes are in all cpusets, so that movable nodes can be
> used by all tasks. Even though we move tasks into cpusets that only allow to allocate
> from movable nodes, oom_cpuset_eligible()->cpuset_mems_allowed_intersects() returns true for
> all tasks.

Right but this is because you allowed _all_ tasks to allocate from those
movable nodes so why would that be an unexpected behavior?

> Maybe when oc->nodemask == movable nodes, only select tasks whose mempolicy intersects with oc->nodemask.
> Like the following:
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index eb83cff7db8c..e56b6de836a6 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2328,6 +2328,9 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
>         if (!mask)
>                 return ret;
> +       if (!nodes_intersects(*oc->nodemask, node_states[N_CPU]))
> +               ret = false;
> +

Nope, this doesn't really make much sense TBH. I believe you should stop
special casing cpuless nodes and look into the actual configuration and
check how to make cpuset based OOM tasks selection. Your underlying
problem is not about no CPUs assigned to a numa node but an allocation
constrain based on movability of allocations so you need to find a
solution that is dealing with that constrain.

>         task_lock(tsk);
>         mempolicy = tsk->mempolicy;
>         if (mempolicy && mempolicy->mode == MPOL_BIND)

-- 
Michal Hocko
SUSE Labs

