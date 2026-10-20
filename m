Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C79E606A332
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bqspJJZ4
Received: by kanga.kvack.org (Postfix)
	id C5A1F6B0162; Tue, 20 Oct 2026 09:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0AFD6B04C8; Tue, 20 Oct 2026 09:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF96B6B04CA; Tue, 20 Oct 2026 09:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 887256B0162
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:19:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E24E3A01A5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:19:00 +0000 (UTC)
X-FDA: 85343060040.20.FFBF890
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id F1D2D40005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:18:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bqspJJZ4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792502339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+31L6D/8A8U1mIX096CB/r7t4YtUtlf54h/6tqEmZI=;
	b=NF7oJy8ejxGMCl+Ff3jknEJfVWGNt5po2yvxZzNnBLv7qinxOUk8Cl4tIoE7j0FmSuDc/P
	chxERfR66qzqvzlQ/ZhEKsUG6hVsF84p22Cjc8+VQnvsntLZmeHOPiuBKqrou/xFgp1WD8
	TJrYq7WEBrqjloktLnN0NJZwH74kJug=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bqspJJZ4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792502339;
	b=Fc67bSr6Llc+1XfYvMN+043n8HjovAKprl9y2kN/ft4y+Ec6rQUK9Hcp5RHfzsOGB6A3Wa
	20xARBSJ/siBRU92CnBs1h3KfZGpt/JItBVnOHxgwpco5bJhuCThg6pXOEF6D2kXLHhai7
	tbD1uZxup6rQ0IXWIjdudX69GFp+yZ4=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so24491945e9.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:18:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792502337; cv=none;
        d=google.com; s=arc-20260327;
        b=GubBrKvsNnBQ7kUyaPcppKiW8xAlS3qMkVxGXwmRpA4elrFXOeqTY1pNOzK/79YrjB
         a7H049x/MVt7Ufqa3BTMu1h3UKcbISmnuxnVeztXSRz9PfQ9C+5SirtQBIDtL6MN3INg
         Bmph6sNa2FjmjMSs4sYDrHg+YqEuErc4d/RS4V3Ww1P1uO63VAckiTJFbwImRWGtAu/H
         W+n0+44bQbORpXkl2/raNgRyI7Bmh7iOTtmnf6+sRI3pJU6hJgiaJTSziW/aarH0GYbW
         Hrhr4n2DO78ygi4pmQFcOdTRLSeFOqZ1kD31Ts4yzFNQmV5ffyivHoBjjU63JsX6kzeD
         +5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i+31L6D/8A8U1mIX096CB/r7t4YtUtlf54h/6tqEmZI=;
        fh=Rh13OZg5BC7H57uB/WMyHi/Il6VQ7hn/4oMhLAeozQU=;
        b=orYgBs2L7SvIL5+a9nTJKO07wH9fKsM9+q343caTN6/7u0Vp/jmLzoRgvmxMlVj9Sa
         OGPIJUDzdQr48UjgAfenPZ00nw52Au/tRsWNJ0rXt/ztcPIzLY0i7usQ0XQ562fuwp9S
         LUSPD7SKpn79SCB7lHH0wB/xRJkTAqdxWyFtdNFRgZww1m3ZG2yqxfkhICdFwV01mgEL
         66Zob8uRJkrfC79WflqsR84+CcsrYYzg7MmbTj9VT8VNJS6tOYEVaiuKtOTKcuZD2uiV
         4AzwdhRhP9ud95JIi5PpsMkhvICSABqkVF/+/JL9yqVrrETnk1DaEbTMKhsLa+qvFp+A
         MgEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792502337; x=1793107137; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i+31L6D/8A8U1mIX096CB/r7t4YtUtlf54h/6tqEmZI=;
        b=bqspJJZ47BXQLyhCzRqeaamFzUjwYfcoKRXAc8lCLpjxGz8WV1vPgP4HWmRtbU+Bi+
         DOAeM8WzaH7a3kaG7X1O7LtO116/h57T0RxvEIsZC7OrzdUIM1S7Q54n0/tlrs+2DNaW
         TJNsA3+ukGfYeSsQFttkwbF9kYqcuysLXSdjwxdJ8aeGmMM2WR8AgV6iRc1GvMuDym3b
         SAMgdD3vpki6+aQ6xw53brQG/kP1+IUT5BcV6f9Zh0YQr8CUPJ+5UFOuqGkkVURd9jN0
         vhi2npMQcZbXiEBLnMWVRZdCtTTtHAwJj+3x1RODk0aAGJ6U7f59eFqBAauENb5BRUND
         Nf8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792502337; x=1793107137;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+31L6D/8A8U1mIX096CB/r7t4YtUtlf54h/6tqEmZI=;
        b=D1+82rSB/rk5qyqf1oRmeKcIXa0eV9z4VmTidmXCddxUe8L6/a8AVjDVIm40StKCYs
         mhXRPv2GehCExFGmwECNAjFvIgRM2/4cUwD4ZKfOzpd7qnuPmN4Up0Uw1qzTBXHPsTVy
         39yut7l4M5Tci0BBHcfFrOIYFyHzJY7/zvdOEBvMAr865WRrxtDx1n3K9sMXzNL9pkrN
         u0+5u3QDuxEcjx3fIaLlC5tT0ttB/SDnPnMdCharZFjmd/brSrg4TnSiOQbf+FTyNpW3
         GhxN0dJGv2Km6h7AGN6QYeG0+gw4MFLMwml7+wZ0uEFd10WQjEXbCnRWMWD8bV3CasIh
         CxWA==
X-Forwarded-Encrypted: i=1; AKwUvBwElij4oXx75fmyj6yYkthnqdCijJi5YRBQiEESbpbEXC+cdfbayuJMzKeBqq3hezqgSIam2FNyMQ==@kvack.org
X-Gm-Message-State: AFq9FYKaHXcKV+bzviLr7qUx4IfQrbcqsGZPrf5wNED6lX3YJLsbmlMg
	0X2r8V+YJuR5afuAk7Id3IEjulWQ1zVC6aRimCFJPwgFioC6k7Y5KX9Zl+4XOkjmOiOUvywHfcw
	aQv5+V7mXfSoPiQRhNLk3KvLiqZXAAwo=
X-Gm-Gg: AYBFou02hvhf+otjronDm1EMpjuY50pqoCelMMiwZ/xcl8tzoCejnoGUsVoJzHH4Jqa
	NiMmRqUJk/vMEf7KMAErvAYGOB/20JkYiZ4hhizaGtmYeK4aHDCi1WfO7ts1XvX4sOXH07sCF8s
	PHOhwb4LpiW6ZWYQeUzMGz6CJQjBdsH/1wLVN9P/PhRoau/3QutuL2MEw3vzZE5jIozyV7lV97P
	Az8b69PTZ0iYuMKRGj1z10Ohs76CbrRefXz4BbDvVB/FGn9WyCWAfsWktLguEiVCw2QIpoyVjdv
	d6yi0p/ps1FDQhZIuG6BzualPf98UXO4JFbUrjXYGREjKETTciUzTLqsr4EQAD7VNbu10KWybXb
	7yqCWwQqdpsWPBSeNk1198QM2QPZTZjgj/l9EloRDsO348vFQjuIZX06uU+orSSy/2+5fSzs=
X-Received: by 2002:a05:600c:870b:b0:4a1:d487:2dc8 with SMTP id
 5b1f17b1804b1-4a1d760518amr230058635e9.18.1792502337460; Tue, 20 Oct 2026
 06:18:57 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019160615.2348500-1-nphamcs@gmail.com> <atcRLYvKavedT6Hs@yjaykim-PowerEdge-T330>
 <CAKEwX=MRvzzd0Fn=UX+LcRo+K9wuqCWSB42NNn7rvZkZukRRrg@mail.gmail.com>
In-Reply-To: <CAKEwX=MRvzzd0Fn=UX+LcRo+K9wuqCWSB42NNn7rvZkZukRRrg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 20 Oct 2026 06:18:46 -0700
X-Gm-Features: AclHuK9yxutAL1VqPHvSn75b4RZFEVufpPDBhsYXxR7jl8qX4EzLhrwQ7rZCnpg
Message-ID: <CAKEwX=OwzpxUfdANEXoCeZPBqch+91C4gKwhrcikm6Gj_LBPKw@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F1D2D40005
X-Stat-Signature: 3wqrt5gs5bj4qdda3sp19k85arr9ufpb
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792502338-586192
X-HE-Meta: U2FsdGVkX1+1tQ+SiaDw79A57uuseNG3rE11MUU91zl+xZOybd6snnZ0ucZzG2GpFerD470SFHGmVNELWjlLG8KL13dFp92gMm/S0+PqW8RNyU9LR5OuKlY5X3dERo6gp9lXkH14k0A9froBCoZhPhwCMgPhLxUJjt0spuJ02RLWJXQzyu2wP4MWJuzG9yhVXE+q1yLclAnJNdJvphnDupGWUuUEacpBoZOJzG2gfUobTCEJtb7ScrMQDtndUuXbp9zk4GPe/UCz/tjfzCVYQ5rpJ6GFfzqyZwuEehof6j6krL0jMvRC5bYRLEh5Fl0x51xJ/2HW0UZV01KMzhTHVIzcvkGq17an4cv2Lz2D9K1f/S4z8vZitiXOhEn423joI31hrPfAXdmqjmEKhv1Jbr9FItaYkZKcPbicFxNbpt/m0RQgdn/e+wgX30M0v2JpRt2ijvuLbBT585KNHDjPvG+poYgkyRxsxYhkRsr0Iae1LyaBvdU6sQfvI8BEdVih5itGlToJac961SMw1GzcPn4a2EEUTOx4OrFqVNY7IYrPODVI+euAM3KWf2NUbzVR4D68bec6+8vjwVQ8s2l4HtMtrTNeiSMRdMGjXFVDM0TdhKWc+0Y6w67I5PhILjgXSecD+kwGocDYWv8FiFOqRZgLN3Y4YmTZPgYblVd1rZLv8p83l7I4BLmg5Iz8JEVLlgbnlq5FrEcDmWJtvAXGaxLcM7mHKVFkb54SICoc43rrF9gwGQTURZhYyrnqOdpo2sH3EGuXkONXNs+UhOIsJC7fVrkb2tuU4SstwknCjees71Zj7RpgwYQ6OSPAZX4JORD58JnljTzDBjz6L4eTWOvSEMQor1MvA2wyJCFo4TFddXZZ5/vUYSlINzofwzfTix8bNXTnywM9QuGRWENzDPV6Q8nKSzi8OOhqN4+iUGppzuSbmhPZSs5yh2ADK2u7ioEZf+o0LXYEIZ6VfHR
 9PRjq7sw
 SEMevoD9qhAD0+/L6zak4gc8S5vCiNAyIAywU2nHBKoIySdL0Dvs6Gh/4k5kZOSI+fPhasODXFJZsoNku9PjTCAveTxhuLGh2An1OTKvuhydYn605Xr/yVFALkK9hKGoiO0c95LXykWPxNLvJexd9ydcuZPcnr70zm6VAEhGhZA+h8QErKDD3u1Eaq6bVGvkwpjqUrQiFP7C9xZeym1Oc6gIohvb/YMurzx7HDJialARnmdat5VX80freiuZ1LiZRhEasDIAj6z8sFc+vjiQRSOZfaqHjA1t+HNt83K5DPVwHz4h/vgH+6h1qs2YBcu+J8c8+9VmjLgBWYp2EDUx9zl7/zGoIeM0TS6LdDBlw3J5/8jzalQnyfzAisV0jK9a6MQSayR6l1IppDpmj+7NpvXMbzuf1rnCwdKwtdzd3p0GSMOT2/THP5gyJRA1LUV+61OJB7Eo3l03IsUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 6:12=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Oct 19, 2026 at 11:58=E2=80=AFPM Youngjun Park <youngjun.park@lge=
.com> wrote:
> >
> > On Mon, Oct 19, 2026 at 09:06:15AM -0700, Nhat Pham wrote:
> > > swap_cluster_populate() can publish a cluster's table with the cluste=
r
> > > lock dropped. A cached allocator can use and empty it before the
> > > populating allocator reacquires the lock. The resumed scan can then
> > > dereference a NULL table.
> > >
> > > For example, CPU1 can retain a cached cluster offset on an SSD with
> > > per-page discard disabled:
> > >
> > >     CPU0                          CPU1
> > >     ----                          ----
> > >     swap_cluster_populate()
> > >       swap_cluster_alloc_table() fails
> > >       spin_unlock(&ci->lock)
> > >       local_unlock(&percpu_swap_cluster.lock)
> > >       swap_cluster_alloc_table()
> > >         rcu_assign_pointer(ci->table, table)
> > >                                   swap_alloc_fast()
> > >                                   local_unlock(&percpu_swap_cluster.l=
ock)
> > >                                   mem_cgroup_try_charge_swap() fails
> > >                                   swap_cache_del_folio()
> > >                                     __swap_cluster_free_entries()
> > >                                       free_cluster()
> > >                                         __free_cluster()
> > >                                           swap_cluster_free_table()
> > >                                             rcu_assign_pointer(..., N=
ULL)
> > >       local_lock(&percpu_swap_cluster.lock)
> > >       spin_lock(&ci->lock)
> > >       return ci
> > >     alloc_swap_scan_cluster()
> > >       cluster_scan_range()
> > >         __swap_table_get()
> >
> > Hello Nhat.
> >
> > Good catch!
> >
> > > Reject an unusable cluster under its lock before scanning it. Relocat=
e
> > > it only while its table is present.
> > >
> > > Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helper=
s")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> > > ---
> > >  mm/swapfile.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index c3288910b3e3..988b7316e0a1 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -981,7 +981,11 @@ static unsigned int alloc_swap_scan_cluster(stru=
ct swap_info_struct *si,
> > >       bool need_reclaim, ret, usable;
> > >
> > >       lockdep_assert_held(&ci->lock);
> > > -     VM_WARN_ON(!cluster_is_usable(ci, order));
> > > +     if (!cluster_is_usable(ci, order)) {
> > > +             if (cluster_table_is_alloced(ci))
> > > +                     relocate_cluster(si, ci);
> > > +             goto out_unlock;
> > > +     }
> >
> > If this patch is applied as bloew, does it prevent the issue described =
here?
> >
> > https://lore.kernel.org/linux-mm/20260720071342.50742-2-shikemeng@huawe=
icloud.com/
> > (This patch publishes cluster table after lock acquired.)
> >
> > This patch is chagned the way I suggested during review... :(
>
> Ah I missed that patch series and your review! What happened to it?
> Did we just never land it?
>
> Looks like we are still doing neither Keming's approach (table
> copying) nor your approach (publishing at the end of
> swap_cluster_alloc_table()).

Ah nope, I saw that Kemeng implemented your approach:

https://lore.kernel.org/linux-mm/20260907091356.53026-2-shikemeng@huaweiclo=
ud.com/

My bad! But yeah I think we still need this small fix (or Kemeng's
original proposal?), unless I missed something...?

