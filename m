Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7990CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 06:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC548E0026; Wed, 20 Aug 2025 02:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4058E0011; Wed, 20 Aug 2025 02:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA2C8E0026; Wed, 20 Aug 2025 02:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAA88E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:45:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A26A5160398
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:45:40 +0000 (UTC)
X-FDA: 83796200040.29.80FA4BA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id E3E1440003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:45:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UQusCr5X;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755672338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdkxXjlv65lpFHAFG1mydo3rEC/6GC2gUDCT1Hlfmos=;
	b=MxrARJSWxL/qDNOuRC6bbTcZmE0IauABbFmzPBIE0iwKS9n9rvt36eJHZWN6XCgDyx5w9a
	OAu+F1kA8zLZbFqIp3/xT75h5i5v8AF4zHBIMWc1eN7j99GzdxMSSb77kiUptFkZULYqjD
	4sRzWnwWC0GssdnFBN0d04sXaL6/osc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UQusCr5X;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755672338; a=rsa-sha256;
	cv=none;
	b=ifntChGk3GV2HGkIQzLdufz9k2phJ27s+YKYfa8lS2lx4t6NQN9w7inITIX6E6DfVprGTm
	pi2xoF/AXl85Sun7F8teddfNW5jzgW4oC6sibWQxqbWlMxo1snmthopLaypIaRZxv+wFct
	9dkiR/ElGgzNJu+YSb0HJCSay8RJDQQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755672338; x=1787208338;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Aks18XLnFJDywmToiC/hQRBj84tcW/vcMhMm0McgHP4=;
  b=UQusCr5X/cZ+aOyeXs87B3bRlV4tqKD6+YQXDRXC51GddjyjVLyCr72e
   K1276mDrlW9pCczOzKpu+SWcsr5mwfGGLP7rzKmGK8P+CCoPaTUtrkDaV
   2wDGxgdNMW8oxStUenXJySucx0zGtqa44xhmxIe5u0+u1xJpwY1mXExMV
   iRn8/HsiGy4QYAQ62WeBhOvK2HbUF5Knyl9BPiVR8md1W2lenyTfKlF9q
   EhMZfcxAITZPOPf6JYU6v/sMWqw1CkcA/RHO2AoVGcUi2z4gOfFyaOQ2W
   LUHzCQZWyMf+WOKE1N0Ic6OzPiT/zZP1fZpXTw5Y3E+jJTtpwklBtgo8C
   A==;
X-CSE-ConnectionGUID: rzvAwDYVSlaUcqqsJysaXQ==
X-CSE-MsgGUID: X3BzJWbPRd6ohNH/O0AHLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="61745336"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="61745336"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 23:45:36 -0700
X-CSE-ConnectionGUID: oZu6t+lTTiuD65z9o2thYw==
X-CSE-MsgGUID: BZwrqRZbQTWCzxT/CDtEsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168851444"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 19 Aug 2025 23:45:32 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uocZd-000IJH-2r;
	Wed, 20 Aug 2025 06:45:29 +0000
Date: Wed, 20 Aug 2025 14:44:54 +0800
From: kernel test robot <lkp@intel.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: Re: [PATCH 2/2] riscv: introduce percpu.h into include/asm
Message-ID: <202508201452.ciEgfhNO-lkp@intel.com>
References: <20250819135007.85646-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819135007.85646-3-cuiyunhui@bytedance.com>
X-Stat-Signature: x9ye75us41w7kwt5g9jnngy9nzs6ah4f
X-Rspam-User: 
X-Rspamd-Queue-Id: E3E1440003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755672337-612057
X-HE-Meta: U2FsdGVkX188+iwZHVGXhO20bSEyD8QT9GqtYttEkr5VwYUMrruJ12lyH84hu2CRRezaYzfhT1GXYAqnvBaiUS2a22WLRVeyFQaWLCowrY3k+fjaUIXpA95Fn8lVDPyr+jWIPtq7iUqKUhRaufbI+BSktYqBT8KVOe6dvSi59rD6BLgmTBusloASaq4HjuSRgM574cO8SZy07gY3fQNbvJTryt5Aysz+l7NJtXvVn1MYweXAaDoEiNHO7v3KJfSaACUd02x4TuOjeGWt0EeW9Kaq2Th/N8yJh1V9s1QWC1nLrb/cnkf2YTdVITqpta+tyCQyEW9ikRf2BSctzYcuEJ3cjOQAwda7awXIR8XXuwqHRx5ONPQ8qb/4x1k08v5mKi4Oz0NHQgHGBNtyU1i6m65f3ej4VXDg89Wr8t2DOEyMQ8ADqh+rc9aNBu2VMQDaIaoXsycWVnqebcJRR3Kg290GQAdwhseUhdI7NpGLzt6pLAJhlo3lEMg05VGjl4lQIHsZBYbg0du0aKMG3eA4q9zaJc2kdVnpaikTnB5cB9aBa6F5wLbyGNznkQoS33gfY3D/Dg/yqzkg0YTsL2Xbm+CxY0ptyVVZ72C3UnzaRVozY08IedD8sUfOPNuvNPqczK+m/dzgUSy/uF5frXzPHTf7wH/2T8ALw0p4pEfv0DbnVVjKhKB/38wIbPG/jciDlJrC3Z/c0JVYS463zrERBdcQvxDDAxsKf7i4djdZ9dm7cpPC0veFZIHiRkabcbwLn20Gj1C6MUHqE2hNIvekH7B6/6vK9O+c96HXU0DnR44O87fo9qd1wABVlwHZ/qE93211wnzXG6koxvwiZiQWRtVRSUP+FabSvA6FfXrxLYTQDBYj72H0GNUw9WqGCN/kDHgBVX4buIjbPOkiLnvJlBTVNzvo118D7TSMZejcKzHPdeeT4It/k1rm8eEF72Tzw5E9DiGuudKztKil4WP
 0qEI60dx
 Gz1+BgY2psZeZq+torPoP+tRNsbAVzTbH8tpbv+96u10KqYWYppq6/g2T+uqQq/c0eV0KN+eVxT/icbnm4liAcABriECMqJezVDN4f8CFgJyzFIfpKmzCsfPrzSNWtNJvBo6nmmtkma7fTX0ueWeGieFqDHTup0tuSLhiA7jpE56zl2eIZGJjfFpZUNcbB1sBdjgum76krnrKbBtIAucM3zScN+l41JbGTyPubxnOFa+FYhmNUQKeH4e0CcFfOo8ut8+Cs6e3xZShqvqgw/a663s/tr8r1/k09RSYxsoJCRwu6Nmegpi0zmiIuKNj/4xS8Dbq6ZLNwthfIZNI1X/IoU4YMPCNO098Sg6OdEDlqQBdr2isPaIu0HbQoXM0f29DJHoI1xrtvC4XGTe1FcVLJe0CkUr2XxR7uXBItZEFmpjqos1Z2QU1P34UBXDxGDGYQeTKs6ZCw5hB4pVGHA/rEBm0zZDwMSw0tdnINUu37e+z2bA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yunhui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on dennis-percpu/for-next v6.17-rc2 next-20250819]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunhui-Cui/riscv-remove-irqflags-h-inclusion-in-asm-bitops-h/20250819-215256
base:   linus/master
patch link:    https://lore.kernel.org/r/20250819135007.85646-3-cuiyunhui%40bytedance.com
patch subject: [PATCH 2/2] riscv: introduce percpu.h into include/asm
config: riscv-randconfig-002-20250820 (https://download.01.org/0day-ci/archive/20250820/202508201452.ciEgfhNO-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 93d24b6b7b148c47a2fa228a4ef31524fa1d9f3f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250820/202508201452.ciEgfhNO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508201452.ciEgfhNO-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:7:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:19:
   In file included from include/linux/workqueue.h:9:
>> include/linux/alloc_tag.h:219:2: warning: implicit conversion from 'typeof (tag->counters->calls)' (aka 'unsigned long long') to 'unsigned long' changes value from 18446744073709551615 to 4294967295 [-Wconstant-conversion]
     219 |         this_cpu_dec(tag->counters->calls);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:512:28: note: expanded from macro 'this_cpu_dec'
     512 | #define this_cpu_dec(pcp)               this_cpu_sub(pcp, 1)
         |                                         ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:510:51: note: expanded from macro 'this_cpu_sub'
     510 | #define this_cpu_sub(pcp, val)          this_cpu_add(pcp, -(typeof(pcp))(val))
         |                                         ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:501:70: note: expanded from macro 'this_cpu_add'
     501 | #define this_cpu_add(pcp, val)          __pcpu_size_call(this_cpu_add_, pcp, val)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/percpu-defs.h:372:29: note: expanded from macro '__pcpu_size_call'
     372 |                 case 8: stem##8(variable, __VA_ARGS__);break;           \
         |                         ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
   arch/riscv/include/asm/percpu.h:96:78: note: expanded from macro 'this_cpu_add_8'
      96 | #define this_cpu_add_8(pcp, val)        _pcp_protect(__percpu_add_amo_case_64, pcp, val)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   arch/riscv/include/asm/percpu.h:72:26: note: expanded from macro '_pcp_protect'
      72 |         op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);                           \
         |         ~~                      ^~~~~~~~~~~
   1 warning generated.
--
   In file included from arch/riscv/errata/sifive/errata.c:7:
   In file included from include/linux/memory.h:19:
   In file included from include/linux/node.h:18:
   In file included from include/linux/device.h:16:
   In file included from include/linux/energy_model.h:7:
   In file included from include/linux/kobject.h:20:
   In file included from include/linux/sysfs.h:16:
   In file included from include/linux/kernfs.h:12:
   In file included from include/linux/idr.h:15:
   In file included from include/linux/radix-tree.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:219:2: warning: implicit conversion from 'typeof (tag->counters->calls)' (aka 'unsigned long long') to 'unsigned long' changes value from 18446744073709551615 to 4294967295 [-Wconstant-conversion]
     219 |         this_cpu_dec(tag->counters->calls);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:512:28: note: expanded from macro 'this_cpu_dec'
     512 | #define this_cpu_dec(pcp)               this_cpu_sub(pcp, 1)
         |                                         ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:510:51: note: expanded from macro 'this_cpu_sub'
     510 | #define this_cpu_sub(pcp, val)          this_cpu_add(pcp, -(typeof(pcp))(val))
         |                                         ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:501:70: note: expanded from macro 'this_cpu_add'
     501 | #define this_cpu_add(pcp, val)          __pcpu_size_call(this_cpu_add_, pcp, val)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/percpu-defs.h:372:29: note: expanded from macro '__pcpu_size_call'
     372 |                 case 8: stem##8(variable, __VA_ARGS__);break;           \
         |                         ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
   arch/riscv/include/asm/percpu.h:96:78: note: expanded from macro 'this_cpu_add_8'
      96 | #define this_cpu_add_8(pcp, val)        _pcp_protect(__percpu_add_amo_case_64, pcp, val)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   arch/riscv/include/asm/percpu.h:72:26: note: expanded from macro '_pcp_protect'
      72 |         op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);                           \
         |         ~~                      ^~~~~~~~~~~
   arch/riscv/errata/sifive/errata.c:29:14: warning: result of comparison of constant 9223372036854775815 with expression of type 'unsigned long' is always true [-Wtautological-constant-out-of-range-compare]
      29 |         if (arch_id != 0x8000000000000007 ||
         |             ~~~~~~~ ^  ~~~~~~~~~~~~~~~~~~
   arch/riscv/errata/sifive/errata.c:42:14: warning: result of comparison of constant 9223372036854775815 with expression of type 'unsigned long' is always true [-Wtautological-constant-out-of-range-compare]
      42 |         if (arch_id != 0x8000000000000007 && arch_id != 0x1)
         |             ~~~~~~~ ^  ~~~~~~~~~~~~~~~~~~
   3 warnings generated.
--
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:7:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:19:
   In file included from include/linux/workqueue.h:9:
>> include/linux/alloc_tag.h:219:2: warning: implicit conversion from 'typeof (tag->counters->calls)' (aka 'unsigned long long') to 'unsigned long' changes value from 18446744073709551615 to 4294967295 [-Wconstant-conversion]
     219 |         this_cpu_dec(tag->counters->calls);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:512:28: note: expanded from macro 'this_cpu_dec'
     512 | #define this_cpu_dec(pcp)               this_cpu_sub(pcp, 1)
         |                                         ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:510:51: note: expanded from macro 'this_cpu_sub'
     510 | #define this_cpu_sub(pcp, val)          this_cpu_add(pcp, -(typeof(pcp))(val))
         |                                         ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:501:70: note: expanded from macro 'this_cpu_add'
     501 | #define this_cpu_add(pcp, val)          __pcpu_size_call(this_cpu_add_, pcp, val)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/percpu-defs.h:372:29: note: expanded from macro '__pcpu_size_call'
     372 |                 case 8: stem##8(variable, __VA_ARGS__);break;           \
         |                         ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
   arch/riscv/include/asm/percpu.h:96:78: note: expanded from macro 'this_cpu_add_8'
      96 | #define this_cpu_add_8(pcp, val)        _pcp_protect(__percpu_add_amo_case_64, pcp, val)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   arch/riscv/include/asm/percpu.h:72:26: note: expanded from macro '_pcp_protect'
      72 |         op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);                           \
         |         ~~                      ^~~~~~~~~~~
   1 warning generated.


vim +219 include/linux/alloc_tag.h

22d407b164ff79 Suren Baghdasaryan 2024-03-21  202  
22d407b164ff79 Suren Baghdasaryan 2024-03-21  203  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
22d407b164ff79 Suren Baghdasaryan 2024-03-21  204  {
22d407b164ff79 Suren Baghdasaryan 2024-03-21  205  	struct alloc_tag *tag;
22d407b164ff79 Suren Baghdasaryan 2024-03-21  206  
22d407b164ff79 Suren Baghdasaryan 2024-03-21  207  	alloc_tag_sub_check(ref);
22d407b164ff79 Suren Baghdasaryan 2024-03-21  208  	if (!ref || !ref->ct)
22d407b164ff79 Suren Baghdasaryan 2024-03-21  209  		return;
22d407b164ff79 Suren Baghdasaryan 2024-03-21  210  
239d6c96d86f8a Suren Baghdasaryan 2024-03-21  211  	if (is_codetag_empty(ref)) {
239d6c96d86f8a Suren Baghdasaryan 2024-03-21  212  		ref->ct = NULL;
239d6c96d86f8a Suren Baghdasaryan 2024-03-21  213  		return;
239d6c96d86f8a Suren Baghdasaryan 2024-03-21  214  	}
239d6c96d86f8a Suren Baghdasaryan 2024-03-21  215  
22d407b164ff79 Suren Baghdasaryan 2024-03-21  216  	tag = ct_to_alloc_tag(ref->ct);
22d407b164ff79 Suren Baghdasaryan 2024-03-21  217  
22d407b164ff79 Suren Baghdasaryan 2024-03-21  218  	this_cpu_sub(tag->counters->bytes, bytes);
22d407b164ff79 Suren Baghdasaryan 2024-03-21 @219  	this_cpu_dec(tag->counters->calls);
22d407b164ff79 Suren Baghdasaryan 2024-03-21  220  
22d407b164ff79 Suren Baghdasaryan 2024-03-21  221  	ref->ct = NULL;
22d407b164ff79 Suren Baghdasaryan 2024-03-21  222  }
22d407b164ff79 Suren Baghdasaryan 2024-03-21  223  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

