Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6023BCCFA05
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 03:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992038E000A; Fri,  7 Nov 2025 22:52:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942B58E0003; Fri,  7 Nov 2025 22:52:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831278E000A; Fri,  7 Nov 2025 22:52:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63ABA8E0003
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:52:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8BDC89321
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:52:10 +0000 (UTC)
X-FDA: 84086066820.09.1FDA61A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id C688A40002
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:52:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bdvgCmFx;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762573929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y2Zi1+67+kwrKskStRqobp/hD9BQNKLRohhrYlkaFFc=;
	b=rsn5ZWSUu/Pu3yQ5JufeW9nFOZhuifpUHU4L5StzI2IClLM0R+di/IEGKPJYvsPisQTvSY
	ucXvD8s+lAC2N4Xt2f7cEWKgaUjLZM2n/EQ6Eo8ImVTbXr93zm5lgwmc5ymWoc5oQPQ5+X
	CYD/TyZPgDfd87vn7RPvhaGSv/bufV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762573929; a=rsa-sha256;
	cv=none;
	b=OAlpDCeC2RbRu1BJRmf3TRv4ItnKvdCGYapbjKTERHb63UbiFNITbj/B0wSUzMdur7JZHc
	kjXBV9sodQnTcojG1UavB/ibN9iIKGAM7d0qmYDQtUe2ISkYLA3FoekVaLVcqJs2GkmO0n
	GvsSBdXhAUfr1n0uqHbCKvuzFyJn5xE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bdvgCmFx;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762573928; x=1794109928;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=QNByaqPtxYoKLlVdpXtlCQUMyBvVqjwNo4P5QDQhNyg=;
  b=bdvgCmFx8m0+2NKujQKlqhTGTTEi2mzhdZLZtcMVhI5bHgEZQD4q0X8B
   +sYEYMmTJm8BSSgFxXYGaX8Y1GXOguw/rShdVYAgVrGr6a/vwfGQSfLeG
   SRltiwGb8YGQRM1n/Wri/kmVSyREFX0Ks+ouJhqMPRDCuCu3MN3sUQOKt
   xvh6I9h8s5HwzrzHetByC0y1SxojYs9YXq0POk7CQx4DnnRavsG7rYUx2
   nm0S1nWJhBf1y6J57s2ZjyUUgXJWeTWb3UrnVolTsAUEa3Jk0TSnkwC56
   MXcvzMxuUBNfbGFboUb3WQ8gt+DVYRH7m+N99PtgfjrrvpFdkwXD7sXs0
   w==;
X-CSE-ConnectionGUID: TUwk6gbrSRauIHdgj93s5w==
X-CSE-MsgGUID: RnQMKl3gRHqcCYFpvyCrnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11606"; a="75415541"
X-IronPort-AV: E=Sophos;i="6.19,288,1754982000"; 
   d="scan'208";a="75415541"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 19:52:06 -0800
X-CSE-ConnectionGUID: qIkulXAlSCG2vMOmoTCWTQ==
X-CSE-MsgGUID: wHUyVuGATzebfboJ5CQHng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,288,1754982000"; 
   d="scan'208";a="218937801"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 07 Nov 2025 19:52:05 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vHZze-0000gn-25;
	Sat, 08 Nov 2025 03:52:02 +0000
Date: Sat, 8 Nov 2025 11:51:06 +0800
From: kernel test robot <lkp@intel.com>
To: Pratyush Yadav <ptyadav@amazon.de>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: [akpm-mm:mm-nonmm-unstable 129/139] mm/shmem.c:5811:23: warning:
 unused variable 'flags'
Message-ID: <202511081101.9sXNBrzT-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C688A40002
X-Stat-Signature: 3xnrq4i5nwdx8n1wegyjz3m3xgoz4k6s
X-Rspam-User: 
X-HE-Tag: 1762573927-317705
X-HE-Meta: U2FsdGVkX18kLQeM2GcXrWsmz2okOfBuMgkj4eZLCGVm72uRBHZHAyivmRO0AGOapDzNvh1q/bm415Dgtzx844PcGaAaHGB/TTRWql0ls3j+xkoaM/tWenrFC2FM377vN0jU5zHmjaJfMbOpobUbXFvEypd05AHkSmpBPdVslI/xr9fxxjstO57fxBBwSNIlnYZ7u81ZI4643MZ0BjPrIx52PMblEKpPhalxu/KqxlhhG8PknrKTOWMZfvecvFoHR5U5+rN7KtpgBAsr09GWVRmV2SYd6V593eZMHt5MXOaCv3OKTN8YJHvJ96ei1CoJp1bFnPU1r9QPC2OhXmbBYk5edv38n82O7R7di/g8idyMH93qF9MByjNa/SveAIgvtvO3YWd5yRhwOSo6J0T0lTjbTZSNMXwo3NMWx24nrP0DkSslY+1ZvUKT1XKaGxVTlRp+XBGW8dzqvw8OjxU7mX+nZA/ScZErL0Fd2wpfTw8gFpEUBDpCjSjhWeHyoMu1+9buSGT2zUSzHNHhQiHgRHdQWRM1mDGHmY7dJJ0F/7eXHZfguzipwyNisiMLwUkbWlKXd/xMH3wlwL5oB3ngy0+SZ6SKxJn9Z/A2rwCK06QoRSd64W7Y4BtyXCXuuGYwi8v46mQkhYD6ThvLdQmXg4qt60SbII/CUBvsjJ5Cte5RIJpCXKXVKY1uTUPiKBJxwnEB2yPutsUqwtLH3VfIfANW8JkU0JVoKDX4UwCqGWTIG7ZRnGDt48yCj6PpR8sgjTs9m+u1DkLbDmk2Bba6RkDy6L0kBfwenvjNGHPjlVgpQlzAj/tvQFuoF/WI6rzOzCXXWI4kEfsiGhiNEAC2MzL93MdU4FGMMScH788C6aa6fH3qtgKsRQf33FSPNoVr8TSsRid2RpJwYZDYbRK1wxUwzggFELhtKPujogoTElyAnqghzuipWTeaf3BG/HfrJrALqurvTpDY2bVMcQ6
 m1TTjeDQ
 sFZlmgQOz+4F9fgyzXdb1STYJjLCyrf+HWTUEmMoGf7MV1CIE33MeMzN/MNBrgrqBAVFoU21GrClhp4TwNSCC1ogu3DUNu1jFMbxWO2SBKvWJUW4zquNRqOr9UCbwaM8qCQ7tBqyigGSaEOcRuscEHr8QYiCViDWy/gCzqwSR/FBgnbxyGTS/gnqPVHS4R6F/1y63Tt23tP7+ix+2uIKEYJj6jX/2RHgeRBtt47nmKoj7OJOBTcNdXthshvXJhJTnPpdr7rO1Crw+Y39M4Fpu1tH1hdadW3+9t95LxJojpa+m8R5JAc3hx2F5jPUOuloDK25L1ntc+xnaot8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   2fa523fd0829356881811ce9553b707102f55bd3
commit: 730fb8720d1ba209cd74692ece9766101e1fdb56 [129/139] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251108/202511081101.9sXNBrzT-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251108/202511081101.9sXNBrzT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511081101.9sXNBrzT-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/shmem.c: In function '__shmem_file_setup':
>> mm/shmem.c:5811:23: warning: unused variable 'flags' [-Wunused-variable]
    5811 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
         |                       ^~~~~


vim +/flags +5811 mm/shmem.c

  5806	
  5807	static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
  5808					       loff_t size, unsigned long vm_flags,
  5809					       unsigned int i_flags)
  5810	{
> 5811		unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
  5812		struct inode *inode;
  5813		struct file *res;
  5814	
  5815		if (IS_ERR(mnt))
  5816			return ERR_CAST(mnt);
  5817	
  5818		if (size < 0 || size > MAX_LFS_FILESIZE)
  5819			return ERR_PTR(-EINVAL);
  5820	
  5821		if (is_idmapped_mnt(mnt))
  5822			return ERR_PTR(-EINVAL);
  5823	
  5824		if (shmem_acct_size(flags, size))
  5825			return ERR_PTR(-ENOMEM);
  5826	
  5827		inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
  5828					S_IFREG | S_IRWXUGO, 0, vm_flags);
  5829		if (IS_ERR(inode)) {
  5830			shmem_unacct_size(flags, size);
  5831			return ERR_CAST(inode);
  5832		}
  5833		inode->i_flags |= i_flags;
  5834		inode->i_size = size;
  5835		clear_nlink(inode);	/* It is unlinked */
  5836		res = ERR_PTR(ramfs_nommu_expand_for_mapping(inode, size));
  5837		if (!IS_ERR(res))
  5838			res = alloc_file_pseudo(inode, mnt, name, O_RDWR,
  5839					&shmem_file_operations);
  5840		if (IS_ERR(res))
  5841			iput(inode);
  5842		return res;
  5843	}
  5844	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

