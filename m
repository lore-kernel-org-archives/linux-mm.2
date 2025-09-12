Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B04CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 05:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00B38E0006; Fri, 12 Sep 2025 01:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA6F8E0001; Fri, 12 Sep 2025 01:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899428E0006; Fri, 12 Sep 2025 01:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 71EEE8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:09:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 291F916066E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:09:19 +0000 (UTC)
X-FDA: 83879419638.10.D077F46
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6324160007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:09:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j0H8PKTC;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757653756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwYxsNqoUYSFgLOSDQllnhi//dNEj1XGsn4w4FAZtc8=;
	b=bfkYF71UC2/hBhwNMiz1ndjFJiwbANKTMqGtuEUKRkI9XFpnbjBeqDxzXTv6g3DMVQg6c8
	o21NQdzm5/W797jn977WT65Gpb0TuG1+mdUEnKroh8FY+DzqhQb67pKQKP+hd826drImXq
	kzFJ+4twnTsjQtAo8oPsHpGRt0H0Dys=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j0H8PKTC;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757653756; a=rsa-sha256;
	cv=none;
	b=nJhlzUmwwjXb5L4as6Fbl87yli1GeWPg0IKit7p8oj6rspXQVSAgz/wDEoBknBaQF2/vUK
	wbQlk/NW5PWnBEPLo819JGY3//8Za0DbRJH4MrqEj8pMesqFhkdixGKLtY6e2C4wJg5LeL
	/3VrD/9Hj1B1H0KB0/bS+ej6clfpCpc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757653756; x=1789189756;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5Sv52k5u28oEP7ozheRx2UKgazKeixsYXp9Xrw63D20=;
  b=j0H8PKTC+vjetOnN2NXFmA9vpjso9wdtaP02dh+ZTdtbl7cZlauCYoUM
   x2Y01nTZQBnZGex71Mg3m9T2H6tn4EyiLe/UTrLB6r7QBAovnnQq3oWCD
   u0DWwROv9/84BjCD4BAhxTVsfpcLkqbGAeIzNZxisk47+Jzxt3uyVy2I1
   VWWkf7i33QvHNZ0aN9DycxxhkxuZYlaTZ6VZmQ1m6e+oeYNFvdfZdgqhg
   VfvFVig6oHKgjW7jjg7cngJAz69I6vpshFqf17k8m5Aj67veOLVw4yXoW
   CC4lZfIoXtj/MI200UloC8bFBP6rZYrQI1lV9xuLZ5CXWQG0n+Y00UD6j
   Q==;
X-CSE-ConnectionGUID: +bWFrzY2RmaU/f+ES+OwDA==
X-CSE-MsgGUID: nq0kRhurQwmzMEg0jqu3Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="59035023"
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="59035023"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 22:09:14 -0700
X-CSE-ConnectionGUID: Chkn6f1JSeqZFCMjjKycKA==
X-CSE-MsgGUID: UIGyh3Q8S1+iLeSJ6X/vNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="173165172"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 11 Sep 2025 22:09:09 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uww1y-0000rE-0r;
	Fri, 12 Sep 2025 05:09:06 +0000
Date: Fri, 12 Sep 2025 13:08:46 +0800
From: kernel test robot <lkp@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v1 8/9] mm/vma: Use unmap_desc in vms_clear_ptes() and
 exit_mmap()
Message-ID: <202509121212.sx5Tfe4e-lkp@intel.com>
References: <20250909190945.1030905-9-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-9-Liam.Howlett@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D6324160007
X-Stat-Signature: o1i3536kuc9qz34w3qacyar5u1rpr4hr
X-HE-Tag: 1757653755-855886
X-HE-Meta: U2FsdGVkX1/xIukqj9zkApJLaFBzGVXxOldkfikXS/b9W774OQ4H01jKG20NxMMkMO1JTv0aj7iJBxyfMqRUlUe4Ta3E7rMA82FNwzqpD2vAMEKLz8gE+lm43E9+neI5Rt1Hks582+ss1wwFPU9rkYwjJ5Nno9myUPFz1G8CNdMe6Sa4KzUheexml21/+SL08i5KGFnQuOGVJZVuRf+px2VyaLolUu2pNOljEhvhja84NtUAnjdZyxU0my8RMWBpMJLqaIrSj8Q/ouh9qs0YHgZHbqus4NB/ylMmtiysdCu3j88VqTutaS0WnoeOA6dZoVZKGP+VzSZD8PTbg1iWAJg3DA0Nl41LcCdIwRiUZ4uo/ViNgJC52iGT1mrAssAHkBxU/jzFIPAfiVRA9ahMsbDL6E+saBWreYrElHOKI0phbMlRiEzYcln9tMuTonlV0JHAmhyoiLGj8ktuPeafhq8BxAZ790iEHTeo6TCITASsWoJCJgjYfyfK57FGEBykKol1UrnoIor3QoJ9CcJEARTXV82kdqz+6rfLCnlaOtpjEulTxp1CB5OtNCJrTriEFRl8BnyPeKoJ4+Xkt2rYrz9BkNKhSMZOt/Wgc+oDnyx8r/u+HiZjZeWMCfcG7ToP8LW2Qupm4EG4QUwL+4xTupTOGjFMlLpUGxr0qFq8Y91jkLrHdp97qR9POpAMT51bMePV0dh/oI75JimA+58RkGbA6QSBUoCj9Lli5+ifZTLJ/aifXEiX0SCOXUt9vgmjuN3hogJZLjRUMAKl/QArtTMBRojHL8cU1/StjkFgo/u2DCwWC3FsrnmrJ/MtouMUcEYDj1qS/nBqjPd8RiNqe2rFrfduC9pXpQ7bTG0TfnFxLbTDUPoUp/IXIk3Y81aIDWjPjlV2GCaiP+Sq9n1PJQM1hplXRyNrITe35JWQr6Bu4pz85wvoK+QkqBejQylX0mbZa7u0O7uBixEx9d9
 +bW6dhDB
 JD0U96kU17a1BK0US8+t69A0TmOzYrm8CWehjqo9AQfRw2SMD6ba7VJ7MHnZWqDukQQ3bg5BHXBvGFhsRHZaz2aVVO6grkNg64T9kkOGWaDY3xiuUTvqvuZ9cAoWC2Gv+ZAVOWeBUZvh0ATjODQqe5FnRhraEgluzy8UmG8Mz85iHh+ghdOg80gPSlFkN9P/CHhvO2rPWhZfiMbCSPRahbjjGhH3Z+UG9dZWsXErA+LKTXNfnwbFQKDeLtZ9B57vA0o/DXgXcEOlUQP1q426s92CieRVXu/4pAH3Yi9r0ZWB1JC4/dKTG1OKss4Bi4Qc+qvA8z1mUKMpcZFb9N651kQANFB9LQ7oJ6BXCs9Xp9gGQCsPYGTFWuPGtGcVttC1p89TqjkJoQVVIjMbAIlMooY+nczKtb6YcCsHToIUEbLW3+L4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[cannot apply to linus/master v6.17-rc5 next-20250911]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/mm-mmap-Move-exit_mmap-trace-point/20250910-031555
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250909190945.1030905-9-Liam.Howlett%40oracle.com
patch subject: [PATCH v1 8/9] mm/vma: Use unmap_desc in vms_clear_ptes() and exit_mmap()
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20250912/202509121212.sx5Tfe4e-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 21857ae337e0892a5522b6e7337899caa61de2a6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250912/202509121212.sx5Tfe4e-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509121212.sx5Tfe4e-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/filemap.c:53:
   In file included from mm/internal.h:23:
>> mm/vma.h:173:22: error: use of undeclared identifier 'USER_PGTABLES_CEILING'
     173 |         desc->last_pgaddr = USER_PGTABLES_CEILING;
         |                             ^~~~~~~~~~~~~~~~~~~~~
   In file included from mm/filemap.c:65:
   mm/swap.h:461:10: error: call to undeclared function 'swp_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     461 |                 return swp_offset(folio->swap);
         |                        ^
   2 errors generated.
--
   In file included from mm/oom_kill.c:50:
   In file included from mm/internal.h:23:
>> mm/vma.h:173:22: error: use of undeclared identifier 'USER_PGTABLES_CEILING'
     173 |         desc->last_pgaddr = USER_PGTABLES_CEILING;
         |                             ^~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +/USER_PGTABLES_CEILING +173 mm/vma.h

   166	
   167	static inline void unmap_all_init(struct unmap_desc *desc,
   168			struct vma_iterator *vmi, struct vm_area_struct *vma)
   169	{
   170		desc->mas = &vmi->mas;
   171		desc->first = vma;
   172		desc->first_pgaddr = FIRST_USER_ADDRESS;
 > 173		desc->last_pgaddr = USER_PGTABLES_CEILING;
   174		desc->vma_min = 0;
   175		desc->vma_max = ULONG_MAX;
   176		desc->tree_max = ULONG_MAX;
   177		desc->tree_reset = vma->vm_end;
   178		desc->mm_wr_locked = false;
   179	}
   180	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

