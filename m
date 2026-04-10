Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E815DF44868
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A726B00AA; Fri, 10 Apr 2026 09:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551886B00AB; Fri, 10 Apr 2026 09:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F166B00AD; Fri, 10 Apr 2026 09:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36CDD6B00AA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:50:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B00578BEFB
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:50:27 +0000 (UTC)
X-FDA: 84642780894.06.3190CCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48ACDC000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:50:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GPqER8zB;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829026; a=rsa-sha256;
	cv=none;
	b=7KZQjKIpHIRezQs5yYOag5hT8gxr30scULwK0ybI5DGY+XfZYScAefQe/DqKy/qdE4oqEn
	hKUyswchbegX3BP2/9crhK+4gcScj1e5/hOaVjDtKfADdYDAJGtuv8WmC8RHtxEyArN+km
	IlHv7qf16JhYP7tmC8qjKVguULCYu/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39NAX6pobMDiRW03bJAv0Hw/rcf7l7+Va+PozAyLXsE=;
	b=zLHR8UegCx+RVC5STM5QXVwLf2mmtBTAigEuEA9DaMBjRaiwhBhjncL/amTQTCJowbzqDh
	bFngnjBBNmIxYQSt9A7UmJuY4qbyO5+esu/CWp0FUv1eSL4JeLJlG3JImJWZkyn2Rla9te
	fhMoiEKpq9y1b8Fqc0oP5uLgPmCByWY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GPqER8zB;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53EA26024D;
	Fri, 10 Apr 2026 13:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53559C19425;
	Fri, 10 Apr 2026 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775829025;
	bh=39NAX6pobMDiRW03bJAv0Hw/rcf7l7+Va+PozAyLXsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GPqER8zBALj1mdN+bTW+ENjK3Iz9tCxXSiON1IrcWMBqckqHOkL8gmJsZHFDpoSn3
	 fNnkNhnuM8YALPABGCBGy1pGA3Enr10HET+x/Id1HYgTr9mx/LOETSJmhxv0gYAGug
	 uUPS20jrknJe95xMg9xHnK4DfOg6cHnr4oAgLSJPSYAxGvd1jsK7ROVuYyMsTxCE/v
	 cVyf89R3C32BrRXnmutnmp/+5Z35DNV3USKJol8er2b/ZJcfGJ+QIngV6CVQWKmw+e
	 1glwA8bGhawBmt7WXCthBv4XrTFKn8hGxRGo7w4aCbqGZJsaZOcatLYCgiHmhrWemJ
	 HT08plIvK5jhA==
Date: Fri, 10 Apr 2026 14:50:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, willy@infradead.org, ryan.roberts@arm.com, 
	linux-mm@kvack.org, r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org, 
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org, kevin.brodsky@arm.com, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com, 
	pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, 
	Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, 
	shakeel.butt@linux.dev, leitao@debian.org, kernel-team@meta.com
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Message-ID: <adj_SXXEwyi3bxum@lucifer>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev>
 <adjkCOiLgZ_-zovg@lucifer>
 <adjllNan2vgBNBHJ@lucifer>
 <5f99b289-629c-47c4-bef0-966d6678a2a8@linux.dev>
 <adjrKwgiZwXR9epk@lucifer>
 <40f31e5a-7161-4b17-af03-52b3a28a113e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f31e5a-7161-4b17-af03-52b3a28a113e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48ACDC000E
X-Stat-Signature: gtj8begqi9j1pz7ma15sdn4eru8hs8hb
X-HE-Tag: 1775829026-762778
X-HE-Meta: U2FsdGVkX19X6oJN0ChKno5zGO2m3naQhKQ58QWRz6hPP3piYwYM/1Ncs3kCabq2jWAvOFoGf4OhjqwrKEYBA97/I4VCkdQXfwaanc89DZ+jOougtJbyf+pBQQX+5HvgIucma62bdx3ZgvaOrf+tG1oOm1QyURDZ2D4SazmFBxyJ5ZsIopB4HulSj9Wl2k7TRPy0XOkswpIgd0gRoMDRtWvHCPin1c/WPWGf+pzjgNVYskAuzXuoF9Rm1HlZGgbej7bmdBwdhnwrIlx9UO8DyiVHP7j+UiJxCUB1K2cKGhBQYZ3jS3C1fbYI0U6J1Xf5FUrGiVoLHRSbkwFRZ/rgOYokQh4zDWDtoMtk56q6EKl3M7F4Tknz2Sqnh26RihA18uBQxPS1gtPArn3Oh+KuUap10ADXaB+x3vbUi22H6GHSuFIKpur4yrIFz5PR+X4BQo9K3DTrMbrWs/SvrWNReVywh8KuOSB6uSyzbBO/uH2OEvJ8NYhr+N/rGAGEVfpI/uy530bSDgXpucfiYrQM2ncqO7/eiSHdoisVxKbzkk+HnnwjYZq+DksU1f3r491FDkPUXJ8L9VZmMlOy5WsDLrPJzTeW2MTr/bTzLMu63yEkLaunYQpiiqMI4DrvKS6qnGyUbhbs8q4PmizlywvG/o7Q+T4UP/lUE17rOTdIxwnmdFfB4ne4h3/7VtMTWnreQDqShG3w0OnZ4R6oY2khAC2avUtAGHUC1qrl1l57mXslbac2kERVLusA8fOlCqroWAtcnS+00u4j7BuZHlftW+B7f/mFaRezdJVJaYOPiGM00SU4NduzBuUzO81+63SvDQUQdqFS6Y40U8WE/PTSN/ynvDE+4CjeUq0T54moviBfzKdXj9IERd2x9z1jFoMfBjGbA6I0nYz2yv0cE19nDHhWEYfvY8w/DHslXWgiQSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 03:29:12PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/10/26 14:24, Lorenzo Stoakes wrote:
> > On Fri, Apr 10, 2026 at 01:19:08PM +0100, Usama Arif wrote:
> >> >> Thanks, Lorenzo
> >> >
> >> > (Note that we're in a 'quiet period' from here until -rc1 of next cycle and
> >> > won't be taking anything new until then. We plan to do this from around rc5 or
> >> > rc6 of each cycle in future).
> >>
> >> Thanks! Just wanted to check, as I am always confused about this. Is it ok
> >> to send patches for review for next release at this time? So that they
> >> are in a good state when rc1 comes. I wanted to send PMD swap entries
> >> for review after I am finished testing, but I want them for review for
> >> next release.
> >
> > I think different people have different views on that :)
> >
> > I mean it's debateable whether having a glut of new material on day one of -rc1
> > is preferable to having a bunch come in that might or might not get lost along
> > the way :)
> >
> > I personally feel it'd be better to send during the cycle window rather than
> > before but I suspect others disagree with that!
> >
> > So from your point of view, feel free to do what you like, but maybe David +
> > others would want to chime in with their opinions?
>
> For me the more important part of the quiet period is that patches can't be
> merged, so there's less urgency to review them immediately. So I think it's
> fine to still send patches, but not having expectations about quick
> response, as people might be taking time off.
>
> On the other hand it would be better if new series could mature in this
> quiet period, so there would be less work after rc1. But the key to making
> that possible I think is to feel less urgency/being overwhelmed also in the
> non-quiet period (rc1-rc5/6). Then it's should be less necessary to take
> time off during the quiet period. So hopefully we'll get there through
> involving more reviewers, and by having more submaintainers agency.

Yeah I sympathise with that.

But until we for-sure have <you know what :))> signoff, I worry about the risk
of series 'just being taken' at -rc1 because it maybe seems easier to do that,
and then we have a series from 5 weeks ago you forgot about suddenly crop up.

So I guess the more nuanced take I have is:

Once we have a robust set up end-to-end _that can handle_ having series that are
deferred to next cycle without risk of things getting mixed up - then that makes
sense, yes.

But while there's still a bit of uncertainty around that, then I'd rather not.

But I think if people DO just resend their stuff in -rc1 then we're OK and it
addresses my concerns.

One thing we could do here is to tag series appropriately like:

[PATCH v7.2] 00/42

To make it clear where it's intended to head to.

P.S. Having the 'quiet period' REALLY REALLY helps. So thanks for that Andrew!

>
> Vlastimil

Thanks, Lorenzo

