Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85891CA5FFF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 08:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9DE6B0135; Mon, 19 Jan 2026 03:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97316B0137; Mon, 19 Jan 2026 03:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96206B0138; Mon, 19 Jan 2026 03:24:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 942966B0135
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:24:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3224F1AEE75
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:24:29 +0000 (UTC)
X-FDA: 84348026658.25.0E7BA0A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70BC1C000C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:24:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BfX8HSCR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768811067; a=rsa-sha256;
	cv=none;
	b=so8HEuSnTeAh1vlv+SpLJWK307bexseHvUeG+vlwfNnflGTnxRm2wPI7v/A22wOAOjtsyl
	uBDwDTqz2MdofDyD2D5736LqQEOR1IdWjW+4WvgBbWd8jJEggHiVL1TSD1hXzzWyWsh23C
	5hmh+YRLF2HK0T3cUaQfhaKGPwnZs6k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BfX8HSCR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768811067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKJijYo++8zcbEKhMHwvqGK3GQboq6DGUl0Qp8eOuZ4=;
	b=ZOWXAQqm67eThG4+TNoYSLS8MhfG04GppMBWgL1oJwGjwyTuu8FTJqoGQE/HE71nLpxt2n
	juPdPpww4tm+kKHudmpurzK9+n/IF65hfkqNKakupjOpK0H7+vLxh20EpqaE9pv6jv/dCA
	J68WWo+iX7vfr4STKOv60XWLExu6fOU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768811067; x=1800347067;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3UoClJcJDW2uoWng1yw1//FZOmo69ZVnggpsjcysDfk=;
  b=BfX8HSCRui6VC29oaPLJmIHaOcVPjQuPHPFtnVMnzVcFKxPwzMeuGlGN
   XbYuKIXpl17sZkyGCmFoMQbmOnddm3y+qgCKITPwOLE3zNf/a7vKxL14G
   EhPaWy4vIJA4KitBhg9U/RMzBFiJ7kBCNBXFe2jHiDoO5v/JfwmKhETE/
   jLZ/BAc7ss6KGUnz2zEWkCoonAx8aMD2akxp+nx1JSdEsS3+WdqO7WxfY
   hC9+6qjyLGfZ/4Yk0MY0W1LmXhA3dIbbDofbqTHtutT3ojxjVZBqn5kIO
   yArcHB8fuZV4e2fcAjfsvpGKlVhO5hVvMHBH/XZniVTq9wIwCJUpvEa13
   A==;
X-CSE-ConnectionGUID: o/FTuDq9TLSWUYTBXhoubQ==
X-CSE-MsgGUID: mBAPc7u2RgSI3nqxaN47tQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69217486"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69217486"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:24:25 -0800
X-CSE-ConnectionGUID: 6JrKYD8FQiOuYUMvH+ySjQ==
X-CSE-MsgGUID: qEu6BI5JSmWE3xRAdt9Yxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="228742759"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 19 Jan 2026 00:24:18 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhkYa-00000000Naz-080r;
	Mon, 19 Jan 2026 08:24:16 +0000
Date: Mon, 19 Jan 2026 16:23:31 +0800
From: kernel test robot <lkp@intel.com>
To: Pingfan Liu <piliu@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Pingfan Liu <piliu@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Simon Horman <horms@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Philipp Rudo <prudo@redhat.com>, Viktor Malik <vmalik@redhat.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>, Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	kexec@lists.infradead.org, bpf@vger.kernel.org,
	systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 11/13] arm64/kexec: Select KEXEC_BPF to support
 UEFI-style kernel image
Message-ID: <202601191626.CUD61tIS-lkp@intel.com>
References: <20260119032424.10781-12-piliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119032424.10781-12-piliu@redhat.com>
X-Rspam-User: 
X-Stat-Signature: nh56widx4nwqcj88fk15xicgetywoq33
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70BC1C000C
X-HE-Tag: 1768811066-907969
X-HE-Meta: U2FsdGVkX19jIZTpVauaFpg5P4b8y1dXnDaMgx75KMNhTJ+KyveHgtQ30tNA38Ki/WFL25jeNpO/Fdd8aBF0k9QMoN6bCq19IDyhD1M9uyyeLsU2w/UpGeptlaI6xSLYFYQe2WiMOB9fwndbzc7ta9Bo0PHOAcZHBxw5bLrh+AZG3wOqfv9wCnD9BeL1tf0lWwDAPCHG0VH1S1zdZsQ584J7zoUHByT1jcaOm/cSVtOK1yHwKdmrZI3iSM8mZbkW4EvyhItCYjswp/4tBwqdo6nlYLsAOX/iqotHqZIzcCFHtncEB5EfrA+c/B8zh3gVdC8qL1upFSTJ5EebXYCrBOYKSSobbiPBP5uVKN+2chpJeXD3dztiz32pTJz9kOFuaI7Kq0e0ZsqhjVC1Q0xIONBzHstq8ciw9mjRjsHQi/43UdA9tCcm6NY4sC5lVm8ow8fzs41MF6LfVnLoxo25BI7mT0i7kS/F3sxkciAQY8NQdJ90Lz8FdU3jwdqi//9RrW9NSTbKJiApkaOlnd12yimpbEoGenLa7R7Rj8kUQks+yLalclufDCRHHOpNzNoJYkOAc6oR3ZkcHlOtEeCsevY4O9w6vJ1VsKqu4wK4QUktATYyQJ+RRkW3HQjM5ETylPa/5gWHdAfrsQwTn7934iTXbIUjFLApI5r8bJ5rBne7CcAY1leXnNVeH1B2M0RnFmtSjyTKIT34U+XUzn63wBolOlvCGxcka3JE1w228rLW1wp4ZnFhS2HVmKMowHRKsb6gztE7KCz9oOgCJU68rlRxbjt96q5J5PB4KdsUa+lZej1WbgE/IQTik/qFOVv9qe7jjg4zWy0dt5MJFGir2te4cZPBDZvAhhkkfXwF775s0oeSoWcx2Kh1nWxsF/109i4XFC/4zQVVc2dVhpIxSzxpvwvRGx7zcx9uXXChUN7zVd48MrJbRSLSjVgII8tOJ2HEQuVB3wum0ASKLTO
 dxDs7Soy
 5wwyAyGSOeuNrtH50FhmGjU21nwgmrSoNG5jYBwZPUhXCRoncJeLQjOIPitXHZg5uDVQLKMx1YXNF1eICTiKOJAWsg9HQHblkXMizLsLK5bGXtEiqQNWUgJ42rHUY5yuzXghB6tYf4SABIBMqv3O2ViW06V3nO4pdyT+eu1n+t4mzSRTZyDYVhRLLR3EW1VmOAmcHWT+Hb54KQNIhUfSUDZdSbJVOJtnoYJJlQSbUnCbWrK/l8LtBsweeiZ7SEa/l9xgjJJ598z3nmR+jYsm7w6mC3M4t3iYOVrFYCYIiolCRZ/us091yiW7tscsIMpCjSaEQtUfJsth9jOUVisGc/ytf5B0494JiG2LkHw1qwPFwgGXSojhkXz3RNe6mBcXaIzByjsfR906JPzg+fY0W7mkAJYYGalVU2s1U6+h1wXXBznDOYM8zMH6watZL/19kM7tcjiAO2kUEu5W0ULFXZG0ySo8FJNHB6XUzosGXmZRIfaSTtkt5RVCqFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pingfan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bpf-next/net]
[also build test WARNING on bpf-next/master bpf/master akpm-mm/mm-nonmm-unstable linus/master v6.19-rc6 next-20260116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pingfan-Liu/bpf-Introduce-kfuncs-to-parser-buffer-content/20260119-112939
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git net
patch link:    https://lore.kernel.org/r/20260119032424.10781-12-piliu%40redhat.com
patch subject: [PATCHv6 11/13] arm64/kexec: Select KEXEC_BPF to support UEFI-style kernel image
config: arm64-randconfig-004-20260119 (https://download.01.org/0day-ci/archive/20260119/202601191626.CUD61tIS-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260119/202601191626.CUD61tIS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601191626.CUD61tIS-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/kexec_bpf_loader.c:103:22: warning: unknown attribute 'optimize' ignored [-Wunknown-attributes]
     103 | __attribute__((used, optimize("O0"))) void kexec_image_parser_anchor(
         |                      ^~~~~~~~~~~~~~
   1 warning generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for KEXEC_BPF
   Depends on [n]: KEXEC_FILE [=y] && DEBUG_INFO_BTF [=y] && BPF_SYSCALL [=y] && KEEP_DECOMPRESSOR [=n]
   Selected by [y]:
   - ARCH_SELECTS_KEXEC_FILE [=y] && KEXEC_FILE [=y] && DEBUG_INFO_BTF [=y] && BPF_SYSCALL [=y]


vim +/optimize +103 kernel/kexec_bpf_loader.c

e683ae405ea0458 Pingfan Liu 2026-01-19   93  
e683ae405ea0458 Pingfan Liu 2026-01-19   94  void kexec_image_parser_anchor(struct kexec_context *context,
e683ae405ea0458 Pingfan Liu 2026-01-19   95  		unsigned long parser_id);
e683ae405ea0458 Pingfan Liu 2026-01-19   96  
e683ae405ea0458 Pingfan Liu 2026-01-19   97  /*
e683ae405ea0458 Pingfan Liu 2026-01-19   98   * optimize("O0") prevents inline, compiler constant propagation
e683ae405ea0458 Pingfan Liu 2026-01-19   99   *
e683ae405ea0458 Pingfan Liu 2026-01-19  100   * Let bpf be the program context pointer so that it will not be spilled into
e683ae405ea0458 Pingfan Liu 2026-01-19  101   * stack.
e683ae405ea0458 Pingfan Liu 2026-01-19  102   */
e683ae405ea0458 Pingfan Liu 2026-01-19 @103  __attribute__((used, optimize("O0"))) void kexec_image_parser_anchor(
e683ae405ea0458 Pingfan Liu 2026-01-19  104  		struct kexec_context *context,
e683ae405ea0458 Pingfan Liu 2026-01-19  105  		unsigned long parser_id)
e683ae405ea0458 Pingfan Liu 2026-01-19  106  {
e683ae405ea0458 Pingfan Liu 2026-01-19  107  	/*
e683ae405ea0458 Pingfan Liu 2026-01-19  108  	 * To prevent linker from Identical Code Folding (ICF) with kexec_image_parser_anchor,
e683ae405ea0458 Pingfan Liu 2026-01-19  109  	 * making them have different code.
e683ae405ea0458 Pingfan Liu 2026-01-19  110  	 */
e683ae405ea0458 Pingfan Liu 2026-01-19  111  	volatile int dummy = 0;
e683ae405ea0458 Pingfan Liu 2026-01-19  112  
e683ae405ea0458 Pingfan Liu 2026-01-19  113  	dummy += 1;
e683ae405ea0458 Pingfan Liu 2026-01-19  114  }
e683ae405ea0458 Pingfan Liu 2026-01-19  115  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

