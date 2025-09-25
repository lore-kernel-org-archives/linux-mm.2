Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5AC9CAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 06:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33A188E0005; Thu, 25 Sep 2025 02:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EAE28E0001; Thu, 25 Sep 2025 02:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9448E0005; Thu, 25 Sep 2025 02:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 089DF8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:19:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90DAC58767
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:19:03 +0000 (UTC)
X-FDA: 83926769766.13.BBD1ABD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 87DBC40005
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:19:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NM9tB7D6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758781141; a=rsa-sha256;
	cv=none;
	b=EQCIRznFGEgMzTIAh1J0ns2f2QDk7MEPJdKWknt0wFIX+fVQgtYVolQ1x/2J4JwIjZzu/g
	hOHKbEaMQTn4OqiJOa7hte1WijhhhdE2xd9nLspINl9XRFyWwv5vKK0hIz2PGQ1yVjJv4t
	cfiqlSQGodROO4Obq+kUtuUT18mujRM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NM9tB7D6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758781141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hwn8p9903pgXYpd0pkWk7OBG995xEuu/g/XYs/DcXsk=;
	b=XzMhSLH0ofHaFKKchyneEzW3g/+3He67odrd3wB0LsLGyaGrPK9jxkKoz0p7xFmT1HfzlH
	KbYqZ/5JDP1+VuU1nb/+hLubfTuO8VlVlHqaJLTeZICFJwsADIRTZ5le2fhQ+onxwhgQyy
	Gs8RewYpErx58+wsh1oDFTy9RCSlF5U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758781140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hwn8p9903pgXYpd0pkWk7OBG995xEuu/g/XYs/DcXsk=;
	b=NM9tB7D6LH+lV6OdpxSzZDtYjnKgeGeBDoSUv9EEFKbOxg8GIg5rnUqh6KRX/3KmrHcmuh
	b14P3H6VXwvIixchrO1SW6fntXkNdvemKJvOVOOUng802lXUthpO+DtiMtWm5TlNaNQlD1
	XvDjngzSnXEBQb4LcGe2hTh+nipqMM8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-FK5XEpU3Pi-FXhk0i-SOfA-1; Thu,
 25 Sep 2025 02:18:57 -0400
X-MC-Unique: FK5XEpU3Pi-FXhk0i-SOfA-1
X-Mimecast-MFC-AGG-ID: FK5XEpU3Pi-FXhk0i-SOfA_1758781136
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68C7919560A1;
	Thu, 25 Sep 2025 06:18:55 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D35F81800451;
	Thu, 25 Sep 2025 06:18:53 +0000 (UTC)
Date: Thu, 25 Sep 2025 14:18:49 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNTeyRLCRFN4kcdT@MiWiFi-R3L-srv>
References: <20250924091746.146461-1-bhe@redhat.com>
 <CAMgjq7CtBRjwxCp=HvW5xZUGg-5MgKLOHy2tJ+0GC7KmA1BNjw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMgjq7CtBRjwxCp=HvW5xZUGg-5MgKLOHy2tJ+0GC7KmA1BNjw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i7OxNlbgsF225era2ib3m_t-v0s2obyFwoPNk41Bqjc_1758781136
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87DBC40005
X-Stat-Signature: mwds56mnoqgrotgeqpo5xw7iirnajo9y
X-Rspam-User: 
X-HE-Tag: 1758781141-132661
X-HE-Meta: U2FsdGVkX183eTSTek8zfvzWvtJpJ/8yNNhVn60ioaoV+0m5qfw/HqElsbOUesBKNK2Q3eUT7xezkaKmPUuDhGhboS4Wrw+VohdRwgk7rRpQ+YfMJlaVWsQIzevO46pH07bBYXDO3Z9db6Zti0mlTTgia1VL1MYvchPadYBy6KvodlM9bI5EQjuonNJra+Z6/Thc+70VZoItizJUXjEgghXxt2bq9z9zFAmQ3JiU4Dwu2kF7kaPXhXMvnu8m01DfTSGkt6L2sl2N1JJ5x/MZCiPpeso/QO6VS4eeyakPCUVgPBQpuQaV/yyoUIZwhBG2haDFOV1HY0LL9iSLlb+GwHlUq43/SzrPTURmKoNGMED1kYGKgHwY2t2v3e16khqATZIcETT28LGyuBEYV3WCfFsD6tG7NVt7zqSl2AN9BrsBr1HcQRafLcR/4cIhZgM+SDXlHqi/A6y1fW6chYYq+SSPcX6sbHE9MkCDvHVFZMxXkbPIvDgrbzf6BNuSLo9sgVGRgOi8+6XWBFE/ZbPztDY/KGcnbt25zeOkl4PCi6X2LSvoAkVidjlAy5IwQfS3CW2U+STcI2E9dbAHCvy4Yt2+Bk4LfunJT9m17UXiT8HJU3qN68meVvcEDChQjX39jw+Cv+mWeBp/lzMKDxoNBHxI+/j92ruo4+X+5vyaNsYr+nyYdHfa6r9G40TZWBalP/9OgPNUm0XpQ6eIB+J9G3cMugtg5aGSyYsGhhrhSgb7/+IvZrrcd72vt5DMJEMHMa1DL3wlgy97YlC0/U9MAZonn2t5S0WJX1N1LTbF1b6B3XsDD7pfMJXWTlB9MWaKl3pOJdiemdbYiFJwTFNOCNATGI/wEsm7P71nQIuZmc1m3h8rMG84wgNp/ZhBhSFKHsRnYXHEk/I+c/UMfiDpKdHhraKHMYEL6ByYFwWqWcfWAZ8+CLYohXtdwNuap95o82XamKF4LdZH4OF2uwG
 +bpu7yL9
 nc9UR2QqhgDf2rs2lXuZmdt9FiCRHULEE8chSBGrAU5DEiwBmg+G3XHBw3XrPghV/qn4L7/zKowdXJgrvDpx4AbDEelRTph1L0n9k+4fGT0JXNb+rW7Bu6WWnY9UrnuBmloaccyNBs9R0jRaF7LQf8gVJXNxtNsm9OdPdzcSRAjozYUGCJos45qyuAtP6vSC9u20Sg/US7gODk+Z0cpOs77PpjWceCTw4La+mhfGX+wxixAcOlil3ondL6ODdKs+lTb2wFj/D8rzyPXMZa5ckgYBPSfhxMOqZCObR/PfEGVjdMq9rw6nZtgSNTMz7smZgOQL1c8dCPY7auIypxowAuTOHWVlTNyttBrVFNr8o3AYG5YvpiX8afWpJjKMSSgxBBxZme5mRlBeo61CQetIFBBt+USSw700cxWVx89o9dhc7ru35tlbnvkDJPQXTY4Fjy/p4oNYti/dekPqpfPgFjwj34n439jxCSnd3+I4/Iwq7YamSlb1WmZdUwpPkwJP/0SKuqcq+CRJCTAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/25/25 at 12:36pm, Kairui Song wrote:
> On Wed, Sep 24, 2025 at 6:15 PM Baoquan He <bhe@redhat.com> wrote:
......
> > vm-scability test:
> > ==================
> > Test with:
> > usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
> >                            Before:          After:
> > System time:               637.92 s         526.74 s
> > Sum Throughput:            3546.56 MB/s     4207.56 MB/s
> > Single process Throughput: 114.40 MB/s      135.72 MB/s
> > free latency:              10138455.99 us   6810119.01 us
> >
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/swap.h | 11 +-----
> >  mm/swapfile.c        | 94 +++++++-------------------------------------
> >  2 files changed, 16 insertions(+), 89 deletions(-)
> 
> Hi Baoquan,
> 
> Thanks to the patch! The node plist thing always looked confusing to me.

Thanks.

> 
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 3473e4247ca3..f72c8e5e0635 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -337,16 +337,7 @@ struct swap_info_struct {
> >         struct work_struct discard_work; /* discard worker */
> >         struct work_struct reclaim_work; /* reclaim worker */
> >         struct list_head discard_clusters; /* discard clusters list */
> > -       struct plist_node avail_lists[]; /*
> > -                                          * entries in swap_avail_heads, one
> > -                                          * entry per node.
> > -                                          * Must be last as the number of the
> > -                                          * array is nr_node_ids, which is not
> > -                                          * a fixed value so have to allocate
> > -                                          * dynamically.
> > -                                          * And it has to be an array so that
> > -                                          * plist_for_each_* can work.
> > -                                          */
> > +       struct plist_node avail_list;   /* entry in swap_avail_head */
> >  };
> >
> >  static inline swp_entry_t page_swap_entry(struct page *page)
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index b4f3cc712580..d8a54e5af16d 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
> >  EXPORT_SYMBOL_GPL(nr_swap_pages);
> >  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
> >  long total_swap_pages;
> > -static int least_priority = -1;
> > +#define DEF_SWAP_PRIO  -1
> >  unsigned long swapfile_maximum_size;
> >  #ifdef CONFIG_MIGRATION
> >  bool swap_migration_ad_supported;
> > @@ -102,7 +102,7 @@ static PLIST_HEAD(swap_active_head);
> >   * is held and the locking order requires swap_lock to be taken
> >   * before any swap_info_struct->lock.
> >   */
> > -static struct plist_head *swap_avail_heads;
> > +static PLIST_HEAD(swap_avail_head);
> >  static DEFINE_SPINLOCK(swap_avail_lock);
> >
> >  static struct swap_info_struct *swap_info[MAX_SWAPFILES];
> > @@ -995,7 +995,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
> >  /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
> >  static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
> >  {
> > -       int nid;
> >         unsigned long pages;
> >
> >         spin_lock(&swap_avail_lock);
> > @@ -1007,7 +1006,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
> >                  * swap_avail_lock, to ensure the result can be seen by
> >                  * add_to_avail_list.
> >                  */
> > -               lockdep_assert_held(&si->lock);
> > +               //lockdep_assert_held(&si->lock);
> 
> If this needs to be removed, then it doesn't seem to comply with the
> comment above?
> 
> Here we are modifying si->flags, which is supposed to be protected by si lock.

You are right, I was wrong when changing code and debugging, will add it
back in v2. Thanks a lot for careful checking.


