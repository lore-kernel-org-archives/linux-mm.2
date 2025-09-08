Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A53CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28A78E0010; Mon,  8 Sep 2025 11:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00BE8E0001; Mon,  8 Sep 2025 11:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C948E0010; Mon,  8 Sep 2025 11:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9559B8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:06:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FEAA13938F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:06:27 +0000 (UTC)
X-FDA: 83866409214.05.E1216D8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6313640003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:06:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KJMZiDJg
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRKdWPBqgxOOD4haFDefsclhOM8qE/foLVBPNAM3ND4=;
	b=SOPBpP6Mx8A96m8w0boGyttQha9aLfeUcSwfSjcTRkFVMthFA4EFAPslH+FxmcIzCz/+l4
	iccIACPxm5ln62KvSJK9ZyMXqWlUOXsoqreGz+pLiIaqfXSqcV18JVlo5cFO5d/4NPe1gh
	xENr+tusMr9ZD0sfI73uDsEgsKVpXtM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343985; a=rsa-sha256;
	cv=none;
	b=yQAewYLq0bs+nbbbhqw0k+SPIQmEZgy8ety13gI1V22vYLBUp4d+vn+6hAyD0wnKbalvie
	ESUuu3MFr/KDN71JEmTX3YlfuBOTDy1Ezk5L8PjdO/pGVBMW5unEWGwjC2I3QHvFKrX5Po
	lDEUiF2HFEmPe7jY3zrE0hxW2cwcKFU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KJMZiDJg;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XRKdWPBqgxOOD4haFDefsclhOM8qE/foLVBPNAM3ND4=; b=KJMZiDJgZSjSvrkiLoBzlDQ3fY
	oaIifBFepzZkP/eDQFau5WyJdZTeWYTG+aCWbu3GSzU59ERFD24hJKAuZqGFcBPX7LtKSP/WNqCYn
	wNnWkMojKtUKCns7ttt6tjKGhNUSTH5i74HLkMha4GJVppiDNTcq2XsrkzjHet4Lj7I6oi0nrdRYK
	BBflvfGs3g+E6KUN8RIjnM8+jNk5o7WOFNLOQbgLVSBHrmz0ccf09+/U1Qwv9CyOtkijC3iZbqS30
	rDfTvSk//9KB6TGNt42V6Cjzx91BA91DRJCf0QdCJh9gnwDeb2GxG2ECWM4n2bSSRzxg0NmBIKZVn
	WIvZFaSQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvdRb-00000008eVw-15VO;
	Mon, 08 Sep 2025 15:06:11 +0000
Date: Mon, 8 Sep 2025 16:06:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>,
	Christoph Hellwig <hch@infradead.org>,
	Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alexander Krabler <Alexander.Krabler@kuka.com>,
	Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
	Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	David Howells <dhowells@redhat.com>, ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when PG_private_2
Message-ID: <aL7w4qrJtvKE1cu5@casper.infradead.org>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com>
 <aLTcsPd4SUAAy5Xb@casper.infradead.org>
 <52da6c6a-e568-38bd-775b-eff74f87215b@google.com>
 <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
 <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com>
 <3973ecd7-d99c-6d38-7b53-2f3fca57b48d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3973ecd7-d99c-6d38-7b53-2f3fca57b48d@google.com>
X-Stat-Signature: 53b5o3kbrzku6483gxbktbo6cf4acc67
X-Rspamd-Queue-Id: 6313640003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757343985-172757
X-HE-Meta: U2FsdGVkX1+QkHkFOrH/swAehF8NBk4M2dRoN31KNhe2Fejk2o5w+dn7AiBQLbuvO6Rr8R99UQln+LbS6po+DlXIvOvxmPm6nd165erfxBDPw32R3TdfYRc1VsEj2P3Hz5LLOZWnHpLvj5OvGFkSkDrZxE69sdHXJwD7rlATk9+uEKok/qjLBfeARsAF59hnQISZCMNM+yRcVzIgyC8UtXx0LUKzSceflLSOxKvQu5FX7k+LALxLzQ8kGmUMWzPMDppR6Cv1uEhvOgCSI6AP5cZ/bP+Agk1gFDGhZyGjXjVTpfBwNEMp0lwLSzK9ztndLwsovM/e1nMzD+DJvYS+K9PfhhO0eYzqYQ8FCzCFPaSN4sa0Rnd6aaAZjir7JAn9QwI9EFWsRpk3bsa1W+2/7A2yGIVSYHt7CU7bO4J23/uMMaDAajSeYlg2ShQ2hTWWFiLNnXABLcy52l37S9pkOkpDipktBmsv7uJCiLTN91LuaJSkfsVqdmxQL8hRIKJFG2tpl8xxgilqtKfQ/aYCf45+2aeOH7s2KKMIE5ZoFWzJGklt9zakNZcYmyAzYdUP4O8mSxjar5LtG8cF5qVKmF8+R8ikxHAhd2ufuyGqQjDLujkodxUcJW/zp8nleUK4Txh5SX6f+p2ChIOlxYHgpLu5UKBDzA9WurnFpOu5aT2gK80h8jkXW7W0l5BUoySjSYYwhsIGH0bdCy9KX4biV3QFwzKNzJi3UGV5f+PbPGsDGi8Qb6Z0l4EaMddxdgeQFNRfiK1gAC85+/nBEwFBPZCfy1iDxZCL+lTeVfLTgLxrLUEY4+yc97eARR05JVlaQNgT2mm/Of36XTg5eKti2o4cRnoitryt0W2usdOsq3/0IQ94rI93WI0ZJBllC4dt9nXjPELVz/p5NBFVEmYadhfvLVlYqPppa3yV5oyA4pbUIBslD+Vj+xStNttcLa/cb9ZUeiwsdIofJMfq9FQ
 yBDbU2bV
 KPdGq6cb4+4Cz/8ZGHkZfNtVa4oomCq5yGkVOuN8qfE4DS8LgnwURn6kD47tokT43RaH3u70lJbV8P1vMtjqjDTybIU3s+Tn0ifeWdUO5+Zkw6L5mli7nYed/or0zIItpPjXiPVjVvQZiLpSVBuzU3WPG5m+kqILiVxZiW2y5pekpTS2c597TWY5QxT19u0m4c9XYgRjMjoZAvOQn7RZtiBToVnLuk5wngSgB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 03:27:47AM -0700, Hugh Dickins wrote:
> On Mon, 1 Sep 2025, David Hildenbrand wrote:
> > On 01.09.25 09:52, David Hildenbrand wrote:
> > > On 01.09.25 03:17, Hugh Dickins wrote:
> > >> On Mon, 1 Sep 2025, Matthew Wilcox wrote:
> > >>> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
> > >>>> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
> > >>>> which (like PG_private, but not in addition to PG_private) counts for
> > >>>> 1 more reference: it needs to be using folio_has_private() in place of
> > >>>> folio_test_private().
> > >>>
> > >>> No, it doesn't.  I know it used to, but no filesystem was actually doing
> > >>> that.  So I changed mm to match how filesystems actually worked.
> 
> I think Matthew may be remembering how he wanted it to behave (? but he
> wanted it to go away completely) rather than how it ended up behaving:
> we've both found that PG_private_2 always goes with refcount increment.

Let me explain that better.  No filesystem followed the documented rule
that the refcount must be incremented by one if either PG_private or
PG_private_2 was set.  And no surprise; that's a very complicated rule
for filesystems to follow.  Many of them weren't even following the rule
to increment the refcount by one when PG_private was set.

So some were incrementing the refcount by one if PG_private were set, but
not bumping the refcount by one if PG_private_2 were set (I think this is
how btrfs worked, and you seem to believe the same thing).  Others were
bumping the refcount by two if both PG_private and PG_private_2 were set
(I think this is how netfs works today).

> > > Now, one problem would be if migration / splitting / ... code where we
> > > use folio_expected_ref_count() cannot deal with that additional
> > > reference properly, in which case this patch would indeed cause harm.
> 
> Yes, that appears to be why Matthew said NAK and "dangerously wrong".
> 
> So far as I could tell, there is no problem with nfs, it has, and has
> all along had, the appropriate release_folio and migrate_folio methods.
> 
> ceph used to have what's needed, but 6.0's changes from page_has_private()
> to folio_test_private() (the change from "has" either bit to "test" just
> the one bit really should have been highlighted) broke the migration of
> ceph's PG_private_2 folios.
> 
> (I think it may have got re-enabled in intervening releases: David
> Howells reinstated folio_has_private() inside fallback_migrate_folio()'s
> filemap_release_folio(), which may have been enough to get ceph's
> PG_private_2s migratable again; but then 6.15's ceph .migrate_folio =
> filemap_migrate_folio will have broken it again.)
> 
> Folio migration does not and never has copied over PG_private_2 from
> src to dst; so my 1/7 patch would have permitted migration of a ceph
> PG_private_2 src folio to a dst folio left with refcount 1 more than
> it should be (plus whatever the consequences of migrating such a
> folio which should have waited for the flag to be cleared first).

But that's another problem.  The current meaning of PG_fscache (and also
that has changed over the years!) is that the data in the folio is being
written to the fscache.  So we _shouldn't_ migrate the folio as some
piece of storage hardware is busy reading from the old folio.  And if
somebody else starts writing to the old folio, we'll have a corrupted
fscache.

So the current behaviour where we set private_2 and bump the refcount,
but don't take the private_2 status into account is the safe one,
because the elevated refcount means we'll skip the PG_fscache folio.
Maybe it'd be better to wait for it to clear.  But since Dave Howells
is busy killing it off, I'm just inclined to wait for that to happen.

> I'm just going to drop this 1/7, and add a (briefer than this!)
> paragraph to 2/7 == 1/6's commit message in v2 later today.

Thank you!

