Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD5ACD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B6F6B0005; Tue,  9 Jun 2026 06:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBB36B0088; Tue,  9 Jun 2026 06:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1426B008A; Tue,  9 Jun 2026 06:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE90D6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:17:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97216A04DD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:17:08 +0000 (UTC)
X-FDA: 84859971336.01.41CD5C3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3384C4000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:17:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BKafXaJa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781000226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNttG2V3Yc3+inhQrJw8rUw2/59pdpZuTVtKZr8ukKg=;
	b=RTQz5nyoGwascHM6f3XCpzlg0tWAw9ul1/GgsrN4hmQrvGOopfIoCgT/rSnsPB7xuEfmak
	heg7GgLLOM9qsfYKpmx7x2IGpc6qI07fGDtoH+d7dT0GexePbvmx4qPiSK72g00molwsBl
	CTBQcaPy6wYLP+Suq2u9iiNbaeXCQ6g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BKafXaJa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781000226;
	b=Iv5VnKoGehJdmZM9JEULbE02u/WLTCNMb8HOmOVxpaXqvrseI60d4fekCSeLAqjndLxxW2
	taeyupq0MAuUBy9qqBNtmhSHoJrXXNfFMHkk7kpUvwTTz9wO8fS1GJbhJoo4kLCm72y/Fm
	z+z3d6lnq096Y4M/L9SX9Xw9KXoxWH8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781000225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aNttG2V3Yc3+inhQrJw8rUw2/59pdpZuTVtKZr8ukKg=;
	b=BKafXaJa5kPPsoZn2XroufWFV5UImcaVeuajAoeIzHYaZNKBxyArr61syhaF2KxWI3rIox
	SNhX5BEnN3HSoitz43ceAOoniyDT29sloK8UdI+AeDVWyrhFtYyrlndsCM9kSKTDQjiv5M
	QAk+R2l2CnpGZ0pHPKad2rVJ1ws3q58=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-8s8NRUZMObubB8m96RkZ1w-1; Tue, 09 Jun 2026 06:17:00 -0400
X-MC-Unique: 8s8NRUZMObubB8m96RkZ1w-1
X-Mimecast-MFC-AGG-ID: 8s8NRUZMObubB8m96RkZ1w_1781000220
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-660f247c238so9406306d50.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781000220; x=1781605020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aNttG2V3Yc3+inhQrJw8rUw2/59pdpZuTVtKZr8ukKg=;
        b=jciZjhc+oxUqGsKEuh9R1LQj9mDHHsZQZLvWuRTCbbW3+iW0jgR7s22eER+ivDzdeR
         wMsGHBRc2ld5CciY+3FYGjofmS4pgNkyyOn4RiKdiOHxmL0uJjtRkDl/H5HNPnFLcHZ/
         DnFBJmJW4fjUPqaVdUV3ljcVkM00+90OM1tA9aOrwFUHBFEiASs8ma2wm/ybcWHww83o
         mxETT5NXA6WbC3JdwSS9Ajb0LWg3EM+xwAGQusd1GHLC+tLJXR8OiH8f5mIY3CuAYH0W
         2Lpk3SCHiQUroxOv2oHGbhxnpMCMIOIeSnvDyp/bV7B+JA+Lubc/TUPsBpViDTcIPICD
         tBEQ==
X-Gm-Message-State: AOJu0Yy2U+AYZ+MINAEHZ1H7mlYAMwS8bsy7sBn2LADwOW0zKXfaWEZS
	tUzInU26bOZHzHQXBzlczYgZjz04aPYs6mCR08TUluMn6F+2nGkPyr+TUL8o7Mx4+q2Zd5MfB7B
	t+0NVuKFtLs7ddZe0412K8UD2ANK5rXEe6osO//BsyG3crFm2GRu25lPNJQaRnSyBDRpH7YrKq0
	Ovmfc/gCauBFzcR5IY7oNFxtv7H/U=
X-Gm-Gg: Acq92OEL6QLvCZZW0JcJD+sjOv5EaKcsasMxbWurK0Lgy0QS17l7VHwEJ2uxslWlemn
	JubPSvuBjhHOdOFubM6kEI4ykpn+t6qsYNZ9I8Pgj1uWoKlCPXT7qsHI9fLoG+wCyc05q7jmstb
	hpqviCT57+p7BZhwvqTk8Xk1MWVUNcXjk1bJARn33jpM/CYN9QtOq/OKi6Zz3hiDokip8/mZ6eQ
	yadnQvmapFq+ggH
X-Received: by 2002:a05:690e:1248:b0:660:6ead:8997 with SMTP id 956f58d0204a3-66106e67419mr18440074d50.28.1781000219989;
        Tue, 09 Jun 2026 03:16:59 -0700 (PDT)
X-Received: by 2002:a05:690e:1248:b0:660:6ead:8997 with SMTP id
 956f58d0204a3-66106e67419mr18440039d50.28.1781000219417; Tue, 09 Jun 2026
 03:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
In-Reply-To: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 9 Jun 2026 04:17:45 -0600
X-Gm-Features: AVVi8CcqpE3Gp5uSjQiihRNOm7dLMU3OwWkokZs_CGlcncsgI6JZd4n96mwqRZc
Message-ID: <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
To: Luka Bai <lukafocus@icloud.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, 
	Luka Bai <lukabai@tencent.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lY91HEjoCnRwWWa1QNvKic95GZ2EP-dAiJcR1a8u6-s_1781000220
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3384C4000B
X-Stat-Signature: uooieiy6uwgwmq4yxciym85pnbrtq499
X-Rspam-User: 
X-HE-Tag: 1781000226-704643
X-HE-Meta: U2FsdGVkX1/rdn+AEvBuD5s+578yX4lqqfey0gyn/oRbz5Vqaop6RAQ5gN4XAYYCDKSnJh/2pNmRuSAjSoha62iCuy75Vf+oz64xfRhALdxJkv5vbUPm8tV1XadFQ5jUBgzN35JTz+WbZq9ZZ0zZ1VusY2JcUpkMfdonq+Lcv8+2p8aDBt6Lsdfee7Pn43LITWDb4EOWG9Z2LVJlxIyswyaI6/UqMZDcbFuigLPbDWIx1uq2dXBciK8ZibkVecJtsX+p9pXH8seCkbv494FdrVe8is3/lMzGDS1IZ0vHfJBNbF5y/DhZZcVXaDtQiBJ1qXcx3ZyPu4Mpv+ZNH/77g4hJlztnKSqKBTRM7e11bqhi1TOqYtY0CuwkgZ+3/+70wtR2hY2vFfCoV4c9HPlZJAJD/aCchjkunlWlR2q0KGS8j5d447LS9stB9ImU/mtb6BazVV/Ma8mafi5gKgv/m1Q07aaFQX5g0q29NpND2MMw3P+EQtnIWJG/cNb9iFEEN8Bv+FHYJIjoSbGOafEr3YgS8CBKMCM25WSBszDNFqcY5OXVzfW68GtSIZCQWqjQOMBkifuzj0V7z8EjFKtOn25pdIVcqL47t1BoYtAr/nbDfz6A5IaN0+Fa0r7aCWX4e3Zk6InCLSxK26GGZJqGmFaf9ZYlmPr+Cf5dcAGfyyRrvB2q7xg6R8Ii4m+911G6j6n1MAR+0ampoYIMaSEnL5vJF44iuyhvNklkRwgcFxERA/YHLHMXm5OlFqzq7BYefs6N2wlytIu+OaOEsUoRoWFxyoaRKe1XhExgpCl3vYoLlOb3JhRf5mLf7OHN+vWqMiqGMgSv/eM6Zwt9NmCpbGyWGtrj/Qg1hYJyBj/MuPLifFvfzx1H2EuYPnI5VM64OuZpszR/rUlWPRnb0tn+yNV7fMQp2WwgKfGX7rwtNJtyNLcL6GpCrIJBWWDBl99qgPXAHzkTyT58OkIK3Cx
 UBAvA6k5
 w/PAgo09i6mOFZaMRW+EjUABM8WriPTKU6CYCeJblAj8uczw3OB7jsk2KM2bv+BcVcGFz3yobBvBJ3vLC2XO/g4llLWzdnkS07I28t9nP4Qu/laSVRZvsue/1liaca298NYqjPrSQ7xVahv8H027ZhoS3mTNAtZtoemFV2mLIXyoVN01Pw/goBeteOiPqJLdmLJ6OMSyPfeiCZJ5XMMMbAHFkT1jzEqC60Ew53fvj0U0qQwbTJWz+1t274U0sz0Wru9HpjquA9yb88SYLNtiHc4XWrS73DeWsbqXP1fHPMPqkc5Z26x+qKkl/jhJ3EfHmWG4NbdmpcGEpgUEbQdM4MJ2GRJSohf3vlgjR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 10:33=E2=80=AFPM Luka Bai <lukafocus@icloud.com> wr=
ote:
>
> Khugepaged is a background daemon for collapsing feasible pages together
> into a transparent hugepage in all sorts of orders up to PMD_ORDER. Howev=
er,
> it doesn't have any preference in its collapsing and just iterate through
> all the qualified mm_struct, and scan their page tables from the beginnin=
g
> to the end. It is quite inefficient especially for large address spaces
> considering how slow the khugepaged can be, and may waste many hugepage
> resources collapsing memory areas that are seldomly accessed.
>
> We would like to give khugepaged some preference hints when we found
> certain areas are good condidates for collapsing. For example, if some me=
mory
> areas are frequently accessed, then we know that it's valuable to merge
> them into a bigger folio since it will reduce many tlb misses.
>
> For example, MGLRU has walk_mm() and lru_gen_look_around() that are used =
to
> scan frequently accessed areas to save some works on rmap walking and
> generation elevation. By the same time, they are able to find those
> hot memory areas, it should be valuable to merge these areas into folios.
> MADV_COLLAPSE can be used, but that will cost too much time and will
> harm the performance of reclaimation and slow down the process that may
> enter the slow path of memory allocation. So the better choice shoule be =
to
> tell khugepaged to asynchronously do it.
>
> We add a khugepaged collapse hint framework in this patchset. The caller =
can
> call khugepaged_add_collapse_hint() to add hints for khugepaged to make i=
t
> prioritize collapsing these specific address we found before doing Round-=
Robin
> scanning. Each mm_slot which belongs to a mm_struct in the previous
> mm_slots_hash is now a khugepaged_mm_slot, it comprises the old mm_slot
> struct and a number of NR_KHUGEPAGED_PRIORITY_LEVEL struct
> khugepaged_collapse_requests. The request struct for each mm_struct will
> be put in the global struct khugepaged_priority_queue with respect to its
> priority when __khugepaged_enter() is called on this mm (we give each mm =
request
> structs for hint dispersion and balancing across all the mm_structs that =
will
> be added in the future patches), and all the hints will be put in these r=
equest
> structs. Each hint will have the target address and the target vma struct=
. An
> example of the framework is like below:
>
> global collapse hints queues:
> prio 0 ------()----------------------------------()---------------
>             mm_slot0(process A)                mm_slot1(process B)
>                |                                               |
>            hint0---hint1---hint2---hint3       hint4---hint5---hint6
>
> prio 1 ------()----------------------------------()---------------
>             mm_slot0(process A)                mm_slot1(process B)
>                |                                               |
>              -------                                       hint7---hint8
>
> The khugepaged will try to scan queues from highest priority (which is pr=
io 0 in
> the graph above) to the lowest priority (which is prio 1 in the graph), t=
hen go
> through the list, and check out all the struct khugepaged_mm_slot (which =
are the
> mm_slot0 and mm_slot1 in the graph above), so it will start from mm_slot0=
 in queue
> of priority 0. Then khugepaged will scan all the hints listed in the slot=
 (hint0 ~
> hint3 in the above graph). After handling one hint (no mater success or f=
ail on
> collapsing), the hint will be deleted. If one khugepaged_mm_slot doesn't =
have any
> hints in it, khugepaged will skip it and scan the next mm_slot in the sam=
e priority;
> if there is no hint in the queue of prio 0 anymore, khugepaged will scan =
the ones
> of prio 1; if there is no hint in any prio queues, it will fallback to do=
 Round-Robin
> scanning like before.
>
> khugepaged_add_collapse_hint() is for adding hints, and it only gets call=
ed
> by walk_mm() and lru_gen_look_around() right now. In the future we may
> call it in more scenorios when we found hot memory areas. For example: in=
 damon.
>
> We tested the performance by using valkey-server (based on redis) togethe=
r with
> memtier_benchmark to simulate a gauss distribution on the get/set operati=
ons on
> a 160G, 64core x86 VM. The dataset is about 3G. After preloading db, the =
testing
> parameter was like below:
> memtier_benchmark -s 127.0.0.1 -p 6379 \
>       --ratio=3D1:1 \
>       --key-pattern=3DG:G \
>       --key-minimum=3D1 --key-maximum=3D3000000 \
>       --key-median=3D2000000 \
>       --key-stddev=3D150000 \
>       -d 1024 \
>       -t 1 -c 10 \
>       -n 2500000 \
>       --pipeline=3D32 \
>       --hide-histogram
>
> Since we wanted to see the influence of khugepaged collapse hints on the =
reduction of
> tlb misses, we made khugepaged do scanning every 1 second, and used the u=
serspace
> interface to do walk_mm() for the cgroup which valkey-server was set into=
 every 2 seconds.
> We made sure the server was all 4k pages before we run test, and only khu=
gepaged could
> collapse them into large folios. We enable the anonymous THP of order 9, =
which is pmd
> size in most setup. We used perf stat to monitor the tlb misses statistic=
s.
>
> After repeated tests, we could see dTLB-load-misses with a 13.50% reducti=
on, and saw
> dTLB-store-misses with a 5% reduction compared to the setup without any c=
ollapse
> hint. The final throughput for the memtier_benchmark was about 2% to 5% i=
mprovement
> on average, which was not that obvious compared to the tlb miss reduction=
. We believed
> that was because there were too many factors to influence the final resul=
t of a random
> redis test, so the influence of tlb misses to the final throughput were c=
ompromised by
> other factors.
>
> Patch Details:
> =3D=3D=3D=3D=3D=3D=3D=3D
> * Patch 1 is to add the basic khugepaged hint framework like we introduce=
d
>   above. Details can be seen in the commit itself and the comments in the
>   codes.
> * Patch 2 is to add a slab_cache for khugepaged_collapse_hint which can
>   improve the performance of allocating and freeing the hints.
> * Patch 3 is to add a deduplication machanism for the hints so that we wi=
ll
>   not add a hint that points to a repeated address.
> * Patch 4 is to add the accounting for successful collapses initiated by
>   hint or non-hint.
> * Patch 5 is to add the collapse hint in lru_gen_look_around() and walk_m=
m()
>   of mglru.
>
> Thanks for reading. Comments and suggestions are very welcome!

Hi Luka,

I haven't reviewed the code yet, but the overall concept is
interesting (it should probably be a RFC first though, but that's
fine).

I had future plans for something similar as part of the thp=3Dauto work;
however that requires significant thought and investigation into how
we can properly gather hints for collapse/split THP candidates. From
my perspective we'd want a more global structure/system outside of
khugepaged, that would directly call khugepaged (and others like
split, etc). It would also tie into the allocator so that at fault
time it could leverage the hints to make better decisions. My fear
with this series is that making a decision now might complicate future
work by adding complexity we may eventually want to remove for a
better solution.

If you have the chance perhaps you can lead a discussion on your
proposal at the biweekly MM alignment session.

+David Rientjes as he leads those discussions. We could use that time
to layout a plan for what needs to be done for this work, and for the
work surrounding thp=3Dauto as I beleive they will be interdependent :)

Cheers,
-- Nico

>
> Signed-off-by: Luka Bai <lukabai@tencent.com>
> ---
> Luka Bai (5):
>       mm/khugepaged: add framework for khugepaged collapse hint
>       mm/khugepaged: use slab cache instead of normal kmalloc
>       mm/khugepaged: add deduplication when adding new collapse hint
>       mm/khugepaged: add accounting for successful hint or non-hint colla=
pse
>       mm/khugepaged: add khugepaged collapse hint in mglru reference chec=
king
>
>  include/linux/huge_mm.h    |   2 +
>  include/linux/khugepaged.h |  20 ++
>  include/linux/mmzone.h     |  17 +-
>  mm/huge_memory.c           |   4 +
>  mm/khugepaged.c            | 460 +++++++++++++++++++++++++++++++++++++++=
+++++-
>  mm/rmap.c                  |  27 ++-
>  mm/vmscan.c                |  33 +++-
>  7 files changed, 549 insertions(+), 14 deletions(-)
> ---
> base-commit: e1af79f3291a268adf4e149e1faba3052743e898
> change-id: 20260530-thp_collapse_hint-ec92bd943797
>
> Best regards,
> --
> Luka Bai <lukabai@tencent.com>
>


