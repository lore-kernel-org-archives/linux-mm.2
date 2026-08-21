Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C215C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 20:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE126B009B; Fri, 21 Aug 2026 16:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E556B009D; Fri, 21 Aug 2026 16:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBB66B009F; Fri, 21 Aug 2026 16:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 274BB6B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:11:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DB6FA0188
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:11:41 +0000 (UTC)
X-FDA: 85126372002.14.6E14E43
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 00A0D1C0006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:11:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mo0H6g+6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787343100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itcmWornqRB5Pfj7Z0+n8F50D+2rMgNAaXLyWanZaJ8=;
	b=vPavAjb3bE8EqpqmZdtOqBqj3sV2yW4UdQAflzBqgoKNJWGxO5dJMh5dKwke41bpg49/BE
	ojJ+fCN184eERg7Mo0obhlKYjDdNjL2eGIFkELAxX81qoUApvDiwM40wn1foQCt0e/PfNP
	sZtTI4Q1dIGUbI71q3ORsGW0zc/8BtM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mo0H6g+6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787343100;
	b=kM1API58G6znxnvVPkHpMrvmP2B9BBf5sedfN9C/QrpDKyr95DhzTN6hVBPh3rCrJDZEHD
	GQ4XwgV6tsBszC6Y5MoFAwLREIqX2wL78DmHfCbg01T8AqX+uVuPatEmD6iaZSxup8aAbB
	yz40u2y/o9YV5xEg2RUUTsSv6KdKCfg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=itcmWornqRB5Pfj7Z0+n8F50D+2rMgNAaXLyWanZaJ8=; b=mo0H6g+6b6Bl78t3+C+iN8pMoz
	kKRQ2JYDdDcNRLsu8lu9nhJ3nT3Kj8KCIEfPfGwV5wNiasISbb3SWWaFJzmO0TepAgNWJSKu0SWFn
	WHRqXPjzGqhFSh3uzg/pj0MC8cc2thrnZ+RAXi5qJQ4hukK1XVwRv9FKnEzdsxLFrhaMxSa6tQDZ2
	gXZXF2dwpqxdqnPxSIMFaTm+GH9oevzEE6VOgyXNyGXNPHDQ7mwemgw0YzQ5UyIZ5ua4c7oW6zvO0
	/QdBr1sJOdbbZyNlFk9FVYcrq/saa5GNbFIrUg1Co5BAJ5dqwSzqZHyLDapi97SJH58BZe6dQmNCc
	bl7lNd+w==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxV6G-0000000E1LY-2wB6;
	Fri, 21 Aug 2026 19:40:25 +0000
Date: Fri, 21 Aug 2026 15:40:23 -0400
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org
Subject: Re: [PATCH v3 00/19] maple_tree: lock checking and clean ups
Message-ID: <bbvvwdn6r2lliisrsl5veniwjoqkfqgarixjphucrahcwhsgj6@ng3kkcoiyxkv>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
X-Rspam-User: 
X-Stat-Signature: gcdm77ne7y8zdm8irm41yf5ea4pi5kwc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00A0D1C0006
X-HE-Tag: 1787343099-953109
X-HE-Meta: U2FsdGVkX1+Ava2QPFvImRR+hKJzWRFO9p8EnyMPPyJq1Pfb8qqPHCUhQTm5ZpRvukVv1Qo3GY5LFCljrsHF58XAjDDn7z9g4KLatzvCjNCWJ+uQe4h+WUVlhUf5jPlAYKhXPszHRz81St/bjQwe6Tk7kp992kdiGqgfpxWTVhafZkrwKgdAZkdL3MZOklBz7efd6hmchdyw4MiBgdhaiDDdZLtiuZLcKK8SKC6zgTDxwjj7NnRMStTMwqntiOFziZffcCktRjJtMCXCLmH2KvrUDiMjg6G0ya8LEWLfwuagB2AVVbYjG7yuYQHyfZyaBthr3jNO3YroguGVl8U9pI0bucMR93BPO8CRxEZh3gpGv2GMerIKv2E4djH0j0PxE2+NNAmE/mpWK+WvPAKCKWdghHvhpTbexjvVFpiagVnsmB9ZVN0JJdn6CBtbIzvyUHLfokrCG/ebLJW83/2rrJbwTgW8I05wAM90GcA17vzaZnHbSocm4qE4oyi4+uw2Nf8Ez+tezsbG6dUrfibIZllFHjnJjTaKaLfQ8pYOLiaRb17aD8gEo3mwv1YSKymktTbA6Ab2njKf+mxBToOcwBpqBC25gpeJIvu8bd1DM2hqWqLg6VbJitfMFbBR0M+2djURiCWQfBPmvzaUaE0kDQ1cOkzSqcMF9RySbR6W41VVRXrIiDmZx3QvBwSKNebrxzYLuhamV6h0TnHlFS+ut7c/v5JT7jaeH7E4eLRIoeoORXTrdYrjnKm7qHvwkA/gIUNMuNuPByvY8SGukmskZGFrrouie0NS3S6+n2IdjQbDXkY1uTe3IEfbWaXNv3RK3cvXmZB6rVxFL4ObjIPwc8FH1GbybXt/0JcF/kvge2Zn9VaBsugpw5xkGh7FIhrAW/ffuBu3woPHrDcJEXMZxesqAU7tUjHT6lGQYPtpN8r3OXm8MoqOhRG+V9P0Q9HsVYyZuSHLxBow3fXxW1p
 NjYknM1S
 4/89ep37QILCV31Q6PZZYxayL4HjyUw9nhSkmVUQH553PvpifxrJRAPnIaJGQJ+A0r5nqNiNFDppYNgSlfmMltXlw8LhdGULbyn4zIUG0M8UjgK4RnC3AgiZsEBPH0tdARL931XhBT/xIa8dbtFA+XMkYeeWu2KZb0suJ8PvBnR8Pj5R+tllLVlmmIZa4mWxdXHivIA8ZUD6SbfpqTD3l8iu6bq28NL3nXqV7vRwK0dhdGiZECzj6ISU212HsxFMcGiy8e2YLRGCXz4hLuyYDvTnbdB+GaOlfaK46SypY60sm9+TRUkuOanUzM80tZNBNPMeWGSXe/qgW/tfc97k9GBc3SKrHnhdAbMfT9l68/fjwQjbwBh+oTKBoH+twhspJhAdJZ3ijSGDcWXOW4GSKTyttxEKMbChvZA/7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/21 03:26PM, Liam R. Howlett (Oracle) wrote:
> In this series:
> 1. Try to detect lock issues
>   A number of syzbot reports are incorrectly pointing to the mm exit as
>   a source of the locking error.  The first three patches attempt to
>   help users detect errors in their locking - but they still have to use
>   LOCKDEP.  I guess it's still down to hope and prayers.
> 
> 2. Documentation fixes
>   The documentation was lacking clarity, there are updates to try and
>   help the users, especially around the erase() cases.
> 
> 3. Two benign issues
>   The cyclic allocator may have a race, although no in-kernel user can
>   hit it.
>   The erase functions may cause allocation issues if used with the
>   incorrect locking type, but none are present in-tree.
> 
> 4. The erase gfp uses
>   mas_erase() and mtree_erase() do not take a gfp argument.  To improve
>   reliability of the erase, the first attempt to allocate will be
>   GFP_NOWAIT, followed by a retry (if necessary of GFP_KERNEL |
>   GFP_NOFAIL.  This will ensure the data is gone.  I've updated the
>   documentation to make it more clear as well.  mas_store() is not
>   addressed in the same way, but may need to be updated at a later date,
>   but that may require changing callers so it is out of scope here.
> 
> Beyond these goals there are some test fixes, some general speed-up
> patches targeting extra work and cycles, and dropping dead code.
> 
> v2: https://lore.kernel.org/all/20260630190843.3563858-1-liam@infradead.org/
> v1: https://lore.kernel.org/all/20260629144145.1572283-1-liam@infradead.org/
> 
> Changes since v2:
>  - Added a mas_nomem_nofail() function for mas_erase() - Thanks Jason,
>    Vlastimil, and Pedro.
>  - Dropped the WARN_ON() that was triggered by syzbot and questioned by
>    Andrew - Thanks Andrew (and the syzbot)

Sorry, I forgot Breno Leitao's help with the lockdep testing.  Thanks
Breno, I appreciate the testing and help with that (and for working on
debian)!

> 
> Liam R. Howlett (Oracle) (19):
>   maple_tree: Add rcu locking check when LOCKDEP is enabled
>   locking/lockdep: Add sequence counter to held_lock
>   maple_tree: Add write lock checking with lockdep sequence numbers
>   maple_tree: Documentation fix
>   maple_tree: Drop dead code from mas_extend_spanning_null()
>   maple_tree: Drop MAPLE_ALLOC_SLOTS
>   maple_tree: Clarify comments on mas_nomem()
>   maple_tree: Use prefetched value in mas_wr_store_type()
>   maple_tree: Optimise mas_wr_node_store() when not in rcu mode
>   maple_tree: micro optimisation of mas_wr_store_type()
>   maple_tree: Add bulk parent set helper
>   maple_tree: Catch race in mas_alloc_cyclic()
>   maple_tree: Document that erase may use GFP_KERNEL for allocations
>   maple_tree: Avoid mas_erase() and mtree_erase() failures
>   maple_tree: Document erase and allocations better
>   maple_tree: Change two GFP flags in tests
>   maple_tree: Fix argument name in header
>   maple_tree: Avoid extra gap calculation
>   maple_tree: Add helper mas_make_walkable()
> 
>  Documentation/core-api/maple_tree.rst |  23 +-
>  include/linux/lockdep.h               |   3 +
>  include/linux/lockdep_types.h         |   3 +-
>  include/linux/maple_tree.h            |  12 +-
>  include/linux/sched.h                 |   1 +
>  kernel/locking/lockdep.c              |  58 +++-
>  lib/maple_tree.c                      | 394 ++++++++++++++++++--------
>  tools/testing/radix-tree/maple.c      |   4 +-
>  8 files changed, 366 insertions(+), 132 deletions(-)
> 
> -- 
> 2.47.3
> 

