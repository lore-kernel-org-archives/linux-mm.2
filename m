Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB15C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 00:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE576B009F; Mon,  6 Jul 2026 20:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F626B00A0; Mon,  6 Jul 2026 20:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720896B00A1; Mon,  6 Jul 2026 20:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAD86B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:53:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E05DA028C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:53:39 +0000 (UTC)
X-FDA: 84960157758.16.B7ABCFD
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 976F040006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:53:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BwCGp3Tn;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783385617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kn8ldbItk8xyKpMbvXRjP6pkMHLBNAC0H9NfPdYGmn8=;
	b=ZYB/lLWBjebrwgxT8N1xhETnTGBr9vW9fMPlHxZglxD3too/nWIogaxGB/JXO+wiTBFh4c
	zemXdLIrerplf4E19UQpI4OyQUydC3ADhfkQgYyrDso4NtZMP+XtUOkoPU7MsC+6f6YSOa
	qEqi76DzYhJlzwt/0cIv9sJ3cgmDA7U=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BwCGp3Tn;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783385617;
	b=A3ovY8q81Oi0JIpsJDQWqzvLlTQVTd4GJ6w2pC7FJH/uR4zX2sZ+dHhytlyF1hkls/Aa49
	28T25XaB1KIYXHz20hGYHQ0fWwlo5N9p3VlRxPw+IhARzjqTkHecL4YJV9fRJaJCVJ7pqx
	/z1orboHaPbRhYpmV3WnHEw9bT4XW9c=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-39b0c6488e6so40116601fa.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 17:53:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783385616; cv=none;
        d=google.com; s=arc-20260327;
        b=MaSF/YmNVUc+UCX5fL9e3absbNWrd7tEwpCAbpf+rFtqKGHJJAA+A0n7zPMq/q5Ceq
         gT55iS+8Z/nfxV9IrQVOQN/8VaTZ1Wg9uO1rDbCXbxoYuFcxnTLjryFhlJypguOSi/S3
         CtaT8GMY31aiQzN7ZEi/xzNnauCTAI/ekEJcyBrHCmnT3OtTA74eOnfVySCf62/SUum8
         N346+FLkBY/1ychDYF2x2ZqRoyZ871rKu1i2E3A+GhB5/kMXpUN8qYOUhz6HdAam/rja
         brYEWK5cZ1S8V9OBWjRleHZ09Ur206wdWB8F/1GdOu1n7C4cWsG2vkYY68rIzynh+Gaq
         atYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kn8ldbItk8xyKpMbvXRjP6pkMHLBNAC0H9NfPdYGmn8=;
        fh=jqgspvK0gmXuk8DaBHpd0nNSJuf3n5gT7TpTECd09mQ=;
        b=r7sG3f7Wi7rUJ7gh/6eQorLLTQ4LBU3XbTr4oSKwUMgBHHaboRjJi2IcQNoNV9NRct
         vCfRaOZwYWG+uIqIYnfOjFA8xORw+HunuFGdhIV1Iy2nVrm1x2e8yNPY4a6H69D2wMMt
         vXBw2kDTuDJT0wIoSBF4mvqREYzijU8wdIOQg/z6ith95WGt8Uf6vGiDOxhm8nqIhusW
         iPgdLoaeWfRoN+aJtCjsvticcd3kMnl68/KGMYGhKoXbvKqD4AevoO11GT7r7KHd/2Qs
         ecwNX26rd4IdurtqocqGGUjriCt+DAigt0onfpWP8YiRpartUVuI1oEBA0zYOfUOEqSk
         p1VA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783385616; x=1783990416; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kn8ldbItk8xyKpMbvXRjP6pkMHLBNAC0H9NfPdYGmn8=;
        b=BwCGp3Tn9CbDQkda5QlR/rkX5Icdd+sXc8sp9ftUv2Uj5Ku/vOZXwE+3EgDzAEcUbi
         I1fHToEci0/WzHlIS93H/cvF8qhOdHj4pe686asRA44Tm9WDA4ya8e85Fv5ZU9wSupI2
         Ti5LFuxdZBt/n2UeGJOpC7dg/4u+Syh4Xc5z0hr0vXusDslbF4nZ/NJuhjY0ql9TJOoA
         xFID9V5BOnHdEZ5YLR4QimTEzRNDMTLIb2M/4epQu0Fp70r6kjDtnqmzGHoi0FEXNVT3
         Er3RyCJT21tLygrr0R40ECnAO0SCIP/M5dszAiobWfG3NkmYWfJ14pSwTC73xNe9qJyA
         AmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783385616; x=1783990416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kn8ldbItk8xyKpMbvXRjP6pkMHLBNAC0H9NfPdYGmn8=;
        b=PCz/QZiQnzadtyjKUxz+cRCc+r6hvwiAe6Eqlvjgnp2b/NCFhssEGegRLV5jWlCp8o
         b5BObY4WPq6NhtHTUKABgskg9F9wfikLc3w60vMYKM1VeJivMHSj9Efy6s19BHySFnu3
         faKCYGmMry8NNJRgoSAiUmf8qQW4UzzUWYynUBeTve0shCPV/xQ5JQYemzDSwcKoZhRA
         a+PnSLzxOT/VsdfXHyR1L4pC8C3Erx9RFKNGzgNxtbr+FgJ6s9IUY1gGyFqbpovpGXFx
         CQnjNGfHrcg3R8cpBlbZmglMefj8vY+kF9lGoQJCJV7He/I/r2gFeeiqHHQRiUW+5159
         dzNQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq69L2/LaHhBcUgs6hx3SGKNDS9UfbW/28kU1t9BnW/lFGupdkxh7HHTjEhyiVykuiq299PAw1mfQ==@kvack.org
X-Gm-Message-State: AOJu0YzUQJPaZp3Mg0K1tjpQdTzYtPYbdMUsKBry0B7qN7Dz54v1arvF
	1k17H/qvCncdi1nUm5EYih6r9IphRb5xYI/x14Ct5nxOmDKWwkc7bDNi1GTNPoimher6vPY/NUB
	oeMfpe6/cHVHYfFGWrVay3C0H4i1X49c=
X-Gm-Gg: AfdE7cm9+CNlJ9M8/Uyhx/Mib1CYUY/YFDxMZwSHtaMXfCZJE1DLQhFH74db0qabdxZ
	iPCZ6s8KVPOyw9dDOYSY8WNLSQ19/GahyM/BwTCs1se1+3yxnjvopd72kd4kcncDPrNpWbZmJ4G
	9GqAO5fADB/MGrD8vD5BHtph6mobmdTLQPsdAraFOQDXCxQKlquV6z4Awyeckoyfty2iuGdR6Eu
	wYtyZ0ids2GIEZyAHWckYRt1ueUWrCps5nUGnnpLkXMVdEFfgwB68+Jsd/VhVe9MgUaR/1OV49X
	h8UKoIOaM/RPIGtuyD6bFh6YTQ==
X-Received: by 2002:ac2:4946:0:b0:5ae:b6b4:f20f with SMTP id
 2adb3069b0e04-5b007bb0853mr433464e87.53.1783385615562; Mon, 06 Jul 2026
 17:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
 <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-1-a028e8b5fc3d@gmail.com> <CAMgjq7DeWvBszNt0sHcCOft3A48LVJTxLu70F_Ka7=sjii2M8A@mail.gmail.com>
In-Reply-To: <CAMgjq7DeWvBszNt0sHcCOft3A48LVJTxLu70F_Ka7=sjii2M8A@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 7 Jul 2026 08:53:22 +0800
X-Gm-Features: AVVi8Ccjg0Brjkiol6TCwlQC-QFzVy2rNdaaijBQxdxg-4n2Dgi1RvNR2sGYUp0
Message-ID: <CAJxJ_jhL=kdbrqFmZdosXqjgF6Wp4DQRPVj33BOpVWt5=9Qn0w@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm/swap: colocate page-cluster sysctl with swap readahead
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 976F040006
X-Stat-Signature: qe9czq6toyba4p19tyawgba66kt9xxqn
X-Rspam-User: 
X-HE-Tag: 1783385617-435744
X-HE-Meta: U2FsdGVkX18HWW+SDSTMhLmThqiQVxRTO7NazxJCDwtFwEXcDlvfXv0XR80dtjN5lyJjUoHsrmPxciXpJ0U6z+5PjQNZSMQpiN9V0d6tOxJ3rjOgMN7Nhvd+KiSoAFMnxx8LQndhlm1pY+3aZzwD+nvKqbV2AsyMvgav/tH5wVhCWXJA4mNWjF88PA/6F1oikEOnYSPo8rvhzuZ5pViZ2e5horYbRmg6owVN15YjChWpv8iP3PuvqJWYWUuv4Ng/9SkMRhHVceruwwSyxb3zVOF1K30xeO7+a9FzHO7aGC+jUhSrbOjp1wmC51LiQGEKddMuyK2VhJ2GCJTZAT28WTpfJ+rcDEBCBZfj9R66GHqqJvTYnC904YhB8A5Lx2hri1IQOiNnIAtQN0EQ4wNFTMXbPyuX2LSUHWExDUP1Y9zu6S+qPs3n/TE2bIp1Wqe74q8GRv43dHIG9uVN79OdCrw4TM2elXktsHCXSw6I2UaV6GcehFXUMucWPnxBu7mjCYGXuP9kWkcxYTdn716wuAUONgP/OyvgWvEuqzrkNQdb5zJ1UTs4LvNfxGQMv6nBWZeiY3a0rHw3oDbdwn2CT+/fCQiBowT0flOEwdwudQ7L5YBZ5NaD2R3JVU4/i4HKLLibCdV7/UeQ1NOAVkUu5ExT3r/SrGQNec5Ma8QAO6G+OCQCDh82tADKvI4L8mqOYCObjaNkWHoy4coe6ATHcPaoqQ/Tth2UDT/iuC+38tSAFcJrRcaZYBEkBk25Jk8JoyhXWJc3ee7HC3SDgvJLZHY7ETW8PJRaXyRz33miROPglDTs5IGSilMoKKJIJkbv/oLHm1aEBUPnCq34TOMtSpeZAvaOxbUDNGG0uwKG33N/sbUBZ2e6QhVM1EbB/RVPefI5kNxU3v44RaEqoO7EBYSs+y5WV/YxTz1LHAqpqpApsDruWtQNaEaGni1NkovXDnNVPJmBPA3yOjvf2zZ
 dhVbYIhP
 QS/XTzckiYdeCW8RKmN/W2WCga064fdTSzKVDaypUgmEgun9aaAqRNtA20l5XDxmVvsbDvctEFfMBe5jvUwlZv0h21zo+0qBCMtv5yHeaCq6L4MlETq0SbqWFUy1s7KgRSlcrgj1FvDPm+P+Qv0fs7A/CHoDQUJumvlBkhfGNpbDK0UBlV45gfBB012GeUFoBvZAScQr2KdCkaL+w5igdrK4jcaYNPXX5ECJmb0lqAZlPcxYUO2nSY8jztZVQuWSPccYEPf8vuIk3DyukRS4cg1fsJTENB/msggues6str6AuoVZrLhmWOcQ4Y8XEf9NjDSPr45NrXUqnecWZd9CPmK5YnFvEE0x9aVWmOaoJ1r8mJcPYXUbawJWIdBNT76rMaC8swC+CCyLezYBRaKgko8qUO7AdU/G2NzqhVKA3yDh/jx0NqyrkU00qSe5MTEGcSXU2Bxozzqr6DQQGFA8FXm2h+pmQ4D4j/VrvTKQlNnJxw0SroO/EC1VOkVsVmZUXmKvAWBBHy3XemJ0cygLfAXwfXdJEeJsrNs6n5n1v9CsYtCw/y2MOKFeSuyz88utUrsN1oQRCxZQRwZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 1:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Sun, Jul 5, 2026 at 10:14=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.co=
m> wrote:
> >
> > page_cluster and the vm.page-cluster sysctl are only used by swap-in
> > readahead in swap_state.c. Move them out of swap.c together with
> > swap_readahead_setup(), and make page_cluster static to that file.
> >
> > Rename swap_setup() while moving it as well. The helper is internal to
> > MM and now only sets up swap readahead defaults and its sysctl hook, so
> > the more specific name matches its reduced scope.
> >
> > swap_setup() previously lived in mm/swap.c, which is built
> > unconditionally, so the vm.page-cluster sysctl was registered also on
> > CONFIG_SWAP=3Dn kernels. swap_readahead_setup() is now a no-op stub whe=
n
> > CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered
> > there. The knob only tunes swap-in readahead and had no effect without
> > swap.
> >
> > Suggested-by: Baoquan He <bhe@redhat.com>
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> > ---
> >  include/linux/swap.h |  1 -
> >  mm/swap.c            | 36 ------------------------------------
> >  mm/swap.h            |  9 +++++++--
> >  mm/swap_state.c      | 37 +++++++++++++++++++++++++++++++++++++
> >  mm/vmscan.c          |  2 +-
> >  5 files changed, 45 insertions(+), 40 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 3f31b6a56788..45656ca9792d 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -340,7 +340,6 @@ extern void lru_add_drain_cpu_zone(struct zone *zon=
e);
> >  extern void lru_add_drain_all(void);
> >  void folio_deactivate(struct folio *folio);
> >  void folio_mark_lazyfree(struct folio *folio);
> > -extern void swap_setup(void);
> >
> >  /* linux/mm/vmscan.c */
> >  extern unsigned long zone_reclaimable_pages(struct zone *zone);
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 58e4eff698cc..b3ea30edbaad 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -43,10 +43,6 @@
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/pagemap.h>
> >
> > -/* How many pages do we try to swap or page in/out together? As a powe=
r of 2 */
> > -int page_cluster;
> > -static const int page_cluster_max =3D 31;
> > -
> >  struct cpu_fbatches {
> >         /*
> >          * The following folio batches are grouped together because the=
y are protected
> > @@ -1176,35 +1172,3 @@ void lru_reparent_memcg(struct mem_cgroup *memcg=
, struct mem_cgroup *parent, int
> >                 lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, n=
id);
> >  }
> >  #endif
> > -
> > -static const struct ctl_table swap_sysctl_table[] =3D {
> > -       {
> > -               .procname       =3D "page-cluster",
> > -               .data           =3D &page_cluster,
> > -               .maxlen         =3D sizeof(int),
> > -               .mode           =3D 0644,
> > -               .proc_handler   =3D proc_dointvec_minmax,
> > -               .extra1         =3D SYSCTL_ZERO,
> > -               .extra2         =3D (void *)&page_cluster_max,
> > -       }
> > -};
> > -
> > -/*
> > - * Perform any setup for the swap system
> > - */
> > -void __init swap_setup(void)
> > -{
> > -       unsigned long megs =3D PAGES_TO_MB(totalram_pages());
> > -
> > -       /* Use a smaller cluster for small-memory machines */
> > -       if (megs < 16)
> > -               page_cluster =3D 2;
> > -       else
> > -               page_cluster =3D 3;
> > -       /*
> > -        * Right now other parts of the system means that we
> > -        * _really_ don't want to cluster much more
> > -        */
> > -
> > -       register_sysctl_init("vm", swap_sysctl_table);
> > -}
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 44ab8e1e595b..624ea8ff3d0d 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -8,8 +8,6 @@ struct mempolicy;
> >  struct swap_iocb;
> >  struct swap_memcg_table;
> >
> > -extern int page_cluster;
> > -
> >  #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
> >  #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
> >  #elif defined(MAX_PHYSMEM_BITS)
> > @@ -79,6 +77,8 @@ enum swap_cluster_flags {
> >  };
> >
> >  #ifdef CONFIG_SWAP
> > +void swap_readahead_setup(void);
> > +
> >  #include <linux/swapops.h> /* for swp_offset */
> >  #include <linux/blk_types.h> /* for bio_end_io_t */
> >
> > @@ -336,6 +336,11 @@ static inline unsigned int folio_swap_flags(struct=
 folio *folio)
> >
> >  #else /* CONFIG_SWAP */
> >  struct swap_iocb;
> > +
> > +static inline void swap_readahead_setup(void)
> > +{
> > +}
> > +
> >  static inline struct swap_cluster_info *swap_cluster_lock(
> >         struct swap_info_struct *si, pgoff_t offset, bool irq)
> >  {
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 6fd6e3415b71..a9f5b944172b 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -22,10 +22,15 @@
> >  #include <linux/vmalloc.h>
> >  #include <linux/huge_mm.h>
> >  #include <linux/shmem_fs.h>
> > +#include <linux/sysctl.h>
> >  #include "internal.h"
> >  #include "swap_table.h"
> >  #include "swap.h"
> >
> > +/* Swap readahead cluster size, as a power of 2 pages. */
> > +static int page_cluster;
> > +static const int page_cluster_max =3D 31;
> > +
> >  /*
> >   * swapper_space is a fiction, retained to simplify the path through
> >   * vmscan's shrink_folio_list.
> > @@ -985,6 +990,38 @@ struct folio *swapin_readahead(swp_entry_t entry, =
gfp_t gfp_mask,
> >         return folio;
> >  }
> >
> > +static const struct ctl_table swap_readahead_sysctl_table[] =3D {
> > +       {
> > +               .procname       =3D "page-cluster",
> > +               .data           =3D &page_cluster,
> > +               .maxlen         =3D sizeof(int),
> > +               .mode           =3D 0644,
> > +               .proc_handler   =3D proc_dointvec_minmax,
> > +               .extra1         =3D SYSCTL_ZERO,
> > +               .extra2         =3D (void *)&page_cluster_max,
> > +       }
> > +};
> > +
> > +/**
> > + * swap_readahead_setup - defaults and sysctl for swap cache readahead=
 clustering
> > + */
> > +void __init swap_readahead_setup(void)
> > +{
> > +       unsigned long megs =3D PAGES_TO_MB(totalram_pages());
> > +
> > +       /* Use a smaller cluster for small-memory machines */
> > +       if (megs < 16)
> > +               page_cluster =3D 2;
> > +       else
> > +               page_cluster =3D 3;
> > +       /*
> > +        * Right now other parts of the system means that we
> > +        * _really_ don't want to cluster much more
> > +        */
> > +
> > +       register_sysctl_init("vm", swap_readahead_sysctl_table);
> > +}
> > +
>
> Thanks, I also think they belong here.
>
> >  #ifdef CONFIG_SYSFS
> >  static ssize_t vma_ra_enabled_show(struct kobject *kobj,
> >                                      struct kobj_attribute *attr, char =
*buf)
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f40cfe9d703b..ae710027d546 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7646,7 +7646,7 @@ static int __init kswapd_init(void)
> >  {
> >         int nid;
> >
> > -       swap_setup();
> > +       swap_readahead_setup();
>
> There is already a subsys_initcall(swap_init); in swap_state.c so
> perhaps calling this in that init function is even cleaner. And that
> init hook runs earlier than kswapd init so totally fine I think.
>
> Reviewed-by: Kairui Song <kasong@tencent.com>

Hi Kairui,

Thanks for the review. That sounds cleaner to me as well: the readahead
default and sysctl setup should stay with swap_state.c initialization.

I'll move swap_readahead_setup() into swap_init() and send an updated
version after testing.

Best regards,
Jianyue

