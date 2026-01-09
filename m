Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE865D1A62D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5143E6B0088; Fri,  9 Jan 2026 09:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497C36B008C; Fri,  9 Jan 2026 09:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F1D6B0092; Fri,  9 Jan 2026 09:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23C066B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:18:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE497C2DB6
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:18:45 +0000 (UTC)
X-FDA: 84312631410.18.2BF6F0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1FB02120005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:18:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Em9yl8Wd;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767968324; a=rsa-sha256;
	cv=none;
	b=GbYmqt51RTyD2ssDwjz2hkMCh/RpvcdpNs81B1ZwENG2YH5pvYU2nkcDAaGSDIZb0MzxaT
	vG0MC05CXiPQPh1heUSYKcnbC/QVxfxuKXH2gk+SJKISVeIGAaJd40VEITk5pkmbJqwvcS
	RE4JQsDOiOxo2J8uNwdYa3pzAE7Sj2A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Em9yl8Wd;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767968324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0QM+4yIBKhcWTbESsYGFIDaoauIHXGA5MDaFYzeD2g=;
	b=jEuMJYbkEjDri8jVgUJtdqw6wfuuDfiJIOaDQLciEmBfsPab2mDygBURh4rLJoUz06qNwo
	mVenZrSL2opd33xDgNE1OMX5YKlfVkkIZy2QuQPi61/xT5RWvQWP9MmAp1kSjN+FBHfNzc
	Sljnj5RKn1Co+dJxjuE0TT1WBZ4Af54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94C6260122;
	Fri,  9 Jan 2026 14:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED19C4CEF1;
	Fri,  9 Jan 2026 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767968323;
	bh=UDfqyU5R4oLLX8JH9TDhDkX5WS5UHEQCcMVVXXhb5Rk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Em9yl8Wd0UCElsUBhOZ0qvCWAxk1C4K9p5Lvje1H3awjUuSqe2lvpWqlksPe+z/Li
	 0JkJjbM9U3Rr6t/ZaPhfVOWqZCPW5OwXQxfTWuZGb1psUVwBj+Nm/SOnXcA7vtKhwB
	 OuQ4twfmRIWt/3kCMRvMFoW5fO3HncSuXTuFTgkXSrcVdLUJAGyfHCEVx00yi6fghr
	 bscwS8QE4EtbRtcAj8ZuXOVM8j/u8h1EGDuKOiipdaPHO4GImJY5DYgGBqxCQg6HrX
	 H6SjFQyUhBqcoNKm57PVRLpyOZ0IPeVVGf0VkqjpkteSERIX5DlDFmRY4POzeHZp+h
	 vaIhRUI1CFLGA==
Message-ID: <e792db5f-5ec4-4960-a2f8-fde490e0e366@kernel.org>
Date: Fri, 9 Jan 2026 15:18:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix hugetlbfs deadlock by respecting lock
 ordering
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
References: <20260109034723.1342798-1-wangjinchao600@gmail.com>
 <920c641e-e092-46f0-89cb-0f1c130d979a@kernel.org> <aWENkov0R-1nIB8M@ndev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWENkov0R-1nIB8M@ndev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: re1yfdnbjmfb9iceo5ep8ibm1bjcw34d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1FB02120005
X-Rspam-User: 
X-HE-Tag: 1767968323-371301
X-HE-Meta: U2FsdGVkX1/+Eza+zpQL9hzSEwoU6NwoVHL8Mn/Ko1eFY5iUknG4EmHgSJhBgM3FOJUscYiSdPifUEGgkVEVEONzDvvWhcz9G9MpA8Fi0+JPHNJaAu1E2fgscX7gMTbDerk2ZA4ojIe/LWFMS8h/RLYhtsncNJmwk+HXajAF2esMw11S5BwCBaHPiW+Vmh2iNWFJdov7OYYqn5VLyF8LZOsF+LYXwIxKgI/Twwpou7L861Aa18dq8cmIV0U+5TVMIWnLIdYqX7V4k8EbJ7cLDjWb2p+zjIkKZGPA8naazozIKEgOvFeqQyA5MpUxEUFj2TkML/Y5j8Nqy494T2aSdkPxsdfgNKdE/ETRbn849zmbBLErNFmlv4Bqyox7EOO7GlMU/+l/OwxnNd64jL2TXRrCRV7SC4o4b4Bqf6Nd+7JGpPYKehw9VsB6OIq0kyLRGn2NrgE20mTQM5q8Ttg2vkiVyvG7GYFFzPr0LHIMl9RJ07w4X8NCI0ICWq6VmoTWmtA6aaHPPH8/1/sl6JZKefnesXL8vtEOBc1T0VPVqX5cCfdC1Y/pRL5EBIohr+eCOBtsprXPZv4WU9w/4ExnnCUlJ8R806Ic0WkDLl9mORS4kHJPEl4aRdjW40apR3fYnJRjiqC5+wGu7MskChGELoc9LJ/zENoBD6kYm2RhbRPAC38NN61sIbh3Ccd9eYYdhWX9lpzl914RRG6sNlPdpV0rh16NLVFw4fqCayojq3Agn/8VmSFguufiJZzp5huttSiX1VTfjst1LOJ5FiB1KtD4Qxul+Yio+l4bu4GiB7YdXW0nucPGrQOJqJHw6/6aWltqg3+Jh8lCjCE49WmL1Q7HaRvAUDaI+3TTdEUN0A9y919SHOCIhkC+Xhn9kV/qysLvcMtoc2Tb7fPX3DxBldkRf6CqAN3kGSIzkU1VckLY+WrXaIevOExq82t5lseuW/xs/87rPvJRZak2m0m
 66UWVY4s
 6szAou8uOg4SgOxf+xZnvRKd2hg6M8C6ZbAoiX9OzPsA3iyUAQ5M5vn40OjOLgACTP656keglUJ/AW7BgZv3JsasZbWQGOnunfcsimsJ2hrYsBi/9x+BYa/ncpkUA/6NrHW0P7BbOjDPEh+3qxLJfUaaes4a++hdm6qkEizpDJtS+SvSq6k0/UHHV8iT/xZBhlnA5sy/bafrOIHlHAP5OvqBxEVxNtb+pIXpJqdFu3lXc+2fSCGmI5a42S7b1rJEhqP9YhjxJ7ka9ON/vtFpDl80D8rkXmO3Or+gDD3f/NZzY02vIHWI4aOigMYyiJpqvVHe4bAIVAmneJLEdtPBX5kSvqd62YP2TkkBC9rqfIZ2Ny6SiagFC6JmfcFg0MnUDO9Aj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 15:16, Jinchao Wang wrote:
> On Fri, Jan 09, 2026 at 02:39:08PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/9/26 04:47, Jinchao Wang wrote:
>>> Fix an AB-BA deadlock between hugetlbfs_punch_hole() and page migration.
>>>
>>> The deadlock occurs because migration violates the lock ordering defined
>>> in mm/rmap.c for hugetlbfs:
>>>
>>>     * hugetlbfs PageHuge() take locks in this order:
>>>     * hugetlb_fault_mutex
>>>     * vma_lock
>>>     * mapping->i_mmap_rwsem
>>>     * folio_lock
>>>
>>> The following trace illustrates the inversion:
>>>
>>> Task A (punch_hole):             Task B (migration):
>>> --------------------             -------------------
>>> 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
>>> 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
>>>      (blocks waiting for B)           (blocks waiting for A)
>>>
>>> Task A is blocked in the punch-hole path:
>>>     hugetlbfs_fallocate
>>>       hugetlbfs_punch_hole
>>>         hugetlbfs_zero_partial_page
>>>           folio_lock
>>>
>>> Task B is blocked in the migration path:
>>>     migrate_pages
>>>       unmap_and_move_huge_page
>>>         remove_migration_ptes
>>>           __rmap_walk_file
>>>             i_mmap_lock_read
>>>
>>> To fix this, adjust unmap_and_move_huge_page() to respect the established
>>> hierarchy. If i_mmap_rwsem is acquired during try_to_migrate(), hold it
>>
>>
>> I'm confused. Isn't it unmap_and_move_huge_page() that grabs the
>> i_mmap_rwsem during hugetlb_page_mapping_lock_write() (where we do a
>> try-lock)?
> Yes, but the lock is released before remove_migration_ptes().
> 
> Task A can enter the race window between
> 	i_mmap_unlock_write(mapping)
> and
> 	remove_migration_ptes() -> i_mmap_lock_read(mapping).
> 
> This window was introduced by the change below:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/mm/migrate.c?id=336bf30eb765

try_to_migrate() is not the problem, but remove_migration_ptes() ?

Anyhow, I saw that Willy sent out a version.

-- 
Cheers

David

