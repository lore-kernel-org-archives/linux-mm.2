Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F241CEE57D7
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 15:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE1B6B0089; Wed, 31 Dec 2025 10:26:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5D36B008A; Wed, 31 Dec 2025 10:26:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E22F6B008C; Wed, 31 Dec 2025 10:26:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2267D6B0089
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:26:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCA2F1A0412
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:26:27 +0000 (UTC)
X-FDA: 84280142814.03.CE23C5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B1534000C
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:26:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwgTUA9F;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767194786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+ZwGVpCzV8Y9xuG9tETeNsGHVec6lpEYP8zalDoSZI=;
	b=i7RNEInPgLaXpD9fg+swHk5YW+nkI6Vi0n0TO10GQxedu618m1UufNhjvENzZLoSiDbCx7
	A4op3R7Gpuy+MCLKDZ9pbDsIdWMz6Cd3I60zdoKE6GugOn1SdekZC8bqgfCY7s6Nuzg9wf
	dEc7puBpgi0ph9FjFDCd0QKmwaGegA0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwgTUA9F;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767194786; a=rsa-sha256;
	cv=none;
	b=EJFiDMo5g1hCdLyVDXd7NtEcQ3jUr4GcnwRe3HcMziZ202NL/301szJ4BBzCa0vyixJWiL
	QHpf3Jk7h2uZRtSwIGZ6gXRQgJV/5NtUMOfC1S44X35TPhLQyjDCw3fRpObDbbl8F70O49
	5dd+W6fI0yvb3AQCXu2eyKj0NTqH59Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB524437A1;
	Wed, 31 Dec 2025 15:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F05C113D0;
	Wed, 31 Dec 2025 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767194784;
	bh=JzGS4bo9AEHd9uEqNevElOW0FoRxhHNAv/dVhm19Igs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwgTUA9FYr4mYFVd6xyDozLB83BwIlj0A2rTYaJ9gB54HsYl57jEDc6egzI9cVjpY
	 RyaNoTSgGN/aP7V9jLpssR05usdrRRfpewVartIW90tZjzWyJaDslu31/5KniwXvlB
	 AXgpMZucEcvocRrAYwf/vC/CDGcjElF4G8de59z8r3WHlQ6Y6/Xh7A2S2mM5ETToAL
	 aU2Qu6JFxLPe13JJ0LyUNKTMkQawCCJTidR8PlUaHMMJQde6NLvQUtZsTN5/steuzx
	 edV2eglkhXjK4m4x3aoGcXimj/V5ydiYEhmKD9uR00PLSx8LPTgbdgCW8heq9J+ROK
	 lRh0IizCafiJg==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
Date: Wed, 31 Dec 2025 07:26:16 -0800
Message-ID: <20251231152617.82118-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6F5zLnBF=v7G5k1WdDZZmkBAK94ixzLiPF0W53wdtyeA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B1534000C
X-Stat-Signature: 7npfrunp7p8c6tqqhrzu7wij7whurj76
X-HE-Tag: 1767194785-620048
X-HE-Meta: U2FsdGVkX1+++/Ra7zzGFjpG+wJ7f9j89PovlMmk9gkOPNNXULtV1eeDtW/jbpnyNLxLHEv6WH1woqaOJdW4MFcszWWFzlnsJj/hikVz/d+doEAWTuHYJbExIWYoWcEvvX9tI11rNA8T6ipOb7HoajcU4BXvhfZzv5o55tO5PK89Hg9K75ZDPsNgRLGwP5OY5U7/VeyuhXUrCGeqCKlug+7fiQMYI91SayrsdR5q7RYsaOxb+l7o8FHd1/tiQr0HZH7rYCMhVAtpsYegUAMo0ydzEHoamuN+fo15G0Xt3Lt8vW5K5wD8xORMZ4sWNwCbLYPMqlhFuaH3VpOx7yR2ol8X+6pg5tdZODmIYnLwJBy5myBnGryruLI4d4TWgaSYep2JpMxru2wpp73ocSD8K7a2+6nSb4cbFetM2vtV+ux6cLA/To6pXqu81Qk1aAl373CEJPLLZ0h20FrsmFlYb3xj4YV4NhnAH5z/Eq6NZ+N5xxrLxUNSak2Z7sMiQ5/Q8m/YnjhPXazu2+Q6edKM6x/qQTFvDdF0EPK/pVHjshlvq5VzIBgSShthX3pxPF9TBfPkzPIb5rUPA7ASBDIMDYOsarK8TrvqLKj+J37wDjqKMURwaDxdtAtL7mw+oCWiW9md6ypNTmBPw2muvW/wp4do7Jig8YhQGkWwe3u1bFgrF0ToKiG6sZSjrrIFq1MHloqI1acNIf3jLgObOvpdgFfBrdCkVTlPhvaOdNebbLShbMco4xO8m1gOGGpa6+hKCs38HRY92DVWsQCXaxuJSQXVgOvrjOxVfvpco1jalA55sVdh0uQwDZgRvZGP5BTcLoxcdsZekd54DBnRUtEKwEdzgZxOCmlBfNnCYhBsHDAvXhrn9dNkAbdWXczWlpyF5qu9+CWKLSB3IA6IZxnNRWzl8M/zYW/hl2BVlXW65fHRVcrpxYc16cpMAO0ZwJI4pwcVUiggvHW43h0eZaa
 MJaJst+k
 2oYvkMzZ0bX2FlloOoQTvlmwT3hC48iGPGVOPO3YoKq0cnM7ydS5HzCBOUc9hXdR/lf3oZARnZz9d9qOaIv8KUjM8veu6DVVWGaf6j03gxkKe6e8VVWID09Zje2tj/WY48ySbsYhZ+RT5FPPKn1tzS4D78boG9Tc3KeLXAzDsso0GilYSNDqEUZh1OKSEKfCY6j1b0D99tPhOu7AB6V2pTmzbVC9tqVqg/lb5hv/evKVXSiR6PVgVPdwErJ8XphY8+B7QbQYv8YHuVgA0KnTyI5hc1PU1FXwv7kktFveO5b92dqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 14:27:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Wed, 31 Dec 2025 at 10:25, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Mon, 29 Dec 2025 19:45:14 -0800 SeongJae Park <sj@kernel.org> wrote:
> >
> > > On Mon, 29 Dec 2025 18:41:28 -0800 SeongJae Park <sj@kernel.org> wrote:
> > >
> > > > On Mon, 29 Dec 2025 17:45:30 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > > On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > [...]
> > > > > I will send a new version of this fix soon.
> > > >
> > > > So far, I got two fixup ideas.
> > > >
> > > > The first one is keeping the current code as is, and additionally modifying
> > > > kdamond_call() to protect all call_control object accesses under
> > > > ctx->call_controls_lock protection.
> > > >
> > > > The second one is reverting this patch, and doing the DAMON running status
> > > > check before adding the damon_call_control object, but releasing the
> > > > kdamond_lock after the object insertion is done.
> > > >
> > > > I'm in favor of the second one at the moment, as it seems more simple.
> > >
> > > I don't really like both approaches because those implicitly add locking rules.
> > > If the first approach is taken, damon_call() callers should aware they should
> > > not register callback functions that can hold call_controls_lock.  If the
> > > second approach is taken, we should avoid holding kdamond_lock while holding
> > > damon_call_control lock.  The second implicit rule seems easier to keep to me,
> > > but I want to avoid that if possible.
> > >
> > > The third idea I just got is, keeping this patch as is, and moving the final
> > > kdamond_call() invocation to be made _before_ the ctx->kdamond reset.  That
> > > removes the race condition between the final kdamond_call() and
> > > damon_call_handle_inactive_ctx(), without introducing new locking rules.
> >
> > I just posted the v2 [1] with the third idea.
> >
> > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> 
> I generally agree with what you've said so far.  However, it's inefficient
> to continue executing damon_call_handle_inactive_ctx() while kdamond is
> "off".  There's no need to add a new damon_call_handle_inactive_ctx()
> function.

As I mentioned before on other threads with you, we care not only efficiency
but also maintainability of the code.  The inefficiency you are saying about
happens only in corner cases because damon_call() is not usually called while
kdamond is off.  So the gain of making this efficient is not that big.

Meanwhile, to avoid this, as I mentioned on the previous reply to the first and
the second idea of the fix, we need to add locking rule, which makes the code
bit difficult to maintain.

I therefore think the v2 is a good tradeoff.

> As shown below, it's better to call list_add only when kdamond
> is "on" (true), and then use the existing code to end with
> kdamond_call(ctx, true) when kdamond is "off."
> 
> +static void kdamond_call(struct damon_ctx *ctx, bool cancel);
> +
>  /**
>   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
>   * @ctx:       DAMON context to call the function for.
> @@ -1496,14 +1475,17 @@ int damon_call(struct damon_ctx *ctx, struct
> damon_call_control *control)
>         control->canceled = false;
>         INIT_LIST_HEAD(&control->list);
> 
> -       if (damon_is_running(ctx)) {
> -               mutex_lock(&ctx->call_controls_lock);
> +       mutex_lock(&ctx->call_controls_lock);
> +       if (ctx->kdamond) {

This is wrong.  You shouldn't access ctx->kdamond without holding
ctx->kdamond_lock.  Please read the comment about kdamond_lock field on damon.h
file.

>                 list_add_tail(&control->list, &ctx->call_controls);
> -               mutex_unlock(&ctx->call_controls_lock);
>         } else {
> -               /* return damon_call_handle_inactive_ctx(ctx, control); */
> +               mutex_unlock(&ctx->call_controls_lock);
> +               if (!list_empty_careful(&ctx->call_controls))
> +                       kdamond_call(ctx, true);
>                 return -EINVAL;
>         }
> +       mutex_unlock(&ctx->call_controls_lock);
> +
>         if (control->repeat)
>                 return 0;
>         wait_for_completion(&control->completion);


Thanks,
SJ

[...]

