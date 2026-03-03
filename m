Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8125DEC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C5D6B0162; Tue,  3 Mar 2026 05:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E744D6B0164; Tue,  3 Mar 2026 05:41:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0A16B0165; Tue,  3 Mar 2026 05:41:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C680B6B0162
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:41:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 718958B713
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:41:49 +0000 (UTC)
X-FDA: 84504411138.05.BB412A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5B34A40006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:41:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e4ta6hfT;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Re2vvxmKHDUNoRlLMlN5C18DNibzpykpL7D4wljfn8=;
	b=RGge1pU5du66v+QxisMHW5694/BaH9rnOVWKsq1vZNsB2gWVlbemz/NIVc8CVavQd30BEX
	FNSUd20c/n+V9bE6BALqW3G/tKs24R5xOFx0U+a2yPtDiuwqBmAKqrZ7pNwGiVEfrn9HPV
	vNI+yktWnB/gh/Dp3tMUQ6WtI4DqNTg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e4ta6hfT;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534507; a=rsa-sha256;
	cv=none;
	b=z6XirZFiVsTC4VWUNTkgeiOFo7gdb7DFJIsty7Vyw1D2Pxy9eOsxRT8HsComkgFmauzRkw
	HK0ofBKg4UKUYK9qRSF50rcKVGKo5IT+CGClbYmynjM7e5oN/TARwJCTttT8tsdkNaSin9
	iAn58aPD+1b1IIk4QAmN3pxzHcg9zd0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772534506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Re2vvxmKHDUNoRlLMlN5C18DNibzpykpL7D4wljfn8=;
	b=e4ta6hfTpnCuPa1a06cq+CkwF1jG7hRMA+oG+BVTZEqXRBwHx7dv/1/MDgcHb310LNXyrM
	mI+npHPXzN9DnB1e7htBYYLYXhgA4++74M859L9zZ5JqlI4MGZu29pzJV5JOP1k4rgod3q
	mFg3TEmGDqbcjNHUOwQB7QhYyGcg0Zc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-390-ovpAPNhVMYeamDaMeNtVpA-1; Tue,
 03 Mar 2026 05:41:42 -0500
X-MC-Unique: ovpAPNhVMYeamDaMeNtVpA-1
X-Mimecast-MFC-AGG-ID: ovpAPNhVMYeamDaMeNtVpA_1772534500
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C16E18004BB;
	Tue,  3 Mar 2026 10:41:40 +0000 (UTC)
Received: from localhost (unknown [10.72.112.42])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95F4230001B9;
	Tue,  3 Mar 2026 10:41:38 +0000 (UTC)
Date: Tue, 3 Mar 2026 18:41:32 +0800
From: Baoquan He <bhe@redhat.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baohua@kernel.org, youngjun.park@lge.com
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aaa63OdTm-JFVa1J@MiWiFi-R3L-srv>
References: <20260302104016.163542-3-bhe@redhat.com>
 <20260302145307.320941-1-usamaarif642@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260302145307.320941-1-usamaarif642@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M7AJX5tmcP-fBNPKV8AT0D6ccc2fwRuIuRM4z20ejs4_1772534500
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: s5wbg9jo465ay3gubfyeefrpcub8o7gj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B34A40006
X-HE-Tag: 1772534507-962640
X-HE-Meta: U2FsdGVkX1/O+dvlOVl7QHTQV4Z0GojWkNmMTy8CuOSPo/AXI7Xvw+uoisAsHU/TQJbj4vCEjsaP4NGbhcDeJfI0nkfwVla2A2LU4HtlxIzPQ9LgzVGTweUV6O5nINwCtAORPrPjVJ3wEFTDTwxGoyC+1iXX/W8VTcrrzQ1hpnqSayavxtp3kO7bwn9FQDfsWSG/N2VWN4y/GEv9It7FpNRDGKRtAtE44m+Xq+O7Vr9jvCmjVxhK7emsUUcOduws3agrY9uHqYUMdHwf0FXSKatO17E/mADjLz1584WSAxhlrXWlvStiS/1yShoUlrH08gu+dr7k9eZgfuVzD9Xw+xxRSJM7q2Bopuvk3UV0ulS88zjWSle0ZTWVOxciikgQxIjhQdoL1DI1oGwIMFCkaaqCDy5GIzgiaBzdSgwTpJphzwSOJmdwaQY8mEvr7NpRQbzG75rKBFGiYE2SBWSndXvXxLFrtpvYoXRA7LUtlGsyqknaBPrvF4hLRwFnrBuF+iPBsPPpBYh+EEx96/YRZqLwPLFT8jOEgCQ3BuzKIEL2XVrLhfNkW2yX5JavN7GUREFUVa5RLYTqpSv+o1myrpeZuTHkrJRlR/YJ8GytxyXAuuDOfMMykKDoXPCWX5ppIZ91oif1DtP6ImbcknNOCf/qiXBcZnvPiixWgXT/KYmwsoPzeezALec/pVd2mL5f3fZgYZTPnq8Llg1DwmyQ9MhO6AtJITdzAjGZ03+X8FAIhI6ZMiJk+8K/COrR61pIPJHzR627VGZB++OgWMxSXJNhrhbfxrFF9UNyfkAW27xQw2z/wDryUWPbjTaH4YhSweuERjthBfj2AMSja/vcnmmsloCRDnHQ3IJyagtAudVgulraByjcmvuRdaiezo0FqHBYY/t4CosnX1robfUBvZQ0hd0aohgsQD4X9oGj8hHOUTAz5T0C2pyvTZ2s5uiUOIhOq/s6Nb5mdUdn1vk
 lkMLtZQH
 Dx/PGreyWAeJ0NDi9wC65bukbgV+CkqX5O33pcTQ4aTsUUrQsHHM9Px0Rti4GUloJ0njfVLIeWZimNoxoDeXYb/GUPT8TKBLWgKv7AYPJAxJf2pe7vpCnINXYgRwB9HnyPuTwFtfRJrBPMChwLu0N7AY591iIddrhwGyUAlrYBfo91403HxVWOURNDLhiVUeRKmc0lRhiyzDRtXH9GQFtS062FVwsA4xE2zpmrie+e9LRwgzK9thvkP+XUY1D6dUBZwURkZgDBxr3XQkUQ5SqmqVSlUXHwePFqUHTVwPNizRoBWa/QFrr10o0w3v7zJLx/25K3mx1kaVO8NbDVvOPtnsbCms1sAqbGR1fykah0FlKBWzI3S/cfsfA/quTbUVb7UPJr4DmeDgEnmDrOq0yWWR0HlrkUfgEqiQA3MHmpCvj8MgQnNBHOfSQbjPR7MIl/EKQoSZF3MPS13GGtrDGyZQvV43p1stNVz9S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/02/26 at 06:53am, Usama Arif wrote:
> On Mon,  2 Mar 2026 18:40:15 +0800 Baoquan He <bhe@redhat.com> wrote:
> 
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
> > +	void (*read_folio)(struct swap_info_struct *sis,
> > +			   struct folio *folio,
> > +			   struct swap_iocb **plug);
> > +	void (*write_folio)(struct swap_info_struct *sis,
> > +			    struct folio *folio,
> > +			    struct swap_iocb **plug);
> > +};
> > +
> > +int probe_swap_fs(struct swap_info_struct *sis);
> > +
> 
> Would it be better to put these in mm/swap.h as they are only used in mm/?

Right, other reviewers also pointed this out. Will change in v2.

> 
> >  /*
> >   * The first page in the swap file is the swap header, which is always marked
> >   * bad to prevent it from being allocated as an entry. This also prevents the
> > @@ -284,6 +296,7 @@ struct swap_info_struct {
> >  	struct work_struct reclaim_work; /* reclaim worker */
> >  	struct list_head discard_clusters; /* discard clusters list */
> >  	struct plist_node avail_list;   /* entry in swap_avail_head */
> > +	struct swap_ops *ops;
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
> >  	int ret = 0;
> > +	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> >  
> >  	if (folio_free_swap(folio))
> >  		goto out_unlock;
> > @@ -281,7 +282,8 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
> >  		return AOP_WRITEPAGE_ACTIVATE;
> >  	}
> >  
> > -	__swap_writepage(folio, swap_plug);
> > +	if (sis->ops && sis->ops->write_folio)
> > +		sis->ops->write_folio(sis, folio, swap_plug);
> 
> The old __swap_writepage() always dispatched to one of the three write
> functions unconditionally. If the guard condition is false (ops is NULL),
> swap_writeout() returns 0 (success) but the folio is never unlocked --
> the write functions are the ones that call folio_unlock(). Would this
> leave the folio locked and lead to a deadlock? Similar issue in swap_read_folio.

Hmm, for now NULL sis->ops won't happen. But we could have it in the
future, means there could be a swap device w/o read/write_folio methods.

> 
> >  	return 0;
> >  out_unlock:
> >  	folio_unlock(folio);
> > @@ -371,10 +373,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
> >  	mempool_free(sio, sio_pool);
> >  }
> >  
> > -static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
> > +static void swap_writepage_fs(struct swap_info_struct *sis,
> > +			      struct folio *folio,
> > +			      struct swap_iocb **swap_plug)
> >  {
> >  	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
> > -	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> >  	struct file *swap_file = sis->swap_file;
> >  	loff_t pos = swap_dev_pos(folio->swap);
> >  
> > @@ -407,8 +410,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
> >  		*swap_plug = sio;
> >  }
> >  
> > -static void swap_writepage_bdev_sync(struct folio *folio,
> > -		struct swap_info_struct *sis)
> > +static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
> > +				     struct folio *folio,
> > +				     struct swap_iocb **plug)
> >  {
> >  	struct bio_vec bv;
> >  	struct bio bio;
> > @@ -427,8 +431,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
> >  	__end_swap_bio_write(&bio);
> >  }
> >  
> > -static void swap_writepage_bdev_async(struct folio *folio,
> > -		struct swap_info_struct *sis)
> > +static void swap_writepage_bdev_async(struct swap_info_struct *sis,
> > +				      struct folio *folio,
> > +				      struct swap_iocb **plug)
> >  {
> >  	struct bio *bio;
> >  
> > @@ -444,29 +449,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
> >  	submit_bio(bio);
> >  }
> >  
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> > -{
> > -	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> > -
> > -	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> > -	/*
> > -	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> > -	 * but that will never affect SWP_FS_OPS, so the data_race
> > -	 * is safe.
> > -	 */
> > -	if (data_race(sis->flags & SWP_FS_OPS))
> > -		swap_writepage_fs(folio, swap_plug);
> > -	/*
> > -	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> > -	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> > -	 * is safe.
> > -	 */
> > -	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > -		swap_writepage_bdev_sync(folio, sis);
> > -	else
> > -		swap_writepage_bdev_async(folio, sis);
> > -}
> > -
> >  void swap_write_unplug(struct swap_iocb *sio)
> >  {
> >  	struct iov_iter from;
> > @@ -535,9 +517,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
> >  	return true;
> >  }
> >  
> > -static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
> > +static void swap_read_folio_fs(struct swap_info_struct *sis,
> > +			       struct folio *folio,
> > +			       struct swap_iocb **plug)
> >  {
> > -	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> >  	struct swap_iocb *sio = NULL;
> >  	loff_t pos = swap_dev_pos(folio->swap);
> >  
> > @@ -569,8 +552,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
> >  		*plug = sio;
> >  }
> >  
> > -static void swap_read_folio_bdev_sync(struct folio *folio,
> > -		struct swap_info_struct *sis)
> > +static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
> > +				      struct folio *folio,
> > +				      struct swap_iocb **plug)
> >  {
> >  	struct bio_vec bv;
> >  	struct bio bio;
> > @@ -591,8 +575,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
> >  	put_task_struct(current);
> >  }
> >  
> > -static void swap_read_folio_bdev_async(struct folio *folio,
> > -		struct swap_info_struct *sis)
> > +static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
> > +				       struct folio *folio,
> > +				       struct swap_iocb **plug)
> >  {
> >  	struct bio *bio;
> >  
> > @@ -606,6 +591,42 @@ static void swap_read_folio_bdev_async(struct folio *folio,
> >  	submit_bio(bio);
> >  }
> >  
> > +static struct swap_ops bdev_fs_swap_ops = {
> > +	.read_folio = swap_read_folio_fs,
> > +	.write_folio = swap_writepage_fs,
> > +};
> > +
> > +static struct swap_ops bdev_sync_swap_ops = {
> > +	.read_folio = swap_read_folio_bdev_sync,
> > +	.write_folio = swap_writepage_bdev_sync,
> > +};
> > +
> > +static struct swap_ops bdev_async_swap_ops = {
> > +	.read_folio = swap_read_folio_bdev_async,
> > +	.write_folio = swap_writepage_bdev_async,
> > +};
> > +
> 
> Should we have all of these as static const struct swap_ops?

You are right, I will fix them in v2.

> 
> > +int probe_swap_fs(struct swap_info_struct *sis)
> > +{
> > +	/*
> > +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> > +	 * but that will never affect SWP_FS_OPS, so the data_race
> > +	 * is safe.
> > +	 */
> > +	if (data_race(sis->flags & SWP_FS_OPS))
> > +		sis->ops = &bdev_fs_swap_ops;
> > +	/*
> > +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> > +	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> > +	 * is safe.
> > +	 */
> > +	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > +		sis->ops = &bdev_sync_swap_ops;
> > +	else
> > +		sis->ops = &bdev_async_swap_ops;
> > +	return 0;
> 
> The return is always 0, so this function could be void.

Yes, I will change.

> 
> > +}
> > +
> >  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >  {
> >  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> > @@ -640,13 +661,8 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >  	/* We have to read from slower devices. Increase zswap protection. */
> >  	zswap_folio_swapin(folio);
> >  
> > -	if (data_race(sis->flags & SWP_FS_OPS)) {
> > -		swap_read_folio_fs(folio, plug);
> > -	} else if (synchronous) {
> > -		swap_read_folio_bdev_sync(folio, sis);
> > -	} else {
> > -		swap_read_folio_bdev_async(folio, sis);
> > -	}
> > +	if (sis->ops && sis->ops->read_folio)
> > +		sis->ops->read_folio(sis, folio, plug);
> >  
> >  finish:
> >  	if (workingset) {
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 915bc93964db..af498f9af328 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3625,6 +3625,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >  	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
> >  	enable_swap_info(si);
> >  
> > +	probe_swap_fs(si);
> > +
> 
> Should probe_swap_fs() be called before enable_swap_info() rather than
> after it? enable_swap_info() sets SWP_WRITEOK and adds the device to
> swap_active_head, making it available for allocation. At that point
> si->ops is still NULL. If another CPU allocates swap from the new
> device and reclaim writes to it before probe_swap_fs() runs, the
> write will be silently dropped.

Good catch and I agree with you. I will change to call probe_swap_fs() 
before enable_swap_info().

> 
> >  	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
> >  		K(si->pages), name->name, si->prio, nr_extents,
> >  		K((unsigned long long)span),
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index a399f7a10830..7ce906249c7a 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1055,7 +1055,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
> >  	folio_set_reclaim(folio);
> >  
> >  	/* start writeback */
> > -	__swap_writepage(folio, NULL);
> > +	if (si->ops && si->ops->write_folio)
> > +		si->ops->write_folio(si, folio, NULL);
> >  
> >  out:
> >  	if (ret && ret != -EEXIST) {
> > -- 
> > 2.52.0
> 


