Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A05AFA1FFD
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 21:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304FD6B0088; Wed, 22 Apr 2026 17:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD4B6B008A; Wed, 22 Apr 2026 17:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A096B008C; Wed, 22 Apr 2026 17:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1134C6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 17:19:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA4C78ADBD
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:19:21 +0000 (UTC)
X-FDA: 84687457722.22.4FF00E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3171C0016
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:19:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BWLKGprp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776892759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dyh2pqsZK3XgHaNIYiKNX2Zg1KRyIJi0zS0rOrlI+o=;
	b=R9r5w68qBjQMEk5DcP4z6OlhnTQAEA7C9m50fwCll+1fGQPBgd3d5vyP7VXQh0pAGCrJ+b
	o7yq6NpLVQ4ZiOPdaNZ6eI83nPykMC19ERVhg2UN5u8LX7d1vAUMt6RrAXKFLPw3GTZnZH
	L+Yaktx3pbaP8TfR2LKt0jw6PCHlLd4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BWLKGprp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776892759; a=rsa-sha256;
	cv=none;
	b=neSnXpOsVFqNYcbR8edOGpELXOmF7OK+wtKxOHR9DkNWEYysOEHK8t0jhJNtvocNQ7VqBt
	rWZR2qBn/U2TSzvi3uA+TOv8/kK40Dr/8fblpj1fDx0IDZqrvU69dCE8SyoGOQs1Q3ZexG
	CCSoQivR4wTkQk4uZx2jMxUd+WqVMdE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6855A4471D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C50AC4AF09
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776892758;
	bh=bumJ5LT6XkxvHjcx+8KQvvxNPQmwpdknWft8NJaaegY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BWLKGprpcpNtu6hJgFrBpChV1lghVQIQCL9RM/CwhesEEGEddUlrxaTms5Qma8vnP
	 7PyycN6rAzqvUNOQ6p1z94+WHpf1Ehz4SqO+0mpWx9jaWLDNq+Agpe6Vk+eJyMcFLf
	 2ojLbxanjl40ILOPN1I38AtJsmQ0Jyklzcz/L+Ycu69DWjgxU4zKTR22UujrWRHvBv
	 Bdg/NGFy1ELmGKVYEoKXrU0kYig9E5YGqPQw27W33dp92JchyAPDk6vNGxo6s8fNnT
	 qmg63dD0+5XWSGb2z+tRbtOoj/6pi7wSBl5v8DsMBmhDBgP3Jju3ZohX5CrDoSJ87R
	 hmz8qxfxzvTew==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8a3b0242631so71720546d6.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:19:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9KuYajsD4eu/5w8UM0gXk6GnBh+hF71zo7JWLt5Cuud5DQ436o19Pda6reibBgO7EPFATEYl5KWQ==@kvack.org
X-Gm-Message-State: AOJu0YwmW+0++RFIgE8kh1gsklY6r/sqdf+tVRBQH9Vs1Ku+tJZ2x3KQ
	r/9/pSsVqqhareNub9DO+BAeU9+kOODPDGA25PAoC7r3aFJbkey9GKEWElAsUh9FQd7raim5udf
	PchWqBVvJcDdXdDAg2/BXLgapVSIuvjg=
X-Received: by 2002:a05:6214:4a90:b0:89c:4c6b:4615 with SMTP id
 6a1803df08f44-8b027fd979fmr384175966d6.8.1776892757234; Wed, 22 Apr 2026
 14:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260422021842.78495-1-baohua@kernel.org> <aejtfpBUu7gNV6Tk@cmpxchg.org>
In-Reply-To: <aejtfpBUu7gNV6Tk@cmpxchg.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 23 Apr 2026 05:19:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x9vkv2G7d-gANf8kqUJVxQh_P9=AJxr98LFUgQeOTqow@mail.gmail.com>
X-Gm-Features: AQROBzDreH8s0H2BqHgtnbBa_odbJkPeq8mvT6AzuGwRvcSIIZncCX6HZFsQHiU
Message-ID: <CAGsJ_4x9vkv2G7d-gANf8kqUJVxQh_P9=AJxr98LFUgQeOTqow@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm: Improve pgdat_balanced() to avoid
 over-reclamation for higher-order allocation
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Wang Lian <wanglian@kylinos.cn>, 
	Kunwu Chan <chentao@kylinos.cn>, Wenchao Hao <haowenchao22@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A3171C0016
X-Stat-Signature: zq13kj7xaqu9jsafzw698b9du68b4oge
X-HE-Tag: 1776892759-610539
X-HE-Meta: U2FsdGVkX1/7GeqmHfzrCup7EegIqeyZUhw9hNwnVyQWzmEAesDBpG1kvbqRvYPnUxAlwYigH4Ghku3vf6qSAoY76Tt28ZQL5CasuPqhiImAF6TTyfEqDiLQfZa7gQqLhGbYBY+Hq63Fje+jx0PbB5kx+pOCGmbE+jMQdMUhBuMoLMOTcLDu0LZewYhPwGI9uyqJednkBOhVyywqehAyxZQFDSDB5sOMCltfF91iIcJbtdCCKSsEiCdv9/JRspKBcc6IlzIJDfCG1KES8PCURVaxQ4OTDse1pFcMjbU5ZQt0zRxnOSehqBK+z9R2abQsIyzgGuCsa1i+J4mm2pL4RY31ytjRDLj11aq4wt+tYibfx9UOkO9V0c26QWqVkwNjwGeMpSy2xr+a5pBl9vrhGL7/7RxGI6Jxozuwemt48emBmIx3m6Fw8G2tdodrTOjJNiouS8m0gQn4mR8A6MTR7XnZdDF4igdC7jVkEOQIoVKZH4GzESf2dZEztpQBn6hwqnlIaJmwVClwVrKa1JUzHe5AB+aVi1BrtxMboMyfLPf2JxIJgV9NNjhzLMXmmSTYzG/SRR+3HymCQJm6/MEvI5658NUfxMPjv+gagQK1QcRpQYX0wldMjIEdq8LiYIdOksmmigd9TEsEWExkgnQFXiesmk+6Guoxtid6RRfuDKVa3HisNug73yMx7jrn5bQHpMKziS572HIJZxw+odWrFaTVHVILhy4ZEAnQPW1qPFAOnD/hbf31vM7gG4E5sGqyCkzq3aQxR0qSqJpSMGqZeF5MCNs2fVmvWAtBoEMysvfObmND8gFAwBnB95z4D0/QwA4lVz6jkPo37CuhC9bUoTys3Og2XzOAz6vk50MCybkVqvIGclsiNUYY9Et3GEbggxamJq0WmE643bQslhFsjLEbHWqVjaUzyXxUHaqOIi4nquynEGCR9UOD0R6jPjET/bxr75Ow1JVQ5jfyJlg
 k3qkgCzs
 msuCCXIa9IZ+JqHGc7BxNEJybs/7OgRzduS/JwpJCgfFApcuRixdas5UdD9JNmWWRgC82/+2YvP6r28J9+/nPLhdN+IvEpJORZ+Lq2JaM2GCW5CKcWHRiaUT7PlFS44HmiWiS51NzRZaVlCmLU7hYSFRHDdlB+RmW+Khux7u+6getfQHEVqyeR6nedNnEVS+AskpSiyDhO3LaxgRpj9+7Ro+tigDvWOehxBJ0KfI7E0uvo+U1Hj0EcLC9VIlQOX0bf1JKHjyBftl0fHMKln7oTiq+SjIAxMXiPZFHmYiC29pY0iIvz84UbRxN4zvu/xbr7pAzBLgvJKqteS7lEkiWsqeqzLMwoOApBu77a1lKh+ocBr0qsV3v5zQ4KHA4ofHdwtQ59H5wHtOg1WkiThuGht2ItqQfssUAA5WdiZBetfqtBlL8aiFecoHUE7IPCS1f1i1WfqZihSwHqHlwv8TtEIpi3OI119U5vx/bkvw0LWgGdKt1NhdB3Esc8zYwnc+XfR7djFV5k3Z+w3NcO1vtI1OdgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 11:47=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> Hi Barry,
>
> On Wed, Apr 22, 2026 at 10:18:42AM +0800, Barry Song (Xiaomi) wrote:
> > We may encounter cases where the system still has plenty of free
> > memory, but cannot satisfy higher-order allocations. On phones, we
> > have observed that bursty network transfers can cause devices to
> > heat up. Baolin and Kairui have seen similar behavior on servers.
> >
> > Currently, kswapd behaves as follows: when a higher-order allocation
> > is issued with __GFP_KSWAPD_RECLAIM, pgdat_balanced() returns false
> > because __zone_watermark_ok() fails if no suitable higher-order
> > pages exist, even when free memory is well above the high watermark.
> > As a result, kswapd_shrink_node() sets an excessively large
> > sc->nr_to_reclaim and attempts aggressive reclamation:
> >
> >  for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
> >       sc->nr_to_reclaim +=3D max(high_wmark_pages(zone), SWAP_CLUSTER_M=
AX);
> >  }
> >
> > We have an opportunity to re-evaluate the balance by resetting
> > sc->order to 0 after shrink_node() with the following code
> > in kswapd_shrink_node():
> >  /*
> >   * Fragmentation may mean that the system cannot be rebalanced for
> >   * high-order allocations. If twice the allocation size has been
> >   * reclaimed then recheck watermarks only at order-0 to prevent
> >   * excessive reclaim.
> >   */
> >  if (sc->order && sc->nr_reclaimed >=3D compact_gap(sc->order))
> >       sc->order =3D 0;
> >
> > But we have actually scanned and over-reclaimed far more than
> > compact_gap(sc->order).
>
> Do you have traces for how much it overshoots?

I previously worked for a company that had some data. I=E2=80=99m no
longer engaged with them, but I=E2=80=99m trying to recollect the data
on a new platform I recently moved to. My impression is that
when over-reclamation occurs, the amount of free memory is
actually much higher than what compaction_suitable() would
indicate.

Will present the data once recollection is complete with the
help from Wenchao.

>
> > If higher-order allocations continue, we may see persistently high
> > kswapd CPU utilization coexisting with plenty of free memory in the
> > system.
> >
> > We may want to evaluate the situation earlier at the beginning.
> > If there is plenty of free memory, we could avoid triggering
> > reclamation with an excessively large sc->nr_to_reclaim value
> > and instead prefer compaction.
> >
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Kairui Song <kasong@tencent.com>
> > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > Cc: Yuanchu Xie <yuanchu@google.com>
> > Cc: Wei Xu <weixugc@google.com>
> > Co-developed-by: Wang Lian <wanglian@kylinos.cn>
> > Co-developed-by: Kunwu Chan <chentao@kylinos.cn>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  -RFC v1 was "mm: net: disable kswapd for high-order network
> >   buffer allocation":
> >  https://lore.kernel.org/linux-mm/20251013101636.69220-1-21cnbao@gmail.=
com/
> >
> >  mm/vmscan.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index bd1b1aa12581..4f9668aa8eef 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -6964,6 +6964,13 @@ static bool pgdat_balanced(pg_data_t *pgdat, int=
 order, int highest_zoneidx)
> >               if (__zone_watermark_ok(zone, order, mark, highest_zoneid=
x,
> >                                       0, free_pages))
> >                       return true;
> > +             /*
> > +              * Free pages may be well above the watermark, but if
> > +              * higher-order pages are unavailable, kswapd may still
> > +              * trigger excessive reclamation.
> > +              */
> > +             if (order && compaction_suitable(zone, order, mark, highe=
st_zoneidx))
> > +                     return true;
>
> I've tried this in the past, but it was regressing huge page requests
> under memory pressure and with higher levels of concurrency:
>
> https://lore.kernel.org/linux-mm/20250411182156.GE366747@cmpxchg.org/
>
> The compaction gap is sized for a single allocation, but
> kswapd/kcompactd are a shared resource for potentially hundreds or
> thousands of incoming requests. So if there is high demand for
> contiguous memory this isn't enough - kswapd gives up too early,
> kcompactd efficiency drops, you get storms of direct
> reclaim/compaction, and still poor allocation success rates. Continued
> kswapd wakeups mean that there is ongoing unsatisfied demand. The
> system has to keep moving forward.

I guess one possibility is to check whether the gap is much
larger than compaction_gap(), to ensure there are sufficient
gaps.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4f9668aa8eef..428ec7266aab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6969,6 +6969,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int
order, int highest_zoneidx)
                 * higher-order pages are unavailable, kswapd may still
                 * trigger excessive reclamation.
                 */
+               mark +=3D 2 * num_possible_cpus() * compact_gap(order);
                if (order && compaction_suitable(zone, order, mark,
highest_zoneidx))
                        return true;
        }

On the other hand, =E2=80=9Congoing unsatisfied demand=E2=80=9D may not alw=
ays
make sense. For example, network code may first try higher
orders with the kswapd flag but without the direct reclamation
flag, and then quickly fall back to order-0 allocations if the
higher-order allocation fails. In many cases, higher orders do
not improve network performance, while kswapd performs
unnecessary reclamation and may further trigger more refaults.

>
> That said, it's well possible that we're overshooting that progress
> buffer due to running reclaim scans with a high order. It might be a
> better idea to look into that?

I could investigate this further, but I suspect it is mainly
because we set a very large nr_to_reclaim, assuming we want to
reach the high watermark, while we may already have been above
the high watermark in kswapd_shrink_node()?

        /* Reclaim a number of pages proportional to the number of zones */
        sc->nr_to_reclaim =3D 0;
        for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
                sc->nr_to_reclaim +=3D max(high_wmark_pages(zone),
SWAP_CLUSTER_MAX);
        }

A rough look suggests another place where high-order may affect
scanning is here:

static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *s=
c)
{
        int i;
        enum zone_watermarks mark;

        if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc->or=
der)))
                return true;
       ...
}

So maybe we set something like the following instead, if we are
actually above the high watermark and are only short of
high-order pages?

sc->nr_to_reclaim =3D min(sc->nr_to_reclaim, 2 * compact_gap(sc->order))

Anyway, let me take a closer look.

Thanks
Barry

