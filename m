Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBB9C5DF9D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0750F6B008C; Mon, 24 Aug 2026 16:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CF36B0092; Mon, 24 Aug 2026 16:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5226B0095; Mon, 24 Aug 2026 16:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C387B6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:31:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4302D8024B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:31:35 +0000 (UTC)
X-FDA: 85137308550.29.1323CA2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id C3FC1140008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:31:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pT6pGEy9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787603493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIiLtMs4lFBzyUl7bXYr+rHge8z24z1y02ZKkAxdE34=;
	b=jpgM/o6BXFKa0f6EQ1WL4aK/IM5EC/b4FZEFByH+7nm+aSjw7Q8pO/LmcIQV1hbf+q8Mnj
	MIeaLTKJQUgsDFz+yykpHmER9lo0XU5DwxnaKkpXKxB8u5Ks5EUyqTdsfFqcFejUBd5KjW
	qoPQEzRzycywITiGt9zs4db45EqSBuU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pT6pGEy9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787603493;
	b=cfKN36IHEQB4Qq55ScStUqAHb3EcHLURqhw3N9QnamIAQqvHKBgJvhz4pm0Fycj7zwgH38
	HR2Ivje9bN/u/vUyETanNPPoxN4gbH7skBTgiN+x9RlpgazYVuJSgam3wKwZ68B/B6IDIH
	oGqjdHpyKFm1TY3jUwSaD9G0L2hzUfk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SIiLtMs4lFBzyUl7bXYr+rHge8z24z1y02ZKkAxdE34=; b=pT6pGEy9B/KmFPdkcPv/7byZ60
	q+06SOtrN+FUK0b2YWrWtXJydW6w5AD/8Z++8wR453TI1HAmIkqGhzfqsa1bTK1iR5vVxHH6PyqtC
	NMWpOHzvHUf7GGvye/Y6vnSAzKDpKbmTcI++7pwp3uCHtVQcJPEsYUForfPe6ZohH4cZ5h2pky95J
	qJqCiIXNtoC4iydFcAoL2Pkm4AiEMAFvhSaHt790qyviyageiSk+Yn0/5nqQGIREclasCHsTiwGPf
	UqYJw1ogoHlO+ReEVB7C78pSxkh+Mt1jOFPIKVTqZXNqrZJ0Bx3qqURXtSgGqXMaCbmhFF+EtKoXv
	h+ZDsMtQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wybKK-00000007lzg-0wG9;
	Mon, 24 Aug 2026 20:31:28 +0000
Date: Mon, 24 Aug 2026 21:31:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Artem Lytkin <iprintercanon@gmail.com>
Cc: Ackerley Tng <ackerleytng@google.com>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Kiryl Shutsemau <kas@kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] Extend xas_split* to support splitting
 arbitrarily large entries
Message-ID: <aoyqIBz1EoY0R8qw@casper.infradead.org>
References: <20251117224701.1279139-1-ackerleytng@google.com>
 <20260824194755.216000-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824194755.216000-1-iprintercanon@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C3FC1140008
X-Rspamd-Server: rspam07
X-Stat-Signature: yiizsnctxubj7efemzfzgxcfhujewc8d
X-HE-Tag: 1787603492-242755
X-HE-Meta: U2FsdGVkX19iW2ppSE8CyDMCemm75ftdMrAQsu3zm+oKwNsGIBXQ2GmW/OhxILR80jRuFuLj6IJVgka7hSDpToeM8SUFIyeXgfdq7snTrZcJmtRgeiTuu4Jxnxii5BnKf8zXYJOMWqgWcx6TW0xQBwAKD7L8mU0CCxunrERXT2TBufg8j1A38xXlOD59Lbpa0HvUKP6cVxJaOHyB5Qof7AAiFjRO37UarB++jUEqyOy7YxZBBwb0VaQ2TewROKpLSvmG7Wj7m5ukq4AJf+7IUldhCaujp1hrOiMJrEK51iLqlebk4qGabtB2O44uDxFYoDaLQWGJaWY7eLNYrjVRrmtE9GIBe9hBsF1ON/w41a1r3IKJ8r7Nw5bEUvv47cpnHUDV9qmUVmfeZDK8s9vf/wf55uYjfCVrYQXo/mnRrEuvoJKJRuRpsIv8MzFEZfgW6yeSLUU+ouKpiC7rfX/JvMUV2wNAoGCIHP66tWprWgVlrK/ppokvV1UMx0jsD+GMNHBzVvzeJRPUEowz/JAWtFBxZ/4aKFb3//GE5iRzJCO2oc1NJh7WoLBlrQLt9/CcPBr9Z1IZL2BHmBALwdbIzPIUHRts5a8K/ad8W6Kx7TCGimSsWVsLpP3rSk1JGyrvjiKUNvcpvRa1Rndu9IXCgtn1QR1tWjEY5MxxKWnaqTYmuqkxRCzGTbSwg6VJ4EnXX6PMNrBR+eKmh9L4tYL/aasJMEinqCANlR7HGqm49iKuRRgJirFc0oJDxQKQ0ithqVL4jf+lZxyfPLGAhc60HouMQE8wa6MT742g9N62CwcfgmDpviNt64bDcdmuHRNZoqNmgXOpysVOLaH3wA8IlyN2YsyThvYmS6wsjsGuOjeNbau5qA0x4Vft5VB5Oujt7QZFCdcNK6KVR+Q9CzuAqZ/d+4oslTiJ7wF3iyFWAMq6Y+IBE2mrpFO0FrtO+b0zLKdCe27gsCLCLeUDN76
 NYypx6B7
 pRqlYUnssW4tnzG39FlhrBqzTWB8Bc9Jfc/xEDHItKFLVMePMFP5k4/W8wCoXz2W6iyXAln0HQlTDzOxjMKhedlLSzix/+0vP3hU3vPUWfHnmKgey+0dssnk7a/g7oPgzSA3ymvw4qNCzs/bAechfPCB8dHNpC8P9ZVQuDRqZSU7lfAcSC0x7mmzcKA0x90c2kD1q5dGyhcyVHqM7bsvnN/SzyV+uKqMts8CCfodgVvEtaz6CEP8H0/OT539nSboL6yiUCcFpc8LzaIn2F86wShTvgXepd8/ZnHJb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:47:55PM +0300, Artem Lytkin wrote:
> I'm asking because there is a second user for it that has nothing to do
> with guest_memfd. On arm64 with 64K pages HPAGE_PMD_ORDER is 13 and
> MAX_XAS_ORDER is 11, so MAX_PAGECACHE_ORDER clamps to 11 and shmem never
> offers a PMD order. MADV_COLLAPSE on tmpfs returns -EINVAL there, and
> huge=always hands out order-11 folios at best, so ShmemPmdMapped never
> leaves zero. Every other page cache file system tops out at order 11 as
> well, which is 128M and not PMD-mappable. pagemap.h admits it outright:
> "xas_split_alloc() does not support arbitrary orders. This implies no
> 512MB THP on ARM64 with 64KB base page size." Kiryl's khugepaged
> selftest series skips the shmem and file cases altogether for exactly
> this reason, and on 6 August he confirmed in that thread that uniform
> splits still go through xas_split_alloc(), so xas_try_split() on its
> own does not lift the cap.

But why would you want it?  With 64KiB pages on arm64, you need 512MiB
for a PMD-sized page, and that's just too big for current hardware.
What's your bandwidth?  40GB per DIMM?  With 8 DIMMs, that's an
aggregate of 320GB bandwidth, so that restricts you to 640 page faults
per second.  That's too few for almost all workloads.

The page allocator also isn't great at doing order-13 allocations.

Since arm64 does support 2MiB TLBs, even with a 512MiB PMD size, I'm
not sure there's a huge performance win waiting for you on the other
side of all this work.

IOW is this driven by a real need, or just some completionist thing?

> That case needs two new levels of nodes rather than one: 130 nodes,
> 73 KiB, a long way from the 1G to 4K split Matthew was worried about.
> Raising MAX_XAS_ORDER to 3 * XA_CHUNK_SHIFT - 1 covers it, and
> MAX_PAGECACHE_ORDER stays min()'d with HPAGE_PMD_ORDER, so no page cache
> caller can ask for the order-17 worst case that cap admits.

130 nodes is still a lot to ask the slab allocator for!  With 64KiB
pages it's not too bad -- you get 112 per page.  But still ...


