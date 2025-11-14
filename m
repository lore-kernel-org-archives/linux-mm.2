Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5926ACDE006
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 05:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5AE8E0008; Fri, 14 Nov 2025 00:56:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DC38E0002; Fri, 14 Nov 2025 00:56:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1DE8E0008; Fri, 14 Nov 2025 00:56:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A07858E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:56:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5193187E68
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:56:49 +0000 (UTC)
X-FDA: 84108153738.07.E2C809D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id B9704180009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:56:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763099807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZJFTzxmC3eNw/+ZyrE96yzYPuKvXhc9iOIxoJ5RuPI=;
	b=B0EhQ2PMaoy4qiWBu0w/cGkWcWSfx8pnhtixMPQ9YdCJZzzMUznWJ1fXrQTS/ioiSiYfIv
	9sO9K6lIq7CQEn5PHBvJnEwskogkNHLU/9OwiF+j40x5RT5dWv9oH6Xl4lLBJUzFB7rfP7
	XAmr4+4O2PJeLcrCW3xO/sCdapORKW4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763099807; a=rsa-sha256;
	cv=none;
	b=E+6yoB0zHQMkaAgW61u/CNPnRaiP1E2R+rxgmAxH5bCR44B6kJ+S5Y2ELJ1uHh+9hW3vzU
	eDaCO7aWZ2oLB04X0VmOKLgy86qBi4M+a+YlFjOxpj6CfIP1PpcV/sCybZ61RAkGnu63p5
	uTJTM4X7AG6uP1xE1hRhWUl+y1wLssU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 00C8D227A88; Fri, 14 Nov 2025 06:56:43 +0100 (CET)
Date: Fri, 14 Nov 2025 06:56:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 7/9] blk-crypto: handle the fallback above the block
 layer
Message-ID: <20251114055643.GB27241@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-8-hch@lst.de> <20251114003738.GC30712@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114003738.GC30712@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B9704180009
X-Stat-Signature: g7135uqr14851rc7xnq1hqfjhyb3ik3u
X-HE-Tag: 1763099807-147931
X-HE-Meta: U2FsdGVkX19IMNDplboR3LohTCXU3UJU7J8d7SnHGpJ+/KBfCno7I/WXKKAh5GyC/aETfXRR5BxjOJ63EUOIrEdx+7aLbyRHyHwDdmgct8gwkI1WSb6o1gxDTiQWDXHT932s6w8FLuxPHF1AxAV5dnDga6ubT+2WfDsMborObxaqCkXF/nlGvPYa4VHAld1T24L/1YHSDI0fvSzSXUwEEbnNEMk9HaYXx0NQjVZ7ib9igImKD547ZeCcf7pbcdvG033UsuzfVfQnLtUhuwIKBVR2Lo6tBBc1AcJHyEOUHknruFbJgrc4uL5pjOR5zNHrKwawoln8eU084Lc7Rf4xh1P4rmrdSkX/WljIUqYrTv4JlWMoDeIAh1uuf82i0hR7HaqyyRGDKmCUZ+vjKNi+kB/NGR5HBaTovJRoM29Ko4GdvIMe4yXllVJ1eYhHEACZZcLM0i9H+4UXn3UqfkTbh0gKPqtf6VPZA2wfCCz3M2ULPS1EbuLJwWo5EjDJ31cwsrHejK40CjQa+0spBgiYgyC7glIPuB55splrTT0ST5rnxMT3v/eq2QeI5ge6rKSn4NThkEyjlvhjjb921nTPYoIihGMIE33DRHJ9qqQFVjeWMtxje3TVApewqhxtiDYG5cJrRNcDZVmPvDkMpnYIk/Rd9EA8+F+j/LQX2ol8fm/MK76zaWhp7temvcY3kZoeAcCBu3Eqnt68cuS8vBT/2wNX1/0K1kT5GDIT/3iIvP7sUicQ0G4WN9JoPsgoxqnL+HpkpbvR2G6OwI+ZfGl9ljGtAUU4ebLI/eWTLLbhkfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 04:37:38PM -0800, Eric Biggers wrote:
> This omits some important details.  Maybe:
> 
> /*
>  * bio READ case: Set up a fallback crypt context in the bio's bi_private, clear
>  * the bio's original crypt context, and set bi_end_io appropriately to trigger
>  * decryption when the bio is ended.  Returns true if bio submission should
>  * continue, or false if aborted with bio_endio already called.
>  */

I'll incorporate it.

> > - */
> > -bool __blk_crypto_bio_prep(struct bio **bio_ptr)
> > +bool __blk_crypto_submit_bio(struct bio *bio)
> 
> Similarly, this could at least use a comment about what the return value
> means.  It's true if the caller should continue with submission, or
> false if blk-crypto took ownership of the bio (either by completing the
> bio right away or by arranging for it to be completed later).

Ok.


