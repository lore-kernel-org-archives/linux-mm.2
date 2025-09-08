Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8B34CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3768E0007; Mon,  8 Sep 2025 05:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B008E0001; Mon,  8 Sep 2025 05:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A6B8E0007; Mon,  8 Sep 2025 05:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9CF08E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:11:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 873145C652
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:11:23 +0000 (UTC)
X-FDA: 83865514446.20.54C70FE
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8C3DA40013
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:11:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HC8DSnIE;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757322681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMhX2ZkOt+/txfXxXZcLwT5FeYdAG70zs0mvAM/U2qU=;
	b=hafUC3vOchcJfywt4kjWIsKeIsxLfdT8XaQLLQRcZ1D/WGM6z4aiXpnAmCmLDd47dbGJ2w
	8UDrYIln6tl6BSv/7yzmWjjovjAlFQuzcnydBO1gKC1x60BlITGv82JKQ/tsv0XiRyEe2W
	G2Njstfhgb4sATlazCCgqGay1fNi7kU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HC8DSnIE;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757322681; a=rsa-sha256;
	cv=none;
	b=SkaxFnd7E+NbBnnUwviogRC4Dc+qIXnN8Ul5s8yqQYZX+0VBsQX+ujd/a0dyHYTOhDqUxi
	2jmS8mbBmT2rmOMsSYwSdxosU5Lmc/piwF1OX1g+iqCI0QiIvkuzYUoAgpv+8rk26EKfok
	5EWmOZbkdFGJ1pQKgjnEkXLSqPfes5Y=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45de6490e74so6489065e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 02:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757322680; x=1757927480; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tMhX2ZkOt+/txfXxXZcLwT5FeYdAG70zs0mvAM/U2qU=;
        b=HC8DSnIEdM+GJ7oYwvLKiAkwwxz+vfqppwQEKGgvOou4RHxE6kWpoe1uKYFlH7j29g
         Vq335CSOGe+WVZuncJ+aQ1ZZ3AvET+NA5X3U/Ud/lNh0YvjDIBENpnS+JmeDT+mnQBo+
         ybmGyM/5WknQ+qsTWKqqHtvVl3RAMJ0ewAr5kfkkO+Z22bai5al8XxufUY6ctNHGxfpA
         Qx5DvoEwUfmIdOFrql23FX/7TpdleA2O3w3WFzWYejvr3/PER7yUaDHIZrIS8DbjXHIM
         WZpsqZAW35QFv6awYLNyhY/ZeLY/Cbd1iaucVBh81RRq9CRJdAqyUnDbTzJPlLPTkpHr
         ncqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757322680; x=1757927480;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tMhX2ZkOt+/txfXxXZcLwT5FeYdAG70zs0mvAM/U2qU=;
        b=Dov4qUY1Sd+SoAXw7yoB5ZOkywJbbNGLvhN0VYkuRaJfRy76DYG4q5N98VxwY/5BLn
         e3yregptakGiDTCP5UDo8zHG/AVwYwK/Q4B0IN+EQCruPkhgK7LFmvM6DsbJGUdGYAmF
         h/5o3urE9iI1iT0aO8R9zS6WxRfTaGygHr+zaM/mk0mvlLzG/KOMDDDy3nRjZCjzlHC0
         hFccRqFBIRUtqyZHL0fg9/96BJbKBYS5i28aOOBOq1h7CUr24rt0SPXo0dfB6B3X5nEU
         r08+0Ogi28Z00tT4ollpO35EZgGU9hz4jCxt5y44TYg6PXU2Qt59pQvtByyjudOwyWTP
         poLw==
X-Forwarded-Encrypted: i=1; AJvYcCWTWaxB7YTYFmVMsXYrMXBUobf5ZSSi8MjMfdKu1rNlXTJbriw59QJ9p8TJuncxpFCP/F1ZVx8t2g==@kvack.org
X-Gm-Message-State: AOJu0YxIEz7v4MaPfMWEfjAlGOL+sOOmPWDdgOlQp/vRyxF8Xbfg7aWV
	5YxWdpLX2PVx57xgAo9NyCddyk4jm0N+Ylj5/lKjNpSsUBVCI+kLvA5UgguFI4xGg10=
X-Gm-Gg: ASbGnctuhngOFdiI9/ryXtZ6RexH9M6xGk2cQC2DMsPhHJ8eL3EHS/eWpLNjiyOwXGO
	ajiOdX8aYrG1XekYJbunhIIVnWbD0HTbB6VVOWTaxRjsuq9HiAHr26yAMt4J83/t7viX9fdVXQ5
	pPIWBAXeqcnxz2swGtEt4iK+82a8yFHkKVajfKeSNYVyjttYRfLmP5QEitWIFy4U2D8tzFVZSc9
	J0xacGtitwE6DlBgo0etvPtJ+UEqi9Gi9sWbdMZPegTUWW3CrZXNZ8hJIdkEhzp9biqMKQ3ZTBa
	eNvwwVwIfA0kyncGr9il0CRRrC4UtL7zsuwhveJFDV45VqPWO84+TPsM6g5GciF26EN+0DwWzHD
	9nBcnS4BQc04CClOC24NH/m+6NEdUSQ==
X-Google-Smtp-Source: AGHT+IEWH0b6ByNOX9iPKSCIOAJt1+uwupOpgSa2TZgloByIkgBt0wWfnZuaHn6zdNRroeBdEVmndA==
X-Received: by 2002:a05:600c:1d16:b0:45d:dd94:7c09 with SMTP id 5b1f17b1804b1-45ddde955c3mr62905555e9.1.1757322679989;
        Mon, 08 Sep 2025 02:11:19 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45de16b8b58sm79411555e9.4.2025.09.08.02.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 02:11:19 -0700 (PDT)
Date: Mon, 8 Sep 2025 11:11:18 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aL6dtpEQL1A_PcOh@tiehlicka>
References: <aLmhbjtF0Sp75XXE@tiehlicka>
 <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
 <aLqadzgmyGGjSck6@tiehlicka>
 <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
 <aLqo9NKQ-xDfJ-14@tiehlicka>
 <69180098-9fcf-44c1-ac6b-dc049b56459e@huawei.com>
 <aLqwcXHzsaTxN3dM@tiehlicka>
 <8616715a-fa08-47d1-bee2-2608a5c4d9f3@huawei.com>
 <aL6JzhRjQWFQB0DI@tiehlicka>
 <47c4e0c9-9719-4dae-94c8-3a1863b1b321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47c4e0c9-9719-4dae-94c8-3a1863b1b321@huawei.com>
X-Rspamd-Queue-Id: 8C3DA40013
X-Rspam-User: 
X-Stat-Signature: uftukb5eyyabsg7u7tmaa5b8faw7bu6d
X-Rspamd-Server: rspam09
X-HE-Tag: 1757322681-363170
X-HE-Meta: U2FsdGVkX19BoGN58gyHmD3cW9uIjg+OKI3c0Rf8iseh2GRvEBgg9sBfKIccppdXHpBVdkHWLt3zyzgO+7VhFyD30077cRoLw+AsvGm8Nm5w74P7oq0EEKxeWnLMPk0thJ8bMRzbLM7DTW4ubHqcMuzDYVvv6gn36R0NACZ+fd625ogZSZb9BqzCZWDvYSpLP0taTaGR/5yYOQFxFJkrDk/tA10VxniNkz3QYbhuQacprNn438vCddwlJ1E3sQB/1R7jxGado0BuKd067ho7jMirwhlabBnuSF/P0l2bITCfXo58gkVjW5cpdW8rasvQOaJmAyAeujngQgcJW8xpy1zGJScoz05TDxM4cVVcdKTgfvId7ZutQGlqLiVrUUKQ9PxfWzg/wOiyQIstD8QVcBkmgZ0uU0MvP3ExVDX4h7ZyHIzAoroM91IuW+F69YPPVS9kog7BWEDgYMVpi1CFyTRGPROWaxJnHzp24+Ryaz2cMrsyOTucvqq236mZMr/2kk/Y+xX6sg7rvp7QMiu/sN6h8ZuqntPjkkZpgXsD0dfWRWDyfKgIs2Q+SDUX6geKRQlIaKYizhhTYm8R4H2SDAzgUyKHjJoBS2Idvtxs3zqnw0QXZsrDdRk3igz7LSMsbDENXe03OLCTsXoAzeLLrx4SiZWic+fvxJlb6jddzDP8zozm7jLCBNn+u2huoMdK+XweB52/7Jzp1J6kXazFvgPi7FLDMZjGLLOjF/a65velBY2KN/eLpOIdik/u6jC15rkwxE/jELpWRF7zCkgf5PSrOVPbJCIw96RVOkyXUzumueRYfJlJyY+em+qAPlnecEQ23vi+ZTdknIJMW0ib/81vQ7E6aZd382FQb8EIEBLyp47iUKKV9iJVig7XZiXNw8VED6WnnC6fyjJX3TkIiOBiZnOd4ufISPXr5DCdgkdkVHdycn0r6Xo0CPAhygc85LwgahMssiyw/v7SG7O
 /+09uuRv
 RXgIuzTOribNfoE5G2yWdxkcD7xThaf/6mWuvC1ECA4pTZ7+xRTdcXSN4v4Utz9QX5MkiTDUHvL8qDRvkl1PV48Sp9lWIiKmujUBFhbPSxT3NOvfovS5nKLQhJXag3qcnrI7Adwq4lVTpyWAVM++8M+/B1D2nL1+oMb58WTphvqJi78fKjzH+5tlK1CQpvh7PRHb9suRcPg/+awgA2Hq9NBUXTnWrhsdZRVqvjrMfB4MxxAViWkHCb7EMc9a7k/yv8JatvdiY8U/EODsL16//f75WgRpG5chVNsDYMemvW+5u40ZQq0tsBuvtLORSsOMY7tbpUQxDZ+otZpmZGUEn7O+oBdJbhOPxHP2xdu057HBqUQOyJ2ncTzQkFj+FxZW6WIs5qtAawl7GliMZ/sQvUqF79vnIWHvON/o0hx0YKcWhAHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-09-25 16:16:38, Jinjiang Tu wrote:
> 
> 在 2025/9/8 15:46, Michal Hocko 写道:
> > On Sat 06-09-25 09:56:16, Jinjiang Tu wrote:
> > > In our use case, movable nodes are in all cpusets, so that movable nodes can be
> > > used by all tasks. Even though we move tasks into cpusets that only allow to allocate
> > > from movable nodes, oom_cpuset_eligible()->cpuset_mems_allowed_intersects() returns true for
> > > all tasks.
> > Right but this is because you allowed _all_ tasks to allocate from those
> > movable nodes so why would that be an unexpected behavior?
> > 
> > > Maybe when oc->nodemask == movable nodes, only select tasks whose mempolicy intersects with oc->nodemask.
> > > Like the following:
> > > 
> > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > index eb83cff7db8c..e56b6de836a6 100644
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -2328,6 +2328,9 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
> > >          if (!mask)
> > >                  return ret;
> > > +       if (!nodes_intersects(*oc->nodemask, node_states[N_CPU]))
> > > +               ret = false;
> > > +
> > Nope, this doesn't really make much sense TBH. I believe you should stop
> > special casing cpuless nodes and look into the actual configuration and
> > check how to make cpuset based OOM tasks selection. Your underlying
> > problem is not about no CPUs assigned to a numa node but an allocation
> > constrain based on movability of allocations so you need to find a
> > solution that is dealing with that constrain.
> 
> Many tasks are in the root cpuset, systemd for example. The root cpuset
> contains all nodes, we couldn't exclude cpu-less nodes.
> 
> If we reply on cpuset based OOM tasks selection, tasks in root cpuset may
> still be selected.

If you start by killing tasks from the cpuset of the currently
allocating task then this shouldn't really happen, right?
-- 
Michal Hocko
SUSE Labs

