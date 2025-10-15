Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C115CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D938B8E0010; Wed, 15 Oct 2025 02:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D427A8E0003; Wed, 15 Oct 2025 02:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32238E0010; Wed, 15 Oct 2025 02:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE1D58E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:24:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 705CD11B2B3
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:24:41 +0000 (UTC)
X-FDA: 83999359962.29.0E68E3A
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9039A180008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:24:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vgt+7uw4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760509479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GeB4B0o6ZFZSmSenqU/MXjy9m+7+CBsIYJA6lRQIgVk=;
	b=Uuwgd3+QBJ1m38OvZ8geZWFJZDbJxc15ly8EPD6RcPlZss81lYCCLvMEuHRgWe0QkJpDcx
	pFlmFG/98XxwpAHgGDkI9Xaf0CpG8uFoFFKMGzuY3xYl8+ZKzflFeyGyVMots/maDHrnAr
	cjyI1kZ+pzS9vxIQWLvZ8E7F+HLbL0I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vgt+7uw4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760509479; a=rsa-sha256;
	cv=none;
	b=JQUDJJG/2cpoKY9skOsBNgDPL97cz+AOu81+nvrAa3lrbk+V1uky4WhV/AD5GMLAMIf5Ss
	y0BaF+cgAT3iTtf9O8JiXGptNH2sMIX6F94qTv7wZEW5LUJ0XQXsnqvSxh/SxAqIJFY9zE
	x5bAmeKxoSv25UO9AGaufNUpu7f6IWU=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6364eb29e74so10771622a12.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760509478; x=1761114278; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GeB4B0o6ZFZSmSenqU/MXjy9m+7+CBsIYJA6lRQIgVk=;
        b=Vgt+7uw4BzVPiusQNi4a3aI18WPCwsOv2o32Q0zvxondXfY+YYbtumkKmy9yO7WH59
         kgl79kGktMCAEczK84ND0mRlpBySJquZxjqCqEpCvVE+yxPQogqFoJQoB89VvnVLkhrD
         mA3gqLFJmh7pzoMpjot9wXm6vHaxHGrtsMdNNsGfnrCKBom24rAascU9taRclzKHWqb8
         UR8eHFeqaGUmvzePbdSFTlQSAJFJ/xnOwh/zVYyk12wIHOHhQp7r6e7kLzZplvj9NnlJ
         N8DRFpwQt3TLJBuLYou5p6AuDOv+Ne8KVEHrUTWlq5np4RHQbxTQtPNDT0NNdCjhZZbL
         GFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760509478; x=1761114278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GeB4B0o6ZFZSmSenqU/MXjy9m+7+CBsIYJA6lRQIgVk=;
        b=ZsSJkfNY9Sv8kc+4M5Hg5+6zH9/tkLSD+w/WAt2D5vUZHeRwWwOGuaCoJI9HEgnQD/
         hBhtj5E60yDCRRrYgrkWsd169uyNooI1Pg0T/XVy5kUyWx02O2/kkFv6/Wm9gz0L/Bj/
         SuP3SSXafq684O1n63Ouuu1TYRssT8hTKw+5DyrrS2b0rBoxOHrhSa3z3hScoD9C09S0
         7JVsSFrBe/GJVrKd3Wk1hTuSCCNT+HujKjXSCh1KPmN+TTgU474gtG2Z5ndRN/7HNR2R
         wUKHRro7FjwGkAUdA0AGy68hCqp62/5jx2E+g6UNNCzhUO6Lxpq0GdPQ27PKd46DQ3SY
         qGYw==
X-Gm-Message-State: AOJu0YyqeM1/zlBVO9zRNeZo2EEy9/IX9w7kgnmN0wsV9AbQBI+9dR7l
	IVd7Ot459oGPl1LcuM7Oqwt2OmOqweUZLR5+cWVyWiUoY3v+/auj4aS2NJ6xHcheLZmEAc81s7T
	kEf3W7LZR/PZ3P+Rw4sA6bST24D5fJ1M=
X-Gm-Gg: ASbGncvNgJ9cgcpgTs8pIzrEfBqDNV3Nrz1fd+gJqhG9DnOsB6ITC+5yNidDRjHJxCO
	CobnLlgN5I7jxL1Dc5oTJW6VWLc6m1CPfmNaXanz61sdCa6/b82cPeMu61ONA9djqvnIy3R4N3g
	eD2PNwCZr/e0u3Oqdgb8u/mIAtKTZg5XYyBOcfV1RkCePDqX3fQ9ME+zGVbcbGaBw9u/QvYmRet
	ki6pP1ZpJDJFyGlRwkLZd9YSw==
X-Google-Smtp-Source: AGHT+IFGGYslRbnhLBUwy7KAbmiw67Ch2lThxcHUMdPIPl2puDlhXq9qNFXqkvb/itUuPZnYJTygWkNuhYr2Usdbfts=
X-Received: by 2002:a17:907:3d91:b0:b3f:f43d:f81e with SMTP id
 a640c23a62f3a-b50ac0cc027mr3233214166b.40.1760509477753; Tue, 14 Oct 2025
 23:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
 <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
 <CAMgjq7BD6SOgALj2jv2SVtNjWLJpT=1UhuaL=qxvDCMKUy68Hw@mail.gmail.com>
 <CACePvbVEGgtTqkMPqsf69C7qUD52yVcC56POed8Pdt674Pn68A@mail.gmail.com> <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com>
In-Reply-To: <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 15 Oct 2025 14:24:01 +0800
X-Gm-Features: AS18NWA-c-DVGGUWjG-BgLldOVeKrj5tzV3Y865Dq2enhOArH1Y-wIuE0E9YoPg
Message-ID: <CAMgjq7BJcxGzrnr+EeO6_ZC7dAn0_WmWn8DX8gSPfyYiY4S3Ug@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9039A180008
X-Rspamd-Server: rspam03
X-Stat-Signature: gm6qyu8ykophki71c39dt3hjn8rs88q5
X-HE-Tag: 1760509479-509193
X-HE-Meta: U2FsdGVkX18xdiL2AgL21VgILvvfZbO+EfDrUn5kGKYdFZeIlO5Sgvam/pTQ8furBK6gxuj9qpZfRdZ+/KNgZ4X0EF3uSFVv+uysvacihWZRguGU+9WHVLm0B5z4qMc8QLnY+dttsK7vvNvd/meus7r6d4oOC4wHP5brsg4ligbk8nGPOUnRlk+FAFszosT5nxvYi9kel7C3qZobPFUJ0OUTfHZ1MeBk62CJwW2PDRC6F9l+lgIgKNwinHoQmXEcJoq17X38nJN9u/JMu4QRsA46LicX76pIoO/GitFD2z1IFytHKSO9MZcjsf1CK5z5QzbB3duX8aTal/HLMscS2pOfehbD/hqZfMYaiCz4HT1Jmtl5EkYRFl/Qd+fcMXPG8cNEmYCqonlJLJcsrzKPj145wTZkEss4h++Pw8c1n8AETFMoZLaNvU0gk3YioFPhkYuPfD7i6Ywuwm024XPB5+cJu+RRvh81pxgHe6eHHLU7ncq6BxU9lXE9YLOrHsYvtxilG7+WibnIdhfnibYDDmjj7UohycpORQ1XB8kEpzEdSH9Fxn/dDD4E9jE9IkIb2tcZs5lhVrBnTGpJ0nwkXUdQ/6BKgMYh1XqlBgjUg76YJEG4RBLqgGr2ZegUBd66mYY+iMD6xEkxx+wJjXzUeYHfUdsD6p8b+ywOokK63obyPAgxTePfFvbK9fpbV8cYrDzm4hdOS+a+1goreuEG5IZjkXCNs7J9AbHNo12Zt3cPLPovact7mt7xQdosX1EYDhZmxkuFmJYSvO0TOckCqlW9F4XJwtyB7l82hB/uTJbspHFmsqxv3xHoSjt4mZ2gGxamgAfQw3wm8tvP3md2K0zqjPDP5Jz+z6J9/ehqnnGw+ASfFIbVfTn1ts95Vm2mWaKM2aXRPLF5OfElRIB5E4icGxd7MoPlUo3tFeCCh+W5/3Af4XyC8rpiSXhaAyIP2pjrYsGMFKAJ0f4Ug/w
 q9gBVlNn
 lPkL5LrooAxHS0CxU9qFCk1u7LsNjV/UGbpQLPciod+8GolSiKx5+kNJcBsn13+9sWOdYNnY8gOZ7mEMpHOf4NuhPgXjYrvoELk9vNCzyumbxwl6xu2PHVkKmUHo9f+eXuZfIQ0gmlbgez6HmDJYc04ufectYDHQmTUEqucBNJe+xXEPfTAoKmB0oM+TBe30BFUygsSDKYYAdB/Npg0JRXbimTPssPhupgbxFzlQyRtG2vMRCjjwo+rzlaV+XtJRBv44BBRkJDcPdihdek51+m4ZJNT4UqFzNcXDXQnTgSQnU23UK5VOI9ebJXtumZ71krawba4ur+haIxsVLJnUiyylOSIE2FRabu8Hz4XOQ9A9XamJraDwHhK0WJGhYtgltGNofb3Lnjn1x2qlEhro+Q30HPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 12:00=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Tue, Oct 14, 2025 at 2:27=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Sun, Oct 12, 2025 at 9:49=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > index cb2392ed8e0e..0d1924f6f495 100644
> > > > > --- a/mm/swapfile.c
> > > > > +++ b/mm/swapfile.c
> > > > > @@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swap_en=
try(struct swap_info_struct *si, int o
> > > > >                         goto done;
> > > > >         }
> > > > >
> > > > > -       /*
> > > > > -        * We don't have free cluster but have some clusters in d=
iscarding,
> > > > > -        * do discard now and reclaim them.
> > > > > -        */
> > > > > -       if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_d=
iscard(si))
> > > > > -               goto new_cluster;
> > > >
> > > > Assume you follow my suggestion.
> > > > Change this to some function to detect if there is a pending discar=
d
> > > > on this device. Return to the caller indicating that you need a
> > > > discard for this device that has a pending discard.
> > > > Add an output argument to indicate the discard device "discard" if =
needed.
> > >
> > > The problem I just realized is that, if we just bail out here, we are
> > > forbidding order 0 to steal if there is any discarding cluster. We
> > > just return here to let the caller handle the discard outside
> > > the lock.
> >
> > Oh, yes, there might be a bit of change in behavior. However I can't
> > see it is such a bad thing if we wait for the pending discard to
> > complete before stealing and fragmenting the existing folio list. We
> > will have less fragments compared to the original result. Again, my
> > point is not that we always keep 100% the old behavior, then there is
> > no room for improvement.
> >
> > My point is that, are we doing the best we can in that situation,
> > regardless how unlikely it is.
> >
> > >
> > > It may just discard the cluster just fine, then retry from free clust=
ers.
> > > Then everything is fine, that's the easy part.
> >
> > Ack.
> >
> > > But it might also fail, and interestingly, in the failure case we nee=
d
> >
> > Can you spell out the failure case you have in mind? Do you mean the
> > discard did happen but another thread stole "the recently discarded
> > then became free cluster"?
> >
> > Anyway, in such a case, the swap allocator should continue and find
> > out we don't have things to discard now, it will continue to the
> > "steal from other order > 0 list".
> >
> > > to try again as well. It might fail with a race with another discard,
> > > in that case order 0 steal is still feasible. Or it fail with
> > > get_swap_device_info (we have to release the device to return here),
> > > in that case we should go back to the plist and try other devices.
> >
> > When stealing from the other order >0 list failed, we should try
> > another device in the plist.
> >
> > >
> > > This is doable but seems kind of fragile, we'll have something like
> > > this in the folio_alloc_swap function:
> > >
> > > local_lock(&percpu_swap_cluster.lock);
> > > if (!swap_alloc_fast(&entry, order))
> > >     swap_alloc_slow(&entry, order, &discard_si);
> > > local_unlock(&percpu_swap_cluster.lock);
> > >
> > > +if (discard_si) {
> >
> > I feel the discard logic should be inside the swap_alloc_slow().
> > There is a  plist_for_each_entry_safe(), inside that loop to do the
> > discard and retry().
> > If I previously suggested it change in here, sorry I have changed my
> > mind after reasoning the code a bit more.
>
> Actually now I have given it a bit more thought, one thing I realized
> is that you might need to hold the percpu_swap_cluster lock all the
> time during allocation. That might force you to do the release lock
> and discard in the current position.
>
> If that is the case, then just making the small change in your patch
> to allow hold waiting to discard before trying the fragmentation list
> might be good enough.
>
> Chris
>

Thanks, I was composing a reply on this and just saw your new comment.
I agree with this.

