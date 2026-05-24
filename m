Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D67CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 19:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF056B0092; Sun, 24 May 2026 15:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7106B0095; Sun, 24 May 2026 15:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3C36B0096; Sun, 24 May 2026 15:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3086B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 15:59:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75F8A40D86
	for <linux-mm@kvack.org>; Sun, 24 May 2026 19:59:20 +0000 (UTC)
X-FDA: 84803377680.16.47C02CA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF2D9180005
	for <linux-mm@kvack.org>; Sun, 24 May 2026 19:59:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ar8psj0a;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779652758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHpA1ZzkYv5b4KN+kSM30g2nFp55AVavdrQfo+cc1Sk=;
	b=3L6bM9n69GItJu362Rh9VZHgTx5Uc4iv7WwShE/nNeaavQzd1U4KGbTIUtJk8ZoCEU8dUL
	jd9DYUw+Xn0ikjBehqqiwO6NZV6qDnBcOUyhFpUIO8hVL9V6jcfh8fm5hTFfcxwQDCM43X
	+wGVQknlZTD2RKOr/QSFbzbwuimlxJk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ar8psj0a;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779652758; a=rsa-sha256;
	cv=none;
	b=f0+PA5MCe8us+d0nqzZhNDE5oXkhVe5S3wv/Gf9nVFqtrTFARYRouh9hj2cwOofpM6iOsg
	6JIE4DcND7uxbWEGoZNfMVShmT+JPHhg9Tm8QLvxjrwK9L1FDkTy/KAd8FhBv0BM5oeL+z
	jMgyBCDexcaTJiKuFXdNyZ+wL3Cd/m0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hHpA1ZzkYv5b4KN+kSM30g2nFp55AVavdrQfo+cc1Sk=; b=Ar8psj0aA9bZQFqkFB4Ib+13Hw
	F+c1DCDGmUEgM9duLy0u5PP3NQBgnveoGxvWrWHxGUGv0/pAyj35OTieGeOnoM1QFhM5kM77gLVnU
	izfepiRzekqLwdZYiN+bgYSc2s82Z9rUcvn5gRJbvXm6pOy1hlniOTaYX51pGSnP914KyOEUi7VuJ
	HFfQWSJP8VNfhk8Q/EpR+XNKlk0ybostK3QtTfmOUpSoLaijv60paSpTqp9OVOXthz8SlRpMTpXtz
	cJQbH6zaoAm9oGe08LRC8YswGDBnhPd+9LONhVhVvO5VF99lrNdqRUwQ6iIxMqaQZWscSLkVS2915
	JLvmMD5w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wREyb-0000000ChJ8-23fg;
	Sun, 24 May 2026 19:59:09 +0000
Date: Sun, 24 May 2026 20:59:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-mm@kvack.org, david@kernel.org, surenb@google.com,
	hannes@cmpxchg.org, ljs@kernel.org, ziy@nvidia.com,
	usama.arif@linux.dev, fvdl@google.com, Chris Mason <clm@meta.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as
 movable
Message-ID: <ahNYjY1aQlgOehlm@casper.infradead.org>
References: <20260520150018.2491267-1-riel@surriel.com>
 <20260520150018.2491267-35-riel@surriel.com>
 <20260520174749.GA1458531@zen.localdomain>
 <20260523155859.GF183694@suse.cz>
 <daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF2D9180005
X-Stat-Signature: 37ych4awh11au9iguk7mxnkmscrdhr1r
X-HE-Tag: 1779652757-936542
X-HE-Meta: U2FsdGVkX1/Brfjw6tokQ3v1+3M6UbQJTuwzo6twN6NQVrOpsny3CBe07oFqGvR93aqesHezARLkayIP5Vh0ihBfQO+aOXu/MaQVarF9sOL4QelLtH9Zj53UYuGvK7BmG2UIe4l9SB5/W+fe5wWQ1449nrwltyyuV2Lz0k7/xm96FyS64kJCIILe57WtcfE0wz0ZpWNSbjGAgDpEFbsuNUfyOdtRb+o9Kjo7wDXH+j8A7ihjXFzJSs1GZR6orULjaRyc+a5vXC8TjORJm6jrUaVtx1Wu5FpS0cUj1bmnFclE04Oi5Nr6F2dQ1j4+ogmwmKcXGnK3YXsrTh5keyk3UlMxxNkkoxww5KUC1PUgCH1Kgv57QBouAU2rMYnRo31t5cP7e1j5U8DU3jvYp1GKWMCA7jCwWQqE/WY+X12dkMBK1bT98jXHPuhmuOR1ixlZFP0GgWZBpxROun22MGjcH9256zs1/tI0LWHBwhGGGFWDFPaH+r1qUAlzNTeZ7G/tqXw6S6Eo+mpYSbHmIa5bJhgHTylc6E2xQ9IeVf6gTAva5gNAB1rSTdPmGtTrje891DZfP+PzytjqdtGeEg+SoguLCrao0ocUacncLSgrVG4xDshTUsDOtm3p7LOJ06xRp1NzMp6hUedae3u5iRyoCcfH8WhOhA1xDHg7mA6Ji6sou305ydK966UK4d3R3ye3dP3LPTWPyEd7EVgj8SBGv2QgJv4O8gbAzlMOx9ikwjkTup2Q2QDfwWNUFGRx8vTHTwd4jl5rNga1dFj9VzMVRj1i0XxpSVuYal7boVkPsa/Oj1yrN6FRO2Q18QabX7dYOQ/oKyG4ACfrPqjRbsj4zam+m+Aih8xLDOgH1e/LuUcoEZIXSHNmojLRbqSmXa9/g5U055Lq+yT/g5D5IeO4EuYdw1W1SSHNdtrARlkLpeRVafZoIon/zq091rGaB1J0bv6c9+DQv9YzEclMGVq
 pAX2OSSx
 y0BE+2D3iPpcnXA8qsk2y0WcNfs23pjZNhLCW9aI74+3+zy8tUDRBldtG2JPIXPa19vGhUK/C0hEtnM7GAWKbXVftFzdVxCJ+s9MG7nHRH+AnWM+jo9H3IntyRBn18JZQrwjLHmzB7oBNOyVGemdi+yLri4/yPtmOoN52zePiqp7wF/WAYZUlDpQdvunxPKA1kUPY5/wkBJ6X4RpJQlUGYTZHO3/BgI/MnrkrW1B5eE7YfARXv6LeVZEe9nNSew5FP/7Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 23, 2026 at 09:43:23PM -0400, Rik van Riel wrote:
> On Sat, 2026-05-23 at 17:58 +0200, David Sterba wrote:
> > On Wed, May 20, 2026 at 10:47:49AM -0700, Boris Burkov wrote:
> > > My gut says it is nicer to just transparently pass along a gfp flag
> > > rather than a carefully documented movable boolean and let the
> > > callers
> > > do the right thing. Just a nit, I don't care strongly about it.
> > 
> > Agreed, the GFP flags would be better and also a bit more self
> > documenting where the functions are called. The patch is not
> > standalone
> > so I don't mind having the booleans, we can clean it up later to let
> > the
> > 40-patch series proceed.
> 
> 
> I think this patch could go in by itself. It doesn't
> depend on anything else in the series.
> 
> I sent it with this series mostly because it's needed
> to make the series work, and to provide context on why
> it's needed.
> 
> I'm happy to resend it with a GFP mask passed in by
> each caller. That would look better, indeed!

If you're respinning anyway ...

Every use of GFP_NOFS is a bad code smell.  Filesystems should be using
memalloc_nofs_save/restore.  The problem is that it takes deep filesystem
knowledge to understand where the memalloc_nofs_save() should start.
It would be good to lift the GFP_NOFS to the callers of this function as
it gets us slightly closer to being able to replace it with GFP_KERNEL
in the places it's not actually needed.

ie what I'm asking for is, please don't do the 'extra_gfp' thing.
Just pass in gfp from the callers and make them all pass in GFP_NOFS |
__GFP_MOVABLE (or a plain GFP_NOFS) for now.  Someone can come along
later and change them to GFP_KERNEL later where warranted.

