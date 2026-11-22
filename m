Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD03606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 22:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=g+7KT+cq
Received: by kanga.kvack.org (Postfix)
	id 193A46B05B0; Sun, 22 Nov 2026 17:21:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B236B05B1; Sun, 22 Nov 2026 17:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A126B05B2; Sun, 22 Nov 2026 17:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCA706B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:21:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27E17A07BC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:21:01 +0000 (UTC)
X-FDA: 85464176322.21.33376C6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id 676B040007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:20:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g+7KT+cq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795386059;
	b=AUOhRsuQkObzEeoFGElDjZGi1vLt9aufrceD/3un0Ei232yb+M4tKbt0rG9kDgjdQpQ0aX
	EavfeAU0HX/kGmE664T8fs3rt/eKg7QvmI/qqBk/U4FdJ5R5bYudcF/dmcoPjsYZYmLFIE
	OKMJQGSyQp7SDmtOOzMXAAs8U8hnjKA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795386059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6PsEO40SXnidvY6m77b8qIgVTuYI1RooLAz613fO6Q=;
	b=yXzO4GKrMSSKWwCeuW2PQrud2XMJwnZ2y1kxVNNbUQN/nae+dBXSIrvKnABjw4WXWhrzIf
	4Lb0BTES8r+iPgWVuEi67NSuMwLNqorp3SxfEvcrmybP09X6+gdtxe8ZSHGbUizQcyDYjC
	q4IRv54qLgJh/ARCAc0r6axwRDkI1so=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g+7KT+cq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795386059; x=1826922059;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lc/6luGnTfiYQ5L6WAjEeu9PRcuwZl5d6rQ3ClQHdbc=;
  b=g+7KT+cqARaVakhDsmToBsFW3VNR62nd2+qKvbo3212kQ6/DGYM2vLCl
   LgNlkzHUbU3M7MxV6Xklnly+IQxsFHQO0+VaIXxwmeDxuSxq0JeB3PR+y
   u2gzS+mQnW12b7A/TH0a52iZ0/HFP/+0xKQyg1nn+lOHxa3Kk5k4vv5ee
   MiPEu+2mFCC6jjBvQ21oz2OMT8Milb3WbdTxcaFVUMH2ET5NUt2NxUHXY
   Q71Qikl88TIQh/HMTn1gPsAljfKaNuLKLp4Gc5DH83Hsk1qfMZeHXi87O
   +RpA2QFg6mEXp+5bGOWbllpEW68iB1RTUetWgpUlD3baA8bWfNJUe+W9J
   Q==;
X-CSE-ConnectionGUID: Kut/kVrDSKK8CBIT7qRrFw==
X-CSE-MsgGUID: yjYZguEETdW3cS3qCo+Whw==
X-IronPort-AV: E=McAfee;i="6800,10657,11974"; a="4222457"
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="4222457"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 14:20:56 -0800
X-CSE-ConnectionGUID: RnvpdRQeRIyzEGL4W/QQFg==
X-CSE-MsgGUID: XHRIZMQGRly4H4OxIWPybQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="11164227"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 22 Nov 2026 14:20:54 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xVFvW-00000001M9S-2JJP;
	Sun, 22 Nov 2026 22:20:50 +0000
Date: Mon, 23 Nov 2026 06:20:09 +0800
From: kernel test robot <lkp@intel.com>
To: Jim Cromie <jim.cromie@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jason Baron <jbaron@akamai.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Jim Cromie <jim.cromie@gmail.com>
Subject: Re: [PATCH v3 6/6] drm-dyndbg: drop BROKEN on DRM_USE_DYNAMIC_DEBUG
 for testing (DONT_APPLY)
Message-ID: <202611230650.Ebz6km83-lkp@intel.com>
References: <20261121-rd-mostly-v3-6-89e74b23b491@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121-rd-mostly-v3-6-89e74b23b491@gmail.com>
X-Stat-Signature: p85xwxiozeki38m5xcg9wkmgipr1pyr6
X-Rspam-User:
X-Rspamd-Queue-Id: 676B040007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795386058-729933
X-HE-Meta: U2FsdGVkX18qNg1WWLt39/IjtsBEtsNLkrEsuXtEliCU9tNm3KRYwzhQA30Uopm4Htqin7Dt8QqCKyr3x6JpGQqtuM2RRQlDqV6qxjtb7eU6aEtZEbEsRCuhBp1KTFpezBxgIOngflBkvaTCOYyp00aAtcAScTjy6Sbd9VNmfhd0vTpz/GsOeOGDTHZr0V/EdrRpk3BO79Zh9VsUfedlFyktVVKjS9LkTqrV6x1Aj6WBnmkCccrbpKjM0nPPX1X2SH5+tcwk674tAS1nMIOKpYw/zQ+XtvdfAp2J4ULav1rPyFqrhOk3oKvsXTuOdjJRkB+41i5saZ7B4oTbQ6OvZt/Ns3rru8a/7Zgeyr2GNVcOdJ9gREen24RleJ+5Nappd7AnFljZLFK6QIfnvfGYU0OZtHnXDEMGxpXbda6PcE7AUzem/MaQBOiZq19C9+pjJVyLbbUqjisJ55MJ0z0CFHD5wog5XEsQCCKbjBFHHTFaqnmnXry0EI43GINvfsgcXdYjqLBzJOg9rACBWyFMWiDWEjhsjUWKoNeFLbLeJo1eqFhYrUhfhkzq5WGkAv+lasZDNMbNjMwb7vog2VRbdoTUJQpHrRf68ndRQZ4VCiiX8M46SCYo3J88MTXgDn4gLXGag7a6eRxwTeogDorO9DyLUrHORiVyAHxUcbLuzQETKXLRgYawX/0j6nAMRKeKhNEXh83QyQqX2q6uemjpnSvdbpgoJH+6AAsiNe+KJke8ISu8ffqzngXm7aSBk/MSUuYrFFUUo1ppyKYCGdYuKyc9Bo9NMiBOpIMSw4Rv5S6OZ3AoJQqS9TVSnwjwFmEwX3jrBFQRgl4nlX9KseRsnkn4KKJA+/VxrRBzWnBe0yydfm/mLg7jyq5DKdE6jwH6edP3MvmzTuFrn18zWFDik3bVGeYcotaV+kKBVEQD7RoN7w/J75LYEXj1mFhf89FEGK65DPN54t5TnAoBec8
 HI6hxlJO
 TWRZSoe55ZpvNW4VZsuPxDlhwzmYWRYvdF8xGRZtO82QfELo4ga+dMdjQKbDSgAfIb+3MgbPn2xzS/nrIfJUk5NxaluDeLc5ZgpdL0K21UA7Jtsfi1FCR8Nw+xFpLGjz20xYSAHHbhsGyVvE/L15Y+b2GQZZD5e1iYLaYyN02wzSYNlEAe0dIhDpl7MyerO2Vlymki8UEQ/kLYdOw49LGu1dWFPoqNIxe1IkVk+gS0Rg1RqSuj09rb1ZZ++xYFWKTOJIbqxKptPMrEQ0Vhl3fK2uITMFmkhQXqJLYH2X2m+pCVjOLz9dtwbUPkO6qNAkBeSuGIeYAjD9G973WKHjrl/CNmuzPeisS0GmiMjtfVR+fF5TCY0Q1+O61y8gpgId4VQpqub8rko6JwQ/eoVsaQOFro+yb2DAmPwMXpvg3a7ruMk2s6pfbKxp1nSbP6oLvC7yGP28FAo+m8CaShXyWw3EsP4aapsx4tsKM+/pq51JLbgpWV1Ki0C5I8gDJ8yyjvld4PLDH8MSBE+1GFIocBJqqizOVYURjlixlzqpzrV/SCC13r/iM6MeiEXPX/+How2z88J9xGUF6Uc9ojzZiHPZ1wdcTgBHxCeh3b+8l+mFzQugiBn730wOGhwL2G69xrpX8eBWgWSnwVDRN0tnHMFyvPSpKmU776p+MMQSUPEQZiFr6HXufWhzZq5WfDpUkBaEn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jim,

kernel test robot noticed the following build errors:

[auto build test ERROR on aebb7274476403040d582c61478df8f4a7bf9cd3]

url:    https://github.com/intel-lab-lkp/linux/commits/Jim-Cromie/drm-print-Mark-__drm_debug-as-__read_mostly/20261121-142254
base:   aebb7274476403040d582c61478df8f4a7bf9cd3
patch link:    https://lore.kernel.org/r/20261121-rd-mostly-v3-6-89e74b23b491%40gmail.com
patch subject: [PATCH v3 6/6] drm-dyndbg: drop BROKEN on DRM_USE_DYNAMIC_DEBUG for testing (DONT_APPLY)
config: csky-randconfig-1001-20261123 (https://download.01.org/0day-ci/archive/20261123/202611230650.Ebz6km83-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261123/202611230650.Ebz6km83-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611230650.Ebz6km83-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/accel/ethosu/ethosu_job.c:15:
   drivers/accel/ethosu/ethosu_job.c: In function 'ethosu_ioctl_submit':
>> include/drm/drm_print.h:566:9: error: implicit declaration of function '_dynamic_func_call_cls' [-Wimplicit-function-declaration]
     566 |         _dynamic_func_call_cls(cat, fmt, __drm_dev_dbg,         \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/drm/drm_print.h:654:9: note: in expansion of macro 'drm_dev_dbg'
     654 |         drm_dev_dbg(__drm_to_dev(drm), DRM_UT_DRIVER, fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~
   include/drm/drm_print.h:672:33: note: in expansion of macro 'drm_dbg_driver'
     672 | #define drm_dbg(drm, fmt, ...)  drm_dbg_driver(drm, fmt, ##__VA_ARGS__)
         |                                 ^~~~~~~~~~~~~~
   drivers/accel/ethosu/ethosu_job.c:527:17: note: in expansion of macro 'drm_dbg'
     527 |                 drm_dbg(dev, "Failed to copy incoming job array\n");
         |                 ^~~~~~~


vim +/_dynamic_func_call_cls +566 include/drm/drm_print.h

02c9656b2f0d69 Haneen Mohammed 2017-10-17  560  
84ec67288c10fb Jim Cromie      2022-09-11  561  #if !defined(CONFIG_DRM_USE_DYNAMIC_DEBUG)
e820f52577b14c Jim Cromie      2022-09-11  562  #define drm_dev_dbg(dev, cat, fmt, ...)				\
16deeb8e18cafd Jim Cromie      2022-09-11  563  	__drm_dev_dbg(NULL, dev, cat, fmt, ##__VA_ARGS__)
84ec67288c10fb Jim Cromie      2022-09-11  564  #else
84ec67288c10fb Jim Cromie      2022-09-11  565  #define drm_dev_dbg(dev, cat, fmt, ...)				\
16deeb8e18cafd Jim Cromie      2022-09-11 @566  	_dynamic_func_call_cls(cat, fmt, __drm_dev_dbg,		\
84ec67288c10fb Jim Cromie      2022-09-11  567  			       dev, cat, fmt, ##__VA_ARGS__)
84ec67288c10fb Jim Cromie      2022-09-11  568  #endif
e820f52577b14c Jim Cromie      2022-09-11  569  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

