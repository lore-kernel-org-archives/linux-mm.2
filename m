Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12213C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 18:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FB26B008C; Sat, 26 Sep 2026 14:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0F76B0092; Sat, 26 Sep 2026 14:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0526B0093; Sat, 26 Sep 2026 14:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6614D6B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:38:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF6CA1608F2
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:38:31 +0000 (UTC)
X-FDA: 85256774022.11.FF4D8E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E150C20008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:38:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSXb6pTe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790447910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Qra4Hs5x0GhjkOw3qaqLENUU09DmiBO0O2Kq1ZFdXw=;
	b=42Y/8KZ9m++ZapwZgiqXpWxnTWZsFfeijskekA6iV82rsfFBZ0DN8f5/U0CpzWyxTZEnZb
	pS7tgwtv3zwEpQTTBFKspcF2M2C7TCPCe1tV2ib+YEXlroe0A334TkI06IaTxOBppdKWD7
	dfMvcednS3SXQGXm66or89CmKY6UTeQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSXb6pTe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790447910;
	b=epY4w8JEJY52FPHIG/nnSgDNIombJCmj8k5A4v+96Gxaq42ivVcxphrSocvt6G1QyqcmH7
	Env+Rf+bjSnn3999NKiL8z3nSXnI3etFK3ricR4+QHYYnOVlx+0jsQtRPqTuPwLl3VOyBo
	d1MWMOuHgCUP8dXc+l3QtznZYLLU1WY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9FA6447B9
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE3E1F008A4
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790447908;
	bh=8Qra4Hs5x0GhjkOw3qaqLENUU09DmiBO0O2Kq1ZFdXw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eSXb6pTewXsp3a0bCUeO8xrsdLzrJiYIt8xsMeUyG/r4+vwJv7+6+xHae5ybBZopW
	 QT6K/zzNom+nYMVEyyoeMuPHxh4GCFlG6CpcmF1Km6iGCk7eBZRT/UPPycaIz3/ymt
	 5mpjSc61OBsBSpBB4nbNsAW40JMd7DsEj7QxKKOQ8Y5rEm0LMV/x4uCMQbHtWGqVO5
	 TRrIs1i+MGrqgQdTxNyhMYGQmas9q4m0ViR12oUodGhuIQOiaG0cucisJ/8xh0orEY
	 GVJLGOQuZwN86Ft4yJMczG/omOgWepvlhY2Vk0HFohPwW35n522rnhy+zxTYhElFba
	 JgBnoxH+MzSdA==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6063d7dc4so2219341a12.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:38:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzDuABxLgRrbAM4O/yC4ABQ2e4xx8z+Fc+TCq8gu+kksAO1+1HdGOlxFCCCisyIdZzQNEVOwF9klA==@kvack.org
X-Gm-Message-State: AFuF++n6NnzSbjA+VCX4i7TmtRAezBG08Te7EH8CnDRDsYMNIS6LyJ+1
	KiPeX+zQrjC9WpcDi8v7fHm6eN77UyiURu/VKDOUboPXWHG+7sLjBVG0MrlO/TYjDcMYtckUG2r
	uxHlgWM2d+1kr0UQ6ej3Zoj5w0NYLjUOu/GP744s2Fg==
X-Received: by 2002:a17:906:f588:b0:c2a:ad55:b3fa with SMTP id
 a640c23a62f3a-c2ac22db042mr757145966b.7.1790447905700; Sat, 26 Sep 2026
 11:38:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
 <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com> <a30eb60221cda2fe726a86c2c6f859f71fc7a46d.camel@surriel.com>
In-Reply-To: <a30eb60221cda2fe726a86c2c6f859f71fc7a46d.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 08:38:13 -1000
X-Gmail-Original-Message-ID: <CACePvbVd8uE5mwPX8T95zbURhhXxO2zbRETziJcGwQs3tOLEng@mail.gmail.com>
X-Gm-Features: AclHuK-N2jo4ZJ9-ufy2a2NhRahWQY5CCHBUKvfMp6i2GWnJxoh5F1ffpf_MpB0
Message-ID: <CACePvbVd8uE5mwPX8T95zbURhhXxO2zbRETziJcGwQs3tOLEng@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ecam148ujo6qjzbsxs56gojczjp9pwby
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E150C20008
X-HE-Tag: 1790447909-585824
X-HE-Meta: U2FsdGVkX1+BpsZ9en9mAxYpTeIT7N6jXscc1zSLKlWXP9xu/glIjoHRgStWE+oucZTQCEkxBVcSkG9/QelgaeciJcL8SchqUT06V1DJpK1hJ03nuCutLLjsjdNO1vdYmUoMGj+++PMDwc1JdcFQartiQk3ExGlfka3m7Nh1jZnfUT4L/6nese9Sas+eTUaA7DzrhEbl3AmxW8cyu8vC1R9VHsM3dik1vu2FhGpJ3VmvDwrQvgH/jAu1X+jXH9pnTplJaJ2wKs4g97/G59iZG+n737sESgfyC/ct9bfP8mmcXxKUlQCcqr+k0B6kZR5DITHOdixkkVx75VdFkiQrgUcZznaNYtn3NZvxqgzf09u+yNTio4kcPvLsyIVnWlB2WEXktFH4ROWHR7FFo1OAPWDg8Ojx1lm/x0nXB+vi710ikHS7HeudzCoqXfyvCGSupfsYQpMXOh8ajnm9vYcsi79/v5yxMdXIkx8DZCchPmlTMFeub5+D3IxZC+m47N9TSAUgFnowj1bzD6ftVl09eduGXWpK+GW5jZVmh9dA0T2Y2BxsFnlw2F3dmDGeaB2hXscZNo0Vu2xngPdFVRdrBmL+LVImOXHrBTB2mb+ltAwiQ5EM5pvnh9aAIjS6wqXpyGOXDLqrmrc0ucXxntnx1Fg0/NjTxnCfHW/myGU7YdVj72IVsrsGOPuBNHZ72qEj2h44kvVb5/6Fl30sh2mhKIT1Bl5352DDTdKYpNX64hDszvDKiH3tQLhD3/NDnRoF91tPbLTgkkwo6BKgF0MlTlDmCRyUIqRCE35vSWmpLxjLSxStZyNtewaXUC4LzdubEOpHZx7I1XMvxZ3yInjwZK8ieZ7BAsklt4lWOQNqED+W1aKhbgoROOl7l3dAKWxQMUzeUK6n2gy6Z7lTR+RJMj/j1eGipTHiARuPdRBo/YuEPKBemc64Sm0GSEkjO0nHbdcJJlEoULeGrWIF74c
 NzoWqmuK
 LtzZ6/9/y2J4cC5PJ35LbsyVmMVNWvgeJBvsKI9c3AwLVBGe465qSsEUcz70SoUS+2RLv0NV/H7ROXTSOVzSzl07irNHYjbWC55BGt5CFQshYZTIIzlwOc1jOz1QtMOxFq/l+Wlfj1WRO4JFUd4xLgjtge6y33eKer4ltnZaXbpHeN8f7qjuPi4a4gg0aMGNccZPKQbG2S47NHO3rUTEm3VU/Y/8Vm55eJ60ZB87ToO8Xclm7Z9f7rY7t/WKID4PduDMHOPjICgWZU9f6wjrHscuyQ8Qqz2C77dfUAF73EySi+YXdxvSqQKD37DHy36BDhjMYUL28CKMk5l2gOgCl4Mj7I3+zP6w90sksN/aT3AaSv8ILTLa5i/nqUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 3:24=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Thu, 2026-09-24 at 15:17 -1000, Chris Li wrote:
> > On Thu, Sep 24, 2026 at 8:13=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > On Tue, 2026-09-22 at 23:18 -1000, Chris Li wrote:
> > > > On Fri, Sep 18, 2026 at 1:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.co=
m>
> > > > wrote:
> > > > >
> > > > >
> > > > > @@ -482,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx
> > > > > *ctx,
> > > > > struct folio *folio)
> > > > >         if (zswap_load(folio) !=3D -ENOENT)
> > > > >                 goto finish;
> > > > >
> > > > > +       if (unlikely(swap_is_vswap(sis))) {
> > > >
> > > > There are too many swap_is_vswap() in this series. It fragments
> > > > the
> > > > code path, making things harder to reason about. Esepcially
> > > > around
> > > > locks. I count 22 in this patch alone.
> > > >
> > > > I consider this the biggest drawback of this series. This
> > > > fragmentation of the code path.
> > >
> > > Could we avoid that by simply always having everything
> > > go through the vswap abstraction layer?
> >
> > Yes, but it will pay the price for going through the unnecessary
> > redirection layer always. It incurs performance and meta data
> > overhead. That was one of my previous objections to the earlier vswap
> > version. Sorry I enjoy micro optimization too much, that is both my
> > strength and weakness.
>
> We really only have two cases here, don't we?
>
> Either the data is in the swap cache, and
> the vswap layer can directly look up the
> swap cache page.
>
> Or the data is in some slower back-end,
> and doing a second lookup is not going to
> introduce noticeable overhead.
>
> If the micro optimization come at the cost
> of less flexibility, and harder to maintain
> code, are they really worth it?

In this case, yes. Because there is an alternative that can both keep
code complexity down, perform well, keep metadata small, and be
flexible.

>
> >
> > > Handling the details of what's behind the vswap would
> > > be handled one layer down.
> > >
> > > Chris, do you think that would be cleaner?
> >
> > If it can wrap below the swap_ops, it is just priviate inernal dedail
> > of implementing its own indirections. That would be much cleaner.
> > That
> > is what I am trying to pitch to Nhat in prevoius email but does not
> > have following actions.
> >
> Can you sketch out the details of what you
> think that should look like?
>
> What would the data structures look like?
>
> What operations should there be at the
> abstraction layer, and at the swap layers
> below?
>
> How should migration of data from one swap
> backend to another be handled?
>
> At this point the best way to make progress
> would be to hash out those details.
>
> If you are unhappy with what you have seen
> from others, what does your ideal design
> look like?

Those are very good questions for the people who want to take that
path. I can work that person to figure those out. It will  not be me
just handing out all the answers.

Chris

