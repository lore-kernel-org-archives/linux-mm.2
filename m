Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70805CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 19:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1876B00A5; Sat, 30 May 2026 15:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853376B00A6; Sat, 30 May 2026 15:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767AB6B00A7; Sat, 30 May 2026 15:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64FDD6B00A5
	for <linux-mm@kvack.org>; Sat, 30 May 2026 15:49:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDB981A0156
	for <linux-mm@kvack.org>; Sat, 30 May 2026 19:49:29 +0000 (UTC)
X-FDA: 84825125658.24.9F35C49
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F8A6180007
	for <linux-mm@kvack.org>; Sat, 30 May 2026 19:49:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bj83evpA;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780170568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jsiPV03p9qXK6UAhNTUB3Gg8jLbZ8F5+WyNP3D4YAI=;
	b=hk7em/IKD4XHhKJChe7o2QnXXkWbNfLjK0skjL1krcHZeptw79ePiAI7ILIZMEb/2ovUrA
	XJctqtSfK5ePiGE6CrjvQWTBXoqQXVAxtLViVvZJq2RuLtik95zGQnkXXt2LtbyHby78HI
	TRgMXmvJKI+hm1sP4RSy6R/x8JjELQs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bj83evpA;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780170568; a=rsa-sha256;
	cv=none;
	b=PbtSoL8X6aeCzeK1DxIk5ztNpOoslcxZcd5LSUaGFtJ3qhrO9IJAuZotmvhBB6nddVYs4d
	q0aTB+3iYv4IO1SyMKR88E57jyU91m3OrgyOjtsyP6wqBC8adCOYggh19pvLNJLhvUiXhV
	IggjdNIwBVHl1cdPuPu5Fa2zDOwC2Gw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780170567; x=1811706567;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r2HYZ1309/OZlVyvOT2l/OJyonDxhgfEY4CEmE5YdKQ=;
  b=Bj83evpAQbHIiFwQMJzLgSJSzWgmfTQOGsl6rOS3Bx6BqK3NniDMw9wD
   Ln+OGxI9TdgFsvzIp8R9K+5GaO5OKKPiTLUU67q16+EyEnEctNG2yzvh/
   7735MJF//0lNhaVkQBsUVtQLzEkEEPDYWy16v8m+01UT2FN7QKLXz5uOn
   nf/8Mu96MyEXvEfrJtOGs/XIu9nezHK9QQegKoEqGmiicjw5ldwblKPCH
   k4eT7xE0YD7Xgi28z6UpPmHIiRd/M03Tnz2khQ/qtApHK1QpV+PiRqdxE
   bs4iudqCYlhp8JdXuUdBSPn4vZdOlxaKI6CO1Bzqnrcda3k1LxPGvF5Cr
   g==;
X-CSE-ConnectionGUID: arhep6D4Seesdj0iAQjPWw==
X-CSE-MsgGUID: GKssiRxiSiWSfEWAu7q3xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11802"; a="92367067"
X-IronPort-AV: E=Sophos;i="6.24,178,1774335600"; 
   d="scan'208";a="92367067"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2026 12:49:26 -0700
X-CSE-ConnectionGUID: WrVI3wmXSVSZaKetzgcb6g==
X-CSE-MsgGUID: neI8wEgjR/qzIuBfSXLVLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,178,1774335600"; 
   d="scan'208";a="244979562"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 30 May 2026 12:49:23 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wTPgN-000000008p8-3PBB;
	Sat, 30 May 2026 19:49:19 +0000
Date: Sun, 31 May 2026 03:48:44 +0800
From: kernel test robot <lkp@intel.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Qu Wenruo <wqu@suse.com>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] loop: reject binding to procfs and sysfs files
Message-ID: <202605310318.dbidMe6W-lkp@intel.com>
References: <148efba2-a0b6-47d7-ac76-b19d2f4b696c@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148efba2-a0b6-47d7-ac76-b19d2f4b696c@I-love.SAKURA.ne.jp>
X-Stat-Signature: bx6ufczoagsxmt8hi6zc8iasguspksn6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F8A6180007
X-HE-Tag: 1780170566-727684
X-HE-Meta: U2FsdGVkX1/RHJ/SCDd6Y+VfntBrDX3yVVRRzhQHo9VBxFVx1JjmImi6cFNIuyLehnvq3leuWf+4zT4IT4L1GFnGwk6qxgdbhaGZxB3WYSNVW+xXb+KCvaHy3reNj24z6JLSBfg+dikuqtXXSnAmsWqDHQiTHrDdt1b/cYvy2P/4Ki8YDx3W7CotMnZyOzDmpczknJRCP8F8Q4QCW7ShbbX05hifz/MFxB86+F3SucmyAWchOZma0jUEUpXkdYVp+aOrabbhsAaOs5+J19j+B4RooFnImCMVqvYwEdFe9iuoaMfW7LFY5S8cvS3Ky6mgcaceeMCoFsVm38Cnzb/Rmit1tAwD9dGsVasXEkrE9tBl/uqPFJIjsTBGUEVEir5aIWdbTr9S3YsravxuKy4XlP1lwWInrzitfsXrnsso/ifOFowqQTUy0Wx3KClbGfaCFpOkb6Pq0jnFPL1QsYGUMK/DaScinNpmostjGCeePanMPq4v7l45dbSR8U25SgmbyzibfEzNZQbcdDRIJVEDbnSUkim9/SQRpJYr0gcnesGtceK7XFNRxwIrXJOhFp1KHqpqsUYn0e5HdCVO05+et6PWsRBfIqY4s8KJnfYJzNM1OH21lDm9K4AoGjq5DCaZtWEGpU1Bc7bGIbNS6k7grY0XxWqpyxeoO4REa4FZPwWuQruv9kn6oypJDkebYW6DKNt+1cYplhP1sS+Rv01L6AJ3SS/In96/vDJV6cBWrBCMLgFsVe78/Oelp2lNanJi491H2Hn3kXP1bBzXFWAOESlirw75edgIDdZdG1GXSb+5m56pY3TtqJrDN7hDOL1BXQUHkHhpqBiWXBjyZj0qfyzKBRK2gz17xo1ilDtPrQCo2FcD04rPoSRBhsCwr863o3nZBGjz/Pe5V6EXAO7QVI0e0KgATs4dpViFAzTQAadgW1gtkYi7atLs1UjhG3wP/s5GKXqD9RvWfjKI5uE
 7M4HEwWe
 usL4ZtniIIHuuL3a9RrpzCVP8FALXji0npXpyxuS3sOcpbtYbUa2nksJeQri36u4cizyLIPgVvbsuYm6fWRZH4o+kWJRYtwlmajZKbskwGioOLEzShhKVLnpOt+y8TzPJ0elU+4E4ZjG9uHDk86isWS5Kov+wsmbdRIKs/A+KTa6XvUrHa8sPP1CsPi6tAASCa3F+KRiCUxx4qPu/XxhljCdLOW224HS7YMvhjUnXaLgCAjR8RgyS42bOOMmDGfvFf/3isCEWiQSR2as1npvGxfru9avx4ffjoJmQ/kMp5NRheF3zYQGzExkjF+A8TzoGXQOYmC6ghCIn1MwnMY+NMV9pvEhfo4RkfDAWstAzzupjsLxUB9g3DxJOfEmwkA+P+ZS52ooLuS8ZoECzTmEThFMhZ+I+Fu1WNkCgfus3s4dSgbk=
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
config: um-x86_64_defconfig (https://download.01.org/0day-ci/archive/20260531/202605310318.dbidMe6W-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260531/202605310318.dbidMe6W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605310318.dbidMe6W-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/block/loop.c:504:7: error: use of undeclared identifier 'PROC_SUPER_MAGIC'
     504 |         case PROC_SUPER_MAGIC: /* e.g. "losetup -f /proc/sys/kernel/version" */
         |              ^~~~~~~~~~~~~~~~
>> drivers/block/loop.c:505:7: error: use of undeclared identifier 'SYSFS_MAGIC'
     505 |         case SYSFS_MAGIC: /* e.g. "losetup -f /sys/power/state" */
         |              ^~~~~~~~~~~
   2 errors generated.


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

