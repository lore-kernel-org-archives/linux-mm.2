Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A5DC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 07:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836826B007B; Mon, 10 Aug 2026 03:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E79D6B008A; Mon, 10 Aug 2026 03:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D61C6B008C; Mon, 10 Aug 2026 03:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 317266B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:25:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C84680603
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:25:28 +0000 (UTC)
X-FDA: 85084524336.27.0E0EF89
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC0D320007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:25:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CUjwXl6y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786346726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4ew6lRFtkLA6JTCFVYpe5QpkYXzgq7mhDYzpmtX1sw=;
	b=yzwu26GUyu8dgYR09wmdFxXbx8xUMyHRw5l03XQb56/fL1kgMjpn6cwJwhGhjdcVkPmR7Y
	6ybDFh0l3XcyEYYf1iYdYUfYmM4lzjEAc7PpZUSZbjApfI0+C6NVmMMbcb+vu80cbuPXRs
	SEgqaoekMrkXW9Q1NiA+c+ty1vl+k0Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CUjwXl6y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786346726;
	b=dIMcEsMbOipezDJZPEvVfXpePXYBKPfZmqRWELVWGmiB21s7r57jHh/YfpHiOB09D3uwWo
	//f/aL7ET27s3JcJAvUw4tIiv4KeKdeovmaRfhDjivdS9zi3M5iH3QxK7M7owv50eoclLl
	zI2Tc2Hx/hNRWGeGiFEGv+ecK06HwAg=
Date: Mon, 10 Aug 2026 15:25:07 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786346722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W4ew6lRFtkLA6JTCFVYpe5QpkYXzgq7mhDYzpmtX1sw=;
	b=CUjwXl6yS8F+/qptE3/yP4p6HUJ/aD2fbpPZKn/k+EvMtr3o7fbrnEhPKipwpnkVFhg5Z1
	b9lZ36a5UFpAgGb3xwhKkNypRzHb5VVO8jJ+VXdkDhKZqNL6p19viwA1dzH0H+s34n/amu
	IXx4mexVtBlx/B3hCdfo92V0R11LOrQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	chrisl@kernel.org, nphamcs@gmail.com, kasong@tencent.com,
	baohua@kernel.org, yosry@kernel.org, david@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] mm: xswap support for zswap
Message-ID: <anl80zDN2t4Yex8K@MiWiFi-R3L-srv>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
 <20260805075336.3579395-2-baoquan.he@linux.dev>
 <anNGE_FOoupPtOhj@cmpxchg.org>
 <anWhKU8NPzosQR8d@MiWiFi-R3L-srv>
 <ankuMRz8BjHomhY9@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ankuMRz8BjHomhY9@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC0D320007
X-Stat-Signature: x6xd1h5rz56hbf7jjm3zmyitf6iynjg3
X-Rspam-User: 
X-HE-Tag: 1786346725-419910
X-HE-Meta: U2FsdGVkX1/mQnojo7vhQ30vOHxBLZXnKH+4SJ7K2FxTR3uYtzzMADiHDELgYLDmwf+uBwijdC0WrgX6THgLI/mayOZ8GzjPqHU4JkaRlYM+Q0364eIX7Jc9c/1a6T7oCVfS59vWuEhwKDMYSzoyyKirOjj/oy2r4ViCX9a9fUwGCdFgpsrp3TVlWTdmwveO8rASdYanWRL4wk02D2BGsTKs6YFQ2+rUD8wukvIpB9WcBR8rEz6MA3N+Ou9QyRpf9fxwHz5kne/ekyj5BNELQNWe+brn0tSyvM8arAT6nrvJyHYXMiSb/KAjmaPCXuDj/ZIapg/nODUYgOkizYISN5j+pCGcmPUnNzKdqs6bmeiMJMTfcqYhmhdxhk+Yv5p3joxZKBnbZ5V+1e+BCV9S7847uzWc1YF6qkShfCWWZl7yxayuyr5oCXnjzDXtwjXVUPSlZo84H30fhIrkKZNvUXI6UxwqF58p8zhPjaUZZ27R1fJDsYcLS7udYBQU1CN90ctRaN2Gh+pTktdnuStD8O39ixR9r45JxWhHM1T5m70kGEdbotl31fVf1aIvSoa4A4MRrP3jgg+mVzTzLB2NgZie6hcIqq4BdbMWCoQ4UmwdxQEb1ciKvT/Rt0qxh9LX8F96EI2UV26bWSEGeSyId05mSCZ8JpxgBUsXRFx6j7vtmJJ8uIc1ZwXhtuxCvBX8CoO0EbJq5TXqyx30cUI3I9MxZp9voQViQYKyL1PTL/aR+iCP8z/5pA5ve2TJAxSaR+WG2Hv6sPY3uiR5lF3ZHiL8FhbbXx88hLQSV/T2WxRzzxp+tES9BSD//4TiGvK0M8LRpgjmvGjKWPftvxq7hOi/eY1NJ+i4YzYxBOksea2YDlY9uiJNe8axs1ERetbX22C5pLKFiqPXANFOuThlHVvR4AeLQ3WZ0il0lRqEl763c78ceS/gT2Esq+jUYKR7X2SuU2v8XZjifJwywYr
 eswztEO1
 gacMlHF7VYk0mfobT8lAZNbRnNwCaRZOlj0H+n+KzrnWLmOWywSjfyQBWYYTVJb24H0Ok1Y8R2nKOZs85FW8XDSjfwLjVFznSidSceItF/iPYyAa+3C7UC7V9tC60ObRj8haQuIshfVfGM5JG54rY5XiAuk3SG0YMLjQ2jADRBVIO6A0LEqmvlm75yGiax3PagvHZl6Z8xGY6GJWzhAaY9lPuBeK81Zr6T/ZruSQ2v53tENNXveTg3nX4NmTe8fmkVhXpMaehGyzmwMBz1bBkMMBowdsgomfU0mlfdZTms1B4iDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/10/26 at 10:49am, Youngjun Park wrote:
> On Fri, Aug 07, 2026 at 05:11:05PM +0800, Baoquan He wrote:
> > Hi Johannes,
> > 
> > On 08/05/26 at 10:17am, Johannes Weiner wrote:
> > > On Wed, Aug 05, 2026 at 03:53:24PM +0800, Baoquan He wrote:
> > > > From: Chris Li <chrisl@kernel.org>
> > > > 
> > > > Introduce extendable (virtual) swap device support ??? xswap.
> > > > 
> > > > The current zswap requires a backing swapfile. The swap slot used
> > > > by zswap is not able to be used by the swapfile, wasting swapfile
> > > > space.
> > > > 
> > > > An xswap device is a swapfile that only contains the swap header,
> > > > with the header indicating the size of the virtual swap space. There
> > > > is no swap data section, therefore no waste of swapfile space. Any
> > > > write to an xswap device will fail. To prevent accidental read or
> > > > write, bdev of swap_info_struct is set to NULL. Xswap devices set
> > > > the SSD flag because there is no rotational disk access when using
> > > > zswap.
> > > > 
> > > > Zswap writeback is disabled if all swapfiles in the system are
> > > > xswap devices (tracked via nr_real_swapfiles).
> > > > 
> > > > How to create an xswap device:
> > > >   touch swap.1G
> > > >   truncate -s 1G swap.1G
> > > >   mkswap swap.1G
> > > >   dd if=swap.1G of=xswap.1G bs=4096 count=1
> > > >   # xswap.1G is 4K on disk but reports 1G capacity
> > > >   swapon xswap.1G
> > > 
> > > Sigh.
> > > 
> > > Why does the user have to go through this dance?
> > > 
> > > Why does the user have to decide in advance what size the space needs
> > > to be?
> > > 
> > > You point out no inherent limit to how much can be compressed, so
> > > there is no reason to make userspace decide on an arbitrary one.
> > > 
> > > There is no reason to tie an address space that can be managed
> > > transparently inside the kernel to TWO named files on disk.
> > 
> > Thanks for looking into this.
> > 
> > The file-based creation dance is there only because this is RFC —
> > I wanted to reuse the existing swapon path so the core grow/shrink
> > machinery could be measured and tested without also designing a new
> > userspace interface. I agree it's not the right final interface.
> > 
> > The direction I'm thinking for the next revision:
> > 
> > - Drop the file requirement entirely.  An xswap device has no backing
> >   store, so there is no reason it needs a file.
> > 
> > - Use totalram_pages as the initial per-device size.  Chris suggested
> >   this, and it's a natural bound: if all anonymous memory is swapped
> >   out, that is the maximum number of swap entries zswap will ever need,
> >   assuming a reasonable compression ratio. The hard upper limit could
> >   be 2 times of system RAM, or the max system RAM memory hotplug can
> >   add to.
> > 
> >   Doing this because we need consider swap.tier support. A single global
> >   xswap device in swap.tier would mean all memcgs compress into the
> >   same device — there is only one swap entry namespace. With per-device
> >   xswap instances, swap.tier can bind different memcgs to different xswap
> >   devices, giving each its own swap slot namespace. Total isolation on slot
> >   usage, no cross-memcg interference.
> 
> Hello Baoquan :)

Thanks for the thoughtful input, Youngjun.

> 
> Is there concrete user scenario isolation is needed?

Hmm, not yet, it just comes from my personal understanding and thinking.
I will exlain later.

> 
> >    -----
> >    Hi Chris, Joungjun,
> >    Please correct me if I misunderstood the swap.tier concept and xswap
> >    use case in there.)
> 
> >    -----
> 
> Anysway, if we want to use xswap isolation like below,
> 
> 	xswap t1  xswap t2     tier1     tier2
>        | x1 |     | x2 |     | dev1 |  | dev2 |
> 
> then each memcg may have its own xswap front-end and backing tie
> 
>         memcg1: xswap t1  + tier1
>         memcg2: xswap t2 + tier2
> 
> However, with the current tier design, the root cgroup needs to see the
> whole tier layout. In that case, I think the root view may become unclear
> if there are multiple xswap instances. From the root cgroup point of
> view, it may be better to see xswap as one logical tier, not as two
> separate tiers.
> 
> For example, the layout could be like this:
> 
>               xswap tier        tier1     tier2
>         | xswap1 xswap2 |     | dev1 |  | dev2 |

Exactly, this is what I am thinking about. Unless we assign each xswap
different memory tier or memory type in the future. Otherwise, all xswap
instances should share the same tier.

> 
> Then each memcg can have its own mapping or policy:
> 
>         memcg1: xswap tier + tier1  (xswap1 + dev1)
>         memcg2: xswap tier + tier2  (xswap2 + dev2)
> 
> With this model, the root cgroup can keep one simple global view of the
> xswap tier. At the same time, each memcg can still use a specific xswap
> area and a specific backing swap tier.

Exactly. This is what per xswap device is trying to do.

> 
> P.s I am thinking about multiple xswap usecase on tier. 
> (this is just mind map. I don't know whether it is right or not)
> 
> Another possible layout may be to use xswap as a RAM buffer for each
> tier
> 
>               tier1                 tier2
>         | xswap + fast dev |   | xswap + slow dev |
> 
> We can use xswap as a simple buffering layer?
> In that case, we would need a clear policy
> for how xswap is assigned to each tier, and how the backing swap device is
> selected for each tier. 

I may not get your point. Do you mean kernel will decide how to assign
each xswap to tier and how to select back device via policy, but not
user? 

> 
> So why I am saying this is that, 
> if xswap is managed as part of swap tiers, it would
> be helpful to define a more concrete layout and policy for xswap
> assignment.
> 
> This would make the isolation use case much clearer

Here let me explain why I think per-device xswap is the right starting
point.

The primary scenario I have in mind is cloud environments where different
containers need different swap tier chains:

memcg A (latency-sensitive service):
    xswap-A → NVMe tier (fast writeback, small capacity)

memcg B (batch processing): 
    xswap-B → HDD tier (slow writeback, large capacity) 

memcg C (best-effort):
    xswap-C → no backend (compression only, never write to disk)

With a single global xswap, all three memcgs share the same backend. If
memcg B triggers heavy writeback to HDD, memcg A's swap-in path is unaffected
in the IO sense, but the shared slot namespace means A and B compete for
swap entries. Per-device xswap gives each its own slot pool and its own
backing device — full isolation.

Beyond IO and slot isolation, per-device xswap also makes per-memcg swap
statistics straightforward: slot usage, compressed page count, and writeback
throughput are naturally scoped to each device.

Futhermore, the existing swap subsystem is already per-device — each swapon
allocates an independent swap_info_struct with its own cluster table, slot
namespace, statistics, and teardown path. Per-device xswap inherits all of
this for free:

- Slot allocation via the existing per-CPU cluster allocator (no new locking)
- Per-device statistics already exposed in /proc/swaps and sysfs
- Device lifecycle via swapon/swapoff with no new management interface
- swap.tier naturally binds tiers to per-device instances

Thanks
Baoquan

