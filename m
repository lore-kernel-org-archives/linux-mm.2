Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB0ACCF9EB
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 07:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2650D8E00C8; Fri, 31 Oct 2025 03:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C8F8E00A9; Fri, 31 Oct 2025 03:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179248E00C8; Fri, 31 Oct 2025 03:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 037948E00A9
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:11:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 791F512AA80
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:11:53 +0000 (UTC)
X-FDA: 84057539706.01.706EDCB
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9745C4000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:11:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ECW+bIP7;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761894711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXB+Vh+b92T0wuC0Ul2D33PSfjieUXT8f5pmdI4rnpo=;
	b=4coiMlBDCReq16H3jD6fyc3oqFgYDvmQ/6ZaYsss3myAFomcOHRlxeJMSJpgIjTNJuoP2y
	tlQhuF1I8VVJDSU29975lwA//Ix93k8nOSqF8Q5Cl+5Bw4ykH0LNhHJ2myulL3r6bWqGKR
	1/Q+r6Q76PwlSf/0e5x0qoLY0Td851Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761894711; a=rsa-sha256;
	cv=none;
	b=K1Ol5b173c81OQ7HbZl/cskin4EacU4IYCxxcrShXgdshtWCbCTfyoKXmClrQY48jg4XMa
	nWZQ+m8xZSot2P3PdTfchVUezTDfFcMZyxi514RPdOK8VVQqrUmo8jGRHA/LpIx0I2Dqvh
	aT7lR00hJ6m7czssKJhCJIABCGTjBBU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ECW+bIP7;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so332268a12.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761894710; x=1762499510; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXB+Vh+b92T0wuC0Ul2D33PSfjieUXT8f5pmdI4rnpo=;
        b=ECW+bIP7klX1NUCSfF9K5Pjx4tTKEy+Pxqd4kYcsxeG64ltqTbK/OIu9EWDRHJHXrk
         5mbJhKme/ITG6SAaGK1tEK+OMtzGTNFlkezTvIkpxQBvlqIcHI+GP2p12H1MQ5/DsLJv
         fyRvbxYttFSTZzWS+tYPdaKeI3zL/ubvBPTtv1p8ZOhj8oZi5RL4AzzpTFAk6sR1DY8y
         +sFfRRrf9JiGojnrQHhJXbD2O9WkgfizgcwcX5v6NYlaDgHOVPf21KxZQ2s1jOUCLaSL
         HzcV3w0/MULeJ39sqenrOoqoDbs+2DTUyyU3aduR282P2BNT2C4zK4Ai7k3+vH2Fujzl
         nwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761894710; x=1762499510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXB+Vh+b92T0wuC0Ul2D33PSfjieUXT8f5pmdI4rnpo=;
        b=WzjjN2qG/3ybQTfifeTkYwgcSk4Q5EaBrusCaUHTssSEvOKOT8d2SY3tuIcMOXg25r
         bTah/EMhZXp5dmXnBLtrxhau4srtKlQYymJ0MDSQajytt63k3Vb82Bt0E0q+zXTXWRnk
         P/dnq2UTENqXSUNDw2/uqn5m5NnqgU4+hzsn/aTGFB1ol9+du+HkJGTF2D1WHik405RZ
         Ii6zS77RiNDnixkIKpi5r9Efyo/NXNE//fZjvpHzpdrXj9dh7eP6i3w6txopUmozvKA1
         FJXk8RMFWYGeKQkRzSdFTZ6Fhin5/Hw5V1/D9WGzy+72l/CCP0SMod67W3Pj6TFLAMpl
         /ypQ==
X-Gm-Message-State: AOJu0YyejORIsiptXK0BhvJQP6jE46Csx0V3ykQXliZn475oXXzyZR9q
	vrOWrOTnNZBJBWOO2u1ESjJIPwrsZIm6jbgMqMZ9OIT+Eez7+sI349W5CO8X2C9qO/i2K3JDwuZ
	vHzpWQkDP6fRe2Rbj0oxaU1Sk4UMeqEuyhZtgSZQ=
X-Gm-Gg: ASbGncuG7Qpx3r7eeLPbGqoOE7k8uCJrdKByxWTkk/k+8DcXe7xY75AFbFXnsmcBToi
	x1LmDTHB54f1/JRZAkY4kp7A0XMFcpbs66RyKbgoNMReSY0HAFrqhLXyXAd9H88stSdZcR3g0Xw
	OqlroUQ3RtPhdOXEDkNAFRaE9OYFMfCr8VAal0CC2sb7HSoNP438+8fOJTgvvdS5SFbqocSGMhs
	+44oDF+lFYYUU8LOe6z1A6FFl3gZHhBBZxVrJr3EbPPaA5rf8s+i/X0HCb3
X-Google-Smtp-Source: AGHT+IEa+rgq4Th4Ha/g3FBZ4FkmU4TjKVn+RGltX7Wmz1uoTotbPOvX8BJ4rCoXh+dAatlVRaYla2NKrWme3YUf5D0=
X-Received: by 2002:a05:6402:51cf:b0:639:ffb5:3606 with SMTP id
 4fb4d7f45d1cf-6407703ef39mr1959342a12.33.1761894709939; Fri, 31 Oct 2025
 00:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-10-3d43f3b6ec32@tencent.com> <aQRIOMsAkDciWFw/@yjaykim-PowerEdge-T330>
In-Reply-To: <aQRIOMsAkDciWFw/@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 31 Oct 2025 15:11:13 +0800
X-Gm-Features: AWmQ_bkR65N4sXjn4E7jF7ZR-b0DRabhpr_6ttycSokgao5UgLF3qlUaZW0wRPk
Message-ID: <CAMgjq7A2gs+CMRftP9r4Pt=GKDAO=NaZVuKFYBVkZZjgz8c96g@mail.gmail.com>
Subject: Re: [PATCH 10/19] mm, swap: consolidate cluster reclaim and check logic
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: a8bguwa31ercy35socwtzi6w6jc5oe8h
X-Rspam-User: 
X-Rspamd-Queue-Id: 9745C4000C
X-HE-Tag: 1761894711-930192
X-HE-Meta: U2FsdGVkX1/31NgfRgYIBAGDPkUst92TLcGoES9as+FzcXfXe2I+5ixKc0xN3lbv7VCAlNQvz2nJmdQvuvQuE90rVzTerGzWJDJkYcpuYpu/WxZ5wEywx7+K3KcrxGbHNPOiz2UGNHmyKg7S8JG5HTv/uDv35HsEP1jpJWBZIM9xV3WQ88zyc5KJpKPpS4aJOF/ngSd7Dqt/U4uGeQUMVUtHapRuD3oEppYMd8k9dUcplmWIT39SHP3m2sorz0DPzotz3afxXti1PkW7qbemkk4dbeDotXuzoiUMjkXR4vGWD9v0xNOAwPsN5nSOguooSVVEQgkInT12lfGKKKtp5A1Hz8EQ4qMWXIxp/MfOI9HYF7ey2UcWFQORlB+pW/wIlb0hxPVNLPm0BS1+kV/zyAbYZs5gQS7PC71k3jX8dS5/YEp4ZXQPAUf1z3vL+CCF0tIUhyFSSakKYl4VYmN55257tc+Cgf9AsYaFfferWG2vZTBG+JbG44mW+379c1AnXyo1kbcc9IwKNO/BNfc25lCVI+IgUc45o4YbBSo32LjBUz+ENO8h1Q9cqdTyvRejtve9301/Zusa6IWEa/wKwqTogAXqK37nBIKzRIzk4wFcDadSxF4Dkr1851c36xm31LPrrah+hdogjX94+kFVai+xb7cvOcFduOaXVfWdgTcEcZnGkLb2jJGBCzOGYX4hACPyHJbiGU0dSw1mglWmcC4joLrKFTEZmZwqpc7np5xEPKMg2ny6lUVzcf9oCynmmmYhz+/obNoYWiWAvh9LdFZWRCGFj2Reot70deD/If7kh6Y2YWnVrCWseZ8+bCcxGLlvXLtxHyo2kaSCwV4U0RnequJWIjQA4q5RhkBHzZhYo4FXyKl0FUdSyI2/hBtsLecd2ek6PB1gL5fH3qk8OShLQUC6l2zpuRkwfrmLfzpgXYN7o20OK+qba7KlZZ90wHuqMXU5OAq4RxkggYW
 XaZLaaeJ
 ouSryPvhvwqrw358tmqHIzVD3h7qp75ReECvXPGU3A/smE33NBBb67LXAKx5Ncg4d8kygmweqenD9LcZo5dUwQkbOHKtqZbNfRhRz55Mi9Bt0CcK2LdizIWuH4UAOZsdO4sbmXjuLquMEsV7J+M3P0iJ8lYI+51DmZG/NwIxbWaxlHVeZBEBrKIgwt3usSQLKKGaBuK7vlbQy1YYsLcCgBttOgPEttXQvQ6ebMJOc+1ygxnU0K8+qcZgl4lDDBpxrI5/PkJ7JsiCnXNLTRbWeecG7b7arpL3bGPjCFJ5QhHbK684kXyYVHEpcXkDPyn3KvMMTU5qfHxPlHTdBo1D/e3M+mVkUQ+SEmj/3mWpjE3UgBmT4uxs33J+Ryp6W0F1eJxf40S+ccz/yLRJMIaXq6P1m6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 1:25=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Wed, Oct 29, 2025 at 11:58:36PM +0800, Kairui Song wrote:
>
> > From: Kairui Song <kasong@tencent.com>
> >
>
> Hello Kairu, great work on your patchwork. :)
> > Swap cluster cache reclaim requires releasing the lock, so some extra
> > checks are needed after the reclaim. To prepare for checking swap cache
> > using the swap table directly, consolidate the swap cluster reclaim and
> > check the logic.
> >
> > Also, adjust it very slightly. By moving the cluster empty and usable
> > check into the reclaim helper, it will avoid a redundant scan of the
> > slots if the cluster is empty.
>
> This is Change 1
>
> > And always scan the whole region during reclaim, don't skip slots
> > covered by a reclaimed folio. Because the reclaim is lockless, it's
> > possible that new cache lands at any time. And for allocation, we want
> > all caches to be reclaimed to avoid fragmentation. And besides, if the
> > scan offset is not aligned with the size of the reclaimed folio, we are
> > skipping some existing caches.
>
> This is Change 2
>
> > There should be no observable behavior change, which might slightly
> > improve the fragmentation issue or performance.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swapfile.c | 47 +++++++++++++++++++++++------------------------
> >  1 file changed, 23 insertions(+), 24 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index d66141f1c452..e4c521528817 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -778,42 +778,50 @@ static int swap_cluster_setup_bad_slot(struct swa=
p_cluster_info *cluster_info,
> >       return 0;
> >  }
> >
> > -static bool cluster_reclaim_range(struct swap_info_struct *si,
> > -                               struct swap_cluster_info *ci,
> > -                               unsigned long start, unsigned long end)
> > +static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
> > +                                       struct swap_cluster_info *ci,
> > +                                       unsigned long start, unsigned i=
nt order)
> >  {
> > +     unsigned int nr_pages =3D 1 << order;
> > +     unsigned long offset =3D start, end =3D start + nr_pages;
> >       unsigned char *map =3D si->swap_map;
> > -     unsigned long offset =3D start;
> >       int nr_reclaim;
> >
> >       spin_unlock(&ci->lock);
> >       do {
> >               switch (READ_ONCE(map[offset])) {
> >               case 0:
> > -                     offset++;
> >                       break;
> >               case SWAP_HAS_CACHE:
> >                       nr_reclaim =3D __try_to_reclaim_swap(si, offset, =
TTRS_ANYWAY);
> > -                     if (nr_reclaim > 0)
> > -                             offset +=3D nr_reclaim;
> > -                     else
> > +                     if (nr_reclaim < 0)
> >                               goto out;
> >                       break;
> >               default:
> >                       goto out;
> >               }
> > -     } while (offset < end);
> > +     } while (++offset < end);
>
> Change 2
>
> >  out:
> >       spin_lock(&ci->lock);
> > +
> > +     /*
> > +      * We just dropped ci->lock so cluster could be used by another
> > +      * order or got freed, check if it's still usable or empty.
> > +      */
> > +     if (!cluster_is_usable(ci, order))
> > +             return SWAP_ENTRY_INVALID;
> > +     if (cluster_is_empty(ci))
> > +             return cluster_offset(si, ci);
> > +
>
> Change 1
>
> >       /*
> >        * Recheck the range no matter reclaim succeeded or not, the slot
> >        * could have been be freed while we are not holding the lock.
> >        */
> >       for (offset =3D start; offset < end; offset++)
> >               if (READ_ONCE(map[offset]))
> > -                     return false;
> > +                     return SWAP_ENTRY_INVALID;
> >
> > -     return true;
> > +     return start;
> >  }
> >
> >  static bool cluster_scan_range(struct swap_info_struct *si,
> > @@ -901,7 +909,7 @@ static unsigned int alloc_swap_scan_cluster(struct =
swap_info_struct *si,
> >       unsigned long start =3D ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
> >       unsigned long end =3D min(start + SWAPFILE_CLUSTER, si->max);
> >       unsigned int nr_pages =3D 1 << order;
> > -     bool need_reclaim, ret;
> > +     bool need_reclaim;
> >
> >       lockdep_assert_held(&ci->lock);
> >
> > @@ -913,20 +921,11 @@ static unsigned int alloc_swap_scan_cluster(struc=
t swap_info_struct *si,
> >               if (!cluster_scan_range(si, ci, offset, nr_pages, &need_r=
eclaim))
> >                       continue;
> >               if (need_reclaim) {
> > -                     ret =3D cluster_reclaim_range(si, ci, offset, off=
set + nr_pages);
> > -                     /*
> > -                      * Reclaim drops ci->lock and cluster could be us=
ed
> > -                      * by another order. Not checking flag as off-lis=
t
> > -                      * cluster has no flag set, and change of list
> > -                      * won't cause fragmentation.
> > -                      */
> > -                     if (!cluster_is_usable(ci, order))
> > -                             goto out;
> > -                     if (cluster_is_empty(ci))
> > -                             offset =3D start;
> > +                     found =3D cluster_reclaim_range(si, ci, offset, o=
rder);
> >                       /* Reclaim failed but cluster is usable, try next=
 */
> > -                     if (!ret)
>
> Part of Change 1 (apply return value change)
>
> As I understand Change 1 just remove redudant checking.
> But, I think another part changed also.
> (maybe I don't fully understand comment or something)
>
> cluster_reclaim_range can return SWAP_ENTRY_INVALID
> if the cluster becomes unusable for the requested order.
> (!cluster_is_usable return SWAP_ENTRY_INVALID)
> And it continues loop to the next offset for reclaim try.
> Is this the intended behavior?

Thanks for the very careful review! I should keep the
cluster_is_usable check or abort in other ways to avoid touching an
unusable cluster, will fix it.

