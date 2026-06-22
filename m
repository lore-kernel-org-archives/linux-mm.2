Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B4BCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78B66B0095; Mon, 22 Jun 2026 19:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28EB6B0098; Mon, 22 Jun 2026 19:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17E66B0099; Mon, 22 Jun 2026 19:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1F86B0095
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:19:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D38DA1202A5
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:19:53 +0000 (UTC)
X-FDA: 84909118266.11.598CE8A
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id E5B55140002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:19:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGRskXls;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782170392;
	b=oqMSaZkUTHapSopALJhndKNRqpzkUC1oXFyZ3TYhwkw1kWn6NdJB9Q2fai5OrbeLglcwPh
	NjBr+JAAodjw7PnOYi1ofYVuY8PlhEA/acCzkJmt2zJ6paGxp6b9S451BhUnS/pDEOho4y
	aVyhO9PBHdcfuBBDl07uNhFJPQ5k6Nw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782170392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoK1Vry3ZA37o4N+PhVs+8t5kaUWOE3Fz+zyZS4k++4=;
	b=S5/8HMv/Bkf2DVvNCLQaz+P6GAWwn5PnbC+ksPnqUMhPu0TNw2Awo1H8yUwBoWreIdZpjw
	TW0zjKrMjlsszNCY4yiPvdss9LaK4mZNUNkLVkwWYcIlaE2Du2e3OBqCsw+Zu77OGmXwOv
	zniZJuquzIma+oU7t+cml0+RMVEOsQ8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGRskXls;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-489f3611e0cso2361169b6e.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782170391; x=1782775191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoK1Vry3ZA37o4N+PhVs+8t5kaUWOE3Fz+zyZS4k++4=;
        b=jGRskXlsut3sRMq4B3Of7xTvAdHqBmxk2NdMd7KmOPN3bUCwPs1DKe0K3MvV73pAQE
         57uXgR/YtOz2cWEG+eyngd0QQ9gWjSGcIO3FW56RB3UXN+IqxJMGJTyWDZ2Da/VsXTQS
         stw0pwMYOmcU7fw4tTmbbUiXoSXV9Dcqg01JwfT0rXhK6b38l5TaNH9xCqMMKgOZdnuZ
         7uh6mj7lPtZzBJq2Bp4Gvnb916Zl9QmJbOgxkMCRAr7ZlZUvrSlrJi91DOi9OCx5W9K0
         aNNRkyMKYzwDKW87LOuh4E4NfM7vVM+8d+AU7IJMKpQVQWFWBJc4A+3XwXqAWCmuVukf
         Z0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782170391; x=1782775191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UoK1Vry3ZA37o4N+PhVs+8t5kaUWOE3Fz+zyZS4k++4=;
        b=AcXJoQVtuVeRE7vNqXyJWKjiY1ZFaNX4zv50wdbOMj6MGF/R2/jp+xO00UzukQlh+v
         L8aBGsB6g90pJibOGrcF9jf553sSYl18DM3gXlOQxLQ6yhcz8vzaGAFea2W2xN3k+2hZ
         4Z23kCEVQfZsgMyJFnDLwWj/lvCI6hOm9nH3unyZ8M+3bl6HCl4AGUVU/r5byP0nm0nf
         h4iuk04DOPjL0/ojVr1nrZjyqdKjEthe3LT4NHlUImhQrlFH/lVOkpEVWsX64IwRXMvV
         BHULqbpx6ESWtGBPS+YJn655YDFHv3VK1bpytV1Lk+DArHEl7Rvb/9FcCpTdDny88ZW2
         BxUw==
X-Forwarded-Encrypted: i=1; AFNElJ+YYrP1OKL+fK/tIj7/peC9hk5mD5mrAKBzvgv1LGqlM69zv/0+5UxE3mSTIlctIvy3ZR4LmonT7w==@kvack.org
X-Gm-Message-State: AOJu0YyQ2QGAnrfbycE/XrSa00wZpbr1xAKVtYjaUt9TSdS1sctrJUMb
	nvQbawaV7wm87iS04Q8+yW8/U6sSxszd4RAgctb9jN4Iz0R+TJSgFprX
X-Gm-Gg: AfdE7clTxQg9hKTxUyWfMRoVnC3uMGxC8nob4gK96j6Y12W2BfR+elyG8R3HrX0K/Pd
	rKdlTr6DKYas9ap/pwlD5TVryuQv8J6z0h9eMaFMJJ/jb5cfFu34Yf5I0NeS1WZNJgOqgrDzldj
	eE63pxLd48UUOBDlpKyOzYaWqEX1PRB/ezQesj89rG4gh97h/hQfYST54wTiLiVrggYcpOZsPGa
	MlVetfN4FWQJiJVkQltelnIxs4qel53gIkqzI9X4j3oFKCp/8As3jGbt9BN4ohnXFGh2877w/9u
	pxNXHJbO1V2EWpGeD3vkqu764BKUJpekAcdpM8HNP58PyTBV3BTDpIsuK6mUzfb3P6/3AMaFb9F
	jRZbZRUP+PIxCLCyCBKmRj2HHQwN1B70YZEqxSFV9oH2Nh7O/O4JYvd+6iGkBYnChHsG+AV9d4z
	RcJq0YAXRrX2xeJCYc+uiZZVFmcl2iHxa11YX1gY6A4A==
X-Received: by 2002:a05:6808:191c:b0:487:4c11:7a17 with SMTP id 5614622812f47-4896acb178emr14254437b6e.36.1782170390846;
        Mon, 22 Jun 2026 16:19:50 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48aec0e5e53sm5453907b6e.8.2026.06.22.16.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 16:19:50 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
Date: Mon, 22 Jun 2026 16:19:47 -0700
Message-ID: <20260622231948.1002174-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAO9r8zP6zDshSGU4chaHiPocahQZpiK5Z-eP9VKH+2_xjNM+4g@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 83ntmjwqfrocckbdz3pmh7ehhjrpzutb
X-Rspamd-Queue-Id: E5B55140002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782170391-633242
X-HE-Meta: U2FsdGVkX1/FGtqbxFgjqtaaqbqMMTNwxEXvxz2sHQEKTbiNkXUJr3bYCb3rDNtTTry9XBHkGKL3A5mnUiEX4vwAMsJfvORoUzGxl92IEJfQrerg+n/cD/DT99tkRYK67iiYlNKmjRYnk7AZKWIgYT9k8mD31wn8AmlCmEzo6X7EYoOU2wcYY4P4Q/YVpRlKb/ymiLwadJFRz7PkoZIIyBHLIcNF8bluPIUPqfihBgvsJqxgu10tvh0HFw88BTd4jJ2AHNDcx00ztcP2/u5E4fwn3+DeNqyvgAWu7KI+s5JrFzWJdN7pN3hTlcQnigBbiXjGoo2Hbuvz5jM3fZ2yJaaOFYYAgFtHA2LZ8GXS0qKy/WvM3KDHvAP47NUS3PD0gMYk2xCQ3gSBhTeu//vCtGNjaRefBrI5mj3b57LhvHdllI+KpaA9qGYU+FazdSfs21eZnq/GouoBgGu4/84Mw3/Ez7T1jp59sTiLxkeUV+7lPkUI4j6cQP8J5x9QLX2KtFRLUzMOm1k3KarOTjdWzDslC0iXJzcytu9rksuG1DT4QV3otTuoz4cIc2nqpe7AO9IdBmnJoLyAsCiFSsljnv0uW667qhg/QDnRpcybvSUnRWMAkcykU0vMoASBbiR++5zpE6AnR/EqXPkTZO5ue7QfxfICjzLd+2ZHYBK8w8qWLMmj5rc8ILuqK8NAwgF6bQxh8zcN7VqDw2ECNEU4FxJdL9GHWgaAgGs7u9ewWT5bJ6ehLqqav3iU7FLHW1Ig7ZYIl5jL+IPGut51CGnc4u5vjRTOBTUl/UlJHWsqLHs3yYIkA7kk8aIzhcS3Zqc9jKqJo2bCsFJecQdAb853hKlAPcZD6jMjxcpvazEMgWXBzEhg+EKuYJGHEoztimAwnCRUqFzXnwZBBtInFd1rOPPlZuIRbnthurz1GgO8U7KxDUNX9ltRpKWhfNykjkzMOXSJlDsPVpzNax4NZro
 ky4vu1+W
 1v9CrwAc1mcdpNJlxwH8LQEhu+kcG/McE7wv4ZoQyKbg0T6WGoQNKYdCcRWTfeCG1ggXXP/ETtr205ZJCF9P/bzThXpA20fotzsVZaeyVoF5/1gJTeiumIGZW6EJMUTy0CA2bAhOAXlwhZa6xWFlsPg4k94JkiE3Jziq5TWJ+8t4WjalfqynDGZzpnc5Z/WxcBIjlMZsmGCFKpJMoG0mA6yta/4Z2lBEsjhMHdhc5TWybPcJaUWG+xpXQ/JTV2fDyqxsixh79yLZkf7IfC9HVTIVTWvOjJhsSQVJybDO7GAq0O2B1Sj5PFba1i+gjMf1+Kk3QpDKR2nDEdErHEHjn0CGcIkJMcyimA/i43Vye4litkOqx5d82SDAoxKIcK3At7BSYgocli+rfpm4QgAaWGDGaBaW59djAa3NUw5I/wwmOxc+9PeZN5hzkzhO26WxdzHjmemf+QVpkYdnAqDy3IkDzNsjIfCF15uNVrq75eAiFzdy0PQQ8Iukpm4p13Tp7d0uZhYuv0pGSStVAsQvJ/qC8V2NPN7MKGd2dfqWTVAsn8Qte5xR6W+26bIg841sB0TKsRmys+tc30QZxEUpNY5OJuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 15:26:17 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Mon, Jun 22, 2026 at 3:10 PM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > On Mon, 22 Jun 2026 14:21:30 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > > On Sat, Jun 20, 2026 at 11:17 AM Youngjun Park <her0gyugyu@gmail.com> wrote:
> > > >
> > > > Introduce memory.swap.tiers.max, a flat-keyed file listing each
> > > > tier defined in /sys/kernel/mm/swap/tiers with its state, "max"
> > > > (allowed, the default) or "0" (disabled).  A tier is one bit in the
> > > > cgroup's tier mask, so writing "<tier> max" or "<tier> 0" sets or
> > > > clears that bit.
> > > >
> > > > Since the current use case lacks amount control, it only supports
> > > > "max" (on) and "0" (off). Therefore, it does not track per-tier swap
> > > > usage, relying instead on a fast runtime bitmask check.
> > > >
> > > > We maintain both `mask` and `effective_mask`. The `effective_mask` is
> > > > strictly bounded by the parent (e.g., if a parent is "0", the child's
> > > > effective state is "0" even if its `mask` is "max"). Maintaining this
> > > > separately avoids costly cgroup tree traversals to check ancestors at
> > > > runtime.
> > > >
> > > > Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > > ---
> > > >  Documentation/admin-guide/cgroup-v2.rst |  20 +++++
> > > >  Documentation/mm/swap-tier.rst          |   9 +++
> > > >  include/linux/memcontrol.h              |   5 ++
> > > >  mm/memcontrol.c                         |  67 ++++++++++++++++
> > > >  mm/swap_state.c                         |   5 +-
> > > >  mm/swap_tier.c                          | 102 +++++++++++++++++++++++-
> > > >  mm/swap_tier.h                          |  57 +++++++++++--
> > > >  7 files changed, 255 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > > > index 6efd0095ed99..4843ffcfd110 100644
> > > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > > @@ -1850,6 +1850,26 @@ The following nested keys are defined.
> > > >         Swap usage hard limit.  If a cgroup's swap usage reaches this
> > > >         limit, anonymous memory of the cgroup will not be swapped out.
> > > >
> > > > +  memory.swap.tiers.max
> > > > +       A read-write flat-keyed file which exists on non-root
> > > > +       cgroups.  The default is "max" for every tier.
> >
> > Hi Yosry,
> >
> > Sorry, I feel like I'm joining the party late. Apologies if I'm missing
> > some context or repeating a discussion that's already been had.
> > Please let me know if that is the case.
> >
> > One quick tangent:
> > I was chatting with Nhat last week about swap tiers and its relation to
> > memory tiering. Nhat brought up a good point, which is that while both
> > swap tiers and memory tiers provide a clear hierarchy of performance,
> > only memory tiering allows for movement between the tiers.
> > AFAICT, swap tiering does not allow for direct migration from a higher
> > tier swap backend to a lower tier swap backend if the higher tier
> > backend runs out of memory.
> >
> > In that sense, I'm not entirely sure if we need to enforce similar
> > semantics across swap tiering and memory tiering; it seems like there
> > are some fundamental differences anyways to how we treat these tiers.
> >
> > > I wonder what should the default behavior be if memory.swap.max is set
> > > to a value other than "max". Should the limits in
> > > memory.swap.tiers.max auto-scale or remain as "max"? We probably want
> > > to keep the behavior consistent with memory tiering.
> > >
> > > Shakeel/Joshua, WDYT?
> >
> > I think that the motivation behind these tiers is different for swap
> > and memory. Tiered memory limits is motivated by preventing one
> > workload from conusming all of a valuable resource, while swap tiers
> > seems more to do with excluding certain workloads from using performant
> > tiers and ensuring other workloads stay on those performant tiers.
> >
> > IOW memory tiers exist for fairness, but it seems like swap tiers exist
> > for workload performance tiering. But maybe there's a usecase out there
> > that would want fairness to apply in the swap tiers as well that I am
> > not seeing.
> 
> I am not sure what use cases exist, but I think it's possible we end
> up wanting to enforce fairness for swap tiers as well. Maybe not as
> aggressively as memory (e.g. to avoid wearing out SSDs), but maybe at
> least proactively through userspace?
> 
> At the end of the day, faster swap tiers are also valuable resources
> that we probably don't want a few workloads to hog. I also think the
> interfaces being consistent makes everyone's lives easier, even if
> it's a bit of an overkill for swap tiers.

I see, thank you for the explanation. That makes sense to me.

> > If that is the case, I think auto-scaling makes sense but can be a bit
> > tricky, since there is no universal tiered ratio; each workload will
> > have different tiers it can swap to, so they will all have to calculate
> > their own ratios. Tiered memory limits escapes this difficulty since we
> > assume all memory can be placed on all tiers, so we have a system-wide
> > ratio : -)
> 
> Hmm I don't follow. It's also possible (maybe not initially) that a
> memcg cannot use specific memory tiers, right? I am not sure what the
> difference is.

You're right, I was speaking more to the current state of memory tiers.
The majority of the feedack I received was that we already have too
many memcg knobs, so I just opted to make tiered memcg limits a
cgroup mount, with no ability for individual memcgs to tune their
limits or opt-in/out.

What do you think Yosry? Would it make sense for us to be able to 
tune these values? Personally I think it makes sense but just wanted to
make the basic features merged before I went to push for making those
knobs tunable.

If we want to make the tuning the same across swap & memory we should
probably align on the file names and how we interact with them.

Thanks,
Joshua

