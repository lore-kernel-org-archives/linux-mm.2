Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B30F4CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC2E6B0093; Mon, 25 May 2026 01:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD2D6B0098; Mon, 25 May 2026 01:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2C66B0099; Mon, 25 May 2026 01:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA6E06B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:37:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68C8D8F6DB
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:37:10 +0000 (UTC)
X-FDA: 84804833820.10.F47CCD0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id C7EB71C0003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:37:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mI7+58UN;
	spf=none (imf20.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779687428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPlnrUAngQhntq0icVQxK0A5R6EP/y6CGfxUmuJ8Roc=;
	b=r103F/s8SYO/EZzQaOpkIahKAxi+9BmO3gTkyJXkZ43xmTig2WEJBug5g/qr6yIztoet9S
	LdFTBRq7INkkvWKelbEL26KFvcmhIq+jWwst3WBF5KYYGMHnnQdsRWVxdX90TtpbgQslp1
	1X56H4J/q3J4wv2Nwqq0T7d7+BJZvls=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mI7+58UN;
	spf=none (imf20.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779687428; a=rsa-sha256;
	cv=none;
	b=lbLuIWJmPbZTaZ33jbWtBiHD0LzlHfH1nyYa0RcKV6FdePKSDXNbl/R671zFpG0hi1fW6F
	EFunGdv+9m1h53QtDePLciU48e6XFjI2TkJmwCqbb/mRzEbYcJztmabAOYsMHYs5cblXJ0
	lDkFJfy1ntyBjRsEB5W5hBk3obPrPXI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=bPlnrUAngQhntq0icVQxK0A5R6EP/y6CGfxUmuJ8Roc=; b=mI7+58UNZvQ1rHO+UR+G3zOxD7
	/8Q4dyZKxJcdSNb/R47cH8reyDTtiHoTo+ZY1PEHKP1sCy7wV2KEhwd8MNm/M9D7VXNwHZoztfouo
	ellPDj7sZaVnwIcwtuRKY+kRVN9tGtX3CfEZ+71st7D3jw6OwcdGneEEFEF9XNvEvTxVz0XU8F5v6
	aKLKYaDQcv0dpz+Vxwj0TvKoeLyqOXxQt3Fs7io8F6fnGJKSnqnfrBDTuM9Bjn1mwkQsNTWDDnfhD
	qxzwqs5H2TVfEJQkzZA/O6FF3yMLeD+t3A5pcA1FIZEHbDav7HM47fbADf9+YeeWA6EZTFKtS8mej
	OhB0Hp4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNzu-0000000GKn6-0I3f;
	Mon, 25 May 2026 05:37:06 +0000
Date: Sun, 24 May 2026 22:37:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahPgAog1c6SltcQS@infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ag_OVwPF49LSZ7rz@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: zfd7jxwri991ehea4odz7r6oe1pgbzmu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C7EB71C0003
X-HE-Tag: 1779687428-710232
X-HE-Meta: U2FsdGVkX18+S+3VVqwWmHomHGcYQEQz0wMHlUAKdCI6GXcduBLppcZ2ITYcGVm/zTDLP4pagWsokepbz1Imv24U9uYGYZJ/hv2u0XWzNLqPOCv/Z//5ZLlNtFyLeAWj4giOktgm0O1gi9BoKFWc6gHepD13pttoz3ooRgcb4XiWFqQ+I2Y2KgMHXYq+6pkMBH2GqZjX/ZssDDobYFTLzbB3/KJ3w0YPfMsLftYY2HKmBXgT8Hx2lXHMuxhFj5eszx10GvsyPDWwVQpgH08RjKIeQHyE7BwaHcRHt0nDZBLd7syiVAYWtrRf36EFC9iqY303ye+jGTDilLYIGCcyLVWn56kua1Xze7zhPmewThptMOkpTlSWSJT+UH9PiBh8sZmo4S/STcB/oRmbk+IbQAaKy8+N3HO9ySlHpeRJ04jNFEGp7MEFFPWhzOF/+lIKFB2isfG/4D20kkf+/+/b65Qgd86B5rJ2rHeCNcTXy3ivNrYtQBQdgYvq7gEaCankAPRBpgIjTNjiXQsm6xlAtjmQwFN3vCWtqCdUBZLKcUaeFNH7l/yRTCERx+6XmS/EUim8ijKoS0zfgvxufKFLjL+hRResXokunXRLvx8sqpZidnSVLFRmGuGoV2qI6wJJ3ReHWkRbtoI/V/3wK9qRomg+vYLlact5UiBvwiDjUhFy0RgIWzX9lVFNIsfqPy4AeTtxoyyzABPBATaISgbRmEbeMgJxYYIy5qbza7Aho5YRlKW5eQj6hQW5Lals+RmYWRH2Rz2dTq1SitEZS9RjoX75fpQXKJUnA3CDgfeAv/yOWQ1/9p3ORVf4b7aYso6WrrtubXn6TSJwLEoW3iuZVB7Q8T7jbRjIedYEKwCZqrcwDtrUyntVjTs0ly4AyQwSI2BvmZZzxBCZeRWNFtpdazPK0XUZyDI5eR0+ONq4puzV1oI7cWo6ix+N6H6ucVJM9RwUfle96EZL1HJYb1L
 5XJ8tkOH
 ovPxToycoxN0EB96R6zpyES83uVggGNQjaaxAJaBJfFR7WN/mpZvr9TklPzcrPkq/McUROOSSrXFXcbQUYQrL9iXXivkfMJ8wY35v3e3i5nFEfB7+TNESt+R7Fa536/PM28/I1nSNUZCL3xRqEL5K8RHVi9f91ToTSwWi9Vu7IgW7McmR/9MLONDAVWnChcJ6WCYD2/pc9tYXit2NefUBqV8okjgANtuNr8yTW3mYCL6RM7+Otne1ULnM+Uz2h0845l8ETGnILxXhjk8QR1bjMwszvMUFsiWtAJK3KFxBys7x6ta9XQ7PQ7whs4QfhSaAcmq+saEZLAqdmSbBFnMyk6ALE19ktd5fioEDbt2FUIQDAD/9chHBzRVhsDxLi7CuzF8UiseDhKBW664eDKud4Y5Iefls2yLVESjS+mZLpStbgkKx3cnMKyE0Qcq0vMcPmD3ouzPGJasJBiMf9nr5b7OmfAjbJaQNrLvWbpNluw0/Io8UIru1emEp7tEINoYvqECNjHDaN3wg91Gokw4+m1meqhHQEXVEAi0JUM6e4txlrDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 03:32:39AM +0000, Jaegeuk Kim wrote:
> I went this route because Android heavily restricts ioctl() permissions
> and we needed broader access for this to work within the framework. It’s
> definitely a pragmatic choice just to get it running in production.

That is not a good reason.

> If ioctl() is a right way for upstream, I'm happy to change this patch. By
> the way, I really don't understand why all the messages are so offensive,
> even without trying to understand the problem or guiding right directions.

The right way is to:

 1) Talk to the relevant subsystems (MM and fsdevel), and if it affects
    userspace that linux-api list and actually explain your use case.
 2) And then actually listen to feedback.  f2fs just keeps piling these
    ABI hacks on without any review, and it is causing real problems.


