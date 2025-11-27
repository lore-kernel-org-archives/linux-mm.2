Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3554BD111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A296B008A; Thu, 27 Nov 2025 14:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA516B0095; Thu, 27 Nov 2025 14:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9636B0098; Thu, 27 Nov 2025 14:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68D316B008A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:29:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 303F48855B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:29:32 +0000 (UTC)
X-FDA: 84157376184.22.E3EC1E2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf22.hostedemail.com (Postfix) with ESMTP id 72718C0008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:29:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oEgXcRsA;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764271770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z7w0Y+UWHlazqNd54TS/urgOPxmFfe5ziQltEKPZ1Y8=;
	b=doC+85BUp7onuGJDEmMU8hHAUGkhYnqAwFp4YiD/osRXMQPfi3DJbTs00mZUvI92RTUauE
	TCHF7bkmb1vWOg7DYsExlV5juMYa3XTxK38bTBfSS3KRXhDUCL3Uq5Rg2P94mGhcV9Jgql
	t7L/XRsYyIzgPH6sPWpIYWei0ctNMU4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oEgXcRsA;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764271770; a=rsa-sha256;
	cv=none;
	b=d+bPd1sJqV7LXQikztphw/E3KQzf7wL0vX5AYO9OXLslz1A7iDLMEHEM7+hwoT4WUUaf/P
	B1X3D6BzW2LoW44uo/9sFYjW9V+Em+59jm3UbeXkgEsgNmohiojPmqTkIRqrrcX4xIV73Q
	QjcLefHrSHzpkMIRjqzKAj5bRFXCTEY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764271769; x=1795807769;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=IoJDqo3p2KUZ6CfHm4PkzJhsZADgqOzfnts8yppvMng=;
  b=oEgXcRsAZYH0KmA1gcq5lRZSrOEO6y1/OtVILq6Iq3fZjl2I5WNbmPFQ
   eSk8VS9Ug548u84KK9g5NmeziHne26RYOqw7yUTGSKM2tNATfE+XyA4Cs
   tXWO5vGlwtqaO9sTspIHVoiFnrFSvVHZeXC0ao9Bk/AOFea1PYs4+ax1w
   LINtOeuowHEnCWmQdnYWFVbbohUXD4GqgrFGs4oRQYO2gX3k0W1KNRYtx
   lCrIuD4mKu12MkxiQC6E2wdbuaLserkV6vb85zFSmEmBMLPlLEN5LBBGA
   Kc7/LlHNgX1x3e4i+hTkx1kC2WN8O1fhsjNvjJH4ujVhFt5EfOVH4QTo4
   Q==;
X-CSE-ConnectionGUID: uoIU910BQfuKo5IFXlz5jA==
X-CSE-MsgGUID: TvDcXQdQTguSoyFEUE1eWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="53887355"
X-IronPort-AV: E=Sophos;i="6.20,231,1758610800"; 
   d="scan'208";a="53887355"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 11:29:28 -0800
X-CSE-ConnectionGUID: fadmlSSgRNuSAaw7Dnv61A==
X-CSE-MsgGUID: yU2C/FaKSR+ZZk22kjhrzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,231,1758610800"; 
   d="scan'208";a="194095708"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 27 Nov 2025 11:29:26 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOhgC-000000005a4-2EiN;
	Thu, 27 Nov 2025 19:29:24 +0000
Date: Fri, 28 Nov 2025 03:29:05 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [linux-next:master 12118/12398] kernel/liveupdate/luo_core.c:402
 luo_ioctl() warn: unsigned 'nr' is never less than zero.
Message-ID: <202511280300.6pvBmXUS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 72718C0008
X-Rspamd-Server: rspam02
X-Stat-Signature: kyzod9iqw7zhn1jfbj3eijyfnszqd5rc
X-Rspam-User: 
X-HE-Tag: 1764271769-292343
X-HE-Meta: U2FsdGVkX1+pkQWGXPisoxI6YUmBM9G0E1sGNDbe8LGY7KmoQ198LFBGjpnA18wQ/iTC8V8mtK6UubUAnrvqeXOjUsQDXYhfKPsKt4xYykBiDZrSzAulJwxF6R4lw+qK9lEJjUoJIHXnwH7qS6LKIgLOkrZOZOWiuVOeoj2ARmn7sWuVOZB7gHioMfrgnfo+OjQ1goc0MLwxv91XG6SyIeIzHDPmT0twhwYHHPW8jBxJRT8otdZJCOykyPOYgLJYZ63Qu6eTECRr5YPGaznITmObpuXRqIxArpml1hMQp2s80Cg3vt3RvzjFRi2EkaKgg/dq4hpHIlaOvG51/ScHp7rNzp5BlIfTHvPPu5KUKuk9hE93LYuHfe1xoEqLWiROb0HY7kDZlyAYr8QZvck8PpOK8LZyyDRATPwAPSi4ESMmpA89jeJMMCQwbWH/hA4fANR4hFu3wmsMfqMFL8YQEc30rPxaxWCFrwc3WsuHoX3Gr7zvpy+ajKy2ctNrU6ZbtD4GBJwLM1d4DF7Z1I/DO+aYNRDrigG34KaW8i2NtATIWqx4V/c+rJEx/4qzBjO23K4RtEoQq2fh+PdGH+yjTSWKA6NZWCyNppTtKnCcSRVI1cT2BxDdlkF9qIvn31kmXFyIw7cBC401TEbiNDvwE4Fnvje62bqzJj+w6ZO8/5zTf88IDoZ3PqsvlTIjKa50k9qltaJR3KIGIBd4XkhDgv73kns4MjGJPZcGUdeSFa1M0c707uCpRRwDG7Pep5SZafnTezYLJPxh79+aYvmzRBtEN7VXbPJYh/3rDlECrSc16HD7cQl8pmyEOC491MQwTkMoX5qKCadIKq4k/HeXHHxk1B1gA5Gd8XfPfIpDrDxC3ttvGYrjVjlyjiR1Lf2x/2Oltuwc0xbAr2b1STctpEpLi0SfQnRtg1TLypRjsnNRNO9jLkANap4lpb6xYIlvDszMfpfE0BnkNAMQlJk
 7e8pvKu9
 BOjTJp7OXOTliNqN1DwhNQ9Kph5Cgx66mxdbdtRzZ+mlgFcWVF42Vl47z5hBrxS7IYCXw8z3qsxv8mdYul6z0mO/vuPrTwNniRg9LCN9TMu8O0SgK4qiIYThkDnn1E4fNkc3n9hMzoLcci+yaiEAWB//sINaQNysZ9MCuL+00BEslfgpwNcyXtllHhKRjc+CCGf+inlHTC9bZ8fz/HrPqqFfXJLomGKpIgD5rn6SBdNx9M6BqalWy2Yi/yPXf5cZl6gxDYG6Ub3pqHAAPsOHaL4ccsmKmbXcSddYLELD49iSaGDMRfioKoXHiLOhp/x1TjsnvlMmw/VKFijUeT10qyiC00ec8zUNMkp35OpFYdZv151o3hQdWFCWrOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   ef68bf704646690aba5e81c2f7be8d6ef13d7ad8
commit: b30a1fee674c8446bebd9e399b267ac824093bc8 [12118/12398] liveupdate: luo_core: add user interface
config: x86_64-randconfig-161-20251127 (https://download.01.org/0day-ci/archive/20251128/202511280300.6pvBmXUS-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511280300.6pvBmXUS-lkp@intel.com/

smatch warnings:
kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is never less than zero.

vim +/nr +402 kernel/liveupdate/luo_core.c

   392	
   393	static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
   394	{
   395		const struct luo_ioctl_op *op;
   396		struct luo_ucmd ucmd = {};
   397		union ucmd_buffer buf;
   398		unsigned int nr;
   399		int err;
   400	
   401		nr = _IOC_NR(cmd);
 > 402		if (nr < LIVEUPDATE_CMD_BASE ||
   403		    (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
   404			return -EINVAL;
   405		}
   406	
   407		ucmd.ubuffer = (void __user *)arg;
   408		err = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
   409		if (err)
   410			return err;
   411	
   412		op = &luo_ioctl_ops[nr - LIVEUPDATE_CMD_BASE];
   413		if (op->ioctl_num != cmd)
   414			return -ENOIOCTLCMD;
   415		if (ucmd.user_size < op->min_size)
   416			return -EINVAL;
   417	
   418		ucmd.cmd = &buf;
   419		err = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
   420					    ucmd.user_size);
   421		if (err)
   422			return err;
   423	
   424		return op->execute(&ucmd);
   425	}
   426	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

