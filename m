Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A11CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 13:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49018E0005; Thu, 11 Sep 2025 09:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF90C8E0001; Thu, 11 Sep 2025 09:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E80B8E0005; Thu, 11 Sep 2025 09:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89C868E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:24:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D34C13A878
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:24:55 +0000 (UTC)
X-FDA: 83877039750.26.7848BF2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf02.hostedemail.com (Postfix) with ESMTP id 959E880008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:24:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nglXQFAA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757597093; a=rsa-sha256;
	cv=none;
	b=tfEYOAMrd4PMAxcuf8ZOcud4M0Nk8Qc5pvQlAouTRRS1cERJfJEAdwyR/tmUvEECOWSBjY
	IfPlALezxTcsEZH4/hCENREJhKz289WH1p+wO6CYatcpLY+yuWbF8bBjkOwuRBESkx+9bt
	X9i7HPh6dWdUD7IZ0wdReHDwwF3uNUo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nglXQFAA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757597093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1bgzj1FibOhcu93jpOSuac8l4sB947S6RkPDa3rAbOQ=;
	b=X9ckSCM03O6CvyWN4prfzdSxz1pP3Qx+Nm8evRE74mzhAMOyX8Ays2Djr0uqgVFVoKjicO
	QRm/ymEeyJFSLXHL8byMRVSdvptcL+xFWdK/ej/vz3yMXF1CGbUI52+8Q5XW3D3R7x/YlW
	IaqRVPomYClhvzdO3E8UnF6aEGr9loQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757597093; x=1789133093;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+AsJA3fwN7ebjrzACnOVJAO4yIltEC73u1ZO5SGyLdo=;
  b=nglXQFAA8y1OWgfyUstOC5/7/xIry/AfWiGI3W6buLK2C/jM9q/n56Qw
   2oNjrut3miHGMQUt3yJVcZZpQR5BMr+MBFYatoczVofXnbE3TzJHDcetR
   52v0Zc3YYdqCmlqqPLefMPXU8wleX4U3iwDjrOVdGB/O85/4Tn+R6dOAo
   9sU9GcHzusT+IS1N6pn7BKDTnae6g6eK2d20ex7UkPK0b3JNglG6QKw+D
   2+rwDAqxg1befLN4O/rSgb/MWODiIVH7S/fYKQVztQijjy7zCQATfRFH9
   neBwwm5MzE2IYxDmAMoIuN9wP1NC4F7l+qzA2kcSim+S9UP9JPBpC4Xun
   Q==;
X-CSE-ConnectionGUID: 7f4yAjqFTQibl3n2tnKQRQ==
X-CSE-MsgGUID: dfdov5omTOCT5PoWJHMPkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63753556"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63753556"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 06:24:51 -0700
X-CSE-ConnectionGUID: MR/LBW95QSWzZ6cAFa+EDg==
X-CSE-MsgGUID: qie/tJ+bRQy6g6/ytI3+2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="173763974"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 11 Sep 2025 06:24:47 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwhI3-0000Lu-13;
	Thu, 11 Sep 2025 13:24:43 +0000
Date: Thu, 11 Sep 2025 21:24:23 +0800
From: kernel test robot <lkp@intel.com>
To: Justinien Bouron <jbouron@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Alexander Graf <graf@amazon.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Gunnar Kudrjavets <gunnarku@amazon.com>
Subject: Re: [PATCH] kexec_core: Remove superfluous page offset handling in
 segment loading
Message-ID: <202509112118.1NElSKNk-lkp@intel.com>
References: <20250910163116.49148-1-jbouron@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910163116.49148-1-jbouron@amazon.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 959E880008
X-Stat-Signature: 9wzrsyscwa1zn8diwmoj3byiqkygokfy
X-Rspam-User: 
X-HE-Tag: 1757597092-605255
X-HE-Meta: U2FsdGVkX1/Ehvr6cJV7pg9Cu0c+cZo2dNirsCLzRX15kAQ054YCVoTuHeXN1CUFiS7SA3HGjAmB0qhon/XiEw0xXd2WKVkxp0BwMbBccGz//RspxoenyOJb4Xuw/HRcxWj1CNpD6+xT+V4vCm9MJh3rpUVXtguGKJomHKpCymgs+DQD4/gMzHAjYDlCQIsGb2GDQLCuv8Pe5pf9bttAsvmxWVnNd63yW0by1UD4LHRDMOSPZF/qxitaZHeuL2AUkS/HsZTKgohvMqVstMhwio2GWlPWBvXcP5havxR0ZJmHjFMMICBHkSZDi3lQrO/mTs5h4EYYW/mcxSOKrl0y11E/CQW8vAAPJmwbmYKLxjg5MrUM6zpkZgh3GeGbL9s2Rz8ItZAu4XPyc7TvComDj+CWzaxCf908wm8oa20eTb+p4By2fkdAcUoD5USPLbkySnXDtBvnY3P3wGzJwdoJ308n6OT8E9Y8HgaI6C1E4SYLlhDTnXl7hLuzgSU+tZIrsDJWdqr8h0f80JvCCb7Li0/4vHhHdP0P//mcmALgaaGAwT8WBxXMYtjCA1Mi0AErAX61WMQepigJ8iIuuKrRsPGW1Rh5UIwxJCfakz9CK8Qsw6LyO/ePzGTq3k7i9LpjOux98OTjE+qx0zaN4LzZdxnB4g31MIOnGqEgX61fnuldLhkGI+5yud9WGZ+We8Lw045dTH/nZ8jow8Ktp4EgPzJx2v8gOoT5lY1WxQuIbEfBEc+014/xjCOoHtBvEuuGZ2l5cJ9kHaBpI0MuzMFSK+ADsIxb3q5boO+7lGEQ/vO8CxqZ3v8Kr6r8GO23r3CllizlkJqJGpF5nVMuxI7zYklIEW/e2Drt/r0+UaH4eIp0j7qWq3o2BNX6P7GyCZUX2HlqpRIyLZjWQsFvIaUp4WUgaul8BtCQB9cXmBY5J1/Nr1eNVdJ9OTxSOAj3LSHz68f2AywQjwP2u4XhbsC
 ewvlTWLx
 rKa8Tmpr1HDGDQObSAWJWea6bUdovI5lCE5tGyMTkhAKwDhKw6jFtnjjglKa33CkXYsSFyAqE6gDlrfx1dkFMFqePnKzoCTgem0TTEI1XPmPxnHF/g8cM3vYUh18hf9jXe95PKECZpNoIC+zyXwTEQGUkhoLvBjh55UC/kT0U2gm98LMM7JSicGX4MzYpPOFDVzD3MqF9Oz7FSEJ3/buc4C2EdfgxYeIntZOIxkGDnOmHsf/BeD0Ed5Ujqw+BR2CNVzgckr6QeYNx+hozZ6FTvq0q3/zHbepKn6giiTImLUPbavHsbtD6VJqhy/9rj3IYECDSgAOlvnGi5dhEiobh/3CNTJfyE2UHYvmED5cbgxCnLh7oATHpOjUrxmBeXk911woLu1aPWl96lfyKwYAvAQqjri761AwwdGVMGzBIuXmr+c0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Justinien,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.17-rc5 next-20250911]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Justinien-Bouron/kexec_core-Remove-superfluous-page-offset-handling-in-segment-loading/20250911-003354
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250910163116.49148-1-jbouron%40amazon.com
patch subject: [PATCH] kexec_core: Remove superfluous page offset handling in segment loading
config: x86_64-buildonly-randconfig-004-20250911 (https://download.01.org/0day-ci/archive/20250911/202509112118.1NElSKNk-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250911/202509112118.1NElSKNk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509112118.1NElSKNk-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/kexec_core.c:745:16: warning: variable 'maddr' set but not used [-Wunused-but-set-variable]
     745 |         unsigned long maddr;
         |                       ^
   1 warning generated.


vim +/maddr +745 kernel/kexec_core.c

2965faa5e03d1e Dave Young       2015-09-09  739  
07d24902977e47 Alexander Graf   2025-06-10  740  static int kimage_load_cma_segment(struct kimage *image, int idx)
07d24902977e47 Alexander Graf   2025-06-10  741  {
07d24902977e47 Alexander Graf   2025-06-10  742  	struct kexec_segment *segment = &image->segment[idx];
07d24902977e47 Alexander Graf   2025-06-10  743  	struct page *cma = image->segment_cma[idx];
07d24902977e47 Alexander Graf   2025-06-10  744  	char *ptr = page_address(cma);
07d24902977e47 Alexander Graf   2025-06-10 @745  	unsigned long maddr;
07d24902977e47 Alexander Graf   2025-06-10  746  	size_t ubytes, mbytes;
07d24902977e47 Alexander Graf   2025-06-10  747  	int result = 0;
07d24902977e47 Alexander Graf   2025-06-10  748  	unsigned char __user *buf = NULL;
07d24902977e47 Alexander Graf   2025-06-10  749  	unsigned char *kbuf = NULL;
07d24902977e47 Alexander Graf   2025-06-10  750  
07d24902977e47 Alexander Graf   2025-06-10  751  	if (image->file_mode)
07d24902977e47 Alexander Graf   2025-06-10  752  		kbuf = segment->kbuf;
07d24902977e47 Alexander Graf   2025-06-10  753  	else
07d24902977e47 Alexander Graf   2025-06-10  754  		buf = segment->buf;
07d24902977e47 Alexander Graf   2025-06-10  755  	ubytes = segment->bufsz;
07d24902977e47 Alexander Graf   2025-06-10  756  	mbytes = segment->memsz;
07d24902977e47 Alexander Graf   2025-06-10  757  	maddr = segment->mem;
07d24902977e47 Alexander Graf   2025-06-10  758  
07d24902977e47 Alexander Graf   2025-06-10  759  	/* Then copy from source buffer to the CMA one */
07d24902977e47 Alexander Graf   2025-06-10  760  	while (mbytes) {
07d24902977e47 Alexander Graf   2025-06-10  761  		size_t uchunk, mchunk;
07d24902977e47 Alexander Graf   2025-06-10  762  
b4cdefb6ef1453 Justinien Bouron 2025-09-10  763  		mchunk = min_t(size_t, mbytes, PAGE_SIZE);
07d24902977e47 Alexander Graf   2025-06-10  764  		uchunk = min(ubytes, mchunk);
07d24902977e47 Alexander Graf   2025-06-10  765  
07d24902977e47 Alexander Graf   2025-06-10  766  		if (uchunk) {
07d24902977e47 Alexander Graf   2025-06-10  767  			/* For file based kexec, source pages are in kernel memory */
07d24902977e47 Alexander Graf   2025-06-10  768  			if (image->file_mode)
07d24902977e47 Alexander Graf   2025-06-10  769  				memcpy(ptr, kbuf, uchunk);
07d24902977e47 Alexander Graf   2025-06-10  770  			else
07d24902977e47 Alexander Graf   2025-06-10  771  				result = copy_from_user(ptr, buf, uchunk);
07d24902977e47 Alexander Graf   2025-06-10  772  			ubytes -= uchunk;
07d24902977e47 Alexander Graf   2025-06-10  773  			if (image->file_mode)
07d24902977e47 Alexander Graf   2025-06-10  774  				kbuf += uchunk;
07d24902977e47 Alexander Graf   2025-06-10  775  			else
07d24902977e47 Alexander Graf   2025-06-10  776  				buf += uchunk;
07d24902977e47 Alexander Graf   2025-06-10  777  		}
07d24902977e47 Alexander Graf   2025-06-10  778  
07d24902977e47 Alexander Graf   2025-06-10  779  		if (result) {
07d24902977e47 Alexander Graf   2025-06-10  780  			result = -EFAULT;
07d24902977e47 Alexander Graf   2025-06-10  781  			goto out;
07d24902977e47 Alexander Graf   2025-06-10  782  		}
07d24902977e47 Alexander Graf   2025-06-10  783  
07d24902977e47 Alexander Graf   2025-06-10  784  		ptr    += mchunk;
07d24902977e47 Alexander Graf   2025-06-10  785  		maddr  += mchunk;
07d24902977e47 Alexander Graf   2025-06-10  786  		mbytes -= mchunk;
07d24902977e47 Alexander Graf   2025-06-10  787  
07d24902977e47 Alexander Graf   2025-06-10  788  		cond_resched();
07d24902977e47 Alexander Graf   2025-06-10  789  	}
07d24902977e47 Alexander Graf   2025-06-10  790  
07d24902977e47 Alexander Graf   2025-06-10  791  	/* Clear any remainder */
07d24902977e47 Alexander Graf   2025-06-10  792  	memset(ptr, 0, mbytes);
07d24902977e47 Alexander Graf   2025-06-10  793  
07d24902977e47 Alexander Graf   2025-06-10  794  out:
07d24902977e47 Alexander Graf   2025-06-10  795  	return result;
07d24902977e47 Alexander Graf   2025-06-10  796  }
07d24902977e47 Alexander Graf   2025-06-10  797  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

