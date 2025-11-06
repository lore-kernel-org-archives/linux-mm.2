Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B1BCCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8958E0003; Thu,  6 Nov 2025 09:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0778E0002; Thu,  6 Nov 2025 09:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704B68E0003; Thu,  6 Nov 2025 09:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9E68E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:01:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB6691A0776
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:01:53 +0000 (UTC)
X-FDA: 84080345706.19.66DDEF6
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id DA763C0030
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:01:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762437712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GYE5V9MHvfmZr7HEYeaOaAS6seFmcIOehNuhVzfEMtw=;
	b=LpmOk/wfQvTlskdIFnYIk8cSJr8L/8quVnFbnTm47lMMo8R49wLnanVinS0RQS7/Ob19wY
	wUVWf6s4cS/HonqfX0N0+T5SyTeMCuhDnz740KfnFeSykY8bqZL2r0XYpYxk2l32AedqCG
	IXkkZhJ4995IMWquggFnnZ6Vrv1hRcQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762437712; a=rsa-sha256;
	cv=none;
	b=Ai3cuOEpW9RjKp11FpLhYnYZVX1AcmwKVAageXYT6EU9PzJIlVg+5OvdtMdgcqDY3rtElA
	vSE9fNoYLvCQBMya2EpF1RH1wQC2uX5az+4EIcdqMdZeTZUj9cgjDkdDnaRcrdFg9LLU4Y
	2wz8GdFvh6eH+Psx6g2kc59Xzv7yHyM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EDBAC227A87; Thu,  6 Nov 2025 15:01:43 +0100 (CET)
Date: Thu, 6 Nov 2025 15:01:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 9/9] blk-crypto: use mempool_alloc_bulk for encrypted
 bio page allocation
Message-ID: <20251106140142.GA11440@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-10-hch@lst.de> <39f2d0d3-de79-4e13-a577-83a3aeb5cf1b@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39f2d0d3-de79-4e13-a577-83a3aeb5cf1b@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA763C0030
X-Stat-Signature: 67z4oaswppth7imbymdgc6xx9mfjccdh
X-Rspam-User: 
X-HE-Tag: 1762437711-240072
X-HE-Meta: U2FsdGVkX1+M3KIIYxuQ7BbLwnglhGHebYqy1bEVagAbsn1kddv+UeRiAO5qYgKsEm9AgmlXZQyUY50IOv3XnP6N+mwLHyjTktpVZikauL/n2AFirOi1MrYo4bT5enHyMHXIS5NOJXf2jyvJwK98oLJ0/n+wILwE1MUfejVSkrd9cxPfk33e8fFCdotDFrZ9zjQDwjKIP8jiwAwCt3z9RZZWFoWVMf2Zxj19TdknNFBF1uoAawO/wbfFmAn7shuAFAaG4MTT++O0fPPg5XTfJ4HmNNC7rR70YdSFxibwFQ1DEjCCHaO/FomEH3jtOmdFsHqguWLZw13ZRGKrN0qNtXjbJEFN8hg9yyylYJnRNXxNx1icZZLOyo2g5XRgrLrdh+m4GwH70dVNfJ/hUC0l4SzN7xzdxWcxfaSo18f2YoUe98QlIBIUb7uY82VfwF4xRsNNV8eWWCTYgy/T8KK11ZfeUbPid4AAbwW15yGhL0FzcpV5FpxK4jxcYgTwUQtG429CwHcUQNdXi9wBHaxkdzAPb6gbWWqYEgKBGILyD8Pwk003Fsl9jpMH373NM0T58DOsKjLQcUIGqAaBqfrP2TFaJbHyJ5Jy/DFpTK4eefwsirCJ3/nyCIHsKb2RVPJ3z+3U8wcuvUv3XlfvoCejYvku4LwNpfP9HZoXcgA1tWhDKNFtmVgVjvBjtJZvKaS1EWKqnjrRWa7pziVkkAJC7TIL/SQDgST9B9S4h6N3BOE93ePNXzMPMUyJV4JO53XVHTkJhaSRXbHbLWcXBunC0kB3irZqyy1pY7emiughOJtRpH6SNIqLYtJlL+85p4fjloon8tMmWpUfkj4ywYkuPHeJk6vdYa45NnOKzMxW+15il42e3xsk1AzwmCdNKgsjr6LUd/GKjs8BF40lfslcz4j3I6k3iMQuMYMDNov0/HhXDtLJtM+iHMVXCVufePy4PzS8MvAKk7jI+maSGg5
 HMQ7cudO
 mWQaPOsD6VLo2vQ+HEgNhsoWYzzfcrr+EvwtyHFsZ1QWfbc79PvW01L5XCnfTLfxG/D0wVPNpb5l5MgVw15xw1pX2rgG/dVpNScCCOGhle06006v0ltofhRm4Z6uoFOy4KDtbjR0oZwsNHgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 04:12:29PM +0100, Vlastimil Babka wrote:
> > +	memset(pages, 0, sizeof(struct page *) * nr_segs);
> > +	if (alloc_pages_bulk(GFP_NOFS, nr_segs, pages) < nr_segs) {
> > +		mempool_alloc_bulk(blk_crypto_bounce_page_pool, (void **)pages,
> > +				nr_segs, GFP_NOIO);
> 
> Why do the GFP flags differ?

Me messing up.  So fsr all blk-crypto stuff was GFP_NOIO.  I think it
generally should be GFP_NOFS now, but f2fs is doing some weird things
with GFP_NOIO.  (Could everyone please document their restrictions,
preferable using the task flags, thanks..).

I'll restore GFP_NOIO for the next version.


