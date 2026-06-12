Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A240CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 21:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E356B0005; Fri, 12 Jun 2026 17:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F896B008A; Fri, 12 Jun 2026 17:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87426B008C; Fri, 12 Jun 2026 17:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6B796B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:31:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DBA740282
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:31:55 +0000 (UTC)
X-FDA: 84872558190.11.A091FD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4FEA18000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:31:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2C9aLsH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781299913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8PD9i0sOIQmZK1FI66pR0cqwDLEgrFW+rulxA1LOvE=;
	b=lsk9C/uuUL70kGSZiVrk9KYoPK9rbJndCiqsNirjONKWImgVRZdQFFloC+ZHdUUeX/kt9R
	fOh8zsQ8oKAROLh8gIroodyQgsvCRFFA6gxgpviRfSEn3ZZjriIfCWOxiTKueSr+SHOd4Z
	i6Q7cWofHmlqodMmaGNR7fB8VLCQS1U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2C9aLsH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781299913;
	b=X4dfbd68aWi6OraDbdSNfoBJ89RXJnd/kUpXYD6O6Y/zGC6HALLsLbC7mLYGvhQyK6rIsu
	bBa5F22yahwzcuQhszh96+WUA4Sdxksas8ZjZ1gNjIq/XCoSzY288DXEXgqnmMnOdmpA1V
	kPt1L/KSHbYGiXIpmcvTsLY9/IKhOHI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3FD560142
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADED1F00AC4
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781299912;
	bh=b8PD9i0sOIQmZK1FI66pR0cqwDLEgrFW+rulxA1LOvE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=d2C9aLsHpl2K7U/kj2lmpOhu7UxHqUtJWjFxMsV4jzRnjD4dDsd6DM8L5D8aMxjzD
	 HKUussFsE2Aj2dF67WLXQK2lKQMI+epPQZsCkS4q/hZlaSqaMWRwImwEQ0HhyFfzBb
	 KHN1WdwnSCg5InR0RuLVVXj12FurveOnrpJeoW/qnmA1/bgUfmFDO16OdAxDq/sv6a
	 ke1GlUnZiCNe7gy8LJ/P8ZYl75dWiKQPsS7D6pneZN0cay9wdmAkDUDu4/sglNktFH
	 eSIMmRPluyUZswmvuOoFwvdRKouZQA5zQUU0mdOopTRxqbjPMA0IgoMPK7i7aNNBdq
	 SI2JWlVnF6qWQ==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bef47b1ac01so204478566b.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:31:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+Kzi1gX6PMs5oprYrkt75Z2nZkILLemTDBDqIk1lgxWNaznvzrISnLTjAeVQyzlJrR9KDCKlLNjw==@kvack.org
X-Gm-Message-State: AOJu0YxZXRehjAurFIYyxvJiiagV3+ybniG5MHa7bQF7LBpKqsmCMCEg
	H6Q1E1m470koS4S6ZfuBLQzAByVKDKWzK6AQrcn6e4LyWcQAVcy8yRQb8O2l4+eWa5ojgf94qu8
	Xb9RYSWlESQIzKINVoeaTkOoWImx/dyc=
X-Received: by 2002:a17:907:e143:b0:bfe:ed16:2841 with SMTP id
 a640c23a62f3a-bfeed1638f4mr80835566b.53.1781299911645; Fri, 12 Jun 2026
 14:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev> <aicZ-5GX9De3MAU7@linux.dev> <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330> <aiw2p5ANjsQUCIHA@linux.dev>
In-Reply-To: <aiw2p5ANjsQUCIHA@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 12 Jun 2026 14:31:40 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNi4-QC4sUi=xXWHt9WMeG39mbyoSf8kON9vLOZ=cbCmw@mail.gmail.com>
X-Gm-Features: AVVi8CcO7wY2xTke3qmgBmUl7EfCwgtSKSiK31KON1wLQrtykLxRuXz4sDM4eoU
Message-ID: <CAO9r8zNi4-QC4sUi=xXWHt9WMeG39mbyoSf8kON9vLOZ=cbCmw@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: YoungJun Park <youngjun.park@lge.com>, Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, kasong@tencent.com, 
	baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A4FEA18000D
X-Rspam-User: 
X-Stat-Signature: ha4y3ffduorpnoj7sh8ipd3na736zjo5
X-Rspamd-Server: rspam09
X-HE-Tag: 1781299913-995680
X-HE-Meta: U2FsdGVkX1+GPavHhf0isszdrZL4Kw3RNDwZAH/gQRafwfyMGZrsYahPfn/S8Mb3/cheH0DohxWg0Rx5i964Vu2ar1CPkyIn7rPE5S/93Uw4m5fYqID3BfKMRvdJFLWddZ88bufOnkNr0XkY/HFOMgaDaf5gekZ7DPo3hYH45xsbqAhcnSHRsoC4DIrzSVjlOmso7RAUzyeTSrzXLiYP/+O0q7rARdL265YHG3wo9GOUXx10MUWhlwhpGSmRt4PiNMFdOb1jHrPYrvg0U298FiumMiBCqMGl27a8Px0aCG6lOBffn4SFF3Y80v9L+KiuHI4fUaOt3kwLX1TI7fUoL2k+0p2nRGGqQ4dMCFzrNMZo4ePXT1Q2ZnR83cjV8IwZIy04UQtLqWy9gWrWylqXr/WON4k6dnJwTzrqcVzEK7yK8ALZiUN15aGyAdFJKs8FEf4NWWFUwWwgHIBNmAQgFkIkO8yElr/kh0SGc7cXrl8Xzysp55jHkbf1nOSFC+zoVtbcRCbQv/LmS0E5NtZINCwOmSfmfsQsNHnHi8vkZR8W1+TPEtykxqhsPS4l7GP/PGBalK5T/1EGn5yKP77vFMBwOCC8qWxBL3pHPHzAvjR1BIHZ/JXkoRd2T/CfTkS+6n9Bp6BwWopjf3KPC3LkVT74eLZGFwYhvxSUkyh50HGzk/Vd+NOIs8U06khUXDtnrQKh8nVVjtYtHNC4r48HiBf8zdjaKnolFadlNXCGpnMQdM+EImD6SmsbWIJEOAZw9weo5qwIx2GPDa3w1Hw6h8SzcDydjed8+8311ZfzQjs5t9oOzvwMDpkvrdPUSbrwvrb/SiijOUU+Utsxvkoi+bZTi9XmbMJKPjL1sHFj6kFDEmiakBZ7HbbVTZfxuxtuWXVRnngz+t+YG8gLHa/8d5a9RJ5aCX8uANb/cJaADkB3JfUpdIeCuS2qquV6oHMVyiImsrF7gCdI7sqHqhg
 xqlrKKmh
 0ACZWUArvtYY9WtPOsD+w64K4LTnx3D+6W6o3GyU3Z3s6hMreDGR3MEPqk2hW4TYlaJpuCckoaX6d+SJSd3UO50LJhSbmQ9mmXdsSE4ftTx3m/vk9rN7gSQ/fqVUD5zl/oMuGGx22k622DNwwrxUKERoCXMlpyW8e/bBnq4uLNE/r4GnbGVeDVnojiNt7IHAFLryEem6Drrd4jK9+CC6aipDYWZmWXKwmhezodockaxdSpu4d/mdn0VPl3E5rFe3/XhNXkjDMcE/E9LFmVRr1vAB9EuC7FWGkO3qac4U9T9Eo5Fp98qLTJ1c+ECGyRvvwQl20e9OxfFo5iDVx1sm4Z4MnKHOl1ZoveJBxGJOnQIqH/TA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Is Hao's work needed for some followup work/development? The earliest Hao's
> > > work can is 7.3, so if we aim to figure out swap tiering interfaces in next
> > > couple of weeks then option 3 is the way to go. If swap tiers take more time
> > > then we can discuss other options as well.
> > > However I would need zswap folks (Yosry & Nhat) help in figuring out swap tiers
> > > interfaces. Zswap is the current top tier swap usage in real world. I want
> > > zswap users to eaily (and hopefully transparently) migrate to swap tiers.
> >
> > I am looking forward to the discussion on this interface!
> >
> > To help boost the discussion and progress, I would like to share a few of my thoughts.
> > We could either introduce a new interface to trigger demotion/promotion,
> > or we could reuse the existing one (using tier just internally)
> >
> > Based on the memcg interface currently proposed in swap_tier
> > (memory.swap.tiers, memory.swap.tiers.effective), I think it aligns well
> > with the current direction. It provides a foundation for selectively
> > targeting devices in tier order.
>
> Here instead of cpuset like interface, we may want more zswap like interface
> where you can put limit on the usage i.e. memory.swap.tier*.max. We can start
> with allowing only two values i.e. 0 and max which effectively will be the
> same as what you need.
>
> I will respond to your other points later when I have time.

If we will have one interface for all the tiers for memory tiering,
I'd rather we do the swap for swap tiering. So maybe
memory.swap.tiers.max or memory.swap.tiered max?

The file can show the limits for all tiers when read, and maybe write
something like "echo 'tierX max' > memory.swap.tiers.max" to it to set
a new limit. We can support only 0/max for now to enable/disable
tiers. In the future, we can also allow something like "auto" to
automatically scale the limit based on the swapfile size and
memory.swap.max, similar to the direction memory tiering is heading
in.

I think we can start with just this interface for now, and expand
incrementally. For proactive zswap writeback, we can add
memory.swap.tiers.demote or something, and only support zswap
initially?

