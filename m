Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75641F99C7D
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 09:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3F96B01B1; Sat, 18 Apr 2026 05:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64BC6B01B3; Sat, 18 Apr 2026 05:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952F96B01F0; Sat, 18 Apr 2026 05:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 820B66B01B1
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:27:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E50F13AD9C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:27:16 +0000 (UTC)
X-FDA: 84671148072.14.9034657
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4025140008
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:27:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ikWmHtfu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776504434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bN34o4x/1M+hoa3HgnWvk953cLhBXlECblYV0Y8wQTk=;
	b=kqNEtkPpaIEYYi6JKx0PmDRbmKjaSN7cmG1E1rI3gic7RTQIYkHUNe/F60k6H7qZN8iPgv
	djxMCLvR5UffrYUq8sg+omsRmvFBl9MzJ1acBEwSvNbHzn7qdHfupTShKy+8xrXJROvyGs
	ZdQ036DiiYbvzSwrnFx2QbLPijw7ODY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ikWmHtfu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776504434; a=rsa-sha256;
	cv=none;
	b=LV8i1cc4vtlzwh2g1mLe3R8J5b+fg9S7VGXXv9qBkcC6vHG7qL34Ori9r2tUZUN/Ke4/R3
	M7iJZcQRHe6qRPfmlzB0/D2uTZjxOlhVfiUNW5FcANVDtdTUsLZQJeSFisC6OEcAhJzQZ2
	TwD/XLUbT9dQ8RvCG851KK7a5rNwwb8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC1B7442CA;
	Sat, 18 Apr 2026 09:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC7BC19424;
	Sat, 18 Apr 2026 09:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776504432;
	bh=qQK1tXEC3bQP9DZ7GFPDMCN0K1t29slMgrLD0yyfeZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ikWmHtfu7pVAnscldTDWmT2dkebMotrLIBQE8B3cj/NJm+LMOdJQ1+SicHCaJzh2j
	 hvQDrQkhkcCi9Gs9VMZ+zu/zKq2plSfI+RnUQ2AKfDN0ePzK/cddQUoOimK4WLSszf
	 73s7zVs5pDX8IJ1ORCYFd+4yIo+u+omrpvxuhh0vbNwiJSdalDH28uKWpTGEVH3tOm
	 jyy0UKIxK3Db8Tw+PQ4t/LhdfbHTtt1XgMdnZxUteaIAUPqDeMUzwIoq2wRqAysxrN
	 /iuPRwQi1pEE1O52z35J4YmZ5J/y1R47cZAbeZXVPqXz4SmGwgdUhgQxYkzqAzQNjx
	 3cpLn0aRJZ1mQ==
Date: Sat, 18 Apr 2026 10:27:04 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 00/12] Remove read-only THP support for FSes
 without large folio support
Message-ID: <aeNNjgD09VqwI0jo@lucifer>
References: <20260418024429.4055056-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4025140008
X-Stat-Signature: d43tw1j4y3f846zxfth94bhjj3dbpu9r
X-Rspam-User: 
X-HE-Tag: 1776504434-566426
X-HE-Meta: U2FsdGVkX19RrlVF9CRogVFjbQd41648pBJv5KNbfSnr23WzcD0tgw5EKWKuw0OSsEE8eBy4eAorTMJUSNYWyZSnLltI70m6UCesGOljsmAfURsikW8TWYjDhWow5wqIN+2ECjLRoipqiClzadYUYAqM9UTkEbCxXn/RT2j332sLBfSHQzXrhuUcAbxQKXVxvBlDfvvmc526IS1wQ+WkevPPDhXLpkuiZY02/sWm0uytRtuM7arSE8fY8u0UV+4obbiTA6vEBelDe7EBNcDnRXSttgQ4iRE0Y+cnspGWVZoMx74N6+E5XbJQfLiCfWvMwiPSDY7RgodlQs8ApmQ4Y53n6CLDgIGHbJqgx2877NhkyyRmgzBtSan+x24/Wiw87Qks3+eCHMF9AxHy2eJf5WfH0m1P7CZOIBa06erhAywdh9IJ7UrIu3/Mla6xZYje3ydPDVNoO0mIyY80TCGKqlKXKkvJYpAQXIRseQ7J2Lh/KFEaHV5laq//sdzUtsp2fydMF6Bz8is47WgmUXSNsTncXAgMjfgb62UViqd5PB2BiC567axNSIjL/JGHQNJK5bUHfntheQWzERoBUyufGNaFf0P3a32poDem0C9KgO079nih6VyZfhmRG7+KbmWiRHZ/mtT+IO1SWGO2b4JsNzAwrKbtGvjObR0JO/Di9MtkiPLt8VrKzOLxYHDxwIvRuUiYf04HUFlnDk0FyH0ezVNsfBa38N5BrUnTA3pxoIuZ80+S6sB8lGA/J0BJL2JtqFEPHGNGbYuKcQ4qqwbhZ5r7Xr+kdivh4ygYNMyyygREXKXq/3cQM2MJpuuM1MIPpzgupsUefO9/5QEX8XaxB95e/ZJus9zgSSxokbZ4fX+w/p0j0TOLvYaldgZmd3V0hqPUuSKCEhOH7tiK9dhRoulecXHdi4hyyAJvIGcnP4sj2kO25Qd/z0KYf7WJdFMB7HtHfTCZmhn4o4sFu2S
 kPh0JjSX
 wQ/1ipDXyCuF8FV9IopsbpuP+uD+77xNlNJLOOhSuS23G5P6oH43iJBzGhMjZt/Z0mWh6mSJz5XMkewaVrybvfNZuLLpPASLYqOqjcS3AjJQGhOcgTJHvAtey6ZbVS/Urm8cVeofAh1EVOWryGyT9gxN4QJFlO7xn6Rc4iNkqecctgft2UV16z0IfR7E7Xq9vI5ZbFJ8fC56ZMrTSysPxmGgxrzJ007HdLTOrHjQtCLfdnep/EM2KxrYyKFkkQg3J+QsMwavDKlSwge3G5CaKOvKlQS520HOtFBhbSAKTO/Zur2aTZeVvLBLn0F+qMX1GsyM5A/s+XYP8vqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 10:44:17PM -0400, Zi Yan wrote:
> Hi all,
>
> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> read-only THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default.
>
> Before the patchset, the status of creating read-only THPs is below:

Good to specify the read-only bit up front!

>
>                             |    PF     | MADV_COLLAPSE | khugepaged |
>                             |-----------|---------------|------------|
>  large folio FSes only      |     ✓     |       x       |      x     |
>  READ_ONLY_THP_FOR_FS only  |     x     |       ✓       |      ✓     |
>  both                       |     ✓     |       ✓       |      ✓     |

This diagrams seem familiar :P but very nice, thanks!

And since we include cover letter in series in mm this should be some nice
documentation in the commit msg also.

>
> where READ_ONLY_THP_FOR_FS implies no large folio FSes.
>
>
> Now without READ_ONLY_THP_FOR_FS:
>
>                            |    PF     | MADV_COLLAPSE | khugepaged |
>                            |-----------|---------------|------------|
>  large folio FSes          |     ✓     |       ✓       |      ✓     |
>  no large folio FSes       |     x     |       x       |      x     |

This is really nice and clear thanks!

>
> This means no large folio FSes need to add large folio support (the
> supported orders need to include PMD_ORDER), so that they can leverage
> read-only THP creation function.
>
> To prevent breaking read-only THP support for large folio FSes,
> 1. first 4 patches enables the support, so that without READ_ONLY_THP_FOR_FS,
>    read-only THP still works for large folio FSes,

I guess this introduces what was previously supported by
CONFIG_READ_ONLY_THP_FOR_FS to large folios as part of that before removal of
the config option?

> 2. Patch 5 removes READ_ONLY_THP_FOR_FS Kconfig,
> 3. the rest of patches remove code related to READ_ONLY_THP_FOR_FS.

Makes sense thanks!

>
>
> The overview of the changes is:
>
> 1. collapse_file() checks for to-be-collapsed folio dirtiness after they
>    are locked, unmapped to make sure no new write happens. Before,
>    mapping->nr_thps and inode->i_writecount are used to cause read-only
>    THP truncation before a fd becomes writable.
>
> 2. hugepage_pmd_enabled() is true for anon, shmem, and file-backed cases
>    if the global khugepaged control is on, otherwise, khugepaged for
>    file-backed case is turned off and anon and shmem depend on per-size
>    control knobs.
>
> 3. collapse_file() from mm/khugepaged.c, instead of checking
>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
>    of struct address_space of the file is at least PMD_ORDER.
>
> 4. file_thp_enabled() also checks mapping_max_folio_order() instead and
>    no longer checks if the input file is opened as read-only (Change 1
>    handles read-write files).
>
> 5. truncate_inode_partial_folio() calls folio_split() directly instead
>    of the removed try_folio_split_to_order(), since large folios can
>    only show up on a FS with large folio support.
>
> 6. nr_thps is removed from struct address_space, since it is no longer
>    needed to drop all read-only THPs from a FS without large folio
>    support when the fd becomes writable. Its related filemap_nr_thps*()
>    are removed too.
>
> 7. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
>
> 8. Updated comments in various places.
>
>
> Changelog
> ===
> From V2[3]:
> 1. removed unnecessary check in collapse_scan_file().
>
> 2. removed inode_is_open_for_write() check in file_thp_enabled().
>
> 3. changed hugepage_pmd_enabled() to return true if khugepaged global
>    control is on instead of false. cleaned up anon and shmem code in the
>    function.
>
> 4. moved folio dirtiness check after try_to_unmap() but before
>    try_to_unmap_flush(), since that is sufficient to prevent new writes.
>
> 5. reordered patch 4 and 5, so that khugepaged behavior does not change
>    after READ_ONLY_THP_FOR_FS is removed.
>
> 6. added read-write file test in khugepaged selftest.
>
> 7. removed the read-only file restriction from guard-region selftest.
>
> From V1[2]:
> 1. removed inode_is_open_for_write() check in collapse_file(), since the
>    added folio dirtiness check after try_to_unmap_flush() should be
>    sufficient to prevent writes to candidate folios.
>
> 2. removed READ_ONLY_THP_FOR_FS check in hugepage_pmd_enabled(), please
>    see Patch 5 and item 2 in the overview for more details.
>
> 3. moved the patch removing READ_ONLY_THP_FOR_FS Kconfig after enabling
>    khugepaged and MADV_COLLAPSE to create read-only THPs.
>
> 4. added mapping_pmd_thp_support() helper function.
>
> 5. used VM_WARN_ON_ONCE() in collapse_file() for mapping eligibility check
>    and address alignment check instead of if + return error code. Always
>    allow shmem, since MADV_COLLAPSE ignore shmem huge config.
>
> 6. added mapping eligibility check in collapse_scan_file().
>
> 7. removed trailing ; for folio_split() in the !CONFIG_TRANSPARENT_HUGEPAGE.
>
> 8. simplified code in folio_check_splittable() after removing
>    READ_ONLY_THP_FOR_FS code.
>
> 9. clarified that read-only THP works for FSes with PMD THP support by
>    default.
>
> From RFC[1]:
> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
>    on by default for all FSes with large folio support and the supported
>    orders includes PMD_ORDER.
>
> Suggestions and comments are welcome.
>
> Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.com/ [1]
> Link: https://lore.kernel.org/all/20260327014255.2058916-1-ziy@nvidia.com/ [2]
> Link: https://lore.kernel.org/all/20260413192030.3275825-1-ziy@nvidia.com/ [3]
>
> Zi Yan (12):
>   mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
>   mm/khugepaged: add folio dirty check after try_to_unmap()
>   mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
>   mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
>     hugepage_pmd_enabled()
>   mm: remove READ_ONLY_THP_FOR_FS Kconfig option
>   mm: fs: remove filemap_nr_thps*() functions and their users
>   fs: remove nr_thps from struct address_space
>   mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
>   mm/truncate: use folio_split() in truncate_inode_partial_folio()
>   fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
>   selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
>   selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
>
>  fs/btrfs/defrag.c                          |   3 -
>  fs/inode.c                                 |   3 -
>  fs/open.c                                  |  27 -----
>  include/linux/fs.h                         |   5 -
>  include/linux/huge_mm.h                    |  25 +----
>  include/linux/pagemap.h                    |  35 ++-----
>  include/linux/shmem_fs.h                   |   2 +-
>  mm/Kconfig                                 |  11 ---
>  mm/filemap.c                               |   1 -
>  mm/huge_memory.c                           |  39 ++------
>  mm/khugepaged.c                            |  86 ++++++++--------
>  mm/truncate.c                              |   8 +-
>  tools/testing/selftests/mm/guard-regions.c |  18 +---
>  tools/testing/selftests/mm/khugepaged.c    | 110 +++++++++++++++------
>  tools/testing/selftests/mm/run_vmtests.sh  |  12 ++-
>  15 files changed, 156 insertions(+), 229 deletions(-)
>
> --
> 2.43.0
>

