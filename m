Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE138CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157DA8E000C; Wed,  3 Sep 2025 08:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F6E8E0001; Wed,  3 Sep 2025 08:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06CA18E000C; Wed,  3 Sep 2025 08:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA7258E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:55:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B96B5A2CD
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:55:30 +0000 (UTC)
X-FDA: 83847935220.26.DC96B68
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id B1C92100002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:55:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V05ifRgV;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tqa55yV4aTAm57v+SxbuLsg3N+TNVNUmjaRawpI6v5A=;
	b=LvuOWrkP59ZPVtn+QLB/Ko3pUhtz254L3HqKmUEtxyPjsYdeyUc1nFzdr1pAPzGSSvUP6q
	ibTnmTZL5/ThWj6FpT48i3AMqYDo5Ati/enliGVAAk+fi8syZaJV7iPHmwaciGCR4iPTQ8
	yn0fRVPFO/X20MpejSmh9mRW7tyBkUA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V05ifRgV;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904128; a=rsa-sha256;
	cv=none;
	b=gw/3cYr05K8WzaO0q66Wkn1v9iW2SfQ05whJ/8+L1d5jQ8JveTUfUKWGpMBsUs2LmP/rFU
	5+TJP8qvVKwm7fTM4nlreWVLHRPFWz+afyzwZlz9gKOM8Foys9GRZU253rbcZqqBaJsjxM
	z+M0M0v7HX/olWCleqXGQc6HEL2eAdM=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so7234787a12.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 05:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756904127; x=1757508927; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tqa55yV4aTAm57v+SxbuLsg3N+TNVNUmjaRawpI6v5A=;
        b=V05ifRgVC1/fuaM5TIYmam+QC6XRj0C7WiApqe3jTaSAl07pYhqQBq5YoUsy7B4Y8p
         NNu7FanjcKOoms6Za4/2+BKaeh8zxc1HkS2yLHgfXE6rLjUuSbEzor+IXymOKIIF9wQf
         Cn9bNSEbKDz56ti7MRTXz56cTa2bMNG0lc2p1MAg7VVL7UU1txGgU11tzjCn37qfKjvo
         AL1+iG84qfkBE1vZKqLrIzDBx4GyzhjcYCjrR6zN66dshzX+Qs/9EIocRPg0TQPIBFFv
         AHFFWN4HoOBMIcm+xwS0LMMqIDMWb29rc8ynzGQE6lbWeYu2EIIQ3XUpsN+4II5G10/o
         BfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756904127; x=1757508927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tqa55yV4aTAm57v+SxbuLsg3N+TNVNUmjaRawpI6v5A=;
        b=uGtAXw2XU9H14Onfs3YpV0+ddv301eRSIweuEjg06gn+F5C0ThhIDTiJWStYhy054p
         6yvmRvMHzQZxQXF/U5l6jgdL6Lv3dByxgS43MkNKQ7y/njVGFwgZsCiEcKGntCoL+O8W
         ZngW710kB9YLvCcruZgIwJhc9ADsWCrZ3tLYo01m0TggqpSr1BDUekfXpLVUnHq2wslY
         4x5loW7JxRm13i/3wMuC/UlxcX34vsvGannuVSnZsGTmw0Cy7KVuXBhiFrINn8AfTYB/
         ofgT97cVe/OHnAwe+Tm5p5mi90u9Gl8WaqdXpD9GysgL5dv/j3CSsVseytRGLVg4zt0B
         mxSw==
X-Gm-Message-State: AOJu0Yz7xOMGmhd31cBQQFrJg5j3p7SGZatycYCV1ivS89pw6ZJTZ4ja
	uFyfj7rKyBONyvNYxb3umFPlAs5GBw5I2DGQSWi6b9oiTdgnfBGkb/pSLuBkha50tjwXA+CZgRl
	tcUIY8QZfhoIzV+ly1V6btUkpo+WwRbM=
X-Gm-Gg: ASbGnculZaFdkp4JP5xpsFNNK1cjLwfUIox5pGTeu+zp2iMeTG/KprqA37IZgt0PCI3
	PX6Wd7VFGfxNK5rtLETTHfaE7HaeSIRn0OtzhKkHoYO+zPp9Og3DV9Dj8/yCB6nXLGxt+uG+BrL
	VYlAyoikMq1W1A+zZEcF5/Wp0URw6vlnJjl8wt96s5F9s2Ukx3KO8g8JW0zrgV7v7v8xUy+F2UH
	OpBCHLlSgvousq/pLgq2Q==
X-Google-Smtp-Source: AGHT+IH93DlNhlDZom+cRlBgpdZ47jI+EeuVqgjSdW1pa295QyX5je3CwP+x4TvCpkpqWaBS09ok6f+z3WMHwh6D7CE=
X-Received: by 2002:a05:6402:40ce:b0:61c:7b6e:b242 with SMTP id
 4fb4d7f45d1cf-61d260cc398mr12917065a12.0.1756904126711; Wed, 03 Sep 2025
 05:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <c492b99e-b6fb-4da8-8055-1e93c6141a12@redhat.com>
In-Reply-To: <c492b99e-b6fb-4da8-8055-1e93c6141a12@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Sep 2025 20:54:50 +0800
X-Gm-Features: Ac12FXzPseeYqc65OYbpAk29ZR2hTSrQ01RR4YQVxqkNFFK3XdgC_fBKw5zTuo0
Message-ID: <CAMgjq7DAbMMmPVPqiGg_-2vghpPc9Jn8rkVNDFgq3reFx6CZtw@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B1C92100002
X-Stat-Signature: gfkkcdyotmf838rtyspo7tdfajoihgix
X-Rspam-User: 
X-HE-Tag: 1756904128-237740
X-HE-Meta: U2FsdGVkX1+yEc6KsBB8LR8hMoTjcBUCclaf7iz+Mk5lZyOS0e8Ww551hZGB+QKryF8YNAqqI4HTbcA95gaEmIY0v7VfIwWasP1fmN7I+sQb11iC3VwTly6OjIMM1y3MJmDSvZGSbzgpaH5D35YpTE5gNeDoCpg8WEk+9IhUlVlTvtZ+Tkwpkj6+B6PSJ4i3BO+Jx7OIp/St7RDHMZJIaHxuA+Mprs+PkpH90wspQfPXygq1FhBZxQrEDlzctfusiFTvB9nh059YCb70prXBmbpLbADuwjo9SyEtNxTz8DOlzABIddIQOAjlqrQrUlblw1A26PlfIxmSGDbAnE/8vOWXHgSqYWJhd1lQKomzcu9+tUgXyIXb67EQ7hvRMqDz+Y5C1UZxprWalHoj+RzEIt4NqcPL1iJuDPXCJBQfOLlFvZIWuyyeUTEwMY60ZvEDalaZPXm48J80oPB1pPTitki5aBfR0x0G8baUYJZztYZYgURmR6c6SXiDpWo2pvDzXuh8cZCMSw2vhQluycBLwVp1KN+axfaUshPV5a4AZiQkt+sOhKLUJLouPIN84drJ63EUeFnASJ9SaIcvRQBV4wXiqonaOaQhjFcEeQLPW6JVec95GMRsuD8VpSpvpqo2hrSoX57ew3lVUgIxSYQdAOtiAZrKIpioTGzyGYzGcnCkrlWU2uKB5+v78TPaQUKUpnebPiumNi82jaHd/siHmf1q0QIH925Cm41nfl4vl9z7VzL5PZWI0eD3IMcvA07jHsurl9KCIyrUnkHMBlP1bFWARstvzfunEHPIBO39902WulhKGcliFfWyX/mppwXr2ZFJUZeN4ZNoRz7H+NHZebAe9vlpk2Ue2n/n7I2M515pTc7EvTyk/3uXDwJ5ibB5raLXQsEPmMqs8oC3fiINKGDRn+Mb0HyUCu+085Y4iXAh++9sW7WCTUgGk7fkwbv47N4zhoi4uwQNQKCbsxH
 9jqH8E7J
 33AsQmFvoMEEOUOhIUzIagh9Z5F+GwKnuxJpBv+7IR0RliQrfwXQzD+57TJ/kNU0HP7wRaKBVtL9q9cxMVWuiYSQJZJvn+p4Ffc1ArEVhOd3goRHZZLzkkCU5BBJIpaicfoGXb7e+RIPoV1Tv5NIhug9usQ5ZIVYcAz+retZzEgLBLl8jx7ughK0L2ZHIk10S0iQmZmWP863nAkkUNN02SYbb/cMRDvVxmtkHDRyL79XiX/faArNJpaDFymHomR1Z1UhuBkmTTuoDVe8JSdqSdMe7NpFaJ+nBN7bommBRY8emkryKKLzUUVuf0qGh6GqjEgN0xzy9dM0u7sKn5ttadBjieyGVpx5xugdMxxsiuJMhW0e05ucd2drA8QchM1DRYzkPIbsesrpz+07TI6kfJa3+exmNCzPTXODY8Jqv2qEGMq+7knz7u262kMIZb9Biwqn84DJXZqbE67Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 7:44=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 22.08.25 21:20, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce basic swap table infrastructures, which are now just a
> > fixed-sized flat array inside each swap cluster, with access wrappers.
> >
> > Each cluster contains a swap table of 512 entries. Each table entry is
> > an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE)=
,
> > a folio type (pointer), or NULL.
> >
> > In this first step, it only supports storing a folio or shadow, and it
> > is a drop-in replacement for the current swap cache. Convert all swap
> > cache users to use the new sets of APIs. Chris Li has been suggesting
> > using a new infrastructure for swap cache for better performance, and
> > that idea combined well with the swap table as the new backing
> > structure. Now the lock contention range is reduced to 2M clusters,
> > which is much smaller than the 64M address_space. And we can also drop
> > the multiple address_space design.
> >
> > All the internal works are done with swap_cache_get_* helpers. Swap
> > cache lookup is still lock-less like before, and the helper's contexts
> > are same with original swap cache helpers. They still require a pin
> > on the swap device to prevent the backing data from being freed.
> >
> > Swap cache updates are now protected by the swap cluster lock
> > instead of the Xarray lock. This is mostly handled internally, but new
> > __swap_cache_* helpers require the caller to lock the cluster. So, a
> > few new cluster access and locking helpers are also introduced.
> >
> > A fully cluster-based unified swap table can be implemented on top
> > of this to take care of all count tracking and synchronization work,
> > with dynamic allocation. It should reduce the memory usage while
> > making the performance even better.
> >
> > Co-developed-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> [...]
>
> > @@ -4504,7 +4504,7 @@ static void filemap_cachestat(struct address_spac=
e *mapping,
> >                                * invalidation, so there might not be
> >                                * a shadow in the swapcache (yet).
> >                                */
> > -                             shadow =3D get_shadow_from_swap_cache(swp=
);
> > +                             shadow =3D swap_cache_get_shadow(swp);
> >                               if (!shadow)
> >                                       goto resched;
> >                       }
>
> This looks like a cleanup that can be performed separately upfront to
> make this patch smaller.
>
> Same applies to delete_from_swap_cache->swap_cache_del_folio

I can have a patch to rename and add kernel doc / comments in swap.h
for a few helpers like this one. That will make this patch a bit
smaller.

> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 2a47cd3bb649..209580d395a1 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3721,7 +3721,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >       /* Prevent deferred_split_scan() touching ->_refcount */
> >       spin_lock(&ds_queue->split_queue_lock);
> >       if (folio_ref_freeze(folio, 1 + extra_pins)) {
> > -             struct address_space *swap_cache =3D NULL;
> > +             struct swap_cluster_info *swp_ci =3D NULL;
>
> I'm wondering if we could also perform this change upfront, so we can ...

This one seems not very doable on itsown since the cluster idea wasn't
used out side of swap before this patch..

>
> >               struct lruvec *lruvec;
> >               int expected_refs;
> >
> > @@ -3765,8 +3765,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
> >                               goto fail;
> >                       }
> >
> > -                     swap_cache =3D swap_address_space(folio->swap);
> > -                     xa_lock(&swap_cache->i_pages);
> > +                     swp_ci =3D swap_cluster_lock_by_folio(folio);
>
> ... perform these cleanups outside of the main patch. Just a thought.
>
>
> Because this patch is rather big and touches quite some code (hard to
> review)

Thanks for the review!


>
> --
> Cheers
>
> David / dhildenb
>
>

