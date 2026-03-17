Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC55F3381C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C741A6B0005; Tue, 17 Mar 2026 04:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B276B0088; Tue, 17 Mar 2026 04:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88386B0089; Tue, 17 Mar 2026 04:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A44376B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:59:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A90BC21D9
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:59:03 +0000 (UTC)
X-FDA: 84554955366.26.BA735C5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD6F44000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:58:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e666kfGZ;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773737941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hhzwZ0yC4AUnjluUYqE0M1DTyd68F2hJqcH/Pu/a+k=;
	b=PyAU91vQg7soBPfe8Q1J73i0YLjumFSFLuTyaNmCTEZcSJsV+U+liDy1cIl5W+eCHD6Vek
	zSDUsKXeoyK0KhruY+TnxfSfwWPOdRvWNYrenrO9jsaplCbBq3PtfTILLUWu32UB5vKMOI
	G2OnMer9ziWmbUxbf3Zxn0XPECS+/SU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773737941; a=rsa-sha256;
	cv=none;
	b=6/EG3Lv8qNzHp2yzazfFZUFBQieTIEjdJOuqxoXZ0LMCQt/0p8TgfvZS0XFT9XHvIMWZp4
	pcxSJEOlM/VsN0EB1s/jK8GOUN003+ZTZQXDxMeQiRVKrV+8DimDdqNQD7OEz3HI/ufTvG
	Rw7kAVo6vU1vCDUomgTGFqilgOU6swY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e666kfGZ;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773737939; x=1805273939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OlkdjzuVOi9z4NPPUuSL0p51tYWRM4T1TvomF+a/yOA=;
  b=e666kfGZnlnGWBH6RCXQqJ1ALWgQfAZJ+KDgo6DD5XQ6zrUugGhfQa9/
   D74fiFSG66ASaWy2i1ZX3u8hNOTHXsqpCCzKEnzNHHhG70Tm3N6fCUDCK
   T1DCN2gE7gOhVgO+LOXiJoNG7TWVOVTo/HpmCj2LvGEHLfUo1JI8CBCM3
   FCuEBG3GXJVw2c+C9VHOrBNo7niTqu6ZShe4IDwi1IlkvmdqbHESTZGYI
   2QDPdMVlBRvV55YUsBfTsUY7dSZgIUrbkbqwKhSdEbg31vzOvA5qsY3ER
   Gr+0aYvPDWJ3mNyoETae4ys1vhdCnREnC/THCdkOPL1GnHX2GmN7xC7CP
   g==;
X-CSE-ConnectionGUID: L2y8QmtsTjuucwnLM92Vfw==
X-CSE-MsgGUID: j8vLIvPDSwWH18iR1eBrfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="85461720"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="85461720"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 01:58:57 -0700
X-CSE-ConnectionGUID: TMKcp+2HTRS7Mh9m6Hh72Q==
X-CSE-MsgGUID: LvAsp+W6SuC7aoTr8fbcaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="222426303"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 17 Mar 2026 01:58:55 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2QGL-000000004P7-03yL;
	Tue, 17 Mar 2026 08:58:53 +0000
Date: Tue, 17 Mar 2026 09:58:40 +0100
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, rppt@kernel.org,
	pratyush@kernel.org, linux-kernel@vger.kernel.org,
	dmatlack@google.com, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5/6] liveupdate: Make unregister functions return void
Message-ID: <202603170941.c2zUXqhx-lkp@intel.com>
References: <20260317025049.494931-6-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317025049.494931-6-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD6F44000A
X-Stat-Signature: 4dwu4rusk7kkjjmgzw3q469pa3qik4tk
X-HE-Tag: 1773737938-692560
X-HE-Meta: U2FsdGVkX18Yal1mRihFYXGdYJOvT2RlSwBqyN0qmH2DNmC1CN4WQvvBTYaDU2b/4E3gD3KwD7OtHH6hJXtOdED6sNBRsnUH/nrmgfxs4B97p9p8k6fWtwLwYphnms5rr9gHoWVImNs02lvPceLbsSy7haXaI0UUEEonQzflcV+QAoXQw1nV5iyNtfTSLtaQwq+5XJTz89Qp8tagfPemBTXbQ1HAMd+VGdXL5jK+G2ZKmmTx3zjHXeByxv3RIUfMOTItDUpB/rpoOmiyWLQgO+3OgDYw0hLsA9HukKNruGOjP1QN/xTuJh4ITbCdWNP2ABIYESR8KXpsVjpbBTbkYkytj0yxTtYIJ56lVMC9WWdHg1/PDxcGfZVr/gdAHf17OONeQjX3dmme5RVv3NIwDfjrji7kCmhYv6tHk9vSzKqZXxQI26vO/g5OOu9ozh0YuNa95xPoiKrjR6jfKi9yV6XT9EHw0qpf3Ov9ELtzAbxY4XV958jtfiHykjabDKgH3lT+7UVxvZAnUS4YVuDl9UDefpONWxFNoA32a3IZnB8ZT8uNOGLCojkjwK/zspaOE+mRS8TV8J2G9oP7k3S17aKXLZQX3AHmy2/VG+FPWc3RLBV4rVToN+/SkY8uRrgxW2OdtcxuFdTFIEDNi89yYhzOv9U5tLf4zKTce2U2Gv4zIJZmKWES02wNiAF7rfHD5uXZUnipYyT6HSWk8DW1tV9kOl2PEF9quAc+Y2EpxbeO0trwksmFehlep6a5Oe6dBRkdECgBOIes0QrYZmMPO5C1ArfjrH4zyTih2CL9j4IZ14+e3cKNKO/SfH4AVE8gecyYv9qu03X3+NkYWvQ0X5SbCeIkbiYwp86zlQ3JryaIsBTA28kXrFeKdwQPqubd8n6xbb4Y83efh/WkPJookJ3MbScgJ48Mkx9c2Fu3MukV0mNpB5kTcUrsmkKAqb1Cf2Re4RyfAB8LUqe9NL5
 GqMAZHRY
 tQWFdK0EmraDdN8TGLsPhR5zKnDkFoJqYvOzeL4+/o7SVJHLiU8Swwx955RnxVL2qFk3gZZdJXl4dkyNKSVf9Dg7bEesI9sNpurPADyHKDbRVBpKpl1YlSX+/1HVk0BnNITENgXSdYgoNNZ7Emk7rEqIvVbPrT+dDs/cKmBv2YYt9mYmE2njdo3f3EZ91RTcjUxeQheETyItvSzQOPqZeVywbGl/nuT5K+4FqlvSTp3FYQWNxpUwZv+aXLIoemvzsddWnbD6Nr+CwLmVcLItapO+sc0whbRTi9gqCh/cwSTeFZt+Guuq+fuTVZ21SwDmfc4CWbb30roYDm/Hn4flXOyR1huosNXwTGtQP52kOMp55/9tePYw9ydeqzfuZqN+QnpauIrAhP2eVmBfxmdjQSdAb7KPrzxKms6mCG/Xsyg8aBqJCNFyA6RUP6ND+pQ6ltTpR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on akpm-mm/mm-everything linus/master v7.0-rc4 next-20260316]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pasha-Tatashin/liveupdate-Protect-file-handler-list-with-rwsem/20260317-105522
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260317025049.494931-6-pasha.tatashin%40soleen.com
patch subject: [PATCH 5/6] liveupdate: Make unregister functions return void
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260317/202603170941.c2zUXqhx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260317/202603170941.c2zUXqhx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603170941.c2zUXqhx-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/kexec_core.c:18:
   include/linux/liveupdate.h: In function 'liveupdate_unregister_flb':
>> include/linux/liveupdate.h:274:16: error: 'return' with a value, in function returning void [-Wreturn-mismatch]
     274 |         return -EOPNOTSUPP;
         |                ^
   include/linux/liveupdate.h:271:20: note: declared here
     271 | static inline void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/return +274 include/linux/liveupdate.h

cab056f2aae725 Pasha Tatashin 2025-12-18  270  
e62bd1ab0687a1 Pasha Tatashin 2026-03-16  271  static inline void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
cab056f2aae725 Pasha Tatashin 2025-12-18  272  					     struct liveupdate_flb *flb)
cab056f2aae725 Pasha Tatashin 2025-12-18  273  {
cab056f2aae725 Pasha Tatashin 2025-12-18 @274  	return -EOPNOTSUPP;
cab056f2aae725 Pasha Tatashin 2025-12-18  275  }
cab056f2aae725 Pasha Tatashin 2025-12-18  276  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

