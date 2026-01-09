Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1C1D1A63D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 21:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6DC6B0088; Fri,  9 Jan 2026 16:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394596B0089; Fri,  9 Jan 2026 16:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268FD6B008A; Fri,  9 Jan 2026 16:40:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 100C26B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:40:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97B7DD1270
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:40:46 +0000 (UTC)
X-FDA: 84313745292.15.42F5A3E
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B09DC0006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:40:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WC5it+QW;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767994844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1T5Jfe8diqm3ahhuEtgg+KQ26xQUqcKW5qWJWdj6z0g=;
	b=0EF8Y6fvsDLlmE8AEHUnROnh126c5KgOaFCjnApy81sy8WkNAcQtFf1bTFJtAD/4dRi5ym
	yhunGcDpD9expMWfuaVcUnzLDOCjKu5xhVf2NmJ/BJE+LpAOw8uu46ciIBFqOjSiPQuZzr
	GHz5ksj3cxIEZmFHBdbpkcGAWav+S1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767994844; a=rsa-sha256;
	cv=none;
	b=fBfBUmeQkGy4GPuZgWn3u6+tiPLXX3mlcCNYnnygw/DL7EUlyUHLm74CRdk4ygOYtsZSuH
	pkwBAlmPre6ZX9Pfezwh0CF3A4HOA2tUOz65wl5x0wyDLFxmC5p6sFr5x3mvVKjPd/e4iP
	4hdkkBHinH583aHC7IE3PtCJI0XOWIs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WC5it+QW;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c305b7c472so318350085a.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 13:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767994843; x=1768599643; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1T5Jfe8diqm3ahhuEtgg+KQ26xQUqcKW5qWJWdj6z0g=;
        b=WC5it+QWWwFYV4WrbsGVvKG4ZErCllePkJtCcvRw9XgCXyodKoqu5dxQNvvG1oUu6F
         x6A+Wr4EiHq2kYiILR1WIz/cakrcVuT7sYAatFjjYc/gDVYY3DTg697MbKlZHnf5tFAv
         lv5KssV657JoLgpOT2Ge+0HSOIOkdWwpz272dIkia48pNarR6mZvBJ80CM5R/UrWhu0+
         2eQE3qtZ54rYPIyGb0l6D8fiBQLHk25ZnWpKLW/0WZtRtit7qWLDYBQf9b4gNWB5K4iw
         eg5MGaKtSvVpMdRx/Zwa2WC61dQGZLTBgvK0/eki/sEy2brs21ocjUN1bferu8ofwsvx
         IozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767994843; x=1768599643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1T5Jfe8diqm3ahhuEtgg+KQ26xQUqcKW5qWJWdj6z0g=;
        b=Ep9JMtNsGr5Of30DB7RbTf3VAzcF1akiOM+o36sDgHCeP5epv5ffvAbiQUOgtv5Xka
         4gaKwXkTd6OC/Ar9cx7t55wPSEFYYDa34zvKcWoDN6K4dpW2Klkr7gNK3kE7elpcLUTw
         2PdJk7aG/6xhOgj7O9KC/k8Krhx92MUgnFoMIyHwaZIUWMzsm/+CqmBt6epgu5lg/NOz
         +Fjn/hcKKVNrr+VXsmw+8UI2zODm4nJWnrMzo4PMZBE4eUIifh8cEi4q7w9MTBvltlHj
         HeVPFvS8qgQjRyysmInUAT2aWrojwpyTmb7fRa6Wb8f4vS01fxTfP/cCU06ctI/KIK01
         UC2g==
X-Gm-Message-State: AOJu0Yymkh26poAYxBL2qfjEsbX4Zna9kyEjv64lF0XbS9hUMM3RCjWF
	F8W8l/KaaOWGnv3MEjTXtrRN9C7QBfHmhLz34LrsYno87HefUNRv/q4F7HLcpY40FtEiX1Z1Dq7
	kX3/n
X-Gm-Gg: AY/fxX4gAgwRnYMjsU9Q39h7tZteYg4GSCt3cbb4oK/4FnJED/VPeofFz2PfsWKUfHZ
	0bgYT8GBUKVWDqgOO9xw7KJFxRK8M1IWQKdqyGDG7YXtPrp9D9USDRz7SdDuVNIt9k6a4QMRxD0
	o5jWu8xQ1enOknqYgvWE5G+LLPoww4dtxUFBT57iKSeRUYJKtZIxC5gznysnUZX8qkhSWM5W2IX
	2JBYU99ib0cHwUTCju2g6stG9Y0Y+aEj7tmCzhRhvWp75wfcTmtCobAKENmfs0v9hSqGFj/lENM
	IcAgXh0VNpFe1woqtcCnlD4X91q536ZVFY8bNEy/PUj0EDdpZE9dpTPa4fCOR8vlGXR+YU8OTBX
	u0OVjeZhqtkH39GauVNmY1Qv1miThCJm6NzbwyDY+RUEhqwK6JtHrxTFXMbRcHacxoguRbzRnH5
	A5stFg2MCJasNrGLydslZZFvOL+bid/qTA+TfsIHClpEYuDr7R8143nDYhPeOkSImUooyrwg==
X-Google-Smtp-Source: AGHT+IECZ50vj1hnAePHBzinDlZDGYs+7/mlvEWHygZHTAQz3MseJ7eUXnsVQ1HRY8SD8qWK1C+CIw==
X-Received: by 2002:a05:620a:1709:b0:8b2:a0cd:90f1 with SMTP id af79cd13be357-8c3893de7c3mr1525931485a.61.1767994843351;
        Fri, 09 Jan 2026 13:40:43 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4ccdf8sm924975985a.23.2026.01.09.13.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 13:40:42 -0800 (PST)
Date: Fri, 9 Jan 2026 16:40:08 -0500
From: Gregory Price <gourry@gourry.net>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B09DC0006
X-Rspam-User: 
X-Stat-Signature: 4k366i4zxpxtfoc8kducgr75ks7zisbo
X-HE-Tag: 1767994844-226098
X-HE-Meta: U2FsdGVkX1+WZXxWaXd0Ccx6gPnUJyQIJUqez+gmedJDPDYvMqcVE9Ohu4E9c8paNmaKmAYWobDzkQejN73AGZ6hc5BGZnLKdL/2O+2dB299MGDpwqeesedBOKPqTqp1yyyMQoH10JgQNdBwlbuerVNSyU4Knqgp0dY56MxjBM5zj9cO7Bh+HIOwrNN9ZN3/a4A+BX+WfGoX++2va6zHhyxPpWgc08CVZEggwRV/xSDkcjvl2qMqHLHpaYy6+i1ycuSLSmw1pig9/w7qfq34Gk4dIYGOphgmLNaH7Xf+5D4jBVtYxI2uq3hnlDJO7AOwp4q1iFTb7JyheO5lztB0gvkTEBvOVqL4Kp4yz1S1kbcsRH0dxwDwSs4uHy0DeBPYeWRHPLUcwjq8qzgPD8djNsBYPQ3OQrobeCvtbQ1O34joeZCc3xRJOqvxD9bJTpddO8U7InUTx+HLOfHh/uIrYBAs8oYaSh+h2eJFZzMLKBGBFSLTTUHNyOe8R5bCyFrABLvduy3uFzURgCgyt99uRd73PxIP8OjJGEhRAQ1d62eievxaTkNz0+/am1Rzzsvvy6iPo8sqaDQaa+skv2yXF3IayNhdaHFhIe5TF0H78wqM3E+e2b19A+92sHuV3wJ+pXE5fXmXakDj4xeopkG/1lcrfvsPU0jtc6mEhQyoQfcfAOgxInyz6ha5R2gO5917obWWzcj0CjJtGfRZjnb9gkWdbf7jFbaYis7prWvXmMJ0VyUXUzPYzIi26QQcGRe+VQ6SKiVmQm6LgWpZFhxwLZCC8Nb7n71martx+S8G1zO9Fd4deSdLaRS/td4tIpge0X5pYr7vX8EIFLIhbTLAtvx1i/XOQ3btklL7hedo0ORnEHbBy12azlauL9a4x/hvvkmS4NiF9XGCqGLoAAT2u/5OOdGVb1tczixIlSM7PIDb62gjyzjWLJNgO0vwTNOIuLFH95lDyEjQZRJBnEz
 rrat4zSp
 8+jjHUyBWci9WDn4ydmhOQdjgvoJe7nDnIizv7oE0BYRf08UHSZq/codo6tiyoBojnOWwTS6nplZXlP9dSOaIofjUJD/cyKFjYVrmQU1hxIycvy/fao9A/30CHpafW81Y2Jl3GrteTCudeC9dygNP8fwnwk8pBzR6I7Yj269Sut1T/i0DsAFjC0dMxeYJLOHk3cHsUZoI0ivQ3c4ASWdBSUAByJj5ENvgfhqxfEycf6Yh6T0+igEVnfFIC8akRH7AtT1LJv9KzqQOqLmCNZ9rLHe999GugBsRojm+zsHKfUNf9UcDErWMqbXBh577AJ3SnUrQFTvK1pgbfS2zdzMubxVcGgLI9O3qkNh5GGNS3lsQrAd/qjJUOmts8/OLxHsjDna+tJYJX9/YSi9zM2EfliUJMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 04:00:00PM +0000, Yosry Ahmed wrote:
> On Thu, Jan 08, 2026 at 03:37:54PM -0500, Gregory Price wrote:
> 
> If the memory is byte-addressable, using it as a second tier makes it
> directly accessible without page faults, so the access latency is much
> better than a swapped out page in zswap.
> 
> Are there some HW limitations that allow a node to be used as a backend
> for zswap but not a second tier?
>

Coming back around - presumably any compressed node capable of hosting a
proper tier would be compatible with zswap, but you might have hardware
which is sufficiently slow(er than dram, faster than storage) that using
it as a proper tier may be less efficient than incurring faults.

The standard I've been using is 500ns+ cacheline fetches, but this is
somewhat arbitrary.  Even 500ns might be better than accessing multi-us
storage, but then when you add compression you might hit 600ns-1us.

This is besides the point, and apologies for the wall of text below,
feel free to skip this next section - writing out what hardware-specific
details I can share for the sake of completeness.


Some hardware details
=====================
The way every proposed piece of compressed memory hardware I have seen
would operate is essentially by lying about its capacity to the
operating system - and then providing mechanisms to determine when the
compression ratio becomes is dropping to dangerous levels.

Hardware Says : 8GB
Hardware Has  : 1GB
Node Capacity : 8GB

The capacity numbers are static.  Even with hotplug, they must be
considered static - because the runtime compression ratio can change.

If the device fails to achieve a 4:1 compression ratio, and real usage
starts to exceed real capacity - the system will fail.
(dropped writes, poisons, machine checks, etc).

We can mitigate this with strong write-controls and querying the device
for compression ratio data prior to actually migrating a page. 

Why Zswap to start
==================
ZSwap is an existing, clean read and write control path control.
   - We fault on all accesses.
   - It otherwise uses system memory under the hood (kmalloc)

I decided to use zswap as a proving ground for the concept.  While the
design in this patch is simplistic (and as you suggest below, can
clearly be improved), it demonstrates the entire concept:

on demotion:
- allocate a page from private memory
- ask the driver if it's safe to use
- if safe -> migrate
  if unsafe -> fallback

on memory access:
- "promote" to a real page
- inform the driver the page has been released (zero or discard)

As you point out, the real value in byte-accessible memory is leaving
the memory mapped, the only difference on cram.c and zswap.c in the
above pattern would be:

on demotion:
- allocate a page from private memory
- ask the driver if it's safe to use
- if safe -> migrate and remap the page as RO in page tables
  if unsafe
     -> trigger reclaim on cram node
     -> fallback to another demotion

on *write* access:
- promote to real page
- clean up the compressed page

> Or is the idea to make promotions from compressed memory to normal
> memory fault-driver instead of relying on page hotness?
> 
> I also think there are some design decisions that need to be made before
> we commit to this, see the comments below for more.
>

100% agreed, i'm absolutely not locked into a design, this just gets the
ball rolling :].

> >  /* RCU-protected iteration */
> >  static LIST_HEAD(zswap_pools);
> >  /* protects zswap_pools list modification */
> > @@ -716,7 +732,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
> >  static void zswap_entry_free(struct zswap_entry *entry)
> >  {
> >  	zswap_lru_del(&zswap_list_lru, entry);
> > -	zs_free(entry->pool->zs_pool, entry->handle);
> > +	if (entry->direct) {
> > +		struct page *page = (struct page *)entry->handle;
> 
> Would it be cleaner to add a union in zswap_entry that has entry->handle
> and entry->page?
> 

Absolutely. Ack.

> > +		/* Skip nodes we've already tried and failed */
> > +		if (node_isset(nid, tried_nodes))
> > +			continue;
> 
> Why do we need this? Does for_each_node_mask() iterate each node more
> than once?
>

This is just me being stupid, i will clean this up.  I think i wrote
this when i was using a _next nodemask variant that can loop around and
just left this in when i got it working.

> I think we can drop the 'found' label by moving things around, would
> this be simpler?
> 	for_each_node_mask(..) {
> 		...
> 		ret = node_private_allocated(dst);
> 		if (!ret)
> 			break;
> 
> 		__free_page(dst);
> 		dst = NULL;
> 	}
> 

ack, thank you.

> So the CXL code tells zswap what nodes are usable, then zswap tries
> getting a page from these nodes and checking them using APIs provided by
> the CXL code.
> 
> Wouldn't it be a better abstraction if the nodemask lived in the CXL
> code and an API was exposed to zswap just to allocate a page to copy to?
> Or we can abstract the copy as well and provide an API that directly
> tries to copy the page to the compressible node.
>
> IOW move zswap_compress_direct() (probably under a different name?) and
> zswap_direct_nodes into CXL code since it's not really zswap logic.
> 
> Also, I am not sure if the zswap_compress_direct() call and check would
> introduce any latency, since almost all existing callers will pay for it
> without benefiting.
> 
> If we move the function into CXL code, we could probably have an inline
> wrapper in a header with a static key guarding it to make there is no
> overhead for existing users.
> 


CXL is also the wrong place to put it - cxl is just one potential
source of such a node.  We'd want that abstracted...

So this looks like a good use of memor-tiers.c - do dispatch there and
have it set static branches for various features on node registration.

struct page* mt_migrate_page_to(NODE_TYPE, src, &size);
-> on success return dst page and the size of the page on hardware
   (target_size would address your accounting notes below)

Then have the migrate function in mt do all the node_private callbacks.

So that would limit the zswap internal change to

if (zswap_node_check()) { /* static branch check */
    cpage = mt_migrate_page_to(NODE_PRIVATE_ZSWAP, src, &size);
    if (compressed_page) {
        entry->page_handle = cpage;
        entry->length = size;
        entry->direct = true;
	return true;
    }
}
/* Fallthrough */

ack. this is all great, thank you.

... snip ...
> > entry->length = size
>
> I don't think this works. Setting entry->length = PAGE_SIZE will cause a
> few problems, off the top of my head:
> 
> 1. An entire page of memory will be charged to the memcg, so swapping
> out the page won't reduce the memcg usage, which will cause thrashing
> (reclaim with no progress when hitting the limit).
>
> Ideally we'd get the compressed length from HW and record it here to
> charge it appropriately, but I am not sure how we actually want to
> charge memory on a compressed node. Do we charge the compressed size as
> normal memory? Does it need separate charging and a separate limit?
> 
> There are design discussions to be had before we commit to something.

I have a feeling tracking individual page usage would be way too
granular / inefficient, but I will consult with some folks on whether
this can be quieried.  If so, we can add way to get that info.

node_private_page_size(page) -> returns device reported page size.

or work it directly into the migrate() call like above

--- assuming there isn't a way and we have to deal with fuzzy math ---

The goal should definitely be to leave the charging statistics the same
from the perspective of services - i.e zswap should charge a whole page,
because according to the OS it just used a whole page.

What this would mean is memcg would have to work with fuzzy data.
If 1GB is charged and the compression ratio is 4:1, reclaim should
operate (by way of callback) like it has used 256MB.

I think this is the best you can do without tracking individual pages.

> 
> 2. The page will be incorrectly counted in
> zswap_stored_incompressible_pages.
> 

If we can track individual page size, then we can fix that.

If we can't, then we'd need zswap_stored_direct_pages and to do the
accounting a bit differently.  Probably want direct_pages accounting
anyway, so i might just add that.

> Aside from that, zswap_total_pages() will be wrong now, as it gets the
> pool size from zsmalloc and these pages are not allocated from zsmalloc.
> This is used when checking the pool limits and is exposed in stats.
>

This is ignorance of zswap on my part, and yeah good point.  Will look
into this accounting a little more.

> > +		memcpy_folio(folio, 0, zfolio, 0, PAGE_SIZE);
> 
> Why are we using memcpy_folio() here but copy_mc_highpage() on the
> compression path? Are they equivalent?
> 

both are in include/linux/highmem.h

I was avoiding page->folio conversions in the compression path because
I had a struct page already.

tl;dr: I'm still looking for the "right" way to do this.  I originally
had a "HACK:" tag here previously but seems I definitely dropped it
prematurely.

(I also think this code can be pushed into mt_ or callbacks)

> > +	if (entry->direct) {
> > +		struct page *freepage = (struct page *)entry->handle;
> > +
> > +		node_private_freed(freepage);
> > +		__free_page(freepage);
> > +	} else
> > +		zs_free(pool->zs_pool, entry->handle);
> 
> This code is repeated in zswap_entry_free(), we should probably wrap it
> in a helper that frees the private page or the zsmalloc entry based on
> entry->direct.
>

ack.

Thank you again for taking a look, this has been enlightening.  Good
takeaways for the rest of the N_PRIVATE design.

I think we can minimize zswap changes even further given this.

~Gregory

