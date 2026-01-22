Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79526C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 02:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF926B00B8; Wed, 21 Jan 2026 21:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9CFB6B00B9; Wed, 21 Jan 2026 21:43:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B976B00BA; Wed, 21 Jan 2026 21:43:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A92F16B00B8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:43:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55B591A153B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:43:17 +0000 (UTC)
X-FDA: 84358053234.06.D486429
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 58FEA4000F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:43:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YVXX8Jt/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769049795; a=rsa-sha256;
	cv=pass;
	b=qiChil/ZEGSXGU6IA1w2B9kBqaCj0l0ApvqnHc7jjXRHgn6bfGgkKqMfgnxjjMSfiualPU
	nhqdS4tEErW43NXgtFa8Kms+Kefc2tOKjjpQ2O79duUbE2rwKIoGU3KzYs3eNi374GvJEY
	GATo14DVFc1dTWdxwsgYaQFi8uaMZ2E=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YVXX8Jt/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769049795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxXUcjQ44JCW2HptJvxF55yGvNXT4jkLNymRKeJ4ZDA=;
	b=o3uEHWb2jvyJxhlCdYCHspxocy4z5COwGV9v/WtkNuW2JSkWq3VVIugvjGEBRXPclvRYKB
	D1MfEZJjI2iZ/zJ0jgQnXBBmGGr38md8vLwBbZogjMk0UKyGwzPjbSMdd1mjVjuIBfX0Hp
	xFPRkuktlaNKs68zheUZqdTJ0bM40sU=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59b717b0f80so74714e87.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:43:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769049793; cv=none;
        d=google.com; s=arc-20240605;
        b=h9loe7ksZ8ZBmH2hxv6X4MK6U8TVhhnvG6Pqml175hFeWkCMVkIuxRLgYZS+whboAA
         KGJ6A/znck1lk2Q5dv68xMCKLcwjYodONd+9Fyw7dI6J71D0vSFwL977lz43FIwb98mC
         /gRUrXacoiDMs5zF2TrJzTOaLseYaFJRfsNO8S41g20yc34kVDVDZT78VCiCPmF5m5YX
         2n75Qg3p3uXkKfWRQ54hJg7BSkOhd+Jdqf3cxFgoRROCZ7U2ddjHOAhbJQTDM2KmHtN0
         bq8d+0+sy0bBFrtvK88i0X3Z83m5EPQrsplS3RSnffit0zpihAFIhVoMda3KGbxlarN4
         QICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hxXUcjQ44JCW2HptJvxF55yGvNXT4jkLNymRKeJ4ZDA=;
        fh=f3BrS5oLG1M1YxAkQLNogFCGlquFsHNLfMQbOhAfIHc=;
        b=BgD0+Ti38PsHqPsnu/TZTHcEz/TXR5y+PvShICGSmW6uphZ2PAbAK7maSezx9KliOg
         NGGCxVl7O3RszDuP4lvoJDkHYNVFV5T5waq6IP2AZUJFqstDHmyQDT7PF3jBC6Q5cFVv
         2qvrYBkK45QJlZxiya7dfeHJ44R+gbH8/RhozWI3J0gah1PPhSsjLWi2HRVfbbjsAleg
         v0uIf2bExQRk1gYJQq7xdIO+M289ealkuAkAJ+KUug45MW0VMBRTnr8tGinehFKaca9t
         ORU+v9SAjwmRd1/cKsSg7g/PPP9Eb0vWtIXIvZGiREIMpby8CMNCyOIzrVJB4AyZNHyz
         qaXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769049793; x=1769654593; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hxXUcjQ44JCW2HptJvxF55yGvNXT4jkLNymRKeJ4ZDA=;
        b=YVXX8Jt/8CjuTFB/Ua89axqgdyl7dC2x6p3Khb1jRTMnQUnwMouYeABuZWs08+RGru
         vOB7/1ZG1zf3IrpNoAq1iIhjyPegEZVTf2iTVAQYuETMFulgcdDC9Xc4SQlkAT0SOACn
         gtjv9oJEwh2sIqVPm9NEbhqwWcIf3iNivVHMo0Qlhr2KBspCURw/Sq3RS302cveKUr0A
         zQE2IaO3V2pAgF5FPbu5ren4JlLDKhV/zIx7LxKS3r6u5axKtyfk863WWnONgP0JIbpf
         MrN28upRc3ISGHNcGlo3spzDZEIhVbXiIuRuBtBFfs6/M8lWkKehypskYTR4hB7XUv/O
         WOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769049793; x=1769654593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hxXUcjQ44JCW2HptJvxF55yGvNXT4jkLNymRKeJ4ZDA=;
        b=osFRm4NR/DwhSH5UPFvUgHQzXzAg+K5GomxzJrCPGp89VwnJVny9K+GYInnnQOZq1a
         Y2p5/Vwo2d8AgktJEHDcY0od9pj7CgMbiqwSGB1Lr5cpc6JcYiWI4qa2LmKbE+Cfn2Ru
         SghGvjdVEkOwK0yoa12uAu2BSRCDnkcZg6Gei08nIIz4HfRPXip0TyzS23oQ5xv+OiAf
         681ZrpqwQIVH5HpW7eyoghFw+N2HBgUVQV1XHtlZtAv8zsBi/iIoB4pHpmHUar8Rs2Cj
         ECk0IV+JS3aKDNo0GDBLHS8+2ijP0AAy1dKj7yXm9OTz3wSMCyh6nOvsmvjeIQjDLNoh
         VGuw==
X-Forwarded-Encrypted: i=1; AJvYcCW78rem//OleJZ5WLUzRCm8wtnzC1NMKaJubDRPi6Ty5M35R3A4VqhyX4n3WHhVsp3QIyvhcEerhw==@kvack.org
X-Gm-Message-State: AOJu0YwkNDgTWD+Z2g/rduT0gYr4TUl3FvFfvnNQ55jSnN5UNwBRBfjI
	0SbnV8hK9jC0SZN73fCv/Midz5lMTY51ZjhId6YwrmeoHZyfAUH92ytTTYMK2aOHlyeuaRe0q8D
	PGjoTzqdk4Rt05PM57A5voKBr6oBpeqY=
X-Gm-Gg: AZuq6aLlO8yp+J7QbBjmv3R7P6lTz4KNv36VQ67W4YQEtppxBTmnTROdTkPyRm6gzzQ
	WOABwfjzJeUdznkpINTYJLPPC9hj9SWAUCNs9zE0Xr3CgeRF7KZLj0NG8hgdw7IOp8zC47cVRcw
	IFUvhBFtFFeGidky4u3Xo1MMNcSyvTdShxELiyRqhXEKHUOR3j3387PRJW4WeR/F9iQnuheowJ3
	0kr9DeufN0v+gwFJFnPeZn6DYlhyN5kYE+GaXUKYBpIS5iV3cHvWh4y0GdtsIU/AxG2XHQemWf9
	2Z8FTtg=
X-Received: by 2002:a05:651c:1a0f:b0:385:c7f0:2b1b with SMTP id
 38308e7fff4ca-385c7f02c21mr997961fa.3.1769049793170; Wed, 21 Jan 2026
 18:43:13 -0800 (PST)
MIME-Version: 1.0
References: <20260121090620.559242-1-zhaoyang.huang@unisoc.com> <20260121155410.459018-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260121155410.459018-1-joshua.hahnjy@gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 22 Jan 2026 10:43:01 +0800
X-Gm-Features: AZwV_QhIE6ZtMkoBbl4rqO5C1iw-PuEnsv1OlCPNesBSqGtzmBROxQZqwkFsjMo
Message-ID: <CAGWkznHr46jSDNPMxk684QYcRTJnNk5BOhuMQoRvCxkyEBKdZQ@mail.gmail.com>
Subject: Re: [PATCH] mm: bail out when meet the goal of proactive memcg reclaim
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 58FEA4000F
X-Stat-Signature: zmb5jbojbwibh6tcjszg8jmpbxh89dmm
X-HE-Tag: 1769049795-417007
X-HE-Meta: U2FsdGVkX18/xlxZaKwBYfI4osSaHeXwwJ023liDF05Q/sy1MbdICNu2GsPUvAOkwXC2fe42l4MpjxU41PHMpQCjHMJM/wKNkUUibXMKPkPWdWxEJWKru3f3MHMx8MagPgk+uIpa0fPiOgLjdEDWZddZ7DJ/ZjHx32T4y2Av4bAXB40qGg7rAHRkelUfZE4PxzZNHiEscFtLo85kkjpeV7euCYZ4a581KqZT68t5+CMUesFOuhCwFT6vZuqJSy/cHJ5fjzpkn3QiAsgjIoyr9pKKNkBxiTFD3DsWaKl3c2mGJZCKeMHXEAN+xZs+h3KerJfjKnsQby5kREtTO9VKetNLMJmkrSmbtY5hi7ktR8KOkFulbsR3EDZ0g28SjJR1SbJ+9TorheIVT+rX+uhSXM/PWinNcMcRovaIbGDMwPun5hsRnvcj2j8Z7QM1XoOjkSysNVD7NYH/eoE19mTn7thIws5PiELqIvXBupzPvNHpGT/gzQdI2GceExxWu3Lsza4qLdShcfKf0O7Mz74NeSyVczVEU4fptPk+ln825r45cnrt3oF5FIh3y6LyZVolNGtiqYUlm59EVsUZUMRa7ba16D99u50BYSu0BaJvDdAX1cXjJADhD1q4JB7pHycvUS0Xq/oETcXIyjVGLXyExK5rvkXsXCR60lrhU60GaTDbqCHPmyZdrlGVW+gqIhsh5EfPHUlTQ3bStCmg/tmTH8ndDmtUNrOzwKPJoHRQ0ZkdilaTXeKHWJsyg1AIBEeh8Mcf/CMpM2kCfMpmCFP0W4fDsCXA0CXtGkh++p8oOz8ew8pHD/o7SVc4Tq0FN3s7g4kvHKaffh8Xzt8pRJzJWxkTw1BDblUaq0fn9ZRlbNjy2LO2cPlUSUBTld6S/fiTElVt8mOoRGp/RnFPyMpzIQbYOcG939ncsfWVuJtN7g6Akt7KRkZ723jqqFV7vSJQ06il5GgF9skroasGk+e
 JBa9vArN
 VxXEaVegKgfiy/VL7Kqo9/3v3mH8UaqJb5HGwTLBNNjh+BJEpQbyTdB9lxWkw9GwDQN65RfINg7DuHFVIIXL8Bqt7DlL43zjg2ZXGd9ALOvR2NM9dIGp2GzQcExAGt1X6aW9MExljOJfkaj8MZex4xcUaqTVCe7wO83Q7oME+6WXCpWDrZhx3ZsnJ5Q+M1KUz0wsqVbAqbrLasgCoQ3G2TyWYPkZM6NZ1mJ2HWIk+Pz/lIsCEXsNzFS5GheDER8M9N5ejdxCP/LPiiuIPRqlqSauaKKaDlyXQTTJnk7xgXYEZSDNvU1U5mQtZP+h3pSUKCJEYn99qUV+SyU96UeUm0kfb3E+zlH+CfTamXxans3uHJZKgnPC3Nt+s86FKAcQmz+ZHnu8um1LTu3boSDCuRJ3BybkcVbVy5MOUMiSn0NfDnUSCPk1BtlBu4g0dVIZEF0VBDAmKaOxn86VmplSxQO1uQ2IH9Rg23qtYwVU9gsj+M2BcxXk4EmBkk3osSl412b0Xo+W1DX2vX+Ze8nYcLj4kis2MhjZxUtfwwzJScpTEc9lRbk0meCtkFU42nP4W1yzuHvNrpXX0BNo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 11:54=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> On Wed, 21 Jan 2026 17:06:20 +0800 "zhaoyang.huang" <zhaoyang.huang@uniso=
c.com> wrote:
>
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Hi Zhaoyang, I hope that you are doing well!
>
> > The proactive memcg reclaim defines the specific target mem cgroup
> > as well as a certain number of memories, which is different to
> > the kswapd and direct reclaim that need to keep the fairness among
> > cgroups. This commit would like to introduce a criteria to have
> > proactive reclaim bail out when target mem cgroup could meet the goal
> > via its own lruvec, which means the reclaim would also go through the
> > whole tree if the iter start on the desendants.
>
> I think the motivation makes sense. If a user-initiated reclaim has alrea=
dy
> reclaimed the amount of memory that was requested, there's probably no
> need to continue traversing the tree and reclaiming more, and we can do
> an early exit.
>
> We also don't need to worry about fairness among the target memcg's
> descendants, because if the user cared about that then they would have
> specified one of the descendants as the target_memccg.
>
> But I would also like to go back to what Michal also pointed out in his
> reply -- why include target_memcg =3D=3D memcg? Wouldn't we want this ear=
ly
> bail out to happen down the memcg hierarchy as well?
>
> And most importantly, have you seen any issues in real-life as a result o=
f
> this? Is writing to memory.reclaim too slow?
>
> Please let me know what you think. I hope you have a great day!
> Joshua
Please correct me if I am wrong
root
|      \
A     B
|    \
|      \
AA   AB
|     \
|       \
AA1  AA2
Let's take the above hierarchy for example,  assuming proactive
reclaiming launched on AA, there are two scenarios
1. AA has folios charged( 'echo +memory > AA.subtree_control' happens
after a certain time of running), which will enlarge the reclaimed
memory by many times since it reclaims on itself and all descendants
without check nr_reclaimed until the traversal finished. This is what
this commit aims at to have the reclaiming bail out when the goal is
reached.
2. AA has NO folios charged. Keep the fairness scanning among the descendan=
ts.

PS: reclaiming launched on bottom level wouldn't be affected as there
is no traversal at all.
>
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> >  mm/vmscan.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 670fe9fae5ba..5dcca4559b18 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -6028,8 +6028,15 @@ static void shrink_node_memcgs(pg_data_t *pgdat,=
 struct scan_control *sc)
> >                                  sc->nr_scanned - scanned,
> >                                  sc->nr_reclaimed - reclaimed);
> >
> > -             /* If partial walks are allowed, bail once goal is reache=
d */
> > -             if (partial && sc->nr_reclaimed >=3D sc->nr_to_reclaim) {
> > +             /* If partial walks are allowed, or proactive reclaim whe=
re
> > +              * the target memcg is clearly defined that could let us =
ignore
> > +              * the fairness thing, bail once goal is reached.
> > +              * note: for proactive reclaim, the criteria make sense o=
nly
> > +              * when target_memcg has both of descendant groups and fo=
lios
> > +              * charged. Other wise, walk the whole tree under target_=
memcg.
> > +              */
> > +             if ((partial || (sc->proactive && target_memcg =3D=3D mem=
cg)) &&
> > +                            sc->nr_reclaimed >=3D sc->nr_to_reclaim) {
> >                       mem_cgroup_iter_break(target_memcg, memcg);
> >                       break;
> >               }
> > --
> > 2.25.1

