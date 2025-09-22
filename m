Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2993CCA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2048E0010; Mon, 22 Sep 2025 17:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671D48E0001; Mon, 22 Sep 2025 17:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE7A8E0010; Mon, 22 Sep 2025 17:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47A4A8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:29:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBE471A0253
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:29:18 +0000 (UTC)
X-FDA: 83918177196.06.EF9936B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 745C2A0006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:29:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZWqd3e1c;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758576557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s4YVHEevhU5usN+Lp213UcR591msZTm8EaYqPL9udNs=;
	b=aPoLAa3ewGGOfguzArqKbacq4JzJOEetEifmkhjSenLJ1mmeZ/DYnmJ/abTJXYfjlIOL8X
	7H55Vml4v8OSDObDoVvqgHy6GT86zQKBkQU/VL3+JS7EaCQOp+XHs+xUio7fJlImS+juMU
	JLAQEmkYO9YziqXGvoB8+kas2ebW3VU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758576557; a=rsa-sha256;
	cv=none;
	b=R6pr7fauwCW00nDCNDyqnTbX9Y2iOuX8ceeY1uRkuvHwiCvsSBBCM1eQ5O8PORcH7ZDgaa
	TddIXP/wkjNhQc/WnGJDBfW2N5v06nGOhk8ImaH2dGzwRUa5FJHUBGqMdWlFM5KhaDuanF
	IHLEN+U5BEt+aZREiBtmgTWy26n444M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZWqd3e1c;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758576556; x=1790112556;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=iyd13/Fud5LSon0kal2rF7LlOuf0qFyvWUpHWjYkR0s=;
  b=ZWqd3e1czX26ttru2l1R0Yc0fBwv3JMIIs5qKd5zEZcz067QA6LkY13x
   URRKBP2bBpvV8IcfVo81Gvv0Fnau/ioIw3/JeYE5r8+ahHPSwqrmLWRmf
   yegop8rKQZKOPVx606xskXgoxcbjN0isHQx4PiPTHqceDShwdbfuF8DNK
   oy10vYd1/E3Byh6/uSdAdCAlE0PTxbQNxUH0irLes88dhPMi6Z2DenFyo
   aYcCCQph/qW6qIDz/8A3yUF917ZS4q6CTvbElOgCNRKVHR68/K6axyxCu
   o+jNCaiIl54DrBEZM81MQM8qqGGdDFfkiHp2y+c0ZhYWmkM+v8LntVBno
   w==;
X-CSE-ConnectionGUID: fEJQf8XiSU2ISEf6EnFKHA==
X-CSE-MsgGUID: BmmWI835RI6yHd931Uik4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71524011"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="71524011"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 14:29:15 -0700
X-CSE-ConnectionGUID: /K0XKW2zTJ2hyap/hLEESw==
X-CSE-MsgGUID: TJwjT1FhSCGSvetm5HCcDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="176188631"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 22 Sep 2025 14:29:13 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v0o5u-0002Uf-1E;
	Mon, 22 Sep 2025 21:29:10 +0000
Date: Tue, 23 Sep 2025 05:28:57 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [linux-next:master 11234/11516] include/linux/pfn.h:12:43: error:
 passing argument 1 of 'kho_restore_page' makes pointer from integer without
 a cast
Message-ID: <202509230547.orS14pYx-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 745C2A0006
X-Stat-Signature: wngykbg6cqtmdhisqxb84ixra1cbg9cq
X-Rspam-User: 
X-HE-Tag: 1758576556-614845
X-HE-Meta: U2FsdGVkX1961c38axbv9jzC2F8tVIr5CgQOepm5cBw0dmQBwpTsbMWMT/z3IURAYJ696gNnt3yPk4JH2or9VhIhLozErPj/abWEO0jMDl8NToBn1TliUXaaKOUcj9vSVK+2UCnExHmYpZsLRmYAv5Oi4Jr3bLccg5K3/eaVZb9q9ODo3TtVtmGyY2aPJtItRelziA5c+fAeKQtOqkJnX48TN+c19pvyqWYISrZ8QkYlQsEuFl6lec/5Lg4Gihi9G1gfMogLLBt9iN8YSS0j5GLCi0KfbXdnJtgHZzOV3+WHjRdN6v6p75fZebAP4LjciVyVF1SloFeZ9YxH5OsTOz+zdyORKQhc+c6Q3FyjBt9qg8iFJ/9AXg6cur2PtoNejSReUsZqliDEGz6GhlZTwW7wiuuYpMSN4bej1SCfuJ7103gnUXc6ysBzClyEVeYT6cgkN52bY3b6PjyMYNl2PUd5uHnj7p+Ih7tuyqXSoUutA6VCzWEx+UgLISG2xP3qgsg/T0LYY4zibAisqqhYi60gZ7lbomrlz6ZNcytNs91maUjOAS7rUd5OrKjcotvFDgFwhlc34jJMA4Xncz9MgX8eZja4chVxdnzcB2R2+QO+MlwfJLCqXzbuw660jtB8auGGgs6oIcyA/9NTYUoOMLF7XmlBFc5gAKitQpIo9hCNcJjlD9B+znj83z77pFAGz3Ryx+dSdslPrq9i9oLaG1N60bPCEikOqs1nDd5wPkaGnb3sBD1wbVy2Qalgn4XJBck3RHn60V+U2BYZSpq/0WYmIwP9PGFTCXjuMu5BGJvRXbLeQiyxepeEpocR48ZPyc7rp5Q+O10UTEdSRW8zSf45Xhx+B74Z7lG5ShhX8oOi6Vh1tJZOdGjM65vTno6uD+puAGUKa0p63bAtez4UasSAA5lMRnJxzFTB4bMEcpmA8qdMox6YuGhRSQ06OGf0gPXAF4MJHdU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   bf2602a3cb2381fb1a04bf1c39a290518d2538d1
commit: faccf4f8536bbd064a1d25fde98da1c5a25474a2 [11234/11516] kho: add support for preserving vmalloc allocations
config: x86_64-randconfig-004-20250922 (https://download.01.org/0day-ci/archive/20250923/202509230547.orS14pYx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250923/202509230547.orS14pYx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509230547.orS14pYx-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/memory_model.h:5,
                    from arch/x86/include/asm/page.h:89,
                    from arch/x86/include/asm/thread_info.h:12,
                    from include/linux/thread_info.h:60,
                    from include/linux/spinlock.h:60,
                    from include/linux/wait.h:9,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:7,
                    from include/linux/debugfs.h:15,
                    from kernel/kexec_handover.c:13:
   kernel/kexec_handover.c: In function 'kho_restore_pages':
>> include/linux/pfn.h:12:43: error: passing argument 1 of 'kho_restore_page' makes pointer from integer without a cast [-Wint-conversion]
      12 | #define PFN_PHYS(x)     ((phys_addr_t)(x) << PAGE_SHIFT)
         |                         ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
         |                                           |
         |                                           long long unsigned int
   kernel/kexec_handover.c:273:54: note: in expansion of macro 'PFN_PHYS'
     273 |                 struct page *page = kho_restore_page(PFN_PHYS(pfn));
         |                                                      ^~~~~~~~
   kernel/kexec_handover.c:214:43: note: expected 'struct page *' but argument is of type 'long long unsigned int'
     214 | static void kho_restore_page(struct page *page, unsigned int order)
         |                              ~~~~~~~~~~~~~^~~~
   kernel/kexec_handover.c:273:37: error: too few arguments to function 'kho_restore_page'
     273 |                 struct page *page = kho_restore_page(PFN_PHYS(pfn));
         |                                     ^~~~~~~~~~~~~~~~
   kernel/kexec_handover.c:214:13: note: declared here
     214 | static void kho_restore_page(struct page *page, unsigned int order)
         |             ^~~~~~~~~~~~~~~~


vim +/kho_restore_page +12 include/linux/pfn.h

947d0496cf3e12 Jeremy Fitzhardinge 2008-09-11   8  
22a9835c350782 Dave Hansen         2006-03-27   9  #define PFN_ALIGN(x)	(((unsigned long)(x) + (PAGE_SIZE - 1)) & PAGE_MASK)
22a9835c350782 Dave Hansen         2006-03-27  10  #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
22a9835c350782 Dave Hansen         2006-03-27  11  #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
947d0496cf3e12 Jeremy Fitzhardinge 2008-09-11 @12  #define PFN_PHYS(x)	((phys_addr_t)(x) << PAGE_SHIFT)
8f235d1a3eb719 Chen Gang           2016-01-14  13  #define PHYS_PFN(x)	((unsigned long)((x) >> PAGE_SHIFT))
22a9835c350782 Dave Hansen         2006-03-27  14  

:::::: The code at line 12 was first introduced by commit
:::::: 947d0496cf3e12ebfa70b3eaf561c25403247ce9 generic: make PFN_PHYS explicitly return phys_addr_t

:::::: TO: Jeremy Fitzhardinge <jeremy@goop.org>
:::::: CC: Ingo Molnar <mingo@elte.hu>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

