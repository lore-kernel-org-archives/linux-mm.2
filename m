Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A7EDC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512B76B0095; Mon, 21 Sep 2026 06:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA586B00DF; Mon, 21 Sep 2026 06:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFB76B00E1; Mon, 21 Sep 2026 06:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDDE6B0095
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:05:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5172A156C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:05:01 +0000 (UTC)
X-FDA: 85237336002.11.3EF4022
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf26.hostedemail.com (Postfix) with ESMTP id E5C9614000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:04:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VviTU8YR;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789985099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=848XtZxmbC+66r3doYpKzH4vwIPqoTKFKUcJhFIukUc=;
	b=LRj4jghstRQD2wwttjajlWPrzJ5mypC2v/HN+gOq2e81sJqalsH6U1FxbkxNNx2inbU3CJ
	Ce7ZkxFJmZ1kVgcfc0RGjmt5EfLfomQDlSo4iwK9Oee1ZflnlsLUXlqPqgX0MJnvTEV2PZ
	Vy2EaJuqUYbM2JzqeAF2T2Ok2iwxIVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789985099;
	b=kSwChdWjeg1bjFgwwZQl0QRqY1lDlM/zoHXHqNcTbcuRzveY4N6ukCcSMXhQ7YH6K41Sfc
	puoLoRPTjn6bcWxU6jND/BagYrL6tm6XJeuLcoxoqHXY63/551tuRcEfHDOPe4AyeMVlWg
	XGDVlPKSa4s74rEnc0KHScwAeyCCP/E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VviTU8YR;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VwHox4/h5VjYSrL3ZI6LKmLCzWabEF1m5mv80BQeC1g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789985095; v=1; x=1790589895;
 b=VviTU8YR5qClJJFiaflEOuE5lmWnXQHbkv8W8sxtWYPWmgbjps2p23TLuQM+bcMsPrg0uddK
 Tn8Ggj/ORFB2Zl8ukDq5MlZwfnSiOWp2pTUqeQ+swpEp7e2Yfx4lLF5L6aoSNR7OB4sPJrdFMtd
 vQT+m/y78OESoZoWKx/esinQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 133da64645af3d12;
	Mon, 21 Sep 2026 10:04:54 +0000
X-Mizu-Trace-ID: 133da64645af3d12
X-Migadu-Flow: FLOW_OUT
Date: Mon, 21 Sep 2026 18:04:46 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, kasong@tencent.com, nphamcs@gmail.com,
	baohua@kernel.org, youngjun.park@lge.com, yosry@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	david@kernel.org, linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Message-ID: <arEBPsFJvzhQZk9W@fedora>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
 <aqrHjfHwyEtRIr5S@cmpxchg.org>
 <aquWKJoP5JLP8Ci7@fedora>
 <20260917131712.GA1344@cmpxchg.org>
 <CACePvbXQRBnTAivJp7mh-y3PQjjUeO4KxzV8+nnhC5UzMomT0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXQRBnTAivJp7mh-y3PQjjUeO4KxzV8+nnhC5UzMomT0w@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5C9614000F
X-Stat-Signature: baoxg6ax9stssfiyqpftnfoieuu53xqs
X-Rspam-User: 
X-HE-Tag: 1789985097-72991
X-HE-Meta: U2FsdGVkX1+CpkJE2FjbvWEBuDFpt1YIL6gH84yLBYhmEWcw63uq/2dOVbwIFo5AlIGtoSwPP1meApnT6IiuOVM4iSCxwPlV+WqZCzAIbbwrsdgQOuYwbHzdnSDZnw3byTEsRvJmNC+EhuxfYDVZBdcsgOWF/s1cJnGsTGsoN98BE7ULtYB5AY+n1NFCX9DurpS5oflwOF2MtXL334bahDfiESGjquH/VQMM9eTRbjpm6lyduhuPfsvWZ9Uk9fCsJ+J/YGn9NFwjzcCLXLZjkrhsu+s95EK7mWkCe2VhqezoC/Vd+FA1NixQNjp1ccHJ9ohg097Cn/JK7jW1HKGKxHydDSda9ZqwejViHkkmEGIy/kRUOb0lCxdRjOLZOm/WjBhxOoseXPiRSqFNglskZxT2mWJlg35GmuT7DbscHFnDp4VRQbEhyL2WZ4PcbEUDjiqMuCPqpOLdZ8JIOOGNdBdXB+gwSszRWUGN1hov5DmZimCvCLPepL2WjXugDW2ZcaIhJVqM5XJJF+XM4ApfHhTVBNiFaiYlSYFf7DXocZY7RjplVw9a2KIFXvihlD3Ix3Wx3MfmH+4dmgcXYIPSlIjO2oRVo3TgiNRgzZ1kFvRym3BIlaQ7mtJReXjNkRbe4I7ceTzyWl1F924d/Ri4aXdOHORqlSttd3vVMpIMdaTCXTT2gkeBD7oqGIoI+aRBNmL0kyjDddo+x+iXzy655zcQRSQ0Cb7J0NR4GUlHH1Y0mF4qyRBT38iqO9/3vGh5oTA5uhPMurOkaLcgwtNYX1MG5lsdTMbH49Ko3YJ0o8T+pus8tTxr9Lzew4YumsvT1oBwChQ3A8boO+UySyj6DjTXnVB0bL34K6UWnHLBVvO3/KCUvF1IRBvo1b4/Mh8vxnShh/nT/eqWJ51AWu7V6WfhkC7fxLQ/3dyJ/FMgS/Q5zIbUH+++KCq9n+mb426uyNIoEwivnjedFAe/+U5
 8lC4oI2C
 GZ9TKfqi3iXCAz7jx/wr4U7sMtO7QmY7al5JJUx5wk/ArT5SgXasCD5YEXqFzAeN2lTlDRvjpSxsj8vkCnRgnYzDJq9q4HZeMYXKmgfvSYVuuxJh7XOIavSs39O9O3N8DjFmk2+IXizI9XuyLDgtVcxel/B1ysRYNSeVOlHUma2a8gThWtwuGrA9aukir/AYUVeChA2afAk3Lny4yCF7nvtFI7tyuyp0ZbfKa6EhkY6Y/EcO7j97JYpR7YEOyaYh0FoeuJK6uN30TeUhs8MNSiJMa5TY3evbhEWeEak+N/2Y/2Z7W28e/Qbpvq7HxnLhksaMZUpn7i4cs5irc30K3Vsfmgq8zCDKsKNSxGPePU001VW6MMVBc7cF0aR0UMU+hI6XBrYZtZhT7SKkAxuQji0fcbapGqiASfnlI7Jr5Xn/s9yP5+HTMTMpibVfR52QRa20CSJOviXjGjFbTGTsYMGt/ZF+5gaE/UN+0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/20/26 at 11:52pm, Chris Li wrote:
> On Thu, Sep 17, 2026 at 3:17 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Thu, Sep 17, 2026 at 03:31:23PM +0800, Baoquan He wrote:
> > > On 09/16/26 at 12:45pm, Johannes Weiner wrote:
> > > > On Wed, Sep 16, 2026 at 06:19:07PM +0800, Baoquan He wrote:
> > > > > xswap is a swap device with no backing storage. Swapped-out pages live
> > > > > in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,
> > > > > and the area is grown and shrunk on demand as swap usage changes.
> > > > >
> > > > > The problem being solved is the static size of compressed swap. Both
> > > > > zram and zswap need the size fixed in advance, and neither gives memory
> > > > > back when the workload shrinks. The solution should be a device whose
> > > > > size can scale up/down as per usage. xswap does that by mapping the
> > > > > metadata lazily instead of reserving it for the whole range.
> > > > >
> > > > > Design
> > > > > ------
> > > > > - si->cluster_info[] stays a plain array. Access is still
> > > > >   &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branch, no
> > > > >   RCU discipline, no tear-down state machine, no NULL return.
> > > > > - Only an initial chunk is mapped at creation. The rest of the address
> > > > >   space is reserved, not allocated, so an idle device costs nothing.
> > > > > - Growth is driven by allocation. When no free cluster is left and the
> > > > >   address space has room, the next chunk is mapped and added to the free
> > > > >   list. No userspace involvement.
> > > > > - Shrink is driven by frees. The free tail is scanned, and whole chunks
> > > > >   are unmapped once the mapped range is at most half in use and several
> > > > >   chunks can go. One chunk is left mapped as slack, so the next
> > > > >   allocation does not map it straight back. A ceiling lowered below the
> > > > >   mapped range skips the half-in-use rule and is enforced at once.
> > > >
> > > > If the swap maintainers prefer the VM_SPARSE route, I'm happy to defer
> > > > to them on that.
> > > >
> > > > However, from the cgroup and zswap camp, two stipulations that I
> > > > reasoned out in the other thread[1]:
> > >
> > > >
> > > > 1. You must not charge compression space as swap space to the cgroup.
> > >
> 
> Sorry let me push back on that. That is already existing user-visible
> behavior. Changing that will break our deployment using zswap. I don't
> think we should change that.
> 
> See more in my reply in the other email thread.
> 
> https://lore.kernel.org/linux-mm/CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com/

Thank both for valuable input. I am thinking if we can add an counter
like memory.swap.disk.* or memory.swap.backing.*, then we won't break
the existing behaviour, and also cover the use case Johannes mentioned
where different cgroup have different swapout target setting on xswap.

> 
> > > Hmm, I don't have a stance on this. However, isn't this an issue
> > > zswap/zram have been doing? It feels like an independent issue which
> > > should be done separately?
> >
> > If you have 3 containers using compression space, and two of them have
> > writeback enabled to a shared swapfile, the memory.swap.* controls
> > need to work to manage fair access to that swapfile. They do not work
> > if compression space itself is conflated in.
> >
> > Right now zswap entries actually consume physical swapfile space, even
> > before writeback. Charging the space is correct. But the whole point
> > is to decouple compression space from physical swap space.
> >
> > This is not something that can be done later. It would be a dramatic
> > user-visible change to how the resource is categorized and managed.
> >
> > > > 2. You must make the compression space large enough to be outside the
> > > >    range where users can hit space limits before hitting memory limits.
> > >
> > > We may need a way to define 'large enough' at first.
> >
> > I've tried to lay this out in the other thread, and highlighted the
> > usability issues that result from hitting compression space limits
> > prematurely. It's kind of your call whether you want to seriously
> > engage with this or not.
> >
> > But ultimately it's your claim that a static size can be made to work,
> > so it's on you to make a convincing case.
> >
> > > >    That also means not allowing setups where this is possible.
> > >
> > > And the limit is only an optional knob. If the admin does not set it,
> > > the device grows to the full address space, so there is no space limit
> > > to hit at all. It already behaves the way you want by default. The knob
> > > is only for admins who want a ceiling, they can use it or not. I hope
> > > this would not be a problem for your use case.
> >
> > No, I've laid this out already as well.
> >
> > This isn't about "my" usecase. It's about designing a coherent
> > interface that works well with a large number of usecases, and other
> > pieces of kernel infrastructure commonly used in conjunction.
> >
> > The other proposal in the room needs no such interface. The burden of
> > proof for adding one is on you.
> >
> > > > [1] https://lore.kernel.org/linux-mm/aqLi6cIjD2wJwk0B@cmpxchg.org/

