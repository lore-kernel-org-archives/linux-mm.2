Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA194CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41486B0005; Mon,  8 Jun 2026 10:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1B76B0088; Mon,  8 Jun 2026 10:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07A36B008A; Mon,  8 Jun 2026 10:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B13266B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:02:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5088914011D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:02:27 +0000 (UTC)
X-FDA: 84856910334.24.43B96B7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 942661C002D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:02:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ND9GCJrh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780927345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TKX08CRvSuVhFmNgIKWVRWM8aqxu1xw/8GwzDfzCGs=;
	b=nmjl7AtFTZl2rL+cknZed0JzLOLRatvDubZMN66+tO3PpWnBCfN2Qr4K2Kr00LR2XTi7M+
	yAY5iPJQvChtXGyjuo1I8SCQ97m3RkuQWG2d/viupQTr+FgT/D2ttdWib9r2y+FRUTVxcC
	ol5ozQ4T3o0gsS2VjaITUmpASLMyTZw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ND9GCJrh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780927345;
	b=pQm9LlF3nKi1TxGc87seKOnBEKW1zVmQ9R0ZBLh3hAPXwYL574/ESjewzHWP3Gsp2B42xc
	6FAxM2XIXudREUoHrWRbe1OZRwqVDuNBpBXVv5L0N4a9kDFzbl0dme+pf+Zjl4KuSj3CPe
	CBSZkegGPVf2pkxPDdjrjauPHmQ+x+8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8TKX08CRvSuVhFmNgIKWVRWM8aqxu1xw/8GwzDfzCGs=; b=ND9GCJrh6SNtQG54pIYuK4w2fI
	ETbp1GJ4e0SLbi7ZtSchnZMZAr4RL0B+lnYdV19bIXnBFZ8d/GBx4ffx2J5L9bfU3FZcaTWgwsgiD
	lKJpZFg3hxJlNsNX7623F7wCyGQAVgdRmvpPz0QFG2ak5hCB1cAMtrQ8KjempW40+bZdZvK28llh4
	CkAzShCEhPOpmQaossI8/cZhi9RpzJH5nhglwBpphiQsdrxrrf7QGvKFecjHjOMcl9zJtyD9SXFnZ
	Rme/IiLM3gShCr3vNZcKvomSdQZuxgX/lapZyqM5NHQHzNr8ezN7NAynIxF0Iw/hCJxIvGggTUjve
	2T39L6Mg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWaYY-0000000DodS-0Baq;
	Mon, 08 Jun 2026 14:02:22 +0000
Date: Mon, 8 Jun 2026 15:02:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG?] invalidate_lock not held in read_cache_folio()
Message-ID: <aibLbSANZh6ijw-h@casper.infradead.org>
References: <5ca6512c-bdc1-4620-9c99-c7525e059099@arm.com>
 <aiazUtNaS5mVlaCy@casper.infradead.org>
 <903740a1-d48d-458e-8fa3-c129c68b5390@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <903740a1-d48d-458e-8fa3-c129c68b5390@arm.com>
X-Rspamd-Queue-Id: 942661C002D
X-Rspam-User: 
X-Stat-Signature: tjziyhdrch639m7cemu8ddo18rw86cnk
X-Rspamd-Server: rspam09
X-HE-Tag: 1780927344-705071
X-HE-Meta: U2FsdGVkX1+lde4lb3h+9tygpxNHps3Ci8GlgmR2ZHSyasWs/sAwR6VTFA7GlnRYAFTA9fSKW4pxP5Mt7C8mpmjmjCP45r958cJpQe0cUjbD+HNGHLAYwUfhbf4mbsLRBiXwYpkWDmylPCQkU0wy74C3hnUxuw2NLwDfYnxlHGD+3fYNG+dP5RH5fWAyrZJaY9xFqAro5e1WPhsPaMN0bMzlMReGmQeHgRQaAFHBM/Td7Xx1TJZSlsC20SzrdiIDRZ6AXQt31+b9OzKAs1tao/EFYBp+Y8mxBqfrmsH+xPvOHZUhsb1maEKctY7JegKzUroCkL7RVVQxiVM6u0ixanqzOKpM0AheBwGNLIXuFV9IBFVzDm0j1hUdhWWeQYZ3/mH2JFT3bKUfe4BTEJdF2cOG73iX7xmw2rGYGhcarjfJZzEldD3pJSyWeAYcFfsYifoox26oinLjvsoE6iTkuLNT5IMrMBWHLnNhHrDjcuJfFFf6y/xf7QarWG3Te4bQHModPg0kpxBoS0zhZKYsy80++emJVuFD77jp4D+QYtc1zPjnIa+YAsJwidjA0EG184+CvaxWjDm+MxCDOhn9zpcu/tvP1hHTDHXePfLsPKcn7fYbhOQ4AybxWvwHaIYIt/H96kIxnD5067znUrZYFD7R3waJVFUScsx8Mk6rJWtw26J8nHvQDslWmScXUgMhT7nwuNcpgW2Jqa8pajuYJXLUbMc1qQxB1MujPdAbynPmL2qGy6TeoYhWXHYXeHXili7WjndWtLI51tJQpwVOUdocZUihUPYz7pat2HdXgHCPK/dG/MtdsqK2Kn/voOfhv+7i3UV+ebHw3DY1/x2I9755CGx+kjg/G4Rl2r4hMXTODwYRPLrrKIYu240bV329sx8oeXlBkZWvAZL9lONn6qP/m1Iupsd9YsKufI/Wq1s50ApwUfrL/cTMzs9Cy9+pcB2l4xyPvy24nlL8CCl
 tsBpy7s0
 /mU16ZBi/ik5rI52DIfSu/atfviawshn00FXV3aFSxI5PuXyN25GG1gjnzSNsCJoYmGK+bdBOutTdXX12bWd15nj+ClvkvMwTQYHlXloAK4NPcZ10eU2dlBTMIMkCndMNICFN6Jf+n9zZQ6EiOsUzTYbKxO16I373VrDQZfgBCxJ/hjuDE0VdWoTzSl2qFK48LHJooDcgBEmTNyZZctgn6tkL77Juyg2e9O5q5Ay1WwzC/UYz+V5N2GeeCN0Hvr/V0+mucqYEnTCWilj3ym66ImQhtUEh28N/UwMfJmhcNyOcJBY/p1J1ANtBlYaE7dxjCQDYa41vnbKu9fI2yr1pULJQbPtmRU2SrE3l9jjYkcmkh5TRHBH9IbKnQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 06:59:46PM +0530, Dev Jain wrote:
> 
> 
> On 08/06/26 5:49 pm, Matthew Wilcox wrote:
> > On Mon, Jun 08, 2026 at 04:54:51PM +0530, Dev Jain wrote:
> >> Hi,
> >>
> >> My understanding is that there are two ways we are serializing against concurrent
> >> addition of a folio into the pagecache (see 730633f0b7f9).
> >>
> >> The kerneldoc of read_cache_folio() says:
> >>
> >> "Context: May sleep.  Expects mapping->invalidate_lock to be held."
> >>
> >> I put the following in __filemap_add_folio():
> >>
> >> +       BUG_ON(!inode_is_locked(mapping->host) &&
> >> +              !rwsem_is_locked(&mapping->invalidate_lock));
> >>
> >>
> >> And got the following trace:
> >>
> >>
> >> [    0.115587] Call trace:
> >> [    0.115686]  __filemap_add_folio+0x5dc/0x680 (P)
> >> [    0.115871]  filemap_add_folio+0xec/0x2d0
> >> [    0.116031]  do_read_cache_folio+0x144/0x2d8
> >> [    0.116194]  read_cache_folio+0x1c/0x30
> >> [    0.116344]  read_part_sector+0x4c/0xf0
> >> [    0.116499]  read_lba+0xb0/0x1a0
> >> [    0.116627]  efi_partition+0xa8/0x740
> >> [    0.116769]  bdev_disk_changed+0x238/0x620
> >> [    0.116939]  blkdev_get_whole+0xac/0x100
> >> [    0.117090]  bdev_open+0x280/0x3c0
> > 
> > You can't truncate or holepunch a bdev
> 
> Yep, I realized that later, thanks : )
> 
> Just that the kerneldoc says "Expects mapping->invalidate_lock to be held"
> so was wondering whether this comment is appropriate. Difficult for me to
> reason about that since this goes into fs/block code.

Yes, you've found a documentation bug.  

+       BUG_ON(!inode_is_locked(mapping->host) &&
+              !rwsem_is_locked(&mapping->invalidate_lock) &&
+		!S_ISBLK(mapping->host->i_mode));

might do what you're looking for?

