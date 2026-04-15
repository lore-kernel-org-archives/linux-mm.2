Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 250A6F9D0CE
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F64D6B0092; Tue, 14 Apr 2026 21:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6566B0093; Tue, 14 Apr 2026 21:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394F66B0095; Tue, 14 Apr 2026 21:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 285646B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:43:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C696A8B10D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:43:35 +0000 (UTC)
X-FDA: 84659093190.29.174BCF6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf28.hostedemail.com (Postfix) with ESMTP id 15F25C0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:43:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ct++P5Xs;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776217413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Bl7WGpmLYIApMfuS1TwMShkQjfWUQ5qudg2RkqIKY0=;
	b=wDIQyRZxTUUH4oODicf3qeMiOPp21RIZXasgVPwB0UeGbVsk9Fztzh3PWFT0TlT1tj4YwW
	SejWAMj/jfZbcPZ4mTXarEgkx+IRJJN6M2gY2kE5+sQ56QPFh2fcOO83SWEVV/SQ4RnVbY
	m46InjMEP51fvnppjGqCCdiYCF7CAc4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ct++P5Xs;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776217413; a=rsa-sha256;
	cv=none;
	b=Mm50AVepcywLKZj9VRarqJty2F8T9ZtBQfxc6XOc4X+UFc2SmTy2q8iti2actsEEAnb5CL
	c7a3N0Yg4dIjLYHW6SGmERU8ycC7lyvNz8CwqbrVlwJmAY8kxWFPBxvJEtNSIKoVM3ViqJ
	ogcFeGqV2l0zk0MBBdeG7DLMf+78UuM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776217413; x=1807753413;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KJ1dmm7JBQS8tm37XInqKorcvhoHPQHM2ZL56cx+0tc=;
  b=Ct++P5XsUBJCz7JhMzvZ3nfAX/zU+GXjhBdXvJPFBZKI0igDRwv6xV8l
   FJcmfmd31z0n2FoiNnUJovxN5b2uhY+KmPi0a41pmjBkAhXa+3MgKKFzt
   jkhMkJvRQoOrsAIjqLu3/ueLQcZMNlr5jq54SqV3pRS9p88r2X30UtZOY
   TWXYH5MbuQ3EboqQmqNzhBbh5f6GystlI+x8jBJzh3oFJluwYrlrPq0HH
   oFDCaZIHjHKekDN4d/kCXRXGh3z9wC3NeJn3fhgZTwiJxi8CqwAwCeyHl
   TDxsD9Ool4xpVQuAvhrd3ajeZX9PoEgA0/KzYnsurpKlEyYtaaYjEzbNo
   g==;
X-CSE-ConnectionGUID: +uhlwKD1RbuZYJR2PRMXOQ==
X-CSE-MsgGUID: +dPt4UNKRiCuojh/APHZiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="77092848"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="77092848"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2026 18:43:31 -0700
X-CSE-ConnectionGUID: xDnDgNgmQHylQE5TEFOqqQ==
X-CSE-MsgGUID: 0K3ensgWS3ubo6LrqDE3yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="229401197"
Received: from lkp-server01.sh.intel.com (HELO 7b0b59b3a0d4) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 14 Apr 2026 18:43:28 -0700
Received: from kbuild by 7b0b59b3a0d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wCpHp-0000000023N-1IVW;
	Wed, 15 Apr 2026 01:43:25 +0000
Date: Wed, 15 Apr 2026 09:43:06 +0800
From: kernel test robot <lkp@intel.com>
To: Youling Tang <youling.tang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] crash: Support high memory reservation for range syntax
Message-ID: <202604150941.oDguaP7A-lkp@intel.com>
References: <20260404074103.506793-1-youling.tang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404074103.506793-1-youling.tang@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 15F25C0006
X-Stat-Signature: ebuhnb6cmj4fs8mrjqwct816bobtj8cb
X-Rspamd-Server: rspam06
X-HE-Tag: 1776217412-639800
X-HE-Meta: U2FsdGVkX1/+Fzu1sbvfeMIj4cq7IsRNeyy7zAG2xKaJ8h8LmkMYrpdyBIw9R77znRCi/3vB3w659/M0QFIJUP4xFMRs2Qe6zV7wjBKXWcUzLe+Vln3j8/4q7SfbsjE2+jbSy0pRwwBEm4xfI9i65ZhrepDpQHtgLAUt3/A4VPFsiia7hSlG3OOFmxKPU5JXX9kG2SHfaNKhGNZVzgIZhaJLp8eiwdMfZq+uMUkuUGLJiLhz05TErSyS+fyXhJG7yD6NzhqaLY2ETywF8Dmp90ThFV4qViKDcZhzFgHB8q8ELfYPxEvjP+rZC+qwPv/jWKMb2kVMd97iK3XEdRHqXHnxfF2w63mM/x7XSd70ydCrnejqbhRFqSiVztm3Kl2OB/tZ4Ys6u5eepQAbrxqwOmCHE7ChK4gxOQkZgQxyPbxw4Bw4P4jZnnCwO7yGkXWxqTSoZM/sei9Vo9s/10Uxb4i4hDmG+RXkgzL+PvMFjmwBiyzm1v4TE6rwSjMbDzUIIbTrbuy5W8khq/zGV758ttPVkV18hM2yM0YMMWynCrR7zKsQ2zX5sY9B6FqVwS9rNTdUjA5qsEOHlj3v1KrwLoZ4j9GvYMOQOThV73j6FxvRPF3FULraIecKj9m8ZzQBSLKWrjar60Gvd9MyozXVoHxPdluNZOzEIKQwCbWrR3Kf5f4jsDl+ZYS8S1F8opigfrym0Wga1NjyLxtvrPtbDkENmigRC044itVquyzGptVslbhTQER8T2bftB9fjyckaVcnH/+0f7cp/MHy9Dsc8ulo7tNyjxLpvaDBKAExmfRuWkK2KEackw7wOYS/xDIsongZU6QCBbP//s41v2IQ+hnQBxDaTkrk2J8pikXSAywK/yZKUAFvxjRxloh04B/TS7qqp4S3BXuZu3/0Hd3NC+vAE2gV9uYW5/coy+EJrgfSv7Tmzi2E29FrJkBNOZ9NHyhQkbUzvEHgNP5uTDc
 xt8Ec3T7
 13iiEhZOZqmExrHc+SB+zA0CqReRVidwmt0G8CnjjCXNszemPYZV2aXyXmYkiveB8ZMoJ88Ud8el33ttqVS1zc+cqS86Qia9ycwYVape7jRJNkJCNv+UhQme0ScBf9klVwUDuMwpctabVoLiuKbriZZbG/uHuz+JpEgppYaXZ7mxv56B5brcGPLYbXj3LTNvnD2ODWfS9LWWI8gILguD1fUjOa0BoyjHPyMK09f0LT3JHCB2NPdPLVz+/Nmhr9cm6YAE6JkICaTUU8PpPFiN8epUEYzWmYA+P3v+2KL5wIePVHvdw88/8r+EtbU6LOuUMKZ8IPUE4LVDrFJiv9bZThTXzDU6Rd7kcq1z5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youling,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v7.0 next-20260414]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Youling-Tang/crash-Support-high-memory-reservation-for-range-syntax/20260414-205035
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260404074103.506793-1-youling.tang%40linux.dev
patch subject: [PATCH] crash: Support high memory reservation for range syntax
config: s390-defconfig (https://download.01.org/0day-ci/archive/20260415/202604150941.oDguaP7A-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260415/202604150941.oDguaP7A-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604150941.oDguaP7A-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/crash_reserve.c:264:19: warning: expression which evaluates to zero treated as a null pointer constant of type 'char *' [-Wnon-literal-null-conversion]
     264 |         char *first_gt = false;
         |                          ^~~~~
>> kernel/crash_reserve.c:324:16: error: use of undeclared identifier 'DEFAULT_CRASH_KERNEL_LOW_SIZE'
     324 |                         *low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning and 1 error generated.


vim +/DEFAULT_CRASH_KERNEL_LOW_SIZE +324 kernel/crash_reserve.c

   282	
   283	static int __init __parse_crashkernel(char *cmdline,
   284				     unsigned long long system_ram,
   285				     unsigned long long *crash_size,
   286				     unsigned long long *crash_base,
   287				     const char *suffix,
   288				     bool *high,
   289				     unsigned long long *low_size)
   290	{
   291		char *first_colon, *first_space;
   292		char *ck_cmdline;
   293		char *name = "crashkernel=";
   294		unsigned long long boundary = 0;
   295		int ret;
   296	
   297		BUG_ON(!crash_size || !crash_base);
   298		*crash_size = 0;
   299		*crash_base = 0;
   300	
   301		ck_cmdline = get_last_crashkernel(cmdline, name, suffix);
   302		if (!ck_cmdline)
   303			return -ENOENT;
   304	
   305		ck_cmdline += strlen(name);
   306	
   307		if (suffix)
   308			return parse_crashkernel_suffix(ck_cmdline, crash_size,
   309					suffix);
   310		/*
   311		 * if the commandline contains a ':', then that's the extended
   312		 * syntax -- if not, it must be the classic syntax
   313		 */
   314		first_colon = strchr(ck_cmdline, ':');
   315		first_space = strchr(ck_cmdline, ' ');
   316		if (first_colon && (!first_space || first_colon < first_space)) {
   317			ret = parse_crashkernel_mem(ck_cmdline, system_ram,
   318					crash_size, crash_base);
   319	
   320			/* Handle optional ',>boundary' condition for range ':' syntax only. */
   321			parse_crashkernel_boundary(ck_cmdline, &boundary);
   322			if (!ret && *crash_size > boundary) {
   323				*high = true;
 > 324				*low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
   325			}
   326	
   327			return ret;
   328		}
   329	
   330		return parse_crashkernel_simple(ck_cmdline, crash_size, crash_base);
   331	}
   332	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

