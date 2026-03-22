Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4FBFC72AF
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 07:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504ED6B0099; Sun, 22 Mar 2026 03:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B61D6B00A8; Sun, 22 Mar 2026 03:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB6F6B00AA; Sun, 22 Mar 2026 03:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5A76B0099
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 03:41:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D287C283D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:41:06 +0000 (UTC)
X-FDA: 84572902932.25.4E9D060
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B378C0004
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:41:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d12oIyJf;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774165264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fl6Vo0CZ6glcVLyy4yu619dgSiIfKOAp/m+BURB5CJU=;
	b=yAP56X044qY4oYMtgkSl+U8a8DJo4MJz1XpSEaIznmR+uVp9In+Vw44kAvRDHbFRRaMEq+
	v5jqg4c1Q8lxRScE7UXUgw3HWPlrsReQZY9jcZ+otH3oIkMe22r8/Q+GHNgcLmnD2/+2Xz
	UsMTTYqQa33hOBFgrRS3hcP7ouYXdUw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d12oIyJf;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774165264; a=rsa-sha256;
	cv=none;
	b=OQzj7YKkq2bpF9nOuw9kSpdLxaaKB9hrFlUoYyJv4dOdHEibveqsMTbxW8QYF/qxARmz6I
	iG4XB4HmEmgA2af1MRNzXuojDdqKmSIaNis55I4p6Q2e9YDpDFWJFxt0qm4fjcreSwA3lA
	Dxr5vB7q8Lofe2y+KrzMLzBdM2cGtdU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774165263; x=1805701263;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bb4QyRenZ7daQTIah7HNDKj8CLKXNag8jCu6QnIEdBg=;
  b=d12oIyJfImpwvGDel1dtKfa5MXe127CkBH4Iq7OAkS1PVJgmzQLdY3pm
   85/rqs4sbyEh4UVZLSyS7jiLUQr4dxZerEXtsiRrfsVnOo8RhxmEyE7qJ
   NEz3UTVgCcoBBGYoSYbOCgb14dc5ULExEFm7K8o6RZHFUfjIOsXKpsh3r
   UMB4Dl2nWxfntHotVz3o/maVose5MT6Zyee9P+2J/mPoBlpmCe7rlkfaO
   gVcQ3tMPUh7srhqoKjiTEktPvXP6eZWfBvQdcKc+QTovr4U4BMervE+V2
   isBWVvT9dc3adQE2dCg34qFPWiZtscBxqD0rTXeQcu6eJLTkvvIFNC25f
   w==;
X-CSE-ConnectionGUID: DgcZ+Iq4SiCaRcXGNfTaeQ==
X-CSE-MsgGUID: 2DYpMjHOSyGh+sXjXtsfTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11736"; a="74218073"
X-IronPort-AV: E=Sophos;i="6.23,134,1770624000"; 
   d="scan'208";a="74218073"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2026 00:41:02 -0700
X-CSE-ConnectionGUID: aubtGZfvTP64cXi8tj3R7Q==
X-CSE-MsgGUID: iuwTwHhqRGKMtknP2CxQOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,134,1770624000"; 
   d="scan'208";a="223749971"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 22 Mar 2026 00:40:59 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w4DQb-000000001pJ-1PUq;
	Sun, 22 Mar 2026 07:40:55 +0000
Date: Sun, 22 Mar 2026 15:40:06 +0800
From: kernel test robot <lkp@intel.com>
To: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Subject: Re: [PATCH 1/5] liveupdate: block outgoing session updates during
 reboot
Message-ID: <202603221537.TfoAS2LD-lkp@intel.com>
References: <20260320163720.100456-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320163720.100456-1-oskar@gerlicz.space>
X-Rspamd-Queue-Id: 9B378C0004
X-Stat-Signature: q4twmy5obry1o5mw8m9a8hi5y1zzk8mt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774165263-809819
X-HE-Meta: U2FsdGVkX1+l9vlubvKZ5yx7w+wizAGkwk5ea8Fzqw0RGSrVyJCTnqnoRtCa72fegjBGKEe1qIh5GZIDDN737oZFq28M0fCH6WqIb1Sl6lL1Y+q/Px9SHsvUG2to05DlGKoUcLHui+Nb5j25G+t9vcAW6Nq+vmHXVW9uCWmD/F0gIUZcScjk89vF68aHErJmn+L33BDGYl0v2+B+Rtk06qf6AJl1SfK0m4w8kSGUWke92ZKU1LJVHdRoF6RRDLcU1/Pueg6mKLxnih9nxI6lvyoI9UUz6D8nPI0PC2uxeksWmMBIhu8zTWDjQcwTNaMp/f1N3orQQ9/CEWMnovT2LHTv5PZEYCbXWn800RbmP02JMoPu/Bt4SnrmTLXDN5/vGjt2XYG28/NQUv36zJZbC3zUQi4G3DpwexetRBVyx3UTtqaplETMVBMfRqCWyfnQOc4vCWoKAjTvH/FvvWJ5LEWyNdZJX/t+ls5Y1Sbwzo3Xah4OoK87sLNUL7nGT2YBM2WTpac+9FS1JGSEgh1dsI264CbyQp1Erw4H/hH2EnVaQnilduWh2A+AGXRypxGNS7TYODfMSRybyQ1MSLvbnZ40c6hdlYuZunvMyxBbMZXzeAcCE2y4bunxmjfy1vnafNRjT3uFsw1D5F1i1H+X4YSLwOWknACHEjerMjSs7DorY1mxT3wETlrudCABywLTp5gjlDS8y90V/Bf/mK2X1OSxBZylj+JV+hKvmKheYnec+vDi4vEXXChxtOpxSO8da8qkw+vwryPZGtasEMm1+lcoqZNHFuNUFTTprRjr8vmgfLlfb+t/LoNl5ewQuGhb5rsNrAf5PNfzV2gSCeffOciUes69gV2BZbYYnajJCZ8t0wTdXHJPo0QVZ4sYXAJk4P0lQd7neN6GMmySp8iW9Yt1mC+YA8ig07e//WVmfw6CcPG98C/vOycUoy+TQGbJWRhajpCcenrp9/wXuZM
 RVKGQIHK
 rU97x+JBTFeVySOSc4txDvQP3IjiyK966fTxPb71+w3hp4OBORF95AP0E8/CdlGhefovt5gG0jRtVq1TmLT3SaUTmHjCHg+rdv2UwOgagfp+Q72md6vqp1KpTcej0SAXwBKuNTEiltGyWac4r4XawigEglAPUHCjnATQl4In9gbZO6DfRBRq3wkszPTIoGU1gFXmzD+/YYMEicCIE1IOvC1ABhEP6pI4t+XGMOFFg2mXYQJCyrcDGIzfLCNVHxr6su0NI89INHEmFVFV3zMbl1J7n6WzzU6DfrHYr84QH5xdf/qsLJmbJanYKsh6aMt1Ux1Lh8d9YlBEyUWGTVSs1I6cP6sSyvRom9pgH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oskar,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v7.0-rc4 next-20260320]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Oskar-Gerlicz-Kowalczuk/kexec-abort-liveupdate-handover-on-kernel_kexec-unwind/20260322-071016
base:   linus/master
patch link:    https://lore.kernel.org/r/20260320163720.100456-1-oskar%40gerlicz.space
patch subject: [PATCH 1/5] liveupdate: block outgoing session updates during reboot
config: x86_64-randconfig-161-20260322 (https://download.01.org/0day-ci/archive/20260322/202603221537.TfoAS2LD-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
smatch: v0.5.0-9004-gb810ac53
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260322/202603221537.TfoAS2LD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603221537.TfoAS2LD-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: kernel/liveupdate/luo_session.c:99 struct member 'reboot_waitq' not described in 'luo_session_header'
>> Warning: kernel/liveupdate/luo_session.c:99 struct member 'rebooting' not described in 'luo_session_header'
>> Warning: kernel/liveupdate/luo_session.c:99 struct member 'reboot_waitq' not described in 'luo_session_header'
>> Warning: kernel/liveupdate/luo_session.c:99 struct member 'rebooting' not described in 'luo_session_header'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

