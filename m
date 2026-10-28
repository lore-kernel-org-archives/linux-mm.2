Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C95606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Rfe9PynZ
Received: by kanga.kvack.org (Postfix)
	id 28EAC6B00EF; Wed, 28 Oct 2026 16:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F486B05B1; Wed, 28 Oct 2026 16:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E4C6B05B2; Wed, 28 Oct 2026 16:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0E946B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:10:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80AA61A01FD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:10:59 +0000 (UTC)
X-FDA: 85373128638.06.F9BC009
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8019A4000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:10:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Rfe9PynZ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/+CeRbT0qyE1g9JY9xgqgOlku9IIi6fz6AQMBy+up4=;
	b=2s7m5IDSNi/3C6Y8dOuARq2Tq75QwYPH5UCWt4fQkHL1ZIWxrH1UB6O6nb7C5rkga1IcfH
	OW8Z4woVmmkhisrNJ8YHE6HnxVoOYE79DMqt1V9A6bD3RhEr+AGqwr/u5iAVYFVxdj2lrT
	CLar9e0NIvvYgE9wfc1ydfOePJANucc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Rfe9PynZ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793218257;
	b=OvOCS2DyK72nh3unROe1GHvCsqrQsNzNGcsmtlrQ50Wn7i9hKW/vW3jw+OGlz0SfeCQEby
	dm6PiEQS0B8eih/NaEFKISpK7p4jRJH/qgDCcM6YqNtYTPMH51GsrziHkg2IhhPu9ZKvaV
	SRH/IvysB8g7cQ5NmggfcE2oqdbd9II=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a54bba0442so1865e9.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793218256; cv=none;
        d=google.com; s=arc-20260327;
        b=dyLpPxmqOwHDNfr3bd9wRVX7pjCI34MakypSSojM9N531tpT0HErBaJN76kyUS+nnM
         VZBQNluB+7LQgk54VHO4zAZTi5EqM47F+amsxrT8WDAHyfdvirev/ppB3Ki7KnAL+HIa
         Es2nIokJ1N4caJ+NrKf1AF7jrC6r9KPkj4pcIsDFafeKTxBlwA4BVOqoD1kO2Pkr4NBX
         tyDLrcwSCHbvC9GE4P/xowcUB5w+FpvFknmIj/oAdQP289n0QSXOBOJiTHjNhLdQDmbn
         fBJRFDiQ/1iBszUUyowlY5oVtdpclXXxPzcjCOFKo4hfJKIvn2QyePapzsALaReB3llL
         JcNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M/+CeRbT0qyE1g9JY9xgqgOlku9IIi6fz6AQMBy+up4=;
        fh=v+aiG0AdQYNXcFu0zGrAGa+rvd1AQtLjo+zPgN6PxYY=;
        b=hx5qoQ6ANO5CxBJ90r98Qkzbix+qxJiP4MNEURmWD4GywEm3Gxt8T+Tqn3kTgZT53j
         6WHNbg81Ch595tY17Zo7bTM2jjgRq0nHJmRZmHglGHk9L5HGS54EjaGjhXdusMcc5S8M
         ppO6immaCzqQ7NveOOWUamqAeOmihuRuV3S5mg9xFgQ0YOuB9TMUWG1RMbpv3ekY4qQC
         yN1jTZknigBWhxN54+CkjA8oY8WefSvYblW1GW8s348GW+ch+uBvYPhTMQJGY5BIhmHg
         y2CoHcgXKd5EtACPe4iRnNsnzUsxdSnlGAB/trg5QPr9AZIj1IWlo6QhCcZrsMAX363t
         tiHQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793218256; x=1793823056; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M/+CeRbT0qyE1g9JY9xgqgOlku9IIi6fz6AQMBy+up4=;
        b=Rfe9PynZelMP3Ax86uo3FlpBODCClv7avID8sL89iN1RXTojqtBCVNe1Z6E6L1xnmb
         8/jpo+TnFDyGyRip8W8LlpReMd/SphIgAsWGquZryoxUUqPIUcstVXe61REONOwm2phG
         4kqOXS1x03IaKDCswdVXmtymGoyw3OFvXhcquHW/eZUv+0GufeE06DLXTWy8GxkusgSy
         g/kZ5csZc1E/9NOHngUTGnsqEkuq5otH/4/G9GGkHBAPnxHsT0XnYhVNm8vbM6OdKx5F
         28jJxv2/mphvZX7JBFnqXA7glUArYKtejoG1dDntkoMU7p3lzBu9b7y1cNTOE/ZSHwy4
         rPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793218256; x=1793823056;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M/+CeRbT0qyE1g9JY9xgqgOlku9IIi6fz6AQMBy+up4=;
        b=nY5SEPFIZrpg39HhGmbmnOGGPcduQqmfdoZLe4K+iGg8Hmz7wo4unA++UeGOGCR6QY
         hza8cQ7Ov+7hknExYCj/PX6/RwrO1pZm/bCHbPzGOr6GYsKBVI96110WcYMhDHLT9v4w
         lNNq8shqjLTeaBsP5WWPVylFxAhajOoeIrn3+IxeJj+QgeTenuvRNZmuViGcy0x650ZM
         a2I2zw3VWVEfoY6jFP8ffr1yOWMfA0pJxxHIrOC9z+96SyNcEq+KFLgkx4jG/g4HteTR
         4iAzcDpFn0bYqwKau+6qvKSsBp2lpN18PsffCcZNcNhjOHtjoXzHO32mDMKEFep+h+c9
         goTQ==
X-Forwarded-Encrypted: i=1; AKwUvBwtQLSkkIVmE8Z1RihZs07KDo08wrqu+xu9n254xzXGkJ6wCHDCDqkoIJ/0+zdiricZ49n+mtP1yg==@kvack.org
X-Gm-Message-State: AFq9FYKBHvviHK2fMyucJEmKjXDbtnheXZE/CwMUlf9gnTVuf1ayui+e
	yakAqqaapidUcvOE8M35sZWO3lPfKmMSRck4lAazlBg4yJuLdyd8FqXAZvvKXsvK4yzaq+0xH6R
	SqliOualgcsQZRTtZpNmPa5HjUoipqdzMEuP1eTOY
X-Gm-Gg: AYBFou2Fv0IvgFz6//eIxVSbrS3+v/Famk2xRUeOSU3WG+El+AbpMSm09dsKAamXjqN
	lbTHNutILTHAQHyMaZBMfG4NCPFqBlaF/c8s8ATQP0+GnuIXtNpUxLEs0BVkt9XGC7gut/nzKid
	/0hPVF1pHKtVb3dNVomY/29/gWNMxXfyp+MPfuUrM2Rr0QfkNS+saue9P8HaU4rSKIuDMsUkSto
	fyFPaHQDsFSVqe0OBqEm0Tgx+25fD2pdKo3tQpZ6oAteTuz2a1J08Cxh0BVajlG9hE9CwvTkXtM
	s9Ta3IZEKgcRwhhz4z15KF5NwJhUhgcRKybOLy8coRj0jpJ4ceWM0lgIOgOAsaWCD3G0IUBW5Ar
	YfKC1dvF55RRnbgs6B+Xa8srpOnKYHQdT5Fx/EY1zptYtTU1fnVBaH9ljxbH8gK+Jphfu2O3feQ
	sJMfovVVUNCY+/w18kzSxXl5o=
X-Received: by 2002:a05:600c:6048:b0:4a1:e7fc:fed3 with SMTP id
 5b1f17b1804b1-4aa97e58aefmr149895e9.13.1793218255229; Wed, 28 Oct 2026
 13:10:55 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com> <auFerm6kHxeuPFpR@parvat>
In-Reply-To: <auFerm6kHxeuPFpR@parvat>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 28 Oct 2026 13:10:43 -0700
X-Gm-Features: AclHuK_GdOj6cBCMgskUWEzvtIHw2HGovxaKUq0R2OOOuhOoVrm0zxPtUkNd7mU
Message-ID: <CABdmKX1PT4oOKdRMGsWDHZRFmRB3VR9zxgnp8W5QXqhTErFOzg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online() checks
To: Balbir Singh <balbirs@nvidia.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8019A4000A
X-Stat-Signature: xoi5gp67qznfpo7mo3epixjmta8xfcy3
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793218257-142136
X-HE-Meta: U2FsdGVkX19I1w6mrsCL1rj4MuVYWx1P+pkZ+CLGJjULdR48JkNc+Yze6RcMPMA0HPeOZMCKcfzNLf1ZtD54SdRTkYuHILVqwR2KNN5B+snID1k7O+E3V/5hyQqdvM7ntFsjX8do23jp2UXL2QDB2gclq94ysFylHa11UrS6YJ/GUZ4NQbP7VJUrvrSoTHW6UzFhCnv42bSfXPNgXJdIRZfqFWluNdxR88KAuRmxcVstQEVuLXWcOfWeDQQ4GRXcOZrCph3UwLyr51mezwKa1dMQT4w0hm/oP1HYC/BojatQIQZidVnL4Fp6vk30Zd9TrgzXBI3JuZxka/SKOH3MihMuV5ElB8LBxlOiTOq3GayEPJj5kmijoWF0EzRWLwwdjDAuJ/AEFVxQdZDeHgcKfj5KrTMhc9Pb67OecnaUOfh9IPItVYY9bo3ekbaZ1K7+ZkINSRIBsD0/3Jl3BkK6/T1YkAZD3DYTKf9+Cx7M3AzCmNefZPVjP32bHk0+PGKc64BXwjFvOpA0O4QBC0NVKbmZGlCGBTF029zp57n0hN50V6tv5tAfs1s2nwxfFJiS5Rcw6MEMXHu63wFfG70uHTCG3evhD1TmN4J+q1bragU3aJALgww8NquBM56ubagZH3pM20qU0ucTDW0ZsaaqWeLeKaSE4mzuOIqLmaRb3Ss97Z+b3dfhdQOW73dkwFhFIBkhvOfQfJcEbpB8cTq/3pUCVjYGzPz05POfHlhtInhahUgkLABU/5YK0UPNEXMv1l7kMOg5E0qx7pkr3QKC6V3r+CHpeHv0BZiRmzewR6CYsmxu7MOgRXuGjLW8Gnmk8NxUJUWjjN+exCIj/cVEniYyrAYXQ1AfeWg2/p5txeMC/70OuPy1lKqfev0KdZeqpGigCIBcNZ9SHiu7zzqCfelqAMm/WzlUVroacultDhReBjv1YpjgbK3wGxmNpK0xOLdaNWFiIy8vHhKlA1R
 jbql0DNn
 PkmT0NqnLaZG8VqGJO8D+zFVpCDuPe6UkO6loHM4uFe06qblc5am0PWeBrvcCTy314dOiIoM4cTfW2uUuYYiFnZs0xcVsOPv1mHbfFqOPzJknbeplCa/CcBwTzsydLG8l3m5iVs9blL+EEvNv+mVKSujFFBD/9PM3/G5oAlDzqrixj7JmwhAZLU3o0+ipCJlFfvBYxkUc/ym6SylmwnTT02UFCHZmdC7OHMdFAcRYtPH7PszVNVkcYpXub6EYC5JjwhjpKgctiE205njrk0LcNxqzaHtqD71ryEjxDLfIhS6yfIv2wfD3r/eVTWa6xCSXJ5o2CJJ8KwUjsPXnp49LtdLqND2yNVF/4aruLwkSiZSlqmw75es1+QnDxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:32=E2=80=AFPM Balbir Singh <balbirs@nvidia.com> w=
rote:
>
> On Tue, Oct 27, 2026 at 06:06:05PM -0700, T.J. Mercier wrote:
> > Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> > move LRU size accounting on reparenting instead of copying it"),
> > mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> > and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> > memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> > afterwards. A folio that is off the LRU during reparenting looks up its
> > lruvec through its objcg, which now points to the parent so it is put
> > back on the parent's LRU.
> >
> > As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> > when !mem_cgroup_online(memcg) is true, making the offlined memcg speci=
al
> > cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> > code. Remove them.
> >
> > With the get_nr_to_scan() special case removed, an offlined memcg that
> > still has stale effective protection now has
> > apply_proportional_protection() applied like get_scan_count() does, so
> > the MGLRU and traditional LRU behavior is now the same.
> >
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > ---
> >  include/linux/mmzone.h |  8 ++++----
> >  mm/vmscan.c            | 28 +++++-----------------------
> >  2 files changed, 9 insertions(+), 27 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 3b96d6c7123b..7f078ff0dd76 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -638,10 +638,10 @@ struct lru_gen_mm_walk {
> >   * The events that trigger the above operations are:
> >   * 1. The first attempt to reclaim a memcg below low, which triggers
> >   *    MEMCG_LRU_TAIL;
> > - * 2. The first attempt to reclaim a memcg offlined or below reclaimab=
le size
> > - *    threshold, which triggers MEMCG_LRU_TAIL;
> > - * 3. The second attempt to reclaim a memcg offlined or below reclaima=
ble size
> > - *    threshold, which triggers MEMCG_LRU_YOUNG;
> > + * 2. The first attempt to reclaim a memcg below reclaimable size thre=
shold,
> > + *    which triggers MEMCG_LRU_TAIL;
> > + * 3. The second attempt to reclaim a memcg below reclaimable size thr=
eshold,
> > + *    which triggers MEMCG_LRU_YOUNG;
> >   * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LR=
U_YOUNG;
> >   * 5. Finishing the aging on the eviction path, which triggers MEMCG_L=
RU_YOUNG;
> >   * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9959ca158ce8..636152d8c94d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2754,13 +2754,6 @@ static void get_scan_count(struct lruvec *lruvec=
, struct scan_control *sc,
> >               scan =3D apply_proportional_protection(memcg, sc, lruvec_=
size);
> >               scan >>=3D sc->priority;
> >
> > -             /*
> > -              * If the cgroup's already been deleted, make sure to
> > -              * scrape out the remaining cache.
> > -              */
> > -             if (!scan && !mem_cgroup_online(memcg))
> > -                     scan =3D min(lruvec_size, SWAP_CLUSTER_MAX);
> > -
> >               switch (scan_balance) {
> >               case SCAN_EQUAL:
> >                       /* Scan lists relative to size */
> > @@ -2769,14 +2762,8 @@ static void get_scan_count(struct lruvec *lruvec=
, struct scan_control *sc,
> >                       /*
> >                        * Scan types proportional to swappiness and
> >                        * their relative recent reclaim efficiency.
> > -                      * Make sure we don't miss the last page on
> > -                      * the offlined memory cgroups because of a
> > -                      * round-off error.
> >                        */
> > -                     scan =3D mem_cgroup_online(memcg) ?
> > -                            div64_u64(scan * fraction[file], denominat=
or) :
> > -                            DIV64_U64_ROUND_UP(scan * fraction[file],
> > -                                               denominator);
> > +                     scan =3D div64_u64(scan * fraction[file], denomin=
ator);
> >                       break;
> >               case SCAN_FILE:
> >               case SCAN_ANON:
> > @@ -4355,12 +4342,11 @@ static bool lruvec_is_sizable(struct lruvec *lr=
uvec, struct scan_control *sc)
> >  {
> >       unsigned long total;
> >       int swappiness =3D get_swappiness(lruvec, sc);
> > -     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >
> >       total =3D lruvec_evictable_size(lruvec, swappiness);
> >
> >       /* whether the size is big enough to be helpful */
> > -     return mem_cgroup_online(memcg) ? (total >> sc->priority) : total=
;
> > +     return total >> sc->priority;
> >  }
> >
> >  static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_c=
ontrol *sc,
> > @@ -5199,10 +5185,6 @@ static long get_nr_to_scan(struct lruvec *lruvec=
, struct scan_control *sc,
> >
> >       evictable =3D lruvec_evictable_size(lruvec, swappiness);
> >
> > -     /* try to scrape all its memory if this memcg was deleted */
> > -     if (!mem_cgroup_online(memcg))
> > -             return evictable;
> > -
> >       nr_to_scan =3D apply_proportional_protection(memcg, sc, evictable=
);
> >       nr_to_scan >>=3D sc->priority;
> >
> > @@ -5325,13 +5307,13 @@ static int shrink_one(struct lruvec *lruvec, st=
ruct scan_control *sc)
> >
> >       flush_reclaim_state(sc);
> >
> > -     if (need_rotate && mem_cgroup_online(memcg))
> > +     if (need_rotate)
> >               return MEMCG_LRU_YOUNG;
> >
> > -     if (!need_rotate && lruvec_is_sizable(lruvec, sc))
> > +     if (lruvec_is_sizable(lruvec, sc))
> >               return 0;
> >
> > -     /* one retry if offlined or too small */
> > +     /* one retry if too small */
> >       return READ_ONCE(lruvec->lrugen.seg) !=3D MEMCG_LRU_TAIL ?
> >              MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
> >  }
> > --
>
> In some of the places do you want to consider adding a VM_WARN_ON_ONCE
> for memcg_online not being true?
>
> Acked-by: Balbir Singh <balbirs@nvidia.com>

Thanks, does this look ok to you? We could also put it on the read
side in lruvec_lru_size(), but that backtrace will just show the
reclaim stack rather than whoever is trying to mutate the size of an
offline memcg.

@@ -49,6 +49,7 @@ static __always_inline void __update_lru_size(struct
lruvec *lruvec,

        lockdep_assert_held(&lruvec->lru_lock);
        WARN_ON_ONCE(nr_pages !=3D (int)nr_pages);
+       VM_WARN_ON_ONCE(!mem_cgroup_online(lruvec_memcg(lruvec)));

        mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
        __mod_zone_page_state(&pgdat->node_zones[zid],

