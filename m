Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C62A2C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F366B0096; Fri, 18 Sep 2026 06:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF7D6B0099; Fri, 18 Sep 2026 06:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10856B009B; Fri, 18 Sep 2026 06:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9536B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:37:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A0598065A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:37:28 +0000 (UTC)
X-FDA: 85226531376.28.577A697
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	by imf25.hostedemail.com (Postfix) with ESMTP id A24EBA0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:37:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=paJGso43;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789727846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ze3IkUmbbLbQPan/yOwJ8EKPgZuTbIUxZsVekoGqm2E=;
	b=SzAQiUD9ywDFIVy4gBw37m3efXP3RcEuWJv1VnH1S8PCioBOV0X7ugDn0aOqH633Sfcj+S
	xsub2pXmxZSO1l448KcRGmig9q2g8l4R4VnCnVi1ZbBbyDqkHMgtF0pQBV6q5Absjpcs25
	nxNY5xRDfXImilV6hRgfJtRYbNf3YVM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=paJGso43;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789727846;
	b=zFqQ5Py9ncMi32l9S6jhNYEVI6XheTv8D+Hz1Jf4ZIxhVoEffvIvtV/kjlEiTAPxTGVdKg
	1Hyva/xrivFjgIOJJSBKKTHIa3/gFhjfUEqIq/ht8QrsF7MNsiknu2tdAjNsYrgRu3YRCb
	bYM/EAqXWBsv4lnuc34sbANE7VUGJxs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/0Izr/ImD+usADyY0NZMdwIDKPvMFyLMW7fMx+8kP2g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789727843; v=1; x=1790332643;
 b=paJGso43CpqUGYUK2pBn36KCvy7DFlCKH/vZlcLJ73GlFixEUrMfrrT5LSyxNDXyDRdcKorE
 OB7SdqgRYuOjMYb5yZO5HwHreBOQAdpYPFL+ONpeWSDNUqseh5EF1Bc/xNjv0Re5iH7iEVDJiCa
 mMis1xehzRSuceKnlhyBvnqk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 10767ddc7fddd317;
	Fri, 18 Sep 2026 10:37:13 +0000
X-Mizu-Trace-ID: 10767ddc7fddd317
X-Migadu-Flow: FLOW_OUT
Message-ID: <ad25b99c-d9f6-4e52-819b-81e08eb2a131@linux.dev>
Date: Fri, 18 Sep 2026 11:37:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/14] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, baolin.wang@linux.alibaba.com,
 ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com
References: <cover.1789695931.git.luizcap@redhat.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A24EBA0009
X-Stat-Signature: 7sdw5b5d3aganpd6tcbe4bfajiy3qqbq
X-Rspam-User: 
X-HE-Tag: 1789727845-76831
X-HE-Meta: U2FsdGVkX1/1Ukm4FS8nfMMYLBfyTf6F3QKnTT6zDaQsydBQysEx1+n2k17j2v6H6b+vTdoqHmrT0Od2FdaIjW31ioOeOdA9JxdTrm/vLVMxW2Io4QVURJ8GzshZXT7wYZkiliRnNwL6dwq8uU+ejoIX75k4NDf9kUlf42CEvVtmdoN+yQlDl/YeYyHYI1bKXPcSQI+Q6oACOFwZ0F0GFoPt+eGfYXWcgKzqcYf4nO2CwI1JPnemmp7SRn+BS1Wqr3AFzzo7d5lWMGuRSoVTo0VYXg6UTSnb0OHUKa6pTS5zfHFiE8IFIFdefE39b4L+krknEiMd7Iwy3SF6DT42+1Phuvbx56Lo9FFocGY1howWHl+C6fNWFneY6VM/90OHYcB2rq1BDgJhih0vYUO7+k/rNxaWYXDDqGvlpj5t3xjcgWoQdeZ8cs853VNr9NGifIdIWlHzzR3IoRZKv04tVgJGYhUTgv97B459KCddI2DBy5Q15ENFV/Dr5HRxLjV/NdTc3HinG507gpfZI2vIszCfKdjejlhNLIV3kXjOOQUw9PUgUArnHAq3hserRoKtu0gyfEXs1EQfqOiwLLVtJNQ8WjjBkTfHsbJDh9k4D0QbfEWSEfND0fDSVh5IY67YybQwilSfIKdEGNFoWa/QcOxYzF1Q8ev1yR/0pjinhY/bKs/1A+UWHjAIll6yeiXMikCr3Hyma1vf5XIaKr03kVmWlnYbPb9Zws5+jn/g9MZsuBhk33kR6yW1JACs96o1NI4ZF1AGSZdfXraZvgVtUT9zfTDPY6BJhtXpyfgmHSZp0TxXWGIP8a+9bDqaM9FAoHuXSCChKlPo3bFLZdx/XfWPzLqgQe/44zG1fp+uJy1fOHU1NPlikSPgOo8OhECmAduaX7gAZzUb5IkXVR6+7G+03Yx6Yd6PlnRxi47PCI6Ff1GxkCP+1zGQuperxD1tZ3oxMiJ10g0CbzNpx3c
 OJ5NHree
 uZHnkati5n2/dnIvNmMAFQ9+CQ5H+YoHdrSCpGc5Z4kqpRmtDKXXG9GE9N6iCMJ/I+W/sja2MFpfgGrfK9N6Hd720hJ4yl+1r0BNlRP2vCVhrVfn8p3UCFSbhBmrZO+6Iiky+8stedl4ePgwRM+MNXNfb2rT2NrSxBL3I//4Lq9Zg2ouYCRAAw/YR4avIlYPhPc56m9WRz67rhFCYvKEP2ioDVephdyQEC0HKzizVAAc080Xb1xSyzeS64KndHM0GpTWNvA4njy/M+dPVPO1By4QJxz/vV9UhBRvxNhBkcMNh10uWBRsUq8lYdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/2026 02:45, Luiz Capitulino wrote:
> Introduction
> ============
> 
> Today, if an architecture implements has_transparent_hugepage() and the CPU
> lacks support for PMD-sized pages, the THP code disables all THP, including
> mTHP.


Hi Luiz,

Sorry for asking this so late in the series, but which CPUs lack support for
PMD sized pages?

Is this series mainly for PowerPC?

Thanks,
Usama

> 
> This happens because the has_transparent_hugepage() helper is overloaded:
> its name implies it checks whether THP is enabled, but on some architectures
> it actually checks whether the CPU supports PMD-sized pages. In addition,
> the THP and shmem code have a big switch on has_transparent_hugepage().
> 
> This series solves this by decoupling THP availability checking from
> querying CPU support for PMD-sized pages. THP availability can be checked
> with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE). For querying PMD-sized page
> support, this series introduces a new helper called pgtable_has_pmd_leaves(),
> which is independent of THP, has well defined semantics and can be used
> in fast paths.
> 
> Core THP code and shmem can use pgtable_has_pmd_leaves() to determine
> PMD-sized THP support at page fault time (or folio allocation time for
> shmem), leaving THP and shmem always enabled for other THP sizes. For
> architectures and CPUs that do support PMD-sized pages there's no
> intended change in behavior.
> 
> We also convert each user of has_transparent_hugepage(), and the related
> helper thp_disabled_by_hw(), to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
> and/or pgtable_has_pmd_leaves() according to the call site's check semantics.
> On s390, powerpc, mips and x86 the arch has_transparent_hugepage()
> implementation is moved out of the CONFIG_TRANSPARENT_HUGEPAGE guard and
> renamed to arch_has_pmd_leaves().
> 
> Thanks to David Hildenbrand for suggesting this improvement and for
> providing initial guidance (all bugs and misconceptions are mine).
> 
> This applies to mm-new 93f615a22169 ("mm/swap, PM: hibernate: atomically
> replace hibernation pin").
> 
> Reporting availability of PMD-sized pages to user-space
> =======================================================
> 
> Before this series, not having PMD pages available would shut down THP support
> meaning that /sys/kernel/mm/transparent_hugepage would not be available.
> After this series, /sys/kernel/mm/transparent_hugepage and hpage_pmd_size are
> always available but hugepages-<PMD-size>kB is only available if PMD-sized
> pages are supported.
> 
> To me this seems logical, as hugepages-<size>kB is only available if <size>
> is supported. If this is correct, then MM kselftests that depend on PMD-sized
> pages will need to be updated to check for it as they fail with this series
> applied when PMD-sized pages are not available.
> 
> The alternative is changing hpage_pmd_size: either don't create the file
> when PMD-sized pages are not available or set hpage_pmd_size=0. My concern
> is that this could be considered an ABI breakage as this file was never
> reported to be optional or report a zero value.
> 
> Testing
> =======
> 
> - Ran MM kselftests on x86_64 and s390
> - Tested all mTHP sizes allocation on x86_64 (with and without PMD-sized
>   pages available)
> - Tested shmem with within_size w/ mTHP on x86_64 (with and without
>   PMD-sized pages available)
> - Performed defconfig build on x86_64, s390, arm64, powerpc, and mips
> 
> NOTES:
>   * I'm forcing arch_has_pmd_leaves() off on x86 to simulate not having
>     PMD-sized pages available
> 
>   * Running the MM kselftests when PMD pages are not available causes some
>     tests that depend on PMD-sized THP pages to fail as noted earlier
> 
> Changelog
> =========
> 
> v8
> --
> - Fixed build breakage on MIPS (Lance)
> - Rebased on top of mm-new (fixed conflicts in include/linux/pgtable.h and
>   mm/shmem.c - dropped a Reviewed-by as a result)
> 
> v7
> --
> - Applied on top of latest mm-new
> - Improved various changelogs including cover-letter
> - Changed arch_has_pmd_leaves() default implementation to use IS_ENABLED()
>   instead of IS_BUILTIN()
> 
> v6
> --
> - Rebased on top of mm-unstable (required a minor conflict resolution)
> - Added more Reviewed-by and Acked-by tags
> 
> v5
> --
> - Moved init_arch_has_pmd_leaves() to mm_core_init() (David)
> - Renamed init_arch_has_pmd_leaves() to pgtable_leaf_support_init() (Lance)
> - Added new patch changing shmem_getattr() to set blksize according to
>   highest supported THP order (Baolin)
> - Added new patches to move has_transparent_hugepage() out of
>   CONFIG_TRANSPARENT_HUGEPAGE guards
> - shmem_allowable_huge_orders(): rename variable and only disable
>   PMD_ORDER (David)
> - Added <linux/jmp_label.h> to include/linux/pgtable.h
> - Added new tags and removed Reviewed-by from changed patches
> 
> v4
> --
> - Used static key for pgtable_has_pmd_leaves() API (Lance)
> - Moved shmem pgtable_has_pmd_leaves() check to
>   shmem_allowable_huge_orders() (Baolin)
> - Default pgtable_has_pmd_leaves() implementation to
>   IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) (Zi)
> - Dropped patch “mm: thp: x86: cleanup PSE feature bit usage” (Dave)
> 
> v3
> --
> - Rebased on top of latest Linus tree
> - Removed i915 patch as driver dropped has_transparent_hugepage() usage
> - Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
>   with early_param handlers clearing CPU feature flags
> - Fixed build error with CONFIG_MMU=n (kernel test robot)
> - Fixed huge_anon_orders_inherit default setting when !pgtable_has_pmd_leaves() (Baolin)
> - Small commit changelog improvements
> 
> v2
> --
> - Added support for always enabling mTHPs for shmem (Baolin)
> - Improved commits changelog & added reviewed-by
> 
> v1
> --
> - Call init_arch_has_pmd_leaves() from start_kernel()
> - Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
> - Clear PUD_ORDER when clearing PMD_ORDER (David)
> - Small changelog improvements (David)
> - Rebased on top of latest mm-new
> 
> Luiz Capitulino (14):
>   docs: tmpfs: remove implementation detail reference
>   mm: shmem: shmem_getattr(): set blksize to highest supported THP order
>   mm: introduce pgtable_has_pmd_leaves()
>   drivers: dax: use pgtable_has_pmd_leaves()
>   drivers: nvdimm: use pgtable_has_pmd_leaves()
>   mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
>   mm: shmem: allow THP support determination at folio allocation time
>   s390: move has_transparent_hugepage() out of THP guard
>   powerpc: move has_transparent_hugepage() out of THP guard
>   mips: move has_transparent_hugepage() out of THP guard
>   x86: move has_transparent_hugepage() out of THP guard
>   treewide: introduce arch_has_pmd_leaves()
>   mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
>   mm: thp: always enable mTHP support
> 
>  Documentation/filesystems/tmpfs.rst           |  5 ++--
>  arch/mips/include/asm/pgtable.h               |  6 ++--
>  arch/mips/mm/pgtable.c                        | 25 ++++++++++++++++
>  arch/mips/mm/tlb-r4k.c                        | 22 --------------
>  arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>  arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 ++++++------
>  arch/powerpc/include/asm/book3s/64/radix.h    | 14 ++++-----
>  arch/powerpc/mm/book3s64/hash_pgtable.c       |  8 ++---
>  arch/s390/include/asm/pgtable.h               |  6 ++--
>  arch/x86/include/asm/pgtable.h                | 12 ++++----
>  drivers/dax/dax-private.h                     |  2 +-
>  drivers/nvdimm/pfn_devs.c                     |  6 ++--
>  include/linux/huge_mm.h                       |  7 -----
>  include/linux/pgtable.h                       | 21 ++++++++++++--
>  mm/debug_vm_pgtable.c                         | 20 ++++++-------
>  mm/huge_memory.c                              | 27 ++++++++++++-----
>  mm/memory.c                                   | 11 ++++++-
>  mm/mm_init.c                                  |  1 +
>  mm/shmem.c                                    | 29 ++++++++++++-------
>  20 files changed, 144 insertions(+), 100 deletions(-)
> 


