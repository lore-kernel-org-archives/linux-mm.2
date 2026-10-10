Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF93CA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F96E6B0099; Fri,  9 Oct 2026 22:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1656B009B; Fri,  9 Oct 2026 22:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAF76B009D; Fri,  9 Oct 2026 22:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3A026B0099
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:59:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F91F80704
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:59:39 +0000 (UTC)
X-FDA: 85305211278.19.02D6379
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1A13120004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:59:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ll9asCl7;
	spf=pass (imf29.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791601177;
	b=ESH3DG2MA/J+w2UdsJQh9lPbmne2d6zVxueB0ZiqPN4nOiyIfoMDXEQAv8CMKBw1mBqFgQ
	E0rNSglml9u/ZU5XJ3eEOjZfdG/+/P42NsbVICh7aJP1DPe9cc1PecO1lEh1HGE8J2PXLY
	I/X5GuDEGXnyuANwhye5Y/lwo/kJfCI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ll9asCl7;
	spf=pass (imf29.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791601177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=dNztIAkT027bgLvG/VQPdxghtem94iH2j1PE9vpwbWk=;
	b=ALodl/tTn81Fvc0I7xuy31tyZ3pGhNfjLzh8SGiRXoNj/o9lVDvMtwnqpEeXk1DC8jrYii
	Mfcra/R1uE0gxzhjPND3aTOFRIwNL9rpAZiyuNWvjCC42TvK+BW/dFnlP2WVtMvWA+hujS
	vepKbH5MzTAY0eL81oc13P8uON45YQQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791601177; x=1823137177;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=Lmzi9xD+MtFDsvia7u2Hw0Yuu44BmeRtKvAQ5SQT7cY=;
  b=Ll9asCl7J9FeNzw4ss6mw9sOis9ptCgIt/ckN2vz+/t/l+bgNb+E1kza
   zOiMIoG52kzx62AwzrzpdjyE3vmU3yGM23vV6GKeiulf3wITwF/0tedvR
   Fif3uCqUeBu4Sgy3R932Djjwxw6zl8ltzPAg5gtTz0KLiDHBFMx7zpjoV
   BSmLZ7lsQscWUQmF4HX5UD4+kzEb/SZR19kotWv6UxVJr22JLa8rcnioa
   nF9dWVKdUgOZmKGBuXkZAWFR57R4i9+5vOq+atPFZMjv92/ak4qapfn59
   mWqQrYYmcYsNNcDHzhiiDGdyz70QPj0EMUDh65771yFlmgg/QIhkN7ft0
   w==;
X-CSE-ConnectionGUID: iILG23w+QuaImLRiVtTsDg==
X-CSE-MsgGUID: zwR5Y4oBRbmSdKOXX81zXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="297250"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="297250"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 19:59:36 -0700
X-CSE-ConnectionGUID: D0WT4WvpRAWa+I2cCRGTnA==
X-CSE-MsgGUID: 5I+VBCSRRdyWLhvWpsksMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="541414"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 19:59:27 -0700
Date: Sat, 10 Oct 2026 10:59:24 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Luigi Rizzo <lrizzo@google.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>, netdev@vger.kernel.org,
	driver-core@lists.linux.dev, linux-doc@vger.kernel.org,
	Luigi Rizzo <lrizzo@google.com>, yi1.lai@intel.com
Subject: Re: [RFC: DMA_PMD 02/22] iommu/dma: add DMA_PMD pool lifecycle and
 page recycle hook
Message-ID: <202610101013.706708d0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003212241.3432303-3-lrizzo@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1A13120004
X-Rspam-User: 
X-Stat-Signature: 4gcu1pngggd3utse7pfnij7gtbrwqe6q
X-HE-Tag: 1791601176-653226
X-HE-Meta: U2FsdGVkX1+UmPlb0V6pvdgExl9t7QispUs7n5z4K3SZiCRZMOcv+kdvzY4h10iM0sLFSL//+JXFOHHgkfCNUodHI6zOAQJeJyDHoGR08Z4iH4dakYDUwo4af2eIweVBod7zlLOdbFxUBl3N6rHUdJ2nkaQS/AbdPVZbKJ2FfMbU9on5oq1tM7RO9G0U8yKVuoxvfOZeLJxWfdaR0Ys+XVzx9j/sTsmgljZcGiVMuqBJC+e3q22ImFo70vNilF+/YslD+8vehqa234ppUV3XWWr1oRtQeWfTBld7aQZuAAUm1vff+d1gBs4cvdo2PkIv0J3qp5jkX9fUlm5HdVpRUrIxmRXChNxWQ36yo1dOSM1zSEJLCuWwThZ2m3jXIuyml2VagGTK7L9o9mkZRkgzk2CKSsgoZf1olujqeTe9HmmliogB87MZtNWL3Tm0DklQv1DAXks+BqO5o0gjCFbbKIsbROQngnJ2puSYQ3sy4k2Xzr8WE53z0S4Fgz2AT6174q53tORdp783KwACfFqIfsXxz1/mKvjyo2fq8LpkcvhGJYMBJ+uVVFpYYGSTpY+Df36NG2LfhALjigcKSxAQCTeMe/MwuAugYheL8hbZf4Ez1Rkfi5A0olkV5ffmTDjNaaUmkdTFBEh6hKhkmFqjhZ32CQd3J5D6LLL+TjXOAoA+z0BijXKPxPShspsvL9KelvzEuX3X1gYLNW75v2+1sOJOeRLxODWPVXDP1o6oUOyQaWGmd4MOhxEQwzpKpjVE8EpmLgdwltf645RiKx3IhN+9Lr9XLi5pvU4Hu0+LgvBcOEzmtvFBZGNkWq5IdNHqt8la4NJT+ob+NK1fKNalx+Yqxt+vTYqFin80gF2qciLIco2ADwQXOgj+0/GaQr3Qiz9tNFy6i1LPdsrjo3sV/rfFxQBtOvef0TOQGwxnXuM8NoLlUoabg0WI1C6mqt4DggFHdNmHqjijHVPSA74
 VWCP4k1d
 zrJtVmQp2hOt6XRHQLv6IFj3WS0o0/044IgX0jqxzaoMUl5O5mmZN+q9tnuucPd54HmFVMv8ksC5IqfTv9mmjzygu7QEU9qh36Z6qHIaxR2ceq+GzZgQOFq0lOo2SjG1hvDQQ3wNvwR+K3II2lLRvJAl8WbKYJCYDupmxYLiIGLQna0m3TaWzYNE5xpmYPH1d75kMKngqflcpDrD853BKGL1uwkZDYS0apQbRYrg2m/xsYNwowvS+eOnAUdiw/NL0rIMK3amtD0HKpO4auatNJe1IYciX0Dg3MFJxpvy2EbEWB37+PwGsJNOm8jwDylBxO32LBoo/BSwmSiFCZULyuN32LVu/KLYmUne9cU2D6WEmFQ/7Q+JcIsiJ0xbB3QWOuF6kjGoEnOzFzegAF6/x9fAmPwDayDh7lj6IpeWenKAu3nQtsRFu1sEU407B4Mlkj5ePphj428Y95e8/PIF0iB/LsqN7vIx7SsW7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

kernel test robot noticed "WARNING:at_kernel/workqueue.c:#alloc_workqueue_va" on:

commit: 3311715530328ddf9249e312fa817c89b767fde9 ("[RFC: DMA_PMD 02/22] iommu/dma: add DMA_PMD pool lifecycle and page recycle hook")
url: https://github.com/intel-lab-lkp/linux/commits/Luigi-Rizzo/iommu-dma-introduce-CONFIG_DMA_PMD-and-metadata-table/20261003-212220
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything patch link: https://lore.kernel.org/all/20261003212241.3432303-3-lrizzo@google.com/
patch subject: [RFC: DMA_PMD 02/22] iommu/dma: add DMA_PMD pool lifecycle and page recycle hook

in testcase: boot

config: x86_64-rhel-9.4-rust
compiler: clang-22
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 4 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)

If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202610101013.706708d0-lkp@intel.com


[    0.966875][    T1] ------------[ cut here ]------------
[    0.972831][    T1] workqueue: dma_pmd is using neither WQ_PERCPU or WQ_UNBOUND. Setting WQ_PERCPU.
[    0.978823][    T1] WARNING: kernel/workqueue.c:5939 at alloc_workqueue_va+0x75a/0x7c0, CPU#3: swapper/0/1
[    0.983827][    T1] Modules linked in:
[    0.985221][    T1] CPU: 3 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.3.0-rc5+ #1 PREEMPT(lazy)
[    0.988734][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    0.991819][    T1] RIP: 0010:alloc_workqueue_va (workqueue.c:5938)
[    0.993522][    T1] Code: 00 08 00 00 e8 40 08 f0 ff e9 cb f9 ff ff 0f 0b e9 cd fe ff ff 0f 0b e9 c6 fe ff ff 48 8d 3d 66 07 18 02 49 8d b6 b8 00 00 00 <67> 48 0f b9 3a 41 81 cc 00 01 00 00 e9 75 f9 ff ff 48 8d 3d 57 07
All code
========
   0:	00 08                	add    %cl,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	e8 40 08 f0 ff       	call   0xfffffffffff00849
   9:	e9 cb f9 ff ff       	jmp    0xfffffffffffff9d9
   e:	0f 0b                	ud2
  10:	e9 cd fe ff ff       	jmp    0xfffffffffffffee2
  15:	0f 0b                	ud2
  17:	e9 c6 fe ff ff       	jmp    0xfffffffffffffee2
  1c:	48 8d 3d 66 07 18 02 	lea    0x2180766(%rip),%rdi        # 0x2180789
  23:	49 8d b6 b8 00 00 00 	lea    0xb8(%r14),%rsi
  2a:*	67 48 0f b9 3a       	ud1    (%edx),%rdi		<-- trapping instruction
  2f:	41 81 cc 00 01 00 00 	or     $0x100,%r12d
  36:	e9 75 f9 ff ff       	jmp    0xfffffffffffff9b0
  3b:	48                   	rex.W
  3c:	8d                   	.byte 0x8d
  3d:	3d                   	.byte 0x3d
  3e:	57                   	push   %rdi
  3f:	07                   	(bad)

Code starting with the faulting instruction ===========================================
   0:	67 48 0f b9 3a       	ud1    (%edx),%rdi
   5:	41 81 cc 00 01 00 00 	or     $0x100,%r12d
   c:	e9 75 f9 ff ff       	jmp    0xfffffffffffff986
  11:	48                   	rex.W
  12:	8d                   	.byte 0x8d
  13:	3d                   	.byte 0x3d
  14:	57                   	push   %rdi
  15:	07                   	(bad)
[    0.999820][    T1] RSP: 0000:ffffcb9d00013a90 EFLAGS: 00010246
[    1.001542][    T1] RAX: 0000000000000000 RBX: ffff8b7380b46400 RCX: 33ebeeb162fc7d00
[    1.004550][    T1] RDX: 0000000000000007 RSI: ffff8b7380b464b8 RDI: ffffffff8e484980
[    1.006818][    T1] RBP: 0000000000000000 R08: 00000000646d705f R09: 000000000000000f
[    1.008790][    T1] R10: ffff8b7381cec680 R11: ffffffff8ea6ca80 R12: 0000000000000008
[    1.011630][    T1] R13: ffffffff8da42c29 R14: ffff8b7380b46400 R15: ffffcb9d00013b10
[    1.013818][    T1] FS:  0000000000000000(0000) GS:ffff8b7721089000(0000) knlGS:0000000000000000
[    1.016639][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.018818][    T1] CR2: 0000000000000000 CR3: 00000003e4e20000 CR4: 00000000000406f0
[    1.021819][    T1] Call Trace:
[    1.022829][    T1]  <TASK>
[    1.023829][    T1]  ? iommu_dma_forcedac_setup (dma-iommu.c:?)
[    1.025515][    T1]  alloc_workqueue_noprof (workqueue.c:6049)
[    1.026818][    T1]  ? blake2s_update (crypto/blake2s.c:131)
[    1.028234][    T1]  ? intel_cleanup_irq_remapping (irq_remapping.c:?)
[    1.029818][    T1]  dma_pmd_init (iommu/dma-pmd-pool.c:373)
[    1.031195][    T1]  do_one_initcall (main.c:1358)
[    1.032833][    T1]  ? get_random_u32 (char/random.c:396 char/random.c:541)
[    1.033826][    T1]  ? __get_random_u32_below (char/random.c:555)
[    1.036270][    T1]  ? alloc_from_new_slab (linux/spinlock.h:425 slub.c:4519)
[    1.037829][    T1]  ? refill_objects (slub.c:7424)
[    1.038818][    T1]  ? irqentry_exit (linux/irq-entry-common.h:539)
[    1.040264][    T1]  ? asm_sysvec_apic_timer_interrupt (x86/include/asm/idtentry.h:674)
[    1.045448][    T1]  ? parameq (params.c:91 params.c:99)
[    1.046722][    T1]  ? parameq (linux/fortify-string.h:218 params.c:99)
[    1.051786][    T1]  ? do_initcall_level (linux/srcutree.h:?)
[    1.054571][    T1]  ? parse_args (params.c:153)
[    1.056827][    T1]  do_initcall_level (main.c:1420)
[    1.058834][    T1]  do_initcalls (main.c:1436)
[    1.060827][    T1]  kernel_init_freeable (main.c:1671)
[    1.063560][    T1]  ? rest_init (main.c:?)
[    1.065827][    T1]  kernel_init (main.c:1561)
[    1.067786][    T1]  ret_from_fork (x86/kernel/process.c:158)
[    1.069828][    T1]  ? rest_init (main.c:?)
[    1.072821][    T1]  ret_from_fork_asm (x86/entry/entry_64.S:245)
[    1.074826][    T1]  </TASK>
[    1.076251][    T1] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261010/202610101013.706708d0-lkp@intel.com


--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



