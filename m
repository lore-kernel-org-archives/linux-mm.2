Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B71CCCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF158E0016; Tue, 30 Sep 2025 06:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F5F8E0002; Tue, 30 Sep 2025 06:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E388E0016; Tue, 30 Sep 2025 06:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0A88E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:05:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D325C86CF1
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:05:53 +0000 (UTC)
X-FDA: 83945485386.25.576953F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id A85291C000F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:05:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gOGVF1ml;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759226751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyWM7M3FmhurEwSCgkwQ76vToMTu4VsK1uo0zZ5Zw9k=;
	b=y7IG81K5EmAk2yFuue97gIfqb8QG9qqloBMtHtV5c907vs5qJhwEOt23Z/HuftKC1jxZ9A
	j3z7lJAnfTeDaTYJX8z8KgHMkEsp63Pj/MP7Au+iVzdS2Qu9HqvS9EC40LtcPRC5EalTzp
	4eUVYo0kIkFg+Zvlo4GcCDAReFRnrdU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gOGVF1ml;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759226751; a=rsa-sha256;
	cv=none;
	b=A68HHRcNR3hJ9vxbBnkj7Ad0Uycj85pv2kOeLxpNnUFc+oL8n+tRUHecAOfsk3E/XpufNY
	fikN9XsyzWPalGBxRr9wfoSgz/ZHEloldDQc56zLoYQQ0bYeJ1rK3imGD+d152E7+24/vc
	nzB+6suPKy6C/CB4yxPRyjbXfAPewNM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759226750; x=1790762750;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=npvtgCQVERmCarOfKSvie70oeT0wMLmYdU95Di6tZxk=;
  b=gOGVF1mlA0+lFGOqGZxGDLEala+0OHUHvQ5YBJg9a0EZi/Rgm8FChSPz
   bdLuOhr4a6qM0APrAwtkg6vgw7OybUh/p+lIMYWXp+JrRW5ccl5A3S0Q9
   J1KOtyQTPFylcP/wlCrbUUhpZI6u5FTNPY7vG7ZRMqslUIOamdqPVzHLU
   FyGai2uuS7OkxB1vgoeO+3/HszP3OhARUZI6DPuB6Qog1jNzC59xX62E6
   30+6gf1VEOxQjvibzEs3kfM4KkwHPzXZ/Ozr4oxHqZ4zCH946MB1e2g+u
   LZK4oEwVtsuqsIv6VRt/RgTYv3FFjptXmCeNtCk4vNEfBs9Y2SUVdz9v/
   w==;
X-CSE-ConnectionGUID: /fJG8jiZRtiCFbcji4RWOg==
X-CSE-MsgGUID: FVMdu1gJTCmvnuGkGg7x6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="72097648"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="72097648"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 03:05:49 -0700
X-CSE-ConnectionGUID: PV+0NBfaTwSqEdenvWAgLQ==
X-CSE-MsgGUID: K51ZkYz/TQmtpVOD/uXFwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="178889093"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 30 Sep 2025 03:05:43 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v3XEq-00019L-1H;
	Tue, 30 Sep 2025 10:05:40 +0000
Date: Tue, 30 Sep 2025 18:05:36 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Lo=EFc?= Molinari <loic.molinari@collabora.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
	=?iso-8859-1?Q?Ma=EDra?= Canal <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?utf-8?Q?Miko=C5=82aj?= Wasiak <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, kernel@collabora.com
Subject: Re: [PATCH 2/8] drm/gem: Introduce drm_gem_get_unmapped_area() fop
Message-ID: <202509301702.DL6CeU62-lkp@intel.com>
References: <20250929200316.18417-3-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250929200316.18417-3-loic.molinari@collabora.com>
X-Rspamd-Queue-Id: A85291C000F
X-Rspamd-Server: rspam05
X-Stat-Signature: tmusp5aqcchne5ji8pae8zpboqcyyth4
X-Rspam-User: 
X-HE-Tag: 1759226750-443769
X-HE-Meta: U2FsdGVkX1+yZkK7zvJe2iH0L96if2i3JGUpc7jBvKMFimzZOCSBbxYZwdMywFZdgsbUyP+cwcmXSjIAEaGQvFNSNySK62EI1PW3EzD+6E6K3a65Z3SDcwmA7qRXLzA6CBsPX805PWQj0a82q2QOQRehqhVQM0v0/6tSd9MjBjyuL2hfnXwAl7F4cQBXXi0lJYp76yUgH8tGYGOyybLLi9cx6iu8ypCGW754l4A8OsT6y0NJzlTz5bJMh03aolpqDQZ6PZxO5LKSHOekUPkltM8zhrnFWN2ZBJjrvedWRSYO5YBvZ8YJ/1G75doGqkrxSAaNfsf/TtI4GTbbVYVRkNaxpy4IQeXQH2qwwN27R4Tw+rLpqXBR0PibeAYz9ER0MasWYmDArUN8mdWIsuHs3MgYn+FZhgCmzFsSaXTzFf8izSrtHhrDY5ySZZQfNbs+Ip+tqxyoCBTphddbNoLs3bYDdgVbwsvnp3qRFLCruL8Tw+/27qLo4R9oBxUMqy1sST4/B/x2PAh+ecIbSHDj+w+ykDmpdqXpFlUOZqUiLmsm8nL3KEnc5u/0aYpY6dswU6B8w9JIVKUmTqqWJi9ksUUiPDvQnUQ9M0AA14ornUBs4WBt3y3aJbvVf6KRggSJz9gVnjSua2Ct3kuIF81FdOBn935/JpPVWAKLEikHmiNzAN/Vudh9qeLkeZJRy4+K7ugpzjZr/OFWc8tD/t4AaVACqFwmbqpqoBWArS6cEosggbti0qWqlJySrsGkx1cQG2s3R0Y4XIgYBFYI8rGIB4PQBbv/1i0bWSHVZR8NiYby39rMnbUWQsBOQKuFy6/wI9nbr5CZbKZNcRwD9vRKQAFHriGkNW1Hd3rb9CfLQx5ytqn6Bqc/U12qCM9MIkBa1d5tB97FDXsacIcWHP/Uc/AVT3Vwe3Lrt8QS9n5nroSEKbTTLBnqXGBr+nos5HPs9EStiQjbCYyV23Aqh/J
 qKkvuXX9
 mcpfr3lGOdoiu53b9LCQb1ikjapqW4DYwKCYi5+qM0KTEtMkhcjfffYNpnnW0zLOfTVjrPCMbAs92R/O+dG1IsDaRflLs0Xn9lH0ytsbAgMwOKsSv3TgSdCNyq00WpPDPTSZxojt870bugMBulnlM3vKdIM+roBR+KliLJG7aPTkREGfBfrwq8RlFqUHq9nmi1fHI4p6ClK5NksVGBeyS7UxV4m/akLjNGwwCTxfUaocX4KL5u6wXxKv4oifK4S0RuQQHSrbBpzjvdMikc5/oeEsJkLCw7AkkRfRVNqmBMcK3gZoCzJ+onWE9Casud/5fXr6YTNSPMGrKa186Sq7xOH1QMGyoeO98P+ZEbNGd68EvpOLSb3v7kFCP2q5h86XMxgA6HBcypOT62JmFWP7jnwfPoFRlGUaKYXQ7/iBJOwgAHkdE2xMZlMs8MCSz2MHTatpoqbbJ5xhXHcRU/9GKC7ODnoob8oNcUQZ3BC34yRTC5avu8RGuQ4numoXrixJGJA0j2TRidw/BIc0f1QlHyY30fzXPine/hOHq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loïc,

kernel test robot noticed the following build errors:

[auto build test ERROR on drm-misc/drm-misc-next]
[also build test ERROR on linus/master v6.17 next-20250929]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lo-c-Molinari/drm-shmem-helper-Add-huge-page-fault-handler/20250930-040600
base:   git://anongit.freedesktop.org/drm/drm-misc drm-misc-next
patch link:    https://lore.kernel.org/r/20250929200316.18417-3-loic.molinari%40collabora.com
patch subject: [PATCH 2/8] drm/gem: Introduce drm_gem_get_unmapped_area() fop
config: arm-randconfig-002-20250930 (https://download.01.org/0day-ci/archive/20250930/202509301702.DL6CeU62-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250930/202509301702.DL6CeU62-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509301702.DL6CeU62-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/gpu/drm/drm_gem.c: In function 'drm_gem_get_unmapped_area':
>> drivers/gpu/drm/drm_gem.c:1280:9: error: implicit declaration of function 'mm_get_unmapped_area'; did you mean 'shmem_get_unmapped_area'? [-Werror=implicit-function-declaration]
     return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0, flags);
            ^~~~~~~~~~~~~~~~~~~~
            shmem_get_unmapped_area
   cc1: some warnings being treated as errors


vim +1280 drivers/gpu/drm/drm_gem.c

  1238	
  1239	/**
  1240	 * drm_gem_get_unmapped_area - get memory mapping region routine for GEM objects
  1241	 * @filp: DRM file pointer
  1242	 * @uaddr: User address hint
  1243	 * @len: Mapping length
  1244	 * @pgoff: Offset (in pages)
  1245	 * @flags: Mapping flags
  1246	 *
  1247	 * If a driver supports GEM object mapping, before ending up in drm_gem_mmap(),
  1248	 * mmap calls on the DRM file descriptor will first try to find a free linear
  1249	 * address space large enough for a mapping. Since GEM objects are backed by
  1250	 * shmem buffers, this should preferably be handled by the shmem virtual memory
  1251	 * filesystem which can appropriately align addresses to huge page sizes when
  1252	 * needed.
  1253	 *
  1254	 * Look up the GEM object based on the offset passed in (vma->vm_pgoff will
  1255	 * contain the fake offset we created) and call shmem_get_unmapped_area() with
  1256	 * the right file pointer.
  1257	 *
  1258	 * If a GEM object is not available at the given offset or if the caller is not
  1259	 * granted access to it, fall back to mm_get_unmapped_area().
  1260	 */
  1261	unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
  1262						unsigned long len, unsigned long pgoff,
  1263						unsigned long flags)
  1264	{
  1265	#ifdef CONFIG_TRANSPARENT_HUGEPAGE
  1266		struct drm_gem_object *obj;
  1267		unsigned long ret;
  1268	
  1269		obj = drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SHIFT);
  1270		if (IS_ERR(obj))
  1271			return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
  1272						    flags);
  1273	
  1274		ret = shmem_get_unmapped_area(obj->filp, uaddr, len, 0, flags);
  1275	
  1276		drm_gem_object_put(obj);
  1277	
  1278		return ret;
  1279	#else
> 1280		return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0, flags);
  1281	#endif
  1282	}
  1283	EXPORT_SYMBOL(drm_gem_get_unmapped_area);
  1284	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

