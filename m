Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BC6EEB56F
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 02:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450B46B0005; Wed, 31 Dec 2025 21:58:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF146B0089; Wed, 31 Dec 2025 21:58:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0246B008A; Wed, 31 Dec 2025 21:58:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3A86B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 21:58:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADBD51A14AF
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:58:35 +0000 (UTC)
X-FDA: 84281886990.06.38D06AF
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0EB3F20004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:58:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nwc974lq;
	spf=pass (imf03.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767236314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9qPVyC1carZwgVVH75m9TaECbDsPsKfFm26AaARR8o=;
	b=vHe+tBNMPCb/blA3kY9IaJzX8ZaAj/F4p7SmM+ncKx7cIJH+hPqTsl9IT6EIMNMVjHlro/
	RUdiBCHl/IWJB+//OTYKK6CxZpVMzs3u83KMMOFPd0So0O9HoBfFUavLk7cJ6DDs4UZfiJ
	JG6Vy3nJVyYICO0UUj8B8UxzoPhZoy8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nwc974lq;
	spf=pass (imf03.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767236314; a=rsa-sha256;
	cv=none;
	b=309EzJAU5HrkjiXNjy34UH9PR5ldrFoI7E6Jf92w/16Q+ni/rdJa3Gnsq/nb+CpgnbXtNd
	1Lr8uAinrMK5M9rvLj/yjnN5C3lHdNktTHvbPctbLiuZ1VDC1hPme2BCrY4e7cX+Kfnoay
	A3YGCPCToh9bnoNu6ZRUAezSziL00co=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78f89501423so126911697b3.1
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 18:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767236313; x=1767841113; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k9qPVyC1carZwgVVH75m9TaECbDsPsKfFm26AaARR8o=;
        b=Nwc974lqC49NSN0Fyomb87W8xneQKhLaonkzXdOW6/lqnc2bogdTpe0zWjDkyItE6c
         A2uJsJezuBrwZchCKvsPj6y2GXWYuxMZOMgP9vwcPsqybVsBNhOziXth09byNLvOgSWi
         fO/j2GPVt6yFyCHfpDAv+7PNigUGoFinmRMbUz/ZmTdPnYteND/8KHn7+eQxmy/VGAhR
         +HgiCx6g6zzzCCsneQU3SiWkKxr+aSnGgFEMG28emLx90ylSGytT/2deuyCD6Cl0j2zH
         SApjtWufEWTw4Grp+6y7OZuzamW/uJojnFznfB1VEsmBsWf3sfKMWm+oSczoJDnjWko2
         TaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767236313; x=1767841113;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9qPVyC1carZwgVVH75m9TaECbDsPsKfFm26AaARR8o=;
        b=Uf3yJIHa9cUWva2tY72D+ItDm5kLJaXwTz4/qclKKYlXFOxTmey9l1++jyEHaTuXfg
         lvqTNp1UFlV2AfcRh/Sll/2Pr+d1wFOrFZs/6czxzACbA8lpXR0OYbiaytyXaP59A0iS
         HaT34XQW2n3yMAt4FHo2ejcUTB2Ys318pE0MgoytG2XoodVLd9nqPkmlocO3dal5K/We
         3jWuCulFyOk7NdiRbqoBaMqz14O02Zq0ziVzcZrHfqZpM7Vc7AapkcN4vFZL7ASOBJ48
         rF0ZPbwgoP/cIIX3Fro4SgufNH9lNYW5p2osDrU/fviY+XuhXFT2/h5z2Rh8B+kZi+Mj
         L5Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVNpLVONVtdEB7/6XeDY6fiNESZ76rU0RNnbROB4kiuLUj65EgLXNAwVYHjmU5Wb5ueoaajB857WQ==@kvack.org
X-Gm-Message-State: AOJu0YxOsvhTtFgndOmaUb06QwK84QeUZfNczfcaBK8aXDbJU/47qSJq
	yoRGqqZNr4ZZRy7gg3gmvT0paENuHY8yhPaRywVUwxKvWLPtFt2pqZvGBOrQjI+ygQVQ5D8vtrM
	+6ribFk2K2/D5ZVRVZ68i8o37kKyFYSQ=
X-Gm-Gg: AY/fxX4FHqi8YnK5aXgpWrM50i1H+UI9lFk5D6ofp3kHpZtSIKAOcNKQgP3qCBQY9pl
	HnOinJ9Gtub+XijbBCHWPat7R7ClgvLwlgBHiBGTTNgbh1KnwCx7ZacA6Yx2+DprOY62glqTf+H
	4H7tD08NhuDOKY24bVZn79odi8VX21z40gFFJ4a8CrRI59fHqX+NQKGGbVdnwfSBJ310NaZ+QE8
	pTofyC1l9WA6MmZCy78Bx2SJbOomSXaNQqTnZLflFKGypiYpQEPi/2WDxig7yFSiwzSuAY7
X-Google-Smtp-Source: AGHT+IEykEkaPCHD0X0I6L0ptnL+oTDQcPJEkuriAyEDUp0ZrlA4011Fv2iFVPiLKJUYRQYPeI0lIJC47Kv+zgF/GSs=
X-Received: by 2002:a53:d009:0:b0:63f:b2b3:8c2d with SMTP id
 956f58d0204a3-64663252770mr33509496d50.17.1767236313054; Wed, 31 Dec 2025
 18:58:33 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4_unsc9u4kEDBTNxfS3rsiQi5QBTaiu3fGDcGrdryyBA@mail.gmail.com>
 <20260101014107.87821-1-sj@kernel.org>
In-Reply-To: <20260101014107.87821-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 1 Jan 2026 11:58:21 +0900
X-Gm-Features: AQt7F2qk60Y9SeYysM-zJgRnvUfmjuZOg6-DbWG6PFvxlPWAHpnRRFpuE3nJJkI
Message-ID: <CAHOvCC6UEaWx=Jj+x3Mfo5HAGL+6yAnEvJCrkiLe0M2cL+3wsQ@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "# 6 . 14 . x" <stable@vger.kernel.org>, 
	damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: bdz9cu3s6w8esyrqnoag54cg9dconpp8
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EB3F20004
X-HE-Tag: 1767236313-973623
X-HE-Meta: U2FsdGVkX19h4O62pysH2EAg623wXltwZfaYonQP5SJm5Bzn4XSR2N1JaLHuerNWbQrRuJKeityTsN6bsGeHLHzwW2msgHAGW6lYhAWNCgWNialgI3+2TdVNkATLU0gwA6mBWVImxtLRo08ao8IqlsudeuqRU1DWtT7uQ53CBKFVeR+KmsQG2eg1iXwMgQewo4ZdvZ0cKj03HOyHgdlpJ63QNdS5B2zhgeqbXAFKaoMpp29mAy1jG9ZDOwNl0unTxoQ3S4iHJHEcwR2kaY2JoAxiQuSY7Rv/FTLtzH+1Hiz+XlORocWohnTLU5AN6TGsbbU6P4ldHJAjxe7lVDnxTO3UdUvbTIumwCeS2LDHgEYAg9vjIk6TfucjeZ/hQFYLqPPy3Rf/tlu7Z5zKjw9whjwloFUsMUQG/QElwl/Xb9QTvJ8BimgvqKFe/Nyt9i3KcfHat3tgYmDyzZonfSMRhuqEybfzUhhdDSpF6AVlTG9pdLYqK8rqG5a5eAXZloLBV8cFBJsfqDeQgEu35aRSdGeG0wCqLx63bmAE8nSkwXvceAKKWMXGaHck8MrpgFdun6j1mZMHsBXHEhH+Nux3zbTnqjeM5mVJG83W2j+dspZ+OiLT8UWaA74AzGyDYIB+F1a7BBYOJT0pQio9ByU3/cI5yiJfNjtJlMg7QNlAgytvGmStXPceRTuQ8ggezaVAoETQ8n0/VEH8Zfrw80hQaGMU0cq1S25VjQy/7NlNhJrkvpeUx5ul6OEJssVs/5Secy5dQhhxSrwDqPY9rnFWadEnaheQfdNww7hpbvQzpYDZCSW22gSD39c47XKxHAGP1wu08LiH4+SP0r59jIKuSHbcQ3KdSH0KVBkLrZ/e864rT46b2zWQR7OWlFPalIEKsiy+pIrg5ia1wlZxxtua6SA+nUbQVG116Kj4Flc5HuBjhFf3R5JNHZ+G9n+wxg3LDWXjb3cH4PrWOdw7L6G
 zcS4Kswu
 /+A9Kul2rgACdMMa2dwoZurw81iXd1CWha9fitqgzEy2pSUepbJiksGW61A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 at 10:41, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 1 Jan 2026 09:55:56 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Thu, 1 Jan 2026 at 00:26, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Wed, 31 Dec 2025 14:27:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Wed, 31 Dec 2025 at 10:25, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > On Mon, 29 Dec 2025 19:45:14 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > > On Mon, 29 Dec 2025 18:41:28 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > > > > On Mon, 29 Dec 2025 17:45:30 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > > > >
> > > > > > > > On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > > > > >
> > > > > > [...]
> > > > > > > > I will send a new version of this fix soon.
> > > > > > >
> > > > > > > So far, I got two fixup ideas.
> > > > > > >
> > > > > > > The first one is keeping the current code as is, and additionally modifying
> > > > > > > kdamond_call() to protect all call_control object accesses under
> > > > > > > ctx->call_controls_lock protection.
> > > > > > >
> > > > > > > The second one is reverting this patch, and doing the DAMON running status
> > > > > > > check before adding the damon_call_control object, but releasing the
> > > > > > > kdamond_lock after the object insertion is done.
> > > > > > >
> > > > > > > I'm in favor of the second one at the moment, as it seems more simple.
> > > > > >
> > > > > > I don't really like both approaches because those implicitly add locking rules.
> > > > > > If the first approach is taken, damon_call() callers should aware they should
> > > > > > not register callback functions that can hold call_controls_lock.  If the
> > > > > > second approach is taken, we should avoid holding kdamond_lock while holding
> > > > > > damon_call_control lock.  The second implicit rule seems easier to keep to me,
> > > > > > but I want to avoid that if possible.
> > > > > >
> > > > > > The third idea I just got is, keeping this patch as is, and moving the final
> > > > > > kdamond_call() invocation to be made _before_ the ctx->kdamond reset.  That
> > > > > > removes the race condition between the final kdamond_call() and
> > > > > > damon_call_handle_inactive_ctx(), without introducing new locking rules.
> > > > >
> > > > > I just posted the v2 [1] with the third idea.
> > > > >
> > > > > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> > > >
> > > > I generally agree with what you've said so far.  However, it's inefficient
> > > > to continue executing damon_call_handle_inactive_ctx() while kdamond is
> > > > "off".  There's no need to add a new damon_call_handle_inactive_ctx()
> > > > function.
> > >
> > > As I mentioned before on other threads with you, we care not only efficiency
> > > but also maintainability of the code.  The inefficiency you are saying about
> > > happens only in corner cases because damon_call() is not usually called while
> > > kdamond is off.  So the gain of making this efficient is not that big.
> >
> > The overhead isn't that high, but I think it's better to keep things
> > simple.
> > I think it's better to use list_add_tail() when kdamond is "on".
> >
> > >
> > > Meanwhile, to avoid this, as I mentioned on the previous reply to the first and
> > > the second idea of the fix, we need to add locking rule, which makes the code
> > > bit difficult to maintain.
> >
> > I think it's better to solve it with the existing kdamond_call(ctx,
> > cancel=true) rather than adding the damon_call_handle_inactive_ctx().
>
> On my previous reply, I was saying I think your suggested approach is not
> making it simple but only more complicated in the next paragraph.  And I was
> again further explaining why I think so.  More specifically, the added locking
> rule, that I previously explained with the third fix idea.
>
> Your above reply is saying it is "better", without any reason.  It even not
> addressing my concern that I explained more than once.  As a result, I again
> fail at finding why you keep repeating the argument.
>
> So, let me again ask you.  Please explain.

I've already answered your question.
Please understand my lack of expressiveness.

>
> >
> > >
> > > I therefore think the v2 is a good tradeoff.
> > >
> > > > As shown below, it's better to call list_add only when kdamond
> > > > is "on" (true), and then use the existing code to end with
> > > > kdamond_call(ctx, true) when kdamond is "off."
> > > >
> > > > +static void kdamond_call(struct damon_ctx *ctx, bool cancel);
> > > > +
> > > >  /**
> > > >   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
> > > >   * @ctx:       DAMON context to call the function for.
> > > > @@ -1496,14 +1475,17 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > damon_call_control *control)
> > > >         control->canceled = false;
> > > >         INIT_LIST_HEAD(&control->list);
> > > >
> > > > -       if (damon_is_running(ctx)) {
> > > > -               mutex_lock(&ctx->call_controls_lock);
> > > > +       mutex_lock(&ctx->call_controls_lock);
> > > > +       if (ctx->kdamond) {
> > >
> > > This is wrong.  You shouldn't access ctx->kdamond without holding
> > > ctx->kdamond_lock.  Please read the comment about kdamond_lock field on damon.h
> > > file.
> >
> > That's right, I misjudged.
> > I've reorganized the code below.
>
> Your reply is not explaining how the reorganized code is solving it.  Let me
> ask you again.  Please explain.

I will explain this in the code I have summarized below.

>
> >
> > >
> > > >                 list_add_tail(&control->list, &ctx->call_controls);
> > > > -               mutex_unlock(&ctx->call_controls_lock);
> > > >         } else {
> > > > -               /* return damon_call_handle_inactive_ctx(ctx, control); */
> > > > +               mutex_unlock(&ctx->call_controls_lock);
> > > > +               if (!list_empty_careful(&ctx->call_controls))
> > > > +                       kdamond_call(ctx, true);
> > > >                 return -EINVAL;
> > > >         }
> > > > +       mutex_unlock(&ctx->call_controls_lock);
> > > > +
> > > >         if (control->repeat)
> > > >                 return 0;
> > > >         wait_for_completion(&control->completion);
> > >
> >
> > +static void kdamond_call(struct damon_ctx *ctx, bool cancel);
> > +
> >  /**
> >   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
> >   * @ctx:       DAMON context to call the function for.
> > @@ -1457,11 +1459,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > damon_call_control *control)
> >         control->canceled = false;
> >         INIT_LIST_HEAD(&control->list);
> >
> > -       mutex_lock(&ctx->call_controls_lock);
> > -       list_add_tail(&control->list, &ctx->call_controls);
> > -       mutex_unlock(&ctx->call_controls_lock);
> > -       if (!damon_is_running(ctx))
> > +       if (damon_is_running(ctx)) {
> > +               mutex_lock(&ctx->call_controls_lock);
> > +               list_add_tail(&control->list, &ctx->call_controls);
> > +               mutex_unlock(&ctx->call_controls_lock);
> > +       } else {
> > +               if (!list_empty_careful(&ctx->call_controls))
> > +                       kdamond_call(ctx, true);
> >                 return -EINVAL;
> > +       }
> >         if (control->repeat)
> >                 return 0;
> >         wait_for_completion(&control->completion);
>
> I think my previous concern that raised to your two previous approach [1,2] is
> again samely applied to the above diff.  And now you are suggesting a similar
> approach here.  Please explain and answer all questions before you move on, or
> explain why your new apprach is different from your previous one and how it
> addresses raised concerns..

The code above applies mutex and the locking method is the same.
The difference is that control->list does list_add_tail() in the "on" state in
damon_is_running(ctx).
Another difference is that when damon_is_running(ctx) is false("off"),
the existing call_controls list is cleared with kdamond_call(ctx, cancel=true).

Regarding spin_lock,
I'm sure you're familiar with spin_lock, It can apply like this:

spin_lock(&ctx->call_controls_lock);
list_add_tail(&control->list, &ctx->call_controls);
spin_unlock(&ctx->call_controls_lock);

I have expressed my opinion sufficiently,
and I believe you will make a better judgment than I.

Thanks,
JaeJoon

>
> [1] https://lore.kernel.org/20251225194959.937-1-sj@kernel.org
> [2] https://lore.kernel.org/20251226184111.254674-1-sj@kernel.org
> [3] https://lore.kernel.org/20251229151440.78818-1-sj@kernel.org
>
>
> Thanks,
> SJ
>
> [...]

