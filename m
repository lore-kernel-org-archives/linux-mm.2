Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AD2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572636B00A7; Tue,  7 Jul 2026 02:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549CC6B00AF; Tue,  7 Jul 2026 02:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460146B00B8; Tue,  7 Jul 2026 02:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 192D46B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:57:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F870C1C2F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:57:04 +0000 (UTC)
X-FDA: 84961073568.02.34D32E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13712C0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:57:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A47IAmZm;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783407422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0FBWE8Jb5+vMlrP70d2roSOjCV4VZTmyKyzdZd5y78=;
	b=f4lzFiWmdgExkYM544VgaT2bvUvyWLchbCQvmwpwCpJpb6Q2GrEG2692I8rzdW8hiBEEyz
	QTda9tadVY8mkgnySlJe7ZNd4BTAhhLSQMw0fJDtXhh3v5qma7QyYh5tH42UvHu5vHOlao
	NstLgg4UEHKniuI+l5cCRhB4re7Uqe8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A47IAmZm;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783407422;
	b=NMeBxeDWQbvMvgsA/dJwEFHdoLmRTDQ7sVdyTanzd5sylSqEc1AR1uoIu1ttS1atAZYdES
	/HRI31iks9mmvRT+nDirKuScjXQbn5tpfLxYPN1RWQGVVQqg+lK4MIV8WSjxRJIbhNNmcs
	K6DRX0+crlwh/jUkzAyhf7HI9jjNDic=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783407421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c0FBWE8Jb5+vMlrP70d2roSOjCV4VZTmyKyzdZd5y78=;
	b=A47IAmZm7FeS/wJVPxxVj7fHbJUZOlQ897si8dDMrjWMNFZXfldeznOxqpnO6tESzQSA9U
	AoNy6XEVfCDsRpkaW+g3kaghqdSDosaA9dWIQXlQzJ4wHXfnyTLTHWS19A+iKJDYDhdNqR
	HC3B+R1q3l7PIkaqoRBxJU8XH+tVh40=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-49I708dyMjSTuWbGs1ZU_g-1; Tue, 07 Jul 2026 02:57:00 -0400
X-MC-Unique: 49I708dyMjSTuWbGs1ZU_g-1
X-Mimecast-MFC-AGG-ID: 49I708dyMjSTuWbGs1ZU_g_1783407419
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49244130073so25707655e9.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 23:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783407419; x=1784012219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0FBWE8Jb5+vMlrP70d2roSOjCV4VZTmyKyzdZd5y78=;
        b=N2e5iZAUudFm4XQVvA27qjpDBlqMb2cx1kk9FBtWa1e8MgigPjhb4SbBFT4q/9B/Sq
         5R4m/arn3lBgEVFOh2VDJX93/CCNmAKt+fhaN2r/bCViMUmaBq/qQCnxAavT0PbLOhKk
         1MQ1Vw7GxzOiez2TSd7rekHQY5arhqNS48XoCSna6WNf0QHTxtPEx8ge/dHR/2bood2z
         7SwXBLLw6PK5D9vQS8Q3C0/N9EteKyBrd0i+sAEZlXoH5RaJBcs4BkX1dWk3oG0cVeiE
         Zwv7J2IXwd8zB5ONh3hXLUP7cqsfDyAbZBsqYDB6jGviXU4te0y4na4o9WLejev+6CJN
         jJWw==
X-Forwarded-Encrypted: i=1; AHgh+RqAAhsSGeUIvn+NOdKbWXrlIizqW1PTjnhqTSOrm6iDzwBeTxW8pSSJM3KWL3YWylQrE/0bCYZ/jg==@kvack.org
X-Gm-Message-State: AOJu0YwNfLxujI3irRf4CcpzpoN+TmSjhe/460hkLR1y+hl7Izhi8B/c
	rXhEbIwIAOq4gABJXis6jJgMJ7O10p1U/jx4SVPtgx4T0XtMFWmtwgq92wopDeMQHvGHsc/hdH7
	M9a7kwe3/uOJ0y7+A9kdWT92f8QCBd0CVU/iohJin/PvHBiihLs3e
X-Gm-Gg: AfdE7clJNSbsa3Y6e0BzBWaRwIl/9AFKu4J9givtPIMZUcYg533UMpg0hEJp0drROxK
	PGGLCDi0ZSZ+yaIu/Z3MPgTf5THHPwCBc63ZrNgiBEMQ65AcfhlconON/U5YZB0QRPffWCa7Sa0
	sH8zXQrDewNyp72LNpCqRT6zLdOPCxwkbwqgt6G5i+kQsGUJVdq3Vvi4aAwMyzYM/0PsHt7EAe9
	Z2LVD9XzDp6OaOq9ssxp/9dK4F4MBz5CD6G8xmcWEcb/8CzxcW76VeL26cmfH88/kXje1DhLp3B
	6YVF+0yhxaKJ1D/yHBXn1GfBFbttjtARkNkjxgLor21ndhn6C/uCIJYaHk0Y57ZFsC1WQIT52XV
	4u/ImxIaVTzxEtr7wP/a1B7CVDPPHg3dX
X-Received: by 2002:a05:600c:83c9:b0:493:bc31:b2ae with SMTP id 5b1f17b1804b1-493df040597mr40628265e9.10.1783407418838;
        Mon, 06 Jul 2026 23:56:58 -0700 (PDT)
X-Received: by 2002:a05:600c:83c9:b0:493:bc31:b2ae with SMTP id 5b1f17b1804b1-493df040597mr40628075e9.10.1783407418369;
        Mon, 06 Jul 2026 23:56:58 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fc1348sm30919825e9.14.2026.07.06.23.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 23:56:57 -0700 (PDT)
Date: Tue, 7 Jul 2026 02:56:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com,
	gthelen@google.com, mike.kravetz@oracle.com,
	pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
Message-ID: <20260707024744-mutt-send-email-mst@kernel.org>
References: <20260707064235.1386552-1-souravpanda@google.com>
MIME-Version: 1.0
In-Reply-To: <20260707064235.1386552-1-souravpanda@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ivdbsh9_o5evF72Q_ZytqssNjiFh29neuP5GHSZvvYU_1783407419
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 13712C0005
X-Stat-Signature: 58nd6ibhpi1nexch7ou64rpykukfofxg
X-HE-Tag: 1783407421-80132
X-HE-Meta: U2FsdGVkX187W3w8oUia7eXVwKzNBGtlwUlOuqSI8qdgBx6fcqv7tj5Z9ygk4pWr+LTEsSkckvZ8rHPmqmB4ZoTpwWHGGupcKQIFBMycFyrwccX0glStQrx/xOXtOaDmsoWuZ+iKWXmtw6pd8iH2g600e8uYafvP0dEyUljMsRCGbtqDSQ86WcevgVN8OB7ZHvrU6l/hUyTngx0WTucFufCcrZP7eEdpwGg0bDZKh2vbqfldmi4y8LpjFV+40BTkNjK6iMNbmlOubMalk+ZFTCWkzWqhLBrtdrSAcXfA3ij0IFNwwGxobC7sMDwcOCdmGn0oyBHJvgJNEq8t4C7FBp4gwv7qkM9q7lB3HV8Sq4jK7LwcvXJC875FmS9vyh64RRKkBJ6im9AtPPfu87tqm82KSQ/WISZR9H2vvgI2pnjvu3sA+NwXET8x5HRYIjTwkiBWods23iVdVY6AspPp8lDVZq6XhmRTfD7h0kc2xCFztWPhjGiUQ7vl7I6jD8XAmsYtWCwASQyzsr/BPQuDQZpvaV1MdokYQGJqR7K39tMZZ3izBJFpFqKzB9WM9HFXO6TVbnohjFvjUsFaiF2krjK6TCSrCXT2uTfQ9ORQoj8I6ipThG0MXS82T8wpF1UhoeruAuGswdnR8bk0sjIwNHzltYlHhW/S6QhRoRJmgkEmvEzwiA8ndBWeLuz+CyLsPkHKBUBq7p/rQM8WXCEjuAjgAdUU+RWdnnVqFxO1NroJCFpqXdnv0/zOs5fcjsF8DGN8Q2aaG085RnAVMxCoDIWDPN5VZn/ICZaxt/STigV+0+NDVy2Ikfdj1ueiUBO0ovsBi36zjT3VJT+e6woCDr0+Co5j7gwrVX1nQs5DobXyDMR0c/43ojvRXYjmZ1LB8fZkSNTxbk2wsJIe1ZwDuoTOqSBNLWga3xcS2IBeVZeoSO4li0bNkx6Au3R8TIXs7fQamzqvUFR0/TSP9rY
 Q13Wi+Iu
 Nci5VCGr+LkeEOmKAaVkoy8KFf/GgPlqaiirML5O3Oo2qg0ztA9qoVfNIvw0I0eXlUaM/VYjkSdgnqo+BZbHUtNKAgeuQBY/cfdF8TcvloYs43vfxawGKgCFz9+XNH/iLguJCDDT4Fl6pvqDoHbpW+Kbr6un84FlY4p9tMEBHv/dhZiXFXbPuM2uhHzdaIBJIj9x6IWKllmpH55VZMfAS6JoB/SQd0OnI37258Z9fNtpwLRufnvQxkV/8p4uPJa1QzdjGRXwWBEcsVxqnUPttU0tAV9eEO5uSxrWBbBImq1pslFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 06:42:29AM +0000, Sourav Panda wrote:
> Overview
> This patch series introduces a dynamic, NUMA-aware HugePage Cache,
> backed by a kernel shrinker to safely return memory under pressure, and
> integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
> specifically targeting gigantic (1GB) hugepages. The goal is to solve
> the tradeoff between allocation latency and memory
> fungibility in virtualized and heterogeneous cloud environments.
> 
> ---
> 
> The Core Problem: Allocation Latency vs. Memory Fungibility
> 
> With highly heterogeneous workloads, latency-critical applications demand
> gigantic hugepages. However, dynamic runtime allocation of 1GB pages
> from the buddy allocator (via CMA) is slow.
> 
> To bypass this latency, operators often pre-allocate hugepages
> statically. However, this locks up the memory: when the HugeTLB
> workloads are idle, that memory is completely unavailable for other
> buddy-allocator workloads (e.g., page cache, anonymous memory). If buddy
> memory is exhausted, the system will OOM even if gigabytes of HugeTLB
> pages are sitting idle.
> 
> This series resolves this challenge by delivering Dynamic Fungibility:
> 
> 1.  Dynamic Caching: Intercepts freed surplus hugepages and recycles
>     them into a NUMA-aware cache instead of dissolving them immediately.
> 2.  Fast Allocations: Satisfies subsequent dynamic allocations
>     instantly from this warm, local hugepage cache.
> 3.  Kernel Shrinker Integration: Registers a NUMA-aware kernel shrinker
>     to dynamically dissolve cached pages back to the buddy allocator
>     under memory pressure, restoring host/guest memory fungibility.
> 4.  Free Page Reporting Integration: For virtualized environments (Guest
>     VMs),

I was going to look into this part, thanks for working on this.

> cached pages trigger background Free Page Reporting via
>     virtio-balloon. This allows the host to reclaim the physical memory
>     while the guest retains its Vmemmap Optimization (HVO) metadata
>     savings (~14GB saved per 1TB VM)!

Why "!" - that's 1.5%, seems surprisingly modest.
Are you sure it's working as intended?

>   +---------------+   Slow Allocate  +---------------------+
>   | Buddy         | ---------------> | Active HugeTLB Page |
>   | Allocator     |                  +---------------------+
>   +---------------+                    |                ^
>     ^                                  | (1) Free to    | (2) Fast
>     | (3) Under                        v     Cache      |     Allocate
>     | Pressure                       +---------------------+
>     | Shrink()  <------------------- | HugeTLB Cache       |
>                                      +---------------------+
>                                        |
>                                        v (4) Free Page Reporting
>                                          (Host Reclaim in the case
>                                           of virtualization)
> 
> ---
> 
> Patch Series Structure
> 
> Patch 1/6: mm/hugetlb: add Kconfig and basic cache infrastructure
>   - Introduces the CONFIG_HUGETLB_CACHE option, hstate tracking fields,
>     and the HPG_cached page flag.
>   - Establishes the clean helper API (hugetlb_folio_is_cached(),
>     hugetlb_cache_remove(), hugetlb_cache_add()) and updates
>     remove_hugetlb_folio() to be cache-aware, eliminating inline #ifdef
>     blocks.
> Patch 2/6: mm/hugetlb: implement cache recycling and allocation
>   - Hooks up recycling in free_huge_folio() (up to the cache limit) and
>     allocation in alloc_surplus_hugetlb_folio().
>   - Implements MRU allocation policy for maximum warmth, poison safety
>     checks, and MTE/dcache cleaning.
> Patch 3/6: mm/hugetlb: add sysfs interfaces for cache
>   - Exposes global and per-node sysfs attributes (max_cached_huge_pages,
>     nr_cached_hugepages) for dynamic userspace control, including NUMA
>     memory policy scaling.
>   - Supports dynamic delta adjustments (+1/-1) to safely scale cache
>     sizes alongside concurrent background reclaim operations.
> Patch 4/6: mm/hugetlb: add memory shrinker for cache
>   - Registers a NUMA-aware kernel shrinker to evict and dissolve cached
>     gigantic pages back to buddy under memory pressure.
> Patch 5/6: Documentation/admin-guide/mm/hugetlbpage.rst: document cache
>     interfaces
>   - Documents the Kconfig option, sysfs attributes, and shrinker
>     behavior in the admin guide.
> Patch 6/6: mm/hugetlb: support free page reporting for cached hugepages
>   - Integrates the cache with the Free Page Reporting framework (virtio-
>     balloon), introducing the HPG_reported flag and the
>     reporting/isolation/draining lifecycle.
> Sourav Panda (6):
>   mm/hugetlb: add Kconfig and basic cache infrastructure
>   mm/hugetlb: implement cache recycling and allocation
>   mm/hugetlb: add sysfs interfaces for cache
>   mm/hugetlb: add memory shrinker for cache
>   Documentation/admin-guide/mm/hugetlbpage.rst: document cache
>     interfaces
>   mm/hugetlb: support free page reporting for cached hugepages
> 
>  Documentation/admin-guide/mm/hugetlbpage.rst |  34 +-
>  fs/Kconfig                                   |   9 +
>  include/linux/hugetlb.h                      |  45 ++
>  include/linux/page_reporting.h               |   1 +
>  mm/hugetlb.c                                 | 590 ++++++++++++++++++-
>  mm/hugetlb_internal.h                        |   9 +
>  mm/hugetlb_sysfs.c                           | 158 +++++
>  mm/page_reporting.c                          |  10 +-
>  mm/page_reporting.h                          |   6 +
>  9 files changed, 844 insertions(+), 18 deletions(-)
> 
> -- 
> 2.55.0.rc0.799.gd6f94ed593-goog


