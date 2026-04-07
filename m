Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43540FB518B
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 03:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9321F6B0089; Mon,  6 Apr 2026 23:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3326B008A; Mon,  6 Apr 2026 23:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FFD6B008C; Mon,  6 Apr 2026 23:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71E8C6B0089
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:58:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00D82140144
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:58:42 +0000 (UTC)
X-FDA: 84630403326.19.1112A55
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id CEF5C80004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:58:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Di8i1osz;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775534321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPCL4SYEOTpsuntIyjkFcDI45PGxbT6xpxDCsKLiz0k=;
	b=1tBowHW2MW0IF/OJcgLWlu14U/fMsTEv5I9o4XgRexm/ksNnwHbitt4UuvPoQ3ok75op/n
	jMVsQ2cBgSSr0A4sEgl7/t7P9H7//tXq0C4QIpm/xPuwhq+e5p5zQu+y1c2dRc2BxreFbV
	0KtFI2Owg2po4FRFEvrT03TNfOy9w8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775534321; a=rsa-sha256;
	cv=none;
	b=pZXeZ8ds1Bp6DEPSqk1RGhrCwAIDcATU06ddsxfBQRQLfFZYqgHbw48vWkiIRiJUH68xMl
	WEaUyOa4/bS12Nu/7RduCl0FBFP/o8fW6QkB+dvcCtlVcKW2mR/amG8tbTOywTjiCISimE
	AVi3DgGCQ4Q2HT0ZjyNe4SnCUeBK3ok=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Di8i1osz;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775534320; x=1807070320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XfcgHmHjRHl1GSGL66oSlMGazVU+tCu6zO0GxM0fWNU=;
  b=Di8i1osz/XvQx3lM207WyYkkRu4WWWjXL9P2P3lCTs4TU9siereC6C/N
   hOVUyDTx4qS+dnZRaP5Ks9Sgpg6AbQ1QuBhhPBzEI6S1TfNEeSNaaQxBA
   xNAt212ndpT01WRkDyVKr6zmagtxeAIih83VN/bWq4BmyHeSFu4aaT0FS
   71CObPtsVmXcsYtdXCnbjJJBmVmM0TUrfWN1d8KJ+EPGVr7DMKUckzq0J
   cUpy3QktIb9tKWyNPfD+SdZuNvaOEWIyySUFA8SOjvHE3PDYitCFn+oQX
   GXBj8NVJdnfg4U3pjW2Boj6Y0c8y5n4mv6xbBRgoF7IPhA933X8RQJfwt
   A==;
X-CSE-ConnectionGUID: 3nJObMSERRGyrz9o1iy/yg==
X-CSE-MsgGUID: eLTIRlKDTs2k5vDAp8IT7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="87114186"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="87114186"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 20:58:36 -0700
X-CSE-ConnectionGUID: 3QVANTy5RSCNmBvKYCAZ9Q==
X-CSE-MsgGUID: UIln/iEMSIKL1QWWSOi9gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="223259658"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 06 Apr 2026 20:58:35 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w9xaD-0000000005z-073C;
	Tue, 07 Apr 2026 03:58:33 +0000
Date: Tue, 7 Apr 2026 11:58:05 +0800
From: kernel test robot <lkp@intel.com>
To: Mateusz Guzik <mjguzik@gmail.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH] execve: block Emacs binaries
Message-ID: <202604051155.fCOdDQwL-lkp@intel.com>
References: <20260401131226.4011156-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401131226.4011156-1-mjguzik@gmail.com>
X-Rspamd-Queue-Id: CEF5C80004
X-Stat-Signature: 9n9woaz1me3honwukiqxc5dho9n5bfm1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775534320-611803
X-HE-Meta: U2FsdGVkX1+Jm60SegtSfNgnUFAkl9+77voYN2s61WH8RQh7dv5QsD2Q6CKwT9rrcoao7UiDtmi4IDp1xvX6rPw9sWoqNtCq5/lv9ALJNdHlSRtchKeBsGF51TOCAdcBxXqxQSoD8IFWD4nkSVn87yWzHuXyUcR5yjjX4emCiYXhTnMJosVnuYRVdZfwnw+x64pckGAtx+t3d1IVktxZ37hxu55Xc+cFix/RYk2lydGM6h5Crxowh+aoPkBRx33JCz1nwjiYe0TYLjJP1hTmiOZM1IPZKmgG8U8U2Mu7Jl6CONf2U+VJVWig4h6aJKRT7le0DvtB2P1HX4I918tL7Vrza/UcFnf1spsi47xbwCO+ZD+9HPCo+F8Bx7UKhe1WbgElBrFHWX+6IJHI0FIXYrLCKi/GPfwQ7j2UtLojnUHioGhJSGAl9mtD8KPPzS7ZY/PGOj1zvyuCsfofDPLpagJa3fZ/+ZK+SBCrOPjMVgTcZVj8sRszeFRSJGKwH+4dZylE0KJymbvLaOFB357P8qN7w76Z8jVIIpTix1RdBc1NX3NPiZxsOeXGUoIIIH/A/unuCaZt1NtlBh+X9cX88kVK7CNzTmkKjmvZgEitEEHyaW5GgBhXJ5HAy5WFnN8p1xZzG4ui+S7LJu18IPbnmyWqw9iQ7LbL5sFHkHTx5uHIU/M9dnsViDIinxJzv+sP3adTjoTZDGcIZGz8G46Sh9rTPOqWm8neCmjuTWzPvsnP7gKli7Md4rndMDcQ7A/xX9s0+MlLTRX/RA8ECC/7ExeDG7jd2rf+i7Pwyv1PA3TbwfW180ay9jC+ermSPQgz6i5eIJTTgXuJCWA6uiRWf8QvtcXshvtYESrkcRtWpqOM/3xFYXY/QzzbQQ+MY6fZL2/1hem6r+DwhB3mGJ2Q7UsB7oCyVhhvhXzcumWDqxWkZZxd8uIsIhWKqfZLOlR771NrZ2zI1kS5Xl6ZCZf
 qNhTCxW2
 joa1LDtH23+2xl915lBlMXhRxWI//aWoDGZNVAnjl8Ng5y+wUVLDIrIsZTe1E0kgbipe6VbjB+Jxp7oGgvazxeenIUyvGxcftZyqaG6AOJWmx2vayYXRCC6jPdHGRoO75AIn+lI9jAqcdPm+2HocYu8m6ZHUSNV/o4iZI83ubcJTcLZFwZZYnZxlIOD5IYyH8VaQf9AYCkh8JZ5xRQRMi7OWaNtL6dataeGdDWlc5bZqvQbCOkPaOyjycvDFa/IXqNHvgC3HqaRMlC+UL+WncyD7tmF/RPBwq3CAwzIxdHio1/Zp9FXzzQ74+vQ+RfQxnDkH0PMT1Q8Zt9tgMSs2MLP1VpkqrpTyfvgsLmPYXJ1q1NLHN2sC9KswwVOH6pTnoNfk59oj43zsb+BPX+VMg0Q0X1w==
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
config: sparc64-randconfig-002-20260405 (https://download.01.org/0day-ci/archive/20260405/202604051155.fCOdDQwL-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project c80443cd37b2e2788cba67ffa180a6331e5f0791)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260405/202604051155.fCOdDQwL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604051155.fCOdDQwL-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/exec.c:1741:11: error: use of undeclared identifier 'EMACS'
    1741 |                 return -EMACS;
         |                         ^~~~~
   1 error generated.


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

