Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D502D26D6A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B4A6B0005; Fri,  9 Jan 2026 10:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD906B008A; Fri,  9 Jan 2026 10:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFDE6B008C; Fri,  9 Jan 2026 10:41:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9A0B6B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:41:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D644577E1
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:41:16 +0000 (UTC)
X-FDA: 84312839352.05.60F455E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 76DDAC0013
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:41:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LJx/Awqs";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767973274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQs+Ey+VtfOqF5nOIC8X49iirsiw+1QczYlsJqHnQM4=;
	b=8Affa4BFX0TE9O8U3oZzlKLa42FhmqwTASi6nyQKuzTxvs4qhCwUfB/1weLkWU4cpHsV3T
	HjSQ9DjXl6PfbLW5fYopR5z8XzMlrDCNY0aghEP2ueN0bCodJkyO35NUVjaRNGQWe6n+wz
	tXOgV7mtbX6QBwxr98XmjNC1GTxPAG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767973274; a=rsa-sha256;
	cv=none;
	b=eKR4EEV4MLoN0nCtas3ad4YehjRRO567dSxWiUz/wji+nIm9wHFRP7aLxrt21URIdItW0F
	8kMOrWw6xSBIP1hPCP0dcNWx3HlZy1+dxGbNrjLroVN2KNb4hXcMZ0tyI9fVUwcsH0gucL
	FfNjq+WB/lo5oJky0eQKt1JGvrCxedE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LJx/Awqs";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A30F4029F;
	Fri,  9 Jan 2026 15:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDDEC4CEF1;
	Fri,  9 Jan 2026 15:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767973273;
	bh=zjirbLzk5y4/eQmZlP5l5XZ6LrVCdp2/2cmDJBEPpGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LJx/Awqs0W8dnmRGPKis4lRGYO1YtKIv2LCgMk3hfDNR1EFX3sXp6duz0kcaTGMky
	 H76mUFClbAmZdOaQd3ccOYADKsFcIeqkB6jX0X1GRj0JmAr9WlOQHL5UzFnAueaD/S
	 XolUvioNXor2OXyarOz0L8T2YbvP0TrU1XhrAMWQMZtUKDqsGOfNo4sg96KSUTnBRA
	 X6NuW57vsAdLtnbDPvjdhvU4oTXRFF8saqcL+cYLk7A6KYBwDRptIvyY3es+8suu40
	 S7bl8DlcxqDipdPTzcUFD5q4VC/PHQxd5Eq47chTB+ju6df/v7RiRWzHZKIrJ5EQAu
	 Y2DuG/oHLU9tQ==
Message-ID: <a14a7d81-7f87-42a0-9b3c-1a71e765cfe0@kernel.org>
Date: Fri, 9 Jan 2026 16:41:07 +0100
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
 <e792db5f-5ec4-4960-a2f8-fde490e0e366@kernel.org> <aWEfjVqVpoatvOpI@ndev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWEfjVqVpoatvOpI@ndev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76DDAC0013
X-Rspam-User: 
X-Stat-Signature: 47kfx3fypouk6e7nwcuc8qj6k89ubenr
X-HE-Tag: 1767973274-414663
X-HE-Meta: U2FsdGVkX18AOSwBStz3CuSrL2OzSkeVfXS7jFPlLLNPoLqPMXrSmoiTcHo7x43vK9olrgT+HWUdgQH/O55cHpEYU2MfJRni0rL7/LPQ1mM/JnhWEph25W3/d3VlKNGZhxezgUMD/U4R02ZC8CfoESOt9GAz8G4LFj7jMG7c0gYK4YKtIvLYHgflRDtR/e2bb4PG1yJSIWxy56UC3FjjgjU7E4sTs4PJslU9FhXEA+8llYIIyJiF3MpBk9Zth1Wb9u+afz+Gv+BbNM0YIBiwO2lEfPK/ZNDx2HZzsKzAQIzBQTS9ve4ha+L98DRUr5hhnDEpmIfOWkHjV3/G3zRhTuqND8jqUT5a+vm/kNeBVeZksn5g3f+xajD4oV+YFqhUMAiydbRgBqaqvINJ9zrzDnH/yyn7ok2koYOau2EVSVAP1Nci7pI9TaAJHAH7vW5sYszTAJrRZVNHci16Wq6at69SpcNE+SRWoiIAoNLSEfwGxcjVIPA4rGrgpNJTVly4qqZWMFydQaSqhiNwIEaAo6yyFlCT3xgXMHysA9yPU/XrKknz/TIEsY+VPUmhrs9S035DzCLBD6Ia0dvqzY9ghCFkrDS/DsJohnlrFzSJwcOUDNsJweAmN3n42UlG2QQ1AJo6LJBDKUVvlZvNTIfpNIF4CM7Vwc3NlusMgJjMmF4g+ci0pBhIt8TirUZoO9gPo1htvPYKNceBlGoO7VMiwSOt0A414Volhl35yz5SofZ1dDQFpgp7ud0HFGJpWxVmwgmpU9MntoEyj/DWC/4knIg/XF/fe5tEx/COI1L/phcJ39Mu67JDH5jMc4WwgaW9OjmCacY6cXrtWgefaITyeysuY5CXplvqEL9GeLtX4SibGinc5RAV2jsTedeE6ATtJO/w0A3vAQJ8ohRLaRuCP+DFZhz6UhR+SD0kXnF+1B5WOCrQ3flAJJwQcQ48qEka/oLwZ9AIfTNSexmAAOw
 1Kpo4f3L
 9NPOP+asMdSflZ9BlsY3BRHHRGUb8RnaeflISFHYNQc0tPicjVlldeGqCkbgu6sIN+YwAVQWfdvPcXIwXudMkOL3ui4ixWaa3Wj7GpHAEHFhb9Rwtg5Pzg9tCBmYh9c7CHqvJjrORHikrC8vNWEVXVeNL1K1/tj1oeAkX40XFBqD+0u4g4AxxeeiKyagxm0XbqIQBHh616sxJajiAMv3CiE+u1YdPDw0cTWvNbnN23Ef73egCWPJZlV0D4T/Hss2Jsa3MojGuvgzQ9fw9W71HINQ27CvmQ8mcoP+/lDW/N+ufsu1xJ1vKqyui/uSGeCMjdfd2w1ZSLHHFmKggl5rzb9HBHWWHoxsIib568jSYKbQ24/V0OKHShKs62iMO6HTvPrbQaV2BtlwhHL/jib7CX6KSOI0A5mFcbhD0GCX6eV6uhs4ZywxoF8Hu/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 16:32, Jinchao Wang wrote:
> On Fri, Jan 09, 2026 at 03:18:37PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/9/26 15:16, Jinchao Wang wrote:
>>> On Fri, Jan 09, 2026 at 02:39:08PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 1/9/26 04:47, Jinchao Wang wrote:
>>>>> Fix an AB-BA deadlock between hugetlbfs_punch_hole() and page migration.
>>>>>
>>>>> The deadlock occurs because migration violates the lock ordering defined
>>>>> in mm/rmap.c for hugetlbfs:
>>>>>
>>>>>      * hugetlbfs PageHuge() take locks in this order:
>>>>>      * hugetlb_fault_mutex
>>>>>      * vma_lock
>>>>>      * mapping->i_mmap_rwsem
>>>>>      * folio_lock
>>>>>
>>>>> The following trace illustrates the inversion:
>>>>>
>>>>> Task A (punch_hole):             Task B (migration):
>>>>> --------------------             -------------------
>>>>> 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
>>>>> 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
>>>>>       (blocks waiting for B)           (blocks waiting for A)
>>>>>
>>>>> Task A is blocked in the punch-hole path:
>>>>>      hugetlbfs_fallocate
>>>>>        hugetlbfs_punch_hole
>>>>>          hugetlbfs_zero_partial_page
>>>>>            folio_lock
>>>>>
>>>>> Task B is blocked in the migration path:
>>>>>      migrate_pages
>>>>>        unmap_and_move_huge_page
>>>>>          remove_migration_ptes
>>>>>            __rmap_walk_file
>>>>>              i_mmap_lock_read
>>>>>
>>>>> To fix this, adjust unmap_and_move_huge_page() to respect the established
>>>>> hierarchy. If i_mmap_rwsem is acquired during try_to_migrate(), hold it
>>>>
>>>>
>>>> I'm confused. Isn't it unmap_and_move_huge_page() that grabs the
>>>> i_mmap_rwsem during hugetlb_page_mapping_lock_write() (where we do a
>>>> try-lock)?
>>> Yes, but the lock is released before remove_migration_ptes().
>>>
>>> Task A can enter the race window between
>>> 	i_mmap_unlock_write(mapping)
>>> and
>>> 	remove_migration_ptes() -> i_mmap_lock_read(mapping).
>>>
>>> This window was introduced by the change below:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/mm/migrate.c?id=336bf30eb765
>>
>> try_to_migrate() is not the problem, but remove_migration_ptes() ?
>>
>> Anyhow, I saw that Willy sent out a version.
> Thank you for letting me know.

For reference:

https://lkml.kernel.org/r/20260109041345.3863089-1-willy@infradead.org

-- 
Cheers

David

