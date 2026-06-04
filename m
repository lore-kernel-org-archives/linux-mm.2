Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0692CD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8066B0005; Thu,  4 Jun 2026 01:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBFAF6B0088; Thu,  4 Jun 2026 01:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC3D6B008A; Thu,  4 Jun 2026 01:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B14DB6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:44:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5516840598
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:44:30 +0000 (UTC)
X-FDA: 84841140300.27.852A5D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C1EB014000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:44:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtPfhMok;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780551868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9U2E5wM9GwBXet0D5NfI+XdIVHV58zoDfgA5pHkk0Q=;
	b=t8dw1AY3LnzpuT7g2p7YRcFSp9n+bFqKb4zYp0MKqN9MZo22ZlhUOw3s847S1pAzlwsWrD
	ZlsWT+VNCZveeshJKp8iU1oWAPvBkxL5kXFcJQAIaPsHlYcLu/CJbPyQdjhCcoFySF9J0+
	D6YwEtDwgp15hp6GxP88DMaCZk0DbeQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780551868;
	b=5zy91moNOR2ckfzmHs7464pMKirJ2dG/DKOg/fNUTe6XW5+wuNzcUJBSpYO1jGJHJHAhT2
	rXRd0ysTvD5a/YYxZhZvV8K6pL/zRN1jP3NAk5YyE4mXhDR0OPvK0fo/xHCwolT/QcCLtK
	OyOENnaa54b1r0RzRBEV7K66vuG6TyU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtPfhMok;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 554AD601DD;
	Thu,  4 Jun 2026 05:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C211F00893;
	Thu,  4 Jun 2026 05:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780551868;
	bh=i9U2E5wM9GwBXet0D5NfI+XdIVHV58zoDfgA5pHkk0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FtPfhMok/Sq6q/EWpl0HkfZHEXB93SkrfDQ1avxGAUV0U6pC/V8iyBvjtTtkts5gq
	 d6vlMQSw4o8T3gbCW4X22yPx9/vz5b82hMCVFd1HYtcPdQyIciO3mIbCIcZc1wrmma
	 pN6gbeazjyTVMZPMXWpbMHaC0tgciwvZA+RdwFPtQuPcaS9v/lin5GSukXB4rXlAfq
	 Uah0e5RmyQV53tamwmMAV28lqbVKPQuwSxe2uLqoeZP0IEvSMZkbvjcrX0X8P4nvW/
	 aAohKKtprbmaxyiWh6xqDjRdNXm2yaFDtq2Q0KVYJ34jueUE/x8hwlvBWu738nzBWy
	 g1UVQim2kTCQg==
Date: Thu, 4 Jun 2026 08:44:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memblock: Introduce memblock_alloc_node_or_panic()
 helper
Message-ID: <aiEQscLI2LkNSj2v@kernel.org>
References: <20260604034139.2827148-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604034139.2827148-1-zhen.ni@easystack.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1EB014000D
X-Stat-Signature: 7tic7t4g78c3qsga6zcknbyms3ueqk5s
X-HE-Tag: 1780551868-738000
X-HE-Meta: U2FsdGVkX1+b/TlwYS+suWIDm3RbkQP6U6Z/tMZDNMAIconZDXYnRbqDT38ClrxopaYFYim8akGb/wBj+4Oqy+a8dnsUHaV6AmB+FnXgLo7uwn5YccOQtrsOXXmJnze/JlSyB62cIIIITeLLyQ0EWRnmQ+rVw5BcA5csHB90FhzeShJ632Rvrb8FufrsdSChUXnwdHaqHO81mW+IOOxrE2lbLLmA/JZQY3qdl+Kz0PEXN7N5DGiwPQSsYh7XUL3POl8nS/bGX1YRw4MKsLEPhZpkmgFFqxDZKbo+zvWmjLzO9l+Vg/B1GXd4TbBJLDJjtInmPDc+zse9svBOQh4KJ3VFzYlJY7HLX1A0kseXJeqqYzkSdTgjHn9h4rR41VMq6oQp6cBHSZUCxF73PMhic23vuGg2iDPnB54QpB+4m2GE4WWo3ZtDtSlet4h0BuIKLMkO5sjRnk2OtBK8uYeWoDLs+z4uLFVph7qQQwWXujPgpGk6VOvdTth9im9ehsazTQzBkN6Uet/8tBhV3qz17l8FowfVMS6QCQkoPEg3sNPkyb2O30DKvkS94Dz9rKLdHMftAUL5QuOD3t8jMjXAMb//FqUFShEW5JmPdmGCsA2DClKvvCqRUniHtwzkc1tKOwKIeNWnHZLcgr5exzLsEfNMs/nT5z4GDXcu7eMvBs1M3LEzHn0XqMByMPF9K1z2NGEYjl/+ZbCHAAas6MhvubE/tIfMWW4My0i5KkwMR1oXIqPgxFyu7uas4xK5l1LT2FmZKQBBP6Ub3F+I45FWLXLEOu04MJAm4JKmWbqLZPuF7Upd1s804GHlbGuE415IODRWmZv5a9bGbX3mxIONApVQUMn4Y9uHtAPxrdmESoU67p2KikJt0pr6tTUXK4qOJcxACWCV+Z7W4pk5Zy0zpE4pLLQzTJtyA9KfwBJBYRNSAr9USWPFQjBm6Pc0CNdTk5sv3w0zo39gQ1bATAt
 waXhEWik
 mrI75MeME6MXcqMoQ4yTMLyE6ed/JOkeY2ZxIFzhkDU3GE3Fu5/AVO/uRzdXw1nW+HkfoXcBLwZ8AB3UkSENt90xAKSZAzt3+4aDIuAzYMRLi8B0dBu8PC6HqUSAad7cW1vgG4BruBcfTEsMCkRTy/FUj/7FWMlQ/JnGGAVObB7r8dkeGxELW55r/tKYgp5QtjTmgQO/SjFBoPu/oIyi/njoFvNjpN0S5FDMIGz3W1dG4VYpxJJulnl+EOgHdcfYcJeLYzDLmG7fpgzfMQ/Cc3Cp6Mg/xa521WaiFrzjYIDicrGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 11:41:39AM +0800, Zhen Ni wrote:
> During early boot, several subsystems allocate memory from specific
> NUMA nodes using memblock_alloc_node(). When allocation fails, the
> typical requirement is to panic immediately.
> 
> Introduce memblock_alloc_node_or_panic() to automatically panic on
> allocation failure. This reduces repetitive error checking, improves code
> consistency across subsystems, and enhances code readability.

memblock_alloc_or_panic() made sense because it's the most used memblock
API.

Adding panic() versions for a handful of uses is unnecessary churn.

A better patch would be to update panic() messages to convey more useful
information.
 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
>  arch/sh/mm/numa.c            | 10 ++++------
>  arch/sparc/kernel/setup_64.c | 16 ++++++----------
>  arch/x86/coco/sev/core.c     |  5 ++---
>  include/linux/memblock.h     |  6 ++++++
>  mm/memblock.c                | 22 ++++++++++++++++++++++
>  mm/mm_init.c                 | 11 ++++-------
>  mm/sparse.c                  | 13 +++++--------
>  7 files changed, 49 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/sh/mm/numa.c b/arch/sh/mm/numa.c
> index 9bc212b5e762..32b01697b27f 100644
> --- a/arch/sh/mm/numa.c
> +++ b/arch/sh/mm/numa.c
> @@ -38,12 +38,10 @@ void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
>  	__add_active_range(nid, start_pfn, end_pfn);
>  
>  	/* Node-local pgdat */
> -	NODE_DATA(nid) = memblock_alloc_node(sizeof(struct pglist_data),
> -					     SMP_CACHE_BYTES, nid);
> -	if (!NODE_DATA(nid))
> -		panic("%s: Failed to allocate %zu bytes align=0x%x nid=%d\n",
> -		      __func__, sizeof(struct pglist_data), SMP_CACHE_BYTES,
> -		      nid);
> +	NODE_DATA(nid) = memblock_alloc_node_or_panic(
> +				sizeof(struct pglist_data),
> +				SMP_CACHE_BYTES,
> +				nid);

Please don't touch this, the entire file is going away after rc1.

>  
>  	NODE_DATA(nid)->node_start_pfn = start_pfn;
>  	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;

-- 
Sincerely yours,
Mike.

