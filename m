Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7ADCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 04:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6787E8E0006; Sun,  9 Nov 2025 23:56:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629878E0002; Sun,  9 Nov 2025 23:56:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566868E0006; Sun,  9 Nov 2025 23:56:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 437808E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 23:56:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4FDA5CC4C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:56:20 +0000 (UTC)
X-FDA: 84093486120.23.C62D687
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id A50EDC0004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:56:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GSfVHs5p;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762750578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UVMuljYoDwAYzBVAbxFd9TGVKOm8H2S8GWOgUpf5RXU=;
	b=AIclwqkHUiGwtLdRS8cUMWuVmUHj54OM9NxThdWlThs2MUjZ+eFziL0U+Z9mk5z5DacRSU
	fPVputQip2dN7SBMsETAnH+iUPuGWTxkbai2hTyD0lKEYT7s5HOY4dUEQFfElyhICcinxc
	vSLZOoRIjJmLHqMtCOPkwddeMHg9ARI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762750578; a=rsa-sha256;
	cv=none;
	b=lILqFlZOP15044EufyG9S06Z47um/AIooS6z68FzwPOcuyaGMRRbqvFbD3n/BWG/xqw4TL
	6SlSBedxViChMf8I8SvhKI9k8JsKpoNadD1/oeSwePW0MWGh/uQAFa1M7e0O5EbkbHYOYK
	hf1uY6NlynuWCIZQPB97y3maHmCy980=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GSfVHs5p;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762750579; x=1794286579;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=o4dnrJF/zL3tHnHkxUrc86rJ5TDlOtv/Mscs8IBPhEs=;
  b=GSfVHs5ph10/55vGSbgEbsnEZxTOVDrc3oOsbEtH49/uNL9BGeOcniWO
   w/AS1mgW2fS201/5tM/EHwuO359EVCMqWv5sg+wl1YjWA7usOT+dsXw4U
   yMfyfZLdZwfZG/qFxIs0PvA/GVeuwXu/tJkd/nMRjFGVXKazmUhVX6cKi
   iwatoWw8w2Evoe2qeJF6m9TYU2yGjrJ5dIwjdjK6j7e1/R9aWfwkQchY+
   5GJ0L9WYLelPrP4JxldfiL0wau8FAVJbG2hFzDwIds5UrI1IM7OCO5jrq
   8eakH6qLdhfNnZN1ViERh7Qoxu6VFJG6CcDbo/dydqE5aTy5RmtR778ro
   g==;
X-CSE-ConnectionGUID: OL9vmCNbSx226kbDtg70hQ==
X-CSE-MsgGUID: HKlzw5BGQCepaI5ggwiEzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="75408531"
X-IronPort-AV: E=Sophos;i="6.19,292,1754982000"; 
   d="scan'208";a="75408531"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 20:56:17 -0800
X-CSE-ConnectionGUID: XaF4WF3KRhubLCU1e3NS9w==
X-CSE-MsgGUID: mznSG5n8Tamnb+dOdu8P1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,292,1754982000"; 
   d="scan'208";a="193591058"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 09 Nov 2025 20:56:16 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIJws-0002fT-0y;
	Mon, 10 Nov 2025 04:56:14 +0000
Date: Mon, 10 Nov 2025 12:55:58 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 291/296] include/linux/mm.h:944:31: sparse: sparse:
 incorrect type in argument 2 (different modifiers)
Message-ID: <202511101223.yntfHDDu-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 1nubyc9wun8g96uuee5c4mzfz6engou4
X-Rspam-User: 
X-Rspamd-Queue-Id: A50EDC0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762750578-668072
X-HE-Meta: U2FsdGVkX1/ZTvVz6iu9175/jM3K/n7wlmfB0mLtRcmOOK6Qx6Q7r6cW8zddghV3xbSsV2pgsYEHoRrJEEQ8eRLXMNHpZ3a6ODHpAR+YrI9egkR0J/Rz6M4kwdDVzlKpGsQotaeLW3VmWEmpFHUefd3f632SvifLwOhtX03HHJ1iLfct7QxwkMDnz/xnBRXylIF+S/WeWJF6KCncKP4AoU0C+SyKupggf/050jshyKbyxZKrpIQ69E+0GbDQf7xkNfguuXTcfGeUejm8PANpFSvFMJHxiwTIaf+nyEJ+UDm+t9t+L6ZdwdGr44N61TvNu/1eP1jGpUo9AGyX+wbLTuf292Db/6QsMDzqQrCbayzvu/Ov0RDEzF4HWV6MzP0XggL/jOAJzkrYEMqQotXkZtmeHd1DPTEeNRkVhnH3IJmJ/0tNthU0COXrz41xNxclurDkKL58jPtYtuCtNayXi/AWiTGJUXoINPO5y4z211ssxo0I5Y398yPEK70lm2iCMa5Q56g3SCTL7Be/1W2S4IdgELaCpYXZHfwD5LZeHJHK1xZ8lIKciRKP6A/WuRPXGScxbsfTm4nlw1qavu20t7npTTz+mvyACOEoWUFzq2wSwe1pLN4ntdIrVRWxU9supd6AU6i3m61hG5SRYGnoPTEuDjCbXq8sNRfpGH/9mGOwTeNO0Kl+CTsh+7TIDmmOYKMDPDiYeirUL93igjKafl9HqYQLKPFs4iXZEQVw0ILwykM3MaRAcJ4k0m8ZgQHcskD+6UpiLcI4UAMraIzABD1o65hBHoV3POkgn4BU4YZKOLHX0CIesg3lyx1+2p/HPQKlTaLNVip/M931c8EoUZhXQ+ujPUQzhsNwMnvC21ZcSCSBEkm/hrPFPhyl/FEedcm5iT3lZfQ01sSdC4B4vMfaO9O1dksxqtNZTxg0SmzNGylgjOwVDK+exT667vMhbT28UVmIvu9jhzCKdRh
 +tKnnM58
 8WtiASLW7lghYGxcAEP1QOqf3WYUayuGt3VIELQ+4unTKbb2kZ9xD+2kDrIl1P1NyCaNlfk7Fqh7BpfnWm0vQLwFfcjFIhOt3Z1bhq8IOeTwrt87MwFyKWxPc8SCLoHMvD+Ak+YNRdOX5cScKDieV8YMqZ/MCUvJ4BozLhl7t+CIRlMN4ImAuY+8CX7FjHOT1WVBKEtr4qUhsOT7aj5XDK+8MwoV4BFLWFVadQj5LkzDYjVTSb54hJY1pXQ1YzTPrRgor3jBHTeXMoT0N3bvOxFzk5bV5n3jcUAoms/F11U39Ekhz7MMsIJStR7VHJDmD+292FszahyJaPGt/PjcaJDRXs7fByozLy/fi45MyX8kuVq1SGJ6+1RcTqL6/PMxNQcBHOHQkCvvKZCAdDc7wfl/TjfibWuoY6K3Sys/wNBlibpengWuKPYGBlWuQIjYaLYs6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
commit: 85de428c7ca1b71457690b95e162662d0edb2792 [291/296] mm: set the VM_MAYBE_GUARD flag on guard region install
config: csky-randconfig-r121-20251110 (https://download.01.org/0day-ci/archive/20251110/202511101223.yntfHDDu-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251110/202511101223.yntfHDDu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511101223.yntfHDDu-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/madvise.c:562:9: sparse: sparse: context imbalance in 'madvise_cold_or_pageout_pte_range' - different lock contexts for basic block
   mm/madvise.c:781:9: sparse: sparse: context imbalance in 'madvise_free_pte_range' - different lock contexts for basic block
   mm/madvise.c: note: in included file (through include/linux/mman.h):
>> include/linux/mm.h:944:31: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:944:31: sparse:     expected unsigned long volatile *addr
   include/linux/mm.h:944:31: sparse:     got unsigned long [noderef] *

vim +944 include/linux/mm.h

bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  932  
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  933  /*
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  934   * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  935   * valid flags are allowed to do this.
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  936   */
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  937  static inline void vma_flag_set_atomic(struct vm_area_struct *vma, int bit)
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  938  {
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  939  	/* mmap read lock/VMA read lock must be held. */
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  940  	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  941  		vma_assert_locked(vma);
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  942  
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  943  	if (__vma_flag_atomic_valid(vma, bit))
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07 @944  		set_bit(bit, &vma->__vm_flags);
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  945  }
bf91f4ed2a530f Lorenzo Stoakes 2025-11-07  946  

:::::: The code at line 944 was first introduced by commit
:::::: bf91f4ed2a530f2e55e7b202c1692a4c682888d6 mm: add atomic VMA flags and set VM_MAYBE_GUARD as such

:::::: TO: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

