Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C4DBC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 15:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FE16B0005; Wed, 21 Jan 2026 10:44:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993C66B0088; Wed, 21 Jan 2026 10:44:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9C56B0089; Wed, 21 Jan 2026 10:44:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 785426B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:44:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC2C0C2402
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:44:50 +0000 (UTC)
X-FDA: 84356393940.20.6D9B1D2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id C189620005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:44:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LyMZ76YC;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769010289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Hm4/1xREjrcogMyVsBDQK1Qp61mllDKrUCORsmeD2JI=;
	b=2QsXC1DbFv1Xv1rkTOxHekADFmc1eReJK3hTMXW2rKrKlSZRHTpLxlfr/+xORclzpNHSQ0
	X14SfZQfZYcP3SYkjf2fDrT8Trz1CUZObaju/mMI7r/icxuxhzFGaAztDWa/oNEk4CKY0m
	iRrCW1dSvy6eRHNPbsvLcaOlPwyxQe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769010289; a=rsa-sha256;
	cv=none;
	b=q0XMuPp5g7sILlDn65/ZXZ4xHPzkzFw4ks+1bVsN/XSAz8cY0Yxfh/X1HRwxanBlDmmOPy
	CPXj68lvzX1xgrLiXmPfDT9YOtTbXF96sEqP11BFMeeix5xaWVcPueXgPksG8x9xNR16fb
	VJjpnYwp/QFKw6UakGQwx/a4lZzFTZo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LyMZ76YC;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769010288; x=1800546288;
  h=date:from:to:cc:subject:message-id;
  bh=pDy4BfSLAn84EDfUvOkKtsrCnZKTANceUixnr6zv7DY=;
  b=LyMZ76YCbCJJGrhZhq6ZxJ83PCMmpB/1XbLZygltYtMqlRaMp6m561JE
   G9L8b9J7PbgbqXpwCU2roeKOLwwTqEHY9jgNFDAdB0asKoHeUMRgMHFdO
   CQ7bOOkPgsmr2al4FgRydyxVUNKxLWUWl3HmUmxLl02jY/k82q2eF+iVs
   fez/6Zzqi4t+ZoN8fm+n6cp+DMW1ugpnWv77dHCfNGiAmllg11Pv9KcHj
   kisn4dk+ja/PLbLMP52mbD9NPy8n4Pl+R+wHV3RomveYRveNAW7AIZJsX
   SxpmHqGMv39j+wkP1pRBZ1xg3HPRJuXis0sJ7Nq0BjvEWGde8xgITxt3N
   Q==;
X-CSE-ConnectionGUID: 33taohGGTziM5lksDg5QWw==
X-CSE-MsgGUID: fbf237VMSvuiQaBGpkThJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="69435063"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="69435063"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 07:44:45 -0800
X-CSE-ConnectionGUID: TmcEmGjHQLWEAqixi+tXEw==
X-CSE-MsgGUID: 1QFVINlsT6iu7VK6AvHGrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="244055679"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 21 Jan 2026 07:44:44 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1viaNs-00000000RMV-460G;
	Wed, 21 Jan 2026 15:44:40 +0000
Date: Wed, 21 Jan 2026 23:44:07 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 414/422]
 include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef
 expression
Message-ID: <202601212341.LQmq1CzY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Stat-Signature: 6uoagcn9hs6z5x9qzy319ehnni4bt1cc
X-Rspamd-Queue-Id: C189620005
X-HE-Tag: 1769010287-984542
X-HE-Meta: U2FsdGVkX1/CPmNShCvB02+mfkJOkMmuaKGBZPJct8ES96SZ6Ul+UXa1nbUat7NZV6YfYcJbGfavZKPTIdZz0pKKScevnjqiBlpCJrUlpdWGDal363wyNArWnwf9qu4TFFxSLGeodZBasJIGirA9wLfZv0I7+46LokyrpoDttXVr2RoQZ9ztAIaZdyl98UoRmFRye4iEOZq/7FTKbjPK0iWFAp8eWOpOW1zakWhC0Ydit1M+GwqfDBaA7BrP+cZTJZ5pil4u9nTh03FckoQ+bbN5AjM5IycSxfq5ohzIbrRZ7nN5TRl5F5lmX1mz2UCH50gW4M/q04WkAuipO4zl9U0Nr+wEXXIvb6fj5iPOapa10ZFo5OqEc6Ug6Kuf3Y96E+ki16pfYdEha3VChgHTvrxYS3cJYxJ+qFNgFDdxdOUHcxWuFNtPREeMJvIl+a3LiBWurBoWY2ozMUgvfen8UQOntmWEOkDNPDJv0iLnPRDIEh8tacQbLQk79OzzNw8DSgpMvg3K6n/nl30SHz3Hd5gYjmFDlL+/S05znm5IoFAOS8OjpHitxjE3bl2tssm0MbzT5siwSBBkR9CG0kqYzwHbdiPNStlYdhADaJRX7P1DuJpw3DmyEwoNiN/DjW3VbPDrE/MLfsLkvA2Kze329F7u/k2XA8C6A5LaKolwJRcp+9IeBOPuQ3woGMFxQRlBOTP5Gb0mJKBc+2Hw0he1HBXH+ECU+IzpkHbqYSNhwoAebUBxQ0GpEjHZrBjXbTGJh3cnolg0FkzxcJoCKhgiXMQ48baWvvOHieF3nenRHxT4oGK1SyoKlHZAq/1+Uin7hx+96FLpp6WzxsGL9nGg1SDdlhwqBj+D9UwPsPyOVR4zc6VNKLs6ydcaOYf9NBpQUrdpzJL2IbM0GEm3B0eVQVvH6An85FOY/FxNi/GUdB4Q6Z1b+KeUDvpG+5I5eMgOf5nxTDkn58+Er9vAClI
 PH32kAiJ
 cs8IS+f9uDtv/5WigZdQnZJnWVdagslKptwR1FzDy/SDsrLxBI2dIe4EFJ44X8+svo9b+gD1CiO+cnr/BANQnwTS+a1uUZbFpkdOrZgNTJPdF/XyYEUU+FluTiLEXO/5C7uBXEhFxG88+LZrbpH0FzhfKlEA8VLnYAN5G2b8Tux5pceiwr34WsTdwa/wSH61Avko0yh4leq86DMetiyfYyIX4UtbhDUdcJdaRBrqcpdZEQ6XmBpQyrH6lWPhpVk+EJjRVlXmzvAWZAPPEAeiTmST6yLYaWzmrlXAzaC9g15aRaWHasfWdCTg/8Q8YykJz4UwzpV2V179knwM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   74daaa378c853e693bf1822327648b98c7d491ec
commit: b9a7362d7bfd71c7db3c40aa82816ed3209c3967 [414/422] mm: update hugetlbfs to use VMA flags on mmap_prepare
config: x86_64-randconfig-122-20260121 (https://download.01.org/0day-ci/archive/20260121/202601212341.LQmq1CzY-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260121/202601212341.LQmq1CzY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601212341.LQmq1CzY-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/hugetlb.c:658:12: sparse: sparse: context imbalance in 'allocate_file_region_entries' - wrong count at exit
   mm/hugetlb.c:729:13: sparse: sparse: context imbalance in 'region_add' - wrong count at exit
   mm/hugetlb.c:796:13: sparse: sparse: context imbalance in 'region_chg' - wrong count at exit
   mm/hugetlb.c:1196:9: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:1196:9: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file (through include/linux/pagemap.h):
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file:
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file (through include/linux/pagemap.h):
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file:
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:1197:9: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:1204:9: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:1204:9: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file (through include/linux/pagemap.h):
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file:
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file (through include/linux/pagemap.h):
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file:
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:1205:9: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:1219:9: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:1219:9: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file (through include/linux/pagemap.h):
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file:
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file (through include/linux/pagemap.h):
>> include/linux/hugetlb_inline.h:16:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c: note: in included file:
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:5098:20: sparse: sparse: context imbalance in 'move_huge_pte' - different lock contexts for basic block
   include/linux/mm.h:1772:22: sparse: sparse: context imbalance in 'hugetlb_wp' - unexpected unlock
   mm/hugetlb.c:6588:13: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:6588:13: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:6588:13: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:6597:22: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:6631:22: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:6668:22: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   mm/hugetlb.c:6732:22: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:36: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1181:53: sparse: sparse: dereference of noderef expression

vim +16 include/linux/hugetlb_inline.h

    13	
    14	static inline bool is_vma_hugetlb_flags(vma_flags_t flags)
    15	{
  > 16		return vma_flags_test(flags, VMA_HUGETLB_BIT);
    17	}
    18	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

