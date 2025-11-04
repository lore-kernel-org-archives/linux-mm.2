Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DF0CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 06:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572E58E00E9; Tue,  4 Nov 2025 01:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54AB58E00E7; Tue,  4 Nov 2025 01:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487B48E00E9; Tue,  4 Nov 2025 01:03:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 364F38E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:03:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EE1E58CA2
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:03:25 +0000 (UTC)
X-FDA: 84071882370.21.5A34E51
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 716952000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:03:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iSbMj2jN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762236203; a=rsa-sha256;
	cv=none;
	b=xLGN6uUHGLSNP3jr6l0T5JE4GKJODvMI1vQeELD3guUEsRqCj8pRY3dgFENLavEA2wcn1q
	Ewu/Dr96/QMnOhCIkFzdZg2HyrU77Bgc/xFDfSiORidVeMiGhCUy4KMYqM5AXlz4Efd/i1
	1SKJMT6z/G+ECfscU5NQPXMac7/Xwxc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iSbMj2jN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762236203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMG43XGmFfY2+hKAKyU++HKnP6RudbWJPMtaLwgOqLQ=;
	b=EUnw2op4BpoUDDsoiWUd/DTxIl4bTMbF+uRJfm6Bgj5FbRD8wJ45MjkjSfr0H/svjZMgT/
	00wSnZSFIkMF9szeTy7eoLfI1JXXpQUTaj/c2CHl4bSUusBLfNQVOPDXjvsDsyBnBWLEh1
	3tclGP1nTA4MSiINTxwGWNQ33q6VrJI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762236202; x=1793772202;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/dL1gBSTItHzBoVba+zlzvDJWscPnr+j+9zMFRaFDIA=;
  b=iSbMj2jN0xKfBVLLYCrT3Y4e6CKnNZ+tmccpZUCtn3g0iohI8jtzzkZ6
   3VRp88OSchnuAGkbcxaT0jqZnU6tqk55HV3D82d0b8Jfzdfvc1QMWnrKP
   RPhWd0/o3T0WClZh0c/hqg+3nzhyKT2WdONY1ZhWldSbGTYUrpOU3JWdK
   S9yP5xe8JfCaEWawgjD6ohnhXE+3QNHSQlg55dRn/0p1VAM0oU5yPk49J
   1aHHgW5eegGV+L8eFo3IE31ixrQr7cMoVsXzmUK3PYxsCxB3r+Bsm1WdJ
   Br+Q932jtSn6OzLiCz0Ux6tNwa0qYy4iW0ToexseIwcDgPQS+6N8M7IAN
   A==;
X-CSE-ConnectionGUID: 4j3raXzOSTGyvrLXtO3m4g==
X-CSE-MsgGUID: UexSp5aQRTq2ohqwOVu60A==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="51894021"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="51894021"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 22:03:20 -0800
X-CSE-ConnectionGUID: qsZ0NbiXT6ukdTHRh+FeNA==
X-CSE-MsgGUID: t7vmxUyhSVeSFQnjNikDfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186928092"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 03 Nov 2025 22:03:14 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vGA89-000Qyq-2I;
	Tue, 04 Nov 2025 06:02:59 +0000
Date: Tue, 4 Nov 2025 14:02:13 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 13/16] mm: remove non_swap_entry() and use leaf entry
 helpers instead
Message-ID: <202511041345.8K1Nt70Q-lkp@intel.com>
References: <b4925aeaf6b7e8255b1cf1585476b718862b8104.1762171281.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4925aeaf6b7e8255b1cf1585476b718862b8104.1762171281.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 716952000C
X-Stat-Signature: ag33ksrtp99emmow1mcimgcg5go31yj7
X-Rspam-User: 
X-HE-Tag: 1762236202-975136
X-HE-Meta: U2FsdGVkX19zQBJkqrN2Fy0YOmg3lgRuprQD9+0RHIxGbBCexlncF0khfhP2FN6EnH6l+LBYgj5pJOGEk8EyBpe8tLUdmnopI0/8iHPHmU9MS12dqJP7P2tZnNmaR5fr5rN65B1/jUUVDtxBjlQw/f1jDAGa+aCvrszuSUgA/yarRvbhdGj7SwwHP7r0COzJCfSfx3LUI26E8zmT2ljteDptHhy95St26hp9wpM34HmmfLjDt8IHRtSXqSLuE6SlpoSzBsWEU5lOMoED0vkEnhYUS4ToN8/xZO9wzwLkpDuBhp7+OkJ9Xij4d4Ilxj+1NIyH+HzPOWIrqEFI/s5Tm2kRuKL/cN2v8q/faTcNDxTkMPfgpuaBIO9W8wOGIkKqcMZ6NYLqCsGvV03veUQ4sE6gcWczGahooUfa+dYChvhEY9lnTABOkfposrK81uG0y+Uqb5JMzpGNCaxglLhrWILeWXi7PnQjIMarZ2aPw2ejMBYHuVtWmCjcZKZuCpWCMecdgsJikHnH4KK+G5B+znyAaUwzCCOfEYCFMzg/q4uvahrlCs6WFTEGCIGvEBcRNXuVoMoyNQ35pnXDcDFjgGKEN5fik3r6CWPOCqZ3CmOedRvbLL5uzFRBVz5DULTFeAs+exRSLF9L6iXeeRXXbnmsbMbSu36aPFKuV/ZRYTxqM9lM2spFlwrUiLDk3lsQLL4HxhVY0beosNx9WSdO4o0xkxWJggsYzW21rz+Cb43tYUmKC256FEStw5jfF/PY3mX2PL2hd91ix2WIGja38SvWoVk6E/IVkNKGf2HM5wAf0PzGSt45cQ75ZDHZgVThIGLbFjJMNQsm1bZzSPTrieEBxyLsiKfdE+h1s9HWOSGuyZgVy0zCLP8KzkA3UtYukr/mMM2FpL7T3fU3LsyXMcEATxpW38k7AzNcLQrcxM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-correctly-handle-UFFD-PTE-markers/20251103-204118
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/b4925aeaf6b7e8255b1cf1585476b718862b8104.1762171281.git.lorenzo.stoakes%40oracle.com
patch subject: [PATCH 13/16] mm: remove non_swap_entry() and use leaf entry helpers instead
config: s390-randconfig-r112-20251104 (https://download.01.org/0day-ci/archive/20251104/202511041345.8K1Nt70Q-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251104/202511041345.8K1Nt70Q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511041345.8K1Nt70Q-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/s390/mm/pgtable.c:693:47: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct folio *folio @@     got struct folio const *folio @@
   arch/s390/mm/pgtable.c:693:47: sparse:     expected struct folio *folio
   arch/s390/mm/pgtable.c:693:47: sparse:     got struct folio const *folio
   arch/s390/mm/pgtable.c:1098:9: sparse: sparse: context imbalance in 'pgste_perform_essa' - unexpected unlock
   arch/s390/mm/pgtable.c: note: in included file (through include/linux/pgtable.h, include/linux/mm.h):
   arch/s390/include/asm/pgtable.h:2067:9: sparse: sparse: context imbalance in 'set_pgste_bits' - unexpected unlock
   arch/s390/mm/pgtable.c: note: in included file:
   include/linux/mm.h:2832:9: sparse: sparse: context imbalance in 'get_pgste' - unexpected unlock

vim +693 arch/s390/mm/pgtable.c

4be130a08420d6 Martin Schwidefsky 2016-03-08  685  
9c8ce56552b434 Lorenzo Stoakes    2025-11-03  686  static void ptep_zap_leaf_entry(struct mm_struct *mm, leaf_entry_t entry)
1e133ab296f3ff Martin Schwidefsky 2016-03-08  687  {
9c8ce56552b434 Lorenzo Stoakes    2025-11-03  688  	if (leafent_is_swap(entry))
1e133ab296f3ff Martin Schwidefsky 2016-03-08  689  		dec_mm_counter(mm, MM_SWAPENTS);
9c8ce56552b434 Lorenzo Stoakes    2025-11-03  690  	else if (leafent_is_migration(entry)) {
9c8ce56552b434 Lorenzo Stoakes    2025-11-03  691  		const struct folio *folio = leafent_to_folio(entry);
1e133ab296f3ff Martin Schwidefsky 2016-03-08  692  
a23f517b0e1554 Kefeng Wang        2024-01-11 @693  		dec_mm_counter(mm, mm_counter(folio));
1e133ab296f3ff Martin Schwidefsky 2016-03-08  694  	}
1e133ab296f3ff Martin Schwidefsky 2016-03-08  695  	free_swap_and_cache(entry);
1e133ab296f3ff Martin Schwidefsky 2016-03-08  696  }
1e133ab296f3ff Martin Schwidefsky 2016-03-08  697  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

