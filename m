Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E73606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 07:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmR+ov55
Received: by kanga.kvack.org (Postfix)
	id 655696B00EF; Sun, 15 Nov 2026 02:31:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6067A6B05B0; Sun, 15 Nov 2026 02:31:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51BEF6B05B1; Sun, 15 Nov 2026 02:31:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3A46B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:31:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 613D91A05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:31:52 +0000 (UTC)
X-FDA: 85436534064.03.C5BE32B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B73CF100003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:31:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmR+ov55;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794727910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQ713QRNAekIGjd561kzHhEiq1a9v32zLLsxJ3VDhUE=;
	b=rtFSF9Vks39FOzv5J0YJj6wHXb+AvEloJmcuy8IIsrtCkNpIfthbxEVBqD4FJL4Sg+lOYV
	ZKUDz5zawhTjj7bxVN6edYp1qnoN3oQLX57e/J8IayPAioHM6v9uuehkVwanLkyWID0c+1
	Wh4Ek0tXPAc+6IgB9Aiztc3uGd40YNE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmR+ov55;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794727910;
	b=AugA4aPV0Z7e9+yLziaVyM5RtFm6QeWxEfxbhGKCxnC73Vz5ZcAu2R+/mkebgbmIvdP6l7
	mXaehfdWB8mGIPiaIQ9WHROiIB+ZjtnMuUqu1xcaPsrTDkenlZ765eVFJ8AnW8BKI+gWsK
	s7SezLUixzkzhAcKDmhOVyH5MKpuyz0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E26F0611FA;
	Sun, 15 Nov 2026 07:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009211F000C4;
	Sun, 15 Nov 2026 07:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794727909;
	bh=TQ713QRNAekIGjd561kzHhEiq1a9v32zLLsxJ3VDhUE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=lmR+ov55w3BRND1pmg4VD+/X00Vfk8cE6VGaeaINUKR0AljewXM+RrwYXxG5xYXzY
	 nN1jWlgF7PgtJdwUoWrLfmmmkn+L/Sy4VaS20ZOT6ZfURkddQCl7yEzifz6EvSza7+
	 1s8jkPurTSZbnc2RYZNu8nENteW3J29zf22p0U3eSCKfOoCct743JZPQosfgcgksTb
	 dDa7Lx1v+awqW2cIhQFbqYQHVEZcsNVcUR7Va40dygaQt/fiBqEP34du7GD1e5FCRw
	 vGqjVUA+ZA7+4UPfcT1fRUtnnl8bxeKdR5myOHq80BzoD72n7OaqoclUE2XsGLq9Rs
	 nV8f3aOqAhzgg==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/3] mm/page_ext: support early allocation for
 SPARSEMEM
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, David Hildenbrand <david@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Muchun Song <muchun.song@linux.dev>, Sang-Heon Jeon <ekffu200098@gmail.com>, 
 Mostafa Saleh <smostafa@google.com>, Ketan <ketan.kishore@oss.qualcomm.com>, 
 Usama Arif <usama.arif@bytedance.com>, kasan-dev@googlegroups.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261114104150.58424-3-songmuchun@bytedance.com>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
 <20261114104150.58424-3-songmuchun@bytedance.com>
Date: Sun, 15 Nov 2026 09:31:41 +0200
Message-Id: <179472790175.1870365.16622132821657916911.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B73CF100003
X-Stat-Signature: 4m747jbxh7aaebdgytzhbrsu7rb44ph7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794727910-727654
X-HE-Meta: U2FsdGVkX18m/HDU2ldL6ZGjxUVvIWdbRKM1/8KUtp/DE0IM6ZXI/LiqW9id1e2dcVN3ujk+5bRHWhn8H3K1C3t4duSwkhLcfW5RAK12nydRoMzF3kG6xa1lyVeL1GBt+bUXmXkG1A3oNs8G56RYVLxxizpBazb0WRi2lG6Sxx+8NWCkTU4rZow9pXngUbNM+OdGxSbm6EXsyZ+VI+6+VjyU/PBgRYCjC9IWqUt+mehlRJ/Uu3FdLAZU2tSlVdHr/oBuZE03udPfc1irs4kvQ6jC5u7R23Meqhqtyp5BzLTH9hKCZsYgZELPd0u1ufbQ6/Ubg4g5/iQSYwds4nGsHW8wmnZuBz2q6beBU2nHSCCsfq1or8/TFhMIfsICtKIexONuOI3Eskon6azE6vWNs0kX1zf4wck42TuhU80jRKJvJCtf03AzCp59we065AZaopp95HpXTVpzMoY4bApkktj3mwVOJbjkBHUxzaI429Jm6E562TXrbVw5+i3gjBBwDR3RuvD3kc+A9EyDp8fWNLDM4n8cr+ofGaMYlwXPA8ZrmbjiW9xF7ruDBiatLtzoKIyuuBdH4kkbiA4sfwQxPWQ3drTacFzUMLUlB0lHMB7U8ONiaNP7Xyh4pRsOs7+Ixi5Uvm0r934ujjpMNhjXeMcHqJGDzByexet0MNhoA6eGgBlXuOYthIevSHtHHHEp9ePbb1RIEyAcX2tXdIkiHdwFeazOhm5aFg1WBn0niVVC5tc/X1TVSVdgOXUEmwjgzKf7vQkJg6QmsulDCnDI9EH836S28TVZWgdY5CqFydU/r9pBYy9ioT7L2cfXhgJplyJBiHNoAqRhCgzyqv+2JM9TtGYCrAc17GsGqgvhY7qBcmImG/k65nTUlkKUIrxq8djsow5XdyqCXp8uW3+Hk9yLsTkU9zccMhAphfX7Xyshct0tNDleFpqU7360f4+a1VwLLou5y99ZGFLYnuV
 qbSdMlSr
 OOrkMGzZCAF+ItbVv9WrdCJeGhGQyLCsZp5mY4cNJ3yCDFKMM2c1ssVm1NUc2FQ1dxRbY0jZJzqvGEcRp2MfP9JrIkpNr8ViRx00lHYhGPJT5XLlJB/YjqPG9HwcfKKzq4eZ0UB/UFqNeQAOZ5JWxhPyPIYYQkJLJKu9wFCLI+xSVUzSaV5sEB2lWE8WLLmwr/1HcUnxDF+OQA8CX4arRG4ghirkO75/JrBu+1IaW78YSZdriAiu3Er94A12we0Naz4bRIMiKKBEKvLpbU/EUaedaQEYybVYQC0Y2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

> Moving KMSAN's per-page metadata into page_ext requires page extensions
> to be available when kmsan_init_shadow() runs, before memblock is freed.
> FLATMEM page extensions are available by then, but SPARSEMEM normally
> allocates them later from the page or vmalloc allocators.
>
> Add need_early so clients can request SPARSEMEM section backing from
> memblock during page_ext_init_early().

Can't we just always allocate page_ext for early sections from memblock?

> Use page_ext_init() as the common late path for client callbacks.
> KMSAN starts requesting early page extensions in the following patch.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/page_ext.h | 26 +++--------
>  mm/mm_init.c             | 11 +----
>  mm/page_ext.c            | 99 ++++++++++++++++++++++++++++++----------
>  3 files changed, 82 insertions(+), 54 deletions(-)
>
> +static __ref void *alloc_page_ext(size_t size, int nid)
>  {
>  	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
>  	void *addr = NULL;
>  
> +	if (!slab_is_available()) {
> +		addr = memblock_alloc_try_nid(size, PAGE_SIZE, 0,
> +					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
> +		if (addr)
> +			memmap_boot_pages_add(size / PAGE_SIZE);
> +		return addr;
> +	}
> +
>  	addr = alloc_pages_exact_nid(nid, size, flags);

And unrelated to this patch, do we really need to try an allocation from
buddy rather than always use vmalloc?

-- 
Sincerely yours,
Mike.


