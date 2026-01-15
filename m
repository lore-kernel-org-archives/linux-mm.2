Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D825CD46600
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3212F6B0088; Thu, 15 Jan 2026 11:55:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4B76B008A; Thu, 15 Jan 2026 11:55:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3AB6B008C; Thu, 15 Jan 2026 11:55:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 030236B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:55:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5D6013AD6F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:55:43 +0000 (UTC)
X-FDA: 84334799766.04.660B709
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 90AF640008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:55:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OkCmGmZT;
	spf=pass (imf12.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768496142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oN0TuaNOYXt16rCu+jFV5kzSUAKS5IS1k0m12m1o9aA=;
	b=gOIOk6/psWqNXKux1NKD1Uzva0LBCzF0AyLhw51pLBDjfhzaNFag9dJDqXq2kg3ZztX+jP
	dMfuVOu9JRgbCKHxvlh3b9YDFMu9bviwgsTZkr9vfKUYuHuMEfRnZzOPVqZzde+sDCy2V0
	TZbBODnSOubTzas0W9JyrzJdJBWLhIE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OkCmGmZT;
	spf=pass (imf12.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768496142; a=rsa-sha256;
	cv=none;
	b=Y6uhHJth7U3+kq6phM/9jJC3beGz5WzLe9sgaDs+ZAUitaB/IviJ9CayH98HiKjMmDDKBU
	DlO5HIrGXRP+sejpknQXd0ifCe/yPODrksn8JYki9Knu4YDcgZ0tLwuv/R831JidF16OtQ
	i9pO7mTXhQ++b7EN7Fuy8NTwzIUvrrY=
Date: Thu, 15 Jan 2026 16:55:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768496138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oN0TuaNOYXt16rCu+jFV5kzSUAKS5IS1k0m12m1o9aA=;
	b=OkCmGmZTlnLaXdUsV+HoNugWY3ZhFbdWednaJHtUzZ1vPpgYt21cQJubRfzCCYlcKC/B+6
	7B0kXUT18tvaZ/7o/q+dIgKTf2MKrNG5GPlQs0MKcv1mOfmD7Md5NF3K4sREyoozvSzTlV
	FkEqH9n+WmZgm82NA56jWhAADHzOb9E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org, rafael@kernel.org, 
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com, 
	ira.weiny@intel.com, dan.j.williams@intel.com, akpm@linux-foundation.org, 
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	ziy@nvidia.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, 
	rientjes@google.com, shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	osalvador@suse.de, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <fkxcxh4eilncsbtwt7jmuiaxrfvuidlnbovesa6m7eoif5tmxc@r34c5zy4nr4y>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
 <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
 <aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 90AF640008
X-Stat-Signature: js59nwqc77utw9ibeajiegm481jpbghx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768496141-369194
X-HE-Meta: U2FsdGVkX1/WK95MdTfqaE10nVEfFhm0fWcBluPUKA+jxuwKkqlOInuM/CiLYofAX7Xyq82pVVLASxDRT2L4L5Kzh6//xZxxrOLZVQZTH8UDVF/5LADiENIG6swqRNOY3NMyDXM6cdp8ASUuHBTdIbR+/pSgCceKO2VXP5EyAYw9YGFXnIWqb63Qnv6DQ2jLVS9Y4U0HvEa7GvthtcyXQ8Ow2KVf9QUA1sb/FDnRRSBTxGEtPvVpTmuxyOnVwZ8Sz2QvxsXwmYGX9n7eVVPXFpc5Vo3sbcsBJRnq7NSIUbVanCadRsLqia8YoaDiw4QOXcZo8lHYCzia2TQl9yg8TAjzQZIwoNZKZoRCDWS1Y4o/jgFsrJOA/tqPDmCFyllvqJlmWduAlwrJQEgsnr6VH+ACWTgNpMWNZgg9LHTFLoBiy0jXGHUoVf3ShqV6NcGjMPFabItlv/kuAsLY7bMtFW0xkMjqkashf6JSjw4w0e3h5DD3jdSjbq+avtsoKsNsphEzvY7K74ambv+WqLBRmIEpitwdGjmy6HH8CkmkSJW2nHytH4GIBPQDHw7ndm4A8e2GJC7uYyFFzF3YSt33GmcnvahQ1uZHHRLtOycMsh+UwtuDRcR+p2XCJePNa6J5cSyaiQePEMNHKZ9eTMLzfSkSyj25THRCZJQU6bMomXp/5GHdSo3F2xW1hNv5OKSX8g9JiTRtI+Nkfd5Eq9f70v73zEmIsky9KP7p4zSlzpWfJ/f3apD3XshRtuVqi/8OjMajMoGDKvHmR8F0dXWnl4gh2E223o8knKNp1DD+DN4ADhn125M72LYCUrYcIh9G5vlSc1S/lVPK78w6S6cnu7F7DdUfrmO7blZ8mb3hEbpuOWEJ0LVhsYHZGAkugI/NWqGzaZckAuNJGyEtx34Ay0d8SWlcYvVybambNYbwijz5uqWhavT6Pmf0A7Zhgic4Zlk9t3tMG9j5/lly99d
 b3affgmv
 TEc3T4Qr3DLns4WByub8b5YAzO+NEfTrcNf2SGfT0DcWZTVIZ8ZBY3Wd6gO00OvRSICJuI51pnE39sPkt1bCMttq60N0zt18L9V0iNYBmcMw9T+b/qZPdsBOGD3k6YOvkD3+N2J54lxcY5MshRKE0YOd9KKGPsIGMAeeglW4oCZcZyQSEvy2xcf9fVaDc6/08AjMSRcC0kjQIqsAiKw8Z2pEJPSVjpPftGj/K/ycofc3zuLPZz8Vhw4nZOZBkZeRVO9F+uGvnV7vUrbaGuKnzRhOb8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 06:33:16PM -0500, Gregory Price wrote:
> On Mon, Jan 12, 2026 at 09:13:26PM +0000, Yosry Ahmed wrote:
> > On Fri, Jan 09, 2026 at 04:40:08PM -0500, Gregory Price wrote:
> > > On Fri, Jan 09, 2026 at 04:00:00PM +0000, Yosry Ahmed wrote:
> > > > On Thu, Jan 08, 2026 at 03:37:54PM -0500, Gregory Price wrote:
> > > 
> > > Hardware Says : 8GB
> > > Hardware Has  : 1GB
> > > Node Capacity : 8GB
> > > 
> > > The capacity numbers are static.  Even with hotplug, they must be
> > > considered static - because the runtime compression ratio can change.
> > > 
> > > If the device fails to achieve a 4:1 compression ratio, and real usage
> > > starts to exceed real capacity - the system will fail.
> > > (dropped writes, poisons, machine checks, etc).
> > > 
> > > We can mitigate this with strong write-controls and querying the device
> > > for compression ratio data prior to actually migrating a page. 
> > 
> > I am a little bit confused about this. Why do we only need to query the
> > device before migrating the page?
> >
> 
> Because there is no other interposition point at which we could.
> Everything is memory semantic - it reduces to memcpy().
> 
> The actual question you're asking is "What happens if we write the page
> and we're out of memory?"
> 
> The answer is:  The page gets poisoned and the write gets dropped.
> 
> That's it.  The writer does not get notified.  The next reader of that
> memory will hit POISON and the failure process will happen (MCE or
> SIGBUS, essentially).
> 
> > Are we checking if the device has enough memory for the worst case
> > scenario (i.e. PAGE_SIZE)?
> > 
> > Or are we checking if the device can compress this specific page and
> > checking if it can compress it and store it? This seems like it could be
> > racy and there might be some throwaway work.
> > 
> 
> We essentially need to capture the current compression ratio and
> real-usage to determine whether there's another page available.
> 
> It is definitely racey, and the best we can do is set reasonable
> real-memory-usage limits to prevent ever finding ourselves in that
> scenario.  That most likely means requiring the hardware send an
> interrupt when usage and/or ratio hit some threshhold and setting a
> "NO ALLOCATION ALLOWED" bit.
> 
> But in software we can also try to query/track this as well, but we may
> not be able to query the device at allocation time (or at least that
> would be horribly non-performant).
> 
> So yeah, it's racy.

Yeah I think we should track it in software if possible to completely
avoid the poison scenario you describe above. Relying on setting a
reasonable limit and a certain compression ratio doesn't sound too
comforting.

> 
> > I guess my question is: why not just give the page to the device and get
> > either: successfully compressed and stored OR failed?
> > 
> 
> Yeah this is what I meant by this whole thing being sunk into the
> callback.  I think that's reasonable.
> 
> > Another question, can the device or driver be configured such that we
> > reject pages that compress poorly to avoid wasting memory and BW on the
> > device for little savings?
> > 
> 
> Memory semantics :]
> 
> memcpy(dst, src) -> no indication of compression ratio

Right..

> 
> > > on *write* access:
> > > - promote to real page
> > > - clean up the compressed page
> > 
> > This makes sense. I am assuming the main benefit of zswap.c over cram.c
> > in this scenario is limiting read accesses as well.
> >
> 
> For the first go, yeah.  A cram.c would need special page table handling
> bits that will take a while to get right.  We can make use of the
> hardware differently in the meantime.

Makes sense.

I just want to point out that using compressed memory with zswap doesn't
buy us much in terms of reclaim latency, so the main goal here is just
saving memory on the top tier, not improving performance, right?

> 
> > > --- assuming there isn't a way and we have to deal with fuzzy math ---
> > > 
> > > The goal should definitely be to leave the charging statistics the same
> > > from the perspective of services - i.e zswap should charge a whole page,
> > > because according to the OS it just used a whole page.
> > > 
> > > What this would mean is memcg would have to work with fuzzy data.
> > > If 1GB is charged and the compression ratio is 4:1, reclaim should
> > > operate (by way of callback) like it has used 256MB.
> > > 
> > > I think this is the best you can do without tracking individual pages.
> > 
> > This part needs more thought. Zswap cannot charge a full page because
> > then from the memcg perspective reclaim is not making any progress.
> > OTOH, as you mention, from the system perspective we just consumed a
> > full page, so not charging that would be inconsistent.
> > 
> > This is not a zswap-specific thing though, even with cram.c we have to
> > figure out how to charge memory on the compressed node to the memcg.
> > It's perhaps not as much of a problem as with zswap because we are not
> > dealing with reclaim not making progress.
> >
> > Maybe the memcg limits need to be "enlightened" about different tiers?
> > We did have such discussions in the past outside the context of
> > compressed memory, for memory tiering in general.
> > 
> > Not sure if this is the right place to discuss this, but I see the memcg
> > folks CC'd so maybe it is :)
> >
> 
> I will probably need some help to get the accounting right if I'm being
> honest.  I can't say I fully understanding the implications here, but
> what you describe makes sense.
> 
> One of the assumptions you have in zswap is that there's some known
> REAL chunk of memory X-GB, and the compression ratio dictates that you
> get to cram more than X-GB of data in there.
> 
> This device flips that on its head.  It lies to the system and says
> there's X-GB, and you can only actually use a fraction of it in the
> worst case - and in the best case you use all of it.
> 
> So in that sense, zswap has "infinite upside" (if you're infinitely
> compressible), whereas this device has "limited upside" (node capacity).
> 
> That changes how you account for things entirely, and that's why
> entry->length always has to be PAGE_SIZE.  Even if the device can tell
> us the real size, i'm not sure how useful that is - you still have to
> charge for an entire `struct page`.
> 
> Time for a good long :think:

Yeah it's counter-intuitive. Zswap needs to charge less than PAGE_SIZE
so that memcg tracking continues to make sense with reclaim (i.e. usage
goes down), but if zswap consumed a full page from the system
perspective, the math won't math.

Separate limits *could* be the answer, but it's harder to configure and
existing configuration won't "just work" with compressed memory.

> 
> > > 
> > > This is ignorance of zswap on my part, and yeah good point.  Will look
> > > into this accounting a little more.
> > 
> > This is similar-ish to the memcg charging problem, how do we count the
> > compressed memory usage toward the global zswap limit? Do we keep this
> > limit for the top-tier? If not, do we charge full size for pages in
> > c.zswap or compressed size?
> > 
> > Do we need a separate limit for c.zswap? Probably not if the whole node
> > is dedicated for zswap usage.
> >
> 
> Since we're accounting for entire `struct page` usage vs the hard cap of
> (device_capcity / PAGE_SIZE) - then this might actually be the answer.
> 
> > > 
> > > Thank you again for taking a look, this has been enlightening.  Good
> > > takeaways for the rest of the N_PRIVATE design.
> > 
> > Thanks for kicking off the discussion here, an interesting problem to
> > solve for sure :)
> > 
> 
> One of the more interesting ones i've had in a few years :]
> 
> Cheers,
> ~Gregory

