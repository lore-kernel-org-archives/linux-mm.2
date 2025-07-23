Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D580C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BE58E002A; Wed, 23 Jul 2025 10:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C958E0002; Wed, 23 Jul 2025 10:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B6D8E002A; Wed, 23 Jul 2025 10:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8458E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:46:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC2D3140724
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:40 +0000 (UTC)
X-FDA: 83695805760.07.6A8C973
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1603E18000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CPmkABex;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753281999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maOB+H4Zr5tqE5BoVupSOxs08mEDheR6VcZSJ2X5J+4=;
	b=7Qfe0/Sg3/c3+HBTsAxkyGgaVXW7z+PH1QOI7+oNhhgOM6yJ4Cgi+8JsBY7rSa+/KW8atl
	qQzC8t42tfnwldtY/GiZJuND1CwPVVJ9pi7GvTt3ALIPWOesMiJcAmfXS16NxwNyyNf+0H
	j4ETY5ZOg4pZ3h+n2Wmo8PIT6HRgAoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753281999; a=rsa-sha256;
	cv=none;
	b=CXh4sjfT0yEXuWyEcXcglaoTWSB0gEqvbvf5CA+yjWndLv+EtYlIv5S24spcGqFJvdmBPw
	zoqj6YDAJFXU904lsLbAM4ZEAiI/jq6TE3ei1Kc+v2RMNRtot44gXJslyB9YdWdqtI1NVs
	U1FfSiRWfVS5KVkBgbxzATbsDwhRhw0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CPmkABex;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86317601DC;
	Wed, 23 Jul 2025 14:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB37C4CEE7;
	Wed, 23 Jul 2025 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753281998;
	bh=gGlgOle8BYTBsJBazgGXJhWVGajCQhO/jB9JlJx7bKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CPmkABexxAU563jj7cXZaiWnoX+pnf4iOwVvkCw4AT6U/HSGybCbAbGLwwEGNM6Ai
	 QJ9n5xUuyavgOf3JmFofdCwrfxivrB2jgdH0a92AvLXnrGHNbx2vZxDU68XhgaVFMw
	 wt+XI8owSrdHF91Gtd/EdzzhM5+XHQ7jc0eVcKujgraTivRyLqnMgCHKgzlyRKkJyf
	 QqRSCyB3y65mhvOlJSZbQGhbL+GLrfiUwNZNwun0sDf1ItpaB4GwdQcgClNYIssqpS
	 x++qS5yONt75+1zkUDnLIB5MGT8bJjuqCr46B3rDyeozd0vfYvZUbe8Oq1GJ07fZUn
	 69FiRPwbeweQQ==
Date: Wed, 23 Jul 2025 07:46:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>, joannelkoong@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
	lkft-triage@lists.linaro.org,
	Linux Regressions <regressions@lists.linux.dev>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <liam.howlett@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: next-20250721 arm64 16K and 64K page size WARNING fs fuse file.c
 at fuse_iomap_writeback_range
Message-ID: <20250723144637.GW2672070@frogsfrogsfrogs>
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1603E18000E
X-Stat-Signature: ygtb1n9694t8ctipggr3x5k9is3gzp13
X-Rspam-User: 
X-HE-Tag: 1753281998-348982
X-HE-Meta: U2FsdGVkX18+D/xtnm7TXyz9qAl01k/xApN3AD/yyx03WcpdZF6JwWlaC3EwUv1It695EvSVRqcouYEKHH9zYQ6vcLECrTcUUwoWiD9dt0gW/70B9YOemSVEBlbsYh8ZoM4OV8s6tXROu+mwiUkHyf/+Zg/duIdVB1jjTauEIDbTXn2htjuMz7BKmhqznfqJRb3MbZ6P3mdTN0eeE70pYuhsF0fNLAyYT+aqRaCfRqGkTqsVbZbPnCGs+9WSF7KkfdECBBD8RsHJdFIgAjKwiWPycf7bUoDJf+AhrQcK7L0SHBdw/tJnlvV+Ne+nm56H0rjm2YeEDR7E+UZvOTt4axhbtEuZ7K5mUr8Ty5RIX6uFWIb4H9H5HnMtPM+B/CM1Pg4n+C+nvJpwVSjFJBmenpcSUKHd0RbHpxcGj87YWTPWSFfx1dV1/uS3yntzBRuBynRFJxI50MHqwsfa9NAsTzSE0PGlSTeMw717gb9PPlLlL8dK1N4qoOzKZDUpLPhWfZkvkCKCLmW8FF+f8knPYMo5i8jIRg9ST0ECZkdRkqTGYRh79m3cqaE71UtYxGJX2BduR3OpsyZKKlvWdT6Bng7Ej1MQ3JBrlm4frs0e4IWKtxe+TedIUWMR1RMYM04nld3AiOE2xkOpE4DTMwEXXgQvrB75uDeoPK1IDqan963XXGg0KvhFxkzmK0T/UQJqJ7tP9BAvAk8Af2+Wc0xkXPvr4uAbgdxS73IO3zx8zbhSIPY7VguftbQ29s0oEli+IGU8v/F++ZquZ9dobmESSg1tO8OKPlUCbo6Wyux1rX6wtX3hW/pZdeCgiFNe9PmiDRlxobvtdOOZIZHLA3u+b65pUknrPOkD8kXN1x7fb5LidjTznHrjIUsEwY5lIz1LAG7/Pd08PrJTuBvIsdJWoD3H4EJKFlRNgD6dGAmo2URyVFEFD1TnQcuRUmjQXfDl82nmd5W/Zb2fDpDp+vQ
 sTAu7P2w
 fUublLTcLZb+x5+GU5ietL0/OHrwzSrn2q+tHjHkdpPhkM0A6EH5CeAIBrNJ3QM5r32r0d+7mHpTjKBs+dkNp0l/dwALt2tvouwm2w5UhL1J0kgQ353C8O4sUbXCI6ImPwUFdxSykJvHo27gTL/0bRg0mHXSyNzN0tVMPHSvm5yiEEfBgQA1gR/aN0EII0Raz9/no7dVGNJvZ/OZcgg/dTW7LvmOPN4LZ9nq1af/RG2/d4gweae8feV58i26vpcxjYs45/ePMqjC3W8oOMZt+cG2WsFisJiwvmnHFxBnri6SV8LVOvSTe+HCaxsE9VbhBt6/gDYknbQqm1ezXug8/spUriVykiPEUbsk5/qJRuQEncTw9VXRefW6f3RyjQjWJmDd9fuo2SGMeDqx1K/kvHFAo700q4v0DCpSCTVnMIZ6Q2j8HHZjKbpTbQghGuYtPCcLCMDRi/ymATvVbpyVi9cph+faswA76186fZP1ePdZ5Yguerha21TuswHdyEJ4ii9EP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[cc Joanne]

On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrote:
> Regressions found while running LTP msync04 tests on qemu-arm64 running
> Linux next-20250721, next-20250722 and next-20250723 with 16K and 64K
> page size enabled builds.
> 
> CONFIG_ARM64_64K_PAGES=y ( kernel warning as below )
> CONFIG_ARM64_16K_PAGES=y ( kernel warning as below )
> 
> No warning noticed with 4K page size.
> CONFIG_ARM64_4K_PAGES=y works as expected

You might want to cc Joanne since she's been working on large folio
support in fuse.

> First seen on the tag next-20250721.
> Good: next-20250718
> Bad:  next-20250721 to next-20250723
> 
> Regression Analysis:
> - New regression? Yes
> - Reproducibility? Yes
> 
> Test regression: next-20250721 arm64 16K and 64K page size WARNING fs
> fuse file.c at fuse_iomap_writeback_range
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Test log
> ------------[ cut here ]------------
> [  343.828105] WARNING: fs/fuse/file.c:2146 at
> fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/4190

	WARN_ON_ONCE(len & (PAGE_SIZE - 1));

/me speculates that this might be triggered by an attempt to write back
some 4k fsblock within a 16/64k base page?

--D

> [  343.830969] Modules linked in: btrfs blake2b_generic xor xor_neon
> raid6_pq zstd_compress sm3_ce sha3_ce drm fuse backlight ip_tables
> x_tables
> [  343.833830] CPU: 0 UID: 0 PID: 4190 Comm: msync04 Not tainted
> 6.16.0-rc7-next-20250723 #1 PREEMPT
> [  343.834736] Hardware name: linux,dummy-virt (DT)
> [  343.835788] pstate: 03402009 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> [  343.836455] pc : fuse_iomap_writeback_range+0x478/0x558 fuse
> [  343.837294] lr : iomap_writeback_folio (fs/iomap/buffered-io.c:1586
> fs/iomap/buffered-io.c:1710)
> [  343.838178] sp : ffff80008b26f8d0
> [  343.838668] x29: ffff80008b26f8d0 x28: fff00000e7f8c800 x27: 0000000000000000
> [  343.839391] x26: fff00000d4b30000 x25: 0000000000000000 x24: 0000000000000000
> [  343.840305] x23: 0000000000000000 x22: fffffc1fc0334200 x21: 0000000000001000
> [  343.840928] x20: ffff80008b26fa00 x19: 0000000000000000 x18: 0000000000000000
> [  343.841782] x17: 0000000000000000 x16: ffffb8d3b90c67c8 x15: 0000000000000000
> [  343.842565] x14: ffffb8d3ba91e340 x13: 0000ffff8ff3ffff x12: 0000000000000000
> [  343.843002] x11: 1ffe000004b74a21 x10: fff0000025ba510c x9 : ffffb8d3b90c6308
> [  343.843962] x8 : ffff80008b26f788 x7 : ffffb8d365830b90 x6 : ffffb8d3bb6c9000
> [  343.844718] x5 : 0000000000000000 x4 : 000000000000000a x3 : 0000000000001000
> [  343.845333] x2 : fff00000c0b5ecc0 x1 : 000000000000ffff x0 : 0bfffe000000400b
> [  343.846323] Call trace:
> [  343.846767] fuse_iomap_writeback_range+0x478/0x558 fuse (P)
> [  343.847288] iomap_writeback_folio (fs/iomap/buffered-io.c:1586
> fs/iomap/buffered-io.c:1710)
> [  343.847930] iomap_writepages (fs/iomap/buffered-io.c:1762)
> [  343.848494] fuse_writepages+0xa0/0xe8 fuse
> [  343.849112] do_writepages (mm/page-writeback.c:2634)
> [  343.849614] filemap_fdatawrite_wbc (mm/filemap.c:386 mm/filemap.c:376)
> [  343.850202] __filemap_fdatawrite_range (mm/filemap.c:420)
> [  343.850791] file_write_and_wait_range (mm/filemap.c:794)
> [  343.851108] fuse_fsync+0x6c/0x138 fuse
> [  343.851688] vfs_fsync_range (fs/sync.c:188)
> [  343.852002] __arm64_sys_msync (mm/msync.c:96 mm/msync.c:32 mm/msync.c:32)
> [  343.852197] invoke_syscall.constprop.0
> (arch/arm64/include/asm/syscall.h:61 arch/arm64/kernel/syscall.c:54)
> [  343.852914] do_el0_svc (include/linux/thread_info.h:135
> (discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2)
> arch/arm64/kernel/syscall.c:151 (discriminator 2))
> [  343.853389] el0_svc (arch/arm64/include/asm/irqflags.h:82
> (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> [  343.853829] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
> [  343.854350] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> [  343.854652] ---[ end trace 0000000000000000 ]---
> 
> 
> 
> ## Source
> * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
> * Project: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250723/
> * Git sha: a933d3dc1968fcfb0ab72879ec304b1971ed1b9a
> * Git describe: 6.16.0-rc7-next-20250723
> * kernel version: next-20250723
> * Architectures: arm64
> * Toolchains: gcc-13
> * Kconfigs: defconfig + CONFIG_ARM64_64K_PAGES=y
> * Kconfigs: defconfig + CONFIG_ARM64_16K_PAGES=y
> 
> ## Test
> * Test log 1: https://qa-reports.linaro.org/api/testruns/29227309/log_file/
> * Test log 2: https://qa-reports.linaro.org/api/testruns/29227074/log_file/
> * Test run: https://regressions.linaro.org/lkft/linux-next-master/next-20250723/testruns/1713367/
> * Test history:
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250723/testrun/29227309/suite/log-parser-test/test/exception-warning-fsfusefile-at-fuse_iomap_writeback_range/history/
> * Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/30G3hpJVVdXkZKnB15v1qoQOL03
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/30G3dvSFyHHQ3E8CvKH7tjU98I6/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/30G3dvSFyHHQ3E8CvKH7tjU98I6/config
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

