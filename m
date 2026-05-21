Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD28CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 01:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742B06B008A; Wed, 20 May 2026 21:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719EE6B008C; Wed, 20 May 2026 21:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630406B0092; Wed, 20 May 2026 21:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 564636B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:03:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E3C2B1A0314
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:03:22 +0000 (UTC)
X-FDA: 84789628644.30.29287D6
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 39B8220007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:03:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6LV4LV+;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779325401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWovRyu7TnS4H+kwdxrm7oVBHQW0yNncYwQSYPO+Gvg=;
	b=W2n0PChrl/hO6pHkHQASCkH9MNywre9hcBy2cKbwYb0QOgTIUwQmxdrNWm/P5cTkwqO71Z
	413AgFqFzOtahiedzuM9UY7xggDnBVDVeUv9mLlJhWtV22ZX2qZIF8tx14KZbHt2+rFka8
	NJOg4eQAJRYlzrlGfwbf2fYk6fpBwUg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779325401; a=rsa-sha256;
	cv=none;
	b=gHRVm1hA0dMTAu7xTrm0ZIb0sCd2YRwNuM4dOn5DC0QCxz9mbHJxMVvJxoNwRWy2P6xaN8
	VQckXoVtykepT7gZWXQRrvj5kfzQEUtSRYeQ4L4H1jCFp1g7vfo5nuWF4QnfakZXC3lC3W
	cngvNztGO7HMjP8tYrvyg9Fq2NPfhhY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6LV4LV+;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 20 May 2026 18:03:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779325399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aWovRyu7TnS4H+kwdxrm7oVBHQW0yNncYwQSYPO+Gvg=;
	b=j6LV4LV+gJnHuP5vaZFF3lT53uKAZT2pLPiHjyiGTZiKbLpe9h8/D62lPeKi0augmUVBep
	78FCkrDSxR15aaI8AyG4LEClbjjJ8eE3gaxJ57kyB4FmmHqPmjLCngHsXdwv0250i71qE3
	BTW/r8e8Wbu2o3MfX6kl/BFk0MLLvOE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
Message-ID: <ag5Ze4ugWTbOnSCe@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-3-shakeel.butt@linux.dev>
 <20260520142023.6eae5ec7@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520142023.6eae5ec7@pumpkin>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 39B8220007
X-Rspam-User: 
X-Stat-Signature: x88c5gjtbwmp3ohepwssobmtoi3rx6p3
X-HE-Tag: 1779325401-376216
X-HE-Meta: U2FsdGVkX18FNuN2xAH12Vd4m4yMteYNwl94GsttheI3hmlOAeHayYv6G/JpBw7tvBqWRxFVKxIZHP6w/2jy/YO8Q+o/Q91MPgX0I5y6ppmHAA1P9KRqXLK+BSGeJYiD0WBf4uWpU6BHrPCbvtznVib6xu6TbTlKZyNFV1fsyWzFOnLj0lRSwoz3d1WtbmL1Rx2pn4WKtXdVhXLI0LFzgrdfUNFeXvZ6fXqBvFWHt0614Vjj6Ae9ee/jLUaMMw+EOJzb9+yTrx+ZBlebBb7RmuvxQ8OWhMdeqzZdOWtzPEV+njNWs8JiOPHqE+GYJMg8YUfWgZ796xjCjlb5PQMTMny2Q09gI0DhnSKZM/y2dC/xbRE73t5Y7ZkBJ34UB78gj+fCm73rvuq5dWsOrCphbI2XNQPZemaurRBxl2pewJru6qSPv7X4LESc94dZPf7N9NKxdT0ztQAptVulOaGdwoiVWGPybdyg3qNBduyYORwRxcjtcNSzvAGQ6NXZf9XfKfWhdmIWekw8ELfo2GMEdnigGM89fvvuhKUn9JdIJQLx9a3wcQVYYIDjV3OMforkmmMTgIAI84rKfkNbHHhJoytkb08y2rLwiU3cyvDRnrjf7J5puH4wHR8p8YAH0sqFTPFXYLriDOPQk7HMiPgTlUSG20o//rYd2S655R0Trb6iP2pVdvZ3zgx0jZlS0Mp0h28MjDVxvuqIZQ/XOmv8tQWmHFMrQn/MOctZsAhUJ38YrV6nmy4s2w9rV0+LksKiCIH73lKkJypOu5bfBsN7B2krSVvuI1kGUYDR/Kywkk8qsMizlL6G2P371DhCWpciH4tsyqKcBycYU2rVNURpOzwIJF2RPBZ2IunuPPlLXp3RB2alYtPoLj1cNflLlWVSXLcVvrPgAcjdUDXujup6Qv0Y5aLdyMPOCiBPd1jdFdVJsV2LWO1BL/myR0mQf22AbmfTAHvkZJmGBOSF0g9
 U6tmZxOF
 mNJI86E/B7EmCw4CXJX+lwzouFIfCyB0CY6kpk4PSI9ReRg2t6uaaQA0imh11hDGSoFFV1c0JZLaf06NNJtwxOtW2oB/W/2rW3GO0qJmk2CGKX8/3fVP996QiwUl6DBRPMeNn8+6wkdg7fyqLa/lJRvqGK1XgG9qwzo0GuvACnQdD4/RFqMg05dLPOQ5ddRhPkg1XmzU7NOX7EMR3v0VrmbHcfkjlhv63/5EYY14kMyWUrtVcDlyCCKLNYiF1K5raEbHtOPEgJHgv9D4ZdtjZ8rFZk7BRmY6lTjLUI6w4ayxqDBQPKm17BKxxU4V+u8XDA3v6VENnNb1Ny0sqo+mFfprwZMQxNWbjxxpzUimIUwQujiC4cjGFx5m2E1BNf+10CEC9JGPCKR27Y3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 02:20:23PM +0100, David Laight wrote:
> On Tue, 19 May 2026 22:31:20 -0700
> Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
> > which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
> > shrink the per-CPU cache.
> > 
> > The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
> > _256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
> > PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
> > remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
> > == U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
> > U16_MAX. The accumulator also needs to stay within uint16_t between
> > page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
> > U16_MAX + 1.
> > 
> > Accumulate the new total in an 'unsigned int' local, then:
> > 
> >   1. Flush whenever the accumulator would hit U16_MAX. Together with
> >      the existing allow_uncharge flush at PAGE_SIZE, this keeps the
> >      uint16_t safe on PAGE_SIZE <= 64KiB.
> > 
> >   2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
> >      powerpc 44x), push any sub-page remainder above U16_MAX into
> >      objcg->nr_charged_bytes via atomic_add before storing back, so
> >      the store cannot silently truncate. The PAGE_SHIFT > 16 guard
> >      folds the branch out at compile time on smaller page sizes.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Tested-by: kernel test robot <oliver.sang@intel.com>
> > ---
> >  mm/memcontrol.c | 33 +++++++++++++++++++++++++++------
> >  1 file changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d7c162946719..b3d63d9f267c 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2019,7 +2019,7 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
> >  
> >  struct obj_stock_pcp {
> >  	local_trylock_t lock;
> > -	unsigned int nr_bytes;
> > +	uint16_t nr_bytes;
> >  	struct obj_cgroup *cached_objcg;
> >  	int16_t node_id;
> 
> You might want to move it to this hole.
> The size of 'lock' depends on kernel build options.

Thanks. In the final patch, I am rearranging the fields for better packing.
Please take a look at 4th patch and see if it still need fixing.

