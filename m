Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23700E7DF11
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482A46B0005; Mon,  2 Feb 2026 13:31:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430616B0093; Mon,  2 Feb 2026 13:31:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331376B0096; Mon,  2 Feb 2026 13:31:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9A46B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:31:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD78AB71D8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:31:20 +0000 (UTC)
X-FDA: 84400359120.10.6E12871
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id 885FA180007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:31:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bn7iJS0a;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770057078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=t9+bvfBQEkjMCoKn8hDaUbiuNsVex6DewVLWBe/jPYU=;
	b=zwDzmIQVyskIjHytvuo/+arFWA74bfk+g6L0TjJ8T5q8f8yjE+d+WH+OJ9xTItTPa/m1bE
	tWx54XUStcLj1pOQyv2fKleGgsHXqxs7ka/6mqorZsm7cFkZB7B/Xocptk6YD58IQQcR16
	mJmEQ0WLQNDpyCGVo/X6+SSudTug6AY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bn7iJS0a;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770057078; a=rsa-sha256;
	cv=none;
	b=pKRVEUyKYcV71/Y5IkNb0ssZUXcCtcySgHGiUBvbhhIW6NRUtydpPwDrpwiUfbRve/Ylcp
	n+xovCCt0pkymqptZFoauSfAPk7hiVVKLh3rBLw4XER7njo8ioilrU+1OO027q4/SbGxd7
	SrQcz/CKJ1L2E6jr47epahyWB6TBTd4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770057078; x=1801593078;
  h=date:from:to:cc:subject:message-id;
  bh=uB6mQ73vPdis808q5Avpb+ZRr7P4BPyr+2R+PpDzip4=;
  b=Bn7iJS0aysRggHekvrykYRepG1YlWyP0mWd7SWs+FPD6OfKXj5Nyc0iK
   o/mSl08AV454swuSbzRq135VnLYXEKry755KSuPHZEBA5/c1GYT/p4nX7
   wGb1j+/zhRG7FR9i6y12f8ugXF8kvFb2Qi657Ue3HS/ezE9y2MaOWJ3wH
   sCiQ7zmUSffDW5VFiWWBGYJwLZzZKxwajSVWuIomfjv5Igix1JwlAcR1C
   OIb8ERLmh7WKMe90BWqX0YZq47MBY1KIw7XuwQ606n/YnHCpwlTggaSva
   9MuExvANJdx5hlISYjlHuS4Y11e7XXyMwpTQmAhtMbuYnI5zv2Nj0ZEN7
   A==;
X-CSE-ConnectionGUID: qY0SyfzDT7O/oJa5KHj4+w==
X-CSE-MsgGUID: SGE3DTdHTWuvXeM27uunSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71203008"
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="71203008"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 10:31:17 -0800
X-CSE-ConnectionGUID: pv8upkzvT0GeLrs6FgP+0A==
X-CSE-MsgGUID: zAbjVh03SrC3YwPTOqPwiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="209603443"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 02 Feb 2026 10:31:15 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vmyhc-00000000fqS-10gZ;
	Mon, 02 Feb 2026 18:31:12 +0000
Date: Tue, 03 Feb 2026 02:30:31 +0800
From: kernel test robot <lkp@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 10788/11220]
 include/linux/rcupdate.h:555:36: error: dereferencing pointer to incomplete
 type 'struct maple_enode'
Message-ID: <202602030233.gZQAuAMc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 885FA180007
X-Stat-Signature: q798nnweda6swg85aiawjkndz34ei5sy
X-Rspam-User: 
X-HE-Tag: 1770057077-332410
X-HE-Meta: U2FsdGVkX1/T6cqLDhEvhlQ4sD6tqY86iiUT21Fp83/De1GQ21s7HXQaqmMUgAuRQMIeIJJbP2hPoA4TSzNgXvat85gSd9SNEVHCq8EBnpXE5iJhpKc1ycVlcDoQKjtxrHaEjepL0/rE+94di2LDRb4XCgPMUzyLtDlb8y97cj17cb8GpfYJaXvRE5+HPzG93CLA6WJvtyxm/+PDuKlgjJ6w/65PKy5PCDJb3tI6Hr1z7G3pUPXuWM23pFSeRYQwgpctP5C5yXuWly4y8GvAbCCztVWdqWbDPCIRn2EIPxSzcK5X00G3dKoBW8A0CUYkCe/ekGR92PBryCiMgyStvU02n2Ew09wdGZLm3OdzOsYWN+YprV3x3PKm5JFvPdBSAVH9iaOpT8YSx1sQl3I4YDLKP7H5ihpB+jFt8SRfiZtCHskLZ+2Uk9yH2byTWk9E94H5YUkZlY6EK+l1OvwdLljN1iuHwV08zl6g4hlQ7qlUQKyhU5RWD2WuAH5qXts3Qu5SD1mX6RS2YyMP5Hib5Em26VD5u0zOp04gcKbvhAOO08lTE7mhi5qMvW4yOmmJwwdwnckiuXriIc2XFKndx9miXaHNoPLhGff6+ygLJ6N651mdR7+lRcakI1wQlndAJ/F/oHeGjNzgn/vlnxPY+iatmgHKDN263qPyGnY82YmzeUZ41x5ym8hqcEYnyz2oWJRSLntuWOeEaaemqVBD8yvp0Yn9Ib8DDfD/xD8ZIfneHMYHg2Uc9AYq3V1yI6rgWIqw7h0K6K5lFbKyZnsx+DsRF239O/2Hg5r3r2/EGuagfL3czaxXHm7++dxK4V766SSkoauEH0fftXDCVvaLZ6tboOR0lgcrAgr7hSEjQTeMqtnVtjtFd3R/9fpxKecwIKiTq7/dM5NUt2BIJUjp5BBWErVrPbEsct781bpJNC/3uCIMrA11CdG9RdvppFd6t4Qg9ZWFdAWDave3RL0
 it0MmHQn
 CT/qGbUY+NJwJsxj+HvioITMfWHjKEyqdBalPcouExqGtU2BoYGzVzoIISDCz0KNK0RzDYKqhUVpJcIrk/m9Lxkess1Fv6xijp6jTQcxuLDjqg5mur9FQ4/RB/L4XFEdHxe7fnCMNYImm2Uiw6g6ipQ/sSadxzXpTNce4q86Z3beVgmcz8M4JG5QvtpGKUjkG0NTj7dLGyl3aL6v7uoimlfSIX7O+04rC8mUloZILnMoF5JR7r26jXxoTsKDNUqXuUO4ngFZ/BPyfGKaTD3oo3JB+LkKDr521knBquKsPUIiVyGimuHlvS/ycOIX5ybtUVGe3asm2kuewClN84SdlY74h9YG15qzvriMr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   193579fe01389bc21aff0051d13f24e8ea95b47d
commit: 60d8a8eb080e2f6927add49f47625574b39d3072 [10788/11220] maple_tree: add cp_is_new_root() helper
config: parisc-randconfig-002-20260202 (https://download.01.org/0day-ci/archive/20260203/202602030233.gZQAuAMc-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260203/202602030233.gZQAuAMc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602030233.gZQAuAMc-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from ./arch/parisc/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:380,
                    from include/linux/array_size.h:5,
                    from include/linux/kernel.h:16,
                    from include/linux/maple_tree.h:11,
                    from lib/maple_tree.c:56:
   lib/maple_tree.c: In function 'cp_is_new_root':
>> include/linux/rcupdate.h:555:36: error: dereferencing pointer to incomplete type 'struct maple_enode'
    #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
                                       ^~~~
   include/asm-generic/rwonce.h:55:33: note: in definition of macro '__WRITE_ONCE'
     *(volatile typeof(x) *)&(x) = (val);    \
                                    ^~~
   include/linux/rcupdate.h:1046:3: note: in expansion of macro 'WRITE_ONCE'
      WRITE_ONCE(p, RCU_INITIALIZER(v)); \
      ^~~~~~~~~~
   include/linux/rcupdate.h:1046:17: note: in expansion of macro 'RCU_INITIALIZER'
      WRITE_ONCE(p, RCU_INITIALIZER(v)); \
                    ^~~~~~~~~~~~~~~
   lib/maple_tree.c:3364:3: note: in expansion of macro 'RCU_INIT_POINTER'
      RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
      ^~~~~~~~~~~~~~~~


vim +555 include/linux/rcupdate.h

ca5ecddfa8fcbd Paul E. McKenney 2010-04-28  550  
462225ae47d717 Paul E. McKenney 2013-11-11  551  /**
462225ae47d717 Paul E. McKenney 2013-11-11  552   * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
462225ae47d717 Paul E. McKenney 2013-11-11  553   * @v: The value to statically initialize with.
462225ae47d717 Paul E. McKenney 2013-11-11  554   */
462225ae47d717 Paul E. McKenney 2013-11-11 @555  #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
462225ae47d717 Paul E. McKenney 2013-11-11  556  

:::::: The code at line 555 was first introduced by commit
:::::: 462225ae47d7175f886281d8a91708550cd5178c rcu: Add an RCU_INITIALIZER for global RCU-protected pointers

:::::: TO: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
:::::: CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

