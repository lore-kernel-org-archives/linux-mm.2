Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D419D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VnshaIwX
Received: by kanga.kvack.org (Postfix)
	id D805F6B00EF; Wed, 28 Oct 2026 21:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31776B05B1; Wed, 28 Oct 2026 21:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DB16B05B3; Wed, 28 Oct 2026 21:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6E426B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:00:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33F28120289
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:00:16 +0000 (UTC)
X-FDA: 85373857632.14.9773019
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86F2E180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:00:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VnshaIwX;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793235614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=AvcUC/1MiOceAMBu9K9D2zoZ9m1WdRohTEGTv0h4Flw=;
	b=3vjjRk+HzjH2fIAeh8u4HSa0H7WrW949lde+feerzKMTH1bOQTzpotL8gNKbGSinh7Uf7D
	oAzp7FoB8umWlmodiNcYwpkIgd1RjnSUtW4GIQFpvpLtOmUaAmNyfILtiw/0fXsu3ruYyX
	jqOX0wVFEtjkafdTRm6EvlpLd/2Oyhc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793235614;
	b=ujWOYOGNi6kf1TVc7SKcbA21+fWoZm8PHRRPg4gpZL8eY6BGXXjqRVe2RoxSSVeVaQZnm8
	8xG/XRtp7DTVtwXZ5fhdeM0+YPwpWGKQXb2eMum2XW1rrgmUF+wumTWmnWNTMOvqSVuM4o
	uPPpqJHvGSYnvHMbCg87GDiAeJFB4qw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VnshaIwX;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793235613; x=1824771613;
  h=date:from:to:cc:subject:message-id;
  bh=EUKRzknw2e8I9NSRveKmihVUd0h/TngiF/kNRita2mM=;
  b=VnshaIwXWNsOKDYMZA9ba1ZoTVYxIdx+p8JYwc/ebaZwpb+2+5YxqFef
   R0GMKWg5BSO25S2xaYt4qQG5KFkrIn+vcrpAB5Swdxmw+BgguBC4txiCv
   mdYxTHF3flZeqGZhWL97QLfEIXoUFgfSSQgQ9y9ZQwaKQAJSkFeAJwijK
   ubI1hw37vH1TdOei7BiPUI7E6DxhfFrdNFuPztVAs7zg83cNSE7baON0f
   lZ8Ek5+xVQtMvDykp1QZlNjyThP3fnjWGxwKFVdrThFwX5idMhOzByOyA
   5IoM/73xItLlxcgxtkbT0fXP3EOWivhyqXARTblvrSylE2Km5HxRUM6e8
   g==;
X-CSE-ConnectionGUID: KJDK0fodQHO+xgrio4vS+A==
X-CSE-MsgGUID: G9MwbNDyRTaNO1tobAmdEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1996875"
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="1996875"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 18:00:12 -0700
X-CSE-ConnectionGUID: xuLpf1JaTRiH9SL1hq5ocw==
X-CSE-MsgGUID: uJVdH5ozRpi0erEHLgdGVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="6822378"
Received: from igk-lkp-server01.igk.intel.com (HELO 58ca8a381a5c) ([10.211.93.152])
  by fmviesa011.fm.intel.com with ESMTP; 28 Oct 2026 18:00:11 -0700
Received: from kbuild by 58ca8a381a5c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMEUx-0000000055D-3ljg;
	Thu, 29 Oct 2026 01:00:07 +0000
Date: Thu, 29 Oct 2026 01:59:13 +0100
From: kernel test robot <lkp@intel.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Bradley Morgan <brads@mainlining.org>
Subject: ERROR: modpost: lib/kunit/kunit-example-test.ko: symbol
 '__mulsi3' undefined!
Message-ID: <202610290106.o8Fs3NvO-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86F2E180003
X-Stat-Signature: digcpnxndrynw47jz7crjfexo9ufobbp
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793235613-305958
X-HE-Meta: U2FsdGVkX19ZIcl5EYC1V/n3pnoOq1REWvMVLwEHeyHP+yMcxn3UQ4RAMjaoTauw/SgG8c7UBvMzpBHouoc3qFgEj66GTdxXnCb0jefFe00oo/kXUVRbbYiywI+qgDc59x9k8Ud9YmrEC1vjMfJEzTpzjOZoXvjYCjFx/1XNp2FhTr3RWUR7JiEqRdpXZv9i2ZTjELfdwk8mnEhMEWVJpOqXNhwE+wVcEnYhXdnKYWkv806zUNlsQIy6fYOM+BWRsAMJ1IGnjl8oX3M9hXtfTlcUi4bBW5Ix/uDYoDphiPJB0SqcSU6DaxWV3byETZc8CwyG1eEb14El/n/qsAD5qipa3z1G09miRhASPPIXSsI2saSoYyGXn2UnP7STpHzqKd+SE83ZYhrp8eGTeU6bpr0wbMW/SWXk4R1f/70ARWe4K6Mu8SyBlc4FrmWqQAjF3MDoFcX5i/XK6mWG4Yw8z7zlnENVlM6rt+DN0WQJ0ZQVG91oXzKlqu1JB74aZ1bsWPTQ4GnppDmg1I66fj+80q6TeQpYjVCAhrnrK0YPFIbYMcEZ7HFrHyD+6Ridjk3kI35jPlG/BqDXQgIO0wc2I26KPZLmQ8/E4sLlvVPqiPYxwrBWSUHhMamj4HFwm49Oge4ZIm6ULyWLpzyuI8SD+4ia2LEsWY5VuLpGQ5DbCrYCsbkvKXOq5sYnizRel1VAsw3Vo3loGOjKVSMZE3gsXRKwqmOP/QaKkp8Ei9R/8UtNYPVmi1G6FFvBQfuZ8cddhjwmAD5BTZuCR/+FcHO7s9x+D+bVXdFQ7CCrq+4RYklo3jOo6RdoCujzT8I11vYSgCbd8s/p6vrDnjiEgkf1dwcHWm9uUiN4+JA0nq+peyVcP4M+oRkNPJDdxDsZYxSZ2R2dLhV68EvOhIMW9yQlUHYBKaiStAtFZgJFgsZ002HHiMBlIR+8cNX+zVcVnYmn+IpGu78BFVi+GmawAB5
 bzlnPqEF
 /mIoByVd2mIIPzj3cbzRQyZhXvMHjDO5rSaGeQuCxhVubOUJkA05GjkPRumtFKAhNyutCz1Ob00x8Stwh9NyOE2TU6tVihrFQ++yuqXKAIlhKIBvALyPyJGdeFxIVIRbi3St9VM/ZoyTn1z2UI+XuGs6i382R8QsLa45/TCqoEDJ2v1vTQcCNPgOwndrrYFn+MDXzMLj7hsSL1A/zObmP0NN989Ftq3DS9bF0ReY7+ifF0v6uLw83H75myxy+FQ5y5Mx8a+wHo+LZnaL1dAnzfuLo/8d1o5SztCeNRDGyi3SzA+xnV54BdSEh8Ri6XInFSI8NvDp9m5cTKZze5mUFxEy2SM1Xp30oMAUxIpP4dwBUZFQMRuV3euIXww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hi Karl,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   c339f4010dea8b0d754f84ace70cd1b089878ef8
commit: 7c3f4d699f34535285d0ceb184927d71543d0064 resource, kunit: stop selecting GET_FREE_REGION
date:   2 weeks ago
config: openrisc-randconfig-r2306-20261028 (https://download.01.org/0day-ci/archive/20261029/202610290106.o8Fs3NvO-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.2.0
sparse: v0.6.5-rc1-1-gc4640450
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261029/202610290106.o8Fs3NvO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 7c3f4d699f34 ("resource, kunit: stop selecting GET_FREE_REGION")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: kernel/rcu/rcutorture.ko: symbol '__mulsi3' undefined!
ERROR: modpost: fs/fuse/virtiofs.ko: symbol '__mulsi3' undefined!
ERROR: modpost: fs/pstore/ramoops.ko: symbol '__mulsi3' undefined!
ERROR: modpost: fs/ecryptfs/ecryptfs.ko: symbol '__mulsi3' undefined!
ERROR: modpost: fs/overlayfs/overlay.ko: symbol '__mulsi3' undefined!
ERROR: modpost: crypto/asymmetric_keys/pkcs8_key_parser.ko: symbol '__mulsi3' undefined!
ERROR: modpost: crypto/ccm.ko: symbol '__mulsi3' undefined!
ERROR: modpost: lib/kunit/kunit.ko: symbol '__mulsi3' undefined!
ERROR: modpost: lib/kunit/kunit-test.ko: symbol '__mulsi3' undefined!
>> ERROR: modpost: lib/kunit/kunit-example-test.ko: symbol '__mulsi3' undefined!
WARNING: modpost: suppressed 1014 unresolved symbol warnings because there were too many)

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

