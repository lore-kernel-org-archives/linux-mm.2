Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 329D9CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7280D6B008A; Mon, 22 Jun 2026 09:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9AF6B0092; Mon, 22 Jun 2026 09:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF5D6B0096; Mon, 22 Jun 2026 09:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A05A6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:55:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE90D8BCCB
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:55:22 +0000 (UTC)
X-FDA: 84907695684.23.0FF67E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2117818000F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:55:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJ6z0MOi;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782136521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSv61ssW4qc4Rb4nc4Phm6/rZ5E/q8Nhnm6lGxqv4Lc=;
	b=CEHueNSySXUGo9gCUrvBCSvbFHzxcUcNiIO1doFs4oPi+YSMJwhlzJj0X6c9myvH0pC+Ma
	ZuTmO6yPj292EynW1LL8J0ZKFwSrQYMvTHLu823aMZcmmUg26whnr3dM9mnqNA8K9UqreK
	bbe98JB8DalJrgZQMNEu1+AMlYIhCYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782136521;
	b=c3rNnWiSDJiD16uuuyXlBv8eDFfF809X+WDEkxLiTpKOrvDILnuZ44JnV8atZwKXB5Zlut
	JRKthlFnr8ZXfCKxbEAmp/g3AfxJgMKud62BJYWNOnz2Ec9wrrFjrJgEmHMeX6dTp4XsdR
	e2rDoSCqJiKXAHR7ryEQ4yykFOp75Zk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJ6z0MOi;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96CAB601F3;
	Mon, 22 Jun 2026 13:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39FF1F000E9;
	Mon, 22 Jun 2026 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782136520;
	bh=lSv61ssW4qc4Rb4nc4Phm6/rZ5E/q8Nhnm6lGxqv4Lc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eJ6z0MOip6YxUE4QsGFzORnLmafH/OnigpV21qukMVYRjfSY7Tsrjc92QtgKm5w4I
	 3imxnlKh9MwMmv3DxMMiqLKWXDM1/BXGwXmyVv3Zer8gkU1QXWiT9QvM+1ryxggTe0
	 6E+aPbM6i2QcA4XQew8aC4ekzIRtinhc67pYlJ9Lp1/qqT1JmOYHB22HNMFHStC1PJ
	 lkZrJb6Dt5cHfxO2BjWOtnubPFQgteMBHeWVUzg4sp5h4F8sCkxHxsUyqVNdTXbqoT
	 OLM8CXWX6wn0RynGvsgsfobUxn7jMkNeYTAdUhSlN1h8JqnYDPzS17ujkxcs3/+5hJ
	 v1+pLsnAMIvTw==
Date: Mon, 22 Jun 2026 14:55:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Frederick Mayle <fmayle@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajk-NMghY50F6Sli@lucifer>
References: <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org>
 <ajV0TbwEyaKMzoa6@lucifer>
 <ajV49Fyogfa6aIjy@pedro-suse>
 <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org>
 <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
 <ajWXEn7gECvgG7F5@pedro-suse.lan>
 <CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
 <7ftrqtta2bw2xxtrzelrs46t7khr7tf2vmh2ur2mhdphtymlsr@rqbd3pfjxdp7>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ftrqtta2bw2xxtrzelrs46t7khr7tf2vmh2ur2mhdphtymlsr@rqbd3pfjxdp7>
X-Stat-Signature: c4iutd9gjryfgt7npc4oftj8e5hxcgz8
X-Rspamd-Queue-Id: 2117818000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782136520-933593
X-HE-Meta: U2FsdGVkX1/Sk5iuUc+5kCY9kjSGNVKutuYiiuZnetPwu9UL1zZctZD5DM6OSRqJJJNKNANfolHoLcq3Xi9BHr3IEc36p17JAcfs2BqmdnY3KbrMLXSgfEnj4fCieD81hqv9TQqKYxkyO829xUfjNWBQ72S9NWTcvAsnk1lAPFdmwD6l2h1QfF2DM0q9vtz6qTPsj7tM52VGUVlKlHC5+ySDQHGRb5fjWiokr8s+AuSTKXFLrynopis5U6G3Qi6EBxJuIRQVVCQTwjSuNeYwtT3GO7qbrEZZmpcogF1La5EOos0L2X2vbRMnxaMXemdfaUKYVEySshB0zz3VlfYnGiDLrT8Ea9/U0WpNoAKNPWFFQVJ0QZTBA6SOaGg1sdz4owTW2rDMtq7P/yvLGMLeJCPxhhRMvLUqgPEv+gQ6GDZIeBwa+nvuANEcqJJr3ydXo0IOc6AW5rzOZmFrFO8/+KzqWgDuOzIHaoKT4id672gVovOG59YpOBwT06aOjUNqRgHqiM30jDbD6/FE7xZX5+yM2Waza7b94y0eTEuho+aQJ87i0z3OToY4higGCgKu+58dE1+IJic8534kPLzYTfGHDBQvwHUR9ve2fW/Zmuis7ZGYiQ5ULoI6rdzlMc6loZ+ewDaKrbHJm122NZVUpk9wQ/J3coJ6fdd5oEgpjMB4M82AeRksyuPrYa6NTcCE+RdzNUEka562oe39g915NMsP3Z+H5DBQz4tm3h1x/7n4EKjvZEALb2WGrNGDfbga6kHv8PFr62TTntOW8LKHEoscCTqmilc0jCTiiX9DJ4B1jG+n0g2RVbDhpGYnPbSF6rwOkEfweEqXpdDOd1cSsmPP1JRyk0aHv3A1qRmkSSv1Wlp9CVmDUsl3x+5nKZ7djV2OtUvMekc0/rIh9yHjNQ2l981vnxtqRgWFhc79NBcIsRPCwvdlnGhpQABkkRtCqQYW59kL8dcw7jqPNc0
 Mehzu5no
 /0CwUIXLoxXkMeDB83bJzTxwTjUz0K2k8sgGj9eUge4oew+fmYiVzgd7HigMxaNbmx+U0aPDTcc4YAuty41Ybr83GqQvkGHuobsgADGR7lhLphYfXZJF5xW5oUjuJlUAQArXX7Oa6Ua0hnPxBzXBM9UugBQx/X0TRFi9CcEv9WnR5qxL+UNGub+HM082gos8qsZJMGHAw0cUV18HzgnRHvCFaTXnPMxUBPnCaFYNXjaHt93npzoIOqQjsfMN6Qy3CLPlfB7ZZA5q1GlHRGw/aYwjkTSqZfqrCBpYnI3qMGu/Kd4dOp833vQsvuGeV/AVsilIM4wA9lsByUYfz1bQbrw8Db2ND8LgLSnCc8di318jkfaJTwbrnJYZGcg8uAQh0BS3p8OFQQtvq0kMoN1wbUnTK4k1obc+wd+9AzMr227+gOoks6apd91Q7h4/qhR3DcBeH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 11:26:18AM +0200, Jan Kara wrote:
> On Fri 19-06-26 12:33:43, Suren Baghdasaryan wrote:
> > On Fri, Jun 19, 2026 at 12:26 PM Pedro Falcato <pfalcato@suse.de> wrote:
> > >
> > > On Fri, Jun 19, 2026 at 10:52:07AM -0700, Suren Baghdasaryan wrote:
> > > > On Fri, Jun 19, 2026 at 10:46 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > > >
> > > > > On Fri, Jun 19, 2026 at 10:43:06AM -0700, Suren Baghdasaryan wrote:
> > > > > > > Yeah, the mmap usage on SVT-AV1 is a little suspicious, but I guess the
> > > > > > > pattern may come up time and time again for people doing chunked mmap
> > > > > > > reads. I think we need to take a closer look at this change.
> > > > > >
> > > > > > Frame-by-frame mmapping for a streaming workoad is quite questionable
> > > > > > IMHO and I don't think we should be optimizing or encouraging such
> > > > > > usage, but I understand the reasoning for the revert.
> > > > >
> > > > > If userspace is properly tuned, it doesn't need automatic readahead
> > > > > at all; it can disable it and issue manual readaheads.  The point of
> > > > > automatic readahead is to cope with userspace which is doing stupid
> > > > > things like calling read() for a single byte at a time.
> > > > >
> > > > > Could it have better defaults?  Maybe!  It's worth a try.  But those
> > > > > attempts need to have a very low bar for reversion when it turns out
> > > > > they affect other workloads.
> > > >
> > > > That what I meant in the last part of my reply :)
> > > >
> > > > But in general, I think that benchmark measuring "how many frames per
> > > > second a CPU can encode" should be revised so it doesn't depend on
> > > > file prefetching mechanisms. Otherwise it's measuring something else.
> > >
> > > To be clear, that's not (necessarily) a benchmark, the code we were
> > > looking at is their encoder app.
> >
> > Ack.
> >
> > > (it's also generally not possible to prefetch the whole thing into RAM
> > > because, well, raw video files are quite large)
> >
> > For such streaminig workload I think read() would be more appropriate,
> > and the change limiting read-ahead by VMA size would not affect it.
>
> In fact if you look at that app, it has three different methods of reading
> the input frames (mmap, normal read, fully buffered file in memory) and one
> is chosen based on config option. So the benchmark apparently configures
> the mmap method of accessing the input file.
>
> Anyway I agree with you using mmap-frame-by-frame approach for this usecase
> is kind of odd but not completely insane and it does demostrate people do
> odd things like this. For others the usecase of Android doing tons of small
> sparse mmaps into executable might look odd as well :) So this seems to be
> one of the cases where it's difficult to please everybody with the same
> behavior and we usually stick to the legacy behavior in cases like that (as
> much as I personally find restricting mmap readahead to a VMA a sensible
> thing to do). We just need to figure out how to improve the Android
> usecase.

Reading the thread, I think we're all in agreement that this is a workload
that exists and we are regressing it here, thus the revert is the right
course of action.

Andrew - could we move this to the hotfixes branch please?

>
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

Thanks, Lorenzo

