Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2122AFED3F0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 16:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303AA6B0005; Fri, 24 Apr 2026 12:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4C06B008A; Fri, 24 Apr 2026 12:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CAC16B008C; Fri, 24 Apr 2026 12:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09FB06B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:45:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDD401A0255
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:45:43 +0000 (UTC)
X-FDA: 84694025766.29.6579ECC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 56B77100002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:45:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JIWAhgVJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777049142; a=rsa-sha256;
	cv=none;
	b=mLJ00E3RuDFClMHHQfVY4uZorqxac5+oxtRt0OKZqeaVuXJrBfZZlOuAyty0KYHkjxfK9j
	KYVbtp03NiklodUi6HK0OihQ32gcDWsuCV3rWXKt53lSIcWcjpmGEN3rmE228HhgfIRZza
	a3IJI07LYKtAlySlxuHrDRog8ga7MVw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JIWAhgVJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777049142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MuIhTKn81QH0/FznwtFyEBRCGi6RLudX/kQq6UY2bI=;
	b=BptyM9VmsJTvDm17GbaH7R0CUY6wyL9Pq0Orr5epq+P7GM4cByBQLo98ggTpG5fPTKNoPw
	ZGHrUm1bAHfDDj+iDfYPzMEZP+wqHbDJYb411JCLclvgUhF3PKTRvGQB89rcwsL7vgGtsq
	BNGXx0s+RhgEsXla6QOTMVB0cPYpJUY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6MuIhTKn81QH0/FznwtFyEBRCGi6RLudX/kQq6UY2bI=; b=JIWAhgVJoTGgF90npbxq2/cgHu
	bq4/mViVjxtLFxXB4EYuCD23xBVkNFN+87L+NhL7/n1LhEjcZEjh8cQn6oPfv4XaneT3X0KX7SPIZ
	XyfWL+Vgqhxr799qOpfDwagohch91PzE49v7rQFd7ProqwXXwti9g7HwZ4EA7iRWoU7jvx7fwV/Wk
	d69Q/ENZoGIA7KCwgp25vZqr/PjbmR3uQ7ToDHdLCTzgZy4xMZ+Gg693EKUYBLR97VZam/opyuSX3
	3ePKpH17x4xNeRTyyiGI9mfdqg3HUAY64eV6ZW+DOOqJ0UjEDGGZ7oO5sU89wZWsHlKtQGW30BJPU
	4GZVdjnA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGJet-0000000DT0j-0FcI;
	Fri, 24 Apr 2026 16:45:39 +0000
Date: Fri, 24 Apr 2026 12:45:32 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Ryan Roberts <ryan.roberts@arm.com>, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] Page cache tracking with the Maple Tree
Message-ID: <oi2kit3a2qulr53c7j3h4g3cjjgbss4kd2djdqota2sriiaaov@7uewnraaq4gk>
References: <biynsvpcamct5fva5nxxdvc3q43dqi72jotpyasvrk3pumdz2w@7okprmuwznlo>
 <aeKO6bKupHa2bgWt@casper.infradead.org>
 <aeaKAxrAUtfwM9ns@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeaKAxrAUtfwM9ns@cmpxchg.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: g5gr8xdx9nzfzfkofnm4i48apgrt43sw
X-Rspam-User: 
X-Rspamd-Queue-Id: 56B77100002
X-HE-Tag: 1777049141-49752
X-HE-Meta: U2FsdGVkX18wSDr+a84NnoU2ZlLclxDJuGlNXpXDtJmE4lH5jtsAlEAkQeT5aO4qisStFnAAcr6ko3m70wIHZghPKJ/j5Y2lxdYOhOnO5xqMFAL5hoSB2Wmcfwz2HMf6gTfRqEEjJdctkSqQVSHQK8errwZzGhV6NywvaPLdjoOK/6AqZwbYuu4DlVzdmlppKwHiUOItnx1WJ+vA3XbOqc4K4LifPZV+5cNsYHUcvLDnffY4JAhQipHPgEar4OAWj2q0QKlYeeyn4Bwbpwhu0crO3WcUAVN5RS8hp0NMndZX+4yWh0XIjX6NDEjgyAP3yYvEOKZN0SNcG8DGCT+35pH+ZW8IfP4+C9I3UDvloaFPHWXSSsXF3OzktKvDetBeC8+Dk2epkNEVoejDGkh1tHP/XLuKP7+yN+Mrshufgz88MwykMTXf8aHLqXSU6Ktz8CPzItXBON7HuD0xRF4FmoPkFpeZ81ix80PfOTFzZQBVkFfW2vv/fMxz6F4sfryMy0+LvwyjiB3HLz/5nf3hg3u0tzMLpX/upStg7n66TC2fE90kT/FgtgGoHvt3kFPquN/WRsKE2ljz81uEN5+axL29D4R4HJ427hc4RRtHLHZuX3vQcqzWNfk6dM3zIeyoGb0DiYC1pYuNY/+gSgr0f0XHulAK+Q1000CyyNRhk7YLm8C8DQikyF+/JM3qHOlBBT56VYr2SUbfTnMKQbdciTjpck2z0vgDZOvC6paEDXR+L2/uOOlEIxmAIVBh8lsm11qK2b17cQpuhbJMeUXxpDXgjMfoit9saT+4yaxa3+B6/3oxfQw7Ncx2PfZs+WIzIG6WEzxmXVzZhIPZH3ni//iZAMqy/BOgueY0R8sJW+2yvjTjHMw+h2sS5z7Og+yAQaH+8b2jXQMXf6udoIC8VcVTFhgw6KZvtzjPxJc8Ypl/mZmyn9stWmizomd3MR+3sY/fFLzq3z0mkNFoSoL
 OaFvH+5e
 9E+uE0mQ06JDbEpJ6jcFaLZDscfysfPjWfSWvxE7xVfz4DTrOezUseDEQhErYN2r7ufw2E5JEMEPBj4H53v3TcdLfW13mw266V4ll/GFVDq3rLZfAtsafgACRlTxc9hU0tzgxZbJuwfXnCoFPsgdnj6Uc80HeY8piXPN4eGgTNgcD31SrbkCqWttPhl8YRrEJS694t95p+782Onxve3flqXH6ByZDRDpRTmJnvNdNk2f8cbvMVpArBrKULxGl1U+pU/yL15vvcyL2t+yHZABYLe1uoW1cNkSMI52e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/20 04:18PM, Johannes Weiner wrote:
> On Fri, Apr 17, 2026 at 08:50:01PM +0100, Matthew Wilcox wrote:
> > On Tue, Feb 24, 2026 at 12:10:26PM -0500, Liam R. Howlett wrote:
> > > The Maple Tree needs some enhancements:
> > >  - Support for purging shadow entries from the page cache
> > 
> > Liam and I hd some preliminary discussions yesterday around this
> > and we'd like some feedback if anyone has time before LSFMM.
> > 
> > For those who aren't aware, when a folio falls off the end of the
> > LRU list, we store a shadow entry in the page cache in its place
> > so that if we access that page again, we know where to put its folio in
> > the LRU list.
> > 
> > But this creates a problem (documented in mm/workingset.c) where
> > we can fill up memory with shadow entries.  Currently, we embed a
> > list_head in xa_node and add nodes which contain only shadow entries
> > to a list which can be walked by a shrinker when we're low on memory.
> > Ideally we wouldn't do that with the maple tree.  There are a few
> > options.
> > 
> > The first question we have is whether it's best to keep nodes around to
> > wait for a shrinker to kick in.  Was any experimentation done to
> > see whether eagerly freeing a node that contains only shadow entries
> > has a bad effect on performance?
> 
> Hm, I'm not sure how that could work.
> 
> The LRU order created by readahead makes it highly likely that all the
> folios in a cache node are reclaimed/made non-resident at once. Going
> this route would destroy a large part of the non-resident cache the
> moment it is created.

Not the moment it is created, but the moment the entire node only has
NULLs or shadow entries.  Meaning it's removed the moment the last
entry becomes a shadow entry.

Still much sooner, but not as extreme as just dropping them immediately.

> 
> The goal is to garbage-collect the oldest shadow entries whose
> distances are too long to be actionable at this point. Specifically,
> their distance to lruvec->nonresident_age (per-cgroup, per-node).
> 
> In the current scheme, we just go in the order in which nodes became
> all-shadow - oldest first. And we only do so lazily when the
> non-resident cache is far into that territory (cache set vastly larger
> than available memory). That gives us confidence that we're mostly
> dropping very old entries without having to look at them one by one.
> 
> We don't have to stick with that design, but whatever replaces it
> should meet the goal, or approximate it well enough.

The goal of garbage collecting the oldest shadow entries based on the
nonresident_age.  That's a broad target, which I think is made more
specific within the implementation to 'groupings of 64 shadow entries',
which I bring up later.

Besides the locking improvements that we can bring, is there anything
that you have found doesn't work optimal in the current solution that
may be nice to fix?

> 
> > The second idea we talked about is that the maple tree is much more
> > flexible than the radix tree.  Having even a single folio in a node pins
> > the entire node, so it's "free" to keep the shadow entries in that node
> > around.  But with the maple tree, we can be much more granular and
> > delete shadow entries in arbitrary positions.  So we could (for example)
> > keep track of inodes which contain shadow entries and purge shadow
> > entries when they reach, say, 10% of the number of pages.  Or 1000
> > entries, or some other threshold.
> 
> It's not the volume or the concentration of shadows, it's their age
> that makes them good candidates for garbage collection.

Maybe I'm reading this wrong but it seems workingset_update_node() adds
nodes to the list that is composed of all shadow entries (or removes it
if we have changed one to resident).

Doesn't that mean there is a concentration of shadow entries since the
entries in the tree are in order?

That is, reclaim is at node level granularity, and the nodes are sorted
sets.  I think, sibling entries aside, it's fair to call that a grouping
of 64 shadow entries?

This also means that with today's code we are keeping older entries over
newer entries because the node has at least one resident entry.  But
that's fine, because we can't gain anything by removing them today.

So, we can change this behaviour to something new if we want, if 64
shadow entries are too many to accumulate before removal, or too small.

> 
> Searching the tree for all-shadow nodes should be possible, but you'd
> still have to filter for age. Naively, that would be unpack_shadow()
> -> workingset_test_recent() for each one, but that's likely too heavy.
> 
> What might work is a monotonic ID counter for each node that becomes
> all-shadow, then search the trees with quick comparisons for any IDs
> below a certain cutoff?
> 
> > The third idea is that instead of having an injected list_head that we
> > keep a tree pointing to inodes (or even just maple tree nodes which
> > contain a lot of shadow entries).  That's not how list_lru works today,
> > so a certain amount of development work would need to be done.
> 
> Ah, so you don't need storage inside the inode or maple tree node.
> 
> That could work well with the monotonic ID counter, you'd just scan
> and reclaim through that tree, oldest node first.

I think this would end up looking like a linked list with a few extra
metadata points.  Basically a linked list, node pointer, min of the
node, maybe a size if we support multiple node types.,

I'm not sure the node pointer will do us much good, considering how the
maple tree node allocation needs to track the tree status on walking to
minimize allocations.  In fact, if we do a write that rebalances the
tree, we may have stale pointers.  I don't expect this to happen under
any normal circumstance - the node would need to be altered, but maybe
the node type changes..

It might be better to just track ranges and the largest (thus newest to
become a shadow) monotonic ID counter.

There's many ways to do this, but it'd probably be best to decide on a
size that makes sense (I say size because of the siblings..).  On that
note, the siblings stuff will go away with the maple tree as well.

Thanks,
Liam

