Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B032CFC510
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 00:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6796B0026; Fri, 21 Nov 2025 19:05:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70AE6B002C; Fri, 21 Nov 2025 19:05:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37EC6B002D; Fri, 21 Nov 2025 19:05:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECF56B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:05:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D482B16058D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:05:08 +0000 (UTC)
X-FDA: 84136297896.02.901D094
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C76D4000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:05:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lo+1hFAx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763769906; a=rsa-sha256;
	cv=none;
	b=g0XdmeIPCfWu0gWeKrLQik+vHdahSDLtjiOcipn9OtHukcT8E3UD1fpdS/9Z76auJ+Oxac
	1p2cDXzZKjWwcLLCFxO8XhAVJ6qYnPffleykP/BxIvVyYpsihsuea94jybeoMrKXW/Muq6
	2eHWfvf4VAH1AhJTrfNUgltyIyNOwnk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lo+1hFAx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763769906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnTxzMXAj4C+H3rJQAtbVjm3gxEOt7ieVLNhLtxygHk=;
	b=chJAT5cYSxbN5RQYZgMOVG9+DhcxIhi9+IA9meTz8GcyYz4nXMdE+MS9qU1LqTs95tmg86
	w6bN7GmgN6esa3bCrnGgSdG6UJPsPPjgNKFXs7mTno39sW226MSv9vp/xup9+zQSm0dUk1
	NOVqnkQJGQnm0PuoX27zacbXtLWcnAQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763769906; x=1795305906;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lKk63OBIxTgAZL2BQA9bHbccK1TAmQ6Nota8WFvpBkg=;
  b=lo+1hFAxH06+sytQZxKbwsDz0D4+BSsgFqQn+9GNccChG+4jv4Mn5OHt
   fK/gvRxyVI13LnIYqns1QtNh87sxMgAj3pfoQHY6JMRP8QQVEuiy7hb0P
   05ZCLzPmyYifqbRErYklia0iA4h5QCek86ussYMTzmrKDwBQ4kgBNiyBF
   +ZbUF+0Ldp70eI9mPN57stORcg1exZ+xWSjZnxHPRI9tXkVy3exhF5yJV
   Mp72Yv03CgCCjJWcug/Yi+SJylt1vYGLEoqb7U5tm6T5JIXpDrIGGC2kW
   TRp+QsrlFIk6I3ZS2EzUf1TbAjec22yRtgbtnefe8BNUsnjmWhfFWEUeD
   A==;
X-CSE-ConnectionGUID: pus5V8RQT8mfZpIBYvIMog==
X-CSE-MsgGUID: 6+JDVoUMSwGDql+/oDE2RQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="76980193"
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="76980193"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 16:05:04 -0800
X-CSE-ConnectionGUID: 0m1MqlNQSeC7xJO5WxDOzw==
X-CSE-MsgGUID: PhKw3WinTWa2mGSgArHQNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="196760418"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 21 Nov 2025 16:04:59 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMb7Y-0006zb-2u;
	Sat, 22 Nov 2025 00:04:56 +0000
Date: Sat, 22 Nov 2025 08:04:02 +0800
From: kernel test robot <lkp@intel.com>
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	tglx@linutronix.de, andersson@kernel.org, pmladek@suse.com,
	rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
	mhocko@suse.com
Cc: oe-kbuild-all@lists.linux.dev, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: Re: [PATCH 01/26] kernel: Introduce meminspect
Message-ID: <202511220712.LEcYEMJx-lkp@intel.com>
References: <20251119154427.1033475-2-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-2-eugen.hristev@linaro.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C76D4000C
X-Stat-Signature: bseaybtsfftti17xtb87tej8trmefqzw
X-HE-Tag: 1763769905-146410
X-HE-Meta: U2FsdGVkX1+zXu7YNwNkC3+yIZjNqHBApxU949yHfbz8BRuTNTbRjBchUx+S8tkPumbIIWiMyHjf2ccbM/yg3l6aDZ7X5WkGuLfVY0aAeffGfXYAvKnIMnKIrATcQPlskK6AWByky3f5WPal+JYbhINirA1arZJbx+zncWXwRH3kwTLHO451BA6leURB2RtchfnFiE21aDGm06Vo2tBAFg3DXhhZOYoVzIIXLkBUcGNMezoKrM00ZpU2dgIgpwAkRAyE3DmRroO2jBtdBipKCKMVQww/+U8gDOrahmb05UjJonHjMQZe6r20Asemsjz2U5PFgPbVpcGOU9xujd/7MpPwYjNhpbE7KIrW9SATEXCCE/biO/4EoVVBw0lcUg+U1PyibnySqClFMmukubyDPV4Fk8R3HZ7kyQj1zygVZBXvyf+FP+1Imqik5pckzaR2CI24mVRI42l9kIN3ucMEkd0PPX3NbGHavWB47RZBgUh26S3H3AjnWo1vTeK3/UQeVB7OFMMyjAr/6by1hZB7YFoyz7ThBiPyUM3NXq1lUa9y5SgqH8MlmIg7p0xyI2sV6oTocVUzOxIaAl39hr/IJmpWxBcnSjkSywitbhv4UCkfTT6P40eePukjPEnxPETGc5w8xgS7S3wEutuUxkYc4s7jnyQZlqn2yAfM3nxv0CF6Vb4zHtNhfaoccxrNgmqICXCIbFQyDmytOQFxAb2LS6nWEHo6Oew5KYvK55GEpdz3L6xHV7KVKGHFUO0S8+1JuIfV9V+Pz/xNAXpbirhFKr5+/qOZTuXSmVgF0Q/0UG98z5SJAmu0SgTf1Jx52+ywQt2AYS2BCkH/RSH+eOB81F2iyHOGJ2mCnR1HVufZRfEQZGANVTnB4icVV8GD0ABkLmHWxJg7482auIUWUEDrhjGdQdfYR84KUXzMIJ8Nq4KydHFMGI4Avtu7zrj3gydIkUR3qsqRW5xyb2Dee3I
 q6cX5H7y
 732as1EMQ7XH9UIbL5KcAn3IUrZapwgtaUy90YMh8DZ5dIYgfX1h2Bn3SoTMXOWe6ugVBvbLZV4ifRhpDIGqHVKu/O6KFOBPPsNWioZprpIiTHMmEsuxF6Tj1z+D+xvMlCa1nCMDF5q3xkUihkghIZ8CPAHuUQGIBT3/O436OPG95I6JFtlF2tpmRZDO7JZDmaNvUm/cT360nZlIkvl+gLdEUYFRLPE0SXTYhqZD0qXoBept3N4xYbBEQhHPH17+BsUOJ9Wg8yo4UKc4Mb1tYPekKa7U3vo/Oz9OwuGDfGNuD4wo/haTQ8zOT9jCUxw4G4hlwcNUJtnuhNyOhCA80UR8FENVffKDtGfW3qS5xMhD75RfuWIKOQ4VaYao7NpVSNF23CIjD7CFlr3TkPzugdMmCTlhi48jjkSQonIOG8ML21hD4dNDWLWnQyKAx6uAADBxJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eugen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on rppt-memblock/fixes]
[also build test WARNING on linus/master v6.18-rc6]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next next-20251121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eugen-Hristev/kernel-Introduce-meminspect/20251119-235912
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
patch link:    https://lore.kernel.org/r/20251119154427.1033475-2-eugen.hristev%40linaro.org
patch subject: [PATCH 01/26] kernel: Introduce meminspect
config: nios2-randconfig-r131-20251122 (https://download.01.org/0day-ci/archive/20251122/202511220712.LEcYEMJx-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251122/202511220712.LEcYEMJx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511220712.LEcYEMJx-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/meminspect/meminspect.c:15:1: sparse: sparse: symbol 'meminspect_notifier_list' was not declared. Should it be static?

vim +/meminspect_notifier_list +15 kernel/meminspect/meminspect.c

    14	
  > 15	ATOMIC_NOTIFIER_HEAD(meminspect_notifier_list);
    16	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

