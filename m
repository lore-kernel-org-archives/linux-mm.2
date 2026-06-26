Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80FDCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 06:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0764A6B0101; Fri, 26 Jun 2026 02:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027D36B0102; Fri, 26 Jun 2026 02:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FAD6B0103; Fri, 26 Jun 2026 02:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1C1D6B0101
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:56:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2021403D1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:56:14 +0000 (UTC)
X-FDA: 84921154668.09.07F3C61
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F31C18000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:56:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oE0R1mHt;
	spf=none (imf24.hostedemail.com: domain of BATV+6a0954e2f3b24d650eac+8342+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6a0954e2f3b24d650eac+8342+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782456972;
	b=M+8ZxkRg+60pIFVNuMLsIhsR7vy3p0S0uOzNCF3tWTTboCjWz2ynMgNOGO+okvR4xDrl8X
	lvufVZ9KPeC5bGLbsYCz4oyERyInoFOzvMe4t6MUN9Kfw37/cXWIUFKFAO6z0KORHgjnPk
	2ff084snXSpcj54VnrxvTbeIZHx2KaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782456972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIfqsHd8ihBL61AqZDeOTYBP79ZhHNbdbCAc3Fu49SM=;
	b=w188ZGHM/p0eHEUvX0HHUTZlhKOATJEVQ20YvnCyHtgc5VNKw5uf19K0geMYlW1pz9DuGa
	j7k9XksmFwQpkLdR5Ur+uDsfr7X4XGkqju+8L1hjAiYpvGk8IHD92/Qi8CnQUQsWxp4HgO
	nJWbB3UzSPUZf2lMGt/VCjr3z1f8OJE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oE0R1mHt;
	spf=none (imf24.hostedemail.com: domain of BATV+6a0954e2f3b24d650eac+8342+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6a0954e2f3b24d650eac+8342+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qIfqsHd8ihBL61AqZDeOTYBP79ZhHNbdbCAc3Fu49SM=; b=oE0R1mHtR3UXS9T7lQ20Rhwr2d
	20/URBEfimgv+uBo56GHhEJ11yy+9fctdNtV8gU9k9J5xa4+4MIc1BNhxCxFszd5dWAJV4v3ymPje
	hYfex1zfEszdXuwxfrvu2rFtP1DkuQbk88f7GvXL4eSR52I24d84YQaGmWQSUm6ahjnLHeBDc57eB
	MZqqsiQ8juwt6FJ+rnafE+VHGjfWhnffMAE88DJ8rqW+t1b8/LungKkSw9PmNzODQZmtpvzlftdsY
	RkUOEYZAQ4Rtc5WQIddP6zgUDWRqwVDxkWPCkUc1wjO9Kg9xESwCZnAHnFvrxwrbUTlvF5bdSHMqU
	AkcErr9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wd0Tw-0000000AdCL-2EAR;
	Fri, 26 Jun 2026 06:56:08 +0000
Date: Thu, 25 Jun 2026 23:56:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Pranjal Shrivastava <praan@google.com>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <aj4iiD5C_yyLeb3U@infradead.org>
References: <20260616134000.2733403-1-praan@google.com>
 <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQ21kH1ZVajS2Y7@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 3y3rp8zftwakoz55xkfoerke6idbkd6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F31C18000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782456971-365193
X-HE-Meta: U2FsdGVkX19bL0OchwdQ0o1Vaf/76Dchy/u2eDHTsvdmlPD/DAHoGJ8srkcMbauLwu4qu6hmhEqhucjMVJ3mpuYqTbCxROf8q1KS/zb177NWZc50KYLJ7QTnwpZETMghz++7C40fVQVT7vqPhq3iu9QmxB+B9ExlrwdgGKll7+0l9D/0xWMhx99RZKYc0r/x4D3i780tVO59SE+qLpM0KVJK+KIwLZ9MOu1WglyZ/zollrYmZ/NpfM6rJfdEWpOGRnzyDdW/52mCWpSXUd8qtnqdzvZpQoPIVIUm/6ahLJcYTfw7Bx1oh3CEis9ksrUMYTil+RpEON3CS3jjpPWZ7x7j7EEzQsDFZh4JnuVyOPIEcNCIX1ZB3BZi6nN8T8llBCLlDnrXLACBH1Win68h401v5GrIhIldca7qgxmuLNcMmiFwpQuQOeOHZ5oS0T7mySpAyrb9Ueb6PHvWTTvUn2ijW4/Nj+rtVI2fz2XNSbspg1HkdXg0Q2aTZg7ky+9V5d6dp9NGQVgO0o1UJzkOvuorS6IWpFYh7D5QNLTk8sAaWdacXueXADqyKk8MtYJz3leRchKqPF5C2B2sMS6103kkGbudqGnptdCOWwI2uSPlxdjyj2eY4Gpa8iWdsDmWwe2P8maaqFMfjE8iNJFBdDCnkzHbmCvtaLCmTrl+LP2XPpRQPTdaxmlFGzWCw8LPykOuivQ39TqF4eBGjTISzhXzzp1vMx437u/kPtV2WxRBauSsZf8C8LYLZeqr7gPxXzZVmdPiWbuLzxRbZHvGBk6XbbZl/IWycfZ0pGv/I/CFjLfFRQoHFYNJjUElPz9BasUnIaC1mUUmeEMN+cTPRC4f6c+cQuumCDBoEow3JL0hXrVtWpZ7xAohhpXIvwnzSQHekulJFDA6CYDcU1aWSnw/rKdYOLYsidbrMmlaTTDXXIEV6QfXlYllXGsGb4Q6tgcMqqd1LL6HKDpymbT
 oLxmfayq
 lWcjG06pYsxwBxtc0E+eAl4by6NejNPK4HaEA6crZQ3amJeF2+w8m49Yj35UBmBs+cC1LLrOkWPbvITOdVm8Bf+i2VcyKhHDi9nujFVzzuGyolMP2W15H+8g7tH35AFpFvagwnJfY6r0uQDKCP028+mZdhiJG0fwG+fHsXD7+Efihztv7ChtLv7RR7/XRVKWY7JLqv1BxUvqQR9JmwsQe4v1dQJ6mmWTV7XCOh98PpIV2m8U23ek+gX2xIMTqCUYaJvhQUxEm6/ui/9RRwvNPyC//IbsgcnfpNvtG9DnJ5ffKxiqk6u0G4X1RcbmFBkrbAcCLSmVGtBAyHIwJlOvwtJTLBuFi/dnrtlqY4lHKFis4viJLfhhBfLzVLWc4cq6VswVDPo8cIcIJj9ojIUBBgizHEu4CgfGISxtGOS/eCY+imFX60qfBmyYEuBYWPiizxkta7rCFEAOxX8UflbtnEJ/cEXfWatuPy1h0xlJEcFl0sWh4gIA8IzbJEsCzUiLttY6M/pX+dESMMJWpuBY1uFOsAtbNwgxtk0IE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[sorry, dropped the ball a bit on this due to overload]

On Thu, Jun 18, 2026 at 07:20:06PM +0100, Matthew Wilcox wrote:
> On Thu, Jun 18, 2026 at 07:10:45AM -0700, Christoph Hellwig wrote:
> > On Tue, Jun 16, 2026 at 05:23:48PM +0000, Pranjal Shrivastava wrote:
> > > AFAIU, the MM subsystem explicitly ensures that every valid struct page
> > > is part of a folio.
> > 
> > It is definitively not what the vision for the folio is, although if
> > I'm not mistaken it actually is still true right now.
> 
> It's not true, eg, for slab.  While there's still a struct page there
> for slab, there's no refcount and flags like PG_locked have different
> meanings.  You'll get into a lot of trouble trying to treat slabs as
> folios (and that will include assertions tripping).

True.  But also not relevant for direct I/O user pinning.  If we stopped
having valid folios for anything mapped into userspace,
iov_iter_extract_bvecs would run into problems, and we had the discussion
before that at least right now it would be hard to fix.

Also if iov_iter_extract_bvecs was used on kvec or bvec iters we could
run into the slab problem.  The block usage currently makes sure bvec
iters are not handed to iov_iter_extract_bvecs, but there is no such
thing for kvec vectors, although no one is using them for direct I/O
right now.  Not that I'd want to rely on that in the long run.


