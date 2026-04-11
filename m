Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94ACF3ED40
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 15:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0356B0089; Sat, 11 Apr 2026 11:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71776B008A; Sat, 11 Apr 2026 11:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986376B0092; Sat, 11 Apr 2026 11:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8808D6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 11:38:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 034C2140298
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 15:38:28 +0000 (UTC)
X-FDA: 84646681938.27.CE6B6E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B1194000A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 15:38:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D0kW5Ny2;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775921907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teB7nJjcZulmF+QqCRVlmL0vmT+6iIsw4Nm7u+ggIro=;
	b=nHw3+gkc2Gbo0hESJPCa4NV4JTQtSSs9NUZ9ZSxNoLC5WxRngsFf0dQiY8Bpx9xYon0nop
	1y7wbGyf/OL0PegNnMHL43n5i3hSPMt9+tb32mW7bRPvIca/8xXorjp8u5XnkOS6pyprNN
	lhvjsGqRwL08R9axEVL0emiIqHGYeGc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D0kW5Ny2;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775921907; a=rsa-sha256;
	cv=none;
	b=Al/Z8wDq2HTNUt8Hm3ZLt0SJYG7l8XgXG4xn7TMhpS4eNKPaC5z1TT0eiK/vkUKDNtcVfo
	Nh48WQZiW7GcsgodmWdWwVzV2dwOFoOowofC1ziuJLnld8DuY6lx/fnG2Zhremn/HIDNUH
	Jy6zRoi95IuRwa5jQ+WYNJbS+mPbSZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF4366015B;
	Sat, 11 Apr 2026 15:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A34C4CEF7;
	Sat, 11 Apr 2026 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775921906;
	bh=LTVxwT3Pm0EEvV5xqJRIkOmNdAWttHKTUm2Zvmwi/Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0kW5Ny2rEzuJC7NB9F436LQ3+nYyQ6M4KCJ+Mk3OGeedqiwuwdS39NUsi3gUSr/e
	 2CXz/w35j+x+NyeRdRagrrJSGuA4JXZdE06q+6r6KwsZWmGZQkNKgJLoFJy0ij+PO8
	 2smKxske3Muqjzw5mF7RdbHEfbaPdUR7yng/2CqoJG56d4fRUA+zQJEsT7VmMH2Vqk
	 lE0xoYGFg+RwqqE1JzVYOoTNmoKI9WWsz/jtLieMFCEeqdahqCUZzTS+fiL1hzdd5l
	 iRPEdUe9NWbMHiP+BMSPLABhwKmhmC1WH+cuCtc3FbPNO4kPgoqk0Q/Cci2wXi6tUx
	 kLH8PPaWHWIxw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Sat, 11 Apr 2026 08:38:21 -0700
Message-ID: <20260411153821.95491-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411000458.11479-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B1194000A
X-Stat-Signature: hsr8786rxk1kp8zq8e6frga1jknz3ypp
X-Rspamd-Server: rspam06
X-HE-Tag: 1775921907-348726
X-HE-Meta: U2FsdGVkX19KJUiTGzuzbafVoRTVghQoKHcC+qzdMyfHoI6NNCE27VfmFiSxUZP+iB+iBnqJYjr6BzucB2eOjZ1y649MU2T3SU+50ozIyuX3ikSfHOGX6D1TsoSPDdtyoyM47gJCA/msHxZ74Aw1Zoj/ZDeWmToQXpLJB6VZMr1q1Z5hzOLRe1e8o7cdEIVIy847dTs649jainNndFiUhWLBCjqkf/rKRK+W47KptZi8s76KCqsi6oarCO6UUkBU69D5UrGdYC6RzoW+Y0D6BRG6vDp1BXIP7qbEgwjYQXuq6s/prAUDTHIbC0lJ3VdnziF3Xt4pvyC6CZ8M0nFaQv8NG2Am2iDxELTC+VU+KoK5k8T8tIWI5poaAMUEIdwOVMpBNTOsx0PFqR5Z2q+roKP1gRCWZf/qoK63RIUx2Wuh2hncCsjEQy6gVZdRLat6DRrgznTGKTDFKfdSqB3MnB2pIQ7eAeGqEIFVDpufzz+I1KbG8ELcs3VSbYOOW+nvbLBWITmbfXFlDAE7R88f+B17XoYMjP7ii/NRmCYyW4zM9pNVLuLKAPiBb6tz9zqQLIFmReV6ShbXOvTrzlvj6wqxJl5xewuoeNhYoXwCBv0Hc1yl14ldIS/wKi9DOhpK1MJsz0GqOYShK+jaP0zKeOhcp6g59a0MAtEoVGRzkCbsrVgmtJwd7ejXQbnrXYsvGCi3G7CCwH0ZZ8stG7O+53Jb30TejHCGgw5FBIH69r4P9u6a9nbdwVw+l+3OwNKipc9KHYfqScxNigSof6LIFSV5DMUtEUprmcSVzZsJvEiImXSrwKD6DJd312MTfjfQnHXvFSoqCyQNaDQDxOYSkdG377/O7Ej01qnrRktwSGh1krIRjwfRCgMvUJVF4flsG/5hRYt7qqIoSVF9+pm4w5XJHIKYN+WlCPOiBtvnilhUwcBjpH2GPnrD3UsgLoKboSs6ce9FV4yHuu4J6WV
 FIG6eaMM
 Pv+mUHhK2eLgbqCo3/3Vkc7OvYpH22dVFsmbHR9fKbLjPSocp3Rf82wVL817CmpoJlcLx0XVUgpLXulltkyOc7epLH4cOgI9K0dZgXKmJD1WlnKOwdfEopFLfyv7ogTUxx8Tg9kBK1fdZx+Lzc89cUXr89tEAgzDHEat0qMANH/reau8A3guoOqnC6o05rML9Ob1sBDTH5V+ZJrhY0BNq4aspWB38wOJFa6M53U5s0vT1xF6hdKAJMLdGoR3QfqgVqyWWI2TMlYTJY2sFsu+8YmTmVhRE5RoQBojOBVEu0/SNTX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Apr 2026 08:04:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Fri, 10 Apr 2026 10:00:50 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Sat, 11 Apr 2026 00:46:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > On Fri, 10 Apr 2026 06:55:00 -0700 SeongJae Park <sj@kernel.org> wrote:
> > > 
> > > > On Fri, 10 Apr 2026 17:40:04 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > 
> > > > [...]
> > > > 
> > > > Agreed.  This was unclear to me in previous disucssions, though.  I still agree
> > > > it is out of the scope of this patch.  But now I think we need to let users
> > > > force-restart.  Adding this to my todo list.
> > > 
> > > Just to make sure - is this the same issue that my recent RFC patch [1]
> > > aims to address? I want to make sure we're not duplicating efforts.
> > 
> > Hmm, this makes me confused about how we ended up working on this series, then.
> > 
> > > 
> > > I'm still actively working on that patch, and I plan to send the next
> > > version next week. I've been holding off because I didn't want to send
> > > multiple patches in parallel.
> > 
> > Ok, seems I dropped a ball.  I was working like AI bot that only works with
> > limited and nearly fresh context for each mail that on my inbox.  I will work
> > on making another thing for tracking this kind of parallel works with good
> > context.  But since I already dropped the ball for this, I'd like to make sure
> > we are on the same page.  So I'd suggest below.
> > 
> > 1. Let's hold this patch series.  Andrew, please don't merge this for now until
> >    this discussion is completed.
> > 2. Please summarize your parallel works in progress with the context about how
> >    you decided to do that in the way, with summaries of our previous
> >    discussions.
> > 
> > Could you please do those, Liew?
> 
> TL;DR - There is no dependency between my parallel (2) works. I never
> intended to merge these two works into a single series because they
> address the problem at different level.
> 
> Yes, here is the summary of my parallel works and how I decided to
> structure them.
> 
> My current parallel works
> =========================
> Series A - min_region_sz power-of-2 validation (this patch)
> - Status: You gave Reviewed-by, asked Andrew to merge.
> - Scope: Small, standalone fix for specific issue.
> - Dependency: None
> 
> Series B - reset parameters (enabled/kdamond_pid) on unexpected
> termination (RFC [1])
> - Status: Preparing V2.
> - Scope: Reset 'enabled' and 'kdamond_pid' when kdamond terminated
>   unexpectedly.
> - Dependency: None
> 
> Summary of Series B
> ===================
> The design evolved through our discussion:
> 1. Extended 'struct damon_ctx' with 'thread_status' pointers
>    - SJ pointed out: "This feels too much extension of core API for a
>      problem that can more simply be fixed."
> 
> 2. Alternative proposals discussed:
>    - Option 1: Termination callback in core API (Too heavy for backport)
>    - Option 2: Override '.get' operator for parameters (code duplication)
>    - Option 3: On-demamd correction in enabled_store() (passive)
> 
> 3. Final direction comfirmed:
>    - SJ suggested: "Can't we catch damon_commit_ctx() failure from the
>      calling place?"
>    - We agreed: Simple, backportable fix is the priority.
>    - Decision: Reset 'enabled' and 'kdamond_pid' immediately when
>      damon_commit_ctx() fails, add a fallback in the damon_turn() 'N'
>      path.
> 
> [1] https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com

Thank you for sharing these.  But seems even this context is incomplete from my
perspective...

The Real Context
----------------

The real start of the context is probably the question [1] that you asked on
2026-03-18.  At that time, we found committing wrong parameters stops DAMON
without an user-visible error.  We agreed DAMON being killed is no problem but
the absence of user-visible error is a minor user experience problem that
better to be improved.  So you planned to make the user experience improvement.

Apparently series A is the followup of that.  The first version was posted on
2026-03-26, according to the changelog of this patch series.  I can show I was
saying the patch was confusing on the thread.

While the review of the confusing series A was ongoing, you posted [3] the RFC
of series B on 2026-03-31.  This patch reported one important finding: the
silent DAMON stop is not just a minor user experience issue but a serious bug
because it cannot be started again.

And this made things much more confusing. There are multiple ways to trigger
the issue.  Wrong addr_unit commit is just one of the ways.  We discussed the
way to fix the real issue.  So, by looking back this, I think you should
prioritized series B from the point, or make suer series A is only for the
minor user experience improvement.  Or asked me what to prioritize.  You didn't
and I missed the fact that you are also working on series A.

But you just continued posting new versions of series A.  I was wrongly
thinking that is still the minor user experience improvement.  I still think
the patches were implicitly saying so.  I'm not sure if it was intentional or
not.  But definitely it was confusing me.  On 2026-04-02, I started feeling I'm
missing some of the contexts, and asked you more clarification of user impacts
[4] and full history [5].  You posted v3 [6] right after I asked the question,
even without answering the question.  Only from this point it became clear
sereis A is not just a minor user experience improvement but a critical bug
fix.  Now I think you should clarify this can also fix one trigger point of the
critical bug but the real fix is work in progress, and this is till only a
minor user experience improvement.  But because you didn't, and my poor memory
is volatile, at this point I was thinking this all the work you are doing for
the series B-exposed bug.

In the response to the sashiko review on this thread, therefore, I was thinking
you are thinking the wrong addr_unit commit is the only way to trigger the bug.
I didn't want to ask you to work from the beginning to fix the entire bug, so I
was saying fixing the real bug for all exploit points is out of the scope of
this bug.

But now it is turned out that you were aware of the other ways to trigger the
bug, and didn't transparentl and explicitly exposing that.

So I withdraw what I told on the reply to the sashiko review.  And appreciate
sashiko developers again for giving us a chance to finding this.

Next Steps
----------

So, what to do?  Please prioritize series B, if you still willing to do.  It is
ok to keep doing series A, but only as the minor user experience improvement.
Clearly explain the whole context you are aware of.  Don't Cc stable@ for
series A, as it is only an incomplete fix of it.  The fix of the one trigger
point is just a side effect.

And For Future Contributions
----------------------------

Liew, I really appreciate your contributions.  You found and shared important
DAMON bugs.  But apparently your communication has many rooms to improve, at
least for poort DAMON maintainer who have to work with only limited resources
including the poort and volatile memory.  I find I was asking clarifications to
your mails multiple times.  I have to say it was even frustrating sometimes and
definitely took quite amount of my resource.  Meanwhile, from my uncautiously
biased perspective, you were only adding more traffic and confusions.

This makes me disappointed and even suspect your intention...  I really hate
myself suspecting someone.  But we are in the world of bad actors that now
gained the power of AI.  We actually had a suspicious case from DAMON
contributors recently, do you remember?

I want to still believe you, so I will do so.  Please feel free to keep
contributing to DAMON as long as that's what you want to do.  But, please aware
of the fact that DAMON maintainer has poor volatile memory and working with
limited resource, and try to make every conversation super clear and
transparent, from next time.

[1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
[2] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com
[3] https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com
[4] https://lore.kernel.org/20260402140314.74600-1-sj@kernel.org
[5] https://lore.kernel.org/20260402152915.75294-1-sj@kernel.org
[6] https://lore.kernel.org/20260403052837.58063-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

