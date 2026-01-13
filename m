Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23207D29DC9
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 03:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B556B0005; Mon, 12 Jan 2026 22:53:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF416B0088; Mon, 12 Jan 2026 22:53:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD706B008A; Mon, 12 Jan 2026 22:53:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39CD36B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:53:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B755E8CF6A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:53:41 +0000 (UTC)
X-FDA: 84325571442.22.BF5FDEE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id E2552100003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:53:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kgCUZwHW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768276419; a=rsa-sha256;
	cv=none;
	b=dRSU31lz32JBRj6R1HYjXXX3Au8XstjKryxmDxMkPEfJH2H2HHmmbS6/5DQlS4EV6cEHDx
	cC5SEn8UjDMh4wIrKh4NGtTrTK3SbJYJYhj+dBJpvvVF5uX45zzZWg4LE/NEQsDLwwJvDP
	/ccPbycaOTSJLhVH5A0KxaeAN8TeYSM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kgCUZwHW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768276419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJfHK0U2NUrFKGfiunVN+UxBId2ZLvcoaiWlmbMD//0=;
	b=JN7I5FeW9WznpXZwUXbMcA5lEJ5lVA+WPqLEKYrDlWyO07FZC/ezonV+gZm6mD2mPRyFxx
	MGA1ia6gkmYBI0EPEhlw6RJC+SXnw+yjpgn2QjsQQDLVsXPrYfr4CZ6IwQJQsigzHdU+WX
	6WYLS4Lvo5SVGkofHuVFmdnaVzeCbEo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768276419; x=1799812419;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mffo6pT405RBQgYZIVLC+IUbRqcWM9QOybQuMjtdUNU=;
  b=kgCUZwHWqG2fhwKeoxQdpCHnCMamWMwUX97iRIANYBiX26/uEB572QRC
   sCRRKsZUU4UaT+h/fU1oEmjVhdlGDaXd+WExBqL+jThfFp4wDtylT2YCB
   gQJiKQOzB77ZjNXc67LcwzKinEXe4QLEud0XLTRbU4L2R5Fs0jVdTu+jJ
   7iJHuAlJnwyreuczFC+TvzP4TqASAGrBebWbd1DbKHHPmUSfu9G4Bs9hQ
   XZOo0PPf1FEUV8G1sIaLgAHsqDeF8OKp9au+0Y6xzM+ewx2NBuI5Mn3qy
   LfplqbVX3vULkq+Do24fFF0NYtl43D+15XoFzI4wiigYUrynCIIQXtf3G
   g==;
X-CSE-ConnectionGUID: bgyNx1N0QVaTLoBg83N4uA==
X-CSE-MsgGUID: GEjb31R5T16gam4Pc8IlDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69613573"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69613573"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 19:53:37 -0800
X-CSE-ConnectionGUID: o5DUd1t5TFauLTFAU3u8cw==
X-CSE-MsgGUID: kOoAowsbShG/pISUWE2Ttw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="227496204"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 12 Jan 2026 19:53:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfVTH-00000000EBW-1ukE;
	Tue, 13 Jan 2026 03:53:31 +0000
Date: Tue, 13 Jan 2026 11:52:51 +0800
From: kernel test robot <lkp@intel.com>
To: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
	linux-coco@lists.linux.dev, x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, kas@kernel.org,
	ardb@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com,
	prsampat@amd.com
Subject: Re: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-ID: <202601131156.Kfi0QLIm-lkp@intel.com>
References: <20260112202300.43546-2-prsampat@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112202300.43546-2-prsampat@amd.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2552100003
X-Stat-Signature: q5fwfbkwi3ytr13d6n67obgpqgna85qt
X-Rspam-User: 
X-HE-Tag: 1768276418-371720
X-HE-Meta: U2FsdGVkX1/zXVP0wq5yw71l96M86QPR1qiMd11SCantkf58WPRs94bFB/0DgQ3KNCpvcRg8jYJqtWRT+YCrNCzHPov9IwzczSgBGsqIwx3h7ecuEbShbVNpXaIMRag1AIb6HCns7q3hfyh/ATixOk/zmkaxbjvNPLUrJKwHOQbtLtgIjuw/OK3rNuI1UxVNSm3qQmoWCrXFn8Di3cRgL2A1Q8nA8WDu2xau5tdaRhp0qFNavxD1BwZrs9SWbDakZxzLoTqLo9+Fx8nFVcpcns6VaUOVrrHyfckdVD4h69NVvUuz9bAgY1Clk2mR411GnNpFn3kbi0DuTd82MRjhGEcjawsqcaNAuDZt3Z6GkMhRgn5xXrR+F0u5UMqVEPuw1apmuFCsxg2hwA7NXDyg+9/p96wlbAdOcknKnP29Wz3oidt2MHq2nvJkyX5bFaGW5j/TOZNKzFDmpxVGuqlsxrOhbAXxFaKNaU8jFSrhslX3w0hXu8MXMJqCThwadeirxTKZ1u4UkZURL1hDmfJLcWq+vkBWyMZPCg+5FPosBgN8wbf5vS/7Cj2m0jrLEnNKsPVWlH42K0q5vG2wsq2aNirxMncniAua649ENOknXPZfTcR8sYmcSKQBPD1eQ/M73SKPaa7M+ktf5fbeb+47wsJqiSMn+sczTgUw8BfZQD/9EJ8/c4+P8pglui7xUjY1A3Fz95DE5wguRyK7BAyYpOdKXKdywlorLV9z432EQNi+C4xxzM1RP3Brd4L17+OT4ods/MdAU8UiBrH+QyE88k/0rkKZsWFcj+3U1I3eA0/yMSw0Sjan2O9ZnyG9IFPubhVsiw2wXQkuN2e1yfb7gB5VFO/4w/sjAuj4wekcO4KdNyzffZre2TRYwRZSV8jMuN7zFFjsNq37wNDqUqA1Pauj0UrOIFvyQJ3WnMsQTZLrEVHcwhqrACLN4mxybUWubi40yrVAdjjFrusscmY
 AWKbDplQ
 E/WLjhjIQLYWKTgfQth75JTWi6435RumOfVQpdWdG8RUXE8FPR+xUbECc72aXQooB4NtCOTXF2BY4GnL82hAwzWe9dxGcxT5YCjUfRopgZsY9uSzmkbHfPHx09YpIJibTtW2D3pHxazq6UnME1xfRr63gZYA6KtPqncFqS2B9HNasZtSAHvXWopkMXnIacER9XKKiM0BV7qCnHHWKAKtwcmyG7pQXH2/nnqZGHmSyUVaMz4LAMz6TN6NYuHdpLs5ZZ/4qEsH6YBgRkuHy6M3tvtAkgBTIOzlYQiI8rQ0ekCaP9fnBpveZ9VxD+RChN6CqTPvYQ5Cui/imwjYuXJC33KajqkEZS0xz4JBkcGxEMSVlLDo3Ic9/ExffvDkpwPsdUL/wxXILTrQU0OCyYenRjdWup8BqsL9uKcs1gPe1Lo2oeIw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratik,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on tip/x86/core linus/master v6.19-rc5 next-20260109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pratik-R-Sampat/mm-memory_hotplug-Add-support-to-accept-memory-during-hot-add/20260113-042631
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260112202300.43546-2-prsampat%40amd.com
patch subject: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory during hot-add
config: s390-randconfig-001-20260113 (https://download.01.org/0day-ci/archive/20260113/202601131156.Kfi0QLIm-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260113/202601131156.Kfi0QLIm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601131156.Kfi0QLIm-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memory_hotplug.c:41:10: fatal error: asm/unaccepted_memory.h: No such file or directory
    #include <asm/unaccepted_memory.h>
             ^~~~~~~~~~~~~~~~~~~~~~~~~
   compilation terminated.


vim +41 mm/memory_hotplug.c

    39	
    40	#include <asm/tlbflush.h>
  > 41	#include <asm/unaccepted_memory.h>
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

