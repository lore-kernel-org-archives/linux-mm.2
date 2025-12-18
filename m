Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E49D68BD4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7859B6B0092; Wed, 17 Dec 2025 22:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733306B0093; Wed, 17 Dec 2025 22:34:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615F06B0095; Wed, 17 Dec 2025 22:34:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA6A6B0092
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:34:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3489C0EE4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:34:10 +0000 (UTC)
X-FDA: 84231173460.21.10662B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3CA1120019
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:34:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CYRd1AUy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766028849; a=rsa-sha256;
	cv=none;
	b=owhlk7p59GP+z5IuaeL1pRNMrMZnJNVPgtRplxac2foIpXZglgoCPSwVCmEeXztnKn8t8P
	K+lEFPNOBA5wtUIEAO3Ox7MthmXco8+4dB7s3EiAByDnA07AMRxxR23mYCRkt9KnH1vxac
	p0wMU/Wh0K17p6ihWPrFA2u39gZPhE0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CYRd1AUy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766028849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7NCoY3gkUnMPv3EKCdtZ9hIEZ8MNGARhKh/iShdPtE=;
	b=MX4pdqaXjtdMFj40Q+cY81dO4AALhNHO2K+qPwDtRuiQ9bgtdOqdMy67zZdDL0L2NzkGxl
	6oox0zyZH49dZ4n1xKXWZ+PzMqbzjzU+RbhN7d0KS0y5bOxitInvfqTssWs7podWsX0KtV
	Bz7igkuoQqtHiTDOJr7Xm0Gss5f43GQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766028848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p7NCoY3gkUnMPv3EKCdtZ9hIEZ8MNGARhKh/iShdPtE=;
	b=CYRd1AUyxhtL+Ct7T41iudNIHDgwasjx192JHf2y+MrXqpiM08pFHAj6n6+kdUaFv8EkhB
	RO9gvXEJ0VEe//3FoZWWLoq9n6iU2GnxzaiPzh5woJtSarWMo8vLjjGmUBtt4qPOkLXMtb
	NHaO/kY8+WDKsq9LhPftnJ20M59j+YA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-IJ3Mz50dO82-Jay4YSq0kA-1; Wed,
 17 Dec 2025 22:34:04 -0500
X-MC-Unique: IJ3Mz50dO82-Jay4YSq0kA-1
X-Mimecast-MFC-AGG-ID: IJ3Mz50dO82-Jay4YSq0kA_1766028842
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFE981800669;
	Thu, 18 Dec 2025 03:34:01 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E412E1956056;
	Thu, 18 Dec 2025 03:33:59 +0000 (UTC)
Date: Thu, 18 Dec 2025 11:33:55 +0800
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
Message-ID: <aUN2I9MhVJFPAMb6@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-10-cb7e28a26a40@tencent.com>
 <aT+KvZplFPimgStY@MiWiFi-R3L-srv>
 <CAMgjq7AKe09wKEeD9uf5_EuLBLMRoV=Rt+Vp0PU9-b5Jmp+1TQ@mail.gmail.com>
 <aUKQ7dke3uf9ud6W@MiWiFi-R3L-srv>
 <CAMgjq7D4xa+UpGfwP-Ji1HEoxB1=iaPzypGHL+hozwPW6v6tPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7D4xa+UpGfwP-Ji1HEoxB1=iaPzypGHL+hozwPW6v6tPQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3CA1120019
X-Stat-Signature: jgub1xwz4qw9mz87fcctoyzhxa41s9q5
X-HE-Tag: 1766028848-486942
X-HE-Meta: U2FsdGVkX1+j4HZB1aIbgRVRqNrsWe1ehdLy33dQLWVtZymfJN6qCMRRwarGJhOtyNcK1I7XsxidtZc6rtvuoVHF6jbzIeTeTrAlFrFraV0El4i4PrL0K3kYNCyGTwOVPMAuU9yvK9fIZX17k7YTF4T7F1ccf4Aae3v7tCSpiLDmBCQ5he4jmGmu/CUasy50EECXYXT0kDLfxD4v+NU9JPCJPBZSij2ZJ1W8sG2aAYkSdwWCFka2Jj82T5kXZi7C3izUFzOcPnYav8vwqL8VWD17M1GoMgCw47y0IYbbrP1yd2x7MPTnnLedQQrA74BFmLyd8CvUXj9q7e9h8aaCrFVz0mtZnj8UniywVnI/yzy3/v8VLazWuNtiLa1oW+7shLPzlszhOB3X27wTVwzBdVZkC/P8itey6zt8k0i5I6qMymdAWUHjoTkUNL41AQyHCLKEjoAxBGiKRsliCFLU6eGO2xNW2yp4fceInJzBz2SmA5fU1mJwEaA6eowM3IpgxNt2njDrUGoxvucTfo9IPfvPsgSfdRQ/BEG3YH2G47Mx9AHYqevy3u0NNXbnndlvpszBv5vPPbm7v3BPSIGJAVvXJBOKP0S66eSxOfOcfozjcyShQcSY4t6lQLN7O6uOZenbzu3rJcW4HePFyhr0V+lUqlutfYAIVltHlnheU12f6TJ5chmiBf5GffuJ1kdYDTHhdtFdh/4IXFf52b/0vmlLbBggOOr4kxYsEFrssmqwwFNxfxTcj1AGt+p9gl1y+EGNQ9y6A3xfxYuDFng8mxroEAqAqAXI+z+7686F4V2YmfhODcbuWhBKi0E9E5XtwlH7VaVsaBHxI/jgRpWHapw8za7l3uMMUyZLDl0DpwbqvD1MFAMkSBSWR5OfxvtIJCCjzGYezLlelPuDtnrHuA0UAJl5B/f9BtZbHqhQ+QRYYSYBwuprnT1bcSYUQ7kIyKvKCHHO1eCT/WL6w0d
 whC0VwJ6
 b0i4AhUC/Y/I+pQmeaVuC8OwO1esXEjij/FySXvWbptw2m1Kt/aDrA/9SrTFUfDghIgyF5FpA5h+tgYtuPf+rNbkw8x0tNq/z6D9PFB9iKvU3QyOfrYf0YLwDmMotA1uJTIID4pszOsCeWSzzqY+sxbHz0lQydlj5alWCOgpqkQ3urL3Vh9WNfvScOu4hWpTDcdLo9CUDuvL7r4NS+9fWls9rBcF9zx4EYkssPhCNKmdBMURcRlzPNIs0lsEC3hrZmJZBI3B9PWIhcxsiSweRurRN2E1TJNuF6F4qLrWwiyD1doc1je38HeLjBXOixAD/191atlZk1RK8GL1nvYOujNtUJ5DsZM3LeK3FRpqOXAHUdIMiIuqNQPENRs9OFJ/jxLInuPsgIL9CjWebU1TDATL3WfT9fvYqM+SP2LcDZ8oPAl5MZVmxeY1UvoZjYF+OZ3vRFDhGiQv3lfwv9CaEAiNRPrZpF6MFL3Rl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 at 02:30am, Kairui Song wrote:
> On Wed, Dec 17, 2025 at 7:16 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 12/15/25 at 12:38pm, Kairui Song wrote:
> > > On Mon, Dec 15, 2025 at 12:13 PM Baoquan He <bhe@redhat.com> wrote:
> > > >
> > > > On 12/05/25 at 03:29am, Kairui Song wrote:
> > > > > From: Kairui Song <kasong@tencent.com>
> > > > >
> > > > > Swap cluster cache reclaim requires releasing the lock, so the cluster
> > > > > may become unusable after the reclaim. To prepare for checking swap
> > > > > cache using the swap table directly, consolidate the swap cluster
> > > > > reclaim and the check logic.
> > > > >
> > > > > We will want to avoid touching the cluster's data completely with the
> > > >      ~~~~~~~~
> > > >     'want to' means 'will'?
> > >
> > > Sorry about my english, I mean in the following commit, we need to
> > > avoid accessing the cluster's table (ci->table)  when the cluster is
> > > empty, so the reclaim helper need to check cluster status before
> > > accessing it.
> >
> > Got it, I could be wrong. Please ignore this nit pick unless any english
> > native speaker raise concern on this.
> >
> > >
> > > >
> > > > > swap table, to avoid RCU overhead here. And by moving the cluster usable
> > > > > check into the reclaim helper, it will also help avoid a redundant scan of
> > > > > the slots if the cluster is no longer usable, and we will want to avoid
> > > >                                                        ~~~~~~~~~~~~
> > > >                                                         this place too.
> > > > > touching the cluster.
> > > > >
> > > > > Also, adjust it very slightly while at it: always scan the whole region
> > > > > during reclaim, don't skip slots covered by a reclaimed folio. Because
> > > > > the reclaim is lockless, it's possible that new cache lands at any time.
> > > > > And for allocation, we want all caches to be reclaimed to avoid
> > > > > fragmentation. Besides, if the scan offset is not aligned with the size
> > > > > of the reclaimed folio, we might skip some existing cache and fail the
> > > > > reclaim unexpectedly.
> > > > >
> > > > > There should be no observable behavior change. It might slightly improve
> > > > > the fragmentation issue or performance.
> > > > >
> > > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > > ---
> > > > >  mm/swapfile.c | 45 +++++++++++++++++++++++++++++----------------
> > > > >  1 file changed, 29 insertions(+), 16 deletions(-)
> > > > >
> > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > index 5a766d4fcaa5..2703dfafc632 100644
> > > > > --- a/mm/swapfile.c
> > > > > +++ b/mm/swapfile.c
> > > > > @@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
> > > > >       return 0;
> > > > >  }
> > > > >
> > > > > +/*
> > > > > + * Reclaim drops the ci lock, so the cluster may become unusable (freed or
> > > > > + * stolen by a lower order). @usable will be set to false if that happens.
> > > > > + */
> > > > >  static bool cluster_reclaim_range(struct swap_info_struct *si,
> > > > >                                 struct swap_cluster_info *ci,
> > > > > -                               unsigned long start, unsigned long end)
> > > > > +                               unsigned long start, unsigned int order,
> > > > > +                               bool *usable)
> > > > >  {
> > > > > +     unsigned int nr_pages = 1 << order;
> > > > > +     unsigned long offset = start, end = start + nr_pages;
> > > > >       unsigned char *map = si->swap_map;
> > > > > -     unsigned long offset = start;
> > > > >       int nr_reclaim;
> > > > >
> > > > >       spin_unlock(&ci->lock);
> > > > >       do {
> > > > >               switch (READ_ONCE(map[offset])) {
> > > > >               case 0:
> > > > > -                     offset++;
> > > > >                       break;
> > > > >               case SWAP_HAS_CACHE:
> > > > >                       nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
> > > > > -                     if (nr_reclaim > 0)
> > > > > -                             offset += nr_reclaim;
> > > > > -                     else
> > > > > +                     if (nr_reclaim < 0)
> > > > >                               goto out;
> > > > >                       break;
> > > > >               default:
> > > > >                       goto out;
> > > > >               }
> > > > > -     } while (offset < end);
> > > > > +     } while (++offset < end);
> > > >                  ~~~~~ '++offset' is conflicting with nr_reclaim
> > > >                  returned from __try_to_reclaim_swap(). can you explain?
> > >
> > > What do you mean conflicting? If (nr_reclaim < 0), reclaim failed,
> > > this loop ends. If (nr_reclaim == 0), the slot is likely concurrently
> > > freed so the loop should just continue to iterate & reclaim to ensure
> > > all slots are freed. If nr_reclaim > 0, the reclaim just freed a folio
> > > of nr_reclaim pages. We can round up by nr_reclaim to skip the slots
> > > that were occupied by the folio, but note here we are not locking the
> > > ci so there could be new folios landing in that range. Just keep
> > > iterating the reclaim seems still a good option and that makes the
> > > code simpler, and in practice maybe faster as there are less branches
> > > and calculations involved.
> >
> > I see now. The 'conflicting' may be not precise. I didn't understand
> > this because __try_to_reclaim_swap() is called in several places, and
> > all of them have the same situation about lock releasing and retaking
> > on ci->lock around __try_to_reclaim_swap(). As you said, we may need
> > refactor __try_to_reclaim_swap() and make change in all those places.
> 
> It's a bit different, other callers of __try_to_reclaim_swap are just
> best effort try to reclaim a slot's swap cache, because ultimately the
> allocator will reclaim the slot if needed anyway. But here, it is the
> allocator doing the reclaim, so we want precisely every slot to be
> cleaned.

OK, I see. Thanks for the explanation. While I think that's why we did
the recheck in later for loop. The old way and your change may have the
similar effect.

> 
> Avoid the align /round_up also make the code a bit cleaner.
> 


