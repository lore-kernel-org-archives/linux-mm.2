Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B120AFB44A2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4AD6B0005; Fri, 24 Apr 2026 00:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86436B008A; Fri, 24 Apr 2026 00:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DE76B008C; Fri, 24 Apr 2026 00:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF2336B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:26:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A0F81A0632
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:26:18 +0000 (UTC)
X-FDA: 84692162436.19.EEB758F
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5F82F40011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:26:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dudrc40m;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777004776; a=rsa-sha256;
	cv=pass;
	b=JDxZX7ec3wcS03VV5OLHKgjqEo1j48fTT7qFGakn1bw508M0H0PJozQyVI5zoi58IDwlkd
	ASeHyjRROVgblybY/BK7DzgIsAaviOferRpl9PalLrPTeJgxjWlM0n1Evnh5Sx78yOIhIb
	SZY3MyGCQLydWSnjcplQdfwDkLguiaA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dudrc40m;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777004776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ik1IXjkQGe/1mCxzMlkTq7jyLpXW+ghrJTKxgI9AJXU=;
	b=EM7Q+FgvpGFZjujPVSdg2wYmzn3sfkL/Btk9iuEpAWpge8OjETs4b2EoCXMor3K9Id+7x1
	PD1+Xwc1jQqzqtNDXopuJa0kCsLGre0QEZmBvguk3PHlAkv5g6vqaEVdMVJzZWM0ZWdPrS
	PmKV+u8EG6h4T/fWXzlq+bS6b664j1M=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-baa8c78ac7fso500565666b.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:26:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777004775; cv=none;
        d=google.com; s=arc-20240605;
        b=bh0BM3zhBQHt+Cl1f9it4DlItvDM1/vTpjiRbME7nk6VtiHiMOnTXpAEbqJxcAyPVB
         LELkPUfqXJ/15d9doar8fPr2aggbtkP26xu73L0wAc9HPLulT0A5EPjGGTLEu/xL/2JY
         JobkfIJCDtYxYSYhd6zuUtgRlwn6D+HwquX/rQmfEXDEbboVUFJZWncjaELaFmAOFFo7
         TKB6KKwwp4Qo4Dgofor2P0QMBJaTfYV8pdf8Tn/fvZBo6q0jvUOXs/cBB1AehBbvZagF
         4WksoPPmpEmfE+JXbJZrExcJPl/nuFR/SNRQ8DSBJr8nxecOzmBZKi4rDqmxUg9nKBf8
         6x8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ik1IXjkQGe/1mCxzMlkTq7jyLpXW+ghrJTKxgI9AJXU=;
        fh=e5f1hNEi7mVqeN5lm6KebqtscMkK0UiY9F/LI11NC2Q=;
        b=fcCwiu5JR60OgbJwbBHc/AHGHTkad/FeKTZ45lIqIkbDVbAc5RPQti5CHRg0L4xgN6
         ao3ooZl81jej/i9/Svt69IQ/uSeh+zATZ2NVUex+yG77EnyrodXSa5VtKq0wGulKHi6a
         BFlFBpGh6hrb5d383Bcucz+k0j3CVwALn/BFD734Pzl2ftHAmTK//N0tEOKt37sz1dgb
         vjTCQpGcAmV2f68srBrILQd6/fTUg8qNJBZP4OwcUuhg4KNKMrdB1TltXkfT6tuPog5o
         yI8ODANjJ8c9rDKbHE/HfL7Lxd+BGQQuIJTrsRX3EkX+8hTbsoF0CKRsMgUzOLlCdOGw
         6IkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777004775; x=1777609575; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ik1IXjkQGe/1mCxzMlkTq7jyLpXW+ghrJTKxgI9AJXU=;
        b=Dudrc40mp2sGWuT9z9VqvskL2n+PTwgFLasb/rCwMdImZnKfS22r/B+CnDgkljS5s2
         NA4zuf/KxaLwRzHhvmmR7guOVHdM1H3HraVyyHbeO54LCzfRwgMOedEHtPBnqUbrZiVZ
         dZ2VcBmdQgJy+IqIfEXkXVz6i+7gCnsy4sFNao3446gMGK4T7Q2yKiks3pD3ujyJAq9t
         izTo4Pe16Wk7fzav8PPDRUrls78n8yc0M0kcp/Qfsnh4XtOuPir8O0Tfio9FGbx/6vFr
         G73n9HRpVmBppHBU14hJt5NIMixwUWCVqPQu2IMV8oy8E/HAJwcDzEY7kUIfxRNMCy2m
         KRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777004775; x=1777609575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ik1IXjkQGe/1mCxzMlkTq7jyLpXW+ghrJTKxgI9AJXU=;
        b=BUwpM7VMEYekgpt6RMthxMtC2HIOgXdGTXlfBDhCOHRwe6z4wFT29jR0GRghuF39RB
         HBm02Bytefiyv5oeMGp2PbTR4uJCAMHgzzBSqAnWKgWOWHJH3TGoiwT+DRccsvlXve6b
         i9og0dE5aCKLyhZI3GtSNhFw791q76EA9xzWbXQhOuf+lfLUpy64OxfdPxYEg+2oO9hP
         vO5RjVW2q2eSuxCEfg4c8iCNIC63Az9ESD+aGyyQCv8YLmaoR+7bEz4tgkdA63LIJK/p
         I20mmVIriPLIryvwzPQXcoIisSzD+4PKhiPUXg5qBfV/LfHu4hkA1R7pvvVXQRRh+EOM
         Sbcw==
X-Forwarded-Encrypted: i=1; AFNElJ8LBbFIGh4jsjTdyd2D9SSfz/9c9Mh1bzTj5vVo5uYuXh0cKXo8FJoMRqf86o57onsP/zP1MaQT5Q==@kvack.org
X-Gm-Message-State: AOJu0YyfJFL6Ovw8mhlCfGTAnnXjrTiHg7FlqkI6FYl4Dck4rJ5jQPne
	+bUOlO9wMQf0tjwOsFSuyqKwwvRq7b07DQrF7sUA8hNFRZv+p8UgmVR1Ztv4VJivboL4Qd0jfml
	wL7BMLp8+sQ/qZ82vvZNUhiJZlv9KCrg=
X-Gm-Gg: AeBDieu3g7IZ/vJPzUVfKlhAoPlxgmuKTHd0P+e08kFyiVdx2lnNLj+kTCLjuAJjxmK
	23PEpWl7rk/hbgQu4KVH4R1OWkLgztIk/X5JVLLh7kN1C7EaZ2y38/MsAZwImWi/SABHwjr1nbP
	SOjQ5UpKz9fC6pN6VTda07EsbTJgJ2ykqbpH0BU6T6x2op5LFWI4ftsGHQoFt5hk2tqslrE6o5G
	WVKkI8OhK6afWH7e5ldI0k1lfW5xK89EY47I5QcEbek3t4DXHEy6jwfD0jWwSbWBElQXlmOn+Tu
	2dT+RitGjxpmOBEkU53tTgpAPyUW6XwUvBMB0M3cK3YFC1rStg==
X-Received: by 2002:a17:907:7f94:b0:baa:3cf6:4f53 with SMTP id
 a640c23a62f3a-baa3d0598e6mr755922966b.5.1777004774432; Thu, 23 Apr 2026
 21:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com> <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
In-Reply-To: <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Apr 2026 12:25:37 +0800
X-Gm-Features: AQROBzDSTb6IkbZFirEBaP59AWqfa9zcQlpgQGNGPOmXf4DwwEQvNG1RpzWB-PY
Message-ID: <CAMgjq7D-xpzWz=v5jj76vuRRBJwaEkt-gJKaviJALLY7UX76cw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 5F82F40011
X-Stat-Signature: ag4a1sfqwjtqbb94jkpxx5ebx4amkdn8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777004776-680330
X-HE-Meta: U2FsdGVkX19aCbRtX+2DkVCpmid25j75qGWWj0g0MGgexf/33OAD1viFShG8AIZ431HBTKsNX9aTO7e4W81+FodYW8zDsCT95uQCctix3rzYgShRGt2BiaAx8BtF+0KBFQEQaZ4AwsCk2lyZMRDBPxHRvC9jbDVK9TT7urUbfDX3ySKW33SKBKvMXnILI/MblDJ8NDkYUib70i+/GTL3IUtBd5I6ADyIwSzvuRvZoazn6mOEGKD9CdPT4nVgY/QHhLQmyTbscsIOuMnxDThHmREceeXmrPHGOIRyh7wHK3AkmOmv2/yjmQ6DOarAh0Lb802ogAzXAe24W145efx3zXA8FuVrHVAsMTgrem617YX2R2QXiv1AIWKvg2EHQ46bHGRB9CWJp/pA2AN0gEsDiG38gduSM8kztfpCBHk5UT57ULdmuoJ1dMv6aRyCAl5Uod5YZGgd+P4LpgNO3SGo6NS3ttelRKW4j33iDReLOrv0tBDwx0UE17Ll0Lc/ZG6FfBsnn8Uyr0ofeZOyRxwFD/Q5Ju/b/Cozj/8zbBPAg4xQF8fj1FX7dwRfnQbv111LgTCY9U1Kn45XnVRocId21B2E7+VBu7jZDe6JzEnwbzjgHmW3wDEPyugdSMPInKoL+24NqStcPVNmteU+cuCdvWOddc2GPBOyZ2ThSh+eZqb7Ahpli3HaD4jbP6h3KiC53JLn+CKyP65VGV9ftCMeCSeT3L2tIgS3cWn6YH/6z+98NcD/Aej8RsCYXJze600JmqrA5ITe6K0lTFzL9tsdq0W7rl2RR2NJUhKyMpgQjqhCcISpejYy76ueTU0D11li3clmtXnCUknBxsYE6179TxizEXQnAmzgqBK3Eq/DQEEScHsGxChWe9kRBiEzEx3l49CjHGNgDMK0MYBjDm0kFzWNSfHvOXJPN+B51ss11P4LzEOcdbBKfi7UcjSDM17KYoI2Ptr17TSrLcIj5Fx
 gtOHpego
 6Y1QqwCp3ke/N3+p1GN2f5sv9Jk0sA5d+7ceKdOuFheCMaWOxBPj4nNLkjbE6MK68tDMJUq7aDP95tmD71ikAbBNBSoffWjiil4EPle3IZQ8mmegrvv6TH9Bi/OPSWc6wdyfDEJaZqDmfp1ow/uRYfROw2J/QGPPQ1ea2IXcYgi7C+Px7bBEopLeTH0zP2cBZFqfgHuy++XI6QEKJaUPzIh56P7lyGPEIkSphaySjNE/NDr2Mp3+qpdogfwXMXa+kyw4gnbFkqic9xtI+QljLB4MSSe+szWXWZqk0+4Z7R+b/eB1G4BzAFbkwgA8pSpB6SrHm9/Js4RhxuICBY8813CPsQvZkBiYqG9lzzyiXBzfRiW8uiENz8QS8vCRRtDv7L5OX3av8mnIC6YrqiuMz1IVzu7nmVnBZcNSJTn4INElew/DeXtnOhIAf9/vWjcwxJ+EX9auF9eN8btd+zNxhcdka4GeZem7H5YFiHfE+Fa5450D/O7UL721TIBVw6rhisMaHbYOXgOzJv1FvJXpHUc9t9iMI/pgaTFOeLrjN3gl8lEmjgPsJpLmZaYc5pylogpqio5Mdijz6Zphq/BGV3aLUCPi8GitpUeiMqmlyuUIhLKLEAm0INMjinw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:15=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> Yosry Ahmed <yosry@kernel.org> =E4=BA=8E 2026=E5=B9=B44=E6=9C=8824=E6=97=
=A5=E5=91=A8=E4=BA=94 04:48=E5=86=99=E9=81=93=EF=BC=9A
> > > Using a swapfile does have its benefits, though. For example, the
> > > virtual layer could act as an ordinary tier following YoungJun's
> > > design:
> > > https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.par=
k@lge.com/
> >
> > Hmm I didn't look too closely at this but I don't understand how
> > making it a swapfile helps with tiering? If anything, I think it makes
> > tiering more difficult. For tiering to work, we need an
> > abstraction/redirection layer, such that we don't need to update the
> > page tables (or shmem pagecache) if we demote/promote pages. That is
> > exactly the use case for a virtual swap layer. The page tables point
> > at a virtual swap ID and the backend could change transparently (e.g.
> > for zswap writeback, or tiering).
> >
> > If we make the virtual layer a swapfile, how do we demote/promote
> > without updating page tables?
> >
> > IOW, I think the whole reason we want a virtual layer is to separate
> > the backends, which would facilitate tiering. If the virtual layer is
> > itself a swapfile, wouldn't it become one of the tiers?
>
> That's exactly what I hoped, virtual layer being part of the tier.
> Tier could be set up per task / cgroup. So is the virtual tier.
>
> A standalone implementation of the virtual layer is more heavy than
> being a swapfile. Actually I think at this point, it is the word
> "swapfile" is misleading now. We may rename it to "swap mapping" or
> something. A swap mapping could be physical or virtual. Virtual
> mapping can realloc from physical ones (redirect), and swapoff of
> physical ones just read its data into virtual mapping's swap cache.
>
> I think it's actually functionally very similar to Nhat's design
> already from a high level, the only difference is we don't need
> standalone infra for virtual parts.
>
> For swapoff or migration you don't need to touch the page table, same
> as in this series, just update the virtual swap mapping to be cached
> or update the entry, it's identical to what this series is doing.

BTW it does look like file mapping. In the long term maybe we can
merge part of the swap mapping with file mapping again, not sure
though. Swap mapping is a bit different as it's integrated with
allocator, and previously it was reusing file mapping, but we had to
use a lot of strange techniques e.g. split the mapping to avoid lock
contention / special lookup routine / synchronization / handling
writeback in an entirely different way. Just an idea and reference
here.

