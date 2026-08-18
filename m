Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F92C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 23:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C286B008A; Tue, 18 Aug 2026 19:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D446B008C; Tue, 18 Aug 2026 19:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253CA6B0092; Tue, 18 Aug 2026 19:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F14A26B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:59:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84663A2A07
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:59:42 +0000 (UTC)
X-FDA: 85116060204.11.2712A27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C2D3F1C0008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:59:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="O0SVV/r9";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787097580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kz5005IQhYTqHLRDhRzDxqDrp+d9vWEqAIEu8aMS/Vg=;
	b=4sk+ydADNUc1cEIYH1QMBRqnjDAsATKjzCMrNSOQ9ZKUQo6NoxHCEcQX5jtqkpattOQdOP
	MYf+fGHdt+tUHDPjNiy70MB/N/iWWCBd96cHeTkP3dXyy4W+kVDuZFTM8RzBQjueiDZVGV
	iKtuKrOuUu7A6n8GAoEb4dLvYgiBAVk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="O0SVV/r9";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787097580;
	b=mGkkYj/4cgNdeShSY7CDzYU1YD0KOXGnRaG1e6G9ideKz2ebf5wIFRuBOi1EkSJPS8u1Lb
	1RSSX3bCJfoPC3OC/QG8ryPZFSeX8a/8fgUG1xAIKWKkWAn5foupoTru6kJaz4cC686SG8
	y1oDJrKfCkc0LqcIZSSDr4oce38AnxQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA9014137E;
	Tue, 18 Aug 2026 23:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3563C1F00A3A;
	Tue, 18 Aug 2026 23:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787097579;
	bh=kz5005IQhYTqHLRDhRzDxqDrp+d9vWEqAIEu8aMS/Vg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O0SVV/r9mWdAdFT+WVyA28j6wwk6fspX0dtkmaeApzEcqzQRivbjuJsZjEurJYhf1
	 ovi1kSEwM+d9qUxORYLTlzqA8w6COo9u2e2MPPqME6P5BQlzPe5eBZxbblYrQqzjg0
	 jhr31UhobOqi7JhSkAtPwvuiQmCTM0X+VXiAEJBA=
Date: Tue, 18 Aug 2026 16:59:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>, david@kernel.org, mhocko@suse.com,
 leon.hwang@linux.dev, linux-mm@kvack.org, muchun.song@linux.dev,
 osalvador@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Message-Id: <20260818165938.243ead051f792ee1519a5c79@linux-foundation.org>
In-Reply-To: <aoTuwV76Sd0ahBEC@casper.infradead.org>
References: <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
	<20260818221858.86452-1-lance.yang@linux.dev>
	<20260818162430.0a51522ac9bd671cce62650f@linux-foundation.org>
	<aoTuwV76Sd0ahBEC@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C2D3F1C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8efhekgge3q917qa1mauwfefowk469k1
X-HE-Tag: 1787097580-177027
X-HE-Meta: U2FsdGVkX1/9MBNg1/Ny7NYuusphscd9vdY6qloXzaIlQpYPr357wrS/kL15oVJQgQ+UKg0GX0ekcqjet2hM8OW4dHJfOdnVZbEIKsw5y4GzkufoZARnU9iJlj+FQQFsU0zOZD6uFyibZTrjWU5QvttWMQ6jmSZvb926453WtOjMskl3eJY6bEOomp4/qX0hvK00Yr7cvtujkrLRF+ozRh089OOYrx+Lw6yW7j8aXZGuXuSb0ya60e5tjgK8oiE3jQPLYCTG9ItZ8kofbv3AhfM0fv2uG+Yk8yQU5LVbVU8M5dVlyTlywBgES7P5ikBUnNKsNeC1mrgvhes1riOqxdJde6al28B4DGxf8oqjU3FeXfFpghQkX1Lmw0YJO9zJoAbICjWM32C78i5gFpdcL6opUCoJiAVoKphdmQhx9MewrGmZx9+Q9Yw+snPInGz5OeYiANK8qYjqNFv+TSHgkdz0mYFtXc9Ll5msWw4BlPxqRlxDcWK/Ok7gNcDT0Lu5qI5u7y10yyP6aFQC8QLp0gGM8FP2Ivjee4sJl4sxBLJCjiwMICQsKAqF7pBota6Fove3zI9C+/1jt8f/OnMPVIV+OCx0eAnTNf69Je2F9k+MXQLe6QZNs2lFdVyLHXPajp1YS83WPtwwNCi4ARnFh1CDZPqpayjw5UPTutP+wTokT8NqIRh9UEu+AE7pqB562Wyyc6KklsOJSOu6FkB0pbOsIv8G43JHMZTdfi0Fwv7DgqaAJ5Ii8QTbdTL5Y1OHCbrf0IASQgsVET5nF97Q2uD0dAv7zU+ctZ3j7Sfu2RJR888Lncid9UDMuLw3yt0orz6RqfOvwa1sDhZN5ls2nSvK+mg5GULn6by6gvPj7AkySBQfbPqxYbtqpM+hg6koXDj+bYhvMF8rDUyv2PJKGX8DHuNT8qDmBltc4Wi1RY5SHApo81ubgxHW0jF7Mgyb6oTwPEs4Q/16bn+02tc
 UdOxYipN
 Mu8Pb3X0VsS3RB3sEOjgeP1V1FqoD26Y1yT1rCftjaQBJa8dfqkjwfubwAnmfdXQ7YGLsa+a5c0Qc1+XgDzukhWRguKqIHuPWIWDeg2V/EupUz5Th7o4RHJINihc9gIjVBFa14EETP/pyx/m3HvaRU/mBeFRzVvwI/Ne6EW+9+ElZkaUynbZFqt5L4hPTHrs3Lwa7w/HveM4bvXT1KsSul2gI1bCOO0M3oeL311fsgTv2QxxyyKfD9pJDJLAgGAuaQwSwldv42x3Npxz5ckFbrI/9RBu9Cq0bi44lMc+axVPuXuUBBufYl9h6Fh5+sytA1TMCNnUl2YJbmuIDOu/o4ntQlnATd6CiLU3T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 00:46:09 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, Aug 18, 2026 at 04:24:30PM -0700, Andrew Morton wrote:
> > On Wed, 19 Aug 2026 06:18:58 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> > 
> > > >> > 
> > > >> > That's pretty bad behavior and we might want to fix it in earlier
> > > >> > kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
> > > >> > existing users?
> > > >> > 
> > > >> > If yes, we do want to fix older kernels then we should merge this.
> > > >> > 
> > > >> 
> > > >> Okay, but that would be stable-only fixes?
> > > >
> > > >Not understanding.
> > > >
> > > >Maybe you refer to adding a patch to -stable but not to -linus?  That's
> > > >against the -stable rules
> > > >(Documentation/process/stable-kernel-rules.rst).
> > > 
> > > Since cond_resched() is a scheduling no-op under LAZY/FULL anyway (only
> > > the __might_resched() debug check remains), why not take this upstream
> > > with Cc: stable?
> > 
> > I think so - as long as PREEPMT_NONE exists we should support it as
> > well as we can.  If the day comes that PREEMPT_NONE is removed, then we
> > get to remove lots of cond_resched()s.  mm/ has 200 of the things.
> > 
> > > Mainline scheduling stays unchanged, and stable can pick it up for old
> > > PREEMPT_NONE kernels. wdyt?
> > 
> > Addressing this issue in older kernels is another reason.
> 
> That is not the direction that the scheduler developers wish us to take.

Well back luck.

"Packet receive timeouts were traced to sparse HugeTLB unmapping in
production".  Do sched developers have a proposal to fix that in
year-old kernels?


