Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792CBC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 01:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0913C6B0093; Tue, 28 Jul 2026 21:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042936B0095; Tue, 28 Jul 2026 21:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E994A6B0096; Tue, 28 Jul 2026 21:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9A736B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:43:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63F81A19A1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:43:34 +0000 (UTC)
X-FDA: 85040117148.30.DAC17DD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A638140004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:43:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UztfcEwy;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785289412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQe3rducnc/hAq/daIrVP62zjCCXI1gzLpDOiqHGhmw=;
	b=l8MJD85+YhUk6WYY2LcbMpFAOX7Xtwi7ODQvoUQv0gHt7aEAxa52A/0hOw3SQhYNce3zyW
	CtH7/JgA+TlGoQ5UPRd5Ypo7GacPjAwMc8GzmvE7ZFXn0ZyNDoYPXnZNDOZ6oqszWoc6Y5
	o56+h2Buh+JP4+wbtxaUOfePx3s9xI0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UztfcEwy;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785289412;
	b=a8BsowJAFopnnV6KU345XrRsHt8uz26m6+ujxlg7jdiQns6lhiBkleuDI+mIVMMZqeg/CO
	2WjzFRLkfGhiF017RYqloLwGfUm/Pq+ZaR6u4uGd3GHKLa/qAOcw1ti2TqRXu1m+LPEpGr
	GabCNJ1STwFQgLp4a3wuiKRl+OdXgLo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tQe3rducnc/hAq/daIrVP62zjCCXI1gzLpDOiqHGhmw=; b=UztfcEwyLXvFJYGKiI0fBUhlUz
	Zehf6jCxV2aHeB3/kb/wK2M3s0cM22Pp6GAkn9UyivROwOpdBcMJmGWy3KqqGMCt1KjY43k0Z+fpB
	wKty6uOXF+ObZBIzi4vuuJ8n1bjVP9NhmZw8kZjW6SLpAYnlA5XQE0Saiaonqz+z8H3ZAFUYTmxOp
	16rN9olJdVlhIiyemH+UIyjkxk9BLKmrfyaZFtRRjSyU2xPRLVfIvKkS0Oopvr5n3WBLSW/hks46u
	mm9VB5evniPrOD+M81SIJwM6mJY7AX6ST0R44yGgRsM/RmOzJOYEHO8dVDL8GtMoDiY2rWOYO6+Qc
	MUcSg/Nw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wotKR-0000000Erx8-2KYz;
	Wed, 29 Jul 2026 01:43:27 +0000
Date: Wed, 29 Jul 2026 02:43:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v7 01/13] memory-failure: Fix hardware poison check in
 unpoison_memory() again
Message-ID: <amlav1zfVy-9fLw5@casper.infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-2-willy@infradead.org>
 <amlKHkemYQBxFESG@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amlKHkemYQBxFESG@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A638140004
X-Stat-Signature: y88oxbueetsn4748k7u5f4t95hfiewa5
X-HE-Tag: 1785289412-520894
X-HE-Meta: U2FsdGVkX19SpBh3hQp4mJ7zUtK92bpNJlXhqaTcfTwZhmr4FVUrfNBqsGsoKYWoc/zpPMEjI82ySo3KNgsL5CyUQfHtoJ6Pka/mFekwJhYkFUcyeBAt6yMtLoAHE7JGmgbQe87YREQEgTCK5uXDIDYviRjHeI0j3mgnzjwIArZQgWXXSdwXJXW32zfT8kD5Hi7YLwtWJEoaC08Xj3fu28GVEwB+hIMHehb7mzmEeE45JmuG6jd/BamAFHqyQnXBPQjqgwdH6M5MhGrlN6KjuFQ/qu9yE9OTjMYvel0YbROl/PRdhJf2BbgJhKwL0gGhtRcjDhgPn4998YshueAFMFCnKJFIfQlDZEULmvK/KeoQl4bD1m0MSejF8VnVphDr9FRkmuRCJMUafBghBXeIg5LwZOava3CVtDMN3x+SF0Ut7c5WSBJ0/Y7JeODDR05HHAi+nUoHokv/PDOSuhaglYI5okLMtWDm7KDveQN58M5UGOSA/9poCBNKXC33yhkJq3wTXOMQzY85rKDv/mj1rKtOgzr9ZWwJdHxi4clYG5oMRNY5eYhaRifRol3AOSkVSYmgC1S7LSdLpjUKxcZODFpDrhnyVzpQEkQlb5L0cYJFGYrjdTb3PF5AnCtJxC1klnvN4M3YL65FH0jsboqhCNEcXJYZGLcLGa7KBjvfeNEUaQJh4RGRpe5fgJiUt7iQErNRuIjhJ+8dHwwK7QMcEYoumstHDLI4hDHUqCVKs2tWrWCn8Xuy4w71IhIQQvLGPhYMD8gbNTSp7WZ5d4AY0ieoZxLgPNSuxQL4RQ4g/TVThySnZpnme56Hmk0l8ApVUbOBZpN2J4xtU5GKOmxy8CF0pmB8l+BU39IaEbjZYAN4rO7Iwl2ezBT70nA/icD2o2URSBVwFplqfnvL01x6q+RbjLTmCIpB03ydCDlIfs0FQqgJQsyDzzZMAxb8kcqE0wJYc9wV+6T8J/hpEaF
 OYbT1kAZ
 B/u70bpGvjnRGJ/4pSccZe2Fb2FWUf53tzQT6CHUryjNzJodt8OkjPuiBppPgiwgv+SUO19eCHoFauJurwzQdsLfAC3QOvgWe/AUqfGujiAQx3gGLxLYl3YuaJPAZHETeDPXJYFnX1sVTNSBTqTVRwTj0G6FvcjBoxcPxDkVQlSn3xx+t+sTOV8t+ibE/NBt60eV99/9keK+0i9rJf91/oNgKY9CC+Uq7vX+Sv5K29Wph+rXlA1ZgeD5qJty4nHlu1kS0Us6jlKqXBT6fH9lTJ8zGA6VbPErb/5UyfZuTuwir35Pr5SRJMce29DaNBst9d0ScC3spX19vQ1Buk1Hd0NgrsqiK+TzRXND2Iw66kE0uzTiX/29ZlfLXocUMBeCqQcStxOCCNOi4mokFYyiJ461vSsqgZXew8taf9jhYxUlTjcT1gxf1wwIej8QmEIjIXjnFPMC8xLimuCylcJKPVuhSwTOtGUOSlY+g6LBhgjs7CmPTLDI1QzPmYd/TjBSObybX9QBd5o2NHo30Pv4FA3d4lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 08:39:29PM -0400, Gregory Price wrote:
> On Tue, Jul 28, 2026 at 09:43:53PM +0100, Matthew Wilcox (Oracle) wrote:
> > The earlier patch (6c54312f9689) that attempted to fix unpoison_memory()
> > was incorrect for hugetlb folios.  Before a6fddef49eef, we checked
> > the head page for poison (which was correct for hugetlb and incorrect
> > for THP).  We are currently incapable of unpoisoning pages (other than
> > the first page) in a hugetlb folio.
> > 
> > Use is_page_hwpoison() which handles hugetlb pages sufficiently well for
> > this purpose.  This is racy as we don't have a reference on the folio at
> > this point, but fixing that properly requires deeper surgery and this
> > is a CAP_SYS_ADMIN path only so this will do for the moment and can be
> > easily backported.  It's no worse than the situation before a6fddef49eef.
> > 
> > The other bug in a6fddef49eef is that we currently clear the HWPoison
> > flag on the precise page, which is wrong for hugetlb.  Fix that too.
> > 
> > Fixes: a6fddef49eef ("mm/memory-failure: convert unpoison_memory() to folios")
> > Cc: stable@vger.kernel.org
> > Cc: Miaohe Lin <linmiaohe@huawei.com>
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Just trying to wrap my head around the state before/after, assuming
> the following is correct then LGTM:
> 
> prior:
>    pfn_to_online_page(pfn) -> p = precise page
>    PageHWPoison(page)      -> checks precise page. Poison for hugetlb
>                               is only set only on the head, so bug.
> after:
>    is_page_hwpoison(page)  -> checks precise page AND head (if hugetlb)
>    p = folio->page         -> now TestClearPageHWPoison() explicitly
>                               clears the head page poison if hugetlb

Exactly.  That was how it worked before a6fddef49eef; it used to do
p = compound_head(p) (which wasn't great _either_ but had different
problems ...)

The careful reader will observe that injecting two memory failures
into the same hugetlb causes ... problems.  That's true before and after
this patch, so it's no longer a regression.

> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> 

