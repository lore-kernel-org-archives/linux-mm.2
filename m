Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D185CA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA556B008C; Thu,  8 Oct 2026 07:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282AE6B0092; Thu,  8 Oct 2026 07:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1711A6B0093; Thu,  8 Oct 2026 07:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECE2C6B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:53:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 328531C2B4B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:53:07 +0000 (UTC)
X-FDA: 85299298014.30.BF3974C
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 33E90A000C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:53:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jj1xRHto;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791460385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98tihVeFzpmoGjcvFKHdmbVhnNHCTi0FP0rU9GSDJmc=;
	b=BgqgUMq2akNCqCntGtw0+qTIxfPUQsF8umUFQHJDsL7a5eB5NTTl496uhd/F7l/KJEOl0r
	kToOf03tG2J7jod/LR9JqwGlJgMKCg3vnoikQ8eYwWzkhUlcAdn0VgOY/BOvuok4k0sIt3
	40dlteHAxRJ41kP6EBlTdtENnWONX98=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791460385;
	b=ABDlP8CqA2QZYVKYoV6jsPSX0uF7m1iKdDBXIcQ3jcVBVfFaNSI9QGf11vUIA0tjSDXMw/
	MfenQg/ieFQ/Isj/en5pWJU0oxHVNK1HPh0ZQIV6F87yT0cbbxicKRnDsdTSuGHFrZf6Wj
	fMFWtmuva0JBsM8jOww3hMcMOEuA0uU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jj1xRHto;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c20ce3c118aso133220566b.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 04:53:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791460384; cv=none;
        d=google.com; s=arc-20260327;
        b=IUJccEWfzGl5XUzp4zvOQs82ekGMIRPgDUG67ADG0yh9xAvhriwmLpKNAgSX3OxF9l
         arF4PyxCHlNWyilRsEcqJ9RdZAB/eNZFaeSxgW8e2XUuzssK+GNhPAFLC11IptIMQQbx
         6Y64FPv72AhKZcHVzGds2mrCJGSt5OHnBQJsSJvCUJeaDzfGWOZqVIX1dH6nS7KbekEM
         shMH5xXIg0yRcBug38//drLlzFxQZ83cXfgZzL5ObsF57rS79uYGdrX+ZkkIdw2YvAB0
         EsakcdNiPy73EJfs5aU4OPvbcy+AvjbJejGXfk8ikGwzwjKwR+6Wr2EiCSRzhWcdP4LM
         tC1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=98tihVeFzpmoGjcvFKHdmbVhnNHCTi0FP0rU9GSDJmc=;
        fh=vjF0Agu8Q2Wsqq9GP8nnkfAl2VVw3pq1TSjesBaEHS8=;
        b=DG7mPVms6pH08Wyt4r+Zd8l5q/wRBap9BzfxRiWA4SuqVqY6kIxHt1xCHqv+xhnveU
         p2EVNNCES2VrSpbrgY7QNJtcEQHzC/+qyh4ntnW+MHj3NNBbFzjzYuQHfqKoDs/rmCbX
         uNXsA5b2J+I/a8JplDODWKjq3yCaSPnAn/teWRJialgU59FpTLO/ipuVyyWRscDLEDZH
         3q48LNDY8I77XDf/9AhaugxNigWxyCDDJbgWDdDphJqqG+dU1J5+Pbw9WPaExfq/QwUk
         qVM8dA+HPDFmhVZcJ62QQBe3Pb1PrGsESOhQaLoGDKzpC/RPZmFxdCxUEO/TB3TPC3n7
         iP0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791460384; x=1792065184; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=98tihVeFzpmoGjcvFKHdmbVhnNHCTi0FP0rU9GSDJmc=;
        b=Jj1xRHtofisZrWLnhyyGXJ4I7lP9hpdox16A1VKRIdjFEd0io2EkK6rgENX2cEizbx
         elJ5QfGfG6vp/7fxDDYRzvfOAUN7/jZZDtpD46OSV1Qwv8Z4J8iFmqsWwlhg9BK74hnG
         vcLpfBVS1hJSMzd99yzouMwuyGYcAMS+IkF3H25Dxbq51Uy2gEBzbToaW3S0Yf+KMwqQ
         +qC3gT66yNESHUhmPdRl7r3BUygSSrm4hBb/b/16POjRNX+wUO6T7nW1B34sVoIjlKe8
         A3Maw+PDL0agPbQJo47bldSrEWKS3IglmmtpOsw6cQ7c9FFdZGhfjUuiCe//qyA5OutX
         7iqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791460384; x=1792065184;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98tihVeFzpmoGjcvFKHdmbVhnNHCTi0FP0rU9GSDJmc=;
        b=Jt1cgOpOn7+MY8KPKNfJ41URYlG+JH5bkvIguH0JXvGoypovlscU3BvA9CRnvS0JEU
         Il2mG9HPajTKkTnaGIE6aJslmKA3jqsV9y2TE6xrJZ7WvrbXhbYBz0NLav2tzo1FH+/y
         2MV86ajngxxHGnuXho6/tpAHyrxHpfR54cMv4kVInsrOkgXpLXLTDn8UdskJPrfmyzQ9
         FYevS6jG7LYwPeXPVsBnQehh26VKZCeqwgBWQKscRJ8FX3YjLgcMFef/pc54W9qimcNQ
         MpE+OgqxICUzYpK4mAXKTy4YtSQYuMzZJkJL1eLaqLo9zoh7ZFPImBWCtsYm6RPIyrel
         HEpQ==
X-Forwarded-Encrypted: i=1; AKwUvBwkkPHt8i5d+P4WA6Oyu+NDpci3kpcyfihlKh0YyStOvZrAN22rJrc3ORceeco6dtahqZs7+wZ3KA==@kvack.org
X-Gm-Message-State: AFuF++mGwpt5kyuPh2OpyWYk9EkTaREz/xRF5cErMHnyPXLFgXHMYWay
	QYtDEaWy1HgKrf1ycVamUxXzPjSsxuolDkKleMUyGJzWxl58Kb6ZavAxKzfDo3gFImPcxT//bh3
	ZHhHjlVdT6UXWLqlNC+YfqOfy1nAgwCw=
X-Gm-Gg: AYBFou32/NILXHFLzmgKns1zAXjZVCdHuHAyeMtzk4e5tqYojixsMddpnA9L0zPlNEN
	YLpxnU/4eAg8Y1rvkmFPyxTg9Oe3tEnLHOB5j5VWZavD764TBKyaLJE7EntQM797zjApkj6nPzz
	flJ+BKnaoD6Lw7ozwiHj55xcIr32D/P8mH3Z7xOb0XEQWYJuIG7vnoPTigN0LKxqyUU1byv3RFa
	SNrr6zzwRdBGbnot8jx3wF/1EThI71CYaIeNfTOHp+2K2WKtlVg3nPL9SZ7sVB8FQooX05VXUNs
	FidaDsiH7W03ko/OzrtMKRRlaGbGH9EG712HSDtgZ27ae8GEZUO7pM0igDI6XvnNykhS+esRiZ/
	NTJsGG+xBogA=
X-Received: by 2002:a17:907:3d0a:b0:c2e:3124:e9c6 with SMTP id
 a640c23a62f3a-c3191b5b5d9mr210845366b.15.1791460383641; Thu, 08 Oct 2026
 04:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20261003054216.9155-1-baohua@kernel.org> <088f991f-429f-49e0-be11-548a77e8d44e@linux.alibaba.com>
 <asd-8uoATmpH9YN9@KASONG-MC4>
In-Reply-To: <asd-8uoATmpH9YN9@KASONG-MC4>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 8 Oct 2026 13:52:27 +0200
X-Gm-Features: AclHuK8AetRqe4T-vZyG10jAq4fSR9DczmGNkcmeAoBw-gojqOTN2XpQfXCvNwQ
Message-ID: <CAMgjq7DR6h6GTKASQo_fHx1hyzw_zJZ1OHP-dzy3RDcTcZJUxQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: Avoid reclaiming kept folios during
 retrying missed rotated folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu.xie@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	chenridong@xiaomi.com, Yu Zhao <yuzhao@google.com>, Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33E90A000C
X-Stat-Signature: muko843jgsxp9gjnwxuttzc9c9erm5gh
X-HE-Tag: 1791460385-892209
X-HE-Meta: U2FsdGVkX1/Ejznp/9wwcy+IUHyhdBYz8Nnijdardxc5DKtL91RwY59gRv9gvlY04mVFzQbzTb5qlk+ugkorS7T2GlTT6yD+AaIBFXz0XF1pD3zM6S0Kd964JnGrrKYrnBpeh+CJd8fjdE31w3GPoxRX6bBgkRGUzlMneFw23XYxCYHm1kjJR7NqCQ55d61Cwa3+Gb1pmY6pnKwtDtXCDLhJbjm+KQuR73S0DWy/gqBlkE7WezPW3T6U9Zrp6pYm/bUvc4ZUCtO1KjYnAgD176lmF8z7XHI4zJ+YJtiNccPYfd0xACCTJWkEdEYIVwEfgIfEd+2UYhElH2Z9IgwMHDtHGCis/TcoD4xX7LARPJBDVaSG18Df8tKyGRHbPaxaxl4FM4dZnXpdMlHIdAPD+F/Lo6mUZSduFhA4O2WNpDIxLQrtPYv5/ZoGnliaMG4NtI2a0dOtwRfxS52DCY/dMlttgJpiybEYS6BtCgGwtOyQv3/xkZow1G1ADfbptnZUl+g2uLT3N5+4CCCNb6j8V93yytXcJG0Gik6HnomV0eR0PyaK8BwMIw4SDwKaI86yBekd5Ya8MK3Pgmb64IpY9GTfyXKUuSgGbOYyZ9Dvs+D3RkrI/zKvyJKmu6oVWalEJ01LlgYR0Lo+ueHvELXQqq1ZjUMP7x64oh9AXrCAlrhox0d1nl23aSTxB4GHOtkzm4j8vQUaKLf+P3IYXwufCvhhv+PJ5TE/lShq9xWczBeoIh9afe8pqAEQJ9j8PdqO5oaqIBucLEZJcsKUzIdDbrEYx5ttjKL662frgCjuA6nU51PQPFGwplPCFYKVjPv7lpjB/T2kvHxVEtmvTsJTCXaY4rGBEi7+7Akm8p6mx6WXEMHoi1nQ5debUXfdoNU0pScEp6H6RhRQBOEfawd/vw9L1LunV429NT+E4P04f95WuYUHaAZ1php3hOnrcGq7U3DrUWrnrKCdJMnXpgQ
 7LXxTSFa
 WjgD29CtVr2sYAl4T56I3GfSpYwThNrH/CKk7SDu+cXEDMgy7lJ3TkLi8sS9Rc+4muQAvdLPdIDHpe8YgMQykC9i7RZM9UbU1sgrFM/c1EVSi3ah0QFFbvR0/koz4m3lQzR5gjcm1GKL/9p9VCVIgHX/DhsMlJLR6s4tz5PB4s9rVQkRS1Q/kHPta5E6tXghn2Y3idUZkJnAWDLMB8Ev5E4Tp7Js5MJCYzpZdAc7anZf3EINR/Q/w3hJmji4TdhX/t32jeAFAlnlrgaCb/exvkpEYmi/Jc811HYbGpJtVdXjQ5Ka+Pn/ceYGH1Jlk/fG0YTcZenJX/VMEmdVmPzL71DBHuBnNC0Gy2mLTVpbq66D1ZyYqbPQBaxaeH6yHRgbZtnWhYx9YQsdZwp6EVZrOaEsVumGGgDT1rz0yngqL+v2Awc4iFXFjaYIAc3rDyEoTaZ5O7KlnokOLhpCU7BGSbpK9XB/xLHqGgB5xUD5UjHCuAHfNwa0WvhL3xdHeq2lPIjdAWpnqruJYZ10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 1:43=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Thu, Oct 08, 2026 at 02:52:35PM +0100, Baolin Wang wrote:
> > Hi Barry,
> >
> > On 10/3/26 1:42 PM, Barry Song (Xiaomi) wrote:
> > > Since commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
> > > `folio_test_referenced()` was accidentally removed when checking for
> > > missed rotated folios. As a result, kept folios without an active set
> > > could be added to the retry list and eventually reclaimed.
> > >
> > > The impact should be very small, as we have the `folio_mapped(folio)`
> > > check before retrying. Kept folios won't have `try_to_unmap()` called=
,
> > > so this is really only applicable to folios that are unmapped by user=
s
> > > after `folio_referenced()` has been called.
> > >
> > > I'm not sure if anyone else has seen any issues with this. Sending an
> > > RFC to check whether it is worth fixing.
> > >
> > > Fixes: 4d5d14a01e2c ("mm/mglru: rework workingset protection")
> > > Cc: Yu Zhao <yuzhao@google.com>
> > > Reported-by: Bo Zhang <zhangbo56@xiaomi.com>
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >   mm/vmscan.c | 7 +++++--
> > >   1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 91295070ca33..6a931b576b7d 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -994,8 +994,10 @@ static enum folio_references folio_check_referen=
ces(struct folio *folio,
> > >             return FOLIOREF_KEEP;
> > >     if (lru_gen_enabled() && !lru_gen_switching()) {
> > > -           if (!referenced_ptes)
> > > +           if (!referenced_ptes) {
> > > +                   folio_clear_referenced(folio);
> > >                     return FOLIOREF_RECLAIM;
> > > +           }
> >
> > I've also been investigating the issue of referenced folios being recla=
imed
> > recently. The background is that classical LRU will return FOLIOREF_KEE=
P for
> > folios accessed once via page table, giving the accessed folio another
> > chance.
>
> Hi, thanks for looking into this.
>
> >
> > However, for MGLRU, if the folio's pagetable access has already been
> > consumed by aging or lru_gen_look_around(), referenced_ptes may be 0 at=
 that
> > point, leading to reclaiming folios that were accessed via page table, =
which
> > could cause more refaults (I don't have data yet).
>
> If we go with MGLRU-FG, aging or lru_gen_look_around may move the folio
> to newer gen which is identical to the behavior of promoting at eviction
> time.
>
> > But it's not easy to maintain logic consistent with classical LRU, beca=
use
> > we cannot distinguish whether this one access count comes from page tab=
le or
> > file descriptors (for anonymous pages, it can be distinguished). I'm no=
t
> > sure if Kairui's MGLRU-FG patchset helps with this case (I haven't look=
ed at
> > it carefully yet).
>
> It definatly helps, check this one:
> https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-4-cbd4546a5bd9@tenc=
ent.com/
>
> folio_inc_lru_refs and variants will promote the folios in a consistent w=
ay.
> See "First access only defers eviction from the oldest gen" part, I belie=
ve
> that is the issue you worries about?
>
> BTW promote then to newest gen directly does over protect them, I've see
> regression with that.
>
> >
> > Perhaps at least for anonymous pages, if the referenced flag is set, we
> > should return FOLIOREF_KEEP to give it another scan chance.
>
> No I think we really shouldn't do that, it will over protect single used
> folios. Promoting them to second newest gen or second oldest gen seems
> a good idea and similiar to CLRU, and this is the behavior of MGLRU-FG.

Oh I also mean that protecting them by lookaround / walking, and not
at eviction seems better? As the rmap here have higher overhead and
can see stall hotness info.

