Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99098C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2C56B008C; Mon, 24 Aug 2026 15:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9DB6B0092; Mon, 24 Aug 2026 15:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E07B6B0095; Mon, 24 Aug 2026 15:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC516B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:08:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D466B140238
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:08:19 +0000 (UTC)
X-FDA: 85137098718.23.5472AF7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id AD09440002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:08:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fVJ5WxBy;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787598498;
	b=rThlfaBstXl05QoRzLzdzFh9m1XKCX2DqOrGSKPu/+aw5rU9T3ntz470r1Q/UOt9JPbJiy
	RqduzeAivF2w47fA7eaTEoxZ7L7FQ8i/twrz2o4wai2B8KlmmOpelZuIRxvQhaYAy0R59/
	kK8OS+z7j0UbvAg2Jg+dV3RmNjghK0w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fVJ5WxBy;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787598498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rXZ7ZE15rvwerUJ9OHaFUdA7osUeOjHjAwPp1v8D3Z8=;
	b=f41zD26/9nDvsKmuGEz5xM9+fBL6SZhX+jKwI7gGXYi4H/cdftqeNJ97MbhRgpAY2O1yXl
	wojGPicRF1FJwxmmDZjodxyL83YGwzQYhaQ5B8WXheSDX0ALHaaCWX//IyjlOmizOA9GoR
	pCpMdbznANjIAuXMmnm5eiRtqyuL3CI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rXZ7ZE15rvwerUJ9OHaFUdA7osUeOjHjAwPp1v8D3Z8=; b=fVJ5WxBy21PuBmR1rP+fz/pIl2
	5Iuy6MNrN7UowmFAKk8XIDnE7WC9ITFHIuJe/0qyEScfD8Aq3HNb5e1Kiri2u+3H6fiY8aSK9fyu2
	XQevVKRrCMTmBlMNadaWX+V+rVqPbAv62qHyPJkOraieP/ZkEWspLWVMewUYnHGMh8BJIZEINI0kQ
	WqcLUXDbgQn6v4HUweUI71vOv6UCWcA57cnwYfI19WbBrRGpDLMBANTfSay7oE9/4QNvDmF113AH/
	LcERCZFuIfNDm5T712CokJ4O0JmENbSA+FD66cAVZV7EUpVaHpnhFOd3m7dcWbozPDNtmMWL2CyMn
	A7Laf5Zg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wya1e-00000007gW8-3U3q;
	Mon, 24 Aug 2026 19:08:06 +0000
Date: Mon, 24 Aug 2026 20:08:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Removing ->dirty_folio
Message-ID: <aoyWln-Gt-yvZQkE@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: AD09440002
X-Rspam-User: 
X-Stat-Signature: 6z9r98ubwatn4mhof5znfbb3nstozekh
X-Rspamd-Server: rspam06
X-HE-Tag: 1787598497-298726
X-HE-Meta: U2FsdGVkX194ukhxsbMAc04fDMzcIz9HsnkI1SjgJK8y4H2n9i+jabjDKzwk9D2bObal8VrMfxtgBiJGdZFGd6SpF4aI3PsUS19VouQ3lwX+t/DWJFXhtjmrr3DHDAXnA6aw4BVgFyGELjWmbOBU+5b2XAQV4g8Gfz86u/g0ss7BiMCXFryHdYhVOq/D0WiwGvFXZdLixajfC3McQd+C3qa5pyx/tFkIQ6PsHMfOX6k7p/xsgPrYfbe4WjxH/QjXva2MjZn4J3jyF8gZ71pNVZMybI0iC+7wakwc03QPle+BuRKVpFo4/+NCuq2BTxIrpsbtYzBNeH4M9enc3wQgW013asJepp55OdfMcGGGNTqvpppDT//IRHLy9oDinBzg+TvhsY+TF/nxtUH2sRPYMZrY1ecUimhw82iSkrC/sFUsp4CcTLdHF1koBWyCiypANREYz9tuuNEEIetxfVp3SywJSPK/5e0z1N4q+EzrCihGFCYnZ7/kYpfjIoa8AYxQ41CVr0w9HZ6ORhDU/HJ91mHLYrzzwcaqLVcq0iY4g9Tx3SupqBgy8ppjc3/zkWef63XsvA0EdeNdDf6gYPSXEUGmCpZLUxcU1ycpWEbTiwHy1Ij6NGuv4wiOkDI1R45/u9PzGmHMI+DrUIC/ahFzv0708aYPz2z5ueWE9LrolTILsZIRDKlsrBKwkqiX5gu/mUn9S0NcRszrtdT8x3TlFKgogs38SqziF++siL4oiAw4er9AX4NbpXIY8eXn3hWypSxnVUeUfhqYOg+hg7v0xIPoDq/Ro/37IVdmuTUuIJvIXm4sn4g+1qyBc2vYtB3C/lN3doIgv2Or3WfElPXES/uyHn8D562EJg+fV3m9Hu9yy25+FsjQKsdU2N+G2bq9BRMZe7kUstvegddJxKcRA7r9p9UZtZVSxdBVOF4Sg6m015lc4Wa9QY7R0LzZ6GAT0zznZtNWNWLLzp8aHJ8
 k9IfHtnT
 sWNyo8WXvRHIdpLw2Xfcl1LjewbbvPUnjQenswT+UvBp8MNt2+ZWYEoEqAmXrEk8wYpWM5xsiTM9gT+r2dO5jgthP9Pdq4rl7H9x0+hQcP9bmo/BjFThocRi29qQ/CRln7RBBCY1Q1LfixVA5dmeuLxAdKjbPzDhcZ0TEMgjvmdYGGmFb14b5NAN7Xpmp8uchxJdyQFSHxoqPADsPyfNKSP+8FsZTZ7XHH8H/6EhebL2zfXCf8j9ZuxtQ6hXxdhcay4sR8tNLOYysko+PKuj7EbLEdSa4UFSgKgq4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.

This is not how filesystems want to be informed of folio dirtying.
It was fine for ext2, but anything that's journalled or COW has work
to do before the folio is made dirty, and it's hard to do that work
under the page table spinlock (not all callers hold that lock, but the
filesystem has to be able to handle the cases where it is.

Filesystems want the page_mkwrite() entry point to be how they find out
about a folio being dirtied -- and that works great!  Except that we
can writeback the folio for a number of reasons.  If it's been dirtied
due to a shared writable mmap, that's fine; we map the folio read-only
and any subsequent writes will re-enter the page_mkwrite path.

The problem is GUP.  We have no way to force the GUP caller to go
through page_mkwrite again.  So instead we make the GUP caller call
folio_mark_dirty_lock() which many just don't, and generally we get away
with it.  But it's a bug, and a bad interface.

There's also the problem that GUP users bypass the folio_wait_stable()
mechanism.  If a page is written to while somebody is creating a
checksum over that page, the checksum will be corrupted.  If we want
to fix this, we have to bounce-buffer the page.  There's no way to
prevent or delay a GUP user from writing to the page.  Enjoy your RAID.

My proposal is this:

 - Fileystems take note of folio_maybe_dma_pinned() during writeback.
   If it's true, do the writeback, but retain/recreate whatever data
   structures you need in order to write the folio again; behave as if
   ->page_mkdirty() had been called again for each page in the folio is
   marked as dirty.
 - The MM behaves similarly; we do not clear the writeback flag for
   folio_maybe_dma_pinned().

This will have the effect of writing pinned folios back every time the
inode is scheduled for writeback.  But since we have no idea whether
the folio is actually dirty (because the GUP user won't tell us),
this is the correct behaviour.

I'm probably missing some stuff here.  Let me know.

