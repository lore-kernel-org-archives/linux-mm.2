Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB7E5CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4956A6B00AA; Wed,  3 Jun 2026 16:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445416B00AF; Wed,  3 Jun 2026 16:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D476B00B0; Wed,  3 Jun 2026 16:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE9F6B00AA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:25:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0038163296
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:25:24 +0000 (UTC)
X-FDA: 84839731368.15.75ED7B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 150404000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:25:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4YWQj08;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780518323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmIvnRW/JH4l0jkU+wpLIRsFLhy34ftAmVsUOe9lQk0=;
	b=6XfkRjH3CyNHf7N+jjCvOAKIo1bk9kAfyDsP0Tg9xYOiv2iDbTsvrJbxuhGgngRe8LWFOf
	jq0wcSU5SZrmCPeXEKr27pop0ZjwKjN8tXUENc7vnPafC2pREUGel0BlY1cHTk4XMjR4dG
	U4ARShyLtMGIc5D1hinwaUbbzwy9UTQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4YWQj08;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780518323;
	b=49P3U59+323s1CJYtfuh0uZ5x4+/XYsPTb2gYC6StZ2goqfXPLnKQJ5BUVY0Mvbp3+1ivO
	msg3CbJ2eSVBUjV47I8orYK1LqxKH2vf4VwB1hpFOfnMQiaW/yCm4DY2HB6hu0sUNV9o51
	hRGtAdPIr8rF/T9z0ExtgpMi7wwof4k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF5AB409B5;
	Wed,  3 Jun 2026 20:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137011F00893;
	Wed,  3 Jun 2026 20:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780518321;
	bh=fmIvnRW/JH4l0jkU+wpLIRsFLhy34ftAmVsUOe9lQk0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P4YWQj08fQNEw6TZFl2z7DSm4sqNR2Gz05k5xn8jlteJ/fJ3REtS320d3jdb0Seb2
	 a7ao4f1T6gee2wV+OyFLH+4pBupbXhiyf7Bm6vUJV27Z6U22E8EaIXB1PwM+cG739q
	 ylLXOzQLT2vwSW9+BkMQcNUC8xeLxcnMxCcQS7vVu0U6CBj4GVmMdF6zxtUPkxfiPu
	 84Q+FHCxN5Wq7PLUJ+nDlWIOZ8hQRX8jLcIiZHpYJb0FEe0eulppdOVh0D/gvjIsIU
	 8konRcIQf/YtiOqVZvnf13kXrTVFcghrhvdhtkwnakHQbuZjBWznFBVw0XBdu2FnTT
	 dwO5hkm5Hro5Q==
Message-ID: <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
Date: Wed, 3 Jun 2026 22:25:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
To: tao <tao.wangtao@honor.com>, catalin.marinas@arm.com, will@kernel.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, akpm@linux-foundation.org,
 willy@infradead.org, sj@kernel.org, kees@kernel.org, luizcap@redhat.com,
 zhangjiao2@cmss.chinamobile.com, kas@kernel.org, ljs@kernel.org
Cc: hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jack@suse.cz, riel@surriel.com,
 harry@kernel.org, jannh@google.com, jgg@ziepe.ca, jhubbard@nvidia.com,
 peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, nao.horiguchi@gmail.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 pfalcato@suse.de, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev,
 ryncsn@gmail.com, 21cnbao@gmail.com, jparsana@google.com,
 dvander@google.com, zhangji1@honor.com, wangzicheng@honor.com
References: <20260527110147.17815-1-tao.wangtao@honor.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 150404000D
X-Stat-Signature: 6sr74jbcp4hwqeyyb8apjab5eeh8aey8
X-Rspam-User: 
X-HE-Tag: 1780518322-292477
X-HE-Meta: U2FsdGVkX1/TzRCVwOD3TxxBc49ikcmqsnSL4up4S3vivpQI8Vmqwrnl2h97Jc0d62EWSjDs3LNuE7sjRH8hfIFZrTh+JwjFABoeonxu122+eihDuUtIPZ08iUCMSripQv1u4/hnMCGQIqx94avd3mqljoGYRKJDOrDznsyglN4Ai5HavG7AooqZqOjYwRviLutheRks+Z8NAqtRuQg2FI5DneLUMHNOT+Fb1Omef7DKAq06rIVjFtKL1rnJoJ9mADngmD1Gp4T5XeztC6TZH7OLjLCAgVwADyu4hJJ0km7+MNCn0j0XPlVhCs5qiNLAChar1XWzAp52VUvJrO/sNVaxAyD35PCU0lZWNSxO8X0zwE/f4IuMypMwE+j4kBWHFooR588kdxSp6pIzGmjlLfYihJAKnB+NgsPY9OOyGM0PgVsUdkmK4xtRu9FozDQuzXf6MJ06O+8N0dpRcFlQYeRFB88CvvZ8p/wRemqmSC+JEIEep0xseNqlR/xWqA58vg0y0aTPTzFzPaSvl0nq+GC5eg29W33su/4uAdMp6Ptr4IQuZPMnAn6XYUsHRwm/QlO8XFfZ7Uw47jgiMhNnaeRS5vU8FTmFlTgV6FgAyh/sicRFm2VAKADJYMdcGe50IgsH/Mz7NHS2+uc6sfyqi0OMnrZ2+CJWwOkWI66MfsAIj9eGeVbb/LBkOd99G3dl9q7Xwq8D2Jp2/i3nXlJ+Y+L/gy2FNBvinEzQv0UghmTGxSaVfJkenJ24sy9Zfx/6I26HMTj+S4/AD8wUREaf5qlSaMPr1jiwcnKJKe1uU6Jipql+/qy2CaRk8p/BrhPrQgBI+PVjVRfuz+o01lD3Tpjksvzt4llLNGjr+2xeTO7C0y8IMqHHZKbM65QJwHK91ChbyIk3df6vIakASLQtqKefRvhqb6dVgQjElnDe21KTNgCPoo5q3NYkpmyNjI/L9TJ+2swzxio8phiUJ05
 6em4pKnV
 /c+CW6PbnaQXgkOyuftggX/MLoMjHJm1iZtkUTTxIK+9R6KEyiczLBWGobQPp2UAcbDhkckXHxrSA4xQNjid38HFaTZey5dg8Zg4cKj/pJ4ZLKNhK/CT/wUXThZT8r5+vpxG7ZBFECNg9oI2ytImWbUd3vWadMlSkL+IVLxUmqc+J9DV7U8e6Cij7oTnsqPBA+QD26SyMiumf9X7QQgPdXmB2fv1KaNVH99PizjUVKtcjgwMlrlTuvXOlkAkxti07zgSJndSWRSBqq6wWYIRgdICMv2tBMKcOU7Q1NeCOjFrH8Sid+fORcKkuxi5DxWvSzGgrmRtvTZsILguUTB5F3P8BHks1inu7XD72kCbjBHpoo4cTZQLE0mTs8dYP67YfBSNPG1gWv1MvC/Nafea8Iw6yXkt7PUNEqXJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 13:01, tao wrote:
> TL;DR
> -----
> 
> This series introduces ANON_VMA_LAZY, which defers anon_vma creation
> until it is actually required.
> 
> - anon_vma memory reduced by ~92-97%, anon_vma_chain reduced by ~50-57%  
> - rmap operations on ANON_VMA_LAZY VMAs do not require anon_vma locking
> 
> Background
> ----------
> 
> Currently anon_vma structures are created eagerly when anonymous VMAs
> are initialized. However, many VMAs never participate in fork or rmap
> operations that require anon_vma chains, so the allocated anon_vma and
> anon_vma_chain objects are often unnecessary.
> 
> Design overview
> ---------------
> 
> ANON_VMA_LAZY defers anon_vma allocation until it is actually needed
> (for example during fork). VMAs that never participate in sharing can
> avoid creating anon_vma structures entirely.
> 
> Before an anon_vma exists, rmap operations rely directly on VMA
> information, so no anon_vma locking is required. An anon_vma is created
> and linked only when sharing semantics are required.
> 
> This series introduces anon_rmap helpers to make rmap less dependent on
> direct anon_vma access. It also introduces anon_vma_tree_t as a container
> to support both the lazy and the existing anon_vma layouts.
> 
> Once a VMA becomes associated with an anon_vma, the normal behavior
> remains unchanged.
> 
> Memory impact
> -------------
> 
> Preliminary measurements show significant reductions in anon_vma-related
> slab allocations.
> 
> After boot:
> 
> Object            | Before (active KB) | After (active KB) | Change
> vm_area_struct    | 117035             | 118176            | +1.0%
> anon_vma_chain    | 18865.8            | 8112.06           | -57.0%
> anon_vma          | 20426.4            | 613.75            | -97.0%
> 
> After launching 24 apps:
> 
> Object            | Before (active KB) | After (active KB) | Change
> vm_area_struct    | 196873             | 197345            | +0.2%
> anon_vma_chain    | 31477.1            | 15576.8           | -50.5%
> anon_vma          | 33280              | 2648.12           | -92.0%
> 
> Simple fork microbenchmarks also show a slight improvement in fork
> performance, since child VMAs do not need to allocate anon_vma
> structures during fork.
> 
> Feedback and suggestions are welcome.
> 
> 
> tao (15):
>   mm/rmap: introduce anon_rmap APIs for anonymous folios
>   mm: convert anon_vma rmap APIs to anon_rmap
>   mm: introduce anon_vma_tree_t for multiple anon_vma topologies
>   mm: switch to anon_vma_tree_t APIs in preparation for ANON_VMA_LAZY
>   mm: add CONFIG_ANON_VMA_LAZY and folio helpers
>   mm: add CONFIG_VMA_REF and VMA helpers
>   mm: replace direct FOLIO_MAPPING_ANON usage with helpers
>   mm: prepare rmap infrastructure for ANON_VMA_LAZY
>   mm: implement ANON_VMA_LAZY rmap semantics
>   mm: defer anon_vma creation with ANON_VMA_LAZY
>   mm: handle ANON_VMA_LAZY in huge page operations
>   mm: handle ANON_VMA_LAZY during migration
>   mm: support setup and upgrade of ANON_VMA_LAZY folios
>   mm: support merging of ANON_VMA_LAZY VMAs
>   mm: enable CONFIG_ANON_VMA_LAZY on arm64 and x86_64
> 
>  arch/arm64/Kconfig         |   1 +
>  arch/x86/Kconfig           |   1 +
>  fs/proc/page.c             |   6 +-
>  include/linux/mm.h         |  38 ++
>  include/linux/mm_types.h   |   9 +-
>  include/linux/page-flags.h |  34 +-
>  include/linux/pagemap.h    |   2 +-
>  include/linux/rmap.h       | 165 ++++++++-
>  mm/Kconfig                 |  22 ++
>  mm/damon/ops-common.c      |   4 +-
>  mm/debug.c                 |   2 +-
>  mm/debug_vm_pgtable.c      |   2 +-
>  mm/gup.c                   |   6 +-
>  mm/huge_memory.c           |  16 +-
>  mm/internal.h              | 171 +++++++++
>  mm/khugepaged.c            |  13 +-
>  mm/ksm.c                   |  43 ++-
>  mm/memory-failure.c        |  11 +-
>  mm/memory.c                |  19 +-
>  mm/migrate.c               | 126 ++++---
>  mm/mmap.c                  |  15 +-
>  mm/mremap.c                |   4 +-
>  mm/page_idle.c             |   2 +-
>  mm/rmap.c                  | 690 ++++++++++++++++++++++++++++++++++---
>  mm/vma.c                   |  76 ++--
>  mm/vma.h                   |   4 +-
>  mm/vma_exec.c              |   2 +-
>  mm/vma_init.c              |   1 +
>  28 files changed, 1279 insertions(+), 206 deletions(-)

Hi!

When I saw the diffsat I was concerned. Going through the patches made me ...
more concerned :)

This is a lot of complexity. On top of something that is already so complicated
that I fail to grasp most details without regularly taking a look at the nice
figures Lorenzo created recently.

For example, I read above "since child VMAs do not need to allocate anon_vma"
and wondered how that could be part of something that is just done lazily. Then
I had to learn in the patches that there is some additional "Child VMAs
are created as ANON_VMA_TREE_PARENT and do not allocate anon_vma" -- excuse me,
what? :)

Reading about VMA refcounts made me shiver. Reading "Holding only
folio_lock(folio) cannot guarantee that the split
operation completes atomically." confused me. Learning that we have to invent
interesting ways to make page migration mutually exclusive to free_pgtables()
concerned me. Figuring out that there are arch-specific config options and
runtime toggles is a clear warning sign.

Seeing test_folio_unmapped() was funny, though (why?! :)).

I think this patch set has a noble goal of reducing anon_vma overhead when anon
pages are not shared during fork. However, using anon_vma for them actually
makes the overall implementation (e.g., rmap walks, locking) more consistent and
simpler.

Even if we could be convinced that most of this here is correct, how should we
reasonably maintain this increasing level of complexity here?

I won't echo what has already been said in this thread (and I didn't manage to
read all, unfortunately), but for such big and invasive work it's often best to
get in touch with the community earlier. Otherwise, you might end up wasting
your time.

Ok, arguably, someone who writes that code learns a lot on the way. And if this
code really was written by one developer only, I tip my hat! I'd be curious if
that code already ran somewhere on some Android kernel out there?

But adding more complexity on top of something that's already extremely
complicated to save some memory looks like the wrong direction, really.

I was excited when Lorenzo started working on a completely new approach that
would focus on improving the common cases while trying to reduce the overall
complexity. Because I think most of us really dislike anon_vma. It's still work
in progress, and I am sure there are some rough edges.

But fundamentally, I think we want to find a new design that is just naturally
simpler.

Lorenzo has been hard at work exploring various design options (and I'm afraid
he might be one of the 3 people on this planet that understand anon_vma in full
detail), so I suggest we wait for a redesign proposal from him and see if that
is doable?

-- 
Cheers,

David

