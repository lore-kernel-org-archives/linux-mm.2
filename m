Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55432CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC288E002A; Mon,  1 Sep 2025 12:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC7C8E0002; Mon,  1 Sep 2025 12:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B748E002A; Mon,  1 Sep 2025 12:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7B9D8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:06:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EF001A0914
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:06:47 +0000 (UTC)
X-FDA: 83841159654.07.051DF16
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf14.hostedemail.com (Postfix) with ESMTP id EAA2C10000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:06:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756742805; a=rsa-sha256;
	cv=none;
	b=JalB+SD9pVJ963F844OSo6sSM+70VwdVgGe5uwrUhYQD12SLEOnj1nUKJ/4s+Tc43yWftW
	Eh7rajJavkjg69FqdioM1ggZ0wUZ9XXURt87voDszrHANvkpDoZv2eD1bDTumLahnuWVBx
	cH6dVZnhfKB8iTbkW9cXwDvg4B9ewK8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756742805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0g6SugGw/UALqv2cU10ldYc1q7M6DhWlc37IAVZPeA=;
	b=60rAyn/xT3Uo55SJB68+/TF/hJnmLMkjBcYlatXAdN5j6B4Hi4mmKXsQ0RTeLMUzL+tVFM
	reSi7lEAf8Yc64aW/ZTwQrwI6jl+Hk394Qe/YPh1aBib07C4LntjheULPlTe03XL4RT1fa
	6KHLgfjs4NSyZZ/R16DsCqLQBejMgIU=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 2 Sep 2025 01:06:41 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 2 Sep 2025 01:06:41 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aLXEkRAGmTlTGeQO@yjaykim-PowerEdge-T330>
References: <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330>
 <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
 <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330>
 <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
 <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330>
 <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330>
 <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
 <aLRTyWJN60WEu/3q@yjaykim-PowerEdge-T330>
 <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
X-Rspamd-Queue-Id: EAA2C10000C
X-Stat-Signature: 1r6gwm1pyqetu61mjwyscxphhxnrozej
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756742804-657070
X-HE-Meta: U2FsdGVkX1+UMd1OwTjDdZ9ibGPFLte8e2EXvjXxEYdvj+0VFVw9rmTYwCHx0kq+R1qY1Ef4KNX6IhCFnCUa+wpesGQA6BGX8FQV4bUiLJ2GVqJpApguxqdMQYZ7qY3Ad4cp35qV8WN+Iz5fkC1lKyNSL7wn8PNRs4XqXOxIHkfn2UXbkVhgeAyZqmpejzpcPMxfqzk05HPDdeU5V051prrOnDWuZc0wR6qOpP04e3DmnY06FX3wajJuLNoD6OWYhJWekp9795Vcf8NTFWvxCWjnznJkuDNh+/Kxa7VpMS16hRAv2TPMHeSgN/GIVedilWIvZegLn3x76FslXNitnapCtqhNhLCA171tPclkxV9sgC6gPFJCy2APUvKscVVZ4YhwpsLv6ajUAD6+aINdUiKcFeO50taVeRb0SfUvgKooqD9n+lgZ6LYylWIJlQD6cWcMiCsuRfoZ4uvomHbi/GMdoZVy9QWIERAvj5K97bvKrxGgK4E61GkbioOGeeWfdbHgjCWOrgnvW1M4hYNLyo03yKwcqpmKhErEzX+B1ZeiBQvrKU9E/hrWwNiED2ZwpRbpChHrOm+FDFr/zHNExLZQ8K6dtiHEeCUqW7nHRYdxLEFDXFBYq2mcAXbog5Rk6YfQXyWdYz3G+40uKO8kYQyta0A6d6D9Q707K6HGPjSBgeyLx662/UG8/I1v2EwYl220XWjfepp3w96U/SQcZCFiz/BZbJcUEcrZT0LMSvI2qeLJZ24zD7IK+/0k67r491XfOU/KpQcxY8+LRvifWmMDw09rd7RUry8JYRZX3vkp3xBrnJ+RFo/0+zXAdy6SOEeOKF9XC//aB6VmBYOdwtrYFYKQXqHyhoLw746V0I4FDWI6fCv+rA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Overall, the alignment looks good. Among the three points you suggested,
I agree with (3) cgroup inheritance. I would like to continue the
discussion on (1) swap tier lifecycle and (2) allocation logic.

1. swap tier lifecycle
2. allocation logic
3. cgroup inheritance

> > This part relates to my earlier point on runtime modification. My
> > intention was to only allow setting the tiers globally, and to align
> > bitmask with priority ranges. For example, an input like:
> >
> >   ssd:100, hdd:50, network_swap
> >
> > would translate into ranges as 100+ (bit0), 50–99 (bit1), and 0–49
> > (bit2).
> >
> > From your description, I understand you are considering allowing
> > additive updates, insertions and letting bitmask differ from the range priority. Is
> > that correct? In that case we probably need a way to distinguish
>
> That is right.

Yes, I agree that add/remove semantics can be supported,
But it was not fully clear whether there was agreement on the full set
format, I wanted to state explicitly that my preference is to require
the full set format for simplicity. That said, if staged insertion and
removal are considered useful, one possible approach is:

(side note! explanation of the interface was somewhat
descriptive, which may not have been fully clear. If this explanation is
sufficient to establish the general direction, I will aim to present it
more concretely in the patch series. Otherwise, I can provide a more
detailed explanation in a follow-up email.)

  echo "add ssd:100,hdd:50,network_swap" >/sys/kernel/mm/swap/tiers
  echo "add new:80"  > /sys/kernel/mm/swap/tiers
  echo "remove hdd" > /sys/kernel/mm/swap/tiers

Alternatively, separate files for add, remove, and show could be used to
represent staged operations:

  echo "ssd:100,hdd:50,network_swap" >/sys/kernel/mm/swap/tiers/add
  echo "new:80"  > /sys/kernel/mm/swap/tiers/add
  echo "hdd" > /sys/kernel/mm/swap/tiers/remove

When using the fullset approach:

  ssd:100(bit0), hdd:50(bit1), network_device(bit2)

If we remove the ssd layer and add a new tier:

  echo new:80,hdd:50,network_device >/sys/kernel/mm/swap/tiers

The show output could display staged state (imaginary output for understanding):

  ssd:100(bit0), new:80(bit3, in stage), hdd:50(bit1, removing), network_device(bit2)

After the hdd tier reference drops to zero:

  ssd:100(bit0), new:80(bit3),  network_device(bit2)

> > between “add” and “reset”. Personally, I feel supporting only reset
> > semantics would make the interface simpler, while still allowing add
> > semantics when the full set is provided again.
>
> The counterpart of "add" is "remove". There are two possible ideas to explore:
> 1) only allow removing a tier when all swap devices in that tier
> range have been swapped off.
> 2) Remove the tier by removing a midpoint from the range. The lower
> tier automatically gets the range belonging to the tier that was
> removed. Optionally, you can add another tier back in replacement
> with different range boundaries. This effectively achieves replacement
> as well. This approach does not require swapping off the swap device. I
> like it better. If you want to avoid the race window where the
> swap device temporarily belongs to the lower tier, you can always swap
> off the device before performing 2). So 2) can be mixed with 1) as well.

I have already explained this from the perspective of option 2 mixed
with option 1. Let me clarify one point:

If...
ssd:100, hdd:50, network_device.
Insertion above 100 becomes visible after ssd removal,
Insertion above 50 becomes visible after hdd removal,
Insertion above 0 becomes visible after network_device removal.

It means that as long as the tier exists, the referenced priority ranges
cannot be overridden.

And Regarding swap_tier object lifecycle:

A swap_tier should not be deleted until all devices in the tier are
swapped off (As you said, references are held). Therefore, cgroups that reference a
tier should also hold a reference. Silently dropping a tier is problematic
from a cgroup perspective.

If we allow this, the implementation should behave as follows as I think:
If a swap_tier is removed, the cgroup’s tier configuration could be
marked invalid. This should trigger an event to the cgroup to notify
user space.

> >
> > > > 2. Slow path allocation uses bitmask skipping; fast path uses per-cpu
> > > >    tier cluster caches.
> > > If the fast path fails, it will go through the slow path. So the slow
> > > patch is actually a catch all.
> >
> > Do you mean that if the cluster does not belong to the desired tier in
> > the fast path, it will skip and then fall back to the slow path? If so,
>
> I am describing the existing swap cluster allocator behavior. In my
> mind, we are using the existing cluster swap allocator code, with
> constraints that only allow swap entry to be allocated from the
> affected tier bitmask.
>
> > the slow path would need to avoid inserting the cluster back into the
> > cache, otherwise processes with a global swap view may end up using the
> > wrong tier device(which must be referenced firstly assumed)
> > Also cgroup which is tier set experience performance degradation
> > because, there is possibility to try to alloc swap on slowpath most of the time.
> > Wouldn’t this have performance implications?
>
> I think we are mixing two different concepts. There are swap tiers
> which decide which swap device to use. Then there is the swap
> allocator to allocate a swap from the allowed list.
>
> If we move to the swap tiers, the swap allocator needs to be swap
> tiers aware. So it might move to per-cgroup cache list or disable the
> cache for cgroups that haven't been allocating for a while. The
> allocation logic should be in the allocator, not in the swap tier
> layer.
>
> > I was thinking that maintaining per-tier per-cpu cluster caches would be
> > simpler. Then each tier manages its own cluster cache, and we only need
> > an array of per-cpu caches of size “max tiers”.
>
> Again, let's not jump to premature optimizations. Do it the simple way
> first, then let the measurement numbers guide us.
> It might be per swap file has a cache not necessary per CPU. per-cpu x
> per-tier the combination is too big, I am worried about caching too
> much swap clusters. Each cluster is 2M.

You suggested maintaining per-swap-device cluster caches. As an
alternative, I would like to suggest a per-device per-CPU cache
approach, which could be simpler from an integration perspective. It
would fit more naturally with the existing allocation logic, remove tier
awareness from the allocator, and should not introduce functional
differences in behavior. Moreover, since SSD devices are likely to be
concentrated in only a small number of tiers (with one being the "best"
tier), the number of clusters actually cached at any time would not be
large. I am not presenting this as the ultimate solution, but rather as
a simple and reasonably practical approach to consider. I agree that we
should revisit and evaluate this approach further.

> We DO want some parent level control. That is a real customer
> requirement. The cons with your proposal is that, if you want to
> change the whole set from top-level cgroup to child cgroups, you need
> to traverse the hierarchical chain to set each child cgroup. While
> walking the child tree, more sub-level cgroups may be added, and
> you could miss newly created cgroups. It becomes a mess.
>
> It is much cleaner if we allow the child cgroup to have the default
> "swap.tiers" empty. Then you just need to set one value at the top-level
> parent cgroup, and all child cgroups inherit it automatically. A child
> can overwrite it if desired; by default it inherits from its parent.
>
> The whole set of cgroups from top-level including children can map
> into a Kubernetes pod. It is common to perform adjustments on the
> whole set atomically. We should support it.

Okay I will adopt default inheritance for pod-level and similar use cases. A
child cgroup inherits the nearest ancestor’s mask upon creation. If it
later sets its own mask, that configuration will apply to itself.

> I think we are aligned.
>
> Thanks
>
> Chris

Many thanks for the detailed review. It helped clarify the implementation
direction, and I look forward to preparing the patch series accordingly.

Youngjun Park

