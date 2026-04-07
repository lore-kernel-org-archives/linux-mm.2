Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCD9FB5188
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 03:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7396B0088; Mon,  6 Apr 2026 23:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E881A6B0089; Mon,  6 Apr 2026 23:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9DDD6B008A; Mon,  6 Apr 2026 23:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C834B6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:58:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 706DFBA3E8
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:58:40 +0000 (UTC)
X-FDA: 84630403200.14.C6246F2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id AEDDC80004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:58:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Lokwcdk1;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775534318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5NrHVy0gR2yuwkZg3tfjA3qW91OgO52NK8uK9Ms6gE=;
	b=UIe4P6/qaCgFxO+In0EPK7dNeQull3sell1HfHT2wqeQmFd/SmVovvKjENeIwGMQFr5Jc/
	OOxU440U7I14uG9i9Quqy6PkRKQgimewHXWHaF/hi/VmXkxhLjtrZBPFaBoADqh+s3/ZIn
	omRq7690vxEAE8a2CTPdPHaeP97hyeM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775534318; a=rsa-sha256;
	cv=none;
	b=d/HMY/Vn0tbsPkyyoj0+hpgc3oADD9f2wWlxU22n6Z2c7dBR3vi0RoNcAjke2xwQG1B35f
	JyfqCop5qdNP38MhBymR9Xy4urnQtSz/bRaWiibS1MGmsJkufRz3e1/zNx2mmhsIQ65P6G
	krT/52n84T34LF7BDJaxxqrNSC+6iNw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Lokwcdk1;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775534317; x=1807070317;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QN5hVQr7wvBrglI7joKcuDjYCJsKaHYMtvZCofb88iI=;
  b=Lokwcdk1Qv+1YiVP2foh3yyWsmweNhFVn1NHQkCQLqwI2O9JDR8I1j1w
   wrVQVZSPNu088jEHMFdvlwRIgHopAzH8G0ldx1O+zGeZy4NsKlGIES+Zu
   XfvB4BVq6KUU4LkCA0yj3yZgqVqedLbUAcPHI0pGPY1ishu+i+jDGpHp/
   EWDpuwMcdhsds3x2g7PULPmjpAt6rVCDzhYfE716f4RHY0rUFveaBxXwC
   ZAn1ad1YCFrGh9y/F5day6J4c5c7qQ8QIoE/Vw/mHeMWM6HX7VIL922BZ
   abZy5hkZvHM0ro29juYeW3ts9pvZGT/+oDJLLsQpGSif4nzaDuvfqhz43
   Q==;
X-CSE-ConnectionGUID: 4FFs1+sbSHCudKkFXNpXWw==
X-CSE-MsgGUID: oJpc03gBSiWnzJYkx/M+iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="87114182"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="87114182"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 20:58:36 -0700
X-CSE-ConnectionGUID: tBUY8QMjQO281LmK5gol5g==
X-CSE-MsgGUID: +bH34ASzQbKZB2NBbJTiCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="223259657"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 06 Apr 2026 20:58:35 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w9xaC-0000000005x-4BPx;
	Tue, 07 Apr 2026 03:58:32 +0000
Date: Tue, 7 Apr 2026 11:58:04 +0800
From: kernel test robot <lkp@intel.com>
To: Mateusz Guzik <mjguzik@gmail.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH] execve: block Emacs binaries
Message-ID: <202604051143.qdWe0OAE-lkp@intel.com>
References: <20260401131226.4011156-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401131226.4011156-1-mjguzik@gmail.com>
X-Rspamd-Queue-Id: AEDDC80004
X-Stat-Signature: fo1m455hbkbgsmiun9nsut9wsdija9pp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775534317-515352
X-HE-Meta: U2FsdGVkX1/R2/sCWYNXq9sXb3CImCXaal79R8vfKKKFO6bO6Z2SjFeBsxQXjlEvUCSa9pDxuPv3bT+F3ZYB8FPTOr1lYcnYN0uuMsdpnyUBIDgwA3khJZkd7W6Up37+nDU5M/FAIkxlsAbf3+CUN9jXFQTLietcOSRtRFOGRJcm4NtjP/rQ46SDSQwVZaAuaZ66Nu0xtV6Go44VLjtMBS1FYD15OGNxLFqs2WpNw9BrnPPyc3Jt4u1Nkpo28sNEsiF15nuaKArSZ5fdxzq2UR3LWYkgNfSBMExHVTl7LLMUJLwliTqfZ5zuw+05OZgXFR561xpVCQ+PN4q/BlEb7a0qu4rH+naEKtBsSIQWSAE4Kh0Kah1+3i2zjJgO2nA8tiFQbENl7G1gOFUoXkhbIgax7Cqv7H+M5SfmPLcn8GFWVS5feF+OcB2sIVBumJ8t/nn/WxjGOxXSF+w/cXEK2IJjU4cb7Mr0xXfFt0QE26ZI0gNLPmfNcaS86xNaPmNYbTHtcS2o3mqRCio2ue4WWCuV6jyb4CXb/aXrhMzYin7MxM3mEQZrD+KTQjIJuW5ynjpku9Peyvvo/s40cBiRIK9tStewI+zCMqKzJYz4Eu4n4R2bkY7mh+ahYgMmHVOLJ0SUlIVEd2Ugb8jitC+NU4GjpSEnLJaJZk6GgGQyiWwI9xhUuG0J4jnIuyo7shE5GSDlxX9mA6c1ZRQIZL3uB+1ZbeMwYWzJhNYgngVuWnIF7HMhmaIU3JUgg3lU5rpXlAatyN6amiem+1CDlZmHaLIwfMXkJOIBK3fTqQ6JAO4K7UvA7WzJIoPA2wBGslPTh92VYSnmqLAtMk7qwFFCXaGFH5UHpDikxo+fJj3WHOJBMABLR5WBMAFRpiAoDIvz4gfdktQomt67RY/FK0VrppqD34xEOc061ARWi4KNVS7ckJzbsrBcCwWodMcOEBnTIQrbm+2dHQfStATBLOl
 hsqoLsaK
 JJw/Q9q4HIyrtQRJ6YQzA81SbOHTlgtB75OyBcBBIiBxA+4PU9unqq1n6fGfsvgV2W06rNxW8irOaG5eRQzyzBdp/8af+wLHnNOXE+Iyru/AB6EI8Mn6yuzvJk9O5YYAnZ50wG5NhzXI+GJRLFu3s2m6xttqsjnffOHYxQnvuJUuxYZdzmA1Z7V23bOxcnDGNrJgk5x36UhNPPdeumFi3clC7M64mhILC5Atbt2axKkBlch+Ox6sJ+/S17y8sHjRXC9vpjLkRVtMwpM0aNTaBkY98kHQpmFB2etzTkcYsUIkxQktEuJARkfTelViyN1bdMfNSIEihHSU7mJAGA1J0WzT1lB9uRS0FA8UEnZQ9HYvx3OD/rcmDl495V79Tw2BNPIvx04vT6Pg1NGgFHwqaBZCiJpS0CkDUbA1kfvxCoL+7B489vPS0z8vRSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mateusz,

kernel test robot noticed the following build errors:

[auto build test ERROR on kees/for-next/execve]
[also build test ERROR on arnd-asm-generic/master linus/master v7.0-rc6 next-20260403]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mateusz-Guzik/execve-block-Emacs-binaries/20260405-070808
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/execve
patch link:    https://lore.kernel.org/r/20260401131226.4011156-1-mjguzik%40gmail.com
patch subject: [PATCH] execve: block Emacs binaries
config: parisc-allnoconfig (https://download.01.org/0day-ci/archive/20260405/202604051143.qdWe0OAE-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260405/202604051143.qdWe0OAE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604051143.qdWe0OAE-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/exec.c: In function 'bprm_execve':
>> fs/exec.c:1741:25: error: 'EMACS' undeclared (first use in this function)
    1741 |                 return -EMACS;
         |                         ^~~~~
   fs/exec.c:1741:25: note: each undeclared identifier is reported only once for each function it appears in


vim +/EMACS +1741 fs/exec.c

  1723	
  1724	static int bprm_execve(struct linux_binprm *bprm)
  1725	{
  1726		int retval;
  1727	
  1728		/*
  1729		 * Trivial attempt at blocking execution of Emacs.
  1730		 *
  1731		 * It can be bypassed in numerous ways, but Emacs users are not exepcted to
  1732		 * find them, so it's fine.
  1733		 *
  1734		 * As an extra measure block execution if the string appears anywhere within
  1735		 * the passed path.
  1736		 */
  1737		if (strstr(bprm->filename, "emacs")) {
  1738			/*
  1739			 * Disgusting!
  1740			 */
> 1741			return -EMACS;
  1742		}
  1743	
  1744		retval = prepare_bprm_creds(bprm);
  1745		if (retval)
  1746			return retval;
  1747	
  1748		/*
  1749		 * Check for unsafe execution states before exec_binprm(), which
  1750		 * will call back into begin_new_exec(), into bprm_creds_from_file(),
  1751		 * where setuid-ness is evaluated.
  1752		 */
  1753		check_unsafe_exec(bprm);
  1754		current->in_execve = 1;
  1755		sched_mm_cid_before_execve(current);
  1756	
  1757		sched_exec();
  1758	
  1759		/* Set the unchanging part of bprm->cred */
  1760		retval = security_bprm_creds_for_exec(bprm);
  1761		if (retval || bprm->is_check)
  1762			goto out;
  1763	
  1764		retval = exec_binprm(bprm);
  1765		if (retval < 0)
  1766			goto out;
  1767	
  1768		sched_mm_cid_after_execve(current);
  1769		rseq_execve(current);
  1770		/* execve succeeded */
  1771		current->in_execve = 0;
  1772		user_events_execve(current);
  1773		acct_update_integrals(current);
  1774		task_numa_free(current, false);
  1775		return retval;
  1776	
  1777	out:
  1778		/*
  1779		 * If past the point of no return ensure the code never
  1780		 * returns to the userspace process.  Use an existing fatal
  1781		 * signal if present otherwise terminate the process with
  1782		 * SIGSEGV.
  1783		 */
  1784		if (bprm->point_of_no_return && !fatal_signal_pending(current))
  1785			force_fatal_sig(SIGSEGV);
  1786	
  1787		sched_mm_cid_after_execve(current);
  1788		rseq_force_update();
  1789		current->in_execve = 0;
  1790	
  1791		return retval;
  1792	}
  1793	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

