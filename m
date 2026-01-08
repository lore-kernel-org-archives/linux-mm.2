Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1CAD185E7
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 11:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCFD6B0089; Thu,  8 Jan 2026 06:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A916B0092; Thu,  8 Jan 2026 06:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79FE86B0093; Thu,  8 Jan 2026 06:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE1A6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:58:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33CDA13B8CA
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:58:29 +0000 (UTC)
X-FDA: 84308649138.21.F151456
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id 34CD21C000D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:58:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hXrLYYwT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767873507; a=rsa-sha256;
	cv=none;
	b=VaXJ2rSd+3eRUEb07LIdvjHyjlDwcotWUJ5umI9UZLt/WEyj82Ce/nGrSUPUQgqntY1CHM
	BzxO+zULqJ9mL3V/pQzm8gUxv0iKks5NoQyhqWmN/4PhYsw1bOXpZSLcxITkX6l0f1nmPz
	fE4VjyfFxK07eyM9vq3/N9QSZQ2IuYs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hXrLYYwT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767873507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0m0duLtHTkYn6eVmR3FYjJRUqSe/1NoTjqwhsTnSDn4=;
	b=pQ8Vf5xnCjH8nQB1zlmH0tJRy6+TEJjuKE0MrV8R8zdcGi5Zhm+KNxJbBea6eCicxzsTfp
	zI6i1dnSwegr7s3gn63WiMN+HbJmQLiU3sXBqKQ/CpJrwfX0hF1OVrDpTF7DI/4ddfM0jj
	r2fxXrexaRdFmPYwQjGIBXkZnbZkPjQ=
Date: Thu, 8 Jan 2026 19:57:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767873504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0m0duLtHTkYn6eVmR3FYjJRUqSe/1NoTjqwhsTnSDn4=;
	b=hXrLYYwTptrwpyONDcA5ygx/VKWJnwg8tyeYPLPPeBnrpVYqmqkrK7o1wsDxwwLcfSZzJe
	8OAdxdWQgKCBXlFuuL/gbtJqft/mIHqLdOzY7cuPAQHwRrTM78y47kkDOC0Pgc67pRSEtN
	MeggUj29Bust2hNfTWVo+fBUu6i0Vf8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@gentwo.org, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, 
	surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH V5 8/8] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <he2zo2ct4zkv34iiakp7zjzgdbl2n7nj3w7c3dlldvegbs6vxd@zyqrpczadamc>
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-9-harry.yoo@oracle.com>
 <fgx3lapibabra4x7tewx55nuvxz235ruvm3agpprjbdcmt3rc6@h54ln5tfdssz>
 <aV9tnLlsecX8ukMv@hyeyoo>
 <7uiizca4ejiqw6zegjwmou5va4kw7na7wivy4kxebrju7dsdwo@5brr7vhwf5oh>
 <aV-Kn8vfyL5mnlJv@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV-Kn8vfyL5mnlJv@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 34CD21C000D
X-Rspamd-Server: rspam03
X-Stat-Signature: qne45xi7qie8ui56x7pj1zgpxhqbbes4
X-Rspam-User: 
X-HE-Tag: 1767873507-449931
X-HE-Meta: U2FsdGVkX18q/1xVY6cOlLjVFdpUkAsHHGjZA6kcjY+wfew5d2F2tXvFyqqdey7o8ejZPJh5Ecoy5TFOiGlV31gh88ZHeF1juhxg5KADh7Vroh0SCixSj2a/hknC2qDgaFBJYQiNHdHERDjZjZQv0DMCnY/YcHuvCbdaEOwD/4O6BW+BkfS+A94GxgTTp7C7/vJI89BnAmjR2DBUxn357R5VfqyYuBWPY2gSnyRvwyqLNUP+jg7B4vOYGSQAvvDKn1fhZXggSHpBbYnRi6QlcwJSsdCGpAPiIqcxC+pgv46apCadLnhmK28tqdW6iy6s4pRHRapP5+z47xw3hENcZ8oqbjaSAQev0vSWv0Ifn6y1lt6MmHy87k/BfTzeM8iAXvZCBsXb8SVbHBuW+corlYp1mGVr7FpYpyeV8NtM7q/Kn8qrVEO7PLK8hq7uD61/mCIXbhRlXCV8zOacWvm4wM0I9fE/5m65ZNmHop3icYBbn4xZt//hasbhMw3e9Nx0Dwzo7pm2pxmYXgccjzqPCmi0DbqjJlN0UB6W4ejDTIlVws9RMLAOU1nhIX9ls1Dr902cLlYqPGm5l57DBNhsHAapLEtS8trHCnZyJntMFf2f6xqxrKR9zKticgxNNw5GzqHNwwxEl5RSbkm3Bnfs/QRge9PZ0Gwln49glVwf7kAhNsJvz7lECAzADVdhYFaS0Vx9LmGkIrHi0Bqisb2y2NFcnpIY+y+jSTawl6RCmSQ/HFdXtH8VAC8HsuoYs95S9zsm08TeWeQAXcxKBTMtBcvYcQmiTZWzrAbDTzpycLIu9uIKvNuscGI0yxHdpcD/+3r77cBz9n61MyAQVhUXUEjhrFuggGLamkDAf4G4lsGEFi/MCq+BTwRmqGOsZ/1YTxvg7Y62Faphum5brPnY54bjVY5AmrQdtz1zTkL8ywXYDM/ayoj7TVxEDavw7YGY4Dp3xjO+hRGsoyxTZhz
 MeVsQSue
 AYRB9gYpSkaRVsKTkBayOk/VheIM1Pb20raR2TNVDCHjP3SqPWTHw8GeHUprakOXZ3s1t6+vAkYnjlP5r0sltwRZVj0IQeH9AL3GxwjvQrSinWFIPf9knDdh0iibjB5+xSaa638tcQUNzUInX6ezd2hTpzESUM3OrDzv4Sd+F2anxFgLJoIY8EfG1ZcVSs4mXR7oqlN04+a+aB0ljzSO7g5wSh6Zd2X92VFTcrNM74yQNyv8nN97XCtvw4Pk8rRpiZ+hc5AE9Vvk0z1xrjz7HuFmX8GvSZC22IszgFie2EnIp4yC1CAIFtDendiCGSN1ExX/1QlRUMbaAxQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 07:44:47PM +0900, Harry Yoo wrote:
> On Thu, Jan 08, 2026 at 05:52:27PM +0800, Hao Li wrote:
> > On Thu, Jan 08, 2026 at 05:41:00PM +0900, Harry Yoo wrote:
> > > On Thu, Jan 08, 2026 at 01:52:09PM +0800, Hao Li wrote:
> > > > On Mon, Jan 05, 2026 at 05:02:30PM +0900, Harry Yoo wrote:
> > > > > When a cache has high s->align value and s->object_size is not aligned
> > > > > to it, each object ends up with some unused space because of alignment.
> > > > > If this wasted space is big enough, we can use it to store the
> > > > > slabobj_ext metadata instead of wasting it.
> > > > 
> > > > Hi, Harry,
> > > 
> > > Hi Hao,
> > > 
> > > > When we save obj_ext in s->size space, it seems that slab_ksize() might
> > > > be missing the corresponding handling.
> > > 
> > > Oops.
> > > 
> > > > It still returns s->size, which could cause callers of slab_ksize()
> > > > to see unexpected data (i.e. obj_ext), or even overwrite the obj_ext data.
> > > 
> > > Yes indeed.
> > > Great point, thanks!
> > > 
> > > I'll fix it by checking if the slab has obj_exts within the object
> > > layout and returning s->object_size if so.
> > 
> > Makes sense - I think there's one more nuance worth capturing.
> > slab_ksize() seems to compute the maximum safe size by applying layout
> > constraints from most-restrictive to least-restrictive:
> > redzones/poison/KASAN clamp it to object_size, tail metadata
> > (SLAB_TYPESAFE_BY_RCU / SLAB_STORE_USER) clamps it to inuse, and only
> > when nothing metadata lives does it return s->size.
> 
> Waaaait, SLAB_TYPESAFE_BY_RCU isn't the only case where we put freelist
> pointer after the object.
> 
> What about caches with constructor?
> We do place it after object, but slab_ksize() may return s->size? 

That's a really good question - thanks for calling it out. I took
another look at the code, and the comment for ksize() notes that it's
only meant to be used with kmalloc()-family allocations; those objects
don't have a ctor pointer. So as long as callers stick to that contract,
I think we should be fine and don't need to worry too much about this
case.

-- 
Thanks,
Hao

