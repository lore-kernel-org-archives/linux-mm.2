Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA5DD10BA426
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D546B0099; Fri, 27 Mar 2026 02:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465626B009B; Fri, 27 Mar 2026 02:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3206B009D; Fri, 27 Mar 2026 02:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 28EF26B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:03:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB4A91B969B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:03:26 +0000 (UTC)
X-FDA: 84590800812.15.E89256C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49722140004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:03:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nNqIJz5O;
	spf=none (imf09.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774591405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iv7k7jt4dplLesyfY+epqBGiPQNj+XYY7x/5mn5IrXQ=;
	b=hcijjGb0EWM2rPDKeI4LUh6e9PB7XDKOOu1Y/8WqLs3yM7wXANYyXG8Nfy1RXJKNPcm7gB
	Jw3PfooxjJYr1IHXNPs0+vQetk50qOc9vKzIS8DdtRCtWLZd12yVny02batsqaZ6uCtizy
	EGsqngcsHdUcXyFpv2MT27jWQkeru6M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nNqIJz5O;
	spf=none (imf09.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774591405; a=rsa-sha256;
	cv=none;
	b=YDJXb8/cJ3u0qANe5xEYhBX63UzDDRWZGp7hkXvfrZkc3rMi/eke2UjRh1RxPDNtYlyVVO
	jD8HB09qd8D/+cczT7sxfklat2yD5UMdqkk5ZnLXeVeBDJO4HgJXzmo4S09f59gOUhanSg
	d7G3wfqdzg2OnK9R3B43Ee/dPofYsmQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iv7k7jt4dplLesyfY+epqBGiPQNj+XYY7x/5mn5IrXQ=; b=nNqIJz5O/4su2NhB0ci8ATVbf9
	+UVEnolYQZjthdz8NSR3EzFfHpYMYcvH+/D8WrVJIa4xUIE8S5JaNXceG5QndLnnVDmKtwdI5hZ8i
	IbfB75jHd/wRHS3PVwSsol68iPinA0TqyNDduPvldYRkkh7qNt2+EzHCCr1KbyuLnKZKe/eJbY+OA
	s99wGstoT+wV+qMJemG1NHwJb5A/JMIlqqofcocgYUWce5eAVQLx8L7n0tRtSiK9ztC0SyOTQBpOa
	trM7SQqt5kuiGw3bRRPct79zkmgbXXfOOlfrgKUq0DM0PoTS1OTTBHHnsrG5FABCIecLdDRVImFh9
	uDRKOi5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Hy-00000006jhq-0TXU;
	Fri, 27 Mar 2026 06:03:22 +0000
Date: Thu, 26 Mar 2026 23:03:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acYdqqe6sahnfH7c@infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRDyJrkJhnHHMSe@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acRDyJrkJhnHHMSe@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49722140004
X-Stat-Signature: 54mzujeniz6yc8a4yzypuxwd36qqrihn
X-Rspam-User: 
X-HE-Tag: 1774591405-380865
X-HE-Meta: U2FsdGVkX1/bPre5KYf/agWt+RVZiDvKUi5w491Uj5ONS4XAxCSLkXdjRgCr+sYrPm1KhPGPeWLpVewTw5i1cc9supHahjYpykoeOWjorempv0KAHzvfw+bUS75DTpWaA01OFQsqwvpbmldWVMY0oYvJuy+p5u8LdeoCnXjE7rs8Gn9b/PDHi6/WGi8K6HdvDY898fI3z43/tT4WL+B0rJMoUzC/zTqC1l7erlf/+neGwRHMJAgWvSSnuLr6HuntnY/6wShWeuZeXAv6hc9fKyZz5ECHDZpr8f3bPKfIoAKnGhkgrxyppUnUtQdx/qODRpTRzI25dDQndC6xnYuD4Xf9z9n+ytBVk+qL4VRstXhUfxEOWC+T+gNvERksmcRBZtPJ9gSIl0QdWyFvZ0QtgGx726VdnFBpHSbKy0GUusJhledrMA96rZ6hBuXFJHMZoFOUUtqXrmzoUwbb8ADy++xaEbdCjKW4LMIkfHQZdLsvHHB8lhWL4Edj5HIH4EUBXYFiumlopjaEOScr/L62lQsbS2gquBUNNSGWig1cW9y4WffQ2yffqSkPG2LK5WtVCBdj8dnQic9YcfR9dp4CjR/atYEkGROjsFhFyGdrWtbohIpr/+wJMw5ExIThhP4m8vyMuC06RIoWILWnKYamJu6Q1l07U3hGY+LGDQpyLETquki6VIuhyffuZjNKfEbrx71BnwgDfJ3qkSpJg5LP1F4txLU3xDpwpnrx6aXwb85rYSZMJjm3V1MOwBlVMGQnqxzcTK0dXzfxj8ePv9Y4IqmQ56pHZZPkUQQCegD6bpdv+kI4j3Cmise7qv0Hva/3xXZoF4V2uhUQcqX6564PUIqwxV9x/aJqqJCjqt4jbQIA52zrtgs/eqxDf/Md2+pqKZp9s6VYpbwi5xAQIEVnXLm3l6G4H5v5Cw66UmunTx8g5jjVl3zZU1wx5t9pAdaWt/BAnEbs+k5UhjIQ/Vh
 QERjWYPT
 c2UImkMhTsvi/hlnX8YI34wIOFIhoN/j3zJ+6bH0J9gCkNQw64rg7WSofBCsvGwPaNghBsve0+g7MccWYA8UFz/D7x5L7D4kWTLfGFtPOb8d2N6S5PkfJO9Nd93PBcrjuE6SBW+IWThzqSbkUxGtKzC+wPhfHDwN+rGonoZdQlZrAMfWpeVy+H8+4oFHH8iUpxOS5Uom5iiS2FvtnfDaC56uhc59AqgwcNX3i5SBOWVHakluuQhyY1rINnM4dlSaE8LgBFcP080yZL4B+QhyIOVriFsPwtZ1LbVwlvHabhEl9IWOhO4vNQYOOisWsc2WIMBSYoYUaI90Wm51PpgJtj6KfPnbaYEBXJZiuIhlkpbUhhHOuBXSqep6ZHvOE2qdyZg7DwM6Jvauo5r77mziivi/7oOB35lEeocyqm0jmpyHPF9uDuetUM4jT8GiF0Qi7Vh6Vexdr0dp0UorUgS9AilZNGxldkJlwenNeX+aAypICgWk81qmLyLAtnCuq3S3sajbrPnvmO87H7CrK0ZRoTiciL43fYn6Xq2mJD1FnRQl5WN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 08:21:28PM +0000, Matthew Wilcox wrote:
> > +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
> > +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> >  	wbc_init_bio(wpc->wbc, bio);
> >  	wpc->nr_folios = 0;
> >  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> 
> Can't we delete IOMAP_IOEND_DONTCACHE, and just do:
> 
> 	if (folio_test_dropbehind(folio))
> 		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> 
> It'd need to move down a few lines in iomap_add_to_ioend() to after
> bio_add_folio() succeeds.

Yes, that sounds sensible.


