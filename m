Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB34CEB2F7
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 19:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8778E0007; Sat, 15 Nov 2025 14:06:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098E58E0005; Sat, 15 Nov 2025 14:06:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9918E0007; Sat, 15 Nov 2025 14:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF4F28E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 14:06:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74CEC4DA2D
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:06:48 +0000 (UTC)
X-FDA: 84113773296.11.8FDFE17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id AE4C54000A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:06:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MF2lo6C5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763233606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fAngtQVVbUsaQ5JerSq4nNNMOcI7PbhNCUtgbzCPz+U=;
	b=IjA8jwgsSalv/1uqycBy421Q59V2Gy0mpY0kPIW1Q6y++RqiTeF7AL/Q0BHTusHdNKg3Cm
	yHT7tPyo7NdAFUPd/373i17q5Rj4XfNk/9kafut6QOGW7DneftAObaoguz7RLXZlkn9SNr
	n2B9zcmC90Z7NHk+V6NM4q5vp47ZV+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763233606; a=rsa-sha256;
	cv=none;
	b=phH3UCGMwXAfrPDrMb25b3DaQ3cct+7gLhAsO4xkysbbJ9/VrmzletdxUsa3v1GchBnJzc
	JcY1/iNRDJjhQLkjYWROkn1E1xYn07ubkT0n5MYvqZMEE3kGI1ahttUKerIiyPlL67iTp+
	MZpp56vc1DKw1V/KzyTdDBSku/CTfn0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MF2lo6C5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763233606; x=1794769606;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=cVdHc0zZMKwI/lhvVkx0Lah8VDIvpX47gfaLp/x4dOY=;
  b=MF2lo6C5OhHz/T6IQYE3NZzVPUfwBnYpMVU6wsfPQ725DDngdaGYf7Um
   J+SgTmjCsWdPAEAUpW7B7fiHKP2SsyDvijRE/gjwKsZ5SatCH9FPMK7lK
   D6Eqa+7/54sh0jYELuVBZFNLcJ+zXriZ0SlcCiFdhodykKeKEkaPyvQtl
   YCKiHGaY6BmnxBvIiDuJNsXAcFocrIUu5qgY4Jc+sv/0zbA6TqLTch2wX
   6lAp6Z/TgWjaYR2c4uT2LmWxr/BeW860m6OYykeScOk364VAa7MZN995D
   I1+SXXFd/YN6/hxxDtYr/WbRa0+71KjT+it2diS2qnDf0HZ38mdN6Ln9X
   A==;
X-CSE-ConnectionGUID: SXVW+pr7T9+fkaZ7CZkV8A==
X-CSE-MsgGUID: CBVYyYJAR+Cf2hDd3I+syQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11614"; a="65326677"
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="65326677"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2025 11:06:44 -0800
X-CSE-ConnectionGUID: MgxB5T1ZRYywJ2N41Elqaw==
X-CSE-MsgGUID: i0os8C7dQOqSFtYN1KlIhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="195210382"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 15 Nov 2025 11:06:43 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKLbb-0008CN-27;
	Sat, 15 Nov 2025 19:06:39 +0000
Date: Sun, 16 Nov 2025 03:06:38 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [akpm-mm:mm-nonmm-unstable 82/133]
 include/linux/kexec_handover.h:108:7: warning: no previous prototype for
 function 'kho_alloc_preserve'
Message-ID: <202511160314.OK0OGRXl-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: apj61cwjdh97phq6oj1oddr3ohzqhzdb
X-Rspam-User: 
X-Rspamd-Queue-Id: AE4C54000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763233605-324960
X-HE-Meta: U2FsdGVkX1/OjieYi4TGI86BLCiqDuBZrm3eH2PNdoRQXSmSKKu5XMLJMGvj+iAiNV++ub8c7oyYsQLsYRv72ynWmrNsYlnSy2/Cd6fjsi+jkzWe1h4h4Sg2gYFL+Qj523Fxqi/jtpFd5oWGR8flEpUiCij4mRtMU9xu/JYx/4ROQlpF1L5w3GYh5d8s3NdfUMHlrtjlO3g3W9rAWPeycm5T4mrpNkPv2PfTsJUq3xJsLyGlLdG5D58Ej2jJT2lZEQeEj8ts00t1QxNPyjFrRNpmwV8Iv9FkAAiCtSZVcCO2kTyrmznd3rCaJyHjo1HsZlxx6caDwIigtJB4E5vPEe41JzASPB/84cxTtsdFjiZUgJiNA22Nr7XB/Yv5VUNtSlEl14P84IsjgRpWP99HYmjU9r5FF2mzkikPnfEsQ9RWJ9zIw16Rxy98uEaLb6fmK188JgUg4I31vAwIn17RHPCUgkpGOvONtX8aCCVvAPeCr/oqdEJqWcsQ0sD3Xqb+tA+H+dAJa5+4bx1+pOx/+w+2M9zqDPQZYGSg1wMeI+KV4Xu6DD2nfHt593HiNIAnTzeWeY2LG6i9IDMwjd82EisKyMnqcuDP8vJghzrqKrmUVcPu+oNEN6g4UIUBVIZjJdI7mHcym0j3vVgqh/8dvfSADvHAYyybVEFyIvgposAGf3C6iJmFcZvvNYzOsK9Jm2hP3/Bh/YiFhsveX9iV5BbxaRVsYcWgpxL0sTOSFkVbJ+8swrkGSutoOLf300RWCL+z4lmP2E+/NWP3gxTdV/+9W/mTkY9KgX1QH2C0es79H7U8WeBfA1UtIYnSAzNx9HNg3OCajlLTU4CZL2YW8I2945YkyOrxqMpNqeMoxfnR8FCwbYZ/9AEDQ9/M3iZWG6+siocZs0CIGH7lUZoqprxus0tbe7UFsGyqYverxdUwgj2X3hEwOrAtq5sa13vz89TZo9EFbYlBdNftOUL
 fOkfVtr4
 2mFbTAaM6cul/u3BqNHeoLTSogBkYvTdTAKYxHe1D7ZLkiNxQW0p4XLfrqZAsv22le2QaBttd/hRFC9ymqpBxBE9x0NtRttZk7FBqNXO71o6Q8gDwNEo0HRipFkDL9sbFkqdVDoXZVNNhFYVvcKkoK07bxBFSG9THhD962+IVu3QMRyu5p5dvhka3DsprHOTeciB6Qzd6NtMWlkqMuv51Co8bNKo1jwKHWLe4yqyJwn9q6uu5l8gDgV+K6UbJW3Kr7oPO78O2o6Hhr8XpBftC7xkbBar9nNYmswYIz4nY/17DrGSOfz39mXrzlClHz6MF/e+PNmsl37c/J1viRvxPNr0O+MmEhpFfiE+ddZG1vGKLaq4x/glpCiFVuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   4fc88c237bfe11bde443e104428aac56e63a997f
commit: 88316955b5b1b4cb0cb2fad416f7e8dde9b246a0 [82/133] kho: introduce high-level memory allocation API
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251116/202511160314.OK0OGRXl-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251116/202511160314.OK0OGRXl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511160314.OK0OGRXl-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/mm_init.c:33:
>> include/linux/kexec_handover.h:108:7: warning: no previous prototype for function 'kho_alloc_preserve' [-Wmissing-prototypes]
     108 | void *kho_alloc_preserve(size_t size)
         |       ^
   include/linux/kexec_handover.h:108:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     108 | void *kho_alloc_preserve(size_t size)
         | ^
         | static 
>> include/linux/kexec_handover.h:113:6: warning: no previous prototype for function 'kho_unpreserve_free' [-Wmissing-prototypes]
     113 | void kho_unpreserve_free(void *mem) { }
         |      ^
   include/linux/kexec_handover.h:113:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     113 | void kho_unpreserve_free(void *mem) { }
         | ^
         | static 
>> include/linux/kexec_handover.h:114:6: warning: no previous prototype for function 'kho_restore_free' [-Wmissing-prototypes]
     114 | void kho_restore_free(void *mem) { }
         |      ^
   include/linux/kexec_handover.h:114:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     114 | void kho_restore_free(void *mem) { }
         | ^
         | static 
   3 warnings generated.


vim +/kho_alloc_preserve +108 include/linux/kexec_handover.h

   107	
 > 108	void *kho_alloc_preserve(size_t size)
   109	{
   110		return ERR_PTR(-EOPNOTSUPP);
   111	}
   112	
 > 113	void kho_unpreserve_free(void *mem) { }
 > 114	void kho_restore_free(void *mem) { }
   115	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

