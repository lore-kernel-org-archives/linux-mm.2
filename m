Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B25ECA0EC0
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 21:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CBB58E0002; Fri,  8 Aug 2025 17:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3678E0001; Fri,  8 Aug 2025 17:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0678E0002; Fri,  8 Aug 2025 17:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72ED48E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:53:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 168F5C04DD
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 21:53:20 +0000 (UTC)
X-FDA: 83754941760.08.E760E75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id AC09D80008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 21:53:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lYbLg4Gi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754689998; a=rsa-sha256;
	cv=none;
	b=8LRpvFM1VAcMgiuByBd4MiksM7Bm2+ThxSJeCYE4JQF6ODbSN8XjJqyHwIZI2j+cAZS2Ub
	YQR5tbAJrBEvDRjOorPH30m5B4ZHm+J2wiQ+931AhHNjp4CmVH4By5A6emzaNPLjf8nOqE
	jqww2KLJVp52jbbKlm+Rz95gJk8J21c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lYbLg4Gi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754689998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=in1pSSZxLfL20nG4gMIAAIYL1q/9GSl39XFJyrxDacw=;
	b=EAhJ7LLJjoTfkihLEWxIM/UymQAVEieU/6v7Vm1V2G/jtxdCAmVTu1ajSxB9UKR1UTs7bt
	RMf2nhQc/Ep9W0TCK4KuMze2x4EZWBvgJvnU0oH4muNlvzweUFWiRTFts6wOxYSNK7wKDO
	NSFek3MTnogIS4UsMm1Gi1xTg77USl0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F18566144C;
	Fri,  8 Aug 2025 21:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1511FC4CEED;
	Fri,  8 Aug 2025 21:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754689997;
	bh=Zod0TsMHtgwPaKwYE+/U4AqQ+FNkV4HBXTB6f91BvZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lYbLg4GiGw07oF2xFiGEtFahtPNaTguxQZTnzCPsaP33Ps1Sd5dpiW8Hyd5/tH5fz
	 mNwQTkVnoHd8KUZjNIK+Yrud4qzng0tU9T6Z2/wF6XCUipfQzAz+oqGlla7oRVuQKu
	 4DMlU/Mjyav39rR+6LZEtDFHTv8GCIC7FRQ6VPqWN1Y0lk9mV3Uyn4N+758nnMgSQq
	 TAfj/Ivzh7mUG6hOvUxB117SjPt3roQe5TQM7xa2+gU+P+ltdgxpem4MCU77zInFJB
	 2lVBwI+71nkOi9dtIpA/QEJjRO6cgrmZsSBJjEKfTzXiSiEzoAH4NgpaVDxE9rMWGf
	 ctO+yy1/jYC6g==
Date: Fri, 8 Aug 2025 14:53:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: kernel test robot <lkp@intel.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev
Subject: Re: ld.lld: error: Function Import: link error: linking module flags
 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at
 1229286), and 'i32 1' from vmlinux.a(vma_exec.o at 1246866)
Message-ID: <20250808215312.GA3625764@ax162>
References: <202508082339.sjRnzZrX-lkp@intel.com>
 <j6pxm4n2n3tnan22x73ff3ku6dwr6e65mi4tafjmlyoicbpygi@vbjbioh7p5fx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j6pxm4n2n3tnan22x73ff3ku6dwr6e65mi4tafjmlyoicbpygi@vbjbioh7p5fx>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AC09D80008
X-Stat-Signature: o7741rmpctsmsnbe59swt41y36hih95j
X-HE-Tag: 1754689998-337253
X-HE-Meta: U2FsdGVkX1/iolCPpTm20a9gVmtdP4v0hDJFB7tedsNg+E5IZ7OiYO7BjNnlWIDMpofyFSUCYaSVSOclKAQRI64UGDSbToWCeHZtrGN4yHnW9wfdLBSUB3SLuIdV+yhFlLNrP3GSJycVHJM1Q7n0ff1b4D7ZiSQNBkGAMLSFtgOwqYBEgv4754OD2Gx0JllJEQOA5Q8YWTMj0vuNxVEuSbQECLPwBGQVtSpCzGqUm9ej6jfyzJqO0J58LCGOKE0kWthoMEx5ZevNpmmJNF8gG6D0dKmmqj1Ac+3WCA/Da90ogGQI0Wbi9glz3t9evRFs75vuJpGTWDptCIXFVBJ+nGjbJ/J2wxww8dCFv5VcQ+Pi0MLqI3P6xrKEXfvgqiTcQDGfNQFcriOL3sY7H6a82k9njEzvSJ/qvxJVHxJLe7d72cDLdmhWQtH9Xr+Vf0+2mzaCs9d4Gw+Wlji8kmwChQJw8T76a2SHS43dC501lmekWcRbW6+OccrBQ5EQGgU7pHliyA+Qf9dUOYXbD8zDZPUPRycfMEZbc4PGWzRmimvu1kdgXOsnP0wF8ZKw9Iq9YVV8itvkI/2LrcdmASZ9E6AytgvhV8inirUhqXDfDvJBcibSRLLo2kOl4XEA4LBaqEgUyZLNvM2bbadTVBAynPX0PuBLE2HxXk56xNxwWJPfYCLVTothXbOjfv4bMlrvpdmAh90TL/5xCYSLV290wU6jadaYuhU2RHQvKzkQ8US6UmdBGCX20ZDAfl0+tAK1ljNytuZoV9fOnubGfZdivjSU2V6pMg42ms96oBOD1pGUfU1gdavXNeTyDZqJ6nsFuA2xO6zcFgb1O12d/+plCntwnw7Z+bGyf+e21k0dzFk0/4Lc8jnd1xLGUPL/lXxK6GKycuJUiLgaaDg/p2bFQstLXiEJ2pj+7NShFIENeAQb0/vNw0tA4m3YahjJEXd7Osmt42/AatIX6yO5OGQ
 YglklbQf
 DWkHuopCMuR+Kzyn4+y8Bj3xwCmbLwElXiAgi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 10:32:01PM +0100, Pedro Falcato wrote:
> This doesn't look particularly mm related, CC'd riscv and kernel llvm lists.

Indeed, this should be avoided with [1], I just need someone in the
RISC-V space to pick it up.

https://lore.kernel.org/20250710-riscv-restrict-lto-to-medany-v1-1-b1dac9871ecf@kernel.org/

> On Sat, Aug 09, 2025 at 12:09:05AM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   37816488247ddddbc3de113c78c83572274b1e2e
> > commit: dd7a6246f4fd6e8a6dcb08f1f51c899f3e0d3b83 mm: abstract initial stack setup to mm subsystem
> > date:   3 months ago
> > config: riscv-randconfig-r071-20250729 (https://download.01.org/0day-ci/archive/20250808/202508082339.sjRnzZrX-lkp@intel.com/config)
> > compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 1b4db78d2eaa070b3f364a2d2b2b826a5439b892)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250808/202508082339.sjRnzZrX-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202508082339.sjRnzZrX-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(core.o at 1243626)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(ring_buffer.o at 1239546)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vmalloc.o at 1246746)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(memory.o at 1246026)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(main.o at 1225686)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(output.o at 1404306)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(mmap.o at 1246206)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vma.o at 1246806)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem.o at 1315866)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem_shmem_helper.o at 1317846)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(virtgpu_vram.o at 1327806)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 1' from vmlinux.a(alternative.o at 1226286), and 'i32 3' from vmlinux.a(init.o at 1229286)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(direct-io.o at 1251666)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(debug_vm_pgtable.o at 1247886)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem_dma_helper.o at 1317726)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(blk-lib.o at 1282566)
> > >> ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vma_exec.o at 1246866)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(context.o at 1229706)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(setup.o at 1226826)
> >    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(physaddr.o at 1229886)
> >    ld.lld: error: too many errors emitted, stopping now (use --error-limit=0 to see all errors)
> > 
> > -- 
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> 
> -- 
> Pedro
> 

