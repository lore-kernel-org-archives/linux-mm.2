Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03C4FCC062
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1507A6B0005; Fri,  6 Mar 2026 15:15:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF206B0089; Fri,  6 Mar 2026 15:15:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000966B008A; Fri,  6 Mar 2026 15:15:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E07AC6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:15:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BA3C13B6FD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:15:33 +0000 (UTC)
X-FDA: 84516743346.22.E4FD2DC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 559C340011
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:15:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="sBhsbe/F";
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772828131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqDtRxUnfGVfrmPs+B6wD6LFhV7Vqmyopjf7Cm65ZXU=;
	b=jNfC8zg1V0s+Lt/ATFZPEH7+1tJ3hptHVU+HiGbtJ6ZKnBDKWPhBy4OLWTFrSTfhEF8CRp
	5Qi9BCAi/mEAarv1sFVvjIm0lkMouqerRj7fV8jjwMLyF1u2+v9Fk7HKypGsASlgvsG8If
	ZUuH7InMQAU9YCHftllabmV3Ac7x7AU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="sBhsbe/F";
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772828131; a=rsa-sha256;
	cv=none;
	b=qrpIsjXSsEsiLLDJhA/Vp1eJuxA+/EprEJISREjb7zDYVNcetDxHwMitVf3pCryP2KgZTu
	5G/AcsiDk3iwTUUc1o4QlrzqZRZ1dzysRaSnijzPwoc2ifIYmziJNQ1EUETdYjPRhNqaPN
	QV7gdXFL4mSkNOEtsz9iBGNzhjP4ETQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kqDtRxUnfGVfrmPs+B6wD6LFhV7Vqmyopjf7Cm65ZXU=; b=sBhsbe/FNOqE/9HPmw8kY8dloZ
	D3l7DInSbFxSaRAGRZ5ESjNCK30kpnNJQmpNy3wd8uaJncNSI5SYn5GVyFQhbgef9IvfE+J7x8I8G
	cuP+fHX7rowitDNg++hVYOrVbs14VVSv44OUNdEmldYhWz9/jwbLuy1n3bLwc8KQ0EoXK894aH0h8
	zKF+b7TywvlXPi+nLe51Tyk9qcfLYN8wrn/c7B7tuazL+jq4bfFgo7TUmNSBNQCHwbA0XxC40V59t
	rieSdE4cYACXiuUHwRIGtxm9sozlM2dgZRKVH7ySQjtMS6D2DiwVJOwDPoay2PKrl6rEr2TNPudxE
	f5cE6rDg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyba4-0000000HGPN-1QDp;
	Fri, 06 Mar 2026 20:15:28 +0000
Date: Fri, 6 Mar 2026 20:15:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Josh Law <objecting@objecting.org>, Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH] lib/idr: fix ida_find_first_range() missing IDs across
 chunk boundaries
Message-ID: <aas14HsY7dj6jTDZ@casper.infradead.org>
References: <20260306200319.2819286-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306200319.2819286-1-objecting@objecting.org>
X-Rspamd-Queue-Id: 559C340011
X-Rspamd-Server: rspam07
X-Stat-Signature: 5mu4sqaagfke1memfr5yr5gmyahrn9rk
X-Rspam-User: 
X-HE-Tag: 1772828131-730468
X-HE-Meta: U2FsdGVkX18Kc3W5BSkZVO48uQQlHIsrmhZcAvgIOdPCngr5rJizCxeycwmmSzYM6D7crOiixjm1+D1k05NkoYTtclpQBlMiO2D7J8PgGA03k8lsmwkCCVlOPZVV8UoC53BXn5aSg7yxBTgeYZFm5ByyqO3GOtQnFiZcmciImta9gKMueIfpmEaFMqPYEGtw6+tFUY3zxREEfsUzC1dhV4ZCAMiHiTEBljS263j/diXSTNica8TDr0qIy6CgwSYoy39zPSkLvMR5fmln8QRHvCAsYgG/P9palILif9ILSSzcNe2A+2bXXOVx1uTc80xMKOt1siIkzTAVlnqioFaOg4h7q0isst1iSYz1eiMuh4tTCsJEHYU8W7a+hCPP/ldsbACYURgCankzABMMOzfBjWv3YIcCov+tVTalP/uzmlZWe+VWpbUNDLHnEA7xWcz3i9kTpw1l/enewYisnavmCB+V7GFCPnq+zxlpaYf/hsU+KXZUjeIu32WmY9lo4xLreD1BfcEfsXAZ3JAOdPB/TxeXNh+xKnzCbRMeuF3pfbhI712DtPU19+gJrmxs+JLXy1HsA2t7M0prnSZTvIDwNi3AfGddV5jhn9lltyjaPJFP9UcRmdEh2OJ1GpGPVozFNOI8Wx3VU97Re9NLlucukh3swEGx5t6c5YK2d7QLyNDvt0SN0xxZDJGyKvvaleNN5MAYoo5W5pV+fUxgdLU6ml0xP3FPMpmtAbIjuC3Myilv9FHQOvCYa6axYXp+9RlCKIFa9G8iRAQPU8fc7lGr/KAtRqx3CQCQZtTNGvriWaZRokcKB68fVTYmifuwmGQHaJvp21F8bLsgL8Gk/lUMzZ9XgJlWEevaASIbx+jkLGANQR6ESkyEd15Z7wC6WoPSPhPPUkCUQUSkA885FcuNwztiKWgUvX/Wv0gbFwD5r3eXDeraFqSrCVx8SlTy0gOWXdVGYkTfqY9xiU5xp6C
 lqnmq5WD
 6TM6ByA3NS8Sf+RBZQJ9eVKKDsmDyXQKnkSCwha/5fXRWY5YXpz7bbBd0hjXjTv5m7WtxONpGeE4PygjHUOdEy+VUdAMoTx7PdEKsTB11kXiB6ZhAh0imo1cvoW6S59nI8Nap70MdxzPWLJ0kYyPKrBV2vF+PXWrWvZWQa/ih4+Zx/PnKKxvuOGXLbzzC0B0lGEwU/sUgn0g7aP6Igeud+lN5P5YAU6kxA06AyxDMkrS4sf+qk6RqpIIyMQm2HdFDq3PbUCHv5mNMvUWLA8pmz0ISmnvQmlcX7LtfAgPJa5iuvUO/J3cgcHAcietOZQOcGULN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 08:03:19PM +0000, Josh Law wrote:
> ida_find_first_range() only examines the first XArray entry returned by
> xa_find(). If that entry does not contain a set bit at or above the
> requested offset, the function returns -ENOENT without searching
> subsequent entries, even though later chunks may contain allocated IDs
> within the requested range.

Can I trouble you to add a test to lib/test_ida.c to demonstrate the
problem (and that it's fixed, and that it doesn't come back)?

Also this needs a Fixes: line.  I suggest 7fe6b987166b is the commit
it's fixing.  Add Jason and Yi Liu as well as the author and committer
of that patch.

