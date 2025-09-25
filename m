Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E662CCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 01:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EBEF8E000F; Wed, 24 Sep 2025 21:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3688E0001; Wed, 24 Sep 2025 21:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8E88E000F; Wed, 24 Sep 2025 21:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0512C8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:55:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A133B7C09
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:55:57 +0000 (UTC)
X-FDA: 83926106754.17.DB28B61
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E9E8140004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:55:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e10MBZbU;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758765355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNNnQKmMoVxymRmdhgbGlizpGIlyds4DvgnWiKKICtQ=;
	b=umKtY7X2T/k0GhQVGW80P0bFECTHTSdypMlYT8jDKakif5ChX41JvQvVw2x/2w1CCGcKBZ
	MSIDGqlqo3a5Nt7e6zLinzANEw+7k7K7jyRdR4jONajC7r3l8RVDDD9rmuMA11xAUD0W7k
	z6m2GyCTH/NFz5lKqqSJGvUV9lrSkig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758765355; a=rsa-sha256;
	cv=none;
	b=esrKARoXMOfy1AGx0KVdYyf+KS3TaR3XxLQSv8Y2Ef06MY0L7Dc5wBs2VM4fs5D2YBoDIc
	yAMwfLPZojYoSM8AgJ6P7qixO8vGydo8GkjCKdonhyBZNIRceeP39qCMfCV/WXj2Mf6q8G
	d6i2o9gTNOm5jl+cV81cfQTrtLGzsII=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e10MBZbU;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758765355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UNNnQKmMoVxymRmdhgbGlizpGIlyds4DvgnWiKKICtQ=;
	b=e10MBZbUc9zX26GkCYaYGuyilHtbDND+P94qrbKNO3RZZRk8dwU6vDF+Yl5pYqXTBYLI1/
	NfKG2PElEvuNMTQBtzEcDNubLVmM9LHk3C1DLWmIbrQWC+0yR6DvF201PWYO111teH0Rwm
	70VS5U0K3mucWVGLGFU0VHXrE70SZNg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-235-0hlPajSxO_-jLT618MlLiA-1; Wed,
 24 Sep 2025 21:55:51 -0400
X-MC-Unique: 0hlPajSxO_-jLT618MlLiA-1
X-Mimecast-MFC-AGG-ID: 0hlPajSxO_-jLT618MlLiA_1758765350
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FCB219560B2;
	Thu, 25 Sep 2025 01:55:49 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96A7319560B1;
	Thu, 25 Sep 2025 01:55:47 +0000 (UTC)
Date: Thu, 25 Sep 2025 09:55:43 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	YoungJun Park <youngjun.park@lge.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNShH7WWxuBEvIuh@MiWiFi-R3L-srv>
References: <20250924091746.146461-1-bhe@redhat.com>
 <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GZCvZlxBUH4gSaRHk-HSSzafoOZS_TXrcvOQCiz1dQ0_1758765350
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7qsbj96ps6pr7y5cjd7b3aym9fgfmt96
X-Rspamd-Queue-Id: 8E9E8140004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758765355-470547
X-HE-Meta: U2FsdGVkX19aapepDbk8f16j4popFjTsdBEBFtj2Xrh6R3fvMmqlTsB4SI9txIyn5tFZXQjXCZJbBN91MhL3i/AFHVUyZ3VQHVLBLfx/xVD298ST5pGCjcbmA2ynsfeS1MPi8el8Qh/3nAK2bQPRzLAVagit4r0orfxgYCtPczumYaWLwjWEOIOjfmJ6GWB5eGaYF9w2fNXCP0k0P3Dv33+cgpBS+R5BtYG7fnjtuEq3keMz+NV6MbuLvHo4Vd3LXU8gUQamRk+2Rt8JFGVOrSiExaRyFm0mThwuuSnxsc/GbjB3d72YnYmFIwzuJEas7iXjjPkoWMnc8Cs9DEnzchZ5RXsddzON72Xj7mIE8U+jilY80RfutRMDh51IG6pLxB+kGN+0CNa6UXY5bSJEWB5RT4hwG6HvUALlGdILMDrJwAQNYfY6DtpFp1NxaNuLP/kSHgkAwAQ2Cr64YA04vdUZns2sROk7zPeH91QJVUesMpeI193RvBhdEPjktXbPnyLz6qIRBM35+uGAGX6RcDD2EW2UFCQK3NTPS5vfhLVSeZuboCo/SfJHwjxXHuk2cPUXnbbK4UViXyH1oZZRKooljcsotsWxh17aEmG0W85VTpDR04b3t5PDWuEwz1jofor//q0xyb665ozKrxzlA9/y8dA9KiwB172FzkjPCT45wMkB01u+IC41fD/+7OOuos9NevqQpHnFsW2aQwYsgOb1+aGOQjYypo7Hy7mbmPIF+nLOG9DrXbGZj7bcanlDlbn2TZHgKAoCbZxpAeCT7Z3sLq06jCkUXqUv6SqZY13aivFAjInQJfkZuPjuCTFaDJI2Sm38APpX+/qPga1eq/1zKiwZI0FsRMdb0j3n6eQAhtnTCYjCGXGURYX3GnceUNeOOEMRs21eTAyq9YQK0TPE97tlfbIhhj5Ys7k9e4Btr2btlAeT41z6MMaRxrkUnmrCNXtgBXSrTv8ri9r
 jdjUC26Z
 H4aHLfpo99GE6DwOlRJgJ4XbcgUe6+TAMc3dSRtI2BbpPUqLy4fWX8eQfF6iSs8kEv/aixqFy06VoJuMfCsk5NtwrwlzGSpVu/uKqRbChTLjuP4h8AeHtkC9IAcLd2rbNuq0ceu0ojnOUo6rT3K1V1HSm7YD/JI/gx7tt1udQy88l7carOXHDgCn13jRHCU6kpsc/eu0cW5gWRJ0B6SKgJHqqJSttLWqULmKtCui4M3e5zrLvbVzpWm9EdBIhTRkX5OKt7wmXs7VhVPLmXrLjVsFa/a3o8E/4Nyp69CWQaKb0nPXJe2ZcWRiYXnWs32dol+AUG6OCbqV8txKw4M7fCwautL3n07tVpqX865WZl6tQa28GiVivu3AyeZz5Ks8vsT1ZYIblEu/f3Ohuj7fkz4bQaeBhVgckb8DTnR+DAC94Ifr+Jhkku9R0VP9zwdyub2KiCgeDHFUfCxbeMbiyS/qDUt77wR6GslCrwMPC6bkxt8ci9RoteQ7i8Y2K6q6zVHwTqgBAwS7Ekec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/24/25 at 08:54am, Chris Li wrote:
> Hi Baoquan,
> 
> Very exciting numbers. I have always suspected the per node priority
> is not doing much contribution in the new swap allocator world. I did
> not expect it to have negative contributions.

Yes.

While compared with the very beginning, there has been some progress.
At the very beginning, there was one plist and swap device will get
priority from -1 then downwards by default, then all cpus will exhaust
the swap device of pirority '-1', then select swap device of priority
'-2' to exhaust, then -3, .... I think node-based adjustment distribute
the pressure of contending lock on one swap device a little bit.
However, in node they still try to exhaust one swap device by node's
CPUs; and nodes w/o swap device attached still try to exhaust swap
device one by one in the order of priority.

> 
> On Wed, Sep 24, 2025 at 2:18 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > Currently, on system with multiple swap devices, swap allocation will
> > select one swap device according to priority. The swap device with the
> > highest priority will be chosen to allocate firstly.
> >
> > People can specify a priority from 0 to 32767 when swapon a swap device,
> > or the system will set it from -2 then downwards by default. Meanwhile,
> > on NUMA system, the swap device with node_id will be considered first
> > on that NUMA node of the node_id.
> 
> That behavior was introduced by: a2468cc9bfdf ("swap: choose swap
> device according to numa node")
> You are effectively reverting that patch and the following fix up
> patches on top of that.
> The commit message or maybe the title should reflect the reversion nature.
> 
> If you did more than the simple revert plus fix up, please document
> what additional change you make in this patch.

Sure, I will mention commit a2468cc9bfdf and my patch reverts it, on top
of that default priority of swap device will be set to '-1' so that all
swap devices with default priority will be chosen round robin. Like
this, the si->lock contention can be greatly reduced.

> 
> >
> > In the current code, an array of plist, swap_avail_heads[nid], is used
> > to organize swap devices on each NUMA node. For each NUMA node, there
> > is a plist organizing all swap devices. The 'prio' value in the plist
> > is the negated value of the device's priority due to plist being sorted
> > from low to high. The swap device owning one node_id will be promoted to
> > the front position on that NUMA node, then other swap devices are put in
> > order of their default priority.
> >
> 
> The original patch that introduced it is using SSD as a benchmark.
> Here you are using patched zram as a benchmark. You want to explain in
> a little bit detail why you choose a different test method. e.g. You
> don't have a machine with an SSD device as a raw partition to do the
> original test. Compression ram based swap device, zswap or zram is
> used a lot more in the data center server and android workload
> environment, maybe even in some Linux workstation distro as well.

Yeah, just as you said. I haven't got a machine to create several SSD
partitions as swap device to test this. So hacked the zram kernel code
to assign device id to zram devices's node_id. I also tried to use
several swap files on one SSD disk, the speed is too slow, the
comparison results are not very obvious, there's only about 1%
promotion. And as you said, in reality, currently zram or swap is being
taken more and more and become the default setup on systems. So I think
it makes sense to use zram devices to test this patch.

> 
> You can also invite others who do have the spare SSD driver to test
> the SSD as a swap device. Maybe with some setup instructions how to
> set up and repeat your test on their machine with multiple SSD drives.
> How to compare the result with or without your reversion patch.

Sure, I will write these detailed steps in v2 cover letter, and attach
my two draft scripts for easing doing statistics and output the final
result.

> 
> > E.g I got a system with 8 NUMA nodes, and I setup 4 zram partition as
> > swap devices.
> 
> You want to make it clear up front that you are using a patched zram
> to simulate the per node swap device behavior. Native zram does not
> have that.

Sure, will add it in v2 cover letter.

> 
> >
> > Current behaviour:
> > their priorities will be(note that -1 is skipped):
> > NAME       TYPE      SIZE USED PRIO
> > /dev/zram0 partition  16G   0B   -2
> > /dev/zram1 partition  16G   0B   -3
> > /dev/zram2 partition  16G   0B   -4
> > /dev/zram3 partition  16G   0B   -5
> >
> > And their positions in the 8 swap_avail_lists[nid] will be:
> > swap_avail_lists[0]: /* node 0's available swap device list */
> > zram0   -> zram1   -> zram2   -> zram3
> > prio:1     prio:3     prio:4     prio:5
> > swap_avali_lists[1]: /* node 1's available swap device list */
> > zram1   -> zram0   -> zram2   -> zram3
> > prio:1     prio:2     prio:4     prio:5
> > swap_avail_lists[2]: /* node 2's available swap device list */
> > zram2   -> zram0   -> zram1   -> zram3
> > prio:1     prio:2     prio:3     prio:5
> > swap_avail_lists[3]: /* node 3's available swap device list */
> > zram3   -> zram0   -> zram1   -> zram2
> > prio:1     prio:2     prio:3     prio:4
> > swap_avail_lists[4-7]: /* node 4,5,6,7's available swap device list */
> > zram0   -> zram1   -> zram2   -> zram3
> > prio:2     prio:3     prio:4     prio:5
> >
> > The adjustment for swap device with node_id intended to decrease the
> > pressure of lock contention for one swap device by taking different
> > swap device on different node. However, the adjustment is very
> > coarse-grained. On the node, the swap device sharing the node's id will
> > always be selected firstly by node's CPUs until exhausted, then next one.
> > And on other nodes where no swap device shares its node id, swap device
> > with priority '-2' will be selected firstly until exhausted, then next
> > with priority '-3'.
> >
> > This is the swapon output during the process high pressure vm-scability
> > test is being taken. It's clearly shown zram0 is heavily exploited until
> > exhausted.
> 
> Any tips how others repeat your high pressure vm-scability test,
> especially for someone who has multiple SSD drives as a test swap
> device. Some test script setup would be nice. You can post the
> instruction in the same email thread as separate email, it does not
> have to be in the commit message.

Sure, will do.

> 
> > ===================================
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE  USED PRIO
> > /dev/zram0 partition  16G 15.7G   -2
> > /dev/zram1 partition  16G  3.4G   -3
> > /dev/zram2 partition  16G  3.4G   -4
> > /dev/zram3 partition  16G  2.6G   -5
> >
> > This is unreasonable because swap devices are assumed to have similar
> > accessing speed if no priority is specified when swapon. It's unfair and
> > doesn't make sense just because one swap device is swapped on firstly,
> > its priority will be higher than the one swapped on later.
> >
> > So here change is made to select the swap device round robin if default
> > priority. In code, the plist array swap_avail_heads[nid] is replaced
> > with a plist swap_avail_head. Any device w/o specified priority will get
> > the same default priority '-1'. Surely, swap device with specified priority
> > are always put foremost, this is not impacted. If you care about their
> > different accessing speed, then use 'swapon -p xx' to deploy priority for
> > your swap devices.
> >
> > New behaviour:
> >
> > swap_avail_list: /* one global available swap device list */
> > zram0   -> zram1   -> zram2   -> zram3
> > prio:1     prio:1     prio:1     prio:1
> >
> > This is the swapon output during the process high pressure vm-scability
> > being taken, all is selected round robin:
> > =======================================
> > [root@hp-dl385g10-03 linux]# swapon
> > NAME       TYPE      SIZE  USED PRIO
> > /dev/zram0 partition  16G 12.6G   -1
> > /dev/zram1 partition  16G 12.6G   -1
> > /dev/zram2 partition  16G 12.6G   -1
> > /dev/zram3 partition  16G 12.6G   -1
> >
> > With the change, we can see about 18% efficiency promotion as below:
> >
> > vm-scability test:
> > ==================
> > Test with:
> > usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
> >                            Before:          After:
> > System time:               637.92 s         526.74 s
> You can clarify here lower is better.
> > Sum Throughput:            3546.56 MB/s     4207.56 MB/s
> 
> Higher is better. Also a percentage number can be useful here. e.g.
> that is +18.6% percent improvement since reverting to round robin. A
> huge difference!
> 
> > Single process Throughput: 114.40 MB/s      135.72 MB/s
> Higher is better.
> > free latency:              10138455.99 us   6810119.01 us

OK, will improve this.

> >
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/swap.h | 11 +-----
> >  mm/swapfile.c        | 94 +++++++-------------------------------------
> 
> Very nice patch stats! Fewer code and runs faster. What more can we ask for?
> 
> 
> >  2 files changed, 16 insertions(+), 89 deletions(-)
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
> That seems like some debug stuff left over. If you need to remove it, remove it.

I ever tried to adjust the lock usage, later I found I need keep it as
is, but forgot to change this line back. Will change it in v2.

> 
> The rest of the patch looks fine to me. Thanks for working on it. That
> is a very nice cleanup.
> 
> Agree with YoungJun Park on removing the numa swap document as well.

Exactly, will do.

> 
> Looking forward to your refresh version. I should be able to Ack-by on
> your next version.

Thank you very much for your great suggestion from a big picture view,
and help during the process. Really appreciate it.

Thanks
Baoquan


