Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4897CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 23:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C436D6B0088; Sun, 17 May 2026 19:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A3E6B008C; Sun, 17 May 2026 19:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57DA6B0092; Sun, 17 May 2026 19:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A744A6B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:38:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E67A140687
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:38:07 +0000 (UTC)
X-FDA: 84778527414.27.A9C2EA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7A1E014000C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:38:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bQTWjja0;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779061085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Av6uNqGbUSKIl7oceqgqRm4zjbD/lm+ngnSHvPUMy8E=;
	b=ipF7Vu+ehULso3DZnUbxuwtuYJQ4ca+6QLPUZSviOpnh1kjKglfydQyJev2MqNs1hm/Wn2
	edOm/eOowBFTGrBvqy4tAI0p6nyPEV3GOo8cQrihwB1ymcKfUe13/cwhWhP2I3nhkU6lMz
	HXDw3JHFet3PAD6NvPW+xG6Y+FAB5O8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779061085; a=rsa-sha256;
	cv=none;
	b=8BDuZod8ns2UAClEXpwIlIaONt9TRjFZB83pnjIdq01lDT7qtD/aF0unqpqV2cCgEJShF3
	4nDNp3eWYRT6kuUcOhbgY7+yeH+GWO1223WhGu1EYVuRdt0hcHgt2iWBEQZtMG3FC0Scj6
	pDAV48Q+CmB2ExlHezjBHlBepceD7Zk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bQTWjja0;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 53F1543EA0;
	Sun, 17 May 2026 23:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52B2C2BCB0;
	Sun, 17 May 2026 23:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779061084;
	bh=ECiqAt9xoPWZmUznHtBSPzT0B3FSpo2D0BKG4KeiTuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQTWjja0ecUoGO/loHB3HhbJeqUM/pZzgcF12hl02M8frXScwwP2R3fvZfIrbkdwF
	 iDUW4Zb6oB41e7IHxI/Dn/5z8SBIh4UbpdiqYefz6C6paU/SYs24GavAgv1VLBUNdR
	 oBtM6BuMdWrvCUnD3zisuSWe6UVPhuZGazjx442tV+WPOGfTpmgzSSQRUKKLdRVsgd
	 QDZhxIwKaV8756gBdX3zfqMQZIdieIHC80nQlZmHRlM0mx0yNLSOp580WbcXit53sG
	 S9eMmLoK37dsUh/u5pDZMQXS3/PnXylV2NEhW/zbS7jjFEUlqq8f6WemOC5SkdmDcc
	 UnTqcXvNjeWTw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 4/5] mm/damon/paddr: skip free pageblocks in migration walk
Date: Sun, 17 May 2026 16:37:55 -0700
Message-ID: <20260517233756.89097-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516210357.2247-5-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A1E014000C
X-Rspam-User: 
X-Stat-Signature: a3q7jnnujwnyu4atqjsz7aiisu5qt3wh
X-HE-Tag: 1779061085-182476
X-HE-Meta: U2FsdGVkX1+NAU4oXAEwy2DlWQcWqRUOMM+Edqn96UCTdfxf2VriHzuo7i1/zs0JhgxsbMYV3DnWuBsxP3htQEvVZ3lAd/wv5Q9M5RwRPJd2dsvL9q5Uukuk4i6ceF4KJMn+ZRrh6PCyl0i+U4lmScQ5Kbd9lOegSXDvM3JTMVCt39S5FxKUTkS22sNAapgEpADh96jXg2WqN4jt67JD02KNK1CqfTOYPHSCs5/6Ixh11/NpGlRcvtXSLxoOfAIzxu05WSCgDJ/kexAKp+lhVF8OAhmblx4PmjxqY030K3iULEfVzibQU6bpqnEALJVyX4qOiOETq/g/QCnMaTF8SL96jP8m37kVv26jX4I9aG7/B5GlkifZvJpwKgoZZrq+xcLE5v+y2cZfcgg9bT5x/iyUZdYA8cUSyWaq6wgaGygTjUS8qY287BMGG4Qrv/lIjV99W369r01pztqWmikyUnwlZIAPb66AULJAGG/gE0EbuQh+RUFLLfStqcEYu+e5BSCPWcc0MOdqxNiRUA1Yt5YGKEqoPmIokf+jkAQ8dOgp3P39IqJE/agHUnyagFpjGpEpll2PyVG+AcHRHcRSBse6HLxZrrkqaidE8WzwmpyrDGR5mhyemjgd9/BOmELSYXWi9ikUnJgZq5o4hwRBr44k0xg+hxkOWdeFFFIvzOqkyQnoaTokpS7QnPq+XCe+Ryug3lPDJ+9ox2Ul54pPYDOySFda9pujDnUZ9i9MOOKwb9UybAGYhPk60DmOaxZufLJW50CC94F/cAc1sa34Sl+IYz08Iw6EIUGB3L5pGHKo81eIp7VzIYcSjR/VDEdArtirS1GhrJ9FboiPq0hXvMdB2AuQ/9rzxv9kFCRZV9s6dsfUiRepgH2nO0Fw6lylozBxaKSTG9FiaSajZ0xfFGSL8f2GOcWwGKXxfYk1DVuyI68gswfE6K3Zfq+PppK5dG1T8qQWBggVsZj8n+4
 ON6EhNTM
 5Uy/o4viPvQTYypQd8ZG7qT1ILFzq+atNozAOXS6UO0r1v/191Hz0udJRNGjkwTckFYDTbCxxRkYbMp5V686INyUl8PPN85BHvJooMqwcn4AN19381ml9Til0T0sMDVAoMRQFXirwaaaem4Uhk7rdHmhzC+i5lwZhBNcUKjV6k303aq4Mv8Ne//E4oUuin+pQ5Lnf2kt8KtOpLe02xzl6Ezq+dZTNJWZQXRcWr3G9EO5i3ToMN7KWCJIgWmg12yc5CwSXjSDWLxFblxfUCY0Y2ns2s9ajfx1SJe+YRz/0slY2fbjMwImXB/Jq3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 May 2026 14:03:56 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> damon_pa_migrate() walks every PFN in a region linearly, calling
> damon_get_folio() for each one.  On sparse physical address spaces
> (e.g., CXL-attached memory), a single DAMON region can span hundreds
> of gigabytes where most memory is free and sitting in the buddy
> allocator.  Most page lookups are fruitless and dominate kdamond
> tick time.

On sparse address spaces, the problem would be large DAMON regions of offlined
memory.  The large DAMON regions that nearly all freed memory is another
problem that doesn't require the sparse address spaces.  If I'm not wrong, the
above paragraph could better clarified in my opinion.

> 
> Check at pageblock boundaries (2MB on x86_64) whether the block is
> entirely free.  If the first page of a pageblock is a buddy page at
> pageblock_order or higher, the entire block is free and can be
> skipped.
> Similarly skip pageblocks where pfn_to_online_page() returns
> NULL.
> 
> This reduces the iteration from O(region_sz / PAGE_SIZE) to
> O(region_sz / pageblock_sz) + O(populated_pages).
> 
> buddy_order_unsafe() is used without zone->lock.  A transient false
> positive (block becomes non-free between the PageBuddy and order
> checks) costs at most one tick of missed candidates on that block;
> the next tick re-scans.  No correctness consequence as DAMON walks
> are best-effort.

I was initially thinking this is a good and reasonable optimization approach.
But on the second thought I get below questions.

For large offlined memory space problem, couldn't we simply tune DAMON's
monitoring regions boundary to ignore the holes?

For large free memory area, is it reasonable to assume such situations?  In
production, users will try to utilize as much memory of the system as possible.
Then, wouldn't there be such problematically large free memory area?

Could you please enlighten me?

I will hold digging deep until this high level questions are answered.


Thanks,
SJ

[...]

