Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B447CA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 17:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDE46B016F; Tue, 26 Aug 2025 13:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B37E6B0170; Tue, 26 Aug 2025 13:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C96C6B0171; Tue, 26 Aug 2025 13:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 285E66B016F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:07:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9907B6A2D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:07:13 +0000 (UTC)
X-FDA: 83819539146.10.1035DA3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id C42511C0007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:07:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Oznd+yRk;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756228031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YBzx3ViW4EtXrDzQLBj1kqbllLCE4w7CGaagrpml8nU=;
	b=J6l03Pq8saXvDeWD00qz37oJdWGUFJoFc6FLZ2fTt5NMiBh+m2Tii8g5JbJ0Bi24wnQjUE
	2xnLP7CRnGKHsqz5uoSGjbyTHxh5nx7EB5JAO9Z+BIXjko6PyzSJFmxqetD/DU7FkdCZ/y
	s+TKC9X2+QxDRl2KAsa2MTqAG3qh65c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Oznd+yRk;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756228031; a=rsa-sha256;
	cv=none;
	b=VddlShnPx2EkUmWeHfX8Pbz8Nrg+clzkedGQRWoWYZPkURBwrv7VaQ3sSnWmO3/tixmQK+
	ZLaPh9Ssh5Ivby8lyR+19aYIyOGxnKPTQZBKACs5P84m+BxtjLQ8mRlHwNn9jkJOnrO30Q
	SY/0yAPbdQH7G5QBQMThrPMn/h8M5r0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756228031; x=1787764031;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Xim6uq+1U5KRge/G8NjQ7QH9Y4Ln6m7wN1iOQxDfl44=;
  b=Oznd+yRkJ2vORgoAxKGpBPFhvEhmVZrwhs/IgP8KYpFsZXPoweQLt7yh
   O4eCe+jEZlIvFEOkkWMLFLQaxWDOBXDHrHhymofBlmgSKanQMo96vwdz1
   N+o6+hYoqHiKD+QJDxIH3SgP1aH/pt5UeLOorkPTc2hijCHqdbCTUBBxq
   TZuWhf239bf2mhOYqMve++P1f3zRRb7NTecbZVBD3tpAlevsSaIZlPOYk
   QSiydLsvok1yNH6jIRwqRhaztoenMDhpTCTNMmh+Xqfo6Ll2SLFbYyDXf
   eaQiJDCKn6B6adiXSafoVN/4cASZkR0OwXd4vu29UoISEYhzFyLkm6+4i
   w==;
X-CSE-ConnectionGUID: a055brBNToWDYIqWpRlgJA==
X-CSE-MsgGUID: AH5KPlw1TyGwcu5N2qI/qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62307064"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62307064"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 10:07:10 -0700
X-CSE-ConnectionGUID: rSUJ+LV/RFOGFzOpJACbOQ==
X-CSE-MsgGUID: yAa0CKbXRqy/yTvxK6l9gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="174931831"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 26 Aug 2025 10:07:07 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uqx8R-000SFH-2I;
	Tue, 26 Aug 2025 17:07:05 +0000
Date: Wed, 27 Aug 2025 01:06:09 +0800
From: kernel test robot <lkp@intel.com>
To: Breno Leitao <leitao@debian.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 23/220] arch/arm64/kernel/kexec_image.c:79:6:
 error: 'struct kexec_buf' has no member named 'random'
Message-ID: <202508270141.fyzLcWqi-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C42511C0007
X-Stat-Signature: 3wb1j5bn57sxzp9jharj9ortfr1ai7iz
X-Rspam-User: 
X-HE-Tag: 1756228030-798482
X-HE-Meta: U2FsdGVkX1869mPurp4FOeUKJQAKDQihPQ2tcZeky+a4cvj6J3vPETK6vkDN2ZeKf5FWrLK8k6vPUOFaOqnZg4rWRkN0v7if4sdUq9ocEQ/IAIeF05JjmqPDDPamm7ceom6UfXvv5iByBa7vjLLeQt7O1o51OgLqc4LJC6c/zg5Etd7ZKDPI182uVQOJFRcmpy1I0OEv1A39H3DG4e8eK6t43dPAzVe6EmlGROVMFIzQQjcZzIBEw1AjZoGdIyx424wEh6ZVLCrnMhnEPw52GatFSsJToT1oOOS5Hg+aUqcDfXO3QbVD/uTAKBHcxV3QAi4KMyxGgKrKreHtzWTu+rNAoRnx5dEysRWRt6rud+2Rn9v9Vg/4TnLRmIddQEM8vPtslwIb7tbunC+SoDRNvpwmTyITs4NQT+p7qbhIZcdWFrW7SXGMVPziQwJPLkJ4Ew2azWAPkmS3GXId1boOzi9UcxNgxJkBgPpiKtj0h6YQbzzuKJAy9Igyzwh5SQgOuKVnXcLfrdP2X1ah+NzbL8HdG+Kuqvt4SRJ5LqckTwjnaBIAzbW+tkX4bYC5eKOw2Yt3bNAHCujVGJlGxLBwQqumr8DZp5wcR2AXdJBnZ0E3LlvYNMa/Wr5+4QeEj7MPdB5lVA33Q6r9St2d/taD4LekT/CmGn77MEpR/62sswBAvXUiTqQbgBWCilD927jr6M9uEWiGhaFTtEr+RjkA9/wqdfXt6d5WNMuiKBtqmfTbTKPa9gQu9JZoUdRDhcvT39vgyxdNohrzR1k22V68wEeox4ktGl/6aaGIV05EbmGcPARXunVZUuM4njnUj/281eaZJQPFEwYTehMHCNa56zRF4MtMyjFj6cM8S6AuT5QQD3ZQpnCwhZvmu8PcpQMedFHTTdfBmXY+L4z0g/j+BBA0Zro2l86qrcZtbLn2gNaD/MRWCtpkW1s5JovYwYROWmGc+IBuFPOo8I0PTzz
 OBOtHftG
 k/apEu6XOv6kiSMsYRMfXBnNTj12h6xvtBZgRL7aaRyhQVnmEksf7LCNaPp1i87gKNgbLryVQ5OgS5R+axNLr+KikFJSKx+jBAZnu+XVswH7FGU/dWPYrwB0qzMzKtWJBLEFRdQ1AyaLOdVV9B8kf9qXdACZBffBYrrzEyvBGuqUnpLkq9uh7mFxquiKt8KYIpOBCfa+hX85q3C0MvsYwhwR828hES9qZ1Ek5j+5jJhcOH1ezxqSb/sNXFC6iMLRMXcFsipWZODN7dz23mXp6vHZgZaePlUT3UWQ1XdM3xzx1h1qDbNKFXAwzSfn1RLtCZ6RfJb2akTxIP874V1SEuzbAItMoed9FX77NHsLQNJP9jlkuqH8ogkOBqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   f279bb633c0aace9bb737f2cfcd7e91deef13356
commit: d2567dc490b0051381940a31f95c98d76ea0e5c1 [23/220] kexec/arm64: initialize the random field of kbuf to zero in the image loader
config: arm64-randconfig-004-20250826 (https://download.01.org/0day-ci/archive/20250827/202508270141.fyzLcWqi-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250827/202508270141.fyzLcWqi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508270141.fyzLcWqi-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kernel/kexec_image.c: In function 'image_load':
>> arch/arm64/kernel/kexec_image.c:79:6: error: 'struct kexec_buf' has no member named 'random'
     kbuf.random = 0;
         ^


vim +79 arch/arm64/kernel/kexec_image.c

    35	
    36	static void *image_load(struct kimage *image,
    37					char *kernel, unsigned long kernel_len,
    38					char *initrd, unsigned long initrd_len,
    39					char *cmdline, unsigned long cmdline_len)
    40	{
    41		struct arm64_image_header *h;
    42		u64 flags, value;
    43		bool be_image, be_kernel;
    44		struct kexec_buf kbuf;
    45		unsigned long text_offset, kernel_segment_number;
    46		struct kexec_segment *kernel_segment;
    47		int ret;
    48	
    49		/*
    50		 * We require a kernel with an unambiguous Image header. Per
    51		 * Documentation/arch/arm64/booting.rst, this is the case when image_size
    52		 * is non-zero (practically speaking, since v3.17).
    53		 */
    54		h = (struct arm64_image_header *)kernel;
    55		if (!h->image_size)
    56			return ERR_PTR(-EINVAL);
    57	
    58		/* Check cpu features */
    59		flags = le64_to_cpu(h->flags);
    60		be_image = arm64_image_flag_field(flags, ARM64_IMAGE_FLAG_BE);
    61		be_kernel = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
    62		if ((be_image != be_kernel) && !system_supports_mixed_endian())
    63			return ERR_PTR(-EINVAL);
    64	
    65		value = arm64_image_flag_field(flags, ARM64_IMAGE_FLAG_PAGE_SIZE);
    66		if (((value == ARM64_IMAGE_FLAG_PAGE_SIZE_4K) &&
    67				!system_supports_4kb_granule()) ||
    68		    ((value == ARM64_IMAGE_FLAG_PAGE_SIZE_64K) &&
    69				!system_supports_64kb_granule()) ||
    70		    ((value == ARM64_IMAGE_FLAG_PAGE_SIZE_16K) &&
    71				!system_supports_16kb_granule()))
    72			return ERR_PTR(-EINVAL);
    73	
    74		/* Load the kernel */
    75		kbuf.image = image;
    76		kbuf.buf_min = 0;
    77		kbuf.buf_max = ULONG_MAX;
    78		kbuf.top_down = false;
  > 79		kbuf.random = 0;
    80	
    81		kbuf.buffer = kernel;
    82		kbuf.bufsz = kernel_len;
    83		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
    84		kbuf.memsz = le64_to_cpu(h->image_size);
    85		text_offset = le64_to_cpu(h->text_offset);
    86		kbuf.buf_align = MIN_KIMG_ALIGN;
    87	
    88		/* Adjust kernel segment with TEXT_OFFSET */
    89		kbuf.memsz += text_offset;
    90	
    91		kernel_segment_number = image->nr_segments;
    92	
    93		/*
    94		 * The location of the kernel segment may make it impossible to satisfy
    95		 * the other segment requirements, so we try repeatedly to find a
    96		 * location that will work.
    97		 */
    98		while ((ret = kexec_add_buffer(&kbuf)) == 0) {
    99			/* Try to load additional data */
   100			kernel_segment = &image->segment[kernel_segment_number];
   101			ret = load_other_segments(image, kernel_segment->mem,
   102						  kernel_segment->memsz, initrd,
   103						  initrd_len, cmdline);
   104			if (!ret)
   105				break;
   106	
   107			/*
   108			 * We couldn't find space for the other segments; erase the
   109			 * kernel segment and try the next available hole.
   110			 */
   111			image->nr_segments -= 1;
   112			kbuf.buf_min = kernel_segment->mem + kernel_segment->memsz;
   113			kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
   114		}
   115	
   116		if (ret) {
   117			pr_err("Could not find any suitable kernel location!");
   118			return ERR_PTR(ret);
   119		}
   120	
   121		kernel_segment = &image->segment[kernel_segment_number];
   122		kernel_segment->mem += text_offset;
   123		kernel_segment->memsz -= text_offset;
   124		image->start = kernel_segment->mem;
   125	
   126		kexec_dprintk("Loaded kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
   127			      kernel_segment->mem, kbuf.bufsz,
   128			      kernel_segment->memsz);
   129	
   130		return NULL;
   131	}
   132	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

