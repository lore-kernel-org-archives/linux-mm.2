Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD05C2A074
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 10:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F72C6B0092; Sun,  4 Jan 2026 05:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A576B0093; Sun,  4 Jan 2026 05:45:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479E76B0095; Sun,  4 Jan 2026 05:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 333BB6B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:45:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 027D01AA069
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 10:45:14 +0000 (UTC)
X-FDA: 84293949390.24.E03FDCD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C16A1C0007
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 10:45:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kFNzZawD;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767523513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4kUc4Gy1Q4guuMiS1dhlIBFRFKR3lmOikhJJznqndg=;
	b=ovjHOvUZflWxZhM3cfjTvtdYqIJEpRaoC3cg+LvQI0jWLMHBpGzr9oJPzCbaM3DdccuE6X
	zc4ksUjnZPw0DIlgYKxz7fjey/ZYRwGBOjW+H6p0Rs1Atf508Zdrq8WsQA3QV9h9rkCAht
	H20gFIjWAKJ0Oc3uMjKDArZz55B2Xpo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kFNzZawD;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767523513; a=rsa-sha256;
	cv=none;
	b=JKZ0nmSx819ssBS5h9zstSZeTaZsE++4uFGZijUFkbT+nzbmS0MKogDNPUNLlyloQphGs/
	g3X9cYDTVmdfh8UGfZjGG/xSqWdtBu0/VwMWjHvlzj2+uGzjYb3s2lsGNFoIYNiQt/Td/M
	BmjpeOgNw0qv2miFxStzT4pKQVux5TY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767523512; x=1799059512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ktwHsdreMOy3nXLKvFJ0EqHl5o10OsVdQQOqs+UIyeA=;
  b=kFNzZawDq6WLnHGYJb/IXeLvxadebU37uodA6T7kw9Rit/Cl5NaiKInd
   6KzrNgokfJSSxHBFtjRh+klzIpfFFH0R3AuASqMYb5CeJqWuwobyr6sS3
   Exs6jVdhNmUNfHbIELW4753lmaGWm8MnyQSyRoewWC1Dmg71gttzD5YBs
   8ToGulNQvb0KNIERqlaiQDicYYpwkMccp0deAkGKKgMNbmWbNPAyP24kb
   FRs7vGanSNMB6rBldQQbGXkjz8b9M4G3h8EdZTgDB+euMnqMSmSeaguVR
   cWym8iOBNu2UPFyWwmJ51X6WltHS4acg7HxZRgfk1XIdBmSTPN9Q9wuO/
   g==;
X-CSE-ConnectionGUID: vw5cTIaDSyOqdx9wJmXJ4A==
X-CSE-MsgGUID: xgV9F80dRmSz8ySoa7IeYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="68832778"
X-IronPort-AV: E=Sophos;i="6.21,201,1763452800"; 
   d="scan'208";a="68832778"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2026 02:45:10 -0800
X-CSE-ConnectionGUID: ADv6f5dcTOe85eJFZpu8VQ==
X-CSE-MsgGUID: yObrqGyaQlylT4I8Pv62Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,201,1763452800"; 
   d="scan'208";a="206690326"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 04 Jan 2026 02:45:09 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vcLbe-000000000W1-196D;
	Sun, 04 Jan 2026 10:45:06 +0000
Date: Sun, 4 Jan 2026 18:44:30 +0800
From: kernel test robot <lkp@intel.com>
To: Pnina Feder <pnina.feder@mobileye.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Petr Mladek <pmladek@suse.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-kernel@vger.kernel.org,
	Pnina Feder <pnina.feder@mobileye.com>
Subject: Re: [PATCH] panic/kexec: Allow forcing panic execution on a specific
 CPU
Message-ID: <202601041820.6M8cIq2e-lkp@intel.com>
References: <20260101123237.277411-1-pnina.feder@mobileye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101123237.277411-1-pnina.feder@mobileye.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: 78c6z889roj5p9jozubq79omteeny5c8
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C16A1C0007
X-HE-Tag: 1767523512-659585
X-HE-Meta: U2FsdGVkX1+mGYRzyqGRCG2cPm3Gi+Tk2a41vDRE1+IRMhBW2sOt+KdBT3rL06LZgGSiIJTQ2mGxytnzFnI6C1NvuSG3ZPSPP+FYt1GjLXCLpCVCIroRpCFnyG/XObGvAqpQwkyrJnvdoJjJ2fhfobDCRsGY+o09hy/R9Pfj30iPDFa6NUioA3243Jtzh9jlUl9f5n9J4dB0D8YcGPTB6cHNidGkvSdWewmJXzdI0ETbSduvm1AN3ec1tOOy4Jd7riup0o/aNccTB64knpApsMk4OE0XNF1vCmDMlxt9edh6bk8xxYyJGhUSkTvID2pxCuQ3iMnpJS3OuNlftoSHzMKHKlxyCYn3KOX4VGYJqDTs1pwrmzvM07u3lD1miFDWN9sZ1quo7hI4kTVaUxwiHlQq0ff3FDCYFWQGRw2akPlG/qEJZeYuXPyiz4l1Q7pwqXUvKrlfivPoZubJfwnOkVoGWPxj3H7vWQvT2q7ACXztQF+7h7GX2J5D8MrB/Z2xKnjMwDFVdeHtgYnq1L1B5H5Ev3daZ7bjLvS2fNylh7IyxWej1frwGpjaLVhVPKgwordsS4lHeiqkKPynvniFA+u6R5i4Tm7LMpULMdjh12l07cmlvIop/KSaIoB3uDJuJWfmpZdEIzPWLaNmK8/mEXtrl6qkQ1q2X+RofWazE/ujR/KdqBnkmYpbfOSG3fAQ7KmX1uBinmjUlK4Db+BNtZGwlwiFUaKBFyD5M0GyhYCMnUEgcHDQ/GXaJzeEWXVBToygDuZRu9NG+WtCXkf1lxqem4chKLOeoHXqDRS90sWuaCMxuydSjDtsoN2PW8h3OusWVMS2FNyoccAWvOeGtC9Maqe5wYRj9vqQvz0ZbyGQCk76OpfjbNGPQfafZ7yUt73Ogw36i6WCLif6luOSVu4B9qTSnaqDLP0crMnVb7k6yQgR2HKxYqhowb92s829sdzh57I5iNvSg8aJLpX
 +mB07HH0
 BABR3iZmK6dqP561H1HRnSX+91zh9nNM4lgrQpxcs1cevcK9g1N96g3R7Spn5MN86SnE8rfuzl+rtaVtA+aOz3aJ6b6QFHxW3SChdJl8QGovjWIZ5zIqZNnU3XH63bcE2z+N+HajAkDpkslbNjPzxHhqQIK2Ky7GOXwto+bGalr3ufiQ5YTGendN3BfmZltoWPAK8Pk0mEsZgc7l+kKbQLlMknhcoQ41bhdrXVgKUz6IruzH8Pznif0HbxuhhnwkTi+muoPm7nSEyl1CFlI6zvmbRLhi6FK3XwOC9gaBaIBoL0j8X0uBsz/2euT2DnBb7eHr7JjskA+6bdw8f1wPUagHnnQtQlGK4JjtA8YO8yLOFd/2l0RQyDnNfyvZjJUHtf4smF2baOh/YB/ePwfC7JfCO2gUkaywFqy/i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pnina,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.19-rc3 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pnina-Feder/panic-kexec-Allow-forcing-panic-execution-on-a-specific-CPU/20260101-203448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260101123237.277411-1-pnina.feder%40mobileye.com
patch subject: [PATCH] panic/kexec: Allow forcing panic execution on a specific CPU
config: arm64-randconfig-r122-20260104 (https://download.01.org/0day-ci/archive/20260104/202601041820.6M8cIq2e-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260104/202601041820.6M8cIq2e-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601041820.6M8cIq2e-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/panic.c:349:69: warning: diagnostic behavior may be improved by adding the 'format(printf, 1, 0)' attribute to the declaration of 'panic_force_target_cpu' [-Wmissing-format-attribute]
     321 |         vsnprintf(panic_redirect_msg, sizeof(panic_redirect_msg), fmt, args);
         |                                                                            ^
   kernel/panic.c:321:13: note: 'panic_force_target_cpu' declared here
     321 | static bool panic_force_target_cpu(const char *fmt, va_list args)
         |             ^
   1 warning generated.


vim +349 kernel/panic.c

   308	
   309	/**
   310	 * panic_force_target_cpu - Redirect panic to a specific CPU for crash kernel
   311	 * @fmt: panic message format string
   312	 * @args: arguments for format string
   313	 *
   314	 * Some platforms require panic handling to occur on a specific CPU
   315	 * for the crash kernel to function correctly. This function redirects
   316	 * panic handling to CONFIG_PANIC_FORCE_CPU_ID before kexec.
   317	 *
   318	 * Returns true if panic should proceed on current CPU.
   319	 * Returns false (never returns) if panic was redirected.
   320	 */
   321	static bool panic_force_target_cpu(const char *fmt, va_list args)
   322	{
   323		static char panic_redirect_msg[1024];
   324		int cpu = raw_smp_processor_id();
   325		int target_cpu = CONFIG_PANIC_FORCE_CPU_ID;
   326	
   327		/* Already on target CPU - proceed normally */
   328		if (cpu == target_cpu)
   329			return true;
   330	
   331		/* Target CPU is offline, can't redirect */
   332		if (!cpu_online(target_cpu)) {
   333			pr_warn("panic: CPU %d is offline, cannot redirect panic. "
   334				"Crash kernel interrupts may be unavailable.\n", target_cpu);
   335			return true;
   336		}
   337	
   338		/* Another panic already in progress */
   339		if (panic_in_progress()) {
   340			pr_warn("panic: Another panic in progress on CPU %d, cannot redirect to CPU %d. "
   341				"Crash kernel interrupts may be unavailable.\n",
   342				atomic_read(&panic_cpu), target_cpu);
   343			return true;
   344		}
   345	
   346		pr_info("panic: Redirecting from CPU %d to CPU %d for crash kernel\n",
   347			cpu, target_cpu);
   348	
 > 349		vsnprintf(panic_redirect_msg, sizeof(panic_redirect_msg), fmt, args);
   350	
   351		smp_call_function_single(target_cpu, do_panic_on_target_cpu, panic_redirect_msg, false);
   352	
   353		return false;
   354	}
   355	#else
   356	static inline bool panic_force_target_cpu(const char *fmt, va_list args)
   357	{
   358		return true;
   359	}
   360	#endif /* CONFIG_PANIC_FORCE_CPU */
   361	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

