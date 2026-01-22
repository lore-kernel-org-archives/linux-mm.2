Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEB2D6CFBB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C9A6B038E; Thu, 22 Jan 2026 23:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2101A6B0390; Thu, 22 Jan 2026 23:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D8B6B0391; Thu, 22 Jan 2026 23:14:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02C8E6B038E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:14:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45DFC1602FA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:26:21 +0000 (UTC)
X-FDA: 84361185762.12.EBF231F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8480220009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:26:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YCTlFsh/";
	spf=pass (imf03.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769124379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GwXXNQ8SNbPe7avFy0iFXPcMArPUzkVeRxZw6xq0HW4=;
	b=OXA6utu2FmCj1KagjonO0a902JtcYysN1XKJ+3mann+0ra+KreY1X+D0b+L+dREip88m5v
	QJbSHFX55mBpoC3rXYrY6lW3yFa0UMVlz7p44ot7ya06ZZHjMav4SsV/onejthRAuVhgOd
	J9+FWAvwsrTIAJm0eACOTBFFW4/drYw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769124379; a=rsa-sha256;
	cv=none;
	b=LbikZECxLdK3I1BQD68Thz22XKoDG9Bs8ZTM+tk0IhR8ssYuyGCf7p5QxBR9isTyO3BUyB
	2+0tSVNyVXeZtrnQoxpS8cRoOssTWvyFU9POlX7f5NqF7W+sJxdrjvCtF1rNGwNhLJJn0N
	yeTCVHqXwrAzdEfJPjyV6HrcPdBnhzI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YCTlFsh/";
	spf=pass (imf03.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 785DE40AF7;
	Thu, 22 Jan 2026 23:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13697C116C6;
	Thu, 22 Jan 2026 23:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769124378;
	bh=XGFkGzSWYNYNegHCuCLWkagl8o1IXw5VGAe9BlYwAeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YCTlFsh/PvlHEsFrvzeBnozx61sK5QqaeiMfQ/Wc+Sop7ADqPwRPj93gz+c7Ywx9H
	 phe4+Vp6OYAWWGe6mxS5+brmNZKJfC3d7Vbnq/jXrPUWzOBB4T7rV36VoJlKzWAHX+
	 y9+fHgwFz/eFYVKvs7pcSTGBYkCGbFjNPsA6DDjo46VsA0esXG4XsE37Szqpe7KF/r
	 dDS4hFd1ILM9viLxHowpQIrUCJTa6v2yzo/wpy+X6rzn/1kfdSUklKeJfnFm8Veg5u
	 6uSHTF+uCfTCqsto2aZddrU23DQAZMcA4pvH4e+86H8Mp29o7IhPRLq/bmrwxo/1/t
	 wkfv3h+j1kuuw==
Date: Thu, 22 Jan 2026 23:26:16 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] f2fs: improve readahead for POSIX_FADV_WILLNEED
Message-ID: <aXKyGIH-ZuvCI6h5@google.com>
References: <20251121014202.1969909-1-jaegeuk@kernel.org>
 <aSALfvLUObUGSx-e@infradead.org>
 <aSCpzRW8mUhNnjHB@google.com>
 <aXHhFN-feFYFcKYu@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXHhFN-feFYFcKYu@infradead.org>
X-Rspamd-Queue-Id: 8480220009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: yxr913oaegsgf7fry331rcr6bo1qrzym
X-HE-Tag: 1769124379-39539
X-HE-Meta: U2FsdGVkX18NndLvIzBlH2x3tcHGtpbiczIaewl4dr8QClTigr3cT3cfp82tcfJN+Jja3Wjm/cCYdq4ZXhV58kJVuy2kc3w1r1u5ffEtMR5HCDPhDnOs7dfQktWGOr0EuouUZzbdUNMITyvuXctZHjbl6h9LNIRgMNnRDPPNl5UXJDRxSbqjycksit8TjaO828JbBOu7Srlq0uDuApOcGk7JhdOv6VvK8tUzNMeiOpyhmOCUFyOpkAYBzebrTQtaPosZovZ5UVmDaobY8nMjJIsnWJDmKCRVe4mHPt3kBf0+8i2VKCmo53pImUQXeuLKwv8jnz7gCrStqDibBIKap7HtAd8LZLaVEy7c/yiGBRdi43v4kvDW01lDxTYIviQ6xbnl2fndsfoGLhnwfg8tVuUlfNCri6zsfviTF2IrqXvamrFpp7i9m4hb9oVPJiDy54iPKqyGpjFRxMmhRczr8Iai+NmDn98MJlKyZV//2wwMFX1rxovldT7T427XOMjYZse4AJwYnIH9l4LnghJiPGSh6HC7CWj9uAsky3Jrtdc4lItZS7lzYzOi8d4NraVrWj0BgZdmV5xzfaGcx/kiMjSpTukAV0U+rv+cR8YU35LLYu6PGpu+WLYPdctBPq0buFhHmPJp/g+o/MpMKY5UFRFxmW3Hc/07MokhnfF92/iAh2bz4oH5sboaLSK4aJYoMnAKcLmzfI5bNaNkSzLq6AOM3ePacEfclUBH81WFBZovQYwbVD4JeEHUfzuwddH0+9EFkvUMXkDUx4lCaaUKkEBWkjGNbsPnCxyWg9FimBYerObXzZK1+6mriWKr2X3nxkRcdoolstpngd1rB7I652E+4nrZWfAbutRBJ1Rr/afCwCWAi7hDnoTrBsgxehe01j73V+oYcd19KplmSTRvoOAadvAXRnFn1CD2/Qfos1IwGzLrMZSG6zbg8kULqlW3JU4eOPnY7IiRrMH8RIi
 paQdQISC
 TVmtlEdsaYlX5/MokSYsimH416Kgn28+nlXx/xAIx0MqkuPd2xWBYyvj7XOWzor/kMIwFWzWPeIkuVYAyuNLWbU3adfZT5nuNPzN6682OFESHPOn+QyYgKVLsTUnzRMd2Wh9DCVwsfGVBUrWw24ewenSxSWAvgxWqaqfOPAicjmPpdNSEBmAnkNuffNrm7HJGLJo16pl1xH3QZpOJzZVsAYAu0547cNEDX2OsArGM0t0Er8Bj87W9M9M1XO+aI4W4zEkMsib+sdG6pmYVZ13fZEfnKN6yxOnMcIXbJn5v3TSqcNTunbRoz/OH9WaZaIDw2Jm0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/22, Christoph Hellwig wrote:
> On Fri, Nov 21, 2025 at 06:05:01PM +0000, Jaegeuk Kim wrote:
> > On 11/20, Christoph Hellwig wrote:
> > > On Fri, Nov 21, 2025 at 01:42:01AM +0000, Jaegeuk Kim wrote:
> > > > This patch boosts readahead for POSIX_FADV_WILLNEED.
> > > 
> > > How?  That's not a good changelog.
> > > 
> > > Also open coding the read-ahead logic is not a good idea.  The only
> > > f2fs-specific bits are the compression check, and the extent precaching,
> > > but you surely should be able to share a read-ahead helper with common
> > > code instead of duplicating the logic.
> > 
> > Ok, let me try to write up and post a generic version of the changes.
> 
> Did this go anywhere?

Here.

https://lore.kernel.org/lkml/20251202013212.964298-1-jaegeuk@kernel.org/

