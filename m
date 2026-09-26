Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B445C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 19:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70486B0088; Sat, 26 Sep 2026 15:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20C56B008A; Sat, 26 Sep 2026 15:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0FBD6B008C; Sat, 26 Sep 2026 15:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4066B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:51:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00E5940907
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:51:43 +0000 (UTC)
X-FDA: 85256958528.06.9D57A8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2384E180004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:51:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hXk79hjY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790452302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfjoZScS9ZOqe44JQfBF8wEPZ+pAl5CDH2L/a4RRcvI=;
	b=Wjxcxg3er0LhvZqASe2eEUEUS1sMYHuQIb0h4mss0CHyVlVtmFX9AlBlhuwt4PQI9s8KO9
	AZMsuGoOGLigyKgtGXMSMVsa7rstlqdev+OZODtHD9zCgYXHYePRhk0BcNCh3adTNutrMp
	9r/aAC8AN3BlhO4lP+feMUf0AUmCzSM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hXk79hjY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790452302;
	b=zsP1Chp/UnF1ZZFFyBDSuqvIl63x369t5ypz58AGuP0+KWVRfyLUZi16pGLzwgwk8C1QyJ
	dc6/aMz4rD+weylKVT/WUKOVRQRnk9ifFB6tY3V2eaa0l+TSbmq8qifIt7cOgRls8UNZ7G
	9vJYRp3+G5WK4Y1bLHfgznnZ6MBmEj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 743C6601FF
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8811F000FF
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790452301;
	bh=dfjoZScS9ZOqe44JQfBF8wEPZ+pAl5CDH2L/a4RRcvI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hXk79hjYpNN/19b5nrcBKIx8dVJ+Msn2Ree7YWck7KvESCgcDzse+0R8GBkYnjmuJ
	 gjBRzkQPySngRT+ONMfxLoCDRumHCzujifJZtz/2aSeIVKieC4CFAZcizSom+LeWu2
	 HHTwunknIC9uRN4TZgLRjSe8LYnNRp3AUa4uEBN+L6ASiI8PQX2myinD4ASn++M8F5
	 lKE7qMOePuS6ve8X1d7J/wq6XPBFZjpy85T7YP+/cFoXkssMUaESPdvzSO150JZ6pn
	 O4AMlk2UHxdNvlwoBIDh1i19tFkjlFKjp2Qc1BuJk3kkhXvh6f2XDrHLctIuqmyrz0
	 po+nmZ20xvMeQ==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2dbbf409b8so81737866b.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:51:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBylWz71S3yy5VdgrrDmP/niwZ1zMFY7CSYWmaajAzVFQ7anyWenrrEX4HUi0FwvTjzIlycVtmZi0Q==@kvack.org
X-Gm-Message-State: AFuF++kPRcL3e4zenzSXxnP0rRdY3J8oSiGODlNmuIf7J8F/wQwM245l
	A2sgliCPw0qwYvbK/+18fFPhJ+wbVwFZwMWnkqZMAujMSfqXwamaszxz60mweLlN1M0DapWc01g
	ayKbNKn4wHnksQ/UZXbWOyrXTzA5lbjLNncTQba/rOQ==
X-Received: by 2002:a17:907:8908:b0:c26:3424:f7df with SMTP id
 a640c23a62f3a-c2ac24d3e8fmr788004566b.30.1790452295952; Sat, 26 Sep 2026
 12:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
 <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com> <CAKEwX=NbD12FfApEb9g+3Gt_-Rmof0tovYZsxPPyk5TCbFq=Lw@mail.gmail.com>
In-Reply-To: <CAKEwX=NbD12FfApEb9g+3Gt_-Rmof0tovYZsxPPyk5TCbFq=Lw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 09:51:24 -1000
X-Gmail-Original-Message-ID: <CACePvbW2rejcNUhK7AG7xLv1C9PmdmdF+uvkV1665BYwG-GNBw@mail.gmail.com>
X-Gm-Features: AclHuK-xpiJYlVPsv444_ENhKedDDd2x3kiC91E8lDWQNSSouldPc5mcq4B4NH8
Message-ID: <CACePvbW2rejcNUhK7AG7xLv1C9PmdmdF+uvkV1665BYwG-GNBw@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2384E180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ath5nthkuzaqjeg566jwopppt5jjsdr6
X-HE-Tag: 1790452301-580922
X-HE-Meta: U2FsdGVkX18yYfLw4k1MCwIsWq62RCxNgLu53AfzI20EQBPALh2bGQKJpUaknvmsZ8lh7hMDrHi//svYQVf4y8r7YOd5eMm4nyQa3RHRkL1BbB9O1ORyUVuGThnCJEau3nw87y+xj1cXPpcm9UU5vYvg22chwGJkUj2z1FAacrot983LJ2de6FnnyxxeT1bmIx8SyEt1jnM8oOj2VJu5jeLKtLBf7d0RGOsgTI5LSH6CCeL3gQK5wCgng9SnEP9OPfNAqB7ycr29HABb0Jta6qJIBs+nEk55oLkhMmRoPSkECHkema5L64nzzjzo2stKA/y2BeWxDkdoqTh1gO/NCFQCGzZaVEgtWBITkwgSKlYytbDWD7AYr/L+jGeXD7W0fq5lEPmk3tfxkyjZUiml0DOVBmA1t04T0VeX41ZOdnYTgfMVAV0zkaGxzpvBpp8n8z9MOVZb/3if0nV6rrnDR1mcp87l1I8oVMH+Jz+0PP4M5/Hz5JBWgwJ+afzO09mcJu2U769I5ClPxVnTmC05HSWbWYlLMDdJ4KPRbcTr9uNxDfygRoNOhBEdwFSQcYUfBiSAKzhWUiEZ0QxlgoU5fUNO3zQLAVdjKzEtq62krDXDNHi+3dUPMOqsjcdJB87tTdDSWoNqEZnRHRNhBml8E8Fb5TNVrvueBAmTqvjE4A68b1zLrdayIZcBEdm3H60iAvghWwpXDUHW7KYzlQ9Y4+0aP8pRUnCsZE6ksp8WILVwC/aB7nLU9xMjxsy58OhTHuVTw9LDvSUHaP4cqH1Exa0g+rscneRxofGMSzufev9BaZQyFYhle6Uam/j9K9tAjrXGUYjsRIQVfwhIG3nd5GuRomaXu4AFOTMHv3tiW/OciuBoWi+17dfm5I5SgwSM7yIHabUv5CU7QX8GYW2gB2npPIvpecp2omDBNfgMUnosJXNY5NXyc9P1vVeldJpu+K+kreXhnNM0bRGJB74
 aeL7YGez
 /caO9mwxcBuF0Yzt9QIYd7SardD9JB+6q5OXHHY1liCm+H62xvxJ9XgFbQRMn18bzACokzdHiNcQCwARnUS+KTMR9ETqj6pCzF0RNe1WHf7pdA6XI4BgyoXVzzmLeqIAoSyzdpHaqt11CqWkR+Jg/Az0+hc5/n6p8o7jqVrYJiCkcQ3lyxFEi+MgKBlLeaWBetRmA5werCtsHc1gSK6fKgRBfxoV+ZWvpYRJxNKwjG5gI0vaHgq86F7qJUGynjNJfN/y3JSXgjFK4qfvNoszADSdE2oWYmaJSXNDvOzRnJMTNhXqS222U1jBf+AIArxQOMBq/fJM42xtabfftYLuJGUCadg32R3kMy1udXh+LBym8vknLyPjhokuT+XkjMw6gqGO8qIz+/SGCb/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 8:25=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Sep 24, 2026 at 6:17=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Thu, Sep 24, 2026 at 8:13=E2=80=AFAM Rik van Riel <riel@surriel.com>=
 wrote:
> >
> > Yes, but it will pay the price for going through the unnecessary
> > redirection layer always. It incurs performance and meta data
> > overhead. That was one of my previous objections to the earlier vswap
> > version. Sorry I enjoy micro optimization too much, that is both my
> > strength and weakness.
> >
> > >
> > > When everything in vswap, we don't need to test for it.
> > >
> > I've been there and done that, the result was pretty bad in those
> > earlier series.
> >
> > > Handling the details of what's behind the vswap would
> > > be handled one layer down.
> > >
> > > Chris, do you think that would be cleaner?
> >
> > If it can wrap below the swap_ops, it is just priviate inernal dedail
> > of implementing its own indirections. That would be much cleaner. That
> > is what I am trying to pitch to Nhat in prevoius email but does not
> > have following actions.
>
> Registering vswap's operation as into swap_ops isn't too hard. I
> frankly don't see much wins to it for vswap itself, but it's not hard
> to do if you like it.

I am offering these as ways to move forward with vswap. There is
always the alternaive to use xswap instead.

>
> What I'm disagreeing is treating it as "just another swap device". The
> implementation shares a lot of swap device's machinery, so I have
> don't mind adopting it, but you can't treat it like a normal swap
> device, and expose it to userspace like one. You get issues with
> allocations internally, and externally you give userspace a vector to
> misconfigure with device priority.

I'd like to hear more about this. If a user wants to shoot themselves
in the foot. My philosophy is just let them. It is not worthwhile to
complicate the code path. We can add a big fat warning that
"Oh, you are configuring xswap with a priority other than the
recommended one." But if the user really wants to do it, we should
allow it.

Another use case is when users employ more than one swap device to
reduce swap device lock contention. It is not a big deal when you swap
out a few GB of memory. But if you swap out more than 100G of memory,
the swap device lock contention really shows up in the earlier version
of the swap core. The new swap allocator and swap table significantly
reduce that contention. But that contention still exists. A few
hundred G of memory under one lock is just a bit too much. I think
there is a legitimate reason to use more than one device to reduce
lock contention.

Granted, other ways exist to reduce lock contention, but they increase
code complexity as well. The current swap device design is a good
balance of code complexity and flexibility.

> That's why I've been insisting on what's the use case that motivates
> these aspects of the interface that you're interested in. A pretty
> design is not a real usecase, especially one that creates problems
> with userspace misconfigurations.

Points taken; this isn't enough to justify the extra maintenance and
complexity of vswap right now. A cleaner alternative exists with less
complexity overhead.

Chris

