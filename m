Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A8EC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054AC6B00A1; Tue, 11 Aug 2026 00:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005A86B00A2; Tue, 11 Aug 2026 00:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C8C6B00A3; Tue, 11 Aug 2026 00:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1ED06B00A1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:35:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CC8B12036E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:35:36 +0000 (UTC)
X-FDA: 85087725072.07.B654136
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 742DF140008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:35:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=prrXaUSf;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQSvTdqN4SshKtnVLc6M0cv+xfMXZGr5TBSWuIZ8vc0=;
	b=xYQpadfSQcKKpxj48S1bpsFJ4YHQ4O1UuTX1cfYKaXik3tDHTCIOL51AeZIo1hnD4BQ9Fs
	ogsF0HBHo3lMoLxZVpA63+52M59z7GR1+lIfr06vTAsbE3IgpCd3uzv0sXW/cqICebbEJq
	x491JZOVQ70A1huykUfU90WkpwT3WBM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422934;
	b=l87ogU4Ep57ZetCM1dTK82nWYTugb90JVQ+0NRoUuYaInktm7WlZXUEoJZif3x2nMDcXaN
	b2t1TGSyCaJOr4sL6I1IyaeG2VKhwzlo8o5oHcEaKVk4ihuNsSfpjDCc4bUbhavxdJLU1N
	JUhHkw/LtsThKPTt533KIQ8E9l+++xw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=prrXaUSf;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 10 Aug 2026 21:35:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786422932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQSvTdqN4SshKtnVLc6M0cv+xfMXZGr5TBSWuIZ8vc0=;
	b=prrXaUSf1QXdgNwKtyVDepoBOmYOCGGbMXmay01RBwAVtVU9Z5I/rJhnxMPqyrrAvubMXE
	W3DmPRd5TNw5/hEitBoeS+JWOmxcOWhIxhqQ4/+pM+3Wgjt6UoN6+VE+bE0kYl+sfBnuLW
	Q9QPlSNy+pw7NrE30/l3N2+OkM38g6g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in
 zswap_shrinker_count()
Message-ID: <anqmAJKQ61CDlBiR@linux.dev>
References: <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org>
 <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
 <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
 <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
 <CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com>
 <CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com>
 <CAAnvDSyDYU4MvRo1rNwxQcnmwHe2_UW43-hZEU-Zf76B2euYQQ@mail.gmail.com>
 <CAO9r8zOPMNDQWZ8z+RsApbA0cddE1au5hTHdRT0NYe-EjmP4aw@mail.gmail.com>
 <20260810200915.8461c16060fe1b79c18bced2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260810200915.8461c16060fe1b79c18bced2@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 742DF140008
X-Stat-Signature: 45o75q4ok9xwoyzge6fm6ge4owu8hwcn
X-Rspam-User: 
X-HE-Tag: 1786422934-884292
X-HE-Meta: U2FsdGVkX1/IgLCorp3UjtFtvr+JfSQwEfhy6jKqF2qp5+FoWpBlwKd9L18ffOITlBAB3vsgF1hUmVPhrns126xOKEV7UGWZZmi5RIw3e49ESN/P5zOGa1lbyl1gTU0d7yUpXnrcf5DPJvtTSzc/J+G5vsj3/B9kEwwwdYDPO1j5VZFw/eoP0BJa0JqSlxrMI7a5O1lbWJOMEZJyKzkQXx6c2qqauYyOjOW41dTYN4NbiwJWDQZCDS40mQdLCcPuxJNsCLSGCEG32leD+cpV6dgUHijROvjCHTwSpL1EZr0AslGKV6KtiPb9x/tMuoEirtDtBT1daknc8VB1yTWmBIzwP2vA7rk8Qk0NneSE/f8nDGilBxDlao9J40dJLqyo1pEwxGry2CR0yw+CrYv7MJccTvmqdPgN+VhnzXjMuYJV3MnOn1LcyOSQKJ7AzYdpI42ITMXvKP7RHp7dk18TRfVGtNIFksvtfBDoL71CFydVPlKqG1Z9Z1TIYDoetK2cuYebEzC3+6GS2NH+h1c1yNnM4zEZNsXB/VqFSQFABqDRhWmno0/o9AldPjLb4E6gtUbKJwa+OxAwQD1UiWXLdmQ9Ob624VPb3xWAQuRv9/N2KXjYm+R2+GJP/rJtMTlA8efwJ6QusiGk4481JOoMo7HeLNcfQA3Z0zpLayEoBCVQpgM5vkWg6hpcZonnn9gHQ/te7Es2cRvMJBNKWNuAhbS/VvBwUItEYL3N/7oT6x4L5bYmGeIM3lswGBBHxflwvBGLawfAA6WmONCRwVA6DrXcdcrtumg6e+SC9txRAIfdSSSSeIW3wQ1Q1lpSFaxDyRxpaBrwOW/IIXjMMtWtumso77CThhBAfBZrYCUED+glF43/sPqnTO9asfkBoJ5o8LwjU6qxUcum4OJRYO2YMWlJNbDkXNvz59He/AqO+6gOIP5EEZED0enSx8psG62F/+HKvC88+/pET3vYqMM
 l9Y6ssMW
 aJEL6kT3514R6uKts9w5PwWc0q+q0Iufem5nS9bFZvYgbN/wztcBvT1vtL+5z8ACIPUjswZwTv2oGFKuRU31vx/q227U1iUan4K2UqnH+BwLfXpYR9OLzZ8aVkKeRMXKJNHdV1KpTOyXDcmAaynEWWsbBV9BLCag/H1a4PzdIb4AgAf9HV+KZjVYgD7uzIkkhnPAUUaxYKCrIVRG90D6Qif/ZKNJV2NplrvYR90lhreGESTxZIiRFqemEjK5NPaH66JqtRkkkeGNTi0sppYvRvl5fGYZpLsd39cYM2HFYURNPXI01ByRDkj02ZL+bb+zA0oHUjI/bIJHUCgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 08:09:15PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 11:27:31 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
> 
> > On Fri, Jul 10, 2026 at 9:36 AM Yunzhao Li <yunzhao@cloudflare.com> wrote:
> > >
> > > > Yeah the per-fault latency is exactly what I was looking for. Seems
> > > > like most of the faults are not faulting in the pages written back to
> > > > disk, nice.
> > >
> > > Yeah, at least for our workloads the cold entries seem to
> > > stay cold.
> > >
> > >
> > > > Would you be able to take a stab at eliminating the flushes as I
> > > > suggested above as an alternative?
> > >
> > > memcg internals are a bit out of my depth to be honest. I can
> > > definitely test a patch on our fleet though and get it verified
> > > if someone picks it up.
> > 
> > I can try to come up with a patch if you can help with testing, but it
> > won't be for a week or two. How long would it generally take to verify
> > such a patch?
> > 
> > > The ratelimited fix in mm-new is working well for us in the
> > > meantime, so it'd be great to keep that moving forward.
> > 
> > Hmm we can keep it in the pipeline for now and perhaps drop it if we
> > can get a proper fix before the next merge window. Does this sound
> > good to you?
> 
> So it doesn't seem this will be happening.
> 
> The original ratelimiting patch seems useful, is well-tested and
> well-reviewed.  I'll plan on upstreaming it in the second week of the
> merge window unless someone stops me!
> 

I agree to proceed with the patch. Since this is not exposing any api, we can
always come back to reevaluate the decision.

