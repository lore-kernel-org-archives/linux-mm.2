Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA86CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 10:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6262D8E012E; Tue,  4 Nov 2025 05:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588918E0124; Tue,  4 Nov 2025 05:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477138E012E; Tue,  4 Nov 2025 05:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318D18E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:55:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0C5E87C3A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:55:49 +0000 (UTC)
X-FDA: 84072619218.01.95EB9B9
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10AD6180012
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:55:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="EvQKAE/G";
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762253748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYx65Ajs81HOm10wh2za1FtmkK5GGLky+6Z7TY2nQnw=;
	b=COpBdCGYgffvPvq4S7ZHdh86TBfjsgOq5BWw0oI4faj7Hae92NKUT4JRE96aQBDwJ1o9ZW
	VUPaiskbMJ7l5DWJmqdi6Bb5a0syancdUrli7tVVV5i/UX/pFDaqpl0XAgrwm5pYTSjBfU
	QKpCGCA8FGrV0gQg5z6WIiPuntOPKRA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762253748; a=rsa-sha256;
	cv=none;
	b=MTnsYDWHtnNM5aGQk8UzwrsIumcJJct+9lo7U14DsDEFshWNZaMpBWjuy334ulhgLIoE/C
	okVS6vRhUlctwRfVR3PTRMzSBmVX6nHkIvMVjSqER/udJCRaTWUHvEyMWt6GRw+zoIp3XG
	YYrf7lXAhOKHXhuCk4PPT3hlABCYp54=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="EvQKAE/G";
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so3992683a12.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 02:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762253746; x=1762858546; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sYx65Ajs81HOm10wh2za1FtmkK5GGLky+6Z7TY2nQnw=;
        b=EvQKAE/G5dcq5iOUHxn20444ETZCsFrIFAYwzhJZFOleRioFGr8clLrFX9ViehHlaC
         0SgJnl+jE5TwvCQlLtJqG3DFQznulKIOq4iRUaDoME0QbE7CkvFuzA51GzHxCOjaAWNs
         qd9H2Lq/a+fj6t8VFOm33HI3v6fRuhL8PHPollInLcfvvw0e9s8ubB/cuvZJAA255Oqv
         /4lzEqc3/9NfVZygo7KKvFAD7b9uEphBmHMOmcpvmUc/qjqEsX+42V8W+JwNNG61/ZFT
         Jy5wIqdh/161hb/kzX+ewMxkm2txXx/vCQWsq8vq1oJNRrxtu/eL9+jDnEPqDA7u+ojc
         YuhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762253746; x=1762858546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sYx65Ajs81HOm10wh2za1FtmkK5GGLky+6Z7TY2nQnw=;
        b=Pq5+bgVzX0pe4plFVWOwzhKPcUp07+9sDP0a3X8qH9eSbyzgFDEWKT9Ino5PbEZa1l
         PM/mI4AO72IIdeGGlS2bs/iCh2+J3aZqZqIJtBridS4IM0Ay+YLvaUHPcZ32+oKWtKkz
         LEx0uyuC4RcMV6hyD3E1jRo7TNAVDj4Tbiv7HdzWDtVwXG/2kphulSaJlCJrU/ojc9TY
         1XWZVd8Yiw2DtX7KojGaHb9lLFYkMZQQhhqpdoJgPCeenS/1BNuAxj3oO0MAGZ3dljxO
         hWg36UoUfGMrgYWN9T5n2XjysAzUa/tJR+5WEPziwXPDxeqactssqOhNfsXiewHg7vqL
         GO/g==
X-Gm-Message-State: AOJu0YxmKw40Y/HRkfh7hItQx2JfCs8siGTZFTGYsPgvERkHSY+Tx2Th
	E+WpNWFAtHoHoM6QAVjL7nlSnzUwEaD/XK2qk3swjXfTy+zzEn1QtXdcwK9QHzJOqSWT907gbKy
	1TKqdA5VHr9nS/fFtMHxpd/auJMH/2hY=
X-Gm-Gg: ASbGncsJehAPfXiAgoIHqKzxVPYpEhVhgtBOKgO1YJHuINMyFB8ZImu0A6wV2SJHkVE
	BDoMRUnFzIuN5SmHFdc2mezno4z7QnavLhVLIYUEfhPZTWJs8xMhryg9SVR9ZM6UKUcHLU8GgP+
	Byb7BgB57y11GhQOihhhazsa2mLQxuU/UK0CzMW/n24Mc28C5siMzFsGjt9YFMKyJjjgNRuG5nl
	7ZaasVJtD/cuNkNW/F6eqS8x6XIs+UKmGgDB+YTVxnb9Yr6/29jfii9+OrHmDO6
X-Google-Smtp-Source: AGHT+IHCPOnCh3IGY2Eq6cNtPlJHDt91gY7lJFsQg4HRVsucdlISL7TQnSu2L7dI1JasQLApmSCul7dtUqQElSLk/vg=
X-Received: by 2002:a17:906:3950:b0:b70:ac48:db8d with SMTP id
 a640c23a62f3a-b70ac48fb80mr718240366b.28.1762253746475; Tue, 04 Nov 2025
 02:55:46 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-4-3d43f3b6ec32@tencent.com> <CAGsJ_4xOd0CJLZvzvZu9mRLjVvV0OSKE8NcBAYe3wvHFtLjWyA@mail.gmail.com>
 <CAGsJ_4z9xTd=oHDuzLbdkyhd_F=tj2A3K_dsp33dXad6pvVZpA@mail.gmail.com>
In-Reply-To: <CAGsJ_4z9xTd=oHDuzLbdkyhd_F=tj2A3K_dsp33dXad6pvVZpA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Nov 2025 18:55:09 +0800
X-Gm-Features: AWmQ_bkhlu705Rg4epmhOhTM7qF-S9lFO_ydWRgeH2VOBr0FVTh1QNgdWHU5P3Y
Message-ID: <CAMgjq7DJMtN9_r9L5jatZN8_0GS=pKYLPcArd=ie4rBSwHWXGw@mail.gmail.com>
Subject: Re: [PATCH 04/19] mm, swap: always try to free swap cache for
 SWP_SYNCHRONOUS_IO devices
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 10AD6180012
X-Stat-Signature: py6rizpufu9ozzied38pxzaqodgnt4h4
X-HE-Tag: 1762253747-33636
X-HE-Meta: U2FsdGVkX1+HLKVmrbVxF6+4KVAQb1wO51NzCnborBd3bPKmXiNa3mpBqT1en5Fks62nz3RLGZPu5ESAS49QBYVfddwfM2FTWNxhuJ3XTbcz3EzrC0b7/+7pChF/tHpERNurW9d3HN71Etj3jtLK07G6MB5Tk3CDCuGCI/D3qnAoeCkP1CfguBKtg6PfcEyY0FZxOul8JT6Qtz9l5GbBOQq/oruQGHIBS5zShlDLr7ao0GZe/cNIJwVyP02fhAkq0SCDDuIz4cDUs+m9oltvbntobCprEMCfm9cHs+ocMpoZbGyxIjj8HHKyYm2K4qK0HIKEY3VFookLDtiaEf56NoVgA56sPTRC5ygn9tdzw+PWT2ScT2WRHpOG4R8mzm+yY5ZXTrPzNDb890omObExgUXnvwqPB2VaXj7r8BzF0VLdwga4x2qkJ8rJ7BImP3U+XPZKFhe62E+W0CTgJ4/r2Tun6ZFockSqszeTJFbC0doLbmOHqclpWejDU7h79oc0cF6ZsyPodeEt7w7XHxiQBjthK2M+9S/CrAItod3g2ygHvihZ/ILwELFs1plr5ZpzyAd/FFydqxW736ra9Dqxd0Cp6AEl3cqW4uxaizkKMB13brd7d6VUF0nxq+NOgBS96FQzPQwJ+4VHdFjfLVDMoPRPdSm7/4sCf0VpA5Xge1HdT787ZYtwuiwr2jcbFMw60Uba88nssHNX9MU4IjDgg5B7pcyx4sxh0yNIHmcneaDwC6qXsvhoBMdHu6CTmnq9KoyjVZrXB+qMy36rFIybftu4pnX/P1s9pTsEgythkn/gTCfsCyiK2gU+VQrFl/pazZ0SDoCzN0r1ZT3XlsCTaJvoBO/z3ACZ+1QtSuLuGgePfVhTpc0Pvft/14H9Ma6/yruMwRdZfKBekkPcZ4cyF1MtaR9daVxRhiYtx8cgaXKRPz6jmiT8KV6ILehAOSFCSj2ydBsl5u8mQl1JumC
 mItfYrT4
 rXCUyf2ZPIV7Lpcs94nXTE+nxUBPUbEjg7tYywn4qw1mOq49DheyhL+ybpUSiyXeRXTG/yWf72DjmYk0V7F4D4TjNRj2PAlmcCPQahNhpFieikFe/yf5WqAiCZpzSjm0lQTx8iO9xescjrFOH+IbKLPJGXrKpNaFUCJX54OpPfjEM4W9SXE/noZba8aWw7qAEx+FNW1+8/Suj4kCvzNttptc8znXzUTevMbtCp+pNDqzgdtDmrfUwP5WhmzAROc7U46ExbXAaDwtTtHcin9NlHUEiVvb2dm/Mg3JTtHIgLUrTLoR8GfizQbtRqDKEfsSaJ3hvYoGx88upsDcBCO71aD6K3rcXb+b+qE+ztzk+cuUVGgLncuAyOpS7RijomkAGzUcetbnAsP/xTkwnroP+hqhytgxZeeNtI/1LlsVn+A/JP6Z+mKWHC1n7Cub+Ol2R4r4JzHAUhiQ5SBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 4:27=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Tue, Nov 4, 2025 at 12:19=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Wed, Oct 29, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Now SWP_SYNCHRONOUS_IO devices are also using swap cache. One side
> > > effect is that a folio may stay in swap cache for a longer time due t=
o
> > > lazy freeing (vm_swap_full()). This can help save some CPU / IO if fo=
lios
> > > are being swapped out very frequently right after swapin, hence impro=
ving
> > > the performance. But the long pinning of swap slots also increases th=
e
> > > fragmentation rate of the swap device significantly, and currently,
> > > all in-tree SWP_SYNCHRONOUS_IO devices are RAM disks, so it also
> > > causes the backing memory to be pinned, increasing the memory pressur=
e.
> > >
> > > So drop the swap cache immediately for SWP_SYNCHRONOUS_IO devices
> > > after swapin finishes. Swap cache has served its role as a
> > > synchronization layer to prevent any parallel swapin from wasting
> > > CPU or memory allocation, and the redundant IO is not a major concern
> > > for SWP_SYNCHRONOUS_IO devices.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  mm/memory.c | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 9a43d4811781..78457347ae60 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4359,12 +4359,21 @@ static vm_fault_t remove_device_exclusive_ent=
ry(struct vm_fault *vmf)
> > >         return 0;
> > >  }
> > >
> > > -static inline bool should_try_to_free_swap(struct folio *folio,
> > > +static inline bool should_try_to_free_swap(struct swap_info_struct *=
si,
> > > +                                          struct folio *folio,
> > >                                            struct vm_area_struct *vma=
,
> > >                                            unsigned int fault_flags)
> > >  {
> > >         if (!folio_test_swapcache(folio))
> > >                 return false;
> > > +       /*
> > > +        * Try to free swap cache for SWP_SYNCHRONOUS_IO devices.
> > > +        * Redundant IO is unlikely to be an issue for them, but a
> > > +        * slot being pinned by swap cache may cause more fragmentati=
on
> > > +        * and delayed freeing of swap metadata.
> > > +        */
> >
> > I don=E2=80=99t like the claim about =E2=80=9Credundant I/O=E2=80=9D =
=E2=80=94 it sounds misleading. Those
> > I/Os are not redundant; they are simply saved by swapcache, which preve=
nts
> > some swap-out I/O when a recently swap-in folio is swapped out again.
> >
> > So, could we make it a bit more specific in both the comment and the co=
mmit
> > message?
>
> Sorry, on second thought=E2=80=94consider a case where process A mmaps 10=
0 MB and writes
> to it to populate memory, then forks process B. If that 100 MB gets swapp=
ed out,
> and A and B later swap it in separately for reading, with this change it =
seems
> they would each get their own 100 MB copy (total 2 =C3=97 100 MB), wherea=
s previously
> they could share the same 100 MB?

It's a bit tricky here, folio_free_swap only frees the swap cache if a
folio's swap count is 0, so if A swapin these folios first, the swap
cache won't be freed until B also mapped these folios and reduced the
swap count.

And this function is called should_try_to_free_swap: it's only trying
to free the swap cache if swap count =3D=3D 0. I think I can add some
comments on that.

