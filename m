Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FD1C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E8B6B0088; Fri,  4 Sep 2026 05:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0676B008A; Fri,  4 Sep 2026 05:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6BF6B008C; Fri,  4 Sep 2026 05:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67F046B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:42:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC76F40142
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:42:29 +0000 (UTC)
X-FDA: 85175589618.09.B6C94D7
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf05.hostedemail.com (Postfix) with ESMTP id 80C6A100005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:42:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndS5Nwkz;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788514948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMHEPjY05VrVAvXYJN5aQJ9iulTQ573kLxiZf3AJdu4=;
	b=DMH+nNDtDxEWey3xNmvduZPigYaz+21iAnq5+UQbuoOfwui0tgCLtQ5YGRFflBjTqczt83
	l7JlUm0IXUCSNdlLh7UdwDsaud53kE4grR9LThUNVfnmcQQ0ffH7fMdQS+wSUgdR2Z/NHa
	yvq4gt51XAL+a7bQs5kWCx5lVryAcno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788514948;
	b=Ezxr9Jg5jSrCsGi2PTSHBuXpMtPZUc1ekhJwahkxDqOtkAFNOjKR/W834yglywF89lRubW
	0Y4mYOA2WizUbpv78IK5SU9L6zp3bEE3GOsx2dhfsMXmVL1qve6YSpDzrX67j1ULfWa9KG
	6AdU61gX6dswNRA6/HocE+9nhe9BIFw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndS5Nwkz;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AEOl6nzdf3KLgAdeyrWM9HJQIsd4abDqxzz7JxSO0f8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788514945; v=1; x=1789119745;
 b=ndS5NwkzYWT3+Ing3GlOaqW5rLELXaiH7MT5vuB5bjLRRI5gaxbOk4m6+JRel3bknHUQzhn2
 AsFAC6onmdX29suSE7rIasU1bDEJbvdbcHieWxMtTatInD1p2lPP/q/016Ar9vVc/XLVsxSnvYz
 4dDTdx1bNX3VmqrnBAIpnZks=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6ce36c104c4d392e;
	Fri, 04 Sep 2026 09:42:25 +0000
X-Mizu-Trace-ID: 6ce36c104c4d392e
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 17:42:20 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, Baoquan He <hebaoquan@kylinos.cn>,
	linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] xswap: extendable swap device backed by zswap
Message-ID: <apqSfFGyJpUMWCY9@fedora>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <apVNB2FRTFMDtvGP@KASONG-MC4>
 <apaw_XmqnEcY8sv7@MiWiFi-R3L-srv>
 <CAKEwX=MU9uXVenEu7he+h-Pq7K3BmCGvvKS-KiPK61Xd0ox_mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MU9uXVenEu7he+h-Pq7K3BmCGvvKS-KiPK61Xd0ox_mQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80C6A100005
X-Stat-Signature: 1wccydach6iupo58cbb9o3x47bq1mqf1
X-HE-Tag: 1788514947-970249
X-HE-Meta: U2FsdGVkX18DUesB9lF3OI5a08ReCiSE2r3jOUMcMdQlokua84miM5yjyW6j6G/WfB/aA0yaMasa3XO8Qj3OIXuYBz8ZYFI0fZLm1DQGG21dpp1ueon3h8JHty2ys6TrdYBGzF4S4V+wFH1PTpfKK5NJtZBBbXOxE8sgKQCBVEXxF5HrFMGztezdJcoGqCOsTZWRC8c8wBASxpcXaWJYGP3YvkDPlgb0QzU9wjyPbLGMMu79cgDHf0dDSIdGGKmV+XyEWqT68kLZjJXMe6J7W8kCBeXdwkk5PIHbXuIdN/6F9EXQfp8KoP1Rg9XWRHhTzKkT1BZmEKLuR0ceXuztgncw08JV6WMaM5z1a+UM+SlCt23TfPgx+Xu23CpoBbqcOhkvxBTGv6wGVZRfO5hADbPGE/IlDe/AQQkuhn/aBdKh2guPAV871UeG6xpZyQ1XrFNNFgheulXelBadnYGm4xxBYnDU3/eEeiw/Uh95Pmq29grdJGQuQgmOlVBBGwIiI6/yvIz04Q9B+UnMSw+jQCvYF13qty051BCQO6E5AFM8ReSZJu8FSRCduH90TojTszXbrk/NOK4FDerVzO+6dPcpADmFOyxA5vGxEiNK/p4g2Eo/ANiNAalMrlpVNY+YYQUij9jMdUrZnVKdgLVfsfcR5cTDkqkce+0v08MKeDFytwq3gGbdq5zGYjgOrr8fJQ921bPDvmpf3Uvy0LBkAHKd/cyfoDnU0eb7EOvdXQGvmFA2u3947Eyr4XskYDPKBXfEyKxmTVYbN+UYcwnSvb5VsnMTTE8M6HYMjM5nvuDaXTIdz81TYkQlKCMDSSWw0SlRYdlklAeeptEe5knP0aMm/Hb7PstKEhehqNRisUgqv9gwwFqAfIvHRrB1Mb2dnolxJEQ4MLmHXEialX5B/NAF67yHGCGHPd0NE34WU6Ut/9UB3IH6SjqFDPPMPaP69VJychuMmMNhWU++gNK
 XYlRAh9u
 hB+dNuB2yo5OwU+G2AFUwNCGc8zdSxe4eAg4Rc2zg8+SVqOnlEYtwZnpIntzgmLzNY9YNEkysBHQsEMNtaGKmv1yoX6zpW5fjo7rgdqPzqlbXerGa34zmrZg+vhUarOWk7s7kvp65xq2AvQMXf4QAJ2rWKUIP2adxqN2ONGAWoRXRlw5OlCvwoO4Lsusr+d/CPUQ+Rv4h8W9gwGMHj58eOs4w0aM+KG0OlFTaGAoDs4w4X/qx/X6eo994ge8Kh0BneTfEOE+2Rfla+zaLXcpbZiAvzTvPvAdqyQ/uQXR5yzmjyIo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 10:10am, Nhat Pham wrote:
> On Tue, Sep 1, 2026 at 7:03 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 09/01/26 at 01:54am, Kairui Song wrote:
> > > On Thu, Aug 27, 2026 at 05:44:50PM +0800, Baoquan He wrote:
> > > > xswap is an extendable swap device with no backing storage. Swapped-out
> > > > pages live only in zswap, so the device wastes no disk space and its
> > > > size is independent of any physical device.
> > > >
> > > > xswap decouples PTE swap entries from physical backing storage. The
> > > > cluster_info array is backed by a sparse vmalloc (VM_SPARSE) area that is
> > > > grown and shrunk on demand:
> > > >
> > > > - Grow: when cluster allocation runs out of free clusters and the device
> > > >   is below its ceiling, more physical pages are mapped into the VM_SPARSE
> > > >   area and their clusters are added to the free list.
> > > >
> > > > - Shrink: when contiguous free clusters accumulate at the tail of the
> > > >   mapped range (tracked in O(1) via nr_free_tail), they are unmapped and
> > > >   the backing pages freed.  Shrink is deferred to a workqueue to avoid
> > > >   lock recursion.
> > > >
> > >
> > > Hi Baoquan,
> > >
> > > I didn't check too many details on how the implementation in previous
> > > RFC until now, After looking at it, using VM_SPARSE to setup the cluster
> > > info area is a really smart idea, really good job!
> > >
> > > I think many info are missing in the cover letter though so I wasn't
> > > sure how this grow and shrink works from the description, after
> > > checking the code, it looks much cleaner to me now, correct me
> > > if I'm wrong:
> > >
> > > Every xswap device will have a huge and fixed "hard limit"
> > > (si->max and si->nr_clusters_max), and practically can be considered
> > > large enough to hold any workload, and won't change once swapon
> > > is done.
> > >
> > > The actually data (si->cluster_info) of xswap device is completely
> > > sparse and dynamic using VM_SPARSE, and so we don't need to change
> > > any existing routine. It grow/alloc and shrink/free automatically by
> > > the kernel, limited or driven by a "soft limit" (si->nr_clusters
> > > and si->pages) which you can modify using the interface below.
> >
> > Thanks a lot for careful checking, and you are quite right about the
> > mechanism and details.
> >
> > >
> > > Once concern is that the "hard limit" is now the total RAM size. Isn't
> > > that actually a bit small? Will be better if that one is tunable too?
> > > With a parameter, and before swap on, as the hard limit is hard to
> > > adjust once swapon is done. Any thing limiting this?
> >
> > Chris and I talked about this, we both think the total RAM size is a
> > good hard limit. Because xswap is similar with zswap/zram in essence by
> > compressing memory content to save memory. So the real limit is the
> > zswap pool, not the slot count. In fact it's never able to utilize the
> > total system RAM, right? Making it larger than system RAM is
> > meaningless.
> 
> No. This is not quite right. The size of this device is the size of
> the "swapped out" data, which is multiple times the post-compression
> size (i.e zswap pool size). The multiple here depends on how well the
> data is compressed.
> 
> This is not to consider the other swap backends:
> 
> 1. zero-filled swap pages have effectively 0 memory footprint.
> 
> 2. disk swap pages (I know this is not currently supported yet, but
> it's a consideration for the overall design).

You are right, system RAM may not be a good hard limit. Then 2x system
RAM? 

> 
> >
> > Memory hotplug is a case in which system RAM can be enlarged during
> > system running, while that can be taken into account later as a enhanced
> > feature if it's really wanted.
> 
> A lot of these problems are self-inflicted. If we design a fully
> dynamic swap device, then it's not in consideration.

As initial version, I'd like to make it not fully dynamic. The current
mechanism can make the change of xswap being full dynamic very easy.
I am glad to see people can post patch to change it later with
justification. I don't think we need to make everything perfect and anyone
satisfied at the beginning.

> 
> >
> > >
> > > And I think these details better be mentioned bit more too.
> >
> > Sure, I can put these thoughts into cover letter or patch log for
> > reference.
> >
> > >
> > > > A per-device ceiling (nr_clusters) bounds growth and is adjustable at
> > > > runtime via debugfs.
> > > >
> > > > Interface:
> > > >
> > > >   /sys/kernel/mm/xswap/create           write "<percent> [<prio>]" to
> > > >                                         create a device; percent is a
> > > >                                         percent of RAM (0 for the default),
> > > >                                         prio is an optional swap priority
> > > >                                         (default DEF_SWAP_PRIO)
> > >
> > > With what I have read so far, the mandatory percent limit here is kind of
> > > strange, even with 0 as default. Why not make both args optional and just
> > > let it grow without any limit by default? It looks more "fully dynamic"
> > > that way.
> >
> > I'd like to clarify why we default to a soft limit rather than "no limit".
> >
> > The soft limit is the administrator's deliberate size choice, similar
> > to how zram requires an explicit size. On a multi-TB system the
> > cluster_info array is not free, so planning how much of it to allow is a
> > real decision. The current behavior is: grow up to the soft limit as usage
> > demands, then stay there. We do not shrink on idle, and shrink only happens
> > when the admin lowers the limit. So there is no grow/shrink oscillation in
> > normal operation.
> >
> > A default of "no limit / fully dynamic" will instead let the device grow
> > without restriction under memory pressure. While allocating cluster_info
> > pages exactly when memory is scarce, relying on shrink to reclaim afterwards,
> > which is the oscillation we want to avoid. So we'll make both create arguments
> > optional, but the default will be a sensible ceiling rather than unbounded.
> >
> > >
> > > >   /sys/kernel/mm/xswap/destroy          write a swap type to tear down
> > > >                                         a device
> > > >   /sys/kernel/debug/xswap/type<N>_cluster_limit
> > > >                                         read/write the per-device
> > > >                                         cluster ceiling
> > >
> 
> What's the point of having multiple xswap devices if it's going to be
> dynamic, cluster-based anyway?

