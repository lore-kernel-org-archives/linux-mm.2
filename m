Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A458BD358D2
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E617D6B0088; Thu, 29 Jan 2026 03:05:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F076B0089; Thu, 29 Jan 2026 03:05:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11576B008A; Thu, 29 Jan 2026 03:05:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF7D66B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:05:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 577461408E8
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:05:26 +0000 (UTC)
X-FDA: 84384266652.27.4B76A38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BC18F40012
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:05:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=skHak3je;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769673924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4R6ehO7jhv28zJwl/UG7FND18mtegYIg/NBBeJ6x9E=;
	b=Algi+GccQ+l/7dIZLSov+gSuhqnjajcPEoCvcGrMq1xzs/m20doV/QAhuqHmB06n781MfH
	27qt4DI6NAwBzRNBtDhxN//F1hN2IWWqumAghFHhCIDbgLvUiTvE7Qa+MogfcZiA83wgiE
	EbNxuHhzOW260EPv8zOmUOHG7GYG5+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769673924; a=rsa-sha256;
	cv=none;
	b=nHYPS9K0wb32Qe7WkVIqvyA50JI84MFvjkm9SqbsItbIf3A+E1gA++EW8Gnupif98oK2RS
	wMinvEY3ErOgYObNK50X/ir+h4smfOnYdBcT/n7rBaYNmYQTxEdFkxCXj2a/Sj2iyKMT8y
	WXgwDopI7zwCJzYFycdejtJr1SfMJIM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=skHak3je;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EF4F6012A;
	Thu, 29 Jan 2026 08:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C326C116D0;
	Thu, 29 Jan 2026 08:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769673923;
	bh=i22p4sf+DSGw5s0Rcq+vLuTdckFDHomjbE1xSKrN/1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=skHak3je481fNw0ayYjO7y493PFx2ce5kzqQ9HAm1wcGlEKvhLSW2DL58/l9c1Mor
	 g0n7Nw5zEEI0y/NdCN+rV+jldL+a4jYxLwRjdckEBxVowHltqTSZFGxpgDCkXe1F9E
	 FK61DrzQSfd83p7KvlzAquTCZQHtR1LRcjxFA9bADMfn45DVVZtkt13dElB3tnKiw4
	 2yxrniX7u1ExsegzmUB8dezBfJ7c0bJWftmHWBm9QL8XyLTz2x1YZ7X1gOKKUdAkM9
	 +DruqvmZJovjkyoZME9LhOoWvKm4qDTF+0LzY08iDR8FvH35iIxHCw0RISHY824STm
	 RUrUPyKfd7skQ==
Date: Thu, 29 Jan 2026 10:05:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 0/3] Convert 64-bit x86/mm/pat to ptdescs
Message-ID: <aXsUvOmmUBEjrjGY@kernel.org>
References: <20260128224049.385013-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128224049.385013-1-vishal.moola@gmail.com>
X-Rspamd-Queue-Id: BC18F40012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gctbdgkuygf19qnr1zs5k6qwyxdhh6at
X-HE-Tag: 1769673924-818573
X-HE-Meta: U2FsdGVkX1+id4w+XRRSNA/2A9AqGo9KTUdYsJCai7E8yixiNw1ic9YQFPUAcN/kpRPttULvfetTcarBjuAGmGkXR/QZV/GPffwycnPHPdN/IGHLFfOTypzXAA/86L/G2ft1NqQGR0MNqGNPgX6UXCfPIjXXnY2ABeHvRooHz7bLMv7TGbOMsb9opoYPFtGkdUsYAwlcRGUNzRFY77ZT8jgY/r0gxYvNTXqgH6KxkpQtHkuJ0DFLAIGcA0nuNBZn7jyHROnAmsTpYECNIfl7lYHeRBzcYlNXlbcT+JzApzPu+RHrzkJ3dISXAjTuCKU1CQJe017zQNlwy5VJoGOdMaHYeXOH+k1MdGYtosNJIra8DtesMDDKbwDn4FPxuRtX0AmHuDZlP8vu/oFgRLHup61R5RtBFaT9eRYehc6MSWSkQJu81d3CLDvdrSgzzyZzfToajYSAyxU9qLQ6j5DqFUKHKJ9slzWwQi4/n4QbuJ+H2E7BDdyJFNJ5TANgQzPC2/T5yvjFbxLfyjFInjodBqd9WYEhdBNj3lPLbe2L9ikkVfVipBBMTwfOduVBg3FNPdx68KUYWax20MFFw3uTwQ/KexgQFtdhrZ2S3AobBt5/XsZf51jsoOT6IjuqDBhO95cNakJBMrsoKuhigTVqsh9nBiFKGpPhufhGN86Rxyd5VBDLrKts1KPglml+bkAsG5uQyRkvbE8Ik898Vkpd9OVboUPwPBXfzranBL+mKNmyUIy5mxkBrvpr2t6sD/zY+M/rl3CcU5jQBoSrx+gjYTa2GEq3WhjJYohaVX/0YeNZp6ElcZAKehPZfsB68/abfD8Gm9c/NqlAFHsaEPNDfsi5YhAG7WgyaeOXQud75f/gQpBpk0jh2hbKabWKb+Gh72Of9Xf1gNO/mqGrjlNvsS+lyk+oQWIURlTP+N216skEe/q3KH5NE8yDbser/c0QEi2XsJrcZgk3BZH1gdi
 9jJJ6Wpj
 YMrJaItMs8C6p+k9Q1bygd2R/iCM5UHFh+nmM90enmxlboP0yiky0pGEQ3jk47Ehx/OHSX7Ij+Hs7/7q9eF2DhraUViNFBb/qRYcs/BAns7yaEGI3gfaqe22YAgUGPo6quE86y/OChPyFM0Qyr/KeYrjNUmaJouyh/05BeiP1mocpSNHuDePtCU/MMqo6NIgqkegCKBog/SbSM0s3Mbs0WjwuMo+24TywP9ZRtjZa7A+HBShTIsLVp4ubH/uY5lsM/POWi1cwygPWPXzGeAImTKF8cY1TUjKi+euhvZGLODKpW6TDF+31i7TjQNQuM/Lh9bN4CkTW70MTeCGeCjWtjFelYyikg0AKjhiMfXmba+XF6tvoR/+O51RfKwGW81lSzLG6qhOvWWT2FyeA7LaKcgWIhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vishal,

On Wed, Jan 28, 2026 at 02:40:46PM -0800, Vishal Moola (Oracle) wrote:
> x86/mm/pat should be using ptdescs. One line has already been
> converted to pagetable_free(), while the allocation sites use
> get_free_pages(). This causes issues separately allocating ptdescs
> from struct page.
> 
> These patches convert the allocation/free sites to use ptdescs. In
> the short term, this helps enable Matthew's work to allocate frozen
> pagetables[1]. And in the long term, this will help us cleanly split
> ptdesc allocations from struct page.
> 
> [1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
> [2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/T/#u
> 
> ------
> 
> I've also tested this on a tree that separately allocates ptdescs. That
> didn't find any lingering alloc/free issues.
> 
> I've realized that the pgd_list should also be using ptdescs (for 32bit
> in this file). This can be done in a different patchset since there's
> other users of pgd_list that still need to be converted.

Since Andrew merges cover-letter text into the first commit changelog, some
explanation about pgd_list should be a part of that combined changelog.
 
> Based on current mm-new.
> 
> v2:
>   - Use pagetable_alloc() in populate_pgd() - in patch 2
>   - Rename subject line to specify 64-bit (i.e. 32-bit wasn't converted)
>   - Added reference links to the projects mentioned in the cover letter
> 
> Vishal Moola (Oracle) (3):
>   x86/mm/pat: Convert pte code to use ptdescs
>   x86/mm/pat: Convert pmd code to use ptdescs
>   x86/mm/pat: Convert split_large_page() to use ptdescs
> 
>  arch/x86/mm/pat/set_memory.c | 43 ++++++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 19 deletions(-)
> 
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

