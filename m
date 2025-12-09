Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14118D1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 04:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AED66B0005; Mon,  8 Dec 2025 23:43:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38C226B0007; Mon,  8 Dec 2025 23:43:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C8F6B0008; Mon,  8 Dec 2025 23:43:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18CEE6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 23:43:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EE67C0459
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:43:41 +0000 (UTC)
X-FDA: 84198689442.11.15043B5
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 421A74000D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:43:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z4RaZnHR;
	spf=pass (imf11.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765255420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHaNF3NLkUcld+qJXROnyemM10ER7BqRqDwEKLhFDTo=;
	b=HDt2IeF2uhk90YUjUHK4J7wbc8YZenDdXKg0uGwOKpgFzkEBJ8xvp76gjyQAiIIlUIvesL
	DYr0urCvGmSl9Nl5IC8f22l1uUpt8dod2KCKG4/w9RlbrIWF0//i6DuUUU9GazB0mu5Q2P
	wiVX8pUlgt8JyHliAAm9JizWgzN5ptM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z4RaZnHR;
	spf=pass (imf11.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765255420; a=rsa-sha256;
	cv=none;
	b=qITr98xmXU3hRMUJZblTRYPEaKpwh3RFLesBjIjCuqIEfeGSAvwImxg2owKqFnPAdis0ct
	YzhslppAE0a6Gakh6UKLGUm4S5PY1CeFDTFIk39sB3+6qPGS+ZRMAO+iV7BnFbAw+ooqzq
	mzcoAqgaYFTY82m1EmsyLuow55kyuAM=
Message-ID: <48d0b46e-2b82-44b6-a717-94bc258a508d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765255412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHaNF3NLkUcld+qJXROnyemM10ER7BqRqDwEKLhFDTo=;
	b=Z4RaZnHR0fIYk8Sv17Zr2mt78F7d5wPSTnieVtot08w35Gl9cmheLnXS1geWFqfwS5eRjd
	1dTnwFOYF2fDWvGYEP78fX93UW/XAMectuyHfrIbLeXZ/1SUE3Wvlt7Wf38yfm1OVCIGG1
	TiwkOIHMVpMwzQZpKOK079f7PElyX4c=
Date: Mon, 8 Dec 2025 20:43:22 -0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH 00/10] liveupdate: hugetlb support
To: Pratyush Yadav <pratyush@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>,
 David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kexec@lists.infradead.org
References: <20251206230222.853493-1-pratyush@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ksrk1zq6uprnqrn3feb4pb16kuqmtimj
X-Rspamd-Queue-Id: 421A74000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765255418-84191
X-HE-Meta: U2FsdGVkX1+eNnaE6VHUjRngIHFEGlUPKNNiicKRyVMfAPTd0m0JwPGG5KIq2V/EBJ7KZl84Vv2wCWNp5UBxR0l3diAVH1z0gG9ImrSzbR8wXqREqSQO0hbQZbx6tWeomZa3RPKp12GeFyN9J/I56Qta7Ob+HgFDnOdjD28CIxC9wlCZZLJx94jy0qUWE4OoQqe6SyyLRDwZ+j4gzbvX1XSdeb2c9TQqfLYBawoxMMIJHas+uiMcOfduEGBGVVBrdkDb9HHXrEgq/NvtJmeaBq0orBmP0Q/zHrNNSHNVDkgsZjf+LqHOF6fbZkF661LTxe+5w7xGuH0mHCfHRQSbgF1kLpvFxWSFgQQA4CE10x0YhszMgy7tRPfAeWyECmEybt39RMNcTAm37iQipjTE4Q+Lun4+yueNfTZTIZ9aJ2xS+M60pwJhrEXXUN4NDh+9YdryLIf+nw0FyoIdPBnoOQX6oH2EPIk+PJ6Kde4re5GKe74rDzkRwVvjkuv3gEuN9FT5Z4miwY5b4X6uj3NOp1mAc/M71ouiT1EBslB2wIhKEQF+kgq6zLnHJeFFlBLKbEM9jjWVK2ZgOFZNqiVs9NZf4mOZffrYybMNePRkZGv7ApDpA4m/mbMPPRbIlvX6pumrwqq20xTkjDvx6WeSaU6h/KXDJvqY3eSI9qyWtEHNTOoF08kcVCTXDCuaMg1ahlzJ0FQja2lw9LfURXbKxoGbWg7iFbedgCYLwwIxciGamYZTczp9RwtBAyEuPZlkcwG16hkTtkq5ONTKTY+nvN46Oq8MPt6Jkvf/kKvXYjxh5QiCxFIPIyngjhnpR8juLMslrzbGeHr6jUsZncDG1R1DvNsKyk1HCYQwL7T2mi8KToJtpxoJAxgI+h2K5hV5PszxtcyNuxAtAeaoz0rfgW+7B6fInyZXjErOj7QZfO1GIIkG2x5jKjCPBFMZ9wnQbtunrzGSe9nTibj45U6
 /r+7zG2G
 R+kcnP/EZEEiv0EnjeSF/61Jq0Z+pExGfyfpxRmzILPYly0vtkKL4tv2tNczQ+CIYbtAAfmRl2B8k1OCcpBrhqdiJ8NT5VyRdTI3uvUS+1GkbwzEczIFhQKlpDILH9ekA9qTqfDPpNTZZllZeBp+V6WRdPPosHAfrFW8a5Sr6f1veDVsLJO4e480TBooiH/cPgelCelOwG++/oecxAPN3vTk7mew9o4dgISLgjNmY+iH6KrSpZlMKxD3U7OqB2qzRmMuT25fcqbb8dpRlCamwUK7mFGFRoyGwISLXlhbXP8goLOvqHzoDmfxKAcIHhWEH3Q7zTj/RVzvVIHM0I8jKDPVGDryC3/qr2Vc6R7xUkSIfr7GrKOBQt1F6rDX0VkWSJIEOKwBBfZr60p0StKd/Mp7f73ZEiMFZAu3IHklTjppTf7AwLI57GU5HUg05w6QjMF2wHg4hXhY8/PtNKyj6QY+NJEyMJqeDBZF94IRLfBCDS9TlXoiiCNczTGc/5dwymnqQ4oaD3lL32mI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/6 15:02, Pratyush Yadav 写道:
> This series adds support for live updating hugetlb-backed memfd,
> including support for 1G huge pages. This allows live updating VMs which
> use hugepages to back VM memory.
>
> Please take a look at this patch series [0] to know more about the Live
> Update Orchestrator (LUO). It also includes patches for live updating a
> shmem-backed memfd. This series is a follow up to that, adding huge page
> support as well.
>
> You can also read this LWN article [1] to learn more about KHO and Live
> Update Orchestrator, though do note that this article is a bit
> out-of-date. LUO has since evolved. For example, subsystems have been
> replaced with FLB, and the state machine has been simplified.
>
> This series is based on top of mm-non-unstable, which includes the LUO
> FLB patches [2].
>
> This series uses LUO FLB to track how many pages are preserved for each
> hstate, to ensure the live updated kernel does not over-allocate
> hugepages.


Is this patch serise based on the patches in the link 
https://lkml.org/lkml/2025/11/26/1665?

Thanks,

Yanjun.Zhu


>
> Areas for Discussion
> ====================
>
> Why is this an RFC?
> -------------------
>
> While I believe the code is in decent shape, I have only done some basic
> testing and have not put it through more intensive testing, including
> testing on ARM64. I am also not completely confident on the handling of
> reservations and cgroup charging, even though it appears to work on the
> surface.
>
> The goal of this is to start discussion at high level points so we can
> at least agree on the general direction. This also gives people some
> time to see the code, before the session discussing this at LPC 2025
> [3].
>
> Disabling scratch-only earlier in boot
> --------------------------------------
>
> Patch 2 moves KHO memory initialization to earlier in boot. Detailed
> discussion on the topic is in patch 2's message.
>
> Allocating gigantic hugepages after paging_init() on x86
> --------------------------------------------------------
>
> To allow KHO to work with gigantic hugepages on x86, patch 2 moves
> gigantic huge page allocation after paging_init(). This can have some
> impact on ability to allocate gigantic pages, but I believe the impact
> should not be severe. See patch 2 for more detailed discussion and test
> results.
>
> Early-boot access to LUO FLB data
> ---------------------------------
>
> To work with gigantic page allocation, LUO FLB data is needed in early
> boot, before LUO is fully initialized. Patch 3 adds support for fetching
> LUO FLB data in early boot.
>
> Preserving the entire huge page pool vs only used
> -------------------------------------------------
>
> This series makes a design decision on preserving only the number of
> preserved huge pages for each hstate, instead of preserving the entire
> huge page pool. Both approaches were brought up in the Live Update
> meetings. Patch 6 discusses the reasoning in more detail.
>
> [0] https://lore.kernel.org/linux-mm/20251125165850.3389713-1-pasha.tatashin@soleen.com/T/#u
> [1] https://lwn.net/Articles/1033364/
> [2] https://lore.kernel.org/linux-mm/20251125225006.3722394-1-pasha.tatashin@soleen.com/T/#u
> [3] https://lpc.events/event/19/contributions/2044/
>
> Pratyush Yadav (10):
>    kho: drop restriction on maximum page order
>    kho: disable scratch-only earlier in boot
>    liveupdate: do early initialization before hugepages are allocated
>    liveupdate: flb: allow getting FLB data in early boot
>    mm: hugetlb: export some functions to hugetlb-internal header
>    liveupdate: hugetlb subsystem FLB state preservation
>    mm: hugetlb: don't allocate pages already in live update
>    mm: hugetlb: disable CMA if liveupdate is enabled
>    mm: hugetlb: allow freezing the inode
>    liveupdate: allow preserving hugetlb-backed memfd
>
>   Documentation/mm/memfd_preservation.rst |   9 +
>   MAINTAINERS                             |   2 +
>   arch/x86/kernel/setup.c                 |  19 +-
>   fs/hugetlbfs/inode.c                    |  14 +-
>   include/linux/hugetlb.h                 |   8 +
>   include/linux/kho/abi/hugetlb.h         |  98 ++++
>   include/linux/liveupdate.h              |  12 +
>   kernel/liveupdate/Kconfig               |  15 +
>   kernel/liveupdate/kexec_handover.c      |  13 +-
>   kernel/liveupdate/luo_core.c            |  30 +-
>   kernel/liveupdate/luo_flb.c             |  69 ++-
>   kernel/liveupdate/luo_internal.h        |   2 +
>   mm/Makefile                             |   1 +
>   mm/hugetlb.c                            | 113 ++--
>   mm/hugetlb_cma.c                        |   7 +
>   mm/hugetlb_internal.h                   |  50 ++
>   mm/hugetlb_luo.c                        | 699 ++++++++++++++++++++++++
>   mm/memblock.c                           |   1 -
>   mm/memfd_luo.c                          |   4 -
>   mm/mm_init.c                            |  15 +-
>   20 files changed, 1099 insertions(+), 82 deletions(-)
>   create mode 100644 include/linux/kho/abi/hugetlb.h
>   create mode 100644 mm/hugetlb_internal.h
>   create mode 100644 mm/hugetlb_luo.c
>
>
> base-commit: 55b7d75112c25b3e2a5eadc11244c330a5c00a41

-- 
Best Regards,
Yanjun.Zhu


