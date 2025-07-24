Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154ABC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7598E00BA; Thu, 24 Jul 2025 17:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE968E007C; Thu, 24 Jul 2025 17:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4668E00BA; Thu, 24 Jul 2025 17:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4648E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:23:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31B28133B2F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:23:22 +0000 (UTC)
X-FDA: 83700434244.22.89BA9B9
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 459C1C0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:23:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4F+ko7uz;
	spf=pass (imf10.hostedemail.com: domain of almasrymina@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753392200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNnTJ5darf1pQDB2vsYeV7FJpreNa9uOT82oPg1Gxp8=;
	b=Pqt6Iyahm8Jo8p5adrht2odDQTN1IrWk4+anHcJGE8b8hV2XJ4/+UIStG+KzRiFcAsT6LN
	BdtoUZSOQ4MTnn+gbmgJXQWN7tmNshWUGv8CmZpULtxNYBjzmitJ9Twr3vgocWjU5HDwOp
	vDvJEi7lo7fkdlvFpfvBfcecqTAZFj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753392200; a=rsa-sha256;
	cv=none;
	b=UQmbobpcI0jiYoldP07m4CXEj+0VXOX7C8kszSuXzvY5IMU9jqY0Iz6rHJNVCMdUefpM/6
	VE4QL25zyUuGHx23bEP1AK6Ao/tVW9XXwqND1Og/KiaIiz9FrUrOmYbE3SCd+K8N2Rzm7a
	aTht/ddvxVbir/xHaNH3MCxnWHrx6rs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4F+ko7uz;
	spf=pass (imf10.hostedemail.com: domain of almasrymina@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-237f18108d2so65175ad.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753392199; x=1753996999; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNnTJ5darf1pQDB2vsYeV7FJpreNa9uOT82oPg1Gxp8=;
        b=4F+ko7uzRBwRq1F0CGWu2rlYhhmbNacuoL6K5pJ3QJ8MMmpGGU8o+9LLjSZUdf9CCr
         RrfcpoZ3XJwSG2lJCirxRsDbJdvZh30BFIItEKMC143tM7E/A6uB8fSCpDMsuoiNw5RJ
         Wz+rZF6vAE/ur6qMgKLir1o9VgfNbJB1trJ5RtBts+QkpFPVvc5guuQ9e5myJGFkFWu5
         YtQEl5MENpOnS92ln01J5Lcexu1esdHS4uHdbVkyFf8Mo22Yk06GFQ/z1QNBTDDp99at
         h/ozLlEI248eEjObIs1f4HX0tgh/2WVs9gcuBPun1hpycn8a+56Stc7ZxWdT7WquQGJB
         RwGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392199; x=1753996999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TNnTJ5darf1pQDB2vsYeV7FJpreNa9uOT82oPg1Gxp8=;
        b=BfIsWTU5/Kcbqj1BKSlBpNwgt4E09eRDBge2usWuK/SW96kg3z1C+JfApfbur9apet
         KgxU3HWqdOqA5Z/vnnTFbhx4PXsjpp3AYumI7KU8YrByS0Fnae6AkUjF0qJFBoEMdqxx
         e2B9/X1kpycL3dsD5f5STEd6H1Tktng0V+97/5hRWgCF9wUk2AW6MjrladBB3ZV/PL5S
         q67mSSnFryTVz/zhU52XC3ZPQM2YqYbOOFVO5/n0+gj7T33UQMU0VwulAeRrONZr0MUl
         X5ArfYnlWWFZQ1KUFqpjjfRxD3CTShR8o44Xz4IMUwXhXpUipu5hv/snxfvqw05sixmW
         pw7w==
X-Gm-Message-State: AOJu0YxpyqGtnekax+62sZ+NWtxfP5MQ6+JVBBvyxMT45bT4c1qFst34
	MzWsYNh+bbhQkObnFXyVGkzQ2XYl88uCdCTPFelyqnsddtV8XDlUl6grSkVW203xMAXzOdW11f1
	0ct41FqXioKT0bvi3jTLwsHilQrSy5aTCydAnxKYt
X-Gm-Gg: ASbGncvXTWnCjumZExJtAvfZVZo075cIWr/YpTmmrMDNkI5usRy1Qzqrs1tPXbCJoLN
	X9a29OJvSGuhNNMwE7WF9VBsOXa8Aki2hlSNccBP3KtyLiVQ77TmQ4PJ3WbM2frAC9Z+dur+Dgw
	nRGuKRh9QwNhyQWptIcedwL6C0w1ccVV2IkauanBXspMmMZ3EPadNT/eoy0qErAMIyarD4x7CoO
	7IlfaLbhWM+nj1nCM6DBz1Dq6h0qhgwUfL7qvIO4kJRpV70
X-Google-Smtp-Source: AGHT+IHP4CcY56s6tdK30PaY3+VQezaoZk4lvk+rDg73ia56t/qWWvkH19hG/XzNRK1ErwjJSSAFdSL4fYDkuZlCRh0=
X-Received: by 2002:a17:903:32ce:b0:231:f6bc:5c84 with SMTP id
 d9443c01a7336-23fada5b364mr924205ad.8.1753392198670; Thu, 24 Jul 2025
 14:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250721054903.39833-1-byungchul@sk.com> <CAHS8izM11fxu6jHZw5VJsHXeZ+Tk+6ZBGDk0vHiOoHyXZoOvOg@mail.gmail.com>
 <20250723044610.GA80428@system.software.com>
In-Reply-To: <20250723044610.GA80428@system.software.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 24 Jul 2025 14:23:05 -0700
X-Gm-Features: Ac12FXz-gExQLTDVuATyXHwkSGv0B-njaHRD7KrjKadlfvJJk-4Hay1UO-wB7MU
Message-ID: <CAHS8izMO0LO1uKu0peSAC8Sixes06KLfKJvyQnAOiLfDqZd5+Q@mail.gmail.com>
Subject: Re: [PATCH] mm, page_pool: introduce a new page type for page pool in
 page type
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org, 
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, 
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch, 
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org, 
	kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com, 
	baolin.wang@linux.alibaba.com, toke@redhat.com, asml.silence@gmail.com, 
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 459C1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: nbcfec3yiazo1y8x1sum1zfh9mr1kjqy
X-HE-Tag: 1753392200-445363
X-HE-Meta: U2FsdGVkX1/RL7Y+/unx6KE5zoNNWA1edOKyywzCoWsgqiJqTT6mlHErQ0K0pcGbxYqMc9Jw4sRCcX7wXL9se0JonfccWwRcmdjhIo5CqCgWUftdJhao81NRYVDgms41t7mrCaHznZI+xR5TY3xI/SlRXz7sbRbTJTrNJqGlx4xb9ejmZVRGGGzqwtlJqeM8TfJeeMzkySjwBChgoV9DIebfCj/JmV8sZcrgWke/ZT2nfW2C/9jc+X0qQfEeHT6yJtVv7kE5YylkpXKuSVYJu8QEh1VmANcDKI/+mZWNaYFpMce1sJo6ycsAWUzsrY5HG6sJNB/vF8CaFOdu1O83WnvZkthdQ2iVmcrOKf3DnYFTkbizzv2AQWDx5dzflHY2xxL3NRVIW67fkJxEXnfe1P0GM3xgKcivBqlln7YrdnB5PzoMxTGoZGkXU7ZCfQzOA+h7v3//03pmWdY850O9ffiwjLXUFt6mduwLTf3zxBOVLYf8XZbnG1cQPNBdVToEeyaAtVvxxOJTZX6YoNk7OTAV4q2JM+wokhjUXmPhzlMqu0au8iMR2Z1BR4UH5fDEc2esvW9AFJr5ozMzedcXC08zI8g7f0YM/0La1gtIOT8142cFswQ5BDfXdulpNpIoT/Sb0jyP8rLH98m37Vv/ctK/mQSGRbw59fwLx61Z034wKGQkG5KTVkF0UGsHfECfmtI4aUs1rInNjgQHOILtI4AHXp79kOhkotzXYnffqZPFMxjZSRYPZ1PP4+umfIMq1Vn5Focnn2fFlkkaNYhZKsqu56bfnImMgP5I2jAstZswiotbk3eA11/Yf+Qinrgw+MjxDRF4r6kL/4aPHVN7RPlkxAMjWzLcuh2LyKo9Bj1m/xUyjvT+bSRfku/JV3jyJ+KXLpE7L+SxY95jhkJfS0SNsRWvJsCVOAGlNfgnL4EuJslqlx87YDNBur4kkj5GDpTyqka/S2CY798utb3
 Kbn+m3L8
 cwWQErs2k+cvNLW2jrEj30HAhqB4ZJvX3pW1lCtex3QfefUde8lQJWONZQ/Pk09s1wVekFwqrMQSmGBKsYOfYTQbP0XWCHlZdTvoTf0yuZSd05gkGKYEfLLynY2/9utaid1bRkZDJDwwh/CkWRius9+L1WtluMCwJ6YtmkAsjLqjlCp1qNcBrJy6AD0duVerkfiTfcojebIshnYrjvalA7CIreZiQLUlRHAVN4WB1jhn9TEzxAKE/86myYG6taGG83JW/QZ8M7DPo2LhPs1iTyAh3BFKfEz9YTQpzCb/wugTANgpaMLjP/bKRFJNfxbhGGUkWWEF8SRL3sPSUs29d4NwwHTWXKy6CTXhNz82ENJh/BBUT0JFusmjK+6L/6ONT6lIaOS1WZ7VNTF10o5UT9HNuELc38dnR0D72hRHx7nB6SPdRI72LjXZoVU0PXQ86AJxy04dLAiH/are3tm7DyCzNIxRDXbGTkSxvatYcu1GAgHM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 9:46=E2=80=AFPM Byungchul Park <byungchul@sk.com> w=
rote:
>
> On Tue, Jul 22, 2025 at 03:17:15PM -0700, Mina Almasry wrote:
> > On Sun, Jul 20, 2025 at 10:49=E2=80=AFPM Byungchul Park <byungchul@sk.c=
om> wrote:
> > >
> > > Hi,
> > >
> > > I focused on converting the existing APIs accessing ->pp_magic field =
to
> > > page type APIs.  However, yes.  Additional works would better be
> > > considered on top like:
> > >
> > >    1. Adjust how to store and retrieve dma index.  Maybe network guys
> > >       can work better on top.
> > >
> > >    2. Move the sanity check for page pool in mm/page_alloc.c to on fr=
ee.
> > >
> > >    Byungchul
> > >
> > > ---8<---
> > > From 7d207a1b3e9f4ff2a72f5b54b09e3ed0c4aaaca3 Mon Sep 17 00:00:00 200=
1
> > > From: Byungchul Park <byungchul@sk.com>
> > > Date: Mon, 21 Jul 2025 14:05:20 +0900
> > > Subject: [PATCH] mm, page_pool: introduce a new page type for page po=
ol in page type
> > >
> > > ->pp_magic field in struct page is current used to identify if a page
> > > belongs to a page pool.  However, page type e.i. PGTY_netpp can be us=
ed
> > > for that purpose.
> > >
> > > Use the page type APIs e.g. PageNetpp(), __SetPageNetpp(), and
> > > __ClearPageNetpp() instead, and remove the existing APIs accessing
> > > ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> > > netmem_clear_pp_magic() since they are totally replaced.
> > >
> > > This work was inspired by the following link by Pavel:
> > >
> > > [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@=
gmail.com/
> > >
> > > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> > > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > > ---
> > >  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
> > >  include/linux/mm.h                            | 28 ++---------------=
--
> > >  include/linux/page-flags.h                    |  6 ++++
> > >  include/net/netmem.h                          |  2 +-
> > >  mm/page_alloc.c                               |  4 +--
> > >  net/core/netmem_priv.h                        | 16 ++---------
> > >  net/core/page_pool.c                          | 10 +++++--
> > >  7 files changed, 24 insertions(+), 44 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > > index 5d51600935a6..def274f5c1ca 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > > @@ -707,7 +707,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xd=
psq *sq,
> > >                                 xdpi =3D mlx5e_xdpi_fifo_pop(xdpi_fif=
o);
> > >                                 page =3D xdpi.page.page;
> > >
> > > -                               /* No need to check page_pool_page_is=
_pp() as we
> > > +                               /* No need to check PageNetpp() as we
> > >                                  * know this is a page_pool page.
> > >                                  */
> > >                                 page_pool_recycle_direct(pp_page_to_n=
mdesc(page)->pp,
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index ae50c1641bed..736061749535 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -4135,10 +4135,9 @@ int arch_lock_shadow_stack_status(struct task_=
struct *t, unsigned long status);
> > >   * DMA mapping IDs for page_pool
> > >   *
> > >   * When DMA-mapping a page, page_pool allocates an ID (from an xarra=
y) and
> > > - * stashes it in the upper bits of page->pp_magic. We always want to=
 be able to
> > > - * unambiguously identify page pool pages (using page_pool_page_is_p=
p()). Non-PP
> > > - * pages can have arbitrary kernel pointers stored in the same field=
 as pp_magic
> > > - * (since it overlaps with page->lru.next), so we must ensure that w=
e cannot
> > > + * stashes it in the upper bits of page->pp_magic. Non-PP pages can =
have
> > > + * arbitrary kernel pointers stored in the same field as pp_magic (s=
ince
> > > + * it overlaps with page->lru.next), so we must ensure that we canno=
t
> > >   * mistake a valid kernel pointer with any of the values we write in=
to this
> > >   * field.
> > >   *
> > > @@ -4168,25 +4167,4 @@ int arch_lock_shadow_stack_status(struct task_=
struct *t, unsigned long status);
> > >
> > >  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_S=
HIFT - 1, \
> > >                                   PP_DMA_INDEX_SHIFT)
> > > -
> > > -/* Mask used for checking in page_pool_page_is_pp() below. page->pp_=
magic is
> > > - * OR'ed with PP_SIGNATURE after the allocation in order to preserve=
 bit 0 for
> > > - * the head page of compound page and bit 1 for pfmemalloc page, as =
well as the
> > > - * bits used for the DMA index. page_is_pfmemalloc() is checked in
> > > - * __page_pool_put_page() to avoid recycling the pfmemalloc page.
> > > - */
> > > -#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
> > > -
> > > -#ifdef CONFIG_PAGE_POOL
> > > -static inline bool page_pool_page_is_pp(const struct page *page)
> > > -{
> > > -       return (page->pp_magic & PP_MAGIC_MASK) =3D=3D PP_SIGNATURE;
> > > -}
> > > -#else
> > > -static inline bool page_pool_page_is_pp(const struct page *page)
> > > -{
> > > -       return false;
> > > -}
> > > -#endif
> > > -
> > >  #endif /* _LINUX_MM_H */
> > > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > > index 4fe5ee67535b..906ba7c9e372 100644
> > > --- a/include/linux/page-flags.h
> > > +++ b/include/linux/page-flags.h
> > > @@ -957,6 +957,7 @@ enum pagetype {
> > >         PGTY_zsmalloc           =3D 0xf6,
> > >         PGTY_unaccepted         =3D 0xf7,
> > >         PGTY_large_kmalloc      =3D 0xf8,
> > > +       PGTY_netpp              =3D 0xf9,
> > >
> > >         PGTY_mapcount_underflow =3D 0xff
> > >  };
> > > @@ -1101,6 +1102,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
> > >  PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
> > >  FOLIO_TYPE_OPS(large_kmalloc, large_kmalloc)
> > >
> > > +/*
> > > + * Marks page_pool allocated pages.
> > > + */
> > > +PAGE_TYPE_OPS(Netpp, netpp, netpp)
> > > +
> > >  /**
> > >   * PageHuge - Determine if the page belongs to hugetlbfs
> > >   * @page: The page to test.
> > > diff --git a/include/net/netmem.h b/include/net/netmem.h
> > > index f7dacc9e75fd..3667334e16e7 100644
> > > --- a/include/net/netmem.h
> > > +++ b/include/net/netmem.h
> > > @@ -298,7 +298,7 @@ static inline struct net_iov *__netmem_clear_lsb(=
netmem_ref netmem)
> > >   */
> > >  #define pp_page_to_nmdesc(p)                                        =
   \
> > >  ({                                                                  =
   \
> > > -       DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));            =
   \
> > > +       DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));                       =
   \
> > >         __pp_page_to_nmdesc(p);                                      =
   \
> > >  })
> > >
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 2ef3c07266b3..71c7666e48a9 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -898,7 +898,7 @@ static inline bool page_expected_state(struct pag=
e *page,
> > >  #ifdef CONFIG_MEMCG
> > >                         page->memcg_data |
> > >  #endif
> > > -                       page_pool_page_is_pp(page) |
> > > +                       PageNetpp(page) |
> > >                         (page->flags & check_flags)))
> > >                 return false;
> > >
> > > @@ -925,7 +925,7 @@ static const char *page_bad_reason(struct page *p=
age, unsigned long flags)
> > >         if (unlikely(page->memcg_data))
> > >                 bad_reason =3D "page still charged to cgroup";
> > >  #endif
> > > -       if (unlikely(page_pool_page_is_pp(page)))
> > > +       if (unlikely(PageNetpp(page)))
> > >                 bad_reason =3D "page_pool leak";
> > >         return bad_reason;
> > >  }
> > > diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
> > > index cd95394399b4..39a97703d9ed 100644
> > > --- a/net/core/netmem_priv.h
> > > +++ b/net/core/netmem_priv.h
> > > @@ -8,21 +8,11 @@ static inline unsigned long netmem_get_pp_magic(net=
mem_ref netmem)
> > >         return __netmem_clear_lsb(netmem)->pp_magic & ~PP_DMA_INDEX_M=
ASK;
> > >  }
> > >
> > > -static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned lo=
ng pp_magic)
> > > -{
> > > -       __netmem_clear_lsb(netmem)->pp_magic |=3D pp_magic;
> > > -}
> > > -
> > > -static inline void netmem_clear_pp_magic(netmem_ref netmem)
> > > -{
> > > -       WARN_ON_ONCE(__netmem_clear_lsb(netmem)->pp_magic & PP_DMA_IN=
DEX_MASK);
> > > -
> > > -       __netmem_clear_lsb(netmem)->pp_magic =3D 0;
> > > -}
> > > -
> > >  static inline bool netmem_is_pp(netmem_ref netmem)
> > >  {
> > > -       return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) =3D=3D P=
P_SIGNATURE;
> > > +       if (netmem_is_net_iov(netmem))
> > > +               return true;
> >
> > As Pavel alludes, this is dubious, and at least it's difficult to
> > reason about it.
> >
> > There could be net_iovs that are not attached to pp, and should not be
> > treated as pp memory. These are in the devmem (and future net_iov) tx
> > paths.
> >
> > We need a way to tell if a net_iov is pp or not. A couple of options:
> >
> > 1. We could have it such that if net_iov->pp is set, then the
> > netmem_is_pp =3D=3D true, otherwise false.
> > 2. We could implement a page-flags equivalent for net_iov.
> >
> > Option #1 is simpler and is my preferred. To do that properly, you need=
 to:
> >
> > 1. Make sure everywhere net_iovs are allocated that pp=3DNULL in the
> > non-pp case and pp=3Dnon NULL in the pp case. those callsites are
> > net_devmem_bind_dmabuf (devmem rx & tx path), io_zcrx_create_area
> > (io_uring rx path).
> >
> > 2. Change netmem_is_pp to check net_iov->pp in the net_iov case.
>
> Good idea, but I'm not sure if I could work on it without consuming your
> additional review efforts.  Can anyone add net_iov_is_pp() helper?
>

Things did indeed get busy for me with work work the past week and I
still need to look at your merged netmem desc series, but I'm happy to
review whenever I can.

> Or use the page type, Netpp, as an additional way to identify if it's a
> pp page for system memory, keeping the current way using ->pp_magic.
> So the page type, Netpp, is used for system memory, and ->pp_magic is
> used for net_iov.  The clean up for ->pp_magic can be done if needed.
>

IMO I would like to avoid deviations like this, especially since
->pp_magic is in the netmem_desc struct that is now shared between
page and net_iov. I'd rather both use pp_magic or both not, but that
may just be me.


--=20
Thanks,
Mina

