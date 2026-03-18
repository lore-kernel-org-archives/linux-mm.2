Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73AF5FD8779
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 00:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0486B00B6; Tue, 17 Mar 2026 20:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B78A6B00B7; Tue, 17 Mar 2026 20:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F49F6B00B8; Tue, 17 Mar 2026 20:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E36B6B00B6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:08:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED2D513ACE6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:08:27 +0000 (UTC)
X-FDA: 84557247054.20.B2B8EEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5B2FE40006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:08:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B14gM2Nx;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773792506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+xpX7UOEumMkTqUmEa6ChXvEP47aGRBEA4u/Yiw3Ao=;
	b=EnFxII7yQ6py3owpfLCM8KQLPO2ZwLVh1cmVRJ+OGxE4lJ0bkp1DhXGl4eAIIki7/lrunx
	x0KxQ3WZOFuV2qph8l1EEUWobYeU+9AeLfOWyrT/Me4yIzmoYE3enFA1nBTcU6M5UXcJms
	BPY09EpIC8dIf9l8pE2608RLjpRvOVw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B14gM2Nx;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773792506; a=rsa-sha256;
	cv=none;
	b=JMZmB3es174HIUCHvE4O17LYdSiG6a5+gYd+yAa2dOnVhSXgq5i6dDPYLPehyPT8BwyxwO
	h91bWfB5V7wJCPIUpRMlHnubeKytxjBEiJbQz8qTcmWoHyAcF47x7ILwxztzuKJA6FD1oh
	thyiYhQO4ROVg4iD1pqhIkGARARoq5w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D65A4458E;
	Wed, 18 Mar 2026 00:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA32C2BCB9;
	Wed, 18 Mar 2026 00:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773792505;
	bh=djFFpPUmzZrEXSAwoP2fU6PeHYBExiHv5Hefbxl+VZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B14gM2NxXwWc8lTi/b7HajGaiaT/Kpvsy4hzPBngZCRuYZGmqrtNkE74SQ8/y0XaV
	 ZWn2u6THSdbxgZtuKKYVyN2PK+bt1wqzTM0pxkv76Gcd72zrA4uwjuYlKSWVKFbTeA
	 R9T3Ks8VnKUWxU94ImqCIHmoNzTdV3U1NjFD1t6tSpnB0VT1KzOnHkQdyqbw8bR8dM
	 Mg6/5P3f9rAfK9/Sl4dbzC/PhS5767pQOy5dDvUjLoMtfSbk/RexC6+L7AKTL/pX6+
	 gQj4CJE9KR+UH9Dsg/FeYVoZgblq7NyzcYXSLXXvgpRpAAyCGtJC/f7xC9HjxAnvVH
	 5N11YHhEIkfgA==
From: SeongJae Park <sj@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Michal Clapinski <mclapinski@google.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Date: Tue, 17 Mar 2026 17:08:15 -0700
Message-ID: <20260318000817.130248-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <abniW3D8wbGQcB5T@fedora>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B2FE40006
X-Stat-Signature: fwiznous8cf1wcm7isya87yrmbcxsgg8
X-Rspam-User: 
X-HE-Tag: 1773792506-475186
X-HE-Meta: U2FsdGVkX1+LHFIdKBoS3Xt6hCPB+uLiHqLL27UIFRAiJZLenZ+jvOJseWgsSkJHc+OnwJlHCiLFj0UIMHGrvh87QUvD6MmEZLLwHg3Fq/E++GXIBz9Xjp4AKB2NCQjVM45cFXx6074j39sgpXO+uKmkwTzIIHzcX54ZXl3e/Xdrs/cI+X+QrtIbJJ5o65V/nrgv41hzw7HNr5T4NInnBqTvacgLZDAaRzWZJsoIo/eT9ZOdCbtVcAgLXI2xRG2mhmu+vzy6qtXnV7COXUiAgsD/bduvntIjBsPKTZ5j8cfdesJkMqjAx2Doo5KRHDePRtPsDc10ab7Oy4YeLilkoSuz5jRwtDh28v7FwSxXxP34/vwDw2bXGf4R/fjz9zP25VXlL8pVZ+5y+8eaU1JR9wKzBHy0rNq8oKPsIyN9zIYl9wLfvegNfXme0KLFt2dAYUzj8ZcBw76CfQBJHbv6vYoLxouBfcfsIt7HoabrsD4oR6tB/7yUCtQoVZcpQoYJqRydSSvMs4RZOcpXy96tUXyS2y2A0E5M5JyvDyTYy8qloWX+4R3AHLHV7b2iC6JIAlx+cm7LtRJxP46YscUO7p8tCC5Y9WaXJkWejxxM2grgKXT6/sAAYXMPDwTWFTbDikr+GAcdb/2IQQpyz0AQPZMYBI5Nc2B7RdSm/nuhTSlaO4cyDUFbnoVV2Maf3W6cU5lc/4rTMjIc/7toiEq3D0ag1ZFb0mS+q54lluGx1YD65wwJCvocNm/rp3HiqWuVWJS+We3FQfq8aXchePB2J+clOyihUwCYRCWIEBqVuQZwQ/hNtMOKQVx++d0WmhMFdPvvYSseKTBREEXyzodlxUVEmZyiKhIbww7A9oLqVorjr6os6NGZzEdqKx3yRK9cvNMX8b5076UrTUtGXxnVAm/Gcaiw2bWiBnv4AjNo113P34zKFO8+pAAYi7Nj4Xsq+0F+SHv+ArHOttd8O6b
 phA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 16:23:07 -0700 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:

> On Tue, Mar 17, 2026 at 03:15:33PM +0100, Michal Clapinski wrote:
> > Currently, if DEFERRED is enabled, kho_release_scratch will initialize
> > the struct pages and set migratetype of kho scratch. Unless the whole
> > scratch fit below first_deferred_pfn, some of that will be overwritten
> > either by deferred_init_pages or memmap_init_reserved_pages.
> > 
> > To fix it, I modified kho_release_scratch to only set the migratetype
> > on already initialized pages. Then, modified init_pageblock_migratetype
> > to set the migratetype to CMA if the page is located inside scratch.
> > 
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > ---
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index ee81f5c67c18..5ca078dde61d 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -55,6 +55,7 @@
> >  #include <linux/cacheinfo.h>
> >  #include <linux/pgalloc_tag.h>
> >  #include <linux/mmzone_lock.h>
> > +#include <linux/kexec_handover.h>
> >  #include <asm/div64.h>
> >  #include "internal.h"
> >  #include "shuffle.h"
> > @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct page *page,
> >  		     migratetype < MIGRATE_PCPTYPES))
> >  		migratetype = MIGRATE_UNMOVABLE;
> >  
> > +	/*
> > +	 * Mark KHO scratch as CMA so no unmovable allocations are made there.
> > +	 */
> > +	if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
> > +		migratetype = MIGRATE_CMA;
> > +
> >  	flags = migratetype;
> >  
> >  #ifdef CONFIG_MEMORY_ISOLATION
> 
> I've just tried to build the current mm-new tree. I'm getting this
> error:
> 
>  error: ‘MIGRATE_CMA’ undeclared (first use in this function); did you mean ‘MIGRATE_SYNC’?
>   557 |                 migratetype = MIGRATE_CMA;
>       |                               ^~~~~~~~~~~
>       |                               MIGRATE_SYNC
> 
> >From what I can tell, MIGRATE_CMA is only defined if CONFIG_CMA is
> enabled (for x86 defconfig its disabled).

I also got the same issue, and was about to report.  I added below workaround
patch to my test setup.  It is just a temporal quick fix for only my setup.
Michal or others may find a better fix.

=== >8 ===
From 9d89a12e1a17edd68750e97b0c8b1970e3adc648 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Tue, 17 Mar 2026 16:56:17 -0700
Subject: [PATCH] mm/page_alloc: enclose kho-specific code with
 CONFIG_KEXEC_HANDOVER

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5ca078dde61d6..ed4d585f46202 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -550,11 +550,13 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
+#ifdef CONFIG_KEXEC_HANDOVER
 	/*
 	 * Mark KHO scratch as CMA so no unmovable allocations are made there.
 	 */
 	if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
 		migratetype = MIGRATE_CMA;
+#endif
 
 	flags = migratetype;
 
-- 
2.47.3


