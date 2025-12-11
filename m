Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BBA7D3E79C
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 07:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750226B0005; Thu, 11 Dec 2025 02:38:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7016D6B0007; Thu, 11 Dec 2025 02:38:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616F06B0008; Thu, 11 Dec 2025 02:38:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8016B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:38:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA8A9BB569
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:38:15 +0000 (UTC)
X-FDA: 84206386950.27.84FA47B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3CB81A000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:38:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RXb7Y72Z;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765438694; a=rsa-sha256;
	cv=none;
	b=bxs7o0MyPSZ2fSXOV2uhBGTUtQelLDvP3A4zS9N3d8K3hulXspPjAksPC4EFOmDMMxTaPa
	/Is765InGSohkUCVQkAnfjFxE4NWoP8gZIqKG2xf0uQ+ENEkAgHJ7VhZrrhgyISjBSmlsh
	j3JNqokwCaeQFLXMN5BSBooVcNBmKAE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RXb7Y72Z;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765438694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvL+wWM9xb9eGh0ewmBu/qTlopS6rqYvC3V8y4f6Lis=;
	b=Ghcv0IJTESw2WnnnVkPwhk9/VBLMWpZKrC98/jVukfuS8QHxnRJwkUIK5uP+30UNVlG2Ho
	AjIbdz0lx2KxXLTYTkT26pERdvXKPcJR711xtCzrZOTal+qswvzITc068iOqzPKh+BjFse
	V4z4FZZwt/9xaQ9sKfRq98B8W8LRmZI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LvL+wWM9xb9eGh0ewmBu/qTlopS6rqYvC3V8y4f6Lis=; b=RXb7Y72ZDLDYLNGzvUQCElZAeD
	BL66pjYC7rbK0+X6ld6Xm7Hz94GG/G0qAauo8mZLNeI+zAmxu0fJEwJL99vnwasCVj5N5tj3KLh1t
	KhmtPmtNh9raTTYvuZrRa9MfmLABrsVANz0JeRpO1kZ+RbTVWI6EucsQk9cHL3n7DJJ+elSNVErlX
	DZvbx3t2+JeBopt+WZXzlLqNyERmxqLJ6u2rU3ZaEhQ10Wa4EXHTUArwL+HDPmP/sxLD0U7zcwnV/
	LwdBXGmOhTWf/qEGpq8xoU3IcKTF+jxv10EAHQeCoQ9xAg7gDy0X89VseKqgTBQ7pI9yUOFpb22i4
	AYWUwNDQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTbFN-0000000DwGk-1G4j;
	Thu, 11 Dec 2025 07:37:57 +0000
Date: Thu, 11 Dec 2025 07:37:57 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Michal Hocko <mhocko@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, mcgrof@kernel.org,
	gost.dev@samsung.com, kernel@pankajraghav.com, tytso@mit.edu
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
Message-ID: <aTp01WOPU0dYT7yx@casper.infradead.org>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <64291696-C808-49D0-9F89-6B3B97F58717@nvidia.com>
 <aTj2pZqwx5xJVavb@casper.infradead.org>
 <D498FB7E-1C57-47A6-BAF4-EA1BAAE75526@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D498FB7E-1C57-47A6-BAF4-EA1BAAE75526@nvidia.com>
X-Rspamd-Queue-Id: 3CB81A000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: kpwh9azqwiyti3ij5tywrt5p6d9ixpwm
X-HE-Tag: 1765438693-124797
X-HE-Meta: U2FsdGVkX1/uTawSu1JRo2yH2v+lwbw2Yc0ISJa3+XmBsgwp6CnKo8SdW8E+AZS4Wjoq3IcTNsETeFV01UeqkeMFOmN0rFAArm1W9bDQ8GMBmH0Etdsy/CTdilEFEqbEDN1Z9TBydmAO7GnkW8dih4qWlieOU5TccpyuJx2mULENv1DnKfF5oFSPmORzBLRld/d+fD42ZnZ4tkOh4agw2dvkPpCy0Fvaxm6b7itJFi/GmUaC1InrArNeNZRgsgMnNdnUkDsdrTDHVU/LncmqpISgh/5kUAfeBvdfrhOEyIclveT5woJ5B2EVjA8uOUrPsfYzDpdt7Zp0cik0LcNOWqPjuSvW2+gUkl7y5ZxMNVjJcZP2ZnXswhN2tShGF7cTkGPV3ekVjNWF7NOvQXRdbOwhi/SRzguXHY6n95k0ySwZwjWDZNHLQDzWxNPnWcT9Dp3RtvrVVOmOZa7m1f0pkLtBXaI2XSLvNrq2cTn3aBn57y6t462mhR0udyfYwHEb5hS++hKgFkUetTlb1iOzL32fnhZYI6C9lja63O5YaQGtDwS2hjPs1xvFRTFXUV9k2csUEv2eGC9hhDojcjRUCtxWW0akvX6nQp1uURDRVGDEw5KwlxP3PoX/CZE9+X5a+UQYF/JvKwjKrcpEhyLcDgDri2jSpdOkWH6FfOvh6bnWHpKCyYQ7QQ3ozeyAKLgt2GHgxa7STNb2mvbWhBFc6eynOKCv7chQ4Vqe/om/UCm6eS7+ezZUgXYXzrnw406E0ghv1I/ReTXES0iNHxlLADzMbXhpYWeL6o9Iq1+Ux4tQ72yEph7DTLQnoxXrd9VEaxqQimt67RVar4KHfipDu5CAtZq0N4AS8tZBvqUElAqjMaFj8oqa2lbmvgSzLWPZhW5NA612qbmp576SzxGpMuvBjf/EI/rDabheSdLlGEWw/JLRUpZ9wdLV13ht5xq5vlLoRxXfWV7jg4e/WDO
 lQa4RzbL
 luQpuVDZnfv1zVy+8YcWkKHoV05VoBCTMGPgQhXn2vegX2Ta6/qG7wwJ2C7+HX4GcZnD580BiNaW6cMlXgm0tqBLBa1jQYdkjXVLb9tcxOZd7wVpA5dTb+YVH0FTo53OE94aBhLXGmPbVLCcexLSbzOfY1iDUipMomm2+39hzirpqaX+TBIqt8YgNlt+NVWNUMlarWfEGR7bnEW6eCsr34ccDGEajqiv6B/1Qx2yxSGhXiOy+W9UuR5F0LJtCy8GuMLcO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 11:37:51AM -0500, Zi Yan wrote:
> On 9 Dec 2025, at 23:27, Matthew Wilcox wrote:
> 
> > On Tue, Dec 09, 2025 at 11:03:23AM -0500, Zi Yan wrote:
> >> I wonder if core-mm should move mTHP code out of CONFIG_TRANSPARENT_HUGEPAGE
> >> and mTHP might just work. Hmm, folio split might need to be moved out of
> >> mm/huge_memory.c in that case. khugepaged should work for mTHP without
> >> CONFIG_TRANSPARENT_HUGEPAGE as well. OK, for anon folios, the changes might
> >> be more involved.
> >
> > I think this is the key question to be discussed at LPC.  How much of
> 
> I am not going, so would like to get a summary afterwards. :)

You can join the fun at meet.lpc.events, or there's apparently a youtube
stream.

> > the current THP code should we say "OK, this is large folio support
> > and everybody needs it" and how much is "This is PMD (or mTHP) support;
> > this architecture doesn't have it, we don't need to compile it in".
> 
> I agree with most of it, except mTHP part. mTHP should be part of large
> folio, since I see mTHP is anon equivalent to file backed large folio.
> Both are a >0 order folio mapped by PTEs (ignoring to-be-implemented
> multi-PMD mapped large folios for now).

Maybe we disagree about what words mean ;-)  When I said "mTHP" what
I meant was "support for TLB entries which cover more than one page".
I have no objection to supporting large folio allocation for anon memory
because I think that's beneficial even if there's no hardware support
for TLB entries that cover intermediate sizes between PMD and PTE.

