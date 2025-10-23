Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 530CECCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 21:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C768E0014; Thu, 23 Oct 2025 17:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973EE8E0002; Thu, 23 Oct 2025 17:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7A78E0014; Thu, 23 Oct 2025 17:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDD48E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:35:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 270D149410
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:35:18 +0000 (UTC)
X-FDA: 84030685116.21.A64447E
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 628E816000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:35:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=js3riS21;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761255316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErOQJZYuBYGdBpUlkz7xxYDD/7HNDrO9In4Qqb0EuxE=;
	b=JP+/Ow71fJodhjVYgcZ9eUPz8phW58UisthF4tpoX/P/jeGbeA7vqY4EUvUXCUmxmh8vG/
	maTR8VH88L/QAfP061VUlo4/TROSfx41gkFtDbQsu45Hd/LGH8ubfqeKINXrPDqkVec8y1
	OQ071wFhzT9Ohpgf0/HsbTdYSLkvKXM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=js3riS21;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761255316; a=rsa-sha256;
	cv=none;
	b=WqGaqHwFLQu6rc7PWneHwxgAIq/jDZkxXbws42ikZ75gh4rlLfUEV2TtIsMJNOXaaZOr1p
	+zsSRz0iQE2/EG9LXFvhHsjmN4k6OjkuqNU6Au/+nk+5bMCDwY86PzWUzTbeN+MSNResuT
	HXd1rCnN8MYEsFqHEalGE9Jdyg1b9CE=
Date: Thu, 23 Oct 2025 14:35:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761255314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ErOQJZYuBYGdBpUlkz7xxYDD/7HNDrO9In4Qqb0EuxE=;
	b=js3riS21e66az6Tr38Wp8ZB1PttEvYubbxImrS9U11/r3WOoOSUygYo+4HZmx20Bia1XmG
	vY2PhoZc1GDaXnexuFX7GVOQy1zV1Cf8mfxBbuf7LWncUCkny89N7J8htGD88NU1E/0i8r
	qzsKb/PlZx3RailoFTTtJ6clPPEAe0w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: manually uninline __memcg_memory_event
Message-ID: <jnzfiyojjwvrj3eemqmpigfyjxucdqe44fjy36nxkly6urtn7u@a6pfcppla3r6>
References: <20251021234425.1885471-1-shakeel.butt@linux.dev>
 <aPorFhxQc7K5iLZc@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPorFhxQc7K5iLZc@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: i9teps7jxq5yt3scekukbc3pn3dbk1ng
X-Rspamd-Queue-Id: 628E816000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761255316-237524
X-HE-Meta: U2FsdGVkX185ENx9l8A6ETSnERcmvNWjwe/NQfyGvRSnBZQkVCeOByOPBs1mB9GxLKQgwGE2gD0TdU/XTKpGgVnZY0u9NhwQwO2Ep9SCERpkURx0L62B4u6mPGGEPmu8uY6BO6CJwMLz+7eJTRLgiCsLQOeVO4bsgAlErj8R1wcfyJR0iwLn+EX0Js7wGJlMJqsi27ypGUDIqjs9VWfSkJyz+czW4hXz/3mvgCjRT3UPP6bO5KMytJx0mtv+xLVdF72UsLbfgcD8NKqLoXeFwsrTBHnoU0z282uU4O0lcf8Hqta9qfPE0zFGHe/bQpGAVzvofeIxuZjqO1lW4WO4gcJSq8JjA7zv7OSXZ2JXgdf0+H7EmWiHxml68SnRmmkZs2cCEOfJzI/5a8RRwHiDE1HTfbPdfCAMHeGzhGjvLKupykM0rDlt8p9VX4G09dQ3d86iC9gojGXLdobSENHy09ksMUbI4Fuz1MN9T2hU8z4nff8Clf9kQyXlWy3AMRSV/ZVF7+19GlnGWBIpNX4rOloTGU+Gc0Lj8sbrNzwJQJFP8qVzwhhi8UcIWtoc2l+JfQOil8ISsnStNkx9PYBv8tG8TyAHWvpPa8h+blmWnism+VPvijpNGNdc/mRc0W+ti9UQood5FkV3J/2mFdX5vWrve5uejgAzYwAZ+MTvz2huP9kvHtpmxKM1UI1c4POLkVd4wzI+J0N3GjTy1COozOQFqC5ka8KDeMkbCQgi4eXoYGcj59o6nopxR/l5G8fxDEHlDHRyh47Ab8N4Wy1HzU1bdI6mflRi0PsnRrQY/Rvedj+WfYpciqRIj+H2x6RroDjAn3bqymLj/33+Acf7dFftpaeu/+gchRrD6qZai4xwPVgdCTScOIyeLtfR4Iy4gXn/WHmNig9mFGDk2s6Ewex3tKEAI+wx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 03:18:14PM +0200, Michal Hocko wrote:
> On Tue 21-10-25 16:44:25, Shakeel Butt wrote:
> > The function __memcg_memory_event has been unnecessarily marked inline
> > even when it is not really performance critical. It is usually called
> > to track extreme conditions. Over the time, it has evolved to include
> > more functionality and inlining it is causing more harm.
> > 
> > Before the patch:
> > $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
> >    text    data     bss     dec     hex filename
> >   35645   10574    4192   50411    c4eb mm/memcontrol.o
> >   54738    1658       0   56396    dc4c net/ipv4/tcp_input.o
> >   34644    1065       0   35709    8b7d net/ipv4/tcp_output.o
> > 
> > After the patch:
> > $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
> >    text    data     bss     dec     hex filename
> >   35137   10446    4192   49775    c26f mm/memcontrol.o
> >   54322    1562       0   55884    da4c net/ipv4/tcp_input.o
> >   34492    1017       0   35509    8ab5 net/ipv4/tcp_output.o
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.

> 
> As the only user is in tree should we make that EXPORT_SYMBOL_GPL
> instead?

I just followed the file convention i.e. all other exports in
memcontrol.c are like that. I would keep this as is unless you have
strong opinion otherwise.

