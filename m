Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E3CCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688B56B00A6; Wed, 13 May 2026 13:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660F86B00A8; Wed, 13 May 2026 13:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577806B00AA; Wed, 13 May 2026 13:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 484C46B00A6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:48:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD1891C0F80
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:48:02 +0000 (UTC)
X-FDA: 84763130004.23.A458E7B
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF3FCC000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:48:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kqbxmp7Q;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778694481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFQ+R+QRNZc2dL4tMIvV6mJSpqASOAKS6Pd7xj8Z6hk=;
	b=PQ4I+fUV3S1VTpxlLUJoSYUfGGqhh2rzuubhAOzR7GHzivawuYoEfdnVP1NJUyNVwD2pAV
	I9H3R97upuHohGxNI6esGeVpDSly8nr8b2yYnFtudMAVuNMx4QzezkT21Eal9PnBuGaGng
	lBvpZcIhno2w9+YJRIJxqk/d49eYLLw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778694481; a=rsa-sha256;
	cv=pass;
	b=gTKYKo2Ktulw2qEAI2ggoU+FSlePLNZXe4etzefRPwdA0w6Ugdc59Q8j2fyCugscOWa18Q
	8qztslxsIquBfmXGLzbjNh+o0rNzbircTMzBvNpqRTv3FTcAz7BUp1fnYWpdcKLIb/OKsy
	JpeqVnnsGkKADBRzq4GeO6fMpQ4oY6Q=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kqbxmp7Q;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67c4aaf76ecso587793a12.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 10:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778694479; cv=none;
        d=google.com; s=arc-20240605;
        b=gBmi5YMkLWKAe08eoOoy5JvofXboEggA1kAZqVai79n+GtO+6jPbluZcwwts0drIOf
         OlClMBMPb1G/3jhS8RUaWgDw408ENjcKW1ceRBbOb1L4URQamCNmS6KSuGlQh3Y4dJNN
         ONvxHOgcI6OkX2JPmjV8ekL+s9aya4PJBpfDbeOIkDZvscinSSRHRhamxw0+V87xeUDj
         EMxd+Qrz9qmSvvSYClDxYzeuiMg5Sgu5AZkcbEW7hj2dkHQEk6q7DVO4W+AI406rmYCw
         69M4o6F56JhtZkT789QPrMAFanwh6GcEZk6tyuY3S+weM9ScneyVuLaUozErqyGjKHyH
         NXGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kFQ+R+QRNZc2dL4tMIvV6mJSpqASOAKS6Pd7xj8Z6hk=;
        fh=HgvzTsTje9lnNmOaG67L9WazGxXHdaNiyuLClgLUnnw=;
        b=THE0aZZk2IkJEK32FGBPxG2jyWqVg1wmUVbz4sUCW4kN/Fc83uBXCGUysALxXYqMDx
         tcEQ4NGPQhKZiW6LfrPJ9BIDv9rkLtc28uKAKWFfV1TGZo0kkvgZojeT/psx2R3IGPfT
         kcxgXsGD2RRrbfK35TtvtTUNILmbI64N+/qtKt+jRjlrq97krh1wLae9SEWeo3oxsiYh
         dBnuv8N7+rsX2hnN0qi0IB54PeNDTtPyXOiFntvokN+HK7mY8kC+oQSoXGFI9gXFjQ1V
         DM5pUVtZmMJopo4ATn3yCFYShtdjtkEg8zohlrqhG0x33jNKoXqaNMtf2JkdeJIpGBA4
         GpPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778694479; x=1779299279; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFQ+R+QRNZc2dL4tMIvV6mJSpqASOAKS6Pd7xj8Z6hk=;
        b=kqbxmp7QlHW9RgUTZGcFJZinUrg3yXAN3X5NqvwoQY98ldRvh1XpyugeTEY4XpkdJv
         JdrrKU80mYlhnL76XKo7Sw0sIWKCobfB72G6cdvlk7JEe+vPwQ4hYfiEDKyZOgCV3zuj
         HUTiMVIO8/dvaFosPyBsxqPmdLJaFLUCApzLQwIgHrRXboIh+HXkZG5hSN2cId6MJu5m
         c50Ft28tUPPDE+XFT6f3TvLAJG4onTeZKiTvZ+4x2NusoFu9TgNnLbOqBEDrd7Ew7Elh
         TXmfbr/0dLO9LWzndUeM6iCfOmfsMwc0mSdR3qnWMepOu7NO9AH9PeYnmx2+GBSEGD6b
         5zow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778694479; x=1779299279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kFQ+R+QRNZc2dL4tMIvV6mJSpqASOAKS6Pd7xj8Z6hk=;
        b=WEsIfc1XqlIipo3ulx6SqkqbBS7JlD98ZvTw7fFafY6xZnrUco4iN/GU0FjPh8RUKx
         BtGych7r/L4NFQtoCbwCS/T58steiBoMT5FCVH7PSaJf1MkwcuAkpY4FpC/ez0bnco6R
         Jpn9+oG08/va9NJuB/QZoyJqFfeCcRAdHnPv7thnJJCJ8NYx70L3J8paOmZ54wkMxsi/
         wRIvm5SG4/9k96NRwmbzOErkV0QRvr10BTQBA+p5T+OKdZ8Mxf5cB/3gHTKiWJLcrgXC
         fmufJAesjGKVJRCzJeKaycWsmso7dlRJSOw6yUy59o7W28ZvLl9R9i3kAff637atQl90
         WAMQ==
X-Gm-Message-State: AOJu0Yy9XTZxmGdF/SxALS0FrB9BWjVbdSkbcYGSC2mU16f1R0GAtEdZ
	t4IdQ42g6P8kmgFrMA/cIRSVJNrrs941SrTj4hwYLG61bAODCstrEIf7LGLe9Qq9oeQU5Ibphqo
	sH0Em50CQ0qv/nO7F6OS3cfrB3tJxrVs=
X-Gm-Gg: Acq92OF6g1Z9nBDqMiRpfT/AFUuHceFPUJamIaymuA4VJABIN78izpvIOhRE6mL8/f8
	L53ZCgQR4Jl7n07/vqOVvUSBhVKo1sa+/uqdwKfy+G1vYaLiampTYwIKMXSSnXXdImblCUe73uJ
	80cMs2Nqsfy3UJMjFkQYNQEt7kbIumIAmTyNESBpu3X+InEqNSD/rGlQL2rt8MhUiR3H/AI/psQ
	M1tVfbqFAJVqfl1NFu5gAtgbZNboNWnzIy7TYz1nKaFTBrj1S3vM2c4u60OQDKEMfeK4Snox6mc
	cHNsG6afTJQB5yezzjpYBgvQUuuuuUJ6QEjAhu8u
X-Received: by 2002:a17:907:6d23:b0:bc4:f44f:e145 with SMTP id
 a640c23a62f3a-bd3dfb61d1emr269747266b.16.1778694478941; Wed, 13 May 2026
 10:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-12-2f23759a76bc@tencent.com> <CACePvbUSqkw+5MFFfvwWe9RUs4xUuAzzEkBYOcQ4eB6e7kNonQ@mail.gmail.com>
In-Reply-To: <CACePvbUSqkw+5MFFfvwWe9RUs4xUuAzzEkBYOcQ4eB6e7kNonQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 14 May 2026 01:47:21 +0800
X-Gm-Features: AVHnY4Icxwv_YCrITnlE3l5KbQwkwqxk4IPI9AHQl56N8wd0xj8GUUVymRN36mo
Message-ID: <CAMgjq7CfrFGNAsqc-Zjv+iGni2GADw-TkBeudaAe-+XVFJxpcg@mail.gmail.com>
Subject: Re: [PATCH v3 12/12] mm, swap: merge zeromap into swap table
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF3FCC000E
X-Rspam-User: 
X-Stat-Signature: euofge78kwkdp6wzjxh6zh1pxwe4r39a
X-HE-Tag: 1778694480-26551
X-HE-Meta: U2FsdGVkX19fEqCOBHXZCzZtT0/c85RywbaiQtMtiGzB/bzC2Bxsp+ghWALhmH8/cOVa25D0M8U4vpRwiI8NvrYS+V7V5q7vXWG02zyiW/CIv4aQ1qW2604a1bH65G0S2EyzgVi26UR7BFzZqt5Dgq/c2Bdp0jRuBVigyG1ToZyRyD1BbhGZlZ+50XtxDsmADFk3hgBIM4AOV3vAJ/GqkFj2ij3pHxRWKTmV5GLJug5xPyA7N2O2plNfPu5CV34lgr0qsTvVM+Plk4MjRrX+q3NOYuK/9vKZj9XRwmep4OWmb7A/kLRVqmjPF7qarec0X0tqgje1XGgCrKWsi9x55MCSjWWD8CQz3llnaIEVi4Cq1r2x8omgx+E0uHN+Pp3hY15U64t1TTY6I9XL47luGI8RyzNb3T29sctx70vJpvBr6Kd3G2UyjnGq7UooXhNarkQJkqHaj3vs13tlb8fmdSrt0l1VCbAHSPQMdHIAkLI1lh64Q4Tt8ddpQ0PmudDhsnevCKpHwFzc5gJmcbh5mL7NBdZv8QmzS+nD+H9gjY6X5+/XM4P3BDC3XlKiPeRlF+TIp3Mrvt6A6I6ch4WK2aBlQy9VP9eA83SlBEjTI8TidEGe8QzG83ybq9n+ozyR+RnRy3ojou9QCoEXUR/tBLz1D2AEyBbadpA4Es6EfuJv1Q4QeavXHfDigUlPW1oXBM7NgFXwgFGaVQfVJEweg5qvi0Nk5jwUkcuqgyX8kmYTB+bJmohLWfNlBvGixGYvRVw+c8AzTOLJcWTaUholmqjfVkXgAXkSxUpYCMGbYLMO4ioidJRBmeZGSNAVm9XdTRw7DPqqOnkEQfNv+LT2cDKrT7vYPRP2fv2dTJuST2GLX/MaAz+YdjGMlI9ICYbuvvOR7+Dtdw4MOpODzCs8h0AqzkQaQRihRZApDekuiOL5fpVNeijVFI5w+TVfAfE+lNP7+Uf0RcASnEv0da4
 CQYQmYn8
 HvRDV+xXArqcMKjyxGv6mTV3s37VavBvE+UmRN68ODUJCDN6g/RLuneX5LZutPKaWt1Lc/FNLCZmVeCLeU65TXu3JzUS3yLNrrlKe01olbH2glovIwQfWJSXI7hJ9JyiB4HZzRlzAr5Y7lZZ24RByedLcpLrRdXOZALA09cS9o1e+h0QgpiZudxyp2B2YtT0wg0Nlqae0iEZ+u3y/+gXVrxWiULMpOfx4VDat1ITV9xpwbnoJrms1Go9x4OQQQSxL1bGxJhFUCIMIzCzlov3PcP17Sd/zOnm6N0ZeqYv3IerB2Oac+HtVdnaIqW+w6nHuPsso9beyJljNIgBpdPu3OSUJVr7r+sRp/ixGuTbvna5nFDNZTwHMk8Hju4tCclY+L9jIv1WzhP1J9zhlSEzVWs1vY4usnctqvZAYh2oq3d6GZBHaUzxvS6IFEfyD9/YnnhJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 1:04=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > By allocating one additional bit in the swap table entry's flags field
> > alongside the count, we can store the zeromap inline
> >
> > For certain 32-bit archs, there might not be enough bits in the swap
> > table to contain both PFN and flags. Therefore, conditionally let each
> > cluster have a zeromap field at build time, and use that instead of the
> > swap table for these archs. A few macros were moved to different header=
s
> > for build time struct definition.
>
> It might be worthwhile to mention the user-visible impact. For 64 bit
> systems. The zeromap will store in the swap table, avoiding zeromap
> allocation. It reduces the allocated memory. That is the happy path.
> For certain 32-bit architectures, if the swapfile cluster is not fully
> used, it will use less memory for zeromap. The empty cluster does not
> allocate a zeromap. We still save memory. In the worst case, all
> cluster are fully populated. We will use memory similar to the
> previous zeromap implementation.

Will add this to commit message.

> > +/*
> > + * Return the count of contiguous swap entries that share the same
> > + * zeromap status as the starting entry. If is_zerop is not NULL,
> > + * it will return the zeromap status of the starting entry.
> > + *
> > + * Context: Caller must ensure the cluster containing the entries
> > + * that will be checked won't be freed.
> > + */
> > +static int swap_zeromap_batch(swp_entry_t entry, int max_nr,
> > +                             bool *is_zerop)
> > +{
> > +       bool is_zero;
> > +       struct swap_cluster_info *ci =3D __swap_entry_to_cluster(entry)=
;
> > +       unsigned int ci_start =3D swp_cluster_offset(entry), ci_off, ci=
_end;
> > +
> > +       ci_off =3D ci_start;
> > +       ci_end =3D ci_off + max_nr;
>
> Should we check ci_end less than the cluster's end and complain if not?

Currently, we only call this function for folio->swap with
folio_nr_pages as the max_nr, so this scenario should never occur, but
a sanity check is always good to have. It might be even better to
convert this whole function to work on a folio basis later, since a
locked swap cache folio has much better restraint on its swap entries.
This can be done later as a clean up.

>
> It seems using a for loop can be simpler. The loop index serves as a
> counter as well.
> Totally untested code:
>
> int i;
> rcu_read_lock();
> is_zero =3D __swap_table_test_zero(ci, ci_start);
> for (i =3D1; i < max_nr ; i++)
>        if  (is_zero !=3D  __swap_table_test_zero(ci, ci_start + i))
>                  break;
> rcu_read_unlock();
> if (is_zerop)
>      *is_zerop =3D is_zero;
> return i;
>

Thanks! Looks good, it's more compact indeed.

