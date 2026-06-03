Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0731CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A326B008C; Wed,  3 Jun 2026 08:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141A16B0092; Wed,  3 Jun 2026 08:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0585B6B0095; Wed,  3 Jun 2026 08:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED6F36B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:44:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0BDF140363
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:44:06 +0000 (UTC)
X-FDA: 84838568892.02.D87482E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E6A5120002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:44:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzHlbMr9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780490645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77CURzg/jAFNtzXDpoyP4AKbJU13c4kpfI7PfLbw04M=;
	b=tBl6EOZdcZNZgnph7LJj92vjnDaST10XXhqlcZLis4JI+ezCQyeijb1q4yLKBalXGFzQO0
	Ws+NZqKeYvmrgw0vjye6XuCtGF2QlVMvOQHb37Yh9ieZQQaAqOyldGNe8ive1cSe2MjzZG
	OqrCa5aaJ3HUxy5DOs8U4FJ/1Xdtu8E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzHlbMr9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780490645;
	b=tLidS6vFy2nMWGj3NK8yrYg/vK/9Hxd5/mObGQRjklndx15SvzyzaFjkMogeR47Ey1wQKA
	+r8/6mn4liTQDKC2c8NKeKNzdpFNXLNWxEPmcvj3919Lewq7flseAu/HUCkV2px9lD6/Rh
	ouG2RnUvK52256foJ3cP+9bj8NTzoXE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33D0740E06;
	Wed,  3 Jun 2026 12:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585EB1F00893;
	Wed,  3 Jun 2026 12:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780490644;
	bh=77CURzg/jAFNtzXDpoyP4AKbJU13c4kpfI7PfLbw04M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nzHlbMr9Zu7Uvk7B04WhJ0QhPOPOipiK2G9DXWdN/kL9jUYjtrFt4j4JyEEt0lfi8
	 SM2IY/6fCLWcREl46bmA4f8munOLqLt0a7M+YHpNB9dRZ4svHQskfBJrbfaZGsQDvc
	 c2OIjE7vNBAYPLTQsBf2e9DtCBVwd8XBvShQR5roqbtI22mTyNN0Iqyl/0lgvlEXmp
	 HAdGkKaKwytnjhr3Wb4OS23yvjJTZK8NdvrrnYquhc0tIUaJRWK7kTEGtzwtRkY/RF
	 hzICiQ4z0CElqqjXYONrxy8KjBVRMNyEvgkLw1IxcMw0fLkHBDCPBGbepLfYQ6QMnN
	 vQkU+Dtf4Rrzw==
Date: Wed, 3 Jun 2026 13:43:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
Message-ID: <aiAg6jkIKebAhh1V@lucifer>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
X-Rspamd-Queue-Id: 0E6A5120002
X-Rspam-User: 
X-Stat-Signature: dp134k7dn69byj5ds1hsx57646oyeymu
X-Rspamd-Server: rspam09
X-HE-Tag: 1780490644-869899
X-HE-Meta: U2FsdGVkX1+4qbD8gYR7zOWqFbkPBmb/WJrtiAD0K+OFgZVw6+fEjlZh5tnIY7hNIwbbYVSHwtkeZY+TS/pDzEgaJyJL97em4k/3KxsplD2Kh2qKRLfF0gjiQksASrVuuBXX4zH3ZsAE8aK7z9QMIuoYeF/ybdtzRdgcVN4V7xkxDDWxuC6eHPFpMXZDChsJCvPzQx5A+pXikC0BwJJ7DLabj0COyf6U6NE8QX69HZiP4dxpNmmJWZTUXuoJr8Q6eDVZ8ryeeASQK6MR08scTPUu/9PozfcDZiX6l4RtFSucsEhjqfxaIKyDxM6qP3jXyUk+3NsyVaacf+C29aumfeIb4cEjZqagrP8KiVKiKof5fq5VT8T24srPFm/27uUY1+d2MexbolZF1trZ/JNDTPonvbp8UoXFkfLT43h69DGOp7Sr34mw14MG+GMm4UDpeJ4ENidECi4jb3Zc8c029eyJQwYEvA7Gby75sxv/ogye8KoZ6Jv2m9JekfmpcgwWzhADeNpiwWooi14J8vlfnKq5SzjzIcVA5wIr9xIhhLa3ckRfAAKpYIG2jeELH3ug0fy2lsniTlhuymS2Lzdsx8JoeQyQn4IgDv8q0mhvI29nPGq7kRP0dOs4NAlf1PDE3JMrgcC9OYs1LL9b1UgUfoJ0lQHUDoTDjQpTm7zHV7zpisJ2nxheN6O9RfHhyWamoJlsbRI0KgdU9/ysucAGYWPUPU5177JhwSc8pKh4ZhVOWRQBOjFArdEWpHkegTsUov0I8GOHUTj9ilC5xN0KU7bYkqcgIvboFiNtBXpkiODd83ct8FfLqXPqFyAxYg6HpNkEV36se4EiUCYsuF7J5lYU/SIKIdNsKadZ+iAFFYjzTFEeAK6vYUPvnFoh5ECDbDMDUImPegiJ5tRs6wFyD+7POe01Uvt/WZYS/Qnin9f4DR5Cy1FRxgh2c1ToAqIUUE5YW5iVAzTQxhAJtbl
 Lb45kYPm
 BLefG+l9TJUgwl0k+v6RdP7KqqFagZNrhdNq2ag8UcpowDITSmP6aEx3BpX0/Rxb9XFcbkB9y7vmaiqB2CuUS+17QH6t8slsCanhMULhajZbzcMUHXq+XYFT+YA0G+HfSthMzexvBVMUR8KLmtUPIZY4YqG8siZG+MOC9RzqQNjFlZQlYRUUmc+GN88u9Cftpk0diBn/VDDWqIT9vlWF/eHjkZx5iZSdAYsjKYIrdbs4noBgznIkCncxOKZoLmJEQKNS4tqqiL0QHB80InJG4Bke0MQb8jpe5vNwav4yxLwNEskJ4nI+x5iS/OcBHs71a/toEsmmhiprl0YI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 09:01:16AM +0800, Jianyue Wu wrote:
> Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> the code's main responsibility.
>
> This keeps the implementation split from swap-specific code without
> changing the published LRU helper interfaces.
>
> Update MAINTAINERS and the remaining mm/swap.c documentation references
> after the rename.
>
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

This LGTM, swap.c is really misleading, and we can figure out the naming-is-hard
stuff later :P

So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

But also - do we want to rename swap.h to folio_lru.h? Actually that's less
clear as we have actual swap stuff in there too.

I do also need to do more work on the softleaf conversion for e.g. swapops.h.

> ---
>  Documentation/admin-guide/sysctl/vm.rst | 2 +-
>  Documentation/core-api/mm-api.rst       | 2 +-
>  MAINTAINERS                             | 3 +--
>  mm/Makefile                             | 2 +-
>  mm/{swap.c => folio_lru.c}              | 2 +-
>  5 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 97e12359775c..31d135e107cb 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -20,7 +20,7 @@ of the virtual memory (VM) subsystem of the Linux kernel and
>  the writeout of dirty data to disk.
>
>  Default values and initialization routines for most of these
> -files can be found in mm/swap.c.
> +files can be found in mm/swap_state.c.
>
>  Currently, these files are in /proc/sys/vm:
>
> diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
> index aabdd3cba58e..d6d189b9a996 100644
> --- a/Documentation/core-api/mm-api.rst
> +++ b/Documentation/core-api/mm-api.rst
> @@ -117,7 +117,7 @@ More Memory Management Functions
>  .. #kernel-doc:: mm/hmm.c (build warnings)
>  .. kernel-doc:: mm/memremap.c
>  .. kernel-doc:: mm/hugetlb.c
> -.. kernel-doc:: mm/swap.c
> +.. kernel-doc:: mm/folio_lru.c
>  .. kernel-doc:: mm/memcontrol.c
>  .. #kernel-doc:: mm/memory-tiers.c (build warnings)
>  .. kernel-doc:: mm/shmem.c
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e3ee97f5474e..6bd39e0afceb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16900,7 +16900,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>  F:	Documentation/mm/multigen_lru.rst
>  F:	include/linux/mm_inline.h
>  F:	include/linux/mmzone.h
> -F:	mm/swap.c
> +F:	mm/folio_lru.c
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>
> @@ -17045,7 +17045,6 @@ F:	include/linux/swap.h
>  F:	include/linux/swapfile.h
>  F:	include/linux/swapops.h
>  F:	mm/page_io.c
> -F:	mm/swap.c
>  F:	mm/swap.h
>  F:	mm/swap_table.h
>  F:	mm/swap_state.c
> diff --git a/mm/Makefile b/mm/Makefile
> index eff9f9e7e061..5f712f9bbe73 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -50,7 +50,7 @@ endif
>
>  obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
>  			   maccess.o page-writeback.o folio-compat.o \
> -			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
> +			   readahead.o folio_lru.o truncate.o vmscan.o shrinker.o \
>  			   shmem.o util.o mmzone.o vmstat.o backing-dev.o \
>  			   mm_init.o percpu.o slab_common.o \
>  			   compaction.o show_mem.o \
> diff --git a/mm/swap.c b/mm/folio_lru.c
> similarity index 99%
> rename from mm/swap.c
> rename to mm/folio_lru.c
> index e4b3dadaa6dc..7dab6a544d94 100644
> --- a/mm/swap.c
> +++ b/mm/folio_lru.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - *  linux/mm/swap.c
> + *  linux/mm/folio_lru.c
>   *
>   *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
>   */
>
> --
> 2.43.0
>

