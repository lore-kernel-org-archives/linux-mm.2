Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7EAD26D9B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 21:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD606B0088; Fri,  9 Jan 2026 16:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45BCD6B0089; Fri,  9 Jan 2026 16:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D346B008A; Fri,  9 Jan 2026 16:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2001D6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:49:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD5B18CEE3
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:49:09 +0000 (UTC)
X-FDA: 84313766418.10.F2426B9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 51948120009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:49:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CIblYblt;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767995348; a=rsa-sha256;
	cv=none;
	b=yx02iGYVDHJNWF1Dp+3orqY9ceL7/J6t8FF1bq65CVTADv2uGDNxHLpkawO68SM4+XRmu+
	9Uf48MpyNJ8G8DKovlc5O0TWzoLbx583weWXegdVO1ts6FZ9ES967haX/EO4tFPFWbjHJ9
	ZGcWEb17PnvLIUF+3wgGaRclcFjK3x4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CIblYblt;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767995348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orAWW0c9GM9UfFj1bpBTGics8DndOWhf3L60HJQWvmU=;
	b=DRyHnVtAcgLopa9JtkuoW9mUdfYTlGmF3bPxY300liYjU1UY1ZahlLtf7uB+n2kaDz1pDw
	xjcPadcY/c4vjshLAoYIxPW4RJdljyFC66hIFXZ9Ryv+JlFNxtcKMerbUhGGMFz//jx9le
	9n0a0+shymrE0obaZra/6447OZoZFRk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=orAWW0c9GM9UfFj1bpBTGics8DndOWhf3L60HJQWvmU=; b=CIblYblt2QgPrKx3QV6je9i5NO
	b5D9A+fy3pKImVmulgWOInglXBy/bZ+pIiHIz2jHFd5YFQ+fikGiN+Ebi4kSv1olSUOb49gcwx63T
	ddfzoRqj/5wVX7Hxniu1P+CkJa+3A60OThU0xO0Bkubl32FVEl9jrdMebeUKAwVZBcxEhPzJ3E2nP
	OW5vKQx1mkaWU0c+13X3ju4UD8T4pRoV7EdhMolpqFfB6CzLvz1OswWlprXwekbvUKsy8aFavslul
	yMf/csPpYE8oxci/ITWIWs5gEhVzDS0rwDv6uz9mwcIMP8VvjEQI2t36t8ON+8vUOrlR5kQHJfp05
	mmY9OKQw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veKLm-0000000HO7U-26lC;
	Fri, 09 Jan 2026 21:48:54 +0000
Date: Fri, 9 Jan 2026 21:48:54 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Message-ID: <aWF3xg-72SV4tmLk@casper.infradead.org>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
 <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
 <glu3noshgeh7ktwwqofk7xcwkvhek2x3hrbdmyyo56gmctdx3t@adsfih557p7g>
 <2ace6fc2-6891-4d6c-98de-c027da03d516@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ace6fc2-6891-4d6c-98de-c027da03d516@kernel.org>
X-Stat-Signature: rd1gcp1zj1ozm3bt9jctgb5ce67y9qxr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51948120009
X-Rspam-User: 
X-HE-Tag: 1767995347-941551
X-HE-Meta: U2FsdGVkX194ezIGyuQi5J9kuWJtGKJjmdeSTtCOrw6dImb/r3FLMzwPXYOzzyQRLVM5+L29jLxHZdHkb9iUzEoF616OLV2MCqpAaxF2DvNRqzlZAF2a5nCMaWs41dMb89qB469Ey32NvOuZ8NG75l0yUQ4/bf8MVHEOuNSAmeBLks5h4TtS/aFaI/2SqUbTNwj1zkAdO8GgOBSxonmLzeEkQKnZ1gXGgz2Eo7do4E36SQlx2Lb/Rj3YOwK1ARJHiEZmxVewMtTFIerwAQH8ywU3RkXLmniCLoI9cjhygMWR+Q82dWuvgVa5VnTxIQkflRv74cRx8T4JQSWPtUeiQqcmA+waAlh4DL1UeBIqw8ha/hpmeeCghrJ1wt47i710B4jCULnpX8RJSJZYRwbiVetN+e1fg8jIL7S+Y3JTc5zePohOZ0d4XOPRk6W8VQVg55g6F2kgtyZRo1nlX/RLdy0/gxjZdNRHSoqzoeRkFYJLHX/huMjoFNaOWN1kAmb388Qx2PrFm7y4gyxvsonXGo4zvtmgj4VcE+fvHs2l8GSg45WLjtFQ/iLtq7DFoI2cjoCeXDexjWPbw05dIxDhkyJznxsww5vtS7dIwLecRTgNKaSzEf72cxUngiMjywaU1HgLygU4u/KfJCqoM/VBBaUf5qXcI3tW4AjY4xWhQX8QEJF5F69In0ASIIKQkZkmx2WcsDAvcQUeytnPyWNjlMsLVh3YkaMcaXgiTGM6S2CXD9WL2ZA92Cqj6AxAMKc5nzKwtQYPsmVfE2e7VOsQLnS9ofPhmFPD5QMR6sj4iw/F3pbdRBAtHPywDhNEkYfdnLzPtvDnNIHV0zkdmMDAwa8XxemPsLpe0Vo6b+p6GJssWYttByXYd5IHnLZp1wvf0qt+niz3z6fjQzI421gvAi7+R77ClamGOUMpqqGE03LPqjJ79+KCqK9rWdWviBaXYAK2y5FaeMsN7oyXj1Q
 AZPnBOut
 +E1dMpZKBBwFoqdq0+LUAzd23oNkk48poQOs+UN+shwo2Ns0oqPbNIH14DoUhcqJwXaRlYTTB31HT5Loqh8DXcCD3k26UakPkxv8vZQD8YbyRMJ3z1vHmd8GVf7WGyDyzwT/HbKIMtdJtM7BfaoFX+R6mTpOg0sCgG+tnMsP/yvVhU2n2kIpipoBCOGliARiF4u1vqsTkA5Vpkt5rLcKoUL1nNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 12:08:35AM +0100, David Hildenbrand (Red Hat) wrote:
> > > "Then we make page->compound_head point to the dynamically allocated memdesc
> > > rather than the first page. Then we can transition to the above layout. "
> > 
> 
> Sorry for the late reply, it's been a bit crazy over here.
> 
> > I am not sure I understand how it is going to work.
> > 
> 
> I don't recall all the details that Willy shared over the last years while
> working on folios, but I will try to answer as best as I can from the top of
> my head. (there are plenty of resources on the list, on the web, in his
> presentations etc.).
> 
> > 32-byte layout indicates that flags will stay in the statically
> > allocated part, but most (all?) flags are in the head page and we would
> > need a way to redirect from tail to head in the statically allocated
> > pages.
> 
> When working with folios we will never go through the head page flags.
> That's why Willy has incrementally converted most folio code that worked on
> pages to work on folios.

A little more detail here:

 - Zone/Node/Section stay in page->flags and are replicated to
   folio->flags
 - HWPoison stays in page->flags
 - Reserved stays in page->flags
 - AnonExclusive stays in page->flags
 - Writeback/Referenced/Uptodate/Dirty/LRU/Active/Workingset/Owner1/
   Owner2/Reclaim/Swapbacked/Unevictable/Dropbehind/MLocked/Young/Idle
   all exist only in folio->flags
 - Head/Private/Private2 all go away
 - Locked & Waiters are ... complicated.  I'll elaborate if there's
   demand.
 - I haven't put any effort into analyzing the Xen flags.
 - HasHWPoisoned/LargeRmappable/PartiallyMapped all move to folio->flags

> When the program was called "2025" I considered it very ambitious :) Now I
> consider it ambitious. I think Willy already shared early versions of the
> "struct slab" split and the "struct ptdesc" split recently on the list.

ptdesc, yes.  Slab is still in progress.

> For quite some time there will be a magical config option that will switch
> between both layouts. I'd assume that things will get more complicated if we
> suddenly have a "compound_head/folio" pointer and a "compound_info" pointer
> at the same time.

What I'm hoping to get to is a point where calling compound_head() on
a page which is part of a folio is a BUG.  You should only be calling
page_folio() on a page which is part of a folio -- because there's nothing
useful to find in the head page.  So compound_head (or compound_info) can
share space with page->memdesc.  For now I've actually put page->memdesc
adjacent to page->compound_head, for no reason that I can recall.

I had thought that calling page_folio() on a page that's not part of
a folio would also be a BUG(), but now I think it's better to quietly
return NULL.  That's based on my experience working with slab and ptdesc.


