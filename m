Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE44EC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49AB6B0088; Tue, 25 Aug 2026 15:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAC56B008A; Tue, 25 Aug 2026 15:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9A56B008C; Tue, 25 Aug 2026 15:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD826B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:14:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC760A019B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:14:17 +0000 (UTC)
X-FDA: 85140742554.15.505A29E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id B585AC0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:14:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Kj68+8Df;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787685256;
	b=8WZl4Y2E7M/yuD0VejLEkjUvO3Hw/RjDxEpGwuimN+t02FjihTL90i9O5Ko2y2Oxl6k0zy
	akDgbhL7W9kcpu4rdtOAx9nZsjQ9fTJViyLN2tld/LZANYQqi/BVAAClPi5hSfDticURhb
	HWnCpOwS2sUUN+oHxSAo8ECXNa7XvtE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Kj68+8Df;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787685256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qyn5Bs3PPyuDeSA5xUHQrWKpUB1haYkwcsmOVbrXEMo=;
	b=CqaGsBPdPGfN/uc/dyL7cB3Ju+z5tUuXDgtvWqkhFcd7R7bUfpoEFHhGj5mgkBBsHEdg4/
	bgUul8HFRLEchIRxE0xiNtnuOfKSPYHmmTQ/hdGq6K7geBwea5y8vbSc94SIThYMPvEzv2
	mO+WcgpRObrQ3P8wuVGpFcB2M5pfCnU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qyn5Bs3PPyuDeSA5xUHQrWKpUB1haYkwcsmOVbrXEMo=; b=Kj68+8Dfk4HZzgB1WdbRbLhwH6
	df92mqmYj32/te7T8+qREnij7Pl1gR403+AdUFKxsknUKEu9L3B+KbU/ri8eeASHVdOsbeB+0HJ2z
	ZAeQx7c8RB38jNBfwcBI/K2trrKMnCBlysyohZV3Tmj8uLWvwGQfAUouKKgZwQ2LzIMBl7y1Cd64t
	x1FLFvd3cQ+zu7+rqgn1baZqLS6+GnTm6EABlcWadkzINYra3mb4d6WubH9cd5d5dajLOktQmaNLK
	dNMPLq6k+9WqEYOt0SMP3N/eikoYIc20jPHEw2TgVI6blzlUYKsS4h1Id17VXjkCUwFXzSiGwR16p
	o4eU33rg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wywb0-00000009aFD-1haE;
	Tue, 25 Aug 2026 19:14:06 +0000
Date: Tue, 25 Aug 2026 20:14:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3pfoZbGl50nGN2@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <20260825073918.GA25441@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825073918.GA25441@lst.de>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B585AC0007
X-Stat-Signature: bspewr785ozbibripmdhyzmrqqxj1fpe
X-Rspam-User: 
X-HE-Tag: 1787685255-237609
X-HE-Meta: U2FsdGVkX1/voENEPwLOCrHV9EXeIu3NjPp/u2Wwwc/3gb26qnJZ+IsuTp1GbZqXfuNJTw3VXCHSWRcETvBObuLdBs3r1Hi3qEh7QSoVS4k9S1Dv5oSIJwBF1RL7KrhvuyTmEIfKDrsfgmedPqgkrtHvcdOT7I4c7ETFnvammJ8ZoD8L1w17xWZ8plTEloZXbeh2TYDIIUCtlR5wx0l5yyS1VUf8I3PlBiRsjDNcKGzw5U/UNotj5z+SFjM7llcTN8mmT5FrAlVMFl+M/hwqcNaAjzDH6pkzlaFwi+Sa51Gaqux4CmufZ572TMTV9ZAWqR3Fd6aAX04dkMiuMKAMgWGxEtsHsGDPdPJLI8TdFbS3UZZtnshiEfA2T2bwNOO7hjRVCPE4ZP/4KVbGGE1p5rA4gp/1sf9XKWhoX06O1WiNUffv9pnYHVeC+av6ifUcCk8yNCIlIsl4op4J6Igru7S2/fVVIcP2hzvyhkxIHoLVsJDL7SAilbCq2R/djp1W6kIbByYwBDO02kBPM1LAC17OJL/w49H1AZ/WG0csMtBWYpdzm6V+/mSPDUK/4anwV+CvUFuId6vK0sIpENx08nYFJ07sJRxptoVoi9BBHJTpv4HX+P6rZmYjVFu90Td5qMoEuxmFh/3rjn9/wUDMKNvDrFDvGZy0sbHRNMGLaKyjWWBBI921JxxRpEdPFTvd/fuGapzTR4lUAJuWhEBcRfivzxUl2J2SJb5wdCzd5r1/ZSDddkvNIGJfiHvXk6Ez7jUPr0GPRgQbNvSa6mHn3uBEYQ/ho8VZcrC9k/Ty8j5J0SZOXKG84zdlX6T17SwZS+lIx+Yz/1nMQQFwDIStY9k4im6WZ66q3UsLbb2xnUs9o9ynrfv3S4EBeKSp+JJRpJ+g3hQm2sBA8gazsbP2B1mw52OWCPBzTczmdh5htWg+m5t5Dd77BPayfeVBbNvZDU0J+Dvck4WtW90B7uS
 B32W22K5
 zAuslrzrciTG8vajFPgKr+qXgT3KIc7XMgFaw4m7/6k2FoRdfkO+FSDvn7Ve6Nk3QTm7rB5EwBw8UOr65s+Ql3/qLrmMTdf1seEbhPETuRrqCG3bw3iPMYV3Bo6d2yo6BOYu4HMSoS/YebCRrQ9sJyc6XfSsjqGCJGt2zoTGnDsXIS34+AC4EmPyiryd9bAMlz7tgmgIAp2fXVNmC2y0gzAq8YcQqfsClu5DSyuevNHVlERqt2p7B67SPIkyJehNO6Sxcx+lmRVJdWwRCNE/UiN7d4w8srgnKW47X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 09:39:18AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> > My proposal is this:
> > 
> >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >    If it's true, do the writeback, but retain/recreate whatever data
> >    structures you need in order to write the folio again; behave as if
> >    ->page_mkdirty() had been called again for each page in the folio is
> >    marked as dirty.
> >  - The MM behaves similarly; we do not clear the writeback flag for
> >    folio_maybe_dma_pinned().
> > 
> > This will have the effect of writing pinned folios back every time the
> > inode is scheduled for writeback.  But since we have no idea whether
> > the folio is actually dirty (because the GUP user won't tell us),
> > this is the correct behaviour.
> > 
> > I'm probably missing some stuff here.  Let me know.
> 
> We've been through this a few times, I remember me and Jan discussing
> it maybe a year or so on the list last.  This is what I remember:
> 
>  - the best thing would be to just not write folio_maybe_dma_pinned
>    folios at all.  Jan brought up cases where that might not be
>    possible, so we might have to write anyway.  IIRC the major
>    one is that we actually do allow FOLL_LONGTERM even on file
>    backed mappings, and those could be pinned forever.
>  - when we write them anyway we really have to bounce buffer the
>    data.  Basically copy and do something like in-kernel direct I/O
>  - Even that can be tricky, because we'd still need a space reservation
>    for that write at it would otherwise consume the space reservation
>    at dirty time, but we still might have to write it again.  One
>    option might be to only do the force bounce buffer write for
>    FOLL_LONGTERM as the others should go away, and FOLL_LONGTERM
>    gets a call into the fs to reserve extra space.  This would not
>    be enough for a lot of writes, but enough to allow for
>    "bank switching" over GC cycles.
> 
> So, not perfect, but probably better than the status quo.  But a lot
> of work that someone needs to do for being a bit better than the
> status quo.

Thanks for summarising the previous discussion.  I understand what
you're saying about the space reservation; that's why we have to
bring filesystems into the conversation rather than doing it entireely
within the VFS.  They have to know that they must create a new space
reservation immediately after writing back this folio.  That should
be feasible in the writeback path because we're not under any mad
locking scheme like holding the PTL.

I think the only disagreement I have is about the upsides:

 - Filesystems no longer need to implement ->dirty_folio()
 - The page pinning API becomes a bit easier to use (no need to call
   folio_mark_dirty() / folio_mark_dirty_locked())

I'm just trying to figure out if we can do this in small chunks, or
if we have to do the whole thing at once.

