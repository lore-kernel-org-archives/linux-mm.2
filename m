Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47463CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 04:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0738E0008; Tue,  9 Sep 2025 00:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C80F8E0001; Tue,  9 Sep 2025 00:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD338E0008; Tue,  9 Sep 2025 00:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7C38E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:09:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E11291602D0
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:09:49 +0000 (UTC)
X-FDA: 83868383298.29.2DEFBF6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB40520009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:09:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z6XXRBI6;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757390987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wju6uFp32k8CFEigsDiOdik+ko8zEsrQxT/YvBe62hg=;
	b=MuoRgv1Jl3Xm4dUuC9FKaOYqFL5+HqGVbKo23R/i1/Je6GjkSYS4bIHsvb+6RiNZ4jk1Mb
	EQ2QnqFj8H1AlUBIAb4FaAIgbApJhLNurA0lvwvLUMAvKcONE93zwwvRQ2zMi8O4ub3ZMr
	coqO/wGgSfphLIMqSMWzc+1P5kRSVTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757390987; a=rsa-sha256;
	cv=none;
	b=sSFgt6Od1rR+U8WvXlPC4lB6Ba8QFlE29QNTE8eTldWgTr3/7eHliwSiMiNww7ZuQxLgzX
	k1MphwJ06dqQq3tQZj7xFgVJhHWrIXaUQUTuSKMTuy4+GpNmBSwvINA65sPs42dYGgOe91
	PcyyOjQWErvajC3z4o23p7wTp68jiK0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z6XXRBI6;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757390987; x=1788926987;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jhYZYCBzrdRs97Lp5NHmjYhyow4hwuVi+HJ47Uu6hEY=;
  b=Z6XXRBI6AH8vgZpeymhDRqIBNZCTfhcbNoZX8zGFxqW7AseYgoWwEgN1
   dFCi31h9dqbRFoJXCzqj3EI1zZNseU4ap8qddRfxdFPdZfN18RWLXJ4dw
   XhHcRka8LTMkDCB3fW/EkTp+mKIzN+voSBYC3h7OrnTw1daPdFLTPLuGX
   gOpa6r2KO8+D2q6KQ1QrLOs512U57PNZ+HnFIA6r+3XfOzNOYUNnsDmQI
   ALM1qIwFOCO6mi+iSdPkSkYuMZ0Fx9AgNIynz42d9i3hknEhy2tTrsRum
   b4MF27HZSiOAMrHVXxqn6Uh96bhIPTUmWfHyx6XizuJxyc/6zHlwgXJQj
   A==;
X-CSE-ConnectionGUID: aZbQiW5HRLqSshm8q+TwoQ==
X-CSE-MsgGUID: iKswY3AOQYy8esVkCJ1YpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="47239521"
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="47239521"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 21:09:45 -0700
X-CSE-ConnectionGUID: KZ/2k0LqTpC8WVCYgqnxaA==
X-CSE-MsgGUID: 8I5xC4gsSpiBDJf3Eq8iug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="172150183"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 08 Sep 2025 21:09:37 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uvpfi-0004Q3-2X;
	Tue, 09 Sep 2025 04:09:34 +0000
Date: Tue, 9 Sep 2025 12:09:20 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH 04/16] relay: update relay to use mmap_prepare
Message-ID: <202509091137.FMoksKmh-lkp@intel.com>
References: <9cfe531c6d250665dfae940afdb54c9bd2e9ba37.1757329751.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cfe531c6d250665dfae940afdb54c9bd2e9ba37.1757329751.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: hbp8y76ex7guyxk9nsa7ee8x97rqb3ur
X-Rspam-User: 
X-Rspamd-Queue-Id: AB40520009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757390986-488827
X-HE-Meta: U2FsdGVkX19kgfFtrdm8rjX84bhEaeRo6jZ4TOyOKcbcaLhwUt6yvFZgPUBP9DynG8qOtv19qM2JGCK8mKqt33wgex/CQM6FsPPUbnbdEdKUJWhIYmEwcmw2nQMxp7EDapm0jstNhONaeVDFBoNIZhyGNosMp60tfJH/YQKkp5g65NLzsDl4qqYIiiXVPmpYNDgmrvwZiA7tBjKp3GZV1SLIF35FIx3skzRWCbWKw+ohxhKtLMykOIsi4mg9+SmX05ai3udRtTPNtRpTRbEza+rn8okt41D64xm9hcGzUlrOnkT/DElam+2N2a1SoIxvw2uNZSeTY19F3CuNIgHKLLwHxrk78ow8Ssnbi+5d36pJMUHcmwdvJtF3SNbTUpLtFVGa/e3MaUXMkSz/AF6Zj6brbDjFoCmKRoJMq5gawlYxWobdUPRyle/wonZNYCurDnVK6xWVVdER7GHotNtnfOEnt9IV7Qkmqt0fPHPNP01kEdM4KBGh2NcI38UE/6fv68WySvq2TlzSNvm/Nxp8/yJ5w0rZLZRNLlEMyuS2gEv3pHP1wJMk3og3FYPW4G3dmCqtFcxdAn8P2C7GhMy5y4GGnfM8hOs6GM5hl9onSSQPaECwGiMMYvZbI6jezK1Gb43Fl7t+aLFiJv3yHpRBkZj1lxLY0kuG5ekpNCIq+YOUm4QGlvg+W5V4rSj+j7gfrGQ9iQaRloSSCuum9jalRh4sS1b8AIsVry0HXYf2P+QNG3lHyM3S22uSDUkA5X06kScpNtKDyx6cA6t4rGyWvzzjTYWQFEiqPQHi5BjIWNgfRSi4iY3JM1f5d3+VnYw5XC209CIzucCY6p5HR9Ynk1cpaqfRl+rPnbRkLBpFs5SPnzqdynGFtnIlns4uWe75gjAA4f4s2fVRRkSjaQ/KzL43wL0ImCv3NH5nrcw1cLExdoJuAGseaR5uyQIk7VVBhazQ7Qw4/ev0aN+/PDF
 VDKsTOOB
 vnI+9Vi5yHgm7tyEPvQs6UxrJ1Ma4UzyC8j16J/9voWMMluiaBHMHidZmMYIjRSD1yAXVFEaKWmuXwMJt96DkFHAOVPaFU8doN+a3OByxsCMQKqjswaZBCW7QmTCJ94azyyxkphZbJ1dTT9Ff0d0WkFo5UXScU+VfjAMzcyY9AiAp3SLFrHHXd8hq4eAxjECpdNdCJGySaAekaAeO3DzSaMhvEGQ+CYqx7KevgxtM2QmgWgfry3cE4QbHVRTI0jLx1kQCqBS5axmQR2Z7f2o475odlmv3OHLn73KQ1RBgOxB5xKeGpuWgymAZ1MSGRU4smHv7Ium9Jf3+Xsfp/dzbykNDbXqL4H3p0DBCGut8m3v4F5cdnubAeHmYB91A3xRD2jvxuEN/vKHJca8n9VLqytflgCUndTf/cdt/RaTD9+3/BAk=
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
[also build test WARNING on brauner-vfs/vfs.all char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus s390/features lwn/docs-next linus/master v6.17-rc5 next-20250908]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-shmem-update-shmem-to-use-mmap_prepare/20250908-191516
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/9cfe531c6d250665dfae940afdb54c9bd2e9ba37.1757329751.git.lorenzo.stoakes%40oracle.com
patch subject: [PATCH 04/16] relay: update relay to use mmap_prepare
config: i386-buildonly-randconfig-002-20250909 (https://download.01.org/0day-ci/archive/20250909/202509091137.FMoksKmh-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250909/202509091137.FMoksKmh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509091137.FMoksKmh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: kernel/relay.c:83 function parameter 'buf' not described in 'relay_mmap_prepare_buf'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

