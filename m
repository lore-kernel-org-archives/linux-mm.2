Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A326CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 01:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F476B008C; Wed, 17 Jun 2026 21:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326E16B0092; Wed, 17 Jun 2026 21:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264136B0093; Wed, 17 Jun 2026 21:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEACA6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:48:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7171A165212
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:48:00 +0000 (UTC)
X-FDA: 84891347520.07.AA6EA35
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8D2531C0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:47:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781747278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fr3bhMRvsw9Lt6Y8DjrtChtVaZ44fdJhMV6movsjpdM=;
	b=NTBMSKj7R+/ONIiaImiMQwgPSlGd8k68/JCDhDvs9YnuU+wdsC/xUjWlngpZnon3Ck9iKL
	dD86VRwYA3I+un4J+JJq/HrEbdY6lUsSmYa52jdxTOhUhNHWs5oEFhSUVeXMqpECHxa6zJ
	UUIzJHKzKo8PjBAZ5KbAXWGfX2fAtNc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781747278;
	b=0SCvPcjPaGWr0Sb7nm4H7wCZRL2IGiYYvSPvID5Fn+jpsdfXcBuHbrcKnC/Jml6n1vQLyt
	zqdwntOPHZpGE6Q4RyqIQoWh8Aiwy2v6kkxHt9FkSpyDdI5nT8HtdX42mb9AGcLDbgZ7gK
	0KxHdH/hjx8YUzlfhfHqwdcyJTrA4PU=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 18 Jun 2026 10:47:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 18 Jun 2026 10:47:53 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com,
	mkoutny@suse.com, baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v8 0/4] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <ajNOSesjwTyZc8EX@yjaykim-PowerEdge-T330>
References: <20260617053447.2831896-1-youngjun.park@lge.com>
 <CAKEwX=NfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnnr6J6PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=NfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnnr6J6PQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6nyja7yx9u63y5uo5mynfdgeg856b8mz
X-Rspamd-Queue-Id: 8D2531C0005
X-HE-Tag: 1781747277-461058
X-HE-Meta: U2FsdGVkX1+i6ojawWW+0gvimIhwrYqyqHMVsWIFD7oMtIh/KfPJAjSWVS2O617SK90qR14ZB91GbjpFk54k+AOLE8SurSKZyse/wFtpm1aotDPZjQFPJN99vF+h+2xJoSbPLFlr1FnwdGMc8NVc6bC77xsQvFb1a37RnmWQgYDlAmqYkCX5Q1If2GAOrjyj/dfcPWxYXNb+jX3CpvGdpmAKVs7DCq+31/0jY/LvObyrjoG6O8jLAkWJ6rrQAb06jW408OsMFuA6WpRCFRYQnQiDAHWDhoyeGw3RSSBr8UY9YC+QjgvsIZdR8QviOnrhXRgnxtm0B17pYVwWpGIQD+8JkMU7rSkjvxOHF3Xl9pLNXQiPnuaTju8FzW/N+5ei/+EHD+aqT0F/qiqhP5bivhL5yMPmHKaWEmyZ4pOWJWfjGvl1/D4wU/HAZnam1tVgMOYvvBg9xs5IVmwyF+9ju4pEkiXjjs5L2u+CsrmSA8ZJOKob6xGvW5oruiU/gaiPh1XZSw59CLexJDAgVV5LJONX3mumrw/KM99tdUatvzY0YoIKVEQNUcuTGfJ8H9NZlpxYBoVdVt/y5LJNRDxxIOLCXYOvlEBLMTnOfdYc/nEl4GuuAjn9ecggswRegHXBZRDzefP4rvpKpNUwxQO2kym31PfYZqx/xXhTUZv2d+BilMR0s/goLrE/DZUYzmrmTlMlG2YFzROoDYKwW8GaHPzlhrBVMqMQ9chS3FDay9g0VNL4GJeJ+UnwmpfazSejrn9a1qHfTSw+hGzxrbSnE0m3Oxksaln7u1eAEFg8PX9eKe5M7CZs08/ONOWCKiZCsyBYJMBGILXkjoTFIYk6nYHh1oNQc2v6a381iXIJkhh3Z3GwYqRRQPDTUZx5rgCAL5tLfJXk2TfxOiOLohKRIU1lNQILNYq7cbPkaunvJZRYKLKv/DP5b1+oH9Xnl0NJRlRKKMCZQtxoAUfkSRd
 lf5Gutzb
 pBIYkilfm5FHkP63+uv0+41wGV37HjmXHne8Vh1JpDg+o2jK6WcxGVBr+cXQr+yxA+0QK3LV9E9z4qD4ca1ggEclAESqodz0Hd9lrAXTzHBbKjN0c29x1ZR8p5wgQ4/SGSZWaEJdUmhX4aVoAabu+rqXtGhc8mAxUqfl7mmOqvOvKCZoYaXHaNX6SnVsfYsCARITgvFGbsW8mvcgDLWK+G8IY7oLolJVgrbdHn3xSs5rjP6lkfXep/DpJQXFW4Qm0iN9TW3h2iwyzdRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 01:50:49PM -0400, Nhat Pham wrote:

> On Wed, Jun 17, 2026 at 1:34 AM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > This is the v8 series of the swap tier patchset.
> >
> > Great thanks to Shakeel Butt and Yosry for the reviews and discussions [1].
> > The main change in this version is the interface change to use
> > memory.swap.tiers.max with '0' (disable) and 'max' (enable) values.
> > This mechanism was suggested by Shakeel and Yosry
> 
> I like this interface too :)

Good to hear. Now it looks like we have found a memcg interface that
aligns well with the existing memcg model.

I like this idea as well. Thanks again to Shakeel Butt and Yosry.

> > Here is a brief summary of our tentative conclusions. Please correct me
> > if anything is misrepresented (details in references):
> >
> > * Zswap tiering [2]:
> >   Tiering applies only to the vswap + zswap combo. Zswap itself will
> >   not be tiered, as the current architecture requires a physical device
> >   for zswap allocation.
> 
> I think Yosry wants zswap as a tier, right?
> 
> Just that without vswap, maybe don't allow it to be an tier of itself?

With the current architecture, users cannot dynamically specify zswap as
a tier, and zswap is a separate layer, so it is not tiered by itself.

Once your vswap work lands, I think we can make the zswap 
become the default, top-level tier.

After that, we can also look into cleaning up the zswap.writeback
interface together.

> #2: Inter-tier promotion and demotion:
>   Promotion and demotion apply between tiers, not within a single
>   tier. The current interface defines only tier assignment; it does
>   not yet define when or how pages move between tiers. Two triggering
>   models are possible:
>
> >   (a) User-triggered: userspace explicitly initiates migration between
> >       tiers (e.g. via a new interface or existing move_pages semantics).
> >   (b) Kernel-triggered: the kernel moves pages between tiers at
> >       appropriate points such as reclaim or refault.
> 
> We'll likely need some kernel-triggered mechanism, or we'd have LRU inversion :)
> 
> Cold pages will fill up fast tiers first, and more recent/warm pages
> will land on slow tiers...

Yeah, good point!

> We'll also need to enforce isolation/fairness to make sure no wordload
> hoard the fast tiers too (but that probably requires demotion
> support).

Right, that makes sense.

BTW, One thing I am curious about, though, is whether there are strong
real-world use cases that require demotion/promotion.
Theoretically, this looks useful but it would be helpful to better understand 
the requirements from such deployments.

> >
> > #3: Per-VMA, per-process swap and BPF:
> >   Not just for memcg based swap, possible to extend Per-VMA or per-process
> >   swap. Or we can use it as BPF program.
> >
> > #4: Zswap and vswap tiering:
> >   Tiering applies to the vswap + zswap combination.
> >
> > #5: Vswap on/off control:
> >   Currently not supported. If a strong use case arises where vswap needs
> >   to be controlled by memcg, the tier interface could be used for it.
> 
> +1.
> 
> Also, per-si/per-tier per-CPU allocation caching? :) Kairui already
> has a patch for it, IIUC, but if not it's pretty critical I'd say.

Yes, I missed it. Thank you for addressing it.
we need an implementation that integrates this with the per-CPU
allocation currently implemented on the vswap side.

If Kairui's patch lands, my patch #4 also can be optimized based on that.

> BTW, can we add some selftests, to make sure the new interface works
> as expected, and to have example programs for new users to model their
> scripts after? :)

Yes, I agree. I think selftests are necessary.

Do you want them to be introduced in this patchset, or would it be okay
to add them separately as follow-up work?

