Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A72E63FEA
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 20:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5376B0089; Sat,  4 Apr 2026 16:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC4E6B008A; Sat,  4 Apr 2026 16:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3796B008C; Sat,  4 Apr 2026 16:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1856B0089
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:46:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E5EC8C5E1
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:46:55 +0000 (UTC)
X-FDA: 84622057590.18.D5F4368
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3902C000C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:46:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YQ4CNywE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775335613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsCkEyNl1lnp1czfTsQmmel5+1299ohDP+2LAG1kJTw=;
	b=BCEIFiYX10ZFonTBh1paTTZ2xmPvubP5PxyQA6J2kP4c/upsoXA9KRorn/LUDokCOuESkf
	uJMnGQGS950kVC7CBAzPMzkExRsb5S8lPaXxIz+sI+HSQLWPJ72OnxrkSvJKBdcjRDhhPM
	oEee8/UlLzR+z0ysR781qTjJoAXB9uU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775335613; a=rsa-sha256;
	cv=none;
	b=kcoQ+Wvceh8Bt7IJvMONMut7WxpYKAD9cKss8tuTsFv818dBAJVaql1zaLLx9u97QgC7mK
	0oSqj0820+VsCO6c5u73Jws4rhVvDVUUVhXROf4LK7yKqAj5e3FCziOwSk9gHysbpYLb/a
	2SqPuc6Gus+HGyL5uJsELBNl4eUXlSI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YQ4CNywE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hsCkEyNl1lnp1czfTsQmmel5+1299ohDP+2LAG1kJTw=; b=YQ4CNywEPe47yEr9rMZ/tGxSAf
	vBBrL5CLil1pMIQhxdubKnoQUdmUnLbS5NoUbezngMT/EaxGSGpOfBO7DCsgFWwVgDdrZcIYUbaqA
	FLqTDwGStPdCw3tiTutzFqbKKGUEpbPfuyBd3Xn7PVermVrMcgfEiXjddNQIY6xj+lq1CSIv89DaX
	GIiyGil5Lyvz3VmGEHgtbC1DuNsJJqTqLn5Tw0DPBl19vd6PZz0JiYoHj5RqCsiJaWWs1rbFBIXrO
	9FepSaecvQo5S1O5foXjHHOb9zOmfxt3EnvuGjNt8PYPl0xHNAo37D/HB2pS5kr4w2RkaXzwjV5E/
	AOyB2mtg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w97tJ-0000000GNZd-3hHD;
	Sat, 04 Apr 2026 20:46:49 +0000
Date: Sat, 4 Apr 2026 21:46:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org,
	alisaidi@amazon.com, blakgeof@amazon.com, abuehaze@amazon.de,
	dipietro.salvatore@gmail.com, stable@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <adF4uWa0pikq9Vea@casper.infradead.org>
References: <20260403193535.9970-1-dipiets@amazon.it>
 <20260403193535.9970-2-dipiets@amazon.it>
 <adCQTF1PQnlbNMO8@casper.infradead.org>
 <5x66n04a.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5x66n04a.ritesh.list@gmail.com>
X-Rspamd-Queue-Id: F3902C000C
X-Stat-Signature: 74n99s7hjdkkyue4yzjkdg8dzhodq3td
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775335612-890730
X-HE-Meta: U2FsdGVkX18+A2UxgNPZacA/4IJCAmpnr6vfychIPRn4CO6+7pdcO0ZEkew9zDgTc1+lGEhEcKnoR98hhXBHj1aM+SysHSA0LIF6zLeoTw58PAkn07LZdXEJdcDtOLb8/1JlC/0imHKvm/2SHrcbAAI6d38xJbkLNeMWv6tgGXruhNHE5S0VlOBSim1p7dr8lPq3sfgNMiR5cLGGwqt7jw7131i3IQ8oD1t/qaOrT8PlDSSwy5FJ//RqNmLSDt3bayNBPge2AV7D14lHXoFnPQ6PFhjL7/OYYRGbDlMLlI3AHTNwNgO+hws86D5ybhpiEtsnvbvKQJLEpIg6pQ52jMlCTIihgBVpydxtCnMlphBtm/+IVaRunNC0/mzIAw94y6C5eVvY6CdF5xvJhIOqMCRLSVsYJOBDgorkayiVnKPubmhaWl2+nBm5MG6oCKsK/sUCjhMLJfitJI5zx7autcdJnR6EsrrS5gyKx/ng7poV2AXeTB0FHgjrZ1QYvlRtw4giO6yZLSRZ+iHNyfD6lY5T6q0cxPuc+ihUEIE0ddysu5DTc7TEc84g4wg+LOT58QzyA49qQRflg8XZdzZkNNkj1lQMkFLJkoGeIaqHsU/1EFTqO6pEXN0N2v5Ki1li/g9ma5uT1mj0zo3oCzP0d67oY6cUYOjt1/YFhHh74adjS8JSoidc/L9I3TJPaPHNLWeFxjVNH8uFN8mxsDnqZMLeGVjCbnzMKooiJ/O5BjsCuDzBRICd3rOkd5L2t8RNohCEXcOMPK7Juvl/qoqmT3nPw94aTt+iS5AC8xZdQS2G+WQVduHd0Z45JSffqd+CxlC7z+UyOcRSiqkfIrTPPlWGvsFCWp1vJF9NN9FHdU8EcymRcEQiY44s7hmEK7JgbUoDHhXE+zsXT+dJm9NiYBsxNIG7W5q+wMasblth7SxEEtcv9R1ybTvNGTLedbMZjP9x2oQt4ISuD+aOvUN
 qoiBAPX9
 T0kjJv12Z7JyvPH304flsZodwtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 04, 2026 at 10:17:33PM +0530, Ritesh Harjani wrote:
> Matthew Wilcox <willy@infradead.org> writes:
> 
> > On Fri, Apr 03, 2026 at 07:35:34PM +0000, Salvatore Dipietro wrote:
> >> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> >> introduced high-order folio allocations in the buffered write
> >> path. When memory is fragmented, each failed allocation triggers
> >> compaction and drain_all_pages() via __alloc_pages_slowpath(),
> >> causing a 0.75x throughput drop on pgbench (simple-update) with 
> >> 1024 clients on a 96-vCPU arm64 system.
> >> 
> >> Strip __GFP_DIRECT_RECLAIM from folio allocations in
> >> iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
> >> making them purely opportunistic.
> >
> > If you look at __filemap_get_folio_mpol(), that's kind of being tried
> > already:
> >
> >                         if (order > min_order)
> >                                 alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
> >
> >  * %__GFP_NORETRY: The VM implementation will try only very lightweight
> >  * memory direct reclaim to get some memory under memory pressure (thus
> >  * it can sleep). It will avoid disruptive actions like OOM killer. The
> >  * caller must handle the failure which is quite likely to happen under
> >  * heavy memory pressure. The flag is suitable when failure can easily be
> >  * handled at small cost, such as reduced throughput.
> >
> > which, from the description, seemed like the right approach.  So either
> > the description or the implementation should be updated, I suppose?
> >
> > Now, what happens if you change those two lines to:
> >
> > 			if (order > min_order) {
> > 				alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> > 				alloc_gfp |= __GFP_NOWARN;
> > 			}
> 
> Hi Matthew,
> 
> Shouldn't we try this instead? This would still allows us to keep
> __GFP_NORETRY and hence light weight direct reclaim/compaction for
> atleast the non-costly order allocations, right?
> 
>  			if (order > min_order) {
> 				alloc_gfp |= __GFP_NOWARN;
> 				if (order > PAGE_ALLOC_COSTLY_ORDER)
> 					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> 				else
> 					alloc_gfp |= __GFP_NORETRY;
> 			}

Uhh ... maybe?  I'd want someone more familiar with the page allocator
than I am to say whether that's the right approach.  If it is, that
seems too complex, and maybe we need a better approach to the page
allocator flags.

