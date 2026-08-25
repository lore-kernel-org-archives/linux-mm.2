Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F97C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38446B0095; Tue, 25 Aug 2026 15:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8736B0096; Tue, 25 Aug 2026 15:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25916B0098; Tue, 25 Aug 2026 15:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2866B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:27:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C5961C046D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:27:08 +0000 (UTC)
X-FDA: 85140774936.17.184F093
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5C6B01C0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:27:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Egn/lsSt";
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787686026;
	b=0HHzvTQ2S4d6TiRrH6BGaDExRoTrpYXOifdFK1ks3rM4lJGy75KzRvNY7jab7K9EMtwmEP
	Ma0svnK+siRPi+USdbiQlQ0eibyo8str4PJ27R3gfatIK6iRx4BHikO6GK9+h730K4ueI/
	T+UpYRDu3wpGW7rfj3zjOktMcg7VxsE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Egn/lsSt";
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787686026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxTtAvTtvM+uHl0dQvDvN3ybbm7YPGi9Fc/YNAJO1Pc=;
	b=UW70TSVjkJ74qBQYO961lghKpTxYVoEdBG/XUvOfGTDt25uSR7804CSCWDBD9TOvEzmbSU
	cabiRdYft6N6yMcKuD8EfviAJcyL/ma0aUx9KMqqJYP2KRu7lklVWWpG8f9qXF4jhAG2u2
	OKSxEV7frY62ecyXRwiy6i0n5qmKNNY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xxTtAvTtvM+uHl0dQvDvN3ybbm7YPGi9Fc/YNAJO1Pc=; b=Egn/lsStH5Uq2YFZENOdHYax3E
	wmqqenTC9QVGzw8ggQipiJJLpJ5Dosv6JXO2A9T5xNyFoR56mpErpr5QSNz2fOMyuRMsaptXAD2yH
	yhMbx8D+DJ/3D+YGCGhgZd+70RG9kiCkAu8sudQHIEuJjVM0bCmf3EHYPd46VNr97SjNz+1Zcy3En
	3WumdcHmn4O4O1Ptd3y6zA5IlFaTR4G/bwARAi2pDdCrOMdgmitRMjnyxn28Tw15q9Rx/O/IzSZtq
	t3MoOGkLiuBijPcQh6sMxwYifcVwJQ4oNFQkh0PbJ+JlMmEo7xzPMAXBmcRfRFD7hO/tTDRGSuLLn
	MTLtKS5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wywnQ-00000009bVE-1vU0;
	Tue, 25 Aug 2026 19:26:56 +0000
Date: Tue, 25 Aug 2026 20:26:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3sgEET8GuY7Rw2@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com>
X-Rspam-User: 
X-Stat-Signature: 35bc16znr7ht1ru6nc5fsk3xzztd1d68
X-Rspamd-Queue-Id: 5C6B01C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787686026-711153
X-HE-Meta: U2FsdGVkX1/olXn730noxo1aD3XoWkRqbR/RLw6WOHWiJINmD8UnoRlb5gqC/+ZJ0FeRh0ub/mcxhaP1ynQGjyGXPZK+zCGoMheEHU815D76nxuRWNBxhESSHUfSW6Su0Tq+ToZ4tf55Li10GpNTTz8K5RnADgOXpNvOXZokvdMB4r52Y2ZBPXLaP+jr8UXa5F4+iZ0CbbyFhJE6jcObrQpOIq7/DRcwMliB1cHqRMFZpbK+iuujFZ22usDCYZvzrhSbW34jhRHtKV+9/vsUMaHt54OxCsUSEp2BAqUqb/NI66FBnMXLBTfNbjoS1uD3ZsbXvs6RW/To94gMoY0UWw2mwGwDMfhWnrfDsjfH1jYg5aNTKchb1DmbQC1RmKZXmdsfWKqswP9hlu76dDMd9Qd/IJTZcPUwSXhewH5kquVpppYLlf0Eba2wj1Cc5ouiiB0fIVBlTbOE64w6klcNEllvgpNG0daZXTMvgCsdbZjn9E+mnBbnWfe9cRLkVp6Vgexh0nw88dp5o98XjW4Wd0/Vy7wL+v3D6eCZcW2RbqVmM7VZNDrzvmbRS21WRnQRuFNMM+4C2VaYgN+veaEbv+hbV4y/mB21pU9Sx1Wl0yZW7V07ESeXoTFadnpzE7HEnZIE9s+jA7mdVxhiYtrRl3qdVAmiNuyjC0wgyPBV6I77uxz4Ewv2K7R0iujnmvZwgC41rwPikErZXj3PlbU1vZYWr0vycgC2Cf2ASd9sz04fnnwo64t+6FaoJlzbCL31YsjDAuX/2KmZ1BPSHA4CLLueeSUCOd3PfskMuyrJq4JK/1j2G1SUNP7p5vDG1nMrEZROvIJdPy5CpG+5lC4ezbw3F/fxwLmo2Pld0gjaRwjN0lUHSoGvgTFbHnUNd9/J8uncXO1LTJx9QKpk//FCi0VwGeN0rYX1G7rD2PoBK6jYrB7pwDqKFMJHy2ji+jFSsN1/I7N49aU8rkebpck
 +IW0UM+6
 TxJfAINA6O8fF9RlKMmptTPVZyqvwal+TKsgmBhu8VosrdkRW0nE8r5W6KDviHlc1hVNONuiAm0ntmBGHJx5Lidf78J3oVx6PPA4ermPTjnG3iUndaPVpaWxh8zblA/T84PvXaogSMoPvBws1RKp4aRTi/Vi7L/6uqlt7fVOzjD2GmQPG9QgSBZd3/ZGErC7IaRq6euWIRi6ZUk2J9QKbvmMgCi4yb+Di+7cL9Xh9dL+yhGsWvNg46AyWnTD9lBAJBD/glD5DPc8S5VnkbTeuEU73QE7ahVbFvrUvblJ31FfcfZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:08:48AM +0930, Qu Wenruo wrote:
> > The problem is GUP.  We have no way to force the GUP caller to go
> > through page_mkwrite again.  So instead we make the GUP caller call
> > folio_mark_dirty_lock() which many just don't, and generally we get away
> > with it.  But it's a bug, and a bad interface.
> > 
> > There's also the problem that GUP users bypass the folio_wait_stable()
> > mechanism.  If a page is written to while somebody is creating a
> > checksum over that page, the checksum will be corrupted.  If we want
> > to fix this, we have to bounce-buffer the page.  There's no way to
> > prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> > 
> > My proposal is this:
> > 
> >   - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >     If it's true, do the writeback, but retain/recreate whatever data
> >     structures you need in order to write the folio again; behave as if
> >     ->page_mkdirty() had been called again for each page in the folio is
> >     marked as dirty.
> 
> This may make COW more complex.

It's probably wise to be explicit when talking about COW.  Anyone from
the MM side of the house is probably thinking "but this is only relevant
for shared writable mmap and we don't do a COW".  You're talking about
filesystems doing a COW of the on-disc data, not about the MM COWing the
pagecache page into an anonymous page.

> For folio_maybe_dma_pinned() case, we will need to do extra space
> reservation similar to page_mkdirty() again, so that the folio can be
> written back again.

Yes, you will.

> I'm not sure if we will have a good timing for re-reserving space inside
> btrfs.

Why is it hard to do it immediately at writeback time?  I think you're
in an even less restrictive locking environment than page_mkwrite is
called in because you're not under any MM locks.  According to
Documentation/filesystems/locking.rst, ->writepages is called with
absolutely no locks held.

> Would it be possible for MM/VFS layer to trigger page_mkdirty() instead?

Actually ... no, because the VFS no longer knows which pages in the
folio are dirty.  That's information the MM had, and communicated to
the FS which (if it cares) has stored in its folio->private.  But the
VFS no longer has access to that information.


