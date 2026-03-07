Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925BEFC9EC0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 04:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D404E6B0005; Fri,  6 Mar 2026 23:05:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE466B0089; Fri,  6 Mar 2026 23:05:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED756B008A; Fri,  6 Mar 2026 23:05:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB1C86B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 23:05:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51A7C1407DF
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:05:49 +0000 (UTC)
X-FDA: 84517928418.10.3039F86
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 415B014000D
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:05:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JJp5g219;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772856347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=sd7K4qodrsghX2nk71T2S/XiGUr8TdaDTEGw0PB7gj0=;
	b=7d7qTn2GqR0vTGhQ9XRD239WCJJIYhF83gh5LUeRP0IyVcKSUJfPqZwEjRijxmFcWBsjXc
	MQrL45tKcuHY2pFmQnb8IfD11PAiHueiK7msoQO9oshLZplizXIVIoVJ0Q2EjdG4QAI1T0
	cJpNH4lSv1hf8HTCcIWRYkpv5jhWEaw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772856347; a=rsa-sha256;
	cv=none;
	b=NEiN2woEAYtDU3uH97s7rurJTc5KEGn1o7eFyi7T5umWBLbcmVqSt4zPtyWC/JCm/fmyOS
	01Iriz1HRUJg6JN8j3+s6wzpyI5u8VHXAV7p/yYpwQqKTNilrXPr7mlRCZJQd1yGgzOrMI
	rc8mAopMXfvU8y80fmR2ZEz9dM3lWEg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JJp5g219;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772856348; x=1804392348;
  h=date:from:to:cc:subject:message-id;
  bh=1cCEN1RDGkPD8ziDuZ9SIMWTLmlNebYbtgy9cPF7KL4=;
  b=JJp5g219NE7fTsw+MSel6fjN8KXKoXRoXwP8uDNBjAotBYesUBHbB+r3
   /rzUO2tpKM5KmMf1RaqnHs8LIs9ZCHK15VmtecqSYYLF3ScR2j/+0SO7N
   6mD9zYatmiTO2xh4fst/JFW4ojjJqACSVfNoIFAMj8rz7E2+MzYpuj/dg
   5tURB+DA4Nw5eQ9VR2gB7fDg0GWmSWIN0M5o9a4uaEGcEvfV8OEDVjJ3n
   oDubeoaOc3IKkparoytDRmvpP/wFlcyW746YAcdyjgcGJZt0YFucGVImY
   /UhcGO+A5ZuxoWIQNEhwPYda/5EtPAvN11bq6gE7N0eZBXdLFN8e7BbVu
   w==;
X-CSE-ConnectionGUID: s6yf7tk3RT6ljXox9sFcng==
X-CSE-MsgGUID: 0vg16btPQh2j8qmz26TQZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="77814836"
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="77814836"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 20:05:46 -0800
X-CSE-ConnectionGUID: ZAtUPhWvQtWdEBsLscnjcw==
X-CSE-MsgGUID: 6r9fz7ASRgq2pd3LY5mOdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="224151074"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 06 Mar 2026 20:05:44 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyiv3-000000001fd-0cdR;
	Sat, 07 Mar 2026 04:05:37 +0000
Date: Sat, 07 Mar 2026 12:04:58 +0800
From: kernel test robot <lkp@intel.com>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 34/207]
 include/linux/hugetlb.h:1214:16: error: implicit declaration of function
 'linear_page_index'
Message-ID: <202603071127.YdvMepoW-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 415B014000D
X-Stat-Signature: 49d7iqn9kbi8mx6w8y5o1qxdwrdaf5fb
X-Rspam-User: 
X-HE-Tag: 1772856347-346432
X-HE-Meta: U2FsdGVkX1/SppFUdmfebc2HKyjtJPMBK42qOGiYNunjINO45b7sZuPPd8SDkHbumqGW4TlrskfBVNCpOf/XDj3KyucPLbZyNbJ3Xizjw0qi3RWklYm6GT0vgLEVDoEteO6meWFBPikQwXw6y37ZNb0NW8f6yvxPKZ6mdjRFdO8Go19P1XKHwgUNKd9hbDmXw5YSBbVXxHXCslguHyBVY6MszL+cN6XgN0fkVhcIE+8/y+EATiHOYjowCFsRI0z8A61khkJ5PaTEBNBjbVhCY/tSPJ1rQBS/2E2mTqrogCc5qZSQc2PyhmTL67hQxU6yBBbO6NmG3H3j4sNCw8uqmTi4lZW07PKw7/xXVhCtEiRR6KJ1ZepGrv1NIbyUw+jgLlSNoe7gf8DEwiyYIqygA5NOXJnO+kdpjgE8PMGGFw+U16RLz32S1qkQUCc4iP31Z9d5SLe4UNTXTgVKByPgg2HMLLJNUYmkSfoyqDVAv2oc0vYhj866lV8py3Wlxo3vOqDlNW8d11sFfv/Z1bfDX/2RFf6QqG7bVRuq66HeJorqPequ2Bp9YtcMT8hBhdNIR7JOkagTNjxyOCKxbwe451wKUptBCF3toDip+ye4YF1AWFX7pgViwf1uPK69SK946/YtJqxPoBOQyKZHna8nmPiJ/t7vjkoVrQIgrm1qKqVGaZFy/8yDXeGKrYdlNnyeozLIxfmbCFE2tCDngrHRHbzi7/T0ZTUicLQsMMx/+U7VJZg7NSO7Cy4s+xlmIkna5IF2wuyigQZF5Uf6y5Ndqmvs7CY39uu0LlgYJWBvQVQgzYGe/auI/LkaDjSIHLRgK8THzT46vLVqdSdFdBa96vdgJpCcktwSp6BOdybxpMFxZ9qMI9fcKD6kTDLeygtCIYcW97BPPKhi3HLtXlXP1lguPYlBwDxxKsxtjj2KamjWtxYiYT7A3o3BsZysOjK8P5mIa8+hZYX7p8lZzBR
 uEP3InBr
 KDbNfKYIybE7Hycd/hyFJ14oQTxgy3UknYQ7FGxIyCX1lTrsggLS/gFtSRehxdf978u3zcVlb37ot3pbEppI6bk0atYPTMmE2jLLEiB6fW0SlN1D9W3TMqXHitb/06y7yvMHSGkERJXWpbnnB6zAvMmJvgVq0syIIe9fx+sU8eKRyqTafAOZeaB8lddoIAJO1sj/lymBpVp5c2vO6FkXUgMpEGvX18pzr17t4/36S9/N/knmtmIfXe8AW4YY54DnxE9oLnraJShZawYEUyIf8YwN0Ipu9CvIoLY2Nx+12DVlf0A8G7Pt0Dl5tyaciM+Pn6S59
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   49cb736d092aaa856283e33b78ec3afb3964d82f
commit: cd9119a9480d9d93fdf06792f8f9917cc4f9999c [34/207] mm/userfaultfd: fix hugetlb fault mutex hash calculation
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260307/202603071127.YdvMepoW-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603071127.YdvMepoW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603071127.YdvMepoW-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from io_uring/rsrc.c:9:
   include/linux/hugetlb.h: In function 'vma_hugecache_offset':
>> include/linux/hugetlb.h:1214:16: error: implicit declaration of function 'linear_page_index' [-Werror=implicit-function-declaration]
    1214 |         return linear_page_index(vma, address);
         |                ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from mm/show_mem.c:12:
   include/linux/hugetlb.h: In function 'vma_hugecache_offset':
>> include/linux/hugetlb.h:1214:16: error: implicit declaration of function 'linear_page_index' [-Werror=implicit-function-declaration]
    1214 |         return linear_page_index(vma, address);
         |                ^~~~~~~~~~~~~~~~~
   In file included from include/linux/swap.h:13,
                    from mm/show_mem.c:15:
   include/linux/pagemap.h: At top level:
>> include/linux/pagemap.h:1079:23: error: conflicting types for 'linear_page_index'; have 'long unsigned int(const struct vm_area_struct *, const long unsigned int)'
    1079 | static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
         |                       ^~~~~~~~~~~~~~~~~
   In file included from mm/show_mem.c:12:
   include/linux/hugetlb.h:1214:16: note: previous implicit declaration of 'linear_page_index' with type 'int()'
    1214 |         return linear_page_index(vma, address);
         |                ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/linear_page_index +1214 include/linux/hugetlb.h

  1210	
  1211	static inline pgoff_t vma_hugecache_offset(struct hstate *h,
  1212			struct vm_area_struct *vma, unsigned long address)
  1213	{
> 1214		return linear_page_index(vma, address);
  1215	}
  1216	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

