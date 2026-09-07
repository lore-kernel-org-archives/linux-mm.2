Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336F7C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551FB6B009E; Mon,  7 Sep 2026 08:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503EB6B009F; Mon,  7 Sep 2026 08:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4166B00A0; Mon,  7 Sep 2026 08:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4226B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:33:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE38580152
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:33:58 +0000 (UTC)
X-FDA: 85186908156.06.BD24929
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id F27F940013
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:33:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AHJmmyOp;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7cKBm7+BzUzCvCkEH7tyBUTdRm4vS9wwDEbS3sNZuE=;
	b=zzaOvEZotqCVE91cdLR1uHGoci/c6F1QtJUbqMZqQuNv3dw5SldtsstTa0feU2IQavjKLk
	Tw9trCz8ZZN2ZYYVX9zJ/iwsbJhtxFtEyVGdErZuun5zPqe7K07YvUhZIUlNreQGleWRwl
	AzIpBGkunAEydkiY2mMzcOlGE1MNiAo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784437;
	b=Y3gZ8b2ZgnL+hjZ40hsprqGr+j8ET4s9J8ctWPETIyhPd4wtpkiC5oKCz63yK0QBROCnG/
	Pbbh2ZXVDli5mH31dP9EHz4yS4xbEZ6yakF+aoAkCuxwGDwjgjzBwOAbNEe8/A3tcuAWXu
	udWKzVor+H28onXVLvjo3syEvZO0WWI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AHJmmyOp;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 506D642337;
	Mon,  7 Sep 2026 12:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDA01F00A3E;
	Mon,  7 Sep 2026 12:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784436;
	bh=h7cKBm7+BzUzCvCkEH7tyBUTdRm4vS9wwDEbS3sNZuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AHJmmyOpiwExIz4vREZk9fQD+t6Q8jCuI00q/MyLSuDZHHaQBS4ygHbC7AtSWZQ8T
	 J2FVEopbouH1yFG1kPLeu0k0diRmQDZIC537aX83zKcO1lQ4juKPm00ZLTrFX1Cjy2
	 BNPfO+W+r/r1dBaIdJEkakAPZebE7tbiNCxeXG6GFUL3KlPDkLcKZYSFCBW5dWfDtt
	 sOkDMNIFcoEzc+bj0u2OQ+9hmXrMAak1hJc1br0aFcvLkChengGjrWQh/peJX1SKTE
	 aMWSeREzzHNLg+WYLTLtDgI42cJmb4uEgWccSuQnAepxBPJY5lQZ4lsWoeR/CMPVR4
	 GydJS25pRlFqA==
Date: Mon, 7 Sep 2026 13:33:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Message-ID: <ap6vCPHUIt3Es7ko@gremlin>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
 <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net>
 <aprjOxDy3JCPb2oa@gremlin>
 <5930324d-8252-42e1-ad50-aab796e41550@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5930324d-8252-42e1-ad50-aab796e41550@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F27F940013
X-Stat-Signature: stwswwrrnbfy95jhjfn7n3u4u3uctrtz
X-HE-Tag: 1788784436-1229
X-HE-Meta: U2FsdGVkX1/C1kWtO/ZiMKWZp102axv4WY87MhTr3CIio2ZUXNmpOXl0awYqM2ZHOpmOKMJILNb5DkMFspqrkqxQqk36TnltvCHfVbVuhTPJL9cXxC1eUSEojQiVpOgRTU5Tx4wmugq+D+PJyA8SKIMsurQUMhQop7J0uX1/RchdAQIuB0f6u2CyQUb2Ycb1XgeK7gQWzfS7EpMqaNur/kK/XSv5Dq5xxPAXA1Pf3q0epze7fgpgS1zGZ5r1il08kfkoaqWZ3I0evyE/AfmLT4uSD1jeywuoUGBgJpmGnKabyBGcrNG+MoIWWlIp8apgiAvHUDEq0Y8XkkUWPvcYGk7D2tEZ8dc+Kurhuyn716qWwkqCCLvB8DtFPxrP+Dr2iU6tNHr/hARmIlt2ha85pg6OzaN8R4KMDDMZp6jD2JIbM06qbQ+e4isrccvxiMUdzze21mev748BLtcRFvp537MqkOpHB2l7O4Ovc6YOD0RiCQJ95fNi4vx9uf1SGofwfh4CUNLBGOwzrt+SKdQ5xXSN2O9gkjaElQgYpZCIMPgH9l8+ReyINoZ/Eheu6L8sE6pkXQIggIWvKgy6VQ6dpjFg3YeBAdXkpBBEMGkdmGKW0xtoSSM2k/ac79UahhuDxBdrxlmHp34KPO0sLijyli/esBu9E4G0z+CArL5ik6h3SkRwIrGGo5Dp4JVJeJSHd94NO4JdOkD4eeFiuoCe0Mc4wjEa0ku5A5B/iPflxS/9LLC8SGpuJLx223hXlDe903TnVB2OPiS9Ox4WBrEdVROVRXW7iZLtxhcePo7d9Rm71FsNJrQodU1ogWfO4CUb6yLp/X3no0GbeXTnCk4OHYrmoMX0gin8ooWm4RI9IGx7OV9OkBha5khwksqZOhQijzxuasyKKappedPDP2kI8InXPCZDuRJCq+avquQzvt2gMR75zehvil/6mRWI3Q4ic/nBx5R4AmyUp/5urdU
 qVoBneKT
 xYgE+ibhQr/ctxOJD5fhYgkzaCT02rmMH7l06fvqTsciftC5itaQ2qfVde8kqSoSIBqzMITUpwrnROaIxWpbgBjzGT5vFJQjI2yWXyHyejmdJn3YDG96IAOfUm1rNA5OoEdErVaKe0iSczAcEf6c7nGFQUntCQLOOLb7MI52PWm5kuhFGOl5JivtzSOqvMdede7awNd3T13MhOXvUweroVvRi1Ylj8TLQ43U/c7PYhgUCg1dQMV3XiUQYkw7gYggS7pB7OBr5DpsbP/ztEd+PdvZnMWRMSTCthbUStSRaS82sI0dJ0TqKvXSb4cL3iaSyz/zeavE6gaGe1zbWHmhOEK0kofDMy55inXFg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 01:51:20PM +0200, David Hildenbrand (Arm) wrote:
> > And it's a real improvement to have unfaulted anon skip...
> >
> > But I find that version is documenting what's going on a lot less.
> >
> > Since both anon and MAP_PRIVATE file-backed are CoW mappings we could just
> > reference that.
> >
> > Andrew - could you swap the patch out in-place with below? Thanks!
>
> A proper v2 would have been nice ;)
>
> (and would trigger sashiko and friends properly)

Ack, though it's kinda obviously functionally equivalent (or so I felt :P).

I had a local LLM check it FWIW.

>
> >
> > Cheers, Lorenzo
> >
> > ----8<----
> > From a706374a1186b6b4409a0e760e8728bcadba0c96 Mon Sep 17 00:00:00 2001
> > From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> > Date: Thu, 3 Sep 2026 20:08:39 +0100
> > Subject: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
> >  MADV_WILLNEED
> >
> > Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> > entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> > for the former and a tree walk and swap in to swap cache for the latter.
> >
> > MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> > as if they were purely file-backed, meaning any swapped out private pages
> > remain swapped out.
> >
> > Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> > mappings and performing both walks in this case.
> >
> > Since the logic checks for vma->anon_vma this means un-CoW'd
> > MAP_PRIVATE-file backed mappings retain only the single file walk.
> >
> > Reported-by: Mike Kaplinskiy <mike@recall.ai>
> > Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/madvise.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 73c2901b9adb..963337f93a7a 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -297,11 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
> >  	loff_t offset;
> >
> >  #ifdef CONFIG_SWAP
> > -	if (!file) {
> > +	if (vma_is_cow_mapping(vma) && vma->anon_vma) {
> >  		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
> >  		lru_add_drain(); /* Push any new pages onto the LRU now */
> > -		return 0;
> >  	}
> > +	if (!file)
> > +		return 0;
> >
> LGTM
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

