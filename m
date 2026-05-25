Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C52ACD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CD16B0093; Mon, 25 May 2026 01:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD986B0098; Mon, 25 May 2026 01:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819156B0099; Mon, 25 May 2026 01:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70EA26B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:34:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CB1440148
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:34:23 +0000 (UTC)
X-FDA: 84804826806.23.804FE75
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id A83BA180005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:34:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fbl7TUFK;
	spf=none (imf16.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779687261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JI2Zr6lMZzUwZhHfb31tRyecuT+FmnHjjuc47PlOF88=;
	b=1f8gC+JX1r0i0dqOVO6+yKQgQxAWntM5LRSIjaFt13I23BGj0ssw4T8qx1GSFSjnuBe2si
	7Vr5c48hlNPQYfYff0SrCFV7qYgvyEegVikaMfcPR7RjvRDF4B5TExXqbe01+OoXayHJCG
	HyIhTs82EfjKesOMBfp+dfi61bmStA8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fbl7TUFK;
	spf=none (imf16.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779687261; a=rsa-sha256;
	cv=none;
	b=zWzbHJQtKFJdBjlWHRXKGScOm60cbxBlu8l/G0H/QRKafi078VDRHeHRGX+Idppinwdv4f
	0tchY/bxvu06Dvk0m4gy31dSX1pQLu0lP1Gb91StYw/PWe7QHIWQbbKnrZ2iez3ENpV0o1
	P76uTnmuiZb63mrtYPZB3YwwV/a2ar0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JI2Zr6lMZzUwZhHfb31tRyecuT+FmnHjjuc47PlOF88=; b=fbl7TUFKkiazs7kdxhPNZcZYtr
	UoSs6GmpWA4sd06xY0mSmOJbz1vTEv0NX/in/duJG0tl7QLnFyjlGUNxwr7I0TWbZUC+A4s9djYdU
	4bhcVb7ocFo2e1fhGL4xiWcqzMti7C4Mb0ixnz6UJM6Y63h5ng5Uz/dP1ozLEUkkx38vBNm6aa+7j
	gD9BXH6jklrKy4duOsz5t3vPHgHry/+IC9DIIZRqldDVethOXzNRpRy5XYaveSU4JU4HQR1uEqbdF
	3FObmy1NIUnEwGbzE0qkkHl70qcM9kbu0TNXQ4He5AkG+OM4yrslhu738ntt5f7h43S58pFLVF2n2
	bTmAfl+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNxD-0000000GKaP-0cbs;
	Mon, 25 May 2026 05:34:19 +0000
Date: Sun, 24 May 2026 22:34:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ahPfWx04WCGYLCka@infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag9D6_7dttbDGHZ6@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A83BA180005
X-Rspam-User: 
X-Stat-Signature: dzz83a3dwa1nhobqtx8x1ncaj6i1ifpn
X-HE-Tag: 1779687261-594005
X-HE-Meta: U2FsdGVkX1/bpTwEUoc+126VwSIyRe66e/0XFHC4c4b1JNYGvPLLYqdpSnPKUr6gwaFMuQgVdc2Targ7d95Vnk7ZOE4XQKd6Pb0VUC/NumjzOCVGCpqlg+eq0+ZgVUIVaFYcP+cbldNHDSUbfG7FoqNoLSwDzyrjkLVG5EZ9QGQO7UPup97Hgj4PkQAgJPfW7/RshUOaqlEx7c+0uUEhYOhzx2fB2pSJ0Sjqzy9+9Jtx2v6+TPQIU42TPeasGT+8HLcFQGlr0gvWicB8q3ZJnyb3c6aS/yte1n4QY1y2P74Jf6YW/OIzIUG/HV6SBT5UXcWmp8oWvjWZoWWaJ6TLDbhJDQTFG114XCcFeEUW2ahLP570Ue54maPNgTCdKXW3tSTLVhg0IWm7Nx2ZsryA/UWqR7LeFaKlklKBFHSSe4Gq7dE/dnSVR/ce9zLwjuIKc1t47ZI/RsypOxn/pLEo1A3zQEBZjGze9emTM5fbaMWTO9scMJdGEVSiyxyhkQVEE/T96UxqhV4HdBPRski+wjw5KK8Mem+Qj82JRL8l8U5JlAQf0kjOlZ8eoZnju1Huw2G8emcvSCLP6mU9e8XTiFWul/aIOzcsjyCNleWVwMne7cF+y7RhQj8irsaxChjQVkTE63bg+9Lq6yrIdSeNL47BUu0v/32lEa07xrUi2nR4scfXLEnlORn8z7qL34S+VO2HuKE8e1HV5tUvr10aDRLgH5SLIarE+5MLzSnzgVwnrNIfXyFhzS0omxdSJ2h4JSf2Q4wqzq8u9egDjkN8M0A6cScDimDNuyG8HlxjcRAzCCPKfLPH4gkf+s31e5Kl5xiW6zCtQ0Rj/1X0b92f7lWk/RrORtR+J/+JmjmjjcTbWneT7tI8nuSAzGGp8Kn8VwD7PMn0HpRKkEhn575x2mMrScwgAH+UG4fI8YtvZ6UHtPIF1NVyhhAFBfF9vOCwVGu1KTfcg8NL6re9l6h
 6hFP5wRo
 EGNzyFnogItUQ1eLdRQWLWpzr9b3ZUygDzuUz2at8IOopHfWPuXt34sHdlCoz4zNLVfmPjBzapqwDvmgZSwgf1lNrbvEVbnkn6d6YRueoq84xWzCsztGvBaMJYOePFFZChu0e3ej+De8ZpUwW1cYfVZMFAk6JC97TpUluFkZe85aaZ10KVDG0g5jrrjozSsEjm3srqAXa7mlv4H+oEo2PWOQrTtPx5707Aqg5jZp59+T6cR4HmkssWOoyrLwrHDIH+Rue1+RyiUVJi1L/L0b4YiMGvpI1zvqNHEsgL/FwnYuZvWI40/HrbF9AGtNKLUj2wVfn0hK5uk/KqYEqxe1L5anhO/JonBDdlKz/ERNYsAm7iaQ7PzfXSd6jGR+i3nS5eR3S3nu0hxKeginZ3qrxozkDD//BaLREyz+iIfzQP75KAbyXJTadU/OYTzSX9//RV1qwduWXVMTGNlnxcnkNLR8BF814Q+KKhOSnm5TJAeGl0gHU0br9/zU7xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 06:42:03PM +0100, Matthew Wilcox wrote:
> On Thu, May 21, 2026 at 11:57:48AM -0400, Theodore Tso wrote:
> > So let me get this straight.  This is a magic xattr interface which is
> > not even persisted in the file system, but instead sets a 32-bit
> > bitmask in the struct inode which disappears once the inode gets
> > flushed from the inode stack.  And it uses a generic xattr name,
> > "user.fadvise".
> > 
> > There's no way in *hell* any other file system is likely to adopt such
> > a broken interface, so why didn't you just use an ioctl to set this
> > magic f2fs-specific flag?
> 
> I mean, yes, this API is horrendous.  But it's just another example of
> f2fs thinking it's somehow special and not just enabling large folios
> like other filesystems do.  This hurts everyone, not just people who use
> f2fs.

Yes.  And assuming we'd have a legit use to unconditionally use smaller
folios for given files we'd really need to control it in the MM.  Even
if it ends up being a Android-only hack.

