Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E5FCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F138E000F; Mon, 22 Sep 2025 19:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806FD8E0001; Mon, 22 Sep 2025 19:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743888E000F; Mon, 22 Sep 2025 19:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6581C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:55:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1273311926A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:55:14 +0000 (UTC)
X-FDA: 83918544948.28.2047F97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 48EDD80008
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:55:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QodwpJl8;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758585312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sROAbG/oi7+CFkW3lPDrCTRoOB+OpbeSi5VqV+IIog=;
	b=07ZaC+4/TAaq/UBfeTL9rC04YUOhnf12tAlyDDnp+pchd6FCkqONolsJ+2H7bNKbEr4OpK
	mcI54gf1uZ6Fx4RKOSgewI2v3zV9zRTn2JfoWLepp/LjoGobwBT+Fx30dFg2Lk27rPeNS0
	cIaqyVy9pUI/PZwUXGQjCUb2QRE3IS4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QodwpJl8;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758585312; a=rsa-sha256;
	cv=none;
	b=JXHo+HW0PicwlMT3kEciqX+Hhny/rnXD/tGM/WLnLabRvtsKRooSOZD7iwudg7ABddARyB
	2QhTwjxRWEI+fs1OKKQDTI8sHgtlCINmYoZ3GPshcH5ugBHwjefSBBeTwr2ht8Xz1coAlX
	TfDCrLsa8dhQEhy5sz+ThKaNYoUTmJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF01E440B3;
	Mon, 22 Sep 2025 23:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4220C4CEF0;
	Mon, 22 Sep 2025 23:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758585310;
	bh=GUUIv/PzkqvPIBWCrFcZLWsQWgOY8kSV/evTaZnYusU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QodwpJl8LgA0tAs/Ed4XU6lKjkVzRkPVTn1mvkR2m700vx+dg/C36CMq5EA430M8j
	 NFeO6/Xy2OpKGxh1br3FuHqcjlxhm4YjqqjYErMdYpUEcrYss0BHlgCklJoyJWmHV8
	 9ClCI0kaA6W4SSO1tML+maH2YGRDO4KUh/IlOcXE=
Date: Mon, 22 Sep 2025 16:55:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Meta kernel team
 <kernel-team@meta.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not
 allowed
Message-Id: <20250922165509.3fe07892054bb9e149e7cc06@linux-foundation.org>
In-Reply-To: <552lz3qxc3z45r446rfndi7gx6nsht5iuhrhaszljofka2zrfs@odxfnm2blgdd>
References: <20250922220203.261714-1-shakeel.butt@linux.dev>
	<20250922160443.f48bb14e2d055e6e954cd874@linux-foundation.org>
	<552lz3qxc3z45r446rfndi7gx6nsht5iuhrhaszljofka2zrfs@odxfnm2blgdd>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 48EDD80008
X-Rspamd-Server: rspam05
X-Stat-Signature: dwi6ee47d17xdh3g74j79ezjdjbaf1hg
X-Rspam-User: 
X-HE-Tag: 1758585312-889973
X-HE-Meta: U2FsdGVkX18ShW6QJyju7SaFYqr9gXLVAEvi6GYacJS3mPcySeNZvWkhyf7qQzCBPqn37p3Au2KVrCEikoDqj9pJxUWr07ErdbeJY++LwNQ+CQgZ4xqsEV1klMhMnam8naG73HyfvHOxVQj07e44NXIRRxmpTQ+DOqPk2bWzJfx/XWic6mYFZYlVgLppCfR+a+HSu+RukHePitKSKzcvgcoesMnTBItQ7OErSUYCIcYK5crEwDhk60KJkZEUjtE18Ul0km2MBCuZPc2/MZ/Mth5Dk3+pv3qR3dBEoi+ApKPrMnFf+0RC7LwFgg8ZwcF04mieQSkbevEsTCEXkqPeDXCjxSaZYYsTFG4TH90lk/2FG9r2TMdj7FOCSZ1YO2tzArFPYGfAizW/PPMrc1or8r3ulXMkgfuf6V3lEyP44wfK5pNIoXcUXPhtWkvGU93jFdfILK80dorC/JqSY+m9/TQ7JWHbdhPLVDWkj9mGjO8mI3WE2yvUqPKtj3o2nf7dsvoWVLAfTje7veIYxBavr/zyORMqgJueGmKQwr6ZGkiiQutST1hvMEmRhroskICmwOkU00j4Q7KnAvt22kJNXearpZ/rPhs47hSbJxFrDslKHv0cWSue36rATvYk+JMnN6NgFfVlahLC0qxTYxmK9BJa6jseWVZ/dv7JKJMsz51vSvXTnq29Xh3lNu2DhTIlDY9KP2ZWBkHFe+sdZ6S8AkPlknCFvNbpt/CLVkQqGjsGsfNoyZxLk4X5zbw4vjFkRkLrFHlZH2U979cL3C7ssdeJvyps9BkhJBBrTIme7kQofMgQfLgzTxTi6TMs1CfCGWbhkX9W7LldYbLvmi1GKosCV1yDZit+V2ZulhB30TNjPNF8Y8jYhdiUNbexXDcvSmsD9PFoHA4g6gKJlIEHbO8nog/TvU12DOT11MDKIZ2SOnmwGkneCxZRNO70xG5Snq/jAyzyK7Qd4P2dpsi
 nhDVtSuM
 ZWE1EqYlCTXESU0wB8zwE53dRLAW7PNPO8KjfIZG1km09c2jWOEB+ZPdLQ4q3DpqOJ+SzUdamnaj1/YV00yOOFOjUPRSE+ZUlFCnLfKNT9pLyI4iLCOc6F25Jr8Z9zUPmzaUatvfKcyfSB8ooT5aDqTqh2evaCTQpG46n8v7KdtplxQz9iqHARGqr186Yns7U28ZkseGd67zZ3yNzhsoL3l2gM+YrZ6uvAjHJ4rBbfDDuml84S0yll3nzDFCJ/M1nKHz0ZjgNYdc1hI7GRootDo6ZB1vXZtFstxvE5pTxdeKQzrgjTz2CO+8wZgPrHDGIdWEoQ18iFKW/SeXFij022azwgTWvW94u4FRse8D07SKinLeCk2ZwPw7kB3jV8L4iJF1vOudVW1oJl9d6AwhJrEC2Qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 16:39:53 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Mon, Sep 22, 2025 at 04:04:43PM -0700, Andrew Morton wrote:
> > On Mon, 22 Sep 2025 15:02:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > > Generally memcg charging is allowed from all the contexts including NMI
> > > where even spinning on spinlock can cause locking issues. However one
> > > call chain was missed during the addition of memcg charging from any
> > > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > > cgroup_file_notify().
> > > 
> > > The possible function call tree under cgroup_file_notify() can acquire
> > > many different spin locks in spinning mode. Some of them are
> > > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > > just skip cgroup_file_notify() from memcg charging if the context does
> > > not allow spinning.
> > > 
> > > Alternative approach was also explored where instead of skipping
> > > cgroup_file_notify(), we defer the memcg event processing to irq_work
> > > [1]. However it adds complexity and it was decided to keep things simple
> > > until we need more memcg events with !allow_spinning requirement.
> > > 
> > > Link: https://lore.kernel.org/all/5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd/ [1]
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Acked-by: Michal Hocko <mhocko@suse.com>
> > 
> > Fixes a possible kernel deadlock, yes?
> > 
> > Is a cc:stable appropriate and can we identify a Fixes: target?
> > 
> > Thanks.
> > 
> > (Did it ever generate lockdep warnings?)
> 
> The report is here:
> https://lore.kernel.org/all/20250905061919.439648-1-yepeilin@google.com/
> 
> I am not sure about the Fixes tag though or more like which one to put
> in the Fixes as we recently started supporting memcg charging for NMI
> context or allowing bpf programs to do memcg charged allocations in
> recursive context (see the above report for this recursive call chain).
> There is no single commit which can be blamed here.

I tend to view the Fixes: as us suggesting which kernel versions should
be patched.  I'm suspecting that's 6.16+, so using the final relevant
patch in that release as a Fixes: target would work.


