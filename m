Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F22B5E937EA
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2E46B008A; Sun, 12 Apr 2026 12:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA976B009B; Sun, 12 Apr 2026 12:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F72A6B009F; Sun, 12 Apr 2026 12:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D77C6B008A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:26:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA04D14098C
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:26:17 +0000 (UTC)
X-FDA: 84650431194.19.65F6321
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 24CF880008
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:26:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lc8tEg37;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776011176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gw6yFFg2aFSe6cpj4BZjaZBAe/4elCWA4qFxhDO+SUs=;
	b=XyB+I48f2XNmSj99UQISE3S+hroBnu7KSW2Qm72rmpvx+JSUyU42FiuURpB2QG4gHh2tWX
	lobfL8rOs8KC0WicaYy4lWAfdrKDf9bOjLAWBnV3Z84d1OStn2NbxgKdV6mND7e5jZmNMB
	5bkOACv0eTf62lZefeVlG2qNjOnskzQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776011176; a=rsa-sha256;
	cv=none;
	b=FUFeR5A3GzCxdbplT8Jr4mPee71J8zsIvkKrzEYSHgPbCfjnhVf0GmTQEomJD8s9mI6wO6
	EEf/NyrSzTacuinyOXROlY76ySwKy6qiechbA5FIIaZlKjkWmkqkgEZM5tIyhiFPZJqJkF
	ok8UoKp0y/W21UBTMVsCvwjoi/xCMMU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lc8tEg37;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8118360142;
	Sun, 12 Apr 2026 16:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AF8C19424;
	Sun, 12 Apr 2026 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776011175;
	bh=rSNfWtN34FXwz/x7Q0w3Dbdq63xMPEFfeV8QcmfmuMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lc8tEg373b347asxMiEAb+5P7Gl/BzIbH8S0kE8/0HfFAZcBxRp1EVPBsUbG0ot6N
	 EfyL0CXmAxf/LYrkdtO0ZvuP5tiE1R3gm7Mf+BO1eP8QDfqsoou9OjetNkbn7ykfrO
	 e5NmkH0n7mXVhpwXXpsAf14fnnuFxAb2mvmszyG+eNZmVSUpXZTT5PUPzDVk0Yn91M
	 eKZqfOgUrittoVlisSOrib7AXw48gNYw0v2EZSWNbrLaN6ieCV+mbD2mF/72uNhciI
	 PXU4C5RWkYmkjj2Yhub5VwofX7uma+Qkz0WHwQxSlx246LbZcbvlj8EfJavL36BeGT
	 NFPO/sHhq+bIw==
Date: Sun, 12 Apr 2026 19:26:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/sparse: Remove sparse buffer pre-allocation
 mechanism
Message-ID: <advHn0m0iaQ7d32t@kernel.org>
References: <20260410092419.2446420-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410092419.2446420-1-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 24CF880008
X-Stat-Signature: 9n3nakiecd6xjb953cy3pu6xak4gwhte
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776011175-217086
X-HE-Meta: U2FsdGVkX19eca+H82vp7HgBj6ZZROOE6d4M9g6DuMg7Hy6vo99mHfNSo65hD8sL0TAjW6Z9ZM6yWfCx9GaehfLNKklB1/sS7XwWC6tJfcpuqzk/K25xf/UAsVTWzczydHe71cpcjaaiHki3LRtUAgKPntdSh2q+0GWLT4AxOJ9VgJ0vXVOlrhVvFHhCPjnJDaHLEJ4HisGkK69C9BqvJui+GxnCV+w7NOjs4724/B9DyfytQHS8+1IOxuKYmSk+5VetcB0AYG/iiLnXHH7g9tBX1z5YZbJNSdyrkvdG8QD2DrkQ3qOFAMsMijGwbixTbDZgpkW9P1ZK+icC5BxEuM/UEuoFiCloA5zNNivLlR5e0hPnOTxoZHecbTOMczf8Nfn7z3UUXneV6gCZU6HawjbFUFhfMuqeQxbnlxWQIgfvy0vClqbp+EvkC/UZvvImlZarUq/2HzgqymUfNbOrw7MbFLHSNMIOzeKgqtqDxXskmh55vQW+wqHBbjwOUlU/9ALv1y2b4eNWOTW/MNW6jO0z4FXDADQdPVpALa8ldDC/yxj+f7q28g+9Gyc7Hq/u30h2V3bLIWe71cIt/wEsAt7Z8TEsj1zW/Qzf5x/+IWe1gdn8c2/RkD6cUyde/R9mBQ2wn0KUhiWqZIk4TSKZEn5RjG/fsX5uf3sl4971i8TVREH0hoHxW/aH7OKT1DDFKMKqsMElTsnUUybFBXAtry6/O/TdKrmlLzncx6wOcsYxjTK4TGycDlJfMAj220iJTtvV3R4GLmaKg9OevpCezZVy6mxpFaIztMb17bPPhxjkFQrzDb1gpyq4xI8lDfyH3aSTB3/TgbMIYrlJHVt8f+ML/MKQNaJ6pxtcrqIaAGnWJ5UJJfrBp8uMUjQhHvvDK3ALlsHik5Ly9ATk6rZLDzGysjxnhgrRiBQGvJbfdGUa7UTJ3cggoQr3z6qVfoXB4oVB6iz/4gHruIV830w
 1LCfsqgu
 TtzLBcNctTePY50LEboWvGODOuh+Xp0j7x2qbG7Ka3LhhsN34+Whvh5SIxgt17j0qN6+UhsBEKFmudWx2kxJZ6gk12UJBao1kVPEtQAo0Qvt9BLGwFC6johnth7p4TfIMitDueyBvjE2PfGCYarR4vUH60Oh1P8+7rW2rgBhxtTG33koJiqEhi39CvBRGd+7VgyuZY2Em1VUE5OugpYGnW7DTDRm4+VbAgMVwQPlb0Q8fU9GCYOUNXNiUjuXrmG89834QSrC8d2cJhaIchSoonhh+ZDwFB2VF06ov5ahL/2EFh+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 05:24:19PM +0800, Muchun Song wrote:
> Commit 9bdac9142407 ("sparsemem: Put mem map for one node together.")
> introduced a mechanism to pre-allocate a large memory block to hold all
> memmaps for a NUMA node upfront.
> 
> However, the original commit message did not clearly state the actual
> benefits or the necessity of explicitly pre-allocating a single chunk
> for all memmap areas of a given node.
> 
> One of the concerns about removing this pre-allocation is that the
> subsequent per-section memmap allocations could become scattered around,
> and might turn too many memory blocks/sections into an "un-offlinable"
> state. However, tests show that even without the explicit node-wide
> pre-allocation, memblock still allocates memory closely and
> back-to-back. When tracing vmemmap_set_pmd allocations, the physical
> chunks allocated by memblock are strictly adjacent to each other in a
> single contiguous physical range (mapped top-down). Because they are
> packed tightly together naturally, they will at most consume or pollute
> the exact same number of memory blocks as the explicit pre-allocation
> did.
> 
> Another concern is the boot performance impact of calling memmap_alloc()
> multiple times compared to one large node-wide allocation. Tests on a
> 256GB VM showed that memmap allocation time increased from 199,555 ns
> to 741,292 ns. Even though it is 3.7x slower, on a 1TB machine, the
> entire memory allocation time would only take a few milliseconds. This
> boot performance difference is completely negligible.
> 
> Since no negative impact on memory offlining behavior or noticeable
> boot performance regression was found, this patch proposes removing
> the explicit node-wide memmap pre-allocation mechanism to reduce the
> maintenance burden.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes in v2:
>  - Addressed David Hildenbrand's and Mike Rapoport's concerns from the
>    v1 discussion by incorporating the detailed memblock contiguous
>    allocation analysis and the boot performance measurements directly
>    into the commit message.
> ---
>  include/linux/mm.h  |  1 -
>  mm/sparse-vmemmap.c |  7 +-----
>  mm/sparse.c         | 58 +--------------------------------------------
>  3 files changed, 2 insertions(+), 64 deletions(-)

-- 
Sincerely yours,
Mike.

