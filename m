Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8CACEB2C3
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 05:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D183E8E0011; Sat, 15 Nov 2025 00:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFA38E0005; Sat, 15 Nov 2025 00:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C638E0011; Sat, 15 Nov 2025 00:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B16818E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:08:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 246264CAD4
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 05:08:03 +0000 (UTC)
X-FDA: 84111659646.30.6922295
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 703D0A0009
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 05:08:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Aec3IxiE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763183281; a=rsa-sha256;
	cv=none;
	b=roncX/eYU8+AzeQmtgfqY4zasPbIDa1DYpENNvDbXOe6qMYKJbvlhqROPWa4JWlBaiy2qp
	sPwUPNWToZnnE0+1ftaUEgcjmiEiLeAVm377t7/BuSHm2FjJqIP3bra09XgcxmcGq51FvF
	xPyicYjQzFMZmI+Yp1WvZxrGQlktIgc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Aec3IxiE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763183281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99bQhguiuvazJLFnjKQ96ejx9/UPWFkM7J+BT7DI66A=;
	b=RXk9kgMutTeXAkJ/uYqCJ2HDioQvE+Kna6aoo3SYt7s5aDviErHstgf9ciBUkBl1Avf6mu
	u3rZUqOEp0KzxYZfNIw6UYO2yd4UXZJohdNfh1ybQpgIiFCa/TvYW4TJS6PFlfc+OVq9O9
	xfAoV6L0/FjvmUkNvz0ICKodhT/nSIU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=99bQhguiuvazJLFnjKQ96ejx9/UPWFkM7J+BT7DI66A=; b=Aec3IxiEL5092Gm6TG0Pk9XJ55
	glHK9plEA75MzUf8Zz6BcJ+T0Mo1EwBxc/o7F2fmQnpI60Zv8fbMqg9InpFwqoK1/4pyRoHTeed1I
	8eee0tqD8pGMS0L6C+r8JjsTOh5AGFpy/JX0lMCcrt0GEJFwFld7rpqESA9UFgfxLTvC2TH6onFXF
	qs75PU/i3yohNvWalhAieys0pTsDh0jIq5enKAr1n+wCakJlEE4KLW9S3MMKX6sbKfACfUIA5yYRQ
	lyoQDeD+8HnTjCoTF1RPznuPVZzAhK2M3pjgcNeHJlFVyG/CWxOQ8zn/fjQiVt/dMnSedsHLUZBwV
	78bvpMrg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vK8Vl-0000000APIW-0vnk;
	Sat, 15 Nov 2025 05:07:45 +0000
Date: Sat, 15 Nov 2025 05:07:45 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <aRgKoQT2ZYH_x2wa@casper.infradead.org>
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
 <20251114150310.eua55tcgxl4mgdnp@master>
 <64b43302-e8cc-4259-9fa1-e27721c0d193@kernel.org>
 <20251115025109.yerb7gbty4h7h63s@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115025109.yerb7gbty4h7h63s@master>
X-Rspamd-Queue-Id: 703D0A0009
X-Rspamd-Server: rspam07
X-Stat-Signature: 1i7w6tnfw93cxc3mdmue3n53fh56kjbp
X-Rspam-User: 
X-HE-Tag: 1763183280-880193
X-HE-Meta: U2FsdGVkX18TBiLwgjg1NlkjldHVtEXzsCS0sXxhD1LqnM1OuHGLO9UI0B9uF/zsokSuBivvZFeh8eFhxyJw9u1FMu/W2q+BP5EXY9AwRCeZyxbxh2Atmae89BasvLStiJMOhRFVo4aCulisZ4k1mmWpxw8LWu1cmQDsonZc84qW1p9MyJsSnMFG5mpQaI6jN8ZZtZJfdZUYQ+E/L1x16yv+LrfcAg3c23kN/FQr/PO90qCldOSh4alcndfnT6dDFrEd+H3n4vd2h+WDWdfqOGpZu1XQhD68qz7Yijm0yJo6F5J/I65M4vdcf8z7Ke3y/gtR1XMc7N+5bQA0mNZJsaJplRhOVbsVDxAHFsMRJpCrBHkgb4O1W5QRiX0fixGhnNc1BFsUQL6K8t+AeczisaEr9QQ4UAQjHBtVCfFLCBfZeu9sfUkVrtf7mbw3qSuF99tr/mDzdP1D13/D+c/CQWGsFAJ8ElwQklw7iqXcykdUwwT994g1YlzPQKUc06VDyMsd04dWZ5x8IWkX/RhrrRHjviDsu75TeZf+ofeHObSVeM6TwKgDdE52+pguuqMUFKLpEJy+9vkKZ5lLk/rpFKiNE5tgOeDTR8OKwbH8T55xVCbBY6k7JZspiaWrbkcheW5M+nrfKjvVjGC/lvKpRe2ttLRF8ie0EwL1FGcK0yxIZu6kpgbPm51JGBOiLQj2ukN0us9xCfl9tVhEXhv4KzngCRAZx3gsSu3mKVjGcT/J5btY7+QPZMMYbQxUYG35j8SDzzaqJ6riQwN/VhiK2e4HYEidn3099tmxvp1V/6V/mUlcKLAPMFpopTdd0QI3FwdVBmPBFY2FoebY3Ztxmi1i491ZbTjb74Ywh37C+F6m3ZnnZoFB09oG6gkgL3jTMBqC2OqPKV51a/nVwL8wgM93tlnruX+G0OfSm8KTAjlqvLOOqd9DmX+KTQMTV8nXq+kWy6wxaVVmpmLnzNh
 t8wLoDX+
 OLHlXCZZ0MmvLdicsSTa6OncY1SpHzaQEP4luuf6jDNhD4LFir7H8ZHceSY09PJGnsKYjC9p97p/xc5Jk8qoOqS/K0yR2JPAzXkFX3iDiSmk5yUttOyNFKtswoyLSRc4ec27dor4MyeHhDC5zP3OnNVl26TRsfxv2ptCuDzyUafV7Y5aMb0cdJTbsS9dMi/qZRBw3EX5QR9++SzI4FsHQPyUWOc+ABGgYElib/L+BPGuK0/BFTuJ0gQL2PmTKjamuaGgWq874kRFT6HUXurPBPQkGMW7wBoCtYFuiYX1MoRVpJHg9DJl/4kXhkTdUaGzPpszRQcPYD9ZsmT6lswLVU1rt+Gx9jJ9nCGgGPawb9brKd89WM4f3Z6ICIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 02:51:09AM +0000, Wei Yang wrote:
> I am not 100% for sure. While if we trust it returns 0 if folio doesn't
> support large folio, I am afraid we can trust it returns correct value it
> supports. Or that would be the issue to related file system.
> 
> To be honest, I am lack of the capability to investigate all file system to
> make sure this value is properly setup.

Maybe you should just give up on this instead of asking so many
questions, misunderstanding the answers, and sending more patches full
of mistakes?

