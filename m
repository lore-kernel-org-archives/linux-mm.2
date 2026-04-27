Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD02FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2406B0088; Mon, 27 Apr 2026 14:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872716B009B; Mon, 27 Apr 2026 14:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761926B0095; Mon, 27 Apr 2026 14:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 617D96B00B6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:23:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DFCBC13F6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:23:24 +0000 (UTC)
X-FDA: 84705158328.02.6C073B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62CAE140008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:23:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AxtXtoW9;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777314202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7e7Tf2MGPPvF7IQtCfLfncjsVrLZZIHywY4b/DUulQo=;
	b=bez8jyNdtpHSy7hIQITU2UxtzFvURfYBrUQKFsCw1SwpiOyEsq1P2T/gpRw1y0f9c9u6C/
	Fb/cS/99cf97e7+uUxwuwIrIoSIWIiKg6kBA1j2j1ZqE2pFyOzK5P5XuMWNLXtIUTE0n8B
	PV9/TpJbdtGGGImRiCgWYELBQVG64qQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777314202; a=rsa-sha256;
	cv=none;
	b=IAnY+9Qnl7ygMuPjr9GjBJP/kqeTOfE040lOf8slkOymp46M1KQ916J7mVm9bw5A8RdQGc
	OW1wmylYH2/fiQlMM+NBataXhPygU/mIjygNhkJoT3AJrCqb75TSg4XgyGtJFy4IgSI5zi
	wR4k4Vko/9RHu1MTGZYL9Kv1Wf40oMk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AxtXtoW9;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9FDA6133B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381B1C2BCF4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777314201;
	bh=7e7Tf2MGPPvF7IQtCfLfncjsVrLZZIHywY4b/DUulQo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AxtXtoW91Szs1ppf6YGfwYILqEnqNth9WCmpuZQNj+WzMjxYOBk7QwDAhz5wXitVh
	 GIJWN65tEr5z7Rhs3yVwPrmHtxOk0jGUEGxOzHF7dKLLi3fyNFBH9BhQ9qhasVS8Ov
	 Yw/L3ly9WTIehMz5N26+6UUt8f1MqAwBtpOZW8XqeotLPH7v5XDxczg7HjMSvSYPnz
	 oe13yt1zt2PIamae0azrqg8NnTtIGoUVubvm+A/shtxSo5YpdQ3pnhAICf+sMObQ/2
	 WIM7KNQ1LS27df/0Co9YDsl6DAxCHX3uNRIHOgkhBmhQKbjugIW9jzLHTKzD/8qF3L
	 Wg8qXelz6C3yA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6788838d543so8346340a12.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:23:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+7tZytLy/10f2jFt2iIARA7gnucJuENrP/bJcCxdjJkUbFTy4smznb0q56sQcDM7gerYSWnjQ6cg==@kvack.org
X-Gm-Message-State: AOJu0YxAfFwM+Vm6O8Rz9Vi3Bm0JtHCJgS0jKJ4cRVvuEQb65J8Hccux
	1fJ12JYIkzW/4FFYKeKhv+CXwRtIsyrzpA02zaCcOCeLviE31EW58ymP5+7kR9dUtc0wadP8D30
	j4TZ/RlV5pfQTT2I4q1v7XvaQSBFP6ow=
X-Received: by 2002:a17:907:8b95:b0:ba8:8c8c:1c5d with SMTP id
 a640c23a62f3a-bb7fd089780mr894166b.47.1777314199304; Mon, 27 Apr 2026
 11:23:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
 <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
 <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com>
 <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com> <CAMgjq7A4+Sac9-CYkig1LFfEh5rq-4vLka8AXREei_m3svzJ7w@mail.gmail.com>
In-Reply-To: <CAMgjq7A4+Sac9-CYkig1LFfEh5rq-4vLka8AXREei_m3svzJ7w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 27 Apr 2026 11:23:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMv6oYvqXti8dFfQd79Nd_Yge5g-EjjjhsEWj44gwJ-qQ@mail.gmail.com>
X-Gm-Features: AVHnY4JSrF4JaGtUa9RGykJDx4LJmM53x95FeUNsFKceHbvA9vScOToLoywkb9c
Message-ID: <CAO9r8zMv6oYvqXti8dFfQd79Nd_Yge5g-EjjjhsEWj44gwJ-qQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62CAE140008
X-Stat-Signature: 4swpua16dkddizef9n8z6k5cxfets4ab
X-Rspam-User: 
X-HE-Tag: 1777314202-870287
X-HE-Meta: U2FsdGVkX1/ht79OESVBFkXB9J80Alu+3SBVa/AORigk3DUVj+PwldQoRh79rmp17ezqk+CfbUE3KIV2OFjJ1vsKYf9ml5K+HrD9epUS3vD65lu8HLSW+3o1sZ06fexmsHKecnUc/YADfOUhmK+SH+3FA5sSV79ons9R4JCwibRIR29bk3bd3H+JZ2TLFD5STewVlpV+rXxoNZWNbs3KpBb2qTIS+wX5tE5DctKSv26NN0TQmcf3GZvPwco2g/GcK1C9kNYhmUWQ4Fl7zxeCYM58Tkeyg8fjPc/b3BJbx1p/M9XvmV4mVVdMU69MPPBk5j2BvR1G0L9tKDM9idBbR62cHgmC1maXiFeWX1ieX7ohgeaEDYDqRD1hfyZu0IS6J1W1jTYzG6AYVxuWjntPv3sAz8hv7u11jvJWKH/8wFNgKCo3YkdlzdRmfwLbtuhbtDdPjK7M9+NkeYJehy9g7rttYaBF68nhzVfhWBPtSxviLNXMGQWcDZX5HKX7Ti14yrEUaQ7+mQ6j2VQQp9znQzXcPD+mZs8jVR1b3ryB2n9kV5/qaIWV4KYSwBSVmMNiA6fpo92mD01lOgxLz4y6hFl9qmc8s2dffts1XpEP4yZWsFE3aGkVBlWSKsKzy3frHydSwcnLzDS1F3fgMH1hqmCSdWh0fYBwiKWr58mVtmxJhRURLPGQikJrHZEMy+rk8f1q5O/MuFf8VJ8QNpcahATxlJkPAII+5G/r+wgYYcKsT0OBuut/O4ZFpITLeyRnTehso/JARGQO2YaamCSg1YlEzxMaiPqT1MXYIXZrgadeuu/pLH9QztdeQ/t91gV9ObrB0uAMe0GXafUW328hQ6A/vah4YxT1I8QEIL7/Cwmh8wUgHz0jvPfSThTR5qeLyEoEIJ+JInUSRP7Kl7U/AdqPOGxf0IgLmY2rxBvqPqfdEkXWtxVKRBKDh+TELtGSKApUOg/jgsTuREsuiSO
 pl7m23lo
 fw+Bjq1CaGNsvXRzHRhD7X6fHi4jPV2HBRBiX731t7bR+bTnv9yabYsKapCK7Zr+zCee6NsbHZ42DPwVmswwxhhiBLQxXXlgX9FPo4amy7xNYus+2h2l9WIHCGoxmC2/dYC8UffdoVO76LoRZzeIPtoL5Lxzj7moWgZdBg12VUeWLFbLztvMMj17tBhRF8zEBqDtwWqhOBwS/9DD2ksh8cmFn8iVK11gls+XRH6ZVsfe1u8UQm4qLnHpH+4wsf4q1+vgwmMP7LmWIoUbC2xr9UR3NS/Os1B/RBT027R9ZPy9v+hWS8fz4XIvisvjP8VBGgK6D7gJsVr4/QdIt0F34M/hPUobq6XiV6Ql4/jk7OmxuoatVs2w2wClBnoz4y0Jarb3P/I0h5xXjVxcjYma6ZvzQSEU12fd8IcmHOXG0yPuS9BJKoS2NxzfaQOAaYzoT0yZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:52=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Sat, Apr 25, 2026 at 3:12=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote
> > > https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.par=
k@lge.com/
> >
> > Does this do promotion/demotion of swap entries?
>
> Not yet, let's do things step by step.
>
> > > For example just reserve a type (e.g. type 0) as the virtual type?
> > > (type is really a bad naming though).
> > >
> > > The that swap file (or swap mapping) will be
> > >
> > > I was trying that based on this:
> > > https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-15-104795d=
19815@tencent.com/
> > >
> > > It seems to work and the only thing we need is actually just somethin=
g
> > > like this one in VSS:
> > > https://lore.kernel.org/linux-mm/20260320192735.748051-15-nphamcs@gma=
il.com/
> > >
> > > This part:
> > > + /* fall back to physical swap device */
> > > + if (!vswap_alloc_swap_slot(folio)) {
> > >
> > > We do a folio_realloc_swap if folio->swap have type 0.
> > >
> > > Which means, if there is no virtual device / mapping / file / space
> > > (I'm not sure how to name it at this point :) ), the ordinary swap
> > > routine is just still there untouched.
> > >
> > > If there is one, and it's being used, then, it is still the ordinary
> > > swap routine, just do an extra allocation (and the extra allocation
> > > strictly follows YoungJun's tier rule), which is same with VSS, but
> > > everything is reused. From a user or high level interface perspective=
,
> > > this can be designed with no difference as VSS. Just with a few
> > > bonuses: being per memcg / task / runtime optional, zero overhead if
> > > not enabled, and reusing all the infra.
> > >
> > > BTW this deferred allocation (in VSS or dynamic swap mapping, similar
> > > thing) is actually a bit concerning to me as well. It changes the
> > > common swapout routine and maybe worth reconsideration (e.g.
> > > activate_locked_split and mTHP stats is now ignored?), being optional
> > > for now also seems safer.
> >
> > I am not sure if I understand you correctly. I think what you're propos=
ing is:
> >
> > - Page tables either point directly to a swap slot, or to a virtual swa=
p entry.
> > - By default, page tables just point to swap slots maintaining current =
behavior.
>
> I mean, they are all swap entries, nothing special from the page table
> side. Swap subsystems handle things internally.
>
> > - If we have multiple backends (e.g. zswap or tiering), we use virtual
> > swap entry instead.
>
> Actually that can just follow the swap priority, or tier rule. Even if
> virtual mapping exists, it can be bypassed. e.g. you have a large NBD
> and don't care about either fragmentation or compression for offline
> workload cgroups, then why use a virtual layer for them which could
> double the kmem usage or spend more CPU? Setup is a different issue
> which can be discussed.
>
> > - The physical swapfile has clusters and swap tables (status quo).
> > - Virtual swap is implemented with clusters and swap tables in a
> > virtual space, and each table entry points to an underlying swap slot
> > or zswap entry.
> > - If a page table has a physical swap slot, and we need to do tiering,
> > we basically "make it virtual" by making the swap table of the
> > physical swapfile point at a virtual swap entry? or another physical
> > swapfile? Not sure.
>
> They are still ordinary swap entries, nothing special. The virtual
> space is also just a ordinary swap file (or swap mapping), which is
> easy to do:
> https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-15-104795d1981=
5@tencent.com/
>
> Then its virtual_table will have a different set of swap entries. (I
> left that part undone though).
>
> > > Right... I mean with two layers you will likely have >16 bytes
> > > overhead, and double lookup.
> >
> > Why >16 bytes? Do we need anything extra other than the reverse
> > mapping? Also why do we need a double lookup?
>
> You will have to store at least the following info: memcg (2 bytes),
> shadow (8 bytes), count (at least 1 bytes), and revert mapping (8
> bytes, since you have to address a full virtual swap space). And some
> type info is also needed. Part of them can be shrinked but still,
> scientifically, merging two layers into one is considered a kind of
> optimization.
>
> You need lookup the virtual layer, then the lower layer for many
> decision making, is was discussed before to introduce more cache bit
> or things like that and I think that is getting over complex, reminds
> me of the slot cache or HAS_CACHE thing...:
> https://lore.kernel.org/linux-mm/CAMgjq7DJrtE-jARik849kCufd0qNnZQs7C8fcyz=
VOKE14-O+Dw@mail.gmail.com/

I think that's where the disconnect is. You are considering these two
separate layers, each with its own metadata. The metadata should only
live in one place.

If we only have swap tables in the virtual swap layer (with the
metadata), backends do not have to carry the metadata. In this case,
backends should only have a reverse mapping (if needed), and some
internal data structure (e.g. bitmaps) to track usage.

This is difficult to achieve if the virtual swap layer is optional,
because then the metadata can live in different places. This is why I
think we should have a virtual swap layer that all swap entries go
through and all metadata live in (where today's swap tables would
live). Backends then only carry backend-specific data (e.g.
compression handles for zswap, slots bitmap of swapfiles, etc). In
this world I *think* the reverse mapping could end up being optional,
depending on what we need it for.

