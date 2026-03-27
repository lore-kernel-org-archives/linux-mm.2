Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0513910BA42F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0AA6B0095; Fri, 27 Mar 2026 02:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298356B0096; Fri, 27 Mar 2026 02:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4C46B0098; Fri, 27 Mar 2026 02:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDA46B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:08:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8EDD5CABD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:08:28 +0000 (UTC)
X-FDA: 84590813496.02.5E59FBA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E7FC140009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:08:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fNvdwQ99;
	spf=none (imf09.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774591707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4auPwXr38hQiW2Mjvq8DGPvmEYD2PwPE2/BPhquF3ws=;
	b=HJ8BUVtmBjCySWr0ikwCPk8yWdNukn5tfm1hA1wRQkFi+mZQbVqlV5+qRfdb8oFEGFf7uJ
	0JQSpVdIWr59lEskRm2lU2vUTznYEbvYx/GvOxHh3zKO4oHjl5ouv8O6GLuTb8uxs4wjWb
	Ss37w9FV9YoptGiBQCwVnlDcpDSovzk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fNvdwQ99;
	spf=none (imf09.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774591707; a=rsa-sha256;
	cv=none;
	b=AkUGdBlvoqCc51EHXGcBo9otaoZpoJqv//v6iGQ1TTaAaq3f8z4quAZHjxjqQFeheppkNM
	RDaL6UTwtuGy6PJZoEYvb8d8Q+CrB6QxpurILnzfNC+MbLBmOi+FVNq/HTkaq+97CXT+Qm
	gsvtIVLg9xpLi5BUvDk7gT9FsBBKfjo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4auPwXr38hQiW2Mjvq8DGPvmEYD2PwPE2/BPhquF3ws=; b=fNvdwQ99pb7P9cxIyDp9EJTeeI
	r9Z6b2hvCrftiuFAJM1IHDssE8RxA1zYKUJWY/+REpTHnEqCeFspq3jnhb2QdRkf4wh7pdm89e15w
	60639Kl7HWkYHTTLM8PwrgdgXOnKc2/ofnXc3tEiBeC3ojjmbLGuy34lrhu+hl1lnZre6f25ZSS/9
	p0Vow++Y0M8BYpCszbOCG+7yb2zCdejpZcPjHEK5i49jWoekJ94VMWiFJPvQhBHy9kSk5ycPJq7TT
	eAR6CAl2+tBKJLjmeyqYP5d7s1fkyJlhm92wHFtRIGFhGCx3jS17BgNjAZEHH2Le+CrHJ/k5vb5w5
	h6DkL3qA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Mo-00000006jvz-0rGX;
	Fri, 27 Mar 2026 06:08:22 +0000
Date: Thu, 26 Mar 2026 23:08:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acYe1oCInkDLWGGu@infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRG5f9QjdEKg2JB@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acRG5f9QjdEKg2JB@dread>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E7FC140009
X-Stat-Signature: ejs5pmbnohhcntmin8ec9uw6e8n4eozy
X-Rspam-User: 
X-HE-Tag: 1774591706-64141
X-HE-Meta: U2FsdGVkX1+daLaa8b5EnwEmXoCKsZXM7wZSdQgWA2ER5VsN32rotq49WBTnimVEsAS6evOI22b9CE7As5wi9D55g//Uj+Ve0gCAyd4Lx1omRYp/qHltS2HOlFVzTAn0KtCbGCNE1Swxhhi+nMaC819KBqFd4sSzqkaNw0VHl6r3fcQ7VABbJG70Pp+nXRm4DtjijZFSzLZryumBfYxIsuMLLuNLOSsa8PH27QbBSQ2RTiEAJBvF/MZsRmRneNtnTT1r3hrqud6ONc1cm6T8HMi4Gf24Bsl7XK3nXieglh4WNPlvuWgILAjc2dYgD5KeB40EiEH0ibE+IXXqp9TOLgT2FnECYiFK7d8BQW9utZRkqhDe5SutF5V+PCJwCIvgn0+z/Sjz3SHJgLQt4BgEO5L8EA7YnhTSYUM10aMJfjnwzK3xQE8KTmF+fmxEiv49juCk05AYTW0gz/EYKN1StdebiYWbltY0ihm5r7xNvAAjSSF5KAc8mOlcihTJj52ggDNuQRsUnnOyldFzKSSmxBMa35YVVsPDpR/FcCCnwS7H0Bk2V1qN7zL31/m68Zu5GZTUSZAm2iqmjMm8OFGCu90pxSblAUjlNk4Bj6Rq2aBLY/dN/PGuJXaHtwboZiNNHKNGAZSl058niyzemgrTJAwhZe1iavlWeDsEadEu6rTzt7ucz09I4Uu6pFu6n5bn+SJYg6P1ip5OjoH9HNvLIxhaHAMGRYn4GvES2TNJOkKx6Dsr5HDcU7oyHgkzrC15PlKcenUA7SXExUOvMtEHM9HuOuutBSP9JRurhDRSbwpALJ2oIX/ulvwtSjq0upkEVG2sVHJMgsVPpD6H0pA7rhLzqhs9gntbY6Zrq9/Ox0sEBpMhISub+9rLRl7FNCLCimz823XjmOUW59v+aOZk4QNoCnIO9LJZNAWdBsbZxDFeMyrio4cTHA7q8k80I32KXCpkTRKdRHnnD7HG3Mg
 oV+TC6r0
 7W84BNLjW1QBQ/4ud2h7E4GucrK2FPF7w1kv9dQEHAlShPBSTNI78HmVQbAFrHhHO1v38PQT/46b4LS5q49qAaOdgM/mINvRpTROeXcPy3AYypeDB5AELV4GZ3k27VxGhVinX1Q6VSr0aWHIySjz1vM2fh/M8cBTuryhR8OeSkDr2PbGFMxqMKpyeqqkVyBItoUV8Lhb6Dn+Ai65Gy6Ac72DBnbXlp0kIz0AwQFo2B8sWoqaIe4SGyFp2YfmvyCO+9ta89xZpuglFVbTjjLYrEQfkhE+poNtvt2WmlbPdytQvnY1Rbce6BtilKxiXNKRYYK6mjo7RSlbnNsvViaOYiVq4qCj6IOXjfvvM52jEBZF1rbnVHGg4TQN6xOMYUCEMLD2ZMHsdKCkcpQtf0ocTxzFGCk10uiLqpc3Nk4iZ/Oje0qFBwta359355d3tjD7Xm/n9x40rv7/Ay0kfGA1o5F3AeUMitYcayXnlXZogkUZpbB8mER4CDRu1j6Vk6irxn03VztziAjXK/wUhXNdRoDlSVuN+HakSHS/WK/5c/TBHkvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:34:45AM +1100, Dave Chinner wrote:
> At this point, I'd suggest that we should not be making random
> one-off changes to the iomap and filesystem layers like this just
> for one operation that needs deferred IO completion work. This needs
> to considered from the overall perspective of how we defer
> completion work -  there are lots of different paths through
> filesystems and/or iomap that require/use task deferal for IO
> completion. We want them all to use the same mechanism - splitting
> deferal between multiple layers depending on IO type is not a
> particularly nice thing to be doing...

Yes and no.  The XFS/iomap write completions needs special handling
for merging operation, using different workqueues, and also the
serialization provided by the per-inode list.

Everything that just needs a dumb user context should be the same,
though.  And this mechanism should work just fine for the T10 PI
checksums.  It does not currently work for the defer to user on error
used by the fserror reporting, but should be adaptable to that by
allowing to also defer an I/O completion from an already running
end_io handler, although that might get ugly.

It should work really well for other places that defer bio completions
like the erofs decompression handler that recently came up, and it will
be very useful to implement actually working REQ_NOWAIT support for
file system writes.  So yes, I think we need to look more at the whole
picture, and I think this is a good building block considering the
whole picture.  I don't think we can coverge on just a single mechanism,
but having few and generic ones is good.


