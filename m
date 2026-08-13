Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 173A8C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B616B01F9; Thu, 13 Aug 2026 04:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC6C6B040E; Thu, 13 Aug 2026 04:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E136B040F; Thu, 13 Aug 2026 04:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C888C6B01F9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:38:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5849F8056D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:38:04 +0000 (UTC)
X-FDA: 85095593688.06.605564D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A14D440004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:38:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fwp0GsOY;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786610282;
	b=wuZ6zRlHcMKksg2OPCpCjaYMRTBOUwFqnWvDkQjpx+RjrUqmNu6WgHP6mKzSkNs9bgVJ/a
	OZY33e0Bo337HORFfbINQtZukzecdewASM0GsZriE3Q+xWAlsFU3IeLH/IIzBHgstJIuLM
	mUSBVfTVihr+4OszO9BDNEVUbVhddY4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fwp0GsOY;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786610282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ca01uEIiHk2U7cH1EK6em3TeFeZ9px5SBvC9vsSl3y4=;
	b=3ZVx1i3EO+O9v0ZCYTt3HCGuFKtS0wFoEsMeQzalAHhESmOp3lRwbFvyPQSupMkr9LVdMg
	zIRXsma3Hy0r5uYTOI7Ogw0hQn0nDQBTreqmhGKCcroIwgQBsB1wYUpNTKpjtyXvD2YNwx
	PbuZkC9rL/47O82sc4Y0BmFcg+968BA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C47F840F81;
	Thu, 13 Aug 2026 08:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E5A1F000E9;
	Thu, 13 Aug 2026 08:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786610281;
	bh=ca01uEIiHk2U7cH1EK6em3TeFeZ9px5SBvC9vsSl3y4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Fwp0GsOYxOlbvRI+nGNIIPk3oum/0nIYSduBNoxMlNyNeSEhz7h44WLeFKj7ZHe8Q
	 UOA+UTiXu31BN4woz8qpI1JuVzEUPkk6ARXvHjr73+nlRN6xEtpsQQZ+1a3YjO3Xo9
	 7YT5zl6Jds4mefDxogM6fAj955oBPAxxC9baaVeE3p11uq9JhV5g2/AHlxZ3PT4ojT
	 Zgk3RRarwhG12ozFWZ+Vh0gOhZ5RKHgnwrAb5eUdv6AYBwbbcIbfa28MnFvIs9n/sv
	 0UmAkSjjAvMRFfsu2bxJqErLnXoeXVdyfOoJpwFAwgKhwSBAv4uZ05JcJ3lOvqBjSP
	 hPZz9uPuRJAnQ==
Date: Thu, 13 Aug 2026 09:37:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v9 00/15] Use generic_file_read_iter() in hugetlbfs
Message-ID: <an2B3q2apR0qrS_N@lucifer>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A14D440004
X-Stat-Signature: z7mzptp8a5g8xz9mb143ebt6335mwuoq
X-HE-Tag: 1786610282-784198
X-HE-Meta: U2FsdGVkX19gIR4ZtmoyMwEEPtaHuY2UwGG2aSgjfcgcP3mHUhuOLCm8KkEH0IOFguajs3kfl3S2PXitryD/xvmhYwwds5rZ96OXejnUMtlVPDyR5B7jz60pe+indjT8w6mn/hjM+7nmx/PhFlJK8Ks6zZLBLEZpb5wHfX52ypIaGDquFdRe6HKBMsak3x23zzkXNSzZe7oq4/zQHgvq2ZGyoUSRHRPoktr1ZqFmgIUSRH5foiImQAd3UF7pOVagLdSbWXiqq/fZYLn/8IDLjWC6bzBu+pBk+hFR1eT3dph8G+0T7pTjWnTV2mpcRLJFnoVbJ7HRqMsS+sWALszzOybDSL2Mw6XytNlo8bl6U9RR4IUQLRn6w6YMvqjiAp+eowJ0zENALmXDmF+dnFh6+7js55e+wpLhVesxmXdYxbAexBOuA+u1jQy+6F1MHRXgJS6875CUMpKUBSYKw/0y8Z5Un1HFlOs74jr9xwuTqkoWiX0MrXi8vjjNup507N5UJ1I5Implc+dA0tQ9PCDor+62ngbKRFDdYzM45RXspIAVn/yhT8Ktbaq39nlhfJc+I49IK9VmTfmBAWJKSE/40e2rdmg3+BI0MeVBCgH1UyYJefyqbpKojzrifIOGNAd+oOTyaKg8hP8MAH9qdELJ62KkLLTnVpS9noqHpvJ3mpy+cNpnAKOO16iMVPnyLMxcnzSkt+j0Gug/gj628lPFDp8OulOqA8DGD17kT2GbpWpBn2lAFHfhGUDv7nZi5n4tlXj+NOOKvWVXQ7LJKvvt6bV2YyM9eOSisxoa4NaKHiGte8KQNnuYhln5MOr9Umzwv8rbBeTXQG69CgIbESC+PV0g+AVJrHOlCLSkl4XmxUUHkJmDvGFBel1z2Al+R8iLgPNeYlbRVMi5uSR78cSVm7RqZMgn+2/yRCckee5jEWNhW4ZdZG9t0s1bdi0V3i1wZ0Fv9qGOWdnlF0MbRe8
 SUTFB4jy
 iKzFSQ1tsxy2CVTz66sVETrj+gjoWysk5jupVJfPIuyeRigsk8Af8lfqYft7AKvd14V6hWjSEgu3pKiOofKYv3XogBzSqtCLSt5271vRUJicfd6Lkd1VwGri/jMoJo6pIC8A9d6Miena83NSoDE+BYmP0GO0hPZZ+CmxNj3xyOPiq5dJY7/fBpX3ifrxcAKO124c2mXtEecYu+2sFlrQ9RMLjFJIxnla6kFpn2FVmyro/OignXKQkLlGpO8nUocfTBWcvctM8L79wKo2X7CYYNsryVvHxc74LDHqYrJ6wyKMiRRmsO/3EGSBXgGSRy9lhAlyM8Dpng2M0Q3fKD0oyofQI2EAjMX9yJt7yb3KbRO8aMyfQsNZ94JPTgu0IJMMgPGyz4H9ui2ijIYv2FWRYIZkHRUELnBsSkplcUNSOcs1IAN2ONqldkeD6EoTWwX9QnITThQ5pJhW2wpR8+AfDbu3Una32k3uPu82q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:05:40PM +0100, Matthew Wilcox (Oracle) wrote:
> This set of patches are separated out from Jane's earlier series.
> https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
>
> We need three things to use filemap_read_iter() instead of a hugetlbfs
> specific read_iter: hwpoison handling, treating gaps in the pagecache as
> holes, and having hugetlb set the folio size in the mapping.  hwopison
> handling turned out to need a lot of prep work; the other two things
> are fairly straightforward.
>
> Sashiko complains that the implementation of AS_AUTHORITATIVE is
> incomplete, but hugetlbfs doesn't use any of that functionality.
> We'll add it when we need it, either when hugetlbfs uses it, or when we
> convert shmem to use filemap.
>
> v8 here:
> https://lore.kernel.org/linux-mm/20260731200802.574821-1-willy@infradead.org/
>
> Changes from v7:
>  - Fix the KPF_HWPOISON blooper
>  - Expand HVO in a comment
>  - Collect R-b tags from Gregory & Jane
>
> Jane Chu (2):
>   filemap: Add hwpoison handling to filemap_read()
>   hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
>
> Matthew Wilcox (Oracle) (13):
>   memory-failure: Fix hardware poison check in unpoison_memory() again
>   memory-failure: Prevent hugetlb freeing during unpoisoning
>   mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
>   hugetlb: Mark some function arguments as const
>   guest_memfd: Use folio_has_hwpoisoned_page()
>   kpageflags: Use is_page_hwpoison() to set KPF_HWPOISON
>   hugetlb: Move poison to pages before clearing hugetlb page type
>   hugetlb: Use the has_hwpoisoned flag
>   mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
>   mm: Check individual hugetlb pages for poison
>   filemap: Remove checks in mapping_set_folio_order_range()
>   hugetlb: Set mapping folio order
>   filemap: Add support for authoritative mappings
>
>  fs/Kconfig                 |   2 +-
>  fs/hugetlbfs/inode.c       | 123 +++--------------------
>  fs/proc/page.c             |   8 +-
>  include/linux/hugetlb.h    |  43 +++++---
>  include/linux/mm_types.h   |   4 +-
>  include/linux/page-flags.h |  64 ++++++++++--
>  include/linux/pagemap.h    |  45 +++++----
>  mm/Kconfig                 |   6 +-
>  mm/filemap.c               |  51 +++++++++-
>  mm/huge_memory.c           |   2 +-
>  mm/hugetlb.c               |  41 ++++----
>  mm/memory-failure.c        | 197 +++++++++++++++++++++++++------------
>  mm/memory_hotplug.c        |   2 +-
>  mm/rmap.c                  |  43 +++++---

Much as I'd like to not look at this, nor think about it, nor even admit that
any of this actually exists, I do co-maintain the rmap with David so please do
cc- me on future revisions :)

>  mm/shmem.c                 |   2 +-
>  mm/vmscan.c                |   2 +-
>  virt/kvm/guest_memfd.c     |   2 +-
>  17 files changed, 368 insertions(+), 269 deletions(-)
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo

