Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6D2CF45CF
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81E46B008A; Mon, 12 Jan 2026 16:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F7A6B008C; Mon, 12 Jan 2026 16:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D856B0092; Mon, 12 Jan 2026 16:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA7C6B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:13:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 162065D7B2
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:13:46 +0000 (UTC)
X-FDA: 84324563652.25.8D162B7
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1F02514000A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:13:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rIJaUqIg;
	spf=pass (imf26.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768252424; a=rsa-sha256;
	cv=none;
	b=knTmU2yBKeWRoCoYjsxcoCNv+k4xscRnfz3UGizsdcBJ0pq++zGFmx2yvY+KOw+34y1j1a
	qLeqEPKIOJZg05X8gglAoXhDC1/d4AEhvo8MdTQw9QJ3N2e9ex+5w6ZzwXqHb3Io94e7Jc
	3OE1hxg1i8Mv+/a/rrJcHRu5/MI1a9Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rIJaUqIg;
	spf=pass (imf26.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768252424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxPTgY1hS6x3WN8fauxCi7vpyRV4r7loXaP/CZeSb+8=;
	b=YnrC+V5IpU3Gj/kSCYhJynylmAPtJnBWuwq6IwAFCeySOJlRkz/19e+kDE9OuMoT9f3v+9
	1Zw8rts1UZdqA3GpCrBYLcjQ+PPvJqpsz1hDwMapYVl/MpxHSkVdZJcPFpjO6tVvewVVwc
	iLMY9bhEAqBeClxjUzOdKzlTQ8S28kQ=
Date: Mon, 12 Jan 2026 21:13:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768252421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sxPTgY1hS6x3WN8fauxCi7vpyRV4r7loXaP/CZeSb+8=;
	b=rIJaUqIgDAVioiRw4U9QgiumQcnjPGjKJ9/mbByHkJAw9oZ943bySHt7+JysGEPB1McR7d
	tYyBINte+eUsXxuu7yaBc+L1H2NtxuZujoTwUKMbSudAAQTfhunwyqGYidXNFtJ+dgKtBM
	eV+5UBDmFHCd59rZOGjVHyLYwZj/9LQ=
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
Message-ID: <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F02514000A
X-Stat-Signature: tbhrnnicqemh95tncroo88xa1g3mxnk4
X-Rspam-User: 
X-HE-Tag: 1768252423-559878
X-HE-Meta: U2FsdGVkX1/8Wyv4dWe/okiTLEUc0M25UPtI4njv31cZOQhYOlUbw8m6azRlUY/K33HRUL3iLYYeWgv92eLtKjqSc0XosaK9vLNBe51W4rp3g9Pvn3GPDCXN69+5GDZsztmJ3GXkdzeEFYvc6a02yJ5Poj3AgsyEbCt5rpGT7jUQpdk+GCEuCPpsX8q17oQzZ0uC/W/vMm4vkLdeCrlXXbg60GeRqgyQQ4xlWgBTCT/4sO4ap6cbB8gpgj5cV99n9f0mwvFKQXBcFzO1UbcUI4FdDpWuxVgK4EAUAkZMJ+sIh+U7ygHBtSPYxti6uB/MlcT6a7SbaZk4/cyNYvX6+Qv7khyBVnpQLr3dJpXen0gxLzey2dz/EvK4B8WX5h1HVdcEs79mbZmFeA65CZ+zR1ciKaJjDurxppug336WsCCKr1WuQPOwEoAHPybIfbS0io9KE7mvubUIO+j3LbX025Vs8gLZGNCZYhapcudOx30fffdQHrB5pgU7kYbxm7aw8zLHXZqFU+vZhgfR2LOnsPtYTKLKi1KFW4+exMGM9JNa/C3r7uTciGoMuz0odesqakHGIFR3e2au6flOLYm/bGs9Vjd35RL71lmWEw+qADGNfl+kGpdLcMNu1SrNhVQLl+3VL06oK3OxFnaa/NRjX06twIRDySUVhTlCr8sVnETxlGPg1TbWGrsZ5B6Bur7/0wgduJCvbs9Ks957FqeaKvAjA5t87VrjlPTt+zrfx0808rxo3gcOhByzqkaLQU4LoFU9JvKSsNtONd+zjCuiEgUtjxrBGmTPSxsi4HgMb4nbgmlJXYZOV0yd4xzn49fFsZwSIhWb43SqBsoge/w5MTKMjKinlefuorvJAi0jlaOLS/+DsWJoa8CJEXhPhv657I9GzEoL8NnJQteQD7GBGH832Rcnb40FAqqW/cp5EBrCgHLywx51wOHgEHrObuaHU1RRJekhhC8gqPv5cTq
 r0ihCULi
 MLzWj68ZAX95hMHPVNh9ji4lkNw1tOzZ7bneDJnGYxcLUmZRHw/pvIqDaQ42DPdDHHE10iCZE0qxHPV8HCbOFD+90+zxL5wRanukFigfBdieyW5nAEPqFAh+4XA1Uc5FAk0182eKIhVoCOyAkWUffHDC3QeI+AQdeAscY8ehtzdu0BY4ONDXvxYOlU4bqKpcAw+IlSlh91fG2Io6nxX1l46Cvs5Zy2OX3v+zqv9bPcLQ2OqDtfoWb492jVb4sIluzMHwWf250azTQpj1YadHQZrwoZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 04:40:08PM -0500, Gregory Price wrote:
> On Fri, Jan 09, 2026 at 04:00:00PM +0000, Yosry Ahmed wrote:
> > On Thu, Jan 08, 2026 at 03:37:54PM -0500, Gregory Price wrote:
> > 
> > If the memory is byte-addressable, using it as a second tier makes it
> > directly accessible without page faults, so the access latency is much
> > better than a swapped out page in zswap.
> > 
> > Are there some HW limitations that allow a node to be used as a backend
> > for zswap but not a second tier?
> >
> 
> Coming back around - presumably any compressed node capable of hosting a
> proper tier would be compatible with zswap, but you might have hardware
> which is sufficiently slow(er than dram, faster than storage) that using
> it as a proper tier may be less efficient than incurring faults.
> 
> The standard I've been using is 500ns+ cacheline fetches, but this is
> somewhat arbitrary.  Even 500ns might be better than accessing multi-us
> storage, but then when you add compression you might hit 600ns-1us.
> 
> This is besides the point, and apologies for the wall of text below,
> feel free to skip this next section - writing out what hardware-specific
> details I can share for the sake of completeness.

The wall of text is very helpful :)

> 
> 
> Some hardware details
> =====================
> The way every proposed piece of compressed memory hardware I have seen
> would operate is essentially by lying about its capacity to the
> operating system - and then providing mechanisms to determine when the
> compression ratio becomes is dropping to dangerous levels.
> 
> Hardware Says : 8GB
> Hardware Has  : 1GB
> Node Capacity : 8GB
> 
> The capacity numbers are static.  Even with hotplug, they must be
> considered static - because the runtime compression ratio can change.
> 
> If the device fails to achieve a 4:1 compression ratio, and real usage
> starts to exceed real capacity - the system will fail.
> (dropped writes, poisons, machine checks, etc).
> 
> We can mitigate this with strong write-controls and querying the device
> for compression ratio data prior to actually migrating a page. 

I am a little bit confused about this. Why do we only need to query the
device before migrating the page?

Are we checking if the device has enough memory for the worst case
scenario (i.e. PAGE_SIZE)?

Or are we checking if the device can compress this specific page and
checking if it can compress it and store it? This seems like it could be
racy and there might be some throwaway work.

I guess my question is: why not just give the page to the device and get
either: successfully compressed and stored OR failed?

Another question, can the device or driver be configured such that we
reject pages that compress poorly to avoid wasting memory and BW on the
device for little savings?

> 
> Why Zswap to start
> ==================
> ZSwap is an existing, clean read and write control path control.
>    - We fault on all accesses.
>    - It otherwise uses system memory under the hood (kmalloc)
> 
> I decided to use zswap as a proving ground for the concept.  While the
> design in this patch is simplistic (and as you suggest below, can
> clearly be improved), it demonstrates the entire concept:
> 
> on demotion:
> - allocate a page from private memory
> - ask the driver if it's safe to use
> - if safe -> migrate
>   if unsafe -> fallback
> 
> on memory access:
> - "promote" to a real page
> - inform the driver the page has been released (zero or discard)
> 
> As you point out, the real value in byte-accessible memory is leaving
> the memory mapped, the only difference on cram.c and zswap.c in the
> above pattern would be:
> 
> on demotion:
> - allocate a page from private memory
> - ask the driver if it's safe to use
> - if safe -> migrate and remap the page as RO in page tables
>   if unsafe
>      -> trigger reclaim on cram node
>      -> fallback to another demotion
> 
> on *write* access:
> - promote to real page
> - clean up the compressed page

This makes sense. I am assuming the main benefit of zswap.c over cram.c
in this scenario is limiting read accesses as well.

[..]
> > So the CXL code tells zswap what nodes are usable, then zswap tries
> > getting a page from these nodes and checking them using APIs provided by
> > the CXL code.
> > 
> > Wouldn't it be a better abstraction if the nodemask lived in the CXL
> > code and an API was exposed to zswap just to allocate a page to copy to?
> > Or we can abstract the copy as well and provide an API that directly
> > tries to copy the page to the compressible node.
> >
> > IOW move zswap_compress_direct() (probably under a different name?) and
> > zswap_direct_nodes into CXL code since it's not really zswap logic.
> > 
> > Also, I am not sure if the zswap_compress_direct() call and check would
> > introduce any latency, since almost all existing callers will pay for it
> > without benefiting.
> > 
> > If we move the function into CXL code, we could probably have an inline
> > wrapper in a header with a static key guarding it to make there is no
> > overhead for existing users.
> > 
> 
> 
> CXL is also the wrong place to put it - cxl is just one potential
> source of such a node.  We'd want that abstracted...
> 
> So this looks like a good use of memor-tiers.c - do dispatch there and
> have it set static branches for various features on node registration.
> 
> struct page* mt_migrate_page_to(NODE_TYPE, src, &size);
> -> on success return dst page and the size of the page on hardware
>    (target_size would address your accounting notes below)
> 
> Then have the migrate function in mt do all the node_private callbacks.
> 
> So that would limit the zswap internal change to
> 
> if (zswap_node_check()) { /* static branch check */
>     cpage = mt_migrate_page_to(NODE_PRIVATE_ZSWAP, src, &size);
>     if (compressed_page) {
>         entry->page_handle = cpage;
>         entry->length = size;
>         entry->direct = true;
> 	return true;
>     }
> }
> /* Fallthrough */

Yeah I didn't necessarily mean CXL code, but whatever layer is
responsible for keeping track of which nodes can be used for what.

> 
> ack. this is all great, thank you.
> 
> ... snip ...
> > > entry->length = size
> >
> > I don't think this works. Setting entry->length = PAGE_SIZE will cause a
> > few problems, off the top of my head:
> > 
> > 1. An entire page of memory will be charged to the memcg, so swapping
> > out the page won't reduce the memcg usage, which will cause thrashing
> > (reclaim with no progress when hitting the limit).
> >
> > Ideally we'd get the compressed length from HW and record it here to
> > charge it appropriately, but I am not sure how we actually want to
> > charge memory on a compressed node. Do we charge the compressed size as
> > normal memory? Does it need separate charging and a separate limit?
> > 
> > There are design discussions to be had before we commit to something.
> 
> I have a feeling tracking individual page usage would be way too
> granular / inefficient, but I will consult with some folks on whether
> this can be quieried.  If so, we can add way to get that info.
> 
> node_private_page_size(page) -> returns device reported page size.
> 
> or work it directly into the migrate() call like above
> 
> --- assuming there isn't a way and we have to deal with fuzzy math ---
> 
> The goal should definitely be to leave the charging statistics the same
> from the perspective of services - i.e zswap should charge a whole page,
> because according to the OS it just used a whole page.
> 
> What this would mean is memcg would have to work with fuzzy data.
> If 1GB is charged and the compression ratio is 4:1, reclaim should
> operate (by way of callback) like it has used 256MB.
> 
> I think this is the best you can do without tracking individual pages.

This part needs more thought. Zswap cannot charge a full page because
then from the memcg perspective reclaim is not making any progress.
OTOH, as you mention, from the system perspective we just consumed a
full page, so not charging that would be inconsistent.

This is not a zswap-specific thing though, even with cram.c we have to
figure out how to charge memory on the compressed node to the memcg.
It's perhaps not as much of a problem as with zswap because we are not
dealing with reclaim not making progress.

Maybe the memcg limits need to be "enlightened" about different tiers?
We did have such discussions in the past outside the context of
compressed memory, for memory tiering in general.

Not sure if this is the right place to discuss this, but I see the memcg
folks CC'd so maybe it is :)

> 
> > 
> > 2. The page will be incorrectly counted in
> > zswap_stored_incompressible_pages.
> > 
> 
> If we can track individual page size, then we can fix that.
> 
> If we can't, then we'd need zswap_stored_direct_pages and to do the
> accounting a bit differently.  Probably want direct_pages accounting
> anyway, so i might just add that.

Yeah probably the easiest way to deal with this, assuming we keep
entry->length as PAGE_SIZE.

> 
> > Aside from that, zswap_total_pages() will be wrong now, as it gets the
> > pool size from zsmalloc and these pages are not allocated from zsmalloc.
> > This is used when checking the pool limits and is exposed in stats.
> >
> 
> This is ignorance of zswap on my part, and yeah good point.  Will look
> into this accounting a little more.

This is similar-ish to the memcg charging problem, how do we count the
compressed memory usage toward the global zswap limit? Do we keep this
limit for the top-tier? If not, do we charge full size for pages in
c.zswap or compressed size?

Do we need a separate limit for c.zswap? Probably not if the whole node
is dedicated for zswap usage.

> 
> > > +		memcpy_folio(folio, 0, zfolio, 0, PAGE_SIZE);
> > 
> > Why are we using memcpy_folio() here but copy_mc_highpage() on the
> > compression path? Are they equivalent?
> > 
> 
> both are in include/linux/highmem.h
> 
> I was avoiding page->folio conversions in the compression path because
> I had a struct page already.
> 
> tl;dr: I'm still looking for the "right" way to do this.  I originally
> had a "HACK:" tag here previously but seems I definitely dropped it
> prematurely.

Not a big deal. An RFC or HACK or whatever tag just usually helps signal
to everyone (and more importantly, to Andrew) that this should not be
merged as-is.

> 
> (I also think this code can be pushed into mt_ or callbacks)

Agreed.

> 
> > > +	if (entry->direct) {
> > > +		struct page *freepage = (struct page *)entry->handle;
> > > +
> > > +		node_private_freed(freepage);
> > > +		__free_page(freepage);
> > > +	} else
> > > +		zs_free(pool->zs_pool, entry->handle);
> > 
> > This code is repeated in zswap_entry_free(), we should probably wrap it
> > in a helper that frees the private page or the zsmalloc entry based on
> > entry->direct.
> >
> 
> ack.
> 
> Thank you again for taking a look, this has been enlightening.  Good
> takeaways for the rest of the N_PRIVATE design.

Thanks for kicking off the discussion here, an interesting problem to
solve for sure :)

> 
> I think we can minimize zswap changes even further given this.
> 
> ~Gregory

