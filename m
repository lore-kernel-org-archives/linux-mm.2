Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB5DC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 07:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1066B00FC; Thu, 22 Jan 2026 02:11:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8166B00FD; Thu, 22 Jan 2026 02:11:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1736B00FE; Thu, 22 Jan 2026 02:11:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CADFA6B00FC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:11:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B3BE140188
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:11:48 +0000 (UTC)
X-FDA: 84358729896.09.D71D81E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 17F541C0002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:11:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="iaTfF/4u";
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769065906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ylxXPc/SFOkikrIP9z6qhWnr6QzVCalovkwRLtmhi+o=;
	b=Tf0FA/M7BtWZK7nHO3awBY+XdcfmyNJESLF5+V2i5tFz3K2HjAiwjd+KysN8/Bs2fjBowx
	EJg8PsAjUsaz23bUZgTIUQXIJIFQJfH1LHr7qQUIXzFmBLxoSk+tZXLFa0B98xm2umf+H5
	1Y3D3wv+LrVlzuG0UH+4IX3prY9f8/E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="iaTfF/4u";
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769065906; a=rsa-sha256;
	cv=none;
	b=sxu8hwHQhEy/tDtbNKFQJH+Ep2bf1XkF0wOHPvUZ9RXXtak83g9Ous9Amis63DGng23jk8
	8S1Ns3d/z0l+9dN+xWIhRLs5IO172Av7oQhWuPDhFtz1f1o9J7sjDmlNvxfwcQ/ibTx6kS
	V8p3e1G1vXrbkqGTo2XAdVWj7gVQNQY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769065907; x=1800601907;
  h=date:from:to:cc:subject:message-id;
  bh=fsaQFvqLGFN/BZaRHIqo7prZQO2tS9+8vq9SSKHmGBM=;
  b=iaTfF/4uHweZnF1YwD+thxq43lUrubk5G1jXQsFOPYYsojxN7hbhLiez
   p17JYCIm+AbZukEbWZBW3O8+I00vQ4iq9Z4Vr956YNu8DU/GlLv7JfXGG
   mKwghih0B78MmfKOeRT9tdlW3fG+LyGOKFzY33CzWT11+u2qHoI5rc8F0
   YhS2vMugoM/gVOt6squUQOugliBlwSyBwv5tHHGgS6CVpUVBCdtOlfttW
   m2T0dhbg0YW0OhylSzxHmJfNILTynpdddwukRDzd/+Y9D3FSzfbJtB4US
   6pCmYfAnlbI4koWPERi3AU5PIOiMIvGeynNzIJIlOtuYECxPGtqePYBhr
   A==;
X-CSE-ConnectionGUID: dSF5H75rTf+H9QXp6Lw4aQ==
X-CSE-MsgGUID: vU/yjBnjQ32vxXevz06e5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70352315"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="70352315"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:11:44 -0800
X-CSE-ConnectionGUID: VbF4tTirQKWWFd9GN0wE8A==
X-CSE-MsgGUID: 3TMJCxzWRz2VTATtKXmhjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="206567982"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 21 Jan 2026 23:11:42 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vioqx-00000000SXj-3d8W;
	Thu, 22 Jan 2026 07:11:39 +0000
Date: Thu, 22 Jan 2026 15:11:09 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [akpm-mm:mm-new 419/429] mm/memfd_luo.c:446:40: sparse:
 sparse: dereference of noderef expression
Message-ID: <202601221552.0MhL50xv-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 17F541C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: cx5a8ycfgjs7nc9h9sa6abx3zfzt4c93
X-HE-Tag: 1769065905-301194
X-HE-Meta: U2FsdGVkX1/Jl5Hpl/UCxsFPynOu5FNcnfT6eDfF+wAjgGA3EYuuygWm9z78WcuYXAhOkc73Nr2pN4VB1gvKo7Wunz3RAfeY8CmKvgri5XTQcXwP3ekbkvS/U3RVRIeAKbWp0h/+QZFLtma48KzyKQpyTxA3LVxDoNPLO6BTg/ZFEONn81ErjhEfGnnfILLwXpc9/Y+0OW4mu8KKAhGyXYeBP0DWtfPByXjWBD34LHfOwXazvS3iACIpv/CTTAy5CPUPohHcfpb4fq7pgul/ev9Bn6cBKKUt4HEPYn3PqfaQF68DjAhQNWY3UExUjyuyFFmo7+7iIYmeu5TjNwIswZIqdQz8p6fae/6kUls+IjDbzXUXKMc/YS89qInXWYWmQ8+aZNv0x4sMAF0eXIaYw0GTzz0FGjX+PiDynYyT3zFi+g28XzCyS3UkA4UXXvQDCi1ZUjr4v/1GtM2lolc65miW5mVItY9gx10xg0oQ2aU2JJGsEx0GzReL/ODxEbQaXyRZR9/ostnnJPhkiVA+C7r3NFY9djATjTQpnezi25bBt2ETHGBW8bEfkTemPAl0sdlgK9yuVBY+P1ariKa7KyZDPzstAWt1PorDn7RFAMPIMr88se3f9O9N/YRQZj+tHtYWc8FEzjFl/WB3SASA4uNJ/Lfmy3OD/GmbmXrSJ/+o8wBw1E7O8cTkq5aY0zB0MyW0UMyNy6FuiNRi9H6oVUE0nDJA4FYcdteu5PVVCG2Zoy5Qq3TUJaiqRHhnkuJDqLnCVUf08kSC13WMj5fC+nUVG3SXA6rr1Y8jrAmZQ6opgSFxxMrcR019OU8ESNOk/HkIO5h9SsmwuPT2ToOGCei94Dn11lcinwfXVYI9AsiGpFnDxhURB0ZGeIb1hPgDQ7hwTDZItIhFzEfBWR6kzhUos1vSYH3Pj0TUf6Ii4eFiBYe4ZHgI9vVpaWzRaiKyUqNvqTDjIC9dhuV+evZ
 zRvBckR2
 f58F/ykJSTCrBxnYv6GRqm4h3n93uwjXT82ewCWcEKBMyPZN/lRuPm7kn5KHqoZkCnPNVn6rlbzgQOdx6risfMyrQcAhDb7vS2RTv+hzjBpQuXK0Hk+vFdJ/WKZRid2bXWzHbCLZNDlZ9tKmAaL/F/L1vKQ+53sac7Lx0OZKhZA/K0dPLYG3vDFUUGKhoVSz6fTr02Kn98+9SnkrYcfSzbWe9edAUh9x5vq9F3XAQFy5qdDSLtOLsIFlR8u2V9adx8YvKx/Ru8OorWwCw2SmCenYkCn3dzowMNZIq2tB3m0XXNriM9TkJ7nN0+yoJLm2F4yA9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   dc4fe40a11269aead253fa0beb098b00417b8694
commit: 591558d3350ffa9764039f27ac357be01387ace0 [419/429] mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
config: x86_64-randconfig-r113-20260122 (https://download.01.org/0day-ci/archive/20260122/202601221552.0MhL50xv-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221552.0MhL50xv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601221552.0MhL50xv-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/memfd_luo.c:446:40: sparse: sparse: dereference of noderef expression
   mm/memfd_luo.c: note: in included file (through include/linux/memcontrol.h, include/linux/swap.h, include/linux/shmem_fs.h):
   include/linux/mm.h:1047:16: sparse: sparse: dereference of noderef expression

vim +446 mm/memfd_luo.c

   434	
   435	static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
   436	{
   437		struct memfd_luo_folio_ser *folios_ser;
   438		struct memfd_luo_ser *ser;
   439		struct file *file;
   440		int err;
   441	
   442		ser = phys_to_virt(args->serialized_data);
   443		if (!ser)
   444			return -EINVAL;
   445	
 > 446		file = shmem_file_setup("", 0, mk_vma_flags(VMA_NORESERVE_BIT));
   447	
   448		if (IS_ERR(file)) {
   449			pr_err("failed to setup file: %pe\n", file);
   450			return PTR_ERR(file);
   451		}
   452	
   453		vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
   454		file->f_inode->i_size = ser->size;
   455	
   456		if (ser->nr_folios) {
   457			folios_ser = kho_restore_vmalloc(&ser->folios);
   458			if (!folios_ser) {
   459				err = -EINVAL;
   460				goto put_file;
   461			}
   462	
   463			err = memfd_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
   464			vfree(folios_ser);
   465			if (err)
   466				goto put_file;
   467		}
   468	
   469		args->file = file;
   470		kho_restore_free(ser);
   471	
   472		return 0;
   473	
   474	put_file:
   475		fput(file);
   476	
   477		return err;
   478	}
   479	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

