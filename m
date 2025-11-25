Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB15CFD368
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 07:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095716B000C; Tue, 25 Nov 2025 02:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046286B000E; Tue, 25 Nov 2025 02:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76E26B0010; Tue, 25 Nov 2025 02:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD70A6B000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:00:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23F738A37D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:00:23 +0000 (UTC)
X-FDA: 84148230726.30.CE97173
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id 075B840010
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:00:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mfhve5X3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764054021; a=rsa-sha256;
	cv=none;
	b=oHDE+RF8KKaRy6TDDHj/2Cq+AxHfb/15HT0CtlqZYEQPI0s1keuvMQQGZjBo0oMztdyALr
	2VMlpViAXTpzoCZ9ZYUrC4pnitl/RXVF9+zDVqq3NOXICQS6uC3+EEQ1Y00yIlY6RrYE21
	OUv9TmxbWqwkBSbUCyuGSXX0udOV/7c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mfhve5X3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764054021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+cy31K3dBAOmx5UrxM2qJxA6NHcugxGuxJdpzqyjJ4=;
	b=qL0T9FggYsz52WlO8oYvOE9PAiHcy4f0sSD9yyZCrEvZiclL/2jA9JqCuicBFQrn/UZ72Z
	dfBk+VHoR5Wr7ZuP193wJVhM/1WR84zyPiasPJuU0wlUgNtpODCQPGhxsVmk3IEl+B95ZS
	lvmD4UTX90NJSF9/s1Kxqg3QNs8B2Q8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764054021; x=1795590021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OMcXJ2dkVm7jKJ9rum+8R9nzWkBHh1MYXvp80cM24SA=;
  b=Mfhve5X39LqenxMvBD8b4wSgI1VVtvHtfTWJQCLPWh05QZHjSYctj4xC
   XWTEK7Y3cb4C5RO6ThU4N7+4HJw4cG2RBMve2buVYRPz9oDudA5sdOGSS
   F+gun8gQi4/RDLennSVk95eUXNgp6MxVsCzDaJYp/4wrwEXARNMz7pzW/
   Bdlf848659DEHp6zSNplnaZ7SgkzTeouwGigJxxf6u5f4LKsO76HgGR+1
   GIsIuAExESe+LG9Se/dLLfmgzE4d9X9m02ITprO+fbwbrhbYE3GChPOkY
   /JR+83IEIQxrJ4BiQs1WURCfp/xVmaWXxnTa1e3sURg3YWaBhrtx3uKfn
   A==;
X-CSE-ConnectionGUID: 1g0MlBo4SBqsJwAB7+K/Xw==
X-CSE-MsgGUID: 9l/gHsUqQMW8RErImdz3Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65952040"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="65952040"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:00:16 -0800
X-CSE-ConnectionGUID: znWy9/oWQbi+RJXZ3xcLbA==
X-CSE-MsgGUID: svTfXJE4S8+gb+Ng3MRsKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="192631933"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 24 Nov 2025 23:00:11 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNn21-000000001Rx-2WBZ;
	Tue, 25 Nov 2025 07:00:09 +0000
Date: Tue, 25 Nov 2025 14:59:25 +0800
From: kernel test robot <lkp@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Guangshuo Li <lgs201920130244@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] [SCSI] hptiop: Add inbound queue offset bounds check in
 iop_get_config_itl
Message-ID: <202511251457.AUHUgeyl-lkp@intel.com>
References: <20251124145848.45687-1-lgs201920130244@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124145848.45687-1-lgs201920130244@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 075B840010
X-Stat-Signature: u13atx71y43z8aq63b9o6n8uqisbnx5z
X-HE-Tag: 1764054019-556828
X-HE-Meta: U2FsdGVkX19TZ1Oid0Dd3ZPjaPt5Ks9Gnf/vY44v6lM/t0h0OsRnwcidNnAlc6pY1zJ3tInEUu5BcvJeS0W8Bse+uC0iKPLJ80JuM/3EiEXyPOUVcPxF58hVTyVQQ59snYpLLlKdY6L1UM48Am4E958XSrk5wyI7VhYtBg0wWriF4YeU1jU3Tegm3+L776jh+yNJKGuHmrowSqVV5JoJX1RrF2wYqCR7UxCs86RnBUJMoyOU5v9ZoGEQA8b8ijbc1+1+i6Qu8+knP1OO3eBWT8dqaBoBN2HyLw07d4p2V9JP9ax4KVTU624rJhtaOls3RLZeX0LyGHCMGenEeuwn4XVFoGKelEwdPPCnLaUa+QgTzOrJPbN+Ie49pYhF8dTb5Vh2PhETo4aPz46LxcxBLUQB08DXwLGmVQNXpWlI+jN0IrMl4HiUpW2AgzjOgyW05+1rPB7TTPHeJSDXDGD7tsCDwZsYWu5qtggAzBe4FWObjl91KqMo+QuIKKfcN2oIX3H9ux753+Xs2woemVreLGFVAXrTvyQJld55CQYrwlRUlfg3HjyNcuesHi8cyAYcPXlUJBKJjKHKAA5AlQQjJa0TmIN8rGo9K3vhixnJmmFMyaNT+GwfiNTa+YCN7ndjwm2dNzXzZBK9ogYU00lMqfKqD5cLzKe+tTOfJN7gBnPcFxKWhkuLbX7Tg5TQlD7nqnCNh39xAlo8yMUtrxN7Gy6c/Yvlb10983IJOeV8yU4v6CfSTC8Lt6AUkW0GlsYupsrVVibQWYON8luCxMKJH/Ow7REKsyv7OEQJB1UONCWC7F1sLJvsQG+bIeA1mFMnIYByFSAYT92cHAsop7+WlBXe1yAgwQbocmeSH4nLClQBIRdvI+6lLGBNkAMAkNQWJoexfnOwNdbmgSSkRCYOJhIAKKeUKMceGUvZqJiFkZhcK67OT/B3jJPiOpQC82WSWAfZrXOSttQLNc3l9PL
 oreqz0AT
 vuuMqRN+ubCq+RjO5oYfprPwqyr+j+Dt84WLUfAkeW9hh0JklyS2adAKGrcZK7TyjvGeqALsJauEJYO5sTV5EzZ4bYwsNa5RJM0UF+Rus0o7bu/x4lVYhHGCzFuf1+2FAPTfpnQNyPaZxsjIITo1BTJuQApERrv9hqmrFSAlzQHwspi+K0Fo/VsEKFaIw9mcBlHLk7HJ3STaHNj6AkD0OAi8VXc3D2huajkpBjydsO+2JXS269GUUcZqIMwLJiGt1lYP1g/p511hbvMZ5pdmWuzKUAwV2Hy0YKE8mcrJuW0wSoDeQcWTBi1E5Alr3J3sCnK/uQkDAfSR8EMrW6e3KJhQFRG37a+eDw+jYK48TZHIeTmJpHFuHyPzAChSImpMbDHPAWkV+1iBibYmUyqOGNuXZTVBIrzWyk8a2JH6siJIqDks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Guangshuo,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next akpm-mm/mm-everything linus/master v6.18-rc7 next-20251124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangshuo-Li/hptiop-Add-inbound-queue-offset-bounds-check-in-iop_get_config_itl/20251124-230112
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251124145848.45687-1-lgs201920130244%40gmail.com
patch subject: [PATCH] [SCSI] hptiop: Add inbound queue offset bounds check in iop_get_config_itl
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251125/202511251457.AUHUgeyl-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251125/202511251457.AUHUgeyl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511251457.AUHUgeyl-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/hptiop.c:170:17: error: no member named 'pdev' in 'struct hptiop_hba'
     170 |                 dev_err(&hba->pdev->dev,
         |                          ~~~  ^
   include/linux/dev_printk.h:154:44: note: expanded from macro 'dev_err'
     154 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                   ^~~
   include/linux/dev_printk.h:110:11: note: expanded from macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                         ^~~
   1 error generated.


vim +170 drivers/scsi/hptiop.c

   160	
   161	static void mv_inbound_write(u64 p, struct hptiop_hba *hba)
   162	{
   163		u32 inbound_head = readl(&hba->u.mv.mu->inbound_head);
   164		u32 head = inbound_head + 1;
   165	
   166		if (head == MVIOP_QUEUE_LEN)
   167			head = 0;
   168	
   169		if (inbound_head >= MVIOP_QUEUE_LEN) {
 > 170			dev_err(&hba->pdev->dev,
   171				"hptiop: inbound_head out of range (%u)\n",
   172				inbound_head);
   173			inbound_head = 0;
   174			head = 1;
   175		}
   176	
   177		memcpy_toio(&hba->u.mv.mu->inbound_q[inbound_head], &p, 8);
   178		writel(head, &hba->u.mv.mu->inbound_head);
   179		writel(MVIOP_MU_INBOUND_INT_POSTQUEUE,
   180				&hba->u.mv.regs->inbound_doorbell);
   181	}
   182	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

