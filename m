Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A283DCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 06:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3C86B0088; Thu, 14 May 2026 02:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB5A6B008A; Thu, 14 May 2026 02:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708AF6B008C; Thu, 14 May 2026 02:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC736B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:35:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F163D1A029C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:35:06 +0000 (UTC)
X-FDA: 84765063012.29.2626F05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 653C71A0002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:35:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UzH3ox9Y;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778740505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVN9p0ZwsScExP+u8mqhOdeaul/DU8Y1gL9seSlAhyw=;
	b=haez3h7M8n3r3jS6K2I4hbd6C4CDFgMDlqzSW5fSiOnktoraMkqfqjbjhNkfzL1o6FX4vy
	joeclCEvb83TUhOYVaZnl5upcchJGGJHsPhMboKaHkv2h9Mv22yH9+tFruDEXO1ewu8yts
	zOCxYckbDW12ajVZ5ROuPjWjczpbwsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778740505; a=rsa-sha256;
	cv=none;
	b=DZDdMUAwmLVRRV+L28+svzhVVeEHe4KQjF2qfA3P2MJGzaS/92MAKt0bbcEBXIy3U7yYe8
	H+PUTh/nv4OVLJR5C9rajrv/F+fDkDJI2Ve0xVs3o94xd544DcZTs8u8+Lh8+tGLz2ui2g
	f6ixlHJw/vM9r9GwVhr9+1dAJrJ5GJI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UzH3ox9Y;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF44C600AE;
	Thu, 14 May 2026 06:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138D4C2BCB7;
	Thu, 14 May 2026 06:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778740504;
	bh=AP8uvMgk/R1M24oMaOiPRYCEeaMELHnugl5qDsJEUPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UzH3ox9Y0nOATaoFSAUfpmTnl0wsXCNwRurs9V+s1qVATfkflVVi+w9vI81EGIIJD
	 GeBaYA5W++V5Jcsaz/W+v+ZPnUEDx2A3++nIX4mUMFfhAtG33EXZKYOtXRgzeB0h82
	 Fh7uigv13xpa4J4mZBHTf+t/3sY9cIKmBxlw5QeKXvzRIhniKwQgOnYCMyo9KNgkl3
	 frJKuHsrJZhjmSdYc9B/VZgPTp1Log8ljJiKcds/RuvAIyBJ8zamt3DZlyV2VvQCqB
	 RuwPmZddSJswiSE5QnBWMUkf9A5no4Y9QNXi0SsjJAPzC0ILZcWj92e3OKrBpvXake
	 oL5Rz3XUzaHtw==
Date: Thu, 14 May 2026 07:35:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org, 
	baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev, corbet@lwn.net, 
	tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, 
	dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	akpm@linux-foundation.org
Subject: Re: [PATCH v4 0/9] mm: thp: always enable mTHP support
Message-ID: <agVs9bWkkx6uJdfR@lucifer>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 653C71A0002
X-Stat-Signature: 4jue85iwww6133kixm1btib9pkwdukn5
X-Rspam-User: 
X-HE-Tag: 1778740505-69135
X-HE-Meta: U2FsdGVkX19YxvE8/xJJ7C3sgN9DvZNB6DmJk2slmJ/LAbVvT76faYeyzscShtk9/5oJa984DsER6JQjuB9Spn6BbR5E4CGc0pdyWz/j/ws04DwTIuuYbgXj8B2UlUKA7LX6AhtKkc7K9O+vBEFgi6WtEPIMPq/Qh5RQlkdNF51KI7aVEK3VyDp7+6aJ3l1fVBITTuA/LBwjE6KZoP1wnlKWC5Bv/pQu5ZEA0fR89lRHsFUXPJZxJXD6wUtIJCEtLLERwE3jX+zDR1XCmUeGXCYIh6g5FZM46mBazgT7GkdPFusJ+Z589Lyph5OVH4b06eT+fEB3V+9/0hi92xpwVc2KDG2pQFEo7jFYjF/n2fYbdLyDIbHMlhwWapL4BKBDrsoJap6xWPhmMm7rLfBQMR7WYXQKAzxsw0aaSeH5qONwdwQDM1gpKc3qlIoWpPlj/fsrgCEk3/KnzPw34I5LO7djiKO6AJNqE56m3v7TB9Buxpc91Lgzr3BDoPBE8cZaeAxdy3mr65yBtyoBYpF0zt4xtLqu3UEMzGjJrHxDL7GT1sQ9qNmJ/Pq7sNMLSL5aO0pHDsFoJnq7ncPfLdnL80ay+m7IMngqZa6GPPOyZhhxpyfnaiwWdCDdihV8IVYftSAsOIVd16eZ6vop0zQxxD8kZ6bRfDlcinG37bpQhsJqswW1r5A9YIjY7WtwG4ITVAU5r56IxDRO/C2vu6jSGtkxRGEMwg9G6B+UuDeX1632zlAV1JvK5CMjj6Bx4LnZ6o1Ui2UzwFVXlPn3HeTbhGJs5JmMAriapaXbx+dZHop/2/tgKBOxDfih6zfaXD7Yr/aT021Hm1MZF2Sxt6jIl+VgyZvyZTxB3Z2Kpmtb5FkTCRmOVNRnhMiDpwQhOPYvvFXhTATUhEg1oMkTI3ZSlxEEeK7GV4tYDNW8MufeDoQXRbtEvbVFsxZMQNHz2VSCAt/SrLfp5vJwqrQZ20v
 KBplKsIQ
 cybRK71DmkfX0n78hyJC3d3veR6XjM70ACsXb5dfGKXFY0rbwr8KvexFLjxa5SF6wEflbeNaM2CaJOmqsTqDbEUKzJmVNAN/tLCLMANsbk/NnvpA+cv8s5dJpDgqdZmspM5jF8D9xhkJFYaSAdb7R7o4muIFgHzpwJ9JlKkdTssRUA7/0EptRhMR35eGU1EvMT3yRMnIIgmtSzHPZHecXx6xzviDlJzJJMcZNYxfMg+yHniY439BynEOO0spvaq5JEkkZoJtEqcG04N8yHBWXPltYrqS8CFuyod/N2xJkUU93Few=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc my previous kernel mail

(Minor annoying reminder to update my email to ljs@kernel.org :P)

On Fri, May 01, 2026 at 03:18:42PM -0400, Luiz Capitulino wrote:
> Today, if an architecture implements has_transparent_hugepage() and the CPU
> lacks support for PMD-sized pages, the THP code disables all THP, including
> mTHP. In addition, the kernel lacks a well defined API to check for
> PMD-sized page support. It currently relies on has_transparent_hugepage()
> and thp_disabled_by_hw(), but they are not well defined and are tied to
> THP support.
>
> This series addresses both issues by introducing a new well defined API
> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
> new helper, we ensure that mTHP remains enabled even when the
> architecture or CPU doesn't support PMD-sized pages.
>
> Thanks to David Hildenbrand for suggesting this improvement and for
> providing guidance (all bugs and misconceptions are mine).
>
> This applies to Linus tree 08d0d3466664 ("Merge tag 'net-7.1-rc2'
> of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>
> NOTE: I used Claude Code Opus 4.6 to *review* the series before
> posting. It did find one issue where a pgtable_has_pmd_leaves()
> check was missing when assining huge_shmem_orders_inherit in
> shmem_init().
>
> v4
> --
> - Use static key for pgtable_has_pmd_leaves() API (Lance)
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
> - Fixed huge_anon_orders_inherit default setting when !pgtable_pmd_leaves() (Baolin)
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
> Luiz Capitulino (9):
>   docs: tmpfs: remove implementation detail reference
>   mm: introduce pgtable_has_pmd_leaves()
>   drivers: dax: use pgtable_has_pmd_leaves()
>   drivers: nvdimm: use pgtable_has_pmd_leaves()
>   mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
>   mm: shmem: drop has_transparent_hugepage() usage
>   treewide: introduce arch_has_pmd_leaves()
>   mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
>   mm: thp: always enable mTHP support
>
>  Documentation/filesystems/tmpfs.rst           |  5 ++--
>  arch/mips/include/asm/pgtable.h               |  4 +--
>  arch/mips/mm/tlb-r4k.c                        |  4 +--
>  arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>  arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 ++++----
>  arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>  arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 +--
>  arch/s390/include/asm/pgtable.h               |  4 +--
>  arch/x86/include/asm/pgtable.h                |  4 +--
>  drivers/dax/dax-private.h                     |  2 +-
>  drivers/nvdimm/pfn_devs.c                     |  6 +++--
>  include/linux/huge_mm.h                       |  7 ------
>  include/linux/pgtable.h                       | 19 ++++++++++++--
>  init/main.c                                   |  1 +
>  mm/debug_vm_pgtable.c                         | 20 +++++++--------
>  mm/huge_memory.c                              | 25 +++++++++++++------
>  mm/memory.c                                   | 11 +++++++-
>  mm/shmem.c                                    | 21 +++++++++-------
>  19 files changed, 93 insertions(+), 60 deletions(-)
>
> --
> 2.53.0
>

