Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76E2D31A06
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3506B008A; Tue, 13 Jan 2026 21:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061156B008C; Tue, 13 Jan 2026 21:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84856B0092; Tue, 13 Jan 2026 21:26:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D57A36B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:26:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A63C13A932
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:26:09 +0000 (UTC)
X-FDA: 84328979658.09.B5E5951
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id C145C40003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:26:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NGhYKPki;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768357567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpasUW5efjHKW/7P2YJIXMH+i1/CaB12ixI92yNTx9M=;
	b=HElOvgYCw41vzzZVP/LqXqolinT1KzQ9Z3X6TXRdIGcbkLcyzxLeTM4GusPi9tS/4fSnCJ
	Hukxq6Yf72aP/mpaMx8mkVyD0GDbRrXjdp86e6eFCfNN93p77lhZ1LqyPH3FiSDJhGQvB4
	ZEoeOTfXS4RKZheZC3SVy1HSNI0rNXk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NGhYKPki;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768357567; a=rsa-sha256;
	cv=none;
	b=0QjLaePZCB9u8LxJ0MNl8sL633jnoEDKJFwQPEBiyJnWfhcTeJDldy4NNbkc/XsYqGt/hP
	heDxvo4/oSNuUts1oPeNg1tF0o7VIOjq/FztBpf5TkMjXglFzB5S5ds3uEjdvo/burF0G2
	5eEi5Wj90KBrBOm444nKtdnogR0BdQo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768357567; x=1799893567;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6FGNX7SUC1hVI0mJ4eI4bbSwWtwvzYUDN6Xf105OGeg=;
  b=NGhYKPkiaeObX635pYYzdBbItxst4k70imLg3V8a1X3Tzk5AHhRk9z3z
   vX/MCiDnRBUG1JEFBlQCqum13WBHSQGQL8Il76GgyQUYzrLPsYsLxaITA
   W0lUgqnMHgy1SmM9jfw5m2IrjMkMyq5gsJKsFcfplxcmnDD7dUo6WwdHP
   vnyyVSdWm7gEKzM6gN2sbyJfvpSztbml1KBQI11+gPc0QM4F7clJvY95b
   010aKmm5SVEaKfr9wyBHAUr8MqcwUONePqYDXV9r5AGNLI6fzKWbr54Co
   4VddSxMyKW53KDLuYONAHC+8hf+2/bE/wfJJhvL3tru9GLw08MVC2///y
   A==;
X-CSE-ConnectionGUID: 7LorZZcOTbO8yRoL15Ou+w==
X-CSE-MsgGUID: 7BMAJ1rNQ++pNEMwNHIxNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="81103227"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="81103227"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 18:26:05 -0800
X-CSE-ConnectionGUID: lIj9MRarSHWCSWdMeHN5Fw==
X-CSE-MsgGUID: 9EF3wqrhRvyGQuw+dOtm2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="235799047"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 13 Jan 2026 18:26:03 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfqa8-00000000Ffk-2PQU;
	Wed, 14 Jan 2026 02:26:00 +0000
Date: Wed, 14 Jan 2026 10:25:58 +0800
From: kernel test robot <lkp@intel.com>
To: Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
Message-ID: <202601141042.qJuTeEP0-lkp@intel.com>
References: <20260113114630.152942-4-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113114630.152942-4-marco.crivellari@suse.com>
X-Stat-Signature: xyfedcnmh93qggngsd6fcxnwkrznp1od
X-Rspamd-Queue-Id: C145C40003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768357566-930133
X-HE-Meta: U2FsdGVkX1/EZaGnEV8+2Okd4pvGWsdQ03n06ZMlx5FrasHrZNp7rKEjumSEaHBB6wkrpoGqbW6VWvXZurweIHFayvF+dbVzp1VtengU9OhYByzVQt8Rgw8KJ1A1qFJqVkXcYHM2QdtaCC3S8beyk2Tcee9dfmSz1VdZ6S74Q/Gqke0dypN29QYUb66m1Z8+u3ehDXuaSCbkEy+4PjiUbGLJRjVFy5jfbEHfExqG8bVGmJsLmkXu3U2taJVXcwyQpwMKTEjaqzI7+Q+1gnFlQY5C/5dERb9uO8si3kUWWjuqVDFWsN/qWvNMiiZTVJUsfjtqMDEQR8wJJbZFckWOrHuV0OUmhxRCrQwIcVoXpg9ZGVsJt03ZmtNN6dmBFV8i/HuEFgCfBzIiK5JoCCHXIj0IeSU6Ku27xNzMY/3kCIPO8Njgjfb/Wn8aGPG2TxxjdBlzYnuCjMkjxFl8RJvhVSgOjq4jRYE8QHzOdgZqoq4JT07bpzNXPyT+A6NGCMAAoco3uhJk2PiPaU+pPZc15oTqr1pp5+jTOqsCY+0TOA8CyNjIoXEm/TWF+/xc/1UA9UZdcFvZ0PrvZpZAYjY60/okVyBk+i9ci5GR/oUr6ps7Y3vwv4bwsv2aDCueyvZQDeS+8SyTQHSqHXNrys6WBd7qyx4EVywvnAOmNL2NO7xkYovqttNoVBhEu5yxf9ZM36a0nKvJBrR/Nt4dJlo7IBKSN/2nMJpPlwwZauwZ2gRCJnVp/291Eu64BuWxT/jpTv5OPijfrttViuQwsYlsWEvKDIGOjvirM8f1eBb0AwnyrYnY7lUxotlyVEvtM65uH12pYrtzPd+QE0EnbV+4Vu5krbLKfTeWsUKFQnweSDqB5nuQIdLOvX6EBuVs1WogsINqO1hK7YWfrWtRYkUdTMn+Xuiyppm3HNeY1kCb/tUoJymfHbgOvHILsKmrZ0/LBkqpYrZtGAwghKi1Coj
 tCjdlGQn
 9twWlxX0C5Q3C/pByJUmEMyMMjEglD/JoNiTkh/XD9eFkwvIUGO8KiZvnHTzR4xyP8Um2kv2X+leV7K32HmD/aQjBNFs4yBvBVGjg6GbE771upgyXeGrnGwqyQxi0VJ+gNzVDc53tO5AI9OR4dG5LQdMVrKbUGv4l0R4qg+B4+WkMlAdxj+nNTY7IIf/o3Z8aBbTJMXZ0xW4dX1zliID9NJ7NCekChrLCbWb08t9jQ5bIUNKK7BxA2EOm+JQ8YsydoLTJsQwqByGCWMOsvCWmoy8w6ROmXdn5voY9wwOoYhiqIV1/nKWHGomLl2hyVHryvT65gbjkj09YRI8cNLpnEyQR9/VFxHS5qrGhFafcoI8z53pB0w6vrxeauY5qZUofVSn2Pk41Z2aXWTK8MHPN/zrufhi+XBXupAiskrNMALTiE9LZkSgamGUWgPUoYzlJbYzgPTCHH2oI0sNctKjOxoAZ7KBhiK6l2jswu18PJKSy/xG+N3OWB2B5gA==
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
config: riscv-randconfig-002-20260114 (https://download.01.org/0day-ci/archive/20260114/202601141042.qJuTeEP0-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601141042.qJuTeEP0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601141042.qJuTeEP0-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/slub.c:8545: error: unterminated #ifndef
    8545 | #ifndef CONFIG_SLUB_TINY
         | 


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

