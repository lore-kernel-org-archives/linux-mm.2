Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAA9CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 21:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664A78E0005; Mon, 17 Nov 2025 16:57:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6154F8E0002; Mon, 17 Nov 2025 16:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5523E8E0005; Mon, 17 Nov 2025 16:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43D108E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:57:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD4BA12CFB8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:57:03 +0000 (UTC)
X-FDA: 84121459926.04.D7C63AF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id 07CDB160008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:57:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mscGibJW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763416621; a=rsa-sha256;
	cv=none;
	b=WJqAtdQvH1yPCk2039lkIop5WjFp8F6hYdsoi0O4CJfkcpbJ+VsuBYRNRnQaCaRNaaJevy
	pPduUkfmuAvefO1Eqofn6RlfECYJSRps8/qoqUwPhN5zz0Jfk6rozSnSH2ShwKGYShzl5w
	ngLqchITiN7yJp7LIvyLTK5PqvJK4Cs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mscGibJW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763416621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLsvFfoFkbXiP6oB6KhvNEaQkLt6tZiXJgW8gogrKLI=;
	b=zkzRODT4v/mPiFa5NYKVb4rBitdxv6SSf42f16+fKVmim59LiziqbfOhVV8UvTADxNKV6q
	cXk6xyFUn0CYPZS2Adm2b9jqhFtiWjqd+MjK/cawQLzq9Lv4vQA636OOGKxYT1N9a7Skhc
	qeW2ZWczZo8pEBKi1QPS7IpXjR+VT10=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763416621; x=1794952621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gZdQ90uRnhftwMuOkOtLdGvhk8V2MVWMreJIfq9LKXw=;
  b=mscGibJW517cNZh9xONzEymqXE12ddSB7xrOVhN8r4KqQAzh7r4qW4NN
   h9V5IACYKxZwDnSTk5+UvP/O9ODUUkf3sHkZZ11HKqAPrWZOdCNPET3A6
   CKTGT1WxPJdyPai0BbCmieFFGDQ5iNBS/EH1WeF3FD/bTa+clF16ynJzM
   B+ay9o3ZFhAPUZ1Yb+IDHKMv9LHJwO/pGD/WyfpURW2CGbmyXvdhN4yFT
   gVJVukqybdef1Qq/0UGII7oaA89usyrexKL4ZUD7IR9L6M0t3Ulw6k71p
   B7gT08UPeJHBPbiAjbs+WDqg8uKAQM2r6jlRs7gN659Okw7P2hBMR7ODp
   A==;
X-CSE-ConnectionGUID: bVR348MWT/ip7Q7GS/jfOw==
X-CSE-MsgGUID: 2u6fFZ1QQoGeIPk+BElvGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65520965"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="65520965"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 13:56:59 -0800
X-CSE-ConnectionGUID: 8a+ZIWu4Sd+EFLgDUG4S/w==
X-CSE-MsgGUID: fA7tsMzESkeByHSIqb02ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="190364405"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 17 Nov 2025 13:56:56 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vL7DR-00015n-0p;
	Mon, 17 Nov 2025 21:56:53 +0000
Date: Tue, 18 Nov 2025 05:56:52 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Rizzo <lrizzo@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v2 2/8] genirq: soft_moderation: add base files, procfs
Message-ID: <202511180547.snSezdSu-lkp@intel.com>
References: <20251116182839.939139-3-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251116182839.939139-3-lrizzo@google.com>
X-Rspamd-Queue-Id: 07CDB160008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8gbxjgtatgcxysapqzek4nh3rbyp4e6x
X-Rspam-User: 
X-HE-Tag: 1763416620-535425
X-HE-Meta: U2FsdGVkX1+8vXAuHsmxwqECYttMJXn/RLcQpmeaBLCESWFACcchZ4LIaKdQfIv0RzXhzyO88BaPz7jyoOB4cnEqKG6JSCcj+XAaTuBk4GJAUx9QAEjdZjE05sUqG79KZfUwh3ELBOEOPF/+uAAvwcghDxdwYIhfkHfHF8BAFoImyFF0zQz1EZofrRjOWOEsv4r2uekOQxnY57Q1OLX7LUE7ygAVwjmJFFQpNgAUzUqfVghUtiwgBU0A+3kb12tEMf86NpUnonhbK/LLk7LYgEtmjs2tjaQtVMZQTJlJTj+4RjMqgctMfEHpjnk0BZhwDtt8W+05voVw0AIIS8xitwnN6F09PTX4YaWD+apAubM2BW7cp7/2rHUsp6/ukfV7M0dSRYXWQDAw6xMmlKvFnF56ofUQjxv1pUTNkvSGuAJOPXSmWLN2yD4Lx4/hmxp/UuRcAvnH587TkRMzTRvT+0TpWZDRMruEZET1kB6k5/QuV0FZX+HKsWl1S+a7Ntp5jvA1eKYsyCzn+p7ToTemjopTxMcXnJD4KljDAR+m18Bf8JpItfQmXkXzuDZG+MIjg66PCJ1OqAZo1K2RyUEJk0kANKV6QdKbQMom3b3Nm6fxGakwthOyqlorCcjeaac6d+rG6iD6mATTMtZ2/ZXB0xMMx2A9NFzChPHpxiqs34FBkcmac5qJObobKTxTZLSZmBFMWQ4j6roQYQ9lyuX9rAG5MFH8aW0y23kMjRA2aK3IF2tC0W3wgUtagkmPPEdME9V7e0d/r2NxdYPxZDXElvB6ptpLJiwN5gnyAoas6bBqv45cE3pHKpcvx5G8voa7+k0xwEZlhGcOgANUalNdFhTgHFQwTgp+H5aA6dFL7dsaDmjR14BjLPVWACofHu3r6zOl9Kdw+rroMt6DQJntFdkOsx6H7S04zsNmLLWG0ZAROLrdgR3ugRkmLl+e6OiO6jk8xOb4TV+awHhlNms
 9TodYfS1
 IDNV49tJZpW3Up25CdHFs8LtlNY18mcZNeklYPxz1z1w87umzVexRMXNNHeWn7ARtHTFk6ZgfK2IEQbpeOsLKwfbsHW8vReUiMa1ZrI9KZYzo0jYG5/aVr63SDjpOpVIr+1yaSNrYM5QSkXoMgFoHBfnOEeJlGZpD/wHlszDnt+qGBvs4Ozk03yLDpMnjuOShzJ6Mw+oY79HTnan9EXsmslsWpRdaDWRjvoWQyfOn/+UJIDeHD48fvA+oOHvLY3fvuQ2SgxYhQsRHwP7UZYeADEvdQZ4Iyx9EDtqobV4UUuWIqx8qaT5/o2Bmw/xZ8lIen8beJtq+0kVQmvsoevpBqCj+s+9b40TjzyRf54RIZIOeeeVqU/F3PGm/RU1LoeTRQsetGz4LVt/MXTHQZ424lRcer447tpa/EOYhdMlnPNfsugKE6Nbloa3K/m1xIvnSE2mJVxfjyIiyEXnYzcAULwS3+JCwUZ03nsJDICFv7Or//lHXCZjDHColWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luigi,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/irq/core]
[also build test ERROR on tip/x86/core tip/master linus/master v6.18-rc6 next-20251117]
[cannot apply to tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Rizzo/genirq-platform-wide-interrupt-moderation-Documentation-Kconfig-irq_desc/20251117-023148
base:   tip/irq/core
patch link:    https://lore.kernel.org/r/20251116182839.939139-3-lrizzo%40google.com
patch subject: [PATCH v2 2/8] genirq: soft_moderation: add base files, procfs
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20251118/202511180547.snSezdSu-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251118/202511180547.snSezdSu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511180547.snSezdSu-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/irq/irq_moderation.c:103: warning: ignoring '#pragma clang diagnostic' [-Wunknown-pragmas]
     103 | #pragma clang diagnostic error "-Wformat"
   In file included from include/linux/uaccess.h:10,
                    from include/linux/sched/task.h:13,
                    from include/linux/sched/signal.h:9,
                    from include/linux/rcuwait.h:6,
                    from include/linux/percpu-rwsem.h:7,
                    from include/linux/fs.h:34,
                    from include/linux/seq_file.h:11,
                    from kernel/irq/irq_moderation.c:8:
   In function 'check_copy_size',
       inlined from 'copy_from_user' at include/linux/uaccess.h:207:7,
       inlined from 'moderation_write' at kernel/irq/irq_moderation.c:169:6:
>> include/linux/ucopysize.h:54:25: error: call to '__bad_copy_to' declared with attribute error: copy destination size is too small
      54 |                         __bad_copy_to();
         |                         ^~~~~~~~~~~~~~~
   In function 'check_copy_size',
       inlined from 'copy_from_user' at include/linux/uaccess.h:207:7,
       inlined from 'mode_write' at kernel/irq/irq_moderation.c:223:6:
>> include/linux/ucopysize.h:54:25: error: call to '__bad_copy_to' declared with attribute error: copy destination size is too small
      54 |                         __bad_copy_to();
         |                         ^~~~~~~~~~~~~~~


vim +/__bad_copy_to +54 include/linux/ucopysize.h

808aac63e2bdf9 Kees Cook 2025-02-28  43  
808aac63e2bdf9 Kees Cook 2025-02-28  44  static __always_inline __must_check bool
808aac63e2bdf9 Kees Cook 2025-02-28  45  check_copy_size(const void *addr, size_t bytes, bool is_source)
808aac63e2bdf9 Kees Cook 2025-02-28  46  {
808aac63e2bdf9 Kees Cook 2025-02-28  47  	int sz = __builtin_object_size(addr, 0);
808aac63e2bdf9 Kees Cook 2025-02-28  48  	if (unlikely(sz >= 0 && sz < bytes)) {
808aac63e2bdf9 Kees Cook 2025-02-28  49  		if (!__builtin_constant_p(bytes))
808aac63e2bdf9 Kees Cook 2025-02-28  50  			copy_overflow(sz, bytes);
808aac63e2bdf9 Kees Cook 2025-02-28  51  		else if (is_source)
808aac63e2bdf9 Kees Cook 2025-02-28  52  			__bad_copy_from();
808aac63e2bdf9 Kees Cook 2025-02-28  53  		else
808aac63e2bdf9 Kees Cook 2025-02-28 @54  			__bad_copy_to();
808aac63e2bdf9 Kees Cook 2025-02-28  55  		return false;
808aac63e2bdf9 Kees Cook 2025-02-28  56  	}
808aac63e2bdf9 Kees Cook 2025-02-28  57  	if (WARN_ON_ONCE(bytes > INT_MAX))
808aac63e2bdf9 Kees Cook 2025-02-28  58  		return false;
808aac63e2bdf9 Kees Cook 2025-02-28  59  	check_object_size(addr, bytes, is_source);
808aac63e2bdf9 Kees Cook 2025-02-28  60  	return true;
808aac63e2bdf9 Kees Cook 2025-02-28  61  }
808aac63e2bdf9 Kees Cook 2025-02-28  62  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

