Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27E2C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A711E6B009B; Wed, 26 Aug 2026 04:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22806B009F; Wed, 26 Aug 2026 04:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FD26B00A0; Wed, 26 Aug 2026 04:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76D3B6B009B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:01:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 135D1402F0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:01:11 +0000 (UTC)
X-FDA: 85142675142.11.B47A168
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5662D1C0012
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:01:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=athR/Z+2gnZeAvsr3vG3jwtyXdiVDsk+VUL2F5u3F9U=;
	b=RYCUuXvBOxc/bvrOpq/rq2NTL2c4G4yuCxyj2uhy3guwQTnT9TQ6qHXjZ080To8U7EZwdT
	Gt38WcpDtpy0blOW1Vicj/Ovl+cbIqAInfiQfQfN329eGpg82eFS8RttIuhUC8f7eNVepU
	KQsn4GAmHLlK3yibB5skCch0ZwxjfUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731269;
	b=aWMntDHZ3hwrSXWyvbxA/5JJhA2MMrpSPtZmSRXevGcVmezh1YgHalcnss0yba1WNzh6aq
	ZHkUGExk42iXTALkhzIznj5+XziPVWBJt3oddqc9uekHRzxT64W3Y2kfWBUtdST5fQaKHT
	l6rO/Rwjyt9WOmxXV9CjfrMIHHm0cyQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8F0F068B05; Wed, 26 Aug 2026 10:01:04 +0200 (CEST)
Date: Wed, 26 Aug 2026 10:01:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Pedro Falcato <pfalcato@suse.de>,
	Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826080103.GC19050@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com> <ao3sgEET8GuY7Rw2@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3sgEET8GuY7Rw2@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5662D1C0012
X-Stat-Signature: iug54cdi6xh9ef3o917mukton3skc31q
X-HE-Tag: 1787731269-183392
X-HE-Meta: U2FsdGVkX1/+NGGSou3rzQkXbg8DEXLuoj/RNbnLC09LRwomPhhKoxXc95dbiqPRdBJEaHNspYHPdJ+m+c5ZiByYAxhhqwEGg2PGNEpsEDev7ZFKeOAcitve1ml1Ks6hjYhfIdDNOzzm3ijE1vMhGEr22vJQFJpDXnbiPdAfCFwoL6Hl4D6bsdBawrpOeA2G3MXuKWKeP3lvoZ3qZuC5WzGBTkFNMo4U0EUepADocqTFfyeQ151rRU++oYgATvSMRS3jfII1jZnjZSHiJ6p20J9SNm06JT/Gg1sFXIiOWXALN5HJOT6so40uuaoW9tRRw4LfpQDGJCoOSeV00qF28AQwDtnzffwlVKO9Rmsy+RAc7mSzhZs8PjunsHdkF1QcGFnz2IZ06MG9uoFXSilHtUmU3Ubj4oDHwOkv/i6cfFfxZBOaJOJ69spx1NDSGeDFf9YXAsHKGF/FmWlGjQYqRUnTaGV56owp0xypPgE1cgTbN6URpG6EFxcyDpOlgjp8l4nN/xDgNREACpP5ZYMEbNVCQquTE8BIPhMoMwjNmRG6yG4Z7BaT+cgqDbe021b3LeM/22M0tefcWILrHjBwlnAOvmoOmAm3E9oetlidEMrwgdXnNrHPAKfZ4GwjjHYXIV/LhcCArorn7fSSaUZuGmXDxc9vPyL/CxJMeIBosrDbVvq6w/wrylIq79rB7kCobcSU5br9NS2hcKyzjkB9+u7L4mQnsFPi1tOiinhUzqYeF206K+9eKIoIRHn1Y+5iDSw95NzVRTYNA8owJhQ7KjSRSJDtgwOJtgfDZ2/H0jmO4ax9ACuCMAgaYtsbst//53XLYkyGvo49D0ATGHNp9Mk5Or2LoS4zF6Loz4B+ARFd2rIsj0NELCfeDguKwQuwrhx5xt0b1YBgZpQRUdem6PUd8UsjymlDldbCRwY/JQRGI7HipuKOrf09AUIBOswdBsON1qIn7b6AG8U/Vqt
 bWbAGsaB
 6vDNbc9ltPpSGM3HL+m2lWWbwEZdfHZuvyEFXqhWFStUwE6P/AdpwwQd3iS4L0hqG5+DZN+PYw+ZXDMQvjyvsGzTC0vsiIrFY3KB/x1nEwBgi5kHM20/2qVPGGXLhW1JJjTcBx47pcKKqLDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:26:56PM +0100, Matthew Wilcox wrote:
> > >     ->page_mkdirty() had been called again for each page in the folio is
> > >     marked as dirty.
> > 
> > This may make COW more complex.
> 
> It's probably wise to be explicit when talking about COW.  Anyone from
> the MM side of the house is probably thinking "but this is only relevant
> for shared writable mmap and we don't do a COW".  You're talking about
> filesystems doing a COW of the on-disc data, not about the MM COWing the
> pagecache page into an anonymous page.

Heh.  There's way too many COWs around (says that one on vacation
all around lower case cows).

> > I'm not sure if we will have a good timing for re-reserving space inside
> > btrfs.
> 
> Why is it hard to do it immediately at writeback time?  I think you're
> in an even less restrictive locking environment than page_mkwrite is
> called in because you're not under any MM locks.  According to
> Documentation/filesystems/locking.rst, ->writepages is called with
> absolutely no locks held.

Re-reserving can fail.  So if we want to be fail-safe we need to do
it ahead of time.  Then again as per my other mail we might only
have to do it for long-term pins where the place of dirtying is
explicitly controlled.

> 
> > Would it be possible for MM/VFS layer to trigger page_mkdirty() instead?
> 
> Actually ... no, because the VFS no longer knows which pages in the
> folio are dirty.  That's information the MM had, and communicated to
> the FS which (if it cares) has stored in its folio->private.  But the
> VFS no longer has access to that information.

All of this is quite a mess.  We'd need to allocate it a head of time
to be safe, but for that the file system would have to manage
multiple overlapping reservations for the same region of the file.
Which I don't think anyone does right now.

For RDMA/HMM we might be able to tell the file system ahead of
time with some rework, but none of these good ideas are going to
work for vmsplice.  So the only option is to grab space from
a reserved pool covering the max writeback size, which can be
refilled when freeing them.  Assuming we can actually free them
an no one took a snapshot permanently pinning the old blocks in
the meantime.

