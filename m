Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB31CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E0B8E0014; Mon, 20 Oct 2025 06:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25C68E0002; Mon, 20 Oct 2025 06:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B458E0014; Mon, 20 Oct 2025 06:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 903348E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:00:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4316D1DB012
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:00:48 +0000 (UTC)
X-FDA: 84018048576.23.DA916BB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id AFB50C0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:00:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=g5ssFmka
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760954446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=6vPGsipqewFH0An8fbqPgnRT3TdYk8QOTnwKOAIuU2w=;
	b=6tKk60DCJFnIA/5zOhuyC7enud86K0mcSRLbv2kfkLHwX03fu4ImA8+R4eu9noqKMNlXSq
	jJ8SAKYq9l7+Eke1ABwgzkfnMoLlvIYCFYBiI2zYIzdUUiqoux4VsVSjPonsq8LLeMNChk
	QNz8/cmPUjhh8EgACpvkm+kL69f7Bx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760954446; a=rsa-sha256;
	cv=none;
	b=0tLZSiaTrASOCSq89aWlkcOTnDuAA38xiP1c1SUehS/ZuUb3PPZ1VrhZogaVVNdPRDGlX5
	T/HHsjrHnr+N4IQ0tg8qfPNXGfkc6UFQON/b8Ef9WMKIdtYcjSQVTRXQTPGSSKX/Id6VPG
	bzuXQrLH7TR4cyrchfdcqVnMJ2YXGRk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=g5ssFmka;
	dmarc=none;
	spf=none (imf28.hostedemail.com: domain of BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:References;
	bh=6vPGsipqewFH0An8fbqPgnRT3TdYk8QOTnwKOAIuU2w=; b=g5ssFmkaJ1VQXeJw/jurNQB9hF
	NmA72962DCoxCCFbk7cJHkSN8364lgsT3N+hE1YOCM+UQHysCTs3oy4M1RY7HpT3xQJW4TirD3v5j
	Ckd46sg/3xxBJ9rFAyf2HU9/ZWQE+gIxn3T6D37gJstgLfXXoDeWidqtaV5FHFnMNGqhMwNJPkOR0
	pXaEAeAnzwmswGB68QSou16iHjnLFBmv0zc1gHclJ7I0p2JfQUM/8CWlgx09HNHHZplH5O+J7EJ7G
	ou/fQrD3j5eVqwZnxeVLfJS4tY3FJ7mCT6HsOEAPC6NRuwa70CTC9O9RIIM5wepN7xypSWGoy4NSe
	6DFBFEyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAmh1-0000000ChTZ-0C3R;
	Mon, 20 Oct 2025 10:00:43 +0000
Date: Mon, 20 Oct 2025 03:00:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	martin.petersen@oracle.com, jack@suse.com
Subject: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <aPYIS5rDfXhNNDHP@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Stat-Signature: adjhuuya65ts4if4oja1gz3f5gkkkong
X-Rspam-User: 
X-Rspamd-Queue-Id: AFB50C0006
X-HE-Tag: 1760954444-817120
X-HE-Meta: U2FsdGVkX1+191Ad60VuWs8kM95PCT3LC2jCgjzDdBWeecg2ytqpB3YbdCrM2Y9g46NW/7NUVvLgXxezyiu6mQIgu8GR8ajUItITODzKJvCHSH2K6zONEftalqWE20YDeNQ64d/HLLs5LLua9qWfRpIRpzESFjlx8r7w1DdBMr5ETZR6czmoWgLck0ebLefR+cZbtYenGq/GdEx8rkRofTsIgQr/3g2egRq8TvVB6P2LMGRN740rv2K/dZnR63nMeMM4yx11i0GGmd7SgV8Z+cIEYMvSjMxYLqsAwHvZYR91ZMTPyvAzAkpkeBK4cMzJ3+L0KaM+5cFt8jWqAU+Gm0RfY1t09WxH7uOtO7/ygSpdvabUY02nCUYes6fStoKD1VsNjASe2qfEWgBBP9SfHA72Tc0doeYWwDxOJabxnduoURvAkqLEXsxNSt5c/p3xzcGv7xB+5AGpP/UakynFfsqyxLK0GUZ1VHReUCKr3yvZVyWvZCtDOo2kQ06aLt/817LRLKl/WtIJ76vcHgT9j7U3uG74maSsfRgQ1S4reumdNfIfzcrWtKOjW2LJiF8voHDTVVkcDxL8bh+KZvxYN91listLnHFkhjmwz33QKcRhAjVonZO4D07+FctNyV+T1J92sHl92TRYm0cUBmx6xZcSDmLsy9BOrRTWKY9t7dcH82UCko55+uPN96sEpsmqCCxRmylylzLqXI7Ddh9BQoZXTl4vDY/e0OOfeSHXXp+U7LpbPep8BEPfnv5oprHcW1XiodvwdL05ne3OeH1IdiCZm5cjp/p0OJzAqJSKZJNrM7FPfmosHYOGNfRce18IMNXI+UNKMkKsOdQKP7TUa7DlSmcrq0vF+mQoibBlI8M+tX1f03LdQ/mt/1oHXwW9rNSxcUthAUReAg6P+AnRIfV58DS9l4YLtYIB/aAYYANxcWiJou7MDu18kaVOKcyGC6R161Y8Vev9L1Bukne
 SgHX+TkR
 dCJVt5C9e55anNIo/DHRuBuATm3E81BwY9fQr+sol0TNN4meVi1fUwGLPxWAP+LyTrIBdsQoVTyhCTjaKgzsbET5RBFWbP28UHTVB5oNpqoKLdfF6+KdP5RPgwJfDkC0p00nuXfPhmUGdwO9r53PJ1xLEHZ0ag6oDwnTInan1HDftCxnFP0d2I2UesSnu/bNYXNdM4mH0Y5l4cfusx6PtIw3brKEJsS7QIZh0JQ2CphqTFNuAAIGQ3Rxvzgo88IE0EPNCVJqLCpUq+pJaBIuxQxh5yuHj9TFkB/pyHSTYwawnRxDKxTAQinLMWQUDiJSpsKTfoHH0h5lrM1PxMbAtF01ejtmdtLUw6bhOj2OV3JsHVF9tdK+uipmq/ppbq54NRgDf1j1yqgA59B2mYWc5tg9Zl8WhgnnBcJs6DeIEq6I65wtMv992dT4AD5Ofs8JZum7hZ3P2HaRIgH35Sag4UMTfr7ve1Ttjmf6q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 07:49:50PM +1030, Qu Wenruo wrote:
> There is a bug report about that direct IO (and even concurrent buffered
> IO) can lead to different contents of md-raid.

What concurrent buffered I/O?

> It's exactly the situation we fixed for direct IO in commit 968f19c5b1b7
> ("btrfs: always fallback to buffered write if the inode requires
> checksum"), however we still leave a hole for nodatasum cases.
> 
> For nodatasum cases we still reuse the bio from direct IO, making it to
> cause the same problem for RAID1*/5/6 profiles, and results
> unreliable data contents read from disk, depending on the load balance.
> 
> Just do not trust any bio from direct IO, and never reuse those bios even
> for nodatasum cases. Instead alloc our own bio with newly allocated
> pages.
> 
> For direct read, submit that new bio, and at end io time copy the
> contents to the dio bio.
> For direct write, copy the contents from the dio bio, then submit the
> new one.

This basically reinvents IOCB_DONTCACHE I/O with duplicate code?

> Considering the zero-copy direct IO (and the fact XFS/EXT4 even allows
> modifying the page cache when it's still under writeback) can lead to
> raid mirror contents mismatch, the 23% performance drop should still be
> acceptable, and bcachefs is already doing this bouncing behavior.

XFS (and EXT4 as well, but I've not tested it) wait for I/O to
finish before allowing modifications when mapping_stable_writes returns
true, i.e., when the block device sets BLK_FEAT_STABLE_WRITES, so that
is fine.  Direct I/O is broken, and at least for XFS I have patches
to force DONTCACHE instead of DIRECT I/O by default in that case, but
allowing for an opt-out for known applications (e.g. file or storage
servers).

I'll need to rebase them, but I plan to send them out soon together
with other T10 PI enabling patches.  Sorry, juggling a few too many
things at the moment.

> But still, such performance drop can be very obvious, and performance
> oriented users (who are very happy running various benchmark tools) are
> going to notice or even complain.

I've unfortunately seen much bigger performance drops with direct I/O and
PI on fast SSDs, but we still should be safe by default.

> Another question is, should we push this behavior to iomap layer so that other
> fses can also benefit from it?

The right place is above iomap to pick the buffered I/O path instead.

The real question is if we can finally get a version of pin_user_pages
that prevents user modifications entirely.


