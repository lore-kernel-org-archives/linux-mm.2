Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533A0E7FDF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 22:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285AF6B0005; Mon,  2 Feb 2026 17:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233836B0088; Mon,  2 Feb 2026 17:42:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F466B0089; Mon,  2 Feb 2026 17:42:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0186E6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:42:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8103857DAD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:42:33 +0000 (UTC)
X-FDA: 84400992186.04.2596CE7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id DFD79180004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:42:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iId8sGpc;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770072151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cqluN3IeGiKz19EWdx5yzxUwOQbuVaFyDwRFN3XnmtM=;
	b=lPEcNJQa+HqEwN3Bmi8n5DKOmh/y7Y2i64pMYJTvaVruU6IrNYcgYY1/mMC30Lln+sXF3D
	AsFe9v93IUqH4u1jpxZmltBb2gTeB0R5sgulO4Few0Z2YBXbxiRa+9vDEyGG1KIL33tqVJ
	v755QONhWY8ODdLqh9TXsArnwdWItAw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iId8sGpc;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770072151; a=rsa-sha256;
	cv=none;
	b=ER7V1sJ4xYnGUGSzru7Mtzlo2xZlb25msGZ1C+1XzYKctG842mox3zhhV+iLWQxyxYGLF4
	URJduJ7BSxi75FU/US+ootvKvyw4vtT6rTo3QDBor58Cdh83aA5Ml35z793H43HhjSlShH
	3a/FEZ3tTTW3dwSNhaL8rWziHA5CSHc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770072151; x=1801608151;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dJqBhnCjv+ARNxGhcymEd/bUx+NAcoEk6SIjpgJXcgs=;
  b=iId8sGpc5Op8QVj2I+/CU/skncxSRHjPZ269Hl7p1dwFE9UhWXK6+pSG
   N+Lv1IOmV2U7HH3ZTqcmb6bE1MwmrzFaCvnpK5fb8pbukqYAqgrJfVnH1
   2nVvp7ZijT/muBuSfPOAViYa5+EpM6A3mAtZ1cxPMu5iGCjpI3JkFE00o
   hnEsYrTJf3Ll1b5jnedvqLfLlqcjLNqipJMJu/cSLWeJWGphREH32MaTv
   NBplmITi/mbTR1KUkLwUINcXrtrPJLZQ4tWnfHdCof8FgA2mUYxhnyeNv
   sOB+1LMsqsf5dZSZ7z1+8cvlzyPv1nzxsN5czOiQQdqeNlbdtk2vAyEFq
   A==;
X-CSE-ConnectionGUID: PXDilvBYQey8SRQbDh9sAA==
X-CSE-MsgGUID: fSK93hR0SoCqs21V2vDHew==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71146541"
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="71146541"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 14:42:30 -0800
X-CSE-ConnectionGUID: JhZZAtqiSYqHdWP/GEBTXw==
X-CSE-MsgGUID: fyKoC9HGSS6KG6Ysdwb7mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="214175101"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 02 Feb 2026 14:42:28 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vn2cj-00000000g1k-2F2s;
	Mon, 02 Feb 2026 22:42:25 +0000
Date: Tue, 3 Feb 2026 06:42:05 +0800
From: kernel test robot <lkp@intel.com>
To: Ryota Sakamoto <sakamo.ryota@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Ryota Sakamoto <sakamo.ryota@gmail.com>
Subject: Re: [PATCH] lib/tests: add KUnit test for argv_split()
Message-ID: <202602030650.7n64kb2g-lkp@intel.com>
References: <20260203-kunit-argv_split-v1-1-0d3545314a41@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203-kunit-argv_split-v1-1-0d3545314a41@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DFD79180004
X-Stat-Signature: cgy5fmgemiwnnsb46woxwsecth4js79k
X-Rspam-User: 
X-HE-Tag: 1770072150-995809
X-HE-Meta: U2FsdGVkX19xdVdvjt+Fmk+uFfCKA9cb8ZwRu5MfHYI9TBZc86wPY8V5aDABhWa5DXx4MyIWXSwd8JaOASGcI4X+h1GewW1H6ffRHL+/aSU51sLvREBjf0YEkK3ckLR9ZhS9xh9xWRdkf53gUflEUa0PiO+74e4zSk1wP7NqWL/9Tk/P6ZFLUan6HYW3NSLr9eSBGu29YwL/QOA1e5qMGvii3eGlYn97v4IR3Wr/2gHsnYWcrQQK0CwuDjzZ2YTKSpy7SlCLEV+OoRIM81vMjAZD8cSkge0MpQypZGiPWID8fdWbJl1Wk4XZYGQImY0sn5WUOEGQUBVL74kdEGRorj74zInJy4CCAV0EaCNr4+j2kQljiIlr2NTb+9QePCeNP4qqOIydU0OAFnbqmKMvRFDypSP0dK6oNdq9Lu87Uw6WV8oNgDvgAJ0p7QG+muXazK0K/iFgoKh8k/AkdAuqHqbTpuLzK2/mMG9Tc0oRqFLxNNsJZAbO1kRbcL51/7p/bQEs/5k7xRp5eL+u8w74hcL9EqEn0mensDIQGsR7fo2R6oh6+TLUeMAvRtfmTbQtjjLBtMa/hEiItkwSlQXHqtDtjZNvverRBjN8aJV+zak/WYYmmaTkURxDMVv6keOBwIa+rwbHZddIFIWMpIFIvjh0SSGrSQvnt0VtNfjA0FVOqjIOrr5RLJqTUe4rqq/Yc3ntXeq8CGS8AdRKnLWXtSFvaXZYiqTCbD78P4khsSmkCXzdXZfpIPfup5eXHOGkhf/yc/a/LveyOqSnbebUhV7TqPkc4PiaSvIr1nQ4zZKwPcOjHxUDuo8MfMVJQCU3klBEojSJyU98Opns0Bwrsm01sROTZ5TlpZLtZbB5LDmdj3sXdiB/yJFPys0psQKbMy5MUsy927RoSSndGCKcNoGEjMYVb1lTAqZ2yslxlObgcGPtLym98b4Ue45d02f96Rnbtf1pBij5yhFfjui
 dLZQWKfK
 8BaZxbFgUDlq0DdiRAv7jxkt25xQKubq/MW9J+e+t3pLOcyE7/e68NHcPdmTobTFPOy3tsUp7+oA0tymZMimKYeXKmdP7mFAHcvfp8UGQVf+fQhs9pcKO61W8HyEp+BWwSQDRWubZ2+F2Em4WDcyuU0we8N/goJt8+bouSvLuIiK7hMKmDBBK42oNFswNEl36TH4LjMJnwqwVvtLk7Vor/KQpjSXgEsH/Z/borsEihdqbwPU7G9YoPA/CxyQmqL95ux7p/zTu7q97PoXa4AAALj6fkHPMTfyK0D+/iGwGSLC1CXZo8J0UaNdOKSEaLzoibr4DqUgrStRnWAjF33naGfcYAfzy0wYGpt7Fu9+JwnB2zPZVnKG/dcV8XVA8aNNh2ylWGadPMK1N0WLLQni+P2DYfYVhDY640U7+ZNTv8u+Z4wG/x+HZQ5tKTgxc4+3bfVKEezzK9ncB8wIXQCsJu9u9pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryota,

kernel test robot noticed the following build errors:

[auto build test ERROR on 18f7fcd5e69a04df57b563360b88be72471d6b62]

url:    https://github.com/intel-lab-lkp/linux/commits/Ryota-Sakamoto/lib-tests-add-KUnit-test-for-argv_split/20260203-004209
base:   18f7fcd5e69a04df57b563360b88be72471d6b62
patch link:    https://lore.kernel.org/r/20260203-kunit-argv_split-v1-1-0d3545314a41%40gmail.com
patch subject: [PATCH] lib/tests: add KUnit test for argv_split()
config: sparc-randconfig-001-20260203 (https://download.01.org/0day-ci/archive/20260203/202602030650.7n64kb2g-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260203/202602030650.7n64kb2g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602030650.7n64kb2g-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> lib/tests/argv_split_kunit.c:55:3: warning: braces around scalar initializer
      .argv = {},
      ^
   lib/tests/argv_split_kunit.c:55:3: note: (near initialization for 'argv_split_cases[5].argv')
>> lib/tests/argv_split_kunit.c:55:11: error: empty scalar initializer
      .argv = {},
              ^
   lib/tests/argv_split_kunit.c:55:11: note: (near initialization for 'argv_split_cases[5].argv')


vim +55 lib/tests/argv_split_kunit.c

    19	
    20	static struct argv_split_test_case argv_split_cases[] = {
    21		{
    22			.str = "basic words",
    23			.input = "foo bar",
    24			.argc = 2,
    25			.argv = (const char *[]){ "foo", "bar" },
    26		},
    27		{
    28			.str = "single word",
    29			.input = "foobar",
    30			.argc = 1,
    31			.argv = (const char *[]){ "foobar" },
    32		},
    33		{
    34			.str = "leading/trailing whitespace",
    35			.input = "   hello  world ",
    36			.argc = 2,
    37			.argv = (const char *[]){ "hello", "world" },
    38		},
    39		{
    40			.str = "mixing space",
    41			.input = " \t foo \n bar   baz",
    42			.argc = 3,
    43			.argv = (const char *[]){ "foo", "bar", "baz" },
    44		},
    45		{
    46			.str = "quotes are treated as literals",
    47			.input = "ls \"my file/\"",
    48			.argc = 3,
    49			.argv = (const char *[]){ "ls", "\"my", "file/\"" },
    50		},
    51		{
    52			.str = "empty",
    53			.input = "",
    54			.argc = 0,
  > 55			.argv = {},
    56		},
    57	};
    58	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

