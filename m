Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E215110F3DC8
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C016B008C; Mon, 30 Mar 2026 10:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCCE6B0095; Mon, 30 Mar 2026 10:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07DF46B0098; Mon, 30 Mar 2026 10:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5DC56B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:06:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57A561A0590
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:06:49 +0000 (UTC)
X-FDA: 84602905338.28.C364143
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 08293180011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:06:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E50nERGV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774879607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bc8oXkc/hYZz+M5QI8uHk08RUX0VrEOsDhErYJns8EE=;
	b=z0x3ICj78G7cmhCfMa3g31IOPcuOdnv8f7D5QiqKPVzJikEQ53mbb5LNDbtc3yshL8V9lw
	xm5THhgrgWro7HNbqfecOarPvqxfnZaTu2kcgy5lX/sxdSroN5m/636Ub/GsE+xmsqVFek
	CBb4MDwRZUgpWd0NG1xHJLddDIUVgos=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774879607; a=rsa-sha256;
	cv=none;
	b=ZJ/lWkUP8IRGHM9PHoCVFD+hDTMcx5nXNCaeCpfExqBV96IVYAW8oOMWesfedsvm4vunI6
	gETZ2tolHgdkGKU4IG9c8ewsaRqNcSoWLY+8vopGnnXdxVsPuWFn/YwzmoRKKPxA6O20Qd
	kC1K+P7d5ECoXmtAWlMPC8pEperLpKI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E50nERGV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CEAD543C1F;
	Mon, 30 Mar 2026 14:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338D8C2BCB2;
	Mon, 30 Mar 2026 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774879605;
	bh=fhEugQLyPAkBmo+yDLgQGsY50nwY11NJzNLYdwn+tZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E50nERGVa7Y96mhJLxplUBCC2IdBdWrHmuRgc/nJVsh7j23h91yyvRlZZIwbQ4Hiw
	 diJIyJP81T8wTgPzWoW4p9aR4eaMajoMfjmz7d5pyUOY3TelL6KxpdbwvtUp+O9IEp
	 D03AcO86JSu6nw2DNp5if/hGYZXJ5m39Vefq0XX3g7rCQ5r2Q/IgImsl22ZNv7YULt
	 TMvBSZghp/uPmE+veJi5if6dm4i6heLpRpfnyeSlMkeamcNA9YFk1vc1N/prOcfj6K
	 TTanGiJtvWzE/mm4RAYulg9D1047BU8w09ts2b1GUE9LA86NrtYhdyPMXQksJ2iVAO
	 kbNfDIL8+4G9Q==
Date: Mon, 30 Mar 2026 15:06:39 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Chris Down <chris@chrisdown.name>, 
	David Hildenbrand <david@kernel.org>, Liam Howlett <liam.howlett@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [selftests]  9652b82ca9:
 kernel-selftests.mm.make.fail
Message-ID: <c7bedad1-05fb-457a-b0a5-47d7a09fa254@lucifer.local>
References: <202603302149.1db397e2-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202603302149.1db397e2-lkp@intel.com>
X-Rspamd-Queue-Id: 08293180011
X-Stat-Signature: hqk7bryj8986mu1w8xxsx8d3jcj6qcgw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774879606-174499
X-HE-Meta: U2FsdGVkX1/VHFIPihoSl1Yqo2wJpt598VRwbM7GHnfRE2rIpRXhpgefiIy9RP0L11/TB22bXAe1ZuR93cREYl/dDffujLX4EtuqC3SHxRxiaYl5JEaq4EEaN79oPfWhrDMI6qtel1bxIccM55HbWY3Q4YdXcXUbJnFlcVb/Yn1Px2a66A7WpaPHzh+z6tkNsQ+wXoJpOJlBvz1nt+vDtamhwpItV28HlGun57R8pwLYngTn1ibzh5RogLKOMbDnPLERYtJQzBr+rFMi2x9DEO+lllEWXgDWfpmDhQm576YHrUORkK5Mz4bZPvbIOaL6yuNa8ZsMrIfRCDMFnmen3i/YORVc/A5vhDOSNWN+LROWX3IVXEaJGXCKU2Hz6JtOQb1O+W+WcSYIoHi/bSfU7MySSZAkREEQ5Ku7hyBTyMv5qDQD0iMqggVVpEBwdfOX9Z+2SRKF2QD/qi0yetyuwqdDIJiS4d6vcJwLDAzEqFdyMLZ2wcHU3O+VFgtqR3ZtoBmeuddRkQcdedO1+Tx9XElCVK2St0IXEH+l9R4u24IjNY/Xi0sIjrK5viLJw4+L/2ODEDpm8MDS8G9/GebSu+PgpdHuLkh9w3h4I1pkifNoaMUUv0ct4UoZwnuNvZRapP+Pj4JPLFEh0j3dEJsDp3cISbDgidSCTqEcKMyJgRFKb2UFqGj2dqIjTGI+xoCsPKwXTUiyMEJJmImjGdxmshoxjoPEqT/eswrUtVeZ4fyfJm63Jq3tfSn05mFtMmQ4B7SeX86+kt/Yb7vTxN/6ddcAbZ8I2fyjFKyhJPUEzwtTK+iFm++qBM6sg96SjD+aVTCVwHWtsbwsBsB67gg7mesSdc2UccSUoROi03ZRvq/Iik07YOn1nZFccQn461B3jkLt43eVzjjHQSCodl8bbIbgNChRAQqOxcFjNF9K0pysuvJ39dSeijASSunfgTp3qanx3wQANhVN2J48FuT
 zHuMblL2
 VAX1+XGMTx+2ZOYxXYgjB6itpwtT1UfdRZT3WQd8cZoC1mO+ejgMKXboiK/vlWi6txWsS3dFDw0UzwaayI6nyrmndoXhD/3Yv2Hl0ZHAGh6axhRQN7Z6UAHXeh7QGwD+L0fdl+rj9eOWXVtIOwmyqNzMVOJmxuDFNznwhx8OCmOstYQsmACqG7jj8Vm4ARrEJMijl+Honq8gcJE/nDAPtz3iY8EKeWGOnXFx+OYTVnfd/5ekTc1yqhaC4fr0A1YMPvg6oiEHGgIdomlH/ZI8poEY54/KEwiZOBHWotHJn0M56ra1Ij47dm53mEADBVmqwBqBaiFp97C5MN0L00/TISFodq8//kneulbmzv7Myxx7pDiR3CwvaPF047A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 09:33:51PM +0800, kernel test robot wrote:
>
>
> Hello,
>
> kernel test robot noticed "kernel-selftests.mm.make.fail" on:

This is because of an issue with a fix-patch and another series getting yanked,
it's fixed in the mm-unstable tree, so should percolate it's way down to -next
soon.

Cheers, Lorenzo

>
> commit: 9652b82ca963243fb80e645319d473a7dc65ee79 ("selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>
> [test failed on linux-next/master 3b058d1aeeeff27a7289529c4944291613b364e9]
>
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-c369299895a5-1_20260323
> with following parameters:
>
> 	sc_nr_hugepages: 2
> 	group: mm
>
>
>
> config: x86_64-rhel-9.4-kselftests
> compiler: gcc-14
> test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-9980XE CPU @ 3.00GHz (Skylake) with 32G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202603302149.1db397e2-lkp@intel.com
>
>
> KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79
> 2026-03-28 07:10:57 sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
> fixup_test_group: fixup_mm /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests
> 2026-03-28 07:10:57 make -j36 install TARGETS=mm INSTALL_PATH=/opt/rootfs/tmp/kselftests/mm
> make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm'
> CC="gcc" CFLAGS="-Wall -O2 -I /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/../../..  -isystem /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/usr/include -isystem /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/../../../tools/include/uapi -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE= -I/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/../../../tools/testing/selftests " ./check_config.sh
>   CC       cow
>   CC       compaction_test
>   CC       gup_longterm
>   CC       gup_test
>   CC       hmm-tests
>   CC       hugetlb-madvise
>   CC       hugetlb-read-hwpoison
>   CC       hugetlb-soft-offline
>   CC       hugepage-mmap
>   CC       hugepage-mremap
>   CC       hugepage-shm
>   CC       hugepage-vmemmap
>   CC       khugepaged
>   CC       madv_populate
>   CC       map_fixed_noreplace
>   CC       map_hugetlb
>   CC       map_populate
>   CC       memfd_secret
>   CC       memory-failure
>   CC       migration
>   CC       mkdirty
>   CC       mlock-random-test
>   CC       mlock2-tests
>   CC       mrelease_test
>   CC       mremap_test
>   CC       mremap_dontunmap
>   CC       mseal_test
>   CC       on-fault-limit
>   CC       pagemap_ioctl
>   CC       pfnmap
>   CC       process_madv
>   CC       prctl_thp_disable
>   CC       thuge-gen
>   CC       transhuge-stress
>   CC       uffd-stress
>   CC       uffd-unit-tests
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugepage-shm] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/map_hugetlb] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/compaction_test] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugepage-mmap] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugepage-vmemmap] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/map_fixed_noreplace] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugetlb-read-hwpoison] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/on-fault-limit] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugepage-mremap] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/madv_populate] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugetlb-madvise] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/transhuge-stress] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mlock-random-test] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugetlb-soft-offline] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mkdirty] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/map_populate] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/gup_test] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/memfd_secret] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mrelease_test] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mlock2-tests] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mremap_dontunmap] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/gup_longterm] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/thuge-gen] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/prctl_thp_disable] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/memory-failure] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/pfnmap] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mremap_test] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/migration] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/khugepaged] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/process_madv] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/cow] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mseal_test] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/uffd-stress] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/pagemap_ioctl] Error 1
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/uffd-unit-tests] Error 1
> vm_util.c: In function ‘pagemap_is_huge_zero’:
> vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
>   127 |         if (!pagemap_scan_supported(fd))
>       |              ^~~~~~~~~~~~~~~~~~~~~~
> vm_util.c:70:13: note: declared here
>    70 | static bool pagemap_scan_supported(int fd, char *start)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hmm-tests] Error 1
> make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm'
> make: *** [Makefile:212: all] Error 2
>
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260330/202603302149.1db397e2-lkp@intel.com
>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>

