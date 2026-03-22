Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D70ABFC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 13:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68E66B00A8; Sun, 22 Mar 2026 09:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E199F6B00C5; Sun, 22 Mar 2026 09:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08786B00C6; Sun, 22 Mar 2026 09:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF96A6B00A8
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:25:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5295E16080C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:25:56 +0000 (UTC)
X-FDA: 84573771912.22.C3F6FD0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1D6B3100003
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:25:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kjYHtUxK;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774185954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gI0SKm1TPYXBLTTMcCel/kqZyB3DJyHz/MMlXWO5WB4=;
	b=LEBPV1m1qi6F/pyaVaiv2dKR8f1JCboF4CFvkZ0s7g5+M8j0Vdu0VxIE53Ps5mjHcBXFMm
	bsPwvPC0atfxTmqtiQvNJDYel/2NixCT+PKh1mQhz7/QytWbwv53ErofKsSCaW1dFPdcjz
	1hC8EDFyKrgb7T4q/cptoOioyTc/1a8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774185954; a=rsa-sha256;
	cv=none;
	b=3tRtkQLaWbcicjXVxXlB+Nys0VO5l3y3wQQYdJjKIPoU5Zl9mTBqlANuvDAmIWiPQrxbiE
	/flVrJfn38J0QFxaJZop4lTW7AA3uUcWotZiHsn4aaJ6+fC5uvnXKZ85/9eHdN4gSeDWO5
	1mUZ+katTm+RMFrLjre3L+I89VzUfi4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kjYHtUxK;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774185955; x=1805721955;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tXmbjanna8jwNI1OUqxIulxJ1F9340+85/yv+vfrl2w=;
  b=kjYHtUxKxMPF8XNiW2zjozSxWgfGj0X6kkrMMWCvmguAnn1AdDiqiOqG
   Wb8TSzBui6kCy0wL9lox8JJYS4svbhYe4iHIahABKJNfDRuubekEtyaAq
   vCDzq0v09iw2PfAebMG/i72bzC75g0FjdEmHVcoeWxmtA11XmN6T8uGBY
   tC83s2cmfuXi1usFdS2RtYfA9g0FdxG709vIiPHkAQ0P6+C7nMzBGXZp/
   e+y9VSe2jPUbMqOVjXlYisFKGwsxEhLj5ob3LsinUH/4cQBBaKYZO7zIY
   otP6XRyvdrh3CN9Vj5We4xVzQWVNAhERzSY0/8xrmyV3xDe04BgSMBsV3
   g==;
X-CSE-ConnectionGUID: fY8z7RTqRfKfheyy1ozQiA==
X-CSE-MsgGUID: XqJ1gvKxTJar1pP3sZyUvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11737"; a="75088381"
X-IronPort-AV: E=Sophos;i="6.23,135,1770624000"; 
   d="scan'208";a="75088381"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2026 06:25:53 -0700
X-CSE-ConnectionGUID: f30IYCVEQfuVxUMCuiJpfg==
X-CSE-MsgGUID: 3N59DuJCQ+eUTTnvUhPUsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,135,1770624000"; 
   d="scan'208";a="246798722"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 22 Mar 2026 06:25:48 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w4IoM-000000006Mr-2Eas;
	Sun, 22 Mar 2026 13:25:46 +0000
Date: Sun, 22 Mar 2026 14:25:40 +0100
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: Change gfp_t to unsigned long
Message-ID: <202603221419.9kAfrwc5-lkp@intel.com>
References: <20260319-gfp64-v1-5-2c73b8d42b7f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319-gfp64-v1-5-2c73b8d42b7f@google.com>
X-Stat-Signature: k8zqtucgiuifnmc4jwxhk4csr6anm16o
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D6B3100003
X-Rspamd-Server: rspam12
X-HE-Tag: 1774185953-444904
X-HE-Meta: U2FsdGVkX1+4TxJ9yuVFnQk+0wQFp+OvArQ+J3bdYf4PR1vv/ojRmq/wfEOe/vXKihnOlPujpXyPwHU8cwdGQ/KUX1MjUW8KKQANcfyK/cIZd1KVj5VfK/uB7bHk5hT7Orf9b9OjxviPsJ4/2gsN52pcKLFvm95q27yE0xBcFk/SstrGTDGGFOwr9QIBnU8NTji/9r0POMw42ppdFHKU4maOGaquknMS99WE6cjsI8UqlcjX6tZv3uX+ADA40bLrBdbmovQJyVG98lzhbQwnkRKn+u0oc6x2vZC2WE1xvIV+8IaXu/ohU+masbMDopSolxT4id93mLNSSusS50uZfTR0Wu4XavCExNo23fjLyxaYOAkbgYObHB2IIdNxR4QzcdVl0s9OXSaDcg04wH/rWQOwAxR1FgsvyKOqPRcnS3+phb9QJvUl6pBqiIToFG0DEJ1rNyfBLaGxobR1zr3lbGVxUXj13Hi6bWCB2MJhdvZJTFcG1R7w8lwxiQHIdwF1C+GeL+hVao5EUnTiPJbj/yfv8k8Q1WiBJADhlW54MMb15Jw1Jr9N+aRJ2su8RX0gGVyoNwylA8cSycWf2P2X3D6Fm7MmxHCIOEOw1S9nzLGDPsxbAgr2eHr6G7qfuoe6h90HhRS8HMGUQ8aYSF5rhXSp7fzeTIrdtXLm6EmJIfYx+gEMKt/RsIDMllnk9Rzj4qhOijdj1DemYGYQLhM73j7PHfVu2yVSf1oGmbDRhGI9uJ+759KNPvxGV9yKKcZzvXDJ9fGknBGd1U7aeSMsWHfbVM9Bl92w9j7qtfa6uSntYQF2iDJxz3R/+p0O/Y7WmsL0MyCWwF+6bRXfKWSssHDnqZXAt8xPTNufniNcBxxCqjxsrL8Hav+Lh6dtwQS0cp7r1FuwqZb4sX3/9ttgzUDDxEt9sAWbK+CG+nDQNxklTzg8Ldguth6SucxKTwqmsXQEg7U+YmFN69ZNw7z
 OWX8+o0I
 u7X8zCP3vCnBSFHaR70EDoTcyVhGgluFNKeIyEYlvf2lDtsyySqMKH8O3EEnMZ+BzxKq8S/anm6lufV9eE+CqDpEgvxO8mezjkSIWk/3ns08mAcPK2lhMQFxw5JemlpYG3KruHJePOH5BAbnr56kR6W4LnI3pB2gXbAzKQ1DiccjUZmAm4m02s0d3RFrioZ12x08LtSBIRgolSkapqrVIoQJ5Mm/t/HGpX0mA1Q4ytaEZFhfJIZ/cOL6MHGkQjR+bxEu9lr5HG53Ol57u303wCZwMPNzhLuYt8Ky+Ft6fm7Z0+ryNpZ6rDGPQmTDPyureaBPRPJigfKdwbzXECPhGVTWZO/tVCjMDyavyIGcK6Ffy9XY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

kernel test robot noticed the following build errors:

[auto build test ERROR on 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/drm-managed-Use-special-gfp_t-format-specifier/20260322-145930
base:   8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
patch link:    https://lore.kernel.org/r/20260319-gfp64-v1-5-2c73b8d42b7f%40google.com
patch subject: [PATCH 5/5] mm: Change gfp_t to unsigned long
config: x86_64-rhel-9.4-kunit (https://download.01.org/0day-ci/archive/20260322/202603221419.9kAfrwc5-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260322/202603221419.9kAfrwc5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603221419.9kAfrwc5-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/module.h:23,
                    from lib/test_lockup.c:8:
>> lib/test_lockup.c:133:47: error: expected ';' before 'long'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         |                                               ^~~~
   include/linux/moduleparam.h:175:23: note: in definition of macro 'module_param_named_unsafe'
     175 |         param_check_##type(name, &(value));                             \
         |                       ^~~~
   lib/test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
>> include/linux/moduleparam.h:175:32: error: expected ')' before ',' token
     175 |         param_check_##type(name, &(value));                             \
         |                                ^
   include/linux/moduleparam.h:149:9: note: in expansion of macro 'module_param_named_unsafe'
     149 |         module_param_named_unsafe(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   lib/test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
>> include/linux/moduleparam.h:176:39: error: 'param_ops_unsigned' undeclared here (not in a function); did you mean 'param_ops_uint'?
     176 |         module_param_cb_unsafe(name, &param_ops_##type, &value, perm);  \
         |                                       ^~~~~~~~~~
   include/linux/moduleparam.h:305:46: note: in definition of macro '__module_param_call'
     305 |         = { __param_str_##name, THIS_MODULE, ops,                       \
         |                                              ^~~
   include/linux/moduleparam.h:176:9: note: in expansion of macro 'module_param_cb_unsafe'
     176 |         module_param_cb_unsafe(name, &param_ops_##type, &value, perm);  \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:149:9: note: in expansion of macro 'module_param_named_unsafe'
     149 |         module_param_named_unsafe(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   lib/test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
   lib/test_lockup.c:133:47: error: expected '}' before 'long'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         |                                               ^~~~
   include/linux/moduleparam.h:305:46: note: in definition of macro '__module_param_call'
     305 |         = { __param_str_##name, THIS_MODULE, ops,                       \
         |                                              ^~~
   include/linux/moduleparam.h:176:9: note: in expansion of macro 'module_param_cb_unsafe'
     176 |         module_param_cb_unsafe(name, &param_ops_##type, &value, perm);  \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:149:9: note: in expansion of macro 'module_param_named_unsafe'
     149 |         module_param_named_unsafe(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   lib/test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:305:11: note: to match this '{'
     305 |         = { __param_str_##name, THIS_MODULE, ops,                       \
         |           ^
   include/linux/moduleparam.h:192:9: note: in expansion of macro '__module_param_call'
     192 |         __module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1,    \
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:176:9: note: in expansion of macro 'module_param_cb_unsafe'
     176 |         module_param_cb_unsafe(name, &param_ops_##type, &value, perm);  \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:149:9: note: in expansion of macro 'module_param_named_unsafe'
     149 |         module_param_named_unsafe(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   lib/test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/module.h:23,
                    from test_lockup.c:8:
   test_lockup.c:133:47: error: expected ';' before 'long'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         |                                               ^~~~
   include/linux/moduleparam.h:175:23: note: in definition of macro 'module_param_named_unsafe'
     175 |         param_check_##type(name, &(value));                             \
         |                       ^~~~
   test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
>> include/linux/moduleparam.h:175:32: error: expected ')' before ',' token
     175 |         param_check_##type(name, &(value));                             \
         |                                ^
   include/linux/moduleparam.h:149:9: note: in expansion of macro 'module_param_named_unsafe'
     149 |         module_param_named_unsafe(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
>> include/linux/moduleparam.h:176:39: error: 'param_ops_unsigned' undeclared here (not in a function); did you mean 'param_ops_uint'?
     176 |         module_param_cb_unsafe(name, &param_ops_##type, &value, perm);  \
         |                                       ^~~~~~~~~~
   include/linux/moduleparam.h:305:46: note: in definition of macro '__module_param_call'
     305 |         = { __param_str_##name, THIS_MODULE, ops,                       \
         |                                              ^~~
   include/linux/moduleparam.h:176:9: note: in expansion of macro 'module_param_cb_unsafe'
     176 |         module_param_cb_unsafe(name, &param_ops_##type, &value, perm);  \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:149:9: note: in expansion of macro 'module_param_named_unsafe'
     149 |         module_param_named_unsafe(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
   test_lockup.c:133:47: error: expected '}' before 'long'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         |                                               ^~~~
   include/linux/moduleparam.h:305:46: note: in definition of macro '__module_param_call'
     305 |         = { __param_str_##name, THIS_MODULE, ops,                       \
         |                                              ^~~
   include/linux/moduleparam.h:176:9: note: in expansion of macro 'module_param_cb_unsafe'
     176 |         module_param_cb_unsafe(name, &param_ops_##type, &value, perm);  \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:149:9: note: in expansion of macro 'module_param_named_unsafe'
     149 |         module_param_named_unsafe(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:305:11: note: to match this '{'
     305 |         = { __param_str_##name, THIS_MODULE, ops,                       \
         |           ^
   include/linux/moduleparam.h:192:9: note: in expansion of macro '__module_param_call'
     192 |         __module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1,    \
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:176:9: note: in expansion of macro 'module_param_cb_unsafe'
     176 |         module_param_cb_unsafe(name, &param_ops_##type, &value, perm);  \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/moduleparam.h:149:9: note: in expansion of macro 'module_param_named_unsafe'
     149 |         module_param_named_unsafe(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   test_lockup.c:133:1: note: in expansion of macro 'module_param_unsafe'
     133 | module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
         | ^~~~~~~~~~~~~~~~~~~


vim +133 lib/test_lockup.c

   131	
   132	static gfp_t alloc_pages_gfp = GFP_KERNEL;
 > 133	module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
   134	MODULE_PARM_DESC(alloc_pages_gfp, "allocate pages with this gfp_mask, default GFP_KERNEL");
   135	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

