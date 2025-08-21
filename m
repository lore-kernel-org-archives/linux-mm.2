Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22CECA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF948E0007; Thu, 21 Aug 2025 11:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8298E0001; Thu, 21 Aug 2025 11:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004CE8E0007; Thu, 21 Aug 2025 11:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E00E38E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:41:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E8C3B98BF
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:41:58 +0000 (UTC)
X-FDA: 83801180316.04.DEF68B4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id EACAB1C0011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:41:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SNq+YOGd;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755790916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFujwjOobJab/PHnaVS6I93YKfifsK+pWuWP81+mbU8=;
	b=4729Fd42V5HbWDUcu2h7o9zluy7hHcpoVOiPMrpp32mH/1Cx1FnEimi456zXoc+HBKlOgS
	UL9kd6SD2S1uyGqSSn8wgFHymWgBCeeO02A4I2/2xFTG+LMCmAWiIwzuUI6FGwpKNScEiX
	gN+8R+LG9oXvXzFqqMaws1ocq0Gd0iM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SNq+YOGd;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755790916; a=rsa-sha256;
	cv=none;
	b=0GH/wF/ZQje/6nXiC0JeJM8Yj43jIcFZ/bkQ34FbOjbvXuqUa8x8fz3ya3xXZ0U0emNdMq
	4NQDPln/L535z/TUYysth2Uidmcridzq5RWC44PGQWtv6s21EPrkHBZpQtYkcM7Jlmp66d
	1TPVfAm5K2X1j/tgghD3gTEDqvCS2Rk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755790916; x=1787326916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H6FymCyX3zttd1fv8B07vYL1jBQbCibbvO+W+weuLB8=;
  b=SNq+YOGdYxfmwqZPnI0Q8+xE+/xb00x30GRPWmnUa3+tzkGWrJuVfiH/
   IGEOcKBbxWPPE6XN0YWAqwgZmdJTpdy9DSj6lKHpZLCHfZLyga566j8Rx
   RX/YknnlZAiwjBNbXWSYu73GbI9fUtpJCcUT135wF4Eu9PfeDoD9XW1lk
   ww7sepRMoqBLHHOrbqMetdWgkcuP5VCTS7lEQgNHV+xREuIp0Sv5gTPyo
   EdTQPFGGTyRAj2cwAmErCM+vkUTHL7H8pdRwEY4lSN4nG8/Lj43dv8W8y
   H2m2PVDXSviWsUaM/BSCqUsFv/sIMGJQNWlKEINqMXpbNIco1ExwguyiK
   Q==;
X-CSE-ConnectionGUID: vXDoyAZwSXCvcnYo4I0D0w==
X-CSE-MsgGUID: eTdekydxRh28rVS6CoEx8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="57287785"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57287785"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 08:41:54 -0700
X-CSE-ConnectionGUID: lQ9aarQrTu2EaW0pOZX6HA==
X-CSE-MsgGUID: H+XEDi3gQFW9Pwghmar78g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="168358824"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 21 Aug 2025 08:41:47 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1up7PS-000KRX-0Y;
	Thu, 21 Aug 2025 15:41:32 +0000
Date: Thu, 21 Aug 2025 23:40:42 +0800
From: kernel test robot <lkp@intel.com>
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
	bp@alien8.de, brauner@kernel.org, bsegall@google.com,
	corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com,
	dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
	jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
	khalid@kernel.org, liam.howlett@oracle.com,
	linyongting@bytedance.com, lorenzo.stoakes@oracle.com,
	luto@kernel.org, markhemm@googlemail.com, maz@kernel.org,
	mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
	mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
	osalvador@suse.de
Subject: Re: [PATCH v3 11/22] mm: add and use unmap_page_range vm_ops hook
Message-ID: <202508212332.AB4FbJgR-lkp@intel.com>
References: <20250820010415.699353-12-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820010415.699353-12-anthony.yznaga@oracle.com>
X-Stat-Signature: ms7e9zgmu4urfk9tog36m4a1ijaog3ox
X-Rspam-User: 
X-Rspamd-Queue-Id: EACAB1C0011
X-Rspamd-Server: rspam01
X-HE-Tag: 1755790915-289707
X-HE-Meta: U2FsdGVkX18I86BkWjGzp/Sn9bAgGzgE1ohnY/k1F2XGpOq2kbsdRPXCUhLiZ8AHlY/6R+oPBiAkLURMyMgvU+1nrOMJtZxSShK2Pwqy5pCJv5gk5/f5EuamIsJQPDorZnmJ/8/Q/E1T1EwrhZLuTsWcy7aev0njyDYJWnKjtzgcyDXp7TR8vVqh+BrFUBrEVwlWsODvGpMMsXuxWwsqbqM+6Ro9GE2iRIf6ncxfeg6UbaUN4xJhtAiESYy7qBK5rcGpFaw4uOdPw/uFuiSfE9D2G7/VAi8WZTGcHceB7CbUIqGzYrMAebgeDYsXg6SQlUKRzTCi1d2R0EsTmv0rUhMt5dZBZFIdoGXgbUB1psGy6EZP7Lq1qfV7dD0c+O3PSO41hDwOOeq7Qg3rqizyrpzADKYWENbiEVjG5cv4GZwFkYq5D9DBfBUE5bUEJ4tSPGd7hHbbCKcLGFRpwvNEW9s/idgBVU/3ZPaYnU6tSiupd9YNQAlIPnRuwBAqpYS1ZOO5xLZOH1SMjg924stHestZkYK9o5PRejONDUGRRPMUFL8sQJPaodFUZ3kuGftmcwI4zMLe3XxAOwU6jNRqfqIHioRlgv+ppVGr3IjDsrtkFWFrMJLUBPO+auYEjH5/OsqqmRmzX37BpSqYKeGAAP6JC2Gagt97rgbhhqvoRAlr5W3F/a0Sk7Vwhe14D3910nyB6RvQxceHq4vRPbft/rT0jkv+Hyao5fxvNTced1RRLDMuFnapb97HadQQlDmHSsY2ziUwQOjqTB7PHa0674sdWjmJUgy/PTcVvxEqnwqTvrRaT+zWJ6q7bXXbtfXdnWuqzTNf3AzcrsurHfm4UNIdCPAt+b9oqx+szC1LiR0J/fYOJY4ctOmqHvO+3pXQCIzxd2Ep5Il8ezhkAERXdPWrvRGfgBEdNaOB+cjVx4Oy8zg6LgvsbIcyYfIPe9gGFZxLQHWk8EkaCWwERJj
 df/Xoxuc
 QG5OXiFUzSW/JjIYZno1rBbIjr9bC+gjfEyWkGxNI8gqRcInygJG92Ph1njeREUYG86s/rdGOUp9gbzrI0n65lHgxicwGcS/DuKkbTbL6hOnuTiStpO01ILMxrxVlUqSsPrQb0Fqw2VYX3xhrgIaHv5wOR+vuswcBUQ0QKR6V6Nwb+AvjtqS8+x0UAP2CjUOG6brWLO2ezkRINnqGwepxuywGH3l/fDEMB+kb2PmCHlhYMi6FyJotqt0FM/NbwtKLWehxsGbyS7qh1hxqaEnUKNAHi0EmjT92Nq4l9RIEdwJHD5ZdORj2+IBohUvStUn1915tMV0IpUkjFL9yiKKLgGi3yvXZhOW7qgSQru7FO+2lxJFB2ReGbPiwQV/xtG1W96U7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anthony,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[cannot apply to tip/sched/core trace/for-next tip/x86/core tip/x86/mm kees/for-next/execve linus/master v6.17-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anthony-Yznaga/mm-Add-msharefs-filesystem/20250820-091021
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250820010415.699353-12-anthony.yznaga%40oracle.com
patch subject: [PATCH v3 11/22] mm: add and use unmap_page_range vm_ops hook
config: arm-randconfig-004-20250821 (https://download.01.org/0day-ci/archive/20250821/202508212332.AB4FbJgR-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 93d24b6b7b148c47a2fa228a4ef31524fa1d9f3f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250821/202508212332.AB4FbJgR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508212332.AB4FbJgR-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __unmap_page_range
   >>> referenced by shm.c:604 (ipc/shm.c:604)
   >>>               ipc/shm.o:(shm_unmap_page_range) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

