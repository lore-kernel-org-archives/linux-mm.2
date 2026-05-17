Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA37CD4851
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 01:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2506B0005; Sat, 16 May 2026 21:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52426B0088; Sat, 16 May 2026 21:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68176B008C; Sat, 16 May 2026 21:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4A066B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:17:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 493991C114F
	for <linux-mm@kvack.org>; Sun, 17 May 2026 01:17:23 +0000 (UTC)
X-FDA: 84775148766.17.D3EF88E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 09B1740003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 01:17:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NEIkA09J;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778980641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVUG8R5Ol9Z00xWIgbyWnXRAWw9NOhAMo2nx4jxBrzs=;
	b=sMLVbme6KdLQ4F8aXEZ/DySQzRQFsjALkLlEcqmva20hW4BFr8SLkNe1s573VdDw+MtqvW
	vtkyIWHA2ETZL3JTOceITmwcQ7CwaKOZrIpayjC7/O5KdrsojJD154XtZBAcL53FCldkef
	kdwyw1/ppPqPbnbUeQDS4MvbY8RngTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778980641; a=rsa-sha256;
	cv=none;
	b=F6nRJmqwuJW6HgQbfowINkbKalof2QJJ1iRJXTdQOCa3S34wREiJYwdslbMtsDb1O9r03p
	uvNGkGkzmjTXaeJ4Nd36KgeKIyBDL8jpCXwgaaUc2cTLDH2XybTElCIRjQNsWUHR3MmC1M
	rSJhAqaZE8V6+UEn+AcJHuy5BTCbazM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NEIkA09J;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LVUG8R5Ol9Z00xWIgbyWnXRAWw9NOhAMo2nx4jxBrzs=; b=NEIkA09JHKS9iHhK0PDstOLAJO
	4poRQS5PydOp8NktO4wEHxTzKNjRva5w8io/rxe2FsWL3YtxOghY8Oo2pdvfLxly8tPAesorhx46+
	kBkEir8UkvP/0fZIPx5yI7PQdkxJXyWVGotQp411XAYLHBKwVJ7XYsM0ZFHteLRL0fWsXs/h9nStF
	oFwL81QvgpeJyeNCwUNJ6leYrobO0eIZLozBayzGXHImu0V9sbp05l4yRWuGYHAPB45U24EUJhRRp
	LD64IU0RhL5jmZLRLp5KIaVqYtCgJaPtUX4gQ/Kh7w2+Hn7UUbxe6/GpuNcZfxv9gW0dC/2hU93mc
	47EgUjeQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOQ86-00000003OQn-1PpD;
	Sun, 17 May 2026 01:17:18 +0000
Date: Sun, 17 May 2026 02:17:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <agkXHu_ON_KyWtvP@casper.infradead.org>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <agj4mXKRVW44ZJ18@casper.infradead.org>
 <agkRpj4oU8TPgmTS@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agkRpj4oU8TPgmTS@pedro-suse.lan>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 09B1740003
X-Stat-Signature: iio13rywsi5r34ufejbdjo6yjqirjgug
X-Rspam-User: 
X-HE-Tag: 1778980640-378315
X-HE-Meta: U2FsdGVkX19CRMoRFLg3zQNXe5SdKcSNm+L1Y83WaAuxGadfe1gXEs2B4C/guHz2RkEBqE6Bg5dA+p23jWqjOXwhBAAF89CnhZ/emjwhCtaXSqgoHv+JKAwb2kusCDi8/UDV6r6COFspz+vMcJdfyW0puVt71ErPr1dYG8j64uJFdfNP+reejX7L2x5c/BEV632MEbMQfehGqx1EDuniasFzWwZe+uRttPxWOtgwSKpx/6gFxcB+wIbVl0lgwPdMTVxxk19WotUVD3erJtScuKDZhF/bWAMe7CwYOioLmKyrDqAzBqb5L2nXz7XGJLlSo0SwjDWB6WjndMjzeicOBgjCtlLD9dJuXMl79/noXXnsdHh7ZF+bOQKVgpnlslSGkPJJIeNeE+3EDwC1Uvj6sYwKNiST7YWQ3FAExoL1v36+Cp+gsbifV6OClfDW1udB9Jd9FY+5kBNlYA8dJpiuP7STMSwhyKfOaOoE4CzlxwlqyYSpiXiqAA/C3J4yU4fd49c2W1lil3IBHcE3QBrkXzHFEJomfN9+NC/NcEjO7VajH3GsAStHilPm6qOe2cV6bilKyWYrx6lvD2EqkhOIp9OC45u9TeOcoj/H4A5Z881neEf5TpF61thsijkaDOC9ER2IXnsfeU+JN1k7Tf+p3omIAKsLYoYXw3A/XZ88Ih3KeAFqWvaAQzPm6yhtjUDt3PSaaHWB2IXxDz3S1S3hWWAJ98+MpF4SB6keZxdG004bvFoFJfzBclabqPK5WLH29hVmp1tf9pNDNkDUSsdg+gWv9oV+zt1SObJtZqDqdqdC78pl73xM3o14hzbgZKxLKBmqeoNv+eozSqyQRQBaeSq/KCGQA3YAQde0Jk5iXjguqcnpj37INo9gJ/Uq+MRSA/gw63joCpXbKQb8qr94tDTDUUGlqeycLEJ6J42bgZQw6whBrS4buyNQyEFa6bsqxTCqK/AVmtofsalzwET
 hplClxEz
 10qZhVZZk5/QeqSehZZKGTN/pzVoaVkQbf5Hd0UhaKDUPfJjaSj2ZzXI/hTRDE6MPDrYsASZqiO59tjuAnvF5SaIt1yDJKxbhXkpzwamWeV0wGyRo+KyOrxJzk0FEXNOcpfsttmsgm/nvT/FGK8x1I6PuW5NdBMy3Wfs08+VI3BuXQHByd1AqFQUCNXkDA+1lRvKm91x9oYSe8Y5/QAXJ/bPWY6o3fO6VGBFejv4KUggVW+dPRSZa7Z2Wi2uz+M/MMcjp6IHdacTqyLHm237RkWwMHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 01:59:41AM +0100, Pedro Falcato wrote:
> On Sun, May 17, 2026 at 12:07:05AM +0100, Matthew Wilcox wrote:
> > On Sat, May 16, 2026 at 07:21:26PM +0100, Pedro Falcato wrote:
> > > +static bool may_write_to_page(struct page *page, struct address_space **plast)
> > > +{
> > > +	struct folio *folio = page_folio(page);
> > > +	struct address_space *mapping, *last = *plast;
> > > +	struct inode *inode;
> > > +	bool may = false;
> > > +
> > > +	if (!READ_ONCE(sysctl_splice_needs_write))
> > > +		return true;
> > > +	/*
> > > +	 * Always fine to write to anon folios.
> > > +	 */
> > > +	if (folio_test_anon(folio))
> > > +		return true;
> > 
> > What about KSM?  It's not something we've seen attacked yet, but it'd be
> > pretty nasty to be able to change a KSM page in another process.
> 
> It's my understanding that only anon pages can be KSM'd, and KSM still keeps
> the FOLIO_MAPPING_ANON bit set. So folio_test_anon() should still test true
> for those.

I think you misunderstood what I meant.  If we have a buggy user which
can write to read-only file pages, then it should also be prevented from
writing to KSM pages.


