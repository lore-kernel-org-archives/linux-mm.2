Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD97CCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE1F8E00F9; Tue,  4 Nov 2025 03:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95CD8E00E7; Tue,  4 Nov 2025 03:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CABC48E00F9; Tue,  4 Nov 2025 03:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7E428E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:27:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C3DC58E53
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:27:11 +0000 (UTC)
X-FDA: 84072244662.24.DAFC7C5
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 329974000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:27:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RSUQ86Td;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762244829; a=rsa-sha256;
	cv=none;
	b=VAohh+s9i5U4VDEmEtPkwyeHksAk3P+TKvhCOlmiXsC3Tx3vgiYJgICiMd+S6PZ8+OBzpD
	kKyPfjU5zXNHfDLOQ1bijvbwc4lkXCM3JgQ2Ow5gx8WteYPKNTKX6/6ne/KCKaBgIlLLbO
	Myz25hcIyRuV13E6IY8itiPa/sDG2Ak=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RSUQ86Td;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762244829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dsl3eSPMGHDSeCMQfe8F9VblZgjTpAHCpZj1US9DKJU=;
	b=oSKuLb0Ux6HcP9npMfhuEI/KF5Ol/vxZ1KV+whewuYLc7brdtNwSRfZHzE5QuvTDenxwIu
	AL0Df8qQh7kIZ71v9EYHxuHb8czvdoz64dcFohUKT2dXW3tCBQi39NjPh0IZrdt05Kbj/V
	twVVWonL/t5gv5K54ri2cTsAPJuu21U=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88043139c35so37645816d6.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 00:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762244828; x=1762849628; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dsl3eSPMGHDSeCMQfe8F9VblZgjTpAHCpZj1US9DKJU=;
        b=RSUQ86TdID2/BVOWgodBrIES6vMlxuXqzy6MIjuuMSl3Af6jJo5l7Bot84EjNEhWwS
         NERlXn0QqT81kdN82adpgmQlrzGhcQi1RwwLtiKxIpXZEDeGcMeFKTg+6Nh0KlGeN/FE
         tO9y4CSJrckBYut3TCfKymLowP1zwntMIVIdOGtOqpziIfsxtbvlGY7HbzHL4yBcZiHO
         G6K/yFhOmmKX7Ek85f3oisT+aH9J2opKmT9amzKjKD1xfTc76bhn6IevGuiEf7Ux4QcZ
         X3NnpSPSve4erF6J0Kr9dVX61OnzXYCCviV0A8pXf4gZcLrfN1mgLNUqYhlkAJPHudsy
         0QCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762244828; x=1762849628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dsl3eSPMGHDSeCMQfe8F9VblZgjTpAHCpZj1US9DKJU=;
        b=ee2Tx0GbDZzWDgkcc6a2CM1O4R9RGrz6+EVmOZyjE6yXSy3j5cP3EuIM1OtI0difYd
         S+YRETsOD2qVAc94ebHVqtuue6kEIkZjgndiNw9IJtXDZK6e6PlPXnrIz4XvOE9s1JUV
         IZrjyZIoSG1fbbHELdxgQP6aGUtNvDhGkebZm7dIqlr6YDKBbz/1a3wn8UX3xADyHKCo
         ZT3tAZbb5De40mPAPj10t/xw4GhEEhLV3/CTTeAadE9f1vM6GHKSz/0M542BCWNj8z2H
         G23kfhmPfTegrJZ3xXhPf+5rpxP07FHgNUMqCGqL3tAjcIR0lPi8OYVEup7XMgvjJ2m/
         IC5w==
X-Gm-Message-State: AOJu0Yzx27+tFgXs0m03BIrygFAwfVBpz5NO+FXunHPmYxnk17ULrUzF
	6p/qYsYQeKvjhb090sTqin9kzqLYRjzxesH4Cv6MQ4gQEIDoEGhYsTAFhCrX8pu6sIXtKqKVsrI
	S+hs825CyzrfCPV6eneznnyL+OO6REbY=
X-Gm-Gg: ASbGncu/YIha11rtwSNFloR0DMCzkTqUfBreLWSfrwyjT4mxuFZBmbcohexc41VH0lk
	1tFxc6pORhHlxfUSK1YOJGgGIbRu+d/pwXfMAwkymViiwZSfxDkHyt/H5J1eUAlDc72dP5Vn3Qr
	KkN5VJa47pDtl4NOq+XUw8fBC0a1uK33eRjJAzpZJM4mrw+9MByEEwDns9OOLPwbGM77bu0NNFd
	RGGEyrtYnzaw7eethJ3kK2FF+xp1FolRhRujQquCB4ckGiS4YYHufIXU7LTMSS5iM+V/MWXnoFG
	vW6EoKzGyPin6V/H
X-Google-Smtp-Source: AGHT+IEKVcw2eH6PyJhOzgmbwq21XNi3dsg13Rpx8YePsUrKcKLMXD7+fM0/Ai7dsMB3cQA/RENWt65njrN+60ehur0=
X-Received: by 2002:a05:622a:8d11:b0:4ed:3e3e:a295 with SMTP id
 d75a77b69052e-4ed3e3ea737mr158504211cf.26.1762244827989; Tue, 04 Nov 2025
 00:27:07 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-4-3d43f3b6ec32@tencent.com> <CAGsJ_4xOd0CJLZvzvZu9mRLjVvV0OSKE8NcBAYe3wvHFtLjWyA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xOd0CJLZvzvZu9mRLjVvV0OSKE8NcBAYe3wvHFtLjWyA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 4 Nov 2025 16:26:57 +0800
X-Gm-Features: AWmQ_bmuf89iPst2Ey-dfW5gYteUGfZvgjEHk6ux4Rp2snZpFJr3WPiwVrf2uoM
Message-ID: <CAGsJ_4z9xTd=oHDuzLbdkyhd_F=tj2A3K_dsp33dXad6pvVZpA@mail.gmail.com>
Subject: Re: [PATCH 04/19] mm, swap: always try to free swap cache for
 SWP_SYNCHRONOUS_IO devices
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 329974000C
X-Stat-Signature: eke3hoswdt1y7bah6wy7oet655oz3pwb
X-Rspam-User: 
X-HE-Tag: 1762244829-304361
X-HE-Meta: U2FsdGVkX1+yaWBgE3UyEgAtgZ++mdWUiKqeNboQD2u4eUWiTqipluZq7nEvmaVoQiSUDNGKKhAYSNgn6E8eXkYyTdKDaM/zW/MEP9vhyglDMQbxcqRr462AXPhTMeet5o85Xd//qNBMw7Oawlrm5yN/Rm5R0ixHHolWhAFimSHkZkow5LQjO5p+OqmB8zZ6AR+r23HR1AL4Dm5C7/CCVfZc0A74SVoRkMhYNVLvRht3DI0VaoPMOvq24Pk0VQdeim2V49lobmissS20NaNRtdDuBiztSWXpw/I/7kdo5/mLiSKrR6NSeRP55ZBybloi3iSGi5yToccoJFS+pvNpgxO6pYWfikClcGy/gCnaGFtNJhrBgEPEAGaqIg54j8vWg1z/v42LWStuFiPqTnwNR4aVEy0fUGvTpqd9Cntvku5c9wj2Ah3WBWItkz3ghTHGpX/dH6m8AWc5M+vLksPuIE4xCXtx5LLIOVXkiT06L5BVsfDWs1ix4eI0BOa/aj8R/sdvm+yvXrhehjMhQbUUO7dZL48TpvHJ2emB0GBC5wTfMJiG/VHlFqaeWm+3AJl4rtNkgguFr2e/1HQ9ohO1JeAFtHhFy3MJQ1FP62B0Hd3iiBd2Imrmho+CB1qjO3N6DzQFDARqyuYCvf2slA/1ungtA+IMRdfWrndZYVklU/m96IkWEDR89AbpyasMn2uK/L3N8r3BzV2w+EEhkcIl+yH+tHiENrj+JN7hYvd2MtNArye0lt8JQ2VuglvpxsQr9ncZJzWfNfXwsfyvF7cOLkpZTSYzmlZjDbB/K6K+VvO2Cxf+pUBSgzL+xK2xBO/PKHEe71xWa826JrEbQe218mTW1CE/LuzKn+dipA9uVQB9qh06vAMgPPMLU4h80hR3E0fLPZP2Fbfg1wQLdaaNtk++uB6bbkR2fMusIv/VraqE/599ZnIoVDZEO+JiwZQIaXeEuu6j9WihmmtMj9d
 uACk00r/
 n99to9WIssECKum+n7wwA0TqsuAF9fEE5fxOQ+8hOD52BFxoluHH0NEJdI26KlCShBY90J1r+XxDKEVeDedqvUaWDbfhShIIeTh4RVRNV8NNxI+KIZU35rRqtuXBZIfKG5q7YCKi40O7fHVj2ciqTXHMkjnXn9Mu0+Y7JGZFeIvWp/WMtlsrNVJWWy4Jy/Z8xB64+zh0KmhPA+eOLQ4Ky+elcOa2ComkHEU1AlsDQAFrFCk4j0ibIb2fpXGaHqBhKqZ8mqBsjOjwXpBQc6cn8VUWQIjRcZVJtu2HFKWMoXVJHhI3v5g+2cKuZdbvcZCTGFYEpoNuI3v0Cj8UURVypf3+EAaStC/UJGBWntRfEmJIwexRwbMrX/0IzsWqPpEriO1xXxnWnTZmEjsnKXW+23wt5dCZeO/9n0ODYAFIqGTJgRCrE8vkD0xzmcvbBQBbm5Ih5RaEiT5+2CHk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 12:19=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Wed, Oct 29, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Now SWP_SYNCHRONOUS_IO devices are also using swap cache. One side
> > effect is that a folio may stay in swap cache for a longer time due to
> > lazy freeing (vm_swap_full()). This can help save some CPU / IO if foli=
os
> > are being swapped out very frequently right after swapin, hence improvi=
ng
> > the performance. But the long pinning of swap slots also increases the
> > fragmentation rate of the swap device significantly, and currently,
> > all in-tree SWP_SYNCHRONOUS_IO devices are RAM disks, so it also
> > causes the backing memory to be pinned, increasing the memory pressure.
> >
> > So drop the swap cache immediately for SWP_SYNCHRONOUS_IO devices
> > after swapin finishes. Swap cache has served its role as a
> > synchronization layer to prevent any parallel swapin from wasting
> > CPU or memory allocation, and the redundant IO is not a major concern
> > for SWP_SYNCHRONOUS_IO devices.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/memory.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 9a43d4811781..78457347ae60 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4359,12 +4359,21 @@ static vm_fault_t remove_device_exclusive_entry=
(struct vm_fault *vmf)
> >         return 0;
> >  }
> >
> > -static inline bool should_try_to_free_swap(struct folio *folio,
> > +static inline bool should_try_to_free_swap(struct swap_info_struct *si=
,
> > +                                          struct folio *folio,
> >                                            struct vm_area_struct *vma,
> >                                            unsigned int fault_flags)
> >  {
> >         if (!folio_test_swapcache(folio))
> >                 return false;
> > +       /*
> > +        * Try to free swap cache for SWP_SYNCHRONOUS_IO devices.
> > +        * Redundant IO is unlikely to be an issue for them, but a
> > +        * slot being pinned by swap cache may cause more fragmentation
> > +        * and delayed freeing of swap metadata.
> > +        */
>
> I don=E2=80=99t like the claim about =E2=80=9Credundant I/O=E2=80=9D =E2=
=80=94 it sounds misleading. Those
> I/Os are not redundant; they are simply saved by swapcache, which prevent=
s
> some swap-out I/O when a recently swap-in folio is swapped out again.
>
> So, could we make it a bit more specific in both the comment and the comm=
it
> message?

Sorry, on second thought=E2=80=94consider a case where process A mmaps 100 =
MB and writes
to it to populate memory, then forks process B. If that 100 MB gets swapped=
 out,
and A and B later swap it in separately for reading, with this change it se=
ems
they would each get their own 100 MB copy (total 2 =C3=97 100 MB), whereas =
previously
they could share the same 100 MB?

Thanks
Barry

