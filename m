Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42BEE8FDA2
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 13:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEEAC6B0088; Fri, 26 Dec 2025 08:23:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF266B0089; Fri, 26 Dec 2025 08:23:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5396B008A; Fri, 26 Dec 2025 08:23:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB2206B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:23:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 390C2BEDA5
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:23:37 +0000 (UTC)
X-FDA: 84261689274.04.BE3C7B0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id 753BE40009
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:23:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=koxoUSg8;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766755415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvwgJxfG8RoxlM+nHj4J50KIiHMDNM+uecPJER8vIBM=;
	b=xoVx1dBPDq8p56qkVp1V32VEncTavUNh+gnow0oAD2+mI7ivKM3eOihJvyeJsJWlgXeMVJ
	w2SnoxQC4QJiE2g46T12tE5ypjv5wzg84Bo5JmcRumFRx1QDuREObn5tCIYKo/Tsm4Yghs
	vWWhm0Rd7yQPv3D/UeG/pz/VV5KE+pk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766755415; a=rsa-sha256;
	cv=none;
	b=TPVyW72nCF1x3kybZtETZggymzalppTsle8fn+xqGlV18NtTxMGyGpykJtPvlKre5gAhXI
	s++dLrdVI3VYE0NSvgKe9IqpPEoCsUoyO1CKS/cXo7JzSomvbqG7e6ptCnLxOM7t7d33cL
	SbFdzkK/RGf48UR3kPkmqSooohojxPk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=koxoUSg8;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766755415; x=1798291415;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kYn0/jK2orN0CbLrDQMs5+dFtIP9GLMhhA/ko+U2UKE=;
  b=koxoUSg80QifTGJ78+2OeV7F5Qhgu+aC/2iDGN5U0/B2BkrTENJ44YHd
   WxpwUHXj8lAKj1C2fqcWqD+BTfLXJTME9po/fei865ypBBNZgjDVRb4Vp
   z38wUcWtqa0//bvoloW0ZYzkb5F1P1N3IGMxJ+NqG0cgh2R+/DwjjeO8H
   4tFi5ULyZpIv9fdLhIjKb5DdBKp5lPZqlF1oeUQLQhBph7i4K9RWUxL6f
   /mZ9gl+2/2CwbS47OON3nhqCOl0WAd/Sung7gQOqd8FNSkMVdExZVEcRH
   il9kInNBpyLWQG1T+gtbPb7SGP8avG4BF0y6fhYffo62e8eYjEqXBsVoc
   A==;
X-CSE-ConnectionGUID: vZh2x642RXucBFx0IBde/w==
X-CSE-MsgGUID: wE7s8nXVQ/G4EG/0+JsSxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11653"; a="72365585"
X-IronPort-AV: E=Sophos;i="6.21,178,1763452800"; 
   d="scan'208";a="72365585"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2025 05:23:33 -0800
X-CSE-ConnectionGUID: sMaK0WugQFSQyyqBCrCHgQ==
X-CSE-MsgGUID: SYbRYuy0TaqPlTD/iFOvsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,178,1763452800"; 
   d="scan'208";a="204522834"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 26 Dec 2025 05:23:29 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vZ7mw-0000000053J-3fOD;
	Fri, 26 Dec 2025 13:23:26 +0000
Date: Fri, 26 Dec 2025 21:23:04 +0800
From: kernel test robot <lkp@intel.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	damon@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Message-ID: <202512262017.v77XZpwk-lkp@intel.com>
References: <20251225232116.294540-9-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225232116.294540-9-shakeel.butt@linux.dev>
X-Stat-Signature: z8b3erh5a5dgx6d1tptbtfafhs7uppdb
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 753BE40009
X-Rspam-User: 
X-HE-Tag: 1766755414-84638
X-HE-Meta: U2FsdGVkX1+06CdBo58GSDB/8GYqkke6AxgDaOukfLXEhEJ5xpt0UUiGxu02wGszHlUkGQzl3RBkhWcDKk7+zne/Yt5WijXJHYvlmNDhK+SviOIrylbGhOnyrK4p7Wig4bm/ZughwSrdTd70tl9lR4Y+J84oUu3pnKSunhMzTY4a6AkztCLuvEcZ+cx4109jBiZdyZq/3q5ppMuMUSEPQzim3BXtI5muRQ8SIWPXeBw1CQJS6YvjX/ZaFp2pZEIQ+eXw4nhdzbRRWgW/SbStv2tWGYSP8T/IHiQNJlT8PEZydKPWnxJA/OVMSHvQnvsueWoGvryAhJG9XptZ2B4Hx01hkAMhz2p2B+tByy/9po/IAPKzKXdQm0ezD8ESNV8meAtkNjctbJdex+ZNX/jBPmXBaW9p41pzVVSMOh+/Zbrb5zwzp+N2h7iZeFD8aOF0pJgDkcUyg0kTwscGl8kQl+lLoYPKkooGA22MpFtVHEegU6sAwIeKJVt5dKkzgOx0lww/A1hZ2jsTm9zIB2aLjZ6wAMuNd2i3nzwKYHQrWSkPCZ8y73eW3Vj96qS+dq9DLKIeCfwd4LdKl8JNoQJPB5MlHbHSdt9Sp8GdkHgo00zl2aYpbrq9T2fsm6/a3UsS9PQklVP38yxG0HyFSNdRYMNir57twEofGv/UQHom8dyjMoTan6SG77eIgdxlowVFk6n2p9P4eBJBQmQShaxiBmQtYYbtyW2JLgzZReXv5xZKWsqsL5TlHmRdK8PzqIEKntWxtGFdFBxJ+R+Ys4NA/+qnKQtm662IotgtlqLzSwmDtIGNoCSj9DM2PEwjqAEhTBRsuuwjD8ggxsiIZQHnymlo6UtNKJFHBqZT063YlEO5vOYc+kj0vElCWXEBweREh3nbz5ejW9DrOf8MyoXczmqtRI69tTuy7lq44jbp1wKDBLS+4jnanLlCMKIP8Ps8tnTTd8Z3Pn8y0WUmFOj
 FcvoeXIP
 z3mvdRWqyGtVYc3Iqf4GuNZo9cLZUYRGth7CdZZN674PxhdeOEaE/u9SbQUtZabM0Qnlwa57U/OTwOG5hVLkYSIS7fF5v3Ez5Jj/KtqhiyuUUWwpmGIMdH+gRIzOpRoqKKo5WmYFanRiV/XhAQCnNlAOw/syXWax2+hBxEMWKCKhvwqdwHTPOBiXzgA0rcWf4dNcM7RpHgBpBFod7MULToLNEOXfwcNHPFWdY88qDzfOON6aheXvWdRkbP4sCKqMezWLloLGoRxmlSz6G6B8IiZVgAAFbhfBZTQB58oihT3x68uDBlqcf9FT77w4EzMbI21UYsdVDtY8JuJFstWV3wZEYFdIJ9cd4CnNj+RCXvZRZ+nYUgsMtWWw1oRY36JTWeWGmFmC314DgQnk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on sj/damon/next]
[cannot apply to akpm-mm/mm-everything tj-cgroup/for-next linus/master v6.19-rc2 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shakeel-Butt/memcg-introduce-private-id-API-for-in-kernel-users/20251226-072954
base:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next
patch link:    https://lore.kernel.org/r/20251225232116.294540-9-shakeel.butt%40linux.dev
patch subject: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
config: openrisc-allmodconfig (https://download.01.org/0day-ci/archive/20251226/202512262017.v77XZpwk-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251226/202512262017.v77XZpwk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512262017.v77XZpwk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:31,
                    from arch/openrisc/include/asm/bug.h:5,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/current.h:6,
                    from ./arch/openrisc/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from include/linux/rcupdate.h:27,
                    from include/linux/rculist.h:11,
                    from include/linux/pid.h:6,
                    from mm/damon/sysfs.c:8:
   mm/damon/sysfs.c: In function 'debug_show':
>> include/linux/kern_levels.h:5:25: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'u64' {aka 'long long unsigned int'} [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:484:25: note: in definition of macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:585:9: note: in expansion of macro 'printk'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:14:25: note: in expansion of macro 'KERN_SOH'
      14 | #define KERN_INFO       KERN_SOH "6"    /* informational */
         |                         ^~~~~~~~
   include/linux/printk.h:585:16: note: in expansion of macro 'KERN_INFO'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~~
   mm/damon/sysfs.c:2704:17: note: in expansion of macro 'pr_info'
    2704 |                 pr_info("id: %u, path: %s\n", mem_cgroup_id(memcg), path);
         |                 ^~~~~~~


vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

