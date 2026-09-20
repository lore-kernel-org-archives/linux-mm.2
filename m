Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A1DC982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486586B0092; Sun, 20 Sep 2026 08:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4372A6B0096; Sun, 20 Sep 2026 08:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34C796B0098; Sun, 20 Sep 2026 08:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC2B6B0092
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:40:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 954CD120455
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:05 +0000 (UTC)
X-FDA: 85234097970.26.4083683
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 04776A0007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L5YMptaF;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789908004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=peWjRymtPXmQsQX1GH6pRekwMOJX0iwDy1XFg+jsg+Q=;
	b=ATSw0d3NlQtyImDqWg1TMRQGAOTYkgFTgDor47AGSyuyNqJSMpdJ8iIRb/HRmLzfwhAw3v
	px4tqTJqI18kIfkpJRqtOuMiTQ4bHJ+pD/f3fq452/Jpbbhp68aaF3V7O6kylK5F8piXSP
	uY7utDL7vp2Rj1RtxoEm8hesfoQwHJw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L5YMptaF;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789908004;
	b=f5QETLxWS6KMqZ91Q43jR2IeI2wI8Y13sLUyHZnYAfu6sA0ySN2kYsiCibrqrDXP9J0jp1
	D4Y+XNcOwJnd5QQ8PESSeOsSaZR3AbePfkOVcLTM2cOxWUJI+Cl1+R0MVX9QkAyQmCLb6w
	KhFgOOUPFacIbg0SpbZYPh5yrVNBDZ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 566C5601FF;
	Sun, 20 Sep 2026 12:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8D71F000FF;
	Sun, 20 Sep 2026 12:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789908003;
	bh=peWjRymtPXmQsQX1GH6pRekwMOJX0iwDy1XFg+jsg+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5YMptaFKqtjqb/NeHqaLdXDE4x29W47jZaXTWjpzv8Av3q54uaohccVT8h5yrkJD
	 nwsWht7XBncvpuIUYBEJFeq4HOacwNJbTaSq2qnvOephOf9USt43zi+cTCpvE3ZdQj
	 8VPxgytE5wpLkHED58YBEfBnv5P8uha5wfykYAnevijU85TlVK31KTW9SploSwvPmP
	 wwUw4JdDZl5NPYe9RfPGDyLjxSu+G78P+wDe/AjBOTqrJSFx0p0qtrm8DkfFzdmu/i
	 7aBSdawx3CEV8JSsamd4+qoQFbjgm/ZzWutE8+4APSvQpOcD+OLte6QsW86NAvOr78
	 taZhW/dIKKX2w==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sun, 20 Sep 2026 05:39:58 -0700
Message-ID: <20260920123959.48279-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920122430.610257-1-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 04776A0007
X-Stat-Signature: xjeczho3mxpcm5dgf31by9xtqad8cidi
X-Rspam-User: 
X-HE-Tag: 1789908003-961132
X-HE-Meta: U2FsdGVkX18mUw3abIOFWi6jX8x4QNNaGxcGGqtnHgDlaGndwO0WIt8tEsJWqQzDx5vzOJwGIQHSmC8KgsOU8aqvmjnlp+uSpTI+xT085caGfjw15dGW8DZTIIl8TWFvmY6LYR0PNbyei/xGUHXvSOmGfNkETf09k9dfsHMGTR+wKFGx+7PmZG8RrJ20U3N/gnki7GmUPVykXktvzz1yp6nhCwzew/kEYxKKjzDpOIUikRF00iDcD60kNcjKItmFMcO11qe5MB0M3UtUPA+TYQWCcKZ+NSQfG8CuIDecPpCEcoIGXC+D1fjaqF5LohQ9SCC+UC0TTzh4QnAu9OtDxOBXnYekwTrzGvmik9PLDpshdH4tDyWgJ0664msHqCbOyC5kesnMyhoco74/m7Yuv59nLsGWIbtygQZBZLBXKQ77LFb8NWTO5CqNepMRxfx5aLlxCIgJeiCgylS8AMccbGAsw8doNDtV1NpRWtBhgs+56/AdELM7ex5vNmT67ZQOInl35y1Sco6txzN1SrMI1r+UoMpPePM+Edu4xVMVWBtl/Zj6yfDOqDnMdOy7q+ugMrSCwjWcxZQGABBQ57RPbmI144sKb0FwfvGTsqPkwKbtU+/qreSQv+iSGg62YPGne+/kBiSHLE9A4+yyElvxHeHFbE6FDm1S8tkaIaspRPuu/5GzK6qRYyjcSeYdoqYR0AbvFEFzV5tVjFOQ5UuN+F0vSAu56QYBKMB8x9hGNL9gwuMdN4UZ10NQQRs3VThXJjamwy6LIC+bb6qYPGMcVVuLn1rpJlWf448XnJOB/fmOnxQY9e+OF0zaI2XXJpmwh1TUBf9dycl5iEVLFilu3tnW+vFWtMc5WVwYyUJzpC1CqSjJ6El/aD7qaHzbSD505DJ2f1qozW9CVSRUNLkCIVGSzZfnLoafhtLjrw6/LScQa9vfv+4s0Qxxi3EBCWdevMyPYFOLattTW7GWTuF
 pnex3XIf
 kHILs87lA4r5TPqCGlxjU1RaNJnAAGeJ/kfOiHHLGAkYM7O+DDygykt/OM53RR5kWj2Kx+Y1IVl642cbiKDPpgaaRfQk+QRaY5Tw3iCHhkJZlwmyuKwkkNHUPo1AiCUf1OOBD+7Dplv2quSBTJPV/DXcPQotEu/TtivH6bbDxJuwcTRfDZfImO38EL8kbvE9fDPr2myuhVufuQGCSWJjj8PClgl7p9p0oz4Mk9V9vjXjuFO6zfAIe9WU/a3jZxYKYoS+DJwoLLvw1H6S4pxvND60POBaUIjFDZfqUNuKhFAknmxDN5dhxOIiWefbwcz7K0e1hwAbjH89ZZPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 21:24:30 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> Thank you for the detailed review.
> 
> On Sun, 20 Sep 2026 03:37:13 -0700 SJ Park <sj@kernel.org> wrote:
> > Let's break commit message lines with 72 columns limit.
> 
> Done in v3, here and in 2/3.

Don't post a new version without ensuring the discussion on the current version
is completed.  Also give time for others to chime in.  As a rule of thumbs,
ensure all questions on the thread are answered, and give at least ~1 day since
the last comment on the thread before posting a new version.

I will not review the v3.

> 
> > Why 256 MiB, not 429,496 bytes?
> 
> They are two different numbers.  429496 is where the multiply starts
> to wrap, and every size above it is wrong.  256 MiB is where the
> wrapped value lands on exactly zero: 256 MiB * 10000 is 625 * 2^32, so
> on 32-bit the product wraps around 625 times and ends at zero.

So 256 MiB means nothing special, isn't it?  Why you mention it?

> 
> > So, the way to work around is updating the size quota to smaller value,
> > correct?
> 
> Correct.  v3 says so.
> 
> > But why a sane user would set such huge number?
> 
> They would not, which is why v3 no longer argues the 64-bit case in its
> own paragraph.  The threshold is now stated once, as part of what it
> takes to reach the bug: above ULONG_MAX / 10000, which is 429496 bytes
> on 32-bit and 1844674407370955 on 64-bit.
> 
> > Because this patch Cc stable@, let's make super clear about the user
> > impact [...]
> 
> v3:
> 
>   Triggering this needs a scheme with a quota goal, the temporal goal
>   tuner, and a size quota above ULONG_MAX / 10000 -- 429496 bytes on
>   32-bit, 1844674407370955 on 64-bit -- so it is unlikely to be hit on
>   a tested setup.  Nothing is corrupted and nothing leaks.  The scheme
>   makes no progress for as long as the goal is unachieved, which is
>   easy to notice, and writing a smaller size quota restores it.

Let's put "The scheme makes no progress ..." before "so it is unlikely ...".

> 
> > > Bound the conversion, so a size quota it cannot represent falls to the
> > > ULONG_MAX the function already writes for a scheme with no size quota.
> >
> > I don't understand the above sentence.  Is the grammar correct?
> 
> You are right that it is hard to read.  The sentence was too long and
> tried to say two things at once.  v3:
> 
>   Bound the multiply.  A size quota too large to convert now takes the
>   same ULONG_MAX branch as a scheme with no size quota, so the
>   effective quota becomes ULONG_MAX / 10000 instead of a wrapped value.

Seems unnecessarily verbose.  I'd suggest keeping only the first sentence.

> 
> > > Widening esz_bp instead would reach the consist tuner [...]
> >
> > I don't quite understand above.  could you please elaborate?
> 
> Sorry, that paragraph was not clear.  It was meant to explain why I did
> not simply widen the type.
> 
> The other way to fix the overflow is to make esz_bp wider than unsigned
> long, u64 for example.  But esz_bp is not used only here.  The consist
> tuner keeps its own value in the same field, and
> damos_goal_tune_esz_bp_consist() passes it to
> damon_feed_loop_next_input(), which takes unsigned long and returns
> unsigned long.  So widening esz_bp means widening that function too,
> and the consist tuner would change for a problem it does not have.
> Bounding the multiply is one line, and only the temporal tuner is
> touched.
> 
> I dropped the paragraph in v3.  It argues against a fix nobody
> proposed, so it only makes the changelog harder to read.

Yes, let's drop it.


Thanks,
SJ

[...]

