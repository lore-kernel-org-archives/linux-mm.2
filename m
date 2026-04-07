Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5293AFB5188
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 04:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935FA6B0093; Tue,  7 Apr 2026 00:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D786B0095; Tue,  7 Apr 2026 00:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5986B0096; Tue,  7 Apr 2026 00:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64FBF6B0093
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:00:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 069058C0CB
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:00:48 +0000 (UTC)
X-FDA: 84630408576.03.78A02BC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id C3A6C4000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:00:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d0EVKWGy;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775534446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3/+T4sGeRDGVdaUzwkYnO9uaOm5j9yr5+rSq8y+5Ac=;
	b=W/nUp9EXqwJoKP3es1EiHDfiL1NMuGkI5T6giTin8SKnvjHoGP/r+MeOZXiJfKahqwyzpi
	4Bg3bLkRSS25I0IuTKiR0Os8XX+aRvHeB1BqGJjzcw0PnnITcxB7ZVChyE4OBcBIQwmsaO
	lyqK9Sw1xYrxPILT7TPpiJqvi5Mpcqc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d0EVKWGy;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775534446; a=rsa-sha256;
	cv=none;
	b=sRNG6srRgpR4skJM0aV7au+y7kotA1l8Y71tTWYxaD2mLfj3x0A0k8z+oXE3w2OmD7y9ye
	a/ALQdHupsWWln9E19ni6JcPHpQ7yCn0PgBoZX3gqnkr6p9Z/m/Vv0NSSU7wwnV2h3TVHD
	wsnPurAM6ZvT68E6w5cFNsM+O2KAKzU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775534446; x=1807070446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=USWlDwOx/ndbgT/FRdeormiwr5KIC/20ITAGip56qSk=;
  b=d0EVKWGymTzErPJtkVPMppnpvYkpap4j18pjTKN3LTMrbAE+77U5qc+c
   VAa+w61X0RHEro5kn95+b1iNV7jNRhg01lu6abaYJThHcvhOiK5Tjp73o
   AKHY1iAXYGHMXtu6Rw72EJ7pIWUvvCjzFsXtZsf7/iIEDnPOJgR9kF8fc
   5M1UIzq60J3PzrV3dRleyCe8EPvCFsEpQt2MyHMkArkC/6Y+toITEjUEp
   f595/ZGc6iz2yo0xJS3asbu1G/v5BsW+r5VzItlCAPYoCVKJIuGgAROJ4
   9D3fscdgebBcGYKQsR+KMKEiyH99oYpbQYZgH4G2Yy1zRTBH4I1n2ip6/
   Q==;
X-CSE-ConnectionGUID: 670KQHVQRYe3qoZ3xr1x9w==
X-CSE-MsgGUID: jV8ArwuUSnmbTCme6+Kflg==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="86782301"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="86782301"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 21:00:41 -0700
X-CSE-ConnectionGUID: JbesF0bvTamN7cLAOWalfQ==
X-CSE-MsgGUID: MlWxMTBDRBGxTc/mvPNSBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="224844900"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 Apr 2026 21:00:37 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w9xc9-0000000007H-1lvW;
	Tue, 07 Apr 2026 04:00:33 +0000
Date: Tue, 7 Apr 2026 12:00:23 +0800
From: kernel test robot <lkp@intel.com>
To: Yunseong Kim <ysk@kzalloc.com>, Kees Cook <kees@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, max.byungchul.park@gmail.com,
	"kernel_team@skhynix.com" <kernel_team@skhynix.com>,
	kernel-team@lge.com, Yunseong Kim <ysk@kzalloc.com>,
	Byungchul Park <byungchul@sk.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [PATCH] lkdtm: Add folio_lock deadlock scenarios
Message-ID: <202604051803.UYvkxRXB-lkp@intel.com>
References: <20260402143947.162844-1-ysk@kzalloc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402143947.162844-1-ysk@kzalloc.com>
X-Rspam-User: 
X-Stat-Signature: rna5yzz8o8zf1rnykxeg3xf78mp356a4
X-Rspamd-Queue-Id: C3A6C4000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1775534445-54585
X-HE-Meta: U2FsdGVkX1/IBJ9k5hXWpErFtL5e7qbaUpahjGWVNkpBDlTTGGVvPv3NQUAGPWQqOuDJAkEf7AtDfF2QyffUXz8ne3bgfg/9TEt1PzfJYEqwH0goDV+nYywj7nUa2HUr3HHVd7RhM1NybZopF0Ub4YsodxDQe9rT6l6HBFM2HpUCnhbtH0TOAl8hW1s0PIDNUv9prK5RNIYoYkEStPsskJJCCN665fGl2RXUykPYCsXhiYSZG2HLvicZY4+5BFuPztts3h1ANEEJqQF7hYfns7bn8aCVXOpmTcwziTm6+OmkOwwgpKgfjY1z0CZNf4y1UIWJ7bEd8Ht4UWSMvHztQicIVxc0Lin1d97/Sx2bypAEmp2Qx9B0Il66+50pdWicY4mb5CiGY+OAAQ093corsFVvnc5beyzhha9NK8b5cbSNrU3KW2sY0JinjFknd7KsquFSc6B8MBmFnlD2pJM+p7loFWEKN5AdiYuRK2MxPZsTjXAuu2yGRTvYqr1qhBa4ocg4FTauqzhiw22BqD9BkLB5uPVrIgrJWYl5CQ23Xq3ucLOnqZrNyucGwBSzY95yMHvlTznTqnaea8JuYQpnRTSVUf/e5sF7Y0WFG8too/l28AKlUgCGwQZ0ZtIyKYv+pFmS4Y2z5KLv1l8rE/F4I74f/K8H6oaWvHMPeqrjqnuuQezdHPuqeHGUwS8yBzWBib5JMGXdQrRYuvTtkcecP753zot5+S8/MjqSNbjA3qXZLdH13/BI3Qx8E6I01/fgW3Z6kw6PEAo4N2fiq8KpXbB30Bh8mIM4J+BxH8/5qvFnDBOryYen0+vdwQ6geFoGCMJb53WkpH/sHQR+PXM6NU7CX+8XF+N9rSEvPRMu7EqRH8QA54b5cvDVsc+F8obuagMMuLaCncDWk9Hier+P1eX39NYwZ+yQtP5jc46xV5NUJsC5hU1eutzeGsFFn/z2AuJuM7n6j5Ymr+NqPmR
 oq8ml1A7
 KsPEdOr+74opEskf9RdEoBwU4jqEia4Mg0Vb/OAfJt1jloZAC6zYDUvQc0bTUBe7st2o3aUfzRcLiPJR9vMFRCvXYgSUA5+GNWx8ndmzf/D3oUv6hMUULlxUuJ4T72UQxMgeViEuf3zMsxkLI9ebn/+AO4zrVD2dCTJOsmkUWH7CVO3ZU07A/0hIJkRyMkqc3QnkvMaPIuoDdB/FQ22hYsQcSCu+MbSTRbk935OqARFlgbFSp66ixSk3QnY7ywjTvty5ukZ5nOd+DEchTlUTpNjz+0f/oGcxAOREWhxcjIvPxL8+xM9e3Q7GgqcunkV6rpmbeyF4yjObLDyzUZVR+p81ncOXXTynfHb/OfOexJA0n8VZHXwhMxd/n7OVhxvGVH32Agx5pn295yCBEy7nCxHVMKvtkLX4jmarn6ZoM0O9jZ2rqMH5+y7W/HzJtDqfUDYOX/GhR4BgudMeoFYnVXCbfuEK1YMCqak0OsaBWtlfUq2SsqNWW0rKjUJojO/1iEgvYYeRB4QvQD67LAnqhyjIopHXEzSgxUjBb2NUbtcogjT+esMsAL/3h6wY2ut/cJ/0F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yunseong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on char-misc/char-misc-next char-misc/char-misc-linus kees/for-next/pstore kees/for-next/kspp shuah-kselftest/next shuah-kselftest/fixes soc/for-next linus/master v7.0-rc6 next-20260403]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunseong-Kim/lkdtm-Add-folio_lock-deadlock-scenarios/20260405-145013
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20260402143947.162844-1-ysk%40kzalloc.com
patch subject: [PATCH] lkdtm: Add folio_lock deadlock scenarios
config: s390-randconfig-001-20260405 (https://download.01.org/0day-ci/archive/20260405/202604051803.UYvkxRXB-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project c80443cd37b2e2788cba67ffa180a6331e5f0791)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260405/202604051803.UYvkxRXB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604051803.UYvkxRXB-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/misc/lkdtm/deadlock.c:99:44: warning: omitting the parameter name in a function definition is a C23 extension [-Wc23-extensions]
      99 | static int lkdtm_folio_mutex_kthread(void *)
         |                                            ^
   drivers/misc/lkdtm/deadlock.c:112:44: warning: omitting the parameter name in a function definition is a C23 extension [-Wc23-extensions]
     112 | static int lkdtm_mutex_folio_kthread(void *)
         |                                            ^
   drivers/misc/lkdtm/deadlock.c:228:38: warning: omitting the parameter name in a function definition is a C23 extension [-Wc23-extensions]
     228 | static int lkdtm_waiter_thread(void *)
         |                                      ^
   3 warnings generated.


vim +99 drivers/misc/lkdtm/deadlock.c

    97	
    98	/* Attempting 'folio_lock() A then Mutex B' order */
  > 99	static int lkdtm_folio_mutex_kthread(void *)
   100	{
   101		while (true) {
   102			folio_lock(folio_common);
   103			mutex_lock(&mutex_b);
   104			mutex_unlock(&mutex_b);
   105			folio_unlock(folio_common);
   106		}
   107	
   108		return 0;
   109	}
   110	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

