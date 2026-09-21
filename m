Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDA6C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 08:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606D86B00C5; Mon, 21 Sep 2026 04:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B74A6B00E5; Mon, 21 Sep 2026 04:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6276B00E7; Mon, 21 Sep 2026 04:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 211A46B00C5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:06:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1BA41C2F2C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:06:30 +0000 (UTC)
X-FDA: 85237037340.07.970918F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7EDAC40007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:06:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PB/bRjpv";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V3j/k6IB";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RRb2nd6M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aGB9y2oj;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=OKmsGvu5M+AYj/LsaXs9XpFnBgnIjBIVIg+yhh/fvraZYj7sWQZ7Onms5eAUHhX6mXgovV
	DLhxdMfvRcFlNLGf76E9aJPC4dbeFux/YBsxNCytIO2zQ0NYcfGiNDuJvGVrVudUt68hIP
	FJXhb+tgOH+2INQUvxuOao1ORTARcxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977988;
	b=ipxE3aZzzIAYJ+pUlF4u+v0pVbc7ZmcEBIm9QjTJ+Pk/LUXWJVSgAoICp7e4sUy1T9CBVK
	FzjFcs4BdiEn/Md45IxOI1lHZVA4zZs3BIXtdvB1A/m93aYd8KHW1TX1bIym2UGroXr2KH
	23F7R+hIeh877J87bdC+Ap1BHxogWuE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PB/bRjpv";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V3j/k6IB";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RRb2nd6M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aGB9y2oj;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA8D41F451;
	Mon, 21 Sep 2026 08:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789977982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=PB/bRjpvJulpMdcPRExe+EJrOHfb6btWjlhBoZk7iWU9ygSQ+g/5WA5amnvwprOwnlwXXw
	EA/3rzmME5ET5buBn861pP1ESrArwKqPG7ej4rC1HyPCTMTYBz7f48CM59hgmKqkEyREGc
	6gMoPz9GLNTsMNTpyYw1MsgIwwOcfR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789977982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=V3j/k6IBn+5rsUvHZcFjg+3NawNmj0iSoJXk82U00+Fb+GuxMLtdXNPlzny5VpIJxe3ZQE
	ujeTKXag2xZwoVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789977978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=RRb2nd6M2AGjT42rjUtZoUh1VyDCbhS8pu6t0KkTSVZNIU8KYd0jrVwPbWDHqMucUo/ka8
	y/ApUCmx+ZuvoWciuyp6yj9+0yS+7yyn5w2mRqWDQyD5gpDqqmU1a/KsbCvlatKAVLBc18
	KoygRWcj7w2kkvNSXkBcC4XgteWaXIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789977978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=aGB9y2ojkxPjjVQd6mLGf/SLxxr0G+9/jjD84hyJ4gRVKOseXAWCqs6ctxKaYBs2Cj58iA
	GSZMb3vtMORvRKBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A3761368D;
	Mon, 21 Sep 2026 08:06:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ugHVGXrlsGr4GQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 21 Sep 2026 08:06:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 10B47A13D5; Mon, 21 Sep 2026 10:06:14 +0200 (CEST)
Date: Mon, 21 Sep 2026 10:06:14 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, akpm@linux-foundation.org, 
	David Hildenbrand <david@kernel.org>, Boris Burkov <boris@bur.io>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <5kirwmtqsf2pjoknqjlnsognhdukv42w65drtqsiigf4hoki2u@kmecm2oqgdqk>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <ap6LFvuOuWf_BkGi@thinkstation>
 <aqrDfoFFr8o0Mf0G@casper.infradead.org>
 <aqrJAX6nMTIo6Vnn@thinkstation>
 <aqrPobWbuOdsCnMc@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrPobWbuOdsCnMc@casper.infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7EDAC40007
X-Stat-Signature: i4izk554etd63mn86i8behhft8ncjpyy
X-HE-Tag: 1789977988-233986
X-HE-Meta: U2FsdGVkX1/ymvDZxMAG0ez3mYLMGggiT2EYf9Q/x+PmjMLOBkGY9DywqZdPrbOfTknRrn+sAbswLkvI4+FX8TjC7s6L2wNrN4Cze7GiGqrQkxG3aCVoX3S1DY2DzcBRV2LFief8PbOjLSJrFzBmE+eTKbs6GnA9ukn1/MDiymzclyIhKy2iIF4owI+e4hvKszIUANvaggAIzp2ce0yYc5CSSI7RKdx/QuwuWt2dsd6hBfd7JFsyUGlMvq+7+Msx3iZtP6zXd+fs1WIPIHcuFBecSDLEaWgU8PkrC2GhwU1MhiGjNBsl6+9pkUPGpabQaZhNTRVOdEG/oNzyxlOs251//Un3oo1uuj8l0eBpQyGUeB6A2yc0sF4fdG6Jg1vbocyXoPlS/vvdXQX43aIlo7Gb6/S1GJYRNUkGkJnFqrQ+SMnH6IXWS52MbI6OWQJqCfEHCm3iQEZE9U1iiKUGujsq1ixf0DSkbNuC+nzXMpoBcLtwXkHwNpgEAGLkpRM5GIDPoDuLZP7wfbHHa2DgYCy/hyMNjZ6x9hjmIdv5pAUC4NuF7B3Z2krDW3dC4TKIaFQCq6696ZuVaevo8mgfqdRCMa4J052zRx8eG3h+sG2gIPFj2fpohXfD6oxSzGMMyOyBY+C9nE7ABe4fx61wEJxu1vpJkqvVXNXMGi/fPOUEkrKnXNgfP8S3oc0RRolbbV4Vw0FsCp6xD7R9/HfmgqdXLiU5tWZMOxi0tQFKAgXBFP5OMpi+4oZbFW8bPqId8Jt6tCqRR11LvrG2IoamKjv+xGUsi8Ft2/YpheY0q3fqKvsbCafGVoIY1cQL3kLGXbt2TDl86ZPIe3wDu8IqRBvb4KllrK0To+HTKoOZ5XMmpO1Py/32XZvUw2oKnh3FyPkRxxqpZJrGTs8SRChYGWaP43N26mKJoTMvOrwqq9wJRaRfpdQVP5nEgl0hAj0MqyA7BLupbXvkRAhDl2W
 gBdjcXm9
 fHIIdV9d8Zu5il7XW5WGv0UUR8BcPymRSNcA3NTTPN9bHVxAcvKCO3QiHk2wprT0VftpiXycGEt6tqzhbzZyJr6sBgj3/+HcTNCWAzHZ3ugN3sTX3WKUA+TZrC2k8P9fh17FyJDZSV4B3QXEb+LQt8624Qn0Lv8a3a/2Vln8QAJAJOeGdLRgwfqliz1bUl6UCdW9rOO6AouzPzQ6vCtrCEAxzIZBf3UYPilzNFLoSnfrY0B7P8DfkiLOkhR1nGxYSHVAw3bBF+wv2DEG8s6OsuEL1OQLPLq5gq3j76orMu5AXnQTUe/z7Clzm8+RCfdB8iZhzBH7cUW3FequtkOWrTG0/lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 16-09-26 18:19:29, Matthew Wilcox wrote:
> On Wed, Sep 16, 2026 at 06:09:17PM +0100, Kiryl Shutsemau wrote:
> > On Wed, Sep 16, 2026 at 05:27:42PM +0100, Matthew Wilcox wrote:
> > > On Mon, Sep 07, 2026 at 11:15:15AM +0100, Kiryl Shutsemau wrote:
> > > > My proposal makes the distinction between making the folio writable and
> > > > making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
> > > > on the filesystem side to track dirty state and drive writeback for the
> > > > *folio*, while ->dirty_folio_range() marks part of the folio dirty.
> > > 
> > > Why do you think that's a meaningful distinction?  We create a writable
> > > PTE because we've taken a page fault for write.  There's probably a few
> > > naoseconds where the PTE is writable+clean before it becomes
> > > writable+dirty, but even then sometimes we do both pte_mkwrite() and
> > > pte_mkdirty() as an optimisation in the write fault path.
> > 
> > This is true for the PTE that the fault was for. But we don't necessarily
> > want to dirty the other 511 pages at the same time.
> > 
> > The basic idea is to make the whole folio writable at fault and shift
> > dirtying to be per-PTE on write to it.
> 
> Hmm.  Is that something that filesystem people want?  I suspect not.
> I think they'd prefer to be told when we write-fault on each page.
> But let's see if we can gather feedback from FS people.

Well, learning about write-fault of each page is certainly a simpler model
for filesystems to deal with. What Kirill currently does is that the fs
learns about write-fault of the whole folio (so it prepares space for it)
but then dirtying happens only for some pages (so under the rest of the
folio just remain unwritten extents / delalloc reservations). Filesystems
can accommodate that although it will currently somewhat upset ext4's
delayed allocation reservation system. We will have there unreclaimable
in-memory extents tracking these reservations and on inode eviction we'll
complain they were never used.

What might get ugly with current Kirill's approach is if some simpler
filesystem doesn't have a concept of unwritten extents and delayed
allocation (like old ext2 or vfat) but still allocates blocks in
.page_mkwrite to make sure we don't hit ENOSPC / EDQUOT during writeback.
Then it implicitely relies on current MM behavior of calling .page_mkwrite
only on pages that cannot be evicted without writeback - if the eviction
happens, we've just exposed uninitialized on disk data. In fact this is
what would happen with current ext4 when you turn off delalloc and have old
indirect-block based inode format, except that ext4 is careful enough to
dirty all the buffers underlying the folio (and the folio itself) on its
own so there's no data exposure, we just loose Kirill's optimization.

So overall I don't find unsolvable issues with this but it will certainly
require some tweaking on fs side.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

