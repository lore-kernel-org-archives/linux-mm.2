Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9766DCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033BD8E0002; Thu,  4 Sep 2025 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24918E0001; Thu,  4 Sep 2025 07:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62E88E0002; Thu,  4 Sep 2025 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D79E58E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:55:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AFA083E48
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:55:35 +0000 (UTC)
X-FDA: 83851413030.13.2542F8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D078E1C0005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:55:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a6mjvK+4;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756986933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgcDdqOqUi/8D0xc5CjYvzb5Vi4Dqd8Gi3YciLv8nXI=;
	b=KzWruAGsyZGKFCg5DFXHLLdwdiDn5P/zcseMs9GBVv7ueMb4Xst9Nr5hOcrMAPSCtuXtil
	TCcvP23NbI8G+plDAXxoYTBl3bFVahXg6cVWA1AEF2QjsOUHasuGMyRX2KdXlKUTWIwaVP
	rU8f1o3KlW8noU1KDADF3xTCnYbNRBQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a6mjvK+4;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756986933; a=rsa-sha256;
	cv=none;
	b=y4dfcUTtbPp5kv6jH2F+5vyG1Gk2EY6hRNjrfAgMU9gHHZ3SmGIg00f+CB8BXc5KX3I4UZ
	sfzfQJiOK5g66+GwJQZdTcgmBKXTGg83p1iShny/IkYXzW7jemP7S91kHZec6VxjVy1hgJ
	8vlpPagLLCRKzEDX7kR73MjEG0pr7Cg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 235AD60212;
	Thu,  4 Sep 2025 11:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A6DC4CEF0;
	Thu,  4 Sep 2025 11:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756986932;
	bh=L9cH6bNwYJRlk6FzxhgqsLMYSpGTEmwCEBwi3x9KT/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a6mjvK+469qhzIL3ZY7OLkZG43jt44zcrcpC0SLg+x90jVrWCN4wHiXo7MpMy7adT
	 rFtCuOtKzPv3SCl+1a8iA9VpOzMBrPDZJJ1d9Vgu/n0MZO+y/Z28JeLMsddhB0cWea
	 RleDBDLnf3OLJlwClV84wBgTsGkZkS81LNVCy38Ye4/7nOnd4gE/t0eSwIeO5ttp3B
	 H+owTOKY2NwyL6jQxgmnOxrwFpmn6Ou6pQwbhAXkR9KUmS6EjJSZ5jPtIfC8BuANMa
	 8R3iX32k2EwaEj3QR0QO5ZPrGtPX/z8LW7tiqgfBgjIhl4xmzLimlzEm30SP6ANOKo
	 kaDVgda/8+bIA==
Date: Thu, 4 Sep 2025 14:55:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org, virtualization@lists.linux.dev,
	Justin Sanders <justin@coraid.com>, Jens Axboe <axboe@kernel.dk>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3 0/7] Cleanup free_pages() misuse
Message-ID: <aLl-Kd4nmgSEr8WV@kernel.org>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903185921.1785167-1-vishal.moola@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D078E1C0005
X-Stat-Signature: 45o85ixzrz7dt7nxzej38n141b69ynay
X-Rspam-User: 
X-HE-Tag: 1756986933-289002
X-HE-Meta: U2FsdGVkX181QMEo+iSq1Oyv+Dyibz2jVFy4TAdfgYDEBf6gHw0663AZYk1ub2EOALS3/opsnhDnV6EUlJ2tIZ3w8bpINatSm48HV0cBow5RNpKALlAUcnKQb0H20Hgq9ajMw0bNGpDZVhTG/9qWa79yblCzTR6LbmK7KFritLXWWgn2l8byHET+6MNQXCYLZOgTxBdYwNL3R6/K35oq/NJIVeIwICBvZvxuf5fD/Y3h/xVvGLqhsx0SVeHviNbmCi5pWDpyGDr8emVnIm6j/ubMQ61GXdjbEVW8OwaO3VfEH6T2BhM4KaLGE7XW3rq7eC/h0LJ+ntlHYKDTenkgrsgKx+OJLLbMxPggeOa8lqPxX77/NFAuU/SEL3yhuNu7zxW3Z8HrqZC80R2+NQ0vlJ9r1t61n0wGxnlvpkgCmIGjxf3acjfX52tucXorgRjw+BlP3Pqlo4HTY4nCVH9WGlZAO/Dn86e2Y3rvsx3MvN5+e+lKL5VA6LowE03h6s6jVTB5Ou0657mX0yMe1KS2+quaDwsypiQJZvGKk+Z5Xzpx0CX6I5iNYqJ65qRvs1VN0dkMayM+p1syQZJBP63PqcBWxkWJHUL5F8KJHcy4oO7NphZvce+OE4OJ8OZco6gUJnW+rLqovS+gANN+Wsinc/DzZ7YhfEuDQ9lrga5U8QupfLVr5uf0DZKNG2Gw0liprDrwLFihSsRahXDrnUQvLEkDtSa+PZs7KLfzEa8c5+TgC7j1/xg7r8O9zdubHp2pFTCzwrTM3CTHrFPtyv78NDsTxE9CwY1JehJpiYREzsySs9OlbyvUuRR7byymyHWWcEVq8+1hlGQ3mgQZg4XMP9v9Xy8MQQFoP/HueQoIKDSKYHnQEy8P72a7RQnaUaIBl2epiXO4ECK0pVHAn1qwuN6t/fAl6B6j3LGaUX92hU52RBR+Ana6NQVtWu+sBXYYxA7JU9v5qL0iHRK7Djo
 feifEh47
 qr/zHlsG1Jbj+7lu0KGRudUsALQ7EqeuAJ6+44suHCL9WcZc02QxYhrGPY0ZY9rACbJBlvzw3RMOsvta1wzxi3Y0h0Ej6GZKt45EFhknL93+JAnAHzLwfMjpIAarEeUviq/QJyP/TIxGA/OD+3Ghl+v/B3K2Ws3HdbNCNv7TJs4+LUi7swWu6B3n95RX3K8IYD0RnW1CkSTdekpwGwDSgfRCu17GEm7VcEykh905dDBTCfgY2JpQ5ESQll/pvlcVBAlqGub+1/c/h9MgZmkC/b+S5bHVzOoV8nJc3q29oBbllNpEwTP07H7BJNOXw6p+H6KPIj7FMWYQXFc8IBGmjrS/p1CS9qPjysiIJ21DAjg7Png157k5UJDwN5Z0Uvmz83VcLS+nZz/NRm4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:59:14AM -0700, Vishal Moola (Oracle) wrote:
> free_pages() is supposed to be called when we only have a virtual address.
> __free_pages() is supposed to be called when we have a page.
> 
> There are a number of callers that use page_address() to get a page's
> virtual address then call free_pages() on it when they should just call
> __free_pages() directly.
> 
> Add kernel-docs for free_pages() to help callers better understand which
> function they should be calling, and replace the obvious cases of
> misuse.
> 
> Vishal Moola (Oracle) (7):
>   mm/page_alloc: Add kernel-docs for free_pages()
>   aoe: Stop calling page_address() in free_page()
>   x86: Stop calling page_address() in free_pages()
>   riscv: Stop calling page_address() in free_pages()
>   powerpc: Stop calling page_address() in free_pages()
>   arm64: Stop calling page_address() in free_pages()
>   virtio_balloon: Stop calling page_address() in free_pages()

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  arch/arm64/mm/mmu.c                      | 2 +-
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
>  arch/riscv/mm/init.c                     | 4 ++--
>  arch/x86/mm/init_64.c                    | 2 +-
>  arch/x86/platform/efi/memmap.c           | 2 +-
>  drivers/block/aoe/aoecmd.c               | 2 +-
>  drivers/virtio/virtio_balloon.c          | 8 +++-----
>  mm/page_alloc.c                          | 9 +++++++++
>  8 files changed, 19 insertions(+), 12 deletions(-)
> 
> -- 
> 2.51.0
> 
> 

-- 
Sincerely yours,
Mike.

