Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9D5E6BF3B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 20:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C266B0088; Fri, 30 Jan 2026 15:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FC36B0089; Fri, 30 Jan 2026 15:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BB96B008A; Fri, 30 Jan 2026 15:38:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5CC6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:38:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03741C1B40
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:38:13 +0000 (UTC)
X-FDA: 84389792508.16.B736389
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36911140004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:38:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pBile50Q;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769805492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RUn2+UzYq9oxWCSRL5eNkpr1f5l1vKkVJHeXO3plck=;
	b=vpPqzL2T9piaX/QUB9styKa16dI4l4rJkGhcIdGMtdqqR4yp14RjCrLVaRQS3iqy+jPaB9
	XbI4rBYeu0q1BW9ErzhM9UO1mRtidil6uwWXZ1mDac9bCQt82GGChW6mtWs39alUhNnVeZ
	Qxrz7jNk+NTWjlr2O1vmXAwjYna3+4o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pBile50Q;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769805492; a=rsa-sha256;
	cv=none;
	b=ByCUQjzjC6Bw7zwL9hzDNhJ+y02ZaCP2nymSbp3Esb9nbtxJK9mNZxIyXyHPo6PnNYA49O
	lOiM8otJIHtudUq79dfQZZKSxXi9iAMoJHrHCV1BghJ7mHZXrOmD64oiyliJDPd0vM8yn9
	TAl/Mk/MjMlwMHcptDv9QYVd+FHYJCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21A6D43893;
	Fri, 30 Jan 2026 20:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9694EC4CEF7;
	Fri, 30 Jan 2026 20:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769805491;
	bh=ZtMtrB2Y+G7ZscbAHQAFYF5f2VD5t3/mtZEyvZca4WU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pBile50QnlGw8x75Ig9U45/zvrTbeGA0ov5UjecXOYj8eYIHEOhIX+dMpbkvVuR0W
	 KaxG0ErlZlPaC9kxvgycPVLALXmhDSQoT1+nQjyuzLDUT5H8vJmsc62X6Y0T9uQaHR
	 4Qo3+b9PwRuH9v2n3d6JoxuwZYR/0fN/oL8ep4/Q=
Date: Fri, 30 Jan 2026 12:38:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, linux-mm@kvack.org, stable@vger.kernel.org,
 dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-Id: <20260130123810.61dde600422a8fe01cff8296@linux-foundation.org>
In-Reply-To: <b9dd97e7d9e62ebc33c4dfef53a9fd3f51352d3a.camel@linux.intel.com>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
	<20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
	<b9dd97e7d9e62ebc33c4dfef53a9fd3f51352d3a.camel@linux.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 318oixjkinbou5dj75u6efucot77wodt
X-Rspamd-Queue-Id: 36911140004
X-Rspam-User: 
X-HE-Tag: 1769805492-460008
X-HE-Meta: U2FsdGVkX1/3RwEg4YqYwcsnTvR0EtakOQdszeWZomejBMRRY464cP+35EGj6yePXkeLvE6IedNbSf40zDov92Yju4G6pi7BFNzHoMpCnpN4bbfcyG3wXkL6RYIurn/i/vefJabSo6FWfDqALDvI64MiZ6reL8Ex1BGaxZJVuHfR1FE+OpxV9qk+ck09F4IQQSIcXHrtVOimkQ9B3q3qMtJ4LsDQtwq+6CTlSa+Vc9ZxlZCYmLpQ4H9/SINENfn/sOswtCBcUrNBY2B3COUziUGx14dySFi1jGM2Lw0glBVyEbynzUFejvCFPGV7Ixmi5n0JAhvfHMqLoUi5L5I0xGfwIduVIu7ZGCNFW+hlsWSjZIH6GN/MMH/jRi0FIuLrL3SzBLlmyR7ENZXuN0iohCGnBj+LFYUpZXjHBoMtM44uYJszCg7TtIEyOiL4AGP2ES+mAC+fwxfqCQ6vEZZfNbAS2SV4m7uzzTLL44pVk/Xf3QVQjMM+ADR8ssKJAHN/M46K0udHAuXPQHJu+ToP90vddRjt4+YtUd/uguTC3yEbWqO6pVEvqvlkJrQJVFuGrC2IwRk9FvBH8yh9UE1gZoe6rr9C+QIN35VKlerCxL6JCJgwo4CkrF/fCkMWotkk3VtHvRzzbXme3rWxvk2J5BmZQBNrLPqiJ2pg92HBN78S2hjn5aQ5PH1DbJ4AH7dhewzlMUhHq9nmb97ldlObjRrUu026LGeK7f7+87nd2Gjc6IBJxdclERJplXbgLFgJYPmFU+5Zr8L1ZLJSC0ONM2dWusB/PyoBgjJ2O6iNmc3HxCw06djlHBuHAyRxgTP8YXx8bRCBq/hzLLSy+X/vhmdSquHQNpMUL7jwE3kluxXdc7XA4O/ZBkX0la6IY+a+WUaT6002eVbF7edtmplbnGKMFraDVxDTN+lYnQaoitVy7MvPxEnyOPATOuIAfK5ToFy3HbYTEOORtlhyAmL
 5P2LTba6
 TS1SAxgLTDUomDhVKA/98RVX/rnGtedUUPmtFMTeUm/FZJzdoDgQVamHEj0as8TDtawXlEehdJA/o5H20PyYYHbLyM9ZxkJaILATAcjpnxDLufsmOl7u4HK27X6qseCA9TEe28M1Qz6MRKPsOhfoQe+U4AiUXMXnUl3U0NE5lJ3reAPtsDmxMs3jdkIvZUVw575/8UoRuTAEoIWCgM5o1EZQkUgRTPZt4k8JQf9BvbSOV7f6q6/zDkzZryb1ETS1yHYUcbkU/Gl3+rtU017Nov6Z04ROO1pmZBkD0uGno0XPOo1Cle2kt9+lhZF2EMVbwAZFf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 20:56:31 +0100 Thomas Hellstr=F6m <thomas.hellstrom@lin=
ux.intel.com> wrote:

> >=20
> > > --- a/mm/hmm.c
> > > +++ b/mm/hmm.c
> > > @@ -674,6 +674,13 @@ int hmm_range_fault(struct hmm_range *range)
> > > =A0			return -EBUSY;
> > > =A0		ret =3D walk_page_range(mm, hmm_vma_walk.last,
> > > range->end,
> > > =A0				=A0=A0=A0=A0=A0 &hmm_walk_ops,
> > > &hmm_vma_walk);
> > > +		/*
> > > +		 * Conditionally reschedule to let other work
> > > items get
> > > +		 * a chance to unlock device-private pages whose
> > > locks
> > > +		 * we're spinning on.
> > > +		 */
> > > +		cond_resched();
> > > +
> > > =A0		/*
> > > =A0		 * When -EBUSY is returned the loop restarts with
> > > =A0		 * hmm_vma_walk.last set to an address that has
> > > not been stored
> >=20
> > If the process which is running hmm_range_fault() has
> > SCHED_FIFO/SHCED_RR then cond_resched() doesn't work.=A0 An explicit
> > msleep() would be better?
>=20
> Unfortunately hmm_range_fault() is typically called from a gpu
> pagefault handler and it's crucial to get the gpu up and running again
> as fast as possible.

Would a millisecond matter?  Regular old preemption will often cause
longer delays.

> Is there a way we could test for the cases where cond_resched() doesn't
> work and in that case instead call sched_yield(), at least on -EBUSY
> errors?

kernel-internal sched_yield() was taken away years ago and I don't
think there's a replacement, particularly one which will cause a
realtime-policy task to yield to a non-rt-policy one.

It's common for kernel code to forget that it could have realtime
policy - we probably have potential lockups in various places.

I suggest you rerun your testcase with this patch using `chrt -r', see
if my speculation is correct.

