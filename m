Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279F9E7DF11
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D976B0096; Mon,  2 Feb 2026 13:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817476B00A6; Mon,  2 Feb 2026 13:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E6C6B00B7; Mon,  2 Feb 2026 13:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 601ED6B0096
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:32:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5E5189F88
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:32:20 +0000 (UTC)
X-FDA: 84400361640.23.73A2139
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5DEE510000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:32:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XDpTVO53;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770057139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2I5Xirz3pQC5OR2RcgNO55sGAXhl5cmAGqNiApg/lM=;
	b=RVKWrC9CTLfYDOre1hDxcXzayLPDgVEyA5k4ECvBLWkomzk2++EMyPX52lnvZ8w1/EyM2u
	doaDZlX8YWznpmMNd18RywVjYNqOKT6+Ogzbh4Sa0p+Va70IW6yBXNkmOlCx1C1GZiaktO
	LYPmT3Xz1c1GdUFFoH+/pOMFe0miTyA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XDpTVO53;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770057139; a=rsa-sha256;
	cv=none;
	b=C6nBqIlr5J84zIoi+kovEyGL6HCSte1bHo5cnG9rNHwsZoZIRnMSCOkax3zUcsjqElopPP
	4xTe77BnfTumF3bPPIo1UaklO/5jRyR3a+uwKxQBEuwkf6RKr/8gvaYiOxvp77JDRdNS+U
	cPCjZJAHvYiT8wTVLnqDWMTX9jhFdsI=
Date: Mon, 2 Feb 2026 18:32:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770057133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J2I5Xirz3pQC5OR2RcgNO55sGAXhl5cmAGqNiApg/lM=;
	b=XDpTVO53XUXfn3U+M/5MazYPP75mXuLOUQTdB1sSlKsoL6uk/w4tS/0ViizWTh2VmtrwRt
	XH5OMQVk7wQ6nOIcC+K/9LOJMyZ8Mg7DVpCoo7ZXuko5M8TGMRQIckxLTXsSyoKBMR8g/z
	EA27A3lAUSaUBlak2xvMAadgsTHa228=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH] mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass
 workaround
Message-ID: <h334qa735tm7ejbamm4ki2zw73j2juvc4jg5xqxogcyqqvju5p@f4e73b3gqjlo>
References: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5DEE510000C
X-Stat-Signature: 4d1xso33jre6xzoqzh4jqofsoanmmoeb
X-Rspam-User: 
X-HE-Tag: 1770057137-660323
X-HE-Meta: U2FsdGVkX1+UG1YbpIV+/penOQ5PDCpsSSh3nzEzKZ5f83Tb6qAkjoaZbybKxmGcz5mZcx9zrqD6p6K7IwdR1C01v1eGMLtuiZp8bD9JiyYpJPKumR/hEUzPRrdh5gfjk1dc+fHXjywr2Wydlf67r70fltZX2y3LJCIvAZhS6ZVezs1kDBkd+RX3h5UIXSH5B5EzxoMUz8sRmAem+OXRPj/M6BmbsloPtt+Ol/UmgjH+TGcDATvepso/nYyzbMTFLXRQODgUEkdIXHf3S0SI54zLwgLmrIjXon3dbYY4t/rm4mU4zwt/d9fGGvsL9JMX61uASpNX9Gyd6PIsUqqulaMqn0iJUkhQ5OI2Rk+GbLoEOKixe/Glhuxa256GID4OawrhsT9gS34dFq6R1m/4Hvie6JHXl0tusMy+/6vgfkB3mGt42qqD6/lftFpMwiaQknCD1za15ikcceoPNXP+b0xa4oVz5/Yu3Mqvm4zdwbfdDyJG/SGgRiAyXakXUWUhLTh1rvtnsXkFBT4jM5vwsOJY+GOqPAeMxVwQyxYffVdPTokHvDd9D7w410I4u4SX0JeFv6h0pLNrG0cCznYXTvg/BlAt+MJR3P9KKwmcWlSK0t6Kpd0LchdFcrfiwk7LYWhRGRPGE/x92J3fmgQpwTjQcXVYCPpCPI3DlUJ+uYq0AkB8vyd6pnR2a/UAsKHgYQPsZey4b0EzQVS6kgSS8UqWQV861n4kjp3U9uLj8q3570XneSZkAVNMtAqjA9r83scx3HwfFq597ILzY2ow/XJyXi5Jt1cE6MKbB62I4rs9LHNkImSiBTFYUjJoPACJIvmZe1cLPuq/lXpY0Bl6YyREjNHYau45kyA3AVaikAjv1gz+66n8aKuD2/WJloZKOpp7rlXaMLUK+Fczk8q2Jda/asyoomoHcJTVe619OPT5dKgn6RMz6WdK6aw7/iADp3N9MAW/oqCMjqpFtn3
 BwfQ2PBB
 /jBIWzyAX/c5BxpFWUiuME73Uu3K1hA3CBUSTfecZGlNFm/UlmAYVPkgu9iELNSpJLxR09konhQuSJ9PJRrxm9Oa0BJXoomYGnBXpgKB4r3qHdeYbcP2GZx9i5bo1+hhcX67so7zPTh8U+WYAVLoLPSdIZnxM+KeOdmoLl3wISivme1XZYShio0XL3R8GNHsYu5kbHfKhnEvkpy3eK3eWYEkhSTXROVjMpbCZHi9khXCp15OY0D0FTPDNz/R1HI+2ekv1OVw0RYQ43ymyxZPjfIQFQ8k85xf2AH+A3hJsJBiZFNoZis1HCh6wig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 01:47:32AM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), all swap-in operations go through the swap
> cache, including those from SWP_SYNCHRONOUS_IO devices like
> zram. Which means the workaround for swap cache bypassing
> introduced by commit 25cd241408a2 ("mm: zswap: fix data loss on
> SWP_SYNCHRONOUS_IO devices") is no longer needed. Remove it, but
> keep the comments that are still helpful.
> 
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Thanks!

