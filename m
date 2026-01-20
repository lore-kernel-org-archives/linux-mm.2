Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B86D1D2ECF9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 05:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063706B02AF; Tue, 20 Jan 2026 00:32:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010306B0364; Tue, 20 Jan 2026 00:32:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5ECB6B0365; Tue, 20 Jan 2026 00:32:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D35676B0362
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 00:32:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7529FC1AAF
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:32:44 +0000 (UTC)
X-FDA: 84351222648.10.2AC0EF0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F5271C0002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:32:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bVhGjl4d;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768887162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=vZmtSySTBT27AJZJIV2T01+bX+y2NLCja598WIxtSTY=;
	b=U9s1FSciiguddrO3oVQzYtZPWy/jZduCug8pLXIwlrom5WUX18Tb1iWpWcVB/yIndChmzk
	4wGJ+hRKLMLJBx37QBWcQqUgkAxCLVf9rOTxrTcBXYVqKqOyeNfHyfF9Xbt0HGrpMXdQtC
	qUWpe6JJiRBz7Q/gtvJNY9vqx5FKEg0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bVhGjl4d;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768887162; a=rsa-sha256;
	cv=none;
	b=c/tryWDLTHaI8HxH5X4b3VqMfQ6mv2kkPVY6fFzutJJEqv6LJaCK0WBnu/FnkQxZ/9Knmu
	UPwTKewHI7iB6fTypQsOiTk3QHPOvq7TFUDWkkuIhyi92E0vt9c4wRuv6c1YHrlUM/k7aW
	Qf3AHTrE+JdfX89sbxIfSbhl7qD9lb0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768887162; x=1800423162;
  h=date:from:to:cc:subject:message-id;
  bh=Qv5CtptDiIUKi0fw3b8JGmi/ObJ6DuXAQsO7RmP7DNg=;
  b=bVhGjl4dsvXn8s5fDttGz/h4KXoRdoi88iV3gyljHRFoIzHvoP1BkuHZ
   H3PTejAYXAzYElh7uB5ojEDhcquzmE2z6jQniojVydNam90oIbV8sg5DZ
   Ke3Y0eQfSD7aUr7wX+JwpAkRikH/7UaEXMNYCf9ckEifgQKLKfyt5Ngay
   KFK5WaIUw8gT2V+KIoPV6PGlhRqivjnlKRFpriT59Yf7gpgY4JT3h+iFa
   964xFtBIJ3bYZE2gd7ewZU9A3lTZPFDp3IWgVVvkrZIKc8rh+gf4krBfA
   LV0h42HkZSYSMNkbV6T3bTyfhqQWbHn9rn91foaHUjhs4mdzahmtcjYf9
   Q==;
X-CSE-ConnectionGUID: mRpz8ZUeSLC1xQq7YriWoA==
X-CSE-MsgGUID: aV2v1EoYS8OA/mDEVP8HVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="73944419"
X-IronPort-AV: E=Sophos;i="6.21,239,1763452800"; 
   d="scan'208";a="73944419"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 21:32:40 -0800
X-CSE-ConnectionGUID: S7HTKvdpQ5ixP4bZJRk+pQ==
X-CSE-MsgGUID: c5XJGEJUS72pSchcb9uX8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,239,1763452800"; 
   d="scan'208";a="210162890"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 19 Jan 2026 21:32:39 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vi4M0-00000000Obd-0iIP;
	Tue, 20 Jan 2026 05:32:36 +0000
Date: Tue, 20 Jan 2026 13:31:42 +0800
From: kernel test robot <lkp@intel.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [akpm-mm:mm-unstable 319/345] mm/balloon.c:19:33: warning:
 'balloon_page_device' defined but not used
Message-ID: <202601201338.4muFmFHV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: jnu7mb9oaiey3gwc9r4yqh9osmcm66ex
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F5271C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768887161-130965
X-HE-Meta: U2FsdGVkX1/vaxeahbq2xWen95yxofrhxk1FWOpQSwJPQzmNUI1Aw9TDREASi2M2SbIlZWl7hDySos/I3qHv8lXD/s8eyheBZYBHMcwN5yvEyzZi5hIwnAtfB9pQNpNmSaSewUSXxPcgpOwLAD7DlJbn5Jm2VpehNwNMAbqlQsupicn7431vJfmrUE0EBNI+CmgdoOlD721tAgPbSUBsPDRbTGXFZvPyDszG6wmZmNbFF/VRKs2PtJbiT+Ym1ZVtzNGyTyAMevFR4IyORELBeGPCjSGvfsK08bBXn3hHYlQDCbZXA4ZYVhqlHKjnh55h3v7GcrUvC2wvPtbAisUuaNPw9QF8ZOLtsgQgv14y2m+kp1Hw2HnoBB3qoRhHZhjPmjrrNNMz6JXN1/KX49W0Gm2msGAWRBYZj3VBSRd+XcPErn2RqqoECtMX0PS8Jr4tQct1zzhsd5a0HQpH0+VUz8V/b6fpPLEJTFEb26bY0oLGqAdBWCpQgorMSCwK8J88sIpO8TjD/hZe0EtcoL9+EoW6Ea+rBOe0PCZPXyfkjBT+TourcOHb4OjtgkbaO6mhkbg3C7WLeOum6NyU1SKmEWwtKnpSFQ+0wybd/Mb03Sjc9VesYDkYtrIINOJAzOdWFo7KTxjVi6F6aMLXOvpDIzBQp2dZYq6UmQlyfQcmkIRnPt9QwPAjHsQ0Yv3oS5GoERTF6bWpAXBvHgdlyv6fRtCxFUXGcIdqm0GuzwumGk3/IJNPKW9Z0AdbYfSCqbX3KoBCOwboDAb6aHiiRQVo+nqdkMkkIMeoUT2McR1rtINN/ZIWVU8Nsxvf0i/jRg0QfpBeP1Fvn8xRJBrhWzQp12+s7uzNwpstMD/pBHKSXKLf4yBRlNG6EsjUzAY/p16ffk800XoLRTEBZdJSgZOjNSA6AU3eCC0hSqjP6jSOi67+wdHPXAqYwhQCL2GZ2VR89/H+4Iin1Unn6XOAMdt
 hG7xPlvp
 p1EMJoEA4r/fHGzRiVOutifaCEvfNO7hgd6ERdQnt8w9ewOCH8giqXZvycKzc1PbBS4YxN1fW840pQ/7YHqP0i60puDCwdC7zq/GnMftPijiF0zg2wcke3de9C+SikxWRRnPI3Li6gvjSqOplxtjjrx1pmYWaf/rhB9e3niAk+cWFeMlUbm7McZAbN8iwYgIoK6zmzakyBUsb+5VW9pGWtsUGawx8Smk+J2+Ea1MT+4Bc5EIo9m7YIMnrj6ixH7r/YL/QlBI5YVCvNzebq7c/0qc2T6Fb8PpfPoPyKdfn19qN+DgKw6i8VwHMHNePpDJrnF0QcWqvl86tcisQwDT/ELUV6RC+EJaJXWAQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   bd361423f30912263920dd83326dcf142c16ce31
commit: f100e6eee69ff5746c327bc88a7fa6f43dbdf92c [319/345] mm: rename balloon_compaction.(c|h) to balloon.(c|h)
config: sh-allyesconfig (https://download.01.org/0day-ci/archive/20260120/202601201338.4muFmFHV-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201338.4muFmFHV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601201338.4muFmFHV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/balloon.c:19:33: warning: 'balloon_page_device' defined but not used [-Wunused-function]
      19 | static struct balloon_dev_info *balloon_page_device(struct page *page)
         |                                 ^~~~~~~~~~~~~~~~~~~


vim +/balloon_page_device +19 mm/balloon.c

50fe4326e833f0 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  18) 
ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20 @19) static struct balloon_dev_info *balloon_page_device(struct page *page)
ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  20) {
ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  21) 	return (struct balloon_dev_info *)page_private(page);
ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  22) }
ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  23) 

:::::: The code at line 19 was first introduced by commit
:::::: ecc7c3359cb47658444833b09785c2ceb8459a78 mm/balloon_compaction: move internal helpers to balloon_compaction.c

:::::: TO: David Hildenbrand (Red Hat) <david@kernel.org>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

