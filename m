Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883C9606A82D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F046B05B3; Tue,  3 Nov 2026 05:50:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F466B05B5; Tue,  3 Nov 2026 05:50:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C496B05B7; Tue,  3 Nov 2026 05:50:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76FEB6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:50:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCC4780304
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:50:48 +0000 (UTC)
X-FDA: 85393489776.14.E3A406F
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf12.hostedemail.com (Postfix) with ESMTP id 06DBF40007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:50:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793703047;
	b=6pT0/Q6wDw8xi+14I+/QLj+xmdI3hDZC8MH5PHZsynpK/eskoSfPRiC3c7XeLp4pbx1fIp
	AXLaeKP1cLIGEsujo/tkUPIqV//i4/Yw2Q2trf6P7F2Ug0mmGi1UxvXXd/MUVzZYaTvYXX
	bnXT39c1RH83GlpigBGCaS3AH11d/dQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793703047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f/R88vgW0ovDUfLzxlud9DBVXC7y/E2SblSvUAHW808=;
	b=00LxP4RTKZJ/vS9ZxeJotEBKcDO01G6fk7Va1PgPQnjjjG/5NIRjU6pH+4zPKCOh+A1idz
	Eced2RpXI0GzzMQA0Y0jHl25HhDVgfqPLiXRCuA8VfdfiR82UDGdXNQfhTMiiCtP5fs6zz
	mzYkxXeeZ1maZanQCWCl5W0J0OUOcJY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CDEC168B05; Tue,  3 Nov 2026 11:50:42 +0100 (CET)
Date: Tue, 3 Nov 2026 11:50:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v9 4/6] mm, iomap: keep a partly covered page until an
 uncached write completes it
Message-ID: <20261103105042.GB7296@lst.de>
References: <20261024221152.6965-1-snitzer@kernel.org> <20261024221152.6965-5-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261024221152.6965-5-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: q46w7oa18kmemq7hm1dbrd8uks63boct
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 06DBF40007
X-HE-Tag: 1793703046-93339
X-HE-Meta: U2FsdGVkX19rKHSnJelH+b0qzgSxCDUtJqGHMDNWohLbY4vUWWpMSdsSvRq4mE6g1iRYsu6f6hyHr8QiDcBfsQReTLjDQl8CtcnFd1jvaQNAi01x3VgHTkBTTilNVgmCi5OWiKNwXG410EYzgHe+U+82xc4JLpJbN8lkb+vznoA9+JixQsvlDtoRIGiPAtTguUrPNfuG2o9m/dIgYWAHLPdFLCzsMgx0iAQm89jSfIueATFza11ebi4gDnJ0B70TVYCiLeT5yfx9L3HAenwMWi99zIrBxlJHW2j3uRvCPldX1EQ3QiP+x42U5olmdtX2/NkZWwm6l7SKmT/gqvX0jQGviT9GQyEOchV8JbO8t3Ze5MjSRGv4Z/kbVj1SL7u9ziS9E2t7Zd+8IBKD1gf0AdGF/Xo+cEp3ye36kzylSWtM/jw6Qnl4JfD/sMLJFPS248MkU79PIST3k2v1HCl/ZCvt+xi+CrHfUEe7v8dTNvbOZg6TwgdUEs0ksNUx2ckSY7JKYKMgNS0I5J46eOgtswOHGIRxpUb4+Q9SmOjjbbkvvH6U5w0A8eoyypC6/6IReHTwoYx7ecSl8L85AemX7revaGI2+OGaH4pXIFXtfR8GeLZbyBAsaGRt9FxOAS6OYr4PLqjJ8aIDaxNHM0ftSwVDhbMNs7eSBYHb5h1r5yvwWvb42B/ewkudEEMhdUH+Jk6VY6OcgBt7lfJ4K7kVDuVb/loavhh8OzVu8K1u7jY2aB0cjR14BeB4hKkbRLNWY9KhvSC1BrGncx6bWqjlw6xBiHWod7yKy/N2mfpS63tJ0yQeZDXWjBG4Ef3RDrJtl14l8MA4u/7dcW1HCWUGsoO4fS8gMtTLl/WMuK0YYAI4BUffCxwy6y2Kknn48rymkknS8kCr34hgsrb86xEaKZ1RD3BB0aQM1t/DpXGrUEXUvAxyUqEpFxCGSn29OCjnPaKQKuWtb5nNIy9SZe7
 FLw9YM0M
 sXMLrNFNbvtkTO/wi2a6IZ5qZtQg5MZ/GRsYIvExGu6JmVErDrBPtEnV2dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 06:11:50PM -0400, Mike Snitzer wrote:
> An uncached (RWF_DONTCACHE) buffered write marks drop-behind every folio
> it creates, so writeback drops each one as soon as this write's data is
> on disk.

Please write proper commit message.  This sentence is absolutely
unreadable crap, and it gets worse from there.

If you can't state the problem you're fixing in your own words, you
really should not be touching this code.

> Measured locally on XFS (emulated 4Kn NVMe, 4 KiB pages), 32 threads

And avoid useless details.  What is emulated here, why does it matter?
Unlike SCSI/SATA nvme doesn't have the concept of native vs non-native
4k block sizses, and even for SCSI/SATA HDD that was purely a marketing
term which doesn't matter for code.

<snip pages and pages of irrelevant crap>

Do you really expect someone to read all this?  Please!

>  
>  	if (iter->flags & IOMAP_NOWAIT)
>  		fgp |= FGP_NOWAIT;
> -	if (iter->flags & IOMAP_DONTCACHE)
> +	if (iter->flags & IOMAP_DONTCACHE) {
> +		size_t unit = mapping_min_folio_nrbytes(mapping);
> +		size_t off = pos & (unit - 1);
> +
>  		fgp |= FGP_DONTCACHE;
> +		/*
> +		 * The smallest folio the mapping allows, a page or a block
> +		 * where the block is larger, that this write covers only
> +		 * partly is shared with a neighbouring write: get it as just
> +		 * that, which is kept until the write that completes it.

What the heck is this monster sentence supposed to mean?

> +	/*
> +	 * The page cache marks an edge it finds uptodate.  With blocks
> +	 * smaller than the folio, the edge this write completes is not
> +	 * uptodate yet: mark it if its other blocks are.
> +	 */

When did the page cache become an acting entity?


