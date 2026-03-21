Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC1C1099B3C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD486B008A; Fri, 20 Mar 2026 22:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4FC6B0092; Fri, 20 Mar 2026 22:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB5C6B0093; Fri, 20 Mar 2026 22:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 258A96B008A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:34:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3B44B97ED
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:34:57 +0000 (UTC)
X-FDA: 84568502634.16.025DA4C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id 225DB80006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:34:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qaa94Gt0;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774060496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=P4bcmdn2qO1Lz7K67hHkc1wDeMF9i4ZX9JQ6HPSYALU=;
	b=jMl0YxHRFKwe3Rv7ObYHyrh2qWrh2z0bmCs+7uf3T0TaLVyp6pLCuo6xuAEYpm+iw2J8S7
	SyInItp4lh13lzT3OtOfQlomhqPhdv1Mr+MB5cyYeWISExgjiQOwjjnU7wDgu9zbeKmEVi
	5pyXZn0MGMiTsEtLDO6vqcvMPaVsiPQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qaa94Gt0;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774060496; a=rsa-sha256;
	cv=none;
	b=ARW16eMIOND+wb8Z3+cuUWjHjvG4wVXLFLNTSiaZ8oHMvJL1LjcONG1OJSW3rhtm9v9qcU
	kkH7nbFyKJkTtsoqUrMiFuNytaQ3CWzRxfbJkuSbLX4YV57s/NlVgDP66Ho6j0l05ScmTx
	0hRPg7QKcPhqEVDK6BOQVWwsEw7yQZM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774060495; x=1805596495;
  h=date:from:to:cc:subject:message-id;
  bh=4rlyY9C75uqg5g8E+Fn/nIluEnDFY20ZEhVpzZ5dGkU=;
  b=Qaa94Gt0eJVQftToA4Wg7QKduWWJVgGr7tYMDAG3TAPtCuELaAoaB+B8
   fzPA/FwGXuELiivs3O64SFrkx3FG4NRm7ySxCtunEtbXqe9hNp46FegD6
   99KO+b/54nEfm3S/QalNWic04Hz4BcM5RtmbBBTLcS1tuQGof+T0bK2ew
   bbFgQD/ATDXMtKLipfXXinNUV1G+AflemkVhhw3C9hq0T21aL5N2vaLhb
   edQdY4rod1pQ95ZdP8OYotcH1CVsMBOTxeMPgOY+TbrXB+emnwsaGoAHR
   Fn5YSB6WERfcr01Aw1PU6wm/azGInsjOscbe+INO6ypSDH9/wrEreaPuL
   A==;
X-CSE-ConnectionGUID: 7SFrALzZSSC+OFNTo1iOjg==
X-CSE-MsgGUID: s2Iupy9fSNi1avnnAgS/jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="77756171"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="77756171"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 19:34:53 -0700
X-CSE-ConnectionGUID: ukhpyTZ8QASrpd1utdKURQ==
X-CSE-MsgGUID: iLITr6QOTIGxJyW3x3uj+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="223499154"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 20 Mar 2026 19:34:51 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3mAr-000000005NF-1d3n;
	Sat, 21 Mar 2026 02:34:49 +0000
Date: Sat, 21 Mar 2026 03:34:21 +0100
From: kernel test robot <lkp@intel.com>
To: Chris Down <chris@chrisdown.name>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [akpm-mm:mm-unstable 433/449] vm_util.c:133:14: error: too
 many arguments to function 'pagemap_scan_supported'
Message-ID: <202603210319.P5MPyTEf-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 225DB80006
X-Rspamd-Server: rspam07
X-Stat-Signature: cpidehokuj1qukjtg4n1rqhh1q5983xb
X-Rspam-User: 
X-HE-Tag: 1774060494-970074
X-HE-Meta: U2FsdGVkX1+hBuatfGnnazVo25r9WRDPPVABI1nOa8S9SQsdAtDvjIIqASOCZE5cY7Ya3afUJhBw1kJiHokm1xF6Swn7k8Rt4CwY+PNgqSUZMxpN6+a55X9uMDx36Z+xP1V98fwVRQRUg0PuH+nVUfZKFWOg+Up7+XlqUgc5uWhBP2dsO2Z5thFKYKU1hUwIg5UJmzOgdUef9kqSOtFbov0W1sP3oiHMz0X+Q6wKFzFavJGxGV4Yfx2Zj/6j5zMh50mP7cn7mdYuDnTyQAw9VbendeB6wNtBiS+oMl5tdWp0X0E/IQni2utfH5isxhQNdU4H16ewpcU5Gbr+sxSbH3JL7gPppEvFWebBZ4A6DV1fBQFPL6M7CXycvDDK+I4IXiqCrLy8tNfLrPVnWB97jVFcFqdR2WjLyd3FmcADublzG6NtUbfyMGOnJcszIqyctBTu0jno3/SOo4F4Rsr7bV0z0x5OT2JjfUimY1vm4jHpZKqPmK8E2mp1gVPJl+NQz7/6TKp2yTAOKbldHdZZRnZHxlM8sFhU4KrGvUBF/cH6xIhySWuK6b0tWOM/WdGIJ6J86YiTzvI9zu89ElTVCwZy0AIWSEew0KLqmBrYdY6GerWxH6H7bzq3fS0OFCc6RFPEAF6uspVPF7fdRqvEM3XAuHAB52fTdTwU1qzKFi9GZfzdn2145m0uXMvkWo/sXwJxvh1TMLok11WuVkKjuLmNMECW6ShzVq8eQZ8gXp7Y9exLhBl4MotdzRfchx4ZLu9xeCPVYC92pQaldBIFowYTdK6vv6aTvw0DiwZgVdZz0Zmh9xSmFvu2+Yfo5VZH9K4BysqMI0Q6bNlwdVzNcA0q7uvmCAhZ+3r4qFnF0LLf71V1k36RGg4ad7/6vMkhPk+njhP/fvSgjW5DzGvtSwHkEXmD9QarPdMw9Vn84MiAU2o9dUbiSipmvwWPvQwLyYtqGXrGOpdrt4/HbP6
 aL/TCBYU
 1FL165MugTB2/oRPa0VEl0zeQIwlwqWRBhcWdZrME+QaHm5KgJ/oUJvvZaUxcsU1wr5dvGAFiKpyOELq6kocUtcSnGLpHt55BAvkfxK9pIPlgqb232SUBV5JLu98CWbUgRTqzMXN3iTKklhH0WeMA9LSllAIFkM41ufkO7nlMjZiRMgzAzS9VQHGEhPUgrT995J2a9LJn0y3aJitIlsi3chd9RLQFx1zPXuZnT1cEmU5gi1quDkKfmYsvSaI3ZKBlYDNfdpJNh5d3hyf46oUzwph7XcS5cGUkXWXQGECn402kqKsNHWO6qud+TzqEPx/520zXo3/f38wEvt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   28edd9c5a25ceb76c2d4e55bc5c37acd7eb0fc92
commit: 6fa1bf6b010deb50b35d2b2a7c97e7e229f2747e [433/449] selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260321/202603210319.P5MPyTEf-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603210319.P5MPyTEf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603210319.P5MPyTEf-lkp@intel.com/

Note: the akpm-mm/mm-unstable HEAD 28edd9c5a25ceb76c2d4e55bc5c37acd7eb0fc92 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   vm_util.c: In function 'pagemap_is_huge_zero':
>> vm_util.c:133:14: error: too many arguments to function 'pagemap_scan_supported'
     133 |         if (!pagemap_scan_supported(fd, start))
         |              ^~~~~~~~~~~~~~~~~~~~~~
   vm_util.c:70:13: note: declared here
      70 | static bool pagemap_scan_supported(int fd)
         |             ^~~~~~~~~~~~~~~~~~~~~~

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

