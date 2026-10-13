Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF7ACC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C696B008A; Tue, 13 Oct 2026 05:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BDBE6B008C; Tue, 13 Oct 2026 05:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC846B0092; Tue, 13 Oct 2026 05:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15D356B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:18:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63246C07BB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:18:26 +0000 (UTC)
X-FDA: 85317052212.21.F2E60F9
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	by imf03.hostedemail.com (Postfix) with ESMTP id 547C820006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:18:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hu2MrlBH;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791883104;
	b=iX7HdeR/O0V13xRLWCjmKXyAM7Pi4w6cw74EN5hmerdj7gilud4WnhakWCYxvWEhtadnis
	LBvJaZgAtqt6BUO5N/D8+N4GGP3w6zYrKfRyalSeXEDJHY/+vmJpdbhyhDeYO6/ig4rbG8
	Zkx9HZVhXD2EPkbCCzO/g6fvYK+mmcs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hu2MrlBH;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791883104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaGHpE8HX1rLOLM4Tb7g7HGjJ+iwOYAOzccR/0qiauU=;
	b=yroZ+cAqzeGx+Rfm2f6NneEUyEqpBT7VaUsBJmSCzzEfe1j/rICCoaRf0tRVFBTiQZPZBg
	kPSZZhbpE8iUJSdLP58MkjTyjQjse0Y+IzHOXkfqjv/OORMhWRLFUpmWEqs5utgC4wGvWB
	OOByAuMoSaelGxKes6yg27QMkuJw/sY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7dij7DFyP1tg1HaqF4OFWcRn8VL75Z8/Hg9V+AE8H5o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791883102; v=1; x=1792487902;
 b=Hu2MrlBHcPA+xV5ig1OcmlSpwI0qgTa72AZsGYMYo2KfmdVTIqlQsnnfr2xc4BJNkEb5ZO9e
 kgAHU7kMpp9huD/sxNeArcz1djZUHyzhOA4V3gMsRQZsfCz3m3m03CfESJzBSWh14De10RxKJL5
 np02sbsDkF2np5dgq3sKOvtU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6e95fa5eb5e92f1b;
	Tue, 13 Oct 2026 09:18:21 +0000
X-Mizu-Trace-ID: 6e95fa5eb5e92f1b
X-Migadu-Flow: FLOW_OUT
Date: Tue, 13 Oct 2026 17:18:12 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Klara Modin <klarasmodin@gmail.com>, Baoquan He <hebaoquan@kylinos.cn>,
	linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com,
	baohua@kernel.org, youngjun.park@lge.com, yosry@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <as33VMjNRIZOG5Ua@MiWiFi-R3L-srv>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <asZt7-8mcxqc1a02@soda.int.kasm.eu>
 <asylV5YyyaHs8rP3@fedora>
 <565e1744-54ff-4daf-ac14-7b6c49fd3fa2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565e1744-54ff-4daf-ac14-7b6c49fd3fa2@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 547C820006
X-Stat-Signature: soj95wdjyzzw1p47bwzizqi7nxxornui
X-HE-Tag: 1791883104-962523
X-HE-Meta: U2FsdGVkX1/TTQyjpmw7HHBbFUofvimfckivoQl2iYDWTF5kpvfJjOb2uZEMAw8FpchjuRoecTa4MAkp5LRLFa9FhyGnFj3/zdeCtuw0jfjmJQDgXrMvPcllV033aIfRws72lOd+aZDh0RM1bblGxTsmD6fQ32SSb4KAkLiioTu+bEDJXnHYia6a+6QBDOzVNccUQaZ3xXSnLYsFNTuNVvFAKdGaJw8Ox3miNzpIDRFvbpXX+rwQQU4wm608zL7diIoYgVvzWRanWn9lyeQ9mNu+/ZqnMDxy67saMHHwZiFkAoHkqqsrdnXxczRmPvGXGTFy7XXvwzM1XejWnx2GPY6gH9+hy4HW6e4acwIkv3J47AVaPzHKJRW9AS1zSr4T3AyFgIvy7QvCmKjAbYOasnXbwDVL8SR+vh7LvCo1D112rrg5wrFPRvseYi1N5q3FICTHYVvoZudPRhufAWMsEKRgEnA8To1WFYk17AgTVj0hhnx8t1I7Lot0JmBEGFOUY12xzH/uQz23j0oyVGcdmGSTSBjDXa4jXHujmgVHXGdL45Y4l5BWE5c0XMMXxT5IBDnPMZIVf7bB4SqjGF69Ar4ncgVQf1uNXdq40PpTKYt8NHjgE3SjTH29lqHTb525IOscu9+TfhiNcTZhGT2X7bcMMXQ3l3mKiNh56SFrME7VXbIZovK2CeilxP6q117X4iRP0EG6Agd1Ybx6AHN8KbWZrks0te2k+YG7SFyxmV8uEd5y9o0esFUcDb4Pl6jOcmFYjDvLPKOI+1aYZLFGEUyZmgp71n9OCyPp18JgZ5HEHZnGMKShuo8paFTtjO9+7MLCyviQLc+pmaZvcJcNGJXYinm6Egpf7R9VIc9SK1uaYOay+im/HcB3RPQF9hM/zXXSF4pptZ2p1EN/N5k2UrFqJ+RhDUK4m5Z2pyLzhXM+Gby0AyaKB8J7DGVCGfviDvWc9W6h6GsHtVOdsKL
 wYVfQSwB
 nO/mnOrNaoMunN6fb/fKLAKqkfM3KK9+XWCL3CU5CBrOPPFOQDKSTR8dwe2W5fPaAXYFSxAD5H773J8q7s5CcAXC8H13WGDo8GChPZ0hzEguA4RZ7tmmXKvVvvv3Q6A+I0mDJZ2mnWFNGJl94cEWNDWQlSl17xtFLTIpw1E/hD8zajgozUGL29TdgVY4DfC4LBykntbMiX5k6Ez5TVdqPP1Z5YzLnsLPoxol/qXhsyYxXbUijwTABqDT8KKWW7+jLP75tMOpkoKQDnOvb6WbGGgrXr/L4AkkLq/3OMi2mDA7GPtpV3d2juWiI4FoY/3CBcMdD+Uw2Dtc6kzdtfUVgX990oPi111lHx4ApYbaWC50IfV+BuqUmakW30MGZcHK9Jwxk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 at 03:44pm, David Hildenbrand (Arm) wrote:
> On 10/12/26 11:16, Baoquan He wrote:
> > Hi Klara,
> > 
> > On 10/07/26 at 06:28pm, Klara Modin wrote:
> >> On 2026-10-03 08:31:22 +0800, Baoquan He wrote:
> > ...snip...
> >>> The only argument create takes is a priority. The size comes from
> >>> xswap.max= at boot, so there is one place to ask for a size and one to
> >>> ask for a priority, and a priority can be given per device while a size
> >>> cannot:
> >>>
> >>>   # echo > /sys/kernel/mm/xswap/create          default priority
> >>>   # echo 100 > /sys/kernel/mm/xswap/create      priority 100
> >>>
> >>
> >>> The default is the highest priority, SWAP_FLAG_PRIO_MASK. An xswap
> >>> device is then the first one tried, ahead of any ordinary swap device.
> >>> Setting a lower priority is allowed.
> >>
> >> Nice, this is now a good default which the user should not have to
> >> change.
> > 
> > Thanks a lot for careful reviewing, and sorry for late reply.
> > 
> >>
> >>>
> >>> The device does not move once it exists, so the address space cannot be
> >>> changed from this interface either. xswap.max= at boot and this together
> >>> are the whole configuration.
> > ...snip...
> >>> Open items
> >>> ----------
> >>>
> >>> - xswap_create() sets si->pages to the whole address space (twice RAM by
> >>>   default) and _enable_swap_info() adds it to nr_swap_pages and
> >>>   total_swap_pages, which is what __vm_enough_memory() uses for
> >>>   overcommit. That raises the commit limit by 2xRAM for a device whose
> >>>   real capacity is bounded by the zswap pool and by how well the workload
> >>>   compresses. The question is which semantics overcommit should follow:
> >>>   worst-case backing, or the address space.
> >>>
> >>> - destroy takes a bare swap type. The type is an internal index that
> >>>   alloc_swap_info() recycles as soon as SWP_USED clears, so a value read
> >>>   earlier can name a different device by the time it is written. The
> >>>   swapoff ABI uses a path for this reason. It wants a generation or
> >>>   another stable handle.
> >>>
> >>> - The new interfaces (/sys/kernel/mm/xswap/create and destroy, xswap.max=,
> >>>   the new type string in /proc/swaps) are not documented yet.
> >>
> >> To me it feels a bit weird to have the interface split between a kernel
> >> parameter and sysfs, meaning I have to configure this in two places now.
> >> As far as I gather, there's also nothing that needs the limit to be
> >> fixed at boot since it is applied at creation. If we want to expose this
> >> limit to users (as xswap does) it would be nice to have a 'max'
> >> shorthand for tha largest possible value, i.e. SWAPFILE_CLUSTER *
> >> UNIT_MAX (or whatever it might be in the future). That would I guess in
> >> practice give the same behaviour as vm.overcommit_memory=1 which might
> >> or might not be desirable.
> > 
> > Thanks for the comment.
> > 
> > Here xswap.max= is a global boot parameter, while not a per-device or
> > runtie knob. It sets the space space (si->max) of the xswap device
> > at boot and can't change at runtime. So on the two places: the size is
> > a global setting, fixed at boot; the priority is per device, it is in
> > the create interface. They are different things.
> > 
> > The default is 2xRAM. From our earlier discussion, this is the largest
> > size we think is sensible, and in practice I don't think it is not
> > reachable in reality. If a system has swapped out 70% of its memory, and
> > even more at 100%, it is already doubtful that it can still function
> > normally. So 2xRAM is an upper bound, not a target.
> 
> I remember some overcommitted hypervisor setups where people swapped out
> significantly more -- without any issues.
> 
> For example, Windows VMs initialize all VM memory when booting up. Afterwards,
> you might just have plenty of memory that was touched once but will not really
> be used in any near future.
> 
> So I would consider some crazy hypervisor scenarios as well where people
> commonly have significant cold memory that is currently not hot (not in the
> working set) but might possibly used in some distant future.

Hi David,

Thanks a lot for the valuable input. This is probably the first first-hand
information I have heard about a production environment. And Klara
measured about 160% of RAM in zswap on her RISC-V box, so the 2xRAM default
is reachable in practice, not just in theory.

So I see 2xRAM as a default, not as a cap. xswap.max= already overrides it.
After your comment and Klara's numbers, I am open to a larger default, or to
a "max" value for the address space. The real limit is still the backing:
the zswap pool plus the block devices. The address space should no longer
be the limiting factor.

By the way, in Windows-VM case you mentioned, is there a block swap backend,
or is it zswap alone? If it is zswap alone, the knob that matters is
zswap.max_pool_percent, because it sets how much cold memory the pool can
hold.

Thanks
Baoquan

