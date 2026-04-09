Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EF3E9DE67
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE48F6B0005; Thu,  9 Apr 2026 04:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E6F6B0088; Thu,  9 Apr 2026 04:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935F86B008A; Thu,  9 Apr 2026 04:30:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB746B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:30:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22E441406DC
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:30:07 +0000 (UTC)
X-FDA: 84638344854.24.C9D5FB4
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38C501C000C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:30:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gKn52ztF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775723405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TG3Qdmc3lNsKjHzcIFMYLHvMSiJZlrsl5sNm+q7Fpf4=;
	b=RmUEt5ZExrj40wcPH4OeAt/CJ3n7Yf7rNK4jeorYHBj+QSScEtqShdmc+gN1enlSNSjKtE
	fCuxWVXYTg01LIOkywQKlPhXUHVLGIjFG+TY0D0+MwwCJMqSRvCaT+sWFRjw176e70HzRK
	DEvD5JxXOlaDnfsjsYSGGfyvil8A5FM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775723405; a=rsa-sha256;
	cv=none;
	b=jZAIBHNaC7r+3+edo8kg1AZGZ0PHlSuMiJ7Z6JZ/LSMW1JezObGiiezvh49kR+5t4oWQcW
	JU9Z0nfW0YJ3jiRP+W6vluZsF41GA5AoAWbuxGma4eWWzhvO7mD0isy0thw6B2lr55/I23
	M6Z3aR2xS7WydCjh7HX5GyGkYnLzlwU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gKn52ztF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775723402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TG3Qdmc3lNsKjHzcIFMYLHvMSiJZlrsl5sNm+q7Fpf4=;
	b=gKn52ztF2FP3C+TwXjdoMyA1rNNVY9jZ4UKAWphquuDJP/cRFaH4VO9IRBArnsN7TDAdtr
	Y1/36Y8WzjmU9eE4JBYNIOyEepZ+djE9yYdlZP3LRIejQXBAOh3YIjVdcDEyLokHaXJB2+
	svMCUveneaKphq4wfX2ie8yFWmQJSnI=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	dev.jain@arm.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 00/10] mm: thp: always enable mTHP support
Date: Thu,  9 Apr 2026 16:29:36 +0800
Message-Id: <20260409082936.50302-1-lance.yang@linux.dev>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 38C501C000C
X-Stat-Signature: uwk677mnfmemnc4snex8yeenegigpkq7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775723404-341989
X-HE-Meta: U2FsdGVkX18EF6AiXiW+9aujqkuKjumpKokrimD7ZoJiE8eS6hYTjXCFTr+pPhEXE/Cizgl3MBZm6G0V4pjzIEbkmZw/sNfOmpx0rGfBJy9qwnWcmJyVPEX1VZ2nUMyG60n8ayUUSigeCMwdvknvZXpQZEi7dyOmI9D/wzbfAW6voTQGaLQyvbSPsxPm3a4VAnVqw8OYeVW5QaN7X+cI9amNmd11n5VoZve0anMOzafub9GXtNj85FNuJPlKKiQ9Zgakpl0i+1zw8YJTugBksbOVePrWAy5IW0C4AbsIhz3pyoFNdkXFD727BvTGtxsi5hojBYEICK4cxRoxXmtLZ+SysWv1St6qGOZ/jF9TL5XE9r9qKRaZ/j1xuV6UjKWoeNqPjQAg/d4rBOw0wfOWAeFMMMLfSI1MJN0tf7+1baxJyyFZnvbRpFrin8OwKIahSyEZHZb974mmpu8AqNLTUJ2636BZo6EXF/HRcLtJffkTe4br/F+c/t3LYyQpm/Qeyc5uU/rpOc/6EO5Tb6sqo5i81NSDwKcXbZbZqejXHygnmdAVK9qTvvqZkQDVldS2a9EgZ1Hb2X+/moG9ZGw26v5VObXrcLm28+jjKXwzyoVn9T3DAuYpylEk4jKTuJu7GogvOMoPMNHYRV4MKv1j68YWkQaTDkpijNMS+5ZUiiYrBqY6GFvLFR9YG2qQJPV0oW8Fv0CJaLIDoqXDfE/HIUlV5ihGWZqu8NPOwvKcEb/v4xwwUqbAPAgzCoget4nLTjBWKvE7CHWSUHcYQypgPV85BJW/ryHgS8BVCxCTL1lwQ4JzrsgDtAgdaArCNnL8fqoli/RSxB/tk1Sb6xq2wdVwsMdEh14n80W+i7fEoPNtdUmWH1/OI+RJg3kxZtnuQ9Fefbv7z6lG1TZx0c/z/Q7G+iYeGtbmcyiD24VH71PtGediTH0xsxmvUVdCswB5ddEUZdL1JlUyWPJYU+x
 jOk3uU+X
 v7UvRIusGt1E/0rpDFHDJLsaMrV/3QJdOwpruvIvYJeJFf2poJDxkmQoa2L64XbNrT6HHL7WlaAu35CB8Ugj3JEJh54Ijpwp/HBH2GdMNgipA8DCbfS5PSL3TYoou8o/6kLD+NuOqhdeAMOrub5hXvasPVRPcJZKes9lTSwA5bNc1rYL17LZS4bEqh2HtgpiyV7coilc86P722ol+tijlUWTN4LSRGGPhopvrWqkGV72IowE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc THP

Some folks seem to be missing from CC for this series. Please run
scripts/get_maintainer.pl; it's your friend :)

Thanks,
Lance

On Wed, Apr 08, 2026 at 04:22:55PM -0400, Luiz Capitulino wrote:
>Today, if an architecture implements has_transparent_hugepage() and the CPU
>lacks support for PMD-sized pages, the THP code disables all THP, including
>mTHP. In addition, the kernel lacks a well defined API to check for
>PMD-sized page support. It currently relies on has_transparent_hugepage()
>and thp_disabled_by_hw(), but they are not well defined and are tied to
>THP support.
>
>This series addresses both issues by introducing a new well defined API
>to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
>new helper, we ensure that mTHP remains enabled even when the
>architecture or CPU doesn't support PMD-sized pages.
>
>Thanks to David Hildenbrand for suggesting this improvement and for
>providing guidance (all bugs and misconceptions are mine).
>
>This applies to Linus tree bfe62a454542 ("Merge tag 'soc-fixes-7.0-2'
>of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc").
>
>v3
>--
>
>- Rebased on top of latest Linus tree
>- Removed i915 patch as driver dropped has_transparent_hugepage() usage
>- Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
>  with early_param handlers clearing CPU feature flags
>- Fixed build error with CONFIG_MMU=n (kernel test robot)
>- Fixed huge_anon_orders_inherit default setting when !pgtable_pmd_leaves() (Baolin)
>- Small commit changelog improvements
>
>v2
>--
>- Added support for always enabling mTHPs for shmem (Baolin)
>- Improved commits changelog & added reviewed-by
>
>v1
>--
>- Call init_arch_has_pmd_leaves() from start_kernel()
>- Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
>- Clear PUD_ORDER when clearing PMD_ORDER (David)
>- Small changelog improvements (David)
>- Rebased on top of latest mm-new
>
>Luiz Capitulino (10):
>  docs: tmpfs: remove implementation detail reference
>  mm: introduce pgtable_has_pmd_leaves()
>  drivers: dax: use pgtable_has_pmd_leaves()
>  drivers: nvdimm: use pgtable_has_pmd_leaves()
>  mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
>  mm: shmem: drop has_transparent_hugepage() usage
>  treewide: rename has_transparent_hugepage() to arch_has_pmd_leaves()
>  mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
>  mm: thp: always enable mTHP support
>  mm: thp: x86: cleanup PSE feature bit usage
>
> Documentation/filesystems/tmpfs.rst           |  5 ++---
> arch/mips/include/asm/pgtable.h               |  4 ++--
> arch/mips/mm/tlb-r4k.c                        |  4 ++--
> arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
> arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
> arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
> arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
> arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
> arch/s390/include/asm/pgtable.h               |  4 ++--
> arch/x86/include/asm/pgtable.h                |  6 ------
> arch/x86/include/asm/pgtable_32.h             |  6 ++++++
> drivers/dax/dax-private.h                     |  2 +-
> drivers/nvdimm/pfn_devs.c                     |  6 ++++--
> include/linux/huge_mm.h                       |  7 -------
> include/linux/pgtable.h                       | 19 ++++++++++++++++--
> init/main.c                                   |  1 +
> mm/debug_vm_pgtable.c                         | 20 +++++++++----------
> mm/huge_memory.c                              | 15 +++++++-------
> mm/memory.c                                   | 10 +++++++++-
> mm/shmem.c                                    | 11 +++++-----
> 20 files changed, 80 insertions(+), 60 deletions(-)
>
>-- 
>2.53.0
>
>

