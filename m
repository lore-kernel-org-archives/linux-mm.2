Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F03AAC61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E3B6B008A; Tue, 25 Aug 2026 15:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7ED6B008C; Tue, 25 Aug 2026 15:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96B76B0092; Tue, 25 Aug 2026 15:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5C226B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:16:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14DF316018E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:16:17 +0000 (UTC)
X-FDA: 85140747594.11.9322A3E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0CDFF1C0011
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:16:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=G09TgWUe;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787685375;
	b=AlOIxkeRStG+Kz51zEvwPuJ5nh4aGFqKkgQZygIzFYJ7ASHXWHc7W6DOL2ubg8Z+UPWOne
	xnXpHVYYVK0rM0/LnxMUyhyB5o94Yij1FoYZuu+51I0lqXcIX1E31myUf4PQ5IPdaQHk6Z
	JmmR/lK3RCzZ5M//PZsP6le7xRHeJVY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=G09TgWUe;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787685375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycXANbtGC0cUw84iuY50XDEeCaFMT6BdiIVSuYymPl8=;
	b=fk3Z92OPFIiGri7HIBmsojbvSdgTv+vqPgBYJy1XXt9LuxQOPvWNwGV91EecriL33YEaIo
	Ka+dgFxsp1/dSiW3nN5N2+5sZduWdCNExhSAhlJmCKERgqyHEW4ygVZ5B7ei21I7PEHcsm
	Kn7oygSeUes4Znmk1Kyue3RzgB7z/V4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ycXANbtGC0cUw84iuY50XDEeCaFMT6BdiIVSuYymPl8=; b=G09TgWUeIwSs4vxXpNMyxpfWFu
	2vfuSKgft3JGN5DgcxEAP8qFTNiz5/q1nWpCVeG+nk/0vQFq7MTEXSrAhrlMKp5xnLlcGWBXm3ASp
	J/MD/QHCyS3Zql66PM6J0c1v65m5lQWwOI6xmq/vs1ECTRmGMpaGVBuetOkRG5gEAUpc1HDSp5n1Q
	fHu1OIqCVnFidu6LDjAM48gUzdzOXVY65VQWr4zQ250pcAgKsVdkC2hExrCPKcSKtQSOqKx4FqP86
	FCTZr1gq6bfKLYRlJgkgMA/t61T4tlKRoFa71LU3P6aue9NcBTQbSGDGNcpVlw0bo1gUCQ5XHqc09
	TCV+qAZg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wywcw-00000009aXy-02wf;
	Tue, 25 Aug 2026 19:16:06 +0000
Date: Tue, 25 Aug 2026 20:16:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, John Hubbard <jhubbard@nvidia.com>,
	Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3p9StpLtZloDcT@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <798622.1787640486@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <798622.1787640486@warthog.procyon.org.uk>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0CDFF1C0011
X-Stat-Signature: 8tcaj5wsxke984b7y3en45jcp5r1idbh
X-HE-Tag: 1787685374-101654
X-HE-Meta: U2FsdGVkX18cSgufM0LUBiLfsqk54gBJdbfKS751epO1uMbSE/f+cBeU2jbdkQhpimIcaxKStV2sMh7rG05UUTRltd27tb8NwCa3tYZLxjJHbg9VEtjvWcESv95x44OpAHyZbl+6Szgbup5saG3Pf2Tl3hFsrw0MwS0DdcfVRLcTvnsvSHklVyPM+xMo+jb8+cgSxH6xPyD9h0hSXQ6+63TYXKblE65/Y7OVrmbATBJSOPoxplm/KA4TIinaZuY2RRmQPgOh/bfpGApDhQtLR6nhIpGeUQ5TIvzg+nBBQIxB/9IPDCK3PgzCe1Y7W2zKgcL+rJdiTYPxt62e5PuY9UOdXSlAEOWPP24Lkal2F9zt6wcbScYFT4mPFdPht9nSSPpmbliohHN0xvj/pe9NzMxKHlAURvgVt+LtxDxqQTJ5FXxc4EgEV/kW5387LCoxM7Jb1hiinYDEKdFLZftV3bLZXGvq5CmQptQym8C3INK9sP8QGmP4TcWqcxsDDhjiVGdpVKDRImntk37b/w+kKm/zQeod52GDNDXPb1KU3j0RJHT3Xex1594hg8ZwO1uwm5EJYZqWrOx5KNOcvzFjJSZJTstUwdLprmndywCUEJ47M7XFbSqpbED8n+PV1q7BuUeZ+1u8nl39pbk0LE7jZAMX6BAQzQGrvtmNCPXRpGUK7Y0sOT27dDCqgPOL9rmxjQxRVP14tlEsbZiHvTDI5P4ld6hdOpQZPO2EqXO5yaYgBQotEaAYOsjNjTTQxrU3zKI3ikFZ5d30gaECMdRgB1nPRxPJBYgCRrMdgNiy6+OoJZE6OO3cTGbCaQMwolTG4UVX0go3ZdDHDYcAMR3j9wpLtl5EHgBoBE3lITUfBNd9BwUvD8EluEnbKvwIXHjC6G9IlkEOqRX+qV5SBuQxWkEWFCwCLe8F/HntbuJsdY2aUndbZw8sY52gQXkQJCkUv9rGdrsjkFmmNms8Gr4
 07XvbL3P
 1D9YNhr5wfDgYLySkc+RhKFkwZ8pBHVywOgW6M5HIQByv1BZISMOQLk12uvWAMzGSbwpodE3k6A6XRhFK1eCb1as/yOI1612n05/+NGDy4LpZZIJukfpuCQCcIMbUsWINxCJUYenJtAooK01X5oruJ+pyDVRC8ZNiN6PAvIe45umG4ceifVw2wCMKxUKiiVypQ7jTkJ0grJ4DdEHhOFKuVUixvIJO3VEkKYgn11/lORuOMcPydgS6kA27sy9gNVNvjufE5RpxFup9UWxeq2OX4wmGUkPoteqWDkCfnFOX2BeFE5HiqUgpts5NXU+WUCdHYJs4+XbF2OOlnZY72bua+1QMo8v4fKqk6hwz7bLB4mmKq4sj/L8eOAcUVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 07:48:06AM +0100, David Howells wrote:
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > I'm probably missing some stuff here.  Let me know.
> 
> mmap()?  That usually tosses a spanner in somewhere.

Well, you have to have mmap()ed a file for GUP to be able to happen.
And it has to be shared writable for us to care about writeback.
The nice thing about GUP is that it goes through the normal fault
handler path.  The nasty thing about GUP is that we don't have a way to
revoke a GUP access to that page like we do through page tables.
> 

