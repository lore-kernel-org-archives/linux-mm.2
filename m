Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB9ACA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 21:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D48286B0007; Tue,  2 Sep 2025 17:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8486B0008; Tue,  2 Sep 2025 17:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35996B000C; Tue,  2 Sep 2025 17:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B62136B0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:06:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60AC8B9150
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:06:09 +0000 (UTC)
X-FDA: 83845542858.07.0C27DF3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 50C50100013
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:06:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ohQI5fUq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756847167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0fTlNWPnWfIKHQpQZYqwfXNFzo21NWXYtTUdgvaIw0=;
	b=T5QyQH+Tw4ysvAy7S/uJRhIuVPlVRbEJhmrJ+pVsnRpeyhk/aTShDRWos9YyRtIQT59KzQ
	fIzsjWPTIvCv04C6aAXyUuaY7K640h18KPvrS+JIBneH4ezIX2HHUxeiN4QL5Pxw4mzd4l
	y68GsDua51FGln6ifUvrSDY5ypsCKSw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ohQI5fUq;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756847167; a=rsa-sha256;
	cv=none;
	b=CFBJlKoEhTLObUJ9M/nnCAveGQdxfVCVS3f6h3e+w2dVzKCEVMwvmF3S6stjrd8/5WZ2ge
	zQqBGUBxXLQFQk6wtlJzYPbKIuyaB1ov32Uf0WHOwdWPSnQmrD5ha4P1h3DkNmnjXLwQUQ
	fvlHEr2Me4gSCuuslpZWOxodCTMe2xM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i0fTlNWPnWfIKHQpQZYqwfXNFzo21NWXYtTUdgvaIw0=; b=ohQI5fUqCOtFQ7aqju/Y8OOJnz
	dPgaQCSJ+C3vOypKaWkl3TTFNWSHKMSeXVmhdSCXlAG6RwNVjqcu/VF2qzKoQepTXaseOpmwuJ8Or
	784JXyGfdIyrVy4qUU1k816zixjK2dGGbay4Mv+ksoNFlDgpCM9u61t8jZ8kUnD29k+Schlcu+bWu
	EE7/rjl3kdDnD8JtpAk+17ofJYTTg1/ueRy85XHNV2hLItyVZxHQBYXftTH9IHrqZOUig7vQ9lobd
	3Ma0K2oZNtjUXGn/WSx4qVxMVitsWOzp+2wLD9J6SjfI04cBX4JD6VSP0i9GuAJTEQvKbJ6fEfTiY
	Nar7zuQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utYCb-0000000BW2X-1cbZ;
	Tue, 02 Sep 2025 21:06:05 +0000
Date: Tue, 2 Sep 2025 22:06:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Where to put page->memdesc initially
Message-ID: <aLdcPeb8zrfDwd2p@casper.infradead.org>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
X-Stat-Signature: hdyuiany8gd47j1efsgerrdabjrmxcjf
X-Rspam-User: 
X-Rspamd-Queue-Id: 50C50100013
X-Rspamd-Server: rspam05
X-HE-Tag: 1756847167-376775
X-HE-Meta: U2FsdGVkX1/xtPjASziXbvr8m8EfXvVYaJyLrSteeQfBiPUo6BGNBbIT/lcyAK+9j8X9xpDE2d/1NMxlbZP+OuZDXWtce1lwEB81duNoygRW+lOfwHg1x8vxKMCvovgcqYFBmFSthXHQkLY3bOPlB0jBaiP1SRBIdfQk0H9N6AtYsTP83hrEa4lbKHcZ51B7UR+6JatXliW46vgjV6hDSy84Q8m+z/ShOM2c/igt9kyDfLCJj4+k0hltQnl2MHLyc5CaNL+CZOBSVAaMV0SWZP1BBhpeQVdouFFJC7xKaUXvFhHShma5rRZNdysiiao0n+IQzs8DcKXRSemHIm/hQqJ6JSAitDavo+IAr6Zc7bfE3m5rCrlDtWTm7P7J65Ed1tiGkpnKtyFmF3k6ra8v0OsCum62pJSYFiSmHWxkbVi3EWTHwKgDrnBRk+o1CzVqEYWWk/AYZm7wHZcFljz+LlISfYZCLwX8qvghVe3DO1OGd5Htt4aGNiiAvBiQUtGPqOwCvIX0BBiCzvWQ5wXLzhpqW0y96/HNb7tuL2h5AaZ5gg7/CqhxozUkYgbE1CJrmIi0zGxdMqNARj+FTt6sFb3pJkktHgD4BS0XXFSu83J710j1nJUhncJ5v12uToYxDU2aC1IQ0CU2FbfC7Omr7UaXQYWNYlSb6CtnEvB9wVmFX62/W4GQSj7e02O9H9MWhj99/IEtaWriYTyVaOoeZGP7XA1Dg9B+RRqGu/Bfk4M2BRMjCkpcKf/9A4RXLMjw3Ncqo3iK5VRmBP+ert8AzyXJxrinlABrHuYWzMlcP45xgTc424rVmdM0zsLaYpxjUhC5EHMn1lUldPI9ezKb43ID3jGbve3n0tKCIU5SL8MQLLhGVyAMZ58yN4JftMrMaPMvNv6Ig8UgJgAyiW2aVMTPy9jkUtte4wM3CKG/l29m0IoKKpozFYTIzQZFdzTehUpd1tFdyj5scWJzybV
 ddrn9JUg
 p3nVDEMv0wjC68qxtbR5QIOfnupt+Gcni8AclEW2D4ORvz+uNk/gnVyfwoKsRhZc/18JXMLutESE2wOXqgdi/eewHO1AB6+UUuTmstoD96O8M2uhdJtuLnM7786AtaATrvv/Jeh+ZxoIZzYT0a/Ci3mAWetx8Kh6EubSkxmGKsXmtsUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 10:09:49PM +0200, David Hildenbrand wrote:
> Would you want to move the page type already from the mapcount into the
> memdesc? That sounds challenging, because for any typed folios we would
> not be allowed to reuse a field we want to use for the memdesc. IIRC<
> hugetlb pretty much uses all of it.

That would definitely be part of the same series.  But possibly not the
same patch.  I think the series has to include separate allocations for
slab, folio and whichever other memdescs won't fit into 32 bytes.

> The easy way out for now would be making this page type specific: Only
> selected typed pages will store the memdesc (here: slab pointer) e.g.,
> in the old page->mapping place.
> 
> So PageSlab() still checks the existing page type, put page_slab() would
> simply lookup the pointer in the old page->mapping place.

I *think* that's roughly the same as what I'm proposing, except
that we already have a meaning for "the bottom two bits of
folio->mapping are set", so there's potential confusion for
folio_test_anon() & friends.
> 
> > There are a few overlapping uses of these bits in struct page, so if we do
> > nothing we may get confused.  We can deal with mlock_count and order (for
> > pcp_llist).  But the biggest problem is the first tail page of a folio.
> > Depending on word size and endianness, there are four different atomic_t
> > fields that overlap with page->lru.prev.  That can't be solved by using
> > a different field in struct page; the first tail page is jam-packed.
> > 
> > So, page_slab() will first load page->memdesc (the same bits as
> > page->lru.prev), check the bottom four bits match the slab memdesc, and
> > also check page->page_type matches PGTY_slab.  I don't like this a lot,
> > because it's two loads rather than one atomic load, but it should only
> > be present for one commit.
> 
> As a first step, I would really not use the bottom four bits. Why
> perform two type checks initially?

I'm concerned by things like compaction that are executing
asynchronously and might see a page mid-transition.  Or something like
GUP or lockless pagecache lookup that might get a stale page pointer.
It's a lot easier to reason about if we can do a single load and treat
that as a source of truth (with the appropriate reloads to make sure
nothing changed after we got a refcount).  Doing two loads makes
my brain hurt a bit because it introduces more possibilities for
inconsistency.  I'll need to write it up pretty carefully (which
annoys me because we're going to need it for a single or very
few commits ...)

