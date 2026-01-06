Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73B2C47BDD
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 10:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE486B008A; Tue,  6 Jan 2026 05:26:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C076B0093; Tue,  6 Jan 2026 05:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D9B6B0095; Tue,  6 Jan 2026 05:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 172916B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:26:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE0818BC09
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:26:04 +0000 (UTC)
X-FDA: 84301158648.23.3E42976
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf18.hostedemail.com (Postfix) with ESMTP id CBC041C0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:26:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="K/IeqBek";
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767695163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrYlgSs3aSLf4OO6JdIXAa9ZB/yG8lk++eER1aaE778=;
	b=qcydeXYtAqxPcifFxikZniTxmEF5V8U8aqtG/rVyaGcmSmdzG2Z89MY/bdzwnU5JPqiRGH
	oPWdpUROscI1uFiB/NCTIWH+8WoSnC4Q4o8/3uPxrshFSZ9EQR9eRFOp1qJuQHCnF81vl+
	vmEsHJw1nIUK9Rqdx38c25mUI1xhu18=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="K/IeqBek";
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767695163; a=rsa-sha256;
	cv=none;
	b=mLyJlBgovyTKBht9mkQZN/3xaQhGieaUrK5pVDxVP5ldJFqaYPElPJXicqpT4vAjPixTWJ
	YC5uy1vkC25D5/QdkRUGB/NKztRTH3T1hfGJEFFES7MEDOCo1N4SfFj1nRc7o9kEEpCv+w
	rE4+uK7mYlT7DLgjruwhhEF9pI5ixYk=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso4897855e9.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 02:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767695161; x=1768299961; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yrYlgSs3aSLf4OO6JdIXAa9ZB/yG8lk++eER1aaE778=;
        b=K/IeqBek/8kCjK+f8d94ImixVtJMTcRobmYnTZFy843d10fDOFSU22x8c7RmwK4pqE
         hy5q4sl+JVOYtgPThDE0T9MZF9QrIv2tUtm6aw4DHusfH6m6W2P4l41kv39PCnlqQVB7
         ODDTIZmpc+gzRCqAYeZxbDxKO7b2lnn8W6GYAAvEhcxlAxRkYyDZhq36MI4MjXDi6fwJ
         gstLDrlJN47WX96xQpwn1/d6mE4PEd2SYWTtEZbbRNEPoGHpOVKSKvqUlWkOzmSTv9IY
         u0efPUfSaOsOSKOcjtuOcI16jAB92LTOY8iu7WCVB8FWh16JHOzeiRYe1x5ZfkuSVmB3
         u1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767695161; x=1768299961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yrYlgSs3aSLf4OO6JdIXAa9ZB/yG8lk++eER1aaE778=;
        b=bFnClmVXpMOBM3YRRtK81cK1eBsC9cP8dfvKMC86ebb7Z5QE4Jw+ZBwcldcB0ggZBu
         hak+QmCiGLrCoc11fv+FyzhzJY0LTmHxkyGYDm70rN8X/RnCGJ5lZ/JasV/McscZWJQu
         iqurMP/xOCi3/ke60muTtv+zL4gvxTD4hGAaFeBLP4L1vfo52XArZnvY8AzlEmbgySjy
         RWj3tpPwlHtgjdh7wR/NBnCZEJbDR1oho+5mEDhSuoojEiQx/UZcKpQFhjnE+GrMLcvK
         BvsE2F8muhjuqDrudK/uz8Tkp38JRUOfkAvdHH2vdwT10+OBEnYOM6NOT5CsYwd88JD1
         W79A==
X-Forwarded-Encrypted: i=1; AJvYcCUn2NTGi61lbCgwWIPSIu9liW1b1EMK8j4SeidcSL//xMpBae1rzdfggCsv/lBtFf042RIeOeV8TQ==@kvack.org
X-Gm-Message-State: AOJu0YweHaGSGP5OCsVp1AhJa2zR7SnQyczD9ealWKBQC/j+BLP2dU1j
	F3UV+1U96UeefJjaL1qwHpqxUWjoNjfzJaVBM4ktUE5Re9I6UlfLYfpk8BRK93HDt3M=
X-Gm-Gg: AY/fxX5UGDsBwi5gyEQpu0QY6oL0fMw8UP+c69sBbyGHHTzGFpJFbVeidQL7ljl3yHv
	HNr9+UkOiTL5pnJ7IJrzpAuV8OYrm5Hz057kX+8/wyyh24pEcPMFL/iNM1Z/J+zirUAuX60ohCS
	C8L6KRkcRRHoY3odxwm0CgkV22ut/3QnTfF0FXd7i5fjL50Wk0fOjwGmot43z8dX4y1ev4LnPHC
	8q0j943HIGiBDEaB8EPFXnY6orXEcoNXB8ovgHF4AZghJKfkUgFc96HzRyS1oK6lObIJZsxFHY7
	UDQ1vlpsDV331g8Y7CEzpdsK52AKN6pNyyny/UzJX5QghYdmV2+l/1YytbfNDRm/39A0/Bg9QV3
	JOXjkM+4TkTwjZemiUokHlyj8FIxaXUUiC0lSI015ZjircGSdr9uccDWyR192vtt21ENc8LiI/I
	bmLMRMVAn9+1YeDnBKCNydxrMetSXzP43SF4c=
X-Google-Smtp-Source: AGHT+IFb++SFH+rzxjUyOLzVtbAwCNpIM3DiqRn405rjEU6hdyHt22A9JWXC6Ev1mua/rT+52Ubpuw==
X-Received: by 2002:a05:600c:3484:b0:477:7a78:3016 with SMTP id 5b1f17b1804b1-47d7f06dc14mr27492355e9.8.1767695161240;
        Tue, 06 Jan 2026 02:26:01 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df939sm3571930f8f.21.2026.01.06.02.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 02:26:00 -0800 (PST)
Date: Tue, 6 Jan 2026 11:25:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] memcg: separate private and public ID namespaces
Message-ID: <aVzjN5z3w114fNB4@tiehlicka>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CBC041C0005
X-Stat-Signature: shokiom1gh9i1gmsq1mfao7u1a36xx5f
X-Rspam-User: 
X-HE-Tag: 1767695162-170017
X-HE-Meta: U2FsdGVkX1/ttx4izZ957WTUXqMHKgU70fo6qFaDS6rEjkYyV2jVozkteajbW8DYTmqs8GhSnKkI9ORuLEgGOuxBDgyy4x9nf5REzUP7n6LPq/PCGbMU+Y44RmstsGTMyv2VdwqE5DAehyVgVH/cIry3RlsjKjKg2kn7Bmf4aQYcv6TfgsGCeBVoGKGuhYzGcXjjFJMMiVXVeourki6ekzrvqyEoWewRWeODCJeMnpxTFtfNMzSJ6PTXRE6ihoFB1GFHhoAD5stMDe0zWx5rbtYnKzj8enGn7cXNEOoU+ECoiqHK6WLuSaD7Lyhu7QFcouhqGEF4+tciF/q4J2ziwoJjZMqriKk18Phnc4TYEDTA3RGkZB13ngvg9T9UvKKLsn53piw91WMsutCVMzbDxA08vvgHugi3q5TpNki5oKZZNRfUPzsdmMYTkFt6hbSDgQgcrgwmpnYCyw+JEesuTPgMdArFsE27/62+VJyc9rpVE8+etl6c5xEAhQW2YiWPVkzJ4ujPKwKPMwpEzoZkE1Vg9uyv8VN7Yfyej5vE/3qvrVxd49ThcoEIN71y03Aw6v6M3oTT+2zsXPkTSB5px3gS/DLK/v6E79Kud2lhqV2g3HMtvhz9Sk6/FxuQ5a5o2ImclaFriY/7DT8wsm4r3rhzmeNURUkmKX0qKGDs8zooLVr1ihCsS2/Bw0ZdzzqWgq/ngsFLC24djKMDhwbiv5VlWnn+zjV6E48nTRuNTUttuLOh8zEueBGcC4o0uOCEqwyLUC/xLh54ly1LrzRvhYlBMQPTCPHYg9oG3DMGh/RuX7r8mO4m/NPJPVf+qaBI4C7Mhk5glY2esfjQ/0RrDkpyJv25//Ec4jBSfL2VM7PhZf9008f/aJS0XUnMqLcq/CNQUIoILeNgHGIF87jmB9oq2Fd+y6Zwoaoe3sjADraAtIP+nqBxcBt2Ghi4T0PQgOnuwHedoEeNdXycCnI
 v3i5dyJZ
 RBv4X779DkIxaNDK2CLhMjnDNdTm0SBDgMyZO+3w/tdd4cYfHTPbfvn9SEOECbld3p6aym1GgBDuq4O/GrY+pVh5oaOuYQC3Ym8HM7iFv9DxXvG8Clohg6R+5Ai+7y2+4dHs8sZWSELE3z/EQl5/WxqzLJgHwy0hOjgqPh3DDw/MH7tm8svtQDjY7uoW13dm+CK/Y2t3jwScyRJFpu8+b0l6dSffFTmF2676JIY1uc5FjcYV8VJ8DVZGkrMj9I3zO4kEvixcDrvNsXOEJhik60/3zIbI6SiBRkREGPrC1Ws9LNW4Gl4IOHbpbfBEUiBPtvsqZe5SlSU9wpj6MXo42Z4M8eqJZkx0BefAucGonwe0R6nOI/stbP0GqC/ROQKSWdh5tYU3NjbF/QJTwe1tgi/PSrGqO3NBAWm5tT9Qz0a3ZDxCGl0fy6QdLEXbYNdZ0viZb9aV9zhUr8kDsoyVBLDNRDu33F/2McvQltfH1c/0xdB+Vmom2of5lTg0FHyG+aX7pJMvzVpahm5Pz43gxiH4m3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 25-12-25 15:21:08, Shakeel Butt wrote:
> The memory cgroup subsystem maintains a private ID infrastructure that
> is decoupled from the cgroup IDs. This private ID system exists because
> some kernel objects (like swap entries and shadow entries in the
> workingset code) can outlive the cgroup they were associated with.
> The motivation is best described in commit 73f576c04b941 ("mm:
> memcontrol: fix cgroup creation failure after many small jobs").
> 
> Unfortunately, some in-kernel users (DAMON, LRU gen debugfs interface,
> shrinker debugfs) started exposing these private IDs to userspace.
> This is problematic because:
> 
> 1. The private IDs are internal implementation details that could change
> 2. Userspace already has access to cgroup IDs through the cgroup
>    filesystem
> 3. Using different ID namespaces in different interfaces is confusing
> 
> This series cleans up the memcg ID infrastructure by:
> 
> 1. Explicitly marking the private ID APIs with "private" in their names
>    to make it clear they are for internal use only (swap/workingset)
> 
> 2. Making the public cgroup ID APIs (mem_cgroup_id/mem_cgroup_get_from_id)
>    unconditionally available
> 
> 3. Converting DAMON, LRU gen, and shrinker debugfs interfaces to use
>    the public cgroup IDs instead of the private IDs
> 
> 4. Removing the now-unused wrapper functions and renaming the public
>    APIs for clarity
> 
> After this series:
> - mem_cgroup_private_id() / mem_cgroup_from_private_id() are used for
>   internal kernel objects that outlive their cgroup (swap, workingset)
> - mem_cgroup_id() / mem_cgroup_get_from_id() return the public cgroup ID
>   (from cgroup_id()) for use in userspace-facing interfaces
> 
> Note: please apply this series after the patch at
> https://lore.kernel.org/20251225002904.139543-1-shakeel.butt@linux.dev/

Makes sense to me. Originally I was not supper happy about the private
interface as this should be really private to memcg proper but then I
have noticed the lru code needs this outside and dealing with that would
be quite messy so an explicit name is probably better in the end.

Feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> 
> Shakeel Butt (8):
>   memcg: introduce private id API for in-kernel users
>   memcg: expose mem_cgroup_ino() and mem_cgroup_get_from_ino()
>     unconditionally
>   memcg: mem_cgroup_get_from_ino() returns NULL on error
>   memcg: use cgroup_id() instead of cgroup_ino() for memcg ID
>   mm/damon: use cgroup ID instead of private memcg ID
>   mm/vmscan: use cgroup ID instead of private memcg ID in lru_gen
>     interface
>   memcg: remove unused mem_cgroup_id() and mem_cgroup_from_id()
>   memcg: rename mem_cgroup_ino() to mem_cgroup_id()
> 
>  include/linux/damon.h      |  4 +--
>  include/linux/memcontrol.h | 26 +++++++----------
>  mm/damon/core.c            |  7 ++---
>  mm/damon/sysfs-schemes.c   |  6 ++--
>  mm/list_lru.c              |  2 +-
>  mm/memcontrol-v1.c         |  6 ++--
>  mm/memcontrol-v1.h         |  4 +--
>  mm/memcontrol.c            | 60 ++++++++++++++++++--------------------
>  mm/shrinker_debug.c        | 13 +++++----
>  mm/vmscan.c                | 17 ++++-------
>  mm/workingset.c            |  8 ++---
>  11 files changed, 68 insertions(+), 85 deletions(-)
> 
> --
> 2.47.3

-- 
Michal Hocko
SUSE Labs

