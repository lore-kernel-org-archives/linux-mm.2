Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A3FED6CFBA
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C576B038B; Thu, 22 Jan 2026 23:05:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B326B038C; Thu, 22 Jan 2026 23:05:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938E26B038D; Thu, 22 Jan 2026 23:05:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF6A6B038B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:05:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CED41359C3
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:26:41 +0000 (UTC)
X-FDA: 84361791402.15.E38931B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf03.hostedemail.com (Postfix) with ESMTP id 313BC2000B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:26:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NWZfYEnn;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769138799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwR4RjVnaOX566o+HrWKpmdVGnCZbsFfd3+Y9n3XP8s=;
	b=Ut8PeaBRcti5xGgCBU2ZpkMYrOvPCTXyuXkI8zjNg0yhONLU3cwrKWARVxDFY74RRXJfz1
	TZI4+w18ii/PwYxjxAeVsw6iMOKEq1nX80IExgJsqgRbwrpbwqdtOFVklErFAvIDFtIkxg
	xU80W7KFvTVR0tSObiBXHTCI6VnmZtY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NWZfYEnn;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769138799; a=rsa-sha256;
	cv=none;
	b=cehOnTYYzt+J/3kxblMGWE5QHvAWFzTThxhNo95hWh9Neb9tpqD6VkfwwXvCXaa/xTACML
	LwiTOy4X8/YvW67TJaY06szkUXI3K5N4bta5kI/7AAexz4/ANk+AfigOZ6ahE2cH4b+9Ct
	cUfmPdEkfTCETQo4QjL0dJDRVyaBTqY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769138798; x=1800674798;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NOXL9m6fEubgub/xwM+k4V/yV9xMOb+Sk90Wkl4s490=;
  b=NWZfYEnnHAvxAQy2lfytHkiG/46pVb6AU7csGCVmpgTSnXxG2h35hCV2
   H1SwbdEufkZtpM/LQ95zYwm9JsRbfvf2Nvis+KaPUe4YQQUgXTHrr935q
   KngCe3pz88aNwOLTcaeJ9/v27s/V7Bik3nAsph9zZYb9tfbt+u+h5iGDW
   TYnRACDOo4FnlZzuQQdhH4kyfuK0V0th2jNvGVJkFlWWlRU+2dQicrebw
   W2VIUoq5rbQW2aPRNM+ID4OIgb3sRTdUhkTJlQB0g9gPTcdarvuOshM03
   9JLq7XTemGbLELRu8L5o0//yxlyqvVs+l5G8pJP/YaetBQAdISj2P3OfC
   Q==;
X-CSE-ConnectionGUID: wkFfWxVJRmeheun2BfF34Q==
X-CSE-MsgGUID: lVr4N3k5QBaWvFtCdbC4qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="81760973"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="81760973"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 19:26:36 -0800
X-CSE-ConnectionGUID: 1UJUUNxqTBO2GGoOwSkStg==
X-CSE-MsgGUID: ri+diFlRRQivG4+m0yc/SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="206960705"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 22 Jan 2026 19:26:31 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vj7oa-00000000TT8-3E5h;
	Fri, 23 Jan 2026 03:26:28 +0000
Date: Fri, 23 Jan 2026 11:25:54 +0800
From: kernel test robot <lkp@intel.com>
To: Thierry Reding <thierry.reding@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: oe-kbuild-all@lists.linux.dev, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <202601231123.4V5wVUur-lkp@intel.com>
References: <20260122161009.3865888-7-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122161009.3865888-7-thierry.reding@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 313BC2000B
X-Stat-Signature: rpi6r77u9kdfz6yd3ddbu69gsyeghr6c
X-Rspam-User: 
X-HE-Tag: 1769138797-410105
X-HE-Meta: U2FsdGVkX1+VUf4t0jfwOmkcsaSDUZ3vet9eektfzYJ7y+6VMnpKMlTPXfiCAotr9ETet+NJc1S78oAshCkOzJC0aNM1k9Kjyre7y6mWmAxUe5YAWt6Xn9pGC0N0YaRBbfmewa0D5IKUtg/D7lTAaC0p0PLlAiGGwpIchV2H6JRVwRa3Qaf1OOHeDU4Z+txBFAT9WwfRXvZLn+doAz42rgySM8IG1K9b+4szIfCUMkoQlFiewdLsUSqH+1KQG/wQd572PC/4IEWyBgIASgoWIm5SVc4S9wWjsDapHAFhNhXuA8AYfeX3zMR/ZSe8F8gmXchoin2azldQfI066NeXWdogN4ZeSCujJIlos2OjSzLsvPg/JfFf2pfH/WYuZnoj160c69ey/kCYAjiETdCkkdRzHXxemBTMKNBEwtlJ+Mz1cvp3D8SgdkoXkNsJoQZ3YRgQ2ALL98m0DYiHNg0/P2AZxmUd5uk0HutMz2m+7xLFuUUPycRLK+tJKqLb9jQGcSXXF6s0yUluP3qQEqRCCxkO40VNkXQn5tyLpF++KhMCJ4WX7f3b64/lckvo/Y8BtF+m3Yr7qvDkFG9ZH1Nu+YlUkPfMuRskEmJlbxVpoJ4P9wpdIeVtoN2q/RpxwlohkFtDDoh+V14tHWjCCHhThWdGyBlKKBNp6390KekgvE7rvUaPQi2vWZ8RNsWoY5OofCT/BPMOS4hpRwcfZavF/1fHmDncAcanPGKsDqOXdygRNAObTR5ZII71+lQmtGa0xut5bI4/sZLrfc//DvonBnNiJ1hEag6Av22NQzDP54Yh+dDc2wJs8YlM79TWHqsQWLPZE6xU3xUueyj8Zf4y5NI4zUpPHvBSIRrpu1eWz4o4XahZ/gdqQ+PWfXZHkGic1CHWriiCGHp485Qje+IvPVb37LAVFyi2mOCDmMjW2C2U/z97q7Icq4Nsm6P2vzTcvASZg2UZS1yD0Fwhmbh
 RZnXk1JF
 zDHua+G8VfBaLnkw/Mphtt7osH0qLofCr/wyC2dYLWImhl5myTn/DVJyxJws68rR3gxTk/zvuaD0OUWrvg6jhl1hZChVs2ra3vgqnFWiuzm6PFc+BIfaVhRnISo8stNHAAZO1AYXeVxdMsTp31hhJUri1VpAdQ+8jB6+DZ8Jv35Rd+id5JOWRNSdUhxY4+kEwUvq5KRAzzXjPHLY787Lc00lziCuuAJ6ro52nHMkvsQ6+yt8uhL5/w3Qq+ofOc0o9PXR1SMPJw3i2a0HXtu1VndLwNtY7r3rpFhy/DUH5YYBWDppCpmrxuk7qmPgrxylo/aiMs0X9SjwUiiokqUNi69ky5dIiRSv2bIDPHQpglDiMUnK6aiLfyxD7yLCJi9+/WwClmwXo+81A3mk28USzsWMVMnbbZEksQuu50VW1PBDRBR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thierry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on next-20260122]
[cannot apply to drm-misc/drm-misc-next robh/for-next linus/master v6.19-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thierry-Reding/dt-bindings-reserved-memory-Document-Tegra-VPR/20260123-001244
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260122161009.3865888-7-thierry.reding%40kernel.org
patch subject: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20260123/202601231123.4V5wVUur-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260123/202601231123.4V5wVUur-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601231123.4V5wVUur-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_protect_pages':
   drivers/dma-buf/heaps/tegra-vpr.c:205:21: error: implicit declaration of function '__ptep_get'; did you mean 'ptep_get'? [-Wimplicit-function-declaration]
     205 |         pte_t pte = __ptep_get(ptep);
         |                     ^~~~~~~~~~
         |                     ptep_get
   drivers/dma-buf/heaps/tegra-vpr.c:205:21: error: invalid initializer
   drivers/dma-buf/heaps/tegra-vpr.c:207:15: error: implicit declaration of function 'clear_pte_bit'; did you mean 'clear_ptes'? [-Wimplicit-function-declaration]
     207 |         pte = clear_pte_bit(pte, __pgprot(PROT_NORMAL));
         |               ^~~~~~~~~~~~~
         |               clear_ptes
   In file included from arch/x86/include/asm/paravirt_types.h:11,
                    from arch/x86/include/asm/ptrace.h:175,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:13,
                    from arch/x86/include/asm/timex.h:5,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/fs_dirent.h:5,
                    from include/linux/fs/super_types.h:5,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/debugfs.h:15,
                    from drivers/dma-buf/heaps/tegra-vpr.c:12:
   drivers/dma-buf/heaps/tegra-vpr.c:207:43: error: 'PROT_NORMAL' undeclared (first use in this function)
     207 |         pte = clear_pte_bit(pte, __pgprot(PROT_NORMAL));
         |                                           ^~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c:207:43: note: each undeclared identifier is reported only once for each function it appears in
     207 |         pte = clear_pte_bit(pte, __pgprot(PROT_NORMAL));
         |                                           ^~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c:208:15: error: implicit declaration of function 'set_pte_bit'; did you mean 'set_pte_at'? [-Wimplicit-function-declaration]
     208 |         pte = set_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
         |               ^~~~~~~~~~~
         |               set_pte_at
   drivers/dma-buf/heaps/tegra-vpr.c:208:41: error: 'PROT_DEVICE_nGnRnE' undeclared (first use in this function)
     208 |         pte = set_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
         |                                         ^~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c:210:9: error: implicit declaration of function '__set_pte'; did you mean 'set_pte'? [-Wimplicit-function-declaration]
     210 |         __set_pte(ptep, pte);
         |         ^~~~~~~~~
         |         set_pte
   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_unprotect_pages':
   drivers/dma-buf/heaps/tegra-vpr.c:218:21: error: invalid initializer
     218 |         pte_t pte = __ptep_get(ptep);
         |                     ^~~~~~~~~~
   drivers/dma-buf/heaps/tegra-vpr.c:220:43: error: 'PROT_DEVICE_nGnRnE' undeclared (first use in this function)
     220 |         pte = clear_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
         |                                           ^~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c:221:41: error: 'PROT_NORMAL' undeclared (first use in this function)
     221 |         pte = set_pte_bit(pte, __pgprot(PROT_NORMAL));
         |                                         ^~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_buffer_allocate':
>> drivers/dma-buf/heaps/tegra-vpr.c:612:30: warning: variable 'last' set but not used [-Wunused-but-set-variable]
     612 |         unsigned long first, last;
         |                              ^~~~
>> drivers/dma-buf/heaps/tegra-vpr.c:612:23: warning: variable 'first' set but not used [-Wunused-but-set-variable]
     612 |         unsigned long first, last;
         |                       ^~~~~
   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_buffer_release':
   drivers/dma-buf/heaps/tegra-vpr.c:695:30: warning: variable 'last' set but not used [-Wunused-but-set-variable]
     695 |         unsigned long first, last;
         |                              ^~~~
   drivers/dma-buf/heaps/tegra-vpr.c:695:23: warning: variable 'first' set but not used [-Wunused-but-set-variable]
     695 |         unsigned long first, last;
         |                       ^~~~~
   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_setup_chunks':
>> drivers/dma-buf/heaps/tegra-vpr.c:8:21: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
       8 | #define pr_fmt(fmt) "tegra-vpr: " fmt
         |                     ^~~~~~~~~~~~~
   include/linux/dynamic_debug.h:231:29: note: in expansion of macro 'pr_fmt'
     231 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:259:9: note: in expansion of macro '__dynamic_func_call_cls'
     259 |         __dynamic_func_call_cls(__UNIQUE_ID(ddebug), cls, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:261:9: note: in expansion of macro '_dynamic_func_call_cls'
     261 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:280:9: note: in expansion of macro '_dynamic_func_call'
     280 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/printk.h:636:9: note: in expansion of macro 'dynamic_pr_debug'
     636 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~
   drivers/dma-buf/heaps/tegra-vpr.c:1075:17: note: in expansion of macro 'pr_debug'
    1075 |                 pr_debug("  %2u: %pap-%pap (%lu MiB)\n", i, &start, &end,
         |                 ^~~~~~~~
   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_add_heap':
   drivers/dma-buf/heaps/tegra-vpr.c:1120:30: warning: variable 'last' set but not used [-Wunused-but-set-variable]
    1120 |         unsigned long first, last;
         |                              ^~~~
   drivers/dma-buf/heaps/tegra-vpr.c:1120:23: warning: variable 'first' set but not used [-Wunused-but-set-variable]
    1120 |         unsigned long first, last;
         |                       ^~~~~


vim +/last +612 drivers/dma-buf/heaps/tegra-vpr.c

   605	
   606	static struct tegra_vpr_buffer *
   607	tegra_vpr_buffer_allocate(struct tegra_vpr *vpr, size_t size)
   608	{
   609		unsigned int num_pages = size >> PAGE_SHIFT;
   610		unsigned int order = get_order(size);
   611		struct tegra_vpr_buffer *buffer;
 > 612		unsigned long first, last;
   613		int pageno, err;
   614		pgoff_t i;
   615	
   616		/*
   617		 * "order" defines the alignment and size, so this may result in
   618		 * fragmented memory depending on the allocation patterns. However,
   619		 * since this is used primarily for video frames, it is expected that
   620		 * a number of buffers of the same size will be allocated, so
   621		 * fragmentation should be negligible.
   622		 */
   623		pageno = tegra_vpr_allocate_region(vpr, num_pages, 1);
   624		if (pageno < 0)
   625			return ERR_PTR(pageno);
   626	
   627		first = find_first_bit(vpr->bitmap, vpr->num_pages);
   628		last = find_last_bit(vpr->bitmap, vpr->num_pages);
   629	
   630		buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
   631		if (!buffer) {
   632			err = -ENOMEM;
   633			goto release;
   634		}
   635	
   636		INIT_LIST_HEAD(&buffer->attachments);
   637		INIT_LIST_HEAD(&buffer->list);
   638		mutex_init(&buffer->lock);
   639		buffer->start = vpr->base + (pageno << PAGE_SHIFT);
   640		buffer->limit = buffer->start + size;
   641		buffer->size = size;
   642		buffer->num_pages = num_pages;
   643		buffer->pageno = pageno;
   644		buffer->order = order;
   645	
   646		buffer->pages = kmalloc_array(buffer->num_pages,
   647					      sizeof(*buffer->pages),
   648					      GFP_KERNEL);
   649		if (!buffer->pages) {
   650			err = -ENOMEM;
   651			goto free;
   652		}
   653	
   654		/* track which chunks this buffer overlaps */
   655		if (vpr->num_chunks > 0) {
   656			unsigned int limit = buffer->pageno + buffer->num_pages, i;
   657	
   658			for (i = 0; i < vpr->num_chunks; i++) {
   659				struct tegra_vpr_chunk *chunk = &vpr->chunks[i];
   660	
   661				if (tegra_vpr_chunk_overlaps(chunk, pageno, limit))
   662					set_bit(i, buffer->chunks);
   663			}
   664	
   665			/* activate chunks if necessary */
   666			err = tegra_vpr_activate_chunks(vpr, buffer);
   667			if (err < 0)
   668				goto free;
   669	
   670			/* track first and last allocated pages */
   671			if (buffer->pageno < vpr->first)
   672				vpr->first = buffer->pageno;
   673	
   674			if (limit - 1 > vpr->last)
   675				vpr->last = limit - 1;
   676		}
   677	
   678		for (i = 0; i < buffer->num_pages; i++)
   679			buffer->pages[i] = &vpr->start_page[pageno + i];
   680	
   681		return buffer;
   682	
   683	free:
   684		kfree(buffer->pages);
   685		kfree(buffer);
   686	release:
   687		bitmap_release_region(vpr->bitmap, pageno, order);
   688		return ERR_PTR(err);
   689	}
   690	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

