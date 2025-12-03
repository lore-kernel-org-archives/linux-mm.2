Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB39D15DBC
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 17:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26AC26B0010; Wed,  3 Dec 2025 12:53:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241CD6B0012; Wed,  3 Dec 2025 12:53:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159526B0022; Wed,  3 Dec 2025 12:53:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00E5F6B0010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 12:53:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FE25C037A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:53:17 +0000 (UTC)
X-FDA: 84178906434.11.0D25338
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 61B3B1A000C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:53:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ia87VjVX;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764784395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVJlOc8ND/Iyf2S5FSwKg8rOfnG5RDtAsn0WPd8mpfs=;
	b=1A1DHW/DGD0RxsSUL8Wy5SY4KAEbcjP8lyjNX2+wjEKCF6T9Q353Obe2Cw+pAnp0TvwgIJ
	jOHz8ijwaXyb6JjJv+4JfKFqqGgZw4nsevwZi5e8O6MFCgb95JgISNAopUetEBKbhZ8suH
	C/Y59985ZI/9DgNwqZsMTVoCvm0yBGc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764784395; a=rsa-sha256;
	cv=none;
	b=5uxBeR5gm7t3rCcoOcRSBmZJLHP4wSV3+QTZqiWszrxOyHSKIKS5eL1EfAQDVCveVNbpMF
	2j+rP1b6hT9pXPYXNbgqki1j3rVfHD2hXC65pCnZEsO22pYpCw4z2WdbQdgMSrCdKDyk/S
	cq8BQUoDN2pZsTeh/wBfzxzNEKlWAZQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ia87VjVX;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4edf1be4434so383271cf.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 09:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764784394; x=1765389194; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lVJlOc8ND/Iyf2S5FSwKg8rOfnG5RDtAsn0WPd8mpfs=;
        b=Ia87VjVXKgb2SPKlPDNKMZqZ5ZmXAhQ2phfMcO6IYQYYtRtiChmnmOlZgTNkW+LWDE
         kFpGAU6TTQp7wjY5U1dGgiPIAT9EHqMpEKHJnfTm/0PnWO4Io5GtfewVP+LVoTYH1yQ1
         k4zgLQ6su+8scbS10MqaKOyAqlj8oB1YHO/1c1G3Mvy+r/9RmWEMWKwYmmNdCMkgMzvh
         I4CU4Z+dhlelk9quXtRftkeVH1veVTsOxQqgm8zPLRfX5nVqG0dnySXs+FPWW1gtMbkE
         pNC0EfACltLvy+CZnrmufiYmM2UdCveCq2wDCMR3wdmXOnq9jCmmxBKAvMc+QKY9IUoI
         XK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764784394; x=1765389194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lVJlOc8ND/Iyf2S5FSwKg8rOfnG5RDtAsn0WPd8mpfs=;
        b=uFRoyBjypL9x2agmqyxqGOSVeqWGHJruMISJd9MfZqsVlL/X5G6yZ0oLKU9iU8mRAM
         IWk2c+w9PLToi9Bb4nikwp88gA9lACGEIgejcPTyfDr7hQL68W5LIMFaR31eiEVdvZ95
         3gHbhTnG7CCc0ErOOMLry5OASn28BT0IMPrARByUFKvfNPQ0+23LOEEkjI1RTu6ufxkj
         n/DEv1Qr9M2d17COIKb9EjJLLKJl7afd0lUxGYjIUiU0EMMIMFnTHWruGzQBfck73S1Y
         H8PXhu4ME9l5BWnN0K4Rr2hPogAs0V9ZRyUUDC2u2XUWAqUUaUtXpaBkuJJzejmmM7dI
         lHjA==
X-Gm-Message-State: AOJu0YzkNE+AfxzCBOqkC4dPRzvxuPbgkEHDH5ZH34XA2dThwekWisat
	jVtS8XBUjmErNITTt1JUq1DTS/rVjXXk8/MCHm66hkOSIaKpgSNNEnDdLeaASZ62Mno=
X-Gm-Gg: ASbGnctN1yrVuKd65rB3CmsJoHE8xehd7gmBxzXzpEefFAXxet1X5sc05Xm5mK9ussv
	PMLtrP2Qgt5yf7ffLvAiqwMRu/HAXRw45ve7dFNVPUeUwY8AmWxhoMLJlqyKTEbHMXL9X+TKZ6B
	Hel07oA+ycYzeq04zqw38oq90sh7ddZNLlw1W9Lz8kxB99ON9VxlpH8hfsG8q4ICQFjWOqSIJOF
	LOdwEhZ98oPvLaKaCvV74uyn51UkS7vkGtjhch2B1iM5gqj2DoTusewMPAos39A8md5odZm1XqX
	EP6khye3ViW5jGM6hNhrcgPSzHVkeiHo4vK4T91RexTbRtIrBvhRX9R+miE6B54BMmA/U/5UEXq
	gx6TFGcqQFM9ve8xOK3aO8Q3Bd9BUhguMDfyBjtj+XDMiUKcKusXdgVzughJMOAl3EFv7jIsdwx
	lzKC5yJW1o3BndtfFLh3YwrH02gajZkmN/a8aOw9SEMVvbcY9GNd/TLV7CTqUEqQY/zQYRYg==
X-Google-Smtp-Source: AGHT+IHHD5+Jl7GtUH8NhBzm6kCviK25Go8YNEW6lOEadSIHifkHTfsNCnR07LpsAcRGWeAu1C3aGA==
X-Received: by 2002:ac8:7f4a:0:b0:4ed:b6aa:ee26 with SMTP id d75a77b69052e-4f023ae1140mr209871cf.55.1764784394367;
        Wed, 03 Dec 2025 09:53:14 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd3444557sm118131171cf.30.2025.12.03.09.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 09:53:13 -0800 (PST)
Date: Wed, 3 Dec 2025 12:53:12 -0500
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, david@redhat.com, x86@kernel.org,
	linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203173209.GA478168@cmpxchg.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 61B3B1A000C
X-Stat-Signature: 55og8jpa9biwayhro84ky5qz5cimq9ym
X-Rspam-User: 
X-HE-Tag: 1764784395-390813
X-HE-Meta: U2FsdGVkX1/7qFyy11O7Lb3WmMmBvxnMZts4fIP10s9CmBJRFRlHqNAMMNZEnTbnxR2ZKfhiy/RUuBk3rS2wsFmhjteJNFr9sIFScf/TrDdI+Ntay//87lH/HdS3ssqzVYg+WJbM5zPHD69HZcWibcz7Tne76+dcvkVtr++vIhUtufjDSQ/L6Y8lz63WlA1mTJVLQAVxVEUle1lkt8LK7DIWhYtbtL8rSbvzAdIJpzc+1l7ltqNtAy+SqmOrUVW35OnFlF2wNIR4NwzOELm1TUphrq+40cxeaGRdYsEkp4ZCyJsmhF1g+uNa9aBBuhhOOLmF67mBnVrPGIzm/rgAd+M5w8OuK3S6Lo2BWZcQSJaqAlbRM/boxtOmA0C6kpgnmmsE0I5qDURYwYkClO90GzaObYZOTv2RmrhFZ5oRmqvpbPvSo+3mVfjfASqGYyxGkBuSEk0PU+9TiWhua9aNu/ddpqOyswg/gESSMZ7sGo/fPUafnhqXabf/zeT5V6eulT5++pK12bH8V/sa4GWSrJX/czagEWbfns1JoMWJbPooP8sDY4Tv8VqpyBN6U/7KNz+iT3iKsQxaPh5IF4/PWjA9dp2lKHVkTC2Y+KbC1JvYR4+AZh1flgMk9A3Agem35PhRp2WBa9BVuAR9EQiwYY7kPj2p/fOhBWnYi35fdgOqHTx5Q7eMqns2zIuglUCmWhAfuMZ6lBUfk6Pa4t6jUqECjCvdiRNEJhfgq8h8GdtW089li5xsAQ4t3ELKJIQwx6cPSihv6qoFhWJKgVjxnPJeX2QIE3SU7PAw08prNFWDq8cH6HoZt25ZjcTnDEvneKbVUBUiY98laH4Q1CUlgVBFNInoIyYwDNglRzMhXRKUTc4CdX0eNR2N3KRyaKPfShYdf0XBUpZzlhdC+LFv9iOLY6KqUUsBVCX7YGTiirkcnzN4N5lg7fFtQBzYTopm4EWs+v+n5bEtuaYLivJ
 t/iV6RHj
 zY79+hxqqfvrLmWCbQ3RtakECvpY/w5Uzs7uLozYVitjtRoCMW/XR4KdtY3QqQcHID1JFR6KcHlH09xK7qe8d3RN7tFF7MWxKuT/t3VMkecu/LfEus99CduPfiSNb9dNGuG9zTn1xEIySm+/D62znK0EU+biwlPddJkPM4wSCHMENSusMEmhReF9PcaOqx31aOoPe+KMfA/sbQy2CYIblOQNfK6W1ihdlaX6vtIhfUtkEjvvWPKp0qPicj6kH7peD3x5HLr9LMoI1wjvucPnc7HCJAmgtc5XWFOISabdDulBvsYFKI3LHS+AP3zWyh9dHq4x5DaF54bnlU1yWgn8fbfp/Ff16neWtrNDqZ0LQFo+3oIoiGMxqQ1WJHnm264vCT02+5aD4A1ywYjdFDonk4SotzjWJwm6jj0QPalL+tDYcFj7sdG2i/XYyeQR3z4g1Xggk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 12:32:09PM -0500, Johannes Weiner wrote:
> On Wed, Dec 03, 2025 at 01:30:04AM -0500, Gregory Price wrote:
> > -		if (PageHuge(page))
> > -			return false;
> > +		/*
> > +		 * Only consider ranges containing hugepages if those pages are
> > +		 * smaller than the requested contiguous region.  e.g.:
> > +		 *     Move 2MB pages to free up a 1GB range.
> 
> This one makes sense to me.
> 
> > +		 *     Don't move 1GB pages to free up a 2MB range.
> 
> This one I might be missing something. We don't use cma for 2M pages,
> so I don't see how we can end up in this path for 2M allocations.
> 

I used 2MB as an example, but the other users (listed in the changelog)
would run into these as well.  The contiguous order size seemed
different between each of the 4 users (memtrace, tx, kfence, thp debug).

> The reason I'm bringing this up is because this function overall looks
> kind of unnecessary. Page isolation checks all of these conditions
> already, and arbitrates huge pages on hugepage_migration_supported() -
> which seems to be the semantics you also desire here.
> 
> Would it make sense to just remove pfn_range_valid_contig()?

This seems like a pretty clear optimization that was added at some point
to prevent incurring the cost of starting to isolate 512MB of pages and
then having to go undo it because it ran into a single huge page.

        for_each_zone_zonelist_nodemask(zone, z, zonelist,
                                        gfp_zone(gfp_mask), nodemask) {

                spin_lock_irqsave(&zone->lock, flags);
                pfn = ALIGN(zone->zone_start_pfn, nr_pages);
                while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
                        if (pfn_range_valid_contig(zone, pfn, nr_pages)) {

                                spin_unlock_irqrestore(&zone->lock, flags);
                                ret = __alloc_contig_pages(pfn, nr_pages,
                                                        gfp_mask);
                                spin_lock_irqsave(&zone->lock, flags);

                        }
                        pfn += nr_pages;
                }
                spin_unlock_irqrestore(&zone->lock, flags);
        }

and then

__alloc_contig_pages
	ret = start_isolate_page_range(start, end, mode);

This is called without pre-checking the range for unmovable pages.

Seems dangerous to remove without significant data.

~Gregory

