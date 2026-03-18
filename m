Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58DDA10854CF
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 02:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9FDF6B00D4; Tue, 17 Mar 2026 22:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A771F6B00D5; Tue, 17 Mar 2026 22:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C796B00D6; Tue, 17 Mar 2026 22:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 874D56B00D4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:46:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 559391604E6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:46:10 +0000 (UTC)
X-FDA: 84557644500.11.183FE41
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D4C41C0003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:46:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773801968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vI6FUYR0xzd6oGcsk6C6DwllM9yn5R8KxM0B/EoqS1Q=;
	b=Jj4oIN5Yacjus/aT93t2/VSiDXw8IhhRzZg+4vqnVLpzJ57Htvc2cyUHGJbte8/2+HxHZO
	barEZAETHFqXvO9qQoeAe+VYu+GLAtyQUWykfXSuHQzbIYJv7PcmO+/upjP/3puUBuD2Z7
	32BdzRmNhwvzZVpW5lclw8r56tq04QY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773801968; a=rsa-sha256;
	cv=none;
	b=ij8T0tj1S+YcK2sDb2qkuUWg1bclJWKccKIc3ZmPCmLqImxT+9Z1rAqv2bEGjtmCT5zt5E
	MI9QCpacBJ9oJ88rHxZc2eWbul/l0hMg/J6pC9AHVlgM14uflj3/nHRXcINiU5Q4i7Md5l
	dzRjpr4VsBhL3PNzhfvmrrvxuJiJ/7I=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 18 Mar 2026 11:46:03 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 18 Mar 2026 11:46:03 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com, hyungjun.cho@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aboR60vcbS3edAbZ@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
 <aZpY1FIjYLtLdu5F@yjaykim-PowerEdge-T330>
 <aaXM58EsMtbGri2B@linux.dev>
 <aa9+eK/VEealbo8i@yjaykim-PowerEdge-T330>
 <CACePvbXhk2GFTay3OrPoqFU=hRt9N5fgx=FrWFQ6nj4Nyn7b8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbXhk2GFTay3OrPoqFU=hRt9N5fgx=FrWFQ6nj4Nyn7b8A@mail.gmail.com>
X-Stat-Signature: s59zzx3o6kjhpykhzxyeqop9o7tqsdnb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D4C41C0003
X-HE-Tag: 1773801966-265481
X-HE-Meta: U2FsdGVkX190eH+CqsZXi+NalvYamhvegosv5uJYGDf8ZohwT5ChHBEeWtwmt3ZGkD8GNYLnNoRYpgJf8RTkt72qNz4nJ6V4RT8F6fTKOQU5o/+gdwdDpwbQQ1W+cKq0+HyEhFOuPgi2AILOSO+yI7mliVyGH0+XrED0y1WAwFWMxUYSktotHPWnpcjfjOJYIu5V08ux2mcsvfGdmKcMwrIJuGDBaMu7OVrrqLb+mdnly33QxVtDySSo8y6OFtrVaykuoFStBqMzetXakrSXv4s1LFKd48H12rqrGaB7b/Z26GHeV6nQ9pI3E+mOeGrLhIDt3Y3VIdDTxm4deHRN/PbuDbZDJw8VxBEvYfUlhqayp8r116m8/Xzbuz2Ao9W2JkhX7v42w9Zf4am978w/qb4Fd4SdKwOGZ6I2dsr2ChTPZwm7/T6G1D9epC8ccnj5ZlOMwCrlAVqSSM+8fjbbRn/zVBljgXeBH/JbtihT6exMxbdWBAl31woAmZsfs86KlTLQFbhKLOYjq63iVLIOaCEwf9BSZXivNKAdx7eFD5iWFv7eloDsYWy0D7GVopVr1Miaw37FrWfobz8UsC8i9POMZRXKTj9Cv2oy5yNBZOvfnWQlpH/3dVZBxhuEFmafl6w/9EQ1dNZ4OF0tagS94R0NrsGiBSe9UMx8sNQHx80Cl8wqt4w3ssgSNYlquYPY6i4KF/O7g2IMeCC9YwY4DtuLhYllntJu1flK+twWRpnFcekgYfxezaRcyZa7u0SdRjaoc/aaTy4HhxL/UhiaBjRO7yh9Ej1uQKYDITEXlvG0KayJByATQIWNDDzkpykEcR2r423oVZZDQ2O2ooZkAui2jckPyYeH21R1p9qJKKtbz2TTZFl2YEA24CD40PVvBRUzBRx4DWH5ayISfEo9Xg9LFE7inN1FmW74cG5fKA1JrNt3H7jDaJdFk0cWTu14PKAu6D5ys5WJAhqCMnb
 R96NuEoC
 iUPnsItCj76LwcoW2sLL381fK3tIOCz9I+kvH6bx2UZm5rYHkYQIw543Z2Fag/bCAuQ6TPMKOWr1WiwuepiQjQ5+bErvo2b7Tx723PZt2eGaj7QF/6YhIL10O9PA8OOSxRP2dN+NVEY5XP4Ohs8iMjnH6pH7iK8I7wPm/HaiuFTxvT7LJe0BVJFIvekAsmGTCgPwCtkcgJrvwrKwUkYzz6Dz+Z9K/e6OBu83EaAtcT099lnlonOeOVpGCuvCwhiKDXmI1YSS+Fa6qD8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Sorry for the late reply, busy days.

No worries at all. Hi Chris,

> >
> > To quickly summarize the main points:
> > (I might wrongly undestand your intentaion, then correct me please :) )
> >
> > * Regarding Shakeel's BPF approach, stable interface movement would be difficult,
> >   so we need to choose a direction. I prefer adding it to memcg for immediate
> >   usage, and if it proves highly effective, we can consider transitioning
> >   entirely to BPF later.
> 
> I am very concerned about locking down the kernel user interface just
> because things might change in the future. If we need to use BPF to
> get the stable user space API, I am fine with that. Completely
> blocking the new cgroup interface because of a worry about future
> change is not justifiable IMHO. There ought to be some intermediate
> staging we can do e.g. debugfs interface to test and play with the new
> API. We should focus on designing the interface as well as possible
> right now.

I completely agree with using the cgroup interface. We have clear use cases
and have already shared many thoughts on this direction.

> > * Shakeel seemed somewhat positive about matching all child tiers from the
> >   parent if tiers are applied to a specific cgroup use case, and I would like
> >   to start the discussion from here. Chris, I would appreciate your thoughts
> >   on whether you agree with this direction of unifying all swap tiers within
> >   the hierarchy as a first step.
> 
> Does that mean all children will only use the parent cgroup setting?
> Wouldn't that be more restrictive and counteract the goal of making
> the API more future-proof?
> For the record, the current Google deployment can uses a different
> swap device for the child cgroup, in the current delpyment.
> The typical setup is that the top-level cgroup is a job running on a
> VM. Then there is a second cgroup level for the VMM guest memory
> allocation; swap device selection occurs at this second level.
> There is also zswap vs SSD, the SSD is something new starting the
> deployment. So it's not just about enabling zswap or not. We also need
> to select the swap device.
> If you get the current cgroup, it will need to walk the parent cgroup
> chain to find the toplevel cgroup any way. I just think having the
> hierarchy makes more sense.

Since you confirmed the use case for allowing child cgroups to have different
swap devices from their parents, I would like to keep the current hierarchical
design. It seems Shakeel was hesitant mainly due to the lack of a known use
case for this. If Shakeel has further questions, I would appreciate it if you
could help explain the Google deployment use case.

> We need to find customers willing to use this promotion/demotion. I
> hesitate to build something while hoping to find someone to use it
> later.
> It would be good to identify someone who can immediately use and test
> this promotion/demotion feature.
> We should focus the discussion on achieving a more flexible swap
> device selection approach and reach a conclusion on the API discussion
> before discussing promotion/demotion. If we can't even have a usable
> swap tier interface, there is nothing to promote.
> 
Since I have already sent RFCv3, Patch v4
(https://lore.kernel.org/linux-mm/20260217000950.4015880-1-youngjun.park@lge.com/)_
and we seem aligned on the core direction,
I will proceed with sending v5 based on the current design.

@Shakeel: I have been waiting for your feedback longtime, but I will move forward with
v5 for now. Since Chris confirmed a solid use case for the child-parent
hierarchy, please let us know if you have any remaining concerns when I post
the v5 patch.

As a brief history, we have evolved this proposal from per-cgroup priority to
swap tiers, presented it at LPC, and are actually using it in our production
environment. I sincerely hope we can get this merged into mainline. 
and evolve this mechanism after applying it.

Thanks,
Youngjun Park

