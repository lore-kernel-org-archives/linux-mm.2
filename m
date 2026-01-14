Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1508D31A03
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111B06B008A; Tue, 13 Jan 2026 21:04:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEF86B008C; Tue, 13 Jan 2026 21:04:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F362F6B0092; Tue, 13 Jan 2026 21:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1BDB6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:04:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FE69586C8
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:04:08 +0000 (UTC)
X-FDA: 84328924176.02.D9A7FDF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id BB5CE16000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:04:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YiIGzTT8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768356246; a=rsa-sha256;
	cv=none;
	b=UfZUG2IAaFq1zhlIKhOWO+ZnIfxXB/IUxO4TF04Is6Vur+zmQTyPAWh1XQanLdzKVWlOOS
	5jfmWZ4baImYrCgaHaW5+SXBlIjBw5Nr+um8Nb6uNnKPwA4nO6qGYO8hjmiiF3oqoT/5zN
	oiuhnLsm3iEs1FlV7T7CdAKrxWbHLOw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YiIGzTT8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768356246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZ+G69ZUPDP1wjW8zGZctdexQneChj3kkJxkOwOXZls=;
	b=XB67UhLZ4nzxOg3L5K0GNk7Uf+G9DuhY5ZCWGPQdk+t01N9K5BUbl9MUnMEyuJy0JvK6nS
	NbaqMXpsmzycB3/OYKs+zkKFZO1C6AQPtx7np82kVL/+/0D9ICqvKD4XwOynOSPqVaQlRT
	cOBW8GsHUbwWfXSojhndLi8TEllZkmw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768356246; x=1799892246;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bx1odVcIsFTuNbU+nOZRxpPhkHzBMU0U7zpCDJpaVXo=;
  b=YiIGzTT8geQQAax78t4plAVK1rzLhLs+qT1MbNxeu7vhboKtA6WhavVo
   kRHUCthiz6+z8E5J8sSGxVIDv72djBDA68E0W214ZWnfXlMKF/zodk8Oa
   mr7l6eyN3vtlDMX8iUhSzU5Bj/ONBwxNIdqMv/WJxgkXL7keG/tMz6LfD
   tvHzWRGbNFIegxo31Zn7+nF3k09wCWpcEu21MFjsDe8Lman7jQpMlbXbH
   D21zpc7NIy4+Gb4WJlrrQ7+EniXTEVRSWih+XugyMaPLfDN+SxVYaL+/e
   cg80jxIINLmQQ+5Bt10Lknw8KryU4TMp02ntmCctohMFrRIB7+RsqKxQo
   w==;
X-CSE-ConnectionGUID: iOhk6G1kRViSO7vsRNeybg==
X-CSE-MsgGUID: QPk/krDJS2+AsqcKByYthg==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="57206898"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="57206898"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 18:04:04 -0800
X-CSE-ConnectionGUID: YYGdVVPzRZyibvUSb2jL2w==
X-CSE-MsgGUID: CodrH4jVSyeJjtLQfMFHJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="242077760"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 13 Jan 2026 18:04:01 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfqEo-00000000Fee-3WLC;
	Wed, 14 Jan 2026 02:03:58 +0000
Date: Wed, 14 Jan 2026 10:03:41 +0800
From: kernel test robot <lkp@intel.com>
To: Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
Message-ID: <202601140922.x7qD91JV-lkp@intel.com>
References: <20260113114630.152942-4-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113114630.152942-4-marco.crivellari@suse.com>
X-Rspamd-Queue-Id: BB5CE16000A
X-Rspamd-Server: rspam06
X-Stat-Signature: g3863sbtbyyqq9c75bktcaibumu3hwq4
X-Rspam-User: 
X-HE-Tag: 1768356245-939341
X-HE-Meta: U2FsdGVkX186hzj5FPbHd/thuM4DPRBnsbtbS/q5sjUQVkPKT7NUfP4q3jaR+LwVphB1JKgvW0sJUIC3dHhRpgN/x563u4m4GeckDDPF4+1Uq1E9If2gS0NtTGXVIeb8uRs/GT8JOyE6f3DmZjfS29jwSCqvoZLxo/Izr9HRwDtcUvKseCUvt04RpNWd4XxDXNCgUe3bzr3qZ+yi1GePl+z22AREXGkR0Jp8gmgzUcRqv0WAsqnvPMrw37Hw3y0awk12Xef/pF49MJ3rquJYEm5acpvFeu9aYm5fuX1T4BgqV36UpAjbJd50XyHJErZ1GtlihzEk2rY2GEkJf+UEgIJeOND5rJp3xspLPwx8np8UiCGFdSrm4prVrxR83xbMz8ts3PasrrfzcSQr9Hpw9quPLkWudkhd1jqt8FFSz3dLDaMDCphDqAPksKD4/wdn70BhTEFuE/hoEHZDgbAJ6hV++CsfaB854JFMQI1JOa2Q2azLqCN/j23tRvJf8WY8mHDE3wenOiHzBd7iPQJ+Te9ojk5+CzujT1KVmS8tcYZ8tee/8QYJq2d/OMKmwYU/TglBtTd2gzJQZYhe3okLz0ytH+SF8R2WYm1RfS1+ifMPG86I2JK/WJoMZx4mQT8LAO2R1gXNudSqUeqnLj9OL0iacOEbsiJcN/Ad/9yj1ij+5U0HAMRzlyd5182BQID2Tr7vb3ejeCH85Y6mPIVDKwH5vAPUgMagbQTm98b2yg8Kr1zI+KIazrlT7Z0ojJ+wwZx13yioJ8sICl8UjR68OzW9sPtYqqWHpMzJx0MEmaVOPW7GC+WOJDEGNd9PhBLiQxODUPBBOz41ovJLyYqcfq7czdQBLlTKtxMus/ZPr/JhVhBsc+GZ3/wABk1UmiOzquZrkhT3+JHvUU7aV3gjFHBzq+ow3Ka+hYIa9r7bNyv72VGCE43zgr+9X34kwgyH3u9izuCOzHLex1wXHTB
 teOkO7bc
 LRIQFX8KsGK29YXAJ9lG9uhKL2lvd2S2Gz8spzjLKuva+nZrhrMyuMcH6R3X8Gj2QeFOIf/xFA8DX81WkhfqP+ZxHp7TmaUTHkR1fq9HpCo80RV5SbEMhdmdaAt1Fmgwyl3/H6HmLW29Ngvk8lYCFZSx5NWsbEPuFf1E1oLrnzPJxGHAb6p7VNiX4CYHPoGxkB1cNS4sHFUn6qe/QdTQ1YXMMcDbWYmd6Hfd+wXkeCgIHO9uTFv5bzAOxCrbJFwHnLbU8k6s479xG4odf/PgBkW+hbJGfZlXf+n/Y24cnTvI6Aik77xp7quBTsuvqe+gfn45jjSMBsIaBUiPnKVyeWuhYXy/lrV8OOeXEwgPizidAiZmmkzXDLmdo148E2v7UTvibHEu2/JAppR331OP11t9fwjnfPa/GI1CAvuy98yHw+CXju3Fi497sXRISWJ7jpeZzY6oiEQx4ciFo7Zt0a/VH8pXJ3pIBB7I4xJHOKtV5cBBiSbY85E0I8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marco,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.19-rc5 next-20260113]
[cannot apply to vbabka-slab/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Marco-Crivellari/mm-Replace-use-of-system_unbound_wq-with-system_dfl_wq/20260113-195017
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260113114630.152942-4-marco.crivellari%40suse.com
patch subject: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
config: arm-randconfig-002-20260114 (https://download.01.org/0day-ci/archive/20260114/202601140922.x7qD91JV-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140922.x7qD91JV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601140922.x7qD91JV-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/slub.c:8545:2: error: unterminated conditional directive
    8545 | #ifndef CONFIG_SLUB_TINY
         |  ^
   1 error generated.


vim +8545 mm/slub.c

  8542	
  8543	void __init kmem_cache_init_late(void)
  8544	{
> 8545	#ifndef CONFIG_SLUB_TINY
  8546		flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
  8547					  0);
  8548		WARN_ON(!flushwq);
  8549	}
  8550	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

