Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AD2CED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 12:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E35F6B0099; Tue, 18 Nov 2025 07:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894496B00A1; Tue, 18 Nov 2025 07:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D08F6B00A2; Tue, 18 Nov 2025 07:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 690B96B0099
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:51:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B1D713B151
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:51:58 +0000 (UTC)
X-FDA: 84123715116.06.6200663
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 598CBA0013
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:51:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UMShjRt3;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763470316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzxLKs39PWDbcq4Lbqe/ZoP4a39VPMRKYU7TDvRKOxU=;
	b=GcTOHP63Lbwi7LeTbpfBMV4PjZedsMlhM1bLVcZ+wk/1JS1isDi3efF/uIo40uYOQmFTxQ
	wZtCI5QcyHj1B+8lPvDv4nsMTFR4VNZMWMFXP0B9y3gqA2zLf4Emy8/VYywD71OphABo6U
	/VRU8sKpkI9AHh6fsXKFLmFqyY0QW2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763470316; a=rsa-sha256;
	cv=none;
	b=W0fHjsDl0/+MDaFMAFbluFVcGzH++RdAnGO14Lyo52yCy4PEIal6X3dQ9sFfdOYFMxMrsx
	vgz3lZoxfWenRlekQZK1eSDbxLlexQDxTCvwcmNz/qIEl+w8BrXfxB00/TD1JveD0qbHSB
	kE1I7clSSsGBbwZUrQJIpEX6EEGhgbk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UMShjRt3;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OzxLKs39PWDbcq4Lbqe/ZoP4a39VPMRKYU7TDvRKOxU=; b=UMShjRt32ga8qnRRWFrepB2Pgz
	OgEt5WtRa5Trl4ds6e5rKqrXJoP8wUOyus3IVsusUjlJ8oszfliaxlucomDLrBxZrddCOcny5698t
	BSk1G9c3nnsYTKVX+xuGppqOi7asRlYQlUXF8Ixxt8JQJ7FDjN3VrqSYyoAt7YTOdzNuCrl9YyMEp
	oP78RDKeE2AElybsO5Dq48Wmb9I7LQVfi5GyMupPE6LqZ3jCUrzYYPt13Y/p5LtLTlhywjQJK7Ywz
	42dI2tc2yvJD+62zjtzY57kSMr9ERElNlra4MidXQcKbuQNE9yng6enKYvdJf2G92TxwnIFoQhMU5
	JFgspVcQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLLBW-0000000FUZC-37rp;
	Tue, 18 Nov 2025 12:51:50 +0000
Date: Tue, 18 Nov 2025 12:51:50 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aRxr5l-usmPvenbM@casper.infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <aRv-jfh0WkVZLd_d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRv-jfh0WkVZLd_d@infradead.org>
X-Stat-Signature: tmnho5qcjqihp56gyukbdmotrhdh73o6
X-Rspam-User: 
X-Rspamd-Queue-Id: 598CBA0013
X-Rspamd-Server: rspam01
X-HE-Tag: 1763470315-678894
X-HE-Meta: U2FsdGVkX1/Pq1HMLeSu2D8aymzHC45/bgaSS8vFdnlcueR1j01mTiOhNuq1g+hg38bCJT2sbxR8AMVNrdqZ9EpnoEkdsWePTtwzAUKrP50wCD9F5Zcm4rroOx1FrPuLxgCIeF5m+OqEKtYFl6eKzfnXrTaam4rIlsJ0oIajcXSYeVLQ9VuHqPDWfiOLIuPr/5W9dNnOdCBBwwC9CMOUucGKS3lgF6XAYQ9pbb71PzE7FsWpyNMnv8LAImCJFa7saM5/rsxt1Bf1aV+PdUfSlTV3bZdCwzEzFBPFdhaMHLS89c+Htt59wmBsU+2q9opefkBeKVTviuKwt/esH/RwPPdL4IE7wMCPxekECcXNism1NoWJeuUrjT0+f7t5yIX7OO2kDehXJD1eEHKWL7LnpF092oyCBMUtpTTIBfPR/2C1GtTTq/9YSEKTkPikflc2k93iH7esnZwLbkFLSsozbemiAXf/mqL7X744UeQrPUV403U7KtYRS0pxDBP64Ui5l2B0yAlziTeZJxERcIIi8slEwLWNkw9r81Imo5wc8dO+0Ho4bJ6BLLcvK05Nn2VOrtkLVwmTbOnbf+hr9hwScEIfWAHvKvhZLaClJAmQWfsGVoSzSfDwbYPaMxllZX3e45AHkY4z8CvFliHoHcPathsvp2LpX1jBNE7rTlFji4ctwV0UXQ98DjuzLDyZx7sxQKEk8L6iJ1jgwWnyhocZD9uUPfdZtiQWVG9YbmVXk5YqZ+uQ+BrRPVNmg9gv+jhDoDW14cKfrCLfDYrvDm/olUNiYvh4qo2JB02jBI3sAeZUNj5N6M1zGzDyvd6R/Q49mEdF8Pu/4ArkNwIjhhechHxDeGsCBB0/gvM2Hcmepo0r1ivkk4hC9POACDcaYPjc3cBFyC6x2xB0JikxscGrYoi2Y4oLgJ+X1lq1afcm4qtZvDzs7OV8hB7O2bd55OiEwRghVRaY5aVQLoSA8LX
 tJh4z710
 my+E7moHQ+1JWZSPFYivfOY28IDxdkq0tb4PZMr+KMAuZ+DfuZlv9mJKfHOf2FRcNSfgnvNUWhjWxeTdMSO7YI+aUKr2XeTphIPTxQR9rHVWMLQCg7uBCyEK/bAgbYD3XzRnUpc6nfJAOca+N5iWhA0XyJAEX1O9b+LYtsdeC4O+1mRagZffwr+2CVQGlp+95tnQCJ7m+VJ4Fy4TJ6TSvE5GZPp+uf5/SXr7mBwZyQoX7cnNnc+C0L9wlGP4Nc0Vo6OyCB92TuP/2L4Nxmt+kmj0CgX80Dw+0d9r8lshjbDWOOd82T7cNc+AJXo+Ji7BQb7sTAu/nlJlDhlPCqtE/LCIBjD/w/PQQJGxr1HgghdQFSLTG6X98PwKF6Ajgwr5g1j/CIm2guFCHwa0Tk4/7DFrncBh0It838QFJS7K7dWdeb7NQSPiF4StbCzFIAQdVyP5GuzXXRxKaPlQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 09:05:17PM -0800, Christoph Hellwig wrote:
> On Sun, Nov 16, 2025 at 10:32:12PM +0000, Matthew Wilcox wrote:
> > I don't think it's necessarily all that hard to make buildid work
> > for DAX.  It's probably something like:
> > 
> > 	if (IS_DAX(file_inode(file)))
> > 		kernel_read(file, buf, count, &pos);
> > 
> > but that's just off the top of my head.
> 
> The code should just unconditionally use kernel_read().  Relying
> on ->read_folio to just work is only something file system code and
> library code called by the file systems can assume.
> 
> Something reading ELF headers has no bunsiness poking into this layer.

Please read the rest of the thread; this code can be called in contexts
that can't block.  That was why I proposed the kiocb_read() refactoring
that I would expect you to have an opinion on.

