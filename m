Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F57CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 16:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5236F6B0005; Mon, 22 Jun 2026 12:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4446B008C; Mon, 22 Jun 2026 12:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4BD6B0093; Mon, 22 Jun 2026 12:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 826246B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:54:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63B054021A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:54:19 +0000 (UTC)
X-FDA: 84908146638.29.3C96174
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C48CB1C0010
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:54:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XN8Wesbb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782147257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQRxOVfPsF5zdei5YjlXmlodQ7Ot2nd16HyX3ZqLG9w=;
	b=oE2ERyxrtcdOXvMDwghkm1wB+AO0lLK4ryLzWf1yDFnhbN9R/k9H4rFh4lFmuQWtPtlc0g
	4fOKKj72/gLIf+l0syTAjc6diM8mCSf7HmSuocdZ5/skiiUcWU21ZdJ+LlDYyCyZjMVIKe
	+96SdEIH6om/8bu9jkCRsKsZIJIa8lM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XN8Wesbb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782147257;
	b=Jz4mROkscPcVkJtZsRQ95LSsmhxQaybqP4KtiJ7vegsLoZLk2PRgHgpC1zkboVYvOq/G/f
	YrTgRcfCov6+Uj1nwwgTVh2Kny6sC6ID7EHKEP6py7KhYxKsX+9bwNq4/uL8hiIJrKe7NS
	fx4vSGmvWQDgWZkeNGhXQe8Ai1s5bUM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57B14601F3;
	Mon, 22 Jun 2026 16:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D951F000E9;
	Mon, 22 Jun 2026 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782147257;
	bh=TQRxOVfPsF5zdei5YjlXmlodQ7Ot2nd16HyX3ZqLG9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XN8WesbbvyOworVWhVgscRDeNhSgZmydbPz/p4oR7VNlhMcua0LQgNIz4tMtc5Ju8
	 R/pPzDNePrsm9XRX7YPBAPbyMKML2pvegsX4SjD+N7+DKOynfQueNX8tSXmAHWa/B0
	 JVZbQAtfIdfxEXQl9LU+Jtfbcu2+9rSrayKmQKT8C7Gqxp8OyAdHw0STQ4dxvAMMoK
	 2fWqED/xcGupntj2tnbHAZjSPhJAK6G7U09Jc1BbcBogWDG3ZrE8F29muik4Rva2Lg
	 0nZhRDTFYFUVSvQyYnXSH9J0qy1OT2u8LX+ZnNJc0/MkyNb6gyycTj3dYincWe0QLu
	 OLL1yDR4Ytt2Q==
Date: Mon, 22 Jun 2026 17:54:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex@shazbot.org>, Anthony Pighin <anthony.pighin@nokia.com>, 
	linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajlnTdkbmEzy_uhe@lucifer>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <ajQI5jMJpxyNZCLN@casper.infradead.org>
 <20260618153049.GG231643@ziepe.ca>
 <ajQRY7tHShCEz8vg@lucifer>
 <20260619131658.GA1068655@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619131658.GA1068655@ziepe.ca>
X-Rspam-User: 
X-Stat-Signature: 357ra9s1hztmphdb4gb7bxpyuhfgrsok
X-Rspamd-Queue-Id: C48CB1C0010
X-Rspamd-Server: rspam11
X-HE-Tag: 1782147257-542574
X-HE-Meta: U2FsdGVkX19FIDjx/Oe+lwsDZBwL1tE9O+t+QJTAHU9YiI2LgtqoAFj6r5Y65lR9jMJGevLu86UkfyzvHifz631wEI2K+2JWA5OXKSCNY4xCrl6noql732QtWv8yWTzQUuMgfgzkB61Woou30SWKCPvgG3NTRgq/T9EK6324h6bCs7wUj9kpEPbFrN5fi7ZDHO6B45qwQzYVADGXcrXdYGR3a6NmSdnTdJxc5sTm1MVhd/XgYjV701rBuqTMuk3+JPAlUlRA8qYSIvDfbZlR85ngRSstqRJhbXc3DngLcmr4UhE5PDVU5u7nscv5K1ZR9kpLvZY8DUd9WtoC5YY1Vi9KW2EG7LckGBOlg5mk9UwvY06WPKb+WAlcC9w/n6MS4dZnIRMs1fOHupnjYqhReQ0a8791GWq8WBENfLy36X14Po3P28vCJeP2tIwqgtmzTM6ZVrG2N5b87Ha9ddq8KJTHdXzCMGc3jQNmxCfXvo5B8iMYdQm+lDbVR6cMIeUfwg4Q6RUukj/Zmv/xm1ofAXH5gg8fB2nWd1v0hDZH5/jpXA9E/tx5Dsh6C7Zebg6v08SeAw9hH0AXONSDB3gQxRNWa5E3P4BdkoA78LS94cYvSKYupxwZr26q4uE1ALRB4dd9WYckiduALYYcKtcGP9XUG3BJVPs6A70xRRIH58MjTXkrhQkUGleg07gqEvOP4azPJKnfPD9U7mXBGFYJH7W1D/CY5UwKlD8OtVC50yGfDTtP8FLCwDT8++FFba1aQEiaTRY6BfOwd79Sc4fnmu3gdsYJhgAUQJnP/XEwJjSuHULbNh531WPoEa5oJZf4BnGUEbDwZCXcEfddW3PYUG41GYl5EHNqGuw/YNxeVXZrIDYnU1yovXvuKYqwlxB7DzrVdsuYthxQX6GVY3n96rOsBdE4kDbm682VlVZW5YY07KN9ugL7B7mkMPBKZGdRORD3eUwMm0xmCer1vas
 xGqjye7S
 QaV50VdcjppklGVQ89RpGmwedfilDN/vNFROv+D42wLgjDEX29/qDPHkiQsqdebVdM8JdG8Uc1VrwON9rxUuHg47UL4Jnr7cl5lFtXYy1PnFNwweyNZ/01sx9MCQDNVS++aRwcrR/9KfzY+n/FVLcvx+cjT0iPpmAgwTy6crH3V4Mvmf4OqagQYHn5EukbRhlMT5AoxBEjwlPV9/k5714W+BEKhLttUwnTDMm0/JAX36ohXF4W+2n9Jp8mTlcEL0ztXHiSlC+G4JExQUIqpjuv6kgFrvTjdnJE0YZ7jgJS5fl32XBdC92E7wOU8cw4BZaS8QWPNye1BUSbRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 10:16:58AM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 18, 2026 at 04:56:06PM +0100, Lorenzo Stoakes wrote:
> > > > What you're saying is that offset 0 of the opened file might correspond
> > > > to a PFN that is not aligned in any way?  I had assumed that when trying
> > > > to do the mapping of (2MB+4KiB to 64MB), that the offset specified to
> > > > mmap was 2MB+4KiB.  But you seem to be saying that the offset in that
> > > > case would be 0 and someone needs to know that it corresponds to a PFN
> > > > that is misaligned?
> > >
> > > I do expect that the pgoff space is usually aligned to the pfn space,
> > > most drivers do that or could be improved to do that. There will be
> > > some off cases, but maybe we don't care, and VFIO should be fine.
> >
> > Some stuff has weird assumptions about pfn=0 at start of the range (DMA for
> > instance).
>
> Do you have a pointer? I'm drawing a blank what "dma" is?

(I am obliged to link https://xkcd.com/138/... :)

dmabuf as in [0], where vma->vm_pgoff must be the page offset
into the DMA buffer.

[0]:https://elixir.bootlin.com/linux/v7.1/source/kernel/dma/direct.c#L550

>
> Jason

Thanks, Lorenzo

