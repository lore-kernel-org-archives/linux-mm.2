Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7DFFD006E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 04:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D906B0088; Mon,  2 Mar 2026 23:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24C66B0089; Mon,  2 Mar 2026 23:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924186B008A; Mon,  2 Mar 2026 23:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E66E6B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:06:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 201941605C1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:06:35 +0000 (UTC)
X-FDA: 84503415150.09.43E961C
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28231180005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:06:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YSRVPEEN;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772510793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXv5wfXX+J5345zVcee1UMFjZGyUjB255kmklcP90Q4=;
	b=JUecQAM7C9DH6w+uNofJQ7vSP6CzzNqyzxqjXr9UW4qUCe/Ow2YXTtLLeqCeBzW+J3BIfg
	1d1o24YK39t1P50A2Gip3WOByn391HfVrnfdaipwhacETBkZmdMAAH9l9fi4DM36n/7yXN
	igarLRnqluccIr+5hr027YwxomhR2Ms=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YSRVPEEN;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772510793; a=rsa-sha256;
	cv=pass;
	b=ljcCijDpRsKvGzMgjQOzRjOPp0ivwcLephgbKHzH85v3Adf9d7/pQGqEXIna6N846mhft4
	eTDkQQvxF3fSt6dOgT/Yon2CJkLzbJ8pTCSmdyzGDBJANg0VODI3bE8qvIAT3KqTN4MF2H
	jJ0TsLbKMw+pcYcQndJIYyfR4Hb0gdY=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899e43af784so30753846d6.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 20:06:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772510792; cv=none;
        d=google.com; s=arc-20240605;
        b=BaWGdB+09+iz67vFN+GuwreJ7jftQM9X00fAldw9OHjjpKdQwRk8swIOhQI9rYnOUA
         fW1WjGs59jG2USGcEqdgT4jabp88O0JJbY1M/dHCsT2f7/u33uoa0kmVMMtYH8WoACnv
         45ffK6+3mKgM9aH+wi0fCg1guu6zllmaa9mbfZO4oHb9JbgzQtZQYrXzc4i+iSF/77/3
         iOmRymtjF8DAU1p1oGjRtFjA5TwvcwWSlhX8TGRm3TBtnqrexgbvDw+9+O0xIoDzYjSx
         6Nn2q05Eb0eS9Ijodcrjq9CfA1AJL1FXbnfwBHGVfDWRIOcSRnqHs/aiLRgaKXIzS+2n
         N43w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xXv5wfXX+J5345zVcee1UMFjZGyUjB255kmklcP90Q4=;
        fh=9Pjn+ttwNe3WKEhKljNU4egVuFYNS8KYGFDP6hrMuNw=;
        b=PcUkiptcarpwvnRSgstusAkiYGqrAhry0xrLOYmclqD2rSbl2QnSblDFebLTGmpoBL
         PWYdvQTrSTQxTFGKRHee3uJw0fF0lZefCXpHa4M/b5UMVSzv60KM6/YTevLjOTdkdXIv
         jzzfp82YJZjo9ExhrlbcXZlejFHSjYYkrp0jXiOc5DkStRGDOf/d9kJafY2mMslIIecj
         Ma/MiQpmqwmNEGJa2ZC+L/gB62fECXCyRmBQ3Ae44gZTdnsIgXCpRl9nw831kMH3CJJC
         gUzsr0i84ucGXPEpwQ+ylw9vrofurlnNxTZ/cI6C7Fq6MPGcUfui8M8G4ivlyUllBRFh
         oIrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772510792; x=1773115592; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXv5wfXX+J5345zVcee1UMFjZGyUjB255kmklcP90Q4=;
        b=YSRVPEENyGmPrH88n6bNynD5bHQEfi516AmPwieFMo2MFdYpaANdMnABwNUIA1Eg7J
         ATgsAWekHjxyNodquDyfKq+hc0aQi5EAqY73pOgFTeLxJUXvpvLDyTrcrXkI724N19KU
         tnJ749xo42KyWeAKhoIOdFxCR6mfuHN9zffeRHGEOJ4X9+dNfrLElaAalm9yxmUVDsSF
         OwdZn90gcoZ48rULd7dkIUX22DOKGEn0Bdok/i93VzZ8pXYmIkj9Y6gq8pN/3AYb94wS
         OxXTdl2rcHsHjlG2qIwKxtclERTtQq46Yms4Ly5+c4snvMCHqbS8Orf2v94FC3Tew0YZ
         nmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772510792; x=1773115592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xXv5wfXX+J5345zVcee1UMFjZGyUjB255kmklcP90Q4=;
        b=b3P9cpHF3dRySvt0Z5ufvx7j/tRCofiVbR03QM+8QxrBv82bPoyY9JHTiD+A9aPOG5
         kobaO1m5zRGkG8luRm9mPPv1CII7AwYypg36JgHuUFWC3dSKqWxOsdstcyCl4ysYGvdA
         LlH8XZMT1mHZ8oFJt1iG+A0ZAFGXmHTX3/G7XPtmLBbUJdsyCLCdiB8nghtZR1t7fpXY
         ClA7teq67PPTmrjbQ216jxTBmteOYBOEkLfZSZcQ6pSNJ6xRHybTubvAaM6LiT2MHL9G
         xvKmqRnmy7DIPslnK6blTfU/O7wCt15CJgWIVZaM2FVpjTVlXNUZp3ZUL7N8eZvKLXJ8
         wCLg==
X-Forwarded-Encrypted: i=1; AJvYcCUuKd3qJzzugVIEWdtpwgI0WmTyhKfeDtBv5uc1rRVxtjWEg7+DDdIzg1K3TOBEjnEMsVHuN7+Fow==@kvack.org
X-Gm-Message-State: AOJu0Yw4YwkWOwSJO05a1VTsgTOOx6T0BuEkUHPJfphw6G9pRgWHqoQu
	QDKj+qQB6GfSTQrVSCmZcMtIsBd9w/1I9GAxkFkOEe+AvPoaBYx6WZz9sHqMtucWbFoE4HbxfE9
	FxjIqX3S/bagOOr/WhFnX5aUD9KNmuBY=
X-Gm-Gg: ATEYQzxHOCbs1Gf5kjedijmd/D4vv8Gf4Gv2EWzd2x8Z7TvMDLUTFgXx3UKAP0OIkjx
	irqWYeqB9IA8Xm3ZmqF1A23Kf6l2v1Hzs59XuXNgloK7P7w1hPqWvW7pJyY+dCaMvA0pGaYzzBD
	tww9BhGTur2DnUNuByvzv0IVhw/yFx4kqxsvhHKrQY8m9y7kQmXc4B5Ob2qrIBOa1kIl1U3c9sg
	KXy5iiS/ySThHwIVBDYDuQxZIKls1thA1Jv1gdoFNnhwrlAtOlu/rPR3QIY532KwNhAMATshnFT
	RzrEFw==
X-Received: by 2002:ad4:5b89:0:b0:895:4852:ef49 with SMTP id
 6a1803df08f44-899d1e54f38mr215492406d6.34.1772510791914; Mon, 02 Mar 2026
 20:06:31 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <20260227033013.94901-1-21cnbao@gmail.com> <CAMgjq7CDgap5pe_xVemow+SbaRW+ERXZBZvkymhFWZQZdDM2Kw@mail.gmail.com>
In-Reply-To: <CAMgjq7CDgap5pe_xVemow+SbaRW+ERXZBZvkymhFWZQZdDM2Kw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 3 Mar 2026 12:06:20 +0800
X-Gm-Features: AaiRm53kdK4VYGbtz13gaMF5u8ewVfzw-sYkk53iTdSSSQ7aNQ3AFPdNBU82qvI
Message-ID: <CAGsJ_4ypfGxp5vbNaOt2i2qDmy9tCJuemDjMjwWr6hSv2RtYVA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF] Improving MGLRU
To: Kairui Song <ryncsn@gmail.com>
Cc: David Rientjes <rientjes@google.com>, axelrasmussen@google.com, linux-mm@kvack.org, 
	lsf-pc@lists.linux-foundation.org, weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: du6euppnom54y7yu7twppqjzpxfhb5rf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 28231180005
X-HE-Tag: 1772510792-348842
X-HE-Meta: U2FsdGVkX18u9ls80zE2doKIBNJXUtgTDuafX+3tLOcE5EWStW/39mPTYvYBM1F6Pqs5ScVtA+uB9ydJk09CpnY0aSSYiuvC0WL3jsgDaHF6nOapnsoIK6qQn1HfJgPbQsspLL0yXsG5nt56ScSvK8UiOaEdYYKJdSdHlXQbG7TKWrAWp6MLimhJ1+7UOf0Cs2W1G9sej0xNMQsLaAXTJ2f0P6Lj0+c2NieRJGIXiftRxpAEL+JP22m4uTPT66VLAXmy3TURsIMj1ROJSgq2nu0RN1tA32vz0mIISe1W+reOJm+dq0UFwHcmWoYWRXL0K6wUA3NkldOn2T0TrWPJDgzlma3dk7+6yLATfHAeaHwstp4xsIdObm9/LfAEmJeZG2bmr+ZermZ6p3pUNqMh8hPgIPUcdRsf9qMzk0ju5DOnh4isv7ZK3s3aveHeh0IP4ekxd1EJ7iHFWK00Cue1MsaqSVIIcPZ1jFMY+8u9bGBhHfoc8+ffWnBl5VF5ZfkIlf8bKYmGG2Rh6tWRIf5B5h84NHIszresk4+B4G66R2FwDOOoNeog0DlEqoA3QbtY5F1RyKqGGmhNJlWYzXxq516/KiK51PGPadMoO8MGhzB5s5Zp8ctxkXcoHKzIoz7KEvf5Wlmj7aWsqzgKJhjsLVOgS9t0UTOGxYCGMfsh0Bd2e1hM8FPJMYSvbGa6aV0rgvFgVoqQRg0jRxG6M89fw/fd7jU1RszrTcvhHLc3m895nalpAuVQyj5ikElcnOjhMeiliIKY9VAzdj3ggGO2wi+elxjuvninij3ZLgxpGNNT8EGtfXU1FvJeCFtSsa0Z+69NPuDk2xboM4tizovVsHCllKhx03pDYIbQccbdiagKqyh3rIXI2pMUiGYcXKCAOfgqgFk4sMiu1uyJelqyXiuxak/AZYjRoP1jR6LXQOKsE8bwjYq8Iw06ELcV1m7G5fAzvAq2esok9ZT5qQq
 8MDP8iox
 fhBxZD1yp6a0GlQ+V12SQcz5xDuqeRhUEm24u873a4OTUpDB3Y/DPQqDIxjhHJkmbqbvqiqjnsN4/GPoyqe3Ck9UZsTvo4BFIIJvaL6fW4xHejM01XGYf4dXAeHNX4Xb7+kZKD8Cv2LabTYyVE8SgHe+yyrxDYVW2M1eqQeY5Tc4a+yvxQeAfM0lzdsrANj4zULRztHkug7O/CiX9aCrXCnifVITIMVQ2NodCoQZhu1qzxtBLD69dYCeo4hc47e2bHiuKg2Bg+PwMeS98IQbFejKe3BwCzJW6VMfpkBoy9Zv7UorySDPkLyrp8aXzGpGf00IZsYORRCzsCXsn9aPnnDBBT+rXVjJpC+RDR4+VGu1JUHfHjT29+Yr0yF6SWilj1D+QdOBwWwAIBW7WFKn/xvbzwIP3Rc7ijUSPMYXFcOV/GTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 7:10=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Fri, Feb 27, 2026 at 11:30=E2=80=AFAM Barry Song <21cnbao@gmail.com> w=
rote:
> >
> > > 4. MGLRU's swappiness is kind of useless in some situations compared =
to
> > >   Active / Inactive LRU, since its force protects the youngest two ge=
n, so
> > >   quite often we can only reclaim one type of folios. To workaround t=
hat, the
> > >   user usually runs force aging before reclaim. So, can we just remov=
e the
> > >   force protection of the youngest two gens?
> >
> > I guess not=E2=80=94MGLRU needs at least two generations to function,
> > similar to active and inactive lists, meaning it requires two lists.
>
> Hi Barry,
>
> You are right. But I think that doesn't mean we can't never reclaim
> the folios in the oldest gen? Or maybe, just let the kernel itself

I think we could reclaim the oldest generation even when
only two generations remain. However, that would make
MGLRU more conceptually confusing. We currently map the
youngest two generations to =E2=80=9Cactive=E2=80=9D and the oldest two
to =E2=80=9Cinactive.=E2=80=9D

If there are only two generations, they effectively both
fall into the =E2=80=9Cactive=E2=80=9D category, so reclaiming one of them
would mean reclaiming from =E2=80=9Cactive,=E2=80=9D which feels rather
counterintuitive to me.

So I=E2=80=99d prefer a two-step approach:
1. Age pages to form inactive generations.
2. Reclaim the =E2=80=9Cinactive=E2=80=9D generations

rather than reclaiming active generations directly.

> perform aging when one type of folios is not reclaimable.

I would prefer to avoid having only two generations.
Ideally, new generations should be created before reaching
that point=E2=80=94similar to the active=E2=86=92inactive transition,
but driven by aging.

>
> We have an internal workaround for forces aging, and waits for sync
> aging if one type of folios are not reclaimable (without the wait, we
> still hit the MIN_NR_GEN protect again since aging is not finished).
> And without the MIN_NR_GEN protection we might end up over reclaiming
> without aging.

I see your point=E2=80=94I did exactly the same thing in Android.
However, there=E2=80=99s a significant problem. If anon has two
generations and files have four, they end up sharing
generations. To age anon, we would also need to move file
folios between generations; otherwise, the hottest and
oldest generations would overlap, causing cold/hot
inversion. Furthermore, in inc_min_seq(), moving folios
means the oldest generation gets pushed into the second-
oldest generation:

new_gen =3D folio_inc_gen(lruvec, folio, false);
list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);

This is far from ideal, as it still mixes cold and hot pages
to some extent. Could we keep anon and file generations
separate instead? I feel this is a strong requirement and
likely the first step toward making swappiness work properly.

>
> The problem with that is that the OOM killer became very slow to
> trigger since aging is costly, so the system will hang for minutes
> before OOM is triggered when it should get triggered immediately.

There=E2=80=99s a shrink_active_list() in active/inactive to
prevent inactivation starvation. We likely need something
similar.

A key difference between MGLRU and active/inactive is that
active/inactive performs demotion=E2=80=94moving pages from
active to inactive, with the ability to specify anon or file
types=E2=80=94whereas MGLRU performs promotion, scanning PTEs
to identify young folios for new generations without
distinguishing between anon and file. This could slow down
MGLRU aging exactly when faster memory reclamation is
needed?

Of course, we could treat mm_state as null and skip
walk_mm() for scanning PTEs, but this would make aging
purely a matter of moving folios, without any basis in
whether the PTEs are actually young?

>
> And for the OOM part I saw David Rientjes also mentioned the TTL
> config in MGLRU, I do think TTL is a good idea, we just need to figure
> out a good way to make better use of that.
>
> I think a feasible solution might be (just idea): implement async
> aging; decouple aging and reclaim, reclaim just keep shrinking
> whatever is oldest; and optionally improve thrashing and OOM with TTL.

I=E2=80=99m not sure we want to add a separate thread for async
aging, since kswapd is already quite complex. Could async
aging be handled mainly by kswapd instead? For direct
reclamation cases, if aging is urgent, we might just skip
walk_mm(), or alternatively call inc_max_seq() directly. On
Android, we once completely disabled walk_mm() and only
observed positive effects, which also reduced mmap_lock
contention. So I=E2=80=99m thinking we could consider disabling
walk_mm() by default on hardware that lacks non-leaf
(e.g., PMD) access bits.

I agree that we can leverage TTL to improve OOM handling
and reduce thrashing.

Thanks
Barry

