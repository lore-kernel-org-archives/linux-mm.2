Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1543FEEB578
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B076B0005; Wed, 31 Dec 2025 20:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9046B0093; Wed, 31 Dec 2025 20:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC6D6B0095; Wed, 31 Dec 2025 20:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49F946B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:41:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A7F21A1217
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:41:18 +0000 (UTC)
X-FDA: 84281692236.19.FC1286F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B06920002
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:41:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DP+R3BPK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767231676; a=rsa-sha256;
	cv=none;
	b=bfQknwG6vDsphMF37bpGhVtftr7ieA1tNeCfCrmha3Kn1U/lx99mnXx4yzv/ij5CTAGYUu
	A8GRWurseQAN07tXuPvZ52QimieY4e/Cg/eeErDGzFFwT+/30z1jp8j9GNwDkJCqOJr9KS
	5CNAOsWG/QdapnU1QajUSOu0SZEA3vc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DP+R3BPK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767231676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTC7gPRCrT2QzFMuMt0G4X4B34WF/iwcY4UYAajwVNs=;
	b=shITpKd669kIsR9/FnERXReHdhlRBa+OKgZRTiEFL9f78uNAfwmANXYtc3mKEMHMJcqC9p
	MwKj+IspCsuM9/df6OZDZX7bb0N3+DaPg8yJLpAZyvRccISr29U6cdoe9EtA4CMIbYpm4e
	Q6nLayFU4uE8PsYU+aOsbJDYrUTGxfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 248B842ACA;
	Thu,  1 Jan 2026 01:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E0AC113D0;
	Thu,  1 Jan 2026 01:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767231675;
	bh=i+DdC/S+p6yii9OoNviXUJbL2K6hEFLW+od5/f/n/Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DP+R3BPKrBXAZp35hZceNI/0P1oEljZQ0xQNN2EJcKKah58GDrhXYxp+5ugPPBMt0
	 Mi2hLM6V88EPtnQktQh1aPdrRiVtf5eWxinXGwgYUhco5O64nusbCRDJzisM28jQBP
	 4AJ23oPfDlGWg7q4XdOSGTmS0amZOVol6bRzN9Ia9CGDoWKb2LK00NWI1EV2IOmJDr
	 MDJN0zTvc+27lszYmK0TnOuTZT/jhdY1V9ELHKhIYMJzMXDlirTMy1w/HfNuMKY15X
	 sFL4MPgmVZEWf1MLsj4HuEroxGeJvjxXsG+s6c0Ch7T0/XKMvyXtO6uj7rjE9WBPy/
	 NTwAwoNrs6/Bg==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
Date: Wed, 31 Dec 2025 17:41:06 -0800
Message-ID: <20260101014107.87821-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC4_unsc9u4kEDBTNxfS3rsiQi5QBTaiu3fGDcGrdryyBA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B06920002
X-Stat-Signature: 8fdq7a1sy5s1dgfjc7infousrtsp7buu
X-Rspam-User: 
X-HE-Tag: 1767231676-777281
X-HE-Meta: U2FsdGVkX19BiNeQW0M1zra2Di1W7Gj9ZMX0G8jMVt/tdutkzHafn+r4obZ+Mb9te1njVodYBdOcz44I86VGg+UapFmcycdcKaNSgSh+qj0oiR0I4R4RWDL4QvrKZUkVSnuaN7v31bdU7GBVSzvX2KWBmQ4l0eiSxCR5dmCw6+XoFDhmQ9uzDyKMJu8fCv5aE+ZGMC7ZVdYpi7fMLcs+mgY5VGGwI1A2/xP4l+uV2DUrjD3swO65aqe8hFL9OGQnY5DSJ46TveCrPVQzQFx+mqmROsihFANKDE4757loFNjkt0Tu1lhNyn6hYDn/aA8PbYTTUytLu7i+Qjbt7n0eWXAPJ7/dE04YGDlFVGnq+nPyKYL8Kbts/WEJEsAaF5iPtXTQjBXweqX9DOa4uWq2R5D34/gTriCjt1pohHaDNYNMIdU2C6JY+0Q69EPotM9lh0gTQERsmaIG3RpdRp1F45ak0zbSpje3+C963eWsJIodrIlWAyNXH6zNDA+pR6itvFC068Buw6stW73Wtr7BjGYtN8Wu35wZ10tZwnKJIaWDs6E8XYFx2evY/A0+uFFTnMw0nzfBD3atyIFTJHv2uu4cM2iBFjlbJ5vUHAtGbYQjqR+qTKsT8UquEOsRf6rmXDiF9S9bcZNHvxOX9Lp68Cv0NqnCpvpTcvt45KcS2/K0u47FJWqKVrHrlxpxnzjIHym3CWNP+7GhM9PYYiZBURPAssC5Ijs4+EhnUXck/ANeg92AdhR4ri9UZ8fDlSX5Hb3T4NMAEogAOCZizCr5su+Dbm7KVFDqFdgAigMX3t24oMxpiVLSvU6ZCoedcGUscHdCV6M7XrB4Z249CQPnU6sjU86OELt6EmPNXC0j+LeY/lpJm45zIa1bG+zBN1YH6Xz4u6VCafBmEjRJtObbvaiOxMq2abVbFrj9AjsyYwuZBhcGBelqe059qnB/h5cl+KwDjUVFnafhy3SvrA0
 y9RiSq/u
 nNXVqCwMQEq2BfudC/7foQaY6LGjEMHHo7ZCHVLbmHSLoYJcgYNLCXn6TSZl3TbrIuk4ZCT1kx3C41CjgYYuBjuz5rFlwnmS02WHwsWD/xF8r05RS9O9MH9yklLN9bVBu215kslKqOerMsV9l5p7oNfyr258hQW5Wv0ojf/6L74CWsZNS/D+eW+bjFN3DQ7iKezS7KsuEJnA7jFPuVR53+28GHH1jT0Apg2fr/DfWzKruVECkW409V/ffOfZUDt9odAAEQ/peAzlbZ59mLqjyg9XqxQBJCrMmhuwXpR0ENbFqnkY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 09:55:56 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Thu, 1 Jan 2026 at 00:26, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 31 Dec 2025 14:27:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Wed, 31 Dec 2025 at 10:25, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Mon, 29 Dec 2025 19:45:14 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > > On Mon, 29 Dec 2025 18:41:28 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > > On Mon, 29 Dec 2025 17:45:30 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > > > > On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > > > >
> > > > > [...]
> > > > > > > I will send a new version of this fix soon.
> > > > > >
> > > > > > So far, I got two fixup ideas.
> > > > > >
> > > > > > The first one is keeping the current code as is, and additionally modifying
> > > > > > kdamond_call() to protect all call_control object accesses under
> > > > > > ctx->call_controls_lock protection.
> > > > > >
> > > > > > The second one is reverting this patch, and doing the DAMON running status
> > > > > > check before adding the damon_call_control object, but releasing the
> > > > > > kdamond_lock after the object insertion is done.
> > > > > >
> > > > > > I'm in favor of the second one at the moment, as it seems more simple.
> > > > >
> > > > > I don't really like both approaches because those implicitly add locking rules.
> > > > > If the first approach is taken, damon_call() callers should aware they should
> > > > > not register callback functions that can hold call_controls_lock.  If the
> > > > > second approach is taken, we should avoid holding kdamond_lock while holding
> > > > > damon_call_control lock.  The second implicit rule seems easier to keep to me,
> > > > > but I want to avoid that if possible.
> > > > >
> > > > > The third idea I just got is, keeping this patch as is, and moving the final
> > > > > kdamond_call() invocation to be made _before_ the ctx->kdamond reset.  That
> > > > > removes the race condition between the final kdamond_call() and
> > > > > damon_call_handle_inactive_ctx(), without introducing new locking rules.
> > > >
> > > > I just posted the v2 [1] with the third idea.
> > > >
> > > > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> > >
> > > I generally agree with what you've said so far.  However, it's inefficient
> > > to continue executing damon_call_handle_inactive_ctx() while kdamond is
> > > "off".  There's no need to add a new damon_call_handle_inactive_ctx()
> > > function.
> >
> > As I mentioned before on other threads with you, we care not only efficiency
> > but also maintainability of the code.  The inefficiency you are saying about
> > happens only in corner cases because damon_call() is not usually called while
> > kdamond is off.  So the gain of making this efficient is not that big.
> 
> The overhead isn't that high, but I think it's better to keep things
> simple.
> I think it's better to use list_add_tail() when kdamond is "on".
> 
> >
> > Meanwhile, to avoid this, as I mentioned on the previous reply to the first and
> > the second idea of the fix, we need to add locking rule, which makes the code
> > bit difficult to maintain.
> 
> I think it's better to solve it with the existing kdamond_call(ctx,
> cancel=true) rather than adding the damon_call_handle_inactive_ctx().

On my previous reply, I was saying I think your suggested approach is not
making it simple but only more complicated in the next paragraph.  And I was
again further explaining why I think so.  More specifically, the added locking
rule, that I previously explained with the third fix idea.

Your above reply is saying it is "better", without any reason.  It even not
addressing my concern that I explained more than once.  As a result, I again
fail at finding why you keep repeating the argument.

So, let me again ask you.  Please explain.

> 
> >
> > I therefore think the v2 is a good tradeoff.
> >
> > > As shown below, it's better to call list_add only when kdamond
> > > is "on" (true), and then use the existing code to end with
> > > kdamond_call(ctx, true) when kdamond is "off."
> > >
> > > +static void kdamond_call(struct damon_ctx *ctx, bool cancel);
> > > +
> > >  /**
> > >   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
> > >   * @ctx:       DAMON context to call the function for.
> > > @@ -1496,14 +1475,17 @@ int damon_call(struct damon_ctx *ctx, struct
> > > damon_call_control *control)
> > >         control->canceled = false;
> > >         INIT_LIST_HEAD(&control->list);
> > >
> > > -       if (damon_is_running(ctx)) {
> > > -               mutex_lock(&ctx->call_controls_lock);
> > > +       mutex_lock(&ctx->call_controls_lock);
> > > +       if (ctx->kdamond) {
> >
> > This is wrong.  You shouldn't access ctx->kdamond without holding
> > ctx->kdamond_lock.  Please read the comment about kdamond_lock field on damon.h
> > file.
> 
> That's right, I misjudged.
> I've reorganized the code below.

Your reply is not explaining how the reorganized code is solving it.  Let me
ask you again.  Please explain.

> 
> >
> > >                 list_add_tail(&control->list, &ctx->call_controls);
> > > -               mutex_unlock(&ctx->call_controls_lock);
> > >         } else {
> > > -               /* return damon_call_handle_inactive_ctx(ctx, control); */
> > > +               mutex_unlock(&ctx->call_controls_lock);
> > > +               if (!list_empty_careful(&ctx->call_controls))
> > > +                       kdamond_call(ctx, true);
> > >                 return -EINVAL;
> > >         }
> > > +       mutex_unlock(&ctx->call_controls_lock);
> > > +
> > >         if (control->repeat)
> > >                 return 0;
> > >         wait_for_completion(&control->completion);
> >
> 
> +static void kdamond_call(struct damon_ctx *ctx, bool cancel);
> +
>  /**
>   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
>   * @ctx:       DAMON context to call the function for.
> @@ -1457,11 +1459,15 @@ int damon_call(struct damon_ctx *ctx, struct
> damon_call_control *control)
>         control->canceled = false;
>         INIT_LIST_HEAD(&control->list);
> 
> -       mutex_lock(&ctx->call_controls_lock);
> -       list_add_tail(&control->list, &ctx->call_controls);
> -       mutex_unlock(&ctx->call_controls_lock);
> -       if (!damon_is_running(ctx))
> +       if (damon_is_running(ctx)) {
> +               mutex_lock(&ctx->call_controls_lock);
> +               list_add_tail(&control->list, &ctx->call_controls);
> +               mutex_unlock(&ctx->call_controls_lock);
> +       } else {
> +               if (!list_empty_careful(&ctx->call_controls))
> +                       kdamond_call(ctx, true);
>                 return -EINVAL;
> +       }
>         if (control->repeat)
>                 return 0;
>         wait_for_completion(&control->completion);

I think my previous concern that raised to your two previous approach [1,2] is
again samely applied to the above diff.  And now you are suggesting a similar
approach here.  Please explain and answer all questions before you move on, or
explain why your new apprach is different from your previous one and how it
addresses raised concerns..

[1] https://lore.kernel.org/20251225194959.937-1-sj@kernel.org
[2] https://lore.kernel.org/20251226184111.254674-1-sj@kernel.org
[3] https://lore.kernel.org/20251229151440.78818-1-sj@kernel.org


Thanks,
SJ

[...]

