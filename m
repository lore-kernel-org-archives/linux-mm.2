Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DEEC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7790B6B0092; Tue, 25 Aug 2026 03:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A3E6B0095; Tue, 25 Aug 2026 03:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618CD6B0096; Tue, 25 Aug 2026 03:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 347486B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:12:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75674C0200
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:12:45 +0000 (UTC)
X-FDA: 85138924290.02.ABD0D1D
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf21.hostedemail.com (Postfix) with ESMTP id 254FA1C0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:12:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RZ2vBCYU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of atish.patra@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=atish.patra@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787641963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3306+CUzdH8GiI988xRpOo9PofrRR1DqWx90ydnRE9A=;
	b=pW97N9TcgoZRpLvNv0RSAfxgenf2RT5upS3/acL7/ZGUbeMS6FYu/l4ZHuD6Z5hWu9soeu
	7F66+/5LolWQA05uQSV/oI9D/p5F5LXnnl8ViO4Cde2bCEvhFmg/vQvhqYWEtwcZOJ3SU4
	1Cbly/9Ah7hRT4+ntIzm59TSTO8OvVo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RZ2vBCYU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of atish.patra@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=atish.patra@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787641963;
	b=TV+2GCKg3V2CExorVc/fCKnzgtesvRrRIcsC3euPW4A/oSkweecCxvluoTu+qUprY26t3y
	8UY6wLz+JJy0P30EUocnLt6AkYtigiR1X6DYcseXOS6aJMxl2+c/JitX0a3kEYAOGDjsHn
	emLI1MKKPDGSwKC7ThnmQZA0fvI12y8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vrqAFbQm5tBczLY4hb4nFOlOxMC1/kc+DDXxwinK16Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787641961; v=1; x=1788246761;
 b=RZ2vBCYUJdlQ2ouUbpplBqf0V0IfdZLhmUhRPBFubqs5J7C1o2Tl/sLF4DvU+JPz3goGPA4R
 RSBGovrjrO7ZisJXlZQiZkwYt42mBOr1XRwPC7WU1sU6cVt7G1eSIrfHWh2tFlOetQZGPNxIwu5
 EOiCcFpU4qevjltscGqgZmaE=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2620:10d:c085:21d6::12f9] (2620:10d:c090:400::5:e4ca)
	by smtp.migadu.com with ESMTPS id 29ba699e53c601c6;
	Tue, 25 Aug 2026 07:12:41 +0000
X-Mizu-Trace-ID: 29ba699e53c601c6
X-Migadu-Flow: FLOW_OUT
Message-ID: <556337a8-5e2b-45fe-a1ba-90a90c1f3c4d@linux.dev>
Date: Tue, 25 Aug 2026 00:12:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] x86/mm/pat: CPA fixes
To: Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>,
 Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Pedro Falcato <pfalcato@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Steffen Dirkwinkel <lists@steffen.cc>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, syzbot@syzkaller.appspotmail.com, x86@kernel.org
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
Content-Language: en-US
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e5y7hcfsqj7sya1uz1whwu6xtnqc9ya5
X-Rspamd-Queue-Id: 254FA1C0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787641962-818421
X-HE-Meta: U2FsdGVkX19AjqWSTgzFf9xdAx1IqmXkHV57kaZZ9tVaKDHQZW2MteKa/fV/7Xrda4JU5ptOOUAgK15Tw0Ov+sv7TB82OPBxIEx6XNxlyLs4yS0/DoEmQ3hs4Is5N75B4H7TMzhSPyJ0oWFNP3626syYHXX2EYaeoKBNwDTfDlxVzflQGvOTfheM0+tu8nyzZzNAghDtzW5wgkrB9VFIXFTUPy4dfgtrm3zwL7xK58lFZgJZthiHkrTKU/SXriHfShUm9lUcOWYUuRHMT9sBj/86R1fV+bOn4RY6/1GysQQRMG7h21PCi4BZwz4/eCr0FtNDgXdXy683Y74Rgcmk/AvOezLBGRMyvUPdw2pwSW84uf07qsfgZ+5SipBIra3a4OfeT/z5mn4wuwuV1YbE+za8V77g/oGlWySu7PW3SkuoQkv4XQEU2Lc//DmwKokOSq4/cIRu43LwjB6SNErCkIFX7uw7owiZsDfAG6cWxx9NKxkVe+R7FtIO6A9BCwXgYy2QgE5r6zzBn0LDL1dFiMVnoTlzcPpBah6XtyX+ROhufxGkzhg0bDYOldT4YrsUf9+W24lQRM4MU8PZmILTIPcgt54/jZ+IGRFhwCudL2pspdDFHKT6BwRirLRnHVe0y8q1rIJGNVPdQS6ZfL1R5G4xTnfx7ssXJsZjHZeo5egj7Vx6+6Zf53P7KH9NqIBNi3fGStl5zHlZay058jEWju5Uhq5rNQFX+uo9+ayr90LAxh0WWPP2teTYJzDpRW85+06f2UmyblvXKHtIi1/ahxPJSmMvLJ7DuldgUvuTd57js5pXADWOXw5K8/jPY9C/zMKK7RxOVPW2CfskAJKcoaHeHRDo00kGqCH3uBv4yjMNRmThs9JTRMVEdQRycKaIoYSBjqA7tc35HclNKDce0GS/efsMRTm2hvg1s32gyJw+nL3v7x2Zrv1YiVyaumGqAIOtH7ldv9gqghiK7AH
 8MLipBvh
 EnZuU2sNjRml/L508bxIAe+oCCxM8ZXvwGHVzKOvEaYexAvTh7DKDamDe9JMqEOeEfkjjLeb+/reLYCRSfbI/xH3C4q2RBUHD/g2G2/BQoxpTbWtFSSrKV+K2btLtL+jN5j6LoCJO8SL2bl+CZF0hF5fLsuOK5fwtloGCE/+UfXuxAKXqcAr1iQsXXCx6mZBShRAbgIn8iv6noYsD62H68XaWhcq5RnsyMVgRvILIWIdUkB5KmujL1LkgOnrU3k8cz0LWyVtzLyjPV5GjbYMdOHLKfpFlve1rL0BKfvQwJlsVwvRUnNM6BHyc2UPQtvXeDnj6NouVpZU9E90GiAoJx5Y62VA4nTPMaSD2458EGbK4uf0bkcsmUKXUpTAT32lqYYhhE9r77OKQvfkbI9oO8NL0P44hu2KAiD5nrsstchVcwSbmHr4feHKe5Km5+WRqSNPFuausC10QB36N2AhndFZkCVxy0P27vtyBVG5l2j7ODSj4brDSEBbCRUpklimHxnDU96KWJLIySGRjuTgisbTJTnHRgAksyo8DkFbKbfOSBFFL6j3llhGP59BIw8HyMWHwNMXsX2HibJ4rLWckDfc/pALTUJm/1Sru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/13/26 2:01 AM, Mike Rapoport wrote:
> The first three patches are urgent, the third patch fixes BUG() reported
> y several people and it depends on the first two.
>
> There were no bug reports that the last two patches fix because bug
> manifestations won't yell at users.
>
> TL;DR version:
>
> There are a couple of CPA fixes floating around:
>
> Denis Lunev fixed races between split and collapse of the large mappings:
>
> https://lore.kernel.org/all/20260715183453.2381141-1-den@openvz.org
>
> Lorenzo Stoakes fixed UAF caused by races between CPA and ptdump:
>
> https://lore.kernel.org/all/20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org
>
> and an issue with stale page tables in IOMMU:
>
> https://lore.kernel.org/all/20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org
>
> Mike Rapoport fixed a check of RW attribute in lookup_address_in_pgd_attr()
> used for the verification of RWX:
>
> https://lore.kernel.org/all/20260715144519.934289-1-rppt@kernel.org
>
> Pedro Falcato closed a race between text poking and collapse of large
> pages:
>
> https://lore.kernel.org/all/anCK3eWFMwZqq5ka@pedro-suse
>
> Some of the fixes got merged into x86 tree, some of them got merged into mm
> tree and some are still hanging in the air.
>
> The changes here are collected from all these fixes into a single coherent
> set on top of tip/x86/mm:
>   
> * fix for races between CPA and ptdump causing UAF
> * update to the fix of the race between split and collapse of large
>    mappings
> * fix for races between CPA and vmalloc_to_page() in text poking
> * fix for stale page tables in IOMMU
> * fix for effective RW computation in lookup_address_in_pgd_attr()
>
> ---
> v2 changes:
> * rebased on the current tip/x86/mm that includes peterz's changes for
>    DEBUG_PAGEALLOC
> * added fix for CPA vs text poking race
>
> v1: https://patch.msgid.link/20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org
>
> ---
> Lorenzo Stoakes (ARM) (3):
>        x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
>        x86/mm/pat: acquire init_mm read lock on attribute change to avoid UAF
>        x86/mm/pat: allocate split page tables as kernel page tables
>
> Mike Rapoport (Microsoft) (1):
>        x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()
>
> Pedro Falcato (1):
>        x86/alternative: exclude text poking against change_page_attr()
>
>   arch/x86/kernel/alternative.c | 39 ++++++++++++++++++++++++---
>   arch/x86/mm/pat/set_memory.c  | 61 +++++++++++++++++++++++++++++++------------
>   include/linux/mmap_lock.h     |  2 ++
>   3 files changed, 83 insertions(+), 19 deletions(-)
> ---
> base-commit: 7da514d819a0afb148634aac92b3d190f34947c3
> change-id: 20260727-cpa-fixes-d3c73c075672

Reproduced and verified this series (patches 1-3) on 4vcpu guest running two different kernels
1. mainline (commit: 77ae27fd98f3)
2. Ubuntu Resolute 7.0.0-26 (production kernel hitting the issue in a VM)

The Reproducer consisted of
1. A debug patch a cmdline-gated stall between the two *pmd reads in vmalloc_to_page()
2. One taskset-pinned insmod/rmmod worker per module over stock cfg80211/dummy/veth modules

With the above reproducer, both BUG within seconds in unpatched kernel.
1. Resolute in 0.71s at alternative.c:2564 (BUG_ON(!pages[0] ...), RAX=0)
2. mainline at alternative.c:2473 (BUG_ON(memcmp(addr, src, len))).

With patches 1-3: zero splats across 10 runs each (600s/11,378 module load/unload cycles on mainline and 1200s/55,980 module load/unload cycles on Resolute).


Tested-by: Atish Patra<atishp@meta.com>

> --
> Sincerely yours,
> Mike.
>

