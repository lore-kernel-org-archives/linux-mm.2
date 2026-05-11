Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DF1CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A47F6B0093; Mon, 11 May 2026 07:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255536B0095; Mon, 11 May 2026 07:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B956B0096; Mon, 11 May 2026 07:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 082916B0093
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:20:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B263B1C05E3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:20:19 +0000 (UTC)
X-FDA: 84754895358.18.894D412
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 204F54000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:20:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kcQg+hU/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778498418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1iN285AfyesN+CVeye90xit8+UukjhBJ2wEQ3aW/Mk=;
	b=jBSykoeuZR9mS55A6R6+WairWOC1+9dfjnePuQXtmdXfFmHeRIJqr7fsB181ypBT8t/do/
	TP79964kXJW2csanzbwcC5/1k+A4K+fHY8EkcEGUWpmprN3GeUkTVvmHuVhMZn+mDc8gor
	rN5MIYqaH4Bqnd5riPQClKOtpF+5RrU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778498418; a=rsa-sha256;
	cv=none;
	b=Py5BH5sSBysf8AIPUwJp3SXrKGqZB6UIhuAohJC75V3tXeMZKyR7s3h9Tfo+sx42Yjr/2E
	t8MuenUfizWu62A9CvARRXPi+ZF+vweWQQlmSPxLhyxMbupdkzYBz7Nylg7m6cbWFQ9fhX
	FtFKpUee/yvRL2OQpynRmCdVdRX8WxI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kcQg+hU/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D44760120;
	Mon, 11 May 2026 11:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5F0C2BCC9;
	Mon, 11 May 2026 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778498417;
	bh=c1iN285AfyesN+CVeye90xit8+UukjhBJ2wEQ3aW/Mk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kcQg+hU/Pq47cHF3AHzRll3ksA8jiCmioAMiE2KKaQqajNu9TDnSVq/gtHmgJWoUA
	 5nB/g8NTcZKwMbxPC8yBBOrx4Kyu18EijQV1fqIcvW8TYk13nm2lORABuOVDsYcYFy
	 jXgvgs2o8wwfzGNqYYWeRiP+8qaxp3x7n2btdYuyZcISVCEWiP96ZSeAAQlK27w1bN
	 fK9Y1KCPpv6CZP/N+aPsMEK0yJ3ZsOdVsZsi7qOo/NqawlYLuBsQUDkoDbvjtitagz
	 TZ4o+tLBu7urXvdL6How7gDq5goFfZ/BIEI+KIA8ZmsrtufT5q0Gmziua1HJHAQcRQ
	 Oz6Uje7yFouxg==
Date: Mon, 11 May 2026 12:20:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, roman.gushchin@linux.dev, 
	inwardvessel@gmail.com, shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net, 
	surenb@google.com, tz2294@columbia.edu, baohua@kernel.org, lance.yang@linux.dev, 
	dev.jain@arm.com, laoar.shao@gmail.com, gutierrez.asier@huawei-partners.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 0/4] mm: introduce mthp_ext via cgroup-bpf to make
 mTHP more transparent
Message-ID: <agGzD8K9EBMMkhEH@lucifer>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
 <af376QFXC36uf7kp@lucifer>
 <af4IEwbAAIYUH0z9@lucifer>
 <CACZaFFNdk5EfBxCTT0WOPGLiG_01wNESem_DKAu9SK1hrzBhow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACZaFFNdk5EfBxCTT0WOPGLiG_01wNESem_DKAu9SK1hrzBhow@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 204F54000A
X-Stat-Signature: deqab1i4bsx7ek4igrct7wxfysfggucp
X-Rspam-User: 
X-HE-Tag: 1778498417-42886
X-HE-Meta: U2FsdGVkX18NDm8E2Pq6GbCsNbvfRRWE0NMqBbmlsYmF+vE4c+a40J66xQ5ak1U904zjWOfK1X63byhwC6Jhc6gN70UKEb3G/19AEM4+AYEuJ6nAgfJZzl3trah9TtpdudMok9lhCPvL15WpKcw/UpZp0XkWKvHRKhc8m/BenlPe/E+bdspMQi+BS+OapwowPOIf+4W7Yk5pc+A6xDcVpeX873EBYjGCHv6YhLEKTmqLKGQlduXUe4Dafq7aomEQN3hACBwVUamE27p/rSszJd+Lrr7ILy77Gj2nchKbXhayLCZI3AbAgufCNgTlfwpvEWtuIXELLCZnCLpy5JHJ8aiF7IIdOZ+H5vJFUq3tiMQdq6vtc90eg0NQxzcJAZ0bL8YTltUmylO75Iak/xOPzBwlXOBtUi9XHGZQEq89jcJmIiBJRbIxATxM3HV1vhPzAFl3nmBP1o5a/yCHdDYy0xCm6r5Xrz0W3fFp5zVL8Rj8TCdfIaMXOg4cBtCY3ADulpXu4tFyeHcFmnAOOxT+FnNCY8j4u2aHKOYYcMcgu3aaAYuAErDx4Yr2P7QMopiXqfKzkcFT5/7v+qUaD2Gjhgqy9UIu3wdfGIelIsUWgMnj234IFew6PpzqUCXzpUmhH7U8hDKYMAY2yjjmJIyYCi+mrrReetf2VAqEmFypzpTW7cUp5EDRolYiuqLTAMdMATlWCi+r5LKk70JIlTX7s30nqOXjrSfk7q8OdjVaawjnm2vdr4qzJUaNEhM6SjcQvhRtNIpRxAPLTCoN30CrlFOh4klWoz7VtFs8tQBpzxMdRUd9Y/z83xaRl3o8HC+UeN1tFF+JyinS5Cs3oGbpjPK73VAxNTJXPT5UFVRDUlwAhUVeccx9OML1U3SpmxIwhttGZv97+WWF8xy3ONcUjgiZ0gt/uExJpQbrKoPmRfNKz/Wirk5OHIehLnKrZgAW9421t4ZpBZEOjCmNoU9
 4pyftwfE
 WiA13kk6YG+6ceJmuGlqm+EuFIrqyU50zhOiYNFoaVaXTrNoeuLz8/so5m8JRlQqrEjLiDzTzZ6lrQ13bQdxVt2yx+SjYJmqqKl3QKQQTXvtygL1B/HRK+t0wKrBA6q56WTIaxeMr2ZIc1kVEUNE8jL8SHzadOjVLmM8rHRLI7De/LORC2HrLH6mUsbrZ1bpIfbO+DZqeBz+bhS9l9AW9xE11uu2NtynIM3oEmQu7Jmxy4AeihCxrYXSGEgPMO1jchHiS33LLJapYR+qf3DOGKjdVAEoMaQ0Lsct9lhue81ul512YZ0tNkOXgEFhp9Kky3EkWqeZp3px7U2psFGvlDcWr8wyhPBNL4n3m9yGHronKq487lhjasiB8JfKVyn9Y7IjHWnrt3gM9q/x8iE9jeCTF2gq6GlMsVwKW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 09, 2026 at 12:53:35AM +0800, Vernon Yang wrote:
> On Sat, May 9, 2026 at 12:05 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Fri, May 08, 2026 at 04:15:04PM +0100, Lorenzo Stoakes wrote:
> > > Thanks for the series, but overall it's got to be no to this until THP and mTHP
> > > are in more stable shape.
> > >
> > > And this is an RFC, you're trying to make really fundamental changes here, it's
> > > almost... rude to do that out of the blue non-RFC'd (unless you're a maintainer
> > > perhaps).
> > >
> > > Right now the THP code base is a total mess and mTHP support is not even
> > > properly merged yet (khugepaged support outstanding).
> > >
> > > BPF interfaces are permanent, we've tried the 'experimental' thing before, it
> > > doesn't work and we'll not be able to yank it later.
> > >
> > > I've said it before, but we really truly need to get THP into better shape
> > > before we can tolerate large new changes, let alone an user-exported interface.
> > >
> > > So can we defer this until we're in better shape, and then send that as an RFC
> > > first please?
> >
> > Yeah on second thoughts, NACK and don't send this series again please.
> >
> > I was already annoyed you'd send something this invasive and massive without an
> > RFC, but you've also ignored the feedback we gave to the last THP BPF series
> > while ostensibly claiming to have taken it into account.
> >
> > And then... I mean seriously... _shamelessly_ trying to take control away from
> > THP maintainers and reviewers who work bloody hard for this community by parking
> > code that changes mTHP behaviour in an entirely distinct and unrelated
> > MAINTAINERS section...!
> >
> > There's a biweekly THP cabal meeting which you didn't raise this in, you didn't
> > bring this up at any conference, you didn't send an RFC.
> >
> > You've sent it too before we even have mTHP khugepaged support merged... or have
> > really stabilised on how mTHP is supposed to work overall.
> >
> > And also I have made it really abundantly clear that I want to see the technical
> > debt _paid down_ before we add anything else major.
> >
> > And as if that wasn't enough, AI review is finding endless problems with this
> > series on top of all that.
> >
> > This is NOT how to engage with upstream. Again, please don't send any more
> > revisions of this.
> >
> > And next time _engage with the community_ before proposing something this big. A
> > [DISCUSSION] email, or an RFC, or in a meeting or at a conference, or even
> > off-list or on-list mail, something.
>
> Firstly, before mTHP stabilizes and enters better shape, I will not
> submit any new version.
>
> Let me clarify a few issues:
> 1. This is an RFC. I forgot to add it. Sorry.
> 2. There is only one issue in the AI review; the rest are false
> positives (the AI did not find the dependent patch "mm: BPF OOM").
> 3. Regarding placing bpf_huge_memory.c under "MEMORY MANAGEMENT
> EXTENSIONS": I never intended to take control of THP away from
> maintainers and reviewers. However, it is still my fault for causing
> misunderstanding. Sorry.
>
> Also, I would like to ask: what work on mTHP still needs further
> refinement at present? I can help out.

Sorry maybe I overreacted here, long week...!

But in general - yes there's work to be done but what we need help with
above everything else is to pay down technical debt in the THP codebase.

Review also helps :) right now we are adding mTHP support to khugepaged
which is the next 'big thing' for mTHP.

As David has said elsewhere, the _interface_ is the challenge with
BPF. Because we truly want to be sure that interface is the right one and
won't impact our ability to make changes to the implementation of THP as a
whole.

Treating BPF as a de facto permanent uAPI is the way to go I think in
general.

Cheers, Lorenzo

