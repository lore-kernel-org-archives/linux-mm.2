Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74219CD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 01:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C68D6B0088; Tue,  2 Jun 2026 21:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977C56B008A; Tue,  2 Jun 2026 21:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D706B008C; Tue,  2 Jun 2026 21:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 762AA6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:48:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E2CC401D2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:48:53 +0000 (UTC)
X-FDA: 84836917746.25.3AB7B22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7254420004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:48:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeEi5+CS;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780451331;
	b=jbeyxVOG0dWgJ11/kxkOU5zV2pM/upT7fdLBWKHtycMoaebBaLz4XVARepxXRfdUjHC8Uo
	eAAU/EOdoxof6Awadak5vwUpy9TjdLft7bAgYcLimNL5PLlws6uUA1pzpg6doiZvkgXoo0
	QskQeEenB/EEiiB0c0jNd9j4A++BOEU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeEi5+CS;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780451331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYGrk2aHBiiXWhM3IGNiUFXlkm290VxyZC1ZHOCt5Qs=;
	b=F6wNi7snFkUtN2BRvtQJfp2gsSU05iVgFBUAcV/Asm9tJf7TTrzMVX1uxxR5yDUZhO71+4
	Pb3BYM7WafnU16XCo0TESH1JaIhljKDcU84cT/9aTeUVhIZQ9edC8uSYxuYL/lqQJxjQzU
	NJgvyBFyhh2UjumsJD/vmeUPrX0gF6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 769C140586;
	Wed,  3 Jun 2026 01:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92D81F00898;
	Wed,  3 Jun 2026 01:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780451330;
	bh=cYGrk2aHBiiXWhM3IGNiUFXlkm290VxyZC1ZHOCt5Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeEi5+CSh4X3UBeZ7lWep7Vk5L5UKIw5mYMWzDbWplkfmgOcW6Fjf7k9xD9oWISwU
	 qTtOjmh0+bUkSS5rZZeWb5axYsgOcIfsVMbZlPSzxywJGktJHJr6GzgmAHZUwW33I1
	 QfYlIIK3nFfFxFCaHS4MmBFUvsFMIKez5V30+IFTo+k2fTnptUaCZH3gtcWCl2w/dr
	 JXr52HpvGiomrb9OR35TOiGPM3RVnczGiMmRM3xrUuHQYSc8LX0DHlX1jZZY7rZ8XJ
	 iX1UnCwR6tADFDb+C9m83TkAoQ5bEp3o0Ze6sw8WmST9hrnVp2VSERHgAHThXDAOSR
	 trS6ibkCyxN2g==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <npache@redhat.com>,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	vbabka@suse.cz,
	willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP) collapse support
Date: Tue,  2 Jun 2026 18:48:40 -0700
Message-ID: <20260603014841.90322-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <58b45d62-37b3-4006-b738-08992f502b58@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7254420004
X-Stat-Signature: bcgw65wwytboezwn7xpcqtenmkmbs4p3
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780451331-460408
X-HE-Meta: U2FsdGVkX197ieNRsaSVlcmMhu4yUhOWa0ZVHdOZoaGjE1x7wNi+ZYvqASSBpXOZmEARw+7dC2I6oslo6gKH+uZ+klU1DmtP2xRyXq6Pc2Akuxf2yR2qRpYnB0VYxJOXMChqbuJMp0U0xbbXXVh1z5fLa7ym3xo8OzhAitgh0TXDztmwnddBq2UA9nxU3phrYvBr45LCqK1YTMkhIEwV9bB/du3nIfTn1WlckS1GeONPrWv+N+XvM6wWIexE2spiUDGbDlKJA7ryko6RCesoRrENUVD+ws4ZQJPtjuNthqxz9xfuhs2qKehImmKQlpGDmo+b3WsQicQKoLpJ8YB+i5P34XfP/OvYHRZCr7knLml1Q58Je2HeaJbayXbEL9KvdXug/ua4tmt314EBKWdtsM6RuClsLiMoiBYVYPBivx4v1+V3fDYJuWfuIia4gfgZIVE6tfMfZEmlFzfEdFgxqdPFkTztE61p9XbJ/MDfCgelbOif7txYYzJ5N5oC6o6pEGKaQoq1nTIbMDZUVxxM6D3FIA9gn+eb9QQqAsmRJqxAYMrTGOKaxxmH+V8XreJ8Tw5uyCoLxbahAmDLDq5W9nGQyGZRkToLgbsgoXMvb8qNUNVG3Rwich3oiSjhjfezxDT0TtYH3RHrPrsv6u6ORNTHgpSwESfPv7uS+BRPlFohs1giIsF+6m7lwHmFDgF3h29WZjv40+NUE8ByUPhfBG+RUEFd4P1UMTrOMhFSHWlXdRXnOiLt9pd+V/Wrh7LL9mpIu066unV5beUtG48OKnAyeT34W5qbCLDeB62xsisaLA/BLnHeNH5qVg5dQxHmwUlVP2cfkPdNNxxQ9ig8q8GuM+tDXUwznD9wf1au0l5YHkuhQiooGffE22lpLIn90w0wRY/thw8qf3xoieTDmgJEAiirqcibb/zTylmOAjWiUfVsGtk0hvSGP7xXagaf0cvVlRBLJDtMSt/PwwZ
 E3CJ/yV6
 7lbCj0ZaM18wpttGSf1CHi1C+/zkt4azIPhBQfn8Kry1iiUFr535r7JnAOI/3BNqluWQ+pwNSAkIe1IHrueeJxj9BwsaUam1bcMegOwsbr3VImvy3yc2XiaxLwG1abGRTZz/1DvEQ6Jbo7XCQL/3dNGiTJR3eTfIzyx+fLdn+4l9i9c7LX8S+HOinynATqEcmYUUsCVRHnyy4Vof8Vw+qQIbF3Rs+7HUV8QQWGD/2/mg466A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Jun 2026 15:16:27 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 6/2/26 15:08, Vlastimil Babka (SUSE) wrote:
> > On 6/2/26 14:58, David Hildenbrand (Arm) wrote:
> >> On 6/2/26 14:47, Vlastimil Babka (SUSE) wrote:
> >>>
> >>> The problem is that the patches would not be applied on top of the
> >>> integration tree, so it doesn't make sense to base them on it in the first
> >>> place. Unless they target the next cycle, where the integration tree would
> >>> first become part of rc1, which would be the new base for all the
> >>> submaintainer trees.
> >> Why does that matter?
> > 
> > Well, as longs as there are no conflicts, it probably doesn't.
> 
> Yes.
> 
> > 
> >> For example, the slab-next tree gets merged into the mm-next tree. Submitter
> >> will send against mm-next.
> >>
> >> The slab maintainer will cherry-pick the patches on top of slab-next. From where
> >> they end up in mm-next.
> > 
> > Note slab-next itself might be a collection of topic branches and it might
> > be more flexible to create another topic branch (based on rc1) and merge it,
> > than apply stuff on top of a product of merging.
> 
> Right, and I assume that the maintainer would then either try to fix it up
> himself, or ask the submitter to base against a specific branch. (e.g., against
> another topic branch etc).

So I understand we agree we will allow peoplee to base their patches on
whatever makes sense.  I like this flexibility.  The slight difference I show
is that David suggests to use mm-next as the default baseline, and later rebase
on subcomponent tree if needed.  Meanwhile, some subcomponent maintainers think
the opposite direction make sense.  Submitter use the appropriate subcomponent
maintainer-suggested tree as the default, and the submaintainers handle merge
conflicts of their for-mm-next branch.

I think both could work, and we will learn from trying.

But from a subcomponent maintainer's persepctive, I was thnking our process
will be more like the second approach.  And I still slightly feeling that will
be simpler for at least a subcomponent maintainer.  Why I feel so is like
below.

In the first approach, as Vlastimil and David described already, there are
chances of conflicts at picking mm-next based submitter's patch on subcomponent
tree.  How frequenct and complex the conflicts will be is questionable.  But it
feels like I will have to deal it with submitters.  E.g., asking rebase to
submitters, like David mentioned.  I think some of submitters might not very
familiar with git and the mm process, so I feel it might be not very simple
always.

In the second appraoch, I expect less chances of conflicts when picking
submitter patches on subcomponent trees.  The subcomponent maintainer will
still get conflicts with mm-next and have to fix it.  But in this case, the
subcomponent maintainer will be able to do that nearly alone.  Or, they will
work with the mm-next maintainer and/or other subcomponent maintainers.  I
pretty suree the other maintainers will be familiar with git and the process.
So I expect less headaches.  Also, this kind of conflict resolving between
subcomponent maintainer and mm-next trees is samely required for the first
approach, anyway.

mm-next maintainer's perspective might see many different things, though.  I
will be more than glad to be learn what I'm missing and get enlightened.

Anyway I think both approaches may work, and we can learn from others and
trying on our own.  I will be happy to help when there is something that I can
help. :)


Thanks,
SJ

[...]

