Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC528CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 22:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46BFB6B0088; Mon, 22 Jun 2026 18:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5C46B008A; Mon, 22 Jun 2026 18:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDA66B008C; Mon, 22 Jun 2026 18:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBC9D6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:26:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AF731C53BF
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:26:33 +0000 (UTC)
X-FDA: 84908983866.16.CB82A7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7C50680007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:26:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H69N20hX;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782167191;
	b=4frzrE3dJ6Ye6h8pc4myzQXJdJn6Z031JUsdFaHTGbYurDtELveJ2BEQCfwPT7Bw6Chono
	+GRkTNpCZIkqrL0GwgKZ1k8yDCpW7ZYDPaaVdb+Ys4jdJGryutq/deMnFkVOmDHvXIEWX+
	WRw+hFuNc+j8+IRHiIpVXQlyNOfrYzY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782167191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGHFR3otSoYMVHIMKTx92Qc2dyqLTWvcbb+UcCOAzWk=;
	b=L3IuUmbRER/0bLpoAIIq2f3q5xF38RZCVqOv+6ee65ZzT3cweWG3XspuJ0pofUZTfMpMhx
	z9zlfPJVfmOBJALuR7RLuqts2eJ1n/a3/E+ugNkBzhcPqrZ8o09z+FoFxs8PoPiWnpAyAN
	HhktMqUDmI6ESS8D9iihKApuU9yFZAw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H69N20hX;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44DD64456E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF9E1F01564
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782167190;
	bh=LGHFR3otSoYMVHIMKTx92Qc2dyqLTWvcbb+UcCOAzWk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H69N20hXCx2EFg2GRY1BYm2M3GBmBAqcjbIX2TUFlx3VlSneU8Dy4Q8JA/OQj4tEn
	 /LW0VMDEn/LlfsGBKL8Bj/qN10Jt4Xpdbmgkh0s1JA9B2mcTES4r+WcmN1VOI/tQrk
	 HYv23c3F3vSaMUWgPGT46FgU6T/N8yiV7GelXqRk4yn68vUbnVHwloCMJyp+B631bq
	 yqYQWKNnhUg0pdr4uVKGGkNiKVUM5fx09BM3FlhrRQch64Pj2wYKvdIeM5CBr+XjOr
	 WMwie2OyfWQbNazRk6UhG7pgLf9aZ5+s2LmzrRipsEihZqclUPgE+vVTfCU8J37mYP
	 csJUXTDuChaMw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c0be5e548a4so430579566b.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:26:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ90AI8UakBf5wWaSbPDm7db/kei/+XZLQiljBSMA7B5emrn2/XmsfRnGxlSsf1Xv6Tgh11GMoHtsA==@kvack.org
X-Gm-Message-State: AOJu0YwudRJF5sIew0FsfK3oTSHIu3eHArzfSUWaXAAm+fqhSvuX9aAt
	nDni/Ze48vssj6x72t+tley5DmhGWtSYbsStTqRhIrQp958cAizxfDiZlw2R7uq3rIiaSOSm88Z
	nSd1fvd2IrlHTBWPxzAlDUKpj1Te/3+c=
X-Received: by 2002:a17:907:3d4d:b0:bfe:ed06:5a20 with SMTP id
 a640c23a62f3a-c098ed16f00mr822557666b.53.1782167188897; Mon, 22 Jun 2026
 15:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zNjyW1rh26vv2vavCM_2-r70EuynU+-7XdEmrBdLL=TkQ@mail.gmail.com>
 <20260622221037.255359-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260622221037.255359-1-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 22 Jun 2026 15:26:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP6zDshSGU4chaHiPocahQZpiK5Z-eP9VKH+2_xjNM+4g@mail.gmail.com>
X-Gm-Features: AVVi8CcPvB6x8GnlUC9ZSP0DpmmufpwngYWRm_3G-i9cXpRnV9FIWkWhZqkPsUg
Message-ID: <CAO9r8zP6zDshSGU4chaHiPocahQZpiK5Z-eP9VKH+2_xjNM+4g@mail.gmail.com>
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Youngjun Park <her0gyugyu@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	akpm@linux-foundation.org, chrisl@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ua8ngu9q4h69r8it3o4xukrm39zm7jey
X-Rspamd-Queue-Id: 7C50680007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782167191-731825
X-HE-Meta: U2FsdGVkX1/YZu5qG/35KSu1ebHvRv3uqcxoSfprUDYf7eClZpESf7tJeCw7pyO47zznjJClOxU04+H+5XUJWIuO7r0Pu0ObQsag5auAe+fCVDYTawmW9rUNDKYjw/uiUzhuKFkQuPHjCe4flDvEqpcfSN6OHRoyb2++NisgXO+nQzJKXZU3a7H4B4fIo08udbuKA1g3sV4OTUBQ+htbipkcqRGaPisiAjqvWTnKWKy5vx+3aCwq8LC6WDo62atbVnZ+rUSEtGR0vvAwGU2/S+i/d/YzPDWXnIYO6QBFu1vZvefZJOiRELbpkyXDR7zunWF6XsVVzDvemrddSHNDsFjdEi8i4g1L06j1evzUajzWRIDcbxx1A5TPYSDz3qiaJXY1eQwX3O9JeU35FL0Qud9L7pF5ibc7Q6IH8rDJun8a9k4L2BGLblrMrqgLpfZ6AFXUGPKLq8guBprwlMd9VYVVqT9EyF25LnlpPMLXD7XZ7MmPm7KwakCLb/j0i3DRMKFFQfzp+Vwgxwu9Y0xCQgCZZyDBGlRxkhIRD4Gc6ey9A5vlBopgs23qxzGwoVo61ycPFOmYtIlY67bAHEywstZY/PLaAbvzp8tr//ebvMwGaMWLLyfFSQoeHKS99mss/9n8sZfAJ4cZ3pzMIyi3N56uhk6cJntEL4MxXkC+Eg9kB1dtM5U7sIr9r+A6g89tJSkwfz8Sa2hXQFzpAv+yWadKEZ6q7NKGhdfWh9hc3reCLMvtKh3neLY0yaSO+dSc2nyM37jyEpqSMCRw3AtTClaM8tSZeTx7LR1IAt7pkARNAUYmqJccTQgQib3UQPypHI3D9SfLRnafLRngPKt7Y4w0uNAgHfuzgBqhN3IkYABMevntUDEJufykAhq0yQJou/K6UcZlOeNgWDfM5KzZ6Cbvn/SfCG7+9GRgwmKBqMN4DMMJ9xW+v/H4iyrcs/1RE+QAhg4rm3xTBJaQhcc
 qGcXZ8I7
 XrL4+GR0k6hLFlCN0V2Wi6STtnYcNOP81yH0+JAah3zFBSBNlk6Vq6wB06EoYD+xN7oOWUwkxtlD9C12efqBM6CuEyBxUvGb/Y79hhDi2+n+kcgrM78r+bGN4Ge+u1dJxZ3OShkEDYdvMLIK/FmbYJvHgvkHyfIwtff+n47f8EyXs8ou74hdT/p/7kEH0YDra9R+MOJPNKE5CvmXBdiWbwsFXRcZdBpxqDomjsHAIDmJbnbpdtn5fSe5Sh46K4888luvNxQ6vsFKc9s8jqTs/YJyMJ2THMIf9H0KSn2uRjTLzkTsmXJ4sfEeomSD4a+837LFAOAPXxFiKdZhi0eEzb55t07HjqPX7WZjya8RKhTEf5B4CwFI3asFkNQYSrQompU5cmKCNzYX4Sb0trbGo0vPJzD2j21V5tLuVq2wud4AtaryVW1CovlXsaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:10=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> On Mon, 22 Jun 2026 14:21:30 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > On Sat, Jun 20, 2026 at 11:17=E2=80=AFAM Youngjun Park <her0gyugyu@gmai=
l.com> wrote:
> > >
> > > Introduce memory.swap.tiers.max, a flat-keyed file listing each
> > > tier defined in /sys/kernel/mm/swap/tiers with its state, "max"
> > > (allowed, the default) or "0" (disabled).  A tier is one bit in the
> > > cgroup's tier mask, so writing "<tier> max" or "<tier> 0" sets or
> > > clears that bit.
> > >
> > > Since the current use case lacks amount control, it only supports
> > > "max" (on) and "0" (off). Therefore, it does not track per-tier swap
> > > usage, relying instead on a fast runtime bitmask check.
> > >
> > > We maintain both `mask` and `effective_mask`. The `effective_mask` is
> > > strictly bounded by the parent (e.g., if a parent is "0", the child's
> > > effective state is "0" even if its `mask` is "max"). Maintaining this
> > > separately avoids costly cgroup tree traversals to check ancestors at
> > > runtime.
> > >
> > > Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > ---
> > >  Documentation/admin-guide/cgroup-v2.rst |  20 +++++
> > >  Documentation/mm/swap-tier.rst          |   9 +++
> > >  include/linux/memcontrol.h              |   5 ++
> > >  mm/memcontrol.c                         |  67 ++++++++++++++++
> > >  mm/swap_state.c                         |   5 +-
> > >  mm/swap_tier.c                          | 102 ++++++++++++++++++++++=
+-
> > >  mm/swap_tier.h                          |  57 +++++++++++--
> > >  7 files changed, 255 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/=
admin-guide/cgroup-v2.rst
> > > index 6efd0095ed99..4843ffcfd110 100644
> > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > @@ -1850,6 +1850,26 @@ The following nested keys are defined.
> > >         Swap usage hard limit.  If a cgroup's swap usage reaches this
> > >         limit, anonymous memory of the cgroup will not be swapped out=
.
> > >
> > > +  memory.swap.tiers.max
> > > +       A read-write flat-keyed file which exists on non-root
> > > +       cgroups.  The default is "max" for every tier.
>
> Hi Yosry,
>
> Sorry, I feel like I'm joining the party late. Apologies if I'm missing
> some context or repeating a discussion that's already been had.
> Please let me know if that is the case.
>
> One quick tangent:
> I was chatting with Nhat last week about swap tiers and its relation to
> memory tiering. Nhat brought up a good point, which is that while both
> swap tiers and memory tiers provide a clear hierarchy of performance,
> only memory tiering allows for movement between the tiers.
> AFAICT, swap tiering does not allow for direct migration from a higher
> tier swap backend to a lower tier swap backend if the higher tier
> backend runs out of memory.
>
> In that sense, I'm not entirely sure if we need to enforce similar
> semantics across swap tiering and memory tiering; it seems like there
> are some fundamental differences anyways to how we treat these tiers.
>
> > I wonder what should the default behavior be if memory.swap.max is set
> > to a value other than "max". Should the limits in
> > memory.swap.tiers.max auto-scale or remain as "max"? We probably want
> > to keep the behavior consistent with memory tiering.
> >
> > Shakeel/Joshua, WDYT?
>
> I think that the motivation behind these tiers is different for swap
> and memory. Tiered memory limits is motivated by preventing one
> workload from conusming all of a valuable resource, while swap tiers
> seems more to do with excluding certain workloads from using performant
> tiers and ensuring other workloads stay on those performant tiers.
>
> IOW memory tiers exist for fairness, but it seems like swap tiers exist
> for workload performance tiering. But maybe there's a usecase out there
> that would want fairness to apply in the swap tiers as well that I am
> not seeing.

I am not sure what use cases exist, but I think it's possible we end
up wanting to enforce fairness for swap tiers as well. Maybe not as
aggressively as memory (e.g. to avoid wearing out SSDs), but maybe at
least proactively through userspace?

At the end of the day, faster swap tiers are also valuable resources
that we probably don't want a few workloads to hog. I also think the
interfaces being consistent makes everyone's lives easier, even if
it's a bit of an overkill for swap tiers.

>
> If that is the case, I think auto-scaling makes sense but can be a bit
> tricky, since there is no universal tiered ratio; each workload will
> have different tiers it can swap to, so they will all have to calculate
> their own ratios. Tiered memory limits escapes this difficulty since we
> assume all memory can be placed on all tiers, so we have a system-wide
> ratio : -)

Hmm I don't follow. It's also possible (maybe not initially) that a
memcg cannot use specific memory tiers, right? I am not sure what the
difference is.

>
> Let me know what you think! Have a great day :D
> Joshua

