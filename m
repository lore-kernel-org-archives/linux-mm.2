Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F409F3ED42
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 10:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26456B0089; Sat, 11 Apr 2026 06:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD72D6B008A; Sat, 11 Apr 2026 06:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC60F6B0092; Sat, 11 Apr 2026 06:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B78C66B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 06:34:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2F2C1A02DA
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 10:34:28 +0000 (UTC)
X-FDA: 84645915816.16.AA62F0B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id DFD1116000C
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 10:34:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gHcLUsh0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775903666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJUQLGxJ95p9p1MXGUCU28iVTSAmAXYgCpnJJoxDPPg=;
	b=jDe77xQohFBnwYVozOPg0vjV3ERamSAXJ7bhIYSAFYmGQfnrfC889j+fKxt4bpWdq46BFO
	DIcb7DskJBLf7Gq9+b4OMd2qBUW1l6lOZVT3kFfAS1vYD8TAJwLH8Y9TrQcHaBpPFI+r3W
	AfewSPli5W7/EOoXtxHz9f+vDfh5LU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775903666; a=rsa-sha256;
	cv=none;
	b=3dT4Bv4D/OeLsMgbMGrCiIcHrUn/9urBZuhXvXS9utU+ftchNWSu0UtYtQN8AMQgfhaftH
	ICP4Jx5BCBEVmSwZdDYGhvrtgrrs8eek9EylMKJwYZBZk5jTK0p4FlxBszTjU5s9NDOlhb
	oVfGFlECyD/sv9j+LjIbZpdW32fhYco=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gHcLUsh0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775903666; x=1807439666;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m5XmxqXJ66qVQmeGINtfVWwDdfovdoiv8v618XHKpII=;
  b=gHcLUsh0S5MJLZPWL5IvjS0l+ndPr9CY5ESNoswtI2XC7nfvtD/1ZIMF
   eFbsDtNMy466Vlp46ayOcA/vArfsxCrAIfbSpBP8zR9qJoGEDyq2XI8QS
   C3mk6Cnq90GTOeYKueZTEjGH9mu1BurVX83ao/t2nbmu40yUlANjyzLB7
   sPHVGXRYEvH1ILMNANZj0pCsqpLqSg4S0+EqFxtYBIi0XHN+MZyKPmDIK
   bUWpPIky0AzhVPpa6ueaBMf1s1mqTp7+gMQPrCj3fu15xh0mot7R0RrTf
   t7MptDgIN40uH/ef1PCuesYbYOs+D1G+pbMmA4cvJipILrasUfUNodWzI
   Q==;
X-CSE-ConnectionGUID: z+FyeqcnShCY2FLwjNQCzw==
X-CSE-MsgGUID: u8FhJvwuSkGjuJc9AV846Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76869302"
X-IronPort-AV: E=Sophos;i="6.23,173,1770624000"; 
   d="scan'208";a="76869302"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2026 03:34:24 -0700
X-CSE-ConnectionGUID: LtQqSnvjQ3+RQSqj3Z41mA==
X-CSE-MsgGUID: kQVFAggJQX2G8dJF+hS+Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,173,1770624000"; 
   d="scan'208";a="229589670"
Received: from lkp-server01.sh.intel.com (HELO 3eaaf1a74b89) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 11 Apr 2026 03:34:21 -0700
Received: from kbuild by 3eaaf1a74b89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wBVfO-0000000014b-1MJu;
	Sat, 11 Apr 2026 10:34:18 +0000
Date: Sat, 11 Apr 2026 18:34:03 +0800
From: kernel test robot <lkp@intel.com>
To: Cao Ruichuang <create0818@163.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	Cao Ruichuang <create0818@163.com>
Subject: Re: [PATCH] mm/vmstat: reject invalid stat_interval values
Message-ID: <202604111811.THSgZ1ry-lkp@intel.com>
References: <20260410112554.23165-1-create0818@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410112554.23165-1-create0818@163.com>
X-Rspamd-Queue-Id: DFD1116000C
X-Stat-Signature: xxx5rshkj15ap5s1ww5uoodrt7985ag5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775903665-263621
X-HE-Meta: U2FsdGVkX18gDTMtllb9iVt1IgY3f+VRNDTnJznDTsnnV+jKWMmd2xtSSVe4M5asHpQ5fUgJd7M2l6YgHEMSlrDoAfZDs+4n4HWD4K/1NdgDvK8K33SSBN/YB82ubilvAQ+vNlLr7HcEDgCXLg4IJ0SHVP14QxOchfgFre/Ja/zBtwMtMQ68vd3dc8HCh/d86bryUTI340/TpJTlzIrMvgJHvc56vUYtG+EVKNVfLumRwN71MnhMGooMkqorhdVLv0sdDV71anMbQ4UxlWMW0MPXCKZvi+MtZdJzj+U3j611jobK7bNqDOfbSWYPhaFcLXmjW3JgJ3pkEObBRP/h1ADw+HEjXJO6uR2aVPHVFzgVrnBr+N6543KmbuM9qUcicWK9ZEYWsy3dZIXb0chvR50lDz06lV3PS/w/vxgzFurdZzO44AqXDZs2NOdSObJY5jmJCv9KwUOXXZmVv2PvQBMO9c+dGkOCVaLzIv8s7l6YZhxgOXC2zq4rt6BGO2S0SkCSB9+N8vjqEjMe6k7b4MWYpcnZdu97faVnTnZOQMKpbVYNDV0HPFWcNmQ4IUiGWLfZ4AQigMDx/IdHtYweuAh9jzIUiaUZGK5zSSTWtU1ZQW8rhpZxPTGgzIyBShIOKuQ6hXMTzDi/a4xcPKv2rVZrAPQnY+TdWicKYk8rkWtaFhsm0zZX3vyXDtPK1AULdJXAPxwWp0ifzqqESWCA7zyu4l/1N4F92AfTdX2IZbx9z95v+FNvmoKAPfpgpaOJkOVB3t3nS8bBscYRGOFptDmYmI+wc2DUHd7tb/yBsHC8qdug0QP/FA7F1a7ZI4UmgBG1ZV3XjXGRCaEmLn06bWtTYGuzBSFCIkxFUaXNgVe8bq9xbygHcB9qWCFeavQcDIUe54DPB4rQtmxZVfFDMyFU0GHtKqdEyKQ856WbOogCTWR1UtUreqLzaxxLevrRjN7Ae11+3hTtmQ0GfJ4
 vjyLR/m3
 2VzuS1XrqAN2Ruww0wAmQV83j/451NxIz9W84AfV6vP9An1tJNZsZl9msmxw4wlfYiXTnQyBoVipHUlL7N5hW0CMMWQBBBoL3w/J055+O/eKLphBdmFmmT6RUanTBiqExiLYmYK32jUiaNrWeMB6rMS0XOQGZkGjWtFpMN4MEEFlsfXIeEr+xNz76HBM1KTSwfXriMBKzhFQSOqIgbs18Hv3uq1OZot7T8bwmtVLOhkfFmVqCV/+ZE/dOUWO8wesFJfJD/cK4DOpJOqEE5tE/SuImTWofOMggJgs9dQeCSdkrmr1ldYAzv+pWt9eeuDw6lRfDVYgpVrD+5D4nt2j1YQJUINqBEvjOR31bTV0hP3AGQzJH+oXxAnEHXZSJCuR+wIRUwCLwLEiqC5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Cao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Cao-Ruichuang/mm-vmstat-reject-invalid-stat_interval-values/20260411-085547
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260410112554.23165-1-create0818%40163.com
patch subject: [PATCH] mm/vmstat: reject invalid stat_interval values
config: s390-randconfig-001-20260411 (https://download.01.org/0day-ci/archive/20260411/202604111811.THSgZ1ry-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260411/202604111811.THSgZ1ry-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604111811.THSgZ1ry-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/vmstat.c:1968:18: warning: 'sysctl_stat_interval_max' defined but not used [-Wunused-const-variable=]
    static const int sysctl_stat_interval_max = INT_MAX / HZ;
                     ^~~~~~~~~~~~~~~~~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OF_GPIO
   Depends on [n]: GPIOLIB [=y] && OF [=y] && HAS_IOMEM [=n]
   Selected by [y]:
   - REGULATOR_RT5133 [=y] && REGULATOR [=y] && I2C [=y] && GPIOLIB [=y] && OF [=y]


vim +/sysctl_stat_interval_max +1968 mm/vmstat.c

  1964	
  1965	#ifdef CONFIG_SMP
  1966	static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
  1967	static int sysctl_stat_interval __read_mostly = HZ;
> 1968	static const int sysctl_stat_interval_max = INT_MAX / HZ;
  1969	static int vmstat_late_init_done;
  1970	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

