Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85DF7E67A9E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C237B6B008C; Tue,  3 Mar 2026 09:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFAE46B00AE; Tue,  3 Mar 2026 09:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24646B00B1; Tue,  3 Mar 2026 09:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A28916B008C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:59:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DFEB88DD8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:59:16 +0000 (UTC)
X-FDA: 84505059912.12.5255442
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6BE44180004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:59:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mFuZEJ40;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772549954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzzRBFY4XpGoGT9xNiopMMRuAAFFoqywP6b/pmzvCT0=;
	b=MrcG4dCrlt4ivZto+XzAvcP/ZoZvNJ7r1lWKL/fqtPC5ZTgRLMPc/2BzwCQoKtyJ284ErS
	q7Un7+c5BJD2oodzDSUiYoxKXaJ4TmgKUnF9ULEAdt2GokrFUCBpIHwWaLXcx+KQIlLdX7
	5aoMEWS+VTrZwnk4jDKL1/JM7lq4Gno=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mFuZEJ40;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772549954; a=rsa-sha256;
	cv=none;
	b=7mxFN7/WFAqp4PZ1Cg0wbFK201zYGNXyhRIkiXbv49tHwhAsSMPPVTDxy6leebpniXmdGj
	3CUX0WkB9nkijcA50I332WpoMp5sVb8Kb99PD1k0Qb0Pz6Q3l9ETT1BlX4vA4NQYCBE+EA
	pyOSV2d3b+id2yi6LodDGJUKux0XDhE=
Date: Tue, 3 Mar 2026 06:59:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772549951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LzzRBFY4XpGoGT9xNiopMMRuAAFFoqywP6b/pmzvCT0=;
	b=mFuZEJ40pKY9dBp8jvbCyRxSoBDKPYlDZPoxXtHml753XhNsEB1+BHk4z/zASW7oSWSXBh
	o0ZGKNEl53FiGxD372/ksHrfRAcq3fZleJC3Jntw6vxaLZPrRHKZGvDRjmLWZNoeA4Frda
	x/lt3ZWUs6RcXWVLrqeFOM7M0CqrKGc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>, roman.gushchin@linux.dev
Subject: Re: [RFC PATCH 0/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
Message-ID: <aab0AFAgAzBi4jO6@linux.dev>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303115358.1323188-1-matt@readmodwrite.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6BE44180004
X-Stat-Signature: et4i9kph59hwy3q8h5f6ak97q36edi7j
X-Rspam-User: 
X-HE-Tag: 1772549954-135230
X-HE-Meta: U2FsdGVkX1+pzONuXRihBs0l/mMg7uHXDA/XG2HhaoCwk4MN68Ym4MO7kWZpQimiDI7dPZpqypgb/qoFW00sBW5ZL9hkfE/AT9CBaJjsFthtKFrIvsRjLVY0yz/62GymkfEYUAY1XAoVtIclblvsusXS19rGn2zKEAlT5QC6WxyWBTSURjYEojLK+iDzX6urVBmLFmeMhEFY7ElDkhffcX4N2q3WKFhzNN484ETS048C1RBPNdrd5dCIj9EtKHJmGkdgOa9huulvgapG2bJLvT3Z1LXd0G80cppQSMFCQCYVDf1zEInPzqvwcw5p1vRd2r+AG1pN+7e1tqMpYAyG6DEcoZjxAJ78PFJru6jgwZcs8QKE+Wr6CycVCz+SduTMci5KP0DqbW2vp5kWqdslG9quc0TFXsuraZ0IL7opOkvCl2aJKRO7r3WK/c1ZS2SyUxd2A3cZURbfVfQ3Dzyqqd5GCk/iznxCfcIsChqmMwQ10j/8FLSeeMcI/YXTuLJq766UtfApEcxtEpjNI1I6zrbwfsQHkPaLBjLj7ZhW4FYUpCIshWazXEl8njOItfsoqZwNLM2VgdJbGK/1CDsRUFixjVsE2WLe1nweQgBuqXb26GHKoanedBUqYfWyMKh/QFxzLappu0Xz6OmDwQoMWJP3VoBsJ35yJMm4sva0SAJynELHGC2W4y9S/EdPTl+czeHZTVQ+U7IeCtX6f+tqnvKoCj34RIp2ni9tsnZKamfqH9eUhZx8StEpuUGc/KVHexMJAA4lFt8tZWSg3mFHkZwNUzrb9yy1XiCRy9G9LeDVYUv2Gew1LzL8bALVWkGFfvwUOKYaXeIJr5lQwuyXng02JgB3W22gblaT/GFTxzdYs0IXzWWsTnV+CK+4QUIlMaMup//sNWTWVQON/c66RSpsuVR0od1FrlxE2/T27gpMew02mm+ddR39RSpE9ibKNkmKNcvnzV99EYstuo9
 /L9t4qdl
 TKHnXIei1TxmLjZBjr5oOb+8uHuKnRkZFutdlG/yOS8lwB+Kfq4bwiSjstFi53zFwLbUo17u3YLafNCbsEcMnHkPdqR0tpPnVRVyGA7Wr5xA04n0kFxzVbBuYHjLnzN32sneMZummGqPwdfjvkViWG4bnDZeP2fv+8Cpv0Qi8JHJxaSrGBLoaXo+9WQtZo+qE+/Y94+CqjmyNaWsrpI9+qkPCUJVWvBPyRUDRM2Gn7jmkmJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matt,

Thanks for the report and one request I have is to avoid cover letter for a
single patch to avoid partitioning the discussion.

On Tue, Mar 03, 2026 at 11:53:57AM +0000, Matt Fleming wrote:
> From: Matt Fleming <mfleming@cloudflare.com>
> 
> Hi,
> 
> Systems with zram-only swap can spin in direct reclaim for 20-30
> minutes without ever invoking the OOM killer. We've hit this repeatedly
> in production on machines with 377 GiB RAM and a 377 GiB zram device.
> 

Have you tried zswap and if you see similar issues with zswap?

> The problem
> -----------
> 
> should_reclaim_retry() calls zone_reclaimable_pages() to estimate how
> much memory is still reclaimable. That estimate includes anonymous
> pages, on the assumption that swapping them out frees physical pages.
> 
> With disk-backed swap, that's true -- writing a page to disk frees a
> page of RAM, and SwapFree accurately reflects how many more pages can
> be written. With zram, the free slot count is inaccurate. A 377 GiB
> zram device with 10% used reports ~340 GiB of free swap slots, but
> filling those slots requires physical RAM that the system doesn't have
> -- that's why it's in direct reclaim in the first place.
> 
> The reclaimable estimate is off by orders of magnitude.
> 

Over the time we (kernel MM community) have implicitly decided to keep the
kernel oom-killer very conservative as adding more heuristics in the reclaim/oom
path makes the kernel more unreliable and punt the aggressiveness of oom-killing
to the userspace as a policy. All major Linux deployments have started using
userspace oom-killers like systemd-oomd, Android's LMKD, fb-oomd or some
internal alternatives. That provides more flexibility to define the
aggressiveness of oom-killing based on your business needs.

Though userspace oom-killers are prone to reliability issues (oom-killer getting
stuck in reclaim or not getting enough CPU), so we (Roman) are working on adding
support for BPF based oom-killer where wen think we can do oom policies more
reliably.

Anyways, I am wondering if you have tried systemd-oomd or some userspace
alternative. If you are interested in BPF oom-killer, we can help with that as
well.

thanks,
Shakeel

