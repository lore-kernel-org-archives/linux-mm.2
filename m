Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822DCFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 18:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7946B0005; Tue, 28 Apr 2026 14:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A776A6B008A; Tue, 28 Apr 2026 14:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9677D6B008C; Tue, 28 Apr 2026 14:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 844C16B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:46:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29BD51A0338
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:46:56 +0000 (UTC)
X-FDA: 84708846432.04.3B358C4
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1B79AC0002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:46:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WeHRpyzS;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777402014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKFG0RDVEK246wBeg1IKZgBSUBwwFpLrZPo+iyiQ1R0=;
	b=ocXWopA4JOivjV12DYVUMu1+emk+r0OXI8HhYWU+t8q1WCrsQbhkexUs/V2SD7kNOfTl/F
	nPqqKLg3ixDcrQXbiF+838fc5Fh1N1oDbXSluOmI8VncVLxKjEpp58MvtpXeYnJwlRWepv
	VBZOjrjdcVVxB8yADcA4/3eQNOjG0dg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WeHRpyzS;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777402014; a=rsa-sha256;
	cv=pass;
	b=E6tefHrkJ9AJp6nIR+ZetPvIabkfYElECXrGnyeOU874ss8WjWd5qw+7dfGmSyLSqbKN9s
	FCxCYT57mqgHNvAs6/oKkDm1CLKqn927HMmiLQDJ09RIu7DeRseIkrliiPSa5xnI7Ecn6Q
	B//b60MCU7CwrrmFHBF5FZU/BAKzna4=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-676d8582a13so13991104a12.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:46:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777402012; cv=none;
        d=google.com; s=arc-20240605;
        b=fYPYkQ2H1WKtZAh2LfGV7dadr6UCtiLxUPjcb73z49jAzaP2g98rdLcGi/rXOYF+6a
         yfc1brZAH7tQbG1H3Gf0xXqYgywzalx8lNLfsMRaHmSGZmsb0QdEbjYmqoa9d52TfLiv
         ZRdOxGiKxM9BnSe8teU5eqUg+nwozVVvlPcT61D6CPQSzdT6O/iTGxKr7PmtonPCWtAk
         WbsAfvZqqPlVzz3sC7/Xo5PY9GdbvztwYS/T+146dfdBiIQORzRQ39rdru4pn/qPkY0+
         gNMsQD3axQfLdJzJTzzcLHci/1noGEIoWl+qj70RSiPYUMRnj/F+J5nezZy5ceMSEY8C
         M8UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EKFG0RDVEK246wBeg1IKZgBSUBwwFpLrZPo+iyiQ1R0=;
        fh=E/jhjyCva5BHUBhx4nAEH3Wnlh6YH6CFldPSK6ZFZr4=;
        b=djFV/sLz5ev4nh3lcmBmTTlrNcMjMF4QIwRxUPKSk8OfTv9JhSQB6Vlk7xpzJRneY9
         ZoXTrvFrPBdfvFUQ7fi3mJmagQbkqhzwTySpz568rf1sqav+BydvPO+f/SIAbOfq0yRU
         X3teW4SL2qEs3FTCwJfccR2PfNlQDoH9DP46OeH96/l7Q2gOD9kJn6AWkoowJUBnB5nO
         JwdMTGHMmlFGWG/Cp/NW8GQAEGOic9opkdyIxWlWbq2WqNvlFJ5lHi19v3rQq6sUQaKq
         6D8yvUtO3Wu6pBxojBonTKOCU6h6MYEXTcbeboD66W37gUlSTzuPTLaKvzKwt7ud3zP8
         QslA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777402012; x=1778006812; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKFG0RDVEK246wBeg1IKZgBSUBwwFpLrZPo+iyiQ1R0=;
        b=WeHRpyzSmqd3p95Osd+ha5tUnngCKYGNnL8pKVVVZOpieIpeYxAqu5qtaeAvqCCt8g
         VeZ8BnSGlbbh9QawfR/E6g/pQ9EFp1r9ANldSmPztmXIQxSM76+hALSbDgCVUeiaHRtf
         Tf5SVN8k3+tFcRRpi/oCw2ty19lGWGsRE5JO2NrUQs+JISpS4vyMpCic9lZHD24uGGUX
         VPm+2QEWSHUSUd/d3S9rRRQVZuGQLTy3G9o8iFoD27xQB7rFCaiYFZZgR2juAAmra6NC
         0ujBvvpfg9ggXf3Sf6dO2cL0coNM4MCc5B6tRoLsReubBCukVQTlQV0IXUHwMgo0aUVA
         ms0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777402012; x=1778006812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EKFG0RDVEK246wBeg1IKZgBSUBwwFpLrZPo+iyiQ1R0=;
        b=qOUcwEKmi5WFKm3wnvB8qi0S7zS1xxiHc5CCC1NeHP1HwVthoBGJgXQ07NnM8FaO8N
         DlG2EGhr7/y3O2xCCqCRr9ySsp6Cec7flmPHJJnASuzBca/aJ/Juk0pkz3U5tEwQSPXL
         6vOe7TTNqiJwsuvbShcIXjp5e5bcmrT5Vqevpo714vDdERCp1WAd60hvpKnk1BJbUtfO
         e5ur7fGM6a/f/fXEpHe2NBTUeRHkkrx1Y+HOerjAOgJ7LZkVTbYZPT+yykKYpXEoDC1N
         48QwlZZEb0+PWEDsNuxrSKax/71mPpLjYYx9W7I8oMbI+NeOb+FSj6FLnjXrRk+TYK9K
         0WLA==
X-Forwarded-Encrypted: i=1; AFNElJ9mVuri9X9kZg5/WljcRZkAkhTRKDHZhIT2DHTgVW38gO4L4AIMX0HKUYWbmJPeWtvBPQCMxEs+Ig==@kvack.org
X-Gm-Message-State: AOJu0Yy/z8/nQMxPYn8HGOzphUPGPwDPmOmtq8fiwl0AIgPnIZ0GF79n
	e+UCksFf4h9duyMjGn+384vROxmi1xfAQRyVycCbZlT2wp3hXJvch1YQDVnZcHSQTBRfgspAjzQ
	6Nj9U3TvwYnvRdwsjat5k7I5EjpRo6is=
X-Gm-Gg: AeBDietlGtGjageHUQDbJ9piF/zGEvnoXHfuVM+98Ar4cpiTJNCmTHLgZW2oOBJk+k+
	+6v38fIyuQgSn3UgY2T1tTHBck8XvJ0Q7Fd+5fGwTWYrtHmOHDYIjXWZyiM6CYIoPCjCnVHHdz8
	+4BCaweCwq5yxoquXFZDdDSF59QkucaxRHNW56KCq8XVyZe06Au6tjBR8B8KNtVcZM/86v9IHSj
	zc0dnb2Vvn5EmoY4utN5rSh2XfJxI569QRxpS/1/ya1TtYY9cuS1E3lWxOmUBTGcjSrT4UwShZg
	UlXxCdOBcLIV2J1pVUkwKidEpBvG+Pi1bQxG6U7cqdtYt4jG2q/1pU/pBNru2A==
X-Received: by 2002:a05:6402:4544:b0:671:a18b:32b8 with SMTP id
 4fb4d7f45d1cf-67b1fce62e4mr516715a12.0.1777402012124; Tue, 28 Apr 2026
 11:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
 <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
 <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com>
 <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com>
 <CAMgjq7A4+Sac9-CYkig1LFfEh5rq-4vLka8AXREei_m3svzJ7w@mail.gmail.com> <CAO9r8zMv6oYvqXti8dFfQd79Nd_Yge5g-EjjjhsEWj44gwJ-qQ@mail.gmail.com>
In-Reply-To: <CAO9r8zMv6oYvqXti8dFfQd79Nd_Yge5g-EjjjhsEWj44gwJ-qQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Apr 2026 02:46:15 +0800
X-Gm-Features: AVHnY4KwMPQSKOHLniO-vRRmC7fG6-z8dUk1aqr3V42lrdSb0J0CfA2hErWWeCU
Message-ID: <CAMgjq7BZpU5K1xHyFiqpsjeFe6CZUouGY_gOGMwbkM2Duq-vGg@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	akpm@linux-foundation.org, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
	Byungchul Park <byungchul@sk.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Lance Yang <lance.yang@linux.dev>, lenb@kernel.org, 
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Mariano Pache <npache@redhat.com>, Pavel Machek <pavel@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Suren Baghdasaryan <surenb@google.com>, tglx@kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yuanchu Xie <yuanchu@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Zi Yan <ziy@nvidia.com>, 
	Meta kernel team <kernel-team@meta.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B79AC0002
X-Stat-Signature: ujtfyj4ehwhuztz456bmyqo6ries6n95
X-HE-Tag: 1777402013-53409
X-HE-Meta: U2FsdGVkX1/8LYG/TVObFPcGDrHwnB3DPcQjn3bmbUYPCMaDzAb1g2XDEztAoWe5upTcol8oHvXqe/UYF+qpsnYWKQA3zySI2DWf1Yp2XsDsyJcQbjF6dxMAPAtZDY/0dplRkK+ItYJnnkq0aIqkgrLnrDJqzsgIa4IchIQuT0IzKaZcJ5pogiduuGzvf0Bkj5YA4suTo+8E6fPxPUV3ieoptuQIPx/WgvwgHyYOcLQ6B59fEXF3QYNlZhvYqhsGNCyVUgPHeYju7gArbVmP0DKPvV+3rXACpgqljCZ3hTpMkYgc+ImuAJL9o14PLNcjGoxfFdopp6Ij6n2LO1V0BiwNUR8mENRcIESqC6UcDP9bk54QWeBZ1XVwCSm+bAHwqVui4RSQMdDHIr36IXTO2zBHLREDX5EkK6h5kmKClGZXxdmiezSVB4uc4XT5aW/jbY1rMZIRhCGCNeNvvvE3+MZL0057vPjZP3D7luh9TKNYyn+PUG6idd/McC+ZGA7kMufM1bKYvBRrPKDCH+Cq9jyLUpuXQmEN9UVEdJEwXBojHgQHQJR7lFL5/cuiLNaSD6qfBHFOnV3HG6lyM8ddaKm1LNO6N0WNEfYOtViMLtnJrWr7nWQPYS7oBW0a6ZbrpVLMsEPRM0Y9sWuVwjHYJHsEAhqUEUcXhWAFbCRIjsBiqs77Q6Prvg3GnFuZ6Ma5CTn47yqeuzmTnuKbMnsEsVJAm70ZfK3bPGqi/Ou+OY3l3fry3WxU5Ku9/grnHIdqgyapekITuDWa+7byH6dk+3fxzHGWgH0Eu5jExgLXaiyCJvTgXAnjv4TgIrJI+eEmF0vzTRxLFdG/NTi9HRTTGkd8e1B2qd4vlYVrjYRPdyK75EDfUbnM6RtRQuLNZBbyx43FU3hvO5m+wRUBacs36WvddTHeiMP1+Q+7JFRZVWLg5Z0E0f8kPXE3+WHzooNVBnrqjrW36UZBTJhbazc
 p50xQiAX
 9xWLGJe+adE45KOqsfxweSvJsRCA0kg7pc835A+NRRYGzp3+myyUpURrACeAbLxrXgzY4LK2YPizzA7nxhpbjnt1JZhEOjPfrlxgWdWo0W7uaEoHSlX3R5cNVB1PFde2VENS4W9MSXD3s9e2FAQFuRyKpIYB9QRta/DIGE4MACiPhVg1W1RQjn59OX+Njip/CMJFx6ZyGOMHVv/Gan03OulA9hFEXJMM4u/QBFxde/DYeyXVKcm76DBTFVOSG/kQP7qB1bpzKhYB74oBdYy02HtsrchMrbJzzbNlvyhxh/N1/L/+IQhrOFrCQ+r+DyIG8xTALkWFeiQ2s1/bC+iN0cXXPU9asW/BpcJifNNwrDm+P8sQSjhi7YNiU8E+IjRMXih6/DBEde1lOm2V1jd064df1HiB9RrsiPuyZS5tCm4wmRBZYzTdiEPb4mb3ScCPkEl9Atl2Uek0VUXxreAKBo9JwERFT9QQbSFADVVUv1CrAm1eyga2dKX/tsSRAMhZZRTafbs4SdMBKpNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 2:23=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Apr 24, 2026 at 12:52=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > On Sat, Apr 25, 2026 at 3:12=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote
> > > Why >16 bytes? Do we need anything extra other than the reverse
> > > mapping? Also why do we need a double lookup?
> >
> > You will have to store at least the following info: memcg (2 bytes),
> > shadow (8 bytes), count (at least 1 bytes), and revert mapping (8
> > bytes, since you have to address a full virtual swap space). And some
> > type info is also needed. Part of them can be shrinked but still,
> > scientifically, merging two layers into one is considered a kind of
> > optimization.
> >
> > You need lookup the virtual layer, then the lower layer for many
> > decision making, is was discussed before to introduce more cache bit
> > or things like that and I think that is getting over complex, reminds
> > me of the slot cache or HAS_CACHE thing...:
> > https://lore.kernel.org/linux-mm/CAMgjq7DJrtE-jARik849kCufd0qNnZQs7C8fc=
yzVOKE14-O+Dw@mail.gmail.com/
>
> I think that's where the disconnect is. You are considering these two
> separate layers, each with its own metadata. The metadata should only
> live in one place.
>
> If we only have swap tables in the virtual swap layer (with the
> metadata), backends do not have to carry the metadata. In this case,
> backends should only have a reverse mapping (if needed), and some
> internal data structure (e.g. bitmaps) to track usage.

Ah, you are right. This is currently an intermediate state, that
problem might be gone if we unified everything.

> This is difficult to achieve if the virtual swap layer is optional,
> because then the metadata can live in different places. This is why I

But that's not difficult to achieve at all with an optional layer, and
actually will be achieved naturally without any design change with the
RFC I posted. Swap count / cgroup / shadow all stay in the top layer,
lower layer is "reverse map" only (the undone part though, it will
require to move the cluster cache from global to device level, which
is also required for YoungJun's tier or any functional tiering to
work, we may run into more and more detail issue like this).

Might even be easier that way, it's pretty close to the unified states I th=
ink.

