Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6469DC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 23:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23DC6B0096; Wed,  6 Aug 2025 19:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB0B6B0098; Wed,  6 Aug 2025 19:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37F86B0099; Wed,  6 Aug 2025 19:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C35056B0096
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:25:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 543B61DCC63
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:25:20 +0000 (UTC)
X-FDA: 83747916000.24.E1ECB59
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7BB2FA0004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:25:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=krrUPuu1;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754522718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQoYrjjiOBNV8WkJzEHnMtMq/aX9CEzrVd+b2tWLo00=;
	b=JXVVOxYD4gUcfIHvElNJzDnjc2Y//WC4KbNfNqF/oi6mnD0Nd5FHb5nejKxacWJg0fF48U
	zxfXG9auqMtZzDxrZAW/ZV7yoGCL1OZoQhyk6B59ig3iZd1S5ScryMfLae02d9IsLXIta9
	ht9ak7KekEc84EVqYdSwYQZNz/pP8Ns=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=krrUPuu1;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754522718; a=rsa-sha256;
	cv=none;
	b=hJHGNQmqNI/jOd38utqW5Pi/4Ei5z0muet/mC8RaDeCSPKbaOv3VNVHO3ideSY38K6fU+7
	TWdpPId86o+1V1POa3YSb+cKAZBJohVHW45ivvVYcLeR18QnfK83PWN02F0tF7S9jktEA8
	uw9NOVXd9usuE2T0eqHkH4MFsWX0oCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 7263B5C69FD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38B2C4CEF8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754522716;
	bh=i7moJgUx/xSFj18d+Ij+O8XgpQh8iIyJg6xk2zbatgY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=krrUPuu1lBEhbNbv83U5eYBYHX+f4tM/rV/nhjMNi/Cki+nrqdMd3UUw89RV5hHtd
	 h31zUKdRjpSyvAJmsFrfa3+HF6oQb9eumCW+rWNA119EK5yyhWhUMQCyX+WLW9/PmU
	 ddHO4iiWpfvB1WZzgASwksMbh6MIScgvgnHgHHY/Q7ZSx5HcAChtWY++lzPILf++DM
	 tYapc+fSrh7t5GzEt/0yLHk/iU9nc24PNCGGcv3sWeLRzlfLgyrDYTbPuGCdLM9c1f
	 lpynCQeVNwbV7MloH/XSpftNKnp/F69yk1evNSA1IkKiPRi9y/0fo1l77T16fcgpMF
	 kgsvfDmMyL4fA==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-32f1df5b089so4020241fa.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 16:25:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+mTJnNKnBxS/XHiZrFrPqUQJRf+6aeiMq2z8onNhhGPSG3c1UDL705+DAZFMdvlgI94UH5jnUzA==@kvack.org
X-Gm-Message-State: AOJu0YylEPuPUq/G78pC1Nd0+4gr9Yj1jWkI0bHWEP2Cp4PfAKbb9r6Q
	oUzl7nDhTNxjsHr6yu+zjAHv6OBF1HMPOIqVRVQvhyGe4LUfoA8Wj9nJM6xcv+AZO+uStekRbq2
	e4uZEUSJBXLKY+IOZH7n4UUogPxBTUw==
X-Google-Smtp-Source: AGHT+IF6DYjTcp7hSvwBmqZfeirBCTH7sRLIv3f7sYHG2bcJmsjYkoek7c82LIHpLC5W4rMppUU5oJaohTRxwdSQpGM=
X-Received: by 2002:a05:6512:39c3:b0:55b:8827:b7c4 with SMTP id
 2adb3069b0e04-55caf357830mr1400649e87.40.1754522715597; Wed, 06 Aug 2025
 16:25:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250806-swap-scan-list-v1-1-a5fe2d9340a2@kernel.org> <20250806153146.ee1ee22dc8f6381ff5a6d882@linux-foundation.org>
In-Reply-To: <20250806153146.ee1ee22dc8f6381ff5a6d882@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 Aug 2025 16:25:03 -0700
X-Gmail-Original-Message-ID: <CANeU7QkxNfe5Ut8AnyJYV4eQOS4=aL6ni3EAcdfdgTTZ2vG41g@mail.gmail.com>
X-Gm-Features: Ac12FXxyUj4a1L_iBpo35V6Q_WzlHGvo7MstX2SyvqaYMO9ZWWJh3nSN8R54-Ss
Message-ID: <CANeU7QkxNfe5Ut8AnyJYV4eQOS4=aL6ni3EAcdfdgTTZ2vG41g@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile.c: introduce function alloc_swap_scan_list()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: siqixj4zu7ddxab17hm1a7919mzchqix
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7BB2FA0004
X-Rspam-User: 
X-HE-Tag: 1754522718-364788
X-HE-Meta: U2FsdGVkX1/auh/qTaqvP06gcwwrXg/rLD1MIqxk1PDKZKmwyBimduq0koiqo0Sx+/BymZtDJBvPrNrV0rdKSDi70szd5e6IAUlNy96iaiF6nx4DzTd2iYQ9Wu1PJkEGucZiIGSqA85A6uJ1XI55hZ6B+223DVS7ERnUWf3+6C2U8lIeHMbYYSYCd8AWPOsPUEqtI/V7o7UxqXKxeke4nPfPkh3KrxcOpDHsLJXehot341j7X2WW50Qe1DF/yqTqtu4uNDG0U08BXPD9pUAHOd0t9Bd3P7gSShAUg4WgE4gBfVx/fZQ8WtriWLNUKWfvTyg6Lyk7BKQyuCb4g9PCmKueracD/IL8mBbpa8FGGpZ2x7+QtjgYaukBh7CZNtRqb9xYxEIJIgo0/dRvUDsQLvjqJI2hxqrzYNE+eELllRNS6qHvnFHi0h2CLAXPP02fbW+s9TjZKQYQW5a9FLnD0e6YSMtxatG4QkzMAKcl6GU8Lv5MPA1D8vDafTB49oUu22P8LXhempeBTQvlJO1QZ1/fhQIzip/XUf/Rm3ooLzI7qJvx0LSGsI43AbJ2wPNZDf99pJFygbg4IwnSmKIuKikB0queU1Fn4zY+m0CgZu8nrhbHu+xC6eWMs1eYfai26L9Gbxj8JGRByfiVeV0spNmZP8K4g45Xs81Vf6pcce+Os/paCidx3l3ZLF0JF2qsqDqZ2ppWpbVuPdzbg1vVRPmVHtCXDOhfr7m9toPNwZTi4Dtn/qlANER7b/Ppc7qMSkJCmlL9upC9zUG032xL1uoDsgaf7mMdv3WNLkALYzrA/g2gkm0/ySkw53GlH2VRApz03MC4CW9NeMJ23dqy9REstFNJtwsZPiXbc3uUsVOPNUeY+J53AR1jpiaILm+sBrBVjpFtHskn6XehONL+Jaf/sNOJPr/Qkve4VDA/FbN/8gB9NW6swI+7l2ix6AR8iPLncx0ZkKPYizcr9aN
 a9WYdhxb
 OQJTRo0D5Q4dip8c0vW5CLTOBaL8kCPQrSlNT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Thanks for the feedback.

On Wed, Aug 6, 2025 at 3:31=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Wed, 06 Aug 2025 10:34:45 -0700 Chris Li <chrisl@kernel.org> wrote:
>
> > This the alloc_swap_scan_list() will scan the whole list or the first
> > cluster.
> >
> > This reduces the repeat patterns of isolating a cluster then scanning
> > that cluster. As a result, cluster_alloc_swap_entry() is shorter and sh=
allower.
> >
> > No functional change.
> > ...
> >
> > ---
> >  mm/swapfile.c | 86 ++++++++++++++++++++++++++++++++-------------------=
--------
> >  1 file changed, 47 insertions(+), 39 deletions(-)
>
> A nice little patch.
>
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 4a0cf4fb348d..fcb1e57d8108 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -820,6 +820,29 @@ static unsigned int alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
> >       return found;
> >  }
> >
> > +static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
> > +                                      struct list_head *list,
> > +                                      unsigned int order,
> > +                                      unsigned char usage,
> > +                                      bool scan_all)
> > +{
> > +     int found =3D SWAP_ENTRY_INVALID;
>
> but this function returns an unsigned int

Will fix it in the next version.

>
> > +
> > +     do {
> > +             struct swap_cluster_info *ci =3D isolate_lock_cluster(si,=
 list);
> > +             unsigned long offset;
> > +
> > +             if (!ci)
> > +                     break;
> > +             offset =3D cluster_offset(si, ci);
> > +             found =3D alloc_swap_scan_cluster(si, ci, offset, order, =
usage);
>
> so does that one
>
> > +             if (found)
> > +                     return found;
>
> `break' here.  To avoid multiple return points and for consistency.

Will do.

Chris

