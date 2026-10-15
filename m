Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E45EFCC6B2E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 05:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB696B0088; Thu, 15 Oct 2026 01:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C596B008A; Thu, 15 Oct 2026 01:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82586B008C; Thu, 15 Oct 2026 01:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8279B6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:07:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3F291208B6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:07:56 +0000 (UTC)
X-FDA: 85323678552.27.3E744CF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id 406048000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:07:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LYrwO2Ou;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792040875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZSylkghn0hdtGw504CdgkwUfQo8JryElEWFk3OQf20=;
	b=XJL3YSf01qJoEzZgsDN/wAifknQamjPPbAWkeW5U+rMkKrJl66/uFz1OKwQNPH+IIuUNfk
	ub5Lm/06An72BpFmxcnJDgOgDV21ayFd2eouIFK0KgTfs36e4B87tb7KKb9DYa/jzbpXk5
	cwEshqyo3ThZ96na/6iENlugyc5KyqE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792040875;
	b=qf5jqk2Hs3+B6bvK+BygovDYaBkMnkJgRCsSBy1IKXaCyELpsBRyuweioBWmIPRasY/p7F
	sex+z5rehzfpkhNZALP8XHxMp8hC3fI0ZoG+A7BIBhLGLClTgNH3JP80EOlOtoZONs8B2Q
	I4GTaCTYLkoPVCIBlEhdUDEl3VBZynA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LYrwO2Ou;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792040875; x=1823576875;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GDkcSrZZLMPZxLwziNM3jSo8wJh7MM3T+70vE87ZBL4=;
  b=LYrwO2Ou4Kpo+wcwOhE8yV2rhTOTbDPgppuIqwNr1aD/VJc0zOZC0sV4
   EPHfTbBfWu39hOwhwoPMUKdxt/U5xkxN224UswflgxuMl1Vqdg+LAyaqZ
   vB+MKp6IzQKxUIO/IRc9HrXsEdyPFwDkRx6A4/AXrJ7my+YP31wHtij14
   b3Cl7GDoWUMKg3rxfJEKjgkCSqxBhfu7bZ7SMj98oHNm+Y4sV0FE6swDy
   6IJySW67smRw6ssX/+O9xy3QfOn2sYLEm3tHxBUAIwwnEyTps1HRYIiEE
   OUG43vaPvVRLSlO3Eqmj+UKK9Dn/Arco0CdsMFOtLImLdCBw83oHaeang
   Q==;
X-CSE-ConnectionGUID: VIAV5DMvTcuO92LtcENWmA==
X-CSE-MsgGUID: WbzOXHDhSXiiB6rShR5wfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11935"; a="705785"
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="705785"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 22:07:53 -0700
X-CSE-ConnectionGUID: vWmQz1fcQdOEqrNQm9ZkVw==
X-CSE-MsgGUID: pi78vQZ4TPmTkOcNhE/Opw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="3360663"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 14 Oct 2026 22:07:47 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHDgu-00000000FqN-09LI;
	Thu, 15 Oct 2026 05:07:44 +0000
Date: Thu, 15 Oct 2026 13:07:35 +0800
From: kernel test robot <lkp@intel.com>
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, gourry@gourry.net,
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com,
	peterz@infradead.org, mgorman@suse.de, riel@redhat.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	vschneid@redhat.com, kprateek.nayak@amd.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Li Zhe <lizhe.67@bytedance.com>
Subject: Re: [PATCH 5/6] sched/numa: do not feed tiering promotions into task
 placement stats
Message-ID: <202610151319.1QoCU2Pd-lkp@intel.com>
References: <20261014094347.99157-6-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014094347.99157-6-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 406048000A
X-Rspam-User: 
X-Stat-Signature: j5qrh88i3yckc787799pbc14sr8bz7hy
X-HE-Tag: 1792040874-3556
X-HE-Meta: U2FsdGVkX19y/gSnq/gqnL4BiBIb8o40c0eaV5OSrpNqGkzdNkjQTeZPtKevjGuqpQpaoQXndfCuBOMyZslpq3EBd6hpMscARHHJ2LvvPM2BueO7XvzHxnb+VHDs6/2FpIAxgAD0mUN6SnYfBbmIpTvjhDOepO2SPPyP3Bk/eVNU8tlS8EJMFCl8JsFNCMa1gaRy4S98SPTlxgyS0kWohvb5ZM/0hnqbDLN5FmA+v7hxXMN6M0x+rMF6OnFHKjRuBI5b9VqWa8w1DORazoqKo0hfkcWcDbcmu950KJldP+Ln2UIRIYpegiWY4SjSaJp3bLJ/uvqW1lhY9UXF1lGqhSTX/mTMEIZTzCDLx1rpnB9xBh4jkyIRL8SoW3B/bVuPgUu6srSWtDXmDYD1g2dcrGXoe6lnhrgUQ7kvT52mib4QWxOZF1LI30RbdljN6e2uP0v9z24mtNkEJNaOoO57U2abk4bjlKvFwdPiAADlR42AoUFdJzkaiQMvNA7A4Ep+IGcynytKMdP+Y4M0y5KXx9Q1bbI9X8SfQpL2FtIkGGhWowjp5Ma8m52saprTDSPOCq1+JsXkYwEJkDfdQ39j3+HNlnCTuX4Vw0sRTIVWaFCZkTyqI5vSL91zKOuYfT/cJ1fZde0tf6WQ/EwO6QzMGa5YZUjnUZnAArLLEUMC4MAE4d6xG2gFz2JRESmJPGaLKSVwY6dmhUSnioICCYG6kTyUqBd+XfZ4aad6gPcnreCx5tuAoSrAabfndkGkW3PdEAeOZYGWKIymAXB4Dd9KxY1MobHyxvWnijKQMeY6+115eopyb7QopV1y8ChZ+aZedz82QTU0ByVdRyQ/fE0qelz5iAmwfxGkQvRCk2bp9SYL/RwDuRC6y3BIXIfcY1v2Dt/6wF8Ihs2hI55opnvlEWy5Ouuu/OJcWL4wWo2AKfAE64vZCBFXJWYT4qmpF8t1F4KIbt09O928l+5ErJm
 GfoBg8l0
 rTSBBL3XS2gcGfMcwK5VS1fx4EA1waoBwlS2oki+EicF7H1fq6oeHfimbg7Vb29dBWWkKhBVqMuQH6dhqyV5KBxAs3C9nD8Qmw6LNHw7fG/Rwq7enGlEEJZVCNwhGsMzm7T0NbMlJvILm+PPTroFZY0suiv6Sozm5RB92+v7DvQtjpmoiU7uhbaEelAN8cXo2e8iUCVGMZOrg3bfCNWOKRkOEzZYZPtEdY7wTG3em3HYRtRxSehKzI0EHNc9jVLOR9eaAJgucG05qVvyqhGO28thBErQ79VRAWG4Disv/GW796d2ZgpTIZWNABR4u1FiJYVvGcGBHVkg/RDS/WDEz9Op9/DFFMFOr9A/viaNV/xU4Enax9WoGMMEGAnQ5nTPd83oLBjWuHksKa2loISK9TsgfDqs2viT2vMysE+6TFZE7l4FnG+sny/OU5ZiAsejLO1vjKRN8mThlQTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Li,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/sched/core]
[also build test ERROR on akpm-mm/mm-everything peterz-queue/sched/core linus/master v7.3-rc7 next-20261012]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Li-Zhe/sched-numa-clear-fault-locality-state-on-execve/20261014-174342
base:   tip/sched/core
patch link:    https://lore.kernel.org/r/20261014094347.99157-6-lizhe.67%40bytedance.com
patch subject: [PATCH 5/6] sched/numa: do not feed tiering promotions into task placement stats
config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20261015/202610151319.1QoCU2Pd-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 6719b9e31d6a93099612c474eec76d9f41d0275a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261015/202610151319.1QoCU2Pd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610151319.1QoCU2Pd-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memory.c:6176:18: error: use of undeclared identifier 'LAST_CPUPID_ACCESS_TIME'
    6176 |                 *last_cpupid = LAST_CPUPID_ACCESS_TIME;
         |                                ^~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +/LAST_CPUPID_ACCESS_TIME +6176 mm/memory.c

  6147	
  6148	int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
  6149			      unsigned long addr, int *flags,
  6150			      bool writable, int *last_cpupid)
  6151	{
  6152		struct vm_area_struct *vma = vmf->vma;
  6153	
  6154		/*
  6155		 * Avoid grouping on RO pages in general. RO pages shouldn't hurt as
  6156		 * much anyway since they can be in shared cache state. This misses
  6157		 * the case where a mapping is writable but the process never writes
  6158		 * to it but pte_write gets cleared during protection updates and
  6159		 * pte_dirty has unpredictable behaviour between PTE scan updates,
  6160		 * background writeback, dirty balancing and application behaviour.
  6161		 */
  6162		if (!writable)
  6163			*flags |= TNF_NO_GROUP;
  6164	
  6165		/*
  6166		 * Flag if the folio is shared between multiple address spaces. This
  6167		 * is later used when determining whether to group tasks together
  6168		 */
  6169		if (folio_maybe_mapped_shared(folio) && (vma->vm_flags & VM_SHARED))
  6170			*flags |= TNF_SHARED;
  6171		/*
  6172		 * For memory tiering mode, cpupid of slow memory page is used
  6173		 * to record page access time.  So use default value.
  6174		 */
  6175		if (folio_use_access_time(folio))
> 6176			*last_cpupid = LAST_CPUPID_ACCESS_TIME;
  6177		else
  6178			*last_cpupid = folio_last_cpupid(folio);
  6179	
  6180		/* Record the current PID accessing VMA */
  6181		vma_set_access_pid_bit(vma);
  6182	
  6183		count_vm_numa_event(NUMA_HINT_FAULTS);
  6184	#ifdef CONFIG_NUMA_BALANCING
  6185		count_memcg_folio_events(folio, NUMA_HINT_FAULTS, 1);
  6186	#endif
  6187		if (folio_nid(folio) == numa_node_id()) {
  6188			count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
  6189			*flags |= TNF_FAULT_LOCAL;
  6190		}
  6191	
  6192		return mpol_misplaced(folio, vmf, addr);
  6193	}
  6194	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

