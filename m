Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AB5CFD37F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845566B0062; Tue, 25 Nov 2025 05:24:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D146B0088; Tue, 25 Nov 2025 05:24:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B2F6B008A; Tue, 25 Nov 2025 05:24:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6591D6B0062
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:24:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 981254FE0A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:24:33 +0000 (UTC)
X-FDA: 84148745226.19.FF654C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDC4640011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:24:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YVDDijXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764066271; a=rsa-sha256;
	cv=none;
	b=vfZP2BS9Aj0fYMqjo//pOlUt0C+FSMbna628vX//0C3GXQU2SnSRvajXpM7XSdqwLBHien
	oSu55dukqgDWhg0paJooJGcQYdyTKRZivpws87RDF448clpGlviUFgsH4YFxdapUkC+IyD
	y88gfVf4U191uMYFMgJH+RTgRxedNSg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YVDDijXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764066271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kz70wzRcULbKH4DbOuP6FiqM1HIN3FbR0UrCZzoFo+M=;
	b=fcLUYdqjdVYYJ5aOoZLzN+6Qw71j4kOJcuQ0ZopfHWCPYX+ahqa6DbmyKWlhmAHLCZ48Pt
	zfWtoXgF3i1ztm8ph4fkUGzyw4+elMdH3uD1QZybnnMDW/lUN5RkB262SxB+6KTGODNlVy
	6M2rKqbpdR2Q90G7RDaUidwVrNbOMj8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A31B743FE1;
	Tue, 25 Nov 2025 10:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0C9C4CEF1;
	Tue, 25 Nov 2025 10:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764066270;
	bh=xU4Ntm/M/6qjUA+H/VJSygdegAetlI7Tj8y4SG/smh0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YVDDijXC5cY+GTiSiG64FIcwf9QR+R30X8Lg6uJpnll9rl18cwmHrVhIjbgN0NWJB
	 bX27uKkhdHfKGBa5F6PKIDGWNdFcCT2YuihUvRxBMjbmsXt+DqHeum2ZGtJTc+F2ZM
	 nToLEY8T/9jSc8cfdZOnvfJhxfvJVio/C1ieuL/0S428HHR3qPFISx0DznIlL2haw8
	 ACZnJPN07qQn59fAs79kPRo6Fr1ZiVmWYyMle/rLA2vR9+3KFxew02ILswLPhwJQ8C
	 bsJmiOHPV5tQLf9PEeZct7lVHUI3FGWyGWs8zfkBVdm3JzrL2k8ECrhtcVBhYk1Dd5
	 VgtTd6QdHOIeA==
Message-ID: <c309a251-5d14-49a9-a3d7-5c60d100c4eb@kernel.org>
Date: Tue, 25 Nov 2025 11:24:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm, hugetlb: implement movable_gigantic_pages sysctl
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: kernel-team@meta.com, vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 David Rientjes <rientjes@google.com>
References: <20251121192746.256051-1-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251121192746.256051-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BDC4640011
X-Rspamd-Server: rspam07
X-Stat-Signature: 13zo16yxom65g5ttosnjjdsxza7dafmx
X-Rspam-User: 
X-HE-Tag: 1764066271-598891
X-HE-Meta: U2FsdGVkX1/M6BLGdheYM+Xxix1S+xDDKMC1snYo6+K6hoih3Hj+zjls8F2EIqhmVwIJiox//HjXVn/edFZJLd6B4F8uwpsTVF8Xey88wIPyEjZG6HHS7iuVnDOndV1/xhGgj60r7z+qiJSUt3GeIORm/gTt5HkA4Yt52lIIQN5AnLwL89TCagmJ+LpX4r77WL2LEUu254U4fzmNmPJTHzJ+eXAD+azbItdMTGVot1vODlXlQ+xaqK81J+My/6v7qA31MTAyg8Gdl1X1FbYTYPKhB9N/GRdjwz2L1qbHOhXtxhlfi6cLn0C7HjXODF/vCrfRjln6ENn9CG4pGPBX4vWkmxjoFrbfZ5LXlntklkX6r5qB2CbAA6gb2a0VE/QS7Ml5YccS5tUVt2iKMB93stvZqD1+HJjQmYmupM/aqKAjm2YxLNqIlOJlBUcpl0PezqROBrBBZkIBrxtqbbz25rAnWdzL+2Px+M5Ohf5mBJjuz4cTWYqMfBFOmYGj6aqPJuCUkEUnwPWF9b1TTaxyyO9mJBFebDleRLzHKO6owqkPwMC0YpTu0iahXMG0lROmaTUFa08Kc3yEJBTmZkuvAOTb3b8nhSYprrZZzhXcKvGQhYQKVMM6aUCuu3mU78pKH2b/x0wJSBAVo1nrEtu1DtHPPTg9JAP0tbW7+kN/ciDzrOUA4Yir7VzcUoTiUE2Gao22pP6qH6KSp6XAV1ytqekO2kHLORfvswvFniXkHSfUQ/brWDcIS/DkoYDSeAa6u0MdVdVyZDEANtDYsCAHIr0WuNVJGe7jitYSnHRHpqm2HP2/su0LUqRtQrwv2gONdNHDlJocSKfiyld73Z+vLwHI+XnLR/hnAWeXVnDNyf+97q2nh4rNGETOVQrf3GlPrCklV+gdZaTvvrF5B0vpSbm2Tlnt1P23B6Xij/DNm7zxBu35OsSdvQkLVuUzZThwx67JOsDfMu3qUhDOJdn
 m7Q5BUZr
 9YPXvWNp0qf503IkOQnI7e66IfqbxZTLKziyVO83cKQMZglltOfuvhf7oSZ8VYA8rYrxFsUAbgF2B68/GqiciIdEI+1sCgzTn1/k8IrbMrVLfR6oL30DFgeLZaYqLpUsuY7pL0XM7I8r7M000dk0BrD43lSvQwRLMTeIozv50Aafz31sDvhUJDmPYkh28OFeF7vqMC9mZMMnBLUE1heKJSCkdvqEqzFT65YZ9Ptez8EVEwhY3yrwYXG4VwOm04UxYrQDxtXBYlPrWqiVFzg+zIgD+IzjoUqFS9HHZ6PUAXq25H+TYr5IN5Bz2p8zamhzvY7z3/W3ZmwjZTSvGAdFj4JAPibxc4e5rsyhMrynPMCGaj+xMalj6vsV6Sce+7ocvephUa1KxyaZpRuC17365ZZVa3CUtBQFTSKTh8vulsRLP3BhtQ0mpeLxT8uq1xf9bfK1g9mreBkBa/LZyFgwbHph2KaewXbBvjT4JyTNpubtSuAvU6yaAkMGj0cgvVwJA2l9el94i2AYlSljJG0WHjFh1eR1sZSjvWjcQbppxuCcHiLzjLM6UDlr65ATSKiUaEnKgrrBLmLk8KoMJUFPIYkPA69lkdZ33PvuYlvIEKj1f2q03LvLuIa7pyTyDxbAOzzkCmQI7khleYiA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/21/25 20:27, Gregory Price wrote:
> This reintroduces a concept removed by
> commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> 
> This sysctl provides some flexibility between multiple ZONE_MOVABLE
> use cases
> 
> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable
> 
> When ZONE_MOVABLE is used to make huge page allocation more reliable,
> disallowing gigantic pages memory in this region is pointless.  If
> hotplug is not a requirement, we can loosen the restrictions to allow
> 1GB gigantic pages in ZONE_MOVABLE.
> 
> Since 1GB can be difficult to migrate / has impacts on compaction /
> defragmentation, we don't enable this by default. Notably, 1GB pages
> can only be migrated if another 1GB page is available - so hot-unplug
> will fail if such a page cannot be found.
> 
> However, since there are scenarios where gigantic pages are migratable,
> we should allow use of these on movable regions.
> 
> Note: Boot-time CMA is not possible for driver-managed hotplug memory,
> as CMA requires the memory to be registered as SystemRAM at boot time.
> Additionally, 1GB huge pages are not supported by THP.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Alexandru Moise <00moses.alexander00@gmail.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
> ---
>   Documentation/admin-guide/sysctl/vm.rst | 17 +++++++++++++++++
>   include/linux/hugetlb.h                 |  3 ++-
>   mm/hugetlb.c                            | 11 +++++++++++
>   3 files changed, 30 insertions(+), 1 deletion(-)
> 
> ---
> v2: changelog updates
> 
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index b325bfbc2611..fe3982604b1f 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -54,6 +54,7 @@ Currently, these files are in /proc/sys/vm:
>   - mmap_min_addr
>   - mmap_rnd_bits
>   - mmap_rnd_compat_bits
> +- movable_gigantic_pages
>   - nr_hugepages
>   - nr_hugepages_mempolicy
>   - nr_overcommit_hugepages
> @@ -623,6 +624,22 @@ This value can be changed after boot using the
>   /proc/sys/vm/mmap_rnd_compat_bits tunable
>   
>   
> +movable_gigantic_pages
> +======================
> +
> +This parameter controls whether gigantic pages may be allocated from
> +ZONE_MOVABLE. If set to non-zero, gigantic hugepages can be allocated

"gigantic pages" or "gigantic hugetlb pages"

> +from ZONE_MOVABLE. ZONE_MOVABLE memory may be created via the kernel
> +boot parameter `kernelcore` or via memory hotplug as discussed in
> +Documentation/admin-guide/mm/memory-hotplug.rst.
> +
> +Support may depend on specific architecture.
> +
> +Note that using ZONE_MOVABLE gigantic pages may make features like
> +memory hotremove more unreliable, as migrating gigantic pages is more
> +difficult due to needing larger amounts of phyiscally contiguous memory.

s/phyiscally/physically/ ?

Can we also reference this parameter here from 
Documentation/admin-guide/mm/memory-hotplug.rst?

In particular, there we also talk about gigantic pages and the 
interaction with ZONE_MOVABLE:

"
- Gigantic pages are unmovable, resulting in user space consuming a
   lot of unmovable memory.

- Huge pages are unmovable when an architectures does not support huge
   page migration, resulting in a similar issue as with gigantic pages.
"

And then later, we talk about "Even with ZONE_MOVABLE, there are some 
corner cases where offlining a memory
block might fail:" where this should be spelled out as well.

-- 
Cheers

David

