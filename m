Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14F1CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E7B6B0257; Mon,  1 Jun 2026 01:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD7F6B0259; Mon,  1 Jun 2026 01:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC716B025A; Mon,  1 Jun 2026 01:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1774B6B0257
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:14:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A20B4A05AB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:14:19 +0000 (UTC)
X-FDA: 84830177838.09.21D57B8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC231A0010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:14:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MqS4zHwg;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780290856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=j2+lSxd6cTBVh6P24DniUpKzhQx8Fa2PGtTcwfnAct4=;
	b=yAibmLY/lLxPJ4wNe6xN8lwtiJVzcjdvGYP7NKtP/tsfFLPQBKG+OWWFt2W1u1cBK1To4a
	3yjgCEyoygOtKhUSRBZvh/2ZZ4zt3RjQQ5MounKH5BnE/HykAKU5KcdsKsnDtxuHZhqGDr
	Ia6oLx9IHbL1QOmHCZuuvYkeTpQRVUM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MqS4zHwg;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780290856; a=rsa-sha256;
	cv=none;
	b=sPV+zxwLuLcR9DBzPJlZuBcAcI8Ee8vGa6j9JghwTpgA/lCoG94gDw7sWZXkb/kqEmGBKV
	VQvJ+OC6UDycQ48Wl+Eud2my1MR4Snjja3iq2uj84qB9w4w0CA8SykD8nYhiaYLG43yyvr
	OTRqX3vXYgv6WYmX5Poy7mlgSYwFR0A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780290856; x=1811826856;
  h=date:from:to:cc:subject:message-id;
  bh=XEsSwrxXPnxh14tVWWsBzq/4w2iQD9+xoV501oqp9KE=;
  b=MqS4zHwgNjHFzH4Pw2TG8Q7dsHjplO1TIn5vlVkEPmkC70Ktl66RJ/+w
   2thJQh24MMYXX3SzUEz+7tDXfQGBuXZQ/l+Q/m0XVUEcuFZqk2MH0XoYd
   UpYTHyLKs/OWy/eb04RjEVwlhMyNDSHQQLIH1uMV1wo8ROz6LHXbH8jIf
   5D7dGPYnRrO+NZq3QTXBo+Ii0YN1sApWnktcl3PmBowbh8fLp9tQ4tfoG
   h9aVENWsR/Qmdx1dbV7JFEvyKIeY1LiKqZNaWFp4xpAin/DyL4nfAHmvP
   iMmo+NaMbs7fCU6pnnH33Ps5/JkCDGPtGBfuCkAvsQG7H2d4v6ModLXMH
   Q==;
X-CSE-ConnectionGUID: QIwiApvhRciAx42cjEvnxg==
X-CSE-MsgGUID: 3fq9y52BSYGsYr9a8D/7GA==
X-IronPort-AV: E=McAfee;i="6800,10657,11803"; a="83618058"
X-IronPort-AV: E=Sophos;i="6.24,180,1774335600"; 
   d="scan'208";a="83618058"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 22:14:15 -0700
X-CSE-ConnectionGUID: WOsBk8fKR4CPbaLd+yYanA==
X-CSE-MsgGUID: GJAwtA1OQbabkRO2KsuETw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,180,1774335600"; 
   d="scan'208";a="242410366"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 31 May 2026 22:14:12 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wTuyX-00000000ACg-3Cr9;
	Mon, 01 Jun 2026 05:14:09 +0000
Date: Mon, 01 Jun 2026 13:13:42 +0800
From: kernel test robot <lkp@intel.com>
To: Qiang Liu <liuqiang@kylinos.cn>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 386/420] lib/test_hmm.c:1170:21: sparse:
 sparse: incorrect type in assignment (different base types)
Message-ID: <202606011329.zWs2BKy4-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Stat-Signature: cnp5nrni6tsyuehmdx7ab48g4f5sufxu
X-Rspam-User: 
X-Rspamd-Queue-Id: EC231A0010
X-HE-Tag: 1780290855-677086
X-HE-Meta: U2FsdGVkX1/CiMJxZzK6ikGlSHORyubahEsh8a69Wb9Cl1w8AhoJbq7f5i1b5xvL7vmV1XsEqZq+n22/mjqWMfOmn7bUMgr8qlLGtWu0nAQxbyPzXZnZZovC8th6fn+N1QWmYgoP5y98OCy8nwwYct05w1nBZCGiCxQRZU8RNFeHVPML84wHX5YeLwLw7URjyOHnLv3rJuV7waTZcqRn2gsueAkgJgU0WiEYQHL+YTsjveil4WyUVagmxHvA6JfOSQaWklGajHVLxBtqzyb+B/vmCf5//VldLiI+QaPwlD+OxkXOlPlFSstrDIeG0U87mMcgK467zv3E89xdJHudosoTI67WMTi922RyBHBQQ9qcWURYg/na03oPpBNjFqW63Wsw+l6IoefpyAgg1QAc6YB90dYyu2uWtUB8HaW0hVThptn0poAKU9bOkjOF5MwWuJfuLNs1moR8IfjyMhBsFihDI144TtVlFbPVw51Az/KDi9dPSTzOSd+nz9MvU/xlCZxZVM5fvI7foP7Kfi+j1TYobwIu3yRG6I7gOQazNDxrzzNATVbWw4h1A+MFKK1ZeMvu6Q5EJkdOvMjvprWjtXN92S57k/A1VNcph20Q3Jcp1AUBysRkVKPk8nY4QWcXQEw6+b6DvK+KkWIPkhCXJviW1/DcXscwqLJFRz4fLICurJh2z69cBv+udatm4dHeUPUNOgnCIPSoAfXoLqkAZVsMUjVioNK7xrh3OY+OKTlPd9GikA41jVSNQThtNrJ0TTwgshqfRCgpduxPkob34FXc8agGstDqCjKrVgCeVXwq8LrTX7kqZOIGRnPXq3ebfLxmMROBvGF0DlVJVEe1+OGtWorhLh2KTTOZX/J2wWSlviPlS89ssu5Q4joD2KgufKDTgeTTJwbIgnNIn+ac9zTCMeUo6rKSCmlrJUBsgK0jehQewW4AcxBXR9WQmsIoBKpP/T/GzBK6xlU0SyA
 F9A9OJDA
 1M16TwFm6RksKJ1a3TK6x+oh7zVioGDMpfaHMuWgCicjTba+MEKt6ghgUvf/3/rr6qREdhPdxfrGyGXB+ulVJ+qzMfqk+PnsMgJQ27JSL5g2Kp3KraKEOEqI0JFB2vrt4nZfOpIi6Oo59v2G9ofoPG5p7bL4R2ebbYzVTEEzLOKdvwp71D3K2GdsYeyBE9arOPwDPgX/eE7pFWtG2HjlqLhiq3FAO+vR78fELDldYhDIyjnMsQiPxfMQS3VqcVTltAbkt+HoTzB1uBdcruZzYmV8wXcV9gAsJUsdlo/zzfbE5OfEDBSSAF86IQI0NCKlIXiGp1dy+dVboRBr5f+kHPyvjyYJmgTEc4KKTeHH5JYSD4m3cjSydyJApTmximAmx4Ofu+A9z1nI1ScGD06xn4dMj9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   d97bc98dadda29f23540b8490592962ebcf545ff
commit: d4ab4875497b1659c6c56dd9faefcb4a41c566e4 [386/420] lib/test_hmm: check alloc_page_vma() return value and handle OOM
config: s390-randconfig-r111-20260601 (https://download.01.org/0day-ci/archive/20260601/202606011329.zWs2BKy4-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260601/202606011329.zWs2BKy4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/test_hmm.c:1170:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int [assigned] ret @@     got restricted vm_fault_t @@
   lib/test_hmm.c:1170:21: sparse:     expected int [assigned] ret
   lib/test_hmm.c:1170:21: sparse:     got restricted vm_fault_t

vim +1170 lib/test_hmm.c

  1119	
  1120	static int dmirror_migrate_to_system(struct dmirror *dmirror,
  1121					     struct hmm_dmirror_cmd *cmd)
  1122	{
  1123		unsigned long start, end, addr;
  1124		unsigned long size = cmd->npages << PAGE_SHIFT;
  1125		struct mm_struct *mm = dmirror->notifier.mm;
  1126		struct vm_area_struct *vma;
  1127		struct migrate_vma args = { 0 };
  1128		unsigned long next;
  1129		int ret;
  1130		unsigned long *src_pfns;
  1131		unsigned long *dst_pfns;
  1132	
  1133		src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
  1134		dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
  1135	
  1136		start = cmd->addr;
  1137		end = start + size;
  1138		if (end < start)
  1139			return -EINVAL;
  1140	
  1141		/* Since the mm is for the mirrored process, get a reference first. */
  1142		if (!mmget_not_zero(mm))
  1143			return -EINVAL;
  1144	
  1145		cmd->cpages = 0;
  1146		mmap_read_lock(mm);
  1147		for (addr = start; addr < end; addr = next) {
  1148			vma = vma_lookup(mm, addr);
  1149			if (!vma || !(vma->vm_flags & VM_READ)) {
  1150				ret = -EINVAL;
  1151				goto out;
  1152			}
  1153			next = min(end, addr + (PTRS_PER_PTE << PAGE_SHIFT));
  1154			if (next > vma->vm_end)
  1155				next = vma->vm_end;
  1156	
  1157			args.vma = vma;
  1158			args.src = src_pfns;
  1159			args.dst = dst_pfns;
  1160			args.start = addr;
  1161			args.end = next;
  1162			args.pgmap_owner = dmirror->mdevice;
  1163			args.flags = dmirror_select_device(dmirror) | MIGRATE_VMA_SELECT_COMPOUND;
  1164	
  1165			ret = migrate_vma_setup(&args);
  1166			if (ret)
  1167				goto out;
  1168	
  1169			pr_debug("Migrating from device mem to sys mem\n");
> 1170			ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
  1171			if (ret) {
  1172				migrate_vma_finalize(&args);
  1173				goto out;
  1174			}
  1175	
  1176			migrate_vma_pages(&args);
  1177			cmd->cpages += dmirror_successful_migrated_pages(&args);
  1178			migrate_vma_finalize(&args);
  1179		}
  1180	out:
  1181		mmap_read_unlock(mm);
  1182		mmput(mm);
  1183		kvfree(src_pfns);
  1184		kvfree(dst_pfns);
  1185	
  1186		return ret;
  1187	}
  1188	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

