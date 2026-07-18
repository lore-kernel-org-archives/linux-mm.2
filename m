Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF707C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 10:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3FAB6B0098; Sat, 18 Jul 2026 06:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0606B0099; Sat, 18 Jul 2026 06:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904B46B009D; Sat, 18 Jul 2026 06:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 648976B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 06:49:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0C64A042A
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:49:29 +0000 (UTC)
X-FDA: 85001576058.10.216B0C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A69F140008
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:49:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bSisULYs;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784371768;
	b=bAqtxRxXuKT9Q2YP5X+kqMcEPxfMCYx3REwSjv442rJ8JYwMb+pTUA/ArSkihJFY2vgo/b
	YWPKBXzJ1fLUtHkhuN+OrccuZMQfvlS6EU5KxspKhRte1oSESGu8hV5nZki4UeQ8zgXq85
	nFlqz7dAv6HEZHtn1wNfq2Fft2CypUY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bSisULYs;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784371768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vqk+TTwBA0BAQzINyNQP7BgvRd3meLH2Js/umV4ohBg=;
	b=gY81DJRJK38+rf4ybkRu05ZrzE2qbn70jorenB9dNOhH6MHgmpP0EkLnuIc3VosrJAwgHL
	J4ycbm7N6aHFz6Obl+ieVI+SI1cnc3x+9y51fCg6i25TLk3Db/7sgQUm9XJ8F+6VgjPTuP
	w3odQYcSqyUruZ06uvYhHMoQMCu9KTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19C5D40212;
	Sat, 18 Jul 2026 10:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F16B1F000E9;
	Sat, 18 Jul 2026 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784371767;
	bh=Vqk+TTwBA0BAQzINyNQP7BgvRd3meLH2Js/umV4ohBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bSisULYsLOn/RIwHZ2seWTgJldf9x7ukmTzzreF6gAbsILymCttWYom6Hu/btWb6E
	 tJok3t24xn1w6Yt04xfpzF1LwaEsxyJNftWAx1gZXAReKt97z6wOms/zJMkRkwZwdO
	 Tr1/e9VMbTJlzfXob44GXT8ROUOpZsbXFZPMG6p3m6/fOictlPAb2Xj/q5cuoPA+TC
	 OxBuLfTRItORN7zEndcgqqGyuY8XZWTvftpYYp2oQjZVtPLhqpG4y2S0uHvSBWBKlZ
	 W6DjNM3AQwc2gLvYO3Ncnrjx5dD3WC4iZC3JWuayvDHN82Rgy7A16VkN1UzGeTRfnR
	 jx6lmcubMhUYA==
Date: Sat, 18 Jul 2026 13:49:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, brendan.jackman@linux.dev
Subject: Re: [PATCH v2] mm/secretmem: don't allow highmem folios
Message-ID: <altaMNQ-RDYTzMCv@kernel.org>
References: <20260717-secretmem-highmem-v2-1-1f1a961ca91e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-secretmem-highmem-v2-1-1f1a961ca91e@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A69F140008
X-Stat-Signature: ytudujihqhaqkpjosxga5uwg4dr1zyxm
X-HE-Tag: 1784371768-208769
X-HE-Meta: U2FsdGVkX18fOnvYwp6OCUVVXwo/Ayqs9WkdQMX20SRMGHw76h26FIb3PzHWQu3G9DnGnq4fxvCb0n041jG89HJUqcVPDOo3B21WkpF/zZizx1oqRSoNo/beONTKP64Mmou6okOD8L7Gzi5r6LHoG2C05tLZVVggFqWU7bOdVi51e3ixLPrsSJK/Mo+MhIyqfKEzqEgFf4SKLeLCJMfpWQQx6bUGrHA/YH57/+tiijHuNjjTI88EybzISwbwxUpCGgtWNNbwcCcXiOHYStzKUGRdFyYl/tSMV1SR+wIQkJKvrj3/nKf4F3cOI+QMTDRCGoi5zoeT9/yLQDLdYgNaKzoSdNEq8VWowX1G2QmVJnsOZoLGaxnuoG/sZVWK8rWsvEEw7gdUfNg0TmY1muaAvrKgdrEphw+wKqvuZt59Az74xo/moHhHk5SOmmBfqtAj50lpcROI+kD2ScJTy287oAaJ5Jc17AmN/s6Qd07c3Lmh0MBKfe9MAM82Ot8gfz90I84BNgcTtm72NeGZnOM5BGprEVdliDGdrDT3gM4ot2O/reqy9d3a8Y09JtAw7eqLdheR4OOSTwXMWwoRSH3MtQG2jRgTqOJV9tdFLBu/LeMcdj/pHPi7nhQSBjtfBTxwazFW3BsWYiIWuauOVlRuzdDwlP+wclLpRUUpd/JvTnoHqGuV1JX937F03QMW/n3EpUwfVcU76DF2x3sq47lkZbaxracwQG5vc3sssLsNay1H8RtdIAderXG8Y5nSbKzTrdAeJcXc18eoEqkAHaj1IvkDgsEJv12tMtqgkvzpH/f1t0TvPpj5PioYvZ7KaR8hq3QWBuZgug2mJxU4a8NQPCnWdHg4WTxmWa7sNTywSGmXGmVeGwMl5ngkj3AmvUjhfwbqCU5uR73Km24IRDbcLErVhQzV8wON8Rt+SuKJMrQOB8sPYCmkVwOdunp5xZM1Mpi5/V3am/rYc9mFROu
 YJNtcgQG
 wecTObH893KGI1V6AnvkCGVLVwHczQCLrC+KQGSsWIH4FESIZBYfUyh//rzsxVxV0snLGRUvecqtIglTAGfMSWrhQo0o86SV9COXpk0apOTk+AT1dQzI0ApMZmXt/45xqM35THB91eYKky4/mHhGDLwGJlx7GAbpAndHL9x0OuHiiWGAdBsB8C6cy2tww9w55+IStqnet1F1cw7bxCMo12Nwno25+c4GnD+w8gy8vhlEbVhcV1fOQ29KdaW8/b5zLxN0JjVMEtCgjsFPSwzvv+sdafWQijKvLMug7uZKM/DZohh3hBzo/xH7MEc63TnrbFt1fkXhNh+11yEsRLqkGaSWYpTTSW1KAdOG0pJ9OZmlm2W5u45Zpz+Z/9OX+3IStDZEssaMbd/gavcZb7bSyTutICg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 09:48:59AM +0000, Brendan Jackman wrote:
> secretmem_fault() allocates a folio with GFP_HIGHUSER and then calls
> set_direct_map_invalid_noflush() without checking folio_test_highmem().
> This causes a warning and process crash (vibe-coded reproducer in Link
> below):

... 
 
> Link: https://github.com/bjackman/limmat-kernel-nix/commit/7b2acba2d3a5ef01400d493a155beb1d135b6bb5
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Link: https://lore.kernel.org/all/20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org/
> Fixes: 1507f51255c9f ("mm: introduce memfd_secret system call to create "secret" memory areas")
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

