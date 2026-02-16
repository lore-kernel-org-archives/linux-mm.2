Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC1FE63F33
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 07:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF21A6B0005; Mon, 16 Feb 2026 02:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FEF6B0088; Mon, 16 Feb 2026 02:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77796B0089; Mon, 16 Feb 2026 02:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 971F26B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 02:37:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DFBF140C24
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:37:32 +0000 (UTC)
X-FDA: 84449514744.20.EB3A284
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5CF85100005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:37:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hf6qRQ8T;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771227450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbrx3mvsNH1uOFqxGGT/csf8lky+5VJEXXssPMAdppM=;
	b=4aV6Yz9zJ2xp3UsRgzRDJ6tyQEJoKs7wuXOls+Ru4jtfbG6+MA7fOehA9fZNu1l+dWK+i6
	zd/4f/AW8L+bxiNsG37x2iWuKKAKq1/ROjG+xs1sHclB5fBdruD3aipZzbD25Sw+2LWqGn
	eFxl6wtuy5+0f5mtiKPFm2OfTkA+vQk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hf6qRQ8T;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771227450; a=rsa-sha256;
	cv=pass;
	b=iE0Vq+X/dQJgsulZINEh/EH70VIdV1mW9b2fSt8F0a46ueJWdiyYnIlNOwG+laXq8oaSPg
	4eVXO8fHbTPitYru1mDLSW30m4SZcirrdV/C2wAQGXg4uhyhxSoZczl6KPPXACABzIh+bu
	yl7jGi6U0Z4hSmhB+YLHGy4q3kH8x+8=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89505dd3e24so40354776d6.1
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:37:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771227449; cv=none;
        d=google.com; s=arc-20240605;
        b=Zni5H0Dv+zJ8ajJXu0+DZItSQMHntdx5wyOCPKf5janQXM29obLPtARK65Xsu9Omax
         4tFZhQDeTbVv4AexjWKN5vlmXVsvNDs/kMCoyVV7q4Zsuy6USQVktGCWTMPcd2KsM6K5
         eSFvoRviTh05cz64/E6asqHXQc1jrA7dlcOhfkMKGCS7tYe2iUhqQJ/WbRJfxHYgnwwq
         /2hcvN9AVBQuoYUwsw+HSYNesCQwoA6xsZNBt2OtH6IsQ0z6tFz2iYEX8AjthArjj+Yk
         U9pN+gSHuLqwGPyutJv2n2jFcb3dfQPTm/BeL0ElE5S2tP9KHkm2O8OBFjYpt83kjL7N
         UQRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nbrx3mvsNH1uOFqxGGT/csf8lky+5VJEXXssPMAdppM=;
        fh=rGkiT4R+FvsJSmTNlWQjQ1BSUlCHYv4eQej0+DgYM0U=;
        b=hLL9SOkvv/TA6ABPLTWdwWhHepo/xjipNMJIAC2Vakfhxs1hw51yztEISz1xvJxf/P
         RiRNonIv3lPzr0qFiOma4XmVANbKtK0rtcAjiviOqRvm6/nMJpRvRIyDNxPWnj3HIQu4
         gV1a8CeiqIGr8nglGwZ+SNSNY9FjSQBsRRPFzFkvmrSWPrDj/vddxMc/eMC5Gp+KkcRn
         2lKRK1RDxJ3eKvL1lFSktunFlD2q/Pdy/l/xyrgQnYHYpkt8fmb84gBK5+ldv2MIG/Eb
         gDwU0sgMvDzRjLUoqXqxam5ZEs/y7gGX81EsR8HjU6jI7YQ5NuQVc71L00452WhGZwkY
         PFdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771227449; x=1771832249; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbrx3mvsNH1uOFqxGGT/csf8lky+5VJEXXssPMAdppM=;
        b=hf6qRQ8TYa0A/L7ohAyC9jxqaCJjOJLczu/W60V4NaLRfQn0/LVRiUhYi4fPuKAPKO
         14tpwdKDuogzcUzcT99uO9rkE7cv2xhp8ve2eqayrbdHVQyGLz/HZcCICAJMS0WmQjDS
         yLxFiSz+BZvLrPGoasqKxa4Qv5rwpbpxCDL43FI6WeC8cbLprpeJSYV1ym7J5nHNbdeY
         Q6I6HdDiCqEH6UvNhga3hlDMsOtNAxxr6e55vi+O3DqXPCBAyp6dAMwvWKiKMNo0gz7C
         F8RgERJqiD7IZ2kuIB24KNG6oB02seWNXwUr+s5zQAhwq+PCYh0DuMfS94I1FLRUfxxd
         YpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771227449; x=1771832249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nbrx3mvsNH1uOFqxGGT/csf8lky+5VJEXXssPMAdppM=;
        b=Wa4NWnp7bfLxY2FwgJLZl1iXXOfLcPQQaI26EQ3TsuJqx3/JwUEa6SVpSb3tNi0iVs
         5C7/XtL7v6MG6evORRPFCxL2rp1kLvLcaT7D9ZWJwo/7Hx0Ub0ykLSjsgjrI6HfjDOvh
         cQ6SQru8V7iV5Q5ZPwoDoaPmOHcDD5YzsDCYtkbPKjw0k0GnlwhEhNIZZx9gcJYh9PED
         eguPcpdKcIdKP8IIDmpA1QGznReaohNzu4WiJI8BbjZHouhtifAJx9BitYSQFHU1O8t9
         5W4LP9GoBAEJJ0jikilOpq0IrrE2dQ+ZFTVdo34xehSuD9zYAZH5qo3prxhw6smALnBH
         WLPw==
X-Forwarded-Encrypted: i=1; AJvYcCUeSf7rzKI4VbMFy6W7/4bejuaGUOuNpFycMDZk/8LCFPwcz53sE2TSVwOpUDTHaBVO47H6ZnvR0g==@kvack.org
X-Gm-Message-State: AOJu0Ywq88HwlxHD3FyfzxfM24BMMKF0hRRLNlkxAhzw8YTDoEYZzc6q
	eS+96iMhM5NNgOGZD69NeHw1kJTUZghH0QhzxLGslKWNYgOk9HoNpFvEgjydnwVIuniG98n2l+o
	sPX3baeK5EhT+XnoEHSOB2PTiV2pW29U=
X-Gm-Gg: AZuq6aLJ6icD0WnMkT/jnIczjDYu3txVRYH9jUQQvbk2yMCz9w2WbJqHwvUpflWOHVe
	Z7yTh+Ch8CmCp/FKvJmaI2BrzJwYGBU0FA+NCmFOZ6gaPH+03kXsV6tWqi69zlviUSCHoT2P+o/
	Dvpkfx6FyR/6uvnw1mNEahVTbxlWo8GwYggrL2Uew4ZFNV08w+GcAHoauJN37xTq/zzE1P7VwHw
	Q384+binA+TF+53IhWVeBQz6Oft7BAcQlPlV2utfAXPN8ViJ4tapVZmAXcarkP/5qyGIecx284i
	QdGsRJ1nr35/cXip
X-Received: by 2002:a05:6214:1c0a:b0:896:fdcf:731e with SMTP id
 6a1803df08f44-8973606f266mr117873926d6.9.1771227449326; Sun, 15 Feb 2026
 23:37:29 -0800 (PST)
MIME-Version: 1.0
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
 <20260216-hibernate-perf-v3-2-74e025091145@tencent.com> <CAGsJ_4ynCA_w4Xcwu1k=2Hw3bMnURBxC2FeZEzN+uzBp+9YJcw@mail.gmail.com>
 <aZK0B841VeaDQ5w4@KASONG-MC4>
In-Reply-To: <aZK0B841VeaDQ5w4@KASONG-MC4>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 16 Feb 2026 15:37:18 +0800
X-Gm-Features: AaiRm51YL07XwCLRpDnl1bzYmcZGhOriLqlRjp6yzM2ZWVDai3YuU-_kptZhK_U
Message-ID: <CAGsJ_4wkFZ-uxXO9Rp_Snzym_uXUGD9HDyGF74dF8HmobLfJ3A@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm, swap: reduce indention for hibernate
 allocation helper
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Carsten Grohmann <mail@carstengrohmann.de>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CF85100005
X-Stat-Signature: ai1q1y68hy8f4w7awqsz8bgaihfpb4hs
X-Rspam-User: 
X-HE-Tag: 1771227450-483028
X-HE-Meta: U2FsdGVkX1+kJCM8klB1FohAxRiLFIfXEtYYO/DCh4JF25PPmbtOGozu6hPU+JElOFrhBsATTmOgppsE6bEPmBMvN6lgzVF/YtCHE743Lz8Z2rbHB/Ifmpcd8vFKrWxf8S0cxRGd6bvnpxpK5DKQEL4FdpQ/vBB+0FOCxWa+Eylm4COLMbl2KQZDqNG+kQAWNZ0CaxUIiNuK/4Qd6CBagvFr5zaNIosLGg6b7gXeAi9En+3RUK4srRIJsKWTtvvvQ+VWfDMI5Di/PortgL2tFW+77jS5ROIDLgjN1d1i5psyzKvfUq7q12oq9qqx2s9adlrhEb0tfdY75rYLXxi9RvIWlUf0o6N+tsNo/zyEPOxvgmQQxxL4SgTW9/RnjdxCGiLP6Tak5roMRpp+FSVZTOrPgseNR3OwTmYX+9rUq6xoDSorUZjBkHbjie0u0EgOdTimMzM2kSZotnsXag/C5ntHH+L69L+xmK34MpaCysLWPhYlwP2hHv2w2mCn8hfwAiDnDWB5yCMDoOzIvfJpdtBOFpLMtb0hcbKooYSWeRE90Y/GdleWAGEBUw6l0r2trfuECkJxwVy/wTNuN+UJHjJVRZfItW5EKCy3tUIWRY+sbcPdroQ0msfuqLe953tLW7P4qLRmUy9pSzn2UZXfguMMz90FxSbY1lOxL8GQ0hOZwgP1jDRzg45bJST70AaRqu3EkSqYLw4YbUkvrBTqKTsmeaypjmkjn+vZOlpxUmG4NRxrUDks3uzygP6TIdSZvhZ1ji7Gte9WLHFK10WTLJqpAbgQK3ywifqdeuYmmultRfwmGb8YxYBL8115nFrAHTb3x5Q2SKXtMqoZFEYAPptgy/nrrtD0xM7qdFTzfrvDAz7Un2eei++EJKgNGjY4Z7+Ah4TCqyhXOORcCox3o2KC9Yh0kUEpr4Q9Ao28R6OSMrijuoVPbkrhEsT1OZf/6q6Ycb0MycA1Nso46Os
 ji2bEpmt
 oLI60CP50BJEAR5cs2OPMAZI7WAXbl71M3X0GdFsIB0rVblQh7iOoWmKGfi5p4MLBxEiJuAzjhTSkDvh7p4rlY9RzJUyKVGKzBjEl+DudHuhdhFIjKQJwt17aP8QTgjz1coY+W4QQ8WTBxU5KoWjHk4PjRHRwYiYINGC6SHlndGqQT8toQenDadauWUnmlIn3iA8xN/Kxxh8QE8nYOCpw0gIobgIWk3xbazJQNLNW2o0RJqkafHenWzs5sCNr7uduhID9c72sJkgV6QX9K03KqIUa+ln/6EYrY3xy5ZTxerd+dhAF8mLQAo9D13qMQhD28McJ9eaIV8XfTunFtmczHyaNlymxIqjYSfL9yileYMeVlnnta9BarvkfRckVRsLGI5bK54NG1vp4ExLukx1j4HiwWj5h9e77WIzUwu6/TqiJ6ZkMn5fo04d38LHDlU+k9xhcF1qBuFxpFGn/1ir0zEz6eA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 2:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Feb 16, 2026 at 07:20:49AM +0800, Barry Song wrote:
> > On Mon, Feb 16, 2026 at 3:00=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > It doesn't have to check the device flag, as the allocator will also
> > > check the device flag and refuse to allocate if the device is not
> > > writable. This might cause a trivial waste of CPU cycles of hibernate
> > > allocation raced with swapoff, but that is very unlikely to happen.
> > > Removing the check on the common path should be more helpful.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  mm/swapfile.c | 38 ++++++++++++++++++--------------------
> > >  1 file changed, 18 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 32e0e7545ab8..0d1b17c99221 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -1936,27 +1936,25 @@ swp_entry_t swap_alloc_hibernation_slot(int t=
ype)
> > >
> > >         /* This is called for allocating swap entry, not cache */
> > >         if (get_swap_device_info(si)) {
> >
> >
> > I guess we could further reduce indentation by doing:
> > if (!get_swap_device_info(si))
> >     goto fail;
> >
>
> Agree, I think we can make it even simpler by having:
>
> /* Return empty entry if device is not usable (swapoff or full) */
> if (!si || !get_swap_device_info(si))
>         return entry;
>
> Then the `fail` label is also gone.

Yes, this looks even nicer to me. :-)

>
> I'll post a v4 later today combined with your another suggestion. Thanks!

