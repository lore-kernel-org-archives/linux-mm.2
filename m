Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD60C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 07:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75AF6B0092; Thu, 17 Sep 2026 03:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E0F6B0093; Thu, 17 Sep 2026 03:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9652E6B0095; Thu, 17 Sep 2026 03:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 752FD6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:39:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B134D8025C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:31:46 +0000 (UTC)
X-FDA: 85222434612.19.4AA56A9
Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1BB21140003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:31:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VGGe2Okk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789630305;
	b=hkhG0h5EnTggLt5lZlutro2PukHpDPnxzzOXX2j0ow1atHKNycz0Fhno69ykgmfk5wjzYe
	RYELQCjDlj+SitaHbtu8U0dZEEQKkLb3Ix76mtRdsir4L5LioSkyw7EnDZeAOJ7HpjC9FD
	n74oPv6eYKxS2mhrUZrkrxWF03jAuGE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VGGe2Okk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789630305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kN0UtpwVH9D192R0yffwdH4fiFrTTR0uqNb6qpzuKhQ=;
	b=RXbQo8561nfsKq8hc3Og+x60iYnCZnocPEFzok3CxYPymrLEubD3VLo3p2bbKYRRWFwsAE
	kHR1cs+E7j4tq0LUijM55v16dGMt1c+apQkLfbXRdTYBbJCFN4u7Sd7O7RsZ/GCM3ZD8F9
	plRTekzle+x2poqN5DorTYPNVwDavRU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aalPA+YRmodnwncx7vuTjRQb/Aq0fSpOz9DM5u9UYQE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789630301; v=1; x=1790235101;
 b=VGGe2OkkwZFMVJteJhrCvMXR99gdv0u1hvkTkLyGFq/NuwG5eoGydYh1ivz4rSOvmA4oy85l
 MVt7mlxXjhbB7Gv4HQMlugrD64qwDKyY7ppm9Gz3PwBkVzLcN/OmoHYWZNmqNg8vGhTZ5M/I+Rq
 gHMR4j0fdlwjHCt0/rjcHjg0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c1cd059ca47fcf9d;
	Thu, 17 Sep 2026 07:31:31 +0000
X-Mizu-Trace-ID: c1cd059ca47fcf9d
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 15:31:23 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Message-ID: <aquWKJoP5JLP8Ci7@fedora>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
 <aqrHjfHwyEtRIr5S@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrHjfHwyEtRIr5S@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1BB21140003
X-Stat-Signature: op6opy5zegeboa9afki893fydb5prpzj
X-HE-Tag: 1789630302-911040
X-HE-Meta: U2FsdGVkX1+EH3qQUbdjAR6JFQIWODZ8OGAfSVniX3ouBrYfYfw6pgon9YmtyOCskxoM340sbkW0m8YPe2C8TpUGnrcH6StCrZ9sgSLI1e7pI7GFS9JO5BHmFHklWq6c3KbQ76BS1pCNQBvDFD4YSomePg3ObOi7KHBszHqpaNpnp6/ujDdBt4lvwhH9y9PAVDCahpQKu+Ol/hZ4eRb5VFXUcwdivqNWzB0LFDcl8mQZQincfFV08tj8Hgi2j+3DSRvVi0SZtRfENy1hOflaRSy56Pqb36XJCI1zWRAW5M1mwKvvZXO5NEBC5Ph+Lz33bmsKiklzCYGcQOLg0abHhEdnbLBjfs1izIktQWgl915f4Ha1tvVcS6x9x04Hnwtk2jp6aIcM/61xWsTpdy6cjoyWxHSM0GLieTbvXbGnGvbQuVrxlN23QN6FApf0BEjP1Wqpegql9oGjS0/8Y8UPt5JeSUJ4XM/f7prbQGbjSJkmFARtUI2b8DEGaQQMYkuSt6DVD6jXwsfKwnORtIU9poDNVT7wlA73ZUWw+iRksiJ5vD3IviXOJNNIhtjOYS1k9uF0jICIvp8YbNFndnZXLcIIZyDriFWkr71JtvIVTaMPPinVYySmWBDH4l1+F0z1GAnJCHpAy2Mih7FPCvlpBtLs0qoGZ8ZJdTUqjWGOqJ/0Q/H7k95pRMM1BUFMptVvIPekvGN7cA/uRNAFP4F11Fdom5lggdCW5IhNwXlwNav8tDwCLGzTplxpN3z86+cyaWiMW2mHRFq/gnzUBz6tQ24Xcz7d3gZsDY4u6hVzYUmXV3OlwY9COMbtJCZ3SF4khhgu4sCbwKHKNXzjN87JefHz0iXpXirI7REd+AROZ0ea43DUq9WBtYMyWxUFFRidAJI1OeoriVXRADOP1hWxLlHkfaAv5KH1xDNFRq/JgT1PLW8LW5a+7voI0NLS//QCo2bw2MKFBWKmm5S/t2t
 2Uv45PbO
 J8TPGGvpBTkAYofAj/4EsQgAy/4sXsenpHNDbmHLFg4T66RGJln9jO3PCpb/CqlSnEMEQvpada5Ydvobj+/gIveL6nXHB8kr2wSeMhhbnM0+eupkyqXZthKqUtxBwt6Y+Y6aUZhdkqKEfUYiU2T21Fpmq+/qssWv4K9bkjVR+pDcDUmcWY4KBWjl5ibm037lgAF7jCH348uIt7if0ChrzRqaO1bbUhB4GrERCyuHt41Mbl89ct0e/1zlUxy5VnjsA4R86tquCKvS1X5klB/eVAOYHLXtNMMKvWMb4gj3Yj6Jfv9T07i//VZufdbpKQP4iZkuuY3iwiY/e0euCK8qyE756piRY5/xaYEdiBmUhQGOXdTVrBh/q/QFAWZe2yq2f2Njg9R9V8MSN/q44ya0+RYJD6NfxgA5odsqPfiqqmc8wPGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/16/26 at 12:45pm, Johannes Weiner wrote:
> On Wed, Sep 16, 2026 at 06:19:07PM +0800, Baoquan He wrote:
> > xswap is a swap device with no backing storage. Swapped-out pages live                                
> > in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,                                 
> > and the area is grown and shrunk on demand as swap usage changes.                                     
> >                                                                                                       
> > The problem being solved is the static size of compressed swap. Both   
> > zram and zswap need the size fixed in advance, and neither gives memory 
> > back when the workload shrinks. The solution should be a device whose
> > size can scale up/down as per usage. xswap does that by mapping the
> > metadata lazily instead of reserving it for the whole range.
> > 
> > Design   
> > ------                           
> > - si->cluster_info[] stays a plain array. Access is still
> >   &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branch, no 
> >   RCU discipline, no tear-down state machine, no NULL return.              
> > - Only an initial chunk is mapped at creation. The rest of the address     
> >   space is reserved, not allocated, so an idle device costs nothing.
> > - Growth is driven by allocation. When no free cluster is left and the       
> >   address space has room, the next chunk is mapped and added to the free  
> >   list. No userspace involvement.
> > - Shrink is driven by frees. The free tail is scanned, and whole chunks
> >   are unmapped once the mapped range is at most half in use and several
> >   chunks can go. One chunk is left mapped as slack, so the next                                       
> >   allocation does not map it straight back. A ceiling lowered below the                               
> >   mapped range skips the half-in-use rule and is enforced at once.
> 
> If the swap maintainers prefer the VM_SPARSE route, I'm happy to defer
> to them on that.
> 
> However, from the cgroup and zswap camp, two stipulations that I
> reasoned out in the other thread[1]:

> 
> 1. You must not charge compression space as swap space to the cgroup.

Hmm, I don't have a stance on this. However, isn't this an issue
zswap/zram have been doing? It feels like an independent issue which
should be done separately?

> 
> 2. You must make the compression space large enough to be outside the
>    range where users can hit space limits before hitting memory limits.

We may need a way to define 'large enough' at first. From my limited
understanding, take zstd (the best compression ratio) as an exmaple,
the ratio is about 30%, 2xRAM as si->max is enough. Unless we want to
swap to the backing disk with huge content which is much much bigger
than RAM when xswap is ful. I am wondering if there is a actual scenario 
and concrete number.

I am not against a large enough si->max size, that's very easy to change
in code, just one line of adjustment. Just a concrete number and reasonable
description is needed. I think this can be done later with a separate
patch with a convincing log if someone can provide?

static int xswap_create(int prio)
{ 
	...
        ram = totalram_pages();
        maxpages = min_t(unsigned long, ram * 2, swapfile_maximum_size);
	...
}

> 
>    That also means not allowing setups where this is possible.

And the limit is only an optional knob. If the admin does not set it,
the device grows to the full address space, so there is no space limit
to hit at all. It already behaves the way you want by default. The knob
is only for admins who want a ceiling, they can use it or not. I hope
this would not be a problem for your use case.                                                  

> 
>    I'm fine with fixing the zeroed page flood issue separately, as
>    Kairui proposed.
> 
> So if you're willing to fix the cgroup charging, and if you're willing
> to drop the sizing interface for a statically sized space that is
> sufficiently large, I think we can find common ground.

Thanks for the input, I am open to discuss either of them further.

> 
> [1] https://lore.kernel.org/linux-mm/aqLi6cIjD2wJwk0B@cmpxchg.org/
> 

