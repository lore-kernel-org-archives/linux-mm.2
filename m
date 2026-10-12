Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51288CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157476B00A7; Mon, 12 Oct 2026 04:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108696B00A9; Mon, 12 Oct 2026 04:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E246B00AA; Mon, 12 Oct 2026 04:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2F606B00A7
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:25:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2ADA71C43D1
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:25:57 +0000 (UTC)
X-FDA: 85313291154.16.3A7ED8F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1583120006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:25:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rt2tBD+X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wO18hACz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rt2tBD+X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wO18hACz;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6vB1DNqF6otGL/B8stHx9KLEIOKxJvHsQqgauK/9Yw=;
	b=7JMScL85qchVYlYB6u4bd6BpPmA9KN3MaTDX0Bo2DekERUoNQrKmVBlDJ17/+q01KjZkHB
	Ns4kEAItUcVHK/omY7F3PwFaBWgKVjbXwhQNWfdFeOKkdjQxbgcSS/2GQht9MGgg0BfPM6
	eHXxEIl1t8RTUeLD7GqR8WQG+bhPSJc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793555;
	b=VdkBP6RIdrJcjHnyhO4/ge0EPRdQQMmXk7kXV9imJJX/MHf9eytHKHIW6P5XgnxLe169Yf
	gOlZjqLX2o2SZqZbI4oxSUSQ9NR+jc/TNjvJP2KuSqWwCWshCY5ds1nY2wbvLQW7KNIwLp
	AtEAAEHr3x3qC2k2+VNOiTEOtPciNTs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rt2tBD+X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wO18hACz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rt2tBD+X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wO18hACz;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 115ED21E43;
	Mon, 12 Oct 2026 08:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791793554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6vB1DNqF6otGL/B8stHx9KLEIOKxJvHsQqgauK/9Yw=;
	b=rt2tBD+Xsa4cegseukdkCql4FfWK4dibSELmlF8rG4mf5Q7RQlEIqmgarCitkRbhuk/NIB
	xcBfs8A0WzGm1dQXokBzHeH/Xn34FqT+Va/VqJ0GSzx1ggdYOu06wYLWBYVHhiGUb2NBx4
	6SH1TVz3MKVcZ0qE+iskXKFGeQgWnvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791793554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6vB1DNqF6otGL/B8stHx9KLEIOKxJvHsQqgauK/9Yw=;
	b=wO18hACzvjyI7bzQsXnrnRX/SIi8r8ZZrNbcv1uajklorQkjcD+JtbLYCigMfyhju2koEU
	5p1mGdTHJXttKtAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791793554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6vB1DNqF6otGL/B8stHx9KLEIOKxJvHsQqgauK/9Yw=;
	b=rt2tBD+Xsa4cegseukdkCql4FfWK4dibSELmlF8rG4mf5Q7RQlEIqmgarCitkRbhuk/NIB
	xcBfs8A0WzGm1dQXokBzHeH/Xn34FqT+Va/VqJ0GSzx1ggdYOu06wYLWBYVHhiGUb2NBx4
	6SH1TVz3MKVcZ0qE+iskXKFGeQgWnvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791793554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6vB1DNqF6otGL/B8stHx9KLEIOKxJvHsQqgauK/9Yw=;
	b=wO18hACzvjyI7bzQsXnrnRX/SIi8r8ZZrNbcv1uajklorQkjcD+JtbLYCigMfyhju2koEU
	5p1mGdTHJXttKtAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF56F13408;
	Mon, 12 Oct 2026 08:25:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WHyhH5CZzGpNIQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 12 Oct 2026 08:25:52 +0000
Date: Mon, 12 Oct 2026 09:25:50 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com, 
	riel@surriel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com
Subject: Re: [RFC NO CODE] [DISCUSSION] Anti-fragmenting ordered buddy
 allocator
Message-ID: <asyUgZVSauks3Vwd@pedro-suse.tail5790ac.ts.net>
References: <20261011215412.1181172-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011215412.1181172-1-dev.jain@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1583120006
X-Rspam-User: 
X-Stat-Signature: rk3fticaa4gnitt8xp5mde3pg3qpxee7
X-HE-Tag: 1791793554-163333
X-HE-Meta: U2FsdGVkX1+al5vSqx3voWi/sTZ4pmJIg9eUkFoapBUBFQ9Z/SY2+RtRm20Rrg9xKg7J/F2o3GqYearz5kjvaZYlXySDfm/wX58ld/czMOmHidV8kLgs+dW2kyBQSdsd0fFhgOYX3VZ/75CmXyKOVfmRvaMFjVi9Tq63L6oGn+ZcIeRQb5jPuE8nIOCbp91n5q58mxs+mS3xjsMVdgvsMleYQu4CQ8jy1Yc3M0xY8aPOd2iMiflps2IoD29H6pl6tR9/QSDJZUHy/uQG7vjyAZiW/5vzyn5vwo7EyRCj8Cv++0lYe45iH8UvfxutZTmu+c0uC6Cy+FsDJfvhhD+dX/3601GCFENMzg8k9fsznfXFqIM01KcwvUhIwY2A4JWAhkULWMiiIPv/hk6BtV02cvHtnNL73uEtSkSnTjkUZLWiD7Of+m8FFhlu9LSEbF0c6yqLlgGiGOj4vHbLMV2OKsRedmrN9eve7Jf/4guTedkOiTe/DzvIcHCdDzmnO0vV2kAQRk/RIFbQHJRQ4s2Cp/8ZN5QEzNSq6chrlh2CPgPerrXGmUiqsvfC25TjmHNn41S1/48PUg5D58a6LeqFxVRqlxZIW6n+fbyqr2bj7StWMjivgToFOKYRw/zr0L5a7bUaM8fH8cruSsVFPNBEPIslpseasRRAwr3Gv6Nz/70/p3KDuQsAFGD+5PLXDjzfvTA1nbzZk41ZWWycJGX/NIJ5tfLzvJjOClrxWK9unGfVGRenCWRhGHDDdW+8eCQeEUWCCeboB+e1NtYP4/IKekCcK1uan3K1wwxGaLLVkoz4AUTb9wjT9MzZJf4sKfBJCI82oEw6zdnR9zj4LLGz4+cPnWUYnH9pPR+PKwyqAmB4UM8KPz02UOOEkEzNHPFmCM/QVL0au13NXUzqDebBKxZ4ZhMKI10NEIRDGirmkm0yG6dA14OsgPx1DCAs2QUFLtSfzadWZTsgBa1s0wY
 UX/WiPxM
 p9fSB0iyh0tDbfLAN9J98m7/zYqzCV0IaOTPXK9PXFydkefzKq2bOkmSrJTGQHYZllXSbTKX/Biy+ZUTrclVIu1vFU2LvxbqgztKneqOlPHcVBevp/s2DXIeErMdYRgJuD9gc0l5926vLonOZd9ADp5yfqnd73fCN2hnRBcRzri78NVQqDZ6JPwUgzo8p0Pu6GNkPDVO8FXQRy1RaBhrOTSQOXp0FCapKA5NUDkldbRRG0OCyck/60OFwoo2HNdMl33YqIn4Ome5n44U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, Oct 11, 2026 at 09:54:11PM +0000, Dev Jain wrote:
> (I am not posting code yet since it is in experimental stage.)
> 
> TL;DR
> -------
> 
> I am proposing "ordered/bucketed buddy allocator": we divide the buddy
> freelists into buckets, and prefer lower buckets for allocation.
> This reduces external fragmentation (and, further reduces it when we
> reverse the ordering for unmovable and reclaimable allocations) at the
> cost of regressing the alloc and free paths, which depends on how many
> buckets you partition into. I think we can partition into 4 buckets and
> do some tricks to remove any regression.
> 
> Design 1 is the simplest and the most upstream-friendly method in terms of
> allocator speed. Design 2 tries to scale better with the number of buckets.
> 
> INTRODUCTION
> -------------
> 
> Apart from dividing the freelists between migratetypes, little attempt
> has been made to change the algorithm of the buddy itself to reduce
> external fragmentation proactively (termed as "anti-fragmentation" in
> academia). Linux has defragmentation (compaction). The analysis below
> is *not* to claim that compaction does a bad job; I just took up the
> challenge of anti-fragmentation (because I like to torture myself) and
> kept digging the rabbit hole.
> 
> There have been academic papers about replacing the buddy with bitmaps -
> I did not want a hard NAK from upstream at any attempt to do that, so
> I preserved the buddy freelists.

So, I've been looking at LLFree (one of those novel page allocators with
no buddy and just a bitmap) lately. A few thoughts:

LLFree basically divides memory into 2MB pageblocks (with a free pages
counter), and then later organizes these pageblocks into 64MB "tree roots".
These tree roots are then borrowed by each CPU and made local (pretty much
like old SLUB used to do). This localizes most of your allocations and
pretty much avoids conflicts/cross-talk across CPUs.

Yes, there is a bitmap. I don't think it's required, and it might actually
be misguided. The paper itself has other side-goals. One of them is easy
persistence in persistent DRAM; we don't need that. Another one is minimizing
the cache footprint of the page allocator; this is misguided (IMO) because
allocating pages has the side effect of you actually needing to initialize
the struct pages after the fact; whether the allocator core hangs state off
the struct page or not is not important, and in fact using struct page there
might provide cache benefits.

The bitmap does not work well for random order allocations.
The paper itself was written on Linux 6.0, which (probably) relied quite a
lot less on things like mTHP (and random-order file pages) than we do now.

In any case, this paper doesn't necessarily address your fragmentation
problems, but it does attempt to address fragmentation (and SMP performance)
through borrowing these pageblocks. I would not be surprised if it had
a sizeable (positive) impact in fragmentation. I firmly believe that a
direction similar to the buddy allocator, but with more buddy work pushed
to the pcpu side (like Johannes's pcp buddy allocator series) is there right
approach and could have a meaningful effect.

Of course, it doesn't solve other problems like lifetime mixing in allocations,
and things like slab migration are insanely complicated to pull off.
 

-- 
Pedro

