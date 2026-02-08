Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A1DEF06E1
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 19:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C626B0089; Sun,  8 Feb 2026 14:39:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC396B0092; Sun,  8 Feb 2026 14:39:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08816B0093; Sun,  8 Feb 2026 14:39:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD7806B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 14:39:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3205C1A05E5
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 19:39:41 +0000 (UTC)
X-FDA: 84422304162.25.F978105
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B120D14000A
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 19:39:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IjFfFqKg;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770579579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNMswds5UY7Es5wyLEEcARgDtpyQ7vZBxnMXpBy1eWA=;
	b=1XjWFxQSUHbBkXDoq2XojYLxSU9dmGuqUQm1Dpj1y2YeORAJ3xImQZiTLmBDfwpa9IVse/
	HIyXh1JdBNxgl5R/j0xtejQgTXdDPGlnaqeVKQKXA/Ep6fw2c/2z0EYKXAq7o65jtfrq10
	Ci7WDvqpoJ8hK9RJoHF2ypFSbyZ0FAA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IjFfFqKg;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770579579; a=rsa-sha256;
	cv=none;
	b=VvJ5lOIIvK8VE3IXNJ2s7CqyL6dc2H4J5CI7ak2JbEtiZjzQIo3bAsB7wMeLUY5KBIWIvd
	kRWAMaqN0bicxgMRwdvHoXw118sLhM613XLsCtpVeg4++LiJ7DtAX28tBGjSrlKwMZtUUY
	PVEVJ08o9syoeUUXTMVkp09Co7gBOM0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1F44600BB;
	Sun,  8 Feb 2026 19:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1D8C4CEF7;
	Sun,  8 Feb 2026 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770579578;
	bh=T/n0ApvGKZGfaAOosSp8S0hLFKa3Q4lE8rE0sekUo+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IjFfFqKgw76ipqZJGiLalQ31cZy/oQRfWj6sf74zDfF1/x6X6koRoPvmz05lTQj+i
	 Q/3NZk6m5k+enu2c2FdlcqUvG0Ew1ZRQXKEYMPpVtz9ZQxXS/yA8/2lDUDY3tprRyZ
	 VLvE+T7/APbSy6w4/0SroXGr2ObuRJXBl3DgG+LqWxm7cjFFDyMc9KBbdBH0h6qHW8
	 VmL+LZtJ3LQpvijaPT438hzLWD8vG0kG45KPEIeKL5yVSIl/Whn1SGLzY3bwDStJdj
	 S3zIgCONtTkKgShk2Ve0wBnQ147WcrJESwrgoz/n3IStt/rwokWk4RTxBd+pvSWQJ3
	 0fYqzdQSy8rTw==
Date: Sun, 8 Feb 2026 21:39:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
Message-ID: <aYjmcZ4hg9bNbmiY@kernel.org>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B120D14000A
X-Stat-Signature: z1wk1b7g4zui1ycne96hrc8ip9bk98ud
X-Rspam-User: 
X-HE-Tag: 1770579579-647405
X-HE-Meta: U2FsdGVkX19yCyi0qpD3oT3RSRYoiLkgvGGAj18sSeTH20gutGK+1MmhE7KwZrt1O1TCpGuTsxJ378F+SHIQPsU97tAzPr+IFTTuLWZvKGemUhz5xf7gQ/rJqUL4KeunrYYpHTrHWg9djh2s8F39DgudKmiQwJfiSR/sXwmf8NBQWkJp21EWH1Riglb4AWlyafptmhZDRSokkMBhR8DBDxZrdmGPzUQTyuV9yqPWVCEZ8DrF6WvxaOMw9D7NLNsg6vU2be9Q2Ij7e48qgVcCeF8MlvIZwD3GaNK7pE/eQbQX6dtLnGzvi1nxXnVIPg3vpTHBRANNPC/wbWOtcgDZVrCARKuahZ66LSzXUIADsHkCuyKQNeF4LrNmqF3GasVNggEw39YyKCZv8cwHpOoN6XeOmfR1We0Fed3MrZbvCeA0S2ou848GGMF3hCW5XTTDgZ9jfa+dZe+vz35iPq2xFAh6S8lvTqNOm5aa3yDS1DTGiZuSuTAWKX16qw02YuDiqtDqPBDT4IsRb9UbqpXPVwX6t4hG7gcwfO3lFk4fg1+IGCD1JNh1xHss4xRpDHDAQQfl8IVMIjbCp//9Nw872u7y7ArvBNKsbD0h8BUSS3vFntXeYs8h3vdJf5JeOERL3e0n1rIGGV9CdA3TESB0C7TmL+kyu/CR4VZ8gSa9f3j7eEfIzXnttF4SwJbbtqA4JYzw8nczRa7oac5Bk1AyvjvPi1HTrUPZVXWtozr7yjArzp03pJQn4QnYVSUPiDU6i6m3SddFbuPDQshbKjDLzxNHIy0Qq0N6delGqI9qC4OWAypn5xNSQzRWuJQzhNXuBIkKZDMrEFK53C5QbIjZYhrxcQ4LIU7sBPkDMFKOGtV7lYdsmw0RilK87Hbk0LZGoqNB11blOUd4e6FFfFtVon9MwgbR2fbfdhiThRJAJXGmP1uRdbmtUi2AWV1La30ziE5KrJn8sqR4p3P4Y1g
 G3pwIG++
 kiYyxNRaCc2MgWGo5MJfvqG/Ta0RVXXjqQDdK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 07, 2026 at 12:00:09PM +0100, David Hildenbrand (Arm) wrote:
> On 1/30/26 17:37, Tianyou Li wrote:
> > When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> > update the zone->contiguous by checking the new zone's pfn range from the
> > beginning to the end, regardless the previous state of the old zone. When
> > the zone's pfn range is large, the cost of traversing the pfn range to
> > update the zone->contiguous could be significant.
> > 
> > Add fast paths to quickly detect cases where zone is definitely not
> > contiguous without scanning the new zone. The cases are: when the new range
> > did not overlap with previous range, the contiguous should be false; if the
> > new range adjacent with the previous range, just need to check the new
> > range; if the new added pages could not fill the hole of previous zone, the
> > contiguous should be false.
> > 
> > The following test cases of memory hotplug for a VM [1], tested in the
> > environment [2], show that this optimization can significantly reduce the
> > memory hotplug time [3].
> > 
> > +----------------+------+---------------+--------------+----------------+
> > |                | Size | Time (before) | Time (after) | Time Reduction |
> > |                +------+---------------+--------------+----------------+
> > | Plug Memory    | 256G |      10s      |      2s      |       80%      |
> > |                +------+---------------+--------------+----------------+
> > |                | 512G |      33s      |      6s      |       81%      |
> > +----------------+------+---------------+--------------+----------------+
> > 
> > +----------------+------+---------------+--------------+----------------+
> > |                | Size | Time (before) | Time (after) | Time Reduction |
> > |                +------+---------------+--------------+----------------+
> > | Unplug Memory  | 256G |      10s      |      2s      |       80%      |
> > |                +------+---------------+--------------+----------------+
> > |                | 512G |      34s      |      6s      |       82%      |
> > +----------------+------+---------------+--------------+----------------+
> > 
> > [1] Qemu commands to hotplug 256G/512G memory for a VM:
> >      object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
> >      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
> >      qom-set vmem1 requested-size 256G/512G (Plug Memory)
> >      qom-set vmem1 requested-size 0G (Unplug Memory)
> > 
> > [2] Hardware     : Intel Icelake server
> >      Guest Kernel : v6.18-rc2
> >      Qemu         : v9.0.0
> > 
> >      Launch VM    :
> >      qemu-system-x86_64 -accel kvm -cpu host \
> >      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
> >      -drive file=./seed.img,format=raw,if=virtio \
> >      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
> >      -m 2G,slots=10,maxmem=2052472M \
> >      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
> >      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
> >      -nographic -machine q35 \
> >      -nic user,hostfwd=tcp::3000-:22
> > 
> >      Guest kernel auto-onlines newly added memory blocks:
> >      echo online > /sys/devices/system/memory/auto_online_blocks
> > 
> > [3] The time from typing the QEMU commands in [1] to when the output of
> >      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
> >      memory is recognized.
> > 
> > Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> > Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> > Tested-by: Yuan Liu <yuan1.liu@intel.com>
> > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> > Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> > Reviewed-by: Pan Deng <pan.deng@intel.com>
> > Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> > Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
> > Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> > ---
> 
> Thanks for all your work on this and sorry for being slower with
> review the last month.
> 
> While I was in the shower I was thinking about how much I hate
> zone->contiguous + the pageblock walking, and how we could just get
> rid of it.
> 
> You know, just what you do while having a relaxing shower.
> 
> 
> And I was wondering:
> 
> (a) in which case would we have zone_spanned_pages == zone_present_pages
> and the zone *not* being contiguous? I assume this just cannot happen,
> otherwise BUG.
> 
> (b) in which case would we have zone_spanned_pages != zone_present_pages
> and the zone *being* contiguous? I assume in some cases where we have small
> holes within a pageblock?
>
> Reading the doc of __pageblock_pfn_to_page(), there are some weird
> scenarios with holes in pageblocks.
 
It seems that "zone->contigous" is really bad name for what this thing
represents.

tl;dr I don't think zone_spanned_pages == zone_present_pages is related to
zone->contigous at all :)

If you look at pageblock_pfn_to_page() and __pageblock_pfn_to_page(), the
check for zone->contigous should guarantee that the entire pageblock has a
valid memory map and that the entire pageblock fits a zone and does not
cross zone/node boundaries.

For coldplug memory the memory map is valid for every section that has
present memory, i.e. even it there is a hole in a section, it's memory map
will be populated and will have struct pages.

When zone->contigous is false, the slow path in __pageblock_pfn_to_page()
essentially checks if the first page in a pageblock is online and if first
and last pages are in the zone being compacted. 
 
AFAIU, in the hotplug case an entire pageblock is always onlined to the
same zone, so zone->contigous won't change after the hotplug is complete.

We might set it to false in the beginning of the hotplug to avoid scanning
offline pages, although I'm not sure if it's possible.

But in the end of hotplug we can simply restore the old value and move on.

For the coldplug case I'm also not sure it's worth the hassle, we could
just let compaction scan a few more pfns for those rare weird pageblocks
and bail out on wrong page conditions.

> I.e., on my notebook I have
> 
> $ cat /proc/zoneinfo  | grep -E "Node|spanned|present"
> Node 0, zone      DMA
>         spanned  4095
>         present  3999
> Node 0, zone    DMA32
>         spanned  1044480
>         present  439600

I suspect this one is contigous ;-)

> Node 0, zone   Normal
>         spanned  7798784
>         present  7798784
> Node 0, zone  Movable
>         spanned  0
>         present  0
> Node 0, zone   Device
>         spanned  0
>         present  0
> 
> 
> For the most important zone regarding compaction, ZONE_NORMAL, it would be good enough.
> 
> We certainly don't care about detecting contigous for the DMA zone. For DMA32, I would suspect
> that it is not detected as contigous either way, because the holes are just way too large?
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

