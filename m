Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86AECFC539
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 13:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD436B0008; Sat, 22 Nov 2025 08:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5606B000A; Sat, 22 Nov 2025 08:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EAF16B000C; Sat, 22 Nov 2025 08:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A39D6B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:59:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A64F213BE4E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:59:08 +0000 (UTC)
X-FDA: 84138399576.26.CFB07C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 83994140004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:59:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YVcQ3xYT;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763819946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UK5OnmXlYIEWh0+dSSN9O2D+QPTH6oQPXvnBi8JkQU=;
	b=W7UXZZbd0geynDqGuDzZrVISRfMzfnMRLs9KM2braT4QWEVVvom6aA+c3O46RGvv0+JbMO
	PQ+KZdQBV6+B+0GrnxWhfV7XO3+cLQQatSFFzhNwnXxBJH5dEzoI1GEBZ3bNMmr56cM6Uo
	uxiiudOrizXA52CQp+ERp2xFEDfSat4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YVcQ3xYT;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763819946; a=rsa-sha256;
	cv=none;
	b=0kJH64bSz6RWgdln+uNrzGVlJcf97p8NwE+LkQxrlVCblYc6MyQRQyE3EFRx5t8fQRDzXX
	cVYb87/gELzjBbb2+5jF/QkHgWGS7MV7W5hY24fY3LhWXrAEkmp+BsvyeEwcUbOcszJy76
	hn1/5i5k+cMWgaoKkWfft+7nMA/UdgM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763819944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8UK5OnmXlYIEWh0+dSSN9O2D+QPTH6oQPXvnBi8JkQU=;
	b=YVcQ3xYTbGY73sUMSmVcITkKsrWsT9sADr35TTEt6w9X2HN14vg4LG1gxuyucUWvDkjA4k
	QPr0NZlDh/hvPRCUZ8kO3iRnjDwATRoX2hQMlkGOd13Nil7h3+jm0Xs6Q0vI0QqfTKwoY0
	7mQ61AVk3epyLuIRgbaUjxmYnbXtbEY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246-aHti6GnUNjuLgKIfBP9Ckw-1; Sat,
 22 Nov 2025 08:58:57 -0500
X-MC-Unique: aHti6GnUNjuLgKIfBP9Ckw-1
X-Mimecast-MFC-AGG-ID: aHti6GnUNjuLgKIfBP9Ckw_1763819935
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94C8319560B5;
	Sat, 22 Nov 2025 13:58:52 +0000 (UTC)
Received: from localhost (unknown [10.72.112.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A28A130044DC;
	Sat, 22 Nov 2025 13:58:45 +0000 (UTC)
Date: Sat, 22 Nov 2025 21:58:33 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	youngjun.park@lge.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratmal@google.com,
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <aSHBiVT6Udh1UNnB@MiWiFi-R3L-srv>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <CAMgjq7BgCocnkJAYd-BBBvzbu9zxmv4QCj+k62kcA3ThZcNv2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BgCocnkJAYd-BBBvzbu9zxmv4QCj+k62kcA3ThZcNv2A@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 83994140004
X-Stat-Signature: whogdgr48c3d51dh774ws8b8m3drc46b
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763819946-213395
X-HE-Meta: U2FsdGVkX19UITif4Aj0docmltqF8TSZ1rcwSmIe3Z092Hr19S8J79/fhKIu8rE61mv4yI9UxTrcK3GyqA24qSQGMwBr21T2dLC+AoEsf2jkA8/5AeOYbyBM1OC1+KYKg5Psi5XxmGNLIJJ8xqzp0uleqiTXQHEtiybX7/dfnuRXbUsvgd2LUpYHVdQ/mbgzwZy6MsMwgCDoi6n0/OxXi9dWtdxmdJoBm5oLq53Oku4hZwbvIBcnOW9mB2hgG0/hYGzu5yoX+s6OPdDL4ubXIOkQl34EO1mU2Wwk4i1xHyUTmsLTjviz+k2wLFkeUMcniLJ3v/8l6M3bQ4rNJ3hcs0x+WVoj0p6OrYl9jQOZi4oLC4KqRlIckBaR5QGaQ3rUoL6JCNXHyDVqfeISRUtTtZI1Y152Gyisdi9s1Ocs0wf+sHqL4to6WIf0DMFsAdqVI2Z+1GrwIn/Tw7t/hyrQXpvAYBwBi2e///5TLWzVsQeaHqN5dh+jR82c10X0BpE0Oetr1yEMzZYJX0g3AclRPT+coGM3PHgEc5Hyknz3Qbcf2trLN4aQV6GihsLr/TdvLrS7amYmlArf7vphfkoaOAAVih0Xi/lJlQG6SEwdSRfDRXjFFBAdkIrnkgkD3S4dG0XbqWCsQ0Cy7dJlJic1eXk/JKBzBnTpTTOMB2oYUDB3MR63X/IwpbzhOaRwpW7uNfL0hICxzzqATMe6TOqxXQKKjyVuuItEVNfy/kHS8YegdoMKsSAlwsLn6B1IpKOhxRlciAY+4JIVXmweK815qEmg7jsrvRtmfaS3CA6QXfKHbjWmZYh/wQzfVj8up0E6gsVJMSwMtfR4NPhYVJavLwnAfy/iH8tmej3lPjaTkEKUMY7BluDGofByPcvmo3SOFpagi2HprfnvGjtUjWma6n7UNFKhP6COkhoxuIoFYLEZJ1kQz/7PSILaHFRZVU2fDwqyss351uBsAj2ea7o
 ee6Rfbus
 o5DVNnmLYhXmaDQ3ePEhP6OuB+G4na7H6SUvjJAWWLNBOK09WNAuNIGuo+8EHI41Jx7tku8FxKEv2E/Kj4hI416iyrZw13iVxtUc1cyH2kiXSiTsjzx3iSZrYl8i+atNaLukrkqCM1ROR4UixS53Ne1EycdTXAmDc4jNhnXuKRPKilMnMKob5rEFEwvp/szDglRC10JI498TTUD50/D0MSeK14CVg3Mr9x0RcYOJ0NN8eRCadsdvGlY5ooOlYi7TCWIj0T1PXK/MYvwD+r3UenOwOuV7EiVf9pAcyl7tg4Q0Q6NYOoulAcKxdyil3hocHHhjCws1qUt9WpAOqJVt5DMBOG0AD7DiuxwGtsjnTPY8DpguIuY/o/fthgAGYvaP017ytInob1fLd/918rHYzfwtbLvezZGYXq4FId1PLOir0B5jjTkA/yC/FGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add YoungJun to CC.

On 11/22/25 at 05:59pm, Kairui Song wrote:
> On Fri, Nov 21, 2025 at 5:52 PM Chris Li <chrisl@kernel.org> wrote:
> >
> > The current zswap requires a backing swapfile. The swap slot used
> > by zswap is not able to be used by the swapfile. That waste swapfile
> > space.
> >
> > The ghost swapfile is a swapfile that only contains the swapfile header
> > for zswap. The swapfile header indicate the size of the swapfile. There
> > is no swap data section in the ghost swapfile, therefore, no waste of
> > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > prevents accidental read or write of ghost swapfile, bdev of
> > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > flag because there is no rotation disk access when using zswap.
> >
> > The zswap write back has been disabled if all swapfiles in the system
> > are ghost swap files.
> 
> Thanks for sharing this, I've been hearing about the ghost swapfile
> design for a long time, glad to see it finally got posted.
> 
> >
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > ---
> >  include/linux/swap.h |  2 ++
> >  mm/page_io.c         | 18 +++++++++++++++---
> >  mm/swap.h            |  2 +-
> >  mm/swap_state.c      |  7 +++++++
> >  mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++-----
> >  mm/zswap.c           | 17 +++++++++++------
> >  6 files changed, 73 insertions(+), 15 deletions(-)
> 
> In general I think this aligns quite well with what I had in mind and
> an idea that was mention during LSFMM this year (the 3rd one in the
> "Issues" part, it wasn't clearly described in the cover letter, more
> details in the slides):
> https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com/

Thanks for sharing the background and more information. When I checked
Youngjun's swap.tiers patchset before his RFC, felt it would be more
flexible to add zswap to memcg if zswap size can be decoupled from the
back device. Chris's RFC can satisfy that, but I didn't thought you
guys had planned more, e.g dynamic growth of swap size, and the zswap slot
management being like swap table on swap slot. Looking forward to seeing
the progress and more details.

Thanks
Baoquan

> 
> The good part is that we will reuse everything we have with the
> current swap stack, and stay optional. Everything is a swap device, no
> special layers required. All other features will be available in a
> cleaner way.
> 
> And /etc/fstab just works the same way for the ghost swapfile.
> 
> Looking forward to see this RFC get more updates.
> 
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 38ca3df68716042946274c18a3a6695dda3b7b65..af9b789c9ef9c0e5cf98887ab2bccd469c833c6b 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -216,6 +216,7 @@ enum {
> >         SWP_PAGE_DISCARD = (1 << 10),   /* freed swap page-cluster discards */
> >         SWP_STABLE_WRITES = (1 << 11),  /* no overwrite PG_writeback pages */
> >         SWP_SYNCHRONOUS_IO = (1 << 12), /* synchronous IO is efficient */
> > +       SWP_GHOST       = (1 << 13),    /* not backed by anything */
> >                                         /* add others here before... */
> >  };
> >
> > @@ -438,6 +439,7 @@ void free_folio_and_swap_cache(struct folio *folio);
> >  void free_pages_and_swap_cache(struct encoded_page **, int);
> >  /* linux/mm/swapfile.c */
> >  extern atomic_long_t nr_swap_pages;
> > +extern atomic_t nr_real_swapfiles;
> >  extern long total_swap_pages;
> >  extern atomic_t nr_rotate_swap;
> >
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index 3c342db77ce38ed26bc7aec68651270bbe0e2564..cc1eb4a068c10840bae0288e8005665c342fdc53 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -281,8 +281,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
> >                 return AOP_WRITEPAGE_ACTIVATE;
> >         }
> >
> > -       __swap_writepage(folio, swap_plug);
> > -       return 0;
> > +       return __swap_writepage(folio, swap_plug);
> >  out_unlock:
> >         folio_unlock(folio);
> >         return ret;
> > @@ -444,11 +443,18 @@ static void swap_writepage_bdev_async(struct folio *folio,
> >         submit_bio(bio);
> >  }
> >
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> > +int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> >  {
> >         struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> >
> >         VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> > +
> > +       if (sis->flags & SWP_GHOST) {
> > +               /* Prevent the page from getting reclaimed. */
> > +               folio_set_dirty(folio);
> > +               return AOP_WRITEPAGE_ACTIVATE;
> > +       }
> > +
> >         /*
> >          * ->flags can be updated non-atomicially (scan_swap_map_slots),
> >          * but that will never affect SWP_FS_OPS, so the data_race
> > @@ -465,6 +471,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> >                 swap_writepage_bdev_sync(folio, sis);
> >         else
> >                 swap_writepage_bdev_async(folio, sis);
> > +       return 0;
> >  }
> >
> >  void swap_write_unplug(struct swap_iocb *sio)
> > @@ -637,6 +644,11 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >         if (zswap_load(folio) != -ENOENT)
> >                 goto finish;
> >
> > +       if (unlikely(sis->flags & SWP_GHOST)) {
> > +               folio_unlock(folio);
> > +               goto finish;
> > +       }
> > +
> >         /* We have to read from slower devices. Increase zswap protection. */
> >         zswap_folio_swapin(folio);
> >
> > diff --git a/mm/swap.h b/mm/swap.h
> > index d034c13d8dd260cea2a1e95010a9df1e3011bfe4..bd60bf2c5dc9218069be0ada5d2d843399894439 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -195,7 +195,7 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
> >  }
> >  void swap_write_unplug(struct swap_iocb *sio);
> >  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
> > +int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
> >
> >  /* linux/mm/swap_state.c */
> >  extern struct address_space swap_space __ro_after_init;
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index b2230f8a48fc2c97d61d4bfb2c25e9d1e2508805..f01a8d8f32deb956e25c3c24897b0e3f6c5a735c 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -632,6 +632,13 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
> >         struct swap_iocb *splug = NULL;
> >         bool page_allocated;
> >
> > +       /*
> > +        * The entry may have been freed by another task. Avoid swap_info_get()
> > +        * which will print error message if the race happens.
> > +        */
> > +       if (si->flags & SWP_GHOST)
> > +               goto skip;
> > +
> >         mask = swapin_nr_pages(offset) - 1;
> >         if (!mask)
> >                 goto skip;
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 94e0f0c54168759d75bc2756e7c09f35413e6c78..a34d1eb6908ea144fd8fab1224f1520054a94992 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
> >  static DEFINE_SPINLOCK(swap_lock);
> >  static unsigned int nr_swapfiles;
> >  atomic_long_t nr_swap_pages;
> > +atomic_t nr_real_swapfiles;
> >  /*
> >   * Some modules use swappable objects and may try to swap them out under
> >   * memory pressure (via the shrinker). Before doing so, they may wish to
> > @@ -1158,6 +1159,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
> >                         goto skip;
> >         }
> >
> > +       if (!(si->flags & SWP_GHOST))
> > +               atomic_sub(1, &nr_real_swapfiles);
> >         plist_del(&si->avail_list, &swap_avail_head);
> >
> >  skip:
> > @@ -1200,6 +1203,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
> >         }
> >
> >         plist_add(&si->avail_list, &swap_avail_head);
> > +       if (!(si->flags & SWP_GHOST))
> > +               atomic_add(1, &nr_real_swapfiles);
> >
> >  skip:
> >         spin_unlock(&swap_avail_lock);
> > @@ -2677,6 +2682,11 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
> >         struct inode *inode = mapping->host;
> >         int ret;
> >
> > +       if (sis->flags & SWP_GHOST) {
> > +               *span = 0;
> > +               return 0;
> > +       }
> > +
> >         if (S_ISBLK(inode->i_mode)) {
> >                 ret = add_swap_extent(sis, 0, sis->max, 0);
> >                 *span = sis->pages;
> > @@ -2910,7 +2920,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >         if (p->flags & SWP_CONTINUED)
> >                 free_swap_count_continuations(p);
> >
> > -       if (!p->bdev || !bdev_nonrot(p->bdev))
> > +       if (!(p->flags & SWP_GHOST) &&
> > +           (!p->bdev || !bdev_nonrot(p->bdev)))
> >                 atomic_dec(&nr_rotate_swap);
> >
> >         mutex_lock(&swapon_mutex);
> > @@ -3030,6 +3041,19 @@ static void swap_stop(struct seq_file *swap, void *v)
> >         mutex_unlock(&swapon_mutex);
> >  }
> >
> > +static const char *swap_type_str(struct swap_info_struct *si)
> > +{
> > +       struct file *file = si->swap_file;
> > +
> > +       if (si->flags & SWP_GHOST)
> > +               return "ghost\t";
> > +
> > +       if (S_ISBLK(file_inode(file)->i_mode))
> > +               return "partition";
> > +
> > +       return "file\t";
> > +}
> > +
> >  static int swap_show(struct seq_file *swap, void *v)
> >  {
> >         struct swap_info_struct *si = v;
> > @@ -3049,8 +3073,7 @@ static int swap_show(struct seq_file *swap, void *v)
> >         len = seq_file_path(swap, file, " \t\n\\");
> >         seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
> >                         len < 40 ? 40 - len : 1, " ",
> > -                       S_ISBLK(file_inode(file)->i_mode) ?
> > -                               "partition" : "file\t",
> > +                       swap_type_str(si),
> >                         bytes, bytes < 10000000 ? "\t" : "",
> >                         inuse, inuse < 10000000 ? "\t" : "",
> >                         si->prio);
> > @@ -3183,7 +3206,6 @@ static int claim_swapfile(struct swap_info_struct *si, struct inode *inode)
> >         return 0;
> >  }
> >
> > -
> >  /*
> >   * Find out how many pages are allowed for a single swap device. There
> >   * are two limiting factors:
> > @@ -3229,6 +3251,7 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
> >         unsigned long maxpages;
> >         unsigned long swapfilepages;
> >         unsigned long last_page;
> > +       loff_t size;
> >
> >         if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
> >                 pr_err("Unable to find swap-space signature\n");
> > @@ -3271,7 +3294,16 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
> >
> >         if (!maxpages)
> >                 return 0;
> > -       swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
> > +
> > +       size = i_size_read(inode);
> > +       if (size == PAGE_SIZE) {
> > +               /* Ghost swapfile */
> > +               si->bdev = NULL;
> > +               si->flags |= SWP_GHOST | SWP_SOLIDSTATE;
> > +               return maxpages;
> > +       }
> 
> Here if we push things further, it might be a good idea to make better
> use of the swap file header for detecting this kind of device, and
> maybe add support for other info too. The header already has version
> info embedded in case it will be extended.
> 


