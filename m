Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37C8C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4526C8E0005; Thu,  7 Aug 2025 14:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC048E0001; Thu,  7 Aug 2025 14:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3192C8E0005; Thu,  7 Aug 2025 14:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2798E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:26:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BECBE81A58
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:26:48 +0000 (UTC)
X-FDA: 83750792496.27.8B5566E
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE6B340007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:26:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kirgulO1;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754591206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScqXmRSb91i/fJ0OdvWuOeCIHyAxHTNz1Za1Q6VYOq8=;
	b=z+qVV+OuSiKzRalKixyDufxY3Xt4z8XU2QWLuBfRoA1LD3M9+dKXq8Dx1lztBiyUKenh6K
	BXTRb4I82+Y7FYkgK4/Mge5nHvVAP4w5qOe+xShkhZHBp0BHu1dGK4NB6AZ15PdPD/Vvwh
	WiUcdlSzU2t3PBJ5XD9mzNXaWXD/vB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754591206; a=rsa-sha256;
	cv=none;
	b=NsSLlzbLRVks4zKXo514vq6m3nOH87l+MxiHqUO2gnoS0bkmxICqykYRCKfg6JkHAM6/kB
	wCqMetbEZ2VibeaS8reaMkP9SjXjR6+YojQ9sp+aLwGLwqTw67679L8LlLPEbGkOHPk/Dt
	Yhvn9mZn0YClibgZKB/En8up1CKabwY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kirgulO1;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3e5268129b7so10588645ab.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 11:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754591206; x=1755196006; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScqXmRSb91i/fJ0OdvWuOeCIHyAxHTNz1Za1Q6VYOq8=;
        b=kirgulO11HnLnjdY9RQXT9D6Ud6qitVZqAd7PSEJy/temZ2Qi6bpyZ1wvS45pgnPFf
         Fgw59tdcswJOron7H4uXs50y8ur/Y/Qiy7ebLihQk1sxaMJHRE9xLl0FiW7hDMHjbGFu
         bTlk9V2yyX7a1bu6EtMdwHbP4xdyaIaOhScRPc6QYmx8DjH+60hLJmWhnAsrpzdV/HiV
         qf9ERKJKY1mOMzmSN0eV0ZtpdsnW52c7oj9EdX62UK5CsJzuxItAisT1C4opugClE5yd
         f9okNablcU9M5jXOG8kBbR3+YMdhmqZkP2YRY+GmHsrlEbRpVPQjcht+pfnjTv3LRD5f
         5rGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754591206; x=1755196006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScqXmRSb91i/fJ0OdvWuOeCIHyAxHTNz1Za1Q6VYOq8=;
        b=OXDvDn0CHGjdtjT8y+EJg4rqxVxXwiidA4qxDbMAziFBYPq/QGx9f4UzC17uA4zP3s
         NSHvd+fpHYMFegxRgc5yGJHY6jFNcBr6KOuWXcIlpKBDYsNcvYuthxDRqUGqyOLfT3XB
         a2HhBd0A7sAX+mSnUaI4PvLFVuqelWdEiU2vclSm9yAnleuM6CLhNXsY1l6z9ZtkyO8Z
         vph6X/7K5XFcGhakaT4Vxq60o3J+pjJNUW3X7p77F5rQPieq+7J8VoU7I4tqx/XSxUwX
         0aX4VCjgcrcCItiRy3HnqOoSfgYoqt3D5rz7uo+dmH+Tod3c4HQ355CdskbZKrxAjGYG
         MqOQ==
X-Gm-Message-State: AOJu0YynSxnBnHOIs8VcRCSnRizg0LJzSN7INd93qDMEzGUKE3Idc8iT
	1ryqGaP/F5CMHhyCBmJTTzoxRChHR3R+RO+4DNIPBkg9hYGTBhIrREMhWjBoUvQpkxcsKA3BSGN
	nMdyQGmsLR32DOBuFM091d3SKRRyz9Bs=
X-Gm-Gg: ASbGncslx8ZwZn/TJaIsH6MRCWpcKhO8reSy5IW9ZxaKsZqEMybGB32wDCdTFE9oDGw
	vKQQ27DbrsgTkgmidFSE46k1kHETBdEpaIWjvhrQeCu65UK3QAwsyNit9KDrTo+nhmtVYAHccdn
	9zzxKX/sJCYmtacK5dGEOma+TZcQkSeqoh6DdaKMjWYfNwOHM0k1Pp+VPAAZ0BPOBlL+YDlzrkf
	Lw5hwaykVK7IgwTBg==
X-Google-Smtp-Source: AGHT+IGPT9yhU7B5nv/bo0l1oDGLpiii8QisPFuMqAz2CYCZji2txYrtMUdiLQneKqmJmqdwo+eI/34ZFlubQ7WOyWQ=
X-Received: by 2002:a05:6e02:1a23:b0:3e3:d52b:dc56 with SMTP id
 e9e14a558f8ab-3e5330b5235mr2361575ab.6.1754591205735; Thu, 07 Aug 2025
 11:26:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250806161748.76651-1-ryncsn@gmail.com> <20250806161748.76651-2-ryncsn@gmail.com>
 <CAF8kJuNSvQTxEOiWZRwwB4117713Ks51AvD0gbMhuA7KUhtARA@mail.gmail.com>
In-Reply-To: <CAF8kJuNSvQTxEOiWZRwwB4117713Ks51AvD0gbMhuA7KUhtARA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 8 Aug 2025 02:26:06 +0800
X-Gm-Features: Ac12FXwYXOUkcg6XwG8WOJeG5t9LxnRCQDsRrNtU2l__zfw6bkfKif65MAjMmLE
Message-ID: <CAMgjq7CAGSjocez9C+Vs9r4-hUyaPFVTa55E9WFVi9qB=x0hqQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm, swap: only scan one cluster in fragment list
To: Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE6B340007
X-Stat-Signature: z5eu9p3qn47834ywxmopzcqeau99uot4
X-Rspam-User: 
X-HE-Tag: 1754591206-468743
X-HE-Meta: U2FsdGVkX1/Qfmtsc3ojRwZtIzYiCPbZihdmgqCYBkNQwCrE6YZBws7ILI6OmUtVTEILxl0aaVVMExoBDEBogGdFvx7kx8pbnqNY6YjFy/CcY7/WOU5X46nn1dothGzmKna+O0R22msEcb6hV5O0XCn1cv1rf1w4o1/8Wd4DyYjrDYFqI4ElDJgKguexcnPjwj75/1mX+wRSZSqV6vxafOiJt9ZJhWG09czr9/xIemCmu4A8VTAdihLQ4wGlYxVflEQu4mRjzw8w9++scIQOfC35zWvntubwSDsP4PwuwQzLP7HG4Qba0atyeonQToN5o/hspAsX1ErhmHGF8w3+XZ3MKBsLfWVJDJh79kUmyi0Q2xxmuwM4hNFWoslX1ifMH0tQB5Wm0YtjVUfkmhCHvxTyANb0hddCFPhHG8SD9vz/b/qLwZV7Rn7OLM6UCJG9lHI+B6FuThVfdleph+EmtBfvwfzv38c3kmCqdRi2nOPPsSGN49xfeJJi5GiJ5Ot+wo/lAlwSVgD174/r9yRSppxNVSoCPFJFUw6aTzkTAoi/ovbd1ZD8w3720+JARm0VkpOkntfNuYPKmYdP6aU6OogpKlzXtwPjDhOakU9MvWHgz0LDlnqhP7JN66YeGdGqPRgYJcei/Vqdv+TALr9k3/rX8TSc1BftwXMis4B+enSJ4p586ivdapSCEpupJxnHChnMC3s4UfFKTW6vbgcUMFfwwxB58c+RohjhSnoyW6hebDQxN+PVOasniSBUlgH54UbB/4jhRWhs0tjiloAE0PzV7Qvyu0igy+5R5IbINroGAXDXwUmrwob71XuTVr9ROVMAfgI7njfXny0OGceo4ZcxitlztwMkpYhzCGyp9jENCTqbtRRwqOxacQ7j7pOI1mo3jgk4MN2hz58C3W9kLDqbvyQ391Tv6bFFEa4phioQBoll96K9gMrmhgtw24J1Yzx64Zh2OV7FCpB3jre
 c6Ai1X+1
 DdzqsagHT7CYFw0htWC90fuXGmpeCSS3G9pW1SZYJRsqhMT7qUQVru7C37uX2F1TBgD0Kp5GJABlDcXRVwb+BR/hlMfv/ZRw7WTxtfyevtKKNnexmd1OHb6gay2YJGclFP01iJgzCeJvLdWu9j1v0tV29FHqar1Iheyfc/Wgha8B2IpbG53BlRxKk3+jIBb+rQob48uXPDGSdeALsN9nlK3K25jSHQn1RefBU4JIT02ZeQ/nyXg/P6KoEtUa5Jf7KOQKFnzmIv6DfhzKK1ed0g4ITNInSDXSzTEPJCnFv2okocezfaLmyORcS3E2Yjfg3dW0ZAqhEThCV3PPE+EGdPjeyLo/FP18R21X+2s7lknGIt1BbcaXKkkHxYVTHCnrzxofGip9ZlW3pw+ECTTK94G4ojQroaZ3mTVMofn77KueUoGM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 1:32=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> Acked-by: Chris Li <chrisl@kernel.org>
>
> Chris
>
> On Wed, Aug 6, 2025 at 9:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Fragment clusters were mostly failing high order allocation already.
> > The reason we scan it through now is that a swap slot may get freed
> > without releasing the swap cache, so a swap map entry will end up in
> > HAS_CACHE only status, and the cluster won't be moved back to non-full
> > or free cluster list. This may cause a higher allocation failure rate.
> >
> > Usually only !SWP_SYNCHRONOUS_IO devices may have a large number of
> > slots stuck in HAS_CACHE only status. Because when a !SWP_SYNCHRONOUS_I=
O
> > device's usage is low (!vm_swap_full()), it will try to lazy free
> > the swap cache.
> >
> > But this fragment list scan out is a bit overkill. Fragmentation
> > is only an issue for the allocator when the device is getting full,
> > and by that time, swap will be releasing the swap cache aggressively
> > already. Only scan one fragment cluster at a time is good enough to
>
> Only *scanning* one fragment cluster...

Thanks.

Hi, Andrew, can help update this word in the commit message?

>
> > reclaim already pinned slots, and move the cluster back to nonfull.
> >
> > And besides, only high order allocation requires iterating over the
> > list, order 0 allocation will succeed on the first attempt. And
> > high order allocation failure isn't a serious problem.
> >
> > So the iteration of fragment clusters is trivial, but it will slow down
> > large allocation by a lot when the fragment cluster list is long.
> > So it's better to drop this fragment cluster iteration design.
>
> One side note is that we make some trade off here. We trade lower
> success rates >4K swap entry allocation on fragment lists with overall
> faster swap entry time, because we stop searching the fragment list
> early.
>
> I notice this patch will suffer from fragment list trap behavior. The
> clusters go from free -> non full -> fragment -> free again (ignore
> the full list for now). Only when the cluster is completely free
> again, it will reset the cluster back to the free list. Otherwise
> given random swap entry access pattern, and long life cycle of some
> swap entry.  Free clusters are very hard to come by. Once it is in the
> fragment list, it is not easy to move back to a non full list. The
> cluster will eventually gravitate towards the fragment list and trap
> there. This kind of problem is not easy to expose by the kernel
> compile work load, which is a batch job in nature, with very few long
> running processes. If most of the clusters in the swapfile are in the
> fragment list. This will cause us to give up too early and force the
> more expensive swap cache reclaim path more often.
>
> To counter that fragmentation list trap effect,  one idea is that not
> all clusters in the fragment list are equal. If we make the fragment
> list into a few buckets by how empty it is. e.g. >50% vs <50%. I
> expect the <50% free cluster has a very low success rate for order >0
> allocation. Given an order "o", we can have a math formula P(o, count)
> of the success rate if slots are even randomly distributed with count
> slots used. The >50% free cluster will likely have a much higher
> success rate.  We should set a different search termination threshold
> for different bucket classes. That way we can give the cluster a
> chance to move up or down the bucket class. We should try the high
> free bucket before the low free bucket.
>
> That can combat the fragmentation list trap behavior.

That's a very good point!

I'm also thinking about after we remove HAS_CACHE, maybe we can
improve the lazy free policy or scanning design making use of the
better defined swap allocation / freeing workflows.

Just a random idea for now, I'll keep your suggestion in mind.


> BTW, we can have some simple bucket statistics to see what is the
> distribution of fragmented clusters. The bucket class threshold can
> dynamically adjust using the overall fullness of the swapfile.
>
> Chris
>
> >
> > Test on a 48c96t system, build linux kernel using 10G ZRAM, make -j48,
> > defconfig with 768M cgroup memory limit, on top of tmpfs, 4K folio
> > only:
> >
> > Before: sys time: 4432.56s
> > After:  sys time: 4430.18s
> >
> > Change to make -j96, 2G memory limit, 64kB mTHP enabled, and 10G ZRAM:
> >
> > Before: sys time: 11609.69s  64kB/swpout: 1787051  64kB/swpout_fallback=
: 20917
> > After:  sys time: 5572.85s   64kB/swpout: 1797612  64kB/swpout_fallback=
: 19254
> >
> > Change to 8G ZRAM:
> >
> > Before: sys time: 21524.35s  64kB/swpout: 1687142  64kB/swpout_fallback=
: 128496
> > After:  sys time: 6278.45s   64kB/swpout: 1679127  64kB/swpout_fallback=
: 130942
> >
> > Change to use 10G brd device with SWP_SYNCHRONOUS_IO flag removed:
> >
> > Before: sys time: 7393.50s  64kB/swpout:1788246  swpout_fallback: 0
> > After:  sys time: 7399.88s  64kB/swpout:1784257  swpout_fallback: 0
> >
> > Change to use 8G brd device with SWP_SYNCHRONOUS_IO flag removed:
> >
> > Before: sys time: 26292.26s 64kB/swpout:1645236  swpout_fallback: 13894=
5
> > After:  sys time: 9463.16s  64kB/swpout:1581376  swpout_fallback: 25997=
9
> >
> > The performance is a lot better for large folios, and the large order
> > allocation failure rate is only very slightly higher or unchanged even
> > for !SWP_SYNCHRONOUS_IO devices high pressure.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Acked-by: Nhat Pham <nphamcs@gmail.com>
> > ---
> >  mm/swapfile.c | 23 ++++++++---------------
> >  1 file changed, 8 insertions(+), 15 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index b4f3cc712580..1f1110e37f68 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -926,32 +926,25 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si, int o
> >                 swap_reclaim_full_clusters(si, false);
> >
> >         if (order < PMD_ORDER) {
> > -               unsigned int frags =3D 0, frags_existing;
> > -
> >                 while ((ci =3D isolate_lock_cluster(si, &si->nonfull_cl=
usters[order]))) {
> >                         found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> >                                                         order, usage);
> >                         if (found)
> >                                 goto done;
> > -                       /* Clusters failed to allocate are moved to fra=
g_clusters */
> > -                       frags++;
> >                 }
> >
> > -               frags_existing =3D atomic_long_read(&si->frag_cluster_n=
r[order]);
> > -               while (frags < frags_existing &&
> > -                      (ci =3D isolate_lock_cluster(si, &si->frag_clust=
ers[order]))) {
> > -                       atomic_long_dec(&si->frag_cluster_nr[order]);
> > -                       /*
> > -                        * Rotate the frag list to iterate, they were a=
ll
> > -                        * failing high order allocation or moved here =
due to
> > -                        * per-CPU usage, but they could contain newly =
released
> > -                        * reclaimable (eg. lazy-freed swap cache) slot=
s.
> > -                        */
> > +               /*
> > +                * Scan only one fragment cluster is good enough. Order=
 0
> > +                * allocation will surely success, and large allocation
> > +                * failure is not critical. Scanning one cluster still
> > +                * keeps the list rotated and reclaimed (for HAS_CACHE)=
.
> > +                */
> > +               ci =3D isolate_lock_cluster(si, &si->frag_clusters[orde=
r]);
> > +               if (ci) {
> >                         found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> >                                                         order, usage);
> >                         if (found)
> >                                 goto done;
> > -                       frags++;
> >                 }
> >         }
> >
> > --
> > 2.50.1
> >
> >
>

