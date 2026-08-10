Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF7F1C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 01:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86CF16B007B; Sun,  9 Aug 2026 21:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D846B008A; Sun,  9 Aug 2026 21:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733EE6B008C; Sun,  9 Aug 2026 21:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 467146B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 21:49:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC1BC120640
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:49:45 +0000 (UTC)
X-FDA: 85083678330.16.3ECB77E
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 10D331C0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:49:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786326583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1jdee8snFVAGN2va4MHfrOr2fvdFQACn0yYYvhD0AIo=;
	b=x37jcLIcN5WOx96OubpvX0FusGLNj22OJ8S2Lr+HxvAGNHjZnKpzQDWjlDPwbN75gpMHQ2
	dvPrQFdJQA8wn8AvsPWnAIIyZOypbSLgoyTts8SRPQAffDVBvQNjmX1zxIYNMZa6cuGLQ5
	cxUwMyzn1T9o2GfIygaYixDCYWSz/e0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786326583;
	b=WdY1/Alo4lIUiR+V7c5smvbeNIY+U6RwWZlKRj62T+5+JUMm7HcVHFLvJRu3+xy7bLxqEX
	4PBy/zOmB73EmRwc/EQHfLLqy5N9d3lBylvtj//RvxPe0lmn2YSUBcjfTFhV/uqZQMKIzg
	SZ10r7ZCuTBC3q36IuoEwSZgd7en9Nw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.53 with ESMTP; 10 Aug 2026 10:49:37 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 10 Aug 2026 10:49:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 10 Aug 2026 10:49:37 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	chrisl@kernel.org, nphamcs@gmail.com, kasong@tencent.com,
	baohua@kernel.org, yosry@kernel.org, david@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] mm: xswap support for zswap
Message-ID: <ankuMRz8BjHomhY9@yjaykim-PowerEdge-T330>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
 <20260805075336.3579395-2-baoquan.he@linux.dev>
 <anNGE_FOoupPtOhj@cmpxchg.org>
 <anWhKU8NPzosQR8d@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <anWhKU8NPzosQR8d@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10D331C0007
X-Stat-Signature: 7wi3h54kbdn3ewzjkym86yit5nbqi33k
X-Rspam-User: 
X-HE-Tag: 1786326582-151782
X-HE-Meta: U2FsdGVkX18mLCwiQ5jNSGBgZfWXvuMTV2Y3nNG3lCDjTQnrWqwN4hM3peMqZvfa4c29RNybrA6GGaOCZpgYp2U1We3wEtP1utWJk9/c04isJ9X5wUZKv2Oh+w+1036F1rSPLx5Cks25TH+rXTXbyMdLkkKcQXacBg5BPAq3nc1eDT8Ac9npkv69RiR0OT7A/u3IR64sEqHtMoGm1Og1CSzjMZvtucpBgr6JkHEPRzeKZVpfqF4kKIRacVEGLlq+dcT8lKs4Z5z8qWeg5IISoizqiS7Fnk2LNITYjnIWP7732tTuDECb/mdAlhZtWl24JeHSNC22u7cD5OGYsV8ePYoG73Rn+DokU3Dqv35OaDez1gluOLgW+P7UJGGc5vExsbeghAMkT1ip0NbmiZH2qvKbc27ObhWuDTob0V4t4WHs0PEIpLwWyLi53otkhH/SAwcnsavYg/aWds/IKTKH4wHOvlw0sJNUSGCH4pqMyITsMBJp7D5COEmCuvoFyq7DjxaK5T8JrL6zymf/vCtC4j0W+nHaif7WtJZ/BBxrG4wwLIev7sLQm066r6bL8yoewHcRMN6C+Dw9eLZy9G0hbbS/R+FLPUKh2uUsnKNTmDyVECtRDrkOsTaWJgXbqqB6edmE0CjG2+86IjZuqEZqrid2DHqGdgijxezVIDpLzhO/ON485uX3qNH/eUR6CFXGJwE9Cyrd4NrVvbfRfZvb0mKwE0ttX4Pf7rryFxlGHAWegsYviz87NXhXBAnoZhpclbP9Kiau1+wGT74y02Odj2SBBkdNMsyP2RmN9bIv+MKkzSQF5xL024uKn9UiPtWx9r44nwvZvkc7AhT9M/d9zcZRlGTxIHs3gxNaXcxhU6B0MtblJmpeKWjuX3t8inT9ApL+vHetwpYFI9KgVZsUbBwHZXLG3TKlJgNEhtZIKjuPX17MZ6tHzN7yJSUbMre2Zgkbk0hrY2nD/uTg3uJ
 4IuLmfNQ
 FpVYXnBuevJcHbNECdu+dRneMiAJXyQlSfUMd9eKvCjwKWJiOEj98EIT50jjysC3cM3v3XDvnBEZf7fkz8H/7K2cU39WAC0c+sIbuL9QQs9b9e+rWInRikBtXSr3EuBYMSQ3Rq3TOBaxoo5/irJQcfez1H6ol1FxGZxI3m3wsPijzJ8D4GLhdlWfzw3cSErQNP4IO+vOBjbJrkgURIkTHP8DJcMFY8Kh2pRKhxfS9qSoFmOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 05:11:05PM +0800, Baoquan He wrote:
> Hi Johannes,
> 
> On 08/05/26 at 10:17am, Johannes Weiner wrote:
> > On Wed, Aug 05, 2026 at 03:53:24PM +0800, Baoquan He wrote:
> > > From: Chris Li <chrisl@kernel.org>
> > > 
> > > Introduce extendable (virtual) swap device support ??? xswap.
> > > 
> > > The current zswap requires a backing swapfile. The swap slot used
> > > by zswap is not able to be used by the swapfile, wasting swapfile
> > > space.
> > > 
> > > An xswap device is a swapfile that only contains the swap header,
> > > with the header indicating the size of the virtual swap space. There
> > > is no swap data section, therefore no waste of swapfile space. Any
> > > write to an xswap device will fail. To prevent accidental read or
> > > write, bdev of swap_info_struct is set to NULL. Xswap devices set
> > > the SSD flag because there is no rotational disk access when using
> > > zswap.
> > > 
> > > Zswap writeback is disabled if all swapfiles in the system are
> > > xswap devices (tracked via nr_real_swapfiles).
> > > 
> > > How to create an xswap device:
> > >   touch swap.1G
> > >   truncate -s 1G swap.1G
> > >   mkswap swap.1G
> > >   dd if=swap.1G of=xswap.1G bs=4096 count=1
> > >   # xswap.1G is 4K on disk but reports 1G capacity
> > >   swapon xswap.1G
> > 
> > Sigh.
> > 
> > Why does the user have to go through this dance?
> > 
> > Why does the user have to decide in advance what size the space needs
> > to be?
> > 
> > You point out no inherent limit to how much can be compressed, so
> > there is no reason to make userspace decide on an arbitrary one.
> > 
> > There is no reason to tie an address space that can be managed
> > transparently inside the kernel to TWO named files on disk.
> 
> Thanks for looking into this.
> 
> The file-based creation dance is there only because this is RFC —
> I wanted to reuse the existing swapon path so the core grow/shrink
> machinery could be measured and tested without also designing a new
> userspace interface. I agree it's not the right final interface.
> 
> The direction I'm thinking for the next revision:
> 
> - Drop the file requirement entirely.  An xswap device has no backing
>   store, so there is no reason it needs a file.
> 
> - Use totalram_pages as the initial per-device size.  Chris suggested
>   this, and it's a natural bound: if all anonymous memory is swapped
>   out, that is the maximum number of swap entries zswap will ever need,
>   assuming a reasonable compression ratio. The hard upper limit could
>   be 2 times of system RAM, or the max system RAM memory hotplug can
>   add to.
> 
>   Doing this because we need consider swap.tier support. A single global
>   xswap device in swap.tier would mean all memcgs compress into the
>   same device — there is only one swap entry namespace. With per-device
>   xswap instances, swap.tier can bind different memcgs to different xswap
>   devices, giving each its own swap slot namespace. Total isolation on slot
>   usage, no cross-memcg interference.

Hello Baoquan :)

Is there concrete user scenario isolation is needed?

>    -----
>    Hi Chris, Joungjun,
>    Please correct me if I misunderstood the swap.tier concept and xswap
>    use case in there.)

>    -----

Anysway, if we want to use xswap isolation like below,

	xswap t1  xswap t2     tier1     tier2
       | x1 |     | x2 |     | dev1 |  | dev2 |

then each memcg may have its own xswap front-end and backing tie

        memcg1: xswap t1  + tier1
        memcg2: xswap t2 + tier2

However, with the current tier design, the root cgroup needs to see the
whole tier layout. In that case, I think the root view may become unclear
if there are multiple xswap instances. From the root cgroup point of
view, it may be better to see xswap as one logical tier, not as two
separate tiers.

For example, the layout could be like this:

              xswap tier        tier1     tier2
        | xswap1 xswap2 |     | dev1 |  | dev2 |

Then each memcg can have its own mapping or policy:

        memcg1: xswap tier + tier1  (xswap1 + dev1)
        memcg2: xswap tier + tier2  (xswap2 + dev2)

With this model, the root cgroup can keep one simple global view of the
xswap tier. At the same time, each memcg can still use a specific xswap
area and a specific backing swap tier.

P.s I am thinking about multiple xswap usecase on tier. 
(this is just mind map. I don't know whether it is right or not)

Another possible layout may be to use xswap as a RAM buffer for each
tier

              tier1                 tier2
        | xswap + fast dev |   | xswap + slow dev |

We can use xswap as a simple buffering layer?
In that case, we would need a clear policy
for how xswap is assigned to each tier, and how the backing swap device is
selected for each tier. 

So why I am saying this is that, 
if xswap is managed as part of swap tiers, it would
be helpful to define a more concrete layout and policy for xswap
assignment.

This would make the isolation use case much clearer

Thanks!
Youngjun

