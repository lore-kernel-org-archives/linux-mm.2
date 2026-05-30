Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7954ACD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 20:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0956B00A7; Sat, 30 May 2026 16:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681306B00A8; Sat, 30 May 2026 16:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5973C6B00A9; Sat, 30 May 2026 16:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C32D6B00A7
	for <linux-mm@kvack.org>; Sat, 30 May 2026 16:46:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8736A8D7D0
	for <linux-mm@kvack.org>; Sat, 30 May 2026 20:46:34 +0000 (UTC)
X-FDA: 84825269508.05.5E25198
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf26.hostedemail.com (Postfix) with ESMTP id D204D14000A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 20:46:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kmX7QEu8;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780173992; a=rsa-sha256;
	cv=none;
	b=cDq2kRNrD7Ng0zBQtBlQ+DOu6CYx6foclq8ws3WkdRLij9GRUsrqleqZlzNQWLrSe152aI
	8Mb+4JRptHU+IGbg/mUnOGT/Fp80dsnt0Uv9W+H3FpILbMFOk4JTR+wc6Wek38O2FoUX8j
	2cE9m4eYj8V8WRPtnxEqWFfE9gdabTE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kmX7QEu8;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780173992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5IdoUwdC5PkO8GvZoEw9lpuz2Ii9C3Dqv3BsRg7330=;
	b=NqEkDX559rs79akJKYEqxxgkGGNUsmKMmf0rQPTJh/eWnwugoAeb+a2FbNj4CVlakjmOB2
	TO66iZ6o/ijZYey4wwFoD7pEKUf5awnEoVsv7ldctW5R8USFzpIpVXHrRowv359XhQ1bQM
	6J+F45heTt7DibMTsYt1eatentA25fw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780173992; x=1811709992;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IKhWW7LSJTC41x0mWNouiX5kSdHnHIBXrgOzOcenlZ4=;
  b=kmX7QEu8xqMhn/rpIp0aO49N3GBUapKlDE38OjpaXUzjMlhTt535bNYy
   ecMHONdO+piv3Hpq+iD3JU7DEWyT52pcAh68PhwyyPN3rEG3/3qShFnE9
   UkSj8x3Bjqv9zeo0ueGFIRK1t60y3ZIfCchu1MS/fzEnett8h3iuEREEV
   fqq9JDjtFyl3cpiNZDkaH+RrYA9AMLXCXlXDQnqq/jfak6Yz4pPQk96FX
   kEbM80OrxI2rS/eJo7bogFbaa0ReHueOXKdsO8kLYtwYqToYF/KHmlUUy
   bVRM0KBAFwU1IA3OGE98TpATYPVknadPsMTysDSoEzefmaVNu4p9/UYCD
   g==;
X-CSE-ConnectionGUID: JI4ECg/RT5uwlPWvak63ew==
X-CSE-MsgGUID: yYfGFvBgSxaNubz7wBVe8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11802"; a="80716598"
X-IronPort-AV: E=Sophos;i="6.24,178,1774335600"; 
   d="scan'208";a="80716598"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2026 13:46:31 -0700
X-CSE-ConnectionGUID: DGrd7KQqQsK+ayMD8X3rew==
X-CSE-MsgGUID: MmoRbom1RdK7+lt6il1nYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,178,1774335600"; 
   d="scan'208";a="238985489"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 30 May 2026 13:46:27 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wTQZc-000000008t4-1F25;
	Sat, 30 May 2026 20:46:24 +0000
Date: Sun, 31 May 2026 04:45:53 +0800
From: kernel test robot <lkp@intel.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Qu Wenruo <wqu@suse.com>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] loop: reject binding to procfs and sysfs files
Message-ID: <202605310413.Xgk6vCeB-lkp@intel.com>
References: <148efba2-a0b6-47d7-ac76-b19d2f4b696c@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148efba2-a0b6-47d7-ac76-b19d2f4b696c@I-love.SAKURA.ne.jp>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D204D14000A
X-Stat-Signature: 3ap9jzz3ym9754qr6rguq5c5xa4mwjm9
X-HE-Tag: 1780173991-276434
X-HE-Meta: U2FsdGVkX18ZmBFPTWwKjRMiO3QVCfhuABzhVWLPz2CXZbjfFMxz3t3pi+SMdpiLAAXxSpgT7ulvTYeGbz3hM4Go5LrJV3L9LVVNgyODWSdVINONYz/a7iz43zv1PUkT2fJXrcl6fwLweTweoZr/xtFZfW4keqmqtkBI2gQTqm3Kpbv7bJqne+Ef83mypMsVfznudCDGzYxiOunsItVSEU3ruEfgqJDF2wTBFZ/Uw/wENOiB8ZoXin/zl6LglZdmqKwfHMWAfmXYf2IF+uubsoDRSPDjC5U/BCBnkWNhomBRSTlLYA8ZA3Tq14oGGg+3gkQk3IkIUSmB0VXFYjysxIIDP2E078swRKtaFg9+Sl6/tcaU5fBNWBzOxV8DpKkXcpGE3UJ83ULXA2MzHgeRroNGI63TpXLSspRvW4vvD4Gk2g6kdTal/jweofCiQPMComNKsdmiWbjnn7OwcJFoeND57SmP9SwZq9H3kHKrm5gxCwHnFe/J/TNZAi71j44LztmY36HF2qi+mIXlv9aCQPK25FTvge6Bio58snulKfqgM1+AwbP08cczOjI0kdnjNn5+4XAAJHcaXoFaJ/4VJu0RSt/9uxR+RrLUhbu13CKUzEoo7pd1Tcsv1f4PuwHgMmNis9vB2My/h9I9oYVKFlP5mAE6taP9MccIEUzaupli4/KG7LgL0ZCCzyY5tCN68WJgren2yJwQd8rlgl1HsXXaO3ul6Ae1Du7m5HmmVGmZFGXfyFbHNV5dYxvCAxshJeIU32K84kRrl+7i1Ti9SH7ejfjYcPIEZ+mTSAwVaRJ8Pqp1eh/7aBTidqVLaCdc6gnEV7PRU05FUJVbKXlxkBEjzc6mqBOI22GUrl5hwnbqzPFIohFsLpqLD63GfDTQQVeqBL8V4nfCqrt+n5HMhILQOPM5LfRmNWsKAB71svWWgube6tsEt/VtWr6ikOHEQEaKCZJ2zCKw+UszQGL
 kItceXTn
 2vnO+JxFfgtiQ/qGKToeXp5EfWqsAyHdFoBqOjMwYn4Vp5BtOUGQ8qP4P089ApAWG8DeaU1e/88apmlTGgIS002JXjKB8ZjG+5fYZpHlxHrEYqtVI5XDr/1+3XdS1zPv3BmlOc5UQtledrDfMRIOqqFGCMzK1Yj4HeG1Hs3I8jGx5dwW4EwahPaoJAmdW5FcZUWzSbmrS6Z0QAFHOjN6jPQIUWFYpXUw4D6nix0xRWXH+FnXt+ZhPmtxgllIXLqrZ26MyFzW97YOLzW/YsG1Om9o2xw0WTtWXpRWK3GB1CChvWszAGKrL1XAsuotfDpsl9KsB6PoT+ML8oyRHdLTBN5iHmOZnEHX1UmMSqVvikS9wRxaEO92qqq3ufnq6hVlXNhlPW+SqkPMlNhQGYT0oXqkWvoaeZ8iJCZYv1qw9sTeIJSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tetsuo,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on linus/master v7.1-rc5 next-20260529]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tetsuo-Handa/loop-reject-binding-to-procfs-and-sysfs-files/20260530-214900
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/148efba2-a0b6-47d7-ac76-b19d2f4b696c%40I-love.SAKURA.ne.jp
patch subject: [PATCH] loop: reject binding to procfs and sysfs files
config: nios2-defconfig (https://download.01.org/0day-ci/archive/20260531/202605310413.Xgk6vCeB-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260531/202605310413.Xgk6vCeB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605310413.Xgk6vCeB-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/block/loop.c: In function 'loop_validate_file':
>> drivers/block/loop.c:504:14: error: 'PROC_SUPER_MAGIC' undeclared (first use in this function)
     504 |         case PROC_SUPER_MAGIC: /* e.g. "losetup -f /proc/sys/kernel/version" */
         |              ^~~~~~~~~~~~~~~~
   drivers/block/loop.c:504:14: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/block/loop.c:505:14: error: 'SYSFS_MAGIC' undeclared (first use in this function)
     505 |         case SYSFS_MAGIC: /* e.g. "losetup -f /sys/power/state" */
         |              ^~~~~~~~~~~


vim +/PROC_SUPER_MAGIC +504 drivers/block/loop.c

   478	
   479	static int loop_validate_file(struct file *file, struct block_device *bdev)
   480	{
   481		struct inode	*inode = file->f_mapping->host;
   482		struct file	*f = file;
   483	
   484		/* Avoid recursion */
   485		while (is_loop_device(f)) {
   486			struct loop_device *l;
   487	
   488			lockdep_assert_held(&loop_validate_mutex);
   489			if (f->f_mapping->host->i_rdev == bdev->bd_dev)
   490				return -EBADF;
   491	
   492			l = I_BDEV(f->f_mapping->host)->bd_disk->private_data;
   493			if (l->lo_state != Lo_bound)
   494				return -EINVAL;
   495			/* Order wrt setting lo->lo_backing_file in loop_configure(). */
   496			rmb();
   497			f = l->lo_backing_file;
   498		}
   499		if (S_ISBLK(inode->i_mode))
   500			return 0;
   501		if (!S_ISREG(inode->i_mode))
   502			return -EINVAL;
   503		switch (inode->i_sb->s_magic) {
 > 504		case PROC_SUPER_MAGIC: /* e.g. "losetup -f /proc/sys/kernel/version" */
 > 505		case SYSFS_MAGIC: /* e.g. "losetup -f /sys/power/state" */
   506			return -EINVAL;
   507		}
   508		return 0;
   509	}
   510	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

