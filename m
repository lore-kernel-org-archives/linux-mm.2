Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCB8CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18428E0007; Tue, 21 Oct 2025 02:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF888E0002; Tue, 21 Oct 2025 02:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CD88E0007; Tue, 21 Oct 2025 02:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF84C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:12:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63D551A0434
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:12:54 +0000 (UTC)
X-FDA: 84021103068.23.92C92C9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1263320003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:12:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ShKdqzOl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761027172; a=rsa-sha256;
	cv=none;
	b=2zuwPSkn48YFkLrHduty5GdBitR/n0rGGUTIwa2hkAaNfac4IP5pVNBsqbCvIFEMjneLay
	L1Z5m/AT9rNyXsW3gNL2IB9AMUhdzUGBMw7ZuN9pX9YveQatLnyGxDy8sibqFfjhoITMhq
	5j0BFK3RKHwgyFvvQf8S3VkAZrD2PhM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ShKdqzOl;
	spf=none (imf13.hostedemail.com: domain of BATV+5669af1c49f76a6ebb22+8094+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5669af1c49f76a6ebb22+8094+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761027172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32WXsKzxggeOILJADAf0lJ/XcojNDUkG87T7LB0uMmU=;
	b=O7UfJW4g2/LEdrc+Ns1TCZxWttWbt4FljAGYuv/KvqJV/l0k2fgZeNex4YJZ70+/PQ6sod
	dizTPioQbFF04XZjMMQfIRFyEbk/0rHYYGhzY35viwbT3Zd7eqz0TkiMMq3f8S4riFnigX
	qSYi843cYnSVITXCzQJbFAyS5y2dvHg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=32WXsKzxggeOILJADAf0lJ/XcojNDUkG87T7LB0uMmU=; b=ShKdqzOlsJZJ5PGyNK+WPgm08w
	YG05J6HLCcDbwjPvnI2QKbkgv/jKp9ozm4cWjoblrSDJhZ0TR5nkyWesExrjXvzpM5nGgaQuqd7V1
	rvdQqa2snXe2hDLHng9fXY1sngvgapiVGUyprKX0IWXegzyi4+aXuZzyermYeCXnmCFdpp6bV3QWw
	jmh71KufOM6iT9U0CiMBHCGz2dLUYPXWZXk/5EZwARAimiB+s6wR5K0TATS6/PXzPHCVaGsqYJ1xL
	pgs4ZgTZum8hJdzxZYaGmGzcbeZaXKkXgzvEnVgYuB/0TWX9ayxP052nFyV78namlJzodSv305bya
	CnN0oLeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vB5bs-0000000FuQQ-39F3;
	Tue, 21 Oct 2025 06:12:40 +0000
Date: Mon, 20 Oct 2025 23:12:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Message-ID: <aPckWHAGfH2i3ssV@infradead.org>
References: <20251020163054.1063646-1-kirill@shutemov.name>
 <aPbFgnW1ewPzpBGz@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPbFgnW1ewPzpBGz@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: 3965nnhx48mg4qh15fzsca5intecgf5u
X-Rspamd-Queue-Id: 1263320003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761027171-146339
X-HE-Meta: U2FsdGVkX19AB1YCFjVVJKBn+u0TOyo/NPHU6nELhupNxHxxLepvMU8HvCIwvfkbTRa0QJ7aR+YsmlAJ9bff8r3BCHgmEQ183E+cFOkTUBnj6tWs5cUvPZ8/CBG6MRsd/6JxbHSvqu2C1Qbqgh1+3YteWRpGXxWJJpNRhT7R2UeVBUwGTnOD+9Do4PfeqBZqyF9R6wq1pCJLTnJJezy7Rq8hSV3LkeWb5/g0JzAI8L+nYEVaCCowUeK1KTHlr61VK/eY+FBsEH7Rqf3QOhBFMk2649y7wx02K5pr3R/CplMAUvJDjqh12UzMIcP3TyZHHqNw15Mq067V67xXkvJt7d90lWaUbQB+5IAtYW65enFy2ycNdQyKlMX0mxNsm0RXa8zvsVV7wfdtihA41JsV/C+lDiicELFMGZ/Af3EYxZbdQnYRdhO8jLi042Uj4/+bD+mcKn7WlpTXiJcxA2H99qG3aT3myzG7Qq4R4To4vl1ygsFHbQuVtsl605QB2dscFTUqmaqQZvZzUBVzqu27ikdU6Uq6sl3iDzDJbwO2eEqay23w7YuQaEpFpRqbJngEGX+YueMr+1dnWj1pMtBstxJH6I7GlqWjsonQ26koaJLOrBsrMBj39T+0GyGqBGZHM/UC/3lbM/iEAM72ZcWwcSVuN+GKMtlim5DLi1P3J8cWUSAaiEVaDOw/6eouC9tOA6MLkfkHJjEz/XEJWItvvU5aFcniLjZPPXChIQMWIEIRUk55kos3kUDiQ6AaArgKDIByISVTMq84/obnF27nEUSFyRv/1Qtv5fPkcAOzKoRwC9mqvY4NcY5mKHdGmtZILCy4UbYCW9GCNdadNEMX/R+K07+gKYFs8BZjVAGGgpvIUKhH4rrH6f3nRDp9tig0XpeAqX9Y084uXzvwohvVYSkIZceT5zVCFvgK+GaCRYHFp/ntC1ivRi7WBomjgjXAj/niUPkxkPAOkxS/Poy
 Y0uxsKhB
 gXfw5raot2fVMm4z8LDr9NGzQvJMzrPm+b36jnFqye6RwngdTa6SNcgTpS3NMFUBOB3Z1DxVXGCc4CwZfUD1SS8DGJR3DN3aOiFdPm1gMGU4q7qiPNUOLVtusFjZzdys4hPSDWZsiHHb+H3+ssmarcjhCYHFJgWrxyhQndnu+pbjSSi3tvUDVmwnVtpp6LR6c9aUZIW77Yhll9IF/Nve5k+TDzn8o+/lP8QjDsO6x+cc8D2KOYfhMs4o71Dg4VLtEdqy02Ao8OJl100CBnquX8KhmuOrPs3xblMUrOXmTexfHCl+eFhlMd+SxQNlGJfj0CFRCpW7sedShYVXA0bQrJMWHei1D1vruqdwKbPuBt2LOtXAIPHptoqTYL8Q1hYletRoZcL7TFsLp11Zo136xDFxlWN2lRzlow3b1t5vznXpYGig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 10:28:02AM +1100, Dave Chinner wrote:
> Fundamentally, we really don't care about the mapping/tlb
> performance of the PTE fragments at EOF. Anyone using files large
> enough to notice the TLB overhead improvements from mapping large
> folios is not going to notice that the EOF mapping has a slightly
> higher TLB miss overhead than everywhere else in the file.
> 
> Please jsut fix the regression.

Yeah.  I'm not even sure why we're having this discussion.  The
behavior is mandated, we have test cases for it and there is
literally no practical upside in changing the behavior from what
we've done forever and what is mandated in Posix.


