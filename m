Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23910C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 23:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60ECC6B007B; Fri, 25 Jul 2025 19:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF046B0089; Fri, 25 Jul 2025 19:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4BA6B008A; Fri, 25 Jul 2025 19:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6A66B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:51:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75EA613427D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:51:06 +0000 (UTC)
X-FDA: 83704435332.09.4B08286
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB13E4000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:51:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WC9QXExV;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753487464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qqf3oemEHSrz5WN/F0jsaZ1vSQjA3fwsg2DHfxI5XmY=;
	b=QjDVEylYJHPAJaYbuMbWDqQ2MlzeFbovgGjNHhUmxQ5owpcBEJwywDDIJjj4MOfNhqYls3
	44LCxzqtqohXRj6u7eLninN3+iyg2in1FRZXsxhbbmVH0oqg7chMUENIJYxwErNMCr8xyj
	lZS+EiIOr9Nf3XdoSUF9ZJ5/r2zIjow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753487464; a=rsa-sha256;
	cv=none;
	b=XjPXKtO2/l9SAXPZ2ladWXOHDtyp2nAEy3gLJkmHbwHYJpjG6/Jt1K41Hw/Lyca7QtXKNV
	VCNiaMEUaxKc99mbGdAd9U+xTcYcVmRuYIcCi8ciOg6B37FG2WvmmTqIIr1v5S0t7AC7Xi
	csIBQp7118fKm14CkPTcDzgQZR81/AQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WC9QXExV;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 476DE5C6AE0;
	Fri, 25 Jul 2025 23:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F40DC4CEE7;
	Fri, 25 Jul 2025 23:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753487463;
	bh=k2UEv3H0rQL8yvRCGdCtZL7jRC7k7qI5xjgkdT+pMnc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WC9QXExVCil7nvhzYbXj3XM3h/Vl1LWn9QMpKzNOvDfzK7tmmu6merjEVhJvQmzZv
	 yUs17VM0Wf8pDrcd2pktcCxdrBzsT/O4NubFFqw75xqNVvpwEY/HNkNuGp9pQt+3zI
	 1dZ89hPoykgJ6fKPaTCp8tj3cHuOlfHg0tFzV40c=
Date: Fri, 25 Jul 2025 16:51:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H . Peter Anvin" <hpa@zyccr.com>, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Alexander Potapenko <glider@google.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo
 Frascino <vincenzo.frascino@arm.com>, Juergen Gross <jgross@suse.de>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Oscar Salvador <osalvador@suse.de>, Joao
 Martins <joao.m.martins@oracle.com>, Lorenzo Sccakes
 <lorenzo.stoakes@oracle.com>, Jane Chu <jane.chu@oracle.com>, Alistair
 Popple <apopple@nvidia.com>, Mike Rapoport <rppt@kernel.org>, David
 Hildenbrand <david@redhat.com>, Gwan-gyeong Mun
 <gwan-gyeong.mun@intel.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Ard Biesheuvel
 <ardb@kernel.org>, Thomas Huth <thuth@redhat.com>, John Hubbard
 <jhubbard@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>, Peter Xu
 <peterx@redhat.com>, Dev Jain <dev.jain@arm.com>, Bibo Mao
 <maobibo@loongson.cn>, Anshuman Khandual <anshuman.khandual@arm.com>, Joerg
 Roedel <joro@8bytes.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 mm-hotfixes 0/5] mm, arch: a more robust approach to
 sync top level kernel page tables
Message-Id: <20250725165101.e636bbe3fa69ad0b73810914@linux-foundation.org>
In-Reply-To: <20250725012106.5316-1-harry.yoo@oracle.com>
References: <20250725012106.5316-1-harry.yoo@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r1hsq17idenxss9aagjf7haj3z1cxh6m
X-Rspamd-Queue-Id: AB13E4000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753487464-90931
X-HE-Meta: U2FsdGVkX191KKhiB/g16xjRaQ6gu3tkpYm6HSwa+dSfMUPBhScm1HApQXhub9Cv3b60rRHazrI+/lavlYUEiNvNbUi5ACYMoQmOpme3c3ZOGwMXgZCrkHlV8mYXxCbOLviQyZAQuL2qLDUWXz3EpC7YCwEhZ/pLp9edZjDeSfeyAQ63WWq0Cmiuv76NqeVm+78LDGdULloAzpuizpD02jc2oeHZ62NEHeEKkfio/9LVDXs+5Pw1OJ6H2qPsZCoJN4KIIsDLDmNAVVXV07oTPv64vYYvb0S+daUPE1KIMIoVI7GbNsHN7NncaLipJyz+rqJ62AVitCxWqXzgozePZQthbPS2/sMK8lkNoixjYI3PolbpgkmJvQruP93r3ylH+PZtwerALkMZWvmPjUGnZq7wcr/9A3TLB0DkWr0Iez6cohh3QntbMwvhsOI9HDT2QXnsqUJLmRkZOxxliwZHegXfLM8O7cvVOjkA0EG6kOvd0mb9A1VBvqEZZYsohjNvydmyNH2ptKbe2FTYoWgjM/j57b4UzSQ5sBzq9IW+mBXYymsq1s+fLNuff8W6P6GToQdRnNKvp8Ddg2BdWQwUtHL6FmJX18FRzTR3J74tgiGpnzW8NnVabYtPK2boeac5cXrXHvlC9wg/6T4wRymKWcVYxb2KSuJkdM2HNkEEuZ88V+Td0fr2GwMniErOG7SSEIv3iJQBdwxWPe0cIf1qIDRMSigu+HJfz0XWvsMZoRQCRK+8m4zvZrcjgbPYtJ7KcEqkpB8nyyjJQZtvMslLYSfty2Sd5nkX1RnFw7/BRN7eCirzFTnYXq9VP8gRRRyuQ7aed0KfnwvV1Yxyigd2SrxpF1ya1w7xSFKsA504kh5kVGBs4LAyrNZEWFxb0nbWSNzGtQPSUetjxqxus0o26XzGzeUbHcECinGjei9Z64rKzNo4Ov7OcUwgCqDTnIWs3dnyL1KP7quDPGJTszx
 XrNoneTh
 R67exiCCTuL1KhHscugidfCEEQ9din3YsvLTPKbJrBHhn88q0LGLk0hiXdy26Ei3m9fU5UAPqaCIxQ41xSjHMhRzQLRKgeFQgqLviXCESb1w2yn8/vRh+Ai2KZn3lQ+wCjlXQmnFTxcRfvssYc/XGRS07/y1mB4Yn8wYojY2O+aWD7BGjXNhbwpP6MbpP60LE5ebuYKYh/kwxu2kC69W4Fm+zGCqlU6CWY5BaMtw6VtqdmdgSYRE+NfGNPU9kN8B9c/Q3/Yd9G/2VxKiXqXtFvEBFIMTCHAsni1Ma7CnxuL3tEq4IEDZqpZyEOYdbDcUxqpKPbaB1bXXeFEo6Ozs3en4ppQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 10:21:01 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:

> During our internal testing, we started observing intermittent boot
> failures when the machine uses 4-level paging and has a large amount
> of persistent memory:
> 
>   BUG: unable to handle page fault for address: ffffe70000000034
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   PGD 0 P4D 0 
>   Oops: 0002 [#1] SMP NOPTI
>   RIP: 0010:__init_single_page+0x9/0x6d
>   Call Trace:
>    <TASK>
>    __init_zone_device_page+0x17/0x5d
>    memmap_init_zone_device+0x154/0x1bb
>    pagemap_range+0x2e0/0x40f
>    memremap_pages+0x10b/0x2f0
>    devm_memremap_pages+0x1e/0x60
>    dev_dax_probe+0xce/0x2ec [device_dax]
>    dax_bus_probe+0x6d/0xc9
>    [... snip ...]
>    </TASK>
> 
> ...
>
>  arch/x86/include/asm/pgalloc.h          | 20 +++++++++++++
>  arch/x86/include/asm/pgtable_64_types.h |  3 ++
>  arch/x86/mm/init_64.c                   | 37 ++++++++++++++-----------
>  arch/x86/mm/kasan_init_64.c             |  8 +++---
>  include/asm-generic/pgalloc.h           | 16 +++++++++++
>  include/linux/pgtable.h                 | 17 ++++++++++++
>  include/linux/vmalloc.h                 | 16 -----------
>  mm/kasan/init.c                         | 10 +++----
>  mm/percpu.c                             |  4 +--
>  mm/sparse-vmemmap.c                     |  4 +--
>  10 files changed, 90 insertions(+), 45 deletions(-)

Are any other architectures likely to be affected by this flaw?

It's late for 6.16.  I'd propose that this series target 6.17 and once
merged, the cc:stable tags will take care of 6.16.x and earlier.

It's regrettable that the series contains some patches which are
cc:stable and some which are not.  Because 6.16.x and earlier will end
up getting only some of these patches, so we're backporting an untested
patch combination.  It would be better to prepare all this as two
series: one for backporting and the other not.

It's awkward that some of the cc:stable patches have a Fixes: and
others do not.  Exactly which kernel version(s) are we asking the
-stable maintainers to merge these patches into?

This looks somewhat more like an x86 series than an MM one.  I can take
it via mm.git with suitable x86 acks.  Or drop it from mm.git if it
goes into the x86 tree.  We can discuss that.


For now, I'll add this to mm.git's mm-new branch.  There it will get a
bit of exposure but it will be withheld from linux-next.  Once 6.17-rc1
is released I can move this into mm.git's mm-unstable branch to expose
it to linux-next testers.

Thanks.  I'll suppress the usual added-to-mm emails, save a few electrons.

