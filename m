Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B17CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31116B00AC; Wed, 27 May 2026 11:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05E06B00B2; Wed, 27 May 2026 11:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45266B00B4; Wed, 27 May 2026 11:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A806B00AC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:59:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 600BC90791
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:59:40 +0000 (UTC)
X-FDA: 84813660120.22.90F6A90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C89E7180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:59:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RYqc0BD/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779897578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ky5x6VV8bGsiRibL4Mbeireh2/3HHtZ2G1qotL6tKkE=;
	b=d5CHsgpj/RF3994qZEw1KJPmZH9XUjkGWGmbJy9GLtGnoS3JY7DoN6Pts/vDlph0g2virK
	NYlvAXClrTL66XoUF+XjiUKLgQp9QCHmXRD/6JUywUMfgx2Z2CUn5zVtFIcCFxWjdT0B4N
	DOlUkWKm9hDN4RhtLk1ROyEvGPaWJYg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RYqc0BD/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779897578; a=rsa-sha256;
	cv=none;
	b=0dPo4lbd25GZiNW8TlZliuMYjaA5MvJ2oOWWtfQ/6kX7hePoU3/Kbru7ZtMcPPwt0U4s4b
	pphs0Edil1Jfusi8NMU5hYCm9TMcW3pvrNQ7hds3O4Z+h/e63yYpM9+Qe62MF8fPmx8upC
	L1f9buiW7+GDR+V8fXDXEsF++iVIhYw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 210486021C;
	Wed, 27 May 2026 15:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6866E1F000E9;
	Wed, 27 May 2026 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779897577;
	bh=ky5x6VV8bGsiRibL4Mbeireh2/3HHtZ2G1qotL6tKkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RYqc0BD/c9Rk6VG80/Ku4juq+/5NhEA9655oRwH1Wmuep9DRWmqdGxTBZaGOAbx4c
	 tAWp51YEvq1+8lth6riLToTePL3f5jhd0A9B+eajyaSW8fHPYWYjSs9849zYuwPqKi
	 SkmrQ1Sj73F1X2nwofk44uZKbCtcjtNxLKSdqk50qPKRabEVz9ZGdCeRb9P/jUX7Gp
	 ROw64V0uXEJeCATrY80FENgdTyVVifxFzRe5FtVsGqwU6po13npcbonInSgIoCh8L0
	 uwTj53KmkgZ1MFEdp8hsLXFebtZo4DHZROQbE1pFiS8JcRGFroxsy56nkfPhdv80xj
	 RmK8vLj9DyWvQ==
Date: Wed, 27 May 2026 15:59:35 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Theodore Tso <tytso@mit.edu>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahcU5xbVy7xjps02@google.com>
References: <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
 <ahaPDHiXcJoVShPv@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahaPDHiXcJoVShPv@infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C89E7180006
X-Stat-Signature: 8khkypu7psjhjwkutkt6qgoj4qio4mwd
X-Rspam-User: 
X-HE-Tag: 1779897578-28229
X-HE-Meta: U2FsdGVkX19VuYFtselQlLojAqqJRp/bi9duyHjKs4ARdhhHcSwOuBALZd2jkERho5vtvgC2Q6AMiKgq0QdTuOStLpS1CV0kGr11fgnBaEqQBK8a7rfBpWjJx1gkTuelx0QqYVj1JbfHaDIrNeX2K1deAAP+V5EZ6G+XN4VSc3An++FfdlUvL6hTKncHG2Zjf8bDgzKjcoLjagyTG5qCdM+XUG7w7X6Ony7mzcp/oMuw3OOZhFkdvhCMFLHoZ17sCD/UTa+kL2kU+V0roBNgdOd7idT4O/+o/FTmaowTUIeJmSjyCLAGXKTgNaBSgMLZsRGzoF8eBfICTsZmB+5voa0GpSn67/gM/DrKkdt67oBd7dCbTeZ0YNT7ysrgQTqTj8VqNYf3+fAqTqPxCnIN1l8cJulHY+UIGNBxGQ9RFF7aR2mlMJQI7p47doN6e8CFMThB4qHYfqdloJ4yhHYXY/km0R//30GnK3ro9BPQVWRZNki4shnMFB0c9hhMxh2vayT3iD0VBIl81p2leZ2QO0x7B+fW1dNaGtrVMYJO1UvXlUZwekayr1LMR4WeY5ZaaQufzbusTmXBGDk7Z8CNOKCRBAwyE8gPsEc0Nh3h0yOE63Z37u4KSHs8plOLj96C2pUhAEg7NlsYIp4wV/Y78j7ctdtMW0bLlGFRcP0n6izCTX+5jfVCWmOmlmMwi11Wsu3t7mG8zecXBuog18PHvBHilFKhUfPAwIkA6Sz/aO6DHOTg1boCGkKccRZuYnD/SgWGOGMohp0EJy33VcFDwHAZMZo1P/avfD6J3DACn8OJLBXuiYFAmJx53IeXYRIErFRGBUtwFybGffkGa8nlxdUkbZDyQejwbGjK9CTp2Mk3Ar0BXcb297fe7Gmm6Jan36godORwEmXHyWpSRG/dywPE3+n3HkvFMy8lauvkU2FjXt0mXL/uwlkE1RWjmmCrbmIc9F7VSzqtedbX219
 B3doZSPQ
 Cobn7h69GKIdlp6VRsRVr/FAJbFpSXWVJb1bHvUCwFu/NTLHutC7ZBQFyTrkGIRACOVLAreR1Pdi1afhVzzCKYFDMUsp7Rt2qUw2+uW1AwbPBHlQarhH6GYeqci5F18rFOk1ga/mq1xvkry5+pSazsMi/E25AmzDvMDNGwwLAhVsNYM7KbiWx5e1RFVtaBxaAmXBaRZ1oI1tHE+Uf83cnNI4Jlbphk77WkzrPRelmwpNXpsl8Nz/mGRc0qY6ORIo9S0VfLSvX8738oz+2i9dKUq8eBQzkbm9Xh2KGfB1lEK7tYxlEn58MLtRfKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 09:14:52AM -0700, Bart Van Assche wrote:
> > On 5/26/26 6:42 AM, Theodore Tso wrote:
> > > It seems... surprising that the additional I/O operations are actually
> > > throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
> > > into why this is happening, and whether there is anything that can be
> > > optimized below the file system?
> > The layers below the filesystem (block, SCSI, UFS) is what I'm
> > responsible for in the Pixel team and I can assure you that these are
> > highly optimized.
> > 
> > Since the transfer size used in Jaegeuk's tests is much larger than 4
> > KiB, how many CPU cycles are used per IO by the layers below the
> > filesystem is not limiting the transfer bandwidth.
> 
> I'm honestly not sure what discussion we have here.  Larger I/O is
> pretty much always more efficient.  If you submit smaller I/O you
> need more merging to build it back up larger, and more I/Os.

F2FS merges bios before submit_bio, regardless of small or large folios,
since the block addresses are consecutive. So, I think IO subsystem was
working in full speed.

> 
> Which is exaxtly why we need large folio support everywhere, as it
> makes a huge difference in I/O performance.
> 
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

