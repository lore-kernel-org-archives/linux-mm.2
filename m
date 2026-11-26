Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE8F606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HOoX5cdp
Received: by kanga.kvack.org (Postfix)
	id 1E79A6B05B3; Thu, 26 Nov 2026 06:51:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BECE6B05B4; Thu, 26 Nov 2026 06:51:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5416B05B5; Thu, 26 Nov 2026 06:51:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5AC96B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:51:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69C111C424C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:51:19 +0000 (UTC)
X-FDA: 85477104678.08.30D8CD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7744920008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:51:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOoX5cdp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795693877;
	b=YlPZ6K+4gcIA/M1rn+T4a2LdAbdVN/ykvBxZzuNt0DdQcTbR5cyOB0pM/TQapGUDJ1gyta
	81Qa5MWmJ7Mp3N6rEL13BaPcVoLnRNCuCyCYnFP9acutMBQkxIwNqnHGzhzU1CQqWKJuRg
	QseIporPi2NVWGcxN0jGLM8K2mp7xgY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795693877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liE+IJazZ5oAskLl1TgZ0dicfhbRnZKFpT1xxjcaIV4=;
	b=MXbdCVGyvIfsJJ1bZlbQoHZ3wmZf4+HJRDD5tzdVDW6hMzFh5C6Nj6AiyoEaI2ne0ZPgq1
	PejvbwIWUaQmmLH9CiimwP+Rj2IUiGB+D3sTjaDTcaWdC9ybOAbzNVdZ8V/x5LTdUiSjD1
	Mpr3we0eU1x2SZW5zR/me4J1rUMWiNY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOoX5cdp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A66144387E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2141F000C0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795693876;
	bh=liE+IJazZ5oAskLl1TgZ0dicfhbRnZKFpT1xxjcaIV4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HOoX5cdpqas6YaDLda8NQPo9m3BoYqastRShJFtlPinlbdYA/wwwznMIoUGv1Ifof
	 KXU4+LtHUMdigAw3VE9xJKiMDYUdiJZdZ7ddH4z+OQu/2PEUDHBHPZpHPRKpBex+6B
	 zdMYSrrr59RauaqIffrbCUjFZlCbeJxmAYJ1SsHoQBZOFW8zEnDLf0Mn6tyf39vo0p
	 TcyLdkNJrFKIBb0Jd5B6dPS0gOgKvKrwuJglVkkq8+FCWD0HgAgHryW+lPGLnebdgF
	 gpULuv4dSTAkxH8tkaKlWmY1Kv4avapmm4PzR/9/PkW1HmgnhBNaBDhzd8BKUCVfqF
	 9a1z0XRdggkEw==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-930c0f9c1b1so727211485a.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:51:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH5z76MweneRV8Dvk5OtZLc8CyN4cVWEsUCoGzQ/p04usciQMzwOzXNf1x+sU48xrUPRbd6c/roBg==@kvack.org
X-Gm-Message-State: APuU4Z9VTCWZYrVcBMk6uPEzE/pOhFo1j1ulJlpSPsXllI1QZhIl3Gp/
	cuDp7YhavyhFJRvyFv8GyG1XTW2qFOGpzsZ8jL39jMSc/nj9ygaE/8khUImv4cUQIhjKhA54FaV
	Se1s47aqNeU63SCKh0m/5adEOHmZNlHg=
X-Received: by 2002:a05:620a:29c8:b0:949:7270:b95 with SMTP id
 af79cd13be357-949baa0b256mr3618065185a.32.1795693875794; Thu, 26 Nov 2026
 03:51:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125-fix-mglru-kswapd-age-v2-1-4cc37437af9b@tencent.com>
 <CAGsJ_4z-UdXQg0LYqymEZdoHALPmAZC7eGcXbGad6f0sdjmkcw@mail.gmail.com>
 <awarDrT/DT7tQu+U@lima-default> <CAGsJ_4zf5NabZJanr2_Czr3oVQe6tTTdXmddx+PxowbKBN9M8Q@mail.gmail.com>
 <awgCInIqygIBMRGt@lima-default>
In-Reply-To: <awgCInIqygIBMRGt@lima-default>
From: Barry Song <baohua@kernel.org>
Date: Thu, 26 Nov 2026 19:51:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wBuFz=Nxn=aiwUONerkJVgwKVyp0sbfg0tSa=J=VCo+g@mail.gmail.com>
X-Gm-Features: Aa3M54rmeYOf-N8Nk_jy_G3CeuifqjF8MjvxO4s3hxNTXy0zU7zsvhgvahj5T2Q
Message-ID: <CAGsJ_4wBuFz=Nxn=aiwUONerkJVgwKVyp0sbfg0tSa=J=VCo+g@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: skip oom killing for order != 0 allocs in kswapd
To: Bingfang Guo <bfguo@icloud.com>
Cc: bingfangguo@tencent.com, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9uft4qhtfrzdekswbht7r7sd6hu7n787
X-Rspamd-Queue-Id: 7744920008
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795693877-712392
X-HE-Meta: U2FsdGVkX1/z1rf3H4snDVD903Atzk4BE8ETFw9spGfEVdz7JCUwEq5Kf84jI97QpoSW3y97KmpksSTH/HtJAXq09wShsvUuRse5Ni2xKjEz01YDrIq8i310DabpREfHuJLDZZrrPIOoRyLIg9/8+3Kcn4ZZIPzmkv64MncaneT2P30JUXAxVW+CL0pNk3sxU9wouxitOp4mlwap65cI4pk6HsQpTYu72tORM8LH1pCKvYLmaZamo5oTNCB9UEK7BISZe8lhzkq0t77Oh+iRvFaDHwKvh/pcvWjiz78PZISvMKAhCcWRfyyQEYecTqo+yN4Y9HTGNa2s9ivtGkweGrLpKc0Ki1Q5Qow4+7ae0e1+JZgYaiiIX0DpAqjqIloCl2QopVbKZlIYX95O2FYqV1zNhI+LYXQdcfD0SdNOarqC1qX+irwTGFN/2lPO4358CP9ztaD78vl3pIf7ElrQWAdXiYjbOJHROOvBPOfr++xqYuJLtb8OSaHzhSCRZZoEVJq95Uyr5yI7wstm0YPtiy6vfCrDECAiGYQ0CO2sh+JA6lldrKrUPELzvR3jV3rqdVuQw5Wu8vuPZ323YGlkvRmChZUg6oL6gKUAWvaL4IjafvcOBKBZe6Jk4dG54csd8+AGz0QXbd/Nd8z7toeIEm6SVGjuwMzx6Be1HeXlKorvPVDXrce8HMNqlapjJXI2jmsgSkjtXebExIesV5C7HmfjUb1zq/cLGzeS0DJ20NPTMQnP1+DzKhsptUD+e4EknNw4AVEYIEiMMWzFGYjWAFskRJiAMNcQ7NW+fcmayJAnpAzOpwZXAch2hv5XWGinSKUPkMpcXSIgah3HmHBjChT40fW2rPuqfEDPbcARxOyBU3wgM3APd+WPeU3bErUXTu0zd240ZAzU4L8H8TVWkjw3jDUoAj1LJpqokuA0zuspvAwsSuMaYzv7mXV+ALyggotQGR9VgwSw3yvmfBW
 JchTh6kZ
 DR3Hylg1E0TFvgcGBPfaktjmS8gcIccFutd/1L7PPwpqEn5aEXZ60lUYx33CBDXGdJnUve7H6SglylbGRxgMI/BNrGyeYISh8eLcxKaEXaCVzghg0jEEU0781way4Kjv6qae2rRZbYDaSKr0NHobmSk04Z97irBGvq8Rd0P9V+nPwRd58WbpHH6sHLTtcZtPFc49ClCwPqJ7qosce+SkoAya45seT0zqGwo45ADf8s9p6C5Witk5yA/2nk9reuuWC8WgV4vCF4m3Uiu6NMJsu+znc+IiceGe2ORcfIcMO5/2qkhBE8i3oAlorzM3T5+NngMqBreRBpQNK0jCjePEHrVUAWbNtGJnEo07HW+tGYqOKVKyG4QDPj1WZHty9D/ee49jqC3MgHo+4XBMVIG8DgS/2cMl5HJACxDt9UP0CNuwbjJRbqfx3dmQQosxl5eF4zxJN98Zrt2rm1rJKOniwB489Mcp5hqCJqUuo1PxJjUay/81Wut/dvnmlIu9vT2epGbuxhWWXix4wWjszCn4KyXRfoiR/EsCIUtn9zOphF44HTXJiv9diKitsLnXE45ySipZEJYU9y2/YZQiknvAqj/l+jZbMBYgFbqe32WpooJAcAupJTpEK3Y5LLp1AOiNTe4gNxhfi5G1QulWYDPY/in+zeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 5:56=E2=80=AFPM Bingfang Guo <bfguo@icloud.com> wro=
te:
>
> Hi, Barry!
>
> On Thu, Nov 26, 2026 at 08:40:44AM +0800, Barry Song wrote:
> > On Wed, Nov 25, 2026 at 5:32=E2=80=AFPM Bingfang Guo <bfguo@icloud.com>=
 wrote:
> > [...]
> > > You are right. Maybe we can start from skipping aging in reclaim path=
 if the
> > > youngest gen is still too young? And maybe for this path, min_ttl can=
 have a
> > > default value? Is that a good idea?
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index d891ae46baf49..7f9b14b772d14 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -5136,8 +5136,11 @@ static bool should_run_aging(struct lruvec *lr=
uvec, unsigned long max_seq,
> > >                 return false;
> > >
> > > +       /* avoid excessive aging for huge allocations */
> > > +        if (unlikely(sc->order)) {
> > > +               int gen =3D lru_gen_from_seq(max_seq);
> > > +               unsigned long birth =3D READ_ONCE(lruvec->lrugen.time=
stamps[gen]);
> > > +               return !time_is_before_jiffies(birth + min_ttl);
> > > +        }
> >
> > I'm not convinced that we need to couple the aging decision with
> > min_ttl protection.
> >
> > This has been a long-standing problem: high-order allocations can
> > trigger excessive reclaim and still fail to obtain contiguous
> > memory.
> >
> > I've tried to address this twice, but haven't found a satisfactory
> > solution yet:
> >
> > https://lore.kernel.org/linux-mm/20260422021842.78495-1-baohua@kernel.o=
rg/
> >
> > Johannes shared some thoughts on this here:
> >
> > https://lore.kernel.org/linux-mm/aejtfpBUu7gNV6Tk@cmpxchg.org/
> >
> > Do you have any traces showing how many pages kswapd scans and
> > reclaims while kcompactd makes little progress toward satisfying
> > order-9 allocations?
>
> We encountered this problem when running a stability test on a 6G
> VM with 2 nodes. It populates the system with hwpoisoned pages
> per 511 pages so order-9 migrations should mostly fail. Then it
> tries to allocate order-9 pages. So the results might not quite
> reflect real scenarios, but I think that applies to unmigratable
> pages such as slab as well.
>
> When the system OOMs and kills all the processes, we have about
> 4.8 GiB memory free and:
>
> PGSCAN_KSWAPD                 : 162,406,932
> PGSTEAL_KSWAPD                : 91,233,588
> COMPACTMIGRATE_SCANNED        : 6,542,604,811  (kcompactd: 4,041,105,566,=
 61.8%)
> COMPACTFREE_SCANNED           : 541,265,798    (kcompactd: 348,448,520, 6=
4.4%)
> COMPACTISOLATED               : 174,688,832    (2.67% of migrated)
> PGMIGRATE_SUCCESS             : 100,824,439
> PGMIGRATE_FAIL                : 2,022,069
>
> So seems in this case, compaction fail rate is quite high and we
> have really many scanned pages compared to the actually used size
> (about 1G).
>
> >
> > Basically, I think we need some form of throttling to prevent
> > kswapd from freeing more and more memory when there is already
> > plenty of free memory, yet compaction is making little progress
> > toward satisfying order-9 allocations.
> >
>
> Yes! And I've read your and Johannes's previous discussions. It
> also seems weird to me to keep reclaiming even if there are
> plenty of pages available there. And it's quite tricky to balance
> between that and concurrency...
>
> Looking into shrink path in kswapd,
>
>         sc->nr_to_reclaim +=3D max(high_wmark_pages(z: zone), SWAP_CLUSTE=
R_MAX);
>
> I think this is too much, for this case. So I think maybe we can
> still reclaim for scalability, but reduce its target. At least we
> should take reclaimable memory size and free memory size into
> consideration, and rescale nr_to_reclaim.

So, conceptually, is this along the lines of what we have in mind?
I'd also be interested in hearing Johannes's thoughts on this.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 81797b71228f..0144fe4be738 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7450,17 +7450,31 @@ static bool prepare_kswapd_sleep(pg_data_t
*pgdat, int order,
  * This is used to determine if the scanning priority needs to be raised.
  */
 static bool kswapd_shrink_node(pg_data_t *pgdat,
-                              struct scan_control *sc)
+                              struct scan_control *sc,
+                              int highest_zoneidx)
 {
        struct zone *zone;
        int z;
        unsigned long nr_reclaimed =3D sc->nr_reclaimed;
+       bool can_compact =3D sc->order > 0;

        /* Reclaim a number of pages proportional to the number of zones */
        sc->nr_to_reclaim =3D 0;
+
        for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
+               unsigned long mark =3D high_wmark_pages(zone);
+
+               if (can_compact && !compaction_suitable(zone,
sc->order, mark, highest_zoneidx))
+                       can_compact =3D false;
                sc->nr_to_reclaim +=3D max(high_wmark_pages(zone),
SWAP_CLUSTER_MAX);
        }
+       /*
+        * If all eligible zones are already suitable for compaction,
+        * limit further reclaim to avoid over-reclaiming due to
+        * fragmentation.
+        */
+       if (can_compact)
+               sc->nr_to_reclaim =3D min(sc->nr_to_reclaim,
compact_gap(sc->order));

        /*
         * Historically care was taken to put equal pressure on all zones b=
ut
@@ -7637,7 +7651,7 @@ static int balance_pgdat(pg_data_t *pgdat, int
order, int highest_zoneidx)
                 * enough pages are already being scanned that the high
                 * watermark would be met at 100% efficiency.
                 */
-               if (kswapd_shrink_node(pgdat, &sc))
+               if (kswapd_shrink_node(pgdat, &sc, highest_zoneidx))
                        raise_priority =3D false;

                /*

Thanks,
Barry

