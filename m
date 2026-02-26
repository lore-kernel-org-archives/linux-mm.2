Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A957FD460B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11216B0088; Wed, 25 Feb 2026 22:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBF316B0089; Wed, 25 Feb 2026 22:14:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB9A6B008A; Wed, 25 Feb 2026 22:14:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBDC6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:14:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41B931B742F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:14:39 +0000 (UTC)
X-FDA: 84485140278.26.B7333C5
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf19.hostedemail.com (Postfix) with ESMTP id C49F01A000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:14:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UzUMgvNL;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772075677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpGXbGChzVOG5qFJfn7R95U82EqXMWQ1Rsge2sJdAqk=;
	b=2Bywhk9K4eCi58WgtyEXiUl394f4anEuYqmPAFl+zK7RyYaG/AvqAJMhULVLMNpZaQpfi5
	iaprSrsefbDITpJnBwc43XphA3+Q9+oFC4EigRZtY6GO9je45Ss18pi73O/9aRP2XnwKMV
	51Jm0vEoYQvtA2qM8nm+SGIIvByakHc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UzUMgvNL;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772075677; a=rsa-sha256;
	cv=none;
	b=6BCCeeQQjpryYn6nfH/QDSzAXvXjnjOicObigqAd6lxCK69NJ0iIm69zs5DRESZTTqCmwH
	UrUz/AYNK+U4pJybMKOIeuYE2IMSPyadGz1ECBb9IM1fNsPW/2WS4/Gwr9/urs0gWi8luq
	wIhiq9FU3zyA5Zs65hHtJodbwsKQVXk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1772075664; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=CpGXbGChzVOG5qFJfn7R95U82EqXMWQ1Rsge2sJdAqk=;
 b=UzUMgvNLSmgbyaYoGahf6uBn01bA1UUTsmX44yyvxT6xFxSv2yqVg12ZthvQhy0lVTDwU6
 GtukpA7pE364nhBz4GXg18R/NEoA/4LnNCqYDGznFUCXRr34ejRTb053DRd1BILM7b83h6
 2c6TQ0nkyu0aO2MbV1W4B0k1XImDiFbX92iMQOZXq2rDYRPofjv4XV+PflvKGVfuHDPZxF
 itSTRYaHVIPuD8fsD+XXUIw7prkX6gVJkfB9LMl9sqMD+ZA7icslKFyvYMm1kbYMp5MhrA
 UK4YJRwjdH1XOxsFaQG2C6PvP8fHSDhio8iatI43vW06qg0FhtUOwPwu1jqGhA==
Date: Thu, 26 Feb 2026 11:14:04 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <81065dd1-c131-48db-9ef6-01c0ec0001da@kernel.org>
Content-Transfer-Encoding: 7bit
In-Reply-To: <81065dd1-c131-48db-9ef6-01c0ec0001da@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH] mm: Avoid calling folio_page() with an out-of-bounds index
Message-Id: <20260226031404.82059-1-lizhe.67@bytedance.com>
To: <david@kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2699fba8e+d0e1af+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, 
	<ankur.a.arora@oracle.com>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, 
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <rppt@kernel.org>, 
	<surenb@google.com>, <vbabka@suse.cz>, <dev.jain@arm.com>
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C49F01A000C
X-Stat-Signature: y1x7tjfxjktgu9wg14eutcju6ny53ng5
X-Rspam-User: 
X-HE-Tag: 1772075675-944283
X-HE-Meta: U2FsdGVkX1/FGgKENdaRVQC260n1Tw4M4p/BpTTcJCjNR8XdYA2EgfJuv3X8EYegy7pkxFkwl5GFVQZDX+EevjPI5PpVO9fs3DMvN8TN1W5/VMIEOfkf1GoRI5uf6C9ev5kYkLuUS0VPhFkHLgdvZlRpHR2yogaXgzsb3S03voIsEQGb/mU4Yb1VHKOQFk2QhU6h7WGLrt/rrgnII8qj8lggrZn7kJMtX6+HDoYDfSnanbsOrvgiXwEcwuQg9NvZkqxehng6xC1ZpN4nwuqyail1AfMoaQSjhHqHHMf6FRp3UYxPSjpTLcREFz642w7xroHbh9MHu/n0F0ukH6cwvla6FI2F7FJm2x9la24RuxsF9mJHlolagR4+/MRevXRpAv/QP6zjLeUiDscTRDcrvVyIbrI8qFd7T+LAKfBQj2rbKYz7W1gKTVIEqqnDXWIfnO0EmSDkqvzmdr0nImA37sEcxPzHVjAajlhNxGbdRRSrnO3WVMDaKb0eTec7vVU3Cas3OIuic6g5xX9/UjUaBz9QDyqoI5el/Ulml3s8q4EP/QB0vSjGW7Eo6YWtGstlKx4SNsX8lhLc/d9IczY0L5pGWyOePU005953szqaHNX6qC6p2MYTDJMQ1eZd/D8v2Znx1u5gcRt+tZe0sDdObAziEo0iS0psLHOB0bKbGO1SmNCCiIGNXcIp4NoFhgJg7/11JoOkm/1TXV+/FPel6mF2mhTy4hHUp28QVGPdXImAp9H/W4bH91f1qQBWNXOOrpMxdiyBuPeeXotxMDtEaSFcUQm9+IBW4xE2a+4v6nJv/GfRWh8kncqkoqnjJKs98EU7sVkPuazaZCuzfzBKc8Nzedzv4a75ArQIK5PLlhWdxnBdAvAGW/C9N2eho9Iv7uKs/kvwl3v+i5J/b6dhbFJ370c4fA21NR1IjB7H1azSeLTr4HeQBWgZZwBoAwrLYOVkL5/jn1H1xQZydYz
 S/Hx1rwi
 SbS5GNX8M3zsyXFEHjsI+gjj6LF1+LxK2Fw9gONom3SpNhzYyoB/C2EUde7b1zNPGHtYLH2kvkqvKz+lFUpAw7A+bTtRjoRhJe+6pvSBy2ENEin0H30rVH7d0BLtUfNFAKYLiIjFXgyDRFp6xvbRShCVq8aYg5mGvyO0hUk0I+8M7w3P6QUSw4bZbchoJUGhXMEnD9scyGXinsedF1bLW3BwYDTiutzQlMlLo/UgAPCBACBK0PSEArkUBeC+QiyuxHm2j+CtpWalXajbso88cDtvmLGos82+x+ly2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 14:40:41 +0100 david@kernel.org wrote:

> On 2/25/26 10:26, Li Zhe wrote:
> > In folio_zero_user(), the page pointer is calculated via folio_page()
> > before checking if the number of pages to be cleared is greater than zero.
> > Furthermore, folio_page() does not verify that the page number lies
> > within folio.
> > 
> > When 'addr_hint' is near the end of a large folio, the range 'r[0]'
> > represents an empty interval. In this scenario, 'nr_pages' will be
> > calculated as 0 and 'r[0].start' can be an index that is out-of-bounds
> > for folio_page(). The code unconditionally calls folio_page() on a wrong
> > index, even though the subsequent clearing logic is correctly skipped.
> > 
> > While this does not cause a functional bug today, calculating a page
> > pointer for an out-of-bounds index is logically unsound and fragile. It
> > could pose a risk for future refactoring or trigger warnings from static
> > analysis tools.
> > 
> > To fix this, move the call to folio_page() inside the 'if (nr_pages > 0)'
> > block. This ensures that the page pointer is only calculated when it is
> > actually needed for a valid, non-empty range of pages, thus making the code
> > more robust and logically correct.
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  mm/memory.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 07778814b4a8..6f8c55d604b5 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -7343,12 +7343,14 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
> >  	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
> >  
> >  	for (i = 0; i < ARRAY_SIZE(r); i++) {
> > -		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> >  		const long nr_pages = (long)range_len(&r[i]);
> > -		struct page *page = folio_page(folio, r[i].start);
> >  
> > -		if (nr_pages > 0)
> > +		if (nr_pages > 0) {
> > +			const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> > +			struct page *page = folio_page(folio, r[i].start);
> > +
> >  			clear_contig_highpages(page, addr, nr_pages);
> > +		}
> >  	}
> >  }
> >  
> 
> It's all just arithmetic operations. Just like Willy says, I'd assume
> that the compiler can just move them around as it pleases. No dependencies.
> 
> So I don't see any real benefit with this patch.

Yes, this change does not offer any performance benefits under the
current conditions. I proposed it primarily as a code cleanup effort.

> > While this does not cause a functional bug today, calculating a page
> > pointer for an out-of-bounds index is logically unsound and fragile. It
> > could pose a risk for future refactoring or trigger warnings from static
> > analysis tools.

This is what I see as the primary benefit of this patch. Should an
out-of-bounds issue surface later, it would still need to be addressed.

Thanks,
Zhe

