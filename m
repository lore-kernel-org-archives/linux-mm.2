Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05818D6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645F76B0005; Wed, 17 Dec 2025 06:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DAF6B0089; Wed, 17 Dec 2025 06:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2766B008A; Wed, 17 Dec 2025 06:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0006B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:16:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CD925BC53
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:16:16 +0000 (UTC)
X-FDA: 84228709152.27.29307EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5C1B100008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:16:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XPIhsdKp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765970174; a=rsa-sha256;
	cv=none;
	b=ZWTycZo9cBGDeVFqFMoHsPQTv2iFm/tbXp2H6GzTkwcD5tGoC1GdfZxuUo1+LKMesbYtFz
	6ZnALED1wOMGIPttk8XEsCjs+JjHvhm9PDML7LroR5WBp2lr9aOnMD+oHDA+W7vWuEJUNu
	k90fExMSbmRmhr8owPLczr8X5NgTBks=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XPIhsdKp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765970174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fziopwXFv8kkjMBB9/Q3xq/TrYYxeYKMSvdF100voDc=;
	b=sYr7pxl1cBlH6MFlKa8/F7Aj7aDckAxAEcDkqjKlhC0w5OZzuEHM4lVcM04mJ8ga0B4dd+
	WFnBABX9zQAkk5uQDAf4X9XXiEaZ9PY8yh+FrkrMz+uLFNlRpqcsODOShj9mwZ7aPO172W
	0jDBQiIH4o73J/+UBbfjy7ig/bPrFbQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765970173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fziopwXFv8kkjMBB9/Q3xq/TrYYxeYKMSvdF100voDc=;
	b=XPIhsdKpr5VU1IDzhzDHwX9dpOmQKprF9XNzCQ30iQ8qnA25ftax2t8q8QRzKqhSRNiwyH
	r2+AmGvYR4Gq5xGtnGqgl2GiUf0TwTfZoRJLtr3G82hVZwpyRivhaFYjS4bW0OdaO/2sWq
	UjyW4ATMdd4wCwrgjGB9+wN+ev4wuUg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-0RmcSPelOCKUZAeOLm2ZmQ-1; Wed,
 17 Dec 2025 06:16:08 -0500
X-MC-Unique: 0RmcSPelOCKUZAeOLm2ZmQ-1
X-Mimecast-MFC-AGG-ID: 0RmcSPelOCKUZAeOLm2ZmQ_1765970166
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 987AD18005AE;
	Wed, 17 Dec 2025 11:16:05 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FDA91955F24;
	Wed, 17 Dec 2025 11:16:03 +0000 (UTC)
Date: Wed, 17 Dec 2025 19:15:57 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/19] mm, swap: consolidate cluster reclaim and
 usability check
Message-ID: <aUKQ7dke3uf9ud6W@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-10-cb7e28a26a40@tencent.com>
 <aT+KvZplFPimgStY@MiWiFi-R3L-srv>
 <CAMgjq7AKe09wKEeD9uf5_EuLBLMRoV=Rt+Vp0PU9-b5Jmp+1TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7AKe09wKEeD9uf5_EuLBLMRoV=Rt+Vp0PU9-b5Jmp+1TQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5C1B100008
X-Stat-Signature: ukkm4fkryeiy5ocriok4jxnunmf3qa9w
X-Rspam-User: 
X-HE-Tag: 1765970173-119267
X-HE-Meta: U2FsdGVkX198LTFYXj3XSHRSMfdZEquh76PdT7OmxBvYvHwWi8SEgMPqR8B2CNk5lQrhuhryYWsYUJnKO5F+Nfo/QQwGnqLCK4Gu2m0CJ6NLcwpEwOwfckNQmYHqaj6OsXmFyXTa+PJxCtHRePPGnCpeHObi6gX3QxQ4DvGMQEXOaKb1gZnfPaDVYFw2NMxqMw+ZT6A9gGWvs2vyY3TjaLA6uMSsTavWDGqOKWrgWisL44klbDekz2bwhm/gXc8ghgxS3k+66WsB9mxHk45dxdKFh73bDLOaUGjxFqeYkn86pO5Y+dHJeb/efneoSdhOJkOGI1vln9HS+0L84ciH56RQywJNBDQxF0n6AaLDRKY6CB+7pMuKXQaQSsi6eSN7M2LkOp4495FwiaNUK8YM3Rlud55qUEVAqByAV8Lv6OP9j2q2vrmroyT4/QG0WHaEAYnkI3/HUbEybLaOqkun4QCoYbLNsfhcAidfUNm55tKPLYq4qHukY1TzpbXvDbvzyEndfpD+HOTW8Tj+bPovbHDQplGtLJuUL/6s+07EwjQIH6o4rlGctDL2UPh5f/1v3RL9g6ryufljoaYmnN8yPP/g0YTgsRApL4kZv+84eWbQNotb8TtENksphc3ayTc1MB8IoVrU/TlaoCvnnpgYme1vXdsG3bkoPDxQwikyuA2aW/a48g1OTLK0huYt5M0NNGlKSWyI3CVHFO1i3c3J6hIGHbLzpMx4Keg1bW/KWMDwNwJpTC7MkxZSsGtS5jJgJzcZb+yG7zrk4yarUw1yIxQOXD9KsH6NKuPCi8hMAT3w8xlsmQ6f+s8DyDqM/1bA902qvndBc3b0FhV6PXYyKTo5HNBXF8kCkekEXArcl76qc/juC5F7DsIMhcFwZ3rbiM7rqBMRn2t5wm+1RouekneJ2DBl5XGg8K8/DIXQKUrko6Jesjdf5YhUFkVCFC0cuOVJxxQG9HHlexzSbc4
 XVDbwYad
 CuXvLd4BuuJfEpdTX6bGicrF9lbGwcylVLHElLDnM5xXSD9LS2rAQGtnvl7G2BnEQeRaK4I37sbqaJZ8c2ujXwfFvuHe5Cf+Y8tRgaDnJ6qlLo9i1WKa0SOgB6DKxYzNn/B8/X7vdc7XaP6I/KUyqkiANYXhy6TaI9GhcLY8Kggz99x5i25vGRIz7ZUopez3Mc0P0ejnqpSpo3YDpG+Yq2HrUOK+xR22KfyVf6ClQYOhx6yqSc25JjeQ3uVbn9Hr5uPt+Pyu+sCvsOmkzqCVHiUmXh4J87mOQ/+PvOc7BF6qmDJmQHzSkg3pn0HWm2Ym3TfOA6DC6W6zbHURaFqI4RREg30vOYM3SW/3rcVxCI0YRT0JBk37qXVAwatF3Df+5xxRVN34MsodW/dqnNHrL4YyoLq39A/JFiVbD/tALJMOd31A5SaDpYl1ywvYNhVVlS47bFE+U0bgorbyj5CcLxar2ndJH5pUj42Aq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 at 12:38pm, Kairui Song wrote:
> On Mon, Dec 15, 2025 at 12:13 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 12/05/25 at 03:29am, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Swap cluster cache reclaim requires releasing the lock, so the cluster
> > > may become unusable after the reclaim. To prepare for checking swap
> > > cache using the swap table directly, consolidate the swap cluster
> > > reclaim and the check logic.
> > >
> > > We will want to avoid touching the cluster's data completely with the
> >      ~~~~~~~~
> >     'want to' means 'will'?
> 
> Sorry about my english, I mean in the following commit, we need to
> avoid accessing the cluster's table (ci->table)  when the cluster is
> empty, so the reclaim helper need to check cluster status before
> accessing it.

Got it, I could be wrong. Please ignore this nit pick unless any english
native speaker raise concern on this.

> 
> >
> > > swap table, to avoid RCU overhead here. And by moving the cluster usable
> > > check into the reclaim helper, it will also help avoid a redundant scan of
> > > the slots if the cluster is no longer usable, and we will want to avoid
> >                                                        ~~~~~~~~~~~~
> >                                                         this place too.
> > > touching the cluster.
> > >
> > > Also, adjust it very slightly while at it: always scan the whole region
> > > during reclaim, don't skip slots covered by a reclaimed folio. Because
> > > the reclaim is lockless, it's possible that new cache lands at any time.
> > > And for allocation, we want all caches to be reclaimed to avoid
> > > fragmentation. Besides, if the scan offset is not aligned with the size
> > > of the reclaimed folio, we might skip some existing cache and fail the
> > > reclaim unexpectedly.
> > >
> > > There should be no observable behavior change. It might slightly improve
> > > the fragmentation issue or performance.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  mm/swapfile.c | 45 +++++++++++++++++++++++++++++----------------
> > >  1 file changed, 29 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 5a766d4fcaa5..2703dfafc632 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
> > >       return 0;
> > >  }
> > >
> > > +/*
> > > + * Reclaim drops the ci lock, so the cluster may become unusable (freed or
> > > + * stolen by a lower order). @usable will be set to false if that happens.
> > > + */
> > >  static bool cluster_reclaim_range(struct swap_info_struct *si,
> > >                                 struct swap_cluster_info *ci,
> > > -                               unsigned long start, unsigned long end)
> > > +                               unsigned long start, unsigned int order,
> > > +                               bool *usable)
> > >  {
> > > +     unsigned int nr_pages = 1 << order;
> > > +     unsigned long offset = start, end = start + nr_pages;
> > >       unsigned char *map = si->swap_map;
> > > -     unsigned long offset = start;
> > >       int nr_reclaim;
> > >
> > >       spin_unlock(&ci->lock);
> > >       do {
> > >               switch (READ_ONCE(map[offset])) {
> > >               case 0:
> > > -                     offset++;
> > >                       break;
> > >               case SWAP_HAS_CACHE:
> > >                       nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
> > > -                     if (nr_reclaim > 0)
> > > -                             offset += nr_reclaim;
> > > -                     else
> > > +                     if (nr_reclaim < 0)
> > >                               goto out;
> > >                       break;
> > >               default:
> > >                       goto out;
> > >               }
> > > -     } while (offset < end);
> > > +     } while (++offset < end);
> >                  ~~~~~ '++offset' is conflicting with nr_reclaim
> >                  returned from __try_to_reclaim_swap(). can you explain?
> 
> What do you mean conflicting? If (nr_reclaim < 0), reclaim failed,
> this loop ends. If (nr_reclaim == 0), the slot is likely concurrently
> freed so the loop should just continue to iterate & reclaim to ensure
> all slots are freed. If nr_reclaim > 0, the reclaim just freed a folio
> of nr_reclaim pages. We can round up by nr_reclaim to skip the slots
> that were occupied by the folio, but note here we are not locking the
> ci so there could be new folios landing in that range. Just keep
> iterating the reclaim seems still a good option and that makes the
> code simpler, and in practice maybe faster as there are less branches
> and calculations involved.

I see now. The 'conflicting' may be not precise. I didn't understand
this because __try_to_reclaim_swap() is called in several places, and 
all of them have the same situation about lock releasing and retaking
on ci->lock around __try_to_reclaim_swap(). As you said, we may need
refactor __try_to_reclaim_swap() and make change in all those places.

> 
> I mentioned `always scan the whole region during reclaim, don't skip
> slots covered by a reclaimed folio` in the commit message, I can add a
> few more comments too.
> 
> > >  out:
> > >       spin_lock(&ci->lock);
> > > +
> > > +     /*
> > > +      * We just dropped ci->lock so cluster could be used by another
> > > +      * order or got freed, check if it's still usable or empty.
> > > +      */
> > > +     if (!cluster_is_usable(ci, order)) {
> > > +             *usable = false;
> > > +             return false;
> > > +     }
> > > +     *usable = true;
> > > +
> > > +     /* Fast path, no need to scan if the whole cluster is empty */
> > > +     if (cluster_is_empty(ci))
> > > +             return true;
> > > +
> > >       /*
> > >        * Recheck the range no matter reclaim succeeded or not, the slot
> > >        * could have been be freed while we are not holding the lock.
> > > @@ -900,9 +918,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
> > >       unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
> > >       unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
> > >       unsigned int nr_pages = 1 << order;
> > > -     bool need_reclaim, ret;
> > > +     bool need_reclaim, ret, usable;
> > >
> > >       lockdep_assert_held(&ci->lock);
> > > +     VM_WARN_ON(!cluster_is_usable(ci, order));
> > >
> > >       if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
> > >               goto out;
> > > @@ -912,14 +931,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
> > >               if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
> > >                       continue;
> > >               if (need_reclaim) {
> > > -                     ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
> > > -                     /*
> > > -                      * Reclaim drops ci->lock and cluster could be used
> > > -                      * by another order. Not checking flag as off-list
> > > -                      * cluster has no flag set, and change of list
> > > -                      * won't cause fragmentation.
> > > -                      */
> > > -                     if (!cluster_is_usable(ci, order))
> > > +                     ret = cluster_reclaim_range(si, ci, offset, order, &usable);
> > > +                     if (!usable)
> > >                               goto out;
> > >                       if (cluster_is_empty(ci))
> > >                               offset = start;
> > >
> > > --
> > > 2.52.0
> > >
> >
> 


