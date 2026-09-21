Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8BDC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34986B0088; Mon, 21 Sep 2026 05:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE58C6B00DB; Mon, 21 Sep 2026 05:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3886B00DF; Mon, 21 Sep 2026 05:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4EF6B0088
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:51:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D482D140535
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:51:15 +0000 (UTC)
X-FDA: 85237301310.21.3E055C8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id E9B7C80003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:51:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PwNXaD+0;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789984274;
	b=wjvfshEjbyZ0ZYkYt5xP1rVnvEvPU0tU5onOfvsbuE5bdWehQDwIZ+fuxYmz38GgoMra7g
	egxMZ0Kt4NDS6IpjKMGCvd+wlRLIAtB7jVnXFDO8wOol+3ysTLCc9mrdFa/FNCCajgwM5k
	5+tOFUtwysE/7iZ6D53wpEb9l9IIqFw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PwNXaD+0;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789984274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd1jRqYPXZwU2hXU1MHVfUpexFL0QG0Ad5Vt2W87lxs=;
	b=TKUAAyOTZxrXJCTGONPQanKGCMhkzDhKFKxEOsxZFLVzPmY7fDu0Z/Nr8Wkmw5VcadXNFu
	o5Vqr8dmbMwYpyEIM0cXV3ZdthZmC3K4Kqr7GAQYUVI/qph2ZurFprO4bAVr8rjguUsTH2
	e0alPOCoV8XGH7o8TBgZsOOYDNCIOoM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A778153B;
	Mon, 21 Sep 2026 02:51:09 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F7573F86F;
	Mon, 21 Sep 2026 02:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789984273; bh=Yh04mAUW/tMDEOlWdN+OXJwoGQ3qq3vUxi4DFjfm1GY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PwNXaD+0WUdgUn9Bq7v/HPrz6iSdG1Ka6YECPv9iF0/ZzjF26pxz1O08q0ccMYQOB
	 bwL5+mucY5hunLe30UlgLiO6VVb5ARI9CGDPOGyQ+uv4FlLL6YtNVCUQHpoIMJEw4b
	 NXAtZ3P9Af5w6Y40kU8Ymb3s0bMrOwUXnW+78CFE=
Message-ID: <27fb625b-7117-4666-9a34-3b8aa9a43833@arm.com>
Date: Mon, 21 Sep 2026 10:51:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] arm64: distinguish HW PTE pointers from SW PTE value
 pointers
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E9B7C80003
X-Rspam-User: 
X-Stat-Signature: 1sy5fkh48s49gsjqpp1t86wsy1juf3ss
X-HE-Tag: 1789984273-274634
X-HE-Meta: U2FsdGVkX1+fMQsoU++YsFuFlBT9LfqvJrjl31Vp2XmoCtVfAWfITacPILvah/Y2Nq0w6PpsmcRDs+Qjslj9447oJTYrDGlT5gN5Yvx+WdzwKN8YtIXk/r/mUVuLzr56YGcPf3XjW0h8TourFOQyzcWP1yaoOh1VJOLCnieaCDi2P5JBMH2B6dVrwzGrJIqLXpXrcyG2qsTqWTm52HGVQl6Dl9B5ME1w73A/x9agkwm2L6G8vRZpQGgeLpfEbfDnZal6WF2ObdOgoEFeUJbMQwbzRlPUfj73cC4AKHMnXQVZZ8mka8pikMdcHziD9Q6gXBfkqBrmwyrAAKrtORd2f4nBYL7fzVsACEWt/j/ucbnwejoGEszX4MjSsTzV7HIRfE5CD1s9YkzLjqkmXJLgsawKGpggmL1NbNFxApZYyxZkIF4h7p3E+DQLgvntx++FrKzNFr89tjzZGyidCw0aKSWD59LJGoxaQkFekQf4a4qJHi/Jlz1d8FtWPwsB02bing5gpPkxAhBBxv4a6se89pdNCykjA5EhOGRk/8bjn+0OzzdvsEk/xk2ejyNGmMKsDY61jDZrXKO8jYzGMAZyJARHvBmfGVRG5bpJ1RZlCeq0BgZlK0i01p5sXnbbd5TKXKhlNY1VlpredA5vFZAeu+oMBCyHk+oFbPYLbpi4AsIlgpaZbkCroisqyaPcSF81JAT3Vt12B7e9gnwMUSwnPLFm9xCcQWq56rTUsUcXhPhBLNOG6WxSeo0nx2PRhOFGriIzbbwYQ7xNfZYHX8KBxuXWRWdjJ5zptRrZ8OwKm5VbBWDOjpV+eq3fB7dBibDup3shNj5wC0p9I6FSo5j6GJ95Uzlw27ldIpAm/47Y2lY+A8Sx+erpgtWDoWMwKufMGLsjTfDwWp5iSIPSw4vwcDZeoHNqe13YZO1g3iCr3TImyJGDvxMwK/J+dCYf6w1bHb/6w1vKyuXDwSjkfPW
 Ln/pFGK3
 v/Xt7Y6h5i147AAomowQEUccvYyln+yZ18zaEva2jx0jYmJikPAJ1xIC+yLk41PTCT6i/l9RnaeuUdKNMyPHZKJQSZrJ5jEhe0BLt//zs+1oeO4q4Jithjkl45R0WfRfJzY4tyPzm22lSu2ikmjiNEuad6aBs7YpCt5gAVva8DQMXFKx4mlQp+klUK8/hMIWsAw+HVTEUr/fAKDj19Oqc9q8uGbzQRLPze1bGStS2YLGCJx3QugH6VSTxZp04yNTIOdOE20+0oIjzI6Jo1RBxA4HnZwmcNmGzEhpQe7o2Sgg2JRXkV56LrHIzjYXr/n94gSzqaHvkjn+74y8K/2F1gv0xoikoZIvnZ+uYszbJ82WEIHucDzzqfkSkLwNvwmkXtHck0te65iOlQ70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> Hi,
> 
> The generic series introduces hw_pte_t for HW PTEs, while SW PTE values
> use pte_t. This series enables the distinct type on arm64 so the
> compiler can distinguish HW PTE pointers (hw_pte_t *) from SW PTE value
> pointers (pte_t *).
> 
> The conversion updates HW PTE pointers and accessors, including atomic
> updates, fixmap, and early page-table construction, before selecting
> ARCH_HAS_HW_PTE_T. Higher-level entry types remain out of scope, and
> shared helpers retain explicit casts.
> 
> The linked generic series is a prerequisite. Its cover contains the
> Coccinelle script used for most pointer conversions; the remaining sites
> were converted by hand.
> 
> Link: https://lore.kernel.org/all/20260903103002.1091859-1-usama.anjum@arm.com/
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

I've been through this as best I can and provided some minor comments. This all
looks ok over all. But given the number of small changes, it would probably be
wise to go big on testing; what level of testing has been performed? I'd suggest
mm selftests (with all the magic to make all the tests actually run) at minimum
and all the fastpath benchmarks as a stress test.

I think it's quite ugly (and adds a bit to the cognitive load) to have this
intermediate state where only ptes are converted. But I understand the need to
do this incrementally. Hopefully you can follow up with the other levels soon :)

Thanks,
Ryan


> ---
> Muhammad Usama Anjum (6):
>       arm64: use hw_pte_t for HW PTE pointers
>       arm64: use hw_pte_val for HW PTE atomics
>       arm64: convert between HW PTEs and SW PTE values
>       arm64: use hw_pte_t for fixmap HW PTEs
>       arm64: use HW PTE accessors in early map_range()
>       arm64: enable a distinct type for HW PTEs
> 
>  arch/arm64/Kconfig                |   1 +
>  arch/arm64/include/asm/hugetlb.h  |  19 ++---
>  arch/arm64/include/asm/pgalloc.h  |   2 +-
>  arch/arm64/include/asm/pgtable.h  | 157 ++++++++++++++++++++------------------
>  arch/arm64/include/asm/vmalloc.h  |   2 +-
>  arch/arm64/kernel/efi.c           |   3 +-
>  arch/arm64/kernel/pi/map_kernel.c |   4 +-
>  arch/arm64/kernel/pi/map_range.c  |  20 +++--
>  arch/arm64/kernel/pi/pi.h         |   3 +-
>  arch/arm64/mm/contpte.c           |  49 ++++++------
>  arch/arm64/mm/fault.c             |  11 +--
>  arch/arm64/mm/fixmap.c            |   8 +-
>  arch/arm64/mm/hugetlbpage.c       |  48 ++++++------
>  arch/arm64/mm/kasan_init.c        |   4 +-
>  arch/arm64/mm/mmu.c               |  46 ++++++-----
>  arch/arm64/mm/pageattr.c          |   4 +-
>  arch/arm64/mm/trans_pgd.c         |   4 +-
>  include/linux/pgtable_types.h     |   6 ++
>  18 files changed, 215 insertions(+), 176 deletions(-)
> ---
> base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
> change-id: 20260911-pte0_arm-f1b7df7c0b51
> prerequisite-message-id: 20260903103002.1091859-1-usama.anjum@arm.com
> prerequisite-patch-id: 0114fcc6ab0dbb739b5bb6fc0fe6b1c8f1fa37a1
> prerequisite-patch-id: 09fcf65970074620dd3a9cce6850b901beb01db8
> prerequisite-patch-id: 9b2fdab97c99effabb85526fa7f141c933b3aa23
> prerequisite-patch-id: 1aa309a26d98a1e93a54742705a03567ee93be71
> prerequisite-patch-id: ebe32f52c95ad0542982f0b37798d209595e25e1
> prerequisite-patch-id: a60d249f52d092524176851b2570d7245bb24434
> prerequisite-patch-id: 81ebd1378e25d40a1771b53973abcc4defa87535
> prerequisite-patch-id: d982f2b00c5eddb2459f69008a73e4f4ae4d8299
> 
> Best regards,
> --  
> Usama
> 


