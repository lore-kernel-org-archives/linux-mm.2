Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E28D7EE20AF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528136B0093; Fri,  6 Feb 2026 10:22:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9386B0096; Fri,  6 Feb 2026 10:22:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4161A6B0098; Fri,  6 Feb 2026 10:22:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31CE76B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:22:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F06B6140209
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:22:09 +0000 (UTC)
X-FDA: 84414397578.17.19D8B48
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C6BC80010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:22:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UBvhRd28;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770391328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2Sx14Efw2MdrqSrFAtZIkeoX+ECvkhMa4elHhdmrE0=;
	b=fbv0xx2OXdTxu4rk9Fah4Rda537chWKPmKZ/AarmTSeSxkvEcpFWpmKfMXL55hZWK76vCc
	xEpoznGU0cyXfV5/oz8sPh+XXhpz6kfFDWtNi6WrA/xN0vVHTXp+U6A0HN/f1fXUgMS/sv
	gonLaFcNBAgUSdhDpXfhdT6kODJhhfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770391328; a=rsa-sha256;
	cv=none;
	b=2I4MrEPiqXZITIPV7ZRviO3pxrL+tIUoLWGktzFbHweOnKinRKVHvyQluunLYgXAygCgT5
	Tpsyyxb/Q6wcSYkt25jZKsGj/yOvoIM5Z7B/33p0GhLoUO1eKUGM73rsOm6/oGBhjOpdLY
	u4lPbfab0+PNZH0Bz8JaVno1LhGNHYk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UBvhRd28;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T2Sx14Efw2MdrqSrFAtZIkeoX+ECvkhMa4elHhdmrE0=; b=UBvhRd2894gn4ox1l1tketHFhB
	1rOGXbMLhqnMkMP+qO8Vn9bvvF7tSPTcvTCLgnvzwFucX5BocZzuEMtFJKGDW/bR099kBUGpl5Dty
	A1mrXBaGatZ1B1PlDxWJc1ioh2BJL2C44bVRR94BosfvJZ/8Xz5xwJ1BoYbR1/xIPVLWduMDMutVd
	Lqh84SGndiF+1lzoOx4Y1gRzvKYlz1j+WKvygwgYMjVqedT2nVewK+E8xHDH8qBSEpIdm21Za2PKO
	OFxMULlhW7MMTuYUwa49mlCsb9uOZwxexxsDLJoTbkR8Lrv6sAJKI0M/ZQSYGEeeKeKuzvsvhxShW
	MoMOLDrg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1voNek-00000005OXd-32Ae;
	Fri, 06 Feb 2026 15:22:02 +0000
Date: Fri, 6 Feb 2026 15:22:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, kirill@shutemov.name
Subject: Re: [PATCH] mm: map maximum pages possible in finish_fault
Message-ID: <aYYHGisOQFQINXwR@casper.infradead.org>
References: <20260206135648.38164-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206135648.38164-1-dev.jain@arm.com>
X-Rspamd-Queue-Id: 8C6BC80010
X-Stat-Signature: acwunrkpig8rp65sctdymcm6qm8naznw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770391327-988741
X-HE-Meta: U2FsdGVkX18iXAs7zNdmbgJxD2MruPRVk+S5w6Yt5e0pQQJlMBMsTC/jtJMmjYXnzy+kvgWvavWipRXer6GbRnYwtYao2QGfIaNzQhbNTc6/p/67hUc54GnQGnFegZPnDkDc7gzjXyjtk+ZoBMgLz957jmi4RQrJ+YtA/pJP2y/jUSaClwunjEfOQdYsi394p59SSXDzjt93VRJhNnw9F69ThtHPdW7ENvTaQNp5q2kOz1vqm96UE4dIlvGDZ500V01Sz2foVCgZh4BbdrGGazIM8s/Ytyfayhnt5UcKivPYafh6KGBx6smkFEg67U3STUxjNJxCGBwlTkrBDYVGeno7w/rFbR5B90auCuhrj+B/DV7AUO8XVsbnLkLo68vWJgd8PoUtr8GbDoUUCynn+CEkH3SoJYTIJONaPYYG3q+5xfFVuqqtqTTpbsuD6r5ZAytIftajurhsECpy02gsu39iJPXZiId1IaQ3LTRXrszyaCvx8EL1el1glwnZYkk9yRs/d8LlKKRtH8LlDjXqIaf3NVkvnCJEQeYh9qz6TO/OJsEdXsWij/cOfP6RhK/Z93mUClLoSJWaNiypWNZXge88mLnqFcSYTfQV4mzHuHlWhdZ69LDEpXJPkl6Jm9b7FsKsqt1Akp5+1uveXh7CMoBBswAc7CjifQOIx/o+mMzlq1m7OeRExtCQdDGdyWAx3XIP3W9wTT7zkz7TPC1e6HkAN+tCf42BP2wreLsa6zDryI3E77NSgZDKGEGBeKTB3AFp5Tw70BSzPsp0Cik0oeEQDLUpxGw0j0ood8JKoD4Jr4HufhBKCtU2USmN0vvv0Ie8awDAcVW8k3X3rHX/9NCscMZtB4O6NUJLAqs+4PUsXv4wFxRqyyCs8d/tBJxEc0NxYqThc/6OOfFR7NvjIUZns6JxMuNivSVv3573x7J8IRcZpcTTQQZb/cMb2srAvWU6/4TjGNFt+HiDSdC
 /KLm0iCg
 m/o1Z6Z5PT+XrGP5LK7+tyKfcRY6h1jHBETreUU51Ica7uFnsTAkEXnqehXLFTgnophILUthBrQKGJZlYM9v+5XrFtNri2pow4q9hNpH2A2cOw1Me+OWTS3TX14fDY2bM0OXMDO5G5AiHyHmB3rOPWm+rpCKSNGGmtVsKH0LhzUfLaAoRmlvH1r0eqbYyAS4VrP9tUCLKovhz2GPxNCpLzM7/c7Hx3F3K/Li/9UypP/Gz3bb33dq9VO79FjEhoUtJjEzbCjp1rngtpz0Bn/Z/ZuM1u/kr+/+27pDviR+iUGPQ1mE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 07:26:48PM +0530, Dev Jain wrote:
> We test the patch with the following userspace program. A shmem VMA of
> 2M is created, and faulted in, with sysfs setting
> hugepages-2048k/shmem_enabled = always, so that the pagecache is populated
> with a 2M folio. Then, a 64K VMA is created, and we fault on each page.
> Then, we do MADV_DONTNEED to zap the pagetable, so that we can fault again
> in the next iteration. We measure the accumulated time taken during
> faulting the VMA.
> 
> On arm64,
> 
> without patch:
> Total time taken by inner loop: 4701721766 ns
> 
> with patch:
> Total time taken by inner loop: 516043507 ns
> 
> giving a 9x improvement.

It's nice that you can construct a test-case that shows improvement, but
is there any real workload that benefits from this?

