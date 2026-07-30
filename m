Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0AF1C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE816B00A1; Thu, 30 Jul 2026 05:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EB46B00A2; Thu, 30 Jul 2026 05:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E3E6B00A5; Thu, 30 Jul 2026 05:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42CE06B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:20:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB46C4094A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:20:36 +0000 (UTC)
X-FDA: 85044897672.09.E6FBDEC
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id D20C580006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:20:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W8TluY9J;
	spf=pass (imf02.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785403234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvSFMl8ghpXTurmAcw1Wmt2z0RU/AeJhReoTQ3emrvw=;
	b=jJtXoYIJL1PWnJ4no/izoe+bSMHuF5os52xVtb+R7ZdMsqCSa0+xYrrmjjpreshxrGFj6r
	1Jya3xDj48JFI9z0NcgrYRwXxjnyaIE+rIN+l9hBA5eiPkAUfYdjFOfZlTGe8cErWhMWsy
	ELfpSJ2gLo3WWMPl3yO1wKWli7xvVgs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785403234;
	b=5aEt485TjEQBuUin1Imfh7b85KAErDCR+fDbhuDocYYuIOG/vrXbPjaueOOFp6JNhOHZrx
	84DJ2rEQEZeWxUAkABmxNnJv13P7OBGLu7yPy2F6tNqxOxU0Si8aPVBshOb5QSFquXaCYF
	f0SKqls2de98IxSs1TvJYZtNWCmApvg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W8TluY9J;
	spf=pass (imf02.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-384caf7b168so182146a91.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:20:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785403234; cv=none;
        d=google.com; s=arc-20260327;
        b=ZyywoZQMIZJ5fnmW6uSlv2vEhsAkXGgTIciBPTDuiCfEBgvh+rjME4k0XOYZ5AIfIK
         qYb8vovfWaib4S3hX8TaNXvoW14fRr/RURyxwAAgeCaPru0ehCOdi4K77GIDE9xKsySR
         bDBxygogxeFGS9ZYyrWlBdQI/Mbd912V9kV0Dz6KFibtmXKCdAYR7reS+GAMxRJM3TZy
         utgO8BwmOv0asrO1wK4LPRaAJz/vDtHhjOVL6kl2WGk2xq9xMU8IRWbE+z3jgCA0XCf9
         MQFqE5GarC3tvYta6q69T7KRRbEBsesd+g2LpaxFgRv54jo30CLQoOCl8KLCdd02t4/7
         w42Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uvSFMl8ghpXTurmAcw1Wmt2z0RU/AeJhReoTQ3emrvw=;
        fh=uXIuuI1Cusf4vjttzrkFuVEX/lacZXsW+qElAtBJjd8=;
        b=hVRdARzj8llXdfaVhtdKj+esxQjbuzZoGR6A7HCkFotCzym/MKMm4dLbrls4eDykH7
         fgXXqX/C0hKNxA1OCgULSyB9JyTNIZF/lmsJT+qyRn7tR56cRpyuRmBhdgr7qBGKwV45
         8q+2BWk5tod9Sug0QYCMsDssBh/FKfZS5H2esI7zLM8rNhfooUF6cW1y0TXA9Xdd48g8
         O3r+ZZuTXcxQO7bKaoJ2p5FKHRQXZpem0JmeHhgrhQdFt2ZUjXT+Q6lVMQJ80xfn2oUP
         qUHJk0Giau9aZNqiNgR/+Pc6bHeHRYNLq8WX+TWA1ecXzdr+lYyI2E+D25AiH5Wo1DaE
         mMTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785403234; x=1786008034; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uvSFMl8ghpXTurmAcw1Wmt2z0RU/AeJhReoTQ3emrvw=;
        b=W8TluY9J2/DhSWlvoiBM4et6oHQXa9MZFusRYWkWl/o+vl6Rk4CBN9aOJFLsGpUiOH
         EgaAtMVDegTTVXkQ9P8UPcc8xlZqIjq80HLhmp9eK8YXzRofcHQLpJ9sTqpmm8gXSB/N
         ovtBGP8ih60ORuxaNPio1JjEebM1w395FwtxS3GcoAJBbAj5vVbH+bkIWCjzQeyEZpOI
         xY0MHidzpVR5VpqBh9uvYZkgTNz1/C834dnoJ6aUtlDH8eXXEaMEgt0NQgeOXugRpQJx
         J5Q6D9xxzl4D2f3D8ObwtXfbwYr9sgDWq7lRFqtcWnnxGs9t313vWhNhjo/LBd/u4qxY
         eH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785403234; x=1786008034;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uvSFMl8ghpXTurmAcw1Wmt2z0RU/AeJhReoTQ3emrvw=;
        b=B7pNJfghxtUqN4zwJ1ivUO7o+lBQCjc2fMwBN9nMU2EBgV1dmkTwtK2ruRszsA0dkj
         jWu1MbZA+nirT4A6KvbYtPoJRR6a4S1n/opD+Y1MyRIOsgq3YdFFtP2Kst7vLTRiKZja
         LBpQSfOcDaed7vxSW7NshQ8ukqi7i9XrUD52Xie/7MWPh10+iSl2g5mEiz2CLfX3AtgY
         3ZIFRWITdM+nkh3d4dP2dUE7j2KdF9wSR6IglGm1dMeWyfXFt+ke/YW/AST7nddL5n30
         lZzFlQpa2xT/CKzPZvk7P1b13E7EPVjReR64OM8VJ+uATvrvKP3oToHkiZZCOE5jHqr9
         BH4A==
X-Forwarded-Encrypted: i=1; AHgh+RoAG/futmzzLE/TQ6+ste7y4/6FD8bD8RcSw2EVGTAFKb0BGqACGkPUzafawF/4hbdL+ddVFVuBMQ==@kvack.org
X-Gm-Message-State: AOJu0YzWYdp36NFW5KMAeRwlGBSsqE7PDy6w70NIabcixYBI6W7ai6Vs
	IBm9B5EUAaAkhDbvW2K0wHZ/khSBVaHb4vlqbr3TDmc78SEUtuoW3xUcyIp/jEAqF2eIgnaiCxd
	I2bgsbnXA95vsi+mk+jhC0qtrk/oeelA=
X-Gm-Gg: AR+sD10zUNAjDkUJpOYzxwuZLqbJmYu2COOpL8eZ0kOWIdFCguC2TeHgiqKuCxziIG+
	MAybaTg73OhFPjYxoH0wEfAKcyqekZ41Pc1J8JWAypTbuTlaFditxDNTWuSj05bbM4IupjLewbW
	8q1JCNCqHy+r05TCoyX1GXosMLkxY8/u099142StFJvvCDALi454EEYdh5Wm86Ff5hWlTX5eSVu
	hIWS7ILJ/3bUiiSMFTVOVY/lwDZFj/0eY9hWfjtkub4PT73o9LXdNkWYviWHxR4ffx2AsI79cnI
	CKhNI+wSpD2rdBF65PA2NbcL8LA2dxHhgCb27EyMRci4tOA=
X-Received: by 2002:a17:90b:4fc3:b0:38d:90c1:2400 with SMTP id
 98e67ed59e1d1-38f9bff9c78mr2271112a91.2.1785403233610; Thu, 30 Jul 2026
 02:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com> <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 30 Jul 2026 17:20:19 +0800
X-Gm-Features: AUfX_mxb-EiA_VBy94_qnKIcmuFlLdC8lty_CWiGNTjD_ReIOp0NyYtwubJwPdY
Message-ID: <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
To: Barry Song <baohua@kernel.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D20C580006
X-Stat-Signature: z1qw5j9wc1p1hm8zd871ty1xf1mt8szj
X-Rspam-User: 
X-HE-Tag: 1785403234-960571
X-HE-Meta: U2FsdGVkX1+jnMdw2kE8emetlIIVhpYel4oWjof6sfthJIOnflCVKnczbW4ihMf748QB4r5PcuzfHCzUrHWJuSdBazPjC3LFeuwaONLkioIbNc2e+pIV/HwKL255WnRq7CZSPS2sWNMGeEXfFEdYpTr3Q7OXEsVbtYmAwtpH7SfhEi2x7sf66S1Dz2a6tLP83gqFkKhp+BWojbftJNFXnWfCfH/mS7lJYz4AoqLQ53/uSutvz0SllkOz1OTzQagbBnu7/1xJqI9hAr2PNH2Mvvn3mOi6iRyvq9L5QMBOZAgMWlkyrEXq0olMCHplWjKQPb+U/u1vRVSWHf9pR1MDWzgEAXJ3S76q6I0eiJKJLGBavcg2JFXxGut8E2LYaev6RcPj2PIygSpiSrs6bWRgpZ96Y3PbGgHc3GlWAE/6t8RqR3nZdyPut7TzMQ/vsOeV1LTMVXZjrUR+zo2ACRBgaKZFia7pfUucPvzJXXi6OZpCExElh6vhe8DLNpdth6b0yOxEFqtbw33b87ov3WdMo0TMs/uTUfIHiSK0WRK1Qdv65blFNiPWy4XGwp7fohmXB3tdc735ygnguk6rpz440IYqCWXQVy0Y2TI93ctYen4XVsfoxclgaCmXHOZklnlWUVkl1NzrZh6OT09UShqqzz0NV0o+DhSpkkRIV7ZFXAR/9G4QFKDosZc0BxIZH5jofjU9Ej/3vQWZ/NIpdvwblx18U0Zu8HW4CgkAcDCLOSp1h6WY9TpzXKsge6efBjKtymdFuw4JzI5Ydw5uU5K6RAVsSmpy5uZ+ukbZ4sGg3Crp6n1Md/moO03OPHYTrszovrbp5H09YF4Y+nKBpyX0RWQDONj3dE+aegcRxgplcl6gxryno2/dwsUhxv2fnnxNhrffXNgLK+TkcbQCrRuGjf9KYOrVktIPQqejlYJ7Flv2ajNOow5Id2l1s45WRJUXyAQiwE0CqCDA0EnkPVr
 RXclkS5z
 rFSbr3mAndoYYH4tEm4yENiexf1OUEhPfnpnZ06pGtT93a5FEpdRCLvBzTJheuQ4OyfdF0kUJa3k4VQD0muGUrXP7RzedWc5ii/gCGhzq2lhUqKNH+LUcor91nb/eMcfF9X6rGuK1eCCKreFmukzIMkLAUvfJbcfS52cjU3WavRlioWd2p0yI7faWkh5wbjg79xF/nrsfVThnHLvjeVECaKHZz52+d9JNXdiMM+fXpctun0ilecSPLEsPu0J6vMhAYDLM7MHbp19ixm9moSJ8EgKu+A72V7PiWCpYt2tQW+CZI9fpKwA4ZI7oHGfPIS8jfQxoKZsfW1WmXQveE8jTDPjW7QeSspdp+VSYBtxFbNJkpNAZY/q1hE4aCR7VJN1O/vZZQI5lncXUppN9RkF3A0/tHbYzcinL3mguHXLsKvkPshBgt51Aap/TvNjvFsnAWPG5nowj3PvbfUxsLw4prywYOYpSVkl0KNsXIku+RaS6prc9n2x8K3Bjg0Q0TluIMQMzo7+HWLjOQEttbzhX8FXx5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 5:06=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Jul 30, 2026 at 3:24=E2=80=AFPM zhaoyang.huang
> <zhaoyang.huang@unisoc.com> wrote:
> >
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > This submission addresses an issue where the memcg MGLRU's min_seq is
> > pinned by an orphan page=E2=80=94a page that resides in the page cache =
but
> > lacks a corresponding reference count, while the number of GENs has not
> > yet met the criteria of aging. I believe such pages should be detected
> > and handled elsewhere rather than affecting the LRU in this way(legacy
> > LRU could move forward by bringing this kind of folio along with).
> > Therefore, I propose moving these folios to the next generation when
> > isolation makes no progress at all.
> >
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> >  include/linux/mmzone.h |  6 ++++++
> >  mm/vmscan.c            | 45 +++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 50 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 9adb2ad21da5..b063c56ea30c 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -434,6 +434,12 @@ enum lruvec_flags {
> >          */
> >         LRUVEC_CGROUP_CONGESTED,
> >         LRUVEC_NODE_CONGESTED,
> > +       /*
> > +        * MGLRU: eviction failed to isolate from the oldest generation=
 once
> > +        * while the window was at MAX_NR_GENS. A second consecutive fa=
ilure
> > +        * forces aging so residual folios cannot pin min_seq indefinit=
ely.
> > +        */
> > +       LRUVEC_MGLRU_ISOLATE_FAILED,
> >  };
> >
> >  #endif /* !__GENERATING_BOUNDS_H */
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index bd1b1aa12581..c18db08c5e10 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -175,6 +175,8 @@ struct scan_control {
> >                 unsigned int immediate;
> >                 unsigned int file_taken;
> >                 unsigned int taken;
> > +               /* folios isolated by MGLRU eviction in the current lru=
vec pass */
> > +               unsigned int isolated;
> >         } nr;
> >
> >         /* for recording the reclaimed slab by now */
> > @@ -4748,6 +4750,7 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
> >         trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_ba=
tch,
> >                                 scanned, skipped, isolated,
> >                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE=
_ANON);
> > +       sc->nr.isolated +=3D isolated;
> >         if (type =3D=3D LRU_GEN_FILE)
> >                 sc->nr.file_taken +=3D isolated;
> >         /*
> > @@ -4998,6 +5001,11 @@ static bool try_to_shrink_lruvec(struct lruvec *=
lruvec, struct scan_control *sc)
> >         long nr_to_scan;
> >         unsigned long scanned =3D 0;
> >         int swappiness =3D get_swappiness(lruvec, sc);
> > +       bool attempted =3D false;
> > +       bool rotated =3D false;
> > +
> > +       /* per-lruvec pass; sc is shared across lruvecs during reclaim =
*/
> > +       sc->nr.isolated =3D 0;
> >
> >         while (true) {
> >                 int delta;
> > @@ -5006,6 +5014,7 @@ static bool try_to_shrink_lruvec(struct lruvec *l=
ruvec, struct scan_control *sc)
> >                 if (nr_to_scan <=3D 0)
> >                         break;
> >
> > +               attempted =3D true;
> >                 delta =3D evict_folios(nr_to_scan, lruvec, sc, swappine=
ss);
> >                 if (!delta)
> >                         break;
> > @@ -5020,6 +5029,40 @@ static bool try_to_shrink_lruvec(struct lruvec *=
lruvec, struct scan_control *sc)
> >                 cond_resched();
> >         }
> >
> > +       /*
> > +        * Eviction isolated nothing while the sliding window is alread=
y at
> > +        * MAX_NR_GENS. In that state should_run_aging() is false, so
> > +        * get_nr_to_scan() never calls try_to_inc_max_seq(). Residual =
folios
> > +        * that fail isolate_folio() can pin min_seq and hide reclaimab=
le
> > +        * folios in younger generations.
> > +        *
> > +        * Require two consecutive isolate failures on this lruvec befo=
re
> > +        * forcing aging, so a single no-progress batch does not rotate=
 the
> > +        * window. Successful isolation clears the sticky bit.
> > +        *
> > +        * Key off sc->nr.isolated, not nr_reclaimed: folios isolated b=
ut
> > +        * rejected by shrink_folio_list() are put back with PG_active =
and do
> > +        * not pin the oldest generation.
> > +        */
> > +       if (attempted && !sc->nr.isolated) {
> > +               DEFINE_MAX_SEQ(lruvec);
> > +               DEFINE_MIN_SEQ(lruvec);
> > +
> > +               if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GEN=
S < max_seq) {
> > +                       if (test_and_set_bit(LRUVEC_MGLRU_ISOLATE_FAILE=
D,
> > +                                            &lruvec->flags)) {
> > +                               rotated =3D try_to_inc_max_seq(lruvec, =
max_seq,
> > +                                                            swappiness=
, false);
> > +                               clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED,
> > +                                         &lruvec->flags);
> > +                       }
> > +               } else {
> > +                       clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED, &lruvec-=
>flags);
> > +               }
> > +       } else if (sc->nr.isolated) {
> > +               clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED, &lruvec->flags);
> > +       }
>
> This is very weird. This seems like using a sledgehammer to kill a fly :-=
)
>
> Do you mean that isolate_folio() fails, the folio is put back
> into the oldest generation, and the next time it is scanned, it
> still fails to be isolated? As a result, scan_folios() makes
> no progress at all?
> And is it because the oldest generation contains only this
> folio, leaving no other folios for scan_folios() to scan?
>
> Why can't you simply promote the folio?
> Do you know why isolate_folio() keeps failing? I suspect it's
> because folio_try_get(folio) fails repeatedly?
Yes. As described in commit message, the orphan folio is an abnormal
one as it is on page cache but has folio->refcount=3D0 which makes it
isolated and putback to lru forever and finally be the only one in
min_seq. IMO, MGLRU should keep make progress with bringing this
orphan folio together with.
>
> static bool isolate_folio(struct lruvec *lruvec, struct folio *folio,
> struct scan_control *sc)
> {
>         bool success;
>
>         /* raced with release_pages() */
>         if (!folio_try_get(folio))
>                 return false;
>
>         /* raced with another isolation */
>         if (!folio_test_clear_lru(folio)) {
>                 folio_put(folio);
>                 return false;
>         }
>
>         ...
>         return true;
> }
>
> Best Regards
> Barry

