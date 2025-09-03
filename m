Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F835CA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 05:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7083B8E0003; Wed,  3 Sep 2025 01:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF798E0001; Wed,  3 Sep 2025 01:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C538E0003; Wed,  3 Sep 2025 01:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51BDF8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:26:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E46CB1A046F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:26:50 +0000 (UTC)
X-FDA: 83846804580.19.CE891B6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B5E040005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:26:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MI3hIWVb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756877209; a=rsa-sha256;
	cv=none;
	b=WK2ixK0pS34m4a8jORxvQUd5qXBci+SAeCOVGG/dObwiPN83vMwRlUMKH5ipRUBTxMTPj4
	gCA6fhaWPSW6QQklOSrTBbXxMA+xDqNqsTlXn4Y1M3qrIkui+bdvAY1O2dn1pka0ycLryL
	VUqhUTJw6j0u3Whgg5SEtHEe2V3awWQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MI3hIWVb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756877209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHneDkjVSU9dC34t9LMkjRUhMpIbPTjSsbaFNQXQ8Bg=;
	b=rigS+C5jRAAl1gBXkvo+Mdj6yw0m19sUEgDOkE6FPT+NdLkppw8AzsIF7IfbjOTFC+89s+
	YRQ4EnKrbtxaV4WEYSYGKTcjpyTUaTwXG0XzqA3tCG3Kmv8oQ2H875vAgSpgE1d9qRS1H5
	XkjciwRVMwovQjSnUxyx+5OH6p+m50k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756877208; x=1788413208;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+U/qyUVufuO9/Wxc0OWe61I/W1hyzeIS2pBPmz4WWRg=;
  b=MI3hIWVbBpG0OBI19jADcPMh4H6LxJnjop562fIfTQPhnoMfRUUjTCTS
   W012YYi9qGXXCETqXTBDuZMIgmBUkx/Ae+61i+P9zRk2JpvMkvTMNF7Y1
   jzh95ngoUmfmncmt6yES1ZrC0YqwZna8/Lu6fHJT1Ml9PXwHbkYYVG71z
   N8iPDnV33fQkJndiYgNJVsw6pFghDPAkb+Xdap0+J8N5WR4BzPincl42y
   PZZ4acjDTh4VDWmky8MhsdT3GdLHIhdhkWkTCbnroH3ZxRrRcxb3TiQ4D
   ZxI4Av9vhq0nUd0EAK4YAd8hmVajoD5wuA3PkhTNtrDV01MXgGkDwNaMH
   w==;
X-CSE-ConnectionGUID: SFhh9Bi8TlysBvAvS3/Rjg==
X-CSE-MsgGUID: i4ChV+h4SD+N3KNq04PqSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59092859"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59092859"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 22:26:47 -0700
X-CSE-ConnectionGUID: wIW/+0vBT3Oa/imtc797sg==
X-CSE-MsgGUID: ucQq6avgRw2qGrKoH2kdIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171865325"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 02 Sep 2025 22:26:43 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utg12-0003NX-2f;
	Wed, 03 Sep 2025 05:26:40 +0000
Date: Wed, 3 Sep 2025 13:25:47 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: do not assume file == vma->vm_file in
 compat_vma_mmap_prepare()
Message-ID: <202509031346.N6FpuQIA-lkp@intel.com>
References: <20250902104533.222730-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902104533.222730-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 3B5E040005
X-Stat-Signature: xecfk1imx3t5do3gefs3ptrq8i8sjwhc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756877208-592048
X-HE-Meta: U2FsdGVkX19JV7QTCHLQvAAqM9iBXP1VBJuNesnHVIHF6w74QFBk68kMZUIChJMNzapeJkOceVBgnXM0izn/bnm0wtusARcROuTSwj4Wv5f20WWMitTzmyyIBmQVkb4YCKeLtKO7x1Q9szBoLNwy3c97gCE2AXY76Gwa/Ofxm+j2Q8KpSztbU2+w31iUQYikjpTsfKqr9NrQM4UWbrfH37uNjQbpjmD3/6jyd8v581TiSOqAOdDU1unk63MdBPZo9CaFJRM1m7kS51Py+0n/OGuLwRwr6qJZqwuoDHRztphggtUJaszwMO+Wr/ldgyZwwPgyjP+vvp3FBe4MCFd35SsEK5nh9wFS87bHGzB3ahBAItG4pRCUpLwlUANTm/oD5tnlOQD9YcCBT12GZBQB32A2kAQUAlSZ+ck2ETCTbfASOqtpVk3YbJjKQnMPXrMnbun0Uw7axb0QPUwL9O4k/RCviip04MVPqy7TYY5l4YKHcXE659K2Um3nFMjQ2/g1LjhwcWmQ7Tk+JkxOb4mC2QJTZEdYB/IL1k9TKn87ugn9kh6KDCzUkAQ+8gi+4rSmlGnoDyH054Jm9fuWxz4OHHLchSoMtadoDNDmC4e3TzZZeIufmjnRjVegt1Dlk8SRVVzk2KAR/P9jdnoNVRcoAb6OoAWCKBMEJ7Ux1iWWep6w9CmUIn0Jm4QpduSS8525vs91XNXTn8j/ofGnUVnPa9LHzdFLgDbqUzyEttbGk6sDeVplRK6p1/bXvYSpPzW1nKPWO7eNp7/9++wAAH2smnARM40ltvCyZo0QdTArud4o4bpQ+UCEc1QgQzdlPnJcKiNlqltP7+ZFJkgCS45maLvP2krEQGs6wqkA/xV41+vuM3LUzcddc5I3M9894V08rxWXcshL3aq7aHprY6w87m5LEm2voqCl02yE+IOsGzxoWxYAnlrJAGAvG/LxTbwHbcBDNQfxlCtIlbgAYdZ
 7+gR1q16
 KhntUWpEPYvkW5G9kREfNowB/U3M5ZrM54zjhrqj8r2OkA1rmFtfW7kCHZWS5sbxQGyIqRo7BRoS144CWxdbhFyCvkuLW6i4hc2lHFXF462A9jvsEhLv5ajhBd3nHfpX3LwWJ4Oi8vmShf/E2MS/Ly+fXexM62/z1t6TUCv8jtiLwT71Tj+sdNC40TyVCdyAFutV3rE3tEDmH2tXZUtFbcHshBTTzZWqsSxeIxcXUq9xKXXg+a0QopFNbEExEQjJxkYgzSiPzizdC5Huf5KRLBgC8J+KNVMbAL+ELfh4C+Jir4EBCDrlOJEsFtPrY65MtyLgpLnNiLBJScy/NQSEiQfWarCxS4XU1OYJPXQWp2zE8HR3J0gzOwg5W7H41+8PEGmzCMjcLCebEIXQ=
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

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-do-not-assume-file-vma-vm_file-in-compat_vma_mmap_prepare/20250902-184946
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250902104533.222730-1-lorenzo.stoakes%40oracle.com
patch subject: [PATCH] mm: do not assume file == vma->vm_file in compat_vma_mmap_prepare()
config: i386-buildonly-randconfig-001-20250903 (https://download.01.org/0day-ci/archive/20250903/202509031346.N6FpuQIA-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509031346.N6FpuQIA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509031346.N6FpuQIA-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/util.c:1145 function parameter 'f_op' not described in '__compat_vma_mmap_prepare'
>> Warning: mm/util.c:1145 function parameter 'file' not described in '__compat_vma_mmap_prepare'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

