Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 505FFEBFD0A
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8BB6B0089; Mon, 13 Apr 2026 03:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159BD6B008A; Mon, 13 Apr 2026 03:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049606B0092; Mon, 13 Apr 2026 03:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E68B66B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:23:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2676160C87
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:23:43 +0000 (UTC)
X-FDA: 84652692726.05.10AE2D7
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBC0120008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:23:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Qa8M+TRx;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776065022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nzuZ3kIIyE/QcfErtqwJVEa14xLXdZqRnEwseWxDOo=;
	b=EXhc2VoJMNa3m0Mg5V49LvGOQ7F/oGiNbRljec4gdlOLqI3/Fz592E0FZ/gZXZ3QL9EkqX
	OLxsjALxd7SCkxnoqskEIeAXW3tuUSUuiraxh54jpyHaP1gzadd34L/T8RO0/YUv4W2ac2
	ECS2z3c8E7ksfWs/QQOSlCGtB1VvQ0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776065022; a=rsa-sha256;
	cv=none;
	b=hgPu+xXkMmGlcS6WVVTLfK9eigxNziHanzDaJ7rBFxc5PQ/jZnwSjOXpGAVxikb5D7mXgx
	OAi7rp6Sv5e/ZmcpvO1P6Ecgd5J0SYfaQvjYfgBVljJ4clD86it4EKa4/qISJK+4D/Pd9J
	iU3V64NrwCrTBdqnkK4I/TZR7UsJSWc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Qa8M+TRx;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488ad135063so38319195e9.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776065020; x=1776669820; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2nzuZ3kIIyE/QcfErtqwJVEa14xLXdZqRnEwseWxDOo=;
        b=Qa8M+TRxO3KhENdbfQ4jVxWCmW8EnDk17C0dJcjUjf2gru3dS+5hxCC1BH7Co8kON7
         whefjQYgwWwLBAmBbQqd19UWQvbqbRoKYEGsVNa3p2vPMch+qFrLov8g3ZBPjXGV3vO/
         G2Erm9ikCioKbkhLtnl+TEgeDHCYtfBxzF9MmY2ZOthW2YSpJ/0sxC0fkOM8hboKCjvC
         UspvWQoTI8GOWq7Gr69h3Qmxdmj4a9JaDGQB0fa8pvxLzmn5u8AZKSie361s5s3nzcgk
         42ud6x/QieLBUWX/ojYsEBoYn7Ee47Vh5wvOHJFeLs6pu9PxZTnU3dTmzp+GZxbbRTJM
         68ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776065020; x=1776669820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2nzuZ3kIIyE/QcfErtqwJVEa14xLXdZqRnEwseWxDOo=;
        b=GURQQ0N9nGLBeDQ5okBy5NVbEdKK9uEi3vmO/yuYk5qlioInYHY3xmIglnfAPSmH5J
         iPyw1k6woanz7uEFG4n+dXytrUiPx1PSZb7dnRB8jIrH9mJYX5rz92q4sb0C4b4EmgBo
         wVYt9aPAHFVnz0/G8v1DIrwHTe/cZAsvzG3/iThyV6Yy37+ztVAueuRkzjyoQ702eyta
         kF9eC2gvcILOpmQpS3B2WHFML5xuF400Ub9qIZbxdXA8sLNuxY1B8cQxmk67iCmxUEzT
         aSJy8OEMpUXpE+QV/2QuiK9vo7RiBZgzs8zwm+7MGrKtL86yxxYjpE67Df0OD4xq1ZgB
         3RDA==
X-Forwarded-Encrypted: i=1; AFNElJ8QqbnlnU73TwaqKtAaXpLvqqXwItBjzy5MBsNhBQ7xU2Oo4uDVwymqHJaEvgDO8WjhTzZ0qiNw/Q==@kvack.org
X-Gm-Message-State: AOJu0YxXpwh2dM0JX0+mN1IGMU6WBLDTvAGv7F4S7KoPIJzg+Gwn2sYL
	9m7h8V6NV+XdpgBx2udDAwHmzS3hdK27zHsALrGBSwvwJienpb9KZRfUEPjJ/RiET1I=
X-Gm-Gg: AeBDies4j7VxnrJg8wQtEVrvDzoj6hLC1HQVjr8pTWeZbXPeUz5A64vmVqsWWOpnc2M
	BDXWMSuJ4nxiPMVjpHqy8dG8DL5WMY4ViQnIr9c8TfNybeHG7hyk8hm6M5Mavd8tg5CU2XVX7RT
	xu3RZqCzfOPuZ4VPm/h6KTKpOJQ9gQRq2Z5FI3ldpEtk55N8iAoacrfL/vFlm8qD94bbfmsPf0B
	8wRiZLxmzEGCbLs5igBlMQmhzkBR2+XRgQGF7ziPFyK2SEizrMb7objAFt2NYWpbNU/kI6c/Rbl
	i6YgBrWSFFW8OefYXarW3gJgYrl+ctFT05QyCDG5Jl6mEoPOMEZpKn+GnC70JrY2pJUs+KmOKpG
	hVvqHwQwr1/RZtFNob5VK6JmjrhZ07VS9FixpIvhBIh8TojdEdveAL3jG2w64BOd+zmzHI1M9yr
	Sew4iN+US7elXoAmtB15fPS10zeN/Kw+DUzRFlM7VIa3Qi
X-Received: by 2002:a05:600c:5292:b0:486:fe39:28b7 with SMTP id 5b1f17b1804b1-488d67fa48emr170788255e9.9.1776065020262;
        Mon, 13 Apr 2026 00:23:40 -0700 (PDT)
Received: from localhost (109-81-29-22.rct.o2.cz. [109.81.29.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5dc7070sm89322685e9.10.2026.04.13.00.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:23:39 -0700 (PDT)
Date: Mon, 13 Apr 2026 09:23:38 +0200
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/8 RFC] mm/memcontrol, page_counter: move stock from
 mem_cgroup to page_counter
Message-ID: <adyZ-t4fiKFv_X5p@tiehlicka>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: r1r9wgyfad6wffk9hondcnsb7qah6uaw
X-Rspamd-Queue-Id: EBC0120008
X-Rspam-User: 
X-HE-Tag: 1776065021-690086
X-HE-Meta: U2FsdGVkX18E1/oKHz96YtUsZKqvkUjIV5Y7ru1+OzajSBRVHqxYcYBnh0HykJNJROXbou0RwGwPs6HZufc0rz94iXxT+ai9PmfpojPRHd7jTelhLvSxzGhWxMKk+h94RwmRYpjW5nzjkzuSkQIqeNMQbboYrZU/eGcQHeNOHFJ+PePQnGPPwLi0KhdNGcspJBXDaHkQQMy+jIzL9AB4RPY7vszVrk6Ykfas/0RUcWcxfawDginW3zi/e4k5bwFhfVq5Hs7y5PbScyj1+LHgo0lytrEzgv2xefso79wT+/BrW7w09lfSy3955HXG6d1APqxzdwUTS9Z2mQbtKMPDlWdsGN4AHJBjBjK9IPPDwIV2xqaT3VrMORUOdIYn2sZYrzy0yHzs1RM25ZdIsNFZziTQyzcf2ECHv083RlEwx13b55yQbgp0TZgmRBGsdaMOVy4Lgl7IcPSbrZ/uUv2WVYFz7gyDXxXQkMdKbi+iWiiXrihfYe80klwbols1kMyhgHnIiKVoBiwmJEGEsqQrFXACo5GQS80EDkBWTYdFVAWTFsEjsvyiXjYR+ylDpLmn3/GD3H1rt5U1b+2+SkBxuzt5hh63Zmj+JaUpAbw6/lJ7WAa0twzYKNr0rN3Ty0XfonKtK1ko2LG+Ex3OpGPBHJh7RvfkttBs4otW+B29e2kYRMS/7Qx0Ze3HR8aJ+Q3cDgAjfzEgxBAt2U80ihuHtbdSKoZNWMnY8CU2rLPi/713SqYGk+14DcSIlhbE4P9FxRyzopr419DCYL4O+GI7keY1h8ZiASqcWuXTAJJSwODRK8MS8O3LcRrHQK5rN6cyjq/1AboQ94H55ofiUJ1v7BYCuUFDpe6sRfjEghSxFHrPCkqrETMWebY4xxM2NMr+Px35U1w3jqMUin+FQGcEVVoAD6txUPFezWyJMvtTEd/xfUqRUrnYogiWq9BUDRXlXudkhSqgOyAwxDJB2xO
 G8cyt9FR
 hbF5Xo5QVPkQuo4qFlz4QME1Jov+wss/aTxoE4veoJt+apwS7sQJJwPGy9RDd/MI7NdCeK4oMCpswYfpadruLPM1wDryo+sWz1fjBLgcns5gFRRqK5SrpHkCRJWCYPzVmdCDR+PJL2JxlGny+zq8HH9U5K6XjtPsJ24hFD1lTRFYxKPkBKvUw+Oi8cXYZLBg0I0Mos33pD4d+nXn4xAZFb/77hz2Zox7zTlJ2vnwzE6/l00/WdyeULCLqTXm1paf/Qyi+wX5pg8crZnaUAtJ/6KTQhymGDSd/V/HCv9edGM2th40wuwPUn9bxVLh9/7p023qWjSsH2e7EoMB5Wl/Yd5XpNWTvj6/MzfYsrw7AH3j4fxRdoL1DOLne/AuYa9KjCDC2miroykLYuXkcMpBV7EWqLDx8qRe769dsA2GZViH1PsYYwfct2t9on2laWpSKIJTPYqmRKWefqhEK15krdHuRkWqK8ZMAS2D90F5X49t2o0YnXV9t0ZcIFOVITLUNBzMgR9UOtV5RVQlvLQjjLB7OAQf4/ZuPBknwT2x/v3Em1DvMXKDhjw7zyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 10-04-26 14:06:54, Joshua Hahn wrote:
> Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> allocations, allowing small allocations and frees to avoid walking the
> expensive mem_cgroup hierarchy traversal on each charge. This design
> introduces a fastpath to charge/uncharge, but has several limitations:
> 
> 1. Each CPU can track up to 7 (NR_MEMCG_STOCK) mem_cgroups. When more
>    than 7 mem_cgroups are actively charging on a single CPU, a random
>    victim is evicted, and its associated stock is drained, which
>    triggers unnecessary hierarchy walks.
> 
>    Note that previously there used to be a 1-1 mapping between CPU and
>    memcg stock; it was bumped up to 7 in f735eebe55f8f ("multi-memcg
>    percpu charge cache") because it was observed that stock would
>    frequently get flushed and refilled.

All true but it is quite important to note that this all is bounded to
nr_online_cpus*NR_MEMCG_STOCK*MEMCG_CHARGE_BATCH. You are proposing to
increase this to s@NR_MEMCG_STOCK@nr_leaf_cgroups@. In invornments with
many cpus and and directly charged cgroups this can be considerable
hidden overcharge. Have you considered that and evaluated potential
impact?

> 2. Stock management is tightly coupled to struct mem_cgroup, which
>    makes it difficult to add a new page_counter to struct mem_cgroup
>    and do its own stock management, since each operation has to be
>    duplicated.

Could you expand why this is a problem we need to address?

> 3. Each stock slot requires a css reference, as well as a traversal
>    overhead on every stock operation to check which cpu-memcg we are
>    trying to consume stock for.

Why is this a problem?
 
Please also be more explicit what kind of workloads are going to benefit
from this change. The existing caching scheme is simple and ineffective
but is it worth improving (likely your points 2 and 3 could clarify that)?

All that being said, I like the resulting code which is much easier to
follow. The caching is nicely transparent in the charging path which is
a plus. My main worry is that caching has caused some confusion in the
past and this change will amplify that by the scaling the amount of
cached charge. This needs to be really carefully evaluated.
-- 
Michal Hocko
SUSE Labs

