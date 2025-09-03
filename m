Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95987CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20A88E0008; Wed,  3 Sep 2025 15:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8548E0001; Wed,  3 Sep 2025 15:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E352C8E0008; Wed,  3 Sep 2025 15:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D21258E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:25:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74836867E8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:25:12 +0000 (UTC)
X-FDA: 83848917264.23.B11DEEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A2341C0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:25:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=adGL9oZg;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756927511; a=rsa-sha256;
	cv=none;
	b=wupU515YBBQX85kGyhX/KoQ5nHbMiPi1L/xj5chn6j3BYIyDlsrb5FWRka5l+hrjC6U1tA
	Oc8ZguPBo2/8QzWKuCMm86+VdgEM8+5XRyQAcmtjiGwzL9sl+X/yq7AvuMWVJkkYBQyFUE
	64D0fwrosFiI7xqYig6xQQHyESPDepU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=adGL9oZg;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756927511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUhagBJ1/j4PgqvRx1RFIGu/KN6tTSm9ODHSfQrEMNo=;
	b=sg/+U6XSJtb37FBlrXwueMIxGVGjGji1rEowWqaor5V0nJ9jDazY2EQkqWgby2ngoFVr0o
	rQiPDhQrj6Gh8u7Y4psF5d3G4TzDFw1WbyHpFCVMZrvz9BF0QNWH3cp5se9WEajq6/EGBP
	wcWBGFTV3ZPY4b+yhPRewqN3h0Ke9ec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 67A676013F;
	Wed,  3 Sep 2025 19:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA59EC4CEE7;
	Wed,  3 Sep 2025 19:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756927510;
	bh=NBbsDMjSKsI2AUxX91Gb4WbI92rKyuNDqjM76TYzfBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=adGL9oZgYPs04NhMzOYDFe9H2zXCIScCmhp8FCYjAVCIaThHiJXOKPyFhhI426ebE
	 k1bk9ze6Ty/eCH+cYXBYDRWSUo2bNGShsPuDahO15R/7AM35F+xpGfrHCIEUgCqrzv
	 y0Iup37vzMUHfXI4vtdfimIlD1BKXSnwdfF5tBXXe7IVS/eBu8QkYieuXYB2jPNdOo
	 8w7+0baLFy4wDDUWyccec8EJ8oxOHuyWAvPfOxyAbH4GSxG0k+a+0AofpgoYzsaQtl
	 kzpeMlLyMrc6gOFAJBSyYLqQnrCguEuLzG10UvjAZxXT/sq8OUwW7bqAWeviAC5ejz
	 UFSY/7caqab2g==
Date: Wed, 3 Sep 2025 22:25:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kho: add support for preserving vmalloc allocations
Message-ID: <aLiWDl3sq3RTkdfJ@kernel.org>
References: <20250903063018.3346652-1-rppt@kernel.org>
 <20250903063018.3346652-2-rppt@kernel.org>
 <20250903125620.GG470103@nvidia.com>
 <aLhg2Jli0KUe-CXC@kernel.org>
 <20250903170631.GK470103@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903170631.GK470103@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A2341C0006
X-Stat-Signature: f413an379qk96oxo6k9d61xsxo95mc43
X-Rspam-User: 
X-HE-Tag: 1756927510-976108
X-HE-Meta: U2FsdGVkX19CBTwpXZiwKAGS1KfTHgtG8DO70F9NLk+D8pdgxdHp9Kkqfdgk6NkOmjKuFCGsj28rBtyaTlNwunf6w/0oGepFxD0vztdRL7yKAUSb5k4v12FbtSJ9PUDdtVAYd7Tseuz4ataFgmbrdXxT/iWJZDcHkN31NsB7XBlOmSiY4gHV2cZW5w28WQVyMY+wsOO1Qim2NMMVjx7/WX+fuoNKqyZGjwqBvq8LR3duQMcBK0GHSTvBR597t11v00fTn4298ghMasvfS+0aPUBkh2mW2b46fhfbvGBRKoUNdWh0BVYrp0cTgofK7g2lArH93lxy4Zk6NSZALagwDbNHlbzZ4v7fJ1EiBtlHv2HpXg4cbq/4xrcuMU/rhKM9rlHlGDkvytS0i2o+CbuCX+P7mYXcLzRjWi+GF+1NkmdH8BzZjmRfckZjyDt3UgfGi8PeefLO6oezB7gzP+KZtXf+hlGdUSGPPhfjpCdpeE7X+g9n0AyFf/nFSix6aYmMccvl0Gob8r6Om9d+fouWyOs40wXKyimOWmpZ98YyfgpFRjyruTphdLXGOGo6C2QvOyjmVVJBbQ1/If82i4y4uXUEObqvUuACCoAIzl98BZTqndmVC092XoKnNQbqoXHrhh3bvhc1BwUxOQlmKh8xYTc0zNnIkTcld/Y0YfbtDUME8gEWKimOh96vGR6p16U3eVQi+IPmRnhMgnR74UCKJfwApiSN3JCfk9LDqdaV/LET9bnventvTKli+0Y6oA1kg5szmRtZCt77tLqaMbqPF+NHPsdSnLsHa9hkoj/Db2j9BwPz0JBSoI+FwprrSG8xsuNKMiOjsQ9im+UAp2pecaiXQw1rjAZQc+iLacxnI5olyGNDCEv2Juj4E7RDTeqC6AWSrTjLJpbF2TpzmHzHYbew8/boIsiE6eTPk2QbHQqSDqjs4+0ZvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 02:06:31PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 03, 2025 at 06:38:00PM +0300, Mike Rapoport wrote:
> > > Don't call kho_preserve_phy if you already have a page!
>  
> > Now seriously, by no means this is a folio, 
> 
> It really is. The entire bitmap thing is about preserving folios/page
> which are basically the same thing ATM. folio is the prefered type for
> what used to be compound pages.
 
> As Matthew moves ahead it will effectively become preserving
> memdescs. This may even start to happen this year..
> 
> Every memdesc has a type, so when ever the physical pages are restored
> KHO will need to recreate the struct page and page->memdesc with the
> correct values, including the memdesc type code and any memdesc
> allocation that Matthew plans.
> 
> Meaning everything should be struct page or folio based at this API
> level, and restore functions should be logically paired with the
> allocation functions that created the memory in the first place.
> 
> vmalloc() is calling alloc_pages_bulk_node_noprof() to allocate the
> memory, so the restore of that memory should also have a 'kho restore
> page' type of name that clearly refers back to the allocator it pairs
> with.

I'm actually all for having a single entry point
kho_{preserve,restore}_page() that will do

	if (folio)
		do_folio()
	else if (vmalloc)
		do_vmalloc()

etc.

It seems that our major disagreement is about using 'folio' vs 'page' in
the naming.

In my view calling everything 'folio' is a bad idea as we are moving fast
from Ottawa interpretation to New York interpretation of folio.

I'd rather stick to the good old 'page' and when the time comes we can
's/page/memdesc/g' supposing Matthew actually plans for it.

This way we won't need to handle the fallback from divorce of folio from
page. This indeed is less relevant to KHO, but there are a lot of
folio_alloc() in LUO and PCI patches that will have to be changed to a
different allocation apparently this year.

> In the more general case this should be setting the cgroup and
> charging it as well.

Yes, eventually :)

> > How do you suggest to preserve memblock?
> 
> Does the memory have a struct page? Then it should be a preserved
> folio list so you get back struct pages in the right state for what

page list you mean ;-)

> memblock is doing. Someday that will turn into some specific memdesc
> type and so on.

> If it doesn't have a struct page then it shouldn't be in the bitmaps
> at all.

There is a struct page for everything that's memblock_alloc()ed. And we can
do page list, but for large  physically contiguous allocation it does not
make sense. 

I'd rather replace kho_preserve_phys() with kho_preserve_memblock() and add
a restore counterpart to properly set the struct pages for it which we lack
now.

> Jason

-- 
Sincerely yours,
Mike.

