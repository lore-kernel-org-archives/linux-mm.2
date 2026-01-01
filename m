Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8191EEB577
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 00:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341346B0088; Wed, 31 Dec 2025 19:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF0A6B0089; Wed, 31 Dec 2025 19:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6F36B008A; Wed, 31 Dec 2025 19:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09E866B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 19:56:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C09D1AA228
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 00:56:10 +0000 (UTC)
X-FDA: 84281578500.18.EF554EB
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id C80C880007
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 00:56:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Em01uN9Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767228968; a=rsa-sha256;
	cv=none;
	b=guu9uskv71NmBOlb3BiOViPSJBrIk8iAS/UqtnRu0oniLjCPgwTmVntktdtYCfm4I5yers
	/TgsNCKtNP17dYuERDRwzB5tBgUr0C5sPtnADhQZKi/oaorJ7ePxd/N20Mwnt0SFCmx5Hs
	+V6tSe0Flic34c4HQxep7rs3gsiP7qI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Em01uN9Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767228968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyNFHU4ughVI0kV2KMWlLZk3LMIAUnwijKyFOE7M0sE=;
	b=ld/adMFI2TbzS6ZkUGkaDlU25n1ZPD54WiGOsDkAGQTORT+EKpKtLdHmyePxISebw3vMV8
	j3WJDshbXTFzUWdy739+RLVGlLVQeRvD0SBZujJMnF7X7ggWiuoCCOafRydXJd235s46OC
	xT5Fus7G4YjYSnpGWuvPJjnZ4P5JLI0=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-78fba1a1b1eso134324197b3.1
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 16:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767228968; x=1767833768; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pyNFHU4ughVI0kV2KMWlLZk3LMIAUnwijKyFOE7M0sE=;
        b=Em01uN9ZSm7hOdVKXsOAKWYUG8Scl5GGDrhxeIM7XH5ULK/ybT6UHLyZy9atvF3IRo
         kBZs/SgZifsclEpOdnwjKnvr3XBhXJs2q3y80AO1ouHeU0dfK6XnKZ/i38ysrLQ45mV+
         DhJyRHWRMHZjs6PceFtIDFClpSZebCUokY+acGd/8nMeKYg9u4PSsvqbhDu2q8i1cxeC
         8a5sHmUqRUd33z/mOQ65faScHIYZoN+2YJPqIEPevpm1HWUfzSBxmOAjZlZdCNWd6m2q
         7qZQa2rI+umH+E1EGZM9D45aFG6qPkCNT5D0mjE46WUwt8nZHeJUQKLy3bnyd7e0lTnh
         lJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767228968; x=1767833768;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pyNFHU4ughVI0kV2KMWlLZk3LMIAUnwijKyFOE7M0sE=;
        b=k9fggXvLmg2BZibANk61CqewCfrBz71SGXGeIJmOwIpWJw7c9REPifeuE+u3rFUoyv
         GqxoPsP+FDLd5YNTa40MTEmRjIjNyCF+ZshRJrosT3TOT1Um6zf2F6lP9kHzYU9NIL7j
         p2KJnHmknoQYqCduY+55XRSM0pyyb2IuaIdj1Zw1fHcMvzY9DhwdgXTM4KnjN3rqrE65
         pPp9LG9xQ2UthvNiLpG82e+7DIc5U0NIelGZPupoSb7oqI3YUhcdpQk4987slC1B1y7J
         uEpDrIt0DRaDvaINBPhTUw1iyWZL4DLOav03CZlS4x4OpvQDkVjrCWigTGSQObqHBc9w
         juFA==
X-Forwarded-Encrypted: i=1; AJvYcCViIRq3PyZ19U3IXQv1CEmhFxNJju+IIu3NB/+MQ0dOFMOW6Vc5z6ff+/hzIVsI+PfEXuplGzkySw==@kvack.org
X-Gm-Message-State: AOJu0Yx68afWpTW6Au3WOr2KpZBp/7PTePrSZUm7Sl/9W/C/ApTkimfD
	qJ8WH+QUaesfnlYqDlJMBSeca0xbW54MNDge6GEv5mFqSV99nSeDq1N+cEdflns2y7Yu6iJ3Cq7
	1kRfwpe+lT972JhZ6KQaPQ0lSzwAyMiQ=
X-Gm-Gg: AY/fxX5nHPOf6KIOrBYFOt+ZPKpspY6S5muR8sYFkqrkjfEDLRDDRHWzWErTUV8bgzf
	LydBd47sbpvTlG7RK8lKRL8C2rvS7xdowLJenlxQQQKl5NTygtuvsl6T9idnox1ALP8hYWtIOen
	nelawh1KsemQdGwviYdyt82iou4M9ZK1ucTRFqow/5xKzmkPd9m2hQH6s6nQtCOQPTWHxPH8Duk
	nKZdUVW1Tx4dxHyxZn2BiC5JLFzPVUz0sg0oDtJZ8IpPbouP8anwsM7cScM+30QeTavYkpd
X-Google-Smtp-Source: AGHT+IFJClY5cvw4t2ao24FSwxCQPmReOjoGPKIaWPe4wwUUqq+ToMWXrNF7UTqHic2eYD1gI6W3btX1uZ28DHWmf3Q=
X-Received: by 2002:a05:690e:e85:b0:646:7b7c:2faf with SMTP id
 956f58d0204a3-6467b7c3083mr28119251d50.20.1767228967798; Wed, 31 Dec 2025
 16:56:07 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6F5zLnBF=v7G5k1WdDZZmkBAK94ixzLiPF0W53wdtyeA@mail.gmail.com>
 <20251231152617.82118-1-sj@kernel.org>
In-Reply-To: <20251231152617.82118-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 1 Jan 2026 09:55:56 +0900
X-Gm-Features: AQt7F2oDGlk4DOh69AZQt05dl7jK2z1FaYePTiI_hMVFnytUE4ig0iBuv4p53UE
Message-ID: <CAHOvCC4_unsc9u4kEDBTNxfS3rsiQi5QBTaiu3fGDcGrdryyBA@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "# 6 . 14 . x" <stable@vger.kernel.org>, 
	damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C80C880007
X-Stat-Signature: w5p1dwwfumtaqtrq5eu4tacid937gmcb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767228968-109755
X-HE-Meta: U2FsdGVkX1/QxQeMpA6jeVAUtVfnVi6ZzevdcKPFh7RjshjJ+Yvmq8CJvC+cFIrDr8dSNbjRAw0A6h7LfCg8DkTVUX1hmlNlhmzSMrieqgDHKgIu2XjvYT751D+dwbFlhaInGw+w60kuiH2xMAHabpUOK194Qj9olbKPHsC4WN0cADyznI048ybI3P3aa24z+iCJXf3zvnqKmg5jvmoDK8j/kw43n9hvhpEHfcDWY5fw3wHaI3ai/KKZgWW/KVl8jPDIJ1vxBq/Fn8Yr9qB2zBV1Ra88WveQuoopKdvUnHlbfkcRWANQRBwSTMGvaIZoYBywmjruUQJeId10gI4lrqVS/UoaXgn/Btm+5q7tTt9f1bSqI8KEe3ndCDDwM3KY0VC5DqA+VXok/wwQit6MDUP6MxiQlKP+h3GomPkhEK40ajzAFxGjCloN8bYhoyWo1QeBXrailbnhcKrQBdf9ZP+OBRhErlfrUulAHoRNu0+bD/hj/++vSeT3L6GWMR/E2VqgrtV9OiGeSpmZ/vB8Ock4YIBqXz5muYOW1g8yQ+m5UDoOsi2ownoibhtVGiItFGbANHy/0nSImXlt4GyrHl34YHBzKt89cuBuoPem9MBlcsmwLBYqashqnAsQWSLqZ8Mw5819fNJ0IJJBaC3TB1oNXekn7cLhNjhl2bqiS21K+o7IXrvmo4f2nNgWrMwoY6FIrd7zCl1TlVCzQyY6nLwa/MhSgdARLhZUT5fbZ6MCVJ5a5f/HVbSLyVre1tDoj2tU9vfcVIr4TPsnxzxLJO1RfT8YiEoPm+T0OKM0XE3WuGQM/35m70FsgKlyAKNrktjnNT83pZxAYTX/ioezj/6odt8TX0KwhR8Jy3hfBk2IlRDhosliUgoNLEyQbOXv6dMjXfr/drR1PWscZkAe4fynzFWjNojM2C4M3lhYWG8t1CHnvO4f54aWz5ZRqHMqJAATnsJ8OG1cJU8+SID
 aTxk0Myx
 VX5F4yzS2nI9oZQTiLBkHFRh4AW103384zcQT6mSqmaXkdWtCoKju6fASAdksfwvRv1alYSFv2dgeHmAbrNYvg+/Yd0Xh+LHCGa206mrYy5wq9uB6hVGyNGl9vVdzjMrTjzAMcoDz9cpWP4bddWnvOOJJ1oCsC53aqW1kmWi6LlG45GXAJ3flXATtoVxaPQnl3eGc9eb8kB9IpvHpgV74jawRwa+UvT/sUmXkEs4kmi/uxQUnTJgC+C0+H+zF1rwg57zIlrM3knD47mMVhptXVVpw0RQwqq6qMJh/KImHbFbs2J3h/t4VJpc7Nc1h7+6Hai+c3CDWGzN+gf/uQtrGwqoCIQqKw2OKekmUHBD/Un5Nz3wDtqv399wNpqqnT1kGE1F57tiTBIrnP1/fsxZ6ARkPJeEEdybVUm4n/jwoAtVPxO6/xuEx7wldjvJK1KIFf6+B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 at 00:26, SeongJae Park <sj@kernel.org> wrote:
>
> On Wed, 31 Dec 2025 14:27:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Wed, 31 Dec 2025 at 10:25, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Mon, 29 Dec 2025 19:45:14 -0800 SeongJae Park <sj@kernel.org> wrote:
> > >
> > > > On Mon, 29 Dec 2025 18:41:28 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > > On Mon, 29 Dec 2025 17:45:30 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > > On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > [...]
> > > > > > I will send a new version of this fix soon.
> > > > >
> > > > > So far, I got two fixup ideas.
> > > > >
> > > > > The first one is keeping the current code as is, and additionally modifying
> > > > > kdamond_call() to protect all call_control object accesses under
> > > > > ctx->call_controls_lock protection.
> > > > >
> > > > > The second one is reverting this patch, and doing the DAMON running status
> > > > > check before adding the damon_call_control object, but releasing the
> > > > > kdamond_lock after the object insertion is done.
> > > > >
> > > > > I'm in favor of the second one at the moment, as it seems more simple.
> > > >
> > > > I don't really like both approaches because those implicitly add locking rules.
> > > > If the first approach is taken, damon_call() callers should aware they should
> > > > not register callback functions that can hold call_controls_lock.  If the
> > > > second approach is taken, we should avoid holding kdamond_lock while holding
> > > > damon_call_control lock.  The second implicit rule seems easier to keep to me,
> > > > but I want to avoid that if possible.
> > > >
> > > > The third idea I just got is, keeping this patch as is, and moving the final
> > > > kdamond_call() invocation to be made _before_ the ctx->kdamond reset.  That
> > > > removes the race condition between the final kdamond_call() and
> > > > damon_call_handle_inactive_ctx(), without introducing new locking rules.
> > >
> > > I just posted the v2 [1] with the third idea.
> > >
> > > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> >
> > I generally agree with what you've said so far.  However, it's inefficient
> > to continue executing damon_call_handle_inactive_ctx() while kdamond is
> > "off".  There's no need to add a new damon_call_handle_inactive_ctx()
> > function.
>
> As I mentioned before on other threads with you, we care not only efficiency
> but also maintainability of the code.  The inefficiency you are saying about
> happens only in corner cases because damon_call() is not usually called while
> kdamond is off.  So the gain of making this efficient is not that big.

The overhead isn't that high, but I think it's better to keep things
simple.
I think it's better to use list_add_tail() when kdamond is "on".

>
> Meanwhile, to avoid this, as I mentioned on the previous reply to the first and
> the second idea of the fix, we need to add locking rule, which makes the code
> bit difficult to maintain.

I think it's better to solve it with the existing kdamond_call(ctx,
cancel=true) rather than adding the damon_call_handle_inactive_ctx().

>
> I therefore think the v2 is a good tradeoff.
>
> > As shown below, it's better to call list_add only when kdamond
> > is "on" (true), and then use the existing code to end with
> > kdamond_call(ctx, true) when kdamond is "off."
> >
> > +static void kdamond_call(struct damon_ctx *ctx, bool cancel);
> > +
> >  /**
> >   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
> >   * @ctx:       DAMON context to call the function for.
> > @@ -1496,14 +1475,17 @@ int damon_call(struct damon_ctx *ctx, struct
> > damon_call_control *control)
> >         control->canceled = false;
> >         INIT_LIST_HEAD(&control->list);
> >
> > -       if (damon_is_running(ctx)) {
> > -               mutex_lock(&ctx->call_controls_lock);
> > +       mutex_lock(&ctx->call_controls_lock);
> > +       if (ctx->kdamond) {
>
> This is wrong.  You shouldn't access ctx->kdamond without holding
> ctx->kdamond_lock.  Please read the comment about kdamond_lock field on damon.h
> file.

That's right, I misjudged.
I've reorganized the code below.

>
> >                 list_add_tail(&control->list, &ctx->call_controls);
> > -               mutex_unlock(&ctx->call_controls_lock);
> >         } else {
> > -               /* return damon_call_handle_inactive_ctx(ctx, control); */
> > +               mutex_unlock(&ctx->call_controls_lock);
> > +               if (!list_empty_careful(&ctx->call_controls))
> > +                       kdamond_call(ctx, true);
> >                 return -EINVAL;
> >         }
> > +       mutex_unlock(&ctx->call_controls_lock);
> > +
> >         if (control->repeat)
> >                 return 0;
> >         wait_for_completion(&control->completion);
>

+static void kdamond_call(struct damon_ctx *ctx, bool cancel);
+
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:       DAMON context to call the function for.
@@ -1457,11 +1459,15 @@ int damon_call(struct damon_ctx *ctx, struct
damon_call_control *control)
        control->canceled = false;
        INIT_LIST_HEAD(&control->list);

-       mutex_lock(&ctx->call_controls_lock);
-       list_add_tail(&control->list, &ctx->call_controls);
-       mutex_unlock(&ctx->call_controls_lock);
-       if (!damon_is_running(ctx))
+       if (damon_is_running(ctx)) {
+               mutex_lock(&ctx->call_controls_lock);
+               list_add_tail(&control->list, &ctx->call_controls);
+               mutex_unlock(&ctx->call_controls_lock);
+       } else {
+               if (!list_empty_careful(&ctx->call_controls))
+                       kdamond_call(ctx, true);
                return -EINVAL;
+       }
        if (control->repeat)
                return 0;
        wait_for_completion(&control->completion);


Thanks,
JaeJoon

>
> Thanks,
> SJ
>
> [...]

