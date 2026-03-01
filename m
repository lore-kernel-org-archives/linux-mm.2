Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD8DFD0056
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 08:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617896B0005; Sun,  1 Mar 2026 03:05:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E17E6B0089; Sun,  1 Mar 2026 03:05:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED7D6B008A; Sun,  1 Mar 2026 03:05:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5EB6B0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 03:05:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D05031B7ECD
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 08:05:58 +0000 (UTC)
X-FDA: 84496760796.12.0714674
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9808D10000A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 08:05:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mpn0wyOB;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772352356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKexEmoXctG9tm+xRNz3yCPi9khsmdiDGG7Pq28q/As=;
	b=yi8vmCVuPcu4j/5Zbg/R57CIXUn2rg6Ajz3Hi4AWO7dX8cW8mRxySo2+EpmmL/oVl5wXj1
	rQuDoSeUR8ktuQdmZvRTlLVw5k3IzHvUw1S0UKypXywppuUY8CSUi/M2ybdkOiG9+iWPNj
	6EpBuT3XPtU42qAUQvMO28Urpei1F7E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mpn0wyOB;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772352356; a=rsa-sha256;
	cv=none;
	b=IV30v9ceH+dus6hcspaSAEcOPrdIGbF7GncKUcUAgy8XqP6pxYQ82lLzscCInUpo9ekG/+
	i0GJQEylxnck91kc/7R65IdciyqXv5vwSdghikmPzxeo9oSsbPgnRZnf8Ocs7iAShDu/Z5
	1lkLkX1cFClUR+9mMoM9tPu6WS9w0bc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772352356; x=1803888356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3BZxcqBCNY7RTl2XSzcbbBHM11/xYWsKqBTf6uf+rbo=;
  b=mpn0wyOBVBLgwvnG9QGC/pva2IdBBbQa2ZszGYtb3AZbdblLscUwRBu8
   yt5cfE7x8oqrqaYWY32WhZiyaa0C1Z0gxYO485++WylCxeQ+fLSBtGPTN
   iLw6SY9MOzuo7VCE3vIj74cN+5ZXJJXYTkEAAt1ngT112U9TBJsSMCmTc
   b4lCr1rxrcV/7nJ3llkeP8f61t8+RpPs5U+MenFO+S3/oghX3d/k7Nuct
   tTh+Wv8KNbb1XiEEk1JpMblv92v9wRmvM1rqcBEBIjZgiV/mVf8ivFA1E
   zy2IfMue6bTCnz8J4OHvcpJq2oQJWN84OKc8jBhvqaDtSvIv5ONhEOV/w
   w==;
X-CSE-ConnectionGUID: 6aR4x8OYQvyrxLkUaOOPsA==
X-CSE-MsgGUID: Zod/wzZkTXWooifQPBOKjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11715"; a="72413917"
X-IronPort-AV: E=Sophos;i="6.21,317,1763452800"; 
   d="scan'208";a="72413917"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2026 00:05:52 -0800
X-CSE-ConnectionGUID: 2VXKz50yT8qBRNpS9UgkyQ==
X-CSE-MsgGUID: 0OoPDmusSqyB46Zw765MYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,317,1763452800"; 
   d="scan'208";a="216462200"
Received: from lkp-server01.sh.intel.com (HELO 59784f1c7b2a) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 01 Mar 2026 00:05:49 -0800
Received: from kbuild by 59784f1c7b2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwboA-000000001Kr-3k0N;
	Sun, 01 Mar 2026 08:05:46 +0000
Date: Sun, 1 Mar 2026 16:04:49 +0800
From: kernel test robot <lkp@intel.com>
To: Matteo Croce <technoboy85@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] KUnit: memcpy: add benchmark
Message-ID: <202603011649.A4pBbqqJ-lkp@intel.com>
References: <20260301011209.4160-1-teknoraver@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260301011209.4160-1-teknoraver@meta.com>
X-Rspamd-Queue-Id: 9808D10000A
X-Stat-Signature: xotkr1gcutpqfa6pwzft45jzzaz1u198
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772352355-441049
X-HE-Meta: U2FsdGVkX180uIHWRb1lT55I871NPIp1Dj008juMJbveQ5Gu9ji2B61w9B91mfb7lPj5SN0Y+k2z+0bSf9GIK3ptKTaYkHQ5HrFYHBN13OxU85a3gTh48cq0CLxz6HSSbmbgm0WL/0DoWK3g2RWqIs5bxqh4cf1BpRhozXgeKXFjI+ckZ0ItqnIeUhLgDM0YIXDUnS5IaK7HpN+XC29DlW9iYw42VQGPlG6qwh+KjJ8l5MdeT4YVqyi7/70iqrougF1CTooiUPNzJFLbMW1dP0o7gzLxSqGEiKOGfR8X2VWxQJKUA76eMUQ7dSOsqrcpKuxFyxCoPRC6HqxdUrI3jKTcelSkOu1H5AheRV1kEIBAVq82MsvTCwr9tRagGyzWAJVAENNAzPSLXeQycsrUks6u9WNRR2eNz3tkqNYjZc/DCnQ3JXZPbPPsWyBz3/v86hMK0PkASjEbX8GnsifeDtduBwG1oha6bLG5qz9FxnOmJmLyIvdIjILiK4yq8KPoR+wPhQz5b2ZOycbOtc9asnfaU52SyMSqRmkQxYSeRFhgXPg/uIl2FjECRhCgDwO/PqRWiwwj9gQmgyQ4Jh7104IyWyRrgmBmfmsU23//XklZuWqjvYfLEtyOZTPmGw65U9iMhSjxQ8Vbh5GCeN90UZXDQWFsqMR8zit9ptZOsjREgN8zQ7ycEQ5XLQArbgHhTu/HyFTFDxxle/K5UzOhfPQBl6q1FuT8roGkaIoFPzXeNKND458DLvuOWFjmgpIFSKHewi93oh91KAOEZMz+e2vp55AMccxQ9lUj0UBUMTb8ELApxwwh0Iiz/90TxSiNr4Iqwa8KNf3L8ZVlseqeKabkAAYM/JtwR7FOWwWg1r3ViGWbPs6DiP/MIdhfgZaIzH8nGwy2poa2IuwY2qi2WiiS20//J17trPehNn/+t2pokNPHYRiJQKWE9T6CMSxwaS6OTDbrygNIQ7NeDDp
 dQS45yy/
 NfYuD8z/rAZ8+d/OPJVIEvPCySjcvNk2Gm1iGBtrCMWkjaXk/vlDge/w8IeiD17YELtCi3vTKJARmZCDN/re8RzHyqzeWj9FPidJd5cUnFIcSCBSCzR/xx9Dzng2eBL4XUVwzenSGdku3DU4kY4Cm2h6JZ8Wyesif2ZiD8Do6kSewyWDlcJ+ssGsFBcorkObkxj4UTZ0bBcsdI6HYKR08SAY6E35q6e4t0/l7pE5HMOqnJ1v8wqfRDhDKazy9Iapr0s7JwnHoOGzS+kPBm6LJ8ngGDrkVEfLPIhYYEA6dqvGwmP39SUPnAslNMTlLzHgubSBbwm9dpuYFiPWAAe/YCTFNmDTyUDiHt6v+wMS5K1iQtc6Ywbt+toddX+JyFnMe5rx3gK6IpNvbC7DIT1asJeQHEvax1t+uCTDyhISU7K3eI5zoAvk69IhzU/78jNdixAPk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matteo,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on akpm-mm/mm-everything linus/master v7.0-rc1 next-20260227]
[cannot apply to kees/for-next/hardening]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Matteo-Croce/KUnit-memcpy-add-benchmark/20260301-091336
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260301011209.4160-1-teknoraver%40meta.com
patch subject: [PATCH v5] KUnit: memcpy: add benchmark
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20260301/202603011649.A4pBbqqJ-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260301/202603011649.A4pBbqqJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603011649.A4pBbqqJ-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__hexagon_udivdi3" [lib/tests/memcpy_kunit.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

