Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A78BF5A8DE
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 03:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E736B0088; Mon, 20 Apr 2026 23:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F106B0089; Mon, 20 Apr 2026 23:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454CB6B008A; Mon, 20 Apr 2026 23:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37F0A6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:31:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B86441A0BD9
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:31:26 +0000 (UTC)
X-FDA: 84681137772.23.8D4AE5B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 407EDA0008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:31:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BM3wZuQJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776742285; a=rsa-sha256;
	cv=none;
	b=D9r4WfU2mpnC9JXNXkLt18hNficC1vepMJNYgJCd0+iJv3HxSrJcgmn30gaQYSnMN0i5Qp
	DHGJca7oY0hV98Uj7dVST+LzjY2HACBrNa9mlkH4xcfqRX5hBafwfFbz1jdSpWYYTkgTJF
	OSD8aCoZDAZ2m2BGIbdt11S2ro+ZJUY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BM3wZuQJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776742285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=qlSL6ZNmNgygPkLFoje+dKbyMd0e6MspEOJRPz1PSiE=;
	b=t+MUHp52oR0Xs/sUIlYvP6D1T9FLka3ZvfbsTyrFue47eHkS4Urby8TqlzO8zL1VcHdYEC
	bYc9A25h8nKSqPelaKzOQp8Ym1KWjofmbOLy2/Sjj9d3q58YAncSs+XKHQX1P1Tzvq3tlt
	QD8BzocRWKUUnMHV8nfXLS91jRdFJAQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776742284; x=1808278284;
  h=date:from:to:cc:subject:message-id;
  bh=qKz+q3dhTjceIzN5qRESOwrGR7RS+2kVm3F5LnTnQOc=;
  b=BM3wZuQJbKys0HBf4M8WP4/NZOYDFqhq/VBeTyH/EMlnytV89BFvhmS5
   +WBXMAA6dadvk+shnxozKgcO9aDfQt4uWFJtKZQtv1dLvPZpoC47COOS0
   66AnoMFa+ngYy6w89OopyGzbgcvF78XF9FEKo8gD2KdWjPXnncMZYO489
   wnUD+m2H9y/OS0MEnj6/dF5b0K70bKc5DOOso4pZKJ7m6SBhap2z7HWuG
   TKAZ466Su6JnRDbwiOM9z3Pvx+yifnn1eA7O3zVPkZzk1P384tNQhpKzo
   AcHOmC+aRO3t6j3e3S+jIR5XDS8IMYCOGyiniZXGTDXSykWWZMoKIuaH7
   w==;
X-CSE-ConnectionGUID: PoIMeOYGRiCFssnL+AhYcg==
X-CSE-MsgGUID: N6w08yRORD6VsV4/idjLFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="77792177"
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="77792177"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 20:31:22 -0700
X-CSE-ConnectionGUID: EWxYd6uERB67xIbROvsGCQ==
X-CSE-MsgGUID: tKfP5lSsRRuPQdEg1aI4uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="231779962"
Received: from lkp-server01.sh.intel.com (HELO 7e48d0ff8e22) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 20 Apr 2026 20:31:21 -0700
Received: from kbuild by 7e48d0ff8e22 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wF1pV-000000003BS-204v;
	Tue, 21 Apr 2026 03:31:17 +0000
Date: Tue, 21 Apr 2026 11:31:07 +0800
From: kernel test robot <lkp@intel.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: include/asm-generic/tlb.h:609:42: sparse: sparse: cast
 truncates bits from constant value (1000000000 becomes 0)
Message-ID: <202604211126.7cN4M93P-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 407EDA0008
X-Rspamd-Server: rspam12
X-Stat-Signature: pg6d9k8rw4fj4disfpurno758os9o5b6
X-Rspam-User: 
X-HE-Tag: 1776742284-50826
X-HE-Meta: U2FsdGVkX1+OC7YoveXlZgM1K2LqBrvwnmo9bteKUeWFZ5++5673TjQaT2SJVZb/+XcgRNyR7z6dU5/R/Wtq/4tChugYzRyQbWuIRtyEkFqkWvwOxhZOjiMJ83eN9NLhZjJKVeNMVpnjNp31M6v9hzFZ20gG+SpUNnR95eud0w0O5ExiHys8R9b6QQ7XGHJjKg9s8Y/tCSxeHhI4I6swaICVDdm5C7QGRUs/fPnZjTFuw5V5po9wemCEQGVP6oN6iV4SOgQcibi2bfFqo3tl+5qZMzcfRuiMtuTb14LjtcjWIUEFrb3TYwURjvk/XD4uBeVLDkURpfqSnKQdwz+nmf+khYk+5Cg/wHt0Bh2J6RyrFLZ6h0zRZ41rWLx3JHbIqDUlK4SjsszBPQriVRweQokfS9KM7wr2ADc8gO9B+9hwoUu7qWfAcKhb0smutAbrCAuRpRMnnNTXTOczixzBuU97/FC1BkYZ6ONf63Bft9jVI+8k6qstAuqYrpt2+3LbVNVWkmQEtNiZLBIRRRYSQxcYJgo4njcO4vfJxdmnBCNQfnFDLtho+mrytjAENLV6viH2MLzVF9erYoALL7NY5hbhdmeNKgGAhl0jwqrl6QntiD4dim5459PtjJVdbTr1gAkDZYKUuES9k6i3pgLscEbf/FZBNkyY2u9OKTWJT9puU4a5etiPuzVefn3Quq+px1yStnSfqX+k8AyBI9zPbUA0IngG/dZJREHQkY85xZD7K8QCSllTpc/zZHbJRf0Gtq5R3E/LkUH1ouOWJFPondS9yEI4nLPPKCS89uDZcWaabC51Oi2bZPGLqVW9DMRlApMqQ95rAeeZBVzpN2giMNDDxu8oiIRmL3W17LwuI8mbOsaQrTUM7sdBg6aSmK3mJzPcm0lb/zD4G/Y/vGTEwlhSB9VXSE6OwOpcfq24/J9McKjfkVP8P0iK77NdFU4L72g6SeZ4S4sKy4ercNf
 eIKjmVUr
 9oovR8ktY+hBahCkHCAXW8wIV0TncW9Zk5c9kq+SMCtnSGXkWRhDnMXzmiSm99FLFh36xkctJTM+BhFnmx+Os5IdxKSDvqVyP+//E+1g3UOh2VLs2PnGqMTJT05HCWJ9r9zEYNjb32ZyR/ixrLM/yMHj+1cyjR5uWFfCK7DPOQKdq9LNMr6NM/x+8UnKCWuVUV+VgtkgVgx9C2be4Gy5GB6DZbPB7kVe3SYqFjnqLKyAn1F4B/fnRM8NmWbquk7lvGZUKxaVrduNKrJ0UGI70+F6bWEok/repiUHCKhLX9YxgQ0U0e0VkXGY06N1NGYFJ+6pe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   b4e07588e743c989499ca24d49e752c074924a9a
commit: c090868f59ce888db838cf543d18f731d13ed498 Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
date:   7 months ago
config: arm64-randconfig-r112-20260420 (https://download.01.org/0day-ci/archive/20260421/202604211126.7cN4M93P-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260421/202604211126.7cN4M93P-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: c090868f59ce ("Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604211126.7cN4M93P-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/hugetlb.c:665:12: sparse: sparse: context imbalance in 'allocate_file_region_entries' - wrong count at exit
   mm/hugetlb.c:736:13: sparse: sparse: context imbalance in 'region_add' - wrong count at exit
   mm/hugetlb.c:803:13: sparse: sparse: context imbalance in 'region_chg' - wrong count at exit
   mm/hugetlb.c:5778:20: sparse: sparse: context imbalance in 'move_huge_pte' - different lock contexts for basic block
   mm/hugetlb.c: note: in included file (through arch/arm64/include/asm/tlb.h):
>> include/asm-generic/tlb.h:609:42: sparse: sparse: cast truncates bits from constant value (1000000000 becomes 0)
   mm/hugetlb.c: note: in included file (through arch/arm64/include/asm/barrier.h, include/linux/list.h):
   arch/arm64/include/asm/alternative-macros.h:232:9: sparse: sparse: context imbalance in 'hugetlb_wp' - unexpected unlock

vim +609 include/asm-generic/tlb.h

2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  605) 
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  606) static inline void tlb_flush_pmd_range(struct mmu_gather *tlb,
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  607) 				     unsigned long address, unsigned long size)
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  608) {
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25 @609) 	__tlb_adjust_range(tlb, address, size);
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  610) 	tlb->cleared_pmds = 1;
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  611) }
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  612) 

:::::: The code at line 609 was first introduced by commit
:::::: 2631ed00b0498810f8d5c2163c6b5270d893687b tlb: mmu_gather: add tlb_flush_*_range APIs

:::::: TO: Peter Zijlstra (Intel) <peterz@infradead.org>
:::::: CC: Catalin Marinas <catalin.marinas@arm.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

