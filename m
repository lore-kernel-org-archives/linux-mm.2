Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AB6C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070856B009D; Tue,  7 Jul 2026 14:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047C96B009E; Tue,  7 Jul 2026 14:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9EC36B009F; Tue,  7 Jul 2026 14:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FFDD6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:46:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23F2B1C80A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:46:44 +0000 (UTC)
X-FDA: 84962861928.06.799A300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76456100006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:46:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q2kwS1vQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783450002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnzAVuFS/1c1f8/sGeVM6EqLbn2q6aov1CaEXTJphiw=;
	b=oV4TfYyO+WouZ6st1fSky8pTX7n6p/h3kLasr8L+u3mBXMf4G1Q++cctW6abrb2tU/lON1
	EN8PDvfBSnR3Z2t+r7jvBYYxhE+fWSHi1iAB0jIk1vtn/4sleE0HiFn6qW6neDxKw1M0S7
	EfdGcJq9Pjmcxjk8cw/D4gSmwXDegM8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q2kwS1vQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783450002;
	b=vRXy+9ExK5CqY2zRdDR+toNpuVSmx750nHoIcRe9v4yZeDnUkZvNBLokzu86IjyZofKwq9
	69PlRhdJcBRrYBkmxQOoSCqbQhHL55rW8uDc/nyQI24jdCWqOFsDnhEToyqDpYjfIBJxRF
	/5cIhqxlOVij6BvxEQNMLZ7Pr2v3Y4A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C49DD60018;
	Tue,  7 Jul 2026 18:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2191F000E9;
	Tue,  7 Jul 2026 18:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783450001;
	bh=TnzAVuFS/1c1f8/sGeVM6EqLbn2q6aov1CaEXTJphiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q2kwS1vQT1lvk6DbrNeBX1zSrwqJTy6MVV4NtnB6qmooEdVkr3SP0kigaSXxVtPcI
	 FNiL3NkneqXGz8PdsXfOW7ShhH5GsUyJvZ11fBbBXWTsxY4H1Ytlc4eElaSVWGdSYs
	 SLrz9X0TaUi3woiE1RsdehIj3nErOa3YJgihIIyFOIzEzcI/35o5dqW8mWQ8fNvo0F
	 RnWkMNyFRVMTn2TsXmWBfT4CmqebAU4jGHRb21/8ZRR3nIAmOhV7QxQniojhjZiUrZ
	 ih+s0tTd12+RibBhP6G0AcmO44ieiON9rgyx1HQpHrJNpW5E7vG2Gwh6B2CTWln7gj
	 UdLa664uk80DA==
Date: Tue, 7 Jul 2026 19:46:28 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev, osalvador@suse.de, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com, 
	gthelen@google.com, mike.kravetz@oracle.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, riel@surriel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
Message-ID: <ak0xWgpJPSaNWPsl@lucifer>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
 <20260707062428-mutt-send-email-mst@kernel.org>
 <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org>
 <akzZr2jfJ0J8zox4@lucifer>
 <20260707095843-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260707095843-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 76456100006
X-Stat-Signature: yrswaohq95wgjazqpt1op5gfp45dnhub
X-Rspam-User: 
X-HE-Tag: 1783450002-849641
X-HE-Meta: U2FsdGVkX1+n6IKje9Jc7xjh8y9xhkpuyLThYBERGIR24X6JLglwEMDVuOYyb6npDWPPZFogsSKnEUuOKkJJmGdVOo4ee/7n+Pp+zAQwl3PosEp+gEtb7FJeAappCcbRD359bhgtKU+hqqcCppAuMibgV9E4T6yurPA7TwmycE7xkXDsrB8YzDZhPgephgIf+5MvD1yIJZqDbeYWDAAZVGgFAMuY+Q+S2KhNQLoewlb3tcnzTvCmKKgKwRc/qQOUCXqsasPHwIayXHG0OHy0NnQL5VM8llBUbDlv5/I3p8JvUhnX9aRLstl/eTeILRvWQYQp3FDnvQxKXGNX5StFOr7W6KolOqRHdDeZSn/C8oOmWlLSvyItEaJ833OyhlSsxpfUv5GwAp2q1jIejLFraw560H2CQFDh3gYJC6zzeCa6F9yrFjB9Za9YjmduVLeccilZaqydIFi12KkFwtfiTDQBOXZkYiNPZwgoKgs+J8ox+mMabGMoZ146Itm0P5LvFGqU8/wknEvVkBZg0UA0F7qgz7jLgXQ6vAyCox5tGBe23wXAliz0BscUYhsCWWCAEQl7bzNGM29YHfyOPazqxSe4AYUdIG8AgO56d2lfJLXX3vqRn9a88bHGjOFk5ETrVFnvOvH2W02+SJWd4KYccsahsGejkXBgn9s3q3kuKufHmrxfIfWqwbPDRPcXOaKr8yqNhqaBehdt8Y6AQ06laFEvhKH8hNnXJUyuH7ufEFQPvZWhgUBNIRml6eQjPMoSdXM9B6cVrKLzRNa8za46Iv9IrOYd8+KiXmqkB9f1QdNN2QA8J+N07e+6E8/vTPnQWatuHNFojcb3Oi5HJlqDreKQlqGRBrYu1OabDoF3bIRujVUxf1CSzRv4S8k6jC4Iw/T5DHuI86D6+2Ki/KvbWATo+9//FMbb7XJN43NXD4zppfHzfiOuBLICkXCOeTaqB3MXYh0MzIIkxu754B/
 7PZ3BfGv
 a2SaYFOsNQAUz4VYjqI8ts+UQLI6CXi0Q1IkDd0xuC2yicwWwz0QGBGDDIjzu60cFJafY4OcZOKm0FhXJl+aqaDg0Ihml8ldGBvROGwnhiZ+6xv1ryAmOOu6yObZpWUCsk2TeQDu/rNGRRcugWl9Xrc2av/zBL0n4oGsKuaAMGZcFyYJLkcBr0zdezDBmebH//sM60a3XafEYWmQ18yG3TepOSPjAXll0FtMDk+sB3IgdTEoksBrHfMbad7jzSneZK+j/E9QvmztGg6gXlB+K1BpFkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 10:01:55AM -0400, Michael S. Tsirkin wrote:
> On Tue, Jul 07, 2026 at 12:06:34PM +0100, Lorenzo Stoakes wrote:
> > On Tue, Jul 07, 2026 at 12:28:44PM +0200, David Hildenbrand (Arm) wrote:
> > > On 7/7/26 12:25, Michael S. Tsirkin wrote:
> > > > On Tue, Jul 07, 2026 at 09:29:07AM +0200, David Hildenbrand (Arm) wrote:
> > > >> On 7/7/26 08:42, Sourav Panda wrote:
> > > >>> Overview
> > > >>> This patch series introduces a dynamic, NUMA-aware HugePage Cache,
> > > >>> backed by a kernel shrinker to safely return memory under pressure, and
> > > >>> integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
> > > >>> specifically targeting gigantic (1GB) hugepages. The goal is to solve
> > > >>> the tradeoff between allocation latency and memory
> > > >>> fungibility in virtualized and heterogeneous cloud environments.
> > > >>
> > > >> Hi,
> > > >>
> > > >> in general, we consider hugetlb nowadays to be mostly in feature freeze, as we
> > > >> realized a while ago that adding more special casing on top of something too
> > > >> special for all of MM is only going to hurt us more in the long run.
> > > >>
> > > >> We want to have less special casing and less special sauce, not more.
> > > >>
> > > >> Now, there is nothing wrong in making hugetlb be less special, by making it use
> > > >> more of core infrastructure etc.
> > > >>
> > > >> But optimizing for surplus hugetlb pages by teaching hugetlb about new caches
> > > >> and its custom free-page-reporting support rather looks like the wrong direction
> > > >> for me?
> > > >>
> > > >> --
> > > >> Cheers,
> > > >>
> > > >> David
> > > >
> > > >
> > > > It is currently bypassing free-page-reporting completely.
> > > > Making existing free lists not ignore free-page-reporting would
> > > > maybe considered "making it be less special"?
> > > >
> >
> > You have this completely backwards.
> >
> > You're advocating making hugetlb _more special_ by duplicating functionality that
> > core mm already supports.
> >
> > I mean:
> >
> > mm/hugetlb.c                                 | 590 ++++++++++++++++++-
> >
> > Tells the whole story right?
> >
> > The whole issue with hugetlb is the very fact that it's a parallel
> > implementation of a bunch of mm stuff in its own little world.
> >
> > We make it less special by mm/hugetlb.c smaller and smaller and implementing
> > what it does sanely elsewhere in _core mm_.
> >
> > >
> > > Depends. We don't really want an orthogonal implementation of something we have
> > > in core-mm.
> >
> > Yes, exactly.
> >
> > Feature freeze means feature freeze, not 'feature that core mm doesn't support
> > feature freeze'.
> >
> > Hugetlb is a poster child for poor decision making in mm that has left us
> > saddled with maintenance nightmares because we allowed 'just one more feature
> > in' (TM) with little to no thought to the future.
> >
> > And we've all learned from that and don't want to repeat these kinds of
> > mistakes, nor make existing mistakes worse.
> >
> > And work to improve hugetlbfs and make changes like the above are VERY welcome
> > :)
>
> Fair enough.
>
> > Laying a foundation for hugetlbfs to be more of a sane mm citizen through rework
> > series is really the asking price for stuff like this in my opinion.
>
> Lorenzo, do you know *how* you want it reworked? Could you write it up
> at a high level?
> Because if not, it's not really practical to make it the asking price.

Michael, you're an experienced maintainer, I'm surprised I have to tell you that
the burden for that lands on the submitter.

Nor does a no from a maintainer require an alternative be provided.

In any case, I felt I was clear above but to reiterate - do the opposite of what
the issues are:

- Implement things in core mm without it being treated as a separate entity.

- Reduce the propagation of if (hugetlb) { ... something specific ... } strewn
  through the code base.

- De-duplicate the appalling parallel implementations — and not by pulling
  things out 'just for hugetlb', but by making it ordinary.

There are a WHOLE HOST of issues and problems and difficulties with doing all of
that. But that's just the reality of it - again, the burden of figuring that out
is on the submitter.

So the price for entry is high, very high, but that doesn't make the no any less
emphatic - we're not going to accept the problem being made any worse.

Note that I'm currently working on reworking the anon rmap which is similarly
problematic. I didn't get nor expect detailed guidelines on how to do so. The
burden's on me, and it's equally a high price to pay.

But setting the bar such that the codebase is as good and robust as it can be
both now and in the future is what maintainership is about.

Thanks, Lorenzo

