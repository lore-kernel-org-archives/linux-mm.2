Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F74CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 12:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9364E8E000E; Thu,  2 Oct 2025 08:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D3B8E0002; Thu,  2 Oct 2025 08:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A648E000E; Thu,  2 Oct 2025 08:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 723428E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:40:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D700F11943A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:40:34 +0000 (UTC)
X-FDA: 83953132788.02.7B7B308
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D485716000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:40:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RrAglgvH;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759408832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPrHISj8VLZ5M3SVxpDYBqdgMG635W2kjZnQFxBLWYI=;
	b=DrcQOkYx2/iKiT8oMkZ2BWDUok90ouR80XtR3KrWxy9W2x82RhaEYnsypVnZj4OOkBij8l
	RKVWKckTWUxJXSlbpkgAurDfPiB+masYHB8WNGrtXeokAzs7L3OLRpRlFFMOR90tmc4Qr0
	Lu2bNteJkwLYEnVP/qZnVfT1BfppGcI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RrAglgvH;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759408832; a=rsa-sha256;
	cv=none;
	b=2C9KobnETWX0Rpk7JE4iLsc3cOApvnfptufIq00F/LcLS0RhIF2jGuEKY94hA7lHJoKxxf
	uWKYBkTreGfGDSXiJgb9QV3Qo1YAPl51n+cgua4xpuwQ1MCYCc+KpuULS0tm632dVsDhWh
	TYzaruyfzA8FrhgSRFahE7G5jfoE2yg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759408832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPrHISj8VLZ5M3SVxpDYBqdgMG635W2kjZnQFxBLWYI=;
	b=RrAglgvHG6/TRoQ2jHNpHWcTjLgOVnD8rqzrn9cjZk8O/zCr8upQcXg6jCo/6BASBe9R1N
	OJLbPyc2I2skYtiI1bWbD8X/yECfqSmExbL/S74QtyGohCV0t+BbrtqmCs0hpA+y7Zc4jG
	QJNuYWhBfA+UeMh2D7SczsDxiu43kyU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-hY_sJl0IOnu2Fkfu4v_EQA-1; Thu,
 02 Oct 2025 08:40:29 -0400
X-MC-Unique: hY_sJl0IOnu2Fkfu4v_EQA-1
X-Mimecast-MFC-AGG-ID: hY_sJl0IOnu2Fkfu4v_EQA_1759408827
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64B171955BE1;
	Thu,  2 Oct 2025 12:40:26 +0000 (UTC)
Received: from localhost (unknown [10.72.112.47])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEF3C19560B1;
	Thu,  2 Oct 2025 12:40:24 +0000 (UTC)
Date: Thu, 2 Oct 2025 20:40:20 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v3 2/2] mm/swap: select swap device with default priority
 round robin
Message-ID: <aN5ytDQPCx9EQx1t@localhost>
References: <20250930063311.14126-1-bhe@redhat.com>
 <20250930063311.14126-3-bhe@redhat.com>
 <CACePvbUozJDOtj2hcepfhp865vGou7-s48NbrJ5sBT_udOeCgA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbUozJDOtj2hcepfhp865vGou7-s48NbrJ5sBT_udOeCgA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LMmRuWn8AcilhEs3ox0vnnC4LR78TEQIAjSG5sLRLuE_1759408827
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ht344q7xq1z94x7b9rjx86echqsekf5t
X-Rspam-User: 
X-Rspamd-Queue-Id: D485716000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1759408832-271349
X-HE-Meta: U2FsdGVkX1+QShwynUdg9RzPZJaLdkFKLgC9Zl52MSEjBcanglVg85vxSy8XYEP9ogwfmlZkjgCDm1rnCXIDIyctEmYkY5Ci/HWBbXtwrD46BnE63dd0F3HcDI2w1GcSPjRpgT3SBJJsHlaU5uHTdRrEwulY8zkYm2QPF6dJx4JV/BqvLjqb7MsR/ESd2sD0ha0HcIkyFMaF9nX066elBxdw3lsfzFTBpl23x0XMcY08U0stJ26GGesqh0hLXG63ZQfVZwGrLLi98Lful2PiX2CAOXexG/G9JKixHQQwPXiVG0DqwlnUaUyMf3ittUB4VldUkYnsC1kGNeuI6HhA3w9QxZxKdLNAs7TBjUXUE9MZkXXzkxHM68SgEqJKy9h/QaHnaL3u4gG9QGtvrqFInp4tyef435HJwnwSJd/eBfJ824qqfBSGEkdtxB8elLBLifu6UFgaZu9Lh0HcaKLFB/ZiZpQnohqKUajlmQJCR5NCJUmNcM6jyBvhgWCfmFWZuj/qEuWRCpQMfqSjyY0ZouhctKomioPv4UM8bSdBXyHwdRvX2QQmuU5wudUkAa01pMILPr8lRfUsx6KXqa8q4lMWvQz+WBHJZO14r1+okxEg2RFQQiMg5uoly40T+DcrB5LfUs+Jx/Km7UGsviTa7kdJLWpaHcRBklNXiTCxKxlUQiwRMlbFnSHdTtuCRRMJ2Pra81ilPnxFN6gm8Jt7cwKlyH+/Vc2ANiwMRgiLtdS5c6a0faBkomXtnBm0a+PHiYwfBs+xnx4KCHgKZd2lPmdTckDu7XNKiq2zTulLIis0Up9S6WZ1gy1Ggihu6rpEro5I74nOw6Af6R0pCmkPSLjP3uAeyguOfd8n35VINKqMC9hDjNLCq13iQ8MK7m7MmhXV8Ja51wCbYQhF5dPyuWFRie+rtQ3FZEEr1j9+o1tP7upOQ116mP9GgPA3HDTfnLrVn8O8EOyh6BQk9qf
 6wAOdAuA
 ygR0qJ7oEDLu/rIsOrcWGERus+EMN7ataxXmd+Se0zhr04kNV1XNKTqEYZY8d1i7w8rLIy7eaCgfLjWkfiUEH8mnI7LqqqRUtW/xO2GQ/eNAdTyvIpvIvzF6XmY+1C1+QZUKOU2wStTT5pJfOLeNwYYSGXCBIy60YtcWD4oUZ6xwMl9ho072QkmfrNFGH9YUobj9LzTnTZjebBEyhgcumhmB/s9cwSJNG1pe/hVhfsd1hQ1V3ObR9Q9rT141EYwiY3hF1uT5baLUTJHGR1DG/VbArcXQXgG78rwD/pPc5QYIpksQPySNm3+Uqjv1jVj4v9AMk5Wxwcc7Uh+Qy9/YJ7J1kYuicsml2cghxd603NYOpfjT8/lHpPISIMecl7cebWk/R+JFC3clhFsGtoTnk8FedLVEnt07g3D2y5rSOU9C9tKLbogRqI3b7EtjxGk27bx0gLgP5TN35AT2/obKVx28oWSjpxiwBwrDD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/01/25 at 08:03pm, Chris Li wrote:
> Thanks for removing the node id complexity. Those negative priorities
> have been very hard to follow and reason. Now with the extra 18%
> performance boost just cherry on top.
> 
> I am very happy with this outcome. Could not ask for better.
> 
> Acked-by: Chris Li <chrisl@kernel.org>

Thanks a lot for careful reviewing.

> 
> Chris
> 
> On Mon, Sep 29, 2025 at 11:33 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > Swap devices are assumed to have similar accessing speed if no priority
> > is specified when swapon. It's unfair and doesn't make sense just because
> > one swap device is swapped on firstly, its priority will be higher than
> > the one swapped on later.
> >
> > Here, set all swap devicess to have priority '-1' by default. With this
> > change, swap device with default priority will be selected round robin
> > when swapping out. This can improve the swapping efficiency a lot among
> > multiple swap devices with default priority.
> >
> > Below are swapon output during processes high pressure vm-scability test
> > is being taken:
> >
> > 1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one by
> >    priority from high to low when one swap device is exhausted:
> > ------------------------------------
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE   USED PRIO
> > /dev/zram0 partition  16G    16G   -1
> > /dev/zram1 partition  16G 966.2M   -2
> > /dev/zram2 partition  16G     0B   -3
> > /dev/zram3 partition  16G     0B   -4
> >
> > 2) This is behaviour with commit a2468cc9bfdf, on node, swap device
> >    sharing the same node id is selected firstly until exhausted; while
> >    on node no swap device sharing the node id it selects the one with
> >    highest priority until exhaustd:
> > ------------------------------------
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE  USED PRIO
> > /dev/zram0 partition  16G 15.7G   -2
> > /dev/zram1 partition  16G  3.4G   -3
> > /dev/zram2 partition  16G  3.4G   -4
> > /dev/zram3 partition  16G  2.6G   -5
> >
> > 3) After this patch applied, swap devices with default priority are selectd
> >    round robin:
> > ------------------------------------
> > [root@hp-dl385g10-03 block]# swapon
> > NAME       TYPE      SIZE USED PRIO
> > /dev/zram0 partition  16G 6.6G   -1
> > /dev/zram1 partition  16G 6.6G   -1
> > /dev/zram2 partition  16G 6.6G   -1
> > /dev/zram3 partition  16G 6.6G   -1
> >
> > With the change, we can see about 18% efficiency promotion relative to
> > node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
> > the worst.)
> >
> > vm-scability test:
> > ==================
> > Test with:
> > usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
> >                             one by one:      node based:      round robin:
> > System time:                1087.38 s        637.92 s         526.74 s     (lower is better)
> > Sum Throughput:             2036.55 MB/s     3546.56 MB/s     4207.56 MB/s (higher is better)
> > Single process Throughput:  65.69 MB/s       114.40 MB/s      135.72 MB/s  (high is better)
> > free latency:               15769409.48 us   10138455.99 us   6810119.01 us(lower is better)
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  mm/swapfile.c | 31 ++++---------------------------
> >  1 file changed, 4 insertions(+), 27 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index f9b3667fb08a..2bd8bd76ea28 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
> >  EXPORT_SYMBOL_GPL(nr_swap_pages);
> >  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
> >  long total_swap_pages;
> > -static int least_priority;
> > +#define DEF_SWAP_PRIO  -1
> >  unsigned long swapfile_maximum_size;
> >  #ifdef CONFIG_MIGRATION
> >  bool swap_migration_ad_supported;
> > @@ -2534,10 +2534,7 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
> >                             struct swap_cluster_info *cluster_info,
> >                             unsigned long *zeromap)
> >  {
> > -       if (prio >= 0)
> > -               si->prio = prio;
> > -       else
> > -               si->prio = --least_priority;
> > +       si->prio = prio;
> >         /*
> >          * the plist prio is negated because plist ordering is
> >          * low-to-high, while swap ordering is high-to-low
> > @@ -2555,16 +2552,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
> >         total_swap_pages += si->pages;
> >
> >         assert_spin_locked(&swap_lock);
> > -       /*
> > -        * both lists are plists, and thus priority ordered.
> > -        * swap_active_head needs to be priority ordered for swapoff(),
> > -        * which on removal of any swap_info_struct with an auto-assigned
> > -        * (i.e. negative) priority increments the auto-assigned priority
> > -        * of any lower-priority swap_info_structs.
> > -        * swap_avail_head needs to be priority ordered for folio_alloc_swap(),
> > -        * which allocates swap pages from the highest available priority
> > -        * swap_info_struct.
> > -        */
> > +
> >         plist_add(&si->list, &swap_active_head);
> >
> >         /* Add back to available list */
> > @@ -2692,17 +2680,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >         }
> >         spin_lock(&p->lock);
> >         del_from_avail_list(p, true);
> > -       if (p->prio < 0) {
> > -               struct swap_info_struct *si = p;
> > -               int nid;
> > -
> > -               plist_for_each_entry_continue(si, &swap_active_head, list) {
> > -                       si->prio++;
> > -                       si->list.prio--;
> > -                       si->avail_list.prio--;
> > -               }
> > -               least_priority++;
> > -       }
> >         plist_del(&p->list, &swap_active_head);
> >         atomic_long_sub(p->pages, &nr_swap_pages);
> >         total_swap_pages -= p->pages;
> > @@ -3428,7 +3405,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >         }
> >
> >         mutex_lock(&swapon_mutex);
> > -       prio = -1;
> > +       prio = DEF_SWAP_PRIO;
> >         if (swap_flags & SWAP_FLAG_PREFER)
> >                 prio = swap_flags & SWAP_FLAG_PRIO_MASK;
> >         enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
> > --
> > 2.41.0
> >
> >
> 


