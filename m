Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED32CEA4E0B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F00D6B0005; Mon,  2 Mar 2026 09:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D5B6B0089; Mon,  2 Mar 2026 09:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C8E6B008A; Mon,  2 Mar 2026 09:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37D796B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:47:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E812DB68AD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:47:33 +0000 (UTC)
X-FDA: 84501401586.14.A22DFA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9667C2000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:47:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YAvCoFi2;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772462851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IvpPI1oYKUm8fRHV9Hy0KSgDJYFYfei1Z3JxQsoomQs=;
	b=euJFn0nkgo/7IyShww1eUWfDYRGC/PUHoc3U3Fc9R0mch6pAA8LsADja2tH8uay/Kr9U7K
	QGFm4HqDRxEodJyK/F6YmBHntJdWAo2YHPHQKeRt8MTLo4oT6hK39vt6HccPZwEyIC2Jmq
	wbtBf6AeqMg6Y0b7CqzfH4Pb4c4xUN4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YAvCoFi2;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772462851; a=rsa-sha256;
	cv=none;
	b=FAArF1i42PtQq3yaGkRORfKr++1KXhONXORMXt2hMF/ljoi7uKp30LeEdnAhTrT0wu63sa
	SA+hv5F4HRg4566hwayRoK9D3AZA3c0ducH/cFYCYKgSCv06FHZs0GPkPoLQnFJmfSZ/MX
	PO2T8jwxPoC5xeX0Oqw8VeH2u7W0MvE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772462850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IvpPI1oYKUm8fRHV9Hy0KSgDJYFYfei1Z3JxQsoomQs=;
	b=YAvCoFi26p0qFNp0R3uhB+YjAnU68X7k5kqMPB96axGWRuTkRKRNHbrlV14Wk7pAcfYje2
	tOQZ8DVAYbqB9K6C90a2CHIhTYB0F/WdfUer4KUHP/jLP5AD9ecI8Bu+iCw+rP+GTBWiMy
	ZPJnqAkdYsqH1r2YRsq8CgBQcEzV6ew=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-HfCzEnTaOKOVll6gDecyqg-1; Mon,
 02 Mar 2026 09:47:28 -0500
X-MC-Unique: HfCzEnTaOKOVll6gDecyqg-1
X-Mimecast-MFC-AGG-ID: HfCzEnTaOKOVll6gDecyqg_1772462847
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88342180049D;
	Mon,  2 Mar 2026 14:47:26 +0000 (UTC)
Received: from localhost (unknown [10.72.112.98])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E7B41800666;
	Mon,  2 Mar 2026 14:47:24 +0000 (UTC)
Date: Mon, 2 Mar 2026 22:47:20 +0800
From: Baoquan He <bhe@redhat.com>
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	youngjun.park@lge.com
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aaWi-MU2iE0X3PFt@MiWiFi-R3L-srv>
References: <20260302104016.163542-1-bhe@redhat.com>
 <20260302104016.163542-3-bhe@redhat.com>
 <CAGsJ_4z-TB3qZ1t0H1EgB8ir-eut9oLeFMP+tn2oM3PVco2h+Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4z-TB3qZ1t0H1EgB8ir-eut9oLeFMP+tn2oM3PVco2h+Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SlX1z1rfxdLejgC0Nbpa_r_BqXUAePPXtLy57JxOVUE_1772462847
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5c64q53z18s9pwax489irfkyh7n4aroz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9667C2000E
X-HE-Tag: 1772462851-220871
X-HE-Meta: U2FsdGVkX185yjtV/HIhRXgbYGzVPQgwMRwy1bbY22QUsJfpVpaWihChD4W6WFxfoerJJnZuE5n0eCQXxZ9dDftqKanSxx5R1q0DmszeujIAJV893tu7wxZ2RBm59MT+Xs3SJvowiPsQOjwhcvB7NPnKa4OL9NmJkMq3xwAILWovzdo8PsEqmH/d4DfpJ2eYX6J0FyjLyILW60Hzmr1gwrRjMjolCPE/1NgWxrp+v2mlTcWP9s4iCGi+cci8JLpzjoXev3QjgzCpYGHzww+sONLUBxe2/c7KJ4ZwwB6K18T6HjixyZu4RRtiEKhdGj0eKD49ZYvBluLEIKlJp9IvGzoCiDvTihqWt3zKnL0d1jisTKziOVqS1zffkC+M5Ehz1iprdrzEibw/6+J5a6/pM4eVLOXA/LTpYDVivObqt4ICNdurDpbX1FgFcneYZ3bj/idg8nszyLJ9j7eY7ofEPPmYqXkiyEZD1kh8KHULGNjpPYZVp+tlCMj6RU+cFqCe6dSnKsbwt4FieiFf0n9rUohKG2N3SK934Fcxi+KhyCOQTnyUA0UnqbgX49vQijM2GfktLAFXA4DJ/gjdJTCCCkylzwf0qomUNg6WsMX+VAXoyFByqTNXkgL9EOcosO8AkxUB4mo/dXy1jAH2oMnmZv7xBzrk7heXY+a5bi9dQOJGUwmDinqBfwGI+QS13nFvHPFYblaeaiUk8OhpYnlyVJ/Hm0xHXXqgSPnukOjHThS5T6GFdGxY6Ps9yZVddEc6quLky9OkYKTSjkUHBzeV1Xc24KnGZfvCxXptFE7IYhNJo4lxj4MzsGx8kKXA2DdjQyB0V2Dg0EUZtlfGOZ0ZaTl2/N5cCrPjxYaEdvYMHY1CtCGUuY3pm070DprUlaGCXMwhQKrcIEq2OjOSE2EYNMbK60udwa6qhGl9Fnu0Vh5Qbk1ZTMbprwB+85sUo4LkdIamFefqM1VMGxU9mgX
 F9iHDoeP
 3EAxNeoGOoUBqSsxyOLwPmrJR+IzcljoN9gTMHoSAYoYLGCRP1VYSsfCCbVqGvUx/Kmi246VEXPGgS9UmbrIQsY46gdSwTqLMYbPC4Jyq3bGSuwQuS81x5wxr9icH010VIlAoLBw/PXI5P4Q/gqFvaFQynA3asxziKrcWuOlPAiQrPeq1vLeqgFrd/kW7K0+AXASOzLrbEEIXO3zQRbVRbxn68cBbi9pMFzNAOqKrWq82DRbkhE6GYW6r+/6KzALBuhxZuRKLY7bS31dQpLgQl9OKtSVivp3EhXVAswlxnci70AjBmaASAjofFHNmvU99y2q7vXEVzfMfcV3fpUZJRCHJueC1+0yynHnh+6u/m2Yvy+hdZKsHkwYDFvXUBsBtfOcreIm0h/IhOPCmcJk9QNYgZi1CVUUrJuM5lWUIIpcre+JTpVj3uvE7KYqHgKOe6HbuuyVFxR6x3+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/02/26 at 07:11pm, Barry Song wrote:
> On Mon, Mar 2, 2026 at 6:40 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > This simplifies codes and makes logic clearer. And also makes later any
> > new swap device type being added easier to handle.
> >
> > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > and bdev_async, and only operations read_folio and write_folio are
> > included. In the future, there could be more swap device types added
> > and more appropriate opeations adapted into swap_ops.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/swap.h |  13 ++++++
> >  mm/swap.h            |   1 -
> >  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
> >  mm/swapfile.c        |   2 +
> >  mm/zswap.c           |   3 +-
> >  5 files changed, 76 insertions(+), 45 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0effe3cc50f5..448e5e66ec5c 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -19,6 +19,7 @@
> >  struct notifier_block;
> >
> >  struct bio;
> > +struct swap_iocb;
> >
> >  struct pagevec;
> >
> > @@ -222,6 +223,17 @@ enum {
> >  #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
> >  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
> >
> > +struct swap_ops {
> > +       void (*read_folio)(struct swap_info_struct *sis,
> > +                          struct folio *folio,
> > +                          struct swap_iocb **plug);
> > +       void (*write_folio)(struct swap_info_struct *sis,
> > +                           struct folio *folio,
> > +                           struct swap_iocb **plug);
> > +};
> > +
> > +int probe_swap_fs(struct swap_info_struct *sis);
> 
> Does probe_swap_fs sound a bit odd?
> What about init_swap_ops? Not sure if we have a better name.

Both is fine to me, if no other suggestion, I can take init_swap_ops()
instead.

> 
> Do we really want it, along with swap_ops, to live in
> include/linux/swap.h? Could it be placed in mm/swap.h instead?

You are right, putting it into mm/swap.h sounds better.

> 
> > +
> >  /*
> >   * The first page in the swap file is the swap header, which is always marked
> >   * bad to prevent it from being allocated as an entry. This also prevents the
> > @@ -284,6 +296,7 @@ struct swap_info_struct {
> >         struct work_struct reclaim_work; /* reclaim worker */
> >         struct list_head discard_clusters; /* discard clusters list */
> >         struct plist_node avail_list;   /* entry in swap_avail_head */
> > +       struct swap_ops *ops;
> >  };
> >
> >  static inline swp_entry_t page_swap_entry(struct page *page)
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 161185057993..c390df3f5889 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -226,7 +226,6 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
> >  }
> >  void swap_write_unplug(struct swap_iocb *sio);
> >  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
> >
> >  /* linux/mm/swap_state.c */
> >  extern struct address_space swap_space __read_mostly;
> > diff --git a/mm/swap_io.c b/mm/swap_io.c
> > index d1cdb10ba133..47077b345ae3 100644
> > --- a/mm/swap_io.c
> > +++ b/mm/swap_io.c
> > @@ -240,6 +240,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
> >  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
> >  {
> >         int ret = 0;
> > +       struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> >
> >         if (folio_free_swap(folio))
> >                 goto out_unlock;
> > @@ -281,7 +282,8 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
> >                 return AOP_WRITEPAGE_ACTIVATE;
> >         }
> >
> > -       __swap_writepage(folio, swap_plug);
> > +       if (sis->ops && sis->ops->write_folio)
> > +               sis->ops->write_folio(sis, folio, swap_plug);
> 
> Do we want a swap_write_folio() wrapper?

Seems swap_writeout() is the counterpart of swap_read_folio(). I
personally prefer to rename swap_writeout() to swap_write_folio(). And
make a wrapper as _swap_write_folio()?

> 
> >         return 0;
> >  out_unlock:
> >         folio_unlock(folio);
> > @@ -371,10 +373,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
> >         mempool_free(sio, sio_pool);
> >  }
> >
> > -static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
> > +static void swap_writepage_fs(struct swap_info_struct *sis,
> > +                             struct folio *folio,
> > +                             struct swap_iocb **swap_plug)
> >  {
> >         struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
> > -       struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> >         struct file *swap_file = sis->swap_file;
> >         loff_t pos = swap_dev_pos(folio->swap);
> >
> > @@ -407,8 +410,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
> >                 *swap_plug = sio;
> >  }
> >
> > -static void swap_writepage_bdev_sync(struct folio *folio,
> > -               struct swap_info_struct *sis)
> > +static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
> > +                                    struct folio *folio,
> > +                                    struct swap_iocb **plug)
> >  {
> >         struct bio_vec bv;
> >         struct bio bio;
> > @@ -427,8 +431,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
> >         __end_swap_bio_write(&bio);
> >  }
> >
> > -static void swap_writepage_bdev_async(struct folio *folio,
> > -               struct swap_info_struct *sis)
> > +static void swap_writepage_bdev_async(struct swap_info_struct *sis,
> > +                                     struct folio *folio,
> > +                                     struct swap_iocb **plug)
> >  {
> >         struct bio *bio;
> >
> > @@ -444,29 +449,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
> >         submit_bio(bio);
> >  }
> >
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> > -{
> > -       struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> > -
> > -       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> > -       /*
> > -        * ->flags can be updated non-atomically (scan_swap_map_slots),
> > -        * but that will never affect SWP_FS_OPS, so the data_race
> > -        * is safe.
> > -        */
> > -       if (data_race(sis->flags & SWP_FS_OPS))
> > -               swap_writepage_fs(folio, swap_plug);
> > -       /*
> > -        * ->flags can be updated non-atomically (scan_swap_map_slots),
> > -        * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> > -        * is safe.
> > -        */
> > -       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > -               swap_writepage_bdev_sync(folio, sis);
> > -       else
> > -               swap_writepage_bdev_async(folio, sis);
> > -}
> > -
> >  void swap_write_unplug(struct swap_iocb *sio)
> >  {
> >         struct iov_iter from;
> > @@ -535,9 +517,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
> >         return true;
> >  }
> >
> > -static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
> > +static void swap_read_folio_fs(struct swap_info_struct *sis,
> > +                              struct folio *folio,
> > +                              struct swap_iocb **plug)
> >  {
> > -       struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> >         struct swap_iocb *sio = NULL;
> >         loff_t pos = swap_dev_pos(folio->swap);
> >
> > @@ -569,8 +552,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
> >                 *plug = sio;
> >  }
> >
> > -static void swap_read_folio_bdev_sync(struct folio *folio,
> > -               struct swap_info_struct *sis)
> > +static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
> > +                                     struct folio *folio,
> > +                                     struct swap_iocb **plug)
> >  {
> >         struct bio_vec bv;
> >         struct bio bio;
> > @@ -591,8 +575,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
> >         put_task_struct(current);
> >  }
> >
> > -static void swap_read_folio_bdev_async(struct folio *folio,
> > -               struct swap_info_struct *sis)
> > +static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
> > +                                      struct folio *folio,
> > +                                      struct swap_iocb **plug)
> >  {
> >         struct bio *bio;
> >
> > @@ -606,6 +591,42 @@ static void swap_read_folio_bdev_async(struct folio *folio,
> >         submit_bio(bio);
> >  }
> >
> > +static struct swap_ops bdev_fs_swap_ops = {
> > +       .read_folio = swap_read_folio_fs,
> > +       .write_folio = swap_writepage_fs,
> > +};
> 
> const?

Right, will fix in v2.

> 
> > +
> > +static struct swap_ops bdev_sync_swap_ops = {
> > +       .read_folio = swap_read_folio_bdev_sync,
> > +       .write_folio = swap_writepage_bdev_sync,
> > +};
> 
> const?
> 
> > +
> > +static struct swap_ops bdev_async_swap_ops = {
> > +       .read_folio = swap_read_folio_bdev_async,
> > +       .write_folio = swap_writepage_bdev_async,
> > +};
> 
> const?
> 
> > +
> > +int probe_swap_fs(struct swap_info_struct *sis)
> > +{
> > +       /*
> > +        * ->flags can be updated non-atomically (scan_swap_map_slots),
> > +        * but that will never affect SWP_FS_OPS, so the data_race
> > +        * is safe.
> > +        */
> > +       if (data_race(sis->flags & SWP_FS_OPS))
> > +               sis->ops = &bdev_fs_swap_ops;
> > +       /*
> > +        * ->flags can be updated non-atomically (scan_swap_map_slots),
> > +        * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> > +        * is safe.
> > +        */
> > +       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > +               sis->ops = &bdev_sync_swap_ops;
> > +       else
> > +               sis->ops = &bdev_async_swap_ops;
> > +       return 0;
> > +}
> > +
> >  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >  {
> >         struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> > @@ -640,13 +661,8 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >         /* We have to read from slower devices. Increase zswap protection. */
> >         zswap_folio_swapin(folio);
> >
> > -       if (data_race(sis->flags & SWP_FS_OPS)) {
> > -               swap_read_folio_fs(folio, plug);
> > -       } else if (synchronous) {
> > -               swap_read_folio_bdev_sync(folio, sis);
> > -       } else {
> > -               swap_read_folio_bdev_async(folio, sis);
> > -       }
> > +       if (sis->ops && sis->ops->read_folio)
> > +               sis->ops->read_folio(sis, folio, plug);
> >
> >  finish:
> >         if (workingset) {
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 915bc93964db..af498f9af328 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3625,6 +3625,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >         /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
> >         enable_swap_info(si);
> >
> > +       probe_swap_fs(si);
> 
> Can we move this to enable_swap_info(), or perhaps even
> deeper into setup_swap_info()?
> 
> > +
> >         pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
> >                 K(si->pages), name->name, si->prio, nr_extents,
> >                 K((unsigned long long)span),
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index a399f7a10830..7ce906249c7a 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1055,7 +1055,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
> >         folio_set_reclaim(folio);
> >
> >         /* start writeback */
> > -       __swap_writepage(folio, NULL);
> > +       if (si->ops && si->ops->write_folio)
> > +               si->ops->write_folio(si, folio, NULL);
> 
> swap_write_folio() inline wrapper?

Replied at above place. We will need a read_folio version too.


