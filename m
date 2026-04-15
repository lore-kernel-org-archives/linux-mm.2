Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C390F43848
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 17:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735666B0005; Wed, 15 Apr 2026 13:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D086B0088; Wed, 15 Apr 2026 13:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649ED6B0089; Wed, 15 Apr 2026 13:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55CB46B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:15:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E7CC160468
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:15:54 +0000 (UTC)
X-FDA: 84661442628.20.9D2DB1F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 47E61C0007
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:15:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Y/qzKwPC";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776273352; a=rsa-sha256;
	cv=none;
	b=Zy3qSPzaFh2Fym0L2EJBaQkav+htoxpTSGO1Ew02iT8o55ZfedkbzZndMZ3QuIbDmmHkRH
	NwUOhWpV+f586IIhUxMyxypDS9LptsMblz+6z9vQgdyEev4QOC29lSjKkeEzbaZkCqGTd/
	1uftzteZWrrfaEyyASBRHmMKTTo2zdw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Y/qzKwPC";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776273352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISsLIKP4bjUxgr4BYttgZs8l+uxApeegxanE10R4kzc=;
	b=1jOu2VC8NdirCC7cMaMWmSkeNUfIF8jXLOitH7fjPkTvtna1EpBicajZMHkB8URNH6q/Hn
	DACf8pdPcv6vPSEsbWXLGEJrxrOO5EiMHA/nxMNQoHG6OBjgtr2oyn15b2G5FGRgkCpwC6
	aXVAwjeDHA9xTeBmW3IUEQCsRKI6rO0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ISsLIKP4bjUxgr4BYttgZs8l+uxApeegxanE10R4kzc=; b=Y/qzKwPC6h8YPlkBZrqWGNfOS9
	5WTrl/NWtmNx2pAqg9rGoNGsdTZbyEoa/UdSYzqUEldGyhWm8V4whdF3OLQUdwLt1eP0fAqmfrL65
	l7Q9dYGb5zIuRdxB3tfwHPxFpEPav9jk3SBFyrVHZsZThn+Lqx9KMem0N9hpLf2rGAPTEH0wvPUNi
	ZqKitex3Q//ilsBhw/U9xr7IxjJotzWolQkSg5uCdBphNeGYZqWaegBkJggGzOJsoSMz0hnvCY4wB
	6cxYIv8YOCP6BT8rt/FLq2pRni5qxu/xDz8E6P7NMiDThQbpryw/4ujK93ThvoueCSWF0CapbVOu5
	49KLzwaA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD3q6-00000000CP7-1hCw;
	Wed, 15 Apr 2026 17:15:46 +0000
Date: Wed, 15 Apr 2026 18:15:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ad_HwhzlNPUEKQi6@casper.infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad_AVHe7RMnGrGTb@google.com>
X-Rspamd-Queue-Id: 47E61C0007
X-Rspamd-Server: rspam12
X-Stat-Signature: 5o9gpqwxzi8e3ewshs7x6bnhkomjtffy
X-Rspam-User: 
X-HE-Tag: 1776273351-539347
X-HE-Meta: U2FsdGVkX1/tvsw2CZDWoZhq9vrBFxpbqjdRZnsb7sBk89+PkOU81tB7Fg9XxN0zQKXWKEzDyBnqbo+ydFVfT1TvT79osatv8KrybONZ67MX5oQ6W/1CS5FvNW3o7Xw6M5JrsyXUurCWFHg8A5A29FDSndQbtVuHZ5ajgTRyaASprcxh0e+LMOPcOevXaJRLU7PS8SWsBAGdcCc6znvD1hXmyNF/YfIwpo5lf2FfrAM6V34dJu7PpB3JNOnFr2g4MtLLshIUhlGb0LtVjWxFlwdptLPSF2qMrkB5xpgrAzbKeknQVWCugjQqrsIz6Ofjl+dz0Vm/MSC7/uojAPW5ODheLO7DmCtQUAPINt0+HAYMkw62ZPiSNeoj2J93nH59vbsdzOhV7aF1YaIQGQ62HwisxLN9BWWleM/d4mYpPDP9i4DbZDIAmg1ttdDnFrliHUuSNutX1kxZuVno4Goe83Dna99G0kdSszYcJMx4pm2ZW3BUWacNyGErb29EfS1zDS4gjo7Bk7tY9EhfpnevrGZdD89JFhLFpZiNviOwYRkJPkBFElbjx99pzh2OGfLlXF1OIvOtKzAIHPuOajG9GA+Dk3VJqEKWJk/0MFR8C2KWS9CgEQPcMRWw7osELLeqXj75mZG27Cd2H33oprFzVQnk47UeZBS+QDUVJ5N3yjOLuJww2BKP/bgCwIzLJOumEduLDyQX9frHuwDPhAc8yl6Z36e8JXLLITAZVp+kT324KfKTeQjCmnTpcs8Xw8zHxRFnRqKvzopAlEwjNRe9PzWSyh1qpNBUnpc4jEOZj1ae8yDR/7O9O0VGNx4jsxJEeHL2RiRL12INKZJPhpsk6Zs9ntobSLyxfJB1FlfUprOWy2e+uudR76fyVqDh8rPqpEdYbfQJsL5LuLvl1ucrHRDuQbRQTlIT4WcGgifdEekjKMSp+43Vk/UZWV6XvgkBPQGBgKBLaVqMeu7ewmx
 kJlKWYwG
 wojTjCYbB72OuhmuSFJFojA+cR7EWFEQwyAA9scH7+BHkWYcvOQwHGjJZdStJhGMjrF8y5xoZ3yElckJEInpRM2X07ARG2r6mla4mk5zrl+V76dPqwtPQsHHUUBIUeCCuyBj7s26OjSJZowl4OYvsiRxkE8O3YWYRDLJDM6zl1vhrGnfB4qKzIuCFtejczHY3PEGih7EVHOJtXio4xlHxzq7oA9HG9CvntDEFEjulvec4XzFBrYmqJ+eRAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 04:44:04PM +0000, Jaegeuk Kim wrote:
> On 04/14, Christoph Hellwig wrote:
> > Please add the relevant mailing lists when adding new user interfaces.
> > 
> > And I'm not sure hacks working around the proper large folio
> > implementation are something that should be merged upstream.
> 
> Cc'ed linux-api and linux-fsdevel onto the patch thread with a proposal that
> I'm not sure it's acceptable or not. 

You haven't sent a proposal.  This is a reply to a reply to a reply of a
patch.  There's no justification for why f2fs is so special that it
needs this.  What the hell is going on?  You know this is not the way to
get code merged into Linux.

