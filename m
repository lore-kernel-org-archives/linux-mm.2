Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EF2FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 18:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC766B0088; Sun,  3 May 2026 14:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ADA06B008A; Sun,  3 May 2026 14:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377236B008C; Sun,  3 May 2026 14:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26AE46B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:12:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2F1B1C14A8
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:12:23 +0000 (UTC)
X-FDA: 84726903366.01.E1BF7A4
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA6FC1C0003
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:12:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HjUShKpo;
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777831941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TuHk6gntEIJV0GgLUK1hPsy76HnphKiXZnnnJVyWRVI=;
	b=kEKYcJwHNlerxHaOiiOC1fqnYX6pKS8nv4Yggvw/ko/XguJphInR8GeVmQu0O8y18MaMVf
	xht//ajB5IBmSicH3Liwo2M+6ao4KxDQVIVP/d2a+QfVz9OY1qKDEgotSi/7trIMEYhka4
	iAUn6EPLJedEppc2EGO9UYBjmNHXO/U=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HjUShKpo;
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777831941; a=rsa-sha256;
	cv=pass;
	b=V4xp4oboF4c7NNhGaA0Qe0z7UlorXpFJeS9qjzB+x5jZA+uEbg/Nt5O6HYXw95FLHi1Wwq
	JKM3Lya0+NDgj3ZUv3kWfNd2bDeenCuzido0iNDtmcmmuh20ea9ifGEZxa3f+CESj/bOl0
	58ua3SpYxQGsV0DIobD1NG89CD4ihtc=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40f1a1f77a6so2778513fac.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 11:12:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777831940; cv=none;
        d=google.com; s=arc-20240605;
        b=kfcTvakgagjFou9df2qs7HJbtJvUlTj85kj6II2t4/s5qAbst5wPAUpV+vMQIbNyQN
         gampFjQagNtM9SM7J3CVyslZmH2ywyKJjKmpO0QqULLDbmo6AeqF3KOlWrHKjvIFASkN
         B+lYaHGvMr3VslSqV4daIPNAQcxlaAQvqC/kGT8tEWAfM5ZgK6hBi4QF9GpAonW/Hm4C
         pfafDL1jbrxUMVU7zl8zLMy2d+B7sGRp663Pn6hR9msKMPFWVSwrYaI75tqRMz4v/nj4
         5T1CkuSo/RktuM47uO15Vh0Xmd8Qhdu+RF5n85coUqhkR84TFl/RiwquzGv2Kqyok5Js
         /L/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TuHk6gntEIJV0GgLUK1hPsy76HnphKiXZnnnJVyWRVI=;
        fh=cB3vsCXnDPSnvYSQDnMcUAvlkNKVbmaNcBKNtlRuRdc=;
        b=NBKIBRvs65iDFmjCuM6FH05n4fZTD0tLodHoL1WaVEZ9xCmnXka7PoJV/7fSqDADT6
         WzQmaujUmAKKdXMoeWZo+j3QB6//N0qdcauG9QB/h4/iklN3PQsNZf40T5C+Fl8Xe6ql
         DCb/Pk7nTcNiJjjo9lF+HmjwqYRjACtHjriAKe/Q/+2cv0Fy7eXEUKvHqp0f7Ju1vN0X
         SgzNQuW/TKYk1L36dqlu0YWadPLdoOSCbapRQteQlWWM98B84/csvhgttW9JrOfEuZN7
         9gNpSD5Wl8Wk1U2AZmU0m1Mkl0TodQL4orY1uNBwRpyejR4KnVRyRbwNiU8sp0YITW/k
         lZCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777831940; x=1778436740; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TuHk6gntEIJV0GgLUK1hPsy76HnphKiXZnnnJVyWRVI=;
        b=HjUShKpokf7QGCXbFMOcD8/3loB5GJ17hvchQa/WODa3lnUno5OZvErIl37LEksCO9
         bmDZbGz0p9Oc4xIxDixwfhJqbpGWufj3p/ksDzDd4edH/j8kV3dPqw5NZccta4zwD2we
         1qVchRzfqn1/7nHL4aIzBwvSt1iAGoCNKpPhcmbcm5I7YfLZTlh78lnfAqx3J8BtMLDN
         kFhgcaZ5rOvGneBXb1CXpc2oslHS3mtBUkINZk5eewEVxoLsVcAsUo/ROcp/S+CaGYcn
         BBeFKcK1bIEiAewRdvpFEdKM/Zb/tgWxryKhMYD+7z2auXukfskQQ6EuVh3tJ7ETLL4/
         qlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777831940; x=1778436740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TuHk6gntEIJV0GgLUK1hPsy76HnphKiXZnnnJVyWRVI=;
        b=YZAM2jHALC6vCGR4Tr8lAqqG7NiHNu6Xdl9hAg/qAtgud/rRJ9i41Vz5TNKpTTRKRl
         1kzzvxAawaYL8AeLqrkMrsQc5UxdvRr51fagHV8KB+OcBLXUkekT2TKzivt8sIWkeHWB
         jxzDf4rf0vMSma/CV8+DETuu1Y5Ztg+B1/StgVE273JHh4MtxJ0cf0318KcY05C1/P8V
         miI/DAA6g0pXSjF1lJxMbT72BrzKCzBkri8D3gHCvlivrYGNpreitPbN8cCoeqQI/UyY
         T0hTUOB9tRydC3YaoG/cjAVpqeGAOu1ir6TPDhyZ8sku35hChegYG4m//m2SD7Q0IsuO
         coWw==
X-Forwarded-Encrypted: i=1; AFNElJ+VOnFK4rNQDlNAUjJNei5DSsyItg6DudXHtAnYbxfhcmBD0YMdyh2ZwMN4ht78P7TvNRgNeQFE9w==@kvack.org
X-Gm-Message-State: AOJu0YyffRnaZWVGoUTE+M7xMiENz4CGXXy0kvDyocoANeAWIOzA6v+/
	zydHY+Hapsn0cR6sUXqciYCpGuYT7t6BEWWKgqqTOB+quZYnr9fikdH2ONyrF4Fiyr36EAtC0PW
	ChBLDuSc7RaE5f3id0j6fikPzB67C9cE=
X-Gm-Gg: AeBDieuY7c3YT3dnywqDhZHazGVbvfv/EEL53TvSSsWYMP1WfTBWNfo6np86JUZOW75
	VrpTw2uYPC2ow37stRZLfXGsGqD+/GlarhGnki8U2WFQ3mGSuSssYPNRXwiBTWaMKrpdIRbeVau
	+qeOJKFaBz+6sANdjp3DJFy3iiYXawSvkEqpauALQD+8EovOeOZSKYJCsR9Rw1vpogT0Pc3sm94
	HiuiZQrNVPzP8UvQrMd7pb1l1poN0h4ZWoPPueHMIND05sjKidFMNFf5K+KN8qX2g+bF2zSQmZ/
	T7PBhrjGmPmF3R7LdeC0CcYVK2xTiYK3ta1+yEtoVZ/jTHA1
X-Received: by 2002:a05:6870:1b09:b0:42f:b782:104a with SMTP id
 586e51a60fabf-4347622a4aemr3405023fac.21.1777831940496; Sun, 03 May 2026
 11:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260430195651.287659-1-devnexen@gmail.com> <afUih+XwGTHsR0HY@yjaykim-PowerEdge-T330>
 <CAMrLSE71rs1TyoFwCjChY4bEMX-qz01_QKdkAUQmZOSrMMEzbg@mail.gmail.com>
In-Reply-To: <CAMrLSE71rs1TyoFwCjChY4bEMX-qz01_QKdkAUQmZOSrMMEzbg@mail.gmail.com>
From: David CARLIER <devnexen@gmail.com>
Date: Sun, 3 May 2026 19:12:06 +0100
X-Gm-Features: AVHnY4Kd5l8lopbbU-EGH9NBZKTL3CyVlD7bO4ZsqqXXa_d7sbYSemBz6lTn6Ns
Message-ID: <CA+XhMqys0rbcJd8ddAMRmUPi=6byXYA0MD5oahgdvPU4PTSFTA@mail.gmail.com>
Subject: Re: [PATCH] mm/swap, PM: hibernate: atomically replace hibernation pin
To: CharSyam <charsyam@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA6FC1C0003
X-Stat-Signature: wg7k58htpgpy5to1stp9k7h67sjjui8n
X-HE-Tag: 1777831941-643786
X-HE-Meta: U2FsdGVkX197HwUg4hCSo92oYHXmAtbeaVBtAUJpe3tskNuD3oA/BWgcfWJjyJyDrLth5ntW84Q8WSahjxQb1Z528AirnA+Xu3rCaKXGibxL39qp1fcPGyFvMGTUKIAFEZH0cWKaNiqku/aypmAATrx3SbAPud2uO1ndCWzSAvICNXvbDjUztlNBPCzXpjilTAvfbCBWniSCRR81/V8n2eEaPzZPV8K7Wohp0/HRFuUG8ul6Naqoj/Jrd9730F/QdubHDpBxnSKSaTmPKb81t3QgUq7tafx5V1crvwRmDI1CX4IxBz4ut+sxGfdHgo2sUk8tGR1K4OPyRO6dtawz7wFt2Qyx8gmOiad+mqcwI4F9rdbsG9cIRa2//HkBSNGKuSbT00QHMUGPbTVju7ShZ6Nxl1FGkZdKmvvyFOojzecWinkGW7zEI7j2Y9UpbAV2SHUR5D+/xOGNcWNBDnq+gLiFlm8N2AV9AcapajBwYuMZ/PHAnp/edM3hfbaRdSNnF/JQUuX9Dn9kdu7CjiyTHKDI4Ro+z64LJyCQ4ESMFx7rxf8Hh58tg2JoKLG0qSVN5VBBV5Nko/8Z+BCMDRJj1SkLWEG17F/HLRW+KmJOZXFSM6z2g0s7MIz3OW6/RcZDeVJNLB6Ogn2OoXvhNbRpU7NGRZIjMf815vTJhJn44qNtke21FKk5He6gKfSBfro6jgRxWD83kaQgjxUWWYrxzUgu3nN0DOnzDSAvxhv25/T/4wcnu8PwlNFRzaxAdjN1CT4+p49imNZL2y0QRkdSa1jCfRULMhk7s6hig3/bNiiAp87HpuGUbr06iXDse+zvpaBzhZYL7CCyrEPXjveMW3uFItWyQFm5CDTf0Qo5UMTUwfG6zHb+gu3mwQBhV+81kscVz44fzP4TqBzyNUnuy0Yht62cwuCykfDStlzkjPrKpO4TIehy+FKKd7/S6qNM3zDqginFgLufWBImPVw
 FZE24xZD
 mPHSa1xi2qWjeA6TBrhkoQQOj4Xn4cWDHsHSQLTWYuN32WpXUHN4ldlquBy5FwBLW+dUP0b15sbKZA2vBvLiB6fCU57ad2arT+04HAebPdVVF43fOi8S1mZeqs7iVfTUGwrhhTOWEg6KGbTlbMW1+ls6piQUECbF9ziRBRcMjEWRKtUzlEiGYVE0tjf4IevunRiHe1K+0SuiTFwdgM7i2gAvkbA3ddFMp9zklJ7o7Qti9PUHl9fGIFR2rx9CsNeVtPNz9AjK26LLD3PAKdU1cA+adRuO+86uZ0pj1QhvSDSjSIJy42yVWtPK50u6+npTj5/nD7QOeMetfrcTfkl0vKkWRxW+3TiHwvkyzYNS7VZ3+hjYrm7STKseOreGpkdQs+QHhoCqWbLRxMAv6thtUsKypK9CdtQ7koAC+IQRLaGb2sh+SEZPTigfcpuV7PkRQijC6Lu3oiHjls9nfmGGtSNZsDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi CharSyam it is literally the same code, I did not look in existing
propositions when running the AI agent ... Sorry !

Kind regards.

On Sun, 3 May 2026 at 18:24, CharSyam <charsyam@gmail.com> wrote:
>
> Hi David, Youngjun,
>
> Thanks for the discussion.
>
> This is essentially the same direction as my v1, where I introduced a
> repin-style helper to transfer the SWP_HIBERNATION pin under a single
> swap_lock critical section.
>
> After Youngjun's review, I reworked it in v2 to avoid adding a new
> single-call-site helper and instead reused the existing
> find/pin/unpin helpers. The current v2 approach keeps the existing
> pin on failure and avoids introducing a new API.
>
> Given that this is more of a hardening improvement than a strict bug
> fix, I think the v2 approach is a simpler fit without adding extra API
> surface.
>
> Happy to adjust if there are specific concerns.
>
> Thanks,
> DaeMyung
>
>
> 2026=EB=85=84 5=EC=9B=94 2=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 7:00, =
YoungJun Park <youngjun.park@lge.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >
> > On Thu, Apr 30, 2026 at 08:56:51PM +0100, David Carlier wrote:
> > > snapshot_set_swap_area() unpins the previously selected swap device
> > > and pins the new one in two separate swap_lock critical sections.
> > > In the gap between them, swapoff() observes SWP_HIBERNATION cleared,
> > > bypasses the guard, and tears down the device, reopening the race
> > > the SWP_HIBERNATION pin was meant to close. The window is reachable
> > > on any SNAPSHOT_SET_SWAP_AREA call after the snapshot device is
> > > opened for hibernation, and on any retry after the resume path's
> > > first selection.
> > >
> > > Add repin_hibernation_swap_type(), which looks up the new device,
> > > clears the old SWP_HIBERNATION flag and sets the new one under a
> > > single swap_lock acquisition. The same-device case is short-
> > > circuited so userspace can re-select the same swap area without
> > > tripping WARN_ON_ONCE and -EBUSY. Switch snapshot_set_swap_area()
> > > to the new helper.
> > >
> > > A failed lookup now preserves the previous pin instead of dropping
> > > it, so a bad SNAPSHOT_SET_SWAP_AREA leaves the prior selection
> > > intact. The open and release paths keep using
> > > pin_hibernation_swap_type() and unpin_hibernation_swap_type().
> > >
> > > The race was identified during AI-assisted review of the
> > > SWP_HIBERNATION pinning series.
> > >
> > > Fixes: 8e6e0d845823 ("mm/swap, PM: hibernate: fix swapoff race in usw=
susp by pinning swap device")
> > > Assisted-by: Codex (gpt-5-codex)
> > > Signed-off-by: David Carlier <devnexen@gmail.com>
> > > ---
> > >  include/linux/swap.h |  2 ++
> > >  kernel/power/user.c  | 17 ++++--------
> > >  mm/swapfile.c        | 61 ++++++++++++++++++++++++++++++++++++++++++=
++
> > >  3 files changed, 68 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > > index 1930f81e6be4..213ecb627a39 100644
> > > --- a/include/linux/swap.h
> > > +++ b/include/linux/swap.h
> > > @@ -436,6 +436,8 @@ static inline long get_nr_swap_pages(void)
> > >  extern void si_swapinfo(struct sysinfo *);
> > >  extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
> > >  extern void unpin_hibernation_swap_type(int type);
> > > +extern int repin_hibernation_swap_type(int old_type, dev_t device,
> > > +                                       sector_t offset);
> > >  extern int find_hibernation_swap_type(dev_t device, sector_t offset)=
;
> > >  int find_first_swap(dev_t *device);
> > >  extern unsigned int count_swap_pages(int, int);
> > > diff --git a/kernel/power/user.c b/kernel/power/user.c
> > > index d0fcfba7ac23..6e4f40e49319 100644
> > > --- a/kernel/power/user.c
> > > +++ b/kernel/power/user.c
> > > @@ -218,6 +218,7 @@ static int snapshot_set_swap_area(struct snapshot=
_data *data,
> > >  {
> > >       sector_t offset;
> > >       dev_t swdev;
> > > +     int new_type;
> > >
> > >       if (swsusp_swap_in_use())
> > >               return -EPERM;
> > > @@ -238,19 +239,11 @@ static int snapshot_set_swap_area(struct snapsh=
ot_data *data,
> > >               offset =3D swap_area.offset;
> > >       }
> > >
> > > -     /*
> > > -      * Unpin the swap device if a swap area was already
> > > -      * set by SNAPSHOT_SET_SWAP_AREA.
> > > -      */
> > > -     unpin_hibernation_swap_type(data->swap);
> > > +     new_type =3D repin_hibernation_swap_type(data->swap, swdev, off=
set);
> > > +     if (new_type < 0)
> > > +             return new_type;
> > >
> > > -     /*
> > > -      * User space encodes device types as two-byte values,
> > > -      * so we need to recode them
> > > -      */
> > > -     data->swap =3D pin_hibernation_swap_type(swdev, offset);
> > > -     if (data->swap < 0)
> > > -             return swdev ? -ENODEV : -EINVAL;
> > > +     data->swap =3D new_type;
> > >       data->dev =3D swdev;
> > >       return 0;
> > >  }
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index c7e173b93e11..4840fd40f36f 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -2219,6 +2219,67 @@ int pin_hibernation_swap_type(dev_t device, se=
ctor_t offset)
> > >       return type;
> > >  }
> > >
> > > +/**
> > > + * repin_hibernation_swap_type - Atomically replace the hibernation =
pin
> > > + * @old_type: Swap type currently pinned (or < 0 if none).
> > > + * @device:   Block device of the new resume image.
> > > + * @offset:   Offset identifying the new swap area.
> > > + *
> > > + * Look up the swap device for @device/@offset and atomically transf=
er
> > > + * the SWP_HIBERNATION pin from @old_type (if valid) to the new devi=
ce,
> > > + * all under a single swap_lock critical section. This closes the
> > > + * swapoff() window that exists when callers unpin and re-pin in two
> > > + * separate operations.
> > > + *
> > > + * If the new device cannot be located, the existing pin on @old_typ=
e
> > > + * is preserved and an error is returned. If @old_type already refer=
s
> > > + * to the same swap_info_struct as the new lookup, no flag changes a=
re
> > > + * made and @old_type is returned.
> > > + *
> > > + * Return:
> > > + * >=3D 0 on success (new swap type).
> > > + * -EINVAL if @device is invalid.
> > > + * -ENODEV if the swap device is not found.
> > > + * -EBUSY  if the new device is already pinned by another context.
> > > + */
> > > +int repin_hibernation_swap_type(int old_type, dev_t device, sector_t=
 offset)
> > > +{
> > > +     struct swap_info_struct *old_si, *new_si;
> > > +     int new_type;
> > > +
> > > +     spin_lock(&swap_lock);
> > > +
> > > +     new_type =3D __find_hibernation_swap_type(device, offset);
> > > +     if (new_type < 0) {
> > > +             spin_unlock(&swap_lock);
> > > +             return new_type;
> > > +     }
> > > +
> > > +     new_si =3D swap_type_to_info(new_type);
> > > +     if (WARN_ON_ONCE(!new_si)) {
> > > +             spin_unlock(&swap_lock);
> > > +             return -ENODEV;
> > > +     }
> > > +
> > > +     old_si =3D swap_type_to_info(old_type);
> > > +     if (new_si =3D=3D old_si) {
> > > +             spin_unlock(&swap_lock);
> > > +             return new_type;
> > > +     }
> > > +
> > > +     if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
> > > +             spin_unlock(&swap_lock);
> > > +             return -EBUSY;
> > > +     }
> > > +
> > > +     if (old_si)
> > > +             old_si->flags &=3D ~SWP_HIBERNATION;
> > > +     new_si->flags |=3D SWP_HIBERNATION;
> > > +
> > > +     spin_unlock(&swap_lock);
> > > +     return new_type;
> > > +}
> > > +
> > >  /**
> > >   * unpin_hibernation_swap_type - Unpin the swap device for hibernati=
on
> > >   * @type: Swap type previously returned by pin_hibernation_swap_type=
()
> > > --
> > > 2.53.0
> >
> > I also caught up on this thread late due to travel.
> > Sorry.
> >
> > Hello David Carlier,
> >
> > It looks like the same issue and approach was raised previously:
> > https://lore.kernel.org/all/20260414143200.1267932-1-charsyam@gmail.com=
/#t
> > (+CC DaeMyung)
> >
> > I had suggested improving the fix by reusing the existing APIs
> > rather than adding a new one. v2 was posted along those lines:
> > https://lore.kernel.org/all/20260414164937.1363887-1-charsyam@gmail.com=
/
> >
> > To restate the points from that earlier review.
> >
> > 1. I think it is acceptable to release the existing pin when the
> >    new set operation fails. there is no significant side effect
> >    (see the earlier review for details).
> >
> > 2. If we still want to fix it, reusing the existing APIs seems
> >    preferable to adding a new one.
> >
> > Chris, Andrew - please take the prior thread into account during review=
.
> >
> > Thanks,
> > Youngjun Park
> >

