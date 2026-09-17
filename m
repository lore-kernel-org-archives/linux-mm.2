Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E2EC982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D626B008A; Thu, 17 Sep 2026 09:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5F96B008C; Thu, 17 Sep 2026 09:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3406B0092; Thu, 17 Sep 2026 09:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05CAD6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36E871C20B1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:17:20 +0000 (UTC)
X-FDA: 85223305440.18.51A495E
Received: from mail-qk2-f6.google.com (mail-qk2-f6.google.com [74.125.230.198])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25691C0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:17:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=SPIiRotB;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.198 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYiGnhlo+OU9YMA0gh1fz1xutnFRgnBy7GWsxB2kBCM=;
	b=s5BBQ5iQekop20NoumCsR9mIJItSw22unfmwvhF20b0/NCt9wwn3P4z7L/nAMSOQLwVeM5
	j90bfW/DOY/cRtm/FPJwMpjlxUAFX3i0VRmV8bznm6pZvGOHvRIE7sm5pQkALQrNHDXK84
	M+QIhQynOBAIRQRL/Lv75b1lDVE7Lho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651038;
	b=3pVYi27kKmhESTca4kdgjOz3SbeAO+uuPOpkN5Fhf3PBLgqTpmUlhIJsfoHNnEqe0FGKT+
	3YAPIAaCWXW0r2UlelZJ6qHVFx2pHMlyZqQWeoBg3jGg8UVHPErELCdBmRwcLhUz86a9Ya
	ciDgvtKWjm9cE79jCi6h++vBHM54rWM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=SPIiRotB;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.198 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk2-f6.google.com with SMTP id af79cd13be357-93a0da4df41so36872385a.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789651037; x=1790255837; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TYiGnhlo+OU9YMA0gh1fz1xutnFRgnBy7GWsxB2kBCM=;
        b=SPIiRotBtJ7t2Q79U6l+O04IMGtUmKxKc9/tLfAYE9L1CDbEcT8zPDUnQ9tDcscoc6
         BDvde4DH7DZqc7KL0O2aE8rwQ3ZN1VDwMbkNUsfXav8svd39FeD2/7uAtYsaYqAmaim6
         omms2enNvsJSbJHzQ1ppLsQT6bgBk93LDj2MaTVu9WAom7JJad1cFDOFsZtjG2mBts+v
         3CBoVLtaEB3kZ7Q6RBI80OVFdEMBHFW2Qis/veOK7PZyMZTdMqyBiDkuAOMXaWhmaGrN
         gm92jQ40qzssnKMWHb3r+fhjmpaTgZZ7c8LMGhg/NRXS88DCyrgSob3C9PEHeA+84XfW
         KP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651037; x=1790255837;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TYiGnhlo+OU9YMA0gh1fz1xutnFRgnBy7GWsxB2kBCM=;
        b=IrluB+TBIrlSahdX8qZ0ysEoFdQOAsecUYdc6/VgrYJK2CO+vtdwT9q87usqIeDwHi
         DZGO09HS7raxXV/ytg7p83veyTHPuvBaK/raSTJYieKrJWO5vfUZfE/aHpYrnbGR2kqy
         ED3j/s8ZTegb+HeSKFUmTaIED9cZnGSBUVAFAM2bg2JcJwbMKHB/3z7bBiw3i4DtQJdU
         NLorLKpY5Uuc0cYN1TiUgEzrareBXgkwdBBjjxB4U1hFTkrRyUuRC9mnrfBCm/q0LTb0
         HEMMZrVT0eTnNWHXK4gaRJ+96R9mTNwWNcs6RLpjczq0jaTiMroOFh5OtYYTeNI0RvAx
         613w==
X-Forwarded-Encrypted: i=1; AKwUvBwSs7EOFXFSHYMGmBbUsdcFRYcMVTWryB3X6XbRxdIOjoCfilKfQn+SCQvh+lqQH3kSTqdQBrByiw==@kvack.org
X-Gm-Message-State: AFuF++k5tFtMABgaqtyeBH8uy5AYNVZVauFTZ8LSzCaqAm+6XAEsVdgG
	BBzokdoj6qSt9sPKLPkM8MLeEk6QI2ubjBg889jE96QAjxShab+BUhnSsYS3Clp7xec=
X-Gm-Gg: AYBFou2vVWZZfxs+v+UAr4heG5T6PdEupIAuI6L5YVM+YPNq/7hbWtA60J5nvo6Td3m
	tBZqC8ylDeDkY/7anidra9QISN8ieOckzce6f1xzEccPSNGM/80KzNXz0zIv1oNAL7DqhECkEEY
	yOOk9xVRyq4UumRXYzHnZg2/Mi3LA0MRTRuijwHD81ZRFkp2EoV04V2cXBlopQOtTs3jChremar
	aExN772Dp4pGgoTZjAvWO9pRrJGVjzfeH28WoMbk/F9vnueFouyKdr/SiVs7XwEStnLAW4YzkS5
	ybWlEtbFOFreVFswCh21ujTlK5AGSVEfGScGoLB+84BtHqgPf8d1RMJy7YKvX7SSByrsyP9sgMI
	eDZS2ergy3mC8aiPOqXwLmeObm3n2K0Iu4YscTstab2oVrLf4hz6cgyKmEpBim6B6ymbROc88Up
	3SN8Lq4V2cCBZc8IuhIto+k8IR7n6rXRwi5zLcSDFGkn6HIARXYsLmhCHa2pPcN5uElw8f+A==
X-Received: by 2002:a05:620a:6406:b0:93b:d7a2:83cc with SMTP id af79cd13be357-93bd7a299f8mr48578585a.59.1789651037044;
        Thu, 17 Sep 2026 06:17:17 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:1f35:22b6:fe30:2a34])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b7821d231sm463905785a.21.2026.09.17.06.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:17:16 -0700 (PDT)
Date: Thu, 17 Sep 2026 09:17:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Message-ID: <20260917131712.GA1344@cmpxchg.org>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
 <aqrHjfHwyEtRIr5S@cmpxchg.org>
 <aquWKJoP5JLP8Ci7@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquWKJoP5JLP8Ci7@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 25691C0002
X-Stat-Signature: 4d6sxtg6jgaud8y7fgynquf8oxnnarwi
X-HE-Tag: 1789651038-272786
X-HE-Meta: U2FsdGVkX1/h3/5auGLRYJzgUPeDl5PVSxLjpMpg2dHCkgZEN+xs0htu20yPAg0/v7WtoymYC6F72qq4Bx+zdM/ARa7BeqmfZxEBPuErf44i8VVYVkH368339goefH1zkc6QeQEz5wO7Y+zt9/dov3H8ObfENASsJkrHYOpg0r6ySZG6CfpvCjmH0ECflxuaMRnScG3bgqY0M+Mpk0C5e9HaY0RXh1PDeOg4G6nQKc2DEh5v1mWUJtk9ZU1RPvnLv7kM/aY6fcbmfAtfDjm4TJrOIw9P6KlM6KGm58n98ksws7oFfS8Xb4AndspMyhtmIWduDzkMPT1aPl6yif5iI40PI4goVGsO264nAj96jYrS0+R7rcP3JGwo/R7ej8vaycIcPrcjza3a/XlGvPfcT7/IXcXPYhMxSouIRzIWZWxo0xFu7Ot2VgA+njwxd7J35GMuR+8g/eRXweN3rjjpG6hYcK06eHpSZUS5YGYxQANevhGcftoWRSOkKp01NyOcweU3YsgIrKyAbUNIXzMHJLdpsc/ThtTAp9EgSjsTjxo42AMkagLyt+hglmlLN6f40ZdcBZLxkrUHoqefJbk8sGrNPUoVQyQbuAIILZOJ3WOjQw+p406kF7Fo272rWi5SOPCqPGdRihZnETfJFC5xj2iVufRwQxA6GoUeMStO51EPgENfZyPV0rUFIf5ZAUHpevp4+mfgolOshwj162yHgMRvQWl7A23Q5mXrD9SrEHWpeSalU6aCorl4+ZCSBqOzfbKd1kfAZ8YH3E3XUkldEyWlmNIZCPWyoi/QAP3RIWHCmphtrx8Y3PzaMxTAh4vz1edYqbwfad4Q/cj/Ug7mdlq4UbPD/RlGcxwAQaPjZjYwXUFwqvAO8dM6i7QL4IXObbOzs/81WkrZ+T8IdDmnqs7GdKtWvXjftncMBOZP6qTIOuTP6I6FNqHmr/U1cLCuC7JzS1+jCoEX/GzNF77
 xuL7+nWk
 Ql4wOJ0uTyxeCHwALeYRl3NmZZyzrrwaRbzR3d11v0n7DjRTi9IoWq4Fs/TpxTrKXYqhHQzez5sx3SGI05H6OITy2oX/dfnYbboAWH0ZeEYOUjIAhNF86TQxvHYgkprVGtNhJiX0+AmXR9rNhBv0J9o1UdrAHbOmVF3r5lwBHj5z7/DTkK6aMUPT+8u4ylKSiaZNoT0SO/z9/OEI1d35XN3Nowg28LRxUN0DEgvPxAoK6/qytJyq/hOfnRCBvLQ+rDt8/dKklYyDZwZ9MYEZkocPUB9DW0xpQ6XPNSNhohbUgLRisflTBtSJWt5gRTjAcVjclR8iKjBLnNaxHASVsvXERHD26l6IeKXH80p7No6YnjKjglIGh4Otp5NSpc+lbB0Hrz+YuPv1dw+IM4qhMCLjr+WEz4taNiddzYg6TB5VkFkLXY7M87IzNY+toqQh94vYKMJ8FeGwx6Ywymwkw8tyxVye4Z3O9EYo9/E7CoH4QP8J8hnNBaukAH7hYABRvvZMfLP5gVz51TaEGNS0472Yh8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 03:31:23PM +0800, Baoquan He wrote:
> On 09/16/26 at 12:45pm, Johannes Weiner wrote:
> > On Wed, Sep 16, 2026 at 06:19:07PM +0800, Baoquan He wrote:
> > > xswap is a swap device with no backing storage. Swapped-out pages live                                
> > > in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,                                 
> > > and the area is grown and shrunk on demand as swap usage changes.                                     
> > >                                                                                                       
> > > The problem being solved is the static size of compressed swap. Both   
> > > zram and zswap need the size fixed in advance, and neither gives memory 
> > > back when the workload shrinks. The solution should be a device whose
> > > size can scale up/down as per usage. xswap does that by mapping the
> > > metadata lazily instead of reserving it for the whole range.
> > > 
> > > Design   
> > > ------                           
> > > - si->cluster_info[] stays a plain array. Access is still
> > >   &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branch, no 
> > >   RCU discipline, no tear-down state machine, no NULL return.              
> > > - Only an initial chunk is mapped at creation. The rest of the address     
> > >   space is reserved, not allocated, so an idle device costs nothing.
> > > - Growth is driven by allocation. When no free cluster is left and the       
> > >   address space has room, the next chunk is mapped and added to the free  
> > >   list. No userspace involvement.
> > > - Shrink is driven by frees. The free tail is scanned, and whole chunks
> > >   are unmapped once the mapped range is at most half in use and several
> > >   chunks can go. One chunk is left mapped as slack, so the next                                       
> > >   allocation does not map it straight back. A ceiling lowered below the                               
> > >   mapped range skips the half-in-use rule and is enforced at once.
> > 
> > If the swap maintainers prefer the VM_SPARSE route, I'm happy to defer
> > to them on that.
> > 
> > However, from the cgroup and zswap camp, two stipulations that I
> > reasoned out in the other thread[1]:
> 
> > 
> > 1. You must not charge compression space as swap space to the cgroup.
> 
> Hmm, I don't have a stance on this. However, isn't this an issue
> zswap/zram have been doing? It feels like an independent issue which
> should be done separately?

If you have 3 containers using compression space, and two of them have
writeback enabled to a shared swapfile, the memory.swap.* controls
need to work to manage fair access to that swapfile. They do not work
if compression space itself is conflated in.

Right now zswap entries actually consume physical swapfile space, even
before writeback. Charging the space is correct. But the whole point
is to decouple compression space from physical swap space.

This is not something that can be done later. It would be a dramatic
user-visible change to how the resource is categorized and managed.

> > 2. You must make the compression space large enough to be outside the
> >    range where users can hit space limits before hitting memory limits.
> 
> We may need a way to define 'large enough' at first.

I've tried to lay this out in the other thread, and highlighted the
usability issues that result from hitting compression space limits
prematurely. It's kind of your call whether you want to seriously
engage with this or not.

But ultimately it's your claim that a static size can be made to work,
so it's on you to make a convincing case.

> >    That also means not allowing setups where this is possible.
> 
> And the limit is only an optional knob. If the admin does not set it,
> the device grows to the full address space, so there is no space limit
> to hit at all. It already behaves the way you want by default. The knob
> is only for admins who want a ceiling, they can use it or not. I hope
> this would not be a problem for your use case.                                                  

No, I've laid this out already as well.

This isn't about "my" usecase. It's about designing a coherent
interface that works well with a large number of usecases, and other
pieces of kernel infrastructure commonly used in conjunction.

The other proposal in the room needs no such interface. The burden of
proof for adding one is on you.

> > [1] https://lore.kernel.org/linux-mm/aqLi6cIjD2wJwk0B@cmpxchg.org/

