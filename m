Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6504CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244116B008A; Thu,  4 Jun 2026 10:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5646B008C; Thu,  4 Jun 2026 10:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B8C6B0092; Thu,  4 Jun 2026 10:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0F0B6B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:01:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99FE11206CE
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:01:40 +0000 (UTC)
X-FDA: 84842393160.17.C3411C1
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 363E2160034
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:01:31 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780581691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+zIBXCKO/oX06loH2iD7dO3/BmxxF4yAbeS+B4E8Lg=;
	b=fTZJ3jcTePv/aQlEdDzJzf1+AHm5WHFtZWs6v5RA+qbgSBR4slVx1dQf4HVoDgsQ6naXhi
	roTOqk1EDJC/ox2Ajef8Sz1tDxfN1HTZsUA6GSTPVPgCM/enUIYAUQbiCidyv/g6A5BIuh
	dL6kWcnmSAWxHhhz/Z7gOylb1Ggwnik=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NEv7KS8Y;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780581691;
	b=Iyrc+bFTMLw4YWbESA3oOl4mbDaGgZQQnST8sRfKAln8U1vTtKT4muukaKe3Bue85uirQY
	X44O6GV8KnjJEYMAahncZMtRLS5uc5MuNPLmSj4FnDjozFly5jdC1++rbTM4vUQIPipd15
	3tYZ7qADMYkindQwx/IykRNKFFIHhwo=
Date: Thu, 4 Jun 2026 07:01:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780581689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h+zIBXCKO/oX06loH2iD7dO3/BmxxF4yAbeS+B4E8Lg=;
	b=NEv7KS8Yk6sEcTFnudCS+03flc8fd1Ov7H+pai87DuvhwhTi+GLWSGYyP6kB5H3T2D6G7n
	3WmHH/0OXnVuXJYNQu6HNgP4LQGRDUZcLnvmnFFsNQpPYy9dU9M50WFmf80DzRdIZMflar
	4XqR/KLhCaWRwIemjSaxlpQMfRUJLPc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aiGFEQE5Vsw5XAtB@linux.dev>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
 <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-HE-Tag: 1780581691-742935
X-HE-Meta: U2FsdGVkX1+SvOWubH70LFDFq7x9di3hsL1nUVlsoyI9nspKHdgPZNMnKF3xuvYjdKcgRbZeWCnND6k4YUCBnoFgrrmF4orM7fB5TrE2Kj9+GHEgp0w8doIPRiQnmk4bza7gYvo6gSww/nmEe9liUqC3GEBE2KdASNyesEd0uxjxdW2ld0TLUMPecSAEgnLU5L5YE0XFZkLopQrSMqmOzRYFB/Sd+PEk1ADuEOhxQzJwKTzvDZeNvwFSHHi0pDnGBGMm0XO8CeqJwHuAsnQ4jv0tomGoFK1QyWSwpjmTrVnthUkvS8Xt/g6lWVKpYDE5s11RWfeseFFKw10Zg8I9daWtpVwJqJ976rFRYmJv/GRtSJ9+X4hTetcvtsUIuiTd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:36:07PM -0700, Yosry Ahmed wrote:
> > >> But doesn't it make more sense to specify the compressed size, which is
> > >> ultimately the amount of memory you actually want to reclaim.
> > >>
> > >
> > > I personally prefer compressed size to pre-compressed size. That's
> > > kinda what user cares about, no?
> > >
> > > One thing we can do is let users prescribe a compressed size, but
> > > internally, we can multiply that by the average compression ratio.
> > > That gives us a guesstimate of how many pages we need to reclaim, and
> > > you can follow the rest of your implementation as is (perhaps with
> > > short-circuit when we reach the goal with fewer pages reclaimed).
> >
> > Got it. I will change it to use the compressed size in the next version.
> >
> > Yosry, Nhat, should we continue using the zswap_writeback_only key to
> > trigger proactive writeback?
> 
> I *really* want the memcg maintainers to chime in here, it's
> ultimately their call.
> 
> Michal? Johannes? Shakeel? Roman? Anyone? :D

Sorry for the delay, I will take a look in a day or two.

