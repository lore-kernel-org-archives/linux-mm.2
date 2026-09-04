Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2B5C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F075C6B0092; Thu,  3 Sep 2026 23:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD196B0095; Thu,  3 Sep 2026 23:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A9C6B0096; Thu,  3 Sep 2026 23:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEFD6B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:34:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37467A0759
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:34:25 +0000 (UTC)
X-FDA: 85174662090.21.E01484C
Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D3E120003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:34:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SvgTWmyw;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788492863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqqhIIWR9gERM6HKhQbz+58rv03CIn19sTmlgK5AW/o=;
	b=vODuzm2TZeo+B3KB0UHrUMCYhi+GSjYX52LtCFQ5ggiBn2uFdjbbMr8Iv2hngLw32X8znx
	no6vgH1uzA41bVYpwvA9llJA9lpKvfM+S5tliGN6UmX0KtITVnZt+SpQJDzlTdccmEB0IB
	AfkPBhefv7N55Xovg0UHSJyQXWqmCAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788492863;
	b=sPfi9hKs+UHMSueKWUDe38mZDw+MmKE19OycajrMLbwTpDoFt/SEb5tyJerVc+YdD1VuH0
	JPiVVVFpN1aGvSk4SVuP+aqFhlPIuIlLFlH1/KCHsSjvauebm4vFXnoJ15SrtgHchh+keI
	f1z7WyNpje511qtVjaRhO+6KcavumAs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SvgTWmyw;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DzX2NTbsze0dSJnwYdpWB3c79mh2V1AmJ6cw5XBcxo4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788492861; v=1; x=1789097661;
 b=SvgTWmywf+U96HXGJDJ3SvcHNJr+nHqbZ2dxnXG9n/HJEjO5rIwLLaqifmDbTOIBiI3EaT6s
 xUybHAUNYf4qs+sfRKiK+azrT6t2XWdGufeC7DpaePbVTt/nJ/k02ek1XNHpNCaQXKHMfHNVFml
 uCsPYrt/AsXHaqAKpB+DaCu8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f11963f51e07d4f7;
	Fri, 04 Sep 2026 03:34:11 +0000
X-Mizu-Trace-ID: f11963f51e07d4f7
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 11:33:59 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, hannes@cmpxchg.org,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] xswap: extendable swap device backed by zswap
Message-ID: <apo8J72dWW0CoS82@fedora>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <apkjJo+g6ewvLy5+@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apkjJo+g6ewvLy5+@yjaykim-PowerEdge-T330>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D3E120003
X-Stat-Signature: u1pi5jgqykaq9xrbtbaa94xc7yt7sd6k
X-HE-Tag: 1788492862-578027
X-HE-Meta: U2FsdGVkX19I5XZLwj/ughNIpMgo1/dpzDIweHcdV0rBy42V5hRDcw9Y4m5PWup1REiJ9wl8env2Ehh7vFY+SisnM5w1NX2MZHYllbVymfr4F1LJVz4r83V1jsMYsxmv7HsjQEVhHk+PtdnFSoBTwcE3+uLE+eGQBXbnsvH/A4ivYiVakrV5+JL2TGriFY0bQCWWElNT15PrdNJJ7tHCsWBxikX/kEpX32kOJ9o94II3ulh1grnX3/UiVrMVxcqHfZOWKk6h4sD4MDmSq8Rvo9pSvWQpMssDCxQSTXHYI/ziIwXIJuQDdTciYqplZ0M4ai8hsmaib2oEQnDsWkR5ZnQ61uO0vP2Tldvldk+K41BkV3bs0CqPrJM0HnAsSweRT/0h2DG4jDnuY0Yfxxpy2PEbUeLDTCAAr/lpEIIdj2wUXqrOXCKaquQ10E3U6XFhV07JVvmceJpw7+gY+Oa4QrMKacBJlrcCGDCt0AtJTwfBusTJSJxgD8DzcrmEXjH69vU62tW9LS8a6CADJjpVqzG0ypL/bbEkmnZMeEdzC49Wt23Y9ACyUEDH/6LSo69ZK+HFiuP1nhEqgT5g5ZXmVmdXclwwFabmmqAbQoEvFvJv9R+h2QSMhnHVJsodozfJx0cRusKK03R8K1bZjBWhlIo3oMAxjj0YHNqOql09sUIxItPAEX3lgRSSraCTxcb237MLEy0t4muPmF0IL8d+PDJUzB6fEsoRLPSDDGweAkCBT6Z00QGEtYD0Ys99r3MV+in5/XHmDbSoVAlmTDQ/rzbIaRt712iTAPC6BSedciCfPkBiRTmddI+sXnFwIEz4UyquNea47ORN+TezNhv5vRFuRYu4jDFzVMACoxrkoEdeLkgxKA47XscCX+QycImy3TAxMqh/rwLvVZ87GfV+xFJHLUnS+3krnm2N/NCFPut1cis3dbs1yEJ4rBMcmdy7Ppry4Uf/YetpEbivU7R
 qfbp643i
 oNSMvQRMfWawDXuZQtfWmNYMn3znYHMB4209exEHZhbKy/FLVpjDNFyI8t0emG8yZSKovQA2SxNFqGuHSn2vzesagMEjEXxenGfu96gfiyx/WmToi+RGNvgHKOMrKC4ahhWiXv8yEsAVMuYa5aRlNgEVhctZhwS01qul2EPN2DKpYfmprHptNgsShbRtaUhujMdYamzzwYURUG6mBvwhrZg9qAu/0FzcaNE8RHA/GDhy7Eg2DcWIwF86gRwiFqWMXKEAmqpA9r/tMCi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/03/26 at 04:35pm, Youngjun Park wrote:
> On Thu, Aug 27, 2026 at 05:44:50PM +0800, Baoquan He wrote:
> > xswap is an extendable swap device with no backing storage. Swapped-out
> > pages live only in zswap, so the device wastes no disk space and its
> > size is independent of any physical device.
> > 
> > xswap decouples PTE swap entries from physical backing storage. The
> > cluster_info array is backed by a sparse vmalloc (VM_SPARSE) area that is
> > grown and shrunk on demand:
> > 
> > - Grow: when cluster allocation runs out of free clusters and the device
> >   is below its ceiling, more physical pages are mapped into the VM_SPARSE
> >   area and their clusters are added to the free list.
> > 
> > - Shrink: when contiguous free clusters accumulate at the tail of the
> >   mapped range (tracked in O(1) via nr_free_tail), they are unmapped and
> >   the backing pages freed.  Shrink is deferred to a workqueue to avoid
> >   lock recursion.
> > 
> > A per-device ceiling (nr_clusters) bounds growth and is adjustable at
> > runtime via debugfs.
> > 
> > Interface:
> > 
> >   /sys/kernel/mm/xswap/create           write "<percent> [<prio>]" to
> >                                         create a device; percent is a
> >                                         percent of RAM (0 for the default),
> >                                         prio is an optional swap priority
> >                                         (default DEF_SWAP_PRIO)
> 
> As discussed before, until there's a per-memcg tier concept, is there
> a meaningful use case for having more than one xswap device? Would it
> make sense to limit it to a single device for now, and add support
> for multiple devices later once that structure exists?

Hi Youngjun,

Thanks for careful checking and your question.

Here, I am also confused why both you and Nhat oppose per-device xswap.
Actually, supporting per-device xswap was part of Chris's original plan
and was designed for the swap tier. From my perspective, it's also a
very natural thing because the current swap code natively supports
per-device, and swap tier needs to use it anyway, so I don't bother
to add code to restrict it to single device. More importantly, for
per-device xswap, you can use one if you want, or multiple if you want
too, it won't prevent anyone from using a single xswap instance.

> 
> Also, if xswap accepts an explicit prio, xswap devices would need to
> stay grouped within the same tier. But a slow tier with a different
> priority range could end up sandwiched in between, or an xswap device
> could fall outside the priority range needed to belong to the same
> tier.
> 
> Could prio just be fixed instead? Is there a reason it needs to be
> assignable per device?

A good question. I haven't thought of a good way for xswap prio. Fixed
prio, or a high prio region for xswap? Zram is ram swap device too, it
shares the same prio setting semantics as a normal one. Can we keep it
as is, to leave it to xswap user?

Thanks
Baoquan

