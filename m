Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFEA2C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 20:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91076B008A; Sat, 19 Sep 2026 16:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41A56B008C; Sat, 19 Sep 2026 16:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E846B0092; Sat, 19 Sep 2026 16:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B87A86B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:15:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9A74140311
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 20:15:53 +0000 (UTC)
X-FDA: 85231617786.19.0DA55B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D11D40007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 20:15:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cA6gOk9m;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789848952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEklChI0Z6DSnGg1lTHUJ1IxomPedF8yLHgw2QGf2q0=;
	b=m2NOOuPFmpfAnhM5R7baT7hk9tTWKyMSnQl3htv7jTD7DfEuJ19FP/B0yNgHcvgGc09FpA
	0hoDks9rdonNj63Rq6eB5VPrW19o2L2Q9m+3UDB/7Rj+1GDXK4qLv7ZkTybSrRwqBWtKJD
	RgVLtRo0548kWSZAj5MU/x6eIukRPZs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cA6gOk9m;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789848952;
	b=gF1ISOpdkQfyualhjNXNBMASo2HfirOn2/J13Hr3y0ojGc0Nv347tSqWPCcGd9+p6U+tPu
	mJdQ+EbE7XR1PRyEY1nzeItyoTIf3/iX5Wg7F30CwVefWkHp0vyY07b5tSQSpfbaZFSu7v
	Ug7bmXhReiJlbQCqbRBaPX9ogpIYarY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E22E601FB;
	Sat, 19 Sep 2026 20:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEE01F000FF;
	Sat, 19 Sep 2026 20:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789848951;
	bh=aEklChI0Z6DSnGg1lTHUJ1IxomPedF8yLHgw2QGf2q0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=cA6gOk9m0pTCXjAZtd3PmkW4Edy9ftTtAepGerXCf1aYz4gPVhE/h/LFlqsOsqIFC
	 2pFCsXKcPw/AfBC52QMdG7pihf/rafq3LwEB9hnzAUARQ+XfZwxJ4cUF/kumyhRZVb
	 p9WGBMndGlVU2lTvUfVLkGYbGqp0/sjjafsKmfcsvM2ajC6U6NCY/NnQofnKgj+a8f
	 55qTzRRE7eTpyNyP6MwuXLZ6WIRwuyQMCsnWdvwgqGIbVb9LpK9gGM4NxW/cjEUkkW
	 KPZsF3GQrJtM1MgcMyZ9EkeJi1Fu1U/sIUIZznRUHWD476ONfnieR5z43zoS/M+dl8
	 9GJKxxJMR3lHg==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260901083452.115365-3-sarthak.sharma@arm.com>
References: <20260901083452.115365-3-sarthak.sharma@arm.com>
Subject: Re: [PATCH v3 2/2] mm/gup_test: report actual pinned bytes
Message-Id: <178984895068.1919785.9481531053256508981.b4-ty@b4>
Date: Sat, 19 Sep 2026 20:15:50 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: fzg3e8tfhrfwh9g8tqpsri8pa4jgiwtn
X-Rspamd-Queue-Id: 0D11D40007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789848951-505472
X-HE-Meta: U2FsdGVkX18pt+jg7bXJZ16t4gYO2SAmnEFFGiIii9D0l8OVEcEr9egULcUaz4k8hLsxKV80mN1rqdoHWhb8W3+TxtMRQQKmbmiTzpksBBKy7xcWrmTWV7kTWg0obOcceChRqUyamf/jXiulPbQHzAqCzl9JxCHznT1r23O37bdgxln2KPd887UVJbBOIGs76SDLtgisrG2yj/oQ4EPXBmt7pFG+K1htOyK9MT2i7uGaf2T2hjpYB7oxHGQcv06rLBtrWkvC/YXycmVBwJYITdqfSx3an8UN4wW/Zebfi5buVJXRe62/Zw2r7DpsF/e/URhmtYJRmn+5+0JbSgmlAR7WxKROQBsCOS5fdfypjonbwRyoEzj3Dr67LI7wc6Tqcr2Rf3FJKHODKRfahBNhKVyv/mI6ezpn4dr6hZ6wJqzDfUzqrdU83RQQ5eZbNcnEYh4lR7J7l2E2lIoXS2soR8YxrH9dLsu7kN9eR9iaILKOFkjD0+Q2G5wG0YL7fGTKNQCmAvtA5ZiwZer6aBP+tJDC4A/WmRJfuyhQa3K999qfRQwnfqxVxSjoTTDlEcfxktua1jl9OjVwO1hYD3ty5EZNt/J0iWP0Vk1P2QIlJ4DKC5bwpVVn40CV+AaCZxierXhfSGXjwIP8J5jVjICohnt0RWwOqyd+GsalifAtyoloTtajoukX1NkJYzgRZugTgU8LXVUu+vXW7zbn5BlswZ2XXbNCDsDY/zdmhLvzl/lh/cHxTQ5sOSFRqR7h/x8JfQnvcV1DPVGznitDhDPOHimRQmTXttrurjNRmim1J/ueEh/WzAynUli1HLCnGqc62UpdTP09H492RFB+3yr0SNAHtDIzQ8AYO7JUNgZZ7RFRHBf8Mcp5wrYxOTsl7O+pWs6yxNAFg3WXnsjOy/lB2WohhNjGl5UsGRUx7pCGvLOt7BooeNpZfNbZu78ck5vuA+qfsTUyQ2T+11Bs7Kl
 0DGSrVds
 yrK/sghKcb4CbyzLlzQKsfSSumhF5kNObetc5sLoVkB3u3mAchL3jefMVklY5lbhCkDUlBZP2c5r/eL95KlB2QKDifXq+YiJzOUF6gb4TZqmXROgMV/IvVH54W3c5YT2kRAnpXHhoItD2mPUw9dRuNEUP2cn+qRue+5V1RCl0ZMEWKhT9u6woBNZ1twxLCuuup9MPxXjI8vJZvZayBvGYNFN03TSldepdUdTvlR0y6P8Fy9Qg7zMKnTCl6/ljbK3wKhpG2+FOuOb/lz4M4E5KRT/igunF8ItYuUN8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 01 Sep 2026 14:04:52 +0530, Sarthak Sharma wrote:
> __gup_test_ioctl() advances addr to the end of the current batch before
> checking if GUP pinned the entire requested batch. If GUP pins more than
> 0 pages but less than the requested batch size, addr still advances by
> the requested batch size.
> 
> The next iteration detects the partial pinning and breaks out of the loop.
> Again gup->size is calculated using addr - gup->addr, so it also includes
> the unpinned pages of the requested batch.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: gup-7.4.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[2/2] mm/gup_test: report actual pinned bytes
      https://git.kernel.org/mm/core/c/65a79b9b

-- 
Cheers,

David


