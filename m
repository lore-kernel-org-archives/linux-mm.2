Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E056E9E305
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739756B0089; Wed, 11 Feb 2026 08:43:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700AF6B008C; Wed, 11 Feb 2026 08:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2AD6B0092; Wed, 11 Feb 2026 08:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 464416B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:43:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008401B3914
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:43:37 +0000 (UTC)
X-FDA: 84432293274.01.AA146DB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F9BD14000E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:43:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q5t7GOyd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770817416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3/s/BMwwAmSTETu2e8y/u3D++EfQzrHzCEzcz82YV8=;
	b=pOEtN9qKFtVOSsbllOyVvZnpFIg+9ossl67yjqjohUxVEj/8cp1jqB7QQn5DJddL/99tLW
	U2iWIgdrv77YyZdWKXZ3mmC+GYur68GQr9PqemkUdqc5+9DahumRmmrcWzQiw2sIJJ268+
	BeAEcnjjn5Nmli/aTLoPKIsvRXzNxhg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770817416; a=rsa-sha256;
	cv=none;
	b=w+c7QkIfMGs1WwzFVpPqM7r3+GS+w9FxJtq2njie6btJPviRTzXu/zMqCerj6fGZ2H/yTh
	Ll0JdMPi1bPeijgAkXpn82iAAm5exAdvtSHJ1En00GpvgSfFJpA7pDsUhaQQf2NmJwoe5t
	VVrqzKFBQML2Fyt/tpvX/3iwcttP6NA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q5t7GOyd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770817415; x=1802353415;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wEJz6UAJ/YDJm9FyFpIp7xlD4O0stl9h6zZkBnYZOxY=;
  b=Q5t7GOydXoWy25aSrUdO2gMdyj+le/u6AM/ZoBR/+1CleyjNsZichrQf
   ouov2B6z4O8AMDAd1UvDLouKr8RFpFon7gKYBfMamGSvoalS5ZdwnJa28
   yu6DF464WxZmYpdhLHGucYCyKmHMWk8AyvDlP9y7ilzaE7IJo9rPfLbWR
   qJI1NS9l88RrT4mSX3ij2gMfoBuJH1sFogsvlPMfL8ii5E5aIoDawjlfW
   f9jS/54ljbRQcBPva0R6eo7tqMqcQyDtYsMM3KABMb6bD/T4kHWtU4qOQ
   F5/ycaSVen3tDBoc52xFe8f7zc6IlurD5e3m/cxP2//XxEcILOTKzATVF
   w==;
X-CSE-ConnectionGUID: gPBke6QMQXC9jVTuICg+kQ==
X-CSE-MsgGUID: wVJ0dNW0T02L/rkTQreFcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="72007569"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="72007569"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 05:43:33 -0800
X-CSE-ConnectionGUID: R3H5VLSkRWCLn8vcnT5v2A==
X-CSE-MsgGUID: n5aq+60TScCI4U8b3U0n8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216757612"
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by fmviesa005.fm.intel.com with ESMTP; 11 Feb 2026 05:43:26 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqAV2-0000000015Z-01aG;
	Wed, 11 Feb 2026 13:43:24 +0000
Date: Wed, 11 Feb 2026 14:42:24 +0100
From: kernel test robot <lkp@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	hannes@cmpxchg.org, hughd@google.com, yosry.ahmed@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, kasong@tencent.com, chrisl@kernel.org,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu,
	pavel@kernel.org, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
	joshua.hahnjy@gmail.com
Subject: Re: [PATCH v3 09/20] mm: swap: allocate a virtual swap slot for each
 swapped out page
Message-ID: <202602111445.rP38hmwx-lkp@intel.com>
References: <20260208215839.87595-10-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208215839.87595-10-nphamcs@gmail.com>
X-Rspamd-Queue-Id: 8F9BD14000E
X-Stat-Signature: s9b5psgsnrxupzff7b1jrw7ponnuutgk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770817415-90356
X-HE-Meta: U2FsdGVkX19wuFqRFdEKjJafnFOHrZCk6R1pCH9PvDeYXyPvFmeEYVgeVemLb3os5LtSan5Tx8B2dmzEwX+FTEqBAykyfBvUJ0ZR3kJObGbqPCtwqOpiGk0vQ7ToDbek5UniYsB3IFRUny1u0KnzBfAhLqJ+p0gNF4/MAR1WVuEsOJohmjwuFRdqYR6vwNhCU3AvHl5k+7MPbuvNLEPa9J0jcbF7HMhB/mKuYtGJz7GSUy0ERoX+O1g/yGtk85/kWj7nbk7zbPHlCuBSBsXCwG1TXGzp7NjFTZYEBYpIVTnywpcbl8CArHLbA/hlXrpVHw7/YFvEAZzdy2854HrQnGOaBFIcFXAQVysUdkU1yfjGND+E/jmOdSbSuJzBNHou7Q3OQ+JyN701SgKNuNOZrH4F5dYYc6lZiY3EeL/0g2IapQ8RVAfEPF9xhozRdalK8lbFEi3l1vHXik696PkESp2JjL0IYukvCSo96ZAJVmHU8zHOZpl5EQ09g8MvIntZRpVBd1jLv9aYQyq52y1AtxBsez+K7Qwo9Cl3XmyJLq22W87SlhXVgM9k8VHPyW4RqdrbHKbnWXXWANMxEe7WX2EKZPDZKKDuQfTLWYjZmWzAYE1D/R3d/2ZP4b+wphctb7YIkAomdx/sVDdNH1cjWH6oQXP7U9xvOBiWV1LOvOXUmICXQVxWWg6isCS2AAobfgvRQt4dfUuh/Lf9vdPz3vZ5C4xJb6X10BkpXnp/dVXK5ZOu24OoV/AO46YZMI1oHWmTIseZ8aZtvpO/IcL9Z3Ai2bWQJ5/MFXEoBJLI3rOR1ZmXxXCATXhhjP2t3M4VGXalo7qdUGmICt5fWu3BqRoZNG1OzFb8pGI8zpGDTMN+xwFC+OXAaGvS2UH9M/WmLMZb08pi6EEZ1SYxBbaxGn3sI5I790njWDrfgM5d4C2gbJ6o2eFKv7puPhRe2Dj3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

kernel test robot noticed the following build errors:

[auto build test ERROR on 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b]

url:    https://github.com/intel-lab-lkp/linux/commits/Nhat-Pham/mm-swap-decouple-swap-cache-from-physical-swap-infrastructure/20260209-120606
base:   05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
patch link:    https://lore.kernel.org/r/20260208215839.87595-10-nphamcs%40gmail.com
patch subject: [PATCH v3 09/20] mm: swap: allocate a virtual swap slot for each swapped out page
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260211/202602111445.rP38hmwx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260211/202602111445.rP38hmwx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602111445.rP38hmwx-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/local_lock.h:5,
                    from include/linux/mmzone.h:24,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:7,
                    from mm/vswap.c:7:
   mm/vswap.c: In function 'vswap_cpu_dead':
>> include/linux/percpu-defs.h:221:45: error: initialization from pointer to non-enclosed address space
     221 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                             ^
   include/linux/local_lock_internal.h:105:40: note: in definition of macro '__local_lock_acquire'
     105 |                 __l = (local_lock_t *)(lock);                           \
         |                                        ^~~~
   include/linux/local_lock.h:17:41: note: in expansion of macro '__local_lock'
      17 | #define local_lock(lock)                __local_lock(this_cpu_ptr(lock))
         |                                         ^~~~~~~~~~~~
   include/linux/percpu-defs.h:245:9: note: in expansion of macro '__verify_pcpu_ptr'
     245 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:256:27: note: in expansion of macro 'raw_cpu_ptr'
     256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~
   include/linux/local_lock.h:17:54: note: in expansion of macro 'this_cpu_ptr'
      17 | #define local_lock(lock)                __local_lock(this_cpu_ptr(lock))
         |                                                      ^~~~~~~~~~~~
   mm/vswap.c:653:9: note: in expansion of macro 'local_lock'
     653 |         local_lock(&percpu_cluster->lock);
         |         ^~~~~~~~~~
   include/linux/percpu-defs.h:221:45: note: expected 'const __seg_gs void *' but pointer is of type 'local_lock_t *'
     221 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                             ^
   include/linux/local_lock_internal.h:105:40: note: in definition of macro '__local_lock_acquire'
     105 |                 __l = (local_lock_t *)(lock);                           \
         |                                        ^~~~
   include/linux/local_lock.h:17:41: note: in expansion of macro '__local_lock'
      17 | #define local_lock(lock)                __local_lock(this_cpu_ptr(lock))
         |                                         ^~~~~~~~~~~~
   include/linux/percpu-defs.h:245:9: note: in expansion of macro '__verify_pcpu_ptr'
     245 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:256:27: note: in expansion of macro 'raw_cpu_ptr'
     256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~
   include/linux/local_lock.h:17:54: note: in expansion of macro 'this_cpu_ptr'
      17 | #define local_lock(lock)                __local_lock(this_cpu_ptr(lock))
         |                                                      ^~~~~~~~~~~~
   mm/vswap.c:653:9: note: in expansion of macro 'local_lock'
     653 |         local_lock(&percpu_cluster->lock);
         |         ^~~~~~~~~~
>> include/linux/percpu-defs.h:221:45: error: initialization from pointer to non-enclosed address space
     221 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                             ^
   include/linux/local_lock_internal.h:107:27: note: in definition of macro '__local_lock_acquire'
     107 |                 _Generic((lock),                                        \
         |                           ^~~~
   include/linux/local_lock.h:17:41: note: in expansion of macro '__local_lock'
      17 | #define local_lock(lock)                __local_lock(this_cpu_ptr(lock))
         |                                         ^~~~~~~~~~~~
   include/linux/percpu-defs.h:245:9: note: in expansion of macro '__verify_pcpu_ptr'
     245 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:256:27: note: in expansion of macro 'raw_cpu_ptr'
     256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~
   include/linux/local_lock.h:17:54: note: in expansion of macro 'this_cpu_ptr'
      17 | #define local_lock(lock)                __local_lock(this_cpu_ptr(lock))
         |                                                      ^~~~~~~~~~~~
   mm/vswap.c:653:9: note: in expansion of macro 'local_lock'
     653 |         local_lock(&percpu_cluster->lock);
         |         ^~~~~~~~~~
   include/linux/percpu-defs.h:221:45: note: expected 'const __seg_gs void *' but pointer is of type 'local_lock_t *'
     221 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                             ^
   include/linux/local_lock_internal.h:107:27: note: in definition of macro '__local_lock_acquire'
     107 |                 _Generic((lock),                                        \
         |                           ^~~~
   include/linux/local_lock.h:17:41: note: in expansion of macro '__local_lock'
      17 | #define local_lock(lock)                __local_lock(this_cpu_ptr(lock))
         |                                         ^~~~~~~~~~~~
   include/linux/percpu-defs.h:245:9: note: in expansion of macro '__verify_pcpu_ptr'
     245 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:256:27: note: in expansion of macro 'raw_cpu_ptr'
     256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~
   include/linux/local_lock.h:17:54: note: in expansion of macro 'this_cpu_ptr'
      17 | #define local_lock(lock)                __local_lock(this_cpu_ptr(lock))
         |                                                      ^~~~~~~~~~~~
   mm/vswap.c:653:9: note: in expansion of macro 'local_lock'
     653 |         local_lock(&percpu_cluster->lock);
         |         ^~~~~~~~~~
>> include/linux/percpu-defs.h:221:45: error: initialization from pointer to non-enclosed address space
     221 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                             ^
   include/linux/local_lock_internal.h:176:40: note: in definition of macro '__local_lock_release'
     176 |                 __l = (local_lock_t *)(lock);                           \
         |                                        ^~~~
   include/linux/local_lock.h:38:41: note: in expansion of macro '__local_unlock'
      38 | #define local_unlock(lock)              __local_unlock(this_cpu_ptr(lock))
         |                                         ^~~~~~~~~~~~~~
   include/linux/percpu-defs.h:245:9: note: in expansion of macro '__verify_pcpu_ptr'
     245 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:256:27: note: in expansion of macro 'raw_cpu_ptr'
     256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~
   include/linux/local_lock.h:38:56: note: in expansion of macro 'this_cpu_ptr'
      38 | #define local_unlock(lock)              __local_unlock(this_cpu_ptr(lock))
         |                                                        ^~~~~~~~~~~~
   mm/vswap.c:665:9: note: in expansion of macro 'local_unlock'
     665 |         local_unlock(&percpu_cluster->lock);
         |         ^~~~~~~~~~~~
   include/linux/percpu-defs.h:221:45: note: expected 'const __seg_gs void *' but pointer is of type 'local_lock_t *'
     221 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                             ^
   include/linux/local_lock_internal.h:176:40: note: in definition of macro '__local_lock_release'
     176 |                 __l = (local_lock_t *)(lock);                           \
         |                                        ^~~~
   include/linux/local_lock.h:38:41: note: in expansion of macro '__local_unlock'
      38 | #define local_unlock(lock)              __local_unlock(this_cpu_ptr(lock))
         |                                         ^~~~~~~~~~~~~~
   include/linux/percpu-defs.h:245:9: note: in expansion of macro '__verify_pcpu_ptr'
     245 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:256:27: note: in expansion of macro 'raw_cpu_ptr'
     256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~
   include/linux/local_lock.h:38:56: note: in expansion of macro 'this_cpu_ptr'
      38 | #define local_unlock(lock)              __local_unlock(this_cpu_ptr(lock))
         |                                                        ^~~~~~~~~~~~
   mm/vswap.c:665:9: note: in expansion of macro 'local_unlock'
     665 |         local_unlock(&percpu_cluster->lock);
         |         ^~~~~~~~~~~~
>> include/linux/percpu-defs.h:221:45: error: initialization from pointer to non-enclosed address space
     221 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                             ^
   include/linux/local_lock_internal.h:179:27: note: in definition of macro '__local_lock_release'
     179 |                 _Generic((lock),                                        \
         |                           ^~~~
   include/linux/local_lock.h:38:41: note: in expansion of macro '__local_unlock'
      38 | #define local_unlock(lock)              __local_unlock(this_cpu_ptr(lock))
         |                                         ^~~~~~~~~~~~~~
   include/linux/percpu-defs.h:245:9: note: in expansion of macro '__verify_pcpu_ptr'
     245 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:256:27: note: in expansion of macro 'raw_cpu_ptr'
     256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~
   include/linux/local_lock.h:38:56: note: in expansion of macro 'this_cpu_ptr'
      38 | #define local_unlock(lock)              __local_unlock(this_cpu_ptr(lock))
         |                                                        ^~~~~~~~~~~~
   mm/vswap.c:665:9: note: in expansion of macro 'local_unlock'
     665 |         local_unlock(&percpu_cluster->lock);
         |         ^~~~~~~~~~~~
   include/linux/percpu-defs.h:221:45: note: expected 'const __seg_gs void *' but pointer is of type 'local_lock_t *'
     221 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                             ^
   include/linux/local_lock_internal.h:179:27: note: in definition of macro '__local_lock_release'
     179 |                 _Generic((lock),                                        \
         |                           ^~~~
   include/linux/local_lock.h:38:41: note: in expansion of macro '__local_unlock'
      38 | #define local_unlock(lock)              __local_unlock(this_cpu_ptr(lock))
         |                                         ^~~~~~~~~~~~~~
   include/linux/percpu-defs.h:245:9: note: in expansion of macro '__verify_pcpu_ptr'
     245 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:256:27: note: in expansion of macro 'raw_cpu_ptr'
     256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~
   include/linux/local_lock.h:38:56: note: in expansion of macro 'this_cpu_ptr'
      38 | #define local_unlock(lock)              __local_unlock(this_cpu_ptr(lock))
         |                                                        ^~~~~~~~~~~~
   mm/vswap.c:665:9: note: in expansion of macro 'local_unlock'
     665 |         local_unlock(&percpu_cluster->lock);
         |         ^~~~~~~~~~~~


vim +221 include/linux/percpu-defs.h

62fde54123fb64 Tejun Heo 2014-06-17  207  
9c28278a24c01c Tejun Heo 2014-06-17  208  /*
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  209   * __verify_pcpu_ptr() verifies @ptr is a percpu pointer without evaluating
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  210   * @ptr and is invoked once before a percpu area is accessed by all
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  211   * accessors and operations.  This is performed in the generic part of
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  212   * percpu and arch overrides don't need to worry about it; however, if an
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  213   * arch wants to implement an arch-specific percpu accessor or operation,
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  214   * it may use __verify_pcpu_ptr() to verify the parameters.
9c28278a24c01c Tejun Heo 2014-06-17  215   *
9c28278a24c01c Tejun Heo 2014-06-17  216   * + 0 is required in order to convert the pointer type from a
9c28278a24c01c Tejun Heo 2014-06-17  217   * potential array type to a pointer to a single item of the array.
9c28278a24c01c Tejun Heo 2014-06-17  218   */
eba117889ac444 Tejun Heo 2014-06-17  219  #define __verify_pcpu_ptr(ptr)						\
eba117889ac444 Tejun Heo 2014-06-17  220  do {									\
9c28278a24c01c Tejun Heo 2014-06-17 @221  	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
9c28278a24c01c Tejun Heo 2014-06-17  222  	(void)__vpp_verify;						\
9c28278a24c01c Tejun Heo 2014-06-17  223  } while (0)
9c28278a24c01c Tejun Heo 2014-06-17  224  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

