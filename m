Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A11CCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 15:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7B36B0005; Thu,  7 May 2026 11:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EBB6B008A; Thu,  7 May 2026 11:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5266B008C; Thu,  7 May 2026 11:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC1BC6B0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:20:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF09E1C0446
	for <linux-mm@kvack.org>; Thu,  7 May 2026 15:20:01 +0000 (UTC)
X-FDA: 84740984202.11.4F67A00
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id A16CF80015
	for <linux-mm@kvack.org>; Thu,  7 May 2026 15:19:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZWAU5128;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778167199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvZ4FuEr6FesLFXFPQKMY7rVCvVG3A7RqmeTMe4SIiQ=;
	b=k4gBxqcjlxsOSRIPoWaeOuV9KI00X58Xq/BgYHMtQlZAi708BIn00ywmHg0wWc8Ckhkmk8
	BfRc0txnssxYWij0/ZIraQrgXk+J6nh6rx+AEmmm57jRnuWAkEYFlN6GW6cpfCjaeXGN4B
	IrrGBEjGMR9juvknNVXUsekPueh6qhs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778167199; a=rsa-sha256;
	cv=pass;
	b=IxUzcLH2dcxauRiRrwGo27pUm5qX+YpuoID7vUN05gvSB5BCPZ4yIaw2s3uHq0YeE22K2+
	wRsUtBw677M3JXNKAtIN4SA1gvf0bZfYWof59AVcnLv4xo1byZ1pM4ckszepj/ndqxHmY+
	Db3ds3XBADp+Ot2yvBovgVhfMMuom84=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZWAU5128;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-393c40246afso10128571fa.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 08:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778167198; cv=none;
        d=google.com; s=arc-20240605;
        b=iwPyQ3A//DM0jJ621bpFaEWBSwdRiQEWehwTRjIiSaKHlAgJamtcf/D2Spm7XEQGGW
         uol3R2u7mQHSV888QaeNnd64+jKblL/eYIHr1JspJ+1e34Iub6e6AElc8TEuhDUs6Cwk
         OIJ54rMJJGkkIgpScUDgWcowF60/MALCgacswuuUWErsbjvAT5sb9giRNx2n4AJ0LsVv
         Me7/zDgumcPsuJuW1kJ4ludTykGXIzdWVXcqsIQUdoeyrFnEWw9oR7ekZEhoMPsL3aKk
         ORiepckmg1rqkEN53gJmKs8Emeo3lOOCAqVikKMfSnPc59NeX/SCoroIFaY5TFuq6zia
         0k3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xvZ4FuEr6FesLFXFPQKMY7rVCvVG3A7RqmeTMe4SIiQ=;
        fh=tmMHLEistSFIc5r0DTj6DT7gzraKGM1qFI2MyGCz/0U=;
        b=Mq6v3ZF8ttnHpsZ5KoBycLGwi94UARzm3qeCaHozYKU1teHctiDlAU9xS39MmC9QLe
         hZgnLpYLhoov4O09GPiRw7s5dmnGczbkY/MhvffQgAC1qB4o3eNJgkALDz1ZXqLQ/PeY
         edU7ySXe/vLA1sBMPIe4CdbQjf+9U9CeGB+3iT/Hj4qxXp+vYFxoeqXAFSK4WuLb0u/u
         xVS3NMZvT5Ex01dRMvY4g9tA9iMwb8WKoNECkPbkIHW95TGHUVDHB8zWwtnb8Bc1mxt2
         7XZsK979wwmyxcbTvSeQidwD1qCmladizH8yb3A592B2p4b5cclHv0xQbvFTRfp1qnL6
         RA/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778167198; x=1778771998; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvZ4FuEr6FesLFXFPQKMY7rVCvVG3A7RqmeTMe4SIiQ=;
        b=ZWAU512857DTL+qV9c9yzUuksqBh6W8W0XI1WZcTnhJgO2sdzJI9AiAXdHupdVqQGD
         XbtvQG18zN356nlIbZW4gaEdonAda8ysxDklE2Dlc/G24Baf55bfJsbSiGWoc09pXvLS
         f/t6B26iIS7c93vKORrAp7Zrg6fVOHz8wh0ygPPZ/dt7eHg62ZmhDeN84aTd6zOyZXyq
         dGzqiMNNf0jzqdQGbgql/f3+ImKd0Rt5RzWePWhid49+wbkAoxfuRC92OW+Nc7Xf5elN
         HdxPOOFP6/hV43lnr+VmOBnRbibfDtaLlnfck1SbBoVbpBSVO5fNd7kvSeIC2WU/3Ytn
         nofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778167198; x=1778771998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xvZ4FuEr6FesLFXFPQKMY7rVCvVG3A7RqmeTMe4SIiQ=;
        b=YNaVZJoyVIXKdzXnsPsyu1up8NTTLLrhHs4KbIzT81l1ZyIpc4ZNfKsdQeGxfHZPt+
         WzdSag5mfFOW10ytnGL60MjTWx/RyMsaLp+25rnXL+zXfIGmZ5yqCg4jv0EPONX3+W2j
         WoioOp+6TtrEiaqB1TB2wBd7cc/FFSgQwwa8UX4okwHPoxUdJ0zXRSpYHaZ6YFJ+tevW
         Lh17uw09b/+6Lt4tEXv8JDdEqoQGXFJLH0+dHnI9+9vf8W+5jlkkDi+EUPfw0eypLiks
         HNc/CfY5eQg3WrQ6JWERUWa2yx/yoy0q8NSC5PZbmxm5zJNGsz4400R0TACRi7mOc9Ym
         F5uA==
X-Forwarded-Encrypted: i=1; AFNElJ+AXfF9Co9nvtwQtJwuBTsAYMI/jsSWiCvwwiTd68wA2lIW+7ox4cTg2MJt34qifgndn3v9xeqVxw==@kvack.org
X-Gm-Message-State: AOJu0Ywpgf7QcaFjS9D8ykE+CqOvxDr2uthjmm6GcC4fsHFpGi1mzTFk
	m+n1ZDR+Q5CR8xtDg/tAkv7jxH3ChwRMaZak05m6485iLgXDeBe1PTGGPy1j24IzzgzuZKBI0Je
	0YvLN6g7a9HjREd0crtqaIFNRRAjSZJ8=
X-Gm-Gg: AeBDiet57z06qrvXiPKVvOvy6JIcbwB0PBvm3h5iL6RY/lTkp7JdfFjDZYPShKw20JN
	GxdtOM91yHlRRP63d9rr6OCUCKzqPBS5yWp2fqwT1BVSUGHF1PlQSfH1nCVD5bdGZ6gAl2vUofb
	/FtwYKBs5ytfOyf5kMox7AKZiV1zw4IbwDBn2FYADQBVdkDv0NhHR5qUdElCK+PYloWUnH7jBG4
	sPmuiSwVgE/KeCXualFREUJkgXk+IEVoinI7tGqnKJqOpypmyJ02C81OnArcFPK015dpriUmf0p
	TNTVKhdoHgzkpa0I2MS3BLs7UsE=
X-Received: by 2002:a05:651c:35c6:b0:38a:6537:6f51 with SMTP id
 38308e7fff4ca-393c40a513fmr36502871fa.5.1778167197354; Thu, 07 May 2026
 08:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-1-vernon2gm@gmail.com> <CALOAHbBx6GuZjj9_EdrAPCsiLJekAiqOVsWQ0muNJh18Nxaqtg@mail.gmail.com>
 <CACZaFFPXo_f_2M7y4NfQ=sWddS4Kwo5guFTqZcLmm4Z8COWocQ@mail.gmail.com> <CALOAHbDQyUARbWudg3e94p7QyUF3Jgi3Y+NgPiSjfw=euENsjg@mail.gmail.com>
In-Reply-To: <CALOAHbDQyUARbWudg3e94p7QyUF3Jgi3Y+NgPiSjfw=euENsjg@mail.gmail.com>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 7 May 2026 23:19:45 +0800
X-Gm-Features: AVHnY4KHF6zAOGVDKs5Hct5iRRfpwWPlE8f88WUSoHr5Q9e_GpVW0c3a6W-w61w
Message-ID: <CACZaFFMS0KcmBbEMc-ZC9C9VHaQtZbcGpujhfmKR4Yx=eGsFWg@mail.gmail.com>
Subject: Re: [PATCH 0/4] mm: introduce mthp_ext via cgroup-bpf to make mTHP
 more transparent
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	ast@kernel.org, daniel@iogearbox.net, surenb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	baohua@kernel.org, lance.yang@linux.dev, dev.jain@arm.com, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A16CF80015
X-Stat-Signature: bebmjc5zankrkq79hw6xmy7s9bgiwaof
X-Rspam-User: 
X-HE-Tag: 1778167199-110456
X-HE-Meta: U2FsdGVkX1/m1c/py97iYJK2Md8bxH46LKG0hObKTomnASdjaN63Xi68uZCIyFBWXVO1Oku/0NyzxX5BAElvM2OVKb9pVWuzsZjRrMUBnkhu+GsJMVlef3SN+58870DI9akA1Qk5w6CgmFiOd4pSSOF+yOmqL2BkioGqqf2N7OpWI9Hy1Ns/vuF9p6xNriTA7LX55gFbKPSHFrPiy8b6YSLc6Qo+F3gtDhJGMSd/Cedkw0sy78F8hmKoiiB7wj3PXaQpbckKs8Y9YZmyy62iWXbdBv2rcVBOlr+l42aO3feHfgYK1M8yc9RDMyOYT8b149xiPqyiKjo902GndZ4/RW5PzObaycftzZQYyftm2FSRJ09glIM5bA8SrZ77MAzm9towpz4he/PBdDofgCpCvAup7yqqzicMsK/VPEuWKGrHVM/tgkNUrRh5MjDX1/PjymT9D0h+dwDfxbgo4YwsDn4b7v0wytAjje7LzHBWGK1DXJFLHiiahxlkoTTcxCMQ5qAi8l5pvZtJBFQMQaIfunmS54KWcHw2/epZjDmn1jacaYvAmyP+q+Uj/4955QahPagQE6HQ5QSLoEhww7PY9LARVIV8tnvKcffIXRNcA9SGftz3tS3wVB5O4+RJNbULysp+n+y5+nOFufSLnpzi1nQ1JOBT3EOiEapdozI82BuUYkQ2FOT1Z99JiHtMmHasAGl+8BpUKma072lQK+TElddRZ6CH5N1wxr9JZr+GGBuGxpSf75jrk14/NCyGOLeIeYFqHvZKHcQhGlU9rf1J4weMN3T4OkRm6NVTWHIfYSPtWKEy9i0jTvLTAQlk2bdKSPx0CTzPtAAIzKFYXucKzI9jlDxFmUCSvo9okgRwadZUAgvkMQ2o6eeeNjk0HHjb3VOBAvw4kCRj0giaqsCMFzsm7Bcw93ExGps4bCbCqCeXhDknHwIDTff1pY1GfOIibD48JsYxWU12kv5s+FT
 YW5fxzVu
 EP8CZsCO8vJIkNn5ujnBdmxuh/5P05Z25DswgZh2OFfCrxvHvE0hnCCbwSQnq7ACvMp9DmhKJNzIU/4KSZDOe0ZchK/5RY3ZpkymJTUu73YA61p3y4XSdOUKv/vf0lXmxB+CaS1DuIJeAEuVsrgmELvOR8LFlbUXssvoiFvw8AF4U7ZcHPanwzR4HVjVlIYnsABp1y6HSOm7TDPhXaZFDMRvDaAx7RTW2PSLJxTu2rT2HLxPZY5+pLTHqi5Y/iSvf8zM+3rKlj0TvOiRx85ODhdbTGBgf9nhcHnGMC9hQfetZpSDHqZYpfhn0sQAvzWRRlZCwT31xaFulJ7ggiDn5+tHJAGz/LytOcuTtIWVQLwsR71uJmIoTzu7rTXSyJNvEpFuiouQ3npXknGpaBH26IpYA3kl+19v1cPI3H3WG+3SICJMm2rN+qhBoWlF7WhzdCNLCVaeejZEu5qppB3X426Zmu04TMAKWaSHdzIJEL2a/zoJpZqJgMKM6UtxBrGBb295ER1jCx9g7TmCQavX0/DYFNhf040p44MzaPhxU23OMrjgzVPXSAvxYSHtOO3US+mKC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 7, 2026 at 9:19=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Thu, May 7, 2026 at 8:51=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> =
wrote:
> >
> > On Thu, May 7, 2026 at 11:35=E2=80=AFAM Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > >
> > > On Mon, May 4, 2026 at 12:52=E2=80=AFAM Vernon Yang <vernon2gm@gmail.=
com> wrote:
> > > >
> > > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > > >
> > > > Hi all,
> > > >
> > > > Background
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > As is well known, a system can simultaneously run multiple differen=
t
> > > > scenarios. However, THP is not beneficial in every scenario =E2=80=
=94 it is only
> > > > most suitable for memory-intensive applications that are not sensit=
ive
> > > > to tail latency. For example, Redis, which is sensitive to tail lat=
ency,
> > > > is not suitable for THP. But in practice, due to Redis issues, the
> > > > entire THP functionality is often turned off, preventing other scen=
arios
> > > > from benefiting from it.
> > > >
> > > > There are also some embedded scenarios (e.g. Android) that directly=
 use
> > > > 2MB THP, where the granularity is too large. Therefore, we introduc=
ed
> > > > mTHP in v6.8, which supports multiple-size THP. In practice, howeve=
r, we
> > > > still globally fix a single mTHP size and are unable to automatical=
ly
> > > > select different mTHP sizes based on different scenarios.
> > > >
> > > > After testing, it was found that
> > > >
> > > > - When the system has a lot of free memory, it is normal for Redis =
to
> > > >   use mTHP. performance degradation in Redis only occurs when the s=
ystem
> > > >   is under high memory pressure.
> > > > - Additionally, when a large number of small-memory processes use m=
THP,
> > > >   memory waste is prone to occur, and performance degradation may a=
lso
> > > >   happen during fast memory allocation/release.
> > > >
> > > > Previously, "Cgroup-based THP control"[1] was proposed, but it had =
the
> > > > following issues.
> > > >
> > > > - It breaks the cgroup hierarchy property.
> > > > - Add new THP knobs, making sysadmin's job more complex
> > > >
> > > > Previously, "mm, bpf: BPF-MM, BPF-THP"[2] was proposed, but it had =
the
> > > > following issues.
> > > >
> > > > - It didn't address the issue on the per-process mode.
> > > > - For global mode, the prctl(PR_SET_THP_DISABLE) has already achiev=
ed
> > > >   the same objective, there is no need to add two mechanisms for th=
e
> > > >   same purpose.
> > > > - Attaching st_ops to mm_struct, the same issues that cgroup-bpf on=
ce
> > >
> > > Hello,
> > >
> > > The primary hurdles preventing BPF-THP from being upstreamed are:
> > >
> > > - Uncertainty regarding the stable API
> > >
> > >   It remains unclear whether the following API is sufficient for
> > >   BPF-THP requirements:
> >
> > Thank you for pointing this out. I will add it to this issue list in
> > the next version.
> >
> > At the same time, I also encourage everyone to actively provide
> > relevant real workload scenarios. I will conduct related analyses and
> > develop the mthp_ext to address them, so we can determine which ABI
> > can satisfy the BPF-THP requirements.
> >
> > >   unsigned long
> > >   bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type t=
ype,
> > >                                             unsigned long orders)
> > >   {
> > >       return orders;
> > >   }
> > >
> > > - Ongoing integration of cgroups and struct-ops
> > >
> > >   Work is still in progress to integrate cgroup support with
> > > struct_ops (see also
> > > https://lore.kernel.org/linux-mm/87cy439x8a.fsf@linux.dev/).
> > > We should wait for this infrastructure to land before introducing
> > > new cgroup-based struct_ops.
> >
> > This work can be carried out in parallel with integrating cgroup
> > support with struct_ops. I will focus on addressing real workload
> > scenarios to further clear/stabilize the BPF-THP ABI.
> >
> > > >   faced are likely to arise again, e.g. lifetime of cgroup vs bpf, =
dying
> > > >   cgroups, wq deadlock, etc. It is recommended to use cgroup-bpf fo=
r
> > > >   implementation.
> > > > - The test cases are too simplistic, lacking eBPF cases similar to =
real
> > > >   workloads such as sched_ext.
> > > >
> > > > If I miss some thing, please let me know. Thanks!
> > >
> > > BTW, it would be better to include the original authors in the CC
> > > list, especially since their work is cited in your commit message. ;)
> >
> > OK, I will CC the relevant authors in the next version.
>
> Hello Vernon,
>
> I believe it would be best to hold off until David provides guidance
> on the future direction. While I am not currently active on BPF-THP,
> we are still looking for the right opportunity to upstream it. The
> primary difference is that your implementation is cgroup-based;
> however, we also plan to switch to that approach once Roman=E2=80=99s wor=
k
> lands.

LSF/MM/BPF has just concluded, I think David will soon share some new
directions with us.

If it is merely about converting to cgroup implementation for
per-process version (I have already completed development based on
cgroup-bpf), there is no need for you to start from scratch. You can
directly test whether mthp_ext addresses your real workload scenarios.

Based on the current patchset, we can collaborate on development, as
our shared goal is to get this done right.

--
Cheers,
Vernon

