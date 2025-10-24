Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A801CCCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2F48E0068; Fri, 24 Oct 2025 05:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044968E0042; Fri, 24 Oct 2025 05:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D148E0068; Fri, 24 Oct 2025 05:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5ACF8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:05:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88E19129FDF
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:05:35 +0000 (UTC)
X-FDA: 84032424630.28.5E8FDEA
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id E50044000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:05:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761296734; a=rsa-sha256;
	cv=none;
	b=OQgrswfUABH5auJJ6hEOiETZXPdg3G3Kf+Y21o0V/CLJ4sa1Q0R9opxKmeEcaAY4U/0MiG
	XClKUmA77RSeCARI+FDT6MtINojrMOcoZFRq4w02iaJRvY2ntL3t1h9iKDi4B9029QKQPz
	bSIj7ebDb5a80rbbzl1Zn2t5KUt4L6o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761296734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qMV4qd7uexYM6WuhcADQdoe1w+LK++OHsRg+a1QFRk4=;
	b=S2gK+tmL/2qyuzpRWV3PJ9QK+obEILsfwa8J9Adaqc81aUb64emW8u8BhrIfjGBWHjfCMu
	94Y31FKwBy4nOhyqoL+MYaFAqjCvkNbJ/2eRPicBqkfKAamOXUs4TB2W2vrhfpc0KgjUoY
	knlh4seqKaZKM/Fneri7Ndg7b/VKdJU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id D43BC227A8E; Fri, 24 Oct 2025 11:05:27 +0200 (CEST)
Date: Fri, 24 Oct 2025 11:05:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 1/3] slab, block: generalize bvec_alloc_gfp
Message-ID: <20251024090527.GA27267@lst.de>
References: <20251023080919.9209-1-hch@lst.de> <20251023080919.9209-2-hch@lst.de> <50e96fd8-114b-4de3-939e-9ba606e64b06@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50e96fd8-114b-4de3-939e-9ba606e64b06@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: qosqw68kq9w1sj1fjas85fodxgx1a61i
X-Rspamd-Queue-Id: E50044000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761296733-300757
X-HE-Meta: U2FsdGVkX18ayd7lDCl9J/G4iDGGPS1wceozRuDU3EAwQclCFta6bI4JFoQ42D/eeMUyBZAlpiqAdenZPZ901WUVd5Sg8ASSdo4AVK8zkIWdnBM4MY0iAu7tNLTEN2O58cqtFIYhcFAb8xrMS0AFjCMdiLozwfyx5ZXI8dNMgP4Y97ufPOE5oNp7+sdrZ7WiC7juhEuv5toIu8iSxR9kXEDggaevjZoTCD6poq99kbpCMwPkLHl2JVuqChWvwSBJjaKd5fQAV9nP8xyBGwo3NW3B4lhLisuBpvl7iwtNZIQix3zhiVRp/GBJscyTtTgi7g6Zr3ZrOnj50wuLMuep8DCe6tYChsZJVxtA13wZQhds42o1Q6Z3BZ/U2q/MRkAZ8YYfs0q4o+BbgU1FmhzXuw5ustcEf/mMgOtYMRe13BXc3HAuliev7mWUd/FgiRNYo77qZWnVQvaeP6JfV4rgMRXzRAkySHKPX40Qp7tKZr4ULgMFo0/tg2wBZy3RYmYNyz+hF94bJS/19Fz3gCXHp7WO10m/8+/nqv8WqlbBpElSxmKS8U4q6wo7ZrE+yBDIQBdkuqRc4WgVBB7nq9UKKQrIxOImS1QBvkVBae5MaWPsId4wnhgLiIhzB6zJMzV9w8xR2kBFNiMXHY3/dc9cRsd3zwI7r968RGkh6GYu6Hif8hwwdrC5CGt/Ei/4huW0E3vVWW1omlJMvlXAP1Q6iHjQ3aKrrrWmz9QVveOMPQ3kympgAFeMK5lZ841qKKpi8hVazZilDGcjEEJ1ulVWO6Qn7JyGpvH1vrYA4xniQ+BVzGC1gCqEn8YAVYupIZrn4cNdI6N4GlRXl6iJDgYqUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:38:20AM +0200, Vlastimil Babka wrote:
> On 10/23/25 10:08, Christoph Hellwig wrote:
> > bvec_alloc_gfp is useful for any place that tries to kmalloc first and
> > then fall back to a mempool.  Rename it and move it to blk.h to prepare
> 
> I wonder if such fall backs are necessary because IIRC mempools try to
> allocate from the underlying provider (i.e. kmalloc caches first), and only
> give out the reserves when that fails. Is it done for less overhead or
> something?

That's the mempool behavior, yes.  But the bvec allocator only has a
mempool for the largest possible allocation, while usually trying
smaller allocations instead.

> 
> > for using it to allocate the default integrity buffer.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> That says blk.h but you move it to slab.h? Assuming you intended slab.h.

Yes.  I initially had it in blk.h, but it felt more general.

> However gfp flags are not slab only so it should be rather
> include/linux/gfp.h - added maintainers of that to Cc.

Ok.

> We do have gfp_nested_mask() there which is quite similar but not exactly.
> Maybe a canonical macro not for nested, but for opportunistic allocations
> (if a one size fits all solution can be found) would be useful too, as
> people indeed reinvent those manually in various places with subtle differences.

That's exactly what I've been trying to avoid indeed.

