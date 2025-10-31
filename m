Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B41CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 14:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BAC8E0090; Fri, 31 Oct 2025 10:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CA08E0042; Fri, 31 Oct 2025 10:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB728E0090; Fri, 31 Oct 2025 10:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5398E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:27:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E84388B10
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:27:04 +0000 (UTC)
X-FDA: 84058636368.17.197A9E0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id A736C80017
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:27:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ShMAqP/0";
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761920822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZJeznUxq3NqTvDD4ipQdXNOxRnNKyJPsZbGlCqhuxY=;
	b=M87o6X1sNGm5iEYmmtHEWweawbxdY4F95BmR1T3eMeOTOOmQD2tWWeKwU+oEcAc7QMT99P
	HZ3xBgmLmwl4d2YqGL1IYOzDccC4Zis+S57rvWTrMYtn1cMYoHGNuIx1rfaoLPhRaBw5TW
	XwxbyWSpkBYGUxsyksjZzHlxcOKorMA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ShMAqP/0";
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761920822; a=rsa-sha256;
	cv=none;
	b=HK8pe4ILM51deISA73T30lMcy3oVbnjorZzkD34HyjnJIEBW8zO6sBJHil5fExgDIb8h4D
	TyHvx+9osazPTl/ozzAZ3s8J3Ugdla/b9qlo+4sWzGlJtHQPrm0sBSURhB1ZuhF3Bzy6GH
	wLg/iUgsaMrGiRA67DZP9t8dFpiI0Fo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QZJeznUxq3NqTvDD4ipQdXNOxRnNKyJPsZbGlCqhuxY=; b=ShMAqP/0s6Ht4p7oYW0GtR03mk
	PRXKme7ZLzQQRRBCwJjCLpV4PMv/C3APLzJrsQE0ZalCPQueNR6ho8rAzi8hCpoIvDm33eJatdgg8
	cLF44Pn8t8Jqv4gt0ZLz9eff/jXKKsQMKO9nQj5k5qD6e2CEQ9yEU1mIWVs0Uz7560VvcxB7grPCh
	7E5AJGxlWmkZGwHzbuAWEHxdi2coueojgTrpyKSDwQPQuEQooizeLdz2hzqIRtCVGK23Y8vqZKr8o
	N4GzKafW1RuMQX5mIPnKcBtG/cyqhCv7aoA7YhY8XKeX/S4Lyc6+KvHQN0Q1P7WaAgWwfkbcjguas
	vKdz5aSQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEq5g-0000000HSEZ-1zCN;
	Fri, 31 Oct 2025 14:26:56 +0000
Date: Fri, 31 Oct 2025 14:26:56 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>, libaokun@huaweicloud.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	jack@suse.cz, yi.zhang@huawei.com, yangerkun@huawei.com,
	libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQTHMI3t5mNXp0M1@casper.infradead.org>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
X-Stat-Signature: 95z6we5woiquzywxk47ojcir9i55n7mq
X-Rspamd-Queue-Id: A736C80017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761920821-879778
X-HE-Meta: U2FsdGVkX1/T/5kCMXYm0kZLtpLp6w3VQuyhksQTZAyw1U74jUBn1in+3zH/gPSX+JPcY+OpMQ/b413h+XwE7rEE9m2BadTmOcWOHPI31rzn3jYfnDWnYvwNQYX6Iu+n38kZNfy1JO7m+98dxad73wZmJt6TGKk+nBtoFupLXUsHUE2aVL10ssI9nLfukOy0IKkdOWQdNfpRK5pqq7/Yr0zFe63jX5D1hiuHrWg1HvG2NiQq9uFlb467JLXr7+Tpl4C+a3OggaJ0yY1EzkI+t32NTqneWvErM8WYd2dy/J2Z1YBlaoyHBrJerMFht1wWiJFomaNCxpajPp+QApbl2QauxtKeTvMTV42WBAdJpJOqCd5iZwE/QXy9f2GeGRJ0/mB3D/Q67VUe5BYQ+AbvZdrD4rVp/jvsTypljdLzYb1wL/2y8wnHiF2dThaCLC+WCNgs0sUpUXToTEhc3cfPVPMQiX/8yqeYE6iu8AJF1cvA1jhtPjt/j6RJ055cQhbYbgj00uAvGrEX8I78pU4osarDfOI/XQnJd0b3NgHLXizcAevCxZoGwCzOUoxD/hlLO9A8KaisT9jZhNfp+dvv4LD3mmcN5fLGhs35d/SMKBdDPPQmJ8MLm56JuaIlYKU5YrJQPwkbJqwfI9iAN++9tLUHqd2yWQwG9ou1Ld5dzs4T42I//XFbwzXiK9lYDZt7zB/WmKdboBZjsAJxeOTeUxKL2Ce1gM6WZ2yRkTLUnqHrzzMA/QwUIV34nIYU9uoujzTZ4kzEYk4V2YS1LG+PMC3QbIc+KEIBYUTfq56KAJ7xU2pn34g8oxgfBgbmULyc2xFXeNOofUC6Pci5PuYK4fjzO6q/9wHPxQMjx9k13aUT88aj97hX5zha3grSLcn62bTwf27VZ9lP8A0ZxXTa0tEgq9URLeqoNkWX5f58C2VGrNBc6m2bvMdQe9/aCiNPd06mR7FlcPe8d7ZiZtJ
 A4AQz3vP
 xtfpIy7SxsNlTFXP28Yd67wmTjMa+ype2440nEIdMx8hVqmFfdP/mczyeHTO4khsA+4TLTHqhi/5XhE4ygpQFzu/53JgqqL3j96iwGtSaQMJbFvoHnpWSSH+7Kkx9OGb3IEups2eTWIO7GhdOVELAWdNbTkaraUv0ruVWl7H/gjgKyN1nW1zbkq1dA0foXaNEgfB+LureL4Vryv9GXTljHOTRH82FV2KSVshSdYj95cmjkESOoGrQ1OBrlED6yW8+ySzgKr+nMBdmjx+mnbRW9j5tBpCKKCIic1yRtRtSeIuvVMNUIybx+byJHVpnEcxgc+ePTJclV0hLtGSlxzMsM1W93w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 11:12:16AM +0100, Vlastimil Babka wrote:
> On 10/31/25 08:25, Michal Hocko wrote:
> > On Fri 31-10-25 14:13:50, libaokun@huaweicloud.com wrote:
> >> From: Baokun Li <libaokun1@huawei.com>
> >> 
> >> Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
> >> reads at critical points, since they cannot afford to go read-only,
> >> shut down, or enter an inconsistent state due to memory pressure.
> >> 
> >> Currently, attempting to allocate page units greater than order-1 with
> >> the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
> >> However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
> >> can easily require allocations larger than order-1.
> >> 
> >> As Matthew noted, if we have a filesystem with 64KiB sectors, there will
> >> be many clean folios in the page cache that are 64KiB or larger.
> >> 
> >> Therefore, to avoid the warning when LBS is enabled, we relax this
> >> restriction to allow allocations up to BLK_MAX_BLOCK_SIZE. The current
> >> maximum supported logical block size is 64KiB, meaning the maximum order
> >> handled here is 4.
> > 
> > Would be using kvmalloc an option instead of this?
> 
> The thread under Link: suggests xfs has its own vmalloc callback. But it's
> not one of the 5 options listed, so it's good question how difficult would
> be to implement that for ext4 or in general.

It's implicit in options 1-4.  Today, the buffer cache is an alias into
the page cache.  The page cache can only store folios.  So to use
vmalloc, we either have to make folios discontiguous, stop the buffer
cache being an alias into the page cache, or stop ext4 from using the
buffer cache.

> > This change doesn't really make much sense to me TBH. While the order=1
> > is rather arbitrary it is an internal allocator constrain - i.e. order which
> > the allocator can sustain for NOFAIL requests is directly related to
> > memory reclaim and internal allocator operation rather than something as
> > external as block size. If the allocator needs to support 64kB NOFAIL
> > requests because there is a strong demand for that then fine and we can
> > see whether this is feasible.

Maybe Baokun's explanation for why this is unlikel to be a problem in
practice didn't make sense to you.  Let me try again, perhaps being more
explicit about things which an fs developer would know but an MM person
might not realise.

Hard drive manufacturers are absolutely gagging to ship drives with a
64KiB sector size.  Once they do, the minimum transfer size to/from a
device becomes 64KiB.  That means the page cache will cache all files
(and fs metadata) from that drive in contiguous 64KiB chunks.  That means
that when reclaim shakes the page cache, it's going to find a lot of
order-4 folios to free ... which means that the occasional GFP_NOFAIL
order-4 allocation is going to have no trouble finding order-4 pages to
satisfy the allocation.

Now, the problem is the non-filesystems which may now take advantage of
this to write lazy code.  It'd be nice if we had some token that said
"hey, I'm the page cache, I know what I'm doing, trust me if I'm doing a
NOFAIL high-order allocation, you can reclaim one I've already allocated
and everything will be fine".  But I can't see a way to put that kind
of token into our interfaces.

> >> +/*
> >> + * We most definitely don't want callers attempting to
> >> + * allocate greater than order-1 page units with __GFP_NOFAIL.
> >> + *
> >> + * However, folio allocations up to BLK_MAX_BLOCK_SIZE with
> >> + * __GFP_NOFAIL should always be supported.
> >> + */
> >> +static inline void check_nofail_max_order(unsigned int order)
> >> +{
> >> +	unsigned int max_order = 1;
> >> +
> >> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> 
> This is a bit confusing to me since we are talking about block size. Are
> filesystems with these large block sizes only possible to mount with a
> kernel with THPs?

For the moment, yes.  It's an artefact of how large folio support was
originally developed.  It's one of those things that's only a problem for
weirdoes who compile their own kernels because all distros have turned
it on since basically forever.  Also some minority architectures don't
support it yet.  Anyway, fixing this is on the todo list, but it's not
a high priority.


