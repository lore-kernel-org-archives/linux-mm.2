Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D08CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D516C8E0006; Mon, 15 Sep 2025 12:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D287B8E0001; Mon, 15 Sep 2025 12:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65288E0006; Mon, 15 Sep 2025 12:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B502D8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:25:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A64A13B4B1
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:25:20 +0000 (UTC)
X-FDA: 83892009600.02.28F8C0F
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6BD3D40006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:25:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K8muqtxT;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757953518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMJNhdJv+scko5BawZPjnYJ0aP4LRJcbG8zsCsFfSa8=;
	b=lE760r4n6Xfu4npmulSp1fI35ui01048xnC1KveUuB96nY6yXqrEr5s+FsM1WSoZHMLSkn
	2+kKlJTjRJh5BIX27bSbflSSPD6smBuL/9Hg9uHKFT4pdNouYnnpBkPq3Uwlru29VwO1RH
	KeuC1Nk5tktMa8fLqV4G8A/yLldtkzE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757953518; a=rsa-sha256;
	cv=none;
	b=KlIaFoIS8jfKoNbtB+FJflFRIxOy5kQF/OoMZ5DbJ5FFTK34IcaawMvr/Mg+Eh4TFNzoOI
	iXy5GKRhKL82PGYbWlG3gms8iWFWTsoxzvqCxIfjP1BgdfjwRqVm4w9HnqwenvTECgTg99
	Wxfr1QxRHgw3NxB59sHJ7W5z58n0db4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K8muqtxT;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b0787fa12e2so624180966b.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757953517; x=1758558317; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kMJNhdJv+scko5BawZPjnYJ0aP4LRJcbG8zsCsFfSa8=;
        b=K8muqtxTIFBOij6YgTmWbgOeh05k96lpUvGey4UdiciXYIRWSr9aeyinBE9OZupKY5
         CGZ7IrF2ruIkH4NjYpT/iMpmDhjmAKvkCpbhSd9nOd7KMMCp2mDnEU+Krnt0Zbik5fnk
         ADuycuvHjxQsvaMAHlkXx35ie/57o/FcWdrBEu280gBKwyfpWcizPj0E+zbmA/TLNehO
         5upQuUZ0e0wACmdp6vvpb4/hZ3lGeQtV5H7lEBSD2hqAr2htRpqkiG1aQF73NaFaU5Xp
         5RbR7i5U66TFcrPnrGxT6+NdhMwORnNtHK5Re7ynIt58hqQ0JQzAOuQc+wI4dmq7shK+
         b/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757953517; x=1758558317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kMJNhdJv+scko5BawZPjnYJ0aP4LRJcbG8zsCsFfSa8=;
        b=RF934RaYfqLYPYPnQQKqsAe9XVQK738ckLjlyyvgfxQbaK4uIY7w2l+dH7ah7v+28U
         bSGwZEkxMLqgPbcjlFpD7vk8EuGcB1kV7JUv4wm7+UJ4xlG9BWmnVT//PxQwqZPar9PH
         V7JojI8B7MfVXebUdPh6l2M6PtPuJafkb5ZjLANeOvZrULJENqBe9GzjALbz6ZQeR+Ne
         TB5Q/6YuehCAz/VxsOvYIeNuGHbUwSAUuCWKPbCPP8Qoc+ZivvfWSoUBznKx4sAF9VS/
         4zFJ4g1Tt2l4gUoV6JcEEK4Gj1XcXzqxaKewMGkRyDrnl3S0mrVrym5JFL+hJFeBFWnm
         UWYw==
X-Gm-Message-State: AOJu0YyarOnjRWuSNGEFzWWQWziDdCD+VSJbdmHILXQj07yxse9PETau
	jUASbvYN3S9i7MHLd2G4/TzZ6gtRoiw9u/+dEa8i4W8Wll6z8WS1ctqqggNKz1S09y6pX1YJzoG
	nQFi0xTcEnrOSRTmKXOg2xa0Ux5GUovA=
X-Gm-Gg: ASbGncuhxF7120wjqxcIHOaTvZou7oKuza9hwYm9oAm/GPA4+0Dn4sAKYaVczv3L3Xr
	MOwjgSQhpqxT0lk8Rlkr3yfeOhVuFZ2TvaBhw3OkDc/5zgtARUmlFTD4BZuARxwcr0EIRMnQ0+H
	T0RmLM5huPqu8J6nrpNKFAis5PWLmWvynVSgkCmCgsv+Lut+Sl60rECi14uWUPyc+RG18yifiB2
	uRMFS1Nl2PUWLruO/2odw==
X-Google-Smtp-Source: AGHT+IGKKrKGYhH6a3eAVycEo8JHovvecpIDVESUCCwt0LR+vetnxGlT4YcHWXMDxH271NLb0pokN/iSIjUZjGOiddg=
X-Received: by 2002:a17:907:6ea8:b0:b04:37b2:c184 with SMTP id
 a640c23a62f3a-b07c35d4be0mr1434123466b.25.1757953516544; Mon, 15 Sep 2025
 09:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-15-ryncsn@gmail.com> <20250915150719.3446727-1-clm@meta.com>
In-Reply-To: <20250915150719.3446727-1-clm@meta.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 16 Sep 2025 00:24:39 +0800
X-Gm-Features: AS18NWDS6bsQxblqYbh_bcvmIy7iEJRQRRFAqbNTw1YIXPg7Vr1ljkQHLNBiatg
Message-ID: <CAMgjq7A1hqQ+yboCtT+JF=5Tfijph2s4ooSqNwnexQ9kwJOCtA@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] mm, swap: implement dynamic allocation of swap table
To: Chris Mason <clm@meta.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6BD3D40006
X-Stat-Signature: sprm1z4mmep9bjjp4tk6y96uoijxwjmk
X-Rspam-User: 
X-HE-Tag: 1757953518-571063
X-HE-Meta: U2FsdGVkX1/V0zsJkWbJxLWFe3/vGOTnxxA/EPh64dQIfK55eVeZe1qhMqrckSS++g3qn0zUNMTzqJHYXoSqI0pyVHsajYln/B5Qp6tVIaXG7pn8TtPlCa1Y79416cs0CY6grei0AdBurey5RscxjXlET2aF2at8ksquZHWmlnzUvM6YQLTMzkPTzLR7K/axYtYIeoSZFDzK6NiLpqKDb1DNtpZ377JYJy0Pcq3cnxs2SakSgTk5VQPG8Bx01ilmgmF9LjmW69mB9nGW1wEZP7Fk1oXW8SdgtOoFjUXZ9vfmecB3OwR67EcyBIkkb6oZ61UdjcIhe2Q96vV1DZBjWxANQUGjurgOEb2melQOFmeyOjaNQvBIQxwcPgIC3sAQc6BaKSMIbBMtAD8TTe4fB9PSFK3697y5m2M7lpVbHq/oiBoZUNVFIS1qDfNICG0pgluiN/snFnT4U7VRlghwjcoWtoUJbL9on5pKuugKWDYP1xX4WaMY0q0f9FSH5xchOkmAVoE1sojmn7n1LAIOGCeXGppD49m5tyFsSI/xdAnpSHBrVAi9Vwyk4bI9b64pjltnZdqW/SzPPGtthQ19DAID72ouQ5XeTzJJvBrqrfwDTPlXaHm9FhgdPpkSMWp+84bFgfBYZtMWCP5lusOGHprPTGLulsqYNm0zCmwePwNuetJj8icTiQ/9HpAuUoLbUOikmKj2MY2WJIGlsWh55+7w+teBTgQ/M+VZ3n7RtHyZb/cI/0BYrBxrjrMusX738Abas30UWCLzfhqGgCnxOQPPQ7gngZpL3S0BHwc33Xivb9v11RdV6k90PbrtiqCV9aCnaZBe8TbDprbtMzu070m6fVou5toiGs4weBzQ0yr83U6J/JeR2PEVGD2+mA8VEKBQqXS0qQB2Z+BU9McJ9boA53kB/wROoA5oLeqwBKEgbIfySkcArxiqSATMNV1xHd24JDsSnm7SaDeVuQZ
 KtIYUOyN
 npwI5DXc5K49zZ9BDk7FNEM4nP8SU0FRMJG6wqirMp4KnGt/mE9gsNrqSNlkyftCaKCLNrEFo5ibHYT6lFRIHUoKhEWsVido+KDyay466jsyl581VWztg8q+ohY5aKQ2fn/x0PRO3J/EfvZGjbUL7lBkQowxeEeHemGMNpQATsm1gRKo0mYCzsZRNmzi/TJTW+yEiAVqfrBjxycEfRfXDnZzosIsnbtCgYVwoBu7hZZYNaFOi71+K73YTDDUCTH5Wm1fJJjhJXh5x4O8HbvCA+QBvwbQRw5iYohnGzslaLg8VfhrkSurSL29JgxvfZUbXNYTxnBmAjrJ1uKy7Ex29Ve3r8SLNzog0O4IL0+AfEOAZt+8TTUcNagz097zOcJCcgzAgwkxoimsQQpOT3768ZhAl2IGY1FEx70xJ3CUDI2asaPBSYuwrXVCpLsDz6NGBvknCiTP/LP/ROiEkmBYTZAoC0WbqycOL9HY4TVp2xTURjzM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 11:55=E2=80=AFPM Chris Mason <clm@meta.com> wrote:
>
> On Thu, 11 Sep 2025 00:08:32 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> > From: Kairui Song <kasong@tencent.com>
> >
> > Now swap table is cluster based, which means free clusters can free its
> > table since no one should modify it.
> >
> > There could be speculative readers, like swap cache look up, protect
> > them by making them RCU protected. All swap table should be filled with
> > null entries before free, so such readers will either see a NULL pointe=
r
> > or a null filled table being lazy freed.
> >
> > On allocation, allocate the table when a cluster is used by any order.
> >
> > This way, we can reduce the memory usage of large swap device
> > significantly.
> >
> > This idea to dynamically release unused swap cluster data was initially
> > suggested by Chris Li while proposing the cluster swap allocator and
> > it suits the swap table idea very well.
> >
> > Co-developed-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Acked-by: Chris Li <chrisl@kernel.org>
> > ---
> >  mm/swap.h       |   2 +-
> >  mm/swap_state.c |   9 +--
> >  mm/swap_table.h |  37 ++++++++-
> >  mm/swapfile.c   | 202 ++++++++++++++++++++++++++++++++++++++----------
> >  4 files changed, 199 insertions(+), 51 deletions(-)
> >
>
> [ ... ]
>
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 89659928465e..faf867a6c5c1 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> >
>
> [ ... ]
>
> > +/*
> > + * Allocate a swap table may need to sleep, which leads to migration,
> > + * so attempt an atomic allocation first then fallback and handle
> > + * potential race.
> > + */
> > +static struct swap_cluster_info *
> > +swap_cluster_alloc_table(struct swap_info_struct *si,
> > +                      struct swap_cluster_info *ci,
> > +                      int order)
> >  {
> > -     unsigned int ci_off;
> > -     unsigned long swp_tb;
> > +     struct swap_cluster_info *pcp_ci;
> > +     struct swap_table *table;
> > +     unsigned long offset;
> >
> > -     if (!ci->table)
> > -             return;
> > +     /*
> > +      * Only cluster isolation from the allocator does table allocatio=
n.
> > +      * Swap allocator uses a percpu cluster and holds the local lock.
> > +      */
> > +     lockdep_assert_held(&ci->lock);
> > +     lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> > +
> > +     table =3D kmem_cache_zalloc(swap_table_cachep,
> > +                               __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_N=
OWARN);
> > +     if (table) {
> > +             rcu_assign_pointer(ci->table, table);
> > +             return ci;
> > +     }
> > +
> > +     /*
> > +      * Try a sleep allocation. Each isolated free cluster may cause
> > +      * a sleep allocation, but there is a limited number of them, so
> > +      * the potential recursive allocation should be limited.
> > +      */
> > +     spin_unlock(&ci->lock);
> > +     if (!(si->flags & SWP_SOLIDSTATE))
> > +             spin_unlock(&si->global_cluster_lock);
> > +     local_unlock(&percpu_swap_cluster.lock);
> > +     table =3D kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_K=
ERNEL);
> >
> > -     for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> > -             swp_tb =3D __swap_table_get(ci, ci_off);
> > -             if (!swp_tb_is_null(swp_tb))
> > -                     pr_err_once("swap: unclean swap space on swapoff:=
 0x%lx",
> > -                                 swp_tb);
> > +     local_lock(&percpu_swap_cluster.lock);
> > +     if (!(si->flags & SWP_SOLIDSTATE))
> > +             spin_lock(&si->global_cluster_lock);
> > +     /*
> > +      * Back to atomic context. First, check if we migrated to a new
> > +      * CPU with a usable percpu cluster. If so, try using that instea=
d.
> > +      * No need to check it for the spinning device, as swap is
> > +      * serialized by the global lock on them.
> > +      *
> > +      * The is_usable check is a bit rough, but ensures order 0 succes=
s.
> > +      */
> > +     offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> > +     if ((si->flags & SWP_SOLIDSTATE) && offset) {
> > +             pcp_ci =3D swap_cluster_lock(si, offset);
> > +             if (cluster_is_usable(pcp_ci, order) &&
> > +                 pcp_ci->count < SWAPFILE_CLUSTER) {
> > +                     ci =3D pcp_ci;
>                        ^^^^^^^^^^^^^
> ci came from the caller, and in the case of isolate_lock_cluster() they
> had just removed it from a list.  We overwrite ci and return something
> different.

Yes, that's expected. See the comment above. We have just dropped
local lock so it's possible that we migrated to another CPU which has
its own percpu cache ci (percpu_swap_cluster.offset).

To avoid fragmentation, drop the isolated ci and use the percpu ci
instead. But you are right that I need to add the ci back to the list,
or it will be leaked. Thanks!

