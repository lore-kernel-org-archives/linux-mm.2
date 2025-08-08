Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DE4C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 16:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1EA6B0093; Fri,  8 Aug 2025 12:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589F76B009C; Fri,  8 Aug 2025 12:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6D76B009D; Fri,  8 Aug 2025 12:10:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2C16B0093
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:10:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10636587CD
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:10:02 +0000 (UTC)
X-FDA: 83754076644.18.ADE3C32
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf18.hostedemail.com (Postfix) with ESMTP id 598811C000B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:09:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dQaGhtxe;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754669400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ztwa3E6zBXFgmIFx5dajTfpolgmMbhkThODF1dOX7/c=;
	b=6TrPEbBx7LTx14OdlXZoAP3gk6/9T+zYXurBy6JzlyHTpba38IbI2ASDB/ZLc0aOjwOE9H
	Fhsjz/T6ph0UKcZyFKbObHPLPFHzqrHuZaUWh2vxFtJ48l5SzChxN3jF6y6C2Q5MMcW5fS
	XUISRctQN4N4V+WBrsvHvst0054Isos=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754669400; a=rsa-sha256;
	cv=none;
	b=X/F1Dpht/VQDSdaCXBNjEG/w2o9YR5NDjInwq50zXxxRBQGodPipEgtahvxzHHha5B7IxA
	vgfUZ3NZwW518yngHFUvSVTfgwkeB8lks/SDXDCTUWV92TjbwE8lTCbGVPJGnfSGzmn8mF
	WIsy2uGOjR3s2UEsppGbrYFXIVDtsn8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dQaGhtxe;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754669399; x=1786205399;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=1gA6fLbXCVZ/IsZpo3OVj8n+DPFkUUUcn+HUBENLZIU=;
  b=dQaGhtxegQ/Sjs9WjoEDjVIq/t1qBON5OzZt6csivpBqAX3al4W5Jcwc
   vRcz8LRw6tvvQWpwcXqtKuZ1J4tb4hOI6iMeYdUwNeQc7kPzPkbiMqHgW
   YHTBnxoRzPToLkr0SiAA4d5fuvMPouug86vC6y8+0FzbHW2SEkKImiYRU
   lZFkuvqPMpYiE47L2/cSunAwxVHccEhKIgAerf6RD5h1jyJGFys5hhrhy
   uzexIPEbTRlppzM+C7d4T9TK6eenr08g4TlKiGlswrrAYm1Nm8dhkO/RK
   vSFlq9X5DYhxSaHA9Jg677TEmqP2EQ61xGIL9MGHATX0za2w0Za+moCWI
   g==;
X-CSE-ConnectionGUID: ZqeZkfF5Sk279+JNAKDZsg==
X-CSE-MsgGUID: 02wD3vl1R0+kE2DUdj1Lgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="74469728"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="74469728"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 09:09:58 -0700
X-CSE-ConnectionGUID: rlnIml0bRuCRxUvRwhvJbA==
X-CSE-MsgGUID: SmC7fKTqRZ2jYJGXHTSUzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="165732140"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 08 Aug 2025 09:09:55 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ukPfF-000466-0k;
	Fri, 08 Aug 2025 16:09:53 +0000
Date: Sat, 9 Aug 2025 00:09:05 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>, Kees Cook <kees@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: ld.lld: error: Function Import: link error: linking module flags
 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at
 1229286), and 'i32 1' from vmlinux.a(vma_exec.o at 1246866)
Message-ID: <202508082339.sjRnzZrX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 598811C000B
X-Stat-Signature: meftf9wqjkai68jbf63pgfwrrrgmc5xn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754669399-910519
X-HE-Meta: U2FsdGVkX192srM1yo9XptE6iY4FGepWcPHXgmmmvytOgAjRzcTJqCg4T386QNbhobhcgyC+CZu8Y7wbTxpugCg8kZ0rAkNE42NomlWW7t7p1XtEaaO9ZndTUS1RjZVjeIqFlDPXmr0e/1EOmEKBCUeqeHVN92Q6/a1d1sSv+0+A6IRfTOcgCkhMOugQj8QDaDMHJxzl74UfPvpUh05qeSFkZ6acRNBGPshywOBbv0trVnK0wdrF2hsZNHf2cWL4qMbkyfecP+YbMHKqk1SYJMerZ5AqBX0XnFe5AIYJSSXI4UfJsHJ6nqtvegAhZqDKDd2P43pLKDv0hmDZYitk27Fo+F0T8wJtIdStgGPjWvhB7iYaqvN5w61KJScTK2MjmgD2GwIEIcFE8qwaIcj21YQVOYmGMMQNRXzOky3GRVLnrjEqlRkxPYhQIZFdWfzaISZTTcy1Y4eZtIo4dQtQStub4ruetFHCtFVTtzhLOpztKZXS8V0U0FqtpEwrQzKbasQHxZ7lIrlcA9ibFa4RMzw/gMeYQD8q9U+KurQGZBMBQQENgFY8e1pAicfxZKMSY4cWTAtXybf5KKpOvNaqVaYClJqPU2ur0DCLX8r0JrFCPXp2LYBUV4F7r8aS1s0OmRxnZxr3XfCtIy0uhiUPhWqT+yaieXOkF69NMYEG72C7I15E+zRWqDHtiF2lD8UQw1V78ESTkT6Ybm10/9OsYenlnjd2GS/UXZiRRem48YizF+y6rxWNVht7j803ozKoAETBP8B0txXAsBWPlNuTZy3WxP++dH+7oHL+LKkZzCtvr0E459jhaBhZVZTR5OuxhOmR6HTPMPk5tvaxfT3lIPF+Y4GPsZTrH8wU5mIgrxZY1ham0zpdxThUv2f5GpgUN4Muuu9vZ2TECYQ9YsvKQLA8ttQAyMRLJBp50/Y7F1W0gHFPnCDz1PY5tbpwQSN18fS92pf2Nb6nYKS0nuE
 SzH1cRpU
 4LakpqCUAKvFItP3NiRHKc8rbuiAQfnZn4p2+QMpMrGq6l/Zcc7jwOVZ0xY+hXXxPBMetmJrY0rRyJdEP7UZPD8gDZKGcVmOU2011Gy92LMZc6m+clxyCUkRLBMysC1VQuRXbq5ZD2MjVApCLo8r/zspMNrLkFA1/NxIPcSAx0bzG0+1zsaBsw4Jq9qPYwntrXJ0LfmLCpzj/888KGnEM0fMoqu96aA32WNVBuPv6R0wnLXsBSKiCQ2nk9hJJd/TH2Yl/9rMxFDjIfw4oEYTHLF+DB4rmUazN2+a8My0M1sqn5+7IH4G7IPy0q+t/qTJQhbRHa/pSZDMC/AHilm/aVdtRnn3duCr3VwqCJ5gJ36f9MExdOLx1/2F1LEEhNKrhFsSti2OUshos+zlzlMcPtLsd1wnbDmG2G6HOhojlIxi9xPEtc1UmwV9SJ028yJ0k4PD3IwQob/VA5XmC5KijrC5exQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   37816488247ddddbc3de113c78c83572274b1e2e
commit: dd7a6246f4fd6e8a6dcb08f1f51c899f3e0d3b83 mm: abstract initial stack setup to mm subsystem
date:   3 months ago
config: riscv-randconfig-r071-20250729 (https://download.01.org/0day-ci/archive/20250808/202508082339.sjRnzZrX-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 1b4db78d2eaa070b3f364a2d2b2b826a5439b892)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250808/202508082339.sjRnzZrX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508082339.sjRnzZrX-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(core.o at 1243626)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(ring_buffer.o at 1239546)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vmalloc.o at 1246746)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(memory.o at 1246026)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(main.o at 1225686)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(output.o at 1404306)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(mmap.o at 1246206)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vma.o at 1246806)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem.o at 1315866)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem_shmem_helper.o at 1317846)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(virtgpu_vram.o at 1327806)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 1' from vmlinux.a(alternative.o at 1226286), and 'i32 3' from vmlinux.a(init.o at 1229286)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(direct-io.o at 1251666)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(debug_vm_pgtable.o at 1247886)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem_dma_helper.o at 1317726)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(blk-lib.o at 1282566)
>> ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vma_exec.o at 1246866)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(context.o at 1229706)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(setup.o at 1226826)
   ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(physaddr.o at 1229886)
   ld.lld: error: too many errors emitted, stopping now (use --error-limit=0 to see all errors)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

